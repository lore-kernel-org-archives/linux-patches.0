Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9737941DDF2
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015114; cv=fail; b=RxIfEPbNqvQdEMk3qWyBBPYe0DuOaul2GVt7UhhcPGufXKtgcd/prq5DzczolnUWJY4An4UGKpQJ1bYadMaw/TpG0a7mfM6LA7G5bYE4dKkQxNwRKg9/61JdzbwmiB+oTKtM4o/2ievQmnIVBgopcRvCSPyuLMVRpsEojYk8eiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015114; c=relaxed/simple;
	bh=X5+XfxY3pmN4FxNgPuR/JtBjecjnVcUYd3nbPVXXOYs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=riYzPW/xaqlwofFQy3fhQzT9qkV1Li72vf/EQ+8K1R62V6TSCkfcDHANqSjGVW6MdKcaZvTzaoqPHISMDbo1Ld03KPpotei5JXyLvnqPf6Sbf2SXgQECU/ioE1BORYVGXnB3VvYN/J2Zg2UhS/vItFbaGbLNiZROBV9vXqjcGcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EYUxTZ06; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DuCB6+3o; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EYUxTZ06";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DuCB6+3o"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELgBUB3349855;
	Wed, 14 Oct 2026 21:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vDj4OERY2gAxiQe87OuBPXBjBSXGnRJAblx/pLx00vg=; b=
	EYUxTZ06IN4W/HHyagRyAalHKaeLFdB1Mq2C26AXOzo4Ft2eiIE4MFStWeUZLhH2
	YOJFUMfmcokdZUw2A0grznnJgyR0JyPK2cKuRIu+WxD6Oynuy9XqGMFPwVmSuHt4
	ics+me6JoFFq7geyiQSr2WZUCLIQo2G22MPNuKy0j25pGvDlhq830fX1lNk5XrxZ
	MZDq1anuX8tRR6SLEn1QeIm/8aHiUtzjAvG8jUlwLOkSZl7VfBRD1J1D3AWbK3Lh
	hKtrLM/wbPewIhkMTPCvC22TPopf+xD341GHZc+qR9VV95vsLf4MkL3Q1D2eAIN1
	38UHehbt0jfgCPY1y8LBGA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgq4w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:58:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELpgw2010322;
	Wed, 14 Oct 2026 21:58:18 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btr5evn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:58:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dORarTXXn9e8rtSmHTGOUH/+r3QQDoasf2DzqiNXVF16yvlJ57Nfs6eEvStiLkPh+BI4A+H4DCqkvP1RToRY60m2a13JUWbEFf2jTS6+laIYjZFVVjNZc/9CZID6LEvlBQjwKcUdy0tUa33O22uFOeW3EbwBAIeJrmFC1eFm/oolk6rCqSbAEU8aqQ8sZ9MlRdh/JM3HP12GbguCrMYz0W7cyMb8FMenzB++3tl4Q4MtkRAFrLoak/tHEaOcO2pJgeOROwFRfmhthtYbavcSxruZtiWI3nrSq7KU7hC8KwOYLDn/nfwoiYMT6YxHKJ0VkjlXtsV3wpINgEODqDOsKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDj4OERY2gAxiQe87OuBPXBjBSXGnRJAblx/pLx00vg=;
 b=QZlDsVTxKg0Sx0oz/ExCT9Whf3nVBTRzdX8CxBvxEoHpe43w8Gy7BJWIEHF09HWFe6jM5oFvl+eZ6O8f0ESTv2YrrTNUBx7d6OMaaPRIvN6Oi25M84EbAcWQEjhQNQ7eJZvrXGZpO94eVeMz53g1GH4nQmgbkB9PLXqwwa5Myf5DFEp20lJsdSdxrmOJCZYoekdc57VIr7Ovl6SQObm0LeLdRikgXVcZuQJVlPFFZCj2oSa31z3F7h292H2Mj4cFU5F/TkaOPLXN+Ls49uOqCMqPSzn5j9CCzNanveGMNX65SnojQhRN5yYWY5R3C06GYe8ENqdL+BUZ+0oiSWSLUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDj4OERY2gAxiQe87OuBPXBjBSXGnRJAblx/pLx00vg=;
 b=DuCB6+3ooNwMFCe8R9H0lhnDKc0iMReA2whqH4pYRFwjVmpVE52bNjfawaz+cV3kWs4Sr/DkCnnk7ZB4vWCx7WY8Fpf/yXamA7HZseA2SJBudkOZJNjRy8GGDi46MbWPE5s/zwxJr1WGnhybspRib73FFg5vOaxojLwr0Efb5L0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by FT1PR10MB400295.namprd10.prod.outlook.com (2603:10b6:170:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:58:15 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:58:15 +0000
Message-ID: <2e6da5aa-4301-4b9e-b224-d54a3e0521de@oracle.com>
Date: Thu, 15 Oct 2026 03:28:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 487/497] net/packet: call packet_parse_headers after
 virtio_net_hdr_to_skb
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Junnan Zhang <zhangjn_dev@163.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S. Tsirkin"
 <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112919.435445950@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112919.435445950@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|FT1PR10MB400295:EE_
