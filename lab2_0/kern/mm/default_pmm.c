#include <pmm.h>
#include <list.h>
#include <string.h>
#include <default_pmm.h>

/*  In the First Fit algorithm, the allocator keeps a list of free blocks
 * (known as the free list). Once receiving a allocation request for memory,
 * it scans along the list for the first block that is large enough to satisfy
 * the request. If the chosen block is significantly larger than requested, it
 * is usually splitted, and the remainder will be added into the list as
 * another free block.
 *  Please refer to Page 196~198, Section 8.2 of Yan Wei Min's Chinese book
 * "Data Structure -- C programming language".
*/
// LAB2 EXERCISE 1: 2011757
// you should rewrite functions: `default_init`, `default_init_memmap`,
// `default_alloc_pages`, `default_free_pages`.
/*
 * Details of FFMA
 * (1) Preparation:
 *  In order to implement the First-Fit Memory Allocation (FFMA), we should
 * manage the free memory blocks using a list. The struct `free_area_t` is used
 * for the management of free memory blocks.
 *  First, you should get familiar with the struct `list` in list.h. Struct
 * `list` is a simple doubly linked list implementation. You should know how to
 * USE `list_init`, `list_add`(`list_add_after`), `list_add_before`, `list_del`,
 * `list_next`, `list_prev`.
 *  There's a tricky method that is to transform a general `list` struct to a
 * special struct (such as struct `page`), using the following MACROs: `le2page`
 * (in memlayout.h), (and in future labs: `le2vma` (in vmm.h), `le2proc` (in
 * proc.h), etc).
 * (2) `default_init`:
 *  You can reuse the demo `default_init` function to initialize the `free_list`
 * and set `nr_free` to 0. `free_list` is used to record the free memory blocks.
 * `nr_free` is the total number of the free memory blocks.
 * (3) `default_init_memmap`:
 *  CALL GRAPH: `kern_init` --> `pmm_init` --> `page_init` --> `init_memmap` -->
 * `pmm_manager` --> `init_memmap`.
 *  This function is used to initialize a free block (with parameter `addr_base`,
 * `page_number`). In order to initialize a free block, firstly, you should
 * initialize each page (defined in memlayout.h) in this free block. This
 * procedure includes:
 *  - Setting the bit `PG_property` of `p->flags`, which means this page is
 * valid. P.S. In function `pmm_init` (in pmm.c), the bit `PG_reserved` of
 * `p->flags` is already set.
 *  - If this page is free and is not the first page of a free block,
 * `p->property` should be set to 0.
 *  - If this page is free and is the first page of a free block, `p->property`
 * should be set to be the total number of pages in the block.
 *  - `p->ref` should be 0, because now `p` is free and has no reference.
 *  After that, We can use `p->page_link` to link this page into `free_list`.
 * (e.g.: `list_add_before(&free_list, &(p->page_link));` )
 *  Finally, we should update the sum of the free memory blocks: `nr_free += n`.
 * (4) `default_alloc_pages`:
 *  Search for the first free block (block size >= n) in the free list and reszie
 * the block found, returning the address of this block as the address required by
 * `malloc`.
 *  (4.1)
 *      So you should search the free list like this:
 *          list_entry_t le = &free_list;
 *          while((le=list_next(le)) != &free_list) {
 *          ...
 *      (4.1.1)
 *          In the while loop, get the struct `page` and check if `p->property`
 *      (recording the num of free pages in this block) >= n.
 *              struct Page *p = le2page(le, page_link);
 *              if(p->property >= n){ ...
 *      (4.1.2)
 *          If we find this `p`, it means we've found a free block with its size
 *      >= n, whose first `n` pages can be malloced. Some flag bits of this page
 *      should be set as the following: `PG_reserved = 1`, `PG_property = 0`.
 *      Then, unlink the pages from `free_list`.
 *          (4.1.2.1)
 *              If `p->property > n`, we should re-calculate number of the rest
 *          pages of this free block. (e.g.: `le2page(le,page_link))->property
 *          = p->property - n;`)
 *          (4.1.3)
 *              Re-caluclate `nr_free` (number of the the rest of all free block).
 *          (4.1.4)
 *              return `p`.
 *      (4.2)
 *          If we can not find a free block with its size >=n, then return NULL.
 * (5) `default_free_pages`:
 *  re-link the pages into the free list, and may merge small free blocks into
 * the big ones.
 *  (5.1)
 *      According to the base address of the withdrawed blocks, search the free
 *  list for its correct position (with address from low to high), and insert
 *  the pages. (May use `list_next`, `le2page`, `list_add_before`)
 *  (5.2)
 *      Reset the fields of the pages, such as `p->ref` and `p->flags` (PageProperty)
 *  (5.3)
 *      Try to merge blocks at lower or higher addresses. Notice: This should
 *  change some pages' `p->property` correctly.
 */
