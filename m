Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CB936EA80
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 19:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772825096; cv=fail; b=fYm4nZ3v4+4S5CE4XDjcjdk2uovKat5fngi5XApw1ujXsIDxA9SgkPi2cMM6J7yIwDJosFXsYNnuDB32fit3owPaepx6VqgBuqAlBVsjE68kN/Y3XGp30DqMyUCt1pVwOgST4qomsdGuOWjmBUpOpzsd+/gfhE9sSzyxOTSRJ6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772825096; c=relaxed/simple;
	bh=gVIntVDty1uISK61NuUblF9nMoDXlor2uSHelJf7RoE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZmuoDQQm05Idf9zyPZ0XXejVvMN/5kltLv57pO8mP05Ue5S5hPk8vZQfc8MeUrcmzmjU4sVTKnW46rtrXgrlKX0UpkrttybLPWQAIMz8w27glMN1QO7ZW/PIGmNo1KUz6AwhsJmV+dP75uzKUb0+dhwhwBrPyxMcP39EALTWPe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5cdC6k5; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5cdC6k5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772825094; x=1804361094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gVIntVDty1uISK61NuUblF9nMoDXlor2uSHelJf7RoE=;
  b=e5cdC6k5r7L5gF6S+4iahVw8lgQ5CsPVL+2q1UjWHGwCA2EyOi9MRxt3
   SpaTPYaNNdo1qXjLYVY6TqJVYFPqnwzYJqNmRFbpuCzpo+5tJh+rsqFtv
   dRfBbh6K1El/LcQkYrLU8qKTZtlmL7ut+WHcQTZjXhhmwOU0CVV2vmotC
   o8mMce6YHOwne5EovWdIRSmyxZl2cP13RDZEOkEaorAALyr+6zOLmsUyo
   J+e1Oc/a2Ici1m43kZY7STO7msctd416YpNEgwwC8/+ALsoFWQH2IbdnZ
   a/r1fYq9aS2mWT0kxsRVCwkWGkq925fbHizkUM2dUHIHDRvRFR7f+98ES
   w==;
X-CSE-ConnectionGUID: JlsYqe+NST6hH75dez5bFw==
X-CSE-MsgGUID: cg0X4HNNSbu0AoO/dqh4mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="76546418"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="76546418"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:24:53 -0800
X-CSE-ConnectionGUID: c3stImMZQZqwgHNZF+nGuw==
X-CSE-MsgGUID: pSXxZfuQQbiGmnnV5XHgqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="249573755"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:24:53 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:24:52 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 11:24:52 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.16) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:24:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cELwYtaUBVv7eKjPoEvZOy+EY4JMm5acITVBTATG936ZZaubtcVPrizQbvYfBHi3t4Zsjv/WqVkrI/+H0Ks4viUSsJdsKZDOlgvsX8RoF9kWKYXkerhyFMEa9fkNZysHVGi6DotOaLduF3LKhsVQ9Hmol07bmmVPRZkIZ/EJWjPp3n2N1/dia3YrFyxA/wGl0/bwG9gfoGtrcNpUOw/bi/Y36LlbpEaXM0hVGoVNUGxlpA3bTVdWvJ8xAo4r+rdzTnpGDdH+xQb9aNNL6T97GJDKji4gW3y/Cq/4ZPoz1d5zLq9oaRqF/PtySnUCdWtkJeWjNikh4KEfnO8W5AYxOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rv4qD8dv0SNEOumB8e9+sEE8b9VJsWCc2Y45zwxLi68=;
 b=T91QT2ki2D3SFkwbeIrWcfTtIe5ZLoxeS1Aikvuc132mY1U1yGOtOcxaXmJgdmrlLxYBNUoN5U1PbRB9NgnTK9/qANmUpBSgKkpayLAqOCDQ/COdM4EbIzoCpw3wP+u52r3zOuRbJNfAfgsYenBROVr675uH3gymfNfGWJ6SAgVXx4QtEwctRugOgWkEgYZ1hgBlcZBOkk7hnSgY9Pp74u6Y9PprGax7SHTG5qiaWb/uuBAwQ937c9kRPphIJ/qY4O9DfHJtn/+d9mrE+nQVSi4z6Bd5Ws9aivZwPXN2HcvsK/PGpkF2fnfMAshmYOOteN1vMOPgZZLGvvA/Y3Tm7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 19:24:48 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9700.003; Fri, 6 Mar 2026
 19:24:48 +0000
