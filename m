Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DAB347BD4
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788036950; cv=fail; b=tQbCPSJSXj8a+/QILoutj9iggPgFg0NxJxxy41bK97+yoGFcejbuy2vy8bmvyzVC5vP3858LJ+U4BGM7NGLyUcN8DRdkKvSkfVtrPC70pl1enrIH/uSZPBvgYPs78m5igXlWdva7uQeLNjIRelcbSdhhTuuRBy2nf3Wj2ijlM1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788036950; c=relaxed/simple;
	bh=oM4ap1OQtV6ss2oQTpP7AbMD2BtAtju9IW73tpIjnxQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bJ55NeqYclQr9eoIp5tvb9La0QvfaNaVjhSmvkHssoKKURUpCoNkiFqbrKXKgdUigGZTHOJbOt2WRfCU17ftS+EZCf+UzVlApyO0iilOHD9gow8o28c40TkdBYLTcmDbsLLfXbnWZ19h0wwvI9X3DhIJr+JIBsb0qm3nMEBEF2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kPvZT91K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QIr0B6zO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kPvZT91K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QIr0B6zO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TKfvUv1654009;
	Sat, 29 Aug 2026 20:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mr2HfltoXAETl1WpfEaTs47iEwRS5M2JBgV01Oa3LaI=; b=
	kPvZT91K5XFdGebxR4lnWVJa6P3CPFmd8gIl80Oa2M9OYunYpPodebs+p7yDm4EY
	9bW0zZU0IbtULBTcWHzDpI0xYsfHG/gDp0oSBnG1xDcQGYpX4bHcPwwisrfO5LhR
	aEKC4GRAI1XwjiuGH6Rj/PxFlwxrfvLHD1UURU5o7aF5lj+schU8EYCsyDWcrLRD
	fvHqaFIPpL40BiML6qrVMfmyY5dMoJAXkVcv0R2qsOa2jdwgGq4WxBCVwZddJpTz
	Pq+iJetS+mP2XZIVdIq+ze2qGZsE1n0j+m7UW90g6nfvrJLRRZTXzzjpxYa2KKCF
	XWNUu/Zi/RCjyNplOY1Geg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp728mvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:55:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKtYjL039208;
	Sat, 29 Aug 2026 20:55:44 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010035.outbound.protection.outlook.com [52.101.201.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvn82rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:55:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hStx6kQ7Rzu6qZZBYlQfh1l5l+Dx12lJuqiAAC20TjdUJBKZ9FYLLAXSNA3+HVAsds+GaMBReJ3YRmIeDcH9SKfQ+CAzIAOgGr/qI4qRSOIQKBzRDVx8/DHBMI85F+jUHvSJwkOCnNs+ztUHLTgIogMKx6/PJ1CcPuRpqxyTiPXsAsxKkdpp7vjH24Zoo1A42im8uARlJuOhFZduyLgnpBSihMmNtypOiVXEpNeZI2KiksU7liLra7Q74sZd1/nfiK3UT09+StB3KqWWhN3EgW6F5xhZrY7ayyZlqyDEEEr4FF7wqvZmACtOV3QCq1jc9+r0Mk1oo5uQYEWsAc2bbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mr2HfltoXAETl1WpfEaTs47iEwRS5M2JBgV01Oa3LaI=;
 b=ik3dSpK9me290io5xqvTIvkMsPNGmL16HaiTC2DVxGu/r/WX86YMRxDzcAO03xzI2DVqu2FI22yp4BynF65d7PangQpWdV0MwsTss0Pcf+6IaJpRoeVoHyueYdal9myH3YzaS77AZBZbWzTQvWSyCXEDC4nhxjqQtKHXvGVkcNMyUy8g7SOGhqFidIV4yX5wV163aXEfXs7kbsOllcOuecWVCSpzbUnEUg7znZS5J4wlw5A/iy+Wu2DQWvyCDSYtidp7cwq5I8kPjzpmbMlsvB/1S7C7buRTgfbkuO/xuFCR6cjiLTazRa3KrpUGSadvprcO9o7Tm/eU5nybq224lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mr2HfltoXAETl1WpfEaTs47iEwRS5M2JBgV01Oa3LaI=;
 b=QIr0B6zODnpkSSxQm0f00cngDF9GocmJLeuqEq02SoM1xp9iwfL92jqlYnvh9BdgWnyar8nbnLpjU9HUZ9nH8zkK60Ggfi8MO1Mjj/pgPiNVT2NHxSyqPSxy555PIpRJIXGyS5tfyxplho9jed4zPYYug7tjllLw9HtrDnRQZh0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA0PR10MB6915.namprd10.prod.outlook.com (2603:10b6:208:431::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:55:39 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:55:39 +0000
Message-ID: <80031e30-bf30-4bab-8e78-54a43829ead8@oracle.com>
Date: Sun, 30 Aug 2026 02:25:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 224/272] ksmbd: reject repeated SMB2 NEGOTIATE
 requests
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Runa Takemoto <takemotoruna223@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145231.229664293@linuxfoundation.org>
 <20260820145238.319858354@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145238.319858354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0009.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::8) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA0PR10MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: bda65a7e-f1f6-4023-ed9f-08df060fe1cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|4143699003|10067099003|5023799004|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	6iwosmDT4thIwG+isi2w3oHgLTfU5YUG2gSTRnnk2JWsSeitkRfKLRLchDHDetQW4dYzzR7EaUWq5ela0eM8Pl0I9gp81x5v64jDMln6X49eoFjBtOquYAtSMIvTGq3mwD6nSBCK/2KTJrNHxT+zovypbVO1f5uOstIq6cPhfdLZDykjkQLvc/DiMovxlwMhCfFCSeZUyOlmGWoOudUSB5TlTDKv1CqV5030VxcckfJeDOuNXPXQvt0r8e72T4eYWr8eIkvDzptnHsEkhti1GYctcfmglfdQ6Zv0WHe/vgz5PC25RWawED+FBWpj6WtFO9bC88mqniPbIqZMmKsV6hNeQ0hJRzVsGy+qa0GbTZ4xHB54rbq0go4JBBiIOzHqJtkoAGw37qwb/cM2fBmFfnQed47tUbsy0ATFF0WdaF+5USBzq6WddGwWHFcxVDqnA0gIzfA06lX4gr9UPIOjKYoCt7SUSaTusYDLjLgqCYddEEm1iFkUkshZcVZUZdHgYQndcWQcea8r45mi6F54iT/qsP3oVpP67IP7D6Qi2NEAEgfoDlt72uc2O3ZH7RHYjV5a5dU21TtkKBi/NNnvz1Rs2LbSWRGL00KHjRi1iroxpqYjs21Vu5qiRvP1g2YBgvf9ctE3JIwKuan6LLI/k5JqxP5iRcA+0MjzDEeWFu8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(4143699003)(10067099003)(5023799004)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHIwM3hvK3ZNKzg1N3hPOTBTeStpVDY5U2lid1N3S3VWaU9rRzVibE12THpp?=
 =?utf-8?B?bFZFMytkb2dZMHpmSVVEV05xNEg5RWtRS2huclVWMU5tUjU4Z3VER212V3d0?=
 =?utf-8?B?NlY3NTlRcGxMYlYrTVMzcSs2TnQyQmpxZExpLzJxbFk4eEVqeU04Zm53L1hB?=
 =?utf-8?B?RXl4aHJxaUpTMVJvSXZ2R2dBd2VGZkIzZmhLb3k1Z1MxeUNnZjZPZ2tmSWhs?=
 =?utf-8?B?dytPYjh2djdPVXlkaXZUYllBYlZXMmszb2JYc2RmSlhNaE8rQTFqRTRtUGFw?=
 =?utf-8?B?TE9EbkxzZ01TMllMcVYwc0FLaWdhMU5lL2IvcDVXTVFRWlJKTVk1bHB1Mkxj?=
 =?utf-8?B?eDZRemZ1eTJWZWU5VmF0eTRFUFEvckZhR0o3RkJSdGhUeThZd2VNNnAxOWc4?=
 =?utf-8?B?QlBud1BRWHBrY1MzTGNKYVdHck9NbG5WNU5lclFvYS83ZlQ2VjRyVWxRclJU?=
 =?utf-8?B?Vi8wK05GcksxYjkyZk1QZTM4SGJ4QkVzS2xRR1Y3emdGZG1WS2tnYTkyQVgy?=
 =?utf-8?B?WFM1aWZqMG1WK2MvdkxlQzhiSXdJTHVJcGM1a1p3d1N2YzhNakRyV3V5OS8y?=
 =?utf-8?B?RDA2ZzVENXV3RFNscG1LMUVoV2p3VStRUnhqNFJqVVlSOHpBNXlJMEdjcXg5?=
 =?utf-8?B?NU1sdVZRSFo2OVZaN1FjVkhJSVNKNlpROE9lQ3JOeDFPbmlDTUJRbzF6dTV4?=
 =?utf-8?B?Q0s4a05la0J2bmJaRkxqQ1g1NzZDRnM1MW1LU2puQXQ1OWhPZkxibmV3a1NK?=
 =?utf-8?B?SXlxVGJZVjNQSGdsQTJlK1JqZ3QrTE0yQ01sTFlqamxFaWI4RnlNWEhvVWZm?=
 =?utf-8?B?RTFvVE92Qy82WUx1V0kveEhEOFd4QWhvSU1qS3RDaWtiTVRwTkI3V2h3alNG?=
 =?utf-8?B?OXNvcXdZWXU3QVlkL0JPa0FUaDMzVTU2dVVHNUFVa3RqaE4xL244TzNTMDcw?=
 =?utf-8?B?VUdRbFczaFNXOGFDQlBpSTY3bFRxbUFGYTZsUWxvdUNtZnkwdnphMTFWOVVG?=
 =?utf-8?B?NjZZU3h0dmx6L1BKVkxabmZSanU5TzN5aVd2ZWpRbE13eVBMd1YyenhVMm0x?=
 =?utf-8?B?SEp6VEtlMnVHU1FoUUZoMmV4Vm52NXVVT0RNUVpuWmd6VmtiRjJpRUxMZWlE?=
 =?utf-8?B?a0RTUTZzdENtWUxPM2Y4VFQvZ3FUR0ViQitLUW5GaHhHSjhBc0FLbjVHTHEx?=
 =?utf-8?B?STcrN2wzWUFTY3dRMHNUbjRJTWFUdFV5NnhrcHNNdE9uU2QvSHlzWlljS1Vl?=
 =?utf-8?B?N0U3ZnV2MGY0QnF3MzJjZEc5WWRkcWNaaTErS3BaSWRGemRTNloxRmJZdkl0?=
 =?utf-8?B?UStwbXYrZVZwcjgxNXpWNWd5ZkVRazUrd000Z3NwTlFWd1ROZnJyYVAyZWpF?=
 =?utf-8?B?TzNSOHArSTh2Ry9XbXRhZmNSUS9UWWhWY1NiS2h6UzYvd2k5eWx6TFYxUmd1?=
 =?utf-8?B?ZHRRdThXQjNDbWkwR0xsTkVxaUVnNjFjZzFBY0hjQmMyV2tqN21DMk10QXU5?=
 =?utf-8?B?WGY0eFNtQ3BXZDgzSys2L0VXVEphenBxZW9uZldNN0tWQU92MlppcVVyVDBP?=
 =?utf-8?B?SVU2a0JIYm5FTEsxSlVFRi8xT0hHeHJJMkdteWtZMkxwNXU2cngrQzBMZWRu?=
 =?utf-8?B?SGtLVkhXazZ2QXZsVWNqazRHYlhWRXZpcCtjS29UUnFEeW50VzhlNS9Md3lJ?=
 =?utf-8?B?SWxhZXlJaUsrVE00aHNFR0pCanF3REg0MnJvVGFYNnBhN205VE9jYlZzaXBY?=
 =?utf-8?B?TDFiT1BTc28ralZWRDlUdGdoTzNVanpHTGMyOVZsamJ5Tk1WZlF5WUdwVXEw?=
 =?utf-8?B?MmxxVzllb3h3NlIyek5Zb1pBYjR3RnBlSWpmS1FmUVlEa2llZHYzLytueFl0?=
 =?utf-8?B?ZHVOeTJ3T0Y5SHZYL1FzMGlHeHBlVjlDSVozNWpLalV6VE9BSVh3QWtCMExk?=
 =?utf-8?B?bWVkYkFyZWQ1YzVMUlkyZ1dUZHRYL2w4KzNVTWtiNFJjZ1huekpFSGF6eDNy?=
 =?utf-8?B?S1dnVEFJV1JHUXFPTklpbG9mRFkrK25VOVdtZFhxYWNzN0Q5TzlDYVhiNDZj?=
 =?utf-8?B?cVY1eWZROGdjYWd1RkMxelUvVzRCVTBMVnh6OWZKOWtUUW9TNGE0dlc2QzU3?=
 =?utf-8?B?RzdCbUxqMHZLZUE4bVBFMERvV1Q1Z3NUcDE3RXVzYnBDd1JFTzd3MzhVWFZ1?=
 =?utf-8?B?MWxFdEhZRnFpTjU3MWYxek9KQmlldnZFMHNPL3g0K2t5Q0ppSHlHUXdxQmJR?=
 =?utf-8?B?bWhvdXNjQ3lZcmhKbGpCVU44NDNac3hzRG9pT09wRmJMNitRMk1EQnFZcU5h?=
 =?utf-8?B?UnlONXpRU3FueHp1enVBc0swbm5HUmNNa2dCb2thVGpxWHZ3bnVCK2dzRG1Z?=
 =?utf-8?Q?sHdYqo9q3DrrWnwWS8XvP1ivLtkPyNw/v3s8k?=
