Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2A392C3D
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 21:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774648475; cv=fail; b=TIcxoE3LhZ7kkNLhrE6xeZXDqYpnD3i3cetl65gHPCQZU7URhXV/HX1Z6ERktXeZbH+jatPz3GIJ5LOEaR164zjz8KUYcDmmhRb/mKin0C9m2tE8pFCaWK+HBJK18gzMoTQZXAqNkd8Hj47tqIz50inZLC3SQYUBsWCr5seECgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774648475; c=relaxed/simple;
	bh=K2LqnqhUD4tUrDRmnNcre4Kvw9edwLuxuA9JeEiZZs4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=mCNwENqxc9+nPjpIDQ0TQnNT/M9qef8rWoAqwJ7GnCURa0T7oAyU6XTHdM4LlJmF6XfpPAAeYIoKlCKmsrNk/cywc07vzxqYYRqynfGhWwRyEmrE2DRv7Xr3H3u/puHM+wXRziNHdTDedmslF6HgDQ3QKehx7pmXg/cg2bllyZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gAJbKF79; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gAJbKF79"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774648474; x=1806184474;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=K2LqnqhUD4tUrDRmnNcre4Kvw9edwLuxuA9JeEiZZs4=;
  b=gAJbKF79JsXMUBZA40DFPtJ8wose/O1Jlf6qkT8A+eK4FGxLyIREz3lW
   LuzI7OgqHM/3d6b/LjgpA6qeLIjgsG5DoFF7IntsC4xftbg8eYCjg2NwA
   7H38GpJDNJviMNNxsKioYwSxHoVBk/IgW8+LKbPbdMoXVJy52suwOc/X5
   nWAme4aXsIgS+bvstAH+EyWU/3QldH7tgw1ie71XEO8kfIUL5pWKS0HPF
   yZLpfR+MC1uLiXe6033b3AoWhkkF+fSR9eUMRE/aJD6x+PAECb81DQXcE
   HA6fl/A+Dy/ATC7wFOfwkuid0bkUa5gGaDqaUP7XAbT1IOOmGqEvwmENh
   Q==;
X-CSE-ConnectionGUID: Jm7V6J1gS5ShTH+3RglXlQ==
X-CSE-MsgGUID: AKPqSuE0Th+78LS7mpboiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="63282444"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="63282444"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 14:54:33 -0700
X-CSE-ConnectionGUID: g/GK4mOpRj2lZ6Fwk0wb3g==
X-CSE-MsgGUID: K4qDOtGOSPKfBJn9BUoClQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="248701203"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 14:54:33 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 14:54:32 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 14:54:32 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.35) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 14:54:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fvg9FBMmpkD8ifcFrcKVnj05b2C6fRRCcHwNAu+ll0EuXcIJ02pVP2ikSiUQgjkMgP5zMg7Qyq2mW+4h9G5fzMoCl/lpVqouHd222Yqv9glWv7XcMNdz8lIVJ1WJtlLYvtUg9wLNfyRefBUG/jvT8HdvpkPsE0VzAVkWN5gIzmqxfoQuEIWohaj1Mx0nJmOc/ryRQaEBuFo7Tc+aT+4q90E3A0EBjnz3HwTDF+esBzaF31u5sYSDta5MNVBqrWC+SwWYMGsFhoFHaheSr2f34cpk7+SUtrhJy7ShduY1oHIaW76SepzMdd3RYRazdn0gQ+6CFCbtlISW65G2ZWgLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqbmlSWgRi6FSenQaSOMJgjvEt4MRkzAxbmDzqE8c1A=;
 b=Bu76rYdeRY7d2tkhWAGPSMfMSoCUQFW2KZP/6ujsgwiz9gnUCiH2LOWM9/V8r2saKSfagLP2c+9o8eemdfpN6h5Y2ELEFNqKquyrnsoVhlX8cgt5bMYnT2pua/etj6vMlQnicq9Nse3eXblBH4TIP+u3KAytwuKxkBE8rKTq+cZ8UMpHMEo85KSwBs0rpvOog4nvRyX6nOJjf7LCqA57cBq/xJh4h0iwH7BwNLlnXrMdnk8O/mbFfZqjO+RMSXm1SJL3CQCBPCkLXz1AcH0mekSyCazRXGFDXbQrKxeHaQWdGSghOCCPIAuxWw5YYkN0Es49cnpXgYgJc+BUXOVzPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 21:54:28 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 21:54:28 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 27 Mar 2026 14:54:24 -0700
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>,
	<stable@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Message-ID: <69c6fc90593bd_1b0cc610088@dwillia2-mobl4.notmuch>
