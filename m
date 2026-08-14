Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51D3CCFB2
	for <patches@lists.linux.dev>; Fri, 14 Aug 2026 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724896; cv=fail; b=Aq9GZnrlyCXlN0tWF+SpkzMa29cCmhHx+688JAD5sys2siyYFPAVCiWkyfndHPpKr3pF7FTO23ezY87AWJz/jJd2R08UhqSOwslv+pgkAbQBRlWP8U2i4CRmrsI4LNmVo5grRhTZVsqnSNKoMQiJ+os2tnqphPQo8clLmahitc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724896; c=relaxed/simple;
	bh=6ENw3u2jro3RUHgb7+kliIrV11aVJVf6uavNCwmJ9fU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pYZUpXhGSJvPSLsCQnZgkQS3ybV2NXyFoDfkVHvRil/PjkgHCzifm74VP4fpcDoICwYeWW+DAMdA0T39leGZhXFapSQpeEJ81QrDYIDgMUhjPYpOzT8NoAP4Jj1WNO/+43documpMsWNklJYUdttkUF9Hyf2Y0RMR7wYL2LEb7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSgpqrHQ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSgpqrHQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786724895; x=1818260895;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6ENw3u2jro3RUHgb7+kliIrV11aVJVf6uavNCwmJ9fU=;
  b=hSgpqrHQzZU3E7dxjS7oZSYNiMq7WaS7PpJOnuNQK8QSiGZlo0Mo80OW
   zVobqSrPCrmIaW8QFhW1Vf4SWcuvvtyhhivQhOrrXa/qfkqXgp949cs6+
   WqThdeM7YLXv3EmRFTmw7qFsvekrcLRC8gH/DG8/502C6XaVBYOpa8pnu
   hnIdW5EreRCSvLCsuPzzZNpN/6aY0I6I+iiowJim3tJa3CR/t6wk9KCC4
   ndS8EGF5aLj7ZC8HISXC8cZBXLzC8b7l3yI6Pujewi31r+2zfH0rVUPy1
   oWOPtPFbVLWa5Pl/x70acsc+whXoyrOhS0fmN1GFu+oA8lEx2f1t2TK64
   w==;
X-CSE-ConnectionGUID: lUuZJ2GfR+2+Ma4aoj1sFg==
X-CSE-MsgGUID: pxJeXbi9R+ePAieb5DlSsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="87522508"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="87522508"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 09:28:14 -0700
X-CSE-ConnectionGUID: fRwD+eBTRnaKiYnodGlRlQ==
X-CSE-MsgGUID: pYTdkfR7RTSyXZNaorbpdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="267754053"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 09:28:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 14 Aug 2026 09:28:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 14 Aug 2026 09:28:13 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 14 Aug 2026 09:28:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVTkuvmK1OsNzQFKEAIta/i8DPMixpOuXeiqYnS/1GYxzBS+7ZZ95YOPfx5LGzQ3o7ZK5UoGhFHJJO/9B/sxEJnevIIrJPUiWF5EXhCciWKbFHMZR0sKzJXkt8bkhOGffsQmYSGL6YgCrc91VgaPkK14kcmlzTCbnWt95Zz8If0YR9lvE83Wn87N9Ztixs0KWbm9iY6awTS4uZ9qSpTo+du8NIb8AQ8ERr91TK7e4vflwoJxsXOI0oK8ZgOTZ8xMwlRZ/9bqP5fn1DB1A12MDc795+DBzqaXRtUd7wiQXkAc4eD7QQv4A3lEPZPZki2r8Dkg9fEsj6njp7QdcVnlwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we+B1fqik02ukQe5o5/rrsEWVBFjWoSuTg5oRvHIn/E=;
 b=UTKbCuqJsVYbsy5kzSFPM9UslrSLZk1+3hJ1Qi2ML5njtQzWao820O994mTZPMqDOQ7rrP1nZMyQGjSrc2BJPJtEZKa7pIuM5OMdNJx3wjYDgv4jCv2tfwbDj4ExR19F/GG+7oRBtJmaRVXQ0BtwWre61Zd6F4+yc4kDTMSnatxOtUjejMlYYGer8EdlPSqoOjsGnao+LiwnDjd43gOu91qrhyhcrdpUVftZKI2RjKD+ObTSY6wcxY/RN0436mCbRLX3BeLG/aU/uxPev61t0GN1L+qFKNJvLb8CV10ToG2/hu/K+u+LY2E6QmUcIdkHi/1LHtJTNtVVsDMhuXh+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA4PR11MB9251.namprd11.prod.outlook.com (2603:10b6:208:56f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Fri, 14 Aug
 2026 16:28:07 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0315.011; Fri, 14 Aug 2026
 16:28:07 +0000
Date: Fri, 14 Aug 2026 09:28:04 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 01/17] x86/resctrl: Fix enumeration of number of
 supported RMIDs
