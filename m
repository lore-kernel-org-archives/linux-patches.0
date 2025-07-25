Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8793B25DB0F
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485531; cv=fail; b=pZCvjzCBt7b4aHZnuR7a9juLL/DLu/UC4sawiXOTRA2Yxm0uwYgdDfoHGghsKUp5fGH2JUzZAue01uwyWweZfdFMpJK2zoUl1PnE9BiqNwAEGByS1Ydo578jvLbN1bm5OJn5gOOosbexWopGNlsrYbo+AZkmYssdBtLXt3t5ClI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485531; c=relaxed/simple;
	bh=AH+CYUHaPQmD+lCpIABQ8IQw5Xg/Fby9/+SK/09KBXs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G0jVDtv1yEMBOcInu38dBqWNzAm+lptiejETqo0u5uTVWHJ1reAIc9hkIe2p5mh1rp6iqPkekM+B15VheIpRZfQXmmciJlGMlcz8WGdFN6itPQfM6pd2igC85pQyxNQV5hpK8KkJzGhfyUjr3NVIBlYTyU/JAXhWHU+UVvtKwo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VSHoBpVT; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VSHoBpVT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753485529; x=1785021529;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AH+CYUHaPQmD+lCpIABQ8IQw5Xg/Fby9/+SK/09KBXs=;
  b=VSHoBpVTvOxEzm0JIZafjkbFXIMQPMpC5ShsGyGBsKiMaKNTR3tY3kW+
   g5QTT5l2bN7KNhmq2YmBrGUtv393R553Pt8hx3Ov8G83NLXQK1z9PFC4l
   6qYhVFHhHfpTWiquYlVMfc+7eAZ9P06FSBla6WQ3rZTThExsCIq59KlgG
   oc54LTj6dZO6oppY2hsbwGxqK78Zh2aT/Pvf1eEcZWhuACWgGBdoGucyk
   cVbqcLDzMTgkmL8xFZC8DORyqPGaXf5yq/QfFUZ9iKlvTthpyVZJBlajJ
   D27181jUZmEPKEloZvzxL9tytiOGp2Hx6G+Tv2RssdS5MzQYOM7LAYx22
   w==;
X-CSE-ConnectionGUID: Ox6swpTsQGaL18iPgK1Rew==
X-CSE-MsgGUID: RxOydw0WSaO0LObSmVfjAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="54908596"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="54908596"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:18:46 -0700
X-CSE-ConnectionGUID: /Em7WwUpS+2F14VC946mLA==
X-CSE-MsgGUID: RZjjQdqGQqqhxj274gtbCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165688840"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:18:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:18:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:18:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Azx6YzWwBDpR0p/Wf+7z5QvDMGiD3lOVJzdWAJPmryyUjGxqCR8AOPowwhjyt/v3AKInRm4etwXCiX5dMamPchnUJAMsHXavs65x8sGdmBlNtpfQj5Ynk44p9sMGe+s29NLvDMwhwe2S9K14Vzdj5pp0j4rg51h7l+BRawepZZAc5hRqNcbN2y2eoOiR9s69ncIGt6jztLRwA6I3h2e2BLddXiaGkpjb0zKbhbDokUxmSh1p3Oq01dVghfUXZyVcY/7WCwHskwSvMvmLunTIY5Cnpe2XHHafk0xskci8QrhObkSJu6FKncBRPaQVbp7g04tsFmjBVbTwjO5KbgY7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzMwZOBNISs4FayXWFFE7PyMsBt/uVObwq88eTWei24=;
 b=jIJl4L8/9IkFNVmsbZBrQe3RmFF09KLtepkiz1FuPLNup+CZyhMv5T/9b2iVJlSKnDZ8VzKlMv1/zIgf3Mpbj3E12/ChYs3gEFEuVpC1HhUcIc0ThpaxILXJprDM5AhG3/xIzfut9Pr3mtXwYEAcXhFaIKA8oQK8GU7XJL3GrdoBJPYI2L//lLzAL+IrwOBCd+5lJPsatQ+3wAiV557UiKGyF65/ge72dOXhsizCM2krTv1bFwFw0r/6mRTJttqbOOCQ+tcjcXuQ+syfo/6LbpSTYYp0bhUduFXSbZHgwkx8aLP66+nkA/SmSXz2sdt36WBM6otYDO0xtzL5oIRPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB7496.namprd11.prod.outlook.com (2603:10b6:510:280::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 23:18:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:18:01 +0000
