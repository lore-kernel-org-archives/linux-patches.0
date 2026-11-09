Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794263035;
	b=fi55Lw//DjBh76R/svlgy9j3XmRiQAj5WEdwmUizL8BreeqIzAfZwGzTqr81vlTD4Nog
	 GUh4bfnt1MSpwbFA1DewjIeVU8k83++h43I3WUON7pdje/cWtZwL5cqntAU6n0id37MiK
	 qBzH9bL4nevyP6nbXggOn4jK59IG7+z4bLOC4y/Crx91ybhMgAVPavGSMd6jvTFpYLNXZ
	 OA8pquYOhrYQSwMGsL/so8wN2ped3UZIzDpipGGw13vyX8KzXoW8rANYCyO0fTnkO2UtH
	 tDRAhB41JkF+BeGDmL8UIS5Ep7le/Imt3C2+9LW8JCSfafpCOexsXqJChKUM2niw+JQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794263035;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=8hmMeV5cYpkyVbO+8rVFjcraRnuW0D2GnV6y9K7JExE=;
	b=mwGS+d2SNe9rc1arr5Ri0fh2DOtz0TSsqjrUzYEXdlGAH+z8lDQnPAquWHuLJS/ojJQR
	 C1gU354It/6Xai5DpPpKPqfuVmJZbHNuJqenVuDUzHh1V8TjAdTO/vltn8SCyn2RBoewg
	 QhW8VPEMsxWYuLfh90jP2if5nhjw4+r1R6DPZJpIJEq54tyfQUkOG5/m3hMsQRQ3y+mwI
	 RmseeZCq8P47h27s3Rh3dgYdIwkqg/1+mhuFkn/Cwgw5bI6KBXYXR7zoruUBaIAcJh1cI
	 N7dFVhFzxl77YNcgLoLAkU8A2Qk91fjBfXsPdj096CR1zQxoAdkEI/OKtL3+S/pwDEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=USE94T41;
	arc=fail smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D8D606A321
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 22:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32D8D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=USE94T41
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794263035; x=1825799035;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y4hGbavegy54wtDZnkoUhT7wqvkOsYhkyEx2fftHInM=;
  b=USE94T41G0kq+qRXS3t7p1SO5TD3z3sOEO2AzLm+pK7/532RsuZivPIk
   St5ZmpKI6bF4bd0KkwkA0t8MINKvHH0xxRuOqwRy8ZbwcbJKSsnjR08Y8
   EKf/cKZDxVGkkrr2nYX6KuWrZ4x3rsjga0MhX0amv71R0HDUgA91EI45h
   ppw+fZIPayr9CI3bBcsZjq5jnp6AJ+uG6tYumeAJoo6rxfGn2Qn38czW9
   jHxwWK+u7Thczk/jggRgGNTvgznr6v5uwj3CIZKRak/hMoSjn64B52LHB
   bhD3FsirUAilaUhcEXBeKQrIyxnRwZHG4EImiJcAF5wXQ3KaJD7rHwlHJ
   g==;
