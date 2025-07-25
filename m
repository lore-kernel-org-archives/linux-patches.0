Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2A72356BA
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486817; cv=fail; b=E0nm3s8N5tyHocRrGTLJ3DPeZ6JV6FYvlGuGKbbPJgmiQBFPx86nWOZ9FRPqY21/Wptg4vlR1cX1eWnM0EOByYahVJ5CU1MHkcCIACGeSz65lsDwl/dE0XvG+fWX6dK/8ZsEFpubABcCyRHw6y6s+tizG1JDuHkXM5gpDSlCUwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486817; c=relaxed/simple;
	bh=gkH4B7ziaNH3ITLZDmG24VJlIfBvpkqrGuA+NffsDkM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p8NnpmJHiXMUDQsDdiRg8RBZchKUngYWN9N8O3puNs3pWO42INkidhwQ+EynUg3YHnuSyXIwEVi9+NNOYvKk92slO4xawsBFB6v3r79lOAPbcNApAALW6+BmSQFvAlEt17cYEhGNoo3nK17EZx+YUmaFxsUVV2TBAngcksIzCIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VgKZMAIb; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgKZMAIb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486816; x=1785022816;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gkH4B7ziaNH3ITLZDmG24VJlIfBvpkqrGuA+NffsDkM=;
  b=VgKZMAIbZ1b0F52Kbwj9biNuWiRd9UzqyDdAidIDxhBKSV2GdAGR9ugi
   tv8b4SuBYK+4kvUeuiItm4JtqPLQvRD5BKSQz/y3CBxmCwOE0OgirvlwD
   sBSinGYf98kXGxFf9CIoVCNEWDYvFoFDuICp6KiDKgNKtT2xi4qwPG11h
   ibBnYN7Alt8AOfMw/OBiEXkerjjXvWzrrMlahMPLzxh+X3R9uakTwPwZk
   KREuwx7t+ePw9IxwtV8F1jbLzlGdRN5P9tPMkleh5seG64t6qoyVzWv19
   4xQlyEXfB8XxSX86iNgmwsfqFHQNVwEdiPYriNfiCzG+wxwpjH6sp0Aoy
   w==;
X-CSE-ConnectionGUID: h+2MJVJYTt+Xg5ooGXA6pw==
X-CSE-MsgGUID: KhSSLN97Sm2NMsfBHlBsaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="59648298"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="59648298"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:40:14 -0700
X-CSE-ConnectionGUID: 6Yp08uldRSWkEbMOUN5HIw==
X-CSE-MsgGUID: 03UqciN2RzCTgHOmoTjPCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160520396"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:40:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:40:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:40:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.59)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:40:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXlPyG0qqWWGcNpHwKw4ZUJapScWxjznoYgwtXaUKXxa1TSUA3qow5duTc/RI5aCe9PxugNwpjPO6lGxIhB/yE40iwKKa6FpbNcYoncG54mL73+2jFi/8IghTcpoNrRto/zw2brod5xWz4P3i3q96kCIij1y7i3Zk+YlTFlpw+V32CO9luZTDW0dQO8KnIG/TuA7+ETwqSCGf0GjtFQBmu8CCQckFHiCs75yKi/RsRzeccNzFaZwgIuFufVoBbtwzb3T//qjAvfYRt+SJu5mj34LUWv3BYEYC4VdspM+FbN4iiM9b33Ss11PBqshP9WUlfPnFkSHklLKWt0gFI/1+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQAV/C3t+g/sI0wB6ulFzRbxRD/CiA/wz2Kth4RojOs=;
 b=qXYYNcs0VRWyO9t6tCvN/IajhOhChBEr+FgQbYvo4HSnzOreri83U3by7hEu8d/JERqUNViBOk9BpwIQrg3gkr8eb+NGhylO2kfHVfqDmxvjC7xMzw0RKLT8jdBXZUwDjbtchFWzIEK7scDevX/1rGUnmGLseMh/2R215suJlWEDcimuzYISuvIgtISVayYpw9N7yR/RGRwLjCvfOfZrbwUL54wTJSyhMXX1AM5haSaHIGBZd8btMMBm8nx4TLF47avT/aujNLktXsuXJOClOF1CgtAaa8KN3V5Or0LVRGqz1Lw5h3wWN5k0+G90f/RBZ6i0k8iQlY10fdlxE8MBKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:40:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:40:11 +0000
