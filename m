Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D5621CC47;
	Fri, 21 Nov 2025 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763736352; cv=none; b=tMhhF81kqqE+8ROahxcQ/ZhC2S2ZCLs7XQT+9pnuPPN8vJcmG/jtdG+p4N8FH1vV2TIhw5cK7CV+r7LlDr1YQLwQBlYbNsZHEePhCJTomhjZALtvEEwjvE093y8YYgexWtomF+H/zZGdX6FzRm0k0lnwdA73vvMSzcbtoRnlC2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763736352; c=relaxed/simple;
	bh=MgA+iHCbXzAGYyfK39e3o+GBFa9kMOTkHM4c8Q2Y07w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iqAR8gG4Vke/S3aViOiG7+FtvnZbkxEhuKy2zVVmxRt1CWG/rCJ/WvLBJXLXKCm6tGq10QrkhQQxsv/c0qO2A2qVf4CJ0WG/Vpjm96gBf4ggYjLF2rWfgBOjT5zeTwir7I7jx/8mxXEv7dTXvIwuvnhbdOp3j0ZwrAMc6knPWGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=Nqpm+1nb; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="Nqpm+1nb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=ydLFQK7SXv+kEUbhC353ISIUeiU4Af64nTaKHZk0sLs=; t=1763736348;
	x=1764168348; b=Nqpm+1nbhAm33PeLmfkzMC9/EgkYfl5cAZT31LE7m76wtn1Ph29tpLr3LaGMd
	IQCPtsAhe3PqA510G83UCUogNkzv8Ij19iWIe411EFm9aswjp2NXTbEk+EXTN+E0ecglIWoIi2EjF
	DADIQ86+kmrVctlnwG13f6ZQQa4rHJ0Hkf+25dmBiUaWr/yGL0Z5Ty88NP+or/Aw8xQxvNr4nN8ci
	woicSvMtBsk8MkUGwpuhNW93eYVg4KnPyZySAMFmdHEdZK33/libz8w4Tz2L3xaasqYNpDv4DpZWz
	g3o1DpniiHKVOBJjp/aWhrz9K3n9RHFQNmSD44P/DqQBF98gBA==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1vMSOG-001Db8-06;
	Fri, 21 Nov 2025 15:45:36 +0100
Message-ID: <489a925f-ba57-432d-ac50-dcd78229c2ff@leemhuis.info>
Date: Fri, 21 Nov 2025 15:45:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 164/247] kho: warn and fail on metadata or preserved
 memory in scratch area
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Christian Brauner <brauner@kernel.org>, David Matlack <dmatlack@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 Masahiro Yamada <masahiroy@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Samiullah Khawaja
 <skhawaja@google.com>, Tejun Heo <tj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
 <20251121130200.607393324@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20251121130200.607393324@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1763736348;081a54f0;
X-HE-SMSGID: 1vMSOG-001Db8-06

On 11/21/25 14:11, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> commit e38f65d317df1fd2dcafe614d9c537475ecf9992 upstream.
> 
> Patch series "KHO: kfence + KHO memory corruption fix", v3.
> 
> This series fixes a memory corruption bug in KHO that occurs when KFENCE
> is enabled.

I ran into a build problem that afaics is caused by this change:

"""
In file included from ./arch/x86/include/asm/bug.h:103,
                 from ./arch/x86/include/asm/alternative.h:9,
                 from ./arch/x86/include/asm/barrier.h:5,
                 from ./include/asm-generic/bitops/generic-non-atomic.h:7,
                 from ./include/linux/bitops.h:28,
                 from ./include/linux/bitmap.h:8,
                 from ./include/linux/nodemask.h:91,
                 from ./include/linux/numa.h:6,
                 from ./include/linux/cma.h:7,
                 from kernel/kexec_handover.c:12:
kernel/kexec_handover.c: In function ‘kho_preserve_phys’:
kernel/kexec_handover.c:732:41: error: ‘nr_pages’ undeclared (first use in this function); did you mean ‘dir_pages’?
  732 |                                         nr_pages << PAGE_SHIFT))) {
      |                                         ^~~~~~~~
./include/asm-generic/bug.h:123:32: note: in definition of macro ‘WARN_ON’
  123 |         int __ret_warn_on = !!(condition);                              \
      |                                ^~~~~~~~~
kernel/kexec_handover.c:732:41: note: each undeclared identifier is reported only once for each function it appears in
  732 |                                         nr_pages << PAGE_SHIFT))) {
      |                                         ^~~~~~~~
./include/asm-generic/bug.h:123:32: note: in definition of macro ‘WARN_ON’
  123 |         int __ret_warn_on = !!(condition);                              \
      |                                ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:287: kernel/kexec_handover.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:556: kernel] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builddir/build/BUILD/kernel-6.17.9-build/kernel-6.17.9-rc1/linux-6.17.9-0.rc1.300.vanilla.fc43.x86_64/Makefile:2019: .] Error 2
make: *** [Makefile:256: __sub-make] Error 2
"""
 
