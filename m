Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E8A13D8B1
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731455890; cv=fail; b=nHEdftlVpr0HXhqEjTHJjEg9BJ302vQXIpu3kTO37EfwXN3oOj96v26xCakl4Liyq9ZB/hUD67BjuiGsesEutm8IwXyNx4KQd0izZ+bTDcGnCZGkKwYuWAgI04ZZwY2/JgU8giMHzK9SBXrZ0dKgXA3irIMKH2ri9XeYycn73gQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731455890; c=relaxed/simple;
	bh=81f4pdtP0uciufjom0rF1/bZj5X7xrUYaXF1diSvPZo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aP+fNiS/EalMP0bSXd41ArkSXWx0BeLYyW6oMrvyu7zkhc7yvif4urhvXLMcgRVlOwcy7Syg0jjyYnbIqMoRBHuyJbN/SviVnkh1R+0c/Bvl5SRVFNbXu5P89n6fUbIppC+xa6joITTsy33+ledvsOxY216n7J4YAQpupRWBlrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZEOaaRVB; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZEOaaRVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731455889; x=1762991889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=81f4pdtP0uciufjom0rF1/bZj5X7xrUYaXF1diSvPZo=;
  b=ZEOaaRVBaNu7OryBn1C04ZN0uN0JW2lyUsZr8+Y7BZa4UVJKX1Dd4GWJ
   egn3z13foZ0nB1NwdMDzA0jnnArwXBResG0t5FfqieQjFduZ3mBCayEmu
   bolug3Oiy7ObFrLiNpXgehQgX9T8uqj5kUeNv9oIIGWTbIHpPHgtvPyRT
   oMNQZv14yENF2Wq3lF0G+LWVQKXjEWlnYGPH+ndxBdcQbA+Kz2qZSlfU/
   z074jO/CJzLQ1B8Z5AXpR6UWQMngviWSfQgPfRjgZ9tm8qTmsb9Hd1LMu
   qFaB8NYkT9DdxInWCX03t+6HvXKRC7yxbm4rJliCQsxBMiQK/04zJK34r
   A==;
X-CSE-ConnectionGUID: Bts93qaVRR+QmFysyUU4rQ==
X-CSE-MsgGUID: HLFXGwzoTya/oWFDq/x7Vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31551424"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="31551424"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 15:58:00 -0800
X-CSE-ConnectionGUID: g5b2I0joQPKod49KWERiPw==
X-CSE-MsgGUID: sRd/dxQjTI694x6m/6JoOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88076527"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 15:57:56 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 15:57:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 15:57:55 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 15:57:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBZrK2qZ3WQtwnAfWHY3AvtgRfWzkkY+rWPOfXyX+mrbWOAqGd+voP99hjIpt04HpRKV3iVGhXVBp4P2a0P1wtMpqkSob6rAdiOCsii55/+Rhu8i8wy6j5sus7SAnHP9+f2yWAOHLTcx/2QBpxo67KKwBN7KgdISzRc4GFcc7iB1kWQhiaT16kyxQQ3pQJ3TBRBqKUD4ARDmOYasJSvnaBQVMKhg6Tg9BUNGw5AuedQ7P1qBZmgCoXPo4KG5fnMo2JXyWiXYQ+tnTnrZVjy7+kZpLtB4wKrKgle+h+lzB8CKxa8HARxMpCCXQcHOsw6Bjs3YPA8AhbMjyUldifriBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81f4pdtP0uciufjom0rF1/bZj5X7xrUYaXF1diSvPZo=;
 b=kAw701bYj75Sq9P2xFRW8ubg/Gz9Ub9wAWtPrw3mY6Ep4ZyyE1r9ZVS2fPxcMjMk2vD3lPJhPBtxG7AqcNB+b1vHnAS+D7VW7smXompRMVL86UJQm/AmG/BbafDCLoEJVij5qUBatBcNZhtLc0NpdK0qqChCumXWFWx3Q/HTjOlT8uTnLNuI652FB0Wz+7pAbroNQxHujqZMJsgpsWR9ZD1rRcgNxZlXZDu2fX04kaEWy2Ylt0O7BxcnaH9SuXuxaPmFxhKl6JmUxS29KdiQ1va2/hlff5MVcKgbV3DvtWh/9c8sofpKRM+sQxHfwTfLo/SZQF5arb1kucJMxRf0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7289.namprd11.prod.outlook.com (2603:10b6:930:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 12 Nov
 2024 23:57:52 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%3]) with mapi id 15.20.8137.022; Tue, 12 Nov 2024
 23:57:52 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
