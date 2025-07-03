Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A5428DF28
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751567267; cv=fail; b=fojBsZYVAF5mgNG7++PROyK0X9Ktj5t7T2e3p9qUmN9rt0cgd54tELShYcXp5MhAuMpwZ2YLuIDB8uPYernPvuotGlU5TiGsp3/2DH9uRpCUkFQEQ93JpxXy8udYmuzKm2CmmLbDsJXU+1Tf6XeJ8rGwAcZCuvKHWFAF+IWsRiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751567267; c=relaxed/simple;
	bh=tbyMswwDstZAvbEFolIP/phPzQ2r8xBF3joera+LPXc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sSoYuDX1evX5j/vSvFj+L7TgJeemOol5MSLamE5rJ7sBhsK2pnmNM8TWcmugIgbKBvKQjspD2zWzt64eljg3M/fUaHBElI1Uh+RHgOiC3qG0Za9vf+6Y4SKMwoV8YF7DTpTgGF0eaVxbhD3NtbSy3wE/7tkiR52KlzSh7h4wTME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ny6GV51K; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ny6GV51K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751567266; x=1783103266;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tbyMswwDstZAvbEFolIP/phPzQ2r8xBF3joera+LPXc=;
  b=ny6GV51KvwC8Y4eIJ68Sk0FduKX9Dx9SBacAqy6VKnIcyVFpU99fj1lW
   ujxnEE1yPVP2ZqCiz/VrjXfw/TceUpDnlzSSIC7IQpeW67oxiAJEd1aAa
   IvBVh1k6V9gsBDRCKDn+H3LAJjl3Mw4Em52GcqJvuQ2YebMg3K6/iC9cM
   hYgd9dgb8OG+TSgQXv1ymKwqvjPKgjyV3NH0flscyjj0rJUyqzdAI4mmD
   XLPdyhc3bLZmy8s9ExgfYIQUhfGd6NKifrQXQ7OomcayBEsbKOpHuxaTj
   33ayJdq2qA9LPk+pk46RPX5ZfWNXwX4GNTJJBcR4ZRI5rfn/RmObPc/ZS
   Q==;
X-CSE-ConnectionGUID: 0/fefeVOQJSBfs/p9xU7AA==
X-CSE-MsgGUID: 85BE4BzhS+q6EHaZ86ebew==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76453304"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="76453304"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 11:27:44 -0700
X-CSE-ConnectionGUID: Qe7OENESRHmWaxi25sTa6A==
X-CSE-MsgGUID: b5NTxVhARc23RSoFLTo0xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="154811887"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 11:27:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 11:27:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 11:27:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 11:27:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TBT4BALEvd2+Mn5SyaEEb48vkefnBX3TDGO6H3SHLRjxfFZWQzngSft4f5xuWdJMQB9/kplNPGvLRgRmEGLWCxB6GQoaw3DXz89DDyy3YLOZZPL7Hnc2fTy2IhXpGnkp21JDva6eEybZFyvmtEC5ZPxfZ1NkciCyPjZWE9T+Jomv/GFowv2pVRDES5G9OUgoe+GgW77Bb5WiNxW+ufSE/LQY3z9O15MI+IV0p1Y4CSzun21n+s3Y/o/6Hs3OlAQYixcqCmEq9MyUT93YXfJ/DFDUP60wTXY+Mj91rIVbxzmXCre3w99QTX2os2sHCvybfpRLdgVKN8DSNlDziMXP7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDxljzFVD85ty7nnakdwydUjWiKCp6ABK5CnlPn2Bb0=;
 b=kXFhGnAinugjukw4PcMYXYSOqY+g2+lVHZj1E0nRSLQpAhSqNz7YlpNAaGp3Evdyz+dwo5kcKTmumgiLkCkOpLVWJ1BVmDb1nX0jOCad8wAE1e0iWejqKL83VuP4geHlDkJa5Y/Praze/86ozlIGvIs+OarW+K6G2ChI+K5sDW2Fk28/LTfDxITXz7Yp+aBj06qyTV57hjWl9XDFv86302446BUYtLw/fGvhD8CxgjpcJYbTIN3BUhp2De4xWuZwUHEfGSiJ7bIoFuO4gRUO5+4fg2Vp3hI5EM+ZJ2gsjWIssBJ7aFqXbGkg43xRr8L5O2CCmfGc40YkzsyA9xSeUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPFAC42FDD50.namprd11.prod.outlook.com (2603:10b6:f:fc02::46) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Thu, 3 Jul
 2025 18:27:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 18:27:22 +0000
