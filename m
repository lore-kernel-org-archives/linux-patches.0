Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C301A6806
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781129374; cv=fail; b=HRs33qJN/4ahzAxD2KtMuCZi8UoIHRXWVOzm0jQJhcV1Fli2WW0LNPEB/YvIs2zKTQuQURx0JBsIc06VI4wpSTwWCAivN8Ho0MnnEkm3p01bKh9V6Cra6ZdI5IJu0LvomUXDbVfvqLQf8OFUi0UYSEXanrdgsMiDI5yGxtrI4kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781129374; c=relaxed/simple;
	bh=AralMKwj5ZUaFWwrZ49pOn6CCOY6Msub5EB+PDDP9Hc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gz1BTNoZ/IYV0xMYY/TAkN2eWJNJtfbs3KvYR9mk8rahYpUUwjkWD52iR7yfT6vqrFQiX3Le3yqP3Iw+WiHWAgBAcBzxW8yVd1UnY046EogNZNsVJUVQEOi4ziiUV68S2Nx39G/psOBDdajCsKGySaRQlexu7a4NZy2iO1A/U2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IRmFP0bS; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IRmFP0bS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781129373; x=1812665373;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AralMKwj5ZUaFWwrZ49pOn6CCOY6Msub5EB+PDDP9Hc=;
  b=IRmFP0bSYl08r1vAES7Td3hWmVtQGaQIQthLdB+dfampPHBq3ULFe0Wx
   JCcWZ0KSz8ADOWJKL7ZlLNJfMSIm20WeDp+EB/VYYsfiAhprAQOQXgCoV
   4ZSYhaGmhN1VQN6qRTYuSAPVsZVRn7RU9Pt8qcNp9lXs1X7nlRtBzDEKY
   ega+VvKcUAxLedK8YYiZnWOP0dWV1Qs+w8/XDG66u6FlDtGy7kiqZclYc
   AW8Vrb1f/FZppUGBDROEm1MGFsupUrA38iYLnQASjPp1ih9ZVMd3fv9/0
   TMVgBekSr3k7qCJXCyYPYf9hxyCFegHJ1EKz/MG89lireWk+BBq7uxJcV
   w==;
