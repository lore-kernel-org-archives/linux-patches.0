Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CDB3ACA5D
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781048151; cv=fail; b=Vlo+3zCxzuiIL5T5RfwvJCVwRBRMLsjagyX+s0KfRiclKVe5fUKC5TIf2oW77pWMXSNn1UvdThkgTAquxcBJcHm9R4ARawTnDn7owaV06jCD1jla2EtOPv29VUyMdik9+GcpJ1YVqXnkV4L0KDlUa3AqVL1hxHnxWm/YwR3i/MM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781048151; c=relaxed/simple;
	bh=q5dsqs/p16uPduIN5n/JVRBaBSjReFkwMqAlelLOhd0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cpq/zoCwrqJZY+fCCuPBtsskTfr070jZUXnHoBo/dOmgy/y+/csF3fAFROGFCC75P4IfwqltsVJ6qOaj98BB4kzGdeezGKJtPDmDQGu6OzUyCJgd7+A9kN3oIDY2FNmRg3zwTHj1baLcB02np52YBVBqcBKP48d89QK9pZdB48c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lkXTfuRM; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lkXTfuRM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781048149; x=1812584149;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q5dsqs/p16uPduIN5n/JVRBaBSjReFkwMqAlelLOhd0=;
  b=lkXTfuRMgF9VKIa4GEbn9SQ4cOjBSvogpJsdvjLOnZAfnvK67ie/DFdi
   bWlIHWCuXkqJ8vtfUhqujl27B6bPfhgM+gcGFFrsCo6ze3RhSX6wLeMh6
   9mtYRN8egyTO6tX427xHfhfAagql9NaxFMVSWnYRT996VnFhuo0Bkm3x2
   eJr3M9qRTF2K1GXmBM7baSCIBoWu1y9LckXQ55gUsaOboZIolp6/6byNq
   PVkEKto4by/Ce49NC1nl6BeimUXVgBJRY9U+d75xF7vOn7hlcHVk6n/u0
   K0VM3pfgShBIPZjA5OBO/BjpMPGUyYa2HJyKScXBdlrKHbxfL9ww6cKqb
   Q==;
X-CSE-ConnectionGUID: QuA6Oky3S1GdevEnsqEYWg==
X-CSE-MsgGUID: CDV5U1LbSNuN4wwM83fiBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="85719808"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="85719808"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:35:49 -0700
X-CSE-ConnectionGUID: /QhjN03MSsq+K1PuXYOHog==
X-CSE-MsgGUID: N8M8uvqFQo+DKv4J1RuJ9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="249924644"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:35:49 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:35:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 16:35:47 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.38)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:35:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXDQ1tnKKZYmrdOJuCpjFZPyU1MtBXYiLQM3B1J2m5X0TaW6SzIRlC/utBqjGb8jlPE8JHi2eqxgXVCsyUyoBJTzntXle6SF5CtjXcL9OVUwDBqPrY5KDfGrne9HnulqdCX2Pnb4jLC8qsKB8X8dHFu983JPn5qam5glIkssuIP1iv1ICXYEbogp+KrE6L/g0nk/WZfi3j6l6s6m1koKuQCo7QYF3LP9Nsy3TDTaBuF0pEOPcDbAks2GL6Sux/h4RiSG6MxwvWv1iCQW8A6nxZUGVv48iafEtzukhOIVQRvmO8jn5i7benlhHSswFtDM5j5UyxRpWex03HEirXIbRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dhuOda8mcYkKM/m5PY7LohU1WHZY9eff4/hVh/iulbo=;
 b=QvgaeBv/4sd+9Kk8xZ4dHM3Vtk9ZC3TLSL0oapFl9Q/r7Im1bEiaXZITcqpINrbf3Xeg9H/wfh0LzR9s/2LhDDmNrA9zIqiR4reYLoIBct9kzipYI5r1JFEkOVHjSwgGGPG5X5PvXjKYkjzHZ6cr8p3Ob/SdUhU7udnaYW6l3cxtElcR4zc71abYExXa2Jobn5MyT1jC31aYY9XHp4ZbyBNI+ACQfwbBEj3PDFaf7a8YO0TAKTrC1a4SGSeTV7f5hpolvvvuFVluM1Te32Y1Qz9nBPjABWmMRKfK4tm8Alf1EIGnZPSR9ffA3t/loe5OYUaQYpWpxFl6Df5zl80W0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH0PR11MB7586.namprd11.prod.outlook.com (2603:10b6:510:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 23:35:44 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 23:35:44 +0000
Message-ID: <c46d7e2f-e247-4838-b265-e22b3791d1c9@intel.com>
Date: Tue, 9 Jun 2026 16:35:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/14] fs,x86,mpam/resctrl: Handle change in number of
 RMIDs on each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-9-tony.luck@intel.com>
 <2cd8dcac-9257-413e-b345-7c78bd77043f@intel.com>
 <aiiMfPwk1oDD_2MI@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aiiMfPwk1oDD_2MI@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH0PR11MB7586:EE_
