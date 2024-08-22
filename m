Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EEC1C9ED0;
	Thu, 22 Aug 2024 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346274; cv=fail; b=kEnT+WOINoI2kiv+nW80dZC1d4vlR9TB7wy0eS9jbFW3z1jmqSaCsyM3Ale/66eMZpQtMLfMEXJ2kiNoTQ0wOKni4bPujCoGdOsTcSmjMfgX5DO4/B3VEXZ+tRajI7L+juLYUKCFAtHmci9RQTEtcZUiwuExfmXBgOuMvOuAi+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346274; c=relaxed/simple;
	bh=jZaAAHVkhE/sn1HSnsEhuIFkYMUMsh2dhK4SqwbNch4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BLKZp2xIS17On07C69KJG/lAGntNDXKeA4yKshVFJeWyzEuNEFHw1ZE2QePZDe26rQz3fY6HsaBuk8tZISsaRBAbAPThj2aNmqlhpwUMlRtjxfyFDF5JF5NLlwQpAGqT2jhrXOxewawgc/8kN6BFgfhV7p5yEexcVqHQ9nrWcWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a0m5IaR7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cOtXC6XA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a0m5IaR7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cOtXC6XA"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47MEQV7J002395;
	Thu, 22 Aug 2024 17:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Yt9Ht5kNRPcG35s7P7IelFH10Xstdmc/cZH20gAjkdQ=; b=
	a0m5IaR7R+TfyyqLTpamRFxhUtWwFX/sW+iMP7mUBthwCMf2YG4q9Vb1DyyMmZnk
	olVa2mWQvMVx6sNImbCURfiiBCUSxtUi6SU/l8LVvdR3Rx1iEq09yPs3GZjbhLw7
	HBwdrPVljuuuRYSkHqlfEB4SQlfhzkkuAoy985JwpBsXWdi+2pyYXS9mEL01Lxi/
	atQqY2WzWk3x6EaQBHzSoaUFurilpzZngD8r1rsPiAerQpwrmckAR17hcEEPbTda
	Td/1VwJdXSDoy0MARLeCYqyyWj4kQgjGPJrCDGYCIJrusPDqUNSNvhoIu2bnv+P3
	1UoKRYa7uV6NtSdezJwA8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m6gjkp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 17:04:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47MGxYhq033478;
	Thu, 22 Aug 2024 17:04:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4169bbg92k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 17:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lYL8NgP9Ix005KjlhXd7ETMJ7i4mOO/XapR1bHczyJFYGdAEE7I6zZuFAxO37hVa12vqi57JfMM7ub6/9nRRC3X0c2Z2QRerkO+9nDM2WnyDR4C8CuxgUj+ttIH51H1MZPSIlTyyBcP9howge8VeqjMTq8+pxLxhksgV5NcjSg3OvKStmqyoNRMJ2e9d0izfl4VQTjg/NH2a/c7f1mla4F8t0/6zhKN0VQbqymDREONHA1z2nR9lgGmBdbl1RD3NmGBFHNBAxy/tEvDzy2Wmnsugj1UYBg/FngObbroyDuEkKH6MccY1LlCp9kNLFCUdpDJMDsJBK9QgiHUOLCF1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yt9Ht5kNRPcG35s7P7IelFH10Xstdmc/cZH20gAjkdQ=;
 b=Tg9z+jw9xNwL95FzLCreT1go4Ogz91lUN4gWWo53DBm98BlprSxBK4nWV9WdOMKYWWADIV7i0ODdcJK63ETfcgConA8JTA5P4GLfIQnHD5Qhjya4NjCG1FUTmZWNPKeaiE++U8qZ7k87TcdNFZ4F/1X3XAUiMIWBD3kF2AR+MWfx9US07jbyoETdxNtfxtYTsUbGs3LvAjkriL8kOJ6wFOy+wDyt6iCl/M0Ov0mA5SAq4Zp56yYCKi+S81IRGKAVPT5jAfkD/J5qLX2jxYnKLi5vaYCUA4GlOc4eldeMGdGZzVX31GycdVq2f0J2m8jYuEDGt5PAlmMl/WpGfobg2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt9Ht5kNRPcG35s7P7IelFH10Xstdmc/cZH20gAjkdQ=;
 b=cOtXC6XA2dLtUnpzW/K4dO5F+jq3qVVJXKJExpmZl55LGaoiDMO9Clcj1BMaipq2ovyc+Tj0sy8GkwbgeQKH8n4Z8iJE+AC+kHU8DHODkQyt67AuOkIcmfKIcEQLPe6RWsDOh6fC0zWs5nbxYXGouMmTx7s8iE3TffSPnouVkxA=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by CY8PR10MB6513.namprd10.prod.outlook.com (2603:10b6:930:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Thu, 22 Aug
 2024 17:03:21 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%3]) with mapi id 15.20.7897.010; Thu, 22 Aug 2024
 17:03:21 +0000
