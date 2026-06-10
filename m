Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8EC334695
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781109253; cv=fail; b=AQ1U8QozSgnk9B/dwNf1fL/Mat7j0y74B8b+PSJnd2BME0Z2K8V6z+qneuGEMqZfHFfX5Yx6JHvVsukdiwN/xmUaT+zGwAoTQH8tffqCQpZ0tJ/KAi/IVuGS9kRt/rJhkV+K/LL6GpODB5A+P99nBy2H96yKRCX27NdKYA1NpaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781109253; c=relaxed/simple;
	bh=KgUr01GM6Xj3AJuEngwVB9WHc09J5SlVLzvhzJCRQy8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R6jwqdxgGMZEk9EpalZuRje9FLQgH9/0QAehf6G94zmAuVtK2wje8AJqsNgGM/nw8ypNtAmbqa8xxyULsRhZbBxuSFpe3a9xll4YrSj+bdp960Zvf9lBJODpdT1S+Hk7uuxvS1WlrKeOFtETd3uYXnxeiwhNdIAl4RUcomHpOZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J36lrhGh; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J36lrhGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781109252; x=1812645252;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KgUr01GM6Xj3AJuEngwVB9WHc09J5SlVLzvhzJCRQy8=;
  b=J36lrhGh9mKps9LE4bZG77JlTObrwo3laljtt3PYZWW2c4iqKYjSba3b
   ZfIxkGjuPtJPMFWJ004S4qNocxdgFAbkNcakyVo4JqOnKmij9e4TEz/ek
   8rpKz6m/7pRl3bM0ZOZRtR9U3ytX02rU+2EwgPtCfaVSOixjQ525+YS9x
   I11t/2K7yrF8Vf9a8zQK+uMr1nQZGZnpokuSuxAPPJYr/xBndgVH+NqIJ
   qWxWyCzC9fQEjV1lde3pc6xM8wX/ybvXe5gm49wc0KpemUt7MQzMK2Xyq
   c+CWow2o/BunaFnSw6IfkfI1dApCWIzOw2N3tykKLk9A1DBEwLkZ0ZHk6
   Q==;
