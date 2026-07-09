Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC5D4195A4
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783618906; cv=fail; b=HLdQNVUvf7O04ZvpyQMlJi4/w4sD8eDEBvPrg5fJZvLabNwihADVo728xc/H17TIG4w8c0yTkFhdMOY81IoMZlKMkNl2QKjlgDS3bPBf4Qqy4qBYm4O3KXbae1c0O83SOFgaK5Iq2cWvnYGeun9WIwSd/6v2zdUuHXYV2HtMX8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783618906; c=relaxed/simple;
	bh=a1JSJltKWNjkAIq1JkaoYDzci18TdIGoNSyHWBK/FlE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kb4612bqYbOYqFlf8OMhZBi1Z8ilXd9mFUT/sxGUfvDcw905b8XSyHtvaqMvUBE8lqaNhRo9RItP67c3cn5GS1OPjdyFjlpyCb220kIDzIklo5v/bzAblyTm+BxHmvzbH/n816VKBAB9qjYIagfVQDxNSpCFvyn1pNLrVuvaERg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJURqyOX; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJURqyOX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783618903; x=1815154903;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a1JSJltKWNjkAIq1JkaoYDzci18TdIGoNSyHWBK/FlE=;
  b=eJURqyOXsh/wWmFBrKLYvXcYPoK3ohzyts2K9m7cc6j4FHF7utAIxNr3
   S55nz5sDHn4flTqAhAsvz2KhZJ3U5HKhCvnSUrf2nD3T+URiVOD9YhSgr
   +9itXw6mOj76PV03plA7VAxmTHfPtybjzPFDQ0XpdXnNwzCm7hshB50nr
   BcYCtlJUVVtA5eG7+atFLeUV6JVxyk3DCT9aQ1jGCDPh2CVurqA4wVKRU
   hiQqdj7dZPcOXoMTAP58i7Ow9Le0UFKBFdQL8uJLksKBYrqDKn5nWigft
   5JkIef/RpLIfxS8x8EdnLUE2bhTM39HOHZxx3MTcS9BL4o2mujl4zgTTx
   g==;
X-CSE-ConnectionGUID: 2XkgDhXYQ+aSIA1zDGZ3BQ==
X-CSE-MsgGUID: i7lJ62G9STOeXfB9UDFV9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="101738696"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="101738696"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:41:28 -0700
X-CSE-ConnectionGUID: fTVzX8hAQyWRMS5Ts59RRg==
X-CSE-MsgGUID: 5OegZFKnTJyu8BTIMJdqqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258521104"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:41:27 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 10:41:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 9 Jul 2026 10:41:25 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.57) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 10:41:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJ9yR+litGharwrQDfd1oD75L2D8xsbS5XsScXAoGghQjCUU/iYSAYmGnz35ClyJpBTmXue9r3fgFgizkcWHZLX/+jZNVTlHJGYTDGryR9/ZdRXd5Ju/X8fgGZThru/fH7VvFTWlcliBRtbDstfuyUMYyL88C2aCXfiShQq20JvTHj2wn9WoD6PgNjlZMjiRF324q0LEUKjj+KnMJa+TOrMj13m/QEXopYYtgkQXOtwfKalFOaq87Di/dT9kPJxvf5vTn6bRQP5/sxRnU92R2i00zQl1bgnt78lXhTX6Y7ZEMunFKahNMqWMpAkpGdpL+EPJBQho0lUivAFNacbzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vT8V9N9LID/0zcMBzhExsTA3ABMklKdBhRZrV8a3r44=;
 b=qIUOjGNummB+Pv9rU0PJ8h3Yw8VmcZy9iixWba2tYTzxO716UQhAUUo7+swtWX8LC1UEQwctRXq8Oj+WpwezNisBJAXWx4cTvvk860mBLv0s0h4ygcWpP00nBjluDFziID5DxxoCS/CUbdQL30FPRInvNMQ82HVPEhq6uKtYs2GYBKSBTdgtU8cj0uFd1eSfxYtmXv9WQVAjovo/SKk95aLgmzSKQr7W0GoYsoqABbfcnSwZHxD/nN3SAIEIh78geiTM5HYIAkbMYJNIV9EreFyv2a3Km1sobfhaTZhaFTaOEUFh/EudvCH0v2L4kEIko2D7uUelgqCo2sd8hMEF2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB5110.namprd11.prod.outlook.com (2603:10b6:510:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 17:41:23 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 17:41:23 +0000
Date: Thu, 9 Jul 2026 10:41:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 01/12] platform/x86/intel/{pmt,vsec}: Prevent unbind
 via sysfs
