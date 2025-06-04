Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAED145B3E
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007967; cv=fail; b=nTYUUqbwos6t4srlVSmjVTWYLkxCq+vHy+UBjJeJBVta0on4tusO+8qpz2rBEE0KvxfHeH3EgSG26oCWnCsAeU2s2pPh/TPHMLvLCyliv14dUmAXYiCzm/LMnADoNsBj0Q6+xF1eQHAoc9K0NfU25hWi+Jf5YBtcEc3NNQX6PcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007967; c=relaxed/simple;
	bh=f7y0EY8TouRLWMDp+gFqM0gNJAbGRIXWg/FQApjMBZE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ci7miJ0qVSRuoXxhlEDGcnXURkF34jnAQMmPaaiIP4yIGcF0Min5W8x3uNakTiwRv37Dpe7+vg1sAg15j2afv1Z2vIRT+ha/P46bFFYSxZx/l4waRArF3ifGxKOPEm1LbapHSkduCisyaiu1uAvczhkopQbDgAHDQVvbGyETUOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MStytUFt; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MStytUFt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007967; x=1780543967;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f7y0EY8TouRLWMDp+gFqM0gNJAbGRIXWg/FQApjMBZE=;
  b=MStytUFtp/whLaSF2e3WW9GMbjr+EMLr3DAQIG1/LNuUXdO6FR8WTkXh
   +Yk3EvT5CEk2gJrdo7Nnd2KlZtCzhrtmqUQuY2mcB/SH32dD3qxQbGXTe
   DZrMDeiV0pNJVfl8ISffHFUuH83Ch/ye+B/MvXmM9tBZ2cCE/NSBFZUwo
   P2HDq9ykHqUO4zIzXACCH50sqD1X2cW6bfwfHRxLEWuTRxbvNFeXjYDfM
   21LFQcT50LNk3t9E0lP5iFvehCh487nGemQbzUyz3cnZ5yVc1MvnKUSLB
   frgoTgR16ODz6+4FgjTpq6FW/WC0G/UeqWRzDTCuoUD6g/p8qPrEOhwBe
   Q==;
X-CSE-ConnectionGUID: MLZOBJ42TXKiFoA+9p3AwA==
X-CSE-MsgGUID: Bh0w3TRYSjuoCr2pz3Jatw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="38702683"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="38702683"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:32:46 -0700
X-CSE-ConnectionGUID: CPMLX8VLQN6kKB4M48SC/Q==
X-CSE-MsgGUID: ckUVJMORRsWv0UiXEWoDEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="149836925"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:32:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:32:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:32:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.66) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:32:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3n9Yj5Jq2tpnp+TiCackzjJi38o4gcnzpbvEDdA2TayGUhXLMh7qPVuYihuZxOKi1CxhfOK6QXnpLmqqoCYGdoRpxCNvXaj9urGoVKRz0U+3tp6i+GaGO2AwgYhs6QA1R5zK1otvE/kpfyKT5k3e50Tl33Gx4IDeBY+5U/7ok3el3nv7KgAH/HLd63/r1LyijURc/OvJm1qVToKFPSXmncPd10gG5nMLaJS6PNwB4Cr5YaQvteAXXalYxZ+wDSQrta3wdLtxrpd34XY9Kao/d8C5wBTpFD+m73dR3Tj3+aqyCEq9Nb/G2tKHjpxYIHJytqpZL7VSvvVwymOm1uX3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aJDXwJdX9k1j8sh/6IxCIBI2rsrtLqrqQDmNGWQ6wQ=;
 b=PO4QTiS0gAXcCx5Vc8iuWNgh935qIyZouxdpIOtX5mvBFIvtAd8RmY/2TMiOOHoAnh0tZuLmnUCRpuV882wMTd9prkm0RGmVno8RLB+8MvqHm+3B+o8y2T7jEOkUclhztme3L3f6WS16kUCEr5lZEhTp26kswAU0wsCTH3tf9sOhK57bq952exq6gvTkqkP+Zh2ZApqqBp9fcoKMA1aEtTgD3EMpm5n5r8q3zdw/0qh0ZMuHFhbHCYPcmSnhm26DkpakJzj1IK470Vdhl/z2WvzFkm9bLjlnUMzwPiNUVOxxNX9SkVguSa4K1HlMsAlwsL2zjOd3Vrr5HewIkpTrzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Wed, 4 Jun
 2025 03:32:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:32:11 +0000
