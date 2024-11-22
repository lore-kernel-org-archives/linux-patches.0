Received: from smtpout34.security-mail.net (smtpout34.security-mail.net [85.31.212.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6967784A35
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732284006; cv=fail; b=R6eKz+0vvMnk95fJWbs9FxKg1e8zDF9iQpy2aTDNCEDqKn0KZtZvIMx82RjMF3N8NorG1hjgZJEb2jd7Tl7eDvBMGXmpVSjPpb2BkWK0r1e+sfd+n0ASJ0aLWRNMlkw2+AIWmhLhNYeLoS6Z3uQ5taCbDLdBlNE6l1uOJi64Pfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732284006; c=relaxed/simple;
	bh=rv10wlU5ToCkzzezZBainhZTGm4sPL30rW/w1jyXqdY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A73Nj+XWv1IuFF/L4gqoLYzyFJW39KZAfcheOhNzo5553ldgsypoYcXzXA5r419pn0nPZKFZF1D+1DU11ooRcergZ60LiasrnvETEfcPncVIKJakbwmzwp+Ct6DuqJWW8ppPjB5K30AxNlEhyVluvYbr5nogmIYIR0Qa+i/JPXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=l1PjxKr6; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=CqmfSLcn reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="l1PjxKr6";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="CqmfSLcn"
Received: from localhost (localhost [127.0.0.1])
	by fx304.security-mail.net (Postfix) with ESMTP id 90A345C63D6
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 14:55:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1732283717;
	bh=rv10wlU5ToCkzzezZBainhZTGm4sPL30rW/w1jyXqdY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l1PjxKr6u44U/+VwneNT3s/LA24echFlau705JT4hOfRhUEsTn6O0yOIhgx+pTjed
	 dC4EvUAw9dg+8l7wnDm3zHjn/8w7nVaZRv/TDDB+JXAIGIrU5WeOOT6AXJcYCtp8zs
	 iTRRl2i1chS2hqyJDpzn6dAw0bX6yvZRVKrwHuBw=
Received: from fx304 (localhost [127.0.0.1]) by fx304.security-mail.net
 (Postfix) with ESMTP id 69F385C5CBE; Fri, 22 Nov 2024 14:55:17 +0100 (CET)
Received: from PA5P264CU001.outbound.protection.outlook.com
 (mail-francecentralazlp17010001.outbound.protection.outlook.com
 [40.93.76.1]) by fx304.security-mail.net (Postfix) with ESMTPS id
 493EA5C5F6C; Fri, 22 Nov 2024 14:55:15 +0100 (CET)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by MRZP264MB1813.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Fri, 22 Nov
 2024 13:55:13 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%3]) with mapi id 15.20.8182.016; Fri, 22 Nov
 2024 13:55:13 +0000
X-Secumail-id: <db23.67408d43.47806.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GpaCY8Rgajf0/2geVjyBdmfbUgR+H577QdKiQnRTH5LKTjr+q4NQtjZkUH2XTX5VG3KVwDb8toKJqMU2qwsb8+pocGTkDhrqW9vMaRJda5veEiJlMivIvbxRrGUgngQI8gG+PP1R597ncfPgEenLOkewymn9/FhGFEqeGdFYm2by7SrIuHJiM9fr/3zPr700LgnJNRVcKpC0TBAAb38N9rteDsK5vr0NaYNolRjkRWlwuzkTG+YAm1cBN6mTfeCQLBQ0OgUWFoi0dyOLrmYdS+BGgeBpUw9vkZ+gEygBjz2JF+Ht01y7LzuYFMjQCYfZ43XxAVei8WZmH2c3ocnqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzBDxg2CYyDfsvW/9g6M5TU5Htyu0Hb9qt5Nlm2uwbk=;
 b=ajIHzmPQvA5vB+5nBbgdhgKQiS4mLzeDtxyOQhIgPqG/5mg2FeTL2Bj4jgFrsZScNEjBgVYXWa+0utkQggBW5rqGdrzZNMGMAmszodosxOcl9/pHRkCbA4eN6qaBgmuQB+2GKqrkhe618rjNNUp6ZXsrgg2jpnmb/p7EJCAtcT/j/5Uy+5ifUSHjEV2n/frTauPdrmQf+QQKIPsb5NGXRWLsoy68tASFawFlRpBOGV2JOJnGJemsluHA8AC67U1WODLGpYKDLJmaHgcknn2f5STI8gNl6B0bPNzqgBw4V8MABW9suKZJf5h182Fm3A6nNdG4tO9PVOLGG10dIDmw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzBDxg2CYyDfsvW/9g6M5TU5Htyu0Hb9qt5Nlm2uwbk=;
 b=CqmfSLcnZ3WAow/7Menbmby6/6vWglS9MSWOvQhSBuFxU6sti0/Ul0KXaNpRR8luF64riID5rsBLlrhOksL54QIbpgKlWmNxTYh5J3aqMAZLazN/EuM6VKvfwYOjC65HyM1aGvP4C3jeSIjFkA4yif/JHYCqROrv3aNtHUGSXU9S3JLA4F94mIrVuMTcSkLdN8C9rIEsPZfpCv8f3RHD8rRjiJ2upfPBZpKqC0UqquHPpMhW5eWXtd9VoVvKCx36NqvkFvZnpdWhMOl9EpRSMGEWpbBq8mK3niKmMdcRJ6Rmeg5yErY+zV7ToA2yvWsXmlYHPGs20s5rA42+9thAmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <959d6718-8e14-4ee9-923a-774fb0a47e9d@kalrayinc.com>
