Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D2526C3BC;
	Sat,  4 Oct 2025 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759593178; cv=none; b=HFgh8lvLuyy9aSmcplxACgrbBpGOQXK4FQaYUnIrvDVmedEAGPw8TL34bb/CQhg2SsHMEBmMrm6JvrLlGDXZ3GdqRqAAjSwzyN77NwZ0XaZMPJGeH+D48I0CBUMA7McFTNewV2VvKNoGETS8eDyZWOhPa/fMI/bNPPk4eXlRKgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759593178; c=relaxed/simple;
	bh=VvebeIMyWbu1aBBg6E2uP5MoUK21Y7/8+cc9Bn7WtnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8MsF4GjXb/uqKvMD3CEGANr5N7RGi9GqLXcI7l/08shpqZBUYstzT6LH7iqT2CcrsSMU5JsnY3SXzla7JSRV1TJFJ/eMb1VZkhQtcpsWpEgqiTq7OIXiW92nAqrlnmUw1VS5EjKVXeXIIAeJl1y1C2ZpmqPvkULlGZhotoeaHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWMNMtmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWMNMtmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28825C4CEF9;
	Sat,  4 Oct 2025 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759593178;
	bh=VvebeIMyWbu1aBBg6E2uP5MoUK21Y7/8+cc9Bn7WtnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWMNMtmptPpVg2hCFSgcBHqWotTRIcs3qfU5KUvorW7Ivg8bhlhFq990qWTfRHiEo
	 7B6U4Swaleq7is1XSiuC/JM7vIwICI4aNSwBmUm5cYm+wcKwVxyoRua38221co0cx0
	 c0NNQxWolBqGgKP7YZy7geH9f8Ge1lLnwNugcf/QJ7a4RMmB9zIlk97GlwJ+Qyl8LX
	 HL7Y8gu9DUIguOlhzZVtiVxa81PIsVp8dYziAAjEp7/p4cZQhZVQ36H0nNEsmpL/8u
	 P/ElBKz7APLXm7YkMHZKLpfl19/tEQw+uhydYn8oTaQTIiPEOoQZH7KqlPOxFs17Q4
	 OQE9sH7HH6BfQ==
Date: Sat, 4 Oct 2025 08:52:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, Kalesh Singh <kaleshsingh@google.com>,
	Juan Yescas <jyescas@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>, LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
Message-ID: <20251004155257.GV8117@frogsfrogsfrogs>
References: <20251003160359.831046052@linuxfoundation.org>
 <CA+G9fYuW6+KiuVd+ONpyo-vWCvF=dSNJzc0cdarBXjNY_XGaAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuW6+KiuVd+ONpyo-vWCvF=dSNJzc0cdarBXjNY_XGaAg@mail.gmail.com>

On Sat, Oct 04, 2025 at 05:35:44PM +0530, Naresh Kamboju wrote:
> On Fri, 3 Oct 2025 at 21:37, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.17.1 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> LTP syscalls swapon01, swapon02, swapon03, swapoff01 and swapoff02 test failing
> on 16K and 64K page arm64 devices and passed with default 4K page size.
> 
> These failures are noticed on Linux next and mainline master (v6.17).
> 
> This test failed on 16K page size builds and 64K page size builds.
>  * CONFIG_ARM64_64K_PAGES=y
>  * CONFIG_ARM64_16K_PAGES=y
> 
> Test regression: LTP swapon/off 16K and 64K page size LTP
> libswap.c:230: TFAIL: swapon() on fuse failed: EINVAL (22)
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Anders, bisected this on the Linux next and found the,
> # first bad commit:
>   [bd24d2108e9c8459d2c9f3d6d910b0053887df57]
>   fuse: fix fuseblk i_blkbits for iomap partial writes

[now that this has come up twice I'm replying]

Yikes, you can do swap over FUSE?  Ohhhh, that's why fuse implements
bmap in the aops.

The last I heard from Joanne, the workaround in that bd24d2108 commit
will go away when she lands iomap for read{,ahead} in 6.19.  Not sure
what the solution is in the meantime.

I speculate that the problem here is that the superblock
s_blocksize_bits always gets reset to PAGE_SHIFT even if the fuse server
had set another value, and now there's a mismatch and the swapfile code
rejects?

<shrug> I dunno how much people care about swap over fuse, but it /is/ a
breaking change.

--D

> ## Test logs
> ### swapon01
> 
> libswap.c:230: TFAIL: swapon() on fuse failed: EINVAL (22)
> swapon01.c:39: TINFO: create a swapfile size of 128 megabytes (MB)
> swapon01.c:25: TFAIL: tst_syscall(__NR_swapon, SWAP_FILE, 0) failed: EINVAL (22)
> 
> Lore link,
> - https://lore.kernel.org/all/CA+G9fYtnXeG6oVrq+5v70sE2W7Wws_zcc63VaXZjy1b1O1S-FQ@mail.gmail.com/
> 
> ## Build
> * kernel: 6.17.1-rc1
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git commit: e7da5b86b53db5f0fb8e2a4e0936eab2e6491ec7
> * git describe: v6.17-16-ge7da5b86b53d
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17-16-ge7da5b86b53d
> 
> ## Test Regressions (compared to v6.17-16-ge7da5b86b53d)
> * qemu-arm64, ltp-syscalls
>   - swapoff01
>   - swapoff02
>   - swapon01
>   - swapon02
>   - swapon03
> 
> ## Metric Regressions (compared to v6.17-16-ge7da5b86b53d)
> 
> ## Test Fixes (compared to v6.17-16-ge7da5b86b53d)
> 
> ## Metric Fixes (compared to v6.17-16-ge7da5b86b53d)
> 
> ## Test result summary
> total: 162823, pass: 136895, fail: 4815, skip: 21113, xfail: 0
> 
> ## Build Summary
> * arc: 5 total, 5 passed, 0 failed
> * arm: 139 total, 138 passed, 1 failed
> * arm64: 57 total, 51 passed, 6 failed
> * i386: 18 total, 18 passed, 0 failed
> * mips: 34 total, 33 passed, 1 failed
> * parisc: 4 total, 4 passed, 0 failed
> * powerpc: 40 total, 39 passed, 1 failed
> * riscv: 25 total, 24 passed, 1 failed
> * s390: 22 total, 21 passed, 1 failed
> * sh: 5 total, 5 passed, 0 failed
> * sparc: 4 total, 3 passed, 1 failed
> * x86_64: 49 total, 46 passed, 3 failed
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
> * kselftest-mm
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-mptcp
> * kselftest-openat2
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-rust
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
> * lava
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
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
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
> * rt-tests-cyclicdeadline
> * rt-tests-pi-stress
> * rt-tests-pmqtest
> * rt-tests-rt-migrate-test
> * rt-tests-signaltest
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
