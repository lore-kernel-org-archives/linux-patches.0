Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC7059155
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718990066; cv=fail; b=knsJzZ7KJU9Ne+m+D53nCtRswDziiJS+h5hYqroi7njwRhyGp4mIJNaHpYzFzSXU2SE8aQJfDJierEiNtfoqFzwxOfPp0suL5yjHkUed+igcEFckX2ldYD+rYqA7Y/lwV8GivEY70lQR6dDUqO/WH05/EDw3YkMP6E7n3ABuAX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718990066; c=relaxed/simple;
	bh=Qg8ztF8dCBAy7kgpsfPA2I9OEs1mGYBjAou/gosuTyk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f6SyowmVlSTV53syI1fTlv1OUtEouWY9xx65yzK3j/WcpTcBVcg1ofNT1UfqPMCRqeUh0FyYFXpSlACHscuKojFFWYIlsbIXafL7o0XwtL1Vwo2KSEQBppfiwFXYBgy71C4jTCVlB5vnQryjanxinCcpUIbywQ/Hh+Aqx7rxBLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H6u/qZQh; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H6u/qZQh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718990065; x=1750526065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qg8ztF8dCBAy7kgpsfPA2I9OEs1mGYBjAou/gosuTyk=;
  b=H6u/qZQhvIxUb93mOqzJ65EWIgZVtaGYbgWicxP3nVNm5dHYLHmT1l/L
   prHHUqaSZQhyrl/DJe8SYnDaw2BH7AKXt6h11hP4+ShQV2ua1U9AN2sot
   xi2lj189rNij2mQqifS9mGONJksHvZrEbkK5p1GCJ8YzVxYMv6e0rKSI+
   gSJFxoQmKOY2c0wk5v2e4O8zMn1NfkAqcFoKuF0L50ARrVJzLbD/S35RI
   u2oaVfJxO8MYmD4A3AdRK/jOhO0T5N8ZOF1/SBLmrGrqTbjMM9PL/6Gem
   Kc3XdMxBF++x5QctCwhSB/KrXud9TPaHr7r9lufNBBYVZftA6lIuwsmR9
   g==;
