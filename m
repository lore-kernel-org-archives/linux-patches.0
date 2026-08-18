Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112C32C11EE
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014701; cv=fail; b=AsifIDTMl0kQxr7Iy0Ut8dOH4HZ2ElMuf4MgvN6f3wk/2Tv+VwuFrffMVNh1nXwe3OhoH2/tu+/XPdS5sxEqD/WD4Fz54YH+TDoADl/jwPXCu9mYA6oB1wx/hF+YjujCpo+O8Pya6u1ieY97uxAGu/GktI8oWnfT6V3yrsYYSDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014701; c=relaxed/simple;
	bh=sTgDxqcCrJ20HrIxz6LRUXwRg2h9ZH0VYP7Sr2wIWTA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tTzMtIqBy5oNXQqlPT0wK1ver3naWQFhGoEi5Nq1kQciJGDFaNtCumFPv2ThspUpc60kWRl9EgCO/3quaaOtuOB8LIG+ZGkmBHObYfxtofsq3JwenFjF+6uhIcTFOKOAk7It5o8amNS1a8x1pan74r3sABM98BTAZoN6kiOx5CU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=begzC4e/; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="begzC4e/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014699; x=1818550699;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sTgDxqcCrJ20HrIxz6LRUXwRg2h9ZH0VYP7Sr2wIWTA=;
  b=begzC4e/YxrUR/ftwggUAYH0D5Jt4wj61WJhBfQkXtW3izIL3y7L/Zsh
   X9ZZdwhnUtuE3vsMSH+sqMnAfScS6vl14EQrlwElROXk0xtgF+uDjGF/v
   F8uNsQKYTnOdm6YZbVaglZN52PzOYkcHtNkKdjKoQANIC6OLP+nKebCHv
   TWLuCOQLJTYhEHaQhQYqof3rWsBjHhmmxmDU7RntNoon+4IaZnKi54rpF
   D3UCxfYwsJa+sfIK6NKUEJEuqVjNezGBpQhbrJgbA+8Bbflio9aErBk7z
   LOWGn1INsR3GpzcBI80PpWuh8teTlotP0GqEkN1+TmPzyX2WJm1pLgi1M
   A==;
X-CSE-ConnectionGUID: wPkOSSb3Sq6JRiC61gzheQ==
X-CSE-MsgGUID: ysrBZhWdSAiqPnOVRyxaOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87705809"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87705809"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:58:18 -0700
X-CSE-ConnectionGUID: KGH2wDz3R9+QW6bM0EsFVg==
X-CSE-MsgGUID: uxPE8LDLQguI0w5L+QP4dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="265105011"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:58:19 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:58:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:58:18 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:58:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UcTIdfl8VxwW7QVoTjxYmZ091hw/IkugAQuc26AepKIfgatWnZ4j3c2wUOUHIYHVNCkz4YJNjPiu27yBFzK05HOt34jhMFGvqrnATwWnCWbLAqJXDslwVnvM4UlnY/INJ63Qvq3aHiOg0/e7AuIkgipIFaX52uDEs0dKWJh8x3A/xxG8D4LkYBoNhhbhKZdYmc4eZcmB9Z38aPbAtpJJj7WuHJzfT01XXafEVNj0a+HcWb8kDzeDgcYLLvu7qYoRbau6VYG0HsQQXGdB501MlcVwVfcA7ibfVKX5WJiw2cdAigVROp8DkH/88/ap6MWU1ozlQ5uuGdYCJOXmI0f8gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4OrHWGbI4kbIzIZoqGNEu1nlaf/EpI9J8cPm/1+fbw=;
 b=hlWOiAzM8G9fDCxz00Kt9xIZsJIckbV/0BCMeiLBIdrVKaeVeq+eVfD8T4trcAj6gI1hvq26drHyzLEDoM9S16JcM28WnapI8dWuiN4SLEOXbuIFfHF7saanH7XGuGxDSL/4Yfzv8x1lnxMOejH6nzRo9qStfI+SSeLqKKf2hMqVmSSeXxSglirWZ2gl0ffumZJbHZnZK2lK4EsqDLUu0bIBjKdxaSy4AcnxBssxN/8RP162QjZtnxLb8dT4pdY6U64uhDwneOmQmDGLYPMyOKmDQfQCjGm0Nd4/4/E+xTM75jfmQ4JwCnqwL4YkgUuQfRg8G9b8gbMT/SKzORR8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:58:15 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:58:15 +0000
