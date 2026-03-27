Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9654438BF91
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774651054; cv=fail; b=c0m1zaJjueVi9I/SqtfI/dCYApIksgTB6ZPh5dfxwSWPVV1+/oou02abQLbl4mvkpd2iybpzQz/Hw53SR5ZCDcayxn69dYsC0xm5kKk0wzrk8IXyC8yHTaCNGXSLuQq8qJTfm62rdb2dY0P42VPCCmp6hns8FsUydoXlQ2ADtAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774651054; c=relaxed/simple;
	bh=4Y+lrw2/+TIkgUx7dgEBIKIc9NgB0P2ndUPExk9WB8E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XLKM3V/a6CrlKID8wPhb/+1D0igONv3F0r48x/waNJh7n03Ko4s1qtwRzzKYebz9RrANoedEFk0CpLEhFxjLI1NeokqlnDn6lcCefDort8G0DG3kBeus1DKtQjs68jZqTUwqpfspwINriY/p5qIZUzJg8reN098hSh2Mqn90nPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ks2vlSFV; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ks2vlSFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774651052; x=1806187052;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4Y+lrw2/+TIkgUx7dgEBIKIc9NgB0P2ndUPExk9WB8E=;
  b=ks2vlSFVknfJK+uzDEXdGExOYpSipqbrgOI5wl+K76DC6hD2J99TSwjw
   wsGJxvi/jzuHz3metDyt4Xv0AFQz1qMHvrpa0EAbBQrj99rk1J5T0x40n
   qYh61iJW5gjJOpkcEdfNbUjmILZXh7tjNxZ/sclvzCORW0NdtRX6Wq2xA
   t/2NccnGlv4wQ6G6DiZzeAdjdz8HzjbMwXhKbAfWsLGNGx1/0EnXnqE5+
   O1qg5FEvv2P9P6RZxpG2a7M0GGZqsWfQ1DtIuiRTlxtwfplsRaWdIqy7p
   3L1w3dnYOQqxGr5KPDlSGYpN2lAHOXl/fCWftRPjqhCtSwkw5qzwSyfMj
   A==;
X-CSE-ConnectionGUID: dUjnzpISR6SNIJGK+UPXfg==
X-CSE-MsgGUID: mmU0dAtDT6iRwQdijBQZWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75845662"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75845662"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 15:37:30 -0700
X-CSE-ConnectionGUID: WL1BuStlQfiawd0NYM6VRQ==
X-CSE-MsgGUID: NNwNyrPEQwasdPqT3kFBBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="230223439"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 15:37:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 15:37:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 15:37:29 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.58) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 15:37:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQsYYfkSrHXMFmB2zpDyZ9XNMBAXv8JNQfl74FCo0VsrVlPAleAN1ZDU4h7Gc6bZ6ajhzK8xhsR2gzyXtuSqv+KX/bgCmygzvD2skeMbAbCfcXRA+vSB5LhPw0Wx/oKn7zfTdDnkykvkjW5U+AlrxUdDImceI+oPVJ+NS/unHq/aQ8S7UEuPbaCYcX5VYL7kdknJwaVPEDQSSRJjBhxZqB6KWLWd/cU2xkBBuCitZe92ssA8eUmgiRKgRAxuYUEnmpiNNAp6UGpv4vCF1bT+nXTLCLQVD4jYuQ5rhM+zcqupPhaxAE9YqrUBBzFKkJSPkpJ0wn/a+LfhqPiRaQRgEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6oQR3wtvL9KJpOxQqaGH1cwwxtq9DeLG8CUWTO4wzE=;
 b=AUPOSVQPaRORcC+nlwYhOLDCjwWOYjbXO5SjHbJCxplFPohpCfmemsEUh6D/nx1BO/KbBFrfmG0PQ1cYVs9kNqI2YQk6WZvjYkttlfKskEbgJOX0PFwMTvw51dT17r9rRdAFMVRVd3boeWBm43LirZCA7HgR+EuJ0t89eEtV87nbJf+EDsCmpGo9GYWc3WiXRNxk0s/4fl3FMmS+a44ZcN31Uw1Vga5ctdrnrPTLvnQR6T1Kz0qQfiEr+JvLq8u0RzzHe9nBbuUqqX73d6GShRzwaKfyFJAHhaZn27NnQj+Rme/0XtWg19hJTcMIjvrowfmpi3TX77fgZ3Wa8qVxrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9488.namprd11.prod.outlook.com (2603:10b6:806:465::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.10; Fri, 27 Mar
 2026 22:37:26 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 22:37:26 +0000
Date: Fri, 27 Mar 2026 15:37:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>,
	<stable@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 1/9] cxl/region: Fix use-after-free from auto assembly
 failure
