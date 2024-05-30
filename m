Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E5C158A06
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100502; cv=fail; b=CrPHfapVC2/QXwZ5faJGV8gRGMkPI3XyV4OJOmUAIE3lCZsYMB12S/xweYc//IXf4hEdxk6nUOYuVA74erthCMX2jYVRrVQQYTczKT+sNDhqO5m/1CsZeT4dpF31LFGYkWp5DNbUMP37y8rMiz75M15OBby0OnNy+4s7q6v/gNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100502; c=relaxed/simple;
	bh=bOwIILd+RgMcshYOjPzS98ar17OxI9fxVqjmk9yK8EM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u+juK6I8k81FwJNHFbnVLdXlr/+Z9cLcWklwvknulHbrcRBEaR5E5UKO2vKCNwqFDc4teP9KGLXAZ4iRfb96Ik24y9XChLfmZTWZ75FGPJlOwPCW/MW/KjZA4c4PXel3kLNFFcAT+tP3y2ZWAWZ+hgK+doKfku0LY/J8lsIKXms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IhjeVwCr; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IhjeVwCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100501; x=1748636501;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bOwIILd+RgMcshYOjPzS98ar17OxI9fxVqjmk9yK8EM=;
  b=IhjeVwCrPor0Kwf/vu01xi8zUgxYsZR94guDFQVfE/gNuZSdM/rQTtcm
   i8P3aZil+Oa0pcoIXbfWB2kNzYVk5j6cTI7p3bxIuF6r7UuTb0vm7aCcK
   t6whLIGPsI9Dw6+3ZSbYLZ/IkVhQBIduLJ4kQtCcopA4i0/yBFNZKTXqP
   mYTPaTTDRwhf3T4TqfInRfRCFXMuVeVcCtwkY3buQSfjVOPIFz+VMDAIv
   YmG4qDw0gYzvd1gm1wNAr6MokgFMIP++6wPr00WtS9YdRgmc2dkc4D1SY
   WKp911ETjOBSYoTuOwPadc72Rv0vqBB52CSjssB0Ac71Fzn5ge1SkS9ZW
   A==;
