Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEF138D40A
	for <patches@lists.linux.dev>; Tue,  6 Oct 2026 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791324479; cv=fail; b=LEKxgdhl/WtYLdFAf2CltaaEsUGUmoKC/wJLd37u0dOjBSI8/A4D0YCiUPygiu3ANWKXZYI/wlf++D3Lc5LXAqctNQwzh9ZvFdPDjrM+lAvOi9WsB2mKEvSmCgyzQufmzxSXGPmmbJksLrefcs1QN0qtA72WpjOpFhdHu1lHjWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791324479; c=relaxed/simple;
	bh=rOyucr7Vjn1vb8sEa77pUHMKl1TjfKA/5EdVc8cVX+4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JfZtsy5fYc8KhL27uV1v1fXeuiRsqDVex9XJYIJcnf7C1W6BOsfL7R0CM4S5bAQ28ozuQsEQ95Mx73rfj7tWT8KQXICFuuXDQhB+wSepxeDU57ZTpD+ninfAQUOipqo7BVbYudTfJKPJguyaFFPgFJVqkSWGjLNWMzG7GDiH1P8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XHjzvGpc; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XHjzvGpc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791324477; x=1822860477;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rOyucr7Vjn1vb8sEa77pUHMKl1TjfKA/5EdVc8cVX+4=;
  b=XHjzvGpc3FiQck4nFfIoH8MFLfltYEXYs9F8SBXK/D4ldnPezH6KpkGd
   gomXZEe+T1DwhZyqeMouY1hIBWns74a/0OsJmRiF9A4pNoGucyjrFPc8k
   3GEGFAT1uVSItc0J+yrMu8rzgZ9+CfY2ARbEpQkf9xvSI+hZ99lxu7Oyd
   JjGoZHENZcAh4TZfy98P9oXxvFuDA16NWg3pOZTcePzzIcwUpN9BVOfDr
   uiZBN1PIvLMfURgKtd+2fqS8OBy83aN0+NwZ4u4kv9rc4ZewhlFsX5SFs
   JjlirIq6asBZJ+SL1Jri0NpvNatwBs13Z/rh2RP8cALcBD0KiFA9Pxeou
   Q==;
X-CSE-ConnectionGUID: GwgqoLByRvyy5ENicB/0pQ==
X-CSE-MsgGUID: 76H8YczDRUCchxZYMxd4Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="102549318"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="102549318"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 15:07:56 -0700
X-CSE-ConnectionGUID: AOiJfBRaTRGOR0QlC7i2/w==
X-CSE-MsgGUID: 0T3XJiB2T6iIXhhVKM2P5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="276382341"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 15:07:56 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 15:07:54 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 6 Oct 2026 15:07:54 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.1) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 15:07:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0cNJtqoeVp8+6LuhK+kGpJiRdOr5bEpYHqgLE9o4wU48fAN84fFmuvfZFGARA6J7ia8/cndHjX5hrtquTRrVGOYXq/DfnVqMJ5HLZv+dl01Ye1JZwD5la8tGNnvdYGPfpWaUeWO9JBgUoSHwJ1nKDTmY0xeUH/P6wqL9pA8AyXhWSbeVxxRciBHSocenwDTW+VM7cPrJNfbmkpbkajaGjs81eEZhgJHUMQGAMOL2Ajreamfq1gxvwtrKhuzHfq4GaxJ+22AU+t7Tzf2p+7NBIXdjOb/JoFxDb8YYve+03uYhm9gtHfCkrmqqimXGNB+9P4TPm9wpoGldGo26YeVjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q30OnEJedlZu40/YkfZGaR/jg+XQH8oHNVFKrB4TDN4=;
 b=gsLQy8RlNSq1Wdadpt7RKkfyp7Abv8PT+zQ/UP2zq5gmzCvjkbwqkMA9I8v815QS6iSmwW0B6dEUDCox4oQSY//aC9s409G/qvljZG3SZGWW2thbtjnHvikX39jKJ1sInKLbMpJId4ejkXc3Z6+Y0r6vHCDxIvJLEos6xZOwpX534S5whMXaSZbmIYjV40hLXVaSPzx3FYyypxqH7N29U7sGfW2Yo6eAETjAKMBVw2gZhxcmSk2CEVRMe5UMVEFFtL5GbvPrriiJnXnc3FRg7xKLGq/shAM24HTaQVezVhf8B9cocYYJ9p/PdiWmdVP/FnH/0KVZvCuO3idE2UD8Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB6897.namprd11.prod.outlook.com (2603:10b6:806:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 22:07:51 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0496.010; Tue, 6 Oct 2026
 22:07:51 +0000
