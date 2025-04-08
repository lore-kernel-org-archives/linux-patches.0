Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81832253B2;
	Tue,  8 Apr 2025 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125333; cv=none; b=I+Vwer5sSoGr2Fpkg3mLjVo6ZntQVA5Veer9fTik6zf67JVIXk7XRpK0Nmkzf5qVEW46OK8HzJ9bOXiRlQkNtfjvul5iockGrhYnuicK0VUEPOYjRXhAo7TEoI8E7FS2nzZxxrKZ9D+R9w4/9bKReRNfbl9RxLK+PvzuvYRJ4Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125333; c=relaxed/simple;
	bh=cYTW/Pf9eWDsCCS0jTr1NuQ13SdwxtZf5mlHOzMjv/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao2iJ0XP1HDYxsFKnH4tLta2RzslCLTT0fSdO6jNA0JVHOTY8Ykfj9JuShmINE3vSeR14yoY0b+5ScxUPqglPlfpTDf7AIsEtUDWc+VhSQCWkkFsHF9qSwU6MuP6EMh4yCerR9PPpw4I1fqXSR0NLG0BMHxnQ7/g5FxrxDw7/XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCMaN83N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCMaN83N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50222C4CEE5;
	Tue,  8 Apr 2025 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125333;
	bh=cYTW/Pf9eWDsCCS0jTr1NuQ13SdwxtZf5mlHOzMjv/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bCMaN83N32TTtMXDBTckEgGwkY2LGPC1y17I+THodayKdQ3trIAfuch5dFszCbjjt
	 nwkM8cD6AVDzqVIxKnwxcrvYvYbk/USN4njIuxfYMeVvVvhIT/nT6LDRD+XNUnYwQC
	 YF3Kd1kILKVmFxMGPJerwYVSPmuxQa/iRjR2wr98=
Date: Tue, 8 Apr 2025 17:13:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>,
	Dragan Simic <dsimic@manjaro.org>
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc1 review
Message-ID: <2025040831-buffoon-recopy-bca1@gregkh>
References: <20250408104845.675475678@linuxfoundation.org>
 <683b5bda-0440-43d0-b922-f088f2482911@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <683b5bda-0440-43d0-b922-f088f2482911@oracle.com>

On Tue, Apr 08, 2025 at 06:35:55PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 08/04/25 16:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.23 release.
> > There are 423 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> > Anything received after that time might be too late.
> > 
> 
> We are seeing the same build issue that we have seen in 6.12.22-rc1 testing
> --> then you dropped the culprit patch.
> 
> I think we should do the same now as well.
> 
> arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR
> (phandle_references): /pcie@f8000000: Reference to non-existent node or
> label "vcca_0v9"
>   also defined at
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR
> (phandle_references): /pcie@f8000000: Reference to non-existent node or
> label "vcca_0v9"
>   also defined at
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[3]: *** [scripts/Makefile.dtbs:131:
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2
> make[3]: *** Waiting for unfinished jobs....
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[3]: *** [scripts/Makefile.dtbs:131:
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtb] Error 2
> make[2]: *** [scripts/Makefile.build:478: arch/arm64/boot/dts/rockchip]
> Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [/builddir/build/BUILD/kernel-6.12.23/linux-6.12.23-master.20250408.el9.rc1/Makefile:1414:
> dtbs] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 
> 
> Dragan Simic <dsimic@manjaro.org>
>     arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board dtsi
> 
> 
> PATCH 354 in this series.

Ugh, that slipped back in here and for 6.13.y, I'll go drop it from both
and push out new -rc2 versions later tonight.

thanks,

greg k-h