X-CSE-ConnectionGUID: 0Gnk3L5nRYiu9wutgviPrQ==
X-CSE-MsgGUID: O4H9izm1QEiITUQPZ0rbzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82128914"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="82128914"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 15:09:32 -0700
X-CSE-ConnectionGUID: wAj3LCkcTpG8VrMBhgOlnQ==
X-CSE-MsgGUID: fw7yi9jtQne2QXCGDfXI/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="245423479"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 15:09:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 15:09:30 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 15:09:30 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 15:09:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLbZ3QKQTXR9w7KHpq3cE6UjEAYhbr/Y8UIhp9+c58Mn+ruZjT9GCIOb0gV4qON8oR/Buajdalf2jZg5J65GI4TTAIFuvFL4Bn8CK06u4ezeGUFBbq/wBz30fffAK0CT1xq11nu7uREGvV+FNGbg+A/QakHf9zjWYoa/W0TqZKRIY8YRhRsHsTv69j/ODfiks4EyB9FRq+9/P9UIiimbF0khtBKZKLqupBN+eHRFRMGsG97aTpkDkjOx/r+AFVPqlBPDRmmTOOHAWBYq4pyc4ECj/osR1HwnpxhfrMGk9ttANFAhY5TBeatNIZpRjwc9sdrNaR1X5ZwoyUKyVXI4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtIKtoOK7Y7r13ucWlzXbFdBv+bsIgmrQ80Xxhge2EA=;
 b=v0hsrMvJdrUVDozMNnPqhYYCawAaNjBuObM+2drpX+RdOl15Lx7Gr5X6Z/BTq0Zsi3dL+sM+keMj/RXEL2EMikc3iCQdFnOXAIzsJmmBItI4857CACdcn64LK0XPTNZYy8prU8qWG8vJ97ajdhhEO/AtwqFpCBt/EYk2YjdBw2O5PUrgr/Z1BSe4dwle0JWC5V4q+0/i1w+AdebxZxG4wTJoT3/gSt707PF3PCujK58eoyPbVmFNu7RKt8NlU24jyLB5wgJL+GqUGHXvEdEc4YszmAsNFhFaHkPQpUpUH4p7RaJXo6q9whv9QGXG5k+v9eoyRl5hRcu1Hrs3uXKBuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7732.namprd11.prod.outlook.com (2603:10b6:930:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Wed, 10 Jun
 2026 22:09:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 22:09:27 +0000
Date: Wed, 10 Jun 2026 15:09:25 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <aingld8Hoz-x5MTj@agluck-desk3>
References: <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
 <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
X-ClientProxiedBy: BY3PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:217::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7732:EE_
X-MS-Office365-Filtering-Correlation-Id: 29259562-cfa1-4d42-0d77-08dec73ceff9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: JACRpuA2FLrdcyOigXg9muhsPlRvA+aZ3G/VoJtCckCG1t9hDPi7Z4R6uyf2PSIks33f8Pb9Pn1qsNxIoTpGd/bsPNaj9inBh10KpXjgUJG2QJNb4IqPyIev+CJ3QU2mdV5FHWsTzEnnGBfpE0RCo2g4pCypdhz+/YzGYC8nUOOaGXrzNEsEbWGSi8WtfWHw7C0r/UgNUlwF+dubO8a0t6RdvCR6WscQHhcq5XyWdwWky4a1EEL0paGyuJMxyR0aORGFD0sJLYL13b58VdcfMtxw1sJz6NDJXDLGkFAvM3jBwuloPwyHVSmezSXEdECMDDqCZs6oz0Ta9cZkr5FD0bzK7wDY8N87MgbxzbwYDDLkgCjdZOMnumM57k790TgjDW21ri9Ao6GVK7JOMqyVPJsKG4CaWNFJ3I4QBkiZG/n8xF3YALuWVBgn3kLPxjXzFJIWJ8Hg3KeEREdA2yTKbOEBr3tw8bg9ceSjV0P0fTYfbH89V1ruoYs4S3hW3j0MbZzWW4dK9eFFIO5dRQRoKD3JsRYbd2uzqlrqW+urupCN4U8KPp2wzFipFofSloNuUG0iRL9Lenyu0vdR0h7ajw78/RRICGgEYyGqT0Rmrz4D6ygQLq6FMdTPhahhzbbYxoFuGdjZtv98Zu0xwObJmfTsRb8Tfe0+xaFyTfQxCxdbJbcOwHMLKBuTKEWhPZIE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hk+4gqHnDpdVoz2y/+HEJwxWG/igmKwqJ0+oVaTX5q851fLrYSq7a6fxvU88?=
 =?us-ascii?Q?AkhjRQUwc1TB2uva0VGrCWxE947sxkFpqaUtAbCcVD4qCvqiSiQV+VZJiNtL?=
 =?us-ascii?Q?feSn1QV1e/EcnHwahUCe24pLiptW6JcsMYVdY0nKsWvaXM4rp4OaEKI6KSnX?=
 =?us-ascii?Q?ca0oPRd6tt6qum9gSMG5mjI8CVPKhBXLYEo0nu5tvmor2bAYZvRALtBintk8?=
 =?us-ascii?Q?xDAHz7A1cF9JJlBLStY1kceP2mpliO/CD8ZgwQs6QLxBmZrNDD9xC+nuu3ps?=
 =?us-ascii?Q?ocSFsUAkSXnF2Ysh3VBWf8BfgNYTzYkB3kLbqAXq5AjwDjMwXmd43KCY55qt?=
 =?us-ascii?Q?o58co/QqCERBWUGXC/mxcFZoSfnj+kWSmGu4mghd/BkeDEaFMDk3wLjZS0tq?=
 =?us-ascii?Q?6bzGifpK1QoPnrlgFoGCGnsX/JUkUfKZ+qlsynvmfkD+bDTgggetSN1K60+u?=
 =?us-ascii?Q?oPpTfVkVOkctoS0evpKg6RDLCft90xiK1mM+6uMmTGihQZ9CIofKD2G9SFoW?=
 =?us-ascii?Q?FSpcsYIPNTRcgFkhujhooFZEYndFgj9dvhe2x/71SOg1YeBcEQFHPuqWlARc?=
 =?us-ascii?Q?AGyVWJlpRO4WBuftnu72CwcBlSOol6MUcrw371104XWTJm2nEVr2889DoYrF?=
 =?us-ascii?Q?zkx/Z+06T4/KHW2SFtgIikH6tb4rBjlR/CMXDUBrn5LUEa1uLgxZ9EiHOsez?=
 =?us-ascii?Q?7nczEuWUA3Vz9mC1Lr0d7Y6aFtPnF7Vxi8ty4bFS8oQZCE4+LSK4QwnxYbIq?=
 =?us-ascii?Q?Z5h9nWEnnkEuDVKp8yliFmCXJUKUoMhspcsIMAY2kZsVSwYuak2b4qjAv41F?=
 =?us-ascii?Q?TYtTtsVT45fJIApkMio9/PtKWedgptkIcpIgLPP6l+41prBcTMSS7MRoIwxO?=
 =?us-ascii?Q?QKciDiV79275Dk9fELeZlNeZVHLqUbeLFZdK0DeNpkPWXmKdt21wFwxaiCEp?=
 =?us-ascii?Q?sg8DE+xU2PsRNy2fZgirZwQc2Jn9ykOyaEsZzbNAQF5J/gFynsc5YKE/2IbB?=
 =?us-ascii?Q?eatljrLXWTdElOSgTTqRSuSr487Hwi4cWOskC/gJlhaWpaPmC5GhbjgM8Eho?=
 =?us-ascii?Q?AHUP0PTAdeLi5BB6q+M3roOgR2UgHPPKF/1h+3It2oSHHzfax8pmv8znJJqM?=
 =?us-ascii?Q?le8pDXRudXzHdu2QhYcxvXtQVs7CUN5EVYV6sY9nLzXFA7nn97DQOpcDniBh?=
 =?us-ascii?Q?rgXP+TslkWlaP347SyjNGGnEz/cbCzu1ECzHszSg9z/4cZ6EFdu7xwqNyABd?=
 =?us-ascii?Q?ua364WWjK0e7O1PFyGWBRihG7XJ76xFYtOs07S7bbzP1m2EHkoT0jvGMtcp0?=
 =?us-ascii?Q?GpWarbJ0VnRJJ5jI9OtDk0ttEyL2fc7F+Ze1WcgcmyssiUXBw78+0x6y6cVe?=
 =?us-ascii?Q?KE0Pnzh8MUDIW7KgOOqmpUTjatslO7VO+FWRTebTQGka6EeDSNZilvp1iInu?=
 =?us-ascii?Q?dSCMhzqZUF40yupL2gAs5vDQ0EQvd+G6uf76tlGjfLQanp6wj768IhGH9W7b?=
 =?us-ascii?Q?+b+SJpokglp6SJ4cpXfl40BfK+uW/Jg1eOl27hV4D2ptU6aqB2va5ZCpdhXA?=
 =?us-ascii?Q?DstoomyMjxPPSpN94M3NoXHdfvucbx5jeb/Fs3qb3yBUiK1+cAJNR/pieovD?=
 =?us-ascii?Q?S0ksEwHtv/3ebMdCVg+gUlG0/zbLvwhRPlVzDHcwkO2qZSQ6qyuvGVUMtOeh?=
 =?us-ascii?Q?CoQcyapBVwYFmxNiUaYwv2nn7tjYPk9B4tBDA2f3VlzPyLiJVkVv3ewUuN7O?=
 =?us-ascii?Q?OwI37iTCCw=3D=3D?=
X-Exchange-RoutingPolicyChecked: a6yNJToO/1zL2GxOVoQAyrHFQicnxox+mdiSsoYvRWP4rcXzNGXZXt/URDIEF/UqHG7PkXn9xyv8UPkxxSzg0or55h0gzJaUrkwX+H2r990jfdipt1uJg7uw+mSzpNp5noDdR9kgWn4SMoPvMlCSsEmwy3ki5SInJxAAvhAUN4LQp5sGs4LXUt2D2QsDm8HiVlQkNV618nXBkahjiQ4k6zLC7fvxdRGxWwf6GSHvL2mQm9BLmGlgvwbkj1vDgnmTY8s0P0AEDghhC6IdcPkr3iLPpyxEGuv9ITpnTt/GkCA4w23thPp6ScLMo5+lSZ3OgLCeR3pjzmHK2My/toiFNg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 29259562-cfa1-4d42-0d77-08dec73ceff9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 22:09:27.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1baCSW6HLNet6enRKJZ0YnOcq/ZP0Eu0UGW8J+jP4SVn0ENQG/NzTvXIFdPz1fMHgtOCscXOZCcfTconBPae4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7732
X-OriginatorOrg: intel.com

On Wed, Jun 10, 2026 at 10:58:26AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/10/26 10:24 AM, Luck, Tony wrote:
> >> I see many "if (pmt_module)" checks ... intel_aet_pre_mount() even calls it twice. Are they all necessary?
> >> It creates the impression that the PMT module can be yanked from AET at any time, something which
> >> intel_aet_unregister_enumeration() seems to allow. I was hoping that there can be some guarantee
> >> that if PMT is available during pre_mount() it will continue to be available at least until
> >> unmount() completes.
> > 
> > pmt_module is NULL if CONFIG_INTEL_PMT_TELEMETRY=y ... i.e. built-in to the kernel.
> > 
> > In that case it obviously can't go away, and doesn't need module_get()/module_put().
> > There's no special case for this. try_module_get() takes a fault on NULL dereference.
> > 
> > When CONFIG_INTEL_PMT_TELEMETRY=m then the get/put should stop it going away
> > (I tried rmmod while resctrl mounted and it fails to remove as expected).
> 
> Have you tried "unbind" via sysfs?

I need to resolve the unbind issue. Looks like I may have to extend the
registration interface to pass a pointer to the device so I can call
get_device() to prevent such an unbind operation while the file system
is mounted in addition to try_get_module() to stop the module from being
unloaded.

Or talk David into marking the driver with "device_driver::suppress_bind_attrs"
so that unbind isn't available for the user.

But that's separate from the issue of whether all those "if (pmt_module)" tests are needed.

> Even so, my comment was in response to the code you shared. Let me paste it
> back and highlight what I meant with the "many pmt_module checks":
> 
> > /*
> >  * Track whether pmt_telemetry enumeration succeeded during mount for use
> >  * during unmount.
> >  */
> > static bool pmt_in_use;
> > 
> > bool intel_aet_pre_mount(void)
> > {
> > 	bool ret;
> > 
> > 	guard(mutex)(&aet_register_lock);
> > 	if (!get_feature || !put_feature)
> > 		return false;
> > 
> > 	if (pmt_module) {
> 
> Here is an "if (pmt_module)" check ... can it ever be false? If so
> then the rest of this function becomes very confusing (more below ...)

Yes. pmt_module is NULL when the kernel is built with CONFIG_INTEL_PMT_TELEMETRY=y

I.e. the value of THIS_MODULE in the pmt_telemetry code is NULL when it
isn't a module, but is built-in to the kernel.

> 
> > 		if (!try_module_get(pmt_module))
> > 			return false;
> > 	}
> > 
> > 	ret = aet_get_events();
> 
> aet_get_events() can thus seemingly be called when pmt_module is unset?
> 
> > 
> > 	if (!ret) {
> > 		if (pmt_module)
> 
> Can pmt_module be unset here?

If it was NULL earlier (because CONFIG_INTEL_PMT_TELEMETRY=y) then it
will be NULL forever. If it was non-NULL above, then it must still be
non-NULL here because changes are protected but the aet_register_lock
mutex.
> 

> > 			module_put(pmt_module);
> > 	} else {
> > 		pmt_in_use = true;
> 
> So pmt_in_use could be true if pmt_module is unset? Confusing, no?

I'm using "pmt", it just isn't a module. I'm using the built-in kernel
copy of the code.

Do you have a better suggestion for the name of "pmt_in_use" that makes
it more obvious that it doesn't refer to the loaded state of the module?

Or maybe change the "pmt_module" variable name? Suggestions welcome.

> > 	}
> > 
> > 	return ret;
> > }
> > 
> > void intel_aet_unmount(void)
> > {
> > 	struct event_group **peg;
> > 
> > 	guard(mutex)(&aet_register_lock);
> > 	if (!pmt_in_use)
> > 		return;
> > 
> > 	for_each_event_group(peg) {
> > 		if ((*peg)->pfg) {
> > 			struct event_group *e = *peg;
> > 
> > 			for (int j = 0; j < e->num_events; j++)
> > 				resctrl_disable_mon_event(e->evts[j].id);
> > 			put_feature((*peg)->pfg);
> > 			(*peg)->pfg = NULL;
> > 		}
> > 	}
> > 	if (pmt_module)
> 
> So this implies that pmt_module could be unset here ... if that is the
> case then that means that the PMT module disappeared while resctrl was
> mounted which is exactly what this work aims to prevent, no?

As above. If CONFIG_INTEL_PMT_TELEMETRY=y then pmt_module is always NULL.
The module didn't disappear, there never was a module. It was built-in
the whole time.

> 
> > 		module_put(pmt_module);
> > 	pmt_in_use = false;
> 
> ... if pmt_module was unset then how could pmt_in_use ever be true?

It can be set in the case where the kernel was built with CONFIG_INTEL_PMT_TELEMETRY=y
> 
> > }
> 
> Reinette

-Tony
