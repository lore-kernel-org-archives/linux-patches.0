Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060BC4BCAD6
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787328675; cv=fail; b=kq283L3fc773yVCZZK/rzzdIZQ9YoniBTsvLwRHMbR1cnMNv+74u5nkRT4KENxH5TX7BVJvh6J6qCkhNW00IpcBsQhU4If2yfU5qtNqIoiKoSzGWlxWqineiHwsuglXN9vyrKzdJt5H5Qh+iZcme28FPOFUOanrFytgzWqKMthc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787328675; c=relaxed/simple;
	bh=GgOajLDsKAb6ADgih8C6KmT0XHhf3/86n8LFlGOOzb8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZY9MPmzayAjxF5JiyhhBJTypBFwjTWTe8yYUEr8ebSdg4WmsQnnG8vYfxhIgOWkpyHWro565W425rheWd0H1AcdXayIwlxv4bonSvIDHkXdCNhsP+UXw2xMGAwtTGFUvkFsI3/KdVrIx4tQpL63/s3uHFnNt7V8U9r4527OHOBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FwW2H6uE; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FwW2H6uE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787328674; x=1818864674;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GgOajLDsKAb6ADgih8C6KmT0XHhf3/86n8LFlGOOzb8=;
  b=FwW2H6uE7FY6LrqtQzw30QGCkck2IcxaIWSCWf/IP1iSSX8Vb8Mm4tn6
   WaHcgyUNIWnveSEAcuWB1EJpd2Ffq5A0otrZG2YNK+BM7yH59IYTYmrSp
   2thz2x+rl/S8YMVMsFek7sSAtNLfdt5aJACndN06Up0MiWsjQF0763CHm
   XsvylfHzksUy7Yn6P3lORqf/TPus4tM/6tT5gm7oVmaVZXKK5nmHhfXOA
   e6Au4csU3vgi1TwRuUi932xBDo0x1s2hM0U9yNcAuQPyM+UJ5fFHWXkrj
   jVNYCj11kIdLdnOsHY2g0FbVDcAr0ZZlZXhd/PnAHEacebrEL7D9BWJnO
   g==;
