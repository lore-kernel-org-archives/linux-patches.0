Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F139E2F5313
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960629; cv=fail; b=gYnpcovZFIkieCNlouBo7MDat+EbAUkXqfSq2mu6idKyj9kkmqNbNFp/6a/bYne3jz7u7nMY/XtbleSvdD2F20XhfujzN18Cya2hTnMCsSxQdvKiuW9XCKgMpCiLI3cGsfx1qBYh2DannLyCGjKXw+hjpJep2ooQ18iha7Tn4Xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960629; c=relaxed/simple;
	bh=im+tugiPcstfMAA8REUdfIwDvxeGNr9w+wqMezXFHas=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=muWhwYzm6LtppUJhL9V4/LYgKGGYdmwWk1cH+Tw+zyfIvo9zRjvNUllkR1LfXla2COMktHCjL0T+soRC8/CCaB90NjYc2l1WcEeYIlfNXkb4B27L7iT6w8L8vqrf3uJpZVJnOXbtT9g6EC/brs4Fc2EC5Veqe1hvVqtHN0FdhT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dY16lOHj; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dY16lOHj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960628; x=1812496628;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=im+tugiPcstfMAA8REUdfIwDvxeGNr9w+wqMezXFHas=;
  b=dY16lOHj3VwbDnDSsPfIVOiQ7VQ2cNTyGkG10BmclBe7BCLa4hX4wi/1
   XJtfwkeqRDisZMNQ0lQXe5uxpcCkFuYPbH7e7eSgGyO9bp2/J4uwhxkwO
   dz+DBnlSWrG608hLQSCXePBkOnkl9cQmhnT9CKK39e/oDFlxf7g74NmNb
   ROpE/IK1ytwFDRFEG6G/53xHB/SSnOwnBF9VI89nbtHz8VytHXpo+FuW1
   BNVzOg71qS8rMJfLLGh7HJX7q864s7mkDhMctMJm9OJvDCAtRki9J1wSz
   U643MJZ5EPbIPctGKOQ+x4TpXXdeqXQ3TKc0nVACsZ1+bXu2JZ118SSSn
   g==;
