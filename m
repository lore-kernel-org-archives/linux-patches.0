Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBB023B618
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505388; cv=fail; b=eC1LlfiNX+HfME18fQMFKHznNZHlMZqAAN/ZirJJHFxqJGcmxqXes9+wCM9eAK11XBFYC1YtTEzO00eXSjrOU6b9WzSnXWYWRbHd44bNLYG39VvA/dc1chaBR/3YwyMzhPX//zD39IgjixAo3G6VVgyQ/0HSUI0nd9vYaWim0qU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505388; c=relaxed/simple;
	bh=AROn5CmhVyUaIdiyioo3/eVfWD5jXspeEwyg284AJsI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rGQUpkjqHO0LdQ/GWmIzO/xm4R3RmlWNELsPdWrYimkwA4DjJkXmvghrR0AL29Et5xixlCdQGZRj4nJhHDO01DwI681v6wrvPRfNrKGtQSnM2k7CX6hfMoq8futEZXmmZHCUbsC+1cy8bBfQrVpH7xvRAN+noQtTNo6LHnPFYpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MnrY2bWj; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MnrY2bWj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505387; x=1791041387;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AROn5CmhVyUaIdiyioo3/eVfWD5jXspeEwyg284AJsI=;
  b=MnrY2bWjclB+SUTE5RJ8YttjkgFapUpcONjCWITThrmNxFU/r4KvKpqL
   gEb8x6X+Pbx9N+9eIzkvUmq1o5AjaSrNWLN5ozU51J6sz8jyEKAEd0Z3Z
   yemY9gccbtHDvNzk4raA48pD73kNK/zXH3Wtdi6o72a5ujesvTljUZhsF
   owrn95jQ0ix8LdGm4+ZrT1U660OipP1US4EzRBE89Ib2zRYZbAil+xMH5
   m9QcTXSzzrvuJHRiQEW3/NFSfsqiTzqkwsBEEjMJraYiHyFUUPLrGQFHc
   CXKi18qyDQ+O0q/8LEhjU3m50HiPBhGB2xciq9Pjl2lew9gztVmoaMJJq
   Q==;
X-CSE-ConnectionGUID: OYz97PWHT4SRBL6yaSI4QA==
X-CSE-MsgGUID: urB6D4WrQLi2IuRDpNryAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73142648"
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="73142648"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:29:46 -0700
X-CSE-ConnectionGUID: GlGlExQWSjyfq827mP70bQ==
X-CSE-MsgGUID: 1+JyDuR2SwG3nT9k5Q5Gzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="178441017"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:29:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:29:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:29:45 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.35) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:29:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLPq+2iZGL0lhYvVvS1WBKuFA5IlPS9QrOmWDFkX47trizntOczrVgvJPOUOzGgQb17jma6y4pGtucQ7GE+9JXq5BHzXOu54OJZIcrPbtnioTJqQeTXQYyUidnHXyaNkMilM8slPyadpRbDbaCfQGcRfUzKE//NvrPpgtQZWrbDfY/wZUboeCSJC0BZbFlmV8P6SzsNa0YsANpRfkGQVjidvoOMKc3zdYAPZJvjQC9ZynpU50ANwExo+/BrBofaWxGsNaDHCTtrol+SA+1ypfd21EcIYJLKk2JZH5BYqglV3Yh437nv4aoujgLH1p0eqGKwFhmzIrKjVroNF+AdPgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+JUZA8JkHamW4oZ8QrOm+rGrwLcLtL2rNW8S0aw+i8=;
 b=PHJCx19RKFoFlx8Jzkg+gFpFOLriZxMk50CsDJYbnAK2LRufvR90OoJGQ7xcXM2vjwBJKLq8RovoyLCI9JWF7QYbzv6gyoCzs1XWYAMCOJfy1bFFJC5Wl/BenWitLQkZJp9WoRm8F5pJlQWm2PEJMDFvwbgOKM9aD2mXT8u82ThZlKCzQzvQR1+hEyU2W2709CZ/HvZonDZL1T3mmw2caVnkzuNhCVAMICXuQfje2tQmgsF2VyPZx//RvGKIDBxNmwZGEIbTQ+mffyaYyrEHGc2XvxQgv5gAUCiUFx8FyFYE3Hx8Q5D3PGxhFXm5hu9uYy1jFQqwplXYUAG2IGgP7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by SA1PR11MB8796.namprd11.prod.outlook.com (2603:10b6:806:467::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 15:29:39 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 15:29:39 +0000
