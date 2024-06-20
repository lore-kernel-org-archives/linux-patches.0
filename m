Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3483584D12
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919175; cv=fail; b=B+H7aAH7ZBTsTIcZbo/nY43gd/fr9iC7oI84F2CuySQ5ph/XtRPDDdTzxOQj4B6bJcyhAbPcQy+TnpDwNMwu35/RbPwNLUNb2pIDMmtMi0ykcqBf2GCFnxA4dCxQr/4CLwsNa7psG03cPmZdqpRzViCi4bGH1ii38RPXdx2xGPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919175; c=relaxed/simple;
	bh=h2ueC0qjwOMZedlTo8E5AM3vHOCBH5iD/EAthhqHae4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HxXm3P1BsH7fgADnWf8xgsaT/idARXVXqXBEefNFKxwxzjJcihqNU6ofmti5h4WHZJSmYwwE+3Yx8S7qRrFHgRQ0CkGou2nmq/4L7++ukiwOfCpMaWJbdys9E9RB4YeLGC/ra4RX+OnTxquLMman2Lw/mz75Sft7rYHbZBVFu6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k3d8u2Mj; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k3d8u2Mj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919174; x=1750455174;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h2ueC0qjwOMZedlTo8E5AM3vHOCBH5iD/EAthhqHae4=;
  b=k3d8u2MjQGltKBS7Klk3N9+2FST/tpUw1ACL3P3QTAkOZfnE9K6hyRza
   A6cseTcbabfxR+y8STsdU2P9M/JRZ91tV5aeQK4baihTqihqyx5dHwgRG
   yT/fGM2oQnlZ5cUR4vMAfsP8bLpY3+w05OoCbDqaHJakeXXRntij3kzzi
   Dx2AywlpnN/xuMaS4Vi0E+O3NuS9KCW0Pdt/g0oJjNYzPnYKvXjr+AFY8
   9212XnjTVQMb2107hJvDAyDczF5mMIVucLuy4R1O6t306XDZjRjS+jvGm
   hiLhs7Yr2Xh/DI+U978k0yT3ZDJ6ASwZBtdyBLTJ/dPdQPC3DVPVJv9J+
   A==;
X-CSE-ConnectionGUID: nYFn/PH1QUS9j/4T95cGnA==
X-CSE-MsgGUID: 8a3QoTfPQ8SkjIb43qUxsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16163943"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16163943"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:32:53 -0700
X-CSE-ConnectionGUID: HkPdPlwhQ0aRpRLktHkGWg==
X-CSE-MsgGUID: cPGf53TcSfCFCGuRlD9SPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="65625402"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:32:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:32:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:32:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:32:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m53e4R4/XyNGg1t3FjHN+5kBqdTjEnO5+pVOYSFMzdBErx9tkDLfbA2rl1TtnvN0671Ezg+NuIV44PGiFCvsl+scr8rkd0m/Wf8iCI9lfHNpozTLTe0tQH0+F82EZsLrbz0KFRLjye4e3mtXHPQnfpayZk/Kxgygu7VIdFgbkB/kZipRnlU16dQ3mSXCqD9ZeAW0vh1MFlI+An424EyveRWSD7gT2yHKWzZfWFRxBmcPEDkHFnjz+8VdPPrvphQ4dg6G8RdiALpzUBZnKh5BO16OnzIK26SyfHiSDU3BoH+8OSUf/Vi5hxo4aHxl/pZ57ewgvFvjWdGeZ+fcjThc3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dp1lw1c7MOYvh55TseQvCzua8N08L8PNlPlMCZoUak=;
 b=Yvca9JZJTa4q/LqI7I2nT81LovlIEGWtRTVk25qvRgI6SQTRdAiqCWOuYlA/gN9o9x/0VRq88V6lQ5JE815IFbwYtW1aUpQNG10l6BCZBytxn/U6gk1Z20Qa5NxHemLlfZtmU9tuwUY5rJfpRc8aG8FwqSAdzIRbFU3llyX7jGVq5VMeHA90HT+tbs/YWw1g64CxtgNMhnaqS7PE4j2PthRFPHYvn92V4bXKCgUrwTWAZlWouYiI4b22dXW9nIE/Ey92GS1v8FLZJasIhd0Ie8+1eskwHStO6H2aCGX4AQqbKD/T/RvCc6kvvBUxF3M7VQfTuUSS0l2dRD+Z9g5kwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 21:32:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:32:51 +0000
