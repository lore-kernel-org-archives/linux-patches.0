Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E1B86347
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438117; cv=fail; b=kkNubhagFUigKjEuUUy0d914HVxbAl8eN2aWBJSxCzZupCPE9W0M4sJNNqX2swY42G5bNj1iIjYnsamMUcWdQfaodP3ybZ4wGy4y5k4o0nKrpad2ZGX+848Saii7pEw7jGKKMm3Ltya4lyPvWHhke09kdaFCRTmE8bu10OHdCOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438117; c=relaxed/simple;
	bh=mUOtnJfzo0slfm0y/njX2YM0GdBoLD51gDLdhY6VDKY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C+7mx4WHCGF3suvK951ERdPmsaEZxApGFA7KJnAG7PL1V+wbYBjZhBpkbR8T75MqXAx8Uwmvb4/M3TLpnY2HO3Ujeh0fi03dldo/Jaar+cv5fYcZ7hdMH+zvx6gDSvc/k7k3GZxM6JTllXv/hC+pw5zHjYyM0Vmh1TppAlA+BeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U5gShHbp; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U5gShHbp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743438116; x=1774974116;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mUOtnJfzo0slfm0y/njX2YM0GdBoLD51gDLdhY6VDKY=;
  b=U5gShHbpu7PjIptxrZpWTBpi7olBNykViokZCjcGH2Kb8neNyXycPp+4
   BXOxZgpHuaZjT84F60ejYgz6ijsbdGxTDdY7tp6yRtfA9+BKaLa3h2bzp
   EI3yivKr4GhyeMrQjDKjCkJJT0L5Cp0Cv+23QEVtgZyHpQ6oEttJok0hc
   cGr1iAYJppfOR9wRUsy6Ncj26WqhLh7HuVN9YDGVXhPgtga1buT/mIvUd
   /U2W9GrQ0POf+WJcFNtigZ7+w/wxa+bjLropj1XX1N+fj18cZ4iFupOUg
   dkjx5sipL7hIgjyHBt7HLsKPNmyGWFhTfoaC4xyKkFDBu1H5k9iohcJgK
   A==;
