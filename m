Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FD32F742
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405529; cv=fail; b=sb+9Tsxg7hwC/8C9YWWPtYVB74k2EDQCOJXSz2Y9iB45rgz8OcG6QDXtRj9tioKH9baPnOrWyDqSY/bGqQPtvsfCvAy5e3CTGlFw6vTZ4jXmsx4cERuiK8KcJ4Oab4SKDvq6MSmGlEE9f/pi0sXFk4JKqLQp7r8k0+K36TK4UcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405529; c=relaxed/simple;
	bh=3FjF5l+hbrK/c9qgs4O8m8ebZErwfUhYBVwyXeTXI/o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AFsuP69tF2KON4n/JGJPDreUJ23PXgi79csfr/5WpjE6QMgpXAySIdvKexRryhMpT4SuaezW35UMfTQu2ogCQSVYR54FBePSxLFWrGF+YX22rf5V+ahSTkMw3yHqfNZFmhPtR5qFYakUmiTV3abLoXRNf14Eiucdr6fldOhudgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=arU+n5+u; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="arU+n5+u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763405527; x=1794941527;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3FjF5l+hbrK/c9qgs4O8m8ebZErwfUhYBVwyXeTXI/o=;
  b=arU+n5+uGCd2mKWAvxYU4ggnc1d0mLXOQMksY19TLI3PAx5GM7C7pJ1n
   wZpaaT+o3uplvmd9TA5pOrUUNdd1p2o95AlOBUM09jHhJ+3eDGaVT1u8O
   WKDMEfC5rcMeWqh25hvtj5mDW7f7HMiHlh+bYFx+MWKGZko6XMa56nchC
   6FFFrMPCJ1L2xJ1a0uxT3VVnFduzdUQldNHi2EWmeW6yIwpsLjr5lzoP8
   hdFkYMJfcTipgZczqyz1Ch6qJNijfgoHIACPISx1T8hFbNIvy/rpQrs6W
   neqLFxCJYMtfBUFBmvmupTLi2ozQBMLKq+K5f5boI7AfvIv5foYMKbXRt
   w==;
