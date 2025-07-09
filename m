Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5A2246794
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099804; cv=fail; b=PuQYand82d/cWNN1RJsBqV63KYhP/PtI8qb7R9Bm2iqT6V7VwHpOj4w9nBi7MBSE09hiVmmBrvLC+Y9GCslfUgSF6Xqo1DW6a5ZECp73H8XkkLQaq4FeW3AuOdpVaYLXFMn2X0Z4lk1FOs/MKSvvwPuifJdluCCCwGMfCLsFXK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099804; c=relaxed/simple;
	bh=hnXmDTAgZKD/zfII81NG8erH2aGEGq+87aq+N+cIjuM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EgllF9U3/U52P8xY+x5QlTs4NzWRO6EmYdyEzqILKjNeHWz0Emitu/qGiuvOdyiIThG4qo8ufIFERvCVrRQKrVgRYStQ9BqkebZMtnQk5iqWaQd5yKiWY+5bG8PmA6A+LlLte+uW7EWmnuWC+SttnecH4Ivn/dwKMLUEkiVZjg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdVltL8K; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdVltL8K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099803; x=1783635803;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hnXmDTAgZKD/zfII81NG8erH2aGEGq+87aq+N+cIjuM=;
  b=DdVltL8KEfDFU2kYwWLauHd4ZE2tx2gFgeLaB4t/kCEbk5F4GNeHkXew
   c43PC60Oocf3drNJbPhlXsrSfwizGIdAmMHCiSKXB67Vqx7vEOr/V9lJZ
   F6ueJQR92VFWTGlFcn3s2Zj9wLUJKTXevb7po65bdQeNLR/gpaNcqiwy5
   mv/Pe240lciM9Ox4uZ4qyur9iW3Y3eDeQCc5FsV3xJm1Awkrtos3EERUX
   2umpisrAtq4RISGeDHLAEtzrrWDvtGMzGpslU/HsyynzXwF0KDUW8ifOi
   f607gP8r20yHz2rSm+8OkAnei3Uv3RlePzXG/6KyZS65y9QqDCkne8Hg6
   g==;
X-CSE-ConnectionGUID: mcU8jXh6QJum/yWkWZc6gg==
X-CSE-MsgGUID: aaNY9BmFSNS2/PUQwoMqcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="79810447"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="79810447"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:23:23 -0700
X-CSE-ConnectionGUID: Dx9h1FY+TdiZuftP+ZAIrA==
X-CSE-MsgGUID: PfsY7qbiS1WTpFqNGADF6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="160168682"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:23:22 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:23:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:23:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.80)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:23:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RbvvX67uNDLqcMXHRODXxzEVx26drnuS8HSpZkHr2KgMV9vKDMvShHBMsmWr90WqSEUUm04rt+ijXIf1SRZy7SBOvT8GwyjDL72O+kceSRwjwG+prrNVtuZ2Bwt3gbpuNVyyuJ48ed+EGcQH/PyGJVfXt0hOuXMUASh8rWTQUqfCto9S3yuFWVxan17tAuyiXw9iQ7edfKjZWRc419GugbM6oFeaL6QdTqY7YSmY17X4abuLf58Ef2cAF6FPGxC7UZNQz7FAgiJjC+JEVSKpCzmg3iImjtQ3+nyRc65/t+F4YtT59GaEguptJNjzz+J9izEw6Ng4qRbZmz+ZestTRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DIJs8QgHcwiuJKJ86M2ptibt2dN7vkiE1d8Qm9TsW0=;
 b=XQpMWkFl7OQ//hUYIB00t+KfBoTxN3vleASgvMjLn2DahMvRfmxMSD/A2jy6f4Ya/tr2k6WV8PrKqe7yVrwGUn4KvTcktFSjECZ5BR9BB0nmL+/iG02XkeNZMvxJ5JcdXbhIZ2IQqV5atien5s7KhtLEdgqP5jJNduXh3UmKaK668xV8XdNzyjoG1tjyfy3Az8qX2kOfedo3IBEOebWodivEXCIT8MplAAvQQUa5c9MJZp6VQc5kNHjnliWD8l7WGJvOpNm04GntSqHPVhmx4Wvf0DaLC9KuD+ixf8V0WEC0CibcWEX2RyfH8TjIn1zWCCOW4y0PB2usJCVs2dnP2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 22:22:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:22:31 +0000
