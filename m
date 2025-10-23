Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B2433C52C
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241855; cv=fail; b=V0l9YW2FAUkXShO5nK/6FbNVg7CVhvsI/41NRla+b1a/vcRPALV84SwWmnTSANOf/1axXSiVN8c5PdA+fBdjzxGzk4ubdmHin8ArJhLSMOyCw4NQ3ZeRUsWGaLFqRh73j9UE8P3kzBKLk65ZamfOHldU108/G1cgZkFjmZgaaiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241855; c=relaxed/simple;
	bh=1Uo7C99OwUAdSZe0MwO8/Ib++1/S8iRZOaA8uRbWB0k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QKhmSu+HMdDdXOgK0qYVyvHK/5u3CPTxDp8nrOjxDW+hHdrAxWUHrVY4Fe0KE6y9FT3TJRkpao/vQGj639j2LvyxGkJZxWrZ8kcYS7yeWmWB+WXLBJP/m7LgujujSWvrLigx/tzZNS+BLYbmC3zYWoBV2TnRt/dGQt4/Qhj/K7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cO8wOmtW; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cO8wOmtW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241853; x=1792777853;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Uo7C99OwUAdSZe0MwO8/Ib++1/S8iRZOaA8uRbWB0k=;
  b=cO8wOmtWPmBBQo+h0f31XZ3dLad/msqQbxVccOkuCu/MtP2+I88RK6Sw
   yGvircCU2YroOzKRKDpkTMv2Yh1PB6hP/cTelnDyvAzxNzhXn/8GZ25S3
   2hXr7D6/ymuupMedBOpeoRc2QSS0FTC7UowSWJe0IeOamFmSbrik3qm5t
   3QqIa4rVl8JCbbVyEi6rNQA4SSqU41QVXjqNM0UffkzXqgRMyI+dVFNpD
   bY1brEK430BsnuenR3OuZo2kh42l4MqeZ8+/49n5J3txvpv44qlimnmb0
   u4v1Ur0G0z2gs5AQ/HXU70L21wmz6ZpefFqprR7VumGHb2tUfqCzHrb6p
   w==;