Message-ID: <ak_dQX9j-hmtm7W6@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-2-tony.luck@intel.com>
 <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB5110:EE_
X-MS-Office365-Filtering-Correlation-Id: 4432c1dd-7a6f-45bd-8425-08dedde14b28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|6133799003|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: X5iA31ZSfq77Tw9vZgLKNanthBkITJBV7s9aFE2wMLKD7sUYWP05nA9V82dQkuBJBj0BBIid1eVAJmgBBaPPtJsDFCFfVf46QoSGDHQ5xJFO+fNTra6j0rfyRhToHWcRsC6UaZOJ+j15SRZgXQtuElfCi/7ewXgpuvEAUS5tcPd2XfqX18u4OvIUvK2Tleh6rdFWUr25Atp2QfxpvKlWGAzR6P6jkwZPckI50QYPsP9JtDJj8+LVU48Zxtujv1v1ZFQQdFl61mt0TqejPs6Wz8497YXdWU1gFZS3hFhmmgGAi8eAgMGKUyIotO/31SZuHkHv26BVDzo/W/k4aW9GdxF4Wkmk9DY5lLNAsv64lDcWo6Oapo8Cou/vKXpL5OSDvYgFX8oVTUGIu5qHagvllzo35IkfniKKMCpwrnY0zd7Ii8uFGpbc3VY3Nps75R4lXKzVUUwGdQ+Cpu6xfhIpvR0Oa5Tpfien1YkD6vUrYoP5gbv8s2PW4Dtb/dAMBxh18t2UDAjbGvLczPKnkbLiYro9/z6b8jo9XQC/Ms54OovGmhf5XuLuOndMsnXquYFYqRkiV4PooIWaejpR//Iyd3hd8fgb/OOBg/e4Ob6d6d0+UBYZS633l4JHT2CYuWeVsjwX9uJzO2jkiZ3gE+iXBnNc7uRG0fYFxzZs/mPVRvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8q3y10ENcESeKqWrvuNbaq14azGfxe9ELD9LfUVOeXe5VMJr6aN2ktYh6zDk?=
 =?us-ascii?Q?29a0ew1SXQosoi9WKqEWQ4eSwCMIOZxGFuouDl5Y18r4EC9fmQyDlnAXBlb0?=
 =?us-ascii?Q?T8+CcPMXoUodqlH5ymgmCjHVeVMPbG+7lLfNRUR9iqZmkxNBxPrcfCvX9LeO?=
 =?us-ascii?Q?ZzE/TWSB6L++jDskxGF+NHHoA8ZRNNUr3b918aUwTjZfUdIdnTvBq5+ztl2J?=
 =?us-ascii?Q?NbuEp4hzn2mn4+b4dOHQVXL3ugu4SFR6NTr4qi+/YSqBKYhtEbnd5i+UOkZ8?=
 =?us-ascii?Q?3uEprQq93zH1dZUxvQ3Q+HSsvuUNgaNcYCFBe6QBb6OCXiTJY4vdtuPx/lIJ?=
 =?us-ascii?Q?tndab11p8yRlqqbOUJdTRsKxcoTxI0oiHjoiPoEFfIUu3RL85JKsea1mFUU8?=
 =?us-ascii?Q?TIh/Ju76H0gjHRfhsKu2HOxRAssgUtkQS8Bg2RtSb7IoUZrI8TDuwEGY1qml?=
 =?us-ascii?Q?uNHY5/sRgzIoYYe0KC0D4lJBKz+WIJ2P7ZXgoS/jjPt/+ay3Ed8pWY9DTRcP?=
 =?us-ascii?Q?p4z5tfBHTQv1lc1oqYyJHN5DwcPBXnBz3jCZs+dk7aI41PwnQ7+yF0uxilqx?=
 =?us-ascii?Q?xe3u7gcvz4i5hk43O6mCaAaDQ0s1zS7HOT+yDQDzOLyA4XVBnAWJMTWK+Z8k?=
 =?us-ascii?Q?2d3uahyyZoxD/SzJ5KNcLfscFJT0BkS+lSI8wCOO0IN0NWAib5h+tATaj1am?=
 =?us-ascii?Q?5VXyarSmZ6vj6LTkIoP/GYXs2dcDsQCf2WXjY4gNhx8YclhmkrRgxX9uJ9as?=
 =?us-ascii?Q?3Y/ETqoqB/h4OhGZzCo0IukvgSaimeU4CcVxvHU7ZDWxYyUDYIqWFhTTnDvq?=
 =?us-ascii?Q?UqTC2c5QFPC5xnd9WKA6+Po/0z4OjmoeITbhnADzVx3FTF7E+Jgta3eJpA20?=
 =?us-ascii?Q?Hn4C7z3UrBCcnNNFh7BRKKHxrco9EAb8vEpd9k8Dp1vt/+N/e7220bWiY135?=
 =?us-ascii?Q?Glr5xqEOTK8l2s3ZlcLDB41v9JrzwVo2evGILXdbA+CoRlCPZk7GWsTrP2KZ?=
 =?us-ascii?Q?rJQkTMvO1sL0TpTyie9+czZzF09JQNqtve6/uSgHRMIYyyeJ/SGNVmL6Ry/j?=
 =?us-ascii?Q?Jq4G6qFbazZHuR8nFLAGVdWWY+64BWm7VG0EqrckSeA5lTWPwUAEeKOH/QLN?=
 =?us-ascii?Q?YkB9SJ9zLXFeYOWvtGBrfgCnku0AsSavxjDFBmvFq4k+iOEz6Lc0UFUXxUuw?=
 =?us-ascii?Q?RYqbw3owgpXqxNFt5lTcf5bTZLhIPZqN0GL9AT8lq57s4gkx60UO1HOky2Uc?=
 =?us-ascii?Q?mrONV7NghrG44eu+BB+SD5q8fmSGFPXz/uih3WDLFkyW2Q+QgfqwUodMoqL0?=
 =?us-ascii?Q?quKgZugb4UstTB29iAqIuxjFw5iQnAus04/uS1v123rDwSePpOVk32bPWwqr?=
 =?us-ascii?Q?ika21pUX5E2nLXkgtfkQ83B7DtRS9qaFV7NTvebjQ4AtqR53ZQ1JqpGUsE1s?=
 =?us-ascii?Q?A1FdoScbfBVRdJuiogIrzfqIdJrUb1WEG7QibMnGTa9NgaGPJYthA2REL2FF?=
 =?us-ascii?Q?dd9o5xUT23jJcO/8zExg5KG57C2JUMcIQu6ZPXGLHcWIPVei4lISH4cYoQvU?=
 =?us-ascii?Q?fF3iFBYLAUIpzPOAhEuKAV7IksXWlRqotM6QHsjpOGEgEjruTSP41MtoYv1H?=
 =?us-ascii?Q?I60V1xqQgdtZpzpu96O3Xwc6/xv0ry6zRjRjy6ZGtMoxb6waSbH3+lvoysIV?=
 =?us-ascii?Q?8siv/Oeiy6dFnq/lDXIrw8d/8hmpZMsTqQBVINA3bT8LO7a8T/fqBNF/mW32?=
 =?us-ascii?Q?/GvaTjjUzw=3D=3D?=
