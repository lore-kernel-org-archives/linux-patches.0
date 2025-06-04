Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB312D1F1
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 04:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749010012; cv=fail; b=HkuH0+66/5JDxsbxZcJSzGhpjR4P/82oUqEgMRxMSV2Nns+qTHB8//uLV1ibQw+go24TWVkiLW3pA1wImQbKrsAIhB6T89z2+a1OoGaipuOlEReYajZrdHaM4Zgnj4YerIkzPdCuk8gJ0xkMiYVl1cjIdU/V/UD+8FlHWw/ce2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749010012; c=relaxed/simple;
	bh=rlERlalPKYHZxiDYbj9tLXuh4snAWjgly/XCGV4pHI4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MtkysEWIAA/ElOVTq7weI8xY3s+LRvKbO7QgBp4SVnvdeP/qH2BEMy+GJ4I4oHpXJSw/CmEriTZhEKiSH81DzpZ04fBbe0XNf60xdMKC4wx4Q30lSJMg4v5rn7qKwgQRedXTChp5mp+sjn4ykKhoAZijgmn4uDi3p8F9ETzJOYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gG6UVLQD; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gG6UVLQD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749010010; x=1780546010;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rlERlalPKYHZxiDYbj9tLXuh4snAWjgly/XCGV4pHI4=;
  b=gG6UVLQDn+XN0+UUIYjufLpYbvl9fDMB/xC3+wXPfduvy0lPNxMhmrLt
   5107JnsSFpGCG+VNsIauxsxtgZ8wvS4IrFztqbjXlZ8iTzVgdCQs+qyur
   /IHbB9QaWCM/BjqMdJEPv/GhIef/C9lTp3ImkH4hEv/AZmzrgC8jj/EJq
   Co9Wu7Y92t/qPvbGfW16lMWxUqlpFvBdZBZ7/PQHa13gIUuO4wTKCxd56
   gfctm1Q8waMmvzSbT5hf75LMX9/gCylaMXS6KspjYbD9f9a+ZNhb8PMGB
   6Ys0ij8Gt6HbsUMS5xunzIzV6byJbntg+Omr/207fw5uS42yAul4zwDmG
   A==;
X-CSE-ConnectionGUID: /TDfVb+kT+K9PvePamKLdg==
X-CSE-MsgGUID: 70AjYu/qTjaCv37CDmcvtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="68623948"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="68623948"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:06:49 -0700
X-CSE-ConnectionGUID: u3FAe1MESwWJKNC1ocFOBg==
X-CSE-MsgGUID: pOOPZeOkTuKOclFdhvBJlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="182236697"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:06:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:06:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 21:06:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.68) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 21:06:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vK7uRSExG3yD6qCch4qBpzMNDYjoTcssaxcAydEyEDZP47V38nwSabwT96raWQppmgh8q3YUJdSwOIWJ8PBeGxdO6kcXfPNsW1+xlCtlijGCrWRLlsJq7Vt4EnlbtReU9X03zdyjWWSdort8d48GomJK1QdEByaKtYdo/yuJ4A2rQ7kK2CN5ddqoUOynrgx2V/Hl6KcklvFAOGVL2ugHAmsuPpfopb+ww+oQWKaAVXArUiUz4E3AfN4daCvQlWy24PlJiTlS9w47ZHCFlEr65NQ4YpVXXuRG1kWchj9KUcr0Yy4ya5CnmMlp5LNQrjkW0ozlJX8A4eApsoi7z220oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++oZmyn8hIywTF6Kt6Irg+nG1VWc8nr9smKwe66y0gM=;
 b=h8WzIT8JOs3SslEwGvRtKJZfbuudKhl3IOkCYAvCry3byytGS8wL0TwSNpahDDrdvJLRnjrqK9b2TlOkRyvRQezJuODiUJcXkmrPOztqm+e+KOgJvxZVGNx+rLwD5a//O7xFJ96vWM+8HekwTurKkUP8DJMhR5RVS33uleALEu13Fs/GNhoFRY/bOX4lNdaZSNJOkAy2mQv6VYsFaPnCg/HvVquF/0/c4fVjjR+UoKauVtTvty8vjtFtboxbNnXVfuA+iecgQlLn+82fKlts/SHZP6ezUQvAH/sGIKydL5JH+eYeanjY5EOvIgSN6bscKCQbYGcl/dB+l4s3odq0Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Wed, 4 Jun 2025 04:06:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 04:06:20 +0000
