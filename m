Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EBB327A19
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757519791; cv=fail; b=Ki1W/wKOmZgByRFokEFmWwM6H0oM9q8AZj2j3XlJTWb8YbMuSGaadOOsky4aDq4VcuRhmQs9ygKetY/ygIYVqhqvWq+KwuX7ZcYoPCfWwwh9+bxTpWqdvnKyYYiPUOrFBZIBihFOdYHyFQkhU9e9vPE8241jPnlM5NCA9mmXWR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757519791; c=relaxed/simple;
	bh=MKk2qSFPzcW/WCSYDRAH9J6JsrYxHURVaQU6f+vSnVI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tqew98mHczDOOBlrvVDCE5WdkxLwe4n8hfkb/mK5MykrPzMTb4jQ1s6bBs22kqA1Pr9ACVW+K/1JWO8BaaiZwnWroBa36aPAxqN4N8Bk+yCDm755u5ScCINFtpODBvJQDRyGulh+SZOG5/1zmDnrHgUxsxyNj5kHoEvRBhZLGvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GHAKCoRZ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GHAKCoRZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757519789; x=1789055789;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MKk2qSFPzcW/WCSYDRAH9J6JsrYxHURVaQU6f+vSnVI=;
  b=GHAKCoRZwC7Qy+7I16rS3by/Jk9POvFUtW00021yhPehogeAX/kDC48k
   /6zp0oympiH8RXIcE8k2s+4WcHe+wjHZirdkpin0iblHZheoQnQvoJwxy
   wOgXQNsMst3bC9Fz80jRFMqUADfNxdjyHAu7E0Jp+tm+g4xYbcNIDAVpe
   uBWSgbzLUxi4Mi0Ahn66jD4+mmWropJvLP1uifdK3QTLoU5qkLrhYBLDA
   5+SEZH+Girv9+0S0Exa6UlIBk5me7lVnjgs6ICVaAN3/xwCeVTlek86qn
   2J+sJx4j7KGX9R1leZpqAPfYXJCrUfcTsorksyd6poqHE6qYqKG4zhbIo
   g==;
X-CSE-ConnectionGUID: BmRjL5AoSAWgMqkp9QobnA==
X-CSE-MsgGUID: gZ9gqLHlSfG4m3RL2K1QxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="71257637"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="71257637"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:56:28 -0700
X-CSE-ConnectionGUID: nWEGxP9MSu6pCvyBkVfk3w==
X-CSE-MsgGUID: GqNV1IXTQuyZxVHMJ8qhMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="172614421"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:56:24 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:56:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 08:56:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.67)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xygVZQ7JAj+oYiSJICFfXEKxiq0j37q+Tm0TkZprGeCGtbD8vuY0jYa3HUT+Rev6HerKRu8iGrVitK7tntnACG10uh6zzH/Pzb+wMCX335ekIv9+/3uMwRmRcVKX9dN5TeiEh3VpLQ/kI5Q+UHvoNdHurQ6nhAEVHpR+cV6U9Hzh5LQdOSMVCBdVpOWsCuoZC0vmpkHIs024AWVhPzyQT7LFGohfulXrjeu2XmFjSKqHspwx7cxvljhqLzqwXBcsRy36+PdleWxnthF5gQjJA50+SAAphPjpPOAkcWBQ3OwHo6Zc4fIKPQMIh+Jvq5D6rwuuHw7tG07DMbsrZ51fXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOhqqTY8SaeXiI3+Gv3ZCU1wfdOr6rgk3UUuM/MB7fs=;
 b=T+2siDoprDJbCjTXDPq5IwYS4BrZKEqQrBn4LiU7M5RS+71M2yR0CIDx0BlqsApKDgGLcXr6VxRvemzFzNX5VV9HiPqQxObhs0tL8vhgcd8UW8NQrBt8RwHdU5jIRRSCvEVb09UkUn5pc+wjYex1jZa46pYOfMbKf3K3iajL+/uFNLAyocFXhN4dXlyvgizMtRSJfHJNpNk0MALI5PM/t30m2VENsZSkcTiqGiY2un7QkJXDrUPl3RQns/s9lbyfR0QveX5QWAbM/ntKUJXFgqTtqzoMbnyTgDYOqRzdx7rBA0WsLOUVT7/CA41GX4N3qN1V34f+Kk1vp6yAXapQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 15:56:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 15:56:18 +0000
