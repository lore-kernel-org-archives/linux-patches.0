Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203D73BBFDB
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537064; cv=fail; b=Oo2TzNQF0YLbFdsZjsqTnOwBoun2DwBtx4kgmhaHw1g4qcmEPsVXJYtjA9DnaJtJDTViQrTWCbncflqWNCEYA9RPMFpqgv/ENabf0EHmblWcqTlM+A1zrjynpFsqUcvoOE1ORpfE4RZNZegPWsPAnyzDvbbEtogMcDppASgDo/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537064; c=relaxed/simple;
	bh=+NrLiQ929IemfJwRyE1qxl7fOQzbljoFptZ2G2ywl6o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dWKXABduh1BXZddfMYg7APQGYEr8BGW9/J9TowhuqosjVQkvH2hd9kHyha2YyXAUoeStYsE2v7IVJP+qFSyEbxTnHgh2/3yt5wbCfbskzCrZZOPSXF8Ess/83Tj4T0L3Eb3crN5tqTYV4ZnsoZoE/ifKDocAY8Fa50BDuPOjb44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RtEOMvbp; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RtEOMvbp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788537061; x=1820073061;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+NrLiQ929IemfJwRyE1qxl7fOQzbljoFptZ2G2ywl6o=;
  b=RtEOMvbpx+e88eRhgWmcnSFdbyOhBwxMeHGZtkBZ8p+W+wZVY51sMZHL
   a6pCgSnL/TW7hROe+XxXNV/J/7rbgRvj+OrrekMnWC8P/6uQB6KDDaTe5
   AJkFbisaO5N/aBZM9OdGnUKroAurPQGrSGbbpU0yO1xX9SXW01WdF3xu8
   OpPI7IP2z5CRYByRi4k5oX2bkvsJA3/2pg0QGeVh1zw6hAinfYe9z8Hyl
   qUpFjiR5nKtPQ40q5DwOBw9QF+Zb+oLMjg5grbHIRAr8510jLtz+bPK4/
   rmFYuY5zKvlpRenxH2KbXzF8vTYy/QI2bcqrmHOrcqHdTIGT29pQpnDn7
   A==;
X-CSE-ConnectionGUID: 5l9nffahRRGcZ1lTBNjZdw==
X-CSE-MsgGUID: qjLldqGaS5uYIP62IFeNqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="89094600"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="89094600"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 08:51:00 -0700
X-CSE-ConnectionGUID: Y+Zs+RmbQpSw95m54FSJVQ==
X-CSE-MsgGUID: 2D89unJ9SfCuMGhyQnoUHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="268329429"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 08:51:00 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 4 Sep 2026 08:50:59 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 4 Sep 2026 08:50:59 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.61) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 4 Sep 2026 08:50:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtIqexAJkd4B/TEIdXgy/dmhxeRc7xJzp/OaHGVcPXV0G4x7tDKHUupGtnnWIWREzM/WPwebOGfu5KKgxBSux/cXQW2oSmrw4OAxCGz4cyNTKzUQcTJ0tuKNiOE8RDPAy5idYdaPV5JyYFJDlbiZSFvD8BcxxeGEPJ3RLuBw8A9Vu9hfYChgcRvLWELYIggquBQOW4iiiFCDmENYsUlhKwV+M+hTvTcEVQm0bhTb2qvHgcfw02v5gsdUCApuJoagaz6T11yqNFCexoTrr8IE+mFBLnui9USRMvYFqQ5fu9r94iRxS7ZIsXwiGW1lg10fbtwL1dB9noBEJ/nuWh8b0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXEDJqvgQS/cnAyb19AdRdeDrCvP7SH5a0fAWyIzgy8=;
 b=n4dpmi+CC4TKN4/kLrK3jCtWnM1ZtfDfL5O60uk9jBHnDUOh5lJeTOdi8f8+BlOToWLIIPGZB5zsC71z+ksjg8KeD2k/YB3qzYjOtAkzvzeZvapRkDINQI44srmlV9NgM1kNPybm2a5k3bkONMW02P+7iUhn+JdxwGUzIxqzx3c2+D+KOInL66AE39LCMAYQEQRByTBP/fT9xfmsR6TRdStUd7ugCecKy26MIFsPMBafHeWxzKEW2tqprE2IoKl2UVaUkJ/wFbz60z9afPrcI1NJ9dBCsncjElwgHqWgVfHBJrqYGJN5fnOfdPDcm7Ml5o7O3QSptscngZijHc/sdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH8PR11MB9855.namprd11.prod.outlook.com (2603:10b6:510:3c4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:50:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:50:56 +0000
Message-ID: <35759986-3bd3-4ada-b2ce-434090cdc1cb@intel.com>
Date: Fri, 4 Sep 2026 08:50:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] x86,fs/resctrl: Remove "arch_needs_linear"
To: Chen Yu <yu.c.chen@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <62904217290f2cd3225d8608c19e284d6dde3aec.1788452481.git.reinette.chatre@intel.com>
 <apo3lSWAQRRK2W_r@fengwei-dev>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <apo3lSWAQRRK2W_r@fengwei-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:303:16d::24) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH8PR11MB9855:EE_
