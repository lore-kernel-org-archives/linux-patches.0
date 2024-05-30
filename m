Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C3158A3F
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100673; cv=fail; b=YotsZou3MGekfy6a7zaq/IU7z90+MG9i5Ig/sKxHxmul+7IC7X7SryKi2DKcoCC1aFHZ4vSIBsuPEGh7JqySnGpybNp1UJr7rq6DYoqNqL2ajieQh4Da+mzD1KGwRbdvvXAz2m2rpIB5nx7v5O69kE54IQCR5AyMEOIQWqIO6XE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100673; c=relaxed/simple;
	bh=W3GH777hpV4X7fUZ+mdhyb75ruZbKZS2W/WbWeXSOLk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X9mx38BMeuepXfDMD/Dd1r/QD8tdHmytseKu8YKtVNzh2lmIGXTFhPeKyMfJvH7qMyxPIcCtyrWIinGpdX6d6zmh/xSlylUPygq8ZagWQXZzJa+HlmJruVKu13wlpqS2zv3qeA+N8Le736frkiSC6s+bvXGwN3yFZdbm5VftVNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gD0xdXgc; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gD0xdXgc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100670; x=1748636670;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W3GH777hpV4X7fUZ+mdhyb75ruZbKZS2W/WbWeXSOLk=;
  b=gD0xdXgcrbHoA3JwOsmgmGrR/y8cVTFNsdWum4tlvoEosucuo+KcWOFQ
   AcJxWqTag6n3GlpogBTLke/Sedn1cPJJCcrJnYXKWwtsB5jC7D2Z+7l9a
   WDO40R3efISO8b6F1x8O44Pb0FOY4DX1POIkbAIQqvvSrCZtph5Ry6B95
   94ig2NFLn2cOe/pJcYaEP8YO2ZfzstaFQMGDfCyHEZHnAtlnWtmL2a080
   +tv4UF708tQ3yr9qaEr95HvZn0hHtMkO+0r/6SoLBgAJknFz8TaMbOjCz
   KStnhHCzDfaSZIKEwB+MQvSwr7uSNHMV3M12lxPu4oeXN1UB8AHvK8GST
   Q==;
