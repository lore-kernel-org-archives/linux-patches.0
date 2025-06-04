Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C3072601
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008284; cv=fail; b=AxUkvQXW5IOr7qA2bFhjK5Dm7pEQNc68nSAiK6Z3y5Vzl/aa1GN7Oc0cv8IWKqs0/F/UcGymAprXoacSs9eKG1inS5nb9E9YiVkXcLGxJRY/KdEoVJqmbQ5rNw1VkN8ZlHJehNe75+TUSKwYLC23S+FRZlxHOqjE8xPvYnGZcGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008284; c=relaxed/simple;
	bh=009A8f+smKr+AgQkuTNEXVyZn5Y2CcADhJokhW8NdA0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PNoQkbOUIKs2/xg6U7osMvj796juQJbPzhlpjqfWxEfeTnbo/KFvZ5xNPp/Z45S9NsHQM4IaHjJ8weIOKYgHd/Q/2jMsaQNwxjJ9JS1X5nQAyeBk6HCKGA0bqEd7U7jP57rtxnrvW5TYjg77H/pacgnxTb9ohrS9mjhxj4dHlaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfR1ZgMi; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfR1ZgMi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749008281; x=1780544281;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=009A8f+smKr+AgQkuTNEXVyZn5Y2CcADhJokhW8NdA0=;
  b=EfR1ZgMilwabqK5XnFtt2YcZvIiWJTMC/S4Py+ge9Cs9Dha47j/P62Go
   mb7NIH/TA0y2VgLitzfpm67SuuzHT/t4eotXGs0uMUekwqZEGowVO216/
   KQJCO81ikrEKY+9ZNVKYq7x4kisOUEYUnEpentbpOJtWFY0fjjg0L90da
   nRzlKxiH03bvlNWRw9X7yAn6cY/iMqhdeDB3TU4qwN4jJd63JWtzjrJpW
   aUbXnCcumB7lNTwKQJGe5JnRxoaxfZufKZDZtOPxhtDIvh+1AVVi0ZsQ3
   sZQdmeV3utMRcXJkkqPoXhz/v78KXRk6nR9mP4AGQOjPXUo82kDuYo/Ks
   g==;
X-CSE-ConnectionGUID: Fym+jKJdQSWD8ElWItfvsw==
X-CSE-MsgGUID: pCCDCf3NQjSJ2h94T2zStg==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61693327"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61693327"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:38:00 -0700
X-CSE-ConnectionGUID: vHf0oMNgQKevIXbeuY1v3g==
X-CSE-MsgGUID: ZdwW7P1OSleZehM8itfCLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="168226550"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:38:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:37:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:37:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.80) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:37:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=le1QHlLxtdvX0jN2e6xxIZwjK7k07qrMqWFzsa45ro7p2ONU/9gtm3X9MJlxTrY8Wjp8rwgqJ4UMntqDaO7lZjc+guuX9qxFj8VzebNtWo3BPeE9QmVMbJp4+ulsztPYE7Y7mLM9t2ASwjwz5HdZWOF2XVRhl18rxOu/iH7MMu7Axjx7LJonAgSLeJZXaLBaKSjpTf6Z5TFByJovSWQiEAUe5OtBYrXqgbtO+hvj5W1Vmr0WiSs+Y2T5CidgPF7qM1wa0KlxyZpWsxQO/eODKqqTa3/vEYlCBp/SB3cRHKhVw5U1ey+KYiwADKk8h9MH86cZLi0LxiAb6KdosACNVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RowpHosTg3d/QJ7M9+QSQS9oiLUy7GNnM8CG/mqT+po=;
 b=j3ZF1fTMYEXLXDqUPLeg/aEcFLjHk9Kuf6qKgAYhqqlh7Cf6qsOiitgnF6xBKjBKXAO7ty/RjlApQCdDJ9Doy+7wHJriICiaC2+zv6xyjVDR/7l7o5X1byZlp1A13av8bcOAv3y3b1zn+jYOdCS14wesVvXbqaWfNmnh8cdGwxFxL2hm30pUESpOdLHNa2y7dQHLIaymAi+1WaYA94F1D8p62QASUrel/ghwr0Vs8GH9MmwRpiw8wMDy/ejyISZRCyIjYEilFwx2ddTjQZmehIA3+QRnndZHk4+lF26lzL5BAaLBhfGRPCKzoj1Zuwge7SPYxWCYHod84CvICiWVpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Wed, 4 Jun
 2025 03:37:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:37:43 +0000