Message-ID: <322603c3-24ef-4cd7-bbb5-8d5257256e24@intel.com>
Date: Fri, 6 Mar 2026 11:24:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] selftests/resctrl: Improve accuracy of cache
 occupancy test
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1772582958.git.reinette.chatre@intel.com>
 <a43f404b9fdcf01d8c8cd825c17f39f95083c813.1772582958.git.reinette.chatre@intel.com>
 <db270056-a2b5-e5f0-1ed4-e652d67e90fe@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <db270056-a2b5-e5f0-1ed4-e652d67e90fe@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0265.namprd04.prod.outlook.com
 (2603:10b6:303:88::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f79e6da-e324-4f6b-f041-08de7bb607dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: bDPzzXCSlEV3tVkxYXOTpp/D5cGEAr65ps60sHcuVPuTMvX1ClJbvA1UFMO0Mtw11DwNJnzvsvr1wlHHxnhTAyktPxZdIz6UCWFu/K0TTmJrI8qPrF6WtPSB0SgrM5ExPHC+NyawzI53/WlveyQ96PXHqw9nA4XZziKCQIgjHrifjNvLk74Ncp6HKvQ8IS2pxN91NZBMc1KPFPaqq2N3Ha4HhWAJNKxXT0zFMlpuPTXixdzj2szVLBVFwogv0M5nbhoxZ/j3Gr8iR5GAXqMl1f6F9FtCi8GSr5GyciBG7ggcYnIbLAWDIVkjBeeT+8LzVUHe7kkIyHQXo7H34J25B1251Ub1dAbi+myt1RMrMwESGV+7sOafHXlfad6ssm95QWtKLgorD79MYRrrvNROMH7E6fZ6oPORh1fL6jnfrqNLlktvpbHwnBLKm07XhyoLiEMEga5HRaU8DB5KPQXNQHLzhdzRJ9Lgu5y9gEVgWMIz4S3DPhewCm4s3Y3RYUcOI2ABt7h4LNhqKJVONyCwQBBk2UojQOKt7APtfESYvGR007/D9+jTCuZc2vulYUlXRcyUn/ozuxlKmlZ5MGyiGphSyyDSYG4xoIOHvHb6IlP/9EKLR77Iooh4gebnd8NoFLic4/Y+kzurRUfSVsULQx+uL0JCdD4pOJnWnkZaV1vXxRdU+GLAxXHaix/YVUqzD9NSI/EfxboyhlF4zL8HAU/21KwT/4bVKJJPHR1FcSo2lByOAw1Ggh8ldprUWHy2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEtxbU5CUnY5OXlySXRjandTdVJ6YlBKalcxdEJzdWZTWVVMblFGNEg1T3FC?=
 =?utf-8?B?cnBNWlVKZmhKeVhvQlVGU3ZvdzBzY05BNlpsdTBJVEo1ZS9DanBRVXI3U240?=
 =?utf-8?B?YkNwajdjazA5T0FUZ3R1dFBuMnROdkJoVW10d01FL0VqalBaTmJlS05GTzIw?=
 =?utf-8?B?THZqdVhNTmxyNGk0Q21pQU9ubG9XTzdZSE9ZenRSWDhIVHh4czV5VlphcTV4?=
 =?utf-8?B?dlg1RnphT2taUUFkcE9qaE1PNmc4NjdSY05EY0hpWVFBYkpRYmpuZmtBa2JC?=
 =?utf-8?B?anlreWNGSlBvOVlCWi9uRVdYSUFBVWQ3UkwzU1V5NkZoSEtDN05QN2tCWHp6?=
 =?utf-8?B?UFVLRnZvYXA5SHBxMmliSVJmQlFqQ2RZOC9Vb3pKbjhLRk5iYlFudEdCMS9h?=
 =?utf-8?B?bzJVc1pLWHlmSjREamlQRkdtZXo3cUFkYytTQk8xejVYY1Fvb0FqdjNHcDZ6?=
 =?utf-8?B?M3NaOEtYRFdHYlU0eEtjVjRiTHZLTEVaNGxRWXZuUWRDRXMwbFZrV0Z3bGd0?=
 =?utf-8?B?U1lLUnRVbnhjSjBWb2dlTkFUZFh5cFQvK0Fac2NWYlNKZlhMTVN5NHhHaks4?=
 =?utf-8?B?TlBoM05uKzFwS1Vud2MyNldrUHY1Mk5vSndHUVF5VkhMWEJEcUNlb2VISXNM?=
 =?utf-8?B?cHVMRFFKUGM2NzZ3TmtxK2V1UHNnZVFGRFY2ZlNIWkthMktPN2lXS0lEQ1BB?=
 =?utf-8?B?SnQ3d3ZRTmp2Q2lzZmlJUERBM256SmIvVm5PM1dDN3lHeGJNUUt5aVFRa3pL?=
 =?utf-8?B?eWE4RXRYaXZNbUFZdk5uWUZrQUtMZ0NYSlFFeG5FTm1hbXJjMUFmem1nK01y?=
 =?utf-8?B?MjZXc0orcDJTbkpsQ2VjbVBTVkpaUmRBMzNUd3hiQkZZTHNzUDNxRUZ5OTBF?=
 =?utf-8?B?TlJGS01Jc2RZNnR2UUVsVko4azVPSTBaSHUwa3VSeS9uQlBIc0Z5cXdzejRB?=
 =?utf-8?B?aXFLTFRvbE9uSjRNMW5MNHB1ZjlsZTlVZmwyNEMzSXhRWjZnOWFtb3VIVC9X?=
 =?utf-8?B?THFCUWZJOWZwSlZvcnN3b1B0V244Nkx6Ym9iV1NhVFF2cmp6OGRpTWxXWFY0?=
 =?utf-8?B?UDZTdmJSR3dwWVJ1MWdYeDJLcXNWeWtvK0N5SDhlUUhsL0hkZHZ5azZXd0ov?=
 =?utf-8?B?RkJyL1AwLysrcEkwVmJ3dFF3Mkt3V3Rza0VmOEVlMmtXOUpXaERKN1dvOGVu?=
 =?utf-8?B?M3lWd0JPbEFRelJDUEN4ZEgvN29hN1g2NTZtMVZLYW82MUpnc0o1ak9qbDk4?=
 =?utf-8?B?S1orZFVNL2gvTmIrWEVRMVBoREZzVVk2VTFWSXIvbm9YUnltMVdVaWxYcEVH?=
 =?utf-8?B?endNWUlKOWtxblhjcGdUNy94UlRQczloUkdtQWhiMVMyVHliVWY0NkNldTU3?=
 =?utf-8?B?UjJ4UVFxYWJsUjhRT3Q3aFJLSnVNZlIrWXBZMi9WYnpkY0JVSytTcGJTS1Zh?=
 =?utf-8?B?WThQVURoaHFsUS9EYlhnbk9BdVA0TkkwMmxreWJYbmY0eWZDa1JFSjRHNG56?=
 =?utf-8?B?RTMxbmZVbTNKOGFzTFUzcnlla1NHNzd2cmlNUSs5RHVSay9CYXpQVXhpdEhx?=
 =?utf-8?B?dzFHRkUxUGR3MjhtVHVySVVvWXhZUWlTR3pwL21MN2p5Y3VuRlVXa1ZkVE9o?=
 =?utf-8?B?V1laRzcva3phdlY2SDJudzJDUFg2Mjh4OWpmOEJEdEtUbmZHUmZIemNKQVJC?=
 =?utf-8?B?NEJUREFsQk1MY0ZESitSd09id0wxbVVOakZTdXdIVG81TXg3L0lmeVRZTFF2?=
 =?utf-8?B?bEVneDA1NG9JYWRhQlNHZkFoWEwrd0J5QXk0WlFSNGg0Z3d4Q2kwVy9EZ2ho?=
 =?utf-8?B?ZGpla0oyR0ZzbDRJQS9jeFhoRXIwaHE5ZEw1bW52U09hei95M0gxV0ZYY2M2?=
 =?utf-8?B?VHNkK1lab3hzbHhoWHdRTVlkc2V6cXJMc2tLRmRibk03Z0czdXhpMWUyS3o1?=
 =?utf-8?B?dDBwN0x6VmRkOGhPZndGM2xuZ3c0VjlSYWNBb0k4a3gxbFZMVVdvL2tiQk1S?=
 =?utf-8?B?M3gvS1FVdjdsY2Z5U1NodFpjMHArd3EwOHJqSEdhNEErQnllcm9WSHVYc3Ra?=
 =?utf-8?B?UlNNK1IyV2dYbW9Kc3JCMFhUMUt5Y2krRmNDcEV0dXhQc283S0s2emxXUlI1?=
 =?utf-8?B?UDF0OXpuSkZOT28vdzRVazBaSjVnemRZaFNhZHl6TVdtKzhWamFTK1R3a25x?=
 =?utf-8?B?cGpRdGt5b1VaTUdBSjRFQ2Q0QkZvM1hTVEkyVnZlNVlCbE92UkhvMWFtRFhN?=
 =?utf-8?B?c2N1K0JYVlkxbjdyVmJJRDloNUdGY2NSdjl0aUg0RTI0VUt0NERCTGtaK0VN?=
 =?utf-8?B?cVJOZ0ExMTkxL2pCZ291N3Z0UWhROExPRCtsMnFMZ3hyWXNIbldTOEVkWFl2?=
 =?utf-8?Q?LR+NvixZygZByV9g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f79e6da-e324-4f6b-f041-08de7bb607dd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 19:24:48.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhwq6Lp1C5bGXhYQcxUL61RmghY1pCG09DzGegvcaj6rWlvYgQdxPt7cYhIhMYFcvSgIof+O7JRiHMAwzcA+W4FiZ9R6gsMuN88pPbx0SPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/6/26 1:47 AM, Ilpo Järvinen wrote:
> On Tue, 3 Mar 2026, Reinette Chatre wrote:
> 
>> Dave Martin reported inconsistent CMT test failures. In one experiment
>> the first run of the CMT test failed because of too large (24%) difference
>> between measured and achievable cache occupancy while the second run passed
>> with an acceptable 4% difference.
>>
>> The CMT test is susceptible to interference from the rest of the system.
>> This can be demonstrated with a utility like stress-ng by running the CMT
>> test while introducing cache misses using:
>>
>>    stress-ng --matrix-3d 0 --matrix-3d-zyx
>>
>> Below shows an example of the CMT test failing because of a significant
>> difference between measured and achievable cache occupancy when run with
>> interference:
>>     # Starting CMT test ...
>>     # Mounting resctrl to "/sys/fs/resctrl"
>>     # Cache size :56623104
>>     # Writing benchmark parameters to resctrl FS
>>     # Benchmark PID: 3275
>>     # Checking for pass/fail
>>     # Fail: Check cache miss rate within 15%
>>     # Percent diff=97
>>     # Number of bits: 5
>>     # Average LLC val: 501350
>>     # Cache span (bytes): 23592960
>>     not ok 1 CMT: test
>>
>> The CMT test creates a new control group that is also capable of monitoring
>> and assigns the workload to it. The workload allocates a buffer that by
>> default fills a portion of the L3 and keeps reading from the buffer,
>> measuring the L3 occupancy at intervals. The test passes if the workload's
>> L3 occupancy is within 15% of the buffer size.
>>
>> By not adjusting any capacity bitmasks the workload shares the cache with
>> the rest of the system. Any other task that may be running could evict
>> the workload's data from the cache causing it to have low cache occupancy.
>>
>> Reduce interference from the rest of the system by ensuring that the
>> workload's control group uses the capacity bitmask found in the user
>> parameters for L3 and that the rest of the system can only allocate into
>> the inverse of the workload's L3 cache portion. Other tasks can thus no
>> longer evict the workload's data from L3.
>>
>> Take the L2 cache into account to further improve test accuracy.
>> By default the buffer size is the same as the L3 portion that the workload
>> can allocate into. This buffer size does not take into account that some
>> of the workload's data may land in L2/L1. Address this in two ways:
>>  - Reduce the amount of L2 cache the workload can allocate into to the
> 
> "into to the" sounds wrong.

How about:
  "Reduce the workload's L2 cache allocation to the minimum on systems that
   support L2 cache allocation."

> 
>>    minimum on systems that support L2 cache allocation.
>>  - Increase the buffer size to accommodate data that may be allocated into
>>    the L2 cache. Use a buffer size double the L3 portion to keep using the
>>    L3 portion size as goal for L3 occupancy while taking into account that
>>    some of the data may be in L2.
> 
> To me the this control over L2 looks logically pretty separate from the 
> inverse of L3 portion control so it would seem like logically belong to a 
> separate change.

Sure. Both adjustments are needed to get results described below so I'll move
all descriptions surrounding the before/after performance numbers to the cover
letter. Looks like partial fixes cannot use the Closes tag so instead of Closes
I'll use the Link tag in both patches to point to the original report.

> 
>> With the above adjustments the CMT test is more consistent. Repeating the
>> CMT test while generating interference with stress-ng on a sample
>> system after applying the fixes show significant improvement in test
>> accuracy:
>>
>>     # Starting CMT test ...
>>     # Mounting resctrl to "/sys/fs/resctrl"
>>     # Cache size :56623104
>>     # Writing benchmark parameters to resctrl FS
>>     # Write schema "L3:0=fe0" to resctrl FS
>>     # Write schema "L3:0=1f" to resctrl FS
>>     # Benchmark PID: 3223
>>     # Checking for pass/fail
>>     # Pass: Check cache miss rate within 15%
>>     # Percent diff=3
>>     # Number of bits: 5
>>     # Average LLC val: 22811443
>>     # Cache span (bytes): 23592960
>>     ok 1 CMT: test
>>
>> Reported-by: Dave Martin <Dave.Martin@arm.com>
>> Closes: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>> Changes since v1:
>> - Fix typo in changelog: "data my be in L2" -> "data may be in L2".
>> ---
>>  tools/testing/selftests/resctrl/cmt_test.c    | 35 ++++++++++++++++---
>>  tools/testing/selftests/resctrl/mba_test.c    |  4 ++-
>>  tools/testing/selftests/resctrl/mbm_test.c    |  4 ++-
>>  tools/testing/selftests/resctrl/resctrl.h     |  4 ++-
>>  tools/testing/selftests/resctrl/resctrl_val.c |  2 +-
>>  5 files changed, 41 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/selftests/resctrl/cmt_test.c
>> index d09e693dc739..44e9938dfafd 100644
>> --- a/tools/testing/selftests/resctrl/cmt_test.c
>> +++ b/tools/testing/selftests/resctrl/cmt_test.c
>> @@ -19,12 +19,39 @@
>>  #define CON_MON_LCC_OCCUP_PATH		\
>>  	"%s/%s/mon_data/mon_L3_%02d/llc_occupancy"
>>  
>> -static int cmt_init(const struct resctrl_val_param *param, int domain_id)
>> +/*
>> + * Initialize capacity bitmasks (CBMs) for control group being tested,
>> + * default resource group to prevent its tasks from interfering with test,
>> + * and L2 resource of control group to minimize allocations into L2 if
>> + * possible to better predict L3 occupancy.
>> + */
>> +static int cmt_init(const struct resctrl_test *test,
>> +		    const struct user_params *uparams,
>> +		    const struct resctrl_val_param *param, int domain_id)
>>  {
>> +	unsigned long long_mask;
>> +	char schemata[64];
>> +	int ret;
>> +
>>  	sprintf(llc_occup_path, CON_MON_LCC_OCCUP_PATH, RESCTRL_PATH,
>>  		param->ctrlgrp, domain_id);
>>  
>> -	return 0;
>> +	ret = get_full_cbm(test->resource, &long_mask);
>> +	if (ret)
>> +		return ret;
>> +
>> +	snprintf(schemata, sizeof(schemata), "%lx", ~param->mask & long_mask);
> 
> I don't know why this is variable is called "long_mask", the type seems 
> pretty unrelated to its use. Perhaps change it to e.g. full_mask?

It is called long_mask to be consistent with the same value used elsewhere
in this file. This is not required. I can rename to full_mask.

> 
> Seems otherwise fine AFAICT.
> 

Thank you very much for taking a look.

Reinette

