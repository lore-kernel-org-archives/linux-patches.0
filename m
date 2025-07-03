Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E7F23BF8F
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751585423; cv=fail; b=qcFCxquVIXOjPcggFEuyJmlsMzv9ewyaf9kxjhfu5oOyfOcrIxi+2xMVzCZ61OcYt8VtnWLreb0dU63lFo3Y/QzzEuaDAX5qnjjjz7x9hMyR9nBsM/cSb1DObAQZQXzzn7vGFB0us2jbWXG/6EwLXGi53sUQYAUUTW7p9vPD1m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751585423; c=relaxed/simple;
	bh=YeLihmpWT9smChcj5ClMHXBHocaQ1jdu5FPmLhHs6fg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FjRyE3CPrVLvYGWunFN51/FK/bOa87uN0TG9/DtHrHZ8z3bgBOX4j1dDcOwFqYQ0eDt5fOfnmDk0SiNKzkbndsx+qQtmjD812Ex8yiEUH39wGQt5bNG5Dq3wM57qRLMeZdOb6I7143skpWBRn4x5E+M0h1TnUGlh4OPWRi6lOoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCe4YOn0; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCe4YOn0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751585423; x=1783121423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YeLihmpWT9smChcj5ClMHXBHocaQ1jdu5FPmLhHs6fg=;
  b=WCe4YOn0F87L0A6whojblN4slGJh30OopkJwiKEWGTHkGmu5P56Ihjx5
   h380fJqSexBy7jORx+DZ4R6WpzNbDSebgPg8bx8sREDFbxuhiftugZjgK
   +Ghwk9ozkoKFmyhBohT+YhxlIL/91FOroYIB16QVkEfyYVX1RaGiPrWVB
   kpAhYJCUNX2JMNuSb/E6RARoKT1T+S58tB4gLlKSGDZRuI7J1z+bx/D5u
   amrR2afWpC6tKDiWPPdH5f2qwp1jMJgZ0YNhlfPC4wDoKr2xBaVwrvPTg
   Gtqun6SYH4qqOls45qF2snGWNA5aiaNAXBSsTa9YUjumhXeR9dC9/+ijD
   w==;
