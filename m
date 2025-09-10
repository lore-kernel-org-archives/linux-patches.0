Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC459223336
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527092; cv=fail; b=IzRhfIdrgugKHRE6+AQct8YGumEEwfE74wE7nmy3r2mYSapabZJ5KFnmhQQ0YVAcgdA9ICOHb2auxVTWO3qB4stu73LyJvlOxDg3Y8tT9hOqo4iONFVEt6Dz/Q3a14PlOQXkKmqLABhtG0fphestxASakS0XgNwqZIGqyQ7SE4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527092; c=relaxed/simple;
	bh=zPcnSzmB0C6szD9u2i2v4jwgtebhZaJ/BiWUvZbMdKs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tiry3/LY3iW3drRehHaRpSbFz+xOFmgMamwvrS3FWwccpeaGX+ZInxLC00H4u4zWxHk6FFuihp8zODXN1DT1lO10QQCwVdK3wp2WdkfV75SFi2a00x651AHsIvEJsPFnxj/5Qtx0nEESLXlRmv666reDmYT1KjyRar9Gm9tZQGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WJM0PdGI; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WJM0PdGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757527091; x=1789063091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zPcnSzmB0C6szD9u2i2v4jwgtebhZaJ/BiWUvZbMdKs=;
  b=WJM0PdGIK2kHfd59ZcR+gM7RIv872pGj/z7SB8Jf3KfFnCUv0B6/3Zj3
   8q9a4JfepVXJeK/WIUFcl4xaFbYc8T2VfPkObaBFFoZLxwxvmW8lal4tj
   5+OUOgTmC+HI7Ja6x0touny4vAmvR+p54OTFOktwQEeKOvxCxy1pHf/Ja
   aA9ByDdF0egB4g8V13IGKtjIpZQayCW1rSSjdwUbUn2kQsj0c7zFqOhHK
   sn/BBVxXCKkctSB/y0FDrJA3fAoctzCxBMeONWq8Jt4wCY9k9eQbeN0UE
   TgevWlF4x79kCfF2NQDQhdlQi14tV3+8TWHXN61ByGrWm9W7nE1Bh+bd8
   w==;
X-CSE-ConnectionGUID: GfON/dxGSxemaectpOUjrg==
X-CSE-MsgGUID: WEgTjiioSsasOh/HTRMoNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="85292488"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="85292488"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:58:10 -0700
X-CSE-ConnectionGUID: hlkiPy6nSaS5FvyRgqol1Q==
X-CSE-MsgGUID: l/J1NZApTuuEMznRit5/AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="197144281"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:58:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:58:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:58:09 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.72)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:58:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBi7jIlotF8++YPOPZZYt+lt0phAGRnXEq5Kh3oAym1BvhADRMeH7FX3Fkr5MOF7h95U8cLBt3DL+v61SbPM8vhgJ2A8Fka7s6D8k0rPURc2fp5SCiTJFQ2ZRA4rJPeLJtKmin6g1M5n3Y3CSXUi6RxkKrEr8fVwoNYMWuQhHmzo9hnDUoZ6pohPfhJvg70U2KYMe+O7iWsJ21Co/QjYHaTti/yU9cLfnVc+hHsD4sXGbSCtd7I6M0yCtenGatOFZpq6bf9R20xu42oz1e3mRnlKVDS41uansLzRQ6U148fOCYg6Cz1siaIJ42CcPvAH4sM889rXjDXFUcxXMbRjhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jh8pEfsLMcsaQhjcHL+MLxnUIuDWG/hEBhMec9STAc=;
 b=u6xaQTPcL07Ul4vO7uWx7wqVkSjc3EnvlVxbm/F3OEcAjP5lb4Q8/M7AD6F/97TaQ4LxiSHdk1gVwCKhBMpJpnf6w5smjkZ9Xy2CcJvCo7w8PdbilA82jife+wZexn4pSzl5GSH2NDF2e5BbD2hKoOLga3LI1VwCR/+zDWZk5IxjSO4HInQWc1kmJczzI582IsO6Qd0VMVvyS/rCNcJOS4PJzi+Lx5DKZbYewvHN5vFpJNzIxfa2P6dcpNjfG4Hy2kOQp3pbJ8LLZqm+l8M8VnU2f5q18LKUE4b4a4cYsPBjJXQy8w1bMv0A6GVngjiQ2lZZ3jeE0v7MFDMR506jbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:58:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:58:06 +0000
