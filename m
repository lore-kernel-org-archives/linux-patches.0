Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BBE179665
	for <patches@lists.linux.dev>; Tue, 28 May 2024 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928925; cv=none; b=dary3U58b9xJWimdphYWKNAAfrcVyVJSCOgVkAvwfNZcLzbyP45PKiXJcVrzC1cmW/ccAtp/uWpIVbDJOiuZUqPP8uaYewND0Mu5vJMPfNoPJkaOse2fArnVArMO/vjym44omXIQdBYtXCzGpRiijd1im5IzTww6DJEDkpPmsM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928925; c=relaxed/simple;
	bh=JGjMkvgaW/hGTfG4fKvV7NZfiLuik0PgrgzQn2JRERA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hN2g3uU3VbcYK78yeLxhvsyv3cJgWvZx2iMcYpOTJwwWzu5fdYtfyM6LFmOq5Nw3cenNtjSUNs/bUlvyNYIbnVKbaxnisXBhBf8MHc045qWc2pTQO9V5YnwkKdrnj3aac2DyB53oa/HG4MmnrVL6Q+ny+6F7i4k2MRTr0KMr6Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kselUf8T; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kselUf8T"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-804efaa51c2so441958241.3
        for <patches@lists.linux.dev>; Tue, 28 May 2024 13:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716928921; x=1717533721; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tS6xXCxVy/LqyXJiba1u7hR4DE1wkaxKXxNrHJ7f2Q=;
        b=kselUf8TXk7xOVGWSdwDIJdKqpkbNJ3/Xa6iJISLXRVbuH+PztEWrTHGH/VZ5oH7r1
         KbERQ0bLhOfVWrrbMr8axWh3MXLJ0kVRcEL0uhctxidLOmScDlLV1qX3pb3O473gPY1n
         VqNF4biEzDL+r51xQagakJm8TO/SVGe2hqGD1c7fZAoKTTS3Hnzy4qqakF1Dd8srjZOe
         x5loOjUDYC6V/SFfIxUB5A5bRlOklWudKwMDF5IJ39TD2BdM9OlkogGqlgkVH17TAcwq
         FR7gl/nMGNXw3DoeHfnpzL34dExf6uX92Efhb3/oViyId2I4E0gqfAdAeprQjLw6xgJy
         UDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716928921; x=1717533721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tS6xXCxVy/LqyXJiba1u7hR4DE1wkaxKXxNrHJ7f2Q=;
        b=UIEGBOZrUv80Ir8y/UiYWMVeA4T9YYWWipy034cn0jWU94cJjLCpXaRb7G3I1ahkjY
         UrX+S2iri2ie8ALS7DKjipLtT7D1MegAl4dA7p3rcx2WGINpdxfw9kHHP7JhgTkLktwq
         S1zlHiHG5W1q/S6iyGVcLU5fA2EH0eQ+xri74R4IS4kkzz9rlzxyy+0VLhI3UEIWbZ2F
         wSH3FZyboG/4okcKfq/K7wheisQdMuPnd53jIP/AUIJEZ4dM8yQsnl+KbuOxzkLFcfRD
         2kW4tcmg+2O5sGSbH5ZLEGkuWRLuGuf9VmYF1VB79vr8z10Y6nOp48gjg7scA4B3T4lZ
         4MOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwO5RtDu6o3+bSpmdOejVbb9ljY4TVxyNssSKeJcslNZlKO0vHCVBa4DO6GD71f+QwpvSOlF/Pm3hPzL6MU2wjOjCRxqqKSw==
X-Gm-Message-State: AOJu0Yw3TVwB1cdFKwyOPjm2CbOrlOLJUyJSrPYH4NhJyKNqvOh1Cz2s
	orSQmHgjZs+vbnsWWwbBNX71MumgWm8V6a+eh4Ob1Z0Byi/GHMrKY5aiv650oBehEkXG5bjoEel
	8ykPGpKE0Rm5ZwVhyBrKtTkulegae2ABBpnGb
X-Google-Smtp-Source: AGHT+IHBOt+yJuqVz4kWO3s7wm5GrNfxrhrfFQWpzXtoqn1G1zQvvTJwI9D7NLsJKgAT8jJo2F3DvxerxddRcFeD0R0=
X-Received: by 2002:a67:b34a:0:b0:486:6998:d773 with SMTP id
 ada2fe7eead31-48a38527321mr13094417137.9.1716928921389; Tue, 28 May 2024
 13:42:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-2-Jason@zx2c4.com>