Message-ID: <34446657-4b03-416e-a8be-fcf35e3419fe@intel.com>
Date: Fri, 25 Jul 2025 16:17:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/31] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250711235341.113933-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0130.namprd04.prod.outlook.com
 (2603:10b6:303:84::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bf4621-65cf-412c-3368-08ddcbd18034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bnNybzM0dForTXVTeGZhOElVVkp4UVdYZkNnNHNvVktqVTl4a2JXcDF5QVNs?=
 =?utf-8?B?UnFqL0tqaGRtM1dSQThGZW55N1lMVExxN2VRMGZNOXR1V2Jndm02ekVYSVFu?=
 =?utf-8?B?MTJrd09BYXUvRVo4SVZQZVlhcURSeDJiNkpEem90S28yM2RiRDVLZGRNRU5W?=
 =?utf-8?B?T1lLZmdJRkdPQmhHem1teTRhdG5PZW9VOEZyeUlJaVlGQmExdk92NlJLVVdO?=
 =?utf-8?B?b0RLdzVxRjg3VXZxTGZKYTg0RjU1WWFPSXNRUWNhNFQxZW9WMUxSZ0EvUU02?=
 =?utf-8?B?S1piUHRkeXlyTW8vRDcyS1V6VU9aY09UYmlIOFRBN3daaXlVZEJHQy9EMmxq?=
 =?utf-8?B?MzFzWGlSTFpwS25MYVFrY1IvOVI1YnVtRDRSNkNxNW9QenhUUG8xNkwvdkFj?=
 =?utf-8?B?TDB3N0hRK1JqMEVXSFFDdm5ma0ljM3ZkSFlIaG5XYUVYdC9RWW8wY2dBNXZP?=
 =?utf-8?B?S25lRVFTblh3WjFxaXJsSmtUY3dCckdWZ0pud2JrUUZwenFJbmlZWEVGRjhn?=
 =?utf-8?B?eDRLb0ZkNlVNK2RNUzhsOVM2RmtOUktNTC9OS28vSzVrQkh4a2hZMm5UOFQ4?=
 =?utf-8?B?a1NHLzJSdVRtaE5wb0VkU1BUVHk0eXhYc1pTU1NiYVRwd0YyNkVQL3ZIYTB5?=
 =?utf-8?B?K3g2V0JqdHRuRHR3MzlIazVmNkJEc1FGYnF3REJXQ05KRlFvdXFROFNoLy9M?=
 =?utf-8?B?Njg3Mmw4azNEYzArZGpWbEtUKzJXOVlIT1FKL09uYVJDSEwrV1ZHcEhGb1hF?=
 =?utf-8?B?YW91K0plMlROOE54djZVcm5wZlJNZ00zWUFkWmJFSlhvcVZ6SHFMbFczSE1V?=
 =?utf-8?B?Uzl3NEJ4SE1qVzRqRHl1RlVwWlJqcDZXN1FVdVErSHZoWVpSempOcXY4S3NE?=
 =?utf-8?B?RzhKakZYcnNUQm5heW5IdDhtMGRaM0VDZTdYNWVaQ1R5ZXB2SVVyRE1JaDFI?=
 =?utf-8?B?dVVKYXB2L3RjSjdaandCS29yeGY3R3l0SVRFcFZCUzFqdDI2NlVHQ0pLZUph?=
 =?utf-8?B?SXNSQzBNTVY3WHA5QW9vcXZrNHhsdWR3bjRWaXllWUkwemNZcklzbTA3d0lK?=
 =?utf-8?B?RUNSZUZVbzVIQ1hob1R5K3ptcGxoZ1I0bUhrT0dreXNBbVRBRTFJczJSeEpI?=
 =?utf-8?B?U2ZpZUJJTzZuc1F2cXdoakdRSUE1OWEzc3pvY2Qwd0s1cWh1K1g5YjdQS2g4?=
 =?utf-8?B?ZG1ueUl2UGNMKzJmb0Z3emhyUnlHUTV6RjdLcENNZW0wcklkaTFrcCttdFBQ?=
 =?utf-8?B?L0t5R01sUDJ3WkRVMWc0bGJrTlN3RUcxb1IvK2JtUnA2bWMzL0h6Z21CWUp6?=
 =?utf-8?B?NHRJclI3eHRWY1ZqZjRWcnZpbVBXZnpMekg0YVlQME5KekIyL1FxdVpvUjlS?=
 =?utf-8?B?bGtETVljUnFHY1htbTZHM1BBSTR4NW1UWVI2a1RtRHhnRnJtcUhHN1g4cDcr?=
 =?utf-8?B?YTBaejdMejd3L2xxbFB2U2hxV3JSSkJaYXg0Sm04enpCbFVHa0c5SVR5Nk56?=
 =?utf-8?B?MFQxa1dyQlFMc1BOMTEwa3VncEdDOHd3T1U2SmJMUW8rdGxyQXlvdGRtMG1x?=
 =?utf-8?B?eXdtRXVVY013YkdIdVFoQWliV1Z3ck5yZzhyeGZmTmNpbjBYcTIzZGtvd1lU?=
 =?utf-8?B?eTdndXpsYVYvRjJobFBwZEZkd0tndjViSHZqa1RvRGtOaHk0djZ4WXJtTkVS?=
 =?utf-8?B?TS95eVV1QUZ1TWF6MCtRNXR3UVl6OXpTVmtNeTU4UzRvTWdVSWYzcDlraUhz?=
 =?utf-8?B?QW8yeWIrU3NWU0NFZTM1N0NUTzBNTFNSVVlIZUVjTGlmRVltU01Yd2JFUkdU?=
 =?utf-8?B?eE4yM2ROVnhhNTUyYmdvL3owYW5QMUltUVpIeThsSUpPRzdMU0o1WXl0dlVY?=
 =?utf-8?B?UHVXcXlzd0J4MTJsQ1FpZGZKQW4wMC9YZE9iNjMranEwVkNnZkQ2YzhHQVly?=
 =?utf-8?B?RWcxYVVtM2tOUDkyZ040TUQxWTFLVStSVVNTeVJLNjVvNjJzM1lWWjZpYVli?=
 =?utf-8?B?dGdJN2V0SEpRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1NsbEpCZVBhK0hzUnEvbWZxSnBjS1FlUlh0aVEvSjFpZTZ1NFFwaFNLRWNF?=
 =?utf-8?B?ZGZjV0RHSDU5MElvcE1Ba2pyNktIUDFlOGZ2MUIyKzFvTUFqb254U29Tbnd1?=
 =?utf-8?B?NWRET1pSazJPVVhrbEQwOFUrZEpMbFZ1cHFWZ2ZMQ0NUV2VrWE1OckZtMEtB?=
 =?utf-8?B?N2dKOXl3NWtzU05mTi9iU0kyTzlzNTNTNXcyT0NJZWhtcjloTE5SWllQWTJ4?=
 =?utf-8?B?cHhTVW5NT2xMdjVBUk9vamlVREFrV0h0Mno0OTB5SHlOL2g4SXNnTm5RLytl?=
 =?utf-8?B?Z0ZwMFp5UFRSWHY2cEl0YnY4TmxCZ0ZmNkEyNXpxSnZidWVQY09FQk9ueWQ0?=
 =?utf-8?B?Q3RROTRVV0tXVUErcGcyRmo2T09ZeG91bGdIOTg2VUUvSFloQlBNd2puQWQv?=
 =?utf-8?B?bEZMRFA1NmZBTnhHODlZcGpYR3RpRlRlTUd0c1h3REl5SXJnVnlVbDdVRXJD?=
 =?utf-8?B?akkybERmVE1jeEJkYnpRdit4NDlFbFZrenVMOCtZWE01RHBlbG5PbGx5dGNu?=
 =?utf-8?B?N1ZMYWx3cndFMTQwWGYzdlhLeGNvbWpFWXpUcGlnM1d6OXRLeldlRnA2b0xW?=
 =?utf-8?B?THJ4NFlheFVYcWxtcklzemJSRGphQ3BoaTBZUEdURzVVRVBLa3hlSFluRHZ2?=
 =?utf-8?B?MktWUFlOWG9lTEJYQVZFdzVhbXg3Z0lVbytrSkRaSUxKbkhCNjY5NWJoSVNH?=
 =?utf-8?B?UHpsbGJIcXBOQUNhVHRIWWhFWVNDVEg4Tm9qNXBuS21hTW1ZQ05ENXg1MlYz?=
 =?utf-8?B?ZkF1L1dkVFRmUnpmcitpcUp5RzBIelNYQ2FpWG9ZSVk5WmZqTWJCMFJadnhB?=
 =?utf-8?B?cmFBMTNwd3l2SlNDZCtENzRFbGtSUXpFMTgrYkx2cGhtWmhYS2ZqMzNZZUxp?=
 =?utf-8?B?dFhHU3VzYnQzZFpPamF3WGxEVzZqREhhczVxNTZFNzA4SUhIYkg1TzQwT1hj?=
 =?utf-8?B?MlE4WC9tVWEwRUV0QjBjQ2dlSFNRK3U0aVNTeEowUUtUQ3pYN01yOFRWVFht?=
 =?utf-8?B?aEkvODFMSXVrbVpEaUxvSnRDQndOY0xPQWRubFZzMTlhM3Y4aUphU3cwc0Vy?=
 =?utf-8?B?YWJSa1dFT3RCdTlPdWJUNkRuQ21PN1FKVlRnMVpzRzYvUDhTNGtSck5YZWlL?=
 =?utf-8?B?c1dpU2tpYk1qYXBtVTllTjgzNGd6bm1yYnlpbnFUOTZvN0taaHFXNXNZejdx?=
 =?utf-8?B?RHBnU2U3SnFsWWF6NXZ6aCtBL3BhY2s4bEJ1TG5jUkp4Sm01cndHWUFCMUpn?=
 =?utf-8?B?NFQwY2pjTjFiL1J4QXZFZUlDVVRFMVlGZUpzaG9oQzA4M0dOVThwN2k3WlJa?=
 =?utf-8?B?L1VLL1FjTWxGa2R0K0N6M0VKMUdVSFd3NGQxVnRZVnRteVF2MTBQVkhHaUFj?=
 =?utf-8?B?VVRTL3l2QmtIZEhaTFpJUmZOSEs5bHdqVWdjelMwUUplLzN5bGhNNmZQTU5n?=
 =?utf-8?B?VlFQaVV5TkxHbDNKUDViVnpGTkFTU2RXdDRCWkU2YnpqT1RCSXNWa1pCSGFi?=
 =?utf-8?B?dGhCa1cvVm1DRElTUytMbTRybEFoc3ZoY3ptU3BFQTlLbW5teTNPenlDakwz?=
 =?utf-8?B?aGhHQ1JvSjFXOFVJWkJaeVhlOEt1SDdva1JodW1UQncySm4zL1c1UC9YNEZ1?=
 =?utf-8?B?UEtITmVYNkdWQmJaZEhrQUMybUE3NmhCQkY2djdMSVNFTm1PeDdLQldTU3pp?=
 =?utf-8?B?WG8xSlhvVnhyWTQ2U0JTQ1pKVlkxSGl5azFrdEFCeEowNmFjdDkvNVdFTmFK?=
 =?utf-8?B?djRwRjZYNmxsRkJ3QnErSWxOcWRLZGJ1VFBIeW1QQ05ablp1QnlNbzExcmxm?=
 =?utf-8?B?bzlYeHMweFZZVTZtekJzVEVMdkYyTnNJSmE1bVNFRVV4VThmVGxPUFUwamFJ?=
 =?utf-8?B?aGErS0tWTEVIcUhmUmNFVktmazVkSk1lZ3JDSTJORUJRVFNEMVl1bkk0ZVFW?=
 =?utf-8?B?bDdOTjZwVTlxK0cxa1ZsMnB1VzI1WUdZc3h3MzAzOXpzRmhBdHR3MGJIYlNu?=
 =?utf-8?B?elBzanAzSTkzYngwamozQXNKU1ZJN3VWRU9PdDZCL2w2c3Nma0ZNUDFIQlV6?=
 =?utf-8?B?SzZFOWYzSE9nRjhiN0NPMDNNZkFFVEZORTljNnh1aHV6ekZvcWFqVmQ5OVhB?=
 =?utf-8?B?YlEranR4dit0K0lPYk10RFNzQU9HZjNFWWRRbEM0ZFdwMmhxVDQzeFBUbGFM?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bf4621-65cf-412c-3368-08ddcbd18034
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:18:01.7322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXJFNIKqPc2bNPKGCAuurLIM51HCw91XYb6mSvW5fuJBvx9lBCe6gD8PP4XferyyhT0XVdlvmMiGhWiAvJQNoQFajWwLy7BiGmHByZYk07k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7496
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> The rdt_domain_hdr structure is used in both control and monitor
> domain structures to provide common methods for operations such as
> adding a CPU to a domain, removing a CPU from a domain, accessing
> the mask of all CPUs in a domain.
> 
> The "type" field provides a simple check whether a domain is a
> control or monitor domain so that programming errors operating
> on domains will be quickly caught.

Above is context.

Below is a mixup of problem and solution. Please separate these clearly.

> To prepare for additional domain types that depend on the rdt_resource

If "rdt_resource" refers to the struct then please "struct rdt_resource".
If it instead just refers to the concept of a resource, just "resource".

> to which they are connected add the resource id into the header
> and check that in addition to the type.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
