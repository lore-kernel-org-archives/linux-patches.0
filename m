Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61117A318
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 06:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748931084; cv=fail; b=KAa9IGMxAmThNHMk4ykNhdIwN1L4IID+2CEi5MFcot9+RLQJKP2ijzLMUAIKVI/u31Ge8BE8QkD6hvZbwVyjnfkybZ1UOvZE9DPUl7+9ji47s5FthweF6Zm7dySLskbaj6C6fDgOgTi02gfpIxJPu9QuAUs+rahATyo5vz7gkk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748931084; c=relaxed/simple;
	bh=6U6gmiYEbil5XUiomlYtMDlJjl+oznbnCeTZzrhImi0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=inoadLnIhBWeWJvcW2ZweHCnWvTrfqPvyEeprNEAXAjH8RXD2Hn0YgNPU+9LAl5tH3ThTqM3k1mPvHVPw0dbtBJyq+OhyBIPanB1jqZG+GlL6RZOuQiHo35sF6lvxQcIIAFss5Hr2/mgK60y0SpiGfX6pksqeEcj72ovnjK5P8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IniMdD2t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kzLggYO0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IniMdD2t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kzLggYO0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552LN9fS009317;
	Tue, 3 Jun 2025 06:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=agFwC4atZneaKTaMqSyf3BjjpEFcGMWWKc50pF4TONc=; b=
	IniMdD2toPejv7Md5/boUdfIFR7wy7Edw587XGMz5zT13WR6vfq81iTwKjm51VX6
	QGx+aatg4BdVWRClbfZV8XBkTju/yWldNLgSBhigV4qc+QpIRtABf6AXBp4fzWCg
	ENEbdfO0lh5hx8cHUvYOa5iM0FRzDkr3ZZ9Yzxa5sZWmtV79f05bTbune5u4Fcto
	wsTNBwGKo6asYylz2dNYISI3k/DyfVIY31xf6/hypaHmHRXhRN1RoNznudfAZK7m
	Uwy7+o7ye/gMgBEGG7ACIZ0ygme4BkrwqkC4e95Y7NuKlCjpVgHniZhxPNxXfEZB
	obFuehQ5S9UYYl7W8TX2Ig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gah96hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 06:11:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5535vYnZ030739;
	Tue, 3 Jun 2025 06:11:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78vr4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 06:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VCFn5S3vn5E0WoeUSgGG95qyEahXP92cItZvNiJLwFBWZF8UpPbSZPJsZF0iWHvnPjjpPguQv8aAwLbcvg373vibrb0eTX5sb4JqsCBWQAfx9zxLCc1GMA6zkbJl1pGjqr7RmaH800EbGZhRisS4h1uuZhaw3L2bWdb0AP4Et8WxO0cgjnJbjKclelXxj1p4rtYsWoYpJ+0Gih9hw8vPkpmsP+5Mr3CZVZ+4ywfaAO9t5pyxqXvOG98AJeB8b/1yBtZBXvf5XDaUaERCS2Brw0WXfFKNtYpQybuAC/+bsppO6AkZlI91MqX1K521yL417pbJxA+BKjFjcNGOXop5gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agFwC4atZneaKTaMqSyf3BjjpEFcGMWWKc50pF4TONc=;
 b=BqAHiwysRvoyZ6kuJevCv/I7Nl6hEu3fF3Nmr0xDGaGW/jMlXKL9trQIp7sfz52MjR8V7AdlB6y6pF5N4xm+28Bu00oAZYgQS8zFaVdJyEjUWlZXNiJmJRiRZXEub14u+89oN77475s+QqRdCp2hqWlmH6FxME77p18RVsU/bvFHAmOQSHQUUUuDwx1SUkll3Gof5mTu3GSK8lOY2JHc1f2MjVCVBfhB302FiV8sIEHr/I9cVC7UbnuKkGrThu0+FCZQ/f7QaJaqAGhmvE7NMxXv8pEQASMDKxeTygIdjT3eY9bicp5X5wShBDa/EFFT7oPGA/Yw4bykGQWXz/Sq1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agFwC4atZneaKTaMqSyf3BjjpEFcGMWWKc50pF4TONc=;
 b=kzLggYO0Y/bcdZHyseabKQE6S5Rs7kRSnWZiDcQV5n9B9lf4QPGmg/Gx+6w4rdGcioDFCtzGnNLeBAL/SKLLpAeQiyfbWzJ7Kmdq5AzC4y76AAPZ4B7EPshO6JegelW6LvKResAjxIlOonzDMPlU5zFeYbHxO/IEZq08Nvzg6K8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Tue, 3 Jun
 2025 06:11:06 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8746.035; Tue, 3 Jun 2025
 06:11:06 +0000
