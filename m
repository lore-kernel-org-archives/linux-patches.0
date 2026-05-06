Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9012E1EFC
	for <patches@lists.linux.dev>; Wed,  6 May 2026 20:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778097785; cv=fail; b=H+FR+JLxZ8h1D8QA9sf6d6hIyS68ty+l5go4dDC7X4me1Mf9uYs6tDLyjjUb2En2IPV8Yk1RDJ6xtIr+cIp/T/dbzXypAGkvjDRG+HzTHKB2792KxjEdvqAfAn/0+Rlot2toIAO68fL0HDqrBLKwwn7viFBYqyAqrpXDuz13k3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778097785; c=relaxed/simple;
	bh=7EITs5kp+pn8pjArPx52Lyf3ISg1Mdfjs5U4sGiCFLc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FC71o2iYkkcxHEGX9xpd17nVs4zI4SpDsTYmPRpT7lAgePa28HnHSGfi7kwhAY5MvmiI8N34wGKm+4AhlHaSzke8sI3rtXFzrdpjflPMVvcFOmusTJ+gMeOugW3G2WsiDZUHV8Q4lSgLcLwAgi1uRCgdoEDqO/w94RmDvb3bz2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZQU3tcY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZQU3tcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778097785; x=1809633785;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7EITs5kp+pn8pjArPx52Lyf3ISg1Mdfjs5U4sGiCFLc=;
  b=RZQU3tcYWulnoTgKSkVm6euLz3tBsUfjt1IM+zWWLn2FM5W3WdDqgc3L
   b6+QfvTw5WT1AWbH8EPFtlcoL3bg0zdd/1XCfKJpCUpm5L2OTr90XRsYc
   icEDp5+wYtCqky1+iGPI6h/JRssDfSFciyj+sAmr32NCcVls7hflqsiaV
   6p3+Xr4YiOuAfFO/c/HyzOAM83vBNU/B/5XLX8k4DCheY+1UkNJdV7Utc
   8/hmyLVM/7z5uX/XpjXf93cLUStVRSmNxpxE2frixZ2pPS5XGgwjQW0EV
   DBZXkwYHiJHgDQULAvhbBXvq4KrpruwXjL7fX/mVUUNJuD+D11/XBLgcp
   g==;
