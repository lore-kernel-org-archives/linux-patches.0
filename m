Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710822FD7CA
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 12:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764678768; cv=none; b=pH4ipVNogKJjdIEhNakyp4JJJc2UppEZzH6Ug+8uwqTbbsc8aL3R0/EVwGvb226d4r2XN0HPIMRuU/8PvvwgF/MPkM3LurpnHMK6/3EdUnYIs3GDnnKqfINqQ/XN4PHslf9tjwM5o6DXN3S/XwoW3Mqaf/qfsm7dpUp8f5Qbc+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764678768; c=relaxed/simple;
	bh=B7xsImJSh4n9l027y6Y3iGlg0olZDZBACXh/3ZYdz2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nOHjICE7ex6zQhv88eEOzbn3/Yr0bj2gyyLeBt3UtfcppiKJkFjpMy5JEMZCfUBIWimMNasncFDAEv4VeTCAaPSPS8xsUwWElK2Hr2fNxKUON3huxd0JF5xo9X6EqZI7+3KK4FASC4QLwvr3hjfgRf4srR10yXrc94LuJPjcx3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fbNKPiKK; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fbNKPiKK"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78a76afeff6so59457867b3.0
        for <patches@lists.linux.dev>; Tue, 02 Dec 2025 04:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764678765; x=1765283565; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pQIYFOER+DEyzt/8xsy4ffVRfQ6YyrVtaYszfSMyYVI=;
        b=fbNKPiKKLWHHKRN9i1KsNvHAdLmKbmf1QIkUa9TxUz6V3ZrVgd7N6l/LK3CFPhFC28
         eOl88HzLB+SLD0h66K7Ox+y/Jg2K/pPJ8mAieBnoO7wlkOBH3Qe2GogVZ9KfsRJo+FvS
         Sfk2vm6hMp6f7SJWgnTKuI6J2+dFhihdaEUFbzwmvVYUxkAWfLaDh5WHYqK2h+QdvE7F
         ol2Zq5L2p7oEmZWP2GezBLNsPy7rTJYNiZVgVXhcVklpvdiiqAGMrbaxcAjLIZmGDOX6
         dsq3C8B8dNj/UyvttInjC6COHcpHoXlKIYEYlMcvmnqZ0NDXMo/0VN7JaySf9W4e8Sce
         fKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764678765; x=1765283565;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQIYFOER+DEyzt/8xsy4ffVRfQ6YyrVtaYszfSMyYVI=;
        b=ThvfA8c4EMfJoJCz8R335WttIE0aiJhI9/F78fg29HmTrbdRW5tr3Ix7f7/CqgATx8
         KZtCmytYANCk0pXnCu0+Mgxxjk3nmsSJAsL2GsK8aL9YVigr8u7p/PJwAmEt13juXRVP
         KHY16Dp7js7wLAXwPnha89Yxp2h/p3p2uLYWewoj/GiszxLohqtyT6JHWcUzTduSIMS+
         7u6GOSPR0AlJDm8xLuBCmc2q4qRNFstyEKB1hfA95jxUawVfxFyVM72DfSbm8GDsb4mg
         I6LtjLd+OU2wPoHKaN4msW61wRm1ouyjLAPDReN5oZ/unF/aZ5M+M+Fgxb3+LcOPb4aq
         SzlA==
X-Forwarded-Encrypted: i=1; AJvYcCVCtLmSv0x9nuB5uOX/vO/gv8K2HV4cQ5868lyFvIN/3hmY1vUW7OuCKWY9w6khFrxmk7UAoCRC@lists.linux.dev
X-Gm-Message-State: AOJu0Yxfh7+SxPQsjst7QjexUaIevXEqEiU/Y5N6rsID5Vq8yE49hg2c
	SAnnh/3pyb6ICaex7kuD3q05lo3VTpHAv9pJQr/TxAYoBGm6iHsrNSdUGsQud6uZs9Ug3Neg7fA
	gnyYOvPFpUm9BPYD/O5T2qVYqDxvsmhzJrJZhipew8Q==
X-Gm-Gg: ASbGncuFJgX1u9TFHST+6J9aWkLVyeRzdIaeD93V+Aw6GkmhzQZeeakPm8lHYnynVYl
	0B0aMdEBvjCkIp8iBXfgj6XpYE2wUZBV/DFdGg/TkWV4qECibZT1AZFZLaGAHwF0j+b8IIng1sK
	TJLn9jP1FshRnt8HTz+2c1omzvnUHsP4sBQavHuE8GDhA3/qGuDHfq0cv2rUAwsV0dXaXKH0MW1
	Q1KOJTOYh0O7LIAGhEBxzCMQoWGwM+uylO+QUF0oC1FcnDdOWBrqO4OtzfPbe7621JsPz8YjRp7
	jUALy1PAgnqmOnuGxoK6DtghSAV20Qqh3Yx7EBY=
