Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009821E9B15
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741676723; cv=fail; b=gGkUgPe+pZlVUjrIrgEup94zMRBtaf6VUK0xvcqutuxeS1f3n61LWH1DOoWV6uWYqGUKoI+JW0EellGDK/RwDhGTDSKdti38xyKguE1r94cSFmqohqEzdKKKdE1pXhWbiN+xRz3wC0eVsrzMF03rKmXCtxV6E0xHH96WJxUGMYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741676723; c=relaxed/simple;
	bh=GdeeYbBILwyYrY5kPR9a0LVGmF+FzJAy7jdPpma2DLs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ROaxXv1YG7GeMcETn6h44kiaxKHhmJfncY0iCGOsM7/kHi8sy59KjeYy/wWB4Er3CI4VwPhXhq3DJLTLjiTvWWRwCdgZNU8v8fTt/oE57VcrZ2QbdVnEOkFmVxHZRRpY6jvh7zvK9isOco1SS/0CwveT4xOZBPfC5XfYCoUUAk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YeH9WcpM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qoi/M40Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YeH9WcpM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qoi/M40Z"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B1fvsD021400;
	Tue, 11 Mar 2025 07:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=H9zV0fyTnk4gboNpL2MOXqRcIMpY0gtfJtODzWYmH3w=; b=
	YeH9WcpMDIsxKHdM5TqqY8cUSF1ftQUYuxK7d3bmS0N2ab+Q6/XtISB++coXn3fD
	VWLBgxDJVNi9zqXelHiPARpbaseXYFhWtB1f6+CoMuQ+BpiALQdwSJdztYUhceFG
	2mxa97j+mjJEqgl8doYQoBW597g5bA9uvG7HpZCNlg/PvAPgKgN0y1jyeGt+k98H
	GZHCOQJGm6z7UY9LOMWLdMu/5hUlyMPgbZ8ue7EuWv6prccLUkGDpnVAzteWns2i
	hJiUs9PnopFYnwwQf5xUdihobTIxcDxk486jy1aHoDUFxywRuhCNqSVunroPhKFu
	0du5ilmnV+FT6M61iQFq/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458eeu46dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 07:05:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B5PPYC030533;
	Tue, 11 Mar 2025 07:05:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458gcn05g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 07:05:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHeVpPQ7YJ9OQ9WsdUdEAofBoBdiK9IcMW0vhKihmXer3ZhJAtB4GPDEqwG+9Mj2VnNaqabHTiUemenUQ3VFrq5AIf4IvKulKXx/pjUa5cqQ4WGm6e2JrC1Q+Z3Jsc77TFY/ToMtfYTQMLJy0FA1EpxfHJxpF6Deq2vhKQKMlxFQKvRVQHNytn1NYB/jCrbztbY1E8qPySq0fx3WQOXFmWnKhEfsNgj9OyOSO85AGf3jEggFJ6o+jH2wmkz8uKaDYw1GzqfOPuPtYizy/GL/XOslJVRpSpXMblwyMPsaRbL0duFBf28qcQXJ09PPNnt1u0gkFcGESQ0gRwBtoi36rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9zV0fyTnk4gboNpL2MOXqRcIMpY0gtfJtODzWYmH3w=;
 b=yjyWFr27NCEKqTomu3xZ3TQoKJ1csYXgTgpqx60yCUxGSwoukovJe7iJUfLhNv3hOfpcPFkBVve5neF6LPhkzAfElL23aUwHYxg6mW0YcAFsQ3dRfQC1T+Xz6olzd1cOmu2ivc3JFICAn9X5GeERLctp11qLdVe4l+AJW/IQ8uLCCBtjX6GyQJXx+JlDCLOay/hNhqCtp78TfHQ9cwSHJGntP5cngoah1Jch5cw9YuNmP/Dg0nqb1umWb+4495+UWG5+zi0ZlkCoKEo7Y+zOpfLsazTK/ATF/V2i/z8m167wwRQk5JnWktdu5I61KPCkcAkGqGWfV10xVOMdJO4HZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9zV0fyTnk4gboNpL2MOXqRcIMpY0gtfJtODzWYmH3w=;
 b=Qoi/M40ZINpMuGEORawXXjN9PuOILjzu2C/aM9e7qEidZnMX4xrLCDMxGRmItPtxFuOpzVgZcjolmf+Zbt4tki/dnxWkJhG9XspHeha0PHAMIRdaOrMy4EHiBsbvYvueSaUBS9/Dzauc4xR5lUvLIZXDjdaaOLDQjby/GmzfEkQ=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Tue, 11 Mar
 2025 07:05:05 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 07:05:05 +0000
