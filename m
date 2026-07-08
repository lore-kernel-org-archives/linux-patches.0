Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF552E03E4
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783550827; cv=fail; b=e/KKpcBgW3ah2dxmCDbzOjxchVnJx4KHKk1iy7p+q7OXhuqmQuFsK49zNW+MU4A8z0I8NWNquYdcc6VgS+XS2YSDD+2bwgCxeU1Q6jqhzPEAlEz15QiBD34uxU6/g+eaQ0RHVJ7SykDp8+musHm2Tg/BdWO19gDPX3JbEAaJb5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783550827; c=relaxed/simple;
	bh=IjbiSdKTDl5wxIIgk0iakljwcx0VDArEsJuHYSVvx9s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JM1fTGUulFVmkZPlrMbexUQWwOHP7piwVA8Qcy0J/Wjec9whb87Lj+ZlKfjx8zGdypx+wSusT0Tueo6jro8wDIrE0SfOAYdZOzbecd/XW9+2lWnHe8JV/VuDXt/wmudj5LNwyfz/3ARDirrwWPRGvs5L2rggKkgh5Msr8bDbdtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1i8saJ5; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1i8saJ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783550826; x=1815086826;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IjbiSdKTDl5wxIIgk0iakljwcx0VDArEsJuHYSVvx9s=;
  b=b1i8saJ5PWqDeBQC3ET6pwxiGb4w11PL1ryN6sL+FcJv3KpcSUO4ATok
   12jfRw4cQ9/1un2CU0tw8vDXAiO6ZzRDZoQb4DEm4yZrjL611DvzAzHCx
   OVvPG5ntyThYpZcmoNEl65pahSPr2vwgWmhDSARDIbsFwQcJ5itZ25B6E
   cld+Z7FPwR02guH+FizX4j+/BShjhMrnNj3ULbbG7q0xyDAq9Iabdk2AE
   YFMW/SdF/ce5nZErlY4ICtfqYqiKH5kNDpVAJgZBebfVPFOGitL8SINM0
   oQcLQkHT1JuugUHyYnGwGUzi5YIQHeCIsEQwjzNgbzH/zcFvL0I7e5DsY
   A==;