Message-ID: <bbd0071f-753e-4479-b259-991501781aec@intel.com>
Date: Wed, 10 Sep 2025 10:58:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 27/31] fs/resctrl: Move RMID initialization to first
 mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-28-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:303:b4::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: f739ca1a-709b-4cd0-baa3-08ddf0939822
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NURVVGVOR2djUUVPSnVyZnNKR2ZzWWUxTDJSS2lYNWNjeDgzdWdkODI5SkIw?=
 =?utf-8?B?cW5SaEloV3BVYXZ5VkRXZG9yNFFiRmZ0S0Q5Lzg5TTNPZS9aNmZvT0piZTJG?=
 =?utf-8?B?R21YRWZPcy8wcDhidWdUVTQvVElFN1JrQ3Rkd2FMQzNlcENHNFYyZHF3cDdY?=
 =?utf-8?B?OE4vMy8zME4vcXJPZDJiZEltZHZXOTRtY0NqYTRQQWhDM0ZQMnhTWUN6QzlM?=
 =?utf-8?B?RGFHYUZ0Q0RaaUdmemR3bS9zZmZwWVV3MEtHL2tSWHZHWVhzb0VUUXB4NnI2?=
 =?utf-8?B?ODAxWGFCZVY1Y0p5S3hrSkRrejBWc0ZNVjNXRlpRamczTm1kVGNNRFdLWWRo?=
 =?utf-8?B?UGdRQmVGclkyQ0hGNDJSN2toWlgzeWFMQTFGZ0ltUTd6bmx0RFcyMzhMaTFC?=
 =?utf-8?B?bkVCSDJYVXhza3E5T3JHY1lucjBpdUJJNW41eFNBSUhtaHRES0pMU1htTHU5?=
 =?utf-8?B?TktPN0VHSngxaFg0dmVqcjRnN1duRHB3NlZLTE5SUmtwK2hTWHY3YldVRmM4?=
 =?utf-8?B?OEU0ckxjdDFwVjFnQlRZTXU2L1BqcGhONGIwZjM2Zm4zOFpmYjNUODFwaDNs?=
 =?utf-8?B?a3NqUVNmVEZFWXBVc1FZbnU4UUdycU44QmRteE9aWVcxZXRnalNKZjZvRmd1?=
 =?utf-8?B?V2h3RTdaM1R5OHFnV2YwZVBkYnkyNURISWZEb1JvSmRVM1RVL1I4OEhpcHUx?=
 =?utf-8?B?REpvZkdZb3pBKy9NZ0ZSUE9nY2dwNllqb0dYZ0h6SnN0b0lrWlAvNGRINGl6?=
 =?utf-8?B?cVFzTHBLTFdiUFIrZ2dzd1pWWDZhdjJtZXQwU2pESmxYbDJGZkFoWnVxcytj?=
 =?utf-8?B?VnZaclE4cjJDWmNBU1FhRENaSThSYTZ4UmVrYVpCK000TjZFeE52M2tnanpw?=
 =?utf-8?B?UWpQUVJrdVJPMG52aHoyOXdZN2RMdXNIT2ttVHZYQ1E3dGlOdDJuNGJzZWlB?=
 =?utf-8?B?M0NqaFNWSGl3c050Z0hPaDR5N2VuMk13Z21QSDJIWHN6NzNsZExXS3Axc3pJ?=
 =?utf-8?B?em9uSHBkZnAyTEExSkZiY0xRVE5jTDNvWHdTSittN2MyNnlpTjVHNHhHdnF1?=
 =?utf-8?B?MEI1blJ2UHNEcC9aNitnU2VaZjhXU0VUR2VRVWF2ZEF5bGEzT3JmQWgxdzIx?=
 =?utf-8?B?VGFqcGdKNkhMOXVXRXNIZlBUODNnM0tycmhTUGdCQWliK05pRnhabkYzeFFZ?=
 =?utf-8?B?NzVwT2NRc1N3eVowS3EwS0RUenBVRGNaVWM2Mk5DZHVUVm1UZEc5ekJHVUlj?=
 =?utf-8?B?Tm5JamNuVW9HSktpODJZcFJIUmdZT0w3T25QTS9hS2d5b1N0em0wYWJ2NEhm?=
 =?utf-8?B?WnBFdy9oZ1FPYUdKazNVajk4Ui9TZnlaZ2ZCU0VBaGhueDJ3aGxhOWhNOTBh?=
 =?utf-8?B?WU5VamgwU3dZMGtBeUNlZVNJU0psYVJsa0tUWXh6eGFMTVdEVUduQXlFMXg2?=
 =?utf-8?B?bnJSWlRteWVjZkQyeGRySUFCQ3BnWExjRmh6UnVXc20yK3JmQ3NxR2szRkR6?=
 =?utf-8?B?SDVUZDhnbFg1T2ptSzlnZWxPVWx1ZFdUMHlKM290bEhlaXBjdmNlakZYV0F5?=
 =?utf-8?B?dElNZFJMeDFxODMwbk9WenJwSTZ1OWR5eUFHYTVvaktNYUI5RkZDVzlYZkJ3?=
 =?utf-8?B?QjNqUkluNHlRU2RiZ1VuTldMRDQzSkhTY25XMzhRTDUyQSs4NWc5MmNGV2lX?=
 =?utf-8?B?MzJuRU9NNEc5aXJFSldLS1FmcURtNXc3eStNUHlxeXppVDlvN1Bsb215NHEv?=
 =?utf-8?B?Sm0wOWl1L1h3Q0JwQ3BqN3dkQnNHdWlld0FwUlM4Y0RKZDVoeHFQdUhkVVl2?=
 =?utf-8?B?aTc0cGdtSFk5RDhqTksraWNyS2Eyc3VtQUZFMDVKVDdNOTAwc1ZSOWFCVmVM?=
 =?utf-8?B?WWhZd2x2NUF1VEtvMUx6UGlGZ09BQXA5cDdsdEdqalZSSUNXNGZna2MwU0do?=
 =?utf-8?Q?hAmPw0W+DYY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUpnV2drOGJYWkdkRVhJTmtxK1BsVzJQYy9wWHZFUmV6T0p0WWdkb0ZKcnds?=
 =?utf-8?B?RGFUSEIvMDI2dWFXR1Rlditoakk2SERsZjRVWHhRM1NlMDFzSzB1cnpDVjVH?=
 =?utf-8?B?YURCK0RHc09HVU5RK2xRMUJpK0lvWVA2dWtoQWhJampsYUxwdk5TMHZSVThn?=
 =?utf-8?B?Mk5UTThVcUFIdVZzUFE3UURmdGN4WlhqZHRTbXNQQVduYTM2YXUwUitMUnNO?=
 =?utf-8?B?MDkrRm5EeTY4a0tKN3c0VVlpOWEwc3VpUFdRWkVjZmpoQ2xwalo3c0p4L3VC?=
 =?utf-8?B?VEtnOC83eU5QRGFKV05KNTVhK29jWVJTMTdJdUFId2VWVElnYVBMYnU0enY2?=
 =?utf-8?B?aWhHV3FGclNPTGQrOWZwQ1BkZExqaVlIamJWWmJKc0VENFJQLzdIdFJPRnRa?=
 =?utf-8?B?WmFkVkNsTThlbHY3d1NvQnBVVVJXbzhCWGpOV2h5SXROL00yemZyTEo4b2py?=
 =?utf-8?B?MDJYR2FUR24rRkh0ckNwS25IblAxb0hoMnBMNHlzY1dLM09SVkN2T2xOT1JP?=
 =?utf-8?B?OWJnRWhlQU5iL3ZiZFR1ZnJDTHhLcHEwRE1XMFkxRFlMS3VGQnMwSkNFWXdz?=
 =?utf-8?B?Ui9yT0lOVndsenlSTWZleVRBNzlDcnN2MVVERWxodDZMTDVteTdoYnJaSWk5?=
 =?utf-8?B?ZjNEVjczUDJSTEwzME1GcEc0Qnl3OXoyZHNIUmxLRkd4NHVNcmdOM3VIR1lh?=
 =?utf-8?B?SnZqMEpwYUZiV0pDaitFQzRGbDRmSE1lYXg3bm02RFlUOHBHNkZFRUFyazB1?=
 =?utf-8?B?NjVTdkYxd0FrWXJ5MkpEVnFET3BCT2lMbTI1cGxhRXVoQnVzUE5YZ0tIVCtN?=
 =?utf-8?B?UmEzL203VFJRK2FQZnU4R2hqdmdDKzZmUVBTZi9velgwRjVSYVljcHppTFM0?=
 =?utf-8?B?VUMxaCtuUmJtYU8veEVXYmNmVkVXSWd6Zm9GaS91dGluNXRxYUQ2bW5XOHhY?=
 =?utf-8?B?L0Vlekl0UGVqRlZQeXMzb0RxSEhhWWg1UDFTUGZFZURwa1pob2xnbUU4TnZa?=
 =?utf-8?B?Z25ha0cxNWd6RDlwOEFERWlueS85US9tbTBPeVNIZStWazRiM2s5Q0ZKbzRK?=
 =?utf-8?B?SFRwTTBlalFSSWhOK2JSLzZ4WHUvdEF1Uy9mclJKUVhVUGljTjYrRjRUdURO?=
 =?utf-8?B?ZzQzWkxuK3VQUTNQL2FqVmFWcFIrSVFsVEJjUGlwWmNkaUE4R0ppeGdaZ3lQ?=
 =?utf-8?B?SHlEcXBZMnk0U0RLWE5lMlQ0NWtCS0wrSTBXcDVGZHZ2cmpYeUV3Z0ltbjVw?=
 =?utf-8?B?anlpOWcrWXEwbkt5QnZJZWNPZ3cvZ2E5QWhKbnJXTDZyRHhnblljRWNVVUYv?=
 =?utf-8?B?a1BmT0ZkbG1DTnVwQTViOHJpWnlubi95TlR6VjE3bi9INVc5d2hMMXFSZFRv?=
 =?utf-8?B?elE3c0x4cnFRSnRqQ3FnL1prQ1RBdkhxUjcvemhISjBpaDdIT0l2Z0Rlb09x?=
 =?utf-8?B?MHhHSVhqL1NjUFMrNDY3a3RidVpoc1h6UExrYXIyMnNLSU1FK0l0cFBLS1M0?=
 =?utf-8?B?SVFHMmc0NmRzV0NzR0VzVmhGQkdSZHdiRXA1THA4ZXZTQ2MwOWhncnhTZGdO?=
 =?utf-8?B?RHJrUzExaWdsZmdkMU5qZEJhUjdRNHMzamFZR2RRYVVPY3MxQlNiamI5SkZ2?=
 =?utf-8?B?blFuQ09YaFlQYjJZbkJYZHFvQ1p6SjY2bXA2UHpVZHNpQTMzeml4ekpWZ0RO?=
 =?utf-8?B?ZU5TYlZYUkxXR3pwbjlTSFh2U1lnVklUWFZDd0hJUUU5a0dBczhZakNNWlQ3?=
 =?utf-8?B?Ky9JVSsxWk1zc3o1RElYczJ0T2FNdVFQd1A4MnFWOHhXOVNEdDZjWTh2QVl5?=
 =?utf-8?B?cGJwd3lBeG1OaFRQMHBNemVmRUlmKzRCOVdId0w4RjZsTm93WGRGT1B6Unhz?=
 =?utf-8?B?Vlo2TXVlZnJFZThvb3FnT1RqOXlpVmtSWm1WdlRNSDRIRDFPdXhHcU94Wnlk?=
 =?utf-8?B?SE8rN1MyVXp3ajV0MmdZWXVkSE1EcTAvRmJpMFhZdW1RL3g2UmxteEZJS00r?=
 =?utf-8?B?Y2lPQVhrR3F3ZFk3KzVXeGZXTm83aHc4MjRRa0czY0VlcXkxOUJhRUFEc2tp?=
 =?utf-8?B?QXhPbkxhellDMFAvNVNheUVIZXhZTk00ZXJXWEhlMyttSkVubjAwUytJbFFt?=
 =?utf-8?B?SjJMR0cwQVpUMVd0VEcza1NJY3NaOG5jZzhzRkt2dGdVaFltbjgrSHYwMU9D?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f739ca1a-709b-4cd0-baa3-08ddf0939822
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:58:06.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhZa927mX9SDKeMavkPYJxRiiZRVYDcE9C4/AVWkpmyWPv8GeHOScdZU92ba1fRnw3lTc9fbHTGvBJePoLdqGml9KYbuz+5HiF0qUGrUNiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> L3 monitor features are enumerated during resctrl initialization
> and rmid_ptrs[] that tracks all RMIDs and depends on the
> number of supported RMIDs is allocated during this time.
> 
> Telemetry monitor features are enumerated during first resctrl mount and
> may support a different number of RMIDs compared to L3 monitor features.
> 
> Delay allocation and initialization of rmid_ptrs[] until first mount.
> Since the number of RMIDs cannot change on later mounts, keep the same
> set of rmid_ptrs[] until resctrl_exit().

