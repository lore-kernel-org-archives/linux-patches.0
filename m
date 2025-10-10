Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D872288AD
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 01:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760061281; cv=fail; b=MWMaG/gy/osZSsaUY/v4rrj4TpjCgpdhjuJz2goR49bD4XpjEn+SIxEJhPxH97dC1gyII7aHM1PwhSlVY272CRY9lKIenI0xz8HKXnpauxKDWJP7fdRanly4ipvMQek3bM1UgObyPV3zTQejuQTKEteSoH7HD2lHrcSLfZ7/FqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760061281; c=relaxed/simple;
	bh=mD2ZdlA+KJRvaibF9uXwCBytLwxpwgWqwea4CtR3IDM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TuTsqVDRruDvIRbr98sub2UbX/oxJKytwzWb6RN2kQk5HHOH7+5jrK0u7f7knRE9kOX09ttIHfpZYNeh68aSXTHIrR/bOqw0ZeFZwrjJvlu3Tdi2dm89G/KZa7YV0qMC9B/36eONXbUZOM3ReJ4yuwVVLlUO/ZWplAvL9iTGlOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aoCupfcb; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aoCupfcb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760061280; x=1791597280;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mD2ZdlA+KJRvaibF9uXwCBytLwxpwgWqwea4CtR3IDM=;
  b=aoCupfcb7hKRFcy72hq8ER+FfQGvq02rupGsVzH1/Fb/v/gAzRmzNJ+y
   VCugNSYvur675yABC9cWZ5Tl2zLzfN32D3OKUKPzroSQFI1tj5Uljndt8
   p2YPni4TRzRVAaGZyV7iZY2CvP+Cpvt0W9G9bfdgR38oEs/qZTFVfqZl2
   +R5y9wkNqQlm4y418oCWIB+mXhYtA9YT+Xtl28xNo8FPOdFzcRLcXV53h
   Se1CQzH+DAH+EngYpkM9AuMthZIAyfUaR8bHvRy337vQ5m6tZm5bZkOps
   F2bMrL2/z4HURdjPnOxI7ZhNIg2WUq7dFj3UA8NlAZNRhISOvnuiwSWJv
   A==;