In-Reply-To: <acbYgkczKrpG4x6d@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-2-dan.j.williams@intel.com>
 <acbYgkczKrpG4x6d@aschofie-mobl2.lan>
Subject: Re: [PATCH 1/9] cxl/region: Fix use-after-free from auto assembly
 failure
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:303:b9::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b3f2404-6b89-4bb4-d3a8-08de8c4b6b58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Nz8aAttuOm5CPujhvW4Mm8Xdj+zy74a/7gVuzjKFa9qbO3WuoWBfaV64pDi/B8lXqioWgrrbBqoWJ8uasJOkUzFxfp62YNVIKnfAYudJCtUne5fmT3fi7zeeVnR4cBjOr8NKFxusGt/w20YXY/nhpW2YVxbpQgVfoGBP/tgGxjolXYlmtggvWToZK2ZuoQ0wy+AQX2z3rBn+mD7JYSuMGDCdbgCXJyF3KerTHVPEB/yu0GuOBVvYJKTtU+KaLBa8kNhpRjyBO868HQSYPKtE1EHgjVejd2DS+ccRY52ZRxT/UPj3Jkb6mEuf3t9mU1RYWVVOK4WprMZs0lcCzXM+u2362akXvD/ncqJa4Y0hwtXRM2lU6EIRbl8/TZba46ZwMTcuxkreihMIwfkzc++yq1+FKzy1i4wdW2srPSnk9AionMnnp8ppM1qv/91W6UcLcb16WRYfc9ZksKWRChUN9osBNroIdVd7dAV7ldp/EzOBV6SVxV9erUPKgb8Domy0MA/B2JebRTYlW502qACGPJqg5CdQlSAijPxKGR6IOPHG2INaRqayW5jkBMecI7+Vh3mhYvVhQ+k9Dk4ecqJg6wCuhHoE8Dw74mbzOv42xZ2q1BTuwlGLdwhZVfQCSSs069gdkOmHKLSMTq8lXvy7/89OEwr3bX/kJigmXe/+SBhIP+mkZ2tm9g5rLQfL47BDnfrTksKx/waINcjb+Cq7vkRcTqRAZHbvBU6ZvXOmFxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG1Wa1g4S0NpMXRaWmwyMktnSitjakluWkFVMzF6NnFMVm9kRFpvOWpLeHF0?=
 =?utf-8?B?aEttby9HSnQ4T0t4Rm9xQTRBc3MyS2ZyTTM3KzJzZ21kVW5YS2x5Vmpra1I3?=
 =?utf-8?B?N2dOVnF6bUVhYXlnK3kvVkluZzB2RXVMcThBV2R6VTJSV05DbTUwYzF2dGZk?=
 =?utf-8?B?V2JjRTc4RGU1S2gxOUF5RWt1UGZRK1B5endiSkFLZUx2VDdhMDNpZ3Fpdm9w?=
 =?utf-8?B?djRyUEhOeldHR0luR2dTN1gvVDRncklXZW9iWlpvanB3bUw5bFF5aXBSQzh0?=
 =?utf-8?B?VkZXb21pd2MxZ1JJcFJhTFg2Q2E3WHRsL1hzci8wZUdndzdYRVhhSktZUXoy?=
 =?utf-8?B?dG5RajYxb2hKMVBsQ08xZzBiYzU1NGd4M1ZkcXp4MXFaOFN5TmZqVmxnNFRQ?=
 =?utf-8?B?djRGUS9aWlNZQ21yZlM5RXM1T2FyeFpUZjVjOGt1THB5aEFDQ0c2WGkzSEVC?=
 =?utf-8?B?ZWx6M1k2dHhsOUVJT002Yy9ybDU1QzVqNGkySTNKNitFbmkrVkh0cTdlVU9G?=
 =?utf-8?B?SjdCUit5Z1FKN3JLS2Rlczcrdlp4SUdydHlsblFsYzhUbkliOG9FaExCejdE?=
 =?utf-8?B?d2xNbW0vekE2RU1hTGYrZnRYNm9LV1BxcitHTGlnOHcrRzJTUVpBaGhyVUcr?=
 =?utf-8?B?VnprblRXYWUvQTBwNFdWMjdaazRUbldSS3RudXpCbmJkL05wbWova083T3Ex?=
 =?utf-8?B?N0F2b3hodzlpRHFuNFgwak00RHk4MHdubnVUZmVqbUJWSWh3bm5hMDlCS0Zx?=
 =?utf-8?B?K08vSk1DblphMXgveW1MNUlxdW52a09PeHgvU3FkWDJlMEkzT3VvZEp1RGlj?=
 =?utf-8?B?V0R2a1ZqazZlU1J1WG4zelhCa1hUY1N3UjRIVlNsSy9DS2xONkFTR1lPa29T?=
 =?utf-8?B?d0x5ZjczNXZIWFVVekRnU21STHA2Vm8ra2J2UHFZeWYvMHZDNU1MN25TUnpi?=
 =?utf-8?B?RTFhMm9xdlZCZENYUTAxdURhMVdrWTJHdXhYcHZIU1hVMGUxR3FSVDRWMXpi?=
 =?utf-8?B?MjBLZTVVMzlhWVRTVFI4aElSM3p4WnhNT1dJejJINU9LTWl5RVFlWXFyMG9R?=
 =?utf-8?B?RzJmUFpHQTF4QkhXUzE2ZUhSUlpnVTBTeUQvbjh5MWczUStWTzh6SjBFckZu?=
 =?utf-8?B?U2ZsaUMwMlNEUWMxVkNWOVpsUWtTLzNyOW11NGhGRXkzTjd6K1ZWUzh4MDVm?=
 =?utf-8?B?QmcvdWRZQ3dteE9uOFhMdnA5dE1vUXFzV245enhzWHcxbE1XbS8wMFRFSVZP?=
 =?utf-8?B?bUp5Z004L3FLUUMwdlhhZmYyRmh5eHhlcnhseVdMUVNOSjZEV1BEZjA4NUh4?=
 =?utf-8?B?Y2tSYXZ2R2ZyQ1plc1F0WWQ3Z2oxam9kTFZUSi9rT1c2MGxPNUN6NmUya1Vs?=
 =?utf-8?B?RU1KSUFYRFgzK2F4NDJTc0pONGRuOVpmQWN5eXRuQlFEcjJUZmEyRlNrL2Fi?=
 =?utf-8?B?UHhKVk5NcjF5d3JTNXlPaXdmblVmYUt5N3VKRWVnaG9ibjJTMG0wdWlOZVox?=
 =?utf-8?B?M0twNHFxeTNrdmpuT1FYWkRjYTVvcGo3NjVuTnA2SVlhS2QvYnhueXRqZFpW?=
 =?utf-8?B?T0pNMzUyd3lwUHJQMjNpUTljQUIwVStwT0JPa3pBZ1NkSnd5cGlUVUU5MlVo?=
 =?utf-8?B?N2FtT1dUdWpHaGtrRUhGN0Q0dXJGM3B2RU1Lclhqc3ZUTlRDWWpEbW9meFA0?=
 =?utf-8?B?OTYrQXBOSmZUc2pIK2dCUTR3TFB6VFpGSWpnQmNuRWtMZkhhdjdLWnlUd21O?=
 =?utf-8?B?VmRFdDcybWsvRVJIM3I1VHYyb1BNTXFoMDVmWjFrS0gyR0NDREtwcDJDeEJO?=
 =?utf-8?B?Sm5uOFNsQkpNZ2FTSGZSVkpTc1JCTDdvV1pTUndPZ2MzN0FjcDJScE44RWF3?=
 =?utf-8?B?bHVxQ0hMMDQyblZ1K2xrVFd0M2MxU1NpVVFmV1pwSVlkMkdpMEFaZU92ZjJj?=
 =?utf-8?B?VTBTV1RYNy9oMjc5OTZ4eXdFZEtaa2piWFZuUWZHOEZ6bHprQSt0QllRcjBn?=
 =?utf-8?B?MjhKZEkrZnVZZ0J2Y2xMTTJEZk16TVQ5YU9mN3dCc09haERjYitVbUQ0YWww?=
 =?utf-8?B?QnZSQzJQRDM2VXh4YmhtSDAwRU5qY1JIKzVQM2FNcEtIV2ZtbDl5YjVmNEFO?=
 =?utf-8?B?dGpQWUxEK3NyaUFWUDlaeFQwZTNuU3pxT3M4bnhEc0Q5ZjJLdlBCWTFDcWFi?=
 =?utf-8?B?Z2ltc0F4S1dFa3NGeDBHUVErNzhteXl6Q1RnY05VNUhoN3pTWFlhaDhQT21j?=
 =?utf-8?B?ekpFWjhpMzgvYm4yK1ZEaTcxZXpxckdzQmZQN1BMQkdDTk1VMDh2WHIxb2wz?=
 =?utf-8?B?a21qbVVrSlV1eGpFcEZuZ3E0dXNsZDZscXpxa2h3aUpVOEpFNEdYOXJnbDBz?=
 =?utf-8?Q?ndNsz7YnesFo5sSM=3D?=
