Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB40191F92
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099248; cv=fail; b=bBsii9lfrao23uEXJYGQU/vk9qLE6e6mQauYrJp9P+U88NNYwXg2AsdJwVRvC4wNsvAIUgv/BUOin5qaSxAQZjUjf5Sh0c05FcBSoVF0LMaoewjfjZpbQONFBA33fKwbP0U0E1YpBqJYVyJSIv5Z6GtLMsOO1uJG+xWJ9GfL1sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099248; c=relaxed/simple;
	bh=EqgxphKzoTAefRw55/UE6tHgSAPA9cymtBXry2FoYCI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RWtAfi/6BkP3E98yRmhk4LJGXCPgklWONXoVnB3rjWJ6r3D/3Hpr9pqg54s895KPn7BlQJU+Jyp0ReIV/1JlKVAwnUcFhWKq+ZhRJJTZFVu51fsImZWo5qd7gJd86YdjQxpmxnYQG8q+DlfEp/ZbTVf1RPouy6vC2M3RJSrEy98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jGuaYiOQ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jGuaYiOQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099247; x=1783635247;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EqgxphKzoTAefRw55/UE6tHgSAPA9cymtBXry2FoYCI=;
  b=jGuaYiOQra7TWtveyYeN7Oyo/1+aK+XVQjtxyZ1MU3nYkpd2LM38Nh00
   UPYnulx2fZQzrXZmcxoXZIX6KH98FgnpjqUvNjca8bT1yoQSDp4H702Ed
   6nc0YfZo2GWC+8TgH5MND265K+YoeP6/V9JpCHGG4QPSUioGmzHNvpFCy
   yqyJStO4RuZygNLp+VpN8pFdNBO062rYzGjaMUMeWtz1worldKkLEgpgE
   DFa9Aa96B3vq+gfCS52end4dxcieBBrQVt+6FmfVY2twB6qlI87s2eWqs
   pXBxJBidwXbssDe5TmGn9tih8B5DrWSrM6eJoN6cdcQjS8qWICbGQ7Vx/
   w==;
X-CSE-ConnectionGUID: ZWdslcHbSS6dkFHTWx1hvQ==
X-CSE-MsgGUID: 6ZLVyqrQRuKflXCSx7x2Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54464881"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54464881"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:14:07 -0700
X-CSE-ConnectionGUID: eei/0locQcSD/Z/bIAzxzQ==
X-CSE-MsgGUID: btgAZjeTTzGnEb6LtYqQYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156032074"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:14:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:14:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:14:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:14:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j8gfhrraJqGXacmlWfYfcJRZ04hwCyLp6ZWD64V5k3ZnZwnswBYqCbzINciATqEM88y3SuSDFCK5MSpb1yzmkdVZ1KIZOf8v9b8DggHg1uQSmDIvrzWXhswKRlnKWJ6z1QI4I3OaBVrzNtrfLMilYXNSJPSVnxoNdVIIyp8zPfMDaHZ63LGCDWrHNJSVQgZ1bBgWd4cLQ5HQutXWGvOfdqA1zrDMOsUjw0Ze/AA8fYVpRVCn6oV2lgb2yZGeCwwbmbnH1aHxHbdYhHPTe5wA69GR5aMI4inMm5gTGsWTkpDE4rFzM3x74u0wqqqrGEQAUcDXbmTNewR2mu73hZ4Zwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtgSISzocxrrxYCdS1ynCeqGjNvE5DWHvoOzN0wezP4=;
 b=m4o2tqne+x1cdzN0Wzd8ttIy/kWI1NEWDXpG8NzjYnVrx40mVAbClTboXS3DxH+Hx1ucNE1ZjcXRJIZXznwZLpgq8Ac4TjcfErdj4G/AhmAd4Ppl0Emp+egPOhDLcSM/yMTvruLV0D/OgQ6sfMzBtwTT/tsOgw9t4O+G4GCxK8fWqwFWu9UnnWRU+vLZq6lIE41SkzX5FudDQsJxeL4sPNjKpz5a0JLHmVdHXTUIzvWCUhcMHUvuwy6HC27XorTpnMZyY/OnZWDx+H6JnCjKV/kl2/YxbEmkQUJil1FZ5eqd6VckbvzaQaPsks56KqOjxq1Mw1lMbfKc+SKFgmOpYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 22:13:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:13:22 +0000
