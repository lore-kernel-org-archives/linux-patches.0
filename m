Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543BA2222B4
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758232159; cv=fail; b=RONVDaulLLRfPp8NvPXEGDBm8EQU8Q7GFZZOTwhyXpfZItNe/5gEjQ/S4r2K1oF8f2mifH7XGO0XKKwVQ2oVnOIBQz0sZ9vNVabVpiBtYHHVezDiCZU5jPoYycompmZW8lXjeLfAtxCwOeKHaBZiezqSIRRRK69hmvjs8O3qTr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758232159; c=relaxed/simple;
	bh=vzu2h0pykaND6fckL4JcQjowRpR+ZWfh0UkaaNAuadA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R8fs9MWnOSEv1rlhq5hbePO8SB/s67izgksPn2hxSxYei/TvQkkq7FCMz1DvDKxr8Ed2c8Cj0bw86Lg5J3a6NUvNIrB8ywlpnMrjeVQ8a+vkLXdWVYgwd9pdcpveDSWbtSBl6utV3xTaQEGIJzebIxSHvVhv+OFKMl/+2/agh0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BGW2oIc/; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BGW2oIc/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758232157; x=1789768157;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vzu2h0pykaND6fckL4JcQjowRpR+ZWfh0UkaaNAuadA=;
  b=BGW2oIc/g67RhFzUglZOiGAzAoTOY9GF1J1wqmoz1vMa4aFX44CxWy7C
   qLI848V6XGcN3VWmbc3Te8hFnIvDgSuxz+aU8PJ2GVSMog6L3fBg1fK10
   VJHzxauxfndcKd6wFFXYvKE81XvfaRyjsfpQAtnJLhPndBTaVC+ZnOXuw
   UxsT1gwniRPi3lfri620LOiWHonyC51i/SJsjZZgK5u9lIdwrAeB+8ic+
   PoFgYPtLVGgS4Gexd4vzWd9QaXdbn3FIhMth4cevb15vpfNNLWTZpM3Ht
   PGAO0IyCkUV2CLlausdo4DWJgtNrlQmPHYiB2jfe+CrdfTGe6G7Q42wf8
   Q==;
