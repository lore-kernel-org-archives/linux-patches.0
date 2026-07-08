Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A2035A395
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551052; cv=fail; b=JKiTxhezni0XA38QNXVKfH3Q8uCYGM9hTVw+SdHCnpKiN9wAgG8gBq7O43Ey9gMxVdVoMyKcV3U8UVHlX0kW1iCKLZM6eNx6PGfyw+FcBSQi/LFXxyCbjvTyw1VP7ehSTbrCxZI+GIfMzZ38m3dTTjZhW+au1PdXI6MOR7Xo+Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551052; c=relaxed/simple;
	bh=R5DXGfJoTXm0YkNhqDwjRM/Lv32StqQ0Okj5Aobl8G4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GqWODJc464iD47zJG1juUGFjPBjmdZl1TC7yeSFyc+sv0ZVeWzDCo+Z4lVKTgeTpCSckl2ASErf0ZFvbcLL7YohnlOfuSoYG/GM6qu0w0OlpIiNkjdzpry1D8AXKv8tzGmqf4KbXvEYHDbGgyx/HW7SVtYp+7YW7mHmFUMwpDp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5lWOunQ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5lWOunQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783551051; x=1815087051;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R5DXGfJoTXm0YkNhqDwjRM/Lv32StqQ0Okj5Aobl8G4=;
  b=Q5lWOunQw+QkRD4fdxP7/ttBMCg0+8YSl68c7cDSuFKEwqnf7mO+9swK
   HOcCKMBUPX3jiPCNzCqMf/UDW6qfLIv7HJarjUoCr+q4V+pxuOmmKDhoP
   iPFwlwLSkqWOg/9kz0RLg/N2e0SGJeWPpYXDJYiNyq1UP8w/M+og1wO2h
   Ei9QgtIFe4y006nLRt6srdZ+nY7VCkAMnL4G8BIgbPJ5ReilX66iDgAwH
   n8WBWxnN5Cuu38+KHDRssozhC2u6gq3ut8EHMS69cm2Ti98n+3qobRgdr
   tETjL1FfbiJrs4xd3rRcw+GKAOy6nRF4Xf/d5yG2G/jrVN1AuFmCENUwi
   Q==;
