Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587B7272803
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767977597; cv=fail; b=eIF/MNmrRpZ/UaMThkYYPiMjG5ClZATlZqvW00ciIz1vtnhJufzBO/8iv7jSNM/a8NwrtVSDhVWPuNxT9SvRM+tYWgB31HkuCp5jP5ePCu+u4xAhhLaSUWNVsYysCihM0eCf0jLu40bAsY14zpZWUuXLUx02ng+LtXIKUJaLc00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767977597; c=relaxed/simple;
	bh=0IVYc+9bgZQr8BS2QexJY4P/JmACZm3Zv/CK8g3UXFI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EvUJimf44gczCxKNtlWm/dxiSC0lbsgGIJOX1Bi9iYiDs1oLUpV+iOBEFrsnPKefPsW86QMxGhCrCKF1P+wATFoGxSSdBZXjBkSDkTfjqAslkSoyF7ejUMZcy0rlb3cJ5RXbqCf8aeniSXqfo8K1BEtM9/VryptHSehPda+3Dik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S5TmI1bb; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S5TmI1bb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767977595; x=1799513595;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0IVYc+9bgZQr8BS2QexJY4P/JmACZm3Zv/CK8g3UXFI=;
  b=S5TmI1bbmhrSonyp+81rqHRO5mAqNj1Qkedf/hPCTq1IO3sPhWorDlX9
   37PuQPbyVUoDxOrGJlIjpgEKybZKKhiqc1X8aDaEUAm4cv+BPQEvqd7B1
   YZ96GWQEnjZZmdfufr6VxVdVRddY7JKtOPSlydpyksSf+dySZcXrlOzMo
   sXsXYXItuXT79jRmhQI9BzcSMppm0W30RarWbype6gSfuTcQK/5q+UCVN
   LjgxiESesecse4pA5bQGL+ykXGNLabdWlnyGAxIzlaLZdwUkhOf6cLKee
   OJBinNK406oxJqSPt7nvPdBbOjiCRWkRay6fjbKmcELIE+LdpySUJiHa3
   Q==;
X-CSE-ConnectionGUID: MkvNW1v1RzKZUlqD2TIq/A==
X-CSE-MsgGUID: bVN73NrLSDmYn1dydXp9Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="71935177"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="71935177"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 08:53:14 -0800
X-CSE-ConnectionGUID: g14GKEmpTMWPCwR61VgoJw==
X-CSE-MsgGUID: KVdfBze1Q42QShEBClZOmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="234207430"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 08:53:15 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 08:53:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 08:53:14 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 08:53:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCohLiJFYgr1CP4Kj+f6hQIu6OlLVUnnu47rmcaAoGBYOgC3zrTjuy/F+5iPrwdALFaDahiEx/xDJ4Fwknry119QkIBC6IrjFkdDiP7AeRYJl69QoYJMQrTH5lIEuDaSqpKnEqW4gIBHfHlo+M0uaWvob3L1tTEVDfwGqx1uxIOUN8DVMI84tre/QtqVp/qVZNWdoHlj8tA1FSpS7IiqFelv6JAu0qMqpdqWvpv+w0iU0neOuxTaxfVsJ1mz/ELipjPeYNPWCB+UOHZ06VWa0o3TrR35I8dpxpm/QV/WQMwPxG7VjnZnIY9qZPRniCjh1G29ll9zDWyOYn6wxB+GTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqmv2VhdXFevVghkr76aVaDXptztCAfhi7sUQ0c80as=;
 b=EKFedIKVAOfFhWSWJ7/iVjQCtE1F1lTgecrT0F82m2ItxnzDqHj7SOm9p43Lv8mfH50450KNTDWaIq2YXRoT/XDh3BwSdX2SVs3pYr+pAXlYKkfkpxvAdHsaq8aGaOpslKu83bToClbs39nkh90KdFFpqlUL97QiinzxTXJbtAQ52BlBv31g8uGaedOmrGbeTQ0P59h89OFHf7IHmzGiGEQUBtmFfKbVoa7AZIAots7/T34iYw9oTc9UXGYkErr4iMEt86/a5vdLIuvJOOy4Lhc/2tVWjIUNnULHUpbtXeDAuxuvNbjxNDO49IxfIFhPu3ygGrNL6D1032MTWaA1yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB8418.namprd11.prod.outlook.com (2603:10b6:208:487::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:53:11 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 16:53:11 +0000
Date: Fri, 9 Jan 2026 08:53:09 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Ilpo =?iso-8859-1?Q?J=E4rvinen?=
	<ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH v17 19/32] x86/resctrl: Find and enable usable telemetry
 events
