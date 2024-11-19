Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9022DDAB
	for <patches@lists.linux.dev>; Tue, 19 Nov 2024 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731977509; cv=fail; b=QjqJzeeYwzOCvetRCkkmvmH6oqaMDI2ojsCXFzcBkNnlHZLsCJa8cMOVPNfMpEzLRjG8O2tdibJGm5XlLa6krBkVO/ttbE3t7MLqdt7rMnGFmr9m4PbLZAyfIdcFxj9buuP54evZxGHemBXBDGAvN1lg69UlWofTmyT4UZoQpik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731977509; c=relaxed/simple;
	bh=huhPsKdu5ribCrlDo36XvHJ7ASryEifzcCxtTb+FfBI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bkj4RL2eqSgvlLdhupBKe7XovCSpyTWUlqqB0gaeoKn7OOV8rrVc97SOGqMUqbCqR57CERUzb/bjXNj84mxvcxZK/Udu4lyozo8gBwJdVITz/8jN4chN/r+gdr0zVpO9po+YP4WVt3InJAIMRBwLt1UvrCyPh6dBdgeuBDMD01k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbblTnb/; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbblTnb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731977508; x=1763513508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=huhPsKdu5ribCrlDo36XvHJ7ASryEifzcCxtTb+FfBI=;
  b=nbblTnb/B0tkYgUbrBp7mwLzaZ+NIElyRLE/IQfkPfkeUOyf9myaminT
   X1xxpOWz9yBxEgM4IKCeM5X/m9ljdUvxgs2bXwZeeCsd/zM7swEm35MJr
   nK5QiktudJ6fnen0SAmRwtH8TZQ7FO0k+Qt6DMcT5uYKWsbVkMGLSJvsR
   PaLQzwBxa7w7YaA63rMDu4yw0LWBsZ4aLlbJdsNgAS1TPcjhbxgF1JOQR
   VKyaPdUH7itnBcJ3Ly0UTl6dsJz7hM04OJ3MXprNu07cKWmRBvOJKlZER
   ZA3740OXCT8IMBPnbMIF8LfDO9P20u0QZVlJz6alqBHAc77jmHVNM07OV
   Q==;
X-CSE-ConnectionGUID: EXuBB2XvRkCBR3ypoWe/TA==
X-CSE-MsgGUID: LiRsTDlRT3GSK4oFOtjPhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="31884669"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="31884669"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 16:51:47 -0800
X-CSE-ConnectionGUID: OkJAPchKQLmvWm8KVuqL8A==
X-CSE-MsgGUID: TiYQKxp0SIyFZufMnxPzuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="93463807"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Nov 2024 16:51:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 18 Nov 2024 16:51:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 18 Nov 2024 16:51:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 18 Nov 2024 16:51:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYcJcVfG2kdTKOFoiUdkrvr1MRKJDrtIkpX5xN0bwpDYpoagXs1gl4ZtlO+S2rgtuM5QFgH0AOk49N3D50YqbZcfUBaXIhdi/PpOFe/1+LDEpN2reUMZG56iz0BRTbY/DwngVfJGEvzwe7OL4YMtO3EdQ+hBdJx2SOedpANgFE0weWRqCofjRBQONAoiFEVel16E16oT8V63NkUId6Pyit0w8HsNZ+bkrtXDxstvYrilDn1HyJ+iJ0+Car/22t1a6g3mXKakN/jtFLaJXWrwIBLOYay0ELwItaAek/pSdSiO5pKbZtRRIyW79LuD1hFTrpRruP2721QUnDhTYCeGfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vnXOqmbzeBbd67SdqyRV/05cn7zl2BuQZD1c99xOGQ=;
 b=HpHw53jcVHSsI4iEWl5HWuOjZ8cJboqUCQFn+njJUdFlpk//kPkMe5qrhSc9r3lHU1NQiRv/irUFm8yp6MtZqZlsbdkF0u0a02DHw/77wd0du8OejrHn7SGcKiheY7cypTu1K5a3RV2tuTxOBKRcc4FvsiFkb/3zaS93ESVfA6JcdVJTjIRaEuWopzwxEwVq4NBFyGgmeCobqVe0+0N5n+zqT+zoTUeP1xa/zl4aScB/2d73r72ci2M9saO9I9YjG5B9VdN0hkBz5kC8ZitKPr+g3XUbdDw9G/XDXIECPWlnb/Qd2zMVy5S8jU9Xgo7M/fH/9QYX+Xdsl3MSEhysew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6709.namprd11.prod.outlook.com (2603:10b6:806:259::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 00:51:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Tue, 19 Nov 2024
 00:51:40 +0000
