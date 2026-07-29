Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DB73CD8BB
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785355868; cv=fail; b=KCs8QWzdiZ2T9NkVD6sQXZ8+sjj1Qb1wwpgYHoy6yB8UEGGukyXl0PU1ljKHnmUMujLAb51I8OlgJvb+O4/uajHHi/15U5ZRRJi2A5uKK611gmRjlzXeOcTdMiAX0538NfAx7wrRXh/8QsTq6n69PMQOT3hk2rClLQH4JfxAmaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785355868; c=relaxed/simple;
	bh=SeTMGzXp2C9XalRMJqoc8P2nVy97h1PPlfbMrSO5+1g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UfBf+D8smHZraM2xCAz8nqjMpVkAbtA5wBEGigDkS/u1oPUHKHansHaNvJ1IsggCiCChenwxhSjrqm42M5bWlrEKFNlDZfCUaNkYFORVDrcU3biT1qTUm76WEflDbU6jk9Q2YlpRCAVJxueiX1HIH8FEM4/GhnO/IzmpKGtHxmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jfZZrNHd; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jfZZrNHd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785355865; x=1816891865;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SeTMGzXp2C9XalRMJqoc8P2nVy97h1PPlfbMrSO5+1g=;
  b=jfZZrNHdVFGduhew5gvm90BG055YIvd5bvi+0cjtPVjJr9M0c2oD8Cc0
   yAT3G8R3BIeb2MRBpmeV6XvYGGmDVL1hJhdFcihciv+n3igPz+dtrOmJT
   tZabODihvJ5nT0Ka/SxluYeQdJqAdpfy58xByka4O3hP55hkQBLavUowi
   QUBly9pGddcTylG+iis/FXq3xJjAmWV+Ge562digZDB0CN6iRe0slguyf
   sj8eZ2tu3ThrgH7Y/mu2O77nK8Q7hmLoCniiopzoJ6CesAiUzXssB3Tm8
   57meZ4Vm6aJtBb5oi72dc+JP4ILbSZBh5VCy+4Q0N479Sdh3YMlWCnWk2
   A==;
