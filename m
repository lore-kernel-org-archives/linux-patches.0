Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC762DFA46
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074102; cv=fail; b=SHxuGdfprtywepQvMEIzr//DkMLZYNtbj/gN66p01HITjdmdjCtCH3JvyDq6fcVBX1e2A9ilFKdfTYGBr/tC24jOs9enj5X9tVqKQjsGIVbNZA+FLMup/4sPFKp6xweJCmBz8V5Yanaee0L9o2CSbDBMdcAfRmemZIlSp/qccQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074102; c=relaxed/simple;
	bh=rPYzyQFS27ISeoFv4ep1BeQXOhN38/75osHnrCDCwXo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fM4+IOOQFIbG5BVpdz7FyY3HsAZa7zeZbX/D8uR2mfVdmi/pFfPCOsU6Awi9QhgYm0tVq2R3Uco36Yx64MzzgesC03tQ4TTqSCKxR1D5rQdeY0Ee179DlESfeGCm2PmNTDgne3VXMDUJJkHFUlabqFTnNF9JMdWxC3bDave4dUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+g6TUrp; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+g6TUrp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074101; x=1794610101;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rPYzyQFS27ISeoFv4ep1BeQXOhN38/75osHnrCDCwXo=;
  b=g+g6TUrpIkrPg5+9eHHlTsawaY5EL1rFZoJ96AiZLdUD+bwVhJH6njEZ
   uKbIb6HNtDsvkzx4kli9lVl3ukTbodj1duZ7HTH8rxsSzKjYDS1npxuH2
   5vf1MRZRyLTFQPUkN2/PjUo9qoK7B78Pl0IukqkjYamDl4HahT1gSLYEt
   RxZODkXQ5VTDmhFZkmacmEmgwLPNFN/z6JaCUiLO5OfKwGavqIuRcpjao
   ztn9+UKhYjmJdWE7oQFpv+wegwGyMJLtJj41YrvcKo4jjcRujHHIRTSM9
   Yv7pP1S54MVw8KxBwr0lAemvNzV7ymb9Asfcn7oPxv8z2ilnnir9Q+siA
   A==;
X-CSE-ConnectionGUID: HyHPTsudRl6cC8wFXMMYBQ==
X-CSE-MsgGUID: HnSiw+U3T3K+LJ5W47c5eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="87812488"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="87812488"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:48:21 -0800
X-CSE-ConnectionGUID: lBKWPJEJRIu3VHeKUtl0iA==
X-CSE-MsgGUID: aFr+yQTxQpmdOgCeMcffkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="193722578"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:48:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:48:19 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:48:19 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.23) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:48:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8bSWnB38NcO8yLPAVY9sVt3pO9HjQuj9V9CE+2FVD5cYvZMU7Fg3AU9QHmb+KRTt2syRJR9w4NLkBVhOntYsnsJ/5b2ddMLzVRTw4YwXowrzfRZUJAsrT/WmcAXrPhiQhKldrP+5+RvvG5vnBFEffhA3n9R1q9lcRxo48lhg2i4vYBEqfow7QD353+WrIZ7XX8NXqONfE5VaMq63qImQ55QgGFEglI/DpIE9/sCaXlTmtlD5ARGb6dgjfJ9t5BaB8SEMwxRKyiJmyxoICYY9hyPEzmzkff+hqJj1mA8oxeqzhTVKeRKpzSXYPIbtE3o+whgMBeNs/2lBXesk8dixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ePx2HJr2V88P5tMAC2vSWcrnlvCfqmZOuhQtrma2Y74=;
 b=GKoKOIORmzkD+y999Q9i674mkIhvYW2Uo+X4OcD+QwlBRGUG25MKFm2LAg9exaGN1m+5LCQ8crfrjVsqcYD73lgIZ+FKTagjk7zAcR/WVgVe4DAbMmQZVN+Aep5uGhVjIy2xZWOiTY9RueJY/Q9VfH9Gp6tO8SgpKVczp9zFWs2TxZpURTPjVg2JA4gfnKoY2k/kt6PBDbsL7j0UFlmLlk5pjBsZRmvt6YZrnAvACnCzbv2tBwjBCwNd3D8z/CHCSRJMascb519ks4cWGn3upFoCZCf/bbsqKfj9W85WFbha/aaHmQgfZhX+F19eP+LTG58OSZkI+eZjrek64YTGyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:48:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:48:17 +0000
