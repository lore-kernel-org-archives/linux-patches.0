Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2041C6A7
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719509503; cv=fail; b=tKi5u18PzksRUEYPmrlWKFMir+42QVHZ5bM+7OAgwpxgNQw8QaJ0tCJSVb914vAxkv0IVLQUzcfLFuzrOqj0DFB6Zx541kR1G4ZvRYcAaO3u3gvFa3hDuqRfHV29yZlvKqMEKFuNH2tgI2eUKZC5+ocvE2f/cSviUrn+6rR8s5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719509503; c=relaxed/simple;
	bh=5Ki7Kazuzc+N5qSxR0PHq7Mb5NOq33Abr8FL2geOAAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m+KKWhcT5cyKC90jeghi6HJ+BhEFAGGU9W+5eY6oMr8kM3CHMTXDv5odj0eXUim5+PUnZ+W5Rc+hC7QJwvkujI/lF8WcDjg6WOY4B6JdatIQBTwEe0LPywSxrqnDruKSXeN6w07bI0xX4ra093Z4ksM0GJOCfEY1il3A/yLBAvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AuW/W7hC; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AuW/W7hC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719509501; x=1751045501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5Ki7Kazuzc+N5qSxR0PHq7Mb5NOq33Abr8FL2geOAAo=;
  b=AuW/W7hCCLzIBn9qitgnk9vlCELKcNphw9xI0icnxEsOIFsp4MUgiyvo
   WQfHl37AiKJgxlPtP4VUIy8bubqaZvuDfM5XZuPuHuqaFExqW+Ps3Fvk7
   HMszEy1nPy7+pzH8wyUit/zGLiFTmusiqDDAEDog9QFfzBhdAZwnzon/Z
   gt230xWpXk1fn4Vna9ifFQrSq+eGzHjpycEq7OUF47Zh0L5/Z03EmCumE
   TQi2zZaW+kfKSSZXxBiaR2Auuk7ObaJsGWcPVMl+Z0cXKWLc9J8k6b3Wg
   xIru5cgmrneMReu0GkHkSVJyTz+O/1sXOyPLbXUSvnb8deLtH0fn5lao0
   w==;
X-CSE-ConnectionGUID: v+QXB8DVRvC0pkbtozSfbQ==
X-CSE-MsgGUID: 70ct0s6hQUGT+9+T1DODCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16621081"
X-IronPort-AV: E=Sophos;i="6.09,166,1716274800"; 
   d="scan'208";a="16621081"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 10:31:41 -0700
