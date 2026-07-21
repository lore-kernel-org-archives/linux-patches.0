Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7944657F2
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 23:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677842; cv=fail; b=GC0rnN/+RwzjA7x/SS9z2VMvuhozo84m9oV5pOQVJ8+Qf78Ddj3+JecMFs9UjUdJLaf4ddPV0xGdoi87cZiUp7sq3OTxOowQmM6+EFOmHN6YuSkg8iDyJUd9aLpYzEunzKcj5gNGgUjca78fDfqhUlKkAHpZtiGFQKHVnexgvv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677842; c=relaxed/simple;
	bh=b5hKLTNKhRstTIEMZYakfrtZk16WAHjTxM8xr3SHqmQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rl7Zg83FhGKloDg8IZ1Mnebit5QoOV9iImW19uV/ISweBxDFoytNr8NEDveDBUHupMZ5Blurun1w5jd8EbF+pAj0NFv3yMcizZoOdH9WBz8/B6iOsD5N4/K4bCN5WdQLGGssINNM3lOPVQCFJ3J9+XvSSRDk3uKOsW7sxXlWIsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoVn1J0/; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoVn1J0/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784677840; x=1816213840;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b5hKLTNKhRstTIEMZYakfrtZk16WAHjTxM8xr3SHqmQ=;
  b=EoVn1J0/PPIUnP4A+1apAgMqVt3mHnNlxnpBPGkg0/OQkL5eOY57MtPf
   iiR8X1UT4gSswkHD08K1XeBGJoA7f6+kJP/Nv0kzd9nbn5SqSEtUIjC1a
   wEM753d8c/g1R15XWh4v9LBFljInE8QksM+Mn5oYuZf1JMY5hgj0u2uyg
   71jlzAL1S3ehoh3033FITdDptaEirGARNvx4KkDlwG4CE0lZcGZ7rFiAX
   KGSuhRHG6m+p7tuVHyZzlhNOX53Aj1YEJo4yRjTD1u/1vWDRIiWlOZs/x
   fK0/uRsCDIfpcdSU8AxtxgaL5kaWay3aQZkWzVh+QC8uYO7SnPROo8DUv
   w==;
X-CSE-ConnectionGUID: f4xuy/ZfQjuD6fOjxBzd/g==
X-CSE-MsgGUID: Y7w50uyqSkWgHH3cwH1IEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="85417142"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="85417142"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 16:50:40 -0700
X-CSE-ConnectionGUID: u6bMQSErRQav5hLkqQxpTg==
X-CSE-MsgGUID: hdTpkGtrTiqdLCB1BvjKJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="257987483"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 16:50:39 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 16:50:38 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 16:50:38 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 16:50:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOr9zG5PItO7MZUL8F1B/fq9Uzo2b/Ik9rSxdf4nRnDvPgtuf5aiR1H9wO/kMKf5Z7OvDjlj/oZ/8PD9JNV1wxpZ4OlQaD6BreKJCaVh4Re8kcMAuJhGaYJKSvcDx3iM2hsBvLLJTJFENgOHneSM81kBEyuWT0/cWqemsN5z7kEP1w9yhOE9tpyzY1l/idTpk2KnF7mQIMk1h5eMqu094+mX5bltTtHuTiaSH/UQqRrSOY0P9bhhx2g7zfq1uqFYaGChqwaPKwDYa7FfFmw8fg9E24yMG6uEUqJulVRQuMdyr3Yd5lw4jnCF5Tt2Ux0TEBRrFm9rmjDwPLNAVjq85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2d1ctLawSpaGEQD9lgv6D+xd+luYnjsI8jiQAZBpmk=;
 b=DxuxXtPZpq6DcsZ6mz59V1btLG+1iq9WHwMElv3XZ8stzHUOEip8LiTQO8ok2IkjNFUBIvTzSO9NVYBOhjf+4aFEDzHyz41gtH+8xlXHpkwX6mQkFSYAFyk+/2LsuR5QWk9vus0toVsAlMXrWDLoOaoU0P1nezU/ikq2Y6tsBOOXjJGOPDLYUf9LK2xubQHvD+iyS233LHUglFhC/EudvWxavK0QdyoXStLxzbcqo8vKysv8g7Yvk3NBAyen7eL1L8MkE0YfS9qp3yGfQh9bq3EUVFhacTg/m1CFCmWlvGV5eTZII9p2fm8z/I/cJlIvPs+HtgnNul4QE8GAb4psow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 23:50:35 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 23:50:35 +0000
