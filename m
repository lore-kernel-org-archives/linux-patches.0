Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949F175A94;
	Fri, 19 Jun 2026 12:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781872754; cv=fail; b=Mc2nUpP7yIww/uEtkjE4vCy8q/Jlv/WKpzZ+GCHUzDWD5MBvG+MYrPpdaRDgyIt9J8aTLaFJiscXpTyqlSaj4LfFeN7gR9eQ6eOgjJNZ6/O++yfvGTHOccd2IwHRCGuLr57hIllxe4M5ujgDB4k68nYaKkmHiIyi9+GjFg0N3GA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781872754; c=relaxed/simple;
	bh=nhTYwTrywwFhucOSIJjvHISLGOl8ziUWSQh2Hnn3pNA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JujuCWuAJKVg6RJZ0v6jOmF82m5vQ8v6O8fE6kXP/L/ketQ8Xmmkvd+ATBLLAzVeEDgOQmq8wqlSeqfhdPOPFpcicKCeRB5ikuN2nCZd0hjQfMQYnD15G7Mf5rg4myXtAXMaj2VKKNMlI/2+Sk0U5AwCxDlDbRamUUfffyDv9aM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KrtkcNXk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=POJlQjba; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KrtkcNXk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="POJlQjba"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J3R1oO1929986;
	Fri, 19 Jun 2026 12:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lmDD4R/xrA85NYIE/D1Iin38agMWtMDbwkRB3FML9LI=; b=
	KrtkcNXkP5axLTDSpZuNTvVX9nX9B+cz5lac3OwyGI+0LJtiqwGSKZrKbdEB/GWg
	dIge3lBVj1g/P3czxc/mOKmZWDpy2qWzt0QiDDN9g8Xnn+MUpevkQNyDSGmWah6w
	d1+zIXfmIY2zM7O3+2ktRWAkRWLW/zQOwC/zLhk/kziVy56Unp7qguDWVLQd2nX4
	V925RFSQ4/Fx1VsB4oibUIOvn4ofVL2cdw/N96rIWQ5u9gEnXLyorQnaNoZc0qJA
	I/zavR7klcpGAdhDogQNXqXcsIxOcscGkq52WnarRSI0Ckvekx9kkn+/gO+kiGt6
	3RwaejLro882NWLN9JmltA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euefum2fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 12:38:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65JCX8nd026313;
	Fri, 19 Jun 2026 12:38:53 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010055.outbound.protection.outlook.com [40.93.198.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14g1qgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 12:38:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbkkxf7ynCEQZJGsWk1HTy0pZTp1EZKqSWfvm/R0sRjVFhXLBMc1susjv3sago8Gx6/5zYXSRUyrkTnxzynHzatzZdRP0PTN8Rd4lOgNNnYXbJSmWCaNe09yOYHfuJQQ6hP2PqSBj04dfKLQFQvIPMAhCVMCrPrhnIgbG67h8FZnlb/qxkmjrjUCaHBj2IT003IbpEjW8eapqmjVivQ9U/4mu9+Qh4X00XMOEHw/1dyud233o0wTy/c2o52iFUZB1DsDh42gU/cyPPN9tsslNzWjJ4U7FyG1Lv3rUAuLTKRwoj02ztUfG9Aq8uAs5ute0SL4TN+ErU8x08/ZLfRf2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmDD4R/xrA85NYIE/D1Iin38agMWtMDbwkRB3FML9LI=;
 b=WD3tU/RGg0UHhkvm6mCJhc4KAuckMTkyZBirebxss8QxbHlcW1bhutT+IOn3IKbcUwM1zMrE8m7Rvo3YO6bnjdVz+lDton0FU6UNklpkezad2jAFSp86CHTgL7azlljlTFEBSM6BWYLhNvRz45VAEep/tPyzqWFA5ev0iWupmceyfogRsKnn//YTA8bdC11O9jGrj+wrSYxuRX2NNsPj7S8hmfhAiFbNktIuvi4RneMiIaQAnSfXSeFsePLFnhZvuTTeXZna2wkSLglyR1D21ijbOBVEC6mE2s/sp8FAUUopkm9MNk6KBSN+4l+HG2wonIjjwf5eD/T8Ap5pUP9/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmDD4R/xrA85NYIE/D1Iin38agMWtMDbwkRB3FML9LI=;
 b=POJlQjbabEYeX7/JQ+Lj03HZeoqrZLSj8BNYZssw0ERVHS5bm2wok9qwowddAaL/N5mcmL6pOxk1sfqSwV5XxzYjeASaujZVdU56MZAwTpb4zFudxlhHQtQS8rnJQQ6IvD4ZT/yMuzl4d1dG+O3JAGqct6XMdIUOvxlh0z9e8C4=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH7PR10MB5700.namprd10.prod.outlook.com (2603:10b6:510:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 12:38:49 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 12:38:49 +0000
Message-ID: <d23a21f0-95dd-4e0c-845e-2a54c50f44eb@oracle.com>
Date: Fri, 19 Jun 2026 18:08:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 323/411] spi: topcliff-pch: fix controller
 deregistration
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Johan Hovold <johan@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145118.324999322@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145118.324999322@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0283.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH7PR10MB5700:EE_
X-MS-Office365-Filtering-Correlation-Id: d57b57c1-9544-44c5-8dea-08decdffb648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|4143699003|5023799004|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	kjE7bj/ew/vP+crdKFOT1ipeqdxs6GKdfoKySD6NrxIDKDRMFyUHmK9vgy6ycuZ4Rontz9xXW1maHqQ1HPATQdoOpsGA8Bz4+nOgITtb/bBt4flfmhoB0nhK4oXt3WMCSLUFPe1rVrdpMay59ZQw9GN7y+K/eZxtOxaPkRMstzQqWClVO7ssAy/fqGLfe+zC26xLgRlWHtwLOgSFxWfrdLZMA+ybCBES0gcuZFI6Q9xqx8ju1ImccpANZb2r3gS6MoPIToF59zS/MroPxRSh0ev4GesqLxo8igKfHYCroOGnht4yz908aYpcj83mFE1KrY4M5rBkmNotEJXs2hKzKzNVDGi21/nD6y/30O/wUeTAMYSnoogU6GCkGHvb3PlwgLHnB2XSAEs+joSzeZpwRrVU1hyPRChJnRHxAG+C6WoQbBFPio8KuSSIn+TfDWfzD2J0jltKstyVbeP0Z/VgfVfjwu8a26vTo4yhPNTPr5EtnccRVDnOTHUxBkTh4SQydYF4z6+1XE6v6YQZJuB6jzxN9iwhPtB08cKL1MBUWFninvFHiGcZcULzb264yUt23qerAD5j0WyV608vyZLSUYLXHAEOfFnUaocJjjllOT/a/w9n7Iyy0mTzRSYRXq3J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(4143699003)(5023799004)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFRyL0wzRkJXcGs2Z1FLZXBvQVZFWFI1UDMxVnhJbHY2K1BVZkdlY1kxTXdo?=
 =?utf-8?B?QmNLWnRXZWE0VUs0a2JDNGdNQ0d6MXV1b3FoU2RQcm1vdFVxOTB6Qzd3eENx?=
 =?utf-8?B?Sk8yODJkVnMyWjZZY2Y0bmJ1SWNlVmQ4MGZ5N3VoUXFxcFdLUDF6Yi9RN0M3?=
 =?utf-8?B?d1ZQQ3l4OFpSRjhrc0RUUWsvWWpZNDJpZnRFR3ZtaVhPRm82VjdTQitZUUh6?=
 =?utf-8?B?VHhQV3hZT3BIQndRTDBPNGNLQzE4Q1kxVE9RRytHdDJlUGNIeEV5M0JkdTl6?=
 =?utf-8?B?WE4zR0lYeExyajRMNDVMUHlTMzFYZ2EwS1p4YXM4cy9naTg0djhWY0xtN1A2?=
 =?utf-8?B?em9PWFdnUk9SSW1sWFdvQVV3cXg0SENJYUZKWUxKSnpySFJqS3JJa0RHVzMr?=
 =?utf-8?B?SEdZYkg3TEF6OEhiNFFBbEE3STRZY0lQNS9EK2EvaUZQMm1lZ0svcW9wUE9L?=
 =?utf-8?B?Y1lCWkJjMGJJUjVKWjRTNWIyRnZ6Q3N3T09lbXRFZ2dqMUdpSnB1UXY2N0Vo?=
 =?utf-8?B?Qk5pM1dHc3kzNHhJcVovZ3VxdSs5a01zU01mcm5sckx5dTM4NDZGUm9hOG52?=
 =?utf-8?B?NW5rakNicWhlemhPams2Q1pKOHZvaHBsTkQzeDh4WSs5OHg0VVlsdGczd2o2?=
 =?utf-8?B?bTZZbkJzeDRCM1REOG10blo3NEFJamlBdlFqTnYvMElrdzdHMGNPNjA0bUIr?=
 =?utf-8?B?Q0NEQWhpVGtpcFdIMWREMGhyWmNhTVVsMW04aHA0UUJETXQ5NjFpMWpjdTJX?=
 =?utf-8?B?QmdFSlRxSis4Q2xnbWlHWE50NHlZMjAxWkVOY0x2K2l6bTRJck5kM3haRThL?=
 =?utf-8?B?T2tJdytkRFgwYWRadmh6b0NkQkxxc3lsT1RFdmtWTTFvVk5LVWlHUkFFaEpZ?=
 =?utf-8?B?eFMyMWc5SlBPVEE1eHduV3pDcDJxZU9VOCsxT1IxVTV4Qkhva0hIWDBWMnFL?=
 =?utf-8?B?aFRPNUFUcm5wbWxUcHk4VFR0aVVRaFUwVFIrV3RyUS9nbitOelNmTSs3Q0g0?=
 =?utf-8?B?d0lEalhLK2lkWjcwdkNFR0c4d3o4cWJUL1FRZjltcjYyTGR4L3l6VzR3b3VH?=
 =?utf-8?B?NU95a0srUDFWTG1JblZYSVBJUDMxSmptOW4wUUVGbXRIWTlDSHhqenRBb3hp?=
 =?utf-8?B?VWZzMEQzbFlZZDlaSDJLa3h2LzhnZUs3UWljZzgwQ3JXdnlnc1NNVkdMQXpC?=
 =?utf-8?B?QlowV29BRXA5UGtxVmJMZXlnbUxORExIaW9SZEhjSXUxVEQ2dmVwVXRUVTNN?=
 =?utf-8?B?Z3JMUWFuSi96cHZMOXN3LzlxaFpHTElJeXBaYWhBVWJ1K1Q3M1RERjQvbU85?=
 =?utf-8?B?bk1qa3FDY1E3WUROVXQ5eFhrdGRIWE5HN2U0MjRvaXIwQzI4S3RIQlJIVXV3?=
 =?utf-8?B?VHNJTmtCV3laZkFLSkVNWE5ELzk1MENKYUt0YVNmUE9OZ3cyWE0wbGg5d1RR?=
 =?utf-8?B?UnZSSzB3WHp0eGNuckhKUU9mVEpGN1oyNG5tOW1VZ0Q2QTJEZTlVTlJOMjNm?=
 =?utf-8?B?WE9CMTdteHlCV0RxdHRUV2NTU040emt6alpIdm9DVWkwVTR3U25GclFvek5w?=
 =?utf-8?B?VnIwTG5NN3p2WWFvd0djVTN0L3I3ZnRyZE1Gc25HVllvQWNhNitpazNOVEpr?=
 =?utf-8?B?a0lMME9WbzN0SVpoQUZWemFSQnFQN0RuZlBrU0E5K0d0QWRzU203RnErNmJa?=
 =?utf-8?B?c2pYbmJIM1RFYWJIb2FkN0hsdXBmazV3Um53SmVUN3lKRVJyY0FPVzRMdDh3?=
 =?utf-8?B?WkF5RXpMR0xkUnNMa291ditTSlMra0JnV3c2N2grY0NrMzB6bFlYZmhTVEF0?=
 =?utf-8?B?b0lqU0xJUDkzdkRDeHlpV0tKQkZSczRadVBXOU1jMyt5REJ3eStyb0U5Mmtt?=
 =?utf-8?B?T2g1ejlwMFZ0djhwV0lvVXdYckNtTzVnSlJIbHkyYzB0dmozYkMwemtUajRt?=
 =?utf-8?B?aXdlbGVPNjRPbGVzUkU3Q0oyNk53bmJkdU9WeENQY0crblAzWG5ybG9jY1R0?=
 =?utf-8?B?R3krQ2YrbWh1L2JHdlJZbkNtT2dTZlpKR28ySXgvZGRnci9WU005U05EOVFV?=
 =?utf-8?B?em9sanpKWnUxcmtYc2NuL1lZR0tWWTNGY2d1YlhrQkdZd3grdjFKcWt6elJX?=
 =?utf-8?B?eFRQdDU3dXEydGFHR0ZLVTZoVEk3UjAxNWxUaTYrZGxraFRHNXNJRDhBbk1T?=
 =?utf-8?B?L1ZyUE1TMkhpMlRWUnJ5MzBjTFNqcmdJL1Mra0kzWFZzcENySE9Rako5dXZi?=
 =?utf-8?B?UnpFdFVsWDlEZ2pPbHQ5V2NkdUU0WWdZTk8wYUtBOVY2cVUvQXZCNXRjMGRP?=
 =?utf-8?B?cVRWOGhxT1huaCtSRDljRkxJTWxrSFhqOEtwWG1RN2xCZ0RSRUxXeXFoTm41?=
 =?utf-8?Q?Jh1kaerGI6rUufykS4X7646XoM1MWH1MLa0eP?=
X-Exchange-RoutingPolicyChecked:
	XCUCTjw1pLtngaygXUGMlm6eWo2t9q5tPlwuZrv1J9AqFn0+yXZx2/h6wWXI8ENPpQNnHFw77Mco1desd87DJdGPHzOBxXLKa46Z+THj89lxkxlH+1FcLVFQltt0VDn5O2tdY6mX5md0FmDRw4tfxx597CjwBVnpkM7OiW8Y7yfaXcxG/FoitfNnJS9MhmIGrjgo3r1DqAccAK+S6hrodYVssolKWSdtxhCfe1RLRmDsqkFzaiE7/UyTaWVG2X0ek5vnrbJkzGq1hGuXXyT3V70B7FPxmKziIX1+GwvCwTF/gZOlzeki8IzPqkggh9oM6VrrmZDON8ekyH2Bg6hwIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Eodj0Tr7X+IXjTf4yL2dg42SYb/2od4Y1h3A1YBghKiXeVhCyYBIWBLABofl0OouQ21dDxg4Wqoet4JIap53vE6d7sJR07zE73k5gzUuUmqJqdWgZp6w8NZVR7ZdLIprkjsE8G23kAm6cdQ64cs4Cubd3xazVDOCnBAMp5DreyEuHzsSAcafQjzG9ZwEAApZtQxabtF20XtlC2YkvvGxsBhYOBkvlUBtqx51fLJ6xosus3ZuVz/+bMNgs1BJdZRiYO/xLxd5W5VVuIDv0cgUZcr170dhiNUC0V7NcVf0IsdUI9mpwEF7IX7HK+cIt6aIT29pPdTRsA5N1vuzal088TeOJo7ZuLH6yUuzp4wayqa9Eu9mHB77zm2JLj8iCetM97zKBdVeODXbC9WHabVhrF1w/g2d/lUPsxJXCQvrXnnOsIoby5dOdmYswZ/QpDKrxfBphZV2HTDl1KnZQYwbYQvQ3SoQR7vkpU2fOsKm0NbhKBgCFhw9UpXXRnmCDLoBVxfcSsAL5VAKWlo8gLxbb2oElkTWQgYyZmDtKvavx5q/Vv6d+gGz04K5GA/I/D9q3CfvNrL9j4y/jRcBip4vNV92i7MjKwKoi7inq4z2xos=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57b57c1-9544-44c5-8dea-08decdffb648
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 12:38:49.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvUVAAeOmrmZ/X0PYMIAkuHMZaIkoOvPwGiOhRRBN/XgDpcSNbQerliFA1domGRcbHexaK66Hz3o4RvlV6Pp+0t0k0onATFrXS4h+dT8OpUef84Si5vGShk04vMFdhxa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606190118
X-Authority-Analysis: v=2.4 cv=S4XpBosP c=1 sm=1 tr=0 ts=6a35385f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=IYcPYRubAAAA:8 a=ag1SF4gXAAAA:8 a=iyz1EoM0Ub_4r-k4ITUA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=xMbVmfqwKv3eApQLKNpX:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDExOCBTYWx0ZWRfX4qbUp5u8LY9R
 c4OunrPEktEJcihQqDDmWfhlyfvosbAvkQuyAe/L53noBo7wQmiuxUVeIyxbw3Fhtslava3vL9A
 +1bzmcBK5FX/y4JFJk0TJux4EAi4ldrZ4pxzI+ev9N8Uzj+1CMP9
X-Proofpoint-ORIG-GUID: 9plWhNu2ZeFLXSqj2VVQgy7H647LsU3N
X-Proofpoint-GUID: 9plWhNu2ZeFLXSqj2VVQgy7H647LsU3N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDExOCBTYWx0ZWRfX4Cm8HgqsiHxq
 iDXzAk+iq4o4iarCMR9FYwCLAzMUBovJTjz9pEsy8/JyXxyBh7H+cTMClzLHBzGkBo/U3HDQfq+
 QwGSJ69+JEk71j0/2gyJ15gUQ371AIRRpTPTvWLxVhkaOg3Poh60AhPdpGOlTn3+xZcL5SZxlf9
 lf7cW2jct6pazZ2PojqX/V6bo4jyEoETlNa/xtkJo1RxCdsZSL9RxQpNSDL+7iTYT8/Aw8zu/8+
 wxDo4zSQDX7OCabxfqab6Tu0cAzwUxyeIbZMXUs1EOM8UsMKvorQCnQg51DdEw6vkHp6oyc1s/t
 tCoDE6HCwhHIrE5F9uviSQfgpvNZEcRoei0PEikx2/0ruhwAOMbStfshoCKba+8kDaorukYaLyq
 KrsE7FnYoLyoasJ9xqpV6swH7lytLLld353+E3ejHEbt4xZTlmFKq397sQxFIMpu3bPwDEdf3V1
 FUPnxk3ZnS6UsO5EgMg==

Hi Greg/Sasha,

On 16/06/26 20:29, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit 5d6f477d6fc0767c57c5e1e6f55a1662820eef87 ]
> 
> Make sure to deregister the controller before disabling and releasing
> underlying resources like interrupts and DMA during driver unbind.
> 

