Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333043446D6;
	Fri,  5 Dec 2025 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764956397; cv=none; b=ZGQKCR4pnNTb98R5USkv/qbVVDK2zp0k5vcOTQArIJBj58SVbMAduGdYBsUaiZvbnnoRsiP2/hJLc8Yukv+FMTgIvnsbGEuSsTLp2ckKvJU+4rW1GYDQcBYZbmA8S/E3SvRtKqwT5hEAXw+8WLfAjfqEGDJOS85Nhqhc2VWNPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764956397; c=relaxed/simple;
	bh=Slk8zzA2bYCWS+9onULjg8VD1m6TNKR6hA/Y9AbOGJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjHZv+KVBi49XrWBQ/TTkuvw6HFvsaRAHuKmlHOyaR8+0MLTd/TMqldmnpsQo3T3mO8MGT9+Jx3BtB6KPLSXkt1cNtZJjb8cFmoF8B+foXLpOEs75VuQF+Wn5LlF2sep1j5m5FNZ1CvmI6hSWQDGBTnKU+EnBqgYYQ6FWiaftGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppQy1x0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppQy1x0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CEDC4CEF1;
	Fri,  5 Dec 2025 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764956396;
	bh=Slk8zzA2bYCWS+9onULjg8VD1m6TNKR6hA/Y9AbOGJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ppQy1x0BLstyluS9Bsg47F/WBuRKrrsUvNI6WvPXuTJ7e1JWXX/J/48iJ9biO20hg
	 RuTpwLBbo/hVI79cuza2sqxwgLZnFKB/5ZerUdZR0niGyjYAMe9yLQgexJ7t5bRyl2
	 7k6Bmb/iz/ivjuzIqLpweyOu3G7r6oDeKThZbR5Ch68hWBlDjZhCF5ySyIxLh+askM
	 0ecqRWKfRJ0oavAoWzAzOKZ3j/xd2ms4e4iMXUBUBoC7ikMzcjtB4RAMTnQsV8PJzd
	 gCkS7Kp9/BhqRfCYkt6qsFMwrr13Hcxo+XUWAuOoUghR0UYAZ1cIq8xis6ccSoZvcF
	 TL/TuL39SxHRw==
Date: Fri, 5 Dec 2025 10:39:47 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
Message-ID: <20251205173947.GA2484770@ax162>
References: <20251204163821.402208337@linuxfoundation.org>
 <CA+G9fYvz4R6SRM0ZZ6xDtnFcHo-RdQkrE3b9WTM0RCgWNiuieQ@mail.gmail.com>
 <2025120553-sulphate-cancel-0f77@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025120553-sulphate-cancel-0f77@gregkh>

On Fri, Dec 05, 2025 at 05:33:19PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Dec 05, 2025 at 12:59:37PM +0530, Naresh Kamboju wrote:
> > On Thu, 4 Dec 2025 at 22:14, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.197 release.
> > > There are 387 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > The powerpc allnoconfig failed with gcc-8 but passed with gcc-12.
> > 
> > Build regression: powerpc: allnoconfig: gcc-8: Inconsistent kallsyms data
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > ### Build error Powerpc
> > Inconsistent kallsyms data
> > Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> > make[1]: *** [Makefile:1244: vmlinux] Error 1
> > 
> > ### Commit pointing to,
> >   Makefile.compiler: replace cc-ifversion with compiler-specific macros
> >   commit 88b61e3bff93f99712718db785b4aa0c1165f35c upstream.
> > 
> > ### Build
> >  - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/
> >  - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/config
> > 
> > ### Steps to reproduce
> >  - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-8
> > --kconfig allnoconfig
> 
> Odd, this works on 5.10 ok?  What is different about 5.15 that keeps
> this from working?

This issue does reproduce for me locally but only with gcc-8 from TuxMake (i.e., a
version from Debian), not with GCC 8.5.0 from kernel.org.

  $ git show -s --pretty=kernel
  869807d760ee ("libbpf: Fix invalid return address register in s390")

  $ tuxmake -r podman -a powerpc -t gcc-8 -k allnoconfig default
  ...
  Inconsistent kallsyms data
  Try make KALLSYMS_EXTRA_PASS=1 as a workaround
  ...