X-CSE-ConnectionGUID: c7l2CBFkS6m2a6UOWqF83w==
X-CSE-MsgGUID: rgPBW8doQdqbzQ6TDbazQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13787484"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13787484"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:24:30 -0700
X-CSE-ConnectionGUID: Ou3bm5znTy6onDEd8RfHcw==
X-CSE-MsgGUID: llOjslvISJiMY4+mY69ORg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35975447"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:24:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:24:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:24:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:24:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:24:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4ESbo9MCgOJrLWMs6OAcLvSb0R9Nw/ZTU9XDmkqydtqzk+FDgJl/suJQWRr/d9msmTZzfv0xcDMWItOx9cpc55FwU1BtoRvXFO5BXe0j89LLoORCy+Kr8iaOCcvEnsutn/Xu6HtgiBtb3AFJDt6I9Q6rbjxhdqmvO5z3Kd2O1yQrVzlYDDpktLVFpAsjFj5lPfFxhSJz9KLqeznUWELW/LlayEToYAP1QzKBcS0xAk9KJ/TI/uPtZFaBVXPczpkZevFuYOrDWeGjio/PCOIiC6L7UpveNGxQxOELAhIPoPvu5xjgm3lloIU5rOGpuoh1yCOJWrtybixlIxq8QdQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7d2ctey5Pk9+YXZpYy8tejGmxRcsNvW5pCXTitJrCrg=;
 b=KVPcTexdkNwUbc8zvZXVOT5DiNeoRcXeNkPxIsgMBd92mpMg/lHRkYIls3Nl0L/d3Cupjq1lB8DBTimzYxUNC6jXNZAoyetjmXdqKFRVlKM7SGvWSU26Tx0dSIESSVIM9Ih8UV8ppw44McSlia2ytEto58CvnBJzzBXmQs1k7udXJmUMCd98p2THABnBFeBc3fJOiLqSplPjyGBMhDJ4uzU3K+NgRyZfehYmBnf4nGJUbOued17s8kt84hUEdfJnHq1CekBigNUs4NOXTqbUZPHd+5InjafYGVRKnBT64kPTwbJ5LujnwnpYkm+pAUTlc36PaDumibIWu5by9GEpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6772.namprd11.prod.outlook.com (2603:10b6:510:1b6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Thu, 30 May
 2024 20:24:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:24:01 +0000
Message-ID: <0e7dcfd4-a7a4-4205-b848-801540c28234@intel.com>
Date: Thu, 30 May 2024 13:23:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 14/20] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240528222006.58283-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:303:8e::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: a3dc6d7a-49e3-49e6-5c36-08dc80e67188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SmFZcHUvQkZESTJtMldjTVZ2QkNMZzlPaEsxUWVMUlFURndMcE40bmpCWTBH?=
 =?utf-8?B?cERiaS84TDA2NGRVNHBCSzZ1ZGJJUHdWbEJJak0wRi9tYy83WDhTNHQrUnp0?=
 =?utf-8?B?VTlCNENvUTJlWTkwQk85VkJ5SERIWkx0bEQ3Y0RhMVlNQm5XUTdOUFdHcFlW?=
 =?utf-8?B?emVVeUg5WER0QnFxUm45NHZQWXpuam50VERrSmkya3N5TDBGTHgyeThaUHpl?=
 =?utf-8?B?TWZITE1zT3Ayd3FFOVFEYlJrTFFmRytVc2NYZVZ1VUx4SlVvamNKMUNCUFVM?=
 =?utf-8?B?T1QxY1BtZWg4d3dhV2YrUEp1SnJ0VllxMkV2WXJmWDFUcmxmWkZ2clVHZjRQ?=
 =?utf-8?B?TmVnQXVXQTVpUUM4SndiektUV1R5RGY4Mm1DcGNFVWpEOWo3UDl1RzhKUEI3?=
 =?utf-8?B?bG9WaUE4Z2xmSEtSYmhVMHZtekFiNjNHUjFRd2J0UWptUzdDQyt5SGNGS2lE?=
 =?utf-8?B?S2dmUlQ0OWIzWk5vWUNNc3RMUTJWRmp0VFRVaHJpb0N1bDlOckNaRm9sQjIx?=
 =?utf-8?B?VWN0MDFZL1JOS1BYUkRLa2lTMTd5dDZXSkt4clJoSHJQalVSS1FNQzFhcHo4?=
 =?utf-8?B?Z1VVUElnSGc2OXpPSlc1bnhqa1F5NnE5RGJqRnFEZ2pLK1loalNoOHlualdm?=
 =?utf-8?B?N3FYRW45dWJEVmdQU3ZNVnk2dlBUMk9wMmF2ZS9OL1EzaERxb0VVS2hXcTBV?=
 =?utf-8?B?WHBuY2VlUStjbWdsOXhwOUhDcExSTXlRbitoZzZmYVhlL2QvY2ttNHdWcUVD?=
 =?utf-8?B?bnNMUHM1TlNvTzlIU2pEbUFuay9IUFN6d2lLbG15QmVWZERMeDV4V1JKUGNV?=
 =?utf-8?B?c3VudXByR21mcFNIcGpGZHBnTlFvUFRmc3cwbFAvZ1VVU1Vnc3pXT3lsRUxY?=
 =?utf-8?B?U1JkNHNYcTBsd3JtNUdFdjVFcjRiT3hrYWR4N1RDbEFTWDAxcEJSQXRmTFlx?=
 =?utf-8?B?UDhEaWdxODJmK2dGajFRSEY1b1dreGp6bm9nbWJ0UnQ5M3p0c0pwY3lGeklv?=
 =?utf-8?B?dEQ3MVJsT21zTXpBalk4Z0VFRi8xTjdPK0E3WGlFUVlrQVR6SVUwWVNlbEl5?=
 =?utf-8?B?UVZOSjJOdXpsclgxTXM2eEZLMUt1bGJQUERkODZuckZPQ0lMTENsUGhUUTJL?=
 =?utf-8?B?eFM5SUY1UUFoUWdaandNVzZhYkQ1aWVMYksxS3o2ZGZnQ1F3VlYySWVXTjJi?=
 =?utf-8?B?NVBHejB5OUNFeTlTdWp2Z2s3eUF3aytYQmMrTkVCVmdTalBIcmg3RzVwTUpo?=
 =?utf-8?B?M1ZaUkk4ZWM1a2RxeTVZaDNsVW9qb0Z5YnFPUDFCQjlZQjY5Vk5WRk5TZlJY?=
 =?utf-8?B?cENSUlcvUHE1OFp2MUI1ZmtOcWhzWFpHMXNWQlpwamVJUEJsVTRaTWVIODg2?=
 =?utf-8?B?S2xZRm5Na2o5MlVkOGw4WjVIRTEyYWRrMjNrc0VYc2NoODRUMGxzOGNneVZt?=
 =?utf-8?B?MHg4YkpvSGxaV2N0NlVubzNVSFB3WExNa0hTSElJQ2JIWmxNWnlHajFteVlj?=
 =?utf-8?B?RlMzdkdHVUFCbkxCVkRwaW5MVkt3TmdPZm1HdHB6MlpVVUQxQkpBenlvcHRR?=
 =?utf-8?B?bmlHaXFzak5raHVlN25CZ2I5RzF2UjVaYmxQblE3c3dmczRYZkIzZXdDQlRo?=
 =?utf-8?Q?DvwvRA1NSi4+QEvhSVVuMJLk8I5lb48cay8BpMR0ITEs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SURLM0paZzYzRlFMYUxlNHZVQ2M1SE4weEZZcVNZWEdqdGpIVFpIS1RiSmEx?=
 =?utf-8?B?cVNLeklMQnE1SWY5V2dtNFJFay9XYlB6Z0RoR1lCYVBaN2VsYzArMGRLNUp5?=
 =?utf-8?B?M2lXUUVNdzAzRTBUbEtibVpmaGFTUTAydld2MW5xYmprLzFkYzhlVTVmWFJ0?=
 =?utf-8?B?SmZLaDJyVkV5S2k3bWhUTC96S2pwaDB1QUJwejkzWFN1VkVEazhyMGNpUm8x?=
 =?utf-8?B?Wi9LcnZ3WGsxR1hLOFJHY2xCY0QzL2RDOVgrMXRDZVVUS1V3M0p0cTEyRFkr?=
 =?utf-8?B?dVFPZmFwRzJ4NDNDSUROUTJSdktRdmtya21pN0ZkRHc0d2RyWWdpSzNLaFBx?=
 =?utf-8?B?ZEtMVFBsckxjUCtOTmExYlhyeTJSSVVBSlRpWXNReitodWZRNEp6ME44U3R2?=
 =?utf-8?B?OUJoeFViR3YyL2pNQU13SmhycmcvcDRHMkMzaWplQW0ySU1yS251RmhFbUFJ?=
 =?utf-8?B?MzdxamU5Mm5jZEFGTzBNaEJhaHBWa0EzblJoM2Eyc2JpVG5NYklxVnk5U1A5?=
 =?utf-8?B?aW5PbCtGT1E5d0dCS29TTXNkL2VFTWtnNkRDbjU1ZFpjQml3dVE3eUtGbHdJ?=
 =?utf-8?B?bnhGcWFZcEp5RXI0akVCb051dVlObFg1WlZWdC9weUE2OTBLa3R3Rlc1Q2ky?=
 =?utf-8?B?Z28yTDV1SC9BYVNmVHA5OC9Pc1ZCcDhUanBFS0hGWUsrd1A0MGQ2NTJESXlK?=
 =?utf-8?B?SzdGL1VhcmxoY0ZvdWhaQnovOU5xb2FUNDU2KzNDNEFyVVhoUzREUkRJaEpt?=
 =?utf-8?B?M2oyZUx4WXpPYkVOenppajdpd2NBbWt0c3Q4Yk5VZWt4STZQbmRpenZsY2VF?=
 =?utf-8?B?bGpWVExSOUd5OUMvT09nbjQxYnhFbHVsVmp5cksvQXY2TC9zU1QxOG91Nmg5?=
 =?utf-8?B?NFhkanN6YnFIaG9BSmJmWUFuNGF1VG41S25FQWt5TGV1OTVWYnNtelZCVytv?=
 =?utf-8?B?bG43T1RQVUFIVWJlc1ZWNFo2bytvRUFMTjdJbHoyM0tIR2hqdGU5QngyR0JJ?=
 =?utf-8?B?d2FXQ0dlUkpvdHlWZDJLa0NEZDJtc2d5WVNhY0RiSHVHQzJnazdna0RlYlcr?=
 =?utf-8?B?S1RMWHNkcTI5YWM1c1J4UlIrR1RTWE5DQjlKRHFTL1BjMENFdGJXck1Ma2lq?=
 =?utf-8?B?U2kvUVhxbGlrMmhWTE11cmhmYjdEWEtxUFFhdktJMFRScWxzZiswbkhsbUFU?=
 =?utf-8?B?RCs2a0oyY3ZFQVdvTERWTHB4dlNRbkV1czczNVNDdE9ZbkhlbU5OSWN3cUhC?=
 =?utf-8?B?eENrQjBReER4RHFrYTdmN3FTVlZCTWFkWTAyUFFicDJOMHJ0UjFDZnhjVGRW?=
 =?utf-8?B?ejFLNTZmOUxqNWdxVVhEcDdmTlprK2tITWpvbjhaV3RlV08xU2RCMlNEZWEy?=
 =?utf-8?B?NjBJN1ZhSTNpZ1pwdXhWZXBRU3hYajdTd3NEWlB3UUNGRWlzUFBsYTF3aER2?=
 =?utf-8?B?bHpiaUZPVXdPaG11RGZzUitWY1ljSDRMckNPOThFRytwZG5tVTJrMks5NnpS?=
 =?utf-8?B?K3hrWVlmM3ZQLzRWYjl2VUJacTV4YnMxeVkyYzFJYXZ6elpyajk1Wk1ydU9l?=
 =?utf-8?B?SnJ2b0owS1l1R3QxZFVJd0p0aTR2MklSemxBb002NHdJcmJXZ2t0a3loMU50?=
 =?utf-8?B?TmRLcWNxVVN3am1UQ0Qxb1I2blJYSC9mZ0kvc0k3MStOU05Ucy96M2VQcmM4?=
 =?utf-8?B?M0Q2L0Z5Ny85cG1zbWpPQ3lYSDRRZ3BndTlXOUtuNjZ3Y3BkUW5WUmN4RDcr?=
 =?utf-8?B?YzdHV3pvWkJSZGYyN2ZkQzJDWHgrOGE4dU1tZklwRlRnYVBJaHJFTGNVcDV6?=
 =?utf-8?B?R3hUTUdBTXQydmNsQXZmS2tlcTFiSGdrNUdQR0dYeWMwUjZCaERJOHZZUk9w?=
 =?utf-8?B?RFZ3U1pNV2FVUDlKN2pVblFqd3dMZGN1SjhQbFBuRGtDdVpjbHRZQTJYZWJM?=
 =?utf-8?B?bUNZYnFrWnhuZDlPaXc0UkhFTkFsMmErc2hxd01nZnAxTU82OHMzcVRPWHgx?=
 =?utf-8?B?MXhLcDBTUDFCdTdtUzNIUk9Bc0hNdDNPWWEvT1hvbzNwNTBheXplL2VUQXp6?=
 =?utf-8?B?bHhFVjFGZndFYzBYR2FyZmxEWXpaaEpaNjJ6STVna3NDRUdDUVdmMTZUanpn?=
 =?utf-8?B?Y3V1Sm1XUFBCWlJaNmxNajhWRFJ0dUN6bDBWR3o5UlUzU3FMMTh3WVIra3lC?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3dc6d7a-49e3-49e6-5c36-08dc80e67188
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:24:01.6262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuWUT5cnmJRMHLF0dpmSTOE0htCVX2kcLPX5TZARO987oRw4gyrOIiyGPs7cG714J8to8yBLotcQFjrBvetxV7RKtA75e3jqA0N+YC3brGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6772
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:19 PM, Tony Luck wrote:
> mon_event_read() fills out most fields of the struct rmid_read that is
> passed via an smp_call*() function to a CPU that is part of the correct
> domain to read the monitor counters.
> 
> The one exception is the sumdomains field that is set by the caller
> (either rdtgroup_mondata_show() or mon_add_all_files()).
> 
> When rmid_read.sumdomains is false:
> 	The domain field "d" specifies the only domain to read
> 	CPU to execute is chosen from d->hdr.cpu_mask
> 
> When rmid_read.sumdomains is true:
> 	The domain field is NULL.
> 	The cache_info field indicates that all domains
> 	that are part of that cache instance should be
> 	summed.
> 	CPU to execute is chosen from ci->shared_cpu_mask
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 28 ++++++++++++++++++-----
>   1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 3b9383612c35..4e394400e575 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -517,6 +517,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
>   		    int evtid, int first)
>   {
> +	cpumask_t *cpumask;
>   	int cpu;
>   
>   	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
> @@ -537,7 +538,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		return;
>   	}
>   
> -	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
> +	cpumask = rr->sumdomains ? &rr->ci->shared_cpu_map : &d->hdr.cpu_mask;
> +	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
>   
>   	/*
>   	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
> @@ -546,7 +548,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   	 * counters on some platforms if its called in IRQ context.
>   	 */
>   	if (tick_nohz_full_cpu(cpu))
> -		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
> +		smp_call_function_any(cpumask, mon_event_count, rr, 1);
>   	else
>   		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
>   

