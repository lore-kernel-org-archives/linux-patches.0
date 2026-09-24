Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0A64A4985
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263859; cv=fail; b=Kl8/GF//CCYo9+J2/JjxfD+E5TkSdkuVzGxfqi0e8TosajSBEPIqhMyIW0wXbkZKrTINht3udlpGpyzLbjhh9uDntV52rJwHniEaH/psNxN18qWQbGzX0uFXc5co4kNwNxwretH6MmLZACTsVa5k2cmTcrRNT2Belo1DLZV/a/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263859; c=relaxed/simple;
	bh=O/+2RfPCMb8R5GsWR1smD4997IqGZxcTndnZXbC2VFw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C4wgpqKRc1ChlEGHQ0xKmuMlQYg1hes84KYILApI1xjVWaRMCvRh9pwWEcNMIfh/JrhToXRQrg+wsrFZVjSo4EQeJB7PgmsWSeNL3jDMYKKGtDxtpZZbcgfcn//KRnqLG3Pt9wiqm2qfh1OJUOxua3lxENoEyO8lygFc5Z5ZU2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fSPKTVfy; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fSPKTVfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263858; x=1821799858;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O/+2RfPCMb8R5GsWR1smD4997IqGZxcTndnZXbC2VFw=;
  b=fSPKTVfyTbA2bnz0Rlrjgc89FO/DicU8qlF92pshyqVEgwwARbwbuxV1
   7mJtMFDK30EzfLlP84P7v6FwqnJrFQ+jusOe82nPjcoxMgNk2Fo6p0180
   zbikbKgXFg5xZvlMhGgcq+fVngByxw3GPJYvPWf+J4dEkCyakS9y7uCU0
   uMB5S68F7gGP5MnT/0Csc5TTRNkku/3i2WbeUi7OuvXQErOOG2OSp4pjb
   3Ib9I0xUxcw2tbaXm+wMrQHPyb8LCDg7kJwOGm7oGxPPHdI0/Ufh14Y0C
   7Azt1UxS6zghGopyatJJbqiZwk9XgA/hNh+YKvGMUnL01Iv9MyKq9u1Hc
   w==;
X-CSE-ConnectionGUID: +4WXDw19TMWAMo18qHpNWw==
X-CSE-MsgGUID: cSwkPPXZRXSvb2kIcbEbQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="91145137"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="91145137"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:30:58 -0700
X-CSE-ConnectionGUID: npA0Nh8DR2GibfVNog0rpQ==
X-CSE-MsgGUID: 4TrdJueOQRSYGbZhSahDwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="273174299"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:30:57 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:30:56 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:30:56 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:30:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DD23Ihn4/RCm8Wvoi2I/jyb1gxmw6g9h3nSl5T8cZ6T5eHLu+xgn68mxbW8UiL9t5oACrtdcn1Ama6Bf4u8vGkfHuLD/Dcz56AqCs94WtpSO19NxKhMxvUOCoMX/h2G205EzLG7eTEMGHb5rC/CWUrthLqPvsJtp0sGK+3/jtvzM1Xs5o+SdiECTQ9xfqaKVmNG3Lh8S6ZZvuJYUfbEQtT2SniuhjfK/wCVPYx7+dREUqEzeIRw0EpsXBPlv5Ad5x+ltLi+KKxcHoXAY+uZ/ZY18gVETpYhjk1xPA5bzFacQLExqR0fbZNHYdgYVMjPlQ+C7i9VoFDl5y6d9iX8ssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TItJcCurXUmCWoZLkKunh5ymQOx4eK1bk+Bwa2zoAcA=;
 b=lIRECiquD2fPKbDAzi7lWYyTVX9fnV60ju86z1aReuVkM1QNm0OO9uFLcc6oaM8iLnoP3Ukb4fFm0XQWXtWGuvHLGOC3TaSyFRo8Warl5d2JQt8HkSXjSuPImYneiKHaiwQi65J2aerpDpZYytJD6WMcg013tEHxQNOt1GB+lVSztRPU9Ax6dn2vuqNiWsG1K2h4F3c+AWZu7ETi1ZREKEx5iPJ7dMmCcnuyKfVOmtdoQnOY50ZvJUha60jrI39bVqCECglDujITf92LkYopBppda3PwgBO5ZFRO3Dd//mEuHbSSdrDJW7UQ/fQ8635C+2djiPexiobj8zwT1T2jKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB6018.namprd11.prod.outlook.com (2603:10b6:8:5e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:30:53 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:30:53 +0000
