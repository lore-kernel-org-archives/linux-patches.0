Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D3321A425;
	Wed,  3 Sep 2025 09:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892895; cv=none; b=kJlYJfhYZpZpdDGsvDVw9kE6iT4kfZmS3w1qCIdcCVlAijCwV+Pa5VZfImeCHvPgjygCu1Eh0RllYwYzd15eKipD38nXXVfMNIgvUKVFnlApL9QAk2ZwdGunpuQb5YNWQBDjx2BJBDfOku6tQzl5POzkNifd1zen3TPR0Ujdu1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892895; c=relaxed/simple;
	bh=bMCZYJzX4r1caQDY+4LLdVSIBbbsh6amHV8lHquVp1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GaqCTqfHn5gVQSTEsnyc6uI5mmI0aNLZdaSHIH84bs2AILRumVPXTshZEAHJbnqrBQMkUiu2l25EEITJfS278eoDDv9eOym9mSg6mz+MWCNbPYr+C03upQt5OEGUw/AoxAa//SgLRvmSDB+1GHhF80dOo7GmWuJjVaG7W6lIJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEpkRS8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEpkRS8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0CFC4CEF1;
	Wed,  3 Sep 2025 09:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756892894;
	bh=bMCZYJzX4r1caQDY+4LLdVSIBbbsh6amHV8lHquVp1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vEpkRS8ep6J0XdI2ePyO0Jn8LI59zyV42pu0BySpJ5arERSo6pTQc/QEcrkaEoogC
	 sdnI9h5eN8VfuJ6pJ6v+6OFdyp8PqPQRn1R8KNWdH+cKT9Ribn3OtBnM7LQbuSFCFJ
	 lQaDRtXmrPksc8lx1Yo8JVnN4P/MARyDX0Q8aRno=
Date: Wed, 3 Sep 2025 11:48:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	clang-built-linux <llvm@lists.linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.4 00/23] 5.4.298-rc1 review
Message-ID: <2025090317-envelope-professed-b38a@gregkh>
References: <20250902131924.720400762@linuxfoundation.org>
 <CA+G9fYtoKARW00i0ct=M+-1OAWoQhE_rvsS6RJPPQ7YEcZ4C1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtoKARW00i0ct=M+-1OAWoQhE_rvsS6RJPPQ7YEcZ4C1w@mail.gmail.com>

On Wed, Sep 03, 2025 at 03:11:26PM +0530, Naresh Kamboju wrote:
> On Tue, 2 Sept 2025 at 19:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.298 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.298-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The following build warnings / errors were noticed on powerpc cell_defconfig
> and mpc83xx_defconfig with clang-20 toolchain on stable-rc 5.4.298-rc1.
> 
> But the gcc-12 build passed.
> 
> * powerpc, build
>   - clang-20-cell_defconfig
>   - clang-20-mpc83xx_defconfig
>   - clang-nightly-cell_defconfig
>   - clang-nightly-mpc83xx_defconfig
> 
> Regression Analysis:
> - New regression? yes
> - Reproducibility? yes
> 
> First seen on 5.4.298-rc1
> Bad: 5.4.298-rc1
> Good: v5.4.297
> 
> Build regression: stable-rc 5.4.298-rc1 powerpc/boot/util.S:44: Error:
> junk at end of line, first unrecognized character is `0'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Known issue, patch already submitted:
	https://lore.kernel.org/r/20250902235234.2046667-1-nathan@kernel.org

Will queue that up for the next round of releases, using clang-20 on
5.4.y is brave :)

thanks,

greg k-h
