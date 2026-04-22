Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171F3352FA5
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 22:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776897864; cv=fail; b=OrARwyNVkukpvYmAcwl131Gx8Qprh3QzP0KgIvTb9aFyD2Qck9a3sYaYZCHyq1uYeQaukXtf2ymdyH0VkOmAQ0S6WyEBqth88WqVdwAloLhXAxyVLcnrrYDBBIv2lS64SojQ3ZqCf3ovyo1BOjOpizXS5gosOohl70jcX/Sy4cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776897864; c=relaxed/simple;
	bh=mgwHZj3MoWHFICUXGgscXd+66qedwV6FAACVZh17X6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nCbiEPHBnlG58TX+dVdzcdbU9hO5HvajF5yXK+eTU6Q02KCQKkWcHCQWzhySHyWMIZOfcdTQXVYuP0gN/bx4h2h1RS/QV1iBokaUSLdC4uQ1D0gg0or1SvdAA4JCIYAe+SrKJ/sEkilyyQNUC45dVa8HKzozX664rkLdLxpAyEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VyjvLofX; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VyjvLofX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776897862; x=1808433862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mgwHZj3MoWHFICUXGgscXd+66qedwV6FAACVZh17X6c=;
  b=VyjvLofXl9I7c8rCeiGVPhqWA2SFShDcx1lsdPWxrczbYUp+NZUhFVew
   QT3MWynITSSr3GvKgkVf/xj6hd80pqMEbNHBF4YxoPhHSAj/eyjaDK4sM
   4iKRZHAAFjL+fxCq2VyZldKLorEyllixXiLFbmd2Feh6EJjIoFO6hEyyc
   rrvrpLHkKEixiCzF7J1xW8KG1/oIAp0H8dNf6it+BYY5POBHmPL3UhZAw
   X8BD6zov6cwJ3HaY8vinTtQH89lsmUPu+emzyNaarW9z+PUJYQyJo4bpW
   TnR4DwY6I7gB/G1Qd72PoaL9TdMM9QxtZwvRalj7i46xeiFhZZUwpQyY4
   g==;
X-CSE-ConnectionGUID: shUVpZMISiaL8TjxBRD3wQ==
X-CSE-MsgGUID: 5VPKTJdGS0iUNpaVAiNTtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="77027048"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="77027048"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 15:44:21 -0700
X-CSE-ConnectionGUID: +VqSFznqS2epvR+HMCfQEg==
X-CSE-MsgGUID: zh7sAWskTyezI8thSqF67g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="229815345"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 15:44:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 15:44:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 15:44:20 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.62) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 15:44:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iy1u2eS5J5IJ8T9FjJVTrDhAVl9eNqZ/qTZy4cOigXkEFXafxhJoVRufc4peg7i5DbrOlvIfWF9YfMD6BejVkPH5vcXzhhIdKYjT6OgxNHYyOkrgRn8FN8vtsg+SXPrpqYGx7awy7hxN4gd8Mv0B3Rf+44a/X8x3XUfOV2ofzmB7vxHkWifkof6V1hTGbrdCK3V2dN3Ow27IH26V3MhygzV4VD56NrB4hcNiZzsnf3sQMopKYCh2/kS5geYIqHNKmvj3SvqesvEhgKcqVEoVztlIg78Rzntjv57jnEfMYqZzDOQdtegpq7eh805uvnGx2qHq0AriceJ1wWCB3J93Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgwHZj3MoWHFICUXGgscXd+66qedwV6FAACVZh17X6c=;
 b=Kl2L8c7qoiFsi2auhIjP2wz2PD/D8d1g8YhPDiKZf5u5nsGXzSLUGANtCxD72QBxHFV+deAbjZW3S7jbHT3cSILYdSMmgnSWQx9jannA+gqNboC7ULTqV2llk1ogC0SvPD63Bg22+OYCsYuAEnXo3kalo6wy6vQC1jz+mJILXUvDIGtI6/s3V4ZVmhMo14fGAUB0R9tHrxxKxFuO7qVfvIUi9KxVczwxtkjzSvrGI46B1fRjo9ln8WpSgHJNYc/xggcuq38qW5iyQsoSIxB4SbZP+TDvxYakMKlao8/VCFcLvXLBlm0zPMvVj6XufADkpWgUtVsyn+Cdbdxj/vhkew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 22:44:18 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 22:44:17 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Thread-Topic: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Thread-Index: AQHcwI5HlovBdt4MTkK5Ga90lG495bXOGYQAgARvGACAAAugAIAEq10AgAE5ZgCAAD4VAIAAJ9SAgBE53wCAAaP7AIAABvfAgAAE9oCAAAbRwA==
