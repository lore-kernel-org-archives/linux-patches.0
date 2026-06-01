Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0783AE1A8
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322281; cv=fail; b=U0SDoZVfI/shXBsPdCyAA0P6Hy6mt4Ia7ZSKWnh5MkbJXP6nX2OqXd9LYRyStZOJK2KfWC1XQENjI2LJi3JUrp5gsHnCnu5O6RNYthmZAo8+iZ/xZJekLbRk8VbfSLlAnoHGrfeWAvSwlSx0Z287YkW/+huTSeUtiBxK19b/68w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322281; c=relaxed/simple;
	bh=B8iN1YMC9qMCatIJ8asdekVg0WNDdFICifC5eLCDd0U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aC+mXiTJPT9xrNnS1L1PvdQz3TNkbaiVnGMX2UdjhveDoKKmYpy7NCnfHyOWXbW0jpRCUZ6/10yee7phzdnmKPd9jshlNEylZA7cAwnvqM8qftTMsXve+4lkLk8FkfZoaDkv4pSuWH65NjkONCw5FeCTuzeAM1B01JOuZOjTDVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=navgL0Js; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DK3nZ8LU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="navgL0Js";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DK3nZ8LU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6511MVJO1893462;
	Mon, 1 Jun 2026 13:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+Kf4BpgG5v7M/zoCqDUjtVvKE1x+wnmtbHvNz66fxAE=; b=
	navgL0JsMrd8MuMJpfAK170snBEQSatgyyGKA9dZ8vyHqRLt+RdhcyjyDR5G6+/g
	RKJ6UyCyUHkR5Q9XH7kZiNmLkK0hEEmg9i+MAAXPRGvgM0nz6FxjGftQE0nXpgMU
	52RSo1AUGzCfxAIlQ10wejjj1Q6zoi2luz68RyRBKdVPhfF18cmsBjstc0bYPfvI
	gMYwrD79bfT1F2kPJ8nxY2xFGUQwc38kt7TE8hIIO8aNz09FpH4Dil5/lMbsf+5M
	f1K04/JRG3vBelhhmYjzOSxO9Yq0rZyXrC0dBVA5vVxa/8GHMODnDqnvmuM9SZck
	SQ62CPcOFJbGFiw8yxB6vg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxda81k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 13:57:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 651DsxKK006767;
	Mon, 1 Jun 2026 13:57:42 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbbw36s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 13:57:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ja9MdAf6jWPOy+4Pha4vEwlbgaxD3vs7vJH51JnMSZ1Yg/HPMwH8lxHQNtEpS5DLa+nAvO00dLUPLQHyReaIHg+gTkv1kuhwuj+UAwbg5pH1+UwWXys63O4/N5xkYIbWvxL43hSqMWV59rn8E58ZxHnEAm+c8tofViZyFWkC+9F85qSgijmDXov2111gs4lUa4OnMhnFrkTrossJ84fXjQEmn0MDmy1EuGOZvt8i/uG7KOaQBOTneeGk7j97quFeR9Av9WOKjWtz+zZ8EDkoR7+CfPMdA69ldKiEpZYUDGM7kX62jqYOete7wvppe4+Z9/abx5KRl9ZXc0NuGFhvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Kf4BpgG5v7M/zoCqDUjtVvKE1x+wnmtbHvNz66fxAE=;
 b=xaUxdJallL6e3iy0QqHW1DIwXlahaMZQCZNuHk9KLV7CI+9mS2oJ56oQ9+my/SoDV/iSvjcbU8ToubyqaYXPOtLwtXuslyhq9zO2tMkRHeppw+FL/EKb10xjvwR5qzI9uNHvEJnhNE/661cOR53vnbwKpcgOyKlOvLtyuuFEyZDshj9PhkLfSJjG3VyNRp6E+j2GaRyXNlVvKHmVVV23ej4+GLS/5NbPqc8MRriKrPTZlx2241kipP3K+fTdVKZd61Sl/ehvYeBWpWaW52bXCY170Abkj+p3kud6No9wh4cq//5pjnjfFc91iUt2hJw8L2Tw99OX90iAeu+Ae1iOqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Kf4BpgG5v7M/zoCqDUjtVvKE1x+wnmtbHvNz66fxAE=;
 b=DK3nZ8LUQvSWOzat4EA2jiiwI8z7qfZ4aODj3aVrOz5tC1pZWlpXICZDPZ1kLGpoVU31gegC9FnbrgwJy/WSgr9UoPKkD/F/LayB7lcqxcOU7tPrtoYfFuNZkGXNae8O77uaEawShWsfrs1YKO0vvYK3bMZ5nK/AfGmgXrOM4V4=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH3PR10MB8216.namprd10.prod.outlook.com (2603:10b6:610:1f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 13:57:38 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 13:57:38 +0000
Message-ID: <fad22bda-4493-4f92-a5f3-e8b802277e0f@oracle.com>
Date: Mon, 1 Jun 2026 19:27:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 041/272] i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT
 handling in DMA dequeue
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Frank Li <Frank.Li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jianqiang kang <jianqkang@sina.cn>, Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194630.531977894@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260528194630.531977894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5P287CA0004.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:262::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH3PR10MB8216:EE_
X-MS-Office365-Filtering-Correlation-Id: 6052d1d0-489f-46c9-187b-08debfe5bd8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|4143699003|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Pr34Lzmlq+BGAvNwakjsBgTal5krJeekvsm3RLfs2Plly8MR9OYrUAVBfo7TQYTtDBCaJLYFis5S9EzwJ/R07X92zkP+J62aJC39Ks1ZQmin4XgasoJU8vJ2AwbvXxncxiup1ASoszPqyWtZm6ToEJn+gpPk10UM/LpkPa5GB4+njXCPKEA9BmNk9otNax4upkpE7RbQ6VZQfB0DnLLvlwsFORDeeYF6unQRdWzcaDFgW9LIpaGpeX9HS8hrTD8FWmeepg20zJaqkxtLLus8LuW6uV3Foav23xn0rS70t8tW7nEAFjknFGpbQ8OKovDX5P2ZSvuUaDTF+NHIpBqd1z9x855Qh6KtEuXO+R8TYxtItC3yjcWFboBK9RhksdoFXoAL3iJ/rz+JKiHctFPH2c7gKEYqVexuvZNrufRDI+RagwDsfP8ead907FOJnJMQlbdA1wEkt3MwYhZqt9D2Z2RyLtr0hcmwcl4VhynkqyekWmJclQk2hTfofnXkW2r55LPheSW5bSREuM3GuMs3QiuPtWBczzchpscP2QMAlF8ShXjFVrrmKzQt6fdC/P8jbcDTanE9uYYSb9rHIp064MdrcFQOlzqUuuWWBh8yrd3iGkW2nRdBdrdUM7n5BfvRbtc9vcu5fIGXGnIBJH5NDA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4143699003)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVFidVpXck5GOHM2VmQvejlDa3NiazRWalFVV2lLTndLVmVQRDJOY0VEMVB4?=
 =?utf-8?B?SEVSc0h5bDVNQzI1dGFaa1pSVHZoZVdFVTNxOU16ZytqUEdQcFNoNVQrbFky?=
 =?utf-8?B?dXduQW5HTEdQQTB3NExmbThTbG5RaWJPYXJvRC9KcS9BRXpnZ2h6WWs3V3RL?=
 =?utf-8?B?WjYzMVNTMzY4WURUbHhtR2JVemxIUnU0cENHa1JxRkhGMFNnUkVEd2RoZ1Ri?=
 =?utf-8?B?MUtueTNMcml6cXNWajdaNkJEczVlVXpabFhYUHVYQ3ZWU2crd3RGQzhFcEFN?=
 =?utf-8?B?bjZyWlgxWjRNQVVhOFRxcTY1VjEzU0RmSWJoTlBUcWxwR0hjbkc4UENwVFVM?=
 =?utf-8?B?cC9GODhkc005ZmFsS3dMdFBRV3UyZGN2TjZCSEVSY3hhOElTRjJ2NFBYaEtQ?=
 =?utf-8?B?dlVuK0V2Zit6blpZWS9uUk9xeDdKbzY1YklIU2xxRlEvNTBaOUd3NjYrRUdY?=
 =?utf-8?B?dnhRZzc3MlFhVzhKU3FsSEZ2aGt3dUl4bFp2YkpWYXE5SVJhenBOcDgyaTQ2?=
 =?utf-8?B?LzQ5K3JIdjc5UEpDbHBYZmFGSksvRm10Ynp3R1l3dHZYTjBtOENMVGVzM0Ju?=
 =?utf-8?B?bDVUaTBiMTlLU2h1MjZMbG9UcndmbWE2a0NIWHl6RWVwZmVHbHVaVERqVjlM?=
 =?utf-8?B?Q1lHREJxRzVCeGZPNVNGM1hwWUFxenVSa0xUNGh0eCtja0UxZ1BsZVROdmUz?=
 =?utf-8?B?S0hoa3Y1MElVRFZLOTRPcVExTmc2Qng0U3VPZEduUzlONTFhSE5nTUxRVFAy?=
 =?utf-8?B?MFhjalFUL25pNkhhREtJMmZkV0NvNm9KaGI1anZiTXdnK3FSMkZFZWpmcVFG?=
 =?utf-8?B?WXNZQXNHcFJENDVGcVV2ZUVQZjRzaTdQUk8yV3ZEZlQwaTZEaGFNK2p6TEUr?=
 =?utf-8?B?MEFJTzNGM2pOWitCTS9RQWtsR3VtWG8zWExxcUhKc2JRT0lhU1ozR0pNSDBq?=
 =?utf-8?B?Nk9sWDBseThZZHo0V1FHbjhpdVh0ellLdUxUdlRQbnZuZTk0SkhNcGZXMWVZ?=
 =?utf-8?B?Z2xvVk9DZzI4cWpzVmtyTmZTakIycUNKbk9iTnpCZWw1VWJkL3hrTVdrRVph?=
 =?utf-8?B?T1lQQysvbmxGUUFqanJZM3owbVZiWHkzZm5EZjhBZzNjbEVxRFZNWlJ0c0NJ?=
 =?utf-8?B?dFJzR3lKd1BjOVpCK3VyR2dvTkROSGdxSlpUeDY4emREbXAxVEhDSzNERVZW?=
 =?utf-8?B?TzJydzYzN3ZEbjV4UFdVWnpscG43Y0kwa1RlVzZQMm1iQWFwSk1UYzZCVXN5?=
 =?utf-8?B?RnhkMFVscjFkZG8veXZJaXpuRU5TU2dBTWkzQW1nNXdtVkh1N2V3YUx6NlBt?=
 =?utf-8?B?UjNqNm1CVW1HUURrUmszRHZZSkNRYm5jVkRMZ2duZFdHRmtOdjNPc09jRms2?=
 =?utf-8?B?VHpOb3JYNHBWaXB4a0xIWms3bW9COVlyY29YTGhBcVg4Q1FoTVFJaUhJS1dO?=
 =?utf-8?B?bjMwbUF5OUxDNTlBMXRnK09OTC9HN3VWZHBOYlFLOFBvZjk3cnVmM1JoaWFG?=
 =?utf-8?B?ODRUOXFQZ2tOODhyRjlFNG16bnVscXdENDhOSzU2WFpkRkNGV2FrbS9IR1hD?=
 =?utf-8?B?aTZ3Zzc2bFRJMnZZVkJUVkpDTmM1K2tmOGEweDVLNWRxQ0V5MmhJMG56dDhH?=
 =?utf-8?B?TkhwVkk1V3NXNzlCOGlKVFJDTDZKLzM5b3l0Qy9HSFpVeHhOMGY5SGtFTFVS?=
 =?utf-8?B?SzZCUjVXSkY3b3UwcXZkL3FOYUkzc1JUZlZrNkkwbXIxSUdXdzM0czZzWm5F?=
 =?utf-8?B?eiswb3EwVHpBdnZUVWVmTTNrUkZQcDdib3lnUFpBVHE2dUp6bFE3RHVrTDhN?=
 =?utf-8?B?ZVlmdFFJaDVpdThSSmozaWkvanhyVTMwMjlyeC9paE9JSDg4TVBJdDdxZEhi?=
 =?utf-8?B?UTE3TmY3R0wxRE1SSUc3MGhETVhhT2hnZVNQZlBtM0sxMGdRa2JvL3krT0NH?=
 =?utf-8?B?RnFicXFONjVTZHhsNkQ4UHJXUHU4WXdFNE11NzBQc2FuTXl4ZWFPZGtXeG1n?=
 =?utf-8?B?Q3FReVU3cVg2N3g2Syt4R3hzMnhQRVVEeUluOVFNMDBlaWdNTnRGTm05MFFI?=
 =?utf-8?B?cDkvYWRsYlo4c2lPNHpqd0dBWStTalpXWUN5cE95Rm1MQWphL1g5YlNuVlY3?=
 =?utf-8?B?ZmdtVkRUd1p2am5kQjJZZzlITFNzS09yazFEYzFGemJKZ2R0QXdoWGozWGcx?=
 =?utf-8?B?T3VKYzI0TTFRTWFGUzUwVWRMeHRYOXJZUmFtMFgrRS9ybkkrVXJ0UVJnTFo1?=
 =?utf-8?B?QW9wcEo3VDIxaXFISTFMS215Rks5Ti9jSVJiYitKSVVEcFRaY1FJMHVHTFZW?=
 =?utf-8?B?OFRpcTJsTzRiQnJEanE5UUc5SEdydjZuWXZoblY2L3ltdWxEcnFTNkhsYnZ0?=
 =?utf-8?Q?gsMUB3hhoNn3EONgZ13n5Mc1/KdA2JXCgrGkK?=