Message-ID: <d244f6a7-8d87-4553-906a-0a2e3fcdcd58@intel.com>
Date: Wed, 10 Sep 2025 08:56:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 22/31] x86/resctrl: Handle domain creation/deletion for
 RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0055.namprd16.prod.outlook.com
 (2603:10b6:907:1::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: 469605d8-30cf-4857-f790-08ddf082941e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MkRqVW91VTNlQUVEYnJCTTFoL3cvS0U0R3NQbVg2QkpqM0k4RlRGOUNiQkNS?=
 =?utf-8?B?QmdRVDF4bXpodFloN3pTTGlOUkFYdHdYKzY5bEVFTWVkTGJmUTcybE41dUlx?=
 =?utf-8?B?eERzYnZRRy9tanNYeUFidXBnZ2UyNnRJdzZ2eFdjSzdWbHI5ckdtd3UzQjBm?=
 =?utf-8?B?SDkwdnpGZzN3amg1a2xNYjRxcEZzc3A0cU9pQ0FZdFdGYzIvTEE0Y25BeDU0?=
 =?utf-8?B?STk0b0FRdDB4enZmSUUxVjR4SzZSeE0vS20vYWtiUmgyRjE0MUhHNTR5ekpo?=
 =?utf-8?B?QldmWnl0MmZtbmtRR2Fpd2ZGRWZwZDhIcmxENVNnQmtseEhkMnlWQmRqV1I0?=
 =?utf-8?B?WktKMG94RzMzQlZpeWJvZW5NeTVNdFptUHVFMStpWnZzWjBoSjZwc3ZBNVhO?=
 =?utf-8?B?WDNFalFST1BDZ0FrYlpWMzlQMnljS1hTUzU2dTRPU3BYYVVFcWpGYkpvV1pS?=
 =?utf-8?B?VjgrVW1Hbm0xVzlIcXpiTFh5L3QrOUpXNGo1ZVkxVnF6Qkg1TXJ0NnVJaDAw?=
 =?utf-8?B?VzJLejhrTTIzV0NEbVh2ektVSXhqcTV1WHF2Wnd3cUllNG9hNnJUOEdrSG1w?=
 =?utf-8?B?cmFhSVZJYzJpQUFXTEVEWTZuLzZTTG52aHNBK1IyVlJ0MnFkc2pTNXg3WHdv?=
 =?utf-8?B?K0dydUFycUt6RXdlb25BS0Ribk1BUjBUWUZtK0VHbHRTb2kzQk5CTE1YTDZQ?=
 =?utf-8?B?MmRuZjlQNUNodHhLSldHNU9namhwZWEzSXFwNy9UZXFSQ09UUE8vTmp5T2RJ?=
 =?utf-8?B?MUNpbUkvbEZEMmIxOXgvK2I4SVRLeEJERzQ1R1RHVmhsSHlTN2tzc0svU0tI?=
 =?utf-8?B?YkVwdGJRS1UxbzRpWHp2alliWVh2U3pKM0s0ZmNrU0hnZXBxcHFRNUNKVENk?=
 =?utf-8?B?TzM3eEFJZjhEQXlqT2ZhTnd1d0RFYTRXdER2Y1ZpZm1SWkRUK0tvOGdMdXVt?=
 =?utf-8?B?Qm1CZ3JGTHYrVmVxc05OMkpzcERaQUdPNnpMdFdjQjhmYk9la1pxWkE0Ry9B?=
 =?utf-8?B?Qi9CZXROUmJkd0NhZHM1dG5BdHkzSGdPRFl1L0JPT01uOE5ncUNCd05aWW93?=
 =?utf-8?B?QlNQN2lhUlhaUHZpQzB1WCtGMXI3a253OFFOZEN1Nnc1V3RQQzRuVFh5V1Rt?=
 =?utf-8?B?bDFYOVNsNWdnMEh1MDB2QXZ2eHY0aWlGeGdLa0ZDc2pXSGNHd1JUSEF4Zzli?=
 =?utf-8?B?MFFxWVRsQnE4ZVhPdnZzdTJ0cDRCZlZwbmZ2SVVUK0JtSENKL0VWWWpKbE5L?=
 =?utf-8?B?OUdETXdZaEo2RFUySDBYcEJUTmh2MnVkdStRdEszVXdkRDhlME9GS1FJYnM1?=
 =?utf-8?B?dk9mRXlUTjRrOVFoL1ZtMmpNZHUrUG5IbEs0U0hwMExibFVFQ3NidEp0K1hm?=
 =?utf-8?B?aDdGTWVMYzRhR2xVQlVpTTdYRUZpV0djS0RoQ1laOFkwSUVhWS8vcTZsNGxi?=
 =?utf-8?B?VUZ6WnhPdFdrZ2NDRHFETnVFU3lURjhvSGRGaXlnS21yRzZBVmo5NUhrSFJn?=
 =?utf-8?B?L2pWSzVwUjQ3ak03OW5uUlhpZGw4TXNnSWN2ZGVsaXd1YWhOdjF6aThXUGlC?=
 =?utf-8?B?cmYzTWJGQ01IbVZJdjZjSklPR3RWYllxWDdNQjdvVHZEUHRYa1p0alhudUZL?=
 =?utf-8?B?ZTRZQm90TlBuUWRzZUhlNjYxazJqd1pGVnEzT1lJbTBTa0Q3dVd4aGRuVGVW?=
 =?utf-8?B?Z3E1dnY1dHB3Z2doQjRTcWRMeDZYSE5ZYWJGOVFiRFYzMndNNXVwbXNSUTV4?=
 =?utf-8?B?MFJUaVI5WmZHL0pRU0xrenAvM2FLMHFDMENUMGRnU2NkNzJOQUtHaWhjQXlP?=
 =?utf-8?B?TlBZR1VjR2NwbGFsRCt1Qjh5NFNmRzA4bzFJOEE5eXJGTUhWR3JPbS9ramdV?=
 =?utf-8?B?WDY0K1ZCYVE5c3JHUlFyYUdRNjJYOUVtMUJLUXhsVU1FN1V5YzRaNllXNTk1?=
 =?utf-8?Q?vU+rxa+WbV8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0ZnbGVOblE2akRzUVlraTY4U0FMSzlKaFdRL0ZZTWtERDNZUTFiS2dHNUdt?=
 =?utf-8?B?a0U1NksvZ1UxYjdVYUZ3Q1RFdzVEbzZmVWdMUUZsaVZFVWhMK0ErTGJKeDNJ?=
 =?utf-8?B?V2ZJcEdSWlVpMTA0a3BtdVJYN0FDZEJsQlc5K1RjNWtxbTBsSGFsUEtJNTRh?=
 =?utf-8?B?RFBibU5aUHVtKzZ4Q0VnUmxYZmdOSktEMzdBeTcwdjdqdEt3VUJGU25YV1p2?=
 =?utf-8?B?cGFsU2xWWFBqaEFEMWc0U2VRTDFzcFZVTkltOVBRSk5haVhGSFg2MWNNbVJI?=
 =?utf-8?B?Q3p4Sk9vMlZhWHlQdXRFMHZnOXF5S3FOL3NDUitIR2hTYjlNK0l4MHcwd3ox?=
 =?utf-8?B?cWw4UGJvd1hEVlIwZzdRRlVTUzUyWjhydXJNblVsYkdOc0w0MDFFeDh1aXRo?=
 =?utf-8?B?S1FRZ09oVGRTRndWeTFMR2lYOWZvL1Rqb3Z4ZFRjNjVqRng3TlF6UmVDOHRn?=
 =?utf-8?B?dm5FOE13QVNGU2oxL1k5SGVzbHUrdisxeWJnM0FrYm1SUmNnd2V4eFhyeVlp?=
 =?utf-8?B?bEJFcHlnN0NIRHYwRFp6YUo2TjBCSVZSbi8yTDl6Vmxoc2dLbDBRYkp0ZmxR?=
 =?utf-8?B?OHpuWkhwYWgzTkFUaHg3VElHMWdhQzFqb2NySEV0V3p6WkpPUHJkNXEvWUhi?=
 =?utf-8?B?emUzamxMNlorZTVDMFpUUmZNR3pUMXp6T1JGVkh3R2Voa0NiTit0WjNzQlo1?=
 =?utf-8?B?SFZIMHN5T0ZQR1dldDRtRVoxclIrVGltUGtVNC83WG9KREYzbXcyZjRYcmpw?=
 =?utf-8?B?b2doTE5PSXRiQnN5UzFVcVZnRm5peEh5QXJIYy81SVpGeUhVRkNwZVNvMVVB?=
 =?utf-8?B?Nk9KQUJuMy9rQXpGNGdDcytoc3ZnMGgwNnhCSll1Yzg1Sjlpai9La3d4S3J2?=
 =?utf-8?B?QTRIRVNRcG9yWVdiL0VaODNtRVNKUi9JUnR0ZHFuNU1BbUlxYVRoNHBQUW1Y?=
 =?utf-8?B?cFhRYUx0cmU5WE9yeE1xb09YVFdmK2lVR2hBblFUTFJCWmQ2N1ZtV3BpUWNM?=
 =?utf-8?B?NzJ5eDBQb3BFMzNESGU5ZHNkcjR3MWd0MXlaa2lzK1BRdzdNZUpYZW1MUnpW?=
 =?utf-8?B?WUFlMkdCeWFkeWdiNVVRNHRGbUdaTG5sVkxETUtoRmkwU2ptQWJyTGJYTXVj?=
 =?utf-8?B?bTBrWi9YUnRxTjU0blRnTWZFMm9wZVIxZlhpYjRSeVkvWDErRUxTVmgwRlJq?=
 =?utf-8?B?SllPNUZud1FYZ0VHdVRXMDNQbmxmSlhPelduQ3BjcFlpcGlRR0U5bWxhNXJM?=
 =?utf-8?B?VGVteVMvR1doa2pjNFF6eGk0SjNNK1gzaDV4R1lhaHk2T2h6RGUxUk5yUjRn?=
 =?utf-8?B?d1lrWmlkU09ZM01FR3JuMzk2TG8vNGdxUDE2QklaQVQ2WW5BSkJ5MldRTyt6?=
 =?utf-8?B?UEJWZGtjWGoyWkJqTjB6UEZ1QlVWY2MyNGlqMUIrZndQeXphdkNyVjlQbmo4?=
 =?utf-8?B?TG9Wc0RXS0RITW1BWHVhV1RyNnJNS3MrL3BzNXU2VG5ISjQxTTNmc1RYMVBy?=
 =?utf-8?B?OFhHSzV5Ty9aR1Z5dHBmWUJhVDJIQU5US2padlA4M1UwZGxTY2U3azlGQjRk?=
 =?utf-8?B?eE9OanljVnk2K1c5clVxb2EzSlpDTzQvYTFKTEcxeXk1R2ZPV2IyVFBSdVdv?=
 =?utf-8?B?R0tKd3dpQ2hScmlLalR3VmRVQlN4TlJvOXBhMnNrZDVVR0J3UzdCMDArMlF6?=
 =?utf-8?B?T1NtWDY3ckR5bFVQaFRLOWFrSkl4SXUvOStFRG1wNG14QXVVdkNYOEJxOGhR?=
 =?utf-8?B?UXVaWUJrUUhJSU9FVVJ1VjRpTzgrUEU4MFNpak5sdXc5WkI5Nzd3U25oNjlR?=
 =?utf-8?B?KzVwYURjbjUySG1kVkhHc0EyTlZWS0daZCtIQzY0SGFqTVVGUHMxajM3Mkhl?=
 =?utf-8?B?QjJCZ3RBN2ZTUldYQnNsTXV1bUd2UExRZkx1eUs1M0ZCVE1acWo1MXJZOEt3?=
 =?utf-8?B?aHR6VXpSQkZVWnp4Y3J3VkhIT2dlajlqR1Z2dzE1N21Wdjc2MmNXVnJGczhv?=
 =?utf-8?B?MXRCOUsyb2cxM2ttNklmcjhOTWtYU3RSQmNQRjJySm1sMnROVlV1ZWNMam14?=
 =?utf-8?B?SCtHQi9EamZKc0t5NVp6c1hBQ3pIdG1HQjVGSEdETEplNTdXRTc5QzZPWVN5?=
 =?utf-8?B?aGI1VUdnRXZBRlhwbmdwcHl2RHZyUlZZMGtMd1NpRkw2emlkOVdsUTFWamtG?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 469605d8-30cf-4857-f790-08ddf082941e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 15:56:17.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwJLncIOY6JWpwdorlydwvim1zaKuU9M+22i4IfVSeiL35znIyc0x7b6hxlzjgbJAOUuRQWM8kqDG5cJoiaw5FItExGGSEFP+M9hC8HiuoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:



> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 8986071dd72a..b054c7cd13f1 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -75,6 +75,14 @@ static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3
>  	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
>  }
>  
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an package scoped resctrl monitor resource
> + * @hdr:	common header for different domain types
> + */
> +struct rdt_perf_pkg_mon_domain {
> +	struct rdt_domain_hdr   hdr;

Please use tabs to align struct member names.

> +};
> +
>  /**
>   * struct msr_param - set a range of MSRs from a domain
>   * @res:       The resource to use
> @@ -174,6 +182,8 @@ bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
>  			 void *arch_priv, u64 *val);
> +void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
> +				struct list_head *add_pos);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> @@ -182,6 +192,9 @@ static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_i
>  {
>  	return -EINVAL;
>  }
> +
> +static inline void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
> +					      struct list_head *add_pos) { }
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 039a00c58514..5745c6979293 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -574,6 +574,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	case RDT_RESOURCE_L3:
>  		l3_mon_domain_setup(cpu, id, r, add_pos);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		intel_aet_setup_mon_domain(cpu, id, r, add_pos);

This can easily be consistent with existing naming (l3_mon_domain_setup()),
intel_aet_setup_mon_domain() -> intel_aet_mon_domain_setup()?

> +		break;
>  	default:
>  		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>  		break;
> @@ -671,6 +674,15 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  		synchronize_rcu();
>  		l3_mon_domain_free(hw_dom);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_PERF_PKG))
> +			return;
> +
> +		resctrl_offline_mon_domain(r, hdr);

As mentioned earlier I think that including changes to resctrl_offline_mon_domain() to
support being called with RDT_RESOURCE_PERF_PKG as part of this patch will be much easier
to follow than sneaking it in with the L3 refactoring.

> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
> +		break;
>  	default:
>  		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>  		break;
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 9239740e9647..71aed96f9499 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -255,3 +255,27 @@ int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
>  
>  	return valid ? 0 : -EINVAL;
>  }
> +
> +void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
> +				struct list_head *add_pos)
> +{
> +	struct rdt_perf_pkg_mon_domain *d;
> +	int err;
> +
> +	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!d)
> +		return;
> +
> +	d->hdr.id = id;
> +	d->hdr.type = RESCTRL_MON_DOMAIN;
> +	d->hdr.rid = r->rid;
> +	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +	list_add_tail_rcu(&d->hdr.list, add_pos);
> +
> +	err = resctrl_online_mon_domain(r, &d->hdr);

Same with the resctrl_online_mon_domain() changes.

> +	if (err) {
> +		list_del_rcu(&d->hdr.list);
> +		synchronize_rcu();
> +		kfree(d);
> +	}
> +}

Reinette
