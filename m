Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5522161B6E
	for <patches@lists.linux.dev>; Mon, 27 May 2024 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716816881; cv=none; b=c1balUgWwGTU09Xq2fhDJ2lxRBA6ewiNXsqALFh6lEB5XjAdjVEpCQ0vDF/d8xw+NZNlA+yFLx14uqdkUUujZTvthiVS8BtZt7Lp1dcdhCKGw2TiPsXWvxTgbRcGKANPRUY8/90PTJIaDjWgSDRBJkhYwZVLSadaqgoxDPfGHeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716816881; c=relaxed/simple;
	bh=pVZXZ4SnOn6a3GICI9IGpGA0qsKuFWtHWCsMI500MGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kA/+FOllX1HpZTv45MeLCSZgHOOH7sFG87nVtS/ey57Js/ztekkV4g2oJk5ME+YpWIdijd86yPwiT1JA8FZvEfODuVbzgVodj1cuFRafFko8jPx6m18IiNzWLfAyDutwRFgeiYt1Yfamhr1fT5XpY9dEDHFOq++EmvClM9rACjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8/J2B2v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8/J2B2v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716816878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDEFX4Rwrocpmk1yMTSH1aYuyP5K1qPmVR60vlP0ECY=;
	b=D8/J2B2vMWq7GilXyEYTjzwR4QhDRlaNrZXtOsZlzmsQWVZanNC7Tpwoh4uxFbAA5XdXZP
	5iuNHkkZW5HfCy9T082Z01u+MxezBd1tziZ7Vd/LCSD2zvfXS+QR2GXAva8DC146nbFuuC
	A/d5EMdt9SJSIcjvP9R5GmZDYHB0WjQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-lY7GiVknPGeLobFsEZ9kiA-1; Mon, 27 May 2024 09:34:37 -0400
X-MC-Unique: lY7GiVknPGeLobFsEZ9kiA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2e95a1fae88so25683121fa.0
        for <patches@lists.linux.dev>; Mon, 27 May 2024 06:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716816875; x=1717421675;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lDEFX4Rwrocpmk1yMTSH1aYuyP5K1qPmVR60vlP0ECY=;
        b=X1tQhg5E9K2UJiF79TmT7JWp7VVn+cAIb4wxBq3H2g9Id1IMnUUp2E/MozIb5E+vv0
         ufOsiFN9JOROoRQjhpRuYhWP1yIZFeDtm0sRsZ5yNUTtCNYnSOhWzXUWDAKyKOHVBHoU
         WNecDbXKhIxHn3vdsxuOd00T/++sdH+3ygdOFpu/mh0m9egeqmGV7jXIiAMDa/D94B9b
         2cxjjnlimMioXdBL/aW37CLbIjOI1/0uR7eNWVzoEbj4xwK+YbdidHLqSaGzewfPfK9P
         KOFZ+ID4Wybtt9G7NaqJufD+OiaOG11/wdy/C0nXfESDh4RZ6S162xAh5QInKkYNMxWy
         UsCA==
X-Forwarded-Encrypted: i=1; AJvYcCX86lS+Jm+HDCmA4yB0t3h7KL1lHSw3JBCu4m03Omr4kzI4EPu8nxPe/tyReXnY04lK5HcRHip87XCS/iauxoJNn7QJgJ3AjQ==
X-Gm-Message-State: AOJu0Yz+qravKck1FHH7Mg60Kw1UEKIyyj4EXzhT+nJmtIpPPqX8VUzn
	MG1sQ/m+GSG5G3weWQkKnXdlnBpos2V1XiWG7FTXp0yTYtsjqNBnuvI/cIwKEeuU1ul2zKK56hZ
	K2sv3WBos9VXY+yQ/JODjoUDcxFxyO6ujdvWprNxZU1hKH+WTuoyTL4I=
X-Received: by 2002:a2e:968c:0:b0:2e0:4cbb:858a with SMTP id 38308e7fff4ca-2e95b0c093bmr51745371fa.27.1716816875616;
        Mon, 27 May 2024 06:34:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhrNV6UN10MPlEkyX5Wt+TB73NepJi/OagUtHe4JM4L/f5UfWJW/uYUEbLaQ03g8LNnZTS7A==