X-Exchange-RoutingPolicyChecked:
	bZNc5WGnzEEORRRfkrncu61HFyZkyfi/ibvhcSHvRKf0rEx7q0VVAhWv2JJvQpvPIBL6bsXMZxXD8PAxpFm8PmP3pt2sNOEav+GMkgAmJQS7V/+Y5aOB4pQLNsMNGHi2fHhqisXF6jSvN8Xt9kIadnZOebZoj2aODOGM/RPDExJJjx0tzO2pecF4kh1M1dstw9mno9DEOZS+NtaXmTU8USs5aWwSRw+Grs7sryVTQG+DYWwLJRfR54F+2ipD2cy1/ATvfZQSTuExCeOrKU0J5uL5GE2fgK+XlSF33rSgFhC/Q95G4bAhmpKJ9Xp7by2hMsHfLxB96f/Aj6BE8FQSpg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wYO/MGDaP9rriaNiLoMuPwPw05UnxXeDKGqJwQJzJJH8jxOwNuyJLtEXohdN3vpJM812O949avRKhlHaEYZlkd3XHp9T9ojeG8POiDOH8sbj3M4YdRVh2fSp2QgO3T1MbCkwJrg/9quOUBNzYvrFhJ7sDI5H5UUHna1ywhncG4QNG0OIw9b0Q72WGgSFNNxTC47d2QPSwyb2jYu80JyxFWwT98UtloW4SfcdiomMUDKZA3QVk2+MnfAgjTQ3tcOM+D26LSD8AOw1kQDvFynVTzqaBgH67cMHtOSpVDoFqOjvjlz/pmCa1Z6OREL6ijo06j9dJzjuJ7eoqu7m6Ec6TpmnFdu0tb1LCm/kgMfLy5/kdoK3i42ICm78f1xMZhFReg3OJJj241SqHynRAupqyD/oht5qey3nAu/ch0MgXHicmgZZgdQWYwGqUlUgxDFBwwUBnInMpmyE55d3C29dEP+pJj+OYVow7QMc9pOLro3dkIU4o+GbZdSjPEop695qFWB3bHjVpQ2brucsm06xBgn7+RS0kSFWFsYhDNXq55IWa6sa3bC3yvLeXAkBF5a6KoxMY29erPtfwuk3zHMawsvVIQ0DkVCLZFATydlY9Dk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda65a7e-f1f6-4023-ed9f-08df060fe1cc
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:55:39.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPSiL2aCOGi2iDCw+ps+RY1OPv++yck4OP1YV/ose8jWV6H2ZPh4ICD2NkjJOddd/8jxmDATj3PBRwbZX0zC/dubStbyllxRsuFG95BgADlmckt2/8M84HdKzAAFaQtO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=855 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290181
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4MSBTYWx0ZWRfX9SXtw2coau5V
 Z3qMn0ZTxRx+Aau7K1rNxK/QIx4zUBJtdqifmEYCMBIUCrBacnej/ac/A5IOv3Eh8ZXUDIBZmgU
 KQ0Xfp+BjIVyuayrvZbextKykCKOk0ngj2vFZh9syobpqvOY6TOp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4MSBTYWx0ZWRfX9rv+nEOgi/6p
 fn4ltX1ASSK5kBp4MXqdEo4UVxROzEP9YxeHvxJK3c/VfBZvEbTxJgf/CiopD52MUSSj/gQNfz1
 2oNI8B9fecVUg3d5FitU2+m+SHNPoe03CUExWAJcto/+j4PrsBdt6sdfGIo6MK1+0GJ6DPysc2y
 Af4U59jm2HU/+WKcxjS023ZFGHdhLqrGnMyDLQl9aMfNWs2TMkuI+K7UeaBxMlUfZGb6bGdD7uc
 9dJf48qeL+Tgh65Pf7euHl9ZUWLC/XR0AlZ5caTCqyJ3DjspefxW55VSLbfK57CrS71NGXCj6Yy
 mD0KKOfblvU5wH7GzhYbjtqDJMJBgsqmYYzIKMOX9bO7VmWRwxaxhfiwC+K4ZB9A9yRjHHz4AKu
 WPU0TYxg1dd0ZjKFXPJ5H7t9Y0+zoSDsp87hSPzb5692ZLYMuhv7JDPHndGCe5qs9xijhQRm4bd
 +t02Jh3uaQRDiHAyqBz+KB0EfKnHAe9zbev8Rkqo=
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a934751 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yMhMjlubAAAA:8 a=ag1SF4gXAAAA:8 a=xpdv_bLa9Fuvy2qmzEIA:9
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: ntkXggUyDzK-PwnPpqIBGCA_6R3oCIyM
X-Proofpoint-ORIG-GUID: ntkXggUyDzK-PwnPpqIBGCA_6R3oCIyM