X-CSE-ConnectionGUID: pXme/dQuSAC0G5bfFNBKuA==
X-CSE-MsgGUID: 75ziWuOJQ0CbQRcQ1XR8Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95383679"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="95383679"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:46:50 -0700
X-CSE-ConnectionGUID: Gf1q9TNrTI+c9IDEpjGrgw==
X-CSE-MsgGUID: jIkxbU4sTNuD8tb8J+kXag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="256323730"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:46:50 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:46:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:46:49 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.56) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4Aj0t13sS9lbcOS/7sKt1TGsrRxMdL8mR1+PcSrMnf6/Pa75PvuspyOJtje7YpDHhrnXpe5KddBCW3uzlvHK0vZYB8SZKf+GT1wFUDswsczxqvO/lSStNv7T1pvsM0AbyaQmRGEyCw3KCKxW1zqqb7Pahqdj84XoVqpkmfUK7v2499ym5AGFf6ci+SmvnR2QehAk/fiJMggTiixCOTR2OFXC8I3DK0Bmrq8MttelePOypWf+dBfT/JFB1jh1dYQN91QIcFfU9QO0TTmi4Axej6LD8xFaSL4lghkuiwNEQrkJKwzpzXL/6aN+JoSQwNfJ/7zX24gEXsKU5WN6asGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLBKNA6nvPqkA+W/M5joxjBtXeZOkUa4nqi4dQzz+8c=;
 b=GJTcb/5CBcb8xYwCDFfspp8YiPFk2KEuukWA8m3SyEQgNc7ENcU2ZtTyYFonSSzm6pMCwFiUa3QvEAAjWaduK4vo/kg5F68/5jkJsAwy6lsTGwzYCnRPECMeq1KawFtGmfsXU3aJAF18oHa3qQZn7Qn0/IcpoTyWzhUItEH7eSuyTUkFJoEzJ4bAetyyChrgStRXmvItAL6Oy7YfH+b79KIVCKfMTG7jO3P8qswi8rYugVYFjHthQ+mecbN+H3LErhra5NfSl19wV26xPRd7swpWWp9qmm7AIosTaJEB1vFE+t10Dayo2oeO9JDuWIVwEU4npI2L/WeoU1a0eMcvQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV0PR11MB9864.namprd11.prod.outlook.com (2603:10b6:408:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 22:46:47 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:46:47 +0000
Message-ID: <a6a0d46d-1b2e-4e6a-85e9-e0efb9aad8b6@intel.com>
Date: Wed, 8 Jul 2026 15:46:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/12] x86/resctrl: Honor rdt=perf option to force
 enable AET perf events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260701213553.15222-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0301.namprd04.prod.outlook.com
 (2603:10b6:303:82::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV0PR11MB9864:EE_
X-MS-Office365-Filtering-Correlation-Id: e3bd33d4-1b0f-41f1-9387-08dedd42cab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|921020|22082099003|18002099003|6133799003|3023799007|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: P+czTq52oRwo186JIN9nIvf6rw6lU3uEnRFr0NBq/ViWzjivWlvclLuy+eklVXbCTIgp52iamqsksHWO4wuol/c9s7rFp3SxJg5AqnpV63pdLYJOfqKQU+LhG3hKmrZY2nzseZHcBBmgVrBlVNqlgyW6eA13UlsqbVk6/PPHZbVEX58686cPDoDi210+ShBvwzndVCJSimms60lus8R8HLwhfDxb7gI1p34KTu7ibZjamrOC0reIpChlBJAiuieOcQPf3zPgH93RRAtcqgqdtE/rftwOoePuLJq/bR2hRcFHssXh2b9oFlrXMcUjreHbZWpMwzCxIxeWU3mH7H67nNkeo4cQP1YEbBnnbdUCtz7A8U6RM/Z5T2tegfEFOhIOYEArRoJX7XyEdWJ19dTiKg7wRFPRe8ZcHN1cR330vjoyL7/Wza6PedgVEjsqNvA9aIA/Ai/gXk8uySFaROXBZ3x87T8am3WaZJAtcrD63u6mQEwrlFedk8w/IzeldXEBf03kXeouNOcvp5DeUK3uwFf4JvT2HSwCK2ehb/jpV7tWEOqjpHyC5ZVGKMcjda2/d7tQooCy351X40x4khBwTPjGjpPUfR/7PHVINNf36W4ElwKx7kSSOl/FJoMm41nU0tRYFXyl1yn7bSRTuDIdudLz1g+xDcKqzg5MY8MNitThNeQU/sRUOr6Ed9Vx9CZPPoFmci1Wi1ydrtvC2fxUPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(921020)(22082099003)(18002099003)(6133799003)(3023799007)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGF2UjlOSEVRWDNMdndGUmdZdFVCTzlUSk43cXpqV0VXL2RDT0J3TVJ5VUZR?=
 =?utf-8?B?c1pTTUk4bDhkMjBzellVZi9La0E3K2xRM0pFUzQ0Mi9LZ3RUQUZMeTNVMUY1?=
 =?utf-8?B?TjJPc3RabFpmeDB1Qk9nRjRiWDdMOUhicEFxVVNFdEwxRVRHSjQvQ1RUOGhP?=
 =?utf-8?B?RGNaSFVwU05XbEw0MlMrUm12UDFrL1BHdUN3SVM5djZhOEIrTjlOQjdtUjB3?=
 =?utf-8?B?Z1YxYVBkYUJMY3FJcVVjTUg5dHZrd3VqVFpWUjZ3RkZNQ3IvdGpLUGVtczNH?=
 =?utf-8?B?NkxoSFNWekliNzFXblJMSWY2NC9HMlNiV2E2dStvdER5WWMySHZESnFiaU9y?=
 =?utf-8?B?eTBuSmVQWHpVM1YyaGVpZFd0L0tvNFZSQnZVYXRLWm5NOU1YWSs0NEEyTUw2?=
 =?utf-8?B?dFhLeFk5cTNvVE5pRHZ1d3N6MjJONzBtMW1SZ1lFOUo2cUhPdlZ6c0ZBdE9J?=
 =?utf-8?B?Tkw0OTdoZjRNVmt3bk5ES3hTYmE0Yno0RE1EUXpQR2xyWm5iQ1pUbng4Z0xM?=
 =?utf-8?B?QUNTRUJVU0VEd0pYWlphN1VuYVhoaW5rWjRLbmJQZW8vL1ZJQlAzd0k0ZnJN?=
 =?utf-8?B?UHlLNHJxTkxZdHp3KzROUVhzOXZPVE1yRWpYT2MxNnNHMGRZcjNYNWJSMkR4?=
 =?utf-8?B?NE52dCttWEMxUnN5b1htYlkrblhHenJZOFRSUnhwSFdMdlQzbFhWV2o1Zjc0?=
 =?utf-8?B?YkxGUUFRNzVkVURQU0NESFF0RG9MVUszU1BFbXRnWGxyOUVHVEgwM3g2TitD?=
 =?utf-8?B?YUk0VHN2UHRYSzVUZnNHQXA3bHZYSFExUVhFQW5tWjZFb1BaZ2NhYkZnWUxl?=
 =?utf-8?B?MTBPbjc0VzRIRUhJOTZGT3NOc3ZySk5ObHhhOThtRWJlSkFZTTJMZThGaEdB?=
 =?utf-8?B?Y1lFWEpZUGVZNVBrQzdiMGZTS0Y1aTd6N1hKUXNGa1NTaTRFT2FGa2VVWnU2?=
 =?utf-8?B?OTJSYW5ieWtCUFZWQS9ETG9hWVpRNVVXcFdoWlA5RlVhaUkvZWV3VjJ2OG9o?=
 =?utf-8?B?THMzTHJMVG4rY0NSZE8rZVFxUm5hV2RPWjBLSFhMZjBmaEQzMmhLNTFHR1Ri?=
 =?utf-8?B?TDZrZ3hlTXU4eU5zTExja2pKajRvOGhEdUNzV3VOci9ZMklQcFY2NGxJT1gv?=
 =?utf-8?B?V2N6UHBDOFNpZ1BaQXREVjZ6V3lLSjRyQnpQeDh4azY4aG95eW43YjVqa1J6?=
 =?utf-8?B?OGpWc2tQZm9JMG1NdWUvdW82UGp5ekltcGZLMW9QTEduWjhyNWFRL1N5OGtT?=
 =?utf-8?B?VDV3UG5qUUd0UEZJRU9ZQmZxR2IzNnBTeUNTeDZZS3pjL1d1SHNIVkkzWVp3?=
 =?utf-8?B?MC90elJYZlB2cjNZTkRFVXhsRFdNNWowNWx4YTE4Sm92YnhubTNIcEkxamxo?=
 =?utf-8?B?L3J3SHdQaWM4c0ZIWnZCazgxL2JRS0hSSlBvNkVyWXd3UXJ0TUZ2bjFjTUJV?=
 =?utf-8?B?Nkx2ajNzdm1aM3cxdHk4Z0hmTW9seXgzcTkzajVjS3U3NVhiZ3NvV0Z4cDRP?=
 =?utf-8?B?dEorbVpDTWEvaDF4TW96cnhwTldSblh2YUNaTGtEYlBBRlQ2VDIvTTVBSWhR?=
 =?utf-8?B?UlJXYjk3UXRSTHVoUDkwdzlTdGdFZnJKMjJpcWRFQS9acE1SajBvWXYweUwy?=
 =?utf-8?B?U0kvUDRGNnFybkNBWURqcWVWSEt4bWk1dm9SSXhkRDNVYjRzOW1sTFkzZUo0?=
 =?utf-8?B?TU5WL0thTDQrdlpZcHhNWWRrL0dZdHQ2dUhZeHVDVVBDb09zWmtLMmcyZE1n?=
 =?utf-8?B?aUtkWFBQZEsya1g4U21Zank2YlZFUmlydHF0dEVuUk9ubzZwdk9iK1JEZ2Fv?=
 =?utf-8?B?RzIrWUwwNngwSDVjdXYwWHNRLzU1SVMyRzRGUGc0RU9ZZlZxSTN1enk0ckpK?=
 =?utf-8?B?MHJ1VkhaRVFsSkdLcXhjSTQrOTdnWEFWZXBxdk1QK0hhdS9uYTM3dlIwcXpJ?=
 =?utf-8?B?SUV3RDQvNnVpOE1jWStGTktESzd6aFhFNUFjMTBRSmNGb2tNWGlnNHpWZkp6?=
 =?utf-8?B?TUczVEIycDRtN2JHQ1Y0Si9pUTdHS2FkeDNRLzdSbUFrU2FaOEhwUnhmL2do?=
 =?utf-8?B?OVRIUGRBUU91TzNxYlc4bDZkWDdndFcrYmZhRWs2dUUxNjIwc0drYzhVVkZI?=
 =?utf-8?B?VUlQR0d2V1o4ZVMxenRyaUpMby9SM3gvbFBsR2hLV2lDVUdoK3hKMjg4c0Fn?=
 =?utf-8?B?ZGUzMEFCVi9KYzJ1ZzhNbURrNjhJcGJwTUFmR2poNUFRQk45cHlOQmxBZUZl?=
 =?utf-8?B?R3U1bkJ3emRiUEtZREFva2tOK3FZaWQ5S3VTQVIwY1UydXBFYktnak9KVjhY?=
 =?utf-8?B?MFJUMUVGNUpCaXFSb2lSZk1yS0VxWFpKNzNCWEhOY0Y3em01U0RFenhoY1p6?=
 =?utf-8?Q?j88/7QJKGyqgUlCY=3D?=
X-Exchange-RoutingPolicyChecked: h4Elc2vyKEraXBSEsU9zmH5jgXpVr6cXRQkBx7UsunNj8cQeAO6FyNXSIVIoP22GUxsbguaIJzpR43mQDTvTXIqqHn60VrqKocbMpyAfm1+4xQKub0MnXAhUMSKzD4MUdO2W8B8Pw7C5Rp7ftcxBbNmMylrucO0H456mT/ZqMELYZif5hyiPQbBEkXeXNxe0p1Ks3gOKulBG0l1WD8jyJ0gHqi1O9W2yvkN4y1BA2bZE93CvR+R1Nb9kJfJF0l4cJO0/deDwZ1Y7ulCayjib9lbbIOamY8CsyjkkvAVjAuBp5vBh4i0J2OH9Ty/ZzJnBwOKt+kr/cHLtPHMyu+ldWw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e3bd33d4-1b0f-41f1-9387-08dedd42cab8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:46:47.2873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1GRNpIsLmchuMtRCdDSLNkshMw6NB8Bb37emCEicP+w5KK9llpqhWNk1LKfCjXjmh+x5gDT6rsZM9eKQadgBLSN37ey0QBzokMOAauil3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB9864
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> The kernel command line option "rdt=" is used to force enable or disable
> individual resctrl features.
> 
> Linux only enumerates AET (Application Energy Telemetry) once on first
> mount. But that is going to change to enumerate on each mount to allow the
> pmt_telemetry driver to be configured as a module, and allow unloading when
> not in use.
> 
> The following scenario will be a problem:
> 
> 1) User mounts the resctrl file system.  all_regions_have_sufficient_rmid()
> notes that a perf telemetry region supports fewer RMIDs than expected for
> the event_group and sets e->force_off = true. But the user had specified
> "rdt=perf" on the kernel command line so perf events are enabled for
> this first mount.
> 
> 2) Resctrl file system is unmounted and later remounted.
> 
> 3) During this new mount cycle enable_events() sees that e->force_off is
> set and stops enumeration for this event group. So on this second, and
> all subsequent, mounts perf events are not enabled.
> 
> Fix by checking the state of e->force_on at the start of enable_events().

