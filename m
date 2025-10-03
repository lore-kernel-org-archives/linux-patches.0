Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08537205AB6
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759535782; cv=fail; b=DQjh9iXhOVyDDfUeBzsrKneUD7fNPIJB6M0O1TEuRHPTfn/rHNfb3Ix07l4kSXgjnai5PAzSPe98CQTIHLFyXYBSzCRWyUtCmE3/jeX0wr1tlAcLGhh0dP7yxwvZB0G/frXwjwVbPu01DJx0aFWrX0F/4gyc2LDow13cumfrWkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759535782; c=relaxed/simple;
	bh=b+qv22vvdvnBceSYfGYPGXdGyR1AmGZ0MC410Mbzqe0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eiyBGnqo61UMUhWpm62xH468a1WH+evnS+AduYxYb4+Tb9NSrhZIQmk5RyxkaRyjYJradjUW8ruPIiRpqILEfRuW4TlzALZjNPshF+6ne03W5UJqppnDVxJXRUXK6vfiy2M9R/n91/acY37QQ5IOEaXQqofj4iWQQ8ZqOYdT0pU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lt+/DntF; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lt+/DntF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759535781; x=1791071781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b+qv22vvdvnBceSYfGYPGXdGyR1AmGZ0MC410Mbzqe0=;
  b=Lt+/DntFW5wIEzJCcuZ7I832oBNUmEMHBdRzzQk/XVM6RR8HpP3NMsC0
   4G58WLda2JY4zBs5clzh2bDvkqR2LnTUJ+RwWhtid/AJ1TLJDsHEFEBaX
   TQ6EiAPdaypSvPDtD09LlC5Ense/I4BztRPQT/VUizxwDmbmfBK6/Tkaa
   sELtzl/pVhJrWdmkq+7E9D8ahpziYUGT0vue81NR6XiSn1bUONe6RQDVt
   P0TQ6g+WXbIl0EJyrccKUTMBzHtYgSKb7pnDur/Mw6hSbkUY4OKaUcKhI
   uPW+sf+gnegU8tgow3sDGNiSuYf70F+rv0jE1xx7cPv3xsbqFEqrsxarv
   g==;
X-CSE-ConnectionGUID: ScN+p7FJTYa1027/UivgmA==
X-CSE-MsgGUID: C7SOYJd9R/2N1Takmjkbgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73172548"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="73172548"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:56:21 -0700
X-CSE-ConnectionGUID: 2otltg1hQcSxEUZgMWX45Q==
X-CSE-MsgGUID: Q/3+BNsAQki8n0gjquAo/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179326310"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:56:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:56:19 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:56:19 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.5) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:56:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3YcB0fA8/RmAMiBV/wHSf61st3F1wP7hR6mdgZvl6BFP/8EGTB9tvyx8FRMNxI6nlzrSOMJMIMbUf6N9m2HceO3GsI9b5YV8md9YBfW9Oi0tvPR/I+jUZ1ni911dp8iuo3uu2zXavoLEebHmuASim0OJl7bM9zBvbugRdkN8AK/aon1euY9tNiu+STvuC9VJeL4VuLCrDY7x3sTc0JNbRNOEUizau7v8R3bbbhr/lUVPlLpI/iYoNv1c4t6PgaIfOa974H9bx5Yewx9BVjHi0+SsYPu7IEyUbNcM432vg+m3lXp1UjJGd/i/E+b/If+pBzKAkg867s1WUntWg6Yyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JwkLYf3eiQ7KLNKpgBkRLSwroS6ohRH9PfkU3bvc7o=;
 b=bFf+wiJ1xubdMfzOv00l3HoU2wBcvzOHVAXXJo5YOtBZbMxGj58ZUtT9x1dDbCN1GQRYA8eCDwM1pKIY/84D/Ank/mhvgx5F7NJIkxHnIpIpLtZsbtPW/QjeiW3imnxMg3y8JZv5NOs3Lz2wKTyvGS0srPICVPfr/jwtFeGrMSiIcsiM9pVn7bud2vQ0zmekBiIE3lTtvztNo2gikyf5iq3Zz12G5r6jHDSLcNKsrX5Zdku+p0+prto5bMWqGsIGKVDdpytG3nC+hONL+2TsqU9UAk8kiDpU1mLOW0E9rUd2jLL/1O3itZbJLaXrkldgT6hXDvpc+SA25CzeNe1DiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 23:56:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:56:13 +0000
