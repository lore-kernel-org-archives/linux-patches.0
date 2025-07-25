Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC0F253F35
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486596; cv=fail; b=BFTQ+cJpqokihuw7ahVt4aURuv2lkqPMZLmi3jKhyFfVe8vL2kuLNmbrgT1smiSGlkQrZxidC/4eS4yJNSyjqM+bABupWp65J1hrYiVh7GceNwrl2YtiNZwXbRhauVMyRS2/3aN025eKo3N6lMgPwv+Xe6MiDpiW8u+BKsc0kn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486596; c=relaxed/simple;
	bh=r1bLH5c2j9LMVlwg2Vaa6FMhdD7lMQU7kg3ZhwPjBU4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N69j6+ODPZcj3/IA0SAC9LGJk27Br5TGGpqMNzzoSrPiTpqO5O1grn2q8ReOZJ0/7hjw1BfdynsEoV2EIUzs14D4mFrWZioPbubNa9dvq7Opfp++i2sMBq4z1FSj36uGjisOlZ4Ku4nAoxWJKB6l329Or2z5s18QeH5ma1D1l+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CA1san/H; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CA1san/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486595; x=1785022595;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r1bLH5c2j9LMVlwg2Vaa6FMhdD7lMQU7kg3ZhwPjBU4=;
  b=CA1san/H2h8QVOZHRLBC6xh/+Ro806bWwn2M4mvOuSEQRlTRGSRmlhev
   jBJPECgQFmJrThYfvyraP39J9nVuudvGMH8y3jF5cO5ZdNhL7c7Dxh5bY
   HcAvUPGsi4WjXiEMGNBb+hB8apVA/XTa2NrBKOpRi1EzSO+wDIoWIluQo
   PoEHb2hOXrvMrA4sN0Vm3nRqZmxu12ED4GqieyK5qj3OyssW+8dQJ047z
   n73+YuDM6Sphqvh2QDFJS6BsBteir2kZQSohmYfQOlajyWHQXJrBKFU3g
   lF13VYun/UMp2/5+XmCS11MP5SZ4CQ7Vdmm0Dj8hi8AdtLlc/+npVq9JI
   g==;
X-CSE-ConnectionGUID: onMkKtFdSCysexDTab3byA==
X-CSE-MsgGUID: ZpQOQuO+TBuGF1ctb6urgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55923092"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55923092"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:36:32 -0700
X-CSE-ConnectionGUID: T9+xABM0QD64+m/4XKs9Cw==
X-CSE-MsgGUID: F+uNPIuqSj+AWS+Abw1qIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="166572710"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:36:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:36:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:36:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.58)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:36:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfQ6RwO993ekEECTKbwDdzYj/WO5vUfdmk1HCY0v83VuF9A2S9Y8p1CXyBh6FjNiFOZp/UcnR3ko99baiGKQUxJlzc0zgV1r9eN5Xg5wrMs97C6pjendQ6psDIilJDiEvayq+jJDp7YYLFCxjx7U7OISXENdzJZLc1gJlWJD4Wqw3GHfOT4PzvCVMoXQZOHIH9/uW6/afUTOSEFwHYvdDFT3ELtiFDRGxgJLeCDypw8R/73NQ09MOZg9K8sByCdtkzqm+kV7WHtkDOKR++67dNBEB3bb4l8U++QXHsb2EnSQKA5L1GwVHNQOS2osAXyoeRbVJk/qiYDR6FKCK/O6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zj7mY5JuEAruqdsK3d0cLvSzbJZmchFgiGMDjDxcUrA=;
 b=k2QA12BkczwuSfXbXrphcyAeGgYXml1mpaQ0T/ynLOSa5FeYfpd+71xvqK6H763aPenHuACkaDq+vo10q2I7yD4KkwhgdR0czGvEigsEZ1WdhqayRJwrRmd3WsA0Z/UMnlIVg8hATwUgn02xyfQZGrR3imSY/3Ntb5n5OYtTiEomObr1e94M4PCQFV4qKqh6ywLH44Li/IRi3cTKbzxDCJGQwfvXxvPGZ/BZ1GPo3ZYQgw2b0r1E7lwzrpzvG/cziGsMT7QLXK/2b/2mgpLXCGIghMAPccfu8OBaZb6cFeIJxmB7LOlTGAYsSi+Ff/7mL0Zw38dpYFxeiN1UrMEG9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 23:36:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:36:26 +0000