X-CSE-ConnectionGUID: uyrB7OI2RGOOyCW8rNVA8Q==
X-CSE-MsgGUID: n2pDcp4BT5Svph3N54/liQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010917"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="3010917"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 14:23:55 -0800
X-CSE-ConnectionGUID: Q4FfR9DgRxGSQB17Rc+dMw==
X-CSE-MsgGUID: mEICCwMVQlCKszOzWml1rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8123335"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 14:23:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 14:23:53 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 9 Nov 2026 14:23:53 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.21) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 14:23:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/H5fvTk7y8ewky7Y+SApVytEO+yYZQ7pD5A/jLTBpM41Rjn3ci5H4PTF6WtHRryxo7Hm24IqTzLHYpzRjpp5BopyuH3qeoem1s+HdtMzgNudVobLOAMnlKQIA8M5V5qp3Dcc2aBPNjlAkmke+lyhtR1wOTqROkOlNRh10OyuLZLiT3XZyt5utHdKg48DZLAEJ8BgIHJuqjVbLzW2/3Biw0OziGHUuqY1zYU3LrERNey1IjwwpBFWAkhh279Jvgb36EJZeYWnBTIrKURETJA6gtqD1zO+4SyVSwDbWLeJjvo2PqPwgtShZ77CMmTApuBSR/89A1PY18PpEGPWWpPEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hmMeV5cYpkyVbO+8rVFjcraRnuW0D2GnV6y9K7JExE=;
 b=igZRmTLIynHbidcwmet9sIDnSmzvm7TiN0Dm1Y2TRHm8lflfEs1xcezwefyVeM49vjSIV2JMdW/HjkJK7Fgpm4gSNwfdkeMLRbGdznAV/UyUWED1CkokalFuwZC3B/iaqkxwygX3Vbm0LVHaCS0NO/jJLQlz0Vd9pd0FIpyOP1BNbpklMzjksVL2xz5F69ZY4yfPiQuCKWmSrFDl8+M4jpWbVJcx+wFkPXjPWoxbvS6wuz6GwcpsdZr6b2MmHVRaJNfeq7YcfXS/t92MlJtadh0JAVaaoS4BGwqXtTY5S8KgHy2qhEDgpcAl5PDoc1FYIvG+ddYOtNe30BFX4du4Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 22:23:51 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 22:23:51 +0000
