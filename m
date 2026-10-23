Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792767235;
	b=ouF0gCvT4Dg/W/KOAj1VjFlLjT+JOugGEo8mBN1lhxb7ux/BU2s3Bidzbf/mfuf3EElT
	 IXUxfBAoASfS5v65RVClG+eua5YsbJthHsskwh16MLM+P32fexWC/gGQPUC0klhfsGHiT
	 IiNucSSebc9Eo2U7gWfDnLZvVOB3zEURsBO+WrIFnezP0zMycJzpKtZ9GfRjngXwrz/b3
	 LvWB4e/XgZ9PXqjnv7DGXXy9M0e7j87W+lagG5N6TOtXN7E0wzK8Xjnu6zekfodfpJyxA
	 /xZgvTb+YykU5ioVp7c1cCBAtcCi2pQ2TpPykc6d+DVFswuCh0VdrHj9PfZgvFJKp8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792767235;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=lDkvYPYQv02TIv6s7q7Q9bKOFXeI8D1peNIZtZWQt2U=;
	b=sz+Yeo9aKw/qiiykwOhMtjBTlHREfwU4agsuHnq05B9xYCrZ5j/dXGbtWfHz4EtZZhQp
	 Is2WlgmEhkiM3jJACltz20frJKrqGjV+DW3x9/aNqdkeaqYj98L3Yb31Nka/5tywaGwL8
	 Pxo+LvxdpXfAuIs2E10i8hr1dwsaRIMWptUPnGnUa6VCVdfbAzfDmdbHoj4fQcnG81PZx
	 bEviYzDZSqjG+4YuwsXwjRvdZ8cJbiQ/mFE2JI3BZ6MLZXLkYUpk+xfemfI9Q9RGSUdgu
	 ZI6VHbSh0/PLkT5InPKRDka6H340Y9Q2buxSVJKMDAf+SSjQ78MX3LPShyr0KfFq88w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T2GxMjlJ;
	arc=fail smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A915606A31A
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 14:53:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A915606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T2GxMjlJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792767234; x=1824303234;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UthUPKkdB1/0cpin9oL+dR5Yb1+FggztyiaFtfAD9QQ=;
  b=T2GxMjlJplSoGP0pJ/jmqnU7gBz+K84CdE9DHK1oE48zDVd/1lK2EwNs
   1Hnr+K7WLZvAuxP+mBPbzakbsJuVHmLqIk+65GsJ494CF0P+7wweIThNt
   oa2CQePa7n/T34CfyupRwlEzClisuieCugLf77jhfjIFOQ19wrEjl71ll
   gO+ekpIRDPq1OqZs5h4RRnxrwQg+y5YEvHlIlVtIJ5B/onpH0j9xdLo/g
   PDUm0yIAAPxLnEi+pOmVXErmcoOBiBi38nml1YSiUassV9N2UO+KMW5zL
   A6T9+wPynYbeF31/cepElUuXPv5ioqJq2zk4oTk1bjojVsvjRoVv5Ee18
   w==;
X-CSE-ConnectionGUID: oOnuesPJR+SkwXxCswPurQ==
X-CSE-MsgGUID: 9R/f7PZuRVeIlP7eUBMKkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1407965"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1407965"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:53:51 -0700
X-CSE-ConnectionGUID: jvkyqM3wQBODkih+s6TQBA==
X-CSE-MsgGUID: rmDuCebnTRe8TE8I0fBHXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="5420728"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:53:51 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 07:53:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 07:53:50 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.31) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 07:53:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awRtxWNixWdhU7+W00faXnsglXXdKge60yEjf7XeQVeDgcyCIaX/q+aAJqfuUJLyyYtgwQ+e7Q2ly3XimILlIV0RJZGCsg3BRdGeHJaK9mtBIGoCK3NHSAxBUiJwBGIQCcW3BaOehh6499b8jJJmCfgqyqTSL3Utt/OHuJ/9WeJFx5gpWnCo0sRc3Lpfx3vm92asmDlOT6g1uoUJjex+PN65AQdJf7b39sk2HW0PbS3yCrVBzCFa35Xha+FBVc7Gm2WZ0JhYxdvfUbvZCW3Y0zxw6w/GGQyabbkt51FeV4flXtVPJQGmHQyMAgXMlKlxDDFfbE5o/QIaTeu4xlBU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDkvYPYQv02TIv6s7q7Q9bKOFXeI8D1peNIZtZWQt2U=;
 b=RQUBIusPgccNe0+FokiXnEj3PsOreog6anUUBexdUBjgfnPr5eBSBMhdCeEjebvM/Kr0+qQvF2ONNL+PybruNaKomUwEjWH6pP1xklJFSDZQkeYOq2Z17KaMfL0NsFD+J6r81Ln3UGa4dQHm/+6L/tRyM5SWWULclyHjK30Z1Ec0ujYG3YeB96URVMnMsbWwA3OHVMuEAs3/OaTIqycJK2P8jP1Al+rh8kDwIjtQaU9KvFMMmWWqEOmA3YPP6Iz28EPZ7jKVdaku/+YwQV6gqsV3aVeedvYBeZHGPj6UEt8DXVR8e+jLxMRzFawhx1pV20ptsGj3I8emBZs07EtsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by EAYPR11MB115281.namprd11.prod.outlook.com (2603:10b6:303:2fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 14:52:47 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 14:52:47 +0000
Message-ID: <0f03e149-6050-47c1-9553-1a2904cc7a52@intel.com>
Date: Fri, 23 Oct 2026 07:52:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/10] arm_mpam: resctrl: Use find_component() when
 allocating a domain
