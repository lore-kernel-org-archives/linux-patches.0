Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5BC2798F6
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719411; cv=fail; b=lcguZ/XR8Y6rLW7nDlIFWs/Y+UmVTgrQb5IKzGTctvrZqC6Pu4g8qDvN4PUFy+j4NcqNWg/NIYeNJ1zj/CE33xhrxc3GVmKc//2CrFk5/UtgoyAo+ahMOuurGM8UEjnwFBjpGPKXo+U4QCp9Ys3Na2BJ8oRJ5Ff5DSRfJiZIa0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719411; c=relaxed/simple;
	bh=zvwxavHNVeiHbxWppBEEJD5Eg94/FFnYrT05YNeWczg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FCO5tlrQFxN7yfW7iJgPycOlOR6oJxHHxGtVMLaTt0dhKlHcEA9ZavKazXSNKb+7hJd3O5yvN5p6fxhafjuGJJU+pvS4E+F2neJ6+qpy/zg3XWX1mR+QK8jEDHBhWyTq83/AmsQl9BdJCI12mlogLNC/50i5pCCAs2rhMfUWXYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UtaUCuq8; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UtaUCuq8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719408; x=1778255408;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zvwxavHNVeiHbxWppBEEJD5Eg94/FFnYrT05YNeWczg=;
  b=UtaUCuq86vCOUa2JwVR88oXCa+oSylunuE+qZuAPVjXacSKW1iU+7Xwc
   jaknxjX9sEv6Y7GUee3DQ4tGyvPkx+iO7SQgUlK2xKN744Ij967N6sh6W
   DHboLWXnWncNUntgy85oJD9yaZVc8FMJXxJySayT5A37SM8c7JxRDkkHl
   P2Irupw6qOPGCVHGUrJb8qjye8xbQQ3qgHhfxU7xN1AtqRLIAek0F/VAm
   OG4U4GsNW9G6g6QQSkBiPb4vIiUcI7hGtmeSvKW22T/+jC+QPOhJAsG9Z
   3uTT4OtFUSAPyeBW2C0dIb1vLIREldwM9fBxqOJxhyU1vMpeq5f6w68pN
   Q==;
