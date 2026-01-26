Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D12BFC70;
	Mon, 26 Jan 2026 20:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769458042; cv=fail; b=AhDcRKOxyJJc558tKs5EMvCcKC/vwEfx0hwY8OEj4sIHfDXfv6e5sElAkzN7AoqUHfQ5joWl6Zz/Hb7sRaSWVMtL4CGU7DAwfgKLf0jyGCnjRLkYbvmC1pHc2TkZNKkzs1Sfz/HFPMd6kigs/5kXWfMKgf3TcNhtsPSK91WUodg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769458042; c=relaxed/simple;
	bh=N38n/wZJYY7iqhTlREeH1PGy2jlPX471VYvtBZ/CALo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=guiVa2s8F2sXBj00xrjMz18awJ/bUeXphTmZjjjShKP0sUIy9EOu+WLUUmAlwnWg4VwG1EDuMZttNsjwEzsazcrsY2Co9kU5ZLDB4ZZhFSBFtD90GnRiy+/PM4fU+h+0Crch4IUjzG6QgwOeR8yPzkIDQptP9jSWXiAxx229CnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DU1qiQLO; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DU1qiQLO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769458041; x=1800994041;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N38n/wZJYY7iqhTlREeH1PGy2jlPX471VYvtBZ/CALo=;
  b=DU1qiQLOq3v3DLmsbiZB2NfDVtmB73pxiFKnUue8BPC1neQj3vBoPVXJ
   ZcGEnKQYKS1BS1ujko/66P7LvSCTnKJgqebJllq/S4WyD2Ld69LECH12b
   7e1kI87ejT1Sqwm8wvLRXIWACdBbrhydLbXxUmzNBeRl4S2jiSQUXhmmu
   QwQdB2BLF6uV9CnC8OZdIHBtvZ3o/DFY7GCuanU9+cAY+ZTqh2UFpWXe2
   uj0FtVD6abbhw4Z72k4gXxgzNdshSPKT+WnSVFp3U2oUeN/lEAne7DA/n
   0UirL39JOQZ7Xnfn5F8MmvcL4PI/tnMILGI1BPOTaftGAXOtkJ/AW6lMP
   g==;
X-CSE-ConnectionGUID: acHeS5amQSyjZbys+iaZwA==
X-CSE-MsgGUID: hqPuyZQwTC6M4SrC7vs0ZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="81753651"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="81753651"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 12:07:20 -0800
X-CSE-ConnectionGUID: saH0vDbERdCNuCF6YK5BtA==
X-CSE-MsgGUID: zh7+VyXJTquwS8UA7WVZSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="208210561"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 12:07:18 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 12:07:17 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 12:07:17 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 12:07:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CGmR3EFmeboe5XwTUKRl15WWXylVv7eCa7nFQfD5x8scY1fsE2lH3nq+isyJOgu1TGUjkes86U04jLJaZrA/WJDzAkd+1ExTysq5QS2n3iWYSFVNZlr5qxa5TEFjm+13S92nQfrpoEdrMvuuFWEgsanazeyJMDy7l1i9/oz2N1h5qIJCrOKJINXpIGODsTOX5JYkIE/C+pm5x0Yfm7mR++itbTORcFapIaZwVz28N/OVRWmNW5//xccAMu20rE2+HvlZc7MLl7kVX0Me8Yk/+zI2kmZyZiJbNNNW0lSm4DH33P07D6DSJ/z6l+8qorh2Vt00gRV0QxDe1Ef5FjVYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhZdjP03QhHBSpQdqNKsHAot384Zlqi80iQ9HyNipYs=;
 b=gWd3s48FCxx9Rl8kpuTmgYE9zNXITIwxugtfyE5vcvMJimCGSigNGOtowWreUY/NH48qB0H4f0oZAwzSpqtRYE6GTshBohcbN6gNnXaIQX1JDZcdZzfmcMquJpTNfCR/zJlS/TzOgq54dwGtphBlPueesqkgEOqx0UXEtcPdfuZHjnZE4OKGx73TUzjKdmuiA16dr2vmBC3HghxVMrfaEn9jvI1wyMxEeeO3sW9igu09i/84HqiApndNZqyzJ4+/3hJgDnAaD81dhl9+HAXNgYZvxM4U0lt5aB5QHTDvct4LjIKNoeZfq67svA4eFueRF3ULVxCYZR9MpZg3tigtrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8)
 by SJ0PR11MB5814.namprd11.prod.outlook.com (2603:10b6:a03:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Mon, 26 Jan
 2026 20:07:15 +0000
Received: from CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::1171:db4d:d6ad:3277]) by CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::1171:db4d:d6ad:3277%3]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 20:07:15 +0000
Date: Mon, 26 Jan 2026 21:07:10 +0100
From: Francois Dugast <francois.dugast@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Matthew Brost
	<matthew.brost@intel.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian
	<kevin.tian@intel.com>, <patches@lists.linux.dev>