Message-ID: <02c7b00c-1f48-444e-b8da-6787c5a12348@intel.com>
Date: Tue, 3 Jun 2025 20:37:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to
 use struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ROAP284CA0181.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:10:43::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: 01fda2d0-db5b-46af-b74b-08dda31929ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TkYvM083NmlUZUlxNTN5RU1zTS9YWXJGZUtGbUFRWkF6dkxha3VtbGVNbXFp?=
 =?utf-8?B?QjVxNG1xQ0h3Z1d3YkY4QjF6aEl4ZGxrWlhaMXI1cUtRQkdxRjZ4Tm9TV0ln?=
 =?utf-8?B?UUVEM3J6UkN0NWIrNXhYUzRqU3lkR3dQaGk4anFrUGpPRFM2NTk4K0x5Q3BT?=
 =?utf-8?B?Mkh3Q01YekJGcU9PNVQxZkVGajU4Q29CbjBVOGkxUk9UU05uMVoweGxlUUg2?=
 =?utf-8?B?NVVYRGIxUWFpdmVJUGYrY1hxL0k5NjBYVWdMMlZ5WkRmczF1OUdudHp3RTJs?=
 =?utf-8?B?SHNJRG1LajQxei81RFU4cGRZT3ZtQUxDdXRxeExXWUJhRzgrejJiQjVCdjZT?=
 =?utf-8?B?MlNjMXh2TzZvNXIwRGN3ZTNBcjYrcVdtQ3A0WnBDcWw3a3Nlb1paQXNQYmh6?=
 =?utf-8?B?MVd6WDMxeUdmM3RPZjNCSzZnNkJuZlZhU2paRzRxQ2NnWStzZWlTaDY4V2N2?=
 =?utf-8?B?Y3AxdEtVQ2RuRzVEWUQyb1lQcitLc0VzL3pxSlB3Mld4NDdUaWU2L1Uxemtv?=
 =?utf-8?B?N05pR2VqS25VYUg5QTB3UTZqUGpkZGZMMWd4V3hmWDVUZUFvbU1vU1VzVCsv?=
 =?utf-8?B?a3F4U1hjSDNPZVJVb0xSMGZkUW85OFNWWWo2aTlTRU9uS0hsY0RVMmV0aFk2?=
 =?utf-8?B?cUNYbzNoaW1RZ3Qxb1JqaUh3WHVtYytueE9sc1FsKzRRZ2dQRUc2S0h2QmNB?=
 =?utf-8?B?NFFVd3JsZzZQNjIzZjhrVVcvcFh6Yjc2bkZuOXR6QnBhcWdvRGNyREVSTGVP?=
 =?utf-8?B?UzZOb1BpaTJ2L0E5TzQ5RUFSQ1ZOR0plRUl0bys4cExlT2NKNFJVRHJSQ1Bt?=
 =?utf-8?B?bXZSWXljZXNweUxOWlJBSFNWeENPMmUyaDlKam1wTE1LbFRlbW1LMWFxMFJq?=
 =?utf-8?B?S2FWQlhpb1kxRTRzL2RYQkw2UGJXSW5rV0ZUbENpYjJWSjRsVnNMZXI1aWIv?=
 =?utf-8?B?S1FjZVlZOEgxT3AxT2g2dHlEendBa2ZabnQ1eXhqczhLK3FCRmR0LzVKN3V1?=
 =?utf-8?B?ME9lZkZwK2lBOTFuWklLeWdoTHpsc3dHYnVsRmhObnY3eGFUYXJBM0YzSitP?=
 =?utf-8?B?T2E0OWc3NGpWdXBVVGNZdkRxU29GQ1pPMlkxMUZOMTgrVXVTN2NlV01oeXd5?=
 =?utf-8?B?YmFBckNFSTdaZHlMNTJ5OTFHYjhxUytHb05Fb3VMQTZscGU5NzdabjllV2Fq?=
 =?utf-8?B?RXlEcnpyMWQxQktWMmp2TWtwOHhPWVhhS0VvV3dJbys5VzVuZGtmZUlwVWFp?=
 =?utf-8?B?KzZDb2JtMFg5Zkpyb0Jtb0dwVDEwbzB3TE96VCs0WERxa3RGNmNOajU5Yk1Q?=
 =?utf-8?B?bnlUbHZhbEdsbG84YmROVGJTWlo2NElkQkcwZVAwY1ZEYmFRQUNFQW1OaDk1?=
 =?utf-8?B?RXRyRTgzU21NWWFnbUFiTDFlMFMzUGR6ZHlFWThQOStENUUyeFpsRnowUnh5?=
 =?utf-8?B?VUV1TThvMW1jeWtpN2h3d3gvcWN1MCtiRnB3dXZFaEdJK3MyVVRSdDhuMkZu?=
 =?utf-8?B?am5BZTlZVHNHN3VLWE9IRlcvclpDNEJsSzFzV3Nrb3BGU2U1UjBBdHJ1ODhj?=
 =?utf-8?B?bWpwWEpCZW5kbHVod3Q4Nzg1R0hjSzlZclRXQldHWnJTeXp1aGRqTC81WUg3?=
 =?utf-8?B?bTJ1a0V1eHVVZ05pdWRRMERzdmowREI5OWpKejJBM2lWTitxeVVlN0NOMmJ6?=
 =?utf-8?B?UkllbmRqQ0xZK055eWxIYisyQ2NiRitrQ0gwd1JQdEh0NWMzSkdYbEx6SnRP?=
 =?utf-8?B?TXJVMHhUVkRnYWFDN3hXMTdka3VHWHVaVWwxdUdybmFJSmkzSjlGRHY3T3pp?=
 =?utf-8?B?RzlRcE9IcEJvenp5Z1kwVEFYSHVtc2VvZVVEQkRkdjdrbFJFN1ljeDFwS0tN?=
 =?utf-8?B?aSszUHpPUUpTd1ZaZHZWTVl1SlcxWEdwSW1YQnpQdzZpNGM3WDdzRnVHT083?=
 =?utf-8?B?N2hOK082RmdCY25rczRuY2NFRDhTN1VKNlh4NHVlTjlGTTBRNUJDRXZ0bjh0?=
 =?utf-8?B?UnNsRHVFNENnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXdzQjRDS3BYY2ZwWmpqNVMwWDVZS3R6aHlXSkhNM0NhWmFETFNiN1BCakkr?=
 =?utf-8?B?ZXg1QW5RdzVBNmxobytkdWJ0WUJOVG5iS3AyNndERk5hZ3hCR3RWd1VyeWlo?=
 =?utf-8?B?SmhlMXpjWFV6UlFTNkRJRVIwV2p3c0tDNExEdDU4MG83RFptN0ZRY3NVYnJG?=
 =?utf-8?B?SVJmOTFYbC8rVHo2U3dmRElsc1lzTm9ZSUlVVUJDTWsydlBJM0JPWU80eTky?=
 =?utf-8?B?VzdteEoxR3hHU0RrSXFKUy9PcEpNY0dtQ1VaOURlYXJ3K2VPa2FnWTR2dGpZ?=
 =?utf-8?B?eUFTTE1VRllFQ01HdW9VS3V2T1d2T1ZxOC9Oc0VOZWUrS3hucGlmYUI1QXRD?=
 =?utf-8?B?LzZOeUF0dEx6emhyMnZHNG9PQXhoU3d2ZmhvN1d3VjBQTmtpSlUwb2Z4MUxv?=
 =?utf-8?B?WS9qdGFNQXIzNHEzcG9FK29aZ2d2dW9Ickk0VU5pcnpUSWJ4alM2L2w0dVZO?=
 =?utf-8?B?eEZNS0F6NGtkbXUwdTN1dWRaNlVlTFBITnFmUWNEVTBwVWdScThKeU5QSDVQ?=
 =?utf-8?B?d0NBOWNKd0c2RGJyRmF4dWlHRFp3Q1doaGtycjRTL1JNNXpHWmtGVENVdzBJ?=
 =?utf-8?B?L0prK1RtOUFzSTNqQlVMQnVHUlFXNysxbWUrMk4xTEtXVEszMkNjL1EvdEhs?=
 =?utf-8?B?VkMvMkRRVkxZdnQyckl6elpLb1VVTGVZMCt3OEpXQUpCM0QwMVNIcVllenpV?=
 =?utf-8?B?RE4rZ2pNV0NZTDI0NVNKbllMcVJnSVllSmREejVqSTMxUkpNT1VQY1FENnpK?=
 =?utf-8?B?VytjSjd3UHNGMHMvR2JKQnVRREVYdEhEeEtXemowQ1lUTmJBWFRVUzBNRW5r?=
 =?utf-8?B?bWx1OUY5c0FVd3NpL2E1T3JnZzYvOTBPMW4yVUlJNGp0RnNzUXNrUkMzV0FL?=
 =?utf-8?B?S0hhcWlQYll4SE1BVXZJa0VoMVI4QzNCS0cxdUVGcEE1QWY0T0wzbjljWGdV?=
 =?utf-8?B?dHNnWXFPRGdoMy9EN1B3UFBRcTNlM0xldXJaTDBwUkVCVTBhTm0wcllNK0lH?=
 =?utf-8?B?OUs4RExiWnNaeW1wc0srOVIxREk3SGJnVlNUeW9JR25LbUM0bHNDL2hnb25h?=
 =?utf-8?B?WGpIK1A3dENqU01DVzR5cWE0WGZid3lhS2hQTzdNQnFPeWxlTHkwaWp3QnVq?=
 =?utf-8?B?YXp6aDhlSzducGNUNXFya1NoOVZ4aWJhOVNPb3dBSVR1MFphTE93NmkyNnM3?=
 =?utf-8?B?K3Z6dUcxaHF4ZDRwbktuenBPWDd2c3ZrVEp6dC9nTXpIZ0Yxa1FIdHBIdWxz?=
 =?utf-8?B?em8yeENTWlQwMFQ3cTJ0OVc5VTAyb3hZSWxIS0N3c0NGZzQyVVF6MzRmYksr?=
 =?utf-8?B?YjZsMEh5dHFLY0IybjFOWHNZa0pQbmxuSnZVSlkvaW5EdDZwTUdIMDlUMEJQ?=
 =?utf-8?B?Z1UrbHBZMGhVeWp4SWRjSzFmMm5ZdWV2T2cveHh2aXVrVS9QRzlScktZaGtS?=
 =?utf-8?B?WUNPSDBFTmExQmJuelF1KzJhZE1ZeVVIM0NNRElxeTNVRTJ1b01FNG5ZbnZ0?=
 =?utf-8?B?U2I5dkRXYk1tSVBoTU5kdEk0a1NYNHVNRml5Y3g0WDZDaW43MlhVcnlaUVpB?=
 =?utf-8?B?L1czN0tXb0VVZzRQV29vSzRRK2lvUVNNdHlsVU5IU0tmZHk5OVR0YVRWTmtx?=
 =?utf-8?B?M3YveWpUQmc1V3Q5SXlUZXgxWlRLQ2FjS2NENVJkaVh6NjM1ZWp6MENMdjNz?=
 =?utf-8?B?dlNPL2d5OENmZWJITmFvb0dpUUhZSkdjcDJwQ2ZxbTFFcUVDMkttMlpJZTJs?=
 =?utf-8?B?MGNtYVQ5clBManh5bEVUY0lFWWJvaU9yNWhpSE5WdWFXOXNYd0hzWkdIQWFw?=
 =?utf-8?B?MTUrMWdHZEdwMzF2Z2hnUmI1ZE5qNS9VTWx3bk1GSHlQMTVJYmQxZ0tsQnhi?=
 =?utf-8?B?YzkvYmoyMTJXUWVzdU1tL29maHJzVHcwYzFlaG1rdzM2d2QybktSMGN6Q216?=
 =?utf-8?B?VU1jSy9wK1lCQUtpeGEvenVadzFHd2JSTnA5aFVqMzBYWTc5Vm1QWTdCVlRZ?=
 =?utf-8?B?VkVqanptK2VJWVluODY5bmlTWWNDc2ZsK0UzRkFuTU9RQUpYb0Z6TVJicVpG?=
 =?utf-8?B?THR6alg3a00zb0NKZyswdFkrT2JNQVdOL0Jnb3dEb2g3dThVVFZiSnp2ay96?=
 =?utf-8?B?bS8vazZhSU1tanhBQzNSTGJ1dHorb1FkeEt6VThWSnBQMmtkZXhjcU5MTlhY?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fda2d0-db5b-46af-b74b-08dda31929ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:37:43.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfe4yYKFMdil2Hs2dIPYxJlQ5vqemqxKeN54C+sJ6L9VAMgV0bZhag+EgHwcJxv3rhcQMQpatiMPsxsncXvEEiEKL3nEnu8WEuSI4K+R5eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource and it made sense to use "struct rdt_mon_domain *" arguments