X-CSE-ConnectionGUID: LnpbOQbRQMGcREUau2WW6g==
X-CSE-MsgGUID: I8Sb3MmBQtyvsAVftrdpFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81777961"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="81777961"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:17:07 -0700
X-CSE-ConnectionGUID: nOj9k7LlTCmj+Y7S1UpVmg==
X-CSE-MsgGUID: a74V7H7GSQCVRJ5mQ0d+ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="242746607"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:17:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:17:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:17:06 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:17:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=agdXH1+7XLiYGKq3j6uiRycdz+5orEui//ICxH4OO61ZDQ/DFmxwmuLJ8Xm9xqq1YjY4B2TrsLvlqMCxQFc+j8AZLMhs2N+XFtEVdZcdWrWA3gDhu7e7PrwyJizl0h+dlrjMLZ2V1CTicLnoOcqvpDGXK9RLn+hhigW2j6An/+g/RaeeEVv8xkSmuPfMOCPqbimu2jBqE2vay1sVmdlXkrkax94bVw+iTPqYO9ahmQ2dhZqqrtK7ExDc54ISPqT3mGS0la0rkluaqXf6vhQLqiaIRnddudJG3aFdNM6Vo9S7U+FteIHR0qNmJYbfWxm7L437NB3bQRFadvADqVy9PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x04vPFLkzCDa7ZL8UbsRtnnId8zji4+iYhTin4sgO5Y=;
 b=VmBzwif2c1O2fTpMEQhcqJnyQ4FQ+ufJCVMS5kszdhHs5mR5I1APd/bf2faEBV5ds9hSGY8Xu6licbkZTFAYm6fIp9b4DFt4VRK2miG/OOGlW4IUG8OpEmKwqv8nme9ldOiUo2M4mPbqC030tu3u3uPNCBQwJCjOVlNn7KpWNxEcku/Q9pQEBR1b4prq88f/PvtM9QvYnlBU4guE3szT6pWW9wMMwj7wn3EKyNfJWH50SWMJewR3wv4oHqlWrAWdi49Pef3K5p5oCSJl654C5hfF2hxwiWwMPQQhR7HWv8l5Tx4Or43+ktlzwQjJ97Z+erq/4Og0kz+nocAS9H+/HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH7PR11MB6930.namprd11.prod.outlook.com (2603:10b6:510:205::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 23:17:00 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:17:00 +0000
Message-ID: <4a62b53d-fafb-4f93-b724-e39ef93f0e99@intel.com>
Date: Mon, 8 Jun 2026 16:16:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/14] x86/resctrl: Stop setting event_group::force_off
 on RMID shortage
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:303:8c::33) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH7PR11MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc6bfc0-a12a-464a-1ff5-08dec5b40ab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|11063799006|5023799004|4143699003|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Fol8d1XjUplL2i9PVomarrEJxyja1ldDkD62yRQ3Ls3JujuAla3W3wY+W5LV1j3jJyT1prj3FN3J/cpPxGreWqh+ZrINxwLh8yz3MAPDH5+4BL4fO46wEXOqhJTV+SwUpGjTtlVmkgYNEltkI2VP4KQ6JUlJPRAQP5hBykqRim979DZMTULTpuSpubL45QW/wALKcjlycdZ3n84uS/cAhG49AOXZwfsiW2AJ6b0Id4XBclcJHFsgM2KqGfkKdYYCoYvtAxXxqcYEg1RzQ8iEshSlQRJm+CwN8MJooTBL2FYwRVYfZ76v3qyUu+b9zeny/SmKYnKsdtmwFGVQsl3gNN8Ke0RGxiCuRwwfLkhevI7M4rtlsRLOmyl7tVcIZAslskybE4nSwYYdrPlP0IwPpcAjHIhrYjDoQ9LOPKgB+MgGE/osmzjm27Mv5M79mzI/LLaIa8zEP44dMKnZelPAC+l10a8HkE/7iPBu46+tmEKycHAtIiIsEtN8DW1RJLGFqa8CpDAYbjSLpRPRvvdrSACeAeynXMWIQb9u9MeZnR2FmN5OywuwAVn8T97zGmeAeXbRHJdfOYOAqhA0ZM0Krr1X/4xTl459I8FXWHaWjnx65l6vDLWUwiKn/kYvjqsyobnu5al9VDh2qN5KQZTHMZ/V0m1QQmJDl0/6QCiAByFiKPAKezpjUYg0OEeiIfr3wz5Ta+Pu6Ze14ve7cRweeeBQ+6Ok+pb7f7f+JKhS+60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(11063799006)(5023799004)(4143699003)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTh4T3hCYXdsSzFLZWIrNzJpVTlEOFZkSmwrVTVtUnA3N0ExbVFFUmozS3Vs?=
 =?utf-8?B?MzdUNHVvaGIwOGx0Y0xPSi8rd0szdjNWOTE5cXRxK0xSQWhLRjVndW56Zk56?=
 =?utf-8?B?aHZReDBKV2dDUE9JWWxPckVIN2UzZ3NzR2Nac1EwS1AzNEcwbU1zQnQxcFRY?=
 =?utf-8?B?SUx1NFFKZUJlazc5MnFFZkdBdlVaS1F2b1JCR28xems5RDlEWWJzb0Y0U3li?=
 =?utf-8?B?bnNRMUFxbERBSnFUckpzMS9TVnRsanBsdE9MVUpWRlphbVg2NXpJQ2MzNVpX?=
 =?utf-8?B?RnViaFJGb1c2anFBTExqTkUxNGtlT3p0aTNTbnlNaHVHSUZaMHA4bDVBcnRq?=
 =?utf-8?B?VDB6Si9nay9OZXJ3bmVtQlF1MllXejZ4VVRLa21hUnIzTlhJRDBOclJjQ1Q1?=
 =?utf-8?B?cHY1WmZKNVd3cVhOTUh0RFBYL1R5RTRMUUV0RE8yRk1aRTBTcEFBU0c4VGU3?=
 =?utf-8?B?WS9pY2VPdDJBVnZ0THFyazRYYnBlQTIwNHY0akJPU3ZLRXR5K0JORS9UTGkx?=
 =?utf-8?B?Tm5zeHJlY0ZJdlNUTTFvSXR5emVpb25oU3hRalFZWjlBNXRTeDBvaExUQXUr?=
 =?utf-8?B?VjM2VHJYOCs5NEVuR1V2T0ZDbzk2T0RMdWc3V3QwWGt3UTF5akJaRGdKdXYv?=
 =?utf-8?B?S0Q3cnBRcXI4MEFMaHlBZzdqS1hjSXZmaHMzR0V0SkZGT0VvWGxleng5eGxE?=
 =?utf-8?B?alVzVU1tMHdoSjV1U09kWFlvZXNpckdmczNiOFJMQ241TDRLYXA4VGJ3a2tr?=
 =?utf-8?B?eVRRUnpEWEFuSDAwVXkvYkVTQzh1b2FYcE9KdWN5Uit5a0pyVG83YkhPQ1gr?=
 =?utf-8?B?MkUyQnNjNHhhOEtiL0gxU25obFhEcHJHR3d1TmdXSURWYXNxMlgrVk1YcjJ2?=
 =?utf-8?B?ajZzVjBWdTEvTC9JcXVadGhja0R5ZjFMdmI5MGtJbzhIdVpBUmdMTWlhQkM2?=
 =?utf-8?B?cUg3YlVpcURXYTNwdm1ubTJwRmtKb2Y2QXhpZko5MUZjdWQrdW9jaDdINUZC?=
 =?utf-8?B?NjE0d3VudGpXRkIxb2tmTkdDa0RsMUJKL0ZzaTFMVFp2WmY4dnJMOXlpaGl5?=
 =?utf-8?B?M1dGZ3RhMXJINGgxMUJVd3EyR2NEVUVCOHVFa2c3WUdHdmcrUEQxTzJCY2lX?=
 =?utf-8?B?UGVUSFN5MmZoNlhPbHR0d3Y5OFJFK3RRZEZCdGd1b2VUbnNTa1pwZ2d4ZmRR?=
 =?utf-8?B?L3BMVVhPMy9mc1h5SkVkeGVwQk9jUHZRaEFDMUlqOUNWczhBS3pxUmJWcERI?=
 =?utf-8?B?cEFHL0J1a2ZXY3ZwcWJmekwyQXFpbEdiOUJ2ZjJQRGo5NURMUmVabk8zdDc0?=
 =?utf-8?B?aW9sUXdtR1pzUDJCSkpHQmRqRmViR2MxaXdTVjJTSEJiL29mLzZxdXlNMXhr?=
 =?utf-8?B?ejJzRjdrZnprejVLTWc2cythaWd0eVVIdTBKbVN6c3pLYTZNR0lRWTJndWs0?=
 =?utf-8?B?K2VFTWxYcTFsamJNSUZmWFVwRDBLTjhFVURMUFVLdDF2MlhyMTYzbENaL0Jv?=
 =?utf-8?B?dzJyb21BdURxMmhOb1RWb0VVYXZOU2VGNDdkTkdFNTh1M1NWcVBZSmsycUkz?=
 =?utf-8?B?eVg0WGZPdnRMOERxbzJSekRpcVN0TWsrV1RCOFBudkdtRDNNQWRhWFI0M0J6?=
 =?utf-8?B?Tk5ubXpka0NveVJhaTh4ZXVDSU1jYjlTYVI3N1NNZGJVcGhmOFFocW90Q096?=
 =?utf-8?B?Q0g3TXpGS3Z1aW93WHVEa0lZaVovajJKOTUzMGN1aUNWQUdIZGxKSjZJRWdB?=
 =?utf-8?B?Q1k3Mm1ZVE9TWFA4MUF1UHNMM3ZtdE1QcWYyVnNmMlJDZFRvQ2lGOERxaEtK?=
 =?utf-8?B?dmpPVExFMFNJaHlXV05BY1hYbFlxVEExbUZNenZZaDNrbzBMajNpdklkV2Zl?=
 =?utf-8?B?ZDhrT0NFMnFuV0FldkpiaFdqOUtPczZ2b1VUYWt3WFoycHpLdnYrVHRId2s4?=
 =?utf-8?B?cW5PdzAvb1BWejhwRm5rVzVybXplVlAvcmJJem9ucVhXWTYzWisvT0NYaTA4?=
 =?utf-8?B?cmZycmZhWFVSOTBTQXJHNnRRbERmbXI3T2E3Zm9kQmdqMXhrUzkrclFEVXZ5?=
 =?utf-8?B?dXFHL2hteklGcVRtWWR3QjFlZkR4NStOQXBTNm9pZi9EZkFPTTY5emFuSDFS?=
 =?utf-8?B?eEE1VXVyTlN5RFJ6bzlnL0dxVDkvWitrR1pWdUJxNWppdHc5cmxWY0lFZmpR?=
 =?utf-8?B?dmRkV1ErTUpyMDVjV0w3RDRoaUVqMi9WQXQxWmorREljamxmbUdiTGIveWVh?=
 =?utf-8?B?SlNTQTFjK05xVFNxMWF3WTBLUENsSVVzZC95cXRybVhYd3BOb3NVUGlBOE44?=
 =?utf-8?B?eGJ3UHYxcVZ6dE8rd3FNL2pod1NOSnpLRFV5akdDRWNlWUxOZ2ozR3ZTalRz?=
 =?utf-8?Q?tBAicZHIAhE2dB7s=3D?=
