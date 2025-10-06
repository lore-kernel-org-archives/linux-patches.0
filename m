Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294F2367AC
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759769652; cv=fail; b=hZbLCneTWH4yrAqO0izTagAbziu+/tQiEkdx2Fcxdnt/LQY9p81KF4kej/t1ZnolLj5jFTxH8a3YSUVAWboeTZ/lwDM6FEiO5y8CP7KtW9LDV25ZpI8fcLLf/KRXbWMmWxuPrfVChzc//SYXG/fDTDX4YlKYlHva5MCqt8U0wJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759769652; c=relaxed/simple;
	bh=TOLm5Jq6lqpfPHndkpi0pSIEe+eLB05gvPYIV7Njzqc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bB84sOCDrvJ8rFmOx/raky4xX2MO8E+kW2LTLjRU2kZYN2PY7pAyK/yexu8LhMBI2PIryVFRppCbC/MADPXer+f7U8XmZ5q538KUqsnSAkaEkAT7+qRkDP6vKscjBUPBd+4V5wN8QWtENZIv4xQTbs6gJA94eBaX7OxSjrHxBio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nd0+YdMI; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nd0+YdMI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759769651; x=1791305651;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TOLm5Jq6lqpfPHndkpi0pSIEe+eLB05gvPYIV7Njzqc=;
  b=Nd0+YdMIPVEj1mmaM5jf4QpiQdRGuTWuwQ/KDncRBcEhrqXHqFpi1Pwu
   63ZLqYPWaysa0UivvAG8IXd6sM5t8mBvx09kCoLjdH5NKOlj1PnSzZZOJ
   PsITvQzku/d8zIjCrZBQajh8fR0f4HTjlxbWApuuklnw4FHnBWQkSZJoc
   KoOD0C83jVkjGDXDabCPqHyZOZ4mbdJmp0gpwLgPpQVoaithqAn7zaCPI
   GtJXOcS+by4AnSi58kJVfYtqDy0SksMOlEcGDqrG3UayQOiosTUlDXFVl
   GuARnufultfOOOs9qWD1tUa+d1363lZ4P5dyBts0laDPcA94MYZ2Q5SEu
   A==;
X-CSE-ConnectionGUID: 8Qd0XMaGQfaSgaekYegBJA==
X-CSE-MsgGUID: e127zTlnSKiFk1496GKnsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="72200356"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="72200356"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:54:10 -0700
X-CSE-ConnectionGUID: lGjfCVsYS/itZTOX+X6DfQ==
X-CSE-MsgGUID: PsMOUOmQT1aYqvEKU3wYLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="184205448"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:54:11 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 09:54:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 09:54:09 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.56) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 09:54:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrmUBvjfkU1cI5rTV3sAZZ2wHBzqGGw/aSGx6xXbip1NnC9in1g3bsNbUKtWp61LSJPnuvBP0+OPF+P/orNlxwwuIJzA8KtxXMnIPUgJDIdW2pPGNdWigO0ndYfFPhX5S4hvdplp+aMdWPC402CTa0XM85rS1lq3CKZH2zppFhbWYRYdaMDYVvfbu4ZbG9Bgw1N87SlNKqyXDWTZzE1ACdkyxugcajWNmCmkVVEx8ooPLcOTuHDWl2RdwolygyEqB6C9ffWQDzM/dO2nEDTTxTXLFksgSr7E6OODXt5psV82KiK9CiTlh5PD3E2zmz1VgdJpa2UdJuBuCgV1f5UaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INLbt8W/BlMU/VhD4JKatyATCKxXwpaVWuXultZi2Aw=;
 b=bTkiiJHReJRDd3QckeKuJhN4VaWyzGKokR7fMvUiF1Qs5rlGG/tpNeFLnKnEDi9SF4DVDYAnmyuGv55IwsWieMNysXVogZBG3TaX+6iI2rvewp8hqUJZ13YRVm7jEOFUkxhh3Si39IqEuCRv8uXQsb+43WZQ8jtLlw9ZLx3X/7nu2HoUwmIhYkzRZcOhOEmvlCFbMVmq50piyZ+dxfQvZETio5ZR01Q3s/6SnMUlc1c15kK4VEniBX8WFjXVFJOKApj3TXXfPeT/n/dXuUJW9eqrqMf/nzVOVrKGkZpRYhC/rqeJi4UV6WLjMh5wzqweaTJrQKL2X7mH+/Ba+6DOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6082.namprd11.prod.outlook.com (2603:10b6:a03:48b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 16:54:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 16:54:01 +0000
Date: Mon, 6 Oct 2025 09:54:00 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 31/31] fs/resctrl: Some kerneldoc updates
Message-ID: <aOP0KPfZYd11XoTq@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-32-tony.luck@intel.com>
 <105e491a-475e-4d6a-a1cd-88d500d8fea4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <105e491a-475e-4d6a-a1cd-88d500d8fea4@intel.com>
