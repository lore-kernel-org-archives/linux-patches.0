Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A413932D0
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789250781; cv=none; b=Fu6QEhxqrogKQj0ciGBWMMJVa3oSIcSvcqGtS7k1pEkMPSqikQrUkk8qwqzNwPAueDS1IZ/CqJOvHrGeYqSTrZQTMwvpWWswKydyAF8zJ3CbVSbuXWq/KORVurO2BqvXM/fIBjZjgGP6cL92lJDbM5YS7t1ZzaoAhUypl6irKpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789250781; c=relaxed/simple;
	bh=lQIhg60H3bu3SYlDaMceEA+s42Je7buGnpMKC43nVaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WLDs2/FlxjOSFG5RVsTxR904aUAaiZgcSlEZqyq4aKiLfEYObZhspq/1V8lp4FAXjGt46bz8nf8PBLiZG3YTOzZCL7qhsLVeanrJdBbtG3JpnGtQ2aOMMwwtNXlUEyp3UL0foxpoyH4Htcq7ffNeT7Ey5TdkX2l5ZZoV9sKf02s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WRo2BwZ8; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WRo2BwZ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789250744;
	bh=bK3SHPytoMltHJRz+d8bS9oWm8DhW6FF6gHXnP39+cg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WRo2BwZ8y5lGq6/tigGsqx5X9hLO0VIZLbMLyJbWTWF/wbOzItjmf5NDcmaAiy+zp
	 MQMDvEO+rKs5c5vN2pNFEvhIC+1f8VYnW4P/XaEDen6At/G0KHOcsZoZM3xG2qqB4n
	 4qCUJvNKIPAPbw7CmwXeZ2YBVmcc5kzzZ470sAog=
X-QQ-mid: esmtpsz11t1789250735td833b7f5
X-QQ-Originating-IP: o3ewcjbyXFuaKthMVzT/fhqw/sdkORJwglzixg/JK58=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 13 Sep 2026 06:05:32 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10090393401742919414
From: Wentao Guan <guanwentao@uniontech.com>
To: pschneider1968@googlemail.com
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
Date: Sun, 13 Sep 2026 06:05:31 +0800
Message-Id: <20260912220531.858986-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ef6ea817-371a-4038-a73d-274fece32f4b@googlemail.com>
References: <ef6ea817-371a-4038-a73d-274fece32f4b@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MB78LT3tbKTeZu2lvEg9Jbw+2TPLXnzOijsSkcwdyMHrPARdkXC4pM4m
	ofwvkWGBimZRS6s8yPg7ZDbPSghITmR2h1UPJ/W/GnaVKeaMQHRYgwhYxoTRKkJrv3UcR2O
	t79MQ3xFx/0VOA7c/kb33hbxqI6Eb7sZepIuw+KzJVc+mKecuoHNnncyxZuzgh8974mx5+s
	Hj0kGHiPoSkV4EzEMczLfrSYEooKvkysJML0ELHn9bOI/jD523a/zCuzf0mPhscchbABkPC
	Vr3u+MtL3GtQ0ERXIWtkYAAJsLuI0HX+yBSXLlwpGuSVkArjWvqPyN3XW1izSAvEA9zdxzc
	e2u44Cp+HoM7jxDlc2MegkuyJ4Hc+cqN6/DY47j06gz/RUuOr87cJUw77wqRHWykihpyxV8
	zV2MFCUzpo2tWp5nLq6Twkt4oCtp3kx9LL2030Q1reVeXAi7mVw580O0/6fG4n+J+hTFmql
	d787k4QC/x0knyhrhRQzCBkPQzCJ7nIWFwGDQMcRFbFv2hnnlXZje1Q3yedssdK9VTsMEXX
	qvL5nP8vAFvJrzxoqI5y2WpXDvn33to3XpCkHoE+dTEIcEyIN6QUaHoNKR6uMQpzFZwrlMm
	JFeRNMTFa3BSc3LI/KpZY4Uim6nvaI3TXnd8G0sa6BZifHajfjFvjORbZR3Iq4ZWfJEnvIn
	HlvqlPpGKc8LWrnBXV6SwVlf+OBKuIAcWdHH7bu3hp3ON5bX3O0oaQ/L/g9v1lEVH+78EDi
	4PBNb1ubBrIKVOvgobYNB4oFllYNhmFnd3nqALy/urhiir+RrHKnOQqg1cb99UU6wtBxgGm
	jMIgM7eHgbBuK4++mrXQq4OXB4zuRX9hoi/XAB/KKJRv4R9OBvsJHsLG0MzyKmWwwstpTcZ
	r8jgqP/UpqcD2/jErwBcv5+c3Yb1b/IlWLNCnWLeIqJ13ANlRR8wOiF6LRiNPeOEEq7n9d2
	VuQki9KX4j+4e9VstZZDpDuVfQ/eOJqnfYUE4m4lcVDPbQH3rZA4fkm0hhWugNIG6tZNcJa
	+innnKcrD9QpJwh+Um7jiiRVBJxA6XWfEtS+4ZHnJsITsDP295GQySqDLerTeX+fLwM7cm2
	g==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Hi,

> Am 12.09.2026 um 08:36 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.18.52 release.
> > There are 1518 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Builds, boots and seems to works on my 2-socket Ivy Bridge Xeon E5-2697v2 server.
> However, I do see the same strange dmesg warnings that I see in 6.12.110-rc1:
> 
> [    2.397237] Driver 'sr' needs updating - please use bus_type methods
> ...
> [   84.031323] Driver 'ses' needs updating - please use bus_type methods
>
> And again, these warning are new in this rc, they did not appear in 6.18.51.

Thanks for your report, i see the warning is related to the commit series:
("scsi: core: sysfs: Make use of bus callbacks")
... As it message describe ...
    .probe(), .remove() and .shutdown() to eventually remove these. Until
    all SCSI drivers are converted, this results in a runtime warning about
    the drivers needing an update because there is a bus probe function and
    a driver probe function. The in-tree drivers are fixed by the following
    commits.
...

Best Regards
Wentao Guan