From: Frank van der Linden <fvdl@google.com>
Date: Tue, 28 May 2024 13:41:50 -0700
Message-ID: <CAPTztWbDvrrCQH49q0GTk54--Hzh1V_A7KRw4-z38eGQupPKJg@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:24=E2=80=AFAM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> The vDSO getrandom() implementation works with a buffer allocated with a
> new system call that has certain requirements:
>
> - It shouldn't be written to core dumps.
>   * Easy: VM_DONTDUMP.
> - It should be zeroed on fork.
>   * Easy: VM_WIPEONFORK.
>
> - It shouldn't be written to swap.
>   * Uh-oh: mlock is rlimited.
>   * Uh-oh: mlock isn't inherited by forks.
>
> - It shouldn't reserve actual memory, but it also shouldn't crash when
>   page faulting in memory if none is available
>   * Uh-oh: MAP_NORESERVE respects vm.overcommit_memory=3D2.
>   * Uh-oh: VM_NORESERVE means segfaults.
>
> It turns out that the vDSO getrandom() function has three really nice
> characteristics that we can exploit to solve this problem:
>
> 1) Due to being wiped during fork(), the vDSO code is already robust to
>    having the contents of the pages it reads zeroed out midway through
>    the function's execution.
>
> 2) In the absolute worst case of whatever contingency we're coding for,
>    we have the option to fallback to the getrandom() syscall, and
>    everything is fine.
>
> 3) The buffers the function uses are only ever useful for a maximum of
>    60 seconds -- a sort of cache, rather than a long term allocation.
>
> These characteristics mean that we can introduce VM_DROPPABLE, which
> has the following semantics:
>
> a) It never is written out to swap.
> b) Under memory pressure, mm can just drop the pages (so that they're
>    zero when read back again).
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
>     VM_DROPPABLE | VM_DONTDUMP | VM_WIPEONFORK | VM_NORESERVE
>
> And there will be no problem with OOMing, crashing on overcommitment,
> using memory when not in use, not wiping on fork(), coredumps, or
> writing out to swap.
>
> Cc: linux-mm@kvack.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  fs/proc/task_mmu.c             | 3 +++
>  include/linux/mm.h             | 8 ++++++++
>  include/trace/events/mmflags.h | 7 +++++++
>  mm/Kconfig                     | 3 +++
>  mm/memory.c                    | 4 ++++
>  mm/mempolicy.c                 | 3 +++
>  mm/mprotect.c                  | 2 +-
>  mm/rmap.c                      | 8 +++++---
>  8 files changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e5a5f015ff03..b5a59e57bde1 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -706,6 +706,9 @@ static void show_smap_vma_flags(struct seq_file *m, s=
truct vm_area_struct *vma)
>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
>  #ifdef CONFIG_X86_USER_SHADOW_STACK
>                 [ilog2(VM_SHADOW_STACK)] =3D "ss",
> +#endif
> +#ifdef CONFIG_NEED_VM_DROPPABLE
> +               [ilog2(VM_DROPPABLE)]   =3D "dp",
>  #endif
>         };
>         size_t i;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9849dfda44d4..5978cb4cc21c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -321,12 +321,14 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_HIGH_ARCH_BIT_3     35      /* bit only usable on 64-bit arch=
itectures */
>  #define VM_HIGH_ARCH_BIT_4     36      /* bit only usable on 64-bit arch=
itectures */
>  #define VM_HIGH_ARCH_BIT_5     37      /* bit only usable on 64-bit arch=
itectures */
> +#define VM_HIGH_ARCH_BIT_6     38      /* bit only usable on 64-bit arch=
itectures */
>  #define VM_HIGH_ARCH_0 BIT(VM_HIGH_ARCH_BIT_0)
>  #define VM_HIGH_ARCH_1 BIT(VM_HIGH_ARCH_BIT_1)
>  #define VM_HIGH_ARCH_2 BIT(VM_HIGH_ARCH_BIT_2)
>  #define VM_HIGH_ARCH_3 BIT(VM_HIGH_ARCH_BIT_3)
>  #define VM_HIGH_ARCH_4 BIT(VM_HIGH_ARCH_BIT_4)
>  #define VM_HIGH_ARCH_5 BIT(VM_HIGH_ARCH_BIT_5)
> +#define VM_HIGH_ARCH_6 BIT(VM_HIGH_ARCH_BIT_6)
>  #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
>
>  #ifdef CONFIG_ARCH_HAS_PKEYS
> @@ -357,6 +359,12 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_SHADOW_STACK       VM_NONE
>  #endif
>
> +#ifdef CONFIG_NEED_VM_DROPPABLE
> +# define VM_DROPPABLE          VM_HIGH_ARCH_6
> +#else
> +# define VM_DROPPABLE          VM_NONE
> +#endif
> +
>  #if defined(CONFIG_X86)
>  # define VM_PAT                VM_ARCH_1       /* PAT reserves whole VMA=
 at once (x86) */
