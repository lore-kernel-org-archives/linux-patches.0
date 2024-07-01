Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA101EB2A
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719850117; cv=fail; b=o9kbl7wFjnnUo1DJG6kOCF0cOf6QwpJWSpJ0ylNecbOl1F3ge5rVN4Y/17+mz/SMsgZFLJHnltLv6qxdnR+gv/d4Vd7lk/ILlNMJWqjSodCHZbwQHAyiswlsqq+eC7dQ+8ZHRpZUG3ebOeZ4jGtuyCsZba4s9li18Tjo+2a8npY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719850117; c=relaxed/simple;
	bh=gLYGIeb2Mmr94ijCMNZh29MBFOObMrWJCqr7VkftiCQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hCkcdB4BvxoieBAuleza58iFQit1rrgjllgXvErGmp5/5amocoFnNHVJWKBs+33tsttljY8EPUsn0H2J5dTObGZthGu47VoGmFLBdBCyoBY3u1vJKnUM0iw3vEXF6LY9erlCBaEkgR+WXN5daiKPfV4+fLUgLHoQC7ZEOFoMBDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+NemqGy; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+NemqGy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719850116; x=1751386116;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gLYGIeb2Mmr94ijCMNZh29MBFOObMrWJCqr7VkftiCQ=;
  b=D+NemqGy3t0tcL94rftGCKpAgQ5ZCM0WSQyOB0eqiUSHMNsy8pnD+L29
   WR+FIsSC5A8LNexT7RoXVuzKhZC+FH8VwdqxmOf8GoDu37rTgSe3qCAjy
   zbrmKffgG4p+FTQnEvPffSVFyGCd7tk9VzW8ZkUeNvoY5whub3r9MZ+vP
   +1Yv2pnUjISA2JHa+ITdDBV4mNbUDaHHkjyKA6j2Kjb4qKdWFLrd7RCGI
   4kmuHtl9CAb9vwbfCGTENWQplbh4VvYOpks5//eP9J0E+rhJi9NdP9/Rt
   UujpfZ2cjjfkA21jOKq4puDzC1CQQbzG/cPJhKB1PlqidVYBLNkMFZM7K
   Q==;
