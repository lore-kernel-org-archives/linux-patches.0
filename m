Received: from fhigh1-smtp.messagingengine.com (fhigh1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A1B13BACE
	for <patches@lists.linux.dev>; Mon, 26 Aug 2024 13:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724678861; cv=none; b=qhKbr44d187ZMwde538o5gQSRJEFy16M7OAZ0c+rV9SaLoGDubKi5gegoiJDis6HUV47hXK9IiVKD1k7ro2DVk1CHBFYby142beaBLcYYXBrUnkBZ04+8CjfNXdaPd+olICA4JPNOVIEdI9PKKBURAuQdwUq0ZblavT9CM6VlkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724678861; c=relaxed/simple;
	bh=sxR9SLe26AMTomZMo/9FDo95TDcNF60oshP3lqoIOWc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=mhr0E5zW//JLTs855w0k/c3vc1HlU76Hcg8kglDZFAOVotAd26etRW9cU8T/7uALuVlnrkjCe+KpIoMoAEsxjt58ravlaESN+wgSYa3Adg6OdIiOwj36YlTr/ymabmNShG/gYSuKeS9885FN2HjEZDyC3fpkBT/iUC5mXWgU2ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=vTaFJEqs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K4JQDMhw; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="vTaFJEqs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K4JQDMhw"
Received: from phl-compute-05.internal (phl-compute-05.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id A87B11146FFD;
	Mon, 26 Aug 2024 09:27:38 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Mon, 26 Aug 2024 09:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1724678858;
	 x=1724765258; bh=OICaw6XdMAULOdvzlRj2FPocYRjHUILsmuI+DTazDjI=; b=
	vTaFJEqsRyFJDzsfuskKExxrw2EODwUTTeggZtD+Y91sdLgbvahSdeEnBbSoHoR/
	5pA3OI84qpDe/9wJgq+9RnzLsuefxxao/0yzXQqAz7bumjY1j/BzxaYTz3QFJroG
	f5nAu5MULbzak/V+/yX3NV6EPgLAffdTh1p0ANW9Lj5xNYjsDy/re3Ne2G209+NT
	rsbPhonaSXL4X74dBc9Xj0edfvl8X8ifcl18j5sRT6XrE1BcA/Qo+vd95OPk0Usm
	Rk/6qrnLUcSmpKpuGqx9exONiarMFo++Ug+3ccv2C2FrZDng1Z+Isu7VjAJ+W5m1
	IamChL/cb5bJIRyeeTbx0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1724678858; x=
	1724765258; bh=OICaw6XdMAULOdvzlRj2FPocYRjHUILsmuI+DTazDjI=; b=K
	4JQDMhwoS3JuNqDi8bvoHDt2nkH0dsHq57d3hy6uuOsuoDbVf1btfrjNIboALe9u
	MqgH22R/nez66agpbreMknakTtc32Pmq/+i1/cyGi9lTOWqhRkK004uwafM30TNr
	isDb3SjCspf/6GEqU5pT7EVRw5UDASFnQjVZ/AoE4kbO1LgVAuSdHKvMHDmyJ7Vc
	C+Kd6SWI8cDsC95ENN20svXZnSR5NbVCpK3nAxBXREluDf3LuF8EVVUwTpNHuL+C
	JF4aKiui4ePxtz4dq4h3kQPpq91nF5XdM+l0ndmi1YXXhFwEzZFCQKrvHIMQ8DUr
	lITaTkTHiinifABhWWd1Q==
X-ME-Sender: <xms:yYLMZulqGFkcESLYh7Z00tz1lIpXVKi3bj1EmjYPxvbxjm1u-bm8QQ>
    <xme:yYLMZl33NMQPu-HbDlg5wZLQ621eyPZ9WsFq_t8UAD2oXqAfSiquE740K8kdk-zYT
    QSbo87nBDiPaSLdVmI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddruddvkedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedflfhirgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfh
    hlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepjeehfeduvddtgffgvdffkeet
    hefhlefgvdevvdekuefffeekheehgeevhfevteejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgr
    thdrtghomhdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtshgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthht
    ohepphgrvhgvlhesuggvnhigrdguvgdprhgtphhtthhopegrlhhlvghnrdhlkhhmlhesgh
    hmrghilhdrtghomhdprhgtphhtthhopehfrdhfrghinhgvlhhlihesghhmrghilhdrtgho
    mhdprhgtphhtthhopehsuhguihhpmhdrmhhukhhhvghrjhgvvgesghhmrghilhdrtghomh
    dprhgtphhtthhopehrfigrrhhsohifsehgmhigrdguvgdprhgtphhtthhopegsrhhoohhn
    ihgvsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegtohhnohhrsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:yYLMZso458eEMQGirlSKgYunEugIPOgaxEeZh6KAWgZ9-O8XDmFmDg>
    <xmx:yYLMZikWlKVrDDUNMuHI4qkE7WaUIiRg6ik8H3Muj5LczDxBvIK8lw>
    <xmx:yYLMZs0JBsS1eF1hPEuo7Vho8PhXaDdpTG7lDF6N9kJan33ifadd8Q>
    <xmx:yYLMZpv2QjPFjZKfm650873xp9fYRFVPxHLUk3tWE3yr2VY1RpnZ6g>
    <xmx:yoLMZt4_58SRVWxxWcAakIUIDEXQO01DU7DidY8bv-m5aBHIlQnY-7Fz>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id C7BAD1C20064; Mon, 26 Aug 2024 09:27:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 26 Aug 2024 14:27:17 +0100
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Guenter Roeck" <linux@roeck-us.net>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 "Jonathan Hunter" <jonathanh@nvidia.com>,
 "Florian Fainelli" <f.fainelli@gmail.com>, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 broonie@kernel.org, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>
Message-Id: <eb7fda2e-e3c3-42cb-b477-91bcafe3088a@app.fastmail.com>
In-Reply-To: <135ef4fd-4fc9-40b4-b188-8e64946f47c4@roeck-us.net>
References: <20240817075228.220424500@linuxfoundation.org>
 <135ef4fd-4fc9-40b4-b188-8e64946f47c4@roeck-us.net>
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B48=E6=9C=8826=E6=97=A5=E5=85=AB=E6=9C=88 =E4=B8=8A=E5=
=8D=882:04=EF=BC=8CGuenter Roeck=E5=86=99=E9=81=93=EF=BC=9A
> On 8/17/24 01:00, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.165 release.
>> There are 479 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, plea=
se
>> let me know.
>>=20
>> Responses should be made by Mon, 19 Aug 2024 07:51:05 +0000.
>> Anything received after that time might be too late.
>>=20
> [ ... ]
>> Jiaxun Yang <jiaxun.yang@flygoat.com>
>>      MIPS: Loongson64: reset: Prioritise firmware service
>>=20
>
> This patch in v5.15.165 results in:

Thanks for reporting!

This patch should be reverted for 5.15 as the infra was not here and 5.15
is not intended to support platforms that may be impacted by this issue.

Thanks
- Jiaxun

>
> Building mips:loongson2k_defconfig ... failed
> --------------
> Error log:
> arch/mips/loongson64/reset.c:25:36: error: 'struct sys_off_data'=20
> declared inside parameter list will not be visible outside of this=20
> definition or declaration [-Werror]
>     25 | static int firmware_restart(struct sys_off_data *unusedd)
>        |                                    ^~~~~~~~~~~~
> arch/mips/loongson64/reset.c:34:37: error: 'struct sys_off_data'=20
> declared inside parameter list will not be visible outside of this=20
> definition or declaration [-Werror]
>     34 | static int firmware_poweroff(struct sys_off_data *unused)
>        |                                     ^~~~~~~~~~~~
> arch/mips/loongson64/reset.c: In function 'mips_reboot_setup':
> arch/mips/loongson64/reset.c:144:17: error: implicit declaration of=20
> function 'register_sys_off_handler'; did you mean=20
> 'register_restart_handler'? [-Werror=3Dimplicit-function-declaration]
>    144 |                 register_sys_off_handler(SYS_OFF_MODE_RESTART,
>        |                 ^~~~~~~~~~~~~~~~~~~~~~~~
>        |                 register_restart_handler
> arch/mips/loongson64/reset.c:144:42: error: 'SYS_OFF_MODE_RESTART'=20
> undeclared (first use in this function)
>    144 |                 register_sys_off_handler(SYS_OFF_MODE_RESTART,
>        |                                          ^~~~~~~~~~~~~~~~~~~~
> arch/mips/loongson64/reset.c:144:42: note: each undeclared identifier=20
> is reported only once for each function it appears in
> arch/mips/loongson64/reset.c:145:34: error: 'SYS_OFF_PRIO_FIRMWARE'=20
> undeclared (first use in this function)
>    145 |                                  SYS_OFF_PRIO_FIRMWARE,
>        |                                  ^~~~~~~~~~~~~~~~~~~~~
> arch/mips/loongson64/reset.c:150:42: error: 'SYS_OFF_MODE_POWER_OFF'=20
> undeclared (first use in this function); did you mean=20
> 'SYSTEM_POWER_OFF'?
>    150 |                =20
> register_sys_off_handler(SYS_OFF_MODE_POWER_OFF,
>        |                                          ^~~~~~~~~~~~~~~~~~~~=
~~
>        |                                          SYSTEM_POWER_OFF
>
> This is not entirely surprising since the missing functions and defines
> do not exist in v5.15.y.
>
> Guenter

--=20
- Jiaxun
