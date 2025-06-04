Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84F323815F
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749009207; cv=fail; b=UzaUC57AwD6LMLXvVaTSu3r1Fwwm4dIZgDce0jauAFmZdUgVWkzfNCFH+TfKL8aKABnaXJSOdxwjomqiuYw8Szz6RPIPJPbhODwxK2MY0xB6KfiYptklKyDK2P0eU3WYDHi//cIbvp3DG6EXMEoiv+jVp/VBLinrf9nHBJ1+mA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749009207; c=relaxed/simple;
	bh=kW8328tvmHST14njkn8KuRi6gJNDFYWAC2hllogzW4M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nGrygWruzk69TEDgdoVjJ44mA3TCAtmePBTrOs7oLWfs7QluOkK4BHsuNgiZcISTkLYFS7JgSonOta5HWAcmV2lxsN+Up59LZ7VF4kCm05b4hzM3gVNFlwWKV0Biv5kDegkmBJ6YlVyh6mmLzuOAsEo5+CZ5otxDPGMn1g/R+Mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iYgOKnWZ; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iYgOKnWZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749009206; x=1780545206;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kW8328tvmHST14njkn8KuRi6gJNDFYWAC2hllogzW4M=;
  b=iYgOKnWZXUIHkKuMBtJzOvnJw+HcANkYFsVOWIrXIO71lpzs/6wOsxO8
   9viK7fU28mC2XwvDxYyd+1W0x6V7DZ2RSTwK5sMJ6060j/vguVgrYBWLY
   1yRqjYBAZ502FjNRPJTUFMn3TfHFAsmS8qpbB2ipVixY+GSFNlZZNPOOG
   7U7+UA4PEq5mhcUSTyyH5jtEP5valt7g9+yOFp0FMIGhlKFnPTduCB7qT
   pH5c1gfnFjvf6bAjhVNIv3W0lcCvcy+2gPYsapdswImP5+kDLbecwBu1s
   ufElpPtjLkx8zApttAsfnS5ymGKYyjcaPfONVW9x9XHvtq/MEbIFjDAYe
   w==;
X-CSE-ConnectionGUID: A6hNJ8t8SSGK9Yzv6EBzhw==
X-CSE-MsgGUID: 0fOeB8IhRjuEoidPWlLxjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61735598"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61735598"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:53:22 -0700
X-CSE-ConnectionGUID: 8LubCa84QFODVsGE4t3R8g==
X-CSE-MsgGUID: actQZ0EATxu6E9ND2d/Uyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="145026935"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:53:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:53:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:53:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.81)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWTGOb8jL0VZrudTE4rA6xLCTdxB89o2aYmvOCKzbA2tEaVPZelWV2NMOTLBnokrlciYPJHA2qcpoUqSeisn8ri05ioTebEjGE7wr6MFuNhGZszJFFBCdp7p9gJBFqYiHX5iIR9OVug3cazUWUMUK6J0eZDuqb33VCfs027DMMziLLjA9UhmwT4gcw6KXXepphbXwOMizH8kQF09LhqjYdsPR6/IwaPp0sIEcKQEgP5VYeDPMQrZaTxBi9OUzSKMM0DrERHbMqpVlQzs6cpzUYiclxXURgCdV69vH/JG3U3+v3FDz5LPhlsvF1GNFMhsMFT9WkP6OjtHbTNrZRM7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjW0/4q6WrIvOm4TSDEookhJKG3grKceyUnoaXkIm3M=;
 b=kgEwsYWPKO227s98ziJaWOS2WHGB99wIF+gztBhIofLaJOhOJtO/xeynT1d39zuk5leqCVDWFwhWeLPoeCZpjddQNlO0o1WSlJ1bMmv01Vk0HDoerLGroGqWkxyoOM7uUoqHzN4oZRGWe0feo7hRV6iJAZ/MkbutCEmdbtmcvUAVyBYaxKOImRBJH6/mDE+FAl+g6j7o57djmuV8/j8jpuA5iix6G8OhnCGngTEoW33bLjAnh3ei3tuEq//i0Qq+FsWelCzZe1Yp8bnv6Apw7SaePVFQq0uz2qOqGPOXbMkAi8VSsDyxENPwdzp0ISvc57i9pPL/SsP9y8igmwJqCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 4 Jun
 2025 03:53:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:53:14 +0000