Message-ID: <24d61637-cfd7-414b-899f-856c9863dc1f@intel.com>
Date: Wed, 9 Jul 2025 15:22:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 29/30] x86/resctrl: Add debug info/PERF_PKG_MON/status
 files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-30-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:303:dd::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd1ef9a-4efb-4bfd-5a8d-08ddbf37189d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WFlmbmZ2Q29DUkU2VlFJR3hkcmFaOWI0ZU03TG9CQklHMG01a3ZHMkdKRzgr?=
 =?utf-8?B?NFcwa1BnbFdRbldNdGRVczdsdCtib3cwU0xocmJMRTdIc2F4dlNPb2ZaNTlK?=
 =?utf-8?B?ZktDb3RVa1BvU3E3NFdlWjkxdW5rKzEycWdiZEdiS2FsVXYzTGtGSDYzOGhG?=
 =?utf-8?B?aGhBNkdWOEg5STdpM2Y0UXc5dmN6aXZMUHFOcFZSOStnTFZvS2wzakt5YmlV?=
 =?utf-8?B?cUN4MVdUY29sQUNraU90aWJwM0tUclVZV3ZjRDQ2QnY5bmdEQzk0VkZ6UGNN?=
 =?utf-8?B?S24zQ0dpemt0a3VycThjV25jajdkc3BJT0drTDFib3JFS2kwdFJ2cmZvRTJo?=
 =?utf-8?B?QmlpRzhDWnFmMUNuMFBZV0s3WURhWXFQQzNwd1NRSGsvZXFoT1pmZy9BTmxx?=
 =?utf-8?B?RWpMVzZ1bExqaGhBWXJOMHVPV2hiV2FBUVJhTUJYUDVFVXBDN1duZTdPZThU?=
 =?utf-8?B?YjVMamphdmhLRGdyT0wra29UZUZYWS9CK2M4OFBtbnhwcHhOY2NOem9lcVFN?=
 =?utf-8?B?eDE3LytJMUJvTTcvVzV6a2RJWjJPQllCUW1wVXRUSGVlZk9lWjUvOERYVy9B?=
 =?utf-8?B?TTlYUFVudWxWUGVUcGxtREx3Q0VqT2c0SHBlMDd0bFV5RXpndUF4cTB3a1I2?=
 =?utf-8?B?QlQ4UkpYUUNGUnVhODFtOW5NU00zeWpvU3VNRW9mNjVBTUp5UUZZZXB5RUxL?=
 =?utf-8?B?UTltRlpVNE41dXEzVndTSWNLczdSeFhiZVBZelV4bHVpRGRkdDZVR3dML21D?=
 =?utf-8?B?aDVjdFFLRThWTWxITGFOVFZ0bllrTlc4VGgwQW45QVhrclFwejZsL2pZZ1Fl?=
 =?utf-8?B?WUwvNWs2YjUxWUROWFFrVnl3ZGVoOWhHMWhVV3E4NmQ2TkhHTTE1U0UwNkIv?=
 =?utf-8?B?bnRSUFVQUlJCNmR5ZnRjU0d0MFdwWngyaG5tajhKWldJWCtqcWhDdlBGRUU1?=
 =?utf-8?B?ay9XbW83cVNyb2tLYms1WEg4djRYaHJyblcxRzVqY3oyblV1RVhhTVpsWnRW?=
 =?utf-8?B?dUxnV25rWHNESDl1R1RrNXpZN0t1UFA0enVFVFhLZHF2eU9EZGhmN044ZHU4?=
 =?utf-8?B?OUNGN0NYd0tkK3huS3JyNWFwMUw0cjRMRHNyRGYzeVdMclE4Vjd0VnZrbDYy?=
 =?utf-8?B?YjRhUG9hRzJDd241Wmt3US9md0Erdm1DeGhER3BVbVpTMnR6NnVBN3R0QjJQ?=
 =?utf-8?B?dWxtdDFoVjc1Uk9hK3kybVZWTkpMNllSMFJxaDhTOTBWMEdhZG5aWUFsYWJ0?=
 =?utf-8?B?cU9qa0EzZzFZM09ORzJSemFKemxDTUN1dGxoZTJ6N3dUTHZmc2JBTXNCa0lR?=
 =?utf-8?B?cTJKTXRvaEQzeCtSVHE1MzIxaVpuc1AzTSs3U0ZPUk13NUlCZW5GRHcvbGY2?=
 =?utf-8?B?dzFCYWVXeGliQks0U0xqaFBlakZMM09tN1FMcGs2S0FkQklGMU1DSkRvUDF2?=
 =?utf-8?B?ajUxeWZyamhJZTBTbldjTk1JeVpZRkVFa202TW4vMEprYXdmMmRMbWV2M0Jx?=
 =?utf-8?B?U2tnLzFnY25aN05rSmR1N2k5VzlkbENFVWczUGprRUx4aWlBWGhBSUNHaHdo?=
 =?utf-8?B?S21JbkJMRFFSSTBHKzZUSlpXU1R1SE9kQS8zUjhzeUM4UkdtSFJwM0xqSDJQ?=
 =?utf-8?B?ZlVPV2FDbTdjb052Yk5QZDg4NExFSVZ4aFdzaExsSUxaRzhuVmc3aksxcFBR?=
 =?utf-8?B?ajM2Q3pBUVlYTFF3T3g3MEtZWU9IOUlDZ3FsaXlIN1hVUU45bEt0UDBwcFVh?=
 =?utf-8?B?YVcxRGlzL3RHc0o5SldlMmhLNFNJbVNXR3VKeWNLRms4M2V0QnNUVVVBTlAr?=
 =?utf-8?B?d01PdXJTUlFTeXFlaDRBc0FYTHcwQUExL2RiMm1FenY1SDZ3aFRITW82L1p1?=
 =?utf-8?B?UlRwamlkU1RBODc5Ulgwa1M2RG16NU9vRS9ySmcrQVQ4RnhDK29vd3lZeWZu?=
 =?utf-8?B?b0FFU0RCUGk0UVo1UUFmZFNsWFNPS044dXdJVTMyNlpGcUJaU3RtYVFLcU1l?=
 =?utf-8?B?S1hndzNLWmtBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnJRbjdKVE9oS2R4QUgrVHZyYnpVTkdOUkNscUY4MmVLSWFTdFBhTnAxUWFW?=
 =?utf-8?B?a2g3SlR6b2FDK0pYSk44KzcyN1hLbzE4b3I0M1JYRlJIc1RzUENxdEZETU40?=
 =?utf-8?B?MTNGdHNDWlRYSHdURStDNlMyUFBFSGx2V3BEbFFCSHVyeG1Wdm0vb3FEcyta?=
 =?utf-8?B?TDloaFdoVnkvU2VXQ3FRb3d1c0w1YmFjWUdDL3o3aDlET1VNVEh1Y3dPZHdi?=
 =?utf-8?B?SGpER3JWUk1lWFZTZUx5UnEzQWtNNkRiVXFiTUFhcVRkdGVpYmJaU3hObHhK?=
 =?utf-8?B?cWRNWUVmVC9zSjlMRktwdlhrRnJ2ZFBFWVBVSWUybWVYSGJ3K29oeGJidHRY?=
 =?utf-8?B?UTZ3QjBUSUZCWW5oeXdIR1hLYlRiL2JDSnJTY1ZTTWxzbGMycHRuZm5SQWxn?=
 =?utf-8?B?WTFLeG16VkZzOFVydXNkZjVFYldrSmgwUFNrQTBUZDhmdllsdVBIRi83YVda?=
 =?utf-8?B?MGlMMmxxZmJ5bzR3ZENQTGw0S0xaaHF6MEZPZWtZWlBtNkNxWDVoUFVHN2lo?=
 =?utf-8?B?L3B6QTZqNFJ3emRsdGUxbHVoT3lNcTJzODFER0hiRUdNMFhiV1RiSHJkaWQr?=
 =?utf-8?B?b25rN1ZaNEVEUHQzU2F4VHBDZlVodVl3YmZ5ZGxrUmVpL2VNVDcrZW5WUEk1?=
 =?utf-8?B?VlYvUGtQNnFZUjhVTDdpRFQ4RWEzR1BMS2JiK2xFZ0FHd3lOUVRKRGdVUm9Y?=
 =?utf-8?B?OS8rNEdTNFZ2OVYzdWJpRGNTeGlPWlJVV3hVMVFLRTM4blZhb0ptNDJ4cEwr?=
 =?utf-8?B?MHp1S2dLL0IvTHliTzg4QmtqUUloazgvZWZudlk5VzgxUFhaeEtjQkZFKzZy?=
 =?utf-8?B?MDdDa3dteG1iUFo4aXhsK09Wd1hXSFd1aW9wdUUwa24zQXc5T2UvWCtJeWpR?=
 =?utf-8?B?VG9vZHljaVZkWlNqM3JKTHNhVjZvZUxoZ1FUS3I2aVZwdjlpQ1gycU02Qzlk?=
 =?utf-8?B?c01pQUFIeHh0eW5SZld0amZsZXVQVkJEM3dNSFVDTlpaajM0T0Jmc25RZVFl?=
 =?utf-8?B?ZHhIaXRVcXpSNUZHWkZJVjZjSDNNVGRKaEMxbmRyNVNqQ0ZiOXhmd01xQVZK?=
 =?utf-8?B?U0tOK2ZrcGhWRC9YUHdEUzB6MkhFVnRSc0dWaUpiMERTM0RUZHhEV1IramVY?=
 =?utf-8?B?ZEFEeXZTZnJzOUpUUm12ek1HSGlwNXcrc1M3UmtMMHVvaXZ3MDAwUkZTWGtG?=
 =?utf-8?B?L1dKMXZTQ3dGWVRNaFFxRjltRTdEWGNEc2x3VTc1cWNrSGhFZUZXQlpBazJ2?=
 =?utf-8?B?Y3JpSGFpL1g2ZSs0bWxidWlNd0xtSXV2K3hTMW5ZOWh5K0dnakpySVJpbWNv?=
 =?utf-8?B?cmtCR29hYlA5QVJDMzVnM3BNZnliSzd0cGIyNUpacXBxK3FYUWsxS0RBU0Ry?=
 =?utf-8?B?Qi9xVyttaFhYMUFHWGc1Z2FYNkRPUGVrTENUK1paWHN3dDhIdUYyVWM3OXN5?=
 =?utf-8?B?c0tmczZiazdDd0NBcjUvQkw2TXJnOXVJbWNidGpyemtPZHdtNVZ0SXQycDY3?=
 =?utf-8?B?RHFqVXJXaXBXM0dYemx6YkVERzE5cGk3ZXlRL1IrbTkvVTg3ZFZvalF3cElB?=
 =?utf-8?B?dW9JL2pOMlUreHVKaGdKZkorODZoWmx5Tjk5em9CcW9OUlN6a21WMU9USitw?=
 =?utf-8?B?c3lvZ2ZrQnVyUUg4UFRPVmhSVE1IOVVzTG5BM2FVMmhzenhicVY4djdndXph?=
 =?utf-8?B?ZDc5KytQM0RidUx3Wm80elBGK2VPSkZmWXNsWGxXeS9BUXJTNDBpc1hDczBZ?=
 =?utf-8?B?QUtCc2swOTFwdUVuVmJ3UUxmZW1vQmNhNFFCdGd1SWtRMWphNERSNzZIUWg5?=
 =?utf-8?B?Z0hjQjdCZEJJNU1SOCtJT1Nja3Y0Q1RKNDdab3NQclpOdXRBdFJBbmVKSWh5?=
 =?utf-8?B?Ujdld0hIczJLZEJOTDZtdW5hUGpiUTZHMWk2TDYycWtSbUJvVjN4NlNjdjYr?=
 =?utf-8?B?blNVd0tUS01PaTJUVFhEdndEUXJKT0RpbGNDOFpOemdVeHFBbDdicVZraGRK?=
 =?utf-8?B?OHZoV2ZTTXdtdzlvQW1WNHQ1cXgydXFLSTQ0YWNtZWJjZ3UxU3A2UFYxSVVD?=
 =?utf-8?B?Y0JZU1JVMGs1R1FzYnJROHVua09rcnNud3lGd2lFeTNPZS9nWkF2ZFNTOVE0?=
 =?utf-8?B?SUY0QW9DeE53Q3NjWjlINGdWcTVaRWJCSTBhcEcxTkQ4bFgzbmU5UkwrSnJw?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd1ef9a-4efb-4bfd-5a8d-08ddbf37189d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:22:31.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fthMWvlUz4//65ayHfJQ2Bde0m6yvRb9uAtLx+tzxGorCXzYIp6bcZeP6fPbxJ4XT3ZoJxTAkixKgwsBN/30ArnGayqSFeife1FJdWqpErA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com