Ciao, Thorsten

> The root cause is that KHO metadata, allocated via kzalloc(), can be
> randomly serviced by kfence_alloc().  When a kernel boots via KHO, the
> early memblock allocator is restricted to a "scratch area".  This forces
> the KFENCE pool to be allocated within this scratch area, creating a
> conflict.  If KHO metadata is subsequently placed in this pool, it gets
> corrupted during the next kexec operation.
> 
> Google is using KHO and have had obscure crashes due to this memory
> corruption, with stacks all over the place.  I would prefer this fix to be
> properly backported to stable so we can also automatically consume it once
> we switch to the upstream KHO.
> 
> Patch 1/3 introduces a debug-only feature (CONFIG_KEXEC_HANDOVER_DEBUG)
> that adds checks to detect and fail any operation that attempts to place
> KHO metadata or preserved memory within the scratch area.  This serves as
> a validation and diagnostic tool to confirm the problem without affecting
> production builds.
> 
> Patch 2/3 Increases bitmap to PAGE_SIZE, so buddy allocator can be used.
> 
> Patch 3/3 Provides the fix by modifying KHO to allocate its metadata
> directly from the buddy allocator instead of slab.  This bypasses the
> KFENCE interception entirely.
> 
> 
> This patch (of 3):
> 
> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel.  This can
> lead to memory corruption.
> 
> Add checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region.  If an overlap is
> detected, the operation will fail and a WARN_ON is triggered.  To avoid
> performance overhead in production kernels, these checks are enabled only
> when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
> 
> [rppt@kernel.org: fix KEXEC_HANDOVER_DEBUG Kconfig dependency]
>   Link: https://lkml.kernel.org/r/aQHUyyFtiNZhx8jo@kernel.org
> [pasha.tatashin@soleen.com: build fix]
>   Link: https://lkml.kernel.org/r/CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com
> Link: https://lkml.kernel.org/r/20251021000852.2924827-1-pasha.tatashin@soleen.com
> Link: https://lkml.kernel.org/r/20251021000852.2924827-2-pasha.tatashin@soleen.com
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Mike Rapoport <rppt@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Samiullah Khawaja <skhawaja@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/Kconfig.kexec             |    9 ++++++
>  kernel/Makefile                  |    1 
>  kernel/kexec_handover.c          |   57 ++++++++++++++++++++++++++-------------
>  kernel/kexec_handover_debug.c    |   25 +++++++++++++++++
>  kernel/kexec_handover_internal.h |   20 +++++++++++++
>  5 files changed, 93 insertions(+), 19 deletions(-)
>  create mode 100644 kernel/kexec_handover_debug.c
>  create mode 100644 kernel/kexec_handover_internal.h
> 
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -109,6 +109,15 @@ config KEXEC_HANDOVER
>  	  to keep data or state alive across the kexec. For this to work,
>  	  both source and target kernels need to have this option enabled.
>  
> +config KEXEC_HANDOVER_DEBUG
> +	bool "Enable Kexec Handover debug checks"
> +	depends on KEXEC_HANDOVER
> +	help
> +	  This option enables extra sanity checks for the Kexec Handover
> +	  subsystem. Since, KHO performance is crucial in live update
> +	  scenarios and the extra code might be adding overhead it is
> +	  only optionally enabled.
> +
>  config CRASH_DUMP
>  	bool "kernel crash dumps"
>  	default ARCH_DEFAULT_CRASH_DUMP
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -82,6 +82,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
>  obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
>  obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
>  obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
> +obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
>  obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
>  obj-$(CONFIG_COMPAT) += compat.o
>  obj-$(CONFIG_CGROUPS) += cgroup/
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -8,6 +8,7 @@
>  
>  #define pr_fmt(fmt) "KHO: " fmt
>  
> +#include <linux/cleanup.h>
>  #include <linux/cma.h>
>  #include <linux/count_zeros.h>
>  #include <linux/debugfs.h>
> @@ -21,6 +22,7 @@
>  
>  #include <asm/early_ioremap.h>
>  
> +#include "kexec_handover_internal.h"
>  /*
>   * KHO is tightly coupled with mm init and needs access to some of mm
>   * internal APIs.
> @@ -93,26 +95,26 @@ struct kho_serialization {
>  
>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  {
> -	void *elm, *res;
> +	void *res = xa_load(xa, index);
>  
> -	elm = xa_load(xa, index);
> -	if (elm)
> -		return elm;
> +	if (res)
> +		return res;
> +
> +	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
>  
> -	elm = kzalloc(sz, GFP_KERNEL);
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
> +		return ERR_PTR(-EINVAL);
> +
>  	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
>  	if (xa_is_err(res))
> -		res = ERR_PTR(xa_err(res));
> -
> -	if (res) {
> -		kfree(elm);
> +		return ERR_PTR(xa_err(res));
> +	else if (res)
>  		return res;
> -	}
>  
> -	return elm;
> +	return no_free_ptr(elm);
>  }
>  
>  static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
> @@ -263,15 +265,19 @@ static_assert(sizeof(struct khoser_mem_c
>  static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
>  					  unsigned long order)
>  {
> -	struct khoser_mem_chunk *chunk;
> +	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
>  
>  	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!chunk)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))
> +		return ERR_PTR(-EINVAL);
> +
>  	chunk->hdr.order = order;
>  	if (cur_chunk)
>  		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
> -	return chunk;
> +	return no_free_ptr(chunk);
>  }
>  
>  static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
> @@ -292,14 +298,17 @@ static int kho_mem_serialize(struct kho_
>  	struct khoser_mem_chunk *chunk = NULL;
>  	struct kho_mem_phys *physxa;
>  	unsigned long order;
> +	int err = -ENOMEM;
>  
>  	xa_for_each(&ser->track.orders, order, physxa) {
>  		struct kho_mem_phys_bits *bits;
>  		unsigned long phys;
>  
>  		chunk = new_chunk(chunk, order);
> -		if (!chunk)
> +		if (IS_ERR(chunk)) {
> +			err = PTR_ERR(chunk);
>  			goto err_free;
> +		}
>  
>  		if (!first_chunk)
>  			first_chunk = chunk;
> @@ -309,8 +318,10 @@ static int kho_mem_serialize(struct kho_
>  
>  			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
>  				chunk = new_chunk(chunk, order);
> -				if (!chunk)
> +				if (IS_ERR(chunk)) {
> +					err = PTR_ERR(chunk);
>  					goto err_free;
> +				}
>  			}
>  
>  			elm = &chunk->bitmaps[chunk->hdr.num_elms];
> @@ -327,7 +338,7 @@ static int kho_mem_serialize(struct kho_
>  
>  err_free:
>  	kho_mem_ser_free(first_chunk);
> -	return -ENOMEM;
> +	return err;
>  }
>  
>  static void __init deserialize_bitmap(unsigned int order,
> @@ -380,8 +391,8 @@ static void __init kho_mem_deserialize(c
>   * area for early allocations that happen before page allocator is
>   * initialized.
>   */
> -static struct kho_scratch *kho_scratch;
> -static unsigned int kho_scratch_cnt;
> +struct kho_scratch *kho_scratch;
> +unsigned int kho_scratch_cnt;
>  
>  /*
>   * The scratch areas are scaled by default as percent of memory allocated from
> @@ -684,6 +695,9 @@ int kho_preserve_folio(struct folio *fol
>  	if (kho_out.finalized)
>  		return -EBUSY;
>  
> +	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
> +		return -EINVAL;
> +
>  	return __kho_preserve_order(track, pfn, order);
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);
> @@ -713,6 +727,11 @@ int kho_preserve_phys(phys_addr_t phys,
>  	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
>  		return -EINVAL;
>  
> +	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
> +					nr_pages << PAGE_SHIFT))) {
> +		return -EINVAL;
> +	}
> +
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> --- /dev/null
> +++ b/kernel/kexec_handover_debug.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * kexec_handover_debug.c - kexec handover optional debug functionality
> + * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +#define pr_fmt(fmt) "KHO: " fmt
> +
> +#include "kexec_handover_internal.h"
> +
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	phys_addr_t scratch_start, scratch_end;
> +	unsigned int i;
> +
> +	for (i = 0; i < kho_scratch_cnt; i++) {
> +		scratch_start = kho_scratch[i].addr;
> +		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
> +
> +		if (phys < scratch_end && (phys + size) > scratch_start)
> +			return true;
> +	}
> +
> +	return false;
> +}
> --- /dev/null
> +++ b/kernel/kexec_handover_internal.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
> +#define LINUX_KEXEC_HANDOVER_INTERNAL_H
> +
> +#include <linux/kexec_handover.h>
> +#include <linux/types.h>
> +
> +extern struct kho_scratch *kho_scratch;
> +extern unsigned int kho_scratch_cnt;
> +
> +#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size);
> +#else
> +static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
> +
> +#endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
> 
> 
> 

