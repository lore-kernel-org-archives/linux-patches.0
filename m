Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5239F2D24B7
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781110021; cv=fail; b=EX6jWkn+JqpprDanhmWyWlziaXVHsKV6lpU0vjQlvXQ54WN45Z3vZwhyUcfUAeyGBmEHoL2gY34QA+L2q3RGgnwtjiojFgsBwit2LHXYfop1oBw9q4c5edsYzWlmWSZBo3iZzGQOisabwtorKXewKXC0p6+2fDl9Hl7N2RT+TCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781110021; c=relaxed/simple;
	bh=6oO6J3qfty94+phKsI0HCajBlspdR6lDI7mzOrYytm4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bDwOdE/qFxNld1oXViUMH2yL1QU0tM1Yub1okaRg3u769yO5B5E64fuoFCDDQnA6Hb0+Mq8RBici/aSEMzAmdpVZB/92ueXHhhlwOVgLqoIMAMTNzs7WvFiAtUU8Z1S7ts/BDrOLJCHi7g0emRq7tWMgkFjVNF/QHTDi+cyMjYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BFWxVnlB; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BFWxVnlB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781110019; x=1812646019;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6oO6J3qfty94+phKsI0HCajBlspdR6lDI7mzOrYytm4=;
  b=BFWxVnlBxfTTMVTG4SiDjPhPrclpJcSia/cDWQQTCbOC58fz1RApUCW6
   6p7cuUd/4VaeaiigLrcfn6c7d+o7BcYYnKEQUyM9xT4rARrUfGfH3sowf
   fDRS6JasOS2M3KT7UOYFut3Qv/QuKEboyxLNUZ5Yx2JVRnCoJ1fQH9pg7
   7hd9EvNKKgcr64wS2nf1D+DnvWEFHozDH5LsL7CzfcGGlT+GHuvSf6moK
   46Hg6vyLIJQrQoXy1BtRDrBixJ7tLcfvkHuuhs2ajyq2o0fm7y+eW8jC0
   ZR4UXDAlyoQtPheaNBrqLZAFFFJKstl28FKfrQ1vnR9Yr9q1VmWYYh6bU
   w==;