To: Jinjie Ruan <ruanjinjie@huawei.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <94ddff51b91f4a51965baf0384c2368e292c1a8c.1792443633.git.reinette.chatre@intel.com>
 <cc73fec1-a8a7-4d44-b935-541aba848fd4@huawei.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <cc73fec1-a8a7-4d44-b935-541aba848fd4@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:303:b5::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|EAYPR11MB115281:EE_
X-MS-Office365-Filtering-Correlation-Id: c27c02bf-c20f-4f3f-a12e-08df31154d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|22082099003|18002099003|10067099003|11063799006|56012099006|4143699003|261022105027099003|261022075727099003|261009223027099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info: hYS6R4bHDLcr+OdLekh7dk8h7I6hjL3YrIQcY9Sbv3YJ5fwz0hk5evfMpKeJonkxFlH4XAeOPXStOcoPdyZBLXNTgmpYTxkKZMa9EXKZxaBeQoOLcHu88wozPZRPuAy+FEpv31G5eVyLM5DpEq8FcpQMDtlrpnSRPf5Pfi3XACFu5GX7UNsl/sGBJcx8TBb9ZYwNOVU12RPIz7A9p3o2OJj/sG3VUQgfCHpNbaZjWC3D7n2ZbtLvTqo8sFXmPav9YbjISJx8+L17G9k4Im3Ki1baW4DzyCo20WbIsvUWYwjIrTg62qLeCsoZp0S78hIzj1b7bzYR0eNVFLffZrnKTPHDGHeBct5xf5AYkEgphnNJyXmxbEuZUsfw0HdMoMs5mDJH2AimCHtnFuRJNtW4Dq4EltBGf590TB8NAE4oTGd8MrkJLTMDRcfL/LYveOJOmXt+OQeGGiENSh0fybQWK3XJtXFTn8bYcFlKYcQVWctCLsATJm3h+1frTONis1t7g85iyflMDeGandYdFLb3Oh2CbMQmiCmMR9g7d1spQueHL+86mxkK5HVPFxhL0R8iQj9tBy3WDW30hVS7N4jNaVgw5nGtZvG+3RV+pENkIl0l8UqhPEYXx5JlDCF1PKs2ZNr0ByY+nCY7TFvmdmFI9qb46h4dbK09VBDVfiZjzo8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(4143699003)(261022105027099003)(261022075727099003)(261009223027099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjJMUkUwc0NGaGU5bWxjSWYreEZ3cEt3aEJNMVhSSXBiMlNaRFVPWVZBc3dy?=
 =?utf-8?B?MGpiUUwvbzBTWmREenBlMm8xT3N3SS81RStLUkxnaVlBYWNFanJrc0UxSnVY?=
 =?utf-8?B?SmxOVnZtSndtUmFubm1FVnM4bmthbFFkeXJlYUJMZnhWS0hqMGF6TUhHWURV?=
 =?utf-8?B?aFBiU2NmMklHejNvU3l3TWRveUNlckVOVFpRZy91Yjd3cUJBYzYxSGc5Y3pY?=
 =?utf-8?B?UitMREdkZCs3bzduZTltZlIxVU1naDRiUDdNQlNaVll3VGE2ajFhMlZ0dE1T?=
 =?utf-8?B?dXlBWG9mbit6aDFmMHpQTFZRczlxOGpkVi9sTzN0cGlqSjJiSkl6czlEeVpL?=
 =?utf-8?B?RVpJODZ1SXJpT3QrcFNXSGZDckc0OUxPOXZvL0FHdmNhOGE0Wmo1K2ZJRUc1?=
 =?utf-8?B?QlRGUDJUYm5BNXllSHJmdWVEMytQcXJTY3JJalJ1Z0ZCV1F3aVI3azFEeWVE?=
 =?utf-8?B?QTlycGxLbU5POE5aa2owejhDWDhvaTNvR0Q1cndrZ0VnSERBSXZ1TEJoZmZy?=
 =?utf-8?B?QnJXWUs0ZVU2ayt0MzdHeEZYcTZDdG5Cb3VmWm5meWxhL25RSWZLN0s0bjRB?=
 =?utf-8?B?UXMrOUg2dm1nN3ByYXU2WVB5SjBpem5QV290ZU1iYUJQeDhaTjZPdGxjb0NT?=
 =?utf-8?B?UXp6NlBCOGh6cC81SmYrbmp1RUZEd00vamVQeDJiVG55Y0pkR2RuaDFHdkY4?=
 =?utf-8?B?S2h2S3NPZTIzbFFZcnFjeEhOeU5tOS9Nc01rOHpYVllGOUl2MUYwdkdpWllh?=
 =?utf-8?B?Tm5TTTNHYjh2VFdUY1BPZ0xsQ0hZUGl3NXpvSFd1c2pYekJqdnpjRmUwZDAw?=
 =?utf-8?B?OTNua1liL201WlBoUkpDWG9YOThrYUFPbjNIY3h2TVRLUmxCd0lCN29FeWpP?=
 =?utf-8?B?K2dkcW9HViszdFFuNEk2NzlaUm1WdTYxcStuVHk4cUhmdFJBMTRKRGlBZkV5?=
 =?utf-8?B?TUZDMHBrdWZiYVkxSnVtcE5kT2Y5clAyRmlJVjBJVUYrK2s0NW5XeEJ1QmpU?=
 =?utf-8?B?b0d0OGxZTnNhS2VGeTUxZWFCWHhFU2VZTFp1Z1pLVnhXZm5Fd1JQSnFDK28v?=
 =?utf-8?B?MlZDNzFuRGRkWngrRGRTN2RKM082SW1oNG9naGVSTDJnL0VWcUpGZHczSHRu?=
 =?utf-8?B?SlRqZmZDd2RBblBWK0E0eGZ1c2lUbXZlYThLZUliNy9PczdjNHFsazVDcGN3?=
 =?utf-8?B?MWg0SFI2WUt0QXFHakl5b29veTVFd3RLdjVYV0FWVjBSRkZla2p6d0VqZFVQ?=
 =?utf-8?B?bGNkd29PQ1BxSFdzR3lENUxsVVZkb2xiU01NNkZ1b2NzMjBueC84UjBnOVF6?=
 =?utf-8?B?dTl0WXhUYXRnN1FqUndJVkxmUWcxR2NHSzJ5YWtVbUptUlRrQklBTXoxZndY?=
 =?utf-8?B?NUQwQ01VakF3ODhBMzQvM3ZXZjlxMnRENEdFOVVoZUFVdm9vbGlYQzcxNGJR?=
 =?utf-8?B?OWtsYk82Nm5aWXlpUnZINFRXOGJxelpaY0tmVUIwcGRoMmZTN04rc0Y5aTZ1?=
 =?utf-8?B?TW0vTTNGNmJiVzVUcVllNllueVdnaTdud096aVR4ZXJ6cjFsWHJPaWl6VHZr?=
 =?utf-8?B?QTNWT05IZ0ZORm9zMnNRd24xNG5tTko4Zmt6MitNTFNURTJmUzRLQlNwb0U1?=
 =?utf-8?B?V2dDTnRJK0Q2ZEZSKzFldTdPMDNGdWlTa0lWSnYvYVg2aXZxaVoyUDd3bVE1?=
 =?utf-8?B?ZVVvUmdSVFNET08ySk9WOWU0dlJDNFUrdEtOQlBTczNPbUptSEsxa0YrMm5a?=
 =?utf-8?B?bUVjTnRMc0h6TEsycVdpUTQ1ei9SNXY1N3c4Vit3UlB4SSsvaUQ0WjIzY3Fu?=
 =?utf-8?B?b1k2L2o3MUZuTlVsOURMU05QRTc2NzJwM2pHK3Z4dXNVWjE3NzBGN0crSGsy?=
 =?utf-8?B?VVp3cGZ3dXJwajljT1E4U0lWY0gwMnduNWhSZkFqUGhNQ0xWaytsRHlYaWxN?=
 =?utf-8?B?VzZocmJzd0ppakpscHNMSnkxQjZXeXBnTEhFWmt6WWkvMG1CTzZnOFdWTjlL?=
 =?utf-8?B?RS95azdxQ1Q0THc4SXRJVU1PWFYwcGppQWUxaDRLeTFNa1lWanJxbEtzL1Js?=
 =?utf-8?B?T2pIcEdhcUFMQitwSVRydllpTkNkUExsaC8zUUJxU0Q1MHN5WGlIcEJzK1dV?=
 =?utf-8?B?QTJpOUloNWFJTmZrbDNla09rOHBDamlleU5ZOGNiWGtoM1ZlL2cxMDAwNmpq?=
 =?utf-8?B?RndPcktJT0lMRFJDMC9qTzd4Y2NyVk02NGJ4R2Q4dytHMUxXMkxwdXRrQ1ZE?=
 =?utf-8?B?eTBjZ1NNYmxuK1Vyb2RkdnZYcUhJVGFQZHpYSjdvQndEVlQ2SUhyN2ZjaXBk?=
 =?utf-8?B?c3h1YXNVUWpxR0o1TFJzby9qZ3o4UFBYeXZBcGJMci9heGNwd1NiZ0M0S2dL?=
 =?utf-8?Q?RykD5pdy8/ShTaCA=3D?=
X-Exchange-RoutingPolicyChecked: rUrO0II/PvNz0aJ6UGiAjkeR1cafFTci4mFjvIJRxBVMHLM1ibkVNF2O13fzUqPWz2AuCuLeIWH+2qOOzteeYqK53c5bMbMQbdwigjxgQB+F7a2cnCireH8aC6PDPtqbTisbbD5U65i0MOdicKkU5ZuDrn62tOaYgI+AH45aKtuwgYqeXFWxDQZeIzN/G1Ub2WYiv3x/WzvlmSGl37fvr3HOjiYOBaubKSBVkDlfjJB2We75xyEbeETOiPPC3sFhyqobyzo4KgvV+x9SvYFH/KdVp0RpNsAbyWUqshIi0CV3YVPH0zKl4nfgdRuNFdPPZDbZQKb5OcYjQPn2CoyvkA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c27c02bf-c20f-4f3f-a12e-08df31154d3c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 14:52:47.0589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glZ84or5GZzg3pHHYWbVNkGAqp6WJTBTr4dawW4ZtsM9oMNoU+RJxLBLMV84jAZhJViMWjYLTnxWF4wsX3E4NP33p7zzyC81w5B4TUEgeiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR11MB115281
X-OriginatorOrg: intel.com



On 10/23/26 1:07 AM, Jinjie Ruan wrote:
> 
> 
> 在 2026/10/20 6:07, Reinette Chatre 写道:
>> mpam_resctrl_alloc_domain() starts by checking that the resource's
>> class has a component whose CPU affinity includes the CPU, and fails the
>> domain allocation otherwise. When the resource supports allocation, that
>> component also backs the control domain. The check uses an open-coded
>> walk of the class's component list, while the same function uses
>> find_component() to find the component backing each monitoring event.
>>
>> The open-coded walk duplicates find_component(). It also holds the SRCU
>> read lock until mpam_resctrl_alloc_domain() returns, which suggests that
>> the component needs this protection while the domain is set up.
>>
>> The component does not need it. Components are freed only when an MSC
>> fails to probe, in which case MPAM is never enabled and no resctrl
>> domain is created, or by mpam_disable(), which first removes the CPU
>> hotplug callbacks and thereby tears down all resctrl domains. A component
>> therefore outlives every domain that refers to it. The SRCU read lock is
>> only needed while walking the component list, and find_component() holds
>> it for that walk. In addition, mpam_resctrl_alloc_domain() only runs
>> from MPAM's CPU hotplug startup callback, which already holds the SRCU
>> read lock throughout.
>>
>> Replace the open-coded walk with find_component().
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  drivers/resctrl/mpam_resctrl.c | 13 ++-----------
>>  1 file changed, 2 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 9cec5843e8fa..3d5f90f9f1f3 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -1623,21 +1623,12 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>  	struct rdt_l3_mon_domain *mon_d;
>>  	struct rdt_ctrl_domain *ctrl_d;
>>  	struct mpam_class *class = res->class;
>> -	struct mpam_component *comp_iter, *ctrl_comp;
>> +	struct mpam_component *ctrl_comp;
>>  	struct rdt_resource *r = &res->resctrl_res;
>>  
>>  	lockdep_assert_held(&domain_list_lock);
>>  
>> -	ctrl_comp = NULL;
>> -	guard(srcu)(&mpam_srcu);
>> -	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
>> -				 srcu_read_lock_held(&mpam_srcu)) {
>> -		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
>> -			ctrl_comp = comp_iter;
>> -			break;
>> -		}
>> -	}
> 
> LGTM
> Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
Thank you very much for taking a look at this series.

Reinette

