Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35803CAA51
	for <patches@lists.linux.dev>; Tue,  8 Sep 2026 21:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901976; cv=fail; b=Y4LIoZN8OGBcwLpAYg+QlkwKBATzhr03d8au84xzH9Pf1sfCHtjQcc8LHRcTSUL2MTkMSGrpmmgy2wUXqNCgpe95PRJ/Yxj0S5tA1FHBTBRt6xai9JV2T7CQ54mIieMh3k2m70ZPaqMUqNP1/hPWNhGfirtePkmpJqk0acQ1K8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901976; c=relaxed/simple;
	bh=OtmVFizi59h0xTvlU7PVVRJ2gP0aoYNkaz7ubB/KAlQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KA/bDJ/rNkP77QRYd7akjM9dt60q8odrkvc5u7CDNgj4UpvCUQhdtNa0akn4nNa612MqL5ruuLfpNhWW6fHeqNRQrlqoFlHNnGfevARkcKp1JHroa4i+PWU25JP2dUub2t/95Fq6LIz1mLqTpYDV+Jj+4I13EJQ/wPd1TLf2mqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7frMhYW; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7frMhYW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788901972; x=1820437972;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OtmVFizi59h0xTvlU7PVVRJ2gP0aoYNkaz7ubB/KAlQ=;
  b=G7frMhYWNA6ZUVe9Ua3snAzQjIsGo8OOWtdtmW7Ra3iLafEoZ0aYWKB0
   xsg7ne6u9Z91cmACPRgJbhSjurMaqBLl3ELUomZqEGjQHIK80zpn33Tmn
   eJGF6QSSJnvPXz82Gov0UGBNebQ4K05CARtyvRObOHKRPvmOC8xadzRGq
   4BNrDS7l6/xTJQUOqtF+U9RqTl0Yz8CvhObNKit4VhJ2SPsT5xY5991Jz
   AC0HkgbveXociJsjgLeynTL7xceDzafgUh7VeomvAyFX85Psml9mQ4Urk
   HConKuhv4IwcF2gll634rzIJOxh/+nfh8tC/uKrDSHk00BXpppkozIGoM
   g==;
