Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E14C3D47B8
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773937251; cv=fail; b=b4BkmvAPSg3x7fEG7m15oHm07iJE62HCJjMgfrFAZYBArnBGpIix+A2Q6N1iJpClvfAVSLUBoHphjf/3LBJOGzOkrZpVK7IMxIvD8+EAzdNHeOtBOkp3Wl+75czJbdJrPJjADEGCSiQSupzQiW7tdtWiVvnr7gL/AH4x0+9erBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773937251; c=relaxed/simple;
	bh=yhaPoneU03UIVWfP7awGmMz7tkuCOuO9qYLJQU035EI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HsPynwWK/RQMG6zNEDwuqO3L3vYGo2irZT1xBVOebhH2GDYgG/7PzsEmA7dVM7CHmwgyRPQb+lPM0/2wE14Yd+EjW8DNbDvgRt55rONwlVNvYiZiOvaEYZ3dMJ39RV5sood3GOyVo3XvWma2yK157N77OlK0dPC0Zn4qMWZ4mUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WedLMaqt; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WedLMaqt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773937250; x=1805473250;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yhaPoneU03UIVWfP7awGmMz7tkuCOuO9qYLJQU035EI=;
  b=WedLMaqtoKddcJEPREXqZZacqd04+e4TGx2/eJCjrSZgIuL5kh0tqT5T
   779NN8mMoaez7J63J7rRfVq/nNX3yyKESf5+bfFFZa0lytqgZBsncFCKj
   +5uriCqSYA79uRlzdamG/IFZNftyof7+ae+2G8YsZX9cnHwrh6i7TzWhk
   TW8aTek+QmtCm38nzWkBZvXQoPNSm4hoz2J3VdS6eL2b26lRKE4AMpMHZ
   wH2jgi8wG9q97mY9eOJfGpp5dMwbF69K1kdY86FQ059yez7X0QDotfYTn
   OjnT2cHbRSQNYXHpuyy4HTNmVTaZzW2H/z3pWVtkvrbSQ6nQ0pYb6k8r1
   A==;
X-CSE-ConnectionGUID: ldj4U8EoR9mUa03ZKjrp6w==
X-CSE-MsgGUID: OK+MMSsmRnKpW0d7WMCGtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="74902790"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="74902790"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 09:20:42 -0700
X-CSE-ConnectionGUID: H/i4mHm9SUi9bEJPI21sdA==
X-CSE-MsgGUID: IbM/tSYKQG+sRse3fODAcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="227714512"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 09:20:38 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 09:20:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 09:20:37 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.36) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 09:20:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mSWRCgGyDChhb3jQZjrkW1ZeLESSrdAKNVl7YoUCGNNrbVUcUthEu0orrhiNzP2V/USMy+QjBwRxToowRSfIHM0CGXb8fFJ68xfqkq3nb1mAZWIn1QHtxcG3XtqMRiIN2HRxIGNAtlBcKtcDnfDJeHqCw4emqpTSOsDkQJFr/1qyl/dkciVJKX73qnBxPNKG8UiPeCIwqdixHG0D/2gwWHS34sPVjcnbGshHAZ2tlXsgn7+i91Wutp9tK3TcKvxqF/IRsXuix80c/B8aIzuI2BXJG6ykDEWaZBBVI+j38tsTG/uLxTuGXRTclEbrQeNl0IG1LwowBoxkZPnwQC+kdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2W2j5Loj4dnhZPUsw+26KdmnTegRNiibjT2VacugnQ=;
 b=VR9PaiwOeEpUqadpIyWaRSqApGxO7PKex2FOk0V6mz5aH4i1brOOJ3VT3k/uE1SoWKGXzkrlOtrijY1VQ+bNkPOyYOUZXDMVae+vGt+xNj3zC3ZTa7c0rHnj4PrHIBT5QWHTfmOgUrJiqTDyOM+dx686KoDzby/udtmymuALTilcNQlf0dGQWZunFH5M2d/8IBI3b1UtYUY3KCMhxo0GBszkGIreSjPsCr9zfSMEppRm+z1VHzAY2XMBLjpibMB2r0roRRZ/k2RjFv7A5cmuehu+62+0QlqMnn4JkxN+VfYSR9kjHwZsu4+NCstdQuASfP7M8sYylpBr+2iNMP5X9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 16:20:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 16:20:32 +0000
