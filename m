Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23701E9905
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752007776; cv=fail; b=Dtvfv15dyGNx3Hmqv5OTLrCAGlW8ur3r9n61C2JGRrOjECJNAk2koVyq1gTKqEE3M/7mC9+oua/evDwxpA5rlTRGwfwb86TeKqAIyx4R+SMvgDMiUxxwtncRdTwSsJWgxiToASuwnV0QO6xG6WWz6posQPJcGePEZutaRRJwdv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752007776; c=relaxed/simple;
	bh=PuYgN8bbkSyIdmiBX0gyJCLXoluRFcrCm8CJkCBN/b0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aLCXecvcEZFq2zwK7fcCGLV9eUkqyQisXKe/h+XoohfmPCUqQc44xo3MhuyjgPJQHr6o6eMkOlODd3POvdooy0JtDoyCRNmU+W0tiR5WT3s8tnIboHkCB0yS2ZhM2P5NDUiw0tjeNJOzsWg3+af2X5sF+mRuZAy8i98Zoi7S9vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TFWydMUY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TFWydMUY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752007775; x=1783543775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PuYgN8bbkSyIdmiBX0gyJCLXoluRFcrCm8CJkCBN/b0=;
  b=TFWydMUYs3g1F+J95O6xjOWEeAeazwsnPXWIOsZQvGqbpFhBfxB8ROoq
   3BA4GoGeIM0/ukACeOxw/ctTcCPUj6t6hFsGhj2cjezHYz18uFEMxSVid
   Tcy9BBL9dKzBGt3osrT7b8oRkJLwqXEQDmlJBIhOncxnbnC30pzHDu68l
   v9RHr1V28sTCibonaXt5gkMAQPb/A0FX7B406f1U0hjYdYo8yFgKwQw/6
   uqb6SRtFzuY/X9XO639FCXpxPfaxBUx1C6sqnRQkR58Wb6rQ/2sIWZYLZ
   7yRY1rxJayoR8wHqT+8niNyP/3wlxFzJZ9LrIJiXOxBc7HtoX+nXWBNvG
   w==;
X-CSE-ConnectionGUID: FwiYKNOoSZyBPOKYuWWNbw==
X-CSE-MsgGUID: qdSfF7xITTSedt++iK06mQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65320751"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="65320751"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:49:34 -0700
X-CSE-ConnectionGUID: 8a1cmnWPRO+ppDxLgO8e3g==
X-CSE-MsgGUID: SrqFaXWyTPiGbHdUHrDBPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161246284"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:49:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:49:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:49:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:49:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PUN+hXBFTL1TiiIOwsHlJUn+CrFblkBFJE35T9t8nqLD8vhPCE8gGgLL8kDUWtGdFu3eOPN3MVfib/5bbJVwdhOqETqd7tfREBGVaF7FnTLV/+7dDYvmuAWzTh5sILM/U7xC2yqmrBMrQdyrQZ9aCLtNpPSBYpTqRAWzvUED0zZFRM6l0hq0MS8PCPWFPg86ljvun7ocP9M5+YN6yRgfiSKnI1KCj8bS6lb/NvpUQWvWvcWZgZS39PdeeRZtCU965AB+awD+ngYhRwwnAJJoHw5S1BUYYC/dvWvIoHoUwwrWnLrhAZhQXNcycuN4aUPedfP9MCxinAUrd9DLrSE7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7P8S/rXAnOQaKC3ljArAU7o/rK0rsVi+wFVMc07Nmk=;
 b=g1dZ+UEVJC8T382OBkP0F6Z2y22qRTs9RTSQjt6Bp4hSuWutLwDCNPyHXdFliB91YRwtIGSWb7ZA+ayQeNSKElmdmpkjup548+0ZYPICO05i4fbTbxI0I7a2OdJTdsVphbVWpjsvZ01F8l9Fatcc5eubsV9XU+S8suoBnuxE1/Zc0ekPsoZpYYRQrlYoknqoA/iawynDhYvIgmLFD7mB7fyRjGDqCnAtaUsiyGivvg7cYZISp3ZahfhqPMxhhzsgim80LpU/m2HWRlZgiDXRi1JdH7h1BGSO7Fv9cSuPhgh1al66tQ3iwSrc8nntXpxFpg+opuGs3HhHQN4s9WcYoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 20:49:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:49:28 +0000