Message-ID: <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
Date: Mon, 17 Aug 2026 17:58:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET
 event groups
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260729172752.11561-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0386.namprd04.prod.outlook.com
 (2603:10b6:303:81::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: b1848a2d-95c6-4aa9-6609-08defcc3c8f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|6133799003|18002099003|22082099003|4143699003|11063799006|5023799004|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info: X4OvCqe0yh6qWWOcLpUt2GNKXO0cGi9JZgU2qsLicOchXKXudDqidx3eMltmsuKW7PJzxFkZMFdk2yeNvAwVSMmkmEit6TVif4sz7DdYOpBAR5m203j53QTJhJ0r1Wd8CTwSqukb3bgWW4UbJvM2qepm+7IRm936BDy5huukoU2NeZAPuJnIwbDWXnB/C2nn1+uZYId/yJ58srg/R/rf6DFGJj3XeJ2bbhKtvNPsq+JnveDXy+/IZISrCLx2F9oyHYWEW44fE0dZaeQYyETiuAm75rEAAi+K5nVk1SSLxrtVJU46WTMzjLFsu7hotbO0/9j37G4YiYfrhdLw2//9KNj08tzCblK4DuVoyV4Qx3TUJoG8JSX1RCNajDplAt0eCdz1tbXyCChPcHU7QoVr/N0B2jPxyy7gWGM0nuMLOFKSAHLLggWQRNA9kv5lSMwGV7AjUvjQhNsHtZdlVvbB3HZUQCsBcUoi8vbUiqZkGHRCaS2+P77e18Haq4pRY1aFmQ+sqUMalWeRndvdtAHrJlfxMlr6PT2GGnljnWkPgdUAZwd+6WgicA/dgfLAK+bh7lX9mRxsE3rlV1bwOeDVV6sx9x207gl7c+4vFhW7Y+YisAlZkZmv5xiBwO23sbXBX/m1cEuaa+u+16hgo0qYZSd1UgWX7ubsusD066AOflgdd1QCLc8rf5z43ktfVCExScLPufcYo8ZBUO8X53VAkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(5023799004)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUJiRzFxK2luZWg4WE9OSkFETjBqSkJnaE1ZUlNoRWZIZ081TFhsZUNHcnVa?=
 =?utf-8?B?MkJRQkRpRTRieUxSanMzekVITFdZdVFzWFlwWUxJaEkySHl4YnUyaGVLblc4?=
 =?utf-8?B?SEtEVVl3c0JtaFhobkRpb21tYzg2c3A2RTRDZkVBVmdRMWk4dVQvRzExZDBE?=
 =?utf-8?B?RXBWa25hYVQzUTJZUlJudGRnbWVLY1UvVG92QzVhTVZZUEVOOERCZGZlZklu?=
 =?utf-8?B?VkpyamJnbTN4YU5CeWdTai9KbW5ESXVKWlFLcEFoL3BJa2RzQ2xQdTlEMmZz?=
 =?utf-8?B?N1QxMUZLNUkxYnlhbGtrMWVFblJrbjFkMFpYb2pxTTR0TXVaUHhmV2t1YjBT?=
 =?utf-8?B?Zk90R2RtTDR3VkxhQVd0ZGRONG5GcCtWcVpXWGRKM2pBbW1TbXRGckZvNU9O?=
 =?utf-8?B?TEFVVHVBRlExNDRwVi9wazNkSUR6Q05NZmN6aGsvZ2xCNkJtNVZxa0NIb2xY?=
 =?utf-8?B?M29qdzNFanRDZWRoU1BiaXpXMFpCa0l0dXIwR0t6WS94K29leE1kNm8wR2RE?=
 =?utf-8?B?S1k2UEJEQ2grZE5qL21odG9JTHl6YnlTbmtFTVBEQ0hLMUtScGFpUWNra20z?=
 =?utf-8?B?d3hXS0loVnliSy9wYUk0ZzhaMGZDYjh0MWRETDd5MmR0bVpkWWwvekV1VW9J?=
 =?utf-8?B?aW0wdGxJZUJTWFRjaHlNR1pIVVVQVStpbENaSUdmZkhiS0lDWXpGbGRQYmtn?=
 =?utf-8?B?VlVNZ1grYUlJZVcwYzBCN0dUT2dLenE2TjZRWWJOMkJSZ0RvRlNZWUVYdlcr?=
 =?utf-8?B?dTAyeWhoRmZKTTd2UXovdlEzbEl4Y1hUaHJmaUo1WDV2VHZ6V29SRWgvbHFt?=
 =?utf-8?B?ZjZpK1ZyRU1wNy9ZTEgzcW01SWhGRVRXMFRrYnJGY055UkJXZUFvcUlHZisx?=
 =?utf-8?B?K2tXaWs5bno5azVOTkgwSjRlTXl4VXdyNFNEVW5Mei9Wb0hUVkQ2cU8rNlJ2?=
 =?utf-8?B?YkNKanZwY203N3I5bXQ4RGFBaVBPMzFwSkxocU9FMFY5MVdwT2cxK1hqVnRJ?=
 =?utf-8?B?cUlPWWVGemdndHp5VDZsV1lqOW9QeDk4Z1c2ME5USG5kR0pFdWp4N3NEN0hw?=
 =?utf-8?B?VUNvYkcza1JLMzVBRkJkNEFhTVVkVXR4cHcyeGVYaHd3YUMvaERQd0lQYjNX?=
 =?utf-8?B?YVVET05pQjdseG82NVlESnY3RHpBVmliMmVGN2JDVXBQajBoVjhNT3hObnpS?=
 =?utf-8?B?K29zTVVidFpZdERCaTlHbXBwY0ptMW82Z3FKdHphZUhyYUpwSUJEeGY5bDRE?=
 =?utf-8?B?dzU3RjdBYVFYT0pEcEJLYjBZNWFSc29NTTZJSXBaNjIwaGVMMnJSQzNrWm5i?=
 =?utf-8?B?cFowOVllaFZGNTM0ajRNTndQNW4yUTZJZUkzMlZzWFM3Y2FSeGliMG9UdmJF?=
 =?utf-8?B?UTdPNVc1MUNTZisrUnlzbkUzK0lHZFRMcGdDYk9KOHZxUjFDY2xzY0FUYWs3?=
 =?utf-8?B?eHJTdVk5YVZxTUg3TTZDVDFpTjJEeGFpMVhVZnZpeVVyUmJ3dnM0WkV0Nklt?=
 =?utf-8?B?SUp1eWx3S1d2YVd5Zyt4RWpOZUFKNWxLOHBwampFQm9DQ0M3RlN2eUZ4azcv?=
 =?utf-8?B?SzJ3cURqQjVwcFRJayt5Z05BZXZEa2xJMkVra0N3OUFzVkRPQnVVc0U4SE1z?=
 =?utf-8?B?UldQWkRmbVBFTEFzUGpDMStMZmhBcG5Udit3c2wxMzdzSzVDNFVVdCt6WEFN?=
 =?utf-8?B?SGZhVDNuT0J3VXVXbXNFRlJ2c1JUM2lJa2pDWTF2Smp3cWdiaGRhbXNoTUxM?=
 =?utf-8?B?REZnOWZVNkdHejdTckl6VU1aNHFzWWgzblpHb1lETUYxQi94aENMWXhEUHlN?=
 =?utf-8?B?aTZtdmluWDFkTHZJdHhxcHp3NDlUUjlTVFJESzJIWHRCeWtIT3NTbllHL0Ux?=
 =?utf-8?B?UFNYSGpaQ2RsWDVCVUwxRVpQMEEwTTRPQ2d2TEZmOHZ6dW5vTEtRZll5ZTVt?=
 =?utf-8?B?aE1lcTBidU9HY3RhN283aitzL0YzKzJtQ01zSGpsWVAvQ2I2MHVjSGJpc0ZD?=
 =?utf-8?B?QXNFRzJhQW1ZOU52ZHJhallmT05oMlpRM25HR0ZFc3Rrb21RdllaUEtuUXFy?=
 =?utf-8?B?M2l2VTdIWVlPTFA1WEZqM2dRdkx2QzA0bS93ZU0wYVFOZ3RhbEthN2kvUmNT?=
 =?utf-8?B?eFVtQkw2VDdGZVNMVFhNYTNueXNOVUZiSmhHWEtaZ1hQd0FFRUtWQmdkRDRL?=
 =?utf-8?B?K296VC9KT3VGU21EYnZENms0N1JWRi9Wc2FpM3M2U25rRDVGcVFDaSswa2Vu?=
 =?utf-8?B?dGFZK2kvdjBwRlpCZEdWbGswQ0hjK2pjeFBtTHppWCtjOVp0czdhZmFGQTIy?=
 =?utf-8?B?Q3NETXB2Vzk1RlJkT2xLNFRobmU4UDBaL2pZYVdqbjRHT05jS2g2NDJ0UTBx?=
 =?utf-8?Q?gKog1dKzZ1B/fApw=3D?=
X-Exchange-RoutingPolicyChecked: g6u0tyXsQbW/Ko9Zd90jg7RtGFyXqslI/ZSSeLNeY79DM5ijdkNT8TzDSin1I8xLwQet4Jx61rk5zLRWWFRRr7iV2ClVUxhPmo880NabzVqS65H3EJbNUxwNHDhxPP3q79lmJ/Xz2hk5iYbIZyjdcX9O0kePp9N7bQkVmPFfUOruMNoBYaIUuOQQc0ie2HcfIcQIrezvYZLrYljnudoWnCZtcUhiph0qhv+sjpg03qxlFQgjv5yvjOhrbmZIphZVBE96Lq6emq7WQXoYGHDKxlKvxB7oq52xEq+JCKCGdQQ/2dX2E1rdiWHDgIqXAgjZu7n2ZpPGzoOhlKmonWHekw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b1848a2d-95c6-4aa9-6609-08defcc3c8f9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:58:15.5219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ECcmRc34vTdj3sJhbz47zXpVf9GOvZqeHShqyfmpmykaU6D0FY/uubkh9ISLusIAUT3QbCn6fqjoz9ETbBDRtKOfrokrbHFwUSZsab7M0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> AET (Application Energy Telemetry) event groups each support a specific
> number of RMIDs. But that number may be lower than the number supported
> by the system. Especially true on systems with SNC (Sub-NUMA Cluster)
> enabled as that reduces the number of supported RMIDs.
> 
> Fix get_rdt_mon_resources() to return true when any monitor resource is

hmmm ... "Fix" makes one look for the accompanying "Fixes:" tag. What is
the fix here? What is wrong with existing implementation that needs fixing?
To me this does not look like a fix though (more below).

> possibly enabled. Call intel_aet_init() to adjust the event_group::num_rmid
> values to not exceed the system supported maximum.

Last sentence just documents the code. Please describe why this is needed.
Is this a separate logical change?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 092764cf693f..2c938b97b147 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -1019,10 +1019,10 @@ static __init bool get_rdt_mon_resources(void)
>  	if (rdt_cpu_has(X86_FEATURE_ABMC))
>  		ret = true;
>  
> -	if (!ret)
> -		return false;
> +	if (ret)
> +		rdt_get_l3_mon_config(r);
>  
> -	return !rdt_get_l3_mon_config(r);
> +	return boot_cpu_data.x86_cache_max_rmid > 0;
>  }

From what I can tell this will return true when the system supports monitoring,
but no resource may actually have monitoring enabled at this point. Specifically,
no resource has rdt_resource::mon_capable set. 

The resctrl initialization now proceeds where it used to stop. resctrl_arch_late_init()
will proceed and initialize the resctrl filesystem, which in turn would allow user space
to mount it.

rdt_get_tree() handling the user mount request could thus be run on a system that does
not have a monitoring or allocation capable resource and then we see in rdt_get_tree():
	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
		resctrl_mounted = true;

The above flow change would cause resctrl to think the system supports monitoring
but resctrl_arch_mon_capable() returns false. If there are no allocation features
then this will result in resctrl fs mounted ... but resctrl_mounted is not set to
true and thus allow a remount that is not supported.

Reinette