X-Exchange-RoutingPolicyChecked:
	p6RlimcnaCbreiBWLdbA93ulz69WPtFXAh83Mq4udT+Q66/pC4ksAfIhtVHGKFWH80ReQuGXRWzJXHRYAC8GR/indFnG17aAxCVbTX6nTti3jGNLm5R5+k2+jYecDHnHXUuG+rA0x2LWo+Xsvxm8mYDH/5QZ2cOrUvxoVxFx5+Tm9JBeaTJ+8+r3xkXZvro510UW2E+c/ffY/rsWi5Tie10sch7nrJFCGjxYvCbvARY+HQPS2s7OFhDyArVYb01ftOSrdcRoCSNCkrqs6iswYJiq2WIwcM2nKpNkV+DOqweTsMKnUdukAB2QKCUmSqmsurcg1Ri12hdJWu7nsgYNrw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iCpJ15XrtbVgZK0oUCbcAu1k50YLl9fvNK0Pz2h62ekVOl2oJEuvB+Ll9GDT6zgjSpN2Iu9DG2cxNA/7JS4foeRn+bdIoL964EK4ubZP3ELxshp72vS1/vcITBVVvSeTvNGSs/UtQxi/XAkbq+h86a83J45Jrj5uh4MsmmzrdB4eAjT8pcttzLdUgIaHjgpJQD4DVC6fWd8VNoQWKEus4B4vBTan40WTe9NHUAXSGpvP1v25HEY7idV4XHTVMUJBTGMSnDdas3zIhS6Xob/ixdRWDt+kljlxSXELgZ8tEqElREUT2RyAsk1ZgRSpqnZ4jX+H2lacgnCGZJrkX1zyQ/UmwMn+OUjhFOEb/QzACjDTg6MafX6WjJM+Vx1/aEQBv+4X+u/1wQp+fYvIsmsWs767+QQX1QOeVEz0oSzouVU1dteP8izl6+0TAoSYNVzHddrFAuBq1b/jUyWdurDbDhUW959WH2nf7fZbpih7S1oXr+W/vvW00mdM7rn7t7x44OZDbjJxuneQbRivYtsNAgCRqBi8xe1MRvsBeatZZzGDce5qyqyftLpcaHZNhcWCs2+alalEhA8WWDKTQ1VhX29WP/C5zIq6FIXOSaF+Ero=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6052d1d0-489f-46c9-187b-08debfe5bd8f
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 13:57:38.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +e4BQC5UD9npm2p70C5rQDerFL+D+/tAl1MDgWvV9jd82A7WNQf65/HuUxktmAnO7i3bolM0ufoqkShMdItfBjBGWLkVB0u9Pxer+ki8BLYGhy1p9/bHVSMu9PJE3Ra8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB8216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606010139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEzOSBTYWx0ZWRfX3whsevSV5kzd
 MZZ5mk4jQS52AtdYuWjsfZ0dMvcHMq3Lc05bGaDDFyDWyb3b6x0NhGzOJ/fKCu/zM8n1RsSZ4dm
 ZE33k+tj7gYCrswMnbIFyOMNzyotlmp8a69yMU9INCNOId9/ltr3Hf3p4xTzlxwfoLz9PQUqY2m
 qY+PqFH7J8pWr067wMvCOfjK9tqzecAlkSxoITLYem5rnExF3di+u4v7x+9Oy994ZutxRjOvQxx
 PPQujD+lKHGAvrQSPQ8Xyi2QVt2jj9ZbO9hkLyB3vFmDko/mF9tuxEWb4F42adBIffIZ5s5NH+0
 HV9H5/83MKFTVImpXa8n5BohKmBChPnRjbXHPMeUjrT2CDLw5BCbnGNfvUxSMYmHStw76H3z4M3
 Lfz0AlEHvuWIw1cHNhiigPcsyIaIkTRbyaQL4THVSbt+mjA26tCf5ELM8sQuBPFW/nXTOIEZM74
 84W6qu5uE4kbWoXcX+g==
