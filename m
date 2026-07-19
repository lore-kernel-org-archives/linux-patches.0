Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE77D1A3172
	for <patches@lists.linux.dev>; Sun, 19 Jul 2026 18:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784487148; cv=fail; b=FlQ5YUf+RV8mk3aCnUrDUCHPB67kEL4o6B7jMiWw8gW38ZbADC11IVtCoAwWOY/1khrI385+yU5Yyl7EMNx5mpPdCEomNdqkmFqEKx66sGCHKE8yBRE8DsBuhqIir2Z2BnB/iqF0drUKjy0gbeUGct1XxGas/KYmJ3eTsfTrEbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784487148; c=relaxed/simple;
	bh=95bcg1tOENLe4iSpnRGzarfw+FANHlp5d+hptmQYCtg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nzmbf1nF2Bp9OSFY3k1tjpcKkNVUvoXyVSOAdBcx25IbvIe+839+/4wVCdw9QqsoQ/HmfvnypRLfhTPsK2Md8yYgIn6BIQQB1MeGtz5LBphgV5SBuZ5Ai22o/FBUCDt9fbciQRniSMOLV4lSu4lKnNG29qmOfk11lExrCG4ESP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TNCViGrH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dLm7Q1DE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TNCViGrH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dLm7Q1DE"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JIYRiP050822;
	Sun, 19 Jul 2026 18:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sa928rYUcFhd3B5SJJY1Lni2JF5GPZpiERJkRDDlAa0=; b=
	TNCViGrHH+LQ255yMq7zDSPn6BqEWCCyovdknTdSPw3E3qrOhTaXQsofmDF7teZE
	kYBNR+lg8RAh1voneRinGheWI/qerOKrbxb5OTz7Ar5EzOAoCPGvmNeYkurf/6q6
	HpvMWnkyXOYJk+xaCkPS0IzGnJaKXmtFTi7+XplRcwPzH+zTn9STMWlkGZvRKeAl
	OyWn3qvhXECSQ2qSX37aW1PaRA1QTxxxmWHGUU/+Fgw5aBXGa8VltBJBJW1eckYr
	LlFVJyisGBVQ4ZngGAnQ7lhuCr/5fEljkans1lPY71GAXorlrZrIhxK+CQa0Sshd
	UGLwQxU1Duy7JpSv1DwE4w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3h02f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Jul 2026 18:52:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66JImGtU040883;
	Sun, 19 Jul 2026 18:52:20 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgtrvy4kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 19 Jul 2026 18:52:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLwbREHPioY/TpLvs+ZDRMrhCbi8loQOII6Tu5wb9LdPhfSZxqx9vX9f3fPqZ4eplrz5KAec6hrOeQirNk0fu1hNw1TSMiXW90TTYt1T/4wYml2PJMnwtx3+2NeezUt26uMRXx8JxmMJa52Q0I9lE9aAXSJCTeQP5iJtkkYGCX4zn9PQsMsvm69dGxJtXK477RrGOgdLvXfSbrmMzkbPq2uGBDo/3/3OUmog6qbeQPHLFJBxA8dMciRLeFpKx/C6GhaUPUFaeB8UWz7PlHtOq62+D+6mDxUblYIusw5IWPaPpyS9ptViP+2xOMDOwwWwpHXe1pwj5gu6TK+EBYOwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sa928rYUcFhd3B5SJJY1Lni2JF5GPZpiERJkRDDlAa0=;
 b=vf9iove/bUCIq0Pf2qahT8M7GMItMKxc5E7fcqoRgcm2KpUaZUnvaKNaq6oeWMOXU2pBRKSGqco8wKkWfTqjPkUDbGJhhrixOg/yDhnlbJOsaOhUguBCRG46luu3jk5q+bdUYn4oIxV547H6WTpDXAk3ysGnaIZEQa1OHLHG1+9cpUQmNFEhS9Vut4StibQXcCeRBT01fiY1cFM0DnEHXb26A9nvBoFuZ9bjUgqD3ya1uoqgB+eKU/CTeZM4BfAZ6s4+Mf60WIJJT4KHUoLdrqCOON/TQOH1DgHAuKkUo4P1QwIbZEWAVzSqRzdT12GzuGWj1ztu8wReEj35BdgBPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sa928rYUcFhd3B5SJJY1Lni2JF5GPZpiERJkRDDlAa0=;
 b=dLm7Q1DE+4izPZBq7B2cE70DvTWEbToK+B85YuSYIqvJfdx/dscWeu5+00Lnx2wgSv6u6tQX0KlG+/VX8xJgPvd3bSGJteSCCdifp1bekph7GCGlIh11qu1JwOjVDWPKtmeySnrHFC7AV7ZGmvqsxa0/u6E9To9vv8ilH93sktE=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ2PR10MB7057.namprd10.prod.outlook.com (2603:10b6:a03:4c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Sun, 19 Jul
 2026 18:52:18 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0223.012; Sun, 19 Jul 2026
 18:52:17 +0000
Message-ID: <7a338426-7b4c-485b-a177-9b3651e3c716@oracle.com>
Date: Mon, 20 Jul 2026 00:22:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 159/349] fs/ntfs3: zero-fill folios beyond i_valid in
 ntfs_read_folio()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