> to functions manipulating domains. But the addition of monitor events
> tied to other resources changes this assumption.
> 
> Some functionality like:
> *) adding a CPU to an existing domain
> *) removing a CPU that is not the last one from a domain
> can be achieved with just access to the rdt_domain_hdr structure.
> 
> Change arguments from "rdt_*_domain" to rdt_domain_hdr so functions
> can be used on domains from any resource.
> 
> Add sanity checks where container_of() is used to find the surrounding
> domain structure that hdr has the expected type.
> 
> Simplify code that uses "d->hdr." to "hdr->" where possible.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  4 +-
>  arch/x86/kernel/cpu/resctrl/core.c | 39 +++++++-------
>  fs/resctrl/rdtgroup.c              | 83 +++++++++++++++++++++---------
>  3 files changed, 79 insertions(+), 47 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d6b09952ef92..c02a4d59f3eb 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -444,9 +444,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  			    u32 closid, enum resctrl_conf_type type);
>  int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>  void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>  void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index e4125161ffbd..71b884f25475 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -458,9 +458,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	if (hdr) {
>  		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>  			return;
> -		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
>  		if (r->cache.arch_has_per_cpu_cfg)
>  			rdt_domain_reconfigure_cdp(r);
>  		return;
> @@ -524,7 +522,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>  
>  	list_add_tail_rcu(&d->hdr.list, add_pos);
>  
> -	err = resctrl_online_mon_domain(r, d);
> +	err = resctrl_online_mon_domain(r, &d->hdr);
>  	if (err) {
>  		list_del_rcu(&d->hdr.list);
>  		synchronize_rcu();
> @@ -597,25 +595,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>  		return;
>  
> +	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
> +		return;
> +
>  	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
>  	hw_dom = resctrl_to_arch_ctrl_dom(d);
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> -		resctrl_offline_ctrl_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> -		synchronize_rcu();
> -
> -		/*
> -		 * rdt_ctrl_domain "d" is going to be freed below, so clear
> -		 * its pointer from pseudo_lock_region struct.
> -		 */
> -		if (d->plr)
> -			d->plr->d = NULL;
> -		ctrl_domain_free(hw_dom);
> +	resctrl_offline_ctrl_domain(r, d);
> +	list_del_rcu(&hdr->list);
> +	synchronize_rcu();
>  
> -		return;
> -	}
> +	/*
> +	 * rdt_ctrl_domain "d" is going to be freed below, so clear
> +	 * its pointer from pseudo_lock_region struct.
> +	 */
> +	if (d->plr)
> +		d->plr->d = NULL;
> +	ctrl_domain_free(hw_dom);
>  }
>  


