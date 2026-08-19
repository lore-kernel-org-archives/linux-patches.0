Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7796C3D5C3C
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 07:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123642; cv=fail; b=L4mAxvOmlml5RmyrbMbPylb2U2sZhzqFBAqEJFXhWwnbRdaVYBT78wrfgfxJNBXa0VeM319DlpFlvpYuEAoo+S5S/B3AlVn52JSfKZZ44n5lSPtbDE7+ihLxdp069QFBgj1geSx/Khcq8/cZivuuI2gbzma1xumJqjyI4V1jpRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123642; c=relaxed/simple;
	bh=pkk8ryodedg44nngLeOuXcukTb8tjMyXk9bMCA6o6iU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TCrSWfeGRXCYQLDjdqXOw3G7CaegCcweO5yzPY1CxArWlcjEzRHCIYBdTzbFs9vW+6N5RGPT9wMUUk8xebj/xXfcMK2+SvvntgQJZlb+Md4hP96K9dO4H5QTdMBqSnIMQjs2nIPAjVMlFt18bdAVhtQq2FaSILJc19ob5tsoytU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GX9zHwDZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FxjPEdFr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GX9zHwDZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FxjPEdFr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ILX0wI4042672;
	Wed, 19 Aug 2026 07:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pGluKohIf207B+srMd1bJJSCBDxwhrGV2sDQruDnIk4=; b=
	GX9zHwDZgQH7XvQSREiKA6UDpwiDvQZPy76B0GM27pUoWhXeO7dMf1ThtuCAx5tq
	ikv7Loh+7GW3LVhdQZced4s/4K2a+18yOj1jUA2QVXHRGmYfFtObqAovbgNqBafS
	zM5AZyLqUvO7D8G0Fpt8CqEQICitUb2zXjhoxkog3rJ66RICGD5/cVZ9Ofdm5ytU
	Frq/At76KzkYSULaXKSwtrtrCnuMljAJuoh/RvqD3ol8rMSCZC81guxiuI69ZEus
	ckzsVM3AFzRme8kFGQxjGTQLmnnqjmMBUVDnblvy/3RZfhfHTz404EJxY4I0yO5F
	cxjsjgcTa4xYcOw09J/TOg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g4yd9gjhr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Aug 2026 07:13:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67J75ecW000684;
	Wed, 19 Aug 2026 07:13:41 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011009.outbound.protection.outlook.com [52.101.62.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejrkyrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 07:13:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmLoLitxxIoIea9Dcf0uDiPoYGtVCdn0zRQZStMQHDr2C1UfJBhooe8LBS+pB8UOB7AvztaTl+x9hvHQmvzCEwWTKeNYOgND2xnday5U9roKVRmKuOn9oDPoX1LMTrmIxv8EXVMWX/0ClfrPLYjnyEIYOrY3ED9+f/hHg/MY4AHKKTISrUb9yuvwCEWA3yol+xhq1wPlK59FS/TTlbGQW+E5ZPyFMlQcoqxuhJNB9EVmnBfMnLkDHWTpVLxXFjiFtSNTUvmpNqwSSSdYppbch7oOEoa2aJwzxY6h5twNutqeKiERe0Hqzq2yMlIoK5RUBT8S2jmiNLRj64kB+n6y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGluKohIf207B+srMd1bJJSCBDxwhrGV2sDQruDnIk4=;
 b=TOqMB0zv5DFi4fbjj26sn74Tj/2JfF6DCIQ1c9qJJBMDbhCdhugAUAkEprqExJw5sWA1oqM0+VKIQG5FzoaE+hkc15yZ2t2/WLUFNWDzjix9Tvxe4UmkvXqaCsPOyuXk0ltWVVuJGIXFz+EctW7/rIaNXgu0FKlDannVCn/YlL1+Rqi6zOCs9gNsegkK7LTcAbNey0Oy/TIxM876kgW0GUjsq8utpQqLnIx1v8TOw15e191/qZAl7SO+/+DvN/UN0ytCz1YIjqpd3OAy87ZxNloQS0kPaNqPrZ0v8aw2HOTLok5vrtEQWDN+Bga39og9KBR2x9Q6WFTARH/gODbuTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGluKohIf207B+srMd1bJJSCBDxwhrGV2sDQruDnIk4=;
 b=FxjPEdFrJNCVHYQy9BGclpoNyp90yxISWSatMQXjiqM3L34uIdDBs3OkIysDBSkk8eTtP8lrRM3rhKRuh2TUkf/o6VCzJ63+Kt2WKuYJORdoCzXhTSMLu0WamunhPCAWyoUpYds6xhu9Vcdrxvi0uS2qy2/lYFkCX16gxZNVRLg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 07:13:38 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 07:13:38 +0000
Message-ID: <23529dfc-e8c1-4d6a-b286-b6acfb683897@oracle.com>
Date: Wed, 19 Aug 2026 12:43:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260817132535.394764707@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc8c7f5-2be2-4dba-5091-08defdc16425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2DLuYP1hsQr8NE1NE9Imy2XGsQ5Fi57juZwBhMIA3+elAhtfeVsP43yEZ/HTFSObJVpHFmll1cqHsgxxruVZGAppm942POzoU+ssOg26ZfspdYzGSJR3bEqyZGGg1PRgeJPPhl8cHyOuftyAOzHySRcXjuBZYzYmDhMNYnGszd56hKai1JxGtXz7hvAtYefD4DrOPjW6R4zwck9RFa+f0U6wQF6nutCDHGZbYanjQkBImwCwZ8zFApoNnaH5l4Cm/fuhj3lXMKw4DoYLVqyZHXUlCo94Cj1w+UchhAO206ovvJlNbpx4dBwaL07EzD/dfin+laUg63CprFu3PEv5TTTVeZGFljT7dHnGvc1wgEU01WKmpXTBvesrTx6RD2lqJG5azoQLPJxaVfo2CAhnhQMmxHPoJmSTH5+Choa9DXmp08IYKV55UXoreGZBaNVcwHQtoTV5qIRDTcpngRWR+kSsPgxxnp04UQST2WcX1tIv3ptHLOtRvxE/9NSrXFtnnlQqVbifWVcSMCE43fUMNd3N36la7riuJDwtMY7IcSwvhfyj9wEy+BY1ckuoIh6M+xn5t0KlbDbyeKAfba1JNGkAkUbj2KZQQ2XTFuRf2WHyzf6WNbaWnYDIV76oRXzwt/05eV9OJf+QJS2ce/oPdQ6Bvv2W/PHEcT+rKxclbCM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVlXdDZya3dzVHFLVkJmMGlpbWh5c3VNczVFNSswWVZZWGgwNjlIM3JwTGVp?=
 =?utf-8?B?eUdkekJ2ZlE0VWtrVEJxT3dhODNBeUljRnhJalVwLzFOUmV2TUxlQU1TY0dZ?=
 =?utf-8?B?bDJhQUhrRmsyUktEK0FkRUxNelByT0dCM1RmYXBsUUFJNm8xd205djBNTCti?=
 =?utf-8?B?RlJRT0FXd21xOW1salplWUNvV3Z5NjZnNVZGZTBNMXVLWGtYS3dIM2lwcmw2?=
 =?utf-8?B?Sk9PTllXUkl5NHkwSWx3QkErdmM4L3E5ZU9hZFo5Mll1ZHZseFozYk0xYXRI?=
 =?utf-8?B?Z1JYRDNQeU1VaThjYzNGeVgvaHJuVlJzK04ra0dNSDFwL0NWY3lpSThZSVUw?=
 =?utf-8?B?RjRHWXNyMDJhOG1jdkFOUkdUUjVRQzROVjJNcnVDLy93NmJ1cGtKY0lkcmhx?=
 =?utf-8?B?SDBIK0FSZEVRMzBqN2NROVdBcDEzRkhNVklzWG9QazFXVzRRS25oekdVSSt1?=
 =?utf-8?B?STR5QllSTHlCdmloOGdKM1FHUmxVQm5vUlU5TlVmT1JUZjlZVjJ4YnByV0xT?=
 =?utf-8?B?TUR6dHRxR3pNYURjeWlkbnIweTdVQlpsZVRCbmZnZlJRMW0vNlI2R2dDblMr?=
 =?utf-8?B?ZDlpMkxQaG1wOU1iR1ZpYm4rZU1HaHJWb0c0cE8yTXk5cDg5b2xTcFNRM1BG?=
 =?utf-8?B?V25wTFRTN3M0OGZJY05wRjZxRkZ2WWFjMjV1bVF0OFBCa0o0eUsrVElEM1dp?=
 =?utf-8?B?VEpEMUVvVzdraUVnWmV5V0d2bURIbXd0QktNMGgxVDYxZXMvVWtGRVUweU1D?=
 =?utf-8?B?UEZ5akhHdTZaWUF1TjM2akJFd1E1TTluSEZyRTJINEh0KzdjajRtcmM4T3dP?=
 =?utf-8?B?ZURMUm5VdjhRZ2YrdTVPN2xvQXplTiszaGhzM2l2OFJ6VHdpZDMwTFlOQUNk?=
 =?utf-8?B?M3ZUOEZiNUF2MTlhK0U5cy9oWjNsUk40NUJNc2xlR1JOU1BaN1N1cEdlTGo0?=
 =?utf-8?B?M0FBNDNXdVl4dExMemlDR0NlMk1TckNEWXcxMW4vd3NreWp6ZDRDYUVyK1po?=
 =?utf-8?B?OEVxTlptK1F4SXJtQjVocGdrRGJ3Q3h6UXdERVJJNDlzbXN0U2dsSFhuSWNQ?=
 =?utf-8?B?ZW9tWC9kMVhWa3g1UjE0VkxwYzZEY1IxaE5FMWM4SkxqcTlORS9PSUpFaFNS?=
 =?utf-8?B?VUhOaWhlaUVmdFJWOGxNU2FpZmszMXQ4cWZpelZ1VDE5aGxFbHZBM3lRcmoz?=
 =?utf-8?B?dXRyYWttbFNDMUxwRjNOU1ZXNlFUK3JkQ0xhcFYyYlBka251R0cxZmVhTGtE?=
 =?utf-8?B?SDNmRXhzU3ZLeENGRVg0WXJyQkJEc0thY1VxR1Zscm9GL0tFcnZGanVDdTVt?=
 =?utf-8?B?RDlGQjMwRUJGTlZHQ1Y3NVYrbTVLQXNKaW9rUGE0VkR0UWlqVG9yR242dWFY?=
 =?utf-8?B?RUNqT3dJaDN2NnB3MkxVVTVGMDZxb201aHRKSHlraDJCa3RqbVlidFpUb3hw?=
 =?utf-8?B?OWZ2MnZ1UWtvMEUvMXk5YTlwTkpTRHNQK1dWcjBpSWFQbTNZMnIxSFBXalZN?=
 =?utf-8?B?a2UyYWhGMVFEb1UwUHlKckcxdmdRTWU1N0ZvaWYxeDY2a2JsL3JlLzVHQVFi?=
 =?utf-8?B?NURFLzg0TTA4S0hkQXcyeCswUEZVVlVjM1oxR2VwcThKYmQ4dlM2aGJjOGpW?=
 =?utf-8?B?MHBVYnd3QjB0QlE5SUg1QW5BZmNCalVsWFB2bHlIOVlMa0w2ZStkdS8yMDZ6?=
 =?utf-8?B?QUNMK0ZzWUdFeTFYbTVzNWlzQVBvTHV2OWQ5NS8zMEdHNW92V0R0Ynppd2tD?=
 =?utf-8?B?a0hILzJTUnhNdTRFM3VMZmYwc0dNeXdzUXJYZGNLYjNTbUdoVWxqY2h1dXJY?=
 =?utf-8?B?UmRyaUVxV2YyUkd5dXI2d2F3ckJWN3FBMDJCTXNaT1pGMGVaTXFCbkswem5T?=
 =?utf-8?B?ZkduSUpLTWl3a3hQdEZIQXdCRjIvZlA0bEpLbTJrOTBUd21qTjZ1SlB3WWRn?=
 =?utf-8?B?VG1wQXBzVnJsSGJqK1N5SGNvMWQzY0NWL2xPYk9Wc3dVZkkrMThkK0FSTElz?=
 =?utf-8?B?U2dmakJrek1KZlZkbU5VeWJEN05SbVVmTlFRUElLWjhkWUlZN0dET3NEYnlP?=
 =?utf-8?B?STNRZ3JpZEJiOEg5R0VFeDJyejRVYUN2VFVzMjg2TXovaVduTWFtSk16dFBX?=
 =?utf-8?B?NlZ6c3hmemNtYng0OFZraEw0SXMxS1k0SC9ib2lBK2tuaHVYcHZTMDhJeWNM?=
 =?utf-8?B?VjBobDJxMDNwNS8yZnRpL3lTMmQ4a0dwWmRtL0o4ZHlJM1dqVFZxaFRMeGVw?=
 =?utf-8?B?RkpQQTY4YTMzTThpeURmUVp1WitOZHk5TUVPL2VnYXVZRWFDM2RPMFhrM08v?=
 =?utf-8?B?Y3k3ODhMM1hVVG02U2NJTXZoQk5ZdUZzUk5rQ2pHMVlFK1RNdjZ4SURkNGJC?=
 =?utf-8?Q?wVv0ALNqwxUBbIQCFjCjPRaOF2EPOYRG4OAPi?=
X-Exchange-RoutingPolicyChecked:
	DF2LKwryXddtiOydgHL8NFeg9Uf6tL6a7lg5MQ5de+7zFhb4lfr53/zxHGa2s10W3c+67Rrzjk2ddwlM0ZVOXNUo5UL48YMQa1Gvs0VfME2NTDRN8WAWnKfxNjbvlkwGlh3gDAoolJi2TEj2U8XmVoKis5YDn8ySQQFI35FIF81ooZ8HibS2OQu4G1hIJoITYDCCS65IDrwfFP4x28fWwnT/zTTRsSlxZahqe4CrKrSV0rLvnfnENqKRD15N9OHH5566MP9/5u0VLdI0mvXifoQiT2JgGQumW1Ijr1chF1Il5R+hEE1w/ky2j11b35PBmN21qbED3ACcFD/JTiJ09A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pUXtSHfdgqNrMr3coyV5FYnVj/jGWJ2S5t06NvQS1aF87AAf8BDiKFlOBomVKqsT+KRaCk7NO5OLxMe+oXgrnicaWSf79oLqrZohPVzByT5LrnOq5jcLRjFDmmlXg5OxtLoykPYuqK0VcI7n5B1snYlBbggpUcppcwFFwwHBY6+bEgB2jPni3Y+vjS/+m89WuZ9tmTnze6wrgYkBpT04Y5SG1sJLNuFz09LnIhXKPV6NVEzsGNsPpYIxgWxKQ61e9nuc7Whzju6PssQv2jTmxTyfEN3Dj20Y0DpVern+c/r9aPhYzWqN3zXt2UAn4iZBrnww9wbYDwEbdt5KuJs08Mi/s9X7bkRg4qUaze2YMKw8t1Lh6/AkiXK0u9LW5Q9Jf+WXmElchBkK8x+Vtz/tygboKwP0s8xGJ1zWscaySGbgpEgr1eO6frIMsxCtocBCi+hlgMJQwZ1/Ic/X7+W8BF3HyTtG+iZIOoC+oD08BJREwx19FzjexNGbZ7T3ljanOK3+PKKv+RwJmnzaEYY0/FkZAg0Z5Gx4iEXSI2uDV1LynLxs4RcSXGXA5sn6yaVEZBYm3wURlMv/ySay6XHVDkntCZU84gSDsj8nHtwFt0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc8c7f5-2be2-4dba-5091-08defdc16425
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 07:13:38.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXTrrqQClGsdjycKp/YHGUPQlZsTcS+n0bXK2dzrM7/f36f+5ze3tGTENLmyGmb1sLbH9UxLmZlnz0jmoKlNKXFB1Prms0IxT08+nprkZvgSOO8ujUeKpWFWvGHngsGO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608190052
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MyBTYWx0ZWRfX9aQe9tGx4G2U
 WzMrmHnSx08E5Z7iigaw5xLmiGlAlqg2/oFauQXMOAPKW+SDFPjgXDnkpGXLBZ/h5Qc0rUGpwWm
 pAjsaXOtzBjR/TlmLgdrjl3QtQpYTKh7vv9TNebSpgzso7pTNN5IDxpO7iYtRAy9FKstZNOy2gE
 YJnZmP74neg9sfwPxhBAZJC6Yn1uySyabffq5bI6Z+AGRI5zhEfbCg86jgetmGAK5jIvEzQZcoR
 t7+fvMSSumtrTBBuZRuFujnt5UsA57vL+2Q7rH/No/52ZHc+bxhW1Ny3zCS8L9Kk3yELmQ8Wpq/
 pB2jIrUx8AF+8+2Ix7xelS1yIvR9Zu5qpRN7TyBe6NzJqftUE3ZyS+mB02tz5dtUPKi8FT+iklq
 QYZcT82fd1Jox6zOf/7HNNpyLbZg7xx8cF17r8mdBZcu2lkfDwh7EreT901zp7UcHlsyXPsccPw
 1yqJUi8DbUpi10m1Ww5vkmnZke11UPHsGHkhtafA=
X-Authority-Analysis: v=2.4 cv=a7wAM0SF c=1 sm=1 tr=0 ts=6a8557a6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=0D24ZiFin6CgtvjM42YA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: WareS93MQ5a-FnI7iDvyH689eA6UlM_c
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MyBTYWx0ZWRfXwoNLQCaZMfof
 ab5LmoFqU69lZFoKiib0fKShe894EzRvGBs7kgD1NS884mZfZe/68A8qSlYjOhdhIlaWvRfkrMx
 Mg1OvnRZWGTF9eeiL1zz2ZMziHPRuBNCpibIwVsYgPqnzTSeASxR
X-Proofpoint-ORIG-GUID: WareS93MQ5a-FnI7iDvyH689eA6UlM_c

Hi Greg,


On 17/08/26 7:01 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 


No problems seen on x86_64 and aarch64 with our testing.

3 AI reports sent:

- 
https://lore.kernel.org/all/24644fdf-54f1-470c-9183-8f5c420c760f@oracle.com/

- 
https://lore.kernel.org/all/70b7ca30-be03-49c0-aea9-840d734011b8@oracle.com/

- 
https://lore.kernel.org/all/521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com/

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>


Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
> patch-6.12.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

