Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A621CA02
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 21:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283656; cv=fail; b=Buv9h1yIXQLWfzIKymycVYEa3A6tvmCr2F9UcuVGiVq3ULK7va1AyvHsTaqi4lTFxk2EBJKot55Nbhdz+XCs0EHicd3Dz2y88+iJ2T88ec4+efCjki2wmYs+lp7XCi+nESJSGXOq0HuqJHj0fDpNMf+3kJ+eTmIig7mxl7NvKYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283656; c=relaxed/simple;
	bh=QjWQAwvqF5tuY0gMf6qD8ZifIYOWOoh1kXo5C92C7iE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cYlXuhcqSFCD48U5jEMU7u+zvg5NAH1C8O0OJChfYyWB10spwupPRuf6P45xfyRGtKpuaLr6LyRrlL2OCbbfKYSOHg/XfJL9ihPuSH2nRaN7YyfhelgYvo3BXsuTt1rsS4JUPFmPvoKmZ0T/Ds/sinCmheRNIgLVxKIxmNGO/ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eFZfNGvp; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eFZfNGvp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790283655; x=1821819655;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QjWQAwvqF5tuY0gMf6qD8ZifIYOWOoh1kXo5C92C7iE=;
  b=eFZfNGvpkFZNGciLFsC54alhKiFnJIaKb2iyZGeTUDWi7sBuRQUN8oGY
   Bk6cb4vjrjzzLgMk1+IVG90/mAVWJ59mks9pHeJ7IQu9+gZYIGElHb6k2
   NsGB60jYN0azwbrr4iF9hQFl2rqlxcUi+zELdZu+HoFzXFRK6M1N/bHH2
   APxcpDlWNsFseVTfDAq0dKVDam2LswEMIDKs7n/5DV1ToEH3IjzhCGcfY
   6RhccETqHXBuWbNKQrYCue5Y7vwrhXv8uIcXdqtm4XPpYj0zyLaQIFIRi
   kEVMg7FNy9zgnwOvrYksQqJSHbAp7fTyGgHCTBG/RTxPmMPblGlzDHdvS
   Q==;
