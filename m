Received: from smtpout38.security-mail.net (smtpout38.security-mail.net [85.31.212.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A34A19EED2
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729605307; cv=fail; b=kTw7vnLjaZsY9zMKrDdwkWe8JkKhuOSHCPt96VFLfdBkr2E/NApWrPJsYZG4Z7ctVSwFMN9sx0sCMacmfFhGCWPGdo+ZF9SkRC3QnPIkwcWtAIWacPcOkz2F4Y65GV4v+tLQUPjgv3OHpEaC4OFQmgRIAHrdd4rxwaPEhL2ORXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729605307; c=relaxed/simple;
	bh=LMGHh7NHN1bcY2Kb5D+gaArOfP1cxIW6WjoxTWXgS7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LyjqYfccSchyyaChdM9oLUt/t5Zj+Jsi4P7r4UrirCGj8/7syL0HHMHvfcDWLQp069TS3KJoCGqK7jYO2EuCYOKJgWJ9MGQV7AHjCM9EiK14LtRI+O5K4dJNa6WihCuvouLvSiH0qX7cbyY+UxGCzd5N423xICf9vv60MrQDXms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=aOgBJR5z; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=fXbMKXhT reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="aOgBJR5z";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="fXbMKXhT"
Received: from localhost (fx306.security-mail.net [127.0.0.1])
	by fx306.security-mail.net (Postfix) with ESMTP id BEF8B35D1C7
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 15:50:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1729605040;
	bh=LMGHh7NHN1bcY2Kb5D+gaArOfP1cxIW6WjoxTWXgS7w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aOgBJR5zN7TihpQfwx435n+zF8uaqNV90KyR7DjGrlCIWAwNmjgp4d4xzAZyZfFAB
	 bE8D00n+12b2P0RsY3HUmR0+yntJdTOgJix+Dz1U27uiA4obQOw0Ti/JDF+f/8dsWD
	 qMkQ6MRhvnUnUmjFm1hCScZVe8DLpIfS45bJKOBw=
Received: from fx306 (fx306.security-mail.net [127.0.0.1]) by
 fx306.security-mail.net (Postfix) with ESMTP id 6B21A35D1DC; Tue, 22 Oct
 2024 15:50:40 +0200 (CEST)
Received: from PAUP264CU001.outbound.protection.outlook.com
 (mail-francecentralazlp17011025.outbound.protection.outlook.com
 [40.93.76.25]) by fx306.security-mail.net (Postfix) with ESMTPS id
 D326535D1D7; Tue, 22 Oct 2024 15:50:39 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by MRZP264MB2379.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 13:50:38 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%3]) with mapi id 15.20.8069.027; Tue, 22 Oct
 2024 13:50:38 +0000
X-Secumail-id: <13ff1.6717adaf.cff8a.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdA+d6HLzE4tlM3jEZ46mJxpSHfmI1OJefHEZS3HSpzoXS+GTBoBc8UbD2Aso9y/IlyXy7OlnL6JhN1Buk1/UqA6Mp0blFiY9YH2bKQssKuF31ddCQfVAZiGNI/I79dp8dWrBzPvipYRsJeqyqpMdD4VMKOaveR/JZO/9qrBX5AJpRVGZ3uRDZ24ccTc9uQS5OcPnFDcLXCyV+dCWo/xGxqw8Ygninoga9/yJ61HOSrlOJuBHNpewJc7DFCbg7LPJwaSjPrHa54C9KqHy60kchnLePk1YQUnzBBwvJALZxaaY3qKJIpJPBKwqNoOd+G6ZLWOBiqvKluB62DE+T8oDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w200T19YUd4kedT2+23uHCm2k28W+68AkOhALX7KAYs=;
 b=rdKAssuu3tVEUnK2Rfzwzipkxv9Vrsrmex0qtSwnEG5paLwTX6bXlSa2SQdxTsBzHMi6+52ibRKBvRHYKHyCKjGeR9oHL1BD2aUv1zerHuXSO9i+krkPzG4bz2vtuOUiv6kRHG6sCluSP6GMFl/l3YcVrZjlmFo9Qpze3Wp3FbSs1t9q/tRxvc3lN5aEKxQw1ArJDFIOMBUMi3evUjySY5nAAm0pSa2I8l2PO9U7AzjKGn89NkoxpqldmMiYf4t8ikHXEzuTJiDYZhFp8LQUOap5Lu5dN8INka5gxq0UiWw9kXKkMDE0RzZcbOoiY+s+A2oObv7H5wVBrrW9YTni4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w200T19YUd4kedT2+23uHCm2k28W+68AkOhALX7KAYs=;
 b=fXbMKXhTPqSXFdzOIbfLhBMQ0rcFGDeRTSCYZ58sV6wYRvxZErLuy4AP2muexuLcPz74ZMrbq0b/yb5clJ9sudtUrBi0WOrgJUVgi0hP22l1yE6jVcBGu7SVGtF4ORxRfhCxb/yg74iX2Hmv0N2MGxpukiOsnFuotfoWTMUzAFf2s/cG17Timq8iCIVZ8jn3IfJX83DM9WryfEIowMbVcbw84QriakcRAsKeqRzu+Cd5uaGNBNwTw9kdmxPZVTDS0l026h+tfhcU5qmnN3llGk1hIKpcGVWAZIZYUHOCTB7iha+SXrW1I9i2ugq4XkX0FkpRDCqK1jgX784E7E0AOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <4fe2beb6-9c68-44fb-be87-14148dddbf93@kalrayinc.com>