X-CSE-ConnectionGUID: qJKOJZS8StCWAlWq1FvzGA==
X-CSE-MsgGUID: HYJa3d+gRj2K7dO5EjnnsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69265274"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="69265274"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 10:52:06 -0800
X-CSE-ConnectionGUID: uBOUA+aJQUyQIKfuqrOWkA==
X-CSE-MsgGUID: YJ0ff6CdQc+HJIpy4gusig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="189790744"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 10:52:07 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 10:52:05 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 10:52:05 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 10:52:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xXzKk+UBTevIaPBklh0LOBAloeA0kAL/IIHsacRmp534TZHH+exeBouM0V7i8Qt5i85KPb1O3pWoksHVRfVBv8ge37BmdQqlIgTJSY1KYFRyk93axukQIVYl7CrlpXQncppALECO+ROhApTexxKSQIb3GBkisCUtNN90Gvsm/BhvLhYiKnGAsC/MRwElqIwGlZ/bPwV+vPYgb3L2hKYrNL/RORebGZPWNFO7WEh/4CfP9m8ClqmpoEv4ufJqyKRh77H/TH/0v0Dx4pJ/ZDlPvoUZaqaCb1wU6ZIQPshUYdgE1D2ukWOupscVaOY1yl8DYEBjrnqOCwBsT+lEdh1ULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2TFHsT9FyN2Fy7520eQWvLQeoLqfNADfBOhZ4KAPkU=;
 b=S/iY5ecDXHWkQxU3k/5ETVoFv1uWOv+5qiQb8EywhMP09Ih/YaYx3EOmKWdF8dHX80iOJycnlcxI7FNneMf5LpWJpHjrpX7Sa/7eySoi8kum6DvAGWEVpJ7d6G6VpJ/udeyBX/cmnO5uwfhix2NHNXBlzaW9WzrAo19Z/+SAtNOeNDOaFUDcxVMBn6djMlgA/4yttv3uWoqVovFmL92/tu7ENEd57lES2IJBOoWQvmrzgNifHDVYYtb6gv0419kr8+XkOT5nGx/x23FWKH32qWtoTHe7wBDArYDq6M5jt5apbbAVX5dLLFHRllJlFtknXz0X3eYCQ3UEq5DgiBF1uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7245.namprd11.prod.outlook.com (2603:10b6:208:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 18:52:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 18:52:02 +0000
Date: Mon, 17 Nov 2025 10:52:00 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
Message-ID: <aRtu0J4os4bXTLV2@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
 <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
 <aRtPL9IQXWiKfhEk@agluck-desk3>
 <cdbc23f6-cf4b-4e83-a037-0aaf7c076e8c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cdbc23f6-cf4b-4e83-a037-0aaf7c076e8c@intel.com>
X-ClientProxiedBy: SJ0PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::11) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3c0dd3-119b-4948-1961-08de260a650b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?n52DfbVaXFAiQWZQgpPNTG0myg8Q7nIM4MPXzKtr2VfFUXuAxVToZjQzyBvJ?=
 =?us-ascii?Q?fcMJ3mxpIVquVP6dA6Wq9h2BDvSUZqQQfFNoay5XXN/F2xx66lZXMyUfqV5o?=
 =?us-ascii?Q?v3ofBUlOCR10U6X3jt5ujAL+cLAc6DM+pPRF6BqglUZIFEnBcJNihhb32dxu?=
 =?us-ascii?Q?hTw8tG6RHyI5SCpLiPjv0hWsWlNcNHRkINqOfBxUiU94oVmKxbIJK5DmoSZx?=
 =?us-ascii?Q?ckgCBck4qfU/yPWAKzqnenPbIHrvxDHFafN/tFdkMjMGupeaajCuth+ATpR1?=
 =?us-ascii?Q?8bA1Vu8dEtRrd2cVbcZzGfVbItNOjUBnKYbTsXgiVTG1tpBRE7GRBiQD+RpY?=
 =?us-ascii?Q?ubbdq6Uq6iqMi/ioYYA1em/T7SocjCcF5qi/hYeeGdUDDzAqzpwE0vfsw45M?=
 =?us-ascii?Q?1mj5i/8FnFinTYz3ozQqihV+qKeCr0wLraYvoqFgkr+9gPirWJITAn5+AfZA?=
 =?us-ascii?Q?tSctTNFT1NkT0n0uOTsGUGJmrCUWbyL1jDD+LNTP7UabJvUA6vkeBBOk7G1M?=
 =?us-ascii?Q?gjc5D0lPl6SXILdtJldFgH9zgyvD9ujNAJEiE9Wc+YwOgLr+3inIE4b9o1Dm?=
 =?us-ascii?Q?Qg/gCv3/wq9cRlm7Y35Sv72uW8vwX2SFgt2Yvu0jspHo4PYE5kw6KqEFHxYL?=
 =?us-ascii?Q?8K+grta+QNuPOtFiyA+to/wUGUeI+m3LxW4Jam2yOVZwDwEhj+vY61/c/7HU?=
 =?us-ascii?Q?niMPyjzknoip4iid6mI6hp9i9XIfnCQu155mol/HQfIuXmZ1SQWvhcHJIgKu?=
 =?us-ascii?Q?/+g6NsPKncOu0vfnaexBgez7UFjx+yXvQtKnB0hm2d7D+rckzvGTjGAV5/9P?=
 =?us-ascii?Q?kCCLc1z8cS+A/JaNpN53fw5SdGQl0BCAPyrCwLTr4iv8zZUTgw30vzheVB75?=
 =?us-ascii?Q?unB/B9sPcBrOxcwT/StVNI0VXG8cR1umMFgsV5nDKLWBiTm2sVPU2F3EXS0E?=
 =?us-ascii?Q?m6NlztpyoR7YXv1lJdgfnV4+6dzn9r1jH8v0rcVl0dPkKV394PqhbsiFy/pI?=
 =?us-ascii?Q?4ZxhWxNE1DEqpNX+u4FWhQpAOSEZSSca2oTK51cMpFDEdYt+h9g8qgoyv2ar?=
 =?us-ascii?Q?VsgN2ZfpMPKtgxEmI2CKyGXepwzHxN6RQXZlk6HMmWWxjdphNyugeVcz1D7A?=
 =?us-ascii?Q?UUbRLFbz5ugJZmqCnVkoemZ2mvJOqkfUp1R7J+Rbm0Pf5ARCKBh/EGB02g6i?=
 =?us-ascii?Q?yha9O+OjGFT6MNRkOh9AeK+pz7exjOSQa68KwtPXQOqlapA9M0+OPeCAeHRz?=
 =?us-ascii?Q?5iON+KK0diqRBZIpkgnWVK1EZnI+Ck+5ead2SEobXKtPV1fc6MTuLel3D0WT?=
 =?us-ascii?Q?Z1EYG7SQ1npSplLvyFs5HHidWmzg4IbvUrmDOk+57Ni7MqxWRYEYyUCI5l0r?=
 =?us-ascii?Q?07dH+QD7kOYwIN8b6XBzDMyj/tao9XsY/CAjfs6M7mIdgZvzol4cZKSuE8oB?=
 =?us-ascii?Q?2mQYwznu+aOFMecy7WDAsa0KvHpFUR/w?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mxIn2U1DeuyVCGon1OOt8sk/AJFkAJkdRExGaGYW0hdJGQZcTKDkGnewgWwl?=
 =?us-ascii?Q?0cvFf8ZA6SqYeSFkQLpN4a9/7mitl5YTg+vPfGlAXP9ACh4CC/kNBpGRnIfp?=
 =?us-ascii?Q?M31e0JXtkxqYCVQHYAeiOczorwy5AEx33Pn/UZCnfYJDJ0dV7oaIaGFJ3W8B?=
 =?us-ascii?Q?Y8QXlqxADsc8wJyTuZnbwfgdsbbbKtU3alXCxBIGgYG3gNa+A7VXfxH8jiHU?=
 =?us-ascii?Q?HEOWwnUZnvcuLELHqUq5EpU53w1Cc96suAhom/TEI0CMtFjOZ1J45J4tbAL6?=
 =?us-ascii?Q?HBFARjgEIHzOrttjeNphc4XYVeE4Wp8PlmyOwQXbouYxgFTOjtJDse2LaJPv?=
 =?us-ascii?Q?t3dISzAsaSa+TTyKjQwGRkry1NmsH4yYXwbtnR3t57dG+5LrTPNmKWRMNZPy?=
 =?us-ascii?Q?uSxUYhLSuc/zp3DYTeHXMFgHQvj1bFD03ToEuzQMW93NWwf0P09g3lB7CJ3d?=
 =?us-ascii?Q?a+TrctIicPoPC5OZpqzm6qkVtjBSpdpXxDj7ZCrkTlW+92TTVLFFe9FiNiRr?=
 =?us-ascii?Q?eEJ37BjiPWtomshu5ookN0S8qR7jieFD5IrzoI8yLBBJnrvZ8XOshaQHvCds?=
 =?us-ascii?Q?55rrFI3Lam/jJARHuVR2HSfL6X3rtAFA6tHdwf4ghLlyNs1ZWGW+96RASRKU?=
 =?us-ascii?Q?3C8qVSlUIawP2TU1o1vWsW1CM4nIHY79Xi17YrbF3fZmII3jlgDTT4v8Qnxv?=
 =?us-ascii?Q?GUuRKZV8SojDKcuPCDyXLJ/ZEkL+nqKrhVBNlOYbcXpyTBzhbo25ZGb2c66k?=
 =?us-ascii?Q?HZAci7kw0JYjP5pTA6fwN1w+Ny0ZWLlJFKj93zmrMpiR8zjtQdTtEkk80X5A?=
 =?us-ascii?Q?8adksmTfhhMiAGXSc128XBnBB0eFaEOr+6+mnhRInPFjnOYleO/wKOkKQaGt?=
 =?us-ascii?Q?UYObPjkj0G+k29tv+ulf8tZeIuUvaa/mlSfNEkgGRLIF4yJdK+eCHuRiaG+/?=
 =?us-ascii?Q?dNbfnYGZFWtqGZSpqNayV6tfQ+pD6tAY5gCLBM2yQ+SOUrFNN4FaJPaIAj50?=
 =?us-ascii?Q?HCsawYXflZ10sOLUf57k9vdkiwS8riRo0i+lgw+numAiQGO3Khxy68omV5p1?=
 =?us-ascii?Q?aVNGesi3AvJC7xRxabKpP5Ersjmyqk7lWP3flHn7o/RTVhBi2lAcLkaD18S9?=
 =?us-ascii?Q?6Ac6rhGyjfkfvdPtcvo2OBjI4U0Ol2YRqwkUDUkdjSMmtBRC5+x1K95TdLLU?=
 =?us-ascii?Q?BDee/JIxNQCokDoqYOVdqyTQYpe9/nf/il3AlRStKha9KUEbYWRPdCUGkrcT?=
 =?us-ascii?Q?uWUI8YVgMDo8Io8OdaXu22qfOSB12fD6vAQYqCMh9LiClc8/7VR5T+1u0wRl?=
 =?us-ascii?Q?AkhnitAhctRlCdzH62RWS7dfztQ49/w7YHAoGJmDtcv6LYk0UPlg+Ach1PaF?=
 =?us-ascii?Q?ygJPYHXpWH6ObARHlnxR/ujbKV9FBtrrI9lc+Bm7PEpUzBvAJWK6HMzaP6jV?=
 =?us-ascii?Q?HX+Z7SjXOtJ2VaxJB+GUskI6WIbTquIVncpsLWWR/Yc3OpZ8eUaB3MbQUz/F?=
 =?us-ascii?Q?X7yLtEPrCoSpVVBNyU+3oTrlb2Zh9hjWBTNmu90OWnG8MaKnup3xFwdLxDKw?=
 =?us-ascii?Q?bu84122vSG6ykeFoQiPj8Qi/3XaXZV54R8ex9cJa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3c0dd3-119b-4948-1961-08de260a650b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 18:52:02.2407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3T/FqXvl+03Ym0xhXJK2ZCU/Kqdb/oUKC86pTdYAb5qOB7LzZoSXyN9rXFi18bgtutVjpr2Gwq99YDr4a1Saw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7245