X-CSE-ConnectionGUID: SqLVGdvcQwyFzS4MWbThXQ==
X-CSE-MsgGUID: T7tDlj1OQ9G7VKeayVsaCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="103376814"
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="103376814"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 13:11:05 -0700
X-CSE-ConnectionGUID: B6XRGvs0Slaf++9EDY+RRw==
X-CSE-MsgGUID: EtlWZ6mVTIWbmi67UR21Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="284671469"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 13:11:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 13:11:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 29 Jul 2026 13:11:04 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 13:11:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Enr5xzeWUJWP53SDZ9PexqNLOEXrV6b5tHBdUq5UwCr90vxzmVfZrdF2J1zP5HMkuj5sWds7/mlUkomgmoIqGPuAO0F0nqcLNZg7zXU+GW7zeWxLJjGehmByNBj9RtL5nRIUurb6h5I2PU16c6aPY8JD/TVmLQXNsuTvnFNZzpYuPBSzt8BiIBjYjPIOy/KJ3IegzxZc+hqftfa1hc7O5ka8/FtapV+KVg5DAt9TMoe01zBwgVweHiLUSyVXQElv3tCECuihm3pg8CTOc/8D01U3a2YoFCBZNysizWpmwfjiJ0blLEms0hAE1cv3XMVblElTT/fLbBfpmtektqXIsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zwksi0OAbRJBu1Qjvm1mjh1yHVEUl0ewgVsqPPSQTNw=;
 b=ZACwuL1BqTJ1pQ7WlUNXEFn/CmA3vkWm5HcnehvLdowvb1B5MSH87MP/xF5AEAA1cifcYpgHBkBKdjoyUILiPOwbKrJNrNgWLnAZxZXfa78bFay8kp4ZZJ+Me6mOsqSnFSGT4tjbL3jJhQjwJZ+lz6TwiEaNzMqocEON4ZgHPDd8sXFyhGva6Ot42CgQ2wjUh9fJrMAECnQaT0UHuSUW4WxAP20+LPNVRFHiLG0l7T67iCWxwWn56NzwPMDM27XJILbmT53OrioleBUTqLizC5k3OKRHW670oQAw9ZtAZaEaAyIOfiZFzdsti+DRAbYpmQLBfXHUhfXigSpvFZQC3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB4800.namprd11.prod.outlook.com (2603:10b6:a03:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 20:11:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0245.009; Wed, 29 Jul 2026
 20:11:02 +0000
Date: Wed, 29 Jul 2026 13:11:01 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 00/17] Allow AET to use PMT as loadable module
Message-ID: <ampeVc1SCnnvqu9y@agluck-desk3>
References: <20260729172752.11561-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
X-ClientProxiedBy: SJ0PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::26) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB4800:EE_
X-MS-Office365-Filtering-Correlation-Id: 55d90528-462d-4a70-337f-08deedad835b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|921020|6133799003|22082099003|18002099003|56012099006|5023799004|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info: q25dRXt7vgqTkT/6t01Ze7GOVF+pA6xbyLUspCrg8NlmeA7at10hhQabrF+fNdMLJ+r69UlMhs18wqdYuq9ADkYfY2Es3FzgTLSRzdaPujzW7sLJX0Vgq/K616Y/FP2DlXjQC74soUckDtgcRQ7/bicDBht9pmzu79u/+jKmHKB1rAraZ5dM/3yEjlvHSaE5zJfUKn9AxXjQJnxp5ZyuY6ncSM8oMcF2h3ssCf/lvaI5cM9SHf5btNNq8NQluhylp4ZUcNNf9JmNM8t3OjLetBe78GA64S4sVhz4GVhauoA9hp8Ko/CWfFbL4RRGTxS6nMU1jqQMaEgny6xn2cGEbrgpAq0P2zZMXiyl7JkKox8ksR+YSPjPMKHmirq+Q6pYN/hylQardWrBw4yib2DdzlTXzvwEDVGkFQSPumyvihIpb3cLxPbIX9IvXRUwQMmCFA/ER/+ru9iGIVLTJIV21lY2KJgKkHPcB661B6rj0B6nRrhi5zXINouqJg2v6S7TlENerKL/G70sd44HC+UYSDVtkbux0/KBYWaZzR2fyu40uDXkWW2yl4BI2fv+gpYxAcPObWMJfEiMtvdlXOED0gez7cxVdsOHSyFKSuxnY19frFsHDe6PnUSxq7ntRV0XbAZTCrFdZJF8t0WSbd2yzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(921020)(6133799003)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DUJdpXWJBF3la37+bXrLu+OEOkNeA2xbogqfERGv+OALwcj1QG9WxR1NrV2o?=
 =?us-ascii?Q?F9EGnoUYpCvJrxDHHGJcAEJ32w3928n0iQTTOWjd9l8m2XGx//9luF6x4KV3?=
 =?us-ascii?Q?bb7TT/c4+Off4qXZ+f67GuQXwaTeo7SqNVjA2YJ0WH7Jj3CFh96A8IWWJPBD?=
 =?us-ascii?Q?YUI+CTRmfvfz69oQ/+jwTJdh/2k7zUUq/qmue7djTpU+6EDxg4EATCInTod0?=
 =?us-ascii?Q?ZGIB2+4FpvUMFb1ypLCBoI7huRKP6RAJ5ciYamQFUQNJd9g9JroSmvbIYCFd?=
 =?us-ascii?Q?7+lG8hg4jfk2ZCwpRhpxcB4XiCK5yrtH9La3r5rl9/PchT7cRlg+w2nsNwX0?=
 =?us-ascii?Q?7b5kQN3IAKAMf7toaaTpKysUDxy8v4207tQl41wtzyCkkJAvikTnP0eXtVMS?=
 =?us-ascii?Q?UPcMofn3Sj/7Ij7dmqroIkFsIZOq1JLzvYpZSih8xgcKs99e3nom1shdqTak?=
 =?us-ascii?Q?yoO2u8YIIjXdUNZ5FwPY+no3RU4iDISJ/MH7W4YptVX5zLImPKzBcpKSSF7s?=
 =?us-ascii?Q?K2Xj8mqlLQ++AkyTvY7lR2kmu9XW9at9inYBld+j+WMYzal3eey5eotHmmTq?=
 =?us-ascii?Q?3ArbRxYXAKv6IJK0KmVFDTDNqFbZ4xml0GgBT7uJbnH31SWPhidy+z2BjnUg?=
 =?us-ascii?Q?eDKTyCWPpC8aJN/K3k5I4pfz5g7wjvgRON7Z3Z19Gw1Gn9k3w7nCVYPVlJth?=
 =?us-ascii?Q?uOX1fVg/f2WtMNJX3AM9aFkcAgvZ9DF0B7Ow6mDQIyHe1GI1YD9IMG/nrcLo?=
 =?us-ascii?Q?8iWZD1FCJwGwuyc1ariukXUaokv9yFOmxPEmZhxAwCAxBjmYJo/v3aJrXknu?=
 =?us-ascii?Q?pw4MbuuEmfWkEcQ5Rd5/5zpLWwSH7xPUbjy2c7I1cDXsI7ZLqkz7+9EvSB52?=
 =?us-ascii?Q?eH5WA95gkO6mD6W+ubtXj+zpVgA7wyJxA/8AndrSoA+3zZoCv6avW4faorOc?=
 =?us-ascii?Q?VCmiu+gw/goKWP8Wz1g7kHpta6mF66D1nOKNxlZstpPzbrEmORbOnQkOpoL1?=
 =?us-ascii?Q?bCW16+iJIHCNYQhZUFoLNZXHrC92lwDM9rTT49b0ed9o6pWAd2daXhzMaAcn?=
 =?us-ascii?Q?ndo68cIrBUbiWBTTirWzx2xLkQ/trpMFWF/VTRhYP0GfBJpqzECta0ZUMke4?=
 =?us-ascii?Q?Fp+mTYgFAOz36n2QsXv3Ax4zBajA6N4njVG8IlkvB01LIAH+N9j+Xxn032ew?=
 =?us-ascii?Q?koQe9Yywg5D9YddBbFQTL7PuvqaHP6lYCeH1MoRim9HF4ICdC/90IkaUx77x?=
 =?us-ascii?Q?QLkTAg7CaQC9Xnuz9BwTXiPNpIFBRLsOaq7H270mfTatODuL/72/90tfELE7?=
 =?us-ascii?Q?j1Ni9+YTIrvYbiqg19v7LhpjH5bmRh3XGR0setkFrvfG0+g95C6JtC+YXF1H?=
 =?us-ascii?Q?SPgDlkZsCvBRW0BvRphdUA41Rl8fV982xVtNZ0jGKol2M/rGzQaSwK5TcjX9?=
 =?us-ascii?Q?BwT3Ver7LE4/MpcuKSiMF3X4EJdHQFceK3f5JcoY29W7Yl3dMoAoq9GqOKOu?=
 =?us-ascii?Q?gB2a1Dk+KrGbS5pZhuealVjCw1qru0EV+IYOptJ0IpaV28BCIl57UrBSi+z2?=
 =?us-ascii?Q?1HuruOydWCkx5K3Dv2ArKe/4SQ5yqglQEpRorhJqp9DMivFXMVjOoTc22aLr?=
 =?us-ascii?Q?dKZnQ79JuXWoZKOhDBEzXVYCBio6za4TkIk0ePSdFHet3WqQrNId2OEgvLgn?=
 =?us-ascii?Q?OsljrNGonNmYs8wEDS1HE3DCoduMSO3h/LetA7VpAiLPh7XrUAJ34k+eMSo5?=
 =?us-ascii?Q?cW+z2x9fBg=3D=3D?=