X-MS-Office365-Filtering-Correlation-Id: cfae0f7a-674b-47b1-3b3c-08df2a3e3f89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|4143699003|56012099006|5023799004|10067099003|261009221727099003|261009220027099003|261009221227099003|261009223327099003|261009223027099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	0Aqx1dRmgJW200U6dJLpbHp2qFg/yRgGlK1cR7L05DLv1rdsP4aLZHFwh53/XWGSN22k8TiBtjYvqA6b17qUvdQZMkPrgosHAApzO5257g0fPk/7pmjyz1qTQ6+1qBzCdf8ylFJeVxHy+Sa77iu5Q8abpZMFAqPdzGSPiXsGCcjvtrhXrWJkuA/f/lns+M4t9NdateZWbubPGAyV7qRIB3BOp8FFWA6I1GFQ/F+RdySAzCpsOi0+SH/wURZo+0HWid3i3XZ/Gtw3QLhvqD2kZo3u+7Zcb3s5Tc5MRUQjWeIoqOXDOa0yT5pPsmzxz/WSWAFw1UPtn80jEq/LWWCu5udYHJrY4X3aHF21XmJxzYNEnlGd+/ZpvZVFYvVRZb7bMAlv8wFgUBfF59ohfMUQ38Iz96dDiJTpkGtuj/E+qkelOS7Pm/rDREFXZlpHDTP7pkLQ4yGawdEPoADo5xhyN5Lj5o6kuqFbM2Er4ps4zwOGWjrbAkDXuVI1kbucZYr3cwvuudkZzh0Jb6vXDGnxO2WV7VbTm4TUwEpvUuLn9CFCSeK97YzCz64QcQR+yiejqtzna1mQXiBXiDxc7tEvT6B4+6ML79Al9IANg4VQWWXaX6zQONmQHQ1dZTEwvlRr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(4143699003)(56012099006)(5023799004)(10067099003)(261009221727099003)(261009220027099003)(261009221227099003)(261009223327099003)(261009223027099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S01MQXlTR3lGRDZNZEk4UlhGRUptNVV4VzZ3aWdXa2RxdXBaVVJUVUgvR1FN?=
 =?utf-8?B?RllKWS9HY2owZGo3VG02ZTlrSXg4UlVkU0ZSemF1UFAydkptNitRdXFWVE0r?=
 =?utf-8?B?ZEVEWTZ3QnJOb1NBa1p4Ull3anpGVlhqTzV0UzZWWU9DRzRqcGVrZFdxSUNG?=
 =?utf-8?B?bSs4MjA2WnpTNUlCNFU0MVZZWVFYMDlOV09iS3pBTXM1Y2w4eU54M3FlRnIx?=
 =?utf-8?B?VzNCcWtrZWx1endKeVh0anBXS3BvQ2VQZE8rbkIrYWxPN1FkWnliZ0ZoZFVr?=
 =?utf-8?B?Q3RqaEpGVTBWVSt0bGpDUlgyZlYwdTJDVWt6VkpxeFJxYmt3dGFGb0gwTUw5?=
 =?utf-8?B?eEN2eUQxSW1UN0YvdlB1YXFnbzc5TEtvc2MxMjk1NHVwSDFJRHVXYUtJWDc0?=
 =?utf-8?B?Q3NZSHdxRDg5N0tCUFVYWkNnbDA4QmNGa25PUGpJY2ZRYzFsZTNWdHIvZU8w?=
 =?utf-8?B?a0RoUk9ub0VHdHRLb1RjRkR3d2xlb0lDT3hweTd2LzdRQjhQd1BoakNMT1hm?=
 =?utf-8?B?amxxeVdoZE5mQklURnJtSnRodzU0V1k0NEJFeW1UcDljbUxFaHZCK2RTU1d6?=
 =?utf-8?B?Q2lrQzdzSzh1Z2NJZWI0R2Z2QTNTZUlQcFMxbHN3a3M4TnBybkRESE0rUFlY?=
 =?utf-8?B?UjZkdjZPNkRoQXRZSkEvN1FEVkc2Q1JyWmxHVlJtcHkyWjhWRU1KYk5oUGhH?=
 =?utf-8?B?QUNsWGpjZDQrVkE3eXZRdTBvQUt1dEs3VmRVUnl5a0dPZlJWdDQwcE1jbXp5?=
 =?utf-8?B?dVM4aUs3NTJnc3k3a1NFYjhqb3ZDNlZCajdJTjlmVlVqT1Nkdi9KUngvWnNi?=
 =?utf-8?B?QXlzbTU0bEtHL2hCeXFhRjYvd3gvcGRhMVVuTjBxRGJPT0lwQmVZdjdQLzlp?=
 =?utf-8?B?MnVlUU9rdFR6RHBic2pHUUxUTjIzUGg0ZEIwVTY4c2dPOTVaN1BJWlJHSXZD?=
 =?utf-8?B?WVhxWXhHWDk3cWNaQW1aRlFMcS9UWHczL05BN2pxTDY3OHhEdzUvSThGRTIx?=
 =?utf-8?B?UnEvdkNwaWlEU2tHZ2VYUVFyRXFDVnY5VlE0RGdKeXFOeS95NzN4VDZoUTdK?=
 =?utf-8?B?U0RWVnlMQ1lSeVBmVXZsVjNVNWo4SG00amgrQWVOTjdpTi9SN0RXTUdScjZS?=
 =?utf-8?B?ckllOXFCV1NKWjhJTS8xTTc0eXBoTk9GWkdOeFhmcEpSaWg5aGpNMi9NckhJ?=
 =?utf-8?B?UmtKdkpiNE1pb01PVXVPWEhKS0hrRVpyQVRNcExPU1JWTm9TNUpIZUZNYWdm?=
 =?utf-8?B?SUNlSkdualIvbW1MU1cvWXo4b1N4WHBUcjYwbzRkL0JBdjVjVDV2T2dReUky?=
 =?utf-8?B?ZXJ0aHBNOU9kcGtjbmUwYWFidUZrbEt0dXdCeWlqbnFqQnl3Nzl0a1creGhX?=
 =?utf-8?B?VTREdTF2dUZkTTIvQktWdWdSQW9ZdXdkYm5OM3p5NXJUMVgwbDd5MVkyZnNL?=
 =?utf-8?B?YXdqWnhsNWF3ZGV6aFk1eDZ3V3dFTnVlRnFvL25xWmVrdG9HeVJvVUdkK0RY?=
 =?utf-8?B?R2YzK1B4WUp1bCtnVitGT0Z5b0xGd1RFZzJua1lGRFlRK1ZYMXBJU0Iyb2RI?=
 =?utf-8?B?WjhlMmRheWNxaUhuYTFzZzhOdG5XY3VWWi8zalFaYmRTZjd3blVXZVJzQkEr?=
 =?utf-8?B?bGdCaUMrc1ErZkM5YlRMTER3ekFzdE5UWjlsVVRhTkFUMWQ1M0RUTVpWMlIw?=
 =?utf-8?B?NERGaGsxa1YxeE1ISExKMG00Z3V0QzVqRHo3QjRZZjZNY29McnlqalFYNDJk?=
 =?utf-8?B?TWdVRzErTzRvSHBFTHZkc3daMm93K1pWVytuQTFpZDl5Yms3WXlSZTNsN3BQ?=
 =?utf-8?B?cSt0ZW5TT0tzaTZndXZtMnd6RS94OUNXZW9McGZaam5xR1R5MjhJclNNd3B2?=
 =?utf-8?B?WUc3QllSTEp1REF1b3JYNlFvcTNWWDZYSjk0K3pHc2I2cW5PenRha2ZGWXQ4?=
 =?utf-8?B?ODFEOGlnYlFTaUVOTC80RWNMQXhwd1p4TlVsR1JDa1hDZitHb3luU3BqUTlS?=
 =?utf-8?B?dVhJVlJ2bUxYVWtxNmRTNS9SSFlGQjgrckgrK0s2eDF4b0c2SXFqYjVHUjk2?=
 =?utf-8?B?YUdjaGo1MndYbHpDNmRvd011dU4yMjZKMXJlcDY0cHEyb1I5NitUQzB1dnBX?=
 =?utf-8?B?Z05ua0d0VWhUUFRoQWlSbndSU2FhbzJyc0x1dmJNT0toMHZvZGdRTFoxdklh?=
 =?utf-8?B?R1V2VW1peFd1OUFyVitHNDZUQlJEeFNCdkxqY2dwcmRVV1I2bUtqamswL2hE?=
 =?utf-8?B?S3RHVVk4RU9sWi9hZWt1bFNQWG9MVmtDWmliR1FoQkt4dXN4QjAxK0NDbkRZ?=
 =?utf-8?B?Sm9lWHd0alBBZWlWSlRyL3VYeHpXOVJFTEMySHpzeFFKOVM0RFVBdjZ6UzBL?=
 =?utf-8?Q?oHIoGc6d4JYMu4WalbVYS5h2AypLqc1MdSu7m?=
X-Exchange-RoutingPolicyChecked:
	ViOEQrT1V2iYJr1ti+M4iTmJ0106gHOXWh/3upOUW9H5gmsazbW9M1SzIluvBtSNPDm/tuikIpmuIrz9nVmWpOAXh+LWEW82e7s/hjQptqpaflIz9l5boGqmUcm6YE1xWQobZvclFZZMIqCRd7r349vYTXOsx4cAfa7yepqvC8s0cWYOS+fMp8uzFuIwvTxs9kBmKL+bsBtV4Ils7hv6XQgA0MFIcM0h/l9KBbcluY3K5Lh7xD28gtU38qVNLtRdu+rvzByu7L3c4B5hkjq2slAwhH7R07G95oqn2HvPqsLd2nyTwKaobMOD/KLQpIGXDJDQny8TpvpgqVAtXoyjPw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SSWfgpdLfyGOtXHLvwL0WZP5VdS1Oy1Z0WNLEmkD1I1RF4uJ/0P7EP2PVrFBXXJiEZ5XwaV0jYF1UpfXdZr9nZmYuNJyzKbnXdLmqJd5GoB+4gEbhX0u2/XuYmhLVDMt6/+e1tvmzr9Sp+Bi4mNnAq1N5FpxVhxetkEf7ojes3jGTf4P1++Yr5c7rRt7p8BJ9W/5TB7WuhLH2wDbauSWohg2akVSEBUU/CEOgAxJoBpc0WspWR7kzsb4tfR5t77qkVutJEC8u4UgdnRma0/kIZ56ARTyv1NJPG214ZajCQMS7G0uIUJAvJPo/fw3WcUVXbRmhpARBsJM4q419cltgNrw7+vQ0v5R2MoClF9PljyG/oEx5sWElkj029hRfgk7yMFcdNXhYEN1MkDXELpLmH98NheK0wDAt6Wnk7r3GuSHoLoOWrnLTlCCiPccmnQFiWEX+GirAtiMkrLwCsBtpM5fYWmBWVYrDZ3sD7mzLBKEJJO1Lyuo7qnwM6c7r/fk+bGX8HL1duIfuO+BWRwX/sWz0e53MRZq5qQ+Yplmv7EJjWE9BKrl2reFbWHo0KbaQuk3c3FgHCHGU00L2RsAkqfHN5q+VJLN9yM+moBQx4k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfae0f7a-674b-47b1-3b3c-08df2a3e3f89
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:58:15.4045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Mcgqm5YpfBTSaaVZ3D42Nq5+T46Kmvum1SmIN4fnEm/v0leMn4MnJ8zTJHJ1JM/+uVHMueh+iOLiTjN20mqBv2h6emJwA+DQYcrECnGDQiRm26jrqsoIXkl3JF7XV26
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR10MB400295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140087
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acffafa b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=Byx-y9mGAAAA:8 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8
 a=20KFwNOVAAAA:8 a=LCrOrLumKtiQM50DVdYA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: O0Uu1En_6U1vAYAzWd_1xxHqjQxGcWLe
X-Proofpoint-GUID: O0Uu1En_6U1vAYAzWd_1xxHqjQxGcWLe
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NyBTYWx0ZWRfX9VFhq/xr0tRz
 +LuOb4h48GuLAHgeypI3AMBE5ttFGncJqNMbhk0JQ+5gkfHYiT1197MLP/Pd9vIC9/hShcqIDK/
 n/tcnsCt6gR3En6+RP+yCFupYRY8Ot0e6VRMrWdDkx4Rp6aHQatE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NyBTYWx0ZWRfX1mpfpUb3g4Ut
 xjhTyWMTGSMuc/tDZDRGiopGfssLBuc/KL0naCJdV68EKRxvK7Ic9wcQ8MDhqAUHeiQzfYNJ0PO
 Mqm79HGBTLZVNvqORTxg3QJUbmeTe0fwaifaS/+zGkbWgwR4+qzWmRlfIAjJ2DFslpuyXA0L26o
 jpVyo4NuLxR0FhyVyBs7IZfFMq2j9V9C5saT+5P9iEDf02PHhYzfdbuO+z8Lak8EYAx2vCPIUD3
 7RSF6OWgiwleWyjXEK/Efo74AGgYmqZMPK7ptgUIhQ+SF2eK7ZynBiRCxlcS059u2SY/gU+wFp0
 UDCiX0NAcez9X3s5JFwEzWcKG1BkiRZPDeNpIFCq11o65IPKSJIHhTg73zN1g38EwuUPpvwkCzi
 mbzoD36KSNrLC1QP8cmOGD9lKdJUrsWeTxnD1sJC7dKZzJ94jlUspsaaBCqmK/weMhqjBKNsd2J
 /qffhus1p5ui0slFFL3DtMydjio2+3Plm5RyjTd8=

Hi Greg/Sasha,

On 13/10/26 5:10 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Willem de Bruijn <willemb@google.com>
> 
> [ Upstream commit 513e23857a3a64fa73a1deb36a385eecd4ad7690 ]
> 
> SOCK_RAW packet sockets incorrectly drop VLAN-tagged GSO packets
> without VIRTIO_NET_HDR_F_NEEDS_CSUM.
> 
> packet_parse_headers() sets skb->protocol to VLAN but advances
> skb->network_header past the VLAN tags. virtio_net_hdr_to_skb()
> then flow dissects these packets, which parses the network header as a
> VLAN tag, and fails.
> 
> Call packet_parse_headers() after virtio_net_hdr_to_skb() instead.
> 
> This matches tun_get_user() and tap_get_user() and thus simplifies
> overall complexity.
> 
> Commit 01fdecc0480d ("net: packet: fix wrong transport_header when
> sending VLAN-tagged frame") fixed the same issue for the transport
> header probe in packet_parse_headers(). That probe is now skipped if
> virtio_net_hdr_to_skb() already set the transport header, avoiding a
> redundant dissection.
> 
> Implementation details:
> - Do not set skb->protocol to the RX wildcard ETH_P_ALL. SOCK_RAW then
>    derives it from the link layer header, as before. SOCK_DGRAM now
>    leaves it 0, or derives it from gso_type for GSO with NEEDS_CSUM.
> - Keep virtio_net_hdr_set_proto() last, so that the link layer protocol
>    takes priority over gso_type.
> 
> Reported-by: Junnan Zhang <zhangjn_dev@163.com>
> Closes: https://lore.kernel.org/netdev/20260821085722.24036-1-zhangjn_dev@163.com/
> Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Link: https://patch.msgid.link/20261007175816.3138556-1-willemdebruijn.kernel@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

An AI-assisted backport review flagged continued VLAN GSO rejection in 
the 6.12.y tip.

include/linux/virtio_net.h, __virtio_net_hdr_to_skb():

Downstream checks the outer protocol before dissection:

     if (!skb->protocol) {
         __be16 protocol = dev_parse_header_protocol(skb);

         if (!protocol)
             virtio_net_hdr_set_proto(skb, hdr);
         else if (!virtio_net_hdr_match_proto(protocol,
                                              hdr->gso_type))
             return -EINVAL;
         /* ... */
     }

Upstream 513e23857a3a validates the dissected inner protocol:

     if (!pskb_may_pull(skb, p_off) ||
         keys.basic.ip_proto != ip_proto ||
         !virtio_net_hdr_match_proto(keys.basic.n_proto,
                                    hdr_gso_type))
         return -EINVAL;

A wildcard SOCK_RAW sender's VLAN-tagged TCPv4 GSO frame without
NEEDS_CSUM still returns EINVAL before packet_parse_headers().
Rejection predates this patch; moving parsing leaves the intended
fix incomplete with the older helper. 44378d02c5aa ("net: always
dissect GSO packets in __virtio_net_hdr_to_skb()") supplies the
required inner-protocol validation.

So I think we need to take this prereq commit before this patch.

Thanks,
Harshit

> ---
>   net/packet/af_packet.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 048dc025b911b..834097e522b59 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1995,8 +1995,7 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
>   	/* On TX skb->data is the L2 header; anchor it for all socket types. */
>   	skb_reset_mac_header(skb);
>   
> -	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
> -	    sock->type == SOCK_RAW)
> +	if (!skb->protocol && sock->type == SOCK_RAW)
>   		skb->protocol = dev_parse_header_protocol(skb);
>   
>   	skb_probe_transport_header(skb);
> @@ -2666,7 +2665,8 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
>   	struct page *page;
>   	int err;
>   
> -	skb->protocol = proto;
> +	if (proto != htons(ETH_P_ALL))
> +		skb->protocol = proto;
>   	skb->dev = dev;
>   	skb->priority = READ_ONCE(po->sk.sk_priority);
>   	skb->mark = READ_ONCE(po->sk.sk_mark);
> @@ -2730,8 +2730,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
>   	if (unlikely(!skb->len))
>   		return -EINVAL;
>   
> -	packet_parse_headers(skb, sock);
> -
>   	return tp_len;
>   }
>   
> @@ -2971,9 +2969,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>   				tp_len = -EINVAL;
>   				goto tpacket_error;
>   			}
> -			virtio_net_hdr_set_proto(skb, &vnet_hdr);
>   		}
>   
> +		packet_parse_headers(skb, po->sk.sk_socket);
> +
> +		if (has_vnet_hdr)
> +			virtio_net_hdr_set_proto(skb, &vnet_hdr);
> +
>   		uarg = kmalloc(sizeof(*uarg), GFP_KERNEL);
>   		if (unlikely(!uarg)) {
>   			if (likely(len_sum > 0))
> @@ -3175,7 +3177,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>   		goto out_free;
>   	}
>   
> -	skb->protocol = proto;
> +	if (proto != htons(ETH_P_ALL))
> +		skb->protocol = proto;
>   	skb->dev = dev;
>   	skb->priority = READ_ONCE(sk->sk_priority);
>   	skb->mark = sockc.mark;
> @@ -3184,16 +3187,18 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>   	if (unlikely(extra_len == 4))
>   		skb->no_fcs = 1;
>   
> -	packet_parse_headers(skb, sock);
> -
>   	if (vnet_hdr_sz) {
>   		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>   		if (err)
>   			goto out_free;
>   		len += vnet_hdr_sz;
> -		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>   	}
>   
> +	packet_parse_headers(skb, sock);
> +
> +	if (vnet_hdr_sz)
> +		virtio_net_hdr_set_proto(skb, &vnet_hdr);
> +
>   	err = packet_xmit(po, skb);
>   
>   	if (unlikely(err != 0)) {

