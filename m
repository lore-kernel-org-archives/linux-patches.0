Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C892207A26
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008211; cv=fail; b=suDtf/0KAL01y7n5+QNC+skkrmWyxhVNgQBnmtxyMlrsXf/+/evLtiGArTHEdgtStOhZYP05KLCkUCzbg7viPEpx8d5am6ZLwsVAzb2LyFctG324cehhEhxsnHuYCC+rjaaSuWkSuQMjYXg22Svuh6YFK2JMyu2+uVGv+fp0n0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008211; c=relaxed/simple;
	bh=KlQ0Z3jBTwqFi57TpdilVgjfUMJOBIvAmHzy8XaKnKY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j//GDr4fwCtk5PFJWfOkSCHeW8GdOss81mGJV1vTIlLFu5FgSndfVMK1MHPejIn71xqr+FNLYGX/3hshH1KpELlh1byUc+//xOpYgQYz8oVMY+G3HHb6L+tttQUHNuWvbBN9oRibgak2quhLvp9lkMS0yGPUDp5c1xOEl+j7olU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vct0w/8D; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vct0w/8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008210; x=1783544210;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KlQ0Z3jBTwqFi57TpdilVgjfUMJOBIvAmHzy8XaKnKY=;
  b=Vct0w/8Dn+ETbrUIksvCW329bf1Rxnjzvo5vHemF4KW+w4/P5eYshoeO
   Dyzk0HjE5OTGPq9jEkB1utlZsJq9Z9i6v8N/J+yvAhC0FQbIkyjcRxFZm
   YSS76hERT2iE7JYNCvfzDFDOtj8SDY+FsEXW+uKpSjaEdPene57PxavyR
   yuhObRGgrs2gHT4T/YW8R6fGOXRJ8kDdJMuDOkfI2BOQLA7sIQbp/Zgqa
   mHUWR+Y7oy8i05jX+5f0FlPU9X0IshX9UpNqNGTMYr4A2ZLZZtJdksotL
   84S9axsal4dNtpM+gYcVKE1fAUWzcjuRT6KenPf78xgV9cTgtFPrr9RWi
   A==;