X-CSE-ConnectionGUID: nFhzHT78S2CVLbmqD0Ej1w==
X-CSE-MsgGUID: aCuy1ojhR0KVO7//3EOWQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="104571895"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="104571895"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:34:12 -0700
X-CSE-ConnectionGUID: JssNR0jcRU2wOBLXVoYraQ==
X-CSE-MsgGUID: RbszDallQs+BQVVoJWqYmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="284304069"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:34:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:34:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 09:34:11 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.34) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:34:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xcCutlnEFzfHAkT/n9XYxo/sJgkhRm+LiG8UEBBVFOoz6TUmYSVrAplShl8tqmkFsmlzHikJJtM2alT/R2TO7VNskJsEbflhKWuDWR8mk2X5LemkXOKH0tlnXhEz1B5ItC9kE1Qyc3X9m1CiaxxIn9p95+PTMcWHGZzEtkBHVU8nVMcyWoIHw5UZmThW1pe0laZo21qbufubZ+48y0OTdrLNfZv+Vx1bUCJgSOCbjjVMQQ0FWW9Tq+hDUW2vQ4OGTAWFrk8eLiR5fmVlyHHPk5O07o+YfUwy+0E3larQwdsv/LfqlxObOt2aVhK5BC+m67tJduBo644p2lAZT5y0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNY0hDfnwFiO6bHtqROAUpmC3ZuMf7a5r4nvBPV4TLo=;
 b=MuU3B4yDukj/G3U0IUZfrn6J9PPoydBL6rqPd8Brd0YfDwtdNenYRDECKVLNIYIfx2rFKJlQC3nBEXVLotXdCxRBq8SV4tc6w63l6UPJIWb/jUqZiSlk4XIC8KH+czDkLQNcUMFRJ+Z+PIeP9J+vg6q9D05J1H1qAMoMHlfVxVs+L30fyx/xB9QJI0QPixZdtkiR9BGK6xRSKRc3u2QB+CQDFkH1pixz6BAbJg4umdkIQnRwSnfPwC4H2Q/G5OC0JhIlOZcr1As0i+2t3DLcGUJYiLIgjXdFw9nJEeh1kPUvPnyvQNgtGJnz5X4wCVT5Tu/ciI5LPCOtv1Y56VbQRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB6654.namprd11.prod.outlook.com (2603:10b6:806:262::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.10; Wed, 10 Jun
 2026 16:34:04 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 16:34:04 +0000
Date: Wed, 10 Jun 2026 09:34:03 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <aimR-7ld7-EE_YCb@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: 913d2f8c-ba38-42b7-cfdb-08dec70e15de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|11063799006|5023799004|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: jmp4DtmdiBaMtRLdTZ5sYg3+H//MTR2QIyxQwirUB0YepqhM4L3ojHLqlMi9JceLjI89xQtnB2bfpmrKB78moKxrWW8xGlDwLbWvRHhXe9b9peGaldfOwxh3DrsyxWXWdzjlTzrl48Lr7ZBpsjxpFbMY8+EDqEWVuBNBok/QOmfqVj/nauLokhxEj8McTDz9OYcra9GqgGoKyhf2CcDLmSCi/BRx8EBf6nRFOaFjUs/6GeXAyVnqnv2RIoblvzubkJMZa14q3vnY+lLpHzLXggtuhJLuiGiE6Lq4R+u6JpXWsBHoUn0Z4EtgI/Ra5x+ADBMvSIfyhCzz9TEwQhiyJJERdW7rG6zIchVPvectpwYZa4RhABuWWw0D+3e1sjoNaJzmS03Gr5yFC0Gzy3dIWiwxpGdGhgU5qNoDLc9AU/LJpDKQ5guzuyWq9CBu+ZD7GSewsiPlfwnqIQRJUvf5zbidSCccFueGHwmJy4rH9yfXjnuLTUYi4aPM4RRuWBgGRgy1Tcp7+NNvrvO+sAb09cLvL3bcXPnuoZ5IIQHHq4Nmi2/scwHij75RLU3vGmnRJTZlZFCa9n9nYWqoo0iFXT8uUElguzo9wNIQhsQr2IQs4uqYDyyvMk9efQfWx7BpNlkzZ+QlLltJUrk/Nn/kQFiEPuDxHLPVP8lr5XnJr/pQxepe/sS8m+8VTYiYNeu5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(11063799006)(5023799004)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4WQlqr4rkTu+6tEOGf9t54yCZ7iOOns5jLc8fiEHom4sjW9bQV7g8f17Foqk?=
 =?us-ascii?Q?ZrN05JmOxho3jeveQEkfi2PZqN9DfEsQChxNUJi8j9HhNI7ZOMQjcpOWuXYy?=
 =?us-ascii?Q?vsA3SWvZHMMzqOVn1lvro3/XrzWsiAVQAYmKxgzjtmp5/qgfD4kql7hd9XQW?=
 =?us-ascii?Q?DstEpaCWvAkAatoFHVRBGUoSoblgIa22c3bCHsP083MbGKS4xmWkaZDhW+HN?=
 =?us-ascii?Q?psVv/rejOhJALuQ/8/XzTJXri4Przv+j5De9gx0HDNL7z9UBKPTN3yEQix7F?=
 =?us-ascii?Q?KgKJZfyhS/ljuFep0kAZJ2mYFUEDbn9c39w17N29khzNHlBTX0epbPknJ51y?=
 =?us-ascii?Q?9D47e+pYSEWr9wy7tqC8auukWs+IQuOfDbTgmWdPNLLFXoBZ4MgM0KIncxow?=
 =?us-ascii?Q?X3cTpUQKw31KpN7Zxca61mXK1O83ipeariE7bYuGwmtTH3uMPKw5fFcLKgzW?=
 =?us-ascii?Q?RYrK/gsXStMn5dcDNFRwVlYV0EghCO0BAHwRxpEN+HQhW5loDoeQcaeJV3wd?=
 =?us-ascii?Q?sXQxDrbM3OYfpQ6HpPEK/qZXfxSFg8DFmsllwN8Rp/QybTtm4ARU2mNM8YrR?=
 =?us-ascii?Q?PvL6KnbVGpUNM9mOvzIZE4OEl6MCYqXbNo7RpcnKPy0L5cFkCXp62bLyQGcf?=
 =?us-ascii?Q?6S8nH5aWlkKIcH9tssfxOYUDwfv50iuSGkrXYi4pxG1sf877M3dW9o9t3UCj?=
 =?us-ascii?Q?2zBs/17rzFwpzV/voYHzjYyyeCihlYeB2UAfyTYZ3m4yzPfUUBQE74ujmOMA?=
 =?us-ascii?Q?iF6c24vGpt2hQUV/dLt9BXe1Htkgea/kOxTHIu0/PwmvdAyU8xGCaubMnlXq?=
 =?us-ascii?Q?x8tO47Lb2gPK2/fNjt82AZ2qCJIYERmuQKcipQnreQlyy+ubsS43qmNQGaXU?=
 =?us-ascii?Q?rPLi5T6DmEeO7ilqbdMedT5AH+qpDLRXpWEEagehsLNhp3EvBJAOYrO7rurA?=
 =?us-ascii?Q?Dciua61qBOaOyuJTgVkJWOCls5DThUPmzx/7DE2D7eH/pC95XFGZ9s/+a70p?=
 =?us-ascii?Q?Gk2vztC3NutCUmezEp3vBMdRkx0r0Rzt7+JrGLsejKW/JXuGy2T6xdjNyc8X?=
 =?us-ascii?Q?8qdihNkqnGUk1LQP04467F0A4uTsdCSTQxciifW3ODCOtreyXcNIbT5IhRn6?=
 =?us-ascii?Q?tIZeayQHz4NxHprnGgx4R2iVa+434Vcq16QuIo+MyRceErn2knUrXPkbZQEu?=
 =?us-ascii?Q?7Z5O9k4ms0zN/28uTnJUvMHYH7CZyhqTsGGInz94zvL6bNS1bH/Dk+4ipdGE?=
 =?us-ascii?Q?LIUpaYfP/ReuUcb+KSAG13AHZl8Z67ORL8yiohZtEh+Scr8HTrmNwIs0XegI?=
 =?us-ascii?Q?EK7bN9Z0hiubtATxqNKmMosezt5pv9nx3yx/TaWnvEGgFjXUFDOHdOX0q0sC?=
 =?us-ascii?Q?jeV4fGF5cmKKlOPcVMHW5Q1/+ls1hxfUCAh+ECrKC3N7b2pjy/MLmzqa84HF?=
 =?us-ascii?Q?c7t7uDNBhWTxYX0v98N0q4mQ4VwvboWq8BOgzc+MXYWyd8KeuO30a/NfULvo?=
 =?us-ascii?Q?UeQgwGTLD5HMT5SCmq5XAgNNSgkpoOuio1o4k4QPUJ8vZ2EWUcm+ka1BYFcZ?=
 =?us-ascii?Q?suxdfTMvDZYo99794R0eY8XdaEGFfxmYUtQTWkTZtZ+Vs3Bd/UGQYbNuYsZ2?=
 =?us-ascii?Q?1s9SwE+b5UTwho+8Is9M/0Yn0L518Pq+RgT54nycIlPOTY+8vNY/mVW2BuYS?=
 =?us-ascii?Q?mPNfv9u47I36lkbFinuv1wllvvE94MVsvBU8sXUzm6Qwvg7F22hRZANap8A2?=
 =?us-ascii?Q?nMXVqvL0hQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: b63ofiNNJYZqbxdkHjYki3GJ8ePnDiMWBbXitNwPPouvbQ+BUras0pP0vrRVZ9N88g3fsvb4o4J+XTvtNXf8RcNRMKjy/8Oi0lBqqLyBx83LxpFmIjxdH8EFjRUQ2aiV2PGWCC3gwcU71PWCtVFTVPKZx/DAvm00Mz57Y3ciS5qFdO7VaC0iOxaAKwsr3KMFiHrG/5MNCHyfTJ3g56up/J/J8rOem+k3OM0V1AUelUFUSQ8wyXOAYd93IW5adw4PuRmShhX2QBbVCnQn0RrD56BCmF1m3vZ1lTiFHgTGE6qDgSub6BvX2DpvkpRvBVqeXcI0aeyAQMyY5i42+y68XQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 913d2f8c-ba38-42b7-cfdb-08dec70e15de
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 16:34:04.5020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWkQv9EddlCnusdIUo/mCKEMRwAzk3Ba0Jwna+ViPSrAuqiHVRXaGz5+8jSehCObQaOXQaaroQlK/f9Ce+7Oqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6654
X-OriginatorOrg: intel.com

On Wed, Jun 10, 2026 at 09:21:04AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/10/26 8:49 AM, Luck, Tony wrote:
> > On Wed, Jun 10, 2026 at 08:27:15AM -0700, Reinette Chatre wrote:
> >> On 6/9/26 5:08 PM, Luck, Tony wrote:
> >>> On Mon, Jun 08, 2026 at 04:25:51PM -0700, Reinette Chatre wrote:
> 
> >>>>> +void intel_aet_unmount(void)
> >>>>>  {
> >>>>>  	struct event_group **peg;
> >>>>>  
> >>>>> +	guard(mutex)(&aet_register_lock);
> >>>>
> >>>> Could this get a short-circuit to make behavior on AMD obvious?
> >>>
> >>> Like this?
> >>>
> >>> 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> >>> 		return;
> >>>
> >>> Same in intel_aet_pre_mount() for symmetry??
> >>
> >> I do not see that this requires to be architecture specific. This capability
> >> introduces AET register()/unregister() and pre_mount()/unmount().
> >> pre_mount() already does no-op if (essentially) nothing is registered. Could
> >> unmount() similarly be a no-op if (essentially) nothing is registered?
> > 
> > Ah, I see. Maybe I just need a better name for my "have_pmt_hold" flag
> > so it can be used as the fast exit indicator in intel_aet_unmount().
> > 
> > Perhaps "pmt_in_use"?
> > 
> > Then:
> > 
> > 	if (!pmt_in_use)
> > 		return;
> 
> Something like this. It is not obvious to me how the rest of unmount will look
> with this.
> Ideally it will be something symmetrical to pre_mount() to make the
> flow and short-circuit of the flow obvious.

With updates applied, mount/umount look like this:

/*
 * Track whether pmt_telemetry enumeration succeeded during mount for use
 * during unmount.
 */
static bool pmt_in_use;

bool intel_aet_pre_mount(void)
{
	bool ret;

	guard(mutex)(&aet_register_lock);
	if (!get_feature || !put_feature)
		return false;

	if (pmt_module) {
		if (!try_module_get(pmt_module))
			return false;
	}

	ret = aet_get_events();

	if (!ret) {
		if (pmt_module)
			module_put(pmt_module);
	} else {
		pmt_in_use = true;
	}

	return ret;
}

void intel_aet_unmount(void)
{
	struct event_group **peg;

	guard(mutex)(&aet_register_lock);
	if (!pmt_in_use)
		return;

	for_each_event_group(peg) {
		if ((*peg)->pfg) {
			struct event_group *e = *peg;

			for (int j = 0; j < e->num_events; j++)
				resctrl_disable_mon_event(e->evts[j].id);
			put_feature((*peg)->pfg);
			(*peg)->pfg = NULL;
		}
	}
	if (pmt_module)
		module_put(pmt_module);
	pmt_in_use = false;
}

}
> 
> Reinette

-Tony