How does this hunk relate to the changelog? It seems like unrelated refactoring
to have have domain_remove_cpu_ctrl() have similar flow as domain_remove_cpu_mon()
after changes in previous patch.


>  static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
> @@ -651,8 +648,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  	case RDT_RESOURCE_L3:
>  		d = container_of(hdr, struct rdt_mon_domain, hdr);
>  		hw_dom = resctrl_to_arch_mon_dom(d);
> -		resctrl_offline_mon_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
>  		synchronize_rcu();
>  		l3_mon_domain_free(hw_dom);
>  		break;
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 828c743ec470..0213fb3a1113 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3022,7 +3022,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>   * when last domain being summed is removed.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
>  	char subname[32];
> @@ -3030,9 +3030,17 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  	char name[32];
>  
>  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +	if (snc_mode) {
> +		struct rdt_mon_domain *d;
> +
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return;

Here is another example where I believe RDT_RESOURCE_L3 is more appropriate
than r->rid because SNC mode only applies to L3.

> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> +	} else {
> +		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	}
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> @@ -3042,11 +3050,12 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  	}
>  }
>  
> -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  			     struct rdt_resource *r, struct rdtgroup *prgrp,
>  			     bool do_sum)
>  {
>  	struct rmid_read rr = {0};
> +	struct rdt_mon_domain *d;

This may need an initialization here to eliminate the "may be used uninitialized" warning
during build.

>  	struct mon_data *priv;
>  	struct mon_evt *mevt;
>  	int ret, domid;
> @@ -3054,7 +3063,14 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  	for (mevt = &mon_event_all[0]; mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++) {
>  		if (mevt->rid != r->rid || !mevt->enabled)
>  			continue;
> -		domid = do_sum ? d->ci->id : d->hdr.id;
> +		if (r->rid == RDT_RESOURCE_L3) {
> +			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))

Considering the preceding "if()" ... r->rid is essentially RDT_RESOURCE_L3 and
can be made explicit.

> +				return -EINVAL;
> +			d = container_of(hdr, struct rdt_mon_domain, hdr);
> +			domid = do_sum ? d->ci->id : d->hdr.id;
> +		} else {
> +			domid = hdr->id;
> +		}
>  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);

