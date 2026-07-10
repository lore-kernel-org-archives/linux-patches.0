Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1435390222
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 20:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783716711; cv=fail; b=Ao1XBR2WU1DzD624+02palbbSGKQxFj8bbjAPzxIF/5hZPlmXTyhcm5gsR1Tg6mNogz44SzSF4fwbY8PJvgsd5zH6LvkrBtZ9F8gWVCJQijf6fbgeEaxY8V7Qk3lO96PLONZMCQzwyxShr5wr0Kk+hOOE5HCiNChoW46B+Mb7Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783716711; c=relaxed/simple;
	bh=ay0s42C509Fte+x5Fk4kA9NDhs1Eqi7gvfCCutwRssk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TAFHttwEAs+hUK7pp7wFXpaWY16uryO4oBcqgmFiGMFuDYzsPwUu8CbPmfwi/LcLGdXswH4/jMCts6zqu2b3O90spE1mEPcsv94i5WKwoCWESf4Mg8HxFksAB6B/x7RKf/sfjVKyjTCOIOCLEyE3f64/8Mg4w2DYXNHgRs63hKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EjdcCljX; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EjdcCljX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783716709; x=1815252709;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ay0s42C509Fte+x5Fk4kA9NDhs1Eqi7gvfCCutwRssk=;
  b=EjdcCljXPXyobCMpCXw0qH7DWRQ2oJpZ5Bd9oUZUbViDxUMVYRjTs/FZ
   Qzwv95BtigZzby9AuUPwgMCbkh9ozhMdNbSrG1ISIRF415r5nS5/NXgdB
   r9OnhMfN6EoaK0r9NVUJqoO71IqurUenAGWxnVu7183soNa+lfsPHhcGA
   bFC2+0DBlzFqBACWpEzJW/y95wgvU++xzSzJdwTiD86OVPFxV0omM9LRj
   uZELz9Bsf5KB05B3bUncz4p61hAc6UM2kZy8NPyOvVwHjQmFFkKc6tjc4
   jHPOjyLBQ8VX82k0eDK9BmCKu0QT6ZVho6DUOwaRVv5OHybVm2UI1ZkX2
   Q==;
