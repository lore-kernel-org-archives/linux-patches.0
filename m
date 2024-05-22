Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D35E7BAF7
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716413215; cv=fail; b=Y2/yv9mfIT1U3Suu/+z+W1FBbSHe72HRFUssxE00WT1rY/2tBPx/QICcWhN4D50+3dGGsFmWsTs4Z0dinwH0yFcobSjdmimWe1mM/9EAzPYKWPr6t6O8rN2JPZCe+Ja1cs36MbBPSA1g79wd4bvdz25ca71sLsrNRVXfdrrgX7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716413215; c=relaxed/simple;
	bh=USzzBP/XK8BP9qJ4r004nTunWpbvZIF5b7fLxU6JHPY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HMEKxXM/M3DIEAeSpuNEE9uRxJkE+geuxeA6p8CfmT3yD0Oawwzz3U+BrICWXtnnoXpPe3FY+lLsVqrH3adRK6jdR92o5Tq2WT5Stof2vJImtAqUvjVoFzdbrDEr404QtTmbrbmGI99FwAOuuEmIuXItRhQ7MsP6Z2xbyTlPcXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hXsWmHf2; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXsWmHf2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716413215; x=1747949215;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=USzzBP/XK8BP9qJ4r004nTunWpbvZIF5b7fLxU6JHPY=;
  b=hXsWmHf2SxsGGqpF5UZRT9IaSwkRkin8KtftaYqWB3mvYGvwNIpDNmbb
   RvI8H77GAcqOv9r+BJzG08LW8wIE4wT4HZutvTX7wPu+ORn/Cw0RNmXid
   BnPQWEJukXr4D8byD0I1asS9Gk6df9Vpp8CaOu1cBSOf3SaWw/HkUwipM
   pPG8PxzW4es1M4knWF7VZkd+RyZx0M+69LH/OUZKoDD5Hcw3sJ3owLqVf
   xgQ1BNutK7t93yEqrciMT+d0Kq5ZtYp+j+qR7vJCuJf6gzMUiYMl+0pkb
   DcVvwBS1tTDqBNMFQth0cNpBgfJmmprpVt1bQJG1bKBMZ3fKeFbfNv5TR
   Q==;