X-CSE-ConnectionGUID: YuCDJToHTE2jzpRYLe8mNQ==
X-CSE-MsgGUID: zDZWhF/BTqWdqqb5+PJUOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11120"; a="34434241"
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="34434241"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 09:08:35 -0700
X-CSE-ConnectionGUID: NZaV/hheTSiP2nGzL9UfqQ==
X-CSE-MsgGUID: Y5UP6RFARLyO3EVrWcqCZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="50533763"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 09:08:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 09:08:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 09:08:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 09:08:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 09:08:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K72x74Hld65NNUOMLV9DwZJojrYE66rm2PNyNlQE3kieSI24Mo0TgcwgGngkdYNtgGxcsfGdY/I65h9CRlb8cO9tHFAJFsilX63InpHGDDbr+pyQjaVa03/PDdtlyq3U0tPlfjYr09X/Na5zH6G1/iuOh2T9ORuva+oTLWgcUxR3fKUOdWeUW6l1WAcJGIUnV+RyHQ1VbXJF5qBhaWulynxyj7e7VbIJW1UmKPn9FWZT+usEBf22I+hj3FIl20iTs+ZFDC/zbCLoVIlzNfYHH9UgtO780bGKlQ9F0NXcKkIsKv3vzdZdR2p/ZQx2/duHa0a582LkZRz5tZEVCvg2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLYGIeb2Mmr94ijCMNZh29MBFOObMrWJCqr7VkftiCQ=;
 b=Wlxnw5y1xBi/xAKW2FTZOdpqborBbtsMgcdlrbr5Thl+Pfn4+M0qeNu+3G626utuSwgRJGFG9y7UIT/ezr0PBnpjmceJ4LUCgJC/oZPI5RK9eVqks7YJ4BbUQx7ge/1BYZpD0J+wdC4WiQViVj3hYbOEKkWndOL/Ol2YYYh0Br2F063wpJ2Csc4fEzaL4nLZVVDWK4SBONb3GF8Ctxh7ubjFDcJvgJyGM+j2eitx6JBJxWdSCrweOZE0b5RAAhIDW8ry3OOi7819M2v/dfAhHuA9gCunDkDzPYu0aaGUdezrr6BWwfWvfpaLijNBp0wL5er0RG+OiFjgRt/WJkfFXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CO1PR11MB5092.namprd11.prod.outlook.com (2603:10b6:303:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 16:08:31 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 16:08:31 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "bp@alien8.de" <bp@alien8.de>, "babu.moger@amd.com" <babu.moger@amd.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>
Subject: RE: [PATCH v23 00/19] Add support for Sub-NUMA cluster (SNC) systems
Thread-Topic: [PATCH v23 00/19] Add support for Sub-NUMA cluster (SNC) systems
Thread-Index: AQHayaYLaeIH3BM3o0mWmakWWVjJMbHh8VcAgAAcDSA=
Date: Mon, 1 Jul 2024 16:08:30 +0000
Message-ID: <SJ1PR11MB608309501E25395B7E298CAFFCD32@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
 <0221f994-ff09-499a-8e01-376211a10df5@amd.com>
In-Reply-To: <0221f994-ff09-499a-8e01-376211a10df5@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CO1PR11MB5092:EE_
x-ms-office365-filtering-correlation-id: 14d2375d-f04f-4c14-97a6-08dc99e80d04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R2dESEdMQWo3dFM5UklYbWliOWNnb0lTaEc1R2FWVGxUZngxVWhQK1ZKeS9m?=
 =?utf-8?B?NUxxeFZkZ0ozS3ovTTFJWHNxWnNBN3Z2Q25LRElpbHdrRXlCNlRhR1pWTG5z?=
 =?utf-8?B?WHNqR29OUGFna2kwaCs1elFnRUhJRXZIREppcG12MnVLSDFSYUo5QUtHeGtw?=
 =?utf-8?B?Z0pLZHZZSktGWDZkbWcxZi9ncXlERmYwQXVHM0pxVE1abVFBVEEwNm1HZDFm?=
 =?utf-8?B?Y0RuSm5ZRU9BWkNucWN2ZWRLeG4zNE9oRVJ4WGJoV3k2b3UrYjE1VnJFbG1P?=
 =?utf-8?B?djd6Z2tTWWF0bVVoUGRJbXcvUlUzS01vK201Y090ck15QWt1eGN2Zlk5TnJP?=
 =?utf-8?B?bzVwWTlkOGpIZFZ4TW16TVRTNVB1YXdQMng5OG1PSEQ4WGo0cEZ3TFdZYkpt?=
 =?utf-8?B?ZTZ3UWNqeVdYc2JDa3NyVjZqbTJUdjZkVEpKYW5KcjJ0N0VZMjV3M2ZJSjlw?=
 =?utf-8?B?THlRWXNMWEl3Zm5XaS83eHZYWVBMWFVudFBJUGV4M1JyUmRFOGk0K2Y2MW42?=
 =?utf-8?B?Q2VkNVlPTnd5Tk5ZS2ROTkZEQS9yS29JVndQUlZMcG8zZXRIYS9ybmpBdm1C?=
 =?utf-8?B?dzZmRmFhdkZlVVZCUWxERXBqK2lyMHhYei91TVhTUXRlUXRFclFxcUFFUXQ0?=
 =?utf-8?B?eWMxZm1YQ3dmT28xemhOSlhSa3FWQi9DNkhBOTdLdjJmVzNjZHJMS1BPY2Ux?=
 =?utf-8?B?Sy90cE12UVFrcEQrWjl6ZVBrUGdWd2NJd290Sll5M0RpUDRqK0pkS2lDUnJo?=
 =?utf-8?B?aFJLOHJ1bFRxS3huNTE5TlF2ZzhaakljSm0zSUprY244OHY4eUYrQTlyQ0tu?=
 =?utf-8?B?MUxMYXQ3VThweEtFWnBaM01XZmhwSlM1bnYrRHhxWnhnSkVMaHEzUHp6MVlm?=
 =?utf-8?B?c01lTm5Qa2RSL2MzanV6b2QrTUREYm9ZdzJyWEVaZXJmNTQrdk5EQm10d1Yr?=
 =?utf-8?B?bmVMUDZiczdtWDl4VFRybFI0cEFnTjJlVWp3TXB6R3d1RHpiS2prUkZJM3dB?=
 =?utf-8?B?UStyays5N1lHWndkSC9sa1AzQ2drdHJ5UThzUVdVL09SRnpiMk5MWTY0Unh2?=
 =?utf-8?B?ZHFHNmM3RzhoTnMyUlN5NG1HNkNMZ1hDMW5DR2pnUEYvTlBuZWFNK1c0eXln?=
 =?utf-8?B?R3B2L1A0SE1FcjkwbWpxa096YWZiUC80MUNIYUF5ZE9sbTBESDh5TFhDWVMr?=
 =?utf-8?B?S2tkTGZteWRkRjJJUSs3OTZ0QldXOStWVWtJNHJnT2VHSVA1ZmRmV2kyaHFq?=
 =?utf-8?B?M0kxMkVKMDJmR3N3SG9qUWlNL0w2dTRGU3JVNkFqU2RDVXVnNVByblFDbkRJ?=
 =?utf-8?B?Wmk4MW1GZnM4U1g1U3JzOWF1REVTZFB2TnFRSm80RnpJeSs1elB4TUI4YTVZ?=
 =?utf-8?B?STlOVnJiYkJmbXRETC9MSnVmZDR3WTlxeUJCeEhGQUM1eUczNFBzNy9ITTYx?=
 =?utf-8?B?SjJzSzhiUEwvL0VzalRpdGx0QVNOQjhIa3hqcncvcTRSYktCdmVUcURWSUNF?=
 =?utf-8?B?eWVsdEZldEF0M3pDMkNXNjNLWk44dUlmeGU1WTllZGpqcGRTakZrL2Jyei84?=
 =?utf-8?B?VUNEdDVqRE9PTCtxcjV4cHZGSXcxYkRvNnJxbytuRHFRblcrbTJYbDFteFlQ?=
 =?utf-8?B?TGpCeWNuaDdpSm5yZ0tjaXVFWlhkZERaM3dUNVlsaTBjdlNFWkVkWFcwdEVv?=
 =?utf-8?B?dTRqZjh2TWF0ZXVRa3F6NFhFeXh2YjFLK0JkRlpEZlpKU3pJU2g3b1RLWlFi?=
 =?utf-8?B?TittNG5KUytLL2tXSDE1bExDaEYyUUxEeVNkejJxTm9JazJZWC9GVEwyOW1v?=
 =?utf-8?B?RFpDMVR3aFdLdHlvYThjOWVWTnl4NjQ2dHB5OFJmZ241M2hpTkh3TFdtbldS?=
 =?utf-8?B?N1BvN2tKSE42ZVZtNWtWeTl5TjExaTh4L3ZqN24wcitNdlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0xKR2NQWkd3TGxydEZsZW5vRWU2c3NkY3lSU0FrZUxwRWE1TlFoSzRyUDBD?=
 =?utf-8?B?YTBYT1B4dG5TcEp5NnB5dWZ3QldNV3NzamlBZzZnNENNRWt4bG9KU2FzcWZP?=
 =?utf-8?B?eExydjFnY3RFZXMxUGJKbFJudUVrVXdwZERWVS9yYUYzbG1ucU1DZjFhMWRh?=
 =?utf-8?B?dmtCK3VFR2VrdzhXSGZ6UEVNYXUybGt5OERxa0FuTDJxb3BNdG90ajdFZk9L?=
 =?utf-8?B?bzRublpzUDMrWHd4aWs4ZGIySmZxYnRKRmJHUE9OanNMdmxEa2tkVSthZ1pT?=
 =?utf-8?B?RVBQYTMrbmdkSHZodzJ5Qmg2a2dCajlpc2REcGh2a1FqUHczNE5JUHlndE5K?=
 =?utf-8?B?N0JKYzU4R25TSjJxeDB2Wnc5R0kxdlNHSHJqVk93MGx4TUlYaGJhaWJ2MDFX?=
 =?utf-8?B?RThvUndZZ0RuWWlyTGFhNGNrY1BPRm9tWk9qMHJoWW55d2Jnb3U0S3kzWkV2?=
 =?utf-8?B?WmFoR2JNeS9TT2FSamk1ODJ2Zkw2VDdoN2U2R0doRW1lQmJkNUxBVnhNRFBL?=
 =?utf-8?B?OWtpcDN3TSs0Z1g2Nzd2NWxCTUY1OHJHdUdhVFZib2U3TmJNTmx2TkhvSCtr?=
 =?utf-8?B?RHB3WFhFNU5hR3laamRhbGlYelNTZEV6cGNWZHd3TDNtNktXUDVoS2pld3hD?=
 =?utf-8?B?Qk1SblJ3ZktrNk9hS1JBTCtqc1RObmJwamVRVlczYTE4NEZIU0pzR2RGNTFB?=
 =?utf-8?B?V1MvQlRvbUpNeTc0QlBDU1RsWUh0R1cxNlpVd1NtSU1CWXU1aE5xbGl3STZn?=
 =?utf-8?B?ZlRkSmVJUEQreWJ3YXBwaC9uRklnRXUyVEd3OTNZc2g3cE1YcDF0SHI3UjhS?=
 =?utf-8?B?bzlPS1JJN29TenRmYjhLZTJSbkh0VlRkbEZhQmpNQzBkSHZGRm9hR2dtWVNM?=
 =?utf-8?B?MUx3YWlIUUtsQjYvRDVLMHZzVVFmamdRNnJxQmMyTk0xSVh4a01LVjNjTExH?=
 =?utf-8?B?aUR1ODYwS3doUnYzY1YwT2dYaHpnbmE0Y2U0aUF2SWhvYytWMnRGVTRGQ0VY?=
 =?utf-8?B?NGg4cDBpOXByYXU4M3ZNR29wL3RHeW1XdEZEZndxYTdlRCt2dGlvbVdBZk5m?=
 =?utf-8?B?bUhWVjc0WEZ6ZFpjMUJZblZZUkhWRWhEcDdrdHFuQXVPMmtuTHFQd2loTTJk?=
 =?utf-8?B?enpJWk5aZmlOa2c4aW0vSlVKTVB3R2JzNi9qT2NMeEkvVWd1cWkvV082TDdx?=
 =?utf-8?B?TFVIRGpUTzBnaC9mREd0UlRmUE4rTFFHWWtnYzNrb3dBUitISzljR0QvL3Nz?=
 =?utf-8?B?M0k3MDY0cFMzdUdmSHRGQmtTbkcxN0g0QVc5UXlESmY1R0tJSGYwMHJWVk9m?=
 =?utf-8?B?cVVmZm5lNDluTkoxR2pvKzZnTDdjb292ZzNSUDFrb2p5T1RqQ1NxclhhbUJT?=
 =?utf-8?B?OUliQ0xhaG1wOGxQdFRDd3RMa05NVmwyeEdqY3hidXVPbExiWGlKRTFYYkZY?=
 =?utf-8?B?c3hBemZhR0FEY2xiRTcwZDNrVHRJcE5WSWxod3VtcFN1a2xkNENxdFQzNUF2?=
 =?utf-8?B?RkoyZmpFN3BLaVJrTFRicHFrMTI3V0J2NllLc0hIUkI3QitIQ1BmMHlOc29v?=
 =?utf-8?B?SmRQbDZuSGRVRTF4OHhnM0hDQkUwY0dSODFnNGwxWFJEN2prbEFCcHR1RU1v?=
 =?utf-8?B?dEE5SlhoczkxNHpGTXhyR01Fb2pJUzZmcW1QVDFHZHVESUNWS1lKT3JpamhH?=
 =?utf-8?B?SzM1M0lmWXVXbytwQXdaMmpTREhwS3dKWEwreDdCMlNUekU1WFBVdjV1Nmg3?=
 =?utf-8?B?ejVoT3VsaEpDWW5LM1BVMFhDaW5pdDE4cmpaNWs3Z1dBYlM3Zlhabi9xVTZ1?=
 =?utf-8?B?TnFKdlpWdXhmUTRUVk91Z0pEcUdlTFFmdHpvOUVORXVYamZhaVpyTHZBaG9x?=
 =?utf-8?B?ejFLdjVYNXNTKzd3TjlFNktQeHZibGdMS2treUdXYmVML1Blb25UWEZ5RFY5?=
 =?utf-8?B?bUJ4bkNncEZBQzhQK3QweGZCVGNXZkhFdjh4NTNFTEVYVzM1OVNEQWxxd2V1?=
 =?utf-8?B?RHhadzNpSThoVGo5Z05hSTlhdjU3Q2lKRGRzZlVZZVZqOEpEbjFCWHp0eVo4?=
 =?utf-8?B?M1NlTldsREpudENndC96T1RlUStWTC9qb1J6a1FGS3U1bFRNeTZ0MFB4OXJn?=
 =?utf-8?Q?vk+ANBtpxmQSoiWcxadrLavV+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d2375d-f04f-4c14-97a6-08dc99e80d04
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2024 16:08:30.9605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpotaKkkZSyTjkwrJqCk+B3s+/sXlSHMgtEHYNN5R+1N4qNHKCrnndVUeJRtVFpwVkIojxyk7XP6GwzgnVEUrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5092
X-OriginatorOrg: intel.com

PiBUZXN0ZWQgdGhlIHNlcmllcyBvbiBBTUQgc3lzdGVtcyBhbmQgcmFuIGZldyBiYXNpYyB0ZXN0
cy4gRXZlcnl0aGluZyBsb29rcw0KPiBnb29kLiAgVGhhbmtzLg0KPg0KPiBUZXN0ZWQtYnk6IEJh
YnUgTW9nZXIgPGJhYnUubW9nZXJAYW1kLmNvbT4NCg0KQmFidTogVGhhbmtzIGEgdG9uIGZvciB0
ZXN0aW5nLg0KDQpCb3JpczogQWxsIHBhcnRzIGhhdmUgUmVpbmV0dGUncyAiUmV2aWV3ZWQtYnk6
IiB0YWdzIChleGNlcHQgOSB3aGVyZSBzaGUgaXMgY28tYXV0aG9yKS4NCg0KSXMgLXJjNiB0b28g
bGF0ZSBmb3IgaW5jbHVzaW9uIHRoaXMgY3ljbGU/DQoNCi1Ub255DQo=
