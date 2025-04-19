Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF95DB676
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 05:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745040187; cv=fail; b=udOhod5Z+gLGEwk1LZhMLeiwjQmjmRRq7xVOU3P6BhaewIhQ73no5hEEWszhfLohM0XiAbMqF+k5l1V+QGzHt/OYZUQGKyw74/waGLaLHAj5TI4AbQKi4TxuFpJXWeOnXw5Ug+BOe3FX09wYiS8WLd3yUOfaMSykFMI1M+tbqeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745040187; c=relaxed/simple;
	bh=U4McoGq0hTo4qlaCicIJ3sZpy2GIk3jpesHAO2V9y64=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CCh7fEJpYqbNi5vDGkL29/zlnu/Pru4K/capJI/FejQS89jewU4IkqKFFp20DGjE7o7jawI5P30dEl61QN1hvMV2RWn6gwxWJAK0JgFu6x2mHEq316IbDPe0/UIKJOt1Hv9O5BbQaWLLjbTAaRTQUC1HMXwV0LZ+oBUVF6gAYzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z/Ouc5Zj; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z/Ouc5Zj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745040186; x=1776576186;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U4McoGq0hTo4qlaCicIJ3sZpy2GIk3jpesHAO2V9y64=;
  b=Z/Ouc5ZjdK+UZm+ehy8sDjr1pf3r7RPnM+/tXg+ZLjocUb4v/D2paOLJ
   K1oMcQOsVJtUsg5gxIhRqQmfbCqHUb09OgcqLB6cT2Dp/32z/Fh49fmsr
   4KnZMlKEE98csQfF3Y9D6b7R4P+opXthUKEJPR/EVIuaMoHZ78Ll1gxZd
   iF7OK1veJPucq+vCzqpHERgDTxlG8ilwfdpqrgPbHY4loWXItUgw8fxmg
   6Gltd20U/sSxbSzCiFGLFrhrnSm9PmBZSG5gtnAgLw3mOu8lX3r+1FF9+
   2zZ1543POXEAEzT39L0pxbygAD0kD2hJ3M9EjSs9DRgLD5/yxqH6beXR0
   A==;
X-CSE-ConnectionGUID: 3yGmc6byRMilPzrKUGPJBg==
X-CSE-MsgGUID: tKLWnxMDRAypBqSiXwg2gA==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="50327553"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="50327553"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:23:05 -0700
X-CSE-ConnectionGUID: aAuegM8bSwaagbSEuPbZlw==
X-CSE-MsgGUID: efTNLPHWRhus16Dbl/kmqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="131255270"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:23:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 22:23:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 22:23:04 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 22:22:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUzR5FlErPam63DHphHGObdS4CVKpJf2Y6g3WJxNlsWA4AFaosIbjpynGIwu7K2bFat6E6IUH5ZEsgItrvRq7fIqvhN6mOZ847nSzVMXQlG6YMRKxl4HGza7NQR+lyFKHNP/jcDq626sHLsLyYZZqA/mOCVUDbxb1UH6zDOf26gb4Vr9daeG2N+fuc8ustxs9JAL4MZOJ579BfHYdnSTCpSOHpO0uekhWNXitd6jsE1ceUk8x/UpZh81WrfRgnpP3Qhzz+pYZOVB0Ot8um2meO3urFk8UIB+LbqneYb/1x4XvddbVP5GZl0a9UKfCLOdf96T7t/IFKaWRrdTLvWehA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cM/FLkBSMt02VFQoYuasasW0ROX0lvV+w2+r91UqLs=;
 b=xREbx9m2JQa6AZY1HFUGl1ZfbUGLzKO1xRebInwrWp4sCgQTsfr2nMOaceDQ8owUubSB/oHH+JUxctLNBoUsfIgvwW6E9CakdMxAoliTlkENTj4Ui8lZjiy/3Vi9eWcxdZLcNOldEfJRNs10EanmXNRccwYHeJhRRMN5o4EvVBkTzedLtsH5BnnqLM6SdQsdc87hD3q0b+caSGRLWzuYabZDOwTOUL7QAb1HuODXGyLj6Dwnv8e6EutkvBKbZYRqp+XQa+qi9tAtR0xgVqmrz/SdD54yM1aJikpGH76kxJW0VXJoBka3MetOgKff1w6bPfZ6vAjBiPvd/WH8cpMAMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Sat, 19 Apr
 2025 05:22:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 05:22:38 +0000
