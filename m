Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C733DA5A6
	for <patches@lists.linux.dev>; Mon, 16 Mar 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773685104; cv=fail; b=c6m6Xm8IlERIRqFvjCRtvxavJIUgaalIjkBtXKUtFXI79sSguUFEcdE2FPwmkyo399WsjTTP+j6zqgZIma2y5UhRSEMXOIv059GlhWoCBimeFiEalv5sDowWHKYXUelXt2wEf05LxvEh5Dy+o9e1MwjNQkQ0uw1N55g764o2Aog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773685104; c=relaxed/simple;
	bh=42Chc2YpQhaJlvDxTVpxDrCmUxE8t5PH+YmIsgdKZH4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XD11ZdYtuR92vAxpDg9T7NkfPFJD7N/ObXfVVxWPhce3Cr7CepJTCx9WIXjN6O0i+wbouiqVdjvCJyoM3Sz5uYKRhaVQ7dPa80TYDrsbrcM730yGkjA/7PWrTMdOnmVbf52UzXI3eUbsMEVxwcclOH2JrwyiScXMicSEV+phc/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pg++PDRQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pg++PDRQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773685102; x=1805221102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=42Chc2YpQhaJlvDxTVpxDrCmUxE8t5PH+YmIsgdKZH4=;
  b=Pg++PDRQGAtBKC23nMzrWoCsVStPQIP8A70HrSJoSbnhDV3Q9vSc9BLI
   aWr6aBNgHikWuF217worn8abVVMvW22Zd2wUl5aUB7h8L3FSaRitSO/1n
   rEummAMv04xEzbBNSFJAC4bAHTl9dBijchXvn1zX7WK+vu8MxdKHFvjpG
   y0Tj3WHPNuDMrb6PTeVTXl1+ZVLUed/cnN/R03FILx9WzKgPZAvEoWtlR
   uT7cUon5LPj8wb+/teO5DRxst0FeutSSi+W4g1aQp2cck30qRNlkNg9cP
   M4vXWiAAYDWKj9TEMRTI7E3L5iHbQLEssbF2i01m/oa4JUssyeHe9GxCj
   Q==;
X-CSE-ConnectionGUID: aKTdIawXRgSMHW1mwENzfw==
X-CSE-MsgGUID: h5ocyYXeSfqvEuqpdKlU4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="86188928"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="86188928"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 11:18:21 -0700
X-CSE-ConnectionGUID: UcUAcDwlQs6Mlh9NMARGAw==
X-CSE-MsgGUID: l0lGtlA/TMuEIsqUrJspDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="226133676"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 11:18:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 11:18:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 16 Mar 2026 11:18:20 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.7) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 11:18:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtnMN6+X0GrufYd8sGSUljI+6E14SaGBqJsyLYDA9NpynCzVFOr98J+ibwqSZP+BWMLc2674pmcjN1iqr7UQDBtOCJki0Jq26KWDsxnTZL8F6OKhz/3ZENOtuDwknX3+895amL9XxxGC+zIBRjpC3UHyetSBWN/3wKR2gi0gCoJ84379UEAgiUF4lQarVi0whif2lSdWGOIhVAe/V/Jl2B8O/7EDMrp+RlPgSvTYI6gTsaZz36TGEuPrBi1ThCs1bTAcwvOwrbygq9vVVwtVji/qyHWOVNROpWm1Me34Eu9RKmWtamKEPn7+JSUXqwjVy+Cx2yNMkXmyrnQxZmgnPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKCsj9SlWxMKtv1Y3FpYJDMEVGq8D+yXwKP08AwdEFk=;
 b=mnaTXxk+v02ejuAy5Kohy2dBvY+pehR0KuH1IlelTs9OhXqxhLzm+TVJErE67qvs1fDhZwEuk6letprFlZVoL4hxoXCS/9JboPzcT8cBbeaf/ek+YSCBVAv8aEJTBBN6wbm7swCn0haH/oCQapYFnihXywBj74jN2td8FvEwBNry4cCPYqT6USAK4u6fRH28C4EHKoIbH4iVJlkdkloB0oqQI1OqjyCY4FnvnKoZmCHiJBWj+aEFVNZS3tIp0VZJ5HIjZbassr/t41yt8Bvp9szApvmZoVpNMmRmecfStQZYCiNNJm/k7WjipJs3P1zx6mkiPieJbCMcYIuMQDNWHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by CH3PR11MB7251.namprd11.prod.outlook.com (2603:10b6:610:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Mon, 16 Mar
 2026 18:18:17 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%5]) with mapi id 15.20.9723.014; Mon, 16 Mar 2026
 18:18:17 +0000
