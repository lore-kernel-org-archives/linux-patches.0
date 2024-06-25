Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4784D14AD20
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358237; cv=fail; b=Z5RwRxMbMU6tTDlGAZwOXFOH+gVIft9r8J5YRRuaK3bckoTNagpDs56qO+q+2utYwnlJhp5WD13QbI0a+NgJtg0GMPzZXaofdzWbj7zY1dX3vhCl31NL8LfM2AUwlGljLuFnuw1P2BZ9wjUMm2ZJVxXXlQrX21yRGjrsFkysa0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358237; c=relaxed/simple;
	bh=qQvAERwCz2OAOFL9+eCHIHM4P0MNOFe/LtVvUE0hfIU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nM4jbv6/QAzjLk0Nr0qkdzGryUF5X+Q4+LeetELEBAfgqA6dtlaHb/Z6+LfzsTFDI1x3x52FAvUs5o9M8vXyaW9ek18R6v1YCKBnB43lzoNUHnR44muUITvJCBzThEWV1lnAW6dFX6Qzjyb8TxY8xasO+Ub3RYCBBM/ka3kERTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fP8zJi9M; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fP8zJi9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358236; x=1750894236;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qQvAERwCz2OAOFL9+eCHIHM4P0MNOFe/LtVvUE0hfIU=;
  b=fP8zJi9MhZ4Zvio2rwDsPrex5DdKUhyvmuIKViN8cxyCFqI2bKLRkReg
   S4hMg27XP2lw3DazdiLkyixvUkuSFoJAuMatwYSX4TPyYoqEirqlbCyT9
   JRxE1HMqXaTiULcNxsmdV0pTIUuu6V5tt4jqur93A/Z8uwHfimqgmt2tb
   6HQy7D7+t/UqJ1zbmO/bsozS+nsHOcKPqOCw0gzzLkGfJqgO9fEdjrnRz
   BDsZzBylIdTHXDX4RgGz0guNEclDqYdDuA1y+UP15kOqyvnfhqVpmH4lm
   ZDHL718TsHNn0H6lPAZ7OzohL4ZQRlD9c1D3IryLdcbG1kBk6NyaAAO3o
   g==;
X-CSE-ConnectionGUID: SEH4AOsbTiiF/wi0Fw1iAw==
X-CSE-MsgGUID: tRS0aQwJTYiG2vIND5fP0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="27810871"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="27810871"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:30:36 -0700
X-CSE-ConnectionGUID: Zdbwib11SGOmdJaVKLp9Bw==
X-CSE-MsgGUID: t9hug5H5SOakmlZVNV3v7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="81346124"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:30:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:30:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:30:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:30:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOjD7t22rAGxeX9nQboj+kDiyN+W4VYqtEZuVt/VWWYckazjbf6IAo47ozoJLKzenUPVAgAgjBYLd+wW3vDppvJEwpHDkD3Bixcud0Uyw5XxPJLeq3cFTjLFPHgyO85IqAY1EEF6/QZp1ehfbTTpjwgxkS+ps26ndJI/341DhA0GxqCgtKFYJkvThvfauc2xp8TzeLyjNPbufpm0P7gAA47uYLUqxEQS1xieI++Pgx94SmU33FMY/irZ8R3Sh8JyxU1Uu+7DZ+oBsA/c3YT5c6c7e30RIg/3n/cQ8vwnu8BiyyTHdnecF3Lvfavt+Uktr6O3dMWMKvw3bPmk2LhEkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0RHT754T6qGUAL67EUnPGFd0Kf645yxuQfFuDIOM3g=;
 b=nABCPcncGNGbv+kPAwRlsKBuhrXSuyIDoHOYD9GHui3ZWvoYSvEFZMTYNX3NpOoe5b9f4n2082+0Mnc7q2YWRhZj8CpkknoLA4WabvTMRVwju8rRi5txvdAoxYkskLUTgClmF+50rnCcbRbVY8LsQqenveQuXojB/QDFBDhPGDHIlTItgGrBU4tGlcJaR6JM5Vy1FSlM+nqBZKWD+HFr1spPlc4oKFpkUrwyEi168mRA6tddyFG9RFhvSgO1NV17HMO/TnKoG3UJHvYq27XIZ7yhRoNugBsCfdtQmKRnoFAwVQfJI8SRluhTjfoh07kCH8hORsTG8iqkFM+XSL070g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:30:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:30:26 +0000