Message-ID: <27b650d7-fa3e-48f5-865a-638a476c9d95@intel.com>
Date: Thu, 24 Sep 2026 08:30:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 09/25] fs/resctrl: Remove redundant calls to
 resctrl_{alloc,mon}_capable()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:303:b7::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB6018:EE_
X-MS-Office365-Filtering-Correlation-Id: d1d6ed7b-966b-488d-1694-08df1a50d20e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|5023799004|11063799006|56012099006|4143699003|22082099003|18002099003|10067099003|921020|6133799003;
X-Microsoft-Antispam-Message-Info: lNXtwLgIVW/5Gm+tDxi+QqyQm0BJDMqRZEeO258kAfkWq4A9ix62J0+U/NDCS/B0ehyzJckttfN6G0B8EEMXzSfF/Sl2y/QPkO7YmRMvG0YTTLwsLT6jj1NtYnFlQCjy/Xq2sDkJOn1vZX14Mlb8351X8hoGaOt8GotOhtLNabxeoDH4PIx5o+2P/JJYmDh05KsoZbzxDT1LceEkUX/kJScsJPMFChk0PXt3oINvR1unvCkfhwdCKJOl4+pl5Mnrbj3Jq+bkwXfyZtcfhhGb0bp4qyjjc/Ickb0Tp7Y7i7vYk4IF3K7k7CXObEy7QKrJtdZRPWfaDGf7rjVXCz7hDwir+NSGHQGlymKk4AqzW3L8AjbIOYGI68V5cMPb8eO/HUknI9Mt10dYKuVhNeOcQwrmE/vonlkLH1Y1z9UsQGlV/JmURJMmEUbNb9U8OJZkpUdwB7HWu/TpCFHOXEYkWmujkIB1MAnbiaKVg1tfU+Qqsvw12GM4UfhZSs6IzE3nqrqJj6qMIFmz71hCFXS2jRv+Eg/xeKEXN0dJ1L4gFrwZyQiLuaDQ41uzWZMUB5vWXFraXvk8m/dqtwTKSySv+xpczbCw00MYNXEaXpiSMCFxYA5cHRxy/K5o0165N8vcQp2NQ5le1f7kc9X+HuaBoay3i8puklv4Ra4EdS/lbsxMDYcwg61ckVeIrkF6vsokJN929MBMCDY5GWZe1mrR3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(5023799004)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(10067099003)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjE4elErRFl1WVFnY1pTQkNXVGE0VjExTjJmeUcyMDgzR1UwTzgxZVRjQjF3?=
 =?utf-8?B?RVhjWFFsTUh6dU1LY0JJN1B6WHhma3hIYWpyQjJuK2E1dkZnVVR5RTFPa3dj?=
 =?utf-8?B?R1dNN3ZQakhoZ1RYV3JQV0cwWXFSZ1VrVE9yZDYxcS9weUprR05LQmZZRXpU?=
 =?utf-8?B?VTBaNmUxR0ZPVk1ISlJXU3MrdHRyNTRVcWo0bTdma0RTakxEZHk5WG10dmMx?=
 =?utf-8?B?d21nK1d0RWVJZ2YrM0lPc1ZPTzA1UkZPN1FtdUNKS3A3TzhtdnlvRExVMTlT?=
 =?utf-8?B?eU93Zms3SmFnOHlDRFZDbHRVVngxejFidTJ4Uy9wVXY3T3R4UnNLME82ZEJl?=
 =?utf-8?B?dE9ROUJJcWwxOXBxUmRxa2RKUFluRmVwNHJuV0JWRVFURWpoZ0NqZGRmb2tW?=
 =?utf-8?B?YVRVam5LR0lpaXowV242ZGJpQ2llTktGWXEvU3ZCZVJFdjBsUzkwL1RWbFk5?=
 =?utf-8?B?M1FJelBGS1FHUHpaNVhIdEFLREZDQ3hEOTlZbWx3ekdDWDhGMHhjSHFEdUtK?=
 =?utf-8?B?MHdpcUlnQTBXWHVtNXowOVZUdHV1cFNIR1BRbkJBSkJzVUduRDdmcjdPemxl?=
 =?utf-8?B?N2lNbjdZK3JIWDIwTjNnU3pvaXJXL010WS9aV1Z1OTJBcFdaeEhqalZCb0NO?=
 =?utf-8?B?ZGZLRUJDRHZLdzNTQTZNWmNHZlBmRVpyTWxOdjBja3l4MGhxblFEcGxzakpY?=
 =?utf-8?B?VGFCTEFxTUtEWWU2Q0RwT3ZpOGdMVkxUS0hSS3VzRlA1S1I3ZVlzTTdseXV4?=
 =?utf-8?B?ZGFnVEtoV0dEQWR6Y0RHNVV6RFJ6WmhuK2RVNm1BVCt6aStiOEpqeXovcFNS?=
 =?utf-8?B?TmYxcCtzczV5enp3UC9zYWYzUnVQUlplMkF2bmswZUprRVlDb1NXc0txejN0?=
 =?utf-8?B?ajA5bFZyRXRoOElZU2VHWEVyMmd6cXZhMzkxMEFQbWJPQlZqU3BvVUtXMDg0?=
 =?utf-8?B?c0NsbmxwamtWcW1sQ3VGeVBiaTFlZ2I0Z2hIYWtPZ3FHT2UzWUp6N0hvN3Nn?=
 =?utf-8?B?MTcxN1FvZVJ3cmRSR0wzRXFTS2hrMEdrcXg4ZWxmQUxidUV4UU1PanBnWEdP?=
 =?utf-8?B?MTNhVVUyN3M0dnB6YTY2WnE3cG5ZSmdPL1RaaHdubjBkcWFQMWNLdzErZGpq?=
 =?utf-8?B?TFFpTUNnTUhjMHVLMUJIdWFmc05Ud1R0RXVudm1pS01wbHlNaTdNc2xVT0ZO?=
 =?utf-8?B?UHUvSWVsbTl6aUhXOHY2NVN2L3crK0Y0SHVIRjdteko4Z1B6S1ZwQlR0Nzlz?=
 =?utf-8?B?VnV1cDhHeGZhWkRJYUdkM2d3aytsN2dkTzA3R3NWT3gxVHNvbU92V2NScHdK?=
 =?utf-8?B?MEhMbDZnQ0FjZEd3eTZxdHZnaW5DdTFNMFovdTZMMWU3Q2M4Q1VTeWpoR21M?=
 =?utf-8?B?cWlGaE9GRUxpMC9rWjdmL3pYaDJ2czl6Ti8vTndPZEFTTmNJY1AyY0UwdERF?=
 =?utf-8?B?c01yL1o2SG9wcTdTVWpQWTZwemk1cjk2ZWNVN2lZeDdsODN5OEorR0l1R3Rt?=
 =?utf-8?B?WEcxdStxWXNVeWMwWjVZaFV6SnkzV1IrelkxbXdyaGNLUE95WWhRSENVSFVk?=
 =?utf-8?B?d2hDV0FubUxHV2ZkMGQ2bmx2ZlB4eTgvU0Q5T1NGSEY4bmRRQUNaYndQNll2?=
 =?utf-8?B?NnZPQnByRlBFeFY5NUJ2eVIvV1k4OXBPZk9pNUFPYXRRN0RJenVTK0RodzF0?=
 =?utf-8?B?eDFVcU9rc1J2emhwZDVMME9FcFd2QVovdi95YWRGTnpxTUk1ektzeGpyTEtw?=
 =?utf-8?B?K0RrdFdKbnpzTDRRNnpVNkVVR1FFbVp0MFNqdE9YeDJZdUlDY1BBdHVXUFFn?=
 =?utf-8?B?Y1YyWTlZSXN4ZEJjVXAyUHRIZnZLckFHWEp3WVZYdXlmYWdUYkhpN0tLZm9n?=
 =?utf-8?B?aWFnbElyTXpmRFN2Z2tENVdwcjkrWWhzZ00yUmdGb3E1b3d0R3J4cVdTTTlk?=
 =?utf-8?B?ODVEYkg0ZTBiWFVMYm5NSnJhcXhqSGdRaHRJQ0ozb010R1hRVHJYbDhNRUpT?=
 =?utf-8?B?dU5mOFNORkNlMitlTm5OcENZMjMxMHA3NXpaUDBDWmNwOGpMeVUwcWtSWkZC?=
 =?utf-8?B?NjlQcnlLekkwOWlzcHU1WC9VUDJzYmtwUUpuYzkyTlhnVDl1b1Fadk1CNWNh?=
 =?utf-8?B?VnhDNlg4UTJEMWRlNFA1UDRYZlRWL0V4RVF2aDM2SS9YWnY5dkNvbE5jUDZY?=
 =?utf-8?B?U0x4NzNxNjE4cUJUUGd2bzlPOWU2VWs0L1J4ZlBEdEFGSXQvS3RFNE9OdWs3?=
 =?utf-8?B?R21uNFg2NDFqZjJzOTdCYmtNcXNNcHZmRjE4Qzl5QjczdnlNZktSSUVmQ0gx?=
 =?utf-8?B?ZXNubjkxMm56Y3liWVpUTnU5ZEVId0VRbzBxZjF1K25UUEJuck9vSTA1VEc4?=
 =?utf-8?Q?kwnSiihnapM736Oc=3D?=