X-Exchange-RoutingPolicyChecked: a0TJV2lYNxvhuQWcFVk1Fxa2P2fDU5lJqNwVPSRERXmGn8bGPkXdkzNV2/NB2rYzhYmLjSdePtPSNvnNNmjavOb74Z60+2NjO/D/D4xeQIeGCSTSnp426U+bPWz6/amGs0d9SxsZLtH/rMaslJoOdiarzoRObLh0RpAjVZTEsOXhkADeq0KxrOtZTub/A4E9jCBvqXlXr993Rl3AzB7EA3LHjGDG8sxeqM1Im7PSSaXhvhNviWbKj43eBr+NW8gWzEOPUljxXA/p9Jxv7CvsD6wAdSCMgGVdg7COJLDDKKo0fWfobFzx6f0WXw8zEb4kr+51Gtmeb5O36VFmQ9HizQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d90528-462d-4a70-337f-08deedad835b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 20:11:02.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GY+CO7/cuBeSnYEu2LkbaR+3rDeO4bUR/M1i4S3SXY21L7JOnz4EMDzfy6EpgpDiQ0YjeQ/Jv1v06d6pWGELsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4800
X-OriginatorOrg: intel.com

Sashiko review: https://sashiko.dev/#/patchset/20260729172752.11561-1-tony.luck%40intel.com

