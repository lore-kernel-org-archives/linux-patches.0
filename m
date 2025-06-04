Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439561E3DCD
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007875; cv=fail; b=s6CwH6sRxKnsoVE/2s6yg3gMsfnMkhVQJ0VbH4x/Lbln0aIx++J1VzMpH/OI4h2zT7WB7hsic2jVQqJvsnKX8iTwsPMn2Xq6kaC8TNticrjc7l3IEMOq31q+ZZKaZF3IvBIMTgV4AM3RN4UzueqM2m7Snn2RJR2N8QPB1Pg9z5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007875; c=relaxed/simple;
	bh=tcRwoc2iq+s1q/U+TNfKpEoVK3yyRKz3a/pseJ8dxko=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hLAltCKEINkULKIMTFuXp+SZBymvFCMDMPdHBhtVC24KKhPLtP3+vb0ffB2F9BXG9+xsz7PbNekFg3Mnjh+YOPy48wCt2JV+/bqKzpqDhqHTL11suPcFmS4RivDY4UQkhQ322IzYy/3wJTG5VQZOjqapwvHHaPsZfki0QcJw/QU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMN8g5eA; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMN8g5eA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007874; x=1780543874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tcRwoc2iq+s1q/U+TNfKpEoVK3yyRKz3a/pseJ8dxko=;
  b=EMN8g5eAZkM/aekG3FPD3dOLeQ+rRfyoPMiJZqWtztpcbOVLs9e5/Hpc
   h/6/rngrsB4Q3U6hkNKOpij0TqWKpNANZI0bgNg+iHVqW4aTNkmdYRVSY
   4fiRJ5vcnAg57E38Z5wNKpt8Lmr69kuyhFQtyDnBd51UX3OPf2BGhzNKu
   3KEfMnrSR1wBbmMpcVbz07CXNfftXHygg91hZz7tzNwY9QLAeXPIGqZbD
   WwJWQ71ek3q0Ul7t7PbayvF9n/SUellCX62y2tYrQqGOc0MsGXCMSscTh
   NW3FGzJzri56erx07Ck8/7gQnoOFyWiHvLoxX3R0dMbotUdIFekNciqum
   A==;
X-CSE-ConnectionGUID: R116SyyTQG++q2bUF0fWKg==
X-CSE-MsgGUID: aaG6+6LzRl2OzFUNLyDCyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="38702448"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="38702448"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:31:14 -0700
X-CSE-ConnectionGUID: KSAxx4rkS0eJFpkZViRTfQ==
X-CSE-MsgGUID: l+nL5EZpQN6+bzlXp+WQ8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="149836422"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:31:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:31:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:31:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.84)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:31:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fa0KUvfZi+2BxERiibQFwQApOwbVBfMW8w3KB6HmDvZmx0yfqk2rxmrKDtCNz2kDvGrRfbXS31sSlpKUAy2epg98dk7XoGN6sI1381OSdoryChiogGtOulT+vG013TW/D9Im5RlCI8ypHf7+95DBzNqtB/hJgOkOr781o6HpJoL9a4hrIV3uGXMyVvq3AacAaI/wv9Jgr6Fs6eIiBetiVVff+qeEpFQVNsLGZnVlRe+DR0ivO9C3/NsxBppMiZY5+tV692UudAIV+jx/1FZHY8Bf90rKS8Ve5gD4x1mMJmXHVE8SNqlwqmXQyodbMl0YpxoWyqkCFa1YAdDvFC23Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzeTfgNAbbjYtKNhbQqDEDYnhWPblj7/Jkm6CTMkrbw=;
 b=KhtB7UuT58cA5cd81ElW+aWLySfb4bVVtud4mn+z5yvCdI9F1RmktV2ARviHw/qeCzJuFFGGeESXyhyd5tYcfnJmNkKaS4MZb8SumUgZJmSNj5+3X6pvHKBG953MbHfG4Thb+jr/PUl3u77qGttr3bt7f0jNdr0zmFC0D2qbbV6kErObzmRQjfY84A/ChwbpBAi5AH88cd3NjrZ9RTeMA63A99EWVmvPn48uj1zjG2OoPGXkVpUELKRcIhZszInw3FUomTbMIG/HFpkd06sJI/zULXmpGkPHFBWgk+H3glT/AyHoMWHAO1z0OJZRHHj4wCtjHKBRWmb3zYcgqclbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Wed, 4 Jun
 2025 03:31:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:31:09 +0000
