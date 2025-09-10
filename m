Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C495C262815
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 03:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757475612; cv=fail; b=deKsAVd4q/68Pb1yz4qJyYzYnW8AI+Vb4VS9Ls8Aj+TRzwnbf8HbNgY8ZcNs5AFlB5XFviYAc1XwOT/3e+47sAcrzeyPW3oecYmkpWdo+O6h7u3jZAFZxvqqrWjYdd5N0bwQO75vLsQW8PHt3weianhtEaN4e22pU6rjbcTKQ8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757475612; c=relaxed/simple;
	bh=cJEQzLKNERZqWNtS7YY3JVZp1dGdxeLxhMdGaHnYzjw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EY/++g/xjnq5tIrcFnJ4rHuRLfUOLbqYCCcmulMjdsX5cu3YNK5/0J+AO94F3rvaTGznXldl0uz8Nrf0TlNTxAP1IdDHKd99tPj1UCwZnzQvnEu7h2DR4tpQrkltaSuobmASMc2F3VqdfBT7Bfj/fUkjMxd+983zJvQArlgT/o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnKX3Mux; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnKX3Mux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757475610; x=1789011610;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cJEQzLKNERZqWNtS7YY3JVZp1dGdxeLxhMdGaHnYzjw=;
  b=BnKX3MuxRZ+wcvADLrBlOe8ptc5m3sTU2cyHnCeUlhkJ9ZO4fl4MbDoK
   ZfS7uRJXl3YfErGmrNJIZNf6kJLkPRROBSso4K5bV2btdT0rEE9A4xKMt
   Hi9lw+BtXY/EA6fD++OchXqhGsGiTOWjWuRpCAFgiaNY2iA19pe0VOME9
   gExzcokcuQFAnJ8SIDjan9sWVCP+a5Auw0V0Rp00JrG/PKZoKmIlBEEca
   CIeH0LIcby4jJwk182tkHbgi1eLLmUeOf77g5KLxABd8YGlIa64mqulhC
   FjiGypgN+v4QHp/iwqKIYAdRas3E4zvjgLW/Yo2UkbSsWDCiM11YKu7MI
   A==;
X-CSE-ConnectionGUID: 6DmFRReHQsmFt4AweJM36A==
X-CSE-MsgGUID: W/DW062JRlqd0Gkwb2yHUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="70874816"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="70874816"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:40:10 -0700
X-CSE-ConnectionGUID: YYd7caU3T7qhx8C8rOAV3A==
X-CSE-MsgGUID: uW+B4GZKS1emX7ffs+Q6sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="177547713"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:40:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:40:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 20:40:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:40:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xy8E3er/UjaoNlv7Lc4Cb4IzpEX84HK1ImxvqRkvQ/REMoJUs3WK3DXAwv0++6I5dDtmP4/ASgVJ+/tVJNMFcILb5pjW5jbuzXhYBpyTfRCyoS5G+xtlE8x6iDhzVtjrd3NpslmSlfBiKeUAnQZD7HVheorkKAy9yA2j5/bZOUN6GVy9iHtorcL0nLxRhiHS9ZtWLLTpECopKdf+NqGiFQb/fRzxfaXb2KBB2ziI2YucJbo8UOSQDNcSjtLqYDCInYVVrivzSg7eOMv2oR1ER8ehlAnWnCCZS7Mw0mIBDqDGSvz6ULYB1BIW2GPgPFRh3GsMrMTCbmPhuWveosOeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/H5pbubsX0ptzpP28os7Jfm8i27b07cGp54aGF5C2Go=;
 b=bxNle2ZRbZYXda3Kb7AV0yp0aht63C0iHLWW8QGDSq1vx/IiaCKLJ786yh1QfWR+1r2d0bh0tDCln1mo7MLrdfX+rkAlrKPPnvoM4JzDXQVz8DHFKiqSlZBgYIiR6VtUBMc6Yi8glkBrepslhf0hqI/MM/Ravw1jwgrXjxFPnNhj2wZsImkTPQpKJeWBTtK+PZ2mThl7HlyJQt+JoFJkIWQvFh6S49JNAH1cIupHGVVzMZQ0EI3Y99eNm289X2pRRsKv7M7ciRZzNNvmy+6rjKfHnT4PGm7EN6s+FeZiAt9sUt5cPqBz3fSCSzmNDzvaYmYm9Rs6LPMS8w1hp/Kt6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF66B2E927F.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::830) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 03:40:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 03:40:02 +0000
