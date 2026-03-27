Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB7429B789
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 19:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639252; cv=fail; b=aO7DMSjmopblJN39K88nl0xqJOxgLa24vn5sTsS8b2o7EWC5ADrwP8JjzDSjlys7yNf48tNWwetl+VW0SdS3jK3cWlDMgiGYqcsRsnrWpTEQnlUoFMZlWTSHIKQ0vW78MVfrE1fndyduPqYXvaI7ZsvRBuR5IncgGzvkrHgGKUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639252; c=relaxed/simple;
	bh=CjTJR3NhOlTcmp/t5dU3PMH1tT7YoaW3D0r/MMb5Gk8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LY8wkdSFB/cQPyS3bm/25pmxIhUdh9DpmmxJ53/ycwzOAAif3Zj+1IQe6C9a7G/BPWModAslP/XXLSLxpc+zTz0JLxlOFRQZAeXAopkls59cLqf/MvFzShWharGNV3PuycEiEdkn+CAeqQL0U9vEiUesKDoKxjhbU+8cZIN2qBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mNVL0fpr; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mNVL0fpr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774639250; x=1806175250;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CjTJR3NhOlTcmp/t5dU3PMH1tT7YoaW3D0r/MMb5Gk8=;
  b=mNVL0fpr5o142bn3xPbzSwc5+LsFVqySbNYWIUrOIp0c5GqrWp4RU8oX
   FoKXbUgyCnaAJF/T9J0GjYISudOLK1MR81HbhrnfXZYGKuBpCI48LbdEZ
   4lm5Ko14vzpSK7Bpq0nPtP3tMQzGcS32XLhay+K82kdVODeNm1oDsoB3c
   SLXcuRwmvYJN2ovI41ALpvT0CzORtRIGZ3GfEBOJH5MQcLm6seqLdSCvD
   f05jp8/z+a6m2Q1oBUpGf04SDh5/jIS/elvKgJks0ZP2ontp3CepudTQo
   uviRQFHHSAcN1m0w4jfDIlTYR4BhGVjauV1/NLuThCxpn0WwQAhNuIgK4
   Q==;
X-CSE-ConnectionGUID: kWt++StSSd2c5ChzkaiDwQ==
X-CSE-MsgGUID: 7d50VNEaQaCFwKfvaxXg7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79326690"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79326690"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 12:20:50 -0700
X-CSE-ConnectionGUID: GgSBRyx4RFWFjZ/GUJTvWw==
X-CSE-MsgGUID: Rg206AuAQXOy6i8t/IJmMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="227001932"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 12:20:49 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 12:20:49 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 12:20:49 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 12:20:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jaDfSfEw10O2GXNxgz5mJHabgYp9LK6uznoeORvqibZwNhVmyXDJm7aBL9PHC9ItgcGFUKrHFIMgtCqEOiXozlA6rzkUVmZr49FKrO0mo9Yd4slU+ksWes051irMkSdmsKzx2aetV6DnWRImw77B9bnQEKNNzvkiL7RvNiliETT6VlzJY8XMo23mGLEuoie7lubvV9NaYhKl6rCAg2YENT8EDovzlwXhf5+b0aTbUBljxxkfUQtvVHmAjpz7KOOyyuSm7km4WKzknpDp0PysLX4ZBRGTOZ2nIsZwH7A+1G11karpNfo7QnazusTOc7JfTBnhN4t2RVMTotbXFcbN6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBlnFXS4F5wSUr1CUxH9WZksHoPr9kJ4cm7HOPZzdK8=;
 b=ElOclVxbfsas3spPyr7AK6ywHWiiKLlnkMCdluUMURL6Pdv33/xLUl9flcaX56K/uSSrLOqlyg5Qfk6iwCeM3fK3y6t2+I/t+LDWlNGFz8ESjWjp2vm6mA6LX9uQIN+TA4bkP8BIsJNEDZ5jmf4Jf784J3nJyeSu1hlD98QTGRynaMr73Vdf49tXvZAiNxUR1L05EzDoVM21kA49iK8NhtikwIA5ksbYyqvzzITCurmZGtpWynftkkpeuc7h5/hCexJ7hVB2GsVeJ7WxS2RNOcsB4UytCOSckGbs9Vh5QKWls16nfmDVTdmeoIVq9/W2lhtaqudxE1Jah1ln60yvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB5874.namprd11.prod.outlook.com (2603:10b6:806:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Fri, 27 Mar
 2026 19:20:46 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 19:20:46 +0000
Date: Fri, 27 Mar 2026 12:20:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>,
	<stable@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 1/9] cxl/region: Fix use-after-free from auto assembly
 failure