Message-ID: <5b2d621f-459f-463e-abc6-9157513f1fee@intel.com>
Date: Tue, 8 Jul 2025 13:49:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>
 <aGa8Pg9pSCJ3XjtY@agluck-desk3> <aG1sqKBJSfHydDsx@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aG1sqKBJSfHydDsx@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:303:8f::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 57cec816-12f1-4755-465f-08ddbe60ee90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ekp5RDRLdEJRWGQrN2xjU3BjaytVUFJZKzNDWTBKS0dlNmZ2VGd1eFR5MVdh?=
 =?utf-8?B?ZGF1cGJlaWRSZDQ0UCs5N01rS2l2QjFOcjZ3OERBTXRRSWJDeWZVSm14c2o2?=
 =?utf-8?B?WXM1UjRoWDhNblBnOEF5MlZHU3AwWC9uSk0xNUZWMTVLZnFmcDNtS09hRTVN?=
 =?utf-8?B?MC82djdidzluYmxaZlV3WndBcitWbnlXTFIwUG9XMEpmU0h4cDRKMVNNUjVL?=
 =?utf-8?B?SGE2ZWtDZGZocUdhS244Y2Z6b1RWYi95RXNEa0dlRFlXK05sMkYySXdNMHAv?=
 =?utf-8?B?LzhLUTV1TFh3amZzSkxqK3dSRDJhVUtFM1ZXQmlVTWI2ZVpFaGlVVmZtZ1JU?=
 =?utf-8?B?VmZlK05EdUtUYkpQM3lhQnJzck1Ccmk5dTN3cHBkUEZzRXJrUkdwTC9sQVhv?=
 =?utf-8?B?RzEvRk1ManVsM1N0K05EV2VlcGc0bWRaR0NUZU9Eay9kNXF3bmlMcXpFUnNX?=
 =?utf-8?B?NEFmTmkvcFBlY2UzV0NaOE5WWDFlcTZrT3hzZVJGVXdSSmd3K080ZS93Ritm?=
 =?utf-8?B?bU1oUWJhQ3hxZVQ3VEZoUktkMmp5ZGJpaEZ1dUUyV2JYVmFZeFJvKzVYS255?=
 =?utf-8?B?bDN0QjZEWC9jSlYva3Y5RzYvZGh6YlE1M3crVHF4WHQrZmxqTmhkcGxVTWNx?=
 =?utf-8?B?c1lyNGRzMlUrdTZIMkpBTEtBMklOTmx2bDhrWEJldC9zQ0xBNStRUXE0Yzcv?=
 =?utf-8?B?TW9TWTNSK0R3Y0JaMEZXYzViTnpRQ3k0N0xxbVRBMjRTM245OStnaG1qejF0?=
 =?utf-8?B?ckJBdTdhRmpGWktQcjRDUm1kWGM2U21kanZMNEFqYlJ5NnM1Sk9wUHhVYmVu?=
 =?utf-8?B?MEFZNUtUY01OZUs1VHI5NER4VlZlaXd4M2NUTm1nMEJxTkhHUktPU2xGYkZ1?=
 =?utf-8?B?Wi9wb0JXRXRROWtFcElmZEJOMkJCaHd4Yzd6eEx2ckVhNm5FVEkydHptcHNI?=
 =?utf-8?B?VEUxMTJoTWdWOUthc0tZQVNUQU8rN1ZRS2RMY1pkeDBGMmpvU3dwa1E1MVpw?=
 =?utf-8?B?bmFlc3NFYldUcjV2ZlFXTlNRZ1J0dm9CdkEycmV0K0hjZHNEZ3RCNTBwT0h0?=
 =?utf-8?B?NS9DeHFRODFGT3VySmMyMDRpSVRaR2ttY2xrcHdicHN4N1lKWGFVS3JqWmpF?=
 =?utf-8?B?MTczb3pBUnlORnhMU3BVdWw2cXRKZW4ydkpMSm1SY0hGVGxZZFM0SzVtbldH?=
 =?utf-8?B?dzNzWG5DNWtRN1VYM3JLODFFaCs0RitJd3BoL3hsRkUxRmRhckFtMWlURFlL?=
 =?utf-8?B?aU5Tc1p4cHNkemptT3hIaFdETjZ3VXpoVWM3dEJHTTU0ZlFueGdOUWtUd0tG?=
 =?utf-8?B?czU5QXkxWnpLSDZWRXdTam9ERklQT3VJYmRSNlRpVEhnRmQyVFVRSU9aRnMw?=
 =?utf-8?B?WjdyL25abnNBdUJIdGVYYWtkQVI4RUFJVHRxRkNpSXAxY21vSytYTWJSWXpU?=
 =?utf-8?B?aEYzcmd1eDE5OFAxV3EwaUtrYU9zUER1YVJleWRlMkhGWGN4N0tuQUdveVJp?=
 =?utf-8?B?QTlyMEloREQ4US9SV2ZYbjljNFQ0MGNWOSs3clp0WFVFeTdFSmVlVGFybkVa?=
 =?utf-8?B?ZGNkWnh4QzFpT1RURlNhWnNuVkhBZzcrL2lqZmRDZDlYL083QUFRTUdWZFpG?=
 =?utf-8?B?VjI3N3MyclNVd20wMnhlR1hZbDNYbGM1MEloNTdhdHNIdmpGM3N6cHp2aXY2?=
 =?utf-8?B?MEdoYkNMRStqMEg0TkZIYUF1VUwvUzF2SnZsRnZLQ05WMGkzZzJ5REZVTEov?=
 =?utf-8?B?aUJJdElxSzZBeVp6WkwrLzdhMVR1Ny9EdTR2WGp1YTBzZ3g1K2dMQ2wyUlJF?=
 =?utf-8?B?Q2Q2RTR5anZEdE9GSHlsMVlKV0h3ek9Ya29CSWFXNWFMYXFtM1FXN3lGYTdz?=
 =?utf-8?B?NlpqaGR5cVJFSlhKN1hBcXBHOFF4RWpPaVNLbWV1U0d5L2ZtM2l1RnRRRURr?=
 =?utf-8?Q?lpb8ZhmANEY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHhmTzVtaXVERzVCWmNCb2t2K1hUOHpMSUMxZzQvM1ZQY01oZklVbmtWblJh?=
 =?utf-8?B?Z2d4TDNjb05LS2N6ZXBHSFZTVXI3MGllSFpHYWZtN3drM2Fublk1eHMxa2xD?=
 =?utf-8?B?amlYdzJrYTJlTEtOZUFzRnBtTTdpL3lpU1RRUGVPcFVLOEUzOW8wUkRvbHlo?=
 =?utf-8?B?ZkR3YWp4R0FkVmlJWVNFWGFzeDdFVnFrc0Z2dVJZcWV1MGRHWVlHMGNyNlFU?=
 =?utf-8?B?Wm40Tks4alJzUjhZNmhuRmxyWjY5djNPR2RlbjIyZnhaV2Q5b0tFWlJIemx4?=
 =?utf-8?B?RDlaQzZtWEg3dWhpY2swdmFLRGVxZXFkaG9McWcrQ0VNR1BhNG93V2JuR21j?=
 =?utf-8?B?MHhWMXRkdncwSFN0bGZ4YWdyNDVkaGgrRXBCdktLZmhHbkpxcWh2YzlDOXZj?=
 =?utf-8?B?MXlZVU1MS1Voa2pYQWtNbEh4d1RRVTIzMVE4ckR3YytEcURDK2tiNUhONU16?=
 =?utf-8?B?TmE2elRZMmREOVVONFBYSkJoTHphcEtyMm9VbE1SQm5PZ3haV1k3Tm04elg2?=
 =?utf-8?B?RkxPK1puSk9hVC83akc1QmtOb1hpS1d2SUpXai95K2F1S2xNeXdxMm9CeHZN?=
 =?utf-8?B?aFRkV2dUVWY3dWR1ZnVYTmF2NFlSU0luZncyZ2c0WEVublZSaS9JR0NaNHhD?=
 =?utf-8?B?b0tIaUMxVkgyVjVuYjd2dXBQbWM5engvN0dZRHZDbEtHcUNyNmpMRkdaVk1O?=
 =?utf-8?B?WkZMd1Q0cFdPdDF2UEM2ZTdxekZFQnhISlRZZkdzVmxKWG1EeWN1YTZlR0hM?=
 =?utf-8?B?enVXU2R6b05CMklWTXdxZldlSWxJdkpaeGZZNWJpRWdJSE5SWC9FeTdPb2Jt?=
 =?utf-8?B?Z1k4aEEyd2lPQUhsdXd5RnVxRklRVkJEVzhDMFhodlRTUmRDeHk2cmVjZzB5?=
 =?utf-8?B?ZUE0SWZ5Y05mbk8ySGh6YThyOGFpTS9aNUJUMlV0bXFqOTcrOWpEekFXd3c1?=
 =?utf-8?B?NkxoS21DMWowZi9qQmpUYmFlUkJ6dEtkKzF3Y0tmWkhNTXBYNGJJU2FqNGFr?=
 =?utf-8?B?cG5BNS9WcUJ4d1EvdndZNjBjRko0SGlBazdFNFpPQjNHbVJSeWNwY01nNVNB?=
 =?utf-8?B?U3ltNWM3bElqNHFKbnBzQzMwTG5RSlk5ZEpXS1lNSWpQRVVQR1pZQXYzclBI?=
 =?utf-8?B?YzZjRGxiam10aklMVEdmbU9sL1NWR1p4Qzg3ZjRxcTV5RkxwMGp5akVlcjll?=
 =?utf-8?B?czZzSTdCa2lqbHZiSS9LelIyWFRUUUh0VHAwWm5TQUc5RTVGdTZlTWdOVzFn?=
 =?utf-8?B?OWh4QWtVRlBCMzV4aERESkY1ODZpY1RKSURVTWFid29XWThWY0EyM3FqZXph?=
 =?utf-8?B?TVRkRzZMMFpPTGJsWWc1cXJnMG9LM2hnaEp0NzN0anlVNDBjSFZ6SWxDRnZx?=
 =?utf-8?B?Q1NqYlk4ODFXeHp3d2JJRW41M0dhRVgzUXFlR3NES1kyOVBsTG1ickxkL1p3?=
 =?utf-8?B?QXJuTVpKT1RhUHNUNG1qN3RwajJaeXp6M04vS0VPSUdYL0Z4QTJpdHc1ZVUz?=
 =?utf-8?B?WWZxTnhOTDFUUEhHS1dKdDBseGtnQk13UFlqRnlxdU5tNkYrZmJpb1dzSU1I?=
 =?utf-8?B?Q2N0endVbDhaMnpNZ0JFTHBUcDR5S1pobXFkbUR5SW1JdkVZbFpHNjh3dlZx?=
 =?utf-8?B?VTdXSWxVZHNNYnhESHlpcjY2QXFMK25vM1ViWjRyc1h2bkYrUk1ZLzhLdFln?=
 =?utf-8?B?bUpSUitIWXAvQ1IyK3hiQnJmVTU2ZlpVL083NWl5T0NRcjhOdkxFelI5WWtB?=
 =?utf-8?B?N3N2cFFBUG1IUXVpRGRsMWdRY3FVLytLWHY5YkRWT2dDeS9JUFFxVHZSbVdz?=
 =?utf-8?B?VUxGb0pscWEwWlRtajVRT2ZPMkc2OWRLOTNLQ05DbnVUdUlLZGkvajZWUlc4?=
 =?utf-8?B?ZW1kWnZwem9MTDZpNko1ZFVKNHg1MGV2OVBYTVFKUGxPWTFtVGRRZzZHcWJ4?=
 =?utf-8?B?OEN4RERrUm1TcU5ZMlBmY3RKa0xHaThVendKWjRBRTMzeFVlVGM3ajA5dUhG?=
 =?utf-8?B?NzMvUzVyWE1YNUZPaUdJSnpIRTRPbVB2eGhlR2xxVU5pa0N5OWIzb2FRbjdM?=
 =?utf-8?B?ZTY1T1pNYzMveDdnLyt0VHRLZDdSVDdNQ28vK28xVUdtY2hkQW96OFlxcW9u?=
 =?utf-8?B?RmNQZ2RWZ0VJblFhTWFWWmEwY3hBVmJuWlFmbU9SQVgxNXN1dTZ2UXVEdExX?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cec816-12f1-4755-465f-08ddbe60ee90
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:49:28.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9lyzBtDUL7Ir38b5OpykF5Y38JArXd/Q8qh6oFKeEyXaXcNfNklA0MEamFmqND7zfp0Hd4kwBqrnrV8H6GmJQRdjv+PNL0ptCNU2uyXZPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com

