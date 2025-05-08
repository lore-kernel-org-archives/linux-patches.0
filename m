Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6809128E0F
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675102; cv=fail; b=roV+6sVMI+DDLB0WFo1Ynay+L4fIhshdRgqd+gYLzcldUpKz5AcnozmswOnkTNBAxJWKF3XVA07It3qjUM8fNqM/FjSrZbclJzKcK5tVRXHcQD5SzTCnUNBJukJthePqG4KNNTrmngvLLxWgCmoePdDnxVQddqJOWclFGR0ve6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675102; c=relaxed/simple;
	bh=dS1Srq/+Rp9lbLgBd3QqgnrlL2SiEgfT4B2taUS76x0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JZV4bHGTkB2yloDCIghpDWA/3Ax37DmI56M9O+tq9p5AaKiUuiK+rJhY3z4Qsp97mHG4ZQ/l9jsss8I0dFJSK/mV8XVVfm+Af+p02rYF4Eqeln3t4dLUk8VVCV7+xZc2lnik/XlWhxSW9ow2ZbcJTy+LM+xhniJBocjhekiHUw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1nStxWL; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1nStxWL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675102; x=1778211102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dS1Srq/+Rp9lbLgBd3QqgnrlL2SiEgfT4B2taUS76x0=;
  b=O1nStxWLK5+RNAUo9+qU4Z5aX4lPj5J4y7eNnu/kJtGKl2/wgF871hRb
   yTlEGoXCOqWprkwcQyXmlaJUp5eiXcRYoEi9Azn/Esi41eypDWN25x9vK
   ZfopYUkczNpKD9avsb/UMBKglPHfgYqEkVAkt8V7CB8wR3Ap6ebHbBaUa
   BaXZWyMY0SM12Vt8rHEZ854CdkjPaFBTZCaOHeNitQjMMotNm1rggq9Qd
   7vE6PScqxqswJxC09utfnxxaUnyORD+dmwvEOe11EdBTXtrRuWljn4+j5
   NrjgMGBc3FvW50kug618jYx+woYN57bT8Q0DR2D1gTUMYP8DKwgjNCRrs
   w==;
