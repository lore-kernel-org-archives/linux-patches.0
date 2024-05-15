Received: from smtpout146.security-mail.net (smtpout146.security-mail.net [85.31.212.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6402126F05
	for <patches@lists.linux.dev>; Wed, 15 May 2024 14:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.146
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715784306; cv=fail; b=VTou5fUA6CzObyaTtGZ96rDJtGqOLO2kp+KEfImiZuGk2NNav9UwvEbXflyMSKkb6az69u6tXY05m8zmn1oskuvH+RYH4qrCwqd7WBx5v0OKVBH2KE+ML0/nNqd5U2K7XbWB1z4KnFWQEPJfuBxqMdfDWoyc4GkncDxWMKeTLYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715784306; c=relaxed/simple;
	bh=IGd4ClDhPi36L6nEfn9iP1a1kK4ikMUMr61c56debq4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LxhCNIkJbSX1nn29NuV7v1a+MZ3WPrLGtHB3qMyRVlVG/ld0bRbRbLT1a3eN4/AuXwmwddU9iNWGOEVuL95kUE8aedj6PBsm4xdU6Lcy9NIlD8U3xRyPVtuQpxxprP9fEOf4qeIWmGd77GWTiDiYVcDCkMZGjKx6K6lHWbA8H88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=Pgud1Hmz; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=YaQhe8x4 reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="Pgud1Hmz";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="YaQhe8x4"
Received: from localhost (fx601.security-mail.net [127.0.0.1])
	by fx601.security-mail.net (Postfix) with ESMTP id BF0E03498C3
	for <patches@lists.linux.dev>; Wed, 15 May 2024 16:41:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1715784083;
	bh=IGd4ClDhPi36L6nEfn9iP1a1kK4ikMUMr61c56debq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Pgud1Hmz/z1iczGhTP8R31KVHaFXq368adA7+ediVudBREejpt7lU6rGijynOJngE
	 vKzETFDI3/YsAe+K9YiKKlJ5aoDOiauvIwnSh2L2c8ikdlcicL+dZQUkdLAY4qxJv6
	 w+WW5fS10LRGBwMfucvkd5q7GdbkzCaOuMbgLC9g=
Received: from fx601 (fx601.security-mail.net [127.0.0.1]) by
 fx601.security-mail.net (Postfix) with ESMTP id 3FAB934984A; Wed, 15 May
 2024 16:41:23 +0200 (CEST)
Received: from PA5P264CU001.outbound.protection.outlook.com
 (mail-francecentralazlp17010003.outbound.protection.outlook.com
 [40.93.76.3]) by fx601.security-mail.net (Postfix) with ESMTPS id
 5F67B349848; Wed, 15 May 2024 16:41:22 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PARP264MB5419.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:3f0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 14:41:21 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7587.026; Wed, 15 May
 2024 14:41:21 +0000
X-Virus-Scanned: E-securemail
Secumail-id: <4e72.6644c992.5cf91.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/8mgNwHok5uOENK8I0Ih+m2gsIbRVYOe5vv5kIt6QCEnkqxkTDnFgX8eIkv2suG0MzZsXETU/ZORrYSaEgyviGMDG2mVegkCByjMHDm4zdjnCDnOcEhtIhMhdqJWpRtj8I6NUppyazAnK7txtSqlig3jDTujyY/AxTINEjnVUj7mC3ERgAxEPNF37CKMFUkwFHE58fMv9S/BWtWwVgJbsTrIpQ9M2Zy84thdsijCWuW3wANilzneLNSQltTZZVChoEeS4EnTi6ZlgN2QurEACv4AvTxsdnMAH084zU3eKFwJegbA2eIw+Pja1sLStYanVWXwesoJg79T7aJ8a8WTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vwT+TxOsx1r8ChwwqD3xvT2FJImA5lTBvAQ7+6rMkQ=;
 b=m5ENid1yK0GVBcQV3ErrdtdDd7HYGz/9V++P+U4Eg+RrZ8mbEYZ+9R3lB1gahRvRnCSKHVZy4dlStE+dtTkx/eVQxUWUvHlPB6V9t0I6L9GkWQqpAhHVMiUikH3dhZhceDZk00QVI4935o44vFXx0JBJs/zaqa7lCFXJp12BDDPJs0ZBj9o4l/uzc4HoI59aAXYyWjPjifARq0juyJsCLArFyPmq/31AfaYKsYqKbwFj0hISuf3CYS//00IHdLey2t63T0SBpmnAnBnPB8IAtgOPKIpyUWXbEVyuU92YUk/h5cbfxkOUPHJtQEtYkSNeOs3kTbhpKvPHK9uoAHf31A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vwT+TxOsx1r8ChwwqD3xvT2FJImA5lTBvAQ7+6rMkQ=;
 b=YaQhe8x4X9R4eNKMJFQPEKBieEzhQbjKVwtLrzjtZSKt4hky3UuhAEhghhwr+9EOSMsb/IaXptFlAGCHaTywCDxvAlRcC9P8EreWVgUA/y+qskxj9b/KX3n8E2pm6+tB712Sf4QQUaK4k74RCFCCqU+WzHLFliJFRRp/2N51cyG+MzSmk8i9NY8yKOcjAO53OSK2syLUhpPGY6im/qSp3QovNUPwBUaxRk8oSy9T7hQL7D9qnILn9k82thB/Mv0o4nczldJJVR/tinshLQgpyElk7PqQDyOIuMJw9wNFJINlOIrAgvUzXJLul1wNpkqyzsnvYO5TMbwuFmrsoE/gJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <550d76ee-a783-4662-b16f-b29713a0d6cc@kalrayinc.com>
Date: Wed, 15 May 2024 16:41:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/236] 6.1.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240514101020.320785513@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0046.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cb::17) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PARP264MB5419:EE_
X-MS-Office365-Filtering-Correlation-Id: 526a4ade-4788-4db2-ea51-08dc74ed166e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: Apu9yK2J6aDNv0KDzLItCx+uOt9i9d3DCaQ7PXvMK4fNsLZi2Slj0Z2lSCDpUpIrrwF5jHnzdh7uP6hlsSrWPk1kfFdV+5IpQOj6wf/6Z5LyZB+6r2Jj8FGCZe+x5zjEUFE2q7cAvDcVTgPsmD4nA0CAjWE4a/zgEaz+KD76fT7J1esJuL0JVDiYchqOcDebXKajApr0nsjmbWEFsXCsRwlvC6oruTXo9/DySvE4CSbRpJeDI1Pj3mGbnOVQmfk8K7yYo4HNAcnOR5lr/UyUzKhZh0bmKMTnNDiqjOQcrtMqI9+4MceSvb6KxIxGq3OrHZYTf+FOrJynvziQ5retSzlu2lyO/sEq+rgbagnLMNSDL0I/kfx+grwvio7rgZjrgs5sACq7NPhK0Z5q6rySY5D1bL3B1dPp2DFFoYWP49WBYgLPe70JxMpK8mB9fkJYLY5oXtaxz/TmcNBPDVnonWFxiQIOyUbecBJlfYDTpCnqZnEs71Wp3wtn3fMa6IW5r9vEproUjk1zvQBte9IgnOuY5FbvfTMsVGofPyT0b1jZpnuEEh6zs38GWfj/JfXJ2c8OKqlS+243FUuVYi3ksnR4uC9gA4cITxpUiDGDHLXExdG0rvxY7C//EmZlIROFZmohN48t6Nfe02w3rnfsvGUPBFExpllXIEfKONGcOwwTisWlIh6MAB4S2mJKd8Sd2Z41Jk8d3eBXLWadVfIGIdbKR4+SJmoBS0QUW8NEqF35bPaK9gZ9MAT0km2cMv/SnUnV9C0MPHPuZhPH2uvI+lYZcsZtwKaA+pz3LLM77PP5EkD1SXcQ33mCHVSmlE+RoErN1PFAvqQuyMaaGRXxhyEsmpuoEuzkjIQwHS+9MFeAgkpVz3egl7HvUqCt6Qu54BXZ4N3SUzY28teZK0nwXvMj3b1j02THXCV9tWtl/+Pp8OIwA8LYIku+q1hvBNvuR4e
 lhxCEeo8DgSenD6CIh67zUKW+DK1y5sIqacVuiM+TOqSsqNfevUZt3KWVK9JQVEB+3dvAQNN50H9/DtSz7Gv/Kbgmfets6PAVJ7ZePFfNDdVKNr7zJW1NHhtYAsJ3i56Uq11LxxjjeDx1ZJQKkT4L8dTpgCMmjCYoZ4hySi9O+Tm42Y5yScx0ynENBH2Gi4PuOpEDqSNuXOkSCRDQWi8QParhAHde8y9t3cLpyGGFbgih2hR2P1ZUGDsaXv1fkHqZnCOuA+aAm9HurPit+ldqsFqA4FiN/hzf+ddXAiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: Ny+RlaU1AXr0uuMLElndJFlN2Dz/3ZjUEKv45ltkJo6KWPhOIZIWAVtjj6eU4/bdcL3kELyecz9wpyvXr77LDv7sw9vUUrOUEuea2AWjgueE27SdMMwPmXoMi4LdFNwojEdEvooI63wB7wvAd1jvKLv2mWULQVqqhUg36hEQbNDEevXNa/SmTuvjRfFW7mytkIPJ18k7L+3MEf63E+JV0fOiRxCTr7VicIt6C780Jyl9DatHR/9V5pAJ+SsJ6nvOG52XSL0FJMphGAt/6FjlrzCL2FumlYJHpaSnztfgOfb5ZX7xFtBnDG7aooBb/8LXihUZyHUIEW9pf3UuNH/DI7WZrIt4bdjFibLNfK/juc6JEjCpGYc/vWc6h7IUjVM9/7Y4mEwWtDSNuhvwWTIdcMlB1r/9ek06gpXSV+pzmltKyfIK4+2CIsQm8nZB3fYur5o8w13yWkbXkII6GEixuLr/vTNncmI7wPhyrbb49UpHseNNQn4hn5ygTq17PQr24lifLshEXPzlxvGp/wjlnsmE5zmh0A0stRtXrdWENZDyvBC/+YatlohJOIigCIMTJ1WDR3oP8PlzL8hXZRe63YO9N5KrMdHIXP7lTFwVX8XGWTQCXd1XwApdbceixHMGl5FVPBLBO/K83rbPA5G3PRTqjxvBQP6qyjeAnsJJmLVaBj1cC1ao//n02qocwtGZqDw+mE8iZ4UuzQy073hWc6TWLRra0Q1lo0txCjryj/PrtEK68Ve93Z7BpB/BNNWfMCDzRVMmNCaxRSdxcJt5Lg8Ci1Q+GEZKo0gHZEir3XFx2BcH9vj4UT1l5jX8n0A/o6mWvpQTxfFCJE854M/YUZ9yG89qhcBLISdAZEYh9DXUJLKuW10BVsMbVI4ktO3XGAa3CPSTuGHtldHfR0/0GFJI8wlcCES8WZfDiIabwuWNQv4VUY+97IgI9+QpOTrh
 6ctTHe0IkNWPExpcFeKwos/BQ5OosBy/KNmPMR56A2at8p5exf56h+hBqJNV8uQnMdlErdP7JHY9v/k44NajeJIezJLzC7PXxHXOcb3vTRmhb7TTecW4wOm17K6NGb2RtfUAkU9tl13FHLzNRF5j8gr3rfyB4ZY6p8sfm/kAj7fuLCg75YNRmMX9wBjkVWPbj2DlPUt4SxmV6sO2KHNHhYJCk9EyWz1iaWuVql0VMc0fiM3rp67aJCTrveDOKw2xtuVBjMziivg2UPkUe+wHLbLVlsbJxnrz91RL4yX3QdNVzQ9UCg6TmxGy9uFYTUCLbOOfsIALMUFM1x9mOrkVEAa7H56BOKKwXElLeD3voQznoqcobeXa07sKCvbsxUBwLvAQFFjGnlgdHFMPjl2qIKIZRriN/NPgZhUTGbhOX3nDbxmKIMCTeN8eDpqH0iNfUcGBsOIOZHu7sukXFU/Ii7Xg7t5viYlvKeGtYEO3eJB7aUAQ42ErtwuQ+jAEZzki4TfnbdEcHQ4Uvte9RePqiRoCtFAURueQp3s/l8sBWwle3ak9v0VDN9eoFvE4cCkMBYcV45AVaToqPpdwvTx2/A3xwcUZVu3YhrHjZ3xHvpsMNwq0t8+Dptu/Wd+pXMq+Y7g454GrnuCu2EJA1Vc1+JwALRXup2Y9Jbw0s64i+L4EtcPI30zL2+z0A6AJFSTRA0u8TOvvMCK0x0HDCf1Hdw==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526a4ade-4788-4db2-ea51-08dc74ed166e
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 14:41:21.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOXMAX5Lfrh/uYaUkp1KWC+Z7pNNwieI0uCd1RHeITTRMVR8RxfMlzccSlWdvqhUi1iSSBI9VNnbDU2jxcB7rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PARP264MB5419
X-ALTERMIMEV2_out: done

Hi Greg,

On 14/05/2024 12:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.91-rc1 (21f6332eaf4ea) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu as well as on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- 

Yann





