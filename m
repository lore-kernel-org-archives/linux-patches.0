Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9486628E0F
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675223; cv=fail; b=kH2u7pytrxfy9K2GinPsKm3thYv8bjZBIEWWz5XFk+vUyN5o40nnQWM+UUcq3iIk2FsyS7KSf3CcYkcnVxCiWp1gL5FIhcCW+LgqqOy+bGfXEq5LZXV4WIgx5QzSM4Nk6qmoIFX2jwxUV5W+UmYA/cijzBj2jJ9y2KPU+8aF9NE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675223; c=relaxed/simple;
	bh=EOKwjm5w1/iAoz/LsdjEwXbg1Cet+5J3gFctL8e1LaU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n1h5f1YwssVqkM3C4TStx+eeqOzigO1qBbigo8Xeg0vs2L+O+m2bGTTLwi6ZO/dxbJ/sNoloJ9E97BZXzgYDjEnnjvqyP6dYDpFb11j2jizFnBYgNEWHOsJ+oUna9h9zfSTgvaIQxeB93S4rzUYI3BoJDfjjChzQStuC+6/aWes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ck4krKVD; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ck4krKVD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675222; x=1778211222;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EOKwjm5w1/iAoz/LsdjEwXbg1Cet+5J3gFctL8e1LaU=;
  b=Ck4krKVDUAupBQSyBiGlMjGFY+hJncxlprXXFxDdBPy+gFyD9nCpJA8h
   YobZgwcIZtLaBR2cBYIekun5SwtAK0tUECVMXI7/q/mtF6EncoIs6G/L9
   SF4/b31bdQXy/WXaLrPi+2ieifamKk9ZB+PlNt47gux/YcsH5neIyH+eY
   o6yr37aynTz/cay7yHe4FJJHtvN+G9w2vRsYacQ7KJ1PwnFxDcAjI7DPD
   Fjk2+C3838lvzfRxF3l1scmsE+EH9+jzNKHCP6IKg0Ed3+qmcRnW1PE8b
   BweQ2txmp3Cy7hn8dXOaLmrTholMle9fHjxeg7WU8cBAPCUT/NdP260bG
   A==;
