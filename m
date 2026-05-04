Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC03E3D94
	for <patches@lists.linux.dev>; Mon,  4 May 2026 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777917167; cv=fail; b=HQ+VAAuPiwW1uep3gEsNNg4qb71OJ0E0BICydGQnTMbNTFjh8nw2Y1DH0i01mubzdL6tD53myWFsPTaiw8InvTr/OfJT6bBYx4nPIwbqiDRUIaJeVlwrThuJqN5qeNz6wYASjLRaLAu3SdBaTqBWCRHlSN0jKXyvZJRuyEJDC24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777917167; c=relaxed/simple;
	bh=4Yt5dfM6MibJq3gMuk2uIZe8mXteGo1VF0segHZK4qM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cYATGchiazk8C+B4ZdNfMIZq0yjBl4yER8SdzEJRDg59Ogvbvgh1DxttaAKO8YOo0cD8fb7uH1qe5J5Aq4r6qe1Szt+AX2raPoHpOEupqFkuDEixpAHxcsCFRlYscvZGJL4hMML9vm+DL0HAFsxsuZnaMtcUbbRadb2bV0yIOyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5XPxy3L; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5XPxy3L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777917166; x=1809453166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Yt5dfM6MibJq3gMuk2uIZe8mXteGo1VF0segHZK4qM=;
  b=a5XPxy3Lop3biafVNx/X8cbZ0z48jgXN7UGuuZiZrT+Pca16g7oonaln
   2DArXu5eeDr87CoRcw7IZj5IVAvYlCp0+qw8ABmdEm0zMEkGEcwYIf0nx
   hhRo6hU8SuoqhPxwr2sHcRylhoU+HpE+JrMEkxnaVbqB+eEnwZXymo9NH
   zCznEOOdMGs3ydCAaKAk0SQ/ByG8YtNyN4htMXfA/M3zInEsf0nnHU9mA
   1JDve0IRxIKyEpjN0hLiOmWHwyVHNZJ7+DK0PVkEljUhvyQn+PUp1QGwM
   Xj7ou0MhBs+BGVL09sFAxhK1ukmbmxjyenjkQzVQ74AuZuuCMBfAQjlPH
   A==;
X-CSE-ConnectionGUID: iBpgpj1qTECbYV0rvfYI3Q==
X-CSE-MsgGUID: 7ZPtIIy9T1+aZ3CecvhQmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="89473512"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="89473512"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 10:52:45 -0700
X-CSE-ConnectionGUID: tBW369oMSR2KPvKRYcMmyg==
X-CSE-MsgGUID: NWsmazgfTYucqwH5L3jQsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="229098765"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 10:52:45 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 10:52:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 10:52:45 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 10:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdM7joJDZcq7u8DfVDhjLfNcsOTJb/cF+wd4XngD8JTKa9RtaR1M+OBX4YWcAfrl7gAFPaQ+9mONP9PjOoec6J6Tg8fHJdGQ+yQWcJvuQLpxLeqMDaEth2DYFGV7I7M/nBH7OJjk5c5thyzH+5W/qDAXuQIfwKsZicXdYdFwGe3F+F6F+8rXbKuONNTQaDywJvm/8qIcFP4yyMnPihS271TS7uHrnDgI740QtxhRJqEKiwZHavd+q+hefj2rP2teIYaniBf5xeiC6zmXhR9Vt+iuPBuftnLwxv82kqQqdHuGbcPTz0k5ggTQOuUHK0bPvsYui6zGYWYTCoA1vwUpww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Yt5dfM6MibJq3gMuk2uIZe8mXteGo1VF0segHZK4qM=;
 b=dLEnPEUlUBToqFTvsVB8Gnt+GUyBkaiUWuDVoRt6OcaALnLsKF2EtBpfUTzBwczNF2b8oKxeaa+tNeWqch3YGId60mTv8kzox6mgxcwYizcHqFzc7jL2FXr/oKyy7AMT4QEgYl/lPzqUD2HiUmF3MH+2uVrdT7J8VAH23nqHQR6xnuIAmy4GbeiMsCgDDF3Pobzv7sSgFVebg03Tdl9pBJuns1NC7cIqD2P/iwsruYf8xEL/wBLQdFXg7vsdPpfdcRZg4la5Ok7qIkjqVf4i3M40r3gFcUgxTRyrAs/F6OlDa2rBe2DrgzCYPvdECTFhD7NAhacU6T0VSdgNb12XQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB7616.namprd11.prod.outlook.com (2603:10b6:510:26d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 17:52:37 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 17:52:37 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, Fenghua
 Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] fs/resctrl: Fix deadlock for errors during mount
