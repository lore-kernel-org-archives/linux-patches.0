Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA36917580;
	Tue, 11 Feb 2025 06:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739256531; cv=fail; b=Gj1gGCT83udbLUIvkjqpFBaZZajX6APucUyvyqwQ3EL3DVJYEQ4wnUPtVGITTuCpkxdI0sms/AZrSfiFwCMM6hC6xubDcqe2wqECk5HOeWoSF09LB8xVfO8VBzB0U0RlYsW91GSXenJlYsHFMcglxsg7BecCDCPdpa60aLI5a3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739256531; c=relaxed/simple;
	bh=id3pCgjRcXEvZ52pe46c26KmkfHWum0a2b3YDjoTxCs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mgaIvVqeEGhQ3mOasmVFuerlSs7cMsfYKfRx5UWq+jpSnj/owEoFPNS/OSnm43XmHtnepqX2mivi672ypjxr5ouwecXGbfvdilkER1oOay+iIAvbDC+IcV5IihEnHwSGRutDZg+O5AHi2jpYUcTQ4MWoXv1m5wDA3DFvYagZOF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTN3irio; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTN3irio"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739256530; x=1770792530;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=id3pCgjRcXEvZ52pe46c26KmkfHWum0a2b3YDjoTxCs=;
  b=aTN3irio5N98zOAoamPBvG2JlQQJYig9zVx4HTkfy/TSJ6qpq5DbJiDb
   9s1SL/Mnp77hu1mPST9TnpthH981xgDlHw+L+1Qaa0dPIRxX0qxm+21it
   akI1gNUH57SkmbuUNDSYW79CfeSyGdlr2wSqDD2GtOzwXu6YjangKZQ2V
   73S5rP8Vqk3v7BY+aV0br5GInrhNEbg6JupjFYFZr2yCoFQINdvIt31hx
   siRT4t/GsyDT1fLFiwf1Z7KO1y9wr5VDlGUxZuMprIBR1Hd7LO+Dqx6vA
   xF4BVXTdBlgMjKKIbD3lKG/X91SZ9b0uu5kP8gEv0aDiqLqbmTu1DS6ua
   g==;
X-CSE-ConnectionGUID: N77B1lKbQBy8Rcgxsxm9yw==
X-CSE-MsgGUID: x/Ji4fLkQPitE7+J5VHIGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39880892"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39880892"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 22:48:49 -0800
X-CSE-ConnectionGUID: o+Oz/01oQouOxngB3AtW5w==
X-CSE-MsgGUID: 2UOhboG0SnqVeEs5uu5GlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="117499634"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 22:48:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 22:48:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 22:48:48 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 22:48:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTHB/saskciJjZ4Zslw/jc8kifV76qjICcjq/5hcEYpQS7AxEyao7uMcliOtGa9tyLGMwCuUBpLI5rhucE/gG+cRdUPIPAs6I7SKY5ad9Z9w1MZxpiNayOSI9kKaMt08nbCQJTJdc226O2d78mOgIcl/Mji6YuFvj1xoGMf57pmGAToz2vXttBdp2PglP8twWT+tqs52//M4gW50nrlCtroCaWQBxeKMdLpSF+MOzDhyXDaW+5fXOfTUUNyQVZ1wgVKdi20znzWQNt5O8MzLL9irqNz2XQgesq0auKKeJmOTJnhwK5VlqVJJR/CxiK5xS53l0tdkUSK81JwN3eafVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VK5U8jRqiZa1Sxk6HTltOIzD7lcha4mOEl8gFlOGalI=;
 b=EmmiHiXtyJaFYKIoI6n7BRg6/5Q5gSoECOWNS41yTXLqYde/wMrRwo0N1giBGs9y8e1yHetN6pWPAUC6wdOOwkzk7Ua7/H1Qk+MmT4/czSSEvOoj7t1BehHAPhSX3XL7Widfa/ynqwc29J6USUzcm1s3JoKN8G+hDFoDoOoitzcWQO1vxn5WQKSLqheb8roz6IwkC78mVIbZXOVGXjUv12Nn3YRyKv7z3zH3nh9Jp0r4waqEEIT4K3fBW4LrSwBi7oZ0hs1B6s7lqr4i2yZbjn2fjohemz1kQKZ/LYZO88o3tk68bi8GX7HoDGeZhbLakSlRYm4jxq67qrg160ouUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Tue, 11 Feb
 2025 06:48:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 06:48:43 +0000