Message-ID: <3b06f198-ef8b-4501-86c7-5f812db15456@oracle.com>
Date: Tue, 3 Jun 2025 11:40:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250602134340.906731340@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: 8edcb7d8-8bf7-4f1f-eafa-08dda2656cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnNTZEl3aktaU3hpdkhmeWNnRTVpcDBtdFcrSEVGZ1NZM0loNWQxY21ZdkJ4?=
 =?utf-8?B?MUhyRXlzcWV0V2poV3ZtR292MGJQUVd1VkM4MXE4cU4vb1hDcGxDanIvQjFn?=
 =?utf-8?B?V1JaUks0YWgvQ1RpTzZ1OFVqQk9FWCt0bEw4M3dRRmZ4ZFBZazBnRm5ZT3BT?=
 =?utf-8?B?ZVE4UmZHVytES0s1QWxUbzBWVzRZY2ZMSHUrWDJiTUszbTQzbUZ1VUdrVkJH?=
 =?utf-8?B?ekkrRnJYVE5SS2pEeWRqSGZ4YVE4TkdUZnlUcmw1Qk90N1pEZzJscngzTENT?=
 =?utf-8?B?TDhtODcyY20zcTB5aTdpWmtOM2l6RDRodFduYlhpUUp6SWlRSjFzdmhOUmZO?=
 =?utf-8?B?UExkWDZ3N1dGOG5VbC9ycVg5QmFiTlZOVE5zb0ZZaHRQdTBJSVp2OCs3NGtV?=
 =?utf-8?B?eTNVa1hCNUFuTUtxQzVzUGlSTDlJUFdqSGpoZmU1ZklkL29ESWgrTDJvcjFM?=
 =?utf-8?B?V1poM1dmS1ZxUi9UU0hSb1ZyN3UxNDA4N0VrK21nMit2MnBzTjlvWWpEL1dZ?=
 =?utf-8?B?TVZGVjJtWnBvTzI2cnl5M0tYK3U4ZjFhK1VWbkgrUkRtRHFrUmU2ejYzMXk0?=
 =?utf-8?B?eGFseFVHVTdEM09PT3g0bHAzTTJhelNUSEQ0OGRxdVpNOUVQV25wZHljcnhE?=
 =?utf-8?B?T1hBcnFCZlVQV1BJbGo1VXBCdlY3ejVhdWM4cEs2ZWkzdFVKcnlNNEUyUlIr?=
 =?utf-8?B?K0tsV0ZyYUJ4M0hCa2JtQjErN2JRZWFkNlhjM0prZGNRL21IcXd0NDYvbk9q?=
 =?utf-8?B?MlFOdSs3ck5ORnFaN2M3a3JLOEcwNGppWE1WbS9WUjBaWWVkN0F1cWhRdzJ4?=
 =?utf-8?B?T3Z3NDZlN2F5Mmxab3JZemV4NTFXL1hsdTJQRTdZK2ZXQUJORnVKTDIzS1NW?=
 =?utf-8?B?cjhJUFVMRzd4VHB0bUdNdWVrN215cUYrVUZpUnBkMEpWZEliMXBHaUdpcUZO?=
 =?utf-8?B?ZWVmc1RpWGx5eGRmZ1dBODFwL3F6QURzWVdhd09UcE85UHZjcFUyQUdIYkg2?=
 =?utf-8?B?TUdDbHE1Z1h0Z0wyRVJ5Y0o2djFpaTAxekhyTnF5OHhsdW51UXB0aTVhUW1j?=
 =?utf-8?B?YXUyS1gwNnBSd2FkV3pIczNNYlNIa1FGU3VQZEtLeEtHOWV4WUVqRnFpaWR6?=
 =?utf-8?B?aUY0bFlhN0hJU04rRTVTMFIycHdEdHU2TEltbUR6Z09tSWU2VjZWdnB1MTZj?=
 =?utf-8?B?TFZubG9YZUE3amI3eTNJVmJvRzRlM2R4TGE0NGdnblgwcVMyT3RJQTlDc1JB?=
 =?utf-8?B?a1hqYUpSRGRPaGNzMWdhdG9oVmxlOC9jdkdUR3dva2JSMDNvaVpEelpOYVlX?=
 =?utf-8?B?U2ZDcjdQNVRZZ2dSazV0ZDc1Z2JCRyt4Z3RHS0lZb2ZnL3M0Q3p0RVkyRE5Y?=
 =?utf-8?B?cUF5Nkp5Y2toRktBUTN0SlNWZU81R2FpOEJSazhLRGcvOWxYbk5vVEM4bEJH?=
 =?utf-8?B?RDZEQmczWG12YzE5eGRvVXRBQzFpTXNzMmwzbnNRNXM0MTBPN3czY0hibTZs?=
 =?utf-8?B?elE2czM4Ym0yanpYcFJNMHZMb2dJSTBQT1k1cHFXcnhnd21Ud09MbVhGSjZK?=
 =?utf-8?B?VkxlemhoSHdJb2pWbEsxUytVdGl5NUcvS3hFQllvTVlvNm9KL3N2U082ZFdw?=
 =?utf-8?B?ZGozZmJRNHVRUE5lVzlYMFlvVEpHekZnNldPWCswbXBValZIN2FyR2wzeS91?=
 =?utf-8?B?UDBVcjhpSytnK0N5SXdwV1YvWjBUT0YzZWNGcHJBUnZvZG1VdEZyckRQTmFM?=
 =?utf-8?B?eVhPT2Y4cVdIZlVnd0N2dHFoakFCMmR4Y1k0V1hlUCt4WEg3OTBNNzVsVjJw?=
 =?utf-8?B?bTVvaXdqSVcyMTRtOVZNQ2FodG5oeVFmQXR2VVJKMDhoNWlpZG9oRFUyMnRL?=
 =?utf-8?B?RlhOdVZzb0o3QU9wYnNRNUJkV256R1JndE10SUh3UC80YjRpY0szaGhlLzdQ?=
 =?utf-8?Q?wLN8LXODtWc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDVkRDZkVHZ3azVSa2pLM0JwNGtILzlhRTJhdzc2MU1SdmRvMjU1RWtZTlor?=
 =?utf-8?B?a1M5RmJIVXk2OWdrUDgxd1VrdDRTYWtWVDN4ajNDb1FHb1JmbG5QeDRRbUtI?=
 =?utf-8?B?S0tNUDZvM0xvNUZlWkc5NXhPR2Zsc1hBTlZlQ3FKQS9IQ1kwaytldTZhYnYw?=
 =?utf-8?B?RTA0UkozRUxlUjROQXM2QjdzZWhRMTE1WWoybEU4WUxnRWRoQ0hLT2doWGFM?=
 =?utf-8?B?UXhYTEVDTXdJWGpweW80K0szam00NXJuRHN0b1QySzY2dVZLYXMzTFNuaVdW?=
 =?utf-8?B?VGVQcytGNEl4ZXo5QVBuNXcyZHhjL2xqWGZreXVvSk9DR3Yvb1FDbVVrd01j?=
 =?utf-8?B?SUVpekY5aVlRVEh0eGkwUVJmSWgzQWpRODNycFJlSEV4TDduQzlLMDBCYjZI?=
 =?utf-8?B?RUlidGZVZktxS1Q1Nko2RUFvRDFnM0pmNlk3NXFKZVJOajBPTXpRQVQ5b3hl?=
 =?utf-8?B?bDF3TWw2SkFudEM4ZkZuWWthcHc2WUtvK0hVVTJVRDlaZzdSc3dzV0RTdU1R?=
 =?utf-8?B?SSsyYVlDeisxMUlBNkI1ZmdrcmN0T1g2RGdWOW9GNmNmSENCSWJVUzhYS25q?=
 =?utf-8?B?RnRZVUE5UEZORGxDcXhWNWNETUtmaHRMbUtTWDJ5akQycFFVNEVRR1Z3MzQ1?=
 =?utf-8?B?bGxqV1VOZHVzNFp5TndydFlUajhNT2Z4aWduZ3pDSnRtTWMyYVA4eVdrWUVC?=
 =?utf-8?B?VmVONUlka25WOVlncjNhWUJkSW1DdS9ZN2FnbzE2cjBtOUZCV2NPMXY1dWlj?=
 =?utf-8?B?amNkYmN1RlFoZVlDUzhCVW9QcGcyRU9aRlRqa09Bbzg2Y2JDTkJUbnJSc2Y0?=
 =?utf-8?B?RG5PQVBZMjVabEJYNEJXZ05WYUwraTdBb1JqMXZFR3pwYkdPdWtBcjBBRzFy?=
 =?utf-8?B?UEhYMGh6bzlESGVSMVhhcW1TQnVJRUpOL2g3OXYram5HaU16WGVsUjZkeGJ6?=
 =?utf-8?B?dlpEeWxHeVF1enhubWpEMTlIZTFTSGV1VDBMZnU0RmlUUWdQNWxtNGUrM2pW?=
 =?utf-8?B?WmU2a1pvSElOTnIweml2NDcvbDR4eFpMS21nUUxjd3I2Z0paR1JrMkFTajRK?=
 =?utf-8?B?TTU3dU5oUUZlc2VtMGM1QnVVdDNSOXhmeE1iWmRrUUVuc1pRT3ZTeWQ0YUxV?=
 =?utf-8?B?UEl2VEdiV2UzV3lzUzZkL08waml3U1ZhVnZLbi9OYTNpTExqaEkrZzZpb1Fy?=
 =?utf-8?B?VzNZTWVyZkJraks3U29Va3c2VGt2N2Y5bE1WRENFbTBRY2dWL0ZzbmlGVFFz?=
 =?utf-8?B?ZGtmS1o0UVFEcHpFMXVVSTQxQzlaNkVaVFFnbHVjSm1vZFJzTjY0TUJGTnlw?=
 =?utf-8?B?WUJtSTZGNkozMnRFTnJOSS9KcGRObkNvck1rU1orb1l4NFVMcks1MlJzMG8y?=
 =?utf-8?B?OUJPdXFVbGwwZEEzN1pNanJ5WWw4RmZSL1MyZTcwdDZuSFRYdmpVOUpPWXJM?=
 =?utf-8?B?V0pJdGVMc3Y4NXF0RUhVUDkwZkVjN29Ydm5MRGJzMUV0RWpCbFVvYWUyUmdw?=
 =?utf-8?B?enNmV2d3dmhVQmpRbTE1b2FPeFZ5eU1LNHZLV2tuNFltb2FBRHRMYVdrV0Yz?=
 =?utf-8?B?TzEvVFphWXJQUlo0RDdLMlY2Znp3c2ZHbC9DYUgrOFQweGZMbFFkak5qNVNF?=
 =?utf-8?B?NmJwMWVVQ0svUHkwR2NpVE41eVAvUExCNWJUNWFEcU1Cd2VqUS8yNG9nSklq?=
 =?utf-8?B?dStXWU1rNDFvclNVUFduWTdSck82bERqSDRPT2Q3QTdjeStpNy82WUVhdUc5?=
 =?utf-8?B?RFZkUmJDTGkwcWJzQ3ErOEdxaEx5ZjNzdk9JNXY3VUY0dEhrb1RvalhXM3Vo?=
 =?utf-8?B?VEdyMGN5Y2tWVFBJQVUzV0hTU1Q2Q2k2WWQzTXRqZWQ0Yi8vM0dVNTZ6T05L?=
 =?utf-8?B?M09TSFJMc2hwdkREQjI0L0d6cDdsWnZvUTNPRlNMRUZoSnZEcm1DRFpFWmIx?=
 =?utf-8?B?WjlWWWZST1Q4VjZOdUNLdHJsWDkvbWcwUkhtT1ZHYnd3aTVhNnlkWE9rWjRU?=
 =?utf-8?B?bWc1TXlGbUlROTR1N1dvNGZ3TWswRHVrcmR5WVpxdXIraHVlT1piUnRWMmNZ?=
 =?utf-8?B?V1ZsM1NxSDNUM2lBVlppenlKdU9MbGJFUEZtUU9KMjJqQnIrTHZSSU4vcEow?=
 =?utf-8?B?a0lFSWNvU2dSSWVWZFVVQ2tDcHh5V1k3VEtSWE9FNmcrNW9wYk1uWmg5NVp2?=
 =?utf-8?Q?Esc3EMil8OsmrPKsvCdg17c=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	69Lt6/AUjTcZANtzivPo+Up7378E5+KmrxAt+jj9NbnzdQ08M0ZAOUTM2LjtWd45k6Dsabw9+jFg2RsGBWDlU9cSdN+7BrTGbXMQSvlWAUbGMaz/tF7K+EUKmcrJg6mujQsTWlLD8LoDAP9ckS1WkF+mEEbf6eTkFrRq7s7f3lsU7RJde8utsTuxNWb9wIX1hImSSjIAZrQr+Vn4+MC8FDx29hrDuke+0nd7cU/W75d8XYqLIgrCvzn6PZB0/VN5L9QffVQiNvo5rLsiOxeDlGnQ7FkjWOCeEmTV86pj9ZDY/8S9DsC5VtczI/tCgpt5v158Bat5QqHLx1M8L6UyT9UvXo2426+psGx+EEOLjV5puR2nl/JjdSzROho8JIHCxtUmsr4sq9ov14YOJLutHv6j10zHRU3jQnyqQc7g1G1mtouUvL3yE74v7rOvnpyz1Z2YV5bwelK9SUES331w6UpOCMgITBwoq4Uza1lmE8L/0vXYd7s8iLe2sojlAJ9ebYaV56VBGENRuv7wKq2pOQD5QY692+DL9QJM8yARq/GVQL4+OnCEoeA4rfhFHlM9/owWG1RX1Es7gGC87uvc/JCfKWA0+2D8mHerxeDIZNA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edcb7d8-8bf7-4f1f-eafa-08dda2656cda
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 06:11:06.1491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ni0jL4TfW+uaryqeJG4E/nWAwQ6KrsIZ60RsH6aPuBkhvF36J4m71gtNH3dQ/UvzaCx0nrs7yW0tGWmeJQxNZfVGd7MiU8Pp+MffTXmTiUmC4oTn+eqKdt8VSBSemwCh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506030051
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=683e91fd b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=cKehCjhk2IfrQodDBDEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: -r3aKMxr4RJi09g3uyKFNny24pBrNtOg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDA1MSBTYWx0ZWRfX/IAse+WYfla5 8ea+ZLyJrpYy85JTZz4gIj9ILB4barAYdJoGsigklG1yOU+tMKodpfbtIbooVW6DTM7swqiJYL+ Hi79LA0UcjWscGVoaxDT6aOIxGrtBUH5xKcVuqp6Hjt/LO5DxL/3KNJuiuvF0vAI0SNy+AOD3z7
 4VwFipOGhNabSSKAQeO68kljHnIumUM089IvF1DJ9BX3p1W9NtUVneKloRATXP5mzOCTAbNO+Vx 4A9a9EDLrtQeNvJnTbPKfJyVwWTOSshamD3eylThr77zlBbcgMo4w1XSbKcegYP4ZY4+0LoNyvk N4tkvjduOudklC7hYv1C3o4SDEFOKCF+ozztFv/tNRrN9CGpZJbhdVsniYuLbFy4zNlVGpjvlsP
 j3m3CVMNFNd2XxJPyEJCgEtBUSPqVyC20i11A4/gTlaMz/lnaGkEKnr7gVB853awqJkXVtI2
X-Proofpoint-ORIG-GUID: -r3aKMxr4RJi09g3uyKFNny24pBrNtOg

Hi Greg,

On 02/06/25 19:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
