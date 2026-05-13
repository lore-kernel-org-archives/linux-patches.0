Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623F3B2D04
	for <patches@lists.linux.dev>; Wed, 13 May 2026 20:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778703007; cv=fail; b=V1N4jawJjq1mgkRzYukwnrGZyzF8XFYOUMfRPDU/W398v3T5IOKCqAh7bCrkGpcFtzm9/0xZeYI8jDJfbJq+Fs70HCH/H6xJiJx5LaILb0AQ2/UC4EoPCGA+38Z6sXHpG9ATn4xTsEsSH9WJS2IeMCgjIWpUro8w4Dh8MkGSOsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778703007; c=relaxed/simple;
	bh=XycVeXp81gBVH1XvzVlhGrf1pX0IIf6am3hwIALzcB4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=soZbEgSL85GBcryYTIBxdffSlZjBumskyskNWqm9OJQSkMHDYeqN8k5MmuLTe1skLJRzv+YhoDqnxS/N2Ov0mn1HexMvFNxNi0rR5Ari7oZd1xigvFm8QRfnm++agabwM9Wpn4sYUZnOEa7pRB+kRTy4Y51OpjoNyOoTDaGqexE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EuBClWiF; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EuBClWiF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778703006; x=1810239006;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XycVeXp81gBVH1XvzVlhGrf1pX0IIf6am3hwIALzcB4=;
  b=EuBClWiFWwtE6G2+ZMuKYLWTMpUGZvVv5A/BR6oRNXWqYlTPGcig9SKJ
   jKI+jDdFxiQohc8+m7p8DB40uZKMlX/tpXuHZ7dBc+Xv/MzHHOD1fWHk5
   mf/gjtdTKFT3xkecwaLMaOJNkUpxmF3N7I/cbfZ+LDV53RoBuS5JYdnvG
   HVa3NhPDhh4RYgUZHOfrEnCNTkBc8pACzwDQdgjKEm25XJGl2lO3QpVoj
   LkgcK0jblCk2+qAKHdhEEt2mAEtaGgs5ctrRjopB0KI80Vl3tRXuVDqXC
   oG1GUrJD4Hnq0weauiFiQI6tPhEbtIxQmasnQ40c7qTHQP5albDtLOGJg
   g==;
X-CSE-ConnectionGUID: ZEZhaT17TA2fR7FZigZODQ==
X-CSE-MsgGUID: SjvnnXfYQyu1ghXTO1HViA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83512147"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="83512147"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 13:10:05 -0700
X-CSE-ConnectionGUID: zOgs3okjSKOgwLbe/GNC5w==
X-CSE-MsgGUID: Cly10F6+Q82O2ssJoZJJOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="261689737"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 13:10:05 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 13:10:05 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 13 May 2026 13:10:05 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.58) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 13:10:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zs7/82bqiAtG8fq0CQkwRSJx7h7ZepCU8+lgqQc5vCL5WO6N8uHRjN0CoiKF5k88APOiiLlvNFqFAwpSACyA/MreecoTO1xrb0Z7wv2twzUK4Qo30SUWqHudIRReKdrszsPUGllbSsDn6AKuMnEOiq82R3NEGEsze7OVX8YQucf87/T/AJk/L8GQg+x8Rxh0+IJqXWKXUy2WQ2rz25SSDpTaiCBBU2XUkXof0eXB39UD/+/rasAkf4ujMUApCmTlzto9tktR1M1GptrOtRs9bBUdOIIQzOTVidPBb1NHoDoPgfZyVp1u0XhKypOg6kFWykv4IQXLAeVqFyzjNfcc7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZICus/LRDXboT/vmqqFazCpWrNDRK1QzicuLXyxCQ80=;
 b=duy7EaGxuz9GKh4i+4jUnjtzzn14qDh18zKYnd6Hjp7q8SdFGMNvG8umCEOnnrBgQ+J9DY8G8cokIvuVaehjEzfu95/EBk3w0PfrPelEg23wbUKauOaaZjtm4dM2IJMmAzcvpNbOPsl8z4XhKPwdhOZS2MDm/dn2FwyHO9pjhP/BYovTS4wsKj8Na/uOQloplEIMboMZrUq0oRBRcvEwem5hsz0Dg0oEq+GcrTKAuBrzy0HkYOVM9+FVi6//n/dYfAwQAMTU1UbvcyDJVlOOmUxBGbiSlcdgjOec6dwA2j1WV0+tD2ATP4JkETH7u9joUF9fCpsVBDQleoMwvHC51g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SAWPR11MB9570.namprd11.prod.outlook.com (2603:10b6:806:4e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Wed, 13 May
 2026 20:10:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 20:10:02 +0000
