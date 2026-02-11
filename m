Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F61CAA7D
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770794889; cv=fail; b=qH1JrjR9kypxJueJN7L3SzHUEVMEDrdcI6lgjlb/TAgUpsssbCHRphclUUewhEwzrA3maufaDDUXb5rSTjo4tUJrcPI1G0H+TUlvgPzoyieSnM5Ie93Q3HyqvkxrSNBQXIckTXkxnxpT8XRUBQKeoOw4y6TbEKBsy7XBJwZvK7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770794889; c=relaxed/simple;
	bh=DkOfXbwqsb01zNCkKa+3BHaNbgTFcG1gQ4S+yE3fNuE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ToW4okhJ5FW//R1uaGpTFZY2VlNAjUrGupUVg2OTy3I7kDxu5NIrZ8ogdD0TsoLUh8aiaa05Pw+iTb135jNP5WXUoQjxnnsgxSYZYXGQVT5rJvkWNM7P/0my5bgfis3hvlLZIfMicPTcYcmiTWYrty8SbTlhxzWqTKcYG3+uLng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ewFgdjV5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q6YNKFuh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ewFgdjV5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q6YNKFuh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AIpSHo3922495;
	Wed, 11 Feb 2026 07:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yIXeQKBHA0RWVONX6Q0qCZHpmQ2KfcaMCeC1YsKFeWs=; b=
	ewFgdjV5g/c9WezcWbktXZlP/z4cVS22bFJCbgP0sq/nQUfzzrWeCfrZJGwQy5Cb
	+39FSaqxjk0hVBLspXRZ9FFF/UBl9uUQ/jdP5er3ydb73x3s3T9YgavCe5rqeEbO
	gEl6mg+qHWQGEobe/AgQc0Yp8Pejyyhdyukd0y/Mg0L/T14IkjCGkbh0qYmr3/ac
	pnwpjccafUSAKK/8D/MCpjWXuY5+aijwqpOUIS3IsVxBVz/we+d1FvmUdUee8S/d
	fTDsQ9tyUlESFOXA00F17gFspQtTtL5VuCmhi2kTEBRUTWuUv0/57ROM1C9JtKHW
	4NX5BhkJ77t+uZUJH1wOwQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7rxu2d6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 07:27:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61B7Rmb8022510;
	Wed, 11 Feb 2026 07:27:55 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c828b6r2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 07:27:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dFbJmGRH2UV68Mb1Lth6VQrXtNJjtL+S0D+sk2XqGm6YRkvmqi9iauBRGUxq2yXcG7TqxnSIBL6qAOWqjYJUrB5u9c8hREYhW6FUnes84d+7wUkEPeFKhM0AtiKbsmYzFPBBadLQOHUika7rnL90/4uoTliHlctVWGcUNgCZaKO72HFnlv8j3pdvNvHzEPvdf2+P9ON0GV0RzkFS9ypjJXBCayzdp2T/+IkhIr0dykVhbBYZQoKtB3T7GAJLWxppx4wKccCnXBsutX29HI5U2hprj5iGC6XaGdpdv+ZilZtQdfoktnuPUUoRbp3IMBw0zohaR8OWRKYPTzkhgOYAoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIXeQKBHA0RWVONX6Q0qCZHpmQ2KfcaMCeC1YsKFeWs=;
 b=ONTOZYmo+O8Z7LKGwcgQwWBgbt/pDDwvYQfLCZ/aDi8Q1SmtG370lDFuY5ZBmQ4e+AkF0exBqnv64TIanpyMKKwFoAcosIU4wLj24BZYWiFl5keM5Jjlizrqo/LfW/KXxwCxOX/h8gaxcdNxX7/X1e5nGYgGDX+QtldvCDVTO9LvJmT4KlIi7XUyrTj8OVaHbD6XgX8zQG5e1Bs+vjiOB3Rg2mQ7PVP2l5ETZsn5vXvTz1HYT6L6h4jUgNfFxFVLRUiTsX2Zii14o0AmCW8XpUFd/LswI0UZv5T3waS4E9GxihPBFcEUhqIeP16fLbZmxRB5zAYIMK3+JRT3zGZVbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIXeQKBHA0RWVONX6Q0qCZHpmQ2KfcaMCeC1YsKFeWs=;
 b=Q6YNKFuhVKfZ4eEPeRthiowHSmiunwQa8j98ioIe4GM6hCuXNJB+QeWgDuPk9dcw7ENDV+Kjf4zVqj+hFuhOQhN04ONxLPaNF0bmQ9zvlqU/ZO9Vea2B9dEjAOa+quXd9QIA62KjxAGLpMZnG56N+VR9cIchezlGhdaJSsk+8DI=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by BY5PR10MB4353.namprd10.prod.outlook.com (2603:10b6:a03:201::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 07:27:52 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef%6]) with mapi id 15.20.9587.016; Wed, 11 Feb 2026
 07:27:51 +0000