Message-ID: <a5ef642d-956a-41e5-bed0-102cbc4562cf@intel.com>
Date: Thu, 13 Nov 2025 14:48:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 22/32] fs/resctrl: Refactor
 rmdir_mondata_subdir_allrdtgrp()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: ff3246ba-68d3-4d72-e788-08de2306bcc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SXRKSW9GS2cxQ3VWY3IzT2M2WnZVUHRLQS9lU2lwdkFhejdKNG5raVA2Q3Ew?=
 =?utf-8?B?M2JDeG9XZXZTUmdaZ2hacllCKzI4ZXJSYmVha2dHOWpnVXlqdXlkOUIzVFNL?=
 =?utf-8?B?YlF2Mnp4S3UrN0xneXA2cDUyL1UyWDlPVE9YWjJBM0ltcURFNkJOUFMwR0Np?=
 =?utf-8?B?WjkzRVYwbjRxajN4TldYWHlYSUFReFhvTUlsOXgydWhmQUs3S2UxTXRUN3lz?=
 =?utf-8?B?U2lzRE5XWG5hUUEyRG9aSDBZLzAyTmV2UVg3U3k2WVh1Y0VKOGJtMkN2SHM5?=
 =?utf-8?B?YXkzMWl3YU95VGQ3dkMxZnpVWmJndVJoRVJ5cWd2MTRYK1Byai92RS9pOEht?=
 =?utf-8?B?S0JKb1MyajQwbkpsNDZNTUVFUUEvY2wrc2p2eFlMUXFCaE5UdFExa2tBN2V3?=
 =?utf-8?B?dnFSV2ZPQWs3dGpZWm9lR3VBeGNIVWJZakFVek9wQVBXZk1KaHAyVUlmQWFY?=
 =?utf-8?B?VVhqMVN5dzRhaUJQanN0WjZxVEhESXdyMWdqSzZlQUFaWHpEU05xN1lmaFZM?=
 =?utf-8?B?WlFTcEdCcHRVc1NTbkxyYWdmWnNZQVUrdU9qbmhNZkF2eFVzLy94R2pMb3Jy?=
 =?utf-8?B?K2tXT3gzTVp3L0RleGE2c0Q2WVdpSm9LVUZ0VUFxb0o0cW00bmNSbkErOFRP?=
 =?utf-8?B?MVcrZWc1aEljWjh5WWt6aVpOckVHQU1obE1xaHZNMURRS01kMzFnV1hrZ3Nj?=
 =?utf-8?B?RFJZNmJTQnRKbU1TZThqdkRYeFJOYisxMjZRTjdYRGE3ZEFvSlgyZGVUdHgw?=
 =?utf-8?B?L3FXbGVoNWs1dFp3Y3VYZ1czL05KQk9WS0FLc081M3FWaFVCTkwvSUpOdXhm?=
 =?utf-8?B?RzIrNHptNkRkVVh1YTExaXZ2Um1aY0tvdDR6MmM1dXZCaE1aRUx0NjF6eUxE?=
 =?utf-8?B?M2NzTU1Dd3ltM21jOEhLcThtNzN5L0tVaGpEOFJZMmVqYS9YdDVpV1l2M3M2?=
 =?utf-8?B?Vm1iTmlxdzdIOTJ2L3ZtQ2J2ZktKcUQvczB0dG5QVkVrbUQ4bU9adm1wTmZG?=
 =?utf-8?B?TDkzdkN6bjdwcHlneTJ6U05WR01wZUJaeHB4NENjM09VamgwZFdETitFQlZV?=
 =?utf-8?B?dythVWFCTFJFTHNTTHc4NU1PeVIxNDFvcVNKVzd0c1d4SVlMQlZnMHhRYlZT?=
 =?utf-8?B?ck5zemhCZ2Z6aHU3Yjd3NHdzRjA3T0VMYjlvc3ZCUlpwaDdDajIrZy9HR1JD?=
 =?utf-8?B?V3VRUE1Cc3ptd3VtM29hTGVrZi9MSUhWUUpwZUZQTnovNngvcFl5WFR1aFJS?=
 =?utf-8?B?TE5BdlNpOWhpL0FkNkVVYTcvZU54aWovdWI4UThVbTZweEJxRXhvWStNenJz?=
 =?utf-8?B?VmxiQjRrdGUyb1dWZE1xRTl3eTd3YU5YMVArb01KZzIzTDB3TWtrc0NXQTB2?=
 =?utf-8?B?SHJsd1Y5TWFGSWpudlJBekE1VXY1aVpPWlpqbGEvQnc5VW1QRUpKd2F6WG9X?=
 =?utf-8?B?WW5lT1AzSW5iREkwVmRMSnQ4VVRUZkpEYUZCQTU0TXNFOUg1cDR5NmladFo1?=
 =?utf-8?B?cXZHbkkyRUVlbFhRa0FGcWwwTnhadWtsekJuclNjTWRFd3YrOFRBSDRSRk5m?=
 =?utf-8?B?SVEzRjFsTzNyajd1VVBYN1k2ajJya1l4amY0emZRODM5L3g3MzI5ZEFrdzlW?=
 =?utf-8?B?VlROM3AxempER1Rzb1B6cWtaLzRpMjMvM1Q3Wk1kd3NCT25KWm5PbS9RZzIz?=
 =?utf-8?B?T3JPN04rcUZuSGh0TDNYWmdKTTNyOERWMUM2aks4Y0hRQW5RQWJuZGx2Tm8z?=
 =?utf-8?B?aGpmN3RLQkljb1VNUlJqSDZheU85T0RjamFsMHM0WFJIYm1lWFg1WW9GaXhB?=
 =?utf-8?B?OGpkU2IrL21XME5lZzJIWWs4Z3Z6QVJwVlFVV1hwS0FKb1hoQ2FTSWJwTU43?=
 =?utf-8?B?M0ozYVcxdDRPUXFxV2MwaDVHM3FaSkw4UmJNYllQSlpwQnFLL2dOR2cxSmtZ?=
 =?utf-8?Q?wSrkzRB+fOieEvAgHAKjzSfbr5SZOgRQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnRHM2RwcnRENGpoMkt4aEc0Nk1aTVdxaW9SOEVMTlB5UDdwa0dsbHMySkl0?=
 =?utf-8?B?bjJ6dk95L3NQdDVmZXdTTlBlOGdYUWpid3JPdGE5TDBRSjVMUkZuOExYUVox?=
 =?utf-8?B?Q2FzVm0vK3Izem9KNTFJRXgxWFR2RVN2M2Q1ejNXUVMxSnBLWTFoanpkYzdw?=
 =?utf-8?B?OHNMNXVmSmJ6ZWx5QTFibkJNUGF3bG00WXhYTEVlVUQzMHBqTkJYQlViRTNS?=
 =?utf-8?B?QzZsS2RFM2I3OUk5MFQvMDY3MDgzZ0xoeFRJSTZVUmFnSGNBMEtwUit6cVoz?=
 =?utf-8?B?MW01RksyWlM1QTlobHlwd21yV29HTGZaUGVaUk4xTTJnSUJtaytLNHdzcGll?=
 =?utf-8?B?TWE1aWdjMjJnaXZscldZaGtiL1Vab3Z2TTZXV1RWajAvY0RrTFl4S3kzcFBp?=
 =?utf-8?B?cWhqM2xHMUNOQlBGZTQ0RkQzbm1KSG9QczBPRVN2ZlBRTHVRVU40Nm4wejdi?=
 =?utf-8?B?Y3I3Q0ZwVE80bVJ4U25ZUGsrbitGSkl4WUxCemVTUzlNUVVQdWJjdEYyeTV3?=
 =?utf-8?B?NUhoQS9VSkZtSmVmSUoxSUZ6dm85VlcvZGc4UUNxZnphMjZSVW5uMkh4S1Rl?=
 =?utf-8?B?RHFYbG1DQ3Yyd2llTU5VSHEzM1Mvalc2RnU3Z1hGVmthZ2xyc1lIMGRvZWVs?=
 =?utf-8?B?R0htNTIvVW9QQjZVa0tVQ2EvbFFkbjYzR1NkNUhUbndjVCs2TGJXVE5nWVhq?=
 =?utf-8?B?VXZjcmdCbEkyT1NJK1BsYXY0d3VzOGx0enhEQUdRQVptWGpqMDhOM3hpbHRZ?=
 =?utf-8?B?WUU3dFlRVHhRK05COVEwbWFYbGlBMC91M2lZTUxCQStJNG1pTGZmTnF6OXRx?=
 =?utf-8?B?SExiMGtlTUloUUxwR284QjNEMXVTUE1EZVJqdGErQkFKRXV3TEw0NVNNemEx?=
 =?utf-8?B?ZWZXTGpzeVNvb1JHRjJkejh1R25odUJxb2V4cG15dXNNMmliKzltZ3VlS0xK?=
 =?utf-8?B?T0ZFaE1Tck53QlFuTmR0Rm0wMlU0L1IwWXN0M0FXRTZqM0RUZnJ5QnBBV3BW?=
 =?utf-8?B?aUtTRzJ3ODBaSSt1Z0lkZVdsWUcrVmd4bTBjNmNKUnZPNVhqTWd3Vm52VVJz?=
 =?utf-8?B?dWhYRi94c2RzdkdEai9Gd0NPMTU1dHRqL1UxK0tBSEh4MkNWM2RzUFNuVXBo?=
 =?utf-8?B?MXROL21ZaE5JYTd6QzVyVG5jUThRNkFVc2tyMTVFcXYyand3ejkxd25WOTFF?=
 =?utf-8?B?TW1BM2NneTIwbU1rYlFScmhhZDg0cHduRFNabE9YdkRRVXpGdjFDOVdTV3U1?=
 =?utf-8?B?MExDaXU5bFNXV3lXU29CZ2dPN0ZBS2pmbHVKbDkyazc1R0xMdGVNUDlwTHY4?=
 =?utf-8?B?Wkg3WUtYaC9EMFBNaTlORzdpYXJjZHA4Vi9vdXZSQnVXYnBYdng3RERTSm40?=
 =?utf-8?B?amZUMTYzaGwzV1JWRFJGenUrdWFlZXRpOWttbkd2R1pLSUJHdnc1WnFINnRZ?=
 =?utf-8?B?TFFsRXJ0dGdiTWVlOU8vM3lDUEZqUy9iblduejRvNkNobFRxSjhSeTRUWm1X?=
 =?utf-8?B?OE5ZbU83QnRqSEVwYmp0cW9qUGtsS056SXczYzVwa2JTb25yY1kyb2FRRjNH?=
 =?utf-8?B?TXpZandUZFRyTStFTTJrOGsvSW5vZTFRSVhFMm9tYiszZUpKUll3WnhXUEI2?=
 =?utf-8?B?OUdjK20zU0VKY3h2WGdqeUFYZHRxQktMemk4WGFiQ2xYWEpsY2xGNVhrR00w?=
 =?utf-8?B?VjB1ZFVOdGIzL1ZqUGwxQ25ITG8vcjRJSVoyam1MRitPdzRFQnZ5UEJtcE1K?=
 =?utf-8?B?WCtuV1dLaTB0em9DSkFPbytIRE5PUDJrYVVQbjZwdjIxUUpNSllPUlZ0c3JS?=
 =?utf-8?B?TG9FU2tpaTd3cm1ENXhLZmpCV0pjT1RlN0FqME9OOTFsTzAxNXhjdHYxd1NS?=
 =?utf-8?B?SHlWZkRlTDB3d1pxem5Pd3lDZE5od1kyOHZZdzF5SWFsdGNVakJoVkNRSGlK?=
 =?utf-8?B?bzBVQlZHbWQreVNRdXUxR2Jka1ZocUV0RnpHOWpwRGthODJYKy8rZ2hVbW1w?=
 =?utf-8?B?WUEwZFFkK1NvUkVPalZDK094M0lvLzFVOXRNRnJVdGVDMlV3bGplZFFzRmpF?=
 =?utf-8?B?dmxnN0FyOWdobEx3dHBscjd1ekluN0htenFkMWh6RzdGNUdYV1V1L2FuWW94?=
 =?utf-8?B?ekt5cVlDTWFaUSs1ZlVyWWZpQWY5VmVoR2Zxc21SYy9hRC9QV3J0dElzRXd0?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3246ba-68d3-4d72-e788-08de2306bcc2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:48:17.8095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l8iFUGpbCcQnLttTU2yHHQpJSssaIa5p/R80StAPtmE8dtj7SRZ8UDlfNppHwGHJI9jzNGSzDW4NZ8RkVADZvWYbU2bKh8R+GC6stLBOg3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> Clearing a monitor group's mon_data directory is complicated because of the
> support for Sub-NUMA Cluster (SNC) mode.
> 
> Refactor the SNC case into a helper function to make it easier to add support
> for a new telemetry resource.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