Message-ID: <aWEydesWamRxWJwM@agluck-desk3>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-20-tony.luck@intel.com>
 <20260109121616.GBaWDxkGvgJ6sd133q@fat_crate.local>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109121616.GBaWDxkGvgJ6sd133q@fat_crate.local>
X-ClientProxiedBy: SJ0PR13CA0043.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA0PR11MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: ce47ee12-89da-4cf1-7c05-08de4f9f9292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/bcRyvmm6nYwGomdxoM7rTdcqQV5B3OL7dNbdGhyQeprkA/hg6972k4BQIHy?=
 =?us-ascii?Q?yAW753B2MjFHEOQERWtIQbAdVNYe66EcjMpa2Qf7dEo1vYQnxndbKBw7PbZd?=
 =?us-ascii?Q?5jgnZJUl1LD7rWthXYMZsyQma2zX9r4TE9UW6KjHEdZVldcyIpKe6m9FG6Nr?=
 =?us-ascii?Q?052CZeNn7QgqOV8vtjU1mPlVlNZr/mXhVO/0QekCTBgy4KZL/Q/o4xgN3Zx1?=
 =?us-ascii?Q?j+9tfvq19OSiRRVcbQv2n+4ApZe8e7A54Z+KyPh8RtNvOIY3ESwC0efc9L1E?=
 =?us-ascii?Q?BV3DJVrNCFqri6g+dhuhoSuZpwQkE6azCmjgy592JUTSJ7J2nNvlz/40s+Ci?=
 =?us-ascii?Q?ntkPMWYc4rqJM+H+Ewtka0IIidwi2krU4eTRug+7uxrOM9PeRI9Z9zVZA1rV?=
 =?us-ascii?Q?yf8xcPHKEdAHrP5dc+1b817T00AJkKAFseQG7CnyU9UbM6V+DY2tPMvDuy46?=
 =?us-ascii?Q?xQoWXoI7qYARv5iF7fMFEL7bRy4VwbS0tNJJAQDnAERCA0k2Tj/j67B5j6xo?=
 =?us-ascii?Q?OETS/CYf6XsOtpSiST+d6/La7iJUIeH60SkqIZ3DBQaXUBWusf252iJ8jXqR?=
 =?us-ascii?Q?tk//N2DZbDncB6lSRuzmYHf51u1nHox6Ecr5AyyF6Y5UpYBZlLanQgn8NhIK?=
 =?us-ascii?Q?/7WjEjFEcVAEq23YSXseJLMKNSMSy9hIkz/IXLnGm4eNzJeeel8J4HrpFYHA?=
 =?us-ascii?Q?wsNSIIC5adu7RHOEYybmSLWmf7bWRxfSRnsZrd/njCaBBNyHCftqa+Rx0aeN?=
 =?us-ascii?Q?zhpc9MeGyluqRV6hmYmelxygQid0CTypQPy99WH/7QE8UNMuUHfnZBZqhd8W?=
 =?us-ascii?Q?QsgtW5mFojvXLHnmH0nBulFN8PIN38F2R6OkcZT7ORCbuPIz6IWUX3YRq/Sb?=
 =?us-ascii?Q?nS4kHfItNn1yqwCllyK8Tzm+oqI4+hbO0uISzrwOJnc4MUkeLTtkkKLKbjcc?=
 =?us-ascii?Q?mWmnXif0RSVcFOvsDMrWF3LHduwLynYj2JJ4TAQOCNw35mYZNL7GsE90iFCP?=
 =?us-ascii?Q?RoLTT/IYWp+78kouTbTWzRcy6Y0NRJ9r3xUd5IvA0cNJDJgtrRPFBIeVq0+K?=
 =?us-ascii?Q?e8PsBWT0eDqEZQghEmz/X9kLb8OHlJua4+1danrtPlLldvdx7+2KH4eaeqng?=
 =?us-ascii?Q?1Qnf9oHvRdxZcvuTOO8S3Wjv4aVI5YLkH6E5fTp7Q8WM0LLJ7IP4Zs1A7mIi?=
 =?us-ascii?Q?lv3T1T/+DT8esD49ebSmp+BYrDZdppNsrzMziBAbSO9vATG9OLxT55aTdKpP?=
 =?us-ascii?Q?oEwLPahCcOxpgk3OlvZKOqmaiNVTN8dSSdsuGTNF/4Uresm0GlYqcme4gzpa?=
 =?us-ascii?Q?7JkEmBwWtSzeK7yQAA/Iqzwyiophm2ILKlvrHh//HZBKIbsvgM7FdxXXMP5r?=
 =?us-ascii?Q?ryJ83M7NPYzB3CsfYrqXqjMjPCd/lRbHJt2YNI52ii6Mpc5hDm+xu+8HYZaX?=
 =?us-ascii?Q?tGlB0aovUtqsFIiHtR/NXgJXrbNY2R9ZRcjst52S8FGeJRXe/SNwTA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zklKlUqNfA0i0Bt+RMuxSSO9Q072Ox64Ktpyl8ftNmSN3i3Yglv90NmC1J8p?=
 =?us-ascii?Q?YAfnXH/iUnQKsb3D1/g64z7kOQ2tPmrGMPx8yJPygBbVso6IGn7Be1i7q0IP?=
 =?us-ascii?Q?I/F4V5YDadox9jpkhRTthuPHxdIvoINNhcTl8Z+b2Vx6olWViavJB+uTkeIk?=
 =?us-ascii?Q?Nja2I0yxwp9hVLVI/t1JCu0jdXkjjJP4Fs5fmQrxIlUsJoZPjq6d1/0gvOcd?=
 =?us-ascii?Q?en5dJUNZcTtynlo+4raa0E5eBjXYVAkKgz+9v6BiFw78piokHrqRV+IIKsIx?=
 =?us-ascii?Q?9XhwsQxCGNZm1KgyN0dq9zMqwvSr6uciO4WtrRiopdTWHhDM5hAGOo9XT97J?=
 =?us-ascii?Q?BbEwsE4op/M9JMZbzVMpeOpaQr+klunLc9itgR9UTQWpb6d4d58T9Y+5eAZl?=
 =?us-ascii?Q?AGEOqT5nwtuseaO6S8g3RGCPTpSgtJYz2RzngUW4wlnv3heYVOIPuxp3p4cf?=
 =?us-ascii?Q?QYHmVBokGCD3ppA1wfQBUplZkBm6vsJs8OBo0uOPju0pX7sMWUhR6+qOWVL5?=
 =?us-ascii?Q?+tLbIi4yfQ512BzZ/a1k7zN+psaR0tdIPYzo02tN1N2gCGsQG8u+irqiVYAA?=
 =?us-ascii?Q?kcSTxdCmsG/YEmZ6UhMfmVDKxyO/qH43e6SBQO/k8/T2alWdAvz3amFiyWxl?=
 =?us-ascii?Q?RDOfRkis4PSZDQFCNTG2EoAef3MOEZfUl7Ca7gKuVxHOs4p/nh6VDzr4Uiuc?=
 =?us-ascii?Q?x7yONKhjH13rQbBVhjyzYCZoJO+jXwu7p73XPkkmyj1TnwzAC9Ix0Z93C4nr?=
 =?us-ascii?Q?kwQbrz7u26fFhP2wiQKrm9KpK28DbUKbwhAhW2Ev7UgZy+4g+39FXUNYO5NI?=
 =?us-ascii?Q?oA2vproyWb9bd00bWoBpumfNOCuzQNnGAQMW4k39Xa6yhEdZaBAxFmDoD0pd?=
 =?us-ascii?Q?P+sLYepUDzHNqzgHBKulplu1EWDSMO3qSXow53fECDoJcooXuuxovYQjfpWZ?=
 =?us-ascii?Q?XGm8HodtWJ9ekDH55UxdSryrYukxKuUgOU5b1WmCIkh+J1hebTS8wmjGU22E?=
 =?us-ascii?Q?OzlfGqhp+TJ0B3TuK2RSfOcTeTY/vkZtOwGAEJW/kYN7blV3epryBphqQSmx?=
 =?us-ascii?Q?zZTkMuXInAwOkt94cz3zxsamk/7RWL/7sbaq1VV8ameYbsTplJQvVqYaawMz?=
 =?us-ascii?Q?XztRpKdTCTVpovLZi96svgQXoxFu0zE195Zj4yqkmF3tdxYo8cqiVmBZsxW1?=
 =?us-ascii?Q?uB2YB4HBpbC9RZxXpOJ7KMTLA0tEmMU6Nv5s3q+MbewbfODGDD5gELou4Ueu?=
 =?us-ascii?Q?uohcc2za9SkhRmxLrVW/+BHfyK2VI9kBlZtfuTLpb1mhoNz2F5JibhYAOZUX?=
 =?us-ascii?Q?QYgZfIWaCZBMrLktPojfFdDXmh1DF+tTN2SQKkGNaES2KwGTRaDi2DUVn2Cp?=
 =?us-ascii?Q?Qx8AXZn1gFc8cQKwW23/v5AipNu0xJck2AxaIT8fgeO+61rBKdEqny1va7+E?=
 =?us-ascii?Q?7mU2sY7U3FLtAnj7tFYSlLxNbgdV9PY0o4Lx2UvOEDhrYnGY5Agr9T4LPl18?=
 =?us-ascii?Q?AKLBr15pLlTDg+b5elxIvk7VyeQlIpLhQ46dtf0NJmVw6lDeV1gj8YS9fJKI?=
 =?us-ascii?Q?TRkXLqCZ2YBMJYDldXqjjszJ7HPgFrYtPVfD770TWx3QznzGwhXndXepsGFV?=
 =?us-ascii?Q?AZGhDoyhNmTtgmccHmeHaWSHXqxhCMA19uHA4kUSJAdCZz+UOTh/VqO7vYJ5?=
 =?us-ascii?Q?t0+3/s91nGKzU00p/Tz6KF73cXwiSjLR5vHPBLeBEMqXb2PFchzBj/RrZ+CE?=
 =?us-ascii?Q?PCJ2bbgPAg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce47ee12-89da-4cf1-7c05-08de4f9f9292
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:53:11.2322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7C8N77BiVAgy0P6yIOVk6OqRfVTXBqmn7iMT8pIVZEhmscipFdNTjAyOfesxff+UXLOEFck36YL+43+4Z8mvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8418
X-OriginatorOrg: intel.com

