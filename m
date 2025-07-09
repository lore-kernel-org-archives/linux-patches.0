Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAFB23F27B
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099315; cv=fail; b=HDbLfZMDWX2DbuaCrQbkw6cG4iFzQyeLD65Zan1gblE9F1+ahXMG1sB10ffI9ZFOLOeNUGYGP9AK9HAN4rCNedgEi5fxhlbx2l38pmL6+ZVujjiXqjdV4jAHMcb9nVQzfMFEciEMaPKzHyJlB3LTnbAlpS6YmX2ZWN7WFgFRUOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099315; c=relaxed/simple;
	bh=xaJZyCYsXctxvWWJA5SeOmvk4Pn0fbCvITYQYZdVqL8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z33dEbf72nmwLioYzaxNhHWuIPBhKb/l6GgiQhDPl6mGMY6nW1H3AgUNZvlTor/8t/v9ew+1Gry/M8LyVGFLCIkmoZpWdktpw7rnIBX3l1nFo0KFvba6p9ndd9UmKHkoip9IO+iSP7u59lWDSUv8KbI2DApFU346cnav/4s0zQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQlqRG3Q; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQlqRG3Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099315; x=1783635315;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xaJZyCYsXctxvWWJA5SeOmvk4Pn0fbCvITYQYZdVqL8=;
  b=aQlqRG3QUM+gu3ceViYjQMyYLnCh865VpgHF4a5VFbldhP5y3+9/NoZM
   KD1RmTIhfGB57lQY4atvMFK+RQHxzvN3C6UNOcld3cEJ9mYBahJDMsVoH
   McX4jq/MZyRBq/VyP0hEpiR19U6DLcD6eZz5rwxdRTU16NAsCf2WKt0X1
   AsRZVL1wt2/QlNP3sv0lDTmUPoRfXvE19qUYNqw0cTU0ZwqcsfBKXaoUj
   uo1+NFB6JYYjMZY15HPaUXvHj5pUKH/x0+I91ghjzbkXxXuQG0S66TZ/g
   OEImxjvmXbRyn7+e+f6Vg+KYaThYMsbp/oEd/hQBj3gAptVd++oCiPh4R
   g==;
X-CSE-ConnectionGUID: Io18Y4EiR6uYekNyyfy96A==
X-CSE-MsgGUID: wxpozTK/R2eO9QdyyME/gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54501016"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54501016"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:15:12 -0700
X-CSE-ConnectionGUID: dcUfPk4YRhWBwoThjXqNdA==
X-CSE-MsgGUID: HKhJ5yiXReiLoBJcXgzE5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156626903"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:15:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:15:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:15:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:15:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/7r05bmfiW8mhmPYaHLYbN+HrWETzQ0F9D8Lqg+o0uj2h+hjFo3+lUZ+52mUDknnJDJ+eZRweeN5WYOedInDdGeEZO8wk/6eo4PCsTj8sLg97nRXR00TFC8YHDVl8czcKkazkVbYYvjHYvyDVbGIKRdOMMGBg6K1SJTujMVdGZ68xYnav+UR5Qo0WhVCY+55mlCtK5u/iMcviyigK33Xywr+HZMDMuuiNQ6To/8bLsqpYB1V9RF59FVG6Bp3O7FesqoIV8EJCUhdDup6lhxroTnNwNO80hQ0piFFYzr1C1l2B8i1Vp4knNVyQWDGTkgJaQjpP7wD7YaQnlUQ4J4yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWBvm72DI2Y/6wSc+WiDRS4yfUQ4QbBud+Oi4fOK1OQ=;
 b=aSCno3r6JJqs1zYuYKkzb+8ky24sVfSamKsS4rMz7JKqZV4XOa6QQdhfw/N3mTolmBBMcYClfgX/Ukm1xACTPN3ws4J46E6MFPi6aZ8kx3rU//Lm7FTrRNlwWSCTVUsaQuPTS3qpFVCCLuionc7KQ7BENLfSPRYLHJbv6ce8qabJQ0KDkUrPLW30L+bNM5r/TZebWP2m9v15qDuev9E72zuwSlIP6kZXCmjOeySavPN4ov3Ww10SEu4r6qEPNfE9hDxglgu2pbQTlMzDgMNFcZsBM1GkT9DGKVvX/FGNjB6MutJjvR4w6NpX7pBatyPiA0Gk+ju6dDW/XKhd6OMOpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 22:14:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:14:54 +0000