X-CSE-ConnectionGUID: amO2zMxTQUamMMi2n5cwTA==
X-CSE-MsgGUID: z0qyNgTiQjCzmnAzzuiu9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84535099"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84535099"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:51:48 -0700
X-CSE-ConnectionGUID: 9A2VkWtxRhW5RuOnlYfHKw==
X-CSE-MsgGUID: HWBdaEyzTDinXUWOsyE74g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="253240682"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:51:48 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:51:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 13:51:47 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:51:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EaZ77us007eJtJiEMWKmivBlZypQkbIL8xeG2MAM+5sdpjVhNoPhd+xqWYzPCTjlEd9jyg+yzA/tbQizDfpxikFsq2HemaJJiUYCnp5bZ9KByHu6AF7ZtQW49j68NokpajQSdgHCeb4q08eF/aGeNwR0A4fvoWwWutnQY9HzXfmVHatHSYCjy7Q8i3mZl2QHC0maZRSRis4i/YnP/nmzypLhJybcO5b8a3BbOzX9z5najSqdwzeO88e3IzkP2vy8jwdXmsJdS5tHC1ZSUXshwAmHCXXGkbCRFCNI4pwIlvMSGEFlPg8EiAf1kOYb4lKXqqOC00OWGBXHutuvdLWV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjeuI8a4aKqtFRX8wJ3VG1Fthh2pHzqnCce4ehl7V94=;
 b=NizDXZHzBMGE4sYon+7QuHrA/HQoaSC2/eM+85mxnkHXugKWKUFF/BmzUZG6sJfZ1sHLONIGKeDlFsbT7uackZ5DqOQ9W1BWyD50W+peHHbEMEePo0sSiPbRhnl/FUODQNIgg+n8GRmzw29V/6cDbSG57ljbQxSZwUrORdmQw2zxao0Nc5uV9hyXYhx0wRi1N/a9FYGlbtoS494L3KCULH392YkzcjLhyKgJxNZJeNHBLoicmlmD/UelX66vAwaWczK2B3BjQhGWUGcF0Fl71k4u823fKiW0wFt7zkxpU0mCzufXjky946MjPU5UPz62SP63Tn3wYnEZnK8yohPthQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN0PR11MB6279.namprd11.prod.outlook.com (2603:10b6:208:3c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 10 Jul
 2026 20:51:44 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 20:51:44 +0000
Date: Fri, 10 Jul 2026 13:51:43 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
Message-ID: <alFbX0tItMg9CbB5@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
X-ClientProxiedBy: SJ0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:a03:331::10) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN0PR11MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eded110-959d-45ab-8624-08dedec50d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|22082099003|18002099003|56012099006|6133799003|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: thj6tj+2vOkwF92B5clj88W7ZoOw+e590aAoYFYB+l5c+qfCDl06vibxixVn7d+HI6YDVFqzYtfKV5/qbFaT4Qm5WKuySV4fFMPQktd2VBlhphBh/Blx/ARlG7QCf+TBygo47LyWBf/RHKjYhSiBBsgnh2heijai9PCvhpdFQcebL3UKl96DoOfiMjhozRASiVdW6EMtBiJJXRWidjEzEshK+JA1LCTrxsjZ72COrP9ezmjKInH1tZv1tsmZZ3PyQfXIidmqqOvAeHqudl2ReclyvatDe1sCiYP6G6uknW/Z579WZ0+CqTF6iuMdiuLTdgKdcpKHodf6YOuRopwFBf5TSP0Q9ewBOrlejicC04Y8G5N6q3mJNarkix/UD1QlSB39j6cql6HgdxKXtxRJWARBAcnPniN80sEVMq4Un1kyyHPnBTqtTcPqaOhPDv7tbWuc8dblTgWPfJ7bp8zs8FfvJokEDxYnRfjexO9EQXaahQXP9e9diKkkZiWURTnA1n46w4Gjpz9FNbLXCYxfto3KY0Uh/MQl9Zd7opItQymVBjqzMamoxGBgAtE53DP4Y6t8l7MgcZsybK8wOW9+kzYbt+S75LvImCoC55I4BSIvzlRcxIL1CLXhKTe3quy+PpQr5JohwqEn4Ob4fFuawLQNkuCWdigvxHqQlqNZ+OI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(56012099006)(6133799003)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PYKKIlsFcD+DDcyEzU4OxZE6kg2+I99vMBK6vKVBF28AmrSUdhvCk9hfV6Qb?=
 =?us-ascii?Q?nrS0Q/s9bUzhQ6Z/FPfCdMsYI6wRtva01KVFW/kTgTkOfKsik7SvXfN41ylK?=
 =?us-ascii?Q?ZfA3yP5Lj7jb2Yeke/ij058EBA0E/KK4hYSTn6FpyCcB+evzIfuzs0OyOBMI?=
 =?us-ascii?Q?resdNH5dluXawpkLA5FCE8+jXlA8HJiK0KLo9imZD5GX8Sx8ZB5RMPmfWhMV?=
 =?us-ascii?Q?wDlZRWSglv7NAh6vGCvxcl0S+aqvojSzEmo8/eSv9sPzrVzgUlNdvCS4WanN?=
 =?us-ascii?Q?zDdcMnP++0MiliYgp4zZuoGci1bdanYN6S4uu5xB2QkmeYfuHm768wkU9S2S?=
 =?us-ascii?Q?4gCFS36Z9WdFjflehNX6kWV19Jdm4xfn05UX+xc9yThl6+4w1LPCx4tcvvA9?=
 =?us-ascii?Q?IbmIvECE1bFjK7LfW+GMGs7Za3exFv5oQm1PHv980Dpd4q+NAdkqbvmC66MQ?=
 =?us-ascii?Q?a9RZfJviij/naSS9I/bg2Cv1qC7phwJ8fmjtm3ToiByGKdF3WNlthpBkki4m?=
 =?us-ascii?Q?4EVvqbEbIB38wveIIPMSFqUzViv4n+WF1kHIzGKvdqaAph2/wDG1D0aAmkNf?=
 =?us-ascii?Q?wJSAL+PkZHWAt4Ejpl0MT0YL5RkG13tW1eGEPVjAZeyrm36EtjCuh62ZZ2Qk?=
 =?us-ascii?Q?nokvQZEzlm1KpQsJKmHT40Z9Et5ZJ16S8Tbr/yksQMzdsQxfdOrdY9vTuDTE?=
 =?us-ascii?Q?woWZ64ZfdVKQrmkfz1XPSu4WU2lmoJymPe/5rXBMksKlrcgQwPsq8FGe3fa6?=
 =?us-ascii?Q?3LyFL3QpFNA6jPtI+Eoo9F1Dzf/GboXja4xGkh+5BvVvju9HFudar8xHlZfI?=
 =?us-ascii?Q?+jeYbA40UGcewAmjDrw64x7L/QqhU2aRahH+Yv0C6wixz4cQpGIls9c5Bvol?=
 =?us-ascii?Q?rUQmobizT7Trkya2hSCUCreqgV02hlRfzBIkgdkISWkuVscgeYLoMxt65bCK?=
 =?us-ascii?Q?uWChyKTu1tAlFNqtl/rFva1+sCuzDEzkcnx1UqTfOM/psvcUcy8n7mTxMrMc?=
 =?us-ascii?Q?quNkrLf+2uXXns7w5EixrTdiQTQ7pGM5aKoW3J4V3C3fDabP/s8RK6iNjMVD?=
 =?us-ascii?Q?qmMDw7LK5ggcjK3uE37l1uPLkQrSLtn9mP5QyQmingcHjrDmfHStngE8uyAp?=
 =?us-ascii?Q?FnfEQ5aMUh0Ubh5VR8cAZzSD34Bha9hn0V1kYWiE5/tEluPILJtdMclg/S05?=
 =?us-ascii?Q?8KU6SYjOwAJZheppAT/dghqz1Xadp7+neG4B7gtFZYShwBY0r+7KomITXjMd?=
 =?us-ascii?Q?N65g8BcDIjREsTQRNxEyIceCcxYlqraywKJ+MK5qJJtpFOshZKD4dOHzLC03?=
 =?us-ascii?Q?vt1zWrUyuLjqU6QbDcgS7Qyo/amNUKamnTqM8YpfT9ZZufRFEP6qhNgqaUzp?=
 =?us-ascii?Q?TVwUiT/cV5uGP+IJukO4AF5iEQ1+1ZBw4iAiTVtSzHcXAf+oLAKwbiW2YLgy?=
 =?us-ascii?Q?cVjM7tq6YtfUWnusGcIHwmPZ2OS/luGadqA4rGnNqlaT7EJSi/Vbh/ARe6m3?=
 =?us-ascii?Q?9MxsnirCrKisKT0YtxdW6gy2nuVd3vWhJa7H4kCQOP+Xf+H2+dceig513jsv?=
 =?us-ascii?Q?UOouP0fCsa/4Sxgapurmmb+9QlxMYUdEvt5qEiGRQdQa+ia7EJiiCPePBKOc?=
 =?us-ascii?Q?NTVcg0iS3vqjqeb9Ja6H66u1NRLkmYCF55vnNG8TYecEEY0uGa8VICzb2Wu+?=
 =?us-ascii?Q?t6Mmj0S4mI7K9SotiMWEe1J7mS+5ykEW9e+/Rkwkh/U9eXDCmQe1bZhXAnRW?=
 =?us-ascii?Q?/P8n1WS+jA=3D=3D?=
