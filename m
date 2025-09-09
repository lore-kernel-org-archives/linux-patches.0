Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A836267B15
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 22:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455984; cv=fail; b=JCqF3yLiCfotB6h40Deq/1DLLYrFBzUCfzdqcrk8uMyeBUso9RV3o8RV38QtIjHsyiWECcc9Qx73vb312CRhXxY5InjlitxdohbmSoRt9ET9ZHjSW5zs1nIBzWsczX9HA8S1tkg42Ghl9UPDN8rfoZiiFOUS6k5bEY1ybC/iLOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455984; c=relaxed/simple;
	bh=4KBxSnDImQgfVW0RPBESOP9nYQmzW0AUzLF3dFD7Q6o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kGSOyyqe7KzrL5CVSikDVUUggRjQa/lnWEjNh7UV7K+r80o5gq/Sxq67xqP+V3snq8845EuRvNp6PhX3x1xyFzJDxWuvd5MnFO5i85ng/j4njODjajWSH8nxGszky8h1sqpRe499O9mTMEaAP9ifWSByeXwo119rIFQstYz0+ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MORArIoW; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MORArIoW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455984; x=1788991984;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4KBxSnDImQgfVW0RPBESOP9nYQmzW0AUzLF3dFD7Q6o=;
  b=MORArIoW+kqbtSECIn+aKPZFITOPVWdn3CxlQA7ekGORbLvH8CDuNB0V
   w6zMMB3Kb0sSHNMq6UNf7tFLosxOaEEwbMI2TAhavmSJy6n0csLkFKdaX
   nTn3k4EFrJXebUBIvTczDErmQP8iOzjl6wnwQyNml5mj1CE1nexoj63Iw
   3unhYsobZYO79sxhFcY7yFBMUXn7ioWlOuNQQ065AzeUYLP2tMuAlOc7I
   Jivg647eomNUyJECCUDAK5ofn7ISsvUx/zethHJNgv6sMgig9y/IhCIRb
   5BDY3p8F/y3n1GBEMKkjkMBv7p0Gw3wm6zN9Dy444UO4+PFMRnQoll+TL
   A==;
