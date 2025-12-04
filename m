Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98D832694E
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 08:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764837521; cv=none; b=pT6iqL9d+O75CrUU9lm5CUusTfcopwRLK+2tKhAMK3byn+UEIlKgNcnZKg1rgRDstJzrG8/0h9S0K7Zd7rmep+XpNvRwgw08NcweXUkv2uua4ZaRrjWN5JykX9dwsXGFwHOSr/4LYEmoxqX8XlnNH9Wfcc/X/8816sC3ooL45Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764837521; c=relaxed/simple;
	bh=mqhXiD/NpVQgpF5pRnCUAPxzIeECRU0KQVh4dg8DiKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRAfJRjilQ1aJcVWw1jqLoxT1caTEl/DPU4a3mW3AXeY9uwUu4oRI3lZs64ZiHlzKGiGvVVVIS6RXou3oDNrpAWhixCD78KZo+h8Gu45fsP+eT8Tl7mH4vK2trg5yIzmVzNHTqfJVr80PHmjrSj9hvgfJnP1/HaEkwVJNkH+qWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CHd1QtC+; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CHd1QtC+"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bd610f4425fso373096a12.3
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 00:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764837517; x=1765442317; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0JlKi5Mxej8/+ZcumeV18Yc+KKJCP9ofTFD7HkIbArE=;
        b=CHd1QtC+lXeE5Slowd1RYhRlbb6Kk5lxz/e0oTOiNGyt3kmvGoDPTGn6F/akoRBx+y
         VHx0y+6cfTcSSXZE+8e34ZILLddXi9GSlxZov2URVfl+yL29X1xbIIXuMAHs0vjrnmC7
         HMBNtPVrxVawu4hQniYbGt0RsbkrqHZA4oQmyBMx6AuZ0peqmumPj9MqDo0q7FlxBrBU
         VByJSoeYTe/BhWD/RLou1VOm/wj5RQY1id8UxkMfzLW0y7jG9jTdabOn/YCmmUh+z9xu
         y1ka/UPC+xdW5hwzOaBwZ4xYB3MH8SoyMzCtX7o2JtBZQOnzX3tkj7KePN6XvNewAG83
         /rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764837517; x=1765442317;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JlKi5Mxej8/+ZcumeV18Yc+KKJCP9ofTFD7HkIbArE=;
        b=dEtPDE8mIKaJqnmrlU9/PVT8E0YnhMzrp2vSCFNEVDO5VGFW3JOhtrEy8iMD++UGZE
         4yWjPoJFWVBFTGuh1nis4K/rI2qMtkzUUgdToGa7xNFhFd1jMhHFFOw6D1BZWmXYGKAD
         kvRqBmZ7F7rBRxRRjM0GZ0NHdhy9OotywyBWIFyq5qQOeG3ZW0+PYjMjmZ6GOKcpCR1P
         40V7PZWKYuMpWr9xUDd3SJiOyMLuALVHlTIxJeCGSBlt8jONbpiTjmnuq2QXyPTtTzBK
         7zfhQ3e98DurYjfhzl6VjtwXveypng6bV85vMOn9M8jNgnJBfZ7xDCN72na1/MEklpA0
         9X9A==
X-Forwarded-Encrypted: i=1; AJvYcCXXLGPApUGyL5LSFxCjCyANssv5IefWvQaZlzBhcd4kthuTj6/oFN0r2urDVUJBy3XzFJ8Dqw7/@lists.linux.dev
X-Gm-Message-State: AOJu0YyAQzZwskZs4cN4p86jppSJZeqzyO64XdyBhbOhNSWARyQJEIDb
	/olj+xSHUYoj/LJOwYfHVRiT3EwJqmJFVbbHHziaJqMixvR5yqKVfHayym8IaYrkZOPnl4YEu7W
	lOPYxmLhk60F9gLop+sCnynHneIzyICXX1MpFiHo3zQ==
