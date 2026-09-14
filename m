Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E672490C1C
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404770; cv=fail; b=UMK8TFoFF/EIH6lqDEErMXY7zhGoDWNtFe+vCMgSXjoOrx+KwIbFmuP1TWYDhIl3w4c6HbUfuDIN++nuAktCgHb89RBcWUWmOUjv70pLksjPlQmREOatCCPEZeh9CUk6aLRUl/byHcd+18s5CRtILdepoCfpzfNNMqAHhl/oH/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404770; c=relaxed/simple;
	bh=YT1LSmeL9l+Y96sxoQbC131PbS7W/xI1tn5zMZ6ojAc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=plnLG+PyHMTVISV0jb5L/bmpUnLtwoQlUXBv+ZJwSZtXy7WH0xctQbev6PpdZYYd7Tl8tQ9NFmLHSruc1l0UbklKOsCVtmQr11/n8m+EmABs2n5ODE0ygOhZvJWN50ODHPCcZQSeAKXAlwlw4AzF0wNdo1Diy0LkDimVFMYPyKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BymLdO62; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BymLdO62"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789404768; x=1820940768;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YT1LSmeL9l+Y96sxoQbC131PbS7W/xI1tn5zMZ6ojAc=;
  b=BymLdO62qKhgZ6j4PU4RFvjG29qBMMx9DlCV/97Z4u5XrfvnHbR0ujfA
   NGEBSlaiZybWro1ARC3NZ++X5Nrdhq4Yrfp2Qhmjz5P2BalrPpb6tlnxK
   AI2Ikgc/L+JEb3sLl7Kk9FtwzoIHskTeajs+lqL1Mo4CVBCZg/BzVubS3
   EV1qO2leUFLM07ZgtLpnUA/Td/Sv6HoudmpR01+0B5H6Z8WhmU3iw2bqV
   3kheq0AIUVkUlUaI2L0Ml0YtfhSiz70nLLDIKyH1MEimFCECTAfP/46lj
   Qp13WCr1Xj8DfoAzDY8XKP3CYqsXZaq4SrLMV4eg4gJpwGovU+fZqX2D5
   Q==;
