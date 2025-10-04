Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7534434BA3C
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759537408; cv=fail; b=fXePEQPJCrNc4syqd8NOrX+sN1dCNjQ7CUznlBVnXtKP9SSlGnnf0iaqEiNw6NLGSNpgzDE5UDXKgaqY2ct6F2w1fZmj6yLz+wD7jv7ZGFNRKll/FMnyCOR4kltKAJAGJ7rGQykUKef4Qaxy3rfQn4Xo5d7MbR4ryaLn+Y9U37E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759537408; c=relaxed/simple;
	bh=WrLIx52zd6PtyPscyH0NIcjuCTkG8LRBschnI08w6g8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L9exPDjkvfSPBOomamBkXRRGjbtpuuAxsS4luqDk62QboAAxH1Otr3y5t9mx0Po28F0cpJLBqe2c+/Bcww3y/OueOaEw+QNNabktdWElY8ZOe64PbLRrqimIeAVNuDUX9qhuBS+exgH2Hwm2He3L0wPChSgbsRrryO/JDaS/beM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dnz47RPs; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dnz47RPs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759537406; x=1791073406;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WrLIx52zd6PtyPscyH0NIcjuCTkG8LRBschnI08w6g8=;
  b=Dnz47RPswLkn/cfsQXQ1EfQW1DI7T1axxSVEO0cPcF1yVD+ienmC2EVi
   2t+mTPQN+r0lFolhKDkT+ENi78XYr8i8OH4p9Q80Jn266EzgTtQaNlcdo
   q3ayP0j52aisosj5qdSfOt15aYiQaTtgNebydpAbzXzSUGRdX+QIM0MED
   A/XugiEvAd5geBYu9eT5h39yFqwvN+oicWuDs01Sp5VZo0Tr6CDCcThla
   Kpy3b03n5VScUdsm0k5hlpZY09JfjG77GbtUjQmXvDwU6XhBzmb6nI788
   STOmeCkiFr8GCuHLrmzIGIuLwMbJtl057oQmdyrfSYhWHXmjuiFb3rqN+
   w==;