Message-ID: <accGn4Y4mjLrm_ij@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-2-dan.j.williams@intel.com>
 <acbYgkczKrpG4x6d@aschofie-mobl2.lan>
 <69c6fc90593bd_1b0cc610088@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69c6fc90593bd_1b0cc610088@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: BYAPR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9488:EE_
X-MS-Office365-Filtering-Correlation-Id: 55975321-54a4-4653-ecbf-08de8c516bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: y/ApU0I0fQEnS4FKxbvcZXFdepJC+6O9ate1VUNegXdSVuEo5pHplOr0YFPUkOa+qp5PhvaTzFWuGBioG1JERfl4g2CQwxst4PhJ8DEc9rHprxvuoR8LYAXVaUXkwRWJuzuZa1BXc+oM7Rm+lgM+w8aMcYs2yicvTIqwh1jBKJ5aDmvCe+nWiwOu6Pi5q+Q+7tOrweiHyc6mdRMGoSguW9J031xXqE6aD9bLlDqQI048gHhJrmKS9AoB3zmU+2NE8mXBnsvawv/EkldMwXj7E9lk0WTPSsAxO4olL4cR4Zewef62OO4FXW+iIHXxNs8ie+FL7Dzl9TOKnlDaQEknA1Saqcpu+RUqeh8yTF6SSyCe4HTjIW2Gm+mu3THeNeOP017PGcXyCTRzD80xn/NvQMItjIzHQv9/fxgQbfTyanQU1BV5LAkVnvqvWibSZtNNH0hJQc+dZuFm68Dp1uipU/zgLMTeqdubtEkEZaxs5Y6WQpeQGvdUUyKGM31KA2Tio3B82+qKyxIgkWSmcVzb2TzNzv07BiNfRljY9iHwG9jSpaQE99jVVzurAK7BiHbRLquhNrLXvruduYj4YPKLdLxOf7cVwBp0xws8R1zsSyvZU+6miZ1Kc5i3Vo2UhRtAJ9I2Qc1+U3rh6mQxVJKxHd2wwcsir/OzH9sea2NwgWlDr0V+9dKQbzO+5B0u4VzBP5Mx67bj7nnUn8bvynIfBhJ7p8HixY+eVWDbznJvbT8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIGR1giFO0QNpW2ssYEVF2CTZa+qkRIJjeREBXGyJfFNrLnoQRxh4ebYmOGj?=
 =?us-ascii?Q?Yx3cN1GAB9SC58DqkRiCEXjTufSGBPW3d4EARCoir6C7b+KcRi2GYlE58iKi?=
 =?us-ascii?Q?PW3gJB0L/17+eoGlg6zL33wOaSMHLG60Su+jmlplGf3XwtJqjTowmjgNC8+p?=
 =?us-ascii?Q?R1FfIrQhlPyfNPlaXtQZfckR6+A0IU0aakczk3pnvQjRMRnxaS1Syzj+irU0?=
 =?us-ascii?Q?gEXb8G8b4HE43YD97hBIUHVVakUb2v+hWcvczxrnrHzm1oMctXP93AMfrWr8?=
 =?us-ascii?Q?hNp3nXvnsXl9Ea8/75YIQeU6Vv/Cft3KcyFJrx7AAivwoEEprN8QH+XRtmPC?=
 =?us-ascii?Q?Yhf7aClxrOX58deB1ZTkG9mQKRN/yHa1FfJkXw6q8m0jWEMfEL+zikK+5O8U?=
 =?us-ascii?Q?rJOdHfu1anHsZsUs9zjECfXnFbyOzejVdzhHIu7qv+tFT30j4z8U+ZE5NRLu?=
 =?us-ascii?Q?6V8gj0MA5sXnQf1481Bx/DI+XoMYarZ3KFb94KUl512whYh08xnoK69GPt1q?=
 =?us-ascii?Q?7VVGxhh8XwQc+GwKvAdjuixi6R8wTm7jO3TlQfB/BMZwEJyI00M2335GU810?=
 =?us-ascii?Q?0UxAtElejcTbrfeio4TywL30zIgg33qJhPLtusynAHgsIsR3yFRXibBzyZpM?=
 =?us-ascii?Q?xAx930vScpsRUIuHH6BpsA+yt8yHJISLyELWII99mEC/kLJUX206gJE0aovO?=
 =?us-ascii?Q?U+/qddB519i9lPfp7vXOFnHWW3qEY03Rnn2b0i3VaIybMPJYS+MTdSuZNHgl?=
 =?us-ascii?Q?/LzxqNbp4ydqYAUx3AI4kcI6CEKJ/PL8GBI1SVXVL6PwlsddmdT4BfsT7tgj?=
 =?us-ascii?Q?XeTqyWtJGFvx5xbNNL/LBZVxAXImtJnyMjdTT6i6Ar4dLYShU0/Spqe1R4Jn?=
 =?us-ascii?Q?ZvJuH9h8J+pxhbReuwruzHKq3y1yQ6SwO79CuDy00qNM5rYqq6ja0MCM7JhH?=
 =?us-ascii?Q?HcPJLe2BUFyjko1xOti7Q3VE3z9bXMSJt1L1KySi1ce9X7Vf5/sV8Fvc+fLH?=
 =?us-ascii?Q?1NpCp5++QpSPvcd3W7S45rXrMXVCPB970U4TnhRr1SuBm5AahKsL6tk/fU85?=
 =?us-ascii?Q?9EX+jCLC0+BotrPGL1VFINSDzGJfPwNO+jGzPKyh8J5DR0uLeYRqZnHuAdyG?=
 =?us-ascii?Q?BBiu0JNBQLVFJeNakXgthPudI9VgmBiFJJVvnjLCDW/0w/QQY4gu+0roo3k2?=
 =?us-ascii?Q?K1ShkXXFAACMeT8cIOXXRV3/YRnVgwrygjlv3djguSLqj327zTG5M6UAkTM3?=
 =?us-ascii?Q?+Vh2P9rHokkS3aX5djOh4TY+dDhu3rUpV1J2sNg4Of32tch/+4AdAuNbp3Rd?=
 =?us-ascii?Q?su642juKLZJDpdYfQn8Vt0vyjCXIw5b7cU/tVQCL7nwGjt0XiINedy/MSSmw?=
 =?us-ascii?Q?Ajp/RjSHY7RILMEMEefZGB6qhJY1e7z5lx+48yWD/dtrUBvJ31klCfRZ9IiJ?=
 =?us-ascii?Q?z5AJs87tnAzO+pZ2CFKicH0R15IAEzKpdiPN8groO5IC4WL0vVXThShYFYKh?=
 =?us-ascii?Q?p7oflg4pQ0MAyiHbIVFA0gVKl3QKnn4PZIqvc/q6szyafGe4QqOZniBhkJzw?=
 =?us-ascii?Q?KdYhIEV26oYF53K+HQrlU6wIB7kMIyj5tBjeOfhQN4RwbF3ZSgfu4Vv/VKQl?=
 =?us-ascii?Q?OgUaJGRtWAHCtnyHQTUJ7BXWdceePM+o5ttv16VDHzH37eNVSzfNr9AZvryF?=
 =?us-ascii?Q?keupJhmPh8qk9p5FMxxVnvgHxHwLRN3VrgbCupQftClokX5Z3+43DXkBYEWM?=
 =?us-ascii?Q?dj/nmB+2etL7fiNS1ziAdjKXT0lL7Ig=3D?=