Message-ID: <eada23ab-e2ae-40cb-a039-f5ba970bf595@intel.com>
Date: Tue, 9 Sep 2025 20:40:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 19/31] x86,fs/resctrl: Add architectural event pointer
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-20-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0028.namprd21.prod.outlook.com
 (2603:10b6:302:1::41) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF66B2E927F:EE_
X-MS-Office365-Filtering-Correlation-Id: 23752b16-d9de-4f06-b7e0-08ddf01bb9b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cndQQmtMZzhlRitmaEhMa01JNy9OZFIweGoxMjRsclFKbjVYS2R0dExyaDRY?=
 =?utf-8?B?clJERzNXM2VhamxzaEEwUzRuejY2aWRFdlhza2h1Z3Y2Q1VQU0Jvd0ZkNDBV?=
 =?utf-8?B?WHcrY3dPamlNbXdzbjAvMzV2MDJ0QTFCdHVJV3JFVm90bzFWVy9iRCthd3Av?=
 =?utf-8?B?bC9zY2pmcXlBdXRRSnREWlI0SmJZVXNmQ0UzQkduUWtQMjNnWUtwN3ZsZytM?=
 =?utf-8?B?NmlmYS9tVGdWUFBJRlY1UWc1eTNqVDNnc251TkI2eEFyNFdGY3hERzAyVXUr?=
 =?utf-8?B?NWcyQ2VuNGtZbXF1T0prZ290UEdvVGpKbGVReTV0QUs1WVFDeXV0alUvalFJ?=
 =?utf-8?B?NkxQUTQweDJBdGUwVDJQUkZWNnU0ZUxrOUFSQXlVbysycUNHQXM4Smg5ZnJO?=
 =?utf-8?B?akpMS1dGRFhxbVVTQ210UU0xeGFEM2o2UUF3Yll6SWNaS25CTjJzNThGVlQr?=
 =?utf-8?B?VFg1UDZCOFBwS015WGVWTUMwcmQ4Z21IV29FaUVrQnR5RmUvRmxRUWFDcmVV?=
 =?utf-8?B?akx6SmI1TjVUaFZKVldpcUJ6QjREYVRTMS9wWVg0VGIva3ZPRS95eVhSVEdt?=
 =?utf-8?B?bDhVUW5iaDRCcXpWRTh4Nzk5T0JPU0Q1eDdaV2R2ODZ1RkhoOVQ4RXRLajFH?=
 =?utf-8?B?TWRBanl1ZFkzRHBtaVVnbFJaKytBVnVnZXA2VG4xa0l2b01kbGhYNmsvR2Zy?=
 =?utf-8?B?eCs4NW9OOGFIcVFmZzVGOHRDS1NGcEFoOUJsVDVMSGVweVlqVC9qcHZtTitn?=
 =?utf-8?B?VW4rSzcxNmpoOXRNZGVGemRKZk1XQ3ZIajVIWHpmN3hNYnY1RWJlY0l0eStq?=
 =?utf-8?B?aHNRd0JvdkdXUGJMTmtuVWRSUFhBeGpKcUtIYVMrNVlCSnRXcW5JZXZlSTRk?=
 =?utf-8?B?dHNYVlNqcVlKNnkvN1BBZDBxUlc1MHRLQ2E5TVhZYzdTL2dpeGZ0eDFXV0wy?=
 =?utf-8?B?Z2c2T1ZHZHNuc0ZzQ0JZSDBZR3JqZlhNYXdhQVNCN1Y5RzlkTGhPazVDaElU?=
 =?utf-8?B?TTI5ZlZ4R2hoNDVxMTlJSzFPeHlXQTcxWTcwSWd4RGlQUkd4QU9tSjhUNjY3?=
 =?utf-8?B?RnQ4djBZMTFSalR2T05yb2pqQ3hURkg5dDNHMjZpK3dBY0pSc0IzZVRxUXBO?=
 =?utf-8?B?d0cyRU1HOTBSeG5scndnSjd5OHNNSWh2clEvUlJHT3d3N25RaUxXb2N0QkxH?=
 =?utf-8?B?WkFrT1RScmhkS3dGVFJXMUg1SnI3OEszWkt0RkxTNFAvK1o4UGtDUHpXMG5l?=
 =?utf-8?B?cWxTc3FsUWpIMWxRYUVaRmlGRWtmUmdZTTNRUTR4bE9id2ZxcXNzN2xBZDVL?=
 =?utf-8?B?ajNwWWozdVppQ0lsaVpUZHU0OWE0MEwyTjNxRjBJeGxPUFJ0RGdjYWpZVEtF?=
 =?utf-8?B?dVYzbVEwYkgvcGVoRUNWaUlVcVNyR3ZKVTlCRTBrSVB2L1dtNHBjaThON25C?=
 =?utf-8?B?eHJ5aExwNXhUUkJNR08wL1lldUlCNGVnK0xJbkd2bVNIaHNlbVVZcXlJT0Vm?=
 =?utf-8?B?alVzeVFaV0R0SEw0OU1CK3oyQ1J4cFcvUmJZLzArU3B6U1JmRUNQTk1uUDF5?=
 =?utf-8?B?bWliR2VZdnBCdEdBWFF0Tm0rZ2M4MDBuVUR6S0NiZ0RObWIrN3ZtaVdhelNM?=
 =?utf-8?B?NTU2RlpOYU9oSi9CemJpTVp6WHZKa3lIU0FISi82c1NydG8xMzNadVZPZmU3?=
 =?utf-8?B?cEhocDlyNk5zQytKK0VtbG1NZE1EbFZ3ZGRzL25vYzd5d21kVjNFdHZpbFBD?=
 =?utf-8?B?L0tVek5UYmphazFxMnVVa2U4ZDZhWklwZ0d6NE01enlmcTJjOTlaN256bmp1?=
 =?utf-8?B?MkYvbCtqaWU0SW1DNUNkR2VDZkZGWWNWcXNoNE9zZE0zZUtPakYrWmpiUW1K?=
 =?utf-8?B?VUdMenNnY3pmZ3o5TjM0dGtvRmtGOEh1VWZ2R0RiVCtvbjhjMVFBVHo0WGw5?=
 =?utf-8?Q?jPalJegkhPQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHBmeTVuWnpQQWRJcXVDS2xoWnlxTStGWW1Gd1JJb0xyNW1sY0hGQ2pLSFRi?=
 =?utf-8?B?RjN5TlpJTTFHc3QvOGhyRzlQTHpSRUFuZmV6L29jeHRaRkhqcXhoWnJ5ZnFV?=
 =?utf-8?B?VFh6dU5LakYvRkdoaGhIOTgySmhkc2dheTNGQkNJVFBSaWdUdXpPTGc0VTZB?=
 =?utf-8?B?dW9ranBBbWRMNXpCTnc5eVB0b1pHNmlnb2JDVnUyZXRybGFKblBWYW9OZnRE?=
 =?utf-8?B?S1AzUHlWWUZvZEhXWFUwK0tJMFE4V1lyejJvRUJWS2ZCaU1RUWZNK3Z6Nm5r?=
 =?utf-8?B?SmlTNlVGQ01zdGo4cGpIbVNHL3lGbllzUzlkUUVIdHdORTZIQmVFdlRGRzFm?=
 =?utf-8?B?bDQ1YWVMeHRrVGtTVnpBQktVem16V296Q3ZuQzRKMU1IMERobitCZjNkakFq?=
 =?utf-8?B?WUZlUWVGbU0vR3RTVVhkZ1N4b0ZCc3ExZkN5TThhS1dkTXQ5V08xTnB4dlBZ?=
 =?utf-8?B?S1BOMzJrd2hBM3IrcnR0c0dUUnBScklpTlBMejd1eW8zTUxPWEw0R0NrVzBW?=
 =?utf-8?B?VVhuZGxoaXViVjBPOFgrbWRoQ2xGcnNNV3hINHROcjA3dTZ5ekNFanh0b1M0?=
 =?utf-8?B?eFZFazRBNmdhYVR0ZlZaUFd5cFdxNFF4SlNMeTQzRGZsZkFxVFVyWG9YcFVy?=
 =?utf-8?B?Q20wU0RtcEd4cFZTS0R4WDR6dFpwN3VIQVB2NVN1V25WMWJoWHBRZWlmVkY1?=
 =?utf-8?B?TzdOalU1WWwydEJyVVlXeGRFbS9mNk5sNitlTDQ2TWdtanhZZkNVT1psOVpX?=
 =?utf-8?B?WlRCN2lBdjNmQm5yWkloL1lNQUJ4SDQ2cmllcktyNm94bG9NTUxuR2dCOHdh?=
 =?utf-8?B?VU03QkRZcUtpTjNDcHdTRkpld2pGMG8raVhqanFEck1VQ3NYVlFKNXQ0Q0dz?=
 =?utf-8?B?bmhHYnV2aWdJSTh3N2RyTWVDdGdVWEdrSnZBazA4OGE1eU1FaStwQWloTzhw?=
 =?utf-8?B?QS8vaG9JbkNrUVc1WGNyRHJOREkwNVNMS1pWejhLSzZkVS8zQ0QvVTcvSDFX?=
 =?utf-8?B?Yk9NTUhUbU10MlFkRkRvMStpd2d4YUdac1lMY283SEV5VjE3eVNvRURIQ2Vr?=
 =?utf-8?B?NjU1cmp2V1hLV2JSZEVvYU9VSjl4bzl4RUk2RGl0UVR2RzR1a2dJVzdCTExD?=
 =?utf-8?B?cDgzME1ETjc4SHdjaTRjdUF1bWJOMnk5UnRHZ0FPSitUZTVjVHpMc2ltaWtU?=
 =?utf-8?B?M1hmdEVNank2alVOcGo0NkxSZEFuOWt0aFFLUWJQbEpZb04yU0Z1TkNRamJB?=
 =?utf-8?B?Wnozdm91eWcyVEFxOE9Ca3pVVFYyS3gwWmNtTkZ2blp5SjRoZ0NxVE81WGVK?=
 =?utf-8?B?SENaeXEzRkNXTXgyN0ZNbCtON3R0SURoUWdnT21hQ2ZKU3krV3JXNThDaFNN?=
 =?utf-8?B?ckJBMWNZV05IN1lCTUg4N1VMaEowNXR2MGJPWEJ4NVJldG9SM0dEMWpJQ2Zo?=
 =?utf-8?B?SFVmL0RjWGZpNGV0cVJ5NWR0TWZ3NlR4c29WM08ycjhkamdQdy9HZlA5Q0J2?=
 =?utf-8?B?N0U1bG9kZFhGcGdMMlYrNW85QmZ6TGtReGhzaGJjOG9KSWZmRS9oWjYyb1V1?=
 =?utf-8?B?TWJBdkN0aWJPWDRqNUI1c0pHcVdoSUxRRkZnaFJ5TlMxOC9makRQcnMzZlBi?=
 =?utf-8?B?SnM2aXlOTnE4SFdXdGNzS2U3MndCMTVWSGkweVJ0SWsySENUK0R6RmFJUlI5?=
 =?utf-8?B?bmtjZnpraGJkd0ppcFZJQzBjaVQ0TUFVTitLczRqWit3VVZWV2xJTjk4aC92?=
 =?utf-8?B?R1djRzllU0s0Tk5IQTNPSmlZUXZxbXB5MklEOUdtSGJnamNKZTRJWFg1dXBm?=
 =?utf-8?B?Z0NFWmVNREtMZG5nOUh0L0lraWU2OTRIUjJnYlVKT2llS01IYTAza0NIdVM3?=
 =?utf-8?B?bFZqWG5TeTRjT3hQa1VDL2V6MlhRcHB1ZXR0QzhReHcxRGlxcG1aUEhVS0xt?=
 =?utf-8?B?OFJjMEtGcVRvTnVpSVI3RkpsaThIZW1CQ0tNODU1a0JpYXFSeXBpM2x3VXhK?=
 =?utf-8?B?R04wQjZOL0pIRHlQZW5BVmdHaWRQWXlLemo0MWluYXk5bThPNGZ0REU2Vzdh?=
 =?utf-8?B?Y0ZLM01IYXRpaFpQMTdEZ1FhZ3lDL1BMb1dCVFFMZkZTcHhmS0R5ZSswNXR3?=
 =?utf-8?B?bDZTY3BBYUtEZ2RCMEJrb09hMFdkdTJTZUlWVldIS3FhYURHbGN4NXZmMUNh?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23752b16-d9de-4f06-b7e0-08ddf01bb9b2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 03:40:02.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM8smgx3Oqe/dsAtag5up/biF5cwdvB+wdQrEe6HOSuQf4ejKe4vLh8fzUFBq7PZe1kkVTU6nQOCAo4r5Da04Nhx4jWtUzmKgWb5HCHy5Lo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF66B2E927F
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> The resctrl file system layer passes the domain, RMID, and event id to
> resctrl_arch_rmid_read() to fetch an event counter.
> 
> Fetching a telemetry event counter requires additional information that
> is private to the architecture, for example, the offset into MMIO space
> from where counter should be read.
> 
> Add mon_evt::arch_priv void pointer. Architecture code can initialize
> this when marking each event enabled.
> 
> File system code passes this pointer to resctrl_arch_rmid_read().
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