X-CSE-ConnectionGUID: +i14YKELQomB2Pk/goZaAg==
X-CSE-MsgGUID: i6srdjR5SjmxiFDUmWKpNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="48604490"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="48604490"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:21:55 -0700
X-CSE-ConnectionGUID: dSH3mP1BTSGFb8engRvUOw==
X-CSE-MsgGUID: syPd+PhlQxyMdwWdC/tF0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="125952984"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:21:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 09:21:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:21:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtAOhdtMjFw11tdmmkHbE5OWHA25J0JtBr/b+sqmL5BHFc0i0ADvbGGEJzXoECrz0BHUGNtWZW4nzcyJiJjVQdD9bsimIVEPkVCOESkIqkvDb6ivqXdXOYKVrhEPpt5EpfTmofNeiwX+ZKQjicGEMXIEzrlwST5hSx26pEl73+cowZAXmnlDGS4FBO6vOJaDRxpcq8D1pfZc32znNcQJyNExNKqFYhSByoOdnPMWw5VDfM0VWgxwAer3QNil0u0kMq2xstXkVodaUDN26fN6P+YhuVL8Vm8HkFPD4Uk0ynAhlccWvQhynd9+OUAi6WOsQwowHD4+mgwesYVNGdhGEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8J+UvMa6fFPnjNoCPKaJBSrj1QEJzTl4M8X7pOKBP4=;
 b=qPCQNgNQVV98EP9c721JIGBVacFz5wRZ4uOTonRQaE9IKhCeB2wcXklsN5MonmkmuBhs4SZlsPNcIGsFd/bcSOwpwV67oofSMxSkuS3p63L8z8bSxRwzK9dN6aRbu8NCc8K2Y9ZWCYuH6VQ/8BUOAYVgwzgs3/QG+Azm+2hwiHlWuznXWIeXV6Lm2CThozpZfi3Tma5RDYN9AsUz6vlbc1rIya9r3FSWxBOabGvIEzypAB8mB5ora615a/sRqbg/UIxxDCNyCGqDs1FXQp8cJZtppJI5fG4prx2QXN9cB1plLAhApFz1r8ife4rTv6Eu8Ms3zJ/xEVO4KAhuh6cVRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6440.namprd11.prod.outlook.com (2603:10b6:930:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:21:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:21:51 +0000
Message-ID: <cbd8198d-467b-456e-b329-baf6ac5cff82@intel.com>
Date: Mon, 31 Mar 2025 09:21:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/16] x86/resctrl: Allocate per-package structures for
 known events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0137.namprd04.prod.outlook.com
 (2603:10b6:303:84::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: dde106d4-7834-4574-8924-08dd707024b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MmVqbU14WUFKRE1NS1Z5MzBJZ1ZCT0tIMlZHQnZDcTcwcE5ERGYvdS84TW1N?=
 =?utf-8?B?RVl6N0p2dHBWSzNIQTlnTjhHQjVCY2FOanhrOVBOa2hXMHRvVjVsaEZvYysx?=
 =?utf-8?B?SExSZWlCajA3SS9IUUtjdXRmQzdOb1lpYTlmTXIzMWllaE43MWs2NUJBck9n?=
 =?utf-8?B?ZWhaZXN4aDN4ZkJFMUFhcEgwK2ZMYVlvNTZUc0Jlb1pHTVFsbm5CRjBCbldo?=
 =?utf-8?B?M2VibVk0VmZQVmQzYWxqQ2t1dTdjT1NJNTdwc3l6bXpRcDdQUmlRZXFXMndF?=
 =?utf-8?B?U3pDWFhDanc0aVVhOEtRY0FPeWg4M0g5ZjV0Q2pKRXAwaGpqMWdaaXRIdTJN?=
 =?utf-8?B?N294WStxbGhWRVZjK01SOXk1UEJnRk8vRVd6RzcwRVhTOXpzZjVURHI3Uytl?=
 =?utf-8?B?eDF6ZFljS2s4emZYMm9oZm1Xd3l2NjR4cFcwbzV2Z2w2VUtJa1pKZkwwajN6?=
 =?utf-8?B?d2d1SW8zNW5EUVp5VDFWZWVXRkpaYUd3UTBIM1hxUUpScnREY0dFMUpNQXdW?=
 =?utf-8?B?M1JVdzc4bng2eTh0bytvMVZNVloweThwa1puWkNNak1TUW9NbUVtYnZlQlJt?=
 =?utf-8?B?N0g5Yy9jeXpOZHZzMTNWUjhvdE5JcWxzZG9GVlJVcFkyY1hvNGlMUnIvS1Uw?=
 =?utf-8?B?a3c5Mmp2YUt1amQrRDBTdVp3YTlrSHJ0U3RvbmlCL2F2VnlWRFJyRGtTazRF?=
 =?utf-8?B?amZtM2lCdy9EWVBadHpHbXdDL0o4bjhPeTUzQmRDMkxhRDhmV2p5b3pUM01x?=
 =?utf-8?B?SExwTmY1UjVZZ2xrS1lGU2puVWV4NXJSdWE4N0NRTmdyM3YvTUl6TGdLS3pn?=
 =?utf-8?B?WlZSRHJCQm1ZSHVKQWtkblpnYlJwWGt5V2xZTGJLcDNoT0NtZ1NYTTdCTU9n?=
 =?utf-8?B?VWE2UC8rQkRxTEZsT05ZUGw2TTk0MU12WHdmd20yYWt1a3NmN3J1MEtuYWt3?=
 =?utf-8?B?dXI5ZXcwU0JYY0ZQMmR3Wm85N1Z5VXd5aldyS0FQckNQdlI1dWxBc216cW1C?=
 =?utf-8?B?WGEvOXhxanRTR1BSWHpyMGxlNXhCVnQyS1M5eDYrZ29uZm9QVlFyOEtLWHlp?=
 =?utf-8?B?Y1IyWDBLT1JEZFVSblVUSUpOUUQrdkhPY1BscHgxdmZMWTcvYk1qR1F6WDND?=
 =?utf-8?B?cVBWbmRKc2xkUHVVMjhOWWJSc2tiM2VCM05sZG1kUjFET1IwNCt6ZDhJSWlR?=
 =?utf-8?B?UUI2MHZVMDNKbW1Yb1JXTEJTSDNuZWhJMWJ4V1lLeTNuc2FEcGIrRHVpU1Ev?=
 =?utf-8?B?TW9NYUZsQTBBeDk0QnNXZTNRSTdCMHhNK09QSS9SM05PVmI1MnFNa1VMK2FU?=
 =?utf-8?B?V1lCbm9KSHNqRkZLdzNLZU9pckoyKytBV1E1Z1B5Sm9hVzREcFJGQlFrOUhE?=
 =?utf-8?B?ajlTZm5WQThIL0Qva05RYVByeCtLOER3a0thWU5NUktlQWVjL1RRK2JhZUtu?=
 =?utf-8?B?QjRxR2lTeHdSU2FsUFF0enRER0dzODMwTHV5ZExlaHNoYnFNUGszMksrSzhZ?=
 =?utf-8?B?c0tIbjlkOGh4eS9LUjN2bzZ2M1JoU2pEVXF2OHJpK1BKdndQVUpPTlhseE9z?=
 =?utf-8?B?L2RLUE9kbHpYQm93Yk1UbTYvZXZsK3d3NU9zOTBpbS94Q2NBSDcvSVdXa2hD?=
 =?utf-8?B?SU5OR3Y0NnNBQjZ3aDZaUktsU3FLbW9OdHlTa0N4MW1yZTZWTnNicnQyYXNp?=
 =?utf-8?B?emlFN2VkTzVSQmtVZWRDS0pKRU5kRUhnY2ZLUTJlZlZLUFJsSFdGVnZodUxW?=
 =?utf-8?B?K0xaL2FoNmV4T3dEOVVRMmpmUzgvNHA1NFlzbG9jUXYrcisvcGY4UjRqVmlF?=
 =?utf-8?B?eXVNcDJQVnA0MWxydlM5TVl0U2xwTDRkdTZBNXlncHRxSnpEQW9iRGZVN1kv?=
 =?utf-8?Q?nYcSElRqOULnm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXpud1lFcEI1UTlnTFhwRGNtN0x6WVd4bDRudzFTRWZyaXJmRzBYY0huYnE1?=
 =?utf-8?B?MnFuUjluYktaakROS0JabDgrYndERGVSRGJxazNVM2FjanFhSFNRVkJoazRN?=
 =?utf-8?B?a2FBd0UxQytCWldMY3NRSlkrWkNmL1g2MnZUUlpURFFRNmp5b1k1Lzd6T1Vp?=
 =?utf-8?B?QWJCRVVWdm83VVJqSmlGM0l5TjNlcDcyaWxhR3pkNkMzZXRTbkpDK0hjSHla?=
 =?utf-8?B?NUgwTlRON0JuenFXR1VTOGNEc0pseVg2S2ZsZFdmYnE0RDEvL1pYWG8rSkVl?=
 =?utf-8?B?OGZWYjJSSVdOM3ZmOG5EZDFpSjZMZVExKzJnTm5oYmdoaUxIQS9xR1RHNVdI?=
 =?utf-8?B?VHlMekhvTUtjOSs1bkFSZVR2RG1EcFRCdkxwYmtlSTQvbFdsQkVyT3kvKy91?=
 =?utf-8?B?b01vYVdBL1REK0toVEtNdHpGeHFYOHkrMGMwUFp4emcxbW8yeTRiMkdUbzBS?=
 =?utf-8?B?ZjZPUGt4YVBCdzNlekZ1bzI2dnd4Tm1XN2ZqMUdaL2ViSzZ6ZFJKbG9UMXM3?=
 =?utf-8?B?NFMzaVdKcVkzWVhpdlk1L2F5TlVNTlhvYTh0eUxTS3hqcjlSNndWWG41emhK?=
 =?utf-8?B?aEZDR1FYcW9PaHNBWmpERHhPWTlzYnZGeEhBWGd0M1N6UjJqL2FkcnVCb2Er?=
 =?utf-8?B?NTdpWFZ3NmlHaHU1a3ZlY3pnZFBzMzJEVmV2STdDVFYxeHJnMnl6aDVrTTRV?=
 =?utf-8?B?Y29IVnc0eW83U1BlUHhIS0dzWFdVK3FDa2kyQnEvM0ZOSHZVRk5VRzNTL3ZU?=
 =?utf-8?B?M3VjOUpFa3VzL3VJWGxUcHN5Q3IvUFRWWlpJbWFVTXBMNFRSUXRSQ1FKT0FK?=
 =?utf-8?B?Nm1Za0htYW5NTG5WTTlIUWx1cnVHZzRTajMrS2xLZlhBTFYzL1k3OHNmMWt3?=
 =?utf-8?B?U1UwSXoxVUlxeWFnUUZKMmhvZDdiVzhPUjhmWDM3V1FoM0pZTDFadTFiS0Jx?=
 =?utf-8?B?ZFNHR0YrdnNHTUhKd3JmeTFDTWNpS2V6RkhuRjZaQ25uZ1I3R0daNk1mZzJH?=
 =?utf-8?B?b0czTzBZQ3VOM3JwVUFyVndDRlBjYVY0Z2kyYTcrSHgwSGMyTjlGYitwbzhE?=
 =?utf-8?B?VFhYYk11eWtKQWZ5SVBTaHhaTG1WbHdZbCt2eUVBL2J0TUJuVG4va3BKN09z?=
 =?utf-8?B?djlBS1NNTUZEMFI4ZTNtU3RoUzQybHJIR21BSklDZzgrb0JySFhML2FrMzh3?=
 =?utf-8?B?amFManM1S2NFMWlnSklYN0VyWUxKa25NZTlzNFVNS0NTSkN0TlE1QThwRW40?=
 =?utf-8?B?dW1oRm5jeWkxMk9aOGF3S05TT3BUSFkwM1FwVEtWMmVBZFVJeC9yZWd1Ti9G?=
 =?utf-8?B?RmlraHpPemp0UVZZVnA1ZUJuLy8xTWhJQ2JqNW9IRWJUVllaUHp6YjZMbXRN?=
 =?utf-8?B?K2YrVUI4c0M5aFNpdmE3VUNxUStmc2YzaTBRU2JOSEx0TWRTUmpRNXJNVWF6?=
 =?utf-8?B?a1BnSGNzQ093Rk1rcVRjVktDOFZ6a0g3MG83YThCMnM0MTMyd2plUnZHR1dO?=
 =?utf-8?B?U3dxMXh5WVJDdytkQ2ZYN3BNQm1FeW93eU1GVlN1b3FBSjNueEMzbVlpWmdS?=
 =?utf-8?B?cFJGNTJ5U1U5a21HQU9PeElqVkZwcEFHUEdlMUJBQ0t0ZExvT01YK25HR2tD?=
 =?utf-8?B?R3Z4RkRjclh6SEVNUmkzZDBGL2svdUtMV2lNTG51d0hsSXJBMENDZWFxaVhF?=
 =?utf-8?B?Tk5QOUdmVmJyQlRLZzg3c2lPYWxwWWxBM05Bb2V5cVFYb3JqTEkxTEw2alY2?=
 =?utf-8?B?ZTN0VFFvaEh1TlRpbnVwZE14WWpDRDBYMDhjOUYyZ1JMNFlTSmUwM0tLY3Vt?=
 =?utf-8?B?SzdBbUx1WkNBU1o3WUhLWm94dU10c1Nhbll2NXF2dllOSHVSQnhSRk5yYmNR?=
 =?utf-8?B?TU9oVnRzT0pQTGZldDUyZHVrdnNIR0FnNEpKQ3BGeHNDMlpGcGNMRzkydG1Q?=
 =?utf-8?B?RjQvWHpsL0RsUzgwS0FOQndSRDBlWmNFdi9uNHdGWjRJMFlVL0NNbEhYZjNa?=
 =?utf-8?B?bTRoYys4UFpSRE1qb210UFBPRm5mZm80dkZGbXdhSzc4Y3E4UFpkdnJqS3Jl?=
 =?utf-8?B?NTZ0TmVweTZCSmZmNWEzUW5kUitEU283QkJMbDFNWUVHZVhMVkpHaTkybG1y?=
 =?utf-8?B?cS9hM1pYUE1DVUZlZmt3cVZONmZrb0dUbFo2ejRJc3FnYm1DVmRWRHY5QzIz?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dde106d4-7834-4574-8924-08dd707024b5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:21:51.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHaEDQ6PJKvrC93XM57WYHlb4Bq/JqGBXhMxEDe+REpJ4HXT7Bi/ZFChxmA6N7ouR5MAE7wfwfPtP+jl2Wm8bp3cn1fxkUCMUDbZKPXuHWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6440
X-OriginatorOrg: intel.com

hi Tony,

On 3/21/25 4:16 PM, Tony Luck wrote:
> Use the per-package counts of known events to allocate arrays to
> make a copy of just the known events.
> 
> Add hook into resctrl_exit() to cleanup.

(above is not done in patch)

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  2 +
>  arch/x86/kernel/cpu/resctrl/core.c      |  2 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 60 ++++++++++++++++++++++++-
>  3 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index ada402c7678b..2503a24e4177 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -170,8 +170,10 @@ int rdt_get_mon_l3_config(struct rdt_resource *r);
>  
>  #ifdef CONFIG_INTEL_AET_RESCTRL
>  int rdt_get_intel_aet_mon_config(void);
> +void rdt_intel_aet_exit(void);
>  #else
>  static inline int rdt_get_intel_aet_mon_config(void) { return 0; }
> +static inline void rdt_intel_aet_exit(void) { };
>  #endif
>  
>  bool rdt_cpu_has(int flag);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2adf40d8de32..d011c095aafa 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -1095,6 +1095,8 @@ static void __exit resctrl_arch_exit(void)
>  {
>  	cpuhp_remove_state(rdt_online);
>  
> +	rdt_intel_aet_exit();
> +
>  	resctrl_exit();
>  }
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 67862e81b9e0..e2d8eab997fc 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -188,6 +188,26 @@ static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_
>  	return found;
>  }
>  
> +static int setup(struct pkg_info *pkg, int pkgnum, struct pmt_feature_group *p, int slot)