X-CSE-ConnectionGUID: UiXTYGNyRqy04AFVb7bbig==
X-CSE-MsgGUID: /WtCBssbR5escWUmpUV1Aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53643890"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="53643890"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 16:30:22 -0700
X-CSE-ConnectionGUID: sN+5CM/qQ52YTlccLqPLWw==
X-CSE-MsgGUID: bS9qwVXMTiyxLFgTA9TRKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="154635257"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 16:30:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 16:30:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 16:30:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 16:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTtMWqUCGORsDFoTTUsgoxweRnB5yPb3gq8CaaqC8JWfSgJUzTVArB0i5QV9a2WuEJDa3MEFZ7a36dtYPw5bu22WP4+eQc0plnjNqliIuiLv/xdQgO2FDr6wOkQ6Uak9fL2DR7RAYwOZ9lypXyTeEjpq5K9qREY4DeDEg+dSfD1zsKGIGaBQfnc4nxD9zfSm/Gz/sNuK+VKcIzMMAC6rDqE9RCVYeE1ACbGZm4MpDHz1aLsW5gG0QVcnYvhtdC7pjTOSoC7qNj052YObMCpNvHeZ06IlBdZmp/7UgJ1liXIyO8ye7zUBWb6cPLhrcDpbeGh9x0AXzhVCXgHv6wdOtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeLihmpWT9smChcj5ClMHXBHocaQ1jdu5FPmLhHs6fg=;
 b=S/SkgMdQPAusDSzKS0hTBbTMa5J+/SjEOGwi9tZAqwItvkAgEikQ46S+19L7aQB+o29F1FCsTvf+7UixaeMui5va4IPe8uvZsKJRuJQRYT3PMCxQoVmiqGW5qEZoMGcYTWbiS9WV5uaWZtGY1/EEPsdnorwCkwE/P/15y2HFY3pVRDkYTyunbeOv78cbRxfqMoOGSZyMR+cFcwHJ4z+kmxrB8ylrs7jGkL9Io01JaTNEotjE/QSERj15pB+RZtbsiIUsgwLjqMoMIRhDhF2s0WMWUVt+R49kRpGyFt5m1EDd+Gj9MaWVgr62V0yUekJjIGZkCJ9ckLPa2LGTYG2pIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM3PPF67FA1A8F8.namprd11.prod.outlook.com (2603:10b6:f:fc00::f28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 3 Jul
 2025 23:29:52 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.8901.021; Thu, 3 Jul 2025
 23:29:52 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, "Chen, Yu C"
	<yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
Thread-Topic: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
Thread-Index: AQHb5rpf9lR6YyLnOUKm4qRBOzTJW7QgwsgzgAAipdGAABjySoAAGAgA
Date: Thu, 3 Jul 2025 23:29:52 +0000
Message-ID: <SJ1PR11MB6083DEA8AB1E519B14A73414FC43A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
 <aF7dt2iQpvuahZil@agluck-desk3>
 <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>
 <aGblc2VimjIiy_bY@agluck-desk3>
 <bb9b5ee5-3367-4193-9e07-747b1ab50637@intel.com>
 <aGbyA-TVAdG5uUBk@agluck-desk3>
 <a1df0e8e-3d80-4d42-85c1-71e014d177aa@intel.com>
In-Reply-To: <a1df0e8e-3d80-4d42-85c1-71e014d177aa@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM3PPF67FA1A8F8:EE_
x-ms-office365-filtering-correlation-id: ed2ae440-71bc-40fa-7488-08ddba8982a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aHJVZE13RUhCTXNQOGxKb0NCS0NSa25wUG8ySk80UVVFZzM1REpwNzFSVy8y?=
 =?utf-8?B?V0hPSUlVOGRGbUtnQmg1OE5VTHBjV0kvMnk3OVZzWlRFMFd5WGNCSnBqV0RS?=
 =?utf-8?B?RnZrOVdseUtKUEZNSnNqZ1YwZ29XS0V5eGVZUVNwQmhBWFFaZFVqWHY4cEcy?=
 =?utf-8?B?Z2JTR1Jid01DY3krYlA5cXNiNkM4WHFWUDBOc0lib3JXYnhWd2xQd1JaWC9F?=
 =?utf-8?B?MGVKQnRpeThxeFV1bmJwN3NkVlUvZlpyc2ZLb3FCWWF0OXpCUWxpNUVEYWlT?=
 =?utf-8?B?bndGZ2dhZFdZRVBDZ3Q0alBETW1oTk5RWVEvbjRvbWZkM3ZYR0ExTGFvWlN4?=
 =?utf-8?B?bjRxUUlqaXNMN3lmMWdheDhpUWZiM2lRaVRaUjBLNXJCMXRXa09UMzE3VDA4?=
 =?utf-8?B?bGpTaHNISHhaZUFUVEt4dnZhU1RGOFJ0Nmh1UHUvbGwwL0kxaUU0L2czOXJp?=
 =?utf-8?B?YnF5eFJpM3RhT3l5dDROdyt0WTcvdm9vMlFGY0U0SEdaZGlZUFZ2dXhQdjFN?=
 =?utf-8?B?eERzUXJLUmRrVU9aQ3cyMlpHQ0E0cXBCSFNuQnFaQzI1ZzRSeWRGclJDWkp0?=
 =?utf-8?B?S0lFRjFjS1F2QlhkNm9DLy9ZTHkxZTlPSWxGRDNHczNHUVdVa1J6V1BPOHZ5?=
 =?utf-8?B?b212WkhUdHVaK3V5WkxNcldmcjNPRjVJV0Zqc0k4RGFiUUkrR0tiMWFHcDQ0?=
 =?utf-8?B?UVE2bG5CeXh0L0pHQ2xUek1vQ3o2N3phNmRMV3JVZUJxL2Ewbk15YjJCVmhp?=
 =?utf-8?B?eDdNRTNxQ2pjQkpoRDhrbzR6eGZxQW5pNXBOMlovSGwyT0NtSzlUZFR6TG9v?=
 =?utf-8?B?bTJHWnVnYzhvNWN3dENycTVUUzRub2plVkhWbkE5b1c1eENkbUErRnV4R082?=
 =?utf-8?B?WlAwKzdyTW1BNXgwZUQ3SDNKQWZGL3JrVTBhN25rcXgvZmZYeStOT0xldlBE?=
 =?utf-8?B?S0t6cmNmVEhkamxxTTdrdFZtTE85c2t0cVR0aVpRWEtiNlJVMkhoVnhWRlpQ?=
 =?utf-8?B?VzdQYzRZMjlHYjBLcGs5WEtzVVN3NVFyK3M4N04xQytnVjREMndGVFpkaDho?=
 =?utf-8?B?U0NZRlErOE9BdUpuRWNScnZYL3JMMVdVYlFNZTkwd1VmWUNWYUNJMHdoaVoy?=
 =?utf-8?B?bVUxVmdkZGJiKyt0ZUF1ZFBIMXlzdHFLNzE2ZjlIb1NGcFpSMzVEUWpKWmFE?=
 =?utf-8?B?dU81M2ZEbi9ZMnFKSWY0TUYwMkJzR0R0UTREYkhwcE1LbHljZ04wUS9Mbmxo?=
 =?utf-8?B?aGpvQ1JuTHJZWEE3VFRRU0RIQ2VEUjdzUCt5azJrTjFwMHYwSXMxOWpMYTR4?=
 =?utf-8?B?d01xUDQ2NEswZ2dwNzA0eElHWnFSZ1lZek44NjJVUTJFZTlkM0U5UER4UnFq?=
 =?utf-8?B?djF1cndjMklGak5PYVI0N1ZZa0NnaWxnV2dYeUlVZFNKclBLbEx1UmtTWEtJ?=
 =?utf-8?B?RDhETUk1TGhSVDlsSzY5NHg4UndqbmZlVHA1cEYvOTI1ZUxkTzd5bzkreSs3?=
 =?utf-8?B?K3J1d2xlR280ZUJlem9yYmRHWVdJUHRMMXhvcG51dS9FZ2E5MXh0VTlBblUv?=
 =?utf-8?B?RXA1Q05BcHB4VTRMSWJ3ditQRHdNbm9zOUtSMVJXVXd4UUNHNkpYTDhyTkpu?=
 =?utf-8?B?VGh5WENac1ZvbFk2ZUFYemR5WXhKN25Kb1hRUTR1RS9iS2k2bEN4U0FNWE5h?=
 =?utf-8?B?bmUzTWE4TEZqdjVzS2JqN0t6OXArNU42VnBYUXB4ekZsVEZ3ZGh6dWNmWUNH?=
 =?utf-8?B?dDlpZ2xMSDVLYTUzbzJ2TkZpUTgxVmdhdUdSNFNGd3U2NjJ2R3R2bjhZYnQ4?=
 =?utf-8?B?RjgyVzRvYVlZcVFQTXJTblVqQXRhZzZ4WTVHZWF5TUIrQmNXcldNTmlOQmxV?=
 =?utf-8?B?bnhHR1J6Rk4vTTRqWGZCMW5ubzUxWWt3Y3pmWHl3SE5ZeUNJekowTnI2NGN6?=
 =?utf-8?B?S0NFNVc5VzlnTC9WOXNYbG9UdjRPYzZNemx1aWZxT1hMQmNRQW94d3ErVEZO?=
 =?utf-8?Q?2NZ1FYKIToDHkKksS7ojBVhW93/KoQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDIzZ1pxcjVTNlhTS3JpMFFOdEdJNVJsTXB0OU01c2dHQVBadWlkaWV4STdH?=
 =?utf-8?B?VW9WbVdsYnJYdUQ5ck9zTVFUZVJVeGE3c1g5ejBVWHZmdnZFQ0RGMlVhcUJS?=
 =?utf-8?B?Kys4ampWb1l2MlNCa25WTHFzUFlwSGJDS21YcHRPVys5aVRhSUdUSU9kdnNm?=
 =?utf-8?B?UjFpak1vYkQ3RktndFN5WlZ1bVVHa1huWDRybUkxK0ZwMng2ajVrYTdmNHp0?=
 =?utf-8?B?YnAvM3hRN1k0Z1ExaWJWNDc3a1k1L3dVZkQwd0N4bVFJZG1CNGpXMWw3bndF?=
 =?utf-8?B?N2ZpbWp1WkxHV0U5UzZMelJ4MlQvN2YzWjc1eVg2RDNkaGc0a211WkliSnhz?=
 =?utf-8?B?eXYvSHh4cGsraHg2SGkxclBWbjV0TjNWcEJJSTJKbHpRMDlNRnpQeHh1cEZt?=
 =?utf-8?B?M2tyZEhwblp0Q0EzMUF4TnFQS25hZVdCZjFzNnI1Wk1QR0tuRC9Xb1R5c1B5?=
 =?utf-8?B?UFVUUHFIc3hKeDZNYWpOZUNONi9LWEJZSUpmNmliSEwwRHhIelRtOFhrWUVs?=
 =?utf-8?B?MmVhcnNMZUc0U0U0VXNUVUxnRmFkdjRlRjF1S0p1Y08zdWw3MWNLT2wzakdp?=
 =?utf-8?B?Z1BiOHFIMlVuU1hZMENKUEZrSkJOSVl2ZDJKKzFFTHBaczljcEtiMEdDZkdQ?=
 =?utf-8?B?Qk1LaTgzM1d1Z2MyVGpxMk44QmdjMU9NN05ZOXRHdnVVVFU0Z0Nxa1hQUjZo?=
 =?utf-8?B?TGdnQnhjY0l4VWxQck4yZnpwUFhwWnBBemxmNkRrL0lOdUIwblhiSkI1QXRE?=
 =?utf-8?B?TUdZb1FLdVNJZHMvOUV4SmZPOHpDV3pWNlhCZWY4VU5rWk8yQ0lUV0puR1Nk?=
 =?utf-8?B?ak1tN2c3UEJmTXJpNVl4UzVuNFpORGlZbzVJNWZhTjV5NGFoVjVTYjZldUZQ?=
 =?utf-8?B?azRWRDNIc2hhZlFPUUpxT2YyaHNmTkxoaXl5Q25qRDc1MnBiY2J6bDJiVHYw?=
 =?utf-8?B?TWQwRjIrMkR1dkpWbHZUSVFTOU9zQnV4bU15dGZzNWpnb0Y5Q2xpSWp2VVBB?=
 =?utf-8?B?c2xCZ0w2MEN4OXFjNUJtdHJBNFBVZzBEQ3dlRjRqUm5HNlh2MjBoN1d5dW1k?=
 =?utf-8?B?NEZoa0M2YnVvbVp3cWRxQmFaNXFhdk80ZGZhU3NJNDN3UlZWN1Nxd2lLUDBJ?=
 =?utf-8?B?Qm9BMngxQWhLbm01clZPRDkyKzZScGYxcHg4UmNaRnlZUjJUTCtWbG04Q2hO?=
 =?utf-8?B?aE9PY3VvdVlmVFVmQmZVcy9iYkxwUWZ0QnZFVStqZVZSamVBY3Vjd3B0WWN2?=
 =?utf-8?B?RHd3clBMVDhEZEVqZWtwZjUzUFU5aTZKZzMrQTdWWTR5b0hWVWpnQ1llRTZO?=
 =?utf-8?B?TzF1MkFvdzBDNi9ndGNmM2dndVVtcERyRHZ3TWU1clJIcTMwcUhWNU5YQ0Vn?=
 =?utf-8?B?TXJFSTdNVzlzS3o0Z2ZPMmdhMDhNNFdtb29CZjA2UnlxRmxXOW1KbmlLcG1I?=
 =?utf-8?B?YVJPbUFYbWMxMStJTUdlditPblY2cmErOHliMWFRaVloZjFtQzl0R1NCZ1pZ?=
 =?utf-8?B?VnI5N1lpQlNTT1ZDU25QdlJ0KzJwT3hid3JYNCtXSDdvVzJQWGRuWExPNnBm?=
 =?utf-8?B?Wm03azJpVlo0Uk9uL04vcWY4RzFHODliTlo2MG5VMTNLWnlRZUhaUURqZW5x?=
 =?utf-8?B?U013TzRKT01QMUhhcDhyR25YeDlXSzhoeTVpVWxTZ1FtSUNKeDYxNnFpTzBh?=
 =?utf-8?B?cm1iU3krb1g2ay9zMWZlTVBqOUZlSFVTd1Rmc3AxbFRwazd5SmlsK0dpY0JG?=
 =?utf-8?B?QW41YTNORVVyTzFEcDV3R0haemJKc0grVjBoTzI0SlNqUHl0d2poOTNzRXBQ?=
 =?utf-8?B?VXlmLy9ZMXIwbUk1aG1POGVZUGpVci92MDlYWWpwdlNiR1ZSUHZ0bzNQcHJt?=
 =?utf-8?B?L25CcUx6RnJLZGFIc1JLOEVmZjE5clQvVFlwbHc5VS9ua1FIQ2dCaDRrR1ZT?=
 =?utf-8?B?bUJhSkNJTTRDSHJBaDRDZXZYNEhBUisvbEhpYm12NlNNUFV3MGpNZ3VBL21n?=
 =?utf-8?B?SFpLZHJOS0FERHFad1lRZE1JdU9admhETUpxenRFRlpnQVAzR0JJdjBnUXpq?=
 =?utf-8?B?aGpEeWlvTGtkaERjbEtUeEVPNWxLRUgyWlk3c1ZmL25uMzRnTjR2QUM3WTlx?=
 =?utf-8?Q?Y4Il5lgmaZK3cYhZ2fKJuEVeT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2ae440-71bc-40fa-7488-08ddba8982a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2025 23:29:52.1194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aoy/vxx5gbemfnh0+65reo4ZxvdFOXhOqlYWxd+uqsqATAB71ol6hn7y/C56espwvVF5rZmdQT59DzmwaLncBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF67FA1A8F8
X-OriginatorOrg: intel.com

PiA+ICtjb25maWcgWDg2X1JFU0NUUkxfSU5URUxfQUVUDQo+ID4gKyAgIGJvb2wgIkludGVsIEFw
cGxpY2F0aW9uIEVuZXJneSBUZWxlbWV0cnkiDQo+ID4gKyAgIGRlcGVuZHMgb24gWDg2X0NQVV9S
RVNDVFJMICYmIENQVV9TVVBfSU5URUwgJiYgSU5URUxfUE1UX0RJU0NPVkVSWQ0KPg0KPiBUaGFu
ayB5b3UuIFRoaXMgcGF0dGVybiBsb29rcyBtb3JlIGFwcHJvcHJpYXRlIHRvIG1lLiBEbyB5b3Ug
ZXhwZWN0IHRoYXQNCj4gdGhlIFg4Nl82NCBkZXBlbmRlbmN5IChhZGRlZCBpbiBwYXRjaCAjMjIp
IHdpbGwgbW92ZSBoZXJlIGFsc28/DQoNClllcy4gSXQgd2lsbCBtb3ZlIGhlcmUuIFRoZSByZXN0
IG9mIHJlc2N0cmwgaXMgc3RpbGwgMzItYml0IGNsZWFuIChwcmVzdW1hYmx5IC4uLiBJDQp3b25k
ZXIgaWYgYW55b25lIHJlZ3VsYXJseSBidWlsZHMsIHJ1bnMsIGFuZCB0ZXN0cyByZXNjdHJsIGlu
IGEgMzItYml0IGtlcm5lbCkuDQoNCi1Ub255DQo=
