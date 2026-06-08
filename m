Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF9F2F5313
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960741; cv=fail; b=ijUvU5KlxdX07GAKycZzZMJyohA9kdoxNKmZFzURcj+gojm8nTTPEhQVNeZsNwdAZ678zXazv/BfA58ya45dXoVOOyPyocO7pmMEjm7vidJaG2eAM3BZtFQy2qK8xiNImmOyTkdlxWuATLTWdULQ2ZNZdJ89SPtQvw6+f2CnT/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960741; c=relaxed/simple;
	bh=BhXNVUmzDNZLh+YBpTNE1DkLPGq8eDwhBiBco8RGSmc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lbMn9NsMbHdARU4fFx458rDOp3wjt5m+WXh/x9EUlJ308x47/mJ57wlc9HgvEWgQOSm44C/b0MsbSi5cBKgV/Qrz7pqhUKAbcJwpYBx/hj0BNrLHfpAfMW0WdhZ2RQif7+T12GFG1xMAq7X/hTail3U6z8Owroicqebj1L8w/yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+o7Fy5a; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+o7Fy5a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960740; x=1812496740;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BhXNVUmzDNZLh+YBpTNE1DkLPGq8eDwhBiBco8RGSmc=;
  b=G+o7Fy5aoxKnX3JYu5ZtYBrNFoA2HuzEPsL45yB11c29UCFgzZ8Epq2n
   4ld5xWmRcHqjwu/3UqYgDJLETAN7/Xs/9spaEtrq+VFJJO0TpRl/gK7Df
   bvpVbVwoXwWPN7P97pkmTPFgWyEQV3WXR4Ihi2GXTmuAapZSYwV1c12PP
   xQbJB6KJOfqDm/m8NdKZeXMXTieqWmsk0BuZgL7y0cOlNBo0AM0E5AWMC
   XBX5vrAo7J2kas/hYNbKw7qX1LzQijU6DCjsemfiOUbdSSXBR2PBYN9W4
   yAO+U+MBX254UE+HOHAZp9cl8KKHKJRUdVycZ+KfrVLNjhwMBohP5Dk41
   w==;
X-CSE-ConnectionGUID: MZ54Up3gRZqyKgXAvZsbiA==
X-CSE-MsgGUID: w4ya605kSFqB1YqEYeVHTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="92817695"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="92817695"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:59 -0700
X-CSE-ConnectionGUID: iDPdiQCjQEq2CDJr1nEpZQ==
X-CSE-MsgGUID: G/aGY2Y7SbWStOBAhQ97Ng==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:18:59 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:18:59 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.50) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:18:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNZA7Mqc7pS4uHTRRWlFu3PbowceTg3kM9ulMWN+spfZPVw9PZ0NWfWke4GohA109F8m1UIigqRZecHsSCm5lFRoomwn7px2vcpwY7DN3H6gH8eYwGTsB0Gsmby3D8XVG8k82rhqdaPA5B0SQBcnFu+dzHRpJLbgPuICY+SC0plFn07kerbxNZ00xASRtttDpI2uUE3xagXTk0Y5Z+2P0THI/WFuy3Yh4gNpIvXbzT+CMrr5ss+ilxe4ibkBc/ib7FdBam5bLSdMfp9k1KUCYHSE7EEKhT0c+0c5vSLEEne8YCZQp3cT1XVYHxaW+Lpp+uSF4gyYQLOd4QtU2ynmAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvyaBOCeld3umu8Xnyp1IWiCgvZp5I76fxpeZycc0hw=;
 b=gsJ1FfqB9u+NaijT+KfB45+AxMKsvGh5mh9FmGxkPYPk57cmznl2KI2Qgykj3QOVACZiOa3piVjm2SM4PTiK17lgBdnv8ptNloP9IB5MfHhuw1Ahudklk59hBIHDSLnTKdrywYTic4IhVmS+VCyu9P3Wj+7emptQsPiwGCa4RmLBNt63fortGKcPV2vQegk9cJTV5WutU3Dx0bLgMnynbafKXBNzm3nKJfp29R6JTPq1Jq0H88eoD4hIIGSl/PTCQ7nJ3HALNCVFt0zHa7UZfQMQL0jHDi32gu4E61Yib+Q4dJlFS6lJ+FsM7wbNIkZziFoQ+zGjWhBe6WA6FRRhnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 8 Jun 2026
 23:18:56 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:18:56 +0000