X-Exchange-RoutingPolicyChecked: LZJoZ3wwyyqxv9XtmZqnmWIrRuBpDDnvqQAYGD1OQw74uroFcHaWMMcdps4Ou/22rRna814JeFqZwC2q/S/ESUQcxl1eKJdKpsj3m58NJ7+NZDFtEz+cd41DNxf0G5Zr7ITlEVHwsNSkLb6W0sSF9TIAmsmWDFqx78HEB+8sCIFqzhJ/HXlX0c0vfS+i2a751OtgonRHnqMeOjmdUGFCQYcjay4Q/lZ010WtHGA7waoWjYDNlmQTepp+X/qZxx9wYzZ556Bm/RbkexMOlVfn26Q5deaddhZ+vKFJ/haXt0fojccCZgskADJu9mPVFU9JoMDrzUuK7FQGSTxoIcyuiw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d6ed7b-966b-488d-1694-08df1a50d20e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:30:53.5458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yI3LksUSPo7NHuhcegaLxJaBoukk7y/p39xXcnI33xEIYtjqcHtkxBke3uDg5YX8jM7rWfWV01jyL3tBR5UwyNUaBoOlr6zxCwRes545rrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6018
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> resctrl_mon_capable() indicates whether any monitoring resources
> are enabled on the system. It does this by scanning all resources.
> 
> Redundant calls to resctrl_mon_capable() in hot code paths should
> be eliminated. There are two prime examples:

All of the context is still just focused on resctrl_mon_capable() while
this change expanded its scope to also include resctrl_alloc_capable().

The resctrl_alloc_capable() change does not fall into the "redundant"
(per subject and in changelog) category though but is a user visible bugfix.
Considering this, should it be an explicit fix (with "Fixes:" tag) at
the beginning of the series? 

> 
> 1) mbm_handle_overflow()
> This function is called once per second from worker threads running on
> each L3 domain. resctrl_mon_capable() is clearly redundant because worker
> threads are only created if the MBM monitoring feature is enabled.
> 
> 2) is_rmid_match()
> This is called for every task on the system so making it less expensive is
> appealing.  resctrl_mon_capable() is redundant because the function also
> checks "r->type == RDTMON_GROUP" and this type of group can only be created
> on systems that support monitoring.
> 
> 3) is_closid_match()
> The call to resctrl_alloc_capable() is not just redundant, it is wrong.
> On systems that only support monitoring it results in no tasks reported
> in the "tasks" file of the resctrl root directory.

Thank you for catching this and including the fix.

> 
> Remove the call to resctrl_{alloc,mon}_capable() from each of these functions.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
Patch looks good to me.

Reinette