Message-ID: <74a1e5f0-5484-4952-9a61-7a4e5b96b707@intel.com>
Date: Wed, 9 Jul 2025 15:13:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/30] x86/resctrl: Count valid telemetry aggregators
 per package
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-19-tony.luck@intel.com>
 <69f18b65-4e20-4383-a559-46fe1eda7db0@intel.com>
 <aG6xGGiOy3xKL-t4@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aG6xGGiOy3xKL-t4@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: ad0897da-afa9-44b8-ebf0-08ddbf35d111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MFNKdlV6Q3pvVTB2TmZ1L3ZYK0RPbWFJWWdIRVlDamxnR3Yvb2NHcDd3UEE2?=
 =?utf-8?B?M1VPYTlaQ3pEYlJIcWRBNWhWRUlRMW1KSC9wUTdCbEs4RUZRYjMzNkNQVlBW?=
 =?utf-8?B?bitpZklmZlFNYmdtRElPQXpLVFBsWWN6Qzh6aER0c25PODNrRVBhRTlHYlh2?=
 =?utf-8?B?TDNjaEtjMkJyUWhsSWlDdXZJSGZ2cnI2bTBwZkdUdThiaXdnQkE4YkhuVkRW?=
 =?utf-8?B?UHJYM2l4bE1XcURaVjFtTng3MkxVNisvWGZob08zclMyZDluajhZb2Q1NTVC?=
 =?utf-8?B?MWhqUS9tb0lDangvUjdiZzhScVYvc25Wajg3QjZIaVRmanFBUHA3S3RTUjFv?=
 =?utf-8?B?TkUvbG9YUTFFTTJudDkvampkVnUwUC95T0NmdjI5V2FuM2lRaE5lcDNUUXlX?=
 =?utf-8?B?NVRGeEFtdFdPNTZLdG9LZFRoRGkvanFGMVFpK3NzY3BvZDh0dnl2SzZ3d1Q1?=
 =?utf-8?B?WEw1Y1l0VmF0VUxHSjhhUmZGYjV4WExRYnQxRnJKNyt0T0d2d0E3UktuZ0tL?=
 =?utf-8?B?VFZOYkhnZ1djdC9vZFA4RWRRd3dKMkxnSnU0TFJwdm5MdGdDaC9hTDVJQSt6?=
 =?utf-8?B?ck9wd3VPZXR6YVJjeDcram9UbDVtWGhHSXVBR1FEYTdVS09HMWQyalZ5OW9L?=
 =?utf-8?B?MnhzcW5IVFhzSForaWY3Nm0yYkJNVTBJeXpscVJGSWRqcUxSTzk5UGRKYUIv?=
 =?utf-8?B?cjhwTGlqeGo1U0RiNXE2akRpVUxYdjV4TG9GUmV0Qy9QaDl3cDRYODJId1hj?=
 =?utf-8?B?VS9BZENsZGdKeDJBdExEYjBPQVZmeWdNREx6U0Z5M2dkWU9CbDRmUndoTm1q?=
 =?utf-8?B?dnpGc2dxZStDTHZicWhrSlgrcHNkQ1cwenBzUnc1azNXbzFnZGUvanU5K1NS?=
 =?utf-8?B?c2RYelV0clQxYWVpMFRaY3JmajBHZUN3K0ZpYWVCaUtxUnQ2ZkRvc3ppTGxU?=
 =?utf-8?B?MEU1cWxmRTJIQVBtbUhxK3ZXWEJzaTVGMnM1d0laVzZaTzV0KzNCeVZqMkxS?=
 =?utf-8?B?cHhjTnZpcWdmVGxGZzc3a25KblBvbGZxM0ZuOXd1OEhwM1RRemJhNmw1Q0ZF?=
 =?utf-8?B?TkgyYTRyOWlrSXJtQU5qUy8xd1ZMcWQ2TGRkNi9DaGc2TzBOSjRVcXF6eWxI?=
 =?utf-8?B?TnhvZVVVZTcyK2tuRnRDUDlUMWNpd3dWbzArdVc2U1ptM3Z4enkvWkxBc1ov?=
 =?utf-8?B?SEsvSzZHcjRzV0dEbncwbWFsTE5lOEczVUtJVzF0bnN3cG1JcW1lR1J6SGpo?=
 =?utf-8?B?K1k1ZXpSUnppWm5MbEl2eitWQ2xsakdHYTc5ZTFNNFRScEpCenJsZDFWV1g2?=
 =?utf-8?B?bWZxS0FBeTdrbGhrb1BrdXdJV1ZPYjBLcHgxY2V1eDl5Y05wTkp2OHVobWhQ?=
 =?utf-8?B?U2o0M2kwS3lPcUpySDNvbnVac2dNVHVRcnUxT0xIWWxRbXlFNDU5UDVnQ0ox?=
 =?utf-8?B?Y1A3NHRkZUpiYzc1NjdGenlsNHdHVkhxSGRWNzBkc1k3UkFZV3kwNXg5cktH?=
 =?utf-8?B?Ym5ya01HYS9ZczZQc0x6MGk1TkZmZ0pRdzNZd0NuYUlVdjZLeHNCME4xbkFC?=
 =?utf-8?B?aFdQQlh2cUhxRXRNU1o2ZXloTWpyL2pWVXNHcGdmaVJvek5wTk8xV0RjMU1o?=
 =?utf-8?B?Nnl2NFZVQlkyQjlSVG4rZ1pKMFkyZnJENEc3MWtHNnZJQ1lUcVBtalVVMThV?=
 =?utf-8?B?Nk5aSmpNOERoSkZnREp6dGRwRjdPTlVqOFhybmpQcTB3Umx5UDcxenhseldL?=
 =?utf-8?B?S1hjUmQveHM3ZkFTZ0hsclRoTU5hN2Q5ZjBuQ1AxMU41d3B3TW5pTmYrR2th?=
 =?utf-8?B?R3ZkRWg3eVh1VUJYZlB0R2NJMVljRFE4NGZwVGNaMXpveEs5bHlNeW5wZkhh?=
 =?utf-8?B?dUVkQ0FNVjRoK0lqRUlZU1duNlpMWWV2MTV3K2h4ZFQ1NjBUK1VldjN1YjBW?=
 =?utf-8?Q?Qw599QgveZA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEIzSnRLVk9JaHUxN2M1ekJ0OEY5eWNtU1NUNXhMZkVhbnI1UVNRdWxRWmpY?=
 =?utf-8?B?RXZsS2k0cUJzNC9XY3ZHOGdUT2o5MHMwMkwxU1lzdHRYbTFOR3FScytQSXA0?=
 =?utf-8?B?b3p0SDdRNlFjVVhTUkhxRVRGeU1ZdUpHNE0ybXlSOU5UTGpySjdvaHZ3Sk9x?=
 =?utf-8?B?UjVyL2EvWUNoQzk5MjVrZGRvWUNWZUpVZ2crVlorK0E1WTQ2S1FKUFczdkxZ?=
 =?utf-8?B?T1JoSWN5c1RQU2VXbXRoQ0t4QnJOaVhNeVM2REJZb21OZ0d5RExQd1VKZkcv?=
 =?utf-8?B?ZkZpc0VhdTJLVDJaaXplUitMZXVMRGpoZWl1d1FNUkUyY0dXQXg1eFJTRVda?=
 =?utf-8?B?a0FmeWlQQkpqMkJHYkpGaEpuRmRKckRhdGVVTksvOWhHUkZyMDhuT281YWpP?=
 =?utf-8?B?WldLVGlvREVQelE5WmZXaGV3bDdUZ0s3WWRUOE5ndUgvT1FiZTU1Y0FVR1Q4?=
 =?utf-8?B?Y3pwMjduQUcyZVZueWhlNXdpMjNhbTVHbFVFQmkyTlVUUlFxaU9wcjE5WnFR?=
 =?utf-8?B?VkRsbmpTTmZ5TlZTWEI5MTJkM3ZyRTBucUdFSU1IazlLNzlBeUR3RHEyS3E3?=
 =?utf-8?B?MExwSlZkQ3E5ZE9oZXZrWnNMb1RNdGpwMXhJNDBZeHYzYTM2bzdWSzJFeW0x?=
 =?utf-8?B?c1UvcjFsUm0reUszRVpOVjIrdEhDUDJrSnVJVnFna1Y0aHZOamVOcWNnQ1JJ?=
 =?utf-8?B?Y0YyZHIwNndMOXpZVjVGd2xNNHY3R1hseXNidis5U25lNi81Z1JOV1UvOGZn?=
 =?utf-8?B?UklUWDRDUzFEQVJDM2ZaTUYrZG5FOWhIeHRwZzJpbWdvVTJWRWdicTNnc1Bx?=
 =?utf-8?B?WUVXVmp2UkZnZVBYd05ZUFdEWW5PbGdXcmFzVXVXNnVvZkgrcjA5dWpwRjg0?=
 =?utf-8?B?NjhjSElLTU5nYm1aaldReEFzb0FBRXFuaWw0a01iSlU5c01DNitOQklhcU5T?=
 =?utf-8?B?SG9IbW1xSEZkUnRrRnJVb04wU2xpZXJIOUVBMHNPNFhFRWpubFpucVRRSU96?=
 =?utf-8?B?TXgyM3d2Z0pFUlBKb2RjOHFqV1Q2UEpZdFppTlJCMnFmR0lvRCtWQnRYTzM4?=
 =?utf-8?B?dmVTRzUzVFdKQU1DUGNyZy9UU0lkM0h3Z1hBclZ4ZmhNQ1lQQTA3SWpybXBh?=
 =?utf-8?B?ZFBVNjh2RFRlTjQ0SlRKclJRWFRyMWczb2xGU3duM3dTdHpPQmdndEpsV0hQ?=
 =?utf-8?B?UkVxYlkwdG1DeUJYQmFEUFoxcnR1UDRvR1RiYU0yQVd3QTdidFdhQXFTdDVU?=
 =?utf-8?B?TUhIWDhQUlBkMzJqelZjZkhZemV1RmRFRFlyeHVHUWVJZmN1L1QxK2ZRblRE?=
 =?utf-8?B?M1krSnk3VG9lWlZEZFhGTGRqU09RUGtYN3MvVXM5SDJsd21oYll2RDE3Tzg4?=
 =?utf-8?B?bllCTVZYa1dyUkd4MElOZGJBVUk4RTFVWEtVcDFqRVZ3ZzJCTXY5c1plUllh?=
 =?utf-8?B?R295ZFdVSnJpbFNFZllsUlBoMmtFU0d4U1M5WHNWcHN5MXhCdE9OS1kyNnJw?=
 =?utf-8?B?TEFJWitKVm5LUnhlNmlwb1c1eEVSNWVKbFFUM2RDcHJqcnlZWVh1Q3pYT0R3?=
 =?utf-8?B?K0J0MkxoZTZsQ3NUTEpqay9wcFFXY3g0ZlJjbzhwL2JrY21maWs5Rm9Pa0tN?=
 =?utf-8?B?NWhBTU82cTBGTzBjWkRJcVFVWndjbHh6NFgzc2NRQUw3WFhHNldSRHJ3WG9q?=
 =?utf-8?B?cTQ0ZmFpRTZ3YkVRckZ4R21BMWtMaXRpa1p0MHpVYkRpb1p5bFFpdUJOOEJU?=
 =?utf-8?B?Y1lRSGZydGk2OVN4bXpDakNpSlh5VWpGd2xWODRBengxSTNjK3NUWkdrK096?=
 =?utf-8?B?djlEek5NeXR4T0tDYmZlOENaRitUM0JVYTlHOGR2dUNITUJTa3B3ZVlIeGg4?=
 =?utf-8?B?Q084Vzd2LzMzRklPZ3dsdFoyQWtOeWtoS1JQWkFpdU9aMGRrTllTNW5pTjhw?=
 =?utf-8?B?c2hsZk9EbWJ6MWVHNFVGeGhmc1R3NXpUUnFzWFhPaGdNMkFlR29QdHFMMkty?=
 =?utf-8?B?RVRLdTR0ald5MWNrMnNzOWd4OFR1SGNackdRNCsraVdyQ2pkSzBHLzAxM2o4?=
 =?utf-8?B?K0laN1Z4TlduZEo0T1A1V0tqcVJjeFJOQzNrUWVUYVVsS0Q1RDhydWRPK2lq?=
 =?utf-8?B?QTBXTE1MTXlnaDBmdEs5SXpQd1E3cmpTVzNpYXFPYWdySnQ0MkFhV1loMER6?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0897da-afa9-44b8-ebf0-08ddbf35d111
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:13:22.0081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KB2KEOVo0rm+Mwrc8IZAQ0LrlRPIsffOSakPNMoFwVsGZ7i8/JBkYajQCOX1ubn6OUJJdGNwD1s4wA9KJzgQjTWNKUq/v28oHGhwa+XfW3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Hi Tony,

