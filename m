Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B2733AD85
	for <patches@lists.linux.dev>; Wed,  6 May 2026 19:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778096941; cv=fail; b=diOYDS6m2XgAd7a20+iozGhW8scvoYIm89D45oQBAReGxVteM/7L9UTcXASa9nkokw5XltXYo7VvLxSdtos+wfp9kP3Eri2rFAnvULnfNSJ8agC6xbnbqxQlgVr9ZuAtamVw4D9fIbgLu65L5Y/NTtdfgau2Mj3nPqchrsN9QX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778096941; c=relaxed/simple;
	bh=97G6HkMllfMMg2JKBjZZK/BqoHzc7KumrQ1DAGs1Gjg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RT9A8vU9Cjo0nH1Uksx5oQ+gXY/jcRr9dLIJHdRPn5YfoiP0Z6ZkB+rGaiRnRyi5PpinYfAwniHg/9fDJ/85wKuhs9XFWnozRTojtz5mvSNXjcUzJok5a/+V79eKy2mANgnbh8NENRzyc7B82/1j4xFL9ZccNfVFaQ/uy4MYr7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mqiTkgYQ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mqiTkgYQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778096939; x=1809632939;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=97G6HkMllfMMg2JKBjZZK/BqoHzc7KumrQ1DAGs1Gjg=;
  b=mqiTkgYQPZuZiv7ifY51RNmCtweS+iRvL9AXBhylgabc7gObChrIJpDv
   jH8QEmaiEAhRrgKlqQQbQQt59DK+5gwYoEZC6AWQGIUTb9gCck7ig/WBI
   HN+ePfDZQPGImYhhAkBZ1jiq/42Iu/MuNA/+x+x4L7eVVInQLzDLmQZW1
   3ORcFDvluvTnV16fbK1zlWhF0p43qm2/V7M838QNbvDcbhu+A4xhbTngn
   rjBO7aVo6zoyDAAbJc3GOkylWo/fMb87GsVB4dHhL6pZZZya2SGz/c9cc
   lgroO23LWYXpbhsOXer6/m2WRzO82JC5DhLtibVsV0/aEToj4MxCcaThM
   w==;