X-CSE-ConnectionGUID: 4eGrTOGXQy+y/I+VJ+oJWg==
X-CSE-MsgGUID: nMxFmjzFQpuVc1mFz017Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="72962758"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="72962758"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:54:40 -0700
X-CSE-ConnectionGUID: YrP0cJ+aTUq0xrXLvQ8RFQ==
X-CSE-MsgGUID: XlykGSE+Q0ChU4nad30L8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="180108015"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:54:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 18:54:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 18:54:38 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.12)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 18:54:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CKKfBWIQc7k/9zsVG6OC2hbRkAUSbISppAg4M+bhUxFcuBNHFstj4mdakpD88LVpfsNLC657sBJ1KUuy7sdhxqRbVGsLw2zvwRt5toS9qkUTNFZeGvmXQzFeLrtv2bVfKrgIL0C5XulCfZQCLIdFvYIEhAdZ99DqLiYjdHP0jwAnN/TZy8348RqPrdglKDAaGFnksBBK/lVGNHMHkBbsUmOUdKoIqyjj0iHBRj9I+iiw79H+nJKaZcix4YhVHMpiU3vZTHineciPBefXooIP/qjerwVzmm2CqgEcM6WpHA3LvCYJe0KhDHNJn62FPQC5Z6vEciYByIQhUB5DDoJbOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSmMXvlawptIvzF1q4PWd4yHOYOGL/5vi0fX506J35c=;
 b=Eu/z/kJQmaDpZPI+riuYfzA2Qucnnl2zTOgDs3CNuz9SvQ4CnsOSbtZGnjPJIjkV1+/HGphYpNxxmy5TrRJnAHYO9gjKjja19fjQ8K1rbI3LzFceFAmMe3nb4oHq6HuMnlGNHrHoyowSW9zXoyNQwyuusTvIOJBs6GxHzFolRz+jytXSkHPtfgOeyjVyoHOAVNurZ01tZ8wGcWShsGtslGw7UbIvrCo1hWLOT6JpvSoEkap1ma/JYVF5x56AxDNHohg84vMWS346MQ5+02Zy9t/uUhLUzIcCDwuB98ivdF2e3g2VIvmcNp13hi8b3a7VTZ8k8Z/CRtvJfiSueZHJ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB8303.namprd11.prod.outlook.com (2603:10b6:208:487::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Fri, 10 Oct
 2025 01:54:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 01:54:35 +0000
Message-ID: <41cac4ed-c217-4a7a-9e78-1f0a599dfba4@intel.com>
Date: Thu, 9 Oct 2025 18:54:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
 <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
 <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
 <aOf0yA1AWlzJLf8H@agluck-desk3>
 <6778a8af-5312-419e-a064-bcb6a495a207@intel.com>
 <SJ1PR11MB608328747C28F736C6DD5FCFFCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <1ea9cff4-e93d-4be8-bbe2-308fc05eb3d1@intel.com>
 <SJ1PR11MB608302F7FFA34D93EBD77640FCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <21cd6535-a51c-4a8a-9e82-328b03a8fc40@intel.com>
 <aOhd_A5L8PV0OYba@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aOhd_A5L8PV0OYba@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:907:1::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB8303:EE_
X-MS-Office365-Filtering-Correlation-Id: feb1ebd8-64c1-4d63-5521-08de079ff6db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MWt5elJpa1hLaHBXcE5oRUdiU1pjTW9XaWdsaGdLdnlzWFJsR1VPOWYvZkhX?=
 =?utf-8?B?Z0ZMWm1DbWc5eWd3SVl5TzBjTXQ2ZUR1eFgrR3ZaZVhJN1F5Rnd0UG1vZFJh?=
 =?utf-8?B?YS9nYngwZHB2SGNBVmF5bVI1M25VYndpSngrWEY3d243YXROMFZoV2xkeVNC?=
 =?utf-8?B?TWRTdXA0SkUvR1krWG9lN3JvM2E1TmxxRWtMbGJ1dENLSmFSeFdSc1VxRk5D?=
 =?utf-8?B?c2F5V25pRlJmWmxvc3BMN0ZWQ0ZJVnkya0xGK1FUUGZlODBLVUp2cVlUNklX?=
 =?utf-8?B?YUNLS3VGMTN0UHBtb3hXUDBhcVFYRCtKRWl0UU5jVU04dFRoaXNCNjUvU2NP?=
 =?utf-8?B?NGZOWXNNUUEwUnZzUDFjbTdUQVNHaFVjMm1ydnlqdmNTNkE1V1pHOHNrSGF5?=
 =?utf-8?B?U2dtUHhkelAzR1RwSHFFZUZSV1IxcjNlNnZWN2RKVUprNXZCVzYzSDc0TlYx?=
 =?utf-8?B?aytxMGRnQU5sVHFXY295K0xERG9XdmMyeWhzMldnSHlLSFU1MHIwdmhiVW1W?=
 =?utf-8?B?TmVRWFM3UFo0Q2VTb2dScnRhSXZwZHVCMDE2NmY2TytxVE1JRERIMUVRZWVo?=
 =?utf-8?B?RVNCbUJpZ1E2SHMzWVpqMVNrdHlCZFVGMFZmRXQ4T0hLdzRQeHlIVFdRbEht?=
 =?utf-8?B?QnBPa1dubGNEL04xZno3QnYvQUE5Qk9VYlBLTkZad0l1bURQZlVScHhYUGMz?=
 =?utf-8?B?SmlYUm5zSTBWa095MXdBUDFGM0poWE1saFUxRUFXaVZIMFRXV1htMzhESFpx?=
 =?utf-8?B?dlNTeklGczdnRTVpVWdNMlZUTkE3Y0s1dU9wZHQ3Zm5hSmdvVm01QnFrQXhi?=
 =?utf-8?B?bStnVUxmOUtvV1l4em1TNlBvYWVKV2pOaHhqSzlWZ1VEc3IrU2ZOanBmZDAx?=
 =?utf-8?B?MEdIVVk3aThudUpYYnZWb0ZnTTBmMGdaRXBHSlhjeW1Lcm9GTmw0bitVR05X?=
 =?utf-8?B?ZVJ4dkR4YzNVaFB4R1pKYVp1Wkp3azBCeHNQRGxmN1JIQ1pYcjdROThBWFEw?=
 =?utf-8?B?OHlpSkNEcFQ1Mi9zclg1N293MndtWjJ2Rkp2TVRsZVhDek1RM3BrQUw5aWYy?=
 =?utf-8?B?a1VnUEIraEprTjBMTG4yczN5a1V0N3dZSmVpK2JnR3k5Q2pwUFpMY1ljdVFR?=
 =?utf-8?B?UllPUUxSNnVWVjVyREk5MWg1SG1uQmc0QXZ2ZWt3Q2Y2eHN1aWdSYjBBd1pM?=
 =?utf-8?B?eXdOUHJsbGwvdmI2U2svVk1IM0NhZlpHaHp4Zm5DQmpFYkMraTVPUnlZcXZJ?=
 =?utf-8?B?NnNpZjBFbGNzYmlteC9SNURsbUk4R1o5YnZPMkJiUVA4eUkxc0hNNUN1R1Iz?=
 =?utf-8?B?SUVVTUh1MktSaDk0V2FtczZvMUZGSm5Va3p3UmVxWUxSeklnbjRzNUtqR2pJ?=
 =?utf-8?B?Mjh6YXlTR2JxVkNyeURvWXpaNWhHeTFCckNmR0VNRFY1WHkzT0dtNTRtTHhI?=
 =?utf-8?B?VDZiUUhYZnpOOHN4YTNON1g5NlZRQ2k1Ym4yMFJxNVZWM1ppRzFyQXlleC9s?=
 =?utf-8?B?cG1YL05GTVVRZHIwWHNEcFd6ckpTbE8xZXdwUnB2ME1GTXZPSEJmZy8rMy9X?=
 =?utf-8?B?bVBhTGVqWUNNanBPdWZVWGdrcEI1bFZ1RzNkQWljM24vNlNiL3IrZmt0cTEy?=
 =?utf-8?B?QjF5Nlc2SkUrQzQzeEhhTE9iSkdLYU01RVlELzVIMlJqOVU0Q0FjWmppVjFK?=
 =?utf-8?B?YXluYjBLT1V2OWEvVHpCRVhUNDhvRitSZUZlVnFUais1dDdoWEMydXVhUERC?=
 =?utf-8?B?M1REUEZoZDJTeCtnQm15aTByZ3gyMm5jUERIbitoajZsYkhIcS80aFN5dTho?=
 =?utf-8?B?SnJkbHZnUWFoN1QvMWN2dXpDbGM1K0dnc2pVZkZCd0Q4Vm1VbmwyZFJlakRN?=
 =?utf-8?B?TVdBNEQxRFRGa3RDMXBpdGoxZlVsMVV0ZTFGZjBoNDRIcitLN3JJNDJ3VXk0?=
 =?utf-8?Q?XNzCtipZzR2XaUcShSFUm7gJHWgF7pzS?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0NCTXZLZ000UWJ0WXdGZFFKY2tOU3RoZE1RcGg1eWp1d0RzcnBidFdwSFp2?=
 =?utf-8?B?K01oV3FmaWVzL2J3VjgydDJ0Ym83QXg3eGV3RzBTUG0rWDNra2ZKNVRCZCtC?=
 =?utf-8?B?aFBsZEs5ZWd6ZktaT3I1TEcxdUFIKzJIam8rZVF6MHdsVjNtY0VmWHk3Wlo2?=
 =?utf-8?B?YjQ0TWdLT1NIQSs5QzllQzR1VENzLzhKdE1sY3hVVEpkMHpCYVlmb3JNQ1Bv?=
 =?utf-8?B?SlVNeGFiTmZqWlN0bis3WlE5amJ4N2dCcFhHaTRHSG4xdTNCUGZkcUd0aUtj?=
 =?utf-8?B?bUdrZkRWQTMyZFJaNGtSaTBqMVdCR21MNDNWRnZ3Ynl2S3c3a09BZEZsR0VK?=
 =?utf-8?B?Mm5EQ0R5aldTQnRJU3JXTCtQWmxFSDQ3ZEQ3L280ck1aVFpZUVFjdU9mU1Bq?=
 =?utf-8?B?dGZxMnd2L0lZYVlvQ3E1c0M1TEp1Nmc2dVB4OFZCWW5LUWxhd0x6OUZNTnk0?=
 =?utf-8?B?ZmJ6NjArd1VsclR5clVBS3lreTlQSFFDeFlodHhFcFlJdXpWUllOOFFieFA5?=
 =?utf-8?B?N21meitoZVBtaXlvVXFOTVViV05lMEVHa09zODBVWG8wZzFVT0ZUUDhqUUcw?=
 =?utf-8?B?d2d6a1hBN2YwL2sxeTZsekduZTJYRDh0dHJpU21mQ3IvSi9waVJySUVCYWNM?=
 =?utf-8?B?VC9WRU1wU0hoL1NqM2pEZFdIRmdVaUdlMWtudEtiZlBXZFVMbHFXb1BTVFdI?=
 =?utf-8?B?dVB0d1daaS9mNXBwa2lCaDN2ZTZSc2xOTHRxVm0wRGlRaTFFc3ovOE5yR2tF?=
 =?utf-8?B?RHZWbXFSa2ZkNXBvU3B5SFA4bzh1a0F4UUVUQ1VhekppT0lxc2g4Yk51dU4r?=
 =?utf-8?B?bjdsL1BibVJBekZIN1Vya1JEWXRKU0gxeE1KRGtYY1JpNDUrbTlqczJPUXNi?=
 =?utf-8?B?c0lTeTN6QnNvSWhTZU94R29DemxkZXE5QURLS0lOMmJnakQvOGpib3YydlpK?=
 =?utf-8?B?SWhZR0xzRzgwSFpkSng3WXNCV2FwZ3VucysyK1gxR2txMmZ6aElVNndhQTV1?=
 =?utf-8?B?a3VUdWs0M3gwWEF6TEpsRjVVTmEvSG4rb0xmY0V2RTZjeER2VUREUGJvTFV6?=
 =?utf-8?B?eUw5aUhNZWNheEJzSVJVaFZIZHNSWHBrS0dZcjhydU5vZ1NmUHg5QnZ0MWNx?=
 =?utf-8?B?amhHS3pkSG9Dc0syWll4S0diSGRRSWdQWVB1SE91eDdRU2hJK3ZRcWZzc1Vy?=
 =?utf-8?B?dXNnQ2Q0LzYvZEF3SFJpUEF5VVdPYVFSMG5qSVdBMytEM204QitITUxYT1ZH?=
 =?utf-8?B?dmhrcHFlK0ZoM0hHaDV1WFlsQmxTRVpwNU1vTy9GUnVhK213TGoxRVpGT1pv?=
 =?utf-8?B?eDB1V0k2emNWaDB3VXJqWEt5S3VydTBTZU5oRXErTFJCQ3N1NTlQSVdPQktz?=
 =?utf-8?B?WXpxdTNoUDRmRjUycGFEUTRxd3lla2wwMkJac0N4WVJ3TEZobHdhTFM4Y3Nj?=
 =?utf-8?B?Ri9PZ0RaMTFPRzdoRlkzUU04ZEZGYkNpSzdBZUk5aXVPVmllOWtKbXJGVDc0?=
 =?utf-8?B?Tk5lT3JkK2pqZEo3UEVUVzIwa3RLYUhmelVjMktXbjV2OU11V1IyU2xLSy9u?=
 =?utf-8?B?RVRDeGllVm40MkF0S2psemFBUk9GSng0VzRDVmkyUDB4Y2FDQnlmK2wreXpF?=
 =?utf-8?B?REsyWXI4cG9ENlkyaUtvWTdBNHVwVjJBWWN1a1VUQ05JTmsrUVMvdGFuc1ZN?=
 =?utf-8?B?TGNmMHB5RWFxQXdrZjl4UHVRT0JKd05TVW9CUy9EVDNtMkNLRTZGRENSdCth?=
 =?utf-8?B?OXRwNlNxcHFOSVVqNkdGSGJSM2JBL0lOQldrbjJJYmk0M3AzbkVxTzBCNGNO?=
 =?utf-8?B?T2k2UjZNYVZhcUFUcUZpclRNTWxtbmw1U3E0eXRiTlNmdkhvbjJkZVcraXVn?=
 =?utf-8?B?SElUYjFSZzBWN2l0YktrRXpxdUhyTG9GVzQ3N20xaTd1ckZra2xFT1VHWko1?=
 =?utf-8?B?TWRiWm91clNlMXZkcEc4bmFCc1pnZzVZNnNHME5hV2x3WTBvRTBjMVFmNkxV?=
 =?utf-8?B?K1M3QjNEcHlBUmhMdjVOTDNYaTh1aVB6a0ZmemNyQ0d4RVBybS91dVQ5TEhv?=
 =?utf-8?B?UlZxc0tQZlNKdTA0UC9SVzNJODBLRXhPQ2hSSzZrT1V4OUlMMGR3b1hYWWZ1?=
 =?utf-8?B?aE1vZEVvRVZyWkxMYytGSkRRVVJjZjd3VjJDZGs1SnRnWlVjZ1NWRnIrSzN5?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: feb1ebd8-64c1-4d63-5521-08de079ff6db
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 01:54:35.8436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0N8Un15pgWfaAZsspxxBPlgWhcPgPDH4dUwhzhJ99Wwpo7cbEezLLyiLu+88pPI9dJUiI/4vs8WOkFyccDe2lhTl5ZbhEspv3yyLcRVFG24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8303
X-OriginatorOrg: intel.com

Hi Tony,

On 10/9/25 6:14 PM, Luck, Tony wrote:
> On Thu, Oct 09, 2025 at 05:16:00PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 10/9/25 3:08 PM, Luck, Tony wrote:
>>>> I did not mean to imply that this can be supported without refactoring. It does
>>>> seem as though you agree that mon_data::sum may be used for something
>>>> other than SNC and thus that using mon_data::sum as a check for SNC is not ideal.
>>>
>>> Reinette,
>>>
>>> Yes, we are in agreement about non-SNC future usage.
>>>
>>> Is it sufficient that I plant some WARN_ON_ONCE() in places where the
>>> code assumes that mon_data::sum is only used by RDT_RESOURCE_L3
>>> or for SNC?
>>
>> From what I understand this series does this already? I think this only applies to
>> rdtgroup_mondata_show() that does below ("L3 specific" comments added by me just for this example)
>> in this series:
>>
>> 	rdtgroup_mondata_show() 
>> 	{
>> 		...
>> 		if (md->sum) {
>> 			struct rdt_l3_mon_domain *d;
>>
>> 			if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
> 
> Exactly what I now have.
>> 				...
> My "..." is:
> 				return -EINVAL;
>> 			}
>>
>> 			list_for_each_entry(d, &r->mon_domains, hdr.list) {
>> 				if (d->ci_id == domid) { /* L3 specific field */
>> 					...
>> 					/* L3 specific */
>> 					ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
>> 				}
>> 			}
>> 		...
>> 	}
>>
>> This seems reasonable since the flow is different from the typical "check resource"
>> followed by a domain_header_is_valid() that a refactor to support another resource
>> would probably do as you state below.
> 
> I looked around to see if there were any other places that needed this,
> but they all have checks for RDT_RESOURCE_L3 by the end of the series.

Thank you for checking. This seems like a good pattern to use consistently.

> I've added a check in __mon_event_count() in patch 13 that gets deleted
> in patch 18 when the L3 code is split out into a separate function.
> 
>>>
>>> Such code can be fixed by future patches that want to use mon_data::sum
>>> for other things.
>>
>> This discussion digressed a bit. The discussion started with a request to add a check
>> for the L3 resource before calling rmdir_mondata_subdir_allrdtgrp_snc(). 
>> I see this as something like:
>> 	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE) {
> 
> I'll add this. Same is needed in mkdir_mondata_subdir().
> 

Thank you very much.

Reinette