Date: Fri, 22 Nov 2024 14:55:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241120125809.623237564@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0053.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34a::17) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|MRZP264MB1813:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f10c309-3062-4fdc-e6ee-08dd0afd493e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info: vx1a30gL7QSloDMWbFmhex0wC7sZLmESTePYVH9q9wC8Xxh93NkOJJPutg68hiocQBazwZ/07kn2h5Xzm5JDL18JaXkENUq2kj3u7KpcFOvyjI4hCW3oToHfsN3vpItAXhaSNrxbJEAcn4LcuQ1xaq+yaon9sPhSKIud5GQvoGiSIJNTEmgeouoBJo6kVvyJ5OYRpSIQSm2UHuPyJKWBty4pC3FerL6bSewWZusN0s68hhk1gu5egtLVJ8cInSMG58bDrccvV7dnZDJagpgCkdPZ/rar/+rXYLLIBLY7d5c8HicVgHrx6xKrni8SHENqFDPpSUkGrr8clpVUSYu8G/qlwI24R+1Hzq0QixjtSDOUXTLAetsv09IYAKt1VsNjlfKP/uBDZj71Ya2EDROg5TpEPd3UfbDVUBkCKf2x5WehzPQv2RCIiCQFDaM9Yza1C7VPrBwMDXjT89JmU3GqGEEFhAEU7hM0+C2kmOz4q5i1HdmAFAXM+mN2qnkbI5aoKGaduzfrjRaymyB6yyAASH7LJfRwGl6dmDhv4Db0RRFWGBzqADrAUBcWw/txCHyAT4NbhBkPAo2iWaTWgv93OImkS0fTwYu5owZqWgzzRc904uF1HPfPIJxS5Lpk2ffcvxBqU2OLBTsxgX1hzV9etFs2DjdItF9KHsOwplgBPflwOfNPtvFAclhtmkZ1rd1RLk3vkkHIEqJGz4VKc4pshkOwf7FNQ7HEsmv5xhmo2AoZDsby0GYGSEbaml6KRbXeph8OFZnf92XKADmmTAaRTCPpmZd9OqZEzc3fvx+AR8uRM1+rSO7Z/qTUMnuuOJJGSqv4LDWbtLQRGQLQsLBJ9c/2FkmxaM55ssWuZb4ePNcF7meojf4FQCDOePaAeR4Oy6VXudtiVsv4Xc9qUnbn27VjMxrR8y8vlU4Eu+GROjP1KNsDN3d7Y7rvNtyrmS0GiON
 Atw75J040kS9s3bnE9PbfbgkqMPcbvFMXVhIe6MNQ9rwAsKqX/gRr722NIjqUc9XlRx0r9ny8415n15tUWwtdjSL43MaAOYL68WN6UHBecZ2fiZoF0JzJrUue9RLMJml/pRMNa2kWLUlxPYUiD+ES5uf6UpdYzmQxRdcqKUbdnjEgME/QR5O4zKHbouskRpafnUZ5tMw4+VDUBnKXJJ/CNxo8EgOiD9eTXabJ0XTLxX0axH6CRuohgZLfBTatft7V5+VksLTDEdeN1q1mHG6FhtljHgdO+GBsZYeu/serjDZIohDCDIHsn+6ATgaLeo7kAWoCGh6MZTcuSBVc21h2tB/YagkxRazq2EGYMcGeGa7aRQHkswT56c9aV+fs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: bbMzpWLVer7K8v96B4ZIcB7Z2Gr70KtzTCFKWLpRL+DphewYpKJLn+q1cIH1np33/Qc5pv8ysva7n1aA4pzTODRF7o3cZf1Od4PJul5ATO61yySESd52B9FoHwGn2zZgXbx5BeU2Z0nOfXZgzYAPuxxpDa+0vPjynTqHEbTNmLd4wS06EUFO+ulF57mfGJEjiTJ7odC4yN3PuPw5wKS+0iQUM8VZlV2C10oy5u7AZxtG1eAT/kNcGGelQlQyVDnii0hM1OcmTbu5Bx8xPpZY1y8CFWGyW1OUCUSCIiHdzqieOXS2xjBUrR07JGNmUQvq8eGLvEevshSb5O2MGfcf0UfD5v+M9jiqmMOMPmv3E6kAWt9mdpz/68hgfAEwz/ByaSKqp4M62Ns0fxky1l1VScDH7GhzO9R7uiJn47ob+PYDPYSyEpZbews9zqKtLX8E4HEDmryK3fhNiSSpM6gVioh1YcwNODka3rLNuqOOVjPJaIMUQEKb1ZmNFXZEaG2lPQHPrgy1YjHKnAXeud6BicSNbnMV0P4alG2DJ7PppzLKYmNrvEAlZ1PkRPfyMvTLesFfbDuXisPorUIAwvR+FcB5drRRC33pY82becdvM3JQjYkV8uv/upTjSl/jQ8RR/iYAM2wnWJt3jzPyDqzISnJFrGBR+ZMGJOaTvPPEWtV9xNVTMeo56pyc/sCDWLYKsilVUzOmuRGHXv8tLnOiCMkXlGd23pDjbhKodFZs41HjHz7jt3iKv2b19is9tAlfsVtxl1sKjzGBw/W4nxyCWh15Z6/3LU3JvXaraR4SNPtCD9ZeIBoo+ypOUDZADaCER0LLqWD42lx9UkFq+HQg3YaIe0lxTzip8XOQsQ+9ZVmmTHFvxG/O9WD9oRWRpRE8NDSLBK63fP7+wmqjRWMIMqj59pGFhy7bkdr/a8ftc6xBNQbspZ+tdD1ediPpjVmx
 oo9LEFyUkk0/GV+7QELeAqokFWL8dwoqZqyrweI4W4X7z2Y8RYpAnrZY67qxJ/IOSFtIeR0zDDID72fD6qhzjxMdm7vjnXhJcpPcXxfzbMiQPG+sDSS/nZAJ2JsjjIYi0V8CDKadp0nQmATXQhbiH3mYfYdxgMgsjZ37EVDJ4C7VdQGa/EnuhJ+zFzTM4Iml9IRNQfZ9lWroHN7YoKyiH1BbbYvzA8LQGrhKjkxtrKNQAtT6kkCLeH8jNvW6qEAZTs5go4YPI950d0WuoF2r8X6obibP/2VF59q3taLasTs9FO/ev8gbC/ePqaMw+1exPmQiys+nlzk+tI+VpEp5xfDHLvgf1Ks9XaTN4PsgXQ31LRYQPzIxUikDmfTKEh8L64zz7zP0qfpOBHcNqoVxp2v/nvgbYkV6hrQZKym3E6e6QAJ4R9R0bE0ZxgLNpTtVhn54322WuEiEP5JhBI7D3q2JFFRNNo1iwu42t8mRXc5kKfOBIALBI9ADqxOUu7eaV9dJib9IrylCvkSCwTD8OJFrjO6Fr1EVRH7VE5iX9qd538QTYX3F31U9UI00slgQKTPRbSFhDgnWaq7auOCCdrU8Eb6wIpuOuCapkMBwBcVocJRGkKhDLox2iyin+sJ0I42h3x449xUYMUR9lAtudtk3RCxGxecUMlc3pvw4ReEAqhibGAco1avew3FNuAYGWJ8xXvwLmc/qaJLRDo2tAQ==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f10c309-3062-4fdc-e6ee-08dd0afd493e
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 13:55:13.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpmZK7o2IVNUFp0Kwl+KUi9Xni0ZKkcHVzv+YhdkqEzT0TIvAZZgE6CfVnMHLuMeOwVBrmCWVxUlb0Cdc9tPsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB1813
X-ALTERMIMEV2_out: done

Hi Greg,

On 20/11/2024 13:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.119-rc1 (43ca6897c30a8) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- Yann