Message-ID: <an9CFNCq6TjYw_o1@agluck-desk3>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-2-tony.luck@intel.com>
 <f06e6b33-4d31-4174-80ab-8ebc51132fa4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f06e6b33-4d31-4174-80ab-8ebc51132fa4@intel.com>
X-ClientProxiedBy: BY3PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::34) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA4PR11MB9251:EE_
X-MS-Office365-Filtering-Correlation-Id: 20b1013b-88ba-4ba9-d351-08defa2104f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|10067099003|11063799006|56012099006|6133799003|3023799007|22082099003|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info: Zk2W2OK6+qldrsxAPZ4mXjAM9bRQ/HQC5igBQur0OcGAJUNXvO9ENkxQcUMQHY0gMddi9EE+IA2erytEjepcNrY1kFM05JQl32UtMmCCuHL67zaI50aDajaEZanNCg067AKfDMcTG2TMieY0//aopvWNrfo+a5AWaPSzHnDEwe5PPHjG/L+YjOiBD76LLyfxJ143pongd/kx6BTIkz8dJ4WShmaEbU0QH8w6BwqGhzgc2i4ue2orGjs22QkgpAximm4pxL82FbmqDPQL2MLQfwDOfPytfSsPkPbUxtYLmJlbiw35oNI3MyfHwHfrFIiPrwq9/ROJN4Bg2dOjnTIfyig9+SRYfuEAQ3jb1O3JY3o7hXLJ68VlYrhfy8Ars2Bvje9WfW9TuxRRcb4BxZLYOra8jYXfu2kQ7Ham8Xtu3fM2q1FYXdp1Hue0hgez5b7Y7wjX/rEcBkBStUaX9CVRRafmf4olP/BTJP9nB4YVhOzcPMACTUlhyMOsi+RAXACcftnOIt6rKRU+UglfhjToYEumA9pUWPPxC0FjltLsr7g97WYjUwTo6N7SUojQB/A6aAbiGudQbrDLHog64OsYNlBXqCGphNcC1q7Tp8ScAgZbCovtRUzgwY1QTRcc0uD2JFqGh4VRgVzEUgqadgkK5IClfJwY3mkppm+Ee1S45HQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007)(22082099003)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zesV/69SHzgUqyQOdhmWIjc27xbMh7PE5QDUUTmvO/iYRhFC7ICMsBcFI2n+?=
 =?us-ascii?Q?3edrRH9UxKZR4lfrJ8Mlis8RV7WVe/uPR/edFRlXZA0Te2+FsRrUlVcB4g0l?=
 =?us-ascii?Q?lmoK6iTly04Pbiv1zL4Rxts+3YEo5m1TLTPHwTw3FooDoYsaWCIbn2eng1nI?=
 =?us-ascii?Q?CZPOPgoTZ8VnD1xWm32BHHIZXyr87HXYVyxznBQAjAjXANdI1v2hohfzibV/?=
 =?us-ascii?Q?ZojnKMiTLRPmhI4bqvZHpmkPpKHr/06ZvLpM0QOrJgVbwPWq2UWlMxgJFlIm?=
 =?us-ascii?Q?SM37n8OrGkMgLv1FZqTQUMnHrueX4kik0XFuAgmA+OFIuahmwXejmx04xmV0?=
 =?us-ascii?Q?7A2uwv4z3PHCuHDo7I72e0NWFwKzwGgqMsu4axw0HFqd8dFXNUsb6uV8clab?=
 =?us-ascii?Q?spQ1G7cvFCVv+9tuwMlN2/LiuELNLZNDE0Z5Ygt62zkrjt0zvFqV3aJX3phn?=
 =?us-ascii?Q?++foKnss8n9zDeP168n5L7Vo6ur7NDuG+mpAnospd7l77uU5ziKz8SDAVrPt?=
 =?us-ascii?Q?hyVxwQEwu5FrrNpbSlMwLr9TgfVv2HG1Z4Qh3F1FjEi7+HBbUu4jTY8jIJvm?=
 =?us-ascii?Q?AHJKCFW8fq4KLypUWmqCX9Sj4iI7QWYfyp2roe8OueApt2d9ka2VlmtPzvfa?=
 =?us-ascii?Q?xPxyKCWCIwdC6WK0ME4y58gYSQ1Y6GzbO4ryGn1iG+XMLk0x44FF/JPzBfE5?=
 =?us-ascii?Q?An/iYJsGviLhxOjB5O9MqcjKe7+m+ZI0WC6rhdnZxCAHVkvABkrOc4dW3178?=
 =?us-ascii?Q?eh9egqnFN3jjcj/zY7WN0lMvEsiVgl4hJ7O7vhlyfDBlZ0OoIXrAv6MK05xi?=
 =?us-ascii?Q?dj0BOcTk1tVtq26S5TacQkF78EzGRIM/mPD7U11PAyikYOvlFsCl47fXvmds?=
 =?us-ascii?Q?Hnk4RKmtEPAnbdAttLtz1b92v86blkc4CFDNcIK7n+z82eZFcZDYJUlJ3D+w?=
 =?us-ascii?Q?tFaehueDzyT/sb3AmxMFx0RoKSjR/rBmyFQM88cPvXlQ/SVkPqXL2my/nfrA?=
 =?us-ascii?Q?kzcusp/QJ0J49+r0f2hJTWknwlMeylHXJbGTGj6iywST9jukVCok7pTLAKRX?=
 =?us-ascii?Q?tecPDchXeJ3v2l6ohkjmEXFXVeMIE9UnIVKUR6a94Z67QXjbFRUaSbCFNuVZ?=
 =?us-ascii?Q?GdLtPTKrS/d5P3JJkMpJPHECPJ9avXNax78T1e4BtpG+CToS0ffeCufqnEuL?=
 =?us-ascii?Q?cs6FunpTvJxDlLAwREUMNpGa7VWDCLAu7HZJ95GqO3C9nhg2fbZVa4SNch3F?=
 =?us-ascii?Q?XjP0nwK8zhxJUgAQzjIBC0hR0HU5NXg0TvJXo/KNV56MIhuUhX33qoxkzlmP?=
 =?us-ascii?Q?G63iDYba4Xj547LQdVYdLuJSWUR7AEqhJw3N9cBHkPaTgeZkqRDFIYEohpqO?=
 =?us-ascii?Q?qLMy+Ot4Kww/pJl4Y/MbxjTniUThRZaaueqKWqk4UGd3DYG5hW0UPI9nRv5z?=
 =?us-ascii?Q?jq2ZnQXt/d+70tP+T9o4V+pclwUOg3Z2uZiVPKiTlQ0uhYkixgbDvV6YA6I0?=
 =?us-ascii?Q?IFrKDOTeVy5cFKpFnM5r8kL4QIPWdGO5/IhnnL6eeJFc1N/Ya1nc4LSAq6Pz?=
 =?us-ascii?Q?3Q+vEc6O4heqvNEkfwmcJFQ2E6/GYsxX0nv+IZPL9B0n6yGBWA7mttkrns9Y?=
 =?us-ascii?Q?FGIYG/MnDMHTOJDQEWdgdYT1IGVdnhMLJVIVkBYtM5zhXkkEE+d0di+CylNS?=
 =?us-ascii?Q?VCeBpJnx//CW3eknVSLiUlT48JKEnBYMAFfuhd+1C0JWKl3Tj4HP6f73E6uY?=
 =?us-ascii?Q?ndDidOLO3Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: cUyqPRiEAEEU+RUI52BClxOy6ZC2kBRvqeiGTVQ0Rlniuv9H1nxqi6lIXaNib4RMN73lWuaC/JmQuNrPFH22P7hxp2uCHzbJ0xbZ/Ok5IyzggsDunQrpPyWzMswXud4/awddaCJJuC+g/RCBMDGFew8tjwT7XBJAJ+MAcpVNvUjrAQ41fp8JD2ucqF5R9777QPjUrvfvV/lupxlbJjcdMsMDyxxt2jDLESq2Jk7UnbmXH7WVuBbw8CQ7kZfEuWTTQHfs54+wEopGPMZU/RCdeppRmYx4eP1lGsXyzvPfX/AcCc5DJzenwKNNe+FeXjMALJeid1encBNsvcXFIr7E2g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b1013b-88ba-4ba9-d351-08defa2104f0
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 16:28:06.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ib4ISi2x0IKXJZMVsScj6N9N/ptKq6d/tN0sHDsF0Lkuk7P69RrHJa0unstB5X46/qce5bbWIVEAajyl7wv1JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9251
X-OriginatorOrg: intel.com