Message-ID: <acbYgkczKrpG4x6d@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-2-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-2-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB5874:EE_
X-MS-Office365-Filtering-Correlation-Id: 776d76f7-55cd-4dfa-f1f9-08de8c35f285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 3Mn+ec75WiAWiP4xilQvOiD0Jf0BkP3DCsxqszNrmeRws6ZjkMyQccU/2CMTyMKOrM241aA8JhqH6y5qeujuq6pBRibz4qtE2xwXsSFhpFnCRZa4r/p0bQObbcLgQI9Yj18Vdi/5GekHmO7oS+ozBrL+K5szcdLAlfuvcTPQ1Wj6EOiFWu+lUleDT3v7n1AFlPoC1nNpbvzCskRZ+jvyAXC62SwXBF9tjPEmGOEomX/DlfDfHYNo57cpgN/6DJZ2XDSvlth/J9+Z5jibK37BwjFnCeiQaspiCruCWgwovWluqv4YvZdqggWkbjiTVFaqQH6fC7SPUoUhvN82LVQIsylP7qKeBbCutInJBQ//rvjLh2Ff8W8B9bKUEronXoy4OdHsIvtKGOasJdA8xBberk5bGClsE3WGrMgxMKgU5peKVq18kWo5Xbb2liSlisMq99zdwj/ItHeNPMJtO8NDVspM6yYOyPCPlNBVe1vEaArpJmmiTACuQymR3hHqi9t0EbLPfst4ueuaLPkDnJHAhM4iTjI4Bn+YwxU6eaSzav7TL73E66sj9ItiBAcW29wPCFlruGDx64V/XAdh1yyRAAW0DA37FtI0KUgixfXLI4S+UKMjwGowmYdzTs7rKLVedjT3yOiZFz8u2RuYdur8IRy1gxS2Yu1vxIUwNKx+LdqxBehc5srNNtLN7qITzDugY9SxqVb2ewTmjwl7k9NTcyYoyqkH91uqe3hvqndY1jk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kz3WHIqavifSEs/2KHFzJbgu7leUNoGabe0oheq9Y7H4wmg/ilRt+MSngm/v?=
 =?us-ascii?Q?SPVAW7DadQg3Ax4KTbm2t40hcNkO7iaTZy79xJhjQIHKle5uBw/j5yUyT5wZ?=
 =?us-ascii?Q?wuLwAwMlsuIrhJ07KMrmGJBUgEOUm+ixWchjXSWhkfQMTlzp4pj+PHzQQXOe?=
 =?us-ascii?Q?CZy2d3UgRJr52ftnJHw+1WzbkacyEapOqypb65Fql8tZvrBM03yekiuQspn7?=
 =?us-ascii?Q?K9l7pdPjHCMNsvysVZgAMNWwD3vYclKXbwpg0VACriUenMaziuyJFs8ZhqyE?=
 =?us-ascii?Q?3viz8O4YRUgfk7J4WB3FkbyRNb6ah7Bzjolw1Rlmom1qKhuJdidNeX7ancpw?=
 =?us-ascii?Q?xGs2ofb8WMh4kotmCTzGQYbdBGaLLgHiw3t8th2IORU6cpy0O+5B7+tA1iM/?=
 =?us-ascii?Q?GNW0AhXZS3OyCe8f9LvuOrZJilnMmcZjLh1zZg8tOvnFhuJnAbLHEgm3/rO0?=
 =?us-ascii?Q?peC0k0v4ZV4YljaTTXTXV3aYPB10Q3Xz9lhzu6mCtEIWjYm3GKMMcbrZ9Cnm?=
 =?us-ascii?Q?nMsn8Ct15n356N2hLvQlPVW6z5ajFSfpwAsSkd+f76w8fHQCdieSY3iyVW7a?=
 =?us-ascii?Q?O7Vlh3AoAUkdMiHn9Yrl6SZK+DovMFMbpyaSNpcPqqTchzW1h94B6LORwWzS?=
 =?us-ascii?Q?1UaAZKX3ZicapBwgNAwIFdHqZLnfHaLOcuMrRoQQvFdgXet1okXi9EqynBZq?=
 =?us-ascii?Q?l5PybpIQIOmycksUS9/7m5TxWHmHVFvTABjg8cRR1q/eAZQkoYJ92yoO4ziS?=
 =?us-ascii?Q?zoaRJ5sE84LIgFbWcbH7uncfL3o+erPtlV/Nnujq19fsy0D4j3Tu9SsdgzRF?=
 =?us-ascii?Q?5LMjTp+7yGEjLUAgpEJXFB7VhlbL5Wnd9ienHp1e7jIkM46RFUEMdqrjFRNg?=
 =?us-ascii?Q?15NK700E8a4DHakN8qzJS4RMOT7zttoUFrzENaseJi6zLVinQ7tt24+9qp5U?=
 =?us-ascii?Q?3PEH0ctMzsdkEUWWK++N4rEQnKBJnS3QhxmCQn76KU1Rt6xyDUWLoMvG28zi?=
 =?us-ascii?Q?0gnp3NVoMkSymt7uQnoYCVpivOLJpzgQiJkhcytL8kAVsYV0Uvh2YL1OXyAZ?=
 =?us-ascii?Q?Ak2MLvMHE0ooP2HkDTeudF7APs2CkKMW7SEulE9bGt+GWJraWkrekRT5E0hy?=
 =?us-ascii?Q?0HI5DXz3KLBGnX02dnpI2bY77XBcPLidW5ivj+SueaW6iAzfkt0+y06b1bVY?=
 =?us-ascii?Q?NOBSc8mGI0JHzO4mFYHszn8NWIHQx/yiZzQxaZKvXD3eGVV1FfrZV2nhaUWF?=
 =?us-ascii?Q?SX+x0xyJ6pEDR6JFceUWp/X2c6QM6ioZjlR4Nf5b99mfLOm9UCWPZOmD1OQC?=
 =?us-ascii?Q?hR3jl/XI/KqQD+KzFN6E0I9z33RwmvAckR8brK0qsVWElksqwkUdqioZU8g9?=
 =?us-ascii?Q?mhr1vLII8wK2iDpOg0yIGQ3XQT14D+tR/zmh0g8cY+RTZuaFLucrL3Y8uDLt?=
 =?us-ascii?Q?Qpuwpl4G0rLBzN6TcS8oov8GvPNyqHZa29M6pxOWIgqXrI5yLg5nloNt2tuR?=
 =?us-ascii?Q?1YuNqO2iSEnCqaWEB1Uapdfaf9ZuRYo1LFSb2gz6Emi5ds9OoRO/L5j6rFT9?=
 =?us-ascii?Q?EpVzPpEcb4LIgwqn9X1Vkj5dyphUP637Hm6JinTwb2M0Tjeh4blmHSzG+D2t?=
 =?us-ascii?Q?I+R5/AmiEX7URw1Td7ZysKGK488VlgjoDhikkUIrVKJKVduRcn3z50aUB+bd?=
 =?us-ascii?Q?/b7/1k1XZCgg07ipKw/k0HeLg5WDRp9T6WlgcSTggQ+Afbz3P37W2mQBg3lT?=
 =?us-ascii?Q?kVBoKal4K12J/ohFcMD02sCZXuuhLYY=3D?=
