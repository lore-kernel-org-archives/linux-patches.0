Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7C14D29B
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719431; cv=fail; b=QUB/tlv27nU7vaQBQZh8GCbsIim2C8ZmMf6AXcAKVV5z8AMfp/shtw5ZjIsmKMWhFMJEEZmH0QZ5XPcVQad/S8ZMeSEgrxpXu/Ew5WAQR+hSr/YYHVX+eYO3nWPEpNGa0BTelZFwHNr1wDQQcwv4rEji0n94JMTpCYBPLA/T65w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719431; c=relaxed/simple;
	bh=GctRiNuIHJLsCGCaFalDd2bWYBi0Cfh63rWaEJZ5TzI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tz1P5+hzpC6ugJF5aEOpSzCW8nsdWnoKvJSGcCLs/6c3BTDXjEeSLTBl0PYVbhXdGegYTJiyxLLSBC8vEmf4pxfNw/5fI0YSZX/jmfeCIylWVzq2EYwzPMaklUaT9/nbhB6+IirFH9IUY+oq19NuPSOU+RWfj+kQKXtFTDxNvas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mN7Ub3sK; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mN7Ub3sK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719430; x=1778255430;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GctRiNuIHJLsCGCaFalDd2bWYBi0Cfh63rWaEJZ5TzI=;
  b=mN7Ub3sKVynapNhHrcNpW/r7x55otfrvbpIwZWE+qkJYl1ziTvh1nSto
   02y7PNLnsajcklFLDCR356xlBEcmxE/Gl+UyvH88JN3FRU0n+Kz2FlOXg
   kzjhFIKgKZJL3ZZYrDxZjpzdYV+w/OzEIpM2i4CDgza+C4Riyq+L8D42C
   Q7300VRVQXzx2HircZLhWcJPv3R0sbKQ9p7LfvLXmBj0ZOlXEbsfobHLk
   OCN+8AIRelIvx7BD0h/Ii0ueQ5ee3r2nn4tNCmKQSpD59n4j/A88azmvg
   Koz5zOPseZCXyUJmRk4xclj0VNEvC/I3ywenpRKsTJyreGmGTzwSuwdLu
   w==;