Date: Wed, 13 May 2026 13:10:01 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 4/4] fs/resctrl: Fix issues with worker threads when CPUs
 are taken offline
Message-ID: <agTamVZ23ilhQw5R@agluck-desk3>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-5-tony.luck@intel.com>
 <1216ef85-9cc5-4037-9c51-6915bc6f4bdd@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1216ef85-9cc5-4037-9c51-6915bc6f4bdd@intel.com>
X-ClientProxiedBy: BY1P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SAWPR11MB9570:EE_
X-MS-Office365-Filtering-Correlation-Id: ded3c846-0435-4101-e103-08deb12b9e0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|11063799003|56012099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: dmfMCytIWLXEePq1PNFzqE5DR4+tSBvNW8mPw4PbVxOhxG1jVyiCgXH+rmmPpUE2BOK7VoztAKiHcW3mHqi6+3hyC7fueaYWbeGAY7XzWyjPFp1CCjYkaQZ6aCD5mNSwISsWnpK8Ph6BWNwLpJxictNAiIlp3o05pKKf7d7hXgj1CruynoL79khfVKFdH/i0ULJ8BOh4OWxYvQYKMffwRjB+iwPmZor9z1MbMCksI82Oqj2eqg/fdH9bGBQ0S0RrnNfwb7kLlb+GuP/GFVlJx5SubBTzaTfC+2VLOszCaITRC9ej01JJnwhYNUZO86OORoy65VOAZo/ZFBOwdcadQM3GQ8jBa7+BauVjfSiFtYoaVwl//oSQrI0WZLa2WCCwktVbtpHIf3KJ6WDg7UAgacGJmV78jJX5f88elzf1umgu0+5GHJI1sGzQIFmE9ipicyc30KL8n4QCtw1pbfRfgJ9lSnlceZk+4B0a35M8JsH8MabWtZfdhl7RmbuLbOvkL3AcjoxIvn/eJWwHQ1nPWmY1J0Gt7fX6gOixiDaaOhlwRMZZa7yl0cOPzgzLyl5ysrc+9onjW+XdFcmBIUHwNDAPYJ8UorFNIEs3ZFnAeusYADNMmpVvcDq9rs312ck0XYjrvZB0P98WrLyDKJqbvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(11063799003)(56012099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1NPZfSgWc8HdRdQmAxOxS9ssLfPgpmGavtXlb+prZP22vBygSxSSwm3XBkhQ?=
 =?us-ascii?Q?/AWby3aeEXjToUUXq50lgLIe+3iRgf820NIcjQ4eTNisGTtYSz6Dng8TGzLY?=
 =?us-ascii?Q?k1GhROAdlp9BAQ8dRTp1wV1ILaHUrgEVMBg96uEAamYgDIJY6tAM2ytv+Y6U?=
 =?us-ascii?Q?yruxQQE2N8RjWn1B36WBotN9I8lk7Bo1VQnZ82XqeksqL4dQUE6UsTcHovoV?=
 =?us-ascii?Q?OItMQq2HvZWck1lF5q1koqsR9Mq153ggTMZTU5OCOL8ewHEeastvKsmrJeQs?=
 =?us-ascii?Q?LoBePLmJ1zKUF3xHRBej9PUsMgTFhFneYRHCNhDUnAspXOMbYMhM041Qj72p?=
 =?us-ascii?Q?+RRN1iy44kTqJTtfAaug977omKFB3ckuY+wLUOgC33qYWQ030uPGItOp/lrP?=
 =?us-ascii?Q?UzGJxVR11Akry28PuywafaV2iGG6ZHU2Ky6BkuA1nkhjpTrWg8/PyohlPNyL?=
 =?us-ascii?Q?IXgjJjypXNcFCeER5T7GneLA/g7Lxzb705gaVWtCtxZ8y2kIoElWCppbgnIM?=
 =?us-ascii?Q?izlrSSb7AmlGD2LksCfBPhZ/5QMQmi5Da19mUoEpg/LCoi/q9dEVwI7eZf3T?=
 =?us-ascii?Q?zrcAfh9dUYE4JcMajLn/AAQ1dKKsLaJxyItbI1hcbmJjGlb9IbvQYy4KrvIg?=
 =?us-ascii?Q?PC6GKbdQ+2EJoWWaPek2ERRjaeIoHoOhzX3Giqf/1LkMjP14uOqAGA3lJGzO?=
 =?us-ascii?Q?BGyzuTXwaYXgRqE/xQPtxWO/cGbG6Zmidtw9IRAqa8Spcy7PSl699bww3HsG?=
 =?us-ascii?Q?uEr82cLWaCeKGEWcD6iIzuF8yz7l4BXcUrLQZU4W+Hm6URGcgErtnhWIDgh+?=
 =?us-ascii?Q?FNq5JzVu2F1OMOd8HV9CarANUsxDDmb1/JhuFUuXldV+ZZE4s+FY1NGcRYlx?=
 =?us-ascii?Q?/Z3lybPtkqYH2NWZalchpX/YWpJNrGLMELLtvooBHxLPtroXerBYUfySWhRz?=
 =?us-ascii?Q?qeeCNFNTFj5Bsu5CnIWoFYMtmZNu3msLAMKr1ycmHPL6zGWWYSwSa/9IuxJU?=
 =?us-ascii?Q?WRNUQz4SuT8oUFQFiCMgBZzKs9FBaF25gF2yLqa/XmTV31WASg1acmMe3t1a?=
 =?us-ascii?Q?5WD/cu6YGAmKUkTy5jIAoHhG8UGtLHk5JBQKEdi8bdilaB1KVAU+eJwZswBi?=
 =?us-ascii?Q?cv5JMETNDVPEcz9ZjeJWINavu8Mg0IQOHimQghQBKmWeTx/GIYxZim8szL60?=
 =?us-ascii?Q?AGOPWKJrgeh7sviDOQteRK+B+/QRQvj5WY+0s/k7NmrIsDtW5ElOydITfzPL?=
 =?us-ascii?Q?+qV6sY+HtqL70xEsVUXYZsIfqmLwXmjPbNwXoW4kBVnKUr7uCpAvkwXlgYf0?=
 =?us-ascii?Q?fa/NOXL0tGEKTx4leZdPdW2s1fG1ptx2xRlrTRoRwZFZ94CCwzoSa3qIkRZJ?=
 =?us-ascii?Q?HXkmfLkvf11sdUIDI0e9a/XqCpx//XAMISTOWKZ3E2cQNFY3//yHah5nVrGm?=
 =?us-ascii?Q?Tu0HquZUUW69lSMkNIYcDFMmrpUC6rpYD26ChumOw0rCfssuSZFMTS68w/Ka?=
 =?us-ascii?Q?rT9FsEws6264Z8TOniHaPZ735hJYJ/S+ipSFODJrd6Ts9+BsvyytAJyHsi/2?=
 =?us-ascii?Q?pgnHiO6ErGOuQbJCCfGs62j4dLUTwmoeX1Htxlh5pbDu+fHGH1/+S5MoKXRz?=
 =?us-ascii?Q?u1lBTWbUlkDU7NENoRf6TmqkZXQB+f2OIEeMECnwcEjkgGfMg4SPyOI3ndSD?=
 =?us-ascii?Q?S+1NCEFNTdzXJrZo6wYRGEeloAgoXWZnl/Cq3PRuUFyUsC6Lzb0K9wGrp+Kq?=
 =?us-ascii?Q?/lOUNyQ1Yg=3D=3D?=