free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲页块链表
static void
default_init(void) {
    list_init(&free_list);
    // 空闲页块一开始是0个
    nr_free = 0;
}


static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    
    //在查找可用内存并分配struct Page数组时，就已经将全部Page设置为 reserved
    for (; p != base + n; p ++) {
        // 判断这个页是不是被内核保留的
        assert(PageReserved(p));
        
        //将Page标记为可用的：ref设为0,清除reserved，设置PG_reserved，并把property设置为0（不是空闲块的第一个物理页）
        p->flags = p->property = 0;
        set_page_ref(p, 0);

        SetPageProperty(base);
    }
    //空闲页块第一个物理页要设置数量，在此处，property设置为n
    base->property = n;
    //SetPageProperty(base);
    
    //更新空闲块的总和
    nr_free += n;
    
    // 初始化玩每个空闲页后，将其要插入到链表每次都插入到节点前面，因为是按地址排序
    //即p->page_link将这个页面链接到free_list
    list_add_before(&free_list, &(base->page_link));
}


// 分配n个页块
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    
    //如果请求的内存大小大于空闲块的大小，返回NULL
    if (n > nr_free) {
        return NULL;
    }
    
    struct Page *page = NULL;
    
    //遍历空闲列表
    list_entry_t *le = &free_list;
    // TODO: optimize (next-fit)
    
    // 查找 n 个或以上空闲页块 ，若找到则判断是否大过 n，则将其拆分 并将拆分后的剩下的空闲页块加回到链表中
    while ((le = list_next(le)) != &free_list) {
        // 此处 le2page 就是将 le 的地址 - page_link 在 Page 的偏移 从而找到 Page 的地址
        // 获取page并检查p->property（记录这个块中空闲物理页的数量）是否 >= n
        struct Page *p = le2page(le, page_link);
        
        //如果找到满足大小的空闲块，则跳出循环
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    
    //找到满足大小（>=n)的空闲块后，被分配的物理页flags应该被设置为PG_reserved =1，PG_property =0,然后将这些页面从free_list中移除
    if (page != NULL) {
  
        list_del(&(page->page_link));
        
        //如果p->property >n，应该重新计算这个空闲块剩下的空闲物理页的数量
        if (page->property > n) {
        
           //获得分裂出来的新的小空闲块的第一个页的描述信息
            struct Page *p = page + n;
            
            //更新新的空闲块的大小信息
            p->property = page->property - n;
            //property被值为1,表明是空闲的
            SetPageProperty(p);
            
            //将新空闲块插入空闲块列表后
            list_add_after(&(page->page_link), &(p->page_link));
        }
        
        // 在空闲页链表中删除掉原来的空闲页
        list_del(&(page->page_link));
        
        //重新计算nr_free（更新所有空闲块的空闲部分的数量）
        nr_free -= n;
        //将分配出去的内存页标记为非空闲
        ClearPageProperty(page);
    }
    return page;
}


// 释放掉 n 个 页块
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    
    for (; p != base + n; p ++) {
        //进行检查
        assert(!PageReserved(p) && !PageProperty(p));
        //重置物理页的属性
        p->flags = 0;
        //清空引用计数
        set_page_ref(p, 0);
    }
    
    //设置空闲块的的大小
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    
    // 合并到合适的页块中，并将合并好的合适的页块添加回空闲页块链表
    //迭代空闲链表中的每一个节点
    while (le != &free_list) {
        //获取节点对应的Page结构
        p = le2page(le, page_link);
        
        // TODO: optimize
        //尾部正好能和下一个连上，则合并
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        //头部正好和上一个连上，则合并
        else if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
        
        else if (base + base->property < p)
        {
            break;
        }
        le = list_next(le);
    }
 
    //将空闲块插入到链表中
    list_add_before(le, &(base->page_link));
 
    //更新空间物理页总量
    nr_free += n;
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}

static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nr_free == 3);

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(alloc_page() == NULL);

    free_page(p0);
    assert(!list_empty(&free_list));

    struct Page *p;
    assert((p = alloc_page()) == p0);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    free_list = free_list_store;
    nr_free = nr_free_store;

    free_page(p);
    free_page(p1);
    free_page(p2);
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
    assert(p0 != NULL);
    assert(!PageProperty(p0));

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
    assert(alloc_pages(4) == NULL);
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    assert((p1 = alloc_pages(3)) != NULL);
    assert(alloc_page() == NULL);
    assert(p0 + 2 == p1);

    p2 = p0 + 1;
    free_page(p0);
    free_pages(p1, 3);
    assert(PageProperty(p0) && p0->property == 1);
    assert(PageProperty(p1) && p1->property == 3);

    assert((p0 = alloc_page()) == p2 - 1);
    free_page(p0);
    assert((p0 = alloc_pages(2)) == p2 + 1);

    free_pages(p0, 2);
    free_page(p2);

    assert((p0 = alloc_pages(5)) != NULL);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
    assert(total == 0);
}

const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};
