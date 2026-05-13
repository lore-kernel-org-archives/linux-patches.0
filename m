Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03F639C637;
	Wed, 13 May 2026 18:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696680; cv=fail; b=eQoDy7z1FlPc38A0ZwKyhk5GO6PdJRNCUP2W1vemPmVrtWaB2EDVHbuvHC5Obmtt0rXizSInrocNpx128wwTPcfuxdzft3DIk8E7JajvSsYrCuV7ycHexSSnz/e3qfUu5icF4+bldqY9Ib8QFduTq4BWXJ1Mg945aWKO6EhnsG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696680; c=relaxed/simple;
	bh=NJFlHavhRzX1Y+MnT+AXQqbh3xvcx4dYuFhHBmBkBus=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eXpwpYX/gUgIFBRLjWhUvE/8diZZExprbvWBtRuj9zt+nJuzYu5K4JyC5rQpGFRY1G3NO3q3IDXtnniom8j5emJ4BMHlTdLy2XhE9fOriIggN25dab1giBou8vWKiATcIZvIksDGPIvXsesbf1FUq96jH5jQJh0Kb8j0kmCPt2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oy6mVBW6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OXz+KUhM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oy6mVBW6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OXz+KUhM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DG2nrc3347394;
	Wed, 13 May 2026 18:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zP2TWddpvgQnNknxbLkqHF+GR0z78QOG1hzjfc+y73A=; b=
	oy6mVBW6MxmdN4FDwDC6mwYiIIgYQvrjPfDUAvoHr1Vv4zIfz06tEbH7BsfQF0uQ
	6nGRl/QfV0mw2JuOoOIGNYHhhToPeFeSsnvVlYgaBTPv/28NStP4FNiocYxVyPo5
	nUO39izFcqXta42r2XcQpB3WdAxEaHhmQmM12gMXBwDc26rFThBSZoVgDwV4Al24
	n5wJiHW79C2KlvnqfQK4goMxREEFDtZtpqNrSBXktpaxsdfLVzspOPLGCT0pNGFN
	Rtg116lz7UA4EggxCw28xp2qqxY9MLZQk1vfboRoB/zL3CTBpgGsO9uF2BNLDtbl
	8rrDCbg39NAedZLz2DozOQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c97swrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 18:24:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64DIJxqE036806;
	Wed, 13 May 2026 18:24:24 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e3neban9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 18:24:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFxENw9Acs8g99iorHfYIVbFCEoEWj9A7V5QjQHra1tvrk8oFINPaaMF245sJecLHpOk6iWEGiREYXHqmg/vysyFD+/03534DjuF3FJ0VburjqIJMlpXlMVGPc+eBkZIS7qWZq3CSqMporSRlS/6VbZYixdwP2d8J0cQWTwMlP7R+xEH4WENFCUPwBfxynMpyS27VKxXrqWh1bryv4un4X2UbnFuQ5EJAssslpBOCmKloLLg/K15DMe1dZbhZOfs0c8nJAJvZMVrLRN5WNmNAVSTb7Bf4OljcLtPjOiZwuPnNn8Hns7DvaYMALELH66VdXvB3CczH9HVfN8OLvUjPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zP2TWddpvgQnNknxbLkqHF+GR0z78QOG1hzjfc+y73A=;
 b=uXKC4IMI60v92JUIgAkPHpnJyNhO2KyIYmK7sjqmfvAmdgqqoZTJT5WE/CXIHLTEVYNypS9e8ztWqRCgWYmJgn+a+300xat8jDsQkITmSxCAAMJD9ODf8NLjtMM0cbZTv2EvLybync0zMPjRTqtxwv7qo6Cb1Ma4bp4DyOR/FWG5TArKSE1InYu2wpVOFrSx+jeIF3IEvAXdgZmd1AGQolCk8+79+tEJj5jR5N1VD4KTQGmtNO/eUofA9WrgH9IkCLCkCUO1wuea8Rfnn7xUe8wH4bs5rIhprpSQ40quF1TR5vRjJPeaoQcBh+u1H4tCrXxTGFdSbm4g7YWrAGJHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zP2TWddpvgQnNknxbLkqHF+GR0z78QOG1hzjfc+y73A=;
 b=OXz+KUhM43c930YwMXB4zCdqbgkdAEjiNZqQOKAOzIeFIhSUUACYcXGKlCIQOxDgPd2LWb5faVa33hLyss8e8fzP5/+zaHVmDS7+nnD1fuwpZgvNs6OMDmeTW3qaPChW3SFMG/menYg49v8A5IIeZHJ8IcmQQ5hdJutdApInmrc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MN2PR10MB4192.namprd10.prod.outlook.com (2603:10b6:208:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 18:24:22 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 18:24:22 +0000
Message-ID: <fb1d6bd1-d3b9-404c-934c-d94790dd551d@oracle.com>
Date: Wed, 13 May 2026 23:54:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 190/206] crypto: nx - Migrate to scomp API
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        Vijayendra Suman <vijayendra.suman@oracle.com>,
        Sherry Yang <sherry.yang@oracle.com>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173936.892132003@linuxfoundation.org>
 <1577a01a-f3de-4ab5-b4ad-b653cf4e3fa2@oracle.com>
 <2026051316-drilling-subwoofer-89bf@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2026051316-drilling-subwoofer-89bf@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0074.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MN2PR10MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: a116e466-4174-4960-5178-08deb11cda98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|4143699003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rlmEw3XH/xaNEc+UMGCDmPAxFryPw/L6Pxy0IyacORGXnhQ6NEBKnRU0oi+Bf7DPD5mVCetK9Mvgl3hCj4Bn9Ggc/5EiCt07r41Vtkz13ZeKL9UAE3fIuwyg4I4z+GZZdIZTRrruu7TRGi6D3jneMKz6Ew0qiacy+h/n09ybszAzmJh0WT+tAlymnzwBd4liEuCOV6FOiRp4vLEAlqyc3ycgcyU+XhX8Kexj11asSF9KTiwaLZjixFkyhpydHIzJ+NYrdR5fSUSMsIlh2WPMILIOlQaQFVZdZMZuQ+3iCfs9/WMqSbyMrpYB7tnCdC4CsVS4Ng4W+/poFAoLBZQyS+XxJhENP9keb633CHi5HsSBA/eZtoz6AbX+2TxLn0an9aFoiI1E8ImjPx3qSap3Fco/DUsRegTpXxYTttWbxLGP/8NRKGbpx2junf5v+CZnslYlolqtMM64N+u58uiLf/PK9d2kdbDpL7ePC0Y8m+PGxJ1HNIK8j55v6FODWmxohMmHT2r5ocCFICFJ2lyygcnumCoWlz5jg1yU3dPsp2FomTOvqRWgCWnpdaOxk+R4fjjx+QYLmswHvGv/otRmy5/nwpC0QGBKpBdwl9ev3opVs+LBTH8FgwwN35IB0ys+NLyVXeLPgpiSmCKCQAeXt9oeGE6N/JBWygP6P7QksPPAXsmt1jMcSteVUjJ0QMYa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4143699003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzdDVGw4UzMvSmhRa0VubmFiUmQ3bm04dUdEVUphQmZTeUJzTStHZWVTejUz?=
 =?utf-8?B?b09nSUFhbDBlbWtGRnJOQ0xGNFE0N0UzVWJwVFp2Y1JOTmZXMkx0VWFNSkw5?=
 =?utf-8?B?cmFjTGd4OUtySWR5OGhZaW1JY0FqTlpGM2R0SkVPMFFHWlM2dFdiL1NZM1g5?=
 =?utf-8?B?bDFUQy91TlZ3VldBNG42MmRGOEd5VVZCbDVGV2l1T25MRnNsTDZNaUt1TmdR?=
 =?utf-8?B?RTRSWUQxR3RwSWUzL1I4VW52NEljbXkrQnFMUGJQU0tpdFFDdFJ2RmNRSU5K?=
 =?utf-8?B?cmpOUzNrRC85bk1DdnVzUHdTbDVJUWNWWDJFcTFxbVNRRVA0WHVaSkNXNmUv?=
 =?utf-8?B?RjBCbDRKWDNKUFBJSW5nNGY3eUl1a3VPbnlNMkRVcTJLWWw4L0ptMnRMdkUw?=
 =?utf-8?B?YzFmS0huQ3VqbXZDOGFvc0poQy9jalVuQ0dOK3I1Z2g3a3RTVU95RUdablI5?=
 =?utf-8?B?MVh0dlZIelRPcXRtSERHNi83WEVqUmViMElINE9WY0RGZ2FaS3dhUzlsaCt6?=
 =?utf-8?B?SGZtRFlJQndOa2dQRThaSGFYRjRFbklzM1Yxbm1CUE1acllJRHJrQk1GWDEy?=
 =?utf-8?B?cjk4clpMRjhEL2hBeldzRlB3d2sxcmttcE1jZTFldHNJYlhOd01jVWVSNXBY?=
 =?utf-8?B?dmJGclBUeU1TNm00VjVoS1poK2QwaWNLT3RTVjVLWWxXMVpaaURleGM1cTZo?=
 =?utf-8?B?dWJRMmUzWFFnUEx2eWc4U3owaGxmbE5xeVhvWFdMeERsSmdOYTMrNWFiR1lk?=
 =?utf-8?B?amk2Zyt3VmcwbEN5Um9FZmVqR1RmcnZMbE9sd040OHFDSFNqSG5uNXdPTWJt?=
 =?utf-8?B?Qi9nbnc0WW51RmpicjhCS2VUemxLaUd5dEJFR2VONmpUYXoreWRPc0d2RGdh?=
 =?utf-8?B?SmNaYWFiV2xuN3ZFdU1WNmFCRmhyMDR3Z0JBM2JOMzVRV1ZMMGNUVE5FMTIx?=
 =?utf-8?B?RkVZak5IYWZiU3B3UjFzRWd4K0hRWDhkcWNNRlFTU0cxSXNSbW1vdGtaOFBQ?=
 =?utf-8?B?aGtjSGFQdHBiT2Y3ZVNaaG9mRjl4d2RBNXh3c0pwRXdSVFM3bHdRd1dQcURZ?=
 =?utf-8?B?MzJEQkJORWprWm5hcmRPMVFVckpLdkhjRGgvcTFQTHB6Ykc2UnpWcmRXU0pm?=
 =?utf-8?B?Z0tWdS9TQ09VbjVVVFp4MmdmVEJBQjBIMUVIMUc3UTh0NGlrMmY0aVNSSlh2?=
 =?utf-8?B?QVluWXRCa0w2Y0FVekU1eTB5bndzTHJwcFpaTXcxakxMSzVmcXNqTFhycUI4?=
 =?utf-8?B?OWs5WTMvQ1cwOUQ3OFAwWlkrcDlKTXNpdkZ1bTIya0h4YTM5cnNXY1Rrbjhl?=
 =?utf-8?B?aWxtZ1lHUWNYS2lkM0FleVRiQVNtRmtINWh0bGxTcTZYZkNLSmtlTm41T3hV?=
 =?utf-8?B?aWtRYVNkQW5Na3B2MFgzT1NBekh1ZjBFbkhmVTNvSmhQN2JDcitlTEF1bExx?=
 =?utf-8?B?c3c0ZGxzMVd1bUpDaEtNRzA1aEVDR1dsbk01WXdJOEMzN0l5b2JVWVdrU1pu?=
 =?utf-8?B?bklyUFpTN205cG1hOHVmc24xdEMzSDFFRGQ5WVZRWjJRU1NMNEMzVEdBUWtv?=
 =?utf-8?B?bDJuRi9hdmhNdmJnb2hKQlhodVBvaWltTFowcmlCMkpwaHBNaEJWNk1sUkNn?=
 =?utf-8?B?MitaQVZKZnVHOWQzdnByQ3MweUNHUmdQeE5IUGJLM25Helh1QlFVOU5BRXRL?=
 =?utf-8?B?N0x6blk2dWpTUVArK3RpcXhFN011SU01cmt3YzVMRWhaM3pqdGc3dzFHemZF?=
 =?utf-8?B?SlpXUCtYS24rN0lOa0xDcDRDNk80NVB3aUZReUZ4VjA2SkRxVHlQUmREMFpi?=
 =?utf-8?B?VjhtUGVQcm1rWTRkS3pIaEYzNWZtNkQxOWx4Sk0yeHFrb2RZLzFEdE4zSU1v?=
 =?utf-8?B?MVFqUnQ2eWpKQTVEd1N3WE85NzI5eXhHZS9hY3hEWW9LeGdERzVENXJPY1V1?=
 =?utf-8?B?b0xvZVo0QmxPbUQySEhGZmdVNStsS3pnVXloMkx3MUI4OHFFSjNYMlZ2ZFJu?=
 =?utf-8?B?eVYzUlY1YkRSaEQxWE5vZUpGQWxHeXZSKzk0Rk9hdU9ucEowN0RjZkMvV0Qw?=
 =?utf-8?B?NWRXLzZISUIzQTFKRGFQcHVNNFJzVG52QWt0dHNtNHNWeGlJNlNQT1BITHRu?=
 =?utf-8?B?SyttWGJ0YXhTV2xHbkZicncwOWlOeDFZbWFnMkppYlFXWFAzVmFGaHpHMDFh?=
 =?utf-8?B?RjNNeGNoTFE4alIwaEV4aVphVG4zRlpuTWg3SFg0NGl2U3VIYWwrNjYyRk9p?=
 =?utf-8?B?dkI5U0d0Ukg2bnJJYjJlMTJqQUhWdjkyREh4UVdBT0p4N0ljbEJyVnVxalJC?=
 =?utf-8?B?aC9qTENPaEpyeHduLy9yNmdWbnFCQnFqZ2MzNklNUVJoelhKcUpDeXlaUkpw?=
 =?utf-8?Q?26BUReqsAHXLGUnQ2dsjcSrgXPSqXoqUVO8pJ?=
