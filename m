Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50034E80B5
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790354396; cv=fail; b=MeVq1qJIPSwYPRk/e6Kl/p9IE2J6GBstCkwr4yu3Q+WTlKLMk3sIxFlpu7Cv90CK9uKYuwE+csjTFBC55EGPoEx3C/86PK9D6zpeHfvxdr+7vdWrxg2hOzfI/jPXuZgz9ddcwepS4+O5cIgHdM4zooAdsF4XowsgL2U8QnqQe8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790354396; c=relaxed/simple;
	bh=k1XoL8VriIwKWx3eEoUAOHDtUh7waDeLoy/W6zGyynQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iWXYz/ncRkJEyVD4jSrLkIOa9M8zAIFjmdiWynT4Buvup46BdVUq08ipSJCaHsnAPjw0clu1NlBd/MLaxiO9UHtIIbPKy/fkMpxpLm7aJh4v4iorDXxCWTR7Pf+AxbxV7xOy4RDHp8Mfee/7wJCNEKHeE7bo4KV7pL9PvHnkZwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fiMZvq3T; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fiMZvq3T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790354371; x=1821890371;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k1XoL8VriIwKWx3eEoUAOHDtUh7waDeLoy/W6zGyynQ=;
  b=fiMZvq3TyqpmLuDF0RDr4mULQjwfCdg/4kTW8Oxanqu4LT+al/JYpYJZ
   /CETxVbO5MWzl5RX+MUvWfIjTJE3W9ToA6qXcVECI9r57faYxUOxVQnF7
   LL5Wo6znyelwV6RWrjZNqJHqQDZcKPGBFoo227OXhalFGVshwa5BgWdVU
   e8IX9Yg8onbWm7ZkXL8HPmNHuo8OjTPz6lu/REB0dJ7uWJROGWXzzWCms
   ltPpO+AEeMgIulR/hEZCJxjRu5dj2SFn485BbwA11+GIcCvVdDerkQ6mu
   b1wsnwhXEnZavh1XGnwyfH7rQHKhkvAYTwwDIkBbyG+xcAt/fJOGnzK/f
   A==;
