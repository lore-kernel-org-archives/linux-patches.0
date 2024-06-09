Received: from smtpout149.security-mail.net (smtpout149.security-mail.net [85.31.212.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB3C200B7
	for <patches@lists.linux.dev>; Sun,  9 Jun 2024 10:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.149
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717928115; cv=fail; b=s2YWHaTDUsOs1vHTwMPVN07Du3FjhpLq3zDQv7oo79Q1HWBm3RE1BDWjvbUA7M89RNBycG2TkkQlkqTvCK/v5uhiEhr3fGMLs984dFE9rMCHozDKVOmfw+lCn02smNANVCTaFbAIbDS5vbVFYWHeaneaQTzR9bmC1v75MMhUwdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717928115; c=relaxed/simple;
	bh=+Eu7p5goilcpuGA5TxewZ+zOoeNGCyKkRa0b+/g3ZEs=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dc15mZfT7+4Jq7xZax6Ys+oGluCtbM/63ErWecRCNv5mgqBk37QEn0G6xMMf/6WV0e/y11w2QMaVc0Q6OQ7zEk5tewbcxkaG2SvfTU+T9DMQ9qYy2NKdkadvxoroYHM4jqS9FJsgl6dV6uWGYTyTQ4G2coVGHiCXGVE7x+tnm54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=KXQIWHh3; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=jAEqo23d reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="KXQIWHh3";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="jAEqo23d"
Received: from localhost (fx409.security-mail.net [127.0.0.1])
	by fx409.security-mail.net (Postfix) with ESMTP id 331BF349591
	for <patches@lists.linux.dev>; Sun, 09 Jun 2024 12:08:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1717927739;
	bh=+Eu7p5goilcpuGA5TxewZ+zOoeNGCyKkRa0b+/g3ZEs=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=KXQIWHh3+kudDEKhrxCGi7NssvUnGmPtok6fscnpUjdmCpM6k68AeffvHH94BhqRO
	 Z6rBBvv4jLIFkNS4O5guPuISzEtSZ5ieAtWW/an1Bu9GSGHxgByZ1WKPs+gGXvj71g
	 cHK0M81Cir4Z6w55k3e0t1aIUOp8ZHjUbjDFxH04=
Received: from fx409 (fx409.security-mail.net [127.0.0.1]) by
 fx409.security-mail.net (Postfix) with ESMTP id 4776934998D; Sun, 09 Jun
 2024 12:08:58 +0200 (CEST)
Received: from FRA01-MR2-obe.outbound.protection.outlook.com
 (mail-mr2fra01lp2048.outbound.protection.outlook.com [104.47.25.48]) by
 fx409.security-mail.net (Postfix) with ESMTPS id 300EC34998A; Sun, 09 Jun
 2024 12:08:57 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PASP264MB4865.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:438::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Sun, 9 Jun
 2024 10:08:56 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%6]) with mapi id 15.20.7633.036; Sun, 9 Jun 2024
 10:08:56 +0000
X-Virus-Scanned: E-securemail
X-Secumail-id: <c955.66657f39.2b512.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ncbts6E0A7ct9OSSZUHHna+WMGjzl9iIk6IExGC80HIl4qLYmLfvfw5Db0lsxzLx/1cx/qDKmwjgOejkP6afw5y2jCNEOvy9qXtM5xMfXewjoWoRq9lDRf7Q1D4YZiUA/g2k50BVaIRIDysfHo+hTOJ2AhbX1ZXLb8JRGnl2dlXpC0J1wj79KVbwsjc3KhgSqpO48+HeERF1TbXvxrwO88PS5sAG12r+UHgLWLphiS5yaVl4rMMk5Ro01ki98PrmO7vPSdwme3Xn8YNEdbLmkOIlN/ghDKYvL5IomsVCqIfNXs9HZG76ni3Y3lg1jj4OtSJ87mRmiNc9ZlqP9Y3uIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NIrYii9vA+eWsdTWKf9b93z0+XNTYX88Wocd3Ps4utM=;
 b=WCMz3Uaxty7tgSQn8cVugwIGQY/haJmudxBJBpIDKGDgh8l+i3bgra+pmSmjZN+aadeIKyrHvupjUzQh5aZRkKBUeHSqrcfJBC6GjiZZprdcoLTGRuyu6fBXYbxsbh615mGoh1NczkAyDlgd1uJq52y8ukY4az0BESOkgn7iOBeuxkttpq6ed7Zz+m17wV0b6dPhQ5qFwozvteJqFlTnF2HUy1Bq3Ll5yCUNXxu8Jd9Pydkn0CKiyo6hb3UWMnsmKKBsU+6UZ93oi3eAB8H5rl8pLuttBATPj2Mqzr0xnrY1NvFKHvWnBzOnmUEv9Nsf4lElr5mXIIZQ05CoP43vug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIrYii9vA+eWsdTWKf9b93z0+XNTYX88Wocd3Ps4utM=;
 b=jAEqo23dh8qH5xqBhQ42xJHwDfjO8xQCOlafrU/C+zUkdgm6maMUPVXIVI4l3Bs6Jm1US7I6lE6xi6h9FtV7Wt3T92WZ/Q/kdX5gluRwdXRw7EeRBpMbCTqz/4JAGzxYhJPXMVHwGuXKB5SzTAzJCaApASfJWJIulLqHZCXYdkN4ZnqKmKeXgdcbtWM2DFefZ4KWTDkHlzi3KgxedMnVU+UylDTND3K0JO1tyakT8+OYwY0yLLeZRh71toxejb+VB7RNgb2iUv4l/T3vZ+XI5jcoASaB0TomYA43kiKQYFw9JG4WbyNJ5mxqv28pyOOWLbEhDgLwb6yKwSqdZZBbfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <a29fafc6-6d19-4dc5-a897-a506ac64cb98@kalrayinc.com>
