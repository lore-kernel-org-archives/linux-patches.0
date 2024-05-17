Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C406C13E02F
	for <patches@lists.linux.dev>; Fri, 17 May 2024 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967800; cv=fail; b=Llr7GUVh5w9ZxMiMlVRXhC+NkVU4a83oOVk9AWppSxMwj3jdDdQfBjHE+7QtstA9hJPeqMt11XuEWk+zwXQSn2YcF6ehMYyWY/urYr4wY4YKNDoGjSAJE+1Q2ou4RHe5R6JDz40fN+FgmKaDwtgmDeq41a+t6EjQTwjNAw1v9X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967800; c=relaxed/simple;
	bh=0nAMTQkJLWU6hdXdYRkY0Zlxl6TbcqASRFFebD08H+o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p5iO85XHjaaoD46iwBDQcTL+YFiYfCYl+h2tzyInCtC403BBz/OhvT0mn+F22sv2uZgI+dR5PT6rL1yh1ka4bvJgzrZCKxoe5m1GxTtAyIdwxtYG+K0WfaDlphQKBgQ/gWwYNTjmnmudj0GW+wJT98Hm5aCQ40FHFNQtcDBxCOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QhrIXnFY; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QhrIXnFY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715967799; x=1747503799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0nAMTQkJLWU6hdXdYRkY0Zlxl6TbcqASRFFebD08H+o=;
  b=QhrIXnFY/I0Aq/iL1lQTSVmRL9C6XNxZiFAmeVlCTFQ59BJkPukIJmPa
   CFoDuXeXzn5znSvuzv3yeDqIJwOalf+Ez9HuKXQHVMilivGYdbTaqHdHq
   zPsFI9FzND3uGaZJ41R6/pyBSTIgd2AR/cSuC1aKJUFJs1EydzfB8we1J
   Xbtc9MuCwt48YCAcnjxkA8x0ziETEJdJdn1IqBKNuTyP2nUcmami4Vtaw
   27R6G0HGrKQ0lm9EzM1lYuA332jSJs7bFyd12WdHoZnVI4s/Fi1VlD2W9
   rhgYmWVMBC71gkr+rZsskuo1Zr4uFzqNLiARQkIlAEKEq83P5vVZ2kN40
   w==;
X-CSE-ConnectionGUID: jyHCnDx8QZuMU+Klp32oLg==
X-CSE-MsgGUID: M1HynHytTVaVdkCSwjBDgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12004596"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12004596"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 10:43:18 -0700
X-CSE-ConnectionGUID: NKJsnLUTRZiyTASzxlWW3A==
X-CSE-MsgGUID: WNhXAY1nTmuCJkYQBHjODA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31774106"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 10:43:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 10:43:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 10:43:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 10:43:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 10:43:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7cHU06R47JbfarxPoXFaTmWL26YRuMOBpPG9jjPBP1y2QnEl0xiPHjt5ts6FU6gfPz5H9oIPkXb3Z7sAQP0ebOpzhcUa062cqvko1YtNsbYBv2Ge3ItgXqTEXc2x6krmeYXzkwBzeTU1OkcyOlCAeSjHSKQZd+4WyCXloK3TP7kZLCxoUpVHonbJkJYDhZd1o7ei98IrN8w6ZKj7EZTuYkB5q7KCOJpuarFKxbfu8QRZDxoi7ZSAFSMnibJoZWLZdVFN5XestzGvmwUbyD7HV/sSKdLqn9kdAOfcYwKZexNYhr8Vwx170wTm3dlvuD2l6Q8xJjqJ2s4EQ/WNUc8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nAMTQkJLWU6hdXdYRkY0Zlxl6TbcqASRFFebD08H+o=;
 b=REnPa8bbajt7YD5VaWeKSSZ98mD8MMkVK3I/GdUfq2DOoJyQYcqPzwn1sL/ciF4u5Yjw/pbowQbYf2wKkA5o7hPVR4lL+C9KZD+3IbBLgwogbbBmUGzGNDQ5gNd9vcIoYZtpChMBOcLmPeKkcnu8OwGEpTLjZ4ENbMcQkoXJqzE0IOw2rbQfcBQPsVcC9b5e6bLuVnljjUFFC8+YSVuysxEYj95I/CN6Vrc2lBk2lD0LgFwYWrvdG2NsowKWqdhaozJndSMrRuth+lHUh15c5Q4G8nfQhQj1Y+Y6Njt2pse33/Hc9SuQmys7aP13OCG0P3c/ILUU1+clInTH8tKbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 17:43:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 17:43:11 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Dave Hansen" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman
	<gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHaqH6zwUWGNcLDPEWX8DDSkF3v67GbsPyAgAAAdjA=