X-MS-Office365-Filtering-Correlation-Id: 2810676f-23f6-483c-6447-08dec67fd385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: qK+5cQdBE8YkTpmC7KtSNIpDfeFVD0sISmsLIh4cQCGFg1mtis1PkL6ddb2VQ+AgO6AFQj7AhaPa635w4EUMUZUtNGCdxDbONph+AF4Xzjqo/NJZz1rXC0AbtxUrvz27reRBlB12wDChGVWjwHqhn7oBtvsEAoyZ5Z6CW2GPGEL2eMbTLA9cmvb71z7jXsdiLQofjwbbxq1uBq1CgrGKRXJTOyYIezUADxFUnEpvpRs2l84lWPb87jfiwIiFpfFrR+0SsbPnpT+Jo9P4b7iGEKbchZzqaz7/Ne4XwpQRQHDPyvB0836+adnE2ShN7dTCU8gMY3kMC3pmY19UX7oIQ4Iymgy4b3mV+XIsssYR62RHxqL7WSFIEUpWcZFqkWE9/y9sJ7oOgaikorXI86VyBTepp3L/EmOadIPBtGwWeqL+/QSmlqllCRijcK3UChVWoeK4ZnhX+ItNP4/2g+uXmGNM/GJPx9qJXmFzGzZ7EQX3SCvBCNY3ao3CGHf/KF+9XT80x0a4b435L9SAL6OfiZmDAtGp6sX6TWyHwYVe9KzBKZrXIGqZ8oEp/m/PI+hyANLKqX3Ma186Gwsq6cVnKK/kexFT/7g2lyXHf2GjzWVE1MkcYh8L0ag/PJ5OZDPxhmFnsKdiqrilWqr/c9GkKtoH8uYASkYr9DFC3Yz/NSUSldS7/mh8mwO8DjOy3quB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnBmTFVDb1VTTXplelpCSEhuYzNIRUJNQU4rSlBSMGFEOHNpdWVoWWJCaXQx?=
 =?utf-8?B?M3BPbWw4dUVqNE05N0pUZnRDazNRc2V1RThIM1AySTRud1ZxaEV4NkYwcmFp?=
 =?utf-8?B?SzhhaVVaUkYxUEx4MFA2K0oyT1JEUmtvVi9qU0ozdW5LVkpGTk9hLzU5a2Z1?=
 =?utf-8?B?YTBURjMzMERhTldQSmNPdEc4ODE2WFJnWkNQTTRRQXM1UVh2cnNMSTFTdFgw?=
 =?utf-8?B?QzVoZFloeDhmK3lVSjE3K1ZtWHlEQlhyQmJITU1jK09zcnJBcVlDTjhSWGwx?=
 =?utf-8?B?SGk2RnVvUzVrZkQycnp6Wm4vRTJzY0dhSHR2cW50TlRCRmNtZDNTRTE1cFRi?=
 =?utf-8?B?b0d4a3VsWjkvdDdLanBxczZMWk5nWkpPclBMRDZ2K2REZ3Y3VUxBUktJUGZJ?=
 =?utf-8?B?anE3Y3ROazBxVDhSUmZrdEw4WXA4S1JQRzJJVjRkL1gwYVgwYUdyZ1VSc0xa?=
 =?utf-8?B?bnVncmZiU0pQQkR6ZHFMMk82Umg4QmhETzdMalRQZFQ1WlpUem04Z09WWnpj?=
 =?utf-8?B?V0FLNGZhTk90Qk5GOE4vZzV5cHlYNTlRUFdjWFdMREE5d1E0WUpEWXM1Z1Uy?=
 =?utf-8?B?ZWVhYlhaMkpCalZYV0VWV3YwWmxFKy9iZmNVK0tFMjZrRS83NldkOGJUcXh3?=
 =?utf-8?B?dVJhUHpuckpNVWpXMTErOEMwVWhLVVo5MVpzUmxMNGtnZEt2QWtLNGRzL1M1?=
 =?utf-8?B?R0pTelc5bEUzajI3c3NoMTlmUnVxQlNvTHdkdk1VQmpQdUxxMjk3VTBDOHd4?=
 =?utf-8?B?aGNmd3VnelJ2TUI3c1ROdTJHL0d1dEpDMndLN2hjYjJ2V1NSY281Q3BzaTIv?=
 =?utf-8?B?S3dtSVIwd0xsbi84bTZEYkJ6K0ZubUhweUdLVUhaQzlCTXROQVRPTEpGaHFl?=
 =?utf-8?B?S2Vady9EejhuRGpVZmpaUUs1cCsrU3ZJc2pLbDFDSk9DOFJ1NFNnT2VyZDR2?=
 =?utf-8?B?R0luaWpGRDdEUjBmcE9OL0xjT1VGeFlqaU5NcUhveVZkc0IwSTBVOGJ4UVh3?=
 =?utf-8?B?VXdaVHlvOG1qeG5oa3FyUCs4dE1zMWpoTndmbnpySHJFTjkzeUo5K2hkMGhj?=
 =?utf-8?B?Z3dHTDkwNTU2QmRBemJoLy8vTHU5ekEzNjRtZWprQkFVeVJTUXI3ckJnRW5y?=
 =?utf-8?B?WUYzYS9lUlZrSFlDWFIzTFZoWFM3L1pFazBMcTFib0oyc1YxY1hhTzU2ZWx5?=
 =?utf-8?B?WkQ1QkJNcTNyMlhCL1ZWWjEvUVd4ZmdJMHd1S1V1YnlUYlljWS9icXZYNWNU?=
 =?utf-8?B?eHA0am92cnpwaGRYOGJJNWFLY1pmaTBzT05ZbjUvcXRaVitlcnlvaTBXWW9M?=
 =?utf-8?B?NW1RUktqNTZncWVwU0RKMUZCNmtMK0c5MFFtMjR6QkNJVDFwYVlYR01xVWcz?=
 =?utf-8?B?bWwvMlQ3ZHFsSzNFV1lyS1hlTHlDR041MUI2MkFjSnB0ZllqdEZIM0R2VENQ?=
 =?utf-8?B?M3RuNkVxQVRuN24wdEZwTmR6V29EMk5LOWtoWnBjZ0FWaW1WS0pEdDdhVzNo?=
 =?utf-8?B?ZGxwa2J5K2wvUjlkYVd1WmRxM3hTL0EyK3hQWUdGVW5pOHN0S0RMZFVKYkp4?=
 =?utf-8?B?V1JFaDQ1WVU4MTh5NzhtbmVUN2hQQU9TOVFQSkxRK3VRRnZMOTBQQkJocGZQ?=
 =?utf-8?B?NFlraWxLWm56VzA1Z0E2MUh5bk5YZ0FwWk9QbHhqWkR6b0JFaEtlbm5CaDk3?=
 =?utf-8?B?TURkem1wcW1ydy8waWJ5V0lnMCsvM2h0d1FsejZFdml5SmptbHN6aktzS3Bv?=
 =?utf-8?B?NTVVY3VUM0pvaXpJNUVDeHNBNmJTMS9OM25DTVZFaUhyb3QvNk94YmQ1RzJX?=
 =?utf-8?B?UzUyMmJPeGVIUW1wMHdRUmVublVLZEdFd1pkRGZDYy94RmdVelBrWE9sZFJp?=
 =?utf-8?B?MDdkMEkzdFQyOTFwSVFaYndac1FhR1NEc3RoVTNlbUdLb0ljMDAxN0VGeWFq?=
 =?utf-8?B?T0s0Q0RzRSttVVhLSHhranBVN2tLU2psRG9kNmxUU3hWUVE1eE1wS1BuUy9E?=
 =?utf-8?B?RXpydVdRZE5zWktobUExWElTZ25IUDZYa25nNzQ5M0FhOCs2RFk4UnVWdC9i?=
 =?utf-8?B?RnYvdExldE92VXNtcmh1elZVdy9ick5PajVLWU1wN1g3WFlqbUphMFRxem5h?=
 =?utf-8?B?dmRWWEdvL2pRY01rOTBtcEFpR3M2ellySmYyeWdqcWFCYjhYZDRldFNyenZM?=
 =?utf-8?B?M3VUbjU1bUN6U25UVzFWV1dLV08vQzlhN0dVSnYxMTl0SlNXSzFEeloxV3l2?=
 =?utf-8?B?czg5NzdXaHhTbjNqVXZFTlUwRkhWUk8reFRFekh1czlkcHVacko1enk1NGhI?=
 =?utf-8?B?L3JldkxTZEc4N2VYUXlIVnNlUFlkaGJpTGhZVGZWeUFsWW9SNk9ETXhCUC9N?=
 =?utf-8?Q?qhBibZeLuDx03vj4=3D?=