X-Google-Smtp-Source: AGHT+IFE2pcDVJtiT+Ye36pmq0tuWoALbiw+3W7TdYBo7VJQjP/Un4lSEKsuZlu4C/H1KOGqXJNubv33oLKhiHO2bzc=
X-Received: by 2002:a05:690c:3510:b0:786:6b92:b200 with SMTP id
 00721157ae682-78a8b4cbc4dmr374825677b3.30.1764678765322; Tue, 02 Dec 2025
 04:32:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251202095448.089783651@linuxfoundation.org>
In-Reply-To: <20251202095448.089783651@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Dec 2025 18:02:33 +0530
X-Gm-Features: AWmQ_bm02SZdTeMjVd095EnXSzGnHsUMWxuWQCSDsJsvyCfAuLbkKwyl2-gH4Go
Message-ID: <CA+G9fYvF3cGqi_McG1AtfkMgd5EB_=nmcwiJAGFjZReP8dGKxg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/184] 5.4.302-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, 
	Ben Copeland <benjamin.copeland@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Hugh Dickins <hughd@google.com>, Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Dec 2025 at 15:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Dec 2025 09:54:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The powerpc builds failed on the stable-rc 5.4.302-rc1 and 5.4.302-rc2.

* powerpc, build
  - clang-21-cell_defconfig
  - clang-nightly-cell_defconfig
  - gcc-12-cell_defconfig
  - gcc-12-defconfig
  - gcc-12-ppc64e_defconfig
  - gcc-12-ppc6xx_defconfig
  - gcc-8-cell_defconfig
  - gcc-8-defconfig
  - gcc-8-ppc64e_defconfig
  - gcc-8-ppc6xx_defconfig

Build regressions: powerpc: mm/mprotect.c:: pgtable.h:971:38: error:
called object 'pmd_val' is not a function or function pointer
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

The bisection is in progress,
meanwhile this patch looks to be causing the build failure,

mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.

The sequence patch.
mm/mprotect: use long for page accountings and retval
commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.

### Build error
In file included from include/linux/bug.h:5,
                 from include/linux/mmdebug.h:5,
                 from include/linux/mm.h:9,
                 from include/linux/pagewalk.h:5,
                 from mm/mprotect.c:12:
mm/mprotect.c: In function 'change_pte_range':
arch/powerpc/include/asm/book3s/64/pgtable.h:971:38: error: called
object 'pmd_val' is not a function or function pointer
  971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
      |                                      ^~~~~~~
arch/powerpc/include/asm/bug.h:91:32: note: in definition of macro 'WARN_ON'
   91 |         int __ret_warn_on = !!(x);                              \
      |                                ^
arch/powerpc/include/asm/page.h:229:9: note: in expansion of macro
'VIRTUAL_WARN_ON'
  229 |         VIRTUAL_WARN_ON((unsigned long)(x) >= PAGE_OFFSET);
         \
      |         ^~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/pgtable.h:971:33: note: in
expansion of macro '__va'
  971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
      |                                 ^~~~