Date: Fri, 17 May 2024 17:43:10 +0000
Message-ID: <SJ1PR11MB608386716D1DA533791DE7A2FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240517172134.7255-1-tony.luck@intel.com>
 <20240517173811.GFZkeWAzKjYtEMwe1e@fat_crate.local>
In-Reply-To: <20240517173811.GFZkeWAzKjYtEMwe1e@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6180:EE_
x-ms-office365-filtering-correlation-id: 06698b5e-2b78-4747-ecd1-08dc7698d1fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cUlFcE9KamV2K2RuaStuWnJsekxjbzc1aHo2RHhpbXNYK21wcE1vaVVXeGNj?=
 =?utf-8?B?aG8rNTZ5L2JxUldCeE5wWkJuQVZ1MWxBbTNUYk01WWJnZGlvL3g0Y2VFUGtj?=
 =?utf-8?B?ZEJSYTdab29UOWEvR3UybFJ4THRxL0RwNGhQOVRaWE4zbTJkQkgrUUZqZHNJ?=
 =?utf-8?B?MzJ3RzJyQUNuMUhhQkV3THIxSGhXNm5iTXFrak9pMmFIWkxvU3dxcHpNZ0g4?=
 =?utf-8?B?cWJCZTRrekIyYzBKWXN1OUtRanZRT3dNd2puUHErMjBlSVRzZFViQjUrNFR5?=
 =?utf-8?B?M0Z5Z2g0NGdhdUt1dGFxVmZUT1BpdC9UQ05EVFR4WHRhY28rQVg4Mk1iR0o1?=
 =?utf-8?B?YjVxUGN0dkhRR3BYTzhEWjRNd3h0R1BZckR5M00yUWlYZjRuUURFTHlZY2Q5?=
 =?utf-8?B?TDRVVUtDa056dHBnOW9CUDZBZ0hnY3UwVmM0d3BXOGRLSllpbmRvZzY5WUFr?=
 =?utf-8?B?ZWhXS3RHaXl6Q2R1MWV2NnRONkhYek1pMEZTWEVsRi9kcHRrT3JTTGtSMUlK?=
 =?utf-8?B?T0NuamREN3FzaW1XWUEwbWFXazEySkpSbVl0N1hTTEcwaU1Ba1plenR4ak1I?=
 =?utf-8?B?aHZvazk2QWM1dmZzTkc2RnV6WHJCenB2MVBCeE9RdHI4Wi9RWm1yaDN1eXRx?=
 =?utf-8?B?U0dEUXI5Uk5RMDVWNEJNbm56bll3VU14Rm94ZVoxeTA3NFZiZU1KTFpKZkd1?=
 =?utf-8?B?eE1QT1hZaXA4RXRyYUpYMEdIZmUzOVZCWVgwcVlldWZyUC80UWlkV1BJU09M?=
 =?utf-8?B?WDBmK0syMG10ekEwdEwzeEpNck52RzJnUHUybzFwWE9Razh2bjV0NGZCTjd0?=
 =?utf-8?B?YXNkdnhMSHZPZzNEZXdBZXVQT2paSTFsblFMQnJPTE5pbVJwMG9Lc25HSmZ1?=
 =?utf-8?B?UVI3R1JDc2VDNFZDemF6ZzFzR1dXSGR2a0UrcE5HTjRiNVVDSGZabXZkYnUr?=
 =?utf-8?B?cWxSSkVRWlhSTDlxTDRpSHlaeDZsdHhRemVremtiMUpNMlYvbkxyQVpnQ1k1?=
 =?utf-8?B?b3FrWVJrcitmNU9PblhDVURPL2lHQU5yRlRZbEVQdlc3cFpXZ1I3a3l0RGxZ?=
 =?utf-8?B?UWJyUEhzN0RjRXZJQWNHd0VHOEg4OGsyemtCbUVpY01rbjFTVFJ4bHlmNzV6?=
 =?utf-8?B?TFkxMUFNeCtPcCtHS1FNWXZFaWF3dGxyNThqOCtjdU5hQS8rRzNOOE1rYVhI?=
 =?utf-8?B?TjZFTit5UHkxQkFHN1A4YXJPSTYzRTkwTTBaalFNeVB2cnlpU05pNUh5bXgz?=
 =?utf-8?B?ZlJwQUgwZkRxN1gwSnV1UDhTaXVGbDJRazZUdUZmT2Q2MEF0bCtCZFF2MTVq?=
 =?utf-8?B?L2QxUzdRYndaL3JlalhsUEFQOTFJN21oTHlXU2IwdjVKQmJlam14VW83K2wv?=
 =?utf-8?B?VWxXM3V6aFlwLzA2Rkx4ZWxLRHhkNTNTK1JWWmJvb1RhQzRQeC9PVHExS1R1?=
 =?utf-8?B?U1pKSGtmNy9ldzhMZU9DY3FVdExTRkNNY3JMRVBmczk2ZTV2a0lwclA1RVox?=
 =?utf-8?B?ZDhQcGd4WndKRHdoR2dEYUpDeURVZFErbnNEUUpHVW5QWC9rcHlRdzFxeHhH?=
 =?utf-8?B?ODBqZlJSVkM3QWZ6VEhQWm9SVnlSVk8wOU51T210MmVLOVUrWk5XdTh4a21U?=
 =?utf-8?B?MHNNWUZUd1JoNk81MjNGMkZiMU1BR2NqaGN0TzF2QmdDck8yYURNVHAyOXAx?=
 =?utf-8?B?dHNaUWJrYUdaOSs1UEZMY1B5eW0yYzBHYmdNYXdDRzBpb0dQYnE1ZHZHVFN6?=
 =?utf-8?B?RktweHVpcG9HZ05NM3VqMXpvQWV1WFpoWmdRdlFCK1lUakVaeXBNcEF5VmV1?=
 =?utf-8?B?UnBTTGw1KzhaV3lUK1ppQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3dTM2liTW5FNVFRa1ZRajZoVy9qWGYrWVgvU3l0MlA0T0VjUyttMFpZdDhp?=
 =?utf-8?B?UmRrMUIyQ0EzWFBxa2JibjBCVG1mbzBnTkQ5MGNOaTNDTXlIZCtVZVF0L2hY?=
 =?utf-8?B?eHFZRGVic21LZFZzUDVuODhGOUdTeEJFNW5oc0J1V0dvcjR1cXNzNzNUNXVt?=
 =?utf-8?B?VXZLVlgwVU9LTUN1b2VlZFZjSXVGN0drZVZaaFV3WUE2M1d3bFREeW1CNE5Q?=
 =?utf-8?B?U05LckRWSzdYZ05LQk5SMXZKWTJCWnY0MFl4eUU3SE8wNStIY3N0d3lYemc1?=
 =?utf-8?B?Zkg4TFdSbW1UN1huREQrTWFhdFNOTEpFM0JYMkFtL3h1ZGhoN2dvajZqOEkz?=
 =?utf-8?B?TE9qK05UT0NZV3hIeElrSDdHZlV3TUNzcUdCdDhmY2x6amNCRW10UHd1OTdV?=
 =?utf-8?B?aE1RbUNmc2Z2dzdKTzNRdjFEVzhqQVRHcTkxT3RuSVdOUlkwSzQvamxLS2FR?=
 =?utf-8?B?MDg0QVYyQjlpa0FGWFBkQldBLy9ZWGpBREVoTms2VHNRMFJSVkRLeEhPZWlX?=
 =?utf-8?B?N01GZ2lDdjdnVHUxR0ZLZXdpSlorU3pqYnUyVVJmY1BXQ0Z6RHhsNytqK0s0?=
 =?utf-8?B?d1RWM3RIUERNWlZOUDJqNnZZeEFQMHlkdzNKTzBPd0JwcUZZbGg4aTRXUHhu?=
 =?utf-8?B?OEVIalFnT1JsajdHMFozdTN4MEdNeE54R2xBMTdDemo3R1VNWGtCZ1FHKzNq?=
 =?utf-8?B?UlRKeGVVaGRjTUwrOGZ5T01NVU4zNHYxT01jQTJwTDF0MHBUbkpENWc0Wm12?=
 =?utf-8?B?ZlB4OTlGOUlOREo3VzlRcXUvQU5mdkNLemhzbFFKL0NYaUN0NnNNbkZkQU5R?=
 =?utf-8?B?QktCUDFrd0I3dXdnS1hxZGdaS29kZTJzTEYzaGhkYmEwU2owbzZiTGZLVFFC?=
 =?utf-8?B?K0pnSXZnZk9GTHFPNzFOMDJPM1dpVnNTTjJoWXNYMHovUWViMXdiZXJsZnhr?=
 =?utf-8?B?ZThpSlkzSmMrc3YxaG1VZExoa05jeTBmamVLQmlnbFR5cVpmVFViUjF0bmsx?=
 =?utf-8?B?NkN5NmJhbnQyRHhWNlpUSUxPRGgvV3BEWDMxKzdIaGh3c2w1UlZEZ3N0bmpQ?=
 =?utf-8?B?cUtuVGRUYkZ2RDRTZEpSNU5rWTFxaWJBQlBCTWdQUjdCSGVLeDN2UjQrV3VZ?=
 =?utf-8?B?empvNUdsZDhsdmxVTHRwaStmbHZFdnlaSDdBbVh6RThDRzVQbnYwUG9ydUVi?=
 =?utf-8?B?OTBXMGRiTWRQVTc1VWtGeTREb0FnelpKdEEwVVFVWjRmZU5sanFmWm1FVW1x?=
 =?utf-8?B?b2xodVdNV21uL2ZHUDNpMWNHWlltNW95ZDM5Mzd0WGpIMm5tS0JkSGNZaHg5?=
 =?utf-8?B?K3kxaG1ROXZYUDhaU09jN2ozbW10M21wZ0ttdjk3ME1pSEdJalNFbGhwaHEx?=
 =?utf-8?B?ZWxlV05FczFsN0JUV1NpUkFVMUFya2p1V3BEVy9rSHZGVFZoSWtBRm9COWpZ?=
 =?utf-8?B?cThTYWNpOUl1WktacXpTbi9OUGxUMzdWYVVURUdpV2xpL3c1UVg3cnpnYVc4?=
 =?utf-8?B?cFRsU2tCNG8ybEwvU0JBL2RkUXhFcVhvb1hSbFdkSTdnMUc0SUNPZjVIZ3c3?=
 =?utf-8?B?QWJRanVXM0xlbmtybVNVOWN0eS92MlZVeTFnajMycTFleVRyajVpdld1LzF0?=
 =?utf-8?B?VDUwZ3ZobGZ2UEhaUi9DUi9yVVFrN2pocjRSdEJwZysyNVM4TlBnenpaZmpV?=
 =?utf-8?B?UEtKSSsyekJ5Mzd3ZnVZMk4xVWxkdnRCazRMRndqc0xPaW9VM3ZsRlVIVU1W?=
 =?utf-8?B?b1NIOGxORG1ISUhlWFMvNGJJVjhFcFlwcHlLK1FHd0V2ay9RZEMyUHpTMmlN?=
 =?utf-8?B?a0s2MEc2WklWMUg5SHREMFBkUjNZMDI3QzVCS0RGQm1vYk1LdFRaN2dNL1J2?=
 =?utf-8?B?UENhZElFZDgzMjhFZnE0Q3VCaHdBS1hzRWlwdzNWWU1YSTBBLzJuaDAzczdl?=
 =?utf-8?B?b29vYzl2dEUvNEVZUFJjNDhuQlhZZ3NWUHY5eUkwK0YvM29CeEkxYlcxKzJt?=
 =?utf-8?B?ZE9jTE5LM2N1bnVVcit0T3RvMnpvVWFYMDROdHNjNUdENk1RS0lKTXZ6bTRz?=
 =?utf-8?B?VWxCZHN5Vk82b1Q1M0tVc2tla1JYcG53akt6OUZwc3BBWS9QdEJ3dittSEkv?=
 =?utf-8?Q?oXJv42AKASGFGWz+m3i6956NW?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 06698b5e-2b78-4747-ecd1-08dc7698d1fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 17:43:10.9551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WfntECxv7cwCuVcY2L5MNoLHyfC49mtmv0WhQe3mXv/nBKoY0F38oqWbyOrzQgQM/k/qijOcbRRhFeaL4r1ILw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6180