Message-ID: <e6b74022-5066-4cf5-aaee-5a70da9701e4@intel.com>
Date: Mon, 18 Nov 2024 16:51:38 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/9] x86/resctrl: Modify update_mba_bw() to use per
 ctrl_mon group event
To: "Luck, Tony" <tony.luck@intel.com>, <babu.moger@amd.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-4-tony.luck@intel.com>
 <b4b31f4f-7f09-4ee3-9373-6ffe5ea859a6@amd.com>
 <ZzvVSamxTo9QSWBU@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZzvVSamxTo9QSWBU@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0242.namprd04.prod.outlook.com
 (2603:10b6:303:88::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6709:EE_
X-MS-Office365-Filtering-Correlation-Id: db93466e-6b70-4eb8-2b50-08dd0834547a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N1gzRzRZYU5NR2dNbEJvYWdQd1RMUEU3R3JNSHcwaStzR3RpT3VpekE1VGVZ?=
 =?utf-8?B?QXNqWHVmSUxvR01jNk9odjNqVWxrejVmQVFQanR3K3pkK0lIZGMyRFpsOVhm?=
 =?utf-8?B?emNMM3lsQkVSVUR3cVlwS2ZJRUlFdFdUUC9UMG9BUU9uZmdIRVRsVTJYbVBL?=
 =?utf-8?B?M3ArY1VKem9QWVY3ZkFvNTJ6L0svdkJMRnBIaWpBUk54QTNEYTBpYkRzTFMr?=
 =?utf-8?B?S3pYUFRsdUFoTWdYamtzbGVOUWhmSzNjKzJ3MGFxM1NIUmxlb3ZMRHNsNXNl?=
 =?utf-8?B?TXU1cXhTMjNHYUtxOUN5VXVyNDJkU0k3SUdFUjZuRXNOUFA5cERtNmM4Qy9j?=
 =?utf-8?B?eU00eGZUK3FYTHNRdjRlQjBVdlFCcG05TVZ5RWZLMkhVZ1A2NVJrZlBZRlFX?=
 =?utf-8?B?dERXY3RQdEduZDJpaGp0UWxUL2F1ek1CV3RCQjBoL1RUYVgwOHJQVWRJVWR3?=
 =?utf-8?B?a1p5ekdkT2kwZ0xybmJ4YktRbllQS2M1dnlPNU9FOER2RGE0c0M5eDFjdERO?=
 =?utf-8?B?R3lXSGR5bXk3Y1hWUXRoZ2MyNjBTZFc4RzN1a1p1Wk9mY25VeEprRXhCckF3?=
 =?utf-8?B?YWs0eTQreVRwdDFDNzIxUGlJYWlpL2hrZjlxeFpBczlDQ0Z1dkF1b1FDemxY?=
 =?utf-8?B?OHlydGRVS0t2am1uV3FMa2J3RVpSSnFLNEFGdWxmZzE4OEVKTkFUQ2NaNkpM?=
 =?utf-8?B?RFdySkxZUVhOcWgxZlA4M0dhSHdHMkc2SGJJNHNmRTZKLzh5eU5MdWVRM1R6?=
 =?utf-8?B?Yy9ldDFkbFNMeGErTzhPT3N2Y1psMlJHVXFqWVVIeVV1OGtOb3ZteXRRWklD?=
 =?utf-8?B?b2IvRWhUSlRpNnYxQ01hQkpzSHVBZzl4UStGRDNnNmJIcDQweTdNVkFFaTM2?=
 =?utf-8?B?SXVTQU1JaFNpT2pqLy9NR3RxZ0RXRTl1MWp2ZnQ0RG9CU2FPVnZMcjNyeWdS?=
 =?utf-8?B?dDl4cUZOdWVkM20vbkRTakRXVTZTaFVUUFlLU2grTG5ieDVyRUdEdW96QVFD?=
 =?utf-8?B?ekk1eHE4bGJ6eUI0S3FlRnQ1NHNpMHlWdmtXaHN3cnFia2NtVERqeWFPdEN3?=
 =?utf-8?B?eCt4d0dmWkNLRmRmdEc1VXJ0WFBSK1BBSUk2akpWSDUvOUd1WDJQc1BMWnZY?=
 =?utf-8?B?YnFFbGprQ2UvdnI3MThSK3hTclZvVmJITkdmUnJ6ZkRJemJVZUdPVk9aZVNM?=
 =?utf-8?B?S3pDZkdONXdzWDRVVUhOYU1heEFEQmJ4bUxQbmNsbi9QZVdqeE52YkkyRDRV?=
 =?utf-8?B?UEdUN0pndmwwL052dnlqS0tyMlFaKzRnS3Fvbjl1QlhaRHp2c3lZRjBvbXRq?=
 =?utf-8?B?K2Y2a1pvMFNUNWMzQmxpVStvNmlBeUxVam1UbVF0dHVZdE03NjlvUTlWeW9Y?=
 =?utf-8?B?YmV2L0xyWDlhZExTbjhSQmVrSXZGSzNRWC9wQ1l0WXFBWm82NWEvc2hRQU9O?=
 =?utf-8?B?Z2plRWJKSnhqY2F1MmJLQzdGdzBtR0ZwN1lNNTdDMEU0aVBRRUpza0k2Y3pD?=
 =?utf-8?B?R1d0SkVHMnRRWWRiTmg0enpHR0lqUkFGL1MrSW1DYUo1ejU2MmdqN3A1RFhm?=
 =?utf-8?B?TGthdGtiaUtnYm5nVTFWb3UzOGhyUUdjVk5iS1pNN0duaFFDdHkrWmRSOXVj?=
 =?utf-8?B?RkRhS0c1bXBWa2pYQ0I0V1NKZDN1ZjdVdS9ndHZDTk1IVDluTnBuR1J3aWYz?=
 =?utf-8?B?R1NXTGdOcEo5bGozYVBrUHlVTXk2ckhkTStINldSL3EyY2ROM1J1UTJ2UDdi?=
 =?utf-8?Q?eKI4calzZfzX3Tdmsyk4ZS1OjHL78KwwkY594dg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1BlRHVZSTl4ZUs0Yk1sNFNPZDhHU1p1Qm96Vkw5aDB6Yy9hVm54d25vamxG?=
 =?utf-8?B?cHk0Ly9oT3BKelRyek5Kb3l5Y2pYbFNUZFo0ZGxMcE0yeU1pcEdRUExrMDdy?=
 =?utf-8?B?NUU5K0psYzE4QUptQXhRdVRiYUpEdVNmbXdvTkdIRHNIYmM5RmhvME9EdkM2?=
 =?utf-8?B?Y0s5OVJOZzBWWUZWQnZZWHZtRFoxdlFrdm1WUWJEUW15Tzc0aFVTMkhZekNs?=
 =?utf-8?B?VElqT0J1aTVsVG1DWFI1TDFUc2hUbWtISmh0YWNxTWVrMnNCMmNaM0p6VVRx?=
 =?utf-8?B?WUdzRHhvWkYxTTEvNkttMzd1dWhMV3lXVFJtSTVuWS94aFFienF0Q1krclBQ?=
 =?utf-8?B?aDU4SGgyQ0NGeXRjWVJhZFEwbG51V1g2b1d6YmNaTy9mek5kSFpiQlBkREov?=
 =?utf-8?B?MGpuS0pTcklSTWJCQk9IalJnNm5tNFF2Qm9FUzh3WXdqV3lLZDJWSU5sTVZ3?=
 =?utf-8?B?aUFyNU95RnJGUFNBd0d3R0JuVWR1WVhFQ2pZWVNTT0VyMUNUZUJ6VGRLaE4r?=
 =?utf-8?B?Mnd0K2xSMnF2QnhWUG15YnI1cVVvK1RNazlQaC81OWJTelo3NG42bzlMRjN4?=
 =?utf-8?B?QWxwV25wYmdWbUF0YzIyTkp4WE41M0F0R0lyWHFNeW5RTnJueGM4eFpIWEl1?=
 =?utf-8?B?VjAyTnVQUGhmYnh4T1lRUk5kU0U4TUF5RjRkL3pXZjZjemEwOFc3YWI5S3Fq?=
 =?utf-8?B?czh4RWJTUDV4Z1gvMWdQWGVYcTJIekJreHZOaXVtZnc5M014UGNBcUdNYVN5?=
 =?utf-8?B?dmF0anZiVlh2ZWt6amI5TXVwRHNyMGZUTTJabmQwZTRlQzdRWWI4U0lhUWl0?=
 =?utf-8?B?QzRJcXVPais1MEFLK1haRGdVZlRBTTZnaGxOMk9UcEVTTGp6TFI4eFo4S3BJ?=
 =?utf-8?B?WXJCL0ZuUDI5eTcxMUp3VXVlRStTZmQrV0RKcUFKOGdmT0k0UmNLQ2lyRHhU?=
 =?utf-8?B?QndubDAyUTArK0dleTZYRGZWaWtzRFkyWm5PdWg5dGVaaU5WTDJqRHYrM1Z0?=
 =?utf-8?B?U3hmeW1XZU03aEdCeCs1Ynd6OFphWXdUbWMyTzgrd3BVTC9xMDNSMCtqa0Er?=
 =?utf-8?B?M3N3Q2RnVWRxMkZZZnRVdW90dUZwK2xveVB1aGkwd3VtdEFnQmhOWmFoRWxp?=
 =?utf-8?B?d2IvNXRId3ExTGpIZC9VUG9mU2p6Q205QkRhaVBOcTFlYkswTmdVY1k0TjJO?=
 =?utf-8?B?TC9QNXZqRVJqVDlCMFFlYVlMMEZDeWVLZHNreGlaMGxVOERncFlLdW14dVpW?=
 =?utf-8?B?VFpwb1hhaHZ4ODBuMHpOK2h6cVdKaHJKYVNacFo2UnBpVXo2T1hrZ0MrNkRI?=
 =?utf-8?B?TlJaMHFHeGxnVmQrbUo0MTVyclJxTk1wQTZ3Z3JFWlpHN2VhVnBTZlA1dy9v?=
 =?utf-8?B?Qy80Ymx1SUh3RVNodXRkNWVxL2RIOFYwZkpFYnNzaXEyU3JJNThOL2I4UGRu?=
 =?utf-8?B?Z3M4SWdpbGJzOStKN0xJaGlDNHgzRFZGc09RV2NrMVUxcmlSTG1PT2I4cnp6?=
 =?utf-8?B?STNvTDJzcUlScktOOVhlN0lFMWJNczBlVGphb3RCZjJoYml3NytTRENBTVdy?=
 =?utf-8?B?RmQvMGxRYUloaEVoOWFuUFV3bnBmZ0xST3ZhdER0NmZTOU9OZ3RoOUs1YXdl?=
 =?utf-8?B?NWVJKzlQNnQwWXFvRXdINlFLYVkrTGNCV2hJNzVwUDAraUdTemN4TTN1MlQz?=
 =?utf-8?B?Tjg3T3hQYnBEOTd2YXJrMnZUYllIL2J2bm43djZnNUY5Rzg2YXZKRGVJcFla?=
 =?utf-8?B?VDY4MzZBcFpYNWFmbVRqdEFsRVhUUG9NME85ZEFYNTlickdHMXFkdDZsazB3?=
 =?utf-8?B?b2NVclRpTXJRYlNKQ0hYV2N0bGRLd2JpcXpLNm0venVLU0lUR3lVNGtNM21M?=
 =?utf-8?B?RHVRUVhIbGJrbUlKZm4xenZqU3Q2U0NyMldmSVBMSGE0eURkRFF6eXd4UTk3?=
 =?utf-8?B?TUIxN2dTaS9hNXBQYzdBYzN3RUwzdGNEMldCa1VJNm12M0JzR2s4dWN1SS92?=
 =?utf-8?B?NXFMdmNaeTU4V2tmRFk2bmJxUGtpOTIrS01qWWFwTzdvdWlYeGptQnJDM3J6?=
 =?utf-8?B?VlRiZjRrS1FZL1hXa1BnVlhrUEE1M3BJbFYva0hLOWloVjNxdHFaT1RPd2xF?=
 =?utf-8?B?Q0Fzbk5oMzg5MG5HUC9LeGlHQUY5VkxMYXp0Vk1OcFB0dEFvQXFZYWx6aUNZ?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db93466e-6b70-4eb8-2b50-08dd0834547a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 00:51:40.6391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkSZsFDffrbhDyk5mKJ33JRkZM++wk9e8SOy5Y1GTPmBRMWgcGKxqLMDgyoN/gq/XGprX4hP3zTtLIJ1HUVOdRWOpXXUfH1REdxTQ+bVMm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6709
X-OriginatorOrg: intel.com

Hi Tony,

On 11/18/24 4:01 PM, Luck, Tony wrote:
> On Fri, Nov 15, 2024 at 10:21:01AM -0600, Moger, Babu wrote:
>> Hi Tony,
> 
> Thanks for looking at this patch.
> 
>>
>> On 11/13/2024 6:17 PM, Tony Luck wrote:
>>> Instead of hard-coding the memory bandwidth local event as the
>>> input to the mba_sc feedback look, use the event that the user
>>> configured for each ctrl_mon group.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>   arch/x86/kernel/cpu/resctrl/monitor.c | 23 ++++++++++++++++++-----
>>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> index 7ef1a293cc13..2176e355e864 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> @@ -752,20 +752,31 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>>>   	u32 closid, rmid, cur_msr_val, new_msr_val;
>>>   	struct mbm_state *pmbm_data, *cmbm_data;
>>>   	struct rdt_ctrl_domain *dom_mba;
>>> +	enum resctrl_event_id evt_id;
>>>   	struct rdt_resource *r_mba;
>>> -	u32 cur_bw, user_bw, idx;
>>>   	struct list_head *head;
>>>   	struct rdtgroup *entry;
>>> +	u32 cur_bw, user_bw;
>>> -	if (!is_mbm_local_enabled())
>>> +	if (!is_mbm_enabled())
>>>   		return;
>>>   	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>>> +	evt_id = rgrp->mba_mbps_event;
>>> +
>>> +	if (WARN_ON_ONCE(!is_mbm_event(evt_id)))
>>> +		return;
>>
>> I feel this check is enough.
>>
>>> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_LOCAL_EVENT_ID && !is_mbm_local_enabled()))
>>> +		return;
>>> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_TOTAL_EVENT_ID && !is_mbm_total_enabled()))
>>> +		return;
>>
>> These two checks are not necessary.  You are already validating it while
>> initializing(in patch 7).
> 
> I added this in response to a comment on v7 from Reinette that evt_id
> wasn't properly validated here - in conjuction with the change a few
> lines earlier that relaxed the check for is_mbm_local_enabled() to
> just is_mbm_enabled().

right that patch had an issue ... the "initialize" code hardcoded support to be 
	r->membw.mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
without any checking and then the handler used a relaxed check of
	is_mbm_enabled()

On a system that only supports total MBM the is_mbm_enabled() check will
pass while the event used will be local MBM.

> 
> See: https://lore.kernel.org/r/bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com
> 
> In theory all of these tests could be dropped. As you point out the
> sanity checks are done higher in the call sequence. But some folks
> like the "belt and braces" approach to such sanity checks.

If that "higher in the call sequence" can be trusted, yes. That was not the
case when I made those statements. Sprinkling WARN() that continues execution
in a known bad state does not seem safe to me either.

Reinette
