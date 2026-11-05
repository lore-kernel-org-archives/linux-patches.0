Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793838418;
	b=pUwQTPL6WWwUxUNFxejEX3Pz25YzwN/eCO2bsY068LmvieUNoTfEb5Uh3TqENidvJtZ5
	 /2qZEzotof97NokSY9FcO6fZwOcUxsSdCqc4sW7kUljfLowNU6qePYsioFcVVigvq/VTY
	 b5fym8gjZmXSZpBeJX64KkTadcYqolz1MXUT/2pG4OU3OmBH0OwrjZylx0RPlEXFROktE
	 LOJulmzoDy4PDqO0uKyrEAZnpD/PEvbH07Wel6/8T2PR/EjCAIlZKOwwgjn3DbTr5EloT
	 ITy8eHn6IjExvCLj2l6b08dja45fWtZKzLyw/VHR6eNlo98rWoIGP242grA6oKX0WmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793838418;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:From:Content-Language:In-Reply-To:Content-Type:
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
	bh=SKWzyWhyz/Dc7Hob4FBrawBTxI626sjrVKfe/nvyQDU=;
	b=YzEtMhUDMt++1WVInQIWi5WMsoeq4jFDOjNPPsWkV2SwT/MMmkwUt1aP4QgE4AaLgEn7
	 FnW29TXxKWZSZHFEyIAJbRrU/Ha4rC1u4YUFp5Ei9sRzN9k3Y5VxMJQhU8S0hoZEOkYKj
	 3hij/SsZXvWjq/w79dYm9kSlLQs+YppZ/LXzYVLg37apQLVd7yLDJB2WfcCiWlKMRtYyX
	 NbUpAU6cSwmq2fNhj1VgkYZCloMc0ADBguUR+CqyQDuYHNVTxKY6lux+erH5R3MHZC9bk
	 7sKepkTS23KM3VOUXp77isY/rLFG/kQ/U49h2CdO+Pr7JY2jzjeqqJZWKq7X9fANUgg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qgnzqi9N;
	arc=fail smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319D3606A326
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:26:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 319D3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qgnzqi9N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793838417; x=1825374417;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ScKzDwujZK8ihBo7P+dtJ2nDNWxWNXUk468VoAuvMNg=;
  b=Qgnzqi9NfdQ8W+TcC70GcKAp0+sQKujnphlmbFOCUSY8au5Bxp9OxTVb
   gyoUw2HQE6KR9BCuhIJYvCYYi5X5qzlyG3ll9OJfrq5HQ3DD4f2vJuprs
   /0xk/rJ+g0TsJeg/vk5ti0RCUETYuIx4pe29/o5uWzfSS+Xi6IkcRtAvL
   oO5YZT1NXSmJ4F/Kd173v/zudWl4/E/j23WFMvSrJaV2xiCDcvjMtxwZu
   w1Fe+Br6LTU3Kag4Q95LfQHsOFGT7LTk190LOJ7C6CUVgO2M7TFSmC3Ys
   C3PkZLsGC+20B1Sod5tN4vqG/DzvxK2Ky5If9PndKkZxgfD+GcG9SMTHa
   w==;
