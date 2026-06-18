Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74C52C325C;
	Thu, 18 Jun 2026 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781806745; cv=fail; b=GO6oV5vWX0pRvQuU7N87f8rRjKR66vvNKFOzPtlAf/ofaysfSllgU0xaDpcxuj8BMnSCksADnVGXzK4w9vL8I0d/b6LJdigQAgG3JdAJU6Wm0+9/ZJQlRpnWiG+0VwTxhYr1MpEszyTHd4lq/FKc4WWTokbrtaVNIk9QPZf3+O8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781806745; c=relaxed/simple;
	bh=9rhCWSOicxKzN2VwbpuvJ4olXiDpZrqlwInJgpr8k7o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I1K/1QWZShBwvYtgMBHh6xfVLTkcA0WeHDanriNtQy0NHPZc+uZmdzfGbSKe2wpnF8s9zEzPb2JCcOp8d9szptdNiJj3iP0/eM7qA/Aa/1nuOzqJfHCGuoBNvYASdFiY8c8dAkXyHqmE5sM438mPn+eRmu2J5M7rP0zATJETIcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wv4RlTGK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jloS0evc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wv4RlTGK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jloS0evc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IGBl1x788374;
	Thu, 18 Jun 2026 18:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qDRzAocNRlJmjauSf5esQt/M3hOUvEvuUIh0fiaB6TY=; b=
	Wv4RlTGKzbv9WL2Un4nmuOhtqLEx0Waza0MRcbU5qGhOzG4GbFrPTbowPC7GxM8z
	Vvbpxap1/eVy4Dq/J2SNXsg1Jr1w3QuBPQBoSA5tmnhUcmIXe+G7bHSlcDgPTSa+
	kIqrCqhxTQZNy4aLaTmn7SYXbC2vPaUxw7tfEzLGqHP+5Y/NgY+3oKumOvVF8amU
	j51C6BQdeDl/zsiEIb4nOAz+K74Vfyair+ihLPIbIEWYNqTLXL5Z6r8xVKaa6wW3
	oIsElR2YSfDyvMIKczVKN3HxqvvhwE9pseLl4iXsMcaTjbmOtH5NhrzbN8Kdfbx/
	DPBPFfmltc0k7amiFDapZw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euegm33hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 18:18:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IIIaZ3006350;
	Thu, 18 Jun 2026 18:18:50 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14trba6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 18:18:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=POkq5ongs433r8vFYvTHMaij7Ka8X/L7q6SFFAtxdRroG1Ufzud2hNVHyZknIgOX4NPz5Ap5LlRWHPNDuBkPXUfN38Ec6W7QozD3T7EYDR+49unMYn2Sqzg3fMuOdxkS5/ul8fWAjRkdx2w3Ook5gtW7ZznWJTpizhxjGG1JGL1fDRpWuynmSW7Gdc+rRoDk3QQuO5r5h0Be/pJpNh1C/TNR6BYHU70wsTNxX1D+EGQSuK3YILiPzTiUY+8W4qJgeV6AvSlhLmf6UTk/uGLEjcV8QRo05NluYWdN3m6XhQmU+hppinRVCR353UsvMc7W70bJGu2PErIx010P4UAzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDRzAocNRlJmjauSf5esQt/M3hOUvEvuUIh0fiaB6TY=;
 b=jkjpyGbvQzdPjXhV6iiZWZ6Qj/oQoqGD0cON4yixOJioMzISditNzXEX1m93g5ihNM5gqf0eok+ZHS+1Rq/BytTmKHCiW0Z8BpPEyYzjDnFYLm+TGUm8cqjw8qbu1vbucWWlhiNERsIkpFYKGml65Kj7gSaiQAbWc1HE5tvzyKmXX25XvnTGMNRQ3djF8Dzz5PQ2APjqNwzw1h6QOVesf/2JL+g3PH7Qho5DIhbrKz+Vwd1ggiAFiSsRJT2CgfJTLFMWV6lSJgYKiaKZLwuyBU1Ml+DwOOaEdjyCtW+hKD8rDZuXHbGilGyxN5Zkbek6gQLKy1Xfa5UkOQxfPN+ERw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDRzAocNRlJmjauSf5esQt/M3hOUvEvuUIh0fiaB6TY=;
 b=jloS0evcbhS1BTSi1CkiwYzVrD2qBVeMp8bsOkDZEUCBRjZuL8r0QHV/p7Jwgs/WJE+YXM6y4Crlc+D/lqXR4AYsem0VI01nIiW6/Kj7Mm1JZvPq8FgiV14GkZ2fYNbiCVeFXrO+ROLiolxQT/Y6l9rKVwTjOdElISXIx5foseA=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB7296.namprd10.prod.outlook.com (2603:10b6:8:f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Thu, 18 Jun
 2026 18:18:45 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 18:18:45 +0000
Message-ID: <b24447af-a758-4ffa-95cf-4a5bcc4994d4@oracle.com>
Date: Thu, 18 Jun 2026 23:48:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 045/411] wifi: brcmfmac: fix use-after-free when
 rescheduling brcmf_btcoex_info work
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Arend van Spriel <arend.vanspriel@broadcom.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Robert Garcia <rob_garcia@163.com>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145102.682627807@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145102.682627807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P220CA0138.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::31) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: 903a1e45-6519-4c7f-8e1b-08decd6608f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|4143699003|56012099006|6133799003|3023799007|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	piW+QuEi+p29srvnY7bShZnC2aEQbXOsbhZ8P2Pdhyjo73QeaI6JtuOViAK5iU6EIVPGyqE4qnge2OhIlZqNUX42gRfesisMq/duUTRu1CNTxW2Kb1K+OBYD9n+Nb3VQNonE3mUabPRKiMtMLV4rFw8kl7xLBeoQPj7tSlsONvB7Ma87ZVDpOuNcy3yUbZVxrH2VcUs0BMc115tv7iCtb8agaB8HVM2mBIF5hqdbyqCBB3BLFWJ09zCiexH4YiXrHpd5gsJRyx/3g5q1S/AR81OsB8kBpPuIlFGj3Q24JYJXP9I1erGofyldSKM9+1lnpU8o+n/j5B3CZ1E+SwWuR8JARXcfAdXEHg9h3dt/SkqvxwtrWEt1bHB+r3KiYutzJl3sCZxLc7olyfsAsazK7N3S5r+QdSkvKmtKfcF+VCo1R0fCPOuRtHd/2sG0IiCsVXpA+nV/ebRD2hDDg2qhLhS6mH1vlxF7iXPAPCULoOvJo/JtUUByurDhbg44rS3EoTvxgv6kCdUx6NuJwpJAFQ720ZR1d+B+VTFIszk1cOnWzLochYiv8kerTAUBOZdaLJzydfqJrd2bVIBw7p5Y/kMX4C+1g89UB4pdCG8GQJ9wfRhrNa+JKYhXqsqarIsIAxLa4QcFEeUfjY+o9W76yA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(4143699003)(56012099006)(6133799003)(3023799007)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHBYNTNxeWxQVFkrN2xteWd4eUFwWVB4MHJZdUkvUGVWeFFITjkvMUtoZFQv?=
 =?utf-8?B?TTBOMW0vUnlmVjk0cTJ6d2FLTkdTUzl3Mm56TlpPVVJsSmNEU0tPUFBTbDls?=
 =?utf-8?B?aktnZWQwa1Y4RkZCM0oyVm9jUEEyNDdmQnUrOG5kREFIM0FyTkt5cjN4enZJ?=
 =?utf-8?B?TS9sM0lkSE5GVXMvam5OQzIvcURiRk96M3NoamloQ1dxZERtMUN2V0grb1Ew?=
 =?utf-8?B?RWdhS0pvY3laNUUxd0pCNkZwdUpSbVlTT3pBYlN3THpyUnZidVFOallUYjgy?=
 =?utf-8?B?T090RnRNdWUrc2w2TGtPNmM0UWNLU2l1dThkbFJ0U2dRK2hmQlFVY1hUcXc4?=
 =?utf-8?B?WDZxQmIwWEJjZ3ZPUjNMdG9ObVNCa2JvTTgya20zN1haaGhNbCtPcXU4VGhP?=
 =?utf-8?B?cmtHYXlPaDdGVlJ4eFBRTko2d09XVjViY3R4WitSTm9SYkNwSk1XZFNncW1w?=
 =?utf-8?B?dUR2Uy9odXYyendwV0JoQk0zOGNhVFFIVG1TV2cvN0xoNDQ4VVljRjJJTnVy?=
 =?utf-8?B?b2wwbUlIVEZpSExXSkp4amFGT2Z4SmtuNlJoVlhwdjNqb2dmYStsdVI2Y3lj?=
 =?utf-8?B?SXJTMTZCMWJuUjZyVUNKMEdmUkdKdElxbStwaEt1bi9YbnBEMDh3SWppc1JT?=
 =?utf-8?B?UENESmd4QW1hdVBtVTV5M3FkOGlxZ2NHbFlyTFB2b0ZGb21MeGlRdEYrd2xp?=
 =?utf-8?B?RXoxSGpkSzdNaUhTUGY2MnN3OGhBVzd5M0RpOEFudkJPYUVGNFJxUmpDOHht?=
 =?utf-8?B?LytGT096WVpaMHl3RVZCUVZJamNGODlPd1dab1VOc090eVR3WGw0Nzh6TVBK?=
 =?utf-8?B?aW5zdnpPOTRJdzhCQWNHQjFQc2Z0Kyszdk1vbFMwcmVXM2NVYmp1VGRGT2xX?=
 =?utf-8?B?Vll4bG9PRG80UkdBOG1mdmtNcFpPT0V4T2ZxaWF1WVo0cE16US95UzFVcEJu?=
 =?utf-8?B?VUtDOWlKbTAyTnA2UWFSTUkwNHBRTFBRcTM3OXZKS0JqbjBuYmhIQ3ljRDVF?=
 =?utf-8?B?SHRQdnJ6NDFGYjR4Z2xMUE50eFc2UlFEM3UvL1Rwcms5RHBOUFh0Q3FuZlpr?=
 =?utf-8?B?TVk2bzl0cEh5MzZLMXUwSjdFRFM3N2o5cENpd1NNdUprM0VLNjBMRUhnTHRI?=
 =?utf-8?B?dnpwTFdUKzBmYlI2RDUwcDlJTDlBTFNrQVFqNktsWkpyS0k4YUNsTTdMTWtv?=
 =?utf-8?B?dVJDV3dFVnNpVElFdjltWUhzVnJQUEhrMk1tNUUxZlF1WWVhWkNhc3RESDVa?=
 =?utf-8?B?OEJ5bmhDZUhLREpJQjRsckN6c1JzS3dnVzEwYngxc01BL2p4SVRxSWFINU8x?=
 =?utf-8?B?VnRHVTAyN1o0UUtLdEE5SS9aM213cGprTHVqMGdFZEwzNE1ZS3pJZjl2ditD?=
 =?utf-8?B?MVBwbk56WEo2TUtYZ0htM3QrdWhncWVGVnFuck05Q1FacFVPRXFTcFIyUVg4?=
 =?utf-8?B?d3pNVCtaemFzMjVpM3RnVzF5RU1rVFJXOHlQNk44WmdnT0tIRGpHQ3VkRXRj?=
 =?utf-8?B?Mko3TFQ1UmFqL2piZWNtdGUycjlFcXNrajJvbVdmYXJGUnlNRTdKUDg4NHYy?=
 =?utf-8?B?a1ZaTDZPeXVjeU9zYVkvTXl6Wmc0UHZiTnFaTlIwY2dJSWhuQ0gvbjhOM042?=
 =?utf-8?B?aS81TXBId1NLVm1CL1h4SEhqYVBGR0JTOHlPV0xxQzVnOWVmVjFic1lXRFZq?=
 =?utf-8?B?Vy9UdEVJYnBjSzVBYmFxY2tNNTQxQU95aTVxYnh6bjZiRGl6ZHZmL1k3QkF5?=
 =?utf-8?B?Vm81Vi9sU3p0ZGxYaHM0UWlkMktXSStzVm4zajZUa0J1WXlGS1JwQU5pVzJO?=
 =?utf-8?B?dUk0bnAzUjV3OU04WkViWjlObFVwRVZ6VENzL2RUTnpucVlxNlpHZkFsUnRw?=
 =?utf-8?B?MlZaOUMzMGJXRkdodTl6OXkzWU1MNklPSm1DWEJsYWVEQWxxNlBmOFdqUzZR?=
 =?utf-8?B?cnNyRU15ekp6TUVFK0RzbDM5Q3pCZGRwcE5La2dIVWZ0Z2FPbmNYVHFSenpi?=
 =?utf-8?B?NnVyNEtDWDdvVkwxbURVblg4dlJHMnRnNWpuZ0RJM09EbFQzYUNzeUtWZW5S?=
 =?utf-8?B?VXZ5dUlMS295TlA4MnZadGRSaFM0elU4d2x0aGNyQWZoTlFSZDdRNUtuOUh2?=
 =?utf-8?B?a2xWMDJxalJGZ2FBTHJ3V0pTTjVEVEtxQnRpMXVHSHJkdTk2U3E5UE9CVzZD?=
 =?utf-8?B?V0xtVHE1Q0cycVQ1eXVZZmhuSjZ6dzFTSWNzRzI5RXBOeHA2TFZLOWx0aENU?=
 =?utf-8?B?UkdnYzZEVjVZUnhJUXQyYlI1TjdDNE5iRXVkNjlBQ21XTkRVb1hJQXl0MWZr?=
 =?utf-8?B?Y1FrWTRSN1JxYjBWYXNIVWt2bnFOUnhLa1VBU2xWNjQ2bmQxWEpOT2haNVIv?=
 =?utf-8?Q?48ww7DDVdouodImwZ4zzgKWeaHBfqYmm8VDF5?=
