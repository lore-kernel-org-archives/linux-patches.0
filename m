Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3E9320F
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 05:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741671181; cv=none; b=LngBppmkSuhmENYU/ROt9MUPssf4tmbnc1eSCXMo1RgILGq4xq1ejtxfXNTnLz6v9m6DpgpnhV0mkRUZMmQa2a2jNwZR1bQe3NRpMlWBr+hIakiv7Nff5FrmkOcYsOmkPYM0h4Rscu0Ok1bT5z44CF5I3XZ/MoRZOkePqHYm2Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741671181; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYd7ERHqSle/0dj0VozMusbOffpNMPr4H73x7WR+9vHhutzOxdcgMrDYD14JXINqdCUqnB05iS/0yjk/esb4a8NzB+t2JBZ+//5yRPePRlUloxDn4pRZvK6CZDd4W1Z8ECNCMphC0j1n1lG6hpim57ozjILx/oXhMKy/B4Cr5/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=WX/zuHV1; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="WX/zuHV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741671163; x=1742275963; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WX/zuHV1O3vXsHGxeNFX3Gt7RQv69DhQx/5lRM/HDol9otPBXQFgimwkp8RyK1c4
	 yY04ClikGE5TKyNdmcKd9X/aUrQdbxODD8WS2f2Hfx4ZK+XIsZ0E87gVEjT3D0QxW
	 7Rot/FnWXH7B1uM90b8U/Bg5fMQa0faWxoRyYOp6zfBGVLyCO2XYn8fLkJc5E6AHX
	 ywRC0F2Kdmrz0M1fByOOztYfiLaoYc+C/naL33bH5HLOhWbf976jX4/Ej2MPJnfhN
	 J1SKH4s3VsIFcY5qPA0MbxKp9TJxFmF+2gbNdP7eD6KLbnO94paz+AoESmCqLxinN
	 GbtYVdJDNAyPFDWrHg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.160]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MhlGq-1tMxFz0lFo-00gUm5; Tue, 11
 Mar 2025 06:32:43 +0100
Message-ID: <c7a12b21-56e3-451e-82a4-2fab8466fa2e@gmx.de>
Date: Tue, 11 Mar 2025 06:32:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170447.729440535@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:e/+fAeIthUFrCiS8rIf1k0Op/NvcWJlw/balAxubc+c6YW6rb5A
 VQoxtG/0NwlCiBmIGLrgkL0mz8+6zrB3rQ4JBgg09Pbe+vcJgJMFjFNnlWz99kj3afNgi/Z
 h16Vg6xLji+munHfgw0n2AnGzg8JJNTV4DmSDjbIoWybF1lWa0fMkMh3QckWWwbW/s5GCNJ
 +ohrPddTFBlh7OUUlMSyg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xjY6WPyGQXk=;alCr/hPyla8pTh3wuXMwBCJF8E9
 BIkeiL4FZi9u7qhsI664r8ir6N/6XTJM14emZJT20VTNWKRtt6ugTP/ZFxcsbmY3rA2EnAQ0R
 gJSHgr6RKuoe3m1VupftP0n5J1bNxX1HmhEo5W+TL1vuNzv7g/oi0TQtdKs0niKk6NBmLEiCo
 cgtXGJTt7dP8nqpIm6qRJ+nH/UqmBCi6EcsT9STMUvZgh0Fm/L3Yp7Ybtb4mB0KQVO3wTJikY
 avHQyCO5dtFKanLFqgM0SF8cs3ntZc519MntJyhBzmDnike8nJByQdYXIEnZAAVDju7/4XJDv
 DroE83A+CM1OJIWIPkvCP+Xm/cdbOAe2O5tc3+66JYc6sFCZBOj77NaV/jxj4XVce7vpvvJ6N
 JGIrvmN86xCz7nD9olkXrW+oW1p+bVGK9tu4M6ilnm+iaqOy0JgtYkyDxzd5wHLGnIfPxNyud
 XFGo74pIBgw00LCeHFCRKWnsa7cI/IuLnOCOeJze9HgxyyttPZ48/XTZEt9AENpokyNG/QQxn
 dnpjZdXbPU8XvwrRyQ8NhdxF+cXNYQwFly5arKvK+LbL9Z9qdThmPX6u9S3E07B+e5G51LTqa
 aVxD9jK9yKPYOF5ovQHAyAK7yFCOfn4La+BizM/XxSnqDBGgo0deM4KuyI5qdEcsyElSFNpHV
 qLEd9pdU9CbPZZQ/obgnsX2wORaMw2Dd16aIH2Sc5OBPvc55NDHhXbT/1QIQY/iYhbYHPtAvs
 JfWBVyM4nUPNL7E9g8Yfx8qsSQcV7K+2Hw4lrpumcsRboqxFjxGy6j/7v6jGavRcpKHw36QiY
 +Mvr8joPDx3NrZQNdiNKSPl6JKl9CxA8IpQQM7W+oEvsi2rEuMLvUIzgN32D4/VKo/pBNzFdr
 O4wKZDujpdArMYxtoxOi5U+YSABA+sxjjxJuibPqNPgqtewdiNEFk5W+UHVZCiuSolbK+g6XE
 LTrDWGcUYCStnShJF3dC84UFazCB/v8ALVU2ud5OsSCCnqOmwzusypR0p8Rer7pZf7vDOkR8s
 Sk0kivHBZQndn2hekWbKag7cX2fz1j8GGCLb/TIPKlIH4s8eMCXPoQOoieTcU6IjD6NURlc/m
 eduAwCBvU2HadHBy3BuiWDd1ED2JJ8adh8KxNvnebL+GOkLM5zicCFE9AysNuEHTaTE+TqVQ1
 75BVZTIh/K3598aESdosUP59WTeDH/dXWoqcqUcddze8E/xIHXY1S5c+Fi2foxlaqCffHF1xj
 7LT5/eoYRvLv0N5xS2UcRFyy1uo0BchO/EQ1czMuyBQVyPLjdOvGR5MxQTwopKfluzrE5vEB5
 eemZNsr90O8WH0AOPIC/fHx5RsSPO5jed1FYfX/Qx4HMMIa4b7/JUhF3nUiPcZ+/ICYR/UOPY
 C1lKUQfwsRo0WfFGUXE/Yhd5WIpTsFkSKmEQRVVeB0mzfUOhxrH/KOizVE

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