X-CSE-ConnectionGUID: g8FWiYiFS2OhzK5tAIBGTQ==
X-CSE-MsgGUID: 3P5yDNR6S3aORNPDX1HKsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="35206867"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="35206867"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:26:54 -0700
X-CSE-ConnectionGUID: ZlYPtXOvTqWnM2WxXJmUZA==
X-CSE-MsgGUID: Iz/GGAgfRz+odIA9UDKkfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="70826167"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:26:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:26:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:26:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:26:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:26:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLsghXOektaX+5gXowB0/eBGyBrekHWCSTz0PwAbwmVvoxnef41xuUebL09/lGfosSkcoDeEs6xRr/hO5KXcn4LPjEyUUiQ541SRzLGojTS+hEPJd/TEw2mS9dIWdA9YHS4h8jG/xD9M4BITkv6TKWEXsqRdF6WdJURQGk7EgoZr2RgCfZpoQcL819Uc/yfPx0ph/LGGEWYZGUPSE49CZg7m9PwPDyhIufcBQKmWVK8zEMC+wNy7HqI92LuYnziNqmu0IJqK5gkSbWEQBzXeE0dPzdUlnN8MNp6273+iplWOtLcS1uBg/buQL6OLRggGZ8wYhBZZdkO+JqmDVFSVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIx0cB3w1897AMWxS2lvBERw5ctCce5hqIf87ifqHpo=;
 b=i2ozneJ7XtxznVZafEvhHw+kBqo48cwdCisaLySY4HFq1pi3Br2la5fMrnBa7UYN2atEhaG52/McZLRXQhOt1uk/x19wZtKlD1iO8ITsIAEgP2p6pEyPNW7RTF6KabVGRz6+bV/Gl/D0TsEac+sY1wSj55NNJN3T6se5kdT9yyARhxJ4ft2eBKjmy4PDDNIn79RziXIE1BC9jWtx6+2bCxmHYPUXLT8TJC1cz1koHtEUz9ynfIZQA1cYkkUig8IYz2k2eaEeBwZFlxbhs/Qn76Jw4udoxYMYwscKtzdCbdCnumS+yBZuxKEt1Mh8YOsx5crmqIDuM0Y3/wk3mHFA9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB7422.namprd11.prod.outlook.com (2603:10b6:510:285::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 21:26:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:26:50 +0000
Message-ID: <e7ccc2f0-c2aa-4814-a2be-5a5a90542073@intel.com>
Date: Wed, 22 May 2024 14:26:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 16/17] x86/resctrl: Sub NUMA Cluster detection and
 enable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-17-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:303:b4::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: ec56cb61-3c30-478a-a753-08dc7aa5e4cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aDhaY0IwMzFYMGYxSnBYQ1BBZlpObTRkcFl4bEJkYm1Nck9MclkrMUhGdzlq?=
 =?utf-8?B?eWZuMTlLTm1xOUVvMUxFc3FJczQxdFMzWnFjLzRNbmQvNjJqZjFRRTFGUkNv?=
 =?utf-8?B?N2gvS0luOWR5TUordUtlbnlvN2t3WkhhZHZ2YXdyMkdvZ3g3cU9UL2hDNFZU?=
 =?utf-8?B?aW4zMGlTSDJqS1ZDK2lBV0kyTlh0cDZ0ZmFmMnYzZUM5M01uaFRyZlZueVdu?=
 =?utf-8?B?Ni9weVpKaTVjTUNsUjgwMVJRRHdYdkV0VjBIclQyOFd1UHFENDZXbmhWL3Jy?=
 =?utf-8?B?NWRMVHZWODZaZ3I4UFpObXpmdkFOWlhNZWQ5bzNmemU4TGYvV0VXbm5nalA3?=
 =?utf-8?B?Sk41NCtucE12VDYwazdaUWJobXZacXY4MnVmSXI0QWV6YmhkL0RVQ3EvY2Ra?=
 =?utf-8?B?M3kzek14T2dsRFkybkwvWjdhZVhRam1nN3A0cUt3RGp2NTRBUVVMTzBIa1Ju?=
 =?utf-8?B?M2Z6NVZnbkNZdThqcUFtWUptazVxTGlzcmZaaEI1YVVZRmxyRzBLS3lBdnFI?=
 =?utf-8?B?V2loc3pKQnp4b0JXVzFMQ3dWY2xHdGtZQkhGTGdCTG9QdjA3Q25qaFpVU0tW?=
 =?utf-8?B?ckdJTFZZVVRQZ0QyUHF4am5BQzJTMzZUUkRTY1IrQWxTc0hIRG9lSEpSWVlP?=
 =?utf-8?B?U0dFbE41T2ZjamtqVVNxYUxFdHRGK0VIajZ1UnFWeHNQNVNtOC9LcEdnUmp4?=
 =?utf-8?B?eUI0UElMbzVCRTlod0lZZXNIbTNKaVg1WEozV1cxNS9wRGdxWmp1b0JrL0Vt?=
 =?utf-8?B?ckJrMmlFY2t1M2EzNjdVYlFaRWYzRzFBTUo2eUxkOHU3cVFrSHZ5cC9jYzM1?=
 =?utf-8?B?SEdTWVpRRW4vVnZmV3VPY2JRMHBURXQwc0tqYmU2cUI3b3VQOHd5aks0cGpQ?=
 =?utf-8?B?bVVtSGdadVdPOFYyMERhL2M0dXZabUNWVm0yTWo2cGc2UVRlOUhuVGNoWXRC?=
 =?utf-8?B?MzZBUnRobHo0KzkrK3RlQ0FjQkNiZE05NmlXM05hSHJiWklUbG5wSkxMZ2Fj?=
 =?utf-8?B?ZW5kRU8vdmxQOGJ4eVlhMTBOOVdzdFRZUGU2ZzNySmVYUlUvVURRdHE3TE00?=
 =?utf-8?B?R3EvcEZPQWUyZEtwQklrazFyOWllcnhBZi9WcXNEbnJoSTZDbVpFK3VGclNF?=
 =?utf-8?B?STVnZWlUSjEybG5KWlN2SEZmcS9KeXFoa1orVVVQOXlkWUtsV2VQanMxa3pi?=
 =?utf-8?B?eURnRWdFK2NZei9YM1VNZnJta1RwaDNCT201SG9CYWZhSy9BaDQyb3kwaUdO?=
 =?utf-8?B?MnFIVWdCNFQ0WEIyc1VhSFZQOWZ0ZFNvT1NMVkR6WDlGWVg5ME5OUmQ3eTNz?=
 =?utf-8?B?NWx5SEw0bUhzMmlscHVuc0l2MzVMY3VjMnF2TUt5ZktQMkgwdVZzazBxOEl2?=
 =?utf-8?B?dE85MnpMdUFvWW5PWk9GS3FWbTF0bGpkRkh5dVRNRS8zSVR3QXp1VDhDS3R2?=
 =?utf-8?B?SXNoNkpmSXdWM2t0bXc5RVBEOXBrT0VCMnhYNlZMRU9LZlU2VFNCMUpxUDdx?=
 =?utf-8?B?UHcwTXF5c3l2SkMxS3ZPaGNGTjc5R2RYVXBpaldwWXBjVTlnMXNRb0hIL2RL?=
 =?utf-8?B?TjZ6VFlSNzRZdHVUVGtFTGZyN0EzcXFYN1N3RXpObUkxOXZtRkM2eTZsTXM4?=
 =?utf-8?B?TTl1ZWJ3dkkwNEFia2NYbmVNRTB2T3VmekRqZGVMemFlc2hnWTlPN1dUdE5h?=
 =?utf-8?B?UTF4cmFLakpTRGdyZGFEWHBNTVlwSTNlOXdSRENOL1lSS2YvTDQvenBRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2xYSUJ6Q1hwQTFmSXg4Q1lYR0dqdzRjMXVrS25Ha01lMEVkMlRkVllDemRh?=
 =?utf-8?B?TGt0NUFvcWx3L0pDVGlJNFYzR1NuREg2blcvUXR0akFJazJuK2F0QUp0c3Bu?=
 =?utf-8?B?WUlPOTZJQzJITmNmZmxsMFZMV3BZbHR3SFlZSVdkLzdPTjg1aEtxcmhHR3cw?=
 =?utf-8?B?OXhQWERXRmtVR2p0cHg2U0NOMGV6NmE3a29jeVVOT0gwOWlieVNkYUdQR3c5?=
 =?utf-8?B?Sk5TcUJ6WjBDZmxUSmRyazlEMWJlV0hoeHBadnNnZVRqVDJCdml4T3Ztc2Fk?=
 =?utf-8?B?OEk0SkovaE8xakJqa3ZHQlBHNkd3bHVXVU1TaFZYRHlBKzU5dVdWMDRrVlNu?=
 =?utf-8?B?YU5jN04zTm8vRzBJMGRZVkpqbDdXaDY1bzZDNSt4NkcxdWRFbWE1TVluLzJi?=
 =?utf-8?B?UDhvSEJaR1g5K3pEbjR0eTQwdmJDTWxZZjlqbzBNSm5qU0FEU3V5V0w1ZC9y?=
 =?utf-8?B?aVd1anZZMHUxNC95TXlRNXBnSHB4VmpYUlJHU1hMbWVtdDk3bnBGMzZVaEh5?=
 =?utf-8?B?cGJhTkJuVlJIcm9SVGhBRXlUM29EU2VnZ1JmM1dWZnhEeTI2c2VwV0hNTGUz?=
 =?utf-8?B?Z2dTN2M5dlJxV1pNMEwwdUUxSWFabWVsZDZtZE15azl3Mks0N2hmOGo2ZTEv?=
 =?utf-8?B?UmQ1ZFpsSCsxbjg5OFlGSDN1QlVUaW5kL2hJNEZsYWhWVFBtTytzVGRYMyt2?=
 =?utf-8?B?SGNDTzI0aDFCUTQwdFQzN29WSkNPU2ZOTlV1Q1ZPbDREcDRFY3NaeVdkQitD?=
 =?utf-8?B?bnUyZk1xWTloaXN5K3VwWk9WRlR3MTRnQmp3dlQ4NFFsMFI0Y1Flb05PVlhP?=
 =?utf-8?B?QXFPeEVxTUdJZDB6cXpyWGU0dzVoV3E0WVFyOXlVbjloclJJMTJGTkVFVmZz?=
 =?utf-8?B?UTlaMWJsbG5aV0NlaW10c25GczIrV0k4dmVNa0xXWHc0M2g3OGlBcjB0V0tl?=
 =?utf-8?B?ZkZqVkVsaUwvd3doMnZlbE8yZWxYQ0Y0cGlXRTl4RDhkTG5zYmRpY3cwUWFj?=
 =?utf-8?B?OGgxck83WmpKQkFOSFJGL1lLT0VyR2d6V2IzZjRwdEtOOUlpSkkweCtSRVh4?=
 =?utf-8?B?aCtuZVd3QlEzUWZGVTcrdFNSTlV4Y3JFS3pKMEd3bVQ3bm5kUEtwTE9aRFRr?=
 =?utf-8?B?SWp1KzFSdjdBR3NORXRGOSsvdUlXVndHdE5oQjcxL2d0UTNKSHR5UTYycGh6?=
 =?utf-8?B?TnpzcUdTT1lGK2FpOTMyenNKd25halNGSmVna2xyamJxcU9LTUxzcHpHRm5v?=
 =?utf-8?B?NEV3WFN2NTdXWjc2bm5YM1F5aFJlRmhsdjZzdkdqK0lFRGZSazVtOXRaSEtH?=
 =?utf-8?B?a1UxNVoxeWFCZUc2cjRmMVpzRFUyeVV6dXd1V2l5c25tS0tNRlBVZEM2WEkz?=
 =?utf-8?B?aUxMcTVoRWx4cWNKOXVBdGxaYVZFMERyTmkybndoUTNqL3NsYzZLcU5uandT?=
 =?utf-8?B?YUVibENOUkc4Snl3WGRYNklBbWRJK2tiN0dGSmtETkE5WEtvRGtDS3o1aVpx?=
 =?utf-8?B?VFZqdjVsK1RZNWZhNDd6ZmQxclBwWG9ONzJpd0tOUm5acTlQWm52WjhpdkdE?=
 =?utf-8?B?TUkvUXVjY2hBN2EzM0kySThnVWlwYjVOZjJ1SEphOTlCN01JT2tGemNvN0Vr?=
 =?utf-8?B?ZWtWL2t5VHNEcktKOWtFdEJoeTBwMUlYNTZnbFg5d09jSkdQMzdpMzUza2M1?=
 =?utf-8?B?WWhJU0txcXg5Q2VkMjR4MjVjRDRDeEhzc3ZmUDE4V3lOV1lsRjNRb1pzWTNJ?=
 =?utf-8?B?M1pPa2lqSTR2UUh3bndoQ2VYdHlGNzQzaCtXWHJpRitFaU1rWElYWWdaMkpV?=
 =?utf-8?B?NnN2R2tVenMyVkhIVXB5UDE3YVFVMnpQTURtVTVlYnpvZ3o5ZHNIMzkwdFRL?=
 =?utf-8?B?clFtYkJ1ZS9pdWFoU2hVTm9vTDNCZzI3MHZHS3ZwdS9pRUxFRVRJM3g0OTVk?=
 =?utf-8?B?Nk1CczlpQ3Z3R0xtVlRWUVc3aVBxYWZDUU5ZbjFGTmJKZkVrRkJTS05tRXZY?=
 =?utf-8?B?S1lhcDdQeTVKdzAwQlZ0UjN3bVg5dGZVcTlVRUpXd1JLN3NjKy9KdWl5R2Jj?=
 =?utf-8?B?enp4TlVDanVxeWoyZGZhdzRZVG9UUXpJRDZJdWtrWHFneFRWUS81ZDMyWXdw?=
 =?utf-8?B?WkNHRC9mRjBrM1FEUVVoMGZhTm16VGZsRGVxdkY0NnFXOXlROEZhMkRMK1FM?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec56cb61-3c30-478a-a753-08dc7aa5e4cb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:26:50.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0yPjOoyRfF7/qpLVgGuACA6O5zj9iPkS/XNjW+hoccK3J1KfUtqok/Uhl/UYRt4WW+Md5IiqHXsQX4DdDCkoUpkAHLpypS652su2XAr4PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7422
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> There isn't a simple hardware bit that indicates whether a CPU is
> running in Sub NUMA Cluster (SNC) mode. Infer the state by comparing