X-Exchange-RoutingPolicyChecked:
	oCIL7ZKhJRIJg3m3/+Awjs/v+cPXwZ+yIpl8L3411VezQ5/6lo0V0Xw1+v2lEXEYzBhk1zsBQXiHjJk8I1kG3S5T0LQ/akEwlytIxYI0xWLYStJmmnogTUe//8sIegOULJmKiBOYl9v8k5YgcjEv9JwxMkAJOcW8imFfR24x9252kt8qqe6DPE0UQ4i19b9wGBWY2hxCElwX3LzP0zvJvp6ZsqqFqo5sso2YgT/0rJktRXVbpc8XGWRiIzUgq8lhXNYKx4pkLDfOHqmJt83d7/LcPA3wQWUgyfUQB8LGfUgtYUFxBzUtrJNEkQCQ8QeL17fzUFX2FM1Q/cX1/QgojA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TetMBNDQv5q9qbcpnj0Jm6lia+HJv7OddoSfaDf4XzF4rH3f2SbqT1gWaBQhJn+diCZykcFDHZksgHe8BXdNXofbn9cKuVRwgTsXwraYTxhQRewj6NTzvhPy3xtWRdUdlyxUeN6pCWL67puOteQN5r1h7XEI9igeIwy2R0gusy0ZfbAEnF4PuNHW5pbaA3aMxhqrd5Yt1K0wMdA/f/4RLvjKVyTyKfRKpZKosbhRJygxGWIN30NTaqeTS8lrvqUKoA4sKz9+q+L3roL98FF7+MgeCK07nKJNtcQT8Rj0QCFj/7otquWr7lufAsYhM6bPMiGBHZo3pTPmxbCl/16vwPiorword5NHfWVej+dnYjsw9WomfwM9PuiyuA7BokxjJlR9yydSK5W/xtKAgdl1DT1er6cbZZNOTbEhU/bA2nBd1mAh7KdltJ2ogb12yUXoTG5zk+2TjXbm0UMR4reBKUefC/k3baWRkt9jvR1CK2+8fKeA1YHova6bsxH82SHLXmj5455/d/XdsG/U9/BqniiSdh6B8pNSqHxfSebiTCQ3qi2IqoBjaDoA+4xmD2Am1Gt6U4fEVlraNgGCE5UdnkjYScvvd4ZS8kZNNvAicoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 903a1e45-6519-4c7f-8e1b-08decd6608f6
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 18:18:45.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjrmS5Og16k6nWjBVdP27MPdklEwsAO2miMFWEHUFo2AIo6BoutRfgQGEZscJEwBF+uHLSUIEkvX3MZZq6WsOvnQor1oezbEA8RNxJP4cega9S2KEK/h2Ypg31Kgy/oW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_03,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180170
X-Proofpoint-GUID: yNblACJweUQ-QyI3gwtgQRgrfMSRJP8T
X-Proofpoint-ORIG-GUID: yNblACJweUQ-QyI3gwtgQRgrfMSRJP8T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDE3MCBTYWx0ZWRfXyl3m6q1iNfFM
 UOoFK6TvybVj0PYcKcxkarPXEU0lJhxZfcYAQU0VmVKmPy0fEC9lMbc6H0L0GvAghgcoIxew80I
 IdCXscuJbZf+VL70aTEy2trd/Essn3DL2/jEkpyshB9o6MkdpqRiX2EOKvSJmZm7ZXud/YJ7UVq
 qi7mkpu9ryKVY8FXQnErwObvJ/50ud0lxIA2CLontClnO7PKz3b3CXeEDS9ELYUZbbGycYdieaK
 IhX5IWZ3WqtgCIKFH2vhJdYHe1CxPNAru4bEVqbFK4vl9zNFcSOPgJ7hwgZQrDxN71tAqsLM4tG
 klxv/wj9eNY9SneKdUboLIfJQ9Fq/UHPEMzqIF0SvXPxs5ARyuJPVIdAscH3tNYbWAqH8akm9qD
 5W4Bd0lb+fX0dbqEh0ZGIDH6W+/FE7+FOLEeq3Z7HajxrudizuW3cIIjeQd7zN2wTQpzoNx1fab
 0CGlmpFbPzKrlp6wjRJ9XIbIuahSX2KufhY096r8=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDE3MCBTYWx0ZWRfX3iejMJfKtHAx
 RadN4k7HKdVKOxinqXgKs7onoCjAyoTW9S4irFDIYUPmlYFlY9I7HKZ8ENCJItaQnRw7TXyRFGt
 8ua8/llfZ3aOLVJQrF7gCBYCkfM3kXTGut8SJSnIdiEt5dGXVRPX