Message-ID: <d83e898a-4ac6-413d-8228-989d5395fde6@intel.com>
Date: Fri, 18 Apr 2025 22:22:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/26] fs-x86/resctrl: Handle RDT_RESOURCE_PERF_PKG in
 domain create/delete
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-22-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250407234032.241215-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0011.namprd16.prod.outlook.com (2603:10b6:907::24)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ce026f8-3001-4b3f-7346-08dd7f023354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXIxcUVBZ0dYaFg2eU5uTU95SHdBVlZVU2h1VDU3YXpRSmxwWFY0UGM1ZVY1?=
 =?utf-8?B?RWljbXl3VXpwcmxlYitOSVlBaTlIbVhhTWFGRllHZFQwK3VYNms0OG5YNkx2?=
 =?utf-8?B?VlpYVno5dkVmRENoV2JaOWxYYVNkc21uUURFRVRFM2Q5aHo3a1dWQlBEWlZr?=
 =?utf-8?B?Szh4eE1DRWZVa3E4ZGlBKzRMcWRqMzdOZkJybnNDbnVTK1ZlZkJTdU84OU1H?=
 =?utf-8?B?WHBtNjA4cDRDalhCekMwY2hheWFZYm9lc0MwOFZ4cU1TNmVUTW1OU3F0ZXhU?=
 =?utf-8?B?elZiUllzcU94WHdQVDhmQkJ3NHRXYU96SzlLSy9oQ285YzI4QUhucUp5Y2pO?=
 =?utf-8?B?MG1OMkpTQURSekRoekpTVGJ5SStoa2pMQ0Z2V3lQb3dHS2xyK1VTV1liS1VS?=
 =?utf-8?B?VEZlWmZtVXlqZSs1RVNBUG1WakYzMTI1S0t1TnFvMHFZMlpGSlYrWTcrbGE0?=
 =?utf-8?B?U2htWE1CUE9wMnF3OWpLbnpUSnphRld2WjIyTnhKb3VxeStCZzcxRkNjMG5o?=
 =?utf-8?B?NVRCMFQrSlA3ZXRFd2JXcVd5cUlySmt6a09yYkRXRTk2NHoybFFTTlVhZEtq?=
 =?utf-8?B?dVZvNUFSR3BLQXQrUm5QQkthRmlFYXVCTFdSQlFlS3g3MnhqY3lSWWtwNzlQ?=
 =?utf-8?B?V2Mvb3VSaEN1UUZ2WkZMZ0JoTC9pWVVTTnU4aUIzYWl3SWxjMVNMelYzWGt2?=
 =?utf-8?B?VURYWXMvY1VmVmh2ek9nQmZXMmUvUDZrRkU4MXFHWERGYXRBTlZjb2E4cVdV?=
 =?utf-8?B?ajQyNUtzZzc4RDBnTXIxalFMZURDVEhTOTRiVk1QSzgwVjZxZ0tpZmE4OFJi?=
 =?utf-8?B?aFlQWjhsWDVILzZVYk1EWmgzZUdFcTRlV2RwUTJEb242RFlVS1RQRU1GdHl2?=
 =?utf-8?B?Zjk1c3cvMGxMNFdlckNLL2Q0bFoxaHdHYXdYM2h6WVI3bW84eDlWR2FGSkFz?=
 =?utf-8?B?SnZQd1ExOTkrWE02MllUa3l3R0hITWhkVlkwelk1QXhlUFV4cys4Q1VScjFt?=
 =?utf-8?B?cmd1ZE1FZWkzWHhWejhYMVcwdHFST1JHNDVsUEpVNW4xYlExWFRvQ3Z6ZDRv?=
 =?utf-8?B?bGN5T1ViK0srVjBmK1liQlM0b0xxS1RJNzhWOHJDWTU3K3hHZ2ZBMmgySVRB?=
 =?utf-8?B?TVlNamhDWjdYLy9yTmljaHpiOWIzSXVtVnZIL3lOVVh5czRxSFVUUStYYVdF?=
 =?utf-8?B?engwUHh0b2FaRVMrdUljV2czVlVLMktNZFQvSjkvaG52YjF6eFpLbUdsZnh1?=
 =?utf-8?B?bUV4Um9qNlBkMGFaOFdtT1NhOUR0cFhkNnRnSGhySTcvakJtSHFTaWVJUnhZ?=
 =?utf-8?B?bzY2ZVdxN2ZZRVVUZTZCOFVkYzVXSkMwREVpNUdZYXF6OVZxbnVkbGdMaElX?=
 =?utf-8?B?b001ek82WC85K3pVcENWWTJkbFkwa3RkOFBmRUJ1SUU4bUd2eW9qbVVPMUpP?=
 =?utf-8?B?SERsVzFzNTFtU0oybkRCVlhCRjhnWGtmeE1vVjJPUmNHSlBFNmtKRXFjbEtr?=
 =?utf-8?B?d282Z3J1QlEyem5ja0puQWZXZ0JVYTZua0J3SEdzOHFqT0Z0RFVLaWZEemIz?=
 =?utf-8?B?WnlBNDRTdVgrckZ3V0FySVFVcXJPV2FCRG00TUZ4c0E4My9Kejg5T2tSMEp1?=
 =?utf-8?B?WWg5N3FORmZsUm1MK2VkaDRBZHNxOGZiL0Zvbk9jR3IyWHlCVXNUSUxCeitC?=
 =?utf-8?B?VmFGazlqaXRxT2w2NzgzZFJLZDhPN1ZDYmU3RUFRSlA3ZGx1NklGSktoaTd4?=
 =?utf-8?B?azVkOURYdDgydFhqWWY5Qk1yR2pSODBCaVNpZFBSd3dpVEhUL3d4dHVyYWVi?=
 =?utf-8?B?MmUwOFVkTTBhMHlSL3daL2pkRjVhOE5XU0x2aExhRytPa2JJRDM3cFBhN2xo?=
 =?utf-8?B?Ymc3Uis1SThkczY5TzJvdkxyU01JT2twb0hiRkd1bmxXV3ZmZ2t5VDBCbCtw?=
 =?utf-8?Q?EVH8SdUASIM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUZqKzhxTkZyNEVMN0hLTU1mZG1TRVcxTU85YWRJWnhBVUZBUWtFdVM2Tmts?=
 =?utf-8?B?MUdVVnpUNlZtZkFuYktvKzFRSnJEdG43TFN1UGlGdGkyY1V2OVZpMTcrRTJq?=
 =?utf-8?B?dVhVWjkrNzdoYzhsZDdTeVR1bzFEdWRqdTZvSHhVNk9EbVRya2drdkYraEUz?=
 =?utf-8?B?c09ZTStWbitUYVZjRDc2cHlXZ0gvU2FtbU1sbkl3dmNBaElnOHQvamVsMGRo?=
 =?utf-8?B?VzA1MGIwL1lEeXRJSlJUT2p0N3dWWm8rWXo1S1M3S2pxK2NtUzJoZ1g0VjhC?=
 =?utf-8?B?YmhkUzUvZE9hQ3JiYXAwdEJpVGpubG5hMnArc2VtZjR0azQvZ1R1SERvRFM1?=
 =?utf-8?B?VTVyWFV3MEpKR2txVXhETVFTbDVUdmZZWU1aSmxzTU1ycGg4Y2hNbURxVGgx?=
 =?utf-8?B?WXEvUUFoTGpNNE9mV0RZa3dOYXJzQzNuT3ZNZGc3OWZqbkt5WTR5MmMxNm96?=
 =?utf-8?B?SDZpdlo3azd3c2FzcHIzSjRFbFNOWDd3ZmtBaW4xWGZsTnJBSkNRaVJnSlI1?=
 =?utf-8?B?SUtKMzZ3bkFTb3FtSzhIWHloNlN2V1g5QW8yMnZnd2JwdHRXbVZ3Lzdhd2xq?=
 =?utf-8?B?TUtPT0QvU0lLQlNRKzg1UGNIdTZTeWE0REhvbExnaVJzbVBpUlVoY1o5c29w?=
 =?utf-8?B?K0cxc0wwcE1DZmUwTFpoUzdLak9JcFFrbHJnTlZic2hST0hEa1RaWWNRdjZH?=
 =?utf-8?B?ZFdoTnBwUDUwTVlSY2FjcWxvK1hXRXhMVEVTTGZxQkZxZWhaTjV4QWlHcWFr?=
 =?utf-8?B?ZW04N1R1OXZBZ21tOG5FeExhdjdpM0NQb2x0NjdNMHJKUWVPYmRIaitOR3N1?=
 =?utf-8?B?bFFsRGxNQWIxNlVHcm5Fb3dBeEFRTTlPQkQ4dFVpWWNUQmtpUnV2bGVISzB4?=
 =?utf-8?B?NWVsdWw1bGErR2sveFJ0TExtMUdhdG8yWFJEQU04UVZKZE4vOFRGcXZuSHlo?=
 =?utf-8?B?NnlvUDNndmFTZEo4SDcwZitMdlVBZU0zaXBZaXIyam5DWWJPcnFhd0J1Vzlt?=
 =?utf-8?B?U1Q1MURsVjdPRm90Rm9MN1Zrck9KV3o0MklIQld3RUJyaVVkT1FrOWs5STFh?=
 =?utf-8?B?ci9oSHgwQjFpbFdsSEwvZUdxQ24rbytIM2lKZU02ci9sNWV2YUk2RTV1TGJ2?=
 =?utf-8?B?SUptSGtNeXdhZzdnWE5Mb2VYMVlqQ1VHUG01WGV2QXlOaFB3R1Focm0wSzdq?=
 =?utf-8?B?ZHhreHh0UTM5TnBuSENyVlFJcG9iZnMxOVNJRmdiSXFRdUtYYURYTmhvY3Bp?=
 =?utf-8?B?T3hlK2FjVTNzdWl5MktVUXM3czhhdXlwemkyTy9sTUFwNjRJVVBHamFwdHBt?=
 =?utf-8?B?TWdWVll6WWF0U1FpSGRqZkdDcWJ6eU5DUWtGaXl3NndPdDZMSmZEbmxxUFdi?=
 =?utf-8?B?L0tqdlRzV3VuamhzM3hOanYrNHFseFlYdUg4aEdXdEloNjFXMlpHalo4R0Rw?=
 =?utf-8?B?OU1XWExQeFZ6RFhyQy85QW9OSkZTOFpQckErN3FGaTV3c1E5MkRaVUpPNFhX?=
 =?utf-8?B?MEJ2bDBQWEgweVJiL2hjWlgxUzROalkyWVdRN0Q4ay94eXJhWVROSXpHc2o1?=
 =?utf-8?B?c1hKSUFOVG1MR0xPRlozNmF5ZmIxSEpBVEZ2QlJvbXBEd1k4SGNtMFFmNWdu?=
 =?utf-8?B?SXlVTnAzN1NlM1BKSnlSb3ZCV3U0L0lXWjBNSnppRlhBaUV4TUZpMHA0K2VW?=
 =?utf-8?B?T3JiSi9FQTFiNjVtTVREMW1UQTJ2bm5lR2lOQXI3TUxoS1ZRQklQVlpNQkMw?=
 =?utf-8?B?dlV0cUc3RlZ6NEhHRmlBTDA3MUdzbG82TlVqYzFDdmtwdjlZNGdsTElJRENO?=
 =?utf-8?B?aDRyRlhjRWYyZHlzR0tPSUZkRlUwcXFFb2czZDBBR0ViOXhOWHRPbC9uVmFq?=
 =?utf-8?B?dk8rRzkralk1T2JNUkdsazB1Y0tJSGhqcGhWMDBBNnJRZlc1SGh6S1FrdEdF?=
 =?utf-8?B?SUkrcCsrT1FzUnZGdDdhV0d0ZXFtUGlkTXVuUjFwY2lUQWNVVUg1eW84SGpk?=
 =?utf-8?B?VjEwR1FwSHAyb3FnbjVpd0VZa3Q3WFVJWWVRWHdCQThXTFJKNmxIYUp3dUYr?=
 =?utf-8?B?cHZpdzFYZFRmeW53eGwva0VKZklEUDlHYzRJL21iVWIwSXFxK1NUV0hqeENh?=
 =?utf-8?B?cWROQnBmd0VBYm9iWUZaSkRwb1pGSGd1dTVQZkIyN3VPdkw4YXJRU0FVUnFX?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce026f8-3001-4b3f-7346-08dd7f023354
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 05:22:38.5622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO3OtJtlDms23bc2cj1x+JHySGe8mrS7/1JNy9AOCvz8V/dWYsBTIbAsHh9Os8W557EXLjCnOtCdwV6rqMh4WHJ/D1dxU6/lXmyFj2BK2HY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Add a new rdt_perf_pkg_mon_domain structure. This only consists of
> the common rdt_domain_hdr as there is no need for any per-domain
> data structures.
> 
> Use as much as possible of the existing domain setup and tear down
> infrastructure. In many cases the RDT_RESOURCE_PERF_PKG uses the
> same functions but just skips over the pieces it does not need.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  8 ++++++++
>  arch/x86/kernel/cpu/resctrl/core.c | 32 ++++++++++++++++++++++++++++++
>  fs/resctrl/rdtgroup.c              | 11 ++++++++--
>  3 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index c03e7dc1f009..6f598a64b192 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -169,6 +169,14 @@ struct rdt_mon_domain {
>  	int				cqm_work_cpu;
>  };
>  
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource

It is a red flag when architecture specific things ("rdt" and "Intel-PMT-scoped") land
in include/linux/resctrl.h

> + * @hdr:               common header for different domain types
> + */
> +struct rdt_perf_pkg_mon_domain {
> +	struct rdt_domain_hdr   hdr;
> +};
> +
>  /**
>   * struct resctrl_cache - Cache allocation related data
>   * @cbm_len:		Length of the cache bit mask
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 9578d9c7260c..6f5d52a8219b 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -542,6 +542,29 @@ static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct
>  	}
>  }
>  
> +static void setup_intel_aet_mon_domain(int cpu, int id, struct rdt_resource *r,
> +				       struct list_head *add_pos)
> +{
> +	struct rdt_perf_pkg_mon_domain *d;
> +	int err;
> +
> +	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!d)
> +		return;
> +
> +	d->hdr.id = id;
> +	d->hdr.type = DOMTYPE(r->rid, DOMTYPE_MON);
> +	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +	list_add_tail_rcu(&d->hdr.list, add_pos);
> +
> +	err = resctrl_online_mon_domain(r, &d->hdr);
> +	if (err) {
> +		list_del_rcu(&d->hdr.list);
> +		synchronize_rcu();
> +		kfree(d);
> +	}
> +}
> +
>  static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  {
>  	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> @@ -571,6 +594,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	case RDT_RESOURCE_L3:
>  		setup_l3_mon_domain(cpu, id, r, add_pos);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		setup_intel_aet_mon_domain(cpu, id, r, add_pos);
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  	}
> @@ -668,6 +694,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  		synchronize_rcu();
>  		mon_domain_free(hw_dom);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		resctrl_offline_mon_domain(r, d);

Something should have complained about using an uninitialized variable here (d).

> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
> +		break;
>  	}
>  }
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5ca6de6a6e5c..34fcd20f8dd7 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4020,6 +4020,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
>  		rmdir_mondata_subdir_allrdtgrp(r, &d->hdr);
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		goto done;

Could you please change this test to 
	if (r->rid != RDT_RESOURCE_L3)

this makes it clear about what the code that follows supports as opposed to one resource that it does
not support (and possibly cause issue in future when adding another monitoring resource).

> +
>  	if (resctrl_is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);
>  	if (resctrl_arch_is_llc_occupancy_enabled() && has_busy_rmid(d)) {
> @@ -4036,7 +4039,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	}
>  
>  	domain_destroy_mon_state(d);
> -
> +done:
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> @@ -4104,12 +4107,15 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>  int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
>  	struct rdt_mon_domain *d;
> -	int err;
> +	int err = 0;
>  
>  	WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON));
>  	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	mutex_lock(&rdtgroup_mutex);
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		goto do_mkdir;

same

> +
>  	err = domain_setup_mon_state(r, d);
>  	if (err)
>  		goto out_unlock;
> @@ -4123,6 +4129,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
>  	if (resctrl_arch_is_llc_occupancy_enabled())
>  		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
>  
> +do_mkdir:
>  	/*
>  	 * If the filesystem is not mounted then only the default resource group
>  	 * exists. Creation of its directories is deferred until mount time

Reinette