Thread-Topic: [PATCH] fs/resctrl: Fix deadlock for errors during mount
Thread-Index: AQHc2Zw3AFP/Fl+Xek24SGMDpaD8s7X5zhYAgARDzACAABYLgIAAAd1w
Date: Mon, 4 May 2026 17:52:37 +0000
Message-ID: <SJ1PR11MB6083972791ED66C4F7E813FBFC312@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260501185612.14442-1-tony.luck@intel.com>
 <1cdef1e9-e484-4929-be2a-793e42a49cca@intel.com>
 <afjIXKwVpSAh5kAA@agluck-desk3>
 <51bc4f90-2979-4102-b503-930dc69ca517@intel.com>
In-Reply-To: <51bc4f90-2979-4102-b503-930dc69ca517@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH0PR11MB7616:EE_
x-ms-office365-filtering-correlation-id: 5cf061e8-d29d-4189-56f4-08deaa05ed9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|56012099003|22082099003|38070700021;
x-microsoft-antispam-message-info: CERlKOBRspQcDt/gQ8Od6zS+9NYHVlFVpe51GgVZ+2pGkWL0eSHPa9IOjAnnkhEYLkSnPgBQJW0QWObOqhQkAo49nTOQ/4IVzSXgRtftu7ITWz0FOVBKHYkt6z3xScXs3zI5X52ftTsSoom0sj0vTgfCiAGCFA8Mb27Ksd3UqJJUK7agKs0J4BXbI7nmxvm/q02Vp7Rj6BPmE4gib2f1EBf5PTfvQvH710roz1BSi3N/NdgkNe6E8mJkcNgy3/OIm6dsOyIHpu5lMnntFpjuszI4dL6hjaI4KD/pJBDFLbBxXyV8pU7xOnCZfc1UYSzZOwj8LoBGzWXc9KSQuycsuc79J1sL3QSgJU48Nf997gRi6mSOQewfnZGQ/g8hWV3CW8PwG+q4DWLCQKaWXW9e39fjeqLZhtoNsM5Vsaq2fQwpRYrq2IgXQBbAPhnEfThAE9HbNmPjrJJURHswumiZqcCnLZfa8LxQ+VAY92FZ/HyOIUNoYnyzs8o2WEPS6fI0jP+efPQipJXcbxwabUO4se/K0GZ00rq60Z5CA9w6LsowhVYeeSzaRipV11eoTgyUChJXQzn0n2537uNM3xATBaD3BrfgiBXGp6HrQy/IoVP3jZwMfXgK/UjINMkrK0yeGzSNGMOmZPwhjQVl2fgyDZAMdEKNjp9JuS1gUDg8MKST5pk00EClamCINrF0LtqkhgESMPR0ggg8q1sAZaTjjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(56012099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUF1RzZ2RXdQTGVEQUVKYTdQckNsN0x1Sm1pWFFwZlluTHhxemQ0am9iVXp5?=
 =?utf-8?B?N2xVWXlWNVM0NFZkNktvRWtqakFZOFF6c0VycDRTOUFqZlhNNFRndC9qMDA0?=
 =?utf-8?B?a1U4bmI3ejFLWmpxUnJpa3IvVGtqVjFIV2QzM1NkN3ZYZHh5VnF5UGpnTkR2?=
 =?utf-8?B?YXRSQmtqSzZnbldqVCswL0lQYVdneThjMHptNWxTclRwWGRuY3ZTeHJGYVRP?=
 =?utf-8?B?anpxVkRVUytqejNlVGlHc3pPQWxTcGF5TDJQVE1nN2VXbFBpN0tmRlR3dU1K?=
 =?utf-8?B?b21IRVJRZDBBQW5mem82T1NDNW5tc1ZtaUk5dXd0YUpMQ0ltQi9oWWROZUZK?=
 =?utf-8?B?MTVGb2tXR0hONWsxUUwrand1UFFydlliN3FHUVJxS2VlMFovenBOc0NrTVBq?=
 =?utf-8?B?eVF5YVB3MDBFQnZ5bmJ0dkVKYkJscUkyVkNJTWtndTQwVVpMc1RFc0RNbW5C?=
 =?utf-8?B?Y21lQlRuK29XUGxTdXB0ZGxFWVQ1amk0WXZDRlQ4Qk50WW1LYVhqYWg4NndL?=
 =?utf-8?B?emJJZkQvZG9ES2JtZ2x1VkVTcDNOU1dqa3hDMVk0UXdvWit0Q2VuaVFZcUpz?=
 =?utf-8?B?NjVzTGpPdm4zTHZmaCtobUw4NDF5SFdtZm90L1UwMVVMY0I3cEhKdkJkU3Vs?=
 =?utf-8?B?a2Y3Q0NBeU9iVm16S3dtVkhxdGVTZ3o0Tm5FRzg1TkdkdFlxNFluMGtLMkps?=
 =?utf-8?B?MjdEZDk1UEJra0FYM3Z3N29tbHF6ei93Kzk4R1lBalVobWtoRmJkc2NpMXdh?=
 =?utf-8?B?L2xySkE1TlljajZpN0JiN2VqR3dkdVg4MVlvZ3BRdFllZ1lXZ29uME1xUEUz?=
 =?utf-8?B?aHROR2YzMjJsUXQ3U051bndreksyQURyYkhDRWJsTnU5NC9HUTVEMFJRZk1l?=
 =?utf-8?B?UlIwNEFGd0t5TjQ4b2ZxRDIxd21FVm5FNG9PcTFFVHpZcXhPeXU5YXgvV1pO?=
 =?utf-8?B?MnUySEJpS3BlNktueVFrSC9FMFVjSUZFZHZDbXFyeHhzOUR2TWJwZG4rRnFj?=
 =?utf-8?B?ZXBEaUQ2cEFTTEw5OVRNS0F2MCsxQ3gwdXhwam1kUE42VFlWeExiQk80eDdL?=
 =?utf-8?B?M2tadzlBdUNkUC9OOGlyQi9HT05qYmpLYUZhakpUNGlHdXlXcWJlcWdUY2x5?=
 =?utf-8?B?a1RnTVZmS0lyZWNpVkpDUmQ0KzZyMmxGUjBmVmNXbllyTllqdjJ1Z20wWEoz?=
 =?utf-8?B?NytpZTNGK1c3THRpc2NlOUw1M3g5THo2cjBYbWZoNllTcnB5V09LTzV4aFNJ?=
 =?utf-8?B?NUovYXphQk13Wjc2dENnVWs5S2hXcG9rVjNrSWJWWVVJYldVQ3Ricmh4K2da?=
 =?utf-8?B?c1hTeG9ubDRjV0FHejBSR3JORlZQS3g4K2kwcllRMTVhKzVxczdpUTZYWFJ3?=
 =?utf-8?B?OHJFWHFrWmZMSE1ZMk5lNE1WUSsydkNvbFZCZGNkZUcwbVBHWFBYTWxJVGc3?=
 =?utf-8?B?M3p1Sno3a2s0alRNU0psWlVUOVBSYlp4YmhGZGo4VWZuTWUxRVl6RCtGMjZK?=
 =?utf-8?B?TS9UaVdSVWN6eTdTTlJ4TlZiaXFmN1hMWmNmL0c2SzVUeDNUN2ZmeExRb1Vm?=
 =?utf-8?B?QkNmQ0c4ZlNaUHVERmVqK1V0OGNGQkJURUxJZXZvY2hnQ2tNYzRuU0ZycWt2?=
 =?utf-8?B?SGFmbjFhMVBVdHY3RFhwaXc5elk4WnNkOTRXeElNL3pyd253OE1CNFJJaFpG?=
 =?utf-8?B?STI0UGVGTEMwQTJTOUQwMlUrSFhvQWVvTzVaenFDZTB0Z2ZIUDJSZy82VmRL?=
 =?utf-8?B?UDVabmlkaGFvRHZkWlJBdnBFTUtPUHFQZit0Ly9NOHVLWHdPQXdRczUvQ2dG?=
 =?utf-8?B?d0hPSjEyRkVwVjlhb0RnUUJjMktnM2kxZFpWNEIvVmllZHpSamwyejEzM3Zv?=
 =?utf-8?B?Z0N1TWRieE90S2FHekZwdWNTQmh4VFIwUkloMEhrN1JDWE9nSWRVVkFsZHkv?=
 =?utf-8?B?VkU1MkROYk9RcnpQM1pNTDlmV1o4N00vRExUZnBFRmFhTzhhMEFhb0VpVTBm?=
 =?utf-8?B?Z1hmeTNtRUp5UFhKVFBhS3F3eUNXcE1GclNCc2lhakxnYTd5T2hLWmZlUDhr?=
 =?utf-8?B?UGU5K1V2d0F4czk4VVlqU1NCTTRKQk12d1BSQkNNSWlTbUN6K0ZLN2h0TENk?=
 =?utf-8?B?eGkvZlZVWUZ1eENuY29HaGNCUnRQVU92QkdwZnpIeUw2QmxsemNPR0FFVnkw?=
 =?utf-8?B?SUlMTkUvMVhJdjF3NlIyUWc3VnVlWHJNc1FiUnVzb09JakVNN2N4cmZtaDVS?=
 =?utf-8?B?L3EySXc1UTY2Qy9QUHFXSVpocFAyaFdnNWZ3YXNuZnVTRGlNZGJ1YkpTbWgv?=
 =?utf-8?Q?iitVQGyEaVteZhAvlS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: bemlC5+lWCCs7KqkVEIcm+3RGJrXuymm/b9g6m43paXi7552ABWbQTO9EM8y9pECvb6EUo8H4NrHg7bDoCgGfKn8m+TsEgDfET/uz5B0xyMcODmEqx2ZaWSZT6QcY9PWrUrhiuBp97xlNNQXAdTz1iNKyhe+g8EQ18kfPALkzAioMnQVRCB0t3EcunuCFOdKG0E4/NBZs8VeEJOEeyjoH+wC5eHEUsoMvVD/xH3SjspuCbXK58IpVUspjsfArX2WxWr8xw9jBBm5HEqvKbO2BNqyTs6ZTtIN2MYii2NYwmj4/j7l9ciX1parGrb/AgALVN3+1QhFZCrBk7fJEl4HDQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf061e8-d29d-4189-56f4-08deaa05ed9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2026 17:52:37.0837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51DZ+znP2sRMU3HC4yRj2YPQiImNcvDlwXgLJeDJdFcicL6YJkdUm6ioO3jLyBcOimDPfWZR2CRLE1wDUPqPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7616
X-OriginatorOrg: intel.com

PiBJIGZpbmQgdGhlIHJlYXNvbmluZyBhYm91dCBzYWZlIGFjY2VzcyB0byByZXNjdHJsX21vdW50
X2luX3Byb2dyZXNzIHRvIGJlIHZlcnkNCj4gY29tcGxpY2F0ZWQuIEl0IGlzIG5vdCBjbGVhciB0
byBtZSB0aGF0IGl0IGlzIHJlcXVpcmVkIHdoZW4gY29uc2lkZXJpbmcgZXhpc3RpbmcNCj4ga2Vy
bmZzX2ZzX2NvbnRleHQ6Om5ld19zYl9jcmVhdGVkLiANCg0KUmVpbmV0dGUsDQoNCkluZGVlZC4g
TG9va3MgbGlrZSBjZ3JvdXAgdXNlcyB0aGlzIHRlY2huaXF1ZToNCg0KaHR0cHM6Ly9lbGl4aXIu
Ym9vdGxpbi5jb20vbGludXgvdjcuMC4xL3NvdXJjZS9rZXJuZWwvY2dyb3VwL2Nncm91cC5jI0wy
Mjk3DQoNCkknbGwgZGlnIGludG8gdGhpcy4NCg0KLVRvbnkNCg==