Could you please add a comment to this function to explain what it does?

> +{
> +	struct telem_entry **tentry;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		for (tentry = telem_entry; *tentry; tentry++) {
> +			if (!(*tentry)->active)
> +				continue;
> +			if (pkgnum != p->regions[i].plat_info.package_id)
> +				continue;
> +			if (p->regions[i].guid != (*tentry)->guid)
> +				continue;
> +
> +			pkg[pkgnum].regions[slot++] =  p->regions[i];
> +		}
> +	}
> +
> +	return slot;
> +}
> +
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
>  	if (!IS_ERR_OR_NULL(_T))					\
>  		intel_pmt_put_feature_group(_T))
> @@ -202,6 +222,8 @@ static bool get_events(void)
>  	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
>  	int num_pkgs = topology_max_packages();
>  	struct pkg_info *pkg __free(kfree) = NULL;
> +	bool found_known_features = false;
> +	int i, slot;
>  
>  	pkg = kmalloc_array(num_pkgs, sizeof(*pkg_info), GFP_KERNEL | __GFP_ZERO);
>  	if (!pkg)
> @@ -220,13 +242,32 @@ static bool get_events(void)
>  		if (!count_events(pkg, num_pkgs, p2))
>  			intel_pmt_put_feature_group(no_free_ptr(p2));
>  
> +	for (i = 0; i < num_pkgs; i++) {
> +		if (!pkg[i].count)
> +			continue;
> +		found_known_features = true;
> +		pkg[i].regions = kmalloc_array(pkg[i].count, sizeof(*pkg[i].regions), GFP_KERNEL);
> +		if (!pkg[i].regions)
> +			goto fail;
> +
> +		slot = 0;
> +		if (!IS_ERR_VALUE(p1))
> +			slot = setup(pkg, i, p1, slot);
> +		if (!IS_ERR_VALUE(p2))
> +			slot = setup(pkg, i, p2, slot);
> +	}
> +
>  	if (!IS_ERR_OR_NULL(p1))
>  		feat_energy = no_free_ptr(p1);
>  	if (!IS_ERR_OR_NULL(p2))
>  		feat_perf = no_free_ptr(p2);
>  	pkg_info = no_free_ptr(pkg);
>  
> -	return true;
> +	return found_known_features;
> +fail:

include/linux/cleanup.h has this to say about mixing goto and free helpers:
"convert all resources that need a "goto" cleanup to scope-based cleanup, or convert
none of them"

> +	while (--i > 0)
> +		kfree(pkg[i].regions);
> +	return false;
>  }
>  
>  /*
> @@ -242,6 +283,23 @@ int rdt_get_intel_aet_mon_config(void)
>  	return 1;
>  }
>  
> +/* Clean up when resctrl shuts down completely */
> +void rdt_intel_aet_exit(void)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	if (pkg_info) {
> +		for (int i = 0; i < num_pkgs; i++)
> +			kfree(pkg_info[i].regions);
> +		kfree(pkg_info);
> +	}
> +
> +	if (feat_energy)
> +		intel_pmt_put_feature_group(feat_energy);
> +	if (feat_perf)
> +		intel_pmt_put_feature_group(feat_perf);
> +}
> +
>  /*
>   * Late (first mount) initialization. Safe to ask OOBMSM which telemetry
>   * event groups are supported.

Reinette
