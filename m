Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934E92609F5
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749009453; cv=fail; b=sSaVBsm9vN8+y3VmIiO6+Vqli1HmygK5aTEsKt7/tSzUCYz1gDmA2BLq3tBGZZMClTOKorS7GdRB6aysw5GK/lT+gR77hoBhXb42PqWX+T+z7KA1IFFFbkuncNtT0rZgEKfZoyrfxI9Vg27UdW7425j/lz9pbioWiXYZkdA1QVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749009453; c=relaxed/simple;
	bh=KPtBNZWxOa3MJjkZckSYMLDuxQfNX3Z7MMkmBA83W9I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ni9dbu14B9OsCq1ouGsRpm4uf9IBB7zVjeH4T8/4SDKGo6W1AajJk/pznMG+QLbOijNEQ8kHQ/I4Lc7cAUF5+fhcMP7VcdI8/3ivmR/Z1HzpHl5dmcCqvYbqT/hmHCRA8MBbuFX0hgII77StdXkTM+80o44OnL81bISgMIf/Pd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gH08VQIV; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gH08VQIV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749009451; x=1780545451;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KPtBNZWxOa3MJjkZckSYMLDuxQfNX3Z7MMkmBA83W9I=;
  b=gH08VQIV7xPaAZ5fnG41Q8y0gwwXIrP6y5mxS7aCX+eWbKNVLrLMzPn0
   rrhfaa6hySz0Ku8Bv8sk1tdGjbWotnmMV3hiqx5Bfv0otHzW7QHgQ6/rN
   BqH/lBoT94L41Fe0J5sgkh8jbwoadOZ6vwdgkF5XgIQTDEbEUUkSRiufr
   nDo0zDhSbNgSGI6A5KAvUG2LyKsGwqEIUonMsPCdUE6N8+JiLOTtgFxIe
   I+L0UineHBsa/NjD5fqL/VC3Y8z96VhWRhVXsX0D3yh5Py2gJHbUs+dF5
   MQtBGwfYiD0RSnNx8IVTNqPx0jsERBcq6oPUYe6rLswaUU1DNh6ug/1y6
   g==;
X-CSE-ConnectionGUID: gS6P7D4aR966DuxJgqZZAQ==
X-CSE-MsgGUID: KKDHv/4LQLShdgpGp/icuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="68623091"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="68623091"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:57:30 -0700
X-CSE-ConnectionGUID: FxwcWMVkTjuWty4pd4CStQ==
X-CSE-MsgGUID: e+d4iwx5TdqSobLWr5CUbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="182233668"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:57:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:57:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:57:30 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.82)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:57:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rO47pKrVOe1olr6ep5J17cJZviF3aFNTHjqfvsFv+tuOiIzRCRG1SdWUotfsuHoj+8ECYo0juTOQdN5QLCYWi7ASkRVcxojdlvHclHMkHTsUD7kyB99ScOKJZRZXQ50/+w/JPcBB/abQl1Y3orcb0nA05yDhEwyBK59V+AxhAGzCOqlLTCunF0mB2F8kbRXWqrUHWAEubLVIRIQS+uzQv05aNagn81fjIL8YLpAuFsIaq4KAcri6XHhF7I+3ehyu9zR9hSNnBZoPfCj6aNHD3BQlt2vLP9v0zGGhF2ZWfhf7OjqVID7qDb8szwog6Ihm8NtRx7cUcYrHCmUE5GPbIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63+DABSoBuOYBFKDAmoHbGFGNNPG0URSDt7pmlZ/pg0=;
 b=Ru4ypK1vYDyUZZFKqeUxGGSEk3/GqbeX8AZRhueOkRsvb90hP8K0CYBh1lxCs2jrqDpJPoZ8GeJ3CSuCSTqEotFcY9z31mXkKtkvCIacoYfb+i/NsTMAqqMcZ8B29+WV1EuML4C3bHju9zF1dOoobcR7x0grKMdxFnTCyyIIniwNJso2Y8BY15tA4JQI5i7q6nRDiRJ6jTXEon4a9kQH87X9c3iJ0peFYPDr9qnYYBFwDX1++BYmXdm905lRtgfn0ZbA9uZvj3D0xXtZVLDFnLQW0Mwrx2T+s/NEFR204PX443xksJwy2x6uJsG1iKh1KxlYmm/46YZOp55dsLeisA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 4 Jun
 2025 03:57:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:57:28 +0000
