Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB22AD22;
	Sun,  6 Jul 2025 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751784935; cv=none; b=bLt3Ne4DPEgch7bbpB3+5CFhTm8McHIq9T1JLGhiqHTOOehg/YvQHz3Wv6DzhEWHlgRimFFMhSmr22MNmWCnnHMZrwJvc/wRA7kDMOo4iBeGPnKdH/tDjodidcc7Q9NGGJa5v95ITdfghz4hBHUlkqaUcTOxLa674nu1yX4jXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751784935; c=relaxed/simple;
	bh=X+pGXLjSOw2kkUC3ASavFHuNKGcsrgfPvxkh97mWYO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfHM+N3NzruF3Ji4ZwlKsqxwOzTiHsnGB+TvOwqDHXeD9MLIkxEMwqOY79lKx1slNAPOMQEFwdmJEUE3Du10gRaxrGDXsi6KiFsF98Y6evxv3SzTZ8QUi+97JCDzI/BsRZjFNoScjGF3V8zKLFqswec9VASI5PBmicdXaNGHwZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrUyzb9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrUyzb9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F7FC4CEED;
	Sun,  6 Jul 2025 06:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751784935;
	bh=X+pGXLjSOw2kkUC3ASavFHuNKGcsrgfPvxkh97mWYO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WrUyzb9i8H6J7JuqQwIhqq+1exw7IL41SeNrCBWi6B8tMVCJZ/sMbZLdELsbhnOGa
	 CitJJUK4XVGF9mG7R5P2zRaUJSdRlEJL2HqU3aEBy9LTYD6QP+Dp7ToJdzN8sh44Qe
	 eCk0Ue79XAM7iMBFUMdkyrb5xkMjIeocor1GoPWc=
Date: Sun, 6 Jul 2025 08:55:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
Message-ID: <2025070605-stuffy-pointy-fd64@gregkh>
References: <20250703143941.182414597@linuxfoundation.org>
 <CA+G9fYu=JdHJdZo0aO+kK-TBNMv3dy-cLyO7KF4RMB20KyDuAg@mail.gmail.com>
 <CA+G9fYv4UUmNpoJ77q7F5K20XGiNcO+ZfOzYNLQ=h7S3uTEc8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv4UUmNpoJ77q7F5K20XGiNcO+ZfOzYNLQ=h7S3uTEc8g@mail.gmail.com>

On Sat, Jul 05, 2025 at 08:42:49AM +0530, Naresh Kamboju wrote:
> On Fri, 4 Jul 2025 at 18:55, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 3 Jul 2025 at 20:42, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.96 release.
> > > There are 139 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The following build errors were noticed on arm with gcc-13 and clang-20 on
> > the stable-rc 6.6.96-rc1.
> >
> > Test environments:
> > - arm
> >
> > Regression Analysis:
> > - New regression? Yes
> > - Reproducibility? Yes
> >
> > Test regression: 6.6.96-rc1: coresight-core.c error implicit
> > declaration of function 'FIELD_GET'
> >
> 
> Bisection results pointing to,
> 
>     coresight: Only check bottom two claim bits
>      [ Upstream commit a4e65842e1142aa18ef36113fbd81d614eaefe5a ]
> 
> The following patch needs to be back ported ?
>    b36e78b216e6 ("ARM: 9354/1: ptrace: Use bitfield helpers")

Thanks, that makes sense, and is easier than me fixing this up by hand
like I had tried to in one of the branches :)

Now queued up.

greg k-h