Thread-Topic: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
Thread-Index: AQHbKigHp2P1tXTtZkmmnqKqvRPLY7KjFsiAgAAFx7CAABOUAIARGCcAgAAcy8A=
Date: Tue, 12 Nov 2024 23:57:51 +0000
Message-ID: <SJ1PR11MB60839C385657E16FA5B84381FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-7-tony.luck@intel.com>
 <6a677a4b-7163-cc2d-a615-6b8c499eb281@intel.com>
 <SJ1PR11MB60833197C3FCC0B3CF9AA290FC562@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <7f5f1f66-df3e-bebd-4786-7fe8a8115f05@intel.com>
 <71eb17c7-acca-412c-bd59-17ee5aa0aa07@intel.com>
In-Reply-To: <71eb17c7-acca-412c-bd59-17ee5aa0aa07@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7289:EE_
x-ms-office365-filtering-correlation-id: ecafb414-7765-4ab4-81ba-08dd0375d1a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WVpoL3p0N0drd0pwRlJHMGNaT2NwSHR4TytoYnJQMnZvSU1sQTFjalNtZ0tP?=
 =?utf-8?B?K3hRTW03M1dHckMxY096WTdYSlZCeGR3elJwbmtMd3Q2Q1Y4VDJmbklzSnlo?=
 =?utf-8?B?YVR4VXEwUXNGUHpiemp4QlBFbDUxYmFkOXdpbXpERUo3d3cyVE1IVk5GVlh1?=
 =?utf-8?B?OGp2elBPcjgxOG5XQXFuc3d3NXcxVHRwclJmeS9vMHRSR3RWQVZvZFEwNTlV?=
 =?utf-8?B?YlFvd1A1QmZyZUFLQW92d3lyTC9zUDdUOXQ4UkxPdEJlTjJrd0FxcW5rTERD?=
 =?utf-8?B?YmxNL0RpVE1VVEVHeklHYUdxWWhrQ2xiWng4c1dNVEZ3bzdDeUNNdU42VHFT?=
 =?utf-8?B?aVBaNVBiekVLMjkxNlRlY1M2NEFPdndiMDNRS20xeUg1QlZqSUFMV21Ednc0?=
 =?utf-8?B?bkl1UDJYa0pFYTZRb1I5aFBBSHR0QTcwQ3BpRFlxcnVhV3kvV1g5OWl4RWkx?=
 =?utf-8?B?NWhsVE1IUkFMRDR1bmRtdTVteURMQTdGSEk0aG1VSHZPd01tS1pFYVhEWk0x?=
 =?utf-8?B?eEtaanB1bExLWHZuTExzYlg5ZDBvSjc3eG8wM2hPdHlyUmNxZC85b0pPWHB4?=
 =?utf-8?B?TU9qemc2REkvY0FmVUxZTGFOb05CSU13NFhqV24xZHlPZVlhVGJVZ0hkc0ZH?=
 =?utf-8?B?c1FoYnhYMmJqaVRtTWlxVFRubEVZR3ZOSXdldFVDN3JzOG9CTVhKNE1WdGJv?=
 =?utf-8?B?RHdqaU5HeitkSFlNTzdDaFhUYmZBTjZRSWVqU09oK0Z5dlFkbk1qRWtNM3M0?=
 =?utf-8?B?a0QxNjZxOHJGa1ZadVZkaytld0trQ3I4THNsNGxHL0cyOHlpeWplWnhFQTk3?=
 =?utf-8?B?dXVYUXpWUmpNajA5cHh3NklqV0g1WnA5NXBuYUlIUWZzK21qRlFRc2tkUDhp?=
 =?utf-8?B?U212OU90OWF1anNpdzVHMWVWQW1FeGplQTJFTDdob1VyVzMva2JnNWtCelhO?=
 =?utf-8?B?QURXUlZsOVFOMC9tK2lXbGpFcDMzNEZNQllKQ09YVitVM0NWbVJUMHZ4eFpK?=
 =?utf-8?B?Q1BnRzdRYjJsTmJXRkJ6Um1ZMWRYb0t6NGdocEREYThIckVtbVRqbUF3TkU2?=
 =?utf-8?B?Q3p4QjlmektEQlpZd3NwamZZaGxnSTdEK2NQa085RGVTazVxVDlqYVYwNHE4?=
 =?utf-8?B?NWtjbk1RMnpQdWtwOW4vVTF0UUxUUWNub245NkxhOFNhRGlKVWlCWW1pYk9o?=
 =?utf-8?B?Vm1iRGR2TmV1ellGcGhJREh3ekh2SmwyZEZmbTZnYmdvYjFETUU3cjdqb0Zy?=
 =?utf-8?B?blZYSjhacXg2UUJlTjBmaWxIWUFLdTZZanREVm0wZDR2YXhsc01aZW5vWGxL?=
 =?utf-8?B?NjA1dE9jaVpFMkU5dFFHYkk1Z1RwRHFvMXYrTVlGVUFWd2dvc2d3K2RXME9O?=
 =?utf-8?B?cEpCODlPN09wNVJLUC9wK3BLOXFMbi9aT3pHZUV4K3d2emVWQTJtSkdwRElT?=
 =?utf-8?B?Q2VmTFhkYkJMdDRBSG1WZ3phSERNdGJnVmQra2pYY1NYVFMzUktFd3plSHhX?=
 =?utf-8?B?Yk9FRmtvMVVlSkRuV0puSHNTSVdqRjBwMWhpSCs2d1RoN3dFNGpRWW9ySGFI?=
 =?utf-8?B?amlLME1yTUZsZlJQaEp5cFprZ3J3ZDFKL2wxT0poempVcGFobmZ5aysyMDFt?=
 =?utf-8?B?bHF5Rks5YmdNc1JsVUV1VS9VbEtlN2FlVlZYZXViTUxwKytmSTNLWjlWWmE0?=
 =?utf-8?B?ZUljV2RPS3o2QjRhZHRiOUo1ZTEvRTRYZ2xPcWFZcVp5UFlRc093NDYrUjRy?=
 =?utf-8?B?UVZIWFRDWHVBQ0U0YXFYZlZqU2xQazB6UlBkVStiNjRtMU1nS3c5bkg2Nm5m?=
 =?utf-8?Q?QwDh9KPJEO0tBBgYo7VcOZHw6xI2bb/i3CD/0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDFzakNBNzNPLzdKakxRZWYrUFpyQU5XdDdvS2lIRnh0dWxPRGtjbjM4MGtk?=
 =?utf-8?B?dWQ5ODFab0Ztdm1UQ3ZXTGNhQ2dGNkNETkZCZnhMRnVzVXM4M09IVUZhU08r?=
 =?utf-8?B?Mmx3ZXN3ZytoS0Y4S0tOMVZjVHkwTXlMRjd6RVVuZitzUnd3eEF5Q0V3YXl2?=
 =?utf-8?B?SU13clU3dlNWQVgyWUlKa2xqRlNHelRYSjF4VmFQcHhNUVhUeDBGakNQdDdt?=
 =?utf-8?B?blVXV1E5cDR3ZnhMS2VKbVF4RjVVN3ZIRGt5bGQyeWozU1hNMGcxZDNqWGlk?=
 =?utf-8?B?QVBLQkc3c0hYMTRDSVNQbUtSQXYxRE9uR0Nrb1d1NlgvTko5Y0ZNeU5mSXEv?=
 =?utf-8?B?VHdvR2thVDA5Wk01dEMxY1NMWm1GSXF0M2YrYzV2UjJoYjBrc3lnYTc0ckpJ?=
 =?utf-8?B?bkVwdW10RDFxblQ3NEdLL05XVFNHOS9ZSDlPczJJOFBZcEEwT1lRcFZER1BC?=
 =?utf-8?B?b1ppOE8zbEM5QktLamJBbklwc0JSa2hXeldGcWNxdXdheURySlZ3V0pZVjhU?=
 =?utf-8?B?eWw2d1JlYTVVU3NvbVE4SWx3RVB2bmFkTXZvZmE2Q3lRMTgrUHlLaVNRc2dv?=
 =?utf-8?B?blY5S3RybDBVdFpLU3VGQ0VMaG5maUR6OVBMVnB0MGFPZEgrTEVIcFR4NjVB?=
 =?utf-8?B?U2ttYWxWOE5FdUtiSTFPQndrSitzVXA0Q01HQTJXYWEySkFYZVh1d1ZBSFR1?=
 =?utf-8?B?NjFGQ2hwZ0RqSXBJZkZxS0ZPRkZxZ0x2YXoxRWFiS09aazIrbjlhRFhtZllu?=
 =?utf-8?B?MFFZc2JUcWNPcXBCYnA1SU1Fb2Vkd0ZpSGpQMUE5SzF0UE42c0xicUlRVnRq?=
 =?utf-8?B?N1hnckRSc2NSZFowYjEzMTRUNkJrdkpZWkU4emd5VnhrODVTazhrTThzS1NB?=
 =?utf-8?B?TGh5YTdPaWtvSklBV1lwN2FJTHdVNExhdEI2akFUQjRSSU96YlR4TGI2NEow?=
 =?utf-8?B?NUlaMVpsbkNUMU5pa2dMSFFOdU84MEJiY01MUlU1OEMyZHhUNnM3b21ielht?=
 =?utf-8?B?bjNqdmpPSnhSWlhDNWdwZEF1dVYyZGFoUDJsQ29BRzlseXlueEFoSlFMU3dx?=
 =?utf-8?B?dzI3czhvT2VpaW1YeTdRU3M5RCs0VDBNaWt1QThIb1ZuYlR2Y3NmSWczS2cr?=
 =?utf-8?B?VmtGNWJZUlJmSWxvNkkxRk4vdlY0N0Z1dWNxNnAxRXRDUnVSNnVvQVBYbHh0?=
 =?utf-8?B?b2piQkNxSlFJejFqL21lbVVJRU9nZkdqN1VmSTJyWnp0cHdKMWx6ZVZzM25p?=
 =?utf-8?B?VVZGOGhnVWo4UlR4ZWZEeHozS2hOSmxVMS9BQWg3Z0p3bFpoMVd5SmFXblRG?=
 =?utf-8?B?OW9rTEZOL1lTUURhUDI1cTZYekI4eDcxd2owZjFaN3Z1d1ROak40QmZpOUR1?=
 =?utf-8?B?RllqV0FyR0cySUxuT1VCMGwwTUtROUJxTWdkTTNNNU9ucU9ic1NIOEt0ZE00?=
 =?utf-8?B?NnNpYVQwMFZNbzZCbWtoSXlScWlQcDAzRTlGeVJuLzR0SnlBM0svQVVHVVYz?=
 =?utf-8?B?R2VISnR2U3kwcEgrWWhla2drUWFnN0hoK0Uwa2F3WHp4S2RuTjF2cjU4aU1F?=
 =?utf-8?B?NUYyS29yTlIzem5ia2I0bHVmL2UrUGQreEtpaUVWR05GK1VCaW9KdWQwM2FC?=
 =?utf-8?B?MzF6VGpFYmhMZEJNV2I5c09wVmNBdXdodWVXR3RBS3lJYzZTUmlNSzVmS3Fp?=
 =?utf-8?B?WmM1OWRXaEE4Q3cwdWNTWHdkWmUvT0FpZlh1Zk5JR3YyVkh4VzhiWUFaSGpK?=
 =?utf-8?B?Um5GaGRiOG1VWiszMUh2L2xtNFV6eVdJT0hTZkJBcUhibkV3WVd4cWFGY0JL?=
 =?utf-8?B?TVJieDF6UUVxSTdIWGZvblRKTE4vaHFvTWgzY1ZUWHpHNkpZaThjSmM0N2lU?=
 =?utf-8?B?cXZ4cmp1Y2dpTVFxYU90dk1rOGY4cnJyMjhabjV0YTBnUkE5YVA5K3I5S3hM?=
 =?utf-8?B?Y3JLTGNFbkFCRDNBYVBiN0FPRkdiZ3ZCU05aV1JCNFRaVHZTWm56VnFpUWRD?=
 =?utf-8?B?NVFQVUp4UDdmcnlrNmNaTEFzLzR4d08rYnBlY05FTE9rcUxyTUMwTkdYZkNl?=
 =?utf-8?B?Nmk4NEpRdmE1cndxSHJRajN5cWJSVTd2cGIxWVJHSk1MZWxHTnkwU3ZFRkQ5?=
 =?utf-8?Q?o9c4Td2aQlu4FqzjAojk7GirZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ecafb414-7765-4ab4-81ba-08dd0375d1a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 23:57:51.9095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LedxOxnOlHcQHD+0zMdbU1m+DI5c1ntcIQtLCwRgHeBYeIoqhZHzYyBaBPFKJq0Hf1uEpDmsAGJS+LaLLw+EVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7289
