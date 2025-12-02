Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE11DF74F
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692503; cv=fail; b=IqvFEVAHJzkVNwgo0cFqecMJ90Fk2OHfHvivfaqzUdGMs49KL1RghasKBMhIgtc0SdGPqvgS22kUavjdcvPm4U4uShFQaGC6IPpfDSlAXfjGMpeSHZ/2zh21nopTIO8PX7XBog1ItI4Nf3kwEAxI+CYnwsLbgEeKqx3hEMqMpJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692503; c=relaxed/simple;
	bh=FWsoKYMEVJn71o8yoDijHf+ONbJwOIn4bjhikwQD6gI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Da0UWuyBpVCoodeKYdOdnmWdYL1O2wqUydMy99g+bjxTEq5X0RKyUhxAqddk4OX3JeLlg/zjSMtU5yt0zwVU/XL1r8BDGbCGZ060gwmXiHh2jTT2CA5kzNwaVlfkn3XMqUBZB2UE1KGtyiWGUnSMWSftCIVwFORJr/B+cqxHR3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmiVVlZz; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmiVVlZz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764692501; x=1796228501;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FWsoKYMEVJn71o8yoDijHf+ONbJwOIn4bjhikwQD6gI=;
  b=cmiVVlZzTfZ8RaPQq+lzKp44W/t1Yz+L8dUhMfOZUR34FqriMdc6GDek
   oNga0xjUJIfkrmuosd0J7GaOgQhdDYutb6M4I6euSEEg2LcvH+9JyLWfw
   j9q2tp9lT8hO8dHjw1KMlzntsCBQPiBH9bEMalZfaAME2IfV4S5/RgtxA
   BcMie8ElN7mMhd7OIgj05BiLv4gw++c2KZPelgZxhgyhBIToxnIO1Rcr6
   U8tvtnomMrqrGOlDPWMn+n57eRoaTlwK8BoEumV7huvdyB82HORaxBPGc
   dXVQmMvw+6osupTvFhIidlk3J+ZXwWhrx49BM/s5I6I2C0MTKsoxErqb2
   A==;
