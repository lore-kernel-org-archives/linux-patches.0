Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B408A236430
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486338; cv=fail; b=LHiqqaTTZodtMmxITJ9Q1+K+CnVvECmDKpLrl6YPbZawmLhLx3PGyfHxP+4Vj/tMv3M6ZXAIWE4gOPhAMjytlGwFDSnfXeDXJd55pLOGRGFpJA/5mxZrpDvBCBtWRTHSS1vzXEDXvfUBcglpUxWWLl8MhGtdEw5VPMp5I3Q8img=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486338; c=relaxed/simple;
	bh=vg5qI03Nk5XhYastdgJoMXCTfNcsQYs3bi8XR4KQG80=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lm/pyGVpxQ/N9cFAwqKDnl3s/esKpu4N1rwqLvquYI8zxIZYlIdt3SA+ljTemg3xRi6J50TyBhpCnIi9dZVxf+BEJJ3tc6ldTVosD4agkxxw/WwSEhCivw3zlfR0dSG+Tq2EWajWRCngg5mB1gUuXm7EYwafDfiq3uA8HjXE9wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lJDPavLl; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lJDPavLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486337; x=1785022337;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vg5qI03Nk5XhYastdgJoMXCTfNcsQYs3bi8XR4KQG80=;
  b=lJDPavLl4bb1EC4NNn54wKza2w6hcXMSlqiU0SoZg12qltFU5LINU880
   AI0Gn1QCB7o63ooN/n88IBq7Zadk2s1xBQMP8Bq7eZ71X0R9y66ZXLK9o
   aAt4NUNEV5qYeRJ+x/6kVNnqlnGLtgF7pp1/AjdAtUT7X/gtsv6pbCRjv
   jq7hRe1/NnnCR9Fqx5AHtPy3GdAyuwew7MRA+A/g7jL2GxQtSSr4/pGQV
   Ywkr2PshJeCr3mizGjQXbyRJxEVfb6btbE/O1QdTYofVry7OofM4pCKhr
   cKdhw1CVPPjH9mmi2RE4VELYdwTELSX8Ceazrp0P/Xd9iTB70diHZhEMu
   A==;
X-CSE-ConnectionGUID: tupRhITFQVSDNb/fFdjHMA==
X-CSE-MsgGUID: ndFH+/gxSDuLhHAcZpAzVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55792553"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55792553"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:32:13 -0700
X-CSE-ConnectionGUID: 08qB6esaQ5C7yaJ4W0BBRA==
X-CSE-MsgGUID: VrJkv3gBQMiLJ5vjcNT8/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160398126"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:32:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:32:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:32:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.86)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 25 Jul 2025 16:32:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LI//+fKU+2qn5LvhAC9i9WoB8RH/SOwReKLo6A9Q+yiHyFbN9dGCTJWWLG0e/k/6E+2qeRymF6/c+3/sXkIXYe9iOODcMcqb2SqhewJodbGGN18nEOkFjS0LDfaluEu+HUYD93d+ouO6XGZH9jmdqTKOTQ9HDNdQ4//JnGsz7kvaDcPWu1VwpgH5pdcZpIqPD95pSyRl70BeTdl4UUaKAhlmQaCGsIaQH1ZYt8M8vmHoy/gNmj1a01OlPRx1jwvyPvSrH8BeUCOpZaM+E0V2VyMTFUsXIdjKokfAOZtQjUm5J8Akvplm4H+Tef6cQwrdK5fDDQlvBSu4ekcOyWlf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKQS1Q7MY0HFvUAhfoW8OWZr+JBH6SnoCv1nLckAJHI=;
 b=AHLNK/6ivmiInF9mBy+X6JVWlN2qcFVE38D4DEbdLy25hsxi4IGKgrgwjbiFBe/IcAxd/ndY2AZz6ScbhwZh+ufEX+pL1QhAVasiTmoiY/fJxBNPVybhkIRUi5LYDJY/cR42x3/HBpkxM0s0vRBjLXy0ki7BeTdSP4FydNf8SkYgLod37k5Z2dIYsK7rZ830spi+gl8DhiN9o4qO0nn6Ss2OqjASkd0UH4DYV/rpwAwu3fu6Gnp/Uqd/lIKE4IVxeof3xNGASQRlNqUYjQPz3WVNGexx8YMG4REgaaE7TVqzdVC5romgkgsW/zk9ZdqkZzwTQ59vdEqumedHILBTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 23:32:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:32:09 +0000