X-CSE-ConnectionGUID: qRkCkZ+XTAql7ZYyMigOLw==
X-CSE-MsgGUID: Te2siJYzSUq9yM/JktGBQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="71687953"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="71687953"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:49:17 -0700
X-CSE-ConnectionGUID: RB4FhrmpRcSRDj/tX1mWkA==
X-CSE-MsgGUID: KIjqBfSBTxaDels1DdVX3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="206599723"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:49:16 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:49:14 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 14:49:14 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.71) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d5/LuBV76hIcDllEkqDat9B2A/RR7oi0onMrNB+OCsrkNSNAKdLzwDuGas/NGFay2h5BzsXQfbvrsJxVabAE6Sx3DVNjzi4qAoOIp3+brOK1YgDiYXnlvd9IhnV+jMMjQp6oPoyriV41OVJa1W4zT9FrCWf5dTp82u4NUmnqawzCiXvPQx2UgBs+1UcBOCQO2vDADPSsd7uPHKcwn/Bi+xsmvk2qv16vdlRl1v9WKPrMV6P5wnW64id2bkvtWhnH9mS8piqIHElHetNdWUqvWdfCdMy7lo6j9t/xTzHQWWIWh1Mia8ogqS5Ir6L0HYOOBtzSK5mDiuFaWPtLEPVkmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JL0PmJOznil6q4ON+FhLQjYtWdN0Ug8qaahens9Twc=;
 b=am00iwulSfoPO52GJpsKI6Gwl2UzYR5KvC8Yjoim1kveQtIW9g/j8qzgvVxPr/JoFheW7bl+duUK2dpBd6ysn+SJbjGS9iilHltx/+S8QvHzYYrSbE2jO0IcKHhQ43sI5bCPiElw5yNlIK2ZwbGBDWLLDZnoEN+sVlIL1L6sMpBKzTeat9MvMbtGrYd4uNWqvxQ0hTfqz0GB5tEDYVb/+hIzANLvXSAJ36Cn/ZwjTceNB5868GXH76C3tohUJL+ec4yiGCOZ71LJBxJXopiPu47E8KnIhQQ/KY3mDXa+j5bJRpumOdZnHPvtbAyFholQCSjG6k/KUeahLhsxpAYW6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4799.namprd11.prod.outlook.com (2603:10b6:a03:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 21:49:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 21:49:08 +0000
Message-ID: <67f34897-d5b2-4ea4-9e4b-edea86b7636c@intel.com>
Date: Thu, 18 Sep 2025 14:49:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/28] x86/resctrl: Move L3 initialization into new
 helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250912221053.11349-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:180::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4799:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e9537b9-5221-407d-248b-08ddf6fd31bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aElIQjJCNjRSSHhhNHNUZzFaTUdkTVlCVDA0ajd0MXA3YlkrRWJTeTM4bmI3?=
 =?utf-8?B?c05uM1lkY0RkV2VFSUJlNTVncGpuRHRlS0RNVFdnVjZhOGZ0QTFVb2xqTXly?=
 =?utf-8?B?Q1RxazBwUmFQTGNUL0gydXozWkVBRi8vMUhZVnNFS1ZEdnc0RkRKVG84NURl?=
 =?utf-8?B?Sk9MVUJTNnlNeWM0NUsxb3J1VFlOUHdDOE04ZEM0NDRDMEVkdE1VdkFKaXdV?=
 =?utf-8?B?NEJjeFR2NEpXWFZNN1dpQXpxRlE0S1NNVWV6SUdnZ1FONXp1cERBMmhnM3lq?=
 =?utf-8?B?dkFHK252RjdYWi9CSGpwaUpLdkhSZWZZQVRjZHltdmVpQUJGdmowRTA0UGlM?=
 =?utf-8?B?UFdVcEc3Uk8zd2xjZXE4MXlwZWY3bTVJSUNrdW5GMUxVdlIxaG91cUEzMU16?=
 =?utf-8?B?OWRPK0tWei9RbjMwdFR0alVuYTBsQXhxa0x1TDR6NVRPRGxudG5FbVM5cXk4?=
 =?utf-8?B?NjlWOHVvaVNqT3RZWlJoQkFNZlBDVW1pbmZvNnhJOFRzNlNHeVlCZUxudFVZ?=
 =?utf-8?B?NlhXbjBPcjhKWm5JUlpvL0Z6NEdSbDRkbFB3RWExTmFKU1dFVkdHbHBkRDhr?=
 =?utf-8?B?YStuZHhzcmFDaEFFQnRGNENKSWdEMG1KNDdPdSt2QzJ1ZzIvd1VDMmVneGZ4?=
 =?utf-8?B?YlJtdkN3YXFXVkZuWHZ4Q3pEb0hHNVNmZnlMRlg1a1ZPbEZ4VHkwOXhkNDd4?=
 =?utf-8?B?Y0QxQ01ydHg2UzZVa2toZU9sQ3VqdmdwS1lObGNWdFNRRm8vL1ppcHMwWEE3?=
 =?utf-8?B?enU1eFNSWEpqYllVeEttekZBZkRvQmIvb0daTVVKMGlNVFBYVFh6Y2FVWVAz?=
 =?utf-8?B?ZDVSSDVJQlNWTzlFUXlydFg2VVNSN3huOVNRT0RFQlBYNmhwK0xuQ1BGSzlr?=
 =?utf-8?B?NDE1UzhsRGdrcTJ5Q1RNUjBOK1lRYnFwVlAyUDY0VDNIL3NBSXRVYlZKbWpJ?=
 =?utf-8?B?MGR1Nk1sSVZsYzNidlpWdUlsdXFJZWhZbWhmRTNCMko3YU1VdEx6OVVRaWgv?=
 =?utf-8?B?dkJaTEVMeVNKNVNGUWRURGRuaWd1bWhicmYrOExzVlJqME0yNHB6amRab0dQ?=
 =?utf-8?B?SjU1U1hnYUhRbjRmc2ptRHhIMWQ0bkFrMDhsM0Vrelc1QXZ6bmtpckpCRUZB?=
 =?utf-8?B?SzNqVlpUb2VHZFh2Q0d0VFNYeDJWVStSMms4WmlidVFWdEhoOVRvUHlxVDVs?=
 =?utf-8?B?YktZVUdEZGlKSzBqd3lEYnZZclJLYWdZa25hK3g2NUo4THNRaDhQZ1dkU3dp?=
 =?utf-8?B?OFBCZklGQWFsOW42cjZRNEM4dlJNWXVVc2d3aHlkT3lqWVBmKzZSSFJpUVNP?=
 =?utf-8?B?WWNMN0RjcjZ4Q0JMVm4vWUovQmVJUmJBVFdNcFplczZjZHNKVG5xVkpiNGJX?=
 =?utf-8?B?aFlNREdzaVN5YXhDeUVWTGdNb2phL1dHSlV2ZW5FZ2ZmVWlhT1dPUWx5bm5t?=
 =?utf-8?B?NERtOUdWR3JucHhFMHdldWdBbndaV0Y2UjlXOVdHUjl2OG1aTjJ2c0NwUWRC?=
 =?utf-8?B?VUN3K2J4ajZzZStDRnN2VDFzYUg0Z3dmYVgzL3ZYWlFQOGp6TFpldlozTTFw?=
 =?utf-8?B?VmhVeFljTFNYWFFKbzNEcFFzbUtPYWJrSnZrMEsyYXB5Q3Y5RWpscDIwWHJu?=
 =?utf-8?B?UU1PVnBIVDJ0UUs0RjVNOHNkSkppREd6US9oMWFoYVg4VGRaZlpEZXRyN2Jz?=
 =?utf-8?B?eUpHekNzOWRLTEJWR1QrdCtGa1Yyby9mZGZKRnl0ZlNEb2NtcFdOc0ZXNEww?=
 =?utf-8?B?bkY5QThCbUZrM3QwcHZpbUZFR21iMDVmUUczNHJON2hLeE9OSXIvaXh1VktP?=
 =?utf-8?B?M0RqQkJSNTJvYTJpam1OQW45ZDRDOTdVZzVlNDlDd1VOc1ZKNDNTTi8zOGIr?=
 =?utf-8?B?K0doS2lPTW4ySXZmL3FoTUc4blF0SUUyOTdrNGhPOUZqMFd0dHJVQzJZMG1x?=
 =?utf-8?Q?ht1fGudcdGg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDRFMmJmSURZbFR4ekk5bnduK2RLM05Fa2dFZkZVRXA3TFBCT3gweUJzM0xr?=
 =?utf-8?B?NUtaVE5LY2ZFTnA3Z3Jsb21PeDgyeGtDY2pIOEE3ZEhKbjAvcnVuckw3K3FN?=
 =?utf-8?B?U1RBcndHVkNYT2xtN3M4MkEyeWVtVUpEbnFNRW9vUFB4cFQxMGlMRzdRWk5q?=
 =?utf-8?B?VXJkRGlkeStxNDA0R1dqTzVka3lUSlprQi8wODczSUo2WFZIQWVQV1dFbkNB?=
 =?utf-8?B?d2JhRDI3b1U1amxPZFZtTk9VNXc5V3QrYjJORUd0QmtjSzlvemMwcVJZaHV1?=
 =?utf-8?B?cnM1RDVYb0QvRFZ3aUNxTUt3V3FncWlMZzA3emJwZzNrN2dwVHFZWTdJMTRO?=
 =?utf-8?B?Wjd5UEh5cXBFdlFCUmh3UmVPaEQ5UlRhSnBneGprVUFFTGJvZWM5eDlTMFFG?=
 =?utf-8?B?TGs2MVF2S1l0OFNFdXkrZVNRSWpOa0tkbTFyZ29nSXBlOC9VUVAwalZPWVNQ?=
 =?utf-8?B?UDB4U2UvSlBBZHZLTm5PTURNVGpWTFFkTkczV09iQ3ZMT09nWkoyWVBXRjh4?=
 =?utf-8?B?amZUWlg3cjNTSmdxOEJDRVpSU1hsL3VKUkgwSmtNRy93U29rNTFpcE1aaHhQ?=
 =?utf-8?B?Vld0bDFhaVBWY1JoUzVWcitsdHI1TkNiL3h3OGYzelNvYTJzWjZlVEFIczMw?=
 =?utf-8?B?R3RwZ2p5M0FRaHFDSFZVb3NnUTVlVjU0ZW9Qc2hHNit6OXVrSG5QdU5HUS8z?=
 =?utf-8?B?OEh5WWszZERuSlRuQTlzbCs0M0RCYnBUeGR6TDhRVXRkSFRkNGMwa09nWElF?=
 =?utf-8?B?aHNJQkE2dXhjZ3I4cFpxSjRYMkQvWjIrbis3bGl5Z29abnUyb1RLWjNvMFhJ?=
 =?utf-8?B?MHdBVUltdWtvL01hSFMyTENwRk02S2tJaFpGQ1doci9Vb01QbHYyMGc5ZEhU?=
 =?utf-8?B?ZDk1cTZnekxnVlRNeExwK095R3RoU2ZsZ2RyUVdBVTZMOE85a3FhYmlMVDk3?=
 =?utf-8?B?NkdIK2tCRnBkS2VHcU1zSkFENHhHSTY0eElnZUp5THcxMWlRZG1NZWFiWDhj?=
 =?utf-8?B?VlNPVkgyd3FHZVNMR2VYTEY3N1dpNXpkNnNQMXlqa2VJSHFPQmdHY21xT0xG?=
 =?utf-8?B?eUNBUVgxV0dKeXBaMXpjSXdwd0VTQUZRZ1gyWnN5NHhyM2ZJMkJxT1lQMzJD?=
 =?utf-8?B?QXp3WVZEdEx3MUJONGhRNXZvM0o4WUVOS2h1NkUxUTZXL3M3cUpDOXJyb2lP?=
 =?utf-8?B?RkMwMkZqbllNd3FqMzFCWG1saXNPRXA4SFNIRkVRVVBmRnVHNmRiNVJYdDZN?=
 =?utf-8?B?Q1hTTE00bHQwVWQyMi95VnJNZHVpdHVtOXFTZlB0eiswTVlGbEJyYzFiNjVx?=
 =?utf-8?B?b0xIVndVUkM5Qk90ZE1HUlNYT3JXVktES0N5c25aZkVSUTZlUzhob0ZUZnhU?=
 =?utf-8?B?WmxwYmVkbUN6OEt0aVoyMEM5K3pMNnNwSmY0MjRNdTFrdjgvbmxOK2NIT09n?=
 =?utf-8?B?TWVhR1dSMThVaEN6eENoRFdRT0xvWXBGSktYSFlRUUZiTTFKbFREVlB4NnpX?=
 =?utf-8?B?Qng0Y3plelYxTG5weGNacnE5cHNuazBjZHJQMTg3ZkNLUTdCeGszMldCZUI1?=
 =?utf-8?B?S2daQndXVVRUdjBSb0dxZnlSM2I4V2FsRk5SQ1loblVoKzd1bDBzdXZiOWJY?=
 =?utf-8?B?TmhDSVErcGNxZ1JkWUxsNS9QRG5XaWRSUEtXMllTWHcybEUwQlZKRVNrWjBo?=
 =?utf-8?B?YVBVUUlUbC9iUGl6R2FGaTRUU1RCZXBVQzNsRHFQK2RkcGZMUit1d1U4aWgx?=
 =?utf-8?B?T2dhQ1d2UWdzb2xWUmJLZU1HOWdKVDl5UmtYK3ArZzYwVzZXRExkTDlRMGVk?=
 =?utf-8?B?V3pFelpYMVREcnhQS25LOTNEY3FHOEE0aW5pYkw4U29Xd1FlN2RNd3ZLVVVs?=
 =?utf-8?B?bW5Pc2NyNnliZTBub2VIOHd0OHgyZWRVQUFBd1NMeTU1NVNsOUJ6TjAwOTlF?=
 =?utf-8?B?TjFXeHdhcnV0UVdIQUhuTWoyZnR3R09NRVBLMG9MT2RHYXBmVm41a3pOZ3Vw?=
 =?utf-8?B?empuaEVaTFJwWC9qdkU3dWIzK0R2VUJnS0VJZG1HaTE1c2F0Vy9IaVJHdkRx?=
 =?utf-8?B?aUFOSkNkNmNCV0hHd1dJTmE2ZkN6RlF6WGJNYnpVOHZ6OTV1VzBUeXVDTkJp?=
 =?utf-8?B?a1NrWmN0L0c1c2VteFFqRWJSZmYyN1FOSHJpallpQnh0QjJEVlQxTnZUcG9n?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9537b9-5221-407d-248b-08ddf6fd31bd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 21:49:07.9347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7458fmDib/YyKMED1qy1abYvwFQAtr8AbzTgvPWQHEpLMl2GUNJuN4DZWtZEQflI1swxQRh5PvsebXB1ooy8juG4YRSqNQrDgRDZi6wLrTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4799
