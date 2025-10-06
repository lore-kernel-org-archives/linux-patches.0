Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B032641C6
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774784; cv=fail; b=Tyn9r8OLIgeOv+XNM9BWogYuRhHQJgiOZmiEnL0cnHR8drLGhuv5bPFzoIOTyzQl759DXpoXao0L8xXudOQn1XAL5g4/sw5mz26feko2gjQZfa/+ChxRvpYGeNBjzOIpQ4gMbcW39klyydbS1ArOWyROApcbrFI2jkKDaW/1XZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774784; c=relaxed/simple;
	bh=C2caX8fQ9y/PnKREGUWmL5LlfPjmhRMvLwLoHFtWBmg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SsQj2GhyaJTXiHrLed8uFMUv5FZ2j5EGh+xRg2o+7hj9FETiCxJMyoljLAtAYQzwzLd2ul+u1twW76v1BzhscjpNXLFHyzzar6d7glOXoyHpedld/hk8UOt1dp63HpOV6SKbBylVJ6/aJXhtrrLtR0LL/7SFkF/gohU6ADoyMhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jCLVv/JW; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jCLVv/JW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759774783; x=1791310783;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C2caX8fQ9y/PnKREGUWmL5LlfPjmhRMvLwLoHFtWBmg=;
  b=jCLVv/JWMyu99Uw8I0ZkO8CKlTYz4SYnsrbLaGtHbbMX6A/T/52ySt0+
   sfzK8WYBGlglx3Yp0dqosVxEUylhIep55w4C+jRn/JT2OqP97bKrKeeQa
   IlnUrI2UCHW/5e2Y50U27nAOMeLY/xAgkmqffSbfZ4t1pOJht0oc4pNeI
   LuZS4CIpAgtUb8zdAmSV3pPL3og3+JgYlgSVJ4WoJEOfAApXw+YJv4yMp
   Ru4d+W5Ac+Yl4l2IipY8r5Tbha+UkZRvlH0Ak7OaVjqeZpUIVGaDf9ch3
   Nw2vH1iB20e6e1AbqC3m5lYVroN28vgMGv7PREL4Sm0FptB9cIFFL7Cnd
   w==;