X-Gm-Gg: ASbGncuXbtXesaHw0NiuZoKXn9o8iZmcyjpJXgGeIYZrOob7tO30X6ByrceDWMZZUX1
	oisreAQZstRlNiKdtKUEUimFPU+51r30QFiq3KQWW8PT+hOD87WCwTtdYdeCeGSho1RWEfRzw+J
	tCerxw3Cbn/JTPg3L6W/MBIFuCPuTXGUSS2ws/fWCDyeVsnkE7TQb3mysyTlT3e3E0qipVywh55
	BUstSO7mKHJY+gC+MFHiTUkC/1NJ0KDSf9TWMedHi+C300CgqAuHN4n86JpswD8CsXwhZglpW+D
	f3s/ZCpCdTnFKmLIb1iBkPZ0X45H
X-Google-Smtp-Source: AGHT+IFZEAv1ezVPCker9GLaQZImi3N5jH6VXIGomJJWxOm3zS/LZIZssrCOD1GSIIbrPIuYSxinKKQkE6vNP8MxkPE=
X-Received: by 2002:a05:693c:3111:b0:2a4:3592:c5fb with SMTP id
 5a478bee46e88-2aba424d110mr1567722eec.12.1764837517021; Thu, 04 Dec 2025
 00:38:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152414.082328008@linuxfoundation.org>
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Dec 2025 14:08:24 +0530
X-Gm-Features: AWmQ_bnogH29i6myZ_z674xGj0T3c_RPNdGl1-x_I57yUAyVvG1sIUwN6973xXs
Message-ID: <CA+G9fYvmhQs9qx-XpLiaOUZQKj=gR=-X5MoJ1auRmbC7cC+AXw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, Vlastimil Babka <vbabka@suse.cz>, 
	"Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Svyatoslav Ryhel <clamor95@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>, 
	Ian Rogers <irogers@google.com>, linux-mips@vger.kernel.org, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Dec 2025 at 21:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm, mips and powerpc builds failed on the stable-rc 5.15.197-rc1.

Build regressions: arm, fuse-tegra30.c:250:10: error: 'const struct
tegra_fuse_soc' has no member named 'cells'
Build regressions: arm, fuse-tegra30.c:250:18: error: initialization
of 'const struct attribute_group *' from incompatible pointer type
'const struct nvmem_cell_info *' [-Werror=incompatible-pointer-types]
Build regressions: arm, fuse-tegra30.c:251:10: error: 'const struct
tegra_fuse_soc' has no member named 'num_cells'

Build regressions: mips, tlb-r4k.c:591:31: error: passing argument 1
of 'memblock_free' makes integer from pointer without a cast
[-Werror=int-conversion]

Build regressions: powerpc, mm/mempool.c:68:17: error: 'for' loop
initial declarations are only allowed in C99 or C11 mode

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ARM build regressions are due to,

  soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups
  [ Upstream commit b9c01adedf38c69abb725a60a05305ef70dbce03 ]

MIPS build regressions are due to,

  MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow
  commit 841ecc979b18d3227fad5e2d6a1e6f92688776b5 upstream.

Powerpc build regressions are due to,

  mm/mempool: replace kmap_atomic() with kmap_local_page()
  [ Upstream commit f2bcc99a5e901a13b754648d1dbab60f4adf9375 ]

### arm build error
drivers/soc/tegra/fuse/fuse-tegra30.c:250:10: error: 'const struct
tegra_fuse_soc' has no member named 'cells'
  250 |         .cells = tegra114_fuse_cells,
      |          ^~~~~
drivers/soc/tegra/fuse/fuse-tegra30.c:250:18: error: initialization of
'const struct attribute_group *' from incompatible pointer type 'const
struct nvmem_cell_info *' [-Werror=incompatible-pointer-types]
  250 |         .cells = tegra114_fuse_cells,
      |                  ^~~~~~~~~~~~~~~~~~~
drivers/soc/tegra/fuse/fuse-tegra30.c:250:18: note: (near
initialization for 'tegra114_fuse_soc.soc_attr_group')
drivers/soc/tegra/fuse/fuse-tegra30.c:251:10: error: 'const struct
tegra_fuse_soc' has no member named 'num_cells'
  251 |         .num_cells = ARRAY_SIZE(tegra114_fuse_cells),
      |          ^~~~~~~~~