X-CSE-ConnectionGUID: Hf8pimrqQJWOm4GLvC6VDg==
X-CSE-MsgGUID: wGjufqY6R1u0kX831Q1Jig==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="90497540"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="90497540"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:03:04 -0700
X-CSE-ConnectionGUID: L9k70uYaQKWok8t4U4jf7w==
X-CSE-MsgGUID: HyGprYphS2WRclv2D1X4Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="274364940"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:03:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 13:03:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 13:03:03 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.19) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 13:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=how3OvB8P2bMm1ikoFFQKUVhVirq/T1GoLO0Ug57N2Oir0Iot/hWvTxrFrUxYXDOjnWEytOOIg5xy6zXP2UZjmFnV07ANb+6PdvSIg4QxHKKyHpulBZ9c/lEEwHk17nKzY8bT7WdcgpMLhSPxp4Hbg9ebYdTTYRDnZdPWkuWWx3u+tsTTXCQUMH/+4Burb1PrDXZaOdVEFGNSd3xXwvpXPG08QqtL+rQ914s8Sr7BnNF88qN4KwQJCVOTQnYkrS8R4I/QdEJYp9jnVDBxv9i7NAfar0M0uofLNWBucK3ijspReIR2w/TACOvMbH/YxKE0bulUTlElkyTqkJCE5pp9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIRR9Qt2rP9wY3RyOn6lD+sr1vNMcQzDIHm8TLMacJo=;
 b=kTeHkk4LoBGqPVLd+rFuELCDkGb5Qe/8+FuWDZtusc22Uw/ypSWikuAfHIojAsifCNo/aYsxDtOou6/uN7cTtF9lTY2RwHXlDfbfgyNJmDuYJVW1de/kQAQNodcjb18Hx8WqpMlt3eK82sD7WydLdykcJbM9WVKE7/rtDU9Hp4pidJq0Dh3tQ7NbLRMSwZlN3hjIuFfRpUTBEbQZhGdWVLBVi1frMnWUPlGgkcZn+JTainBmPZ+UrPf2UqtVULkasP7HlwXQv99iWlizBQvCFX7Bp/k8bn2eJUUfN+mV2aDJMAqlUNHq/IuYYfXcQ/V7cZasfq8YIrcE/nGNebSVvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4758.namprd11.prod.outlook.com (2603:10b6:208:260::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Wed, 6 May
 2026 20:02:59 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 20:02:59 +0000
Date: Wed, 6 May 2026 13:02:57 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Message-ID: <afuecal0x8_2jcUq@agluck-desk3>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4758:EE_
X-MS-Office365-Filtering-Correlation-Id: f17c401a-654e-47b4-6728-08deabaa7894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: cBbXQg9G2uubXzn39emZ02LzKjxhGGOqAyZ1oOsKD7CMQubyRBuQkI2dBgT8I6/TOxQaQOKcLSKPYCjD98tx0H+uIApDlBG4UTZLQyGKixyUlmCGEIi4M4yNRVW8W+UZDFaZPyqFtrTop65a/lL6Yx2YuCGiQTUU7QaHKO97bOWLC79RhMysxaxtTM6kmzDk7sHzhJTEh8nNeE+/nXeXUCVxImI5vVHeGNCPDW+6GXuqB9NnqDjatj0AHUjNcg3AEncfG5D0HRi4rVoWrnTe6zf9gN+Cc628w4R6+OzXTjtn9t0KlPBvtywsybW3Bbm0Dod5hcE8PYfNBV09ThdvgX0BmslcAi7NrsB5V8AERuCwB3GU7O4gHPabXSEkMkVbIn+O1Bm4C5GSUoCc+On8qUJclisq7euN/7uJyPMRYBpvI6Ui8v2Klk88zsSohMoQT56X7RJeIxrasJ9mvq7uYP5iUN9+68NUqnpZAxJplohbd2aWQ3oJX4sdwmE4xAMCGzQ4WEHnPnXCgPdjxyjPfW1yL0fvUcm7cdQXSHPdg4r2fPJSRTTE9P5bxnXD764zLrmI/9fx5EMJpgvgwMmTiq5n59qHCFUaJZYBshT+mt6fS3X0ffgpjP7zsmaw7q1j7hVc63WHPXaZ2obmzxXDVXbHZTh5O3YzR5hlsaRd4HQcMMXuABxK3SVfeiQJR+6s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0FMcLIRq+taiV4hIY2t7uaBUUuUj0N9tHBmx5v0Qw0hWU0Cnh0JfXyucp5ZW?=
 =?us-ascii?Q?Zcc0u3bXEXQPbyY93tVtgAaHlMde9PQ7z/ty952GVKtRFzF9RgAxABQLyaIE?=
 =?us-ascii?Q?0W15+UkYQ8w16LqcHei6tdukZBHaPle/ytC7yHhHDo/0LOsotsMUS5I5Qw3F?=
 =?us-ascii?Q?4eTTA0l2fTxwuYhSBvHpnQ5ItREalcrx2yOlM6CGJZftw0pqW1NT66FADJR7?=
 =?us-ascii?Q?C1WmVyG3c/kLdY6o7sXU6OpEm/hiiyF+tIxiKu5tDjkYKaQqsObOmDAZyZ9/?=
 =?us-ascii?Q?Chv5UK6ktIHl0z5ibuLD4nBw0NQPIHBUW7wEqGVWaCHD/f+MWX12MrMqWjel?=
 =?us-ascii?Q?GV4j/WFnNvEuTB+/DNe1Nk/IKGqbE3FiLrecZLgsnGAvdcqpHhzc0L23rLr8?=
 =?us-ascii?Q?ei7zu2Vvgop99UVdNy4Vd80Zer/45/9ZlJuYrSP3BsBIaBEtJQBxeODnLqyv?=
 =?us-ascii?Q?yzpJcqWSU1Kp7SPD3DXaH2N7T9PClx5QVlKs3BqO6HuGnKsf2yyO7EiYTy97?=
 =?us-ascii?Q?ZzNAg1GhEXPfJ8Yz48T2QF9WrPx42bKMIJ/Dxuv4RUr7dDZRuQuiLMzyxy+5?=
 =?us-ascii?Q?4qFXd8KacBOuOSjulkI2OfUi7yvV2tywqKK83YQRJgOFOpkEalqnxPE7/1rd?=
 =?us-ascii?Q?vSJATAptea2Q0jphD+lZYI5+G1PRdKGJoZuSgYLEOAmy0KuVO0N9MFyZLnfj?=
 =?us-ascii?Q?Pb87mpK+AR/+dihEk5jGfJRluo3bYc27O9Na1jRbdCpBw9iMxIfMBD59WvN8?=
 =?us-ascii?Q?KIgVwlklSGd1FM0/FZtn/h5apSxQb8gpPo7xY/XO/DzWmyDw90mvw1GQ4ZwA?=
 =?us-ascii?Q?T+VDR2BS5RBrY9NNnoxU+9eopVfmaB2y85U2R69AwdQiHGQy28BBZdX2YfVe?=
 =?us-ascii?Q?332SImKTdxkvAKianfHlufAv4SBp6eQanJ8iDhbkCACJsyPrhPceT0T87DyP?=
 =?us-ascii?Q?/+hxh+ny2Q4rcQR+sVDh5Pd8NhgRHajJmI5YzMtNfi7lDUGvX6/ESTKOhXoF?=
 =?us-ascii?Q?H15gEKA1en6APUsjFZlQWYGh0ZM4ccDAyu/Kdl6aIOdHavZYAzXoRs3TgLGN?=
 =?us-ascii?Q?67METSImtdGfe9ji++0ZGVqwMmWMrEk0s0DHrVjirjZ0opLW++2BS/q+VMJY?=
 =?us-ascii?Q?HO5gbKhISEVmjNpypnctmaC97PGkonz4MYkBVxwF9iyDbg9PyDniy0X2y9HP?=
 =?us-ascii?Q?7Wg24VXmSiTELSUmSUlg6gZaBtSnaUgoncQBYcx0SyFim+d8FrMDSvHfc/Wg?=
 =?us-ascii?Q?G+LYSdVVGsKH8lYFAUye9ulMpYBqobxxLw4AOG5CtFG2YkAd7S0/BInJ6xvc?=
 =?us-ascii?Q?0YmivQb4CYOJ7Bd2AeuQs2CRuInMEBiUIYyJihqBM3f65nRSn9mL9akPNuXM?=
 =?us-ascii?Q?AOOemr6vjOvJZTgoQV2ToNBjqR7U2skU5BYTtpFxV32wFdqlKedmTqQXa7Fu?=
 =?us-ascii?Q?F+FO0a7jkLg6A0bh8GtkUfxf5XuF749c+4ys0LGT1p7g2g1iAvJxY/xGqYs2?=
 =?us-ascii?Q?3wue7WpSArtrMY5a1An+/9cX7KIY7/JDHLMrNbq6YmWUKi9OxMriF2RZ9462?=
 =?us-ascii?Q?m7hZi0X4Fpob+AXw5fqL0fp8GIrQzzkVQf8cuMTw3oDCCd/uHgaq+EPzMeID?=
 =?us-ascii?Q?eDM9CRYgUvSGkzWw0YXcwmK8S3iA4QRJ7KhGB6ZW9tYKLqIzhcj8SfePhWf0?=
 =?us-ascii?Q?xbtQvXyxjSSSX7hxfabZSApn+9zX56Hjqs7z9KHZXLXsoLUa/7oOzxz/ulaQ?=
 =?us-ascii?Q?OcrO7TtzEg=3D=3D?=
X-Exchange-RoutingPolicyChecked: GmMOyIEnwgsjlINGQzPqZVMptFzV3w4qvietu+CK1U4Gcx5edZCbWV8i9wwe3Jdo7bsj6mjmwWOBZ6O9a2H7SNO0ECLaBIZSRl2wVH8qgbDYl+DzkaeQFfjrCE9r0+qNshYAl6TxBPmf4hYQPJQIO7A3Pi1R6yPhjR/cN0xI2bsiXHNZ1nww1WUbieNYkH+Gu9ShK6u/Ltc1vzX5Mv23TXRQ0SclQfAr9+ZCRtkXjLf5HJxFfpyqCuSI7iDb2WrZcWHZXntXM7QbIOUOeoQp0dAKh4eqs/1/p0BgtQ46sbhZ5bcRLWZp1cC9Ll9Q2m+k5iEwxlWgwVSqpFjh9kx1CQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f17c401a-654e-47b4-6728-08deabaa7894
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 20:02:59.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31lQbUyY1mDrerm0LSVRVs9lG8LC3yOvR+6s0mpCb7dbwLwBES0aWAe66qMevSwefyGFHXBY443k7XJhq/TN5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4758
X-OriginatorOrg: intel.com

Question?

> +	if (!is_percpu_thread()) {
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->mbm_work_cpu == nr_cpu_ids)
> +				mbm_setup_overflow_handler(d, MBM_OVERFLOW_INTERVAL, RESCTRL_PICK_ANY_CPU);

Should that "MBM_OVERFLOW_INTERVAL" be "0"? This worker is presumably
already slightly late because of the offline CPU overhead and time to
be picked up by another CPU. Maybe it should run right away on whatever
new CPU in the domain is picked?

> +		}
> +		goto out_unlock;
> +	}
> +

-Tony
