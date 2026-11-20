Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795171976;
	b=usfkh6e+7wK/zlCeSHpKNpYhFGDpSIDGxHIJQRjuTgCyuJCLQgMyKQZyq9WwEmuygs9w
	 bH/V3TazIsKNc4lpswFw2WfZLigo3FCGqgEYUH74W1Tlru2l3XYq76dHZQqVQTajcBbZk
	 fUYWgg3ERPTjsdJHIDFU70ElmbhRqeJsvX27rPnWkStRLPMW41VLfusM7VCL0H6f7h4c5
	 Iy92d1Y5U4wb2lUiLxmtvNRJuRssYc3GVhmMIBnGyjbxmmgs9Rp4SkiD86LVgTX7mUFK8
	 UcBSNNCZbRse1ZXiy6/a18D5B6HR0Se21gkCmq6Hoe6LrgnizffiQ2E5XQh96EcY1lg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171976;
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
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info;
	bh=wLo8YpPz80DCcFuImfcIoisrov3coWRRw4yGl05DN/A=;
	b=KFX0gIu5xgOYS+bqXGCT/zWCKuNHBz8GDqDjbn9VzVW84oqJ1frd15bvNbWqIWdnsH6M
	 k0YOUqK/VPux+lLhzpDwASVkHeNyVhLOyZlS0OY9J2DPrYuoE0pl9pbR6fplNNJee69WY
	 6At4vMDiq/1fEBp5GyO7Ug6nIp4Mpmxp1ZP9fTj6X/UvTrm4Pk0wl0/9B4yldSXRjTuDY
	 uz4hrfYRWNdFDoKILa9RlOjgqiQSi/W9S9mLWpdKFAPxRMK/y0FjYVfQGkdzgzkYveb3j
	 zeV6fEg/rXcoY41X4GMYFw1b4ac7PycaY0jg+9L7E2PTXgkgUR8LIwQVavUs1ej1y4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=VAx9zo9G;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=pmfQmTvP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621A606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 10:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D621A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=VAx9zo9G;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=pmfQmTvP
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3T7OC094326;
	Fri, 20 Nov 2026 10:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wLo8YpPz80DCcFuImfcIoisrov3coWRRw4yGl05DN/A=; b=
	VAx9zo9Gmws7ZKQB3p803Hrlo0Lu7c7sUrks9zW1OI23A8/iNe3UpeQcsNwpLc30
	3Mz/o5cllokv7VzD1fD3xSb0ATx7AfS70C0+me+Tdm2Rt3XIFz2r0PC8/mvB6w+D
	xfVpRyjQF9vezRjyp2NXWcJGTzX78/MFdt5z81o1BU4W1eqX8UpSpcKNVtv3CJ8R
	qAa+p/BNk+QbpfU4LhWyK9iiVCjm8Q98wzR1Sh/b7sHw4AaJSHPzf39ZK8jVR9Uq
	Z/MEIWjpYBhnKjy2Q0TfNABJrr7cfoflK2NUpYTtZZ843Y2rcOAdOgWu+esR77Te
	wUD+nPx75wQJ0IlQvVB2sA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0yttvfd9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 10:52:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAiqRm4134326;
	Fri, 20 Nov 2026 10:52:47 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2m8d980d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 10:52:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpZAupNPum8FR/GvOQX2XzPS3Ir2MJApxs5BgXDtBXFq6/rY1azXARv8M3rmbAfuU0j8yRys2UGh15TEmCkBkylCPsQR+6CWB0dt/t6LO+QDcnYD13Z+/RFcM379HHYgjNPdTPwGzeVy79oKAD9VS2oJy6tinYNYNRupSueM9jTUC/7hmZrrjRm3UE/iQf2pFajC+GTQxXpERU/xK0rd0JOfbWBv3AD+j4iRl57pYG6U2OIJzpFea+GvcJQnMo3LnOvM7MXH+Rqae1FpZ45Vpk4q2ZyG9qf3Np/n1y8juiDB9zbe6EKb2MPygBq6JTeGV9tV9HLep4oih0lwN3xeeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLo8YpPz80DCcFuImfcIoisrov3coWRRw4yGl05DN/A=;
 b=GnOR7+MKO8/FhjVu4YEUCSslJ/9O1ShKnGSgKiPaZzKfcN2l2h2ci4ZqZEEITfSpIbMrvISVn4AIx9LJI1k9muebO8Sl5AlJcELLkOJ5/ZHQcoJVKH7h2PcuTka0eOxHHiC11KQl53GoiimHus6tyf5Q3dIORqGHLdmJw/oGJf5IsQMEUfFzsIQO1ZDI2HbeUhR6uBTDNCp2GcZKXoXvw7Em1oxSpKJzw7diTbwfENdhhuSJfBePsmpj/kMeql9C1rWUPHvDRMLBqFFRJ253gzQpejsPtPYTfmx2N1V90xoEtCUoYVgChDK+2xH+3hXTvT/nKlp89SpRHRw1FVObdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLo8YpPz80DCcFuImfcIoisrov3coWRRw4yGl05DN/A=;
 b=pmfQmTvPcn6BPeYGkV0V0y3JuIYPk3o22+FbZiV5Eua1pKMxw6jHSAEYlPtqyg7evNgWUuWz5rjbxRme6F5bw+zhde6aMmzfTQHLamryIKXw1JSWLQnu3aXbE9b5afHVIRxzuwh9Wz9Q2V0PcY3xIT/GPQPqG2H5WPC25s6MvYI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH7PR10MB6179.namprd10.prod.outlook.com (2603:10b6:510:1f1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 10:52:38 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 10:52:38 +0000
Message-ID: <60ee151c-fcd5-4125-bc51-a21f28fde1ed@oracle.com>
Date: Fri, 20 Nov 2026 16:22:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1345/1756] btrfs: update the inode item when removing
 a free space inode
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Tal Zussman <tz2294@columbia.edu>,
        David Sterba <dsterba@suse.com>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150102.881764190@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150102.881764190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0106.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::21) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH7PR10MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bea588e-d915-4b98-dae6-08df46f46493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4143699003|5023799004|261013131602099003|261009223027099003|261021123027099003|10067099003|261021121427099003|261102123227099003|261022105027099003|56012099006|261028144727099003|261022075727099003|261026140227099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Bd2NkE7LeJnafXcDO112rbYkgnJGOt8N53N8NjpdvUGfDwU9yknazx72Bhnjh4KBZrpgNTSQijnq7gODCqNyWjAxxnSSbuBlJzLlh0zgtjpTMoS1HA+mNhEojasOJJGpvB3ArwR4OIWdQWTsgaQQ5E3wm9pkZ8bNT9yZ0eeaLOq4r4wkru2nHePdGRsJIpXEn5W5DIWPtovaicgBjeFpsvFO447eHw8Goe3kiEjt0CgMswJWVt0xNNP1rGGuE10rp/K8Kiz+7/rsq7A6KD9E63TwbfxouODNyZtPx0nLBz8XEuSCfHpPUlWV84F2Mv0KVfYNRabVobejyVmUu200SoEgyrtBen/CQMZ9d15c3o/Q3ES34HP2xTU5L6Ml+96no4zGnbG9dd144enQCd3NqepyOv51QnUhAOFijrJd7guV/abaxH8Cl8nBTxjsFBdmBGMhXv2dVgMRos3wC6B17uqznS7W0Chu0InECEcF8TY2PBmdqnS9G7iQlJsl4Oh3LrnknjI11/G1CB150tWcNocZzatZRRk2L938Ep3MBfsGYOhDf1Qnl+hK7DFWFfqLgEAgFiRp/u++olcsiBPajaVba0qffvltF7cnSCfKaujFQz0MPgPoUxNcNDR5mnetu6eRA6eCKNWB91qhUWToQreOq44kUBRON+PCtISn0KM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4143699003)(5023799004)(261013131602099003)(261009223027099003)(261021123027099003)(10067099003)(261021121427099003)(261102123227099003)(261022105027099003)(56012099006)(261028144727099003)(261022075727099003)(261026140227099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDFWNnVZNUtETTJGbmF4WVpXSEMzUWk1RjFjSlNza000T3FFQzZUTGNOMnMy?=
 =?utf-8?B?WGREVEdiNitJVTRaYkVoUzh5a3ZMZ2RDWVlEczdmMGpzV0F3VE4xUW5xMHI5?=
 =?utf-8?B?ei82Rzl5TmJhRGtoaU1xRnI1dVdueUR4ZE10YlM1T1ZPd3lQbXV3R0xDZXFk?=
 =?utf-8?B?aUtJbDFyYm5jZ0g3ZE94RDIxWEZISlVsSDlURGkrMkx6d0tXajBSZWlPa3Bt?=
 =?utf-8?B?QWF6bDNVM1ZKdXRSNlJoQWFJWURUWmpHTTBlWEdZV1F5VHhuclFITkJZWlBl?=
 =?utf-8?B?NE8xWDVrK1E2Zk51QkZnMm1yTFdSNGdSQTNnZXRHdE4vT20zV2FqTVUvc0Ns?=
 =?utf-8?B?Y3pvUmxOc3ZQSEJYRWFKdFc3V0pHVGZnK016T1pnQmYrZkQrYTJCQUtDbE5k?=
 =?utf-8?B?cWhKQm5uckRvbmI1VmhlRVRWc3NxbmRYdVJtR0JLSlZsTEFYZzNOTFV4YzZT?=
 =?utf-8?B?WFhOSGNRRGZRWXNUaDFNN3dlWXYvK1d5ck5yVCs3R0orbk94UlUrK1FDRlVO?=
 =?utf-8?B?VHg2aUNWVTJWREZRY2ZvcXNET1pweWVzNHNaUUJVQUlHZlhBUzdPajVlQUtM?=
 =?utf-8?B?cUJnZGVKZ3FDMk02T0kzOFdEakJJWGVoaVBqRUJnNEdjQWQ1NVVKV05kSlNq?=
 =?utf-8?B?bFlHd3RZNHZoOGhiNTBBNjlieUJQZkpiV2c5dU40VzZKOEI5eEZhL3g5K08y?=
 =?utf-8?B?YndsU1Q0VkcxUytsZVFyL0d6eWhUNlZQN1FhVzBaYmtWVDI4ZmxwODF3TVp3?=
 =?utf-8?B?MGtoWDlDTTNweU5TK0VyczRmZGxscFVqTkdoTGFJcEpLK3BISVF3SEhzRk5Z?=
 =?utf-8?B?QkhrQUFVc3M3Mm5NNTFIeHNqTnNaZGZWVjhPZi9VWU9LbncvR2hTUGNoMTl1?=
 =?utf-8?B?TE50UURvVWkvVTFFUFIvNnZ4Vkp6blFkSy93aytyVWRpbElYbitvQk9COXhM?=
 =?utf-8?B?eXN0UVdWQjA3L0xsdDVGM1pMbkJGdDNwUXZuNjZzeWlxY2pLT1M3UTRiQU5v?=
 =?utf-8?B?RFJWZFJJcjh3RjIwei9IbExINm53Z1BPRDU4cTdTR3ZoNXU5ZFMxTXlXV29j?=
 =?utf-8?B?YkhJZTlrN2NiVWwvM2F5MU5CWkVrMXNvREVMYkEyTWs2NjJrUVVUWlNZWDhN?=
 =?utf-8?B?QTZYSytUYjRxYUJjSW9GblhBQVZBWHVPajhSQ3BDbnk3SXh1TTA4SnJ0emZu?=
 =?utf-8?B?TExsRGNOcXlyc0VVR3RPSitjR3ZyMndIL2x0Tm9CaXBoRGlqdGI3aE9yMEhh?=
 =?utf-8?B?eWtCZ1hkcU00VUVOdUZ3akNoeStmNDM0UjdIdWQrYWMyMkFpNGFHUjlnZ1lH?=
 =?utf-8?B?S3hlR2hqOXRTSktXcjErT0Rac0UybHFaZlV0aS9uazBFM0pyd2JRaWo2V1ZT?=
 =?utf-8?B?cFk0c2Z0Z0IvUDRmN3RYbW9HRmFtUkJ4L0Y5bXlCQVVvbXgrY0h1MW4rVGJv?=
 =?utf-8?B?VlFSTHAwWE1YWG1WeVN1SnpVNWtReVhMK1VYZWRMbWxGYXZ4Rk13T0tzMWRy?=
 =?utf-8?B?VW1SdGxEaHlYUE9ta2FoUGo2Uk5kR0lDT25OL2tPRFFDakhDWUtDMXI5NXNH?=
 =?utf-8?B?UEd6dU82U21uOE5idTBmSXdzRjB2cGJJZWZuS016YkUxVU0zUmF5amZOakVB?=
 =?utf-8?B?WlpnNUNPQTNQQXM5VXp6aTNyOERuTTdodGEvU2p0aUdTR3VjRzVWN2toVHc0?=
 =?utf-8?B?QlV3RkZOY1JkTmIxa29xMHNycnIvdWl1TTkzRTliY1lCbUlHV1hORmdkU0do?=
 =?utf-8?B?d00xUFdpRHlBdTNMdUFuMCsxTzdLK1JpTk5VNmZlUGRDTzZKZUJKQkRSaTh6?=
 =?utf-8?B?TUMyRFp2SFpNdTdnMWErZWozNURzZEdoaGJmTEtNQmNNNElHd3AxdHJLTnNi?=
 =?utf-8?B?dWV4bWhZRVMzUTZYV3pueVV5NnQyRUFsd2dCYTRGd0RSZ1JCRHZnMCt1UzUy?=
 =?utf-8?B?V2V4VGtmWU1DZDJvdkhUYUMvSldJYlMyQkZGMWVXOEpPMGZzdllJbVZRcStF?=
 =?utf-8?B?V3pUTzVIVThaam4vLzhUVzFBODV5QjEwQUFEdGp3dVRoZWpVYjFvMHJyZ0tS?=
 =?utf-8?B?YUFHaDlzczl3MzRnaCtDKzZhSTZDZVJ6a3EzSkJmM1JkVVVEeFRUR1N4OWg4?=
 =?utf-8?B?anJwallzblZ0eHdHK0F6blF1V2pLM3ZHTlowQUVoOW1Rc0VUMEhwUHlFNk1Q?=
 =?utf-8?B?bmgzTmhvRVowL1JscVNyRVlkdTlUM3JVaEZLdys3ejh3QWlpelZ5QmtPcGNu?=
 =?utf-8?B?VGRtaHVXbW90bmprUDRPcjJGTjQxU0xzV3ZxV0lKNWZFLzlLek54TzNJa1VL?=
 =?utf-8?B?S21BY25XMDh4blI5cW5TaHZiZGtyK1hSWTdZbG04emNQRlE3TWY4Wm9OK0I5?=
 =?utf-8?Q?KbhTsC/RByyv1kO1TMwf2o+qeK00Axr7zX+3f?=
X-Exchange-RoutingPolicyChecked:
	MzOlTD5tKyvqQUwKtkZWYjiuukWr7BaDvCFjcGHGxfLMp0aswOEOxew/1/J90/9Q/vCHjcMxl1zkUJlOWkV9sn7zh7pDKGz8efMS+7WjQ4tpAe8gZrxEkzLSKsCqG5IdGQ+Y+KKu5m1lHZyvKiE2Vv3iegIBv4kuoSltp9j9wTtyd+r7qRbn7L/AP3tBWfQmCyBg0VHFvS8CaJU92MswP4epyMFVfmJkRGf0eqj0zoROlFvsb0xmfwc/yrqklcE+JPa2+5WCzFP10EphmITNfiOBAjiR7D3bGI23yJACtB6TU81MB7pAxzGVciZ9NfziABUWcAjOqRViWOOMryt+vw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zauHTjdvIcZYA9Ll7CgMd4xpS+Pqj7TD5MLsRc1t87dwg23f16efbN0bfAfaVGBy4cgfCDDLIO5IijeMYUjBwVQyPUnO0z+MMdjLFxDEJwAc012+1YKYm7cwXU6XN2OyQeMZq22HAMDylI0+Hzi9BNni+5QB7eNc8bEEqETQvzUajuaVCP4B5BoEMmdvWs6DEfU/Vdw92gyMsddEs8ewRUov5UVx7kHelpRe4FiwkzFkamU9l6wb4pGJW1AAq3H96gQBMp9RQhufeFB5TbdLZR9rcxSiQkC0GKk1zQ6kG8+V/fkmZ838UPy69+Q+c7gVTOX2D3GJ8ceAeSYCF24+MqI2a5ojJodR9Erdhu7+2nvc5v+Ov/B+ksWR015blPAfWj64dT49+IuSNIo/scF+/MylCWDn1krOgedg40PzwAr7JJXhbO5WmSasEMceNIAVmOAzZsozjBSM8fBxuci6FtdDaTe6KBBl5PPn10MFwlRg5jic6jyBFILU1hSHLa/l2V3nnvhGUWonILzcEbPX2WcAWYw0at6HCi0UOqc6jLG0JveQl/Kq1WUhtI8lbxz4BPxAbh0AmkeXg3aK8iZExVpEmoy0cMY84lO2sLXPqZs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bea588e-d915-4b98-dae6-08df46f46493
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 10:52:38.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbAuxsw2iwaa5z1Q9a+InEjB5wKsDQ3fR77bGqX5O2NkEQPlQN4oWQqjBzGzekM/OWfRZ4juEVnDf8RsEhzsFj/B1bA6tYD68RCEz6l1RBURGUPB0OGn8uzCQRMs9tYq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200043
X-Proofpoint-GUID: 4XRGsHGwoeAs0z_b96LjAHWv6wk9Zb6C
X-Proofpoint-ORIG-GUID: 4XRGsHGwoeAs0z_b96LjAHWv6wk9Zb6C
X-Authority-Analysis: v=2.4 cv=dd4VTnXe c=1 sm=1 tr=0 ts=6b002680 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=iox4zFpeAAAA:8
 a=VwQbUJbxAAAA:8 a=PTKaZVi8P45otQ5e7PkA:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0MiBTYWx0ZWRfX/i1j6L3DRLcI
 NqrOtjdUWS841s7Q059KTtQH2fXCigsoPLC6AilIyiMhsjYHGjIb2xE8LRvYx1XFFHumUVDzVVV
 LG1y3L8qL2y253E6bRe5jpnfnvHU7qZ6C/izX9WMG31m/wr6aKElzs99CZr5kzELprdVnxzf7tw
 uNAwZTSwJuSFSlI1UJhPBD9BYuEpgYc+ty9dCcvjtfAjbinxNAvoWiBjjLCR7jrKU1kMpeoWtHl
 QvcfCtg9cpfKGAVZe6vHvPs1vNrxCgbvexeF1bHWqus35R2qPKPODEw48BbZMOqorZvBnbWL7eA
 yB5hwvWjlyh4NoW326eCn+XY6CnrsZC+HwD0W1XNEMDB9TA5WoVODGTpN6Jthct/kLbxdaxgAgp
 a42WZ3rKV1nNvzM+4CAJiQKSEz7GObUpIdvi6c88pvAc/F4hWMjqOf2JnWnuI1HjkWxYspZfmIl
 UnJ6SMNswHklEjCyZf67kzoZbXpUuBfdgPcZyENQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0MiBTYWx0ZWRfX3aPy7ue9g415
 ZcBDO6hSbd6bHvhB+xm6M3qIZxeBcPK5QiiikcrNSeguvrOmUcmhuzbCBy9Oz9Zlsdj1fPppfiP
 lT9KQkge37Mux9vwqkBIDFP+rqtTkfVBIBw4rnOnITCfjbZNfNxe

Hi Greg/Sasha,

On 18/11/26 8:27 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tal Zussman <tz2294@columbia.edu>
> 
> [ Upstream commit 4e89aff9ad6fcbec555c38169807c4023f93450f ]
> 
> btrfs_remove_free_space_inode() adds an orphan item for the free space
> inode and clears its link count in memory, but never writes the inode
> item. The item is only removed once the delayed iput evicts the inode,
> which happens in a later transaction, from the cleaner thread or a
> throttled transaction end.
> 
> If we crash in between, or if evict can't reserve space for the
> truncation and leaves the orphan item for the next mount, the on-disk
> inode still has a link count of 1. btrfs_orphan_cleanup() then treats it
> as an inode with links and only deletes the orphan item. The free space
> header item is already gone at that point, so nothing ever finds the
> inode again, and its data extents are leaked.
> 
> Write the zero link count to the inode item in the same transaction as
> the orphan item, so the orphan cleanup evicts the inode instead. Account
> for the extra tree root item update when removing a block group.
> 
> Fixes: 455757c322cc ("Btrfs: delay iput when deleting a block group")
> Assisted-by: LLM
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/btrfs/block-group.c      |  6 ++++--
>   fs/btrfs/free-space-cache.c | 10 ++++++++++
>   2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index a01c4a5b95db7..20df0965316df 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1326,12 +1326,14 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
>   	ASSERT(map->start == chunk_offset);
>   
>   	/*
> -	 * We need to reserve 3 + N units from the metadata space info in order
> +	 * We need to reserve 4 + N units from the metadata space info in order
>   	 * to remove a block group (done at btrfs_remove_chunk() and at
>   	 * btrfs_remove_block_group()), which are used for:
>   	 *
>   	 * 1 unit for adding the free space inode's orphan (located in the tree
>   	 * of tree roots).
> +	 * 1 unit for updating the free space inode's item (located in the tree
> +	 * of tree roots).
>   	 * 1 unit for deleting the block group item (located in the extent
>   	 * tree).
>   	 * 1 unit for deleting the free space item (located in tree of tree
> @@ -1344,7 +1346,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
>   	 * more device items and remove one chunk item), but this is done at
>   	 * btrfs_remove_chunk() through a call to check_system_chunk().
>   	 */
> -	num_items = 3 + map->num_stripes;
> +	num_items = 4 + map->num_stripes;
>   	btrfs_free_chunk_map(map);
>   
>   	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index effc8895516a5..ca16a8ccab545 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -266,6 +266,16 @@ int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
>   		goto out;
>   	}
>   	clear_nlink(inode);
> +	/*
> +	 * Persist the zero link count, so that if the delayed iput below
> +	 * doesn't get to evict the inode, the orphan cleanup on the next mount
> +	 * evicts it instead of only deleting the orphan item.
> +	 */
> +	ret = btrfs_update_inode(trans, BTRFS_I(inode));
> +	if (ret) {
> +		btrfs_add_delayed_iput(BTRFS_I(inode));
> +		return ret;
> +	}