On Fri, Jan 09, 2026 at 01:16:16PM +0100, Borislav Petkov wrote:
> On Wed, Dec 17, 2025 at 09:21:06AM -0800, Tony Luck wrote:
> > -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> > +/*
> > + * Clear the address field of regions that did not pass the checks in
> > + * skip_telem_region() so they will not be used by intel_aet_read_event().
> > + * This is safe to do because intel_pmt_get_regions_by_feature() allocates
> > + * a new pmt_feature_group structure to return to each caller and only makes
> > + * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
> > + * returns the structure.
> > + */
> > +static void mark_telem_region_unusable(struct telemetry_region *tr)
> >  {
> > +	tr->addr = NULL;
> > +}
> 
> We probably don't really need such a silly helper which is used only once and,
> AFAICT, doesn't grow any other functionality by the end of the patchset:

This was made a separate function in response to a comment against the
v9 series from Ilpo:

	As this is at least semi-hacky, I suggest you move it into own function 
	and add a bit longer comment to the function (along the lines what the 
	changelog also states why it works).

Link: https://lore.kernel.org/all/3b0546d4-d0bc-f76e-e1c2-eef2b4abf0f1@linux.intel.com/

But at that point the "p->regions[i].addr = NULL;" was part of a much
larger function. Since then refactoring into various helpers means that
it now looks OK to move it inline. The comment about why it is safe to
update a structure that was provided by Intel-PMT driver is the
important bit, and I see that you preserved that.

So LGTM

-Tony
