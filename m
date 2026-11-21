Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795270159;
	b=olR0ZcFG6/WAlKhTiiFQGoYJAdeV0T3BJijcvzRVQrm5UvODSRGjAIfpeKk9AUn9vtCC
	 42h+LDb1hLBoXWvlg1jCCd/kvYvti8RsAON+rZA6J2IBIchCuo6hmCtmosZw/UJ6gJXE9
	 kooU2RwjfXKr9ecfHoQi5QvacVtFqRCIR8dNsXeFsLP2bvbGiGFWSe3Hflg23LuYm4H1e
	 iu4BgRtG9wXKjlORdXGj/aQ35NhIXmTtF70J39PIneixgq5ZU+AYrrRoBXZi2iqpMuVzC
	 QK158kRql8zEimBr/t1/wkKQ5KlU8MMsTVYLunk38gIGvZu+5wLlTFiCOoMkIHqCbqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795270159;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID;
	bh=5WgHV3+lcO/+zonfbJJug/5uN2o6p3ggPpMnb38/ZK8=;
	b=MI04TZYmRNNK+tF55WyJMsPWwJUEyEiQhU8JpJg0VcYcX4Vnf76frFB+P/eT+bnqufMl
	 nmc1WdbRbmDtAHv9GVyEUbV9dK7zwGAHt3RIB+fGI4XaQs/L6JuvkSVwG0n/m5uj8VHg6
	 kamepNGHTMa8WM/PaKpsA6i1bCKSnF0DU6lmopyFmywFnPubsn/CZ9iYc/uNrF69gAMMo
	 ziwEJNMnbAAOuumGpD1cH5iKlvhwxOElSMmR/8hjIrQiuIhOGrU+w8AXg9MolTuKR/LH2
	 vmB8sbv5W21QIOgspnjA0WFhSDFoh+SBsLTiOQyYgePyx06uIl54BRy8nDNFEQk/isg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Mp+ZQcjX;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b="E7KYm0/7";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9E606A32A
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 14:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5D9E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Mp+ZQcjX;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=E7KYm0/7
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALDiN91586538;
	Sat, 21 Nov 2026 14:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5WgHV3+lcO/+zonfbJJug/5uN2o6p3ggPpMnb38/ZK8=; b=
	Mp+ZQcjXpp5P0DdikewJbvLazs1J1mHcTWHptejxrBXLNBaxMSK7AX9UwYvFWgBE
	VWNaSUnm9JvG6jhYVJ4iVW5VkfnE0fLW8oTEbp6ZsOCpJGpXQ9DJeRdEY9+Pal0l
	bCxPmpXkXA3AhWvn1xGxLNSqAm3xmxEakKZsNgZC7TcVEnkSssEc6btJ2+TVCLOz
	UWMsrHFtLgevLxSQeRSQH6wGAlx8sKXdHdls5UuYg7AFrQo6xcVdjPwSO8SO6I2x
	vzTN2sibJNixHrp1K4WBUzk6q31tSmGsLE355oRDF04VBYvVDAXn6Km60IlcZzHC
	QqL1lZFl1wYkkEW1YizfjQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34r6r762-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 14:09:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCI0IO2582061;
	Sat, 21 Nov 2026 14:09:13 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j38wf3v9m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 14:09:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAAzVaP0EcsV/LFkeHdHRrZCYjvThBC0eiSzK8uOoeesYobYGQRWsa/tmcnITXgNGcbXILKJjYitMCn32pZheTTZwa0jwxto+fbbG0zsYijVECZrMcNxPaHTaWbZw+dFSZsdrMP1cwvRLUcAJuX//8BX+DvTiiboacAr/khVONoLBNLJofVtdXJNrvyPI5Yuy7xXzfx9c4kFiWjtLWC5mHk3f1x3CdbHoX2rLCGRmYtxoaUoo1KDkfjzmsfYaMspxSmQ0334bRY71ml3uPtpBulOCqAw9kzf/KPp1JM+XyGax0kZWuOf+m4ZOqqFs+E00Q1tTyU8YuR/S716dI21VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WgHV3+lcO/+zonfbJJug/5uN2o6p3ggPpMnb38/ZK8=;
 b=CzgXioHZQ9Lnp1HXicUEqY4yOmjV7ESj4vamO/lDDVDir7I5DKMyOEv+gGsBK0CUaVEN2EavArG6Zq74ptdGb5XoFYFF8U6nvP+aGmAdflUO5gFh32Lt2omph9LHjPdNUcS9DPgghQuqIAc0RS3TbsnPfTpKtlLJBrt8Zau+NoNiUHHG/oehNvPpRPVu6y2ZTx0n+ezXOSaa9yT1CNjWc6TTPBufxq27xUiqFhvkyg3XYlozpfW0Fta3XJEFwElbmOF0+0OPn35E6Q907c8/fzo74j6wjMl2ZbyX8gBA2tl185y2ej2uHHc/F4eb7aMNYc9W8AP1ftzKdHlWzBrgOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WgHV3+lcO/+zonfbJJug/5uN2o6p3ggPpMnb38/ZK8=;
 b=E7KYm0/7W35P0kXImnxeJg/O8Aahl/TCF8FUb3eGn70UeO/xqGj4YcebySlKaVd8PSvcJy36upqFHhcjgYqw5+KV5QX/9AYTueaSjOaQ+WedF6NKObgz+2wSquQ4dQYubSFeIKQjC2zXtj8GSPA6fWGz+lUcgD08WMxT3NC084I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH7PR10MB6251.namprd10.prod.outlook.com (2603:10b6:510:211::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 14:09:11 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 14:09:11 +0000
Message-ID: <de041750-27a4-4eca-8857-bfa39999deac@oracle.com>
Date: Sat, 21 Nov 2026 19:39:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1163/2214] ipv6: remove ifaddr from hash during
 ifdown list cleanup
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Daehyeon Ko <4ncienth@gmail.com>, Jakub Kicinski <kuba@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150058.553818850@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150058.553818850@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0326.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:222::7) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 728188b6-0b0c-445f-ad82-08df47d90415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|18002099003|6133799003|22082099003|5023799004|56012099006|4143699003|261026140227099003|261026121527099003|261021123027099003|261022105027099003|261009223027099003|261028144727099003|261102123227099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	mhYgRoKNgs2xNI2txV/YapSBo/qeSJUw88QVpGYWXNImQUnXDNPU7vCFyl+wtv5JmWo7F94kvrkuY08ZICboEBknNHT5jxfCon4Dmae15ptDtaZCUqXFy3cApttquduDVe1hZIsCsHm6Bg3SicRTwKANeoXLmtcrJJ455P7xAW7pCitynR03GpW+kmbthhhv74BaUDdIrS5OFqV7yC8fq49VdrwkE+Lwt9dD5vlSeMB8B7jDcrMXWiB9x1RCBrZhBEh4lc7J/6MGzE3s8t3OlOU+zzPomuFXwwiludZZJG2IYrjCjfGEvMcPmu105yOTNCMTDc4dMYNUVa58EP5+j9gKMB3JHBTYHroFHDfT2OenPSrpx7mLM9q6n8metBVpwQOjs+ufP54z0RNTdHRuvE0GzgNnOgvaIpybUJqOBgdXn4WpDXoR1gKZrz/1cbbuLfKsnyJI3cp4belTV2EvruWM+ZKW8KvLPmyEZ4VVSIfhkOFX96cAHTU2aUFjpTnvU5P8BK0F4O5df/ssO7mqQ8L94B5/TaYo/CBC6Zfdl8TKdDhqrweGV/2k2OSztQNx5HRud9m7DWmWsKbn7+WQ8oWqmjFU44OtXRCnwWwLsPT8ehhrH89YIr/yu9NJ63fX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(18002099003)(6133799003)(22082099003)(5023799004)(56012099006)(4143699003)(261026140227099003)(261026121527099003)(261021123027099003)(261022105027099003)(261009223027099003)(261028144727099003)(261102123227099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU80a3lLN1JPU0NpREhEam1ONjFLdUNIdlBlcDhxQ0NCZ2ZacTdiOG9jSnJr?=
 =?utf-8?B?UWtRR0JXWmNoSTU1aGtXSXlHRjlvSkNuVjdZb0pmbDR3VGtUWUp3V2lZUEsr?=
 =?utf-8?B?Ly91L3l4SE91YWF6bnphMmNjeWdHankzeDlBMGJBSW9qZktqNEtON1JGUmkw?=
 =?utf-8?B?NE9yOHh1YUM3Zk9pRExqTUE1MFBaQjdUT0EvU0pkMTFpaGRkb3Y0K1h2VXZP?=
 =?utf-8?B?TnV0WTM0UWNESFhmQ2crekNhSjg5NytERWdIeThhU2c5RFhLKzkzblYxdmpq?=
 =?utf-8?B?VUpnZStFT3VHZDlnaWpiSm9wdmpYZ29XQnNRbWxHL0FoSHprOFFzQko3M2Vz?=
 =?utf-8?B?eC9DdlJTRWQ5NFFsUVlXc1RqU1JUT0pkZWR4aXhsdWhST01FaUwrN1lDc2tU?=
 =?utf-8?B?Z2kvQmllRE16WlZLYmFHVkZvd2thZFVLQkp6Z3BtQ3oxOTBlWURDbHVhWTI0?=
 =?utf-8?B?QkI3eDQzNHlWM0FYdWN5Tmc5aE5TZ3E0RlRWODFrS2YySWJMeGVRaVpKeTNP?=
 =?utf-8?B?K1lwVjRBRGFhenB2anNzdzNKc05EU3NFOUtrOVRuRlVKV1ZtNmpKNGl6dlE3?=
 =?utf-8?B?Ly9COEM5aDJ4U3RkTlhUTUtLR2pQNCsxbnJ4OVZndkpMWU42U3ZlVmMreGVi?=
 =?utf-8?B?T3dPeDlUN1JYZkJUTDhEaVZ3aktKQUtkR2NGeE5IZk5PaEFZU1dOZGNYSDZK?=
 =?utf-8?B?d0JXdWwrditYWTN4WXpQZ2NFa01WejU1QlY5dWpBUGs2UmZUZUJ6UEk3ZVV2?=
 =?utf-8?B?eTNsWFY1ZmZKMm1vWDNyNDFxbmtid0VHS1R0dVkvb2Z3UnIya2tUQ2J3Nms4?=
 =?utf-8?B?ZlhMWFJZbEtiMU94SnVqa2Y3TFZSc0daeU1GY1A2WkZ3OXBwWG1Oa1VaTU1Y?=
 =?utf-8?B?enRjcDJia2NHWVBKOWNyKzFhK2tNQ2tpVDdPYjRnenJ0MXJXbGdPOFNPSU5n?=
 =?utf-8?B?R2VwK3hRSW9PR1RBUytiUjg0aTVUN1krMlNWY2d2NVY5UDBXUU52SVpwK0hL?=
 =?utf-8?B?Sjlqa0MvVXZCRC9NT0NpYUlDNmhKUkhLMHBiaGtXZG1GYlBzVG1meWNsak81?=
 =?utf-8?B?ejVYeU9peGVNWkpJOUNkd28xQjBpRHVEWk5panNjNGhKT3JFYUNIRURlQ3N5?=
 =?utf-8?B?b0NFcUVwdFFJdXp4ZHdHaENLdEZNN3FKSUViRzRtMXNPNnV1aUJ1WFNieEFL?=
 =?utf-8?B?aUUwS1Z0TkNWT3I3V1dKUnFsajEyeHNLd2k1Y1RtWTk3OUJ4bUJpZGR0ZUx3?=
 =?utf-8?B?UkNUQ2Z3TnRaZzNQWHBwUEVkYzZ6WGhYVU9ub3J3WkFKa2I4NG9mSGlaalhk?=
 =?utf-8?B?WEl1N1h6VjFVL2FWTFdHWUxBZkhnUXliYjUwMWdIUE44N3M1dU9YTnJFQmxj?=
 =?utf-8?B?cEhOaENVaWdzYW12UmhiVFZUT29ncTNyUVJ0dUFZeFJ3QXM0QU90MWMzT0c3?=
 =?utf-8?B?czZ6VzA5TmFjekx6L0plNytYbVc1RGQ1TExwWlJXT2w3OW90VldKQmp3Mk0w?=
 =?utf-8?B?Y2NnZTBDZ25QMDF5VG93R2tzdGx2R0p4bFFjNFlaMGFrRGt2MzB5SWtiaUZQ?=
 =?utf-8?B?c1NER3pJZThpUlF1S2VDSWcwcGFyeXRDVGF2a0lFVnd5QmhPNlZmRHVKQ2Ru?=
 =?utf-8?B?LzZoM0RvYUdkZWQrYkVqQlN5TEd6UTBGV09KQ3ViWDQyVmtQajZuOUxrVWl6?=
 =?utf-8?B?L0dwUXNkZ0toYkdWbTkzMUZ0WDRkZmdRbndOcG40cGVKbitPbHd6ZVk4b3lN?=
 =?utf-8?B?MENFcnJ0ZTNUZVRnSkIxUGQzaUtXb3NmelNZRkVIVnpMYUJSVXhmaGprdHFE?=
 =?utf-8?B?UDBEd09xdGhrUHBhSUlDWm1QNUFQUDhqS2RBSkpwdlFMVE42MWw4L045M0xJ?=
 =?utf-8?B?OS9Ydm9jTGtkMVJQMjh5SDJNa0VwaG81Tk9nS3pqRlpZRUwrZ3hlbnRPTkpW?=
 =?utf-8?B?aU03cHZGQStab1FuSURaaS8wbEFzSW4ybTJFdmphbUlWRkhEREFtL1BDVE9l?=
 =?utf-8?B?ZENneXpEekwvWmpWVitqYXlnQzZEUndRSXJaVHpGQ2FXRTUyTld5TTBBOWhH?=
 =?utf-8?B?WjFNaERZSERwWmV4ck1qZTFlUnc3V0Z1RHdoNnhaVjBwZXRnZVlZSURDVmVS?=
 =?utf-8?B?TWtOWWFzb294N1JSOXliOUpST0lHanh3cmxhR29VZ0l0bU9rTnJYRmxVbnlj?=
 =?utf-8?B?dnkxWDJKT1YzTE12ZkhBYmk3dzk2TmxxYUJEUUh6M1FOaHQvRi92Q3l5cnBj?=
 =?utf-8?B?VjN5VXdTNnBrWFVBY0E0TzV4OFc5SGFNZ1FRQWpMUkRkQTVBNlVabllJQTF5?=
 =?utf-8?B?c2lobm9xWnpzeldWOElnSVNCWGdKcmhzSlR5bU4vcW03cHY2UEUwV2w5MXJT?=
 =?utf-8?Q?qnMIl0CgS2vAe6igFFHp1ekxLiiDcoMsWbU4I?=
X-Exchange-RoutingPolicyChecked:
	bnWb8XxzdDUD9OPC3ujq5vBUXW/zqp16o1DhreVk4yLUBvJ1c+7pcCcnLIIpdua2KYV7OQYzh/VkQ5H8sOrGrVRFdgmHAD8MAjWECipfhFo2OcUYBIXBV6kUwMZOYiwk0ASGedpJGmzHCiRQ1+XHotPl06YN0v/fDrlqdUYbQ3+p92pmaOmtJQiRyf+y2ApaADfflrXh9poGfHeKCbZHd1UKmqFw8GC9YettoyrVeGVBU/1hYzs3XhVWeUvPX5dWg9ONORrbyx7lWTAPLsJ0zwznnJQLfmC1oEiCNleqPgw1k+Qg63GvZsqZQTLUYi/TIBSPSAnbe/9tKw/3QgOH9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nrF2jo7LxK3ZJ/tTon3MJapazRomeAXnuoKfrYAHswHlw6UKXoZ1naXCkN3i60i/uAXx2ZcTlZEpV9Y+QoZ0Cmb904sowoABVasLb8sKjAudU7Lq0elVfhBZphracAGzwWshWwk0Qbx6y9mebiD7yUyENOCGuDX0HIVVf8SZXx2sukI9JGDOH8WdWr4p38PU5gfOzOQvurYuN3pWubS7lZWqhf1f8Zi0+8SUQedd/s6HmN70rHXoV51gXTlcLxmEA9CmjHosfw91IM3gkSobr/wbVyHBvDdavGR9a+cGjcCPDalpXpJ95MZhQOTWKkTP4ogVgpFbiYdXiWTY4G/WSMFEF+afDV97S2USr4Sxh+26wuyvGJxo5xv2iPU3IOIIxF6aRwt246TntWY/i8YqLDpXUVEFqaPTC9jRlrbeDmc9WX7bU0S6lWHCR61ZXfs0wJjh3PcCADboAZ+BRqGUYTMIDBcdyKgt0iJx3t2faYYkQy4dAuPIpJaZgz/WkSaA3PYTb5WX8SaeQDoqR/21qjqfm9BG+roYdpGMD1oj3aknufjhBAnGlGRSjugyAxNNssOKH5Ecmxn3pv5QWaz/2Acaj/59Gg+IHCIJhxCzIiM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728188b6-0b0c-445f-ad82-08df47d90415
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 14:09:11.4958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aFPE1zWR32KubYddFY0gbiWoL3ufLfiiukd5V0U/OL+W10oee7HJ3/bd/9/uWi8Qv8YJO/4MplHgrawvH1hoVoxibv5WnMxaDfYYT8ZvueVsR6DyRE0FvcTD1frhWW4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210056
X-Authority-Analysis: v=2.4 cv=M5bYuCws c=1 sm=1 tr=0 ts=6b01a60b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=jxYLo7jvbfvcOtuME3sA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1NiBTYWx0ZWRfX3drw5+avD5mM
 DEImB8qX5y9cAxWs2rLP9imfZkoINKqWewZ5XwTeZ02MBHGE24h3irKO1zU8va3Zpsp0cntlm2a
 YGlM9eW+tXoodRiYAtbiBVynN4TlVMSR2h8ndGyZmaCPA0mTR2uttAhCrxaSQ5yt93KqQOsyrVO
 NULagWGGcYpt1Gyo+BCX8r8gq53rE2VYHo8xHxD9JSeK8CmL0I49OE8DQq10JBC5k3QEHUemy5D
 bzTEJT94JfVc6+tjojP4yT4z0Hk3LzuklTGX7b9JpR6P4eNSQOcdM/ge5CGJGT44DpSQDcJOtLk
 0qxnB8mYXp2kXwdMCFF8tG5sqJTNACbOuFJscK3XVsNcNZ4QmUJMHxhDuF2fDN2RmtnmEYWtpWy
 G3DzdfkuIag6/Omr86iwFVXsbJ/tJpTtGKfAQMejBk7hXBRNjsZ3jgFJymuun0ypk/NVym2qF5z
 F09BoGKBqx5S07Fkb0viYdDou3uxwzqN9xyC1R8o=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1NiBTYWx0ZWRfX/Eymr+7DrQ8C
 G6o0wlD3/yEyLgmg774+tWyC4WT10wV30WkuWQ3Ahr+NgpeyO1mblzTep9XiWTe5zxIqTBWoHLb
 O3zNpCbIvpCn16GdJInOsKs5K5a3EIXUawumBtX+GFu7RP/L4FKK
X-Proofpoint-ORIG-GUID: QGb-v4B5LJbaAr-xstUivhRIXSq6j2Vl
X-Proofpoint-GUID: QGb-v4B5LJbaAr-xstUivhRIXSq6j2Vl

Hi Greg/Sasha

On 18/11/26 8:17 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daehyeon Ko <4ncienth@gmail.com>
> 
> [ Upstream commit 6ace56ed7b13a9c6d4cb7ef0d82d3a3d53324a63 ]
> 
> addrconf_ifdown() clears the address hash before snapshotting the
> per-device address list. A concurrent ipv6_add_addr() can publish an
> address after the hash scan and before the list snapshot.
> 
> The ifdown path then removes the address from the device list and drops
> the list-owned reference while it is still linked in the hash. Once the
> remaining references are released, inet6_ifa_finish_destroy() warns, but
> a DEAD address continues to kfree_rcu(). The hash therefore points to
> freed memory that later RCU walkers can dereference.
> 
> This follow-on was found by source review and was not separately
> triggered at runtime.
> 
> Remove each non-kept address from the hash immediately before removing
> it from the per-device list. Keeping it hashed through the delete
> notification blocks same-address publication until NETDEV_DOWN has been
> delivered. hlist_del_init_rcu() is safe when the earlier hash scan
> already removed the address.
> 
> This handles a late publisher captured by the list snapshot. The next
> change serializes publication with teardown so an add cannot miss both
> observations. Both changes are required when backporting the complete fix.
> 
> Fixes: 73a8bd74e261 ("ipv6: Revert 'administrative down' address handling changes.")
> Cc: stable@vger.kernel.org
> Reported-by: Ido Schimmel <idosch@nvidia.com>
> Link: https://lore.kernel.org/r/20261004135117.GA206930@shredder
> Link: https://lore.kernel.org/r/179161099539.434549.2238120015372268173@kernel.org
> Suggested-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Link: https://patch.msgid.link/20261015050651.1841557-2-4ncienth@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/ipv6/addrconf.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index e4f1c67c6c511..aa033c2cd8a0d 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3933,6 +3933,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>   		}
>   
>   		if (!keep) {
> +			spin_lock_bh(&net->ipv6.addrconf_hash_lock);
> +			hlist_del_init_rcu(&ifa->addr_lst);
> +			spin_unlock_bh(&net->ipv6.addrconf_hash_lock);
> +

I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this backport deletes global IPv6 address-hash entries
under a per-namespace lock. Insertion still takes the global lock, so
concurrent updates can corrupt the hash links.

net/ipv6/addrconf.c (spacing adjusted; comments mark omissions).
addrconf_ifdown() now uses:

     spin_lock_bh(&net->ipv6.addrconf_hash_lock);
     hlist_del_init_rcu(&ifa->addr_lst);
     spin_unlock_bh(&net->ipv6.addrconf_hash_lock);

But ipv6_add_addr_hash() still uses the global table and lock:

     spin_lock(&addrconf_hash_lock);
     /* ... */
         hlist_add_head_rcu(&ifa->addr_lst, &inet6_addr_lst[hash]);

Upstream (6ace56ed7b13) moved insertion to the per-namespace table and
uses the same lock as deletion:

     spin_lock_bh(&net->ipv6.addrconf_hash_lock);
     /* ... */
         hlist_add_head_rcu(&ifa->addr_lst,
             &net->ipv6.inet6_addr_lst[hash]);

Allocating the per-namespace table did not convert the old users. The
lock mismatch remains at the reviewed range tip.

I suggest: Use the existing global lock for deletion. Upstream relies on
e66d11722204 ("ipv6/addrconf: switch to per netns inet6_addr_lst hash
table"), which this tree has not completed.

Thanks,
Harshit
>   			write_lock_bh(&idev->lock);
>   			list_del_rcu(&ifa->if_list);
>   			write_unlock_bh(&idev->lock);