X-CSE-ConnectionGUID: nI7F2d0zSnaxpLl2fQVsbg==
X-CSE-MsgGUID: t07drQPfRBy8ENmcDE3HYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="70516899"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="70516899"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:21:41 -0800
X-CSE-ConnectionGUID: CQa02alxT3Wu710wrfZUhg==
X-CSE-MsgGUID: yjfxwfg3RXKD58e7wGK/EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="194095149"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:21:41 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:21:40 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:21:40 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:21:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yXFLTns205JhajGbSYSo2M65FTAyZ2wfvQ1O8dxF0GqGfQKscLHUjZ2VnkofE2VdyUYER0AvoJGa64OHjTVWl98e0OY3xZ9lilE4q/TvQiuGUEhOLKmQOXmih+heq1xJqyP4W4iSU9YFma3npuZy2zLAJw22th7iL5XlAefTSubMFuK533Kh4EkS1nIRZajFCe+YQQni3NlLYDqiI6K3V0YHrkt9mcq5ZsYzdCw6QryUJDYw99K59hYb1hctzsupI3BNNHUHRhDO1Yz1dEEmvUaDE+ViPOnkjlTSPckr6er5+tdf5MiYxjnCHex3QZ+tNLUXWePDvrT9R5P527uGtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvjwjVvzjTwzMUbv1vTR5XcEesqgs4ajLU/LAtfH4ow=;
 b=x2vQf55/FPKSCNKKuirFaTFbQI8Etee923ZEVq7VJONwj12GejPIWsG9bABseH3gTFG9M+pl0j3zdyhOdIDMa+N578qRsBEe7XNH4/OS6KWiNEVnuGDtpxlrMu8kWcCgxKApNlWeqPOry7FUz9SlYeopT/GIDIm/Er+/JdPHrbZPOJUwnVTxR2U47LEJAI30KgtgVMk9gtM/joB5AbIC/dvzEHHm8QdPamWFQwfr9BkWWEdbEOxumULP7giJMyJoVnU6YWZc7wayAJtV2ARmxNbYwhb6KHXK/mQT+j3OURnBcVksLLmnJVEp7EcHD59H6TNa0eMx28g+4mBWpxiwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8081.namprd11.prod.outlook.com (2603:10b6:8:15c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:21:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:21:38 +0000
Message-ID: <8bfb14b6-5ffc-4d3e-85d1-7e6104f8ec8c@intel.com>
Date: Tue, 2 Dec 2025 08:21:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 20/32] x86/resctrl: Read telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 34ddc06c-b87b-46ea-7460-08de31bedeb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WVRwbG4xV3hMVlpmeUZ3SUtmNnkyQTFWbVFhbkxCd25sTVZ0aktiUzVja0Z0?=
 =?utf-8?B?emJXOXNnd09jL3dzSGYxRUtFUDIvM1hWaElUOVErcWZzbFYveGZVNFdLbUxm?=
 =?utf-8?B?RmxTYmtpU05qaTMxMEFWODJHK2doSWJFYkRtYnFjL2tJTE9vSGlRZ3h0aUkv?=
 =?utf-8?B?VnNXbU1tcDd4aFdNbVVMNnNoUXVod2tZYkdtOGZ4OURpbzI0OTJmQ0dJazdq?=
 =?utf-8?B?RGZXa3FSZlBvOHBJTlk5R0VIcE5KSDZzSGRqT3ZReXR2SEtoMCtnMUtwZ1Y1?=
 =?utf-8?B?T0xvY1Bxc2s3aFB5VVBPcVE3MGFFZCtTRFpCdGNFcml3Qy9rNkxFeFhPekZ2?=
 =?utf-8?B?VUw1RW5qNWQ5WnMwdklBSWp5WUdWd0RDaHJ2a3g3cVFHTnVpTWFWNVZJT3ps?=
 =?utf-8?B?Zi94dVd3bW9TZFdBenZjSFB4c0N6SHdtNEVSaWhOM0lWQlErSzJlNGFaRGtZ?=
 =?utf-8?B?SlZjSm5WT3VTY05tNHFwbkVrRjE0dFV1VmNFdW5PdGtsWktUWjhjZDZsWnlU?=
 =?utf-8?B?YlJjdWNzMkRqTnVrODRhRUQ1aFE1ZlBFZ1RkQUhvM3lUYTMxOVhCQytHcUdw?=
 =?utf-8?B?QXdDbURqbWJheE5BbUNEOVZJMGIwVEEzTWV3UUFvYUM1VmpwZEQ3SGRXcEhB?=
 =?utf-8?B?aklqbFRMY0tBNkpZVXA3NVhhdEdpdDlCa29QZmRBZG5VbTZXWjhkbEd0L0hv?=
 =?utf-8?B?eHk0SUpYUUY2OExyLys3QXhhbU9nTFhGcDVPcHQ1ZTdvUXlJSE10RmJWMG9w?=
 =?utf-8?B?SmM1K3FMOWozV2JIM2VlUzJTNmd2b2luUkRjb2k3WjZGeHVreGU2UVYwWHl6?=
 =?utf-8?B?d2hEbTNKVU1sMi85MEs1K0RpWW5KQzY5QWFSbkRmbFBhNUVpQzE5eHRJcEpo?=
 =?utf-8?B?Q3JzaVZXeXVjOTlyODlkYjltaW9VbTE2a3dlU2s1YXlVU3oxSVpoT0dDeDVJ?=
 =?utf-8?B?MktTeG94ckpWWUE5WWxUS0J6MEs1RCt0Y2dWSXJRK2xNMHdiOXJZb3BVQTAv?=
 =?utf-8?B?OWNnNENRd2EwdDRtdkYwRGtwb000UlVKcEROVm84NDVLb1NLeTNEcm1hb05I?=
 =?utf-8?B?YmZEU3FQamFQM1BhRXBHc00xMTNaK29sL3NWcklXdXZnQTZBbVJ3Zi9VT3Fo?=
 =?utf-8?B?MzduY3NpODFFQVB4bU1wYklzNFliVGtpTUlESEU1aEtiZmpOTUM2WFE4bVZC?=
 =?utf-8?B?bU9qYzB6WXloYnFUZG5USDNOZDJId2UxS2pwbS9yanhzcnhJdVphZ1EwVjhT?=
 =?utf-8?B?eW54L0k4L08zYTZTWHNHWVNmNFNOUE16LzJPem1vVmtYY1d6WFpjUFprWE5P?=
 =?utf-8?B?UGJlZmdZam1VOWNqQzRIQjlUNE1scURaWDc3Y1FrMUVDRHdzSWNaSzNsZWYw?=
 =?utf-8?B?WElxTWJVbWFobUphZncxQUZUMVVHRjU0TE5ocS96SHAzUXhHNFJ3NjBWNzFV?=
 =?utf-8?B?K3JlY08xVktXaEVGeFNUZUVDVElaNWtuMW5EQ0VyTkhNRDBReDduMjlvZU9N?=
 =?utf-8?B?bXhaMzFzZ3hweFFOdlh1L0pJdTBqRzMrQU1Bb0d5Sk9FODFIbFFMZzJZK1Jp?=
 =?utf-8?B?YmZBYlVFcGlFeFBRUlVtazdBOTJqLzV3QkgyVXZtcWY2bk1KakVCZmljaHNs?=
 =?utf-8?B?dkZldVBSa2hqT293aXEyRWFkZCthOEtLaDlpK2xXaVNERDJVZ1hDNkFncjVz?=
 =?utf-8?B?cmVGU2JsT0JYQ2VjclpCNTBvWU5FaHBYQzRnUDBKMGhnaVhBVXpwRmozUlNT?=
 =?utf-8?B?VnQ0UG5tS29oaUlTWXdLakl0T1crSkllQWZkbWN5SE1iK0ZtZEk4ZDJ5Z1dU?=
 =?utf-8?B?MGlodndUZitnQzY2K0dIRDl2Tjh1RTR1a0lrNGc1NmRWeVo3S0FvTkI1NWF4?=
 =?utf-8?B?QjFFWStqdzlYa1pCY2RFdHo1NXIrMVBoVVlsU1NMeVlxaTJZOWpDbkcyV1NQ?=
 =?utf-8?Q?cmTHMIU2FFpP5W0466+oh4BfL4TsABJQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzlmOUZjOElCZkJBVEVnZ3hiSjIvV2RrRnZWZHJEaVA5UW9admdTMTl6WGpG?=
 =?utf-8?B?MG5kSnltY1RZUUN1NWVid2NHWHExc0pPVzlKOEpHNGR1eFFZaVdaM0F5VmVU?=
 =?utf-8?B?aWNDTUdZUGZ3bjZ4dHVzTzhrUlE2dGkrdU11eXFTYjNtSzBqNjBvMUd6aVg4?=
 =?utf-8?B?a3llVmRNOHZacDBWdjN4cmNnd2p4OFEvd1krcURtYkRVR3l1bUl1Mml2SWhL?=
 =?utf-8?B?VkdkOHFQQWRUUGJmQ3lqOGhab3pRK2tNVXhWSEs5bmlJbE1UTGdmUzdQVTB1?=
 =?utf-8?B?clNpUEJUWDJZZFZDcGFiZ3lHSnpqWUhBOGppV3M5MkRDRlNCMmZLOUIwOXNB?=
 =?utf-8?B?SktpZFUrS0tqWXZxM1UyN0dGQ09vQW4xNWxEN3NScUtvTldiU2lwcUVneVdH?=
 =?utf-8?B?bnp0eEFCa0M3Ui9LQXVuRzUxQkJPRk1LQVV6K01OamFvTWQ2dXZENEtKSEU3?=
 =?utf-8?B?YjNodWN5b1JVdHJ6cGUxQklpY2U4SVJkamlIc244QmxPWUc2emZHaEI2SmlU?=
 =?utf-8?B?VlpZTVlXZWZhU1VVQ2lkSHZKY0hXRlpHM1I1azExRGJHV1hDK3lXdGxqcTFI?=
 =?utf-8?B?a1lFdFNzSkRBME9iakZ5NjQ3akN6c0t6dngySWRWb2ZZRFEwbXhCbmx1Tzk5?=
 =?utf-8?B?ZW0rMy8ybkFRTmRkZDBXVWpnWnZvTll4eUMrZGVOOTNJVGVRUHlTL0cwYXVU?=
 =?utf-8?B?amVhcjZGSDNMdXU4UFVqdWRjT3h1VkZYSkR0aVhPUFh0TFZFb3FmNUlycHRl?=
 =?utf-8?B?cVhiMnMrY2Npb1dkUm56cnI2dTJpWFJnRWg1MkdqUm5ka1RxL0tRdy9BVVpJ?=
 =?utf-8?B?bVc3aWNBUDNXVytya0wzMGpuM1crUW4xdFVkekZoQlVwOVVhZE9PazFzd0g2?=
 =?utf-8?B?TUd0WmE5VjY5S0t5YnlvTEd3WHpGeG9tUk1qeHRSQTFZQzlUWGswZlhUQkVR?=
 =?utf-8?B?KzZ0S1l6Smt5SzQ1M2lUVjh5Mk9PM2FlVGtBVlJoUHF3SFhRWFVueVJTSTM0?=
 =?utf-8?B?WWxaei80UDV1Z3pxUTNZajZ6OGJPd2JJVlh2LzBMSExUSnIvL0Zicnh5V0FL?=
 =?utf-8?B?MktlSXFWKzZFcGI3WVkvSXFPTFM1S1kvTlBtbVpaSWhtMmdGcnBTLzg1SUcz?=
 =?utf-8?B?R0h1dElNWVVJU2tRK3VnMktKazIxTTBhSE15RlowRldoNHA5aVIrMHRycDAz?=
 =?utf-8?B?TS92TGpoMHJsbjhza1pXdlpNVnYxSEVPZkdHa1g1OTBNNU9pK0ZqeStyTkdQ?=
 =?utf-8?B?RVgvencrRzJ5Uys5Ujd2bHcxWVlLTFFEbFVtN0FjMTZKbngyOGd0UDFhVzZp?=
 =?utf-8?B?dSt6ZFA3Ymo2RlJxRUVHMHlrOXE2SlhLR01qVitUTHRDYnljaTdFcUpZd3Rk?=
 =?utf-8?B?Tkc2UXhDeHBqUXZHcytEZDVoUmJiWWRlMXlZM1ovMnBuWGZLWS9ZMXNweDRs?=
 =?utf-8?B?Q0xjaUF1czVMd092Zy92TVZMUTFEbGhucHBzMEF0UlgwaUlwb0VPWXBSNXhJ?=
 =?utf-8?B?Q09nVjJpVEhTU2M2dk5Hck1QUFRtRmQvckNYYVNmbkNoVXNoNm0xMXh1bm1F?=
 =?utf-8?B?YjB4bFc2UE9RK2dQZ0VBakxFaVQ1TDlZN05vQUNHQTRaYU1sZm1RcnNPTGpD?=
 =?utf-8?B?UjN2MENuamNhOHU3L3UyUGhiRDZUaFVLZXZVOUw4N1pSY29yNHVMVXlEZUVI?=
 =?utf-8?B?aVpJZUJvZjVjU0llaVB0c3duc3NocFZQVjFwbllDaVh3VlZ2UDhmZEg0SGtC?=
 =?utf-8?B?djJoazlLekpweGtSWWZGSEgzWFowQUZxODVOUDdEU21KbnVRRGRSSWZrWENh?=
 =?utf-8?B?cjM2elFrUXQ0RVJNLzdKajRrMnJ0V1JZUk85Yk9UVnhDWUdJM3ZxTWpPa0Vt?=
 =?utf-8?B?amh0cC9oWkZTMUJkS1dKclhVNERzeEFNQTIwc0FaNTB6RG9IWWtweE05US9z?=
 =?utf-8?B?cXhPT2ZDWlNKa1Y0b0VKS2tNdkxVYVdZamVRWGlweTJoKzV0WjNtTnAxaTlt?=
 =?utf-8?B?d3NnVk50WWpsck1lVXpnSEswZi9PM0k5ZlY1ZysxZEZsdnlLTUw0djhTOXhW?=
 =?utf-8?B?R0Yvd0M5N0huaE9OM3JxK1AzVXZZOFg4R2FFZmxMbmR6TitDMldMTFk2RGlI?=
 =?utf-8?B?ZlJwSUJyQ2k0V0hndURvZWVCanBkUTZidEZzWk1hVUo1TzJPL1RqQjlLUlZw?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ddc06c-b87b-46ea-7460-08de31bedeb8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:21:38.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpStuO+OfoGbCKOYFjlL/a8DaiFYx+zEzZUf9ny8xURZs9fBuggndvISo0WRYtzIQQbuMsZG1ORGrXDNbjETHJLIWsMZqfzVRmD4zBcau2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8081
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> Introduce intel_aet_read_event() to read telemetry events for resource
> RDT_RESOURCE_PERF_PKG. There may be multiple aggregators tracking each package,
> so scan all of them and add up all counters. Aggregators may return an invalid
> data indication if they have received no records for a given RMID. User will
> see "Unavailable" if none of the aggregators on a package provide valid counts.
> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index b6b50650e634..bf3c70590d4c 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -12,13 +12,17 @@
>  #define pr_fmt(fmt)   "resctrl: " fmt
>  
>  #include <linux/array_size.h>
> +#include <linux/bits.h>
>  #include <linux/cleanup.h>
>  #include <linux/compiler_types.h>
> +#include <linux/container_of.h>
>  #include <linux/cpu.h>
>  #include <linux/err.h>
> +#include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
> +#include <linux/io.h>
>  #include <linux/overflow.h>
>  #include <linux/printk.h>
>  #include <linux/resctrl.h>
> @@ -221,3 +225,50 @@ void __exit intel_aet_exit(void)
>  		}
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain). If an aggregator hasn't received any data for a
> + * specific RMID, the MMIO read indicates that data is not valid.
> + * Return success if at least one aggregator has valid data.

unnecessary short lines

> + */
> +int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
> +{

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