X-CSE-ConnectionGUID: 0+sYVssLTdaS1uHcDpzUAQ==
X-CSE-MsgGUID: FR71DUi8T72uHbWnGl9G9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="60991144"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="60991144"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 11:19:42 -0700
X-CSE-ConnectionGUID: GNZbOGHHTbauNUZZHHm8zg==
X-CSE-MsgGUID: TwpoIf0YSieKuZhJ+C9Cxw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 11:19:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 11:19:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 11:19:41 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 11:19:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gvLM33F8C90Xmq/avw4wy4q9Fn3U5p5B3/XQg/z09WAnZfIhxIOVh7uumSk3jRcyqhovwnNw8akQoOzUHYZN9vco6tVgx8vo1hFj32Pc5e+izY/uHRcbB6tuQTz3SN/RYHZvwN7aFDFY/OSHayhOYfONzy70oiYBN7bQ30FBLIOBRd0mUWstOURydobAr8CIT3YfdhMMHn61LqMivual4yx6U/xXRCOCJr9EoRmKbLOQyPKYDy4/w54BDrL78TE+BPTSgE+EBen5jZ3e01nheYtmd5Sd+XoBaFGTQ/KcMiCg+6uKn0/hOCZTQrMvnlubknPULrjkgZxUYO1JWYfxGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tj0JuwZ5c+3vhKBHp6R2j3ucVtLjzozaJRO9s8+l9jE=;
 b=PN0VH8gGwsZ43MSnqKKd/vaGdENwRRLIRIA57g2M7X0lYuE1MsKh9teaWUsW/HpO3KMrQFIl3ZVrawJegtmRAUcGPg7g3TKlTG1R++hnZkX5vAlWwrWIs/mtmQpdkjPt5AsH/ZqHv3CaMgKR8LpRPp34s95V+EA5eeXP7d9guCxBrQnJsQ8ZrJC5E95hqcD+/2ucNEeIhF/UBxR97sp+l+F7PSjT1tfCnu1n3CsW8Q361oE35Hy0y0xALm86jZBgdEMTe2WgxmThreOIWUC5XuHT5F4FCzbz94URBjYh12LzTK1Yo7ZNLtf51n2oULzp4coG2nXQfdhPMCBJeTWqGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5939.namprd11.prod.outlook.com (2603:10b6:a03:42e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 18:19:32 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 18:19:32 +0000
Date: Mon, 6 Oct 2025 11:19:29 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
Message-ID: <aOQIMQsgBOta0PRP@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
 <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
X-ClientProxiedBy: SJ0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::30) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: 3130dcc2-a448-42cc-a4dd-08de0504e55e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QM6Y2JI0FJz8heAONhGCaxC/Yy2lRmFJZUQP6rq+iG8CDsvIOrrVIGPuTBbW?=
 =?us-ascii?Q?WdA697YHv05F/AexqG7q552DlSptIjEehjaT6ra5efu9Th3DPZ4yn+jhFYBm?=
 =?us-ascii?Q?82dgJdJ6cDFvaqIqHZwRJdJ4RMexnwip9h+NWmQgaP/qH+fShWidMbiidL5A?=
 =?us-ascii?Q?yUs4XXGkTNlEUIBm8TlAC0ZTD8Q/Rfom/T4pRelrXtIgdsc3+P4RyeCMAtc3?=
 =?us-ascii?Q?ZDb+RE3/H54zLcyMUVBJaBE0POIWlnTc+wnLZXpPhKYPg6zgI3irmqNTjSOn?=
 =?us-ascii?Q?pt1ZLbDd7rbZ9e5UzGedXTOGM67JIg/LbTQD4VGENQ+QZatXdvWTeWDTwdQ4?=
 =?us-ascii?Q?75GY+6tsrwO2GU7s6RbRhXH451MP3luKTe0EVaUIRgqS2RvLFhuusUtYml8j?=
 =?us-ascii?Q?Dy/iiq5o83k8EJeyaP74A795K2KnvEkJRrTsUHWVbg6DNIjjkhDlrkQKOfkW?=
 =?us-ascii?Q?l+vDIorHTK8vlLcommgIP6NPS9vJ2ofKG1NMoCMQYMXkbwWF9vr6Ne3lRu8e?=
 =?us-ascii?Q?LuhbW/bXATtlq4Vjo0H3Ud+q878lZPAjLRumoaOTKSjgqKSyc7chNj6HmzJi?=
 =?us-ascii?Q?vap384D7BSpj5fv+bXksfMBsTy2J4r3szuqIf+pRXcAfi0DNRWfwdx4V+8nL?=
 =?us-ascii?Q?8dvocx4JOqZC+6T3p/y9ZaHLlCTBIcxVDaqwTSw6PBOb5rYfmyPnc4xNUViW?=
 =?us-ascii?Q?LsHnhwvqjTllcGt/EvQy+0BWwqwsLGyZ/atDLB3j3SFq9/0QAiguhKZi7QxK?=
 =?us-ascii?Q?gpoHS1BUed17HUVwBcjsoNTPyKUwQYvBkL1vbxC941LLb2rHDP+hUVwNSmam?=
 =?us-ascii?Q?SGTplU58+hlih0NhGpP6ptbNCWwkJaC6/B2k3CLtvBIKpu5vRF0hStZ1BndN?=
 =?us-ascii?Q?PrdH4/vYiKBfJ5uoAOPkfkcXPQmFDOWMr9thkrhmVy7FGepwNCDtDyOI2gay?=
 =?us-ascii?Q?3Ja8mPGz/d0ExHkWa6DL7CL1oGjRUTR8tgk9vABLT8LXwfXLbTM42ttCdUJd?=
 =?us-ascii?Q?5MBcKBj10YKQTySuUnXznh+6rck3z7Nsi6E+M17hFHsRAThN6pszKEmfbUbN?=
 =?us-ascii?Q?ULE3KULbZslVSXHwhr01SmKEeRxl6CzXxpWk+j8a61mVSDpsOHzcqBYyvHKM?=
 =?us-ascii?Q?usDRgp9GgMu1hLmvv3TBwgmjcH1H6zhh20CU+C2ml4/gdyJjxF6kXp4ewRON?=
 =?us-ascii?Q?kVJhdqUknvqIJN49eldw+NS/S8JhB/I9zcaotR95UzV4N4JBhcXCpnvAC59z?=
 =?us-ascii?Q?zPjzQbwsX9SkJDfimzvUh/ScjL0DsDc+08CnrVdAwItL47umQdEScrlHqe3O?=
 =?us-ascii?Q?YBQe8+rxfRuBadMKofCm2UwDIzUslHdSD6o1u9N7yaiKyEjubDzy2k49KPG6?=
 =?us-ascii?Q?/luKBSoCdzYnpWFsAZpjrGnNOzeP87dA3TttVUkhnWJrYwVYvRE0jTSmNvx8?=
 =?us-ascii?Q?bO3zHqmWnWep/d5Vc+QF5bKnzy6orXLnU7Geg6EePKehKaBS0bARiw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qdi5eFcR5MMj8ukObZwFyhLBWO4qN6vX4G2dwPOqfE/de6V0KPp4uNBEO94s?=
 =?us-ascii?Q?j9OeTTV4pFatG4pZZ7godxVQbvC480gPmQ/8AzvJJrtJklSsJI1558CqMwxS?=
 =?us-ascii?Q?QGKuWR/FlwIQy0JIxLUqGOH7oqU5Q8iguVFK++BwW56asKij+EIiZPtjLDuX?=
 =?us-ascii?Q?MmCSmLOpdx6y6jX1yoEk/9v7pPPvkrGBsfSBX5uZjAPKujOlU00O/JQ+YIA3?=
 =?us-ascii?Q?ZfFXz72eIFp1t0vyYoIp5V1YnKWpeSHbBSywBuxItO8dz3FuIPY2EQuUz8O2?=
 =?us-ascii?Q?FofoyD1lm0joe+accxyH6mDotHO85N92II5hAk5eO7i0Nndp+gS4ugb5GCeN?=
 =?us-ascii?Q?UUPMdhzXIUOTKOAiGZGZX5IA3fpCzxEYA3GT6CAFvSgbieIPwxDvCSsWzNbu?=
 =?us-ascii?Q?4xt6wOMcoHG+iDl0hRPzVdP8cbd6RLY1jB3quyjqRlNrcwOaHNjKcI4CFnuU?=
 =?us-ascii?Q?J89NVf98sUnMbsZmI8I7ThTgbqgZfPnpm5LBNHXoSIHCr4OPiv9GEkQNxiEH?=
 =?us-ascii?Q?/CFMaYpCMrQdQtDlFXcqEEL2SSOJTpb0ZKw69cBURenvHnvjVm1x+kkk6tpT?=
 =?us-ascii?Q?ystyK4IfKbQdcFNXYKMsdBgI/fWXe94i8wEN0Teiq6oES926Nd/9Fsza+LfA?=
 =?us-ascii?Q?9Zzv+oCQ74KFa8azZrx8600ZjdJ+r0vBqdXL/UFLRm+HXZTSmO9+/Tj9PZCX?=
 =?us-ascii?Q?F6TFoxxbj6KYO56lSpUN1yw9Mde4yqb+v1Qs77jClVVRtIjQimCOlZmM3Y/A?=
 =?us-ascii?Q?+ML/VIaVDSVKeNXBUrqIfsQ5qy4/mJK8UdT9X/ZD2pLkPTltiLEKovFnqvwe?=
 =?us-ascii?Q?ItoHA9NCrEl0r6VKNKg4NnLOoiq4xwGKKYBOJsFaT2LKe+6VH01I7B+i9RBA?=
 =?us-ascii?Q?Tuef5rcN5DxsZJoWqCe4N0ykJhDSpuzmmBysFspO9si3qTXtt6La1UYfCf+3?=
 =?us-ascii?Q?0h7XAMDkdZh3JPT7AaCOYzCm+k5+mLe1VOXEfy4OsORg7fz6Ux/uDBOAXrlg?=
 =?us-ascii?Q?5mER0+y7aeoCZ6JK+esiMEW+AIhUkXB+LcHGQdkaKr00rCKwuWOaBwsqZMlf?=
 =?us-ascii?Q?72xeQqUDHksTIvI1t/YP3+DbWDaRCnmASymRetQ3tn1C0OoQIZ4hGUt7Whng?=
 =?us-ascii?Q?1WQNXLsobG6CIQcCxr1aJSb11iY/vbFDGWmJ86mY/VZF+LAh9qaHcFns9gqn?=
 =?us-ascii?Q?BOFc/zQTwtB59F6HwbS6UHuFHAnNspZ2bdy/DWWJkqUk38X009OATpDw/0eo?=
 =?us-ascii?Q?mEOXeg6AVx7bk+vxVaQM7oIQpScRu12NWxiHafOqBmMfDb6E7IaB1YyL+pPf?=
 =?us-ascii?Q?IfAgBuPl+Mbg3mRSsco/IrcrCMW6meDK7P6D2YOkqFNeloKQ9yCgPd4Nhj07?=
 =?us-ascii?Q?4M9HchvMtrJODYgiBGTzFhi6Jg8Jz3UxBUt8sFZPBXEIfUidTaHiBD4d9V2C?=
 =?us-ascii?Q?e6OV1OKZ3fevqh8YoXPUPIouc1uqN+uYE5R4ULCnSFMgsuvULKNF3WORUwQO?=
 =?us-ascii?Q?1/jH+LSewZ0xcIKie3aMxjcafdx+GGBSLgU55lIeyShnuBU46j55rdTtt3Zk?=
 =?us-ascii?Q?qiLAg7Chj9mnn4YjctCM3TfGuUwihiSXuvjgZCvt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3130dcc2-a448-42cc-a4dd-08de0504e55e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 18:19:32.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DA42qEzC4ZUsUP7d8ZVYSyjDs0BpAEguosXjsVo26v51glQzk5TD8UVPD6Ps45dIUfpn4W7BxrSyu2RrCUAw7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5939
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 04:35:11PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/25 1:03 PM, Tony Luck wrote:
> > Each CPU collects data for telemetry events that it sends to the nearest
> > telemetry event aggregator either when the value of IA32_PQR_ASSOC.RMID
> 
> Please note that one of the "Touchups" done during merge of [1] was to
> use full names for registers in descriptions. Considering this,
> "IA32_PQR_ASSOC.RMID" -> "MSR_IA32_PQR_ASSOC.RMID
> 
> (also please make same change in cover letter)

