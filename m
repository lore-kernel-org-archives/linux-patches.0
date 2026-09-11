Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2EC1DFF0
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789085216; cv=fail; b=LDbIKSByWApNxCgqDKKNlfdcYg6D5P5gyd8MnqXeYNrN8hQCOaUeAcDu32EwkFj1NYayX4Wt7ON/I7+ivLVhlhQUtHvfKw3Swxx3A1qk+XodLBiGnDwksjTwS3x7WpcAZYa6cV2a0CUkLcqrIN+X1nQ+trBHMu5ybV0E0Uzlg0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789085216; c=relaxed/simple;
	bh=nUS88ZUgyyXs2gtmm98ruofgoZ05LSLRNzophkNdWkM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QrQoSladX3CvMOtzLW6MuQ5Bl3+gU5T7YQj6ZVcnMK2FYymtJaJSVGBisCPb8VpTBfDChfVj1Jwp0NNmUaCIv/tPqt/6kbe7xGkHdtMqZk0va54Z6NYKYbkoF7g6wE47Kntwtc/Cr9xU2Nebl0KHRph+le3G54bCUtYSRGxI6xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iI4/q7a+; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iI4/q7a+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789085213; x=1820621213;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nUS88ZUgyyXs2gtmm98ruofgoZ05LSLRNzophkNdWkM=;
  b=iI4/q7a+pdL5xk1oaQRMGQUpOWKqeuh3pvr26H3gx8ior0Ggeb7s6Tq/
   +UEeY76SPVYvVeEiUSqZYRm6jdmDS3oB3aLkd77jY6xseRXFNMrE4pJCf
   IfAEhT5wVBTKm3qdffpv0XGQs5XvDeL3rtTvsnnDBzMoHlo7YmE/VdpiG
   4vtJYHasQKbbOIisqLRXQ4rqkfVlLITQHKwEuzlwIicwTGvQK6iRZ93/Q
   TrXZOpo/kmxW0J/RAW8bQa0in404bCOMB8cUjgqCEA/wODsZmvaX/WdFD
   mwseVSqivyfWd+hfttB22Vrp+jEknzfmovkOoPriW92KhjB1tKJslMNK1
   w==;
X-CSE-ConnectionGUID: yCBGdxRdQyW22lLMHzoZXA==
X-CSE-MsgGUID: yJqJRsPXRU+AnEPiEwRVBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="115090142"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="115090142"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 17:06:52 -0700
X-CSE-ConnectionGUID: 544iheczTeywHtTg33Efgw==
X-CSE-MsgGUID: 9tR4Cl8MSNSV6goiJOCY1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="101695"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 17:06:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 17:06:51 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 10 Sep 2026 17:06:51 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 17:06:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFFvDfLZBhkVB4GXyUY1xVeZoiWYlEWy9bzDJ55bl1VRp4pMmYwLAh4ClNoFD9164mqii2sH9wv2u5UIqpu+mH010j7v37LaX99ggk+9RZjayGfsWgnGf4GAw6zQm9Y2icjbkaHVkSMYrQ73YWSJlYTNf6GVE1jZb48gP7HRBvGsGc9oiTWNw+WT/8WwGbuIeglT/6S83o8wHC9DxoCqf6O8sTSmAFZIz/Zp1mvO923fuqK2+QH/yyzfJqcz/yXXOy+tvluGoqM6jlQm2YvwqkTJSMcg5ElW6rgKLBHZCFniiqftEmKND1fZpAFOXV+rn4uoWemoOGHL3O+sO4tVUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5RmsjYE63Rz4EUkV1JOPh8nUue8qbyYKkDssVbb0Glo=;
 b=EPpsYVWbr9S15dxJ3pU5DQeToricOdZS5/RMYOGUMHNN8mM3tYLzF4R6uHUG2IcjT8MU+6tW72gzJjgah3apmUGGDBN1ENJlMOc+9F+4iOUAsw9OS8Y+qbQq9lh6vGT7HfDgjdOe78V2PghBQOwt0XeQdCQPF3P37AkVPUcaVP8dAgWiY/1PkF/ylmnE2ankAIYKDUm5qe+gsfrhhKRh4XHWgiNUsJdiqY83eGGadS2cBFTXbZCFdXG8gOqIO/ZmCugd0eROYj/LH9ZKV5cCpLM1Ef/XSyIEQJg7X/1zL/+TmR+GXb8nkyGDtzST8TvhZKzG/COS9CrKNIJP0uvbdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7497.namprd11.prod.outlook.com (2603:10b6:510:270::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 00:06:47 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0382.014; Fri, 11 Sep 2026
 00:06:46 +0000
Date: Thu, 10 Sep 2026 17:06:44 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 01/23] x86/resctrl: Give better names to X86_FEATURE
 flags for monitoring
