Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88932176FA3
	for <patches@lists.linux.dev>; Sat,  8 Jun 2024 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717853258; cv=fail; b=IDZDiBCJYntdre8mPwoWJ9ApaZF0oQ0ES2K0jqTAty9D2WXLjBF8Ki+qAJucLerPiUcDt0plUbRJ6gBEVOW8EUZTJ6ZdjnT7mQpLVVAF8HdnOFEkUt10l8jOig4CIIbeVcVSFcw783/OfIawYd3uZ39vKKLD0LM9pKYQLmMUa2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717853258; c=relaxed/simple;
	bh=I8fLBdvGncd//q9PfXRv1DJoFcK38RviJKGu7HFXMlY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=krhC0bvSozrTj6HZPVG6DbmvL7ykkE+xOaKEHA8/SKHMj0y34AsDQo20dlGzbY/YDOD25TR51Lyj4jjVCwn9qmO9Xch9YVlr0/T1fbq2jxW/laYoi8K3oBxRgFMGPL8ikKJcIF5n+ffK07mQGQAemlR0vkgmlrD1fr/I0ZImutU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cy+WuSO7; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cy+WuSO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717853255; x=1749389255;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I8fLBdvGncd//q9PfXRv1DJoFcK38RviJKGu7HFXMlY=;
  b=cy+WuSO7m1BGC5ouJg2RpYQwBqdIbqGnpFsZT+IGF2Spp1Pki+XJzFUg
   hRChY6QAWfQNKvLDeYMh43eqv9N6lYTgulPfTw3HDDwOdQtDXPsK8A+tq
   KIps80Uw2wYXoQIKbRDii0HJTQ1WOAcyPZ9YtA0qjNd3FMBeAGsfgzFBb
   MpMuvEx5cTLvlwOX7mv5H5PJxb3/FR1FSVXD+jyFLhtimQaQdXgnfu//5
   KUuUMilCgh9hj2kBk+AiGvDjKmKK5Pe2aeF1MdTaIxRayn25sMFDXig4q
   Hl6Cnmyl2g1LNSZ1jWaMIDWSh/UK1Et3nxuA+Pj0SASttzdhfdJTNwx2H
   Q==;
X-CSE-ConnectionGUID: rLaXO0nTSjKO+h+W6YP5Hg==
X-CSE-MsgGUID: n0Cuw68tQbixxA9Ozdd85Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11097"; a="14805649"
X-IronPort-AV: E=Sophos;i="6.08,223,1712646000"; 
   d="scan'208";a="14805649"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2024 06:27:35 -0700