Will do.

> 
> > changes, or when a two millisecond timer expires.
> > 
> 
> ...
> 
> > +
> > +/**
> > + * struct event_group - All information about a group of telemetry events.
> > + * @pfg:		Points to the aggregated telemetry space information
> > + *			returned by the intel_pmt_get_regions_by_feature()
> > + *			call to the INTEL_PMT_TELEMETRY driver that contains
> > + *			data for all telemetry regions of a specific type.
> > + *			Valid if the system supports the event group.
> > + *			NULL otherwise.
> > + * @guid:		Unique number per XML description file.
> > + */
> > +struct event_group {
> > +	/* Data fields for additional structures to manage this group. */
> > +	struct pmt_feature_group	*pfg;
> > +
> > +	/* Remaining fields initialized from XML file. */
> > +	u32				guid;
> > +};
> 
> 
> ...
> 
> > +
> > +/*
> > + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> > + * pmt_feature_group for a specific feature. If there is one, the returned
> > + * structure has an array of telemetry_region structures. Each describes
> > + * one telemetry aggregator.
> > + * Try to use every telemetry aggregator with a known guid.
> 
> The guid is associated with struct event_group and every telemetry region has
> its own guid. It is not clear to me why the guid is not associated with pmt_feature_group.
> To me this implies that a pmt_feature_group my contain telemetry regions that have
> different guid.
> 
> This is not fully apparent in this patch but as this code evolves I do not think
> the scenario where telemetry regions have different supported (by resctrl) guid is handled
> by this enumeration.
> If I understand correctly, all telemetry regions of a given pmt_feature_group will be
> matched against a single supported guid at a time and all telemetry regions with that
> guid will be considered usable and any other considered unusable without further processing
> of that pmt_feature_group. If there are more than one matching guid supported by resctrl
> then only events of the first one will be enumerated?
> 
> > + */
> > +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> > +			    unsigned int num_evg)
> > +{
> > +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> > +	struct event_group **peg;
> > +	bool ret;
> > +
> > +	p = intel_pmt_get_regions_by_feature(feature);
> > +
> > +	if (IS_ERR_OR_NULL(p))
> > +		return false;
> > +
> > +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> > +		ret = enable_events(*peg, p);
> > +		if (ret) {
> > +			(*peg)->pfg = no_free_ptr(p);
> > +			return true;
> > +		}
> > +	}
> > +
> > +	return false;
> > +}