Message-ID: <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
Date: Mon, 16 Mar 2026 11:18:13 -0700
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
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::25) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|CH3PR11MB7251:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d3e9f4-c0ef-4bd9-5ca5-08de83886507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: cTubBcyp2RjMMq40M9csr6tEymqFZZmRP68ZF9fDrqLhzKFTDdT7iPAOSzUCrkFf6CZrh9kMqiMf/EdRxSH/QK6qnqPLVTH8gwyCyRBWJOioL95gISW9/FdSKid7sMVGKY0qHl4skJY17iTCVlQT8dMmksbWTumJxz69s/MZdhY1Zt/LPb1pGBOFhG9fSuUowJOzZNBHTUfYnQoMGC6K3lhd63D6/M6/vv97CuWKXQjigmuaNDEsuUF+AWmyIYaVZs610Z0kKPVXqCcJVBphPvRnWNhKFpd973V3PskOZ1FKtrU7XfcDN4x9tnMl+jn02VWQBhSdQZYpI/1V2bpKe78EgtNKeEy5J2Uo5FV3m/KxdpcaQga7RDfQSf/1xxF6i6L9ZHlbntRAytCv4HSBP2H6p3eZr2k5Ar+Z/V3wzY0MuJ2+q7EAbN36A6pAVhyvuKGa2DNXP6gjcHxWtHPp5k485I17MGqGEvgVqKYNcX+A8INK5dmJM4R2FjQ+zzJe7WNMTWAKazBGM6CvtdqxlIF6EBs1/+fmGxPytrXDDQY391tcCiasBvy1bL0H5AgPHudWfosm/Pg5QrXkBmLMo2ZIX+B9/SOninYbVDuG2vPpr/o9K3/cXLH6cedCOYHPlFGSvYhosplet/EViwQUNuAsUvHraSZq99ukYtNEeLth6+sTJUAtfdpkfXqnxBHNTDv1e36bzVoBCXRy05P0iOpZMW3XhCxryXVFQtlcDKc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTFmdCttZ3BaUUZtbGFTbWdiK1JIVHdZc3FqUC9ncjMrQkpzOFBMRTRsRXlp?=
 =?utf-8?B?ampWV2RqU2RNcXpveE16VTBDWWRNVUZnVWozVmRYUDJuUCs5enJ0c1g1UjNJ?=
 =?utf-8?B?SEtlSWxORlhHTXlBVlIrSVlndWdXU3o3eFMzUU8zbTk1TVNOMkppV3p2bUZi?=
 =?utf-8?B?aG5EMDBCbnlvK0RwL21La2RLejZiSGRCTkRyUXNjS0xaSklYSFNndXBySEFJ?=
 =?utf-8?B?bUM4ZWYwQXBiTlkxNmRpMEg4cDhnS0xLcGlnNTdjN1hRc2d3d2htdDViU0lJ?=
 =?utf-8?B?S3pkdjdaTkRiaWs0US9FNG5wZ3IreUs1REpBR0JjcDNzTlFTZE9BSit3QTFa?=
 =?utf-8?B?YW9xMVJYaDV0OVZYbWZvcjRScW5JREFMVEZZYVI0QkEwVi9NNUhkRlhmNGls?=
 =?utf-8?B?RW9GOW5oVkxyYWVSRGZVSTNKb2hROURjZDh6UzgrYythaFozai9oR1dPalBV?=
 =?utf-8?B?dkRvZ0hhVjR1OVRUcXZ6eHhBdTFrNCtvT2JFSGtWbFUvWUhWd29BSy9EUGdu?=
 =?utf-8?B?U2NpdjVKWVV2WmNnMnZpdHpNZWZsZW41QzVBUS9OTGxrVFlqallNSSttVVp0?=
 =?utf-8?B?ME5xMDArU3BvZEdYOWcvT3pvMVh2VVpvTldOQTNxR3pmV3cySXk3Rm9vMjV5?=
 =?utf-8?B?ZEFVcERESjJBWnFhSTd0cy96VytlVWtGRlNhYmtJOTdDMzZFTUgrb3N3TzF0?=
 =?utf-8?B?OHZGSGtVYTdWN0lZMWNsTDdYOUhSMm1aRHhpUW1iQjB0WGxiSGlscGcvZlc0?=
 =?utf-8?B?clZ1bElIUllLeCtmcHBzV09BUlJwUnhXNitZV0w1dkVvOTA2R2Zjdk1oekh5?=
 =?utf-8?B?VmIvZDhoWnE5dkRNWC9xU2Q4L2hSbEpOQVV5VVFEb3hPOVo0cTQ4N3VWdFN1?=
 =?utf-8?B?K28ySjdGZDNOalMyQk00OEVEL2RXZWlicnNoNTIyZFl3Zm04dXFBbFVaNDRh?=
 =?utf-8?B?VVExNmNzRHllb0xJM2praElkbzlud2FHeS8yLzdRK21jUDJrVjlaN3c5RlVa?=
 =?utf-8?B?b1Zjbnpkam5nZ2RjZ2YyM1BmODg4M2wyL0laTnVoQ2t1N3hvWkZpNWRYd2Qr?=
 =?utf-8?B?cmFmc0lrbFZIQWcyaDYxam9Oc1owYTI4WXRCUUhPSTh3Tm5EbXNpb3VtdnpD?=
 =?utf-8?B?dWhqZGhIVm9RRWVTYnRXSEFkTGo2OVZyTmhhQVluSk5MUTJGNVBITXh5UkV6?=
 =?utf-8?B?UVVqWCt1VkFxektFdHhreXBvV29DVjJTUzUveGZEYjBVK3BYOCtPZ1I1TU1F?=
 =?utf-8?B?VWRleVlyRUEvWDUzeWdOSDB2MExQOGRJSm5DdWdGWkg2RWNyT1Q1Uk1Zb29E?=
 =?utf-8?B?S2E1eHVqVDEwRE9ycHkrRGhUd1BsdjRaRDd3dkFKWVluUXZJNHI3aFVxb2lG?=
 =?utf-8?B?TFFGYUZLTERtOHRNaVlBaHRVSFdhYlBLQldtWVY1aCt2WHJ4Z3ZvTmlaMGl1?=
 =?utf-8?B?NFVjODBlS0lRMEhPQlFNTXlUNmpONnRIMzk4SmRwNVBhQklaN3M4SklIR0Nu?=
 =?utf-8?B?ZzB2ZDJORHRxRGZ4NGxUcTVPcm1XK2g0RUJ4UGpCWVkwamlrdDJIOGFpR2Nk?=
 =?utf-8?B?bVdIZjZCTUVINmNuMCtRd3ZPRU1tVkZiZDlwYmFzQzRRVGhrTnM2UmVBKzVq?=
 =?utf-8?B?TFUyOTVSbHJaVmNTcHdXZy9sTUhqaHNueGY4L2psUzVqdjhrQStOMS9QeVZQ?=
 =?utf-8?B?MExCUTFuYytqT0pYbVBlbWhraXZvZFltZ2c5UzVEaGZoSFAvTEMvL0tLc1hs?=
 =?utf-8?B?bWpqNWx1ek5JQkVwalNPbEJNZjBvQWNQTWNiWERNdjhVOE5may9aY2RKWVdZ?=
 =?utf-8?B?WVhrWUhJeG10bjhLVWlkYlRNRjBmem1UT2xKWG5uUk96cmVaMlRtRWR2L2M5?=
 =?utf-8?B?YXI1c09scWtYMUpiOFcyWTFoR1JpTWFpQWNkU2R3Z3U2djRrdk44WGVwQWFD?=
 =?utf-8?B?UmIvUFlsbUdKYmFyZStIVnVvOVkrUmhleWtVc1kyRFlPbEgyN1VYandrMmVv?=
 =?utf-8?B?YVZSV0d2SXFmZ3RZbWpydG9icE9tUDZvL0ZzRjZkQTFYb25GTHJ0Z0xVdW4y?=
 =?utf-8?B?WWxFUG91ek4rUHd6NWxNLzhrVWJoZW8xekh2NG1aMTNNQ2VHWXZDY3A0V3ha?=
 =?utf-8?B?RFhtRkpPdGFmK29kRXEwMWNaTVY3V1ZoWElMZXJrNTFPUUVueUV0MmhmWmxE?=
 =?utf-8?B?OHdRZFZTbVl4cDJROHJvR2RoSFhURTVIN1NyeE90ay9HekVsanpBUFFyU3NZ?=
 =?utf-8?B?VGFEbWlNbS8yLzFFdTl4R05LcDNNdTRaWGl2dkVVcThxRUp2VTVUbUhyZXdB?=
 =?utf-8?B?VkwxdjdaNEMyQmhFZ283cXRzczRKSWUvS0tvemtHUVJySFN6T3VrazVpaCtr?=
 =?utf-8?Q?r6ayl2Hde11N6CN4=3D?=