X-ClientProxiedBy: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a9745b0-64c8-4750-5f7b-08de04f8f37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JeIJRyRGXRfIhbhwK99a3+bD0CUuZOfGDKiR6tr5lBOaPK0Mj7peOqz0kOm5?=
 =?us-ascii?Q?nM2Ha+WwVPww3tGLkcS1B6VZrfOI+aCAweMJZtYemDxP3lPfNuKfuky/WjOL?=
 =?us-ascii?Q?p7abcduaT5PMWKscmeSFNsTfFX/8p+h2b7WGSOb5dF4Tyt3fg5PfNxnJa8Yq?=
 =?us-ascii?Q?qEdTLyw6MniWNgSS5dItbSF462eNfPZgi0y0U+EHL6xww9WWhDzub/eAZlK1?=
 =?us-ascii?Q?CD8zRK4IdTHcZw4KlrFWA5snuzzHsWiUsXWoehxkGf2cnsHQVhSEePIOm0X9?=
 =?us-ascii?Q?gDm2WkmUDQ18W7MrwcEPF3ETXd9Wf2qbSqcMKPa0CJlCrbBxEe8NC9EoOguJ?=
 =?us-ascii?Q?K01t21TpTpCAvHY2Jp68oKbo/pY8lQ6g/fpLxO/sKak74ipqQXHRZ3R/uZt6?=
 =?us-ascii?Q?GATSq7SJERyuQ6ITegE7dmvykVJPRDQyodBGao5NtZkY2ueHjTsj3Y2F7SWV?=
 =?us-ascii?Q?x0t0/izYD5IjSCGoEbIO8uIUM/7IpA6Bc1yaqMBHA7zHz3yiyku08jWgfXMX?=
 =?us-ascii?Q?Yz+DGBvuDQUoRRXvjBEybCtV2/D+El202rx6myiuoH89wAEzo82rBBOhyI/Z?=
 =?us-ascii?Q?RSPc590ik6VGv4X7W63tS9h14F/G0qksbKjSTOxFTw4DrjSA6Sn+sZAM4FQ7?=
 =?us-ascii?Q?srNp+iWf9mx/+F0Bo9+9LvnY47XgwTVgnQyzoDuteDA/AIO4kxt5lVInBzR3?=
 =?us-ascii?Q?mI9Hitkll+yq86L+gJsw26p0+cJAM/xjRAgsVo3OGjWArf3y4cZggaqYf2Sc?=
 =?us-ascii?Q?EkyoSBqiTl3ciWXPDkm/yfMfSgpEgm0xzQaqGNrKVpTJ2/A4K2EJ4Xu4RotD?=
 =?us-ascii?Q?ILvZepdtt042D+AlAm9EVkT50lvRgzZcyuvhBLjbbS9mTNMHZ6d5udA/c9xl?=
 =?us-ascii?Q?2or2AJV1mNKqUdw4QU6AOeuTj1pctRlDzl6PiAeV2GMD/NW9xGM+PiiHr8AC?=
 =?us-ascii?Q?EFVPSOck5FOTDSV0iHCM2/eFI06a51FqRTrAQOB+Eatoht1OSoFgEK3HawCl?=
 =?us-ascii?Q?jWgL9hwj9+J+rFgdDkFOpatt/wG2BHM2ydD91RJMmhbVjcj/PBy+h/yf/Afu?=
 =?us-ascii?Q?oAlA4gZBdhLE7nAmD8APoj8lLkDtK76HfIOWPnsnReWuGx7nXd0l0eUWYZ5G?=
 =?us-ascii?Q?RVR7CVPmQcLIkdg6re8asFSDQt9youmMJ5MtNFna9vVujlPOosgDiIHSXn79?=
 =?us-ascii?Q?iCnNOa9yl3Eyk5Tl1g/QesI982vlVobU4dFvtpd5pZb8N5QJDTEPKMAyci9x?=
 =?us-ascii?Q?tFnnVFAkf89n3DntzrOxpz778TGFHAoDxA+wDtP4v4rzEU0g+EP5ozPdc09H?=
 =?us-ascii?Q?sMG5voKObb6BT38TgjfF3LpyNtsUly58nyhQTZvINU+XxKXnQgZ7ykLQVFA3?=
 =?us-ascii?Q?twQp6cOYFq/bGdzlFLcSS3xFoSfa7wqq2Twq2n5q/aFeGjJ3Qp4mdP/vXHtv?=
 =?us-ascii?Q?DZTKpKefNQKOD2mXxjaH37R6Gpsl/KMA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q10iM4ZbnNAPA99YT0ZDDad3Fp0BqYI9Eu328QG0yY7psDgwZknwjRFHrNHW?=
 =?us-ascii?Q?Km3OxrmMpurOUOFoajwOm83SrHdZDGM/gCA7TTADta3I9AFBiYGz06NhGkMn?=
 =?us-ascii?Q?we+NTxZAa/zohXadCcJzWVw5BxxKPjBDpMjp1ROgsdmPi73KUUm9DvwyI75B?=
 =?us-ascii?Q?GgJIS2YK/15t/sdA3GqXwFQSypABNNnj+MFI30YID3RGPS+JSjsY3JWUjkeA?=
 =?us-ascii?Q?uFBf7gZx+smrQiI1WOQ8AbAGYFludN73CjwWUdV5sJ/NjbPBCWKu/1xk/2yk?=
 =?us-ascii?Q?1mOpRTQ24mr6CdBSeKUV53bPNt9qGquxPwuAWCxso2Pn3dsJrsEQs+TFfZZM?=
 =?us-ascii?Q?Kb7nh/vXnBzGrdYKrLfDweVXOnHRFytnSH9o7g5cFVEZ6S8dElfkYdF2PlBQ?=
 =?us-ascii?Q?B7m8A8tN0OUIr6yCOlwy2EA/5x57tNKtpXJxZrn/JL7ojekIci8dxP6/XrTb?=
 =?us-ascii?Q?C8mhRcuKiLxMSeb/nCrgCB4X6POYw2aHhQ2POiuL+W1Ldl+A7yuFa7stXahz?=
 =?us-ascii?Q?FHQXxKZ0BBpB0M2UO9HMoHUKs/R0b5Z1FBIcNvJjokr2J7nR/O09TfE9+ElI?=
 =?us-ascii?Q?okeKMQkPiLhiR5XCxl5WFwtjFyjni04mnG76uYRMk98klmNSpdh0hlCEbx/W?=
 =?us-ascii?Q?7dJYCv5qMqtaUTzToQMXtn2LdYofwoOaZqrZODPcYHhsN+bowkF8880VALif?=
 =?us-ascii?Q?fAiC9jymOpg/e/2gLUK6lHhwPoqnzf/Ulf2mrUHH9AqbvOm6bALpyO2CK+1F?=
 =?us-ascii?Q?bA0qJ3E3swkM6Zb+XypT5eBAVC2ENjBBOkVIwcy1zblgkv2bd+RoYT3jqK+2?=
 =?us-ascii?Q?P8RLQSqrztv0OvKMihBC4UFJtiJoX8Ju9pn5zKV/oxc8eIzurYZUxlgj66Mo?=
 =?us-ascii?Q?aQ09jrWeCRtdkk1ljjpeIdI0BnSG3Be33as8yIEfIwbedj6kc85Ywt1C/A6K?=
 =?us-ascii?Q?svvseXOSt3r5qWC5rHQXklhtFlMuSl3kHd+gvDsJemzn/GWxeT+CozS6LVvx?=
 =?us-ascii?Q?FolK7EXscrep/2vpCa7Vm+PSZRPqKAttqXUwJ09ECFl6xMIN7GImxXErAgLe?=
 =?us-ascii?Q?b/KHbFjcEwYfpNDVhkChaJTOVKsKe1Bw2Tw2u7CUz4hfsenO4q8JTlZWx8Tl?=
 =?us-ascii?Q?cd51sMg10Z+H2OuXjMQHMBavfzaXKbs5SIy+cxTSyuourzpEruis8pNzOzrE?=
 =?us-ascii?Q?ULiD/GwJ2TReT0xLqwG41aT0ohf7gZb3rqbj59zsl0MdRMsljCdz9Egdd1E1?=
 =?us-ascii?Q?cdhblybxTyNPZ2AhjNVgMWtaHLZhsaAEb28xvum8PWg/7kd/2PbOAXS0U664?=
 =?us-ascii?Q?4Os1h31Rt2044ytF+NOIaKTL0g20tMZuP1jN9yYdUjl6DswfERM4wyW47+go?=
 =?us-ascii?Q?F9AGgHEcUxyPVGyLIOZDCHRhPJXaTBYQW/iVWXxh/1SrDS3FuBa6pkChzlx0?=
 =?us-ascii?Q?yySNOHeK+tm6GsRP/N5AOSyTsIT8iDm3o9ZauxWMnvJ75VKkfyR7JAwtsAfN?=
 =?us-ascii?Q?MRu4cWbXjbQWIbb5R7cU0OvVkXqUlbiFx1ZkrGzJ4hhsbmziXPRhQPDaI/ZI?=
 =?us-ascii?Q?s2/pILDGSKdTpBQ0hxfV9GO6esJboWL6v7/0y+b5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9745b0-64c8-4750-5f7b-08de04f8f37d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 16:54:01.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVnW2eye9mgpzzXVNYtwBLrZb8ic6wii//Ogu8K06WTRdBFRodBjOqxAFul8gmTvzz8+lax3LWo4HcW2m5COIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6082
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 05:26:45PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/25 1:03 PM, Tony Luck wrote:
> > resctrl event monitoring on Sub-NUMA Cluster (SNC) systems sums the
> > counts for events across all nodes sharing an L3 cache.
> > 
> > Update the kerneldoc for rmid_read::sum and the do_sum argument to
> > mon_get_kn_priv() to say these are only used on the RDT_RESOURCE_L3
> > resource.
> 
> This is clear from the patch. Why is this needed as part of
> telemetry event enabling? Perhaps this can be combined with the
> unrelated SNC warnings found in "x86/resctrl: Handle domain creation/deletion
> for RDT_RESOURCE_PERF_PKG" to be a patch dedicated to addressing SNC
> topics related to telemetry events? 

I will add an SNC cleanup patch to the series and make these changes there.
> 
> > 
> > Add Return: value description for l3_mon_domain_mbm_alloc(),
> > resctrl_l3_mon_resource_init(), and domain_setup_l3_mon_state()
> 
> Appreciate the cleanups but please have series start with cleanups instead of end.

Can I bundle these cleanups with patch 8 that renames these functions?

> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> Reinette
