Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB2E7404E
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 03:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742961384; cv=none; b=HjOObeE56AfIfnHYqhwov2195kaUjVmNEIsvk5yijOUs9qAYhruu+eny5EeVKGtj2c7lC1IsH7wOSXXDXMQKYTnMw5KpBGJaCRmGduxf4VvKa8hA2T9wYxo1vtaIF3X4qx42hv/oL09I4+x4saysyI1EqciVvnfVFY9RaST2ws8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742961384; c=relaxed/simple;
	bh=+O2A9chS/1wTC85HFYpesN54/BZmDe/Tqj0qtjyvUZ4=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=XWbm3/dPKVuk6Jub6q+5+q5DmNw2Fw+/yKiTWb1SU7o/tMIqpTwYx6YmZFNenQd4S0pD0fWqpu7Y1mXCt1XD/fQmm3qx4a6FqiOZ+Ui4YyNi1tr1pcJda6jFNsFA6T9NrGpGYegCByiVeNy+G+XmJbHZCEhRzAJjyBrivTwNw8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=OAiNj59+; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="OAiNj59+"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1742961379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LKgr9Fda0YEeh31KEQLQz04mnWC+XCuaxrZ++kXP29s=;
	b=OAiNj59+EQHdC7NaNnt5ec9YbC1cBKrGf+TatdLJckaV8yS31QzFpZdf5/YqdMZZViYl4s
	70jwtbSF1DGLsfTQWGqmv05vyU6yv75iWGB4ceY1DGsouNuqOj56k7fHK1oFHVTNLe2DxY
	A1MJWm3TUliV7en8MmQwruaytxX9QknwK0JbiDTU2nFVgRt6t7kQGv9Q1xQltZj6vRf9qj
	LfltuUnlHIAO6syJ7iWURpHgQQvqtTYS6w1RSM+5zA8tomb6Wgrr6+Tancy1cPMaBMjyHX
	CPSPB+Ob7mg2JCo6QU7Px7uH8JZFVeJR7GI21RhwIV9QhMKzG50YFMu2oSR5zA==
Date: Wed, 26 Mar 2025 04:56:18 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
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
In-Reply-To: <751cf2c6-c692-4595-98e9-fa3ae4dfd10a@oracle.com>
References: <20250325122144.259256924@linuxfoundation.org>
 <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
 <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
 <751cf2c6-c692-4595-98e9-fa3ae4dfd10a@oracle.com>
Message-ID: <0001e7e020145983055d154488f5c460@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Harshit and Greg,

On 2025-03-26 03:33, Harshit Mogalapalli wrote:
> On 25/03/25 21:37, Dragan Simic wrote:
>> On 2025-03-25 16:07, Naresh Kamboju wrote:
> ...
>>> Build regression: arm64 dtb rockchip non-existent node or label 
>>> "vcca_0v9"
>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>> 
>>> ## Build log
>>> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
>>> (phandle_references):
>>> /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
>>> 
>>>   also defined at arch/arm64/boot/dts/rockchip/rk3399- 
>>> rockpro64.dtsi:659.8-669.3
> ...
>> 
>> This is caused by another patch from the original series failing
>> to apply due to some bulk regulator renaming.  I'll send backported
>> version of that patch soon, which should make everything fine.
> 
> On ARM configs, we do see the same issue that Naresh reported.
> 
> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> (phandle_references): /pcie@f8000000: Reference to non-existent node
> or label "vcca_0v9"
>  also defined at 
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[3]: *** [scripts/Makefile.lib:423:
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2
> make[3]: *** Waiting for unfinished jobs....
> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> (phandle_references): /pcie@f8000000: Reference to non-existent node
> or label "vcca_0v9"
>  also defined at 
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[3]: *** [scripts/Makefile.lib:423:
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtb] Error 2
> make[2]: *** [scripts/Makefile.build:480: arch/arm64/boot/dts/rockchip] 
> Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> Caused by commit: 1e4bd0ec5a47 ("arm64: dts: rockchip: Add missing
> PCIe supplies to RockPro64 board dtsi") -- PATCH 42/77 of this series.
> 
> We see same problem with 6.12.21-rc1 as well.
> 
> Notes:
> -----
> I think Dragan was referring to upstream commit: bd1c959f37f3 ("arm64:
> dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi") which
> will fix this problem but fails to apply due to regulator renaming in
> commit: 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames
> to preferred form") which is not in stable kernels(6.6.y and 6.12.y)

Exactly, the direct dependency is the commit bd1c959f37f3 ("arm64:
dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi"),
for which I haven't sent the backported version yet.

As Diederik pointed it out already in a separate message [*] from
a couple of days ago, it might be the best to include the commit
5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames to
preferred form") into stable kernels as well.

Obviously, including the commit 5c96e6330197 pretty much goes
against the rules of stable kernels, but it would save a lot of
time and effort in the future.

[*] https://lore.kernel.org/stable/D8ONE4WEF7A2.1OE1YY8J34MM3@cknow.org/
