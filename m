Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011068.outbound.protection.outlook.com [52.101.62.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9FE39EF24
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905146; cv=fail; b=CyG8pphqX0kvrUK5ccGF+6OCuMXa2YpzblgAYDnuhaBOENvEPOlN0NylrfHaCZnPMOuY1TJ8KAA1ZwYOUFfIgzxwLmn4llfAVbhfTWfv07P6XpCQZtTbDkAzkhMP39XoJB5Ov95CGK3+jWDMzstflRWfrhUOij1MLSHEHcCmUJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905146; c=relaxed/simple;
	bh=priGbIph4nbNNzLxDhNd5v8kQlHDo6Q7pkay5iK6hg4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RSNNXa4E92uycaebLH8DoRk9oKcRU8nzRqa+arwombxL5SSG5bWcGgFRAEXnzBJqaa2WiaS0w+mWCV9K++8absmKbdzjxSsJYB8yxnkDqYwGkV074hrVuZkeGaR9asSeZbGiUaJHJYvIJIXcrSuuDXl9rb3xHHFgJx2O+mz4m24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s0lnuFox; arc=fail smtp.client-ip=52.101.62.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s0lnuFox"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBGBBucdix2ZMF+GTLpWqYd4ucRRnd1rPsWR5XxqaYQ9qkA+5xTJ+mOUpFLcG6LgI9TYm3jxNMxSyz17EiMmcb1ynDYbFs+4ibTk6SED7uJvWTky0VdvyHaBgS12xM080qX5x94IbOB0cShdRSHs0Zzd3848iHYrOgqx4O0RJZ655JwLhHCVBIWhSZGVt+BpJ2CvGpsVMG+MI8v4DvpJ/+Tpz6HbO7TOMsXU8WI2axzlw1VrpV1SUodbPEj0VqFa7Au78T/r73Ng3hd423ZYIACTg6Qbhpp6ygBvmQz1j0YzspSLDJZAFyvjKQXBPQ0/c0rsHOMMwph5jd0ZPAsYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTD5mqTx0NWc6qeXEYoDupMEZN9iHAivdmSDfbH274E=;
 b=WxCa+BEMMckJES9FM165RmEel+C1jaqE9p10+k3ICNZA3S0ppa/VMV3b6SIivW3zX1ln5I3EKwck3Bq394KjHYHCiXGRtGi6Jv3s/8gjEyEjt2JkrmKhog166P/kwEcQasXNes+38eJnvqZmyS/cGfN+mgazuqcuvtBlvo/2wrtS/oD9Z8FS84VKxii0sIu91B6s2H5HtQW5n8ggbaKv4EZEouaAYJU7QDACHamr8XibT6WSdVJimHF0liWXpPczhzuFwLmAMx6xOxR79B5CkreFw+RgzmZAEwgZApYwJbAfIkH2XOBpOrNa+LI16y6pMIvLGqgnge9jdAU+xEooZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTD5mqTx0NWc6qeXEYoDupMEZN9iHAivdmSDfbH274E=;
 b=s0lnuFoxKbPoEyYzfcKQYUe1xqtqSyk9b0DCcf0UZKdItThCe3GOYtSps0NkyrJ321mFb3XOO6TeY2dnRkzshDfLk3fuqVmJjrlZhdORjOF/6Y4YuysJuOPnDbBd04LgsrjfI+uJ2HsIulfcvV0L9yWN58oTQG9hOYUFqiPNhSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by CH3PR12MB9195.namprd12.prod.outlook.com (2603:10b6:610:1a3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 21:12:16 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9769.014; Mon, 30 Mar 2026
 21:12:16 +0000
Message-ID: <f1adf0ee-fdd2-43b8-91e1-1102643afa49@amd.com>
Date: Mon, 30 Mar 2026 14:12:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] dax/hmem: Add tests for the dax_hmem takeover
 capability
To: Dan Williams <dan.j.williams@intel.com>, dave.jiang@intel.com
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, stable@vger.kernel.org
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::23) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|CH3PR12MB9195:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c85fd4e-9c60-41bc-f1e1-08de8ea10513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	V8znFhPWq2W1krUY1/R1Ouvo2ui5xBeNxyrO8ZjlYa+hFBnwU4BbCac3viwLxInZ3NhdzxHs3waz1GafsnJgul+zUf0kxhMqHB9LecrAJAd0/wlJFEtId3G2E2yCP+FPqXTlA+0pqW84VnZTZmNTU9OEdv/9g/BNfc5Xkx6Oe8SCZgnAKHG8G+ekY7TaHQJhpLYnnlwxZ8ypsceoHLIs1/rhqW0BqJ4KT7XDKGbf2AOvl1LsVSUDRLhyGyWGVIVBwG4MPHKgRLGpCeoWzOXXTD7oe3YLbfCHRK+gRZHyw7wWva7MykhWwmiSUsqB9rXA9YeasYjJqYSEibbqvMZI3/d30006owEa5PeE6fJLM9hyw7L42kxaEy9QSFIO4jVsqgoJnpTns1exbZXLCNUtTjLR4ypsiLqT6rLiHQgZQ5z6ek6nt4A6YyYxAJ5370+/ErGbwMBOv5uRSMU09LWoGRwqmgLOSH7wvIs1A4IhwQO1wusyA9F+5U9C1q+MJQCHOusdQ/nnNCouGahX2wHCAm0nzON9uUy5k2c8vYROUyYk0jj+nyxolTKdvscWEXUJzWSAX7GdsrDKYMeFF/lE/cTQxYbP9UrCUA2Ak4aMgr+434YkEVQvUI5lJut7xy54TwxJg8XApfx3QX8NrjoGtPfXIl+cWPmsHzGh/6uZeb5y83pr57CXl3GQm/+5LMc1p9cAgliaHrDQvVqfx7+JKLNBtdi7q3l8yQ4eMV5iIYb1v2acdS7jdHgjKRH7n2qq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmFGdnFJV09qbFNCMEVQQ0FoclZoemxNQXZQZHhta1dteEVvRnZHQlhoR09O?=
 =?utf-8?B?NHF6OGZBY3Fxd2NVcE9JR3ZBS08wYkRuWm5wZnNVMU1tZXI0cVFKakx4OXVw?=
 =?utf-8?B?ZlBBK0JYVWkvWWFUbjAyMTdMb0ZiOUhMd3puTTJvdE9Sc2d2OXFveW1oOEU1?=
 =?utf-8?B?TTU3NGVRRjZhU281T2Z3NjM3NkhUem1VQjBIVDY0Nkt2eTczaURkNlE5UmRs?=
 =?utf-8?B?TGVpU0ZPQWorWmJjc2F6czNEQzFmMVdmZlltQnpMWmYvZWZHeEpwY1I2U05Y?=
 =?utf-8?B?dVFnYmhabnZQMHlydHRGclhYcVUwdzBqU3psV1RJZ0d4SCs4OEl6ZnhQR2sr?=
 =?utf-8?B?bUp5K2c3OFg5UmtWdytaWS9GMHBMdXBwQjFiR2JaNmVubEdGRE9qSGJDNmRW?=
 =?utf-8?B?dEJ6V3UrQjloOEQwVGZ0ZENub0Nub0tmKzhqY0dLWWhCTmZNTm1tZFZHYnoy?=
 =?utf-8?B?YWIwOEUxanJnYXBsbDFyZDVOcmdyYkh1alJNVjFlRDhjRGMwNkxrT0c5eDlx?=
 =?utf-8?B?UmN1NTFDNmN5N0tNZENlV2EvamRRdnVRUlFVbW52R1hvdjBxaDNuWjIrOEt5?=
 =?utf-8?B?QUFMY2R6UGw1TWQyUXcySUZFMHU3MEpPdFo5aVFaMEcyRW5XZ05EWjdWMDk4?=
 =?utf-8?B?azFnZ1dkWUZIMFBHR3RUbmNjbng2cjYyWXVhNE9kVGVLMDNPVU1hdkFKOHdC?=
 =?utf-8?B?SEdkWEhTcWZHMUFSci85S3UxQ3E2NEpQckxTVUc3MkE2M3hJQ21QR01Cczla?=
 =?utf-8?B?SlBSbUs2NmFHcnExR0ZrWTF6NDdITXNKK3pwTktPRzNkUjlJbzNVdHhuRUc0?=
 =?utf-8?B?THZHYXMvODZpa21yZUpzekJDdWYvZDY0WStIRFQvV2ppU01ickdlWkN0clFX?=
 =?utf-8?B?RFY4amNjZUpCSlpmTFQrNE04blc2QjQ4V0xna1BoNjBCdzZWMDBKa3NlanhB?=
 =?utf-8?B?NGRmcUJCVFF4WUpiNmp3dnlyL3N3L0RyZXd0SzZYWlA3d3h3OWtXdDRYWEJV?=
 =?utf-8?B?STBFdDh1bVFQMEhJYXVvY1ZjMjEvMGMydTdtdXlVanBIWlVERTk0UHUzMWRx?=
 =?utf-8?B?ZHViVEl3Z2NlQXgyQXRyWC9pYm5HcVlkNTRDMlFDMlpqcnoyanVDUFd2TjhH?=
 =?utf-8?B?K1FzT2RrUnp4cXg5VzdNWlJiNm9GakhYTEVQVFlQQjc4ZTRlczNlVzNiSjJn?=
 =?utf-8?B?Tk1aZ0craDNBemFNNmVuOThGRkt6OXVHUCtDZGdYYkVPSjJmSkV3UDRsa3M3?=
 =?utf-8?B?amNNUmlTWDhUNW1HSlhNV3crcTZhZDNyTmUwejBnVEFwS3dIWUlKZjU4aWU4?=
 =?utf-8?B?NWY3bWNjWkFWOUxla2xEVFg2WndQOERGak1vZ1JjQXp2d2dzQ3VqanBkOUdX?=
 =?utf-8?B?Yk1UOXBPNmNSdDBZOTUvWGhFamtHT1kwdEYzbVM0Q0E0VWpiMGw0Rjc3YVhq?=
 =?utf-8?B?ckUxTGNzN2lZT2dOUVlqeUxjaVRzck1tVlFEU2VkbHo3QTVVUHlyQS90NkVq?=
 =?utf-8?B?eDZFTVl2U2MrY2ErS1loTEYySVBFN0hsRXVHVE1YWjI1UFcyVDVpMFFMaFYv?=
 =?utf-8?B?cEJuWlNkaWR1WGJ2WWQwdEIzTUFsUFd0di9veHJvNGk4QmExWW1FL2NGaGV5?=
 =?utf-8?B?bWUrK0hZYXBMelFrUVZ4anRreUtvNjlDR3pvTWI3OUNZRnExVkQvVVZ3Sm41?=
 =?utf-8?B?dEJNNUV0VkVCNFJZaXhpUjZMQkVRZmYwZTMxS2lFbGw3K0dmWWRGNlR0NkVt?=
 =?utf-8?B?UTBpYWxtMmhsUGY5K0xEbUlZc1Z4eXZ0M3NOQ2xGand3eVJwQnA2elFPRkdw?=
 =?utf-8?B?b2RjYU05WG54ckhrSkJsa3A1emdWbUwrMjdSV1NkUFRvYnF3emtseENwTFFz?=
 =?utf-8?B?V3N5UmpZL2tSSDViTjA2b0NVTnJLL1pxTm5Oa3doTHZrNHIxbHNVNy8rd0gx?=
 =?utf-8?B?cFUybVJMUERWano2Y1N4QkhNRFVzcEFFQ3NZUlhKeUx4Z3FldTVadE1PT21P?=
 =?utf-8?B?Y3dQRHNwSDlIN2l3V3ZwU05WdmFTN1JkOCtEam1YMzk5UUxRMk9vaU5JMGx2?=
 =?utf-8?B?TXNjT004ckFBbUc4RlN2T2xoaDJuZ1lVajFqNzMwa2hsd0lHbWxKMmMvM3BY?=
 =?utf-8?B?WWYzckVSb25Mcms4a3VEYkxDQjFGL1g5aElnSm5wbDNVbnlVY3ByNXRJajIx?=
 =?utf-8?B?K2pRWHJ3OHEybmgzck1HNzhaZHhaNEZxK01DMW9WLzJROUdlSHV5TCs3dFl1?=
 =?utf-8?B?WU0zTERxZDZ0eXM0OExFRXlveGVKY0d5NU5sRDdQNG02dEVXdXRUUzQ5SzhY?=
 =?utf-8?B?TThrQ2tQaFhyc3dhTEtwZ2ZaS3JFTVRrN1QyNU9MamZ3b2xROFVldz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c85fd4e-9c60-41bc-f1e1-08de8ea10513
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 21:12:16.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNn+4/m2KdKTRTqh0rftQxYUO3jn/Yfe58TFYEsijoJplRgoxl1/URo5jn5f7m5a+ihqLIzr5nTeR5Ems4a3sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9195