Perhaps David wants to cope with a future system that supports multiple
guids?

You are right that my code will not handle this. It will just enable
the first recognised guid and ignore any others.

How about this. Take an extra reference on any pmt_feature_group
structures that include a known guid (to keep the accounting right
when intel_aet_exit() is called). This simplifies the function so
I don't need the __free() handler that confuses checkpatch.pl :-)


/*
 * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
 * pmt_feature_group for a specific feature. If there is one, the returned
 * structure has an array of telemetry_region structures, each element of
 * the array describes one telemetry aggregator.
 * A single pmt_feature_group may include multiple different guids.
 * Try to use every telemetry aggregator with a known guid.
 */
static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
			    unsigned int num_evg)
{
	struct pmt_feature_group *p = intel_pmt_get_regions_by_feature(feature);
	struct event_group **peg;
	bool ret = false;

	if (IS_ERR_OR_NULL(p))
		return false;

	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
		if (enable_events(*peg, p)) {
			kref_get(&p->kref);
			(*peg)->pfg = no_free_ptr(p);
			ret = true;
		}
	}
	intel_pmt_put_feature_group(p);

	return ret;
}

> Reinette
> 
> 
> [1] https://lore.kernel.org/all/175793566119.709179.8448328033383658699.tip-bot2@tip-bot2/
