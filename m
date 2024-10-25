Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFBA216E19
	for <patches@lists.linux.dev>; Fri, 25 Oct 2024 20:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888934; cv=fail; b=Fmz1VSEHdBnggABZHkm/yoiy1Ey6Kd0HM0DEzjYG9RQDNuLGePvf6nSDJN9Kkj0wK673ZGDFHIb7ca8Iuc99Z+VG+QszPTem+wCR5eL6VAAJ5UoVMVxjwr69+PS4Ujx9duGHD0BeyPRb0pg0b+/vZ6yk/5yQfLA+DIbakO9dzwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888934; c=relaxed/simple;
	bh=G63kYExIuf3gTT6HdrTkGtQaDmhUCWhd4n2NB18o8WY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BChv+sf5pM2cDDN8zEXzMMP5os69BSJPzEXc7suh52y1usKs871VyLHc/a8J3p9G1WPeWev13uXDLrovAYsUBqcYF/nsaqoWjkpDcwmAkj4vu9CJH8dHnuPlWfVJAedIZ2X3KbajpG1NDNhpQPculeLqKbpu7nAMivPlYIXYqBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxdeFP54; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxdeFP54"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729888931; x=1761424931;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G63kYExIuf3gTT6HdrTkGtQaDmhUCWhd4n2NB18o8WY=;
  b=MxdeFP54pJcZ4lS4TH8DJt3r9/rXpxpzTlL7XJKeWVW4jX/6FrHkkb32
   tHBzQBWd+2HRyTAEfp0xxjBRAbowKUHinLp5XoVIJ6JASioS/rbYLvT8x
   wJtz1kyrbOQvgjC/LEjWiHsEu13axBAFl0v89oEkP5cj8FvUqvPOHOXgT
   bkpNGvSz2KN3J7AS+PcXCEPJ7UfAowxEmAD8iHvd3HpcvL2ZniFB7ygMW
   5+5XkUGJk9wFr6/4BWXrDlMNnnlmT9GRt9X+C9S2F5Bs+kPNlUcb/Kftm
   lEg17TaaBcKHchj2AXHs5mcQdVQK7nZc92xW86mdTcHtZuxDgdLKqc57M
   A==;
X-CSE-ConnectionGUID: oLzc+IYbRjawCXCmSyAhnw==
X-CSE-MsgGUID: 0e2UUVOwRL2WecvUeZvQVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11236"; a="29790014"
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="29790014"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 13:42:10 -0700
X-CSE-ConnectionGUID: 2o5ePqXQQVq78RDYgoNygA==
X-CSE-MsgGUID: YhyKV+bcRu+0W26zZ1VQjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="80672599"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2024 13:42:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 13:42:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 13:42:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 25 Oct 2024 13:42:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eywpBwkm/Ib1aKOahJ0SeHw1LKRrhl95zEXqZs3llGI5s3SFNMGz/O6/nHRl6uyqyAqP6sPgZSXJWqzVpMyxT1BXZ28kNalHZjApf45DQf7HBoAL82pWvvqrrP9GFag+uZH0ZjKyhtSlInCjlA6OZfoif9qyG/zlTmB4MoWjibQK1VorBQiZgi+w21osnCu3HTXS2DR/+zbcUGuINpH6LuBrKJ22Cur7mMEELZbxUlI6y9L7fs/ULGB3Vh+mt0/RyRvtDZyWlklBXLDWZMl2GW0ap+jj62qTnPoMwx+yPGAtSCmuNfVpCTNW4Q6hNgcORb8sWR0NVQ9shM0XebidyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G63kYExIuf3gTT6HdrTkGtQaDmhUCWhd4n2NB18o8WY=;
 b=Uo0MdcIa2yYbVqm12JSodwifFEiwCxZMyfvoYjw1/pkw5pQSidi8MJQIkN3ThlcEyBy3SywIikpI3ta3kTFOK7l/uBCs2z9Xy65/wm2hdSJaPw9nRrgLuYJHIxhgXg/5CK69Qkyuz+jIOFW/rhT5z6ITkBEA7sOOGJJGK9SDhSzreoCEOxIhssm358n/neVEs7Qgfaj7Lze6dF7SFMioKHNfN2ZHgKbYQezJu1wm117JGDH5bLmcgsG4Sb42rR1jrrP2JSJq1EtuceD7DMKQFbh5sVU1jKwfe5Wdv2gbTblWbp7zh7SPPy71Jh33pAl75IKOLBTOGAwWuHU9zdvDtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Fri, 25 Oct
 2024 20:42:06 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.8093.018; Fri, 25 Oct 2024
 20:42:06 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v7 1/4] x86/resctrl: Make input event for MBA Software
 Controller configurable
