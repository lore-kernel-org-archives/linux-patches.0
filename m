Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756682AF10
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437813; cv=fail; b=sqPbwrUb4GuOntN/FyZS47ga6el/IJF+kGT3FQGk6/7CCZq5Fnz+/5ZrIpUbLAEtn4GV7KsBND0br4z1plg8BOScsZH3kE4MYZlN83sPVv/LLjmWJZ09/DPICX7uYy0W00xiVbeOVjKBehf/X/Bd4Z/Uc4FuvPKSOI6upSbxPvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437813; c=relaxed/simple;
	bh=ZRodS+rWfOnwi9cvnRPVHnmj0EqcRnMOBC6q3gRTeD0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ms0eE717xTgX7C2ShS2rkbgnt6XlEZiOf4sSX3YnobHDEeRcxaYI5CqADiKe//MaxNQyofsTPmI6sBt7App4lakXHrIoEslsPIhI4GUm0ltyP+e82XhqaVP0zhbRNCBjQHsEIKJ5bbOmpqQnc9m96ziej/0q3xvww6n0LaVi8EU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BFZk63xK; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BFZk63xK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743437811; x=1774973811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZRodS+rWfOnwi9cvnRPVHnmj0EqcRnMOBC6q3gRTeD0=;
  b=BFZk63xKomezy7ov8N/aBCKodyyX8rmBCSruUq8GJJb3j8592HinYYpa
   BKYvS6mB9Pb7H7669j0lAqHAIcTz41v9/ALbJ8g+iwZVOmhbeP5xtjUoW
   eQoEy3eOI0FFQnfyGoBKFjK65/t0TexYx8IGjql0RzWTGVYWFyLwDa9H/
   EaaSa+5ATRrnesJtN7wNs1vYlV3vaUA4yi55AGECuvOk6ZZ0yMCDrv65u
   N9wRQkvvzcKARg1nwsJFm8l0OlhLtgpv8dN2yUv+joHMNDqaRrcqN76EI
   sYUUme+IdXhYgmGpB7uKqSjc0lVf3SVrItjCdrisdahL7YxoLXOfhAQcF
   w==;
X-CSE-ConnectionGUID: vzsmPcBoQAyAksuvJqrlvA==
X-CSE-MsgGUID: JHwFacfYQveKoSabZ+HkOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44742199"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44742199"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:15:45 -0700
X-CSE-ConnectionGUID: SWQ4RPTCTyic5kfbY3ORSA==
X-CSE-MsgGUID: 77n55fPUQ2iwUsJ+mTqSxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="131134068"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:15:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 09:15:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:15:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:15:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpsbivv+kkRpkde3ur/ubAyyVrk9lCWRdpIwBrdCpoVWDI/Zb8a40r+iys6iLMy3KCeUmEGbt0cqGln1JLSmxREsJ5VS91UHxzt6Em+QCqKhiRyOHqt6oFTRavuEiA9sCtwtWX44DovsyI10p2OXnK9VTq9TxhqGcXj5PRFm5yC1uCFu3T9hGyKdK/hfFyy3t38TjuV1xGy1injE0Thk3oSFwiX29CxpZZ9vXm9YdsZUFYrIRzghsGkz+58QbOWkmASIbp9v6Ab9PAN0D6XGDjzwu5LScmwC8liRItaH94z6xfcs+agfq/zflNOVrCMjb4d/RMMHYAjTyJ5/y2dUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRodS+rWfOnwi9cvnRPVHnmj0EqcRnMOBC6q3gRTeD0=;
 b=hjdvS9xIGAq/SI2L7fl9Um4MA2jzpUSgayUk4DpvZHZTTnpSG1F1rVj1UUwkcVtLHH5273tdMxtFNl0IPA21nK7En01U1eAHn5d31gtrX1MVb8p21RbfosWHgrfhnlu3zKS9HE3xZs6C/RhlHAZc7ODGE4cI8G0vyBL1oS2YryeUPA3189pdrdgrkY48YAvkSz9mJTmh4VDzba4dWB0VfLK8f+6l70eoBJMFLXcvq/aOkeEkcN+z/ujRfQWc4EBv15n4te6qELS95EZn4c+Kej//z8vnmJV2Qx9AzBRTa+bl4bwdR1k1ovVPV9ZA2X5QxTy8k9Sp0e/gDp0vWmws3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5768.namprd11.prod.outlook.com (2603:10b6:510:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:15:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:15:38 +0000
