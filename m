Received: from smtpout45.security-mail.net (smtpout45.security-mail.net [85.31.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE422192B9D
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720617605; cv=fail; b=GHlgnk8UfrY/dJjVMKV8wBj50SJUXJS439lN61piFE/Tc6BvLcSHnYxQkQ5EjIrBbnRhssJ3oyrPrXjnmcTvaEwSAqRSVh5AuThBs/PV2DcwTIooqOkQqQlsw6QPCSkzVlZjgsuSt8VBXih2vnBUjgtkjJXfch+qGroKUfxsAHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720617605; c=relaxed/simple;
	bh=tL0lTlf19aYwfgpifnNgEG8c4hy8jgU7udEMjhgz7sQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PQJVnbl09ouCkGLSIo3C/pkqE9aB7qWB1U72FTgMDQYvqdwGz3bnfevrPR5maqcSWFnr6Oj1+JNNelkA8AkdaOGmdsYjzyh+LHz6jgitJGHZTFExMei+yXoXF/BG8Ak8umIgkKWO6afYxm9DMXYTyOqUZCMFHrkt5w0cWB7NCjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=lA/Pvfja; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=qRiOmQMn reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="lA/Pvfja";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="qRiOmQMn"
Received: from localhost (localhost [127.0.0.1])
	by fx301.security-mail.net (Postfix) with ESMTP id 1A40E528A2E
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 15:17:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1720617469;
	bh=tL0lTlf19aYwfgpifnNgEG8c4hy8jgU7udEMjhgz7sQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lA/PvfjaikPYs/1qrmZqjc65c0MiYybpitzOsUd0JpoWRJM6pFcGkVu4SehNVnd0B
	 HH6nA3gXm5qr1VU2TBnOSYm4Wjyh8sz8DAHHymdYq5oumstsMfXmiep6CQMdEdVZYp
	 RXM332+msWT2SPQ26gQ5FrVpSKCxFcTLsOJf1Qig=
Received: from fx301 (localhost [127.0.0.1]) by fx301.security-mail.net
 (Postfix) with ESMTP id BC13253FFEE; Wed, 10 Jul 2024 15:17:48 +0200 (CEST)
Received: from PAUP264CU001.outbound.protection.outlook.com
 (mail-francecentralazlp17011029.outbound.protection.outlook.com
 [40.93.76.29]) by fx301.security-mail.net (Postfix) with ESMTPS id
 05A9B5286C9; Wed, 10 Jul 2024 15:17:48 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by MRZP264MB2007.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 13:17:46 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7741.033; Wed, 10 Jul
 2024 13:17:46 +0000
X-Secumail-id: <175de.668e89fc.4107.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAindqBZtHo3MgUjuTOoMuwRnBwTRqBqR1F1HnxFxf4O/ybafEhBvJsr2kAb26ow/HS1rQPZEVYEb1fNr4Sg/VIddOFXPL7PeVyEPwU3VCxpiZmM3oJJjp5wng0AmdwJZDv0V4XwAqOyotHDFtaNeU3C5tc6mYO1V10aGzPoOLLArZg/88+I7ay243RjcMUtQ8HMrQFLtxHay9AoS4IZDu+Icd20Fra4h9DDym3MP6ob7wID+GouxvGahPfEtLYJlFwLrwWwb/1X22M4wmqEkqtNWZUeGf5HnvPSmLEw4Gdggu3Nn2ViJ9F9QkrRky+KcUSNA127asYheB7ImH0KuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lh4uarxWWiBoTV6TTz54Wd59sUZIwKeCdTWFHOIwJ6k=;
 b=OknwNqlNg7kjl9+9plCVkIiJWLQoHU0WM0IueRymh7jcbwDT1LizdhCI5m6D0rozX3YJGkZHV9VvttsFdL1+faY3bnn0L0tKfs0gpoHtr33DiBt38py5pR+lfSzIGwRBKUIFcb4OQXV8SkQV+2nJEgoJ8iz3gTy6EsyVeeSuZL40v+rkWMExFkhlQb0ftoL3QHCSo3IR2gPWy8LizWqdsKUvHP51jXviik80hGzTO5DxA6XPnicgu4q4ZBA3vF/Uudb40pxqbG69GDN27Bcb+ICGGOVfNcRudEFGRKe0BUBqyxG9eS6z65dcmSF9fz5BZlu5i0g7b8KGMaZv6P9lBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lh4uarxWWiBoTV6TTz54Wd59sUZIwKeCdTWFHOIwJ6k=;
 b=qRiOmQMnakDgOhJBun22IhjCCrAim/AJcI8snkt8/wPkQZQilBBr7Qvd5nXsAbNdR9gAKHJvONRmwWjf1kYMpIuu/18k+KASrfMF5H1u33+zOkdN36kPlAur6Vb9xUeTO1O/FIZKrHO/fxg7/qJByA5SIqRuyCpoD4DZab6IDfOL9kR2LZYEuQbdLqkLxDZ2yjN0G1hvkZGr2vkVAW+046ud8Got1VoINYjfeBiI5S441oIL30tkjWY5jUBzUkTISIQvIWjiD9OMSQeblVZNGh5TQfotPFqIPJj0aEQyPlRxgzSiQ/zxNpfbtj45ngJcBkniMzaMlObWu8Ztc4lqvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <e82f2ee5-e190-4bf4-8887-81857362c429@kalrayinc.com>
Date: Wed, 10 Jul 2024 15:17:44 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110651.353707001@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PAZP264CA0072.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::22) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|MRZP264MB2007:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ae6877-9acb-480f-48ac-08dca0e2b05c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: iMyahF4hbQmMDf+Pn0Y9Cc6K7hbsKpa3oSYPZucGW1eKiOP5DIImiCsIQ3yIr14B5NPZIufFV9pRPI3FFsgZtfRsih6uuKgHXLQcYPfnCKoiFZ+Yyp9tFfYdR0UFytqvdMmXuHbcEk+jb7hFk4wl0l7MYDBbIpygRXRZOzjr8bhugdDE0ttxOI1adiCLxUf8OjBPErBLFQ9rYn0FvSu/dyxx9/WYjMzuYd/zoLIyI7ETaTyLfzH6jQK3Qb0VaMZ8mNvimQuHpYkJ4K0ZSXAseO5dKLq6NLdRRVFHXVuAHTdJXtfdRpmcSFG8Fp+2PliR7ns8WlCUM9g3B7FeXW4YucZLsLR9K+uCmTiP6md3Xr0jWdwDI0+ibKNIIF+99fJ9bn6k6jOrk97NEKXS/O3iMs6iQMNr6sdwVY+OYNbZf+uHbWLNbHzWpKQvq/E78WXT8RNA+Ltq7fXOX7sazhFqUyMQ2blQ3dpRLii2MTb2wz+asvIYgw027FjjneoB8wFmCI4TTTGpZttwLfFg4W8rMemmWfmj1LcmlRO5kqCjwCWzCydCBmP1it90pyZE8BevOsrzw0XszPptRurimevvQXNqDpqCvZN0PoIVB2tIBF4YrmqcFmr2C9+9L3hEBy8FCb0vcvYHRaFFiKJ7PsjnKxWyFpF3LZoHoSQD2Y98oU49pWEsg9PkWNKsgnNDPgJfK8KJZGIsOMQfqP4BP+U06ZNbPQyqaVe9sAPWkEjgmN0VHURDDXhHbnFsFIZE/G/hI4Wmrcyjb0zY665sbLHIMrTWO2Vw7zqs3qGTTrE0W2oXu1/JBTx8SJwR2RwAOGZn50PVlFyfQIHzAZU7yGry2gaPvHTQ5DgJyU3uz9Y9LoZU/zC0eWHn7So5xd9pemd2Ig6dQL+4VbZMnBlumWxcvEsoC56P8uGeniQvp+m6Iw4rHut6M0CzP5LkcAO+NdmwXgI
 mzT4DOf6/0TxI4eFIeayisOuJLfKXDW2HOEgm9l7/cdsFSEmyhdaGDf6f7kuN3FRtdXzgUnWpHigFhOW3SIJVYbWy5gfm55w5c5yRW/S3DTBskVM+a2LhijfbySn0zgINvmwlltr7loA9oCLEn3t4a0VqUReclRp+cXj6PNt4lOqhpJPhkaLyRb5O4Te1jnvqq98mthQxl1hA93yehnEYMKsL9oXdIaM29QDYqYSiHXrdUEkw5JJuaK+hev82Dz9UNeDM9aUs9FanSv8crQrAHmU75yQSLTEPiWaXrd5+rk+FeKA8G9xt9vNm6L+EFOX9k43YPInpbvwxmJQOojejpSSKPvKrHSnR6FeY5Kw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: NgbVlgX8ZIrZ0IZSQt6YUGxncVBGAMUIgTpdK56w9bG5wzWZBvr4hY0bWDmwjVZXbd2JilIGFneLlWRuklFo16QnyqctYDlPeiSM4wc8qOV7BZwnikSgOIEZv88KcP8bqATo/+AmOK9GNy966ncGHpyDlEA/0jFSiHaF8ifK7BcKprBOzF58Ydryr3ex1dOLnWa1SYSoRvJ+/AcWRmR+fUsMTX4Ss6yfgRfDgSqAlz1P9ksjZvYuOY1rIYsEVvb9C1EDkY9Lf/+N3akOkr/yYNbC30NEFKxsVYN/y1hptL1Sys9gEJ5aW5ofWtjkumm4vmSJ6ypZihMYspZZdDG1agfMvC6FRP+c1l8CFf04TqHEA2yuZ5qeIeccpm/zUy1KvHLPnlzCtegzVgQ+IRMmAqmhf+4JH3U6JqstQj4aBnw2pSCApH+CfxMdq4ZZ9oOXXovy/a52oFO+/LxsncsECp+xohaCOp5BKhsWoyuhE+VNqtgLvqAUG6Q6XE9hdwdmXP1sb1SnHpypK8fgrYuLNeyKIuZ6/2S+z/7JYjmAD7641DoaRjK86hJ/K51wTipwm1OzxW2FpKBNvt/HyiZgkopSnQUgDb0z6cT7YZt6KQWmk4BkJ37qDIx4ZK1oOcp9002w6uSnYfGaAO2ct2epR9KDC+NCsH2p6M9kMCeeqI6gQXuc31KQbb8VLheykphB3eKLBW2OF9LAYsKj6XgDMm/5b9VwCAKgUj5vbwYpFkNmhcibc1M8sUaJiahpIeQvmIIqB5FEhdbnCq3zNterE6Y6trgfJH66JsqXALj1NMARkhIqelTyp+KjasY25P5CFnxpMT/3l2WOaDmx9SLlAY10DmL4DzsIasVZiB4zHxqZYV4EBRzxZimOgr+/XeDujdrDeSu9bUG6jO3C3qkGv7STOkUoL8gmBqhIzLF/ZP3J67ReieKdGndPFr1qFGmk
 gqc3L8JhvNbOHBRgOv3Ty6gjH1AQporM9aYh6MM1wNdSJtpI/sylkJbJLuLlavCnO9k7/5pwfaQN2djQLxdP4HG0F/rx3DzHF10ZTzKPP/SLeKQ/z2cYaOaK+eB4AReoaRh363vl6C7snTzbQJFgI1c8u0J9WEcasFVkJl2CgPdPWPiFVPJHMBJLGAybi43K2Uhbg75QRZr5y7sOP1TLtTocwX5tNMT8eC/B3Fg2NRXefogL9+RbNYdGnC61YPgXgMPazqnTSd0P/R8RMDzqPwYVSfZ/9hD/CJG2o9FVfah4cn0GomjA9IRilaf4/8rXGw89OaT/Q0PJApBHT+rS+8QYk4mCykiwwxka4f78h0GkgJ+MkyShZ+SVZRt28+IzZjn6tvRpMhyc/QSMvF/16HiAlPR8ukV+j7aSqvmgHqKzpIPJ+M0/29m/QfpQx68blgcXGLDe/+BKTdA5L6BhhwU5jR2P8EJxYLSJQybqtilE6/CFB2DZHAUkEkeFEeUYKNiSCWM0EL12Cpq61WpgCcOphwjf3bDL46FJUxywJv0WHn5+k0C1hLTc9yPtYnnr8jfJqs2Hp1U2H36ftSDlkQK3lgpxLbyjlAJR/iJ5aVOBQhaakB2MqoOgF1kyu/SVNO/lLPEeZLZLciMrEBWnx7NEzTfWUpN72eNZSzAlXujtlrFMBiIhrL62l5RiYz8cLMSvKuwyJlBs277ALUOoaA==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ae6877-9acb-480f-48ac-08dca0e2b05c
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 13:17:46.4046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4Wby4aWYvJREGW3bsfSv/TPJZxSOxNMOwMnfh5ehS+ikNRL6ISAM5pVl3Pr1c3v3Incy7ZPY8DRhXVp7m0yUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2007
X-ALTERMIMEV2_out: done

Hi Greg,

On 09/07/2024 13:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.98-rc1 (b10d15fc38486) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- Yann





