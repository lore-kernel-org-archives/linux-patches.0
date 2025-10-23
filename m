Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D362E1D63F3
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761193740; cv=fail; b=bGnvXWlQUOFSQWjt4U6vI8r6o6QbeOo7GG0vnXXQorWVGy2oQmEMZpvQ9ptOUNl3OCmhvOciHRnAOdHivXfzpBIWfYwRFxHok6VFG25XRR6BG/hD52TkdAXPWhGVatQw+XGeYG8vXEFwa2LIAuWsV+GSyVqVU9Jsyofq6V+rTe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761193740; c=relaxed/simple;
	bh=7FEV5/z9mJhvoeHWep/7Z12xWYEW9drK/OQYzl35JZU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CLJcdGU+Dv5B5H3Ur0YFNp6jozLTicJDxtNQZwNE6+0McM3x90d5KGrLveRZ13NELDxTem5HC6gPVmRXOhVuuZdcHbSa/w0ri3mEmFeRmvMG/Jl4u9ycMxm9gJgmc9NwDpvarFk+czb+eit0Or0P0+8+2MFKTxNyo54r/3sM7eI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVMtoSPL; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVMtoSPL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761193739; x=1792729739;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7FEV5/z9mJhvoeHWep/7Z12xWYEW9drK/OQYzl35JZU=;
  b=UVMtoSPL+tgk7X2RVSEqwyFGShEpPQb0HUnskTqX8knNIEGi1p0Ni79b
   5g62+GqXVEsQ9lWeiW+t3v45FFKXeXiZ7BWuLTx6NEgVpBk/wk3cfFoET
   tJDaBImS4O2ElLI4Jf45jb+JpPa74c6FS91wG6Uy/Q7xtmFTuZQfGMgI9
   yqZBtq/POs1EMVbSk8qXaAFK7YeYbfpRUL92EFfWw6dMF8CrDQneF5pkS
   TrTgCoPltipKqcI4Q8WgwKGmErf8kSVZ6frcwxy5rhtWLGqZrEhFIPjwC
   GApGDp4V/I5I56ERLzUby39P2gtaw9MmXmOQo/lv6pMx6Y7S8Bsu6QKqF
   g==;
X-CSE-ConnectionGUID: OFJMo34dSQehyH25NP1jqQ==
X-CSE-MsgGUID: N8eMsgn/Q2CRfd3nrPeArA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66997287"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="66997287"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:28:59 -0700
X-CSE-ConnectionGUID: qyedDQauRHuty4ghVvi7BA==
X-CSE-MsgGUID: VXOZD3qYQZig5ygpmp2hqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="189180465"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:28:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:28:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:28:58 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.17) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:28:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yX0aFB+V48qOcJxUlFDtrTgdbb2X01AhjfywfodBSMalwpMPUdPDmgEyDJGI2bv9jcGviXo7MOd+XaE6q9ZnOGTifSomH5gQFPnXPs8Ru7oGAoEPt0IGGi36w2bYX87GBXWyND8A97OH7cGGCWoaocJoUS2WxmVwSH7wYxV3VQ43vmOsr3vEcK+iGBk4sgFT5pjs1y6PEtkyKKIOwWcY8i8XWHnjq/r6wsC50RsyuDYJqmH1SFBqu2dPRusNZvhvs4U/kAxMa1X7C0zT1e0rEVPEVGF8BtEt5UWCtjc/4iatgjgUuycsBSrM7ApOAS12o/MqY444093pAZb3AUMbVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DSGtmEcHoPGbr49OxwuvLqs4FrXKq5Z2M98FGUWmyc=;
 b=O/HQl13xXfUGWGyUoLMjWo7EPJxxEp8uUC6t1Qi954F3DHYL3XHMABUUwLryjify30EDbSl+Eu0lXEdFg8OQWC7N84uLWGSW1GKITrpLpCKb1rqdqhQfIKvLFQEz1ucItcW8+0F5HsaV6ngrm+xR8SbRdSmEfXiRN2OxDARWkPk1K9O9CPZmY+p3Q/DczE+HxmQ8S/XaXkJE15/uuZTsvmoBO80bJB6MeoXX5aj3xmjgUr/wAd33lkSrxtGsT7DmIamIiMJFK5kZAWJrfJ7ChXnk/uC/UDED9tsceBp7GGxkJpXskBBjKSYnEas3v6yfOlz9zUiFBTO9EEBGuIz4EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 23 Oct
 2025 04:28:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:28:51 +0000