X-CSE-ConnectionGUID: V183V1saQtir8FBj1W6pIg==
X-CSE-MsgGUID: 3YJnDzs0SzCOrn0sOmANSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17450292"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="17450292"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:21:40 -0700
X-CSE-ConnectionGUID: pFkR/AY+QLeACSJEFhb7lg==
X-CSE-MsgGUID: R26xPbF4RS2LIR7alRJu7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="59113166"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:21:39 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:21:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:21:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ob/ksQwrPRv0W0Ynpl92pekWFn0zt08UTyd95LpBHaJgI6c3x2ah8pkqvzNGm2gP0T7K7S2NiokAq407yIOimS/RvjOP/sgYSsItCSL1SQ9Vu1+m1I7SJQZQhh5bj1hYDoWoI5oF/bUFze80oAdH4fexTA3uHRDwMxX7QXxNek67S4Z+QfMMUNbBB5rRD+A7NSfcCY7iY/JMyqQq1zt00ty29jyOqCWA6MWpMdELiBMiXRI4KZc7RpvfH1WZjdYddtAcHweiz09DGx31Uurm5yB3KD1iVdVAmMTSD8Q46WW4H0PntMRRnjRm2gjH7Sf8+PfkKnlJmGf9KCZhxRbpmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQ8rk6p4dXubEG5UtoI8j6uBlf5Q5V7WeGrf43bnFxA=;
 b=QKsI/v/bvBYu2vjfHLxjASa8qLz7/DLPmnT4ig6op57txGGchF/q7Js+ZXym2Z1D93njjtC33ZtHM2aciMeXOdAVe6EwMmqe6W5/NeeZ33ftrlQNAkHRqpvke2F6Zf6nowV4xWBc3Q6cHaIJudDka/tYUDF3xSKC4AVynI0FcnuVgdSUXRHutPMv4j3pW5EakIQH/4AO+tG9Uy2kBdJAA5bT9FwGb3Tqj37EatfOYWfJJLUU+NzI8rAqeX3tH+1c9+fUweSZ83nH122NTVFiz1AwFhrR+SjqzuzL0Vf2+oOdUAVPOx0ss3KgqiyV02cLzkUXP6oYrUNKe9bigsO+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6453.namprd11.prod.outlook.com (2603:10b6:8:b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 20:21:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:21:37 +0000
Message-ID: <b53645d0-2061-43ec-8524-d60c090b896b@intel.com>
Date: Thu, 30 May 2024 13:21:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 09/20] x86/resctrl: Add new fields to struct rmid_read
 for summation of domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:303:b4::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6453:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c631a2-2810-44ab-7df4-08dc80e61b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NE1DUjZoTmJiZit5UUgrSmxTTFlFQ0Qxd3ZBRWhkNlZDRzV4YXpYUjIyWmcy?=
 =?utf-8?B?SmRMS1I3SEhnKzRxY2h3T0xTdndoQzNvNm1BbE9kZ3QzRG5PUUwvekxYMW9s?=
 =?utf-8?B?T0ZuUThBTm1TMVJjcVRJeE13TFF1WnRaR25pck43NmhZb1NFYnFWTlY3elBG?=
 =?utf-8?B?cnVlNE0vRCsvK3U2VDBhcmJPME9iM01GajA1VDAyQ3h2alFVaUFvMU8zQm0x?=
 =?utf-8?B?U0lWUGRRZUJaWW9jM1hlcmZJT2dwQWlKSkJ0V2d2QldTdThhdzFXOXhZc2Za?=
 =?utf-8?B?aFkwK1QrTnpBWEZwMk1zK1Q2c2QzdG1OY0k4MWFZaXR1NWV5OFUwVUZhY0Qy?=
 =?utf-8?B?a2lETWxOaFdscHRBNkhHMm1wK1UvaFdpeERCNVlsNk4xTlRZNEUvMTZkRWpy?=
 =?utf-8?B?T29KR3RTVFpyR09WMmY4WE5kbEdsNGE5bHp6eDF3NFlWblZTei9XV1ZpM0xD?=
 =?utf-8?B?L3NRdkd1RjZUSXpFcHRxQTdiU0hGZTQrVW9Bc3pTSlpYT2o1bnQ4K3ZZV2tJ?=
 =?utf-8?B?Wm1wc1JNWE9NNFVzTHVhdnB1ejZveTYyVitycWkzQUV0ejBLdXlFUk1rYXZB?=
 =?utf-8?B?SkpaRlVQaDFGOFplU2lwLzQrL1dGMlFjQmhsTXJ1Q0Z5by94UEdzcWZKcXdz?=
 =?utf-8?B?bXA1bXJUY1p4TnJHOXVTbjBLVitBVk1vWlpjS1BaWHdXMFhxMFY1OVQzTDA2?=
 =?utf-8?B?WXBtUTlOTlNYL2d4YzlKVzZOZGZXRUFzVGJWSWFMcHpYbXNMZmpTUUlLeS9j?=
 =?utf-8?B?VWh1YTQ2OG9razNGU2tBeHJhS3ROM3FzU0d0U2xPZ2w3L0FLa2dOUk1RL3A0?=
 =?utf-8?B?alhuS2U4R0pnait2K1Qya1EvdkE4cmtDTU1JZjRoUXZhN29JOGJDZ2xuWTY3?=
 =?utf-8?B?eUM2cVkyQmRTNDQyRDlPbUh2UXVXcXcrT3YwcVJPTU9Wc25iWEkyZ2k4WnNu?=
 =?utf-8?B?ajBQTTcvTHRLUVVlKzZiTXFZVFVZVk45M2lxYVd6V3pXWlJXYWJ2TFdaT2lV?=
 =?utf-8?B?YlpZa09NaWZ1WUNFZWNNRi83Ym02bVBkaHk3VDhTb0VhbmEyYXNNdkpnbWIx?=
 =?utf-8?B?U2pXaHFCaFBiR1BURTZsOStUaHIrY3JuVHhNdTd5UGFIQXJzKzFiT2x1VnNh?=
 =?utf-8?B?V0djK0hpZGF4MEw0dElOVlM2RWRLeWRtSGxaT0xRNHQ5MVRQWjFXOW1ialk5?=
 =?utf-8?B?a0h6RUxJS0pUUjNHUTl1WjdOMlcxQnJVR1FoMXo0QlB4aXlFSldneUg4aHRD?=
 =?utf-8?B?Q3gyRWRBNXJvUDVzNURDL3hLYTNEemE3U0JZTmJxRHQwQ3lzODNTNWFsQ1hF?=
 =?utf-8?B?ZnBEQmxYRjdQb2VnL05EaTUzd2JvUWJWOGJrbHFodnBQVm4rTDZSN1k2NG1s?=
 =?utf-8?B?dVZGQUxwRlhnNjExOUZsR0oyZ3hjLzJib3hJb2ZyemlXZEtYUmRBTW1VRDQ0?=
 =?utf-8?B?dXJodTE2YkVpL0ZvUnhxZXk2RkdraTZiektadzlpY21ESytOSUZ4bGJnSWQw?=
 =?utf-8?B?Rk5WL0htVWpsdWlFdml5M2g0aG9HQzJpamdUR2x2WTlrZ3d2KytPbUpzMDYy?=
 =?utf-8?B?WGhUSGVya0VoUzNwaWRyczVGSi8vL0JxN1ZBdVZEOEhaeHNIRDN3dFJpbTlV?=
 =?utf-8?B?T1BaNVlaNWtBcXJFUEZLZUZCeXpYL2c5OFVlZlRiaEJHQzhZT2gxWmFSZmth?=
 =?utf-8?B?bkozNDg4VFFwQk9sY01tZnkrd3BrSitnWlNKRGpNem1iVkRhTzVndnB3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzlDL002K2drVlUzdjVSRVQvVXNJa0ZUR3BFTThRMTFITC9jUXJUS090T2M4?=
 =?utf-8?B?NUpwbmF6Z0J3amRTR2R4UjB1RHBOMkNENTNvcm1VS3NYSWJkNDRIbzg3QnNs?=
 =?utf-8?B?bTdkNzlLN0xLV0M0cDllWUE5MFBMR05SNS92T2w3TTNJd2R6SGozZmJsczBQ?=
 =?utf-8?B?NXMraWMyamhLZDRKdXNzWGxEYVJxTzhwbmxrODR3eWRqdXZHSFZEWC9GajNm?=
 =?utf-8?B?K1pmMlJGSFNVWDFpQll2Tk4zdVFhcmJLYUJoaEtuMjM5MnM4T0MrT2lXVGEv?=
 =?utf-8?B?ZElTanlhQWhUM0VYNDFpMnNWdTNtWHQzYjFYeFJCVTQ4M1FzWDhLOXNJNzdO?=
 =?utf-8?B?dVMyNzIxeEpiakxJTHkxSk5MWmV5UW9WamJYVzJVQ3lGMmVZQVZ6VUlKMGpa?=
 =?utf-8?B?Q1graDJSSWI1THIzU1EzVGZZZWh1Mi95SmExRkJ6b25Tc0dZM3JwcGZKcHpJ?=
 =?utf-8?B?ZDRWRkV5MEI4M05wL08zdjg3aUNmZjhhV3dzYXFXK1J3cEpLQUJEeTR0aUFt?=
 =?utf-8?B?cURoWUF6MWc1eTJvWG9CZUIxUVhSMU1SWm9rU2hOVkYwZmxEcWthSnZaNEtD?=
 =?utf-8?B?dSt2Nk15WDhmeU1sTThMek0zMjM3SGRvU1dpZ2NlSmFnUjNyMVp2a0VMa05s?=
 =?utf-8?B?dEVOWHVkaTBDRkNlakhBV054d0t3WnQzWldqUHh6d1Z6QUNqUzdaMkE2NTZS?=
 =?utf-8?B?b0xva3YwY3dKQmZDTldYbHc1NElEeW5sOWQzeXZzQTVPUStuWWs1bk5aWHZB?=
 =?utf-8?B?WjlyQ2RSN3hOd1AzWEJiTEpEWEY3N21zQVVtNm9IeWxWZ2Q2R0h5MHdCM240?=
 =?utf-8?B?RU5veUxMeVlwSnkxWUxsTExCWWdpSDZFVzRWZFNSSEF4SXJVKzgvZHR2TXJD?=
 =?utf-8?B?NWdJMC92MTQwOUFGMXJvWTVCWlQ0QlZCUDFHU285R01SWnpMTVV0T1YwY3NG?=
 =?utf-8?B?THpkdmt2bi8xellyT0ZPSU5uSkJqSGp6dk9kbmNNMS9rOHBBREI3Y01CMFYy?=
 =?utf-8?B?OG1NMTZ4UFNBbmcyNnFBdHNXakVZM29zbUhzcE1jV0VlV3lVaGJJbUtUWDd5?=
 =?utf-8?B?aTlFWFNzRGwxTUhJYWFRQmhLZ0xOY1hTcDRyRHVDMkVHZ082NTNrRmR3YXFx?=
 =?utf-8?B?Y0ZQTzM1TkNQanBHcHEvc3A0c1d6OHprL3VhSVJxKzBEczg4eExLZ3NhY3Nt?=
 =?utf-8?B?RUZlMGJtMmZ4aE5iek12aGVmT2hYdmZUenZYZGUwWEZKY2pTUkZaZTdwY2hY?=
 =?utf-8?B?QmNGL0NDRjFWYk5rbk4ydE5WNnVOelpXS3J5YzZKUGVSTm4zODZjMjRBeS9E?=
 =?utf-8?B?eW9IUm5pTllVaml1aHA0aCtkUTFFMVR1Z1hvNUtxbGpKcXJZYVNtNVBGdkFG?=
 =?utf-8?B?SXkzUDNQaWphbUoxcERianJ2QituMEhiV1p3bzhvZFh5MG9FUmx1MzY0cGJD?=
 =?utf-8?B?N250dDBxQVRIRkJiK2JKWTlMNjlKb2VrSGFWbXptMlUwbWpxL3VGU1dlN2xF?=
 =?utf-8?B?OXpVcGFoSEpvbzJSNmdtU2g5dmNNVExpdC9jdzZycDdrdlUxbkRZNWR1OUwy?=
 =?utf-8?B?V1Y5UlZqdjYzUXNuQjNEU0NHSWdFMXdwdUtXNmlaOE1vOGxCUW9tRit4RThI?=
 =?utf-8?B?YjREMXdLMDNBc3RMVHM5d0NTek9ON0VjTDNPL29QaFpxdUtvcUl0WDJ0N1N5?=
 =?utf-8?B?cVF4bHFnM0h0TzlFT0lhVFJFbSttY1dmcXByWnEvamQrVGxzSzZvY2xydmwy?=
 =?utf-8?B?T0lSOGlTZGoxZE50cDJhdUtjYzlKZkRxMFMveEFoaFZIbzZLcjhGYTFOc0xz?=
 =?utf-8?B?WTVBKzBUNm1DcEpNdkFyMWwxSGlnQjkvU2k1VEQxVXI3NWRNck1KU3lpZThC?=
 =?utf-8?B?cVBxK1IzMTBwaFduT1FiOXhrWUxWZjMyQWhBZndnM08yUFZDa2t2dWR3dmhU?=
 =?utf-8?B?VnpYakhXN3JwbHhNZ2NEMzdzSEQva0dBdHpHTkJtQ0xjTXplZm01bXRHd3Zh?=
 =?utf-8?B?d1hOUURsOTYyeFpGazQyMlc4MW83RzFCTFBtbzRXMS9veFRPTnRYMUIwbnZn?=
 =?utf-8?B?Q1IwSnAxN0tFSGFZV2Z5dlBEMUlRVlU0ZDYrT09nUmhycE9sRDlZblNZZWpH?=
 =?utf-8?B?azMvUE1NcHRzY0J5UTh2T25oM1NNUHozYUtzaG5ZUldTeXdHUUhrYUdkbTht?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c631a2-2810-44ab-7df4-08dc80e61b22
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:21:36.6876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzQojXfwQkRcW2DafeXTbqG4MUEon6fpx8AK8R8hDuSv6yZyCx5CiCWKwEeT0Fv048rR0le2i00DXc29j6l/RrSeuLIHwLGt3twbhJHyaCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6453
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:19 PM, Tony Luck wrote:
> rdtgroup_mondata_show() calls mon_event_read() which calls
> mon_event_count() which packages up all the required details into an

