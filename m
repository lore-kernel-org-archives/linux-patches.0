Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10526ACF;
	Thu, 18 Jul 2024 06:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721285738; cv=none; b=atWbQopI25rwD5gv8DYWD08oUuyEmagbrVN/QGc1LHx+cDZ9z/7mW/UzZW5H36L6v5F2StLA573q9CpPu/0pLOL3HCFA3frpWV5DAXc+UXJ2w9X2bCYNTrZCphjDfxsweav4+lGQ6dYcPOSs3WCyqJXpWzcfEp8yVQayQDu5DjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721285738; c=relaxed/simple;
	bh=nFH7ut82unMgxgxSn/vjZJx5nU38HuR9Ig9R58XYFes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwbCSn/zTVbBV2Fghosd8MW+Rcq4kp5NJiSESpjqabHM2uv7jULwae/gpjyGim+/44Um3oG14XBB/VhuWlF/frFo+3++7Q8vwnfCXc6RMEwxSl/XnAxojZqLneqWJhLIUZbP0alo1ueluqJev1GvgLdvASDjqA0VNE+LynRCYlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOvEi3rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOvEi3rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE7DC116B1;
	Thu, 18 Jul 2024 06:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721285737;
	bh=nFH7ut82unMgxgxSn/vjZJx5nU38HuR9Ig9R58XYFes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOvEi3rPsQSihVZL3J7iTGBlF80v0KaMUv45OTE52xI5S0fgUgT/2Q6Tz0B5CAJKK
	 FYLAuRLnMQ0tcf5eDGzIIYs09RPSJNXzlEt70XZCuUFrPw1kHnCGqL75HcpiDTwREa
	 VRaTDpesmQarSklaXYrRI8O99QO7dXDF1bDxOUTA=
Date: Thu, 18 Jul 2024 08:55:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.10 000/109] 5.10.222-rc2 review
Message-ID: <2024071825-unifier-patriot-26c2@gregkh>
References: <20240717063758.061781150@linuxfoundation.org>
 <CA+G9fYtfAbfcQ9J9Hzq-e6yoBVG3t_iHZ=bS2eJbO_aiOcquXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtfAbfcQ9J9Hzq-e6yoBVG3t_iHZ=bS2eJbO_aiOcquXQ@mail.gmail.com>

On Thu, Jul 18, 2024 at 10:45:22AM +0530, Naresh Kamboju wrote:
> On Wed, 17 Jul 2024 at 12:09, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.222 release.
> > There are 109 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The QEMU arm64 booting kunit enabled boot failed with clang and gcc.
> 
> Anders bisected to this as first bad commit,
> # first bad commit: [c2ef31fd37ae11e89cb63c73cb7ee05bf4376455]
>             arm64/bpf: Remove 128MB limit for BPF JIT programs
>             commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.
> 
> Reverting the above patch made the boot successful on QEMU arm64.

Thanks, will go drop this now.

greg k-h