Above just writes in words what the patch does. Please reduce repeating code
segments in the changelog and replace with higher level descriptions to help understand
"why". 
I think a more detailed context will help with this. Consider, for example,
something like below (a suggestion to start, please do not copy&paste):
	resctrl can disable ("force_off") a feature supported by the platform if,       
	for example, there is an erratum related to the feature or, in the case of      
	AET (Application Energy Telemetry), when the event group has insufficient       
	RMIDs. The kernel command line option "rdt=" can be used to override            
	("force_on") when a feature is disabled in such case and also let the user      
	disable ("force_off") individual supported resctrl features if they are not     
	needed.                                

	Linux enumerates AET once on first mount and skips this enumeration if the
	associated event group is supported but disabled. Since AET is only enumerated
	once, this check is guaranteed to only consider disabling via the rdt= kernel
	parameter. However, when transitioning to enumerate AET on every mount, it is
	no longer correct to skip enumeration simply because an event group is marked
	as disabled. It is then possible for resctrl to have force-disabled the event
	group during an earlier enumeration due to insufficient RMIDs, which would
	improperly cause the kernel to ignore a user's explicit rdt= override on
	subsequent mounts.

	Ensure the user's command line choices take precedence over system-level limits.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c22c3cf5167d..cd8257c58f84 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -60,8 +60,8 @@ struct pmt_event {
>   *			data for all telemetry regions of type @pfname.
>   *			Valid if the system supports the event group,
>   *			NULL otherwise.
> - * @force_off:		True when "rdt" command line or architecture code disables
> - *			this event group due to insufficient RMIDs.
> + * @force_off:		True when "rdt" command line disables this event group
> + *			to avoid system limitations due to insufficient RMIDs.
>   * @force_on:		True when "rdt" command line overrides disable of this
>   *			event group.
>   * @guid:		Unique number per XML description file.

This is unexpected. The original comment is more accurate and I understood from 
https://lore.kernel.org/lkml/ainCnu4xmHbgh91r@agluck-desk3/ that you were not going to
make changes here.

> @@ -228,7 +228,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int skipped_events = 0;
>  
> -	if (e->force_off)
> +	if (e->force_off && !e->force_on)
>  		return false;
>  
>  	if (!group_has_usable_regions(e, p))

Reinette