X-CSE-ConnectionGUID: s2MJSqrzTXeEsAxtNnIyoQ==
X-CSE-MsgGUID: XuHYJN9QTgyTiyKfd4o38g==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="90417385"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="90417385"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 12:48:58 -0700
X-CSE-ConnectionGUID: YsFIEwHETIWlX7sRASHU6A==
X-CSE-MsgGUID: Ziay8D6LTb6tCOBS69FlPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="231709612"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 12:48:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 12:48:57 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 12:48:57 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.13) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 12:48:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAUdmLBpaRIdzDxTEec1+E7cf3BNXu8nOXyXICJd3FgJ1uOwxWCloLvOaK1pg9R+VzuUJjJctQp6pMFhBTjjOxaE7PHpJ3bFkxo2xvVZDZm4SYdWKouUrfJVH2Pdc3ec1ohZlolwX0qkDKzaVPmuRmG42j7mUS5LrosJ29VybZ3pftemy/dZa97H3dcYnJBtxn4c+++z8NG2814ZXt+jnTZ5/yTvJ/tJAiyca//atPEtZf0qZlApgPAnmNTTtEvG7qO6OFbojcAO0dcQ6dvEZuEF3ee4+KDgTLUgj5lJdu+CbvN2sgRSzEseagtHsUSp0RvwJAhbSMC2AzqHyUXvHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvXv+WtpTH8n8yT6qjhj9wtZgqxyjB4BAZcXL00wxIU=;
 b=dm9400vyOMmD86xZrdjmryi6exhYqRvotpA3QVzPB7r/Vb15Bm2BxLosZKaccfdgPCY3j89InvFxTbvaGp2Hj56mUTGaKiPXwyKU6JKGXLpn36Gi7cQ4nWoW+dSUSHEMps5DnDaawOCrZ9Lnd8srTpTsn3MC9CS8hxLoRv8LjJoRPzQjqWTDFv/8WcVdxxPE/PvNTEPNKYu9Q82HZI/eSyV1c98XD1UEHkFhQNQCywcIcnyUZnbsCHTJOFj4W04AvsOlSt4l+0vHFc7KXcdxyJXjyngK+W9aC3Xmr7cEfAMO+6jZqAojksRboWhIS3J+QLJvYoSDNEvcEohW7mHfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4583.namprd11.prod.outlook.com (2603:10b6:208:26a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 19:48:53 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 19:48:53 +0000
Date: Wed, 6 May 2026 12:48:51 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Message-ID: <afubI4kYrdWUXGUR@agluck-desk3>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
X-ClientProxiedBy: SJ0PR03CA0204.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::29) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: faaf6a39-adbf-4b9c-9d72-08deaba8803e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: rHMDUcs+4Llf478KoAcf44wMSTeXml/koTGNFM0iW6kDUWTrPoAG9Qyt1kOcI3orTQfJw9P3SsoYQTpfPP3EZ2pEpLbgsMIU7K/qWtY7EcCbDw9KiR8lVwnLlakGvoonOK9if5nxyX8aGLmUn2AFU52gvZQczBt2Dp4E/RHmeBHzrqYGnhl1h3NnHCPWDOpN4X9p+px9PHf0nmXPScaIE6/tkTEK1jVonXo8Elk6l+1kL5mXHB3CKoSCEGoEzPpdbkixKatSo1LO4ho69RaaiwDBDnZxckQRK5OTDv+lKhISSH7DPjGglOrBfv6o2JFb+XibWuY9g54V9+arCqlwye5D1kg0z7YRl9tIvlbAmhdnM6IDliXjXvKj+8JrggH5ss8yane9gsKfzTWrx49oCUXTR/k60xN6LH8luxnLi2PrNfStovJM9ebfDxp7sHRwPkA8/cmZRgVHCewPYP9uZVWVzqU03Fa5mJv/dQzMPXq5ltOjAkKr8rM3OwGU8eTiMcFe3/eojXBf3WTA4jVPNqHRVqL5jED/Q/GhADKGqNPmcTNURsHPPv6hYWA8FwHNFVVaishVI1MHaaC51gy7tmZySLNqpPf5cZZS7P/W/6cEqwPJlUYu0yWuLiTRFT5ZCYDzZ7EsyDwCXjjyctFzJcbKUy75lbVSihXjHdsPkUrW2q1smILbRY7BayLqwjoL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JRdk1uZyxurkbxnxUFgCTDZW9beuElRCqcwlnb4i2qgC/U62mODGFjAWeJA7?=
 =?us-ascii?Q?k3bmgq583CJuHFRt6kJFNNfEyJLVdIo8/LhDVmer4mmPoKe5YkyBbdWGw6mc?=
 =?us-ascii?Q?MozNQ8Y4P43MQiOFc/ijzqBEDUPChqHrGTYZkN+K2/LrU8SuOUTRc61t0Kh4?=
 =?us-ascii?Q?/3aPgYA0M4CTzCoe7xQ+jFi1+sYTHXGrzkI12Q8rw2fMnnbQPTBArSvAcMsr?=
 =?us-ascii?Q?na0jHMCU0U/SRqd+8XrJ+isnrNvh7VQo9XqNqFBTX9VwuQ2pT/f+tknQbcQP?=
 =?us-ascii?Q?fRo7j3gMCGNosZ3zGCoBhY9E8tbPCEQ33Ra/GsgnYQyU78Zn/BfgOEmdQDKE?=
 =?us-ascii?Q?Ke7KfVtfQCb+FmcaHF/GSa0ZND2BXUefLGdmRzaieOS6dcbG0ip64E/hwXi/?=
 =?us-ascii?Q?b7+YJDS3I5ereeO7Vd2oFd8eSY+9Pt4JLS6SpyDSqNy3f97Yqiu0DU/vRU1P?=
 =?us-ascii?Q?2OF6CegdNQGXbTuimZ95TJFA5i+KJ69THO79x4FGG2eC49b4oHvelEs5t3YU?=
 =?us-ascii?Q?qh6up40uGFAQywyUmhK3qJvTtgBauQpj1Oa+LS916PcpQ7/dhPRLT6p5mqcA?=
 =?us-ascii?Q?AOwg1cHEvnGllbsKN4PHt1Zlh/XYqiRUHeylYxj71bMa3PkRMC6Q3GJotaVQ?=
 =?us-ascii?Q?mdi/Q4z4jRF5s/N7+OhOUTVatO3GwwVuEga/7psn/gUlLO8bj3MNvgSI5m9K?=
 =?us-ascii?Q?5ZgeiUAgI/3/7x4JZ3//wqZa/JP0cIv7Fqh52ZfXNfTvYA7dIIvbP4GHBpAg?=
 =?us-ascii?Q?qYx3CyEBHLQbA69SPiS1ZH2QmbUNllMcRJ22M44YMlkIBsyhrdWB5nygrbI6?=
 =?us-ascii?Q?Alu48JZCmjlSWkNc/nt7mk45B+/7+3Eb0E7a7j0FWDfQBrcbUT1oGfGZDVSu?=
 =?us-ascii?Q?AFWraigaWlUVxI34LtrLtYO/cN2AHYCFXQt+C7PWWp4CZQmruNjaILDY7QJH?=
 =?us-ascii?Q?e2jR8NTj5o9MTJoNtNU4ZSOP6mV0nmdKhXPgcAdYt59LGmOqS+MvqMqSB77x?=
 =?us-ascii?Q?+upXB9YWUbViqjftzp9rQj/QzqDxnAQrXxcEeCqkVynLH8owoxGophQt7gzJ?=
 =?us-ascii?Q?WoR5pxaeIh2ZR46u+m1iD4UTWr7LqGH4N7tYQDVo1+gzqb3jCyxhhehMoMYj?=
 =?us-ascii?Q?JvJ8yEi3MQxmQT9DPhm9R7U1ZBkxLPRTJQCUM6gMIy9lQlQ9HqmohKOayMIa?=
 =?us-ascii?Q?q93Tj0+kytSuPEVPWJTLlWL64Act/9ynxrvvIW67ynk34nnzpcGEdVTGInWO?=
 =?us-ascii?Q?1kSATfo5AhSwizM3wFeJvykIb4BDBRLPXbTAXW7Lk4DXejw/uZB+J0piYlJ6?=
 =?us-ascii?Q?rsCu0uMWZVtnKvdqa8jqRuw+FYyV3U8aPQAJbMNYty5fEwx4ly/u2Xcq1uz1?=
 =?us-ascii?Q?bEPttVOx2U+Z4x4Vi4y6sZ1px0sh7xMOOveOdM/EoDqNYovRW/DytuVfosVo?=
 =?us-ascii?Q?/4ci1UgvOtkaa30ueElKEsNSYK+0+Ki5aonPNf2s5lJhWvuhrJeq9qK3H4mQ?=
 =?us-ascii?Q?o149I8Z5pLBBi2dbgandlAD/1aDGqlarOEaXdnfywsQY2sCnZpvyF02PWjV/?=
 =?us-ascii?Q?XdAJvHGw7VB4RGn0S5RRJh6eljnNKCin3PPBg09R4e69uHHCrWpR38mzWnNv?=
 =?us-ascii?Q?gYVinsYpL5lcsYp9V46oUXDxkv99qcrcfDYQXopyh1tBKf8+e7Y/726r1Pfk?=
 =?us-ascii?Q?9BVzk6pyTBEyqnAzNOrl3MOoFZf54nGcXNhZRy1frIT+5DzGLlwoT713su29?=
 =?us-ascii?Q?0Sbw+WwuBA=3D=3D?=