Date: Wed, 22 Apr 2026 22:44:17 +0000
Message-ID: <SJ1PR11MB608330351CC00D65341CF6F0FC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
 <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
In-Reply-To: <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6467:EE_
x-ms-office365-filtering-correlation-id: 0566520f-a7c2-4fcf-d6a7-08dea0c0afd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info: 1/DncOy0zTPU73P3VO9GJe1g91q1PQsLxi+apXZK0U/tdynlkFtPy0JTe3itmyUdWHY5chO0vSe+X55QjCkPxYlcpjLTVfqFONNA6v0r0OyTc1Lbp2aeDCBrnpKzXGAphIdjxXu8qa7G27eSZliY/yvVP0tMecLfW7r+b+faExMY8o+qM75sPy2N+Uh8y5Wy+Y7b8JEbUCnrejb+40pT/ecu5fQy9qYbnSzOCsFCUscP34nw33cq4T4MMnEm/VuToikrz5aQ39JrQt6RuEX6y+30N/927h6ii/YlxDHyrtu/IYvIHRy1/qTkYu0mmmg3lf/U7HEqpKdfyLGYyzdfIPGkTYd3HS9lEDOBa0/nMYn4h28Ytk9bs6KmMpwJ2/kiVVfUUKaHDM0C8a+wPBpuEXbk9cyTNCEA11c5vP6HTqprPpopOhN5wFcBn2UxKI6dUbjh/cs5WB7xDZ43OggCvT+veo97wDVoF/GZxVzNCqVR9n0iScjjLhCRCCv0oMRq0QCuJHkMLR4+VQr7cPjnhZN0AigSUrcMl1w2UoOeFgqu1DnK3kboMmF8HubzQ8Zjhtt7vn2+9Q1NlSggEcjvJQIm0xzaQ2bVFSqYYmGM+fDSakE1dvk8oracwRM4pg9B/Nby+rcVEzQqbb9hmwjRfNu60ug7eM2EPCAZ4CY4SPQPPM0A0e/Dp85u1cf02H4o33AjsbfpYaOwNUJVlb6CaMeFjaG3/V2gO0ZonwmWcggnLYtXxkCI2SR6mby8aICwVZ9es4PqL6/YLgvS75cgM3XfFnswGzJe9GEs02fW+W4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVl4Y0R1Qm1GQytJdjNqYlp2MWsxbEluL1pEWWg3WVRRQzVNVEN6SEtTZm9i?=
 =?utf-8?B?blZVVW9kZCt6cHFDUkRRcUl2WkRySlB3MVNOSzFzRE5uN2w4ZEp0Vml6K3VM?=
 =?utf-8?B?VHBYL2grVmJCK3BQa0FBVU9MS1BITy9mOWFHVVhPYmR2OFNUbStjSjRGT0Fi?=
 =?utf-8?B?N25xckJXbmtHOWJzQXA4K2M0aU5TeC9rYndJRGRkd2FpbkJ4NHY2WjBUVXBs?=
 =?utf-8?B?MUt5N2c0aS8rdnFCb3pURlJFZEo0RzdXcmJlZWtPSTVTVXZWdFBEL0Q3WW9R?=
 =?utf-8?B?MUJhNFlObjV6a2pHQWxvL0xDRS91QlRXWDQ0SmpNUWdKeFo2aXN2aUNmSDhX?=
 =?utf-8?B?YndYUVRaRTNzWThKU0FidGNwSWRYemZYQXR3L0JOYnRTYXRzSlQ1SThNSHBm?=
 =?utf-8?B?N3YySzBUOEhtOXcyczV6NExxdjNRWmFjSFZZMUc1aGlvSEdFeTBGNUpHNDVp?=
 =?utf-8?B?dDNpYm1SSU00OXB5b3hZMXFBYTY0akdOUTNWdFdtRTRYWFg2VWFTbklYUVRi?=
 =?utf-8?B?VmVCZ25DTDI0MGV3Mi9aN2ZCd1FWS01ZZjloS0xKajEzNUhtdE5PMEQ2cnFm?=
 =?utf-8?B?TlBCNUZ4Tm5NWWxHT0pPak5QYlNUd2RRNmpqajdKSk1KcU5sbHFjL2UwYmtl?=
 =?utf-8?B?NzNCSHVnY0U4aDljeHNna0Fpb05XYk9RVkx1R1FwMzhQZ09QRTQ5SUpOdEhG?=
 =?utf-8?B?QzhDYW1lY3BOeVBDenhrUlY4RzVHcHNHODYwaVlodDNra3NiMEJlUVltUUta?=
 =?utf-8?B?QTg2MGpiWGJ3OXVSVlNiRUVwZFpGeEY1RFZvY25jSVlMdjMvdDU0aTMzb3la?=
 =?utf-8?B?Y0hkcisyOXpwVU9GbXVRdWU4LzBUdWNDZktKeko3SGJCTmpUNDJ2c3hmMlVp?=
 =?utf-8?B?VTZrY1phVUxhL1hpZ3pPYVg1WnlzZ1VFcWRhQ2tDemxaejh1NUlRRGZ5TStG?=
 =?utf-8?B?aGdkZkhzd3RqaUgxMWkrcVNwQWVncmIyaTBKV3JNa2lNR2hXTXRKY040U0J1?=
 =?utf-8?B?Zk9DT1NrNjVHb1c5RE80L2FRYXQvQkxGbDNCN3VSQnAzY3RWS2xzOGp5WlZx?=
 =?utf-8?B?anpiN2Zub2hmNTgzWjJyRzRLN1hqNVBnWE4xSkNiOFEzNGY2ZGVyMk10YmlW?=
 =?utf-8?B?SFg0akY3dTFyL2ZkQU9pbGM1RW80QlhXWDFLY3dvaTUvNnZ0YmhaQTZ2T1pB?=
 =?utf-8?B?NCtUMXR1UGhua0JkZC84QXRtTDlhWDZON2p6MDRxMmNXUWEzTk9wQ1VLNXkv?=
 =?utf-8?B?VDZNTng5MEk4YWdhdHVHeEoyS1diL05abVFUQm14Wi9Vb0wzSUtsaU5Ud2xU?=
 =?utf-8?B?VDU4L1B5N282clF0aGZMek9idVVMb0xqY3lVM2d4SDdsazd3U0FkTlo2THhq?=
 =?utf-8?B?RkJyMEtpb3FvNTU5WC83UGQ5bWo0NWllQ1RXdTNPVEFuR21wK2hTVWlGbkw5?=
 =?utf-8?B?d01mTmM1K0h0cG1kL0IvK0lIcEhlb1c2ZjNCdFhBWG9zN0Y5d2dBZHNiYnBo?=
 =?utf-8?B?b3JhVTBySlpaKzUyUEI1cm83NmZuS2pRd2J2aXozQ2pJamlQSlNjRjRMTGRa?=
 =?utf-8?B?R3prYWd3OWFDSk1tYWlVSDZ2OHNjOUxFVXZXaFNqS0RWc1BPczI4VlNCSmZW?=
 =?utf-8?B?dnlwV1NQMWFrVE5pcXNzdU03THZvYStiZVFXNUZlV1NKTkRCQnQ2azRpd3Fk?=
 =?utf-8?B?UUpoQ0ZGb3NkU1h6QjlkQlUzdTBZRnlMMFl6VDdBTk1uR05OUHE1N3A4NTVD?=
 =?utf-8?B?YXBPaGNjczlMZGhWWUVzZDVXcjdxcUpKZ2hrb3JIVFFjRDNIYVliSDk1bHpE?=
 =?utf-8?B?cFRGOVk1bkJGWkgydlQwT1VIYk5RdEF2Zkt1Qi8xQkhZN1FQT3JxM3J0SDE1?=
 =?utf-8?B?ZVROV1JOclp1WjNFaWpqbkxuUDJZWEdnaUVwSTVoUFBLOHRhQzRiTTZxeEMz?=
 =?utf-8?B?bVZMcmFDazBqUXVUOXZuWEFCcXFmeFlSdmdrVTA4NlNrSlYzeFo1WFhLK0tm?=
 =?utf-8?B?V3hUYVpxbk84TWlwT3VsRVBWVTEzcWkyZS9qVEVyb0hJNktqcGU1TWN3bTFi?=
 =?utf-8?B?aWNGRDN5aDkxUkxsdGtEWjlic2VRVnNENE4wblVaSlRNWFM2MmFlR3JWZjQ5?=
 =?utf-8?B?Skk0VkpvenpSMDRHa0ZPRXU4ekJPOFBINDl4bFNNMVpqRWJLM1VWd0FlTm5Y?=
 =?utf-8?B?cUUrbEJxYlB2ejRVTjVzT2dVeHJ0MDRWSExVWjMzbmdoOFJmWERYcDE4RVQ4?=
 =?utf-8?B?WWpnQ2JiR1dmYTNwOHBwdFYzQlAzRzFRc09CMFVqQmhESEJDYi9XcEFlejlj?=
 =?utf-8?Q?JpuYXtAinxw+19EBEB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: iwhn5OHcLx+cTTE07z87642PpGOvSY2lHZemnooUlEWdM90uh7FXWalhcSOEb3rdlBxyq0Eo8zLwm8Nuhha/sdC+piSuW09/EsHAbZAxPYkej8CCUgQ2f72nMqduxrxblmMLAZ2WG3xKOWdPvuAz2Y6X5A/mVKsDPJfWCsEKIZTZCeiDA331v3Z47ZZg+a1WSSuSUD5JcQONmbBwRuTGE/uGnnp+o01qWguaMdfCFY5yqdEwoJ/ZpZN1/K74bi5AB0GBsll8iMc9N54X0d8ZrUBzinq3n6p2rg6GZeaY4/C6Eiljboi8YTzuMYnm27MfAuThrJkkuSaMTzY+YV+yZg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0566520f-a7c2-4fcf-d6a7-08dea0c0afd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 22:44:17.6215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O0ZXJsTVyIs8BvDJtrOsl+35N+rs9QaxcBZQEdWtCqf5rL4FRQSlphymKwYELwBJ7G0eEMNRvSHgoLKkZy4lKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com

