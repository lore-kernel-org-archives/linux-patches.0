Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E71279DB2
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207703; cv=fail; b=aHxEvUEUfwz9X1kRLIGLppZuiGVDGNXpoFFApSRu4mOQbHq6F4cAd4yoKk+3yuGGIyLvnw9/LV10IaWT934GpP7iKCNMJPKSh/tdr4Jrji8jEMDd5dc5vUcahe/SsinG6zqKCViausyfQVmWQg7QbojNLvLzExTqDJ5tMxyYbxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207703; c=relaxed/simple;
	bh=//MwqUz13blm3+ijeIUAoG4FyK8gufWF+McZcFdyvaw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j1yu2NnZ3s0ziz24jrdv9mbhbfUpTL91peB8L2475BFs7hj8a/yJN8Gb3usGe7K2PcO5JaoWiM18unNUAnjgcb1kGdYzudwQP/AL1FUmIRDrXxMCyJEkdQVjmwTeVqE39ePIAZlxBsmL0C6YSO0PZ1k+Tgcn/2HKAn9k0eylHFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dDNkqYSP; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dDNkqYSP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207701; x=1786743701;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=//MwqUz13blm3+ijeIUAoG4FyK8gufWF+McZcFdyvaw=;
  b=dDNkqYSPPSRlObl13ydfRcnS8meTUYrFmDO87qVUqYmWbAK739KkDilo
   sag7Rbjey3llkNTLY7ot5VvpbbeqGoHrl6VW6JOioprZYxvUhcukZehA3
   Oh+m1gOMM3ruj3FAxSatpMXZ4nH/nZ1CStm562jJYZRejhJLzKwBiWRQY
   pRW5XpaWmjadVXYEnVy+w9RjqIfrr3A+taKhcflczIeSUcL0CTt/Hu2dZ
   9c0qHSHvCbQ5apYvI1N/GPEO15wnA/+6hCvW+luhaScBxDHomi3sCfrbQ
   W74/pSlsDZtCvyGxgiFjCsSDgBd/YAdZ6TBPdLWyc3lttNzAQxB3mWc1T
   w==;