Message-ID: <2de48392-9517-4859-a932-d54aa6580e1a@intel.com>
Date: Tue, 3 Jun 2025 20:53:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/29] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250521225049.132551-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:a03:333::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 958011c6-36ca-4363-3967-08dda31b54dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Wk5YSkNHSFo4ZGxJRjF2cENGUXpQYzB0Nmk3eGM0SnFJTkREMHV1Zlp6c3lV?=
 =?utf-8?B?M3FGK2JCeGRGSGcrTGt2Q0tzRU1kWDlCOFBBa0hoZ25reEtoWC9aZVdRZHlQ?=
 =?utf-8?B?cnVER1k1djZBTmFTbUwyWGwvNVNjWndxc3ArcnFlS2JxZzRURWQwaDhSaU1j?=
 =?utf-8?B?SDh3b25ScEVRTHpLKzJNZDJWL1RwYkdOakxDOHVJdUR3R2hyamRmSHMxVWpR?=
 =?utf-8?B?ZERTekpQejYzMlQxTnBoSkNXN25XejB2YWlYbm9ycU1KQlNGWnpiZER5R3E0?=
 =?utf-8?B?WUl3d3RGTEw0c0VEMXNmenR5M0dyL2UxYU9PdW5sbk5PdHBJZUZlcitMd3ZT?=
 =?utf-8?B?T0tBNzZCVkxPYkNuczc2dVhvdVd3ZkUwMEE0SXp5VEQrNlpKNyt0eGlIdnF4?=
 =?utf-8?B?VCt4RGFtekRKS0tHcHdhelNIQi9FTGhZb2hLY0czY2VTb2NTTTlTUldkZHps?=
 =?utf-8?B?cFN4VFRYN2k5dU53QVV2MnZhNmhMTjVHZFN3aXh0bmNoSjcvRzh3bjBLWGgw?=
 =?utf-8?B?c3BVelR4RFNCcTdyaENuZUxXcUtvMTJTMytmZFVUUDlzZTJFU245ME93YTFk?=
 =?utf-8?B?Wm1yNUNadE1OTkVlYkxDd3IvQ1Fyb2JrUFhkRXhrVkYwN2FQMmxKOGpJbEVk?=
 =?utf-8?B?MjV5UUdFa1V0UXpIZ2dQZ0ZaNlMzVHprRmJCay9YaTlkM1A5Mk9HdkZxZ3Br?=
 =?utf-8?B?bTAyQ003WWhPM2crMWh1L09YdFhmMmNpUlB6RGE2d0x5NGxzbVd2VjRrQ3Rl?=
 =?utf-8?B?S3VMNXQ3UlNONzlaWENNMldudUJuUkE2U3ZMNVVYMVptaksvbndEcjJ1eXda?=
 =?utf-8?B?bEN0K1BwalFFNGJrYkQ4UVJFa2M3QU1qeW05bE83WHI0Y0ppWjFjdmpacDJT?=
 =?utf-8?B?akQyWWluZThvREdHN1JxV09vczA1Yy9hZ0JqSFM5NC8zb2pBMHIyeGlVUTQ5?=
 =?utf-8?B?OWx6QkZTell4RmZsNk45WTNyNy82V1Rsc2hhZC9rSCtRNFc0YnN2VUZldmJa?=
 =?utf-8?B?VVArbEZFTERjanlYOVkwcVJyb1pGeGNoWVRGMVhEK3NKeEIwRGduRHA5amxn?=
 =?utf-8?B?cWFycHJVMEd3ckhSZ3hFOVE2b2wxaWhUM2w2YmRPUXJqUVJzM3V0OTlwa3dl?=
 =?utf-8?B?dVdyR3FtTDUyRDFkeGpSOWZIbDBpU3V2a0F2bTVRRHFTaVc3ZkRaZnRrU252?=
 =?utf-8?B?Tlc4UkRHcU80Z25lZFFtYVZlTVExZWs0NUlFRWNzbkJ1KzR6ei9POFBPYlBj?=
 =?utf-8?B?c2pPM01lRStzL2hlSUFqTkRpYzA3NTR1Q1hnbWhJbkNIQ0wvNXY0bTVrUk40?=
 =?utf-8?B?ZTRSY25Zcnp4OG5oUEVkdFByYko2OGpSSmlYaU5RYXRQMFFVTFMvTlN5Ykto?=
 =?utf-8?B?L3g5R2ZMRW5nMHlha2t4aHVLcFMyRkdXallWNDdPUGFEUEcyUUZjc1pjQmN4?=
 =?utf-8?B?TkhOQlkzbXZkZ0h0S2I1WmRKU0l1VnFobFV0b3F3NEVxWTdCYkN4WFlnTmdH?=
 =?utf-8?B?cFhJSVdwTitoOUZXZGRSdW5xTzc4Y1dKN1NEbnVlWGZ0MmFkYVJsTFhsUFky?=
 =?utf-8?B?MGIvcGJUYktVYVBmeTJrNHRhK3BBSXNhV0ltaTVSUDA0U2dVRjVNVlcvdm11?=
 =?utf-8?B?KzFoMys4Zk9yNlFQN2xxTWFwWFp0NS9TZmV1TUQybTdGcXlZdng4UGk1dzFk?=
 =?utf-8?B?b1hidDZvYlBZbklXSlpNckRNbjBDSUlibGxSWGlpdjJSaGhpT01ja2JwZGI2?=
 =?utf-8?B?VWgvV0dESEdLV2ppKzl3c3FscUR6UkFYUG16U0pUdGpaZGVBMTJ2T0xRek5u?=
 =?utf-8?B?UkJrWHN2L0xnWUhxbmJ3eHhKd1N1OGdHVzJuYWYyeit0VTk0SldxQTdRVHJW?=
 =?utf-8?B?K1V1Nm1NR3BJcHU4UEhRVC9GUVlGdldFZkxKOXpvZUM3NkFXdmoxTitiTFNN?=
 =?utf-8?B?QVZmajk2WTBvTTNmLzl0RzhoNjlLL3ZkYjNrbjBGV2twdjdTeWZOSzFyTEQx?=
 =?utf-8?B?NllUZUF1VjF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjR2Znk3Z1BGRGxBZ0xmWkcrbWdrWll5TDQ1UmV0cEpKdFZqZ1ZzbXVsZFlx?=
 =?utf-8?B?REgxeC83dlAweTBQVi9LZ0FjU1ZKeG9KYy8zanZsekJPS2pJYnMvNFRGdkl2?=
 =?utf-8?B?UG54bFJhdG4rcmxzQURwWm5VL3JJMzRhT0lkQytuUzRzcWlsYThIQjBOclFp?=
 =?utf-8?B?TU9yYVk4Ym50aGxTMWxqTlZPUk5UaW5BY1ZJbnNESmpRdXVsc01FeVRuMDhj?=
 =?utf-8?B?THV5anpYMUU3dTVmVXFQR09tNjdLZ3V6TjJVVXd5Tm1GVU5wcXhiN1EzZlh1?=
 =?utf-8?B?UDhTZ2hoR3I5dEdJOTdreFNkcTNDV2VpSmV5NXVydThEUVoyRDU0ZTJORjBa?=
 =?utf-8?B?S3pOc3F5bDNJRk5NMnY0NHo3V2l2UnpreFNkUDlPTllNZFl3R2o1MlJUUTQ4?=
 =?utf-8?B?eDdVdm9zNmx3eXFYMWVHR3lBcXA5WjF5MjBjVUE4WkZrTWF4ZndYbkJnSkUr?=
 =?utf-8?B?RSt6NzlTc1hBTFNOUW1hbVljVnhGZmUzUjJMQ2JWb1pPR3Zkb0ZHai9YWTVP?=
 =?utf-8?B?eUdkVUxFeXhpdTNieWcySXlTMHZKMVltWjNRU3pxZm44MlFEQlpRV3ZGajZy?=
 =?utf-8?B?S05WT0hCVnVDM1VPUTc2dHgveFNUZVU2RnZkaGVBWlluT3JnKzNMbmYvYnc5?=
 =?utf-8?B?STNoK0dXZFNncS95YzBQSXlCNVBKMEVPQjJGVlZ6TFlmN1VUbTB6blZWbW1u?=
 =?utf-8?B?eUR4b0dNa2dIenJEaVZLd1ZlQWc3QVpZcWt6NTVMYnJlaWo5aWJtSEE0OUxp?=
 =?utf-8?B?RFZKZUJnMWdUV0NvaWs2aUFQVjE5RnkwQUg3YWVWeE13bXlNb2lVZU42SG9B?=
 =?utf-8?B?bmNnT0F2aEtneDlsZjl1MU1Hem9GclpESXRjSWNpOFdTcDVkd2FsQVZDaWZD?=
 =?utf-8?B?S2dDWWZ6SlY1cFZhcnVyQ2VjaVZGY0h4RU1pNlNOR1BodnloTS9vUmdhT0Vl?=
 =?utf-8?B?bENPeEFIS1JRMHRoWkk2WEE5U3NPUHYxMmdSQ0h1a1J1Qjc4RkZPZGhqSVY2?=
 =?utf-8?B?TnRhUGxvQzZ6WGF1T05zS09BamRpZ1pyUk94SStmVTlmZllhY2U3VEF0UDZ0?=
 =?utf-8?B?NFk1cDJrV0NzY3VaSDhJU1B4dFJzcW1CdVhoOTdmTkZnZDdwUVhVZGEzVE9D?=
 =?utf-8?B?ekprSkEycGxxRGRFYktOcThXT04rVklmM0tNWmpaZUk3cUFOMW9adXlBNWIw?=
 =?utf-8?B?Mm9uQlFtRFAxSWhWUmFLUEhCM3JFUy90RS9rUjB6NU8zdE40UkVtUThXMWNY?=
 =?utf-8?B?ZFI4N2dkYzdyOEc4ZzVGWWlPbWhQeTM0a1pTUTFIUVBuYmZ0YjcyUGJQRWxv?=
 =?utf-8?B?L3UwVytqZktKVEFSS2t3ZnNKejFkQ2h4TloxZHpkN2FCSzg2T05qMEVqSzhI?=
 =?utf-8?B?eWVSemJHY2hiYzJNQi9TblY3NTBzVXBNVCtsT0lTOTlNVW5uWFIvTmk2czZF?=
 =?utf-8?B?MkUyck8waEhySnlXaVhIanZWQUlzczR3VU9KZ1NoeUxTUWZ6bzFpLzBCeWVP?=
 =?utf-8?B?QXdlbVV0cmx3dFJIcGpwZFZZMTVabGFabnVMWm1JTWtqQ1pCMWVib0lORkRw?=
 =?utf-8?B?WmhLSWZzTEZYUUtSbVovNUx4VjFWUDdzdXFValZwS3YxdnNHVTdsZE1jaS9E?=
 =?utf-8?B?bElvZmNaa0JMRU01R05CdDJPSy9aK0Mvc1QwbU5nVGhDUTF3WjFmZldva2Rs?=
 =?utf-8?B?dmorSzladFdSQjBIRnkyMEQ0bGNYcWo2bWFKL0NsVk1uT3pBMFV0MlRoUGUw?=
 =?utf-8?B?Zzh5MTZNSnFPUjd4YVZwcXRLdHdaWmlxWmJlR2kzc0dGSDgwZndlSS80bS9t?=
 =?utf-8?B?M1c3SjM2S1d0M2ZTVEZpYnFZems3RC9aSmNBNERUUVBaR3ZDV1Y4N2lYN29G?=
 =?utf-8?B?Y3hDeG10TDF1ZEhIWWdycjRySVBMdklpOE1NL2Vtd2VjOHFPWm9oMzZtcnZi?=
 =?utf-8?B?NWR5ZGpocGhKZUZ5NlF2UDlhNDdiUFpaM1ZmMzdQalFRZ2JQK0liNUxydi81?=
 =?utf-8?B?MTA4WnN5VGU1QitzNzFydk8vNWp2d3FuanE1OWs2UFZ4c01qTnFxZi9Ic2N2?=
 =?utf-8?B?TWlSYldTV2FnSi9KRisvd0cvbmx2Y0MyOUlRcEFwcS9USG5hRWhycm9Jcll5?=
 =?utf-8?B?dXRDblkzL1p0LytTTnQ3S3Bkd1h0OGRRY2FObVJFdzNFaStqSGdpL0RqVlRF?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 958011c6-36ca-4363-3967-08dda31b54dd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:53:14.3001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/wV+J+V8GM+0bR5BZO9I8dPeCT/2HKudB633lVKH3kf68mtC7IUm75OZjPGnSCgRzKMnMumZK3ApfrOmJjbuIAI1dF8h6fgfLa+rUz1bgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Hardware has one or more telemetry event aggregators per package
