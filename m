Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432A13629A6
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756923868; cv=fail; b=OEG91PTw5bNlQdmMHSlxqDvcOkogUmF8bVy+qjTB4noDlBJOLihMVvezKqDs2Ln/VuZ0GHmw0Sw7psMkv60ayXTNqtJw3JKgrLX57Dm+w2RaQZPB+3u8Z+uPvzSJ1DJWNQA5DAZbBKkofl5DBAP3kmLyosTGjHpLAT2WunyHXr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756923868; c=relaxed/simple;
	bh=KMb85OH+4W8qgGm0fhGR2HVDpv53A7AfTZZ+sLKmmvY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RkUfLM+wu4BhehcoZDKIg2nt3l0dPSdHNjPlTaPKhbv573kbhL15HfqBGECXgtUjm1hOmY3VRWRCI1Fb9X6SPT2oJUGjR4TTIXn+p03GpaUpiRrdmFg8MFus8LzNrm3aCmqhTJW/WsJtNJXRyQXB3rq8YfkC2RFNZ8z1huvnueg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V0MCFu4z; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V0MCFu4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756923866; x=1788459866;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=KMb85OH+4W8qgGm0fhGR2HVDpv53A7AfTZZ+sLKmmvY=;
  b=V0MCFu4zb2EEggDzqCMNg1LDAPYXc5m10Q+oJj8bN3A3kP2qfUG+InXU
   X8Qk/APIBGcIPv+2KpGhQ2hRZrWJa3zBaROgrLgBXkRfyykNZDedgtk7G
   IwBaDVf4Fgcu9tcxZH5JQPKc1jvFl/neDO3emQvuMa3sVFvzmInmJnFN1
   1pZkeXdm8BEAErm4t3YEgco1yp30nCQUIwZTMf8PBY0Z92QqUBVaBv6jm
   tGI+QTBoUJPB/2Bui6wbEU5o2HrO21Vk7V46S1IE/KeXXbqMCsWCF2aeJ
   2U4+fMfwXVgjvGO49U4zIu3VQYWYRdn1cIDBj2GkF2r25FQD+swNH/lMR
   A==;