Message-ID: <ba0eebf2-12e7-4783-bfb6-81773d3b25b1@intel.com>
Date: Fri, 25 Jul 2025 16:40:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 18/31] x86/resctrl: Count valid telemetry aggregators
 per package
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-19-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250711235341.113933-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:303:8e::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a1a5935-1793-40a0-23cc-08ddcbd498bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3dZV0xMZlRoc2k1c1RhYUEzK2h2dlJhelFlWFJhMkNkalhrQXFCbHU2QmJq?=
 =?utf-8?B?cGF1eTQ1aDVLcGQ3VmtKZ1dTcDVvMFNlZ2VTQ2oxc0hJYjZ3V3JHc1N1eDhR?=
 =?utf-8?B?bUp5TUVud1hxZHpra0NwZzFKRXlFQXJ5OTM0emN2Zk02MDcxck01SVlwOFRB?=
 =?utf-8?B?ZEtSSUNZalB3WENFQmZ3ZjJieGhsS3EvTHlMYjFrR3JPZFBlT1ZCY2x2OTJ4?=
 =?utf-8?B?K2tXOE8vbnN6MXY3OEk0ZFFkZ0xRQ1BEME5idWRNakdmUHYrdmxOb1ZGUVgy?=
 =?utf-8?B?THJMREdPT1BTa1E4SlNjTnFDZkJQcUs0eENxYXh3djhsK3BBbi9MR1ZLOWNZ?=
 =?utf-8?B?UlJ4MGpJcUtzakFqQng3aCszcE9ndXRDRTBOK2w2d0JaZXZDV2tWY3VTbnVU?=
 =?utf-8?B?V1FKdGYwOEhZSkJtU1hQS2NQVVhqSDZzMSttQ1dsb1lDUlVyRGtBd21kM1NJ?=
 =?utf-8?B?bmN6akc0dHRna0E5dGNmem9MYW1HRjN1bWtPaWxEQTdnL25UbHZrU3lhZGVD?=
 =?utf-8?B?b2F5ZVZKM0FjSmNKS2l2L3NXQmtCdU5rRnQvUXlRL2dGNk9nOGZoY2RMSVVG?=
 =?utf-8?B?UFV0cEYyY0kwb1Y1UWdxZnFSVFpIYi82TWcrd000TDNTSzROUXhBZGhqYUVX?=
 =?utf-8?B?KzdIc0xWaDFHYVk4M1RTU0tOSWZHb0R6L0thTnN5WHh4c0lWQ3RvY1RtNkh2?=
 =?utf-8?B?KzF4RGdpbklQMXpsVGljdXB3bjgyZmtsbTRFRGdtSGVMeExvaGJGS21EcVhF?=
 =?utf-8?B?bXNGSHVvcTB1VHowbG9wQ3lOb2dGR1BWNGRmeHg2dTRjQnZTeTkyOVQweDVZ?=
 =?utf-8?B?czdjUDdld3duOWZRZXkwOElVcWQzSWhMQTI5SW1vdHVCNUdtckdhUFVVUktR?=
 =?utf-8?B?TGN5V08vZzFJNHFjdFBQT3lqSjI4VzhrNVlLMTR4aVg2RUF3aThMUWJnY3Na?=
 =?utf-8?B?MDh6bi9ERk50bmkrUWdIa29kd0dobW85bHBtNHJQOThGS1RvRDc5V2V6MXVn?=
 =?utf-8?B?SzZyeGZ2b2wxcHg3THhsamZzRXVGQ29lNVlaemtUSGVTQXJ3Q1p1QjYwS0Mz?=
 =?utf-8?B?WHBvcXV0UStCM1hZZHF3Ymp0NThJZ2xmL2RwTXlvKzlMTlFScEhtYXJWMkZY?=
 =?utf-8?B?ZGRCZGNqUWhKOFZ3RDl2UnRqemJTaXlLYXgzVUcxVmxBOEtMcTN1cUtYMlNW?=
 =?utf-8?B?cmVQV1ZaMjRrK2IxZG1Td1g5cXl1blBUM2FlWHI1ZjVsMnd0Tm9lSmhuejdH?=
 =?utf-8?B?Tlh4RDhISkNjWmljR1dnb3RCcHlVdDNVajlEUXhXSk9ESTRPZHE3ZGd0c1M4?=
 =?utf-8?B?WGliUjV0U0RJMHlmNzJKNy9zUVZEeUxMK3diZzdCKzBFdFhsWGN1RHZGVWdW?=
 =?utf-8?B?ZnEzZU5ld1N4bnFIZmJIelQ0SlZtaTM0VlNPck85dDl2QjZIb0YxczNtTlRh?=
 =?utf-8?B?Z0Via2UrZDQwVkx6cDd6M095UDZrUTA5MUZyRWdMWEN6RzlKTnY1QytUd2sv?=
 =?utf-8?B?eDEzSk5DMjZsRnVIUW5jOEsya05WdDNwRVR1a3puaURCZmtGR0w2V1lseWJY?=
 =?utf-8?B?cS9UQVBDL3NDUFQycmN2U1BqaHNmQTc0WjY2ZklYSmlRczdJTS9ZOTV0NE5B?=
 =?utf-8?B?LzlucDdORW0xbjQ1UFFHbTN4SnVpRXFYdGRpRm5mTW5qOUU5T1dYOEM0aTEz?=
 =?utf-8?B?ODRaUm5zNDNkOEUwdDRBWWg3ME9oeDZzZk5XL2VXclM1dzFNbGE1czV1d1BM?=
 =?utf-8?B?d0xBMzF1SGozWmVUei9tclBIUzdQcGM0RUhrQ1QrNysrWDNhTDhTUmZtSk1v?=
 =?utf-8?B?TTZUMlUySW84NkpUS2NXUHoxTzVPa1lZL3BON1prdExvM0ViaHo3UFNRczY1?=
 =?utf-8?B?SWR3UVp0d1UvQnNzcUo2bnJBSjB1bFJKMzFqb0JMazFXWVVRKzRYY0ZQNW5x?=
 =?utf-8?Q?pPthguPZRTo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDh6anRWSlRQU09UaDY1S3g1dDN6NFVXZXlIMkgxM3h2TVVMQnBiSEoxSkJU?=
 =?utf-8?B?d1h5bloxYzVneUpYNjJaUlNmcE1xOGNUTEFwTWpFakYyM0REY1lmclZrYUhF?=
 =?utf-8?B?N2NURFlXTFNSb0FwYTFrMVBYcW8yOFN6TE1QOUFjSXU2Y3ZuNkRZTGE1ZzlU?=
 =?utf-8?B?SHFOWFhZb0JMN01hVmhyNk5ja2IyQlRqLzlPRGU2QmhNZndmellHbU5KZUps?=
 =?utf-8?B?WUs0TnBJaFpmRngwYjNuTHhuYy91YTVRUG04NUphaE9RM3U5QkNsYlNpbzdp?=
 =?utf-8?B?YVlJbVRobVBXRnRYRlgwSDVUcWZ0SkZ2WjJlZ056M2xTbjNJcXFkZStidkh2?=
 =?utf-8?B?VmdqVVFrZVByMWtIZmpRU2hjMS90VmhyNkVIOFBRc2dZakVCdFYwVkNUYnJC?=
 =?utf-8?B?OGMzV3ZlUjVoQzZuUVBlRWJ0UDJrUWZreStxVFNQdjd2MGVIZ21xdzZub2or?=
 =?utf-8?B?YktKQ29LTkZ0MVRIV1pLbHYwR2MxS0RMbTh1MkcrWDQ2R1lvcUFuaVNzeXVO?=
 =?utf-8?B?Q1N3MWo2ekw0M0Y4L2JhcnVjOFdxZlBnZmwrMHcwcDNVTTlZNXlTYm1rVDNW?=
 =?utf-8?B?TFcrU3pmL3N1enhWQlMwVG9TcmxhdlJYR1orem82eWFhNG5LZU9SZXdNNk9o?=
 =?utf-8?B?TCt4UUs0RHRLUzdsZGhVRndHdWlleXRYUE5DWFd2WXNoTkxITnhneWM0Z1Qz?=
 =?utf-8?B?NFp5V05RWmpWaE5NOGVBc2JBMzlLS1Q2MkExMTZtL1U2QXl3TlQ0SDZZdzdU?=
 =?utf-8?B?QTlKYXFkTlVEU0pXL0JpNDdHNk1sU0R2dFVBa2lJQjRhbU55QXpWSFNib0l6?=
 =?utf-8?B?UEd2TFBKSDFUUkpYOWdrZkZ5V3hvQmVLR2tlcDluUlF1a251Ry9ZNk5zUlNo?=
 =?utf-8?B?SGRXVVlFQUxheStzUFg2R1R2SGQ5RStZUmNIOC9CSGQzSmh4VFQyWEttRE5p?=
 =?utf-8?B?dHdhaGdVaEF4eVJnMFFDdStaUVVsLzgrejZNTVVrcWJpNXJzcmRBbzZWMjlm?=
 =?utf-8?B?eEFYNm9oTWIzeTRWKzJDZjZhTzloMHh6YTNkNmF5VmE3TGIrYW1VM010bk8v?=
 =?utf-8?B?cnpvcW4yT2ZTRDlnaFlqRlRzRGZucWtuOHBmS2tHTTA0cVNqcW5QaFZyUXhY?=
 =?utf-8?B?M0s1eTdmSncrRlNtdVg2Nk9jSDBibW82MDRaQmV4ZWthMk1wOVlZaHVqRmMr?=
 =?utf-8?B?ZTJneHJUbDBZSGFNMGtYakdKNXhnRmhTU21xd2ZscVVrNHlGbTN6a1JIZnhZ?=
 =?utf-8?B?RTdJRVdEK09BMkxXdUluRW42N1pXL3Y2UDlFem5lN3RzSnp5M09RVmd6MWNS?=
 =?utf-8?B?L01zd0RRUW5kVkQrb2hNNUdEWHdxMUI5ajBaRlFPRmdVOWZwcEJzeVdodFBH?=
 =?utf-8?B?VkFIZkRPbi9LVFdZeUQ3UmlWNXJlNFpKM1FxZWQrdllXVDVMcmVQc2NKc1hY?=
 =?utf-8?B?eWhpZ0p5bCt4cFhoUjZUZUFIRkxwQVdwRE1TdThWQjlVMjZpeTBmN3duMjJW?=
 =?utf-8?B?UnlVTTFETjNtc3NsSWU2NzQ0cGJjbjlHUU05clF0RkFhc2FaSzZTWTFZczdO?=
 =?utf-8?B?Mk5wSUMxTXp3ang1eWhTZzVHRVlkajBic2tHRENYMkgzUmlqak1VLzRUUXBN?=
 =?utf-8?B?QWg1OUhXbjQzTEtVN1YyZnhlM2MwZlhQd252Yy9VaWhDVEk5N1dyeHdvWW44?=
 =?utf-8?B?akFrNDJkWnluKzN4TXY4WUxGODhlZnUxYWlpa2ZBdjQ1dmVVY3JCcXAvQjhs?=
 =?utf-8?B?S1R2U1ZzRzBRNEJVZDZkSmxnUWRyVG1qeWhSSWlIWjE3aXlJbmVYMnE1TFow?=
 =?utf-8?B?WXl0a1R5bXdULzVYU09EQ3NreVFiYzUxZGh6TlkzYytmeE5OSkorS294eVNx?=
 =?utf-8?B?c3FNOWo2MkNXQ1dYZ1h3RTFFbE9EVUJvdWtLSDhYZzlWOUtFYXBwSzlCWUdU?=
 =?utf-8?B?S2JES2hjR2YzUTFZdzdJYmNOaEFNOFpCNTllQVZneiswU01QekN6YWliMlpK?=
 =?utf-8?B?T2xjcFhSQ3p0alFjTnFJTVk3SHZFeHVzazFXSk9DZytUT1Q5UGFwanRpNFFk?=
 =?utf-8?B?UnppeWJOT1JPMTkrN05GSk9sYWRJb1RyeGZqMG9pOUZFQlVYSGJTOHRHd09X?=
 =?utf-8?B?N21JU1ZSRU1HZzZHM1NiT3p6OG5EeW5jK3FhVnlGYUdqWHY2SW04S2tUTWhj?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1a5935-1793-40a0-23cc-08ddcbd498bb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:40:11.3426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3qfRZ9kXq/6/lMSxaU1/jzHbZ67A5zlXDnonqO0S5o3XibLVLxYUiy7fCtrP19SigUuJ3Q7wejy08olWDRs8gcYCBiQCDT1szmhQKPS5iA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> There may be multiple telemetry aggregators per package, each enumerated
> by a telemetry region structure in the feature group.
> 
> Scan the array of telemetry region structures and count how many are
> in each package in preparation to allocate structures to save the MMIO
> addresses for each in a convenient format for use when reading event
> counters.
> 
> Sanity check that the telemetry region structures have a valid
> package_id and that the size they report for the MMIO space is as

package_id -> package id

> large as expected from the XML description of the registers in
> the region.

The above two paragraphs seem to describe the actual flow backwards:
first is mentions that telemetry regions are counted (above implies that
all telemetry regions are counted, valid as well as invalid) and then how
to actually determine if a telemetry region is valid?
It will be less confusing to first describe how it is determined that a
telemetry region is valid and then it will be easier to explain that only
*valid* telemetry regions are counted?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good.

Reinette