X-Exchange-RoutingPolicyChecked: nyUYjJwiGvkknZaGlevcLebe14gatylJFWrElfzG38hdDBpGbgSU0MH+HaLHGsGGusxkAxLZOYbrNTWrngbZywyH6CnZ/sLe8Bl/wc5z65X5eaOkVGMnHZDJaQjS/NoPghy6hv7Vzg/RG5Gs3yF4s41mO9Y8zbLEnLBu6flDS5+Hl1GaAS753mTRSpXw1kdHU+28Zh39gdfIA5Yd7moceunIi91iZOPDQXwqn0ndqiIdYJAPMEJOkAnd6fKV0V1/VFkiPdUL8tHg2N5oPKLCdVkLVAndAfg2dJOgM4irQ3kbn9LLreHrBrxdD+XJOekseHiDO1Dol1WkFCQh+pq6gw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc6bfc0-a12a-464a-1ff5-08dec5b40ab9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:16:59.9357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imd8AnWUDyPr+BZMqv6ik7V52AyXJ/3bf5n1dRcO93RPkCfkX8ORH0Xg+3sVce0Xw4e/VHFKnTqEbg9XDm5MaC41w70A5qytE+M42IZFJEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6930
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> Drop the force_off assignment from all_regions_have_sufficient_rmid().