X-CSE-ConnectionGUID: 0b2qX6LjT3eWWL5sUaSQ1g==
X-CSE-MsgGUID: BNyWGND+R4CFb+mSgo1dzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,223,1712646000"; 
   d="scan'208";a="43032708"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jun 2024 06:27:35 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 8 Jun 2024 06:27:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 8 Jun 2024 06:27:34 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 8 Jun 2024 06:27:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzsHQC1ULC/G3IpXXF+IFj2NZtztYuJbrqagz+R3sBgwCkIj4brhX2xCcfYucI4uA6WLbTM+5kTr26CNFBNQlqPGmp6/vMCOk4jKzeKw7bBRbEjobloTLLwgnfiNCr4l88oJF0abF+k7aTpuCB6LxE1HBGhRJJ4UFiouCgAl7b8q9bYVOMBu607nhEO7dqY4MgEpWBu2QhDO+/eL2l/4nkK+EbfKRBQeM9W6RLUcA2xjCb1kdE4i8fJiMN5va8NKaqTmoUo7a0kz93o+24M5e8OhutnXPaWF0ky7DpliXKHxAPI0RTj29CcLMqGXhGo5V6dwuftLA8BH5R3//Qk9qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8fLBdvGncd//q9PfXRv1DJoFcK38RviJKGu7HFXMlY=;
 b=QYLHotpiQ33whNqBfruJDFAYn/BapMOmF6/7wjdDvytaVAnYqAM+STX59V1p+5c23Bg1A+0kyKdPJ8pOiGy1BwdiWXzkIu0Lw0Bsse8xNtVRyZqHoMd0Cy0B4+jRPuRE94wHsluKIjyncltlt9HpEoQBvca+MrXbHEAfJTYigJXSPgeRypUGVt48WAX56MUkE7WAFuyyzVz2rZ84vWYBw1zHJ5ABj6zFNfb/ljwyAeiNVbUplPcHO9LNl85OQ/PiKOK7LPhI8yF12D3tr9eZ2q8DaYB5EypB8nOviPmPZJ4mhALWmMRznLWqw8TzqzBfw6J4cxhtN2Yh/ZBTgcg2PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB6843.namprd11.prod.outlook.com (2603:10b6:930:60::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Sat, 8 Jun
 2024 13:27:30 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7633.036; Sat, 8 Jun 2024
 13:27:30 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Thread-Topic: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Thread-Index: AQHauDBdYeGsvVFf40e5nFEfBMSU4rG7FovAgAANIfCAAqYcgIAAEi8Q
Date: Sat, 8 Jun 2024 13:27:30 +0000
Message-ID: <SJ1PR11MB6083ED84B69CABBBD3ED9605FCC42@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240606164047.318378-1-tony.luck@intel.com>
 <20240606164047.318378-2-tony.luck@intel.com>
 <SJ1PR11MB60830475F52F359E116B2274FCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SJ1PR11MB608331168096BFEBBB311EDCFCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20240608121207.GEZmRKl3uwP9Bfrx8D@fat_crate.local>
In-Reply-To: <20240608121207.GEZmRKl3uwP9Bfrx8D@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CY8PR11MB6843:EE_
x-ms-office365-filtering-correlation-id: 3a915690-78d6-48a2-b3da-08dc87bebf5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?OUFkQ1RhYm9VNlU5NDg2TkhZTFVsajdqVzJpNDJCdG5oNW5JbFlOb3ZoRHNG?=
 =?utf-8?B?d3laWk9kZU5MME9FeFlGNzM2NmVueVVhVkxKN2QvTzU5RzNYekNOR1AwQXd3?=
 =?utf-8?B?WEdKcitpc0c5UVRkMXpKRDZHa2FkaStqVzVxYitZUEkvb0c4N2wydVdnT1pZ?=
 =?utf-8?B?TmpXQjBZNC9yaWN1bkZPSlRwNUpuUTlqMk5MM0M5VUQ4WmZ3SklvbG51QVJY?=
 =?utf-8?B?eWNoSlVXemZzcHlmUHJTTkRsQUhIYjZyK3pvaHk0RWoyVzBwbjlYbXE3UjhT?=
 =?utf-8?B?bTFwajU1NDlRemVQRk1TWkc4NWt0L2N5MXM3bkM5OHhzR2V2aXF1Z01hVVNv?=
 =?utf-8?B?QkVsVUtlZnBzalJqMkFrTncwY2o5WEx6b1RHR0xtaXFIQmVXVENxRXBIdm81?=
 =?utf-8?B?Z0F0QUpVRjNtOWJ2ZHpYRHdyWGk0anAwWjkxYVg1RmpoVkpZLzhWRHROblRq?=
 =?utf-8?B?ZC9rQWttWXdvZmp2akxUa0xORUMraWJrUTRkTTJiOWY0RjVjMFBLZkVSdFhx?=
 =?utf-8?B?ZGY3ZURIM3I3cnMwVUFDbUN5STNWZWJhMDJKOUdYNUxJMFR4SWZ3VUlIS2hP?=
 =?utf-8?B?NmV1ZDlrbTdNUnVlek1Ob3g0TEY0b0tpVGhqT0hoSEVUZXJYVm5FaHJMU0Nk?=
 =?utf-8?B?Z1Fzd0xpaElsV24rUXVCZERRRUYzSFFpcGlxYm1CNWxLTHIyblozMy9lT2NL?=
 =?utf-8?B?SVB3aWpYSU9NV2c1Z3Y1TXVoSnAxaWRxMVBKNUVrZ0s4QjYya3R6OHFBWlo2?=
 =?utf-8?B?U0Q5WmN3R0U4bzJwYnVVZG5yeFphMlcvZ256MFU5cm80RTUzS21zL0FhcDRQ?=
 =?utf-8?B?M256alV2Ris1cUtkSk5PZjJHYmNPWFAvb1BXVzczVUNxa21iMHpWUzc4RDNU?=
 =?utf-8?B?OUNEejFNcGJ5WUlmMHF2V0tkanRtUDFMU3NDSXlCRFZZM2FwclBmc2ppUWZv?=
 =?utf-8?B?VUZBSnNnNTJYYUJXQVRhWjZxVjdQQUh5OC94WUFtcm9oQlRiRnlCRmN4ckJs?=
 =?utf-8?B?K1BlUFMzSWl3RVBiMGFMeGtsYWUzNXc4OVhzMW1Ud21scEJJYXpVMW16SjRD?=
 =?utf-8?B?Mng5KzVleHdncFZZVThNWGFlWkVBSDNPV0NXUVRJL2hPdTNpakpZc20yUEJL?=
 =?utf-8?B?RGpoakNrRnk4ak1CVEp4VHpQeXhaNDhuZW5vZ1I1SldGZGU2eEtMcWljbVVT?=
 =?utf-8?B?azhQSGJYa0EyTFlWUUJRU3pWL3VQOEwrVUFoYzNiYXdwV3VxSHZucWM2TEFQ?=
 =?utf-8?B?RDJoVGVINllnblV6V0hUdWlMZG5Fdmc1M29mcTR4c2d5LzI4SEV5Y2hFUVNU?=
 =?utf-8?B?d2xhUnA2QjNVWER6T1RUbVhYUUxVV0JrMVRMNm1lSnpiazA1L1FQbkl4c1VZ?=
 =?utf-8?B?cE9BZkllOXlndGQ1eC8rd2JDRmhhN3BRQVJDUHJROGgzb1hPSHA0Z3lrdkpm?=
 =?utf-8?B?ajdlYkJYa0RUdmhxWWQ3eUFvZGIzMjg5YVhCM1E3WG5aUnFZMEVKbTdsbHRV?=
 =?utf-8?B?cG1BZHhORGRtaGZYZm5sOHlLa21FQldpWnhmV1RZMWYvZFJCZjJtQnJSNk1U?=
 =?utf-8?B?bkFpZ1VNcVN4bnBoUDZuZkFoVWFDRWhvWUUvaExFTm5oRUZUZ1h4VUdVQU4z?=
 =?utf-8?B?d3pJNVNiOGRFOWVsSjVrZDJqS25qL0ZOaGpZVzBpNXNYZG94MFNGNWVtQWNs?=
 =?utf-8?B?THhFdU1CbmVYN3M1cnhjMHVZS3QxZ3ZSNThVVFBFNkY1REUwbFhiQnhEcDdH?=
 =?utf-8?B?OXdCZUZKTGZKOEM4UjhHenRJWk9ZLzMrZEJpWmZ5NkxDT3VxUnRKcXBxVTR5?=
 =?utf-8?Q?CiS43Rc7O3qRdPf/0EVfEAyPLHfTBC7nER3yE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3N5SVdmZGlOb3lXSmhvK3YwVklUSGorQWVUOUZSV0JFL3N3cm13dXFZNFdr?=
 =?utf-8?B?TkJ2cmlDejdDV2tBbllvMmNqNzF5bHpsYmNvSGIwTVAzQ1ZVWU9XdzcwcXBo?=
 =?utf-8?B?cWRTZ2R0ekRPQ2hHdDhCSGFhSkl5Tmd6ZmJtSXkvZU5SSit1QWptRmQvRnpp?=
 =?utf-8?B?djc5Uzk5cXA4MVdObC9FUXlkRlNrYlVEbUE0SWZoVDQxRUdxME5lWUExOUxm?=
 =?utf-8?B?RmxmcFNaZkxidHhqUmY2Y3p0dWZUTlhoN2g4bU5TVTM3Q3ErRmY5S1kxTksw?=
 =?utf-8?B?S1UxVU8vNnRDYi9wbVpuN0xLcU5WRGJDVVpSVFpNdll6Ty9mWTN4M1BrL2NM?=
 =?utf-8?B?bU9XWnNXWWhtaExPVEM0WDFVVmJBZ3Z5cDkvV1IwQVNUNjYwQXpZY0traUV5?=
 =?utf-8?B?c3JsdGx1UlljNnRUL01EUGhwOTI5K0ZSOUZBYmRhRlBwQVhWUUZ1WjFwRm5z?=
 =?utf-8?B?QVYxa3VKRXVMNitjMEFQSjVJeGJOZnV3MXpUeXd3RU1ldjRoV1RwaC90dEd5?=
 =?utf-8?B?c2NMa0ZsVWpZQWhIa09RU0tqMGFVWjAxWW5wWWtKSXAvK0wrYWRHTTV4STdG?=
 =?utf-8?B?VjkrZkVRcjBRdjFwMzFMUXZ5TzJyd0I2NURMTWtDU2VaUDJJa0E0SExxcksx?=
 =?utf-8?B?R3BXSW1Ca3BjVGZ3V2pBRytJWjFYa1VBSUVkT1luTnEzNW1iYlpDVTR6emM5?=
 =?utf-8?B?QVh0ZzJxUXRhaDdKMzdCbU5paVJPVjZ2VTFFenpnejJRSkZZcDBPek5sY0lI?=
 =?utf-8?B?eFFub2g3eGJ6SVFiemhxNlZaZER4M29jZFN3NUZjRkkxZSsvRTVXUkEvWXRJ?=
 =?utf-8?B?M3RDdlovWWtNdTlES0h6QmpqUUVJMUZKRjM0b1k1NG1ON2t3d09kNDZ6WlQ5?=
 =?utf-8?B?MzM3L3JpdWFiaDVTdk5uRHZ1Ym54K1BIRng2V1BrM0lUQ2U0aHRKT21EQTRC?=
 =?utf-8?B?eS8wODZibWdyMlZyZkNIV2Z5aWFyWmRGUUxvV2lIYTVySWNVbHdoRnVhbnBO?=
 =?utf-8?B?WHhhNVB0RHZ4NERQV2dzMCt6SmZBa0Jxb2dNS05TMy9rSE9uTG9LNjFDSS9q?=
 =?utf-8?B?aTYwUTdjblZMRnkvRWpodkc2OVdqR2w4T0dqeGxyNnpYTEdoWGxJUDFxQzI5?=
 =?utf-8?B?aHhFSnlFeHBubmRGaE1hVk15K3dvYmExVkpUS1BBQkhTZEozOGY4NEU0b2lt?=
 =?utf-8?B?UFFOY1BXN2xEMXpiRGdFOGd5SG02dEdaSHN3NlBwODR3eExQQ0JXZ0s2RUNT?=
 =?utf-8?B?OEJweS9XQnR5elMvZUdBUnNIYzJOQ1d3T00ydkNSbXJIcHhUdW80NFlFK2No?=
 =?utf-8?B?SGFPMGJWcE5kVHM1WktBM0xkcGd1OGpiUERScy9TM05xQkNwb0ZrRGNSK09D?=
 =?utf-8?B?RGFINDRXMFpQNzZVMi8xL0lvNVM1K1IrazVQdG9tZ2lJUzA4SDZ1S0JPd201?=
 =?utf-8?B?aW5waENaMFlHSHdjWVVZcWZYWjRQY0d1UWxBL3lqb0NNTStTWjBQVm9Tai9X?=
 =?utf-8?B?ZFI3eGY3MkpWRjhlelB2Z2ZDUUZHMEEzWTZoTmNhTnl6WkZtbFM1S1k2UVVR?=
 =?utf-8?B?MzhQUmRwczN4QitTMmYvRWxJOGE1cVUyM3RDZ0ZWakVlbjhmY2JhbXA2THdO?=
 =?utf-8?B?VFExTVZDVnpUOFczbmNWd0xxYzlrdGtxTS9zVWxpL0pJUnN5c3V0WXl5V3dO?=
 =?utf-8?B?TjRvREZ4TWczN0lUY0ZJT0tRVkttU1ZBUElJNTF3SDd5ajIzWGdZdWJVK2dk?=
 =?utf-8?B?RFhVQW9LZHNSUnc0UXdNTGJ1bGVzM1IzTm9sZmhINlhzRkdMQmg2YUVqWEpy?=
 =?utf-8?B?QkppcHd4MlI4R0xkQWcyeDJObi82V1lkZG04V1FBeTQ3RzFYeXlUdTAzNTFD?=
 =?utf-8?B?SFRoTENRN0VQeklTRTNQQWxLWXVRbmMwaG5uNmMzZWt6Q0RKYlZXeGhQbVVo?=
 =?utf-8?B?NHBvSkhjV24vVWRqSXZkaUxxSWExVUV1bmEwaE5weGxQdDE0UDlNRFRMK3R3?=
 =?utf-8?B?cWJrV1o1cjJIdXE0NFdCVDVVTGxFdCszZElyZG5reFpLYnBTVWFvSTdhUE1S?=
 =?utf-8?B?SWVRYXlLN1A0aTI4ZFBDOElXZG5pTGhiK29xcFlFRFlOaFdqY0VxVDliNHVv?=
 =?utf-8?Q?/AhJLwXt1yHwNEccYvpiQlGpQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a915690-78d6-48a2-b3da-08dc87bebf5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2024 13:27:30.3728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NxexUMbRLDYU3j8rjwaP7nibTiIFixEMkiBgeq8M5NFtN0Nrt8Yc5lYU2t5CNw+0F3JXrN7ceLSO/nHH3f0k8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6843
X-OriginatorOrg: intel.com

PiBBbmQgeWVhaCwgdGhpcyBpcyBhbiBhYm9taW5hdGlvbi4NCj4NCj4+IEhvdyBtdWNoIGRvIHlv
dSAqUkVBTExZKiB3YW50IHRoYXQgbG9ja2RlcF9hc3NlcnRfY3B1c19oZWxkKCkgdG8gYmUgaW4g
PGxpbnV4L2NhY2hlaW5mby5oPg0KPg0KPiBJZiB3ZSBoYWQgYW4gZWFzeSBmaXggc3VyZSBidXQg
dGhpcyByZWFsbHkgaXMgYSBuaWdodG1hcmUgYWZ0ZXIgdHJ5aW5nDQo+IGl0IGEgYml0IGhlcmUg
dG9vLg0KDQpJIHRyaWVkIHNvbWV0aGluZyB0b28uIEkgbW92ZWQgdGhlIGNwdSBob3RwbHVnIGxv
Y2sgYml0cyBvdXQgb2YgPGxpbnV4L2NwdS5oPg0KaW50byB0aGVpciBvd24gZmlsZSA8bGludXgv
Y3B1aHBsb2NrLmg+LiBNYWRlIGNwdS5oIGluY2x1ZGUgdGhpcyBuZXcgZmlsZSB0bw0Ka2VlcCB0
aGluZ3MgdGhlIHNhbWUgZm9yIGFueXRoaW5nIHRoYXQgaW5jbHVkZXMgY3B1LmguDQoNCkluIHRo
ZSBjaGFuZ2UgdG8gY2FjaGVpbmZvLmggSSBqdXN0IGluY2x1ZGUgdGhlIG5ldyBjcHVocGxvY2su
aCBhcyBhbGwNCml0IG5lZWRzIGlzIHRoZSBsb2NrZGVwX2Fzc2VydF9jcHVzX2hlbGQoKSBkZWNs
YXJhdGlvbi4NCg0KSSBoYXZlbid0IGhlYXJkIGJhY2sgZnJvbSBsa3AgeWV0IC4uLiBidXQgaXQg
bWF5IGJlIHByb21pc2luZy4gQ29kZQ0KaXMgdGhlIHRvcCB0aHJlZSBjb21taXRzIGluOg0KDQpn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYWVnbC9saW51eC5n
aXQgZ2V0X2NwdV9jYWNoZWluZm9fbGV2ZWwNCg0KDQpEb2VzIHRoaXMgbG9vayBsaWtlIGFuIE9L
IGRpcmVjdGlvbj8NCg0KQW55IGJldHRlciBuYW1lIGZvciB0aGUgbmV3IGhlYWRlcj8NCg0KV2hp
bGUgSSdtIG1vdmluZyB0aG9zZSBkZWNsYXJhdGlvbnMsIHNob3VsZCBJIHphcCB0aGUgImV4dGVy
biAiIGZyb20gdGhlDQpmdW5jdGlvbiBvbmVzIHRvIG1hdGNoIGN1cnJlbnQgZmFzaGlvbiBmb3Ig
dGhpcyAoY2hlY2twYXRjaCBiYXJmcyBhbGwgb3Zlcg0KdGhlbSk/DQoNCi1Ub255DQo=
