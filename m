Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A9D1F03D7;
	Tue,  7 Jan 2025 13:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736254934; cv=none; b=blFYEVwiqtvOnPcoP7yEbOuPGrYUpYQr+tjmRyLpWHEeQ7yk2EPsCfLh3K178/hOXtMZShOGG94G/B3MGBUUvIl5aqL+NEAClOLREQijLrE3sj8Ht2SRqxjRSgCWPQDkHMAbXGXQ+Bao+dBqGxAfDjEYjouwHaRKpYNJPzrlAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736254934; c=relaxed/simple;
	bh=QmIKjKV1S+pHqmao2HqQF9Eq/07xJ55stA+Lw6SzzeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pb+LO1lm5g8Ee3ZvHlL0APSgrFgwzy8cVUySfAUj1wl1n6enbXInVxeIPKYkGJHG2jZ/UnkvLo0XfkGyNQq/wxoIQDxeeJaartjhtC5nDPrk3lKFaDdVKzkYvm4VlpAzUZ0wihpi/+s7TMfqBVN4S291f9w7zYgd6TTKF6LyAxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHQF9MkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHQF9MkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1572AC4CED6;
	Tue,  7 Jan 2025 13:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736254933;
	bh=QmIKjKV1S+pHqmao2HqQF9Eq/07xJ55stA+Lw6SzzeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHQF9MkG1knq0WGQLn1aw2Tf/iuBfXvPw3/6xbuXd4ZoeZu80DHKw+QJ68WmUxvrX
	 DutE42VzoWfjEYOETOMfnIbf5iD758Ueta9mJemIDEfmPC8R/JXCOFl9o69tpbMB3K
	 8b1mY5ifyJrm5rn7xL1fGLlITAG9N9f2S6A4ecooL6NujWoErdtnFlx0igftrZATDp
	 cJvVyVtqMFe5kGz8eNx3t9YTgPSHanfuzeT4caedPzOztRaKc0DKVWtMu+E3WVDUTK
	 jPL+30S9Pk9Tc2dDqrBbSIl4L2UPVIDdg4W1Kw8TBlhuh4kRlJR3u2J5q3k5nxrfzA
	 P0efP6FGYpnjQ==
Date: Tue, 7 Jan 2025 15:01:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
Message-ID: <Z30lxAIp9x5dhC5Y@kernel.org>
References: <20250106151150.585603565@linuxfoundation.org>
 <CA+G9fYtn+9qbWA7DvmO7t6TvyTy40cpvKufz+4J06x_nPvnNXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtn+9qbWA7DvmO7t6TvyTy40cpvKufz+4J06x_nPvnNXA@mail.gmail.com>

On Tue, Jan 07, 2025 at 03:54:43PM +0530, Naresh Kamboju wrote:
> On Mon, 6 Jan 2025 at 20:53, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.70 release.
> > There are 222 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> As others have reported, boot warnings on x86 have been noticed
> 
> memblock: make memblock_set_node() also warn about use of MAX_NUMNODES
> [ Upstream commit e0eec24e2e199873f43df99ec39773ad3af2bff7 ]

There's 8043832e2a12 ("memblock: use numa_valid_node() helper to check for
invalid node ID") that fixes it
 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 87a2b4340ce4ea..ba64b47b7c3b24 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1321,6 +1321,10 @@ int __init_memblock