X-Exchange-RoutingPolicyChecked:
	gJQJ8WTbvEcr8SR1tZyeWXjHKg3x6h8OA+Jjug4daP9xYINrFMm9scZEGjstfpbAGU+ElMbjF/+KYesjSUFGo0OJeQPTOd5x1Y7QX27gbvsy4d5jK3WL8A6OMdH/yB+CG8ffQbnP0fxTnsv04rj8YynlFZEq6f4oT8/67iQWUxHb60xTRvcUO9LHDvCIsdxkezyrE51AYpQYPNMIPbKKFkSp8bnLROAz+huGF/nuoYDrrGC5Tsrg9JYw6QoZiFPuZrbwYECzjB3Wqy3Fu8Rq+euDLyQP8DqdObRhem31CiooJu6TLupjpsTEYmAaheep6/Waw6DdKHTZLQDWpyOL0g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	grqQNt1F/WT+IvtpijjqyVibJDDtUy7uyZX5U/PSwA6Q3dR51M3BAAzdyAM0wxubQMdCG4NapTqggcL7Eig4X8/36qCBS0yK1LFWDf1FdNBbWAGlVsUKs/QvQOtUFWH8pRm1k+Vkb0LXPYWJ8A9JF4SpqnZUwNy1qDzBI2FrUzGz4OarxZaITYviaLxLUpNpZYbjIDM5f2G2hnXSQl1pRoCC9uqcsCgbrfW2gdnQdsIpWjEvK6PCD4LA33JTHlb1MyP4+5uT1zfKIm0unGt5mJbjcH7ym1wz4UjWV2vF3H65B+EUEfFWqJwdhtQqGlhvO2+7jJaHYVGtlK6GNGXYupWiA8Mb86kfs5ML5hcaLt4fLClsZNXXei/LaiFqwXURvDlTS3udMEmMEKl5ljlDrqyl5fImseUuDS0B0vtJwoVXwuMRhpJu81Rf9DpULXRka1pfAtXpN7WAa7MP52++R76UKVnpU7yPpXmvQns4BwqvqnlheCn36dGalQrK4AFfEuD1/8+L+JAC4AaQyh9umSpFXk5yf/uaKhopDMMC6AApveHSexL+TXFarzxTPiJIRAYzuD28YZsylPt/EuRGhF/S+lX+WMnp9PywMBoctoQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a116e466-4174-4960-5178-08deb11cda98
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 18:24:22.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwZ9+FlNPvLquwEBzK9aGSpA1asQqM+GeErWwQovx10tbJS2AAlu9War+1LMwzEpyUONUJwGwu2fSf59d3+xNYTIYLw9C5DMu730xdPDUttzS4vH4++HG2A0lOg2jArR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=973 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605130183
X-Proofpoint-GUID: QJUvxh2l3WIXhWPbSnk5ZZtMDv0FjIja
X-Authority-Analysis: v=2.4 cv=AeCB2XXG c=1 sm=1 tr=0 ts=6a04c1d9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=kb4lhEofnV7w7_CQL2EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE4MyBTYWx0ZWRfX32hN1FGiBiVj
 3qLwvpSPvsJg6JAQr6c0RPdGwgjgzKM3OTnsEAIgRCb718vyBjslE2QUzoH2USl1doXh6u4twLV
 YKhGxF+k7sJ+UYYAPDR4zF7CvPVzmKYKROJVSnkvXuQWNWTUYB42NdivtWkirHBTZndMFmk6sSo
 lcGmhcp1vbrHcT1kd1/kcIu7GpO1dPPl1Zi5iOoBznasDklxMdqirqQ0JaDPNr6VWw2q9BE2Azj
 SgNibaRgUlsiKyxVpcp9luEMy8DF1Sp2NUHaX5dQzqo3pRbylCpvwhgLmx14kJiI/v1PXLFW/kT
 97wIltnFf6EXVNWLKZ/0IqU1JB+3PrXewuKlzCvyOr1B+9pOWlYcPvKFY/Xa667lTrJsvGfQyA2
 jatlbl2c+lHsDG0hCrgRRuOOzPJLbVt4NqW0HdsDruf/8IaB1wze/AH6zI72lnWRP1TX3h9UFir
 AY7vJ9QTSJjP19UFeYg==
X-Proofpoint-ORIG-GUID: QJUvxh2l3WIXhWPbSnk5ZZtMDv0FjIja

On 13/05/26 20:58, Greg Kroah-Hartman wrote:
>> void nx842_crypto_free_ctx(void *p)
>>
>> Given that we don't have commit: 0af7304c0696 ("crypto: scomp - Remove tfm
>> argument from alloc/free_ctx") in 6.12.y it feels wrong to pick up this
>> patch. Thoughts ?
> Thanks, I've dropped this and fixed up the real bugfix here "by hand" to
> apply properly.
> 

Checked it in rc2:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.12.y&id=0bb6a337dd25947a14658cb199b674b892fd3cea

That resolution looks good to me!


Thanks for taking care of this !

Regards,
Harshit

> greg k-h