X-CSE-ConnectionGUID: VEroaigwQMuCnsYOs5/87g==
X-CSE-MsgGUID: jkqmKUIBSO64DPiynWRsgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="99910745"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="99910745"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 14:12:51 -0700
X-CSE-ConnectionGUID: A9rQrFxkTaasrXLLnzHc8g==
X-CSE-MsgGUID: NxNe0IXlSIOFiwsDDgkX1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="276341962"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 14:12:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 14:12:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 8 Sep 2026 14:12:52 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.39)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 14:12:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGYL6Uw8HNmndah82SHvlHU3/X3i25G36sfwDiXXlLlSFZb4A6qnhIxuX+LvByVFgom7av4hTJ2fGZGWfreVYpdUaqenEoiKIz02OTa1QpZNrloLrWMs+5M0zB+0r0ajU579Io8gIJMAQp7U7bRKk9zH8w1XUswOG02PJxLqLLdBhGtDzSkUhFRnF+CBFEihW2CZWAMDjm3Fz/RlJw7Lx0SGImtSVCeviQObWdWjlwEMIJM+FBPmvX2tM77JTWZhLFkzxPDy1wZZkW60N8Uc0q3x0+QRtWOJ62ugPyfIkUkbg7Y+YpedqeJ/BkF+x8F1BvqvzHMr9+VHQHhRXd+y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMjjDRnf6rZl2lTHKDlKlH7SNqF5sX+pmbwcNyuzupY=;
 b=UDXDMv+B1UizpxCEN+lgv4JDThkLNi2a5d4mFwEUa99pm0e/L8VowDd1KVhO9S8mM0yYEW3E/l0+m2rhVWBsgoct3hvhZk3UEFO8X6cgnwFefN2aWIrO0DmimJQ2eLPqH6x689RS6uHzlLaJFfAMFwWvfaOrgDepA2aaBAi8GSHuwgqg80BqpjcherGvEsDCJy2/WkhaAo7yLT7GNEQ7hRIKzaIhKvtTDKIT4sfKfI+E6DmmbwED2jvgagUzLX+KDC92+7Lbk5UBcYTxo1SiefYe0Yb5MTwgITwszQFE3js+ufikaNucEEfO/0Wnwc+CRA4tffoT7ro4SDVIp/brmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH8PR11MB8039.namprd11.prod.outlook.com (2603:10b6:510:25f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 21:12:48 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 21:12:48 +0000
Message-ID: <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
Date: Tue, 8 Sep 2026 14:12:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <babu.moger@amd.com>, <yu.c.chen@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:303:8d::25) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH8PR11MB8039:EE_
X-MS-Office365-Filtering-Correlation-Id: eda0bbb9-f94b-445c-94dc-08df0dedef3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info: GMpZuduXbSXYVjtxI96lwdtsfdnzDqi3BYRTJfgQGVMmry8MFMseww9no7LxV6ayx62cScqsmhSK+Nyu4tsIBcilv4858wrWKp1LI+Y+U3pFnaJu0XBM2WN+dLg/1aa1kAKU3K0uMMZKt/VhQ4KFQae5L0enW6gzGrb7Cj2xdrSBzlMQWuSCVaLG8V97zK//kFLLP7kfSSx8v8lyTbPJ6O6EhnLZIAHaRCDijsoB4/qYvTEBDLbA9+u1yGBAUHs8eiunmtTkw7YRAGEBo3M7IhFjWDwjbLmdwVB8v9ODlx37RDADKgEGal7y9GP+5aTe6fEvE+wYl8zEibo64UF3sMgBrIt3z0LUue2RLyuYIhN/ZvUkRmxOkaN71oZ16bJ1TrDAuMvE9vZksKhxyCaa4piSA7spkqoW+p04yMKvf+vdsSRAQfzmhtl1UhzJijBe7qfgYI/8tgVfaI0c7BrDvRCeYjm0ULsKqN9qw5y36ONOUyIqDARhTfoQEwtTgkhUtzFbBUaFusgmaAu6YKwsuuiRxDplQ/yhMRZY5rR+cU+GfS66a7qH/z7Ruhg0eH3tAHFTYJPGXV1kSEFzY2clx0yMQ5DEKdjDpkxgWNqDLKcCCBmtxiAwFbhLg+YUgOG2xtNY/4XJ2ikqTHQelOUEX6xeh31eMeDJjHtoz78bM20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmRNL3N2UDYyR0pKOHRadG5VN3RzanZrVCtSK28yd0wyNGloVkJDSENLRXhB?=
 =?utf-8?B?VFY1NHpYNnc4R1VtNkw5WGxkcHFPUVNTR0U0UldNdUtPNDNYbDJIb3JBYVBL?=
 =?utf-8?B?dnV5R1NVakRzS3h2TzlaODgzeUY0dmd1TjR6NjJNektUZE9yTko0VUtLV1Q0?=
 =?utf-8?B?TFVFeVVOTHY5Y08vb3RWWEpLSDFlaW16UWpTSTVtRDVtZjk4N3FOMFBXRnJq?=
 =?utf-8?B?dHVLYmdNaFgrdGt1UWdpM0dwVVQxdjFseFI3bU92SDQxT2ZPS1R4QXNvVml2?=
 =?utf-8?B?c29iQk5sRDB2U2pvMCtHQloxM0lIZ0dON0hGRlhWcnhDcm44b2tuRW1YczBL?=
 =?utf-8?B?bW03WjZvUEs5cVdxVWhmdnBMekhXWS9taTllNmw3cmd1Qkcza2VvckltSmdU?=
 =?utf-8?B?Y0w3MjAzVzdXbWs4clpCMkdlS3A1dk5qUDE3SDN4KzhKV3grSkdVVllZYnJi?=
 =?utf-8?B?dzhEdWRjcHRTWjRtaHpYUENBWHBLUEtweU12aDBxTzgvVThhUUllZVV5dm1t?=
 =?utf-8?B?b1hZV2ovcENZQlJMTmNzbnA4NFJtUlVjUE14eElFSWNNemUwYkJRYitDcmp4?=
 =?utf-8?B?NWszck1JOVNla29QYkVIdGRHR21RUlZnSW54VGYyK3VqeU8vUXI5c3JEYm0z?=
 =?utf-8?B?SjFNQzBoVGRybk9FSFpFVDhvN3cxVkxXZkY2RHlCTlNmbTJ5VXY5Z3U3ZEh4?=
 =?utf-8?B?WEcxb1Znam03dy9aQm9JM2xLUEc2ZEgvbER0ZXgwc1Z2UEFzR2U1VENqa1NF?=
 =?utf-8?B?WGhGcURJOGNrRTZHdXFUZXY1ZEoxU3B5Zll2WkdXU1k5R2pJcDNMem5lTEtT?=
 =?utf-8?B?ZEw5bGlMek1IVSs3UVU0M0IybGI0SEx3ZVZvRHJWZUdKai93NHNxSUNib1VS?=
 =?utf-8?B?bjh0enc2U08zQzh0ZnJFU0p3cEl2M3REbEpvc2ROTSswOUtIQkRYL1ZZQ3V0?=
 =?utf-8?B?NlhrTndJRC90ZnFrS0liZjRSdERlai8xcTYxR0FwZ0VmazlMcWdxTzNpaU5N?=
 =?utf-8?B?cDFzQUljTnNuTEViVWlON2VEVFFybFBPUUJxUXIveTRpZzVxeFBBbHVCVXlP?=
 =?utf-8?B?UzBDSzczODFMcXliUGxGaGsrYTFGSUJ0RTIwdDluZ21VTmFOTG14ZjFOREJ5?=
 =?utf-8?B?Z1Z2dXN4UVMrcEw5UzdES0pDVGJ1QnNRR2ZLN0dyS1F2cXpRWmpvL0ZKMjZ3?=
 =?utf-8?B?ckNoTmo3TXF1VGZkV3FMSXpxakhXZmt0UnFuc3BuMEtPYWQ3TnlQQW9DU1U4?=
 =?utf-8?B?Zm9ZNjlxTXI0MzA2TGtTZmgxUDRQTUR1bzVnT0pIWkt1TXVmbngweFVPS1dy?=
 =?utf-8?B?bStwQVByWHVoWHM0MEFLVmZick5OenB2R1liV1dIR3J3dlZDWHZ6dnMram9O?=
 =?utf-8?B?MEs3aHU3OUZPUE1CUFhCU1QwTGxHZWl0MGpGOTJnQjdmQkpQb3owd0JhcFZj?=
 =?utf-8?B?UFd3Ylcvcm9QOVlWM3FiL3lQa1YvV09wQmN6eEpCMnljQ0dBU2k2RmNsMXZZ?=
 =?utf-8?B?K0d5MmdwYXNaLzZ2MTFYVVptQXN5L3hteFRVbGhSM1JzWEg0blByVytDcUxD?=
 =?utf-8?B?L0xDNkY3YVJwNGovQzNtaTQ3OWczSE1Dekw3eG9hTVd0QUNpRW1NWEUwazg5?=
 =?utf-8?B?VjdNeHhqODFXN3NlcHB6WGhjMUxlZkxBSFlnMGdUcUZ4azQxa2FUcktDclM5?=
 =?utf-8?B?cmhmL2l5Nk9rVHpmTzgzN2lHdkF1cjlIZ2pmeEJIRzRNaUQwbHR2b1VsV3JU?=
 =?utf-8?B?T3lUdnU2UmJZalZWWk16TndTWVhCc2JtSEZIN2E3NHUxVTV3WmZKdXFvYUZS?=
 =?utf-8?B?bFdHRytVQk9aaHp5SkNaUWNOMG1jcEJNSzR1ZVM1YkpScndacHRMbmRNRzMy?=
 =?utf-8?B?VjV1bWFTdU1DMW5jQncraUdrMGJiaGFRRVlXcjJERmxwd2k4S2FUV3hsb1p5?=
 =?utf-8?B?ekpUcnNqeXVrWmRMME9kSnNJaW5PZmM0Y2dhdHphUWgwU0poUHNCOTEybHJx?=
 =?utf-8?B?Z200eG5JdmgrdHFtWlIwZkhoc0pQbm0wcVRhd3RMbzNJWG4wblFXdUQ1Y2ho?=
 =?utf-8?B?TS9lUkZlSjVOYmFScnBNcmQ3RTBRWEdicm56K1o0M1ArS2d2Wi9lN2J2eUp0?=
 =?utf-8?B?MEJTUFp4NnFVem1OSlExN2dlTXNKd3B0QnBzc2crNlBpZ2M5U2JZRmpiekgw?=
 =?utf-8?B?dzJROTRGMGJnSnhHY09ReFdnWGRSV3hlL0cwTXhzVWlxVjRsUi9ETmZRSXoy?=
 =?utf-8?B?dHpGWmhPYXU5SzJiMjVQNFNieXhqcEJhTmdldU5XUHFibktFczYvSlIwc1F0?=
 =?utf-8?B?bkNlNy9DYjhvWUdyLzA2SFJkdmkwaFlWc3pEb2t1RCsxQjVHa0c1cXhPbXNr?=
 =?utf-8?Q?CF5yEaH+G9o7WMkU=3D?=