Another strong reason is that the limbo handler keeps running after resctrl is
unmounted and may likely need to access rmid_ptrs[] as it keeps tracking
busy RMIDs after unmount.


> 
> Rename routines to match what they now do:
> dom_data_init() -> setup_rmid_lru_list()
> dom_data_exit() -> free_rmid_lru_list()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h |  4 ++++
>  fs/resctrl/monitor.c  | 50 ++++++++++++++-----------------------------
>  fs/resctrl/rdtgroup.c |  7 ++++++
>  3 files changed, 27 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 7c37142df1cc..6dde28d9cfac 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -357,6 +357,10 @@ int closids_supported(void);
>  
>  void closid_free(int closid);
>  
> +int setup_rmid_lru_list(void);
> +
> +void free_rmid_lru_list(void);
> +
>  int alloc_rmid(u32 closid);
>  
>  void free_rmid(u32 closid, u32 rmid);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index d5b96aca5d03..636342fad5a4 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -802,20 +802,24 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
>  }
>  
> -static int dom_data_init(struct rdt_resource *r)
> +int setup_rmid_lru_list(void)
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	struct rmid_entry *entry = NULL;
> -	int err = 0, i;
>  	u32 idx;
> +	int i;
>  
> -	mutex_lock(&rdtgroup_mutex);
> +	/*
> +	 * Called on every mount, but the number of RMIDs cannot change
> +	 * after the first mount, so keep using the same set of rmid_ptrs[]
> +	 * until resctrl_exit().
> +	 */
> +	if (rmid_ptrs)
> +		return 0;
>  
>  	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
> -	if (!rmid_ptrs) {
> -		err = -ENOMEM;
> -		goto out_unlock;
> -	}
> +	if (!rmid_ptrs)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < idx_limit; i++) {
>  		entry = &rmid_ptrs[i];
> @@ -828,30 +832,21 @@ static int dom_data_init(struct rdt_resource *r)
>  	/*
>  	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
>  	 * are always allocated. These are used for the rdtgroup_default
> -	 * control group, which will be setup later in resctrl_init().
> +	 * control group, which was setup earlier in rdtgroup_setup_default().
>  	 */
>  	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
>  					   RESCTRL_RESERVED_RMID);
>  	entry = __rmid_entry(idx);
>  	list_del(&entry->list);
>  
> -out_unlock:
> -	mutex_unlock(&rdtgroup_mutex);
> -
> -	return err;
> +	return 0;
>  }
>  
> -static void dom_data_exit(struct rdt_resource *r)
> +void free_rmid_lru_list(void)
>  {
>  	mutex_lock(&rdtgroup_mutex);
> -
> -	if (!r->mon_capable)
> -		goto out_unlock;
> -

Can use resctrl_arch_mon_capable() instead to keep this check while maintaining
symmetry with setup_rmid_lru_list() that will make this easier to follow? 
Having the resctrl_arch_mon_capable() check within setup_rmid_lru_list() will 
also help.


>  	kfree(rmid_ptrs);
>  	rmid_ptrs = NULL;
> -
> -out_unlock:
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> @@ -914,7 +909,8 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
>   * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
>   *
>   * Allocate and initialise global monitor resources that do not belong to a
> - * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
> + * specific domain. i.e. the closid_num_dirty_rmid[] used to find the CLOSID
> + * with the cleanest set of RMIDs.
>   * Called once during boot after the struct rdt_resource's have been configured
>   * but before the filesystem is mounted.
>   * Resctrl's cpuhp callbacks may be called before this point to bring a domain
> @@ -925,7 +921,6 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
>  int resctrl_l3_mon_resource_init(void)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -	int ret;
>  
>  	if (!r->mon_capable)
>  		return 0;
> @@ -947,15 +942,6 @@ int resctrl_l3_mon_resource_init(void)
>  		closid_num_dirty_rmid = tmp;
>  	}
>  
> -	ret = dom_data_init(r);
> -	if (ret) {
> -		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> -			kfree(closid_num_dirty_rmid);
> -			closid_num_dirty_rmid = NULL;
> -		}
> -		return ret;
> -	}
> -
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>  		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_total_bytes_config",
> @@ -977,12 +963,8 @@ int resctrl_l3_mon_resource_init(void)
>  
>  void resctrl_l3_mon_resource_exit(void)
>  {
> -	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -

As mentioned earlier, please try to maintain symmetry with resctrl_l3_mon_resource_init().

>  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
>  		kfree(closid_num_dirty_rmid);
>  		closid_num_dirty_rmid = NULL;
>  	}
> -
> -	dom_data_exit(r);
>  }
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 3201e9cad8da..886de0e01e8a 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2599,6 +2599,12 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	if (resctrl_arch_mon_capable()) {
> +		ret = setup_rmid_lru_list();
> +		if (ret)
> +			goto out;
> +	}

As mentioned earlier, please try to make code symmetrical to make this
easier to understand. As this is written the reader sees that 
setup_rmid_lru_list() needs to be protected by resctrl_arch_mon_capable()
while free_rmid_lru_list() can always be called whether system is
monitoring capable or not. This creates confusion that symmetrical code
can help with.

> +
>  	ret = rdtgroup_setup_root(ctx);
>  	if (ret)
>  		goto out;
> @@ -4408,4 +4414,5 @@ void resctrl_exit(void)
>  	 */
>  
>  	resctrl_l3_mon_resource_exit();
> +	free_rmid_lru_list();
>  }

Reinette
