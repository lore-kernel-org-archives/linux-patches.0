Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F732FE079
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 19:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763667326; cv=fail; b=HxRPE5ByGySmW5CZJIoD9BtMOlF49EldKLSNwrnlwaIttZoSm156/AKEpGg6joFoCjMxFDaVT497itVKw3+z6QxCXBpdnu/vJW+LWv1FDIgEXg5LeK27bpCT4XiOjXomz81RMlORNe8WzlmFpDKxsWmS2YaGKSilWnaWAkBAk+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763667326; c=relaxed/simple;
	bh=kkgH4P7NoT5+z6Ps2qWXTwX0u26gVqTJx2LGZYsvaks=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kt3qyo2jqY/PYmF6krcpZpwChGCVodncfKQC1j2n3R5Q8o+MPKH3eiVgRUNxyuhChpbm7AANvK2F9+MoCdfYQSLrEofbl4QOMSX2I6C8qCCOaVJsBRm9NV4aNt8gX81/c+XgBCACnWk6FfCbJTFn2iMlPmVkIQT4nz2HgGQp70I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1iCsGUw; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1iCsGUw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763667324; x=1795203324;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kkgH4P7NoT5+z6Ps2qWXTwX0u26gVqTJx2LGZYsvaks=;
  b=P1iCsGUw0dApsWAw8OQm03iIgz1V01ix3Ho2Sv2XM+tirrkaf3UqY954
   LwWFQS6OB/J3cGUmifDzN/WrY2+4bwtjahAB651bGa07n3W1P7JXG10Eq
   9w8FNj6tUeSj9+eUrQGh4xKXOb5GYaurN6G2M7Jn5RP4y4X1J6tEkp3Ev
   0+mjlPADdQJmjgmkX0aUUzCu1lVLaNuo+l8qMzRqum8aDxhXwajLSgML8
   04HmwHjCr53Z5RTd7scUNbbEuOey8MXYNu5jQLvKU89oh65ILieenS/6r
   hg4L8y50GUddvx6fT6e6PXEfv+EIqqHyRofdqmR+x9/ALZq708uZIGuCr
   g==;
X-CSE-ConnectionGUID: WpfziGyGQh2IHDY/a5v4iA==
X-CSE-MsgGUID: Jy/14NFqSyarfZlxK9B3ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65643778"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="65643778"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 11:35:23 -0800
X-CSE-ConnectionGUID: OsjliD1pRUaGeMzBOAWp4g==
X-CSE-MsgGUID: MnwroUTET3uZ5vKJiZLpuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="195758704"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 11:35:23 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 11:35:22 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 11:35:22 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.10) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 11:35:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BEgFbic4JKoPsnPHCMuctsz88hUDZ8dIBFww6U5oJi6HrKefp+PNtInNGOZCKKoKJEJmyn0HInFM7TjzElD+bO2EhZc1MGIBTX6/i8HDMnxKFLJ/sGKRdPgnwV6yRusKexrm6q3LYlAd3o3yNByoT1H42bxBV11yeBOXVStna8W7DduWq8zKPoN4G1FaOHd31EhQFzenZvIt+U7vZRuP/Z0mxat0SVqWF+h9GEeT0rujYI5VveD3F52xzR00PYJWV7AmS9EpX18j6vI2GP9tSzc8AvQzlHJsMMPks2AGDXOnRYn9kwuYfs+9SKpB785ZP+NrGXNXxwpZ9/F/Hy8lyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6nkw30ZhKTNfFt2vgXFgz/8ZQ/H9KGUMlObScO7TEY=;
 b=mWISF+5DL3X10gJtUdaaVlcY2RmhM/4AByEvRkTwpy+2ZH3UlHPkxeA7+mwex0wzx14D4Sx13h+K6sjVBJ4YhYHRrf27cYdDgQWNiCcXb6/jHF8oQRXFqJPDIoT1+ckQWPUzW9DVLriNcgoEes99QbTwD6z9XB+RR0D8hR9aFonHXHMYhkHq+P40g6qxBxDbbZOwASwz8KNvs6hAsKv3cxkyidOJc0LHWDOFlnaGN76QPXFB3K8srlYwERkoaC307+61hgdDGlak2YrAahLodK08spwuo8J/WYaKHHXJ4+D4Is1ZsYjmC+eY80BCNtWwqad5J76q0NvnqyOseiIboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB7814.namprd11.prod.outlook.com (2603:10b6:208:408::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 19:35:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 19:35:12 +0000
Date: Thu, 20 Nov 2025 11:35:08 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] fs/resctrl: Consider sparse masks when initializing new
 group's allocation