PiBJIHRoaW5rIEkgYW0gbWlzc2luZyBzb21ldGhpbmcgaGVyZSBzaW5jZSBJIGhhdmUgYmVlbiBh
c3N1bWluZyBhbGwgYWxvbmcNCj4gdGhhdCBpbnRlbF9wbXRfcHV0X2ZlYXR1cmVfZ3JvdXAoKSBp
cyBhbmQgd2lsbCBjb250aW51ZSB0byBiZSBjYWxsZWQgZnJvbSB0aGUNCj4gbmV3IHVubW91bnQg
aGFuZGxlci4NCg0KTXkgcHJvYmxlbSBpcyBub3Qgd2l0aCB1bm1vdW50LiBJdCBpcyB3aXRoIHJl
c2N0cmxfYXJjaF9wcmVfbW91bnQoKS4NCg0KV2l0aCBubyBsb2NrcyBoZWxkLCBJIGNhbid0IHRl
bGwgd2hldGhlciB0aGlzIGlzIGEgZ2VudWluZSBhdHRlbXB0IHRvIG1vdW50LA0Kb3IgYSBkb29t
ZWQtdG8tZmFpbCBhdHRlbXB0IHRvIHJlbW91bnQuIFRoZXJlIGNvdWxkIGJlIGFyYml0cmFyaWx5
IG1hbnkNCnBhcmFsbGVsIGNhbGxzIHRvIHJlc2N0cmxfYXJjaF9wcmVfbW91bnQoKSBsZWFkaW5n
IHRvIHJhY2VzIHRoYXQgSSBmaW5kIGhhcmQNCnRvIGhhbmRsZS4NCg0KSW4gbXkgZWFybGllciBh
dHRlbXB0cyB0byBkZWFsIHdpdGggdGhpcyBJIGFjcXVpcmVkIGEgbG9jayBpbiByZXNjdHJsX2Fy
Y2hfcHJlX21vdW50KCkNCmFuZCBoZWxkIHVudGlsIHRoZSByZXNjdHJsX2FyY2hfbW91bnRfcmVz
dWx0KCkgY2FsbCBmcm9tIGZpbGVzeXN0ZW0uDQoNClRoaXMgc2VlbWVkIGNvbXBsZXgsIGFuZCBz
byBJIG1vdmVkIHRoZSBsb2NraW5nIHRvIHRoZSBmaWxlIHN5c3RlbSwgYW5kIGhlcmUNCndlIGFy
ZSB0b2RheS4NCg0KLVRvbnkNCg==