Message-ID: <a28f8808-5e0e-4998-82d6-1da0db2b571d@intel.com>
Date: Fri, 3 Oct 2025 08:29:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 03/31] x86,fs/resctrl: Refactor
 domain_remove_cpu_mon() ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0144.namprd04.prod.outlook.com
 (2603:10b6:303:84::29) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|SA1PR11MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f1a2375-4d2a-4169-4269-08de0291aad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anVWeEJYQ05JU2NVRyt3cFFubk94anpOWDFuVXE4WWViTmN4K1B3cVRQYkQ4?=
 =?utf-8?B?QWh2cVhBOFlJNWhlVzk4Uno5bDFTbjVVbC91U1hjZ0piSFZLSzlwNlIrTDFu?=
 =?utf-8?B?T2hWdkM2eUdGbnN2MFFnMFJFTDh1OXlMb1hGRkoxTFI0U09UVFNLUzJraGhM?=
 =?utf-8?B?WHcrRGVBdTVnRE1nSTJDY09yaEdhaG84Qm5jd0VhZml4R2F6ck5YVFN4Rk04?=
 =?utf-8?B?NEdnSlNVR3Z3YXpjcHpROXVFMGZOekJvVDZZWHlLQk9Wd0hTakxocUZnQUwx?=
 =?utf-8?B?cVhrTjVCdDdnc2RBdkthamZPbGU1b1lScVlOY2pFMDA0WVFnSGtsb2VGVTU5?=
 =?utf-8?B?cXRiWFRhbnhpbklJaVhKa3ovMnJXN3VrMnFBR3ZLOGNLT1FWMS9nblVRVU9v?=
 =?utf-8?B?c0pheGYzQjhXNmtzQnF6ekFSUEF6RzU3Y3FoK3NaNSs2SDhnUy9Obmxtd05s?=
 =?utf-8?B?SXZTSWV2MFBDSnAzRWJVemYrL2gwcms5ZzJqQXlJVkV3TndFR1BhSDVOUnZo?=
 =?utf-8?B?aUpLb3MrT0E5c0VSczRGRkJFMWd2Zlg2NDdYd0c4Q2JWR1BYdWg2NWh0cm1l?=
 =?utf-8?B?QitIU3AxTVNaNHFDMWN2eERaWTVkZUVIRjNOK3JGVGQyTDBUY0NxVDB5ZUYr?=
 =?utf-8?B?cW1kSUhtTEhScGdsWG14RWFtd1EwZ2ZxaU54ZmpCdHVIZDhOTkwzVll1VCtz?=
 =?utf-8?B?clE3a1pDblFpWlF4bDlwZm5sTTVpYjRpbmFDeGxjLzN1YXVIUWE2THhCTkc5?=
 =?utf-8?B?NzFDTnpZTlRlNE5tQ2Y0RDZwWVRMWEJhN1Q5UFhad00xeDdLOE1LRjJpWnYx?=
 =?utf-8?B?NGVKL0ptbzZ4TlU1VmhpRWFMOWthcW5kcnhtWXpoRTYrTkJyekw2bW41RVhB?=
 =?utf-8?B?bnEyYlR2b3J6RWFwQVYrRFoweGpLMUNBd2UwME9ZR1p0ZXFWNVI3MlZNU0Y1?=
 =?utf-8?B?cVBaK0VzNzVxL0lrMFoyeC9JUjBsRHZZZExtZVdHcFlKUGMyN2FxRitRN3JS?=
 =?utf-8?B?Q25YamF5ajVSSmU3RkliV1JaeGZyVEFoT01jWTdNSkFMRVc5dWEvRTQwODZK?=
 =?utf-8?B?MEw4OGdmaVpYUUhmY0hrSG1YUGhWdkhTakVmUjdxcFBNckpWVGY0Z3dDUmNv?=
 =?utf-8?B?L2paMGdyTm9vbVY0Rm1VcEpyQTVGZEZwWHJLL2d5bG1CZkdmcEJNYkJueE5V?=
 =?utf-8?B?RjlQeWpscndVVWF2RmY1L1U2Nms4cHM0MlZieFV0WHl0MmFlZUs3SUMrQUlZ?=
 =?utf-8?B?YkNVaC96eVI2c2E1R2FnQ1hEUU1acGIxWFhLUW9qc2hubGFMZXpyNndFNTYr?=
 =?utf-8?B?UlJRWjFOUUJQK0VNbVlWTXZMRUE5YnVnZzgwMnNkY2hiS1g0aytHVXNxQXM1?=
 =?utf-8?B?bXRFSEplaFRFajkrd1IvUC92WmRPb3NOcFByd2p2ckt4bEliWnoyUjN3dmdH?=
 =?utf-8?B?eDZISERna0N1am82ckl2cXE4Q1hoTm1rRzQ2Uk5wSUlKTkFRZ1hxazROOUVX?=
 =?utf-8?B?aTdTK2NpWUY4ZjQ5S3VrUTVHUFlzMUpzQVJWa0x2QmJUL3E0OHp3aGIyTUlF?=
 =?utf-8?B?d3NjRm5hM3pSdHlkL1R4S3pmdVdWeUpHK0xvM1puNGM5bWt0NXZjVW9FbnRn?=
 =?utf-8?B?Y2FvaGtVcERCNUZha3JFY3BOQTNLeENqYlRJN3Z4QXhrZHp4dkFHUDE0Y0g3?=
 =?utf-8?B?T1NGcGNmNU40N3FhSk5Qc3c4OW4rdUtrR1I0Y3Fic0picGlGQ2tJL1NHMERL?=
 =?utf-8?B?NC95UTZxaUZyaTdVd0lhTC9zQUZsYXdSRkZsRkFXUERRQ0dhS2had0dlZEFu?=
 =?utf-8?B?WlMwYXBVa1krMnk5S0NlVEdpQzdzQUhrblp0dTZUTnprUFBGSzNqZE5ucG9z?=
 =?utf-8?B?MHRFWWFwNFExRkZYRjhwbVo0cVpET0VScEFVTWs3bXNwY2h3cExIeEpwZ0ZI?=
 =?utf-8?Q?+i22WCKf7w9XHuF0KbLlcvcrmpaEx4O+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmNaeUxqUzFiNmYvZkdMNUpGaC9rUXVIZjMzYS9KT3ZBMnVhSmJwSm5wWWJp?=
 =?utf-8?B?bHBEcVJRVUQ2WDZwZWFaOWpYNUswdEl3cmhGYjdGSHZDOVNaMkNURmFyR2N4?=
 =?utf-8?B?SjB0V2twR1RTUmx2aCtEWGhDRWdybTBWNFFDT3ZtTUhDenFzcGdnWGpXbUYz?=
 =?utf-8?B?UEVQeWd1R29NU1prQkNPRERMOWpoZnMvbUY0d0drS1JiNG8rMEpILy9wR3px?=
 =?utf-8?B?a3R3NlRtd0J1NVRJZTQvUmZKM1AweWZHbGd2am03dWQ3ZlVoMEo0Sm5NSHFG?=
 =?utf-8?B?WGdvOFZVVkFOcFZWeGozb1JCV2o4YmZyNk5US2pYRy9ySU8yWjlobDNvUUJO?=
 =?utf-8?B?YW1kdGZzU3RCU1gra01QK29raTZUT1d1ZHZTdEx1R0oyVTZGTTFkOFZqUE5N?=
 =?utf-8?B?MVBCOFZ5VHpuS3FlME9rVUFFbjZleXpDaWhlQlpOdEVUSDJKSS9mTVBuN0dI?=
 =?utf-8?B?Ly91a3laazJtbExLbXppbk5GRG55and6c1RaRU9RTXFBNGthR0tRMmEwN2Vw?=
 =?utf-8?B?V0RWdXNBRm81T1dXQjdMMVQ0eDh5SURJVnJ4Z2R0Q2VDb2ErV2dHdnBwQlBy?=
 =?utf-8?B?emxpMndWZUJEd2dOaFV3c2RjcGRITkMwVTNiV1pkV1ovYlNUaUVmQmQ1L2hC?=
 =?utf-8?B?MzBZTkxDeVhqejVjTlVKdVJYTXhrdHV2c0FsR2tLWXpTZThiZkRPZU80V21O?=
 =?utf-8?B?TFZpdTlhTDZiWnh4REpOeXFxSWdIQUZaWDBoRjVjRkpTMWM3S2prRmhYMDd0?=
 =?utf-8?B?VTRSRkU5S2c4OUVkMENuaDdoZXhhRm1YUmk4dHdOVHUzYUJCVkdZVlpScEg5?=
 =?utf-8?B?Q2JDNG1uaUQ0cGZ4NEp1cFpJK2s3d0xwQVpaMmM2WVZRWWtaajBYazgrQ2I0?=
 =?utf-8?B?c3J2dDBNbXBCcjI1ejIvMS9hWFBTeGN2UkhGMnJWSUZMUlNYOFRIUmtUQXND?=
 =?utf-8?B?dTJYZ0pCRDlMZHNxdEQ3TzhUSzYrUHVZS2Fndkxnd3h2SnZHWU1tRUt1US9X?=
 =?utf-8?B?b1hNVm13VkpIK0NkRkVKU1A3RjBSYWhPT0pINTdyT1dJMTNHZWNkRlFWV2hT?=
 =?utf-8?B?TE5CSlN1ek5kWFN2WTg1bTFwbFhMSWpHclFBYmZrYnNmc29iV1A4Yk1EQWx2?=
 =?utf-8?B?THFwNkV2Sk9yVWdxdm1CRjlvd01ndTUxMmhUdSs3cGlqMkZ0WkFEVEtFZncr?=
 =?utf-8?B?Y0txajBwWTBmUXJiMnNMZFNGc1VQSUMzb2g5RklmNDJHZmgzR0t0ZmVsS1pS?=
 =?utf-8?B?Y0hIeVE5MVFvMDkzZHdRV2ZqcVZSSVlPZmZOSDE2eDBaTGtaRmh6SHVHbDhY?=
 =?utf-8?B?T1BvV0FjK1pnM3hRQzVKU2NaUWphTGJyejRQREJCVStlTkFlazZPcmE1cmRk?=
 =?utf-8?B?TEVDODVGK0tueHBsSXdKaXdPMitjeFpCY0QzMFhHM1ByOEI4dW1ZNUxYR1p6?=
 =?utf-8?B?a1hoZlFsNFE0Vk1qU0Y3enNFTEJqZ3l6RDFEb2hSckM0Z3VGbGxqZ04wNlZP?=
 =?utf-8?B?alRUb1RFamtkKzZ6RW9OTDdRTGF4SDFhMWh3MXBUK01zbzlKeVJ6QncwYVlD?=
 =?utf-8?B?a0wyaXRZS1dXamUwUW15KzMwcUxRVHZrd3pqOTN3WlprUjAyN0IwQjBpTDJC?=
 =?utf-8?B?aUx3TjFBMkt6aEkwc01GdFFEZUU2N243NW9MRXNONWRTREpDa2ZsWkhycGR1?=
 =?utf-8?B?NTlxWVI5bGp6Z3JIenBVYmY3UkpzaFg1MWVhRTIzaE5zZXBPRndVbWFuS3Ux?=
 =?utf-8?B?Rlh5Q1M0eGRVeWFRZjFUOWhFeDVQVFI0Z0l0TkI1aVViazBvWmRDbHh6RG44?=
 =?utf-8?B?eXdQOExlVm00NE05bStHNzhaVjNzRXJLRDhHYURzMUtiQ0ZTVDRYTE1LRzIz?=
 =?utf-8?B?dDQvcElpUW84R2FDaDJzNWpScXZESU9LNzQ2WTdzSlJLOEFqUzJqNnJSa25j?=
 =?utf-8?B?ZmVKMHNTdVFFUTB0QTdSQ3VFYlJJVWp6eEN1N0FqYUZqR1VpTFZwV3FaSHF2?=
 =?utf-8?B?VCtpZWhQZjJhR1RIWEh0VGMwT3AvanpVems4bGV0S3VrWFJtU0l3ancxMTly?=
 =?utf-8?B?Y1JzSmFPNVludWc2TkpjRUtKZ3pVM2VobklyNFFIYWsrRk96YzlqdFZTR3FI?=
 =?utf-8?B?dTdaQXQ3L0pnT2VJdVVxKzhJUXhTVlRQbHNEZm5IMDRzM0x4NUdjYzRQWWZi?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1a2375-4d2a-4169-4269-08de0291aad7
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:29:39.4698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rmAR/GfWXmwDIZ58bLATRoacyRBFZMPB/dp/I01XJB5ehmu0BRa20EltGh75aUpFuXG7x+VEpx40qbh4pC/rNjpTNuCElmBTv0GUmpV3KM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8796
X-OriginatorOrg: intel.com