X-CSE-ConnectionGUID: bBmdVxnZQtWxmsfPM3KR5A==
X-CSE-MsgGUID: XoPxxodTQqetwOLnS7wCQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="93638419"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="93638419"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 09:39:22 -0700
X-CSE-ConnectionGUID: 3i4KkQ5AQBOUI11VCrodhA==
X-CSE-MsgGUID: W4KSaLgxQ0GpV/fhW91tYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="277741917"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 09:39:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 09:39:18 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 25 Sep 2026 09:39:18 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.70) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 09:39:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVTJxgbEx0BGQnBDekKNp4dhxVtyylMkykjKXWuZom6aLvqTZWVkaBPsiFC3ZKbbTCbJxjRYxMifiNYpJ6JUZZ0PFHUP7tNdkNAwoAXo1CQjM8SVP0GwT4XHveLI667ibXD/6JpekoG+yXcrUkgRmfafinBI5oelqEmp0/g62ktl0lLILkf8fo1PVU7RfUyCvnKWj/XK9q5K4x2QYfFpq8mu7T/x2uF9HMH8R5LQZFTENiVx1YXRMW89XsReGVhblbydNX67wlV+tzuiGg2XkTyT0uRNq6J069TTjJUok5P7QNYuphj8Dc7aWVtg1XCfIpM3L3k2JqIK1rAJrDwvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FSKID+e2UsOqKZ6qPy6r92cM5MUw4XllZxVDIkdd44=;
 b=CL+lvnptaG3Ug9857LPACvdUxZcSGFS5bQWK72nfkJJIv4OsqEEoE3Tez1oQ1maaUT/I9AEjpmtJn7h/ydMg+NPtu6PSfBFIeQk/8JSFn2+H27UXYJT7F0gAO3Efgi2q+aKp2gd9CIR2bTc14MLTx+Bi9Suh5iQ2MPDMLR69oKYD7k3jfwALLrAdB2oONP0e/nzn+kyQwB9JewpfcOxLPpPrpWZ4Qw1CD5KFt1HZy5lLnH4TpB1LpP3QNZPKiNWI0+15QDN1JU9EWeIw1oDTmacdsZj62z6EvIsrR2OqZLERVlCYU6GHcwv85niYYCTY0IsNAubleNriNCd16o3xDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB186312.namprd11.prod.outlook.com (2603:10b6:806:595::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 16:39:16 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 16:39:15 +0000
Message-ID: <dc052810-8e63-4bf0-8056-59ce869b3d52@intel.com>
Date: Fri, 25 Sep 2026 09:39:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is the
 only resource
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-16-tony.luck@intel.com>
 <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
 <arW6xlQWVWkixiWe@agluck-desk3>
 <110d2c7f-8354-4d25-aff8-cd5ceb46334b@intel.com>
 <araYQUCPvnBH_Qlj@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <araYQUCPvnBH_Qlj@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:303:6b::24) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB186312:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc76aba-1d2a-44b7-ce44-08df1b23899e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|56012099006|11063799006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: TLnmSeuW43fmURsvged1hYjbHZTbAF9GDA9p0didT82UnP+dK0Jgc2+31n5jPZtPGuoB0WIJqRYGuot3cWiiBCIkVxh4og9fStgZTrDFAxsBG5pT7ue/7ZGIXvo+V5Bm1/goi0FfUAZ8wZjDMSN/9dp0bwdbukYd0qctmf7EyFq6xztDcuk+733YVO4kvYxhYMTj1KLtCkgJUwEHGX9EzYmmU5vWgIaDOgUvE0i1+8WLSUpIjo2hn7b3Hg0PZbLPxCN9jKd7ASs1aU8a6zqaUwRa3n/QNBN31mQ4KDgDQnHxRmnosgh7cPdy15ZHMVazq51ERkFC/5hkDDC/rkc7/gi4TP9ZfrFzZ8dyMSn0FHd9rEtMWgsaj8t75/ZldyFnszRm5nxrEkbLCdsq9HOwVwgaO0mbUGPpH3ThLwI/w0n5MBH6cIyuNOM6y1Il29np5EIjimM5sX6iaEAOgkPpvD9oQhYNPeWwQDy2z86SmGtuIR4KKcrn7dLNYXN8L/IaekdmU+htVGgKrALxeJCgrfI4hK+29kv7pnru4ODdZltkmgplJp6TRUS+lYvoAJCTWiw43q5m2yOkEDPS48bnk90iQcAaYUmwemPMP18mAA7GAgfO8s2jDE/75WiXDsaL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUZBcTZnYUhxcjdqdFpnL2pzalVoS0lMYVErako0Y1FQbjAwLzRJMkVLZ1la?=
 =?utf-8?B?bzdPV21nb3d6N3E0ZzNuU1dJOXNHNHdweGR3NEFIdGs4anZycXlBSU1xcndp?=
 =?utf-8?B?YU8xNGdnMHhPb0pvcko2OUJJQkRXWXBTajFMZm50eldMblNIRlhIMTNRL05o?=
 =?utf-8?B?UnZlVEtNc0RvbjlaZjJBa3JXMkoyalRFcU03NEtRSmVCRmJsR0xadENkMnpr?=
 =?utf-8?B?L09xazFyUFd0U0RMRmpUejVFRWJidUQ2NWFqdWRvYmFRZEk1TTBvTUZwVFFK?=
 =?utf-8?B?V0lsaEwxYnhHekZTd0g4MUphTUEwNnBObkp4WHo5em9NS01rUkgyRUdkQkpS?=
 =?utf-8?B?dmRHQlZpQUVqV2xjZmhXOGNoM1NNU1NPRXBLSmhDemVrRmU1c2duZTdjWU8w?=
 =?utf-8?B?MEYzRGtzQnZyRzBnRFlaZk1xQXN1eHladmhVQmNSaENnYkRjL2tCbnE0ZVNm?=
 =?utf-8?B?Vk5LSUlLNzlxUGUrOXlXY0ovdTlhYTVPOXd2N2M5VEwzYVljc2hGY0RSY0t3?=
 =?utf-8?B?MFdaOUM3RlltY1pJbG5YeHg2OFdwYzVSMFl0MTFKV0dEV3FNc3BLQllVZ3JJ?=
 =?utf-8?B?eWc2R21kV096ZDFSMW9lbFQwNXl0Sk5ESzVwSUNTMnVMd1A3SExrYWw0R3Zx?=
 =?utf-8?B?ZW1WSHdTNDlhWXkyTm56dVkrQU9FQ2syeEorSUZhdUROdVZmcG5ZQldwekww?=
 =?utf-8?B?Ym5PWnF5L1BBbGYycjFXbkpQRHZxU0tRaFVBY2hYVlhqVms1ekhIbnFwRzJX?=
 =?utf-8?B?Tk9KQUwzcnNKSjNwYTdCMGdOTkw1U08ra3VabTAzZ296b1VWeExzeTU1NTRM?=
 =?utf-8?B?VGY3eURVenlNMkhoaXJVOGVPL0laeTN1a2VSd2dSNHZoVSt3RUZJaHlqa3oy?=
 =?utf-8?B?SEZ0ODZpd21qa1BZazI1NzQwL1Z1dFZaVDhGb2VwRU5KKzNva2hJbmtXS0RK?=
 =?utf-8?B?T1RBcUxYbVFEbS9QbDl6d1RSWjJJbi96aVFHUWxHTS8xQlJtUndSZHM4czJr?=
 =?utf-8?B?eWpPWG4zLzZscGlIamx1VjIxdzV1bkVBR05HU1ZyRm8vOFEvbUl2eWErZ0p4?=
 =?utf-8?B?V2d6RkttdUQwRUw4THRLS3h4Tlk4ZEs5ck9CRUk2YWFuSExMZjRtU0srWlRP?=
 =?utf-8?B?ZDVFVVlxQVhRb280SDdtQW41dzE2YURYY2gxVmx6bDk0SThrakxGYWZ4UGZJ?=
 =?utf-8?B?VlZlQmt1ek5UTmJxNExpNVNYR0N5cGlHRXFHc1dKeTZ1QkRlekZTeTE0T2o3?=
 =?utf-8?B?dzVJK0N3OXJtRSt5VEppazYrc2RQMkRYVFBaRVhacURFZCt6N2VDNTNSVkxi?=
 =?utf-8?B?b1N3cGJGbFdxTkpiN3VvQWlENFRxQkllTlk0aTdKUHA0clprZFRxRmdYb1lQ?=
 =?utf-8?B?ZnBTU201Z0NYb01zK1dzdHg3RXFhc0IvSThKQnpJVE9SWVJESVdTUFlkNHh6?=
 =?utf-8?B?MGN2TWJmSEhJMURuVUZ3b3dlQmhESy8zSy91OGRHZnZoZ00zQXB2dzA5NUky?=
 =?utf-8?B?S29CWlVYQW1lZEdiczVsbHVkTVNJZEQxaHFTSGxmejJQd01WVmFLbk5HY2VE?=
 =?utf-8?B?aGdvZFIxN2w5NjlDY2ZQMldMd04yZmNqRVBVbG9QNjR0VmhyUUZibnBSVEt6?=
 =?utf-8?B?azlUMjFoMXRQM2JRSmZ6ZEJNK2VqbFZlZDV5ZTdoQlZFK0tqb2lhd0FRUU9a?=
 =?utf-8?B?VTVvK2ROdHFRamcvZFUyVFlpNzRFK1M3czVXdldmL00wWVRxclZ3dFBZcGRB?=
 =?utf-8?B?WmFYVG9kcStwaDBpOUNMSFFXK21ZeE5MN2JmZVkwWWEzbWt1TW02VzNuTHVu?=
 =?utf-8?B?N3VmMWFxeGVyNjJXQURnTFdsd2dvNGV1UkVCRlRUN0hQTnUrS3BBaGRCVFJt?=
 =?utf-8?B?dG81WGhJNy81OEJiTFp1YTM5eXAzM3NoQ2RWaStLMGFMNzRTK09lYjFSUzZY?=
 =?utf-8?B?SWdweVlUaEdDZWMxWUNpeFdRczhWckJSODdTRGRTWUd1ZllqenNQREFoVTNv?=
 =?utf-8?B?ODRra3BRbGtYTkJZblVvdlM3ZDJnTEpKMWRVQ3FObU5vcVJScnNMNWwzV2V0?=
 =?utf-8?B?bEVjaGVrbEFpYUlrT0gwbUIxNFdOTG9NUmVPZmJlV0dyZDJ1MndISTlEdSsr?=
 =?utf-8?B?VmE3WHJoRmRWOHc1alJmNVc4REFhNmZrZldOdVRWWnN0aFdRSm8rY2Y3bEJT?=
 =?utf-8?B?RnhCRGRFTUN2eXp2Q0VrMzVQaU9HcjBxdDM1RmN2TlFrN1hJNml6aHdRZlN1?=
 =?utf-8?B?VVdoUjRPbHhLakVUbmFUSkkyV1NhRllxSnVwaXVhcGpUMm9USHhNNzJZeS9w?=
 =?utf-8?B?djFiTXljVkNvOWMzdG56S2c2RjJsVXpSZnp0Uk5EcGRkd0I0anpyeWhBbHVi?=
 =?utf-8?Q?MXTlaHQ25yakLpmM=3D?=