Subject: Re: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Message-ID: <aXfJbl4ZyusgmT4o@fdugast-desk>
References: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Organization: Intel Corporation
X-ClientProxiedBy: DU7P251CA0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:551::27) To CY8PR11MB7828.namprd11.prod.outlook.com
 (2603:10b6:930:78::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7828:EE_|SJ0PR11MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 22a8de3b-c9b7-473e-546f-08de5d167fe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BqsbcaJYvn/JQ1TmX5SNu/yTKbCN3e2/wiVnxVc00TqT1D95zdC21j7lxRCv?=
 =?us-ascii?Q?MDkVdwW4M+rFPQD2h6W7IqmGHwLSE3US9ynKt6DPQBP8uP7M2+rAq8HNtgzU?=
 =?us-ascii?Q?gpoyAgC2eZBIbywMPEg4atMlsWKTATISqzXM+5z1Vj09aPsYx7Ea4oygCasJ?=
 =?us-ascii?Q?k9rxfOXNVeEjOSFERwOvu2JDh98eTKUKumYaWmVJBCOHTjLIYtUCmg0fGRx/?=
 =?us-ascii?Q?Ayr/HB1KHlMe+XXCHFsortRccH9aZH4C0Cc2t8H1MXoDq9jAaWHEjBzqH1rr?=
 =?us-ascii?Q?I2k7Fh+dFDtO+J/QZS7+2DkcuGtnmruBJlyjVjRMSMz+RzXkENfObidp3sKa?=
 =?us-ascii?Q?pJqTT9BMDAVSYue72klDuEFcAJZgE6rLN7/jQ2OUOdoj3tg6lhEfv1D9jdN5?=
 =?us-ascii?Q?AVQVNZT5sXVHZQkEqaIRhrylFmNulFomnRMeYuAksMcpLMgI8uGPjK7PQGoR?=
 =?us-ascii?Q?OmyUWemZ38fWD3j/u5HgjFnUC+XFgKpeaY6JzjG8uiTYpXhrFCgCBH10bwyI?=
 =?us-ascii?Q?wj6lXtVVKMzcf/sU00BdTO3i1FemYBbaaZfIoFkm72LM6OXSD444OIhbrxqT?=
 =?us-ascii?Q?wOBbij+0hglGhfsAYOYb3JdAEc8nuR3dbzDWmiH85kyx8NeUloux7yzt1Pec?=
 =?us-ascii?Q?9qQbvuCBjrbrmJIrT90uNowI7tXCpPih4z9Eqh358Qzs51iXRqYvAAXfUXBo?=
 =?us-ascii?Q?cw0Pha8apgrX93AiIAvLV6l6UP/oX+PA+dTvPQlV05V2v+PT7CrM28Am7f4k?=
 =?us-ascii?Q?JwqZStYr9AzXcRP9ezmkJiBpTmte4swdHhko2CyaBoE07CD9F/wlvczZFFKD?=
 =?us-ascii?Q?NCj4J4k4DBQMi4Jqpz7I7VIGE/EVo1Q2PvvbMQANHGHZWjLc7G0aQhQnhqGL?=
 =?us-ascii?Q?H5c2EMPOgKhLu+D0YH4bGtM5YVrdN+isPf/3Zjcpo3vtCrHmU0TPRyIcdVLi?=
 =?us-ascii?Q?QWt4FqzqatIIpAzv6TtfipBzI/MX/YIckXePWvuXznBnqw2RSjfN3oeBxXoc?=
 =?us-ascii?Q?ScUJK1AA56/RLHciXjtb0wLAk8aPSA3G4Pfy5L8i+yfMwsMTprvIiBql9sig?=
 =?us-ascii?Q?CRkjoVAXziTyuMnD73PPmT1/yCKdD+ALN1N39BDmsQgKbB+vA24i9lcnCBtL?=
 =?us-ascii?Q?q3KBkbGYm0JmtNFmIdjLN9SvpjlC7+wx5uPL70GAX0aEBXRN2/xTFN2aunqM?=
 =?us-ascii?Q?iFl1AyTMyDV+8hJjdWm9iXEJwNOSmCP8yM+xjd5yWh5iYh/c2u2FGQvLBYWc?=
 =?us-ascii?Q?PGEC8yRXAMJ6/bbQGA2uB1yJG76Gq9ZlKjag0J9evUehSF7luaWdXRdShN1F?=
 =?us-ascii?Q?0Yjmgg1/ovaFE7Ykl67yPNIwSOVNmMUBmOAkMmer4GDMwvzLXt5fabn1S5n7?=
 =?us-ascii?Q?8ajP83ecX6FGMKy8GcTBefuizE9k01uz4KZPkr/AYS4gy6W6qJsZldvZmN6g?=
 =?us-ascii?Q?1Kd5xeX+VPsRwRglDH+F9fo5BC+LeWawjsTCa1g4cdA/l7DB+koZqD3QR4Pp?=
 =?us-ascii?Q?xRCgdJH0KXBkoiiyTljqtFDBuWQPXZjgRI4Ji4i4HDsy37oTSXZpZjtOgDhF?=
 =?us-ascii?Q?ZgH2nyd9tGDPNGHu7BU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7828.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/hLRchoPzMinWC3Kfygr4b3MpmY8jOqocCpdYoBX9nXvzL0hRYsidz7/pAWV?=
 =?us-ascii?Q?cPvK2dgsUOadfQ4nmNCVaMQ5ArpMOj4Oo8D1Gq1WeAv/Swvs/D5GXm/0aFqe?=
 =?us-ascii?Q?ArB7Iq4BZjGYZPurMfh2OEIi7bt44MDmeoA76Z4xRY6e1twFJcOx9+9Y7niD?=
 =?us-ascii?Q?8jspaPXJImk9UYML/FNqLzcpsXRgM9rFG+2cZuUGt7VQZjlb7Y0YWTBPjlyV?=
 =?us-ascii?Q?NBg93o1u8mPcnw5jZ7YiVBd8EH0IRPKJV5ZrK+icgiUHmXf3TJ5ZT07/EcMN?=
 =?us-ascii?Q?7RlfLAHPvpGvpjVQSwAqC4jUzHuoZa5bdD4Hd6Ct27323xEIpFBRlxbTtplT?=
 =?us-ascii?Q?FmGMZupria5O+fYRDE+yomM4A6n17zgsaNCISR3fBHYkpooP9fS5q/apmoa+?=
 =?us-ascii?Q?9WxVMKq7b1I6oWMT1+zkCH40fUWO/yo9A9yRdBRVkjMMxIWln/2UKua+I/ZI?=
 =?us-ascii?Q?d7PqxTQ4VD1wEynxrof3TfJoM2PUftJY2NYJnNJAOdAHwNnodSN6072Uw9VR?=
 =?us-ascii?Q?epKfCpPwARGkc71moqXCE0phN+gQ0vpt7M+8qRl4Pz+lbb5bZcJ0lVYHd+MV?=
 =?us-ascii?Q?lx6JCqj68qAsYHwLNA4jyxWjNvqMRVU0e97ZgEOUIV0qy6w3efgo+xK8gONU?=
 =?us-ascii?Q?iOjyABv74XBU6vLsaiGYljiaVLaWmd9Vwl9LLaAd3a/PyfhCw10zRQORgpjH?=
 =?us-ascii?Q?uvsQge7Qwf8Wj8+bcGiwlM3bVYNSrEoVp8GV6l8qbzdRCZ3jZJaHnE+FDhgU?=
 =?us-ascii?Q?0hMQwRi34BlamgeXhl76pst5TBbPo2XBGBkywGSIVe+M+fJqVxjWzUKhgQ/v?=
 =?us-ascii?Q?KY7Zf5eAQjH1NAbzdapQW8TzrPOAuvxAOoskVS++BrdyIZOsLHarQQDQ/5Cz?=
 =?us-ascii?Q?YrtIOG0XS+HDJMcnM/EO/6XpR8wZAsg6wOiq0Jgn4pmS9Zl+ILqj6i7SG36s?=
 =?us-ascii?Q?IFHKnHwgfK33eDlNdSXRvpy7v4YD/0M7WHjzePiVu28R1q4r8yfBcLeEL7ic?=
 =?us-ascii?Q?AXAq6I+Iv6uTCsdHWbNb48z2aAxoiy530esrwXwVt59Z0mO+FCEZnvSA+U7J?=
 =?us-ascii?Q?UZ0GOHBBt9r9xCZiIwfuBuBbqKYTn25wjJunULKn28xW4LemIxbJDU8ZXdc9?=
 =?us-ascii?Q?1rhxO6LOmbfH0Zxxz7lAjDlkTsY3RpJSwX0Q1bouK3Ec8Snvp0Wto284qsXC?=
 =?us-ascii?Q?xgTMWTLxIFoQMUlKcTVMV+FWjq77oqrKsT3wKbwflFCZy8aADAAbq2BU0KC1?=
 =?us-ascii?Q?W6qLBKDCdABePRRprsHq2VDe13/rqibUZUfXiO0ejITA662hzWNk60QZ0KYJ?=
 =?us-ascii?Q?KJgRSo/wS9fJFKmXbHeHHplwWkIObCdQv/Q918DgRhfrRhXsxe/axBIcEP0o?=
 =?us-ascii?Q?PYvdyLDunntPZXwRfscwETvSIwFxDn9XTQV3rjHZf070xAYlM9iUUSzvtprT?=
 =?us-ascii?Q?IgJja5z26l4R2gG1N7WRgmrRTWD3SmcWN55pHt6kCX/nkxatCvyngPFkkajn?=
 =?us-ascii?Q?6zZoPi7R+f2vfgdIK6ln7jRoFD1KrVWDYOu7JPZBDIoVsX450QUa+0YcUZ/X?=
 =?us-ascii?Q?sSqyOWw0le+93K6iOv4X01zxoQeQyTXcDrC54CKHkQFAQJEhtn5MVguww+R/?=
 =?us-ascii?Q?6Ap0PlNsLuJRetLoWkxFvkMd3xE8SfPC1l/Qg+hrCyQMOrg2XlMy8dP3wjHB?=
 =?us-ascii?Q?4SR2kkoK5nGGiO6y/roI6SUMqftE2HPmf68u7ktpbejbbC+ZAVYM7YGKx4cJ?=
 =?us-ascii?Q?H1n2e4Mi3CrmIPbZY6sgphLOrsK6xnQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a8de3b-c9b7-473e-546f-08de5d167fe0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7828.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 20:07:15.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cpn4XUiigblG3IUFgHZ10UL+b1XuV9jruauOz6D5sefpwjiWEAd5xCrYT2angHwlGivZ3EsTMDU05MdhwtzBtT9sY3C7M9Z2JVwga6Jemv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com

On Sat, Jan 24, 2026 at 05:00:21PM -0400, Jason Gunthorpe wrote:
> The cache flush was happening on every level across the whole range of
> iteration, even if no leafs or tables were cleared. Instead flush only the
> sub range that was actually written.
> 
> Overflushing isn't a correctness problem but it does impact the
> performance of unmap.
> 
> After this series the performance compared to the original VT-d
> implementation with cache flushing turned on is:
> 
> map_pages
>    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>      2^12,    253,266   ,     213,227     ,   6.06
>      2^21,    246,244   ,     221,219     ,   0.00
>      2^30,    231,240   ,     209,217     ,   3.03
>  256*2^12,   2604,2668  ,    2415,2540    ,   4.04
>  256*2^21,   2495,2824  ,    2390,2734    ,  12.12
>  256*2^30,   2542,2845  ,    2380,2718    ,  12.12
> 
> unmap_pages
>    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>      2^12,    259,292   ,     222,251     ,  11.11
>      2^21,    255,259   ,     227,236     ,   3.03
>      2^30,    238,254   ,     217,230     ,   5.05
>  256*2^12,   2751,2620  ,    2417,2437    ,   0.00
>  256*2^21,   2461,2526  ,    2377,2423    ,   1.01
>  256*2^30,   2498,2543  ,    2370,2404    ,   1.01
> 
> Fixes: efa03dab7ce4 ("iommupt: Flush the CPU cache after any writes to the page table")
> Reported-by: Francois Dugast <francois.dugast@intel.com>
> Closes: https://lore.kernel.org/all/20260121130233.257428-1-francois.dugast@intel.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

This reverts the performance drop I reported, thanks.

Tested-by: Francois Dugast <francois.dugast@intel.com>

Francois