>  #elif defined(CONFIG_PPC)
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflag=
s.h
> index e46d6e82765e..fab7848df50a 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -165,6 +165,12 @@ IF_HAVE_PG_ARCH_X(arch_3)
>  # define IF_HAVE_UFFD_MINOR(flag, name)
>  #endif
>
> +#ifdef CONFIG_NEED_VM_DROPPABLE
> +# define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
> +#else
> +# define IF_HAVE_VM_DROPPABLE(flag, name)
> +#endif
> +
>  #define __def_vmaflag_names                                            \
>         {VM_READ,                       "read"          },              \
>         {VM_WRITE,                      "write"         },              \
> @@ -197,6 +203,7 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,  "softdirty"     )=
               \
>         {VM_MIXEDMAP,                   "mixedmap"      },              \
>         {VM_HUGEPAGE,                   "hugepage"      },              \
>         {VM_NOHUGEPAGE,                 "nohugepage"    },              \
> +IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,     "droppable"     )               \
>         {VM_MERGEABLE,                  "mergeable"     }               \
>
>  #define show_vma_flags(flags)                                          \
> diff --git a/mm/Kconfig b/mm/Kconfig
> index b4cb45255a54..6cd65ea4b3ad 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1056,6 +1056,9 @@ config ARCH_USES_HIGH_VMA_FLAGS
>         bool
>  config ARCH_HAS_PKEYS
>         bool
> +config NEED_VM_DROPPABLE
> +       select ARCH_USES_HIGH_VMA_FLAGS
> +       bool
>
>  config ARCH_USES_PG_ARCH_X
>         bool
> diff --git a/mm/memory.c b/mm/memory.c
> index b5453b86ec4b..57b03fc73159 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *=
vma, unsigned long address,
>
>         lru_gen_exit_fault();
>
> +       /* If the mapping is droppable, then errors due to OOM aren't fat=
al. */
> +       if (vma->vm_flags & VM_DROPPABLE)
> +               ret &=3D ~VM_FAULT_OOM;
> +
>         if (flags & FAULT_FLAG_USER) {
>                 mem_cgroup_exit_user_fault();
>                 /*
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index aec756ae5637..a66289f1d931 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2300,6 +2300,9 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int=
 order, struct vm_area_struct
>         pgoff_t ilx;
>         struct page *page;
>
> +       if (vma->vm_flags & VM_DROPPABLE)
> +               gfp |=3D __GFP_NOWARN | __GFP_NORETRY;
> +
>         pol =3D get_vma_policy(vma, addr, order, &ilx);
>         page =3D alloc_pages_mpol_noprof(gfp | __GFP_COMP, order,
>                                        pol, ilx, numa_node_id());
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 94878c39ee32..88ff3ecc08a1 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -622,7 +622,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_g=
ather *tlb,
>                                 may_expand_vm(mm, oldflags, nrpages))
>                         return -ENOMEM;
>                 if (!(oldflags & (VM_ACCOUNT|VM_WRITE|VM_HUGETLB|
> -                                               VM_SHARED|VM_NORESERVE)))=
 {
> +                                 VM_SHARED|VM_NORESERVE|VM_DROPPABLE))) =
{
>                         charged =3D nrpages;
>                         if (security_vm_enough_memory_mm(mm, charged))
>                                 return -ENOMEM;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e8fc5ecb59b2..d873a3f06506 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1397,7 +1397,8 @@ void folio_add_new_anon_rmap(struct folio *folio, s=
truct vm_area_struct *vma,
>         VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
>         VM_BUG_ON_VMA(address < vma->vm_start ||
>                         address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
> -       __folio_set_swapbacked(folio);
> +       if (!(vma->vm_flags & VM_DROPPABLE))
> +               __folio_set_swapbacked(folio);
>         __folio_set_anon(folio, vma, address, true);
>
>         if (likely(!folio_test_large(folio))) {
> @@ -1841,7 +1842,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                                  * plus the rmap(s) (dropped by discard:)=
.
>                                  */
>                                 if (ref_count =3D=3D 1 + map_count &&
> -                                   !folio_test_dirty(folio)) {
> +                                   (!folio_test_dirty(folio) || (vma->vm=
_flags & VM_DROPPABLE))) {
>                                         dec_mm_counter(mm, MM_ANONPAGES);
>                                         goto discard;
>                                 }
> @@ -1851,7 +1852,8 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                                  * discarded. Remap the page to page tabl=
e.
>                                  */
>                                 set_pte_at(mm, address, pvmw.pte, pteval)=
;
> -                               folio_set_swapbacked(folio);
> +                               if (!(vma->vm_flags & VM_DROPPABLE))
> +                                       folio_set_swapbacked(folio);
>                                 ret =3D false;
>                                 page_vma_mapped_walk_done(&pvmw);
>                                 break;
> --
> 2.44.0
>
>

This seems like an obvious question, but I can't seem to find a
message asking this in the long history of this patchset: VM_DROPPABLE
seems very close to MADV_FREE lazyfree memory.

Could those functionalities be folded in to one?

- Frank