Message-ID: <03b7751d-3e8f-414f-bb15-cec84fe0b26f@oracle.com>
Date: Wed, 11 Feb 2026 12:57:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/75] 5.15.200-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260209142301.830618238@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::17) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|BY5PR10MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bddf8c3-f893-4bbf-87f9-08de693f1051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUNWSGhOUkZEa3lNczltVGpPMFozZ0tKUWF5YkNsbXBRT2F2RlNRNzdnOUtn?=
 =?utf-8?B?VmlERlVmNUIrTGVhL1ZTT1JXWHpCVVo0QkdRN2VXS3dFVXRiRjR4SXpDUlYx?=
 =?utf-8?B?bGU3Z2NNU3lzSXB4Yk9XNFhLRkhtQjFsTVEvdUlQbjl3T0JsbzI4ZGN1dXVM?=
 =?utf-8?B?czRabUJCUXkxZ0g3dU0va0pnekxvMzJGWVBqeGpTSzczSWhTaE54MmpqV2hG?=
 =?utf-8?B?Zm5iL3NSSkJveVU1U0Vrcnd6Ti9weVJsd3Q1UXo1VjZjMEQ0WTUzSmU4RVMw?=
 =?utf-8?B?MDdySUVmZVVLTFNiL2pLR0N2Z0ZoeFlOc1JOdnlNamVDQzdVZy9OYWIwZC9a?=
 =?utf-8?B?aEQrUmo0WnAwQmxKeCt2UGxJR3ZGcm5TaVNXenNRQjJIUWJPa1QyV21oeDlr?=
 =?utf-8?B?V0hreGlDVFRNN21CVi9kcDJwazdlaXZuSWxRb1JZY0FUNTRKR05sYkltSE9C?=
 =?utf-8?B?dWdqb0RoTStkQkUwdzZLMjNFVlNac28rT0taQmNBTHdCd1lTWDBwRWovRnE1?=
 =?utf-8?B?b1l1ZFpSQU9pMlBIZ0NadVdQNkpSNEcydVhMWFh5d2FaYWpnZzJxK1F4L2Nt?=
 =?utf-8?B?WUt1bm16R1lPZ2FKNldwWlVWOTVGbzZBK1hpV2x2ejZSL2hJWVVQN2JRY0s4?=
 =?utf-8?B?SUJYR3ppRko4UytUUTczNXY1WFlHdlBMd3VOZ2ovUkdBVDRHV05lU2tUVWlo?=
 =?utf-8?B?Y3hYSmhxMHhGdFVyQjNuUEFNTzEvcW1lNmZCaC9yK3F3OTh5eXNqYXdLTGxD?=
 =?utf-8?B?NlJLNGdibUdxRjlHbTRCNG9YS2dFL0VURmFBK3VJclhVVWpPTWR1bjlIdHNY?=
 =?utf-8?B?RnNMckxTLzk3L1ZpUStNbmhsajlEekU1Z3huRmtMOFYrSDJRVjh6RE1MazMr?=
 =?utf-8?B?ZVRhZG5Oem5WUy9WR1VOUUR0ZVp6QTFoRU1meDBKQ3VNWGtWcHpacHJva25t?=
 =?utf-8?B?TUJLMTZWUzVwbHRZWHZ4aVUyYUxKT1piRDUxMUJlOWd2MGREU092TGxFdEQr?=
 =?utf-8?B?TmpCQ3JxdFZBK3FSUVFhbkMxUkFsVnJsRUdxazdJeVFRRDA4YWxiSWxMRnE2?=
 =?utf-8?B?WEpuSG9oSmVwbXdSekljekVpbGVJL241bWk4M0EyTlRIZWRKRzVGWU4zNWtY?=
 =?utf-8?B?VUprMTJuN0dQc3c2bzNNY2NaYkpiK01PWWZlK0xLMmNQdGlvNExiUVBRdG1N?=
 =?utf-8?B?UllDejVhZ1pVK3gzRHpUQ0Z5dy9PV0NkRlFHSktaK2tyQlE4cjNqUmNpbVhq?=
 =?utf-8?B?QndJQjllb2JjUVU3aFM3UEZ5c2RQRlN3by9DcnlHU0RkcWhrYXEwV1I3L09N?=
 =?utf-8?B?OWJpU0J2aHVzR0h3aGtPbE0yREJTNnpFdVBXTG5EK1ViUjZIWXNxQmhjTWlz?=
 =?utf-8?B?Sk1yOGFaMW03V3VQbk5QaDZHaDMrTDRVaUZ4VVlSTjJ6a3V3dW16Ziswa1cx?=
 =?utf-8?B?elB2a3hFRytuMnVNNCtLMmFOeUtYdU1IdUpSN2hkTEw3Qkdrem5VaVNuZGt3?=
 =?utf-8?B?UkVUMUg4Q0dNMUdYc2Jhb05JbTJKQ1dmMUREa1FCbEdmMktWUlNsWjRmMmlG?=
 =?utf-8?B?U3N4UFdjNi9LRTlhWnp2Y1o1NWNOWFRoNk1zcGt3SmpjRHlBYUJlNU8vcnh1?=
 =?utf-8?B?SEpGS01JVnU5YW5xZU9ySDBpNUpYWmhyczhkVDlGc05FU1lQdmo2djZXUjlC?=
 =?utf-8?B?VVpIbGJDNlU1ak54T3ZhUFZVZkxVZG9lUHBMQ2hjb0JmdG01QzREdkhrRHVi?=
 =?utf-8?B?MEFybjlqR1FEWFV2bzc4ODVTT2dheGY1dzQvU2R3RjBsZTR3b3NVMHpyKzRj?=
 =?utf-8?B?bDhvdUIwT2NLbHNQNGIzUHhhVHMwQTFnRU1YNnduMmpFS3JEYkhmdVNLb09I?=
 =?utf-8?B?am1uODB3emZYZU9aQ1Eyb0t6aGZldzBDL2wrNHhpYUZXZld0YzJDMTgwOVV2?=
 =?utf-8?B?Rnp1d2FqRzBWcXhYNkY2VWYzVVBYTHQ0dVVQUG9XUjY1dUw0WklkVnFnS2No?=
 =?utf-8?B?SXgyWFk3OFBZb3dXeTdzVzRTZ3A4TDFKRktDbm5EdHlZb0Z4bFVIeHB6a2lS?=
 =?utf-8?B?NlN2K0h3bTFqdzJ2dWtOSllUN3crSlExMlhqamNpc0wxS1N6anVkUVBucFVj?=
 =?utf-8?Q?fJHg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmNGVTAva0NnL3hwZzVjTGE3SWF0ZHI4VjBFWmNSNDB0Yy9xRHJwVjkyUTEz?=
 =?utf-8?B?b200aG5iWWFPTFZzOWVSZDNSZnlMK2luYVV1aVRIQmpFYWZHckI3WnlpNGFk?=
 =?utf-8?B?SFZSNWh0K1NMZTEwRUZxWTRQa0JBL0UxaUtBdFAyUG9zZ3cyYjNlbVR0S3ZC?=
 =?utf-8?B?c1VmeTZpWkxveTBLK2N0cVlodGt5bDFNRkl5eU9LYXVNTGNOU0xacGNyS2d1?=
 =?utf-8?B?MG9IdmZ3cmFJcC9ERDByaUhEbHlGTnZSWWZBR2kxRWNkM25xZkxDbzRub3k1?=
 =?utf-8?B?d3BORklHU215NWF1SWVmZUljUWx1OTVNYStKWmxzVlZ3V05odjQyWUlxeDhn?=
 =?utf-8?B?b2luUENtSXlYSzc2M2ZFZ1RZZUk5NjFIOEFTL1RuVmo2M2pZODhXN05oWVZK?=
 =?utf-8?B?YUplU2N1ZlVROEc2WkdweTcxdThEWXlQa21NcVFLRFF0OFRuL1daTUIxYnVv?=
 =?utf-8?B?UUc3eXVkaXRINnVWaTFwaGlsWGxwZjkxV3JHejFTRTJVWm5HaWxyOGczQlN2?=
 =?utf-8?B?QzM4Q3RlSkU3RGFabTR3L1JFL3FWNm5GcXUvVXh1WHV5NXppMWhQQWtzS1JL?=
 =?utf-8?B?RC8wR0NXNnNWNlNzc1llN21Nc0dKcGZxR1RzZm1Rb0RxcUtCdFdKUFVhd0ty?=
 =?utf-8?B?emxmZ09NRlljTE8vdTVUNDNiaktzUjkzempKb2ZtUHhsa1hoVlFBb3hRdSt6?=
 =?utf-8?B?SjFFc2piQ25GcDh6dzRLTjNhNHJmN3ZFbFNQcFFEbkpYdGVJckJDaG9wR3dh?=
 =?utf-8?B?bGMwZWFvU1ZQVUlTbFpPUDBHNVhWSXRBZURIaDRQVkV2WEh4Vi9YQ3B1L3g5?=
 =?utf-8?B?eDZ1YmRvREdlZjJIbVhlT1VCT1Z2YzE0STdVNTRTVllKSFl5aTdQZkUxanR0?=
 =?utf-8?B?R3V5KzkreU1oaEttNk5qUHJKbXBCUGxpRzF0Z0o0SGZPL21LUWNaVWNEd2tZ?=
 =?utf-8?B?TWUrTU5VSTNxYkZqRUpnNGMyMFVtcnVvK3hYbUhydm9RdkwyUWFORENkb2xl?=
 =?utf-8?B?dlhWL3pzUGpSdWQ4N3MvOGpsZ3ZYQk0vSmtSeWJ3U3VPTUFZM2p3ZFpRQVQv?=
 =?utf-8?B?N1I2ckp5T2NJYWdSMXJpemJBVGdzSTlqYVplaDdEU1dEOHJHNEJWekducG82?=
 =?utf-8?B?WlZrRi9JdlZoWUFlcGIvZW9RSTdqNmJDT2U0YnVwcVU3cm9PRGw2TVJrSWMv?=
 =?utf-8?B?M1VlZkE0MFdIYllwOHpDcmdoNW5nMUNFWDV5T2R4aTUxME52cHFlMm5kbGhW?=
 =?utf-8?B?NHJ4RndYQ1pjN08rcHFqTHBtMG5jcnNxdUxYdUhHcXZmUzQ1eXowanliQUR0?=
 =?utf-8?B?ZFVVRk1hNUF0d3V3L0hiQkpIVGVpZmdZNHVLb3dZRVZtRnh1SFlIaXFyRE1Q?=
 =?utf-8?B?eW4xdTZXbzlUU3N4eUZYZ0ZIWGVrak5KTTZqVkUyZnd1S2dZVEVHMldVS2Ex?=
 =?utf-8?B?KzYwV3JwTHF4bU5XaDY2ZklKa0UxUzFRSnZiOGwxSVV5NmJ5Y1FpZkhBeExp?=
 =?utf-8?B?blh5TldaT0hzZHNLNmVTSzBDS2RoZW0raDlRTGgza2ZvS3RkMC8ydVZaUjV4?=
 =?utf-8?B?aUZRVEVnclp0VDVZOGQ3anZJZ3hUOHVzUkdPVUwzaWNEQ1liTFM0b0M1cHdQ?=
 =?utf-8?B?QldYT2tMOVlNR3hWU0c3SHI4QXplMnF6aUFSN2pvVGlHSzljMEU3TzFIaTRp?=
 =?utf-8?B?ejllbmlnaXZ6K1VrRit0TkplckJocXdQdnNzdlAzQlZFUzE5OC9vMDRsVXhu?=
 =?utf-8?B?U05tYzVsdlZMSldLV3ZuOEhNMWN0WURsenU5eHNmVjF3UjEwRC91enQvM0hV?=
 =?utf-8?B?WngxQTRJTUZydVgwajFqeitseXdUc0dwWnNsenpTNzlJUjU4TUtzL2NvMXlL?=
 =?utf-8?B?WHFlMzEyc3Jta2hUZ0xsYzA1QzZBUE0zSk5GUG51L09uRXkvUXZpYVYvbURF?=
 =?utf-8?B?OWR1azJ1cHdnMlRsUE45Ylc1b0ZzMkNmSUNkL2VlUEk5VDh2M3ZlbDFHS0F2?=
 =?utf-8?B?UDRrQUYyV0pDZTgwUGhPNDNIcEZnTUozZllvZ0hiRGJBZjk4YjRodXRmZlNk?=
 =?utf-8?B?R29rVUpYQVBMRjF6SmVPRS9hbURkU2hRdXBZK000eVdDWlhQM2Y3QVB2OTBp?=
 =?utf-8?B?NnVGcDArSU1aS28zdUhXVXR0VGZZTG44ZWVsOGVjMzNnSlkwem1iVkgyRDB2?=
 =?utf-8?B?SG51N0dtSENBUkRMak9FWWVPZHRPZ2FQbVp1b2RxTTFKVGFvT3l1M3ZCUDdQ?=
 =?utf-8?B?ZHZ3Wkt0dEhVMm5saGpCbXU4WTdIZXR1Q0FteVhIUFZ1b1VaRmhzYy9DUzFo?=
 =?utf-8?B?V3hrbjhFaFl3YWRCL0k0bEJWalpNdS9Vb2RVbVpnTnRURUhEenU5QS9makEr?=
 =?utf-8?Q?uH4ZDTb025+hmqsU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	84r+c8qee60H/TTir4Ux8thgEnPK7Tgv+M20l0gwSWyuSGNnmPZrfQWVbc/8h5V4uqf+MNTPicPRcReT4uZatvdb8f9/oWdaIM8HqOkES6vJzH/v1vc+UhjESIJ04EvVIJgg5jSVtKb+nL+md62aHb9F5lUBs5OM/uLuswM/1vM4EbuQgzQPM8lVFhddPOa1dCrQPUxzsv1lDVp3d05c2fg0Tfkxhc9FsMB5SD2Dr7R8Jtv74rmJaHHxXnwDA1KDtVnNk4pkxl4RJQ+kfmy/gWbFgvSzcQLKZqrIMa1xFIntF/UmHwmzoZB6mECzCzSpdzITZaccir2gDKIWkNET471//mBPyFVs0FgbTNVgDhUtp5B3dKGtpfNlDamVPtAJlP66/yCwqogdw0jXRbFh350VKo5PQwlWMsJcbcxhLEAQ5HWePIQz1Fox7vLusfUz5DAYn1IUse8BuwZhKEfbbmRWyGwAjcG0YYbx949BLsxSx6zYU4sSzkpUC+uMuS6Jhbkg4ELEOhR3ceUhHJMEV2xERkF75RTgTj2BrBJSOTF+C4ojNEIedlRoNs4K1aFdzum1AVZe1q1TZpDIdgV/uiRXRgZ5e8N6epGkE18dEnc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bddf8c3-f893-4bbf-87f9-08de693f1051
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 07:27:51.7632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftLYo2Q9JhZuSv3N+nxQrMbE7l75tAKkS1IgXOJe64PPzRBAaKmojHEUyp4Usjllp0WzKf2m7Gb0r8nmccIiCjEot4K2CzDQGs5ucp8f204=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4353
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602110059
X-Proofpoint-GUID: aakAxszeOAqlLLHONNEGBipl3Uu59LHg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA1OSBTYWx0ZWRfX8X/K9agpxPEf
 4NnAkShwBlOvNXmXvNnJyGDFvvMnhHlZxOILPLccIhnrcbqlpDX56qwHy9Ggz4Q6RWuuOINlb/k
 SpeMUgQ9L/60GEFRthnBLRHWOoFWpUR6YCNeX/Dggre55TP8aPV52vdXlkinhAhx84ucl+TqeNZ
 +SRzumtMYG6OoSnZqquXJNn3k2x/jWhn01r84daT7Zcn4AYFtpyAQtcUTrepDojYiCSQOjXeeil
 YqpgB0HtHSLjJJGcrROKj7/1L3QNVIy/ltKnjBN9w1TIO79iRpZUY8QN37avzexIt/TpIzrCpz/
 uykqKR2PcmYiVwSg0ni6bvlW1FsR9efc02Fs7puALRqpLWlz05DRJ+9XMjar8/7s6eqnIpuQUla
 ar6LJ/4cvRvhMiUOrwS+ZE7huK4C+qDOwHjBroW478Z2jtNBayH24VCbDPDl4c5bRyB6hz1+yuO
 omV57DURp9OEArH9CBnGfQN6ee4G0zaTpD8FJzzQ=
X-Proofpoint-ORIG-GUID: aakAxszeOAqlLLHONNEGBipl3Uu59LHg
X-Authority-Analysis: v=2.4 cv=Y6f1cxeN c=1 sm=1 tr=0 ts=698c2f7c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12149



On 09/02/26 7:53 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.200 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
Hi Greg,

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

thanks
Vijay