X-CSE-ConnectionGUID: gM57V4TPRIKqdKSFl0suoQ==
X-CSE-MsgGUID: 9s9/wdXkSOmWXV68K6QYeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="65463220"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="65463220"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:23:25 -0700
X-CSE-ConnectionGUID: ckWOveDRRnu43L+hlcJGTw==
X-CSE-MsgGUID: z5Qze7LQT/GSX5GeiTiVMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="210382453"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:23:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:23:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:23:23 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:23:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SV20fDsuoMgiq5vornU+rs2TTu+MtCBJUQgXMRe3z/19r2ZGIaexOJSbrtiXnOFC0Lv0WH3DSBFsRQEei76Fdx7CoR/LgyArUDseNr8WK+JJ9gyQnmn6et0ehNIk6RQheg6ktlIbG/PeFGEOF5wU9c8GE03a8t9zXB8ksTS7vaHLAEGGKCh5hpcVdFtDOyNufgBPK52VFagJajBOM08NRLZMjB+IP+cFtwaI/esX75oxiiH/tQoXUTzf5K8xyEMaplfjJj64Q8GNFKmkrrCJTBG/Y0ZL4As3cm6/mvRN2+MvfLmJIZcAoLNArdIzAxuvR7gV10j80bZ6UknRB/UEMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPmeaq1e5mg1XvZz6hQmNTEVMnx++5JvGoktGlb4M+A=;
 b=sGdARBmYx3dKOeXClzQCO5QaapiQZZeRSBgFpbks3K0n/mkhaZuYIcmMCFFttUo6itv0T10binp/A/i6JtG0Q4n1R3nMCsy7T84lAGHC3XXL6KrcfrEXlt6nt/BYdM0pMU9UI/AcyUIfrO37BReLwkVYUcB6PpuCqH3gmzTAzKoC+0CaxBu6UYnfh3huH6dbG/HlfdW9shGkSJD+hpLO5uaTFme8H4MKyq1ubOn5yErNUYeayeCxh4jckdm0r1TwyONjenLS0sLeb2FUeo8seR1bc7ryl9SDwuePZ8GAT8bHaGSQdflk1MnXM0i0CnEjosZyagIx/cmEU14LNuwg5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF990BCE628.namprd11.prod.outlook.com (2603:10b6:f:fc02::3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Sat, 4 Oct
 2025 00:23:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:23:21 +0000
Message-ID: <49a197e5-6d4b-4e20-a135-676c5bf14c66@intel.com>
Date: Fri, 3 Oct 2025 17:23:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 27/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-28-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0323.namprd04.prod.outlook.com
 (2603:10b6:303:82::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF990BCE628:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a92645-1a4f-4f10-97c7-08de02dc3945
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SHladExSeUNwUmtPN1FUN0xyYVdCUm5jR0pjSitkdVJQcnZWc0JNTTBqUThO?=
 =?utf-8?B?ZlZqOGN2Z1hFd1NoeUt5UkY1YU0zQlBtRUI3d1R1Z0JjcE1DK3VybXVENW04?=
 =?utf-8?B?NDZTR0docjZVNHVWZW1qek82R1JGOEpwbHNjWGdjaGVjV01QZG83S2FZamYx?=
 =?utf-8?B?VGlxU0Rvang0V0lJRVA5UzZ0YnF5bUpIYTVGYzhTK1hEZWh6WE9xN0VOWTcx?=
 =?utf-8?B?NXdZcHNtSHE1Q1JFOTZwRFVHTTBtb2FXdi9BYitlY3JaN3hCTGp2TFpncCtv?=
 =?utf-8?B?TGtYWjB5K3BGaVZHbEJUcTZQZE1weGIwUlB5eVZOaklzR0Q3VU51UkpSMzY1?=
 =?utf-8?B?T2pxMlkvdzNFOEFwVjMyV0M1LzNFRjB1Z0p0bVRmZEpWaE1MampVcG52NENS?=
 =?utf-8?B?UHlIYnFCRmJHaXl6UDRlWjlORlRDTzRYL2lVb1ZBbmdRYndpMlBTVy82T3RT?=
 =?utf-8?B?Snp6ZStzQjRjVU8wb3RRZDZpY0VZdHZnRmRoT2wybkN1eUc4Q0tDQ2orelYx?=
 =?utf-8?B?clhUZ0FSVmFRQit1NVMybDdmNERYU1VZdG9XOWNCQkZVMmg2OEFnZEk2NEhy?=
 =?utf-8?B?OVM0NUVRSGU1a1p1NytrU2s0b1Y4QWhrV2hhbDdmMlRid0FPYlNJMlFsZXJE?=
 =?utf-8?B?dVN4UUNVYUxuUldZczVHSTExSVZGU0dwdXFJaEl0T0ZFbFNPOHpraXBCTzFK?=
 =?utf-8?B?UzFxMUdQaGdManZ0YlQ4bXQwY3BpL1QxRGtMYXRMQTZIQlRkOU54VXdUZDEw?=
 =?utf-8?B?MDREcnFLQWJ3Z2xvUk4zaUgwa293dzdyNG4vaEhyRk8yK2xQYjl4TVB4ZGU3?=
 =?utf-8?B?aGlMTFV4QVVZMW8wV24wRFdHdUZBSGNYN3VnNzFhbjJPaWRkd1NhMmMzVlhv?=
 =?utf-8?B?RW1lYmpaRzQ3blM2MU9meWFURnRIK3RkMWVIOHNJYk52aUgxVUJuVXZiYnNk?=
 =?utf-8?B?VDlVWXJqNlEzRHJ5UDBpQlA1RVhLcW40SVMxMHJjZWlNRkFVakR3eUx6ZHUw?=
 =?utf-8?B?ZEdSWDY2bGRUQWlNSmE5S0FFWmVaMjk0MUhiS0ZvRkNEWG5lVjJtYm5VSTIz?=
 =?utf-8?B?Z01ETTNtVFlJTDl1TFVKVk54T1FDVTEwcXVuRHg4V1JRQ1F0RFc2ejVhR3RN?=
 =?utf-8?B?bUJRbXlHZXpQVFdvT2VRRW9DWVVHUlNkT1VkOGE5bXluNGwxRk83VUowUWx6?=
 =?utf-8?B?VHJmaHFoamlxOFVsb0Y5TG9EZmdBeUR4MGtjZ2pwd2FLb0xmU2V4eXF4ZFZO?=
 =?utf-8?B?WDczL0s4cVd5WVE2VCtRcDMwOWYyMi9zWThyNmVGeEJncWl1R1liZktGZ1Ar?=
 =?utf-8?B?b3hOMHZZWnZKNTE4QzJqdGRFTGpQMVljZm8xK0prMEdUdjE3L2FPNW84Syts?=
 =?utf-8?B?bzBRTm4rSGZUUkFud05PTDJQSjIzczFNM3hWY3hFQVNIOTIrd2ljcUR4UjNw?=
 =?utf-8?B?dlNFZnAvYjRydXJLbndWNEgwa3ExdTFqMnVaT1haMEtmVUJGVjdFY2xYNjFE?=
 =?utf-8?B?enM1c3ZBUHlUaHFKbDAyMkxvRkN3SnpYQlBzY1NXQkpXTTQxYzdTclYwV1ZU?=
 =?utf-8?B?YWJUOHZlY0hGWUZRRGpJSlV0T3QxbEZWUnduYndYS29hRGVtNGI5SHVMRFdw?=
 =?utf-8?B?SnJRRVgrSkdpMGVGc3A3WkdlNGV5eC9VenplRUc3ZXdHQy9qVkxRdlZSS0RQ?=
 =?utf-8?B?bU1DRklSM0JGQVQvU2JmaFppUEEzVnJzcWF1bHYzMk1weWFjOTl0cS84SUNO?=
 =?utf-8?B?akhmZGhUM0ovTURlUS9ZNW1UU0xCVldIQ3FnS0xQTTQ3VFdFN1FhaExWSDly?=
 =?utf-8?B?NU1XWWZnTU81OWFVYlNTMmR5SHVERWpIZ1dYYWZ1QXYrak1HeU5zQjNzTFRC?=
 =?utf-8?B?a0VhWVdpUS8wa2xscXJIK21rNFpjYVJjd2tJOUxrZEdUOHVtSFhlZjVwWXls?=
 =?utf-8?Q?bb75VooQ9X4yzCKgn5fzBXtjHCW4rhFr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU9NNHlpcjQ2eFloRUlxV3JkbXI4R1BIaDNDRGpZcW1mZHdGbDEvcnNUME1a?=
 =?utf-8?B?MnJuUWpnQWd3dldWb0JheUtPOGZLUFlYOGlHUGJiYTR4cEhWZU1ESjhKbm9k?=
 =?utf-8?B?TytwVVBGdnZNWUpZeU9Odm1MVEJRS0NvZ2loMFk2azNIeGZZSE9PZTZWRVJV?=
 =?utf-8?B?YXFaR1NIOFJmdG8vLzN3Nmk3Zk4yN3R0eml3bWFzYzlwcDN5cTJKa3BycXA2?=
 =?utf-8?B?RlpmY244cjE0VmRsUW1tK2FPTjVCVFVNVGVpZW1LaWdEcFBXTGFQM1hsK3lU?=
 =?utf-8?B?aytKNnFJUWdrTFg3dnF0UDBINzRVUmNHTkF6dE9QeDZXRXhJTVkrWERxQVdG?=
 =?utf-8?B?KzBrSkl5aXFxQkRoOUhxTXM2Um0wNHVjT2tNKzJubkZXN203YmFqQTJzTnlR?=
 =?utf-8?B?K3dTTFdsTWJGMHZ1bkVvMjdYeUlTZDI4SEN5U2xVUDI3bUcwcHhsNW1pM3pM?=
 =?utf-8?B?WEhrRkZESWhFM2pBMm1KTlQ5WVloZThCV2lhNDhPMnJjbDVKTFBTUTJTOGE1?=
 =?utf-8?B?V084enhNa3dOUFh6NmhucTF1ZTYwL1NDWHFPd0VZaC9IOUk1NWdRU1pRYzB1?=
 =?utf-8?B?UFQveGltcytZSWNCUjRzcXV6UE5PMFI5UFVXaXN6UzFESFlMVjFXVUkrbU9D?=
 =?utf-8?B?UGNrUnJYV3pXV1FYZE1qdDduUnNIWnFVbmZDMTgxODZ1dHU5cjBtT08wSm1K?=
 =?utf-8?B?VDhlaitlbTNXRVVKMmlFRUVlbWxjUXhGVFNqd1JoYnBWMHA2TTlwekxBK2Z2?=
 =?utf-8?B?MHFpQmZUR3ByVlNxS2FnSkwvN0xBbWhIZ2tEMHp0dUZ4alMyZ3dremJ1OS9K?=
 =?utf-8?B?VldVSzRXbmREYUZldlgxRzlwQW5FZ0I0NVE1Y2VtMTREY2F0amRMWTdyMUhX?=
 =?utf-8?B?UTBndUYzV1RyL3cwMFA4aEdNemJmR1M0U3BsblErRy9HWDEzYzU5MmhJRUlC?=
 =?utf-8?B?cmVmZ1NhN3Q5SDRCRDJjbi9HdlJkbFQ3aUl4cGNhYTU3ejF4LytxdndjQ3VC?=
 =?utf-8?B?Kzg0cTZPdjhydkFORjVWSWxycFpvY2xxR0VudDJ0anVSUVZaekF5WklZbmw1?=
 =?utf-8?B?ZXFhaU1TOUgrcm5UY3VFd0dBUDU1Y0hsSDQ0SE9XVytYb1Y1SEU3RFFUVjdX?=
 =?utf-8?B?Wm5qNlFRN2lYa0FBV1ZsYUpkajUyUytwTTZ1bUl2RTc4Qy93MEdjVUVkbnV6?=
 =?utf-8?B?VjQ2Y29oQ2FGOVg0UWZvRjhxOHFsc0l1VXA2VlVGWnEvTGxETEJNSHBTdkxm?=
 =?utf-8?B?c1A4VFMzY29zbjliUzBFeWVqVmZkZStPc0twaEtCSzV0bmdrb0lLWTNLL2R4?=
 =?utf-8?B?SjNxdkwzYnZZb2NXb01mOTlvMXVhT2ZGbU1RVkR4VkI1TW1RSmVFWTg1a0l5?=
 =?utf-8?B?eW9YT1JIa2pyaXg2Ulp2UUFVVThmanJISWQxUkdSTG1WVHBiQytXSTl1NGNX?=
 =?utf-8?B?Rjg1djV1M1d3YitBWW1xQ2dkb1hLV3VPT0ZhYWloazMyUG1DV2NGRzI3eTVp?=
 =?utf-8?B?SmNrNTU1MTZuYjNvMXM4N3RMcXNjcm13T2dtcExRTWFvOWVCR3E0TmZRcmw4?=
 =?utf-8?B?OXN4R21mTm9ENmdFcEVpWlRpSTFOM0xoRUhhZkRxYWhGaCtEVkZ3V3Y0U0VG?=
 =?utf-8?B?ZlVaNENoSFFwaU5PS0pLVVMyTXNrNVdpSnZUdzVPRWRHYlJVd0Fkc1NnWklG?=
 =?utf-8?B?bnE5TEk4b1RSclBmak9aS3MvdnNVc05oa3NsenYwSFQwMjMrMDkwVkVWdjl3?=
 =?utf-8?B?WXdsSm42UmxMVWRZU05PZVljY2cwODd6dXdtMDZyRnowdHVvTjU2MlhzOEEr?=
 =?utf-8?B?bmVneEhXd3VuR1k1OFluZWZRVmMvck1rcTl4MmFITFZ5eUNMeERrVGlFS3N3?=
 =?utf-8?B?S09hM04vR2lEd01kZE15bFFvcUtXTnE2TWJsb1h0YkF5UHkvSVoxRk8xc2dh?=
 =?utf-8?B?NEhKT1JpOWhDZGNEU2oxa25ZYTFLSHQ5dEFKWmlncGdQREkyVFdrN3U4RVNF?=
 =?utf-8?B?YnphWGp5bWpuUGFhVTFjSzZzWTBMdkEvWS9RRnprNFdSQXJ4UXNyYnhRWEl2?=
 =?utf-8?B?QUJnQytnajFXRFIwWCtTMmJVQXptMDdLT2lZci9iSTR0Tm5xMENGQVZjU1pp?=
 =?utf-8?B?b1UydW5xYUxLTk5NTTZpaHpkSHJETHEyNU81V29SNVRqRHlJQkZrSHJLSGlF?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a92645-1a4f-4f10-97c7-08de02dc3945
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:23:21.1797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14LwaepT0Eyx2mAnTgxQD3NlhC2dSsu9YkcEuUJN7Iok8JStcn6jEg54KtASVhyFWXJkHw5kPcoqmTq4Umb5wSz3Ib5jSk/IWacFILeeqKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF990BCE628
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> Mark the RDT_RESOURCE_PERF_PKG resource as mon_capable and set the global
> rdt_mon_capable flag.

Above is clear from patch.

> 
> Call domain_add_cpu_mon() for each online CPU to allocate all domains
> for the RDT_RESOURCE_PERF_PKG since they were not created during resctrl
> initialization because of the enumeration delay until first mount.

Attempt at alternative:
	Since telemetry events are enumerated on resctrl mount the RDT_RESOURCE_PERF_PKG
	resource is not considered "monitoring capable" during early resctrl initialization.    
	This means that the domain list for RDT_RESOURCE_PERF_PKG is not built when the CPU    
	hot plug notifiers are registered and run for the first time right after resctrl
	initialization.                                              
                                                                                
	Mark the RDT_RESOURCE_PERF_PKG as "monitoring capable" upon successful telemetry event 
	enumeration to ensure future CPU hotplug events include this resource and initialize its
	domain list for CPUs that are already online.  

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c      | 17 ++++++++++++++++-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 +++++
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 1d43087c5975..48ed6242d136 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -755,14 +755,29 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  
>  void resctrl_arch_pre_mount(void)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	static atomic_t only_once = ATOMIC_INIT(0);
> -	int old = 0;
> +	int cpu, old = 0;
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
>  
>  	if (!intel_aet_get_events())
>  		return;
> +
> +	if (!r->mon_capable)
> +		return;

Is this necessary? Can r->mon_capable be false if intel_aet_get_events() fails?

> +
> +	/*
> +	 * Late discovery of telemetry events means the domains for the
> +	 * resource were not built. Do that now.
> +	 */
> +	cpus_read_lock();

hmmm ... until this point CPUs can come and go. This means that from the moment
r->mon_capable is set resctrl_arch_online_cpu() may run and thus domain_add_cpu_mon()
could be called twice for PERF_PKG? If all the second run does is set (again) a bit
in the cpumask then that *may* be ok (but should be documented) but the flow does not
seem safe to end up like that (more below)

> +	mutex_lock(&domain_list_lock);
> +	for_each_online_cpu(cpu)
> +		domain_add_cpu_mon(cpu, r);
> +	mutex_unlock(&domain_list_lock);
> +	cpus_read_unlock();
>  }
>  
>  enum {
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 039e63d8c2e7..f6afe862b9de 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -214,6 +214,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	if (!usable_events)
>  		return false;
>  
> +	r->mon_capable = true;
> +	rdt_mon_capable = true;
> +
>  	if (r->mon.num_rmid)
>  		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmids);
>  	else
> @@ -223,6 +226,8 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  		resctrl_enable_mon_event(e->evts[j].id, true,
>  					 e->evts[j].bin_bits, &e->evts[j]);

I notice that the mon_capable flags are set *before* the events are enabled. If the first
CPU of a package comes online between setting the flag and enabling the events then the initial
domain creation will not be correct?

What if the mon_capable flags are set in resctrl_arch_pre_mount() after a successful
intel_aet_get_events()? Perhaps with CPU hotplug lock held? From what I can tell doing so will
impact the debugfs flow since that depends on the resource being mon_capable. Would there be a
problem with delaying the debugfs setup until after domain list is built?

>  
> +	pr_info("%s %s monitoring detected\n", r->name, e->name);
> +
>  	return true;
>  }
>  
Reinette