Hi Greg/sasha,

On 20/08/26 8:26 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Namjae Jeon <linkinjeon@kernel.org>
> 
> [ Upstream commit cb469993b3a61a72653770856d37af616d72d05f ]
> 
> Unauthenticated client can send multiple successful SMB2 NEGOTIATE
> requests on one connection before SESSION_SETUP. While the connection is
> in KSMBD_SESS_NEED_SETUP, smb2_handle_negotiate() accepts another
> SMB3.1.1 NEGOTIATE and overwrites conn->preauth_info with a new allocation.
> Only the final allocation is freed when the connection is released, leaking
> one object for every additional successful request.
> 
> A repeated SMB2 NEGOTIATE after a dialect has been selected is a protocol
> violation. MS-SMB2 section 3.3.5.4 requires the server to disconnect
> without replying in this case. Set the connection exiting when rejecting
> the request, in addition to suppressing the response.
> 
> Reject SMB2 NEGOTIATE unless the connection is new or is waiting for the
> SMB2 NEGOTIATE that follows an SMB1 multi-protocol negotiate. Serialize
> both SMB1 and SMB2 negotiation paths under conn->srv_mutex, since they
> update connection-wide dialect and negotiation state.
> 

I ran an AI-assisted backport review and then checked the finding 
against 5.15.y. The repeated SMB2 NEGOTIATE fix in 0b1390cf2b6b is 
incomplete there.