X-Exchange-RoutingPolicyChecked: ddiGoYdEUeURQ60Wk7n8R+42I/m7mb4XPKtcWgyRp0aK7AlvhewQs8ki9TIHfgvRAzPDnj9a8a4H819SilCOOguVl1EqD/EpWRO0bS27obiUdroAmxaaDxXY0YoClUoNEvbrY/H+noyaDIb7OD2DdVNPlgj/54gUZYQnDP76xvChElkYciCzTdD54JZUm/qzhWvwa7nDrVMr8/TDjYb2Ii8qUraVjVzziFpDmJcJUwm1DGtudcjbaVA4mDUGUyAzQumuvSCgC4SDQF1sE5QuNs+cnDIl8MkK/Yc4STs5XUyg6Yron8WqRKmuiXIdVGqPVLNGDOf7FTjn2UFllP2kng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2810676f-23f6-483c-6447-08dec67fd385
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 23:35:44.6488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5TYFVdwGFxg8NewcuAjBv0V/ZPx/cjdRZm5GELPH2CWPb+ubMeAM9CF1IM6tplLU43ketzhg/eM9/GWPCl4JrVpDfLLNurSPb7X7cUVS74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7586
X-OriginatorOrg: intel.com

Hi Tony,

On 6/9/26 2:58 PM, Luck, Tony wrote:
> On Mon, Jun 08, 2026 at 04:21:10PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
> Changed the Subject: tag to "mpam,x86,fs/resctrl" to match what you used
> for the RFC discussion. I think the implied rule is "architectures first
> in alphabetical order, filesystem last".

