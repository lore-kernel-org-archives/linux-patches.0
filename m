Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792424687;
	b=22H0VHw96U70dgnJsBBQpTwnqV8PjaBr7Fw/KlW0JsgKXekwkRMbapibi+c/hJs/q+iY
	 ZK4+FyxkjZs8lpnfpmPsBu1IaXpuvqDsOXKTf6003Org2pCbx2UC31vTWicNfnEI3VULR
	 1InCVE/eBBTpB9Biihr5+gBRAhtggCioTVNaGveEAtUSC5yEmPnEkIAXy+Ru7lm27Z9TB
	 kPfCKaC5fRaSK2J1DOgBsxjcpLx9/MWLQ1PG+Epfu6YJJFa1mUFDaTvVqJlMpffF6TKDM
	 LoavheLeMdR5y0J9Xz1BH/38cxDkkCaLSDkXPnxftifOd+X97kg63nWMRAwcSVY/zkg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792424687;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=q2CiIbIuNDLAoWn0z+YKkMKSuFdJBae2IsA0LHInsLM=;
	b=LlSi6Blx91MRiEiboPk3Wrcz3bTnCk9cMmx1X9Td8V1W6uRRzZ8ujsahiDNgJbuzaCJK
	 WJ7rB2u8VdwgMN+AkAChaJKsdoCaQiPtDLjKRUxD81aqI1ewA4rrlxRmd1/tQhfboeUYl
	 i0SFoHWSQqSET3vR2i4cuihhkgyBu7lS9oS1D2lGjeZqeluzsmteIiKn1PiKs1iLVfMt6
	 PtfPBCcyXrh6ykr0ZnQEgeVIhsBYjRZqh/3fmgpa6x/E0najkoNH/WteEbslndXBtGegB
	 B0JWM5/JXONUnkA/GtMPpjgBqo8iCcTHm/FYbx3I3WlXzEIZdZPX9Vu6bk6n6JuInTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Y9ktFYkT;
	arc=fail smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451FE606A334
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 15:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 451FE606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Y9ktFYkT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792424687; x=1823960687;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OL3tyue0on8O7Dsptm1EfNjhrF5Bml3qT73stGcW5jo=;
  b=Y9ktFYkTZyUKqYI4DapOkN2u6zo8f/23jnoN16D6ONZsXWBHsWoTryO/
   C6UgOGldOO1b85K3C7UJaeJBf3WFWHwxU3+Bob7v+TsFVDlKitdcZq0xM
   E5s6ZNoLZ5k9AFbiFZdaFql7UTzflNzfEmJMYoxlrSkz5qSOzKwheI7Qr
   09MgijjT8bLQv7G9qQkp68pTIOtIyz0iCJOro1dfI07DM8JiPYKLFjY7G
   m7SDzCHlBJGUOH9Xafk9ypQhg1Qudd0WF7z96J/zzuyoYdeDiE4ruMAvD
   MZ/JBjgMTLI3WcktZ0aMZry8Gl5+usVci94pn6+UjsytFmVtGBM2WduzU
   Q==;
X-CSE-ConnectionGUID: 2DSdms4XT/iDYB5hrIH+sw==
X-CSE-MsgGUID: 2MyAoyIbRpyiJdpn2PdibA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1011032"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1011032"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:44:47 -0700
X-CSE-ConnectionGUID: 8y9Fze2/TZGyXS/n0Gp+PQ==
X-CSE-MsgGUID: 2wD1vhNaRJacYhcYXTY2ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2620518"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:44:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 08:44:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 08:44:45 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.15) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 08:44:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGQReFZm19CSM07/x16fdHZAlh5Qz4gmIg+maLLpUvoQCQPSX9apH23iUbs9FEIKrOdevJ26UanX0Rks5bwT0S+c87SQuqXMvJK0kvo6OHgNtqZ4Z2tGPcIT5Cq03+ARJPUdp6lNuv1ls4PgW9HVx1zQ2ZeFLCzwDFBMHYFtkb8cxu7b3eyG7BrZ9kQTio7cHnu4ZLNlDCVP7kg3svYwSu6QgT3RqBjtxo6OQdoyBOUo8apkq6UFThd889sl8twD33hwpJRQxWYp//gknMh3B438xt7d95WTgxPsWVBCFdXfZ9Ix3aXcZAREgnn+CA/sCEOdENemAxYhx0YKNobNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2CiIbIuNDLAoWn0z+YKkMKSuFdJBae2IsA0LHInsLM=;
 b=GyUG/NZbTdJeSoNhq5lZExR7dwUG0sm6cFZvb1+e74t5HWDG38C0IKbU/S1P1Eq5S9gFRUpzttmLXbQyFlle8Osmq8KYWWxT8tQCGdagkdEHMul8FUDVnkwOgHdF9sM/mUBUUrYJhVH1nKyp/+ZUOBPTEeQDbqJh5ze2X9c8maE/MpVZU6hbx/fp2n56XtPB0mzwbMYoignddjaKu0IMbfR2wagqEXucnHddLdDLHGHTD5zWGrnDJybERDvm2XoU26Cla8yIkApAArAf7A8f0Tb294msJYBZRBrJZbRHN4yHka/SX1nBnyp85m8uu/CdzhohCkFhVwHNLv/JDOsxPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA1PR11MB8786.namprd11.prod.outlook.com (2603:10b6:208:59b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.17; Mon, 19 Oct
 2026 15:44:40 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0496.021; Mon, 19 Oct 2026
 15:44:39 +0000
Date: Mon, 19 Oct 2026 23:31:40 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 10/25] fs/resctrl: Remove redundant calls to
 resctrl_mon_capable()