Message-ID: <ba1e8bc8-a3b3-411a-85b9-c20cc23d8adb@intel.com>
Date: Fri, 3 Oct 2025 16:56:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 18/31] fs/resctrl: Refactor L3 specific parts of
 __mon_event_count()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:303:b6::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cf248a-bd6d-4bec-40f4-08de02d86efc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QjdCMWVrL2kvSXltTktoeU5yTkwxVFV1eXRQK0xWRlVnUGNIZVlYTERYUzlK?=
 =?utf-8?B?eFhvRG14UzI0eFo5T1Q4T3Nyc016ZUdHa0lGSFVFOHpGWGhnbktMTi93OWlv?=
 =?utf-8?B?dThDOUtPQkowZjZvckxtWkRSWTlmMWlnUU5tcnI1OStrUTh6ajBhWnZwRnlB?=
 =?utf-8?B?TytHMGljbklxTjhXNXNhQVpOWVJhbnhWUzdJbW5LNjJYanFndllSTDY0NDdq?=
 =?utf-8?B?cEI0eGZ5ZEJ5L3R6b0U3cGlBZGE1bUk4R1IyVUdMMkZRckY1dkorWFp0czNJ?=
 =?utf-8?B?aXZzajI2c2hRa1RlT1NmYXZTWDVPL3k5ZTVCVWN0OHZidDhpalM3cWcyeGNp?=
 =?utf-8?B?NSt1bHBqRTIrLzkrak43Z1ZYZWJqNW1iSWN0UzREdklzTlBZcmorYXhnM09i?=
 =?utf-8?B?QVBCTnBlbmo2WlErV2JlODlueUptK3poQTE1dzZ6OUIyaWxXbTVwVm9NT21H?=
 =?utf-8?B?Y2tlbmlDZHlVa3QwVitxQXFNZUovWlVFVE9VNHhsZ1RQdDhqSnhDLzM1SGQv?=
 =?utf-8?B?TnBrTzhycm1DRG1qTkZOcVpBZWwwbEdHM01LMExGVWZlM2JOV0syd2NkQmx2?=
 =?utf-8?B?ak1YT1cyTE9jb3EwWm5hbitDd3FuZmE0MEYzbnQwT2RXYzFDb3NKa1A2blF0?=
 =?utf-8?B?YU85dFJhamdVeGREWGxNWGhZNnp4WlBCMGVOUUFjcWJRanRrZkZsY0tuQXlS?=
 =?utf-8?B?V0gzbFhhaG1IcFZNazhzQnloQm1GeU9QU2hhRVJKajB6aVFvWmJIWHRZK3hB?=
 =?utf-8?B?WkdMci9hOXF4TWRLNzdXSDQ2S1hhdUFoSlBwV2ZQK2xkQkp5bFdmVkdhMEhS?=
 =?utf-8?B?dnlxbFFGRE1EU1ZqdjZZSlFMYUlMZVE5UUdGc01yR1hEbG8rOU9YS3dnZktD?=
 =?utf-8?B?K2g2MHJlUjQwQ2dLTXBtbVkrQ2R5WU00aVl1R1RXRWR2V21tOW5xS0VwZDZv?=
 =?utf-8?B?bUhrb3RsSmZERWVrRXFFRG15RTgyWlpBem9jMnZBSW1ySWF6TnU3bXM3aW1i?=
 =?utf-8?B?L0JPTHNaT2pSeEpqcWRoSlpjblNMR1dlOFRkNTdwaTJjaWhDT2VxVDI2Z3ds?=
 =?utf-8?B?RHNTVXl5L05JZWhxVmM5TEl5R0hCU2NrWDlGRDhLbkFPVHRaem8wTDVGdWVE?=
 =?utf-8?B?QTdWenR5YzVVYm1nY2J6WHJmRURvbGxGTkt3MG1ES1liaUZXSWErQ2xDa3dy?=
 =?utf-8?B?RHZLNFpEWXhQenJVMW5Eamlyc3daOE13K0x2Z0VjQllsNktVbzRrNEl2QjlF?=
 =?utf-8?B?czdOUk1MVDhiS29ZY3FxdUMremJOTFNpd245TFI1Y0ZlNlZsZURzQU5MUFJn?=
 =?utf-8?B?ckx3S0FLQXFCeERxSyt5VitHbWoxQVNPYmNjRm5xaVg1dCs3QSsxNE1RN0pL?=
 =?utf-8?B?bnd5NitReFZkS25zc1ljcFV1a21XUUIzT3lqYlNkcVlkWSswVDlobDA2YUlE?=
 =?utf-8?B?c0hEcGVIS2dwdVNVRGNPME9VRklkbzN4alRnRk1FQ3p2cGdWeng3bHRUR25R?=
 =?utf-8?B?UzJQM3NYSXl3N1RxbVp2KzAwTGNHcW5yamRmT1gyUktLRExyUFBnMDJGQW1v?=
 =?utf-8?B?dUtaeFJMTTN5YVcrajF0SVJsem9WMnVIY2lMV1RVR0RoTjdabU8xQWpxV0Jw?=
 =?utf-8?B?elRmTERwS0F4TzZFdy9sdFFCaVpXS3VRdjZlMEYzQlRoZTgwZVJyYnVUdWUy?=
 =?utf-8?B?QklVM0pkdUswQVFsVWFGMlhnNGJheGErcDZIMXRhNUFVTVVJU3BFYmZFbHVk?=
 =?utf-8?B?TmJqOFFaQ0xYQWFadk9kUG5QTkhYQnptc0hEeHdjbktmVjlZTVdOZDlsbFlW?=
 =?utf-8?B?aUVPejc1engxaHVCd2NTOVMwd1JzamdwNUc2K05pcFdwNUxHVU41MHBIZDNh?=
 =?utf-8?B?N2dtY21OZkhqUHJiY1g2Q21zZEo3b3JwdEhxREpFSEpLRVRSdGc3Vk5RUnpE?=
 =?utf-8?Q?jinsyVvvcg8/uWaydepZKB5kLQBhzaWi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnpZSy9jYjRwelJFcUp0SXNKTVdwdkZ3VEVtaURBRnNoOWtLWnJqaWtuNTRD?=
 =?utf-8?B?aG4xbDh0a2lEdThPOTlKUDE5NFEwNGRTTUNVQ0Y5YkxBRW1aeHloSUhsT0pG?=
 =?utf-8?B?bkpuQjNKTWE1d0RKZDhZNXFlMkRvSkhNWWNvOURua3lZUGFOZkJNSmcyc0dJ?=
 =?utf-8?B?NkdxU3kyMnNkZ2ZONFpDaXh3eHM4aXllTTR6b0o1eGRjWDkwZUM4bVUvSHA3?=
 =?utf-8?B?bjhGV1RwMzQzTW9hSFBlbTZxOFFWSkl2QTJKYjYvZm5nZWRsWGVXTE1CemNH?=
 =?utf-8?B?Sll3ZG1saVAwWENFTkQ0ay9oTmlscjNJbDVlUForL29qZlpITHVJZUtjcDBG?=
 =?utf-8?B?dkNyREtRUUJENHJPR3VzMzhZWllLV1cyVkpPOXY5V0U4MnBtNzJyUFlEZ2x5?=
 =?utf-8?B?VnBGV2s1YmlhTXVWWlZ5UkR4aFlsWnJkU2dHcDV2TzZnbFc3WDBSVEExendV?=
 =?utf-8?B?cnBlL0NzSjMwcXN3R1NLYkhZcjF4N0N0N3NTbWg0VVhaVHQ5MEQ0K0VRazJj?=
 =?utf-8?B?TitCMTQ1eUhySW1Cc2cxaHZxRzlIck5hbm5XbjBTVnMybXZBT3RDYnFlSklE?=
 =?utf-8?B?cEhlbStBS0QvL092TUR0dmJoZ1JRZ2s1eExxbkYrNnNOcVJ3K0dwOEFueFN1?=
 =?utf-8?B?aUx4WU9ZRk9NT2g4cGFjMkY1QkFWSkdKN0JaYWVqZzZOVW1nR2REWExGbzUz?=
 =?utf-8?B?U2Jub0IySmNuUlJ0TGwxampzMkhJTDRBN2p4aTFGaitjMkZRYTJsaUFDaGdq?=
 =?utf-8?B?M2VrYnorWkxyTWZUOUZQcEFNRC9YYlI5ZjZGMDVBekZ1MXZjOXJwRm5yZ3I4?=
 =?utf-8?B?czVMRytGZXJ1OFdkUEhnVFE5bmhCWDMrNlpXWmIwb201VG1vS0FtK1BJanpX?=
 =?utf-8?B?Vm5wcG04QmVzbm8xczYwTXY4b3RVLzl0Unh4TXd6WDhqVFhSeHJWQVNBMUor?=
 =?utf-8?B?NUlWd3dyQTMrb3FWelF6UFl0d3kwSXZ5VXJXZmR1THBRYnJZRnNBejhuRjBS?=
 =?utf-8?B?TktWWTYwVEZGMXNUUDFWazBaUG1VTTR1MlZ3M1d4NVVlTWlVRUxDckdESFh3?=
 =?utf-8?B?aXlyZlpyZzcyTVFseDlvdjEvWE0ySUI2cjRjZXgvOEUveGhEeU0xUUE4N1BY?=
 =?utf-8?B?NUN3VlI2M1hjeUp0M29GeFJqZ0JGQ1hRK3BJdksvbUZDTFh6M2dvR1NoUERD?=
 =?utf-8?B?NWpyMDBOTm1sMVF5and5aGVJUlZudXV2VTNxREhWSktzWXZxaWVtQ1pwZ1l6?=
 =?utf-8?B?VDZBN3hFTVdxNUV6R2RJVFA1ODl3SUQvU1VNWkNFNXJhUHJmSWRHQmNTKzkr?=
 =?utf-8?B?aW5JS0RiKzFOdDFVcXlGT3ZJYXFSdWlZR1g4dWpDNWVVdlI4cFp4WTF6c0RC?=
 =?utf-8?B?Z3h2dDhmdVVxV2lpeVp3UWVXN2NLVThhS1lYemVoeVg5aU5KejFvcDNvbFNo?=
 =?utf-8?B?aW4yNUx0YXZPTXBma1I3Mm5FTFJBMkdBL3ZGSWZDMVF3MVRneEdXN0I4c0E0?=
 =?utf-8?B?VWdUcnJLUFIwY2ZjQkIzZkhabnlpaG5CL0tucjVHekxROVRxRHY1V09vVFAv?=
 =?utf-8?B?NDlnUitCaGRuZllkUmVNYk1jbG9pdXpGMU1pS25Cd1kvSGova1hUSFlUZXRn?=
 =?utf-8?B?QUVKcUxIUzIrbjZjd3AzUmtuSWt3aTNrWldjTkJuQitaZE4wZDgxaFZmcEg0?=
 =?utf-8?B?UmFuTUduUXVoeVpMNnBkN2tOZmg2VnM1YkFmQXlXTEkwNXZBMUhIcTdiTnhB?=
 =?utf-8?B?MFZ5Q1BKUXYwbjlKS2RPTExLd2o0ejVzNXV3azFJWG9vUGNtN1BKa3lMdWhn?=
 =?utf-8?B?d2l2WnpzazNmOEFuTVBWRGQrTlVCeGdaTWZtUmZuNE9penI0OGFpVjBEY0xM?=
 =?utf-8?B?RWxIcEd1VEkvYUR3ZzRzZ2V1SDV6Z2FUWDgzVCthTjRCeHNNNmJvdmF2ZXc0?=
 =?utf-8?B?THkzblVrbkJ1TU5HRWNtOWg5ckk0ck82QmlNdWFDOGdqYmZ0YVQ0ZjR4UlAw?=
 =?utf-8?B?MGhyU2hxMDRad0lRenFtcTZNQkR1bFdhc2JPQnR6OWpnMmJ1SUpKa1d0ZElz?=
 =?utf-8?B?aFg5T2hHVktnYUZoREhlanJ6RkQ5dHZ3M1dWMytaakx4OFYvU3ZWUFMyRHA4?=
 =?utf-8?B?NGhBQlhWTkxQcFFCUkN6ZWVYRjMxZWNvZCtQakk4L1JkMTYrSk5xNUR1WVE3?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cf248a-bd6d-4bec-40f4-08de02d86efc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:56:13.2583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chAnmo9aAutjLEiVglfQ7f6qVnU7g4qxRf18+53fKvqR5REbEdpAwMuTBv0LFfeP5iJ+K78bVrfWInATK1/wcO3DYK6X/eSZn1MkJf9Dn0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> The "MBM counter assignment" and "reset counter on first read" features