Message-ID: <2a08ae2c-746a-4242-b216-f8e8d18dc229@intel.com>
Date: Thu, 20 Jun 2024 14:32:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 16/18] x86/resctrl: Enable RMID shared RMID mode on
 Sub-NUMA Cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:303:2a::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eb49d6b-857e-4a80-2d6e-08dc9170897f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V0F2S0Y2cldqRWFJZm1HTmF0U0FVYmNCR0gxOVRmODlTMlFOQmhIbFVObUZB?=
 =?utf-8?B?Q2pLanNvUktUdHJRL0ZFdmJYQ1NENnRlZ0dMUzhWZk1Vcmtya0R5dk1BbkIx?=
 =?utf-8?B?MVFIWTZOQk9heXpJYkRUODltdDFaVldtT0N4UHJrT3NUd0ZPOFk4T0NTOThR?=
 =?utf-8?B?THM4YzlTamxQNThsOU94Z3JVNkNoZ1dSOE9BenA4TjB1bk96VGFwV3pKdUVn?=
 =?utf-8?B?Z1NZWUIrbTh2L3YvM3NLSGsvVEU0R3J1ZzVHS0lqTXFyWFRHTCthSjZ3SlRn?=
 =?utf-8?B?VUJCTlVlaEhscWlHT043QlFZU3pmODNJMzRzMC9jWlYyNkM0eVpzN09WMk1K?=
 =?utf-8?B?OHhDTEY5UVU1MzBVQ0xqM2MvNTU0dG83V2g1d1hDVWZoR1FpM2REb0hZOXRm?=
 =?utf-8?B?Y21nU2tDQTU1M0ZMVTc3Q1pieURkdGJhSlZocnRoanA4endJVitxcTR3akVE?=
 =?utf-8?B?dThsL1R6bkxHWWtsTnNuYkEyTktaenFjelZJMFlGTk9Hc0c0b3lEQy9zV3pW?=
 =?utf-8?B?V2ZiZzdRUUlWTzRqSjBDeklzdEFWU0JQbUc5L0hVSDRDL1hTSDF0VVpIbGdX?=
 =?utf-8?B?K3Vadk1CMEVnc1MvaWhYNERpemZuV3l6d0VrNWVaTFIrQkd6TWNFQkFWem9W?=
 =?utf-8?B?WFhLajJNZ1p0Q2x1RFc3dkVETjJuQ3cyQTFtT2ZkQk1JVURNSTFFYzl1clMv?=
 =?utf-8?B?WVpTd2x0RmZWVStVcG5MZGFrUU9OOXhYRkFmOVB3SzRTWGs2cFVGMGVzc200?=
 =?utf-8?B?Rnd3OC9zeUNFK1RjeUd2RFFDWmZrOG82ZExYZEFCbHhXRWNjcE1sZ2pYVjJH?=
 =?utf-8?B?QnJrdkZvQXg4Sk1uMGxMR2tLNWRYSUpUcVFMSXdmTHlRMlNrZVRrZm9rWDhw?=
 =?utf-8?B?dUNIYkVRM09wamMwRDR0Q1VkV1lLLzY1OXJFZVVTekdXTDFiUkhqZldQeW5H?=
 =?utf-8?B?S3dLZElVVDFmUzdzMVh2N2hmaEtHZnlaZ0RycXBQa2p6bnBOdGpCY2gyWXM0?=
 =?utf-8?B?aUwrbHN0WjFDem1ZSkxqTHJWNjZjQTBZOVN3R3kwZlMyUjFDUTUwREkyNkFQ?=
 =?utf-8?B?eUZIS09VSGc1aUNicGpXZXdXVWtkOFhGS1F2L0tBeXc1Wll1aVNXWGhUcXR6?=
 =?utf-8?B?a2RuaWhZdjI3aFV2MWFQQVNMSm9Nd3NyanN4bDhDbG9RMUxOclZ1UTdYUUV3?=
 =?utf-8?B?MW56SlI4M05FaE13MlBDOWVsbUdiei9iRGJCSHRvRk1LSnYrTzdTelhuSTUz?=
 =?utf-8?B?Rm04QlR0TzkzNU9CN3RqdUtiRkczSnJrT0dyZmZPTkdEdndpSGx6VEgreWZY?=
 =?utf-8?B?aTNXay9qNUFMV0J6NUVrL0ZnSkdqQjFkdGpCSDlrZjBrMlIxT3doR25mbzlH?=
 =?utf-8?B?TmhJTW1mYi9WWU9YQ3FCT2VwdmhXWHIrejZtUk0wUi9HeHNpUVVyNHFROHp2?=
 =?utf-8?B?RGVJUjgvSWVTa1hsRzZxMUl2c2dZbmVQSFMvNVU4Y2kvTy95UVdCQTZ3WUpn?=
 =?utf-8?B?N3BxRHRMMWJ1L0ZGTzhQL3ZnY3JBTWdBV0lGRStDRnVSeUExdm4rUVJzS3N1?=
 =?utf-8?B?a3JrbWNPQkg5WFk0RnlpS0lNTTh5NVd3Y2QwL2V5WE5oQTB6ZkhvczllTWFw?=
 =?utf-8?B?aXpPVTBCaTE1SUNTYkQ4eHUvOHgySkg2b2NPdnZRNStzZDZQYmNUSTNSN3B0?=
 =?utf-8?B?QkZwaFc3QXRnNm1zdkVweTR3cE9ndkFxRDRiL2ZkNEtqOVFWYnQ1czZSZkg1?=
 =?utf-8?Q?keaetO9mINZzpSlf6d1dGBYgitNj5H9K5p5Idzh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXppVG14a1k0c0RYWFpsWWUyK2YveEQ0V1JEd2t6cnY2bkNGQ3NsNzdvNnF5?=
 =?utf-8?B?akFMZHlwQmRxMllqY2N0QWZPQXIvclNLNGxOMjJFdTFqSE83czA4eDJOSVAy?=
 =?utf-8?B?MzhrVFVVZ1VQZ1paK3FKUmI0SWt2N1hheCtZOXRVR1UzWElIUUV4Q1dtSGY1?=
 =?utf-8?B?SW10YjErRWt4ZzZJV0RmT0tmc2dOdWN6SUFQVC9IWFVxSmt4OHhxQTBVNFVQ?=
 =?utf-8?B?YS9wYWFrYk5IaEJQVmQwcXBPVFNONDRTV1c4N1I4QTNOYlowanVCdWthWXY3?=
 =?utf-8?B?Z3daNWt5TGsvYTA3REs3U0toM0s2TWhITkYrWHVXaWlmbWpkMFpNSVY3VWdH?=
 =?utf-8?B?K0ZOaVliaWVMT2F3d05FRmpXVnhKNXJMbkh2aS95Wndudml3NkVoelI3L2Yw?=
 =?utf-8?B?NkMzaHRNaGJHVzQyYjRYWDBtbVZxZTBRcTE5dGVtUnBNdXFJMmlYdmhiMGNY?=
 =?utf-8?B?ekFxNTBrdVVybEE3enpTT25SUUQxSGt5L0RrZXlBc2Uzd3EwcjBmVWpuaXQy?=
 =?utf-8?B?MzdTTXY0SFJGaTlpYVpRSmVTSzVVSVN5OGJVdmtmbGZYRlBzeDFaNmM0Qmdu?=
 =?utf-8?B?OXhCMURQL0JQVmNVVDFCS0lObC9xTzF1L3kvN3ZiODVhK05BZE52T3R1cUFj?=
 =?utf-8?B?V0pTUzA0VDRHcXFRK3V6TjFOTi9TRjgvQWVoV0NQNUhSUENOYUV4VFl2dUtz?=
 =?utf-8?B?YTlDVVRoVUl2ZGNTV1cvTFpqYzQxNFg3eDhwVmpSaWtBdm9JVHdFbmdMMUN2?=
 =?utf-8?B?UUY5cXNGdjNwbEo3RkRPVGttSSsranZ0SnllK1RvMk55cDhBR1N5WWlpM1dK?=
 =?utf-8?B?b01UenVHczE5dU1RbDN2dVFNdG9kQ1hVWE1qZnVmUTlGT2ErZVFzVExBdVYz?=
 =?utf-8?B?MENUcDRnTWlNVUNWd0FJVFlIZDFjb245U0w2a0xhZWdaZXdoUDRUREkvRHVC?=
 =?utf-8?B?ZUFKcEg0SUtxelVESWZGL2RpMjRkTGhXbkhRdFZJbXlydUF0T1NXQnRvbGdF?=
 =?utf-8?B?cHdUQ0kwb1FlY3U5bzlrVUFmR2dlVWU0TUVYcVZSc2JVYTlBc2liS1g0eDR3?=
 =?utf-8?B?V3lKRVBkUlk3R212cGE5N1M4amQ2SWpMUE8vQWhaSjFqazJzM205WTNzVFZ4?=
 =?utf-8?B?QWhqbmdtdnZFLzVXdklHeGFVaU16MEhhZGx3bXptaUdvRU5IMlZha2NZc2ZY?=
 =?utf-8?B?MDkveU4vV2V1RjZYTU5iY0pzVXlKZDQ4YXRubmZ5MjI4ckVUSVgyZkZYN3Nl?=
 =?utf-8?B?NUsvZWZkSld5b2hKTGZLVkdGaHJPSDEzUjRxWkZzbXhJTEFSb3lFR3ZMMXcw?=
 =?utf-8?B?NDZZWlczNFJqQjJic0MzU0IwMEcrdzhaSjRiQjNseG96K05KSnZkd0dNZzMx?=
 =?utf-8?B?UHRKdE81MlJiem1wN2lQcVlNcUZ6QjNwZFhMVEJWbldqUEFabStXMkdPU1pm?=
 =?utf-8?B?TnNadUZEUE4rdm96djRyYllINFBaUzF3RkRmMGtnRkx5dVpua21Ubm1XT280?=
 =?utf-8?B?OW94cG9sUEVicEdFYTV1dXZiVDZXd0wvMFliS2lKTCtsNWhBa2k4TFgwOTJD?=
 =?utf-8?B?b1lncXkyVkc2VDBVYncxeEYrZVJTNFRDZUpMYkdHa3lTYU5mcDJZNFR0UHd0?=
 =?utf-8?B?bUFra1ErbTQ4c2tLZW9zVEcrM3JHY0hKME4wQVZLTW91b1dtdW8yOWVSaGsx?=
 =?utf-8?B?NkJ1am1SVEVKTWZKT3B2YlBnZFFKZGwwc1hKRE8wb05kTzVzdDRsRDZEejVz?=
 =?utf-8?B?YmVxaCtGYVJobmVmZitCYTR4S0RoVlY3NCsrU3dQQmxmVFppTEdjb2tJNVdk?=
 =?utf-8?B?MWkrbGJabFlVOEVwbXprUThGU0FiUVlLVTJXdFVNclNOVThJZ2xiVGNFNVJ6?=
 =?utf-8?B?UFplOUdPSEJnOTlJb0MxcVpQbk16UFphNklLaFZ3UGVCdUd1ZlFleEZPNlRG?=
 =?utf-8?B?S2tka3pqaFc3QVZ1OWhBMUZXeFBJV2FKUDR3bDM4UDlRU2UveFE0UkNCeG9B?=
 =?utf-8?B?SW04U2ZKekFvSGtBMyswQzVtVTdDeE9KUFZUNUVKdHljZWdva25PbU9vdDBl?=
 =?utf-8?B?WWJSN3JQdkNwSURpcjFJWlBmenU3dFF5VEVvRlhrMGM2cVBZTHJ0d01Vc1Fp?=
 =?utf-8?B?aXRQMGd4QnU3YytFM0k0SUVEY1NhcXh4L0t6S2dtTTlmbUFWenNyTGVDN1Z0?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb49d6b-857e-4a80-2d6e-08dc9170897f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:32:51.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1tyv7aU9xk0gmrzt5IRVVUlbYFyrZ/M8L5BVd84Ngv8gpi7EZmmWksCz1wtp5hon2XQBdHNuhLL3A4v7YIbJUgH3B6qPMBnUEIt5gqatRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com