However, reverting the backport of 88b61e3bff93 ("Makefile.compiler:
replace cc-ifversion with compiler-specific macros") does not resolve
the issue for me:

  $ git revert --no-edit c8dad7eb1e6221e0363ee468dc46700bfbad6dd2
  [detached HEAD 1669da6455e4] Revert "Makefile.compiler: replace cc-ifversion with compiler-specific macros"
   Date: Fri Dec 5 10:30:10 2025 -0700
   13 files changed, 30 insertions(+), 37 deletions(-)

  $ tuxmake -r podman -a powerpc -t gcc-8 -k allnoconfig default
  ...
  Inconsistent kallsyms data
  Try make KALLSYMS_EXTRA_PASS=1 as a workaround
  ...

My bisect landed on the backport of 19de03b312d6 ("block: make
REQ_OP_ZONE_OPEN a write operation") and reverting that actually
resolves the error.

  $ git bisect log
  # bad: [869807d760eeef0e0132eed3f1be6be16d084401] libbpf: Fix invalid return address register in s390
  # good: [cc5ec87693063acebb60f587e8a019ba9b94ae0e] Linux 5.15.196
  git bisect start '869807d760eeef0e0132eed3f1be6be16d084401' 'cc5ec87693063acebb60f587e8a019ba9b94ae0e'
  # bad: [ffd15ced026694355243064968a3b84269e0ee09] ARM: at91: pm: save and restore ACR during PLL disable/enable
  git bisect bad ffd15ced026694355243064968a3b84269e0ee09
  # bad: [1ba52b54e5f45e982d61b4eeabbf28d78a5f9e75] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
  git bisect bad 1ba52b54e5f45e982d61b4eeabbf28d78a5f9e75
  # good: [8966a057d07281a5e65eaa3225cb072713921b25] Revert "docs/process/howto: Replace C89 with C11"
  git bisect good 8966a057d07281a5e65eaa3225cb072713921b25
  # bad: [27df52e05f7dd606e18e869cb4f52ce1fbfe699f] tee: allow a driver to allocate a tee_device without a pool
  git bisect bad 27df52e05f7dd606e18e869cb4f52ce1fbfe699f
  # bad: [2b426fa49ef76bbe04671b3a861352b924a01b96] memstick: Add timeout to prevent indefinite waiting
  git bisect bad 2b426fa49ef76bbe04671b3a861352b924a01b96
  # bad: [c126c39dc662661531c96acbbf5fc129ed7f535a] soc: qcom: smem: Fix endian-unaware access of num_entries
  git bisect bad c126c39dc662661531c96acbbf5fc129ed7f535a
  # good: [c142f0d16766ab7189af4b9128a2c81c56f7a01f] drm/sysfb: Do not dereference NULL pointer in plane reset
  git bisect good c142f0d16766ab7189af4b9128a2c81c56f7a01f
  # bad: [02dc541fc61c3e2dabc3574fe46a19f554ea5d8c] soc: aspeed: socinfo: Add AST27xx silicon IDs
  git bisect bad 02dc541fc61c3e2dabc3574fe46a19f554ea5d8c
  # bad: [23e0fecb7be5010e96b2948490799ef59ac4bea6] block: make REQ_OP_ZONE_OPEN a write operation
  git bisect bad 23e0fecb7be5010e96b2948490799ef59ac4bea6
  # first bad commit: [23e0fecb7be5010e96b2948490799ef59ac4bea6] block: make REQ_OP_ZONE_OPEN a write operation

  $ git revert --no-edit 23e0fecb7be5010e96b2948490799ef59ac4bea6
  [detached HEAD ddf3a34910b0] Revert "block: make REQ_OP_ZONE_OPEN a write operation"
   Date: Fri Dec 5 10:26:26 2025 -0700
    1 file changed, 5 insertions(+), 5 deletions(-)

  $ tuxmake -r podman -a powerpc -t gcc-8 -k allnoconfig default
  ...
  I: config: PASS in 0:00:01.410526
  I: default: PASS in 0:00:04.933923
  ...

No idea why that commit would cause such an issue... but it does not
appear to be 88b61e3bff93 so I guess I am off the hook ;)

Cheers,
Nathan