> for each group of telemetry events. Each aggregator provides access
> to event counts in an array of 64-bit values in MMIO space. There
> is a "guid" (in this case a unique 32-bit integer) which refers to
> an XML file published in the https://github.com/intel/Intel-PMT
> that provides all the details about each aggregator.
> 
> The XML files provide the following information:
> 1) Which telemetry events are included in the group for this aggregator.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for this aggregator.
> 
> There is an INTEL_PMT_DISCOVERY driver that enumerate all aggregators
> on the system with intel_pmt_get_regions_by_feature(). Call this for
> each pmt_feature_id that indicates per-RMID telemetry.
> 
> Save the returned pmt_feature_group pointers with guids that are known
> to resctrl for use at run time.
> 
> Those pointers are returned to the INTEL_PMT_DISCOVERY driver at
> resctrl_arch_exit() time.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   3 +
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 129 ++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  4 files changed, 138 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 02c9e7d163dc..2b2d4b5a4643 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -167,4 +167,7 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index ce4885c751e4..64ce561e77a0 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -727,6 +727,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1079,6 +1082,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..df73b9476c4d
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/resctrl.h>
> +
> +/* Temporary - delete from final version */
> +#include "fake_intel_aet_features.h"
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			within the OOBMSM driver that contains data for all
> + *			telemetry regions.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields used by this code. */