X-CSE-ConnectionGUID: J1dhZ/bUS5iwvCpfjQizJA==
X-CSE-MsgGUID: pCyeBMOvRna9u5Jjut4SJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66036306"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="66036306"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:53 -0700
X-CSE-ConnectionGUID: QSWBIhsAS+mPAWRphcSPAQ==
X-CSE-MsgGUID: CgVhOiJ8QRq5i7EvKB2c1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="188513602"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:53 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:50:51 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:50:51 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.6) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:50:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBeFRa+GZ9lY/0nf2B+cIFS31UJIjZCzHl1K13ThBgICQVgVKgt+++NvbsbhYNSPuQfWaqaLWTaMXXVvrslurQ7hswxctquKNGpT3l4/D5wrzMJ1B0ukN2Vz4gBcixuvdwvwMTGR/ORCi0B7k9g3V9nxw91f+5WbkRyQeo1VGcvBFG/aCuszE+x8LzGoZLLC9nqQqVsNXMM0DqHbm81xnEAiI1ehUx+1fUufh6K5s1/BOPQG3FWetCUd/6hgGlEgJgw44IhuwNXI4NUhceQy7W+drD57/U1ZzsOgctf7aVZpxh2WHTlyMvFFi1ecGcqkJLU0sJCMuxHf0PmRAK0Arg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKrSNXXCv7Jxbi1aG0KbHPJOuPPntoVTtl19Ejq8bnk=;
 b=yRclC8F4ke5U+gGeaCmsSztVS49SrS7BjD9xbxSODTc8XfRLGrHC6Wj0c/NRymTCzZgqv0FNQkmqFxBNPtR00MoOW/FGSV+pCf1GrzurpXc4T8RgIsrRLpcxfjMpQBwYa7FAxKvMCMRTGN3TBbNL6GRFgK97N9XiZP6zn8MnOcjzmA9+zY/iKwqEgrB2AhVAzRV+GH6gLxe8BSd8C7jBwyL2hXlcctE82K4LwJwot4xyhZQUtFjixq+PmwoJaYF2vDAcCc+1dc0DNacCUrTtK7TRMtGPg6Wu4oEYiWY+WB8h+BQ4Ef6a6O0IUmWueLX4cI+ycmAM1Go26646lQ5gPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8469.namprd11.prod.outlook.com (2603:10b6:a03:57b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:50:48 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:50:48 +0000
Message-ID: <caddeea9-78e2-47ae-8e55-3446ec423526@intel.com>
Date: Thu, 23 Oct 2025 10:50:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 30/31] x86/resctrl: Add debugfs files to show
 telemetry aggregator status
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-31-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-31-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0243.namprd03.prod.outlook.com
 (2603:10b6:303:b4::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d6fb71-cbcd-4d53-2bc6-08de125cb342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3UrNnlvRWVRcnNHS0dKb1pkZklkR3gwNDljQ1c3aGp4YzNvTEQ2amJ5YkRr?=
 =?utf-8?B?NzhsZFRqUWpjRCttSndUd3hyVTQrSXlaWEtIcEZhdkRaOExlQWxNSHRwMEhy?=
 =?utf-8?B?NmRsT2p2NnlKcXJ6b0Z1N0c2VVQ2UzVaZlVEdUVBamZ3NUg1UERFVHdyYUFO?=
 =?utf-8?B?NW5YN3YwWFVVUnVNNWMvRGxab2J0YUdrZ1liOVZhcHppRkNnZHlFWlpxZ2NL?=
 =?utf-8?B?SytXL3pSM0NLaGh6Z090OGo1TUtEVEZrdE9uRDYvblR6cjR2eFNqbkNiYUFW?=
 =?utf-8?B?ODdyd051WEFtbmRyZVVXWHlGMUluTTBPd1FVWDNWdW9LeE1aTEsya2pwNlM2?=
 =?utf-8?B?dmRkOG1vSTkxWTRZODB1bXQwdE9tN1RSZEhMd1BIcTl2Ri8xeWRkMlJWU2g4?=
 =?utf-8?B?VHZueHRTL0hCODJoRjRWUWd5Mm1mS0RlZzN1N3NDNCtUTGNGV2hoME95RFNa?=
 =?utf-8?B?ckJlaVFKWVI2L01CdEVzVEJyelpjMmJ6ZjRyRFpIYVJwN04wbDg5TGVyT2ZD?=
 =?utf-8?B?bDNORGJGUGJmSWYweWhJbW1sdXQ1NFZZZnlHTnd4NXI2cytORjQybGtBa01y?=
 =?utf-8?B?T2hmSUhYTk8zb0dyTHNPR21JRERwNlpYY0ljKzQ5VlhrWHEzMS9GRitlRDZV?=
 =?utf-8?B?b2JxN1Q1WWYySjkyWnhVUXZUR1RYeG5YNTQ5bEtnTU91UWNEZjkvR09naUpJ?=
 =?utf-8?B?TzhXRmFadFh5QXJvUU02MWE0K0hwL3duYUx0UndHOEZVZUFMV3FPb0x4cG1I?=
 =?utf-8?B?QXlnSzQ5Nk0xQ2FtdkJyVnI1Q3FIMmp5NDd5ckppRk5aZmdzSW9YNVUrTTU2?=
 =?utf-8?B?aWQxd3h0WmorTGU3RnBRdTJmY241Vm9OZjNNK1I3WXQvNGZUVStndHJvbURl?=
 =?utf-8?B?MUU5anBFZHVRdFlCYzlLUS9XdG1xdCtFOUJMMFFkMDlLVkg5cXB4cVRTWDZn?=
 =?utf-8?B?dE51R0RMaGIxbUY2OWNtM05COVRTak1oQ3J0ZFM0K25Vb3hwQURCYllWUk1x?=
 =?utf-8?B?T3dDeXFlbzJzSnV1UXp4NTY3OTlobXQ0MHB6c2l2ZHh2ZEhrSk9WNVRLN3lO?=
 =?utf-8?B?VFNzbkVNTm5nakM0dGJ4dEptUXpZRmF0dzRISkFDZlBVRW9LZysvOGREYWJ3?=
 =?utf-8?B?NkdqYUtPV2llcVFCRTRSMnBJMFM2dGcycUNXdXZXTUN5Q05Jb0dlUjBocWJ4?=
 =?utf-8?B?QUU2cldJcGdjNUVlNDFwc0dKUlRSaWdqQ2ZEMHlPd0s1aDYzYU9ZSzdZVitU?=
 =?utf-8?B?bzJGZDVTQ0pRU2lXTkM5M2N4YjdzZldtRkh0c3R2V1JCOVJLRnM4TlRsaHFZ?=
 =?utf-8?B?ZWJ5UXVXcmNBajdDdjQvTHRqS0NYQjNzaEdFMGRINUtBbkpTZEVUTUxPMENu?=
 =?utf-8?B?WFVRUURjRHVVcTFGbnVwNzN2clAyUGRZOFJTMmRrZFJJWW1EUDFQenVvMUVm?=
 =?utf-8?B?bXptWEVtTTd2UnVLSCtGNm9GUHdsOVc0LzdybzBsd0ZIWnZPYURiSzl2ei9i?=
 =?utf-8?B?KzNMZUp4Sy9NdG43NkNxdVZLRnYxSWo1bDZVemJuclZBRFBkRXRhVXBERzlq?=
 =?utf-8?B?cVRHeVgvY3NMaUh3TWtySWxnUVpWdEdmTmRFVmhUTDNFU2RTUXNPR0k0Qmpq?=
 =?utf-8?B?TGRqUHgvVDRuMFl2TjVxWStER2w5VytSY1R1RisvRDA1S2NiTjZiZHg2Kzkr?=
 =?utf-8?B?OTd4YkpkYWhHM0dweU9OaXZ3ODE1cmZWYi9tNFFDV1U0RDRaaDF6Z0dWamtp?=
 =?utf-8?B?WC85TGRhczlNbnFabzVNTjVEWXBzRmYvdE9WcFU0QS9tSmhxNlcrREYzYVhz?=
 =?utf-8?B?SW55RC91UTZYQkxNSUdwOXZtemlvY2Z5YVJ1MUlpd3BzYnFWU0hnd3hlY0RF?=
 =?utf-8?B?M2hCQUhmckhYeUN5aWw4M25nTGZjbmtJOWVNdjVkODRJeUU2cHNqcDFZM3Aw?=
 =?utf-8?Q?WxRBjbEA4IfjJeaWdL1vRWIV1ZHzM8Ce?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUg4QkllRTNLcm9JaU9lUUhRSmVQZXhoZ25QU1p1akRjTkQ5NkpMMGhVcEcw?=
 =?utf-8?B?UWNpc3RIWUR4WG5xbldmSEtlbzJZMTlKTUo5NUJWVkJGOVpLd21IdEhVYzJJ?=
 =?utf-8?B?NnZid1JSaTAwSnJLVURyTk10S0wxMWkzUmpSM2d3Z016WmVBNEFTVGdxeDBU?=
 =?utf-8?B?TE9vK21OL05KbzB5M0E5Sms1SkR4bVYvU0J4TEtNUTZ4Z2hMWVZOYjh1T3dG?=
 =?utf-8?B?NGRxVkl1Qm9qSUhTN0ZDdCtSSUg3SkJWUUhPcnd5bCtnTk4zV0dGSXRzUXBn?=
 =?utf-8?B?OEgxMUVMamNqOXcrQ3p3Rk1EQTJhMm1iK29UWWJvdzdGL3pnK2Ztd05QK3M5?=
 =?utf-8?B?aWVISjBCNXVvUTFXSGUwR2d3R0ZXNlo3ck5sQ2NKZUZrVjVxbTRoM295QVUx?=
 =?utf-8?B?OW5mVmN5eDVLQ3NzcjNlWlZ0UjV1WkZhMkVET2dFNDNPc1J6NVhVclNmR1JV?=
 =?utf-8?B?am8xWWMvYmJkY2NHM1A2Z0UwZ2w0SCt0d3dFTnZ1SW9LU0NvR2NpU0ZDQlRS?=
 =?utf-8?B?N3ZySTh0cWxBT3haNkNTY3laaUxnajljNktuNTZtT1AvZkZrbXlmTmZGREtC?=
 =?utf-8?B?V3FjcUdhTDZQWFp4aXVENmJjMnBVc3BkUFh4T0wxeWxQMG0xUy9lNWZnSXJw?=
 =?utf-8?B?R2gvZjlIK3FpcXFtODV5cUsyUC82b1NDQ1BHVCt1WDBNQ1I3TFhOVjNvZm9a?=
 =?utf-8?B?T0wzUnprWlF0MVIwTCtGRU5iQkZOVnppV29ESldWK1l1MzNrSjRsWk1GMy9U?=
 =?utf-8?B?MHJzQ2JFQW9MMXZDeGNQY1Y0VlJRSUVqYU0vSGFKb2hsdkJkUXNFNHh5WUpH?=
 =?utf-8?B?R2s5Z2RIR2RRWHFhUHZidUNlNVd5cFR4WDdxZkpzMU5VQitBMzhaOTgyTWts?=
 =?utf-8?B?R3hCb3lpNFBYNGR0STFETjVheWJNVE9LTkNjUThLTldGWmJvU3Jaa3NwUTRS?=
 =?utf-8?B?TUVhRVF3NFlsUi9hdU5SSlBhQUZtK1k2eGJDL1BFaEZoaFBwSnMvUzBVS0la?=
 =?utf-8?B?OEh5b3hOZ1d3Mk1taUgvWHoyRjRKQ1Q4SVM0Y0VPSjVkS0g1Y25XejNaeUlt?=
 =?utf-8?B?TnU1RzlmN0VUYmROc0R0RS9seXdLVVBySU1jOEs0S2hjU0dWVWJSM0VPNm01?=
 =?utf-8?B?NjdadnFXNHJiR2JxVTl3REV4QjJyOHZBNWo5a1VSZWtRWXB0dVA5Q0U3eVVJ?=
 =?utf-8?B?aUdFUkZIYjVvdXNYcVUrSS9WaGhNTHZ3aTJ5elRrVnpsYkdrK2E1VE5VcGxk?=
 =?utf-8?B?UHVrNExTNDhPNW1SRngycGtMSStoRk1JdlEwNFU4bWR2RWJKNE1ENUxxVnM2?=
 =?utf-8?B?NGovQUh4RDZ2KzhXSUcrV3dGMnltME9McWVZSDdnVlY0d3Y1aVpaSlBBcDhV?=
 =?utf-8?B?Rk9WQSttNitkSkt2c3lHUkJkU3ovbGh6MHdGYStUM1VKUDRvTWYrWitOd1Js?=
 =?utf-8?B?enpTemxOV0ZWSFJpSExBZW5mUkd3cUVRbFdUcHFlSW1JUXZ3a1IvWVNDUnZq?=
 =?utf-8?B?L0lPS1lYTkZ1eDRGdE1MTTRnY2RYUEk4b0Qyb3VmaHNLdnk0Z2xUQVlMempM?=
 =?utf-8?B?cFVpZENWUU5pQTlsUlo1MUkvNVNTdkxRQmJCQURzV3FWVnNiempHU05MTXBR?=
 =?utf-8?B?WnM3aGExNE5Qb2Nya245RnBNeHNaVjVGQ0h2MkJudjFVcXgxTUs1RkREeG51?=
 =?utf-8?B?cGRCVzNvbFdObkxyQk42bzJ1U0YrM29iTGEyNHp4bC9VUG1NdVFhNjNrR1Jv?=
 =?utf-8?B?RVV4V0JFYXMzRS84NTNNSWxMT0tSUE9mdHo3ZHMyQkhta05pdWJDQU5Fb20r?=
 =?utf-8?B?aGhWT3p0aFlMT0V3dW13S0NFOElJNkxqSEJPWEtYL3hkK2FvWVArcldQaUln?=
 =?utf-8?B?R1g3dHZhT2ZjTWtrVzFTZ3VBeVBFOGc0Y21BSU9pK2hHNmJiaXJ5QXNlS3U0?=
 =?utf-8?B?dkNUWVV1TXlHWVJTTzBxcnJOK0pHOU5QSmlsWno1M3dMdDhRakdEVFVRS1J2?=
 =?utf-8?B?eDBaRnlUNjFndGlYekxHdXVwd1pHMHdPMmRra0ZrYzA0MU1oSHp1eERGbEY5?=
 =?utf-8?B?Uk1VOHgyUmdmSnFzUDlKb0VFd2ZpT2hPYzVIWFFJdThNMUpFb0N6ZFFma09Z?=
 =?utf-8?B?WWlCV1pORzZqSzBTN3JZS0N4UE1uVjdScGJ3eU9CblZUVmhPcU5yb2Q0SnhJ?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d6fb71-cbcd-4d53-2bc6-08de125cb342
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:50:48.8377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hd3rhmP/uX3Bt1FVeo9Q2YZj7pVbYWvQZhL+x12NYi/pmCaImcjpf8B0xkng8Tiicz/kpbtomrlRlqumBS0BXAfNZE25/3JZRW/AtNSE6yU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8469
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Each telemetry aggregator provides three status registers at the top
> end of MMIO space after all the per-RMID per-event counters:
> 
>   data_loss_count: This counts the number of times that this aggregator
>   failed to accumulate a counter value supplied by a CPU core.
> 
>   data_loss_timestamp: This is a "timestamp" from a free running
>   25MHz uncore timer indicating when the most recent data loss occurred.
> 
>   last_update_timestamp: Another 25MHz timestamp indicating when the
>   most recent counter update was successfully applied.
> 
> Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/
> to display the value of each of these status registers for each aggregator
> in each enabled event group. The prefix for each file name describes
> the type of aggregator, which package it is located on, and an opaque
> instance number to provide a unique file name when there are multiple
> aggregators on a package.
> 
> The suffix is one of the three strings listed above. An example name is:
> 
> 	energy_pkg0_agg2_data_loss_count
> 
> These files are removed along with all other debugfs entries by the
> call to debugfs_remove_recursive() in resctrl_exit().
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

(nit: please fix that style issue reported by checkpatch.pl for
intel_aet_add_debugfs())

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