X-CSE-ConnectionGUID: 4PPROKqQSP+EeGdMSd4RJQ==
X-CSE-MsgGUID: AGcieb8rTMOWBYAeqoBIIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2606901"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2606901"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:26:56 -0800
X-CSE-ConnectionGUID: whCYhLKwTna2DOUe7/Hxjw==
X-CSE-MsgGUID: B11fjW05TAafYAKqiEjphA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="7015538"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:26:56 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 16:26:54 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 4 Nov 2026 16:26:54 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.47) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 16:26:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndodOR/kKcS+7oVj6k/u5Xwk7jXVDuCcxilmu5jV/akTsuEwlKQvNg4ExgIKKDN6jdfgDYtVvZcY5MOn1SGf0nSQ80K1Qho7EQC+GZlIGpLUXFVh6+c+E5KXXYQyAzFGFZwOafdhJIWbylDJ48+YnKa+oe78iuyRuty5m7e2NAY6gLf9F5Jv3cD77P83g9FPTsl1Hv5Wch9BwTfOt8OiMAapaOzT4yE7OuLtkKwPPJqi3tx4+UGPtHWlTwGmMfBXIik5yx2tcUwSBWg9jVI6I0bOXehCzeXA+z9qu+9yZ+Dkpb2al1TAWN1dkKwppg/fYLPblTvSIZohzGj6PpQM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKWzyWhyz/Dc7Hob4FBrawBTxI626sjrVKfe/nvyQDU=;
 b=uNVrP9Umuf8j8ZFYVNAhjOQ+orvMpdYpfz0cp+56zt3dPKW/0So8i3Ys4B/jMKGtQV0TybpFOlrhjhqVDJJH8qWQPFIRtBAH/AYI5xy919vkriLnRgPOzF5+2zwFJhtIjwefOB3rj7uChJlpAOxGIx3T4g3VadwYMtZb4RwV3sGLsfoxRV9VQWx+H5ke6Vv6SRuwOTh+xFHlkJYI088aFm+ygwlosRVvia06Gtb8DPMXg9Vgxq1GtbuyEXLmNoxRby0CAEMwtNbPI8FQNteBpj6WmUO1no9Eb7oWMnkiYbOJI0zK4ozYvHSv7kXRElc+4Ziy6dsBMZeor9XYkvkilw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by IA3PR11MB721313.namprd11.prod.outlook.com (2603:10b6:208:626::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 00:26:47 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 00:26:47 +0000
Message-ID: <0dfb141b-7b92-423b-8603-12d99ad1b2e7@intel.com>
Date: Wed, 4 Nov 2026 16:26:43 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] x86,fs/resctrl: Cleanups in preparation for
 multiple controls support