Message-ID: <f0e18eaf-3144-4fca-903f-411965ce0360@intel.com>
Date: Tue, 3 Jun 2025 21:06:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/29] x86,fs/resctrl: Handle domain creation/deletion
 for RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:332::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: acbe83c6-dafe-4d27-c03b-08dda31d2987
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UEJkaGdWM3pRR2REc1J3aGNBRzVHZ1VGYi8wZkgzWXdoNnJVN1I4czVUUldD?=
 =?utf-8?B?WU9HcStJQ2lDUVV0Q2YwNmtRd1FWemRjckpkb1FhRFgwTE44SERDYzZVUFJV?=
 =?utf-8?B?MlpTT1hqZDNPRGd4NmxpRjBFUDhFeFFockJEUTY0OEU1ZDE2bWJaN3VIRlMv?=
 =?utf-8?B?WFhkbjFRVW92azdEOXlwdjRJcmNwRlNlbTNIT2p5Ym9BdEphNU5yeWR0c2ZL?=
 =?utf-8?B?MUp1SGdVOVJrbmZQRTZPUmpyOW4xL2xVdWtrc2I4VVZSTklKNmpveU15N3Mr?=
 =?utf-8?B?TDRKT1p2UnBETjNHWUhlUXdjRXp1aGhWSkFtbTdsSTlWMU55ZC9YWXVvK0Nh?=
 =?utf-8?B?MVJSWUY1QmV6T3hrYkFEUk9kOVo5a2t0bElXTjBxWlVUNkZXdGs0ZWVSMnVQ?=
 =?utf-8?B?R3B0bFN5WHB6cnZyTHNtSVlKNkZucmVuY1JjbTNoOFpUbWxCYkx6bDVBaXJ5?=
 =?utf-8?B?dXZFaW9zTGZWWmFRQ1owUHlueGRkTmQxWm5NMlB3VmxqdFJQZndFaC9BY2lI?=
 =?utf-8?B?N2dIVlMwUE9XdFFQVlpiaEdBN2tUT1MrUU94VVl2Q0lVaHc0b2IwaU4xMVds?=
 =?utf-8?B?T1BEQm4wSnJoVWVwNmtwMjR4WHJFTUYyTFNGeG10RGVkbERFMERZYUxZR1R5?=
 =?utf-8?B?Vjg4MU4va2hjNDBZY2FWek5zSStnaUF1MjdwQVVZZy9ibGd5eXZnclVwdE1D?=
 =?utf-8?B?NG9pUlBmaG1QRm5nMXpJVFplVUZhQjlLOEl1Skthb1Exc0w5NnQxenM5WWVi?=
 =?utf-8?B?a2cvTUtQNUV1dHlMc3B2RUJLT09DUS9yVTFsdE1TWFAvYXo4aHMvcS9GelJx?=
 =?utf-8?B?dmxqL2ZlU0tNSmlzQmxVRnNIUlhqeTNHZzRvRXFORm01R1A0N0NTcE1pcDJu?=
 =?utf-8?B?R3AybDArd1JZT3lXcytOVWZtaGRUTXFjUXNucmNWZG9JNHpoVWthbEl3WXR4?=
 =?utf-8?B?bUtheEFYR1duT3FXcVhzblNvQmoxN1BsU1BMZ25WWUNUelNWRVBSQ2NtZ2RG?=
 =?utf-8?B?dlh6ZHU3TWhPL0ZacU9ZREFzZjROclJHZ1IvRTh3bGEzbmc0ZWZ6MVhuRStZ?=
 =?utf-8?B?T3ZKZFIvSG1tcTFDRVlXQ200VGUyMmMrOFVxVGZDTC91bmRORC92R2E2MWJz?=
 =?utf-8?B?Zk9MQTh0WXBGRHkwNWxwclE1N29mSE9BRXZ1S1NaK0d5S2ozUjRaL25ZS3JM?=
 =?utf-8?B?VVhxWExjNUY3cnZvMi9LeTgyQjVBU0dKZDM1b0I1Tm41SitoK1VpdG5YbHNR?=
 =?utf-8?B?bGRsRytjbzg1NW1CQ0dNTTZBWTZWZWk2TkU5bW9wY3A0T2tLblQ2MGx2V3ht?=
 =?utf-8?B?eVRkNDg1TW0wWlJSL1JpMTNZZXRCWm9lUHlxcmRKVExXMHVEOXB0cStZNTBE?=
 =?utf-8?B?dngvSWNVWFVXcVQxQUlnR3JjeHMxaU9mZWhhLzRSNkhMMVR6YzJrUmF2Zk9T?=
 =?utf-8?B?eW5KY0xBL3BMMzZuTWthWStyVmlmVWVPOFdRbmpjYUMvb0I1N1pNQXNrK1ZB?=
 =?utf-8?B?Zjc0eXdnL0hiZjE3RkdjK00yRldQcXhKL1NRV09XbjQ5bWxtK1I1WUQrdVJi?=
 =?utf-8?B?amY1YkxWYzJ2QXUwZzNIQm9icXQrZzJFVTZnOGxkMlZBMlVhMHBnUXhjSmRO?=
 =?utf-8?B?NlRvdEwrN1NyYmJBWXplZVFTYjduQy9xaUtORkp2ODhjMUY4OU1Ib0RHSmVp?=
 =?utf-8?B?MEJRdkZzeVBwYTljQjFZaHJYb2NnRktDaWY0VFlDbUxlcWNhM3IybVh5b243?=
 =?utf-8?B?VmJuNUJ1c1NhSldWQjBxQmpVWmRUMEtGVyt0RytJSmFDVTYyS05tcUw2SFNV?=
 =?utf-8?B?d0ZydnEraFJkWkt2S3NGVE5xS21ZU3NzYUVSRlBwS1AxL2lxSUt5ZkRBay9Y?=
 =?utf-8?B?amtQb2dweDRJS0lUN3JBdFBtcnJmbmJtcTBwSnJXcThwRTc2L3JlWldxTS9m?=
 =?utf-8?B?MzlQOEN1dmp1YlNIRkxNQTh1MUZhRUg2VzNiakVNbS8xTWtnUkpxRW5HQmFo?=
 =?utf-8?B?amdaWGZUbCtBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDJxVnRNR2tZaHpoU0U5Nlg4Tnp6bzNIclg4ZXFjVDNiem1MTFZKQ0oxKzBr?=
 =?utf-8?B?YTM5ODBwMTlIM1REQkZBQi81WWJZSG0ydnpEYm83T1JJbGpuaHVTYUhGMkJv?=
 =?utf-8?B?S3BHc2F0a0x2NHlNdG8wa0JSTzV0NUVnalBLSDJHcG9mMGtoNGV3RXEzQkFF?=
 =?utf-8?B?cHRHdXFQTTRCdXlmdEZZU0tnVnUwQWdvTUxOQVdWcEFJVmlhUHI5Q0c4UkRp?=
 =?utf-8?B?clhVeERLRzlKMzh5eXo4dFYyWi85eUIwY3BnaWVXVHA0NEF4VEdYWEZuaExE?=
 =?utf-8?B?bm1Ecjd1cjJGN0Z3YWVwLzMyY0dPT1NPTEpjY091UlhvSGpGbXhEZjdWZldv?=
 =?utf-8?B?MlZSMWx6b0ZnbjJWQjJYQlgrVFNaR3M0Sng1dlJGN3M4VWZROW82WFJJNWh1?=
 =?utf-8?B?ZXFDS2NMM3VRcVdGZjlKbFFzQ0ZGZndJZHpWNm9jblRXM0VMMVdCc3c2dllk?=
 =?utf-8?B?RnZKS1VDNktFK2pCMS9BR3FSN3FBVERTVHllOGZQWDVmRkM2OG1TaFlibW41?=
 =?utf-8?B?amJTQ3lYYTZUSk0rMlZOVm1ZOHVBL1hiNnl5djlaRlFKNlVMaUlGS0dINGtH?=
 =?utf-8?B?OGVUczBDekU2M0xWc3p5dWhsQktXNEloT1RvOVpqZWlhbkNvNDFDVFc4ZFJK?=
 =?utf-8?B?VEd6akU0WXpvK2tzb0s1eGxiVmt6TUUveVVkYnZXbDR5UWhMK3Z3R1Z2WHNy?=
 =?utf-8?B?SVVmY1RtS0RibU14bWNsZks5VGFiQXZBZC9yOVpuZ21KN281aDY0c3FXUTFm?=
 =?utf-8?B?YzJrZlRSdjY1WlNDb1FxbFQzRzBpYzlrS0tYK0FCVTRUanlEQVE5MWxGbHgz?=
 =?utf-8?B?b1R5dW1JbmtaKzJkcUxTOUJWNE95d3B6MUFsZDFZREtrZHBabDlnMGhLZnhG?=
 =?utf-8?B?V1grTXovUHpreUtUaVVnWjRvM29adFUrRjQwUFR2c2tyVnVORjZaZ2NzeVVC?=
 =?utf-8?B?MXo2T2JZdjFxelVMbkNJSlNWZkdBWThGQlU1UE96VzJKN1dlWGl5L1V4RC9t?=
 =?utf-8?B?d2ZLNHFhUjRLMEt3WERwMXNmNGladHlxMzFpLysvaE9JWFQ5MDhrZlJyNlFF?=
 =?utf-8?B?aWpPL0hSNnFhWllXcnVjTy9ZMmF1Z2NRL1AyTXdpZHZ2VEc4SDlvbjBjZEMr?=
 =?utf-8?B?YkxTVU9xa0NSVlNjYmVkTU1rSW9EZHpWWGFYbC9JbjNZU3B1S2xzYWx1c0pW?=
 =?utf-8?B?K1JXUlNtdEZ0RU1EejMxYTZ6dlg0QXRnWEs1RUVTdUZHWHd3Smpzc2dVenBS?=
 =?utf-8?B?THltVUh0eWQ5bHJNSElzdlZHK3RWbndsWjlLYVJYZGNCRWMrdmlMVEZ1YmpZ?=
 =?utf-8?B?WDNhWEt3UHQxa3pvdWlZeWw2SmFpRDhKdmpUeVJHVVZjS2drMXl2VlZtNEp1?=
 =?utf-8?B?YkYrMU1PaWNYOW1KUUxmYVZsVTI1Y1VBUEdWSXNGVTFYSTF5bkU5UVBJMEoz?=
 =?utf-8?B?OTk1Ui9VQ2pFa1g4R0NHeTE5bStRVThGN0VsTTZHSEllc1NzYTE2N1BEc1I4?=
 =?utf-8?B?ZWFzWjc3dTZuLzN1Y0orM1d1bjhtME5adlBudWRWZy82dlhXQ3NPRTBwdWdM?=
 =?utf-8?B?TnhlWnF0MkJIZXFDYkxxd3hwR1AvUEJvVlk4ZDcydVkrcm9HWTZzSm9SNUYz?=
 =?utf-8?B?bEhWWXRHSW4rNlpKbk1pcTFNUzBhRGxhNk80MkxmWVM4SU92ZGFCZWs0SGFl?=
 =?utf-8?B?UXFFTEZ0czB6elh1WW1kM0ttRzVDOW5OYjdxZTlLcmhBdXp3SEpERGFqZXRS?=
 =?utf-8?B?Wm5aeUJaOGhYMHF0YkFDeWt1NXl5MlBYSjgvVXI2bDN0Y1BqZVJEbEJ1NG5J?=
 =?utf-8?B?SWM2QXdXYklqV2lPY2pFdGJIZGdUUVlIbFJzSHEzVGxKcmtxWkpqTk1Qa0lR?=
 =?utf-8?B?R21kc05CZHFJVHVjRm1QQWdWR3pKVWtlSnhJOFlGOVJaSGp2RnJLZnJqM3Fl?=
 =?utf-8?B?QXBQeWpGZFEwMTFRazYwS2dzWFM5RCtHSHM4SU83SjcyTzJiRmc0VlB2T1F5?=
 =?utf-8?B?RWJpOHE2dzFHSUw4MmZMeDZ6allTN1JUdGx0bERxZlJabWNUVCtGeVpTclhp?=
 =?utf-8?B?SGw4azdZV1kzMG0vL3BIREY1b3l6VVJ6RXNxd2UvSUFjZVUzMStKTForOGtY?=
 =?utf-8?B?SUpJUFVNWjBac0hnVTdmQ3d0YmkzM2VpcFhvY3U1eDVsN3dSSkJ3MU1ER0NX?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acbe83c6-dafe-4d27-c03b-08dda31d2987
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:06:20.4146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qvco2ZX6B+LDG9xIXij++M1lpN4uZV7ZM9Wg7MdS1qOsCazOu1aYxMpETCYm0167xr9eMBSfrPTxENn/gj00zx7twc1MmfyWb6bCEluNILg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are structures
> that hold the 64-bit values of counters, and elements to keep track of
> the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.
> 
> Change domain_add_cpu_mon(), domain_remove_cpu_mon(),
> resctrl_offline_mon_domain(), and resctrl_online_mon_domain() to check
> resource type and perform only the operations needed for domains in the
> PERF_PKG resource.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 41 ++++++++++++++++++++++++++++++
>  fs/resctrl/rdtgroup.c              |  4 +++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 64ce561e77a0..18d84c497ee4 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -540,6 +540,38 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>  	}
>  }
>  
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource
> + * @hdr:	common header for different domain types
> + */
> +struct rdt_perf_pkg_mon_domain {
> +	struct rdt_domain_hdr   hdr;
> +};
> +
> +static void setup_intel_aet_mon_domain(int cpu, int id, struct rdt_resource *r,
> +				       struct list_head *add_pos)
> +{
> +	struct rdt_perf_pkg_mon_domain *d;
> +	int err;
> +
> +	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!d)
> +		return;
> +
> +	d->hdr.id = id;
> +	d->hdr.type = RESCTRL_MON_DOMAIN;
> +	d->hdr.rid = r->rid;
> +	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +	list_add_tail_rcu(&d->hdr.list, add_pos);
> +
> +	err = resctrl_online_mon_domain(r, &d->hdr);
> +	if (err) {
> +		list_del_rcu(&d->hdr.list);
> +		synchronize_rcu();
> +		kfree(d);
> +	}
> +}
> +
>  static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  {
>  	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> @@ -567,6 +599,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	case RDT_RESOURCE_L3:
>  		l3_mon_domain_setup(cpu, id, r, add_pos);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		setup_intel_aet_mon_domain(cpu, id, r, add_pos);
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  	}
> @@ -666,6 +701,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  	default:
>  		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>  		break;

Please keep "default" last.

> +	case RDT_RESOURCE_PERF_PKG:
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
> +		break;
>  	}
>  }
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 1e1cc8001cbc..6078cdd5cad0 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4170,6 +4170,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
>  	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
>  		goto out_unlock;
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		goto do_mkdir;

Please move this "r->rid == RDT_RESOURCE_PERF_PKG" to be right after getting the mutex, there is
no reason to check the domain header for this resource. This enables the domain_header_is_valid()
check to use hardcoded RDT_RESOURCE_L3 as parameter to match the required L3 resource domain used
in container_of() below.

>  	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
>  	err = domain_setup_l3_mon_state(r, d);
>  	if (err)
> @@ -4184,6 +4186,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
>  		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
>  
> +do_mkdir:

"do_mkdir" -> "mkdir"

> +	err = 0;
>  	/*
>  	 * If the filesystem is not mounted then only the default resource group
>  	 * exists. Creation of its directories is deferred until mount time

Reinette