X-Exchange-RoutingPolicyChecked: VRaW4HUd7LEip+6whNsBDJ5u1XU4YfiQ127ST84Qd0iQQ8yk7iZMHCi9KfPY4ZgUaXaXIYRQA+XCOWR/q9BQu2R7Sq47v11OWBIZsn85V7ZZC2NZ6bT4GI64954npkalWyWtbiHMZ1MPOIkMofBJQldqNxrlsMNn8xmJ+D8nyvTMoVh++RJNRxaTcVHNNZxsCqjolFBhrE1G11PlZ5fmFct3cc5iCk0kvJex7v92X3aPkEmLjcvSxBmj7iL0jK9m6v3EAd4OCjBQUoaotZ+8ZE2aUagK7jwAvfsO3tr1AblWR7TioSaPZVlsU9QtzaMXN0hU3oXXs4GAfeV1mSli3A==
X-MS-Exchange-CrossTenant-Network-Message-Id: faaf6a39-adbf-4b9c-9d72-08deaba8803e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 19:48:53.0009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mo4K7cFTh9VVZzAmIau0Jsk2RQt0gHOMvbX6LrzhXuS8t4i2tyAbT6q46e96koXSjrNgL0C4gRqJTVy7NXNQRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4583
X-OriginatorOrg: intel.com

