Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E95A30BB9B
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 07:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770361970; cv=fail; b=dDCb1RVepllRGNuOdNfV29ESTQnEtHBrhDopx97BZBCVtksHa9peoL0nGlVWMhkL78AJOJIjlFW/HlscTRtheDXKo7PM1A4YQ0IUE58zsDIRCRXLmCgWdG2FgppPuxpbyBhiaCv14mFg27MjbuxIfruIl/EENjhmz8q6/BrHsPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770361970; c=relaxed/simple;
	bh=iVAEBVC+CpUsgLis2bdVNRmsOsbkBkeMlpqvF1dfNjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VWJT/ma1KGo+gwbUasq5/fSe2U9O9Ousy62+3/UEGO1peml4eDhBvoWlYPS9LHieYttToHhARt21MYMQErC2N2FGgrANXDi2plM0tfCE70/y6AIpYmplNZI4RyehUG8IwFk4xKV5Cc/DuoDq2J6J8xxO4YResbhqi/yz/jqKQ3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JjhgUaA9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aWJFVWo9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JjhgUaA9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aWJFVWo9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6166JVfO482305;
	Fri, 6 Feb 2026 07:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uex8MeX3y4cfbHfjv9JIeKs4xtyEKBlZk1qfDCyg03k=; b=
	JjhgUaA9UIzdG0jGkHDwdO9lIZ38rvIPKtzUEGgzprLfuFyrawK/+3gh9n0U82l4
	9tOXxLYoRNfZEZZdhRerJvNrIWvMlqTapArd8HNTC3xcJa+VJ9yUZ/jy6AL4Pd41
	1TiuVLbjD1UxZd9C15j5T4b90ICNV8pRtNlTprICXe+Xxhhlx9pnWfzZSU6lqM47
	/oE07AGoXjqiACVMOEkd8XXfec39tOYuunmWdxXSctgU9NfY6U0vqdQBPMYA65NL
	blLV+r6T5v/4CeIQR9DTk4DZ+iUGzmn8eT3U2HVb6AYQyatJmAp71M1AidMtp8ak
	p6J+nRNqeO1eLbpCWdbZVA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb50p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 07:12:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6166B69B031171;
	Fri, 6 Feb 2026 07:12:32 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186rskrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 07:12:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pylq9QVIhMIBfDUOcizqLK4F67amea+pNdRsa7DmkVoCpv+S2U1DizBBX+inzKAYeou6YsuJzTsLP51eWA0xJwTLI1fxO9JhUt75x9LctsPrAtoBg8A+mR16uZQxrOlGah/f7QdNDoYgOWmvAqxdpR4xaM0x2hHxedyMadw6p943ZYjawetoNwga6vzVVIUrhZc9dGSrHZz7TAA88GcShNeIHUnsVWGAMO3uX2GCKBJrQDDVTbi9f1yPLXtunOquRPtP8vgc1VRAkrn6v8tLRqHWzJXvjUdKC60ufW3reZYPhN+q+CN38yht+/hLXdIhpp32xYkK74Qy/bgeCWGJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uex8MeX3y4cfbHfjv9JIeKs4xtyEKBlZk1qfDCyg03k=;
 b=LGeFCpTpqzpAJFSXoeoDB6pygX5xTydQA73u+FtXmUxwho/mbd7gl24RKZY863tCMbIZ5oWdCeQAu2X3EcndqgzhVcb8gRQBbmYt0E5g+BZv/F76lqOG9X8brj4q1ok8JLtt4BJkKA3yulX8aaUMTz1C0b/I0FGfKus+T0D/4fuZIa01qswNsGUT2UbWHjHRwTxd/SHcjHucOtBAqCEevbEWi1WPTfJN081M4F6+k9+qHHrsCePWwGDR4ohAfvq+VGcqTVk4g+QP3PqEkHJkJYjlaxnAsITufPZt/yuGqAg/qst7jVTJXKbh2vK2OxwNUMAb1l2MeR4ZC7VySsOmHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uex8MeX3y4cfbHfjv9JIeKs4xtyEKBlZk1qfDCyg03k=;
 b=aWJFVWo9B1JT08ucZqS7sCteutTrvBM/Lk90XYwgRxYQcPH61d/HPZpIcYQZ4dImU4f6jECbugPohFgq73Oocj/uUvl7271HLmpY299KVLIiQGZe99USNNQ0DRsKOzvjNHGTUAeriAjQhmKrFJjLqwsx/kPbHxtsBzZgw6kh4YQ=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by PH0PR10MB997689.namprd10.prod.outlook.com (2603:10b6:510:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Fri, 6 Feb
 2026 07:12:29 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef%6]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 07:12:29 +0000
