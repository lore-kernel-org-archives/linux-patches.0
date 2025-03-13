Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB1935944;
	Thu, 13 Mar 2025 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741874828; cv=none; b=KX2TvcLaDHJfuLPOb/9/g50RyZpfCyaRQYImA9TBUFWTv2GqtcIN3D+dOQKlSEzer50qYWej+Haz/LEyVd8anqHPjqowtSCHmYMpkFJb3V9jSoUkbKXf2Q5dMU7zFdtBR3eyvPC2mWqWG9mlsFiXtgoslGcievO15Fih090Vpzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741874828; c=relaxed/simple;
	bh=VK6IFCnWqH1VDlX+0nZlauCvGg9qfSZhNL8pqBhu234=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaGdf5SMYgzBYphJMsGRva/vmq/07chLubTHc3uGdzVgOGnnpLwpA8ldpN7G/Cl0kS4W9wDf2J6r9hm48d6MOkZP8AvU/XbhVBTBlNM6bHsq/uki1i/qgIkIp8b6RmGggDY21EftoJ1nD/N1ZNpVHMDWidjrrRWnLhq2R0xfHmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/o9KKF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/o9KKF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D06BC4CEDD;
	Thu, 13 Mar 2025 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741874828;
	bh=VK6IFCnWqH1VDlX+0nZlauCvGg9qfSZhNL8pqBhu234=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=y/o9KKF7FXQqvvJPN+f0dQLbgHndsHqQzyH2jNJvjBTBRNH3KdqJmnhpzyGQOIf9W
	 JQGxlaNON20Krw4IYTxGgm/2R85Jr/xLJnBf1KGOOGUVfS27hU7Cdkp/mBmF2TWk42
	 5+2JDQfluXXZ2rMvoirVsCp2tGJhafCrsqdGIQ+0=
Date: Thu, 13 Mar 2025 15:07:05 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/328] 5.4.291-rc1 review
Message-ID: <2025031359-unsmooth-greasily-5c8e@gregkh>
References: <20250311145714.865727435@linuxfoundation.org>
 <CA+G9fYtG9K8ywO4w2ys=UEuD_r1LgOuZhG4cg62YKAX0qK35cg@mail.gmail.com>
 <603b3f10-6ad9-46af-8b31-d11e46f4698a@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <603b3f10-6ad9-46af-8b31-d11e46f4698a@gmail.com>

On Thu, Mar 13, 2025 at 06:59:24AM -0700, Florian Fainelli wrote:
> 
> 
> On 3/13/2025 12:19 AM, Naresh Kamboju wrote:
> > On Tue, 11 Mar 2025 at 20:33, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 5.4.291 release.
> > > There are 328 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> > 
> > Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > NOTE:
> > The following build errors noticed on arm, arm64 and x86 builds
> > net/ipv4/udp.c: In function 'udp_send_skb':
> > include/linux/kernel.h:843:43: warning: comparison of distinct pointer
> > types lacks a cast
> >    843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> >        |                                           ^~
> >   Link:
> >    - ttps://storage.tuxsuite.com/public/linaro/anders/builds/2uDcpdUQnEV7etYkHnVyp963joS/
> 
> Yep, this is seen with net/ipv6/udp.c for the same reasons, see my comment
> here:
> 
> https://lore.kernel.org/all/0f5c904f-e9e3-405f-a54d-d81d56dc797e@gmail.com/

Should now be fixed.