My responses to issues raised below. In some cases I've clipped just
part of Sashiko response. Use the link above to see the full details
and context for each.

--- Patch [1]: [PATCH v10 01/17] x86/resctrl: Fix enumeration of number of supported RMIDs ---

  "Does this early return introduce a potential division-by-zero during boot ..."

Yes. I need to add this code to the start of get_rdt_mon_resources():

	if (boot_cpu_data.x86_cache_max_rmid < 0)
		return false;

--- Patch 7: [PATCH v10 07/17] arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount ---

  "Does this logic ignore Application Energy Telemetry (AET) if it relies on
   RDT_RESOURCE_PERF_PKG instead of RDT_RESOURCE_L3? 
   If the system supports AET but lacks L3 cache monitoring, x86_cache_max_rmid
   could be less than or equal to 0, causing this function to return 0. 
   Additionally, if the fallback to x86_cache_max_rmid is taken, x86_cache_max_rmid
   represents a maximum index rather than a count. Could this cause an off-by-one 
   under-allocation, since a maximum index of N means there are N + 1 RMIDs?"

First part of this complaint is incorrect. If any monitoring is
supported (including AET) then boot_cpu_data.x86_cache_max_rmid will be
some number greater than zero from cpuid_ebx(0xf).

Second part is correct. I've muddled up the "max index" and the "number
of RMIDs" and need to add one to the max index when allocating data
structures.

  "If resctrl_arch_system_max_rmid_idx() returns 0 for a system with AET but no
   L3 monitoring, won't max_idx_limit be 0, leading to a zero-sized rmid_ptrs
   array?"

Can't happen. See above.

--- Patch 8: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET event groups ---

  "Does bypassing rdt_get_l3_mon_config() when L3 events are disabled break
   Sub-NUMA Cluster (SNC) detection?"

Yes. But that's the right thing to do. Sub-NUMA Cluster detection is
only needed for the L3 monitor events. If those don't exist (or have
been disabled with clearcpuid) then the full range of RMIDs are
available for use by AET.

  "Will this result in an off-by-one truncation of the AET RMID limit if L3
   monitoring is disabled?"

Yes. One of the places where fix is needed: num_rmids = max_idx + 1

  "This is a pre-existing issue, but could this code encounter a divide-by-zero
   during boot if the maximum RMID index evaluates to 0?"

As above. Maximum RMID index can't be zero.

--- Patch 9: [PATCH v10 09/17] x86/resctrl: Add PMT registration API for AET enumeration callbacks ---

  "Is this description accurate given that CONFIG_X86_CPU_RESCTRL_INTEL_AET in
   Kconfig strictly enforces INTEL_PMT_TELEMETRY=y, preventing it from being
   built as a module?
   Additionally, if that Kconfig dependency were relaxed to allow it to be a
   module, wouldn't it immediately result in a link-time error? It appears
   intel_aet_get_events() still directly calls the exported function
   intel_pmt_get_regions_by_feature() rather than using the new callbacks."