X-CSE-ConnectionGUID: P1tgTVW9QJ6hWbNO5WCpYg==
X-CSE-MsgGUID: CPpDg/kpQRSiFtNZvVkfcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11882"; a="88083675"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="88083675"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:10:12 -0700
X-CSE-ConnectionGUID: FS/jua/pQNmmPctPEW4utg==
X-CSE-MsgGUID: LMp6tuDrS/uzK38v962ENA==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:10:10 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 09:10:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 09:10:10 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 09:10:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dWn+CFjIpC8DOp3cocou6Xzg1lBbD3ejsJAD1pOWm2g8BIjqA2Jph9ILLahfPV3AEH7unvjf0fplR3cQOTPNNCSfYGeFMtBgIxZ5ihv9WExjw3bDT3hrYWJI74KX0wl/ewQlVIjSsHMWIXrMlCcO9pQjRcgWmhjMZfxYxhI5zlLDAGlCDVs4BCRVd3yX/tXa77/u2lJn+K3M5Cc4IPk3VDhW+boRh9ft+EcC5l+3A3GiU2STnm783myGB/7ukeBr5BaDmMn3KCHLNymriSGHEE9+Ur5rW7E9HkN6W3PxKdZ0Q2BkZqri3PMkHaRsCfZ85KJ/lXxv/38uWx804SZwUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOvnIaLLZfsI/iWHU12XlB2OqAIIHasHRVkjzVyr6t0=;
 b=iriwFyVlCOvg3lL/5MfNgQyCrgqjdCZ0R95bv8nXqmzbLzsqEzLt9PpagtL9cUTEKK7YsN9Ydh2R8INYsCY1tRTm31KwHdSmsEM/IijSQeiDSp++tiGzE4lPvOskpuTcirv1Lvg8EuH/dTFZ8c/YZj49NrunnOdI2plhbgL1bJ2U5QZcEuJC3f7UeJG0n6STMc4v2QynAP1/g1IENk+bhs2tGtTOgBraCbuAFQh+R65DTjZGTh8eSkNKoMJMf3TXJTR8P1fJHvL6BLxadYhadj2wCaNFZHggtNpVPbLOHUEa58Ea00tvaNxclLLUEs0CirEglWAbMM+0F+mL0udvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB5897.namprd11.prod.outlook.com (2603:10b6:806:228::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 16:10:05 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 16:10:04 +0000
Message-ID: <600c656c-4b62-4de1-ade0-149804e4494c@intel.com>
Date: Fri, 21 Aug 2026 09:10:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET
 event groups
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-9-tony.luck@intel.com>
 <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
 <aodKsOMxcdasi0U6@agluck-desk3>
 <779e9ca5-9785-4cfd-b6c8-42efa1b2f560@intel.com>
 <5ad0c32f-a734-4bae-b30b-791796e46009@intel.com>
 <aoeLm3LqYXTrADeA@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aoeLm3LqYXTrADeA@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:303:2b::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: be980366-a1ab-42ba-5a8a-08deff9ea921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|56012099006|10067099003|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info: c4G2S7Ai+HmtpcnZdkUEP5DtieROfL3JchIU4hKKSvtgzbYSlY0ShnVexOx8Urhb1Y+oR4XUvZloHIMLnM7lVO/2E8pi1lB/D9UXlYX8XcsPvM2oxRNYSXQsyaA4zELjGMR11dFGmefbLpQQCH45lY5DeoxChPItVy3S1/LNeVkJx1c5p+DHWguNgE9paGoIJfDpNFBfCqxEDPRH8zgw0U6wGGbNeGJnAknqRA4Ar0vM81PBlek4mPlp9epzOlFrgThk4eav+v/sVVQn/wtt8y9y7OwlH3+u6MHDGc9305SSp8y7hhEzEE45X+ZLILRIAwN37fGPF/lb0uYfpfr22n73mFSor3TCj2XlyvZ1dFJoYtkYm1ziuE/Na6j5HEmFi1mTNnkSQHYXMm3XMW2miJXW4+RJk5A+E49+qxsTPHo41wMAYGmEXMhRT/XynJCi9kc7aT0UN8i/j+nmvdJu9S9O+temDIYZyFIbUnZ8jHqeG0+mLeuEORhCXsfW+TVusTc45SXpc+TaqhxyV1sbTTLzgycUshKfhXM5cjjIA+ADIX+L0RutLuDU+w3BShc9UgzOG2YdsMUygKZEfz+oyD/oYOhkY1zTBEUMs6jNGRuQwENLyZh9llIa7mpfXr56TQZ59aM9rr8pga4MESCaKNsB8q/bBLbsybc68yY+kNA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWZEcVlyNGhMN2JTSFhnWjdFU20rQm0vcDFyS0YzR1ZVOXZ5MW5VdUJxTFRo?=
 =?utf-8?B?a2NXYnBqak1uSWFCNTRTbFFaVm1sbUpWSXhMcnhIemtVdTVnMVFsdUdqL2Uz?=
 =?utf-8?B?UjhhSDBKV0t2VjlkdnFiQ2luR09aYkZ2eXVZVVBKSVBxb3lyNlVONkJmeU1m?=
 =?utf-8?B?N3VoTHEvRktxTEpEV0VBNHZJNHk3VXFUb1c1UjVoeHc1Y0NJVWwybU9KZXdY?=
 =?utf-8?B?TmRZY1QwRTZHV0UyZ1NuY0p1QWc1QTFndisyWnU1ZEtHRUhZcDlEVGptSTdT?=
 =?utf-8?B?VTV1Y3FTYzg1SGJ4RGdjcXZXNWVsdXZJdmkzYjQzKzM4cHh1UDVNQ1lHb1Jk?=
 =?utf-8?B?WWh3QzRSVXlsbTV1djJxUXpFQ1gwa21BT1o3NGlabHBFc1hzanJoOVk2MFZh?=
 =?utf-8?B?M1g0Zml0U1hHZmR5MzRSbHdDVjVyNFNLU2dBbWJvODdIbjJaTzQrRStTU2tx?=
 =?utf-8?B?SlBtU2F5Mm9HR2svcE80aVZuQm1oRXIybnJOSzhTblkwVENDNzFrcFRzZ2RF?=
 =?utf-8?B?WlR2alFYMHJRUUFzem4yc2FLRkp0RW45NEtuYXdhYVAvc1gvWmpHMVlFN1hS?=
 =?utf-8?B?L2ovaDUwTlk3eU5WNEdRa0QyNU1LUHN1Z085TWxDeldVai9sNkRQYUNCODhF?=
 =?utf-8?B?cFBMcjVJTzJETXFmK2QwMXVobXh6Qm05QjB1S3hHaFFVcUV1QlRmNnlsRnBz?=
 =?utf-8?B?NGVRU01lWFgvZm9JbzNibVo2UUVnNisyZUVEN0w1WEhmdXJPcFFORHUwd0Jn?=
 =?utf-8?B?bnVGWm5qYzk2blFYaEl4WUJRdU5TRWM5bXlQWFY3czVlQUx5SlpXbUlYbkNr?=
 =?utf-8?B?RXRZSktKMjFwM2tHYWVvMFlmTmYvVk1nblVTU04xbDRHak54aHBreDV5dEVF?=
 =?utf-8?B?cDgzNXZZaWtSQUJVMXVBSmczbXBudkdtdDY2OFNrcTFEd0tIOXRjQjRxY2NZ?=
 =?utf-8?B?dFU2WXUyTjBCWU1pN1R6c2RoSCtDdWJNTUpwM1RycXNYME1jbE0vdmtsTFJt?=
 =?utf-8?B?SE4vZDA2TXpLcENNRXB5eG1PUEh4TllSRVV5Skhlai9zakhuNUF6Z1VRZFZ2?=
 =?utf-8?B?Tm1MZXM2SjNYUW9DTGtIOWI1TEF2aXVxeFBscDJRTjNGMy8xRFJRYkNudlhE?=
 =?utf-8?B?Q2ljOEh3NG12N3llOWVta2xvVDJzWWVXbk5wdCtGTEIvVkxkM29FeTB2SGJO?=
 =?utf-8?B?Rm9wUElaS1FRbHlUWDBzNUdTYitzaks2M3dJZUlCSmRKWmJYODZ2STRodXpD?=
 =?utf-8?B?czVUbDFLQk8wN3pGZ3QwZ3IySmZERndoSnFISUxIa1dNUXZ2VHY3Mlh1cmhY?=
 =?utf-8?B?SnNlLzUveWNyYVIzU2I1SWVidk9JRU93eFpqV2ZLSWc1TUtOOHVGSTJlYkhO?=
 =?utf-8?B?OCtNRGZLcHROL1BwNXhkQzZBVkdJaEVQcWI1NTh5UHdMays0bGlpSHUweWk0?=
 =?utf-8?B?eE5RZy81WHQxVE4wTXpJNkNyZklGRTJvRk5PM0RUUDRDU0huTGVHdTFvZVpF?=
 =?utf-8?B?V1oweUY2SHM4Zys4cEFSb1VWbzV5NmtkaEpHa1FIb2xzRzA5NlMrT0U4S1p3?=
 =?utf-8?B?OEQ3enMvUExuWkJRYmJhN1ZWN2JGNExrZFJoTGpLVVY1UHc1MHhZWVQ0QXZV?=
 =?utf-8?B?dUZ6Q1hFZTllOUpBWkdOMDNKc1BjMmtrUG1JZ3h3WUNZajV0N1QzWGUyb1ZU?=
 =?utf-8?B?OHVGamNmUDFGZlRlTXJRYWF4VkhGUUtRUTVkUngxN3N6NlNGYlJFdG81YWh5?=
 =?utf-8?B?Yi9OeUVJVTBtbUNwSHZ4MDJ4dWFoZW9VMkVkcGIvMlNOWi80Wm9PbERzV29W?=
 =?utf-8?B?dGwzTG9CanJ2b0pHSWd2K1ZBZWg5QnRZeWdGd0ZnTDBLTEJaVFd1bGhSWlBt?=
 =?utf-8?B?SzJ3bDZZZzhPMVEzNG83QjdPYUJPaEszZFArZ09FSEFpaWp2TmFxWU90WkNC?=
 =?utf-8?B?bGs4akZzaklRVC9xb3hCSVVDQUxvZjBEODdJRWhtaERCZDg0QlZhdkF5VHRn?=
 =?utf-8?B?SytNbE9lOVFKc2VrWjcxOUc0MENyQndvTkZ3VnE4WUhZWWc2L1lkSXd6SUp3?=
 =?utf-8?B?R3VzOThGNzBDL2VObVByU3hKbERyOGdOUnZnYTZId0hwcXNtZjhGNWp4RU9o?=
 =?utf-8?B?OTZTdE9uWlBNZHQ5bDNqT1VtNndiWjhDYmx3QWR1ZjhpMTlac0diTEZQbnZy?=
 =?utf-8?B?NkZMaVdtR0xTZUFuMHBJU0Y2ZHIxNkJwdVhDV0VQMDl1Zm93blBhUHE1bTNW?=
 =?utf-8?B?Snk0OUNSS2pmU0FrWUw2anNhaWtwcWFFeEtFQnlXU1o3T0d6Y2Z6Q3J4WFJm?=
 =?utf-8?B?RnN2KzE1Z3BCTElmRzhYWVBGaThMQkN6OTZObHMwWkV0c3hxRUhGNS93bTFW?=
 =?utf-8?Q?tW9VwU5Kp4sVo2bE=3D?=
X-Exchange-RoutingPolicyChecked: ZdMbjsBNFYLjfZc5Y3oiyWxd67w1zU0pD/xduSQgiDyHGfNu9NQuu4EIIwOZQElu6Cg2fXO19ujG/2yBZ+Fv0RydJtY8CR+m7x2MdCVQAvhbpfYDihWx4y15+MIF7EMcQe+h3+fzJaMhdjmY5U+0g8JAC2hgGCphwbMMYr1fAGKFgKTCyYVNAS13n77OjyzdOwL4aSCSUOXzmMM0lW6tTiBtMVcoUgyl/yFSanVgRN9o1S8AFNq75cQoGDpN4eN7hZEUayHlPH17ZUUXh5mc5L2b5bfdPpp4O6RVQkYiNCcm0zDvr4EZbA5NDEM1mels/3kPlSQnhsfm2pRxfBWb9g==
X-MS-Exchange-CrossTenant-Network-Message-Id: be980366-a1ab-42ba-5a8a-08deff9ea921
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 16:10:04.3395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRuHifpaIlQDOMon69wEml5sCe66cbTMJ+t+a1SfU3arUB2AI0OYpBd1Xhi0O/wyNYWhrYnM7yXlItGUrydCA26VDmz5JYQA0ttm3puNexA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5897
X-OriginatorOrg: intel.com

Hi Tony,

On 8/20/26 4:19 PM, Luck, Tony wrote:
> On Thu, Aug 20, 2026 at 03:28:18PM -0700, Reinette Chatre wrote:

>>
>> Thinking about this more ... does resctrl really need these to be arch helpers? With
>> the mon_capable/alloc_capable available, resctrl fs does not need any help from architecture
>> to learn whether a resource is monitor or alloc capable, no?
> 
> x86 and mpam versions of these currently use different iterator functions to walk over all
> resources. But there is a file system version in <linux/resctrl.h> so we
> could do
> 
> static inline bool resctrl_alloc_capable(void)
> {
> 	struct rdt_resource *r;
> 
> 	for_each_rdt_resource(r)
> 		if ((r)->alloc_capable)
> 			return true;
> 	return false;
> }
> 
> Ditto with s/alloc/mon/ for the matching partner,
> 
> Would you like a patch to replace the arch versions woven into this series?
> 
I see this as nice to have but I think it will require more planning than just
weaving it into this series. As you highlight this change will span the architecture
code and now there is also RISC-V to consider. I believe RISC-V is queued for inclusion
but not yet merged and it handles its resctrl_arch_alloc_capable() helper differently.

To me this thus looks more like a separate refactor that will span resctrl fs and all
the architectures.

If you find removing these helpers would help your AET dependency work then the answer is
clear whether it should be done. If it is not required then I do not think it is reasonable
to require this change as part of this AET work and I'll leave it up to you whether you want
to take it on.

Reinette