Message-ID: <29558b8a-93a5-4368-8954-7c7de0d9a0b7@oracle.com>
Date: Thu, 22 Aug 2024 18:03:17 +0100
Subject: Re: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Matt Ochs <mochs@nvidia.com>, patches@lists.linux.dev,
        Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>
References: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
 <e978b42b-3077-403f-a5b0-7da6b52f29d8@oracle.com>
 <20240822165931.GS3773488@nvidia.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20240822165931.GS3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0030.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::35) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|CY8PR10MB6513:EE_
X-MS-Office365-Filtering-Correlation-Id: 361d3512-3dfa-4681-5a20-08dcc2cc53d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qk1KSjErYVQ0UUU0RnFGVm9IZk5rTDY5b1N4K2pOdzNhZmxCSmU0K2dlc2NY?=
 =?utf-8?B?a2Z1L2hxR1Jzc09YNG1wQWJ0TnBQOGtxNHZQL2syTVF5Z0JQN3lYdzd0LzFn?=
 =?utf-8?B?a0paNUVRK0IwUDdIUzlhREY0dVdkS2JyNGltVlNlNkFlNzBIVStweGtzbW5r?=
 =?utf-8?B?RjdJUnhScThiYWRuRlpqWFptcDdHa0M2YnJ2UVVrQkhacUF4S3Rzam9OZlNu?=
 =?utf-8?B?dWVmKy9GbjA2Ty9IZ1o1MTNjeDdLTXA0cHZMMG1FV0dwVE9UbnBmdHdVSmoz?=
 =?utf-8?B?RWNjRkdycGVObmhBTm5BaUt2RDlKb3BZWTJEc3BLd2tSMUZOV05OOVhOUjg0?=
 =?utf-8?B?c09ZN3VORFVvOW9KeFFiOTliRm55eG5oVVcxc053Q0ZKSmpyalc4NkFqaHlH?=
 =?utf-8?B?Skd6ZWJ6QmpYdWMxVjZyY2NURUtuNEw1SVNrOElPZEg5eFFtK0N4QVZUSFRU?=
 =?utf-8?B?YWc0eE54YTVSUkNwblRwSjBoazA5WG9heU9yclFpdFJHc2Y4ZVBqMXk3YlJB?=
 =?utf-8?B?Q25vVzZrTlFnZ1NTYjlESDdkRGRvN0pZSTRjNHUxL25KUUk4ZUVwNUVvYkNI?=
 =?utf-8?B?UVMyTjJDVVJLUThFN3Y5MW1seW9DVzJxOUczOW9vN25vV3R2L0FwN0JEaEZM?=
 =?utf-8?B?TStKbGJybllyOWVCeHRpR2s4K2hkOHlFenE3ZDJQZmVrLzcvVitTdUo2MzEw?=
 =?utf-8?B?QzNRc216S0VaMDY2UndZTUNCR3Y2TENDbVFKTFJoRDNzQTVDTi9EL2hyeDhG?=
 =?utf-8?B?OWphU0VWbUV4NjdUQi9ZanRLN0dveDdXSXBteUNhQjZWY3JsNHlNR3VqVmdW?=
 =?utf-8?B?ck8wMTdoeGY4U3VCaFlYelpET3pUMEJ0QXhxa0FqTVVIdlljR3NiczhOOUdv?=
 =?utf-8?B?UEliOWlRR29oVzlNcjdmeWJPTEVZbGJSbG9iN05yZG8xazBTYjNPQ1hpTUtY?=
 =?utf-8?B?OG11U2owVzd5cVVkbmF5Wlp2cWpuakNtL1I0aVN1VWpxSjJCWm1vNzd6ZEVh?=
 =?utf-8?B?Y25lSStWZnQ3SUhoWGcrWGR4VkNyZUJrVzRzR0MvMUZDNElUa0kvVms0d1pR?=
 =?utf-8?B?Z1RHZGorR3F3UDZsdldvdk03Rk02REV2SGphNVArVU10OGFOWWlHN2krOEhn?=
 =?utf-8?B?eGkrWXZZOWY3cXVGclhYZXRJdURxVHBPVVZkaEpqajMyWk9VYnVaaDdwcVN1?=
 =?utf-8?B?WENweE5zcEQwYnBzZ1JUelRBMUVXWnRkZm1PMWk4KzJSc2UxVlB2V2lFQi85?=
 =?utf-8?B?Q3NzK0JiK0E0b3FHTnlqUmF0U0loVjE3VEVrcEEzWStIY0tJVkFHT29pQWJu?=
 =?utf-8?B?MXpIWFY1MDIyMHc3TGxkbC9qcGpXRGIrYWx6YVhReU5sbDV3ZHhpTGVYZzhN?=
 =?utf-8?B?YlpPRWhOMVZVR055Q1dQblF5Z3ZBODFJZ0VOL3pDOXJxVVNVVzdsUnRJbjNp?=
 =?utf-8?B?SUxwbFo0Vzdad2t3Yk42R09CYzcwTEMydUlQLzBpMlBDaXVvZU0zVTZRcTZv?=
 =?utf-8?B?ZUl5dEkyY2drdllFaVdPeTQ2MzVNTzdXQ2lKZi9RYU85TWtsMlcvS3MzQlZ5?=
 =?utf-8?B?d3NLSitYdFdDdDJmZVhYVm83TFAxTUxOMUovSnRSK2pGMWs1NVZoZjZ1QnZn?=
 =?utf-8?B?U2VOVG9RU0FYKytZM1UrMzVCaVh2Z2ZIR3dWSWh4eVJLbyt3NlJIK1kwbVpZ?=
 =?utf-8?B?UmE4YkNxNEdZNDJPYk5qUmZKQ1pwMWJRQzlEcmtlR3djbG5vdkJJcENEMGlY?=
 =?utf-8?B?SzhseTZHSVBGa094dkhNTkFJU3A1NnhmQkxFS09OaG5jRGxvV1FVTkVwalRu?=
 =?utf-8?B?Q3FFZnNTQ0ltMS9vTHd1QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REIzTERoUEFHVGF6VUtOVFlJcWx3OVVTWjZiVEpqUS92SWVkYTRiVG9vUWZK?=
 =?utf-8?B?MHpLMitOZVVKbVVQY0lwb1cxdXRHV2h6RjJIcjZXRU5haEw3MlU1VUlsUWsy?=
 =?utf-8?B?TjJJOGZwQ2VPVll4K2ZPazdmS01CUmhia1NVckd0ZHVkclZHam5yR1J0Slpt?=
 =?utf-8?B?bnlCK0pPT2ZhVHEzbnVOYThhdm9uVGFLWVZHVlI3THBYN05EVk5LdmRIbHVi?=
 =?utf-8?B?YWdNTTVyTGt4ZzNiVW1CV05mUHpsQ1g5V2Y5QWlHN1ZSZGQrdVlvQVIwdTZ0?=
 =?utf-8?B?Mmp5WlFlZEJnN1hmeVhtRkJVSkhZbXFzc2dVV0N3VHN5QUNWcG54aWVvUGR5?=
 =?utf-8?B?MEV0MlM3Zy9rZjAySnRXVkZWa0Fvd215L2Z1cDVXRjgyUWxON085QjdQaUs0?=
 =?utf-8?B?VWxIZkZ6WHZoeXYvSnVZWE9oVlYxRno2UWVTZUZZUnUyemkrRm9iRkpzN1Fm?=
 =?utf-8?B?RndkcGQxNy93THZtSnhkeDIwZDBrMFpIT0FuUVQ2ZTFXd2NkczZFdWRzQWcz?=
 =?utf-8?B?RWJ2SUs5WnpENXFBVGVNUFBCSFZmMmFsbUdKY3ZYaUZFcFlodUVZNnc3aCtG?=
 =?utf-8?B?Y1k4UVN5S1g4cmh5ZjE0QkJnZVF3c0U1L0lvYlVBQkRHUWFWcHQrVUtTbVk4?=
 =?utf-8?B?blVrWWFwUkpYWFQrYkx5WFplbGE1Z0lqblpteXFHTDZKMEs5YTNaRnVkU2Yr?=
 =?utf-8?B?RzNkUFhITWJxaXV3bEViTjdsWUV2RXFCWDRyYktrZHhrYlY1N25JU2RMdWgy?=
 =?utf-8?B?ZlJXakVnNG9DdldkOTVnY1RzcXJpR2c3cEpUWDBrNnVQSmVBWWtvVmF1SGxa?=
 =?utf-8?B?VFppbzIvaU9aUlpteG1HeFdtdml1TWdFU0JLRWdpaHRJYWx6cTVXSVZWbXhz?=
 =?utf-8?B?TUZtbTJNUDFZU25ObjFMU3had25WSExlWDVsNlp1RUkyWUxTUVRQOXRoUGpV?=
 =?utf-8?B?NnVaSE1ZYlV6WCtmS09WdDFMR1JCUEFLdUNwUXdMRWRwQmdaekgxd0szU3c1?=
 =?utf-8?B?UzYzZHAzSkRUYlJBM2xJa1NMYVdOV29FTDZveEVQY1VKRGluM2xIWHhNR3VW?=
 =?utf-8?B?UjZVb2t6cGFFbi9tUlBCbDZlSlF2NFluR3M2Y0g2ZWdpMGlvMG45cm1Va21D?=
 =?utf-8?B?eGlHRnZPdUZNUGVwaDVjOVVyMVM4NUYzM1hRT1FjRVFJWWUxQ3Frbk80OW11?=
 =?utf-8?B?UFB1ZHdQOGc1WWdXYWw4YWRGNk9HSGtiMTNrT0FZUWliQlB0MnlzaWdPbndy?=
 =?utf-8?B?VUY1cUpYMmhYcjNUcm1iNVdmZTVrS3dnanZoaHJJM0g4eGpRMVdGT1RXKzRr?=
 =?utf-8?B?d24vdlliajBPNERLZjlHVjNmdTAvcTF2a0hDR3Bta3lQcFBTZHFKZldnc3d6?=
 =?utf-8?B?bVNSVGZkNk1lTWYycWpKRzRCUFB6RzZjbk5KMlUxTXhSR0xhVUY3M0JjY24x?=
 =?utf-8?B?RDlXK08wckFQYWlPYmw5cjdsRU1VWDVQSG0zVUJ5NUcxL2NaVGhkTHgrRjdN?=
 =?utf-8?B?M2JnUFhKOHcvVjFKODJGNld0czBHbjJzaGdZSC9xWEk1QllTb0daNmhhNlNZ?=
 =?utf-8?B?VVQ3M2ZlZi9GbDgySGJnaFdxZmxWZk9WNm5GRThFM1hvVmFHeTd0ZDJ4WnBa?=
 =?utf-8?B?RE9LVU5mUDFrYjZNbWUwc2hwNUI3SkIvc1M3LzhicXREVXk4VTFoc1hxdVht?=
 =?utf-8?B?aEU0SVJNTlVldkk2UFI1dU1wYzRHd3g3cEdmUHVpRkEwdWdCdlZHNkZha2E5?=
 =?utf-8?B?VFlhTnh1YVFMaVM0YVozcDArb1pzMFVQcVZ6YXpjKzVMSHpjbTdDSzkwRnFu?=
 =?utf-8?B?bnI0NG80TFRQRUZGK0tJZHFrbHRZOGlHQjU5R0x1QmMxY0pJQk1PTkJzaVE1?=
 =?utf-8?B?Y1pzYjUyZWs0Qjc0QjV5SmF2WEUydndIUGNkT1NDanVFUmp0aVRNZHRhc3FT?=
 =?utf-8?B?Ymh2TUZXelpnUk9iS2ZvSDNmdmV4UFNjZkw2L1ZnWEYwQzYxOXRVcGZuYlRQ?=
 =?utf-8?B?NENVWDcwbUtKY0tpNHhQTjBUQlhkTlM2VEt2WThtVmV2UHc2THVUKzdYcUlF?=
 =?utf-8?B?b3RyZUMzejN0VWlZTHBDcUJCbjh2UHpQR2t3bzR6MS9qdkJCRVRwMXNPQ3Ev?=
 =?utf-8?B?TzR6VlRJSlZnZFZYUGlsNjlsV2JUMXlSWTJIMFBkU05EN2tDOEVMS1huMVJx?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5mKkgn2o5Ra1XRRq8+a484Bz2hZFi/VVouzD06R/dt5+zs+IBDAZqXxp6F9jS/Ywfu2dTutiFVl8vjApZFChPGwmc5ed4wNsqv3dAxyVsdgq50uTApvQdchJv9JWXctywC6b70T+U2ycez3w/7WbNjlUbA1DphuGhGTQ3Ubxytkh6GyBDkguWEFO7gNDMemhhx2AVbfoyDvO2W/BY623aAC6ngcpcaeB45vPX+9RmP0xilDUefmd58zVbeuW6c5QvSWWalcgaj6S/YVqIOduaZYmDClc+7hDYhDNHElEjL0CkD97S3fG8KS3BdD5OnbrdYxU68RvVrm06j+f9LiGEPlidQS9SrEqJeT0TRkAA+XXRgwRQQwBQCTcvWHYhPj3qwGbzH+sesZt2Wr/5w13NhqVJ/xWEQGECGWdFMir7YJrS6aqOpMR8QMvVbknI1iSqDVEg+kuULnemLbCsfLWgDFWz6jBiclBdLi6+Yep8T6zMRz2eDtvWyzYASIbrYs3PwQsxGndRkCrXXY/C5W534uiM6RgU0aux6+zDnxcF9U88UFqW2j/9Lb1+Bv3/hb/tLC8TI/CNtBDx7rQEyMBOIPRbGchyPGkBR4dC9u/Zuk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361d3512-3dfa-4681-5a20-08dcc2cc53d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 17:03:21.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wlhtErdQx8yWIX5PO/DmjCr98q4KaOrohx3xU+Os1Ya7oBrJhxknV3nsGf9jG1KtTqzp2RV1pj6jKsbZnDyhRrLzbGlnh2tgiKxAM9yE+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_10,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=991
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408220128
X-Proofpoint-ORIG-GUID: 0U0Ae8KbHd-fFue40R2SNPEZpgon1s4o
X-Proofpoint-GUID: 0U0Ae8KbHd-fFue40R2SNPEZpgon1s4o