X-Exchange-RoutingPolicyChecked: oy2SeYaWq71MZ8LC4eeQo5E75qPpWKkSAM53rrJxrPK8oOE7OOvYHPbHGJ3QrVe+iWqEx/W5N86awdOx0Uaef9OYvcjm6OcmRPM2DAXYiEExOE5ZSwmqTPsxvSWGb/5HP/JM3sXDVR7qgs619vr9H/r+N7YHXM7g9cb5yx1pjSuPL1GnsCuPfhnNiVffGjgXlJujTHRqyTHiIpY1p9dLDZpMtNcc7WcdMK2bN5KurHB5m+D0A592j17z18QcICBP1bzRlqPDcmkC+/+I1i03w+i+xGqs2DqyBN3qYh71gLxJIiGUACY03fAmYjT/ArDMD/mkc13PRfFyrRIMov5ayA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc76aba-1d2a-44b7-ce44-08df1b23899e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 16:39:15.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+H844x6q2ggHivoup0Mo+jSf10DRIT4pXBSaK9jAuaXJpzYkwfa16fwB7azp3L498+NuHVrkNZbTwY4FtWdrH4PcZIKtAPsRovmo/uUyTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB186312
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/26 8:50 AM, Luck, Tony wrote:
> On Fri, Sep 25, 2026 at 07:37:20AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/24/26 5:06 PM, Luck, Tony wrote:
>>> On Thu, Sep 24, 2026 at 01:41:48PM -0700, Reinette Chatre wrote:
>>>> On 9/16/26 4:13 PM, Tony Luck wrote:
>>
>>>>> @@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
>>>>>  
>>>>>  	/* Any of the L3 monitoring features? */
>>>>>  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
>>>>> -		return false;
>>>>> +		goto skip_l3_feature_checks;
>>>>
>>>> This goto looks unnecessary. Why not just "return true"? Even so, this 
>>>> also changes behavior from the previous version in a way that is not clear
>>>> to me. I was expecting this to consider the number of RMIDs supported by the system,
>>>> now that this function added:
>>>>
>>>> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
>>>>
>>>> Should this be:
>>>>
>>>> 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
>>>> 		return pqr_assoc_num_rmid > 1;
>>>>
>>>> Although ... looking at this closer it does look strange for pqr_assoc_num_rmid
>>>> to be 1, thus reflecting that the system supports one RMID, when zero may be more
>>>> accurate?
>>>
>>> If X86_FEATURE_CQM_LLC is set, then monitoring is supported and the system
>>> must support at least one RMID. I don't see a need to insist on more than one
>>> RMID as a precondition for using resctrl. It wouldn't be super interesting
>>
>> My suggestion was not to use "more than one RMID as a precondition". By copying the
>> relevant code not shown in the hunk
>>
>> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
>>
>> I aimed to highlight that if the system returns zero then pqr_assoc_num_rmid
>> will contain 1. The "pqr_assoc_num_rmid > 1" is thus not a check for "more
>> than one RMID" but instead a check that the system did not return zero.
> 
> Architecturally the cpuid_ebx(0xf) can legally return 0 meaning that the
> system supports one RMID. Here's the description from SDM Volume 1 Table
> 21-38 "Leaf 0FH.00H Intel® Resource Director Technology (Intel® RDT) Monitoring":
> 
> 	Register	Field Name	Description
> 	EBX[31:0]	MAX_RMID	Maximum range (zero-based) of RMID within
> 					this physical processor of all types.
> 
> This code path is only executed if the test for X86_FEATURE_CQM
> succeeded. That should guarantee that leaf 0xF exists[1]. There's
> no way for leaf 0xF to indicate zero RMIDs because the MAX_RMID
> field gives a zero-based result.
> 
> So a test for "pqr_assoc_num_rmid > 1" really is checking that two or
> more RMIDs are supported.
> 
> If you want resctrl to refuse to support a crazy system with only one
> RMID, then the check should as soon as pqr_assoc_num_rmid is set:
> 
> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> 
> 	/* Systems with only one RMID can't usefully support resctrl */
> 	if (pqr_assoc_num_rmid == 1)
> 		return false;

Up to you. I already highlighted in

	https://lore.kernel.org/lkml/39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com/

that my goal is simply to align this version to the previous 

	https://lore.kernel.org/lkml/20260831174421.13921-14-tony.luck@intel.com/

that used 

	return resctrl_arch_system_max_rmid_idx() > 0

to determine if AET can supported.

Ignoring this simple question in

	https://lore.kernel.org/lkml/arW6xlQWVWkixiWe@agluck-desk3/

you instead use the SDM to argue against me for some reason.

Reinette
 


