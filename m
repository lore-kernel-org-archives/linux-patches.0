Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1244A230BEC
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 23:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761606022; cv=fail; b=R7xg6M5pwQdfs2iYs1S0WWhOM8lFM0Cr/gAQnRXm258+MSRbU/zkxnu3QXqU14gRg1qYhZahzgUQQVYyhcrnOOrsz2R2iuosfhY/+5jOAIlHOlur8UyEEMc0uA/GgIoKz/cSeH//6vT0N+gXKYAUpPwy0EU3i0EFHmfxhgJ40eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761606022; c=relaxed/simple;
	bh=ncVGLoKYuHHnEsL5F4ucxjlrLVTWHY8q2O1ZtEOLdBM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q0iqhyW1X0oODV0GKc3GU0Rn54HNsgcpHjdWPPlRwyZ9S7KdYPQ/2AnV+2NlAFM+ppxtzRHKgtAokvIgaM4vtr77ltmFVwgZDdU3Cya2iPBpYZmLnkG7mC5SZp42udhLSiVHX4h7pbCzuFcjAv1Sf6LWzwqBP+MYVZFftdXIFeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWM5MA6p; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWM5MA6p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761606021; x=1793142021;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ncVGLoKYuHHnEsL5F4ucxjlrLVTWHY8q2O1ZtEOLdBM=;
  b=ZWM5MA6pszEbH0drw1bcTUN6HFAAQQs963fTeHFqc5Ugsbk8dtTj9tmR
   33QpnhPeBtbf1bS/fK5pLUrgA4VmgTKo1nZ1ceFsn9a9iYLYidx2W5cym
   8UrYbc+nlZDiyJpWIR1oiCenw+FLRKLFHcoNU8YD+hsXGgJc/gdR0/4D0
   1K/Zop8um+KmfrcB4CgJ357sRIQHp/Hs4ttUt46OX6/yvx/fz2eL1B3gv
   NPFw07xU+chiOBjAZCbS8x7+F6yJBiN4jbs2DYU8ZheTxG41MgvqCl55R
   nqwyOevLBt61srJHT/4DdPRsg4bzw1o8Eshiuy2SdfadDV3OY7K0VYpH1
   w==;