Message-ID: <52aa1162-fb26-4ef6-ad9f-f65005625c97@oracle.com>
Date: Tue, 11 Mar 2025 12:34:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250310170457.700086763@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::11) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MN2PR10MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: 90c8f70a-8d72-4594-2094-08dd606b0d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3k1QkdMSGV4NlAxYXVYWHRXbXBzUzBKaFZvdWZETlV2UWlndXRvSzUyaC9R?=
 =?utf-8?B?WG5oalBkSldXSUU4bkMybEEzcmlwK1ZldnRQeXp1U2dGa0JIRzZ4WGQrdC9G?=
 =?utf-8?B?cU1ySTBiTzlLUktmdDJQVkhBUEcwd0thV1IrODhqY1JMSlE3YUJSTVgyVzN5?=
 =?utf-8?B?QXBIekNLRE14QjFhcjQyTjB1TU1VMTA5MGRVaXRDbUZkNUFCbXFjSENEM1lP?=
 =?utf-8?B?dUFMRFpoWWYvUGMxNmRQM0dTSjI2bGU5Y2M1L25SS05oNkUvNUFVRXF3REdz?=
 =?utf-8?B?L2NkTmxjSGsrQU11djk1N3dEVUg2bHpGTnowYUtVZUZnVXBLR0Y2UGhjQk81?=
 =?utf-8?B?VjZJWHBpWXNycm54ZXJZOWY2R3R0WUVCSDBtaFIybmY4dVJCTEM2M01mUmtq?=
 =?utf-8?B?a0tqdDc4TlhUY2srTDFhNTZGM0hKRjNMdE5oOVlYWU96OUNncW5qdndZOXNs?=
 =?utf-8?B?Y1VhVXA0eWpaQis4bzdzSFJtOGxERkduZE83MVRzNWtmRzE4TE9HbTN3ZE1U?=
 =?utf-8?B?WXhiZXc3VGhFYXFQbENnSTByM2Z0WG5XOFlQcmhXU3pnS2xCNXJVcXMwOEYw?=
 =?utf-8?B?QnhRRUpoWmdmcEpjR2dyakQ5TURMVmNhVGo5eXY3NUVIWk9lbU5uTGFoT0tI?=
 =?utf-8?B?R3BWZXFRam9xSHhHRCtxeU91dFYzVzcxeUh3NnZjQUgrMDNtdnJwemg1NmU3?=
 =?utf-8?B?Wk5kQVI2YllPVU9jUUxUS1ozeXZDaUxOTEl2dmhXbHZhQVIxTkVBTUUxR3lC?=
 =?utf-8?B?UDBVNjg1ODROTHYrYlVqZG8wU1l5MXNaZ2xKM0JwQVJzb0NtR0RwQzlWNGlv?=
 =?utf-8?B?VHNFaVpwdUxVa2FpQUEwOW5zbE1kUUw0OE4wUzZPRk5qeE5RTHdvcGVvU3lB?=
 =?utf-8?B?NVlqM1grT1dFVU1jdm9JM1k1OGxkMmFOQ1pXUDllbjhxUndJNFVYcW9ud3Zx?=
 =?utf-8?B?T2xoZUFXTWx6T25XQWQxNmFsc2xoNVc2TUZqbk1CcmdyUi84S0Z0b0o2RDVE?=
 =?utf-8?B?cmY3ZHllT1JoQkpFMjA1YkkxN1ZDRW5Wdmcrb1pYS2NGdUQwK05OY3pVUm92?=
 =?utf-8?B?eDVRM29aVHg3bWhEWjZMY2JUSWtqQTBNd0hSb1ZCUEo3WWRGZlQwbVdBZE5U?=
 =?utf-8?B?ekJDdDl1WTNzVFJqb2toR3B0THFqOFpjMUpITGRzTmYyN2tnZ0ZmS3M0bHhV?=
 =?utf-8?B?SGYyeVM2dFlRWGtoV0w5OE5ZMVFEb2RmMjE2NzhvWkxzZFRNLytkbjVQSVlv?=
 =?utf-8?B?Q1lKWEJnOUtnOWFpT1ZJWDNLTkxJbWJHNDI0YkdmVFRwYTl0VGRlMmhHNGtC?=
 =?utf-8?B?MXY0aWhKWmV2eFFaVjNGQ3hIc09EUU5XV0ZtRmlMbDIwQVRhQUE1US9nbm9T?=
 =?utf-8?B?bWY2T2pISSsyUGdwUTdqOU4xQStGalh0V1JTbTdKUWgyeWpuVlEwRTY2UTFV?=
 =?utf-8?B?eUs2VnNGdUoxMmhxYzRMNlpNejRzK25CU3BOM0NwL0lMMW9hb2hMajRuTVF6?=
 =?utf-8?B?b0R3ZHJUWVdqaURpR3krUjdnenU3N2pnNHl5R1kvQ1NaaFZXdmpmR01qVFU2?=
 =?utf-8?B?cHFIS0JqUDRqbXJrWW9USU1Jd3ZRUko5R0JqWkJoMDUxV3NaclRneU5vSk9W?=
 =?utf-8?B?SUVoMnFIWTRXNDhoc2hyVWI3d3IybjVGRnRVV0wwdzBqcmlndVZ0QTR6N09s?=
 =?utf-8?B?V210bTNST1lQa3ZWSCtTRTdZSUhNSHVGNVRSN3VBM091NDBFWDJRM2I4ZUZw?=
 =?utf-8?B?a2JOcEd5Q08rUm5tb2tvTEpNSlp5WVR0VUErY0MrbXdaVzNUQVlzRWNOdlpY?=
 =?utf-8?B?NXNaME42RzFiNkhBY2REdVpPVFpsditlODdIRXpOMlNlZno1ekZwZi9HUzBV?=
 =?utf-8?Q?9arx1URVmLxYa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ky8wcG9ZVyttc0IvZnMyRzVtU1oxUUhGRy9mcnkvUVhvUDVxa2FKejJVMmsr?=
 =?utf-8?B?MDRuODFDWkwyMUJYdXptVnBRT2d5VXdPUEI3L1lvOFBtSDRiNENXaWk1bURy?=
 =?utf-8?B?d2U4R0RkZi8rcDhIZXZkOThYelFmSWFjT0FtQmNyTHA2TDRlcVdWWGY5cWhY?=
 =?utf-8?B?QkRLTllEZzhVMTErbFptSmpkb1ZXcGc4dXVUQkorVGdRSjJuaXUvaFFrVXdN?=
 =?utf-8?B?YVJ3cUo1UFM4RFd6bCtzOXo2MUFYZXVjOUVzTlhNWUFka3lZQjNQUlkzRDJR?=
 =?utf-8?B?MUZzeWoxOTlvNXBOVTNPeWgvcGQ0SW5ZeDl0SnM5YXRmM0sxMEFFeXlqSklD?=
 =?utf-8?B?Mm8ra0JsaTJPTjliZmpBRUppUElxMXpDNlZFSC9kZFFZbUhvc1B3WkRTWTFX?=
 =?utf-8?B?c2tIbkdDMEMwRzdlbkZYUU0zYmpIZlZ5SW1PcytuUUQ4a2RkTjE0Y05BdmFa?=
 =?utf-8?B?cW40S0tySS9kWWtPTlhicUpqTGRPeStueFp6cVB1Y0ZKbUFFZ04yS0gxSFR4?=
 =?utf-8?B?M0p3dmxBem1EUGhVaml2ZUxja29acTBhMW1MVUJtbzFIaHJoK1dZL1ZranYz?=
 =?utf-8?B?UXNMcXM3ejU0YkZFdHJLWHdtNlczYjNVOGNBemQ0NEE1NmZCOFNEMVJGV1c2?=
 =?utf-8?B?YnFDVENpZG5xdmgzak5hWUNpUUdEY1Bia1lrN2Ura2k0MTJvcWFkUU1JWHpu?=
 =?utf-8?B?WldvNzRtV25QVHZkRU5wRHZ0S2FPMWM1Rkl2Rkd1VERrNG9lc0tIWXkxVHJu?=
 =?utf-8?B?U3JFdS9nL3JqM2sybXBrU0xOeno4TU1EQ2lFdHFrdWxvcUk0Y2txc1NMUDB4?=
 =?utf-8?B?RXYrREwvVVpPeG5BQ1dubFRabWJRVDM4cXRyeHdLYmM1YVpvT2Z0YTFLWmtw?=
 =?utf-8?B?cml4a3VjRTN1cVROUjBueEtrY1M4dmQvNmV4bHFBSGdOb0M3K0MvZXpvSmYz?=
 =?utf-8?B?b0s0ZHl4Z1FMMXp5MC9yTWNoVGtPZFlOM2UwMUliQkdybG83cVpHSm9DK2h2?=
 =?utf-8?B?SFJoUnVnVUhQYktGSmdKcmw5VDdzb0w1Ym90RXBocnFFL1h4ZEJvY2F3a2xY?=
 =?utf-8?B?V3lKTlUyZG5lRWFNNTBxRndKbFAzaEdFS2k4Nkl6QXpEQWc0UjhGaGZMN2ZZ?=
 =?utf-8?B?R2F3b1NyQU5QMmNISis0dGlPc0hsUXhmRVAxZzJUM29KbkpQMU40M1ovZjdy?=
 =?utf-8?B?TWNKVXBEL2VHaGRpY0hXa05uWDJPZ3ZCaE5NdDlCT0MxVWxwWGtHUTBnVkZz?=
 =?utf-8?B?cU1nYm13UExjVjJQaVYzL1RSV2I3NGdCQmFnSjhuL2N5Y29jTmhZWlN1TXVp?=
 =?utf-8?B?RUVNT3BlSVpidDBNdUV1UUV5TmxzWTRtQzNGU1pSSExFcVFqZXVlRE9UbXV4?=
 =?utf-8?B?NnRjVkY3cjNsY2NQK2g4RGJ2cjFjVHBjOW8wV0lnRnNzNEpQcFF6L1hPN2xu?=
 =?utf-8?B?WlNQc2YyRTF4OFJqRDlkckNjc1EyZk9vOExNNkUrR0t2Y05PUzY0b29nbDhu?=
 =?utf-8?B?K29CZ2hKNTZneVY0dHRBMk0wdnNKNThjejVpcWJ3Tk1jQ24wNThJcjRLRnQw?=
 =?utf-8?B?ekRGR0s3dk1WenQ2UHBCNnlrWXR6a0Jodk5Zc05hQU9mdFIvUW9KVHpEd2Yw?=
 =?utf-8?B?ZkNIcnBUci96NUVvWWNwU2l5cG03Q0tMZUNZd2lwWU5vTFpGb1N5VEpsWXhJ?=
 =?utf-8?B?TEwxZzVxZEdNMm8rNmVUWlgzYWpiRnBQSGRDS0pQRmlTZnRGOEsxZnBPTGRU?=
 =?utf-8?B?TVhkOGhKaVQxYVcrSS8xeHhsME5VbHRKVTNIVHJ3REJzRjdWOVVobkFtTkE0?=
 =?utf-8?B?alhXdlBYVllSZDV5di9VbVY5OUlNS1JUQ1VWTHBNanBoSENCeE5WWU4xZFp1?=
 =?utf-8?B?TW1EYnpnanV0NUdxWEphYktkSlQvQ2F4S2FFUDVEamo1ejVvbm5pMEE3QlNY?=
 =?utf-8?B?MFlxNGE0UDFMZGJUNTRTTHZjSFVzb1VxbnpaY0NQNTA2bWY3M2tjRVFGNk0y?=
 =?utf-8?B?YmRBWmU5QzVsOE84TEk3QWF3WjVyN3FoTkMvRDJTOFhtc1M4eTczaUR5MkN1?=
 =?utf-8?B?b2hTRjcwTlVRMno1NkZMSEVJaks5Q1I5VUUwK0I1L0p5TlVuUDJjYzUveXc3?=
 =?utf-8?B?TEthbnlUb094Q2pGQ3pDcWtoblRsd3MyS2d5TXB0SlFtWnRjMjA3MGtFMTMx?=
 =?utf-8?Q?GEzbkzI8O3vhiioBDab6rvw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c9C2JN6YGJhLFqLKq+lYW+eAxF6ceo7H8rV4nTvvmhWhQoI0jsfE34sRCxvoTY2RLLUv7YvjPr4//o4ZdWIAleOIrUpZu5ccPf2dn8O+q4xTAyAaBeNqH92ERcqkLg5Lpr+TAUxoQaAFUXGHDpHtM2TYLNlGfQgK/hG1gMxxtYDbIJcB/ALqXYp1aRSt9N9QYQEfgQbxw6zDhsbPvGs4Ko8iotprZnkRVMGXra5CNYDydvmheB7ggd9nHMMJtIZ05U46pyWmx+w7kFzrbVfMYC6cA2An2mIJGEb9zmqdrtkvqkWbrZQGP+WboyUNXH3SKvC4nU0maEb8SDpF++qF5oDBewng7Bq0X1U9bjmWlWRW9nvCK5vWMllbmkDfF0H+Dh1TbdhNzjB9b6zOQ3e/MT3FRvkGu/rIkpyoiK4JbsSHXxT9QhAAiXO7JS/xm4MWBJsQ5TOQTF7ZzcolKbslmadmeSOwrbj23R3PJ16WyS1HuBgw7vBcd54mL3aIgbBwMKLbdA5EDuL5iP8cc1AX7q5zKO7Ar8/MBg0/WLpvDTnJPo6bsW2PnavoLNtdgKfd5wyIZHZ7b0OupjRxYSLf4u31Axt7Fy2PV+qut3kFD9E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c8f70a-8d72-4594-2094-08dd606b0d1a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 07:05:05.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbNiw4E1U5NKK7jY9yqURK0bqP7e33JsAzVb6b9TAiO99ozESvIkoOIemXNi+O849cNtsieTJIl5TXC4YiQJkX4PolAiuoCZGSuYbqyvoSje0ww0VTnslSnXivII5MF9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110046
X-Proofpoint-ORIG-GUID: XIRFVtv5v2OOPgad6p0j6Yc_Rb6IHsZ5
X-Proofpoint-GUID: XIRFVtv5v2OOPgad6p0j6Yc_Rb6IHsZ5

Hi Greg,

On 10/03/25 22:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