Hi Tony,

shortlog: "RMID shared RMID mode" -> "RMID shared mode" or "shared RMID mode"?

On 6/10/24 11:35 AM, Tony Luck wrote:
> Hardware has two RMID configuration options for SNC systems. The default
> mode divides RMID counters between SNC nodes. E.g. with 200 RMIDs and
> two SNC nodes per L3 cache RMIDs 0..99 are used on node 0, and 100..199
> on node 1. This isn't very compatible with Linux resctrl usage. On this

Could we head off potential tangents with "This isn't very compatible"
changed to "This isn't compatible"?

> example system a process using RMID 5 would only update monitor counters
> while running on SNC node 0.
> 
> The other mode is "RMID Sharing Mode". This is enabled by clearing bit
> 0 of the RMID_SNC_CONFIG (0xCA0) model specific register. In this mode
> the number of logical RMIDs is the number of physical RMIDs (from CPUID
> leaf 0xF) divided by the number of SNC nodes per L3 cache instance. A
> process can use the same RMID across different SNC nodes.
> 
> See the "Intel Resource Director Technology Architecture Specification"
> for additional details.
> 
> When SNC is enabled, update the MSR when a monitor domain is marked
> online. Tehcnically this is overkill. It only needs to be done once

Tehcnically -> Technically