X-OriginatorOrg: intel.com

On Mon, Nov 17, 2025 at 09:31:41AM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/17/25 8:37 AM, Luck, Tony wrote:
> > On Fri, Nov 14, 2025 at 03:26:42PM -0800, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 11/14/25 1:55 PM, Luck, Tony wrote:
> >>>
> >>> resctrl: Feature energy guid=0x26696143 not enabled due to insufficient RMIDs
> >>>
> >>>
> >>> static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> >>> {
> >>> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> >>> 	bool warn_disable = false;
> >>>
> >>> 	if (!group_has_usable_regions(e, p))
> >>> 		return false;
> >>>
> >>> 	/* Disable feature if insufficient RMIDs */
> >>> 	if (!all_regions_have_sufficient_rmid(e, p)) {
> >>> 		warn_disable = true;
> >>> 		rdt_set_feature_disabled(e->name);
> >>> 	}
> >>>
> >>> 	/* User can override above disable from kernel command line */
> >>> 	if (!rdt_is_feature_enabled(e->name)) {
> >>> 		if (warn_disable)
> >>> 			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
> >>> 				e->name, e->guid);
> >>> 		return false;
> >>> 	}
> >>> 	...
> >>> }
> >>
> >> Thank you for considering. This looks good to me.
> >>
> >> I now realize that if a system supports, for example, two energy guid and only one has insufficient
> >> RMID then one or both may be disabled by default depending on which resctrl attempts to enable
> >> first. This is arbitrary based on where the event group appears in the array.
> > 
> > intel_pmt_get_regions_by_feature() does return arrays of telemetry_region
> > with different guids today, but not currently for the "RMID" features.
> > So this could be a problem in the future.
> > 
> > I think I need to drop the "rdt=perf,!energy" command line control as
> > being too coarse. Instead add a new boot argument. E.g.
> > 
> > 	rdtguid=0x26696143,!0x26557651
> > 
> > to give the user control per-guid instead of per-pmt_feature_id. Users
> > can discover which guids are supported on a system by looking in
> > /sys/bus/auxiliary/devices/intel_vsec.discovery.*/intel_pmt/features*/per_rmid*
> > where there are "guids" and "num_rmids" files.
> 
> Should disable/enable be per RMID telemetry feature? I do not see anything preventing a system from
> using the same guid for different RMID telemetry features.
> 
> I think it will be useful to look at how other kernel parameters distinguish different
> categories of parameters so that resctrl can be consistent here. Looks like an underscore is
> most useful and also flexible since it allows both a dash and underscore to be used.
> 
> Another alternative that is common in kernel parameters is to use ":". For example, 
> 	rdt=energy:0x26696143
> 
> With something like above user can, for example, use just "energy" to disable all RMID energy
> telemetry or be specific to which guid should be disabled. This seems to fit well with existing
> rdt parameters and be quite flexible.