Message-ID: <643ad0b6-aa39-4c4e-b9b6-7e17d2cb0a67@intel.com>
Date: Tue, 3 Jun 2025 20:57:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/29] x86,fs/resctrl: Fill in details of Clearwater
 Forest events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SCYP152CA0055.LAMP152.PROD.OUTLOOK.COM
 (2603:10d6:300:148::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: fb38d828-d756-4f11-54bb-08dda31bec4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T0RhZStyaHF6OGZXN3lkc25lT21MSlF2NE5IY1UwSVpJSzZYdi94QzdaRE5B?=
 =?utf-8?B?YUcrejVHNzN5VnM0K3VtQk1jNmkwU2FqQW9KM0Nkd1NWQXF6ekdXd3hXMTBv?=
 =?utf-8?B?NmsxN1J1Vm9vSHhsM3BIUSs2dkxJOWVWN0xuejJTUTZuNStaQ29nMnV4ekFj?=
 =?utf-8?B?Qi9Wa2dwdGpCV1N2Y0d2Q0crRFVPUU9WdThIQ0RTV1Vmd29YUUFHU0FUcThL?=
 =?utf-8?B?WnhOdzN5bGF5ZmJsVFA2SnQzWDhyOG5HdkxUQUNZWnJMUG1uMTNZOUlnbHVt?=
 =?utf-8?B?SkQ0TG1ldkRBVFVNSmtQOWZMSWNlM3NTTmRtSUFETGlSVmR2ZmlEZjBSTnU0?=
 =?utf-8?B?OUxrck9yK2MwU0dJRUVIQ3ZJZ2x4d0c0RlpLdkJVOXZxSmtHZk1GNnZaQU1p?=
 =?utf-8?B?ZGZTQ0tRRDNsOWdmeE4yUnJFT3lQaUZYTEl4RkVLNkJ0cGxqWnI2V3R3VWdl?=
 =?utf-8?B?ZUJXSHBZbkVhM1ZONGQvb3BXMklIK2ZVbnJka1pjYXZZOGhyYlpEa21SLzV3?=
 =?utf-8?B?cXZaNUFDaVVDRGZrYzRFOWp4YnIrUUZveUUraDJUbEhsTENmT0U3UDFuQ24w?=
 =?utf-8?B?SDY2aExkdUhFdTVlM1NWQjR2MTJld2NqMGRJN2NkY0Z4NHFmNDZ3R1lGR2sw?=
 =?utf-8?B?NXg2SVQ4QVVCYUhaSVhZRFRUZEdTYnVQdFBvSWFhVFE4TWZuYUgwbSthT3cx?=
 =?utf-8?B?NnJVWWdiVEZ0bHBLYmRnZWtEOFdpZy9uc1J6WnY4QkVwZy9tRWxPR3Uzb01M?=
 =?utf-8?B?VTVrVUVGNm5CRXAwMHJLN3hMQStYdURpbDVKUXhwRGo5cFNkczhrTFcvYTdz?=
 =?utf-8?B?L0xHMFRDY0tKdVRTWHZ3RUd3K2pSTFBFZk9FZzRycnJleHpPUmlRdThLOE9t?=
 =?utf-8?B?b0p1K3BNSUtGZnFNOUc1VHp1QmJGVWFjRVpYbUh2Y3hSOUdRRytacWJIM1hD?=
 =?utf-8?B?cHMzeGphZmlxVSs4VkF4ZFpEcURsY3hib2lOQVNNOHR5eUlkTWZUUzg2Z0U2?=
 =?utf-8?B?REtHSXNldml1Nys2ZXZvSFFlbFB3QS9saHNxc0oxbkkxUlRNaHZWZDFoanNh?=
 =?utf-8?B?TFBybjhkUUtpaWxSNUJuWVFkWVNIZTNwbGxMaHp0Y3pTWjJaZ0FhSExxOUJq?=
 =?utf-8?B?Z2wwWTZWaDdJeFJwMmFoeit3WmZrOFZmL05YVDJCbnVjVmR5T0xKK055VGd3?=
 =?utf-8?B?WHNCYTR1dFMvZUNhVEVNRjUvUVJTMWpSS0plSWlwN2JiRlBZZ1JOMitpZ0RP?=
 =?utf-8?B?RDlEVFQvaGdrU25OYk54bHFYakN3VjBlNVJ2UlVpRlY0WmNCVllqTEQzcXZ4?=
 =?utf-8?B?bGxsYktma1Njby96Z2psMTIxSVZoMndXcVk1RW5mL1FjUEREbGtVeUJCZExi?=
 =?utf-8?B?RWhoeVo3bUx5L3k1ZGJXcDlCNHZlSTZteWgyWHMxZGtWNGVmSS9qWUxxY0pu?=
 =?utf-8?B?b1pPRU9oL09zdWdmNzBNd09rNHFlRHRqaG4yQnBUeHR6THJ2aXhKcjJjaGM0?=
 =?utf-8?B?NTRINTlPQ0Jxb3hsZjFrdzZOeFl4ZW1Sbjl5MjFSSDYxMktZMzJSM29vOTZI?=
 =?utf-8?B?Y01uSW9yVVdCZXh0YzBiMU45UWE1czUvTWVWbVFoNUwxOWx3RDZrb0YxYmp2?=
 =?utf-8?B?UW91YTFvNzh4V3JNcDlxMXYxS0VoenJraU9iS0tIOEc3ZmJLYytaMFVKQ2lo?=
 =?utf-8?B?S2NaOVFMSHo5cFRyTWtzd1BlKzNwTTdsc1U3TEJiRTZDcWQrTzJxRCtpRFNy?=
 =?utf-8?B?bnpQakFlbHRHVTlsK21TY3l0KzJSbEx0TXhoQVpBY0JwWjVNK1JzTWRIQ29l?=
 =?utf-8?B?d29RRFJmMVlUanRzUnhBS1pOUlpVcVpIdmxjUzFvOC9EYUxiL3BCUDdrMTNC?=
 =?utf-8?B?TnZRRXVKcjVIdFJSV1IwUnh3SVU1VjNLSGZ1RzRJK0dKTHpTWHZvTlBocmxw?=
 =?utf-8?B?TytBNmpqMHA2N3ZOVEQvRzUzTGNjOVVJS0FYcFpaSUNpZXRBRG1pUVlOWXNJ?=
 =?utf-8?B?MzRZNDRSSE5BPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlpCSW9HUGVBWUhHbWVXZGpoY1JwcnEvTDRwOTJPS0tsTEN4RVNWK0NzTDlw?=
 =?utf-8?B?Q0ordURGOFlCMGh6RzlNVDlrdnlxMi9OMVB1dms5YTdTT3BJeTBBc1JZT2Nh?=
 =?utf-8?B?dGREZHhGZ0xXaUc0TUtUMUIrYk5CY1VWZmRHZFZISHpRaWRBallSMWpiSlNL?=
 =?utf-8?B?anJjNWhlZC9YTFlNMVYzdWQ0ZEZ0NW4vNDU2Mk12QzRYUUtnMU0vTWZXMGlP?=
 =?utf-8?B?Y0VYSk81bjh6S1pHTDFtZUdOdm1zQ1pXMXBrSkhMUXNVWDR1ckdnaWpXRFZi?=
 =?utf-8?B?TDZ0ZFdWUjR6WXRaNnpydjFtM2N0Tm4xU256TzFXNjJZMlUwdHdDRUtEWEpN?=
 =?utf-8?B?SlYvTTFOREFqZ1pGTjYycjdVMjVhQUJ5VFVwczZyVmlNOVE1d3M1aVhpbXk1?=
 =?utf-8?B?REFlUlBJcElwWHlKbDE5dGRVU2N5M2p1a1B1RCtld00wOENsd28vMHErVEZt?=
 =?utf-8?B?b1FQZzVTNFVjbSt3ZnJ6VUN1YXR6K0Mwd012YlZWTHo4QW1YbldOeWxzTGF0?=
 =?utf-8?B?NzNnR2pVOUp1TVpsVkVnMTBPUllxZGxmTE0rSUxDMzI4YWVlUzlHMlBQSkkz?=
 =?utf-8?B?WGJwbXNYNHRCMzNGZXpOQ0NSVUlQR0RQS0lOeWQ2SjEwMDRZSEFLNFRjRW5P?=
 =?utf-8?B?RzBZbEpzLyt1L0djZGMvU1FTUGt6N0hWUDR5MlRRNkZLQlYzcVVEdk5leXI4?=
 =?utf-8?B?K3RkQ1UrN1NoMjJNRU1CcElvY0pXZUp1VlRIcktDbjVrdVhqMzh1dDBzNFlH?=
 =?utf-8?B?Z01ZODZCTll0Nm9tTzZ0NlRLd3I3cG1NNFNhTFozRC8yNXkrWlhxUFdUNVJl?=
 =?utf-8?B?ZkVkd2dsbkpzVHNVQ2QzY0hZd3d2UzRwVDNGQnhjUE9jSnE1Y1Z3S1BwcnRV?=
 =?utf-8?B?TFdiZVVzVVpINCtVQ1N1N1lpQkdidnh0V3hBOFZhTVpoQ3JZc1U2MWEwdHJD?=
 =?utf-8?B?U2xHVHNCRU5jWGN0d2dhN2gwdTNLVEt4WjMwYTB2VGphanNHRzBoSDJWRHdT?=
 =?utf-8?B?b3c0SzhEUHhNeUxNRTRadGpwUXdpQStWRG91c1dIVE03d0l0RFRYcTkxTW15?=
 =?utf-8?B?T3ZuN2h5SWc1dGhyTWZhQUNMMXVsbmh4NUg0WU1IWTZQeVlNeUNoaDVWVU1B?=
 =?utf-8?B?bmNKdURjNEthV3RodVBjKzRucGdVWHRiU2JDeWQrMGNMZjhKcHJ4VDByMExG?=
 =?utf-8?B?enhEMVFLa0RQUENMZ0hoMlZvMmJUaHVnMnlTN2pIWnFYalRZaVk3dkxZWnJq?=
 =?utf-8?B?WGlXVk9mSnlFS29JNGN3WWVlODlrR0hXL2c3ejJTUGNwRlQyUEcvN1Zsb1Z0?=
 =?utf-8?B?dnpGeUFMTXV2NHVzRkNaNHhIQzNwREJUc09xSGRWRUYxRW5BUCtpb2phdUNP?=
 =?utf-8?B?aVExUDBrTkM1K2dNRTZYRm4vdUFxbW5lditVbFF4TXBYQ085c2M0TVlRcGxk?=
 =?utf-8?B?bkR6blJmRjRmLzBmL0ZWdVVqR09oZitsR2hrU0VCTWx6RmRoKzZzN3ZTOVJn?=
 =?utf-8?B?OHhVUmE1RDhXQWIvKzI3QnZvNlRqcy9KdEc1blZ3SW85Qmo1WmJSVFVtai9O?=
 =?utf-8?B?RkpoR3Bob1ZiVDNBT1VPcFpVSElqdWxrTEdra0YrcVRCUVZNWFNQM1ZpVkJR?=
 =?utf-8?B?ZWEwME5KYnRVNjlaQlhycVJsb1pjUHFYcTN0clNVNm9sZnZwUWpmQmE4UFBO?=
 =?utf-8?B?UFdFZ3V1YzVFeGorYlFsT3czU2NSN1doS2JmeFBGWkFhWnBqbFdYV1FSZTlU?=
 =?utf-8?B?S3hyV2ZsM3JuTjBUMjczaDQ0T2tBNGFTS1FGUjdUeGQ2QnRCK2plZG1TQ1dt?=
 =?utf-8?B?YnpFRnB3c21xMXdXMXAwMEZiaGpmcEZmcXYxSCt0OXcrYlZ0R2xYbHR0cEhB?=
 =?utf-8?B?NVlWT2RRRXhkcU1DV2lTdTI3aGtZRTNqNVA3TTdyL2w5OHZpV3V5eEJzL0Zi?=
 =?utf-8?B?TjVmRWloeU5CUnJUWGxQWTVZQ2pIZTNLUlR4ckMzSlIvK2NOenpwN1VKd0x6?=
 =?utf-8?B?Z01kT3lMSGRQak1GSGdzd0dDYklxZ0g5U01INUIxS1RXK2g5UTF2T1g0VEwz?=
 =?utf-8?B?OGxGYUxYZ2Q3UFBGTGpGZDRSOWkzT0lDR2R5eldISDNSUmZBdUFqQUZaM1F5?=
 =?utf-8?B?Ym1DbXlUVWJzMStRVjJmT3g2WFZoVitmU25PWlRMUnA2RlhUeUdWcVhqNGY0?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb38d828-d756-4f11-54bb-08dda31bec4d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:57:28.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hypB0nKg0yy+zmowJjxSQpOs3ZR4IxTVSIx35W+nUjB0bGgX2Jek9ps4fawUEVIQMR9QozfmNTKexJnfiTXvURWtUhX1m4iGVglta4M9uA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> +/**
> + * struct pmt_event - Telemetry event.
> + * @evtid:	Resctrl event id
> + * @evt_idx:	Counter index within each per-RMID block of counters
> + * @bin_bits:	Zero for integer valued events, else number bits in fixed-point
> + */
> +struct pmt_event {
> +	enum resctrl_event_id	evtid;
> +	int			evt_idx;
> +	int			bin_bits;
> +};

It seems redundant to have "evt" in names of member when variable will
already have "evts" during access. Resulting in code like:
evts[i].evtid and evts[i].evt_idx when just
evts[i].id and evts[i].idx would be just as descriptive.

Reinette