X-CSE-ConnectionGUID: ZfmUb/z7QFG2L02kmvhy2w==
X-CSE-MsgGUID: jom586RgSMSCbT363kSTPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84342651"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="84342651"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:50:50 -0700
X-CSE-ConnectionGUID: CA3/S98tTbWfhciyazV49w==
X-CSE-MsgGUID: BMm/JuxFTd6LJtnhjo+pIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="292607652"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:50:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:50:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:50:49 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.27)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:50:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wX+wbrp/lVzYmmPtPo0IstfTNE6T6XDixIxrAdEZhbcLi0Dg936MTKWVy11Xn1no0GdVekp4HbRtyGdLHrr0mzvtlZg9IJUvwAI0xX+xZMrmZ2/6I8FjCbq4szgNJlMz0ZG0MUnxBze/fiPJ49ET2gousOJQFJHOgLVuIRMxc5g3RW3XEh58S7qSVXmnsX0A3MaLldUC/BzTJKGcmzb4PCSGijj1cbnbY6UNI9J/pYRJCxReeLJvmlTAB/iF2DHqe493Z4asEeM4A6lU8vGKD4oa5hvMYiPV8JxrvG6WyTv3TDCNP7cuZAUtg4Wkiy+mCS+/KbcFmZ3ntQl48Az2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXuz1wKX/VioYtbBtCcwraMVdjV2/cdcwHv8lYnVB3c=;
 b=cID5FgktdOVO/5l20o8r6A/JO/6dUD3Y0YWUUH0nwXUFGQ/01vyMm9K0LD1fYIzc7Dd9g0HYCDhb0fYuwBu+8PstoWw5CM1E06HPFUH2t3RgiQvp8aEHqX8LX6qBqVBFl7sgDSFSUjWzn3xGOe144e5Pxfbx10v8dR86+z1Yi7L7iOm9EaP8UjLXohALBKyhwK3cB6NjLgy24B3m1y11uRx00pxqfZmvqPnstVEgxVxZqAFJ+BiANaptMsEunoE+p5DhCKWlFped/YaLxJBooI0ECkZ32NvIITHAunZ7HlR3PRgJdX50T2xXmggOY3bwx2NniplJm9prUhDNvi9dUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV0PR11MB9864.namprd11.prod.outlook.com (2603:10b6:408:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 22:50:47 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:50:47 +0000
Message-ID: <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
Date: Wed, 8 Jul 2026 15:50:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260701213553.15222-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:303:8e::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV0PR11MB9864:EE_
X-MS-Office365-Filtering-Correlation-Id: fbaac9ed-b19e-4d20-3f1d-08dedd4359e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|921020|22082099003|18002099003|5023799004|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: nTxM7gQNbZCx1VoawjMfj1VFxEwfTTkrQ4IUDixazct+dB4G+v/sj0TxgU3KbtM+cGSfcbgXLDzUpSgi6w3z/c2+YZTx3tR856LW6HAIsXdKBdOcczOzrpJVEAriJ/s6AnklC5En6LYCcUtPRIJpxJp1WVZk/UWL1MR/k6PhN1a15acRDP+aS1C0Of+UqyCjl1eiA+pbLbqLERKKc0gBCyV5vUtLZmQ+z7eJp9+XSGf2pI1fvfg+50UynfM+sFoyqn+x2d0eUDeiht7TAQgiAWRdDPmB2zYdnXdNP1sLCPDVFjFu/DqR1uoiBXTQj3mTs8x/4cNk1KCNUFRXDvs+7/fFPF0Ft0VHTfjWivf0r8BvpnGekgnhxF2tNF7bY0Be+BhHH11XPgSgjixBP+wkWeE+5gjSngModNIFvgr1mCYjJUZwvjtPaQBmMChD8+BWNgBtRaSxdi4s1TMpMYiNCT+nkRE/eZecntjIGyPgwwFKqj3aboMM6WY7VEJe8gu1INDGgx/m4FP+dfTFFb28LPpeejmPVN0Z1Qz2DPEi6Ya51YAFGTxG8xS3E5NWnUTQy9E1VncPbNAcxFk+ycmtpobZ2uoHtzT79vLcbyMi3TBHYRU+8CRgCSqD+mHVlUpX2c7/vKpgVo7Fko9pRTxMAtk4Eb+Wm4xJWbTL28tKHGKsrOmLvq7TaGaX+f1OOhaQKMDwy8DyQzx5Xh6yIFXteQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(921020)(22082099003)(18002099003)(5023799004)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzZwWk52N1dEdFhxdkVhQmY5QmxjckZFTjJqaEs5VmEyRStLeDJzVHFPRFJU?=
 =?utf-8?B?cmJFc0FlUHluMFZFaDFKc3NWdUxnRmxNV3BPRGV4VmRNWEVWdTZzcVZoS3hF?=
 =?utf-8?B?MFlpOGRISGVFb2plamM0aEZ4QmNER2JaUlFyZWNoZWEwVkZwWllZZDBYQTFQ?=
 =?utf-8?B?U1B3RldwQjg4KzIyaG9GcmJLUnU3QUxEVlNPbW90K2JLWmwzUFNyQ3o2UGVY?=
 =?utf-8?B?dFB6c05FcVhWd1RLV3lienRjOG9qVkZQQTdaeC9pa3cwVXpiQUpiMG9yRk9w?=
 =?utf-8?B?a2JwZUlOQTJRbG5hamJJbitwcWJUV1FaZG9VWHRRdDhFdEkxbVUxNFExZTVi?=
 =?utf-8?B?UjRwaXdnSWFaL3I3UzJobXJheUxvUFNPNlpZRjE5VmRsTnp5MzZHN1pQZ2ZG?=
 =?utf-8?B?Tkw5cXpHZlFLcno1ckVOMWtlZXJnSUJTZ1VtQTBJeW41YWxRR1h3aStFc1o0?=
 =?utf-8?B?cklkNlFOSWVHK09Gem04Z1BkR0hPc2pVMVBDTCs4Q29DT0N5dUlnd09xNkU4?=
 =?utf-8?B?TEFBNlVTcC9qZGtUU0VycFJoblcyWEF3MkJSSDZFdnlLdlJWcmgxZGRvSjUz?=
 =?utf-8?B?bEg1NENNRXRVODJKekhVbjNHaG5FKzNPK2NuQ3VBQ0lSUmY1bHpFYUptVUJO?=
 =?utf-8?B?d0czWi9mQmRiN242UmF3RlkwT2VCNkdPbHNmUXNVaE1qVUhCV0RqRWpXY1RR?=
 =?utf-8?B?ek5rV09ZZDB2UmZVeHlKQWhmN0N2WmtWU3E5TzI3VVZ4Wmlldmt6Y3dPVFZa?=
 =?utf-8?B?R0pydWJmRnZpTFNka093R3pFZkYwZ2R4cnpXendzZ1U5anlOL3REYkh3TGpJ?=
 =?utf-8?B?aXBvMUUvQkttWTVWS09KY3VoSHVDVSt5RzJDZlZ5a1l1dGVKRUo4YXJyUURT?=
 =?utf-8?B?RnVibFFWejdQRjNVa3U4QlhzQlZuWEk4dXhSdVMxSzVRK2VSc0xoM1AxZjU1?=
 =?utf-8?B?TEVJY3NEZ0l1M0l0bkVmZnFLREJiajAxUHd5a3NTNUQ0R0hMdGs2MG9nc1Vs?=
 =?utf-8?B?ekdRRmt3ck5hWWpBdTlGTkhhdCtXeS8wK1RaRm1PVm5jYXNTYS9vT2oyT2sx?=
 =?utf-8?B?eXFIL2pLMzBTTzNtS2VUZmxKMFVLTHlxVW5JNk1wYUgwNytvT3VZYTIvYzNS?=
 =?utf-8?B?aC9kZ0pVM0NRTmt0YUU3dCtUUWxzQnJoc1JUTGxsZXFybXg3bi82TkxsQjhZ?=
 =?utf-8?B?SVZSblRZdXliQXVRN1dTMXRPbFNpKzZMYWVJTGJYZzVyYnhQWkdNZm1QVDhS?=
 =?utf-8?B?WnV3WGRpNzkzVklVUmZvQXZwMytaeFNDbjBtNUI5SXZtM282Nk9KY1B4T0Z6?=
 =?utf-8?B?T3RVMENXU3N3dStVQy85TVdXMHpFT0pJaTNqOTdRcTBSaFJJSU85NjZrUktC?=
 =?utf-8?B?ZjUrYlpPQjZ2dWFFZmlsK0x4NHVhOTVrYW5MUlRsUnYxRHFHa3FsV0IzR1hn?=
 =?utf-8?B?bmpMdDloMTRybVlXQys1REZ2d0R3bEt6TEFrTEVJcm1XS2UwSDRjTHYxdEho?=
 =?utf-8?B?akV5cVYzdkI3SzBmcVJENVVkUVROSjFOY3pmNTlpdEdlNWw5WGkxSFRHRGZz?=
 =?utf-8?B?MHkreElRa0NibDRHK2t3NDIxdmozalJOY1VjT2xwVnc5S1ZGYTRMU1JhYnov?=
 =?utf-8?B?eVIyWlFmcDNDbE5ocXBCc205czNPK0VsMGM3ekRTSG8zTXNMZDkwVlJXc1lv?=
 =?utf-8?B?WXJkNVE3M1dLTXpkTnhUQThWUFpqRmE2OTdwdHdCUTNyVGRMTlBpeGt2SEdK?=
 =?utf-8?B?M1gvYTBVeWRnMlRyYUNQZWtodEV1MGdmN3BWdVZvMnEvZlkyR2l1SzV2aEFT?=
 =?utf-8?B?T3VNT21lVEFpc2dBeStJaGt3b1FZK0dmWEpaM1NveE9ta1pTRzdDZHdVcnpM?=
 =?utf-8?B?REtLdWcxQlZJSkxvbUVZM2xxdXhMeUV6TnRoTjUxOWlmRzhqT3FlSVlpSzJL?=
 =?utf-8?B?V0kxci9qRlBNclZ1dnI5b1RBUGFYcjJwU3RqU01TQkFrODZlWkdZMVpRbjBF?=
 =?utf-8?B?RmRvdUF6WlVXaTFJVFlsc2QwTVFsVWtYNUFJR3RaN096Nm8vajl6ZjFIdFdU?=
 =?utf-8?B?SGhOQVNsaUQyUHI2TGNLdHBQN2pEWElSZlZ3TVFXMGkveUwvQnI3OTY3YUZL?=
 =?utf-8?B?WUZCQWxXNEw5akUzRkFZVy94N1FrZDFEbTFoRk9PY3lhckhMUVFIemVsVDlN?=
 =?utf-8?B?ZzJaN2NkcFdaaVdzendWYmZJVFJpUGRjbHFzenVXMHl4U3EwMmNRUW56eHp1?=
 =?utf-8?B?U2tWVTdZOGxlQS92eWNpcFowRHNhMEZjZ1liWmpzcmJIZVNjcVNmNHJJRlFZ?=
 =?utf-8?B?L1NqL1JCM2N0Q01keDZEeHBmUzhtSGJGTzZBUVhUWndXdXVtYmNvdVpPUnkx?=
 =?utf-8?Q?O8N0BVrZuSIcD7hU=3D?=
X-Exchange-RoutingPolicyChecked: BpTGka3SDt7JsbBtnJy+tfY//9vY/JW8EKJu7POYwrxfIHBhCrcx37hCdleGgxvNUN7Nt5K0XfmiUSTTZ9l6st3xsKheG0ZOKwEAH33GiZF1p9PsTapXLw84wL9c0z51OPrN5KfkJUMQ4D/GRzQpoP1kguwfNuEpHbGwrTZqHJEDL3OuFJX6UvCtxT72QJu6fCyZzEXX2Et4NdTRG6Xv8lD28CcENS9xMJu2FOREafiL2F4+tJs/r2cNQG756S1zhpH+iG9TTEM+wuKk3Sv1OIPs+BSfPQZJebHJXLVzL0UtEFPrgfTpO9ORyHT7juFXBUfPcoUVQANCIdmmArZLEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fbaac9ed-b19e-4d20-3f1d-08dedd4359e7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:50:47.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VS3tPrcQvjTDiqSszjNIU3lI2Q5iGWSvzefGZT6y1QxdSU0fQZkjz/xhGs/xHFoAFYOEGedHTHAIbh2NQrAMW13MpiB1fpd5D5pGoeGCOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB9864
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> Application Energy Telemetry (AET) event enumeration takes place
> asynchronously. Linux builds the pmt_telemetry module into the kernel to
> kick off enumeration early enough that it completes before first mount of
> the resctrl file system.
> 
> Allowing pmt_telemetry to be a loadable module means that it is possible
> for different numbers of RMIDs to be supported on each mount, depending
> on whether pmt_telemetry module is loaded.
> 
> For simplicity, calculate the maximum possible number of RMIDs and use
> that value to allocate the rmid_ptrs[] array just once. Also use this
> maximum RMID value when allocating rdt_l3_mon_domain::rmid_busy_llc
> bitmap and rdt_l3_mon_domain::mbm_states.

This does not sound right. Why use the maximum RMID for L3 monitoring state?
It can be guaranteed that L3 monitoring state is only accessed when that
monitoring is enabled and when it is enabled it can be guaranteed to never
use more RMID than what L3 itself supports. Why would it ever be required
to allocate more than that? Could this not instead be limited to
rdt_resource::resctrl_mon::num_rmid? From what I can tell such transition
will make it explicit and consistent (since arch code already allocates
this state based on this) how the L3 monitoring state is sized.

> 
> The limbo code must deal with changes in the number of RMIDs from one
> mount to the next because some RMIDs may still be "busy" when the file
> system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
> for the remount. In this case RMIDs that can be released are not put
> onto the rmid_free_lru list.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 60d50ac79e7b..3169441a2d40 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -144,6 +144,20 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return num_rmids == U32_MAX ? 0 : num_rmids;
>  }
>  
> +/**
> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> + *
> + * Return: If L3 monitoring is supported, largest possible comes from L3 based
> + * on CPUID(0xf,0x0).EBX (scaled down on Sub-NUMA Cluster systems). Otherwise
> + * maximum from any other mon_capable resources.

Above reads "Otherwise maximum from any other ..." but the code is actually
"Otherwise minimum from any other ..." which contradicts the "max" intention of
this function?

> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +
> +	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();

This smells like a function that pretends to be generic but created to provide
correct results on specific x86 hardware. 
If this needs to provide max RMID why not cycle through all monitoring resources
and determine the max RMID, why special case L3?

...

> @@ -961,8 +975,8 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  
>  int setup_rmid_lru_list(void)
>  {
> +	u32 max_idx_limit, min_idx_limit;
>  	struct rmid_entry *entry = NULL;
> -	u32 idx_limit;
>  	u32 idx;
>  	int i;
>  
> @@ -970,27 +984,29 @@ int setup_rmid_lru_list(void)
>  		return 0;
>  
>  	/*
> -	 * Called on every mount, but the number of RMIDs cannot change
> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> -	 * until resctrl_exit(). Note that the limbo handler continues to
> -	 * access rmid_ptrs[] after resctrl is unmounted.
> +	 * Allocate the largest number of RMIDs that this system will ever
> +	 * need. These cannot be freed until resctrl_exit() because the limbo
> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
>  	 */
> -	if (rmid_ptrs)
> -		return 0;
> -
> -	idx_limit = resctrl_arch_system_num_rmid_idx();
> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> -	if (!rmid_ptrs)
> -		return -ENOMEM;
> +	if (!rmid_ptrs) {
> +		max_idx_limit = resctrl_arch_system_max_rmid_idx();
> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
> +		if (!rmid_ptrs)
> +			return -ENOMEM;
>  
> -	for (i = 0; i < idx_limit; i++) {
> -		entry = &rmid_ptrs[i];
> -		INIT_LIST_HEAD(&entry->list);
> +		for (i = 0; i < max_idx_limit; i++) {
> +			entry = &rmid_ptrs[i];
> +			INIT_LIST_HEAD(&entry->list);
>  
> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> -		list_add_tail(&entry->list, &rmid_free_lru);
> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> +		}
>  	}
>  
> +	/* Find how many RMIDs are needed for this mount */
> +	min_idx_limit = resctrl_arch_system_num_rmid_idx();

Since mon_capable resources can now come and go from mount to mount there are scenarios where
rmid_ptrs[] may be smaller than min_idx_limit so above needs extra checks to protect against
overrun below.

> +
> +	INIT_LIST_HEAD(&rmid_free_lru);
> +
>  	/*
>  	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
>  	 * are always allocated. These are used for the rdtgroup_default
> @@ -998,8 +1014,14 @@ int setup_rmid_lru_list(void)
>  	 */
>  	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
>  					   RESCTRL_RESERVED_RMID);
> -	entry = __rmid_entry(idx);
> -	list_del(&entry->list);
> +
> +	for (i = 0; i < min_idx_limit; i++) {
> +		entry = &rmid_ptrs[i];
> +		/* Don't add reserved or busy entries to free list */
> +		if (i == idx || entry->busy)
> +			continue;
> +		list_add_tail(&entry->list, &rmid_free_lru);
> +	}
>  
>  	return 0;
>  }

Reinette