Date: Tue, 6 Oct 2026 15:07:49 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E
 Box <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 13/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
Message-ID: <asVxNVeP8d6HPRu0@agluck-desk3>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-14-tony.luck@intel.com>
 <327d9248-2e4f-41b8-b4ad-4f6d01c85ecb@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <327d9248-2e4f-41b8-b4ad-4f6d01c85ecb@amd.com>
X-ClientProxiedBy: BY3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:254::25) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB6897:EE_
X-MS-Office365-Filtering-Correlation-Id: 57326ce3-4a51-4adc-8242-08df23f64348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|11063799006|5023799004|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: Pj1a4C2BOY6f65VY4l9gMbb2cvtGqslU14TbYn8+nFtIl9KbSc01sQ1aOiBZ3QPZ6GDCup+gEa+R94JsUtaVsbqr7oZ7XH/uSQCDm9JQHkJskUuXzWWkEZ9tuWnpKrFyuqvfdyVU2b9XKBETbSWjLoKDdgvPMKXsGOpX+TGoXtFJYtqSlAO2ZMbVxKBvTBP7attVuWQMhuagrY+2ZNCUFuA7eX30GI3aUTdkewnMIrJBZsCe+GVBTLEYUR+7q+tedthwwTSHLA4JbKyhnw8Mnkm/JAcrbXFx3YPNft4+rkJ2CzyBI5WOeimIzWVBIA6KHpJDsRFMSSX8Iu+5HWUomXDfSSp5Ysms0QX/UX95zfWiYKAy6ePJ6OUqWpvdl5dCbKQJQzvsVvjLLoMr/LxmekL8sRRr5HzLhPS1oypATUSeYoSKenw1/Z+XZVR3bL1YpQJjvwSrf8QAUQLB0Boish8QYuY5ZOxKdJcTAtG/pSQsPoEsiIuJOB7BeLjHFdjJRtA6QxCoC6oUUFN3aVSO1wA0CZNFsx5Fcr53OUj3BPc+uDFAmXXQfpm83GE4KqQs3SrW5UnHOdNjdZBSEdYfJZ8LgXKmuxNdITl3ukBDqDuJwNMZJfV6w02vmU4PhIyVBe2757pfDiQMdO4PgNa0x5tqXE4lng7Ww4ujQ1L22vk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(11063799006)(5023799004)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TxokK7m3HAOUiEqqiCpUgUL9c5my+Dm3MUrJP4DTYmcGljRoMs8RuMQaR/Vy?=
 =?us-ascii?Q?V8NChkcqJpH9o4ubbkvnnLSUo1pVRbfuCpYpRUWS9QngVWwXS//+pagwBcUz?=
 =?us-ascii?Q?rkkKexY7CCl52xzpdqID0OxQSrJJBt+NVIOmWOQT7z6HRjG161/LaIRHO0pw?=
 =?us-ascii?Q?z+PTTKxMeohd/SlsbIuDuN/fXR8lIQ38pZHldbpFp6RYX4ru+lPWSE4THn5w?=
 =?us-ascii?Q?gbko72DPA1sp++4cR/36LglJd5YgGK/Uq4l8V+CVm3RNt5tejxDhLveLVFb7?=
 =?us-ascii?Q?9o6E8n9FSC36FulYP2LMElPxhGhRDhf1NCvFIiU4dYYK++DfpugK7IUbV/dn?=
 =?us-ascii?Q?tW7tk3iVVycyecCq/PKIYdIyNzlFiB7lTjYGtph4HeZbwXpVyFzv9cVkqEaK?=
 =?us-ascii?Q?qBQXgVPlDgH0B796CgOaVa1y3QfEW7Ehq4FdKJ7Tp6BGBd424bPhYVMM0Xp6?=
 =?us-ascii?Q?mfzAkXl89OXj0a7SwPxvUwPqged9LfkAVPIWMy4ABFDj0YTQW42QMevob1/A?=
 =?us-ascii?Q?hpNfKLZgHvVm/H3DBK65AdCLTlK4vDyx532SFliLAlHdfjCVng9QUYgZKg/F?=
 =?us-ascii?Q?iGgVlyxJNt5UE/aRaMDKPmBiRAT/zjriTgR/hGDJsfhTPzlW/H9VTs4pGS4h?=
 =?us-ascii?Q?kQcG4bEizFXiitUBgzrwgmzR1e2mqJeKYUbT7gSOvDMzF6/gee4lUTwoecph?=
 =?us-ascii?Q?u9nNoy5M00eT+rYdPonVCkWgei8g1DznmYIm/JFUpeLsmdLY/OTGmcgIAvEh?=
 =?us-ascii?Q?OYKlq91s1defbCxf2QzfobOpcydV/5jdvhzubOdy07Un8+Db3S0AqbJQFzoT?=
 =?us-ascii?Q?fkA7hDNQJ1fz+j3OWp4VPUgxHZJIcSR2+1oOAqF/MsfWzIe4bQq4FVL8GmaL?=
 =?us-ascii?Q?ma6nmcc0NcvnVmny79vPKP6c0Ng+/4fPerhacSz9gd/yjMsJT9tEQHyQWA0H?=
 =?us-ascii?Q?/WcEIEpt3CwWFEZlaWLy24iIeZL5aPZdQr88lH4xJ9jCrh9SqLWzV2Vrthtw?=
 =?us-ascii?Q?H0ilPxCX7+64Q+utKTDMEVdPbA2fHq6YoHU0eP2kZZ/EjzLtHvS684lWFsS6?=
 =?us-ascii?Q?I9UQu7iTinFWU4pNPZugR4b6UfRey/LISooC6OSTVrwhuqYBOypuBtP+Rk8s?=
 =?us-ascii?Q?EMbVSdf+SHoPsO7cV/Uky59SGHOzLvT1C0edl5KEc90QTccYeUClCR0ipUgV?=
 =?us-ascii?Q?yEo9yR8cnj4eNvj2s1IJ1NyiP/OE9ydP4lHA9Pf8h+81lXJ5FXvBrTgrfnGI?=
 =?us-ascii?Q?3I8UW54cm4DqPnQECnBMSaEOMw2FXbReKWzmBhtuLdjL7865aOVJY2oOO/kZ?=
 =?us-ascii?Q?T3hUipks2j8zjRqnEd8jALEvytytxS6P+gVBZ6vh6sldAGXnsr/miJVVuss0?=
 =?us-ascii?Q?K4TBqJIE6ZUZTGO7vayKuXfj1lxzx5tD8Je1sY1RnMW2SD9SKvcH+dtx6/Gz?=
 =?us-ascii?Q?8kic8BjS2n8yZxhha2B30AO6ABTgpoM5X0emLis9DAPRnLVQJOtKsRLOTD5t?=
 =?us-ascii?Q?P6KrNpHyf/MzQsFNbtuBrHqeFjqJZc8ty2ZcubQg6iFC5xtLdiyAGe1MYR8M?=
 =?us-ascii?Q?MZhVE8V0iCqULwr5ppzXn5jcjrFuZt1SuVEzCcu1bM6+aBQZA+9Or+sID69m?=
 =?us-ascii?Q?f2jc8W+rWUplRzuA/ZS1BH54Ex6vdz53V0B5fodzysBkBDV3DgJc7WaC0MQC?=
 =?us-ascii?Q?8Jy+3ckSPFE7DmkSCEHqKvs9fYIWlq+N6Ag1XYkUylCtOhOqcTnfY3iYXCi2?=
 =?us-ascii?Q?JbcSKOv6mQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: jnOhmUA0kSWh8lLcsOPzFpHrmWMGlTCriRkSLZtpwbnPOtVnekXdG37hi9O8Oc790d92sTXY+k6a88RqP3MUyj7LNfSnDs2gz6+YGPqIM1s3MmnYtjKUrzR7D/vThysNpkHBhVlyFsjLnkMI/W3RxCFm3idVOwxsVespiAjnENZGb0SQWoGlavQSlDGbsXvOovP39LKnt3OOSrAxPGqhXIA5GyUZ8dIGIYb3tGxpqjeEfdtHUIIN3q9DdAGsp/EyvDWRraZkuMUPQmh5/IvzisPfdKp/8xSPh98nedwtSGcprra5mYmzFcLqql9HLg1lJKXuvdumBVUB2e3QxbG04g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 57326ce3-4a51-4adc-8242-08df23f64348
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 22:07:50.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHo+CoP4oq79S4XGFpTfCJDpCHvAfmycILiUxSm/Ids+RzI6evxTzQyKUO9/Jy/L2BT9SGZie0ewqDA65xq21w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6897
X-OriginatorOrg: intel.com