On 22/08/2024 17:59, Jason Gunthorpe wrote:
> On Thu, Aug 22, 2024 at 05:52:26PM +0100, Joao Martins wrote:
>> On 22/08/2024 15:47, Jason Gunthorpe wrote:
>>> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
>>> index b60687f57bef3b..c360d5a7675921 100644
>>> --- a/drivers/iommu/iommufd/selftest.c
>>> +++ b/drivers/iommu/iommufd/selftest.c
>>> @@ -1342,7 +1342,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>>>  			      unsigned long page_size, void __user *uptr,
>>>  			      u32 flags)
>>>  {
>>> -	unsigned long bitmap_size, i, max;
>>> +	unsigned long i, max;
>>>  	struct iommu_test_cmd *cmd = ucmd->cmd;
>>>  	struct iommufd_hw_pagetable *hwpt;
>>>  	struct mock_iommu_domain *mock;
>>> @@ -1363,15 +1363,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>>>  	}
>>>  
>>>  	max = length / page_size;
>>> -	bitmap_size = DIV_ROUND_UP(max, BITS_PER_BYTE);
>>> -
>>> -	tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
>>> +	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
>>
>> If you keep bitmap_size then this gets to be a one-liner patch, but I assume you
>> want to remove bitmap_size anyways.
> 
> Then we would technically read past the end of the user buffer..

No, it's the same code?

I meant more that the next chunk in copy_from_user() can still use bitmap_size
variable. Because you are removing @bitmap_size which is set to
DIV_ROUND_UP(max, BITS_PER_BYTE) to replace with this equivalent below:

-	if (copy_from_user(tmp, uptr, bitmap_size)) {
+	if (copy_from_user(tmp, uptr,DIV_ROUND_UP(max, BITS_PER_BYTE))) {
 		rc = -EFAULT;
 		goto out_free;
 	}


But considering that's only one call side, then I assumed you just wanted removed.