On Thu, Aug 13, 2026 at 04:55:53PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/29/26 10:27 AM, Tony Luck wrote:
> > There is a multi-step decision tree for enumeration on X86 of Intel Resource
> > Director Technology (RDT) also known as AMD Platform Quality of Service (PQOS)
> > 
> > First check CPUID(0x7,0x0).EBX{12} (Linux feature flag X86_FEATURE_CQM).
> > If this is "0" no monitoring features are supported. If it is "1" then
> > monitoring is supported, the IA32_PQR_ASSOC MSR exists, and the RMID field can
> > be written with values from zero to the value enumerated in CPUID(0xF,0x0).EBX.
> > 
> > Second check CPUID(0xF,0x0).EDX{1} (Linux feature flag X86_FEATURE_CQM_LLC).
> > If this is "1" then one or more L3 cache monitoring features exist and
> > further enumeration from CPUID(0xF,0x1) provides information about L3
> > monitoring features.
> > 
> > Linux skips the check for X86_FEATURE_CQM and begins with step two checking
> > X86_FEATURE_CQM_LLC.
> > 
> > This is a problem for systems that do not support any L3 monitoring features
> > (or have disabled them with the kernel boot parameter "clearcpuid=cqm_llc")
> > but do support other features such as Application Energy Telemetry. On
> > such a system cpuinfo_x86::x86_cache_max_rmid is incorrectly set to "-1".
> > 
> > Correct the checks to follow guidance from the Intel Software
> > Developer's manual and AMD Architecture Programmer's Manual.
> > 
> > Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 9b9495174041..e3544c99cff1 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -1075,20 +1075,17 @@ static enum cpuhp_state rdt_online;
> >  /* Runs once on the BSP during boot. */
> >  void resctrl_cpu_detect(struct cpuinfo_x86 *c)
> >  {
> > -	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
> > +	if (!cpu_has(c, X86_FEATURE_CQM)) {
> >  		c->x86_cache_max_rmid  = -1;
> >  		c->x86_cache_occ_scale = -1;
> >  		c->x86_cache_mbm_width_offset = -1;
> >  		return;
> >  	}
> >  
> > -	/* will be overridden if occupancy monitoring exists */
> > +	/* May be overridden if L3 monitoring exists and supports fewer RMIDs. */
> >  	c->x86_cache_max_rmid = cpuid_ebx(0xf);
> 
> There seems to be a lot of history behind this code that I am not familiar with making
> a couple of things unclear:
> - Why is resctrl_cpu_detect() needed? I do not see why this early initialization
>   is required since the only consumer of the data initialized here is called
>   from resctrl_arch_late_init() and it could just obtain this data itself? 
>   At this time the enumeration of RDT/PQoS features appear scattered between this
>   and get_rdt_resources(), the latter already running CPUID itself when needed making
>   this early initialization scattered in all the "BSP init code" seem unnecessary? (*)

Git and mailing list archaeology time!

In 2015 Intel was calling the feature "Cache QoS Monitoring (CQM)". The
only part of what is now RDT was L3 cache monitoring. Initial patches
https://lore.kernel.org/all/1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com/
attempted to attach the feature to a combination of "perf" and "cgroup".

That's when the x86_cache_max_rmid and x86_cache_occ_scale fields were
added to struct cpuinfo_x86.

In 2020 x86_cache_mbm_width_offset joined them there, and initialization
moved to only being performed on the bsp.
f3d44f18b066 ("x86/resctrl: Support CPUID enumeration of MBM counter width")
923f3a2b48bd ("x86/resctrl: Query LLC monitoring properties once during boot")

> - Why does cpuinfo_x86::x86_cache_max_rmid, cpuinfo_x86::x86_cache_occ_scale, and
>   cpuinfo_x86::x86_cache_mbm_width_offset exist? Only x86 resctrl uses this data
>   and making it global seem unnecessary?

Agreed. When resctrl was invented, this enumeration should have moved to
get_rdt_mon_resources() and the fields deleted from struct cpuinfo_x86
to be replaced by variables within resctrl.

> (*) The one problem with this seems to be intel_rdt_mbm_apply_quirk() that uses
> the data initialized by resctrl_cpu_detect(), but that just seems to be for convenience
> and it is still just called from resctrl_arch_late_init().

The call to check_quirks() only handles this one quirk for Intel, and
happens before resctrl checks to see it MBM is even supported. Perhaps
that quirk call should be done from get_rdt_mon_resources()? I'm not
sure I see the benefit of a centralized call for all quirks.

> 
> What above inquiry boils down to is that I do not believe that this change addresses the
> issue that the patch aims to solve. 
> step 1 (above). c->x86_cache_max_rmid is initialized to maximum RMID that PQR_ASSOC MSR
>                  supports (sidenote: c->x86_pqr_assoc_max_rmid may be a more appropriate
>                  name considering the expanded usage)

Better to move this out of struct cpuinfo_x86. Also switch from
"max_rmid" to "num_rmids" (which can be a "u32" as everywhere else
with "0" meaning "no monitoring" rather than max_rmid = -1.

> step 2 (below). c->x86_cache_max_rmid is initialized to what L3 monitoring, if present, supports.
> 		Ignoring for a moment that this just blindly assumes that the value will be smaller
>                 or equal to the value set in step 1, it does not take into account whether
>                 L3 monitoring may have been disabled on user request or because of resctrl
>                 quirk. 

You don't need to ignore "smaller or equal". SDM states that CPUID(0xF,0x0).EBX
is "Maximum range (zero-based) of RMID within this physical processor of all types."

Thus CPUID(0xF,0x1).ECX must be less than or equal to this "MAX_RMID" value.

>                 The comment above states:
>                 /* May be overridden if L3 monitoring exists and supports fewer RMIDs. */
>                 If L3 monitoring is disabled on command line or via a quirk then this will result
>                 in fewer RMID available to AET than what the system can support in PQR_ASSOC, no?

You are technically correct. But to end up in this unhappy state would
require that Intel builds a CPU that supports fewer L3 RMIDs than the
MAX_RMID value. That would only happen if some additional monitoring
events were enumerated in CPUID leaf 0xF, subleaf 2 (or greater).
That hasn't happened so far. All the possible enumeration bits for such
subleafs in CPUID(0xF0,0x).EDX are currently listed as "Reserved".

> It looks to me that moving monitoring enumeration done in resctrl_cpu_detect() into resctrl proper
> where the RMID range checks can be centralized on features gated by rdt_cpu_has() would be simpler and
> accurate?

Agreed. I'll cook up a patch to do this. I.e.

1) Remove resctrl_cpu_detect() (functionality -> get_rdt_mon_resources()
2) Remove the x86_cache_* fields from struct x86_cpu (replace with variables within resctrl)
3) Move call to intel_rdt_mbm_apply_quirk() to get_rdt_mon_resources()

> > -	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
> > -	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
> > -	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL) ||
> > -	    cpu_has(c, X86_FEATURE_ABMC)) {
> > +	if (cpu_has(c, X86_FEATURE_CQM_LLC) || cpu_has(c, X86_FEATURE_ABMC)) {
> >  		u32 eax, ebx, ecx, edx;
> >  
> >  		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
> 
> Reinette

-Tony