X-Exchange-RoutingPolicyChecked: nnSLyy/tpFDtLlDZ+n51WMkbauk2BRPHZyOI9MjQnPJNEVqu1QEaI19muKKaRw/vKMxpoGZlv+Ci8VYh+RCqNdhF6zzL3AxCu07DetltOpGYko9ALv6ZESlym0zUZci2B1fJNsy+JtsaNqG8RHwFM0dsPUqSaX+bSjmI9XX4vbpBBvVFBiL8ua70J6Vp+d0rAReziEpSp1RvwqDk12pi3Y7+/NuvyOVf6TrEta0o6qkjWvO/oatrZ+Lfw/qrug1f/844tSbxwLpRYG9qAaf6wo1MDbK+tbyeRs+tvHB2xa12wv05LA4rQYYrpWPbRwpOui/ldvmgX/1C52ymYFeYbg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3f2404-6b89-4bb4-d3a8-08de8c4b6b58
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 21:54:28.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfh75EXN2z6IQK0Pt9yOmYmMzUmkBq1dMSg37y0gMsFFlD2XK3CtMoMLJnL3n4Wng6Nstzp9y12B0nW4DqExx4mGt/ZWfykNySPgK4rk+Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7917
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Thu, Mar 26, 2026 at 10:28:13PM -0700, Dan Williams wrote:
> > The following crash signature results from region destruction while an
> > endpoint decoder is staged, but not fully attached.
> > 
> > ---
> >  BUG: KASAN: slab-use-after-free in __cxl_decoder_detach+0x724/0x830 [cxl_core]
> >  Read of size 8 at addr ffff888265638840 by task modprobe/1287
> > 
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x68/0x90
> >   print_report+0x170/0x4e2
> >   kasan_report+0xc2/0x1a0
> >   __cxl_decoder_detach+0x724/0x830 [cxl_core]
> >   cxl_decoder_detach+0x6c/0x100 [cxl_core]
> >   unregister_region+0x88/0x140 [cxl_core]
> >   devres_release_all+0x172/0x230
> > ---
> > 
> > The "staged" state is established by cxl_region_attach_auto() and finalized
> > by cxl_region_attach_position(). When that is finalized a memdev removal
> > event will destroy regions before endpoint decoders. However, in the
> > interim the memdev removal will falsely assume that the endpoint decoder is
> > unattached. Later, the eventual region removal finds the stale pointer to
> > the now freed endpoint decoder.
> 
> I'm wondering how this is exposed. What is 'eventual region removal'? 
> 
> The region driver does not clean up after failed auto assembly.
> The cxl-cli cannot because topology is broken.
> 
> How did you get here?

tl;dr: "modprobe -r cxl_test"

When the cxl_acpi driver is removed the CXL Window root decoders are
destroyed along with any regions that were in the process of being
created.

If one of the region's to be cleaned up has a p->targets[] entry setup
by cxl_region_attach_auto(), but not finalized by
cxl_region_attach_position() then there is nothing to stop that @cxled
object from being freed.

The "modprobe -r cxl_test" event destroys all the memdevs. When the
memdev goes to free its decoders it sees that @cxled->cxld.region is not
yet set, assumes it is idle and frees it. Later, unregister_region()
sees the now freed @cxled in its p->targets[] list, tries to
de-reference it and boom.