X-CSE-ConnectionGUID: sLttTPLJQDKmHE4kTDe1fw==
X-CSE-MsgGUID: XbTSLoTyRpunsLzkeEkscg==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="91175146"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="91175146"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 14:00:54 -0700
X-CSE-ConnectionGUID: 6lQwwKo5SIWRM6LthFGvsA==
X-CSE-MsgGUID: 0Ljfc9NDRPKAcRlt1oxFlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273704576"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 14:00:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 14:00:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 14:00:53 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.50) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 14:00:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXA7Ku+Rl0gFab12896Ioc9rR6FNzx6Gemw+Tq2xPnCjqzLnv5fRrOEAcccDVfogHFFVax6vwnLzNAwHv4yTjluTOOVtv/o3Vl/VVGGv0kwPVRMpmlCKHhGrpc6le4kMRHnjeWvCeCziymkQLmsipIvcyhwsS8/QawtVbTbdkiKK9M8bnRfMqja/I/WFO4ExQpQ/XHvxQbeLVXDr/nilK/qA6y6Go1HZH64V6lfwRDLiB7wkkh4EaQTkBMjUZfrTYiokD4BsuKyNFrSRM3yctMrxgdAfYUuN10268nz8mENqKDqaphrH/sAeXQTdQBUXQGEHWm11cp8qt3YNoD3HvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gqzBDSk7fYfzWlKmxwp1XQ5Q7kf4yu3GnYMKxYQnok=;
 b=qJKRYSMqhzQU/+Jinkm3VXAvlTaSAyRz/rKht7f6ANqBSDX024Z6eyWC/GMmPs0vuVJ9H5cwrsfazWjBhIn4mzRdysWjIDS7TMh5rG36CgXe5rLslmFlLTXOkqxpVTjlD6hAR6b6ycG5MibBt7BqkdwsfEeRkZUVSJuSQoo+8f6rl0H2Qf4x5R+HYeNAu/nAUh9Ic5UAB4RcCLStb8T3J5wf7D1eDZjz9nsX8IRI+ig6RtBMynGjSpVNbUkycrSPMfsJXH7PO4qCnu1rSh3I3i8AiKBVDxhM2QuvFBbsaUl0zW/vx6Gr+VS5pjzCiGtFx8jyVFmGmAp4BZp3E5D4ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV2PR11MB242941.namprd11.prod.outlook.com (2603:10b6:408:3a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Thu, 24 Sep
 2026 21:00:50 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 21:00:50 +0000
Message-ID: <789a5dfd-ffbc-4d67-9965-58f2f9c882f5@intel.com>
Date: Thu, 24 Sep 2026 14:00:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 25/25] x86,fs/resctrl: Document telemetry mount timing
 caveat
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:303:83::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV2PR11MB242941:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d083447-0909-4fd1-137a-08df1a7ee9c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|56012099006|10067099003|4143699003|921020|11063799006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: /gTSu5iMsykVi1tma09IhoLVYXV7NkA9McW423Ww67pw2MdCgcKQul0iH56WSHPTDpi9lCjclTNzDKOmZ1MxE/isEhQYoNXiFqG+5pmusFP8YnLAyLPQUyzctQ79pz9qD8x+N3G2ju+c3oa/uvLcbcVHa736fCnoJZ9IM10IjQS1M9ijJfcHTwlH+bHmqHxvxVO0pud3cd1cUxgXoMFr1BKsijElHz2oLTWjLv4PS2ovXxUcZXhKigt0+2Jew0TYtQUXSzuzFzfowRq9VNV2KBb34cVkvbTWx2au1JKLArNwO8L87GLCdyCn5awgZwNF6is2IQPRZ6hJmnPy3wxUK9I50zYb6FrMH5OVnk3dQ+ygxdP5l7F4GTYf3tlBLd+angAEBvcbVanquv1amzWZ9/l1UvgUZQ4WHzvr8ZbF/U3pKRQCfI/NXWsimNGTeF8p8bywyhmlAqS31X5n9KXxp4eMbue7KC8XA4DrKSeVpRaM7bH+xoOjeBdAB9H57cZH0NPrYkoGShpzuwjoX8jfM97H7wZmKX6bZp7Y/7pIGV6TJu2Ph6sjHmyI5xwgMWp2e2YuAf6+/DgRdU3Nzt9OcQqOAdqHWD7kcrB9E7kbhbK7oaqOGni+kEjjc3rzcmKxRJiHL4ZqMqAtmsIFVgK+TqSiJZhj2rVZrVpp4+7VE3+KbqEFSks3sfNRxe/iYF65H53lKvo/GSdUIUMn/PuyXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(56012099006)(10067099003)(4143699003)(921020)(11063799006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3NqcVNwTHQvbVRjOUg1UnV3bGtFVER0MlZ0eHFxWUZyT2tTV1hGQU9HWVk1?=
 =?utf-8?B?bUtSRDFOTFE2ZDZJZXJPbVJGWDlONUdodkg1T1hESWRFSFRmU2NUTkNwUEkx?=
 =?utf-8?B?cHdIdG1YMk9BTDVzU2VTQnZ2MVREbG83ajRkRHlHWEMreUp3ZnN6ZnNCNVJs?=
 =?utf-8?B?aFZUaFBySVlLenFYUEdtbm1NdmJjMXpONGYxYjErUk45ekhjV0dZNHFiQ2Ni?=
 =?utf-8?B?RUx1R0FmOVY3akcwRVMwT0o2aWtobWVmdTlkM0dJVlpCQkZadzQ1QjhFclF1?=
 =?utf-8?B?dUZqNnBoQUxHamgyTlRvV2FXaG9SRFhHZU5RRDZCcUpHa0x1ZGI5U21DT3BF?=
 =?utf-8?B?eTNQZFNLblRhQ2hMckFucFVjSUVGNkZwakpBbzE4Vkw4eExMUU03NW5YVHFi?=
 =?utf-8?B?OUpNcjA1MVFPdEcvT05tcXdSM3R4cVpjS1ZEV3IxVjNRcTRJMmJiR0wwUlBR?=
 =?utf-8?B?NUNpVEliendiLzg1WC9SWXFnZDl5cTVyUzZlZXJ3K2lvenZuY2VqR3poYnlH?=
 =?utf-8?B?UEVIcDdURW1LRFovdWRXVUFEZHd0VWlkb1hsOWZ3ZzB4ZXVqK0NlNHNOTlJI?=
 =?utf-8?B?d2Q0SFBYQ3NiNnQ2anpqODJKeTUrWGdRS2NDOVFUaElFMnRJRklsNWpXVzVw?=
 =?utf-8?B?Sm1nTDh3d2J4Ymk1VWF0cEdDS2pUd3ZGMHVHU2JOanhhVmRPL0p2SWJIQk9V?=
 =?utf-8?B?OE1JR2E1d0RYSHE2cHBUV2VpTWNodi9melVCS2FWdHNlQmtUNkpCbmFQRytz?=
 =?utf-8?B?K3F3RHFXOFR0cWU5M2R6YUVESCticldqV0xrQVlsekpjTnlRMTRJaElzd0dC?=
 =?utf-8?B?emNEMXd0Mk03QlNuQWFBVFB5Tll0ZmE3YUpRdXIvQUVHbHRVZUNWdkJOVmNM?=
 =?utf-8?B?RWo3T0sxbWpIMHVRc0JTUXltckVyYzh0Q2M1bjNpNmM0YUJjTXhldmk0TWdF?=
 =?utf-8?B?bnl3bUFWdCtPblZxMnhaa2JMV0xRbmk3ZFY2d2dZbTFxaTR0dTE1NDI5cVMr?=
 =?utf-8?B?dEdGR2tqT3EzWmE2cFlzU0pRYjErZEs0TGJSQmF3RVlPbmtKR1NzUWpMY2Zp?=
 =?utf-8?B?cDMxVU5xYnNQRnp2VUh0bGd4a1h6dUZYbW91bGVjOTZIcXd0ZHhKMWlzaW9x?=
 =?utf-8?B?YlR3aFRLa2NxOHF4RmkzSzJucVlrUm9kU1Bia01MdVVObXlwa3NreU9RajJB?=
 =?utf-8?B?L2JZUzNxdVlVak94UUcwa3dZbEFldSs5UWk2ZlRZTmpXMzZyTzBpMXhVUFlB?=
 =?utf-8?B?aGxIdU5vU29nRnoxeDU4MzBiZ3QzbkU5T1FtV3ZtMEttQ29maC9GUzRVZzh5?=
 =?utf-8?B?YUpKTGRERkdyODc0VllFLzB6bWhEcXJvMUVrTlVWckFyQUtZaVczZTZab1JQ?=
 =?utf-8?B?RXZ0TVNCWmdMM0lCbUNjajdZdkRoSzh6Rk9xWGRpNVgrMUoyc1lsVmdMendw?=
 =?utf-8?B?U2NnZ3U0a0dvMC9iaG9DajVpK0hucFRYc0xVL21GMFlrMVowbm9rUVVURUN4?=
 =?utf-8?B?V2FnN2M3cHp1R2dPT0EwLzF3VGRpZU0zTitBSk12M3ZMMjd6OWpaS1RzNGVq?=
 =?utf-8?B?MWpOZ1o1TGxUQmZxTHVKamxJcFhRL3RLaVhWeGRhTlFaZDk3bTcvTW1uOElE?=
 =?utf-8?B?ZlVVUXJVeTN1LzhQMEQ2cWRVY0VyZmpheUE0aVdzMHhBaHc1bkNvek9xNzM2?=
 =?utf-8?B?SUhXOU1HSkhWa1YvWUhDTDY0RW5XS1d1Z2VoUWZvTmFCaFZ2V0VKNUpEVks1?=
 =?utf-8?B?ZUxFa1d3MWxmVEdsajlJc0wzSWlYbmNoUHpKSVhGUytrbmZPZ0cvRzBzalJU?=
 =?utf-8?B?NjhXa3Q0WTJWTG1UV0NRY3RyYWt0TVdTcXZ5U2FIZndNQzE2NTVJUEUrSlJJ?=
 =?utf-8?B?MnNRRThWRm1rY2tIRXlMRVZlaUlacDBSRngxMmJ0dkZmeHVleWRLSUZWMWNS?=
 =?utf-8?B?ajNteVorNERTZTgzMzRqUXNqVFFKTzNtUzJGT0k0aWpuZ3VwaU5IaVIvMWR4?=
 =?utf-8?B?eER5czQxRzBJYUlPU0t4aVlob1ZOL3hKQlMxbE56bzl3ZG9YT21DZG9HSDFC?=
 =?utf-8?B?VGliZkF2d0VWMlV3MTVxSjRTa3hPZDdzb0Q3bXlBWXpEa2t0UTRmWGFUb2d0?=
 =?utf-8?B?SHl3aUd5OW9WVGNjdEViRlV0YmdqS3lVR1UvclppbUhSMXRPblRmaHZBQmNy?=
 =?utf-8?B?TWJRMUNTV3lWSm9ONWozbUZ1OGhJMWlBMXdhZk9jSklXNGRETTNKdDRhSTl3?=
 =?utf-8?B?ZCtuT0h0SWNTcHhKZ3NxNzFnOE1OTWNWOHIxVE1wU1hpaGYrUDlndWhNWjd0?=
 =?utf-8?B?c05wV2FvRUgwY2VES1RaR3hPeDJXbFhPMFNjQmgybTFydWhCYVlxOU94SzZt?=
 =?utf-8?Q?rVGrXPSm5I5MR1rw=3D?=
X-Exchange-RoutingPolicyChecked: nRPwxDdYI64GrJdQVAC4ia/4nAOoPk5C/sCt+mdkag+t+N+m8hjaiBlcP4vuQvo5spAp69JPG5aRYZ3F+jfcEgFeFY+Nb0M2WTWhaBjT4TQNnQ3F9810F1r9y5QRVSdoywB7nkshN2FmWPUP2OAEjTGEHdVlAAwvRrSeZHQmr9E0ynXWrMrhYMwCRp7SK0hLihBzgNJmxaO/GN31kOf0JX6sxpS2tN1pvZ32VakdB93n0HOfW1HFBdps+RGl3lv2AMw/j/nCHNLIri309asw7pXefUVShiqVfQP4IoLFq/bIVje4Lvj+u/BUz1hXkWok2OJ8wEpzNlfYRiUGncpcGg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d083447-0909-4fd1-137a-08df1a7ee9c6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 21:00:50.1459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQR9VQs/pdn0Ooju5sn9yrH/mkhgsjA+QW+AEUyXb1W87fTmHVpGPNh5GFEyj9+D9Ns/V8OIkn3dmuW/s60ErCN0rMb6VCBH21qNnapL2WU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB242941
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:

> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index e4b66af55ffb..91a2ab0fa027 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -630,7 +630,7 @@ When monitoring is enabled all MON groups will also contain:
>  	each instance of an L3 cache. Each directory contains files for the enabled
>  	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
>  
> -	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
> +	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
>  	directory for each physical processor package. Each directory contains
>  	files for the enabled telemetry events (e.g. "core_energy". "activity",
>  	"uops_retired", etc.)
> @@ -669,6 +669,10 @@ When monitoring is enabled all MON groups will also contain:
>  	returned if the MBM event does not have an assigned counter in the
>  	CTRL_MON group nor in any of its associated MON groups.
>  
> +.. [#] Telemetry features are enumerated asynchronously by the PMT driver, so
> +   an automatic mount of resctrl from ``/etc/fstab`` at boot may not enable
> +   them. See `Mounting resctrl with telemetry`_ below.
> +
>  "mon_hw_id":
>  	Available only with debug option. The identifier used by hardware
>  	for the monitor group. On x86 this is the RMID.
> @@ -1898,6 +1902,18 @@ m. Unmount the resctrl filesystem.
>  
>    # umount /sys/fs/resctrl/
>  
> +Mounting resctrl with telemetry
> +===============================
> +
> +Telemetry features (e.g. the ``mon_PERF_PKG_YY`` events) are enumerated
> +asynchronously by the PMT driver. If resctrl is mounted before that
> +enumeration completes (for example, when mounted automatically from
> +``/etc/fstab`` early in boot) the telemetry features will not be available
> +at mount time and will therefore not be enabled in the mounted instance.

Above paragraph seems practically identical to the footnote content. The only
new information added by this section seems to be the sentence below. Could
this be simplified by dropping this section and just replacing the footnote's
"See `Mounting resctrl with telemetry`_ below." with the sentence below?

> +
> +To avoid this race, defer the mount until after the ``pmt_telemetry`` module
> +has loaded.
> +
>  Intel RDT Errata
>  ================
>  

Reinette

