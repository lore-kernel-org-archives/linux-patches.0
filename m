Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0766225D212
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487531; cv=fail; b=X6RAf66xr/RlplnqEyHovuwZjuYF3vw1HFoCnVB06tXTTNqo3HyjLODhzJ0hUcwM6cBvtNBXnbFCKbil9Dbjc1L8fNbwOaEMYsb5REEpXvGFqUVPFdYD0jVXB8g1OSaWdND2Ia30II7tJNE6IU/w/3R8upky5WE1CJOmi5FyFhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487531; c=relaxed/simple;
	bh=LKNasGMuZZ9QGbBEQy3hFWu8NgMkJlJsalwSky0t4SA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rMGYT5g5To83fcubbFGk3NBuNIM1MnDbjBdZw34eNZQIMvrEuimrPj2KaeHV/NvSLVLTxVWNB7pHO9NQwtDejTtzk+yRSJPjhruCteiyMhgDL7kZdwaTiAcvJrKjsiFCBr1MS49vZQCfCkdxixVIdgEafWs+G7SVLHl6bgUhQ2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKD3c4vG; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKD3c4vG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487529; x=1785023529;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LKNasGMuZZ9QGbBEQy3hFWu8NgMkJlJsalwSky0t4SA=;
  b=cKD3c4vG5tpaSQ6JBQeoT3S3vCHn7z0Fqqu/WDvgWtk815MdRSpg2kMf
   V8Z8WDN0dfujuZ+N9Py7gAFFlKOocPBKeKPccrhdfoPp1Rsj6mE5CLYhX
   ms48zESta3fKpKPg1/9supJpPi1V5yuhJB8C8OKH7uGRSMUOBclf/T72p
   LJUUIQGNrl0cT1zyTphv50RIvI29B89Yoe6TJrIphMKALnMG9Abojr4PE
   oO1i2E9rk/s5+xxs0ehxEKrWiBuutyBoLB2CQlaWsRzsUutPmoavPB28Q
   d8Sw8WAE4lEGUpCPlJOeTtyYaHnyQihqDlVRtt2RTE+SfX8GbfX//zh6i
   Q==;