Message-ID: <2607272c-f160-4c45-bdec-e325b438420c@intel.com>
Date: Tue, 25 Jun 2024 16:30:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 12/18] x86/resctrl: Create Sub-NUMA Cluster (SNC)
 monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-13-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240621223859.43471-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0261.namprd03.prod.outlook.com
 (2603:10b6:303:b4::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: fd0438e7-ba2f-41dc-eb49-08dc956ecad0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3laK3A3QjYrcEFtMXpIWG1uU2xVeW1RcmVyc3pZMW03R1JYL2NwQVNiWVpK?=
 =?utf-8?B?a0dtbFlMb2VHOWcwbHR2bWlSemtDMDZqdDQrNTRGOUdCcG1ScGhBNDVMVno5?=
 =?utf-8?B?a0E3NkNHSjhvbCtrY21ob08yMjl5TllJYSthdUlZK1FaS2gwMGlDMFNVUnlO?=
 =?utf-8?B?Z3Y2RTA2RTVjRGxsdVRJdnNwbmF2bktKMm43SnNZYU83N255aDI5ZkRqamdY?=
 =?utf-8?B?M1BId3dRZlJFQitQNGFiVitSS2ptdldjR0d5NjA5OElzWUtwcnBJMXo0anRJ?=
 =?utf-8?B?WWlwcGpCTWxrTmEvOEhaWk1BSTdiQi9BdWQ1WmEwdHp6L3hjdFBlS1NJT3Fv?=
 =?utf-8?B?d2R2Z1hLM3RaSUxwMHk1M0RiU3puQkRDa2NrK0pSVjNZdWNsaVlQSkpKOEJa?=
 =?utf-8?B?NCsySFFVeDNQSVMxQ3EyWXY4aVo3azF5M2JoNllqWExUZEJSMHNCOW1lRmcr?=
 =?utf-8?B?M2p2VWN3c1JMOUx5TTc2RTNlRVJXY2svUTJrT0VpaHFBenk0MzlGRnFYTG9F?=
 =?utf-8?B?eW9Wa1JuaG9nT0V6K28wRDZtM0huZnBnR29RM1VQK2U2S0xnWFVFcjYwdWRV?=
 =?utf-8?B?dGVOa0tHdmhIQ0hualJyYUREejBzRnVjRCtzOWVqUUhzNkdTL2s4Zis3NkQr?=
 =?utf-8?B?eFo3b1FyWjVtMFY2TjFZV3pUb1Rmc2tlUDlsdCtSQnF2S3JyeGorMkZ4UmQr?=
 =?utf-8?B?S3haWWx3N295WUU0Yk13RFhXN0VqSWhUY2dSb2FYKzArbkZyMEFsSGt6bGpK?=
 =?utf-8?B?NHZIVmhjTWk1VXprRjRnYzFtUC96ekN6c0VPZkRTQm9SQndHaEZPbGpSelcv?=
 =?utf-8?B?U3ZJUHQxdjJWUUpYaDNyN1JCWUNvNFlEZ0dDZ3VaMXl0bjlTUndzK3V0WEJZ?=
 =?utf-8?B?b3pYWWQ0YXYvaEhGRHFQMjN3S1B5OWw4eEVCMlBuRkJNNVVjd2lrSDFmemor?=
 =?utf-8?B?S3BTek9Oc2p2RHhMZUs5N0k3Y2Z5Q29YWUk1ckF2YklicGxLeEoxL05QUVdQ?=
 =?utf-8?B?QlNGYjFQRi9aM0t6aFBYRElTMHU0YjkyTlg4QUdPZkF6eHIwRWJkeVI2VC9y?=
 =?utf-8?B?Z0ZlQ2tFQXAvRWVXMkRpcE15eVlEZlIzNFByRkl2ekJ2MXBoWUVEUjJCbHBp?=
 =?utf-8?B?SSt0eEYvZ2RoY3RjcmttMmd4K05sdys4L2E3YWxOd3BiWlZobGtleHpsV0Vo?=
 =?utf-8?B?M0l6c0dncWs5cWpzZ0lVaTlZQ1VnN0g2SU02MUtBSW9mOEkySEJWRGZ5REFB?=
 =?utf-8?B?aHFyRkRqOGwwbHllbWFkQTRBTVphaVA4S3JuUlp5WXQ2RGhKVG9yZnFyREk2?=
 =?utf-8?B?VmpEUm9PM3hvN21FZkI1WWllNGdxY2UxS3l6L2dZTDc0RlMrREtERi9BNkFL?=
 =?utf-8?B?a09JK2tJSjNKMG1LWnFKN2VhdlkyK3RtbG0xUjN0WjgxK0lmd3doOW1VR3Nq?=
 =?utf-8?B?OHF2SFUwbmJtalhOa1E2NVNDKzNmanpPc0xkUkgyYWZlWW93V0xOcXE4bW1Q?=
 =?utf-8?B?NWwwLzl5aFdtUGRwNk9CNmc5cXQwbVBtYmw5ejZxZWdNT3RwL1dER1EwbCt5?=
 =?utf-8?B?M3YzSTd0VU9QQWdxNllEK3pDdFU5a1RJQjl3U3hBVW9PUkJaeXFRcGQzVlM1?=
 =?utf-8?B?ZG1IeERCZHNYQTVDN0p5VysyeXl3TUFOMFZHb3RmUXd0c3FTd1BxdHJYa2Q2?=
 =?utf-8?B?Q2p2d1pZMXY3MGk2bk1sV3YwVitxOHJJZEVzVDFxNTl2VW1XVC9Bbi82Yys0?=
 =?utf-8?B?b0xsdWY5Y0ovM3AxK3EwRjBvYWRCd0h1eEJ1ekRMcFJRY0VjeGx1bG12amNS?=
 =?utf-8?B?Q3FGVDBEL2twSk5WWVpvZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG5reEpCZjdZeUhHeFdlN0RIZ25HWkhhd282YjhjZVhHV1pPZlZ3ZDJpQkxH?=
 =?utf-8?B?RFR1Y0RhZDVrWURpTEZvdDVGd0k5NTRJeEp1eWVmbi95Rk5mejJuUUdnZkxs?=
 =?utf-8?B?M09TRXkvK1o0T0RkT2IyTlZnVDZVenBxbmsySEh0dXRjNFp1eEV3Z2NlQVE5?=
 =?utf-8?B?MzRPeVZId2N4UnNEVzV6V1k4SHNlTkpUVE5kbEYrdnpBVjNGWG5odzVlQ0or?=
 =?utf-8?B?U2RxN0QrMFMvZjdsQk42YURlTEI2bkZrYjlRNExkdTVLODYxMkNCeDZJeXQr?=
 =?utf-8?B?V0s2OHNjVkZVanZOZFVqVzdWdHllK0hGa3VMYk56VE9tV1pmQ0FMNlVaZGhz?=
 =?utf-8?B?SEJBakRVbG4vS2hkYVJyaWluTGRWQXVTOEJ0Ty9TTit0L3l5UFVzcGQvbVNj?=
 =?utf-8?B?c3FpTXdKVEN4RU9Ed1BQS3dFOFo0a0M2amdaemxpYjdLNnBsRElUQnNKVVo2?=
 =?utf-8?B?OVRkUlNTTitUdWh2RVZqeUVkQ282bnJqOEFOZ1VVRFNtQWk4UVROeWdEeHFI?=
 =?utf-8?B?Nnc5N2dWajNjeHdzUGR6NmJzQ3lneEdnSzc0eS9iamx5QnJPVy8zUG1seTBK?=
 =?utf-8?B?bkNVb0FvNGtMOTlqcVkzQWZXLzVXZlRidzgrOFJtRDdrVVppNFZyZE96TG02?=
 =?utf-8?B?TDhmdUpTTmZUYXNLVnVDdWlVTWF3U3NTT3daZ2xUaENzZmpGSFljZGRWd2dK?=
 =?utf-8?B?WmxYOTVkTU9yVXpzTXZHdGZGSmhuNDhtMmUva3kzM2pJUmZlVTNodWlNaUVZ?=
 =?utf-8?B?UVVlU2xnSnNRS2d0ZzRmMmVQQ0kxNDZhQUVrd1hucnZmRzlCdHN3dURiVjVy?=
 =?utf-8?B?cEJLZnQ1R0lqQ3dCUk5PWXBHMzhoZ2l4bzZCTkdzSk9VakdxdTJ1dHFFbVhT?=
 =?utf-8?B?M2hjcEZzQ3NZWjR2WktkNXVCcnBzRStaRVJTYXA4UGR4a3hwdXJCV1phblJz?=
 =?utf-8?B?YWh1dEdIditZVVo0b3gzbVVSMGhkR1p3YWVwbm9uR0ZkejRYUGRTL2gycGFn?=
 =?utf-8?B?N2lta0tnTXBmMG5QTitzeHNDKzloMWNSZ21uSi8wNW9GWHE1K1RTODUzZjJO?=
 =?utf-8?B?ck9zYkJ6MWticldtY3U1V2QwZWN4Wk9TTDBJOWR4dnN6SmVpbzFXaXE0TkR4?=
 =?utf-8?B?b3Zpd21QZngxb1B1ancrdUFsbHBEZW1tUmdQTlRsVzNteHZ6ZWd2b0NGWUpi?=
 =?utf-8?B?SDhoMWdUQjRoWitnWHdmZ2s0anlhSTNSTXBPMzMyejdyanlQcGZMMjA5MU4y?=
 =?utf-8?B?SWxuWEMxZ3E0SVlLNUdrTmNWZ2RwYVN3V0hhd1VndHNJdXJjc2hnZk85RUd2?=
 =?utf-8?B?ZVpValNRWmNGbzIwQ0c0VUhXVVBZTjFUNVQ2UVdEQ1lBeXgvY1RhNWdXbVB1?=
 =?utf-8?B?VlJxSy9Wd2VNRW1tekxFTW43K3pPdGhGUCsreDFRa1RVVVVuSWUwQSs2cm5Q?=
 =?utf-8?B?YjBreVRPcVBDY0JmdjQ0MCtHOXlSODZCQnlkNEQ2aG9jc2NCOTUrUVdVa0Mz?=
 =?utf-8?B?T3BEaUVGV2hBN0d1YnlpTEMydXpZbk5Ia1pEbFBUTjFDZWxvMUV0UEs2Sk9O?=
 =?utf-8?B?WjJHbWxzQkxKUU5vQUZKd2M1d01HQkUxMWZmSVBlbEg3Y2pERG5RV0w5R1Zn?=
 =?utf-8?B?ajA1SGFEYmhRWUZ4Q0tBVjNnTFRPcDRqV3V1Rm5YNnRUbDcxTFVRWWhSK0dL?=
 =?utf-8?B?cU5OV2ZxM2tRRG43bXoxTVpHVlFXN3pnTG5UNnJLU3d6TGVwdS9PcUZyZ2RM?=
 =?utf-8?B?eURtMjlXZmltYWw5WUNiNW8zZ3RONXlOcldnV21MVnVEZmx6VENCYnJOWGhm?=
 =?utf-8?B?NERCYm9MYWtCb0d4NERzblJTdndTRkszblpvRUgzaFhzakllSGh6R3dHUmpa?=
 =?utf-8?B?RXM2a3VybGswbXBDQUtFbnY5TUN1eVV4bTZxZWsrakZ4RElrWWNJNkNTdlp3?=
 =?utf-8?B?T0ppWjZTc0I2SHFGandyWDJmZlVZWGNNQ1NDQUEvS0xRNnNzWHhabStINVRI?=
 =?utf-8?B?dktlYW9yak45djhQQVprTXM1bm44TEY1ZHcya0VHN2F1Y3JhL1FPZm1XMDJH?=
 =?utf-8?B?a2FUanhMZitGT3ZQT1dMMDRUSVpsdjQ3Qzh0TzhNUXNTZVVnZ0ZRNG1ZbW9Y?=
 =?utf-8?B?SWlCOHdCSHJxTTk0Q00yTkdaOGc3clkwNG1SL3hlTHNDZ1diUUFXcEtYQjlZ?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0438e7-ba2f-41dc-eb49-08dc956ecad0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:30:26.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORMvo1H/uRH5eNB5TDXhMTbRNANd/lkqlDG3Ze73NV4c8pxlcJyUddsjvAqS9DZl9W/gfBgVIGFcJEC0M7L2yjv8k7vD/tUsApfax2sV3v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> When SNC mode is enabled, create subdirectories and files to monitor
> at the SNC node granularity. Legacy behavior is preserved by tagging
> the monitor files at the L3 granularity with the "sum" attribute.
> When the user reads these files the kernel will read monitor data
> from all SNC nodes that share the same L3 cache instance and return
> the aggregated value to the user.
> 
> Note that the "domid" field for files that must sum across SNC domains
> has the L3 cache instance id, while non-summing files use the domain id.
> 
> The "sum" files do not need to make a call to mon_event_read() to
> initialize the MBM counters. This will be handled by initializing the
> individual SNC nodes that share the L3.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