X-Exchange-RoutingPolicyChecked: pM32rw48EGuXeThxRkzP8DQ9UkD+87dmSzPW2NH/vJjVZ9hjw0gUifwge8XahmE8v3weMgP9H4zjSdrLrlA2YKSoxqqjb0op+/GGZRN+3nje3KEkR96LhkTNuBM5QmZvfej9QYhdcmXhu1J4aznl4arScoE6pE56jWzoiTgICAdp50E2Ds0jHDT+75AoaW4WNSekyb5j3Q0+kkjtxhqiRDcigo5QEuXvjiCGfMsChUKk27XkRxvwVP7OwPBCr4WbGr3Ao3C4lw2KxEYCBWjC8Bfr5tFw+URVTkGMf2m0BEjlV9VSMyoO2yQ3DyrJxIg8qGW0rBzwdbrNdcSbmNY81w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eded110-959d-45ab-8624-08dedec50d2f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 20:51:44.6009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqnKXxA1+gK1EBBPOmYznYdjc2DOC4HPhr8j2CFe600pIkSXKWtFcm8ORHMYD9tseVv4Ar6MMaNR6XFB9vixAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6279
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:50:45PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > Application Energy Telemetry (AET) event enumeration takes place
> > asynchronously. Linux builds the pmt_telemetry module into the kernel to
> > kick off enumeration early enough that it completes before first mount of
> > the resctrl file system.
> > 
> > Allowing pmt_telemetry to be a loadable module means that it is possible
> > for different numbers of RMIDs to be supported on each mount, depending
> > on whether pmt_telemetry module is loaded.
> > 
> > For simplicity, calculate the maximum possible number of RMIDs and use
> > that value to allocate the rmid_ptrs[] array just once. Also use this
> > maximum RMID value when allocating rdt_l3_mon_domain::rmid_busy_llc
> > bitmap and rdt_l3_mon_domain::mbm_states.
> 
> This does not sound right. Why use the maximum RMID for L3 monitoring state?
> It can be guaranteed that L3 monitoring state is only accessed when that
> monitoring is enabled and when it is enabled it can be guaranteed to never
> use more RMID than what L3 itself supports. Why would it ever be required
> to allocate more than that? Could this not instead be limited to
> rdt_resource::resctrl_mon::num_rmid? From what I can tell such transition
> will make it explicit and consistent (since arch code already allocates
> this state based on this) how the L3 monitoring state is sized.