X-OriginatorOrg: intel.com

Hi Tony,

On 9/12/25 3:10 PM, Tony Luck wrote:
> All resctrl monitor events are associated with the L3 resource, but
> this is about to change.

Please see Boris's feedback about changelogs in [1]. To address that,
please rework the changelogs to not have so much copy&pasted context 
in patches. 

> 
> To prepare for additional types of monitoring domains, move open coded L3
> resource monitoring domain initialization from domain_add_cpu_mon() into
> a new helper l3_mon_domain_setup() called by domain_add_cpu_mon().
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 57 +++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 8be2619db2e7..055df4d406d0 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -496,37 +496,13 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	}
>  }
>  
> -static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>  {
> -	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> -	struct list_head *add_pos = NULL;
>  	struct rdt_hw_mon_domain *hw_dom;
> -	struct rdt_domain_hdr *hdr;
>  	struct rdt_mon_domain *d;
>  	struct cacheinfo *ci;
>  	int err;
>  
> -	lockdep_assert_held(&domain_list_lock);
> -
> -	if (id < 0) {
> -		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> -			     cpu, r->mon_scope, r->name);
> -		return;
> -	}
> -
> -	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> -	if (hdr) {
> -		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> -			return;
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> -		/* Update the mbm_assign_mode state for the CPU if supported */
> -		if (r->mon.mbm_cntr_assignable)
> -			resctrl_arch_mbm_cntr_assign_set_one(r);

Rebase error? Note the assignable counter initialization done on CPU online ...

> -		return;
> -	}
> -
>  	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
>  	if (!hw_dom)
>  		return;
> @@ -565,6 +541,37 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	}
>  }
>  
> +static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +{
> +	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> +	struct list_head *add_pos = NULL;
> +	struct rdt_domain_hdr *hdr;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	if (id < 0) {
> +		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> +			     cpu, r->mon_scope, r->name);
> +		return;
> +	}
> +
> +	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> +	if (hdr) {
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
> +

... assignable counter initialization no longer done on CPU online.

Looking closer the l3_mon_domain_setup() also now contains assignable counter
initialization that is gated by a RDT_RESOURCE_L3 check. Considering the flow
I think it may thus be simpler and consistent to not return here
but instead have the additional initialization done in resource specific
areas below. 

> +		return;
> +	}
> +
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L3:

Something like:
		if (hdr) {
			/* do resource specific CPU initialization here */
			return;
		}

> +		l3_mon_domain_setup(cpu, id, r, add_pos);
> +		break;
> +	default:
> +		pr_warn_once("Unknown resource rid=%d\n", r->rid);
> +		break;
> +	}
> +}
> +
>  static void domain_add_cpu(int cpu, struct rdt_resource *r)
>  {
>  	if (r->alloc_capable)

Reinette