X-Exchange-RoutingPolicyChecked: jpXJbMs3h2w3PqT//RIwhuRfW55E4WyNTC66lXosDkA9rGda4O701atHi0Jq2zjBEWvzEqVCuOf2AM9c+FKAxfGRlDCByN3aWjesIoAIJf641ZnMbLI+Kzq68wByLdVwXub8dQyFlCfT4t2UIIsEREjKr7WcgpVkR4q0iRL8Ak794IguTPl8johGG6eVs/2nwNszxhgYteNRXdhg0Bxh9mRZVhrqDZJme04fxcjdFb+bs+jSnFjuRWzGvrPZ+CshetTN0oiRFQiMLea8Kw/3Ez6p6rwVYQXgtl+U/YRDNFrSgfq/ae4U5C//wEEcOx1258U4fIsD0Ww8vBWdRpP03A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 776d76f7-55cd-4dfa-f1f9-08de8c35f285
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 19:20:46.4829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rV5DvXB4asipSK+03e1KfziTkzJhMMldZOCLanH7f5jgl49qecdKC+7zWuFCDD8NX2LzgikQzNlKbbgQDISsw9u/KC6VW/HRCWcm4yhCYyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5874
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:13PM -0700, Dan Williams wrote:
> The following crash signature results from region destruction while an
> endpoint decoder is staged, but not fully attached.
> 
> ---
>  BUG: KASAN: slab-use-after-free in __cxl_decoder_detach+0x724/0x830 [cxl_core]
>  Read of size 8 at addr ffff888265638840 by task modprobe/1287
> 
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x68/0x90
>   print_report+0x170/0x4e2
>   kasan_report+0xc2/0x1a0
>   __cxl_decoder_detach+0x724/0x830 [cxl_core]
>   cxl_decoder_detach+0x6c/0x100 [cxl_core]
>   unregister_region+0x88/0x140 [cxl_core]
>   devres_release_all+0x172/0x230
> ---
> 
> The "staged" state is established by cxl_region_attach_auto() and finalized
> by cxl_region_attach_position(). When that is finalized a memdev removal
> event will destroy regions before endpoint decoders. However, in the
> interim the memdev removal will falsely assume that the endpoint decoder is
> unattached. Later, the eventual region removal finds the stale pointer to
> the now freed endpoint decoder.