X-CSE-ConnectionGUID: H8lCC2dRTHixdpL4LcputA==
X-CSE-MsgGUID: Kx3v46/yS6u4EXn0g9PInw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="92271358"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="92271358"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 09:52:47 -0700
X-CSE-ConnectionGUID: jlSm0CTTQNGGYyyRvi1wSw==
X-CSE-MsgGUID: rvjk1x7sSzu+SYB6tz+yNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="269009763"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 09:52:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 09:52:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 09:52:46 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.29) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 09:52:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4xJJQRRTCWdWr1fnazMbaQry8pvn5W262vrIh99uujVBk8tMdwn5sBiJp4F0tGJayx3JECduPkzsrkNJZl5qQhb7u1hW8uPWHcXZkX+no6BFPVfdxx4tcfRS/+W8cLDirZ/LY+prm1FSi9qZk9ci97kfnKHkJWO6a75GJaNv/ox0Qp/3h8v2hde3FoBeRYvOrkIWxGakrWd+EEcQjj2aQm+rlCypMeKVva+wAAAswGdM/n05JeugU5w6x4bi5zgtf8cXuKdvxbZB3ZwiVC2vHBe1OubAE87xJ9CHF+4NEqQ6UhzuNCxouEMIqbnNX4VV+aT87f9hvO2zCWrikhGug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D30AXCDpkYxtWCDwCcyiBylHMMBhaV7DbFVXUk1oQdk=;
 b=E9Wcz7TiXp62QQDLVgWl/liiK7YQ0sL8wFqjWK3CjVbhT5o+52Smj1XYg/KQcjwMAsLXjhb3np5TDos6H7CrHjXuooMHJ69CIR+mSQzNtMbhlXU+s3wvJZpE3CpIs3849q6peASH2yqdVwWqUrDYrx7qORXn4gRvl1truf27vn83ggHlNYrsaqfPfw5eRI2gSZTyKYJKgcEtBIcuX0kHG34alml9tx52cJVHddkQvoaGeg0JiLciD0YY11k4xyOxf0Cp2NBzlz/+RS9kS2u3X3GsVIEcUErgdz2vNs3Xxs+5+SYlOySjcFrBu1LB874WUUzcD7gSkvWES0zLuukkYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CH3PR11MB7251.namprd11.prod.outlook.com (2603:10b6:610:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 16:52:42 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 16:52:42 +0000
Message-ID: <4a5276ca-238c-418b-872e-3dd495b50171@intel.com>
Date: Mon, 14 Sep 2026 09:52:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <babu.moger@amd.com>, <yu.c.chen@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
 <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
 <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
 <26e294a0-76a6-4ec0-9df8-021a76bf8ed9@intel.com>
 <86603611-b20d-4a0a-a247-8cebb11b3432@arm.com>
 <071d3dc6-6c18-4287-af26-719b89304058@intel.com>
 <d403b92c-aae8-499f-8c73-933a2d757fba@arm.com>
 <3595fe1b-0621-4599-b94d-a027336a2ce4@intel.com>
 <3571430b-15b5-4451-97e4-455f9fd46f01@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <3571430b-15b5-4451-97e4-455f9fd46f01@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:303:85::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CH3PR11MB7251:EE_
X-MS-Office365-Filtering-Correlation-Id: 101adcd3-3b8b-4d6f-aece-08df128097a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|4143699003|5023799004|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: SkMIfBEXTRi4gVEusnn4EEVS0nNpjr0XvAkwMfLdt3yScKpVBRAvLJ7u32XYhcwMf9XtwD2ZwAoHCbjM3ngiNLz7qLDBKw4hZ3R8ROXBiufK5QCIMoiqwb/n+qMVGHuPe3E9sYbIomvR5cJnkfOF8u/m8kYyZvyEsOocvSmkefiUgGxznOxTN8fOmMOFwN8iegxB7Iv0MQbsT5QC1Vu8hL6hvk0k11vXlStEoYdw949QNu06yvXTYE8vrjf2C3O07izTOsQ+mLNCsJG0Vix+ogffQ4LzYWGbUJ5fE+xwmgFBSCyQBNnNYMsqcIUzMTTDc0vY+iiM4sX6FQYAXz6g5IsBr7U+7vxlAmvwiSACoBU/zZAUEa1mCyRTt+bxy35fdydtSEPB8vqo+YojRb+h6LZ2typS7hgxKEoYRliVv+j4nEeyhZLuxGQ3DlcnhgdQSaJqrQpVGVkMntZGkWDnZMr2UVrz5ZMKslZxTPicHUkyFqmT8tjcfMDLAdpM0pDGqiDbvqfyTMFHWv5ZTnEiF0czX3H0hrRPVSEZoonZvT2p9zxmeUJms9RoFkmBXMXYr+HeI8rVLmMMLlLCmnlrOS9jwyTihL/qN2P1XQupHA7BRwWoq/DR//j/QeGzt3tFwRNmFzUqETkXyWTFoXpj21KiU2+K5crhtSdvJSfMleY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(4143699003)(5023799004)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGRyNVFiM2M2T3BuK2I1N0NiWDROYkpvVE8razl4cW1BNWdCTDFueTlIaFo2?=
 =?utf-8?B?eEZnQUlmU0JGSU1XNncrWVAzeFZVcmx4V3UveXNadWhxZmphejI3QlRDOG9J?=
 =?utf-8?B?aXFqYWFwUmJzNm5iM1ROeWVHSEw1bU5Jakg4MXcvSStqVTU2TENtL0FkK2Ru?=
 =?utf-8?B?b2RxNitQdjlFU3B2YlJJN3QzUDVPZVBRSDV0ZUg1WHp1M01LOFNxNEQ1RFFU?=
 =?utf-8?B?YnVXQXdrU1oxblJYenVOZzdBUTJGMUhwNitVWHk0UWREN1JHRzZoTXQ0VmFR?=
 =?utf-8?B?SzMwV1dsQXdlZ1AyWVpHVFBDV3Mwd1FoYzVNZTAwV2VhWGsyWEFtMnRMRCtj?=
 =?utf-8?B?NURLTEdtNVBPbUR4dXBEVlZ5MXpXdXkydlFVcGwzekx0bWlCOE1ZL0RSVXJK?=
 =?utf-8?B?bHArSGNmRlhNcDhXK2FLeCtvNnd6T25qZ0dEMk4zNlV4ZEhHcXVtYjNHR0F0?=
 =?utf-8?B?dDJ1V0YrbTcrSmV3OGY2b0Z3K0FmeHFpdnAvTDNRSmNXWUovL2IrZVQ3aVZT?=
 =?utf-8?B?OUNpTHVJTTRGdlZqcnU5Nms3YlFFeEhLV2RMVkRSSXlLM2RVemlJdlhNVjZL?=
 =?utf-8?B?ejNqQ1RXRHgvRHI4aHYzeEQyY0JmTnM0c1hDWkRJWUkyR29GeUg1V1M3SWc2?=
 =?utf-8?B?QVFFUWdiOVZVSmRXaTRML1RsSXJGUDlMOEVJMTgwTUE3N2lIdFl5R3ZrbTdw?=
 =?utf-8?B?ekdFMHgwKzNZRnFraHF0UXBCcUpYcndZZDEwRWc1dkJoelQ4eGdmM25hMlJI?=
 =?utf-8?B?MmlNVFBFYXZlVm1GbGZmU2xzaWZkVG9sUG9oVUZsRGdoQWh2dXZHS1FLQlBj?=
 =?utf-8?B?bFVGSmVMM0YyRDRERVAwQVd0NVlWTWVmVXlXamlxSUo3d3lEc2hOSzFrNUJU?=
 =?utf-8?B?Szd1QWJIUkJ4QmZ3MUpvdDN4QzJWbDAzZkU3eTlMdlFEOEYzRHZaRlNtTU9I?=
 =?utf-8?B?bVJMbEZDbFFrUGFTbzBTcGlteTRLKzZvK3lOOE5WUFRrbkM5NkR1KytaZXIy?=
 =?utf-8?B?bUtjcVpVZ1Npa1lPYkp0L2s0VVVXbnl0RCtSRGlCNzZEb1lUMTBXUHBHK0h3?=
 =?utf-8?B?dFJpQTNnQ3JRSDhXN1BXSmQzK2xsSGVIUzdCb3lGNnNBRXMxWVVPMHJjTGxH?=
 =?utf-8?B?QlYweXZkNE9ta0h0aGJqcklMY0FMbnV0d1p2Z0g4ZW9ka0M3bENuZjMzc0gw?=
 =?utf-8?B?M1hrMXRKSlJJOXZBRm5HdDZBUE5pb2xxU0QxNmtSdmJ1Mm9OMjRsZmNwSTNP?=
 =?utf-8?B?STJackpzSlduRk5JUjk1YzkyOGo3YWg1YXB4akdlOUNocTdCeDgzNkxTNngw?=
 =?utf-8?B?dXkveEpBaUU4VUtCOVd2Zi81NWN4SVV0cXhTeUJ3akJ4VEh2ZHJ1bmFqT2l0?=
 =?utf-8?B?aGlXeWRsdC9vR1RQT1l0Q0FRRWdJVHkxUUk1RFZnVUlzTnl6UWZCeDVDR2Y3?=
 =?utf-8?B?ajRKMVQ3TDN0RXBUTkY5T2hnQ0o1UmMxMzIxYmE3TlhFdFRaWnZVNTBnUFBp?=
 =?utf-8?B?ZGxxblRPY0xSRWVCMUJncCtOUjdsNmNpUjcxa3hObFlYb0pRS1gxZkNNMlBW?=
 =?utf-8?B?MWRtWFFjaDhMM0p0T25kcUFSQ0tMdjQ2QU1JOElPbDJuUjhuV2oveUU5Nldj?=
 =?utf-8?B?TkJkUkpXdUZJWUgxTHJaV29BUkdSRXNjZUZsaU1sNitnaHlNMjJ0Ujc3MmJO?=
 =?utf-8?B?TG4wVFdrUGg1ZUsvVVkrOEMwUW5uV05jTHZRcDhjRkhWYnlXNUg0NHlqNk05?=
 =?utf-8?B?SlRUR2thQjEydTZHK2Nia1Y5RXZJZW1FcEsyUTQwcDBDK2FtdFdZemFjaXU2?=
 =?utf-8?B?aFhVbWU2SzZJL3JqRzZUWklUSHVRNlRwWXpmaVJKOTNmdGV6NnFjYXpJd0hn?=
 =?utf-8?B?MWRBcVlNMjRUU2hoMzRiMXkzbGlyM2lCbVJ5QWtkVXI1d29Sem5ZaEtvK1pj?=
 =?utf-8?B?L1BrbFFVZ3krN0J2K2NmcXRxWFI3RmhLbEx2cWNHUktnNUxROGdrWTA4U09a?=
 =?utf-8?B?OGFqaXJJM3BRZ2p3aE5zQ2tBUmlDNm84M1g0emVWUXVDakFFOE5KOHk3ZDdx?=
 =?utf-8?B?aVI4MFdyakpEQk5zV3hJS25IZk1CSlRPcGx1UUtyaGRONlRBWjdSczViUmo1?=
 =?utf-8?B?cXJEcXZtQkk2T0t5UG84eElZVHBuQmVncmJZWm0yWEZlNHVMMUVRNTNhMFRC?=
 =?utf-8?B?ZHFSQXFyNzAzS1Q2UUxGbS9FL3RkN255RHdqSzk5bjRpSXNhT05QSWd6M08w?=
 =?utf-8?B?eXJwUUkyQXNPYTRGNTNLWlFISThYU3BBNUtaYzhOUG1WamdtUVlJQ1VEa21n?=
 =?utf-8?B?UGNGZE5Id20wOUVXSlhVRTRGZzdjcy90Z1drd0VKUzlrNHFkQmNmV24rcm5D?=
 =?utf-8?Q?wloMj/MtE9aW/JBw=3D?=
X-Exchange-RoutingPolicyChecked: risQg02iRgvOSzn0kzG7TVyQTUjDIeugx9CX8LnpLxRWij4HNJdRY9eX7zR/xt4NnbRZrPjHQDeKTvdNRuVrhwkuuX/iTfucK4O+NqnxWCUI/Ecx4oSWpy3j+gQtWaKC9SIGUxLKiM4Y7qsLnwzG9L3Y1jyRmn05VJmYfyCfPj5pdT27AaTG48wlDsGo4aDru9GQYkhn4iwByBMQsJn3hLy4WfUqmSE4vq4Wzxx5W+4OmOtXjgEWR4W0tnGBmP5g6pWzKD0tUVNUzmCjG7wrJdmVPA9ZWVS6+bZmR5w19I3yGb9M78yHA1NggYIFPzcfkvuGe+rEI3JPxWzpNDV3iA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 101adcd3-3b8b-4d6f-aece-08df128097a0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 16:52:42.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWhF9uR/9/yrTOVYFux4DH24D9cCthL1lNC02uGy3iW2xf7fGNsLUjLv5s7DnxPWVaWI9qFOb4c0IoHut3oUmBkF67EXFMUQ8/yu3BTKEGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7251
X-OriginatorOrg: intel.com

Hi Ben,

On 9/14/26 9:11 AM, Ben Horgan wrote:
> On 14/09/2026 16:16, Reinette Chatre wrote:
>> On 9/11/26 1:56 AM, Ben Horgan wrote:
>>> On 10/09/2026 19:10, Reinette Chatre wrote:
>>
>>>>
>>>> Do (admittedly crude) guardrails like below capture the existing driver requirements?
>>>>
>>>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>>>> index 9d223057953a..dbd06371890c 100644
>>>> --- a/drivers/resctrl/mpam_resctrl.c
>>>> +++ b/drivers/resctrl/mpam_resctrl.c
>>>> @@ -1681,11 +1681,18 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>>>  				continue;       // dummy resource
>>>>  
>>>>  			mon_comp = find_component(mon->class, cpu);
>>>> +			if (!mon_comp) {
>>>> +				WARN_ON_ONCE(0);
>>>> +				err = -EFAULT;
>>>> +				goto offline_ctrl_domain;
>>>> +			}
>>>>  			dom->mon_comp[eventid] = mon_comp;
>>>> -			if (mon_comp)
>>>> -				any_mon_comp = mon_comp;
>>>> +			any_mon_comp = mon_comp;
>>>
>>> This first part which ensures that if there is a class for the monitor then a component can always
>>> be found for the given CPU.
>>>
>>>>  		}
>>>> -		if (!any_mon_comp) {
>>>
>>> The any_mon_comp check could still be useful to confirm that if r->mon_capable then there is a
>>> component for at least one of the events.
>>
>> resctrl fs does not handle such scenario. r->mon_capable guides whether the resource
>> supports monitoring and if it is then all domains belonging to the resource is expected to
>> support all monitoring events associated with the resource. resctrl fs will expose all the
>> monitoring event files based on r->mon_capable and which monitoring events are enabled, there
>> is no finer grained support to expose/hide events per domain.
> 
> Yes. I wasn't intending to suggest anything different. If r->mon_capable then the MPAM driver does
> support all enabled events. Maybe I would would have been more to correct to just say if
> r->mon_capable is true we confirm that we can do some monitoring.

ah - I see. Thank you for clarifying. 

>> If any_mon_comp is true while one of the mon_comp is NULL then resctrl will still expose the
>> event to user space and pass attempts to read the data to MPAM driver.
>>
>> Is this a scenario that the MPAM driver needs to support? That is, users will see event files
>> but reading the data will succeed in some domains but fail in others? 
> 
> No, we don't expect the MPAM driver to support any features inconsistently across resctrl domains.
> If the hardware did happen to be mismatched then we sanitize it, in __class_props_mismatch() we
> ensure the class only exposes the features that are common to all the child components.
Thank you very much.

Reinette

