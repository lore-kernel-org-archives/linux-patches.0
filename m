Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654974C70
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734180381; cv=fail; b=Ro6PyYaUqNTGWtTccPkoMA1NKVznjfPF6dmgX4KrtFAvI5jvAyPFTCtVZVjE9IQk3IHeHs9NJVzgBllW2u7HYKEZID19V7GJi500NVltDpV2GjY5qsIcfzb9Bud4OXbfDVdyXOKvcMub2ITTZMOTRZ0EMCCCPvwcUyXBXf/a0zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734180381; c=relaxed/simple;
	bh=mActpkuJofiI+CbRCR45Q1EqAxNqT8uauxQZBz5yXXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rnK+UIFi0+/PvEFDVMlgGAbdMnTsB3XCV4i2GsNxnbvop1BDwj1gsw+oRtUZwIgdM80eFtmqDvWi7sLjrVUGKBgca8BpfuWnlxkpfbsdEKRU0sFp7d1aJCw+KVi4l5YLO9c08j6VEVlhXl4ttn15Of/edk6FFyyWvzVb5jMmmw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jobgLdZi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jK/2Za6j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jobgLdZi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jK/2Za6j"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEBKtt0011088;
	Sat, 14 Dec 2024 12:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tBNhgADuIZOo4NasCLp8Ov9keVPoslCJwbt/i0pkUxQ=; b=
	jobgLdZiFEZAfw6hFGW1BfyeN+LaT++4M1Aq2nvYsMe42OYhAVx2wrPD8WZsXdXA
	zeM6R6M5OK2mrVB2P+I5e1DECDUMgUjlru6QwOW3tM1e1b9bgQdFKeZzs0/B4uDr
	14aeD8vCZ7u5O0Ymstfi9xGkTiTF1DRKQUG7nBpUxEz2dDffr94Zs/EaevKVbYAT
	xk/EdRMw8hH477OuhZ3PiTp0LhtZ4cVpEnsizlZ74x2eu8hkHPGjiz5ffbpm5QHR
	R2Ee4s6WSsXXBIQM1Kn9i3DRRYLlMHK0suSDiSC/IbQLKAjKW/Bd7HrzbHesO/6N
	HnJFIKgLEzgnM1iluNIK9Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xare1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 12:46:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BE9oBCp006499;
	Sat, 14 Dec 2024 12:45:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f6j45j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 12:45:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dz9Kc1GYIb6cvy5v3ER2Czh40QT+pUp2dylaQo7F7q5h+Q59WzDxHYzMmTTqPv69tOU9s0q/RE+G7hzc8/J2CMxl7GeDqntw7ZRwPw0Ihd/WRJde+41oZYb0y0JHPCSk/aFbDHV78kJzPncOtQNv0w+Gvf2ofwN1NxfmmS9pDVW+zpSyKhtvKqSqUZMus6UsBVAuEv81xWaB7RL2XpqMdeqPjWh5pNlAWAivSOE8BqI1vH9GoqZi7sZWHNC5Xsk+CXGutsx+r1ovdRp+cLE5v/RLN+WDNja1fgcUm24+kY6TKFFHUXd8CBuxFrZawg6eJxdcXQq2xSCo4RjL6rWAow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBNhgADuIZOo4NasCLp8Ov9keVPoslCJwbt/i0pkUxQ=;
 b=jV1KpuYreOvQuOwSkyPhtr2GDvVeBL+KjAHqL+p4D4aBc6XjTcR+cvFAA5/jKXmFyjK69Ef4FKikef72BfDgxSAZdI/MvwICuyKZvYaqJAXDD4ZsJxQFAHEYRRXJPr6kczlSIZjQCo1yl6Yh7SGnnMIBMcpL+q86tKn5SQobo5W25JuxSp/3qZAydh+Z5Yed9ZjZ/MPMfOYfH7s1Dt7cB8DX0XaVSIZuUZAB/7wAa5Gb3awveiZ+/Z5mHhOiNwjzRmhZmgOJGYRq1e8jYlAAxfcq0yUE2glNwhuP6OKRMf5GhYtFhnMXdxOtREBVGXT4EO+FbdQPDxTODZ0hso3p1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBNhgADuIZOo4NasCLp8Ov9keVPoslCJwbt/i0pkUxQ=;
 b=jK/2Za6j/766kAC93J91CtyDYSDT7AY8uGfh6z2bMr5BFHLbe/QjDKfWeGf2P3/VCtYJ5TGBMQQuvH8Owyta+sXmn5Jrp1qPr/+2tfaSYs6ne66nYRF5YthMIM4Hqc32JIYG66e/ZT7JL8DkORPI2V/OeWIdiBnKMQXvjBN1bkY=
