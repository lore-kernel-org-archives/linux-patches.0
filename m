Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BBD32B13F
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780961202; cv=fail; b=mBu2KI0UIQBleTnEK3A/uCjzMJCv122ULdsXDzDyHMotRtLzqkzPVLTAWDI6extgvpTZShL9ge6ZVSzBdOjX6/iYp6i0AF2ewjW4XA1nkJSkIzIvsFNxpRDRgI479psYxqurOEN4UqcBhZrIJXF0fbzPlwq+7j5E4dDZcjReBOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780961202; c=relaxed/simple;
	bh=ukUljzeyJhfYgv3VqdjjoUTCstFKt5bi+yLvLxqRrlk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OlDQFSYd5QCMzXIkN/3h1fiCqHgFr/z1SZf90UfyhrtngtUOrWWg7osgPp7xelWq8Ba5Lghd4dWWpAmcEi3x0r+zxYU1ee2nc3mvT+Qv6PxQHu9xyQzMaAPip7sKIviLb1znAZ2vpiO6hNekwkxtlskiDG99zq4yhVCPHC+SdNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SbDJmfNt; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SbDJmfNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780961201; x=1812497201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ukUljzeyJhfYgv3VqdjjoUTCstFKt5bi+yLvLxqRrlk=;
  b=SbDJmfNtnmWeFmForJe6wYfWtTrA8v6yJzrfiyx34048D5kD66bOIpfo
   PIMZ3yt8oCHGR9fXIp/F8wpAXzTfReAuIAfH9yK+BpFD05KNc/xHWHyHa
   9RxsSjQDYy7iJoxOvmGSBllip2n8KvMYyd6Mb3p0S8dblpmAQ72DwSR3K
   OWVzJ0rDbX2xEXPLDSFSMJBRkz/kH8rrtSWbExrRMQevmBlCdiLgD1ySD
   J8j3OMpQdh88clEzZNCMQdwasEd/D53xFJlX4EPu+YM1q5a+LbIWGRZKh
   /RYJlZUQlRQy5INkkp3Z8ADxbgKeX5owmfMT8AAUTuRG6/t/QFY519asK
   g==;