Message-ID: <a8c17f3d-39a9-4ec2-a4c0-503aab3757d2@intel.com>
Date: Wed, 22 Oct 2025 21:28:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 15/31] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:303:8d::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: 5448aeaa-e2b2-45c0-13ff-08de11ecaac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RGtRUmR2TWNOdUFRSTI5TVlQbVdLQm9zQWJLcE54amVrSTFyekFiamdwS2tt?=
 =?utf-8?B?a1BuNGI2akNRMHhDQTMvL2hUNHI3c0ZTUmliRGxyUnpsVGlQekpxdnBUNmNM?=
 =?utf-8?B?VU5zM3B6K2VzaXdmVk5pSVVNSWRsWHVaUitwY1NiakVmaXEvSGRCcVRYTkI0?=
 =?utf-8?B?R0R3eEYxZmQzTUdGVXp4NnJ6R0xlRWZablh1M1hkMXdpZlBjZ3RDNDFoK2Js?=
 =?utf-8?B?a0wydU5vbUdiMjdQZjE4clZ5MGd2ODBMcjQxMXdRMUNwQlN5YnBhSURkNHRz?=
 =?utf-8?B?bUI3UXBPcThLcWRDL3hIYVZPanRHUnhXYXhpKzdjNk1DWUNzdUdSc3lOTUo4?=
 =?utf-8?B?UmkvbGY4NFd3UGhUY3ZxSmFmTzRxT1grQm5HcnNuV0Q3bkFiaFZjVzM4MTZt?=
 =?utf-8?B?UVRrcHNyUU1pcWt0L1E1WmhPb0xZVXFkT2JTK0h3bVlmcThjTi9DU1BpQmxC?=
 =?utf-8?B?MWZBc01TYWZtUFBoMGRjTER2TTVCZWgxZ3hoRjJGVm0rTE1kamwvVlhNU0Fx?=
 =?utf-8?B?alNySDZqVEtzbjgrbjViUE1PMUE5cHhESHR0RytrK2dIV1h4cVJnR2kyWUVu?=
 =?utf-8?B?Nk1UV1JPYzdrM0VsbW1RbFZtMlp1ZUJreGQ3Tkt5NTZhTWpySTFjL1JXb2or?=
 =?utf-8?B?cGl0bzl2RkdyRndpZXQ2VVVNa3FHTUVCOGNJYzRPRkRDYTJOM3Z6cG5leEpD?=
 =?utf-8?B?c201ekJxNE1KYVhxSGxobjQ2VGUyckRtaTBtbmxmWkZGVHRFaWl6OEF4bHIz?=
 =?utf-8?B?SWNzRUJEb3ZrdGdhMDVrOEgzVExWdURVNGVjUTA4THdZbXVaMVVIOXEwSER1?=
 =?utf-8?B?UFY1aVRtcE5jTzNCMHdnMnQ3RFFEVzc2LzVoelZkWlZSYVZ5VXNxdFBnVVdC?=
 =?utf-8?B?dFh0dmlicStsUXRQcC9CdkpWb00rV1BkR2V4MWFHUWRjbmU5cVEyNW1mWUhx?=
 =?utf-8?B?a3hzcFc5RkZxNGNES1lITjNjVGxrTGdvbjlEZ0xCejBVUUNBdUtBNVZLbEl5?=
 =?utf-8?B?eXlCaEFyU0tvdXRYWlhPMWN6eS9pZjVQYmx1dkdlRDE0dlZCK2ZGeUxCUjVF?=
 =?utf-8?B?d2pRcHVWaUxDZFpCTjlRdDlSWFJiUFhWU21vbFFHU0ZPNVpSRE51UDRxVVdH?=
 =?utf-8?B?bnhXTnpLSElsRHhQQ3N2TlhuNm1uS2JSQWZVZXdNZTZ5UDJuOFJFVTVXN0py?=
 =?utf-8?B?bnJjTjdkMXZZemhmVGtJUW1UUnllNjB3T2M5NEpKWC91d3hpK1cxaTEzQ1My?=
 =?utf-8?B?QXpkK05VeHphMkUzQlpLYzdJeUo0bmFkR3ZVblBQWkVBZWFUaE5mK29yMTdt?=
 =?utf-8?B?Rk1rbVRIakxSM3VPWEloZWwwcUthYnUvRERJVEJhdkRwNnpaYXJ2T1pKeHRa?=
 =?utf-8?B?QTJUdGs4V2RqdDVjMitKUmVTa01hNnRIdUlNMlNNTUwwZ1RlMVROVHFiVzIw?=
 =?utf-8?B?QmdJOHZHVlhqdC82TlIxamVLL2NlYjJBeHhwTkloUXovSlF4QlFDOUx6d2Ux?=
 =?utf-8?B?M1ZZRWNJR0tzYkU4SmQ4QVVxT3MrQzRtTUVOOW1LOW1KemZzLzZjMlNhZ1pD?=
 =?utf-8?B?ekVvL3ZSOVhSbFZtZzhkV0I1Q3pybHhpR2lYVmtKY0VEOTgzSGlJeGh6RUJM?=
 =?utf-8?B?N2FyNXV4VjAxRXB6RDcrL0J3YjNYa3hPQ1V6aUhwTmdjM3pxMkdlNGw1d3NB?=
 =?utf-8?B?WE9PK2pPZlphZkIvc05PUnNNdGtyNEFiOVJ4YkI4N3RLRlNSWFhZZjNFR0tu?=
 =?utf-8?B?Z3BhTi92TldNTTg3eFV5VW9EVS9xd2I2SDk1VE1KbkMyZnVtaTE1OXBJb2Z2?=
 =?utf-8?B?bjBQaDJXNGsvTUF5bHJVV2RSTlY5QTVWZEJVODBwWHhSbHNvMEw1VUNKRGFa?=
 =?utf-8?B?bStsVGVjUE9DQUE2dTgzK1ltc09EY2ZEd1VidE9CNDhGbmhYTjdvMW9YaXd2?=
 =?utf-8?B?cE9PMWJrRFVRU2FzcURNZXhmMG9EazdtZ05qRHNrbUsrclhnbkNvMm5SQmdT?=
 =?utf-8?B?aEtNTGNrWTF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDdSVHVhR3NrekhUWUFVS1pTM1VsQUFTbDNXL3hycm0vTVQ2UTZuMWJ6d2kx?=
 =?utf-8?B?dzB1YXRwazNQZzUwWTNqREtUWU9VNDBKQzZsREthVmYzWXBFZGc0RnNtZVFa?=
 =?utf-8?B?cUtpUmZXR2Y3cFBHaG5zTHFZbDhmR2llNk1HZUVwOFU5Nmkvb3RPTVF2aTZS?=
 =?utf-8?B?enU0Q205eTBFSWlHT3dFOW9kSXVjZCszMWU5UTN3ekxlTG1CdURCTmM3LzdJ?=
 =?utf-8?B?Y3dFRi9tb3c5dHVLZDgwais1OTkweGN6Zk5OVzFvSjRKMFkwOFZKM1lXNFYw?=
 =?utf-8?B?MVp3WXA4VXEweUsvcldGTGRMWjRqS3dkQ1NTUEttMzlVdUFoeFg1MUdEQW9W?=
 =?utf-8?B?bnYzUVFRSlJNVVVuNlRvbjVHSlV3RSs5MHlEc0Z2OExHcllibzZIbytNMkhH?=
 =?utf-8?B?MjA0L245UmQ5K3RmVmtxcDJ2NlhuSWR6Q2FhVWlVcXFXOVJFSlJDakt5ZTM5?=
 =?utf-8?B?R2kxQTcwb1NlNms5cWZSTkNZTklQMTNPUFVwOU5UMGNnNllhblNYNjAyMjB2?=
 =?utf-8?B?YXVaY1l4NS9MckJzd0RCSUxYY3B6VmN6NEpWbXhkWWpUWnRWSjQ4OENBOWlB?=
 =?utf-8?B?U0svdmdXd0x6ampRZGFpTGgySkc3ZDRKOUE5MFZWNTcwWUE1YXREaUtRUWVs?=
 =?utf-8?B?cHp0SXdFbEJkeWYzUFlJSkMvbTNrVSt3SXB4dUg2TnVhbzNvN3JPdE0weFFS?=
 =?utf-8?B?VG1BUWJFeERmam4wNGVZSisvTFFJa0RRSlo5b0NIK1RNeG1OcjNzTnhtbDl2?=
 =?utf-8?B?MHFkdFIxaExROFZRV2Q1b2pBTkFYSDEwd2ZUdGZCUU1LcmdjeWFFYlFHS0xh?=
 =?utf-8?B?cUJkOHc0VGlvaVE0V3BwUTBCUDRMK0s4Vmx1YzNOUWthd213elpLNVprZEEw?=
 =?utf-8?B?WEEwb0ttVnF6ckNtZFR3WjZIYVZibkM1RjA4OHY5emZxeW5PdVYyL1Z5eFBG?=
 =?utf-8?B?MjMzaS9QbmJRWlY4MEI1Q1dUWjQ1cXgrd3I2S3QzL042MFJGWWFMMGc2OC9z?=
 =?utf-8?B?clBHeVE1QURBV01tZjhhaGcvcmprZTVscS9tVTJTK0FyYUt5WVNydWdMVkpF?=
 =?utf-8?B?THBjYUJ4SHRNd1RrL1I2QjhQRkI2M25Fb3AyTU03Qy84a00ybUM0YXpiaStE?=
 =?utf-8?B?eWVLTmJFOXdJZ1l3V0ZNd0IzYjdCczQyaVp2Qnh5Tkd2R0hzbXk4aUNzclJw?=
 =?utf-8?B?SVpEaldYWmJleXdTR3N4aVBHbWRWTzN3eENLVkxrU3BkaHEvV3BYOGNrb0tE?=
 =?utf-8?B?WmFLYWljVEtJdEo5TW1VREVLTVRMcVZZeVB4MVlXNDVIV2RtOXpjSnE2OXN1?=
 =?utf-8?B?ckl4a1psajBjdXJ3V0hWalNJY0UvTWJOQzNSWGpkc0xKeS9tNCtWL29hSEEw?=
 =?utf-8?B?dDBKeEVsZGFaZUFYWm90aVhnNEF4emtkSm8rZUV3dGhyd1pMOUhnMDViZk8z?=
 =?utf-8?B?ZkNvczFtK2pwMDN5Um1UbWM4cGJ1dHErNjdBdDY3UmMrQXg5SW0rSlNXa21a?=
 =?utf-8?B?U1JqMW5McXNwaW9MLzcrSjBOZWhYTjBjU2d0TXZHR0ViMVU2WEZXOEZXUkFl?=
 =?utf-8?B?MDBMU3VxUUpwQnhKekdvUlZaRnA2YUFEdXloMEJDRzV4aHFsNFpUZnhhbHY2?=
 =?utf-8?B?VDJneUFTYkU0WUJBaEVMMG9Mc3pSaHNXcVlKdnM3UnFhYmxFaXNOOURFNWxG?=
 =?utf-8?B?WVhxbDFaN0R1WXUvbDR5RjBZcUlCak04bGd6WGphM21EY0o2ais2Rk1OU0RG?=
 =?utf-8?B?QUlBMDQ0NjFqbXlZU0dDYWY5TlhPbHVxL0J3cHNsZC9qc0RaM3d5MitmRHNu?=
 =?utf-8?B?K2gxRE5neTZSTlNnV3Ixc25uMWhNYW80RGprdkExOGhOTVcyUUR1dVhqbTNL?=
 =?utf-8?B?OWhhMDlhWU1GQ3FhVGV2VjhlK2lHWDlkZElCWVpYSDh4MERNeFdYeE5xdHJ5?=
 =?utf-8?B?OE1NYXN3REx0SFg0dktIaW95akY1dVh4Si9ZeHJYYTJmcVBkQzBmL1hOVkFm?=
 =?utf-8?B?dFBhR1VycGRlUW1hWEsyL1BJMEt5c1VQRVUvSkIvU3h0dHBwVTJKV2lNRGFm?=
 =?utf-8?B?YTBTUklhK1pXRy9OdXNDbTZsU2RIbWNabW1XcGpjcnNVZit1Umc4Y3RXLzlr?=
 =?utf-8?B?QXB6dlRiVXJUOHQwbUlPQ2hOV29qbkgxQmE1ODJwc2c3aUUrT1ptSGlCMXRk?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5448aeaa-e2b2-45c0-13ff-08de11ecaac8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:28:50.9642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJEr2eIlOx1kypC/xHEIXiEKIi/y+P5PgW2ojEFpQCJQc/zjULb5M7fZqCbC0SC8WIJkUeLtvJPt0qXM7wOqqV1Ov+wg6lrJJ25QQA/d9/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> The Intel Clearwater Forest CPU supports two RMID-based PMT feature
> groups documented in the xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml

Considering the new design I understand "feature group" (thanks to
struct pmt_feature_group) as all aggregators of a particular type (type
being either energy or perf) where there may be aggregators with different
guid, each with possibly different events. In comparison I understand
"event group" (thanks to struct event_group) as all aggregators of a
particular type (energy or perf) that have the *same* guid and thus the
same events. Does this match the intent?

> and xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml files in the Intel PMT
> GIT repository [1].
> 
> The counter offsets in MMIO space are arranged in groups for each RMID.
> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> After all counters there are three status registers that provide
> indications of how many times an aggregator was unable to process
> event counts, the time stamp for the most recent loss of data, and
> the time stamp of the most recent successful update.
> 
> 	MMIO offset:0x2400 AGG_DATA_LOSS_COUNT
> 	MMIO offset:0x2408 AGG_DATA_LOSS_TIMESTAMP
> 	MMIO offset:0x2410 LAST_UPDATE_TIMESTAMP
> 
> Define these events in the file system code and add the events
> to the event_group structures.

Could you please correct earlier definition to help make this transition from 
"feature group" to "event group" clear?

> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT # [1]
> ---

Reinette