Message-ID: <015e3609-495f-4ccb-934f-e52f20ff2ee0@intel.com>
Date: Tue, 11 Feb 2025 14:54:03 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] iommufd/fault: Remove
 iommufd_fault_domain_attach/detach/replace_dev()
To: Nicolin Chen <nicolinc@nvidia.com>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>,
	<patches@lists.linux.dev>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <cover.1738645017.git.nicolinc@nvidia.com>
 <3ca94625e9d78270d9a715fa0809414fddd57e58.1738645017.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <3ca94625e9d78270d9a715fa0809414fddd57e58.1738645017.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0019.apcprd01.prod.exchangelabs.com
 (2603:1096:820::31) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: 8100d90e-3e72-4ac5-bc19-08dd4a68204e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TmVjMHFhL3NwZFIwU0FhOUY0U3lubThiL0IrRWR0VEJoZm1BQldSMDFmUEJE?=
 =?utf-8?B?eGRtY29xaDc2NlFNaHlxWnU5QjJOUkVxTWk5ZUtsMHc4aGpGWnZ0bjBacnVN?=
 =?utf-8?B?VDZrWXR2Qm9TOXZpK1FqVUkvLzZROGViV0treld4QjdoUE5ORm0xVU9kaUR1?=
 =?utf-8?B?dHVJOS8xdXBhSDdaUS96R3YrN2drc0ZiWDFXWkN4aTFEWXVrMjlVMlJTRExI?=
 =?utf-8?B?NWUyUHdOSTRaTU1yUHV1cWFQR3dheFdxeXJUUTZhaG5jQUM4cjNjNll6a1gr?=
 =?utf-8?B?b1ZQVU5sZGdBZVo4QWNsci9KVFRBcGdNeEhNWFJkQ0xjRVBraWNyMmw5eUo2?=
 =?utf-8?B?bjNldGRpRUtndXgyaWpvODhrOElNb1lXWXNld21RdWg2UXdjOXNtOEJsY3Fp?=
 =?utf-8?B?VVhzalRvYTV6M2s4RGdTcDJHRCswcUw5MTlHZFVTaDJjUGQzRmdGYW1oRWpJ?=
 =?utf-8?B?VDdqQUdpMlduV3FXUnBMSVFUdUZJbFlpekd2NVlsRTg2ZFRJYml2UmVhZlRn?=
 =?utf-8?B?b3A0K1FEY3J6VjNORmhpcnNHRjhtb2RFM1JSVkdrMThHcHFNbnE4Q09yMTNi?=
 =?utf-8?B?OTNGaFpYSGdQUWVmOVFLeFRBRVBOQ012RUczeE81TDBDNzBuUFFMNENpR05y?=
 =?utf-8?B?SzR2QWhrMjVqUzFqOFBKOWRlb2ZPZkl6c2hTT1FSRnlycmdma1JBT25EajZZ?=
 =?utf-8?B?NGpTMktOQ2w3bGhhRmF1eDdMR21sTTYrNDNaaW82RjlGT2Rjbm1PdERKSmtK?=
 =?utf-8?B?RGhRUHlkeDRRbGlSNmFoa21SY0t2N3hHWjNrTVdTbk13dHdKcUJWUGtFMWx3?=
 =?utf-8?B?bTJPb3hwZVFvV2c4b0RzRTV6a0c2WHNNRmxOVURrRXArblB1c1VORlIvTlkv?=
 =?utf-8?B?YlRjZWZtYzhYRU01bUx6dVg0OHhNVWxrSzRuTnpmeWNUU05ibHhTS2FMV3Fp?=
 =?utf-8?B?QlB4U2c5eGYySXdZYTgxWkFPdWFqZTVEaG4vRHcvSHZWQjlGWnNQVkZGV1A4?=
 =?utf-8?B?YWJlMCtFVzFPdTVhRGpreDJwU3VyYzZuMlY2ZzBWSitDZEc1bmpOeS8yQU1R?=
 =?utf-8?B?WUtQNmZ6eDY5b0hjbHJqNTVJUmZRNENrMmNnMEdaT254Um1DOWJiZXJyS2hS?=
 =?utf-8?B?ZTVNQTBZc3pwdnByTGFDZWdaM1lLanhUdko0MU1pYWRYaGh3LzI4S0s0Z2FK?=
 =?utf-8?B?Wis3L1dCZDEvRyt5SmcyMjY0VHh0c0xFZ2VDS1VyQWNESUlsQXNqcVA5THB4?=
 =?utf-8?B?dFJBa1RtVkEzdXFoVW5CNnVoM3lxR0ROYy9uUXpoc3F3bTF5dC96ZGF5N0NU?=
 =?utf-8?B?eFpoQU1VOVdmdmhmd2tBa0VEOVFodGRHN2lHS3Z2WC9rRWJkUVlUK1NPUkVM?=
 =?utf-8?B?NjFKbmUwd1RxS3Q5eXkySnlLM09LR1NYRUl3OG1Yb05pbkJZU0kyNnhCd1F0?=
 =?utf-8?B?VWdOdkM1aU9PTU9MSldGVlBkcjhxN20weDZRUDEyR1JnYkxJMXVqRDVJUTY2?=
 =?utf-8?B?bDZhSkxmNUJPNUVyekg1TzExY0pib3YwY1pCUG5LS0NMQktveUkrSkZxamJi?=
 =?utf-8?B?RHFsanpHVnlvRzBTTmZNL1hkdWNzTEhrbDhLL1BmVGdnVkplV1lXSDY5L2t3?=
 =?utf-8?B?ZnJjUFMrNU5wbGpHUGJsbGZhVWRRck12V3o4SmY2bUIzdWJ4b1N5a0tveURI?=
 =?utf-8?B?T29NTlZsQlQxeDVjTEthMmVwZENISDNxTnIwRExwWVIxaEVxOTh3VkFWZlN1?=
 =?utf-8?B?K0U5SitJNndibW16RlZpU0g4TnNvTlpyeVFlSzVPcmlZZDJnZHZFbXp1TEto?=
 =?utf-8?B?WnJOTUY4NWhlM3hRWlY3SE5rck5KZTVBeVBDNTVnL09jdFhMRGNtZ1NqaUdI?=
 =?utf-8?Q?JW5Y7Ftfx7Ahw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3ordjhDUkd0NU9WeXV1Z0FYcURueHFYTmpSUXc4MlcwckhlUGh1RHlNQlVH?=
 =?utf-8?B?L1JEcHlOSVJDSEZqK3QxOWtJRFphbERTbzlaSDlKYzk3bTRWdy9NaTdMaStw?=
 =?utf-8?B?WnpwNXd5ekVPRm55ZUpheGtGaExmUGhtenhod0V0SVR5UlkvSnkrSXhOVllF?=
 =?utf-8?B?ekdHcDhsS1hUVWFWTHp6UnQ5N095a1BuRUxaTitCZEF3WXk0TTVzWEo4TElO?=
 =?utf-8?B?dlp3SG9lT25mUDl4cER5T0g0b2k3cXFhd0xnMXlvWEQ0QUNzT1JPeGRXa2xq?=
 =?utf-8?B?ZGtwMWtndmNROHFCRUtaQkorbG52aUcvb2hxK3lzVGZWS3NRdTh6Q1IwQXF3?=
 =?utf-8?B?d1pobUZIRy83Z282UUlhZnIzcFdWZVptdnhXYmxYTFlCdDY2b3JVY2JRK3NZ?=
 =?utf-8?B?U3lFaXBzTkNONldQNGtOaUxocVhQOWMxOUIzZnVjank0MG9NSHhTWTZwNU5w?=
 =?utf-8?B?VXJpSGdyT2g2K3BJMjRSVDJFL2Y5STRobUNDdzlrNkl0NnVRT2JzdUlWWXlh?=
 =?utf-8?B?OVR4R1dMOHE2cXpuWXI4MGNGcHRjejZNY1ZpYllUUDljTTgrTWFleHZmUXM4?=
 =?utf-8?B?WmpQNGlNQm5mUVVGeDczcFhLNEVnVVltNXF3YmdJZlhQWEJWSHBwd3lnRnlJ?=
 =?utf-8?B?ajJQSGdOL0FnZENPU3hnbE5ITUFoRUJ6OFNMSUM3SnVQaEVoaTVNZjYvSTNr?=
 =?utf-8?B?YXl4TEREZ0ZqUTNxUVZCN0dGZ2hpSTdLQ3h1a1FFaXkyWUQ5YnA0OFdqSVY0?=
 =?utf-8?B?RktJWEl1NElEYUM4Q0RVMC9LM0Z6YnBxUDg3R0RUVjhhaytuRE5FN1V0eENY?=
 =?utf-8?B?VW5Qa3pMcEozdWUrWlA0Q051eE5KYTROc1BpdUpPL2l5cWJIV2NhNWVIbGRa?=
 =?utf-8?B?ZE1paFFqdmRVdjEyYStqOUlRc0JtQ28rRlFPTDNtMWVtOUNkU29oNVVKRmdX?=
 =?utf-8?B?VGdXRVc1RDJTQVlBUnFrdnFVYmp4dU9ubEJUNHBtU25aS0xOOHdnakhwLzFU?=
 =?utf-8?B?c2hWdmxNdVhwSEowTVBLekpJc00rL1hRMTl2cjloMVFkd0N5S2FMN1JaenZQ?=
 =?utf-8?B?cVhVOTNsa3JlYUg5Q2dCR21FNWZiMjVDZ3l4eDZ2R1FrRTZTeWlnbHZ6N1BT?=
 =?utf-8?B?UWNubjZONWJxRlplZmNFc3pvU0lzZUxuQ3pOa1RWcE1YejVhR2g0TGoxUCs2?=
 =?utf-8?B?NExydXNyN091U1hZamFhYWVwUU9aOVE2M3c1UDB0OHVxbnB0R2FlNUFYMUs4?=
 =?utf-8?B?TlBDZGpleEp2TmJrcGFTUWhBTkdhRmRIR1BITGxZMVZ0cGRHLzQ1a2NKdjd4?=
 =?utf-8?B?TzNJNUxmVGMwbDUyR2lmRFAxd3ZtSitjZGw5cTdIVFFUNE00Y1pwUUlrRmZ0?=
 =?utf-8?B?dDFNUk03TGZxYzVqQ0N3NjlObGtVUjNuSGNrNjVtS2MrdXRHbzFtM3hUNURX?=
 =?utf-8?B?Z2pTdkVDQkZRQWo0em5sK1ZVSWlyT3Nhb0p6eC9UY0E0RGx2Qmp0UlVGa04v?=
 =?utf-8?B?NjZRK0FyODM5TnoxNFJHNEZRYWk1MHA0R1RkNWtDNkl4MHZKc09HMllqbGJV?=
 =?utf-8?B?Z1NkY2V3eFBPTXZBVGIvL2o0M3VRWjZIY2h2WVdWK3gyN2xDQkxxaC9neWpY?=
 =?utf-8?B?a09ieEkzTHlIeEVzdWRPUDZQaDhhTUM4Tk95TzRLRTlyYkU5TjNDKys2S2lx?=
 =?utf-8?B?V1hKeHQza29BbitqSmIvRXZlcm5IK2c5dEFDTG9HVDZjTkxKRzhtZWZxUG9H?=
 =?utf-8?B?dmI1Z0NZbXZWVEdRT2lTd0M3VE1sS3VYUkVmeTVwRDQyQ1pzUm12QVRZMS9p?=
 =?utf-8?B?ZlE2ancyOWJaZmtxa2wwUEVTM0h3dCtvTHZERlhwbXdYckVxWjdFb1lTUWZw?=
 =?utf-8?B?d3NjSFZabTd3NkZjMzdkVmoyT2gwVndNanlvT08xZHNDK2VlYUlUcVdTOFVp?=
 =?utf-8?B?bk1nd1lUcDJ6NFJjZEhHM3dRT3ZnTjBzL3BIMTZXdVlOcCsvVDJxWUVQNmF5?=
 =?utf-8?B?K1J1dkhMd0tYN2RoaEVMZDBUdUFkWFNkSFRyMUFtbCtLeHNKRjhEZ05XRXJa?=
 =?utf-8?B?SWU5WnhzSHd1OTBhT1JVOXVETnp0QXdkQ29SSjEzNCt0RlZGNGJ0Z0F5V1RT?=
 =?utf-8?Q?1FGrmreF++Pwv/Ws0WxnVcdR7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8100d90e-3e72-4ac5-bc19-08dd4a68204e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 06:48:43.9008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96XkB4FWMZwM0gr7MwJxeAP3ScCj8MPpxdsYuqEBcKlBhF39QkUd9EksWD4G60MsPtgV8dAUj2ct8SoDQXSmqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com

On 2025/2/4 13:00, Nicolin Chen wrote:
> There are new attach/detach/replace helpers in device.c taking care of both
> the attach_handle and the fault specific routines for iopf_enable/disable()
> and auto response.
> 
> Clean up these redundant functions in the fault.c file.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommufd/iommufd_private.h |   8 --
>   drivers/iommu/iommufd/fault.c           | 120 ------------------------
>   2 files changed, 128 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>


-- 
Regards,
Yi Liu