X-CSE-ConnectionGUID: DAD8bHDITNStZleHRB0M6A==
X-CSE-MsgGUID: 7WeIHyEBSVecIFTSgNybyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57927552"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="57927552"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:56:49 -0700
X-CSE-ConnectionGUID: nx/dUkPMTSq1/vWbfjfXFw==
X-CSE-MsgGUID: AqnYt37MTXqIn2xgTMWtdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="192777702"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:56:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:56:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:56:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.82) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:56:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SZbXJoVgpl/nB7U/c//ZzYV1XkfKpWaPE4yPOMCAcF8XMV+io4a+jY2rzbXxMTZchioQsLMO8lQK/hgeJVIn1mzEqFU/0szJMULymsp7Yjxo+r3R0aDOEoOAs/VBL577ilNBCJrxnBOvu5Njb03n595gPOrkOiWwQ4joppApiX25WrJQsYRSsesHFlShFEQvYhFOtDKEmNElFXAXk4+q4rFRGuIhxnfVdGiJLhwJkyvvowF1PiKjBNDbq8w+858S3YO6GAeVgzHJpRUqpUuBYYR1urEcS7T/h3gb+I8xmyugn4b625EmMPiB7wILnacIk3NzaqZG3ZEkgR1KzjVjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTHYCkenlfGFnZYpnSSy+T5JPDsmob74PwENQbr/9CI=;
 b=HTVTD301ordaB+ioHDmZVXng33SVLzQE4Ld0Nj2Dq7duKojsy3J2QoU9QE89jHv+iwsra/UxAkAKqcOa6h3AxjPO/ihcc/E9U+5EPcC4vwfgW+Zx8vKbv0uvWMkYRBpg/C6aDvVGqWPAauZCCh22G6wHY/2vdfMWTkV8DQeQ2UoocYG3ZRNHInr9Uzfw2BuyibkQCJ+uab1jSwyZthpC+v0/8GvVpLDI0Sgc/4pw7b7qcAQHx9ScMCf/y9oT/mfZ0Oat8PtF9xUi1LUSKqj8bD0I7iotm76jjyYVqWr4aLwd6MtXVom0tOb81q+I1yeec2qgUMjTCLnNdNijS/KyMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4718.namprd11.prod.outlook.com (2603:10b6:806:98::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Tue, 8 Jul
 2025 20:56:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:56:46 +0000
Message-ID: <2af48f47-1b6e-4d7a-a5fc-7a37d57fbeb1@intel.com>
Date: Tue, 8 Jul 2025 13:56:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/30] x86/resctrl: Move L3 initialization out of
 domain_add_cpu_mon()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250626164941.106341-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:303:8d::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: 752da70f-8c25-41a8-ad75-08ddbe61f388
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZitjbkJwTDlhd2pNZE4xcmhhemJ2NXdVZHQ4eUNUbjFtK2ZkK0ZXc05jbkF0?=
 =?utf-8?B?cjZpVTh1cms0S0JNUjZLY3kxVndsOVBmazZ1WWRxSmxtOGR3TUpLb2dvN0VG?=
 =?utf-8?B?WXI5djZZcHdNM2trQ0JPMHlHZnRxdTVaRVNOckdIU1pTbCs4MFFJS1BVUy8r?=
 =?utf-8?B?NkJSYjJFK1RUU29CYVZ1WVp1cG5KbFpLRDczU1ZRUFIrVmhkZEx0YVVkdVRj?=
 =?utf-8?B?aGtQalpVa0psRjJsZDY3Vm56RmVUME03elpUSlEwZHRzT0lsMEJmZEpNanVh?=
 =?utf-8?B?bGJUcld0V1QvakhYZXVGNEE2SVF5N0gwSG5TdWMwNzhTRXJTRDU4TExZcUp2?=
 =?utf-8?B?SmVqTVZFUnNaVG05dndneGZSR3RpbmlwWFFaaU9aekZVN2FqMGdCMFgxRXBG?=
 =?utf-8?B?c3dLWXFGZVpoNUY5dXJrTjFPOW9zVHZrSDB1WUtKSkVNa0RCTHVmWmZPMDQ1?=
 =?utf-8?B?QXljcE92V3dUWFRwOU5vN1pQOFhzSnRMN0RnN3hGU3kzQUlldGVZdDF1OEc5?=
 =?utf-8?B?ZVNmUlFsZ1FZV0R0ZXIzQytzRTBjSGJPMHNhUzVlQTIycEVZM29XVlVFRFNm?=
 =?utf-8?B?SWRKUDhlRVJubWRMd1FFSk1YbVhHUDdFR2EvMC9PbmZRRFBWZWplc3FEUUpB?=
 =?utf-8?B?NEpMSms5ZVVOajBuTXZtWVEvRW1sM3FESEk0UFBYSVRXc1V2LzhYbTEvRlRl?=
 =?utf-8?B?QTEra0tLckpjS0J6RDRHMGd0Ym9sS044bGRjb1ExVm5LaWtVY0ZuMmM2VDQw?=
 =?utf-8?B?cVVoYXk0aFNoaHRFaDQ5d1cwekRJV2cvTEhUQWR6djQ4eEFxZXJNVndkK3Mz?=
 =?utf-8?B?MWdvM1ZBL0RmMW1Qc0dDWlYyWmZINE5tSEVRSWJkWlU2M3NsdURVZEpLLzk5?=
 =?utf-8?B?MjdnUXErWXg1VlVaSE5qWG9sMVF1Z2lOdTY4cElIekNoNWNmSlBpZTZ6TXdq?=
 =?utf-8?B?M3dTcUNxUmlRYUtUMjdBYU9nR2I1SG43aU56bWFWR3RjdVJqOEphL3FlN2xm?=
 =?utf-8?B?N2FoMDNHdStyRUFTaktQQ0RWZHZ2aUtUNDRwRHQ0QUlFVFV0dkIyY2pGdFRr?=
 =?utf-8?B?dzlVRjNlZldqakdqSllpc3h6M3FjK0RtWHJMZ1lTMzR2MFBhQWtiY21hN0ZZ?=
 =?utf-8?B?cjcvTDcwNnZsUlJsdUk5YnVhRWZqRkJha3F4a0FWWDN2Z1NiRFc4ZWxjMHNF?=
 =?utf-8?B?aUd5NTZlOUJiWHFTYytUcTNDeXhkd3hnZkMwVW1PbG92cWcwbzFvekhHN1k4?=
 =?utf-8?B?ZmtQK1BpcS9iZEduNWVmWUhTYUczNXFjWVhhMUpSNkJHUWI0c3c2SU9ZQTQx?=
 =?utf-8?B?b1NlUU5tcW1lVFRIdGVETmJNQUNqd2lRSEhyTzVTS0l5R2FmSXBkRlY0d21C?=
 =?utf-8?B?b1gvaTRBcVdZUUROaHZ6ZlNUdllZbS85aHREUXlnMUNKQk9LK3FMK2U0MllX?=
 =?utf-8?B?VUQyK3BhSXdpeFZmdTBrdk5HRkgwZnRwTUdmbHRRT3JFY2I2N2lXQ1FQSVNn?=
 =?utf-8?B?b0R1WGcyUHF0MDhIK3hmWVg2ZFY3aXhsWVlUWTFMNG9Jb3pvZWtuWlgyVTZk?=
 =?utf-8?B?YjR3VXZRU1hVVk5Gd0g4eUc3RXFwSGRiQVpmR3ErWnRkSnd5ZzNaMThvRVdK?=
 =?utf-8?B?WjZacTlZSlZXUFE3Y242ejJLTm9nN044aFR1S3A0NkFiV2lmS2dDTjNySU1w?=
 =?utf-8?B?Q0phRWhidkRrK2xpVEhzOGNZdUNqT2N1N3lzanJKQzQvOEd6MVJvenVjYWt6?=
 =?utf-8?B?T3BFSG56VlNnSG52aHRuaHVTaWhpbU11ZXBhQ2tRaGlwdmh1MjdKWmV2K0Jm?=
 =?utf-8?B?YTE5TGE4by9acW1EREc1eFp5RGYwaVJJL0pIaStNa3VwQmNPVkI0WFFYRjBJ?=
 =?utf-8?B?YVJEbndWY1NWSytROWxrNVlmKzA4U2JOLzZoU3FvSXpOcXpHOTZ4SExQRjlM?=
 =?utf-8?B?aCtuZXIrbHZURVhWQ0FNVGVyemxxZzZmNktQZVdTMzEvdll4TVR1V3dnK1Bw?=
 =?utf-8?B?S2V1djlJRWJRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cys5RmFlWTFRODl4S0ZBcWNZbkNCNW9wZTFGTmtJcGRnVUV3TUFzdlFxY1Fs?=
 =?utf-8?B?MmNKUE5rTnBIWkZpSEJpYXFIT2wxakNTWHFiNW1EUjBRRDJzdzB6V3VrSkJN?=
 =?utf-8?B?NjRSdDZ0MzBLRFgrZmZGZ29iMlVqZnJkMVJFUzJ3anJEczBZdkhId0xpT3Ey?=
 =?utf-8?B?NWFUWnBHSVRPUGF3ZXBJQi94eGZwY1F6eXZaYlByRGN1ZjZHYUFJcFZVZHVw?=
 =?utf-8?B?N0daaUVyWFY0Z3FZaUczWEU0ZWNxcko4K1IzVi9kSVpNTVhiMGUwWkRpNzJw?=
 =?utf-8?B?UzM5SDVTUnhocTlvZ1htRXNRb3haWWUyQXFpM1FQYWFmQkpWVkZyQlViQ1JV?=
 =?utf-8?B?TDFvc2hhdGs2QzBUbzE3RlI1VzFUYkhrdlo3THdtUWtlRXZieEMyM3E4UVJl?=
 =?utf-8?B?eVNkNE90RVZOY3o3czZnNkttVFcrS0habVF3V0pXTzF2U3FhR3QwalZRWlht?=
 =?utf-8?B?ZW52em14WGVMMUttbGltdFZUUGo5b0tYYnhNRFRZY2JrRWtFZFRtR0hkTVNy?=
 =?utf-8?B?RVNwZDc2T1FCN0J2QmFodjVjZlBvWW55S1IxN2h4RmRtVUYzL2VFclJGYWNj?=
 =?utf-8?B?aFhadWpqMktUVXgwOGVwY2ZseGd5ZFFsMzJweFQ2OGNzTXRCQ2g0T01RUFlz?=
 =?utf-8?B?cWNVNnRSeDhDbDlDQnExOUhDc2QyR2dRQ0ZQWm9DSkNqcCt4ZEduTDJheWxF?=
 =?utf-8?B?aTJpL1E2eEJVei9JU25HTzlucGJYOHFIVW11SkwycHovUTBEWHN1N3UzVUU0?=
 =?utf-8?B?RTJUWmk4RFpiMWxoMTNka1hYSGQ2eFpEeEYxbTFVODdSTHNxNkhsbThOeTRR?=
 =?utf-8?B?eHA4Q2lHSnhNd0dKZ290c2xKdll5eUsxZGxQTU91ZGZWZGFRUmdpV1BCOFFU?=
 =?utf-8?B?b2ZENEFwYjV6TlZLWmdaOG04TWd4d2tvb2t4R1I2cDhaVzNkQ3ZHbzdMTDZ0?=
 =?utf-8?B?TVhiTjR3NXJBMjQrMjNuWitzenphNWJlNi9TU2hiYzArNDQ5UXM5Z0E3WG5q?=
 =?utf-8?B?dXBYNS9OV1ZkWjFMbmU4dFAwYTdlbmVwNU5LQ01XNzh1aXk5NEFNOU5oVmc3?=
 =?utf-8?B?SGZBZzBNRlJRNmFHU3Q5RjZ1cC9nMHo0K0x6SkRTOG5tKzlTTjFqdWxjaDRE?=
 =?utf-8?B?SFFtZkZwcTJWeXdKeWVSempNdFJEdU5SbngyS2E3M2xTNWRIT04xZnNhWW90?=
 =?utf-8?B?OWgxWVRyQ0dqUnJTRFFJSExHZC9Sd3RzM2xONUVycTVoUDZ2dFA4V0E2YWRu?=
 =?utf-8?B?OEJQVitxV1NYNE1JZlUvSmQrS3VlZE5ZMk9vUGVQQWRIRjF6MERYb0Q5Tk9V?=
 =?utf-8?B?OEVrUWpwb3lDMWh1ZzdQZ3k1VVJhR1NjZERkQ25iOGVwNStVOHU0dDZDUEZ3?=
 =?utf-8?B?WTI5OXVGY3JHWm1KbGJzaTYxMWFxZXlGVFVKS1JwRzluS0dWR3JaYzljb0Vj?=
 =?utf-8?B?UllHclpyTm1DU3JxZE90UThVYlZ1UUoreXhlRkJWYWF2UUVjSEk2aGVZZ1ds?=
 =?utf-8?B?RjVicEJ1d2JORURtOTJyVDAzYmIvTndOazlOUTVwdzEwK1AvSCsrcGF3NzNC?=
 =?utf-8?B?dGF3NUV5MFlSY0lVaTd3SkU1VTl2aDVNUTNLVU5hSFI4Wlo1ZWxFalpqU3lu?=
 =?utf-8?B?M1UwODl1d2dQRG9XVHNXWFNnRDFSMDd0bTBwUkpFT1dKOU1NYlEzb244d0o5?=
 =?utf-8?B?RzhpeEJjcVFNNEZqQmwrV1ZvR3piSXhPYk1uZDFGdHc3Rk9hRnR6RkdiNmli?=
 =?utf-8?B?NG56TEZwZllXQTFKQVlvekZUTElBNjVvRDNYRnNEVndoYXAzeHZVTnZUYjFE?=
 =?utf-8?B?M0pMMFhiYXdFQXFCSks0RkZLclV1WTlWcFg1QnZHZC9VUTdFenpTUmU0ZzB4?=
 =?utf-8?B?RzJoMDl6M2VrV2lMNGZDOWpRZUFaT2YyU0FXckVBZHJYZWorRzk5aStkbGsv?=
 =?utf-8?B?WTU5TWJ3RDIwd3M4UW1XZHYxcGhjQ2pHeWlVVkpneGduTUI5SnFvTHQrbmhN?=
 =?utf-8?B?VjRXUTJQYWkzZTNLYUlnUEFNN1o0VHNEcTRSRmJqTk5HK2tRVk1ITTNYQ1V0?=
 =?utf-8?B?RDhLeUxrKzNxS1RsMkhDUEViS1dCZktxZ3lBcTVzSmVDL2RPcGhwSFk5TEtJ?=
 =?utf-8?B?VDhzZFRQREM3cmd4VldOeFlGMlJCUUg5L25vcWZxVUJOYjYxNWJlNU5PWTJO?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 752da70f-8c25-41a8-ad75-08ddbe61f388
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:56:46.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGh0H/q/+N534ajiwSKtgJXhsCgXlGaDugJt0YSEjLw3zLYiv4hT+GQH3WDSnWtTvVgY4w4t4EcJt4YC0bO/PWWMp3xqm+WIu1+Tz4CJXgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4718
X-OriginatorOrg: intel.com

Hi Tony,

I do not think the subject is accurate since this patch does not
actually move L3 initialization out of domain_add_cpu_mon().
L3 initialization is still done in domain_add_cpu_mon() but
instead of being open coded it is done in function called
by domain_add_cpu_mon(). Perhaps something like:
"x86/resctrl: Move L3 initialization into function"?


On 6/26/25 9:49 AM, Tony Luck wrote:
> To prepare for additional types of monitoring domains, move all the L3
> resource monitoring domain initialization out of domain_add_cpu_mon()
> and into a new helper function l3_mon_domain_setup() (name chosen
> as the partner of existing l3_mon_domain_free()).

Similar comment as with subject. Also please note that l3_mon_domain_free()
does not exist at this point in the series. How about something like below,
(please feel free to improve):

	To prepare for additional types of monitoring domains, move open coded
	L3 resource monitoring domain initialization from domain_add_cpu_mon()             
	into a new helper function l3_mon_domain_setup() called by                      
	domain_add_cpu_mon().

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette
