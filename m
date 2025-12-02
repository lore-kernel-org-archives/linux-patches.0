Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CA463CF
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691346; cv=fail; b=L7uucYAqr8eZbapEcbMkH+FFNjIFREQ04aaF8TKznzNtNGufGyYE4FE1haTLbS4ves4CcxGf5Wqqv/Db6jCpUIqdgaFzYNmBy4yF6t2FN1NG8/nKiIXLHO/dNBdR49kvzobREfoDtrz+v7MdK9wSfAvM3B9YluecfSOTLt7xN94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691346; c=relaxed/simple;
	bh=hS8uWmMWXw4McUEB5eyoabU+CRomd2uO+H7KJ3dnL1A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WwWMaB2tee1sq3tox0u1b+IVNimaO16weg3Orn4KsTI7M5PqiFDu8i+LGKSU5p/wtLRC1VKnxOnerTdkKEgQOiZEbP5+WtH6iJNKJ/T4Zg+45/3OW7Y0rvZ4fNnheje+I9+wcqiTELLBNjn4W41HSTq1LvgTXJ7f1KDIrmAY7Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Saij40Mb; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Saij40Mb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691345; x=1796227345;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hS8uWmMWXw4McUEB5eyoabU+CRomd2uO+H7KJ3dnL1A=;
  b=Saij40MbRfmXmzBmIUz5q1OPoHt4ujdggOxyeKlCOFApqZ+Xty1Om96w
   DeQZVvY3iFpmOvChb9xwOnomA+T48JoIdpwyQIeLk83Yz1EV/inWrgyQY
   GybncT27lNpnxth11EVwS/P+3ZwJW10jqAEn7EgdM+rv+Iyi9s3SoRIxv
   ALY2lQtxH2C9V+LqoBHOwkyOB7ko0iA6JFkTUifTHyc4N0W8U6M3lDP0z
   AaWFCiq6Vn8acJ9MkRYmxfi/iAWxZQbh5k2g2CzDevthk5GM32yKaqQRj
   537UDke9fYoB9pl1hfkjof58J8zUprkUXa5EBtcmpLniyVEawWn6GX80K
   g==;