Message-ID: <aqNGFA6JtddxEn54@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-2-tony.luck@intel.com>
 <2a814a14-2717-4363-838a-6585557baf1a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2a814a14-2717-4363-838a-6585557baf1a@intel.com>
X-ClientProxiedBy: SJ0PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 0385e904-a67b-4c44-49e7-08df0f9891aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|10067099003|6133799003|3023799007|22082099003|18002099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: UacNwn2Lq9Lsl4CyE6TeHAts+CkqRzH/S6+P2UXpRJ1oPeXxxylu8pOyskQUlGq8s3/12ypSyM+xGZJ8hpWAK1rF8Dez6G7nszLEekN6nyabedo/Tx7Eb0X54wqtGk6DlvlOxTGzyC1lFo+BYxxycB1kJ5golQcZOdn1Ty9opCFiD7mleRzCh7XKIgFHCimmVK2uwKDfe09oX6kSn5numbDCHNrS6TxuPEJe9Qw9UApTNcC4HX+b0LV46oiL6fa6hYTdB5yF+Rj7yFxUMmZ8kX2SJju6UE5ntyPYcoqqqprxK8gzQYTnkRW4TGavva6boqoRuz6nOnBeitfl2zPcwpT3pzlmfNingPjUELXTWuB2UggvDt3Zp9Dp8A44qqMEsR4hGrj/tBXnKy0S8ILZ1KNMXKK2I03TLUOme1mzpND0+bK0fzOnpjtljUvQrg0vJkpP8j3KaLy1ftITGSi5GAy3tJz2z2fRJ3dZPowtiKQYM+RUcZfIjH6WBP85bTRBup1AoBJu4eaaoWmQot1MMqqfjQdeyH+mMPzouVOYSLZq20oD3/BZkhgheiJ+rbZraY9jtAwzqCK+GUi06rWZi5VpYyvl7kYaaxmeTRhCRMch5LJ1hLUSNZH3qmF9GxhJPlCHuTwY4keJP+RjWABOxu3lfvk2nzfjsP5TNgBy0hc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rGvGd5xBb3J0YX73j95p6MbUV9fJLdU3UF3/B+u6y129dcNmJIZpQU4kv9qR?=
 =?us-ascii?Q?kIpwKOWQxOraVuLnjaL6fycVseb8eNL791Qxo9ynfj/NMRes39bVR8MAe6sS?=
 =?us-ascii?Q?7z4an5IUtz3OXkUSoiNddhNlcoXsID0AKX60OWLQdNxHcVgr/iwhbDj2YQiT?=
 =?us-ascii?Q?UaC+BJfu1B+t50YKDbzihl3biR52lz81cDzsjNghu/DvRYR9i4MPAgqzHp4P?=
 =?us-ascii?Q?eZbsIjhUz3cKGggpT0LCMsV3rv1ie//06xAMr2iMmc2oAQUaY2fN32wqFZt4?=
 =?us-ascii?Q?C5lzgRRUoH+TzfjA2PkAF7VcFvVOiSbC0e7iClLUwoA8ON0jFmX5w1iYyXgu?=
 =?us-ascii?Q?VGg1MWqjo0ezlJgrPPiUEtu6thYG1uw+SczECrUNNtkmkcIiXIG1N3XvC4oj?=
 =?us-ascii?Q?GXp7mkQotBppG5NYcC8EIrYEtlPJb6Sd5kXGEO+molhG0zYl5BsM72SVhK08?=
 =?us-ascii?Q?lN/Su5aVfPuwKGMIL696sqVkBHjHjpDddzrIFMejjO/tXWQuNIvHv/HKB8WO?=
 =?us-ascii?Q?yPDWVb0ZCYsDQPRa5Q0t+9o+yO4FbLMjDaK0oNXraR7k0vokfVnj0vPfrdr1?=
 =?us-ascii?Q?VUViJX5qmPhDUoir4/J0jSE4fJiJedYh5St/mDXznCVMxzbxjMcZqlzNmL0a?=
 =?us-ascii?Q?simfNvvINAW8lQVzUcKB5vSV229jBzOjosQWr1Nh9DANtZnYPRWLXFWjy0os?=
 =?us-ascii?Q?9thjycmrDBGsz/bmKp7unIA6yH29JEWwZsDJHmaJaLI1m0f4a2Vjy8QZJSy/?=
 =?us-ascii?Q?JWTHlX8hzmmaTFRxVwT9P4bd/mbLRWvO1xd4p3cDfkSxdGb0lK0jKC3jQQNB?=
 =?us-ascii?Q?hqiafVImnmSB//ZSeb/9OPXl6DMOAzGm5R8u5aVoHWzJVGZtOdaLNAVztklx?=
 =?us-ascii?Q?zbu/jwpxTZRrXOFeg8297AA7kNtvLlhJILI93nsaJmNvTKAoDQEZOHpFivFR?=
 =?us-ascii?Q?N0x3AkZmWjjFHnVXACnvDWxNQ799F+Ms4PAZKT6Vcf40lTfpsEBj7FacoCSl?=
 =?us-ascii?Q?uKdm9Cxs9FrLyTGEJZGNK31jcFnT4e1ZBSP4aJHhy50p5OENw9ga6e1OTdCd?=
 =?us-ascii?Q?D8MNYDjvy/IEpxuCvabuIzVbdJ42XSTB4XfeqbCL04erlWyHlFmCkXGdbCj0?=
 =?us-ascii?Q?pN6AftYlePTWai2U1HEMDSkPgBJlherEk+QBBG3YdSliVe+gw9eJuWNJfhMF?=
 =?us-ascii?Q?u1BRoEgxtHWWLHIPd/1AzbwUjIeRqav+/6g/XPkcW288uYyiUOpjZAvUcilx?=
 =?us-ascii?Q?SMjrGoekMCPX5jnka3vGbTlEI8KF5TwfNsIMAo6a2ovePgCdh9QiycJirbYg?=
 =?us-ascii?Q?mYkaaFd8OK7J0lNOtM3jym39OY0TID7gdRcXuPN+O1NWG8THAWCsOM+BOmlT?=
 =?us-ascii?Q?qjbmSVRqDiUq3PuPf+FnLJAI5r++q+0zGT0WmXlw/jNAIu/Ha/FsBwWEEYGu?=
 =?us-ascii?Q?2G+vTMl3KcM8nY6IlNCjPo1Zi+m2r8cSloQBA7lB+v9C9KGJYlYJvQNNK7DO?=
 =?us-ascii?Q?z/JQc05GskrZEDobo8X2oiJVu2tvfMXLM4VgNwDvHs1U3MIcobq3WdmrUll9?=
 =?us-ascii?Q?4zxp5KOvJ9LixXCGiXAx6t2BKRcwCxQQk2HmqKjqmz6/4raGqgq9+h302Znq?=
 =?us-ascii?Q?R+Ruwi2lI/jBUijq95+3UWYLogH32PaBDnLFgzv082ZTvCpJcV3vxD91Sdr7?=
 =?us-ascii?Q?4XnA/xQZuF68TsSUhSTZO63QajFyEueKbmSqMRhOFotyjkskMad3KZyG7Svc?=
 =?us-ascii?Q?4U4lZkwQaQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: rKZGQONYC5847Hsc470+iudvCQMGuuvfvCLbDD71Fk08IIgpBUDQ0EoDQt4R0UEpDefC2IVaqJpWMV0Zo841JvxvtYQbmLS5shl2RbtTVekJQNPxWfzg7DKb1VNXGeahdblvOZbqsRm9kFbGWlh3gFRv57sN4Cfk+N2smLA0gwbcJNmfVRGYga74EbFJOYEzwGqXxToRBW5miIIzVKFRnOSaZ61UCeuptOkLMdtqgGW4X68VziwnAc5UnnyVGjBF1EIQoSDENWJWDo7YZ/zAV/tL2CQuxgQckp3VYztCki2sGbakhrVIGNrDzCpGGrzZEMk5oM5qh2rsb7vZr6HhMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0385e904-a67b-4c44-49e7-08df0f9891aa
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 00:06:46.6142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKPl1ZburGsl0e/5XE2mCsu4wrh3LCVE4LkFfSqkojYbYZv2o5NBxP0VJI66TWKpGVhCcQK7PNqM4QMPSMdhGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7497
X-OriginatorOrg: intel.com