Sometimes it is "Sub-NUMA Cluster" and sometimes it is "Sub NUMA Cluster".

> number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
> the same NUMA node as CPU0.
> 
> When SNC mode is detected, reconfigure the RMID counters by updating
> the MSR_RMID_SNC_CONFIG MSR on each socket as CPUs are seen.
> 
> Clearing bit zero of the MSR divides the RMIDs and renumbers the ones
> on the second SNC node to start from zero.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h   |   1 +
>  arch/x86/kernel/cpu/resctrl/core.c | 104 +++++++++++++++++++++++++++++
>  2 files changed, 105 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index e022e6eb766c..3cb8dd6311c3 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1164,6 +1164,7 @@
>  #define MSR_IA32_QM_CTR			0xc8e
>  #define MSR_IA32_PQR_ASSOC		0xc8f
>  #define MSR_IA32_L3_CBM_BASE		0xc90
> +#define MSR_RMID_SNC_CONFIG		0xca0
>  #define MSR_IA32_L2_CBM_BASE		0xd10
>  #define MSR_IA32_MBA_THRTL_BASE		0xd50
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index dd40c998df72..195f9e29c553 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -21,6 +21,7 @@
>  #include <linux/err.h>
>  #include <linux/cacheinfo.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/mod_devicetable.h>
>  
>  #include <asm/cpu_device_id.h>
>  #include <asm/resctrl.h>
> @@ -753,11 +754,42 @@ static void clear_closid_rmid(int cpu)
>  	      RESCTRL_RESERVED_CLOSID);
>  }
>  
> +/*
> + * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
> + * which indicates that RMIDs are configured in legacy mode.
> + * This mode is incompatible with Linux resctrl semantics
> + * as RMIDs are partitioned between SNC nodes, which requires
> + * a user to know which RMID is allocated to a task.
> + * Clearing bit 0 reconfigures the RMID counters for use
> + * in Sub NUMA Cluster mode. This mode is better for Linux.
> + * The RMID space is divided between all SNC nodes with the
> + * RMIDs renumbered to start from zero in each node when
> + * couning operations from tasks. Code to read the counters

couning -> counting

> + * must adjust RMID counter numbers based on SNC node. See
> + * __rmid_read() for code that does this.
> + */
> +static void snc_remap_rmids(int cpu)
> +{
> +	u64 val;
> +
> +	/* Only need to enable once per package. */
> +	if (cpumask_first(topology_core_cpumask(cpu)) != cpu)
> +		return;
> +
> +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
> +	val &= ~BIT_ULL(0);
> +	wrmsrl(MSR_RMID_SNC_CONFIG, val);
> +}
> +
>  static int resctrl_arch_online_cpu(unsigned int cpu)
>  {
>  	struct rdt_resource *r;
>  
>  	mutex_lock(&domain_list_lock);
> +
> +	if (snc_nodes_per_l3_cache > 1)
> +		snc_remap_rmids(cpu);
> +
>  	for_each_capable_rdt_resource(r)
>  		domain_add_cpu(cpu, r);
>  	mutex_unlock(&domain_list_lock);
> @@ -997,11 +1029,83 @@ static __init bool get_rdt_resources(void)
>  	return (rdt_mon_capable || rdt_alloc_capable);
>  }
>  
> +/* CPU models that support MSR_RMID_SNC_CONFIG */
> +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
> +	X86_MATCH_VFM(INTEL_ICELAKE_X, 0),
> +	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X, 0),
> +	{}
> +};
> +
> +/*
> + * There isn't a simple hardware bit that indicates whether a CPU is running
> + * in Sub NUMA Cluster (SNC) mode. Infer the state by comparing the
> + * number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
> + * the same NUMA node as CPU0.
> + * It is not possible to accurately determine SNC state if the system is
> + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
> + * to L3 caches. It will be OK if system is booted with hyperthreading
> + * disabled (since this doesn't affect the ratio).
> + */
> +static __init int snc_get_config(void)
> +{
> +	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(0);
> +	const cpumask_t	*node0_cpumask;
> +	cpumask_t *l3_cpumask = NULL;
> +	int i, ret;
> +
> +	if (!x86_match_cpu(snc_cpu_ids))
> +		return 1;
> +
> +	cpus_read_lock();
> +	if (num_online_cpus() != num_present_cpus())
> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> +	cpus_read_unlock();
> +
> +	for (i = 0; i < ci->num_leaves; i++) {
> +		if (ci->info_list[i].level == 3) {
> +			if (ci->info_list[i].attributes & CACHE_ID) {
> +				l3_cpumask = &ci->info_list[i].shared_cpu_map;
> +				break;
> +			}
> +		}
> +	}
> +	if (!l3_cpumask) {
> +		pr_info("can't get CPU0 L3 mask\n");

Sentence can start with upper case

> +		return 1;
> +	}
> +
> +	node0_cpumask = cpumask_of_node(cpu_to_node(0));
> +
> +	ret = bitmap_weight(cpumask_bits(l3_cpumask), nr_cpu_ids) /
> +	       bitmap_weight(cpumask_bits(node0_cpumask), nr_cpu_ids);
> +

Can cpumask_weight() be used?

> +	/* sanity check: Only valid results are 1, 2, 3, 4 */
> +	switch (ret) {
> +	case 1:
> +		break;
> +	case 2 ... 4:
> +		pr_info("Sub-NUMA cluster detected with %d nodes per L3 cache\n", ret);
> +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_NODE;
> +		break;
> +	default:
> +		pr_warn("Ignore improbable SNC node count %d\n", ret);
> +		ret = 1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  static __init void rdt_init_res_defs_intel(void)
>  {
>  	struct rdt_hw_resource *hw_res;
>  	struct rdt_resource *r;
>  
> +	snc_nodes_per_l3_cache = snc_get_config();
> +
>  	for_each_rdt_resource(r) {
>  		hw_res = resctrl_to_arch_res(r);
>  

Reinette