Message-ID: <f28541fd-16e5-4216-b43f-7a79639cf56d@intel.com>
Date: Tue, 3 Jun 2025 20:32:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/29] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:a03:338::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: acd7ad71-86a9-4849-2fbb-08dda318640c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V0Z6TlltblR6Slh3emtjYzdaWmRhK0xaYmN1Tk5wczEzdTFad3p0RnVaSnJE?=
 =?utf-8?B?MWZTM0F5T1h3Y2FVSE11ZFdZcFE3ZnRTUUMvanZmVE1Sc2svUk4rUXRvczNE?=
 =?utf-8?B?eldLUExPakgvQm5ZaTluZXNpUGVhL1kzWWRFTUw4c3BQSUJ2ejMvYUVFbzZh?=
 =?utf-8?B?TW1oOGYvbnZwSS9nUCtNdVVQRHdPNjBxaGdTNEYrc1RKL3dMU2VvNFFaWUlz?=
 =?utf-8?B?a093cy85VFczQ3orajc0Ni9IRVU2cWpEMHFxZWFLLzVhOEpTTy94MWJkWGxn?=
 =?utf-8?B?d2VVVTlXQlJDVDBHanhnSXVVTjdjMUJDbGVEbnFXbHoybXRJcnJQS0w1Q3ZB?=
 =?utf-8?B?TGk0Uks0VTl1eXBuTzA1bldkN09OaE51aXlEMjhJOS81Z3JsNCtJQWxIQ3ZV?=
 =?utf-8?B?QlhRblVBTW0vQ3NXWXhZdTVDUnBwZnZZODlVQ28yaXgvcGw1R0J0RTl1YWJM?=
 =?utf-8?B?K2t6TkkyZEhMK2hBcUtRTUU3YVQ5VmdoMzJZaTVueW8vUWZUMzlodWZwQTNN?=
 =?utf-8?B?bVBIaityUjd4ajBFRkx1VU9QMUxyT3pZM05iN2NXcGkwQk5YU0xBWUE1SzBB?=
 =?utf-8?B?enYxbEcvQktqWkxVOUw1aEFnc0sxaStZSWhyUkZDSXRNNzY4MU5ta0lpNWg0?=
 =?utf-8?B?RmxiM1ZLSlZqSEJobno0Wm9yNGZaTGNiR1FXejlXbkxDQkFCQ2N6YldIUVhK?=
 =?utf-8?B?R0xxR0wyMmFQelRUSXg4SzdVdy84VG5DL25wOFBsT0JwRlcrd1lyMHgzaEI4?=
 =?utf-8?B?UjlFMy9qZzlWSm1aMW1aZkdDVXEvNWxra1EvMlg3d2NOZ21TaElKT05UcUdv?=
 =?utf-8?B?RjkrL2k1czAwTGFuVWlpVWxFVmJ5NXVsTUk5eUgrTjVuSTZLVWsrRXBKalpp?=
 =?utf-8?B?V1R4cVgxUmRJbGlCQWVRSnp3emFCelFRQ2VrSkVHdU5EWmgwUnVpdEczemM2?=
 =?utf-8?B?azRlQlVOUEloZzVsMzgrSWxuMkZkOUFucnZmbmtKbkVzeW1KbHYvYnRJK2ZL?=
 =?utf-8?B?NngvMFBJb01sVmZPcnhWWU9KSWN5UEVYZnpGa2FWWEU0YkI3MDdRSTZBcTR0?=
 =?utf-8?B?aDF4Z0gwMzk4TVIvRWlnUWd4dUxtYTZiNWlFcmtWOWZuK2srRzhJUmx6cW50?=
 =?utf-8?B?R3lFV3hHaTJwVE5LVzYyc1dKSWRMelRCaDZjUkFQbnE0S0J0Ulc1eTV2TlRP?=
 =?utf-8?B?T2JyeWNpYXhUeEtFYWpLWU82TFFVMXhBWjA1Zk5LQWVBZ2diU3cxSVpoa1RK?=
 =?utf-8?B?RFBwU2luNEoreEZjTmEvS1BHTnFZZnNZUEFpdlAxZHR3OHJoc3piVmhINlJv?=
 =?utf-8?B?cXhJYUtuZ2gzb0M1bDErbDBDdXhUVVJyN2wzK29hdjhSellHNjdGSUNsZE9r?=
 =?utf-8?B?TGNlZEdTTmF3bWsyeHFRY3kxQjducm1XMCtPaXZBbXRubjh2alNpVExsMUNL?=
 =?utf-8?B?L1ZGcUZTVFU5VVZ6VmQwVzZpMEU4QUdsNUthaHBtd2VRdm5nRU11TndreEM2?=
 =?utf-8?B?VXdHL0RaS3lndVJ5UHVLTEhpSFp2N3A0anFaU3l0S2EzdDhRNmo0YUJPYlUy?=
 =?utf-8?B?anlJRTFpSlB2WWwzNEFWWklBT2xBTWtlWWQxTXpTditZdWNtOXdhNkRubzVu?=
 =?utf-8?B?VXhxM0pVZENpVjYrOXMwdzUxZFZRMXJHL3RVeEhiZDBoNWpvS0xabE85NmM1?=
 =?utf-8?B?VVdKTExpWHduZ2tyZU1vbTZYK2dGeTdyVXdaRGV0SlpKT1BFdWYzVUZWQ0pq?=
 =?utf-8?B?aXpRLytTckZMNU1oVmZGM1lENGh2VVUwWFk1b1UrTldCSkIxZGxJUHlyK3hC?=
 =?utf-8?B?WDdMd1ZYOVNmcDVRajA2UStzOWpBNE1RcFFnQ1VDN0U2T0NpQlYxaUpEME5z?=
 =?utf-8?B?dzJoV0dJbnpZUGRTZ1QxREhSZWJLbEpsazhKL2lMTjMyc0pSSVluWWoyVnBY?=
 =?utf-8?B?Zll0cHpyRVUwbk9LVm1jSDl2andPcnlINFFBSEc0UDdGekFOcFNseXNNQWI4?=
 =?utf-8?B?cURGR3dITXN3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjdweWZldXdlYlE3YURhNGsyQ0RSampXeW80WXJUM2Z0bEpQclZHVXBQVDJu?=
 =?utf-8?B?TXJVbUVoNGJpbGd4dmpNc0cxaVpkQW5tSVRoSk0raWFROWxOb1hsU2Q3bEtS?=
 =?utf-8?B?bEo3SDFUalpCZXp5d3Q1SmFVMWN0d1ZTdGxETDloWGFCT3liREhNeXptZnJ0?=
 =?utf-8?B?aWt0Nmx1MTcxTFFCRUJZekw3cFZmV3lKdmh4OVpwaEZmLzhZSlZGZk1YeTZi?=
 =?utf-8?B?VXRTRkFSMGozNS9SM1pEMCt5WDBUQ1E2YkdSWUttUHJBbWJzOEh3VlZQWFMw?=
 =?utf-8?B?dlROdXREU0tyWUpMR0FuNEtPcnBTTEhoWklLbnROY1BMSmZWSEdSWHhBelhs?=
 =?utf-8?B?VWlPakVwZFJsMTcyTDhVYU9kOWdVT2VlWUt1eGJiV05udUpvbFJ5ZlFDZkYw?=
 =?utf-8?B?K0tRVUNvWG1jd2dxanpYZUNWVkkyQWRQUStCbXVrQjdiZU02YVpMdXdYaE9E?=
 =?utf-8?B?Y1VhQy9sdmZSaDNjUzZLNlF4eE16M2NyL1E0WmZFTlNiS2IrRDB1ekxZcXFq?=
 =?utf-8?B?eFlOMk55aTRpakh3VmxWSTJXbGdUYVFtczhhQThsNzczUkVuTGtjSTVQcWgr?=
 =?utf-8?B?YzVvREVlL2FBaHBxZFB2czFyTHdESzdBY04wSzh0M21xMmRkd2p5Ly9GSWtZ?=
 =?utf-8?B?SWlMdmxEZHNNakZsYkFrdWRnYWpCY1RVWkNUM1FyTU96emxEcUFvdHNzOThv?=
 =?utf-8?B?RDdwcDlnMkNXWTc2NW1oUXMxMDg0MGN5Q0xmUUk3RGE5ZVljNTNxM1dLRTRt?=
 =?utf-8?B?MmZUME8xWW4yckpaeHBDRnp6UnlDN2FydnNoNkVkVG04dlNMdGs4QTFDemdX?=
 =?utf-8?B?aHdrTmNlbko1R0RCOEJmMm9lR0lFQTFTOUUrU3NYMXNPaVhIOXBQbHpEeWJo?=
 =?utf-8?B?K1lZNEJJdHQ3SGlLenJEYm1iNzFBbFNGM1VKeGxFU2txRTdpRXY1QUQ0eXNG?=
 =?utf-8?B?U3I5cWNLMjZVUi9VYm9XSDhCLzNrb1Z2SE9OTUxBc2NRZFhzUC9wMFU1WTN4?=
 =?utf-8?B?c2k4NWRRRDNjNHVqWUd6MFNndnorNExyQlNxKzdLbFhBeHp5M0JsZWkyMDlr?=
 =?utf-8?B?cmtkVHJTOUg4MElvelJvRnFOeXlMMXBkUFZadDYyUUR3dy9NV3pYZDdVZEtt?=
 =?utf-8?B?WlVjeGt4MVl0WlBpZU95aitCKysvNy81QS9Dc2M0WGc4TnJXVG5ZMjdkSHI0?=
 =?utf-8?B?RjZ5SWJjODk3dm8wZWtpWE1UbUVuaVhBVVBrdExjU2xnV084VEQ1YUZJbDBy?=
 =?utf-8?B?VlQxTWNJYjdBeE1YS0NQWm5nenlkQi9yN0R6OEJBbGhXalZpWTUzNmJ6S3BF?=
 =?utf-8?B?Tzk1ZmxpZnZUSElNZU10VWJ1YldhRWtmZXNBN1dxZk9xWjNmSklCY3N3SHE4?=
 =?utf-8?B?Q0I2WnVObFdvWG1oVFpadDBqakZFVVI0M3c5ZHJFQzQ1UlV0L1R6R1E5YUk0?=
 =?utf-8?B?ZEtMdi81QUdVelJhNFpIZ052dWRDSHhBN3BqV042TWxHVTAwVERWWkJxZ042?=
 =?utf-8?B?anZncS9KNTh0S1F4MmIzOHduNWg5cUNVN1I0dFVkWGd6M05EVTlYOGQ1N3lh?=
 =?utf-8?B?M0hjc3JqMUFuOHFJNjZkNlVyK3BSODM3TVZKRnFGOUVJVGRWeld6Q2N3dFdX?=
 =?utf-8?B?SUZyTy90aE5VbzlhQUpWNnFza244M3g1TEdVekNUV0NoYW9PekpCOHBQSVBS?=
 =?utf-8?B?Ukc4S0ZaekpsN05JNXdxMlNWUVhZaEZxRE9xR2M0dG81R2FJblVtMTZPYUdz?=
 =?utf-8?B?RjBYL1NmYnpsWTFJMU0zSVZvNTh0bk53Y09YZGVFaGdMU1V1VEZCaDRkeHlO?=
 =?utf-8?B?TjdLTVM4QndJV0kwQWthdUxhcWM1KzIyRGFQZ2tkczRWOGRKb0N0REo2TDZH?=
 =?utf-8?B?UXpKV1FhSEMya2R6M1JmQ0pXbjFVeFlXMnFscDdHV1NFcGJ1ODN4UE5PdnEx?=
 =?utf-8?B?Qnp3STFrVTN2c1I1cXZHMHFBRE1YVjJOd2JTTDd0T0lGelFGZ1pjQ21rR016?=
 =?utf-8?B?WVUrVW9SQzY0QW04d0xiMWt6SWRxNjlJV1o2Z05nZmR0ZUZoNGY3dCtpZ0JW?=
 =?utf-8?B?VmZnb3lKazc3VUxYbG92N0pjSmxqS2VCaUdkU09rK2xmYWliWWtpN1JhVXIv?=
 =?utf-8?B?V0Q1UThITlQvVUs0S2pRM09PNzFnV0dBcjRNTDVKbGtycW5rYVptSXJpVCtT?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acd7ad71-86a9-4849-2fbb-08dda318640c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:32:11.0839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CKuO5nVj1OTVyaP/KvM7QSZDSpIzVHyz0r4K9ibWMbe5tqIcdp16a+kBmbtAhgd9hliSm3aOIImIT0T16JdDgKW7AqgPCjMr4HysZBDMEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> All monitor events used to be connected to the L3 resource so
> it was OK for function names to be generic. But this will cause
> confusion with additional events tied to other resources.
> 
> Rename functions that are only used for L3 features:

This does not rename all functions that are only used for L3 features.
Could you please add criteria used to decide which ones to rename?

> 
> arch_mon_domain_online()	-> arch_l3_mon_domain_online()
> mon_domain_free()		-> l3_mon_domain_free()

This separates the alloc and free partner functions even more.
The partner, while not completely symmetrical, is arch_domain_mbm_alloc().
How about naming arch_domain_mbm_alloc() -> l3_mon_domain_mbm_alloc()
to at least be closer?

> domain_setup_mon_state()	-> domain_setup_l3_mon_state

nit: domain_setup_l3_mon_state -> domain_setup_l3_mon_state()

This breaks symmetry with domain_destroy_mon_state(). Can domain_destroy_mon_state()
be renamed to domain_destroy_l3_mon_state()?

Reinette