> per L3 cache instance rather than per SNC domain. But there is no harm
> in doing it more than once, and this is not in a critical path.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/include/asm/msr-index.h       |  1 +
>   arch/x86/kernel/cpu/resctrl/internal.h |  2 ++
>   arch/x86/kernel/cpu/resctrl/core.c     |  2 ++
>   arch/x86/kernel/cpu/resctrl/monitor.c  | 26 ++++++++++++++++++++++++++
>   4 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index e022e6eb766c..3cb8dd6311c3 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1164,6 +1164,7 @@
>   #define MSR_IA32_QM_CTR			0xc8e
>   #define MSR_IA32_PQR_ASSOC		0xc8f
>   #define MSR_IA32_L3_CBM_BASE		0xc90
> +#define MSR_RMID_SNC_CONFIG		0xca0
>   #define MSR_IA32_L2_CBM_BASE		0xd10
>   #define MSR_IA32_MBA_THRTL_BASE		0xd50
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 75bb1afc4842..324cf05858f5 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -529,6 +529,8 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>   
>   int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
>   
> +void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
> +
>   /*
>    * To return the common struct rdt_resource, which is contained in struct
>    * rdt_hw_resource, walk the resctrl member of struct rdt_hw_resource.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 95ef8fe3cb50..1930fce9dfe9 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -615,6 +615,8 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>   	}
>   	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
>   
> +	arch_mon_domain_online(r, d);
> +
>   	if (arch_domain_mbm_alloc(r->num_rmid, hw_dom)) {
>   		mon_domain_free(hw_dom);
>   		return;
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index c4d9a8df8d2d..efbb84c00d79 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -1082,6 +1082,32 @@ static void l3_mon_evt_init(struct rdt_resource *r)
>   		list_add_tail(&mbm_local_event.list, &r->evt_list);
>   }
>   
> +/*
> + * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
> + * which indicates that RMIDs are configured in legacy mode.
> + * This mode is incompatible with Linux resctrl semantics
> + * as RMIDs are partitioned between SNC nodes, which requires
> + * a user to know which RMID is allocated to a task.
> + * Clearing bit 0 reconfigures the RMID counters for use

"Clearing bit 0 configures RMID sharing mode for use ..."? It is
strange to me that this whole comment has no mention of
"RMID sharing mode" that seems to be goal of this change.

> + * in Sub-NUMA Cluster mode. This mode is better for Linux.
> + * The RMID space is divided between all SNC nodes with the
> + * RMIDs renumbered to start from zero in each node when
> + * counting operations from tasks. Code to read the counters
> + * must adjust RMID counter numbers based on SNC node. See
> + * logical_rmid_to_physical_rmid() for code that does this.
> + */
> +void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
> +{
> +	u64 val;
> +
> +	if (snc_nodes_per_l3_cache == 1)
> +		return;
> +
> +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
> +	val &= ~BIT_ULL(0);
> +	wrmsrl(MSR_RMID_SNC_CONFIG, val);
> +}
> +
>   int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   {
>   	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;

Patch looks good to me.

Reinette
