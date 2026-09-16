Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9593EEAD7
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544746; cv=fail; b=etEKOESgL1qYyU4LVF94Fw5Enh88BUwnAZ2zUWDZmlJMB8u2CxxI0kQVLsUa6ZSh21AqGqiXRnCjc8p4kE2Nf9bs5lzi/vprz5hN5zTvU0BbYIbF82oEksXUw3DjGvpW/HD73X6YmHaaQwqLTt8xvatqHamlzDvsTIJp5G09LUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544746; c=relaxed/simple;
	bh=e/hVLng+IVVuvW5sMgxJanBSrXJz14oRu8WJYvjxwck=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gKpO9FDwXT/U9tYgbdFjXaLhf4aQmMlRVTv7jVgWF0HBFGcuCv4FdFvdZEcUhA+i2zupb3xgTsYl7DQ01nf/0sBQ3hFnATUXfIRsEgMZfSGO10MTy7Ta4Dj9MT/V654WDzRe7WPL6iPC1oLZzS3vP2af8JenuWj7xPmG6U2u9qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aixvcjfj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nKHzWJvb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aixvcjfj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nKHzWJvb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXxi91308185;
	Wed, 16 Sep 2026 07:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IRR8fGZlHWNLo1h6nI6PQl8tq5Iw3w1nuPIirBfUuRo=; b=
	aixvcjfjpKlTKvgCplaiuGz4ORu0ye+66EPqdC5Im1tTOcz/BepjD42co/x5VP/X
	9mHfjfDiv1qSx/xVCPWx4AICDZ9THM6gN7NLyPMSPke+7k9CNDY4kmdAW7YsygFM
	XAME0NoelAcb+J8crERaudcdDodIopidT9ygXqIX2kLzfPUVb/r4KBIEHRVD4mpk
	YkCYEe4LlFp514Da4G9fc9VL9Z+Zx3Ltp2xSviFOj1ejuSo01cPJHZuIkKjtmzfG
	tGoZTZz/RcQxev0XTkc9kjm2Qagvr1VCNs6BLdjk+bAqoQuDe0DYHOXYB8+gUflM
	cnULb4jNdnpAAQwPRKvjYg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn9554n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:45:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7jOdd040847;
	Wed, 16 Sep 2026 07:45:27 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012053.outbound.protection.outlook.com [52.101.48.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q8r2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:45:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJQ7vksKZ7gxVF+oWhDn/j5Q6vBJDD3R+Dp8nInc7MsRlQqElXt6aH4WInAAbQDrLHw2FrC8f2j8vx/t9LJex0yA/y9fJNCblg+hwQrie5Y/7xHIKk6rZvq/Ln1tTPAN7wFl60nRF1Db9KXwg3NgPB4NqZSM2hSbyMzpDzujoq3CJ0+coeNb5g6+KhTpzCuCVArc1na8B6y5ho0n2FUfU6DR/fzVGeRKn3mJMcaMVUZJxuiW8/hrIl2OER7ozlPSxOg1nSYBJkD8fYXpvIo/18A/rHZNFu6NP8X7Zli/zIasYiaz3IVFhdsPg/ie+YLuZJuUHggmDZg+GzLqX3XUQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRR8fGZlHWNLo1h6nI6PQl8tq5Iw3w1nuPIirBfUuRo=;
 b=zWBJrvHpKYSvUmYt6utBVzdL9f88OGX5SFtugpWbY25D24V1N65kdWgqGcL2HlKDjq1D7I9zTRUjot+l2yhWlZlZxa3WmmUJV9haxlsxQs3G3WEmCry5ZxHRN0WsYjQ7eap96LYWgeJpyJLY+wA5vtRZNEMRprmDp0ggvSTLVn+TWeECeKrlR1cvjrSjbqzyOaEjefme3fGc08pXpdsduHMq0WZwAAcSpgl34o9AHgdO3VXrhBeD+q/X22saQvgRI4G00L4CKJUkUmP5EqmbVVlEfAHSXvfMcLOQEL9DYuoPQOcPqgYdysfeP3ttEVvUyKVlCymkRPLo353Gfm6wyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRR8fGZlHWNLo1h6nI6PQl8tq5Iw3w1nuPIirBfUuRo=;
 b=nKHzWJvbswLBxe+Kg+JunU2MzKRP4YrV3ZXBYUXnTeqNy9d+VggPpWZDuKCLB06hIeTzJgaxAKMRnXZOTicyBhZuRjSsVH3EA1eS0lqF0D2lzaNw/g2uWZqu8V6/vqUaTzd4vb93aY6ZoqYDycfyoPpDKEErOxYCrTjoysJg+hQ=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB6148.namprd10.prod.outlook.com (2603:10b6:208:3a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 07:44:22 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:44:22 +0000
Message-ID: <aa1e8d13-214c-4b89-82f0-ffdf60267343@oracle.com>
Date: Wed, 16 Sep 2026 13:14:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0760/1376] firmware: qcom_scm: Support multiple waitq
 contexts
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bartosz Golaszewski <brgl@kernel.org>,
        Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
        Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065624.478173368@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065624.478173368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0315.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: c12d5348-0948-40ed-9ac2-08df13c652a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|4143699003|6133799003|18002099003|22082099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	0yKN3qIqX13LlDZyJKYiQ8zhckmBFvYU1txqgo9sH6I5irSgaB3VHJofC/fgq8t7Pqvzwo/DsKEt+7xIk1SQgM4uA6X4hlj1QNJfPv6xREt4Qfj53Wr/qRbcgnAIRq0hwiLlkvVC+C8/qR9kkhxwcWFFOVHdk00psMzw2sEttlBszZXAsS5BRW9h62RiikbeTKvZaOzvalJuEMaTdXswaFFXG11fXdbjTvm3greT1P9V2ofaEvVKx5d9MHKBjQ8E2LDotXPQrsdoLBCW3RvsnRhaTpxZvMexydRihQ7UXT81PCE+XI00gcS9JbuMLs6n2xXUqeFM+vYhdxODpVvjESys58OV9FqvXhhPpoEKz5JU9s/WZUKZypI0Y/6ba87vNctpk5T9GXoAhUuJcqHqSf/oTcSVQAP7EArK4tGheRKHBYm4ZArbDOi9u09f3nnLGXW4sHVyOL4wCA6M++ntY0LWIx0ur2pkBCxRd/1Dec4m4BOZ7bA0OhQzG0CxdllC2+7zYywiSL+HzIPDk5z+7lHb7y7d5QyX950qw/bNyXdRQmCMjyLVSdOsQqdL4coxjYv3O4CcyAKWASQJ4Kcj0vsQBDBNsqkioOpnmrBZwJh9sYvFGy5WWenl37k4WiSg9tvunNLnhciXs1wPJUfOTEF4oRzaJps47wWMsUJYO14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVo4N0NiaWR0K0ZqQUJ6RTBCZ3hmVDZNQzNva0o0MXlEMmxlQWxzOE1WVzQw?=
 =?utf-8?B?NFNla1M2VE1zaWN3c2U4cDk5NjNaS0h0VnB1ODR2aWNPZWlzVjI5Q1dpYXpY?=
 =?utf-8?B?R2wvajgrcGszZ1kxcXc0VThFcjZmK0RuK1J4b2RXZjhsdE5GeE41S3kxZE5L?=
 =?utf-8?B?YmNmY0hEUHRFdFNPMk5DMHIvV0RTNCszRTlXUTNnbWphQkgxaUJyM01kZHVz?=
 =?utf-8?B?cnNpa3lOL1JBeFBwd2RsbVd3MWJwSHVKck1iRVowRDVJNTBOSHQvL0hFU2Za?=
 =?utf-8?B?R05iRXFJUFRKVytrWEpqSTkwNDdYUzJSV0k0NjFKQ2VwNms0S1JSWDBQdE5H?=
 =?utf-8?B?cTZLMVJRaVJ0dTE1bGxZelZTcUc4Qzh1Qzd5MmVFT0ZndGxnZHhjd29Mb2x2?=
 =?utf-8?B?T2lvS05IWE5BUXp6K1ZYeURlQVFjcFZWV2RmUnVyRjNhaU9hVGVxbmwyMndQ?=
 =?utf-8?B?amV3WGs2aXRqRU9EdzNiZEVLWmZTaE0zYzRZUlFuQkpQem5OMFZtc1FHWXhw?=
 =?utf-8?B?SkxKUHdNZmwrSUNQNWE5ZXk5YlJWTkVQNStMRjlaQitSa0FuVUc4aXpHZUx4?=
 =?utf-8?B?Y2krS1o3cVhUYm42MXlLME12MGZnS1FvWkdYS05Fczl4b0tCb2FHNUdqZW9O?=
 =?utf-8?B?ZGhXMUIwRlBtVmNHdVloUGlBRXVyREkydmlDMGdUa3greWpvTXQxZzRYZDVD?=
 =?utf-8?B?c0NEMkkvTlFXMnRuTDdVVTRVYXJReFdjZElHV1l0VFNBNERLdjRVMkp5bnQz?=
 =?utf-8?B?NXc1RDhzQzlObU1OUGxJQ3k0WDZFb3ZuQlRZanJiK0tESnozVlhPSkJhMzBC?=
 =?utf-8?B?K2R5VTNLM09LMlFrY2Ixa3VUYlc2YndSdFpGdnJKcXNFcEhDNVE5VkJvNXJ1?=
 =?utf-8?B?elRuc05sU21yMWQyQ2J5TG5seEZzUWhxaHVUYnJheTVzR2pWRGJXSGpxWmtW?=
 =?utf-8?B?WTlObStIUzF4VXJWU0M2OU02Rm9XVUJOQUJNYncwckxMd1JGVVVDR0EyZ3pU?=
 =?utf-8?B?ZWh5V2U3WVN3NnNBcVVxcmxDR2JCa0VFOS9pVVgweHl1MFFQMkhmUlg3ZGQx?=
 =?utf-8?B?WmRiQ3JReXZ4Sm51STJtcWdmdmRqWVNUUEd3b1FLZWFyM2ViRUlsZzhLVy84?=
 =?utf-8?B?S29DMS9lR1FOYW1MNTVsK291QWYyQWVTUGpRcUhBako2QXN2QzIrazJoeTM1?=
 =?utf-8?B?R1dqNkgycVloTU4wL1hxUXpNeDI4aEk2ZDI3UDQxdFp3aVp1ZGpsZ3Q4RnU3?=
 =?utf-8?B?VklWOWNENHp0K3RHQm0vTzFZckV6OVhxQlhLU1BUdTREaG1jUXhRYlJpenF2?=
 =?utf-8?B?YmpXK2JpSmt3elRTUVE3NVRKdTF2Q3lseC9WT3EydTNSSitHdU5NelcyOENK?=
 =?utf-8?B?T011eUJ6SFR5NTZqSy9RYk5ObTVEZWlKV0lJZ2lxYlVTbmErQnoyUWVYZlha?=
 =?utf-8?B?Q2NvZGpnSGdRU0dENlFVaHRjSk1ZZU5rc3dMNWhrL09BR3IzeEltOWJlOGFJ?=
 =?utf-8?B?UXcvamFHZUxCMjUxejNBMGh4YWIyRW51S0MrZmVlR2JEclliZktIdXFiaENt?=
 =?utf-8?B?Ry9ENTNLM0VjZDZaa3E2K0pKTlRrWG9FL3hBdS9VYUJTdnBSbjZObmlydEE5?=
 =?utf-8?B?YVNhT0xKUnQrejhodlBtN1NlQXRZT3RBcUtSV0FtSERqQ1N1NlNkdncrU3U3?=
 =?utf-8?B?L3A0bVdyOGVCMzVEbktaQVVWdDRmaEVaZlROSG9yeDNYaDI2WWxSOTl5RVlm?=
 =?utf-8?B?Q1JQdDB2bUhMTW1UMXBENzV5R1Rlc3o2NjJ1alVLRk0xT2wxTDNDYUFlWlpw?=
 =?utf-8?B?Q2VJenJ0NlAycUFMYzh0Y2VIREEzdG5jTjUyczR6N1c3WFZFbnN0M1paSldh?=
 =?utf-8?B?M0NSY3hoL3FsdVNQOC8zSGxZRTR6S3hLSWx4UEY0a01hQzMvS1RhNnBLTFhY?=
 =?utf-8?B?dDBpbGlHdGc0WXpmQ1F4SDBnUk9oKzUxSWJPSTVya2VJUFFNdWRRRUdqM3Fv?=
 =?utf-8?B?OXFIekNnOU9wOUlWcVpqQnJOUWZ1dkZkQjFQZkhOUEZGdEVlaDVNck95TzhX?=
 =?utf-8?B?eFRpbzMrbXlHdkNjYVNVazJJdmNCTkJNK1RNS2lORU1XTkllUzdNNHBMVE5I?=
 =?utf-8?B?L0RrZ0ZpRE1ZUGdPNjJJQmJMMkhFQTVXQmFuRmZiK3VhMm92QVE2Nm1SU0xI?=
 =?utf-8?B?QzE3MGlrdDMwS1p0Y3pKZitod0g0YmJuT2E5Q3gzREhpaFZZZUVjMitSUG16?=
 =?utf-8?B?STUvZ2NVOUhlQ2IrTFVWTDBPMXRnY0xRVXM3SHJ1RktheDUxTzJjUW1uVFZu?=
 =?utf-8?B?dy9WNTBBU0dDR0FVMk5OMjBNYlBTc1V6dDhlUVhLa0RpQTBndUY4aENKU1lQ?=
 =?utf-8?Q?O0639YoQl5xxn5FZQO9bu4rWdoFx4WYVcgB7T?=
X-Exchange-RoutingPolicyChecked:
	lW3f0TwXBjzN+hr5JM4MOsVo+GQbJ7Y9RZOVAJFWlD71Jq2MIBiPtn+e6/DtuJr0vzIf0mkiavvS6nmkHoCxvIkadabzQKyRzGOthNJ+HfULZ2x0F7ZBEihP8rxrZfh66Gcrd+Je2IR9SVjVrUXx/UUCO185jTo0vR2TN6xhrlBRiB+Qu/ACH3grrMFLJazzYMw1yuy665HIbsC4V3sLq8fp0OVoVaDOThjFdA0mgIzL+a0zNV15sLN+So66ydJtkU00ojU0qmJ7X25rgM+6vZV9X691w9AC6/t7x4Zd+vnq/VaK+IQJfq1FvuVnhzXNWZIdqiGwTNOEbR/16nPQhw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DnsiSXCh1pkGyaw+8BixtjTJwMHAhdUC7WaABkFkv2cK8VJio6AXjDO+EJcaenUiFoeKHnyjpBaSZBfLPLcFQviAjc8R3il1p/NvWm34y5ZJUPCgKGWrWifp7zrFM38gJPqaggIPpSDqob5HYXTsbwE263DNDIFPtnqjLsXSToisLQwf5ScDrzUTB/HRcUyFxu7C30CL4TYBu8oKFGEvPxRbrsVrIj3TyJfxmX/PgoTJCjx9YfOr2g7GLEaswfCrHA8ClDiwPFvkWPM7e9BCYB3OfHRVlO4I90qtvevtaLbQvcxrcDmcZ6p/Lu9ZCUSsTohC0lGA4QobKQIi+BmYZ7yXXhjmXWW+w5NZtz1ColIDYD7zsuzK1po3gn14vGRg2EcXwwyOjc9VkukK4JYQFsMPzJJ7KdV/v26ZX1rkbpIEi82yasyy94OmRR66BmEpSqLlV62fTZ2d5sojSjbeKM3Yd5OGLrfHIgS8+Uk0kXMYbNotUG2Apdggs2sLA4FNHSwikJ5kHAalLgKMW4FI/oPFYbHxJFVFvsjMd5qH6TCFKiJjA7sLjZM00UOHm5CwUECMG263ew7SyDF47UnbOWmnLKVasTDAmplDiGBoQaM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c12d5348-0948-40ed-9ac2-08df13c652a5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:44:22.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8pgTMf0IDX3Lmsg8mQYNGKeP4PUYykMCA/6fWcrIz6PPH9lTMgtT0If3ZPun12uz76EyoMl28vLj4KV9AqQIzpgIjthfUatFLxoCC55AySqasiooTaeLCcxDfn1wi5p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160100
X-Proofpoint-GUID: 5PHswvZudKhyqCTNqPH_Im9AlekX2hp2
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5OSBTYWx0ZWRfX6iOS4h0JuqhC
 lMPZpGQMrxF0+cv8PrwbHZW0P8x5nleUiS7K3ZL1JqG0cXp5B85ZhtFy3x9TDOW0O+lZHNgEFET
 uayPcCdcZOcTgP27lPAF7cnASKVJZzoySnyHOoj3vuoBIy/2462l
X-Proofpoint-ORIG-GUID: 5PHswvZudKhyqCTNqPH_Im9AlekX2hp2
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa4918 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=29KIwY99vDLyvZJVNToA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5OSBTYWx0ZWRfXwVX6/rT/znaf
 mtruBXFQcOst6y8hC9yQ8myw2kMuds5TbxVeateuQO2ts/sPjudcFUW1u1A15MdbsDc9Yq0sqeq
 KDAP9YksgQ3e78MwLjbcK5w/a1Lo1G9GhyHzlpM5H1wDT4zWIZJEyr3DrRET4+FYL7h8TsoDUP8
 3k8/bMlpeXBG+2yOxnLfOGAElMCpqIehVGZHyEPzLaULOLeCjh/F9MshdXfte/sRUm40QcZSMKn
 AEt5aZaK+H3SoMBEjCBkZpSTD1Xbo4xShf03YZEc6jAhNo72PLkeKPeH7M9l2XGReg2SLMqopV1
 09K1yCzxqw/sN4JTlqJse+LQqezKHfmCZcGu57wTT2DSVgPxlBs5liUAj3Grz1utuTUwBYYsdwQ
 bozB1JFICXwPTQ3bZ1Pv3u2RKgb4ml9mGBEj9qzaOjDpezGg76ItjiPwp0NMo7rqhk2vXQOxUbz
 6TYcQ6x/D91lb41hm6fEF9KgR7kftbSfRSWiNl9c=



On 12/09/26 12:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
> 
> [ Upstream commit ccd207ec848e768da41465352a0f52081eec6bb1 ]
> 
> Currently, only a single waitqueue context exists in the driver.
> Multi-waitqueue mechanism is added in firmware to support the case,
> when multiple VMs make SMC calls or single VM making multiple calls on
> same CPU. Enhance the driver to support multiple waitqueue when
> support is present in the firmware.
> 
> When VMs make a SMC call, firmware allocates a waitqueue context,
> assuming the SMC call to be a blocking call. The SMC calls that cannot
> acquire resources, while execution in firmware, are returned to sleep
> in the calling VM. When the resource becomes available in the
> firmware, the VM gets notified to wake the sleeping thread and resume
> SMC call. The current qcom_scm driver supports single waitqueue as the
> old firmwares support only single waitqueue with waitqueue id zero.
> Multi-waitqueue mechanism is added in firmware starting SM8650 to
> support the case when multiple VMs make SMC calls or single VM making
> multiple calls on same CPU. To enable this support in qcom_scm driver,
> add support for handling multiple waitqueues. For instance, SM8650
> firmware can allocate two such waitq contexts, so the driver needs to
> implement two waitqueue contexts. For a generalized approach, the
> number of supported waitqueues can be queried from the firmware using
> a SMC call.
> 
> Introduce qcom_scm_query_waitq_count to get the number of waitqueue
> contexts supported by the firmware and allocate “N” unique waitqueue
> contexts with a dynamic sized array where each unique wq_ctx is
> associated with a struct completion variable for easy lookup. Older
> targets which support only a single waitqueue, may return an error for
> qcom_scm_query_waitq_count, set the wq_cnt to one for such failures.
> 
> Reviewed-by: Bartosz Golaszewski <brgl@kernel.org>
> Signed-off-by: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
> Signed-off-by: Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>
> Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20251217-multi_waitq_scm-v11-2-f21e50e792b8@oss.qualcomm.com
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Stable-dep-of: 966d23c7e68e ("firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The 6.12 adaptation publishes __scm before the new completion array is
allocated and initialized, and before the waitqueue IRQ is ready. A
consumer can therefore observe SCM availability with no usable
completion state. If the allocation fails, probe returns while the
published global can refer to released devres storage.

Upstream code after both ordering prerequisites:

     ret = devm_request_threaded_irq(scm->dev, irq, NULL,
                     qcom_scm_irq_handler, IRQF_ONESHOT,
                     "qcom-scm", scm);
     if (ret < 0)
             return dev_err_probe(scm->dev, ret,
                                  "Failed to request qcom-scm irq\n");
     smp_store_release(&__scm, scm);

Downstream 6.12.y code:

     smp_store_release(&__scm, scm);
     scm->waitq_comps =
             devm_kcalloc(&pdev->dev, scm->wq_cnt,
                          sizeof(*scm->waitq_comps), GFP_KERNEL);
     ret = devm_request_threaded_irq(__scm->dev, irq, NULL,
                     qcom_scm_irq_handler, IRQF_ONESHOT,
                     "qcom-scm", __scm);


Upstream publishes __scm only after both the TZMem allocator and 
waitqueue IRQ are ready, as established by bcd14791ba62d2 and 4e06c33aaa5ddc


Maybe we should be applying those backports ? Thoughts?

thanks,
Harshit> ---
>   drivers/firmware/qcom/qcom_scm.c | 72 ++++++++++++++++++++++----------
>   1 file changed, 50 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
> index 5b2ef39a2e9e9..7f56ab78ac159 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
> @@ -48,7 +48,7 @@ struct qcom_scm {
>   	struct clk *iface_clk;
>   	struct clk *bus_clk;
>   	struct icc_path *path;
> -	struct completion waitq_comp;
> +	struct completion *waitq_comps;
>   	struct reset_controller_dev reset;
>   
>   	/* control access to the interconnect path */
> @@ -58,6 +58,7 @@ struct qcom_scm {
>   	u64 dload_mode_addr;
>   
>   	struct qcom_tzmem_pool *mempool;
> +	unsigned int wq_cnt;
>   };
>   
>   struct qcom_scm_current_perm_info {
> @@ -137,6 +138,8 @@ static const u8 qcom_scm_cpu_warm_bits[QCOM_SCM_BOOT_MAX_CPUS] = {
>   #define QCOM_DLOAD_MINIDUMP	2
>   #define QCOM_DLOAD_BOTHDUMP	3
>   
> +#define QCOM_SCM_DEFAULT_WAITQ_COUNT 1
> +
>   static const char * const qcom_scm_convention_names[] = {
>   	[SMC_CONVENTION_UNKNOWN] = "unknown",
>   	[SMC_CONVENTION_ARM_32] = "smc arm 32",
> @@ -1873,6 +1876,23 @@ static int qcom_scm_fill_irq_fwspec_params(struct irq_fwspec *fwspec, u32 hwirq)
>   	return 0;
>   }
>   
> +static int qcom_scm_query_waitq_count(struct qcom_scm *scm)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_WAITQ,
> +		.cmd = QCOM_SCM_WAITQ_GET_INFO,
> +		.owner = ARM_SMCCC_OWNER_SIP
> +	};
> +	struct qcom_scm_res res;
> +	int ret;
> +
> +	ret = qcom_scm_call_atomic(scm->dev, &desc, &res);
> +	if (ret)
> +		return ret;
> +
> +	return res.result[0] & GENMASK(7, 0);
> +}
> +
>   static int qcom_scm_get_waitq_irq(struct qcom_scm *scm)
>   {
>   	struct qcom_scm_desc desc = {
> @@ -1904,42 +1924,40 @@ static int qcom_scm_get_waitq_irq(struct qcom_scm *scm)
>   	return irq_create_fwspec_mapping(&fwspec);
>   }
>   
> -static int qcom_scm_assert_valid_wq_ctx(u32 wq_ctx)
> +static struct completion *qcom_scm_get_completion(u32 wq_ctx)
>   {
> -	/* FW currently only supports a single wq_ctx (zero).
> -	 * TODO: Update this logic to include dynamic allocation and lookup of
> -	 * completion structs when FW supports more wq_ctx values.
> -	 */
> -	if (wq_ctx != 0) {
> -		dev_err(__scm->dev, "Firmware unexpectedly passed non-zero wq_ctx\n");
> -		return -EINVAL;
> -	}
> +	struct completion *wq;
>   
> -	return 0;
> +	if (WARN_ON_ONCE(wq_ctx >= __scm->wq_cnt))
> +		return ERR_PTR(-EINVAL);
> +
> +	wq = &__scm->waitq_comps[wq_ctx];
> +
> +	return wq;
>   }
>   
>   int qcom_scm_wait_for_wq_completion(u32 wq_ctx)
>   {
> -	int ret;
> +	struct completion *wq;
>   
> -	ret = qcom_scm_assert_valid_wq_ctx(wq_ctx);
> -	if (ret)
> -		return ret;
> +	wq = qcom_scm_get_completion(wq_ctx);
> +	if (IS_ERR(wq))
> +		return PTR_ERR(wq);
>   
> -	wait_for_completion(&__scm->waitq_comp);
> +	wait_for_completion(wq);
>   
>   	return 0;
>   }
>   
>   static int qcom_scm_waitq_wakeup(unsigned int wq_ctx)
>   {
> -	int ret;
> +	struct completion *wq;
>   
> -	ret = qcom_scm_assert_valid_wq_ctx(wq_ctx);
> -	if (ret)
> -		return ret;
> +	wq = qcom_scm_get_completion(wq_ctx);
> +	if (IS_ERR(wq))
> +		return PTR_ERR(wq);
>   
> -	complete(&__scm->waitq_comp);
> +	complete(wq);
>   
>   	return 0;
>   }
> @@ -2015,6 +2033,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
>   	struct qcom_tzmem_pool_config pool_config;
>   	struct qcom_scm *scm;
>   	int irq, ret;
> +	int i;
>   
>   	scm = devm_kzalloc(&pdev->dev, sizeof(*scm), GFP_KERNEL);
>   	if (!scm)
> @@ -2025,7 +2044,6 @@ static int qcom_scm_probe(struct platform_device *pdev)
>   	if (ret < 0)
>   		return ret;
>   
> -	init_completion(&scm->waitq_comp);
>   	mutex_init(&scm->scm_bw_lock);
>   
>   	scm->path = devm_of_icc_get(&pdev->dev, NULL);
> @@ -2060,6 +2078,16 @@ static int qcom_scm_probe(struct platform_device *pdev)
>   	/* Paired with smp_load_acquire() in qcom_scm_is_available(). */
>   	smp_store_release(&__scm, scm);
>   
> +	ret = qcom_scm_query_waitq_count(scm);
> +	scm->wq_cnt = ret < 0 ? QCOM_SCM_DEFAULT_WAITQ_COUNT : ret;
> +	scm->waitq_comps = devm_kcalloc(&pdev->dev, scm->wq_cnt, sizeof(*scm->waitq_comps),
> +					GFP_KERNEL);
> +	if (!scm->waitq_comps)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < scm->wq_cnt; i++)
> +		init_completion(&scm->waitq_comps[i]);
> +
>   	irq = qcom_scm_get_waitq_irq(scm);
>   	if (irq < 0)
>   		irq = platform_get_irq_optional(pdev, 0);