As opposed to data fields _not_ used by this code?

> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_event_groups[] = {
> +	&energy_0x26696143,
> +	&perf_0x26557651,
> +};
> +
> +#define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
> +
> +/* Stub for now */
> +static int configure_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return -EINVAL;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> +	if (!IS_ERR_OR_NULL(_T))					\
> +		intel_pmt_put_feature_group(_T))
> +

Line continuations are not necessary (checkpatch.pl)

> +/*
> + * Make a request to the INTEL_PMT_DISCOVERY driver for the
> + * pmt_feature_group for a specific feature. If there is
> + * one the returned structure has an array of telemetry_region
> + * structures. Each describes one telemetry aggregator.
> + * Try to configure any with a known matching guid.
> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	bool ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +

What is the chance of p being valid here but there are no valid aggregators
for this system? (more below)

> +	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
> +		for (int i = 0; i < p->count; i++) {
> +			if ((*peg)->guid == p->regions[i].guid) {

At first this loop looks wrong since it seems to skip some aggregators by only running
configure_events() on the first aggregator found. After digging to understand what this does
it looks like unnecessary duplication to loop through aggregators here to determine if
configure_events() should be called and then to loop through aggregators again
within configure_events(). This is not obvious in this patch but comparing this
to what is coming in patch #18 I wonder if this cannot just be:

	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
		ret = configure_events(*peg, p);
		if (!ret) {
			(*peg)->pfg = no_free_ptr(p);
			return true;
		}
	}

In turn, configure_events() can contain:

	for (int i = 0; i < p->count; i++) {                                    
		tr = &p->regions[i];                                            
		if (skip_this_region(tr, e))                                    
			continue;                                               
		if (!pkgcounts) {
			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
			if (!pkgcounts)
				return -ENOMEM;
		}
		pkgcounts[tr->plat_info.package_id]++;                          
	}                                      

	if (!pkgcounts)
		return -ENODEV; /* TBD error code */
                                                               



> +				ret = configure_events(*peg, p);
> +				if (!ret) {
> +					(*peg)->pfg = no_free_ptr(p);
> +					return true;
> +				}
> +				break;
> +			}
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	struct event_group **peg;
> +
> +	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
> +		if ((*peg)->pfg) {
> +			intel_pmt_put_feature_group((*peg)->pfg);
> +			(*peg)->pfg = NULL;
> +		}
> +	}
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index cf4fac58d068..cca23f06d15d 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> +obj-$(CONFIG_X86_CPU_RESCTRL)		+= intel_aet.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= fake_intel_aet_features.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  

Reinette