Hi Tony,

Subject needs an update?

On 6/26/25 9:49 AM, Tony Luck wrote:
> Each telemetry aggregator provides three status registers at the top
> end of MMIO space after all the per-RMID per-event counters:
> 
>   agg_data_loss_count: This counts the number of times that this aggregator
>   failed to accumulate a counter value supplied by a CPU core.
> 
>   agg_data_loss_timestamp: This is a "timestamp" from a free running
>   25MHz uncore timer indicating when the most recent data loss occurred.
> 
>   last_update_timestamp: Another 25MHz timestamp indicating when the
>   most recent counter update was successfully applied.
> 
> Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/arch/

"/sys/kernel/debug/resctrl/info/PERF_PKG_MON/{arch}/" or
"/sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/"?

> to display the value of each of these status registers for each aggregator
> in each enabled event group.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 56 +++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 090e7b35c3e2..422e3e126255 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
> +#include <linux/debugfs.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/minmax.h>
> @@ -275,6 +276,58 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>  	return false;
>  }
>  
> +static ssize_t status_read(struct file *f, char __user *buf, size_t count, loff_t *off)
> +{
> +	void __iomem *info = (void __iomem *)f->f_inode->i_private;
> +	char status[32];
> +	int len;
> +
> +	len = sprintf(status, "%llu\n", readq(info));
> +
> +	return simple_read_from_buffer(buf, count, off, status, len);
> +}
> +
> +static const struct file_operations status_fops = {
> +	.read = status_read
> +};