X-CSE-ConnectionGUID: pRoWpuR5T0WQori0P78FNA==
X-CSE-MsgGUID: 3EEaxxdwQnynicgg0QRt7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="81269869"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="81269869"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:52:08 -0700
X-CSE-ConnectionGUID: XzWA8gN4QrGyvijgfjAVoA==
X-CSE-MsgGUID: ptnnbgHqRwSoe1/GTvp/+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="198390234"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:52:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:52:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:52:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:52:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzd0POH76aUrPPgtkgi0yBssNesQt0diqAxj6hIgT5TQDmmj6RfbrnsfsD41n0aVjNA+j4UoTvtzLYIofFZHnnXeNBLehhqDLj/Ie80GvhEbaz0dRJO6Y7V4w74oaJVg7zOTN7TJMUNU6TqenGBfgUOqUDQO4XI3et0n9S5OpZ8zoVgv5gBPtgoNoRCst3vN9q6fUI/zRZEgwmfyKpuJd4cBP0bEQC4YFRPWGuvJbjKNabTm9gD8sW13b7MuA4396MlOVgnJKbRjwbHHb4/s5iuPtkCFtBdeUUKl6YTbmDb7ffITZ5VfmZvnXh/NHmoAOQ/MQ6GfGjR+wBk6H94t8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77OePiT8a7kdEjQ0CHTyUVAoAcCWGDh9kdHM81ncbVs=;
 b=U6DCt/QSOf35Dp1wPjaKTRVvAqVfB7MMc8/b6TgM70B4TybSCpjohucDFk/IFwT3I130cmqLD3rI/kTPIMY44VMGPusj6Fy0N1Q9rGGpOyAWWxRug8OG8/wG5bsxVCB2RWphs9emclxo1ZGppcVrTsMlRwbu/hqGoJgqOoyZIVtceUuzJim5055FoRZ9Ua6kdFLEeNmV8QbZhVjq9GJg57LG79mk07c9o8uwDcam1XiPs85/zKlt1wrqd2+4GLsCujiH+C++f4m2+QGIMtLwS9EvGH3w2pZ0LC7Fl7WNtJ9ugnhzjyyewnvS0svpJ1gImnoayqhJZZtvS/y+vi7qzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8826.namprd11.prod.outlook.com (2603:10b6:8:256::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 23:51:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:51:50 +0000
Message-ID: <1e07785a-fbc0-400e-8b82-68ed110d7a93@intel.com>
Date: Fri, 25 Jul 2025 16:51:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 26/31] fs/resctrl: Fix life-cycle of
 closid_num_dirty_rmid
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0056.namprd13.prod.outlook.com
 (2603:10b6:806:22::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: d00b3069-225b-4f01-0f81-08ddcbd63949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U2ZkZzU3UnNGbi9nS2FHTEZ4ZlJtOS9POThUR2ptOWpCWU54TThRYTZmMnNH?=
 =?utf-8?B?QWd2Q09Ud0tXelFmb0t6T1JoQ042SzZYNDRmM2RQN1pIZExMREFuM092eFVS?=
 =?utf-8?B?UGxuMWg3UmlRbFdYSjJyOGhRWDNlc3lMK3B0TXNsSGJXNDRUMTh4T3Y4K2FG?=
 =?utf-8?B?emJyUFo3TU5MTkJBNGJxSG1CaVRPSkwrTHU4UFBISlg2NlhXZU9NdjQraGEr?=
 =?utf-8?B?eVpaNlRPVjk0NUdlWGVpam1laHpUNUFwOTBZT0dJOXlLNS9mZUt6Vmk1ZG82?=
 =?utf-8?B?SVBXVjIxbFVEUWpacWRpcU10dEFkdk8zZkhIYUx6WE5OUk9Sdk5rMXNQZjdh?=
 =?utf-8?B?aTJVSERYUlBQOFhnWHNZSEhlbDVIMDNnZzh2TkRQVEJSWkR1K0kwdlVrWk1U?=
 =?utf-8?B?Wi9DL0l6Q0RTMEJENVNPNTFYQ09oQzZJOFFvOHppT0VTcExvSEttRjZpMlZK?=
 =?utf-8?B?YUcyVlNEa3MyekhaWDNjd3FxQ3NvbjRRdlFIOU1CY3JYS1hKU1lVMXdCWVhr?=
 =?utf-8?B?bVhudkx3Qm41WVFYZTdoeVJrdEZUeHV0ZTZRQVZoY3g0UXpDR3hTcDhGZFJk?=
 =?utf-8?B?S1RrcTB6TVJiOE9YWDluVVVYTUVuTm82b0h3K0pQR1Y1Nm96YXFyL1pPVEpp?=
 =?utf-8?B?U0VYUVNQZVZ3L25zNFh3WVNKcGFaSVZId1ZmaElJV0MwQVAxMTN6dGVMRUhi?=
 =?utf-8?B?b1g0blVQbldNREV1NzhpdEZ6NVlkRHM0bU1LbHU1QXlWenJXWEUvam1ycFpB?=
 =?utf-8?B?NGR5d2NHbVRDVjJiQ1B6anY5dVY1aXFaTFhYNkZVZkFYSGJLMUNSYnFQNnJS?=
 =?utf-8?B?Z2g0L3RkaDg0Z1RSUWtmcFdIYWtRRkwwRGppQm9LOVBzK2ZoTk14cTc0Q0px?=
 =?utf-8?B?WlBGaENBM3JBdW13TEMyZkxidElDaUhlZG02eXZBSHI3anBZZXB6UmxnRlVm?=
 =?utf-8?B?SkxqNFVwYVM3Wnk2Mk4yQnJIK1RVMk9BM1FHK3VjUFUyWFBEKzFnMy96SThm?=
 =?utf-8?B?MzBUMHJVMGRRT2svMXhhcFM2aEJ0UThCcmZsR0V0b1FKcGdsWk5tcHRWNnQz?=
 =?utf-8?B?RXVvdWxucUFqbVg4cmk1THBrcHZnTlRWMVZGVFNuVHBXMkF3YW5KaGgzTjB4?=
 =?utf-8?B?QnRUNzVjZTFpSVpIZ2NIWmptZU9UMjhzUVpnSXVISTFjZDE5M3FlMENiaXlR?=
 =?utf-8?B?S1NUUk03MUI1b091RkFlNFRQYnNLMmdXNnNxRks2MXZMQjJJeENyYkxTdVRI?=
 =?utf-8?B?SnZ4MExHb1lsYk1mcUl6aTZyS09JTUZWaUZ1ZHFURHd4LytIZ0VKbGxnTFFl?=
 =?utf-8?B?MUorNktodFoxYkRnSUhCczBLQStaQ01nWXplOE9ESG9uakhsbHBkd3dDV0xJ?=
 =?utf-8?B?UnFtUEcxZjFPMFNQZC9mbGZ2eDJOSklNWEJEemNjbThVZ0dIUEQvUCtRaW5y?=
 =?utf-8?B?NlFTOExhVTBLek4yVXFzWlFoVHNhQlRoVTE5eXJQblhDc3ZLNDNWL3hUUS9p?=
 =?utf-8?B?MzAwZlUxc1E4TURDOXlQdTlZVDU1M1MwTlRtUHJUQ1dUWHFlc2ZtQVZEOGE5?=
 =?utf-8?B?RGhuWHNBUkp5MTFLQU9objBBOEozcm9XVGxuNjJzR2hGZ2o2S2pZcmdaUlFr?=
 =?utf-8?B?RHZRSThEVWVTY2QwWVFuOENPTE8wY2Zmd2dsZmFmdHBQbVZUTHJTRGxueHd2?=
 =?utf-8?B?Z1NQQUxMZFAvYU9WOW81RmRaMnRDbTBvMTlWWTBYZERVdk1BdVkweHFCUUhI?=
 =?utf-8?B?YjI1Tk5CMzliNkhjb2N4T0lEWkgzQTJQZ1p4SlM3RktRVUhVc0p3Uk1WejVV?=
 =?utf-8?B?cktIRWVIS3JxcGFwenpMNEdlZkZEQUlaWEFxKzN0UTAxeURFSWFwbHhCWkFl?=
 =?utf-8?B?SmFuN002SEZZdzEvOEFOYlVWU0s5M2tkOUw5cDBjSHRyUUtkZHhXNDBQU3V6?=
 =?utf-8?Q?aWpYyKuZF7M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VStiN1VxU20wVFlObDNOWUY5REJ5M1lYM3FPZFhPa0h3YXRjcFBDdVdtMVYw?=
 =?utf-8?B?eTRiaXhVZSs0c0hZdlNlbmZTc3BJVWNHd2M3dTBtR3N1Zi9CTDk1WkRHdmF2?=
 =?utf-8?B?d21zeFZpQ2QxYXE1OExwbUs2R3A4ZUVzVEQ1c1IwYjJaelBreHJ0aVVKdUdt?=
 =?utf-8?B?TGJ4Vk1nMFpja0Jwa1BPM2pKbGQ2NEFkaGhRZG9waE9HV1RyOERKRmRRdUZD?=
 =?utf-8?B?OXVWeHhFQVdzd0EvRnQvZHZCMlE3dGt4WDBZeE5vUnlQMGIwZGdBUWlQQm9B?=
 =?utf-8?B?V0tlTTRlSXY1ekVuV01hOUJ4b0Q4SFczV3hRTVBJSEU1Q0pUaWo5K0EvelBG?=
 =?utf-8?B?dWd3SVV5cHhtb1p6TDE2TUt1ZXhyWXR6VVZHZ1M1WWZyb3RVNndKZ2lkbnVR?=
 =?utf-8?B?Z1J3VFhodFZNU3Y4RWFWVDY4V1V5SDFBL0xqNU8weFF1UjZVandwYnhiY2pt?=
 =?utf-8?B?bmFub01STm5YU29PNUk0Zkk2Zis3VkdwNjRWOHIwaWxJa2FMZ1FlMVczRGht?=
 =?utf-8?B?Vk5mZURMNStJLzNoNTQ2Y3NZa0QrZUgrVURkSTR2d0grc1QwRXJLZ0lteU1h?=
 =?utf-8?B?cHN5Y2lHb2xBR04rUUdSN0VqVnpoU3hIWlpVTkc2QWJvVnE3bWJ3VTBkRXNS?=
 =?utf-8?B?NzhvZ1QvN1RWUlpjSTg2OUpEdEdrbDA4NVdWTndvY1VXdVdRMzNCQWNvNlA0?=
 =?utf-8?B?enBFa2dObFNZUzA1RHFBM3hwUGdXUk1NR0xFYW92UURWUTlhSkpDQ1RlRi80?=
 =?utf-8?B?NHcycS9oME5pWjR2MWNmVmNhNFFHM0dFMVhpSnRTL1N0UzB2N0lVM1R3UGo2?=
 =?utf-8?B?VWp4bDVGRDhnTTJVSDFOc1N5T1ZyaWczZnMrUnZGQTZneVVjQVNVclMzalRB?=
 =?utf-8?B?NXJxbWhlWHhDTnFnbC9ldmx0ZkgxOXNQV0pMOHlVOUpzWE9LU1pTNjJkSlVG?=
 =?utf-8?B?Z0VYSEJaM2JHeWRSczBhZzUvVTJCMXpHNjRnWlFYR0FzbXFsUW05amFMWkVm?=
 =?utf-8?B?T2xFNmhQV2RJOUVhVW12aHJTajhDV1RMZkxpcEtmS09OL2owOGNWYXdFeEhY?=
 =?utf-8?B?WEwxMkpTbDE0SDBrWjBBNHN3RE95Wi9hYlQ5TlM1VWdIZU1GZVVLNmVnNURK?=
 =?utf-8?B?K2hLYWRsdUEzYTJ5M2x4dXZGODluSmFWby8xZ0dqVHJhVlY5eGhIWktkS3hX?=
 =?utf-8?B?aG5VcHMwK0doTUx4dERRWExZUjB3VWt0ZnR5eWptWmVJendNYjlDTGE0YkZ5?=
 =?utf-8?B?M0RXYkg3dWVQekZ3Z2xobHd4K2w4MWlRZHpVYmQ2a0JyL2RYRHR2MTVNNko4?=
 =?utf-8?B?MEFXdGxkcUdxTk5iTEk4c1BxSzF6QU5oOS9IUGJnM2R3OU03T05WUW4vdHBa?=
 =?utf-8?B?eFFmNENaVHNsMzZua2RZZjlmUHdNL1VlVmU2N2NIRFRza2diQmVzNWtlSnBT?=
 =?utf-8?B?QUNRQ1YyU28yQTVxb2Z2NkM4bWhMZHNmQkowc2JQUENmUWQ2KzRLeEJaNmp6?=
 =?utf-8?B?ZFBHVnVXZW55ejgyeHcxTEJnT1NjRVFHT2tmdXVFSnRMSzY0aTVSbHB6QVFI?=
 =?utf-8?B?enJ4eEVhK0hWOGZ4Wmk0UGhDZGVsWkpHd1pjYWZBVkVmZ1UzK3V5NGFvMksz?=
 =?utf-8?B?Zk8ydWs4WjJUbFhHNVVqQ0luZ1NwSHkrbmVUMGVHYUVRczBueURiMnN0elVn?=
 =?utf-8?B?QnhBcG0rOWJtQTNsT2F4RU9FRkxBbXJacnJuSUNQc29JamVzSUs3MWZpeUtQ?=
 =?utf-8?B?SXg0QXdmL2xLdXlPa29RV2RNODJyemJ1clZPU0phSUhhUDJ1cGY2ZkN6akx0?=
 =?utf-8?B?KzNYZTJPNG5nOFAveDZGdS9uQURobU05VDNucUk0bTFQNUNQOHV1bXJrSDRn?=
 =?utf-8?B?S3BCTlNtZXg3K2dKZlNYcHJJZlRIOXVqdk5DRUMyM0lkN244ZGtveCs3RVBQ?=
 =?utf-8?B?b2xWclZFbEpweDNNcURhRVBBTTlzQXRFa2xOY01sc1FGYVhxQUI0SzVzdDhU?=
 =?utf-8?B?dUtlMHZnbTdLblFMLzdRWERkVktBWmg5a3hlYVhMWUZpc2pLTGM4VGJIM0Fl?=
 =?utf-8?B?OW1iT3VndWUydWpVLzg2K3RZRlRvMnc1cnZ6djJvYUp5cGpJL0hmYVhrV2ti?=
 =?utf-8?B?TnROcFo4YjBpVWw3dlVFYVhKY0tnaVRUNWRYZ2VSTDBQZU1WTkEwYzdkZ3Fn?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d00b3069-225b-4f01-0f81-08ddcbd63949
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:51:50.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Khj0GnbGdbqm1UNhmEGVMj+3Q00uyUoKmfe+ZGrmh/bEZUMlQiQS66y1BnXcmUZJ5eKEJUMdoP3x1RuHQ1o+EdSPVjUhNYR/XQK0/dFTNsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8826
X-OriginatorOrg: intel.com

Hi Tony,

"Fix" is a loaded word to use in a patch subject and its use cannot be
justified for a non-functional change such as this.

Do not make false claims of code being broken as patch motivation.

On 7/11/25 4:53 PM, Tony Luck wrote:
> closid_num_dirty_rmid is specific to the L3 resource, but it
> is allocated/freed in the more generic dom_data_{init,exit}().

Quite bold make this argument when "the more generic
dom_data_{init,exit}()" is only called with L3 resource as argument.

This is a very straight forward change but the description so far
totally obfuscates this.

This patch does two things:
a) Rename resctrl_mon_resource_init()/resctrl_mon_resource_exit() to
   resctrl_mon_l3_resource_init()/resctrl_mon_l3_resource_exit()
   respectively. As mentioned earlier, this can be done as part of
   earlier patch that does the renaming.