On Wed, May 06, 2026 at 11:24:30AM -0700, Reinette Chatre wrote:

... trimmed discussion on how we got here ...

> schedule_delayed_work_on() will schedule the work but will do so on CPU going
> offline. Does not seem as though schedule_delayed_work_on() should be used at all
> if the worker is currently running. As an alternative, when it finds that it cannot
> cancel the work resctrl can avoid attempting to reschedule the work and instead just
> set rdt_l3_mon_domain::mbm_work_cpu to nr_cpu_ids to signal that this domain needs a
> worker to be scheduled and that to be done by the exiting work.
> 
> Combining the previous ideas with the results from experiments I think the following
> may address the problem for MBM overflow handler, not expanded to include limbo handler
> and untested:

Initial testing seems good. I added a big mdelay() in mbm_handle_overflow() 
before cpus_read_lock() to make it easy to hit the case where cancel_delayed_work()
fails. Tested both the "still have remaining CPUs in the domain" and "this is 
last cpu" case for both success and fail of cancel_delayed_work().

It looks to me that resctrl_offline_cpu() handles this completely and
the additional cancel_delayed_work() calls from resctrl_offline_mon_domain()
aren't needed.

Do you agree that those can be deleted?

I'll look at fixing the cqm_limbo path in the same style.

> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 9fd901c78dc6..2e54042b7ee9 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -852,6 +852,30 @@ void mbm_handle_overflow(struct work_struct *work)
>  		goto out_unlock;
>  
>  	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> +
> +	/*
> +	 * Worker was blocked waiting for the CPU it was running on to go
> +	 * offline. Handle two scenarios:
> +	 * - Worker was running on the last CPU of a domain. The domain and
> +	 *   thus the work_struct has been freed so do not attempt to obtain
> +	 *   domain via container_of(). All remaining domains have overflow
> +	 *   handlers so the loop will not find any domains needing an
> +	 *   overflow handler. Just exit.
> +	 * - Worker was running on CPU that just went offline with other
> +	 *   CPUs in domain still running and available to take over the
> +	 *   worker. Offline handler could not schedule a new worker on
> +	 *   another CPU in the domain but signaled that this needs to be
> +	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
> +	 *   that needs a worker and schedule it now.
> +	 */
> +	if (!is_percpu_thread()) {
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->mbm_work_cpu == nr_cpu_ids)
> +				mbm_setup_overflow_handler(d, MBM_OVERFLOW_INTERVAL, RESCTRL_PICK_ANY_CPU);
> +		}
> +		goto out_unlock;
> +	}
> +
>  	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 02f87c4bc03c..cc8620ace7ed 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4539,8 +4539,19 @@ void resctrl_offline_cpu(unsigned int cpu)
>  	d = get_mon_domain_from_cpu(cpu, l3);
>  	if (d) {
>  		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
> -			cancel_delayed_work(&d->mbm_over);
> -			mbm_setup_overflow_handler(d, 0, cpu);
> +			if (cancel_delayed_work(&d->mbm_over)) {
> +				mbm_setup_overflow_handler(d, 0, cpu);
> +			} else {
> +				/*
> +				 * Unable to schedule work on new CPU if it
> +				 * is currently running since the re-schedule
> +				 * will just force new work to run on
> +				 * current CPU. Mark domain's worker as
> +				 * needing to be rescheduled to be handled
> +				 * by worker itself.
> +				 */
> +				d->mbm_work_cpu = nr_cpu_ids;
> +			}
>  		}
>  		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
>  		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {
> 
> 

-Tony