To: <bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>
CC: <hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>
References: <cover.1793834224.git.reinette.chatre@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <cover.1793834224.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0215.namprd03.prod.outlook.com
 (2603:10b6:303:b9::10) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
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
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|IA3PR11MB721313:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dc0ba32-6615-4377-dff1-08df3ad379fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|260925022911599003|261022075727099003|260925021311599003|260925021911599003|261022105027099003|11063799006|56012099006|261009223027099003|261021123027099003|261026121527099003|261026140227099003|261028144727099003|261021121427099003|261102123227099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: oj3lDUVqcpoXeOW6cTqZX5pCuVHkuSKN+13Vs1FRh1OE8Z2T8ur+uaP8X+8sOuQ/azhYHpUp8DDF8KmOHmReAKorsDm7XVPwIS3ZaT/kvLOr+1Eqh707fA9cHu9zq7PddJVJG/LjV8FjlYII7yksBnBzNWF936dJ+z1UVmLs8+H21WObDY7w1Hqko6pH7BVPDO4P1PzBk5ExGJcQouaKbBrT5JKcTa6pP/jgQsTnYQrojdxt/ziUotZNDCuK3QqEeXx/0jWL+NoTi5A/2EDD2hUVx9ad2NcmxAYtACp2ASm0trBkip/NaHodI1H7H8Qs4RUc6QM+SwOHgUbnrsNxAmfEJ1d7LilCT59ATJPi6g14znVjLak4wLBvHjif5ZCH1oDpSUVTNQoVFS63lip4yJkjm5moi6TcGzIkI+31o6P5H1DvkW3KgvR8g40HJR/CKu78KRPDLDZUjtZBLmXPT7bwTU7swYHHlyjibg+HYL2wvzyFJ1fWb3IV06zmcyFp4LX55M0eik2X7yOioEWq5NbAGuvkWcW2L+jTBWp6nWktYM3qtos3PgPkSqufpU4+0PiHB4jTjTonhZmC2TZNHqsSUUfQPMv2srphOoyWULQIej/BaY8xksnmBSO8D2KZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(260925022911599003)(261022075727099003)(260925021311599003)(260925021911599003)(261022105027099003)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021121427099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkUreS93TXRsRFloUDZ0K3JidHFmV2VDZTVpeFNqVE9XbXMyOHFTTzJnTlVV?=
 =?utf-8?B?S2s4UEZralRXQlFYei9WYXZ1aGFsQTZyVTNTWlhZZ0ZnU1k0MERPTmdVT0pM?=
 =?utf-8?B?a2hQTmFXb3FkOHZWUTBwYzlIQjNRNk4yMHhGVjNkVUczVEVndzJDU2hhdHpV?=
 =?utf-8?B?NjVKMzlzQXhxRzh2OS8xZ0FzUEpPT3h5U3RIMDFlS0NJZXZhRGNxdFlSbkxT?=
 =?utf-8?B?RGx0d2JlVkFENjRvVDU4RmNJbFVvc3BOcjVramZGaU9Pc3pYbWxMazI1RlVm?=
 =?utf-8?B?ZWgyM0RvMW4wcnBGbHY0bml3WkcyTWFOT3dnYUFVY3FDaXZkRG9yeXkwWGhs?=
 =?utf-8?B?K0xVblBVTS9idUkwYjl6WFU1dW5rcVhtMHh6bjU2WWJ5b21uZkUrelEyMTVr?=
 =?utf-8?B?M1djS3g3Q2c5T2YyajlSSlZlbVBvWUVFbi80K0pwWHBEV0F4NFhkQjBFVEU2?=
 =?utf-8?B?cTFHeUMzTFpqSURRN3RwbFdSWmYrTWFXSVZESkFBWnYrL0pERkdCczN1ekVG?=
 =?utf-8?B?NjVWUHRiTXJUU0N6YlB6dGx0VDVLY2t5OXp6NWJhV2hGVmU5SGZZRTh3djI4?=
 =?utf-8?B?TVJ6ejNBSng1T2FhV3lRc0VpZXJPUTVNU04rUTNmWUEyRElpODFmQUtKY2Vw?=
 =?utf-8?B?MjNLV0RPYXUwSk5qVVExWExxeUROcFJ1THZWNzlWTnFNNEtrZmxrREhPVUNW?=
 =?utf-8?B?QUZDaG1rWVI1d2w5bzllYnNRUDFEOWt1bE1hYU1aaDF1dXBjaGdDcE1JWE5O?=
 =?utf-8?B?UzAyOGNNQkJWZGZsUTJFMEw0Y2R6Y25FUjd3N0NmU1hBZnZ1UmZaVXozSXgw?=
 =?utf-8?B?RlhjQ0pSSDVuSStPTkh5L0k3UzRDaUdMcllpNmRXbWNnbk50TnBtMDk4aWE4?=
 =?utf-8?B?MXpoWEMzVk5Fa0NkRVNGMGF3eng2dEVJZWNka2ZQRTQ4U3VnZnVGVXBoNURB?=
 =?utf-8?B?cy9DR2N3blZUeVlBcy9ud09DTmVieVlXa0p4S3pWSExURitrTS9naWFlTnZs?=
 =?utf-8?B?ekUyelJmSHpoTlI0MXo3NUR0aHQ3M3VFTVNIZytqSGFJM3E4MDhqQUJWbnVH?=
 =?utf-8?B?QkwwQmRnUVhRMzFob2JqeXZMbzZqV1dIMXVadUw1eVdtanA5WDQ1dklSd0ZJ?=
 =?utf-8?B?MWJIek42OFM5dlpkd1FES0xiK2k1bURDSmxjQzdGL1ZPRlNtQkd3Ky9JSkNu?=
 =?utf-8?B?L3l3Nno1RVplSVZvMnlISEdKMVNTanlqZ3IrMU9WUWlROHNINEcwbUFpUlFU?=
 =?utf-8?B?UUd2dHRlYStUQndGYWJITll3Z3FncnliZk8xY2g0THpwSk9aS2ZrbTRya3Jh?=
 =?utf-8?B?UGl6Z2ZGRzJoYmIvVm4xV2t0aDJNZ0drVENBWURNS0hkcTZWN2ZVQXZOYmE3?=
 =?utf-8?B?Z2pLa05EQ2hVdW1LZ3E3MkxTeG5qeDJ1YXhxMTZWbGx5OGlLYURRUXJmSUtz?=
 =?utf-8?B?cElpdk9xbkdxSDQyTFlheTBseXIxV3pQNmZNLzlrM1AxR0w5UGcwNEUxb2d3?=
 =?utf-8?B?NlZTWWpVSmVORWUxVDNVcTFwM2VSNVR6LzRGREhaR1dGT20wNnJxL3pOZnBW?=
 =?utf-8?B?Lzk4U3diRW80RFVCRTNML3VPM0IxOTgvVks4NjRKc3E4bmxkV1BqdktEQytE?=
 =?utf-8?B?eXVrQTdENUk5SGdMUmdZUUpWM1Y0OXQvMlJkcWRJWkV5QUs2L2hTTXZWc2la?=
 =?utf-8?B?dy9nK0lKWnNhVWVmTVZGNkVKWXFPd2lDYVlsZFNTRnJHVkdlam9MZUNTM2g1?=
 =?utf-8?B?S04zN2xlakxRMTdpcm1XYlpmamJBQW5sWThUTUFmcERzSWU5bUhPOTArR2hq?=
 =?utf-8?B?OEdWN0FXZ2p5bjU3eEkyTXhuT3V2UzlOd3lRTmR3YjNwZjVqT1NtSFhIUHZD?=
 =?utf-8?B?U3M5d3h0cXBaU0J5VXEwK3lLdE1YOTlhS1dsUElrOXQ5dVFGbDkzMUtoOUEy?=
 =?utf-8?B?Qm50V2FHbWlxVDg5Y1o1YmFaRVlSMEtTMDRUanU0bnJ5eTQ5SmNvOHlqL2VB?=
 =?utf-8?B?enpkMmV0Q1c1bGhnTXh2d2FzN2JOT04rL1kzY2o2SUtVWjNvbk5BYmczbUdF?=
 =?utf-8?B?NmYvekNKY3R5RTR5RWlDREhOL3hyRHNPL1Z1QmtPcnlnQmUvcXREalBzTmpH?=
 =?utf-8?B?UStGMGpiajNIb0h6RWltSm9zSlc2MUVCRFVPc0dudUFoMXlHZEF0TFB4MFJV?=
 =?utf-8?B?V0czZEx5WFoycEw0UGIvaGhaU3hlWFhHekFlcklsSi9wd3FCb3p5TTEwdGZL?=
 =?utf-8?B?YWdzTHA0eFIvVzhtQk50Wk5zeUZTd3NuODhZWUlORVdxb0V2c2ozQi9wamtR?=
 =?utf-8?B?cUJMNFBpVzZjY0x2NXlPSmhPM3ptd1Q1d3RyTjdxWjN2ZGRZaGw0bmMyZERC?=
 =?utf-8?Q?r63IpjcWDWXhkbpw=3D?=
