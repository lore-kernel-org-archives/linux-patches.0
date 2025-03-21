Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218922D023
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 07:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541339; cv=fail; b=L+LUX0PNOr06gWgZ7/OSv9r54yx8aS1Dt/hCE0oPGWSHnS/iXTDvigc7hHcVLbJCvkDIFnhqBvYC+VgafUIohiHhCNfIUvrzh3+RO1dpcTJlPqAor24jyDYXbCcKcACCNZeKgAs35IwWc8Dxut8vzuDdewouv/NHcpubyURbhZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541339; c=relaxed/simple;
	bh=tpLO3MjYWdBSM4CseoJkawutBs07WXjJ2R2MA431ZoM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uQJSDDMifrapVJqoUrcGLDQ9N7frzZMeo3dkYig65Z9+uA+BHuQwMar/85wyKPgjw1Suz1gkowFr1q6dgMsWI1I3Z4iE0297kNUYFuJKaBu0E0dRwcix0UnP/Z90e4Z6b4HRBDcbIED98INfjuzSIsrSXSDpilXVLmjFFxaDTtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ewQHGdXm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vnIbl7m5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ewQHGdXm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vnIbl7m5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52L4uCV4029356;
	Fri, 21 Mar 2025 07:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=l415i8PZ5wNULMBcE0p6iLT5mI15FhAT8QGEd5vkqSc=; b=
	ewQHGdXmnVc7jJFkJNM+FtEfFitYN/hTjkiCq2bwFJNrAIJgFleLzflGwiJstspa
	WLbGWczN84K6tu3qwm2VEsFzVr+7Q6mYST9evO0mdM4fc1Kpy/odrmb4x04YYrcA
	XE8gMPbpC0THoXzecW6hGnXcOEMU+JlTwUmyDyLTwn57fyuSCWM/MzeiBhy2tN7/
	IWCamQ71Y3pD7WyDNPLyW39+/t19boPaLoTwgOU9OWaOGjg/aKbZAKL8r5ccG/iq
	0libpJWqaaOgLGYklXQe3ilrhQ1oS8eD6msoq2izIXgOb1bxfUtVY+sCcZn3p5pm
	iGcC/QiZXmEyNDYWItaVCw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23s83e9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 07:15:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52L6AFJD024329;
	Fri, 21 Mar 2025 07:15:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxbng17h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 07:15:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Chi6rh62vYaaHQs4jRcNtcQfK1AGkQrHHgvcgbCYQDUTjblE9zPZy7xDtlQ/p3Fnh5XhJkV6QZMtjsr6ZHOjSjABJhb5shF1w6Ciqe1uH7uk5ZeTDM2okHXZnItBwPJi/xdyF223ANFXB4eOKeYjSd1SRj9sTRMJrditH6iXIRS0AaaodHDy1J6u7BDPgBeFc6L14iafdFpcLudAfczM2+62uBobXDJeZ2l74Jed8tNrVnNpFruukoZ2p0vzHiySN8gWbAGVhVXoGqzyMW2KLdUw+K1qNiM2JxEHCBZe2lz46pdinhlN+noQnTcupH7q6+WI3D/IQt5mGEimAHuYBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l415i8PZ5wNULMBcE0p6iLT5mI15FhAT8QGEd5vkqSc=;
 b=ejXbtvoKd/D/kjdiMLgNJ3DcOm7/EaAXkfCpvMe8X3BBjfHAtxXNBYDidKEJmMCIB8vBaxYfzA8pJl48s+Hf4emnvSlYAW77foLV5ODMRb5R2BhnM3BEwpdbDlHbI/svT/QB/IYCf/W/brbrP6Xe6NrlpulmZvAg1hdqO/7Rd+E0Eiug5FAfDEK8scmL2Yt0Siv4nvbbkiWVZHQrcU6wWCK1AjkP91KRvwNLHUTMMYk6bQVOqwaTclvQYFgFzhvfV4jFQjYFfNZyYZcZfq0NCO/zqxJaXDBNz8el47YNdcQD7qNSlg7MFE1kTK9VT+S98AgeDsi7I7ScV1UD87gBuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l415i8PZ5wNULMBcE0p6iLT5mI15FhAT8QGEd5vkqSc=;
 b=vnIbl7m5+L1xR6MNjH4QGHI7J4GXFmYPfRbqPnsRfDJA2KoqdDQRay5/V/0WlJBSrgqdSTZmowbGSEvGcu9mIIX+ssmNjO6QLG5G6mtBXCNtyHMaih5Qz7qZwZ8YQJ2wjFaevXcr5pdFmDxGoytSiRYL0+coTJe8OpUTCw+gJIo=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MW5PR10MB5807.namprd10.prod.outlook.com (2603:10b6:303:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 07:15:22 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 07:15:22 +0000
Message-ID: <03519996-31cc-4656-8957-3a9e6d23b789@oracle.com>
Date: Fri, 21 Mar 2025 12:45:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250320165654.807128435@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250320165654.807128435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MW5PR10MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: dab6c1b4-ac56-438b-2664-08dd684824ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVdVdHhzdlJmbFdTTS9OcW9SYmp5ZVhGM0RkMXBSVDVkRzh3akp4QWpqTFVt?=
 =?utf-8?B?RUJkbWJ5V3VJam5Zem90WWRWOElUaEZmaGxYcUlxK2VkSW1FYm9PUjBXMEhU?=
 =?utf-8?B?eEE2ZVlnbVpBSHQwM08rREJlTmROYm5DamkvRmg0TE5MUDlFUXVPSmcxbDZr?=
 =?utf-8?B?bFR1UkloYkwwZjhLbzhBWWJmYmFWSjdETEFYRlJqUWg4blc4bEQvR2QyTzQy?=
 =?utf-8?B?cWJ1OGo3L3pGQ1lENjBjcWRDbElKTEcrQ1VoeFJnVUVnOHh6azBvbkNEek44?=
 =?utf-8?B?NFI0WnNuZWpnTXpmdmR1ZzRISzJiY2FidVp2TkMvSkdjMzMyaGpBSnc5Ni85?=
 =?utf-8?B?TmhQcXFlYldnTlFGSmFUczBwcnFyS2FxTFlTc3FPWVMrak5QcmJzZEQ0ZkJ4?=
 =?utf-8?B?djB4UkloQVo2elFZeUYzbzd0T2ZPNjN1ZTZsQmpRalpINnhQazBiODVueCtv?=
 =?utf-8?B?WEE0OHBKbkVCN2JLKzI5ZktBSmczZStFenpVazN5RFUzMmdFUkNOaW5aeTVP?=
 =?utf-8?B?ZjBtWXc0NldhNm44VFcrYTNGSHhpT2Z1Y1BxcGwrbWNDZlBoRmZVTHJuejVx?=
 =?utf-8?B?SnZlbFdoYzBweTEzcVM5ZTZtZnJlZzRyeU1CalBzeElWd1YzUzJQTXZhc2lP?=
 =?utf-8?B?L2hUY1hMZ29VUkdjYTlrbFhwSHRFazRWK3d4YUlQU3l0TlFHVjBSdEEyWEM1?=
 =?utf-8?B?aTFuZEdkNGlDZVZzSlZ5VjRtbXpZNkZFTWFqb3dIRUwrQjRoYkFSSWdNbDJR?=
 =?utf-8?B?K05yUmpkMjlrUUY1bmx4ck1RT0ZNN3FDZFgreEJGUkFyUGV2MGlZUWU3SnZ3?=
 =?utf-8?B?M1BvODB6WFFpT05lMkJrdkNOKy9ONTZ6djRQczRwUHJ4akNCamtTcWorNFU1?=
 =?utf-8?B?eHYvczhQdW1CK2xUcGIvRmhyZTBxWDJ3OFJ6eG82aTZHRnVPMXZtNktuNTJI?=
 =?utf-8?B?cWFpTG5MdDlsdDM1R2dFNzI4MkFCSXBrVVREVzlvQnQ2K3Zhb1FIN3NXU21K?=
 =?utf-8?B?Yi9YOWk2NjBRSDRJUSswVitlM0MvY1VTYzFPTXovMDFmMFJsNFgxVGJNMmVF?=
 =?utf-8?B?bDhRVi9mcGIvN2FINnBzYTlOd0pFUXpRSDZmUXprSUtoV3RWR1pqdG9ITVJP?=
 =?utf-8?B?RVFMWTE2eXZ4cXBEbVlHVEV6dUIwaU1QZFI2MVdmZWFOUnN6TVNITncvZUUw?=
 =?utf-8?B?VWlsQjhmQVJWMnRjbFZwcWtxS0dhWDFYYmFYaUFuSHR4SVI3LzJmTzhqVi9h?=
 =?utf-8?B?VTBqSkVORkNKVVlDOEpEYXhWTnd6Y2xteXNtUUR2TnpXMUhBMjZaSjRJcUtR?=
 =?utf-8?B?MXNVK1owMlNScE5yMVNsaHVFNG9qazdadFZTUUx0L0RvbStYT1FlNHFsRk9T?=
 =?utf-8?B?T044eDRUZ0dnZ2pCeTFJaGZ6bHV2R0lOalVlS24vY3BnTnlCZ3A5OGxvcEEw?=
 =?utf-8?B?T0o2WnZQRHdoWUxUdlozS3lkR0h6VGMwclNzaXloZ3Z0YnJVeE85cnpIczN4?=
 =?utf-8?B?Q2R1RzBHd29FUnZBYllqOUtJdkpldmdwcWN6QkwrdDdwaWNRTElBVVVWUlRT?=
 =?utf-8?B?MTkzYVlZU1I5bm9JQk5xTGNMa3dnMGJ3a0k4dkc0QXRqSlFXanU3S1E3U1hL?=
 =?utf-8?B?dzA5UGZkQ0lXeTJRTzZxemdic2l4R3VBaXdKb1UwNTNoa2JUb2NJV2pBZm9p?=
 =?utf-8?B?YVpmZ0l4RjYzSmFtZUtMaXh6cGRXWE9CV2YwMWt3VWF0UTVaYVR6RUNJQW5k?=
 =?utf-8?B?OGtuQ0N6VEJISFlsL2JQbzZDVE9UR0Rqb0llVUNQalEyQ1Q3S0ZQd3huTGZL?=
 =?utf-8?B?KzNOSE01RUJ2Mys1dTFTbnl6MVhvWVJHM2pNUzFFcXcycDY1WnJsem5DU0tO?=
 =?utf-8?Q?XzH/YSE3ZRGjW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDFHRzhkaTgwUzAwOWNoSGNEMjVza3lRUG45S3dzV3ppeFBqZXFsRlJ2dmRE?=
 =?utf-8?B?YjJldTA1eFFVcjdZR29KSUowZitDR1dEMThiRWJPaVM2djV5OExhNDE2QnE5?=
 =?utf-8?B?VVhOM0RyWVVIWEExTWxCc21vbUptb1dzbFByclRYOEFTc3B6ZThVVHhFcnFo?=
 =?utf-8?B?eCtwL0lGK0ZjdGpjVUwvM3FkMmtUNmt3LzRoNXV5dWw3cHg5ZFVVM0tCVWNF?=
 =?utf-8?B?dUF5VWQyZXlvUVowZWZldE5WVThiSkErYVFtNkNxK2J0bjdMZ0llSnphOFJQ?=
 =?utf-8?B?aDFNNDI5SE0vVi9LT2xtdmQ3ZjFQUnNaM1lKQjBwK08yUHlDTmlzOEVuZ29Y?=
 =?utf-8?B?NTVNVkZLYVgwbEZoTE1yT3lHYit3YUg5cHRscnJnY1UzNmh4QjRwSkxJV0VP?=
 =?utf-8?B?QUN1WE9rYlZsZFFzS0xCUWpSVTdsdmpEL21TMHJGSU51RGVFcFZpeW5tamxS?=
 =?utf-8?B?QTFCajZlTDZIdGgvckVKSzk4QlhEWVBxbXB4MExGVzVRUEs4WWx6SmRCVGZW?=
 =?utf-8?B?cUhSdTh4bmRWVlI2N2NpOGU0OGd1WVUwT0JIKzVaODI2a3pET0tsQ1JZYWpp?=
 =?utf-8?B?dlVkL3JnYXk4NlVpcTQwUkVSZTJzN0RhUVI0WlVuRHFqVzNTVGJLMjFxM2g1?=
 =?utf-8?B?eHZCYmpCdlBHSmRWb3dXMkg4aUJpTGlIbi9DOGxKTW4wMjlydXhFU0VmRzdy?=
 =?utf-8?B?RFFrZkpZVUUxU05WWTBRQVNDOC82alMxT3krc3VhaFM0YzdVYW5RSjBHa21F?=
 =?utf-8?B?MnhmR1oraVBaMHZOeTNyS2xjZTVKQmdKdkZNeDk0VG9OaFNZdDVxKzBNdkRQ?=
 =?utf-8?B?K0xZTzNjb0w2VXZaV0xjbE15RHNhT1YvNHV4TzJnTFpTakREVytZZlNCaVBQ?=
 =?utf-8?B?Y1k3K3JxNU01NUhlaE9pSzF6UU0vSWdoOTk0STBiekQyOXFsTXFtbml6R2Zx?=
 =?utf-8?B?bGllbG41YWhCTkFvSnZMSlRHdzNiVmFKaUx2emJteE1DRWU1MzhIbHF6WFlR?=
 =?utf-8?B?QW1MQmVNSTIyRDhXaUFyUWhibU9aRmtiWUUrMysrM0o4aUd4dXdFSEEyZjFn?=
 =?utf-8?B?M09nVENtdnQreVREWjI1NEIrckk1TXdxc1dsUjkxbE9jVW1zaDMzdFlqbGJQ?=
 =?utf-8?B?WHVSakF3VkI3NnBKdDdxKzhuekk0WUluanpUUHpyODBpTEZLTExZdGFhSDcy?=
 =?utf-8?B?MVRTaVphVkUvSlVIUWlGUE1sUDNGRW1jNFRKL0piZDJOVzlVSGNsZGprakNy?=
 =?utf-8?B?TEIxcCtYUVU1S2xuK1Rya0RsNThxNFlDWjdaaldwdGdWN25OTDFYY1JQckpY?=
 =?utf-8?B?b3Z2M1FnNFlqRmtUZlY3cXh5UlFuRExsdm1ZWEhJdnZhb09SMFNkNVVTZ3o3?=
 =?utf-8?B?R2dBR2FpNGdmb3lRaWpqWDBSWTJjMFg3WjN3VitNdWlVb0dtekZuSE9SWDY2?=
 =?utf-8?B?a3hscFN4aTJPMVR2b2pDNHN5dXoxSGdJd2ozZHVsWUV5MkdKU1NEeFVGczMz?=
 =?utf-8?B?ZkVOMERLc2VpbndERTMwOTBDbitvV0FUTG5uSEUvczFhNi9mLytURGp5ZW05?=
 =?utf-8?B?UWdNK1dCUTVldk1CVUp5ZWtVZDFvOCswQXZJbm12VjRsb0xFQ05pdllqN2RI?=
 =?utf-8?B?TFlJK2Ridi9oRUMrOW5GOE5TREZuS2xYTDIwbXNzMk1UczR5NEF6NlN2ZzBU?=
 =?utf-8?B?TTJvL3dBdGcxVU5JMzRmMzkyTmJsU0t1WHl0WGJQRG16SmZlK3p3eXBRQ3o3?=
 =?utf-8?B?R2liVm41TFRKblpQQlRTaWZ3OFpsRlFIZWxkMjJ4R1RFVnJERDNMVHh4Nnly?=
 =?utf-8?B?OTFlWUFsUlNPbWl5ZXczbzNJN2diOTlmK1drc09lL283Mk5WVDlqaldpSDBn?=
 =?utf-8?B?bklKd0lvcWduaWM4bEczSHI0S3BHRngvNFhVd0E4YnJreHZQeFJ4eUUwS0Vk?=
 =?utf-8?B?WHdiNDE1ak9IYnI2YXg4NUtnRE5mRE5CSmxpUjg5bXR3am9tbzJ0TW5USnNo?=
 =?utf-8?B?a3B2c3FPK2RkbERBRTVhVm9hZ3kxNlZEU3QzMFZLc0pHdGF5ZmxCejRyWWNP?=
 =?utf-8?B?RHF2TTY0R1ZCaGFsZDJuRlFVTTZ2NnRuNm85elJ4WlVGNXNyVXZVN09iRS9u?=
 =?utf-8?B?MGRhbVpXdFREZWU4RWxlVW9paVdDOUlETURmS1VINXQ5NnhLOHgxOVh3cjFN?=
 =?utf-8?Q?UFeQoDY6Wj7aJ4uEJzezqJo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V+EG0Ba/udXNjWRn+jUC54OC4NFr2zFtmXL76HWeucfS7RgyJAswQAp6KV0TOGxePyXulZBnZGDEeyjaYRd+nuWLITd0LoxBCrykx5xSQW1+9sg/9fjWfa8bCNMnvcnO+ZFpNJtTP55gFBmP6LaWUwL3V9VUdXCWAel5CiLyBoid1zdro2HWHrPbcY75fjn4g5ELFCPRmtLgTTP1j1R+mOMxJJV75IgYf051nUB5s64/fNdTJoN8Px+YSjIk3+Cp1TCcp1cUUnGWh074aHeDVIXTwLd63zHpJLz92C44yWPlxza8GpB9kv9VS/vLD+Wu5MzmSjUlX9sfWDfG8HBxDVoFN3QUhJv3OugIQ0WnnVPgljbX8w+cselKvsXCEbjf5RDppPxfwkUgI3Ni9/s2gZ7gJ1SRpbkvBeeQWrgXVYN2ElCXIaaPI9z906d+hUe5goIKGrhQpZYxKfOgNFd4P08EMCMzedKyuw9gCI4XL1bzCyk6+LLR/NiFno0ImH0CdWBJIC+kFgoVtK3ZTsvm5L0rTD9ZIkMvl1O32cb87zd2ov0GbCt16ERGjrBr1GorKLitMTiy/8Am04rZdkXjTQBBXgzrCFgq/XODq1vZHSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab6c1b4-ac56-438b-2664-08dd684824ea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 07:15:22.5757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRiZfV4qkXpKe88tooVcrwa73yGi76D0tOentZH8vmSokDr6u6PbtLCuBn+6Xpdk4jaq+Lj//FlnyDbjvICj+bPmTC+OavXe06HjFxflRSOQXDmqIi584L/1bfDBopAM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-21_02,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503210052
X-Proofpoint-GUID: 0oeYhn1rbmkNMTFKzqQGtVxyI4icIj4m
X-Proofpoint-ORIG-GUID: 0oeYhn1rbmkNMTFKzqQGtVxyI4icIj4m

Hi Greg,
On 20/03/25 22:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