X-CSE-ConnectionGUID: QJBf+/MER0OQ3P1Boup0dw==
X-CSE-MsgGUID: ObW4D7mTRw2+K+pxnESkNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48222033"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48222033"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:50:08 -0700
X-CSE-ConnectionGUID: Q8uvdn6nQ9K1cIL2v0rt6g==
X-CSE-MsgGUID: IWtfpWTwSwmkmFCVrv/6Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141453722"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:50:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:50:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:50:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:50:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXiAXvXGCnVYkIP8VvJCBC2aQ84X3crtbXQHH8mdYN8rDHA2TCtv7muR8KRTJ77LDj7BMse66wSBKbqy87F/EkzSTckL1szYfXSHRXM3D3JQ4PF/1TL2G3xLoDOI7hmKBxueKqZ/bFduAuh3URoYoGPVtIZYHRG2EZEI8P0Np7T7wDlKWGmUyc3lrGkA9BJrPv4KuJ4mo9BZQ7Bw1hC1lTpPgg+PFUJPUcuLkOBYSarhtXP6Cg+z3agrgxky/fZAfLR1X9TXPza/QYf9XCibw6o3HFS3HB0i8/RLRWpI3ZeAVajAOO3yUZcW/JfoWhkivAkgktDft2Hl2rRzbQzNCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G51v4QuxhfSFl61wg9FZIOMWWwyHlWNTOcVU7INzGmQ=;
 b=w+CXICa+yhGbUrrWCOEV9azWUv+QZO3YiKSJPzMkCMxSWMxyfrprg1FoidAaUah603pK3v6FbAyxud0Ec0eAiKWKGJIVJyyq5mjtGI294RNVLCZfceqAl5BnDYpkw6v2F0824aT7qjRmFvReCwOq4AFxJZCMUdqWkkf8Okty1EafSnkpHI78H7u1jewVbYUbcOjS9QPIVOxJqFo0la3PD65oJCzk+D8wGvV9yrGMEn6mMDPgUJVcZSMMj+rBd4/NQPC4du+CQNGkAAhgKi3ZSVCRye4wXH7srRvFHeHxAJs6XWy+Llohgyd3ShrXuK3s7y5961aWbN53yuzOWGi00Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BY1PR11MB7984.namprd11.prod.outlook.com (2603:10b6:a03:531::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 15:49:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:49:57 +0000
Message-ID: <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>
Date: Thu, 8 May 2025 08:49:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BY1PR11MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: 14737291-ad66-499c-12a2-08dd8e47fbca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z3c1SjNQQmdZbWlpWmhUcmtISTdwRVdENmh5LzNhbzJOOHF5dWpHMDBrSUNa?=
 =?utf-8?B?Lzh2bWFndUZxakFkQ0xva3pnQUJTMUhEbFdiRExuNVFNTnhqNHRIVlhGNTg1?=
 =?utf-8?B?QTU1L0RHUUswY01RV2VyaVAzbFhZczAxVDBkeVdqUkFNZkN2QkFGcGQzYWY4?=
 =?utf-8?B?dEFMTFZOeXhsSEwrZUxkbHQ1eEZHTWRTeDQwbUYwcUE3UmQyc1IxZkZpejJG?=
 =?utf-8?B?NENXdzlCM2Q1djQ3Rk5aR2U1YXlyQjJoNDlpd29MeFBkNk1Namo2QVg3bDFu?=
 =?utf-8?B?cDlLTGZJMW9ENDdiVCtud0hwbzBmZTluUG91MExJZ3hLS3Zqak5qMklkTlhI?=
 =?utf-8?B?WWpMK1k1UWUydzNNQ2hsYnA2VmVTWi9mTFhrdi8vaFQ1QmtMODdpdnJSVlJa?=
 =?utf-8?B?VXZkMkdVdjNpQVRLSlRSUklkR3A3MUVKMHBNQk9hOWIzN2pvL1g5VlVyT2N6?=
 =?utf-8?B?YkJXajFBeUVFdnVWYlJEWjZsSHFpdHY1OFpWV2Yvbm00RUhDWDZUSHgvNGJa?=
 =?utf-8?B?bDNxczVjWTkxTGNyR25WZGYyYzNWUC9OL0ZacmdJK04yVzB4TkRyZUxNRTdn?=
 =?utf-8?B?WklOZzI4am1FKzVsaW1wNFA2czNaM2VGK1I4UkxqMlduVUV6cW1zZFpMck82?=
 =?utf-8?B?aVFpMEpLcFdGK0xVclZ2d3lURFZVNWpFWlJKN0FwZmRQa21JRVlqVzM2V1ZE?=
 =?utf-8?B?Tk5mMldCM2JwS3p5U1hEUzRPV2lqZ1FKbGNvVkZQVzFXUE1iRW9qaytYZ1dQ?=
 =?utf-8?B?MEdxQ0J4anlrM1lhbE0wTXhOc0J0MGp3ZlhHMHhEcWFvaTI2VWE0OXNHZk1K?=
 =?utf-8?B?MXFIMjg3MTBpcUR4SEIyVi8wcTdwOW5Nb0FnYzZNRE00NnNxRTd4Q2h5YkJv?=
 =?utf-8?B?YjJDdy9qU200bGtLaW1jSEc0eUxTd0dKR0kyT21XOUNkZkpCbXhJditsQ05h?=
 =?utf-8?B?eDArM2Zpak1VL0xvYWl1dTN4N2tQUUdVVHIvdmpVKzUzK2hzT0M1RXZ6blJR?=
 =?utf-8?B?VVZiWm4yUmJ4aWhSRi9JaHdvalRyVGE0VlE5REVCVnJCb1ZiSUlhT096RVFJ?=
 =?utf-8?B?Vzk4c0l2OUJqN1NPSDhGd0tPMURLbU9tNGhBZ3FmNTVxaHRSZUo3bVd4ZkN1?=
 =?utf-8?B?YkxKMmc5S0c5cjVkWUEraStTNTdPU2I0dnMwZ3hPN0RpRTlXTVk5dEtqRUJJ?=
 =?utf-8?B?WUtMaldQOTQxNkhMamx1VWZrbnNTa0JmK1czdnVVbkhneHZlYWpkc2h3NEQw?=
 =?utf-8?B?WUxCS0hWcklFbml0c2Zod29CeHg1c3paUS9ib0dITjFBeDFWZ2gyUXBhK0VR?=
 =?utf-8?B?K3BKWkZ1WTZkR211dThDbFlsT3h1Q2poQUYvbldBam8wQjEyY0lwZi9kRncy?=
 =?utf-8?B?Kzk2ZjhvR1JDVHVSUlFZZ2dPMjZFMXhEcUgwS25BdlBaeDFTSmQ0L2ZhWFg5?=
 =?utf-8?B?dzRYQkpTNE41SXpHQTJ4VkFQRG5WMmgxYmNTVVcwZENqZDAxUHpONjdpMk1j?=
 =?utf-8?B?M2ptU0NZZlJBUEIxV2ZKUC9qODl1Zkpsd3pGYk5XcG5YWk90TEhiS0JkKzhG?=
 =?utf-8?B?V1ZrZFUrT2YwVE93MW1VM2VHcnFLK0p2U3E3Y3pEeUtLUytwcnJBTlV4WGpz?=
 =?utf-8?B?QzFWWXgwc0MzMWhqUHBiVGY1UUFxQXowMWUvZlIxUm1LMnkzb2t6NGRMMFZL?=
 =?utf-8?B?aDYxS0svdHg1WVJrb3JUU3JYR3FBYTVMYlhNR3hXc09QdXgzTms4VkNhOXlZ?=
 =?utf-8?B?U2tkQnRiTitGdisxTDN4RnoyVTFXVEJaS2dleGJQMnJ6b1hIbjVzbGhGM2tJ?=
 =?utf-8?B?Y0ZMd0d1b0xscTdybWwwUmN1RXB4RlJGMmtMT3BNd0JmK3d0c0EyQzFNNitR?=
 =?utf-8?B?UGU5S3d5SlpLTmFheTMySWtTUWFqdnRURTRwejhBTGRPcm5QWWZaUlgwZzRm?=
 =?utf-8?B?dFJIL3lZclF0Z1dPcWFtdmRyeTFoUVRpdVRJOUw0TnRPTXB6OWNESW84WU1t?=
 =?utf-8?B?bG9Ob3dsdFBBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjdTeTBrZElZenlmM2dSbEN3TXU0eFc2NVZDeFdPN0ZUMjVlMDV3dXlwbjli?=
 =?utf-8?B?ZU1LTGk3WVQwRG1IQUpQZGtlRGZWbXJIQWVJWW9CVGhxd3FoZmVKOEY4Vldz?=
 =?utf-8?B?UUhqT2IrRERDNEt6a0FiVVE1L1d4bjQxWk5JWldrU1dGd21yQmIweXVLVkYy?=
 =?utf-8?B?RU95QjQyRVowZjRNTmxrNWdmdFlMN0NkM1lOZE5TQ0krTzJyMDQvNjlvUGgr?=
 =?utf-8?B?Y1o0T2RuQ3J3Z0QrVmduWWZSYlo3bUk5Uk9zUHdlN01GWVJqVzZBS000RUdZ?=
 =?utf-8?B?Vit1NEtWU0dSbkhYdnlJaUJvaDEwWmhpc1RRWktOVWtSc3I0am9vUTM0WDBY?=
 =?utf-8?B?dGg4NktabnJ2Z09tUkt6bHYyZDEzNVA4QU80UXpNcDZxYUJabUx6Y0h0bGhj?=
 =?utf-8?B?WHFSSmFSWFI3bzFoaEQwMjcwOCt6aWNvNzRsZ3FDWFpNQTBOZFMwaXMxV2tW?=
 =?utf-8?B?WlhvUmgrM2VHY0hNQUJVbFUyVjROdmU0N2JTOXdUR2RUYlVuRmJDbXNSOUhZ?=
 =?utf-8?B?YW9ub2dudGVTT1YwYkZnYytVSlhnM0FaQUkxUk9tYmU0cDhjNUJ1bGhxKzVx?=
 =?utf-8?B?MnkydGRxT2RmcSt4LzhFVFZwRTFqQ1Q1a2JQbGFnVEdMb0ZoMXBjNE9RZDM5?=
 =?utf-8?B?NkljTmdGL1FHZzVPQWJSa2VIQjFOWDhlK04zaDZaS0RsRjZ6WGIwU3NCSUdv?=
 =?utf-8?B?ckh1S2hFNDQraEo5VG11MThoTVpiTGZ1R0RjRVcrbXR4WGpWOEtwOXpiQUR5?=
 =?utf-8?B?a0NDYkJkcGxWaTRpYUZVL3BiTlpGL01PNnhGeUZsaCszZURKNjNtVC9QOWh0?=
 =?utf-8?B?TDloWEwrZ2NjanRsYlRuYkFFYWtlNTJJYURUYWl6dllyRk0rRHVMNHI0UmVS?=
 =?utf-8?B?TlJjZ2dPcHhBOG1QVlIrb0RZc21XYUc5ZHNVVXJGR0p5RmxXL0hqQURmUThv?=
 =?utf-8?B?K3J3R2ZSN3E4K1RQVnFITU1kTXFJV1ZPYkt3MmlNVGM2cmdZWHdYRjlhc0lq?=
 =?utf-8?B?czlrdGFyYnZhaFZodFEwZzFJT05pQXorOTdPRlAvQVM0dXM5eE5kRUg4L1FJ?=
 =?utf-8?B?NVBBaWVySXJQa3pMa2JEUDVncllOUjgySFBNQVRJOWFJaTNLT1d6R1BQV2Ra?=
 =?utf-8?B?Myt3VzJaQzVuVWtweE9hYXJ1akgxb2xXMUVEUUN6K0VvVkd1djVWUEdoVHNm?=
 =?utf-8?B?MEE0YVkzSnJoTUpDWDBSOVQ5dzBFODhZcS81eWRZazVpak1PRmprdFJKNDhK?=
 =?utf-8?B?dkN6ck5NeXIvZVoyb1g5L2l0TFpwTE1sN1lnZmUwc3V0Y05ydjVHL1ZQT05n?=
 =?utf-8?B?Tkx5bHNlQVNQSkJBMjUzcWJZUGkwa1hLRzNTV3ZvRVRabGdSSGZXNDdiV2gx?=
 =?utf-8?B?M05Hcm1NQ1RiQ3NXN0x0KzR3THBHMFRLZzFNMDVFTFczdGFIbWtqNys5eGFw?=
 =?utf-8?B?ZzhVNUNkMkN4QXpkOVlFSnBHZTRrOG9qVlRTRXl6Uk1YdVE0bFVJQlE3TVVX?=
 =?utf-8?B?RUptTWRqWDQzWGgzd1JjRWNOSHFiTy9jaHgvOUhLRStCZGNLbUthYVhmcTFU?=
 =?utf-8?B?Z3JlaisycUlRR0FaZkJtV0REcWVkOFZUSUxYbCtYNkdZRkdWcVh1UmVEMGw2?=
 =?utf-8?B?aFdpakp4c3JpZWhIUGlRclE4b2VmeUlvdGNVN1lqcTZFbndGTzM2KzNicjNn?=
 =?utf-8?B?N1hLNm5IcjBOMmk1ZEtXQ2Zyems2cElEWXNVYXhuTUhOamk4cm5NTGNraGZJ?=
 =?utf-8?B?R0NmbzJXQ1RTeU1Wd3lZQ2RLaHViTVpIbk9NTkhGNC9uSGJGMWRwdnRNWnZz?=
 =?utf-8?B?WEhnK2pmbmpJVTdxeW8xd2dGTEZhanluTVN4dXVtL3dSZmp4QzA1c3RHUUxr?=
 =?utf-8?B?bEUreWpZTW5SQVBHMHRwdDI5YXdpZXZZcHg2bW8wSXYweDEwQlFXOCsxWTI1?=
 =?utf-8?B?YTdDV3ZZZjVhTFI4d0JVMlB0OFFJd2VpbEsxQXFGVFhkZGVJbUkralYyb2Nh?=
 =?utf-8?B?N1dJN2FudEJIMHBpaUUybFBQSjRhK2JnRlNmcHNwUW0zdHgycFROeTFWbXAr?=
 =?utf-8?B?MlNpNHpJcVhYQ2pXOGxTelp6YVNLWHd0cUU1WjhrajRDbkFpZWVxa1pTTnho?=
 =?utf-8?B?YnVFWGdtZzF5RElLakdCN1Rma1RiVDVWVVNaVXdzaVluK1lmM1prU3NUSmNI?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14737291-ad66-499c-12a2-08dd8e47fbca
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:49:57.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jb+vWbn8D2PnBPHzOk6C3kEoMvVT1A4IJqB0S6HmzsDMZx1hP8V0xhW8KAOu0g2GpcASDlkzpcMFsq0Lc7EqG52ve3Po7pcQD9UimxXbVXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7984
X-OriginatorOrg: intel.com

Hi Tony,

shortlog nit: "fs/resctrl: Support additional monitor event display formats"

On 4/28/25 5:33 PM, Tony Luck wrote:
> Resctrl was written with the assumption that all monitor events
> can be displayed as unsigned decimal integers.
> 
> Some telemetry events provide greater precision where architecture code
> uses a fixed point format with 18 binary places.
> 
> Add a "display_format" field to struct mon_evt which can specify
> that the value for the event be displayed as an integer for legacy
> events, or as a floating point value with six decimal places converted
> from the fixed point format received from architecture code.

There was no discussion on this during the previous version.
While this version addresses the issue of architecture changing the
format it does not address the issue of how to handle different
architecture formats. With this change any architecture that may
want to support any of these events will be required to translate
whatever format it uses into the one Intel uses to be translated
again into format for user space. Do you think this is reasonable? 

Alternatively, resctrl could add additional file that contains the
format so that if an architecture in the future needs to present data
differently, an interface will exist to guide userspace how to parse it.
Creation of such user interface cannot be delayed until the time
it is needed since then these formats would be ABI.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h |  5 +++++
>  fs/resctrl/internal.h         |  2 ++
>  fs/resctrl/ctrlmondata.c      | 24 +++++++++++++++++++++++-
>  fs/resctrl/monitor.c          | 21 ++++++++++++---------
>  4 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index 5ef14a24008c..6245034f6c76 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h

This needs to be internal to resctrl fs.
resctrl_types.h should only contain the types required in asm/resctrl.h

> @@ -50,4 +50,9 @@ enum resctrl_event_id {
>  #define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
>  #define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
>  
> +/* Event value display formats */

Please add details about what each format means (how it should
be interpreted).

Reinette