Message-ID: <86f26d3c-92a7-4365-b6b9-2b31da15ce1b@intel.com>
Date: Tue, 21 Jul 2026 16:50:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
 <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
 <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:303:8e::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 12019663-a972-4b0b-707f-08dee782db8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|11063799006|56012099006|5023799004|4143699003|10067099003|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: b4+GPJYUlJ3oYtqcs1U2fVujf9wcc430CdlaYKA5gLjHrJ79wAtNxlzsgZYCeczDCGk5qLnL9GL3GvesHLr+eZTep80mR3R3gFqexwriY+neurrk9VcU9C3LdMN1ZIGYrjznxL4xO8lVdAT3SVuNHoKffk8Psu+0hzxN608hUbkJJh7TDwkaDe05me1fxWAE/brIKzqpwPJd1w3DgjyPokaXCwhbrq55GcFC0P3DzX0H0VRjpkvfL5OzeKrXU/L1oTMZMsAjBpKUCTiLMR5QdVD9RgBHJnNPjE/7xgu8wy/JyCRHm3XiMVYx8EVrTEFYSi07YbSs3e+S5mkAsxQ16R+mKqCsNLpt5uiOEaBqQDe0+kwMF29fqSpnK3gmhbWCjArLfylSgnNFMt5i/pujVrazIUXkO5WeUPui5tLH3T5VElxz4td66MA7ghVIStRgnvqOKUsRgyn8HqJEhNTL0q0FGC5DKGyWQhkqwvgXPHXeEwJv2zYJXvZY2nb7nRaygoqCoqF2NWoLsvSpyjVcCJvJQpjxfCaXxQL8ZQw7L8uXpDSmGH8P/fDgCkleLHvZHwzXdjlS5ULARA2aTgWwAqDzqI0PTil1liGr/n2kIsAVjE2st9jgLXZbEeISS1+4yRFxIuQRLw4IZe1KAM3TTvH4IICClXJAZA/PuLTY2XU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(11063799006)(56012099006)(5023799004)(4143699003)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFlJT20ycGVJR2FrWjRINnZlaDlKM2t3cnpQMWUxWTlpRHM2SzFhNDZKdnAy?=
 =?utf-8?B?NlM2cFVsbGUzbitlOGwxYk9senFxZ0JLSUd0bEVudDM5VGFnUE9RVTluSmpC?=
 =?utf-8?B?aFd2WWJMYWVGRnNSakw0K0FGWStrVEZvelNuL3JvUUx3QXhBT3dGZXhxUm95?=
 =?utf-8?B?bHRSZTJLWWdteElhMnFvOUdIbERCb1V3V1hPYmlhL29FTkttYTlBZkVEQ2Vs?=
 =?utf-8?B?ejZ5RnhtWnh1SGk5MWJ0QXRrWGYxeFJyeC84Nmgza3hwYis3NHFWZlplckpF?=
 =?utf-8?B?Q0dNckxVM0tYV3VXWEUrVkUyaFhONUc3QmVMNjJiOGJOQ2ZyczFXcENudUtT?=
 =?utf-8?B?Z1lBRVdpQVpLNlpMRTVWN0VXMWNkTDI5dlRLc01EakV0SzMxb3BxYkhRelk0?=
 =?utf-8?B?Y1QveWZwdCtiV05OTFNVb1YyUDdkckhUNHlSaUM2R09sS3loazAxR0FHTXRV?=
 =?utf-8?B?c3libC9WRWhCRWxPU29jTkw1bmtvT3pON0ZDVjU0a3Y0Wk5zbnh4VjJDNGJn?=
 =?utf-8?B?RXovcExFcUNvYmhmZUt5b0R5cG41UEtkeDZqK2xtNG0yRkJKckZuTDlSYjl1?=
 =?utf-8?B?LzJIVjk0RWZYaW1EUDdyeUFRZm5mcDlqWGk1bStGMiswd2tlUndqd2x1WFlB?=
 =?utf-8?B?VDBoWnczeVJlaDRMeVRSV3pDYUFQRSsyODVzNkd5T296Y0V6a1BxZlpYZkRR?=
 =?utf-8?B?K1puUHNXTG02UlpLei8yL082Uk15aUkyTnBJMFQyRllPK2JWREhZd2xYdy9D?=
 =?utf-8?B?WmF3YWp6VzVqUWZONVora2RyRWhsSFMxS0RqaDJhSW1vOVFlSCtmbzlaUkw0?=
 =?utf-8?B?WXZxOEp4dnZidVJDUlYwbDcvZnFKSzRRNURSUEUwTVJYdEc1cGQ0UmI0UzlO?=
 =?utf-8?B?VlZIUVJLYWMyVUIzbGZTMm1EbllhUUVFenBxdXRKR0YyY25LSytSYzEzMlJP?=
 =?utf-8?B?M1kyY2QrcjUzSEdtL3FhUy9YaHc0aEc3WE9UNlRjbjZUdktURHVUd0htc1dI?=
 =?utf-8?B?L2R5bk1XN3pnQnphOERubE1RQXE5ZmhGMU5JWEZhRzh4ejRBNzVVbkVmODYz?=
 =?utf-8?B?alFZVU9zN1B6WFFyemtuWjE0cnVQelpkL2VGbFNxSnpKTHUxd0RCTkJtaXMr?=
 =?utf-8?B?MFpDUmh0c0hWMG9WZE9KRUpMcmJ2ZWpOYWVtbVV5R2x0WGpsSmsyUVdsY1ph?=
 =?utf-8?B?endiNG8vaHBRMGVsaFRVc0E5QURVWDFPZ1ZXQzZObXJoUXJ0eGFYdGtmcVNl?=
 =?utf-8?B?MDV1NmNNOGlZYnh0SFl2ZjRsTnJUd1h1ck4zUmdjUWxtMmZFTHRJUUFLb1pj?=
 =?utf-8?B?Vmo1K3JDTGRjYTVZVHRiYVFud3M0ajIwU0tjUDQ0VSswRjNleWdnQzdRS3Ur?=
 =?utf-8?B?QXFLQWQ2REs0cFB0RnQ2YmV1NWNFWWEzaGF6dUxmT05XdkJDMi9qY3psRXBw?=
 =?utf-8?B?SzZ2UFNnWk5QVTY5TEZIRjl3dXBjeFpKeE5MeDFDaUhrcHNSMWdQQ0Fjc09G?=
 =?utf-8?B?dkpnbGZHUmYvMGwvckRKb0hmellzczJCdGNqdklSVjduTnZpWTYwN3UzaGFI?=
 =?utf-8?B?a0dJSy9aTGt0UkF3eGc3ZUxHUE9wS05hZ0J4QzExeDkzcFVlRlFFbW1sNXJP?=
 =?utf-8?B?UzRZZUMzUFlGV0FaYzVnV1JIQks0YWtMdE8xdk5hT3hSbUVhTVVHR1plTlJl?=
 =?utf-8?B?dGo3TURLZzZrWTQxcWdHTWdHUWt5ZVNjUXR6VisweFdrWkVmT2dxVnYwVnFl?=
 =?utf-8?B?akoySDNxalFkaTA0UmM0YkVvRjJTdmdMbGZoNGpENjhhbWpLa0pidElHOFcv?=
 =?utf-8?B?TzhKZDN5NkppckduUGl2QWhxbkdKaXVjaENKM2RhWnhGeVBmbXVEU1JEeE94?=
 =?utf-8?B?TjdHZGV0MUVMZ0ZSK3ZSQWh0YXB1ald1OWJvTGVLeW91SWZSQXREYXI1VWF4?=
 =?utf-8?B?NzBmOTdmemtTd0VoUERBcXJGakc2b2NxeFlvL05uYzhWUWpWbzBQV1BIY21w?=
 =?utf-8?B?bGtwVExCeWYxUUhrOUVncVBCTjB5R1dnRWZaUURNSGZ6MW9DdUJZdGdDQkw0?=
 =?utf-8?B?K1lXWHN0ZGxzSkl4S3VPbi9kMXQ1U2xxU0twWHEyV2ZWY3RNa3pJclplZGE4?=
 =?utf-8?B?cHpYMTlrQVUxRTV4VUtzNnlUMFBlRVRFdXYrcm9JYWUvZHE2M296RjltaWw3?=
 =?utf-8?B?cGJQRGt2Vk02Zkx1Q2V0TWlQbGtQWXlYdzQ2OEhnNFRQQlYxcDh2R29HdjZF?=
 =?utf-8?B?ZkFHVzNiQXdvMEQzTzk5bEdxejJJYmVHVUZ4Y1lkaWx6b01VNndPUXhtVU5z?=
 =?utf-8?B?aWEvN2pMUG05cWlYUnlSZk95NmtYc3duWWdpdlhIL0VseVlRQVBVSVhFand0?=
 =?utf-8?Q?IXOTfD+H2gwNOEGM=3D?=