Thread-Topic: [PATCH v7 1/4] x86/resctrl: Make input event for MBA Software
 Controller configurable
Thread-Index: AQHbFcg7Cl4VOPaS20mRmpaJ+OMAyLKX3U+AgAAs9gA=
Date: Fri, 25 Oct 2024 20:42:06 +0000
Message-ID: <SJ1PR11MB608328D2D772314AF62A2A7AFC4F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241003191228.67541-1-tony.luck@intel.com>
 <20241003191228.67541-2-tony.luck@intel.com>
 <bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com>
In-Reply-To: <bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5008:EE_
x-ms-office365-filtering-correlation-id: 13a1d0c0-150d-4c9a-b5d2-08dcf5357d3a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ejQyZUhXN0FHQVYxOWViZVo2TzdVRnFTSjdrRFJ5bFZEcXR3b04wUjNOWWxM?=
 =?utf-8?B?Z2VFRzQwd2NHMHErcktrSzN6eEVQaGMvc0E0YWVXQjBXNE1GZ2VlQmxrTGtq?=
 =?utf-8?B?WTJWZmVuSzV5dmNDd2lWSHQ2UTltL01pRVZLUTVpZFgrakJOclJSdmJFU1Fx?=
 =?utf-8?B?bkJ0aG00NzVwNEJVMEZRejYzYk9XM2R4YU94d3dYOENqZzJVMzVQbGZZMUFT?=
 =?utf-8?B?U2YwTXBqZXVGSWxqcFlUc1Iwd0xGVEZ2cGIvMEh1UE5RaDgrODZWOFdxYTl3?=
 =?utf-8?B?ZDJQYWZpNFNodk1HWkNFcVo4aFV6aTc2cEI5c3pHMEdld1FsWDY4NFRpVWpW?=
 =?utf-8?B?L0VyVWJBNlpONzQ2cWptbitQWGkyVkw5T0ZHN0dhczlwTFdWZG83WGVjbi9u?=
 =?utf-8?B?R3pUWFIweStvL0xrWG1uazFkYkM2ZEs2V2JZb1NEbk90MWY2UGxZMlFlSEFR?=
 =?utf-8?B?L3RTbjR0Ymk3TVFkK0RpZDZUb0ozNFVQa1JZNW52dW9FaDI4YURtNUp2V1Ar?=
 =?utf-8?B?cWcvaGh5UTJpUmRTdnlQMzFYY3VrWnZqQmZNUFlzWFRNZ3lRTEYzRDdoWEl5?=
 =?utf-8?B?SDZJT2tGU1BBTGdNWS9JY3NjNDZQY3p1Rjl0K0k1Tk1tenBCOW5vcVhsdXI4?=
 =?utf-8?B?anF5MzRrQTBNQUFUY0d0TngvVHZHcElvczJNYURsNWxMcmRkb2FVMFJTdEg1?=
 =?utf-8?B?MFFDbW0vcmYxcWF5bDg1VXdFb1JGSUowbGZVazR4b0xrR3B6RjBuUk00TGdF?=
 =?utf-8?B?MzZlRzFiMWFSdzlzRThKRGhRTEtKUnVrVG12cXUySWhMSmdySHJjVkFYSHRS?=
 =?utf-8?B?cFhrSFhzZ2t5SWQyRXJEQjFhVjJtSWdlUnRzK3I5Tlg2a21tTEluRFdCTE5D?=
 =?utf-8?B?U0FDd3FONDc3TFR5elNYeE4zNmIrakJOUjc5R2kvSHFObnhjajNrdnFGaXJK?=
 =?utf-8?B?aTlqQiswYklobDJIWFpNK2o1bExsMTJCbGhlREtSWi9YZDloT1lqTFhTeW4r?=
 =?utf-8?B?TXlWU3ZjelArU09iQXdsWmVWSkl4U2QwZ2hXZ1BUSHJaeDFEaGttVTVkUUd5?=
 =?utf-8?B?UGh3WkxuMmM1VmNydTcyWmhKZUlTeGJxT1NQM0RweURSUXJqVkg3NHZuT01L?=
 =?utf-8?B?SzRnN3JKaDF2Zjk2RTM1RllzMTJkZkxOK1Vtbm9DbTQvMTBOTVpka3ExQzVH?=
 =?utf-8?B?eW5FdzZFUFVtODlVRk1kSHh1ak1hWGx6cC9Ja3ZUWUxyUlFNSzl4Wm5NVnhR?=
 =?utf-8?B?bFZiQnFKQTJTMVcrcFVwQTJnR3l4Q2xWYUJUN25TdnBFZmRtYTNVaXBxVGZi?=
 =?utf-8?B?eTlxNmxoMzAzVWVzYUN6bTZWTzcxY2FDYjd3NmFJTmRJOU00VndNSldQZmZC?=
 =?utf-8?B?Q1pxRWowRUlCdC9aR1lwSWtvcmJFTFZqcTJ5VzNKbzJuSVluVmwwbHltcklo?=
 =?utf-8?B?NFVneTNBd3E4czFlV1J0alZTMTN6UG5UZFJacGRqdFRaNnBMUWZHWjFNRjN3?=
 =?utf-8?B?TEdtdFUvRmxoUjR1YTZhWkdZcnJrK0dkOEI4eDhCWGEydHd0amdqTWZJQzJF?=
 =?utf-8?B?SHh0WG5DeVI0dXo2K3RINjV5VndOWmY5QmJjL0I4T2IzdWRzWTlVYVpqVkQ5?=
 =?utf-8?B?Qno0dmV4OCtEMGU4NStBTTZSMHM4K1F1a0tVd05EZGE4SkxNR3J6Q1VzUHY5?=
 =?utf-8?B?eXdTQUNOSEo4MjRJUHJKUE5aUFNaaXJFV2hMOUxOVzBMczhIU2VWZEFqTU9Y?=
 =?utf-8?B?ZzBnM1FNWnpIZ3QvUUJhL1pqdGFaMVNBamdDSUxqYzN5UTVJdjBjeWtMNEFX?=
 =?utf-8?Q?XWMFpzhiDfe79gI5NM+qzliVcvqjy4Matt+6Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHNBbUZIOE0wUTBBMmIwNVhuZDJmUjVmaE93UmpMWUdCd2lnR1UzRzdweGVW?=
 =?utf-8?B?UmZMVnJ6ZkNyYWpTcTBWb1kzcEdjRmlJUnd3aElwWE1jY054Uy96WllmOW1X?=
 =?utf-8?B?K2oyQi9QOUJoZVhGTGo2bWN0a3pUaThZVzQrNmFEeU5rYmhmRTFPNG1pM2k3?=
 =?utf-8?B?Mjh3dHh0UWRZNG9nR1pLczZ2Z2JkVlNTNGpsbjAzSFl3a3RtTmdZbnEwTlRU?=
 =?utf-8?B?S1FVWFpYelZ5RFE0Njl4emp5akJCK3lMUmlpZjBtUTdiOHkyOEpNSTdCSjJ4?=
 =?utf-8?B?dlZ4QytLSis3K3k5MU1DSUFoMDJNQm14OWdCdExZaVdEY2sxdVhoR2NsU1gv?=
 =?utf-8?B?b2JwSmZoRVR4bjA4RHlJeXRpK05TVVE0VWJlM2JiY3V4ck9IeCtZdG9mbEVi?=
 =?utf-8?B?U0ovc3BqYTloc1Z6NXM4Z25UZEVNazlMSGhJZWxqVVYybk9uNzdOMCtjbW5r?=
 =?utf-8?B?SHl3TlFqUmtlV3gyMXhaaWtWVVNuMDlpWVlyOXRmdDZWZFA5MWdWaWQzT0I2?=
 =?utf-8?B?Q25wT0s4dnBBaEJZVytYNkhsSi9uRFNkdmRyYWI0Tk9MREsxdHJQK0VSd3px?=
 =?utf-8?B?R1RmQlNQOWxMUlBLdU9EZlI5UFdYLzg2R0luWm1TeFQzQ0pESVlCV3JtbXZq?=
 =?utf-8?B?QjhKMUJkblBXMnU2N0ZnMDF1cTlldWdKcTVja0M1Z1NRN0tmS1crOFM4Wm9F?=
 =?utf-8?B?WFNLOVJzSXpFOUU5QWF1NEh2eFhjY1JVTjhTZlcwMjYxbGVHRlNuMCt4WWhR?=
 =?utf-8?B?eVVNNG9Gd0xNdjdWOXdNeUdoRTFrMHcwRzdlUVNsVkxXcU43S1FjVlVzUXht?=
 =?utf-8?B?cDVLTWhUa3NRRVZTZklYdmNWTWtUREZ2MjFRaFlCSk02dk1lYnpUendzMms3?=
 =?utf-8?B?bnU0c2ZtNHlKUkN6RGpuNjFNYzl4dllSNC9lSnA4S2lQd2JKNk1Makt4NldQ?=
 =?utf-8?B?SU1LTXMya0ZnRE1JTzYxdmxPM0VwTXZ5NzZONnlLM3dXNit1b0FPbGNHWU1q?=
 =?utf-8?B?QysvMGJQbE5JQWtvRk1uMC9UcUx4cDN2SEJNbmI4N3dHMmJ2SW9CVTdhU1dJ?=
 =?utf-8?B?QWxZOTZSa2xvMlE2dGxyb2JIMkVpbkgvNy9kK2FLQSs0Qll0VWIySG5GZnJF?=
 =?utf-8?B?THFFdk9sU0xabXlyZ29CY3VrVEZlQk9CcUUxK09rWDFzWk9wVno5QVVrbUpH?=
 =?utf-8?B?clQ4SHhKZjZzVWJSNnJSb2pMZmNnNmNGbEVOMHAvWkI5VEpKMEZGZ3VFWEpo?=
 =?utf-8?B?ay9TVHh5Vk90STd2L2Q3K0t5NHZ4b2VhR3c4SXB2V2dVRXpnTFJSMXM4cUwx?=
 =?utf-8?B?UnRQQi9DemJTRmJ3VmhWUTVUZXFaL0dGektHeXh5S3o2bVN5VWRYelZDMHFq?=
 =?utf-8?B?WDRtcnpmL1RSUWVOSFFpZSt6V3lHci9XVDJjTEgzc0wxTmlPMkt0NEZ5SW1w?=
 =?utf-8?B?K1JoVm0rdkZ2NXpoVWhpNWVqRW9INytWQ1RsYTEzSjlVamdDODZuME5GQ2da?=
 =?utf-8?B?T3RwcU80c1ordi9oNEI4M2tHQTIyTTl4enpnSFFEKzFVOGEyM0JSNkdKWXNk?=
 =?utf-8?B?dWhvWXdYZkphOFJkcHNxdGVkZG1kVmIzM3JhSzFGd3Fuck1CU1YvRG5mNGF3?=
 =?utf-8?B?TnFvb2Q0dnd4cXJRd2Y3UnprWXVHSFpCcUpDNzl5UmFxUTJMaFlmS2l6dzBK?=
 =?utf-8?B?VldQbkZHUGZOUFlwWjRWdkN3ZDJsNVlWV3p1OEpiVGdvQm1sSThza2xNdWF6?=
 =?utf-8?B?aERKUXVnSmpsSXJlQzhjcTcySXdoMjhnRVhtck9VSlg1bmRKT0hYT2pESGND?=
 =?utf-8?B?RlFWUVU4SUtnUVZha1NiSU03YW9TUSs1NjNCbHdNSU9UVXFuVEhXUjgzR3VT?=
 =?utf-8?B?ZU1aQWppdUtVU21zRGdHdHEwQlhlMGZNbklnUHFUL2R0ZWhZZGtna3RRUlJC?=
 =?utf-8?B?dExEbDV1VnUvWWdUUUhZaHpINlhzcUNyY1puYnpYZ3FrbkJQeFpkZlhNL29v?=
 =?utf-8?B?ZjUxTDVrNU1CUHpzTGwrWm5HcjZCOFVkbEtkUU40dm1NSlNJamo2cGZYYkxw?=
 =?utf-8?B?UGdIOU1ra3ZGcVJZMEtwZVk5UFAva3BmZWlscTBtQlQ0UnlOVTBLNjBjV3gw?=
 =?utf-8?Q?jbk77ZiKLt/z0RSHcz+Qxdoz4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a1d0c0-150d-4c9a-b5d2-08dcf5357d3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2024 20:42:06.2512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x0jpC8c48djRjXir8caoc7vpFQztmP+IolQguPmPmV/hN90ToZTJ97o2T8CpC6AmXgttExcTrURTivpdf86Jig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5008