X-MS-Office365-Filtering-Correlation-Id: d74b80c8-8183-4315-2be9-08df0a9c4f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|4143699003|11063799006|10067099003|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info: u4V0WmTbIHD/Au8rM3hyJbfc1RCen4rIrJnRubnYvD3uTgTXEO331mEDWNtOuQqPKDIe9PFVjfx29xGJJWrQ4UXH8lIniAiDWmwWaUmwTvZqxrwcYEQcrR7SEqsyOVUQXhfM+a8wmfTGLseRkbB5tRaUKozORGEQb4+BcXzapbPwdFHwVF1VYjJ/mPh4KzZd80qw1q1WsF1FIRVrhnbzczze7JW05H8BIUK8eKzumSLuCc8QT3o67OL1hzXjsgwiFFbxePTwLfS7fZGPVWZ4EKUodRdilx6zF5ZiEkL6qwFWzEs1PMfcLCW5QDCOj7cLV4HxkQ5UInk8gtXZC5b2OuiZoGa4YBmheKKIrFdSFqPzvmsF3IQ9npwk3lp/S7VlTDu9ElqxLaVQ5Gdpl7wj9RKkui5fIYdf8RViNyYGy9qCxj8HAnA3ZkGXYtPvBVpu6uOJpkjJwReM4OSIOjdexWwSid6ZqT0z6AM5NX8BedlEVTlSK10Wq8EndPW7nmm5ztGgNOB3xIl7DiMehDzeZeuDjOwkarIdMpEfFSAKXDO3DdXE4qDWG5Lz7mg0+aLH5l4Hy2H1WpnwLBGRjTrd6BgAcpYPaR+fIKqVYDujd9acuDywPPTdO6ZzGU39hP2bO3ZU/JZxiloiTpAO7Q7bXxShZV3IGqtcZC7cB1OIKXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(4143699003)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTVtS3cremxQQVVLK1ZUNjlQUnluTlQxUituWTkvV3VzNm1FaXg3ajNhcTZu?=
 =?utf-8?B?UnRCazBnbzFnYURVQUJrSjAzbFZOL3pYMkdHTk9CaStNK1BCOFZnZEpMSVpv?=
 =?utf-8?B?SkJBYWdFQ3JITkNXblN5NjN6T3E4ODV3Q3drMDRrMnlmbjZ1U2pIVkV1R2xV?=
 =?utf-8?B?K21iWVhFY0NZeVN6SlpLdGowNER0YVFBcWpLRUEwSURYN1hMcGV2Vlc3R21J?=
 =?utf-8?B?SVd0anpabHg2SHpJQ1k5aU94QXVYc1JwWFNqNUtob0JVME0ramNnREtKNFVa?=
 =?utf-8?B?bXREUUduQ3VaaTlYMDVmdUhNemZlVU81YW5VWXJpRnFPeDJvMjNiVjRSZ1oy?=
 =?utf-8?B?LzM0aGpYdUlxY0JQYVBzTjNEZVdGeXhhdmxCSEtkRkEvVzZmYjc5UTU4ZXQ4?=
 =?utf-8?B?SkVack5RdVJ6SWZYZ2xPOG0zY1JtWjVxQXRqUnJQK0M0UFhqK2o4QTZKUjRN?=
 =?utf-8?B?dnV0NS81YjZkeiszM2RMNEp5MEpCUUorY2tWZFoxa0F0bk9VRzZnUStsYUkw?=
 =?utf-8?B?a0tsZGJ5VENRRTJaTTI3WHJrbWROcVo3RE1wSmxGaUVHZmlDdTVPajI3R0lH?=
 =?utf-8?B?ZEJZbVhWckprUWtwTzRIU3VTUitydWtZaHNGR3hJK2lRS2k0QWZKenJCQnVu?=
 =?utf-8?B?TzdGSDVVYUx3YWwxdFd1d2hFaEF0K1dFMno3Wno2dCsvVWxhZFU0U3JOWXh4?=
 =?utf-8?B?c2dyTVYwcXpkZkEwcHZya1JUY1d4b1ZGTmtuRXBwZW5Cdm5tWVIrUC9GcXZ0?=
 =?utf-8?B?RUptV3pWN2F2ZDRTbDFFU2Y2aVF6ZnoxR3dPcDgyTm5YZXB0OUVrdXpxTk01?=
 =?utf-8?B?SWZhbVcxNG5BT1Y2T1NDMFUzUWRTeXpJcEtlbmx3ODZCQzdqRHVVN2wvempR?=
 =?utf-8?B?NkJuZm9mREFMdzdZblNQQ1doR2Jza2w2eXNSVCtsQTZsMlpFamRwVWRJelRG?=
 =?utf-8?B?RkR0R0hYU1lQS1I3OE95ZUdOUWxNOU80VmZlM2JudXRKTnhCbmNxWWxTenlj?=
 =?utf-8?B?K0MveG5rd1BkQXFUZEVpQUM4RlhXNjYxNUZjUmNpWmpFVjhHbTdOamZ0ZUpV?=
 =?utf-8?B?SmVmV0xQNDE5RUdaMXNPbDFIOExCSjRmQ1FIWVorZjZrL3BkU28zUmNoQTFZ?=
 =?utf-8?B?bWFVNXZveHZvQTI3RURobWdhYjk4LzFVL3NzeUEyYzlYNTRQRUZOUUo2YUNV?=
 =?utf-8?B?ZDdlajJlSEtISUJXUCtub0xRdUE5cFFhS0VJME9qa3gxNmVGMkRCYWFhdCsw?=
 =?utf-8?B?UkFqbVBIcy9lY3VzOVptVlJrZTRIdEJIcy80RFNyMEkzME5qTGIxSmdaVGo3?=
 =?utf-8?B?THd2SERyRmo2enRieUpZNmZobWtZc2lkaTIwSzVIcG1XWDFqZ2oxQXpSLzdI?=
 =?utf-8?B?WXZSYkpoWlFndDJwaFRVb2N6bTFleHVhMEw0ZklDYlJrVWExOEl2NXhsR2hz?=
 =?utf-8?B?MDNmZzRLejg4QlRzYlZQRit5VnlTUlhSbE9IZnZkRTUzS1ZyTkhYbFZhbFl4?=
 =?utf-8?B?SUFPUFJwaHRoc25HLzVnYVlCOGNYTGZHZFl6VCs2TDNhQXNmVUNvSEFsd2tV?=
 =?utf-8?B?b0lZaDZIY2VFaU1TSWdmNFZXOEVxN2FoSjFXbXhMM2JBZEkrcmNCR3YrV2tk?=
 =?utf-8?B?SHJUanRZS0J1TmtWV1FlQ1A0ZUdBdVZVZkpxV1phVWxONjM2SmN2bmdhWlcy?=
 =?utf-8?B?ZGtVK0c5NVY1dWwwUHNEOVByWlh1c0dmS1p5dXhiY1lHVzRnM1gyNitqLzlF?=
 =?utf-8?B?UGJ4OVRvcVNUVmJQL3pLQ2RoUlI3ZlFUS0h5eHo5MXB5NW1oSGNVSnQ5dFFk?=
 =?utf-8?B?KzNzMVpTMnh2eVE1RW1IWkVlaStaMG04RDNlT1lSQ1NpS2dzN09ySnBnOGlo?=
 =?utf-8?B?NlJmTGFCMVJudmJhVGRaM1l4U2M4YjdwQkowb2lyNnNqM2dmS3ZMRS93MFJE?=
 =?utf-8?B?N2hJcUcrZjAydXYyWDJRT0s2WkdLbGFjSlE5TVJqUVFsMU5qdVdQa0VQZkZq?=
 =?utf-8?B?TW91cFgyWHpOb3NXM2xUcExUMVNicFlMSVp0YWZ3SnNKL0FrWVNFWFFFTk50?=
 =?utf-8?B?clFrNmk2MWRQajZ4M2dJUjFlUG5ObWFrbzZMMlViUjZGak55OE5OUkJnQzR1?=
 =?utf-8?B?UXpJenNvK3hJVUZxNFBONit3eGg1TUtXRWxFMjgwRmgvaFVnQ24zRWx2U2hN?=
 =?utf-8?B?eFVaSE5vdnhBVVBXQURFdS9xRXdQSTN2OGtNbVR6N0F1YnhKM3Vua0lEeW9N?=
 =?utf-8?B?Q25MU3E5NjVqT29MNUFxTjhTRWdOQ3BFNWdCR1B1Yit6VW1oMmQySWFCZ3VK?=
 =?utf-8?B?alhUYi84TmNEN29lcHE1Q09CVjlCc0tNTDR4d3F1YmNtRXBnL2R1VVA3Y1Vp?=
 =?utf-8?Q?Qhp0hmBy+H+iDscI=3D?=