Message-ID: <atY33C3JoNI_sQ_P@chenyu-dev>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-11-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260928221509.68002-11-tony.luck@intel.com>
X-ClientProxiedBy: SG2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096::11) To
 DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA1PR11MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c73b89-05d1-43ec-0c56-08df2df7e2bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|6133799003|10067099003|22082099003|18002099003|4143699003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: nj9chSt7puDGNI66sxoHjShZOahbTp+dhPbQyf5UZZMUrZ97Zg+cGwWoiprXZuo64Y64sM1kQjI63QfjK+s27hrQEnAUbbbYGEOlFpiR5JkkmjmV0xXFbqhPmWdOc5nyuA7aa6I4c6hqaYgQbKtO/JkCVN6y2fzWp1zeO9nonxTv46mWfXLY3Zi3JB3Ozs9YhsL4Ae2PYiYNUfjSVELHndNPuJ0QeJ6SeDcmMu2UBaUG5NGhbf+Z54BZjm090ZWuFzEkdjHHvc92bsmQmhYqv7st6u48S1zaZYTAki44H9yHbNtAQd+zzxmFyygklU5a3mFJ/owIB2P1X+lkAA4tvYDXvaiYRTZ0uXEGU28kAcubM45WydytvfSahfbt2M+vxknuGzdwNUi0wmpZJ7Hh+VO+UcxFj8XsJMdaXj0ArZhE4SR2AF7uCsFHvmOUIQnWSNmmqbGp7F3f7BT5yquoAGq0/61Cp1Yu/iJFam945et88WUJ/upGo4BpNTnTrYhcmGoo58z2xVHnAIdfB+cupNKsPeT9DZsqb4WK8mx3wgLKMScVRtAIusrjbc7Yb/evqtX+amCaqAswUrgubrRN//6oopQRsdROENLm6IUDuRjALXl2wM4CBN1dDX286sVlH+SAEVIulufu4WE1Xm8pzarkUC1nU1DB4ZVbJtDIxbM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(4143699003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yiAIq3iv92TLaORkkJE8j8A9ds2S9lCyTWucm6wC1yfBDUsfrdk6ZpON7vkS?=
 =?us-ascii?Q?PUJwVPc2uWeRLI/QxhSpYZ/SJUdMyJDbxY0OQmm7Jw6lJLfLMuHA4uysZARa?=
 =?us-ascii?Q?hbQS4ZlVP2bhg291ZSEnYu/ImGBQRYrPxEjog2EGPNSdThTjVcyZDSANY3aT?=
 =?us-ascii?Q?gGJrpfOMYWtIROOq9Wm5HumNYTsg2ZyzD42EsDTwOdXyzziGoDnqWAU0ctGc?=
 =?us-ascii?Q?kHJNl5rNVBy87/noLlYrlyCb4nBDzyu+PFrfVPXTmQajD0jdonRZWF28X46S?=
 =?us-ascii?Q?sqoTnsodXqPytbqUSBzyvZruUZ5Nk8NQNh/peINCdGH0kKeTf2OBJNnwC894?=
 =?us-ascii?Q?AXu36b13sEbv9saNjaCaiE9xlfgtWFwZVwrUHDjE9ZvpYQ3tuPNHRfil2AWQ?=
 =?us-ascii?Q?hH3993EuOfgH7ZZvS3bmdpnlElSrdXjXMNKHmKQOS9VrY0m1/AeefecBfJBV?=
 =?us-ascii?Q?c2kpZ3/xg2mU6jceozUJME+KmwsfO7BT0knKZ4K0O7xVMe/v5qjsrvs6Y7za?=
 =?us-ascii?Q?WBiXT70p5FFY0lAKKr5q5clODc8vJEERwXOwXYSHlx5a/q4GR+zyRDC+mfoe?=
 =?us-ascii?Q?g6mFW6Rg+vlAEXvxcYRjzzTwizELSytCYcs1y/My+YbYchcYPitRH8YMR33r?=
 =?us-ascii?Q?k+WiavsdTRhrEtgQnSJa7BEA/aA6tu/4K07Q1KOPOxCYCqutDd/vk5OYYJDf?=
 =?us-ascii?Q?CUf6Eo5ujg9yqH0woojaYaDGlylGX+i4oF16G/egvOzh5+Bm2Qb9em7nBXN1?=
 =?us-ascii?Q?Hr8nKi77QeQ48KHBLwXL2d+1DOQAOuC1XLEBwo1fHQX092RmsUxSu6/YafUB?=
 =?us-ascii?Q?WKNs/bZ9xkzwazZJ9Pxlk0vH/9sJo0GSCmr/nijUSvgv3WDcteBKo96Isan7?=
 =?us-ascii?Q?HYIFws3mkp6RU6CYl+Lgp2yuUjrGrv+HqItF64Xt14O0z1ZWpQ/79roYAlJz?=
 =?us-ascii?Q?SYCka8yh5jlzR9v9HPWr9PHr6aZzefXg0AHdpbtibkxsE4HJ+4PAEL6uHwDS?=
 =?us-ascii?Q?DRH8g0APSe39C4Y9nkhM+MbH03ku1plGeb9uD5veXfRGW4yim4CBd5JTnbRt?=
 =?us-ascii?Q?JiRrsmdESu6I+YX209ubNbtiuF5Z/E106LoOPOAi+GPpvV1O/trRGLVcOxoZ?=
 =?us-ascii?Q?NfCzU6kYasQhBcUayh3Vdp2F/gIfYuylJo3lfysNaqpLnHXiZZVTwBY9Flqg?=
 =?us-ascii?Q?3NJ0OzaVVygd56lUDdunNvYgyAFiFrprVGsjO+OzbtMJS8fjsF6xUBmCMviM?=
 =?us-ascii?Q?wy9xULkMswkcWWghSha5kFeAVYjaZG4yw50Kj0pnjeTH1BckC2VQcgBIQnMN?=
 =?us-ascii?Q?2MnekHfoVu2YkkUZm8PwY/1KxJTGEmIXdi7i+WdMC1mzUAQ+gx0/xilRTJlT?=
 =?us-ascii?Q?qSfhsaEg0EEUQgMr1tzZG+fY1cSulhG8jmyeBBEfZsHprMsGAfhO6uL7Y41S?=
 =?us-ascii?Q?2YdAw4/hI4Tp6MXojdygEfuZQjAlKYgiEOtRcIn2aHH1iaEeqLdE7+nDsqTW?=
 =?us-ascii?Q?JHN0/NHMQfrUj7RD/XwJq59lTbZi1eBbUkCArYaYSMxdAgdzqb8rUM+99O+w?=
 =?us-ascii?Q?p+EOW6yiVRDGAHEAez2sndjTzzjuorWXJAOOULli3p2UveOas4uJ2hwQ9117?=
 =?us-ascii?Q?PTulx0ppOAGcJMV/YjrvdvK5K1X4n7MNdNaScJZsiJXWj2vdbVn9t5LL6F6Z?=
 =?us-ascii?Q?k01KgHQtNrP26OuKiSuc17bToDc8cXEW/tzjuS70xBW47FVGa/kq5UMnUMgG?=
 =?us-ascii?Q?6dp743VnsQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: TdEXQrw92RADJJ2giDqO56zGozrGYK5lUw0FcwgblvREpfhspMMKqlPshct05tpOgQooVyUoHAjhzfnU69gEtDevUdBQux/ADtjoHktRNcsvsVRLzDdEsdLBHXlqiIUuSQ5jiMjiU7qbLX2XrhYZmKkCadVruq5Ztd7NeYNK4vFes4qmgWlxKIinuvPtFYbPSBdaQ5+AzsxVlBSM7QYUv8aRYZC6TjDL9qANH6QPLK+v9KMDelrgirQ4MA9J86dJY7VC+9R+lXjo+5WPlafWbMOf3zOABKvZGu1rbN6F59A5byE0fVz16Bmle46BzEETxIpgKav1DhJ3u9rQ2HAnzQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c73b89-05d1-43ec-0c56-08df2df7e2bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 15:44:39.8588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LH7F8hYnyfpMFcx69vnos/GPJ30iBsZqbhVaqeSufmThN5N3VbgcwS2WKbFJT+n9ietX9sKcC1xSIXxfLETjRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8786
X-OriginatorOrg: intel.com

Hi Tony,

On Mon, Sep 28, 2026 at 03:14:54PM -0700, Tony Luck wrote:
> resctrl_mon_capable() indicates whether any monitoring resources
> are enabled on the system. It does this by scanning all resources.
> 
> Redundant calls to resctrl_mon_capable() in hot code paths should
> be eliminated. There are two prime examples:
> 
> 1) mbm_handle_overflow()
> This function is called once per second from worker threads running on
> each L3 domain. resctrl_mon_capable() is clearly redundant because worker
> threads are only created if the MBM monitoring feature is enabled.
> 
> 2) is_rmid_match()
> This is called for every task on the system so making it less expensive is
> appealing.  

Nit: since patch 7 turns resctrl_mon_capable() into a resource scan and this
patch then drops it, would it be worth moving this patch before patch 7 so
there's no intermediate window between these two commits where these callers
pay the extra cost?

thanks,
Chenyu

> resctrl_mon_capable() is redundant because the function also
> checks "r->type == RDTMON_GROUP" and this type of group can only be created
> on systems that support monitoring.
> 
> Remove the call to resctrl_mon_capable() from each of these functions.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