X-Exchange-RoutingPolicyChecked: TG64dWDY+G2MT4rVqwWJZqXe01sC5+kX1tovuFZjy9TuRAJz+jkCbtX2q54hMZ4ksdEUun7yaa+CLhrm0/tLsUsOUvU61WIt2dNr0iOffv3faneAtLdy+30NrM6uGGB8JaySpHAetDS648Nsn0fRpBrQ/aEHgyU+yNzEeIYH9PDYI4HgEbmZseV4n8FMe7863chZZSUt7sRkyqhAR/58f+UBHGwYOoagkrcfYx3wxTS7ckGv8Jf0GlfSbxVqEp/wUj59QOtsT9IJySHtiaF5Zj5o6V9R9QetNMi5dR4drECVLqgXMnV95qLhFbS9/17Z4Xp5tazBRj0C76DTjw/Wvw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4432c1dd-7a6f-45bd-8425-08dedde14b28
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 17:41:23.3724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+zVsSRQuo03jQ5/xRiEmPQMn8ddJ7A7b1AFTN7QYuE9vQSi97ia23fLnE0VLNhMuMeXGBJIfDVYD6bzTnkb2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5110
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:45:03PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > The resctrl AET code uses intel_pmt_get_regions_by_feature() (exported by the
> > pmt_telemetry module) to obtain pmt_feature_group instances that are populated
> > using data from the pmt_discovery module. The returned telemetry_region::addr
> > values are MMIO mappings created in the telemetry driver's probe path,
> > and resctrl reads from them while a mount is active.
> > 
> > However, a user can unbind the intel_pmt driver or its parent intel_vsec
> > from their devices via sysfs "unbind" attributes. Unbinding either of these
> > drivers would tear down the MMIO mappings, leaving resctrl with stale pointers
> > and causing a fault on the next access.
> > 
> > It is safe for the discovery driver to be unbound. It does all its work at
> > initial probe time and saves a copy of the features and RMID count.
> > 
> > Set device_driver::suppress_bind_attrs in each driver so that the "bind"
> > and "unbind" sysfs attributes are not exposed and the user cannot detach
> > the driver from its devices while resctrl (or any other in-kernel consumer)
> > may be using the resources.
> 
> Unbinding via sysfs does not seem to be the only way in which resources that
> resctrl depend on could disappear.  The "/sys/bus/pci/devices/.../remove"
> interface looks to be another way? I am not aware of a way to prevent this since
> this represents how devices could just be yanked from a system. I wonder if
> resctrl should instead protect itself against telemetry resources disappearing
> after mount with another helper that telemetry driver can call when the device
> is being removed or the module is being unloaded. When telemetry driver informs AET
> that resources are going away after resctrl is mounted then resctrl/AET can return
> EIO on event read attempts? resctrl could possibly recover when the device/module
> re-appears but if that is complicated then user space could just be forced to remount
> resctrl.
> 
> With this there is no need to prevent unbind here since it creates a false
> guarantee to resctrl.