b) Separate closid_num_dirty_rmid and rmid_ptrs[] allocation done in
   dom_data_init() in preparation for rmid_ptrs[] to be allocated on
   resctrl mount in support of the new telemetry events.

> 
> Add helpers to allocate/free closid_num_dirty_rmid.
> 
> Rename resctrl_mon_resource_init() to resctrl_mon_l3_resource_init()
> and call the closid_num_dirty_rmid_init() here, instead of
> allocating in dom_data_init().
> 
> Making matching changes to the exit path by renaming
> resctrl_mon_resource_exit() to resctrl_mon_l3_resource_exit()
> and free closid_num_dirty_rmid here instead of in dom_data_exit().
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h |  6 ++--
>  fs/resctrl/monitor.c  | 69 ++++++++++++++++++++++++-------------------
>  fs/resctrl/rdtgroup.c | 12 ++++----
>  3 files changed, 48 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 56fdccb39375..28d505efdb7c 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -358,7 +358,9 @@ int alloc_rmid(u32 closid);
>  
>  void free_rmid(u32 closid, u32 rmid);
>  
> -void resctrl_mon_resource_exit(void);
> +int resctrl_mon_l3_resource_init(void);
> +
> +void resctrl_mon_l3_resource_exit(void);
>  
>  void mon_event_count(void *info);
>  
> @@ -368,8 +370,6 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, struct mon_evt *evt, int first);
>  
> -int resctrl_mon_resource_init(void);
> -
>  void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
>  				unsigned long delay_ms,
>  				int exclude_cpu);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 92798e1fb5b0..e3eceba70713 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -86,6 +86,37 @@ unsigned int resctrl_rmid_realloc_threshold;
>   */
>  unsigned int resctrl_rmid_realloc_limit;
>  
> +static int closid_num_dirty_rmid_init(struct rdt_resource *r)