Date: Sun, 9 Jun 2024 12:08:52 +0200
User-Agent: Mozilla Thunderbird
From: Yann Sionneau <ysionneau@kalrayinc.com>
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240606131659.786180261@linuxfoundation.org>
Content-Language: en-us, fr
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0089.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:349::9) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PASP264MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f8e0bab-142e-4d5c-4f39-08dc886c2bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: 68HUlHccZDZBQVenKV8IUBxj4N11eomFfAduD5/SlAgKMV+eLnoKOkstEAyv8SO6a2HGrxghAx0hQNOcYL3q36+EeWaVykSNJ2nfqoqiGaAtnjGMxG+VurrqOgYX5NUg8ssMhoFXNx0LYl6JI11GhPi1PvJAVBjVpaSYvs+q01iSeyuEybKw1mWxAmlvnNv+7Nup+GsoKJQAClAWhkIY/ATk1z3+am+1mdFZXsOE4tGTlcIhsdDE9zvsB+fi+sa3txV+R0Crd994yc+Zo/b8u6mmZLmJhu8sPohIr6AaXCK/bPRqzqBwH9CDCVveWe9+jdUT48cT+QeT21KYxQzkJ7EWvLif6G/KU1PgdTd7SIhmYTvvvejCZIs8phEbznOMH3GcNWF6dIDY7qxn/mAJaI2ryMHl+vDlhipLeRHleQ6PV81txZKZ9lSKuxboruSxyxeDopSHo1R8nKB5NoML/sXMkpD3mEl9RiM3cDAXxwi43HxI9ta6Ou1rVuxsroouJxXkCWUWzPtw6OrdK/dCIiM/MmN3oGwwRb/YwBE07T3HO6nP5ELOhuG3Z0hYofFiKrIlPEgnb+q4zpu6TwCyfPlYSryCvX1nyysjvlv242BplNoV8mRez+PJ50g165DL0iRgSg4VFvbTmdF5C9D1M9OtdIkP+IMrHz1MAnps6vNS00vvnyAGtT00zpTRkEM7oiSdFJge+g5oqf/ZnLZ9ft3luEIeEpb1WvME9pnX/gJfyGHNIMJVGZ7oCHvr7V4HfH1kvmonrowAGhYliUq1GLrN7aVaxzoK6V31BtY6pbpH7rOiNAPI7kUkSKSs7til7TK6vj8ICaSAuaXklmxdsZlbraKO5Ddo6NuBzH/BHFwYBGgxGz6PPAq5OwgBg1O/SvBF8IXEV6Whkwr5T3xNDguLtDURltzgXlwI1Lkg6z6lYLpNsHhfN90L8qWg6jusibx
 NbyTqAkUQk3B2Jd5BWQ3RZ6fywiYunz8wlUSHYoy63nvFtJx3jQxifegSFndCRwmqBFfsegK6YFN2QqADThI4NZQOw+3LZsqYKbP68mruYiSbcTLwu4HJNrMMURVrjCq4OryoKmA/zDbPJbwzFBC9hCKQoe2G2cq0R2/VEPjCvVgHD0a+Ngg6Shzu3V0yw1FpRl8uDhsMzOhQQZcG8BkVralxd1kLQ03rKlo6Z03hLERgpnegv8iWEmcvIjRa+YMFhqRyZY3POVg8tAjGBBeiu/jhcX7cNrFo/gGyakpzIxr3BMG44W8S8wEM1FoO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: v9yDPGyhQYXV8v1G9BfVK+UKVXvvb6ft09WkDCnAbK3zzUrEQLQHSqctANUqR4Hzn/wOf6lPgrAeUwKaQr8no8tiKk/FBeOLIOxYqxPuDo5DUvqTYk4v/bFyJSH519FAmZcyh5FqkIgH7dNWd6N46I7QzEL65DjNwRhQ4B4I1L77mriiKw6PIQgT8Q+UuXbqV31nzJVpqcU41WH8UwpeBrvmcjFXXKKanC9zkDgSJnwUuVM5aijedQOQS7+m7aRMCI3vThoanjKWrGileEOXZY+o0oLz0yIYem4HAXubfS2QLpErGyIbwzLmRYDb3P8CY2qqEqSLqrE+MAileGiyxveq5UfOMi8gf2K5kzbduM13a8YYaEp519cNSTJQqvO9+dD5cWdPHojdWjdD7vW/mMN5t1R6h8YlQZIIjNypyoM06EM0i3pW5z6i4ltUfcu0CKLfElgoycIRGlqNRX1V30z28XO9wLoCR+EInAmJ43wU3EjQF5+c7HVsAmRZ3Gefpsbg4c+AGvf7oeeRAboEOkOEZvYn8NfC7SwYETqzEtXSGEJ6PlfDuHcjHWLYx6cRn2YBX0vHfVGwe5zJNL18oZkIz+NzSoew3veMJe+mIOV1JRAi+8f4ZQ27cgjMOblkmCPQnoLfoo2W9mOaE/YZ2j2FtSbD90mcRqN2lDiA4pg8U8AE5pDjZLNHI5R1wJK5GdXTGxaCFjj8iNxNVj2rVef90iKmApkayEqMxPrwQe1WDACiEVukG7AMcsKSvzIo7frWbNbzAp6G9/Q847c7p1PxLqBy9ygtlUALAUmic5jQwXXLnGQJD3ZHZCJmZqTh5iSwu8WnzU9mQMU4wD1N2nRCck9rC6nFuGIYajY6LGorOZ2QFZf4Kok1QEyTX7dQ6B3+ulCd+h5HAHni+dg+w6wYnAAUUdFRcxC2xdpSh7GHVgHN7k08ZjL9sSYqd5aK
 ySzAnKcx4sZKFKl/ZGr2zwMOPbcFbqwmsWWttYZN0wG84ijlrLXY+Lp/vSOIEwCWsT5Yde85Gb74ZqOXDhHIS5vNs4Pm1/+RzEQshH6awYST85U74suyPihhfz/HSHXt42uVoKq7bwduarYb2G2r4W9ER0w9tYBtVNZHJhXRG4/6rt8vYuS4Cvt/jvcKhZdRuyuRxMCXCHCacaHvhYHFXDO6qqEAMqTaz6cbhGBM4ft8EgxlM3Mfrp8+NClfi5PCe5hubE2Pc7Lpgpzbz2AjwC1k6snUp14cGj9EuWokPI5VtZBV+gPSQNn854X4zVO1wAew/RiJpVGHizTarXd8mJbu27u6b1Ea/E16ne9m1D/aeHRX0PMD7Q86sDwJZAq4pGxM7j2BPJf62d7JW/nOazphtODdiMu53LrWq16H/xRMqXacZMUSOmZ8PHO14hDmKfxaGUeEwTH2QJtgMLFRL3uw3rjFPl9pzBxjx9emDD7E1LFWVv5Qez8wIC2Pxo1GAAFdb8GLUbcVkHiOz/hmFoe53vVYz26Zdt1tscZRSGO4d7rQYOgTnOlc6SmQswTwmqQBKum8g7K9LkWAvnMDCVq4eWq26ZuXByOn/tl7y5Mgop0ojxL8Y6siOOZMsagAbD3Ceg42DZqmVmiX3kO+r0TWejXcZvxQO0Jq3Qr/CoQuji7cNr9mspGyiILwsLx82lp90P8ZGuW0XQ2OCUIcbg==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8e0bab-142e-4d5c-4f39-08dc886c2bbb
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2024 10:08:55.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfGXFo0LFp8eLWpGCv3SyjmMgBzsDirIJGsWOdzJdI1IxyuF3RUrjjhk9QpUHA8qvRVwSLkDwJ8uGFD61uRU4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PASP264MB4865
X-ALTERMIMEV2_out: done

Hi Greg,

On 06/06/2024 15:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.93-rc1 (d2106b62e226) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- 

Yann