Message-ID: <578818ba-e646-4118-a2c1-54bcf0be4050@intel.com>
Date: Fri, 25 Jul 2025 16:32:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/31] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:303:6a::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN6PR11MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: 81de72e4-1870-4a05-08c9-08ddcbd379a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S1MvbDdNbTNabHhpWng1eDVUSmx1S3hoeXNvaEY0SGtVMTg0ODhKYUMxRU9B?=
 =?utf-8?B?bTlVTS9OejlSNVdDdngyNFhWSUptSHVsMjdWbjBSZTVENjVWVk9LaHNvZTU3?=
 =?utf-8?B?RzNLUjFINWNocUFMQTA5VmNvUVRpOHNrL3BCcy9xVmlkM0trdjlXWjVtR3o0?=
 =?utf-8?B?Vlp5YlN3ajZwTHRrMEFvYkJZdnViTnF2OUFBRm1IU2twL2lOYUhhc1ZQM3Zh?=
 =?utf-8?B?UmxiYUNWZkZnajFmd2M4d2kwcGxjQW4rcmZPSFlHYkRzYlBKcitkTzM5Q3o5?=
 =?utf-8?B?QUJQY2dGaHdQM2xNdTI4U0lPMnhlcURVU2tFMXg4VjdNcndRcFV4bFZ0cnhj?=
 =?utf-8?B?U3pkdzJGZlU2L2Jtc2xBRmZ0ZXpUd0ZDSGs1Y2xaTTAzZTlORUpsZzNKb3lo?=
 =?utf-8?B?R084aFVYNTZCMkJ2czZhc0VYeThBNHQrbUY4RGdsdVlVVkVQWEQwd2xkVnhN?=
 =?utf-8?B?c0d6ZHpqV0oxTWlXRHFudFQ1NFdHNWt4c0JqbFlYa3lxaUVsbGF5Z3BsMURp?=
 =?utf-8?B?U0Rhdzgvc1QzckdCcDJGbnd4d0R1UzBiNkJFek5kYi9rRFVIV1dMWlZtRy9a?=
 =?utf-8?B?d2dDMENvc2pCZXVtN1ZNMGVVNWhPSUtGeTB6dWN5cHIzeXMxNmN4L0tYdnUv?=
 =?utf-8?B?U1RSYjBrb0d0SnNhRlg2OWppMUdKQjRzK04wWU1GelFlbCt1OUIyb0gzVnlZ?=
 =?utf-8?B?Mm9WSmFlcE9EbW1oYkpIWTRJYThldlMyWXFVRGVwSU80akJ5OElySG9ZVVhs?=
 =?utf-8?B?QWJnOGlHTTY4SDJnTXdEb1AxeXBFL3U4RDJLTUdSOThQMlIxRHdHUkMyTkE0?=
 =?utf-8?B?V3drMGtFQnVxTjk4UHBVRG9hbjhyNEZ5YThWbXR3NkYvOVhpUW91UUJoOFNH?=
 =?utf-8?B?OFRpTytpejB4clZMb2dpQ2lNdFFnSkUyYkNzR1IvVmhyNGZOZG5mWklYaXVs?=
 =?utf-8?B?cHpIS0JCYU1ZTTE5L1U4d0dVRkdWdENOcHN4RGNpNnE3dW9VbElZU0NMQVQ5?=
 =?utf-8?B?NklUWVRIRDF6ZDZreHFvV0NoWXZ1UWpiT2V6d1hSWldYWk1uTXpTN3FHdVVr?=
 =?utf-8?B?TUhtNXJoMzM5Nmpja1lSc2RVVzNHeGZPNnlEdGRIVm5Vdlo1LzcxK3pGckVr?=
 =?utf-8?B?RFhHNXdFMitSaFA4bU1YYU0wWUtYUURnaEEwUlliWC9DcFR4M1VDN3FEV1Qv?=
 =?utf-8?B?Z3RTOTNuSzl2Z3VjZUZhTUVGWElTU0hvWWQ5NGNLSTM2SlYwcVpOMUtvaHJP?=
 =?utf-8?B?eEZkaDBaSkdhUGZmT3NlL1djQXE3R3FRejRyOHh5QW5NRzNvNTNLV1BsOSta?=
 =?utf-8?B?a1JMdXVvYW5oZ3ZsbTdnSUZWbWdpVzdZR00wVFpyZncreXA0VXZoYmZMUHRM?=
 =?utf-8?B?VHlBL0RVWjlLakFPVGpxZDBNVUV0K2FqK2RUbnZVRkhiU0RVVGJWNjFwa3Iz?=
 =?utf-8?B?V3pvR3NpUU1FYjNkNlRSa2krc3cxQ281V3dYOU1jU2JnTkZSdnF3bVNnMXNZ?=
 =?utf-8?B?VkhZUUFaVmFqbjMwdVFNaGxOeVVCazAyL0E4ZUhRZ0JIMHhUWW54U3dnbFhp?=
 =?utf-8?B?YXVDY0pYRmo2UU1BSXNiaFpjcW5PZW43cTBGNGtqK0tFdVltdng2QWhUWC93?=
 =?utf-8?B?Z1NaSTAvZDcrck82V1BMOXo0RHc3SnVNRXFlM3FWSTNMVDVqVGprVFBsdnZI?=
 =?utf-8?B?dkVLcEJQMjhtdW1PTEZuMXQrWHFBMmVBd1l4TzJrZDBaU21Ob1owTGdDV1Ni?=
 =?utf-8?B?bitDanhnWDNodWZlMXVzMnN1OTlCcUYvN25FY29HWFpXeDNGOC8yS3dnQzB5?=
 =?utf-8?B?MDFMa3UwYmNlcmYzVUljakExMkVSMXQrZFRwVGxCKzIxMjRvanYvcDQ0eENB?=
 =?utf-8?B?RDhoY0FRL1ZSSG1QRjJ0NmpuMndwR1RaSnB4MFNCbkNWbEFueWxOdW5VTWxz?=
 =?utf-8?Q?RhVpXB9QKAM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ZjOERDbGtsUlBFYTJoNGNldVFBNW1UWlFJMDk1bUxoUXZ2dnd4NXd5VEdN?=
 =?utf-8?B?c3ZYZDFDSU1xaTN0TnIxa3FBUjZobVpzOHVOc0xpOWpMVW1BaGc3MWM0ckpC?=
 =?utf-8?B?L1M1VGxMaEM0UkRqOWI2cUN5Tk5odFZVL2NVSm9QK3lwbnJYWUJqYTZBd1Bt?=
 =?utf-8?B?ZlVlTHVUWmJNcXh5NUNyUUExdlJKUUVETU5LNDd2dlJHbzZDaDRYTXYrOHVi?=
 =?utf-8?B?RlZhUGt3RVoxc0ZvUVpQN1NoZjlLQ2NEemExTlhubmJTSldiRlYxOWxnbmFX?=
 =?utf-8?B?QXlQN3BHQnArbEZEdW5icituc0NGVWlGS054NDQrWndNSkpadlFwSUVsOHc2?=
 =?utf-8?B?OFQrSWdaOTdWa2xRZ1pJcnhPMytxS3BPTzJ3cGxNM3p6OG03UE1MRExsOE5Z?=
 =?utf-8?B?RFVUbUZLaUE4OTlwMW9mOXkvaDJzYjRGaU1VN3gxejRkNW5adkRJMFFSa1Yz?=
 =?utf-8?B?d3p0eFJLMzBUa1V5WG15TDRRTm1LUDd0aWhZNTJOL3FPczNKY0R1UmNYK0lN?=
 =?utf-8?B?OVFRenNXNmRXYURUbS92Vlc1NVYrWTNjdzZIRTRRVXM2VkoyTEJiNjRZWkRE?=
 =?utf-8?B?cGdTRXVLZmRnaWo4ZU53SjN2b2dLcmhKZjNlTDdlY05hL2VLZ2JjTVo0V0tz?=
 =?utf-8?B?OGkreG95elN2dDdXRmdrNE5qNGRSSEhLZGgxQ2RnaStkK2htVW5GclhoL3g2?=
 =?utf-8?B?UTB5WVZrcUhxcFVBdWtDbndsVjJJeHZiUkVwVUswY1poaFpMcTRBQ2RGWFcz?=
 =?utf-8?B?bzBGK3Y5dGZOUE5iRjdGRTV3S204MXZXV0V2Yks4ODJsOUt4WUxaY2dYbjdv?=
 =?utf-8?B?UnFsMUlDc0RxeXVJRkpOZVFNeUlSKzl2ZVZDVjFZZ09iMkpPL2QxMU93U3J5?=
 =?utf-8?B?RkFWV3ZYTlVhQjU3cmtzNzJJY0xkaldJSFlaMHQ1SnVVanpkd1lWbzlQbDVZ?=
 =?utf-8?B?ZlhScUppNnpjS3ZxSm5kMmxIMGRvd21TR0VnYndGeWxRUnR1VlM0bDc5ajY3?=
 =?utf-8?B?NzZWMm9ZRFBoN3RYa3FMTnhyRkl0dHJ6U2hEMXZudmpkMm9xM25vMUdIY1c3?=
 =?utf-8?B?a2wzKzA4OUxnVFhjd3Z4d3V2dkVzREU1T29pYmw5cHVaajVDeEZaU2lQZTdC?=
 =?utf-8?B?MzA4YWFTeEJCckloMlZJNW1GWHVHdFRIR2t5UTEzT2V6alRZNjNuYkpTU3BD?=
 =?utf-8?B?TzZuZGp4T3pMNGVaOGcvNk9VUjAzSDd2di9DUGlDbEFHSHJ3L01aRXBrRTRt?=
 =?utf-8?B?Ukh1eEZtNXFZazd0elpORmo1RFRxSk0xbWNmNCtaTjYyV2l1a0FndmNYTnhq?=
 =?utf-8?B?MjJ2ZThZMklDZUZ4TC9QTHZ5VC9UbDgzK0FGblZqRTIxS1UzRmppNkxxd3FI?=
 =?utf-8?B?MmZ0MDZpek4ybmRqQnFEdzJwTm96NUpjUjZUNERiMHZ5Wlh0Nk1BdXZnMWZm?=
 =?utf-8?B?SDZpOU8wdCtmTndLVEhoSTZIT0ZvR2I1aGRSbS81aWRwd0pKQjJyYm5qOXV4?=
 =?utf-8?B?MXZIdFdtZ2ZTYW1TSVkxVWJhTzBsbnVkT1VBVG1BeE1qK0NKNVMxcCs2V3h0?=
 =?utf-8?B?eEdOWWlpajVDMjlZRjNtd0cvME9PcWQ4MjJ0cXUrWFR5T21oYk0rQUpJQnNL?=
 =?utf-8?B?Z1VZTUlMNzFLbHZIbnJqYU9RNXpJK1kvYmVENzBjaVQvakxCQ3l5Rm5USy9Y?=
 =?utf-8?B?UkVUVW1oWENQQWRjazkyeUp5bEh3TVhYa2t6NkVYQ2Z5T0trYWt3dkRPNXNj?=
 =?utf-8?B?UlV0ZHozQk1EL09lZElOZmxTemd6REx2OFcxakRpdGpXalBaWnFaSG9ya1M3?=
 =?utf-8?B?dTBETmxZQ1g5RVo3aXhYbXBUTURBNk8yaTROcHpvOUFCRUc2KzN1R2VLV1pr?=
 =?utf-8?B?NWdwQi9HdWEyZmhla053Wmp4elRyeUFFeFBFcElBdTNyUXVTKzNGMTB2bjlq?=
 =?utf-8?B?TGZuc2dES0s2SHNPWWV1UzVDYU05WlJNMHNrOVhtczYxL3JPYm1FR1JDcmww?=
 =?utf-8?B?RkR1NzZ0MU1FUlNMYkY4STJJZzlTREtlSE1qdFVCYVRya3ZlQytYSk5VdUtG?=
 =?utf-8?B?OTg0ZEtKTW5LU1padEVwRTkvZExzQXpLaTUzQkZwa2RsZnhUc2lURGRkdkc5?=
 =?utf-8?B?d2NmZ1k4Q1hEWmh6STdRc1RUdEJRa01FdkViWmtocHZUUDlBOXRDSXRrak9w?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81de72e4-1870-4a05-08c9-08ddcbd379a7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:32:09.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcqAmtgKQXnKHdj1tWYTxhvYfghRmeCju3Lo+uFsMzrtr7AoEA6EeHLpY+v0vkgbIoNysQMY4QeqiX5Z8RTNQVHs9KhKgu9J2BbN2BlGk2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Resctrl file system code was built with the assumption that monitor