I ran an AI-assisted backport review and I checked the finding
against the code, and it looks valid to me.

Verdict: lets keep this and maybe add a downstream only fix ? there is a 
allocation leak created because of this backport.

In fs/btrfs/free-space-cache.c, btrfs_remove_free_space_inode(),
the new error return bypasses the path cleanup:

       ret = btrfs_update_inode(trans, BTRFS_I(inode));
       if (ret) {
           btrfs_add_delayed_iput(BTRFS_I(inode));
           return ret;
       }

Upstream's early return is safe because the path is automatically
freed. The declaration differs as follows (6.12.y -> upstream):

   -   struct btrfs_path *path;
   +   BTRFS_PATH_AUTO_FREE(path);

In 6.12.y, the manually allocated path is freed only at out:

       out:
           btrfs_free_path(path);
           return ret;

Could we change the new error branch to use that cleanup?

       if (ret) {
           btrfs_add_delayed_iput(BTRFS_I(inode));
   -       return ret;
   +       goto out;
       }

that would be a downstream fix. Or drop this patch ?


Thanks,
Harshit

>   	/* One for the block groups ref */
>   	spin_lock(&block_group->lock);
>   	if (test_and_clear_bit(BLOCK_GROUP_FLAG_IREF, &block_group->runtime_flags)) {