arch/powerpc/include/asm/book3s/64/pgtable.h:1007:21: note: in
expansion of macro 'pmd_page_vaddr'
 1007 |         (((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
      |                     ^~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/pgtable.h:1009:41: note: in
expansion of macro 'pte_offset_kernel'
 1009 | #define pte_offset_map(dir,addr)        pte_offset_kernel((dir), (addr))
      |                                         ^~~~~~~~~~~~~~~~~
include/linux/mm.h:2010:24: note: in expansion of macro 'pte_offset_map'
 2010 |         pte_t *__pte = pte_offset_map(pmd, address);    \
      |                        ^~~~~~~~~~~~~~
mm/mprotect.c:48:15: note: in expansion of macro 'pte_offset_map_lock'
   48 |         pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
      |               ^~~~~~~~~~~~~~~~~~~
mm/mprotect.c:43:15: note: declared here
   43 |         pmd_t pmd_val;
      |               ^~~~~~~
In file included from arch/powerpc/include/asm/mmu.h:132,
                 from arch/powerpc/include/asm/lppaca.h:47,
                 from arch/powerpc/include/asm/paca.h:17,
                 from arch/powerpc/include/asm/current.h:13,
                 from include/linux/thread_info.h:22,
                 from include/asm-generic/preempt.h:5,
                 from ./arch/powerpc/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:78,
                 from include/linux/spinlock.h:51,
                 from include/linux/mmzone.h:8,
                 from include/linux/gfp.h:6,
                 from include/linux/mm.h:10:
arch/powerpc/include/asm/book3s/64/pgtable.h:971:38: error: called
object 'pmd_val' is not a function or function pointer
  971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
      |                                      ^~~~~~~
arch/powerpc/include/asm/page.h:230:47: note: in definition of macro '__va'
  230 |         (void *)(unsigned long)((phys_addr_t)(x) |
PAGE_OFFSET);        \
      |                                               ^
arch/powerpc/include/asm/book3s/64/pgtable.h:1007:21: note: in
expansion of macro 'pmd_page_vaddr'
 1007 |         (((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
      |                     ^~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/pgtable.h:1009:41: note: in
expansion of macro 'pte_offset_kernel'
 1009 | #define pte_offset_map(dir,addr)        pte_offset_kernel((dir), (addr))
      |                                         ^~~~~~~~~~~~~~~~~
include/linux/mm.h:2010:24: note: in expansion of macro 'pte_offset_map'
 2010 |         pte_t *__pte = pte_offset_map(pmd, address);    \
      |                        ^~~~~~~~~~~~~~
mm/mprotect.c:48:15: note: in expansion of macro 'pte_offset_map_lock'
   48 |         pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
      |               ^~~~~~~~~~~~~~~~~~~
mm/mprotect.c:43:15: note: declared here
   43 |         pmd_t pmd_val;
      |               ^~~~~~~
make[2]: *** [scripts/Makefile.build:262: mm/mprotect.o] Error 1
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1769: mm] Error 2
kernel/profile.c: In function 'profile_dead_cpu':
kernel/profile.c:347:27: warning: the comparison will always evaluate
as 'true' for the address of 'prof_cpu_mask' will never be NULL
[-Waddress]
  347 |         if (prof_cpu_mask != NULL)
      |                           ^~
kernel/profile.c:50:22: note: 'prof_cpu_mask' declared here
   50 | static cpumask_var_t prof_cpu_mask;
      |                      ^~~~~~~~~~~~~
kernel/profile.c: In function 'profile_online_cpu':
kernel/profile.c:384:27: warning: the comparison will always evaluate
as 'true' for the address of 'prof_cpu_mask' will never be NULL
[-Waddress]
  384 |         if (prof_cpu_mask != NULL)
      |                           ^~
kernel/profile.c:50:22: note: 'prof_cpu_mask' declared here
   50 | static cpumask_var_t prof_cpu_mask;
      |                      ^~~~~~~~~~~~~
kernel/profile.c: In function 'profile_tick':
kernel/profile.c:414:47: warning: the comparison will always evaluate
as 'true' for the address of 'prof_cpu_mask' will never be NULL
[-Waddress]
  414 |         if (!user_mode(regs) && prof_cpu_mask != NULL &&
      |                                               ^~
kernel/profile.c:50:22: note: 'prof_cpu_mask' declared here
   50 | static cpumask_var_t prof_cpu_mask;
      |                      ^~~~~~~~~~~~~
In file included from include/linux/list.h:9,
                 from include/net/tcp.h:19,
                 from net/ipv4/tcp_output.c:40:
net/ipv4/tcp_output.c: In function 'tcp_tso_should_defer':
include/linux/kernel.h:843:43: warning: comparison of distinct pointer
types lacks a cast
  843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                           ^~
include/linux/kernel.h:857:18: note: in expansion of macro '__typecheck'
  857 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
include/linux/kernel.h:867:31: note: in expansion of macro '__safe_cmp'
  867 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
include/linux/kernel.h:876:25: note: in expansion of macro '__careful_cmp'
  876 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
net/ipv4/tcp_output.c:2028:21: note: in expansion of macro 'min'
 2028 |         threshold = min(srtt_in_ns >> 1, NSEC_PER_MSEC);
      |                     ^~~
fs/xfs/libxfs/xfs_inode_fork.c: In function 'xfs_ifork_verify_attr':
fs/xfs/libxfs/xfs_inode_fork.c:735:13: warning: the comparison will
always evaluate as 'true' for the address of 'i_df' will never be NULL
[-Waddress]
  735 |         if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
      |             ^
In file included from fs/xfs/libxfs/xfs_inode_fork.c:14:
fs/xfs/xfs_inode.h:38:33: note: 'i_df' declared here
   38 |         struct xfs_ifork        i_df;           /* data fork */
      |                                 ^~~~
make[1]: Target '_all' not remade because of errors.
make: *** [Makefile:186: sub-make] Error 2
make: Target '_all' not remade because of errors.

### Build logs
Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.4.y/v5.4.301-185-ga03757dc1d0b/build/gcc-12-defconfig/
Build log: https://storage.tuxsuite.com/public/linaro/lkft/builds/36Hn1iZBZCBAXg2OuUdfdNEUFxK/
Build config: https://storage.tuxsuite.com/public/linaro/lkft/builds/36Hn1iZBZCBAXg2OuUdfdNEUFxK/config

### Steps to reproduce
 - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-12
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