X-CSE-ConnectionGUID: VJAB30qwQOuyt0ohB78xlg==
X-CSE-MsgGUID: MOK0mMAZTC+vSt3ZuvZ1fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48305347"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48305347"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:31:25 -0700
X-CSE-ConnectionGUID: sIoZ+1SfQeWDKm1DGoMBoQ==
X-CSE-MsgGUID: JhEFXbcYQBCJd+GT8/E/UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="167214441"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:31:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:31:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:31:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:31:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdaePkhhGu+i0Kuqv1zgn2E/hDPfmayEPDELwYvWWMNz74GcHO53xp0Q4oJr17UCV7dlPmpb1PVRQbiWh+W1Rap3Y4bpW+pIyUruV2rTjDUFFEx1oHvFd+a+Y3yIpopcrJGgrZA0Hwn5fTkoI8oDNVRL4nkjd7uPzuqsF2j38xGXk5pxm6jiBnsbQ+rGnSJKuuUeQqH1a2FgnVrV+CknVlq6kTilKeOZO8zQAV3reWEyGAeLR/mNVX6vcv7/pXOQW6vSTGd224KN0ucid9PBWxAF9/0lBELBOjwjWpfyiA9/lh+V1WjuTBlWNASzMVuisc3aCnG3mBYRiogaz7NgQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQlna4NSxKBJ7L95c46WF2tpiK5uCYMekM4OMyOR9h8=;
 b=M4SWGUeG22wNbJbZYdm3qSsevsG2xy8priUHBi7Fj2WhClthTGWpG8orVVnWevtK0El4lsL/3tI4akR8qLLZwxhP007UqleFSmU+xbVu6oeKZcYYbON+aFxL9bkMIDc4xf/R45dPXZhnxqFXF/cCNZ8rIgsb04PL+Tvnal4h2UYkymLB4KJjC8NhpzE3mDn/7W6+m4ceeLUlnmB5Rr2j5vCIVrSB6Y4XeZrossjR271KEpUpheZx1GyLOntRZswkEFs7IySVYgT4gX9+uLXtGjOgA0If1jylCjfg6w5NPi/tVHLbDNA+xO14O1HTkLk/K7x2CBTS4outHep12duBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8513.namprd11.prod.outlook.com (2603:10b6:a03:56e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:31:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:31:16 +0000
Message-ID: <8be0d994-219a-467f-8303-cd8f6605b784@intel.com>
Date: Wed, 7 May 2025 20:31:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/31] fs/resctrl: Clean up
 rdtgroup_mba_mbps_event_{show,write}()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250429003359.375508-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 79177819-8a68-4456-d003-08dd8de0ca5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L3JSbmVFRVM3eFEvM29mY2ZaWmd5LzRSTjhKZzlHNDdXdEcyV3NRVFBSYmFJ?=
 =?utf-8?B?VnE0SjRmWXJ2ZnZmTWREcmJxVFpMZVJYQS9WYlNrZEJST2t0ekI1TVo4TUdi?=
 =?utf-8?B?OUczd25IWUh2K0VCSzlhQjRLTzB3cUg4SHNQRTh2STdkZUlrZUQvMkcwMVlL?=
 =?utf-8?B?cDMwZUlNTnY0Vld4UStuOG5zMmI5NmhneCtvakh6OTRtZC9pQjYxbVVzUjRE?=
 =?utf-8?B?eXlzZ1pJNWtWb3lpdStUYkVZTFpOMjlVY2hsR2ZQcUZpVnZMK0NUUUM0Mkp1?=
 =?utf-8?B?blhBVEwzMDVxM3VFY3k2STJTK1ZVeFd3YnZoQnRWMWlCV2FTeVA1VUdCLytp?=
 =?utf-8?B?TUhKSlR6VW9vMEZXRldRWGYreTU5cUFvNUtKUHFmRHFaZlpzelE3QWVaZjVm?=
 =?utf-8?B?UG13eU1oTml2RXJZOER5TE5ueTZvZzhzUWQ4MmpROGVoL3dRWkhna25HbFdr?=
 =?utf-8?B?Si94ckcxMzhIdkordllMcGpMQnhTL25XbXEwK2FkdUUzL2Jzd1ZqcTJvdDNT?=
 =?utf-8?B?VjFjMlpBVFhOM24rT1ZMZGJCVExFTlFLOEdYUjh2bnRTT2gvenhZWUpRNEFM?=
 =?utf-8?B?NkI5Y0QzcUlJTXdxaFhkdnRQZ3NOOHljWms3TXVLMnpVU3l1SEwrOUZqSGlL?=
 =?utf-8?B?blFYTGpFcmpZaGs5N0VIQnFNckFCdmczRFFxTmpyYStYcDBoK1NOa1VzK1Mz?=
 =?utf-8?B?OTB6NHRoVUpwamh6MEI5Z0VnQllZVG1HZzdyOGQ1ZW00TzZxTFY3RHhyelV3?=
 =?utf-8?B?R3BOYWVNR2hYcjhQS0dBWE1RdGhaRFJ4ZWN1UVZmSll0ZnB2czlaZlJKeGJP?=
 =?utf-8?B?V2FNV0dxSW9qcnhOSzVUTVNYQm1CMWFZd2dVMUtoMTJEMmw1U3BueW5INTRy?=
 =?utf-8?B?cjhNOVJCQVR1SjNFelp6V2plQWo5Q280cXp0RTAyTFRmSTFlSFNTUzBjOThB?=
 =?utf-8?B?MU9pM2JHNWUxUXNHbUZubmFRekZhdHNqaDZieDRaVHlhM3BaTkdZYlBZTDFV?=
 =?utf-8?B?MEJyV0I3dDJRaUlWUE84UUE5REtaQVo3ODUrS1R0SzNSZ1Z0ZXVIcmxrRnBK?=
 =?utf-8?B?YkJKVHowRGNCNE1VWjVVdXVqRFRlM0FPemIxMnQ4OFNHQXg0R3o1eVBwQTM2?=
 =?utf-8?B?ZFl1RVpuTHBzTG8wa2YzV3drM0JOVGhqcDcxYjIzRDIxYUxnbC84aWlvbzBv?=
 =?utf-8?B?MUk2bGtZYTZSbnF3Ukd0d2VDZ25xTHJwdnZkbWpLQnY1YVNBZ0FTbkUrekN6?=
 =?utf-8?B?bmtKYmw2T2FEN2hucHFXeG5FV2ZobkRwRkJobDhBczhnVGRIMUFzT2FtNDhZ?=
 =?utf-8?B?SzdCK3NyM0Y4clRNbXpWYlJDRkp3cHJDZ1hDYUxZU0lFU2hLeGFFb1NTelJZ?=
 =?utf-8?B?QTNmTTBqRUVoTzVqa0FVUTZrSW5uaTBRWXdGSXdUSzd1UFh2QmhXbGNmS05j?=
 =?utf-8?B?bE9DcCtCclBzNldzeEM2ekNXZGZuWjUwUkRqWkdSVFg5OXUyc0V6MTdKdlFW?=
 =?utf-8?B?RkFxbUxDaGpGejJvTVhRcE5wY05nZ3hOY0lXcXJra1p1YXJtNjFDbDdKbjN0?=
 =?utf-8?B?OTBnMm9KMDFnT3MrTnEyejdyQm8wSDJIRko2U1E3N3FjdDU0ZTZ1ZUhzT1cz?=
 =?utf-8?B?eWJUSm1rUnd1aFZLNG1udFpqNmwzN3VORHUyR0tYL29VN3MveXhmQmM0aVBm?=
 =?utf-8?B?VVRYVVJFODRmN0JleWVvczJROHRpcTlzckducnpNRGxpUENlQVllMEVkQ1lB?=
 =?utf-8?B?NlVoTGtvNEhhSkxYWHpDODNZTHlSaWk0N0pWRHBFMFNYT3FPeEppVE82dmZi?=
 =?utf-8?B?TDJyT0VvYkVOOVlmYk95YS85ZXJ6blNMdFJVN2Zqa0FGSEl6cWNvOEdZdk1v?=
 =?utf-8?B?SjZqOVkvSW5yeHU3aWhibzNwK2Z6RFl2SXNESFEwYjZhaFJqbEFnSlkycnIx?=
 =?utf-8?B?MzNCWUE2c0hwZ3Rsb2xYbDczeHF2OEpVVjdXTGVoczF1NDNBVlJKSGtWTjYy?=
 =?utf-8?B?MlJOdzM5QTZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MThEZFVXTUxDT1NtTmtzQjZIdVNEVFZPaHdRUmVYM3dMM0ovWEVHRFBpNWdt?=
 =?utf-8?B?TTNzMjFQd1hmUTlFdXF0RW1XdGRNajg3c1BQVFJkRWhlejA3R1dQc1Ziakt6?=
 =?utf-8?B?RUJCalRZSEs2VlV2dTU4NGxRMklrSFdQSDhJQ1lXc0Jvc2hFSnpYTGhhcWor?=
 =?utf-8?B?NlROZ2ZnZW9jVUt6andyUDZRa3lZS2lUazNJV0ptVXI2SVAzK2trdWE0cnh5?=
 =?utf-8?B?TFU3Slp5Um9xZTZUdjlwN1FPZ213dHhLWmJuUjRMSXZZUHlmbW5sTFZlTmVv?=
 =?utf-8?B?cDF2ajVFSHhHM3BGODREMTAwbmlpUEQxZXozd0ZHYWxJTzVVM1VPTXlhZDE4?=
 =?utf-8?B?NUdpc1ZpVFB3Zm5aQnpuMnZPaXF0ZWgwRzYxQ25hOTgwZlhVMDkyY1d1a3FN?=
 =?utf-8?B?L3NPL21teVlyV0lKOEFQazVYNE9CTlJwTGQvdDZob3NJcmtwU2tRVURweVc4?=
 =?utf-8?B?RWdLVUNSamxLL2ZMWTdvK3N4VllrdVYxenc5M2RvUDc0Z2RzSDdhSTZYYmNk?=
 =?utf-8?B?M2xLZ0U0NW8vTGp1QmxONGwzeEdTTjFGL1hQZUFETUZGVDVJcjhLWEhZVytl?=
 =?utf-8?B?RGdMN1RYLzE2b3ZtREthMHpKZCtGOS91ZVMxUTNwYWJXa1BvTnErbEJVa081?=
 =?utf-8?B?OUZhT01WVjBwbmxJVDh2N2NaWmFlY1VjLzJ6RlFRcXZXcG1CYWgxT3Vxcm13?=
 =?utf-8?B?aUN5QVUwYVYwRkVHVkg3TmZEMjhWMlpXMXdnZkQvelBTZ3FzRnNsa3pQWStG?=
 =?utf-8?B?czNTR2E2VjdqYlpPMXNxMkp4OTlLSGN1OUNWTGVURGRwMTNiS3ZkZFV6QVBD?=
 =?utf-8?B?bitrbjFiNW8ya1pGUnI3NURaQ2ZDVnI3RnErY3MyNEFGSXN6MnNLY0VneU1s?=
 =?utf-8?B?MHNxNGFFQ0xEVGRuUnp3T09yYllEU0FucHRwdFRqRmdFU1AvWVpMMWtsNms5?=
 =?utf-8?B?MmtuSVhyeUhIaU41VHhrQ0lsLzRsUnNPaDZ6eTJpL1drRW5FSWJRRmtQQUNU?=
 =?utf-8?B?eVdCSTJhUDJxNXhlamh0QnJaV1pIcnZxOFdNeTV6eHA1TkRFVkhUUy8ydjcw?=
 =?utf-8?B?TWlaeXJiZHBrNnlOVDlFRXJwWkVudTMrdHhIUENCTWFHcys2UWM0Zy9aN0or?=
 =?utf-8?B?bHRRakcxSVFpMldyV3ZwWEpxS3A0Nnl4MEhPSzJ5eklYSitndXk2c3h5eW4y?=
 =?utf-8?B?bWpNL0U5VE1jZFVCODcwaThLaXdhdXJNUGw3TGpRYi9tRFpVME5rbitnemNH?=
 =?utf-8?B?RGpjNi9IYmd2TmdheG9nanFWRkltR1BJc24vMFlKSnNSY0FsaXV0WVRoK255?=
 =?utf-8?B?NStnRm1qVGZyRGd6dXQ0K0xCNVhpL2FpYmtud1ZsREJ3QzJBak9zMHZtRW45?=
 =?utf-8?B?RTFBdmlieWRYb2dxQTM1VEZjUXdTTmdzVnFqM2o4cHV0S1ZJVnhGZ2VXTmwz?=
 =?utf-8?B?Wmd5bmxDS0ptMmxEdFVpNnEyN0lpbW55ckxGbXpzQ3lMMFd2eXpXZEthRW1k?=
 =?utf-8?B?QWs3TC90SEtJRlpwa25XL2tNRkNKU0RxT25sT3VwYWRqYk1XZkdZL2VJSUJB?=
 =?utf-8?B?OXdYZks3RmFTQjliN285ZlBudStxdDRvUVJXTEc3V0l5N040QjlmTWpGRXM2?=
 =?utf-8?B?NVZtdjNRa2hJbnh3dzZJK0ZnTjdpWnI2cFU1aHZSVDVPeExFV0FSNVNicFUx?=
 =?utf-8?B?YlVBVmRlYXJ3UnJCN1RZT1lsVjBadmcyMDNFaVBreStmUkx5LzN1UDU3eERZ?=
 =?utf-8?B?SHViUTN0cEdJU1QyanJEdWp0ZHRuUUIvMG5UUDRLV3NJendET3habTRadmpo?=
 =?utf-8?B?aFNqaEc3YWlORkdUK2J6NkJpbVhydFRPM2NKTWVhRzVPUmtLam12MkRIcys5?=
 =?utf-8?B?bFp3ZHNkLzZKYnJmYTlGSGowVnZFYjRpZFFreHBWR2svcFB0Rm56YklSVVhT?=
 =?utf-8?B?REVROHVmSEpEUUdJdnNuRmo3TGt0bWd2ZmNTOHd4bnZDQktZQ2dSRks3RU1B?=
 =?utf-8?B?RG9oMGw2blVZQ0ZjRGxNYXdEMFFNRHg1UzdjaVFxL25RSm9VM01MUUc2ZlJL?=
 =?utf-8?B?UnJXTjBFbElYN2tNZVI4UHp3bSs1dEhHU0tQdkhqQ1VIY3dPdnlJcjUrWWxU?=
 =?utf-8?B?SWR2cm4vV2o4a2xhTC9GS2ZobWIzaXVGZnVPaTRKNCs4RnlkVENCOGViWHUw?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79177819-8a68-4456-d003-08dd8de0ca5f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:31:16.5193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/06X0AXr9ragMXqSKT53AgVFixLFFJ7eWvSyqSI2vT6J42SSI9U94FRkM10PLUQQz9SeL7mRMPVJzuLiFC6oDvQuw9MX3r+PSjRfd+Chy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8513
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> These routines hard-code the two legacy mbm events.

No context, just a cryptic problem description.

> 
> Change to allow for other mbm events in the future.

What is changed? How are other MBM events allowed in future?

Something to start with (incomplete and needs improvement still):

	rdtgroup_mba_mbps_event_{show,write}() respectively shows and stores            
	which memory bandwidth event is used as input to the software feedback
	loop that keeps memory bandwidth below the value specified in the
	schemata file.

	rdtgroup_mba_mbps_event_{show,write}() hard codes the two legacy MBM            
	events, MBM total bytes and MBM local bytes. 

	(Needs explanation why the hardcoding is a problem and how this is fixed.
	 Since this series is not adding any new MBM events it is unclear what
  	 motivates this "in the future" fix as part of this telemetry work.)

Reinette