"resctrl assumes that monitor events can only be read from a CPU in the
cpumask_t set of each domain."

> events can only be read from a CPU in the cpumask_t set for each
> domain.
> 
> This was true for x86 events accessed with an MSR interface, but may

"This is true ..."

> not be true for other access methods such as MMIO.
> 
> Add a flag to struct mon_evt to indicate if the event can be read on
> any CPU.
> 
> Architecture uses resctrl_enable_mon_event() to enable an event and
> set the flag appropriately.
> 
> Bypass all the smp_call*() code for events that can be read on any CPU
> and call mon_event_count() directly from mon_event_read().
> 
> Add a test for events that can be read from any domain to skip checks
> in __mon_event_count() that the read is being done from a CPU in the
> correct domain or cache scope.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 6d4191eff391..a6d11011cb8e 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -356,15 +356,43 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
>  	return state ? &state[idx] : NULL;
>  }
>  
> +/*
> + * For events that can be read on any CPU this function is called
> + * in preemptible context with a direct call from mon_event_read()
> + * to mon_event_count() instead of using smp_call*() to execute on a
> + * specific CPU. For other events it is called in non-preemptible context.

Thinking about this more there are a few more things involved that makes an
attempt to simplify it to preemptible/non-preemptible not be accurate.

We know from resctrl_arch_rmid_read_context_check() that resctrl_arch_rmid_read()
can (usually) sleep and that is because mon_event_count() is usually called via
smp_call_on_cpu() that runs mon_event_count() in (preemptible but not-migratable)
task context. You can confirm this with a closer look at [1] that shows the
preempt_count() is 0. 

Here is an attempt to clarify the context, please consider it critically and
improve:

	Called from preemptible context via a direct call of mon_event_count() for
	events that can be read on any CPU.
	Called from preemptible but non-migratable process context (mon_event_count()
	via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
	smp_call_function_any()) for events that need to be read on a specific CPU.


[1] https://lore.kernel.org/lkml/e818906f-b03a-474b-8a6b-d291cf1a74fe@intel.com/

> + */
> +static bool cpu_on_correct_domain(struct rmid_read *rr)
> +{
> +	struct cacheinfo *ci;
> +	int cpu;
> +
> +	/* Any CPU is OK for this event */
> +	if (rr->evt->any_cpu)
> +		return true;
> +
> +	cpu = smp_processor_id();
> +
> +	/* Single domain. Must be on a CPU in that domain. */
> +	if (rr->hdr)
> +		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
> +
> +	/* Summing domains that share a cache, must be on a CPU for that cache. */
> +	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> +
> +	return ci && ci->id == rr->ci_id;
> +}
> +
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
> -	int cpu = smp_processor_id();
>  	struct rdt_l3_mon_domain *d;
> -	struct cacheinfo *ci;
>  	struct mbm_state *m;
>  	int err, ret;
>  	u64 tval = 0;
>  
> +	if (!cpu_on_correct_domain(rr))
> +		return -EINVAL;
> +
>  	if (rr->r->rid == RDT_RESOURCE_L3 && rr->first) {
>  		if (WARN_ON_ONCE(!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN,
>  							 RDT_RESOURCE_L3)))
> @@ -378,9 +406,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	}
>  
>  	if (rr->hdr) {
> -		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
> -			return -EINVAL;
> +		/* Single domain. */
>  		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
>  						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
>  		if (rr->err)
> @@ -394,12 +420,9 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
>  		return -EINVAL;

As I understand the above WARN ensures that only an L3 resource can proceed considering
that the code that follows explicitly uses RESCTRL_L3_CACHE. Now that this hardcoded
RESCTRL_L3_CACHE is moved elsewhere, should the WARN not follow it?


>  
> -	/* Summing domains that share a cache, must be on a CPU for that cache. */
> -	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> -	if (!ci || ci->id != rr->ci_id)
> -		return -EINVAL;
> -
>  	/*
> +	 * Sum across multiple domains.
> +	 *
>  	 * Legacy files must report the sum of an event across all
>  	 * domains that share the same L3 cache instance.
>  	 * Report success if a read from any domain succeeds, -EINVAL


Reinette