X-CSE-ConnectionGUID: 9BgefTifQByPUyN4a+CbCg==
X-CSE-MsgGUID: m4FYdonURMqqTtGOblLNuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63735426"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="63735426"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:00:19 -0700
X-CSE-ConnectionGUID: s401km9fTpKgHWbtKoI8Tg==
X-CSE-MsgGUID: BT75bP1BQO2lcUFj3kv2ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="185937245"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:00:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 16:00:17 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 16:00:17 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.5) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 16:00:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpScnNpwcGwqo0wIc7c4CuFKh0Sa8PXxtXmGGW+Ofij/Jyi9GqS6P0wnRfU95ZEaqGK1qa8LrC3L11esNHnvf3TtUUJxt52/u6fZsCb7TZ1ZYpilsEHSueePebdphveXruoYx4pxMCQIZiSGJ7Oc+QoanBgoTTTdIMlZ40QH8sOvij8y+rzMSk0ObBHlrM8tjvodGFPQHYJZ/6aEoS1oU1z5HhPmlM+gKzIz65eKkA8mrTDaMoha81u0X791uMmFPP6HzmclnJ1+mBAA9bDADm4KDLaKF1YHa6ekHYkQP5vSXcRAUBcPp1+JVQOjllHGpNMZAKM0MT8FazD2ktOb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ICT05qp/Li4mGeeyn6fwGrPrDJFqK76+JGKP2LUfr0=;
 b=bClYZNJm75z5KQdM8c7vfdNjaJDoo5RZiLt9LwO8Lg7zFccy7FFoZEp4UTXO6IsPSIFI47BqgrGTKnTundPfwJrCjJ99VYCW4obiOf7U6lCmZzXU5M+xL1+UmGGkro8rsTlsqw0HjPkydJRFcggR+MzAa4d76oH8g3JAND4lbp+sJiB8W98PpM9DIuSmdsMyQzF93k+uXZyRfvzZveHhCE8etNP9TRPkrl3ngzxwOtbel2RAOrMjQll6xN90xt0Kn3wOmWBahrEkg1/5errPEucAt1b+QQMThp21S1bW68tuPRh6/1b9yGOBkx+yLL3Nup9PWMzIU4tLHaybPl65pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS4PPF178D5B043.namprd11.prod.outlook.com (2603:10b6:f:fc02::d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 23:00:11 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 23:00:11 +0000
Date: Mon, 27 Oct 2025 16:00:09 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
Message-ID: <aP_5eW_GHwXebeyq@agluck-desk3>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
 <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
X-ClientProxiedBy: SJ0PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:a03:338::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS4PPF178D5B043:EE_
X-MS-Office365-Filtering-Correlation-Id: 006f76db-0522-44cf-040c-08de15ac9516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?I0TY0KZ8EbVnSb+xag8ha0S7cuH54xWwOCiZ3beqIvpZE9WfzI+bzhU142Ax?=
 =?us-ascii?Q?4HDsNDhETF1qEg0C+5TQH1HrEiHGePETJPgkiEGV6SdGC7eAwNFBtxRdXOFd?=
 =?us-ascii?Q?wAMujVtUUmcZ/LAP5iNj3OsNVP+MZWYJ6cZzjHC44WUZ4YzvQL4eKSqzwPkf?=
 =?us-ascii?Q?Rz6NnIdDql0vcJJpVuTV2pE8oztqq3FAd64lBNAM0dbh+stlnkaxactUVK5K?=
 =?us-ascii?Q?SoA3zqLv4mkTER5mH4ffpFtCDuodW3TgsqjbMratcCln92F8xm4uH3PKzGel?=
 =?us-ascii?Q?rlQxeKHgjROYkGBEcScviHvKc+eMOadWYXorrGwgOgCsMgq5wFXuRzsRXht1?=
 =?us-ascii?Q?GATfYp4cqXV64TTAI3wdkQgbt3WPY6FJ2dvedWYNSXgQ69n9mXsn6mq8Ka/m?=
 =?us-ascii?Q?rrmuAjX6r4qZBTXuirneBKG2kUWUJ7XjZdB9UO9B1fsBu2rboXzMufvX2RqK?=
 =?us-ascii?Q?MZkCDvFU//bA/9DKSw0Ciz6/HKyImsKBRwXziHPVoddVZLtcbxiTb/4AO7iu?=
 =?us-ascii?Q?i4sCDn47tI84jvbb5iPViB5RQGlWHI2TlBZJjvGO7s+SKs8fRcfPaB5DjA0t?=
 =?us-ascii?Q?NiF8hWA62qdr2UEO4OKTENAjnKkNSSYEetqtWRfuRWB29Nh4kyct7GmKT3Yc?=
 =?us-ascii?Q?znLjymeb6NezLBf1aln5Ts5LMVFsbkaBjWZXPbR0l1+lnPHk04OSHbwQBEmO?=
 =?us-ascii?Q?JpMyJHSH7hsZ4GxxG+BGJjQXmkKRJMa9TFm4MZUFzx9Fp0eRzCyiUSfZXwYq?=
 =?us-ascii?Q?OVkph24HMFH5LozQXBZCyTDu/uLghNuRkWmB4+fdO2xzNbwogxPD9Zzd2e4k?=
 =?us-ascii?Q?gEQaa6sR80kgFHwkUe1ubCsnbodD6g+R6kn1aUgvvsZUf/JHU4Yu4QOnH4i2?=
 =?us-ascii?Q?B5Vu0PxG0YL/YKnGn4jWWhB84Qo5HMh7VOS271nCWYt7/oBgogWJJsxAgvkO?=
 =?us-ascii?Q?gtOgjdtdPLlAtXC+H+icX+OL7io6eUU+kv3mt8JymCU9FlbtbMroO1JXEv8X?=
 =?us-ascii?Q?/23SgGTGeBsBM8pVn5CGEh1/ecY42mtFdfJRREmxIoeQ2XohhsViUFtc1bxo?=
 =?us-ascii?Q?3xV3LHMrcpohKS7ZBnrkrlM4e9voHXOQ4AR8vFBW9eR8e4fohtW+sSOLjfFr?=
 =?us-ascii?Q?P3oMbpjeSkgJtNbqzoV6PCZt5VoOhuryBpt5SJ4X1/Ee9M8IWcWzFVSE1eDJ?=
 =?us-ascii?Q?PYTxoYOCnQK90HKIJrY8heQps0zkqnZXjRLk2fIr8qU0uxKDLpJcizG+JVza?=
 =?us-ascii?Q?JqhL5zJUUExqZiualZPLI9z70/zSju6fwsQixhmYYkV6fRSJagyWacBfeB8F?=
 =?us-ascii?Q?Pqf0ZfUTv9mYDSqghY9fFDL//lyzHB02qLIms1tKKcCE1YPxx4uKfODhOfCG?=
 =?us-ascii?Q?iitzoNEmBLzGqDDDB8ndBdwDzjlqf8pQgNB9AWt63rpO4ilJl1t0qKuRReMK?=
 =?us-ascii?Q?nq7S+t2+vmJyM/BlFCYJCaYCLsp0rxQ2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMKBKuERtDADAeYzcfLteIQsnxLxqHMiSVnFlrihWsj+595meQAr5AWlw2yC?=
 =?us-ascii?Q?LDFzYmynob94j+dUauOAW+r5IfR9WhMOwtb2w0Eq3K3U38SzyGukv6K39bpe?=
 =?us-ascii?Q?nA6HYwi0BYTD9By4UBNcEbdp8o1AgUcI99s6VYPlNNIpbZGfmRLHq90fWrA3?=
 =?us-ascii?Q?gFhU2ZQmV6Lgk2Lga19DH/8ha4bJoQ6MuTlSoY0ZFGgJCkPoSqPi633TKY1g?=
 =?us-ascii?Q?G+89bopmXviPtevvZhO1/z5cNS+ZKNdMztZ2uvPhQF6csqLXe5HUB3VqwJ06?=
 =?us-ascii?Q?nJXLZTP4zRUBRCjPiU+tGZ+mYChhStLnNHkBN5yc3d8CexBcwb6KaIzwb6Ny?=
 =?us-ascii?Q?cFXIKMNvz9dcJKjcL9QzLFwlqb2CnKBOwh6DfNF6mqhW6by2LHpYZCtU9KVH?=
 =?us-ascii?Q?I60A7Ja1GAhYJVccjnZo02+AJ3kJM83uaJNGVBdJ9Pn0IKCl2HPlZbWl6wCS?=
 =?us-ascii?Q?QWp4WCSCO/qmS8Izq2XFFCvJuUvngxCoeO6QSPMNtQGR8MwgsgvBXz33U6N3?=
 =?us-ascii?Q?A1O+aGkmFHGMQlMyBb3DJtnrJvE53b5yRhGDBWZjgS6K7OkXiW7yXkD1RxmD?=
 =?us-ascii?Q?SLIW2T03LicgHHmM+ZroheHQaaO7qz/HrMEd6GhANSc3kVA/qoWNJEuCcE9x?=
 =?us-ascii?Q?KD5otJpN5ZN1/OGWfJsFyZL23TuerjSPXA8bK7iOYks4ypr+adbI9r/QJyut?=
 =?us-ascii?Q?1dUDonuSv8UAWnSA0XD8/UeOxY1BauOIQcS059Kslur/d6QyUwTd1O8Fmxfc?=
 =?us-ascii?Q?5CEboInS/N/PT6tZKn0rcqk7Jq8FMOiaudloJI31A5IQslZc31vj2U2fAbRl?=
 =?us-ascii?Q?0As14ujYG3gYemP9s2SF5UxTikiRsz9ybW3aB4TE/lkrMWPaDEkLzsPRMIph?=
 =?us-ascii?Q?kJjfCfeIM2vFBJW78zuqpJ8OqNmX7ijkhcjqCVQ8KLbxlbSSWKo5Z08ejbZ+?=
 =?us-ascii?Q?5VteWk7rhGpWArxNa/qzH9ob1BTmfio91w/g1xYIBQTTOAmUOf1vHUqdKtxx?=
 =?us-ascii?Q?qmp9Gn3v0On5EmfoogF4nmSlhEGTZCdSBuuntOWPLzdsNL4MUXl2LP62b6US?=
 =?us-ascii?Q?YZZdu4PCf6oua73erKoMRZfrozuUy1Gy1Lui7x+NgqNvYHHMob0Eu1kYdV+f?=
 =?us-ascii?Q?2ZwF8dX7fRi5eWL8jbgqbeRBdpbMraTHaQTQOaUUUDIBT+yxU3hY6xTX5dp5?=
 =?us-ascii?Q?oVohNFfQJCsNuQvxyjLUBDLF1yyNmaLq02h1IdGvxjHWFlp09vxoiFd5DmFg?=
 =?us-ascii?Q?hqZ9gdO0FUs2xujSUd37sTprWx/vG2JhaJsFcprLbHeAmu//l4meXl6PVedv?=
 =?us-ascii?Q?mUhZrn0PVvMm8T+TQ1991DVDwcXnbibbBElMZdksr2Y4mb7U1rQJjivs72Ae?=
 =?us-ascii?Q?VV5+zGB1enMjZ7HUWWMbMfurSgY2cJpCzvvVluIKt2edbNR42OSLsvYnNokl?=
 =?us-ascii?Q?ZLq6vqAQRil6MYMuqoQrCLNZG2YHUW4vwsRf2EyZD13G89M1wujhEz1Dpdcb?=
 =?us-ascii?Q?pKJe3K0/QwH0zc3apgXOAtY3NbP8WLSJYHAGc4VRpLX6ObspXbf2c1BETUbe?=
 =?us-ascii?Q?uUiRHp+YBpKn7/B5Whc4/EZd4CIUx4c627gZBihP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 006f76db-0522-44cf-040c-08de15ac9516
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 23:00:11.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IM4h5JczQeih7CZOdOSi5mZGuYLjQoo68uziLFRbWi6V2VNjSLtWd6fm9pGPlK9z7qaTXf85HUrkynbgVJBRnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF178D5B043
X-OriginatorOrg: intel.com

On Thu, Oct 23, 2025 at 10:45:06AM -0700, Reinette Chatre wrote:
> > +	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
> > +	ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> 
> Noting here that kn was created earlier with mode of parent_kn->mode. It thus looks to me like
> above can also be written as:
> 	ckn = kernfs_create_dir(kn, name, kn->mode, prgrp);
> 
> The reason I mention this is that this patch adds a third copy of a very similar code snippet
> (kernfs_create_dir(), rdtgroup_kn_set_ugid(), mon_add_all_files()) that looks like a good
> candidate for a helper?

I looked at this. But the helper needs a lot of arguments to cover these
three cases. Something like:

static struct kernfs_node *make_and_fill_mondir(struct kernfs_node *parent_kn,
						char *name, umode_t mode,
						struct rdtgroup *prgrp,
						struct rdt_domain_hdr *hdr,
						struct rdt_resource *r,
						int domid)
{
	code here
}

A subset of this repeated pattern (just the kernfs_create_dir(),
rdtgroup_kn_set_ugid()) happens on every(?) mkdir. Perhaps a better helper (for
cleanup patch unrelated to this series) would build the rdtgroup_kn_set_ugid()
into a new rdtgroup_add_dir() helper?

-Tony