On 3/26/2026 10:28 PM, Dan Williams wrote:
> Given all the cross subsystem dependencies needed to make this solution
> work, it needs to have a unit test to keep it functional.
> 
> On the path to writing that, several fixes fell out, but not to Smita's
> code, to mine. One use-after-free has been there since the original
> automatic region assembly code.
> 
> Here is a preview of the core of the test I will submit to the cxl-cli project:
> 
> ---
> modprobe cxl_mock_mem && modprobe cxl_test hmem_test=1
> 
> dax=$(find_dax_cxl)
> [[ "$dax" == "" ]] && err $LINENO
> dax=$(find_dax_hmem)
> [[ "$dax" != "" ]] && err $LINENO
> 
> unload
> 
> modprobe cxl_mock_mem && modprobe cxl_test fail_autoassemble hmem_test=1
> 
> dax=$(find_dax_cxl)
> [[ "$dax" != "" ]] && err $LINENO
> dax=$(find_dax_hmem)
> [[ "$dax" == "" ]] && err $LINENO
> 
> unload
> ---
> 
> This builds on Smita's series [1] pushed out to for-7.1/dax-hmem in
> cxl.git [2].
> 
> [1]: http://lore.kernel.org/20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-7.1/dax-hmem
> 
> Dan Williams (9):
>    cxl/region: Fix use-after-free from auto assembly failure
>    dax/cxl: Fix HMEM dependencies
>    cxl/region: Limit visibility of cxl_region_contains_resource()
>    cxl/region: Constify cxl_region_resource_contains()
>    dax/hmem: Reduce visibility of dax_cxl coordination symbols
>    dax/hmem: Fix singleton confusion between dax_hmem_work and hmem
>      devices
>    dax/hmem: Parent dax_hmem devices
>    tools/testing/cxl: Simulate auto-assembly failure
>    tools/testing/cxl: Test dax_hmem takeover of CXL regions
> 
>   drivers/dax/Kconfig                |   6 +-
>   drivers/cxl/cxl.h                  |  11 ++-
>   drivers/dax/bus.h                  |  15 +++-
>   include/cxl/cxl.h                  |  15 ----
>   tools/testing/cxl/test/mock.h      |   8 ++
>   drivers/cxl/core/region.c          |  68 +++++++++++++++--
>   drivers/dax/hmem/device.c          |  28 ++++---
>   drivers/dax/hmem/hmem.c            | 115 +++++++++++++++--------------
>   tools/testing/cxl/test/cxl.c       |  66 +++++++++++++++++
>   tools/testing/cxl/test/hmem_test.c |  47 ++++++++++++
>   tools/testing/cxl/test/mem.c       |   3 +
>   tools/testing/cxl/test/mock.c      |  50 +++++++++++++
>   tools/testing/cxl/Kbuild           |   7 ++
>   tools/testing/cxl/test/Kbuild      |   1 +
>   14 files changed, 344 insertions(+), 96 deletions(-)
>   delete mode 100644 include/cxl/cxl.h
>   create mode 100644 tools/testing/cxl/test/hmem_test.c
> 
> 
> base-commit: 51d2fa02c0e4b3b23c4484f2af9b6d65c35471e8

I tested this series. Its working as expected for me. Thanks for the 
incremental.

Thanks
Smita