X-Exchange-RoutingPolicyChecked: X5DZcnPN8T4WDUeCCYDC+qJwxymA8eZ2M2mQfQsFRaiCvsmFpITvjD5Cqhklc4DMJCAkOaWN8kl4v4onXgsQV0YkTKsawLc4ppgJ3hCoepSbYw2k1UU3jHvm60WVYQ8uUgS9VQuxWe9Ja6EOKOFyllZDlXZqzqSrIFnzaxkJ77YQyKz+Ha4Xtc+MiOwfmBt/gjC7mRzugevlQpTEl8w5dTNQFL9ZfZmbPPMJ1qhL3KYS0kMces7bjnsrX+DqG1KhEJqfV0UhAB98R9Uf+6Pnm7ZJSPAPINk3TgvBG079dtyhblSWvwlZFiy78pTZi4S8jsWxuM38gPdW0Si6P7VVag==
X-MS-Exchange-CrossTenant-Network-Message-Id: eda0bbb9-f94b-445c-94dc-08df0dedef3b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 21:12:48.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7bd5QuR3LiGJzIzq9nGD3W6pt1bgjJ4v57td8uNkN3TY2BuqpnF7PBvnA8cmEFuPaZNbQBjDNjiCF0X7BNySe6YFYJAFMmJwvNjIpxG+J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8039
X-OriginatorOrg: intel.com