Received: from CY8PR10MB6873.namprd10.prod.outlook.com (2603:10b6:930:84::15)
 by LV8PR10MB7967.namprd10.prod.outlook.com (2603:10b6:408:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Sat, 14 Dec
 2024 12:45:56 +0000
Received: from CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0]) by CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 12:45:56 +0000
Message-ID: <30e84dd5-bda1-461e-8401-c0c2177d6c57@oracle.com>
Date: Sat, 14 Dec 2024 18:15:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241212144244.601729511@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::11) To CY8PR10MB6873.namprd10.prod.outlook.com
 (2603:10b6:930:84::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB6873:EE_|LV8PR10MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: a40ec7f8-6e6e-49c7-4b9f-08dd1c3d40cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1E5Ui9mSTBGRGdaRWhsbnVxbUVINXBMS085R0lCWWU1NG1JT3VNSk50eUIz?=
 =?utf-8?B?dmUycnZQa1FxZEs0akdnWXlUZEVsWE92b1F3RkcveGprVThUVitFcDN1aTRt?=
 =?utf-8?B?N2RQMlIrTEZTRWlYKzBSYWl1R1NGTWxCZjRDNWRObnAwQ255YmpWbkhwYmoy?=
 =?utf-8?B?UGlmNGFWZTMvazFDbWFaL2pBUDRsZ1c1Yis3c080aGp0eHA2b2cwUWJnQ2FM?=
 =?utf-8?B?VWZ6MS9zS1hJYm54OWVvclVEYk9ZZWQwU1M0Ukt0RUxYa1VmSHEraHlHMTNt?=
 =?utf-8?B?K0JMWU80Sm9qQWxlYmc0QlF2OWVyUkNGQmthTGo3ZVczUXhEaUxzdUV5RnI1?=
 =?utf-8?B?MEVjTkZGdnpyQmpKVENhOUhURnZNemdCY3lnOW1RdXF1V25DV2JGbjhBV1ps?=
 =?utf-8?B?RnVZSmx3cng0UXRJN2JwS0RiWjJaenJ3RWg5RnRjZEhYQWYvMXVISndBQ0Jq?=
 =?utf-8?B?OVlacTZQNmE0R2diQWRkVHN3ZWNHbkpQOEt0ZGx0cEJtbkt1emJHTVlweG04?=
 =?utf-8?B?WW1CNlZyWHJFQ0VTbUFkUTNvZGJGMWRJYlZpUkd6N1JoeUQ2cFBIWkdEQk5l?=
 =?utf-8?B?UDdKWU1UU3B3c2VaNlBUNDZwNWtSaVRBK29kQ3l5a1loTlNldDZTMTV3Q1VS?=
 =?utf-8?B?T25HYUNiUFdmWnJveStMTHlEU25wRmNjRXpHQkpVN2UwbHpRSkNaL1N2bUFU?=
 =?utf-8?B?Nk16MldzbHZlL2h3bXlLV0JPQnFhd2wyRTF2VHZDWDZpQkYzNVlFbkVaNGhk?=
 =?utf-8?B?bVgySUltcGJYbytyempIUFlZNGxOelpUUHRBSDlrYTRVNUFVeUVQZDA1Z0xl?=
 =?utf-8?B?ajZVMm9LM3BmT2tDRnJKV2Mzd21oaUFualE3Y0w5SVFoSkxUQ2lNLzkraTRL?=
 =?utf-8?B?bkttTWwwNnk0eENhdGhFb0drVUgrbXQvR3Y4NFM1UmpkM0tWT2RIODlWWTM5?=
 =?utf-8?B?a3FHTzNsNXFpNkEvN1NoY1hDeHNIbS9kSFlDUnhTMWkwZDZhN2IrZlVFK0pO?=
 =?utf-8?B?VkNaSTMyeVZzWmJYU3JkOStrMDFVdGJmYXBvYWtMNEc5aFJPZ1lpWGdRRnNR?=
 =?utf-8?B?L3g2YldoSnJDQldaL0diMHh0VGRmUmQyemhLYnpLQkVRUjVlQ1lwNEdsNjlT?=
 =?utf-8?B?MFN3VXoyV3I3WERDdUpleWFDYWM0cjR4R2crS3BzTmIzNFJyaTVLRk1iWmJG?=
 =?utf-8?B?QStqNmJJRENXcVc2d3RzZ3F0RTY4ZEMwV0FEdnhMRmlkVFhxMmFGT0hkTTc5?=
 =?utf-8?B?ank2dnpWQ3NER0wxM3M5SVpaTWo3R005em12Y3VZekJ2R2RPTGdpUFp3WHRE?=
 =?utf-8?B?cVJ4dCtSYzZ1ZmtXS000MGlYUEpiQWdaTC9Ub0Y2SmxwV2YrRGpHRlpDOFZl?=
 =?utf-8?B?WmtyZU1VVXkyclN2cGZGR2RLQVJOc1Q5QnVNcTJEK1dZVmRwRkpCcmRUWi9y?=
 =?utf-8?B?OXhtSTZ4Nkt3L2tSaTYvME1vcGNYWFVwYytFK2owQjJmTGE1Ykh0OXB2Ti9r?=
 =?utf-8?B?eTBCRzlnODRDMERoSkZ6M0t1blEyTjFnVVBkencwMTFrY3JZRU9PbXZOOUlZ?=
 =?utf-8?B?S21UUnE0MFVyb2w3Mm5PSWtYRUxzTVh5QWkyTldIaGFsZWhLUGEybHFsdkpq?=
 =?utf-8?B?WFNpOVg2OVBXamJSRDNOYUZxcWxLSGZrd2IvWmpSYzVjVTlTUGFlcGp2R3I5?=
 =?utf-8?B?amp1TUx4MWMxZk9TN1hUZVJBVXRSUzZ1aDlsUmdnbFpZbitHRzR5djJ3aFF0?=
 =?utf-8?B?a29QTkVmd1oxcXkrR1BRbkdFbU5XakZ5SmtLWmlLN2Zzd3ZVOVY0eW1xbVov?=
 =?utf-8?B?Mjc1VWRaWncvWFhKOStQWERwczQxRVkwZG8wdDYyODNPUU1JUUtPUGVkYldG?=
 =?utf-8?Q?/xzaTBZwdNUcK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6873.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWZ1VXpiRFVTTGF1UGtyNW1pMVdDNldEVmlRbFA5NW1TeDltOFdCT3hDa1lW?=
 =?utf-8?B?Q3FBc285cVhHRS8xdS9tdmVVdmNWTjJDUmp5QkJZQTJVbEtSQmZ4OW9WOVpy?=
 =?utf-8?B?MnM3eFFCa1doZlNaaGlEa01qbWdVdmQ3SnZ6MVhibXhyaWZvdTl6MFpCaWkv?=
 =?utf-8?B?TWlFUXg2ZFJabmp1bWZJUmQ1WGM3ejJ3K3FuQzdYNWFpTy92YUI5VklYbW5p?=
 =?utf-8?B?YWloUUhOZHVOZDNQaVVVZFJYdW1pWXJHOUR6ejdHZk1MUnVkTU1UaTBUWGI3?=
 =?utf-8?B?Ykx4eWwyamxEUjI1SHhCd1hCQXVqSGRzUmdnUkpFUU1LbUJ2Q25TdG1LMTBZ?=
 =?utf-8?B?azZUWnpFNVlvVjZqUDlDZkk1M3ZJeGZvNDZILzZVOUdWQTUrT1lybVhEelRs?=
 =?utf-8?B?TzBMUmE3YmxYUXMyazgwN01WZG5rNlhkR1RPN3NOWUtCRnI2ZzJSSUZORVFp?=
 =?utf-8?B?SnN3K09MSC9QTEFBTlhxWW1qV3hWcTdBYnV5ZVdDR1VieEEydGFtcWZIYjgr?=
 =?utf-8?B?a3RQaURlaC9yenlZOFZraUlrUlZaVkpBUE0yKzhneWdYMG5abFBuQW9yMXFs?=
 =?utf-8?B?bndpMWt5dGREc0FNY0pSNHhqaFlhU1h2M3V6bUlMNnQ2OGVNNzZmZnFra29m?=
 =?utf-8?B?bHhaNG8yM1k1azFLRFRvR21jUFdzY1E3SGtOZXR1OUt2K2pBcUtKVGMybkp6?=
 =?utf-8?B?Vmt3NmVrK2NjYTNzV1dsU3lQbytmbmg5cHFtSXFjYnBQR2Z2bnBKTXhTYjc4?=
 =?utf-8?B?aldNQlQ5R0NYUVFuVitTUDRqZzJ6cW82M1lEOTcydVpXQUE4SGY0cFVaSE8x?=
 =?utf-8?B?Z2JQbEVkM3BDaTNjTW5ZbU5aS3hUbFBTSmVWRThnLytieHJyN01hZWRCNWh1?=
 =?utf-8?B?ZjRrNnk1a29jY3RGUlh2WW1LVHNINVNrdkJMZmEyVllRc2pWaHVjdktXWGMz?=
 =?utf-8?B?eDNBSjQrU1NPWUZLQTBUREtPR1RjQmx5a1JvV21MU1h3MWZUYUFDZ0lscjQ0?=
 =?utf-8?B?RUp2VlNXYnNoeFRVOHhOcGwyYVhlbFl2U1pWTGJCSHFWV1pabVZFWG5VK2Na?=
 =?utf-8?B?T2JqMHh3S1diMmd6Q1BhWG0vbjIwVlhCWlZVOVVzSG02WHMyVTVSNDlUSWh2?=
 =?utf-8?B?aEJjc1huWW5QbzFzdHpvOFp5MWN0WjlMVWZvVUhtalJvMG9CbjRJSUtkWCt5?=
 =?utf-8?B?Rjhzbzd4bVVQcU5WVDVaSzBlT3llU2VkRHdjY0lwMG5Rd2NSRVlabXFmK3F2?=
 =?utf-8?B?S0RjazZ5WXN1Y2FucGh5eTlJS1l5bEQvOGlMSkdUQkE5TFZpMnRUT0pWZXB1?=
 =?utf-8?B?TVZ6eGs3emMwWDRQNStHTlY2ZHV5NVlPT0xUeWdkKzlxckg0Zmc3TXF1WHY4?=
 =?utf-8?B?NzdQQmNzdFJHYktGYjhUSWpuMnozZUY1UUZJOXJEbnVsSkFyUFhxaE53Z244?=
 =?utf-8?B?OVVwTWxCS2ZRR3lnbEQ2Y0tTRW5XRnhxU0xqN2NiSW54eTl6em9UV21LS3VD?=
 =?utf-8?B?dEE0NzhoNG5pTUhRakN3cHhnL3p1Z2FLNFQ0TnJsNDF0RnlFZllmQWY5cTU4?=
 =?utf-8?B?S2NQMS9ubG4yUWtpSWx4ZEkrdjN1dzQ4K2FnVGFwWkZoai9BNy9ZQUp3Z21z?=
 =?utf-8?B?UnZ2Rnp3ZmU4aS9qNjZBZkRPUE11WkM5SENrdms4NlE3K085WmN4clVEdkNN?=
 =?utf-8?B?YUU4MHBMN1F4bWd3TC9mYURFcEZYVWF4YWV3Z2lyQnBpTWFwczJsYS9lbUxo?=
 =?utf-8?B?L0ExTERNMmJUUFhsREFoVkRESHlvbWpiYU4yMWNsSmt2aFRhblloZnI0MmVL?=
 =?utf-8?B?MURuNzFMTnFIVno2Q1E2bmY0V1RhRnFuUlVTNmRIL09VbXdKbDZOQm9PdHhV?=
 =?utf-8?B?RHliWTFUd3drSzdEOCt1bUFCUDdybjdtMHJoR09nUURSTkxOM0grL2oyeHpq?=
 =?utf-8?B?RmpHZ1UzUmprcXc5OFl5cUpGb09pVVBWS0xmVFd5bGdFbm1EaXFoa1ZVaWRZ?=
 =?utf-8?B?dGl4SHUrb0pBZEZxcVozRm1PZEkzN1ExTkt6c2JDSURqeThwMVBPUzg3WDhx?=
 =?utf-8?B?SmRjcGpOZ1VHb0t1RG9VTlFxNGljajd4NmxNaG9VdUdydXpwa3FMYzlPQmRW?=
 =?utf-8?B?RkU4ZytHY2lWcTFUTHJzZUtPaUlWQ2FPTUpmYkpOM21OUXhEQkZxV2kxMG9k?=
 =?utf-8?Q?TE2HVVn71G4rXuy6ec1YklQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U2gTTqOzojcYZOt3o1wvTfBktOSY2ZMuhpTBhlbb6vr6XDUGmYYM8Zm4IVfjmBnyJwmiCagH/y8drwpybkO2OIkWjLi3uWqdaYhklMH+OInX9W/9SYVL3F7fvF54AGTcx2FXyE1N8RmqbSAJYVzWg+BKs7nbSpmiCaRmRrPs0IAtJgRS+sCjA2GCxsED/PoMrKZtNayFUMYwrkoSfOTjl+A1CS8bw3e1W7vRHHygtCmMmdyi6kK8b93CBBy73bg6xGFnKZ+GfPE2jL04So0zc7VJpXfjFwJ+A9bVAXYcPexM2ALRMNr9bilT2MNELPlEbGt9+9IjggAZFEoloJ6OdkoRBWrpcuQK2dnMB8c4+n8MI7eRE+VNbmSTOLle7gckfsl25kIB7NkG7TFMRj93JX1tjqdhNF+CYx1uYwqrO8JRxMXN1K9HiqdWJ2wa3ZILV+UPrGYuKrkhilKRfthZ+HuZJ+11sRPQTp03QUMacKWlfT6FZoW5zZmYiwzAP83EAFMNIKwgtkVnl4AX3o4t07qVnnRedZCT4ZHZturZeQE12FvOveNBrcFWvO8eY5bnGinKYPWlDlwve9vt5Oydy2cbvXSvFPhjqKn8OLXaphE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a40ec7f8-6e6e-49c7-4b9f-08dd1c3d40cc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6873.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 12:45:56.4103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tD6wBfbm3AuKrs+sah1OGNqXVsgWxzREw80DDJthTb9/DoXi8bulXvxBwHiOWgMoMElK+rCDoF9AK2TZl1k8cJnF5h1cuWn6qbk5prdA9WpGJGvXzEA2+ZT3EWy+AcRL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412140105
X-Proofpoint-GUID: nnuhiu6vLxC1eg60_eVBRcP_90PR-jXi
X-Proofpoint-ORIG-GUID: nnuhiu6vLxC1eg60_eVBRcP_90PR-jXi

Hi Greg,
On 12/12/24 20:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