X-Exchange-RoutingPolicyChecked: IFxqJlac/az0PRe7eYRzjuv3N/hf2eFKG+KaqD06JLDPdZkl+TCBd5yNeWouqAegoovIDbSyduGgyhkSPprqemCTNRxz9cXxQ+x9Q8s3XAukR1aQVBS6lFl+vKfGT6O3DA7xszxVoU4awLh0OSbBovdEGi9/JUK/9PGRXCAptci/9u2R/ZJxbn6dnxx4JehVUCzMhLqW1FELOznFVYV3RHehZgPek7biP2BKOGlLAGidnbu0Fs+FO0InjNPULCUe29q+Nq73jA3WqFBcnac3LjOn2B9G5SOv/iF3dfxusa0HioTjzj2+l0mdhrr9k6L2DruCLqStD0v20SXPnLwZ2g==
X-MS-Exchange-CrossTenant-Network-Message-Id: d74b80c8-8183-4315-2be9-08df0a9c4f08
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:50:56.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQXahEhk109r+gOIpfvyrWIxkwG88MC0EbywTuC8JRrX4ex+IIt0/C9ruSAsP3+LqPAyi6LnWfS8P/LXIND9j3eVcwU6eFCLdvHN4XZ2r9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9855
X-OriginatorOrg: intel.com