X-Exchange-RoutingPolicyChecked: KmP4Rz2MOr51HycRk+kEs4sgqG0C0VKp4bYUOv/A7aj/3UsVx7cCgxShPssqclX7I/vfntWYVzwxJF0ZtJkhBCmnNuCea/+lW1wGZdchsVAB/AjAZyuDw6EPy1n4f4j3CvPzRb+Rk8so3ynm2KLcHFHbAteEs5Ytm7fbxQnxs/CABq3C3s1DpenRL8KMPTtHXiNS4k58vCovh82I1bcQKnGOc/hOTy4Z0LCCcIhpVgMkAFKrfoxW9+GGES+28UIp2PArKiOPMCp2ud8WFA1GKUgDpMRzumzqIRcHhkCkPl0O3M211p8Li1Pa/zWhoYLn0RRDYofE7xRKUwQEI7cgdQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc0ba32-6615-4377-dff1-08df3ad379fe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 00:26:47.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: torOhtZXZ0iAKAjD0NrfmqKrQsMwDwZwiBm6Uu1oR2JAuBoRnwwWr/6Or8tgZkgmIj0bgH0bJgDDV2xweCNkX05f9Mmm0qlmUNChKiCEnn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB721313
X-OriginatorOrg: intel.com

Dear x86 maintainers,