Message-ID: <420a4782-2c1b-4cad-9fec-2454184f4f62@intel.com>
Date: Mon, 9 Nov 2026 14:23:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] x86,fs/resctrl: Cleanups in preparation for
 multiple controls support
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>
References: <cover.1793834224.git.reinette.chatre@intel.com>
 <0dfb141b-7b92-423b-8603-12d99ad1b2e7@intel.com>
 <20261109014629.GEavEl9ds0dVxaOqER@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20261109014629.GEavEl9ds0dVxaOqER@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0299.namprd03.prod.outlook.com
 (2603:10b6:303:b5::34) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|CO1PR11MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a4c1053-ada5-4ccf-fe35-08df3eb021e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|261028144727099003|4143699003|11063799006|56012099006|261022105027099003|261026140227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: FCQgQi/PNsp1bIio0meOxP5mVGOr6IpJe5Z1mM4MJKSSzYAU29xkOJyNUpsO4W2az+oATVeFMtzodKVXGzo98rx/CS94BsEYLXiMh8+U0T3kWu7R6Ppr8KshiI7SpksyHKjNJh9s6G+uHvG6wA4h6tjSUi5PxXdBFUZXWCIrvKTAhrH5bUhOg2rBXQHTl/cPpQbTmIYEOWCIn3vsQZz695/dhB+kysoEMw3utAhnC/cWn+1RpxBpmT4JYJe9Q/fQ9KaRQA51sUPNTSxrOebj7T98YE5KAnsqqLJWsuuO562qMgHU/taxfHqRHOYXEj3BMG14WFlTGnmQRZ0CCRvRv6T9lzga7ZmxC5eylxMbTxLNeaY3BzbPqmw14usOrcPQUzA3rneyChKYlGtAr/A6gmVOSN1rIo5q/KDd4bY84YBmyJrAJVxFxHxM0tZB+zDPCuVmH3DkJjFf6JJ90bJ1HblAwtR2wI8sPnKdGIEN34XWOutgYUWFB+VlkUeiEOMnQIxvicZ+0V91ffyRYpjpqKCGQ6thiqW8RGFDxl6W1NRes9tbasqdW8r6R5jJekg82/mx2A4gvXNxmHOQGA/yFQKryZsGC3SUDz3GKNcpBq3Lte+6os0Gc7gdMFgIvwjDWKkvPtCa2Le7V3bjfjSL/beh/+EKkUNSyc/E2OrI3UE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(261028144727099003)(4143699003)(11063799006)(56012099006)(261022105027099003)(261026140227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEo2Nmw0ZnlHZUdlV1VYc3MxZDdpbGJUMEpXR1p5N0o5K0VwdXVvM0FYTTJI?=
 =?utf-8?B?Q2ZFUmFmN01QdGNpNEdXNFVUbzgraWczNE5la2VkeVpGMmFpck9RTEpBZkNa?=
 =?utf-8?B?NE04SDcwaGlZaVpLSWVoU0w2cUJKR3dsckNLRURMYmxjVTllZlhiYWxZbDRD?=
 =?utf-8?B?MjkwRjJOcFdQLzhnVFVZUkpXV3RTVWp6MTZUZkgxaVhtU1RuUmdlTUZzNFdN?=
 =?utf-8?B?OFUwQUZidEdoNlV4RlIyYUYyaUhMMU1zNVgzbnNqS0VkZVFVakFnK1NKTXMv?=
 =?utf-8?B?bXVkQ3NDMVkxQWU0Ti81V0hOVUViNkc3ZGp5YlVxTUV3RWlPUjhpeWYvbWh4?=
 =?utf-8?B?N002NHNoeUdEdUw1K3lHL3FodG0vMXg4bWRIOFdQMVM1M25xdkQ5VHU5K0tO?=
 =?utf-8?B?U3R0aDdnNnBJemdMZ2U4TnIwRVc1czdXYitvUllVQ0tacWlzMitpZ3g5MVVI?=
 =?utf-8?B?QncxaW1lekRzTkQvNE0rU3VKSzZtMUhLSEtRc1dKSFRGNHh4emxxOWtZQWVt?=
 =?utf-8?B?aXZubXR5U2g0TGRIc1c1dENuWGdqYWhLWlc0eUdCaWlMcG9PaEEvVStyVmQr?=
 =?utf-8?B?VmYwNTZzbUtac3lpakE5bytRc0Qxa2ovZWFrMXU0cjM0TmNmd25acVBHZGNV?=
 =?utf-8?B?M2FIZEUxTjZDU3FvQ0loWHZvdGl0WjlGbWs0UDRpV2JJMEplTGdKenpGaGQ3?=
 =?utf-8?B?WDh6OXZiVlBGZ3BXeW5BekJBdk5TUWRkdExrdHFHUjFxMHROcGNIQ3oxMnJn?=
 =?utf-8?B?ZGFIL2ZiZG5mWUJoMGRsZzZYbzA4NGNKdTlwaVY1OGpnSnRjOTNQbnhjOUox?=
 =?utf-8?B?RHEvM3N2N25UNU5mcXlCSENNWjVlQkZqc3B5YUc0cmZqU2V4czAzSnZ3WUpy?=
 =?utf-8?B?NWRVUTVCTmxPNnFFY3kwVHI4ZTlWcUNlVTM3VGVDWHVhR1pUMGZuc245amw2?=
 =?utf-8?B?S1lpWEZ4Q295cXEzdmdwSGNOZktmWmc3eFdwbUo4RTBBRmVGMGpSNzJZOWJa?=
 =?utf-8?B?OWNoUDdXS1RsWE8zSjhEbXNjM0xYOCtKYUIvdjN1VmRCTjlvRXJuQUVKWUw2?=
 =?utf-8?B?VTZZRmxveUV6MmUzNXllT0hJU1VtMGhwbXVMc0NHbEVxTXpWMDRnQ2oxcVNo?=
 =?utf-8?B?eWpqWS95R0IvZHdoWExhSVgxL2F2bVZWbkFXWndBbExxYURqMmUzdE9QK1hV?=
 =?utf-8?B?dWltRkFYa0tjWjJLWnhldHI3Z281QjJZSjZqeU9xRFh0R3VRTHV5YmRaanJ0?=
 =?utf-8?B?NnNjZHJTZ3FaT2syTkw1ajhrSjZZMEQ3THBZUjZpeXRsYk9wRDhqNEdVZTFh?=
 =?utf-8?B?UmRuUnFPdU5HVDVEYzREMHRVZHhuNis3TDZuV05iQ1h3UE1xYTRDNC9NekNH?=
 =?utf-8?B?ZCtrTHh3azNyQk40ak5uT2xQMXNDKzg1VXhZdjFLOWVLTEF4ZThmL2p3aVV2?=
 =?utf-8?B?Q1pTb28wTzZzSm9CQXJHRmhsOFlKbnR1WWZZTk16MGZCeUFBR3lod1BBMExj?=
 =?utf-8?B?aGxXMERBaFl1dEtyQnhPbW1yamdHcHFhbVZDS0JTVGxhRU1rVkFXZ0w1aGZO?=
 =?utf-8?B?aWozRzEvWGFyV3lPZjdQdEdpM29pN3V6UXB2NFpycndaNTNnYy9LM0lHZ2pE?=
 =?utf-8?B?ZmgwcWdKeXVlcXhQcTNiVlBOaEhERlU2YWZURkRxcjNGbXUyQnV1a1BWaEQw?=
 =?utf-8?B?eEVkQnFCWXlGQXdETk9xaUR1NDlxY1JVNW1DQ1ZuNFNuZ1J4K2oyY0VQenZn?=
 =?utf-8?B?WHdZOU1wV21jWlpyK0tTd2lCcDNCdkpWRTMvbStScDl1blZzNXFyeEJzZVZT?=
 =?utf-8?B?WmZRYkRQY1FSY1E3clhKbUl1WkFibWF2L1pXNUZoZUNTTDR1WGRFZmpkMmd1?=
 =?utf-8?B?eDVyMTVrRkYvVDJRVDJMclRwTFczN2MydCtqZ091TG9Zem5DYTRmOHc5VlZr?=
 =?utf-8?B?ZUZPTEFJUzl5Mk1TQ3U4eTJiQmY4MkIyY3E5Snk5TmY1M0ovS1FXS2hPOEhN?=
 =?utf-8?B?VG9Xa2RJUUZWVWR4VHJJMUdlRUlQOVd0ckdxWUdFaFRjUzk4emZLcWNodWtU?=
 =?utf-8?B?dlJNN1ZjUkswVzBPc3g3K3QzdmFIOFhoTC9tNFp0TXNmV1F6N1ROVEluRWpU?=
 =?utf-8?B?ZC8zeTVyODR4NEtwZHd3UEEwbm1lVStHOWdKQ0RscFR2R1RjUHpwRUVoV3k5?=
 =?utf-8?B?Q3VNaFhFY3dOYkg3MGJwckNUNHVYdHZ1VTJKL3J0Z0dyYUYyRTluQi90WENG?=
 =?utf-8?B?NWVuKzdJbmgyKzk4WUc2OGxRTkxFL1NmR0d5Y0h3Ly9EbU15RXY0SFNhekZQ?=
 =?utf-8?B?dlpXVnhUVlh4SHFqMEJ3azFKdmFvMkRPc28yNzFXZ1EwSmJoUkdPVDVJR1ow?=
 =?utf-8?Q?TNBts5rLK/z/6cHE=3D?=
X-Exchange-RoutingPolicyChecked: lvfwzTgCLQCRa13iSA/9L+clPvWn6jqpG4RafjF0OSlTHVThvUEl2u1/9x01a96qnnCDhI2sz9dxb7CAP37m0G3dkdLcWvNbazOOeTHrdwr+tvmEM86sAhHgGlBt7Kevogd/FbPnDSUR5my0VjUFBXgke+xQIZMWsPcCQNzlrb/WHdT8NIaELZBH2+Q0GbuSqfwY/42McOYP7eKD58/MjuHz+XskYTbBug4Cp7hd27MzAayLs6jA2cxSBbXOZ0BZ2TJuNTEn3EHn1fw6JZn10uIArfq1Kc/gUn93iXZRaz6SnxXQm6RWaNxq3JVX2FzfOOsA+3vPyd0uPsy+1AlnDQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4c1053-ada5-4ccf-fe35-08df3eb021e1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 22:23:51.5632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gA/a2MXDvzJa8RtL/1aFlLXguZ3jxNyqAHhAyGG4getemf+DX2agixi5cSPMVdT+LZ1HHakKAbGdOD6GCQJrnJbl8S6jz5WhYXdMH/V8ZDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5105
X-OriginatorOrg: intel.com

Hi Boris,

On 11/8/26 5:46 PM, Borislav Petkov wrote:
> On Wed, Nov 04, 2026 at 04:26:43PM -0800, Reinette Chatre wrote:
>> Dear x86 maintainers,
>>
>> Could you please consider this series for inclusion?
> 
> /me is looking...
> 

Thank you very much for merging the series.

Reinette