Sashiko doesn't understand that I've broken some parts of this series
into "add some new infrastructure" and then subsequent patches "use that
new infrastructure". At this point in the series Sashiko correctly notes
that the telemetry driver is forced to be built-in. The issue raised
here is fixed by the point in the series that removes the Kconfig
restriction.

  "Do these static variables cause a -Wunused-but-set-variable compiler
   warning that breaks builds when CONFIG_WERROR=y is enabled?
   It appears intel_aet_get_events() was not updated in this patch to use the
   new get_feature callback, leaving these variables unread."

Ditto. Variables used in later patch.

  "Since these variables are assigned here but never read, and the registration
   function intel_aet_register_enumeration() doesn't seem to be called
   anywhere in the kernel, does this leave the variables and function as dead
   code?"

Yup. Dead code now. Gets used in later patch.

--- Patch 10: [PATCH v10 10/17] platform/x86/intel/pmt: Register enumeration functions with resctrl ---

  "The commit message indicates the goal is to allow INTEL_PMT_TELEMETRY to be a
   loadable module while resctrl remains built-in. However, are the callbacks
   registered here actually used by the resctrl subsystem?
   Looking at intel_aet_get_events() and intel_aet_exit() in 
   arch/x86/kernel/cpu/resctrl/intel_aet.c, it appears they still make direct
   calls to the exported PMT functions:"

Another "defined now, used in later patch" issue.

--- Patch 11: [PATCH v10 11/17] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime ---

  "Will the module reference acquired during mount permanently leak?"

At this point in the series the telemetry code is still built-in. So no
leak.

--- Patch 14: [PATCH v10 14/17] x86/resctrl: Export interface to report telemetry unbind/remove ---

  "Is it possible for domid to be 64 or greater when evaluated here?"

This patch is new in the series and I'd like discussion on the approach.
My first internal version used an aggressive approach. If any of the
MMIO regions were unmapped by unbind/remove, then I disabled all AET
event reporting. An AI review said this was overkill, and I should only
disable event counts for the unmapped MMIO regions. So I added this
"per-package" logic. Using a u64 as a bitmap of affected packages seems
like it will handle real systems. But now I need to checks for
theoretical systems with 64 or more packages. Seems like make-work.

--- Patch 15: [PATCH v10 15/17] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed ---

  "Does this code safely handle non-PCI telemetry devices?"

No. But there are no such things. All telemetry devices are PCIe with
VSEC enumeration of events.

  "This is a pre-existing issue, but does dropping this kref before unregistering
   the sysfs file create a use-after-free window?"

  "This is also a pre-existing issue, but does removing the PMT device leave
   external consumers vulnerable to accessing unmapped memory?"

I can pass these two pre-existing issues to the telemetry maintainer.


--- Patch 16: [PATCH v10 16/17] x86/resctrl: Simplify Kconfig options for resctrl ---

  "Does using a private mount point here break mount propagation to child mount
   namespaces? This could isolate the final filesystem mount, preventing
   container engines or virtualization daemons from accessing the resctrl
   directory."

Yes. Deliberately so. Those things don't need access. Propagating the
mount to them makes the system harder to manage. Users must use the "-l"
option to umount to get the file system propely unmounted.

  "Will this 10-second sleep inside a oneshot service cause the systemctl start
   command in the udev rule to hang? This appears to synchronously block the udev
   event worker during boot."

I haven't observed a hang. The udev rule seems to be running
asynchronously (on Fedora). The system boot completes, and then
the sleep completes and the filesystem is mounted.

  "Does this rule make the mount entirely dependent on the pmt_telemetry module
   load event?"

I'd expect users to only install this rule on systems that support AET.

I'm open to better suggestions on how to trigger resctrl mount after the telemetry
module loads.

-Tony