References: <20260716133033.287196923@linuxfoundation.org>
 <20260716133036.938913374@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260716133036.938913374@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0030.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ2PR10MB7057:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff66c4f-41b5-45de-1920-08dee5c6dae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|4143699003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fcdfexZ/ZwUkFHhTDfQTPx2BAksSvf9thEtougkTzgbr44zSQ+XRx+ZzZqN5vvkVjFBmrEeX/HoInH2lwQUveh21t5M7F42yrqsELusEIfNV1GVIya6LFKLlHxflYQ5Jj4XbvIxflfRhldV0TqaollSFN3dZPUviYcXH8sBsx2ZOmhYA0OuZaRAoyQR+VVQBw0WPkstjWTjorXfiKFGcPIfzbcjB5lGSIGwSqsBv08mj15wm8uM3EPDZoj2zRgdA2A5DSkqt40RORDYJckGDLw9CjUbVKo0NlN0TypOSMFVbsG3d650I+kF32LS4Q3tvXR5eyRrrhMTuQwbY49FxhxvSYYmjrjtSAxc1WCgnTOAqIfIV+02ExOxPfRPNNHhLn5QHWDsPwv66WmtC/OB6qglBLRC0WBthtTtvTb/6WpeRCLB6McJaJuoM77USWQDoqhMiYjHQE/oXoV/spTUHOnqbFqyxBorsNcgeAEaERWS15NHO+yBaWID9Psye1dqdqM7fU5HrlmPSMSWbqbsi+WF8Qc3hQFijn4yFvrT/ujuYC1UI2mjbR6P+fSjlXpQXg0thwxQxAFL16Gh1gJVt9qUtuUNCJDxKI3K1tM4s6zRP/FRzZIxQ2oRQWJAJih8/eAdY3McB0lhaazWaccNfCL9dDkHDdiUecWvJj6OD5S8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(4143699003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHhRRldNbmlkNTF0S2tweXlIUjZvVEpIak1wOG83aTcvM25wZk16cWpuS04y?=
 =?utf-8?B?dlFjRSsvSHJGQ1gzdmFBTFV1OURSUHBrV0Raa25rNUdaL1h2WW96TVA1c0Zw?=
 =?utf-8?B?VW1Cd01vcGpVanJMNmQ1YTVvdWJ5Rkw2L0MzY0pWQmhKNVdldWg2OWdCc3pL?=
 =?utf-8?B?UDFscVJCNUlaK0IyNkVRMUVoa1ZIT3pJWDZsdGFSM2pCTTJ1MHR1cFFzK05P?=
 =?utf-8?B?SjZ1UmZUZHJnR1pLQVFhQXo0Q1BvcUdjMllPSE5uS21rVGxRb1lrUTBBS0pZ?=
 =?utf-8?B?bi9PZlFWWmdsdlRLc09DRVU5VWo4TkoxVG9leHYyL0RVaDEyUXNjTjZvRGpD?=
 =?utf-8?B?dW5qN3lSQXJOYk9KdWVVWUNYR0ltZlhoYmlKUy8yRjJ5amxsdzRjZ1Z6b3A2?=
 =?utf-8?B?WVhHTXMvY3o5OFI1MTRGVDRTVmIxenN2VWpYSk9keU9yL3pTQnYzY1RYNUQ0?=
 =?utf-8?B?TDBucnpLSEU2Ykx4Q3N6L3BBc3JNUkdKTWR4Unl5M1pWUHNWSmdsZk9wYVM4?=
 =?utf-8?B?UGhCdUZHN3EydGhSWlEwZTZ5ajRLY0hiLy9JNWhYZmNSYzRZcE5lbnY2bFhn?=
 =?utf-8?B?TS83bUVYSzVGN2lVWUhjNkVIZDhPeW8rTVRBdS9ZY20vMDdFK2RBVE5INk1s?=
 =?utf-8?B?NTU4UmRaVXhOSnJTWERYOE1wZ2JWZEhrNHRBbU15aUI1ZnUrVkpoTWlaS3Bj?=
 =?utf-8?B?aXJKTklWOVdxTjc5ZkVNbTU4WnZBK2ViOFVFbFIxelVTWEdQVmowekxRT3RB?=
 =?utf-8?B?R2NVeEtmZ0NHbkpXNWFsOS85dm1lT1VNZjlvUWQyYmZoR1VVQXVTdEFjQkhk?=
 =?utf-8?B?V2xPOU9QTkFOT043Y3VjU2trVDByNmhWL2kxQlZsUWlzUnVGUGRTaWdLSlNh?=
 =?utf-8?B?d0pidXBlbzdKa2lCbkI1UGYwbi9VTjdFQUNmUkZWWS9uRnUyeHdaYXgwZ0M1?=
 =?utf-8?B?Rld6WG04Vmc4Y0gxTTJpTitsWC9kRCtObURmNmd5S0ZQVlhoWXE4YlVaT1FM?=
 =?utf-8?B?bWFWSWVVVjRFM2JIc0NIVmVwbzhXQmVNVVd2VC9qaTUyb25XSlcxNXhmQjNk?=
 =?utf-8?B?c0xnY2U2ajdvSjhCem93WkZ4MDg3VkMrY3poSUtwYWFHbmlseFUxQzBRSjRO?=
 =?utf-8?B?TkhkZHVqYlNiOXpkbC9mc3JGY1liOHZ2SVNsVmkzNTVCcStsa1JJajUvL0JF?=
 =?utf-8?B?b3A1eXdFblppeWtKRkdYMTQrUWRoMGJLWXNDai93VTkxcHlqbURvUCtEbVI4?=
 =?utf-8?B?eSs0VGVmNGZ3elh6Q3BqRUxaZlg1YW1ET3YzcHRYSEZuTjBWRW1ScE10Z0sw?=
 =?utf-8?B?eDRFRDJOdFkwa1h6ajUrYWFoNEE5YWFUNCtGU1VHOHlJQlMvYllzOFF1L3gz?=
 =?utf-8?B?SDlMN01SbHRWK2JqTWg1Z2xCMEs1djZuNStCNlBYUzFBMk9jVTQ0Nm9zNUwz?=
 =?utf-8?B?NUtOVkJPS0l3ZGxhN1MyWEdSN2VLSnU2azhLaGVmU1gwd01vK0dDUkFmNlRS?=
 =?utf-8?B?MXFiZHkzZ21mMUE0V0VhaHlLT2hTMUZzRG9nTVpmT2w2Q2ttemd5enhOTUY0?=
 =?utf-8?B?LzR3d0QwRGNacjZhRWZoSUMrMWNUc2FqaVozTjB0ZzlXQnA4U3R2bkFhVG54?=
 =?utf-8?B?N2IxV0tkMFdhZmhoc0U0Nm03Q0tpb0JnanhuYmlTalpWTUlBTXZDM2tEN2VN?=
 =?utf-8?B?bjBvTGVPenVOQnhEWUViMHlkcjVIWmh5MTIwdFIxeHU2eWx4UGUwRmU2b2lJ?=
 =?utf-8?B?TWMxWEhnYlVCQy9Nb3RFcm16KytYZVVmN2k5SlNobm85MzZpVE5hSnY0dGRF?=
 =?utf-8?B?WG5CcDZQVHJIVFdEd0tGVUhBZndDa1FPQmJmWkwrWVM0QkVMS0V1ejBMeG1X?=
 =?utf-8?B?Y0lYU2RUNnl3QUk0ZUhuVS9HYVJHUHZFMEZ0K0xrazBsOUcvbi9zbGppVHow?=
 =?utf-8?B?dm54dkZJSURtd21LQVFISGJUUDJjV2NUS3NiV3R3aks2RUlBNWx4c3NzcjBi?=
 =?utf-8?B?N2NscGVQc2JZRHZJejZJZzBDRmN5bkhraUZwWGczQVYySHc5UHRmaU9UbGNT?=
 =?utf-8?B?bWI4TnkrRzdpSnBTakJFWFVlanQxZ2hWdlVDQUV4SFdOalpjTjhyWEZTY21h?=
 =?utf-8?B?c3lpY3luWDMzUURsMzR0Y2hEZWludnRZblgvdnErbXVCZlNlYjhFNlFIWHVK?=
 =?utf-8?B?bm1jbllNM3V4ck44MjVyU255SDdpTFFpazJUYUdyNHYrV0hOYlJpSlNSNlYv?=
 =?utf-8?B?dmM4VDBzbjNodSttUmtacDZzTWxvOVpubkNGMlZDOWFWUUZQeGRRZzJhSXFq?=
 =?utf-8?B?WDhEK1RZZklYVjFaeU9GSjd3VW93Sjh6Vy9zbCt3R29uWWpzU0lvdmw0RTVr?=
 =?utf-8?Q?8Y6AXRDRy5d7rul7KOr60Wqaqq7PvWaeN0jPx?=
X-Exchange-RoutingPolicyChecked:
	cisbPznHFdv6E2Jl2W2M/Qvmct0obTj89ElZuKBQAB4IW4KQSI5/Fn+TgIHA/MEQp2Pgfiy8TT5w1NulKs1kggUmJUlSyTIDGyv8TVJBY0mEbin4z6TT5tAhPqOl59orDhN5kAaTPjBhLNFHM7dwxgUzAL6VEIAv1HWOEKT/A3g4XnbiNxtnkve07TYZWYkeoriyPUEW3WLLB9/HYViY6GdgfmJZ7r8GAxsBb0VO/IGoIeshAtMsagYqlz+BkjHQ9CdfHDNRXXEoOGkhCSi9f+W3cKpsi7Wrq/PccPNs7e5n6PIqxpcgLM+uGgHG4AIVH94LbKfWsUFVdKZMZx11PA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8hwDEshJZDIcJ+NNnOCF+tPeCGLHShHBC6ZG+RvrBpDmcK57ynQ8yLy6ITKb5JAdZKXbydaT4P8iO5cwydpedeQfaAFcUKrO0qS90FpLLGhuh8RYTmN9Bu+Xf8UK4B+tV5N3qZaipbP+rND/YPecvh/Mceogtf4IY2ke8wiB+MgOO4A7FmeVlKmZBk78ggGN08bjweutrS/bffSSf654E9wy4Hu4pfRFrw4UR3u6psxrUoUKjSX6uOoW54VfsjsOmzwdsNoW/RDCzyhiJ7UXO3rVLFsK8A5NMbJaivxz2k0+4ctfTEGSBUsGndTi86witH5kc5yDco+FdKbY6jGICGqCAg8maXsvLmvQzIncBYdiRTBPncmlJ98sbIihSmAVYF7MCH8p8LRI0vZAiNSqhUtnMMSmZbIfhqrjqdrEMXFNagEo7t0Ij/JFuG5KEuP7XhryF72g+Bx3JXZbjQnquNdG+k3nrc5Gpfm6MM8gvlHlCCImmId4r3Sr3zyFMZRJpx7ENi/38IQlPi2crTVuEpmid8XMrU8rtBAxSsG+O4LAU/JdT4mNH4OvnaQdZctXwmTrjECLhKD0KGfhWWAnApf0Fyl/S6KjCb60lXh0Pf0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff66c4f-41b5-45de-1920-08dee5c6dae1
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2026 18:52:17.5062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5RrGelhUYqgT7P+N6tA91Tx3YjZlAjkYEgSWBXa56abI9RX4INkB4kdfpEhbNSK6Au6GFOcItLyXu2Kmj6gaEhJgV3jx4RMvDL4H2uuSdEqLkNAvB0TKPPtaPq0wPyW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7057
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607190210
X-Proofpoint-GUID: aeHPODO9PtOaTCfqwHb1dWVmo4i_2RYw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDIxMCBTYWx0ZWRfX1y1+qjipdN1c
 bjHwOC5jeMWlWzjed+Gdd8ZA2Qem2yFeetavTe31mfBY6mjX8+P0mlyAzFt2/v6EAxr7p6z9wW4
 xlo4Hm/0O8G9TcCOm2/j6VlsDPO6fNWxS/3rtK5cP0jxl/Krg90+
X-Proofpoint-ORIG-GUID: aeHPODO9PtOaTCfqwHb1dWVmo4i_2RYw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDIxMCBTYWx0ZWRfX+uwqPLp/13P2
 k4rZ7bscdgWxyJlAw3zf0c56uwvoMKYzdLkYZfumbOwArXAE9DjNURvnkrD0Dd0Z4dmCat0acPE
 gvNtABMOkRPPfGVB7LAXnozY7CKYwPZearyQDbP9vqyHY+2ozBsysQupxweMIMj24wD7HSSOST3
 Rb48JwRwBsXt6G6zAtVCvp4og7F/ndUHvqEsYEUh1hJ8MVm2DuloqrLvMrjyNRqE4ZQ0PyIt4ex
 VxCh2r0dIcHXpf8+s8WcZ+bHW5cJI1fjR5JPptQV/J4umEbrUj6BGUpDybvocFZWvOgMeLF3O3D
 SrM8VBMIv8dOFsQo8SNidYyLl4pYmLVCSuXkimX2SAoslrziqGit0yHrk/Z8sBnlZQxyLhZraG5
 1DVjb+4tiEH+Crw4H907dMXFeODbMZOAwXnNfLHE+1EIKwvxuwbxj1KIkasO9GRXr3P3adSwDUW
 whz1LtQ1nEhGSwU/wlw==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a5d1ce5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=GFCt93a2AAAA:8
 a=VwQbUJbxAAAA:8 a=hf_vhcfwsPhM5Ld9ImYA:9 a=QEXdDO2ut3YA:10
 a=0UNspqPZPZo5crgNHNjb:22

Hi Greg and Sasha,


On 16/07/26 7:01 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
> 
> [ Upstream commit 356fa248168be90109b66f32a61b8eaedc98424a ]
> 
> Handle ntfs_read_folio() early when the folio offset is beyond i_valid
> by zero-filling the folio and marking it uptodate. This avoids needless
> I/O and locking, improves read performance.
> 
> Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
> Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
> [ sashal: dropped the is_bad_ni() bail-out; 6.12 lacks is_bad_ni()/ni_bad
>    (introduced upstream by 519b078998ce6e) ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/ntfs3/inode.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 5e240d7fb03709..93cf65db77a015 100644
> --- a/fs/ntfs3/inode.c
> +++ b/fs/ntfs3/inode.c
> @@ -723,6 +723,14 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
>   	struct address_space *mapping = folio->mapping;
>   	struct inode *inode = mapping->host;
>   	struct ntfs_inode *ni = ntfs_i(inode);
> +	loff_t vbo = folio_pos(folio);
> +
> +	if (ni->i_valid <= vbo) {
> +		folio_zero_range(folio, 0, folio_size(folio));
> +		folio_mark_uptodate(folio);
> +		folio_unlock(folio);
> +		return 0;
> +	}

I ran an AI-assisted backport review and then checked this one.

The posted 6.12.y backport is:

commit: 45e5059ad174
("fs/ntfs3: zero-fill folios beyond i_valid in ntfs_read_folio()")

It preserves the new zero-fill fast path but drops the bad-inode rejection
that precedes the same path upstream.

Upstream has:

commit: 356fa248168b
("fs/ntfs3: zero-fill folios beyond i_valid in ntfs_read_folio()")

         if (unlikely(is_bad_ni(ni))) {
                 folio_unlock(folio);
                 return -EIO;
         }

         if (ni->i_valid <= vbo) {
                 folio_zero_range(folio, 0, folio_size(folio));
                 folio_mark_uptodate(folio);
                 folio_unlock(folio);
                 return 0;

The posted 6.12.y backport has:
         if (ni->i_valid <= vbo) {
                 folio_zero_range(folio, 0, folio_size(folio));
                 folio_mark_uptodate(folio);
                 folio_unlock(folio);
                 return 0;

The omitted upstream test uses is_bad_ni(), which was introduced by:

commit: 519b078998ce ("fs/ntfs3: Exclude call make_bad_inode for live 
nodes.")

6.12.y does not have is_bad_ni(), but it still has an equivalent generic
bad-inode state. ntfs_bad_inode() calls:

         make_bad_inode(inode);

make_bad_inode() records that state as:

         inode->i_op = &bad_inode_ops;
         inode->i_fop = &bad_file_ops;

and the existing VFS helper tests exactly that representation:

         bool is_bad_inode(struct inode *inode)
         {
                 return inode->i_op == &bad_inode_ops;
         }


The narrow 6.12.y adaptation would be:

         if (unlikely(is_bad_inode(inode))) {
                 folio_unlock(folio);
                 return -EIO;
         }

placed immediately before the new zero-fill branch.

Could the NTFS3 maintainer confirm this is reasonable ?

thanks,
Harshit




>   
>   	if (is_resident(ni)) {
>   		ni_lock(ni);