Hi Tony,

Note that subject prefix indicates resctrl fs code is changed in this patch
but it only changes arch code.

On 9/25/25 1:02 PM, Tony Luck wrote:
> New telemetry events will be associated with a new package scoped
> resource with new domain structures.
> 
> Refactor domain_remove_cpu_mon() so all the L3 processing is separate

"L3 processing" -> "L3 domain processing" ?

> from general actions of clearing the CPU bit in the mask.

"general actions" -> "general domain actions" ?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index d422ae3b7ed6..b471918bced6 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -645,20 +645,25 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  		return;
>  	}
>  
> -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
>  		return;
>  
> -	d = container_of(hdr, struct rdt_mon_domain, hdr);
> -	hw_dom = resctrl_to_arch_mon_dom(d);
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L3:

This function evolves to where its local declarations contain a mix of domain structures
of different resources. I think it will make this function easier to understand if the
resource specific structures are declared local to the code block dedicated to that resource.
		case RDT_RESOURCE_L3: {
			struct rdt_hw_mon_domain *hw_dom;
			struct rdt_mon_domain *d;
		
			...

			break;
		}

> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return;
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		hw_dom = resctrl_to_arch_mon_dom(d);
>  		resctrl_offline_mon_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> +		list_del_rcu(&hdr->list);
>  		synchronize_rcu();
>  		mon_domain_free(hw_dom);
> -
> -		return;
> +		break;
> +	default:
> +		pr_warn_once("Unknown resource rid=%d\n", r->rid);
> +		break;
>  	}
>  }
>  

Reinette

