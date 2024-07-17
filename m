Received: from smtpout34.security-mail.net (smtpout34.security-mail.net [85.31.212.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AFC17C64
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 19:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721243709; cv=fail; b=XZhIVbUFpifv8XDxo852gCf/c5MhorR0Xdc0u5cM4TSa/Jun0fHO6YMi0ODu8AJgiOnEGx0ftawNaMUecJHYtvExVYU2jvw+Zt/6Urc6xzWvo1ZLUVsYnI8NM6W6FdDsAluQpBRvHOjDZiJhN3fzLcyJtErUX2nswK0I69d31I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721243709; c=relaxed/simple;
	bh=QwWamtvJKU6/BIvC9UGTgxF9Yn22vu5hjZhC8/+ToTc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mbytQAXsFaz9vp3qZfeqJAi6xmbYQ9+YYVZcAr3k23xgTGAB3x18O7fNcgv8sWZjuzcOn1Tf3TUbQdxNuYyxAzETEnBZAgaEW3jliyiIf40R2to0/MNyx2pLOA1rFXFT5/vLPxPEHo7wF49N+WroCls4FBW9d6yjBRDADoNswOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=QC2YL+xB; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=DqvaUfyb reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="QC2YL+xB";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="DqvaUfyb"
Received: from localhost (localhost [127.0.0.1])
	by fx304.security-mail.net (Postfix) with ESMTP id 6799E419B2C
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 21:09:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1721243391;
	bh=QwWamtvJKU6/BIvC9UGTgxF9Yn22vu5hjZhC8/+ToTc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QC2YL+xBnR0e3yGHcQqgXeEdst62sS8qqrvN7i+aU6ahFUXeV5lPxR2mGTu4zk7hg
	 rrfByHmgr1h2ELnA4yWPLJJfqHT63pPC/KlUAzXcd+DOmPUs+ND1uYB0fztTluFx2E
	 Iz9yBRdNOy6LQSfA6e+yLbSXn8hyYHQ1VxGHsyX8=
Received: from fx304 (localhost [127.0.0.1]) by fx304.security-mail.net
 (Postfix) with ESMTP id 0A3C141993C; Wed, 17 Jul 2024 21:09:51 +0200 (CEST)
Received: from MRZP264CU002.outbound.protection.outlook.com
 (mail-francesouthazlp17010004.outbound.protection.outlook.com [40.93.69.4])
 by fx304.security-mail.net (Postfix) with ESMTPS id 6545D419270; Wed, 17 Jul
 2024 21:09:50 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PR1P264MB2247.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Wed, 17 Jul
 2024 19:09:49 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7784.013; Wed, 17 Jul
 2024 19:09:49 +0000
X-Secumail-id: <10dcb.669816fe.4c70a.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ibl8ECDZpRg4pleKjwnokXScoirS7gHjbjurioD7k5fkWRjLVhjeEuFG/C0rYkVlhgZNeqquVVtKTrefU6y+odEbs0rNsidcv//dYKM4EJMRDj5oJw1rE3ozfFxznTxFkAaMfzO4vqUzq3Mwsv6aUWanDA3eO+U1oVA+GYDkwbhMQ0BT+Y/9Om6jNrrAtq3bCPgtWMyNgLgbjYyISzuXY7hcu6cNJFpFFme0t5K0icF40jgJrVhgfvXU2xmHlz4Fyq076vgbGx5VsqkmUz/NmowB942qs+Zy+/c8bKKTtYY8/uARBOCN/oy0YiG4Gob3GwyYskyBTDNV0w5JCdbgVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZMp8EeP/P+uuSXNnClnJ3ub4efS2eNRkT4cnwhwEb4=;
 b=B+e7FsTc+qBq5nJWmVJ7q5xTs99m4QbLuhFcgJ+bRRGSAUTgOo1e/cvO0bC72ADc/ZjDlBz0km/2RRdbnLroaxI2nAds34yYy4EyVZvJp62lYRH6VXkTPZACwOt/GBID6K55BeQuRhbGg/+5gDQrtlNmeh53gWCD7rabEh/BXQA3FKGymuf13MIxCKTW0Q6lXglV00ZEtL1tBWRdwfdkdoWOkdihjxMsH1j6ahzn1sd5U7ni312ElvGhGxO4YpEmldBD943HpESJFyP/rsS7reMBvJWlYBUjjf5AtHdEegKKH80M3ukgtsfMbHSzoYb1Gr5Nf0puv5s891UTAr4Eng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZMp8EeP/P+uuSXNnClnJ3ub4efS2eNRkT4cnwhwEb4=;
 b=DqvaUfybJhaClStQg1oxXH0zAT7obND3FEnrOEKdXbEaVJwsvcgowOK4UBKFghnHKhCZ5RKXPoYRC0FImzO3zaT2zGNtnAV9pXGprg/UOoZKysGqCJspzqw2YDVIPSUevrLPXDKThbuicybryLoGhIgpEkJmkLrvfXaa7tf5U2A8W95f5DnOTiD3YOdzuHUL/QR41e0ShLbAF8TK0jZ3EgzV46x4A+z6d3xv7IhcCwiFpePkfR1FUcUlr6zLs9f0Zwjjk6iXOjf9+HEfCWEO20XFMEFWFaVhu2ADjSQCNmdnzQ/27d92qIZZ6flhHZA/hg+smuhFZXv81KfqDWIjGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <b9fb368e-b44c-4cf7-9529-d0017a1059a2@kalrayinc.com>
Date: Wed, 17 Jul 2024 21:09:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063758.086668888@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0453.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:398::12) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PR1P264MB2247:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d83a675-7544-487b-c8f1-08dca69406fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: ngeTJo04B72vmAhfUVZ/QxmuQlAnY09SYi4reUtiI/K1Oy8QnM24TlYieVzDcet0NvW5f49Ep2zf5X1V2k1ttEV83o6zGGdCM6Sxr1uKW3KlUGMs6WwnbO9/e2s+4sX3Ms36nKqMcjpKsO2uYEo5tRIVCkTdCZC5IX9e7qFRdwXgW3VuchbcD4uJABW0juGg7VAfX0JdRYQJLeuw83PptlZN+ZtQVErVfWftPI7z+ZY3rdODHiQZwIB382+h4fUcyIwUmOcpRGufIQkKfvISnU1alwRK/0mcrka+1IPS4+jcv285fFBr6M5/4q0SJEgdbnsziAECcTnhzqKpHPVCD9vwqbRobSRfmKTN+r4Xu+V0RbNMBgoeOuHmskIWAiHvvevl9RFNg0IxPeqV5m0+DC4hHZybcyXmASjHjFM8WUYx8HCm6Qews4zbwY/XQn9xJTycvv0PnsHZ8+V9y7pY3xd3Bjh/3zCJcC3VjZnZxZ+TuU5bvXPiwpomOiNBFyOHYIXEX8csgDh83Enk9qmNvBSL8ZKCjpJsxawGu+i9aUU7KkQj6esNmYAs7jiRaRCLZXPrHJd01I1I1UPKeJmjjJvUTMuNADxWP/ru6i40O8Bf6amXi+OUBPr/+f6MxzMYrasJyyonEqiHtfYaPI9OZqbri1cONPmndDXozJyGKIetBn3jbEJ8n5B1sGVeKTJDPeNP2y6Xp6jjm4OTqTT+ACkBRdPIc3adE8ZYrJ8pF7LoFNs8F4ekni/1DQuk7vEEaGfvn1mUTNfeH+DI+Rm92kfcVqw+sjpjhhBujvcuTO/3wvFn/cqGltlYCq4vdh516KEoa2bjziypX/rSG9g+0Rg1uiIhNDkdT49itipjXZxRr8NrRwzFZZkgEpLZa7NISl9n6Khxmx67mu7yYZSTrcFpiK+bZLYmoVYNhcArWg2igJB8kAts5PsCQ5Wg+d+RU3y
 ebg9aANLMDFs+Z+glPNHQcY1jiipbu9tOKM9ZKEcKANB0DCPzvLlBdWj2BQLXduo/+iZLvy8Qr/RK9wG8+OkWpVgQQVmEVSwWJvnDJc6rOORKGtrYBwF6H6VlUNa8oCS9jfYbewbQ51kNSOvsSmIrDe5DzfK65n6lfChgvee9Kxq255sk1UsTkGkhAS13/xsm8jZs6OyzWt45jGJ+lkHk4hipclBXBmCnqpbjSnE+Wht+v65jdVZeVgBbgRYy2AuOs5zau1AdkDwjlAdt8O/F35+VeaLhpYAv9OJD2elyAQUuodn76XU5WAzS8RsDJYXP8kFbhCr9sdmRvp1oT+COhKWZXjZaNVjlf9pKxIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: mLaXxLJPiI2vQrJuMnHDl6aEeULjB/KrRawW77N2Qb8/EdkdR/LZC8ftOhKS5C0UWEfQ9tDk0UbXp5jlJtUct8z3+61rwjhK+RzvkEIRUBDF6AoYyquCKEzzgS8EEdgeXwuLRdxpAIpJq96+jLgUE42smZShkOHcE8YNlksLcH9/S4CWjekPIBx68r0IgZYc/MD4mOvPGPvyjKDw9vQuMDoYQUuKsbx5qC/zD7V15oP/yA//uGgHIaUoGY35RJd4K6hp+7GtlJTF+nQjCRXRyFwlPO9uyaPp+YOGPpUaFaffDN0g7DVQCt4UdluCaJ1mu1ce83NETabh0qkVLCo1kPu49zR3cESa4lzuamViL1c5ubi3cajNyd5x8wa0aMXsV9K3ovlpIykIjDxauJiHMW1uRf8LMqX4crL9QqroAE4z5CtzaVK4O2/iLmXOWd2UM7Z8H8Hk2Yov6xvhBO9gd5nB5Yw8n4bQagrNTpQmaBddy2Muafzwk42IS49Csl5ekLjZ/ekeIVl8xmD0+yYApTjTFhRUiUoFm38SDdt4x774LAjmQyg/PQEAVOeHmJkXIzcZPDOu43qVIC3XvKhtT5T8aW48Lhvq0Qn2rudhiqbNx/iidGgT/bROQLx4LEAuwjp8OKYoB5c4QKm0Ccjx3XGIdnPydluw3/eVM9Rw9uN1zDjH6hEabIO8tL5brnm95X34i51MBrnbh7yE7XIH02r6uMxfFWgdG9DhTMIkTAG0hzo1QZg4/Oucmf5RfbRqnUT/BXs8nyj98T9cgAglPxxca4nn01Up41O9nFU7x6HWouRlwiKHMug27V6jIvxYq5laGIYzh04s2iYQs1wu+aFypuXIsh+RDxe+DOfUCqdED9gfwqO0ZNQFveT2BPEkNOuxIMdZ6RxvXL05zP9spI6Yqi/qJUyGfZKerOw9MVyN9LAy8V1l7h2zARobxs5J
 AlU2MUmQZqlNAqGLXYARiBG0aNdq1iU4++9l/aZddklagAjZEUNNXjJN3K2dO8683YR3u9puKMXBXZBcU4yxV8XDOKd+u8Ef7zTqXNtkOj/TA724UzhY1iOUieKt/FWTwt75oH+pmuSkoK6WISNS/mHh0yRGT3t4/2pqO//OJCeYfH3zfhw+Bdo4yhL2Eaxl7+bct6FEpdE9eDgzbk/hp8UMumMG3gLzDUKa4ZMSPriSL8rSP1eDDqLmK77eT0FuZ1CbSUsaKX5NWk2pvVRPFGSS4l+7wKCD2R+h+rSKvgNbFeUSoLIbwqbPNdtKYKkazK77iD3wttsPEfNHtLlWJMMDa4sutA3gJJWm8MsntKU9Uu721mOfwh8sVsVdPciFDxWKV1pZbbEFe2CpCdDqi4hxzP+21SU8SM7aRnyl9ARwiAUbSkYsivrm4amGoe+pMgLTddoeSbHYMKvY+xw647O4KVQmBhG1LTYkTcdy83ne/4w9F2csBkQGN43NVwdSXKD+iZSv4Snyqx+tpzPA/U/yaf9d8vS5HqyUtRdM6t7MW6MwjXSn/77FESXuS/yoZjQBfPc+jK980grGrqO1jrckZKZSORtsv12Pa0JBCh2JlIE9X7M8wezbXBBo+ddKGcTxY6lIRLlUhGjTY9RbhGCXmg0UvwuHtTu9K5GOE94qCCU0/KG7dZ0ZZP3UnSSYBaeqEIOnxcch5zuPv6jliA==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d83a675-7544-487b-c8f1-08dca69406fc
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 19:09:48.8892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3bAczyuROqa7Ob9TMDYgJ/9XAZXVcsHeBzx/UNIyEyZOKN5IZdKFS7Pb8Iqt7ErOzZVGvucSZorMbqM7W3lAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB2247
X-ALTERMIMEV2_out: done

Hi Greg,

On 17/07/2024 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.100-rc2 (c434647e253a1) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- 
Yann