^^ let us remember this -- deregister before releasing irqs.

> Fixes: e8b17b5b3f30 ("spi/topcliff: Add topcliff platform controller hub (PCH) spi bus driver")
> Cc: stable@vger.kernel.org	# 2.6.37
> Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://patch.msgid.link/20260414134319.978196-8-johan@kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> [ renamed spi_controller_*(data->host) calls to spi_master_*(data->master) ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/spi/spi-topcliff-pch.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -1450,11 +1450,16 @@ static void pch_spi_pd_remove(struct pla
>   		free_irq(board_dat->pdev->irq, data);
>   	}
^^^ let us remember this.

>   
> +	spi_master_get(data->master);
> +
> +	spi_unregister_master(data->master);
> +
>   	if (use_dma)
>   		pch_free_dma_buf(board_dat, data);
>   
>   	pci_iounmap(board_dat->pdev, data->io_remap_addr);
> -	spi_unregister_master(data->master);
> +
> +	spi_master_put(data->master);
>   }


I ran an AI assisted backport review over the 5.15.210 queue and then
checked this one manually. I think the 5.15.y backport keeps the API 
mapping, but not the upstream teardown ordering.

Upstream 5d6f477d6fc0 unregisters the controller before the local teardown:

         spi_controller_get(data->host);

         spi_unregister_controller(data->host);

         if (use_dma)
                 pch_free_dma_buf(board_dat, data);
         ...
         pch_spi_free_resources(board_dat, data);
         /* disable interrupts & free IRQ */
         if (data->irq_reg_sts) {
                 /* disable interrupts */
                 pch_spi_setclr_reg(data->host, PCH_SPCR, 0, PCH_ALL);
                 data->irq_reg_sts = false;
                 free_irq(board_dat->pdev->irq, data);
         }


In final 5.15.y, the equivalent spi_master_get()/spi_unregister_master()
still happens after queue/status teardown, pch_spi_free_resources(), IRQ
disable, and free_irq():

         pch_spi_free_resources(board_dat, data);
         if (data->irq_reg_sts) {
                 pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
                 data->irq_reg_sts = false;
                 free_irq(board_dat->pdev->irq, data);
         }

         spi_master_get(data->master);

         spi_unregister_master(data->master);

The spi_master_* names are equivalent wrappers for the controller APIs 
in 5.15.y, but the call placement is still the old ordering. That leaves 
child SPI devices registered while the driver has already started 
tearing down controller resources.

I think for 5.15.y we should fix the backport by moving spi_master_get() 
and spi_unregister_master() before the local queue/resource/IRQ teardown 
in pch_spi_pd_remove(), thoughts?

Thanks,
Harshit


>   #ifdef CONFIG_PM
>   static int pch_spi_pd_suspend(struct platform_device *pd_dev,
> 
> 
> 