Hi Tony,

On 7/8/25 12:08 PM, Luck, Tony wrote:
> On Thu, Jul 03, 2025 at 10:22:06AM -0700, Luck, Tony wrote:
>> On Thu, Jul 03, 2025 at 09:45:15AM -0700, Reinette Chatre wrote:
>>> Hi Tony and Dave,
>>>
>>> On 6/26/25 9:49 AM, Tony Luck wrote:
>>>>  --- 14 ---
>>>> Add mon_evt::is_floating_point set by resctrl file system code to limit
>>>> which events architecture code can request be displayed in floating point.
>>>>
>>>> Simplified the fixed-point to floating point algorithm. Reinette is
>>>> correct that the additional "lshift" and "rshift" operations are not
>>>> required. All that is needed is to multiply the fixed point fractional
>>>> part by 10**decimal_places, add a rounding amount equivalent to a "1"
>>>> in the binary place after those supplied. Finally divide by 2**binary_places
>>>> (with a right shift).
>>>>
>>>> Explained in commit comment how I chose the number of decimal places to
>>>> use for each binary places value.
>>>>
>>>> N.B. Dave Martin expressed an opinion that the kernel should not do
>>>> this conversion. Instead it should enumerate the scaling factor for
>>>> each event where hardware reported a fixed point value. This patch
>>>> could be dropped and replaced with one to enumerate scaling factors
>>>> per event if others agree with Dave.
>>>
>>> Could resctrl accommodate both usages? For example, it does not
>>> look too invasive to add a second file <mon_evt::name>.raw for the
>>> mon_evt::is_floating_point events that can output something like Dave
>>> suggested in [1]:
>>>
>>> .raw file format could be:
>>> 	#format:<output that depends on format>
>>> 	#fixed-point:<value>/<scaling factor>
>>>
>>> Example output:
>>> 	fixed-point:0x60000/0x40000
>>
>> Dave: Is that what you want in the ".raw" file? An alternative would be
>> to put the format information for non-integer events into an
>> "info" file ("info/{RESOURCE_NAME}_MON/monfeatures.raw.formats"?)
>> and just put the raw value into the ".raw" file under mon_data.
> 
> Note that I thought it easier for users to keep the raw file to just
> showing a value, rather than including the formatting details in
> Reinette's proposal.