See rough patch at foot of this e-mail. It's just on top of my WIP v14,
but if it looks like the right direction I will merge it into the series
in the patch that adds the energy/perf options.

> > 
> >> How a system with two guid of the same feature type would work is not clear to me though. Looks
> >> like they cannot share events at all since an event is uniquely associated with a struct pmt_event
> >> that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
> >> will complain loudly but still proceed and allow the event group to be enabled.
> > 
> > I can't see a good reason why the same event would be enabled under
> > different guids present on the same system. We can revisit my assumption
> > if the "Duplicate enable for event" message shows up.
> 
> This would be difficult to handle at that time, no? From what I can tell this would enable
> an unusable event group to actually be enabled resulting in untested and invalid flows.
> I think it will be safer to not enable an event group in this scenario and seems to math your
> expectation that this would be unexpected. The "Duplicate enable for event" message will still
> appear and we can still revisit those assumptions when they do, but the systems encountering
> them will not be running with enabled event groups that are not actually fully enabled.

There's a hardware cost to including an event in an aggregator.
Inclusing the same event in mutliple aggregators described by
different guids is really something that should never happen.
Just printing a warning and skipping the event seems an adequate
defense.
> 
> > 
> >> I think the resctrl_enable_mon_event() warnings were added to support enabling of new features
> >> so that the WARNs can catch issues during development ... now it may encounter issues when a
> >> kernel with this implementation is run on a system that supports a single feature with
> >> multiple guid. Do you have more insight in how the "single feature with multiple guid" may look to
> >> better prepare resctrl to handle them?
> >>
> >> Should "enable_events" be split so that a feature can be disabled for all its event groups if
> >> any of them cannot be enabled due to insufficient RMIDs?
> >> Perhaps resctrl_enable_mon_event() should also now return success/fail so that an event group
> >> cannot be enabled if its events cannot be enabled?
> >> Finally, a system with two guid of the same feature type will end up printing duplicate
> >> "<feature type> monitoring detected" that could be more descriptive?
> > 
> > I need to add the guid to that message.
> 
> Sounds good. Thank you.
> 
> Reinette