Another subtle change is that mon_get_kn_priv() was created for L3 resource
and now being subtly switched to be a generic utility.
Consider its last parameter documented as "Whether SNC summing monitors are
being created.". Surely that can never be set for any resource except L3.
Silently wedging things in like this makes this work difficult to consume.
At least the function's kernel-doc should change, it could benefit from
a warning if do_sum is ever true for a resource that is not L3.

Simlarly this work just silently also takes ownership of struct mon_data.
How does its @sum member apply here? That kernel-doc could also do with an
update stating when @sum can be expected to be valid. Increasingly subtle things
are left to the reader to decipher and it is looking more like this work aims
to wedge itself into resctrl instead of aiming to achieve clean integration.

>  		if (WARN_ON_ONCE(!priv))
>  			return -EINVAL;
> @@ -3063,18 +3079,19 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  		if (ret)
>  			return ret;
>  
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> +			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>  	}
>  
>  	return 0;
>  }
>  
>  static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
> +	struct rdt_mon_domain *d;
>  	char name[32];
>  	bool snc_mode;
>  	int ret = 0;
> @@ -3082,7 +3099,14 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
>  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
> +	if (snc_mode) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return -EINVAL;

Same wrt explicit check using L3 resource.

> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +	} else {
> +		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	}
>  	kn = kernfs_find_and_get(parent_kn, name);
>  	if (kn) {
>  		/*
> @@ -3098,13 +3122,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		ret = rdtgroup_kn_set_ugid(kn);
>  		if (ret)
>  			goto out_destroy;
> -		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
>  		if (ret)
>  			goto out_destroy;
>  	}
>  
>  	if (snc_mode) {
> -		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>  		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>  		if (IS_ERR(ckn)) {
>  			ret = -EINVAL;
> @@ -3115,7 +3139,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		if (ret)
>  			goto out_destroy;
>  
> -		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
>  		if (ret)
>  			goto out_destroy;
>  	}
> @@ -3133,7 +3157,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   * and "monitor" groups with given domain id.
>   */
>  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct kernfs_node *parent_kn;
>  	struct rdtgroup *prgrp, *crgrp;
> @@ -3141,12 +3165,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		parent_kn = prgrp->mon.mon_data_kn;
> -		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
> +		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>  
>  		head = &prgrp->mon.crdtgrp_list;
>  		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
>  			parent_kn = crgrp->mon.mon_data_kn;
> -			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
> +			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
>  		}
>  	}
>  }
> @@ -3155,14 +3179,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
>  				       struct rdt_resource *r,
>  				       struct rdtgroup *prgrp)
>  {
> -	struct rdt_mon_domain *dom;
> +	struct rdt_domain_hdr *hdr;
>  	int ret;
>  
>  	/* Walking r->domains, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> -	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
> -		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
> +	list_for_each_entry(hdr, &r->mon_domains, list) {
> +		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>  		if (ret)
>  			return ret;
>  	}
> @@ -4030,8 +4054,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> +	struct rdt_mon_domain *d;
> +
>  	mutex_lock(&rdtgroup_mutex);
>  
>  	/*
> @@ -4039,11 +4065,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	 * per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d);
> +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
>  
>  	if (r->rid != RDT_RESOURCE_L3)
>  		goto done;
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))

Again, no need to obfuscate things, considering earlier if(), this
can be explicit in check for RDT_RESOURCE_L3, no?

> +		return;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	if (resctrl_is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> @@ -4126,12 +4156,17 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>  	return err;
>  }
>  
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> -	int err;
> +	struct rdt_mon_domain *d;
> +	int err = -EINVAL;
>  
>  	mutex_lock(&rdtgroup_mutex);
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +		goto out_unlock;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);

Similar here ... expecting the container_of() to require L3 resource
so the domain_header_is_valid() should be explicit for it. Making these
flows explicit makes the code much easier to understand.

>  	err = domain_setup_l3_mon_state(r, d);
>  	if (err)
>  		goto out_unlock;
> @@ -4152,7 +4187,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
>  	 * If resctrl is mounted, add per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		mkdir_mondata_subdir_allrdtgrp(r, d);
> +		mkdir_mondata_subdir_allrdtgrp(r, hdr);
>  
>  out_unlock:
>  	mutex_unlock(&rdtgroup_mutex);

Reinette