X-Exchange-RoutingPolicyChecked: c0DZrP7ZUedt/KtzYZ+xavW3s0QFQ8ZNceJwyUyEG7j+dBcNmhMcc6oi8i+SJDPp1HnVW1eo2UOEONnIWM6zw8vcp5Z34bYG8AvbhFZFG2lwP+cZPYonnua0jaIBEKQ+Vug/g9eg3I7tz/bBC9CTS9RsbsD+GaH1V4XgFT6S1+naCdlbY4jZ0aH8SIDwgrdd2RTQcidcGkc2zmyddjtXPj/byB3RIFR26zgJc58K9Q+2Vq9Zh25Paxu7d9s6MPYwNQ7gIkqDqXn2ousgnaFBwuYBwDiXZkZJhGPJ1mU9Lqd2aWKJRqrQ1oieSaB8FUET0R42MEa9SF/+xaiJoLdEEw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 12019663-a972-4b0b-707f-08dee782db8b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 23:50:34.9941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrOB3wmXChaWHZhV6XpQLjucDWpfQpD/KYcWp6zq3UmwZE7LlIH7Vgi+zsoDDTjttvpCqXKRNCiszZ+NRKbryb1yd/zvmXFYHeyR03La2+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com

Hi Boris,

On 7/21/26 4:15 PM, Borislav Petkov wrote:
> On Tue, Jul 21, 2026 at 09:14:20AM -0700, Reinette Chatre wrote:
>> On 7/20/26 6:59 PM, Borislav Petkov wrote:
>>> On Tue, Jun 30, 2026 at 09:27:02PM -0700, Reinette Chatre wrote:
>>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>>> index bca782050198..9b9495174041 100644
>>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>>> @@ -247,7 +247,11 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>>>>  
>>>>  	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
>>>>  	hw_res->num_closid = edx + 1;
>>>> -	r->membw.max_bw = 1 << eax;
>>>> +	if (BITS_PER_TYPE(r->membw.max_bw) <= eax) {
>>>> +		pr_warn("Unable to support hardware's maximum bandwidth\n");
>>>> +		return false;
>>>> +	}
>>>> +	r->membw.max_bw = BIT(eax);
>>>
>>> Why?
>>>
>>> Why go all the effort if the field can be 64 bits?
>>>
>>> Why not make max_bw u64 and handle *all* possible values naturally?
>>>
>>
>> resctrl does not support values larger than u32.
>>
>> The value represented by max_bw provides the upper limit of control values that
>> user space can configure via the schemata file, which in turn represents the
>> control value programmed to hardware.
>>
>> u32 is expected in several places:
>> - Parsing of user input in bw_validate() is done via kstrtou32() placing result in
>>   "u32 bw". It is this value that is compared against max_bw and would thus need to
>>   change as a consequence.
>> - Parsing of user input to schemata file via parse_bw() places parsed bandwidth in
>>   "u32 bw_val".
>> - Upon successful parsing the control value is staged by resctrl fs in
>>   resctrl_staged_config::new_ctrl that is u32.
>> - On receipt of programming request from resctrl fs, the x86 architectural specific
>>   code programs the control value to rdt_hw_ctrl_domain::ctrl_val[] that are u32.
>>
>> resctrl, from fs to x86 architecture and now also MPAM, would thus require changes to
>> support these AMD systems. If I get the math right this will be systems that support 
>> 1073741823.875GB/s and up?
>>
>> If resctrl is required to support AMD hardware that can return up to 64bits here
>> then that requires more changes than what I am able to take on at this time. From
>> my side I prefer to stick to this resctrl safeguard for the scenario and leave support
>> for this hardware to AMD.
> 
> So that bandwidth limit thing is read from those L3QOS_BW_CONTROL_n MSRs which
> have
> 
> BW_LEN-1:0 as the range which is the bandwidth limit, at
> BW_LEN there's the unlimited bandwidth limit
> 
> and that BW_LEN is read from CPUID.
> 
> And that is, kinda 12, right now.
> 
> And your worry is that some day that limit BW_LEN might go over 31?

This is theoretical since the spec/hardware technically supports larger values
than what resctrl supports. This could take the form of actual hardware or some
model aimed at testing limits.

> 
> Which your math shows how absurd this is.
> 
> So what are we actually fixing here?
> 
> Something some AI hallucinated that it might be possible at some point in the
> very distant, dark future?
Not an AI hallucination but something encountered during my earlier attempts
at getting resctrl to pass with fewer issues reported by the various deterministic
tools, in this case a static checker, that I run as part of checking resctrl
health. 

I aim to highlight this caveat in the changelog with:
	Whether this could ever represent a reasonable bandwidth value is unknown
	but addressing the issue will appease static checkers.

I see how such change could be considered absurd. I am ok to drop it from the series
and just keep treating it's report locally as a false positive.

Reinette
