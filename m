Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117041D86C0
	for <patches@lists.linux.dev>; Sun,  2 Feb 2025 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738503124; cv=fail; b=P0qC2pW1H8gK/MoOEGFIkk6UBEPxovAgSBylBCvgmdsp3qXIW9Z4U0dLUjOUsvnuuvP70I6U63PvxrxqIgYbCFf2tUI4iALYFoeXHjurTcJDeZAn0JR/y3rvbVCaSUVzj4N5JDhASGtbtf7WRn3OhnyU/8a+GkWTBwn8jPFWXps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738503124; c=relaxed/simple;
	bh=TKksWsAc6FQevOJj6+NMllpb9kCWA48YYdsWtKkmL/Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RNO6UMP0YyWLGKasyOZUaYqJnRpExMZaE+UIe8xMWzfrwOi0VgRG+JleeQG4z4W985Qag+UzmN46eWWJqqJqP8rjx/aKPaa0PTfhZvBnvan25kVJTXprWLO8+mTCduG+VMVhxVmRYMe9BV1hikT/hSMtUqFiCk4ThhCggIkaFnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WaAg699s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vpeWGBEh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WaAg699s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vpeWGBEh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512CuOCF005652;
	Sun, 2 Feb 2025 13:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=zpB47pfPA5/1jaEnuRtghOtm0SVPM05Im2w7qBGSrL0=; b=
	WaAg699s8MPM62bv3GCVFqgA4gwA04kUgRv0DCaucXWyEp9kOhc9yEV8nI9ExFqX
	tAE6Fq6PC2TSrQAt3UlUlLU4rm467iSnQT4Iwi7+apqtplUkVP1TDiaznZ0+FLHv
	lbtzmJfSqsGVWqJ2+jFAD8HuwcLya1NesRSYc6UCq8GLdxjS8DxW5QLdlyz+/pby
	oXYd8NlSv9lhBNIgOcVMqFJ9lihGiPZhuPeK2JTYFNolBU0Vk39QAPicn1qeNHgv
	bcT7t5+WYwLztKZ/RGtfxheinSY/iwHn/fz6XRnutFRHdLnlqv5Lq72AplbO4uOv
	ogJyDXDD9XR7GWZnHAXa0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbt925x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Feb 2025 13:31:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 512CNfVH029074;
	Sun, 2 Feb 2025 13:31:49 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p0rvjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Feb 2025 13:31:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTB4ceC1xnfh/BIPHm7gcFdkY5rtLfYGDa3Aq8TuMnvoqkGXuntYwbsfQ+tTDUjU92w6XjG/6rQ9dbvqR46pc2C3gebJAiKtaUKoTuYUpuyrXeqTPlFgMZSbz0PBxEJM23RQ30MD8Tl2keVAtkvgBnNplj7X3MTRnVvilmWT+4HJCGCPyIRCr8Yb9gwfR1cm0FAzKVTpVfBAl/P7HekxbRBBsDLs5Cpwhvey9xHnj5JvDqqz+Akw0dcGMbd/a1/BrTNrg9XHQ5i3W7o3glLgFkmrHsMJIfDW5nKZtGQKw5+SsmzZ+9PbzFVpEvirCCw7Z6RHlwOKeOSf4GPpEIZy6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpB47pfPA5/1jaEnuRtghOtm0SVPM05Im2w7qBGSrL0=;
 b=V1v+YRe/dfhhMxBqWEsV2UDjStzXHUo5d9FSe9D992Kksocec+bVn35pdRdirJ+opLs4zLQGt1I3JtCNfEvO20T5nxfT1RyxevNrvkN1Nrt1ZXYAjE8a6GX7kJx6Das6pOmEd8Fnxv+CydAfoJjJxFYpv2RdWicySr00t5l1NoFCPXhtu6mvD53KIdLsKHZJeO6qYRxsJs1zZOP8FCOuoZbp4hHrWgW88BhPjJtGKnXHC7LQwl5jKEKXe9L3PjYDR/zjRrjx7t1WQ+x6HDfDiLrzjT2b450Riea8Y6Mi7BDh0+AIlSzHYcAvi0v1Ut3fMhFGOIBPPIva7lXrvLXvGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpB47pfPA5/1jaEnuRtghOtm0SVPM05Im2w7qBGSrL0=;
 b=vpeWGBEh5q3gQYBomNX+ExWNRfVbJm++A9GEXe3My7a+WMbhvq49iX7c3mpHgi3yWgBR2xX7yzJ6CiKZ7fwrJ224BXO+3KKNEYb7PNKU/j6mxEkM8B0dxrQ6i9pIWYzWrcem1mbsDP8xh99GIP95JrtxTWRKEWyfZBbe/vq3dj8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA0PR10MB7381.namprd10.prod.outlook.com (2603:10b6:208:442::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Sun, 2 Feb
 2025 13:31:47 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8398.021; Sun, 2 Feb 2025
 13:31:47 +0000
Message-ID: <f3942a3e-844f-41a6-ac54-fed5c8f3f447@oracle.com>
Date: Sun, 2 Feb 2025 19:01:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250131112114.030356568@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250131112114.030356568@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::10) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA0PR10MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5aa043-cc76-42cb-af27-08dd438df138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0dLWlBkMzhRWGFVRGxIVnI2ZTFNNFdSdU42cSt4QXJoNS9jNUNISWl6WnBl?=
 =?utf-8?B?KzdYYWhObm5KVVEzYjhyMWJseFZ6Q2diS1JlajFXS2F4c2hNUFkvZ0poYXhU?=
 =?utf-8?B?bWc2dWh5WjkybEVBZ0Yrb25OZTBHOXd0dXdEU0loVjJSV2wrdXhjQ2U4NG93?=
 =?utf-8?B?bVRVTm5WUUF4VEU4Y0wzK3JhUTFON3p0bU9LQ0wyNTVaQmVzc2ZncG0yVkNO?=
 =?utf-8?B?dDhyNGRyVitJV2YwVjJKNkhGMEt1UUllaEVlOVlzaTBucmNmaUdPR216Zndh?=
 =?utf-8?B?ZnkydEhYYndMdWhDMHFmUTdKM1QrREtTQi9XUGdPOThxdU1ic1doc2FLUjRP?=
 =?utf-8?B?N01SQzRhaWFKZnQ0SXBrMlBReGJ1WVZYaS9MVCtMMm9BRy9BOURnaDdpb0dP?=
 =?utf-8?B?d05TTG9ZZXJtTzFkSzlpZ1BtQjdJNUJHV3JzVzd0ZjZjOE5Wc2QwaHUyL25p?=
 =?utf-8?B?UVRDTHl3RXUxaWphcFFLZXdoQ0V5NUw0dnpBM1dFMjg2NHVYNXJncUpUOGJy?=
 =?utf-8?B?YTZ5d2ZSRW9GaHFvNGlOS0dGREdvQzk3MCtrUlBUSXJXTk8xamcvTGR3UFVJ?=
 =?utf-8?B?Z3JRVGg0MHpzNVp5QzVBS2FUN0NQRU1haWZ5MEdMUC9yNG5hRGZsay9GMzBF?=
 =?utf-8?B?ejEra3h5USsrL29WblEyMk51MUJNY1hnbkdVSWJyVm02ZFo4OHVEYXpaa0tU?=
 =?utf-8?B?bk1lUkYyaXMrTGs2MG52WFA5aEszK3JacXorT1VDWXpLVzNCamMvL0pkdUdp?=
 =?utf-8?B?WjMrblh5NDlsdUZ3aG9FZFJMTnRheFVTbkVUSkpBUEJ5c3dpZ2JDMWRIeUNk?=
 =?utf-8?B?eU9oWlBicTJyY2ZIQlV0TXRZLzh1QVZBbnlPem1HRmRRR1VJZGdiQndhaUVD?=
 =?utf-8?B?U0RMZ1lTR2l6WTZRQmtUaXVWMzV1MVFqdmswVGhvUnQ5Mm4wSWV4UUMyZGFz?=
 =?utf-8?B?NzBYWHFNRXhweVZCMmRaOTZ1azRRVWtCTHRhd0tIMFNrK0lJdzFPV1RkNnda?=
 =?utf-8?B?aGN0bDRnNFV1MVdTQWlrT2pzaFFlTnY0V0JMQllkTlZCaERTUzhvUHBhV1Jv?=
 =?utf-8?B?Yit4VGN1c3hubUZRRENXdFhxVGRvb1hUS0RsOTArMFgyajc5c0dZcmFKMWxK?=
 =?utf-8?B?ZXNqelVqV1AwbE1BZ1ZGZHE4V1lBcXdKdHdyVERIT2lIdFJPc00yRnhWRkg4?=
 =?utf-8?B?anppTlkrelJsU0hPTldxT0p5SUllUkx0YXh2ZnZvUjhQSWZOeG5MMHIyVzhh?=
 =?utf-8?B?eDlKc2JWRzhKUkZxWFBSdllvS08yQ29uT2ZjSjFIWXlVc2pxcDZQcGplWktP?=
 =?utf-8?B?bjBDR1JRRTBoZXJ4RlE3YzlrWlUxNGZ3a3FxOEZ1NDhIRFpwWXdvZmtHQXhY?=
 =?utf-8?B?anY2SGVXYnVsNXNFYndtSHM2WG5xdWN0TWRrcysvQXo1UFdva0k3OXJsbHB0?=
 =?utf-8?B?SnUyYnhLK0p6c3diRkhHTGNRRjdhUXRHWlRaSFV4Qzdkc2NXZDVlY2JlU1h0?=
 =?utf-8?B?ekdYU05HYzlORThrcll2N05GQU4wTC91WkZlaTlDM0gyTFNWNStDVXV5b29D?=
 =?utf-8?B?THF1NWdHZWt4M1lNQ0FyOHFFemRPWVpiSjdQQWZTeExsSUgrY2NoM0tqL29z?=
 =?utf-8?B?cmFoeW1QYkx1eUI2WEx4cWd0dCtJRWxaeC90WVFodTBQQlpRSFFnMXhETE9h?=
 =?utf-8?B?bVdxeXpNK2tUbjNiWlRCc3FWUnF1Z09zRVhuQlB5VWZmREJTd0FPd0ZWblp1?=
 =?utf-8?B?QkFCY3NXZ2hFRks3TklHWW00MjJHUFpEWFhoQVlNNUN3N3M3UVpncnBqeUpT?=
 =?utf-8?B?L2tqeXpVRXlaeG9pdDFyZUpyWUNtYitRMEV2WmZkWHhhNjlkZUVyZUdWemV0?=
 =?utf-8?Q?+5+77+Ri3S65A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckI5TUF6VkIvcjN0aG8wQU81b0RlUnhFNGlDK3VXVFlhMVpqb1M2b0FXWHRR?=
 =?utf-8?B?dFVwOGNIODh1Q0RGcTgvcnp4b1h3RmU4RUR6RERDTDdIMmxocW1PNGNDdUht?=
 =?utf-8?B?YkliTVdON0drdGs0cjZCR2tJNHR3a2NnazRHUlEwS0h1S1NHZkt4d29uSzV1?=
 =?utf-8?B?S09vcjhYQ2NrMmtXTHl6RWh1eFVLNktrWi9NaWFWY2VTMGJPbzFETTlCZXhX?=
 =?utf-8?B?MEhzTFFzaUpkN3RUY3krdmc4L2luZGhLcWdkdVdJNVNNbXZxd0srUXdrb25m?=
 =?utf-8?B?Yi96ZjQwb0pQQ1p3TDhPMzNUbUxLNEVYa0JxVmQxYXllZGFBM1daVjFrK1BJ?=
 =?utf-8?B?aXVpVGtGc29FQXAxNFhlUkZtY0xEcGQ5TjM5WTNCZi9JQVRTZThUYkJlMGs0?=
 =?utf-8?B?czJVempUQlNYWHo5Sy9mMURMZkc4U2x1NHVRL3BUY01sWUUwTHVESmFHRjYy?=
 =?utf-8?B?STl1Z3ZURjVZWHQxWi9rRGlwVnl2NGJTdkJGNnVFYWwyMXg5aksydUhuQlJX?=
 =?utf-8?B?Z3R3aHlkODFXenNrSEczdnZDdlo3bzVxQjFZWTZJcDI3ckd4S2QzV0hXTWtE?=
 =?utf-8?B?VFpWREpHTmw5d3JlT1FzdllmS0lTWTZ0M0YvcmZqYk1hdjBhWTR1TXBaOE50?=
 =?utf-8?B?UFAvUVdDY0xFamVqdThSOEc0bHJBWVgwc2U0RlB6bXFuME9Bd2FmckV3S0Rs?=
 =?utf-8?B?b1p3OFpwS1pNcjhyeGVkYVdIeWo0aFNyQm5jUk9jSE1KeHVwaFVJYjR0b044?=
 =?utf-8?B?UHEzWTNsS1BFMFhWRW4wdElNSWVuc29UbkRWd0NxY3dZSnJzd0VIZ09DUCtv?=
 =?utf-8?B?bTZlc0Rvb0pEOHNTbzJ4NCtGZmxHZU9XWFh6K2Z2WFNoemhTeUZKa3dNVk5u?=
 =?utf-8?B?TUFXZDcxdzlvV2dwcVpSRGhINlRFdVN2U29GVEVYRXJyZk5uM2hWcE1kTlFY?=
 =?utf-8?B?NFlraUdBTGd1VWxhejlHMzFtREUxTlNXSUZoL3FSZWpHQXF0TWlCZCtiNm1J?=
 =?utf-8?B?WXdUSHRqNURncVdHTis4NUFhNi9yUzVRWmhkVG5LTzVWOTFOckVmZHBrUkFj?=
 =?utf-8?B?U2Jlcjh2R3QzRytsTkcwMEhwa29CQTE4ZlFadmFZRkNZVXpFZmxFZ3ZJdlc5?=
 =?utf-8?B?RlBVRHBWY1JXQkJEYnp0Z1hEZjdSS1ZBQjJ5L2JSSFlTSHZ5ZWlLR1RqK3dR?=
 =?utf-8?B?MElNejhzTTdyWWMxSDZFWUR1dUthL2QzKzVaRFdKM1ZjTFM5NUNIVXB5RzhN?=
 =?utf-8?B?K2FJdUhUTHdTNVdoYVBVTThBN21rdDZKQk9McWkzQWVhVSt6aUJ1UUVsQ2VD?=
 =?utf-8?B?bXZlVldTWlpNc2dRTkNxOU1kQ2VQU2xYb2k1azZrNmkzSWdaai83b2hYa3N5?=
 =?utf-8?B?em9kMmsxSkpzbE9XRll4NlgzN05FeHlOempvaVNOcGZpVU1MYWZUaENUTFI2?=
 =?utf-8?B?bmNzOTU5dXR3MVA3cXBzdVFTZWZKaGpMd3VvcHNtRHRERnRKTUdLcFAwT3VM?=
 =?utf-8?B?Nyt3NjFpU0tza25jLzVRUVcwOURWenJXUFZvbVV2Vmp5WUZhSXdMV0pDSzlp?=
 =?utf-8?B?dUhqc1gwWVF6OW5kVTF4U3dNcVFDNWpJUXQ5Qm4zbVZrZElxRG5QcnVhcFRW?=
 =?utf-8?B?THUwOWRnemNpdzFUeWpNeTAvTFV5QVFhenR3ZUlLQU1lQ3Q1S0djNFZKeVZl?=
 =?utf-8?B?NFJtT2ZrcDBvM0RETTJVdVgvaWJ3dkR6eEVSRUlPNFpVTEZWeWY2emNQWWpR?=
 =?utf-8?B?Nm92SE1WS0VzTDkxa1lqN2h6V24wc1VFM0V1ZHRrZ1ZNWDhqSk1KR2JGYVIr?=
 =?utf-8?B?elJuVEliaFVqcng3dzh4dlJoMTRCalVVOUtLaHdsMXpCbWxLbUI0WGhLOWYy?=
 =?utf-8?B?Q3NDbjVZY2pONk1md1BBL1lRbHNxN0NHUzNrSWE4VkdFTDdOSnU1MUtTZ1BT?=
 =?utf-8?B?YnRqUEhac1BTTXVTUk54UWlwbmdFVzJ5R1BqV01XNFBuQ1hlU3cyYXVhNlE4?=
 =?utf-8?B?VGZMTE1yUTIwa3ZnMHAzVi9ZRDkwdlNkdVJBQ1VpMVljZW1ZMXk3OEpUY2w4?=
 =?utf-8?B?b2ZucGN5ZWJHemcrUi9vOEdnOE5VYkNnZmlUeXJKOGF4UC8relIvZzl5cmdH?=
 =?utf-8?B?V3pyWmgwOHR6UEFPZGRSSnJQUVRoOURDd0psazN2ejNkMWQ2aHJreWNEV2RQ?=
 =?utf-8?Q?mRW4Al4eQsfk+ZGiyZgYGYs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DKmAC+8SoWq97SQeHDTbok3xcVsHcNKr+6cIgLPTmT1RNrSR91LAoycgW8FSzArf78GCaZx7Et3dQtNEIdFDEq1Aa7lVTeQ2e/H1RrWTdMzZU0rPfXQx1x6t4MqSuUQ1Bj1z6KqhvV+bW9ThjWXj01g5GpqgKHkn1n6/cF+8OJCMZbaYP6MxyF44BWEty+VNCKcwhNYSXIuZAteAFUjWxeZTNQLT6w2cifTDYVkAhX0ZTiMeTvEJfvDF+ybnlMp+fpm7Sqwkkq7LP1GUZVnDLHe2drbUQuaiNNdgiJVjymq49JQtdlh8DOLwFaJeslGo1nr2QgrMZz/iJgblVrpmVXBidiR/nEqFgWc3Ke+zEYzPuhywdSepLyDRxR7b4uSN8FVYObJr4uJe9tv9r9PMugvVEmLYqbac++gHxtAu8bbNVeUrUtYF1iBzTwXtr2xWbOD9gmG+wqr/1Sj7Jdmqu7W5hs1uikaZmLWQjgsqRg5DjqURRgL0avWQr639/rlDgPE5IRlFkyDZp9wsUFVl8ChHCb1+zCIaUNWqqY146cwCi8AtA7uMcK3Hw5e8NsxyPyl9oA9MK6UIZijS/66yB0ifPSvq4aLV8TVcBTO92XY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5aa043-cc76-42cb-af27-08dd438df138
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2025 13:31:47.6145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooXoHf5teCVQP8SOVB8gWngo8f8TvIPK6/MwCIpVKWk2haK//RynUsB6E4PiPvAT8tHi7Hxd7nhiNnduOUenpn1oNSnv2ss/xy0rpuS4lhec5Qu8jhgiRPVgoywsv9wT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-02_05,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502020120
X-Proofpoint-GUID: IMZqRXG02TScXGJLd-qoO9VhAWsTCPkK
X-Proofpoint-ORIG-GUID: IMZqRXG02TScXGJLd-qoO9VhAWsTCPkK

Hi Greg,

On 31/01/25 16:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Feb 2025 11:20:53 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