X-OriginatorOrg: intel.com

UGx1Y2tpbmcgb3V0IGp1c3QgdGhlIGJpZywgZGlyZWN0aW9uIGNoYW5nZSwgY29tbWVudCBmb3Ig
ZGlzY3Vzc2lvbiAod2hpY2ggbWF5IG1ha2UNCnNldmVyYWwgb2YgdGhlIGNvZGUgY29tbWVudHMg
bW9vdCkuDQoNCj4gSSBuZWVkZWQgdG8gcmVmcmVzaCBteSB1bmRlcnN0YW5kaW5nIG9mIHRoaXMg
d29yayBieSByZS1yZWFkaW5nIHRoZSBwcmV2aW91cyBkaXNjdXNzaW9ucy4NCj4gWW91IG1lbnRp
b25lZCBpbiBbMl06DQo+ICAgICAgIEkgdHJpZWQgb3V0IHNvbWUgY29kZSB0byBtYWtlIHRoZSBl
dmVudCBydW50aW1lIHNlbGVjdGFibGUgdmlhIGEgci93IGZpbGUgaW4gdGhlDQo+ICAgICAgIHJl
c2N0cmwvaW5mbyBkaXJlY3Rvcmllcy4gQnV0IHRoYXQgZ290IGNvbXBsaWNhdGVkIGJlY2F1c2Ug
b2YgdGhlIGFtb3VudCBvZiBzdGF0ZQ0KPiAgICAgICB0aGF0IG5lZWRzIHRvIGJlIHVwZGF0ZWQg
d2hlbiBzd2l0Y2hpbmcgZXZlbnRzLg0KPg0KPiBDb3VsZCB5b3UgcGxlYXNlIGNsYXJpZnkgd2hp
Y2ggc3RhdGUgeW91IHJlZmVycmVkIHRvPyBJIHdvbmRlciBpZiBpdCBtYXkgYmUgdGhlDQo+IHN0
cnVjdCBtYm1fc3RhdGUgc3RhdGUgbWFpbnRhaW5lZCBieSBtYm1fYndfY291bnQoKT8gbWJtX2J3
X2NvdW50KCkgaXMgbGlnaHR3ZWlnaHQNCj4gYW5kIEkgc2VlIG5vIHByb2JsZW0gd2l0aCBpdCBi
ZWluZyBjYWxsZWQgZm9yIGFsbCBzdXBwb3J0ZWQgTUJNIGV2ZW50cyB3aGVuDQo+IHRoZSBzb2Z0
d2FyZSBjb250cm9sbGVyIGlzIGVuYWJsZWQuIFdpdGggc3RhdGUgZm9yIGFsbCBzdXBwb3J0ZWQg
ZXZlbnRzIGFsd2F5cyBhdmFpbGFibGUNCj4gaXQgc2VlbXMgc2ltcGxlciB0byBydW50aW1lIHN3
aXRjaCBiZXR3ZWVuIHdoaWNoIGV2ZW50cyBndWlkZSB0aGUgc29mdHdhcmUgY29udHJvbGxlcj8N
Cj4NCj4gVGhpbmtpbmcgYWJvdXQgaXQgbW9yZSwgaXQgc2VlbXMgcG9zc2libGUgZm9yIHRoZSB1
c2VyIHRvIHVzZSBkaWZmZXJlbnQNCj4gTUJNIGV2ZW50cyB0byBndWlkZSB0aGUgc29mdHdhcmUg
Y29udHJvbGxlciBmb3IgZGlmZmVyZW50IHJlc291cmNlIGdyb3Vwcy4NCj4NCj4gSWYgaXQgaXMg
cG9zc2libGUgdG8gZG8gcnVudGltZSBzd2l0Y2hpbmcgaW4gdGhpcyB3YXkgSSBkbyB0aGluayBp
dCB3aWxsIHNpbXBsaWZ5IHRoaXMNCj4gaW1wbGVtZW50YXRpb24gd2hpbGUgbm90IHJlcXVpcmlu
ZyB0aGUgdXNlciB0byByZW1vdW50IHJlc2N0cmwgdG8gbWFrZSBjaGFuZ2VzLiBZb3UNCj4gbWVu
dGlvbmVkIFszXSB0aGF0ICJhIHNlcGFyYXRlIHBhdGNoIHNlcmllcyIgbWF5IGJlIGNvbWluZyB0
byBhZGRyZXNzIHRoaXMgYnV0IGRvaW5nIHRoaXMNCj4gbm93IHNlZW1zIHNpbXBsZXIgd2hpbGUg
YXZvaWRpbmcgYW55IGZ1dHVyZSB3b3JrIGFzIHdlbGwgYXMgY29uZnVzaW5nIGR1cGxpY2F0ZSBB
QkkNCj4gLi4uIHVubGVzcyB5b3Ugd2VyZSByZWZlcnJpbmcgdG8gb3RoZXIgaXNzdWVzIHRoYXQg
bmVlZHMgdG8gYmUgYWRkcmVzc2VkIHNlcGFyYXRlbHk/DQoNClllcywgdGhlIHN0YXRlIG1haW50
YWluZWQgYnkgbWJtX2J3X2NvdW50KCkgd2FzIHRoZSBwaWVjZSB0aGF0IHdvcnJpZWQgbWUuIEFm
dGVyDQphIHVzZXIgc3dpdGNoIHRvIGEgZGlmZmVyZW50IGV2ZW50IHRoZXJlIHdvdWxkIGJlIG5v
IGJhbmR3aWR0aCBkYXRhIHVudGlsIHR3byB1cGRhdGVzDQpwYXNzZWQgYnkgKG9uZSB0byBnZXQg
YSBiYXNlbGluZSwgc2Vjb25kIHRvIGNvbXB1dGUgYmFuZHdpZHRoKS4gU28gdXBkYXRlX21iYV9i
dygpDQp3b3VsZCBuZWVkIHRvIGJlIGF3YXJlIG9mIHRoaXMgbGltaW5hbCBwZXJpb2QgdG8gYXZv
aWQgbWFraW5nIHVwZGF0ZXMgd2l0aCBubyBkYXRhIHRvDQpiYWNrIHRoZW0gdXAuDQoNCllvdXIg
c29sdXRpb24gaXMgZWxlZ2FudC4gVGhlIGNvc3QgdG8gbWFpbnRhaW4gYmFuZHdpZHRoIGRhdGEg
Zm9yIGVhY2ggZXZlbnQgaXMgaW5kZWVkDQp2ZXJ5IGxvdy4gU28gdGhlcmUgYXJlIG5vIHdlaXJk
IHRyYW5zaXRpb24gY2FzZXMuIHVwZGF0ZV9tYmFfYncoKSBjYW4gaW1tZWRpYXRlbHkgDQpjb21w
YXJlIGJhbmR3aWR0aCBmb3IgdGhlIG5ldyBldmVudCBhZ2FpbnN0IHRoZSB0YXJnZXQgYmFuZHdp
ZHRoIGFuZCBtYWtlIGFwcHJvcHJpYXRlDQphZGp1c3RtZW50cy4NCg0KVGhpcyByZXF1aXJlcyBh
IG5ldyBmaWxlIGluIGVhY2ggQ1RSTF9NT04gZGlyZWN0b3J5IHdoZW4gbWJhX3NjIGlzIGVuYWJs
ZWQgc28NCnRoZSB1c2VyIGNhbiBtYWtlIHRoZWlyIHNlbGVjdGlvbi4NCg0KTm90ZSB0aGF0IHRl
Y2huaWNhbGx5IGl0IHdvdWxkIGJlIHBvc3NpYmxlIHRvIG1ha2UgYSBkaWZmZXJlbnQgc2VsZWN0
aW9uIGZvciBlYWNoIGRvbWFpbi4NCkJ1dCB0aGF0IHNlZW1zIGxpa2UgYW4gb3B0aW9uIHdpdGhv
dXQgYW4gb2J2aW91cyB1c2UgY2FzZSBhbmQgd291bGQganVzdCBjb21wbGljYXRlDQp0aGUgc3lu
dGF4IG9mIHRoZSBuZXcgZmlsZS4NCg0KTWF5YmUgbmFtZSB0aGlzIG5ldyBmaWxlICJtYmFfc2Nf
ZXZlbnQiWzFdIHdpdGggY29udGVudHMgdGhhdCBtYXRjaCB0aGUgbmFtZXMgb2YNCnRoZSBtYm1f
bW9uaXRvciBldmVudHMgYXMgbGlzdGVkIGluIC9zeXMvZnMvcmVzY3RybC9pbmZvL0wzX01PTi9t
b25fZmVhdHVyZXM/DQoNClNvIGRlZmF1bHQgc3RhdGUgd2hlbiByZXNjdHJsIGlzIG1vdW50ZWQg
d2l0aCB0aGUgc29mdHdhcmUgY29udHJvbGxlciBlbmFibGVkIHdvdWxkDQpoYXZlOg0KDQokIGNh
dCAvc3lzL2ZzL3Jlc2N0cmwvbWJhX3NjX2V2ZW50DQptYm1fbG9jYWxfYnl0ZXMNCg0KVXNlciBj
b3VsZCBzd2l0Y2ggdG8gdG90YWwgd2l0aA0KDQojIGVjaG8gbWJtX3RvdGFsX2J5dGVzID4gL3N5
cy9mcy9yZXNjdHJsL21iYV9zY19ldmVudA0KDQpPbiBzeXN0ZW1zIHdoZXJlIG1ibV9sb2NhbF9i
eXRlcyBpcyBub3Qgc3VwcG9ydGVkIGRlZmF1bHQgd291bGQgYmUgbWJtX3RvdGFsX2J5dGVzLg0K
DQpOZXcgQ1RSTF9NT04gZGlyZWN0b3JpZXMgd291bGQgYWxzbyBkZWZhdWx0IHRvIG1ibV9sb2Nh
bF9ieXRlcyBpZiBpdCBpcyBzdXBwb3J0ZWQuDQoNCi1Ub255DQoNClsxXSBPdGhlciBzdWdnZXN0
aW9ucyB3ZWxjb21lLg0KDQo=