Apart from this being obvious from the patch, this is not how an x86 changelog
should be structured. Please see "Changelog" in
Documentation/process/maintainer-tip.rst

Please note that, after the preparatory fixes that are expected to land separately,
this will be the first patch of this series ... having this first patch just
kick off with "what changes" without any context is a difficult way for a
reviewer to start considering this piece of work.

> This preserves current single-enumeration behaviour while preparing for
> the upcoming per-mount enumeration, where latching force_off would
> incorrectly suppress re-enumeration on subsequent mounts - even when the
> user explicitly requested the feature via "rdt={feature}".

I believe that user space should still expect that rdt= options behave
consistently. So if user space for some reason provides: rdt=!mbm,mbm,!energy,energy
on a system that supports both then it should not be the case that one is enabled and the
other not.

I this think that, for example, enable_events() should start with:

	if (e->force_off && !e->force_on)
		return false;
 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 89b8b619d5d5..e2af700bca04 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -60,8 +60,8 @@ struct pmt_event {
>   *			data for all telemetry regions of type @pfname.
>   *			Valid if the system supports the event group,
>   *			NULL otherwise.
> - * @force_off:		True when "rdt" command line or architecture code disables
> - *			this event group due to insufficient RMIDs.
> + * @force_off:		True when "rdt" command line disables this event group
> + *			to avoid system limitations due to insufficient RMIDs.

From what I understand it is only architecture that can disable an event group
"to avoid system limitations due to insufficient RMIDs" and this capability is removed
in this patch. Above implies that this capability now needs to be implemented
by userspace, which I do not think is accurate?

>   * @force_on:		True when "rdt" command line overrides disable of this
>   *			event group.
>   * @guid:		Unique number per XML description file.
> @@ -214,10 +214,8 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
>  		if (!p->regions[i].addr)
>  			continue;
>  		tr = &p->regions[i];
> -		if (tr->num_rmids < e->num_rmid) {
> -			e->force_off = true;
> +		if (tr->num_rmids < e->num_rmid)
>  			return false;
> -		}
>  	}
>  
>  	return true;

Reinette
