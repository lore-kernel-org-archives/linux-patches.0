Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72320B657
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723989691; cv=fail; b=nVJUsuy2VTAze7y7F30dtkM5afHzsleVhTAtjdnE+v45LrEUWJqfygHQXbOheDSN1AafW3Eg97PNz90hX+Vz5OE5UEsnFFnD4WZ15kCUgmw9eAe8Dq6ErliGxM/4gDkBdxGQi+zULb71VAV3JYjfHHkUrn0lZki65IdB/soObko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723989691; c=relaxed/simple;
	bh=hpPHjR1NfpjdBLBukzMT9mem6AgsBZxj81F4KtxtDUw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lW0Mtc+ZNjXgtmV0E/8aRZBZk4gu99ApM3jZOSPeKu+ErsXHF3fBpKxtmjjD2MI1mS16EVMkWK0FJG88Wr/fSjw1bN9AIg/KkXmys552RcPTBIf2xF0G4NohiGJpQfyRKd1/c0xrBHTL8Y8BiXoLh/aD3wxVN28rQdFbJvYkNxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ngKe2aJg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UgyTm01A; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ngKe2aJg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UgyTm01A"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47ICP2Co020688;
	Sun, 18 Aug 2024 14:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=EXh6yDuAmNLYa4SEaVh8aGYtlgsA7JOD2MLlUynYAoU=; b=
	ngKe2aJgccab6fUQzyZpUEYYetj1EjvAsDogohYs4LwM45lD5AcMNfTJ464M/yEY
	RtCIfj44Wx6IAMfTPfROa6FfFZYaXk2ufmuAodYhtUbTYMFFpyrvsJddkiDDaLUF
	jGhRbKrcPtEiKihXghL2tfzIboAjr3lzJn7z24PfIgsuiSjL6cYp+qnAGt04oYqo
	UvgwmyaFw1Me3mbytPN1g83srX2dacw+7z3/DQuB+6L4RxLD34vOduYW+dq37Onq
	xIyjaVWrjO06ssOpilJdzDFZC2+1Itv8oTRtX2Gdm9JkkLFXq9a3jA8fsSNaim6M
	0JBoEpcS3amqYRxt7vw0Uw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m4us8hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Aug 2024 14:01:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.17.1.19) with ESMTP id 47ICZmwu029696;
	Sun, 18 Aug 2024 14:01:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 413h3n95dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Aug 2024 14:01:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dp0ogXHxNV5BmtwDuv+4abyIx78moGOLWsaaQdT5/T9U3KUnZGiVNt+uuaI/MWUeHdGJHLEDZRemUZz1SBPkWrx9k/Ri1Nu/jTl7xQwq0eOaykPk9waP05FUUFs4TdxBIWoyYPwlkAGzGQ6r1CgMB2wlOgdMpZBq5gnW0dDr/JnU7L9lRTLof3UU8ZBETcip778bAPqWEsL8PvF0uPIaS4M/Ubz1h/x5V07B6975OIFWrFnr7H//XqIKH6PbY+zpqj4e6hHh9LioHU+Y9FKd5XLZpVgFJLXBmCn5kMVtZdSDT2M99yQfdNAOnChU7ImilEIqD7NzH3ShcKOdi+LAGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXh6yDuAmNLYa4SEaVh8aGYtlgsA7JOD2MLlUynYAoU=;
 b=ThRW7O9mu73MhRdAlQDnoyDilYcwmx1QedDTtzjg9TbaqrP/Nhnz1fDg3DGNqhM3Slp3mrwxY0ykQTVHaqvnJ2O37DvOv8t/gjhHmg2KSTvHK5QGJgnuHmld5wURKsKiSBbE8kpc5CDazvDmjXrRo433uP3w47CZA88/NhraDyvavKhv2FZcF6FrImX3pXo3/igPS20+96mmFvYb9Q7TFvwgUk0T/4gMgmV3psrr4nm4Fg2mmmEISbpawxjgFyt7+gF/6pkxRv6JD4HYlwKfqAhkbT4hSclPKNzBDvGtfd3WRRRlQV5ny6rkyXfXnYGEmxy8aQrN6gqZgB7YdedBMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXh6yDuAmNLYa4SEaVh8aGYtlgsA7JOD2MLlUynYAoU=;
 b=UgyTm01AnJO0TmIjD485yJ8+gSjEGe7WxZwrMswK5dCdXk2TPxhHe1suuQBVf3RBB+Bag+MlMcDX2KCcOcj5kKt4TyldTdcUI2bGbnfiytlzQNP5twxC21goLQOzdm7qkjfo5zKxmuYYnHzvJX5mN/onh6kaF7EuEC/ebZQBEzA=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MW4PR10MB6323.namprd10.prod.outlook.com (2603:10b6:303:1e2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Sun, 18 Aug
 2024 14:01:06 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%5]) with mapi id 15.20.7897.010; Sun, 18 Aug 2024
 14:01:06 +0000