X-CSE-ConnectionGUID: N37AhK3/RYKysNUYD0N5sg==
X-CSE-MsgGUID: 51iKa1+PRCmZokWrpFsyzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48344523"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48344523"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:33:41 -0700
X-CSE-ConnectionGUID: mPPnxc5sQ1uoSD6oz6gkNA==
X-CSE-MsgGUID: v/q7PVeAS8SLZUa0b90fVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="141365267"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:33:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:33:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:33:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:33:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cah8nKi5H11HZB6trX1uHig6pdLDO4Kz0cllK1mRHc2AG/rthedqZeciW6+vzUYi+wp2taVLkdzU09BoJen+KGehReewdzpUDpzBjOyoxiC5Z6bI3cgwJhXMH0l3RsQ8N5XJBTSHQfFY422RIoVsAxqEGyyw05ncUJTDKEVFhhABAxbzyB/wlbzSNN4ttdUCEPNl+GiY3hDw8IIm1YYdU5v/3EBjFOVEMX78COTmyYZpouz3ILi4gKVJopzY45TleOpQ3kHq/SxER4xfVP/yukXfGv6QhIAjKwpEz2Se2Urj0RH31Th5Uul7ymvjgPSgLAiw6b0Qp0G0BRj2PV9WYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9PmK6w0E4Qz4Amo68TWGZXuBWm7yyJ+gX/sSwwh6WY=;
 b=NG1f1lWjb+RlWJaOr/PQUTje62Gk+hQT0+LF5h5d5lAkUinzv4CvANeV1d1/tmd8MZw5qf1JmLA9IfFHGD2oNgo7FNL0orQ2VRs6rrz4jqSDk7LF1D0ZwNFNZdD9mNt8BiUlTsCUz8eQWvXgFjAxCeEpYU0RuDsED1HPH5fzBN4yiOokYwjx2sTmH2VSpA2+yGWgBkkUtMtymlhh34VHHDu8Srp+oVKmGIK9YZDWznJjDTLI151NxLFbigvFOtZWhMkonws61HhNC3dHTJ1B/h6g+cLTwqibjP7kMsMbT26gcr926YW401HiDzeg42jHWgykcUP/ix1+CS6L3uByig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8513.namprd11.prod.outlook.com (2603:10b6:a03:56e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:33:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:33:28 +0000
Message-ID: <7fa19421-9093-411b-b8e2-da56156a9971@intel.com>
Date: Wed, 7 May 2025 20:33:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/31] x86/rectrl: Fake OOBMSM interface
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:180::39) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 27fe9ed0-3eff-4e0b-6915-08dd8de118cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VUo0NnlQYU1NbVhWamJtUlRxOVVlM05PTytORlM0enNHdEdUdzExZmVrSU5S?=
 =?utf-8?B?WEpjK1FDVVp3ay9aVWVvZk9mc3YwLzdlUDdlS2Rzd3kwZlZsRkc5dEIzTTZE?=
 =?utf-8?B?MDkzOGU4NkplN3NsRmJuZnpmbW44dWhTanZLTEM4K09qQzZneUI3YWpWTmE1?=
 =?utf-8?B?cmR1ZHJPZmVSdEd0RUxwemhPZGxPTkpqcmlVQnNacFQrUXhpTjVjVU5rSXJD?=
 =?utf-8?B?QzlLbG1xbTNRR2xUc0ozMFdnYWZDUmw5eU9iaG9sZjhrZ3dlOVlZQW8zVDNo?=
 =?utf-8?B?dE44YWovbC9yWTVubHo3Vk9ST2F1VTlEWTlGbUszM01iYjlTOUJ1WlNmU2Ft?=
 =?utf-8?B?M01jSktNVXd6UGRtR3UzeWdPOXh4U3FBZ3NHNUREU2hadG9YM0cxbXVjMjJl?=
 =?utf-8?B?bDFHZnVoL0VlR1d6Qmt0L2EwWDh6dWNZcjZ3SFRzN3hqZ3dXQWlGMG5oUEpE?=
 =?utf-8?B?Mi8rS3U0SzViN2d3TENxNWNYcGlOOWI3U2Q4a1pOWnRWNHdZUmVvNjBEWVVS?=
 =?utf-8?B?Sk5JVXdMcE9kMXRXYmx4TDVoMnh6aUJSM2ROOHJEbUhxZmdLZXE3V1BiOXJ6?=
 =?utf-8?B?dFFvTi9PVlppRlRkNnFtdURmTUlxalBzUTFrczFvWVY3aGRaQ0NaY3NhWmcz?=
 =?utf-8?B?bVVXRTRSck1ybmpYTHVGTndvcHhUM2tackxHK2YvbnU3eUJZT2JyWFZ2dWVq?=
 =?utf-8?B?WjMvak02eHpRaktCN0dXcC9mbmFWMjFvZmtLOVN0Q1dVdEl1V1dZYi9vb2tw?=
 =?utf-8?B?QmZKNjlGQUVqbW5Vd0tDWDFqSW5ST2pKOUJ0QjJDaFozZG9rb1lxZEhMWUc5?=
 =?utf-8?B?RGdxckpTOVFhMCtMWDRoaDFCZG5SbTF4L3MyWlQzd3o5WmQ4ajhLbFVndnph?=
 =?utf-8?B?cHhDdFVxMjV4UXYzV2ovZFFjNGZYTnZiZmh5angrY2dhNzBabVN4K2xYVTlC?=
 =?utf-8?B?OGg0WXdMcFMvWkNkVlhXbEF1ZENzVGFlODR6SU4zMVBDYy9IcDBGTkpIVnNl?=
 =?utf-8?B?QUl0NHdYQ2pWdFB4MkE1eEYzRjg1dXljQjQxait1azZpS21jZWM2SXZ6djM4?=
 =?utf-8?B?WUUwNStqWkJYcnRqR29TMi9tRnhKOHJ2YTNvc1JDc2pqSzNYOWZaemd3QWE4?=
 =?utf-8?B?TXp6dFZBVXZDRHJQWERJOEhNVTJmVTJTOGova2NRRzVPYlZoQTFZemQyNG5N?=
 =?utf-8?B?UTNGaHBPdFVjZUU2U2hJSFlsL2VSUG95V3BWenFBcmRIb1VqMk40T1JSMlBq?=
 =?utf-8?B?OVBWc1lGb2NPZW16N3ZlY3hPSUZ6TDRLN0dwSHozT2w3ZzlkYW41STg1MnAw?=
 =?utf-8?B?WjBvZlhFc251WUxBQ3Q3ZW9laUJtY21nNkVTUURscVRuc01Fc2QxanpMblBI?=
 =?utf-8?B?R2VYS3FGWFpKRlR4MGtIK0JTdElxOFIvaVE3WnU1VWVudGlyejlEYzFvZFNu?=
 =?utf-8?B?WUpFdnBScnUyNk94RnB1VnNEVXRHWE11WWVYajJzOUVKWS91THB3djJkcU1O?=
 =?utf-8?B?U3ZMVVhhK3FydDBVVmV6bStpTTNrY2pzNDB6T2hnZ2R3N1Q3N0R3cXNYcXRO?=
 =?utf-8?B?TGNXYzVPdFNMWmd4aGRJekM3dU5zc0o1akJWdXBLMWRaVTRDVTNORVhlSFdR?=
 =?utf-8?B?Q3krUFllZjA4MjRwKzBBMWkrZEdoVjNDTmYrVHhZTnQybk0zVG9KZVc0bUJE?=
 =?utf-8?B?aGE0c2tpOFFjVC9tSVFZQ3RSakcrbm13b28rVXF6Rlo5dm5WMnd1dlVqdE5J?=
 =?utf-8?B?cnAxV25PTU5TN2dsVlEvTTZpSE5WbHJ6c3BFaUlxWUk5bnpqRVFwTm9xT24x?=
 =?utf-8?B?d1FMbkRpV09iTDlYamtnS1I4TlRNT3V2cmxQYzNSaUVaSDVZV2pXSjNKajFL?=
 =?utf-8?B?NW9xYTNLaERPNFdMNFVzM3pRQW84c1d1UW5UUFVReS9lRFlnVXEyTWROOTIy?=
 =?utf-8?B?c1NsdW5rck1PWHRHUXhLU3J0ZGtrUDBvVzkxN2hoSVZiNG51blVpZnRZZjVw?=
 =?utf-8?B?U2JYcWI2M2h3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azZmb0VRanZKN2VNWUpkdElScCtjbWdLdEE4NGhhT0IwMzRXSE51cFV6NUxv?=
 =?utf-8?B?a0hlVUlBWEtJYW5Ia0dyUVJiWWVOVGU4anBVNXV3UlROTFRVc2xldTFPOXIy?=
 =?utf-8?B?anEzd2Fkd3VyUE1rUW03Sk1EQTRuSWVON1J4Y3RqdklBZnBMNzNDZ0NOYlV5?=
 =?utf-8?B?VUl5ZzM0L0IyVElEMkRoRkx2UjZFeXZCNGFQLzk2dXEvZkRWTFZuTFlwaU53?=
 =?utf-8?B?ZWMwOXlLc3BwTVNDK1FGc0s0VG5oWXB0RHZaYVZ2b216cCt0NS9JaGNnMk5o?=
 =?utf-8?B?N25mWitueUo4RkMrYkc0emptT2dNWWJWWU9vUG51U21oTGFmMjdMOTNkckMy?=
 =?utf-8?B?SDRkVEJqMVRFazRCalcrWmtGRmtXTnZCUnkzQWFDTkhwSWVuRmZpQm8wQ1FN?=
 =?utf-8?B?VWUwakhvOHlHV1o1NzltdnFLWnJ2VGwwSHRucFpvVnJuUjhNdlVzRk1XMFp4?=
 =?utf-8?B?a2ZEd1RvRUhzRlF5OE5LbHRhbWozQ3RRUE0xeGpueUpROHhNb0hHWW9taFlv?=
 =?utf-8?B?NXNoNnZTbENqSkhhempXaHRFNlFabnBsSUpUb2o2Z0YzMHkvbTJTaC93WGpa?=
 =?utf-8?B?d0pRSlUrcFJzZUZYVTVZdFlLa253ejRmM1NOVDZ5VGZhRlNvMmlsZThFSkg4?=
 =?utf-8?B?M1NMOGJzdFJQYlBPRHRmSm9aNVBNN0hTdXgrSzByYkxyV1RENGkwZmxGa24v?=
 =?utf-8?B?NGVCZG1GRzFiWHhUVHlRSlBJdGE2WkFEeWsrNTQ3czRlOWY3dTJUWHR0UktS?=
 =?utf-8?B?TGZlYmpyeFJrQVBMcU5mWGVWUEhTVGFwSUYwelRnaDRIKzczNVFCU0I2Q3U5?=
 =?utf-8?B?cmlYc1U5UzI4aTBWMXNKVElIa3BMcXhkR3ZoK28xdmV4T0tYVkdHUU13bWZm?=
 =?utf-8?B?N00rU0xId3JMUDdaQ3RTNFpVM0w0enNocVdLRGhSOEpCVW5rcFljL1RpVXYx?=
 =?utf-8?B?bndYZ3RKOThXMTlrSForcGNQTUZIU1BhanJtaGtyNVR3N1pZZDk2MWlXMVk3?=
 =?utf-8?B?QUZTOFYyRGk4Vlp1em9hVjFsUkJsRkt2RlFtV3ZEUkZLVW1MVmd4S2lUdDBR?=
 =?utf-8?B?QUZWZHlEVDJLNWdvRE9MaFZ3NFlnQUI1Z0pxSllLT0RIekNiS1RJbEtHUitZ?=
 =?utf-8?B?b3FlQysyYzJrMFY0SjYrQkUwcW5SNE5JWFk5NVRmR011UDhISHVMcUZxRm10?=
 =?utf-8?B?N0JrM3Y1eWpOV1NyOHRQc0NSZ0drdnlTanNIbUh6QTZZdHZwTmhWenBTNE8y?=
 =?utf-8?B?MzVWNnpFR1NtTFJRZ0hFd0RZWXdBQ0JnNEc5aFdBbnNGa01Fa1VTdlFlOGpl?=
 =?utf-8?B?QjEvOXp4Nnd0bDBWQUlyaDNRZVBLeFRxSTc0VThYMENjdjU0NGJNRnJNUlBs?=
 =?utf-8?B?Z3NxdVRLTjI1Z3oxQ1pwMncwenFIZHdCN2xEd1dlaGlMWVRaWTZjRTdlUlFT?=
 =?utf-8?B?YlhRei9oRTE0NGJMUExvR0JJMmJ1MHJEelV3WlRiSUhTVzhUYmwyeWRjV1hJ?=
 =?utf-8?B?MjBiclJNZmMvOHpMd001V1BmS1dhcjVyTk5tbzJlb2F5ZC9CR2MvUUdDZ2hz?=
 =?utf-8?B?N2V1VUl2Um1KaE5tVnFOTHY1c0tYQ25nbDFQemRsKytISXhtaFZwQ0pPblVS?=
 =?utf-8?B?R2x6MWdPYzEraU05MGN3czNWVmcrUVlsdzJVZ3ppNjI5aEFOLy9KcDFYUjNF?=
 =?utf-8?B?QU5tT3VIWlJzV2dlMVFTaVNMVGtsc3ZvSkYrVHNBSGZXNHdlRzVZcHZkZkFu?=
 =?utf-8?B?RmZNVHI5dHV0NjVJMzkvQXdrQjczanlmeFBjRy9VTnArYmhqcG9DZHZYMUNz?=
 =?utf-8?B?M2w5SllYY1RlUkZXR1N5QnVvajNsSUhtaVdzMGdsaEd0am9LaUd3aytXS0k1?=
 =?utf-8?B?ckFra1YvZFNzL1NSZ0I1NXZzT2gweDQxYVJZYWloOW44VmtiY3JZRWlDZ21Z?=
 =?utf-8?B?VWNER0lJVEtkeXdHTGdCL0hZN2dvRCtVQXhkYUtJSjNub0oraXkza01XejVq?=
 =?utf-8?B?OHJlcjROQk1DN1gwWkZpQTBETm1vZnNDZzdkcEFNMC9SS1JzR01SWjZ5YlFr?=
 =?utf-8?B?L2NpUmw1WEIvVnRodFp5NW5PbHN4b1ZrQ0lZSG1ycDh2TWlkT2pTZjlSZ2lY?=
 =?utf-8?B?MVdyNVpmOUhYTmNEZDg0UldGQktzd1FDS0oreTFzd2tyTHlzaDZ6dy9oQWt4?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fe9ed0-3eff-4e0b-6915-08dd8de118cd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:33:28.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMvi4aIcwv+9qmjGPdJ9rb9KdUSklBvHTWlglGo4pN98jn/+Ye+rHVSv2Ktf6ARSV3pLdfYlXimWb/pTggJ58KP+uagrhIDrbyLU77vMu/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8513
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:


> diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> new file mode 100644
> index 000000000000..22b7c02a538c
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/cleanup.h>
> +#include <linux/minmax.h>
> +#include <linux/slab.h>
> +#include "fake_intel_aet_features.h"
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +/*
> + * Amount of memory for each fake MMIO space
> + * Magic numbers here match values for XML ID 0x26696143 and 0x26557651
> + * 576: Number of RMIDs
> + * 2: Energy events in 0x26557651
> + * 7: Perf events in 0x26696143
> + * 3: Qwords for status counters after the event counters
> + * 8: Bytes for each counter
> + */

Thanks for adding the explanations. This does not answer the question from 
https://lore.kernel.org/lkml/2897fc2a-8977-4415-ae6d-bd0002874b3a@intel.com/
though.

It looks like this sample interface is created to present the scenario where
the energy events do not have sufficient "counters" to support the number of
RMIDs in the MMIO space? It would make this work much easier to review if
these quirks are documented or at least answer the questions during review.  

Reinette