Message-ID: <ebb78841-8676-4383-a1b4-81ff4f1e782a@intel.com>
Date: Mon, 8 Jun 2026 16:18:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/14] x86/resctrl: Maintain a count of enabled monitor
 features
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: 229e7312-c2e9-4eac-d410-08dec5b45014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|22082099003|18002099003|4143699003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info: z+8SgPkjXklTvYSmVwnqBIUMAZTRrRrBsrHEypRSidxePXH3OKEhzh7j6FQPyisQ1YzFoB3aeO6fvuuNfQDOAfuRBsOLQWtzDzOk8ElAh/qPnZaLemlCF5K2G/YC58jJU3Evj4URTpQHfs/iumERsf7n3PvCZCyYG+qT2PnB2cnLzFWcKu4GnIpRhCI/m9IoH1YVTn3D4f84TtqF7NaFVshmnitaIQjtm5dYFSKVlbExEkm8A5AeBZHq2JKlgAi6/dTnSVM2kQtcUbeXN+1P7FM95uIlQj/AZLbLuIqPbzobKAW9dp5ZAxa/kAz+Dg+31+FEulr6SVG1FQHjxgQhcAR27pDpd6gVr75Shm6WE5bjTf7GYqWu4cW85hsBDlYhX8exkFFookwKg4rNrs7/HSBOdYkuUztiYio2K7TeUr5ynnC/Dm0w/y30Vp7+9Hj1fgJ1VXyIPqFJx6bbSzWMeOpA8ur/Gilx7zVM2ffJTaLKn+gi4YAvoZ2rRrhy/+y6J0LPyhGaTHr1PUwQcg7x25SA2L/LFMzsAqw5KZMVQR3fLCyp3DLhZT7+Rzj0SYPDgBI9yMpJKaAy12IMIz5GAa8Ayl+kONl8GzvihT9nbo9lWWbxHId4X0d0zZW2oGyGVYgN7LEvRBQCVdgwBXGxAFiLlubadN/pYmpDJQnaimuvpsLYX0cHzvEw4ghwpBDIzRVD7QpQwyo163WgFdMwWDnWEeQFZuEB58p4kR2heSo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(22082099003)(18002099003)(4143699003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVB5UllPejYxVHVsSHRIcy9RVUFhbDNtTmlFWkxrRmh2R01aS3liQ0VjRnpv?=
 =?utf-8?B?Z3FrdWo1eTd3bkd6MDJ4TjJySm9jUDBXWlJFTVBqbkV2MW9kUXduT1VGU0hy?=
 =?utf-8?B?MUpYMWFJT01lRWZWWUJtL1J1SS9YRDVVb3BoMjFsT21oZ1IwNHBHWm5GSU5h?=
 =?utf-8?B?R1RiNmZQTlJmT1hUQlZNM2VWVFVBK2ZJRkl4SUdzZzdnQnl1K1c0alQ5V1NH?=
 =?utf-8?B?SjlmSkE5TWtMZ2VpS3VWSzc0YklETTVPak1VbnIyMzdNNDBRLzlIS3diZEFt?=
 =?utf-8?B?ak1keTBxK0w3ekhuWEVYV3N4UThIb0UvaUtrV0VFREVnamhnUzExcTFOVDZu?=
 =?utf-8?B?MnpIeGlXWVdlbi9kU2dvY0E4Nys5bmNPUC9YeTdSNCs2MzRWdFY1OHlvaCtW?=
 =?utf-8?B?TE95alQyRUVYVVJ1MlF6WW5NSUo3amxNRWxETERmZ09KN1FQaVczSW9tNEpR?=
 =?utf-8?B?L1VwdzlnTi8xcTR0NGhjNlVCeXJhVzdVVFFqS1ltcXQxVUhxV0FQSkFhZldM?=
 =?utf-8?B?d2NhaWtXK2xEN2QwVTQ4YmR6NmdteGhRbEE3QlkveTVrWUJnVmVlNVJVbndm?=
 =?utf-8?B?L3BHSG1XMHkySHNqbXQ5dThuNlVTUVQydGR1L28zV1lOeE54WXZ6WW1vTkQr?=
 =?utf-8?B?b0RQSTAycFQ1TGQwZ2hYaEhvUmVFSEc5d09kQlFIZ3pwN0VEOWgrdS9kR3A1?=
 =?utf-8?B?aFZhUlllWDVDV3JpUk05aTNyb2pibno3RXgwMmFJeVJPU0M2R0YyQ1pvUkdi?=
 =?utf-8?B?WWZ0QXpsaW95cklQVGtsd3poWUNRSEplbVJLbFZXMzF3WEh4QXhUcHorOWVD?=
 =?utf-8?B?V0Zjb1dpYWRiYjJjU3d1eHlVdEY4em9VRitkZFZQanhCZ1ZPQ1M5NCs1SCtU?=
 =?utf-8?B?Uk41Mi9jdHpiQUkxM3BhWjRPVVVSMGFUU2FBN3lvMkpRNkdKb29RS3BDdjNo?=
 =?utf-8?B?LytNdHBlUU95Q0lyMGtnODR5WlptNXppSFNWV3kvL09tUWNoNG9Cb1U1anhJ?=
 =?utf-8?B?RXIzV1BDUFZ4NGZGbmhpTXJUeTJ1MThmdjlBcHpEQ0hYeWpjelFTbWhPNjZQ?=
 =?utf-8?B?OTJicHBTQlorOFdrNDJLTy9HSlk4emFkK2loaEtyeWlTVitISVdlS2pXZ3Jv?=
 =?utf-8?B?ZFhDazVIY29OclA0SVRCam9LZFRXTjM1R1VFaGJVY0xveUFGU0lLSzZIcVpS?=
 =?utf-8?B?dWFQK3NHV09CWHVGNVJ3cmdLZ3dKZVpmOWRjNC9WRDFseGxrSTVxUlZobVVv?=
 =?utf-8?B?Y0VmcmJuTkhRSDBHbWRxV201dlVnUFVaSkxqekFOTXorRTdqV0g1TmRrVXhY?=
 =?utf-8?B?akR1djhVZkNNR2h3cVh1ZGk2dlpyRDlJeDZOYlZjTk1KbEFzSjBwSVVUOHA5?=
 =?utf-8?B?Zm9mdzFsRTdKWS9KYmpIYTQ3aVlCMGlFRlFrcTY3NUJmMmhyZFpSbXRuWWZo?=
 =?utf-8?B?emZjaitSaHJPN2NkUGhBeEwzVVZTVG82cStKSXVIS2xxbUdQYkxMQS9QY2xx?=
 =?utf-8?B?U2hxQlRKS3ZSZ1BQN1Q3NWdMNmhhbTl0ZE5zeDlEUVN0Y1d4ZFhrbi9nejR3?=
 =?utf-8?B?cStlZkpUZm10cVpkRlpSYlFGeEY5S3cwaHdpQWJnZm52UjExUDR4Wm8wSDZV?=
 =?utf-8?B?ZExYM01WdmlLa0dET3VxS2QwN3ZIL1AzOEVEczNNbnJIMi96SGlKaWF0bzFQ?=
 =?utf-8?B?Z3dRVnp2bmo5M3pZcVBHcGJlbW1OOTJnOGVlU284SDZRaS95c3pPZTF1U28y?=
 =?utf-8?B?bVZsZ0taMmR6clJuQlVtSGdaUkJrWG9zell4bithUVhYWE5vY2hLOHduQ0ls?=
 =?utf-8?B?ekdWc3lxZWIydDlKTklaOGMvRitZWDQ4cEdKZ0RCQUgwNWxScnFxUk40Y092?=
 =?utf-8?B?R3FlNVM0RVJlQVA1djdyZmxyYk54TTQ5NVlLTEhwc1JwWk9id0g2dURTMk9H?=
 =?utf-8?B?cS9XZ3F4a0g5SkRySUdWeEJ6YUlrNHl1cnhkY1FsdUxCNGp5aWVQS09yaDRH?=
 =?utf-8?B?eW4vUkdTQmZFTkppS0IyeWo5RTlKR3pneklmSHBuc2M0QndKeEQrckw0YTBQ?=
 =?utf-8?B?V0pmOWl1YWRyV0lGeGdnTHlkclNKdXF5Ly9rOFRDcnh3V0dSVjQ3TEp4NDM1?=
 =?utf-8?B?OEo3QlNKU3V6V0NKdnlPTGhTTGU4YXZyUFpBL1R1ZDM1VWJkOW02Z3dsZkQ0?=
 =?utf-8?B?WHJySnJDL3hGck1LOGxxd2dONmtZWFpkcW5ueTJ3azdvbC9MUElQVFF1dmpS?=
 =?utf-8?B?NjhuclFSelU2eXo5NkQrcGhDT2ZqbSs2aFl0VHJVVUdMbWl2OXE4bTFCM0Ft?=
 =?utf-8?B?WUNsM3ZDY29oMjJLUjY5U1FBL29ZcC9lZ3Zxek9FWXRPLzRPakpyb1lOK0pS?=
 =?utf-8?Q?/XYMVrho/f+8FZdM=3D?=
X-Exchange-RoutingPolicyChecked: Lp8LkmnqOA9aYiFj3Or+8zjavSBRtD5jQD3Ig6XOAB/IopLw4P8Qi5e4+pWqb4CSvbYwMx9hHWuiVyyZthf6YCkwPOfRmGZyghFI0pTZMLtcZBSe4zskbTwHV/F7zGPhp8AxdMj2zRXyJJwaRajmciaXKPwQ7axgvh9Xfbpypm0KpdNk2UqfpeKvNph88e+GpBZcJx+JA08vzvca//xEe2x63tl3630RlLENsCnr+6NAz0Jwkk3QMIFJBB29d1G9x0OLM5ue9c4LyhgWrE8ezRW9yDyakh3stTrTi05PCWfawVvfQn8XAgRD6bVl1VBXRbZaaC24itA6bcpk8vskWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 229e7312-c2e9-4eac-d410-08dec5b45014
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:18:56.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p68gQ/Gc0uu2P1HI9QJjtXSYZhKSaYuE1QwKNjC8Blv5OqTcnzo0y17J8CnWKkxXoiSKUv+cq4chkMHt2CTNy8VzfPIxw8ztlt65ZZYoBwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6734
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> AET (Application Energy Telemetry) may be enabled/disabled from one mount
> to the next depending on whether the pmt_telemetry module is loaded. If
> AET is the only monitoring feature supported on a system and it is enabled
> in one mount, but disabled in a subsequent mount this will result in empty
> mon_data directories.
> 
> Change from a boolean to a count of enabled monitor features inside
> architecture code. File system code only needs to know if any monitor

First sentence seems to be missing what is being changed.

> features are enabled so resctrl_arch_mon_capable() can still return
> boolean.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/resctrl.h         |  4 ++--
>  arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
>  arch/x86/kernel/cpu/resctrl/core.c     | 24 +++++++++++++-----------
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 11 +++--------
>  4 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index 575f8408a9e7..1e50c7dc3fe3 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -43,7 +43,7 @@ struct resctrl_pqr_state {
>  DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>  
>  extern bool rdt_alloc_capable;
> -extern bool rdt_mon_capable;
> +extern int rdt_mon_feature_count;
>  
>  DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
>  DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
> @@ -68,7 +68,7 @@ static inline void resctrl_arch_disable_alloc(void)
>  
>  static inline bool resctrl_arch_mon_capable(void)
>  {
> -	return rdt_mon_capable;
> +	return !!rdt_mon_feature_count;
>  }
>  

This seem unnecessarily complicated to me. Can global "rdt_mon_capable" instead be dropped
and let resctrl_arch_mon_capable() just return "true" if any of the resources are
"mon_capable"?

Reinette