Message-ID: <bc7340be-9728-4938-9196-8bc48d56c068@intel.com>
Date: Fri, 25 Jul 2025 16:36:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/31] x86,fs/resctrl: Add and initialize rdt_resource
 for package scope core monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0322.namprd03.prod.outlook.com
 (2603:10b6:303:dd::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN6PR11MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: c0831916-0f88-4621-59f7-08ddcbd4126e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RUVqc3gvZFZmMlprclVCZy9laWZzdTNqSkxreDFwcmFBSHdjSExyUERCQ2RR?=
 =?utf-8?B?OEMwMFpPR0hnWlJadnhQamRGZzdNc2hqNSt2WGZYZWZUWXhGTmdsMldETGl4?=
 =?utf-8?B?cllUbWt4Zk9CbGIwUEE5cU1XUnMrN0dJdllYTVFWb0lzbUI2WVZhNFZkR1Zy?=
 =?utf-8?B?MHF3ZFlLWHZSb2hGb1J3SkNhQWg1eWtFMVB4SlpPVzZnQU82WHhLNHRRTUdl?=
 =?utf-8?B?Y1JDaEtOSUNwYjM0empIOFhxL0MzTnl0RkNmM1NHSFEwTUw4UVV4ZS9VM3Vy?=
 =?utf-8?B?Y3VrVFJxTkhUOWhyUWJOeHNIRTBIOEpKclZEN3Uva0wvdlgyWW9jNnNxZjZI?=
 =?utf-8?B?NlpyVnlVZHhkRmtKZXM1cFhxbHYwUHkwK0h3dWk5YUpNdW0vZGM5dm94MU13?=
 =?utf-8?B?cFJJZ25qRmpFdGtLdHo3VGJ2bmVvdVl5eXZMVzlycGRzWXUwQW9rZzVyUVFv?=
 =?utf-8?B?ODJOOExGV3VoRTB6blZuQ2lRbjFRNlJkbXFSUUVCMVNVbGI4NEVnd04vN2c2?=
 =?utf-8?B?cUJ5TFM2eWJ2QThyTG1BMG16NFBDMXplTlI4ZlR2Z2gvWkRwZzZHZzNVTmhU?=
 =?utf-8?B?Q3lpNFdnaVdDMCtFek5Lb0U1a2Yrb3dJVDVKWU82MnZhOHFCVkxMR2VjaHVp?=
 =?utf-8?B?djdkSC9ENXlybnBjeXo0Y1p6QnFjSGowRDhxOG5oV2FPaWs2ZkNZZUw4UHBu?=
 =?utf-8?B?ZVk1MHJqbXYxYXl2UnN2bDBWT3lpa1YzZjcydGpzYnhONjMwd1FhTWlyODBB?=
 =?utf-8?B?N2M0cU1VeFVQWUZvT0dKNkVjb0IwNUY2elRiS0NOcnV5c3EvVlQ5LzQwQ0Er?=
 =?utf-8?B?MUZTVitvckJ2R0pyczM5S1Z5UFRDZk9Rbzl5ZVVySE82Sm5FOUZJZkYzc0Nx?=
 =?utf-8?B?SGxEMmg0MFZwc2xlVytTdkd6dFFCRVd1dXZVNE54c1FvcnBsMGQyTklEOW0r?=
 =?utf-8?B?THpCUG4xS2paS2p1V2FBVDE3bVVRNWo3WFhieXgralJIMU9Qd0t2NTN5bVZj?=
 =?utf-8?B?RFkzd09IVlVEbXE5dEFOS2grbE80RUE0R3F3SDhFUGxYK29qamhybUwwc2xj?=
 =?utf-8?B?YTlxWlVOekliSURxVm5kQmFSVDMxSGJNVDRKcDY2SlRCMnQ4YUdFNlU0WWsy?=
 =?utf-8?B?YjdzZXowdGt4a2hhZU44VEovNHd1RHo0R09CRW5KQXRLbWlwOGdOZjQwNFN2?=
 =?utf-8?B?bGhUbHlKTGJ6cVJPRHNCdVJ5RlliRHEyNDl4T2dvdTRQcjBYU3JRY21iSkZE?=
 =?utf-8?B?Z2YvZW9FbjBVNXZTclJ4Qk01VU9HMW8yNVJrNU02RGwxa3lHUzExM09RRWpP?=
 =?utf-8?B?emJoRTFkbURKSzFubWZTWEMyMUFhbUtXbnNHNGhzOWxzZXRGRWI1WkMyM0c2?=
 =?utf-8?B?c0xxWUVWUVF6YzZBcE5DME8weDlNUlhpWWpqcFU2cDE5blc3MFJSUGRkay80?=
 =?utf-8?B?ZTd1VFBsSkdlQytWZk5lenlSdk4rTmdaNUtpL01jdndOLzVIT2YrdWRkQW5l?=
 =?utf-8?B?MVlXTEJjNHVmL3pPRUUxbXY1NitPcUV4K2JUaFJGMWdGTFI4anU0WEdNMmVm?=
 =?utf-8?B?eG9wdENsd1J6Z1B2OGxaelUvQng0QjJ1Wk1HbDJmV0pDZ3RZU1hHYTdsM0xE?=
 =?utf-8?B?L3hzM0plVUlKbWg4RzVWUy9wTkVqVC94N0k3bDdtdndCcUhESkdIMUJER0V1?=
 =?utf-8?B?Nlh4MytjczFkbk80M2E5NXd1cVZXWHNBWVYyZStHeHkvMlNyTFpkK1E1WGJE?=
 =?utf-8?B?QnVDamR4UzdkOHBaR0k2M2N6VGVNanJMY1E0ODBubTdZbkMyTDZlbWF2akFM?=
 =?utf-8?B?enhERklCS0NPRVU1SlVLWSsyYUdYSVRqbmNiWVNyc2UrZWdqdXB4anZGMW93?=
 =?utf-8?B?eklOaVI3RDZKWndwNGUvS2R3SXVGTkRkbU1tWDdvOHhSZDRMRC93cVF2ZUZG?=
 =?utf-8?Q?cSmzGtUhDCY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RSttTURKRm9hV2ZRZ3RJUW11YlZNZlg1TmV1MWpabTFBcVBzdGxmaXpJY1JS?=
 =?utf-8?B?ZGJCeHc2TEF1WitWK0RaUmVkd1I3VlZIZkZuZjIvK0l6UWc5M3QzY2t6RXVp?=
 =?utf-8?B?NlBSU0ZFcUhUcVh0OWVNQ0JXcjdNaEJSTndwak1TYW5taE54Nm9Xbk16MkdF?=
 =?utf-8?B?cTNnMm9BUFltUUtjQ0c2RHV3RE1zelZCV2lnaGFTYVE0dFNVd25tdTByc0pk?=
 =?utf-8?B?b3A5QTFqOEVhb1RocXVRQ3lXVjkwUVh5YTNZSEJKUytqdXVUZE93SCtnVHVR?=
 =?utf-8?B?b25FWVF5ZTdTQ2c3ZjNZa2dNWHNtMDdIQ3ZVYmdhUVB2cU4zYk1kRW1rcFJH?=
 =?utf-8?B?azJZTGpmUjBjTGtHbFo1Z0V3WjhCQkZwWCtSTkx5bCtRNFNzQ1lBY1hGTFpT?=
 =?utf-8?B?eG00QjNyMENpU3NPUy9RRjRrL0pyTWVncmlJdGczajIzaEd5eHZ0SHFpNHY0?=
 =?utf-8?B?S0ZOQXNmSnNtQXk3eENnK0dGRHQ1SzFocmxRV2xrTVdhQjJtRUF1bW1GUkxi?=
 =?utf-8?B?N2JaMWRmM2RqVmprRHVPYnczY3JhckQwUllHWXdDczljc0dkNitWMjVSdTdx?=
 =?utf-8?B?ZThLdGZhOTd0cFFnSi8wZ3BuaUo2OEU4RldLOEZPSHhEbjNSWmhpZ0ZGaVlB?=
 =?utf-8?B?ZHVCVVM0QWRHeUw5d0hLY00wL2NWaVg0T2lJSlhFaXdhMlFZenRHaEdWRVBr?=
 =?utf-8?B?VWgzWnBDT2hjd3RITmlPYlBkcjkwQlZwVWlxYisvcmVpdmZFaEpNL0RGK3NZ?=
 =?utf-8?B?UTNRQUdCT2hhdWZBRUVLNUlyenBJNjRtR2U2aDcwd3B3M3IvYXJIL0R3ak5t?=
 =?utf-8?B?cjJ5aXAxajFZcTNZSk1aVUs5eGszdHk4SVlxbWlHZ2pVL2xTNzdDNWVJRldi?=
 =?utf-8?B?c1dkZFVKVUtnUWgwZFdRemIySTYyK0VTNGFHNUtaTVExbnBFeEh1Snl1WWt6?=
 =?utf-8?B?ZFU5RytoSG0vUldOVVZPSlBNeUFxNlRwU0V3a1hMZzA0ZXdnL0hFYnZrTnFM?=
 =?utf-8?B?MVdIRHhxVVhZUUJNa0FLT0hBUzgzYXZMOHYrV2dNakFIdDJaSFZ5bVlkbGEr?=
 =?utf-8?B?MlE5V0NSTldQZER2UjY1a3kreDBGdEpVenVnVXhmcjl4OWE5WHVoV0psR3F4?=
 =?utf-8?B?a1hsR1c4LzI5aWdsWnZiWWRqVkcvUzYwS2x2R3E4amxLYUQxUHZpVEZ4d29R?=
 =?utf-8?B?WlBuZlh2MjFndEtmMDlYWWZ6QmJDNmNiSmNUTW1wVWFvL2tZNUdsNnZpVmF6?=
 =?utf-8?B?UWhLbWJBOHU5d2tVUk1OL1BKVFVCbXVZMlhVRjhFWTJjb1lETnhDZHdRRmpz?=
 =?utf-8?B?SmNZRTFWN2VkNFplZi9MM0JiZnd1N3JOcm5ZWUF5Sy9IQnkxM3MvU3BsTnFh?=
 =?utf-8?B?ZFB1M0RWZVpZdElickdWdWhQRkdBbzZTTzVzNW1HdE9UbnU0Zk4zVzVTWXlq?=
 =?utf-8?B?cmFNNzNreXRvYklXb2ZzdUwrR2RuZmd3SVk3MnM3RGVXQ1FsN3BxWGtHSlF4?=
 =?utf-8?B?Y2xBd3FhUm4vMG41NlZKVzdUa3ZuaERoaExJajM5NVI3dzRKTjRYRzNuOEIy?=
 =?utf-8?B?Q0dVbXpCQ3UxdHZQeWZtQjdqcDdhMDBGaytsMWdSdWExazV3Y3c2RnlONDd4?=
 =?utf-8?B?cG0zM3FVNkJwU3Q2YUNaRnAyeG5rWmF1MFYwZEFicUM2bVl0QXpMVko2ZTdl?=
 =?utf-8?B?eVlRKzVtdFVvL2pkRUdUTjVaRmhSTFZUK0FISng1ZUFUREFtN0xmN2J2UC9N?=
 =?utf-8?B?bjhxUkRzUzVSdE5ucjdER2R0TFVjVXJlOFdVb1E0aDJyT1ljek5PQkpRQ3l6?=
 =?utf-8?B?b2p0K3RKZ0FHWDJTVmNacFpPSFFaS1RSWEMxTkhFTFFsQXlRdjJncFRieXNM?=
 =?utf-8?B?YlFPZDdLd2wwNHVVSDl6UnJmRFNTbjZqamViOWN1eldvMTREMG5PR1dydUNt?=
 =?utf-8?B?TkszOVRScWIvMjh3STJpOEE0bjhncisyWXF1cFJZTUlpcTBxQ1E5UFk2RS9h?=
 =?utf-8?B?eUFxanJNNjc5Mk9BMXFaaE5zbnBqZlpxOHJCaytMSnhWY0NLZGRWWjZJQTZR?=
 =?utf-8?B?M0gzS053dXV4Wi9ZTFRrWEJKVXUxVG1xZlFVb2NNc0RPd1A1NDBvV0VOSFl0?=
 =?utf-8?B?VC9TZjh0K3l3U1VWUHFnL0JtTWNRbjZmNTU4NWI2VENyWnM0NWUyc3UxaWdF?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0831916-0f88-4621-59f7-08ddcbd4126e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:36:26.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iBkHHv9Ue2GEsmYp2OFOX3iHwjB6tV4cy5K7S51U0+Pt1tAKuDiKSggDVZ9qtq3KRa+5kqjFJ0ekaVGgfW04HV4SYCWcG/A4ePLxAVr0y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-OriginatorOrg: intel.com

Hi Tony,

In subject, should "core" be dropped?

On 7/11/25 4:53 PM, Tony Luck wrote:
> Add a new PERF_PKG resource and introduce package level scope for
> monitoring these events so that CPU hotplug notifiers can build domains

It is not obvious what "these events" refer to here.

> at the package granularity.
> 
> Use the physical package ID available via topology_physical_package_id()
> to identify the monitoring domains with package level scope.
> 
> This enables user space to use
>  /sys/devices/system/cpu/cpuX/topology/physical_package_id
> to identify the monitoring domain a CPU is associated with.

Above two paragraphs can be merged?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good.

Reinette