L3 monitoring on X86 happens to provide the overall maximum possible RMID
value (any larger value with #GP fault when written to IA32_PQR_ASSOC MSR).

AET could potentially claim to support a larger number (and this could
happen on low core count SKUs where the number of RMIDs supported scales
down with the number of cores).

resctrl_arch_system_max_rmid_idx() needs better comments, and
implementation. On x86 even if the L3 monitor functions have been
disabled, the limit is still bounded by CPUID. Not by what might
be found in the AET->mon.num_rmid.

Though perhaps intel_aet.c should look at CPUID to avoid believing any
larger numbers seen in AET enumeration.

> > 
> > The limbo code must deal with changes in the number of RMIDs from one
> > mount to the next because some RMIDs may still be "busy" when the file
> > system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
> > for the remount. In this case RMIDs that can be released are not put
> > onto the rmid_free_lru list.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 60d50ac79e7b..3169441a2d40 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -144,6 +144,20 @@ u32 resctrl_arch_system_num_rmid_idx(void)
> >  	return num_rmids == U32_MAX ? 0 : num_rmids;
> >  }
> >  
> > +/**
> > + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> > + *
> > + * Return: If L3 monitoring is supported, largest possible comes from L3 based
> > + * on CPUID(0xf,0x0).EBX (scaled down on Sub-NUMA Cluster systems). Otherwise
> > + * maximum from any other mon_capable resources.
> 
> Above reads "Otherwise maximum from any other ..." but the code is actually
> "Otherwise minimum from any other ..." which contradicts the "max" intention of
> this function?
> 
> > + */
> > +u32 resctrl_arch_system_max_rmid_idx(void)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > +
> > +	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
> 
> This smells like a function that pretends to be generic but created to provide
> correct results on specific x86 hardware. 
> If this needs to provide max RMID why not cycle through all monitoring resources
> and determine the max RMID, why special case L3?
> 
> ...
> 
> > @@ -961,8 +975,8 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
> >  
> >  int setup_rmid_lru_list(void)
> >  {
> > +	u32 max_idx_limit, min_idx_limit;
> >  	struct rmid_entry *entry = NULL;
> > -	u32 idx_limit;
> >  	u32 idx;
> >  	int i;
> >  
> > @@ -970,27 +984,29 @@ int setup_rmid_lru_list(void)
> >  		return 0;
> >  
> >  	/*
> > -	 * Called on every mount, but the number of RMIDs cannot change
> > -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> > -	 * until resctrl_exit(). Note that the limbo handler continues to
> > -	 * access rmid_ptrs[] after resctrl is unmounted.
> > +	 * Allocate the largest number of RMIDs that this system will ever
> > +	 * need. These cannot be freed until resctrl_exit() because the limbo
> > +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
> >  	 */
> > -	if (rmid_ptrs)
> > -		return 0;
> > -
> > -	idx_limit = resctrl_arch_system_num_rmid_idx();
> > -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> > -	if (!rmid_ptrs)
> > -		return -ENOMEM;
> > +	if (!rmid_ptrs) {
> > +		max_idx_limit = resctrl_arch_system_max_rmid_idx();
> > +		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
> > +		if (!rmid_ptrs)
> > +			return -ENOMEM;
> >  
> > -	for (i = 0; i < idx_limit; i++) {
> > -		entry = &rmid_ptrs[i];
> > -		INIT_LIST_HEAD(&entry->list);
> > +		for (i = 0; i < max_idx_limit; i++) {
> > +			entry = &rmid_ptrs[i];
> > +			INIT_LIST_HEAD(&entry->list);
> >  
> > -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > -		list_add_tail(&entry->list, &rmid_free_lru);
> > +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > +		}
> >  	}
> >  
> > +	/* Find how many RMIDs are needed for this mount */
> > +	min_idx_limit = resctrl_arch_system_num_rmid_idx();
> 
> Since mon_capable resources can now come and go from mount to mount there are scenarios where
> rmid_ptrs[] may be smaller than min_idx_limit so above needs extra checks to protect against
> overrun below.

I don't intend for that to happen. The initial allocation of rmid_ptrs[]
is supposed to be large enough that no subsequent mount would need more.

I.e. resctrl_arch_system_max_rmid_idx() must return a value >= than
any subsequent resctrl_arch_system_num_rmid_idx() call.

Perhaps I should add this to resctrl_arch_system_num_rmid_idx()?

	num_rmids = min(num_rmids, resctrl_arch_system_max_rmid_idx());

> > +
> > +	INIT_LIST_HEAD(&rmid_free_lru);
> > +
> >  	/*
> >  	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
> >  	 * are always allocated. These are used for the rdtgroup_default
> > @@ -998,8 +1014,14 @@ int setup_rmid_lru_list(void)
> >  	 */
> >  	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
> >  					   RESCTRL_RESERVED_RMID);
> > -	entry = __rmid_entry(idx);
> > -	list_del(&entry->list);
> > +
> > +	for (i = 0; i < min_idx_limit; i++) {
> > +		entry = &rmid_ptrs[i];
> > +		/* Don't add reserved or busy entries to free list */
> > +		if (i == idx || entry->busy)
> > +			continue;
> > +		list_add_tail(&entry->list, &rmid_free_lru);
> > +	}
> >  
> >  	return 0;
> >  }
> 
> Reinette

-Tony