X-CSE-ConnectionGUID: I1n4jYSOTMG6ROFCA58+mw==
X-CSE-MsgGUID: GfbkpuC5TVqWzm7c7Aq7dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48422591"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48422591"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:50:21 -0700
X-CSE-ConnectionGUID: ZkbzrYZ1Qi6nqCq4Tb+/tw==
X-CSE-MsgGUID: GPeAPy2oQe+svP+oK1kaqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137267232"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:50:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:50:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:50:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:50:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=keKPvHyMI2VHFTZykBEVsb5wWfNbZODcSvm6zF2HOAhZeQpsKsNOsjRzX6gJHiAKgJuJt7Vw0GNLp83T8HWFpOnxJNEU+FUfheAK9qV8gkdy12vEWG11aQF7TfsGd991fedXh3nUrfBdFpHY1VXui6a6En/2W9HP7hVqeOLTIwNE+iirIpI3YB1iBb39YyUAUzZkDQsSFeF5HxMoMbkMQ/0rIvwfULFyCiWeMjFtNbRkE8Sl8XGaVWNP9ZLhnXNiuMP3V9qqPtYTcVENLfWTcc0SfjN9lgRnlRcRKFuT04gRiJK6wRHrU6hVLkjCwjQ5FAXj27JOOVIjqyHBboabMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLAa6SR/3HYwLWAFhtInPUjEp+dLG/zKBOpiEuiceaQ=;
 b=TjrBs0SipdxFtLytjuW2BB3XVIkCOwKv2DCUcWcJekXVEyHdZDZ7kV0SAd6mjdCDSDkLl2Thyw5UJn0gpyAk2/dW2p5My/Z6CoZ4Rv85ubPA/q454x1w7m0dKTteIhedfyF7B9YCt2hJ9Xb2BmwaIrXWg1I4jMb0zfCTgl9CU8YHDQmJROrzkYou68mDoJ4q3kQnOp2sqN8r68vPo3WmlZW6JWIl65tTT6jHQny/UW+BQW2gEo6B1QjsNYNYU/Q9Mkzysuwz56gShaQYzWfSRYZak6IbKDeaHg8dbUk2CptcYQIU80fcXMSSPDmGQfyXpEUTqSVYcUg8ickVn8jMPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BY1PR11MB7984.namprd11.prod.outlook.com (2603:10b6:a03:531::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 15:50:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:50:18 +0000
Message-ID: <cc0b9d1b-7039-404c-a33f-66d2e8872135@intel.com>
Date: Thu, 8 May 2025 08:50:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/31] fs/resctrl: Add an architectural hook called for
 each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BY1PR11MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: d79c8540-a2ac-4111-62c6-08dd8e480871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bHNhYjdHdVhGN2lvRVdjNXVHQTc1c1orcWtOYXBPZGNEL01tY093blhIWmVB?=
 =?utf-8?B?c0xQSkdtam9YUnRzd2M4UGFiZzV4NmVyNFZETTRaZWMxUWRZVllXcDBFZ2cz?=
 =?utf-8?B?UXk0ODlrM2xwUkhjMHg4MXdGMTU5aWFlMnQ2OTgvVFR2MnQydFZGeGcvTVp4?=
 =?utf-8?B?OUZaWE9SSm1MR3RlcHdZeU5NNDg1VHB1SlBORThwdUNDQ1F4ZTlCQm14SENY?=
 =?utf-8?B?Q0VNekdYejNxYXEyai9tejVZTEo4bm1ZNit5QlFCTVY3bVRudHFrbVNJWHIv?=
 =?utf-8?B?eWNaelNkSVVibDRQUTE4OG5sZGptcHNiQ3U3Qk5OSjBDNHFxb2NwcEtvUTA3?=
 =?utf-8?B?WCtveEpXUEduWVk0czZQazVhNVFiMTkzWjNDOEtZZGpGWTRtUGtVSUhrK3Yv?=
 =?utf-8?B?Mk1RUkYwVTc3ZnJ0ZTZsV3RSM1lpeUpmNUxWb0djeEU3NWZUL05Ka1VaVk55?=
 =?utf-8?B?NjZ3WGVidnEzYlpTdWdjMkEwdGR0bWphRjFDU0NkcUhFM0VSRkQvWnZtSTFY?=
 =?utf-8?B?OUh5M1ZMQU01ZmFSWWc4dDBabzFyZmJYZXB1YUE2THAwMGcxUlVtVjJMdVJI?=
 =?utf-8?B?dm9EZUdsQXFzekNES3p2dDZmenYwNm5UK05UcThtbjFvd202czJleXdBN21o?=
 =?utf-8?B?WjVTNkltSGc3a3lPMXVpVEZneGIwRjZvOHZsZ1hwQkZtdjgwNUo0TWptUnhP?=
 =?utf-8?B?TVJaOUxsWFBoNW85cnE0LzZJU1dJRXhWcnJDdEJLeVZacWlJUWFCT3diUXpG?=
 =?utf-8?B?WXBtblF4MWV6Y2NpZWxBVmZsNjMvQ3dYYnJpNmQ1Q1RjRUlabUlKMExaNTJ4?=
 =?utf-8?B?NHBqYmdiVXcvVVpEL0J3MUtGWURCWVFqaENFaU1STnJqb0hYNmprSS9VY1pu?=
 =?utf-8?B?REZrWmhPVjUzYWVzUXI2Z3cwKzJFL2Zqb0ZnVjEyUXV5c1RvV0JrckNMWTJB?=
 =?utf-8?B?SjMrMXFSY29aS3pRRWU1ZHlnZ20ya0loY1VBNVZldHFXMzZlWFM0SStmWVlY?=
 =?utf-8?B?VTdhMkljbXNrMmczUHJUUUF0ZTlhY1grRUROYUZHUGJiNk93VWh0Mlh0V1M1?=
 =?utf-8?B?S01OQUxLRW91NTJrcERVaHYyVzV1a3FWVnMxSzVETEVaMUp1b2Q0eFpLaE91?=
 =?utf-8?B?QUNVRUdWTmV3VE5LOXB6Q1FNSmZHRVdLOHJpRjU2YWRDeXU5V3M0K1praXls?=
 =?utf-8?B?RTVXOHY5Und4akJvcFo0aFNzOVNZV3JVNUVsUTMzeEMwYXV6c2syNnVQUUR0?=
 =?utf-8?B?TVVjNVRCMUZUd2xRMGp3NndFdkZLSGYwTDdGUVlRcjZWd2JhL0VzcU4yUVBo?=
 =?utf-8?B?MHplRmVReHBqcDE5UHlWU0tBY2htU2k2eGVVeG9NcXgyMVNtWkF5UldVWkRx?=
 =?utf-8?B?SWVyY210UkkvUnJxQjRGTmVSUnNSNmRxY09DSEpMd2Mwb2drY1B6dTJtcUFo?=
 =?utf-8?B?SzA3eFI1NHpQRmQwUENLZElHMFBxSGgrQU9aOFZpUEdubU9BeWhjY1lHTS9C?=
 =?utf-8?B?bkhzVGdlQlpRZ2Rkb01DSjFycmk1bjIzekZpOC9IWGtrMG9obHdiNHduem84?=
 =?utf-8?B?bE5RdHA1NHI2YWJ2M0dlMGtOdDljTEQ1R2t0dENhc3lER1JwNFhITXRnQ0Vh?=
 =?utf-8?B?SWVCb3NrbmFweDdJZjZGUmdTWXVmdlN6T1NxRmxReGgyU2V4Y1NEem16SVdT?=
 =?utf-8?B?c25rYTlsN3JKRzlsa1B1bGRpcGRLaG5jU09ER3VWYm9zRE54L3E2MUIvS2F2?=
 =?utf-8?B?Zm0yRDFvelZ2ak8vY0FQVmkydHR3SDZKRGt6Znk0TVRFSndSQ2wxRjhnZ1J5?=
 =?utf-8?B?NVcvWloyZzVaVjVTSGtoSThmMGdkQUxqYXhuNE5JRy9jYkpyMk1URlFqZ09G?=
 =?utf-8?B?K3N5WHgrQXhaWm03QWdONFUvYkd4bVVmQ3IxVUhoUDhJbVN3SHJtbXdWYTA5?=
 =?utf-8?B?NHBGeVU2blRGNkYxdWJTSFMvM1psMktPdUhYS3NsQjNyN3Q1T1JSemZ0c1B1?=
 =?utf-8?B?eGFGUENUb0p3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dU9ZVnpvTU9LdDFRRzBiR0tOazdCYkpkR1RpLzdkVmtNeWpwWUZ0WXFCdjdX?=
 =?utf-8?B?eDhWamFUWHQyZCs5THZHNTFkSUx1VkZ4KzFWb3BBLzNLL2FHZHluNTdCUHJN?=
 =?utf-8?B?MnpYdHFvdkx6YmpCUkhvSlNqT05ZK2hNSDVLQWxUTUgxTGVxN2svSWlRbW9w?=
 =?utf-8?B?aGN3SmhqNDRBd1pkdTdSaXpCS2tmZEsyeFhPamllQU1HRXo2dzlBOTZCMDFS?=
 =?utf-8?B?aVhTNVlaRUYvZXFVWjJpNUlsMk9xQWpWSURpakhKVkZxaURUc2RTQk4xTG9P?=
 =?utf-8?B?SmVWN21Ub0JOVkl0SFFkdjlmRmhsNmd4QWJsSFNvd3hJL2N6dG0zVndnajV6?=
 =?utf-8?B?ZDdQd2Y4UVRLU0tpVit2YkRRVkVOTjVDdGREZ29MYjQ1OW9aajE2MDcvOUYw?=
 =?utf-8?B?RTVPanVMWVQ3STBySlBDTWFvWW9hdTNTTVJpYjJjcFhPdlY1eWd0S3l1R1B5?=
 =?utf-8?B?ZDZic0I2eDJRbk4zb2QxSU9SU0hObVdyY1ZkclBVWExVS2c4UVU0cWpDdUVl?=
 =?utf-8?B?aktOMFVOeXp2NlJiTHlsaE9iZXNudElLckhSbkpmc1U0bVl0bkNMN3ZKVXZu?=
 =?utf-8?B?K21DWCtWVENmL3laMGgrUnptcEo2VFBmaCs1QmU0MldBOEpRR3UvQTFBK3NU?=
 =?utf-8?B?aHZ3bEFvS3lwQUQ1ZUoyL3FLQzVwejVQdE1ZdExVbnBaZU9QbWNEb0lQZ05h?=
 =?utf-8?B?K2Qxc21qWnBmNmhUUnBxb0ViT3dPamR6cGw0ODZ4WTF3c0pqcU9icnB0ZVJE?=
 =?utf-8?B?Qmt1MWpTV3hiVm9lZm43SFVEWDV0Z3FMNWJ1ZnJWc2lteUFjTmFjWjNndmNM?=
 =?utf-8?B?WEY0TU5QQXVCb3FSdlJ0R1RXRnhjeXdnKzk4bnZpVnlEUFNlRTVuWjhmVkZj?=
 =?utf-8?B?NWlUNkcyTitmaU5pNWltOVFxTDFqeTlQQjZGaUFIMmVCZVo1clV1UTNqOXo1?=
 =?utf-8?B?SllST2l0NmlHaHo4WUd5b00zN0FTMHpCQmJjcEQ3NzhQZms3UzkxZDNzUkRj?=
 =?utf-8?B?WkhJbmdHdVljVWRaSERrUW1VUXVkak05U1Nla2dmR0VIME1tNHROeXhiVGtF?=
 =?utf-8?B?TzVndmpzWEthR3lKRE5jN290V2NNM0Z4ZUVuMXU5cEN0ZVdMQ2xWNWp3cnBB?=
 =?utf-8?B?WUxFMmVOak5MT3NiN0lNamlBUktKekxXVzFxbkdKbmxKRTN5Z3NhN0lsUWFq?=
 =?utf-8?B?V1pWVjlJeEtPNnNDbks4MGdOaFhBSHNVOXRaTEpZMXVZSEhFUjUrSTN0Ly9B?=
 =?utf-8?B?OHYzbXJQb200VTA0NTFGdk5IYzhNVGNHSjhJRUM1WGNpZU5rZi9uUm56TGhl?=
 =?utf-8?B?TUM5VFRYektneG5BK3lleDRNdkQrMGJrV0xPOE03KytrdjdIRVNaYUhhUXI0?=
 =?utf-8?B?NnhoRU9mWDRJNUFpcE5tVEZKVU1iZ3hBamFTd3l1Q3V3aDBKUlRWOXdmVDdj?=
 =?utf-8?B?ZU9FemhFeG9jYVphWE5NTVMwaSs3OU9qVTh6UmJyQzN0WXY1ak5GQkR3dW4y?=
 =?utf-8?B?RHJlZDgxZHgya2U4enFqL1dmam0yM0Rqb09aYktYbEo1dnNiU1pWZHNHVU9X?=
 =?utf-8?B?TUFGQklyVEJ4cjZFWHhyMmQ3ZDNQWlYxZk8wVEo3UDBuZzNRNWpEK3JmcnRU?=
 =?utf-8?B?bGk5L3BiVksxeENJU09XNjFSZkRpTG96Yy9WSkJPMHpvemcvUlc3NXdjcStj?=
 =?utf-8?B?TEIva2E4Y1MvN0tENStpdk80MVMxdTliZk9rYnRhdGN4allmOGFPWEQrQndt?=
 =?utf-8?B?NlJ0M0RzUkdqck0rL2piOGFqSERmc1pQRzRQb00zR1FhOFoxTFliSnpZbEpS?=
 =?utf-8?B?RFJjalI1amg5MXFGTElvOWx1SnZYREdjbXVtVXc1RkcwanJkbzFiYW1GN2h3?=
 =?utf-8?B?N3F4QVRscDE3TGY2QllxWmd0Q0Y0NWVoVHF1YTY0bGRXSVhpT08vUlZHSzFj?=
 =?utf-8?B?N2QxckZNOU44TkFTVTluQ01tampzVUw3TkZQa1dhK0lQZU41eGUycFBlUnBG?=
 =?utf-8?B?N3FSakdFNHRxckgzWThCT1pvU2Y2V1ZzTG5GTXpWd0FrMElWSk15bDBJMHY1?=
 =?utf-8?B?MTY2Q2ZvRTF0aWZneEVWZXBENFhNZWROeHlZckE2Yi9nbXR4amdHY3QyY3Jl?=
 =?utf-8?B?dnlRZmRYQUc5Um5zL1pUaHVnN3JsS3lmL2lPKzBLUEp2VC9Oc3ltbDA4ak1L?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d79c8540-a2ac-4111-62c6-08dd8e480871
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:50:18.8906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50IAGpZR31srusrz4ayJD6SUF+Qj3imUMqlRNwXkgJYUHxIlKuUr4xf41ROGITUqTvqKDV5FUv+MjABvV7ZrmBdvsn3jrk2dg/7auauA2zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7984
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -450,6 +450,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>  void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
> +/*
> + * Architecture hook called for each attempted file system mount

End sentence with period.

> + * No locks are held.
> + */
> +void resctrl_arch_pre_mount(void);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 58bc218070e2..2f3efc4b1816 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -707,6 +707,14 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +void resctrl_arch_pre_mount(void)
> +{
> +	static atomic_t only_once;
> +
> +	if (atomic_cmpxchg(&only_once, 0, 1))
> +		return;
> +}

As I understand atomic_try_cmpxchg() is preferred on x86. See
"CMPXCHG vs TRY_CMPXCHG" in Documentation/atomic_t.txt for reference.

Reinette
