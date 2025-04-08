Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AE726ACB
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118486; cv=none; b=cCQLfLIzIHqaD4uZqibkVL9U6S7BNmnV4X5Cy+CXDWcDRYnZWTNlWevb06VrVPIU0AcKmnum5OiVfSnzIJwbJoY9pYpKCWASIUWuSnzqPVTQkqG3odbpYuGMfSCDnbRryl22RWAjHXQkRZhHce5BO1BOQJRBQL+JdgyUd+dR//4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118486; c=relaxed/simple;
	bh=dXVtbiqQNGAxyvyND239vsV0CG+r4ci5k74Ehhk+X9Q=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=AzzvEzZBZH0f/sQZk9VimhfDMb6xKYY97E/+bDN9bzebuQxBbrG6oEPzeYOT42F2+8dvfUOUu44zXKZ2frTQDqhl+nlKpo3UZGtXn18krat24dH1oKjJKExOSv2vGdzAyJ0wbmbfVBV8mb7Mu683ikd77o9aI4gWAK49gsoYMcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=bcGOSiQv; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="bcGOSiQv"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1744117896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ9wOyhr5OZ2W7fMi198N8FcLIDJcoQtgXpXVI7uRjc=;
	b=bcGOSiQvDs5OztA7ea6FCwv2yZ6wetx4v0TR4WyQcediA0B5FhCBWOnSR/VfG7w6jMcXwJ
	Si1a8MDmQuii4lQvD2LMOV4o85kAXrq17NYCeJcgX8HdvM2KYDS7SXVjqHWEY8k4wFWTGA
	VureHTRYmRCe4qVcT3hTfXI5oB8wYdCP7J1IJc/sF3hmv3cVmTrxmTZHBQrsuu/QMIjPtt
	ovW7yriiDYaemXsYuKHwr/mr79QQ86uLG4S+2nmg76jVujMrbub8WB+pXKzaiE5EJWhZce
	qT+JEFI8adS50CG9HUEDeb7tz9IpiqPyDO69pERymnTU7DSZuPtrtnbXV1DwMg==
Date: Tue, 08 Apr 2025 15:11:34 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Vegard Nossum <vegard.nossum@oracle.com>, Darren Kenny
 <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc1 review
In-Reply-To: <683b5bda-0440-43d0-b922-f088f2482911@oracle.com>
References: <20250408104845.675475678@linuxfoundation.org>
 <683b5bda-0440-43d0-b922-f088f2482911@oracle.com>
Message-ID: <e9f371830fc38a5ebe2cf7c1c66b0e44@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Harshit and Greg,

On 2025-04-08 15:05, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 08/04/25 16:15, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.23 release.
>> There are 423 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, 
>> please
>> let me know.
>> 
>> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
>> Anything received after that time might be too late.
>> 
> 
> We are seeing the same build issue that we have seen in 6.12.22-rc1
> testing --> then you dropped the culprit patch.
> 
> I think we should do the same now as well.
> 
> arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR
> (phandle_references): /pcie@f8000000: Reference to non-existent node
> or label "vcca_0v9"
>   also defined at 
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR
> (phandle_references): /pcie@f8000000: Reference to non-existent node
> or label "vcca_0v9"
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
> make[1]: ***
> [/builddir/build/BUILD/kernel-6.12.23/linux-6.12.23-master.20250408.el9.rc1/Makefile:1414:
> dtbs] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 
> 
> Dragan Simic <dsimic@manjaro.org>
>     arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board 
> dtsi
> 
> 
> PATCH 354 in this series.

Sorry, I've been insanely busy in the last couple of weeks, but I've
luckily got a small window opened up, which I'll use to finally send
the backported versions of the troublesome patch(es), or to submit
the bulk regulator naming cleanup patch to the stable kernels.

I still need to think a bit more about the possible approaches, to
choose one of the available options.

>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
>> patch-6.12.23-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-6.12.y
>> and the diffstat can be found below.
>> 
>> thanks,
>> 
>> greg k-h