> memblock_set_node(phys_addr_t base, phys_addr_t size,
>   int start_rgn, end_rgn;
>   int i, ret;
> 
> + if (WARN_ONCE(nid == MAX_NUMNODES,
> +      "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
> + nid = NUMA_NO_NODE;
> +
>   ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
>   if (ret)
>   return ret;
> -- 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ------------[ cut here ]------------
> [    0.042522] Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead
> [    0.043058] WARNING: CPU: 0 PID: 0 at mm/memblock.c:1324
> memblock_set_node+0xf0/0x100
> [    0.043730] Modules linked in:
> [    0.043957] CPU: 0 PID: 0 Comm: swapper Not tainted 6.6.70-rc1 #1
> [    0.044026] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    0.044174] RIP: 0010:memblock_set_node+0xf0/0x100
> [    0.044293] Code: 3d 81 da ef ff 00 74 0b 41 bc ff ff ff ff e9 6c
> ff ff ff 48 c7 c7 30 40 e3 8e 48 89 75 d0 c6 05 62 da ef ff 01 e8 20
> cb 04 fe <0f> 0b 48 8b 75 d0 eb d6 e8 43 db 0e ff 0f 1f 00 90 90 90 90
> 90 90
> [    0.044494] RSP: 0000:ffffffff8f003e08 EFLAGS: 00010082 ORIG_RAX:
> 0000000000000000
> [    0.044537] RAX: 0000000000000000 RBX: ffffffff8f46da30 RCX: 0000000000000000
> [    0.044553] RDX: ffffffff8f156f08 RSI: 0000000000000082 RDI: 0000000000000001
> [    0.044588] RBP: ffffffff8f003e38 R08: 0000000000000000 R09: 4f4e5f414d554e20
> [    0.044606] R10: 2045444f4e5f4f4e R11: 0a64616574736e69 R12: 0000000000000040
> [    0.044621] R13: 0000000000000000 R14: 000000013ee00000 R15: 0000000000014750
> [    0.044673] FS:  0000000000000000(0000) GS:ffffffff8f347000(0000)
> knlGS:0000000000000000
> [    0.044707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.044723] CR2: ffff9ab33ffff000 CR3: 0000000140c44000 CR4: 00000000000000b0
> [    0.044816] Call Trace:
> [    0.045237]  <TASK>
> [    0.045521]  ? show_regs+0x69/0x80
> [    0.045593]  ? __warn+0x8d/0x150
> [    0.045611]  ? memblock_set_node+0xf0/0x100
> [    0.045629]  ? report_bug+0x171/0x1a0
> [    0.045648]  ? fixup_exception+0x2b/0x310
> [    0.045669]  ? early_fixup_exception+0xb3/0xd0
> [    0.045687]  ? do_early_exception+0x1f/0x60
> [    0.045716]  ? early_idt_handler_common+0x2f/0x40
> [    0.045742]  ? memblock_set_node+0xf0/0x100
> [    0.045760]  ? memblock_set_node+0xf0/0x100
> [    0.045792]  ? __pfx_x86_acpi_numa_init+0x10/0x10
> [    0.045817]  numa_init+0x8b/0x600
> [    0.045932]  x86_numa_init+0x23/0x50
> [    0.045953]  initmem_init+0x12/0x20
> [    0.045969]  setup_arch+0x88b/0xce0
> [    0.045988]  start_kernel+0x76/0x6d0
> [    0.046008]  x86_64_start_reservations+0x1c/0x30
> [    0.046022]  x86_64_start_kernel+0xca/0xe0
> [    0.046037]  secondary_startup_64_no_verify+0x178/0x17b
> [    0.046111]  </TASK>
> [    0.046180] ---[ end trace 0000000000000000 ]---
> 
> Links:
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.69-223-g5652330123c6/testrun/26599367/suite/log-parser-boot/tests/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.69-223-g5652330123c6/testrun/26599367/suite/log-parser-boot/test/exception-usage-of-max_numnodes-is-deprecated-use-numa_no_node-instead/log
> 
> ## Build
> * kernel: 6.6.70-rc1
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git commit: 5652330123c6a64b444f3012d9c9013742a872e7
> * git describe: v6.6.69-223-g5652330123c6
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.69-223-g5652330123c6
> 
> ## Test Regressions (compared to v6.6.68-87-g159cc5fd9b13)
> * arm64, build
>   - clang-19-allmodconfig
>   - clang-19-allyesconfig
>   - gcc-13-allmodconfig
>   - gcc-13-allyesconfig
> 
> ## Metric Regressions (compared to v6.6.68-87-g159cc5fd9b13)
> 
> ## Test Fixes (compared to v6.6.68-87-g159cc5fd9b13)
> 
> ## Metric Fixes (compared to v6.6.68-87-g159cc5fd9b13)
> 
> ## Test result summary
> total: 150166, pass: 122611, fail: 4998, skip: 22391, xfail: 166
> 
> ## Build Summary
> * arc: 6 total, 5 passed, 1 failed
> * arm: 132 total, 132 passed, 0 failed
> * arm64: 44 total, 38 passed, 6 failed
> * i386: 31 total, 28 passed, 3 failed
> * mips: 30 total, 25 passed, 5 failed
> * parisc: 5 total, 5 passed, 0 failed
> * powerpc: 36 total, 32 passed, 4 failed
> * riscv: 23 total, 22 passed, 1 failed
> * s390: 18 total, 14 passed, 4 failed
> * sh: 12 total, 10 passed, 2 failed
> * sparc: 9 total, 8 passed, 1 failed
> * x86_64: 36 total, 35 passed, 1 failed
> 
> ## Test suites summary
> * boot
> * commands
> * kselftest-arm64
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-efivarfs
> * kselftest-exec
> * kselftest-filesystems
> * kselftest-filesystems-binderfs
> * kselftest-filesystems-epoll
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-ftrace
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-kcmp
> * kselftest-kvm
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-mincore
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-mptcp
> * kselftest-openat2
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-tc-testing
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user_events
> * kselftest-vDSO
> * kselftest-x86
> * kunit
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-build-clang
> * log-parser-build-gcc
> * log-parser-test
> * ltp-capability
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-filecaps
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * perf
> * rcutorture
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

-- 
Sincerely yours,
Mike.