X-CSE-ConnectionGUID: ivndaiU/QMivs1mlPsXogQ==
X-CSE-MsgGUID: pnjk0UdiT8e2IxsegSkm7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="56743895"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="56743895"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:41:37 -0700
X-CSE-ConnectionGUID: SMv9QnKhRBqppMh1B937eQ==
X-CSE-MsgGUID: vswyF59lTqeKT6TByafBMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="197857112"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:41:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:41:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:41:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:41:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brO6CaMKORINLCa4og8Ki7iEXJA9X77ZL5Ih3N8aQoJasSGyLyhvcBrm77i920ePsAtefQovz91SD7wlEOi3ZbO0pupHLh6U3Oin5kCJIZpzrOhrLQQXUs14SRq8QAIVZtHQG84dpnYNeGlIO+klguuq4qCKALP8DXnm2AcTZi42L1FDLqiJm8nByU2GDGDYfD7rJUvzqujb7bmNgps6IufphqwY7NuG1VTojKTXrUFZh1B0Xw+jM2z0xqn/44SaNPcnteUeJw54Qrynxjq1S6Uz3tmV/lISZcs9pZompFwm1bbQ4jgSJ/hBfOsijmFnHswSCbKVI8zaR5E6Rhbf7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPALBH8uPF2tnKgIqcAgCxQNE1sRLXUOQXQEeErusgk=;
 b=nmt4UmKZrgB0+SLuIq753lrVMmqWem2u+84X4UBL/735WLrVAlGI0PlTQZyzjtsA46mKtuDo59lU6AO/iZgg0g7wHcMcfUlAS0xtM6BzL7quf1TP+mPGRuAAPxnxDadm6X+5h9OrH1xdfcgMaJioDQUKtMhdo6AmBDpGHHxkZZBF745O+ovlprzU9FfZnQvRWejlDzhx/kkt6K9USmXWRf0mFLJ03pGzeusFE/XzJ1jo6LGbQeb+loqi8iAVDlVpBiQC22b8QfZrgagSkSCd5dD09vt/DenvqQ2wPxY7e/aMbMuZXoGYhnpOjaCr4g73rjeePXrTu1NM57cwLB1qTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB8988.namprd11.prod.outlook.com (2603:10b6:208:57d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 21:41:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:41:33 +0000
Message-ID: <bf08936b-f7c9-45cb-a8a2-0ae781452835@intel.com>
Date: Thu, 14 Aug 2025 14:41:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 18/32] x86/resctrl: Count valid telemetry aggregators
 per package
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:907:1::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB8988:EE_
X-MS-Office365-Filtering-Correlation-Id: 35bdf7c8-18b2-4756-b2cc-08dddb7b565f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WndNOTJDL3JiODZBOHVKUzZacGRZaW1pbklMY2htaDNTU0hhMXppNFJGVkdn?=
 =?utf-8?B?MXBCUTBhcnF1U05CdkJvY2lkUlJUWnhkQlhFb3E1UDkxQ3NvTC9EV1RyWUc0?=
 =?utf-8?B?NUJWa0kvOXVZbmszaDFyV0tCUUZRcitLOGFYMU0vUTFKKzl1Rmg2UURWN3h3?=
 =?utf-8?B?WUw1NmF6RTd1Q0plZC9tRmFnR2dDZFh6eUZVd1pCVnR3cmlROGQvYzUzM2k4?=
 =?utf-8?B?OWJFRHRza1cyQ1U5cDdWRWdMM0x5QW14OVAweENrSkZnd0p0aG1vN0RzaitF?=
 =?utf-8?B?c0FlYnpVRWZCNU9hcUU0Z2pvSWkxRjk2NkFuZzMvWU93dlZUT0RaU25PSHl2?=
 =?utf-8?B?eGtVNVgrU2QwYWk2ellQYlVDbHh4SzA0Z2RJaksra0dSb0N3M0NsVE1jWnp3?=
 =?utf-8?B?NjVWNkJpQWlxMFB0S25JK3JiOFdNNXpSeFFRdVFDNzZVZ2dyM3RJdllYVUVx?=
 =?utf-8?B?VWhFMWhubEJHYitWVmM3TjBaUDhGcWRjSWlEKzJFTlJBRktQRHVnQ0ZETm5W?=
 =?utf-8?B?ZEZCek1vK0J3TmloMkcvWFU5YnFFdnhFWGtuZ1F0N3NuNnArYnN2ZTJDeWow?=
 =?utf-8?B?NXJCbTFTdnFJRzZDcXgrL3pUbWFVVjE2d04yQit1bm9nUkZ3eE8xQUllK21I?=
 =?utf-8?B?S0l5WkhmVkh0bkdsK09xbWk2ZTh2Y2h5ZFQ4ODdMbmNYU0VyY1ZscG0zbnZI?=
 =?utf-8?B?ZkRwbnduNld4WUlzT052bUVCZ3ZLWlJiV1MzTVIrU3IxcjB2WG1kamswZjAz?=
 =?utf-8?B?WXZtVU5qeXJYcGFrcmUvbjJ6TUNrb0U2MVlGUDEwQzJicW5TOUw5YkVEM0NX?=
 =?utf-8?B?ZEtpc3BDalF0MUJxR2dxbFlOc1hBMkEvVVo0eVpIYTZsZ05LL3ZUWFpLb2Uy?=
 =?utf-8?B?VGpkMUoyL0RCTjFYZlp4MWZkdmpIWWhOaEl0NllMYVozcjgrVHVrWG1WUjhk?=
 =?utf-8?B?dXJkcEErRTJjK2ZHTVd6amFwa0xLcy9IQnQ5by9zK2RmdEhmODNrelB6aVFO?=
 =?utf-8?B?UmNnM0d5dW1pSkRkQ0xGYVFLcDVrUlorL3orSXUxM3NCS3M0aEtXL0p6YTZC?=
 =?utf-8?B?ZkRnSnVxOGJlNXFRTzVMbGFiZHNYTDhuaUp1OWlFUWpZZm12TTBWTlRtYVdX?=
 =?utf-8?B?RUtaSXR0TEgrRStOV2J6VmFhL2R5VS9VNUxTQXZkaHBjaUZEYXNuTGhkRkZt?=
 =?utf-8?B?S0k1Y01BYnUvYXlEUFBwTzBhWVZNcjU1MUZiMmlUQlRncUxDZHhJVnA1UTE2?=
 =?utf-8?B?UGw0Y3JtWnc1RFpwNUU5QmpueThHSTBuQWhRc3FkRWU0b2gzK1Y5R0NVcStV?=
 =?utf-8?B?NDgwUkdwREJoVURNK0p6ZGJHV25jNlNZay80Skk0VE5MMFBSVDdaTTNoOU9W?=
 =?utf-8?B?Y0prcy9aZVBUZHNUSkVnOS9XNisrWjdjUmZGR0FxaVR2aENURW1xemIrMkRC?=
 =?utf-8?B?cXZuTzFjektJVDZ0WmhiZC9QdkdBa1JZK3pKS1BvZDg3UnQrRmlRN0xIdERa?=
 =?utf-8?B?MWJtQU53OWZQTC9SV1FsZHFkampmN3dKR2lEMjNlTFZna1hEWnN0eW9nbFQ5?=
 =?utf-8?B?MFZZRlBGbXJaUUNkdkdrTjRWZU9IYkx0RDF1aGM3dndpZjVlRXkyWmVHR3Zs?=
 =?utf-8?B?LzFRMnVFUFphVDVrRUZWbUFxTGxXTVZOZXZKUlc0RkZlUjV4LytYWmNxWnV0?=
 =?utf-8?B?citvV3ZkNzlraDJMYUtEYk9WZkRyYXpmTnBjaWE5UEtIbVN1TnUrRER5SlVo?=
 =?utf-8?B?L05SUnNjTjFZeE5WR0tSU3ZxOGI2M1hIeE1BQTh1aFU1MThXU0h5Z0RUWUN6?=
 =?utf-8?B?aU5yeUttQXhFY25UQTd3ejNKZnhCVjNRRXY4SjQ1bGNMbmFsMEFkd1FNcCtM?=
 =?utf-8?B?L3B1Tms5ZjJZUWdONVZQQ0xUTHNWTldmVi80bHpoTndPU2EwbjdKQXc1eEtu?=
 =?utf-8?Q?baH5cNbJJ8g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlFZVWlscFBwNHpTb3N2SkVOaEpObEZyeEpjd1dNUDQxY0YzYXNZakF4djBP?=
 =?utf-8?B?RlpvRkswejBsZ3UzK3Ywa1YydlZZcmRHOE9uSXRaSk9oUEsweC9pcEZEY1NT?=
 =?utf-8?B?OVFtRDduNU81VDZYM1BEc25yemtlK3c0aG1jamdKR1FwOHJ1T0tJcGRoWDdW?=
 =?utf-8?B?R0Q4a09xVzlBS2VtVXhBaytnL085dDg5Z3h5NzB2STQyOWxJaDBjWUltbUZP?=
 =?utf-8?B?VVc1N2dGYTdwNmRPOTB1bC9TbDZSZW9xOTRVUkhlZ0NmYzFrUjhrVlZ1Mlc3?=
 =?utf-8?B?WXJ5amsxWi9LWjdiRXdIcFhRSGEzaS9kMWlXamxXRlJDek01UFE4d2NxZUow?=
 =?utf-8?B?YUltRys3YzR4T2x6QU9VUzBJR3NsKytWTzdtRThVUURpTHJlUU16S0JwRGFh?=
 =?utf-8?B?WTdrL2xSOTRFdnptRmhkSi9ndWdGRWFEbVhUSGhvL2krZ01IQkFyZ2twdDdH?=
 =?utf-8?B?V0pPTzVFTkEzTXdIeUVnbk0vN0xvMlRYcGlSSjY4U1NMcThHZkxaTDdySkts?=
 =?utf-8?B?WjVMeU9BVS9yN0ZSYkkzVGRYN3gvY2Q3dVRBME4vWnFmYTdpeVQralRmTlBr?=
 =?utf-8?B?VnZ3bU52NjdHbHhuWlhRQ0Jwd3BqTVVQNW93UUtOclJPbjk3VGJXNTI3dUht?=
 =?utf-8?B?UmRVN0oyT29KNGZGenJWL1lZRU1EbkY3M25GUVg4WnR0T1FmQm0ySXBtM1Vt?=
 =?utf-8?B?R2FMNWJuaTZDUFVyR3k3d2ozbURCQkxiK0xOSDRLS3B1cVV5VHI3b2pSeDAr?=
 =?utf-8?B?R21naDE4RWtjUDd3bE9IWlBST1p3VkpHelFGb2tLTnlFMCtqcjFWS3lNYzNK?=
 =?utf-8?B?YXJBK05VR2NzOUI4U2Y4ZGpGakY1MVVqTmRaNVFoQnk0Um5haGVSaVJTK0Z2?=
 =?utf-8?B?WStlUFMwZi9sUVlwN0RsWjhpR21LYkFpTmRQOWZaTFYrdWljQmVMc25JNDNZ?=
 =?utf-8?B?Z0psclltNzQ0ZGd0MlpRaVBLenZjWVpUa2ptaytXYW03SEEzYzFKeXkvV1BH?=
 =?utf-8?B?NXNxdzhuVzZ5a280c1FOcU9nMVoyOU9QcFBTcmZpeUtaOExuVVlyL0FlUngr?=
 =?utf-8?B?ZGdKQzZQU2daUS84ZUxZUXd4cktWazB5bkxrTTBBWUhhTk1NK2xkeEFxeEFy?=
 =?utf-8?B?WmpWbStIK0h6MFRjNUNGbjQ0dmpnR1hiTFlkc3plcGJML3oxQk4wVGdPZTZ3?=
 =?utf-8?B?SHNkcDhLdDdjQkRZczl1bUVoNm84NkQrelZrR29IZ1g0WE9kRWd2eVI2cWFC?=
 =?utf-8?B?aXdnSVk2VmNGYURqb2JBekVicTdIamcvSmgveFpRTHdkRmQvZ0kvZ29aQ3Vi?=
 =?utf-8?B?aC9CM0FRYkF0SXBMbElva0hGNUFMWXEyeU43Q3lsTHo4VmR4cUpBcFFRM3Qw?=
 =?utf-8?B?MmNkVHlpeEwyTzJKRkxxcXdNZFB6L1EzbDdsWktrRDlKYnV5WWNIZGkrelBk?=
 =?utf-8?B?YjNOc3pjMzJFcDdkaXFTSXRhNmVFcVM5eXMyYVBIekNKYVhYMjNXRnVnTXZS?=
 =?utf-8?B?S3JyOFBNRFBFS0V2MlNhOTJsajBYWUdwcVB4clBKYTJTU1ZrSU4yQXlnRWVD?=
 =?utf-8?B?Q0RkOHpJUHFNY09ZczFmUW43QStlZXlMYmRJRytxMlYyaVgzRWF6UjBZL2w0?=
 =?utf-8?B?NVhVakJFbVp6UzI1ellBOElSK2pUYk43eFFNMGU3YWQzaGV3Y01kOXBBVmtS?=
 =?utf-8?B?R05BTDZEOFQzMytwbERPeDFTeDZSSUR0T3JsYzIrQUxrdWJMVk5FallMd0tX?=
 =?utf-8?B?MXRzR0hhL0pVVll3MXJDYUIxRXNRRU1lOWMxcGtMUU9mM0NZSldPVEx4cmUz?=
 =?utf-8?B?NFdKRDNjM1FPV0lJaWZ2aVBybEhSWEgyVmNoN1hheVVrWVA1WTIrWFBUbkhU?=
 =?utf-8?B?VFBOUFBESjI0VGVzVy94VG1hMnQ3eGFkcTNBZUhOMEdXWkpqamZGUzFXS3Ni?=
 =?utf-8?B?Um1tVVEyTmZJRjlXVHJubHdEVW1GNFlZaTkvcHdPQVAwTUVWaExVTFE2MVNK?=
 =?utf-8?B?TFlBMGoyY0NDYjVlZC80eURjcE8zQTZkTFR4SHJVZUFjUmF6V1hPWWFhTytC?=
 =?utf-8?B?NU5CQVBReFBuMGkzek4xRlJQOXl5V0tiT1dFUnEzY3pSVVJFUTY2RkozMkFt?=
 =?utf-8?B?cEdTZkpKd3FYTmRMMFdWWUw5ZXZXTnYvYUV3ejRxaTdnWXNpcEpvNU9VVmI1?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bdf7c8-18b2-4756-b2cc-08dddb7b565f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:41:33.4562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hjFkhOAeUKXUvj6GNBmQAM2PYGoiozFcutwzM4e+JcM7rmhvjx0gaDZy500TFT19/Zi7qxzgCfLIfiUGnyMZVA/wywoglpflglp6ePlwpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8988
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 25075f369148..09043d36e08c 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/resctrl.h>
> +#include <linux/slab.h>
>  
>  #include "internal.h"
>  
> @@ -24,6 +25,7 @@
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
>   * @guid:		Unique number per XML description file.
> + * @mmio_size:		Number of bytes of MMIO registers for this group.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
> @@ -31,14 +33,19 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	size_t				mmio_size;
>  };
>  
> +#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status) \
> +		      (((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
> +
>  /*
>   * Link: https://github.com/intel/Intel-PMT
>   * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
>   */
>  static struct event_group energy_0x26696143 = {
>  	.guid		= 0x26696143,
> +	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  };
>  
>  /*
> @@ -47,6 +54,7 @@ static struct event_group energy_0x26696143 = {
>   */
>  static struct event_group perf_0x26557651 = {
>  	.guid		= 0x26557651,
> +	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  };
>  
>  static struct event_group *known_energy_event_groups[] = {
> @@ -57,10 +65,54 @@ static struct event_group *known_perf_event_groups[] = {
>  	&perf_0x26557651,
>  };
>  
> -/* Stub for now */
> +static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
> +{
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
> +			     tr->guid);
> +		return true;
> +	}
> +	if (tr->size != e->mmio_size) {
> +		pr_warn_once("MMIO space %zu wrong size for guid 0x%x\n", tr->size, e->guid);

I think this message can be improved. Compare with, for example,
"MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n"
(please feel free to improve open to other ideas)

> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Discover events from one pmt_feature_group.
> + * 1) Count how many usable telemetry regions per package.
> + * 2...) To be continued.
> + */
>  static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> -	return -EINVAL;
> +	int *pkgcounts __free(kfree) = NULL;
> +	struct telemetry_region *tr;
> +	int num_pkgs;
> +
> +	num_pkgs = topology_max_packages();
> +
> +	/* Get per-package counts of telemetry regions for this event group */
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +
> +		if (!pkgcounts) {
> +			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
> +			if (!pkgcounts)
> +				return -ENOMEM;
> +		}
> +		pkgcounts[tr->plat_info.package_id]++;
> +	}
> +
> +	if (!pkgcounts)
> +		return -ENODEV;
> +
> +	return 0;

Returning success requires matching support to drop the reference to the
feature group that does not exist at this point. This makes the code increasingly harder to
follow since the code that is promised in previous patch is not available yet
but needed here. This can be solved by handling the reference in previous patch.

>  }
>  
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,

Reinette