On Wed, Sep 09, 2026 at 08:48:01PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> Please switch the subject prefix to "x86/cpufeatures:" to highlight the
> subsystem changed. Considering that, the short description could mention
> resctrl instead, for example:
> 	x86/cpufeatures: Give better names to flags used by resctrl
> 
> Although, I do have a question about one rename and depending on that
> outcome the subject could be made more specific.
> 
> On 8/31/26 10:43 AM, Tony Luck wrote:
> > The feature flags for enumeration of Resource Director Technology (RDT)
> > capabilities were chosen when the only feature was LLC cache occupancy
> > monitoring and they were given names using the abbreviation CQM for
> > Cache Quality of Service Monitoring.
> > 
> > Additional monitoring features have been added to CPUs and the names
> > are now more likely to confuse than inform the purpose of these flags.
> > 
> > Rename X86_FEATURE_CQM to X86_FEATURE_RDT_M (to match the Intel Software
> > Developer's Manual, and for symmetry with X86_FEATURE_RDT_A).
> > 
> > Rename X86_FEATURE_CQM_LLC to X86_FEATURE_L3_MON since it enumerates
> > that some L3 monitoring features may be present.
> 
> Considering LLC as synonym for L3 it is not obvious why this rename is needed
> (more below). 

I'm concerned about the "CQM" string in the name. This stands for "Cache
QoS Monitoring" according to the original commit that added it:

 cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")

This made perfect sense when the only feature was LLC cache occupancy.
That's very clearly a useful metric for anyone interested in cache
quality of service.

But the next two monitoring features added to CPUID leaf 0xF subleaf 0x1
were memory bandwidth monitoring of local & total traffic. These are
only peripherally connected to cache quality of service.

I realize that this argument is somewhat undercut by the Linux naming of
those features with CQM substrings:

#define X86_FEATURE_CQM_MBM_TOTAL       (11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
#define X86_FEATURE_CQM_MBM_LOCAL       (11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */

But those seem wrong too.

> > 
> > Add missing dependency to cpuid_deps[].
> 
> nit: dependency -> dependencies
> 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index f70ee74b5f92..6a7f0adb123e 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> 
> ...
> 
> > @@ -285,7 +285,7 @@
> >   *
> >   * Reuse free bits when adding new feature flags!
> >   */
> > -#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
> > +#define X86_FEATURE_L3_MON		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
> 
> The original name matched the description and since the description needed no changing it
> is not clear why the feature name needed to change? I do see some redundancy in the name with
> "LLC" as well "cache" making an appearance, but none of that is inaccurate, is it? The changelog
> claims that the name confuses the purpose. How does X86_FEATURE_CQM_LLC confuse the purpose of
> the flag?

See above ... 
> 
> >  #define X86_FEATURE_CQM_OCCUP_LLC	(11*32+ 1) /* "cqm_occup_llc" LLC occupancy monitoring */
> >  #define X86_FEATURE_CQM_MBM_TOTAL	(11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
> >  #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */
> Reinette
> 

-Tony