X-Exchange-RoutingPolicyChecked: Wc0nflEDrTaczYW+b/p6yJokRI+vyff9+LaheketZrshXWPPII82VTfB4mxWEdVOb2L/20Ts6p+OjYXQaAS+DwYRQ+LznpvdJUeZRSHLn+K6OCBnox+7QRfQQSVHG8fJbSLm0Cy+g9EX6osVnn7K1WmAVd+7qMsG/vhrDV58Zg/ZHGDImYphSJZ/rOIWtK6zwUr7xnNBbpghauF+zgoZcJXRBVVOEfQmXWOprBvo5XhYEs8ViQSB7vOKxfiGb9pWBYejbxvyzu4q6Y1GWq/B2K7S/bu/LElVSqO63hIgV3+UH/mGCHNmTTuWRInjpvD+BnyEngwU0DVOVRj74gzp2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d3e9f4-c0ef-4bd9-5ca5-08de83886507
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 18:18:17.1046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlcLmUbys9MsmrPlgxTRjUgzypGT14WhwMzidtVokZ59ZcvXkY5b3bQDtWTsWlM+RApW3Pa5BHRtk43VpCLVso0gJsWy1z0BjvtVQJrLSFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7251
X-OriginatorOrg: intel.com

Hi Ben,

On 3/16/26 10:44 AM, Ben Horgan wrote:
> On 3/2/26 18:46, Reinette Chatre wrote:
...
> One related issue I've just noticed is that when ABMC and mbm_assign_on_mkdir are
> enabled the creation of MON/CTRL_MON directories may succeed but an error message
> is written to last_cmd_status. E.g.
> 
> /sys/fs/resctrl# mkdir mon_groups/new5
> /sys/fs/resctrl# cat info/last_cmd_status
> Failed to allocate counter for mbm_total_bytes in domain 2
> 
> The failure is ignored, as expected, in rdt_assign_cntrs() but the last_cmd_status
> is never cleared. I think this could be fixed by:
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 62edb464410a..396f17ed72c6 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -1260,6 +1260,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>         if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>                 rdtgroup_assign_cntr_event(NULL, rdtgrp,
>                                            &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
> +
> +       rdt_last_cmd_clear();
>  }
> 
> Is this right thing to do? Let me know if you want a proper patch.

Letting group be created without any counters assigned while writing the error
to last_cmd_status is the intended behavior. If the last_cmd_status buffer is cleared
at this point then user space will never have the opportunity to see the message that
contains the details.

It did not seem appropriate to let resource group creation fail when no counters
are available. I see that the documentation is not clear on this. What do you think
of an update to documentation instead? Would something like below help clarify behavior?

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index ba609f8d4de5..20dc58d281cf 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -478,6 +478,12 @@ with the following files:
 	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
 	  0
 
+	Automatic counter assignment is done with best effort. If auto assignment
+	is enabled but there are not enough available counters then monitor group
+	creation could succeed while one or more events belonging to the group may
+	not have a counter assigned. Consult last_cmd_status for details during
+	such scenario.
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy

Reinette