Hi Babu,

On Tue, Oct 06, 2026 at 02:53:49PM -0500, Babu Moger wrote:
> Hi Tony,

... snip ...

> >   int setup_rmid_lru_list(void)
> >   {
> > -	struct rmid_entry *entry = NULL;
> > -	u32 idx_limit;
> > -	u32 idx;
> > +	struct rmid_entry *entry;
> > +	u32 cur_idx_limit;
> > +	u32 rsvd_idx;
> >   	int i;
> >   	if (!resctrl_mon_capable())
> >   		return 0;
> >   	/*
> > -	 * Called on every mount, but the number of RMIDs cannot change
> > -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> > -	 * until resctrl_exit(). Note that the limbo handler continues to
> > -	 * access rmid_ptrs[] after resctrl is unmounted.
> > +	 * Allocate the largest number of RMIDs that this system will ever
> > +	 * need. These cannot be freed until resctrl_exit() because the limbo
> > +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
> >   	 */
> > -	if (rmid_ptrs)
> > -		return 0;
> > +	if (!rmid_ptrs) {
> > +		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
> > +		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
> > +		if (!rmid_ptrs) {
> > +			num_rmid_ptrs = 0;
> > +			return -ENOMEM;
> > +		}
> > -	idx_limit = resctrl_arch_system_num_rmid_idx();
> > -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> > -	if (!rmid_ptrs)
> > -		return -ENOMEM;
> > +		for (i = 0; i < num_rmid_ptrs; i++) {
> > +			entry = &rmid_ptrs[i];
> > +			INIT_LIST_HEAD(&entry->list);
> 
> [1]. All the nodes are initialized. Basically, it is pointing to itself now.

This is setting the ->next and ->prev fields to point to the entry. So
each of them is an empty list. Maybe I should just delete this as it is
pointless. Later on these objects are added to the free list with:

	list_add_tail(&entry->list, &rmid_free_lru);

but if you dig into that code you'll see that the ->next and ->prev
fields are never read (not even in all the debug/sanity routines). Both
fields are overwritten to add them to the free list.

Note that this seems to be a common pattern. Code does
INIT_LIST_HEAD(&x->list) and then immediately uses list_add()
or list_add_tail() to put "x" onto a list.

> 
> > -	for (i = 0; i < idx_limit; i++) {
> > -		entry = &rmid_ptrs[i];
> > -		INIT_LIST_HEAD(&entry->list);
> > +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > +		}
> > +	}
> > -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > -		list_add_tail(&entry->list, &rmid_free_lru);
> > +	/* Find how many RMIDs are available for this mount */
> > +	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
> > +	if (cur_idx_limit > num_rmid_ptrs) {
> > +		pr_warn_once("RMID count %u exceeds allocation. Limit to %u\n",
> > +			     cur_idx_limit, num_rmid_ptrs);
> > +		cur_idx_limit = num_rmid_ptrs;
> >   	}
> > +	INIT_LIST_HEAD(&rmid_free_lru);
> 
> Initializing the list head without first cleaning up existing entries could
> be problematic here.

I don't see a problem. Any entries on the list are left floating, but
they are all in the rmid_ptrs[] so easy to access them again.
rmid_free_list is now an empty list having discarded all entries that
were on it. Sure, those floating entries have stale pointers sitting in 
their ->next and ->prev fields. But those pointers are not going to be
used by any code.

> The first mount works correctly, and INIT_LIST_HEAD() is not needed in that
> case because the list head is already statically initialized.
> 
> However, on a subsequent mount, the list entries remain linked from the
> previous mount through the setup performed in [2] below.
> 
> INIT_LIST_HEAD() only reinitializes the list head itself. It does not
> traverse the list and detach or reinitialize existing entries as was done in
> [1].
> 
> I think you need to replace
> 
> INIT_LIST_HEAD(&rmid_free_lru);
> 
> to
> 
> while (!list_empty(&rmid_free_lru))
>         list_del_init(rmid_free_lru.next);

That would set up all those floating entries each as an empty list. But
doing that doesn't matter. No code is going to look at the ->next or
->prev fields.

> 
> This ensures that any entries left over from a previous mount are properly
> detached before the list is reinitialized.
> 
> 
> > +
> >   	/*
> >   	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
> >   	 * are always allocated. These are used for the rdtgroup_default
> >   	 * control group, which was setup earlier in rdtgroup_setup_default().
> >   	 */
> > -	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
> > -					   RESCTRL_RESERVED_RMID);
> > -	entry = __rmid_entry(idx);
> > -	list_del(&entry->list);
> > +	rsvd_idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
> > +						RESCTRL_RESERVED_RMID);
> > +
> > +	for (i = 0; i < cur_idx_limit; i++) {
> > +		entry = &rmid_ptrs[i];
> > +		/* Don't add reserved or busy entries to free list */
> > +		if (i == rsvd_idx || entry->busy)
> > +			continue;
> > +		list_add_tail(&entry->list, &rmid_free_lru);
> 
> [2]. Here nodes are linked to head.  Basically, Head <->A <->B <->HEAD

As mentioned above, the ->next and ->prev fields of this entry are not
used when adding it to the rmid_free_lru list.
> 
> 
> Thanks
> 
> Babu

-Tony