X-OriginatorOrg: intel.com

PiA+Pj4+ICsgICBpZiAoIXN0cmNtcChidWYsICJtYm1fbG9jYWxfYnl0ZXMiKSkgew0KPiA+Pj4+
ICsgICAgICAgICAgIGlmIChpc19tYm1fbG9jYWxfZW5hYmxlZCgpKQ0KPiA+Pj4+ICsgICAgICAg
ICAgICAgICAgICAgcmR0Z3JwLT5tYmFfbWJwc19ldmVudCA9IFFPU19MM19NQk1fTE9DQUxfRVZF
TlRfSUQ7DQo+ID4+Pj4gKyAgICAgICAgICAgZWxzZQ0KPiA+Pj4+ICsgICAgICAgICAgICAgICAg
ICAgcmV0ID0gLUVOWElPOw0KPiA+Pj4+ICsgICB9IGVsc2UgaWYgKCFzdHJjbXAoYnVmLCAibWJt
X3RvdGFsX2J5dGVzIikpIHsNCj4gPj4+PiArICAgICAgICAgICBpZiAoaXNfbWJtX3RvdGFsX2Vu
YWJsZWQoKSkNCj4gPj4+PiArICAgICAgICAgICAgICAgICAgIHJkdGdycC0+bWJhX21icHNfZXZl
bnQgPSBRT1NfTDNfTUJNX1RPVEFMX0VWRU5UX0lEOw0KPiA+Pj4NCj4gPj4+DQo+ID4+PiBVc2Vy
IG1heSB0aGluayBlYWNoIHRpbWUgdG9nZ2xpbmcgdGhlIGxvY2FsL3RvdGFsIGV2ZW50IHdpbGwg
ZWZmZWN0IE1CQS4NCj4gPj4+IEFuZCB0aGV5IG1heSBjcmVhdGUgdXNhZ2UgY2FzZSBsaWtlIGZy
ZXF1ZW50bHkgY2hhbmdpbmcgdGhlIGV2ZW50cyB0bw0KPiA+Pj4gbWFpbnRhaW4vYWRqdXN0IGJv
dGggdG90YWwgYW5kIGxvY2FsIHdpdGhpbiBidyBib3VuZGFyeS4NCj4gPj4+DQo+ID4+PiBCdXQg
dG9nZ2xpbmcgbWJhX21icHNfZXZlbnQgZmFzdGVyIHRoYW4gMXNlYyBkb2Vzbid0IGhhdmUgYW55
IGVmZmVjdCBvbg0KPiA+Pj4gTUJBIFNDIGJlY2F1c2UgTUJBIFNDIGlzIGNhbGxlZCBldmVyeSBv
bmUgc2Vjb25kLg0KPiA+Pj4NCj4gPj4+IE1heWJlIG5lZWQgdG8gYWRkIGEgcmF0ZWxpbWl0IG9m
IDEgc2Vjb25kIG9uIGNhbGxpbmcgdGhpcyBmdW5jdGlvbj8gQW5kDQo+ID4+PiBhZGRpbmcgaW5m
byBpbiB0aGUgZG9jdW1lbnQgdGhhdCB0b2dnbGluZyBzcGVlZCBzaG91bGQgYmUgc2xvd2VyIHRo
YW4gMQ0KPiA+Pj4gc2Vjb25kPw0KPiA+Pg0KPiA+PiBUaGUgbGltaXQgd291bGQgbmVlZCB0byBi
ZSBwZXIgY3RybF9tb24gZ3JvdXAsIG5vdCBvbiBjYWxscyB0byB0aGlzIGZ1bmN0aW9uLg0KPiA+
PiBJdCdzIHBlcmZlY3RseSBvayB0byBzd2l0Y2ggbXVsdGlwbGUgZ3JvdXBzIGluIGEgc2hvcnQg
aW50ZXJ2YWwuDQo+ID4NCj4gPiBBZ3JlZS4NCj4gPg0KPiA+Pg0KPiA+PiBJJ20gbm90IHN1cmUg
aG93IHRvIHJhdGUgbGltaXQgaGVyZS4gSSBjb3VsZCBhZGQgYSBkZWxheSBzbyB0aGF0IHRoZSB3
cml0ZSgpDQo+ID4+IGNhbGwgYmxvY2tzIHVudGlsIGVub3VnaCB0aW1lIHBhc3NlcyBiZWZvcmUg
bWFraW5nIHRoZSBjaGFuZ2UuIEJ1dA0KPiA+PiB3aGF0IHNob3VsZCBJIGRvIGlmIGEgdXNlciBz
dWJtaXRzIG1vcmUgd3JpdGVzIHRvIHRoZSBmaWxlPyBRdWV1ZSB0aGVtDQo+ID4+IGFsbCBhbmQg
YXBwbHkgYXQgb25lIHNlY29uZCBpbnRlcnZhbHM/DQo+ID4NCj4gPiBNYXliZSBkZWZpbmUgIm1i
YV9tYnBzX2xhc3RfdGltZSIgaW4gcmR0Z3JvdXAuIFRoZW4NCj4gPg0KPiA+IGlmICh0aW1lX2Jl
Zm9yZShqaWZmaWVzLCByZHRncnAtPm1iYV9tYnBzX2xhc3RfdGltZSArIEhaKSB7DQo+ID4gICAg
IHJkdF9sYXN0X2NtZF9wcmludGYoIlRvbyBmYXN0ICg+MS9zKSBtYmFfTUJwcyBldmVudCBjaGFu
Z2UpXG4iKTsNCj4gPiAgICAgICAgIHJkdGdyb3VwX2tuX3VubG9jayhvZi0+a24pOw0KPiA+ICAg
ICByZXR1cm4gLUVBR0FJTjsNCj4gPiB9DQo+ID4gcmR0Z3JwLT5tYmFfbWJwc19sYXN0X3RpbWUg
PSBqaWZmaWVzOw0KPg0KPiBUaGlzIHNlZW1zIGxpa2UgZW5mb3JjaW5nIGFuIHVubmVjZXNzYXJ5
IGxpbWl0YXRpb24uIEZvciBleGFtcGxlLCB0aGlzIHdvdWxkIG1lYW4NCj4gdGhhdCB1c2VyIHNw
YWNlIG5lZWRzIHRvIHdhaXQgZm9yIGEgc2Vjb25kIHRvIHVuZG8gYSBjaGFuZ2UgdG8gdGhlIG1v
bml0b3JpbmcgZXZlbnQNCj4gaW4gY2FzZSB0aGVyZSB3YXMgYSBtaXN0YWtlLiBUaGlzIHNlZW1z
IGxpa2UgYW4gdW5uZWNlc3NhcnkgcmVzdHJpY3Rpb24gdG8gbWUuDQo+DQo+IEkgYW0gYWxzbyBh
ZnJhaWQgdGhhdCB0aGVyZSBtYXkgYmUgc29tZSBjb3JuZXIgY2FzZXMgd2hlcmUgYSB3cml0ZSB0
byB0aGUgZmlsZSBhbmQNCj4gdGhlIGFjdHVhbCBydW4gb2YgdGhlIG92ZXJmbG93IGhhbmRsZXIg
IChvbiBldmVyeSBkb21haW4pIG1heSBub3QgYmUgZXhhY3RseSBIWiBhcGFydC4NCj4NCj4gQmFu
ZHdpZHRoIGFsbG9jYXRpb24gcmVtYWlucyB0byBiZSBhZGp1c3RlZCBpbiBlaXRoZXIgZGlyZWN0
aW9uIHdpdGggYXQgbW9zdCB0aGUgYmFuZHdpZHRoDQo+IGdyYW51bGFyaXR5LiBBIHVzZXIgYXR0
ZW1wdGluZyB0byB0b2dnbGUgYmFuZHdpZHRoIGV2ZW50IGNhbm5vdCBleHBlY3RpbmcgbGFyZ2UN
Cj4gY2hhbmdlcyBpbiBhbGxvY2F0ZWQgYmFuZHdpZHRoIGV2ZW4gaWYgdGhlIGV2ZW50cyBkaWZm
ZXIgc2lnbmlmaWNhbnRseS4NCj4NCj4gU3VyZWx5IHdlIGNhbiBleHBsb3JlIG1vcmUgaWYgd2Ug
bGVhcm4gYWJvdXQgYSBzcGVjaWZpYyB1c2UgY2FzZS4NCg0KTm90ZSB0aGF0IHRoZSBrZXJuZWwg
Z2VuZXJhbGx5IGRvZXNuJ3QgcHJldmVudCB0aGUgdXNlciBmcm9tIGRvaW5nIGluYW5lIHRoaW5n
cw0KdGhhdCBkbyBub3QgY2F1c2UgZGFtYWdlLiAgRS5nLiBhIHVzZXIgY2FuIGFscmVhZHkgYWJ1
c2UgdGhlIGxlZ2FjeSBtZW1vcnkNCnBlcmNlbnRhZ2UgYmFuZHdpZHRoIGNvbnRyb2xzIHdpdGgN
Cg0Kd2hpbGUgOg0KZG8NCgllY2hvICJNQjowPTEwMDsxPTEwIiA+IHNjaGVtYXRhDQoJc2xlZXAg
MC4xDQoJZWNobyAiTUI6MD0xMDsxPTEwMCIgPiBzY2hlbWF0YQ0KCXNsZWVwIDAuMQ0KZG9uZQ0K
DQpTaW1pbGFyIGFidXNlIG9mIHRoZSBwZXJjZW50YWdlIG1vZGUgaXMgYWxzbyBwb3NzaWJsZS4N
Cg0KPg0KPiA+PiBNYXliZSBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8ganVzdCB0byBhZGQgc29tZSBh
ZGRpdGlvbmFsIHRleHQgdG8gdGhlDQo+ID4+IGRvY3VtZW50YXRpb24gcG9pbnRpbmcgb3V0IHRo
YXQgcmVzY3RybCBvbmx5IGNoZWNrcyBiYW5kd2lkdGggb25jZQ0KPiA+PiBwZXIgc2Vjb25kIHRv
IG1ha2UgdGhyb3R0bGluZyBhZGp1c3RtZW50cy4gU28gY2hhbmdlcyB0byB0aGUgZXZlbnQNCj4g
Pj4gd2lsbCBvbmx5IGhhdmUgZWZmZWN0IGFmdGVyIHNvbWUgc2Vjb25kcyBoYXZlIHBhc3NlZD8N
Cj4gPg0KPiA+DQo+ID4gQWRkIGFkZGl0aW9uYWwgdGV4dCB3b3VsZCBiZSBncmVhdC4NCj4NCj4N
Cj4gQWdyZWVkLg0KDQpXZSBoYWRuJ3QgcHJldmlvdXNseSBkb2N1bWVudGVkIHRoZSByYXRlIGF0
IHdoaWNoIG1iYV9zYyBtZWFzdXJlZCBhbmQgYWRqdXN0ZWQNCnRoZSBtZW1vcnkgYmFuZHdpZHRo
IGFsbG9jYXRpb24gY29udHJvbHMuIE9uY2UgcGVyIHNlY29uZCBpcyBjdXJyZW50bHkgYW4gaW1w
bGVtZW50YXRpb24NCmRldGFpbCB0aGF0IGluIHRoZW9yeSBjb3VsZCBiZSBjaGFuZ2VkIGluIHRo
ZSBmdXR1cmUuDQoNCkknbSByZWx1Y3RhbnQgdG8gY2FydmUgdGhhdCB2YWx1ZSBpbnRvIHRoZSBz
dG9uZSBvZiByZXNjdHJsLnJzdCwgQnV0IHdpdGhvdXQgYSBzcGVjaWZpYw0KdmFsdWUgImRvbid0
IGNoYW5nZSB0aGUgdmFsdWVzIHRvbyByYXBpZGx5IiBpcyBtZWFuaW5nbGVzcy4NCg0KLVRvbnkN
Cg==