X-CSE-ConnectionGUID: nnUes9HrTBmhz1doDCc47Q==
X-CSE-MsgGUID: gDsWDSU+T36Fk8e7vE5uPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="85603183"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="85603183"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:26:41 -0700
X-CSE-ConnectionGUID: ikCQRXctQKSPaII7o3FVeg==
X-CSE-MsgGUID: H5UXTZWLTDGtOBuLKKBpLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="250614049"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:26:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:26:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:26:40 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uA3n/CL6Ii6HycbkfFXPRVlAQv76HYEZBd9i/fkWXdgzRtigFun+c5La8t9SZ7h0TORlqhMLtxX73OCj2wMt26WJqtYnPl0ZmOFX3x2uJbkxUi3eIW/3pADXMIVDgOu2ypuCD2wbeQueRMzqQDGv8VtvnVAyUgZPdPlMeHmCHSPXf+20hfA6vFW+TXejMfbXkd+y8gEFQudpJguZhaWSJTJ6CtCzwXAvFGWpOTja28Cxp9VGwbShl3IqEM20F350XUWye2PBbiOdGNeHWV6abDFMt5ym3Lqe5rNeET5wuSbPPnajFumC0+XQ356QMVZmfAwVzUC+xCfCcBf2DHk/lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/qk7TGacKOtmCdq2pbsqlz569inOvtg+96eHugwKdc=;
 b=b7zDjjPp8ashtyUdwLa25UWabQP4AZOFtPsWCWgP272s79q0cpGmhD7JzC+0TjmxpTpA41eTZ+Z91Y4lCzO3UYs7i2MER+JYIIu2W5ZIfxEh9mv1+7sMY4idCex/qkk/7Hpplw+35TiVzNfoVyc81sRWdcP76dw6Z+u9FxsIO7j+TBFP/M7UI86eMotrQXdiRyeXnb+X4BoEGrQSrN0jbAxMlR9E/af4HjMYHj1XeG7NnKCi0LuWYGygRNJcbfCof8c+Q8E8i8nH040+6O5nV5dnkH35/KX8922l8ds9kj7xYPtUIyoV3zZmoeLZ46L2jSsS5UpVP+r9Zx30FqBEcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB7581.namprd11.prod.outlook.com (2603:10b6:806:31b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 23:26:38 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:26:38 +0000
Message-ID: <4121f521-830d-4483-9305-efa31cef0f3f@intel.com>
Date: Mon, 8 Jun 2026 16:26:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/14] Documentation/filesystems/resctrl: Add footnote
 for telemetry fstab mount caveat
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:303:6b::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f54f078-032b-46ac-b0da-08dec5b56355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|11063799006|4143699003|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 47QYtApcl1lTrsOUEm1ZhDJPlGpuW4NKAxMn6CXIueNc/Iw22SjCa2lDEnxcf5pKYk/AhjZcAk5kvMhe1qzGzQp8W285RJhUDhzZeGUPo1oKqWYAtglB1+PT+hEw2307CUWBYHVsdVQwQjLRPCwLbZWiVKaQiAl3XHh4mGFwjKCeP9dalqjludMFEhiYmDf4AOnzCmpuJ7S34f1E0C8naTOTw9bl2ZIHv5+NRmO8kQOdnyP4i69a2xGCrb8jv/IG1GlodzTozLm9cUI29daDMue4OyU0PaIJw8MA5Oxfr0fr0f0XLPERxOiJ9DHmOADohkBiBn5Q7Kcl7FWrj5AWPXRaIVbs3810n8zzIDx34ywGNSZvjWTifpNoXndghsxzkG4eaTINrr2KQ+kNkCKGSjOCKZ4D88lyQKEGu1UX1v5auJKLLsQ7klw+8Mdvh9j3i9q4AAU+uUrsGy+eO+Ov1GspymRc4sGsCJpsmDjr/VrRpdzAS0hdwlrgAwgoID0I6hs6jApjLicgSpS6g2fFb3rH8/gUMPTPu/j7izXmcHmZFsQYPIUdNS3kpREQWZ4LhbP7Cwhfiqmp/tX7rqXmjzaO+1MJYCvIS2G4oHZNtxqHi5cfIYAg8hoqPWuFWKQgnDfLLp0kEIfNE3JYE1MrsLZnY5xG4B+qvN34NkaH0JF1wHYdcDfzVztKWwkvirC9nBxlyKfhi1B49ieBrrYHCzAmmyIsvH12WlsdJV4TRMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(4143699003)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnBQV0JzOHRXelo3aCtCRzIzRWFPOENjQzRLbTIyZ2dNem5pSEZPK3FnVklH?=
 =?utf-8?B?cDgwNnJuWDZjbVF2SXlvNzlSOTd6amJMYzVNNkc2Ni8wYnkyTzlzMmhxanVi?=
 =?utf-8?B?dTRDVkt1RE9mbDlBampvRHljb3ZOSkphT2FjTFFUdHFrNzVKRHhadnJpckhm?=
 =?utf-8?B?cDNUT0RMQXZBajRGNEJxM0V1VnE3RnFGQi82WHZqemhmSHhPR1J2RVJuR3N1?=
 =?utf-8?B?dkRBa09idi9vUURXcEJ5a3NNZzJWdEFwMU9nTGJvY3I0TmdsZDI1dzF0UEpC?=
 =?utf-8?B?U0VoZmJObllIZmxZNkU4L09yVTBJVGNJQjRYL2J6cWVCRmMyTmFqSUZyK0Fw?=
 =?utf-8?B?L1RhemRaMGlNcHY1OFJFRnZqQTVjalZINWZvQW9UeVJucXk4MEpYOFhrVmVH?=
 =?utf-8?B?MnY2TXpBbkhUTVR0ZlB2bWxpVVRXUVYycXVUc1RvNzlIZ0ZwQ1FXZjdCR1Mr?=
 =?utf-8?B?RjM4K0J0eDVUaXFPdkk4MGpsTlFaSGVjcFdDcUtWd2RSZzZ1YkJ2bWxnSUQ5?=
 =?utf-8?B?WExxTTZhMjFlQm5sQ0ZrRWJjbTRmT0RpeTcxNHhrRTVHSktXVjlRUEpPVzdi?=
 =?utf-8?B?QXhPUnhzczlUeFo5eUVyYXcwbHA1WE5oaTgweURJaXZ2bWdNZDFqc290eFN0?=
 =?utf-8?B?eTdDVVNGN2tUYlEwK1Z4dThHeWZlNnppaFZQa1pIcHJlbU1XQ1hLbFNod1JP?=
 =?utf-8?B?dlltZGJUMlZVaitDWk13dlpoNFhTMVNrVnpmZlZ3bGJhRDIrVmkxR2N5bGFa?=
 =?utf-8?B?V2JHUnJjRkpnSWFlRXlCeXR6RGs0OW50Z055YWIvNmNPL2h0aXhUeGh6Sklp?=
 =?utf-8?B?NC9ETEsxYnYzR1ROWXFmdWdxZ3RCWTFaUHQ1TWZHSzBiUGd4QW9GTXZqUDE3?=
 =?utf-8?B?c01BbHhHWVo5dHJuZkUvR2QyNi9BRXg3SjFlYmdBOUx2LzNvVHcrMlRhcDV1?=
 =?utf-8?B?MlQwMXkzNCtKL3U5NmJ0NldjWHBQeEtPeC9mN21maDZvWi8wczdqT3oyaklG?=
 =?utf-8?B?andHT1lsMnpieDZmaElLbTE5VFBtY0EyNE5zVEZ6QzZOWWhaVEhRc0lkSkNy?=
 =?utf-8?B?UUhyOFErODR2VnJYczc2LzNIcGV2NHZpZHFKZTA0Njg0VjVUa0FUa21UQTlR?=
 =?utf-8?B?TDhKaTNMRXdaNUwreUwwNXdZQnZUMnc4cGxtVms3UENkVll1YjhxNTRvUDJV?=
 =?utf-8?B?UHFiNk1kTUoyMCtWbmtLYmtzUTJ1cXNSWEpQakFRUFEzSVBtSnZFcHo5VURC?=
 =?utf-8?B?UUFRem5keWR5aVlQTXNPcFNSZ2xsQ0lQSWNTKzNRUm5rUzhuSnlvbWQyOEtx?=
 =?utf-8?B?TGlQWHdtcS9KL1RmYzByNGcvV1dCL3Vrdm8rS3hyeXV5SjZXemN4dFF0cHhs?=
 =?utf-8?B?ZXgrRW5MR2tVdVlmYUNBUTlXZFNzMitPNWY3QTMrUTMyYmM0OWk2RnJrNC91?=
 =?utf-8?B?Z1FNTUQvWmNYSDZqYlZRVnh6M2FKNnBHZTdiZmord2FoSVRwdkhkWHl2emEv?=
 =?utf-8?B?dDZ2eU9rb01HbXRZSWJNOUIwc3gvbk9Nb3pUcFh4WTBrVTRZMFhMd0Z1Skcy?=
 =?utf-8?B?Uk50WWg1SmJaWVpINm5kWTdvZlFQOXBYZ3NuemhFT29obUlXYWJ1amgyZFZI?=
 =?utf-8?B?WXNYalNzbldTSTJJU3ZiMGxSczlRNzloaGgrVG5laEQvdlVFa1lWVmxnVHNC?=
 =?utf-8?B?OEpUVjRxMjYwUGFnczMxc3VNaHdYUUdEUGlZbXBpQkJ0RzIwS0xBUnN6bVZP?=
 =?utf-8?B?THVyNkV0aWpLYmMyeEVmNXJxREppdjFGazlQcWZvV1FvOUZENlBLYmVWbWZx?=
 =?utf-8?B?MDZtRkpPUUFaaXY1ellkdE1nUVdjWFFPMnhCOHl4Slg0OWR2V3QxRXVMMWtU?=
 =?utf-8?B?YW1sWXEyUTBMcHJxMUNEcWtBUnN3enAzZVZUcEdXbjMzZ1ZkT1JSRUlmcjlB?=
 =?utf-8?B?QmFFOVRDcnhMMVdBbGhSUElSNDVXYU0vM21yQ1hYRm5zd0QxeGJBd1cwV213?=
 =?utf-8?B?Z3RoL3g2bUdrUTQrUmwzaDE3ZHcrQzVJZkZDc0xSN3JxSTY5TkdrY21id0dw?=
 =?utf-8?B?cGoyN2dVaGlZUE9uQzNtaFJLSnV6b284dlpsT1I4M3cwd0tpOFFDOHYySFlS?=
 =?utf-8?B?MVAyTHRwRUphc3lMdnlzNGEzRUI0YTNOZ1VlUzQyTnFaK3piNDY2WjhrM01v?=
 =?utf-8?B?S2puSXMvZXNyVU94TE9ObTRoY09MSW8wZlRmclRYNGI0QTc0RTgzcUFTbnND?=
 =?utf-8?B?NDlOalZxWG9DamtkbTNYRmkvb3NUTlhFTzlNYUJsZDd2alZjWlQ1eDY1d3hz?=
 =?utf-8?B?all3aVE5cVZnQmtwZlVpK1BLVkJadHhJK0JocWdOOU9iWjB3K2JBVVM1dmdi?=
 =?utf-8?Q?7Nvrj5lIrb0vDK70=3D?=