cc1: some warnings being treated as errors

### mips Build error
arch/mips/mm/tlb-r4k.c: In function 'r4k_tlb_uniquify':
arch/mips/mm/tlb-r4k.c:591:31: error: passing argument 1 of
'memblock_free' makes integer from pointer without a cast
[-Werror=int-conversion]
  591 |                 memblock_free(tlb_vpns, tlb_vpn_size);
      |                               ^~~~~~~~
      |                               |
      |                               long unsigned int *
In file included from arch/mips/mm/tlb-r4k.c:15:
include/linux/memblock.h:107:31: note: expected 'phys_addr_t' {aka
'unsigned int'} but argument is of type 'long unsigned int *'
  107 | int memblock_free(phys_addr_t base, phys_addr_t size);
      |                   ~~~~~~~~~~~~^~~~
cc1: all warnings being treated as errors

### powerpc build error
mm/mempool.c: In function 'check_element':
mm/mempool.c:68:17: error: 'for' loop initial declarations are only
allowed in C99 or C11 mode
   68 |                 for (int i = 0; i < (1 << order); i++) {
      |                 ^~~
mm/mempool.c:68:17: note: use option '-std=c99', '-std=gnu99',
'-std=c11' or '-std=gnu11' to compile your code
mm/mempool.c: In function 'poison_element':
mm/mempool.c:101:17: error: 'for' loop initial declarations are only
allowed in C99 or C11 mode
  101 |                 for (int i = 0; i < (1 << order); i++) {
      |                 ^~~
make[2]: *** [scripts/Makefile.build:289: mm/mempool.o] Error 1

## Build
* kernel: 5.15.197-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: d6138097171ea16c4b0e51c3414d51c473f820cc
* git describe: v5.15.196-393-gd6138097171e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.196-393-gd6138097171e

## Test Regressions (compared to v5.15.195-118-g59a59821e6b5)
* arm, build
  - clang-21-defconfig
  - clang-21-lkftconfig
  - clang-21-lkftconfig-no-kselftest-frag
  - clang-nightly-lkftconfig-kselftest
  - gcc-12-defconfig
  - gcc-12-lkftconfig
  - gcc-12-lkftconfig-debug
  - gcc-12-lkftconfig-kasan
  - gcc-12-lkftconfig-kunit
  - gcc-12-lkftconfig-libgpiod
  - gcc-12-lkftconfig-no-kselftest-frag
  - gcc-12-lkftconfig-perf
  - gcc-12-lkftconfig-rcutorture
  - gcc-8-defconfig

* mips, build
  - clang-21-allnoconfig
  - clang-21-defconfig
  - clang-21-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-ath79_defconfig
  - gcc-12-bcm47xx_defconfig
  - gcc-12-bcm63xx_defconfig
  - gcc-12-cavium_octeon_defconfig
  - gcc-12-defconfig
  - gcc-12-e55_defconfig
  - gcc-12-malta_defconfig
  - gcc-12-rt305x_defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-ath79_defconfig
  - gcc-8-bcm47xx_defconfig
  - gcc-8-bcm63xx_defconfig
  - gcc-8-cavium_octeon_defconfig
  - gcc-8-defconfig
  - gcc-8-malta_defconfig
  - gcc-8-rt305x_defconfig
  - gcc-8-tinyconfig

* powerpc, build
  - gcc-12-ppc6xx_defconfig
  - gcc-8-allnoconfig
  - gcc-8-ppc6xx_defconfig


## Metric Regressions (compared to v5.15.195-118-g59a59821e6b5)

## Test Fixes (compared to v5.15.195-118-g59a59821e6b5)

## Metric Fixes (compared to v5.15.195-118-g59a59821e6b5)

## Test result summary
total: 28764, pass: 21862, fail: 2212, skip: 4511, xfail: 179

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 86 passed, 15 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 0 passed, 22 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 19 passed, 3 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