On 7/9/25 11:12 AM, Luck, Tony wrote:
> On Tue, Jul 08, 2025 at 07:20:35PM -0700, Reinette Chatre wrote:
>> As I understand there is 1:1 relationship between struct event_group and struct pmt_feature_group.
>> It thus seems unnecessary to loop through all the telemetry regions of a struct pmt_feature_group
>> if it is known to not be associated with the "event group"?
>> Could it be helpful to add a new (hardcoded) event_group::id that is of type enum pmt_feature_id
>> that can be used to ensure that only relevant struct pmt_feature_group is used to discover events
>> for a particular struct event_group?
>>
>> Another consideration is that this implementation seems to require that guids are unique across
>> all telemetry regions of all RMID telemetry features, is this guaranteed?
> 
> The guids are unique. The XML file tags them like this:
> 
> 	<TELEM:uniqueid>26557651</TELEM:uniqueid>

I interpret above that guid is expected to be unique for one
telemetry feature. It is not clear to me that it implies that the guid
is unique across all telemetry features. For example, what prevents
a platform from using the same guid for all the telemetry features it
supports?

> 
> the "guid" naming of the value comes from the Intel PMT_DISCOVERY driver.
> 
> An alternative to adding the new event_group::id field would be to
> separate the arrays of known event groups. I.e. change from:
> 
> static struct event_group *known_event_groups[] = {
>         &energy_0x26696143,
>         &perf_0x26557651,
> };
> 
> to
> 
> static struct event_group *known_energy_event_groups[] = {
>         &energy_0x26696143,
> };
> 
> static struct event_group *known_perf_event_groups[] = {
>         &perf_0x26557651,
> };
> 
> then only scan the appropriate array that matches the
> enum pmt_feature_id passed to get_pmt_feature().
> 
> 
> With only one option in each array today this looks
> like extra infrasctruture. But I already have a patch
> for the next generation system that adds another guid.

This also sounds good. Thank you.

Reinette