This sounds like a complexity road that I'd prefer not to travel. The AET
enumeration is handled with a contract between resctrl and the pmt_telemetry
module. But the mapping of MMIO space is handled by the parent intel_vsec
driver. So to get notifications of impending unmap of MMIO space the intel_vsec
would somehow need to be aware that pmt_telemetry had handed out some pointers.

The "remove" interface might push this trail up additional levels (to the
PCIe bus driver level?).

All this complexity to avoid crashing when system operators poke at sysfs
files without understanding dependencies.

I propose a simpler solution. Just have the AET code defensively read from
the MMIO registers with a new function that turns any page fault due to the
MMIO space being unmapped into an error return.

I'm terrible as inline ASM code. So I had Gemini write this for me. I tested it
by removing the code that disables unbind, and then unbinding the intel_vsec
device for socket 0 on my system. All the AET files for socket 0 reported
"unavailable", the socket 1 files continued to work normally.

------------------------------
/**
 * readq_safe - Safely read a 64-bit MMIO register, catching page faults.
 * @ptr: The MMIO address to read from.
 * @val: Pointer to where the fetched value should be stored.
 *
 * Returns 0 on success, or -EFAULT if a page fault occurred.
 */
static int readq_safe(const volatile u64 __iomem *ptr, u64 *val)
{
        int err = 0;
        u64 ret_val;

        asm volatile (
                "1: movq %[addr], %[val]\n"
                _ASM_EXTABLE(1b, 2f)
                "   jmp 3f\n"
                "2: mov %[efault], %[err]\n"
                "   xorq %[val], %[val]\n"
                "3:\n"
                : [val] "=r" (ret_val), [err] "+r" (err)
                : [addr] "m" (*ptr), [efault] "i" (-EFAULT)
                : "memory"
        );

        *val = err ? 0 : ret_val;

        return err;
}
------------------------------
> 
> > 
> > Fixes: 1fb2daa60de6 ("x86/resctrl: Discover hardware telemetry events")
> > Assisted-by: Claude:Opus-4.7
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > --
> 
> Please note the separator typo ("--" -> "---") above that exists in every patch in
> this series that has a changelog. Please check all patches for this, I only highlight this
> instance.

Oops. I was using those so keep my change list intact when updating,
shuffling, re-basing patches. I forgot to tweak the "--" back to "---"
when posting.
> 
> Reinette
> 
-Tony
