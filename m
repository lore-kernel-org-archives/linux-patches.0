Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7EF259CAC;
	Thu,  1 May 2025 06:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746081453; cv=none; b=OHBnSNKf8rccB14A+MARxhBmzNpsl/G9Q13JKRK8pfveDO0/X97XU37SojyhaZPysE3przC1KnqVKfR66pPkV729Iuo1cdj6/R3ccYIQlNe0MSu7WBch5Y4LHHjHLgCuH0udPfiIyXW/aYkXH4Za+MUTLzxocMYEDJN6NOZstgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746081453; c=relaxed/simple;
	bh=XSs5FmnW0gR+lLgxJJLKw6c+ayB1H/kAPjj52SplI2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJPJY8KgJTDmxRC2l6lzH/7aiLHW6l0Q1GYj3bBgT3c+aoVO3KfrNGIJdoBHRX0s/PC1jYQBCYmnSrl5WTwRY1bA/buDNRT+91dTDeIASZcoJlFsyA732NTnwRhMGxYX1juiNePQ/mGygBDVru8Rk3BJGh27d2+X7YFJfTG49yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM9qzWz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM9qzWz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0610FC4CEED;
	Thu,  1 May 2025 06:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746081452;
	bh=XSs5FmnW0gR+lLgxJJLKw6c+ayB1H/kAPjj52SplI2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oM9qzWz6qrdfn9mOrSZASQWYjpmBNeWSYnxl1PdbHyTMhNuGcxgG/VZTztO+MB//b
	 IyUtOVRn7RkDlg4zof0+stby89IbOK0QY9rDcEq1faCdoPZbNLJt2O8BXc1SvB9+bx
	 1e08HkfmbDnmf2GPllrCWarB+8GgdpSqhG/FZfpo=
Date: Thu, 1 May 2025 08:37:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
Message-ID: <2025050121-reflected-scorer-cc29@gregkh>
References: <20250429161115.008747050@linuxfoundation.org>
 <CA+G9fYvL0ZXnqujn9iNvy59R1gzX10Of_VLRmad5yg1aGxO_ZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvL0ZXnqujn9iNvy59R1gzX10Of_VLRmad5yg1aGxO_ZQ@mail.gmail.com>

On Wed, Apr 30, 2025 at 10:28:57PM +0530, Naresh Kamboju wrote:
> On Tue, 29 Apr 2025 at 22:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.26 release.
> > There are 280 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Regressions on s390 build regressions with defconfig with gcc-13/8 and
> clang-20/clang-nightly on the stable-rc 6.12.26-rc1.
> 
> * s390, build
>   - clang-20-defconfig
>   - clang-nightly-defconfig
>   - clang-nightly-lkftconfig-hardening
>   - clang-nightly-lkftconfig-lto-full
>   - clang-nightly-lkftconfig-lto-thing
>   - gcc-13-allmodconfig
>   - gcc-13-defconfig
>   - gcc-13-lkftconfig-hardening
>   - gcc-8-defconfig-fe40093d
>   - gcc-8-lkftconfig-hardening
>   - korg-clang-20-lkftconfig-hardening
>   - korg-clang-20-lkftconfig-lto-full
>   - korg-clang-20-lkftconfig-lto-thing

Offending commit now dropped, thanks.

greg k-h