Date: Tue, 22 Oct 2024 15:50:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241021102249.791942892@linuxfoundation.org>
Content-Language: fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P192CA0005.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::10) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|MRZP264MB2379:EE_
X-MS-Office365-Filtering-Correlation-Id: 90226ee6-461a-49d0-4075-08dcf2a0826f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: BbiczVcacf80fTy4FPz+0pZ7uSIFfvdaEtz2AOS9Wr543NbNseEvIk3Gq3mtiPqL5UsPz60IwXPYxz2dCSUqqKqxqRfT1ilNhc/hpiU28pf/vPfeoQJECOiGVJvueAvYrlR/q1Q995hD3vLvb5YhelfzyN+scWnN88gIsZ4bjXtKf5HWu8Ej3grPDdvq9aR7Ci0jYw/jw+7jUtnG9Cb1jA7LM3Qqe1gU5XmYHODV2qaTRfQpAHd+zHyz3Hu1OhSXMPgFLrUkuV3Cf/+iwYxvbsSe/dbunc4lpeprmDE4VDPVbFtI6/o2WagN51DbuWOaPGQ5R9pdhcQh1kthTRYZnta5v4FPjntZZ6FpfBrPUXpq7Yne35Yz3L/rcKKX6YMnhp3VBx75gakQvE0r7KBeGo2d6elfJc5U6MO1SW/8dwp5kq1gTaRWfmuH0NHozcNQ8qGEj5Hptq3MBN5LlKFn7Hdldm42H5z3u2CSClIGes2MMW62ANeSHbCIPHzB7eT8shjnt6dBIMrpw3L/6caSBWQYX62JMhMEHPtm6Pa7rYMgG1FToDQhaFbiigbYPwh6u6NMnqVhwzGmi142HyYNshBn7hAAFmuqGTwcluaoai3vucZluCx3NVh/+Ti2CR+1htNPWO38Y+zM1flx6P/5H8coI3H0FbfZkioarMzyhHzKipOkmK3cO2LCUeZD1PyV+zKS7zt/7JsOOhs+2GvLwJ6vqkuV6+YiSul0b56S0edDcuHtOg6AgVrZO+ztu6OBieULQa/A+RWYUWQYICNMQJtDgBPr2GTbP1HuBCLcOgv7o+Bt8W56Yjyg0Tfq4s4JZto9Q83kHdepzoNpQ3Z7yJdCyNLpMud+uolWxIZ28WWb4xwEMbPBV8TLKGp0wOyT9cDf7skl0UH0dSytJ23NxFwfQpU7OexAZBdI79+3lzyNFrB9f4992DehiiVfaHCjtX3
 LJw8ZaYUO2sfTJY5rdrZV7YwP2vgVx6iMMIGlTMuMoEmdoObrKhJVCYai5/AN0m1YLyEra+/N9mwscAO00PINJ0EVF7o6Rxp7WHdtITpaeYCzgwUxerFD/By7b24hJVfCAM6itDBfNQVsbz2oeG6xKwfDtute+KHn+FQm/bXnv6zaiQ/JtJEvSdvmCEeILT7ZYxd3pc6EsFm4U2UFCJEn3B4ghD3x97Sga4/8W8QTL9UDYeb0V0886l6RR7vGg2BsEYN7u7ubF+Pn/+cdecx5wkqeAiBFH0PQiOH09r+FceeysfLtYZwH5dO8DWeu/idLAl5l+50qVH/0VZ8XAkpNgBAGK2zUpASSukgDQC6IEe/0Tg1iwqECIm0j2hl+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 0JozI4GBNLyDwl5KXZuEOa5hr1woMnCJxrdhJ7d0Xp6DupuQVGQl+TA9SJCk+tdp7kibqGDxOsHsrGKjTdae3HqqogGuMfa4rBLvO3+mydCqzHe6yf/CIniRLCR7mWCNu0vIZ8G40q5joehNsfac3lHubnzuvyUpAXvC7vg5KFbQVXKbKYJLB1BD+yLet1nv3dLYN2fpbSAV7u145oq5uc7J1IYGRP2r31h0mTNE/9TscJBQSo9TrCvwIL04pWv+j0AbLJWlgLGtMQCUmykQ/GxWwg8v5PG/eJdLCf1h0WKoy7NdNAXX1kDSMQ7tpF3EpA9+IVdC6Q4XxGSihGjF+nnvbxNrsWX5bjjAWmwKTlI0Wt43wwd1NFmUHTw3VPMXwupY5tLXrV/c9VdIP6lCTwcCQrF/APAlgyJgWyCmmxw0OthO8RhgR5J8XO3oky0t6hIc/wLQsFu19XMpYmwSEuGmjjilasPcj8ZaQyzBfNK+dRhzulYHD83WdlE3tu539XyxrCHqAJRwRJRu1dgEc72vueOlvxj4hIoLdHQNjKQTXjB7rjKJD2iySzGB5qavxAEYBV3a64GDEU8Lbdt+6+W6mrqu7gTo9vVhUrnmjfDjpQ5Qf05NxbFTYYE8+5qD178vEKGD4/EGuBBe0oiSkjmDGSAO0L9amW9Y7HzvU8EAVldSw8PJ/udIFDr+e5rHal6dOGHOhgNva3eBpEvhreW4HpbJ8g+qq+BJX2FzqVX3nRQri/aaqCxSR2p5jwuWIAInLzNbEc2+bAfxx0r7/QW6iw5+nRR+tDB+VsNRJJawU7ZesRbhB6sZyggtPniZ7Ngy7mMF19NK5pGM2aqFGHcrPhGjAkiKFsUS57eyyg2ZHzZjnfx0mliCSrZ3saqHdUBD3bic/jAE+glzkZldOZD5uzOjtWdL9A2oJgWuMFR0FP4yeXDP68K7Bc0jtr/y
 rFZAViD02df0esFE1CFxCkWltsbopeSRnSWAKT9luykn9wI232WjeLq/97xT17Dxoulyj4Mle9UqyVAQcXYr8UprmZJ5wlab+TnrxKKzlurZfuzbQ/bcfBF9t5PrZo+ITUkuayU9CpnlZb8uG7dZDl6h4a42CbswHTP5h2vikwAnG4lCwHhlfkg/eYzaGZOXrNaLx6/TlQz3+wxYYy/8bdzG46ImGeYSUqofmGekw0/sr2isKjTBY16zbaZR1nmTYDAFqZFH1xbNxjBt9sS0XiSbxLF3HAFZtK5agAzCGBI1IVzRdvzZ0/qEGo4hF7Vo3cckZm3c5Ag7S52pLh99U7yv0AXjOsnd87WX1kPBQHYLRFZviW7zzsWL0tKSEv2NHmR5bTCnev/+oBU/wPH8IkM83wvbA0CIa/ZHbRP+0XavIvWeE9B//Fx5nfw28/MLL49jaPsNCnI6KPbn1pvCrB/ebUda4V1Js4BXNc3hB+xCifcQwwDWx2WOCmUFeTKOvUKiUP58A/ZOUvojEpcid5T5i0UqiugpqhsfzOOT5CUcRh4y0sZ3K6vJMfgMap95SAhMqEBq/VP4A9mqsm/yIrZY+iYtKXHzWBU+WutvemQ9A14wM+bw8wZJgxOdZjKbHM1sGKnEP+NVBX0tPPMaBw==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90226ee6-461a-49d0-4075-08dcf2a0826f
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 13:50:38.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxs2rcJ4Ri/76uA7Srg+AWjSBjehuF5v2SQhsoeFGxfAyWXzc6YlvuAxPj5aSiaH1fxuNeIuYtrd7FCRMLFQbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2379
X-ALTERMIMEV2_out: done

Hi Greg,

On 10/21/24 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.114-rc1 (6a7f9259c323c) on Kalray kvx arch (not upstream 
yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our 
internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, 
PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng 
testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- 

Yann