X-CSE-ConnectionGUID: t/1N36euRDq93P74+E3AwQ==
X-CSE-MsgGUID: 15MBrjtmTZSmIt5z3rux+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26660697"
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="26660697"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 10:14:24 -0700
X-CSE-ConnectionGUID: y5y1ndhCRgWiDqsKjs0mfA==
X-CSE-MsgGUID: BaayINGvS/icHCcYDIVDpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="42726886"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 10:14:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 10:14:23 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 10:14:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 10:14:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 10:14:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpDb8B1Dhh/ObnhqSZn5+1gX3agik+Sc9gx33lpMR2goLmD85tGNZ5z2j/7VpvDTcyRaDTry0XyFgGlOaEtqMJu/1TsvgicuBLOdKNyZyg/7Cl8zp47xOYYh+O2/U2Zh06dETO80zsWc2xThd+nHQrLXE8xLqDX54Z0ZXCIwRw6u+c2zB5Aq/Pi2X23TRpmNlGC8n+MnN7P+0i5JRVzjyKsnmtQxML7/Krh3VEXWyK/WBJUTSZeM9GxF972RvTq/7dsjyF0BDjmvPiwiGdnAgCKY7dzfXiZAnUV9nImQnuX/oe9GGsFOjGGfDLqMgybJyQpbcCFNpHHZAG5Usrh89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qg8ztF8dCBAy7kgpsfPA2I9OEs1mGYBjAou/gosuTyk=;
 b=ltUMVlo/Rsuy37j6c6+jK8Fs4mhY/vwl3XYpdHEQVI3HyUx3ZmVXjVu3nbkw6wLbmVa6U5opYXyOm8C6WpVfly1ggQRzGZGb5EaubKwyF5Krr5YZgsjzBnc4OM7GXv65tHveHOGvhEHZZzP+8P03n8b1O0oVpq/JnIFa3BSag5rdtxD5a3SK3jxFKcEuZjIlKKBZZjoeXgqfUqSWfmeSWkAAPYLMjdMhvNYOP/HezBA0pHegbLTsDSNPgxcyeAYUj1HLUE19TCYtvoK5MuYcUMxzQd8+sbaeq0XggHLqXU5IWAcDgynpFP9TZXOQ4iUZyZsTU1vAhp649bMybhGGWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6273.namprd11.prod.outlook.com (2603:10b6:a03:458::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 17:14:15 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 17:14:14 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>, "x86@kernel.org" <x86@kernel.org>,
	Babu Moger <babu.moger@amd.com>, Dave Martin <Dave.Martin@arm.com>, "Drew
 Fustini" <dfustini@baylibre.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"James Morse" <james.morse@arm.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v20 17/18] x86/resctrl: Sub-NUMA Cluster (SNC) detection
Thread-Topic: [PATCH v20 17/18] x86/resctrl: Sub-NUMA Cluster (SNC) detection
Thread-Index: AQHau2UM+QjgYuLmIkq4fLfnk7RV9rHSg7IAgAAAtqA=
Date: Fri, 21 Jun 2024 17:14:14 +0000
Message-ID: <SJ1PR11MB60838E655CB373A762F66851FCC92@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-18-tony.luck@intel.com>
 <c9a00f59-eaa7-40a9-a118-66f87b11c118@web.de>
In-Reply-To: <c9a00f59-eaa7-40a9-a118-66f87b11c118@web.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6273:EE_
x-ms-office365-filtering-correlation-id: e40b559d-f6e6-4e3a-7908-08dc9215936e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|366013|1800799021|38070700015|921017;
x-microsoft-antispam-message-info: =?utf-8?B?Z3RmVmUxUzJIWGJBTi85K01UWWxXenZlVnFGY2VjNTRUTzdYQno3VFZKMkRr?=
 =?utf-8?B?ODlPTFdrWVoyU3h6SE1EN2lMMVlHbjNsMERwbWRtS2xweDJ0aU51UVJBZEdu?=
 =?utf-8?B?V21vZENkbnc5aHlzbnlIaExrR3ZpYmtPbXZLQXFtbHZEVlhPV2J2ekRSNVZx?=
 =?utf-8?B?bVZSSU1aSzhTVGNvNkhBWWVPQ05EQ0pGYmlubHRaeTRGZG10VmgzL0tnc1Vi?=
 =?utf-8?B?d3BKeTIza2FiZ3Nkb2R1Y2FMY2JxZzFROHNiYStMbDBReWNkcytiWmIxUEps?=
 =?utf-8?B?dWFsSzBRQWlQZXYxaThMQ1BGV2grYkpWUW00Zm01d3V4UTBsaVJWcW9PQTYv?=
 =?utf-8?B?ZDh6cTFqbWVoQVZGQnJDZHdCMGpFTFlQNWx1K3k4dExIcWpVaVF0OUU5Rk1O?=
 =?utf-8?B?S0ZrMm9heTFITWRUN24yU2U1VFVrYm92bWNzSTVnZ2R3dHlXa2Iyb0NLWGFN?=
 =?utf-8?B?UWxXaU1aZFhIS0hrVStydk1LS0xHWDVQcTBxSENlYU5BUUVVbnQ3UmhHV0FY?=
 =?utf-8?B?Z0YyVUZMWEUzYTBLSFExUWxpT1hjY2plRHR4Y3hCQ3FTOFp3Q3lod0ZMWC9m?=
 =?utf-8?B?WG8rRmpzbThEczBEQnRORWwyUzY2QlZnSGJqd0NUc05acTJNUndaYTBjVW1x?=
 =?utf-8?B?SmpYYmNDN3RDdlpNeGJ0bzA5ZlpmL3JESFQ0MG5JMFM3VzJETTNGRWZLbkU4?=
 =?utf-8?B?VngyWGs4b1BiZUdWTFE4bElNZTN3ZW9hVVBwWERKMkQxK0F4NzRXNm1CeEgx?=
 =?utf-8?B?d21Bdms3cW5HRVV0d1IyTC94NGNvbFNIaDVLOVFBR01SS1kwZkFOT3ZmNjA3?=
 =?utf-8?B?MGo3VFlIcDFJTVZIeTdLSG4wQjBOM1NzUFdKaW9qdG9STjJDelkwNG9zV1ll?=
 =?utf-8?B?MkRGTkwrYVMrSG1WUWtjdGRQMVphclZzb1RYRW93ZHJJQUh4KzZsVkNhOXFp?=
 =?utf-8?B?cmYyUzl4b3NsNHVTTGp4dUtDc2VEUzdmcHVxVHpmdEF2d1hhQ0I0TkJsVERE?=
 =?utf-8?B?Q1J2R0dXMkJWQTVNS1V0UXpDZU9WNHJoOG55UUh2MVVMQmRWMjRKMSthZDdt?=
 =?utf-8?B?dWRpL0ZOcFNDa0IvVThUcmM3cXY0TjhVV0FRRE95YytsSlBHMmpCYkRFM3Vp?=
 =?utf-8?B?MGV3VDdYck5BNTJuMnhXUUdReUE0UWFvRTR5QTdTSUNvcU5iUk44WDJsdzhQ?=
 =?utf-8?B?TkhTaVB2Ni9RTmlLVGc1M2srQ0VXY0VJMXZnQmFXRnhjUGxxZHhmTzJEajRT?=
 =?utf-8?B?S0FVOTJjeHNSS3FVUk1ZWE9iOUdUNlk0bmFXMFl1QXZEMThpWnBWSXlZM1ph?=
 =?utf-8?B?RnBqT2MzZmluRkRqb1Y0RHArV29DclR5OFd2KzN2VHF1Q1FKOWxWZndSdGxr?=
 =?utf-8?B?cHZiR25sellJaytmZElZUDJhcjhGSXN0cW9RS0JWaEJ3ZkdLb3d4dHRUcWl1?=
 =?utf-8?B?bGtWeTlvdkNJWFZtOGp3c0s1WFYvd2NMZ2xpeUVwWUpGdVllMk0ybCtXV2RX?=
 =?utf-8?B?dFBsL0ltZXVlWmxtelVqQ0dBdGlTQTJJYXdZRWRDMjFmVlZ1UWlpNkNLMXU0?=
 =?utf-8?B?SUxuOG9jRWROWDQ3elBuMEVQd2E0citUT1F4MGMwUDlabFFGZ0hERlUvdzNV?=
 =?utf-8?B?WDlCaDZJd0JUSmpINHVjK0tldUZDVnlPaVlWRDV1VytHc1psYzJIRTNKekZq?=
 =?utf-8?B?ZnRCMUp1RVdZSEg5TFppdWRWRUg2enVodHZBelh6Sm9ZeTVSL29HOGtxc0JE?=
 =?utf-8?B?eGZtc0hDU2xUQStSOFFVKzIzM0o1b2VFd1l6V1RYZWx0M3RyczRDdXUwcHlP?=
 =?utf-8?B?NGhyWk0ybnhMQ3FLWFpJUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021)(38070700015)(921017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEJNSEQ4eENnaENtS3ZPZStTODVnUU93Si9iaFFBWmFjeC9IbjVreDRiZ09j?=
 =?utf-8?B?bHhxdnVTM0FnVCtseWdQUjEvZFpxNW9xMXBxQmI1S1hkdC8wdU50UTJqT3JD?=
 =?utf-8?B?dTFFOG1HSlZVYjZ4dFVUL21MenFqbk41UkpFL1RMcTQ0OVFMTS9Md2dNcWVD?=
 =?utf-8?B?ejlVUmNsdjl4dHk5WXdsMWxnVWpIR3hXbUQxU3ZoUFdLVkV2RFJXdytrdHRH?=
 =?utf-8?B?YzhrL1RMWG5XOTVJUUdoNDA4WkQxSnFLS1cyem5RTzBwTmFnMGpEcVpDT25L?=
 =?utf-8?B?eXlVK1pqc2RkMGo2RWpLL3FEZHpENEJadlJTdnRRSythUk9Kbmh3clZQUVIv?=
 =?utf-8?B?YXJsazBVYVQ5ck9ZcE1GaG5qTEV1T2JaRWs1SzRHQUZUd0w5bmZQMmdVaUVo?=
 =?utf-8?B?Q3VUbGtJUWl1cFZDK2N2TTMzc0NqRWZzUXNmdmViWXppMlp6ejIvVHg5YjlH?=
 =?utf-8?B?V1NWeEJoeVNvRkVEaUVVcXJkcUhma09GVUg5ZUlDT0RVVEFhTmwzMXNhNXZi?=
 =?utf-8?B?cVNDK2FJTTF5bmh1d3RpNVd0dlZKSGYzYmRzMnpoQ2NoVDVlVTA3MnlydWdG?=
 =?utf-8?B?ZTloY3p0WWc2K3FGTjdaQVk5aXhaei9VQVJxYU1DRVVHYXVUcUdpcE9STGZC?=
 =?utf-8?B?alBvZUIwZFJzcE5OUStxTjhQUlJYMlh1VkY5bVBjS1VzTTBieXEvanNLdm1p?=
 =?utf-8?B?b05HYkNHakhCWTBDZGljWmZsZXpzNTVXT1NFUk55QXF5RWYzSkdmNE9kVEJl?=
 =?utf-8?B?VzNxMXRrWWhEVEJNTk11T2VIc0RkZnZPYkppV3ozNUtkUzB6c0NwTy82VzJW?=
 =?utf-8?B?QmtmZHliWjdQUmluVCt2cUo1aDlkOVVlcHNpZWZuTGMrZlZ4Tzh1SFFENmJE?=
 =?utf-8?B?Rm02eENuMXE3am1CcWNxMUliOGR1Wm41SUZZaEFWSDVwRWlybTh3ZGNnUWc4?=
 =?utf-8?B?SmZ2Sk10Rm9tTjd6c2lGZFlLbDNjcWRxT1dBN3k4NU1IdFJTNzdTZ0JwNHNQ?=
 =?utf-8?B?S0U1MDFJSVRJK2V0ZS9iNk9TRUlLT0JoaFUyY3hoU25RQTNOYks5eVNkNkx3?=
 =?utf-8?B?bmtFUzRHa2t1Rkk0dGRaNHo3WUhlY1R5Z1lUN0hCMFNNY1JvV2xING5jakcy?=
 =?utf-8?B?M2lFOVFhRGtGaElObHdJKzgyNkIrL2Q3T1Y3YUFxZEJLTXJaNWhKZ0tTbGdn?=
 =?utf-8?B?MHFRTlNTODNXN3JLcDk3MkJpVEZzK252WlZZQ3pHellYa1dNeEFoanA0SDhV?=
 =?utf-8?B?bG9sWVA1MzN6aXJ0REQzTk9ka252dmUzUVNFM1VVQXNvL2ovdHJEUThqWVRX?=
 =?utf-8?B?RGQ4MDRkb0Q3VVpXbzJyMWNpT3ZsSERFYytxOHNsc1FrYnV6VjVQd21yM1hB?=
 =?utf-8?B?RnR6KzZsdU5Gb0k1WVBoZU92d1k5cnV3eDZ5RzVEanFONjdIaVpVd0oxTmFq?=
 =?utf-8?B?YWZXU0hhOXdZQ3VsZkFCZjBGVkYxN0Z3MkdqQXY1TGN1UjhIR3VjQ1ZXTXY0?=
 =?utf-8?B?UzcyZitFeng3WS83bktMRVdXdVFHbERhUUZ6NHRiYVdqeWdNRFZOeVlHR3pa?=
 =?utf-8?B?YjRoRGVJejZ5STdGUnU4SGpuY3UrTTByV1RZRUlzQmRZQktlVklCaDJQbVdz?=
 =?utf-8?B?bEM4NkM5WjRPYngxOXpCNDVUaEtJWnVVTWNkSThzUmJtSW90QkpVWFM4eU1t?=
 =?utf-8?B?dndnVStVZncyS29EeTFEa2IwRGF3M2xRSW5xZTJzTkVWeXFyRGFmS0RJVDJx?=
 =?utf-8?B?WHBNejhyK3orSlMzRTJCd21RQThIYURBYXAwYW1hQzhFVkVWYmEzUmhrWEdZ?=
 =?utf-8?B?UDM3RlEwSXVFL0hKT1ZNVmZvSk45d2MyMEVISkpTYjdXUXVwRFFMY0wxVjdy?=
 =?utf-8?B?dnlNb212eGpqNHc0SWdEdXhSWlhpdE9QNEpLY1hIeXRRM24zVkE3aC9rcnpL?=
 =?utf-8?B?dU5UWnBwdzhLTVNmN0lhS0Nqcmt1VGdRR1MxUVBjNCtFT25oWmNDbmlGaGly?=
 =?utf-8?B?UEl3cDl6d0w5QW5yTDVYZERYZDJtc0QybVdTOGVOaEhYa2tlZHFUWXpSaUhy?=
 =?utf-8?B?VGNpWFE3bzVPSlQrNTRHMFBwdGo2R2RsYXlIVlFpeHhvNFAybFRuL05MR3Zv?=
 =?utf-8?Q?gD6Ub+8ZzR6spKG2FUZlJaZOy?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e40b559d-f6e6-4e3a-7908-08dc9215936e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 17:14:14.4789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myA1bTxNLAW5NnLOsPcSuPq+g+AYolqPHuNIGxXHwripxa3kXswA4OeXQ28vJC9PHvgf1wvGaxHevSpSKkVtTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6273
X-OriginatorOrg: intel.com

PiA+IEFkZCB0aGUgbWlzc2luZyBkZWZpbml0aW9uIG9mIHByX2ZtdCgpIHRvIG1vbml0b3IuYy4g
4oCmDQo+DQo+IEhvdyBkbyB5b3UgdGhpbmsgYWJvdXQgdG8gYWRkIHRoZSB0YWcg4oCcRml4ZXPi
gJ0gYWNjb3JkaW5nbHk/DQoNClVudGlsIHRoaXMgcGF0Y2ggdGhlcmUgd2VyZSBvbmx5ICJjYW4n
dCBoYXBwZW4iIHByX2luZm8oKS9wcl93YXJuKCkNCm1lc3NhZ2VzLiBTbyBubyByZWFsIGJlbmVm
aXQgZnJvbSBoYXZpbmcgdGhpcyBiYWNrcG9ydGVkLg0KDQpJZiBpdCB3ZXJlIHRvIGJlIGJhY2tw
b3J0ZWQsIHdvdWxkIG5lZWQgdG8gc3BsaXQgdGhpcyBvdXQgZnJvbSB0aGUNCnJlc3Qgb2YgdGhp
cyBwYXRjaCBhcyB0aGUgcmVzdCBvZiB0aGUgY2hhbmdlcyBhcmUgZGVwZW5kZW50IG9uDQpvbiB0
aGUgcHJldmlvdXMgMTYgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcy4NCg0KPiA+ICsrKyBiL2FyY2gv
eDg2L2tlcm5lbC9jcHUvcmVzY3RybC9tb25pdG9yLmMNCj4g4oCmDQo+ID4gK3N0YXRpYyBfX2lu
aXQgaW50IHNuY19nZXRfY29uZmlnKHZvaWQpDQo+ID4gK3sNCj4g4oCmDQo+ID4gKyAgIGNwdXNf
cmVhZF9sb2NrKCk7DQo+ID4gKyAgIGlmIChudW1fb25saW5lX2NwdXMoKSAhPSBudW1fcHJlc2Vu
dF9jcHVzKCkpDQo+ID4gKyAgICAgICAgICAgcHJfd2FybigiU29tZSBDUFVzIG9mZmxpbmUsIFNO
QyBkZXRlY3Rpb24gbWF5IGJlIGluY29ycmVjdFxuIik7DQo+ID4gKyAgIGNwdXNfcmVhZF91bmxv
Y2soKTsNCj4g4oCmDQo+DQo+IFdvdWxkIHlvdSBiZWNvbWUgaW50ZXJlc3RlZCB0byBhcHBseSBh
IHN0YXRlbWVudCBsaWtlIOKAnGd1YXJkKGNwdXNfcmVhZF9sb2NrKSgpO+KAnT8NCj4gaHR0cHM6
Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTAtcmM0L3NvdXJjZS9pbmNsdWRlL2xpbnV4
L2NsZWFudXAuaCNMMTMzDQoNCklNSE8gaXQgd291bGQgYmUgYmV0dGVyIHRvIGNvbnZlcnQgcmVz
Y3RybCB0byB1c2luZyB0aGUgY2xlYW51cC5oIGhlbHBlcnMNCmFzIGEgc2VwYXJhdGUgc2VyaWVz
IHJhdGhlciB0aGFuIGhhdmluZyBqdXN0IG9uZSBwbGFjZSB1c2UgaXQuDQoNCi1Ub255DQo=