X-CSE-ConnectionGUID: j/3MnNF6SaWYnJu+L8e3xg==
X-CSE-MsgGUID: KCSk7Ln4RG6CpFrV0slDbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="58465615"
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="58465615"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:24:25 -0700
X-CSE-ConnectionGUID: k3lOGZQCSrWT1zYnpPky7A==
X-CSE-MsgGUID: 2CBc8OTnSF6jvpw3yXk/9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="176895309"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:24:25 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:24:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 11:24:24 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:24:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Es29FZku5cUoWmkda5cpULkmJuV0TsuoB/PoDaRIorqpLva3PMMBNFYUgCnxPwS6VyUDQd7cFdel6bWhQzEjhTz8AnWpsw2JvlXwyW2u2ynFpceQDliCuaMwoJxRumLdXzHso3hknZbdyfbNv1jY6cMHk6DnNxpUxt8rbdsekfXBlY6yqSSm3PXOn2niJ0JU+WtvwykrSx6+0nG6YOai62bEi9DUXTH8JTLGZUIxAfJ+WqWUoRqlWd1NpBWoCUKmM8A8iU/pmJLsqKTNPH2ZwLljKgqfDsdiWDozDXjDNBEGaFiXnVvUwEkNFoEm+yLWDap5QuvZC7EZCOiTIcBJVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcIyK71ykWU04A59OdC0SjGWr9h5lIhJ+HHyKrlbTAU=;
 b=vmK6U4if0DTcD6u5c8PW7ID7MMgk4yo8khRxo88E7L2mGQWsjlTXCUcwsUkaNGCZx/JeOqb7eeNpUzo7KFwIkuFUa/AFVCHRc3nPFMBxMC4ucKSClbnmmVHYuo2RCIRltOVFGwJbyMQFjeaSPpkUgDqRPDli1G2t/aPWL+H3XYcBEMwzWI4KEUCYaoVAct38O3/sa7xzCRyXPmpufqhfksQcu+vYIw2R9AzLKilqX0EzRnJLL4NIqURC3TCluyaMOzAuGManhKlC3DsP+7hefTczz9eyxb+NMdJnwY5zj2+RxoqmJK6FbVO4LC9NdDTeNCmnAlXckTM30QQVr++BUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB7131.namprd11.prod.outlook.com (2603:10b6:806:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 18:24:21 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 18:24:19 +0000
Date: Wed, 3 Sep 2025 11:24:17 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 21/31] x86/resctrl: Read telemetry events
Message-ID: <aLiH0QxFCP9EpmWn@agluck-desk3>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-22-tony.luck@intel.com>
 <3b0546d4-d0bc-f76e-e1c2-eef2b4abf0f1@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b0546d4-d0bc-f76e-e1c2-eef2b4abf0f1@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::26) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA1PR11MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c22f771-3a7e-40e0-42af-08ddeb1718de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?rvpMVPV8yc6umqv3Mri+P5Eqgyx58KTgai33Yd/saHGaTTxcEsACD0EfeO?=
 =?iso-8859-1?Q?GZL07q6wOvvPQ7/IvStJl87NoJxoZwHFJTf7no86n07KW5JbUkGvmuCmwd?=
 =?iso-8859-1?Q?YjEUR86cRgfEvphCxpxl6BrAjtZtiuCJrkDe0b0CAeSN8gvVaraP9SHbLu?=
 =?iso-8859-1?Q?0ijFWGFQ2h1iVshQC6TtSVHaJ94uGYgVb+EFNTZ0rrbv/fDVTukKQz8WSS?=
 =?iso-8859-1?Q?F3a2U36x5VMQK13s/zG16SR5GNyeqPefmFq7pm5bZH0oFEKZeTxqgTIA9A?=
 =?iso-8859-1?Q?Ov4AntF2hy0wRWajijp9op/+i2Z/80ER7Xg0XgcIiFYLbHvlLGI82sB8mX?=
 =?iso-8859-1?Q?ZkA+nJ10yqWcD4Zerag3Xh2vuW7+2cxu+wfEWyoqg9P1A0r61bIh5mUVVZ?=
 =?iso-8859-1?Q?44zerNlTs3VojwCCClwRcsUDqnrC7988K9xaLHX9XhMJobrsfttnq3NkQt?=
 =?iso-8859-1?Q?ZQV3t8ioRmgmy2n3D7rBvK+xRrJYnzyG8wQVQ6jyZAxjz3f5W1gx3GDG7c?=
 =?iso-8859-1?Q?pfXWZR8PlbUp+OEuoK8dH6sLtgjZD75rGlehf7D2rCKq+D7GLgcYMmneLb?=
 =?iso-8859-1?Q?ji/ldHu3i99DKMJpblwvwQcMOe6Cx5ek89ddpTV4DD0wV1JiYsbMumuvAv?=
 =?iso-8859-1?Q?oxMlNPcGImeUHKfU31YRNCS3J6m6cZSgOAIx9H9xXuYAUk8+vQ6lQRx02V?=
 =?iso-8859-1?Q?RiUt5WjnocCwgm4+GJDiFyb4InFXJvyGtyeW1Ga7S9disDTjgpvMMKP4Qg?=
 =?iso-8859-1?Q?eFUQXP8e4Rxbu6HT5cGF1e7tlIhUmvJnL91RHHroDRYAF7sa3chO1hQDN9?=
 =?iso-8859-1?Q?edcUW/MDDWmZLVIySq9xEFMq+AT/d6nryQLG9w4wNQeisuuWdZntOXaWOC?=
 =?iso-8859-1?Q?QHrshtnmelH2eCOyEqW3UjY7WvPQrAtsprb/tLqkf9kljcoHLJrzEOF9Cz?=
 =?iso-8859-1?Q?0rEPJAuL/92WDwqC0+S42KEr/JUl0x2akD2SZQl1y9gZ0t6l0wzMDCwf1K?=
 =?iso-8859-1?Q?SAUfoU0WWcvlBkdRZGPi+wn3EaKIb3qDacm9IaKO2qgkN0YY/mbhoWR7iU?=
 =?iso-8859-1?Q?d7qpifUNZPdtmiApOF+vhmLtPl9rgqWqhxrncLdH7IdQiMZhwBCEC3uNRN?=
 =?iso-8859-1?Q?3gW07cV5ZhlCBIi6wq/toyNvhNmD5FkT16rnWxn0oXyaMRorA/4Nq017JD?=
 =?iso-8859-1?Q?rcGXt/3SBTias570kVLFxKZStgXzVMF+3YB9GeWiunVNz6t7vpoNlpovQT?=
 =?iso-8859-1?Q?UFIF+U4UBFBZXNlGSk9nJfZnOFhMFLEEEbTmXNBBx3HT/kPDK1y65dEHDH?=
 =?iso-8859-1?Q?tUZjNnhxmjmtqbkRRstLlLl/zW6yjf0ri2kMpKckbfP3tov8LGcXeYa4Re?=
 =?iso-8859-1?Q?dzEDMVhmrn4Ba9GqFU8YrFYvLYtJqJXJkX9U0aJFozMWTIG2Rb74Q8z8dN?=
 =?iso-8859-1?Q?G3jH73Ws0Bxzb1XTPIvQAtk3+BcjNoxP/TgRA9KgLoYAUYrMnB7bhW+8va?=
 =?iso-8859-1?Q?Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?O0d2Jch6s1SXp+7HtZsmMvFEq6vsR6t4Jg/ZMzs62Q9AGDJsEep4v/0ZI/?=
 =?iso-8859-1?Q?EQWNUhx3pylr5XykTqdijG3QsUYmQuYbH/mQYFNo4WREb0d2mDf4w0Gkhy?=
 =?iso-8859-1?Q?06cLFoj0OJwmlWYMz7bc3FPr0aumVjsfD3DYDxgasgTUrK8Iq/qOZBvgd1?=
 =?iso-8859-1?Q?SHTYio0wBuzKuXcKh0tLpLiMDUAtKfYVr8V2fDAiZ6aP0mmJ3CRQ69MBaH?=
 =?iso-8859-1?Q?GLu8RoEYn+Z0IFlBo28v95F+f7OivrkfVLPy3D7HfvLUI+WrR5Pl0/r6UM?=
 =?iso-8859-1?Q?HmkD9Ood3xRL2wYdufY3Rzgki+mV5nfsob1AT6jJGwkHHE80yPfMzGAbQa?=
 =?iso-8859-1?Q?nfNxxKYsP4/iI14qiL+jWKpffYav4gLrnBVhPx2zBNC3OvPVkwBv4XX6h5?=
 =?iso-8859-1?Q?pveDnk6pqTZQ2h9/+N9d/uPnVdN24JWsO1BeLKqoPeEdaHVn2XfD4e4Gi3?=
 =?iso-8859-1?Q?dQWuaUDbzGhlM4FVSSAJkXHwtW+D3OHgiAezZiWXLCmZNIuqH4TirEirBA?=
 =?iso-8859-1?Q?pCOS4uIBd6lBynqbxz7bnL7krEhizfriZYO/mluFqDYVFpxmSaSyv5D/Cs?=
 =?iso-8859-1?Q?wwqjSxAsB1ZOKx1xVojJsG/ZTlacqI9MLThYuxlyHqWJ0pWP8Jl86VTc0j?=
 =?iso-8859-1?Q?2PsWBcltvsgmLWdFX2oko0PmTb1ecMUPW20vlMz5yEjSlH+jt+u5DWg10D?=
 =?iso-8859-1?Q?y+nahmlcyELbqWeNBj7a8H8Y+iQNFHxgenT29YbO0wC8oZb7LLsfmnWkXP?=
 =?iso-8859-1?Q?Qgqoic9zxsn6L7nz2EKfsqdRHTaQo+l75TF9LAlivZ8EHRIM9DY4tIK1KY?=
 =?iso-8859-1?Q?VyIXrV/po8mWl0RWqpk205y5ChFyZvpSwi75cJ3RCKatrSBCay90ccVy03?=
 =?iso-8859-1?Q?Li5jXfDBzMXkWNi8n94D87dj2tqg/qXwqADJ67sBxla2SOaCRK2Ygp6sg5?=
 =?iso-8859-1?Q?ZUrbQ1md/yZjmXOSs3ItarkH4THMQYq+i8iqGxno30rNvHNgHwZTW8+M46?=
 =?iso-8859-1?Q?WM00mx3POhXTfijWHgmAUk+yW1ZwTmMqDZbbc9fbtcIRWM/9dKdsIP2W5n?=
 =?iso-8859-1?Q?aJD3O0QLy68yfOr2/9b8vc/gocMgA986RO7IXXRM8k2IEOq/4jypQT5O0i?=
 =?iso-8859-1?Q?1aZvqS0Lz8AsIVKLZKcrvsrScv/Uo7SuASlYUn/vxyeJYUDUaGkfS5Tjto?=
 =?iso-8859-1?Q?wi+AG4iZLP2WKRdpE1w+HmL818dkxTY0SFdqENf61TpHmrOr5JhHQdtwuh?=
 =?iso-8859-1?Q?/iwFljZ5SzCcHuy2/agkF2opFZ7qQl7/9EpvTsqvi3Q7AP5ba5faxwJZ0b?=
 =?iso-8859-1?Q?eWWaMOAaQW9piyUs60lwm7LxDB8qb1EQz5CCxOqEcVNqrXBV52whQ2Z5jp?=
 =?iso-8859-1?Q?cGrIN+U4WVViuRlBj4h7w6T5IQQ3JdbORhYsZQU4mgs93ArXaJ3rpOrsZt?=
 =?iso-8859-1?Q?5M2K8brpm+6AMf+p/EPBuhdcIe/AXLFh9l1Ybk5uebBVPTlYoY7rRPWkAd?=
 =?iso-8859-1?Q?A2MgKvgdGfGSEXrQvxnpQYtPX3wlr4Zkextxmjcm5aZFn000gJxayuxHdr?=
 =?iso-8859-1?Q?Cf24tljtQauMssQndHN7yN2tHCDKkdxCl1YhmN1VLMP/0jTu102am5b0FT?=
 =?iso-8859-1?Q?I/LjJ5fYsFN+5eofhJ1WbkLQ03/YpVW2yt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c22f771-3a7e-40e0-42af-08ddeb1718de
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 18:24:19.3225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgC9L1KXM5TarA7k6kpLpRi5QWaRo3cJwW9oc33jVul4SGn1DnN9Sfqe/mKSUhv/o4HI8VBSoIzTE4Okx4nlYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7131
X-OriginatorOrg: intel.com