No, mon_event_read() does the "packaging".

> rmid_read structure passed across the smp_call*() infrastructure.
> 
> Legacy files reporting for a single domain pass that domain in the
> rmid_read structure. Files that need to sum multiple domains have
> meta data that provides the L3 cache ID for domains that must be
> summed.
> 
> Add the sumdomains and cacheinfo fields to the rmid_read structure.

This just describes the code and that can be seen from patch. Please
check all changelogs in series for this.

> 
> Add kerneldoc comments for the rmid_read structure.

Same.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index eb70d3136ced..d8156d22cbdc 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -145,12 +145,28 @@ union mon_data_bits {
>   	} u;
>   };
>   
> +/**
> + * struct rmid_read - Data passed across smp_call*() to read event count
> + * @rgrp:	Resctrl group (provides RMID value)

Provides much more than RMID so either make that accurate or drop the annotation.

> + * @r:		Resource
> + * @d:		Domain
> + * @evtid:	Which monitor event to read
> + * @first:	When true this just requests initialization of an MBM counter

Seems strange. Perhaps just "Initializes MBM counter when true."

> + * @sumdomains:	When false just return monitor count from domain @d. When true,
> + *		sum all domains in @r sharing L3 @ci.id
> + * @ci:		See @sumdomains
> + * @err:	Used to return error indication
> + * @val:	Used to return value of event counter
> + * @arch_mon_ctx: hardware monitor allocated for this read request (MPAM only)

Stay consistent with descriptions starting with upper case.

> + */
>   struct rmid_read {
>   	struct rdtgroup		*rgrp;
>   	struct rdt_resource	*r;
>   	struct rdt_mon_domain	*d;
>   	enum resctrl_event_id	evtid;
>   	bool			first;
> +	bool			sumdomains;
> +	struct cacheinfo	*ci;
>   	int			err;
>   	u64			val;
>   	void			*arch_mon_ctx;

Reinette