X-CSE-ConnectionGUID: sTw2qHwoRtqQD+ZvlydWSw==
X-CSE-MsgGUID: dd+O3RTJQoCjHGZWs3vRRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="70521785"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="70521785"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:02:00 -0800
X-CSE-ConnectionGUID: mWqA1QBZQAGgclZp0a5hxw==
X-CSE-MsgGUID: 1FnfiMdNTHO5Qau036RfKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="193713830"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:01:59 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:01:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:01:59 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.41) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:01:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ScPdVYS1SM8oo7BKTpVj+oJhLEOPyx03Jgb8gftcwTlqVeBkxqFlBlv0tdKx9x1yp7YDXM1GUEtCH+bggKT5G/5IWhD3ioajaaABLin80G4oVqYvpo+7Ri43r1Uu2yxgy2RlfAshwmizTOKlF+/Wag4BAOzBAUGRP2+jwmcgzxxtzRuA4ChBYUUR9C5ZrkAmupBiMltJcFf+ISL5yiYkUqnA+SXheEEDsmek5FO8GgBJY27OinYCW67s12vOzNvE2csiVS5QKgvMw0F6EJbmx0ZghQaFgm1HFp4dUGNsfHEu+wEr269DvJVH9go/EMHcGuTNffPMgPzr5RYHNTVd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zQwwZXl8ouu3HpIWWOO2Jy4RRqb/wPAlzMF+xGy2Z8=;
 b=qTCSNBDjm2D0EOeEpzGl3/lmR78Xxyoop/4Gwy/RMZN8B9wwEy72MiaDmGXpVWc68KgYKJ2V+nRtMXzgxhD2MFbZEbtkpkYIZ/F0QAdNBdJTRLe/ymuoTZEdxFWbNx9l6Nz2wp0syB6ILc+FDrGZX9U9TLx3llRwsf7hOYy6UYvQTA+XV5grg/uEkB43cthNBdK1D50KQ/B1JmVRzLBUvjikkp+EPIPmVtEaFbpzG3cm/eajuqN2yHGZFdhuWe6RUjruu2vdvVzkSWY0EyRdfEI0yR5BVoqnCIFpNHcO3gUhhZQx/+ssEy3wSIAMNAZ374qb3jpXrlw+Dx9+zOnLSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF4EB9556A6.namprd11.prod.outlook.com (2603:10b6:518:1::d1f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:01:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:01:53 +0000
Message-ID: <b4fa1bd2-70fd-4450-a3f5-e3edf38d2b53@intel.com>
Date: Tue, 2 Dec 2025 08:01:51 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/32] x86,fs/resctrl: Refactor domain create/remove
 using struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0335.namprd04.prod.outlook.com
 (2603:10b6:303:8a::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF4EB9556A6:EE_
X-MS-Office365-Filtering-Correlation-Id: e27e122e-36b7-4ff6-73ac-08de31bc1ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TUtIaWpTV1BlQncwUDZleEZpWmJzVXIzRHpTSkJYTlo3TE95SThuMzdXUjFC?=
 =?utf-8?B?UWlnUTFsSnRUSUVodzBrcnFVTWNBZnFYbEh0UEdiR0g0S3BndDNvTXM1NDFL?=
 =?utf-8?B?ZkYvb0s4bDA5T2Y3V3lGMWdkUlFRbGpRbGEwaTdJUGhlRGdJNEhyYk9QczQr?=
 =?utf-8?B?emVITXVuekpwbWJ4Z2hJOXdMdnJjNkJhZ2hraHUydDI3SFp6eVFqUG5HZ3lB?=
 =?utf-8?B?TWs4OVZFUVF6VDV5aS9yNnIybkNGMnR1MU9PaENQZzlLNTJlQmxTdW82Ky9C?=
 =?utf-8?B?ci80UmdOVlFma1lBd2RmWFdoSi9Nc29sek5ibDFlVCtadHcwa1FKajBCb3Va?=
 =?utf-8?B?dDRKd1Z3bTdiMzFldSs2VFB2eStGSkMreHNQVGRXc3l2WTQ4TzJpdC90NUow?=
 =?utf-8?B?MWZFRGxmYjVTUUt6TnFHWm51MFQyMEY4eWlkMlNpd2JpVHBhSzJPT04wTTlt?=
 =?utf-8?B?cmpaODFJNTQyQXJrbS9UdTdsYUxFa3VvSEJxV3JzQVRPNS82dUk3Rm1DVGFq?=
 =?utf-8?B?amFsQkNVZjl2K3BtK3ZldUV3ZzBoYlJ1YXVLdERSYkRXZ0hWV3V4c0cyNGJh?=
 =?utf-8?B?WjgvTVlMbE9weHNxRWxGSVNidmgyTU9zcXNteW9uMjQvNWR1V2JUWWdYMFZ6?=
 =?utf-8?B?U2didEpPK2JEUlRaVTlNVVlNRFBCTUFkbEQyUmlTa3hWNk1MSXVOa0JCWUFj?=
 =?utf-8?B?a29nR3dyeEMyUkNQTzJPSC85UUkzdStmK2Iwbmo3RjRlWlZKRTBqOFFLaDVi?=
 =?utf-8?B?UGdIOHFBQlB3U2xuRTYyN25oMkJvMkVYZ0lPVFRENUJKdkJOWlR5MzEzQ1FI?=
 =?utf-8?B?WjV5Q0srRytHNUU2NFVjMHB3TTk2MjFwc1BGOHI0Y0VzUnovRnNyczhTdkJi?=
 =?utf-8?B?TjI1S1N4TmYvaVE4azdXQlI2dDJNU0hNeUMrNmxNejdCcmhwM1NsYk80WDJm?=
 =?utf-8?B?d3BOZW9UMU0zY3JSdVRCRExVOGgvanNMR20vb3JINCt0bWRHQnMrci9KWHdR?=
 =?utf-8?B?Z0paQUJSbjh2dlhpbzZpUXRDL1lsRk5iMUJMZXlXV0R4SVZnS2Q2LzRONjhO?=
 =?utf-8?B?VzFOanZINnBqL0tqLzhQVHQ2NzRFMUtLQmJnYkJQeURmQ0FxeXdGT0djZkJu?=
 =?utf-8?B?dEVyVE5Xd3J5ZVJPT0R3WFhCaTlscHdqS3VQY01sZHBMLzgyVzF5aUw2TXVH?=
 =?utf-8?B?NWQ1T1FMUzY0UDVhcFNGd3lRNjF1ejJ4blBsZkJnS3hyNmRUV2NXS09sZXRz?=
 =?utf-8?B?L2RrdkZHWXY5NTd2d09MMUU5eGdOb3FDZjhNZC8xcmF1WHlTeFZnWTRBMS9Z?=
 =?utf-8?B?eitDcW9LZGdYYVJIUDI2YU9TMERBNnhTbURjbkd5OWtIVVNUNisxYjVDVUpP?=
 =?utf-8?B?ODJIQW1GQytXbjdoUzBuOFgyRCtvMmZsSUhUTktqZ2dLYmNpV2hZSExEQnF4?=
 =?utf-8?B?TmYzc1QvZzU2cDZLbXZaU01lRjFLL0dKdGlydTA4R2owczJCYjErTXh6Vi9E?=
 =?utf-8?B?LzBLNHFJK0xMRWtKK25lbyswSkx3ZXRtbzJob0tCRWIrTTZ6V2pzZTZVOXBh?=
 =?utf-8?B?QjkzbXJNaGRhN3NYUU1Kbi9RNXpjeVo0SjdiMllnN0p2UWpzK1lNV25wNUpS?=
 =?utf-8?B?VFRiN1RHdjVqcUNYeEc4ZVU5SmErY0NxWUJhdHV1U0JJTXYweTM4ekdRbW95?=
 =?utf-8?B?TGt4WFFlcHV6SVhEejlocDg2bUhTMmtpdGNpdGtqait6bGFlQXN4Rms3M2ZQ?=
 =?utf-8?B?OC9pTmNWRi9KazNldncyUnBsbmdsbE5iZ1EyTmc5NDBXNXRMUUY1MEVUZ3BT?=
 =?utf-8?B?Yk96RllTVmt0M05iemlVeS9KYkdoYkZ3eUIrVk5uT2NONzhqd2hrZVJKM3lJ?=
 =?utf-8?B?SXJMbHFQcUxQSis1dGhYNFVjUlRRKzd3ajRhaDM0MEFqYjdFZ0NvR3RLOFNh?=
 =?utf-8?Q?BZn506UgOWdNJl7W9ARdoTpvrJPNI31t?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGh2VDdQV2FWcFNnVm5UcE41Z28yTnhzYnZ2d2ZGdm5DSlkzY2hkVnlBT2Js?=
 =?utf-8?B?dW5vN1RuYWlCckVTelRHcEtqUGJ4R1lxWEpYTCtBQzI3a2o2YktVWi9sSGFY?=
 =?utf-8?B?N0lqbEE5anA5RHR5RmVPaEZjVHJ4S3FWeERYVzdZVmZ3YktNUWJZdFpveWVj?=
 =?utf-8?B?aXAvb0ZBS0ZmWElPcy91emFnMHVYc3FxRFlDSElUOWNhRHVnYW5GS0hhOXVH?=
 =?utf-8?B?SjZTaFc4NEQxVFAwaE1yS0hQRHpNTkhXTlRyN0V2WEhiUlh4M3lSdmJNYlQw?=
 =?utf-8?B?SXU5c1ZMTURHS3Y1anoxRURWS3Q2K08xekdXRENhR2x6L2N5RENKOHkvZmtH?=
 =?utf-8?B?cUM3L1F0YzZkTGJvcWFQT0ZUL3dhUDlwUSsxZGFzSlUwQmNtalBtMlBtRWY2?=
 =?utf-8?B?MS9aVGRNWW92ZnZIeE55dmZ5UU1Eclp1c1hJM1o2TUdzUU5zUXBqWHE4WXM0?=
 =?utf-8?B?TDc3YTEzUytrZmJTOFd2d253UzVaaGtQSTZ2RFhSaGJXT3NaWkNwZnV6M2Q0?=
 =?utf-8?B?WURleDVBM0FJeGJOS0p6VjJpMXFRQ3F5bG1GSUZBNDRLSmQzTEhCWk54STQ3?=
 =?utf-8?B?MmlJY1hOaG1RbWE5eWEva0R5YllQWnpsOHdTSmtlczBBL2d0VGtZbmRyeUgw?=
 =?utf-8?B?QUlLbkFiVUg2Mjl4dmJpU1RsdnF2WUxsamtLUUtpcm1wM1U1L2pRWkR3SUIy?=
 =?utf-8?B?QkR4am1IeGVPMENLcVpsY3VwYlM0ckhIbS80OGtBaDdIR0dpN3QyVDNXUDJn?=
 =?utf-8?B?MVA4cHU1NE14eGdITGtFZThCcDFXUVJMcUl1dXlnYVE5S2R1L205dXBFVlpI?=
 =?utf-8?B?RlJDWUF3S2FSc2NnUXI4b3BtTXpVbmQ2aWxuUlh4Sy9oSkIwQU8zZ1EwYlFx?=
 =?utf-8?B?NTNJK3AxenIvbFBnR3l0eVJlY3czcmZsc2c1cllla3hyT1haQ3I1ejVhZlVW?=
 =?utf-8?B?UTBLcjhhNEpVQjE1UlpUWTRVVEZzdVpxZzZ5MmM3NWZ4RW1kdzUvcHhvRjdz?=
 =?utf-8?B?bGwrbXY5QWpyR1lEdjNnTmxTTTc3YnY2eC9WY0phMmxPc25FSHU0UmtTc245?=
 =?utf-8?B?aXRPNGlweDJZbWN2SHFkanZhM0NCZ1BRTURIak5FeDFEZGpSd3d1QnJQYk1w?=
 =?utf-8?B?Y2NNSHpIYlRjYVVzdnFiSHdpZ1FoUUIweTVNVTVpUTJ2VGh5cTBBMUJwM1Vi?=
 =?utf-8?B?bzk3OERHWEFoMDNiZU9CYmhLYUhFV1ViRGdzeDl6bFRtTDFTeG1sUXdRdDd1?=
 =?utf-8?B?clFJOGQzbzdIb2lMM1IxUjl5YnNLdFBKNlRtMkZFMUgwcXNZODBONTluNncv?=
 =?utf-8?B?YkV5cXBDRnBBVFR6SHlFeXk2SXZGdjg1YjFtWEROSXlSTHh1S0Y4aUw3b3Nw?=
 =?utf-8?B?cW5BK0RJZ0haUXZYK3JEQkZhZWQrTTdxTWVRcGdmWWVKeXNQKzMzNm9wQkJk?=
 =?utf-8?B?Y0l2MFRidWpKZWVtNWlNT0c4dGVhU0w0Wjd3UmZLclo1UHJwTnR6cjZzRjVI?=
 =?utf-8?B?VkNYbU9NUUU1L2RhK3Zrakc1N1EzTXJ5QUJnUHprcm9LaUoxdVRMSUVnTUUr?=
 =?utf-8?B?SmNIRjJ2Njd2NjR3TzZYQWlFdFEvYktGK2E2Z3FSWGR0YUE5WHAveFRHVFkr?=
 =?utf-8?B?UkVjL3BkTUVQZ3VQVm5lOWRQYjJOQTAvRFdtZ251NnIxNURYUFVOWnJ3L3gx?=
 =?utf-8?B?TVl0RlFPVXJlUDdRdVJyQXRNYlR2UnNHYWN5NThjNGZUc0pRZCt1aG5YOWta?=
 =?utf-8?B?VU05bzVPeVV6b0o0UDVGaTAvVTVSNWxFVjdIdmJ4NGJVR3QzUUwzV2JkMXFy?=
 =?utf-8?B?M2VCWlFjRDhpUndtOHF5OHRzYnZZbVFBVXJNUmVpWGc2ZkJqVTVybi9tNkJH?=
 =?utf-8?B?M0tyMlZiZi9oTmdVOXFBNmlCYVNKR2NIZmZWTUZYbnB1UmNlMVFodzY2YWZG?=
 =?utf-8?B?clgvd0VmNHBpMkptbkdIaUU2UGxaU1NCaUtsbXQwekRFR2xXVGJoRW5FalVW?=
 =?utf-8?B?SmRNZWNORnBCdHR1Q29jZ2hZcTNTZlRkR3htSTZQd3RWdDQvTS9yYlBUZk9G?=
 =?utf-8?B?M25MTUVzb1NWK0FNVUVrNTNIUzVjcmQvcTJXc0loV1QwSHhNZVNVNTBmeVhJ?=
 =?utf-8?B?L29tc240S3pkWmR0YXg3YmlLK25ldTBid0FlSWVaZTV4MjFaRzNSSDV4Y3ZZ?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e27e122e-36b7-4ff6-73ac-08de31bc1ca0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:01:53.8542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNNIsl6sMkyz4XgYi2DQn+fww/Y8t0Qo2woIoBfj58Z4hea2vcwTeL0PZzMXXr/k7ebuWVnPV5LrOU7NId5GSk9qhB5/AIuEf6kNqs5HPCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4EB9556A6
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> Up until now, all monitoring events were associated with the L3 resource and it
> made sense to use the L3 specific "struct rdt_mon_domain *" argument to functions
> operating on domains.
> 
> Telemetry events will be tied to a new resource with its instances represented
> by a new domain structure that, just like struct rdt_mon_domain, starts with
> the generic struct rdt_domain_hdr.
> 
> Prepare to support domains belonging to different resources by changing the
> calling convention of functions operating on domains.  Pass the generic header
> and use that to find the domain specific structure where needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