-Tony

---

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 08eb78acb988..25df1abc1537 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -241,6 +241,7 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 void intel_aet_add_debugfs(void);
+void intel_aet_option(bool force_off, const char *option, const char *suboption);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -252,6 +253,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
 static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 					      struct list_head *add_pos) { }
 static inline void intel_aet_add_debugfs(void) { }
+static inline void intel_aet_option(bool force_off, const char *option, const char *suboption) { };
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 5cae4119686e..68195f458c0b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -842,6 +842,7 @@ static struct rdt_options rdt_options[] = {
 static int __init set_rdt_options(char *str)
 {
 	struct rdt_options *o;
+	char *suboption;
 	bool force_off;
 	char *tok;
 
@@ -851,6 +852,11 @@ static int __init set_rdt_options(char *str)
 		force_off = *tok == '!';
 		if (force_off)
 			tok++;
+		suboption = strpbrk(tok, ":");
+		if (suboption) {
+			*suboption++ = '\0';
+			intel_aet_option(force_off, tok, suboption);
+		}
 		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
 			if (strcmp(tok, o->name) == 0) {
 				if (force_off)
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 6028bfec229b..b3c61bcd3e8f 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -69,6 +69,9 @@ struct pmt_event {
  *			data for all telemetry regions type @feature.
  *			Valid if the system supports the event group.
  *			NULL otherwise.
+ * @force_off:		Set true when "rdt" command line disables this @guid.
+ * @force_on:		Set true when "rdt" command line overrides disable of
+ *			this @guid due to insufficeint @num_rmid.
  * @guid:		Unique number per XML description file.
  * @num_rmid:		Number of RMIDs supported by this group. May be
  *			adjusted downwards if enumeration from
@@ -83,6 +86,7 @@ struct event_group {
 	enum pmt_feature_id		feature;
 	char				*name;
 	struct pmt_feature_group	*pfg;
+	bool				force_off, force_on;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
@@ -144,6 +148,26 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
+void intel_aet_option(bool force_off, const char *option, const char *suboption)
+{
+	struct event_group **peg;
+	u32 guid;
+
+	if (kstrtou32(suboption, 16, &guid))
+		return;
+
+	for_each_event_group(peg) {
+		if (!strcmp(option, (*peg)->name))
+			continue;
+		if ((*peg)->guid != guid)
+			continue;
+		if (force_off)
+			(*peg)->force_off = true;
+		else
+			(*peg)->force_on = true;
+	}
+}
+
 /*
  * Clear the address field of regions that did not pass the checks in
  * skip_telem_region() so they will not be used by intel_aet_read_event().
@@ -252,6 +276,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	bool warn_disable = false;
 
+	if (e->force_off)
+		return false;
+
 	if (!group_has_usable_regions(e, p))
 		return false;
 
@@ -262,7 +289,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	}
 
 	/* User can override above disable from kernel command line */
-	if (!rdt_is_feature_enabled(e->name)) {
+	if (!rdt_is_feature_enabled(e->name) && !e->force_on) {
 		if (warn_disable)
 			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
 				e->name, e->guid);