X-CSE-ConnectionGUID: DbW/cWyqT1ub4rBao5Z1sQ==
X-CSE-MsgGUID: s6I/ZU6gQU61dbsxcmePJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63586248"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63586248"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:13:01 -0700
X-CSE-ConnectionGUID: 5G96K/m5TZ6W06SPCOe9Wg==
X-CSE-MsgGUID: V5vHU0BVT6aS1VI2ix10Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172783500"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:13:01 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:13:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 15:13:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.66)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:12:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBt2GNSbegRHzupIff9niAuttO2DL3wdTRqQF9LZ/5Ab7087CaFjdntJMMVZ8nK2NEw1dXVz1WAMgMEQwKx11vdN2OqF9sGvZk8TkNoqTmTI+o0n/PC9SLWpaOdAfALvbrOw5uXAD52Hs97+4SiBG/jL57UAfVkWWklDqA4V42g2yfAbxgjPw3QEEzMTNNZl+Aa2EmTXSLAsvaq14kwfCXIEiqbNrrq8XLH4KZtS5PGO/a7zxwfCwYhThOlw0bdsxBbm4i9e7a6ly3yemvmtnkzulwhmN1GChz4ErM9OMnaPVjumj4vMwR9ZcMxNXyKYMyBkMDZ5p8LndcFqYll9cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OB2Ix2puLtwgXZ4x4m/yJ4WS6MPYK6Y9ort7VWWweY=;
 b=i1GjVie9g5p9KI2OquSGsHnSCYbyLIemmzBNy4ocUMynf3aQN0yq+lTqszFpd8pEvGSQ2agltbfrbEZbgpnYgkMQBxl6s/30XfeoiYPOXmS/clTJWDZtdar2cxLMVQE0xmuZMcgEaX/puj1vFR6PNs9f0P8dFm2fEh4e9WbkyXO/aK63eEppsl9J2vEeChiSBPBvbdRLeV5XRIRZJIeSv1cKeUAZqLVz62eKav+pQmrTjksZ6y2tqazElsO8iKM6KHtZQXf7DU5asIftb7f8vunVbaM70eZs6yvgilV6P32eWzEBxPja5dY14K7sQYuxOnHWQ97qv/LR/wzCt8aMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4836.namprd11.prod.outlook.com (2603:10b6:303:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 22:12:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 22:12:49 +0000
Message-ID: <df10c9ca-b195-441d-bf4d-57e543a73cd0@intel.com>
Date: Tue, 9 Sep 2025 15:12:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 12/31] fs/resctrl: Make event details accessible to
 functions when reading events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0310.namprd04.prod.outlook.com
 (2603:10b6:303:82::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4836:EE_
X-MS-Office365-Filtering-Correlation-Id: 819dabbd-1df7-4d8f-dccc-08ddefee037f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2w1VU1XQ3hYSW1DUHFrMU1NSm5EZnZPMWRPOEdNM0pOLzBSTStqRDNFUW9L?=
 =?utf-8?B?YkFzVnBrbFJZRzJyS0Y4UWptOUpnK1lYWlYxWFRuWjArb21EdGlHNjNSUHdN?=
 =?utf-8?B?NXlOOHlQdlppbHpVT2JlVFBnaUFZcTdtSkx4bTdDUkxHaUJuZ3RRS3p1bW9W?=
 =?utf-8?B?Yit1NENhRUcyK3BpOVZMR1lKWlJnYWJCckpTeVRaU3N3L2hQcTlhYUhYZUd2?=
 =?utf-8?B?cXZ4L0tKK0d3M1Z5cGRuT1RpcmQzbkVkSWl3d2d1NDZVcjVNYVBZaSt1WExV?=
 =?utf-8?B?Z04rQWx0SXNwaGhCc2RoNzkxTFVwM2FvK2k0cUUrSzFMTStESkE5ajV0OFA1?=
 =?utf-8?B?STFMOXc2Vm9RL2pFWWdGeGZEZDREMmtzVmx0cUVudUhTTFBUVDB3OUU1YlZM?=
 =?utf-8?B?NlowdFU0YkFFdnBnYVFmMTE1bG1uRkFtRkRveStJRkY2MjVRZUZsd0FkK2N0?=
 =?utf-8?B?UzZwRS9FbmhjM3pSL2JkeWxZY2ZIeEtuSG9naWJ2TXBzdzk2ZW5uWkVzUnNE?=
 =?utf-8?B?UUhFRHlFRGhSSGp3VDNCWGhlWGlLekI0c01qZ29jbnZWVGFudFRjcGFjb3BU?=
 =?utf-8?B?N0NCck4yWGYxZ2w0Wk45dUhLd2FhZVBQR0c1ZWVHNGRxN09waFQ3OExOVDU3?=
 =?utf-8?B?Uit1YUE2QW56alR5WWoyc1cveHg2YXVlcTE4Y2JJY0pLZTBhNWpKc3pkU0Q4?=
 =?utf-8?B?aDdrVS83TXZYQVFFMmdNTzRpUFpGRS9BTUVPWEV2cEl5cUJhNmd1TkdFcVRO?=
 =?utf-8?B?VXQxWXZBZWVTZHU4NDVocktMMFB3R29EMzlMaGt5bERiNWZ5ZituaU5WaEQv?=
 =?utf-8?B?dHNtaS90SFpqLzFvbk53eFU2eS9xMEF3cFZ0dlhCK0hhYjJ3YnlwZ3E3TGNO?=
 =?utf-8?B?K2VPVHQrbzdYdEhaVFA1QTd2SEE3MXpoVlkxMVpjQXBpWXBUTUdoY0hyNUVQ?=
 =?utf-8?B?citIbWQ3ejUrKzNhY2ZkRTluTWtock04Q1BDc2xRcWFxdzJIZkhlcVE4M0Jh?=
 =?utf-8?B?OTRqNHh4SG8xZzRhZVphbityQ3RCSzd5ZjhVRnp4STdWbGZoUHdTTmkxMmFq?=
 =?utf-8?B?aDErUW0yY2NIT1U0dmQ2Z3NHa2YySHA2LzZQY05KdTlrc2NCd3RMaVI2KzR5?=
 =?utf-8?B?QytMTGQ3VzVXR1FpMVhpSUZaZ0ZHVHhESWpPckN2SUpIUE1Yemx1a1prdllK?=
 =?utf-8?B?NHVuZWFHU0laODU1N1VieHpPM2pEdHNxMndHYnQvRytvMjQwK1pzWm1ZT2ta?=
 =?utf-8?B?VkRCdFJXMkt6YXB4bHJ0UmtVMGVVY3NLa1FyWHFDMmRWa2ZJTHZ6Zm5OcWVh?=
 =?utf-8?B?WnRFRElsRitEQ1ZvU3BqTVpnQ1ZVdDFmZEp2Tmc5ZWMrRmdSNVIzWkpLSDNQ?=
 =?utf-8?B?bE9meVpWRFd4cTZadUdDaGFwbUsybmlYL3JuemRSdzVLem5Wd1FBTnQ2U09T?=
 =?utf-8?B?NTZRNWplZlBtdG5pdE1rbFl0Wnp5VEhXSloyV2Z2SzR3czlkcDM1Z0ZRc01T?=
 =?utf-8?B?d3pUNlZMbHhCRjJzTm80OWt1cEtxYnJzdmNadEdoUFBzMTh5RzJ5c3JxcXhI?=
 =?utf-8?B?cS9MNUpGbTVHamQwc2tLWDUrZzhXQnhNTXpjNGVUdFBjeW92UklVZFVBZUlx?=
 =?utf-8?B?Z2ZaVmVjSWhFd0FraUdqZFdPOExOa01LbTlDc2pvdHBPQXZEL0dWMEZLcklH?=
 =?utf-8?B?bEIzcFZENXJwSFVpNDd6djVNSGRseTFOelBqc3d0elhVMUR1LzlXcGxHMmt3?=
 =?utf-8?B?emNjSWRzU2RuVDhlZXlUTHdXVWo4OXllU2NCOXhpUDJ0b2hlVW5jaUZ2dXZL?=
 =?utf-8?B?ZEV5SUJCd0ludnZnZEhVODdUdGxmQmlTUkd6N3l2YnNQOUxjZnNqYWk5akVa?=
 =?utf-8?B?OWF4MEZwMTh3eUZHNlZBbW93R1A5MWZPU1NGMjhORkxYclIyZDVIWnh6aW83?=
 =?utf-8?Q?K0sS+xEWJ/U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDhjWWkvSERxdWh6RURnbW1yUFBxcXNzb25iTHJnTDk1M0xCTnpYZkprNDlu?=
 =?utf-8?B?aE5sQ0syZHRjdlQ2SWFHempEYVZ3Lzc5QlpvM3JPemJaNjdNYnJxc2taZm1L?=
 =?utf-8?B?Mjk2cXczL3VHT2hxVWlOTzF5OXZYM2JkYzc4MzBJWWFRSVNVRFdneEZPRGJo?=
 =?utf-8?B?dkJWc25UVGttdHlRaFdVV2d5WU1xQWl3aFdFNHcydHJDWktEZzhSYU13Q3Fj?=
 =?utf-8?B?UzZTSEV3OWdMdDBoQVIzL2pwUGF3MUhrTjNWNW5hSkxFQU1Nby83NXdZNzRI?=
 =?utf-8?B?QjRndE55cFkyTEhYZzN0SDRsTU0weU5pTFZ4T3JuQ2VBUzdiMlNHWFQwMWlr?=
 =?utf-8?B?VUhMVEZlR2RlbXpJSmdCbTE1L1JBTzVza0hwS3djcDZiUXg0QnRCaDRLODNx?=
 =?utf-8?B?SGhtWUVrZk5weEJZczkvMkNySnlLVXYrVDVLZlo4c2toaDQ0VnR0MGxBSXdM?=
 =?utf-8?B?SVAxWTZBc3d0REFkaTYrRWpWZHMwOHZ5N1dUNkRSMlN2V1JGczFEU3NFTjVM?=
 =?utf-8?B?c3RBeFJIVUtVK0pYcDk0eE4zUDgvK1JCcElxRXFhR21nZnlrWFladWdKRDE4?=
 =?utf-8?B?cWpjL3U4dFIyRlhMdGtZelpnUTh3cEthUEtKbnpWekZ1a3Y2dHpRV2hjUml5?=
 =?utf-8?B?dmJFU1A5dXNFU2FtSjI5bHk1TENnM041MlNTNVhYaWdMTWxWN0RNRGtvdVBw?=
 =?utf-8?B?YU56S3VyQWxEQXFXNE95VTdlbnh4MUtxZnpqQnBWbHh3bXNmcm4yUVYyMVQ0?=
 =?utf-8?B?WCtPN3hDUi9MQ2UzOU5id08vUFYzeFI3VnptbGVCVzd3bEFaRHpHZXlYZUI4?=
 =?utf-8?B?WXJZRHJFcC9BMlFxSVVYeWFQTXRTZHgwS05TSFlNMUdqdEhpbGJPMUlKblQ0?=
 =?utf-8?B?aDBuZG9kYkpZZmFVZDBIdVkxdHlrL3czRVBnTGhiQ0x3KytKeTE3R1RMUm9U?=
 =?utf-8?B?TGsrVkQ5OEpFa28xVWV0WkJTUmFBcnpJSmxtbnF3MWpmYXlpYWtaZGh5c3Ax?=
 =?utf-8?B?djV4NlNiTnNGMkhRWFY1V3Y3d0R2RnpNK2FJMS9meUx2dENtZE55L0JMUk9l?=
 =?utf-8?B?K0hybXBFRFhOZUJRY3hHZWFTRW43Y0F4YUpKbnluQUFmd2ZWME5Pcnc4UHJl?=
 =?utf-8?B?cHUzd2VsbXdkcXpYbTBERDhidkU2L2FaM2p3WmwwM0pwS0N1NForYTdkUlp6?=
 =?utf-8?B?R1ZZekFzamt2V1d3MWVUN2xzUHA4OUZHaG1iVkFDTWVrTFp5ZCtycE4yeStK?=
 =?utf-8?B?MmNKdXl5N3dZL1NLSk50QSt5ZERkQ0VDYytoTFVwV0JHODlyVWFBRFpqTVJO?=
 =?utf-8?B?MmUrYjVVQi9jTGwzeVYvNnhOT1BRSTNOVjZvYk5WU0V2ZmFnamp0VU94NGc0?=
 =?utf-8?B?am5tRDhQZkxDbm9yTS9NM3o4TkNNWVMvRXNWZDlKRnBBQ21TSDRCbVFFNE9O?=
 =?utf-8?B?LzFyb1FLOW9SaEplcXFyOGU2VXpIVStrS0xBV2VpbnJVRjVMNzAyZlk0cmFZ?=
 =?utf-8?B?M2ZzYjNuTGJtQ2xBRHdlcFd3T04vSGdOMjBDNm1MZk5OWVRVelEzTUFaSjlE?=
 =?utf-8?B?ZURGYldJcEVkRmk2bXRPL3pVbFJEL1IrTG5CWFBJOXZ3eXVYTTNFN0RwVGtM?=
 =?utf-8?B?YzZkMFVEZ1BsdnM2a2crTEhHU0l0VnVHdGZsYWEvWDlwL1FmeXM2VnJ6UllZ?=
 =?utf-8?B?L200SThuczJqOGk5OFdPenVkTWROY3hwcTZnc3RBcDA3YjVJc0hycHZPMDBx?=
 =?utf-8?B?VWJBVEdOUnJTdjFBYldEOFJJWVprRjhkRDNTcm5mczRmZklOamJRaVpwMFFq?=
 =?utf-8?B?OVpXMzFhTmRIWXlhZnp2ZXVOSTEvZURxbktzVHlvM2tIRUltZFVVQlV4dXc0?=
 =?utf-8?B?Mk81TUIwOE5DWlN4Wk1PT1ZIaXErYnB5VGdLZllnSldsd3ZSM0d3OGpaN1Ra?=
 =?utf-8?B?SmZRQVVVeDQyOHZyMC9PZ2lsL3VzUTJESWJRMzlxSm0vcng2czVjVnpwTnhh?=
 =?utf-8?B?OU1ORUkzLzRsQ1pDdGpxdmI2Y0pDc2RwaHRPWEgvbnNYdGdPbDE0c1lreFF3?=
 =?utf-8?B?TkV0S0NkMWxvOVl4bkJ1eHV0eCthaDQ1VjJvUEdnTGtUR2NJTkVtRHFzOW1I?=
 =?utf-8?B?dmZ2TUtxeUs2eTZnc0ppaHlsdDBsd3FIL2htVUI4djVWbGlLMnhnbkdZaEZZ?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 819dabbd-1df7-4d8f-dccc-08ddefee037f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 22:12:49.8390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cOZxdRJv0XzB1EGNqmhZIcjTZ8JZvZffdQ0z2e6ua1FNoUtu+cNIYrRdnLyKA7KJROYeHXT8GE4Slsx2jkKL3AWlSBFYjItQC3PE1H1FFX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4836
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> All details about a monitor event are kept in the mon_evt structure.
> 
> Upper levels of code only provide the event id via the mon_data and
> rmid_read structures to the functions finally reading the monitoring data.
> 
> The event id is sufficient for reading existing monitoring event
> data that requires programming of event id into MSR when reading the
> counter. Reading monitoring data from MMIO requires more context to be
> able to read the correct memory. struct mon_evt is the appropriate place
> for this event specific context.
> 
> Change the mon_data and rmid_read structures to hold a pointer
> to the mon_evt structure instead of just taking a copy of the
> event id.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