Message-ID: <f95e4868-0f87-4b58-b4a8-4fd18dcbf6ad@intel.com>
Date: Wed, 9 Jul 2025 15:14:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 24/30] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0150.namprd04.prod.outlook.com
 (2603:10b6:303:84::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 006f2990-b881-441f-925b-08ddbf36083b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cmJtdUFsQTRDc1FreWFLeXc1L1NPRVVQendWSy9sYjN1M01BZTFDOEFCb2xX?=
 =?utf-8?B?ZTJwenpUZkVFTHBqOG1mNkxPdU9JV3ltTm1FeldvYXpRZFR3N1hZTjBQVGtp?=
 =?utf-8?B?QVgxc0ttU1V5akJBRTkrV0hBYzJPSGp2Mmlhb2V2WUE4dFkzTlFVN2NzcFFN?=
 =?utf-8?B?bmMxcjFsZksxUHA3endXZG1iSU1qakdYQnBOakdYeEsyL3NjQWlrRWVYT3Vw?=
 =?utf-8?B?WlZPUHRqVkRkUXBhTnh3c3F2S1ZPcGFpU3NqMGIyNTFCVkVtcTd0WWpQVGdX?=
 =?utf-8?B?WnEwdlRGc3ZOMWRoam43aXlpbTUyWGpseDNwZDVHQ3gvai8zSVdRS1BRV1h2?=
 =?utf-8?B?VEJXVTZYZm54RXJrRnErak1hN0VDZ1lVaEkzbU9YNWNUQUhPS2I3TDFzWXZw?=
 =?utf-8?B?cERzTVdJcWc4TUNrV0s1SHdUM2hEbDNiNUpiTmpqOWVGakxWWnZBelVYRjhG?=
 =?utf-8?B?Tmo0NHI3TWZkSTFxUzE0bHgzQlFUcjJndThCVi9XT0p0NVJVS3luRFRtSENU?=
 =?utf-8?B?Z3ZSUHNuUlhnS1pSelFqMC9LdzgzOVNicXhFQUw3aDVEajJnTWczenZnWGdv?=
 =?utf-8?B?c3YwbGdpeHBnQlg2Njh0OXF6VDFSY3hXTG9TNDBmMXBIVm4xdDVEZktRUkJY?=
 =?utf-8?B?RlpZTGtaN2s0OEthcW42U2E4NlNLRUNuVUtNWExHanpZSFdITjFqMUw0dExF?=
 =?utf-8?B?c1FlNURiTVBMb3E3N2ZkV2VmUzNmRGc0d21zZ2RnSEFSRjBlQXlLUEkrNUVW?=
 =?utf-8?B?WExEOHEzL3h5VTZVY2p0YjNDYndlNDRkQWVpKzlCMnFGR0ZHYlJtVUwvZkU2?=
 =?utf-8?B?ZzNBOHVGS3RxQnVQWmErckoxVWZ1d1BiQ0ZuV2xGSXBCRldvZ1VNQWxrNjlC?=
 =?utf-8?B?MEV1eUt2YUthbG1OMVdkSHFrNlYzcUdYNUs0UFdyRE5VT043K0ZsN1ErV0xO?=
 =?utf-8?B?K3V1a3l5QWhSdmhNOERjbkZWbWQ5QUhSMDlvZTU0eG50OFg1Vlg5ekdCTG82?=
 =?utf-8?B?ZVFSVk5DRGhVcmhOWnhkUnh2Wk9nS1dIRVNyaWJvdi9LSm5DczZYQU8zd0FE?=
 =?utf-8?B?VGppTHJJVWJHRjk0THpmbmJ0Q3R6K1IwNXZERkpkZHFoU3dkNVA5Rm9Xbys5?=
 =?utf-8?B?UHlmRnpuamUvWFhtNHdhajBZaE5PUDd4cnhvcTkxK1N1S1hxK3ZTTGkwT0x1?=
 =?utf-8?B?Q0RudmlJaEJxeVZ3bGswRFFKc0haTlNobEpLaUhjZDRwWDJTaUVGQXJCUCtt?=
 =?utf-8?B?RWhMN1Q1WFZUaklhUEtKQ05kSjJ5ZmZ2UllOOTNyTThlUWQ5aDlhWXVpcDkw?=
 =?utf-8?B?WXN0cXF5aWlsYzZuNndML0NlYUlPajg4YkhYOGwyVUZlSVowZEhyVkF1Nmk1?=
 =?utf-8?B?TzR2WFhseStmdExwYmJTZ2dEZnRsdEYwSWVDMXlvRkw2eW5ad05meGNjcGdU?=
 =?utf-8?B?K0t0SFVnOVNGeUl2aEdmTzJ2TlJtclNrcUJpYWhMajN0SE45NFlQMzBPb25C?=
 =?utf-8?B?SkxhWGJWblV6bmtCbzBxUGx3eWFOanE0eUwwVTZUL0REYUZKOWQvejRIYnVE?=
 =?utf-8?B?RmlGbGFXWHhRSzRhcmc0UjRZT3pzWnRCK3BDalkrQ1Y5dTgveEd4TzJ0NHVz?=
 =?utf-8?B?eFA1MmpJeWM2Mi9DZWIvdjhuZmxqWXNiSkwxcjBBRVIxczhIbTBCcjJPOFlB?=
 =?utf-8?B?YVpqeUc3c3dUVFpOWGhCVi9PL0l3cVd6eVVkM2ZGdktKNTkzTTBqbTVaY3Zq?=
 =?utf-8?B?OXcwK1pHZlNpVlRSZHpjYjZtNTlaZTJMVnROeDBwemYvOGI0dXVEbytyUHEv?=
 =?utf-8?B?OE56VnVXZ0x0M1ArS0JGbkRFbDU0V1c2WDFCQkF0cHAySlV5NGcvbjlXNTY3?=
 =?utf-8?B?TUZSSU1CdnJvUDlIUEk4czhSWXZ5N3JoS2NWbnlBK0c0WjFNZjZVRi9tS1Vl?=
 =?utf-8?B?TXcwd2ZHME1ZakJua2lIaEtnQ3c3V2RGWXNweFlWMHRmNmdYRDhkLytYY3NO?=
 =?utf-8?B?dW9YajFFdVhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVlTaVVYZVVBV2hIaTdhR3A4ZzViZytWalRMek1GcmhEMkNwUldUeUNqdUZS?=
 =?utf-8?B?TzBRa29yblZmdVc0SDl1YnA5RjhmSmFMK01FdzBWd3p2Y2ozRGRsZFNSVVBo?=
 =?utf-8?B?RlRlVitQK1YvV1VaY2RuZU5CL1p2WlhDN2cveEtZeTVVS3oxejlIeFJrUEtP?=
 =?utf-8?B?UGFETkZOQ3BXSXViTHZqbXArTzBhR2pod2xKS2gwWXU0Sy9FZnppclJheXBo?=
 =?utf-8?B?Z2NON211M2hlbGJ0dWlEYmdCYjFHS1lZN2psbjZBYVkvTGlUU0N5T05jMEZK?=
 =?utf-8?B?S2pEa0w0c0RERVdETHRLUTBOMUM5Z3ZiQlRDZkFxVFlzUkwyNkZqY3Y5c0Qz?=
 =?utf-8?B?MXJYb0xzemp2K1l2M01LaiszdW5pc01hVDFZTlVGc3RrREgxcDYyaWdNa0VD?=
 =?utf-8?B?K29Zd2hPa1ZEbEo3Smk1cU8xV1hYTFp5MUpESGsrNEZoS1dhdnllNlovTEhH?=
 =?utf-8?B?TmZiL3V4K0JvK1p1dTlZc3VHclNONVpEbXA2U2VUWWRIV25tWFB1andDKzZo?=
 =?utf-8?B?TFNQb0JzWWxCSEEvam1pOTl3OGQ1QktDOFNyYjFuUm9NQXpoQ1duSlFTMHNZ?=
 =?utf-8?B?SVl2RnNqN1JGd3lKdTVmK3g0NW52bjhBRzlQYWFkMzY4bjdudjI2d2lZQ0dX?=
 =?utf-8?B?MFNzTzNXN2pDU0lUdDYwQ2FZazM5NVhrUWZiTXY1RXFUSGl0cDBLZWlMaitI?=
 =?utf-8?B?QzZGM2hyakdiOHVLb0J2UTQ4THQ0SjlqZHNSVHFJaW0wU1RWN2ExdjdjL1ZR?=
 =?utf-8?B?T01XcDI5bDY1dGZmZmZERlZvZ0pyZHVDVXI1aDBqR2dmRFFQYjlkUGQvZDN6?=
 =?utf-8?B?bW5nQTZSeSt4Lzl0V0pRS0F3SzUra3k4U0w5eWNJQ1QzMmhPTG4wZ3ZYMy90?=
 =?utf-8?B?WlhlMGIvMHMrK1VUQlBnTytTSmF4NHcxSnh1b0hOdjF1Y1lxTitYb20zSkl0?=
 =?utf-8?B?ZFYvR3djdlgvMlowcTliekZHVExGZGVpU0xsMWU0cityaTJ1cHJHU2Z1TUVE?=
 =?utf-8?B?c1VoU1M4ZCtzOXFCcEVYNWNQaXZ0dC93UldLc3pHQ2VCbk5acDVpZzNLSVdX?=
 =?utf-8?B?UkVSbkFIL0JvRW42dXoxUWtvcHg2bEpQNHFHaGtDdHFKRlI5TjJFaTlCNnEw?=
 =?utf-8?B?YWVGMG9VOGlqa3hJbEdBUGtqUXRWaEJFUVF3QXZuNkpPMC9LRGhzVHg4UmJF?=
 =?utf-8?B?YlVQR1Vqa3RCZGp1b2ZaWEZoRnFQSXdwM3JZUUtlZmdoT0RwSlNqVkVKeXRi?=
 =?utf-8?B?enFlSTBOQmlTQzl3TkgxdGFPcWV6cS82dTNiTVBLbTR2Y3ovMmRYS0tsWGFT?=
 =?utf-8?B?blo2ZnBVNEtXQnR1dE1LZXh6OG9vYjluNnhWMUhwSXM2UlN0WjloeTUzWTZV?=
 =?utf-8?B?SHl5S2RKdk0vR081dm5MWkhnYkUybW9VRzFtM09jbUs5czl4ODZua2xweWIv?=
 =?utf-8?B?SGYwZFAwME5ibWRGWmsrNjZoN00zN1ZpUkE2KzlYMjdReXlrMGNyTW1pckti?=
 =?utf-8?B?OVJpKzdTZDF5NjhWL3JYaVEzUkdzbklwV01XcmRXaE9jKzRCcklYbE5URisz?=
 =?utf-8?B?ZkZLNUZjOSsyWVNqWStDMmxWd1d2VnBKZ2grVWhJdUM4ZTBFWE9HZitpWDFx?=
 =?utf-8?B?cWFxVFFkNWtKeXNJUmpIRjRnVis0dTBBU0RBV1YrYVFSR0hQazFKcFFTMG52?=
 =?utf-8?B?MGZUaDE4Q3pWTEtYYmxtSEFNOTBzbExyYTZFUUEvck1tbVFSaHB1eTZTa0l6?=
 =?utf-8?B?UGNsTi9NNXd0Y2ZiNmUyWS9TeEw4TmwvYzJIdUw0SmZjamZucVRHYkxPOUFB?=
 =?utf-8?B?anJTYy9zMG9xZGhJbktSSkhBK2R1VVU3R2hwRDNPREt6bjZBRElzRHNBN3lt?=
 =?utf-8?B?eUM5VDRWTEtKTVc0aXVvMkkxazQ3dy9DOE5sVXNCQ1VHeFo5M2JzWUxWRTJj?=
 =?utf-8?B?Y3ZoaUdjODBiMnhrMGhBRG4xcUdkbjZSUmJmVmd6UkFMZDBVeTNackZtajZF?=
 =?utf-8?B?cTlSRHliRVNqMzVFcEw0R3hFVE1aQ0c2Tnl1OUxhb0U3ZTU1bzVxRnl3R1hr?=
 =?utf-8?B?VU4rOU50VzE1SGZaRnl6K3B6L2dZNVE4WlJGODl4TmI0OEhad1pHd3Q5citB?=
 =?utf-8?B?TURHQkEwUndRZGNWSWIrSUNhUEg0NlhxQ3MyRk80dW5xU1l1bjY4YVZUbW9m?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 006f2990-b881-441f-925b-08ddbf36083b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:14:54.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hDO+YDpDFY/gsEc22wwZK5MbGtwJX/WSfIuxwsZ+x9nMwhNu6xxf+pkgD3kUPQTndM6k5h88R/rdxtkK5EB0ootHoRyllXGZxY+nv8gsQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Hardware backed resctrl features are enumerated by X86_FEATURE_*
> flags. These may be overridden by quirks to disable features in the case
> of errata.
> 
> Users can use kernel command line options to either disable a feature,
> or to force enable a feature that was disabled by a quirk.
> 
> Provide similar functionality for software defined features that do not
> have an X86_FEATURE_* flag.
> 
> Unlike other options that are tied to X86_FEATURE_* flags, these must be
> queried by name. Add rdt_is_software_feature_enabled() to check whether
> quirks or kernel command line have disabled a feature. Just like the
> hardware feature options the command line enable overrides quirk disable.

Referring to "Intel Application Energy Telemetry" as a software feature does
not sound right. It is a hardware feature, no? Perhaps just "a hardware feature
that does not have a X86_FEATURE_* flag"? With this rdt_is_software_feature_enabled()
could perhaps just be rdt_is_feature_enabled() (open to other ideas)?

The idea that a "software feature" may have a "quirk" also sounds wrong ...
to me that sounds like a different way of saying a "software bug" and we do not
handle software bugs with quirks. Referring to it as a "software feature" just
does not sound right.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c            | 30 +++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c       |  7 +++++
>  4 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index f1f2c0874da9..4c12159f3ea0 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6066,7 +6066,7 @@
>  	rdt=		[HW,X86,RDT]
>  			Turn on/off individual RDT features. List is:
>  			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec.
> +			mba, smba, bmec, energy, perf.
>  			E.g. to turn on cmt and turn off mba use:
>  				rdt=cmt,!mba
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e8d2a754bc0c..ee1c6204722e 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -169,6 +169,8 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +bool rdt_is_software_feature_enabled(char *option);
> +
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index f857f92e7b8b..f9f3bc58290e 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -791,6 +791,8 @@ enum {
>  	RDT_FLAG_MBA,
>  	RDT_FLAG_SMBA,
>  	RDT_FLAG_BMEC,
> +	RDT_FLAG_ENERGY,
> +	RDT_FLAG_PERF,
>  };
>  
>  #define RDT_OPT(idx, n, f)	\
> @@ -816,6 +818,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
>  	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
>  	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
>  	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
> +	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
> +	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
>  };
>  #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
>  
> @@ -865,6 +869,32 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +/*
> + * Software options that are not based on X86_FEATURE_* bits.

"Hardware features that do not have X86_FEATURE_* bits"?

> + * There is no "h/w does not support this at all" case.
> + * Assume that the caller has already determined that s/w

(please expand h/w to hardware, s/w to software)

> + * support is present and just needs to check if the option has been

Looking at how this function is used I rather interpret
intel_pmt_get_regions_by_feature() as determining that hardware
support is present.

> + * disabled by a quirk that has not been overridden * by a command

(stray *)

> + * line option.
> + */
> +bool rdt_is_software_feature_enabled(char *name)
> +{

Reinette