X-Exchange-RoutingPolicyChecked: fiTBPPsN3BQ/kI3SIPzUH/etm3n5523U+pTF0Fu14iVDl7qm/OEQ4Sge8SDy59px/H/Ajx8J5qA1Oj0Ha/tm0SZ0KHFIriBmhFlLoHLdVUZR0yRsEaQR9EVytxK0BRcGVx3Nx8ScDrOK19tTcQpqPmGXe3pcjS28xURG8I+mnAE3qn4HBf5ywWcNdIRUKVFL3m+k4l9Tp5kKGbMQ0Xv39MqBFYYa0TAnwk4a6jVnc+iOQm12QS4/iiIT7FeSxfiGT+2gzAjb5qKtZyC5Aj513RqoZ/h+cSVvD5kcxgkiGw1HlIuqxjqNx1pIXgNNs0vH3ptTZvcIinX7BvfR9GB2WA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f54f078-032b-46ac-b0da-08dec5b56355
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:26:38.1134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIhX+oswBFVRA0376/tetES7+Imj+0HYEdMGuAuIa1YFHRVYNfl4XMs/BmsPces83o+mh7wXOwWdmDFIMCx94paaBxg4QoqZncsfzRNnIYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7581
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> Add a footnote to the 'If telemetry monitoring is enabled' sentence noting
> that because PMT driver enumerates telemetry features asynchronously, an
> automatic mount of resctrl from /etc/fstab at boot may occur before those
> features are available, resulting in them not being enabled.
> 
> Assisted-by: Claude:Sonnet_4.6
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index b003bed339fd..4e62b8c5e0d6 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -620,7 +620,7 @@ When monitoring is enabled all MON groups will also contain:
>  	each instance of an L3 cache. Each directory contains files for the enabled
>  	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
>  
> -	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
> +	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
>  	directory for each physical processor package. Each directory contains
>  	files for the enabled telemetry events (e.g. "core_energy". "activity",
>  	"uops_retired", etc.)
> @@ -659,6 +659,11 @@ When monitoring is enabled all MON groups will also contain:
>  	returned if the MBM event does not have an assigned counter in the
>  	CTRL_MON group nor in any of its associated MON groups.
>  
> +.. [#] Telemetry features are enumerated asynchronously by the PMT driver. If
> +   resctrl is automatically mounted from ``/etc/fstab`` at boot, the telemetry
> +   features may not yet be available at mount time and will therefore not be
> +   enabled.

Would it be helpful to add a snippet that explains that in this scenario telemetry
features could be enabled on resctrl remount?

> +
>  "mon_hw_id":
>  	Available only with debug option. The identifier used by hardware
>  	for the monitor group. On x86 this is the RMID.

Reinette