Upstream, after c8b5b7c5da7d, a successful direct SMB2 negotiation does:

         ksmbd_conn_set_need_setup(conn);

and cb469993b3a6 only permits another SMB2 NEGOTIATE for a new 
connection or the SMB1 hand-off state.

The 5.15 backport instead still does:

         ksmbd_conn_set_need_negotiate(conn);

so its new !new && !need_negotiate gate accepts a second direct SMB2
NEGOTIATE. For SMB3.1.1, that reaches another assignment to
conn->preauth_info, overwriting the previous allocation, while 
connection cleanup can free only the final pointer.

I think 5.15.y should take a branch-appropriate backport of
c8b5b7c5da7d0c31c9b7190b4a7bba5281fc4780 ("ksmbd: fix null pointer
dereference in alloc_preauth_hash()"), now that we already this patch 
merged in 5.15.y, we need to think of a way to do it.

thanks,
Harshit


> Move the locking contract to ksmbd_smb_negotiate_common(), where the state
> and dialect are selected, and add ksmbd_conn_new() for consistent state
> access.
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Reported-by: Runa Takemoto <takemotoruna223@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/ksmbd/connection.h |  5 +++++
>   fs/ksmbd/smb2pdu.c    | 10 ++--------
>   fs/ksmbd/smb_common.c | 37 ++++++++++++++++++++++++++++++-------
>   3 files changed, 37 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index 66815e56223f1..2d675ab5b7156 100644