Hi Chenyu,

On 9/3/26 8:14 PM, Chen Yu wrote:
> Hi Reinette,
> 
> On Thu, Sep 03, 2026 at 09:57:04AM -0700, Reinette Chatre wrote:
> 
> [ ... ]
> 
>>  static __init bool __get_mem_config_intel(struct rdt_resource *r)
>>  {
>>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>> @@ -213,16 +192,13 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
>>  	hw_res->num_closid = edx.split.cos_max + 1;
>>  	max_delay = eax.split.max_delay + 1;
>>  	r->membw.max_bw = MAX_MBA_BW;
>> -	r->membw.arch_needs_linear = true;
>> -	if (ecx & MBA_IS_LINEAR) {
>> -		r->membw.delay_linear = true;
>> -		r->membw.min_bw = MAX_MBA_BW - max_delay;
>> -		r->membw.bw_gran = MAX_MBA_BW - max_delay;
>> -	} else {
>> -		if (!rdt_get_mb_table(r))
>> -			return false;
>> -		r->membw.arch_needs_linear = false;
>> -	}
>> +
>> +	if (!(ecx & MBA_IS_LINEAR))
> 
> Maybe also print the following from rdt_get_mb_table()?
> 	pr_info("MBA b/w map not implemented for cpu:%d, model:%d",
> 		boot_cpu_data.x86, boot_cpu_data.x86_model);
> 
> In the previous patch, a "Non Linear delay-bw map" warning is triggered
> during the actual write operation. Similarly, displaying such a message
> during bootup in this patch might also be helpful.
ok ... but who will the message be helpful to? This is a check of
hardware state, not x86 resctrl driver state as in the previous patch.

Reinette