Message-ID: <aR9tbOMEVSDGvtoA@agluck-desk3>
References: <abbbb008bc09d982d715e79d3b885c10f92c64e0.1763426240.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <abbbb008bc09d982d715e79d3b885c10f92c64e0.1763426240.git.reinette.chatre@intel.com>
X-ClientProxiedBy: BY3PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA0PR11MB7814:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c642ee4-866c-4340-8f9e-08de286beb50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0myZgK2GCWAykWEGQOo22MbF4IPXQU5IrzrU+Za2Tbip1cRRKdigxNgZTLTN?=
 =?us-ascii?Q?t0+RDKczXtNUvwlOEXeIdR56UOTO4zzThf9F6hUQEg1IWX5fcnAxFQ+AZ/Cz?=
 =?us-ascii?Q?8vzSh/nXbEJ+oOe4OUGatPmaJjCjHvfQ1H2OH+mQwrvECFkh1Ntv/19MWIFt?=
 =?us-ascii?Q?EAedW04Uo383dT7jDd4Z69bR97eNdYA2FlgEDgJhvuJlYMAeQfXlr1sqeZpn?=
 =?us-ascii?Q?RgLjGExfUpbI/Q1S1BHr7Yfoly0k+Me/kpP0ECBrqQpmwkExXOZOQEyvM00x?=
 =?us-ascii?Q?jCQBvHZ1I+esmqqEdO3T5h3Jh579DlFFkqbCNsDV34+nDnirIR1YWVJPrwT2?=
 =?us-ascii?Q?FAx5Ka5KW2J+FG4829DAfwgyyP+fQ1Wn3vxXG5gD+6kTt90lEUbHoSZAplow?=
 =?us-ascii?Q?ybm3QlAkBUgVyyWnyKedFED/sySLXHO30X4z42ZgjDgVaFBt4KzzvQviALrm?=
 =?us-ascii?Q?fQlQ8HvIOEefbhhMTzOKrgsmgP6sBnCU0mRbIE72ffVUFhcykY47TR5H02cD?=
 =?us-ascii?Q?Uxb0Ue0Ic3tRNRmgLVGIiqVsD83mUj/G3nOEHaxg4R2P/aoZrHRoHDaY4LxH?=
 =?us-ascii?Q?mKU2/Ms1yAIbdOCXG2dAzhObsPXrQl/Tjk+L0gplO8eCRLNp8ueimypCEroh?=
 =?us-ascii?Q?hO06DbTLat6j/MgKortoijGgtAx0mO5JT7cHEsKm7QTsI+cd/ZXiSjKDz4Ea?=
 =?us-ascii?Q?yc3PiT9Zn9+/QBVbpH/vXF40/pxsRK+H2Jg3FPiR7y204pnNDmO0mTmnlcJH?=
 =?us-ascii?Q?9sTJyPGdZ0/0PhSwJHcZVoQUkUlDH5jTM05IGCYIJq0Apyg1UoT/SjehLDlz?=
 =?us-ascii?Q?hHXjtuC9RvKmy5xM0mDt6iHgmclMwLYqdOxZssWEpdLnXlOW/HekRoETaoeX?=
 =?us-ascii?Q?dOCu4yM8EJ/aJ9nL4NB/Anw5TjDxG/Q98RYYJfAFLYzhDmLYv8ii7CibuJHB?=
 =?us-ascii?Q?tbeh161mHSZT4I0uHpNxstRfyRyM0377LlwW/h9M9p2pW7oElTXIhGLKS1ZZ?=
 =?us-ascii?Q?A7lfPfMaOj7D9Y2XsHfx+GiCZhq7X+EVOR9ZuJamrDlUlPfXYsaSrnpunmsb?=
 =?us-ascii?Q?bg/KObUYfJFTVVKDo/fPjt8gHHqYGS3IBpV63NMdYQHr5N8pdrxeLnVTkrXo?=
 =?us-ascii?Q?4KkNpVAWS06ealmtA36xAjY/UXdc0hdA86PYTDGUUwexPpGLnwuhd3jVBwk+?=
 =?us-ascii?Q?CPHAcHJxpBjImEmfrxwWu5eNcZD/Mlrgy9J2+DPzUGP79vF5jrk2bdBm1Z7n?=
 =?us-ascii?Q?pojArSChw7wxAEz2lsdQsANi+a9WBXGKy72Cem12DPdSOsghBlt8AZX6xOcR?=
 =?us-ascii?Q?+YaNJGoQ1jl1Lq7mTJp9pE9hlR9VLIOzNLFQYllqmi7qFXTbPOUzARe8FoyU?=
 =?us-ascii?Q?tBOJMiJlZRQkpUKIJ+yjlGjNCBRU8JxkH9YasXJdO8SpIRS0f3AeDMk65jpB?=
 =?us-ascii?Q?6u/mpZMmrpm6izzBP1nbX7S/gcrzF90eK12qea/I4aSM/O4fDLotDA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?abj+XcTAfooJytail3WnsNYjAOu00P38+ZURqZ0IqVvc/CrV+Ft3gJ78vIp0?=
 =?us-ascii?Q?z6SmKbrt2HfHo82GrkbWB0SKIlbaHVrYgr/bptltYOGTw442vlxdT29jIf8u?=
 =?us-ascii?Q?SgSJJHCghCw7m855I3v7Nvf+N/0pP0681+MXepKD4JX2TWeznyI+NCPt1dEa?=
 =?us-ascii?Q?6cuCmp1zxL2RobmPzA92E0lqDDGB1SGX9NwjQysM74h61IYGUmqiUKiwP9XC?=
 =?us-ascii?Q?jFjcr1UDqd45Ozk5OpbddzKYpkb4z2Q0O2tiI6bOvzOrn0rHsBsNr4Vdkhi8?=
 =?us-ascii?Q?qcRHoCApdiHC42CgNYtMHBTyEKnMYCIhaJN73a+ebV8+Tu1ph5Z4piD9r9n4?=
 =?us-ascii?Q?H+2j/MefYgWHGTSlAX0xPM0yo8tIzWD2VtWXWptbepjxZmdEuKOpUy0LNAXp?=
 =?us-ascii?Q?hZhrdtWyTqJIFEVHa5u/j3ZhkZqkYJsFsupAH6ZMqUUQ+bJBrBQBXOgw2uEp?=
 =?us-ascii?Q?nCg7uc1BeJQPlqFkgZvvMvzNmnOPRfL3xlac2LKJU6Pcv9o3k7EB2Ik3casE?=
 =?us-ascii?Q?sDWcjmfsQ8R4Dt49pHe0oxZKbVjzyV/S+Dqm2xYW4fKeJ5ixxQWLW1tgG3vt?=
 =?us-ascii?Q?3JYTzb97jsMboy7VP3zr6EyA4LRQmxaXKfPY47YMl4zKSPfQpKqpZ7gucS1K?=
 =?us-ascii?Q?cZplwHf65qMp52Y6UswIKHG+AXwZ/h1pzCAI3qvIFLSpKMshKeawuF8lm4tS?=
 =?us-ascii?Q?XHMyN1U6SztXYe3GtGt3FCbJbVfFLP9V965eG1iaUPGCVAYiZfA4e3VCFulT?=
 =?us-ascii?Q?MEyV3jQCpUve/TmXJCsSWNK29SLkn0xj8ftIpj+1ADkGcW4hEBDsvqoU8Igf?=
 =?us-ascii?Q?fZyfWDR6YWkd+LLlR8YWthGt6oSgrRCQ1ttK1xXRCRxgtXESKDW7hy0Bkk1M?=
 =?us-ascii?Q?LnaQkGFtnbwOL9wMPeMBOZIaNV5wrDLzHwI6uZQbEq1aigtGy6ehsvCwdch0?=
 =?us-ascii?Q?f1w3O+NB+upsJCpHR7jSFWFxjY0KE5/MSJc9wPDDe04xOrYWEoPLKE7KPwCJ?=
 =?us-ascii?Q?X0nuWM92h9tpQps/pv+FKk7/mNH7QSSo/G2VOX+AENR2EU2kLEzjnJpw6Lmm?=
 =?us-ascii?Q?RxoVUe/gbKbeb2L0YYKVCveoboeHFqVXSlgDJcz4DIlPF22u2qhmgRMt2/B7?=
 =?us-ascii?Q?jpRKyxhl8ki42UXj4mtAwD8Jyye1hzzHKcDdKTOLH02lXfXuLs/YXgDOH+fI?=
 =?us-ascii?Q?SFvWbTJJ3ZvX6eXxZjazQ0w1LPCd7aPA/hvRDiOgjZc6xo28YbCSll0Gxikj?=
 =?us-ascii?Q?TMCUNWDTYN9hTUd4OHCLOm4kFczzuAP2Kv+m14dhzzBUdkXZP1iXvWvh3wfL?=
 =?us-ascii?Q?/J9uDLIAjfL0m3ErycrPlhJ520vJHVRTVbJTK+KD+T3emlT47ruJyoTbkKKC?=
 =?us-ascii?Q?/2rpb1I7/bAACYDlvTVuxDRYu4zcbQA0axtnDK/2+s3B88Pyu0m8EFcKm9Gu?=
 =?us-ascii?Q?KOCwIL7E4C1ni58ziukOcbqK3CgxRtrQ8ndpRJ+xhSf7Mj2fmJ2zutxeepg3?=
 =?us-ascii?Q?HhAjGAkKysFc7BreF51BunbqUlr98ljWZjfVnDN+/41W+aPuTVHEQfmFm+r2?=
 =?us-ascii?Q?sAN3LV8mXqM1UCGETmT4QBFb4z7QFTB4dz0tV72k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c642ee4-866c-4340-8f9e-08de286beb50
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 19:35:12.4229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hINZbkJtRZm2YcdVCe5DyVW0zj3MwpPmNOHrfziWoDVEeN+mxLGIiFFUb8NnwSftW8ne6o2OXXzQMTyRKnt/FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7814
X-OriginatorOrg: intel.com

