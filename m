Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C401B14F98
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 06:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750315745; cv=fail; b=M2YSrEDySWTzvR7gRpAr12LerSg8DfWzpNDlbn8aNQGDNb76YK8q9l10yZe8nbTqpGLLbRv9/IiqoVeG/B3ROT+1sQ1514rpMTRaeRNWGmDlafW6HV4NRPsRkA2NtXaI6l+OEcgkTAp310BfmNVOh4NGe2heCDGAQK+NQko0o34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750315745; c=relaxed/simple;
	bh=H5LpSqNug3CzAZO96wcq+4uw+cgcxtW4pHrByH2J0Sc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LMCakIz3YyTPt8F7cVOREjkcNWBmj22t2TwUdR8VSUmZU91Lg69jJpLsRIh86SvznriU35rHK5xp0/VbKK7o62lhCP98ZzZAujsFd1l6lxWy6AgEx5ZAUVTqa+QZe83WFvAUAxqANiXZZ09WWo5BXvdnNQn1EKmTUhqEzBai4UQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RXIMZusQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DotRC310; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RXIMZusQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DotRC310"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55J0fcIa031393;
	Thu, 19 Jun 2025 06:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EtqLeLV3EwjuYdCUBnS5HlpgwqER3lf+ikp0lMJTd10=; b=
	RXIMZusQ95OXOUVPHNedYxrl+lwH2v+7qf4ZsoTuK4P0E8YcuVl3NDCZj0brGoNo
	kIdqHHLckJL3kBztG5ArzgY0dfLZYJuAcAxGYVxaJa6mAq6Abl0l/x3w/U+dM8Lh
	Jo83n0zUmmRxK6TJ6W9q0EuoSqMu7oC06iHVBAZOPOw7Js0/5s4BZypixYv6gSdF
	t5BnqqfvCivpvAa6ipXRYyYc1mYNC0ztENQTkjTRU9BlCvoY5OKZ/7DGMUQobhhp
	JvFQGM4iuka4zI7TmtdD3MPjFIANdbZR/vG2pi8nx6bsoa2m4CiEb3HcCnH3pEKe
	+0YdawN/JiHCi53BPQrkYg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900f1c0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Jun 2025 06:48:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55J57J3C000869;
	Thu, 19 Jun 2025 06:48:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhbjfr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Jun 2025 06:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YUtB587E0HRsxqiEuKFVNOVQyB+BQkLj26nWHOTQjo+dmWlU1ZFRdMdqKVmyeucmZEqjxommUXqVYiZqFhqQRlWKkKJUpigg3Vcb7NNiwNMeCjbV8FN0ZRq4fK+Dtp1OZQpqoYlQf0IvgYccktmZP/oRo/Nc0laYILqH/qltUQKipL5T4/TkwkFWVjZi9yRSB2KcXtyO7EZqUphKfquZO6CUX4AEC71NrDnDnANlrL/Rk8Xgv6Sg0eHn2P6T0TPL9e87K4Y476bhDbMC4eJDjBpzzii9P2XESkhnmDFc6KcMp2B1VzEleTqyKoVAau2gjfWYAnonBuoxgISZ+Fx9oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtqLeLV3EwjuYdCUBnS5HlpgwqER3lf+ikp0lMJTd10=;
 b=BSMSzME/YEAShdRtpYGz3M4sO1/AghzDJwmD8JRhzvg1J76Amr5HFLCBF/InhTBWmhR18nnHsaCvkwa0POZCrURMYMHKSV3lJUN+1p2KVtLnBhHH98hwygj2EjeGYaTQxUEo26ZuyTTHz81XkkexfHCwDGkpQKBDopmXIJeEjZNXpzOHPxpe+AEnR9NTq1ftKhSllXZYZDXg+bJVupvnIxMDX0D0ytbkwUFZPfeIIcER8a9X3mYa32LCHSHlPjoRYFhQ/2rLbsVZskCJkCH942DdGJJrO/a5rdi4vOHLWu3zOj5VGzqjObrHZRo/kf0MwbhyXogkHhYyyh4LGGK5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtqLeLV3EwjuYdCUBnS5HlpgwqER3lf+ikp0lMJTd10=;
 b=DotRC3106860yK7zoaTG54I2paJKzXKrfk2qcHRWGk+lP0tushxX5McybLokiESQIg7bhoxxzGvFpIau2M+hQsMrqpU2mpiSXks+V4DsessRqCtqSBpncAy5dkAN325xp+1XuQQTnU6RJNWhf0wq7JYaZBE3/m89wiw1nQi7dz8=