Message-ID: <24f542f9-6690-4ce1-9596-f0bb92eb45b9@oracle.com>
Date: Sun, 18 Aug 2024 19:30:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/196] 4.19.320-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240815131852.063866671@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MW4PR10MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: bff0c3b3-f876-4db4-d5a0-08dcbf8e345c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UytWUGo2TDZVVFhrWG02eEN1eFVQU1F6VmYyb3N4QUl2NmZXVUZPMTBXd1FG?=
 =?utf-8?B?S3UyOWF6N1BGQ3Izencrek14TC9nMkN2V0JFK1VtcnZJT0hEZ1hmZ1E1UUhz?=
 =?utf-8?B?SktwUnc5ZVV2M3EwRTl0WTZ1bWlnWFplVGpTV1IrQ2x5czdrUDh0YnF0b09h?=
 =?utf-8?B?NDRnajBYdGZSUDNRWGpuUldXSkEyUzQ5dldGTW5ER1NSekRPR1ptUDlwbmxT?=
 =?utf-8?B?blozVzdCR0orSTA1Zy9EMlJLVVhqU1ZacDllb0p6L3pGMmpGeEFtTkozNnJQ?=
 =?utf-8?B?YjVrQlZmVUdmUm9LYUFuYVZRQVVmZ3dram9aTk40UW04YURUSXMxTEtWVkpV?=
 =?utf-8?B?Z2pUUFFWV005cEpQcWUzWVU0NHFrMmNrYjN1TjZEZXg2U0JRY1k2RTFIZE83?=
 =?utf-8?B?OGFaQWNxLzRaVDVzbnJCU3BRZHVTQ3gvdkZXSFV0azFUM1RmeDNLbW1DcEgz?=
 =?utf-8?B?czhhcVdmRE9yd1M1ci9BSGx4YmZKZ1ErZXpRc3RFTGNHT3lPSDZWRkFFcENm?=
 =?utf-8?B?UVZra1FVUGNhaWhwYmN6VWR1Qlk5REcxaXBMU0NKQjVmcVhVc3dydGR0WUxI?=
 =?utf-8?B?bFNJR1AyYVdXelkxck1Jd0FnZmFJOWFqWkI0MC9lcTlOMmlGa1pEODFkeTAr?=
 =?utf-8?B?Ymh2U2t4bm9xMTNMTXhPakZuWjU2UDdFcENuMHhzYUVpOGJicG5Zak5PR20y?=
 =?utf-8?B?blkybE9ITUlObThsRGRQZDJwOWQ3QTlWVmFoUW9veXEyNVg4ckZmUmJ5VEdZ?=
 =?utf-8?B?NHoxODBNb3g5RU8vOURBcjBvazRiSEdPbXBDdEdjT0pWVVVRTXc4b25obEl4?=
 =?utf-8?B?b0xzVE4vN3EvS1FWQzVIaUErdVpuc2UzQ0VHVWgyemc2MGRlUVNkOE15L3VZ?=
 =?utf-8?B?VjZvdWxZV2Q0dllHOG5Lb3cyL2dybWRBazBDOEd5aHJhUFRBWFFUQVNrSlFs?=
 =?utf-8?B?VmtPc2NLKzByUXV6WUlVOWpuMU5pRy80MDllN25OaEVpNHUvSW1MQmhPU0ZY?=
 =?utf-8?B?RmJPNDBHM1kvckxSQ1ZEdWhkaHBGTmJJSFFhWHJwc3NPRlFkWmZMUFJOMzRx?=
 =?utf-8?B?NXRpRHFJL0g3Nlg5anVCWGFjaXpjVkpjUitRRlZHTWluMS9TUGtST2lXKy8x?=
 =?utf-8?B?OHNyRDVGRENEZHpTcDNtUU5ySFFFbjF1eXZEaVlMQnI5TlcxUU5NOVcyeVJa?=
 =?utf-8?B?QUc3Vk95Rjg2NHNubGQzai82RytMajlDUFd4Wk5KbGY2K2RremdCd0U4MkVL?=
 =?utf-8?B?ME56RDF2dU1QVDgzKzErS0J1MVFEd09Camc4Q2hDcEZyZjM5N0hmaUZya0d2?=
 =?utf-8?B?MkgvVVVHemZEWEJadW9rMWdSUmczYzZEQ01RbXFvVXN3VlJqZmU3WU4vc1Uw?=
 =?utf-8?B?NWFYTDc2SE9xU2J6TC9GRExReVZ2VUJqZHB4OWhOdVkwV3A1MjlNUHFmaGRW?=
 =?utf-8?B?RCs0clk3SjVJR21YTlNWTktZaVhxZTNBY21WSFRFWkJwdGV1dDd6T3JjRGwx?=
 =?utf-8?B?cU9ST1phU080ZFZrdWlrU3JCa0xEVDNBaXcxS2U2NjlsTFlqMHdCMTJJeFJN?=
 =?utf-8?B?aHVwdk9XTnV4MXJVQmhGSkNzOGtjVklmSy9mNXQ2TTg2VFpqcFhnK3hoZ3VN?=
 =?utf-8?B?WEltaklRS3Z0ZEZJeGZvN2VGdHVmL1dWLzBrVVd3dUhqVmt3aDRHS01SdURo?=
 =?utf-8?B?ZVFxVkVueEY3SWdMOXZpSUcwVUxzTnFNUjZRTkV0Sy9sTDg4UDdoUWJTWEU2?=
 =?utf-8?B?VzFoYnlyTHJ4SlJ1NHN1T2FtaFVlTnAvYksxb0JnbFJvcWVIbExSa0dTRHpC?=
 =?utf-8?B?bGZtczBleHJpNEhXY3YyUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkZBTXZ3K1g0QzNyV1lreFBhRW1nTW44dnNSRkNVd2ppZjZzMExqdUxFdElo?=
 =?utf-8?B?YkpMdDN4ZzY0bHFZNkFUYSs5ZUl5MnFHdmwwUmlwSWk1Mk0xakU0NXlmRVB0?=
 =?utf-8?B?YUFQamNCL2JlMkw5NGk2cks0b0poK1QyU09yUzhUa2FyUDVZdVAyajdHOFg0?=
 =?utf-8?B?RWxVT3lRcHNQbUhiT0pHdzNnVlp1MjZOdndOeXovRjZ5aHNWaEl4WDlUcDNt?=
 =?utf-8?B?SFFsZHhMZC9RamxjOVF2RjZSckFkeE1GQ042UnVaMkFhUFBzbmNVN0NVSlFp?=
 =?utf-8?B?R012T3NPSU1KNk01Rm43aWRRRzhlOGhVYUxBTkQ3dG5pZ2JUUDd4L29XeTJj?=
 =?utf-8?B?dzlmc3BVWXhGYlhCZE4xc2dteUZONlQ3NGsrbklkbVFoN2cwcGRocytoMzRJ?=
 =?utf-8?B?Lzd1anpMbk1DL1paaXBrZUxyOGNndUxYU3R0NVZDcGc0dm9mckFQSmNzQzlD?=
 =?utf-8?B?S3hFcUhvMWZJbDFyNFl0U2lvcWdlZVV0TERyMGk1MisvYTRoT1BTV2hsemU2?=
 =?utf-8?B?NHIrN2krUVZZVkp3b2lKbjJONE5WQzF3dm8yUnh5TTZ4S3huaEpGL3dMeG5z?=
 =?utf-8?B?ODFsUDBURTIzdm5QdVdPR3k0TmNRUlFqWmV1YXo3ZHhKVW9aOXFLNGlHU0Zu?=
 =?utf-8?B?ZmhVL01IS09XcGhwNGg2aitFM0lHVmhQZzg0RzdWeGl6NFp6UndubUJjTmJN?=
 =?utf-8?B?RkdRUithalQ2R2I4Z0RYUEtIZjNMMUZra2dReGUzSkZQWGNRdGl0cVdmaDJm?=
 =?utf-8?B?ZGRUdUlPQUFBZGhqOUhZcUJuVGFlQk1uTjBBbC9VL0tvMVVVOEkzMkpkOWpX?=
 =?utf-8?B?Rmg2cnJvd0twRlQxUThCZHQ3bkZEUUw0MkpjYkxyQ2Z1SUxLZEVtMlkwRTgz?=
 =?utf-8?B?TU05T2ZTdXo2RXpnMGZlNm5SNlduS3BsWm5ia0xHSnVDMEMzQzJTT0RSdkVZ?=
 =?utf-8?B?RjR2cG1RdFRlUEd5UkcxT3Z6Y2lBOVFNREdWSm00VUNmT0lCb2wwUUZCY2do?=
 =?utf-8?B?U3N3ZzZpckNDS21QOTl2NExpb0MySEwvY2xYTUp6QlRoOURqTjhmOUp4azdD?=
 =?utf-8?B?WkpqSHNjTEY0MzBLampoOTVnZVRxbTFCUWhmWGVUQXhMU2JRZWphV3V4ZlVk?=
 =?utf-8?B?QzZVeURBODA0aDBJQW9aeFVFRHcyRFlPWUw1N3BkejhpcWxVUFVBRDRoY1hm?=
 =?utf-8?B?UUNRZGo1eE1QLzZBeEhZWC9VcS9pNkNUY0VkVzFxNGlTYm5kcytlS0FNc3J4?=
 =?utf-8?B?YTZEU1d4SHhGaFpEcmdqYm14R3VFU0F1Y0NSejhGc21DVWNXNjlEaXlqaE1p?=
 =?utf-8?B?c1F4aVZoRGh1TVVVUXRnRnpIOXhRZVlGaHdSS3N2QkVGYjAvaFlXeWMrYzhr?=
 =?utf-8?B?WVFOdVgxT1psTGxrZFdxTlZYZVkzTTM3bkZtZFQ5VTZFa0l2azBrR2RsK0xM?=
 =?utf-8?B?TlVuaFhZMVE4dVZ1S1o0ajcyOUs2THcyY0lGZndvakJOZnlJMjRlNlR5N1JB?=
 =?utf-8?B?QlRpWW9pQUdIV1AwWkljL0hqdkRRS1ROR3hUWjVic3kyNDMwQXJnMHF5WDRZ?=
 =?utf-8?B?UnViVndjQk15ZCtMVGg0QmRyNUZYN0JibGVnRGdTNnpabTlHQ0dFOC82UTVW?=
 =?utf-8?B?dU0xVlp2ODJWR0d6RFB0SVA0dG9jd2phL1h4ZXJ2R1hpbzI2aXNVcVArN256?=
 =?utf-8?B?c2thTmlkMlJGS0hram1WWGhvZ1VQSjJVNFp4OWNKSmx0Z0UvaWRhN3dRYUpn?=
 =?utf-8?B?OGc2cDE3dzdORHpUd1JuK3RvbTBOWGZFODVmOHFBdERTYi92WS85aGRScDNT?=
 =?utf-8?B?a01oeUFYU0txcTBXb2tDV0kweUgxQlhDU1FnOWQwSGFMRnJSMEZsZ0JKc2p4?=
 =?utf-8?B?Ukx6UWVwbElNUUdwQWg5R0haVXRUbGFMTGl4TmswNmVKYmFmSVJVRFlGblZY?=
 =?utf-8?B?Q1pUdURrVitEWTBYSVZERXM0bHBxR0NEcjh4VGdYMzZPd3pwMUZUNWM0T2Ry?=
 =?utf-8?B?cUJaMGpuY1BrcFpMZEhMWjNxcUhuNytqRjRxdkh3VjlwQy9vSFBocDllS3JM?=
 =?utf-8?B?Q081TkpoQWFTQWRyWG4xUVl2VnBqNHZFR3hZWDRCdjZxN25aQWY4Ny9NeU1s?=
 =?utf-8?B?SHI5K1BRc2x3NEJZWStRTUJ2MHRWalVtazh4bGpLaW14bFczL2VOWVdVTXVH?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3nbNU2TBTOAVIa8ugZy4pDyQh8ynA6ZR3Jc8A1+QfxRqVF6sPSqZRTSyMU8fLLVwoRRdQ1tQ4w8cC8BeTbCi13Yy1DpVgFFu7xPX81zGqAGx1JJuemRF70bPG8Jf6d5FVUTlKwIOo8aYzz6gOrRzqnfMOr/rcoIfjkk8F8SCW2VxCS8RLTQe5ABQxW2AsVeEfiEV7AHPW8u6cR0qsx25gkOzq9M5l/lZDEw8SZddgBlktRQKwiBMqfve5hOQdoSJqW9SOouVfmAjKdGRIXBD6eDcCsPlj9+RSW7nnjPllpY8QqQDfjTKiXjR2zHgV2kFQHranl+tEmPLIiiL8FYIXMBut3Aa9X4eVssTQfroCPCnHqbykDaKrR1T98gTqQH79xM3VkmTC/8KpgQcNdEyFHy7YoeRrNsO/YzBtY75HuLoJlK/4UZFPQZjMimd8OkYXntTxFZZscV8sWYahSx073Dbn3v4rwRAB1aKugPoR11vIS2bdxpWybP3u+L71E/o8aMoFj7v6eZmDksThouk98dEtuXpvxv7X2KxOibfcx41BVAx3hJwYqHJRblhkvSr5/mgh+Uv4pvfSznZm5GUiuJvu4ZGaQf50Xq/T2kC/Fs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff0c3b3-f876-4db4-d5a0-08dcbf8e345c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2024 14:01:06.7142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVI+85YjLv1mhFQAps5Xs6cfHJWkfKpUUst5zufgu6tD41LwCyElm4X1JHpj5QnrDrzetSpTnrioKTTyWQPdsLlN98oHUdiz7eGBe1yWdk6cylXBk8A52ymN2uQNTnNx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-18_13,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408180102
X-Proofpoint-ORIG-GUID: yO_hdkPw39K683ogQgj-3kNfJCBT_RcD
X-Proofpoint-GUID: yO_hdkPw39K683ogQgj-3kNfJCBT_RcD

Hi Greg,

On 15/08/24 18:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.320 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit



