Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EB1200C2
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764717742; cv=fail; b=D7PdsFfKyGon17FtyU5dckk1SKJUR3pkUb7sX/BEju8ygIlcs4RYz5be+TcYB1Cowkxl7dY8oh+bRfp4LNnIvQLqiDeA+7hg+AopkAGwZElQ2fNs31+BWC0L51jBjuobUOmBPz645xD3JUdhFyzt8n7IUHPyRZpYH2/mKuuOT6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764717742; c=relaxed/simple;
	bh=LlZLIMCbAMQr16DUIikweRPo00tDP8dbUmmxhShBhLI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BZBAg40d+z1EjXM0Wy9btvVurR4X8ObcmoJVPrIW0uins+G/OA/vgdgrTJdv8+vjhSimM9GxUHIkvX2KjGRx0795loGNLMpOdMnm11ntpxu3x+C2YcreK6qNKVqZaEDDhwzL4y0d81s6Izhxx1Y6p/LhUWZLgHtR8Ymi0P6pjvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZnuAusXz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZnuAusXz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764717741; x=1796253741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LlZLIMCbAMQr16DUIikweRPo00tDP8dbUmmxhShBhLI=;
  b=ZnuAusXzN/KUe1v4i7/3SAcjXjKCZhNbCg4fSNRrG51f5492Ge2SBk+Q
   q1Bg+gEWmFRl53S+AsX/OaQYSHgyq3n0nHKxxqVweDoYJ4SXpML0ofGuH
   iXiQdRpmX8LlFdW33d8a30MHg4kV+eNI8/P6mBqe3b7NZliRTyKsk0T0s
   SD5nvMTsq1RpO8uPCmErvbXV/u1zUzFZiXWi7zxzcN+2qLp5dXUY3l0Qy
   PMqLmJOWbRf2SX7R8gNdw73k131vjI0vlFjtuqr7hMZF5HTfmIVlIpU55
   FZoRfCk3cSSjCW5ZXe2h2TxAQ95vQMqemazWzNi2xNCaCp+ChzY0Wzfgr
   Q==;
X-CSE-ConnectionGUID: zm4nBDlsTQmiBcKzH3WT+A==
X-CSE-MsgGUID: ymqbOB4DRFuuew4moWrjOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66868082"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66868082"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 15:22:21 -0800
X-CSE-ConnectionGUID: ygaGOOG2RaqJ/rwuJkCujw==
X-CSE-MsgGUID: 5ULiPXRYQ7SfBL1NISPBzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="225461509"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 15:22:20 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 15:22:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 15:22:19 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 15:22:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eZ/WkeZUj1bKwPFI1z3gy5XowGDgAoyXQmtRrrlSCzhnffNk5lxh8gT4qoX0eVeyRXRSNWp9l8sMZSqU1FgcEl78kk7tOiu1uak6fLGst/xl8Cm9xU6M2HzpC4P23iZ64moEht1uYUNvIAGU7WMoNge6PhU+Sirf0N1L/3dYO8vxvuDwR71GFTuhAvNgus5gBMhjDiq+s1wu6x4sDK5QPLtzSXmR9FL9h0bIlRefQgfB2TeZ+qYblRTuz27buLfH7xpEDeGVL4al40ESPYwL5S+JdPuG5FYSZuG8T7bG4fROHwINA5B9U07c/3mZJHJ0ekiVmeAejvW/4o7RCvm0SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlZLIMCbAMQr16DUIikweRPo00tDP8dbUmmxhShBhLI=;
 b=NaABUT9t7fKnw+osYhyz4v4RtGpWTqTBwSKGkeRBF01o+lD72PLARkuGwNLoS3hDhwU+8cDsWrVWP4oKZZ3RfJdErqeZBo6tPGVD0c6u7BHDxLXKI2inl2cRNLPJK/IS2m9Eoav6bHusmpwSexYAJvln6ty/OmF/YjOdO9EoLrYBqMn/T2TvKg/SYuu72+iP/4Or4KX/b/XAcEH1CrYQ96uMEpunwSRSb1hhVXKk012DLA8F2m8Oi3wA7e61lKtYtfVBEvtdMVlzaUfsMRYN1RXO74cFuK6xOAaCnIwQ9Ke+Eja9n3fgnmN4U0jbE7b03vHxlkFNrd/IoPrafd6Qmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB4959.namprd11.prod.outlook.com (2603:10b6:a03:2de::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 23:22:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 23:22:12 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v14 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
Thread-Topic: [PATCH v14 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
Thread-Index: AQHcXXPIfImYh3Thk0eO+UNMym2TbrUOkGqAgABKeQCAAB8iAIAAD7dg
Date: Tue, 2 Dec 2025 23:22:12 +0000
Message-ID: <SJ1PR11MB6083CB1AE9572E62175DAFB9FCD8A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-8-tony.luck@intel.com>
 <895cee86-ac6e-43e7-aece-e283200384ef@intel.com>
 <aS9NEJAnx0MWoyaT@agluck-desk3>
 <ee83f3aa-9d89-4520-98bf-78f371d214b0@intel.com>
In-Reply-To: <ee83f3aa-9d89-4520-98bf-78f371d214b0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB4959:EE_
x-ms-office365-filtering-correlation-id: 925009dd-7e6f-40f5-d81e-08de31f99f72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eWc5WUYvWlhOMHJyWFkrT2kwVU9jMDUrbk5KUkZDV0syOXBuMDRiWUhnWEZz?=
 =?utf-8?B?ekJQWWs4emhIYklkSHN6WUlRanduRUNyMXUxdGtIdjlFcDIzVVN2RGt0SENH?=
 =?utf-8?B?YVE2UUNIaDJLRnlTTzlZMVhGTlE1VUlaTWpqaEo1WGFTWFRSaDlESHA5NXRE?=
 =?utf-8?B?M2VNWWlWRW4yS0xJUVFCam82VkVtcm1qVExsVlRqRmxpZkhrUGEzcXRmbnpH?=
 =?utf-8?B?SVZaTnNaOTl4SnFGVnpxUllzeTVBSW5YZGNiRGZIRDU4S2JLRnZDbGtsRUpt?=
 =?utf-8?B?TU05ZnY2WlFyRTlzQ1FvcW1oZ09PdEgzY2p6L2grYnV6WVRrU2NGVG5ZYXJI?=
 =?utf-8?B?VHlnTy9sTGRiQUZxTUw1Q2JjaEQ3WXlVajRTNmlhODlTV2Z1a2ZacTNDaDVa?=
 =?utf-8?B?SmgxTmZ6VnZjRlpXa3lzZWQ1THNibUJhc2lidDZVamFtaUdoSVg0SG5tK0tF?=
 =?utf-8?B?TGdWV2o4bVc0THIxcUVSWVk1ZEl3UTc3b0tmdjBGOTBnaEpLNlk0eU4zNncw?=
 =?utf-8?B?Y2pzdkV3aWh5alltNzZkazQvWGVoeDFRQ1pSaStTcjYxcDRZcG4yeDZUaDdw?=
 =?utf-8?B?Q1MrQXBIbVV0anBpRzRwWlVXSnZac0VNNnhKY282Yy9YTldBU3RBYVI2akw5?=
 =?utf-8?B?NGhnVDhjdWZJUEIycmVGb256bVhzY0xNSHppMFk0THU0Z2RLaDlaQm11OTBt?=
 =?utf-8?B?U0pYQkZpSmRlWDhNWEp3U2trTnVtSStpSkVUYzg1TUM2QUdPcU1yZnNPTTRh?=
 =?utf-8?B?MXNvbFdvYTlGRVJ3TEJTZ0dVVFpuMTF6RUVtMlhrc2F5ZzRJYnpKeDNXME54?=
 =?utf-8?B?UVpmRUovazJPT2dqZFZaYW53d2RhVEwrOE9XcDB3SDgraC9UQ0NCQWkxOEx6?=
 =?utf-8?B?WXY3T1pjZFBMMkp6dTQrVjVDUjdXcjhDeXU3Q2E3SU1OaDF6UXZNOUgyZGhN?=
 =?utf-8?B?TllwUUV0UStFMENGanJZQVpLTEZLSytNWDRQaTFodWc0VDNacld1djIzZzRJ?=
 =?utf-8?B?THRkTXBIS1JOa2lkTlBrUHlHTEx6c1BlcldjSUp0eTJ1bGhhNnRYaXZJOVFH?=
 =?utf-8?B?MUpSYkVmUkZiNm5wZGk3bDVIcWpoSlpKY1NWVXd0UjJnYW1oMnNkeC9GN1Ba?=
 =?utf-8?B?V3ZVSUtqN0dvRW1CaFR4VzZYaHpqMElqTTNNZVJVTlZqcWNUaklPWWpVaG5D?=
 =?utf-8?B?dU9pbUNJYkdqTWp2aFVDY05yMlpMSnRiVVh3SE8zL0FMbGRCQXUwZTlMcjAy?=
 =?utf-8?B?UWpGWldNOHhMelhWSTN5WkxibU1KajU0ZlJ3cTJTTFByajBNbmVUQko4L3NI?=
 =?utf-8?B?SWNpc2J1STlERFhUN0tTU21EU0pXY0orVlBsZWlQdWIzdjBiU0pFTVRXWVk4?=
 =?utf-8?B?cGJTNkdTMi8yZHN5VUpmNUJ0VEQrMWNDdE5sZGQ4eStUZk1xOGFPS2hpeEx0?=
 =?utf-8?B?bVcveG5pUUJjTzJHNTlYT1ZzclIrK0lzNzdFbmF6RnJTWURNV24rZGJmLytS?=
 =?utf-8?B?WFU0aENDOHJEWTNZcXVWSlBuK0pPTTNGNXUvVWdDSFZoMDhVZXRMZW9VSUli?=
 =?utf-8?B?eUJrK2o1Y1JPZkVMbGVNRmFlUWtsNCtkYWN6SjB2SWt2aTNIRlVjQjQ4MURZ?=
 =?utf-8?B?MG05YUs4R2EvSlo1Vmk1WnFxTmw2U2FsYlp1dGgzQnBTRndlN1doSy83K1RQ?=
 =?utf-8?B?Tm5iTnQ4cG1lZUUwZHJRTTBKK2IwcGRvcGVhVm9UOXFPaE9hWnlJMUhaQ3E4?=
 =?utf-8?B?bldmM3BZQmlDNTJlM3NFaWdTVnZabzdLcjUrRlpmY2ZuQUcwRkEzTVVPdC9P?=
 =?utf-8?B?b3BCcWMrcm4wMTJMT0hHTEcydWZwZWN3MUZvNTdJUUM2TmlWUGJLVWtMVjhT?=
 =?utf-8?B?aGp0NEY5dmVha2QxOVJDVWN5VUtOY2xJQnVaV3czT0tVdEp1NFd2VTU4THVU?=
 =?utf-8?B?eFRIQkhwcHp5dUlsYnNxZVg2MjV3K2hDMjZFK29CMVVVSkk4ZTBUY1lLYlUz?=
 =?utf-8?B?N0ZOUkdxZ1NKZWl6Y3FXWUtpUnJlK0tmZHluOTNNZnR6TEhCblZXOG82RmU1?=
 =?utf-8?Q?ceUkYK?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXVLM3VQODVFRjU4Vzk3VnFDVFNsdFNZTWJhcWNIeCsydi9HS1FDNkc0NE5I?=
 =?utf-8?B?QmdkcGxKUW1id05TQ3BPSTN2NllMYzlMbU9RTjJpckdWeHFsZnhQTUI5V1Z6?=
 =?utf-8?B?TUlMblBIYjdGMVpkOXRyV2hzUG9qZVhCMk9icTUrbHA5VTdHeFpCdzA4ZXRP?=
 =?utf-8?B?aDNLYm9RV1hMc3E0Tm5IaE4xRVRwUXU0RzZ2clRXTjg3c0JzY0dCQis3cEFk?=
 =?utf-8?B?NkdTa1Qrdk1qc1JudGZKSnRPeUwySktxNXpIMXlrTFRJQzVmRUt6YXBkZFNB?=
 =?utf-8?B?eVZrbzRpbTJWZ1EwUHlyc2EyV082Sk5GcmZkRXF2c1UyRFowazRNQnowaFB3?=
 =?utf-8?B?OElxMU82RlpuTlI2WkZkeG5COHBTYkY2TkxMbi9aaWg3Y0lQWFNId0k5SEZL?=
 =?utf-8?B?OUV2KzBFNDhtRXJ1RmZOYjczb3pLTFJlbGdtMFlReklQMC9sOTk1SFN3NnVI?=
 =?utf-8?B?Vy8wd1ZaSVhZUnRmeFhJdG9GTnM1NFNHN0l5emVIZUprdDdkNE84K2k1bDhM?=
 =?utf-8?B?cUhXVW54YlNsYzZxL3ZIcmhCMXRtRHROdG9SOU9ZZkZITDRQWk9zVmVtZnA1?=
 =?utf-8?B?Sm1MZ0tRVW1QVWk0M2FtMDBianVGRlMyR09Pa3BmaFNpZm9neEZieGVNYmhv?=
 =?utf-8?B?ejM3Y3ZTcG9wVmlnUmZ6Tm55cE5SR0FjNU8ybXVLOEpNNElPQWxRMFloc3FF?=
 =?utf-8?B?Q0xiNGFERFI1dHhNWnJ3Z3EvdGZhY0FvVlJ4ei8yd29uYU1qR1A0VEZWL2pn?=
 =?utf-8?B?WDhESDllVFZOdFc0S1NiZG5mUGlRZkZLUlRGMTR6WUtVVUlBRmRPNHc3Y3FB?=
 =?utf-8?B?Y1BHdE5YTzErR2xkYXFKSDJvRTFTa1htNzBHaTI0REUxSisvRnd0R2lRSUVE?=
 =?utf-8?B?SStrRlltblBvNkZrdk14Wlh5TUdiUkJ6VXVROWVjWVFsVGF6MmF1ODZWM1pT?=
 =?utf-8?B?WndtWUFrR0VOOGh1NC8wU2M0YkxSVzRlOG45T0lEUmJRTzRSVlhGa3d2enRj?=
 =?utf-8?B?Y0VyZS9kaU8xSUJ4aE55SzhlNlhsd1J4cS92QVFzV2s3ZEp2Nk9FOTJoTUxS?=
 =?utf-8?B?UlBBMzdiKzBNT2dVekZvWkpUTmlxamlSNUJwQURSZ0RaT25ndGUySmlMTzFs?=
 =?utf-8?B?SzA5UGwreGpaTzVMNmlERG16QVlxSUlZVjVwYXc3SDRkY3RTTnhuUG83ci9S?=
 =?utf-8?B?ZEt2VmkweGhlQlB6bjcybnNLdzY4aE5nRlBTYXFxWHNjMEFCajVoTElVbjZr?=
 =?utf-8?B?QUR0ZHB1eC9wSTJuWHpNaENTcTU1T0tDdE1Pc214bWJPem56YmcxVEwrdGFu?=
 =?utf-8?B?UG55RWFPM2xCbjQ1NTVoeG9qMDRXeXBSZi93b2pONnVqOW9va2s0RGhzZ0M3?=
 =?utf-8?B?elVnVnhXemxKYTM0cnRGNGZ3NVg4WTl2Mmdwc1hTYkxsblQzcmIzREVUdlFE?=
 =?utf-8?B?bXRNdjlabE1pRG40VG1reWpNWFllbFIxS282TUFSaTdWdCt1TFkxZFJTSTgz?=
 =?utf-8?B?ZXh6NWREalRncmtBRmtaSzg4SFJkNUp6eTlvaXFTOTBZN1RFL00yQ1FHd2hT?=
 =?utf-8?B?czJSayt2cExVZzZNdmY3RitUcjRsWUFpbG0rOVM1RVZjQURxZUtTcCtzWFNn?=
 =?utf-8?B?RzBDS1g5VWk0TXVLeThxUEhZVFhHQzV0YUxiUkdFOEJBVmNGdmJCRVFaNVpB?=
 =?utf-8?B?aGV2VVRJNnU5SDNYUTk5YUVUMEthOFlJNU5KaXYveGtLalR5dmFGcUdCWnNP?=
 =?utf-8?B?dm9PRkt2ekd5VUtyOXdhbUQ1cG9GTC9GcXd3TlhsM2NWL2JiVFZRZ1pwYi9G?=
 =?utf-8?B?ZVJVYTFGRkRQQ0tVbHpkd3B0NW0rNU5MbTFEM1k0Wk1Db1FjQUVaY25McFE1?=
 =?utf-8?B?dzZEbjZ5VWxqTzQ0UjVseGdZbkdXQ240UGtwREIzU1p6M1d4UTNkM0IxcEpM?=
 =?utf-8?B?ZDNKVDA0MXVHdk9NN1RyVkFBblhyeGZON2drVmg2S3pOWlhPK3prN3FIWlZi?=
 =?utf-8?B?bVlzOHpVVlVMcjhGTDBhbktNK21xc0F0RzdLcmh3aXJZbnNLZDQrY2IybGMr?=
 =?utf-8?B?WVJ5VmlrYTRaaHduVUF1bTNGSDIxZVVUZHhSNWVrZWFLeU9kS0JwRXJrR1hv?=
 =?utf-8?Q?AAuiobBKOwO83OdlSWE8cpGGi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 925009dd-7e6f-40f5-d81e-08de31f99f72
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2025 23:22:12.4367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SaWyJcBgfURXL2GJzXB4Ujhipm+AMd2vPI4QhlhfBM2+n3CTIZYm+qflNfMM6nUhiMY/pzNSgAxxLMA+YHjJJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4959
X-OriginatorOrg: intel.com

PiBUaGFuayB5b3UuIE9uIGEgaGlnaCBsZXZlbCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUuIEkgYW0g
Y29uY2VybmVkIGFib3V0IHRoZSBhcmNoaXRlY3R1cmUNCj4gIlNOQyIgdGVybSBjcmVlcGluZyBk
ZWVwZXIgaW50byBmcyBjb2RlIHdoZW4gaXQgKHRoZSBmcykgYWltcyB0byBnZW5lcmFsaXplIGl0
IGFzDQo+ICJzdW1taW5nIGRvbWFpbnMiLiBNZW50aW9uaW5nIFNOQyBpbiB0aGUgY29tbWVudCBt
YXkgYmUgdXNlZnVsIHRob3VnaCBzaW5jZSBpdA0KPiBoZWxwcyB0byB1bmRlcnN0YW5kIHdoYXQg
aXMgZ29pbmcgb24gYnkgYmVpbmcgc3BlY2lmaWMuDQo+IEFzIGEgbml0IGNvdWxkIHRoZSB1c2Vy
IHNwYWNlIG1lc3NhZ2Ugbm90IHJlZmVyIHRvIFNOQyB0aG91Z2g/IEhvdyBhYm91dCBzb21ldGhp
bmcgbGlrZToNCj4gIlN1bW1pbmcgZG9tYWlucyB1c2luZyBhc3NpZ25hYmxlIGNvdW50ZXJzIGlz
IG5vdCBzdXBwb3J0ZWQuIg0KDQpUaGF0IGxvb2tzIGdvb2QuIEknbGwgdXNlIHRoYXQuDQoNClRo
YW5rcw0KDQotVG9ueQ0K