On Mon, Nov 17, 2025 at 04:42:45PM -0800, Reinette Chatre wrote:
> A new resource group is intended to be created with sane defaults. For
> a cache resource this means all cache portions the new group could possibly
> allocate into. This includes unused cache portions and shareable cache
> portions used by other groups and hardware.
> 
> New resource group creation does not take sparse masks into account. After
> determining the bitmask reflecting the new group's possible allocations the
> bitmask is forced to be contiguous even if the system supports sparse masks.
> For example, a new group could by default allocate into a large portion of
> cache represented by 0xff0f, but it is instead created with a mask of 0xf.
> 
> Do not force a contiguous allocation range if the system supports sparse
> masks.

Note that the allocated mask on systems that require contiguous bit allocation
is not optimal. In your example where the available bits for the new group
are 0xff0f, resctrl will focus on the least significant contguous range and
set 0x000f, rather than the larger group of bits 0xff00.

Fixing this would be more complex, and I don't see a lot of value as the
user is very likley to rewrite the schemata immediatley after creating
the new group.

So for this patch as-is:

Reviewed-by: Tony Luck <tony.luck@intel.com>

> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Not a stable candidate because nobody has complained about this and it is
> not a serious issue but instead an optimization. Discovered during code
> inspection as part of review of:
> https://lore.kernel.org/lkml/c5807e73e0f4068392036a867d24a8e21c200421.1761464280.git.christophe.jaillet@wanadoo.fr/
> 
> Tested on system that supports sparse masks.
> ---
>  fs/resctrl/rdtgroup.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 0320360cd7a6..41ce4b377af4 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3383,11 +3383,12 @@ static u32 cbm_ensure_valid(u32 _val, struct rdt_resource *r)
>  {
>  	unsigned int cbm_len = r->cache.cbm_len;
>  	unsigned long first_bit, zero_bit;
> -	unsigned long val = _val;
> +	unsigned long val;
>  
> -	if (!val)
> -		return 0;
> +	if (!_val || r->cache.arch_has_sparse_bitmasks)
> +		return _val;
>  
> +	val = _val;
>  	first_bit = find_first_bit(&val, cbm_len);
>  	zero_bit = find_next_zero_bit(&val, cbm_len, first_bit);
>  
> -- 
> 2.50.1
> 