Message-ID: <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>
Date: Thu, 3 Jul 2025 11:27:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
To: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
 <aF7dt2iQpvuahZil@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aF7dt2iQpvuahZil@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0348.namprd03.prod.outlook.com
 (2603:10b6:303:dc::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPFAC42FDD50:EE_
X-MS-Office365-Filtering-Correlation-Id: bd1c3101-398e-4fbd-c877-08ddba5f401d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V21kKzZmcmNOTFpwVmptdzMrUFRXS25Od3ZqK3U0dVRNQ0ZCRWJSOTh3MzZq?=
 =?utf-8?B?MHR4ZjhOQWJxeVk0ZXAyQUN4eEd1TVp6aWk3ZEN6eFB1d0x1amwyUnZvK2tJ?=
 =?utf-8?B?MVRjZ2R5ZGhSZ2J6V2hnNTVHK3VUcUVSL0t0OGVLZ0VSVW5HZGd3Ky9ldW9l?=
 =?utf-8?B?VHdqRjhXNlpXOW1jRC82MnYydHZoMzI4Nnl3RWc4MmtpUG5VMkZwZW9pOXBa?=
 =?utf-8?B?a1EvTzNMMmtqR2h4aW9QUzhWazRnS1NrRTUyWGo5K0puQjNqamdEenJoNG0v?=
 =?utf-8?B?ZlZPeEppcEI0aFpUaGNYbnl3U3dDWGYyMk1qd1lUdndCTUluZ2V4dVB0NWJX?=
 =?utf-8?B?TWJBaUkvUjlLVHpIRVZBeXllSHFBYkhzbDBPU3ZjTGJSbXhTaUZ6ZjBHTi9p?=
 =?utf-8?B?c2ZNMU9BV0Q2Ky9zbnlKa0lqeUZiOEFGTGlwR0NHMVloZ2dQK05QUVJnMlVL?=
 =?utf-8?B?ZlZmY2gweE15ZGNzZGF1R1hHQkRTbldQSnBHY1pOSGtJeFMvNWJ2aHBTU1pT?=
 =?utf-8?B?RVdtRVo5QUtML2JldlliVU50WGV5ZjRleFZkUDluYmRIWG5nVk1IdEo1ajE3?=
 =?utf-8?B?OExDZ3FjdjZPUlRPOHVYdTFmVFA2RmxZTG5hWWpjeWhONmthek8yVUxDSmF3?=
 =?utf-8?B?Z1hxTFN2dXV0YzNXdksyWkFTWkZQNlFvSG9wS1V4SnQ5U04wM0dXbE41UDVu?=
 =?utf-8?B?V05wc3EwNWQxQ2M3SjNGR2lOcDYrdUM5VTBCdU5xRkVUdGtYUFFPWC9Yajhn?=
 =?utf-8?B?Zkl2aFNYZ2dUTEVMZkFGT3o1RUpUZzZsY0plbkd0MHlIYVNtMXNXazMzYS9W?=
 =?utf-8?B?cGYzK1JUKytnZ205Sk9jQ3lhRFB0STl2blEwb2xPZk9qZEZFakliS1krKzI5?=
 =?utf-8?B?bTJjTWJxWGNFcG9tMlE1cTVHb1UyMmhxcXNOUjlzTVBneWhieTRSY1ozZzZj?=
 =?utf-8?B?ai9Sa3NLZ25UNzloMW1ET2t5aUtPREZkRXMxWkFNV0VJWmtTV0ttVW5CNk9D?=
 =?utf-8?B?U2lEYTJVSkFZbEhjTlRjRVZKczdvNEs1WWxJMCtUZWVIZjNCUng0QVhpZTdY?=
 =?utf-8?B?MlQycnVQTDhJUHd5ZWtkNE1LSnpXVDM2NVJkYmFRcVo1R1BDOUxmTWdFTndq?=
 =?utf-8?B?N3FSMTBBSy9hcEJKaVBFdGwxdmk0NG4xYTI0eUkyYlVjbWZqbGwrelZ2cHdH?=
 =?utf-8?B?SEd3NVZUKytkSU1obUJFSHErTVFHbGd4ZDVRdmZtenVILzUwN0s2Z29IbFoz?=
 =?utf-8?B?Tnk1ekxLQ2grc0NOS1l3VjllUzJoSVF6SGZ3ZmxzcmFlTS9RMFB2VmJrYWdv?=
 =?utf-8?B?VFNQcXAzRnBKSWRvc0JLV0ZhK0Jnb2RFZVJjbURUQjhqQ0U0VHMwcHg3TWNW?=
 =?utf-8?B?UzNNTW12M3ZJblpMLzBua0t3aENobjk2aTFUampQMUlyQ3NjMHNWNWYxeHVo?=
 =?utf-8?B?K0RCVnp3NUhMaFlDcTljMDBwL2p0KzlKMHJhRmRKQ20vNnBmeUxWaHpHeXdT?=
 =?utf-8?B?azh3UzJ6cWFLMnNOSmpUVjJtVU52RFU4OWd2c0x2M0ZudTRCSjg3OE5SVE02?=
 =?utf-8?B?OEM0Z1FSUUlaWEp5WVJSRks3N1AyaUVkZFF5WFhiWE9SaXRGWHBWamt1TGJL?=
 =?utf-8?B?d3VUczVCUnp6TFVhdGJiWFJFWXZpbWVpZk9USVllSllLVTkrc3lrZkRZQUhY?=
 =?utf-8?B?TU10Z0gwM0JmQjA4OURZUkMyWmxDWmlIZkZhbXhoMlRqbGJ1aDZzTC9vZnJG?=
 =?utf-8?B?Q3dvQVlxSEsvKzd5eG90M1kvMEFzMU1xTnoxUmFQM1Z0Zjc5YUJyMkFzTERz?=
 =?utf-8?B?SzBiWEUrekRIMjFabVQ4bHRLTElmZWV2VnlpK0pXR2EzUnBDN1NTV3FsTTN5?=
 =?utf-8?B?QkhDQzdTOWxLV1BIdnZJVk1PeVlvK2hFdjIvU2g5SmVVWWRZd01OUEdIVUNr?=
 =?utf-8?B?QUNKeUcwWkVMZXAxNHcyUXp6QjBuWkNnQjQrTERKMlZBOXVoNzluNEh2Rmxn?=
 =?utf-8?B?aDZUNVV5OTlBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFFNSmRJOHNVbGRqbkp2UnVkZnIyZ3U5UFVmR0o5VWwvQXZuTGkveC9IdEx3?=
 =?utf-8?B?TWx6UTNUbjRMeDVZTFRFeUhNbGlQcUtsRFhHbWYxRjF5b0hHVFRKMUtrR0Vm?=
 =?utf-8?B?YTRmandaOC9TS05XNGtkRFp2czU3OFgyNk8va1ZJYTdzN2NsZTlmRmdDMk4x?=
 =?utf-8?B?OVA2UXFSN2JNcEdrc2l4TmU5ODRYNVdHZ1ZRbkNJRWNBSXg2VWdsaFdIWCtU?=
 =?utf-8?B?YStuVjdSbVhEMUZNWGpxbWVYbDBWUWUwQTBiRTFMTXkyNWoxYnc0aHRFNzRu?=
 =?utf-8?B?bDlzS2dKZTlSekk3b3VGN29TNUNtTDFsdm0wVnp3NWFET3NRZjE4UkhBRytF?=
 =?utf-8?B?b1doL1J2WnF1UXRKL0VMbHNySW9zNEMybnNtd1NMSWhpQ2dJcTVydTN6Qksv?=
 =?utf-8?B?SG1xUDRUMUNQd2pXL1BZeFFyN0FyMmNlVGowKzR2L040a2FXN3B0Mi9pNmxj?=
 =?utf-8?B?cTRCb1oxOVNMcVR1WHdkdVRTOTdKUnIzcVJZc24xblY5TDJRN00rTzYxZlUx?=
 =?utf-8?B?QUJ5emlLMGl6bkV0WW9xNXZVZUhMNkQyTC96ckRXREVIcGR6c0xiTmVsYjht?=
 =?utf-8?B?eHlGbmc4bFVJSlhUZ0NOR2FIM0FUK211emNGbWFiYktpWndNalpFd3ZXUGNH?=
 =?utf-8?B?VVZsZ2xmWWNOOENmZWFDMjUveWRRTWJjVytDbjd6dkhlWmhlZDNaQkNmN1d0?=
 =?utf-8?B?YXlkRXlRRXRNOGdOa0pmQUdETXFLckgvNGlLditseFUxdVJpWTk3UlZjTTJP?=
 =?utf-8?B?OU83cG4wbmRYK1dkTzlMQVVTS0NkRS9oWEV2dlZuRGs2N0RyZStzS0djMHBD?=
 =?utf-8?B?d2dnR20wUFlDY1FkdHZCcXJ2UEtydXBJOXVoaXFxOXpDQmFlWlBFdXJPYk9U?=
 =?utf-8?B?bFdDdEZqUGp6eFVqaVEvTXE1T1ZVQ255Mnp4SzNGU1AvTXV5TlRYMW9aNHor?=
 =?utf-8?B?WE9JM2lVZU5WVFh4SFludzNWTkJ5VWNWZ0lsTVdRSnJmU2ZETzIvdXArN1RZ?=
 =?utf-8?B?eHFaU2NDMlFaSGZIZDZsa1dRcDBhVzgvTmh3cWNVcnBteVdJTzJMdlAvWlli?=
 =?utf-8?B?Mm5sUzJUNXZJc2lZQjBHRi8xZDJzYTArWFprZHJPLzRvU3J5dzZOLzRuSm01?=
 =?utf-8?B?VW53c1RxWFZwSEQ1Mk5IYXpKSzcrYitPUGhPMHp1Ym5QdXUydkN5UG9mb0Rl?=
 =?utf-8?B?RkQvelR3a0ZBR3kyYmJwREkyaU5xTlVrQ1p3UHU0TkVJbklsQ0pRVVo2ZVg0?=
 =?utf-8?B?T2diTTdqeXpvSk0rTWtFa0c5Y0V6RHpJdTZFUnhkbUVmNGx5Q05QeUxKcGZu?=
 =?utf-8?B?TXNtaVlETFZ4SHhmb05FR1MrY21mdWIvNUoycGwzZE9vMUJhQUI2bVFvK0pv?=
 =?utf-8?B?UzNmRThyN2pablI4TWYzUk1McW1OcUlQWmkra2QyRUpaT1UvYWtaVlA1c2tD?=
 =?utf-8?B?aVl4TGtLU2YvYXNzTzVRYmEvUXFpMURKdkhyTUgyRDlvbngyd3oyY0NWRUZU?=
 =?utf-8?B?RkVCTmlVcitVaFZINjJaMVZzb0J0MWpnRlFZbGJPZmh5dWpCaGhLRXp6cVdH?=
 =?utf-8?B?bHMvQ0hlSDhTSldrYjd3K21hcllQRHpEK3lnUnhKTEhvbEZBOFdPa1MzbC9D?=
 =?utf-8?B?UFNGY3BkY3ZJNUxYYXEzWVdLaDFld01RVmFGbzdjTG4zWUJwN3B4dTFyTjZl?=
 =?utf-8?B?djJqQkZRZ0RXcEc0L2VqbUwwLzNsZkdVOFpJOHNvMlRXaDBzTnRneTZWU1BE?=
 =?utf-8?B?UWlaRHpldUlWL1R0dUkyK2VQemFNaFVtMnRRUzU1WjhNdnN4K0x3WWl0ODdO?=
 =?utf-8?B?c2FUKzE4aTcxL0lPYUR2WDlqTTN3R2VGb1VDb1JZMmJLbm0zMGdiK29ZaTRx?=
 =?utf-8?B?MHdOQit5S1cxTVEyV2REZC95ZHAzbXRUMEJsQVI5NlJmZjRBL0tOc1pEdEFV?=
 =?utf-8?B?bU83bFBKSmFodGlTN0pFYmpBaU9pNUtGNkllYndvVE50VEdPUVlhU1dJdDVF?=
 =?utf-8?B?dDJ1eW9OS1A4OUZidnBONXdIN2s0SkFvbW1qaWpZdmFHclZkWG9JZi9JSHlz?=
 =?utf-8?B?NXduRVZLWE9OVnh2MFVQZjNEdytnMVdZNVU3UkJYOFF6ZnJqUWZXcXVMYVh2?=
 =?utf-8?B?L3NNa2NtdmlXNXNaS2lGQk5KM0lXaFFjMTRZNTJiZlg3UjllemhDK2x6MTVp?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1c3101-398e-4fbd-c877-08ddba5f401d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 18:27:22.0299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5haMyq3381m0x6dJlhTFxGEn+NXM4eYscOTvqPAsEdUmZYjRfQuQZBnc1pwcyFiHLhb+05prheAUev/uyfsWedY02NIGuht/9dXqFjp++k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFAC42FDD50
X-OriginatorOrg: intel.com

Hi Tony,

On 6/27/25 11:06 AM, Luck, Tony wrote:
> On Thu, Jun 26, 2025 at 09:49:26AM -0700, Tony Luck wrote:
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 71019b3b54ea..8eb68d2230be 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -512,6 +512,9 @@ config X86_CPU_RESCTRL
>>  	select ARCH_HAS_CPU_RESCTRL
>>  	select RESCTRL_FS
>>  	select RESCTRL_FS_PSEUDO_LOCK
>> +	select X86_PLATFORM_DEVICES
>> +	select INTEL_VSEC
>> +	select INTEL_PMT_TELEMETRY
>>  	help
>>  	  Enable x86 CPU resource control support.
>>  
> 
> The list of dependencies to "select" keeps growing. "lkp"
> just told me that "INTEL_VSEC" depends on "PCI".
> 
> An alternative approach is to just add:
> 
> 	depends on INTEL_PMT_DISCOVERY=y
> 
> instead of all the extra "select" lines.
> 
> Pro: This describes exactly what is needed. The INTEL_PMT_DISCOVERY
> driver must be built-in to the kernel so that resctrl can enumerate the
> telemetry features.

How will this behave on AMD systems?

> 
> Con: "make olddefconfig" will now drop X86_CPU_RESCTRL until the user
> hunts down and enables the chain of dependencies to get RESCTRL turned
> back on again.

Reinette