After seeing the RFC discussions I do not think what I did in PoC is ideal.
MPAM is the name of the Arm feature and soon there will also be RISC-V with its
"Ssqosid" and "QBQRI" features. Since we currently have x86 as established
prefix for the PQoS and RDT features it may be more appropriate and simpler
to instead use something like "arm,riscv,x86,fs/resctrl" if such global
change is ever needed? It still follows your implied rule of "architectures
first in alphabetical order" ... but it instead actually uses the architecture
names and not a mix of feature and architecture names. I am not dictating here
and open to suggestions.

> 
>> On 6/1/26 12:56 PM, Tony Luck wrote:
...
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 327e7a863614..b374e2f84a75 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -115,10 +115,17 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>>>  
>>>  static void limbo_release_entry(struct rmid_entry *entry)
>>>  {
>>> +	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>>
>> Having the code switch idx_limit to sometimes be resctrl_arch_system_num_rmid_idx()
>> and other times resctrl_arch_system_max_rmid_idx() makes this change difficult to
>> follow. I think it will help to use different variable names to differentiate 
>> the context in which it is being used and not leave reader trying to understand
>> why there are *two* limits.
> 
> I'll change the local variable name to max_idx_limit when dealing with
> the max value rather than the current. setup_rmid_lru_list() will have
> both variables since max_idx_limit is used for allocation, and idx_limit
> to add the right number to rmid_free_lru list. Added a comment to
> __check_limbo() explaining why max RMID is used there. I think the other
> spots are easy to see why.
What do you think of "min_idx_limit" instead of "idx_limit" to complement
the "max_idx_limit" while reflecting that it is the limit that is common 
(hence "minimum") among all monitoring resources?

Reinette
