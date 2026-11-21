Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795269907;
	b=EHXjY5sjIQ7nUYP9qrN8lVpaMWRpKLJLTBb72sASVJW+1N39YyOSJA8BOfivSz+HFpXK
	 y/Uqa/kfKBc6h0WROxDrA5ZpuxCQD8cYwLQ7S/nuVDseniFd0tc/jW76PV8A1JyxOd2PI
	 Wu2u2+UeLhxoPtjkwJzxPwn/jrlIpm0wmwmJwy9jvwrQhl5zEzYmXttFDbWXvYpp3YST7
	 ara/xjWiI8Wo9FtL4Fo03T/GGYhR/WdmsJ+AFPUHUEdsndVDZAgRPp9Mf+t994Mf55nMS
	 xTeYYtNFiWumFmOtRvrzUyGnU3EV6W+A6PjRc5+KTYZppCExVC/3wZ0kjlJJ43kXC8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795269907;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=P437nIsJNYcO58Ga7RHXPAw+IuRhtcYeur1JvEMaw2A=;
	b=3pNt1t1v4ErPUlb0Zjs9TbxH4xBu7e2PbOCidr4KixbQlfVY8K3obuRdPN3rqqDcl9S3
	 kSNEOKzJWsd92gnBE1YpYbm55d6sXhdJ0zIZMSUtFbnO8pMgqTdorjrisxfz9KUZGuglZ
	 8n1YkzMjBmHM8VJugZwb5oZfgZV3DtucVQ+tCAt1nmgeA8UCvqSv++8D64WM4GbMd1NYQ
	 +L6PC9lYXXzaR6oxMsm4Z3gdjMVzqVGT629t03DX6tGuYzt2bNOzXwkKQO0F+8l+5UkxV
	 xaoscZ+yqTAIo/yU8GE/tikYfxyOPE9YJXq7Wi8rc/wTG2KiY/fo4upR96DGyk2i34g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=o7tTqSum;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=y4L7nVHg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE18606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 14:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EE18606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=o7tTqSum;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=y4L7nVHg
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALD2H452270341;
	Sat, 21 Nov 2026 14:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=P437nIsJNYcO58Ga7RHXPAw+IuRhtcYeur1JvEMaw2A=; b=
	o7tTqSumBEXFhpH9EZy51JN99sZfq0Y0vEIStB+qTgtFV0jWJrIUKO+a1KPSM3pq
	3jDrX5eMR4GLSKqsky8qNrwI6v8XUr8JSGIq+0Rvq4RD43FaKsv9c4EF/mE01UPS
	AJUKTa+J3VWVAxX4WaujPl57BxCLbXzpK/Znc10Wtt4L9OKRROlTpnoARhtSOrHR
	hdL4BSqhxLEU+7V0EAmacf6LzSx3pBVQH6lA9V6qauX6vYwYsXH0bPHSOGGWAfBu
	oqQ/Wv8GAIV0kYEk1pRFh7mF9f+sty0TcZiYYx3uL3YTfRcN5AY7LdYzv0cKXtTq
	d1Ww7xvezmQunHSIfUhHUA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34rp87km-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 14:05:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCIGG83220983;
	Sat, 21 Nov 2026 14:05:02 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j39bcu9fc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 14:05:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P8YEy9X2WnZ+xobNdkVpvOpsg1rhREF2Fjid0x6P+CdcK+9rF1XVWJeCO8PPgLX1tk0S9Iu0cvGRNGI+coMqa+xcet87f97l0Lzr6uQJ4SWuBHe+Iq5cG3XhBkXBlCetvzkD8xOjHO/lJaMrBDa7UVbyk1qBBNe4BRkjthMlcbxAwCeT2hVcMm2S6IpEZ2htzLL2Rky9A5mtAGYkAuzv3d13Mce/uruP0ewMNuSHiDpG3tgZvnqZkke8skMfFv2eoY565v2ERzqC3b8uqntoiRtICLxgUZbgqOUShMFuC1BJgtDRUO7rNrVfdn52DMXvEEnZDYkRsFP7Lm6S6Ghgqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P437nIsJNYcO58Ga7RHXPAw+IuRhtcYeur1JvEMaw2A=;
 b=bOrsM7A2H8SVCqAM/LWYZwK1aiBgnnml5g/YUKH3YLw/MYzasJiS1NS2iEwnV3Kze+R1Rh6COkCLrTWBFgdq50VNsh9IAjfBhtjRPuIRMVRaCSxidZcvj8NE5L9sxzI30EA44TEZsr+Lue0ATFGz5EkfLjSP6UjQWtRRNtpaTIDj9Y4miBM27fJTaKFLSpjlwnysbp60kwXWVX+WaupWvG2XaaeVdjO96WxriRf9HMlnMuMreOoRRg665ZoLotc+RmHoywGocZeNtt0xLsfTkPYOU8b8l8yr00pXNOVVWhRoVVRxNh216XDp6HzPVDBwf4cMka9WitOdg0LYgehGTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P437nIsJNYcO58Ga7RHXPAw+IuRhtcYeur1JvEMaw2A=;
 b=y4L7nVHghHmgrtCqQkTKOpp06Hn66MQ1pYg70MAGRw5f9+vgthaBl53AWy3TdkgpyPBatq6orND/MYNqfNrRqCBl0MxKuA3QwwaUDoj0/8VTeTFlDrMDoGpUO3zZvl6W4o5TzZAJ4BRnk2OCPP/id4Neq6o+EtDkC5uo/2GOKAE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH7PR10MB6251.namprd10.prod.outlook.com (2603:10b6:510:211::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 14:04:59 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 14:04:59 +0000
Message-ID: <254e49b8-c3b9-41b8-8692-bd5d9f04f7a4@oracle.com>
Date: Sat, 21 Nov 2026 19:34:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0966/2214] batman-adv: tt: send ROAM_ADV on each
 roamed back client
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150050.936317714@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150050.936317714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0315.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH7PR10MB6251:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b01a2b4-81e8-4f9e-8b2f-08df47d86d84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|18002099003|6133799003|22082099003|5023799004|56012099006|4143699003|261026140227099003|261026121527099003|261021123027099003|261022105027099003|261009223027099003|261021135927099003|261028144727099003|261102123227099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Vj8oaCprRmQYXR2CtX8kez5XFjAAY0tTB3QfxYyqei7ICDvz7wAtolqAlHEKkojf9Sn0ENxLFrccvJ1CQdEhSR3eDn5FfE4RsWBnnZcQ97f9CN+e9tJd1eTr/qrAvPvFADst1dYEUSg+j9EWXk20iKzFGuF+5WD+EAzmelkTyiW66yvpXS1irRzPbh9RwCIEkAyAR4CixRfLwP4hRXQ5/fAW1o2oeEAmLm6RljRlksXxVuktJqRAWwrN0Y4C8Uhe5v9xM48FdgDVe5qil3L5K+XZOyCVq3XouUhDnXBcIEDyRseyJYkpU/uAKNFME8c5O9jU9ralgD1HmV9SZUaMkLbsxt0Lp1XKPNIzaZvWWjYMCyKHulxb8sd/aEelrtFvMJ2VnqxdBPvGSVs6vxKZzM0pmNTmY0Evj04BJsd/Hkfgr/8QS1qsf00vvIqhzveId+7bdEziEL8InUpvaW9Y9xoVSkdy6tLzyLzgeParuwC24m6OqEmt24Etpm9hYtnSZy1bq6/FpoUhoy/zFgFpylG2WMkgzjKn85R6XNUYy6HbmWqRHUOb7RVJB07XdIA3a26Zlc3wnC9BfIky9RgIbhvZcqehkHQF9W4aoqcApyNPR6L9JaLuS76tDQNA01u2V9X1k+wBiIT7ArcWroWbq9wdya3vtCTW0NkbuNPqw14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(18002099003)(6133799003)(22082099003)(5023799004)(56012099006)(4143699003)(261026140227099003)(261026121527099003)(261021123027099003)(261022105027099003)(261009223027099003)(261021135927099003)(261028144727099003)(261102123227099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkpBUGl6UkZzWjhnTHNyanUrWCtmVmlNS0pBUWF6bmFRK2VNeHdLL2xlbURI?=
 =?utf-8?B?RG9lcHBhMGpDdGpWNSt2RTg2VFdqQlpDSE5pbEdlU1J1cnpsc2JtL1JOWW83?=
 =?utf-8?B?ZFRxTEo0LzVaMmhuWHBYbVpxQmd6Wmk2ZVVxandYOWY3bWNzTFBlaEFmNFh1?=
 =?utf-8?B?bDA1SnRieVVDa1pTRVpIRjZma2diR0xSWTB5NHlNQ3ZlNVpNcnhIQ3VrS0xy?=
 =?utf-8?B?N1h1eXUxTS9RdDNkMWd2NGl6U2hFTEpaQXByLzV5b0U5MzNKTWdTRitIcGtk?=
 =?utf-8?B?ZE03OXh4YXFEbjBGTWg0ZUFBT1FFTHVndWdHWVZ0ODVld2twN1lHWlpCMHhl?=
 =?utf-8?B?U0pLZ2tPR3l0emtqMjhpVG5ocDRTc1dxdXg5MnVsN3lIZVN2SXVYMVNscXMz?=
 =?utf-8?B?ZnpIZjdoQzVLRGlBQ0dISnoyd2o4OVBjRVkrWXZkYWpaa2I5QmUvVFRRcG5w?=
 =?utf-8?B?US9ZZ3ZOaE9LTkVzTCs1WWQrS2c3NVZvUUJhdDE4RzhKYjNjWWNGNEpGQVVM?=
 =?utf-8?B?VFlmLzBqR2N3QmdueDV2WWRDSXJ4VEtuZGZ1NlhRejJYM0VkdDUvQzlTZHRn?=
 =?utf-8?B?U2RCSU1sNkEwV0hrdFE4NjhMSTNBbFlMUjhGWkIra0kzSWRRSm5YRkF1WDBC?=
 =?utf-8?B?K3JVMlNlQmFoNVFXU1RtUVRXOURVQ05JWGRuUGJpNm5SU1AyK0RRWFlDbVhz?=
 =?utf-8?B?K1dSN1ladFVQN2F1UFhDQ28xRjBsTXdDSkVFbGpPUzNaYWthNExJVThFMDdO?=
 =?utf-8?B?aDlxenF6cVM1d1BxaVNlNWk2RXJ5bmNjTkwwTE12aUFoaUVBYkZmckR5UEtQ?=
 =?utf-8?B?ZDlDVGRnN3VyTTFqZ25YcE1IM3MzSXc3bHBzMk1GR29lWUZsNjlwY2pZM0pY?=
 =?utf-8?B?ZXBVK3RHMVdpVWMwOUJvVDNkWG45bk5hVEZKRTFDSHgvK2pVM0dXcEFnY0hj?=
 =?utf-8?B?R24yaldDZkFmSk1taldPV3Qzcm92ckpGSmxFNW1oZnVxTVo3eVRCVHVXamZa?=
 =?utf-8?B?K01QM0FCWlVsUVFWRlJBVzgwTk5PbTVtUjdwbFBvSDhMSFNOVjFxbkpvcy9Q?=
 =?utf-8?B?RXc1MnFSUE54Yytrb3F1bURGclBtTUk3Sk1GZ1U2bVZXRUxTSzlxaUptTEMz?=
 =?utf-8?B?Q1pFNEhXS3ViTjF1T3Q0RVkrc09OYnBkV1d6aGxPZW9DSWU4MmluVzhPOC91?=
 =?utf-8?B?dzhsS2FmY0llSjdMS2w5U2g1VFhGb29INDk5THRaWVZ4RUJoZ0JGN0c0TkVq?=
 =?utf-8?B?T05RZ2l5OWIvbjZjeU1RU1NzLzhEVG9OQlRZQ2c1T0dRdzNSZFlDMXpWUWtG?=
 =?utf-8?B?VkdiT2thU2oreWptSUVMdDU3M0lrQ3ZYZWFlZWR2K1JyZEgvSUFqTHE2UmZQ?=
 =?utf-8?B?eThOQ2lHdks2QjNLUk0wcVFTck1UMGNkN2Y5UVBTQnpjZ08xUlJYdzBnZHlB?=
 =?utf-8?B?QW5ycXMwQ1IxcVdZZHBlRkRvVG1VeFFSUHBHeDFuVGhCajU5Q29WemhHOWYr?=
 =?utf-8?B?TDdkTlhIc3NwWlc0Y09abFAzUE51K0hRc05zT2hidHJxbDNiWWJaNUFEbjdK?=
 =?utf-8?B?dktJYlVDN0Nwd0xlWkgzNHQxbGw0bGJ5UEdnb2VGQllOU2VHQzJnbkZrTlRB?=
 =?utf-8?B?a1VCR0ZTR3p2RTRnT3BYVXVjSWtEOElHZmdKM2JFYlp3YS9ybHZNOEZjdFJB?=
 =?utf-8?B?TnVVclB0TDIrSFN2d251eFRqNU5KbkVuV2FlMFhoV1hBOWJIUjllVFhUcmhq?=
 =?utf-8?B?SFJXbW5PL0pZcVlOUmRFQnZXT0pWcUFwMjhkTDNwa2dQYUJuUnovR1lnUEtM?=
 =?utf-8?B?RHpHRlFRUTd6WFRyQjhUOGdWQUxuVUJ6TmsybCt6K1grM2tyaFNvaXFvTGZx?=
 =?utf-8?B?RjYwVENNVHFSY3VYV2cxZDM2S21vOU5sWUk1czdKZVNmRDUvci9mSmlxN3JZ?=
 =?utf-8?B?U1JROTJDNVI3emFsRC9aNmkvWk13dWM0UGYxNUEreGFSR3UwcmYxRk5YY2RR?=
 =?utf-8?B?aGVVUy8xbThYdG4xV0NDWFRkNk8rekdXdEJTcWpnOHU1eUNMZXg2aUxlUmY0?=
 =?utf-8?B?L0dqemVIU3p4ZUhRKzhCUGJxeGxoK1dHajBpazVZWWdqL2g2US9EZ3NwMnNP?=
 =?utf-8?B?YWN6S294Y2lnWWlmZHIycTNTZEg0amtsZWxRdUZULy9xeENHcXhqaFJzWURx?=
 =?utf-8?B?eTMxUGFjK0JIb1BjSFdDVkNGZjgzOERXc0hlZlZCTGphdTRMMDBacG5Nbng0?=
 =?utf-8?B?K1IvYk9VcTVmMDFlK0p3RWtYeHNtNktSc3pVL2pjZFR4TXhXVHVWTzJndzVI?=
 =?utf-8?B?RkVqdDZDTWVkcWJYWkNmR29iVmR0RDE4ZUJ2Tm1UVTg0bUpVOWRiU3BXWWpk?=
 =?utf-8?Q?Z4AN9RHqKrEjBHA/HgucuUNNSDRAF7R6vO1GT?=
X-Exchange-RoutingPolicyChecked:
	pESbaEtj7NwGsvC8PotpxLO2b7nxwfImJdwpjkC/kQqN3jvyUNjMStarYgtP2NSqQz3PyoJWRGZgZLsqW3bDwQ0KEuHlaCaqGpiOJ5pCXEq1Cc1ffO1ykqBSrck8V1l8fDGcxHK1x/dtQQTt1SPo8aqJ/kGIewilECZLQeWhM+UOBLQWhbn8nwqWeplgdp5locDR1vRTLclF6qHCEv7lJuLg0VE8+fSACenKS1/a9SRVUMz9EkNSy2ZiBBKt5iWUaU6SIHMOMKNZ7wPFKR9CojwIcRLMp1v9Q+O7V7D9NBJ49P0JzbmpNmWupK3JnBqc2wNj+K3tClx6KY5yt3Vxow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zQ9mGhkAZtYQdagPp3MKkpRIOl+44i1dMqZPRCIsCnCa68sAsu6wQmXbhufTiQZNw39VElAYWs2FA+lYa2vP03uhHnPb8xZriFMEj3K4qwtnEaGkR7yEGfMT8zanuLWUNgahRQ1XATPG5FTW6a5xNOM9I2hgkALVvuOy+hhunCKbtgJWKftwrhg1NtR4tTS/fGSA91BR6HYPO+921s29i4GWbDaCBuOpMiNELZ+y0yOgOej554OIctBy0JcOIlD7NeXXdUadyRuFfvZXA+pOKL5GUuDnA+AJcx4QusbXL4BDgasdo1E61lIm3kzROz5K82fKZ8RyEMeFh9LPqAXtuOzugkpm5RyRAGwMlXkQNNwhddGcZvf2Bjtd44ZGkw8rroXiazJRPiIlhJHoNK7lwbT8mMZBOrbcuDQidj+PInJyv2ufU8/1rG8NbFlu1+qF1o+vMK4lEZMAp0Xx/LuNZTC+GJE0KZ2EEwgz+FaxVrV/spAVqs3/wMXNHFOHY7lJaXdQD2tV++Z9ovF985lh0RsScUwpnYQt9TkSW71zqSg4zfXfi/1sfzEH8ANkdtHOIGAaNdXjePM0xWS5ihjQo2Zi2+GYggyEpuqr2jxtyKM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b01a2b4-81e8-4f9e-8b2f-08df47d86d84
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 14:04:58.9299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4b/Vl+NirS6DMtg0HLhbgoFI/bSP58Wn0/yQzUzK8od90v83RATgVwu+OLYzTyGY98h5beGlEwYjgC4TIMIZ54i4G0MDFF+f5thOnQUIUzkEHO2DBgG3xmisZ0M3KXv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210055
X-Authority-Analysis: v=2.4 cv=c4w+0h9l c=1 sm=1 tr=0 ts=6b01a50f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=svCTMBYCAAAA:8
 a=VwQbUJbxAAAA:8 a=3PAycNjCOWdSBV35ZEUA:9 a=QEXdDO2ut3YA:10
 a=lbQUARmhvTNeubMQCRFT:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-ORIG-GUID: EBRi5ayT5cJKep75RHggsTyz9PPe-7Zf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1NiBTYWx0ZWRfXzr86aEYFMPE1
 oADY2XTXiES2XcB06e2GvlDEWBcZK8NAQF+PB7DAWtLsjo13ZFpvQSnzaRTCYEzA5YoMjAQu58z
 HQn/x3NknOtbqsOc9iyDxbY+IimwOB7UqpCroUDPlK2nHpMzwRsp
X-Proofpoint-GUID: EBRi5ayT5cJKep75RHggsTyz9PPe-7Zf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1NiBTYWx0ZWRfXyyXacOzRevmC
 sG+cc2+vBEJFfALW+CwO1uHmLbXsIQJF1czEtFL2aKa+bgIDQu80PBy3WwLXyYU4kpZU1oFSNYG
 C/klsw9TPIsK1LsEAKfMpCqtOQGNqvp0MwS0JRc8zPE/pE+IZgHgnKRd1VvZqbDKj0G7lfO6e74
 lRYJDO7aeA3PmPSe8NjvdSYu/qwz5hDNa+3mLMw3JCArKXb7aJnol8OGsjUx11LsmB7qsDHOOLK
 WyoJcGwcBtzHFHtMQ1JQZt4hKv2dcghSAKPEQBBjKDLoQDz4dpo1TKX7mk/wJiXJlP+XEP7/CQW
 Usu8F83q1ScsDzmGOspUECDLDqH7yjz7ylr3KFFFC/yYbOKXyCsIyq6XCsMdeNYicPhKhsIVeEK
 yFNuVC2kjh39xaHprTzpf5mdmGaY3iH0KruUBpQ0M97RMqp6qXK6tlIwgCvWii2LrKyuNsCtnKl
 ybLBxVezHuqfa/Ej93JpB6O9UIAMFTdsFsvcB/Jo=


Hi Greg/Sasha,

On 18/11/26 8:14 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sven Eckelmann <sven@narfation.org>
> 
> commit aff4d5d10f2dcb4a9b604e27414dafa1d51b6406 upstream.
> 
> When a ROAMING_ADV is received for an announced local client,
> batadv_roam_tvlv_unicast_handler_v1() creates a global entry with the
> BATADV_TT_CLIENT_ROAM flag set.
> 
> If the client sends a frame again before the next TTVN commit,
> batadv_tt_local_add_roam() is expected to announce this return via a
> ROAM_ADV frame. But this doesn't happen because the global entry (created
> by the first ROAMING_ADV) carries BATADV_TT_CLIENT_ROAM until the new
> originator announces the client.
> 
> Let batadv_tt_local_add_roam() always handle a roamed back client -
> independent of the ROAM flag of the global entry:
> 
> * trigger sending of the ROAM_ADV frame(s)
> * remove the (with the roaming) associated global entry
> 
> Cc: stable@vger.kernel.org
> Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
> [ adjust code still in batadv_tt_local_add ]
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/batman-adv/translation-table.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
> index 300e3f9b60200..ed74e02f5bb20 100644
> --- a/net/batman-adv/translation-table.c
> +++ b/net/batman-adv/translation-table.c
> @@ -775,7 +775,8 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
>   	/* Check whether it is a roaming, but don't do anything if the roaming
>   	 * process has already been handled
>   	 */
> -	if (tt_global && !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM)) {
> +	if (tt_global &&
> +	    (roamed_back || !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM))) {



I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this adds roaming-cancel cases to a cleanup
path that can delete another CPU's replacement entry, losing forwarding
state.

The new roamed_back condition sends more cases through
batadv_tt_global_free(). In 5.15, that helper removes an entry by
address and VLAN, which can match a newer entry with the same key.

net/batman-adv/translation-table.c, batadv_tt_global_free(): (Code
spacing adjusted.)

5.15:

     tt_removed_node = batadv_hash_remove(bat_priv->tt.global_hash,
                          batadv_compare_tt,
                          batadv_choose_tt,
                          &tt_global->common);
     if (!tt_removed_node)
         return;

Upstream (aff4d5d10f2d):

     tt_removed_node = batadv_hash_remove(bat_priv->tt.global_hash,
                          batadv_compare_tt_entry,
                          batadv_choose_tt,
                          &tt_global->common);
     if (!tt_removed_node)
         return;

The upstream comparator checks the exact object:

     return node == &tt->hash_entry;

If another CPU replaces the entry after lookup, the 5.15 cleanup can
delete that replacement and lose forwarding state. The older comparator
was already present, but the patch adds roaming-cancel cases that use
it.

Maybe we should take commit bbfb0d2cf035 ("batman-adv: tt: remove only 
the entry which was looked up from the hash")


Thanks,
Harshit
>   		/* These node are probably going to update their tt table */
>   		head = &tt_global->orig_list;
>   		rcu_read_lock();