On Mon, Sep 01, 2025 at 12:15:49PM +0300, Ilpo Järvinen wrote:
> > @@ -125,8 +126,14 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> >  	bool usable_events = false;
> >  
> >  	for (int i = 0; i < p->count; i++) {
> > -		if (skip_this_region(&p->regions[i], e))
> > +		if (skip_this_region(&p->regions[i], e)) {
> > +			/*
> > +			 * Clear addr so that intel_aet_read_event() will
> > +			 * skip this region.
> > +			 */
> > +			p->regions[i].addr = NULL;
> 
> As this is at least semi-hacky, I suggest you move it into own function 
> and add a bit longer comment to the function (along the lines what the 
> changelog also states why it works).

Agreed. See new mark_telem_region_unusable() in updated patch below.
Also pushed to
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip

-Tony

P.S. In addition to all the extra #include files you suggested, I found
a few others missing. So those are added as needed in the series.

From 163824a2e10de9f63e20f0bc9f86b8c14f58bfcb Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 25 Aug 2025 10:47:06 -0700
Subject: [PATCH 21/31] x86/resctrl: Read telemetry events

Telemetry events are enumerated by the INTEL_PMT_TELEMETRY subsystem.
resctrl enables events with resctrl_enable_mon_event() passing a pointer
to the pmt_event structure for the event within the struct event_group.
The file system stores it in mon_evt::arch_priv.

Mark regions that did not pass the checks in skip_telemetry_region()
so they will not be used by intel_aet_read_event().

Add a check to resctrl_arch_rmid_read() for resource id
RDT_RESOURCE_PERF_PKG and directly call intel_aet_read_event()
passing the enum resctrl_event_id for the event and the arch_priv
pointer that was supplied when the event was enabled.

There may be multiple aggregators tracking each package, so scan all of
them and add up all counters. Aggregators may return an invalid data
indication if they have received no records for a given RMID. Return
success to the user if one or more aggregators provide valid data.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  7 +++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 65 ++++++++++++++++++++++++-
 arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
 arch/x86/Kconfig                        |  2 +-
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 9ddfbbe5c3cf..8986071dd72a 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -172,9 +172,16 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+			 void *arch_priv, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+				       void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index e36b3790733b..170158d40e27 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,13 +12,17 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/array_size.h>
+#include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/compiler_types.h>
+#include <linux/container_of.h>
 #include <linux/cpu.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/overflow.h>
 #include <linux/printk.h>
 #include <linux/resctrl.h>
@@ -131,13 +135,28 @@ static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e
 	return false;
 }
 
+/*
+ * Clear the address field of regions that did not pass the checks in
+ * skip_telem_region() so they will not be used by intel_aet_read_event().
+ * This is safe to do because intel_pmt_get_regions_by_feature() allocates
+ * a new pmt_feature_group structure to return to each caller and only makes
+ * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
+ * returns the structure.
+ */
+static void mark_telem_region_unusable(struct telemetry_region *tr)
+{
+	tr->addr = NULL;
+}
+
 static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
 	bool usable_events = false;
 
 	for (int i = 0; i < p->count; i++) {
-		if (skip_telem_region(&p->regions[i], e))
+		if (skip_telem_region(&p->regions[i], e)) {
+			mark_telem_region_unusable(&p->regions[i]);
 			continue;
+		}
 		usable_events = true;
 	}
 
@@ -215,3 +234,47 @@ void __exit intel_aet_exit(void)
 		(*peg)->pfg = NULL;
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain). If an aggregator hasn't received any data for a
+ * specific RMID, the MMIO read indicates that data is not valid.
+ * Return success if at least one aggregator has valid data.
+ */
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
+			 void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct event_group *e;
+	bool valid = false;
+	u64 evtcount;
+	void *pevt0;
+	int idx;
+
+	pevt0 = pevt - pevt->idx;
+	e = container_of(pevt0, struct event_group, evts);
+	idx = rmid * e->num_events;
+	idx += pevt->idx;
+
+	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
+		pr_warn_once("MMIO index %d out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < e->pfg->count; i++) {
+		if (!e->pfg->regions[i].addr)
+			continue;
+		if (e->pfg->regions[i].plat_info.package_id != domid)
+			continue;
+		evtcount = readq(e->pfg->regions[i].addr + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			continue;
+		*val += evtcount & DATA_BITS;
+		valid = true;
+	}
+
+	return valid ? 0 : -EINVAL;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 249569327e4a..0333dd85450b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -232,6 +232,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
+
 	if (r->rid != RDT_RESOURCE_L3)
 		return -EINVAL;
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50051fdf4659..a42f749f31cb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -527,7 +527,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.51.0