X-Exchange-RoutingPolicyChecked: AEXdqU7CKT8pvHkwb9xnbECW6dDWzwEAn3Q7xqodYg6WUQQuz9PAXqPlYNVMETaECOeWIomfh5hJOv7Ux/zC3cwhOjy0nuRmE3oc7nSwr+EGEv8yCjNRlbpTOZutPog4KHo/wQIJu2ng0z3uL2fE2OqmZzj2ikfTCcb83HRmCGEa+dCPWtffB7yvdPJtRrPwSKcUmhlaa7gfyJlCBaUTukZHVaxb9CrxWm3x4qaunt/z+NwwdqlCNd+pyBvbWCD/ZhTKd5Snine69S741YQAOv0p49nN0vrNueQ3kaURH0fgDJuxxQdvm60z68gNwLzkZaVB/XuTcvRcT++AqJAauA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 55975321-54a4-4653-ecbf-08de8c516bf2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 22:37:26.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJ3sKn6d3+AyVUz5xT/jBeoJXm7rbwmIbiw/qjGT4FdWmXW1hKlYfdNi/Gm/+uqY86ylgY/8eBkFrZqRL9ZMeYg7tJqzY7PrzA3WCTEB2Jk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9488
X-OriginatorOrg: intel.com

On Fri, Mar 27, 2026 at 02:54:24PM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > On Thu, Mar 26, 2026 at 10:28:13PM -0700, Dan Williams wrote:
> > > The following crash signature results from region destruction while an
> > > endpoint decoder is staged, but not fully attached.
> > > 
> > > ---
> > >  BUG: KASAN: slab-use-after-free in __cxl_decoder_detach+0x724/0x830 [cxl_core]
> > >  Read of size 8 at addr ffff888265638840 by task modprobe/1287
> > > 
> > >  Call Trace:
> > >   <TASK>
> > >   dump_stack_lvl+0x68/0x90
> > >   print_report+0x170/0x4e2
> > >   kasan_report+0xc2/0x1a0
> > >   __cxl_decoder_detach+0x724/0x830 [cxl_core]
> > >   cxl_decoder_detach+0x6c/0x100 [cxl_core]
> > >   unregister_region+0x88/0x140 [cxl_core]
> > >   devres_release_all+0x172/0x230
> > > ---
> > > 
> > > The "staged" state is established by cxl_region_attach_auto() and finalized
> > > by cxl_region_attach_position(). When that is finalized a memdev removal
> > > event will destroy regions before endpoint decoders. However, in the
> > > interim the memdev removal will falsely assume that the endpoint decoder is
> > > unattached. Later, the eventual region removal finds the stale pointer to
> > > the now freed endpoint decoder.
> > 
> > I'm wondering how this is exposed. What is 'eventual region removal'? 
> > 
> > The region driver does not clean up after failed auto assembly.
> > The cxl-cli cannot because topology is broken.
> > 
> > How did you get here?
> 
> tl;dr: "modprobe -r cxl_test"

That explains it. We did failure test outside cxl/test. No module removes.
I'm curious to see how this fix may help with the stranded broken
region cleanup from userspace. 

Thanks for the detail below too.
> 
> When the cxl_acpi driver is removed the CXL Window root decoders are
> destroyed along with any regions that were in the process of being
> created.
> 
> If one of the region's to be cleaned up has a p->targets[] entry setup
> by cxl_region_attach_auto(), but not finalized by
> cxl_region_attach_position() then there is nothing to stop that @cxled
> object from being freed.
> 
> The "modprobe -r cxl_test" event destroys all the memdevs. When the
> memdev goes to free its decoders it sees that @cxled->cxld.region is not
> yet set, assumes it is idle and frees it. Later, unregister_region()
> sees the now freed @cxled in its p->targets[] list, tries to
> de-reference it and boom.