Why not provide the cpumask as parameter to mon_event_read() as I asked
about in previous version (again feedback that was totally ignored)? With
this implementation there is a portion of SNC logic in rdtgroup_mondata_show()
and another portion of logic in mon_event_read(). Scattering SNC quirk logic like
this makes this very hard to understand.

To help with understanding this code I asked _twice_  ([1] and [2]) to
_at_least_ provide comments for these SNC branches but even a request for comments
is totally ignored. I even provided some comments based on my understanding
that could have just been copied&pasted (if it was correct), but that was ignored
also. I understand this work has been taking a while and to support this I am
trying to spend more time to review and provide more detailed feedback but to
find it just to be ignored over and over is extremely frustrating and wasting
so much of my time. I do not expect that you do everything as I propose but if
I propose something silly then please point it out so that I can learn? At this
point I am convinced that you find my feedback not worth responding
to leaving us stuck with me who keep trying to review your work and getting
ignored over and over in every new version.

What should I do Tony? Why should I keep reviewing this work? Asking to address
review feedback should not be necessary yet I seem to keep doing it. An attempt
at an ultimatum was futile since it was just dodged [3] with burden placed right
back on me.

> @@ -575,15 +577,29 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>   	resid = md.u.rid;
>   	domid = md.u.domid;
>   	evtid = md.u.evtid;
> -
> +	rr.sumdomains = md.u.sum;
>   	r = &rdt_resources_all[resid].r_resctrl;
> -	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> -	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +
> +	if (rr.sumdomains) {

	/* Explain what this does and why */

> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->ci->id == domid) {
> +				rr.ci = d->ci;
> +				d = NULL;
> +				goto got_cacheinfo;
> +			}
> +		}
>   		ret = -ENOENT;
>   		goto out;
> +	} else {
> +		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> +		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
>   	}
> -	d = container_of(hdr, struct rdt_mon_domain, hdr);
>   
> +got_cacheinfo:

Something like "read_event" would be more appropriate since "got_cacheinfo"
has no relevance to non-SNC.

>   	mon_event_read(&rr, r, d, rdtgrp, evtid, false);
>   
>   	if (rr.err == -EIO)

Reinette

[1] https://lore.kernel.org/lkml/2a7cc72a-99fb-4862-b7eb-da3d515f0453@intel.com/
[2] https://lore.kernel.org/lkml/ccd5df99-4d7e-4224-a07e-3897e370b53e@intel.com/
[3] https://lore.kernel.org/lkml/41cc8a35-81fb-b890-f963-8dc9524a54b0@intel.com/