Hi Ben,

On 9/7/26 10:01 AM, Ben Horgan wrote:
> On 03/09/2026 16:29, Reinette Chatre wrote:
>> On 9/2/26 9:10 AM, Ben Horgan wrote:
>>> On 01/09/2026 00:54, Reinette Chatre wrote:

...

>>>
>>> 	/* class has no component for this CPU */
>>> 	if (WARN_ON_ONCE(!ctrl_comp))
>>> 		return ERR_PTR(-EINVAL);
>>>
>>>
>>> In mpam_resctrl_alloc_domain() this initial 'ctrl_comp' check ensures that there is for the class
>>> associated with the given resource, res, a component which includes the given cpu in its affinity
>>
>> Why does the monitoring require that there is a component associated with the resource as
>> opposed to only relying on the component associated with the the monitoring class, specifically
>> the mpam_resctrl_mon::class? (more below)
> 
> The class associated with a resource does double duty and is also used as an indication of whether
> the resource is in used at all, see also mpam_resctrl_online_cpu() and mpam_resctrl_offline_cpu().
> When a resource only supports monitoring then the class providing the monitors is used for
> res->class. As such, a check that there is a component for the given cpu, in the monitor only

Regarding "class providing the monitors": From what I can tell each monitor event is separately
mapped to a (potentially?) different MPAM class. With MPAM supporting two events, each associated
with a class, which of these classes are used for the class associated with the resource? 

> resource case, is just a way to error out early when the monitoring class has no cpu. We shouldn't
> hit this though as all monitoring classes are check that they have the same topology of the l3,
> cover all cpus and there components correspond to l3 instances.

It seems as though there is a requirement that all the monitoring classes as well as the control
class cover the same CPUs with the implementation flexible to support otherwise while assuming it does?

