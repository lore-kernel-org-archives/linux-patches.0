Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996AB1C8627
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 07:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743059546; cv=none; b=Ge7WWKVAlQs5LG14z39gby6faF0ID2kufglbX0d7rAQ3hAGNcOAXPrCCJP8/y2LcCvp/Ku7xHIhwKk9eI5eNLMwywt1T/qiLVlp8i837F89Wu3YvN4bEMeZfDp/I0ED4TrePPxJSAh5XKVAT/c5PClmSlDgTuJ8bw4v0Ub4RjbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743059546; c=relaxed/simple;
	bh=xLDxqFPTSPn0/knZPERzvm0+bXSKlxaYfylULmtrafg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=RjfHE96IPnshf6hhb+ZtAAsM5Ma7vJsXTe8HXoYiXGkTZ99EDigqS5ckNt36xFDJLJ3/GWADVJMa1/RDt3D4PSDqN3SUjNxwYNpkDWqsMmjwlXy051It+bqoPGcVqb0RiU2qmnuDCDZzZnV1LeV9dc9xN1SnOVvpjYlwpIQgoZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=h8AErXRy; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="h8AErXRy"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1743059536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lH20vJ48RSA10XECX0SWG627PAsPjNVOUl91E9dSA10=;
	b=h8AErXRy2tf++eIitSzH4Z7avDyXJ3XY5svwpL8omEiu/+RugNoAOmQgoAcvtxJuq2K3lF
	OBL7yNp5z2S8UrU2xL3P/dwwPZ+z2tjk/FL5wYznfPEuLNF7EXHBeoNJV8+tdlqKW8Bysu
	A/h8o7mVuanCMIOBx4cAJCCNpxAybAPPM/CJ3gE0Dw31mk75lBGlhtbg7J9tMANBPyuwHI
	HmMVM/OIxMoeQoOc0MfCW/ho1u82D1qIw8Uw03DHGmPjBsRLHLDDquUAjboVscVmAKjsgv
	eW/Y0hHCT9n8ETLIsGgsnV9HG4X25LpUQs7NAaHZTFDN+v7rAdLXnkg2C6k71w==
Date: Thu, 27 Mar 2025 08:12:14 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Naresh Kamboju
 <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Heiko Stuebner <heiko@sntech.de>, Vegard Nossum <vegard.nossum@oracle.com>,
 Darren Kenny <darren.kenny@oracle.com>, Diederik de Haas
 <didi.debian@cknow.org>
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
In-Reply-To: <2025032656-closure-exile-38fe@gregkh>
References: <20250325122144.259256924@linuxfoundation.org>
 <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
 <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
 <751cf2c6-c692-4595-98e9-fa3ae4dfd10a@oracle.com>
 <0001e7e020145983055d154488f5c460@manjaro.org>
 <2025032656-closure-exile-38fe@gregkh>
Message-ID: <6a8a77a00a11ae9c22b1a2fe50cbbb34@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Greg,

On 2025-03-26 16:38, Greg Kroah-Hartman wrote:
> On Wed, Mar 26, 2025 at 04:56:18AM +0100, Dragan Simic wrote:
>> On 2025-03-26 03:33, Harshit Mogalapalli wrote:
>> > On 25/03/25 21:37, Dragan Simic wrote:
>> > > On 2025-03-25 16:07, Naresh Kamboju wrote:
>> > ...
>> > > > Build regression: arm64 dtb rockchip non-existent node or label
>> > > > "vcca_0v9"
>> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>> > > >
>> > > > ## Build log
>> > > > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
>> > > > (phandle_references):
>> > > > /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
>> > > >
>> > > >   also defined at arch/arm64/boot/dts/rockchip/rk3399-
>> > > > rockpro64.dtsi:659.8-669.3
>> > ...
>> > >
>> > > This is caused by another patch from the original series failing
>> > > to apply due to some bulk regulator renaming.  I'll send backported
>> > > version of that patch soon, which should make everything fine.
>> >
>> > On ARM configs, we do see the same issue that Naresh reported.
>> >
>> > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
>> > (phandle_references): /pcie@f8000000: Reference to non-existent node
>> > or label "vcca_0v9"
>> >  also defined at
>> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
>> > ERROR: Input tree has errors, aborting (use -f to force output)
>> > make[3]: *** [scripts/Makefile.lib:423:
>> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2
>> > make[3]: *** Waiting for unfinished jobs....
>> > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
>> > (phandle_references): /pcie@f8000000: Reference to non-existent node
>> > or label "vcca_0v9"
>> >  also defined at
>> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
>> > ERROR: Input tree has errors, aborting (use -f to force output)
>> > make[3]: *** [scripts/Makefile.lib:423:
>> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtb] Error 2
>> > make[2]: *** [scripts/Makefile.build:480: arch/arm64/boot/dts/rockchip]
>> > Error 2
>> > make[2]: *** Waiting for unfinished jobs....
>> >
>> > Caused by commit: 1e4bd0ec5a47 ("arm64: dts: rockchip: Add missing
>> > PCIe supplies to RockPro64 board dtsi") -- PATCH 42/77 of this series.
>> >
>> > We see same problem with 6.12.21-rc1 as well.
>> >
>> > Notes:
>> > -----
>> > I think Dragan was referring to upstream commit: bd1c959f37f3 ("arm64:
>> > dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi") which
>> > will fix this problem but fails to apply due to regulator renaming in
>> > commit: 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames
>> > to preferred form") which is not in stable kernels(6.6.y and 6.12.y)
>> 
>> Exactly, the direct dependency is the commit bd1c959f37f3 ("arm64:
>> dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi"),
>> for which I haven't sent the backported version yet.
>> 
>> As Diederik pointed it out already in a separate message [*] from
>> a couple of days ago, it might be the best to include the commit
>> 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames to
>> preferred form") into stable kernels as well.
>> 
>> Obviously, including the commit 5c96e6330197 pretty much goes
>> against the rules of stable kernels, but it would save a lot of
>> time and effort in the future.
>> 
>> [*] 
>> https://lore.kernel.org/stable/D8ONE4WEF7A2.1OE1YY8J34MM3@cknow.org/
> 
> As that's a big change, and no one seems to be sending it to me for
> inclusion, I'll just go drop the patch that broke the builds for now 
> and
> wait for someone to send working ones later.

Makes sense to me, thanks.  I'll send you the three patches (i.e., the
bulk regulator renaming patch, and the two RockPro64 patches) that need
to be included in the stable kernels, in the next couple of days.  
Having
the bulk regulator renaming patch included in the stable kernels should
save us a lot of time and effort in the future.

I would've sent you those patches earlier, but I'm currently in a really
tight spot when it comes to time.