Message-ID: <7de291ed-a29b-4768-9b27-7fd9f5602e37@intel.com>
Date: Tue, 3 Jun 2025 20:31:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/29] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0184.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: cf810508-551c-46ca-42cb-08dda3183f60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dm91eGZPL3BZNUlnSFkwRGprVmVzS1dJdHNGTFI2bGswNys3bVdhNEVROUM4?=
 =?utf-8?B?bXhMUlJ3eVlBdVp6RjYxb2FoY0FNQVV0MmVCWGJ4ZGkwM2dMQ2NzVW9TOTRi?=
 =?utf-8?B?MGdaeWZoQ05ickdGS0llK09nQVR0Y1VDMG1NMktMUk9uSnFYaWtoc1NWckJT?=
 =?utf-8?B?cXhNWEZLZkxhcVJVdnVaVHh1WUZCVFdFSjRSdnhFRHhJLzZJdEVRdkFpWmtP?=
 =?utf-8?B?RHVreEE3d1VKYXVmMUdaMlI3dXVBNnEvM3FBajlYSERhRi8yUDNOQ1UwWFRC?=
 =?utf-8?B?SzMyc01CUlNYOXBTdzBEWElCM2pLUllzRGRSSkJqbUp6ZEtmaS9RRVhBRThX?=
 =?utf-8?B?czJwendzSW12aW1NVERBUjVQVE9GdllBQzU5QWFoakt6cFBXajlyWExmQWtz?=
 =?utf-8?B?OUg5a2pMbTFkQXZoWkhyd2NvbGxnVTRQQ280TDBPaEthR2VKVlpPL3V1Ukc2?=
 =?utf-8?B?ZWVYczkyVGVTNEIrcXNacnUvQm00djdCNDJ4dUcwU3d2UWNGeGlQaFhrK2lH?=
 =?utf-8?B?RllVTWdaTVhDQ0taNW9Ccm03bGlGaVdxUWtIa1VpUjh0S0dvdUs5QUlRSWJR?=
 =?utf-8?B?dW04WmZoamhSMzNDQk5mMVowL0FzOWpEOUlZN2cwSnV2eVZYMU1OcVdLVk5D?=
 =?utf-8?B?S0FOOTNZejlCVjZySkZZenZScHVCVWVKTzZoSGNxdTVmRU9NVUZzeU9HMldz?=
 =?utf-8?B?NHdZTlQxeFRDeGZBMElXbUFOckpvblBoRVBUUkU4TmRsSE1PbnNQeFhlUHVP?=
 =?utf-8?B?QVc3d2RNdnpCengwaEpWaUlWWERTMmwrVVErd2Q0RWh0bFdZVFNFeEJBYTJB?=
 =?utf-8?B?S0hCOU00VmpwVndueWt3Z3V5bEVlYkNpVXY2alJmcHdCZm9Pa1N0UmY2b1ZY?=
 =?utf-8?B?QkhCK2ptV0FxVzRRNkp5U2JGYktmNGxkUCs2RXJNR0NQVDNyZWFNMmZpZW1x?=
 =?utf-8?B?V0RuR25ZMDFJZXppeG90UXNqN0UrdW9LYmp3UXlZYnJaVVFVK05FOWdCNnRH?=
 =?utf-8?B?anhVYmFNK2RmTVc1VU8vSmsvalArME8xazJLL2hGNzdwblFmMjQzZUFVM0Q5?=
 =?utf-8?B?Z3pqQnNNRC8waENmUzJGSEtndnA1SjJDQ3lSUEVWUTUwUjRCdTFJbEdrRGsz?=
 =?utf-8?B?TUkzalNQNk9OZkkyQ1VIeWZRWkRaVERJYzNiUS82dG41dVdLdWtWdXB0bU5C?=
 =?utf-8?B?UEdEcmVNa3g5ZTBGZ0RZeTUvbDJzaTNMRmJHd1RZWVE5Q3RaTXBxSGFwd1lY?=
 =?utf-8?B?UEVQakRxYXBFemlKN3V0RWhRVCtRM016MTFnd09lZmJRRVRzTHgxWUYzRENM?=
 =?utf-8?B?bDNiRGxvWURpT2hwbDY2TkVHUmo1TUNKRFdtK0JFN3R1ZlpTYjlwV1MyT2xU?=
 =?utf-8?B?cVhQeVNJVG05TkpSUFR6ZnZrN3JmZm9seUVJbDY1YzFtTFJjblZqb0ovbjJk?=
 =?utf-8?B?ZlRCVk0xb1I1VnlNRFlWK0NlZHpJMldCT2xPT09EWHRKWHM1N0xaQ2E0eWlq?=
 =?utf-8?B?RTd0cmVqOThvZ0VieENHM1VCVWpIQjdmSkNkYWlpTDZ5aGE1OXZGc1B3NGhZ?=
 =?utf-8?B?eWNPR3ZYWlJaZXZRSkNPeUgwdW9Cc3ptMVc1dkJIZUdibFJRR1Q3ck1mdk5o?=
 =?utf-8?B?N3FyZkVCNkZHWEYyWjJuUGJWNkVQeDNrVC9zMjRzWU5adVFCa0w2ekFLYWRC?=
 =?utf-8?B?bm1aU0p3Sm5FSVB4R0xqcWk4a3ZpdmFraWtQckdwNHV0SER4d0x3MUNZTmcx?=
 =?utf-8?B?UWliQXZhME1USUFINDlrMTZ6ZWJtbnVBcFFlTDNCdE9pSXNKbDRvREJYTG5v?=
 =?utf-8?B?b0FkSmhtUUF3MEJnZnFPL1M5Y3JIcmM3NFdkZFkwQ2UxMysxeks2OFNlNFlW?=
 =?utf-8?B?Sjk1Y1NtM2dGSjVhcGNBak9FbHJUNTErdHE0N0V1NlEwVlpPdE5BdFdueVNi?=
 =?utf-8?B?a3Q4czhYRGQzZlVtZjBzOWlSWTBoMGxCQ2Y0b3NaWGdtT2FHM0c5bkdHQy92?=
 =?utf-8?B?NlVKUWhkbGhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU1seWR0YjI2bUNkYWZnZTVTNG4rRHRSSDFCWm1zSDI5YURhVHNhME4yZTk2?=
 =?utf-8?B?Y1VTRCtqcGkwa2Z4YXJkZkNEU0Qwb3RNNVh2aHgwcEhFS01kdVZvcXhiZEhO?=
 =?utf-8?B?aGFobVIxVmYzOUxGRXJWN3lZTC90R2JVeWloc011OFg3cXYrcHRoZUtHZ0xv?=
 =?utf-8?B?NTB6cU5CTnVrQjMvS1VhbzVwMjBXK0IrMkZERXRxaFFDYUNNbzd0ZDJrK1B4?=
 =?utf-8?B?NUxId0RUZnJGOUhabzhJZEoyYVVKTmR5YWgxbGREOFl2WXRSSHFKVEhLL3U3?=
 =?utf-8?B?cTNQOW1PNkpYVXliNzNLY0l3VWNXL2dCakdVMko2UDBJVTFldTQ5cjlyNXg3?=
 =?utf-8?B?RHNDd1VwMi80d3FJNjJJcGVkZGRWV3hocUhwRVlUZGVTckN1ZGUyK3VTYWR6?=
 =?utf-8?B?aDcyeDAvWlFxRUFodE1VQkFIZHFITkFlZHdZOEVMR21jZ3dWMVBSSVIraWFl?=
 =?utf-8?B?a1VIOTZabDF6Q1Rad0JqeW9oUm1iNStGMWJlS1NJRHVkbkt5eTJxVjlYczlu?=
 =?utf-8?B?L3ZaOExRdUpuck01ODYwVTZndHFZZTB4dlZ1N0VjREdnNXZFdmZSNy9VQkdK?=
 =?utf-8?B?enJHWXZBa0Zzc3hHb2cyVkc2S0pHQndacysxbS9kQ3Y0ZmRqRS9LYVBkVnZI?=
 =?utf-8?B?aE80TzZQWndkZHhiQ2NQNE55M2xHMCtGd1ZTK3RHSVM5Sy81dFBtOThsbS8v?=
 =?utf-8?B?WW9NUm4wZDl2NzJJbnVWNks5czh4eUZGa0lKYnhkZWRJL2Z4ZlFlcjFhb2V1?=
 =?utf-8?B?WnZDU1VycmpTK0NJUzJRdkczU2IyK1p0QlJPbXF4K1NXcEM0OHoyRGxNdXlY?=
 =?utf-8?B?SENpWHVIYkc5NXpWckRDOEQxTkxTZjg1THdtelUzR210UVUzM2VuSFRYKzg3?=
 =?utf-8?B?NngvRmJIMjFZU1ZxeUpuV1JYaGtGVmVQRjU4ejN4a2RmTU9sZ3lsTzR0VTBB?=
 =?utf-8?B?MXJZOXlBdWZoNjlYQU9ZZlVmaGs4YmNUc1JqT2VZeVM4WDEraU5wQi9IUEhz?=
 =?utf-8?B?ZjRzSGxlb0h2cHRHQ1lPVHpmYjY1QWRjWGVFRkdVUWZpdTNCS2hpL214L21V?=
 =?utf-8?B?THlISi9HWDlaQTNaYjRKYmdIckpmL2VGTnVUeng5cm5RWjhPTncrNTdQQ25K?=
 =?utf-8?B?VFN3M1E0V0xZQ2VjdDExUERwdkpZdHV0VHNOWUdzcWNFb3h5dVdOWEcwZGdx?=
 =?utf-8?B?NXdBbTlDWjMzc21hdzVNb1NuM3JWSVVWRTVpMzVnN1k5Rk5DZDFET0xUVUtm?=
 =?utf-8?B?UmtCdE9wZmRYRUl2YXVMN01mSVdyYk5xRm9MbjQ0RE93RDZTODhUaThhT0RX?=
 =?utf-8?B?RVBUR09WY2hVanFNbVljWVRUZ055cVdhbmVNTGFVVTJSSm05L2liVi9XRmlq?=
 =?utf-8?B?aXdkTXJ0aTlWYXFMREhBOGhoL1o4REpmS2dseTFVZFNKajRNRXR6UkIyT05P?=
 =?utf-8?B?Z1VCaWVVOXQvNjdIWWxzL1ZKN2JLRlpHSjBqc3BjSU9TdlcydmRDaG9Cdmgv?=
 =?utf-8?B?dStVaGxkVEllNFhFVFlzbzFuSytSRTFxUmVaQUFXS3NlQjhvRGlhZFdaL2h2?=
 =?utf-8?B?VG1saVdYdDU0ZHYrNkJyNDFEdTN2WGtaYUdDbTNobmpJakwvamVpVGdCRnll?=
 =?utf-8?B?VDJUVGZrdXdXZFBCbmplemp2dnFnWXJGemo2dEQ3MTdMaHBwVzF6bmtvZkV6?=
 =?utf-8?B?c3JUd24rZ2JvQUs1N1A0UThNTWdlSXd3RlcrR1cwMi82NER0dGQ2a215TkRJ?=
 =?utf-8?B?Zk9SOFJvMHpmVndrY29nK1RhRlJPcWpMck9aOVZ5WENGbElGVHo3RFVUVnZu?=
 =?utf-8?B?WUttMWk5UDZBNWxEUm9tbmZVWVEwN25HeWkzTzlCZlRqMEtUQUdjeDgzZEdS?=
 =?utf-8?B?aFhBekhld0hudzMrQkV6QnQ2QjZYQmpFb1lIdWE1a3NBRUZENXlZd0NyMmJV?=
 =?utf-8?B?NC94eHBhQ3RRYVAyWSs3bTlOU1pTc0pXTVZjdHFIK2dDZC9yN3RoL1VsdWJ3?=
 =?utf-8?B?TUZodG5zQmFmeW9FYm16QXZhYy8vdUo1U0JTbWcvSHBudVAvMW9CY1BHVUQw?=
 =?utf-8?B?SmU0OEZFR2FoT2xxUXB5cUYrcitRVjNpYTZYZjF2U2g0NTZIWHdObnd2YVM2?=
 =?utf-8?B?VVBhMDI0RjkrL2JoNzhEeWYrODB5RXBIcVBxR2R3TW90WW8zK2xScU5ETmlM?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf810508-551c-46ca-42cb-08dda3183f60
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:31:09.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyrEUnhqaQTtpq2Hm27ZHwTXVvVKAs89XfDehXdQMAiWmKHs/G1wfAQtrAnfG0p/tp3CH0T6+Yd0JWV2KLFR8Iux9LWWrDi9qhfHjhBMVNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> The rdt_domain_hdr structure is used in both control and monitor
> domain structures to provide common methods for operations such as
> adding a CPU to a domain, removing a CPU from a domain, accessing
> the mask of all CPUs in a domain.
> 
> The "type" field provides a simple check whether a domain is a
> control or monitor domain so that programming errors operating
> on domains will be quickly caught.
> 
> To prepare for additional domain types that depend on the rdt_resource
> to which they are connected add the resource id into the header
> and check that in addition to the type.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  9 +++++++++
>  arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
>  fs/resctrl/ctrlmondata.c           |  2 +-
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 40f2d0d48d02..d6b09952ef92 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -131,15 +131,24 @@ enum resctrl_domain_type {
>   * @list:		all instances of this resource
>   * @id:			unique id for this instance
>   * @type:		type of this instance
> + * @rid:		index of resource for this domain
>   * @cpu_mask:		which CPUs share this resource
>   */
>  struct rdt_domain_hdr {
>  	struct list_head		list;
>  	int				id;
>  	enum resctrl_domain_type	type;
> +	enum resctrl_res_level		rid;
>  	struct cpumask			cpu_mask;
>  };
>  
> +static inline bool domain_header_is_valid(struct rdt_domain_hdr *hdr,
> +					  enum resctrl_domain_type type,
> +					  enum resctrl_res_level rid)
> +{
> +	return !WARN_ON_ONCE(hdr->type != type || hdr->rid != rid);
> +}
> +
>  /**
>   * struct rdt_ctrl_domain - group of CPUs sharing a resctrl control resource
>   * @hdr:		common header for different domain types
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 4403a820db12..4983f6f81218 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -456,7 +456,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>  
>  	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
>  	if (hdr) {
> -		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
> +		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>  			return;
>  		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
>  

This is quite subtle and not obvious until a few patches later that the
domain_header_is_valid() is done in preparation for using the
rdt_domain_hdr::rid to verify that the correct containing structure is
obtained in a subsequent container_of() call.

Patch #10 mentions it explicitly: "Add sanity checks where
container_of() is used to find the surrounding domain structure that
hdr has the expected type."
           
The change above, when combined with later changes, results in
code like:

	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
		/* handle failure */

	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
	...

Considering this all I do not think using a variable r->rid is appropriate
here. Specifically, if the code has it hardcoded that, for example,
the containing structure is "struct rdt_l3_mon_domain" then should the
test not similarly be hardcoded to ensure that rid is RDT_RESOURCE_L3?

Reinette