X-Authority-Analysis: v=2.4 cv=G4Ys1dk5 c=1 sm=1 tr=0 ts=6a34368a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=bC-a23v3AAAA:8
 a=Q-fNiiVtAAAA:8 a=QyXUC8HyAAAA:8 a=Byx-y9mGAAAA:8 a=VwQbUJbxAAAA:8
 a=8Fg3trD0StBx1J9-ZcUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12312

Hi Sasha and Greg,

On 16/06/26 20:24, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Duoming Zhou <duoming@zju.edu.cn>
> 
> [ Upstream commit 9cb83d4be0b9b697eae93d321e0da999f9cdfcfc ]
> 
> The brcmf_btcoex_detach() only shuts down the btcoex timer, if the
> flag timer_on is false. However, the brcmf_btcoex_timerfunc(), which
> runs as timer handler, sets timer_on to false. This creates critical
> race conditions:
> 
> 1.If brcmf_btcoex_detach() is called while brcmf_btcoex_timerfunc()
> is executing, it may observe timer_on as false and skip the call to
> timer_shutdown_sync().
> 
> 2.The brcmf_btcoex_timerfunc() may then reschedule the brcmf_btcoex_info
> worker after the cancel_work_sync() has been executed, resulting in
> use-after-free bugs.
> 
> The use-after-free bugs occur in two distinct scenarios, depending on
> the timing of when the brcmf_btcoex_info struct is freed relative to
> the execution of its worker thread.
> 
> Scenario 1: Freed before the worker is scheduled
> 
> The brcmf_btcoex_info is deallocated before the worker is scheduled.
> A race condition can occur when schedule_work(&bt_local->work) is
> called after the target memory has been freed. The sequence of events
> is detailed below:
> 
> CPU0                           | CPU1
> brcmf_btcoex_detach            | brcmf_btcoex_timerfunc
>                                 |   bt_local->timer_on = false;
>    if (cfg->btcoex->timer_on)   |
>      ...                        |
>    cancel_work_sync();          |
>    ...                          |
>    kfree(cfg->btcoex); // FREE  |
>                                 |   schedule_work(&bt_local->work); // USE
> 
> Scenario 2: Freed after the worker is scheduled
> 
> The brcmf_btcoex_info is freed after the worker has been scheduled
> but before or during its execution. In this case, statements within
> the brcmf_btcoex_handler() — such as the container_of macro and
> subsequent dereferences of the brcmf_btcoex_info object will cause
> a use-after-free access. The following timeline illustrates this
> scenario:
> 
> CPU0                            | CPU1
> brcmf_btcoex_detach             | brcmf_btcoex_timerfunc
>                                  |   bt_local->timer_on = false;
>    if (cfg->btcoex->timer_on)    |
>      ...                         |
>    cancel_work_sync();           |
>    ...                           |   schedule_work(); // Reschedule
>                                  |
>    kfree(cfg->btcoex); // FREE   |   brcmf_btcoex_handler() // Worker
>    /*                            |     btci = container_of(....); // USE
>     The kfree() above could      |     ...
>     also occur at any point      |     btci-> // USE
>     during the worker's execution|
>     */                           |
> 
> To resolve the race conditions, drop the conditional check and call
> timer_shutdown_sync() directly. It can deactivate the timer reliably,
> regardless of its current state. Once stopped, the timer_on state is
> then set to false.
> 
> Fixes: 61730d4dfffc ("brcmfmac: support critical protocol API for DHCP")
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Link: https://patch.msgid.link/20250822050839.4413-1-duoming@zju.edu.cn
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Robert Garcia <rob_garcia@163.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
> index f9f18ff451ea7c..f46e4090021777 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
> @@ -392,10 +392,8 @@ void brcmf_btcoex_detach(struct brcmf_cfg80211_info *cfg)
>   	if (!cfg->btcoex)
>   		return;
>   
> -	if (cfg->btcoex->timer_on) {
> -		cfg->btcoex->timer_on = false;
> -		del_timer_sync(&cfg->btcoex->timer);
> -	}
> +	del_timer_sync(&cfg->btcoex->timer);
> +	cfg->btcoex->timer_on = false;
>   

I ran an AI assisted backport review over the 5.15.210 queue. I think 
this 5.15.y backport doesn;t really try to do the same thing like 
upstream. Why so ?

Upstream 9cb83d4be0b9 uses timer_shutdown_sync() before canceling the 
work and freeing cfg->btcoex:

         timer_shutdown_sync(&cfg->btcoex->timer);
         cfg->btcoex->timer_on = false;
         cancel_work_sync(&cfg->btcoex->work);

The 5.15.y backport still uses del_timer_sync():

         del_timer_sync(&cfg->btcoex->timer);
         cfg->btcoex->timer_on = false;
         cancel_work_sync(&cfg->btcoex->work);

The timer code in this 5.15.y tree already documents that 
del_timer_sync() cannot guarantee the timer is not rearmed by concurrent 
code, so the key point is the difference between del_timer_sync() and 
timer_shutdown_sync().

I think 5.15.y should directly use timer_shutdown_sync(), as we don't 
have commit: 292a089d78d3 ("treewide: Convert del_timer*() to 
timer_shutdown*()") in 5.15.y, thoughts ?

thanks,
Harshit


>   	cancel_work_sync(&cfg->btcoex->work);
>   