X-CSE-ConnectionGUID: U5P5rCpwSeC0IuugsANP7w==
X-CSE-MsgGUID: sasW5H3GTAyE4e8PgbypNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,166,1716274800"; 
   d="scan'208";a="44866450"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Jun 2024 10:31:41 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 27 Jun 2024 10:31:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 27 Jun 2024 10:31:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 27 Jun 2024 10:31:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyN/H+d2S6pidWHDVIk1zs2usLZbjO+9aw993mfhrp27qPlBcuNnXM3reMNtHqItredbyAlhC3RcwfC5InierSZRAsH5xXoYUvwMl4uGW2l4arUwll6Hjl2hXBtrvwMkguLpMvR44rkwCpIfnhvuvwklHOE9jHHkmqLcDAUTmdSUPvX5j5YImVaaX51cpvaxb4bHz1sYn1G0ZfplP/wgwjyWmAw7JsqwV2o+A55A+KTkNIWQi/Lt2YhgzL6tsiXWzche0bHsJkKc4cwvqVUDIj4dAOOfM/2EFxO0qbZ5uq5m85SsFIapgOjNytHJ90jWzDNt5zMD+9Kn1NhgjL2n+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ki7Kazuzc+N5qSxR0PHq7Mb5NOq33Abr8FL2geOAAo=;
 b=jUVOD/5iKA8knhiAsUAk4tNL+vrfD2DLMnLqu2yv3pdkNBJlGii2do3tT7Y7lE7RuSRf7U6JXGjlynMQ4DeNfIl0nH+SZY05y1h7ouTsL0/jgBEcqFiW7oFaFJprzwkmITAFHRM+5D+gbJaQv0iMjQOXRAV+z6dPODv7iJrvt/OBnxGXG6Vw33LGelWO9HrthW8VJFA+bTYQvB888zNbDG8NrXZvd6cRhbSvLyZ3g67MzZWLDEK6yiRo6mz/knUz+XgpwomjCes2k2yA8rAcFQtHJXhDDMnc3SWLjieemCTwQLVMnRVzglMmXKStSCGnMphHUMXHhfMgiILTltPIbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV8PR11MB8605.namprd11.prod.outlook.com (2603:10b6:408:1e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 17:31:37 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7698.025; Thu, 27 Jun 2024
 17:31:37 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
Thread-Topic: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
Thread-Index: AQHaxCviQ/AbgqqooEmxvVfuWZc2VrHZJ90AgAFuCZGAAU/+gA==
Date: Thu, 27 Jun 2024 17:31:37 +0000
Message-ID: <SJ1PR11MB6083578781B19FC3111BEC32FCD72@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-15-tony.luck@intel.com>
 <8df55906-23b1-4772-ab11-703da64d5ebb@intel.com>
 <ZnxtZc140S11gFKL@agluck-desk3.sc.intel.com>
 <d82a0882-1b92-476f-bc14-e8edb6ec43ca@intel.com>
In-Reply-To: <d82a0882-1b92-476f-bc14-e8edb6ec43ca@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|LV8PR11MB8605:EE_
x-ms-office365-filtering-correlation-id: 3654451d-2924-4598-00d3-08dc96ceff6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eXpsSEFQZ1IyNUdJNWgwZlRnYVoxbmdkNjFYUGxsRGhod2ViT1RWK0p0ZTIy?=
 =?utf-8?B?bGNqQjcxT2dGNG1SUHlLc21FMVp5MWlXT3VMQjNvb2ZqZWZHak9YTytGVmlR?=
 =?utf-8?B?bVhTd2lPYnNmNGM5TCs1c1NwcDZUR0dwZGJiTjdobjNyOS9RbDYvT1FNRGp5?=
 =?utf-8?B?OUlGbVJXZGwzY3FjZy81elIvMGhZVG9KOHBBNnJlRVlqVmtrcThIVXg4QlVh?=
 =?utf-8?B?K1ZldUFJK0lSRVE1RmQ5WjRDb2RoZENMVFprNHY2WmxNcFZMWGc4dDQvYllO?=
 =?utf-8?B?QlZWUW9kTnV1T1IzY203T3RYYzNReUt0NEltY0pRd2FRTkx3UXZmcFRJVXU1?=
 =?utf-8?B?b2ZjbUNQVS92WndHaHV6N1JheW5KSFBzMTRDZjNSeVJWMGUwT3RMMGk3c290?=
 =?utf-8?B?YmFOdTVvRUVJSGNRS1BCNkNLcURTSDlDaDJhdEJuTGJyR0hxakZQbHJCazdC?=
 =?utf-8?B?RllCM29YaFJYSHZTTzkyZS9BRWR4UUI5aUZXWFBWaENGdkdRUlI3emtpNXdK?=
 =?utf-8?B?b0FPRlRJSzRQUitsWXlCd3YzUjQ5b0FpSlVHNWVuR2VqbzZ1eWZZek9jaWd4?=
 =?utf-8?B?UHh0bk1ZaS9WY01IK1JleWNmaEd0WVhzVXdoMURXS3ZJUjhIeThTeWEyQXZ6?=
 =?utf-8?B?emQ5WUNKYUd6d3hZMmhzeHVoNDZJdTdwdVBUSHhSckRrUThMb0xLamx0SVIr?=
 =?utf-8?B?Z2MzYVJhWE9CZVl3alFhQStpTEMwRHZrWUxpOHdLcGZuNXZNcW9RMXAxSVVY?=
 =?utf-8?B?YnJvYkVoRC95U0x4N2hRTEtPU0ZHNFJwbnVuV1oxL3pUNG5YcGtjUEFEbFFR?=
 =?utf-8?B?L3c4V1VsT2pQMUVwODVya3Q2aGlGQ21ocjhsRnF1RUl1TkFRT2RidlpHQ3dx?=
 =?utf-8?B?SUVoVE9QWFpNS2gySUFMb29zMVVrc25rRXVtMzBidzkzeGQ2RnQ2TjN5d1pi?=
 =?utf-8?B?eWNab3E0SU1lbDBwQ0tUdU1ZcDgyQWtSRy8xbjVZWlh5cGtHeFZlM2RmRmY2?=
 =?utf-8?B?a2o2TXNDbGswM2I2Njg5dkdNbVZUVjdKbkxxc0pia09iakc3MjA0NkNNZlNh?=
 =?utf-8?B?MjE4Nk5CVTJMdU9SOW84TlN2d0RMaFRNMm9GUGl6bk01NENpSkZwbElQZjdK?=
 =?utf-8?B?ak9taENHR25NSEtOOFJqOVZvWkdad1A3dk5Uc0FmNWQzbE9ZNEhwT0xJanlz?=
 =?utf-8?B?TlkzaXcyS1B3Qm12a0dWZFlwem5kRzRHdzZOKzlkazljUzdLT2RVbDdrV0Rx?=
 =?utf-8?B?aWVOZTlzNnJxa2JIS2hnaTR5bVhEYnJVazhQcVVMSFhNYnoyV0V4UG9nVlY1?=
 =?utf-8?B?V0ZvLzM3WHNxZVdiUHI4d0crZ0FXT3B6V1pSdThxbE5LRDAwdU8wZkswZzla?=
 =?utf-8?B?cWw0T2Y2SHNCMDEwcUIrd0h3R05kN0MrWGVxdjNGU2lhaHRKYmk5cisvNjFD?=
 =?utf-8?B?eXRzQVdZbnFPdy9HUzloZTZMV1VIWEZtTGlNeHdDaDcrcGFRT2F0bkpUSDFF?=
 =?utf-8?B?NUI4d2RqRStnYVFqNk52N1YrbEVNZzVOd1VsZGtjWDl2VlpNVzg1eDBqVGxC?=
 =?utf-8?B?dEFqSzU2TW5jcEU0bGVxQ3NGUHlKMjdsSWlhdUdrSGJGZDdPZmtTRkN4ZW04?=
 =?utf-8?B?cjJPSE1PMDhzbFkrSVlVUGZocTZ5Z3V1RmtZYm5VSC9OcjBmS01VeXVkMUNU?=
 =?utf-8?B?YzMxTS9UczRIeGg1N3FERHhhKzVINGlnOC95K0Zzcjl4Rm1zdDlyMzRpaEJW?=
 =?utf-8?B?TFY1enQ4WUVZamVEdis2TE16VkJ1TVlEa3FaTm13TWVqQ3hWS250dUdBQUtu?=
 =?utf-8?B?Z2xDUWxpWk9sTkp4TzZKUFZNb25EM2MvSXJxZXdyRUZkTWNHVU5VY1BOeXJN?=
 =?utf-8?B?dE40MFBIUFJsK3pYZHNHSXIvcHRMNzkyY21CQ25YU0pxNlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUFUNk5NZS9SY3hJRjJBbExFcXZkb1lTMHpGTWdZZ25RMnhsMTRuZ2MzdE1C?=
 =?utf-8?B?NlVqOWZ3dGIzNlVSYXVNNXJqNnhBaUxRM29vZGx6TzQyei9QSzFDdVNlSDFM?=
 =?utf-8?B?L3RURUR3blVKcE5NUm5OWTNVTFp0eWdvTTVqMnlZcEZPS1dVd2NacjVLNzI4?=
 =?utf-8?B?aHFXcElQVCtNa1Z3eDVwM2pOOU5rMFdiUDdJT0NqMlVKemhUcmJveE1Cb0da?=
 =?utf-8?B?Vk0rZWEyaUZZWWp1WERtYmlja3BRTnRwZ3RaZUNtdkRpZit4K0grMVA2bzI4?=
 =?utf-8?B?ODlXZml0UytZZ1Zua29PS0sxYkF4T292UnZvNG56UTZxMGxndmRYbExPbS9W?=
 =?utf-8?B?TWxiSnVBWFhjSDVOdnk4REpMK3lUZGdta0FLSjhUbkVYWFVmR29YaGVBVU12?=
 =?utf-8?B?UzBkOGNDZ1hRQ2M1amdmN0dvbkpoRXoxcjFOOU5wY2c1Y1o0WWIrY25malRM?=
 =?utf-8?B?Q0lQVnk5WXM1TkJNa3JDa0pRQkpadFVQN0VVc2ZBenV5cjg3QnlOMzQwelhx?=
 =?utf-8?B?U3VIVlVnRUk1Nmd1VjRIS3p6WUtPejNIOFZUWlp6ZTZFRVdoUUkzaVB0RkIr?=
 =?utf-8?B?UUhEcExSLzU5MUdCcFAvSjgrSTNSdmdSZU1qclBTdnZqVGFkNzIrOFpqTzAy?=
 =?utf-8?B?UFVqci9kTGNGcHNHMTJOcHl5MW9XMlNvejFRRXp0a09xak0yeUxoeHVweENV?=
 =?utf-8?B?akptU29SRU1qL3JnVGxUTk45NWpoV3BFd3J0a0hKdWZkSHlDdHJFdTJOcHNj?=
 =?utf-8?B?dHZNUGN4YjBkckJYOUFIcFZzTG1pYWYxdjY3UktuUnpZdTRidHg0d0JTV0I1?=
 =?utf-8?B?MDFHdGdhV3gvMFplUzVxa0pKYUQ0ZjIrK2NMcWF2cVE3cnFPd3lONGl1cjJR?=
 =?utf-8?B?L2d5dkRsMHFzcFFKTzBBZzE2c0QxYXlRK24yTTRvd0M3bW9QWkJWM3ZlYURK?=
 =?utf-8?B?YVdObEtIaWhqemd3T1l2SmVhU2FJSlRnREdZMmRkTThWMTFKUE5DdXowczla?=
 =?utf-8?B?RWRpV3k4MlhRVUZ4YXp5WmtGdGpyT2FNOUdBYVBHSW8zRktteVVKdnZaOGFq?=
 =?utf-8?B?MG45MkFHb1lYd3JqdXJoUk0yRU1zRWlWd3FBdWZkd3hIQVo3UVBZcDU0alVn?=
 =?utf-8?B?MDlBMzBtdUtRcFY2WncxVFk2ZjJ4cGF3V3JQSDdIdzV2MnlXcGp5OXUzZzhW?=
 =?utf-8?B?ZmdXVDd2c01NUWd5UjVscXAxc1JLUkdHSjVTZ1pXclFXaW1pWkRuYS9xcmt2?=
 =?utf-8?B?YlVTaXIvQ1lHbnpLUm1aeUtoWk1LcktadVlnOWhrNWRPRHgxUGFOR0dkcC9y?=
 =?utf-8?B?WjZuTlM2cktjRDJHbFVDSU5laWhyRW9ialpKa1BULzlza2txcVBQWmJKUjdF?=
 =?utf-8?B?NTA5eEhwcU1NSXh0WEtsUTFPbDVrT25CUnRZYUk0aDJZYll6ckViTHp0MDRh?=
 =?utf-8?B?TnlFNkJCYy9UcE1IaHhJdlNzVUNGWFdEejhxQlhFQmk0ZytKTFo3Z1JyUFVo?=
 =?utf-8?B?cDJ0djRhclVIZ0UvSk1hTFVVZWU0UUgrUTVWSzlodVMvbEFhYzRGSlBHUVEy?=
 =?utf-8?B?aTM3ZFQ4OVpXVXRTUGVPQ3lFZzNKQlNzUWY5bWgvQzBhL2owV2J4Y0RlQlBu?=
 =?utf-8?B?NUhDaXBKblFCMW5TZDBvRitEQkV0WlNtSUJXbE52eTdFSmlQdEh5RHh4WDMr?=
 =?utf-8?B?T1VtbUtXQWtrU2xmT2QwaElpNWVWRWF3TFhSMjc0YTg4S3E0aXdiWjl3aW1y?=
 =?utf-8?B?WUkrQVRlcjMyZklYblFyb0xLcTc2TTg5M1RYWEY5VzNZR2IwNUlsRVpIT1k1?=
 =?utf-8?B?R1NvZG1FbVBUYVIrSE9rYTdpVFVuT0czRHp5NEE4czVaWXR5MkpXZktiVGZa?=
 =?utf-8?B?S3F4Y0luN2pMbk1haVRtMXI0NEkwRHlsWUxvNEVMeFFadS9EUk5WMDJaRDY0?=
 =?utf-8?B?UVAydi9BQkxqUkhRSElmSk5VN0VPcWFjVWsxWlM0YkdENWlEdk90RW5WVmlR?=
 =?utf-8?B?N2gyK3NqTllTTTdkZkREMnNKaUxkVElHaS9GQ0dGVFBKMHA1M1ZzVUhHcG0v?=
 =?utf-8?B?ZXE0NVpDalZhSHNvbTFkN0hUY0ljVVlNZlY3citJZFNZekx4UTN4WEplN3Jt?=
 =?utf-8?Q?UYb760br/9URzuy7bfqQ3YniK?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3654451d-2924-4598-00d3-08dc96ceff6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2024 17:31:37.1966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3d9Zn/qMIYJ2ZrCDEHRdIMV6xLx4y5PSKgYMIJgF1efzAvdV9osTdhG7ky+kMp9akeclO/dUcA+MVvZ9/1/7dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8605
X-OriginatorOrg: intel.com

Pj4gT3IgZG8gdGhleSBzZXJ2ZSBhcyB1c2VmdWwgaGludHMgdG8gaHVtYW4gcmVhZGVycyBvZiB0
aGUgY29kZT8NCj4NCj4gWW91IGFyZSBvZiBjb3Vyc2Ugd2VsY29tZSB0byBrZWVwIHRob3NlIHlv
dSBmaW5kIHVzZWZ1bCB0byByZWFkZXJzIG9mIHRoZQ0KPiBjb2RlLiBNeSBnb2FscyB3aXRoIHRo
aXMgc3VnZ2VzdGlvbiB3YXMgdG8gKGEpIHN0b3AgcGFzc2luZyBnYXJiYWdlIGluDQo+IHN0cnVj
dCBybWlkX3JlYWQgZmllbGRzLCAoYikgdXNlIHN0cnVjdCBybWlkX3JlYWQgY29uc2lzdGVudGx5
Lg0KDQpSZWluZXR0ZSwNCg0KSSBkdWcgdGhyb3VnaCB0aGUgY29kZSBhbmQgZm91bmQgb25seSB0
d28gZXhpc3RpbmcgcmVkdW5kYW50IGFzc2lnbm1lbnRzOg0KDQoJcnItPnZhbCA9IDA7IChpbiBt
b25fZXZlbnRfcmVhZCgpKQ0KYW5kOg0KCXJyLmZpcnN0ID0gZmFsc2U7IChpbiBtYm1fdXBkYXRl
KCkpDQoNCnBsdXMgYSB0aGlyZCBhZGRlZCBieSBteSBwYXRjaCAxNDoNCglyci5jaSA9IE5VTEw7
IChpbiBtYm1fdXBkYXRlKCkpDQoNCk5vbmUgb2YgdGhlbSBzZWVtIHBhcnRpY3VsYXJseSBoZWxw
ZnVsIGhpbnRzLCBzbyBJJ20gZHJvcHBpbmcNCmFsbCB0aHJlZSBpbiB0aGUgbmV4dCByZXYuIG9m
IHRoZSBzZXJpZXMuDQoNCi1Ub255DQo=