> are only applicable to the RDT_RESOURCE_L3 resource.
> 
> Add a check for the RDT_RESOURCE_L3 resource.

Why?

"Add a check for the RDT_RESOURCE_L3 resource" can be seen from code.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/monitor.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 1eb054749d20..d484983c0f02 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -453,27 +453,29 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	if (!cpu_on_correct_domain(rr))
>  		return -EINVAL;
>  
> -	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> -		return -EINVAL;
> -	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
> -
> -	if (rr->is_mbm_cntr) {
> -		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
> -		if (cntr_id < 0) {
> -			rr->err = -ENOENT;
> +	if (rr->r->rid == RDT_RESOURCE_L3) {
> +		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>  			return -EINVAL;

This snippet keeps moving around but it remains problematic from what I can tell since rr->hdr
can still be NULL here.

> +		d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
> +
> +		if (rr->is_mbm_cntr) {
> +			cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
> +			if (cntr_id < 0) {
> +				rr->err = -ENOENT;
> +				return -EINVAL;
> +			}
>  		}
> -	}
>  
> -	if (rr->first) {
> -		if (rr->is_mbm_cntr)
> -			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evt->evtid);
> -		else
> -			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
> -		m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
> -		if (m)
> -			memset(m, 0, sizeof(struct mbm_state));
> -		return 0;
> +		if (rr->first) {
> +			if (rr->is_mbm_cntr)
> +				resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evt->evtid);
> +			else
> +				resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
> +			m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
> +			if (m)
> +				memset(m, 0, sizeof(struct mbm_state));
> +			return 0;
> +		}
>  	}

__mon_event_count() is now unreasonably complicated. One motivation from changelog is because
"MBM counter assignment is only applicable to RDT_RESOURCE_L3" but then the change proceeds
to only add a RDT_RESOURCE_L3 check in some parts of __mon_event_count() that deals
with counter assignment and leaves other parts to rely on rmid_read properties. It also
fails to mention or make explicit that all the special SNC handling is only applicable to
L3 and leaves that code to seemingly be generic and reader needs to be very familiar with
the code to know differently. I find SNC already a challenge and find this to increase that
complexity unnecessarily.

PERF_PKG only needs to reach a handful of lines in __mon_event_count() to read a counter.
I thus think the best way forward is to split __mon_event_count() and move all the L3 code
into its own function. 

Reinette