X-OriginatorOrg: intel.com

PiA+ICAgICBmb3IgKG0gPSBtYXRjaDsNCj4gPiAtICAgICAgICBtLT52ZW5kb3IgfCBtLT5mYW1p
bHkgfCBtLT5tb2RlbCB8IG0tPnN0ZXBwaW5ncyB8IG0tPmZlYXR1cmU7DQo+ID4gKyAgICAgICAg
bS0+dmVuZG9yIHwgbS0+ZmFtaWx5IHwgbS0+bW9kZWwgfCBtLT5zdGVwcGluZ3MgfCBtLT5mZWF0
dXJlIHwgbS0+ZmxhZ3M7DQo+DQo+IEkgdGhpbmsgdGhpcyBzaG91bGQgbm90IGRvIGFueXRoaW5n
IGltcGxpY2l0IGV2ZW4gaWYgaXQgaXMgY29ycmVjdCBidXQNCj4gc2hvdWxkIGV4cGxpY2l0bHkg
Y2hlY2sNCj4NCj4gICAgICAgaWYgKCEobS0+ZmxhZ3MgJiBYODZfQ1BVX0lEX0ZMQUdfVkVORE9S
X1ZBTElEKSkNCj4gICAgICAgICAgICAgICBjb250aW51ZTsNCj4NCj4gSSBkb24ndCBoYXZlIGEg
Y2xlYXIgaWRlYSBob3cgZXhhY3RseSB5ZXQgLSBJIG5lZWQgdG8gcGxheSB3aXRoIGl0Lg0KPg0K
PiBNYXliZSB0aGlzIHN0dXBpZCBmbG93IGluIHRoZSBsb29wIHNob3VsZCBiZSBmaW5hbGx5IGZp
eGVkIGludG8NCj4gc29tZXRoaW5nIG1vcmUgcmVhZGFibGUgYW5kIHNlbnNpYmxlLi4uDQoNCldo
YXQgaWYgdGhlIGJpdCBpbiBmbGFncyB3YXMgbmFtZWQgIiBYODZfQ1BVX0lEX0ZMQUdfRU5UUllf
VkFMSUQiDQoNClRoZW4gdGhlIGxvb3AgaW4geDg2X21hdGNoX2NwdSgpIGNvdWxkIGp1c3QgYmU6
DQoNCglmb3IgKG0gPSBtYXRjaDsgbS0+ZmxhZ3MgJiBYODZfQ1BVX0lEX0ZMQUdfRU5UUllfVkFM
SUQ7IG0rKykgew0KDQoJCS4uLg0KCX0NCg0KLVRvbnkNCg==