X-CSE-ConnectionGUID: 0sUC63HVTcGB9giqdhu2Xg==
X-CSE-MsgGUID: HwWSl0F5RTGHx9qtOi7kLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="84480928"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="84480928"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:46:58 -0700
X-CSE-ConnectionGUID: celpw1MZR2KLM+NjAzm6+A==
X-CSE-MsgGUID: alXp7X98QveeR7+PXJKgAQ==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:46:59 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:46:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 09:46:58 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:46:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbn7jBy9mPUx5p1ckZp5dM2ER7Ezv+/76Rj4EFZPb2PnRujAU3rnRsHl32E3zLvITFzlWAfSbfrZGkk40Lhg4r6qW6QRhWaQIVMHQFIVFyTkEpwh22aqgOhTaZGbO1TPORL5Zu2kvUEf1n1kp6XR8zf704pIwARtdD08rbOCQIB4hFIDB9AR6ooemeWpy+vqilTZi2S3FbWeXGx6CFL4E8SuH3SlXZXkk3bu8tebtv6hvvzzqAajd2/nKopriRZXyT1Lh/eUxKlHLj6UF0fHKR/V1v/qFZkE/de/bGvZJOmjM2n+xghh7EOdCNqb06RCm055VwwagcK8nZxRJ4gUXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjbJblz892+edB0FqMUMBbtUlkRe354cFdTpVqblu3E=;
 b=vr+LmGc8Tjf0TGxDCP2Sov+J/VzdZS2Vp+9UlFhQy2l/fLfX6B+eKO5UscSZHddbBpAmadYf2EOlkrNIwGnUmRZEHoo1nMzyHfrUpGz0urT+42EADaaCUCDIEKmP0ZxsYKQbL9B2myLxqLiaHfNYk+FuS/vIYv7/udXxdpRxMhNaGXciUiyfrVU7iqrS0Io4tPTu0INqjrWiJMG1K/T/kacOIVaJB7rb2lgiTV4gbkCYRCBF2X5ki1aI0GZvizsF+bIsKpb3yVO1ASrtUB2aoCm1S6/GbUs4OitWVBnejBccLUrtmgwXf2WC3ayjXyYflY5iXLs7YdXuUIGMUWzZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS7PR11MB7737.namprd11.prod.outlook.com (2603:10b6:8:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Wed, 10 Jun
 2026 16:46:53 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 16:46:53 +0000
Message-ID: <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
Date: Wed, 10 Jun 2026 09:46:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aimR-7ld7-EE_YCb@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:303:2b::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS7PR11MB7737:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a81a21-dc41-42aa-a6ba-08dec70fe02f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|5023799004|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: Yd2cYpb/ADDiukQKbYmCysQIC1KCc2MrmPFup0Tfzw/4zSc69k27eqhmRkBHUpUgGfEM3e5y31i+73CqPo9o4fnAYFx7ttMfEu37FM4mdd9NNsdhPzgEyTWsa2h1565L1QGciCZ/qzajdHw9Q8vbUT/RBM9ABYoRADaTUqMPVb+X5bXYqyz3TlPNRJO8GrPuj8XZr1T8HX7TjWueJlVVT3mRY8aQZ45yR7rsFCgBBd9/C4ptqgs3WvNDn3rf0KN00redBbu31C94mutY97iYRkBtsEGuXCaWDO0DLSYiF0sabHdjnwpMFgDmA7gUQmgziOIqlNrzj1mMMdImjS66L4pbdiye0suRo7uq96kF9xRXEK8G1nbnx+xgROC8Et8oX8Kal0XeUYQTo7gDj37XVOI5dwFhcHPMtNLb6v/8KdhZ2VxK1R6LqwoK3qmgj7ga8rDrPESNrJYsAYoKyvnRlPqegoFuE+XDob64+/Iw4LMpy77HeQCEF97rwaOaslY/CZdoFbMvy7t9yIySYeSF55DS3+zsZRHJq7CJbKSZFPGWAqCYAMXteoi+shF/RbUFY2EPRG8EQypgvnnjEQBsOjk0zWY1kThofq31ZYpUnnolj/CPuw4vvndRtVmJLLbpVEmN3g/AtsSFP0vNuOJgovXg0iYFRyeURIrasPQQNBl0wSRz3VwexNSFFnuAULsi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(5023799004)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmxhSUxQaUFhNDAweXFlZWxxV0NPZkgzZ2dOQ25FaUNScnNHWDNqdVVmTEFz?=
 =?utf-8?B?aWxHUEhKSW9NeTBWVFloLzUwY05qVmRSL2lsSWdYMFVDcnlTWlFGM25FdDhM?=
 =?utf-8?B?VHpabkxaWXNEbFZRSDJJdXhOc0lNaStpVW56RUl2bjNOTmxleDBUZE9wWXV1?=
 =?utf-8?B?Rkx3KzYrelpLNktZWlBXTzZOOXlOUnk2dURFY2Z6MFlKQ0lqS2hHa0w1NEdT?=
 =?utf-8?B?WmRYRXJrd1V1bWlkWXpEb09QWDkzMjJBRlFSWHVRcTJMRmJER0EwYisxS1Iz?=
 =?utf-8?B?anhBNGdjaHlsY2dESW1aYU5TWGxFRDdRemVoK2ZkYWxZTVlQby84b0grbm9h?=
 =?utf-8?B?S0dMRTFVc2dDUDVXT3FBT2lFeGpBNGpzSmc2NmZsZDE5NjMyUVFjWi9TVVp0?=
 =?utf-8?B?Z3NkSVgwSmxFRnVIcUFieEtRWTNuZVpwV2xWd3ZQREdoRm1wc010Wnk3M1Fj?=
 =?utf-8?B?STA5TDRJbHc0NWhKdUxUMWs4Q012dkh5ZXRQQlR2T0N5SGpKWHd0eVI1NnFw?=
 =?utf-8?B?Z2hmU3NBdjdOSlFYeEtOS1c4dzQ1UmVpZHBTKzZyUFZDcE00TGw0a1pGUmc2?=
 =?utf-8?B?eWUrSXo0WEg1emZFeFVNbTkzc3R0UmRkWXkxUncrVkVrVWgydlA0MVd1T0dU?=
 =?utf-8?B?bUEvTmx5cUZUa2V4Z0d1ckovTHJQYmpYSHNWVXRIMFpWSVQwWjlPYW9vb1Rh?=
 =?utf-8?B?NEs5ZUNTRE5TNVJPT2pYSVpham5BcytxUUJjTEJxZUtXY0ZnL2lEMHVLaklX?=
 =?utf-8?B?eCtodmZoWm5pY3Rpd0JaTGNHOUoybTdJWFVueGM1UndHbmRUeXBiWDhMU3BH?=
 =?utf-8?B?cFVTckNOUXlVTFpDMkJ5N0tESWlBaWI1Uk5CMWdqMldlSlNOL0VzMVh2ZXB3?=
 =?utf-8?B?TzNQV0dycS9waTZBV2pYd1hCazArY2lGVktNczZGN0k5SHMzK25iNEYyakI0?=
 =?utf-8?B?Slo0OGljTjk2RllaRTVtWGhQU0Z5SHZoRTU2VjVpOXMzb3pKVFRqQVJkQWlv?=
 =?utf-8?B?allYNk5zckRnZDZDSnYxL3lCU2M2VkxHUktxcVYzYnZ0S1NtSnZxbjd1NXgr?=
 =?utf-8?B?WEV3SDZaQlpKbE5QQ3lBTk81NmJFeENSRVlrdjlXbjU1OE8zWSs1Z1BoeVB4?=
 =?utf-8?B?c3hMOHl2bFZMTUNSMXQva1R3dXB3N1ArakkyU3pFd3phWG1jTFZXVUd3c2JW?=
 =?utf-8?B?cXg3MVJuMndEb2xlTytzNkNlUlZBWXZDTFB2d05hOWIyeXh4N0ZuQUJwL2Jm?=
 =?utf-8?B?a1VyNkw3QzArWUpqTFZ0KzM3L3RFemJ1NFU0K1BaYVdrMjQ4bFpBeUc2ak1M?=
 =?utf-8?B?WEZzS1NhRGdmRDBjQnFsVWlBTFJvSk1ydHhuamlpbGMrQ1hnbklvcGgzM0xY?=
 =?utf-8?B?Yk9KVkdSMkpyZ2pxYnhLVTJZNC9ZdGEzellIOW40ZmxhTWJrSmJBWHFhZjdr?=
 =?utf-8?B?V29HNFI1bnBjc3phZEdyNzl2MW5JNU9pQmhEcy9SelVCU1ZHSVZ4ZVZXOTIz?=
 =?utf-8?B?L3BXVWtIcmdFMEF3SGtWc25LNTVPYkpQY1plYStGcitUdUhSR0ljVUdJTlVJ?=
 =?utf-8?B?Ukc3ZFpITzdXR1p3SnZ0aXlCcEdVc3RWRkdTMXNFRzZqZi9IS1UwOXpjRUdv?=
 =?utf-8?B?ekhCNmxPc3dlcCs0MjBUNFAyYzhlZUZzU1Bndlg4WlV3a2lXQXh4dVkxVFgv?=
 =?utf-8?B?c2lpbGN2YVMxelhuQVk5d3dXTWdCd2tMZVpkVkZ2eWloYTNNUXFFWG9ZSjRJ?=
 =?utf-8?B?cDR5ZGtNQWVNVXNiaW9sM3FBb2JnWHJ2N3UzN1dpWGJQUlhWaWF1NEZRUHI1?=
 =?utf-8?B?Q1Y4aVcwQ25HcDlhTUV0VlYrNFVMWDVCT1g4Z29zcStsTFV0cUM1dVBWTDY0?=
 =?utf-8?B?SUFUMWlaS3gycERQSmZLSE9aenNnMFhhdkVxL0hZdVE3MEZoeEl0ZTgwTEhL?=
 =?utf-8?B?SmpSYWY2N09aZ1dCNFozUFpIN3hyVWZyY3NhRlVaaTZNR0hXcXFucjlmb2tW?=
 =?utf-8?B?NzNzR2ZjVnQvU2tBWXJydVVtQmRvSmFtamduK1NxTkFpTXRGa1FwcEx5VC9C?=
 =?utf-8?B?VSt1a0V2ODdZVHJrRE1IZzkyOUdnbTlaK085Ry96NGswMUVuQU1ENzdkMDVH?=
 =?utf-8?B?OXFsUW0wbGJNR2oyZ1lCeFJvd3ZocWZYZ2RWWkhLNmNxV2plY1NBUlV5MG5t?=
 =?utf-8?B?T2ROOUR0UjZKa0ZDL0tIbk5KVjRiRUdnM2N1WStMc3B1aUN6cy95R3VWRHBz?=
 =?utf-8?B?SEl1MlB2SFVaQWRoKzl1R1IyTVZnRjZEQ1E3SXUyMmNMclF0UjdadFcwbzdM?=
 =?utf-8?B?QnAzS2tqUnRTYlh1YTlNZ1hQdGR3TFJMKzFzZE5mMEhnYXR4TmRKN1ZseFJs?=
 =?utf-8?Q?YCL5toyYttmEufUM=3D?=
X-Exchange-RoutingPolicyChecked: mgkiy0he4okUXySF1RfQ20PR2L5HmmpO8WwWBuZ1I8atj97rsxJ7d9WrNI+T9FmoOZf/tAO/wlssLAPjH0jYMWfXL+X5pG1xuWUlEjdrU5LV8wueDnjaMDziLweGlcF6Y6r15tmxfryrkwjD8m5sQsy44LEAwGmjB64Qk8GrFJdwZlnMKkH4jbGZnaM0MOirnZznUWjh5lIQ1TJQIqMMQ5vf99Yum0IhPNzGtBKvXiI0s3jjP1Vefa5zuWe+t8+lpmO56IatUj1z2sltp0ERBE6jY53/03uc5V7yyqotcws9rSu2cJzuk2RRhX6A3nl1m/qgFaPR3WayTIHRrGmPRg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a81a21-dc41-42aa-a6ba-08dec70fe02f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 16:46:53.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBP83k5zQP5bEH7OqnRjzYXCJoiPObG12KVbSnu4NJoPhjKucDzQxHLOIe3yuhpOaKnM5RXBzEmt/XJ41DXQ+isKLw0dvAms3/z6nopPVsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7737
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/26 9:34 AM, Luck, Tony wrote:
> On Wed, Jun 10, 2026 at 09:21:04AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 6/10/26 8:49 AM, Luck, Tony wrote:
>>> On Wed, Jun 10, 2026 at 08:27:15AM -0700, Reinette Chatre wrote:
>>>> On 6/9/26 5:08 PM, Luck, Tony wrote:
>>>>> On Mon, Jun 08, 2026 at 04:25:51PM -0700, Reinette Chatre wrote:
>>
>>>>>>> +void intel_aet_unmount(void)
>>>>>>>  {
>>>>>>>  	struct event_group **peg;
>>>>>>>  
>>>>>>> +	guard(mutex)(&aet_register_lock);
>>>>>>
>>>>>> Could this get a short-circuit to make behavior on AMD obvious?
>>>>>
>>>>> Like this?
>>>>>
>>>>> 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>>>>> 		return;
>>>>>
>>>>> Same in intel_aet_pre_mount() for symmetry??
>>>>
>>>> I do not see that this requires to be architecture specific. This capability
>>>> introduces AET register()/unregister() and pre_mount()/unmount().
>>>> pre_mount() already does no-op if (essentially) nothing is registered. Could
>>>> unmount() similarly be a no-op if (essentially) nothing is registered?
>>>
>>> Ah, I see. Maybe I just need a better name for my "have_pmt_hold" flag
>>> so it can be used as the fast exit indicator in intel_aet_unmount().
>>>
>>> Perhaps "pmt_in_use"?
>>>
>>> Then:
>>>
>>> 	if (!pmt_in_use)
>>> 		return;
>>
>> Something like this. It is not obvious to me how the rest of unmount will look
>> with this.
>> Ideally it will be something symmetrical to pre_mount() to make the
>> flow and short-circuit of the flow obvious.
> 
> With updates applied, mount/umount look like this:
> 
> /*
>  * Track whether pmt_telemetry enumeration succeeded during mount for use
>  * during unmount.
>  */
> static bool pmt_in_use;
> 
> bool intel_aet_pre_mount(void)
> {
> 	bool ret;
> 
> 	guard(mutex)(&aet_register_lock);
> 	if (!get_feature || !put_feature)
> 		return false;
> 
> 	if (pmt_module) {
> 		if (!try_module_get(pmt_module))
> 			return false;
> 	}
> 
> 	ret = aet_get_events();
> 
> 	if (!ret) {
> 		if (pmt_module)
> 			module_put(pmt_module);
> 	} else {
> 		pmt_in_use = true;
> 	}
> 
> 	return ret;
> }
> 
> void intel_aet_unmount(void)
> {
> 	struct event_group **peg;
> 
> 	guard(mutex)(&aet_register_lock);
> 	if (!pmt_in_use)
> 		return;
> 
> 	for_each_event_group(peg) {
> 		if ((*peg)->pfg) {
> 			struct event_group *e = *peg;
> 
> 			for (int j = 0; j < e->num_events; j++)
> 				resctrl_disable_mon_event(e->evts[j].id);
> 			put_feature((*peg)->pfg);
> 			(*peg)->pfg = NULL;
> 		}
> 	}
> 	if (pmt_module)
> 		module_put(pmt_module);
> 	pmt_in_use = false;
> }

I see many "if (pmt_module)" checks ... intel_aet_pre_mount() even calls it twice. Are they all necessary?
It creates the impression that the PMT module can be yanked from AET at any time, something which
intel_aet_unregister_enumeration() seems to allow. I was hoping that there can be some guarantee
that if PMT is available during pre_mount() it will continue to be available at least until
unmount() completes.

Reinette