X-Received: by 2002:a2e:968c:0:b0:2e0:4cbb:858a with SMTP id 38308e7fff4ca-2e95b0c093bmr51745181fa.27.1716816875047;
        Mon, 27 May 2024 06:34:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:4600:d3a7:6c26:54cf:e01e? (p200300d82f284600d3a76c2654cfe01e.dip0.t-ipconnect.de. [2003:d8:2f28:4600:d3a7:6c26:54cf:e01e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3557dcf03acsm9229340f8f.103.2024.05.27.06.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 May 2024 06:34:34 -0700 (PDT)
Message-ID: <2c943e16-e8f1-4311-b707-1be94d883948@redhat.com>
Date: Mon, 27 May 2024 15:34:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, tglx@linutronix.de
Cc: linux-mm@kvack.org
References: <20240521111958.2384173-1-Jason@zx2c4.com>
 <20240521111958.2384173-2-Jason@zx2c4.com>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <20240521111958.2384173-2-Jason@zx2c4.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Am 21.05.24 um 13:18 schrieb Jason A. Donenfeld:
> The vDSO getrandom() implementation works with a buffer allocated with a
> new system call that has certain requirements:
> 
> - It shouldn't be written to core dumps.
>    * Easy: VM_DONTDUMP.
> - It should be zeroed on fork.
>    * Easy: VM_WIPEONFORK.
> 
> - It shouldn't be written to swap.
>    * Uh-oh: mlock is rlimited.
>    * Uh-oh: mlock isn't inherited by forks.
> 
> - It shouldn't reserve actual memory, but it also shouldn't crash when
>    page faulting in memory if none is available
>    * Uh-oh: MAP_NORESERVE respects vm.overcommit_memory=2.
>    * Uh-oh: VM_NORESERVE means segfaults.
> 
> It turns out that the vDSO getrandom() function has three really nice
> characteristics that we can exploit to solve this problem:
> 
> 1) Due to being wiped during fork(), the vDSO code is already robust to
>     having the contents of the pages it reads zeroed out midway through
>     the function's execution.
> 
> 2) In the absolute worst case of whatever contingency we're coding for,
>     we have the option to fallback to the getrandom() syscall, and
>     everything is fine.
> 
> 3) The buffers the function uses are only ever useful for a maximum of
>     60 seconds -- a sort of cache, rather than a long term allocation.
> 
> These characteristics mean that we can introduce VM_DROPPABLE, which
> has the following semantics:
> 
> a) It never is written out to swap.
> b) Under memory pressure, mm can just drop the pages (so that they're
>     zero when read back again).
> c) If there's not enough memory to service a page fault, it's not fatal.
> d) It is inherited by fork.
> e) It doesn't count against the mlock budget, since nothing is locked.
> 
> This is fairly simple to implement, with the one snag that we have to
> use 64-bit VM_* flags, but this shouldn't be a problem, since the only
> consumers will probably be 64-bit anyway.
> 
> This way, allocations used by vDSO getrandom() can use:
> 
>      VM_DROPPABLE | VM_DONTDUMP | VM_WIPEONFORK | VM_NORESERVE
> 
> And there will be no problem with OOMing, crashing on overcommitment,
> using memory when not in use, not wiping on fork(), coredumps, or
> writing out to swap.
> 
> Cc: linux-mm@kvack.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>   fs/proc/task_mmu.c             | 3 +++
>   include/linux/mm.h             | 8 ++++++++
>   include/trace/events/mmflags.h | 7 +++++++
>   mm/Kconfig                     | 3 +++
>   mm/memory.c                    | 4 ++++
>   mm/mempolicy.c                 | 3 +++
>   mm/mprotect.c                  | 2 +-
>   mm/rmap.c                      | 5 +++--
>   8 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e5a5f015ff03..b5a59e57bde1 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -706,6 +706,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>   #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
>   #ifdef CONFIG_X86_USER_SHADOW_STACK
>   		[ilog2(VM_SHADOW_STACK)] = "ss",
> +#endif
> +#ifdef CONFIG_NEED_VM_DROPPABLE
> +		[ilog2(VM_DROPPABLE)]	= "dp",
>   #endif
>   	};
>   	size_t i;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9849dfda44d4..5978cb4cc21c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -321,12 +321,14 @@ extern unsigned int kobjsize(const void *objp);
>   #define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
>   #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
>   #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
> +#define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
>   #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
>   #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
>   #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
>   #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
>   #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
>   #define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
> +#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
>   #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
>   
>   #ifdef CONFIG_ARCH_HAS_PKEYS
> @@ -357,6 +359,12 @@ extern unsigned int kobjsize(const void *objp);
>   # define VM_SHADOW_STACK	VM_NONE
>   #endif
>   
> +#ifdef CONFIG_NEED_VM_DROPPABLE
> +# define VM_DROPPABLE		VM_HIGH_ARCH_6
> +#else
> +# define VM_DROPPABLE		VM_NONE
> +#endif
> +
>   #if defined(CONFIG_X86)
>   # define VM_PAT		VM_ARCH_1	/* PAT reserves whole VMA at once (x86) */
>   #elif defined(CONFIG_PPC)
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index e46d6e82765e..fab7848df50a 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -165,6 +165,12 @@ IF_HAVE_PG_ARCH_X(arch_3)
>   # define IF_HAVE_UFFD_MINOR(flag, name)
>   #endif
>   
> +#ifdef CONFIG_NEED_VM_DROPPABLE
> +# define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
> +#else
> +# define IF_HAVE_VM_DROPPABLE(flag, name)
> +#endif
> +
>   #define __def_vmaflag_names						\
>   	{VM_READ,			"read"		},		\
>   	{VM_WRITE,			"write"		},		\
> @@ -197,6 +203,7 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
>   	{VM_MIXEDMAP,			"mixedmap"	},		\
>   	{VM_HUGEPAGE,			"hugepage"	},		\
>   	{VM_NOHUGEPAGE,			"nohugepage"	},		\
> +IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
>   	{VM_MERGEABLE,			"mergeable"	}		\
>   
>   #define show_vma_flags(flags)						\
> diff --git a/mm/Kconfig b/mm/Kconfig
> index b4cb45255a54..6cd65ea4b3ad 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1056,6 +1056,9 @@ config ARCH_USES_HIGH_VMA_FLAGS
>   	bool
>   config ARCH_HAS_PKEYS
>   	bool
> +config NEED_VM_DROPPABLE
> +	select ARCH_USES_HIGH_VMA_FLAGS
> +	bool
>   
>   config ARCH_USES_PG_ARCH_X
>   	bool
> diff --git a/mm/memory.c b/mm/memory.c
> index b5453b86ec4b..57b03fc73159 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
>   
>   	lru_gen_exit_fault();
>   
> +	/* If the mapping is droppable, then errors due to OOM aren't fatal. */
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		ret &= ~VM_FAULT_OOM;
> +
>   	if (flags & FAULT_FLAG_USER) {
>   		mem_cgroup_exit_user_fault();
>   		/*
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index aec756ae5637..a66289f1d931 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2300,6 +2300,9 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
>   	pgoff_t ilx;
>   	struct page *page;
>   
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		gfp |= __GFP_NOWARN | __GFP_NORETRY;
> +
>   	pol = get_vma_policy(vma, addr, order, &ilx);
>   	page = alloc_pages_mpol_noprof(gfp | __GFP_COMP, order,
>   				       pol, ilx, numa_node_id());
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 94878c39ee32..88ff3ecc08a1 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -622,7 +622,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>   				may_expand_vm(mm, oldflags, nrpages))
>   			return -ENOMEM;
>   		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|VM_HUGETLB|
> -						VM_SHARED|VM_NORESERVE))) {
> +				  VM_SHARED|VM_NORESERVE|VM_DROPPABLE))) {
>   			charged = nrpages;
>   			if (security_vm_enough_memory_mm(mm, charged))
>   				return -ENOMEM;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e8fc5ecb59b2..f23b9f796aae 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1397,7 +1397,8 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
>   	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
>   	VM_BUG_ON_VMA(address < vma->vm_start ||
>   			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
> -	__folio_set_swapbacked(folio);
> +	if (!(vma->vm_flags & VM_DROPPABLE))
> +		__folio_set_swapbacked(folio);
>   	__folio_set_anon(folio, vma, address, true);
>   
>   	if (likely(!folio_test_large(folio))) {
> @@ -1841,7 +1842,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   				 * plus the rmap(s) (dropped by discard:).
>   				 */
>   				if (ref_count == 1 + map_count &&
> -				    !folio_test_dirty(folio)) {
> +				    (!folio_test_dirty(folio) || (vma->vm_flags & VM_DROPPABLE))) {
>   					dec_mm_counter(mm, MM_ANONPAGES);
>   					goto discard;
>   				}

If there is any unexpected temporary folio reference (ref_count != 1 + 
map_count), you'll end up calling folio_set_swapbacked() and the next swapout 
round will write that folio to swap.

-- 
Thanks,

David / dhildenb