Message-ID: <012377fd-e292-42fc-b348-4bb5e5becb97@intel.com>
Date: Mon, 31 Mar 2025 09:15:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/16] x86/resctrl: Change generic monitor functions to
 use struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:303:8f::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: af399a70-ca7b-4e34-011b-08dd706f464a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Tk1DMFYxYzlyNDAzb2xKR3NLSEhPVW1HcUtRUEYwdUFOUEtOQWVjeFhLVjlK?=
 =?utf-8?B?WThNUnVCUkI3UHQzR1crQXNZMDNoZ0FrcVNodkJRazY3SE4vVGN3TTc0MG9E?=
 =?utf-8?B?NC9yRXVDTm9JQ2dCc1l4SGVvYWZiZjJQM0UwUXBiZkM2Q0FHOG1DU1IrMVNJ?=
 =?utf-8?B?K0Q3OFdrbTFXWmhGZ2NkNEQzQjFza0N2TDZqYTJudjJPemRwNXpoeEJOL3gv?=
 =?utf-8?B?OWZaZXQ0WUExOXN5cGI2a3EwQmZvVGRhYTlDTFgzbklTd3JQTXJVSjRnckh4?=
 =?utf-8?B?Uzh0clIybGE0dHJNcTJtNnlmR1JETTlJU1F4RmhBVUhIc081d1BlUHJFcjFX?=
 =?utf-8?B?eVAzenU0NWdaVzc3dXBramplVko2RXNESXhkamdXejRvTVd4NWFuK2QrbHJm?=
 =?utf-8?B?TjFtR3VvdExybkJPZllsTm43Q3RIR09nRVJDQ1FCT0dDcUQwUzhyK0gvd24z?=
 =?utf-8?B?ajMyaU16UytJTGFhUHdzUkJQRDdSZDQ1VURBWG5rcm9pdXA3eHdjQ1JMUXNS?=
 =?utf-8?B?NHJRYzgyMUo4alozQ0ZpUXdlSkxQQlV0c3ZIWFY1V0tOT054Yk9lYllDbHkz?=
 =?utf-8?B?RmFHd2ZlTENuNWZuUUliYWN2ZWd4T0ZrdEk1bUpMQnZxQzVmWEpLczRhNFZP?=
 =?utf-8?B?TWdoR0lQNEZLcWE2a3pmRmRsaTV0YWNMZ1FiUUpmaGFYNE9nMk1JUUNOc0V2?=
 =?utf-8?B?Y2tJTzRmck1YbWk0b2M4SmRhOTlKODBTL202MU5DWXdFcWpyUmUwTTVUcDBs?=
 =?utf-8?B?M1dQdGgzNXVBVU9rSVp1SDJjNVE2OGc3TTdlYk5NWmovOWQ3VmU5SXlIWDVq?=
 =?utf-8?B?bTc2ZHRkMUlGNkplbWpkT0J0cm5RMzRrRHlKV1UzMTA4MGJwQm15VkowRUtU?=
 =?utf-8?B?TFpJOEE2SkhxMzV4WU5WU3JZYWNEWk1sOUF2NGZ5WlQwdUlzZWpuTnZ4SDNZ?=
 =?utf-8?B?RjJTTjh3U3BpRDgwNzN3eVZlTFIxcGs3U3kxOFJaYWpIVXFFdW9ld3cvQk5M?=
 =?utf-8?B?WEZmUW50eFE0N2NyZXhQWnJuL0RHSVpsQkhaWXFLenZmNUpybldYYVU2NURs?=
 =?utf-8?B?Z3FDUFhZa0x3emxDUFd1T2ZRWkFFYkRzRnVBSitqM0R6NzFhb1p1YkQzaG1R?=
 =?utf-8?B?Z0Juc09WUWxVKzdyZTgxQVNTbmU0LzQ3WXdOUFg2alNSMmFjMGoreGVkZ3ZB?=
 =?utf-8?B?NDRROS9xcHVtWFAxQTI3MlN3Zm5qTEpPWWcxMS8rd1ZDY1h4L295MFh4T0x4?=
 =?utf-8?B?d2RIekdJcFA4YVFlVjUvcDU1QzR5RG95TW9CVzl5Y21INkpZcjZCQ3B6Vk9j?=
 =?utf-8?B?cFdUOU5ab1V2OG5UTlZ5cUY4QXJJVTRVVFgvY0ZZUXFUWXpsMWY1MHNRQ28z?=
 =?utf-8?B?YjErOURnSjd6ZEN4WG5SWTd4cERHN2ZBYUc5ZW83Qlp2R0E1d1J0RjJnWG5H?=
 =?utf-8?B?MU9JTnVXcWUveWIwclBIMUhheEVyL2NkUlZGZ25veGFRb25kTFJrSjV0a3Rn?=
 =?utf-8?B?cklsRWErR1EydE9TS1ZkdUdPQUZMWlpkUVI0SFl3QlpVYmdLVjJRb2xWRTg4?=
 =?utf-8?B?MEJ2a0p5MGxCVThnOWIvd1hWNDcveG9yRHcrQmFJN0RhYnpUNDdib0l5bCtk?=
 =?utf-8?B?TzB2MFUrcnRWOVZGWElqNUZXZmorR3lCdWt5Zy9xcVZhVWlKaDlhOWhWSG5z?=
 =?utf-8?B?Rkt0ZGZmMFVTTnpnOXRXdkJQTUVKWE9KR285ems0emk2QXpZaE1xTXIyMSs3?=
 =?utf-8?B?MnZPQSswc01nZGZOejBqdld5SnhxUnlFRWF1amdTT1E4dGhBK2g4MVBsVVRt?=
 =?utf-8?B?MUdZMWdPMytSLzVKSVprRG94RGVrc1V5OGppRUMyN3JOQkVKdnZ4Uk9hdHUw?=
 =?utf-8?Q?+OaqIOHnb2JCk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUhKMDZOUmFrVG1Mcko5aGpibUI0UEV2ckY3S3lIS0VHeTRXK3RFTDNacTVj?=
 =?utf-8?B?V0lQZDNHSjBvTGpCSnVxV3RjK05CY205VVVGbVBYNjlGaHNoYy9yWlVNS0RL?=
 =?utf-8?B?cWt1c044QXlGdllIN2kxaEhNazhTUVJaVHU1N0VjdDVySEpCanp6SUd6NFlH?=
 =?utf-8?B?bkJ2UCs1VE8yNWFybmQzTjFMNmMrSDJVWXU2QTlJUjh5V0lCQktZOXJFLzZK?=
 =?utf-8?B?a2d0YXF6TzNFRytwVHkwbkhrZjVNbGdCckMxZGt0VFBFUG02WWcwRjBjalBE?=
 =?utf-8?B?TkJneGx0WWtxeWZVZThiaHhRajZVV2JTaHBTRU5HNjNUMU1Bci81V2s0TkZm?=
 =?utf-8?B?bHpJTkFDWW9UaG5QOURvYllOaXBvWXFuYWlxTGQ4S0RUZFRCeXhTTU0wREJP?=
 =?utf-8?B?RDZpV0JWSk9FZGZIdFV0UXZuMEtWRHpOeE9QSkg5MlRYdkEzQjdyYTRKM3Jp?=
 =?utf-8?B?M09MWHk0L1NWY2tVQ0lnNUpIOExjM2ZPN1p6TTR1U1FLWTdHVVVoNDgrU1Vh?=
 =?utf-8?B?NkhPQnRFbUN4eDd4aVhWSHFRMjJQakU4YjJVZUpoV2RoU0kxcE5KV2tUdldv?=
 =?utf-8?B?R2pnempsbCtRcUozV2txMERib0grSzRlWjcyNWd6YUtvQlUrdnBkTUNHdWpt?=
 =?utf-8?B?cWI0ZjkrTEF0ZVNDVWNBOG82ZlpOMzhIeEJyT0VCWDNuSWlOdkJvaGFuaVFP?=
 =?utf-8?B?aXZWaFR1bzNlenhOS2FUR3BrUE8yYVJleG9vZEtQdzhPdy9rU2lkT09uUkdx?=
 =?utf-8?B?eUxvZklwLzkxY2xIang2RSt4VFNDcVZvYWhHc1lNc1dDRzdIekJZai8xZHVT?=
 =?utf-8?B?L3hvWDNmclNLa0RoMHNxbmJaWWpIdlRrUWxDa1BjR1RPYnpTZUNvb1VGZ2Z1?=
 =?utf-8?B?RVhyeSttWk44VEVGaFRmeVhKNVJvTnVLTXE0R0xpU3k2U3JKdGRZM201ckVH?=
 =?utf-8?B?N1BBMXZrdVdlNFFIZDdNeUgyQ01hTG9QWENWcjhKNFBpTTkvNWRRaW91aUFV?=
 =?utf-8?B?TjJLT3lPc1hyRDdpY2tZTjZXQ0hyRUh2RWFZazJpd2V2Wlg0clcvdFVlVVR6?=
 =?utf-8?B?NUNmcjVHUmtqSWFsTmJ1ZitNYllBRHZ3c0l3dHdhT2xyTHEvbzl0QWFFN1N0?=
 =?utf-8?B?ZVkwVk9RSWd4U3dIZWFYWFI1c29GckxjaDlyMW9aeVVwek5UQlNZN1F6dkY3?=
 =?utf-8?B?VzZleGFQNm1kamhmSW0xMnc1TXh2dEJOOEYveVFyNXJrRVdEU3UxL0wzajB0?=
 =?utf-8?B?LzlzL3QzcXp0ak10TW02NHNlQkNScktGeFRUQ0Qyd21EMjdDZDZabE9GMitm?=
 =?utf-8?B?NjhTV1MwK3RvVVlMZ0dIMitua2FkaysrMFBVd1hNL0UxVWhFR0ZPblgvL0Mz?=
 =?utf-8?B?Qy9Xd2doRVRYRHhXSHVHemFzMmZKVDBuTjJHZnJJZDhYL3pNT1dEY2JSKzJh?=
 =?utf-8?B?WGliaFN5aitiK2I5bmlSajdFSXBGVUhRcWRFNzhkVDcrTy9IcS9ocFR4UERL?=
 =?utf-8?B?Rm4rSDIxWW9scHpVNkk4dlNWN005UUd4RFB0bGJVeGY2MzVLb2NFam15ZHRX?=
 =?utf-8?B?VGFlVVp1WXhoOGcrY1BLMWIxOHN1MkN1NXRmc2YwRHJPZGhHQjN2ZU1nVXFL?=
 =?utf-8?B?SlRTcDdKVnBPWGFJd1VxKzhNSmtmZkRza0hqb0JpcloxbWU2bGduWGpheXpz?=
 =?utf-8?B?S0JraFh3aTVXUVdXRlllVFZURi9TWkREQnlwMTZPcytQZWVjRUtBR1pmdGhV?=
 =?utf-8?B?VFRaalZvcktiVmRWRnR2dWtGSjloMzFhTUhKTkg4TFR2SEhJUi9GQlFwNkVU?=
 =?utf-8?B?LzhFbjBUNWpyTldXZElZdHRSSUNOMmMzZmlWOEoxTjNWRUJXSEozRm1BeE9p?=
 =?utf-8?B?VkNnTEtPWE5mM29xWGtybDJVdVIvbktJbkxoRWY0ZS9peWtIN1hRckd2SWJj?=
 =?utf-8?B?NEhTV2xDVjdhNUVmOW44QUN3bVByVWlYNS9PT1dldFRGc1FrZ3h5RVZHaCt3?=
 =?utf-8?B?RURFVU1JZ1pxY1hscEsrZ05IUDcrVldHUDROTjBucHJaR1lNTllBa0o2T2JS?=
 =?utf-8?B?bFJHdWp3MEhiaUI2akpGaVV5ekVRZ1QyVm9YV1ZNQktXeHVmVVNlWVFvNU8z?=
 =?utf-8?B?amhJbERKWlNvenppWmI4TGhPalh2U0p4UnNsTWxjZ24xVnhrYmJmV3lFZFhp?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af399a70-ca7b-4e34-011b-08dd706f464a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:15:38.1213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQ8RswfmaTzvbatwVbf1tP8vyDlchXA2WbbfA93SlB4M9sDt0wC2iX0VAm2Mh+986wzZeXKFsxtd/Hwft893Xd9YKt5dakSrToRlNZLXR6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5768
X-OriginatorOrg: intel.com

Hi Tony,

On 3/21/25 4:15 PM, Tony Luck wrote:
> Functions that don't need the internal details of the rdt_mon_domain
> can operate on just the rdt_domain_hdr.

This does not seem accurate. The functions are modified to take rdt_domain_hdr
as parameter but then the functions are modified to extract rdt_mon_domain
based on rdt_domain_hdr .... and proceeds to operate on internals of
rdt_mon_domain in a way that contradicts the changelog.

Considering what comes later this seems risky to me to rely on the
code flow to interpret which structure rdt_domain_hdr forms part of. I think
that it will be safer if rdt_domain_hdr gets an identifier that reflects which
structure it forms part of so that the accessors could be made explicit and
have error checking.

Reinette