> 
> The resource supports monitoring but not controls case only occurs when there are no l3 controls and
> the condidtions for pretending the memory bandwidth counters at the memory are at the l3 are met.
> Those conditions for pretending occur when there is single l3, a single NUMA node and no
> intermediate caches.
> 
>>
>>
>>> mask. The class is all the L3 MSC or an equivalent of the same scope, see mpam_resctrl_monitor_init().
>>>
>>> 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>>> 	if (!dom)
>>> 		return ERR_PTR(-ENOMEM);
>>>
>>> 	if (r->alloc_capable) {
>>> 		dom->ctrl_comp = ctrl_comp;
>>>
>>> If the resource is alloc capable this component is used as the domain ctrl_comp.
>>>
>>> 		ctrl_d = &dom->resctrl_ctrl_dom;
>>> 		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
>>> 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>>> 		err = resctrl_online_ctrl_domain(r, ctrl_d);
>>> 		if (err)
>>> 			goto free_domain;
>>>
>>> 		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>>> 	} else {
>>> 		pr_debug("Skipped control domain online - no controls\n");
>>> 	}
>>>
>>> 	if (r->mon_capable) {
>>> 		struct mpam_component *any_mon_comp = NULL;
>>> 		struct mpam_resctrl_mon *mon;
>>> 		enum resctrl_event_id eventid;
>>>
>>> 		/*
>>> 		 * Even if the monitor domain is backed by a different
>>> 		 * component, the L3 component IDs need to be used... only
>>> 		 * there may be no ctrl_comp for the L3.
>>> 		 * Search each event's class list for a component with
>>> 		 * overlapping CPUs and set up the dom->mon_comp array.
>>> 		 */
>>> The MSC at the L3 may only have monitors and so no control component.
>>
>> The code that follows is:
>>
>>         for_each_mpam_resctrl_mon(mon, eventid) {
>>                 struct mpam_component *mon_comp;
>>
>>                 if (!mon->class)
>>                         continue;       // dummy resource
>>
>>                 mon_comp = find_component(mon->class, cpu);
>>
>> Is this find_component() perhaps sufficient by itself (without the earlier "ctrl_comp" check)
>> to determine if there is a valid component associated with this CPU to support this
>> monitoring feature? 
> 
> Yes, I think is the "ctrl_comp" check is taken away but would have failed we will end up not finding
> any relevant monitoring components.
> 
> Although, as written it seems that it is ok for mon_comp to be NULL?

Yes. Are there scenarios under which it will be NULL? If it can be NULL, does it not
mean that the event that was already enabled during init cannot actually be supported in all
domains/components?

> 
> Isn't any_mon_comp the relevant thing?

(answer below)

> 
>>
>> It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
>> like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
>> consider the component at all. Would that not cause monitoring features to depend on which
>> CPU of a domain comes online first?
>>
>> Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
>> "ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?
> 
> Doesn't the !any_mon_comp check provide this?

This is the part that I do not understand since any_mon_comp seems to support the scenario
where a mon_comp may be NULL which is a scenario that I do not think resctrl can support.

At a high level there seems to be three affinity masks used by the monitoring code:
the CPU affinity of the component belonging to the control resource class, the CPU affinity
of each component supporting each monitoring event, while these are three separate masks with
code sometimes treating them as though they can be different they are actually required to be the same?

> 
>>
>>                 dom->mon_comp[eventid] = mon_comp;
>>                 if (mon_comp)
>>                         any_mon_comp = mon_comp;
>>         }
>>>
>>>
>>>
>>>
>>>
>>>
>>>> 	struct mpam_resctrl_mon_dom {
>>>> 		struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>>>> 		struct rdt_l3_mon_domain	resctrl_mon_dom;
>>>> 	}
>>>>
>>>> 	struct mpam_resctrl_ctrl_dom {
>>>> 		struct mpam_component		*ctrl_comp;
>>>> 		struct rdt_ctrl_domain		resctrl_ctrl_dom;
>>>> 	};
>>>
>>> What you have looks to work for me, with some local cmax, mbw_min, mbw_max additions but with the
>>> new layout also works. I gave it a go with this mechanical patch which uses the new layout.
>>>
>>> Thanks,
>>>
>>> Ben
>>>
>>> commit c67c624149474b96e07ccedda11a11ce968e5599
>>> Author: Ben Horgan <ben.horgan@arm.com>
>>> Date:   Tue Sep 1 17:36:29 2026 +0100
>>>
>>>     arm_mpam: resctrl: Separate monitor and control domain structure
>>>
>>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
>>> index 3304ef64fcae..855f06657554 100644
>>> --- a/drivers/resctrl/mpam_internal.h
>>> +++ b/drivers/resctrl/mpam_internal.h
>>> @@ -393,18 +393,14 @@ struct mpam_resctrl_ctrl {
>>>  	struct resctrl_ctrl	r_ctrl;
>>>  };
>>>
>>> -struct mpam_resctrl_dom {
>>> -	struct mpam_component		*ctrl_comp;
>>> -
>>> -	/*
>>> -	 * There is no single mon_comp because different events may be backed
>>> -	 * by different class/components. mon_comp is indexed by the event
>>> -	 * number.
>>> -	 */
>>> +struct mpam_resctrl_mon_dom {
>>>  	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>>> +	struct rdt_l3_mon_domain	resctrl_mon_dom;
>>> +};
>>>
>>> +struct mpam_resctrl_ctrl_dom {
>>> +	struct mpam_component		*ctrl_comp;
>>>  	struct rdt_ctrl_domain		resctrl_ctrl_dom;
>>> -	struct rdt_l3_mon_domain	resctrl_mon_dom;
>>>  };
>>>
>>
>> Thank you very much for trying this out. I find this layout better since the
>> architecture domain structure only contains those members related to the domain. 
>> I see your snippet is based on the PoC, would you prefer I incorporate it into a new
>> version of the PoC to get some more testing or to create a new version based on
>> current upstream so that we can work on its upstream inclusion for the multiple
>> controller support to build on?
> 
> In the spirit of getting the precursors for your PoC upstream I think it would make sense to work on
> this for upstream. Whatever you think is best for progressing multiple control support is ok with me
> though.

I think that it will support the multiple control work if this is done upstream first.
I will incorporate your changes in the next version ... I believe that would make you
a co-author?

Thank you very much.

Reinette