Received: from BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
 by SA1PR10MB7700.namprd10.prod.outlook.com (2603:10b6:806:38f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Thu, 19 Jun
 2025 06:48:45 +0000
Received: from BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c]) by BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c%4]) with mapi id 15.20.8857.016; Thu, 19 Jun 2025
 06:48:44 +0000
Message-ID: <bd639f85-7bd3-4d7d-83ae-c68bad7e63e9@oracle.com>
Date: Thu, 19 Jun 2025 12:18:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250617152338.212798615@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To BY5PR10MB3828.namprd10.prod.outlook.com
 (2603:10b6:a03:1f8::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:EE_|SA1PR10MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a27cec-a5a1-4b1f-e84a-08ddaefd55d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TG9vL0NpV09OMTFQcUUwT2xxNTZOMmVXNVFrejVrUzk2MWpZL0MvV294WUE0?=
 =?utf-8?B?cVNmZkRTL09WQWwzcTlrSldidzY5YTd3YWtYb3N1Z3k0RVl3TXB3cFMrQVlu?=
 =?utf-8?B?UTNQekwvNjg4ZVBDZDJUSUs4dXRqK3NpL1E0TENHWmZtZDRHL2c2NGYrKzFR?=
 =?utf-8?B?STZwTXF0UFFnbXdENzJwbkg0TUpGWlBDV0pTa1FtdHNWbDdVQ29iekpEWFA1?=
 =?utf-8?B?Wm14MGlRUEJJU2g5SW92cXZEejJQMnp2SXhINWEyRXlqemdlblVjdlNmVHhI?=
 =?utf-8?B?NkdtbVUrRzl6TGMwTVZlMTNWZllRdHVuLzdjUDRlc3ZKK1hHbDZsWmxnc2VZ?=
 =?utf-8?B?T0I3VUJQMDBtdWNwRGY2d014MWVzUStZQThVazJ4R3R0VDdHSE8ydTVHTllJ?=
 =?utf-8?B?L01xYlovT2lib1NmMEhxaTlqUW0rdVdJNm5sTnZseDJHTHN4OSt0UFdkdllw?=
 =?utf-8?B?Q2tuUW45R3I4bVgrMmZkR244UWUyMzQ2b013VGMrWlF3R3BYRmFwbU4yTGww?=
 =?utf-8?B?dkh5QXhVcHZZUUdtbTNQZlVNMURzUWJ5YTR6UEFJTDNvV00rY0oralppOFFS?=
 =?utf-8?B?eExuTWgvK1BXUTdmWG5jTWtyajdMakkxY2dQbzVRL0xEaVRsV1pRaEdRbWdr?=
 =?utf-8?B?OHo3TmxraEJZTUw2Z0JaUkY4UFQ3THNUY0luUkhYSUpqa29RUDZ0c2NMNDF0?=
 =?utf-8?B?SmV5amlyMEF5aEdXdWkxaEtDN293TG9jaDRlWkxKTERwUm01NkZZSjBSQXQ4?=
 =?utf-8?B?dUxUdlFlZ1g1RjRraWVFZnhtb2I3MHVFQzdldCtpcjNNbW91eDJOL0N3S1lD?=
 =?utf-8?B?OW5wK3RkMTZ5UHhJM3NyRmQ1a3l0ZDh0Wm00elEwSVY3Ymx6dEd4eW9ZREJC?=
 =?utf-8?B?YnlvSHNXUmZHWU1uVk1nT1htOG1nNDhOTXNaZkpRZVNUZ3VZMUsrQmw1Qklq?=
 =?utf-8?B?c1hwdnoyYXJNKzJsK0RyK0djNVlIMW1EMXQ3L1ZJd0szT2dZaHBjWGRnR3Zs?=
 =?utf-8?B?OGd5R1J4SVZnYVh4ZjlQaTlEdjVqRFRtcWVzV0t6dkFLdXNaeVVPdDA1Sjhs?=
 =?utf-8?B?cEt5QTZhWDNEOVlGeUUwM252TnoxZ0NtZVVkTnQ0OXRidDJkSzJOR0E5RTZC?=
 =?utf-8?B?Mk9NYnZpWkJ2MFRTd081RVAwOVoxQWdtYzVrRHhHOUhhems3UnJuWXlnV0xV?=
 =?utf-8?B?UjJ0MFhlOUtRSlkrUGlzNXN0Wm0zQ2xwdnc0WEZla1VFU1R5emg0SlhnbzZm?=
 =?utf-8?B?TDRDQ0k1K0hHVWZUSk1Uajhma0tGK0NRUGhvcnY1akMyU0Y2RDhET3Y1QTh3?=
 =?utf-8?B?Smg0elZCdEVkYjQwanpFckRWTGh1bS9nT3VNZFlWbWxuQVc4QThCMVREMFpn?=
 =?utf-8?B?Wll4eFlMcUVKazh3NEl4dXNkSXZoVTNxRjdpOTR6d21KMmRja1g1SXhlTCtz?=
 =?utf-8?B?Mk9kYnhtbTc3ek8wbEl4ODZjUmtPbCtuTTZ3a2wwODYvdGhsU1YrVTBPVW1i?=
 =?utf-8?B?MzB4aEpETkVkSzdGVDlRTTA1a05qNytHaHU5dXNwUDNOK3AvSnk2RDNTVUp3?=
 =?utf-8?B?MENpbnY0UzZNWFc5MVdYWTUwZmpoTWFhLzJFa0VBcVFsUHhCcmpOcDAvUkRX?=
 =?utf-8?B?Z3AwQmRCTmdGdk9TQjQzWE1Ld0NiY1UvME5IZk9FWnMzVzJ1SnF2c0pvM2JP?=
 =?utf-8?B?cE5SMDBVaU96U09Ga0p1aEcrZWE5NWtGL3dGR1hwaUsxakNwVTFyRU0rUGg2?=
 =?utf-8?B?WnB0OUFObjVwVWZrUWpnNEFia01pOVVpeDU2ZG1lVlNMWlU4dGIzc2kyMzRi?=
 =?utf-8?B?WVpnQyt6c1BpT3dPSS95WjVNbDl3TXpteFptQlZTZXhPSmV1VG5QUlpKUjJ2?=
 =?utf-8?B?VlJQT1UyUkN6bnM4SjVyRGNNMHlNUGxhM0xPeFpjR2FMVVZ3RzN6UHpnbDFk?=
 =?utf-8?Q?cw+DbPO+vNY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3828.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUUwbUhRWUdJQ1NxLzdRUFlCME5UZmlOWFE5MHh4VEhWdENkVDFiRkp1U1RY?=
 =?utf-8?B?Mkk0R244YkdEWm5QaUJzZ3dma2lpKzN0aERld3hUcmFWTCt5Z2hpQmovV0NZ?=
 =?utf-8?B?SU5IV3NYWnFxWEJNaUowZVVqVEdPY1JndUU3clMvNzFGMnk2aU9sNWw3RWQx?=
 =?utf-8?B?NnVnd1F3MjJ6QlRXRFhSTFFjVVRVUlh5bm92WmRaUGVlQ2RiVUFVdXdBZ29m?=
 =?utf-8?B?V21kaVppTmd4a1ZFa1NKb1F2ZkRIbGdLMXgxQzRvelo0VG5hM3JseUhTMWto?=
 =?utf-8?B?TFNsTyt3UVBWaEFsOGNjaXZLWVJ3K3p6bnF0K1VxMzdwaUxJK0kveE9pQXdj?=
 =?utf-8?B?aCt6dEJxMzRLWEdJSWE2TW11cUNSMUlWSXZYSG9HdjVVT0Vjd1d1cjYvTkVq?=
 =?utf-8?B?YXYxcEo1ZW9NaDFhT1FwYklCQmVuSTN0aG5qU2dKZmE2MHhjQ0IyOHdDM2ZR?=
 =?utf-8?B?VlBZdWppMW4wYkpNVUUwb2U1blJhNjBvRFpGUXFMZWEyL3h4UWFlN084QmR3?=
 =?utf-8?B?Z0VrdHlTQVRwTUVQR1ZSc2k3dkc2VFVqVnVtRGFIa2w0aWN6ZUp2ZEVtdlFj?=
 =?utf-8?B?Y094TUt4TEZVWjZsSlNjSTdlWjFTOGNIVHdwQlpkMWpZczVNUGQvTE9XWEx1?=
 =?utf-8?B?VmYvY2VPaHFSMWRhc3dicGg2QTA4WEtZeXBUQjBIMmROVDFhY283eW9WL0pW?=
 =?utf-8?B?QWt3TkZ2ak14dUgzd1pvZzVsbmhLa0x0N2NxWS9PZkhJY2tlWnhMVk9MUUxQ?=
 =?utf-8?B?cERxRE9tVkl3Z2VEdmc1T1U3L2tIZUhEK0R1NHI2TTNZU0JJaGRieXJmZ2Fj?=
 =?utf-8?B?WkwzcUFzT3dEUXo0clJxaGljcVdmVFhOT3JjOEtuVGx0UUZaU1N6UGRxWUJJ?=
 =?utf-8?B?OVpGMktnYVVEK0Nrb3M3c0hSVC9aMXVDbDZlak5lQXptODNYVHlHVU1nY1lm?=
 =?utf-8?B?ZEZVR2ZOTi9LV3Z5U21rZGVDb3VvdlBONGFtRENreldQRzVnOW5PZ0tTcDJm?=
 =?utf-8?B?WWJvd2tMbDlWSVZzSWdvdHlvcEd3OWsyb2toc3NJczZCT3c1Tml4UXJrdG1H?=
 =?utf-8?B?SHlqTXMrdE9PSTUxS3dkb0JHd2JwRWcxTXYwNFJQSlFzVDNoM2crSUJmK2E3?=
 =?utf-8?B?OWZkMU5sK0hCRGVFTXltMytiSjVUVzBEbVF4VzIxTWp0V0ZQT0tjSS9LRXlz?=
 =?utf-8?B?ZzBabnBtY1hySy9NRVVnd2MyM0VDeGtjMmV2TStZVnBNQkRvRTdyUkRqWmdV?=
 =?utf-8?B?dXFTSmxOb3Uzd3Yra1BkVGw5U2dybkh0Vldscmo1OUxhTDBBYWpHaWoxOEcx?=
 =?utf-8?B?Z2pUY2RLTmhaNldqWG9OUVV6enlqN3k0SWp6cnRWdWNwT2xSUFlQSCtiN0ZJ?=
 =?utf-8?B?NUN0OHBQaGF2eG1uUXZrVHFpVmdueVZjaS9LNmZQQ0VZL3ZYcGt3dlhmVUdn?=
 =?utf-8?B?TnE1bVQ2RHByOFNWS0I5aU5sTUJzcFcwN0h1R0s2OWtFazg4dUhNZExmcHBj?=
 =?utf-8?B?Vk9VVjM5WDdsODVtN1dYQnJZTkVueXlnQlFMdER0UmVobk9RTWJudXV3UTkr?=
 =?utf-8?B?aGlRSFJwejY3ckMwTXJnai8zclh1Nm92VmxZN1hQRjh1Uzl5MjZrOElIeVha?=
 =?utf-8?B?cnlEZDJoVGN0b3NSNFJCSWV3bkxxYU95ZkNiRURvenZFOWtEcjUxYytpSitm?=
 =?utf-8?B?NmxKUVhZaWZLdWVQUGR2dW1CeGwvY0NNWDd3U0xHQmdoUDQwd2ZoeTRWdCtr?=
 =?utf-8?B?ME5rdlpRRFJYQzBldUF3Wk9pK08rdlVXOFVlbGQ3N2NmbFRrTU9DUkpNYmt4?=
 =?utf-8?B?R3N4NUJQZ0hRSkxpOGQrM1MrcW14NkptSVhxS1VNdkR6dVlORDJ0emhzZzhS?=
 =?utf-8?B?Ymtqd3hHLy8waitCcDErM2xDMlBWc093TE10K0FCcUpMR2lEZ2owcnVPK3Uz?=
 =?utf-8?B?RStNWDNObUtMYnkyR2taQjdYelpxUjdFSThudFZEWm1UaktPUDdqYndDT3Ex?=
 =?utf-8?B?eEdiVG41VUJjV0Z1Q2trOWppRDdMRVN6czJYZXRvZVdDemtnTmY4dWhkcEl2?=
 =?utf-8?B?ZDlNQlllL09UZnk3aXZlSzdoQUVYM3VLcUJQOWJIamFUcHA5a0pwb0E1Qk84?=
 =?utf-8?B?bUlNTGRFM2oza3VLbk55NkF2U0tVakp4REVnS3dHbkIwY2gxeHQ1Y3NCa2tV?=
 =?utf-8?Q?/mDfUI9IAvNJ/K/esW857Fw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B1xvuiSomLiAhER8UgP2sbDuHyrUjvvuhTxHZhQ8BvZISpGu77Z59RUMy8hTHVtvMdZ9+FtWbpR1IrIPKGOJigLBSHGAnudmej5NQi0ZMgLE0ib+hLMfdX7MFZ1KrVN/YG+e0beK70JHFI6XdEWO/dMKVGYBsizOkShdw21t+pgkkZopCCUyR4JR0HNllS67OgUAywXqOtVihebkM1xHycFMYjIyIjAaMkMzTHeHCKrE3FXweFzlq16gLWaWAg7g29P46a7+XLRKeKPQLWRK84IKgCRsAL2nVMl8s3wFy/adf+gw8UfTmLRksiW5uy8NS84ZCPzlH7uzrzLHKsyu0oJ7TXB5ejU8Eo+A3BK8KSukjfDwY1JNW9dxl1m/uyxnTx0ccRHuvByVud1VUS8xzgE7LISHyKHQdOigaTV1szsI/FF9S4a4JHzapdhWKGj3xWgvyxonLE0uOYKWDcgEtWR4/5L+/S3B0XVOY7SP2LFojLe/QhYqpzRZkDMzFovFCe1P96TLQzNl3l6x87QqhSCLjLiwR+y9yyphAOewapQQLkUwwIkbkBTvugc5tsMOtPf0kzh8M8eZCmMPmkJb0OBQhVUfrCXdCqLO8s2uEbU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a27cec-a5a1-4b1f-e84a-08ddaefd55d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3828.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 06:48:44.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpSpjyfKQuvU5VvoMuSD/rmcvGT9UXtd0LMOLW3pmZ5twG42MPvwmMVlklHSL+1ecGvDLe+GozRl5E1N3Oz65YsN6nGNoHo34cWcM969sIn4Y5kpQbzIN50yIDrGiXcI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-19_02,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506190056
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE5MDA1NiBTYWx0ZWRfXxh/2UW1PY5Sm Os5imqufXff8T3aSpRNSIuipnxeVGRK942mdhk3a36kRE2KOogU9n6RAfsocGXst9LNBuMiExGC M36P57V2HZ7w+LcTSC2hM0Zxt+tUqF8TI5S6tXv1oxop4YztwY3ve0EkcUlUvav7t0IqLd8kNt0
 hV4IT4gpiwxqUZ9DrfOYOh0NQ/4J9VQxShPOYDN3EwCL3Y9+KxJbNEZMxp+U+vFgfPKDZCr1gJ/ xmMKeC0ASDTKvrEmVYNB81gK54B+hSQp+WdlRFQAp9ucBYl16X+TBDk5FwfmPumHvC3Jy9GKuvt 9C/rsaTk38c2nWkWSipU2XGjayzShGZWnu2Kt0Uzf9Vk61KIL8RlTqVKZphw8XhrUAaE+AblzsD
 puQxmybTh9PXI32xzJr1U7F/bmuhKINqd9cR/eEoQ/vWiFb5VUD/JpdGtwa+OAtSXlNb4Y2P
X-Proofpoint-ORIG-GUID: eU1B12lgGe_sdx2LRblfwDaiex7yuHUt
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=6853b2d1 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=NAwWG0e-j77qbkYhR88A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206
X-Proofpoint-GUID: eU1B12lgGe_sdx2LRblfwDaiex7yuHUt

Hi Greg,

On 17/06/25 20:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