X-Exchange-RoutingPolicyChecked: CEs6maZYvQ8EZcXCQmJNE+0VDnT/RJgVFZzjiToURWC8X5m3v9cCfg1Oib0a8nILeP5dEBkOOa7fQitHIjtEzqHQA1+Gyj5OgD4fSLmwzqUH3Y+WJL3pF565fBwEow/3/ugCu65ChzRT5imQdmAP059UD0s5hDicMliQlDdO0eJLNYI3rRnngFNckofyXh8Adsn1ccV9VdTycIGUoM3Ny9hPvEG/yDlkn+S19NqNaGMFpWdXt7do/dAgW3FFBjZbWrhV4uR/64gCwKm6Dq2iNftaEfgU7K8enLtBvaLvsrqzmHCMFXl2TnRuhr8n9IWHF85mQHEecUTl8QntXKhmjg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ded3c846-0435-4101-e103-08deb12b9e0b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 20:10:02.7807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrqEC+ZLKQvhWOGaa8ClRIZYFT1PQSP/jSzRm5HdQLku2hI4I8aRP9MLY79koLghUU1Nqb0rqlusMm9TCY3PVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR11MB9570
X-OriginatorOrg: intel.com

On Mon, May 11, 2026 at 04:06:04PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/8/26 11:21 AM, Tony Luck wrote:
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 9fd901c78dc6..02434d11e024 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -791,12 +791,38 @@ static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
> >   */
> >  void cqm_handle_limbo(struct work_struct *work)
> >  {
> > +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> >  	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
> >  	struct rdt_l3_mon_domain *d;
> >  
> >  	cpus_read_lock();
> >  	mutex_lock(&rdtgroup_mutex);
> >  
> > +	/*
> > +	 * Worker was blocked waiting for the CPU it was running on to go
> > +	 * offline. Handle two scenarios:
> > +	 * - Worker was running on the last CPU of a domain. The domain and
> > +	 *   thus the work_struct has been freed so do not attempt to obtain
> > +	 *   domain via container_of(). All remaining domains have limbo
> > +	 *   handlers so the loop will not find any domains needing a
> > +	 *   limbo handler. Just exit.
> > +	 * - Worker was running on CPU that just went offline with other
> > +	 *   CPUs in domain still running and available to take over the
> > +	 *   worker. Offline handler could not schedule a new worker on
> > +	 *   another CPU in the domain but signaled that this needs to be
> > +	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
> > +	 *   that needs a worker and schedule it after the normal CQM
> > +	 *   interval.
> > +	 */
> > +	if (!is_percpu_thread()) {
> > +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> > +			if (d->cqm_work_cpu == nr_cpu_ids)
> > +				cqm_setup_limbo_handler(d, CQM_LIMBOCHECK_INTERVAL,
> > +							RESCTRL_PICK_ANY_CPU);
> > +		}
> > +		goto out_unlock;
> > +	}
> > +
> >  	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
> >  
> 
> The issue reported by sashiko [1] is not clear to me. The claim is that if above worker
> is running on last CPU of a domain and is blocked at cpus_read_lock() at the time
> the CPU it is running on is rapidly offlined and then onlined, then when the
> worker can run it will find is_percpu_thread() to be true but the domain structure
> will be freed. 
> I am not familiar with the CPU hotplug locking but from what I can tell, in this
> scenario, the cpus_write_lock() in _cpu_up() will block since there is a pending reader
> and the worker will be able to run before the CPU online work is done. The scenario presented
> thus seems to be defeated by percpu-rwsem semantics. What do you think of the scenario
> presented in [1]?

I'm also not familiar with the fine details of the CPU offline/online
flow ... but this claim by sashiko seems fishy:

	4. Before the worker thread resumes, a CPU online operation occurs for
	   the same CPU. The workqueue subsystem rebinds the worker thread to
	   the CPU (restoring nr_cpus_allowed == 1).

That sounds like a thing that could be done, but did code actually get
written for this obscure corner case?

I asked Gemini about races between readers and writers for the cpu_lock,
it says that queued readers will run before queued writers because in
this case cpus_write_lock() is considered an infrequent heavy weight
operation, so priority is given to readers (who can execute in
parallel). This matches your analysis above.
> 
> Reinette
> 
> 
> [1] https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=4

-Tony
> 