X-Proofpoint-GUID: jf9rd2njyZq4u7ti2x8oCpEw8m8noLH1
X-Proofpoint-ORIG-GUID: jf9rd2njyZq4u7ti2x8oCpEw8m8noLH1
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1d8fd6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=8AirrxEcAAAA:8 a=P-IC7800AAAA:8
 a=FOnGQU0Qq5fygM2ep_QA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=ST-jHhOKWsTCqRlWije3:22 a=d3PnA9EDa4IxuAV0gXij:22

Hi Greg/Sasha,

On 29/05/26 01:16, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> [ Upstream commit b795e68bf3073d67bebbb5a44d93f49efc5b8cc7 ]
> 
> The logic used to abort the DMA ring contains several flaws:
> 
>   1. The driver unconditionally issues a ring abort even when the ring has
>      already stopped.
>   2. The completion used to wait for abort completion is never
>      re-initialized, resulting in incorrect wait behavior.
>   3. The abort sequence unintentionally clears RING_CTRL_ENABLE, which
>      resets hardware ring pointers and disrupts the controller state.
>   4. If the ring is already stopped, the abort operation should be
>      considered successful without attempting further action.
> 
> Fix the abort handling by checking whether the ring is running before
> issuing an abort, re-initializing the completion when needed, ensuring that
> RING_CTRL_ENABLE remains asserted during abort, and treating an already
> stopped ring as a successful condition.
> 
> Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Link: https://patch.msgid.link/20260306072451.11131-9-adrian.hunter@intel.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/i3c/master/mipi-i3c-hci/dma.c | 27 +++++++++++++++++----------
>   1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
> index b9496e8c4784d..44461f13b54cd 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/dma.c
> +++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
> @@ -457,16 +457,23 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
>   	struct hci_rh_data *rh = &rings->headers[xfer_list[0].ring_number];
>   	unsigned int i;
>   	bool did_unqueue = false;
> -
> -	/* stop the ring */
> -	rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
> -	if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
> -		/*
> -		 * We're deep in it if ever this condition is ever met.
> -		 * Hardware might still be writing to memory, etc.
> -		 */
> -		dev_crit(&hci->master.dev, "unable to abort the ring\n");
> -		WARN_ON(1);
> +	u32 ring_status;
> +
> +	ring_status = rh_reg_read(RING_STATUS);
> +	if (ring_status & RING_STATUS_RUNNING) {
> +		/* stop the ring */
> +		reinit_completion(&rh->op_done);
> +		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
> +		wait_for_completion_timeout(&rh->op_done, HZ);
> +		ring_status = rh_reg_read(RING_STATUS);
> +		if (ring_status & RING_STATUS_RUNNING) {
> +			/*
> +			 * We're deep in it if ever this condition is ever met.
> +			 * Hardware might still be writing to memory, etc.
> +			 */
> +			dev_crit(&hci->master.dev, "unable to abort the ring\n");
> +			WARN_ON(1);
> +		}


I ran an AI-assisted backport review and checked the 6.12.y tree.

The posted backport adds the RING_CTRL_ABORT completion handling, including:

     reinit_completion(&rh->op_done);
     rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
     wait_for_completion_timeout(&rh->op_done, HZ);

In upstream b795e68bf307, that path runs under hci->control_mutex, and 
the ring bookkeeping is also serialized with hci->lock.

@@ -546,18 +546,25 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
         struct hci_rh_data *rh = &rings->headers[xfer_list[0].ring_number];
         unsigned int i;
         bool did_unqueue = false;
+       u32 ring_status;

         guard(mutex)(&hci->control_mutex);

-       /* stop the ring */
-       rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
-       if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
-               /*
-                * We're deep in it if ever this condition is ever met.
-                * Hardware might still be writing to memory, etc.
-                */
-               dev_crit(&hci->master.dev, "unable to abort the ring\n");
-               WARN_ON(1);
+       ring_status = rh_reg_read(RING_STATUS);
+       if (ring_status & RING_STATUS_RUNNING) {
+               /* stop the ring */
+               reinit_completion(&rh->op_done);
+               rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | 
RING_CTRL_ABORT);
+               wait_for_completion_timeout(&rh->op_done, HZ);
+               ring_status = rh_reg_read(RING_STATUS);
+               if (ring_status & RING_STATUS_RUNNING) {
+                       /*
+                        * We're deep in it if ever this condition is 
ever met.
+                        * Hardware might still be writing to memory, etc.
+                        */
+                       dev_crit(&hci->master.dev, "unable to abort the 
ring\n");
+                       WARN_ON(1);
+               }
         }

         spin_lock_irq(&hci->lock);




Downstream 6.12.y has the new reinit_completion() path, but it still 
lacks the MIPI I3C HCI control_mutex and the IRQ/dequeue ring-state locking.

So the backport can reinitialize and wait on the shared ring completion 
while another timeout/dequeue or IRQ completion path is still touching 
the same transfer state. Thoughts ?

Maybe we should drop this for now and queue it up with its prerequisites 
together ?


thanks,
Harshit




>   	}
>   
>   	for (i = 0; i < n; i++) {