It is not clear to me that these new helpers are needed. To me it seems
easier to follow if they are just open coded.

> +{
> +	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID) &&
> +	    !closid_num_dirty_rmid) {
> +		u32 num_closid = resctrl_arch_get_num_closid(r);
> +		u32 *tmp;
> +
> +		/*
> +		 * If the architecture hasn't provided a sanitised value here,
> +		 * this may result in larger arrays than necessary. Resctrl will
> +		 * use a smaller system wide value based on the resources in
> +		 * use.
> +		 */
> +		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
> +		if (!tmp)
> +			return -ENOMEM;
> +
> +		closid_num_dirty_rmid = tmp;
> +	}
> +
> +	return 0;
> +}
> +
> +static void closid_num_dirty_rmid_exit(void)
> +{
> +	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> +		kfree(closid_num_dirty_rmid);
> +		closid_num_dirty_rmid = NULL;
> +	}
> +}
> +
>  /*
>   * x86 and arm64 differ in their handling of monitoring.
>   * x86's RMID are independent numbers, there is only one source of traffic

...

> @@ -938,7 +942,7 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
>  }
>  
>  /**
> - * resctrl_mon_resource_init() - Initialise global monitoring structures.
> + * resctrl_mon_l3_resource_init() - Initialise global monitoring structures.
>   *
>   * Allocate and initialise global monitor resources that do not belong to a
>   * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
> @@ -949,7 +953,7 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
>   *
>   * Returns 0 for success, or -ENOMEM.
>   */
> -int resctrl_mon_resource_init(void)
> +int resctrl_mon_l3_resource_init(void)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>  	int ret;
> @@ -957,6 +961,10 @@ int resctrl_mon_resource_init(void)
>  	if (!r->mon_capable)
>  		return 0;
>  
> +	ret = closid_num_dirty_rmid_init(r);
> +	if (ret)
> +		return ret;
> +
>  	ret = dom_data_init(r);
>  	if (ret)

Leaking closid_num_dirty_rmid here?

>  		return ret;

Reinette