Message-ID: <0d1bfeeb-6304-4fe0-8e41-1053d241b518@oracle.com>
Date: Fri, 6 Feb 2026 12:42:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/203] 5.15.199-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260205143441.536029503@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20260205143441.536029503@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0160.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::19) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|PH0PR10MB997689:EE_
X-MS-Office365-Filtering-Correlation-Id: a4fe3caa-f0ac-4ea7-e27f-08de654f154e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXZja0J6WVQyVnVMT1JSVFNHQStLQmdqTUxvZXhrMTVGekl3WWxTT0NLWENE?=
 =?utf-8?B?eTA4L2JDNTJKSDFXK1hOek1kVkFIRGFqZWpHdWxoOEpvZ3NCTjgwamFXOHl6?=
 =?utf-8?B?RGN5SVFFcjlDVzFLTEpnUnFLVGFlblhwQk5HckZ4QmdETTlFblhrNmRDbVpQ?=
 =?utf-8?B?czgxS1VQa2tpN0tyL21TNm1hV3cxeGJySUw2SEw5Vnpad05wQzU5TUwrQy9n?=
 =?utf-8?B?ZzZjcnhDZjMwQlZocENKTFlHU0YyTmFYam5hbjhnRTZENVpPd1lkdnBhZDI5?=
 =?utf-8?B?cFlEeU45c3IwZXJGc1BxU2tad21iQ1NIS245MW9IU1B0Mkk1YnZHdGsrNHdp?=
 =?utf-8?B?cGhXcm5YVWpoNGFqNElCdjJpWG9YbE0waUFva0U0bnJCdVhwaG1lWTVlVnM1?=
 =?utf-8?B?T1pvN3FrS3ZmY2wxSTNjZkVONkYySWkyZjhjUWh1d2dYQm1uNjNuUXlmek5U?=
 =?utf-8?B?SWFHQ09RbmVUamFnK3ZlQm9sRDZndU5ZZmRJNlhQQUptNVFJUStNK3BXM2s1?=
 =?utf-8?B?ZjhPNlVQd2ZObVB6Mm5hNVRpU3lQczZDb0tSZU5GbTlEdy9GUWl6d3dzSXhi?=
 =?utf-8?B?V2J2SjdlNzRoOTB0dDVDNjJTM1haYm1Zd0p4TW1Dd1N6Q1RqNFBvSEs5MEli?=
 =?utf-8?B?ME1jMEJRUitkRkRpYjFLa2ZwUUh3SExGWDZuem13MWNtZVdWMUdLYndLRVhJ?=
 =?utf-8?B?TWg0OEs3MU15WjNlWXRETk5NN0UvTkxLS1N4cVZ6bUl6WU9XcHFiVUtySzdk?=
 =?utf-8?B?VjA0NEphL3p3bTd3YWZabUV3Sk9KTWlJUnkwMzV1UVV4bTJ6WEZqWWZhWjk2?=
 =?utf-8?B?L1ZyUk41cmwzb2xCNitrbFZiU29EcGtCZDNzVmw2SFBYd0dqeko0NDFsd05P?=
 =?utf-8?B?UFdyVGR5dTlyVWY3c1pJR1NUS0tzTHhUUy9FbzBNTitNNFV6blVYSjNWRnY5?=
 =?utf-8?B?VDhER25ZVENteEpMd0Q0aW1VbFpYZ0lWMWVSMzFYcjR2aCs0T1JQMER4aFVs?=
 =?utf-8?B?eUhDSElxL0U1Nk9CR09KTDZpZFlEYThCcEk0UGJSeUVmcStnMzN1U2V6WEtY?=
 =?utf-8?B?MTVuQU5MYlpHd3o2b3g2RnNScEptQzZlVGJFL0pQMXFYemJ0WGIvUEM0MGdO?=
 =?utf-8?B?czIvNkdYSG1MZ1Q1b2xCVStLcWJpRzRMNXU3L0Z5M0xtY1RleXQrNDM0MWdE?=
 =?utf-8?B?SWFmNk1yT1N1enZwWHp0aXJ0TGgyb3h6eWdDWnA3NkZ2emM2Nmd3bGY1QzN1?=
 =?utf-8?B?d1ZvY2c4R2s4SjFkdlZ5REpCZXg3cXlEN2NmRW9TR3hyNDNKaU03Z3ZSMVpV?=
 =?utf-8?B?RDNWNWxTNVZMeWZGV1J4M0NYb0I0NVp1SXNLSGtEOXJNNzZaSE10RGxXMFJv?=
 =?utf-8?B?azBjSzNWUk8rYWhxNnRsZW84alRsZjJqU29pcGI1czl3cjVkd2RsL3F1cnZU?=
 =?utf-8?B?YnhKR0Y4MndlVnpOcythYzdTd21IWm9pY0YvKzYrU0dETFNYOWdLRnhzRHJH?=
 =?utf-8?B?blVoYnExT2pLdFE2WFlZY3d4RmFKVkt6cWJPdVFaQXh4U3E0b3FOaXcwMjV1?=
 =?utf-8?B?UTZqRGNIYWpEK1c5YnBiL1A3ODlGNU1qR0tEZHNBUktoeDVyYXg0bnVQbUFE?=
 =?utf-8?B?N0FoK1hVdElOSkU0aEtDSnAyM1pScWZ1Mk5wd0VwRTRBYVBGS1V2SGd3KzFL?=
 =?utf-8?B?eUpGUzkwMHdUbkdZL2E3Z0pxcmdmQkNqM21ydDF5TmRGSFUwalZnQkp5enpP?=
 =?utf-8?B?NC9yeVJzRmlNaXhVUjdieXRnSWJZY0lzcW1uRnkya2I3L3grSVUyZEg2aVhn?=
 =?utf-8?B?Mm9CTld4TkpFeEFFKzB5MldUcitTUSt3SzM0N2d6NHBMbnZRY01jZGNPcGow?=
 =?utf-8?B?SkFrQ0haNVhwQ1dkMlNDUzAvaXlBcTI4VmtsYWc1VlBOQmg2ZVg5K3lSdWpF?=
 =?utf-8?B?VjFVUGhXNFQzVTk3M3RyUWc4L2dIcUdqWERwT3RpREttNEVGaXZXaHdLVHlD?=
 =?utf-8?B?ZktLOTlwRVBsa2hPYXpteCszT2U2bkhLVUF1OWtDYUVMSXhac29Pc0tRQlVw?=
 =?utf-8?B?VUNDZ1ZLOGc2NXBJV3lzTk1ZKzdRL0FnbkJYWFUxcGZkUjI3YjFNQXB6MFVs?=
 =?utf-8?Q?5m2isR8szS4J3lWrTLJrjV5ev?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGlhb2pXNGxXeWhLUDV3UElaVzBCd2VHMGo1dERWRlJ0RXJpYTRNUldiOGhF?=
 =?utf-8?B?dmM3WkZoOXp5NHJHOS9ZeUtoUENnaXNjcnN3eXZWelMvK2NGY2xYUi96SUJ6?=
 =?utf-8?B?VUtHYXhaNVBnSUU1MjBleHh2NFRLa29tNEZxMXRZd2UzTDNMbnY2SWxTWFBL?=
 =?utf-8?B?RExrZkdvSU8vQ0loUFYwZDVRdWIwUGxsZHhhUXMzM3NjRnpWZEVpNHRncmNT?=
 =?utf-8?B?Q1VJSC9ZaFg2bU94RnJaK29VbEMzTzJUVy92KzlxY0hRcGFoaW0yY2UzakhR?=
 =?utf-8?B?RC85blBmeUpmZ2tuSmFrQy9XTmhkWVpyb1M5UU1Sc2hlUlJFT2FhNHB1N1hx?=
 =?utf-8?B?ZHBNTlFJK01nWkl3MnJueDh5TytaWm15TmhUNWZtQi83TXBYRlFIRTRTMHYy?=
 =?utf-8?B?eWVpQTR6QWphaTB5YXpCaWZNY2VOdUxsTkszTjJBYVh2aEl2WFp0ZUY2R29n?=
 =?utf-8?B?VnZWbllrRFBRYzBwZlN4VGtsRldUUjVmeXBHNW9nZndtdmhHR3AzZU1KNFBH?=
 =?utf-8?B?N0c0eTByU0x6aTV2NCs2dnNDdm5zLzJBcXJzMkNJbERaU1pxcVBGS2pHejcz?=
 =?utf-8?B?RmtXYnYvVzM2R3lZbW5TZldFUlRHWXk2aVhRN1VkdjBQZHRia2tjemJ5dndM?=
 =?utf-8?B?N3E5SWgxM2lNVmpKZzlkKzFXZ1pwdWdYVkhzczFFdU1OOVJ0dzRLNVFXU1dD?=
 =?utf-8?B?TEdzNEczdTlvdDFlV2syOVNwTEZIVzQ2VGE0SjdMdHl1RjM4WC8zdDFVTERI?=
 =?utf-8?B?UnpxWlJSOXhxZlN4ZEpjbFBSVC9XY0gxZ2VqeEs4KzhqUUpRc29rTkhsL1lM?=
 =?utf-8?B?SG02STZ4T0xlTkpRR1NMZkw1ZDU1LzZqb2VoRnRpd3JacHZhMWtWRStPUzVS?=
 =?utf-8?B?WVNza3dxaXRLK0Q0eTVTT0dYNmV0VFJ2NThkaUk5U3owb0FrTjZTY0syT3FJ?=
 =?utf-8?B?b0hmM0VjSDhHSGMzMENHOElibkRuNzM2Zk5Ccmd3WmlGWmdwcXF4SlhVZk1R?=
 =?utf-8?B?Vmk0OU85THNvV2RXSzhRZmxydWJBZ05MTnYxQ2xTZmFPZml0VGY4cW0xZTdM?=
 =?utf-8?B?NVJhc0Q1VG9HZkg1ZXkvYmk1NXkvQ1RiS3RvbjF6YjdvbkpON1NmekxjbVg4?=
 =?utf-8?B?SnY1eUV5dXZUMHp6WVMvb2Zaa3FNaTI3MGZOMzVWY1NQYmZBZzRwOUQvZW04?=
 =?utf-8?B?M2M5ejZOR3MxYU1adGgyZkR3TmhzcGZuLzdTMm1sZWw4dWlnODBGYys1WWpE?=
 =?utf-8?B?YjlHZ1NBNWZ3NVRMZUdkMXlHN3BZUVppUWJISFdtT0d6Zjdqd0tQUVp1bGJF?=
 =?utf-8?B?VlU5WUhpWDJ2RHdtb1hTMTBZRUpHZlk5cUx3RkFYM1J4dmRTWTN2RzZTUjRl?=
 =?utf-8?B?WURjeW5wYWVjMVNOS3VtK3RJbnlSdjQrYlpGMGFKTU4vN0xuL2NSWXp6K1M0?=
 =?utf-8?B?aGgwQkRlZjNYZlNkZHZkSkZpYlJGSGV5Q2o5eElHelJZTnU1cHUrOVJqbGRK?=
 =?utf-8?B?eUZ5L3hhWWlhZ05yeU5sTkc2U3Z4L0hrc3g5bUwzTHkwM3VZL2J4SWFBYXIv?=
 =?utf-8?B?TlVJOUE4OHk3emxobE1VQnhJNHlVakdkeUswVEV6dzF0ZzlqL0VIdHZaK0oy?=
 =?utf-8?B?dWduWkFieGNCbzBJcmVhazR6ZGxNQmgvdE5KZUJ3TE1YUFpjeEtNeWZPejU0?=
 =?utf-8?B?UXFSakt5VUxSbnVlUmhkM21hUnd1WmJrNU1QdkVzdW9PeGcvYTJkZUNJL2s2?=
 =?utf-8?B?K0xVQ09aUmRvNEFkTlYvN2lJbkN1eFpqcFlJT2tmamdsWkt0eXJ4cm8xNmZG?=
 =?utf-8?B?Nm9td1VrVlMzVVdIRUMrbFJpdjcxVW5ySEhJQk83azhWK1hqNGUxenlidkkr?=
 =?utf-8?B?YUwwcDJSa1lRZjVLTFNSV3dvc0lPVXgrcXlpSG5VbW5nYTJwdlYwWUdKVVF4?=
 =?utf-8?B?SEZ2K2tmdEQwL3FVVHZXdFgzVXZ4R1NFVzg1QkIyRm9rZ3ZtUWtFT2Ryb2N5?=
 =?utf-8?B?Vm9oTE9TdGUzTEh2Q3UzakpEMEU4aWpTRzIzOGNnNEdra0NwYTZvVFprcDJP?=
 =?utf-8?B?WUltL0ZFZVlFVkd2YWs5cVh4aUtqMFAvbGFjN2M3YjJpSWt0RVJuRUovdnpa?=
 =?utf-8?B?bmpub3N1MEx2cXVlNnErOG45WHdiMEVuOG1lT2ZrNUZWeHVEOHMyQmF2aTlF?=
 =?utf-8?B?dFdXTjFWWmZlRnk0RG8wREU3aGFua0RqZlRqZlMyUmtVRHcrS3lPZ1YvTXBW?=
 =?utf-8?B?Tml6RHdvNDRIdnNBRDl0azZLeW5NUURKSXRBNkZYWUt1WEVmZjZjQzlCeXFK?=
 =?utf-8?B?WisyYTlFNjNoTkh0NFRRMGhMK2x3WkRYUE5UbmxZdFprUEptYmVQWXhRQk9w?=
 =?utf-8?Q?2T/tyqE69I8stB48=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vzlChvNaQGFeu9Txak5Vj6yD908ErZI4nX9Zr2ycLHwWbitb2uhPAOmDn+2uGWLsBPJE7QBEtrWcfZRXfADEM9WLYnA5MWaowUUrg9Pmqr9kUFigMsap+BmRb4VMO28pgnFhNLGl2ynbrr0PmRYi8CHexnoL3vOfo9yu1hTSTk2I7V0vJTDUsijnnc+AwRVXnkGGC/TVE+eoWO+8VruaODzNPrfK9TFV2yUWviZ0kBp4wG5JMZDAE3Z1V03+V1poPEjNi0kf3WLc5Hiy+YEDeJoYCUork0hoh5uDWOwjtknqoyLvYiiftz4znWqHEsPTal8xHXLBRwcIfStXdeOCwi8nEZGudHsfh9jsDlYxwzSI3/zLEpm67ORGSyyjBh0sklHYkdkOAHh5Yjn4zefsXKco6v9kTOaPJLK8sWYu+spc7/dAmBiSiYJt41wP/2D0YyabxdgPJyFBzOZiiNq4DCyaVcFY8ucz+4hUyeQjjXU5vc2OZfVhazVE8ycG7e94vlZYHNxen66evYMeUoy6h8K59Te239wj4NyNkQ6LSzV37+nrMiN5MIXuTwdz8r5Mx3rWrqStk3SFl/z0KgZiCzAY1fJMv75OiHjGsrCJ3B0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fe3caa-f0ac-4ea7-e27f-08de654f154e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 07:12:29.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XExmRXH1CS+715JJj1o0isAVFE44L0X3u41OrICOMxxUdUEgLucZB+ZRc6NjsJNqkzN0CSFPKQgxOsRjNSfNLfPprJRCKHmxKLbnwyx3Pd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602060043
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA0MyBTYWx0ZWRfX6b83Zi9W0zu2
 oXgy8DcsyBTbw18w1KQINMJcGxjK9bGcjUqMSmD/gZRtRyLk8q33UnPzGMXz80/kKksLWPS5i73
 ohclLJR4eEPzX55v6rJ/vv17CycFcf5LJh1YLYcl79/HMIpLmQNvcWlG07/5MmlfP+DVwC4ITP8
 BCK/PjmybOGEMo/4JUnqpAN/BXGsOB53Y1yMklazFFl8Upj1zZvwmPRd8IMrZbG1OQzWM63Ln5S
 QceIHPFQPIuUDRTWGLCbmEPQ+YQdXsJrnt3LQi7JzZWu/xoYJsIVfunDBXBkl4lRsMaPzWgO830
 XJJTXo9nysAKsdHVxIXFlthToElcC/ZaeWEy4W39kKYWjuP94ZEs+HREBx00gH67n9hhidJibQx
 y4CsPOIbzjP6wf0qFhBcyJKy1zqLLDlCx2+/4kvhROD7Ht6sENJlgUSMIZ7ucRzYPPb/65+Wq2d
 ofCvWTlxzg6Qjd0FQM9wY40MvfvMoUo+oFCKlPSQ=
X-Proofpoint-ORIG-GUID: a_UHYgEPWJsvgYIavegLSG0OwNE4jgoG
X-Proofpoint-GUID: a_UHYgEPWJsvgYIavegLSG0OwNE4jgoG
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=69859461 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=KdOv7OQ6cRbLYJpAh-EA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12104



On 05/02/26 8:14 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.199 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Feb 2026 14:34:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.199-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
Hi Greg,

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

thanks
Vijay