I'm wondering how this is exposed. What is 'eventual region removal'? 

The region driver does not clean up after failed auto assembly.
The cxl-cli cannot because topology is broken.

How did you get here?

> 
> Introduce CXL_DECODER_STATE_AUTO_STAGED and cxl_cancel_auto_attach() to
> cleanup this interim state.
> 
> Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")
> Cc: <stable@vger.kernel.org>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/cxl.h         |  6 +++--
>  drivers/cxl/core/region.c | 54 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 9b947286eb9b..30a31968f266 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -378,12 +378,14 @@ struct cxl_decoder {
>  };
>  
>  /*
> - * Track whether this decoder is reserved for region autodiscovery, or
> - * free for userspace provisioning.
> + * Track whether this decoder is free for userspace provisioning, reserved for
> + * region autodiscovery, whether it is started connecting (awaiting other
> + * peers), or has completed auto assembly.
>   */
>  enum cxl_decoder_state {
>  	CXL_DECODER_STATE_MANUAL,
>  	CXL_DECODER_STATE_AUTO,
> +	CXL_DECODER_STATE_AUTO_STAGED,
>  };
>  
>  /**
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f7b20f60ac5c..b72556c1458b 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1064,6 +1064,14 @@ static int cxl_rr_ep_add(struct cxl_region_ref *cxl_rr,
>  
>  	if (!cxld->region) {
>  		cxld->region = cxlr;
> +
> +		/*
> +		 * Now that cxld->region is set the intermediate staging state
> +		 * can be cleared.
> +		 */
> +		if (cxld == &cxled->cxld &&
> +		    cxled->state == CXL_DECODER_STATE_AUTO_STAGED)
> +			cxled->state = CXL_DECODER_STATE_AUTO;
>  		get_device(&cxlr->dev);
>  	}
>  
> @@ -1805,6 +1813,7 @@ static int cxl_region_attach_auto(struct cxl_region *cxlr,
>  	pos = p->nr_targets;
>  	p->targets[pos] = cxled;
>  	cxled->pos = pos;
> +	cxled->state = CXL_DECODER_STATE_AUTO_STAGED;
>  	p->nr_targets++;
>  
>  	return 0;
> @@ -2154,6 +2163,47 @@ static int cxl_region_attach(struct cxl_region *cxlr,
>  	return 0;
>  }
>  
> +static int cxl_region_by_target(struct device *dev, const void *data)
> +{
> +	const struct cxl_endpoint_decoder *cxled = data;
> +	struct cxl_region_params *p;
> +	struct cxl_region *cxlr;
> +
> +	if (!is_cxl_region(dev))
> +		return 0;
> +
> +	cxlr = to_cxl_region(dev);
> +	p = &cxlr->params;
> +	return p->targets[cxled->pos] == cxled;
> +}
> +
> +/*
> + * When an auto-region fails to assemble the decoder may be listed as a target,
> + * but not fully attached.
> + */
> +static void cxl_cancel_auto_attach(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_region_params *p;
> +	struct cxl_region *cxlr;
> +	int pos = cxled->pos;
> +
> +	if (cxled->state != CXL_DECODER_STATE_AUTO_STAGED)
> +		return;
> +
> +	struct device *dev __free(put_device) = bus_find_device(
> +		&cxl_bus_type, NULL, cxled, cxl_region_by_target);
> +	if (!dev)
> +		return;
> +
> +	cxlr = to_cxl_region(dev);
> +	p = &cxlr->params;
> +
> +	p->nr_targets--;
> +	cxled->state = CXL_DECODER_STATE_AUTO;
> +	cxled->pos = -1;
> +	p->targets[pos] = NULL;
> +}
> +
>  static struct cxl_region *
>  __cxl_decoder_detach(struct cxl_region *cxlr,
>  		     struct cxl_endpoint_decoder *cxled, int pos,
> @@ -2177,8 +2227,10 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
>  		cxled = p->targets[pos];
>  	} else {
>  		cxlr = cxled->cxld.region;
> -		if (!cxlr)
> +		if (!cxlr) {
> +			cxl_cancel_auto_attach(cxled);
>  			return NULL;
> +		}
>  		p = &cxlr->params;
>  	}
>  
> -- 
> 2.53.0
> 