Message-ID: <b00bb178-9de3-4baf-ad9a-c842054f71a7@intel.com>
Date: Thu, 19 Mar 2026 09:18:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
 <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
 <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
 <f37db924-dc65-432b-ae48-ddd986b3efd9@intel.com>
 <d4460f04-813f-4a6f-ad1f-6f2e5bb1c9fa@arm.com>
 <55a9461e-32f8-4665-905e-bc18b7201c7e@intel.com>
 <e7e480ed-4dee-4898-a47e-8730eea2dcde@arm.com>
 <06df6bde-6790-4320-bcf1-cad2ab3d473e@intel.com>
 <886f1287-c6cf-4162-bb2d-8b32c679990c@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <886f1287-c6cf-4162-bb2d-8b32c679990c@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0318.namprd04.prod.outlook.com
 (2603:10b6:303:82::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: 02073b64-90c7-4471-8c14-08de85d371bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: X1hzhUyAQ6NVmA+2/qih7rhWcn+b5LbJRQ/Me2C45e3/3Wx6cLHaS8XtZ3aLeWtu3oKSmLGqFz7EGAUo/vkCPiFS41AEKFMxf/yZ7VjEf8SiO8CnKn8FEFLIR+CWDmkUYrvn5Mom9RfF84x+EfzEZse0WAzjNmXQoLL+9QrI/3h7h+w0O18O6pQMJp3STOyd7yc9OGUJ5zqjtgO6B9X6errtP8QSN4TCgu8yquIrT3TzduoIlYQ9yfwDCh0iHk66sSnic3KdkNlYVwWlu29TKOu52pjz2sufLLvSo5dI1DZl4cXsppabymGNeiXSVgVkF9oVoVBEp73dxfqE87sFXn1NsWpgdQDBZJ4Sx+h4clzq8hV+Wsa3om+999vXfrVyTy5Bw6e0c8/ZTD0KkwvHELrqb87eft2NDkbeJkFjGhO5+vrrL/xX7obd8bqkfdSAYzkbeijQPbsX3md34LuVSVfL10tzA+hTpyhAL5+4eatdnhJ2+OeX6OKum2GB1Sw9Zq9x0Wu5/d/xIkj7MW83b7mTENvSCHMhzOVQkcSiEh8ST0xlHUcih+7KSIuupGiQYL4daPBF5hNJnK7sIEalmxKLUrJI/a0Y7JoPgDhSkdn16hMlFlb3MibK0N4oRz3Nz0bttB5KWJXOIk51uC88/CWlTVHUd4aUlvngaNqr/yloWfeGQArwuFknPpOXT9UnU690t09V2apBX7nsfxhuQYF6Wkiewa2i/ZqXGLF4VAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnJwVk5uTUMyTjV5QUNuN25mcnhMNEdNb2MvUnNiSFluT1RJbmtJMlgyL1dR?=
 =?utf-8?B?SS9jSXpyc0JkSDlITE9VaUlBNW9uTEIzeVdNSFhpTFFlODFjRzlkRXNRNnl6?=
 =?utf-8?B?NDJyVEovU2dwWWliT2tGbTRkSW1BQlRWcXBTVE5scUxGV2oydjVuUFhPRkJG?=
 =?utf-8?B?TERaWC9EWWFVVnJTazVnYUNIbzF3a3Y2ZEdBUndsN09pK3JiS2xvcW1SeHJM?=
 =?utf-8?B?Wmc3empjM2E2Mnk3Q0VQVzkxdlV4b0NQRkdZci9SVHRCM28rcGRERjVCamdP?=
 =?utf-8?B?aEpGUXZHd015RGtPK3NibGlqYnFxY0VWL3BpajZiamFqb1lBc3k4em0wZFFR?=
 =?utf-8?B?UXhoc0orT21pTkgxV3k3cWNGdEMrWmh2OVNRTktWUEdjTUptLzZrS0I0MTNS?=
 =?utf-8?B?UU5RQUNzdmVMb0tqZ0FVTXZzMW5jc005d2pYVUpxRE8rVFE2MEdwb2hieTBD?=
 =?utf-8?B?UDBZa21HZVArcnhLNWtrVHFkK1ZQaDlIejJSRStMKzJiOVRoUGN2cUdaNEln?=
 =?utf-8?B?d2p5NTM1dGtRTHp4MlhPdU1IdVZjN0hNbzVTaHpmbUdRcXE2STNoY1ljNytD?=
 =?utf-8?B?YlVGWUZGN3NVWWFLN2FXMWtMK2xsOEN2TEl5YnFmMExFeTdLbTVWTEpIUFpR?=
 =?utf-8?B?YWU3dkZxTDEwQ2JHT1gyR2lSbWMwNGZ1QTdlZ2l3TkR0ZnBUZUw4aFl3RWth?=
 =?utf-8?B?RElTeHZxRHJOR1BlcnNGbDE5ZlhnK0hONmlLbFpaY1FjVWYreEJsa3YrQ1Vm?=
 =?utf-8?B?Z1BKM0k3VGkvdUw5NitLb3M5M2FqMkREN2EvakE1NlFhY1d5WnhwZUozWjcr?=
 =?utf-8?B?a3ROUmlNNXUzc1pCUlZOVVJWVkVuZ0pEbjl3Y0grcmU1NHFSR3NKcDVSQm95?=
 =?utf-8?B?RTlaQWZOK2ZsamtxQS8rN1pyVWwrcGtDRHJkYy9WdWVqS2hCNEhVbjU4Unp0?=
 =?utf-8?B?Z2NiNVo0ZmFNYVpXZ1BKdUJDb3VRYkJDMHloOGhQTmw1UEdPajAwSEhZdG5r?=
 =?utf-8?B?RDBuV3c0RHNGQVBpa3lGcnRkSkVVcmUyN0RoZ0tJeS9YdVNzMEM0WmxVa2pj?=
 =?utf-8?B?Y3JmWDZIckkwbXIydFBoTEdtTmFoMFZZU091aFJpbTlLYWN3VTZ6ejlRVHI5?=
 =?utf-8?B?S3czS1hwR3VFaXdnSmJvN2o0ZmJOR0JLUWxHdjIvTXJGZUJJeWlRN1M3UkxJ?=
 =?utf-8?B?QVFGaVV5SmZaeExWYkUzcWwrQ2VzUkVMOW43VjJsOXRXY0R2TGxsL2dBTjJB?=
 =?utf-8?B?Q2puelN3aVJmRUo0Wk9DenFOM3IvcnNXRlp0MVVrZDdEaVZ4MlFvY3VqeGNR?=
 =?utf-8?B?ZFhEYzkvZFlUSlRYNHAzS0RvWU5lZitIenBoVUVYeXpFT3VrS1ZkNk5pL2JW?=
 =?utf-8?B?MGJDZ3Q4dXhUaVhJL2pIbDJ4amljOVlRN2lNZlNKNnBpZzYzMlJybXBKa3Ax?=
 =?utf-8?B?REtUOHVxczd6NWRjSEZtYjlVNzJyMDY3bTQ5K0l2UVNWbzZiWi9sRHBVVDZs?=
 =?utf-8?B?aVhqUEJsQXhTUW1BWFRLT3hRQWYvcXY5QnJRZWVKeGUwU0UreHIxVHFaM05S?=
 =?utf-8?B?RURheVJwRjJpU2hIQjM5UmMwbXdFYk9vWXdram5lcDJmUTczQVhpVWJZK21D?=
 =?utf-8?B?KzlCUVNoTkFWWCtwTGFETFFpZWhJZ1dPWGZ2YnVJQllaQVJ4K1RnRDdFTmNq?=
 =?utf-8?B?MHNUTDNEODI3QnBWL1dJaXJBa1hwc252NVZOVjFYTmhsQ1VDZmxkdU9sd1VW?=
 =?utf-8?B?VTd5N2g3WDNLSmttcWlHV0hpT1NVd0s3R2ZkR3R2ZVB2dVRxT0FQbXpTc0xX?=
 =?utf-8?B?bDdNUXd6bnd5UHBMd2JQTnplWDhYaUlIN2dyK1YrTGE4dlRrVEFTazlzbGFp?=
 =?utf-8?B?MUJ6a1Ira1hwS0IxZFJSdVhKQm42a2JjQ0o4RzhBb2l4bzEyYVNVMk9iMVEy?=
 =?utf-8?B?WU1wbTJ5cVBzT1d0UGNqZnRCZlQxTEdwUENsN2VXZFQ2NEhCWHNtK1NGQUZQ?=
 =?utf-8?B?Y3VYOHQxQ3hpYUtuRFhSUG9LaEdQbjdpREtoMndwYkl3OFNqaGFLMS9pbHR6?=
 =?utf-8?B?ckxXaElydG5tY2xJTTFRckhjTHg1bnQzZ3ZLb0xZTU1rUjh6Y0dHekFpeWJs?=
 =?utf-8?B?YVhvdGh6YUoxVXd6U3Vic3lFWkdKSnp6QXl5UG94ZDhPN0djeUJSWGdDK2pF?=
 =?utf-8?B?WkVNRUNTenJ4N0d1NmdFUEJUcnZKaW9aWmgvMlgvNlh5aEpOUHJoQ25QS3p4?=
 =?utf-8?B?U2huaEZRd3FsQkxHbFZVRHdIMVpYSTEzZ1JBYnF2RXhLcTVpK1FsWkFYOHRL?=
 =?utf-8?B?TnU0dFM2Z0o0dEFybXJ1cy85cG1DcTZCRGE1WmF5Z2dOeE9sbStlY0NhWlFo?=
 =?utf-8?Q?bKB/ctNtwK7A2xvo=3D?=
X-Exchange-RoutingPolicyChecked: EtgW4lMIH6/IvJS7aljmTIrA68szIfG7/NKfAp4tDYd+4xNISGiaSJr6Lcf1OPxMT105BpodcZYyjbV4XPYynATvVqUd1sRCLEfLRVVOlllPyQd9m1p4fdtA36v3OPRBH1YSmwGIE6a7o7d3B7KaxIKHNRiWBILSF0l28APNrbBcNldMcpupwRamY3fJ6dQm1OroK5VUFoklZyYAa/v5rLqjXNirbDAF0rFixwNknY8/w4rh8cf2bQoVyYUVbkiS0kVQg+SP4F9cAP0uHBh1dZb8jVi/FuJMxJ5SyXU+rtFsluwaQySOCo/hxPHOI5f4X6PF6/Fubv43RG5YcgGMNw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 02073b64-90c7-4471-8c14-08de85d371bc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:20:32.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYa6T8aC/eoN0ihVHE8T2ZHGX/9NRDHCJ0i1EGE00vL8Z95NaUFUCkCoRzKeAEL6XeSC+7sGHfIVxvGt/WhFSPQZexoI8KLL09YeGwY4STQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

Hi Ben,

On 3/19/26 2:53 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On 3/18/26 20:12, Reinette Chatre wrote:
>> Hi Ben,
>>
>> On 3/18/26 10:10 AM, Ben Horgan wrote:
>>> On 3/18/26 16:35, Reinette Chatre wrote:
>>
>>
>>>> What resctrl could do in such scenario is to at least convey that some messages were
>>>> dropped. Consider, for example:
>>>>
>>>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>>>> index 5da305bd36c9..ea77fa6a38f7 100644
>>>> --- a/fs/resctrl/rdtgroup.c
>>>> +++ b/fs/resctrl/rdtgroup.c
>>>> @@ -973,10 +973,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
>>>>  
>>>>  	mutex_lock(&rdtgroup_mutex);
>>>>  	len = seq_buf_used(&last_cmd_status);
>>>> -	if (len)
>>>> +	if (len) {
>>>>  		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
>>>> -	else
>>>> +		if (seq_buf_has_overflowed(&last_cmd_status))
>>>> +			seq_puts(seq, "[truncated]\n");
>>>> +	} else {
>>>>  		seq_puts(seq, "ok\n");
>>>> +	}
>>>>  	mutex_unlock(&rdtgroup_mutex);
>>>>  	return 0;
>>>>  }
>>>
>>> Adding a truncation indication makes sense to me. Would it be good to reserve space in the
>>> last_cmd_status_buf[] to ensure this can always be displayed? It looks like space could be
>>> made by interacting with seq->size directly but I'm not sure if there is a cleaner way
>>> to do it.
>>>
>>
>> Please note the distinction between the struct seq_file instance pointed to by seq and the 
>> struct seq_buf instance last_cmd_status. The last_cmd_status seq_buf instance is backed by
>> last_cmd_status_buf of 512 bytes which is printed to the seq_file instance seq that is
>> backed by another buffer that starts out with size PAGE_SIZE. So, it looks to me
>> like printing last_cmd_status_buf to the seq seq_file instance followed by "[truncated]\n"
>> should fit by default? This should keep working even if last_cmd_status_buf size is
> 
> Thanks for the explanation. I had missed that distinction. I've just given your code a go with
> some hacked in rdt_last_cmd_puts() calls and it behaves as you say.

Thank you very much for trying it out.

> 
> We've discussed two changes, one is adding a truncation message to last_cmd_status and the other
> is carrying on after failure when allocating counters. Are you going to take these from here or would
> you like patches from me?

Adding the truncation message to last_cmd_status seems to complement the other last_cmd_status
improvements in this series. I'd be happy to create the patch and include it as part of this
series.

I would like to confirm behavior when encountering error when allocating counters though:
My previous assessment of rdtgroup_assign_cntr_event() callers was incomplete since it is also
called with NULL domain when the user uses the "*=<assignment state>" syntax to mbm_L3_assignments.
This is a different scenario from directory creation since it passes the error back to
user space. While here it may also be ok to carry on after a counter could not be allocated in
one domain I do think that user space should still learn via error return that not all allocations
succeeded.

Even so, to answer your original question, please create the patches that change the allocation
behavior. This seems to complement the work you are currently doing and would be easy for you to test
(I do not have access to assignable mode hardware).

Thank you.

Reinette