The custom seems to be to use DEFINE_SIMPLE_ATTRIBUTE() that can handle concurrent
reads on an open file descriptor.

> +
> +static void make_status_files(struct dentry *dir, struct event_group *e, int pkg, int instance)
> +{
> +	void *info = (void __force *)e->pkginfo[pkg]->addrs[instance] + e->mmio_size;
> +	char name[64];
> +
> +	sprintf(name, "%s_pkg%d_agg%d_data_loss_count", e->name, pkg, instance);
> +	debugfs_create_file(name, 0400, dir, info - 24, &status_fops);
> +
> +	sprintf(name, "%s_pkg%d_agg%d_data_loss_timestamp", e->name, pkg, instance);
> +	debugfs_create_file(name, 0400, dir, info - 16, &status_fops);
> +
> +	sprintf(name, "%s_pkg%d_agg%d_last_update_timestamp", e->name, pkg, instance);
> +	debugfs_create_file(name, 0400, dir, info - 8, &status_fops);
> +}
> +
> +static void create_debug_event_status_files(struct dentry *dir, struct event_group *e)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	for (int i = 0; i < num_pkgs; i++)
> +		for (int j = 0; j < e->pkginfo[i]->num_regions; j++)
> +			make_status_files(dir, e, i, j);
> +}
> +
> +static void create_debugfs_status_file(struct rdt_resource *r)
> +{
> +	struct event_group **eg;
> +	struct dentry *infodir;
> +
> +	infodir = resctrl_debugfs_mon_info_arch_mkdir(r);

I understand that debugfs guidance is that callers should ignore errors returned by
debugfs_create_dir(). Even so, I think it is unnecessary to do so when so much unnecessary
work can be avoided when, for example, debugfs is disabled. I see no harm in bailing
out here if "infodir" cannot be created. If it can be created the other debugfs calls
are likely to succeed so further checking should not be necessary. 
No strong objection from my side if you prefer to keep it like this ... considering that
it is indeed following debugfs guidance.

> +	for (eg = &known_event_groups[0]; eg < &known_event_groups[NUM_KNOWN_GROUPS]; eg++) {
> +		if (!(*eg)->pfg)
> +			continue;
> +		create_debug_event_status_files(infodir, *eg);
> +	}
> +}
> +
>  /*
>   * Ask OOBMSM discovery driver for all the RMID based telemetry groups
>   * that it supports.
> @@ -300,6 +353,9 @@ bool intel_aet_get_events(void)
>  		r->mon_capable = true;
>  	}
>  
> +	if (ret1 || ret2)
> +		create_debugfs_status_file(r);
> +
>  	return ret1 || ret2;
>  }
>  

Reinette