Could you please elaborate what makes this easier? It is not obvious to me
how it is easier for user to open, parse, and close two files rather than one.
(more below)
> 
> Patch to implement my alternative suggestion below. To the user things
> look like this:
> 
> $ cd /sys/fs/resctrl/mon_data/mon_PERF_PKG_01
> $ cat core_energy
> 0.02203
> $ cat core_energy.raw
> 5775
> $ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
> core_energy 262144
> activity 262144
> $ bc -ql
> 5775 / 262144
> .02202987670898437500
> 
> If this seems useful I can write up a commit message and include
> as its own patch in v7. Suggestions for better names?
> 

I expect users to regularly interact with the monitoring files. For example,
"read the core_energy of group x every second". An API like above would require
a contract that the scale value will never change from resctrl mount to
resctrl unmount. I understand that this implementation supports exactly this by
allowing an architecture to only enable an event once, but do you think this is
something that will always be the case? If not then an interface like above will
require user space to open, parse, close two files instead of one on a frequent basis.
This is not ideal if user space wants to read monitoring data of multiple
groups frequently.

I would also like to keep extensibility in mind. We now know that
unsigned decimal and fixed-point binary needs to be supported. I think any
new interface used to communicate formatting information to user space should be done
in a way that can be extended for a new format. That is, for example, why
I used the actual term "fixed-point" in the example. Something like this avoids
needing assumptions that a raw value always implies fixed-point format.

Reinette

