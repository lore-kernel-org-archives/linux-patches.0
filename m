Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DD32E644
	for <patches@lists.linux.dev>; Tue, 14 May 2024 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715704135; cv=fail; b=VaRIpTk/9Fr4PrBE+ELy8xdCBaO5lnQsVFKC9aUGtVQ0emKjexpq/18baiVOFtn3MkHBL+/dX1rAhQn9wGjZZ86pjLuEPYvD3Poxb+EkxnUbL2lEyB4N261DjOb1V13K33pK+48RjYfpzjMtRbHLAyF4K/pWIaAFF1tZBWY1JFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715704135; c=relaxed/simple;
	bh=4Ovpb6z0Qg3sAlnal77p3T40C6smd7zfYJkeoTft7Wo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iemrqeoshn5OgY1jX1/WtjTns58CUwCO+15eZgW0dHs67vDVA1iI7wsSdNKNaGljkljeIoTp/SOYUB/69vgrfchuXVsNaCG8qtlPupP+is+mks5ZvZWsgT/9LJoctOxh3Z/GKHVm04nfABUaDfV7a0+65gJBPwJNO8yLjELgqu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hn+rO/uW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UJ4LLRcu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hn+rO/uW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UJ4LLRcu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44ECgBbC008672;
	Tue, 14 May 2024 16:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=rXkS6KktaIzbMVTBz5mNLWIPldc5wq5FxLNpg3tedlA=;
 b=hn+rO/uWP/6bRrcoZaBqP6mJgxMd70bw3wrXnhQC0YKe+PUlhtr5Z2r4/bABqDFg7uEo
 wC5dNHDxBAShoVftlCjsTx45SVgXuBDJvvavt3RCNxM+X0vnir6ldlpJHQ5bel3hYdUc
 inBnNK7vA93aXf69tnxNMTvqYtm0bUtn34WmOR2gzd4dlfUCQRvTWe7pRAdhJH4icaqU
 qfOAB/3MepbX43/WHnY1lC46F4FlVI82ZySx1MlvCYbbFF5NVWPTewzWU0PmC0OoAQ8H
 +LxxNzimWMBYEGsIinMkvu/eZdr+2emBI3wSs4DTRWCRHaPlp+5cbAFnVTbAdzeGX7qP eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3tx8hrf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 16:28:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44EFnt6A019232;
	Tue, 14 May 2024 16:28:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y3r8523rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 16:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewx8d+jNEhKitrGQl4F034vD+CfwXBLHINgYjKER11ZvSm1yXo5UmEJckl/7tXbuZwOzo6gW9dtiE22MjYNhkDUYLNilfaKs8wcjzWevEq5rRiSM7kor3CaXvcpqLPCizzGWL+u1t16HBHg9EaDYNfYnGrw/V6URL+UHoo9mDUfkA71ViCRGZFl9b68k7BuycpgUsT1xF0nMspGDUHhJqbEoSvpUJJZUeYHHRovzxn8/MmSXqBa7F9sGgbL5eVYv2pW1XXhn3xLgiyzPqLPTvY+pq1Ntg1FDNymbXwYogtWBIbeL6gGD0/+TvJCPhtiDcdBZ3Gkzgu9L7Cl9N0vB8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXkS6KktaIzbMVTBz5mNLWIPldc5wq5FxLNpg3tedlA=;
 b=Kqr6IbfcAlxCzQVyS0RBbzYjzkkMh9Rw08OC/cIa0yzQ+zn8dGZuy/DMsU696F5zVgV6Hc9VwP30438jwUMxtH5PZxs4UJW8geMv+APYp+4q0cXy19H6OXshCq9Ep5e6tv9f+hKrLyvS0LlviiQgEvNTYQSPcePz2hlTZPAPe1mOvpforel0t4jp2h7vzxNnZFFUHC5jT712dKnXo+xQK1rjWCTQP2aM0sW9e3o6DmbHiuiVioWUvZVhhrVbKiTWCc6drRnz6d9RsvGZuV4YInOn3LtIWAb8sZArcl7crbjdqRUj9l94m2vHcG4BX3z3d7xR2WzItYEQto7AITVIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXkS6KktaIzbMVTBz5mNLWIPldc5wq5FxLNpg3tedlA=;
 b=UJ4LLRcupIVux9LlWOVHu36jG9exHfCv07Sib9FO2DB4gFRVhgOawI2I+riha9Che8tzAX0dq5ISWEIyzHMQ2/WVoGkf7mN4jfW/xGQTW7uJH3YMbWCc4oQcOLxkmKyx37S2FKZi3DbdmcxQnGFYWI7tHgyWZSF6lCF0J5BQy8s=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CO1PR10MB4594.namprd10.prod.outlook.com (2603:10b6:303:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 16:27:58 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 16:27:58 +0000
Message-ID: <5beea8ed-b92b-4bee-b77b-4a3d57a5c001@oracle.com>
Date: Tue, 14 May 2024 21:57:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240514101006.678521560@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0065.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::29) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CO1PR10MB4594:EE_
X-MS-Office365-Filtering-Correlation-Id: f04aee43-9dae-446b-910f-08dc7432d0b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?OUxySWlhR2gxK1RnRmVYdk1rb2xLWitYS1RIMlFVbkhVazVCZVkrV2JXeTZj?=
 =?utf-8?B?aGJDT0llemZRYzFxd01vQkU1K3NFVjF3UFF3V1YyM2QrNGxOOXZLdUVQaDRD?=
 =?utf-8?B?NEdQZGE3TTRMQ3ErSjBOdXk5dlREYzZheWdGVFd3MktWWDNnVU5TNkp2cUZv?=
 =?utf-8?B?UVRIbHY5aElEVk1va3hFNW5SczUwR2ZReTNLK0lKVkxMQm5XMEhldURyQ2cy?=
 =?utf-8?B?a2Eva2Q2ZjgwcmtoUmphR2pKTjhkUExqTnA0WVQvMFBidVozQmhwT3FKNDVR?=
 =?utf-8?B?TUhRQjVyREFRT3J0N0lzNmtYbFhDNHQ2bWM5RXJ1M2k4OS9UY2hITnVsdkhv?=
 =?utf-8?B?a2lNUDFMVEhwY1BIWlZoTGVjTVoxTm9QL3NSVzdqbXpFaHdPbWowenhYUzRu?=
 =?utf-8?B?TW1mbW9uc2Jma3hkc0xNdEQweVJrWlVRV2FUaW9mcnQyWEVRamVsTUJjSG1J?=
 =?utf-8?B?THlHSjk3WUxWYWMzdXFVTEVZSGl1NVh5bm1CSThHRW40UU01bkhnK3BPRXd1?=
 =?utf-8?B?NElNc3dNaURQK25XcjIvYk9OZGJVZ3hvNTg4a1ZpdTFnTGhWT3p2dTdKM2FB?=
 =?utf-8?B?QUlqWW1DcWlXbUI4ZEI4OTB1OGNPenQrMHRVN0Z2elpsaE1XQ0dIUStzRURF?=
 =?utf-8?B?aTBwZ1FMT0hkamlOekYvQnhabzdVODI5L0ZZaU9UTmFRc1JQbTVlTnBkYi9P?=
 =?utf-8?B?djdWbzhHWW0zVWEwRlJ2RUVwZ2tkdEowTXcxb0JBRVE1TjRoanc5cnd3ZEdm?=
 =?utf-8?B?elFQdHJUb2g4TC9sd1M4RE0rejloa3ZIdGhoeHZaMFdmaklSdmpTUVdRWFBR?=
 =?utf-8?B?L3BuYTNqU1pTSkphSC9Tb2J5N3FzbTh0TDlpenN1YW1BNmlCcHhham01S245?=
 =?utf-8?B?eFJ0dTNFRlVVSDdIV2wvOU8wQTJBRC9LK0tHeUdrUVY3R0xhNnVGbnhFR0tw?=
 =?utf-8?B?bTQ4UzIvU2pnTk9vaTJkSldoNWIvZ1ZCMXpEZVVEdENDaFpHSUtGV1Jia1Y0?=
 =?utf-8?B?MUhNb1FMbXNBSUtOcEhSeFpzeHdlY0wyQmRSMkdaa0JtcnBGeXBsUVZqcjdt?=
 =?utf-8?B?V2FWQ3RjQjNQSmkzQ2pPdXRsMU0yTWQ5REVhY3VIUWNnWXY3akoxQjRmd0ta?=
 =?utf-8?B?Zk9JbnIraU5hc3Q4TzFPL3NyV3QwUVpnYUJLVUFpUCtab3QrSnFjU0xwbUww?=
 =?utf-8?B?Mi95NUg0Sy9acVFFV2N3ckhIY2h1N1M3cVNNNnowWnJ5OFdBWjNBeFpJeERs?=
 =?utf-8?B?QUFJL3Y3WDFDeDJUOWZJWGlVSHVmMG1Id29XeUJycVFNeGozUmlCZmRjOGgr?=
 =?utf-8?B?RC9lY0p2eDVvOUY1QWJwMjNSdlQyWjB1RDFwYjFZN3B4K2ZSemJmVWNBMFBM?=
 =?utf-8?B?aDVpVUdoQ2VEVEZOTmZRZUNDa0pQeU5DeU1oREVkalY1Kzhta3lSWmdBSjQx?=
 =?utf-8?B?QmNkTUE2WWFWQ0dnUCt1UkJFRFhhNnBEOEo4eGFRZXFYa0xoZXZkWW85c292?=
 =?utf-8?B?WnQwY2dwK1JQc3VmdDhISk8zOEVvdWVyM2MvK3NSSm40VXNSTkNtTnlHcFBx?=
 =?utf-8?B?cDVRa0luV2RKUEtveGplU0plRG04eVV6T2kzSEh4cHpNY012aU9PTkJKWldY?=
 =?utf-8?Q?/NtaBPzp7fqO74UUHQsX7IWtq4rV5srd0a1teXgV5vSo=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YnE1Q0orcWRySWlCY0lsdU94SkZkaGlMcEdjdG1HdzdvTWkyd290Y3gyNEts?=
 =?utf-8?B?ZGR6M1ZEbHh0b1g3UEZHdENBQVlJS0ltZ2podm9lWVpGMGNIM2JETSsvWWhT?=
 =?utf-8?B?Q0ZnbzNxenB0SWZicHFUeWtoSW1MR3o3b3c5S2x2WEVpaC9yK1BqQlF1ZFB1?=
 =?utf-8?B?SzgxQWZsZjQ4ZXQrRks5K1dEZTc2M2hRZzJ5Z1k2UzZDWjZzZ3F3UzhrU0d5?=
 =?utf-8?B?QW5PYUdxd1NkUnpwTDZNNy9CRmNWOUM4N1lNRURydGdMT0luVVNuSHlLdVR2?=
 =?utf-8?B?MUNhekJURW1NV04wbldacnhVKzFKUzlYWVZTWXhBamJjeGcySkVia3BZRk05?=
 =?utf-8?B?OFV5MVR4WGxmd3hqcklnVWhoZVhLem95ZnlSejR6U0w3a2ZSaTdnSWxKU21U?=
 =?utf-8?B?QmQyMEt5cUUwVlcrZ2Fta2sybTg5M1NidHFIRkxyM2hSRmhMT1M4WkhpbWlV?=
 =?utf-8?B?a00wOGtLT0w5bGwzclBWckh4WVpxQVFEYytZWE9KUVM4Y3d4Z1drR2x4Wk5o?=
 =?utf-8?B?TUlBOGZTOEk2ekplaUxhdHNyN3Fkb2ZGYVozZThoWVBZMUlXVUx4YTVMWi9k?=
 =?utf-8?B?SzRPRkJFUFFPWVIyaFJRbTVHVVpuRlF6d2drNUlkam9jSEpQSFlMUDlYV1JM?=
 =?utf-8?B?ckVkZXdDVGFiYjNSRE54bndtSjFRM3g1NHhFVSt6MFBsT0M1WDF1VFhLWTJR?=
 =?utf-8?B?OVkxRnQxUUdNVzZuZ2FOOGpteHk5QXFEak9QUDd2ZGtuZEhhMXlOK1ZSMzQw?=
 =?utf-8?B?MkUvc3pLdDdlOXc0amJIRFJyRURLcm9NTDU3QURwZGVHSkVKZFBzajVOSjFJ?=
 =?utf-8?B?K1hwMXJpNlFldEFGdW5QckljN0lpRFFUajRROTNTKytUQnRZNUxHNXZlNUNE?=
 =?utf-8?B?ZGFrOVlzaWNWeitZL1lkY1krZDFEZ3FkRkJ1QVdrYnFJaFlIZDdtOFNFNUJp?=
 =?utf-8?B?aDJOVHUyMDk2WmJiQllVQ0k4Mys3ZkJlRnFoSmRmckkxSXVkZ1V6Qmo2d2t2?=
 =?utf-8?B?ZjlJME1BQnNvb2JkMXY3cEhweVVWUGRJRWhJaS9hWGRnRks1RmF4bUZQWTJ2?=
 =?utf-8?B?dVNQL2NsbDIwalBaYnhuVzFEbmN1dXFXaTlOOE5RWUpnM3FJVGsybjY2eUta?=
 =?utf-8?B?WjE4eGd6Nkx1dXRnU2tYNzF3VEM3NzBaRldiSlZqbmFld1JTSGROT1NyMER3?=
 =?utf-8?B?MVZiSW41dkJVTm1zaVp5VDAvKzgyRFdHS2owVFVCWUV2THVCNjVRUG1GZGlo?=
 =?utf-8?B?UVBvTFRsRkhsZlRFeno0Szl5TFpjdTFUem5HU2hpU2pIcHFTUXM4QXBaZCty?=
 =?utf-8?B?OUt3N3lWejJQUlVSUVV2eGh2ZzBOQkRnSTNCb29aSS8ySVpwR1ErbDdrOWk5?=
 =?utf-8?B?QjU1UWY5VjNPRUJFOVBPQUZidm1jWTBUR1JSRTUvbjZJajF3Q0lTaUtMUlZN?=
 =?utf-8?B?OUV4cDlSZk1lNWNFKzRvNUNXNEprYUZ0d0FNd0tURFRzeWh0UHAzTElHajhk?=
 =?utf-8?B?NWRIVkZDV2plWkMya0xFbkVvTDJmaW5CRkplRmJ5Qlh2L2J5Z3M3c2F5cXNX?=
 =?utf-8?B?M29Jek9TbUZJY3k0Zy8vdFlEQ2MwYzdnRmVuOStSN0thR3FVNlRqamlOVkl3?=
 =?utf-8?B?TkhBOWk3VDM5eVlUZi9jS2hXdVRwY0NDQURDejVhUGp3RDkzSEJyRVgyZXIw?=
 =?utf-8?B?MmsyaENlZUFMSys0dGEvUWluUGRGVnRrMFh2eXhSN1BHbE4zcjJ2ajRPa1lM?=
 =?utf-8?B?b0wxdW93S3VabWY1NUkvQWVxbHJMQWdBS3Q1QzlsYm1USUtodGw3dlJKNFRE?=
 =?utf-8?B?eW51bkRWdndGZWNja3pWSFlmWlMyQUdPaUw1dCtia29oY2pOM1Fqb05VOUdY?=
 =?utf-8?B?SlFFS3pGRkd5d1ZrSk5sRGxrNG1nMG11WEsyU1pLQWRBcFNiUG9TYkNmYXJm?=
 =?utf-8?B?dFBTNEFraUdNc05ybGRJaGp0bUQyUnVWQi8yODFtTW1BT2pPcWRMenlyam00?=
 =?utf-8?B?alFMV3BFZGVqQy9nNjdIQXZ3dzVtUGJnUVhDQUgvdjJPOEEzcjBRZmVicno4?=
 =?utf-8?B?TWJYMVowcmcrUjBsTmRXQlIwYnBPcWkvTFhtNDE0eTBTVFhLcmswMU9VSWdl?=
 =?utf-8?B?bXZVV0g0Rm93VjZhNTNhVVNaSWw1UUpLTktaWDZRUEtCb1FLbkQ2amFsMG1G?=
 =?utf-8?Q?+VR4UFi165DoQNNr+CKguq0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eA9rzOz3eZhOWsaAbaJLS0nd6VtIKw58NqGH4lfVkBmVjg+AI6oaMoL2l9qXwaIjQ7NkVFJUlXJTNkkKI7CjT3R68KzKLYLiuon3dLD23ioZVh7nfyneWv9K7Ptjt8fbJDOqs9AO9zJBwJtsHe43lktaraJn0KewN/ebJeKrNUMFhCkOyCMsYWjqRwvDvuMYJudfzoh5MS7N/d13g3aYJc4MMRZSRe4G9QGyW0G46Uwg8FyXxljsgmUm5tHLovzlwiMYexgffCGGfyelRuf/yXW3onbh9auCTvuxHYceH3QQ/IlM43ImDKnr2ImHPq1majH0+fZo/T1cBhxhacxfGe0+vHuLUU9hbkoRbIZ/x1fcTdcwB/cEhQuBVipjJNip7yhv5sLVDEp5GDmiXDX5BOHpiCFC+L8fprWIOtzrmp5eb4DGeKoJTUXIP18Hf3XbFJ9KhmQ/fUVOGyqO+sIxz5twN7gVFgC6CGFatNwXm5zi5z418Ji4KQ6Fj6v/okbK5m2Mjw+z0alNQMwEwtIHvQLKdj5XLpKsH9aLFFB6U9i3DJhzs1hv8YYqsh8mkgwzVO15c1oKaRVlyoBfqlrEQ/X0HZrZzkIIFL7XSS+z7H8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f04aee43-9dae-446b-910f-08dc7432d0b0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 16:27:58.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4+Y1ghP9+jvMG6FDzIXrJs7JAVU1J1AzMGU4xxd16zIW1S4wHmDHYAXvNbG9h2qqO/zIxxtVzgQyVj/xxvMFCxvAHZnQE+qE5dA/JZ93KkimxwiX3JFa+JgZiWeiPkm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_09,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140115
X-Proofpoint-GUID: uBpSMiJsnD6bmInPHzyzRTeiagB6uaJR
X-Proofpoint-ORIG-GUID: uBpSMiJsnD6bmInPHzyzRTeiagB6uaJR

Hi Greg,

On 14/05/24 15:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Note: selftests have a build problem in 5.15.y, 5.10.y, 5.4.y, 4.19.y

5.15.y revert: 
https://lore.kernel.org/all/20240506084635.2942238-1-harshit.m.mogalapalli@oracle.com/

This is not a regression in this tag but from somewhere around 5.15.152 tag.

Reverts for other stable releases:
5.10.y: 
https://lore.kernel.org/all/20240506084926.2943076-1-harshit.m.mogalapalli@oracle.com/
5.4.y: 
https://lore.kernel.org/all/20240506085044.2943648-1-harshit.m.mogalapalli@oracle.com/
4.19.y: 
https://lore.kernel.org/all/20240506105724.3068232-1-harshit.m.mogalapalli@oracle.com/

Could you please queue these up for future releases.


Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