Could you please consider this series for inclusion?

Thank you very much.

Reinette

On 11/4/26 4:13 PM, Reinette Chatre wrote:
> Changes since v2:
>   - v2: https://lore.kernel.org/lkml/cover.1791406459.git.reinette.chatre@intel.com/
>   - Rebase on v7.4-rc1.
>   - Add tags. All patches now have at least two Reviewed-by tags.
>   - No other changes.
> 
> Changes since v1:
>   - v1: https://lore.kernel.org/lkml/cover.1788452481.git.reinette.chatre@intel.com/
>   - Rebase on x86/cache branch of tip with HEAD at:
>       50e5282df427 ("x86,fs/resctrl: Add event group descriptions for Intel Diamond Rapids")
>   - Rework all changelogs. Most now explain why each change is safe and why it
>     is needed independent of the multiple controls work. (Ben)
>   - Make subject lines more specific and fix the prefix of the patch removing
>     the non-linear bandwidth delay mapping.
>   - Keep the informational message printed when an Intel system with non-linear
>     MBA delay values is encountered, rewording it and adding the missing
>     newline. Match the related warning to the same wording. (Chenyu)
>   - Group the memory bandwidth property assignments during Intel MBA enumeration.
>   - Clarify in kernel-doc that the MSR_IA32_L{2,3}_QOS_CFG scope property only
>     applies to cache resources.
>   - Add Reviewed-by tags from Chenyu and Ben.
> 
> Hi Everybody,
> 
> For resource allocation resctrl assumes there is only one way to allocate
> portions of a resource. That is, every resource supporting allocation has a
> single control in the schemata file that user space can use to allocate
> portions of that resource.
> 
> All architectures supported by resctrl already support, or will soon support,
> multiple controls per resource. For example, the memory bandwidth resource may
> have a "maximum bandwidth" as well as a "minimum bandwidth" control.
> 
> Adding support for multiple controls to resctrl is a major endeavour. The goals
> are described in [1] and summarized in the Linux Plumbers Conference 2025
> slides [2]. The implementation is in progress, with the most recent PoC
> available at [3].
> 
> This series contains the preparatory cleanups from the PoC that are ready to be
> merged independently of the remaining work:
> - Remove the unused support for non-linear Intel MBA delay values, including a
>   user space configuration check that can never fail.
> - Make the scope of MSR_IA32_L{2,3}_QOS_CFG a private x86 property instead of
>   a resctrl filesystem cache property.
> - Drop an unnecessary helper and an unnecessary function parameter.
> 
> The only intended functional change is a reworded informational message
> printed if an Intel system with non-linear MBA delay values is encountered.
> 
> Changes since previous postings can be found in the individual patches.
> 
> [1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/
> [2] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
> [3] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/
> 
> Reinette Chatre (5):
>   x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping
>   x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check
>   x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG scope property to x86
>     resource
>   fs/resctrl: Drop unnecessary is_mba_linear() helper
>   fs/resctrl: Drop unnecessary parameter from
>     resctrl_io_alloc_parse_line()
> 
>  arch/x86/kernel/cpu/resctrl/core.c     | 72 ++++++++------------------
>  arch/x86/kernel/cpu/resctrl/internal.h |  4 ++
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c |  4 +-
>  fs/resctrl/ctrlmondata.c               | 15 ++----
>  fs/resctrl/rdtgroup.c                  |  7 +--
>  include/linux/resctrl.h                |  7 ---
>  6 files changed, 33 insertions(+), 76 deletions(-)
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

