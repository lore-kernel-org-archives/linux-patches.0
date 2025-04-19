Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D46F3EA63
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 00:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745023746; cv=fail; b=g0V4JojZwPhzqcELn81Qa/AjX3K25AKk2VcnNx+bQm39MhiKyDvS9l1lhIxV0Ky6Qdq6mEgr/2nC9pC5WAL3DW2QJ7kXu6oByBneTfBXe7GLBeO5+Mrv9FCNnWxsnOwTMECdttf4BugmC0mWDAapW5n5gamzoVA0nLGw3M7o6Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745023746; c=relaxed/simple;
	bh=VhfuupNd/W+K/PEk5bsWmr1+K/uF3Dds02PE2Qw75qA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s3zdF0QHu4Be5uAxnFbv+upYcZQi6UcIsab35ywP4x68PW6AOS/ejGUYu2y4Z4/VKbAYhAFekGVVDCccmOHpejOfF9mEh41QLgVIZEKRa/8GUvL7t6itF33DHr/Nr72oteClZMB7QFNxpDbsIi/fsm1mxY6KXGyt4Pwv8xPazIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZScS9XJ0; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZScS9XJ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745023746; x=1776559746;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VhfuupNd/W+K/PEk5bsWmr1+K/uF3Dds02PE2Qw75qA=;
  b=ZScS9XJ0NJA0kDu9Luo/BRpom/djl1mX0zMTC+gYZcBZf2qe0ppx3Fs8
   IC7n6FRXAAtKnTMxFEbiIrVmAcEaHekfc+/1bHgJYWcOfHoUB/sFX+ol7
   VoGd5jEy8nc4vjzfQdyyhLqqEXV81i8Y4ZxgP/x+91asjjfsGxqSc9ooG
   8A9m9w8AO8nZErjj6VKTaczmuUF9Mbf4J0SA6mkumQLMaoDM0KCaeV/Ts
   4qEeuG8pezQNmWV4nLAntuT8w7NgCpaJYBnBVupt+1b/tJ67aOoDdpgza
   mUI8AQntiu+v5H+S6mfyLEnROcJCAWsT5zBTKDOylf1HMk7VXZm5Oi6ax
   w==;
X-CSE-ConnectionGUID: QsYF0NKKSQW/Q7/AdaVWKg==
X-CSE-MsgGUID: Tkpeco1xTaSKESdpsRp8Iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46664001"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="46664001"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:49:04 -0700
X-CSE-ConnectionGUID: v4ay3qm/QiC2Xf7eZveivg==
X-CSE-MsgGUID: jct+pxbDSgurUqIiQ690OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="136114362"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:49:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 17:49:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 17:49:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 17:49:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6Tm3PaCNzQkoz6mJycEANqSbRlP9Z/4RQ9s31X6yoiDh4zN7+RkSyfsUFvK2keVbYjOeYv38Micp6vTE1ThS5BuN/DI9vu0JyNeFREFRouTN5WNszMjEiVK5vSK6qwGqOXACHtZ3TMdf+FakO/6hqKlo79rhrUbHvM6r+Sr+Jgo+7HUpYwy/usw03crkOenQPwz9Za3plajoR7CsQo9oaTJQMwgJWt2r8LkPEBp/S2Ajl+QaIl+Amw3TNNw7bYWDtqkJG2vtihBiu3rRNJ96O5pj7NR5aDaPxqhWCHRAgE3JJyaLeLw7SgI0MXAatK1wt994URrYiD1W2h+YCvjsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spThcm1W0vN4O0x+kMvzzjuGLerzRGkh1UW//nAPFjE=;
 b=fD5lGkbUI8Mxd7V6nhV3e4jey7S76a57O4kDzdUi/p5MucVk3sfljZqQwLj0LpgWlclLs9TBmKpMDTAn+5ZAxZBbaDp43aHataxBHDoKk+DSlxQOMgBnHjPL4F6jJQXJb+e32gtTzouSKj6bg0pSIkSguujFp22cBojKY4RD+sTwevSrQCaWKntosr82gq8bwv+Nwazo5DiWu2vThoBjzdK//TKhHwqFzbUX+YB7UKJn1A8sazpEiQcnlFwDHIeOsbIvp0p5Cp//jTs3fE3mbZTndFCK0NnAwqG4OIvcLzo0KI6rf0E4pNh1FH2kpgIeSHBHP3e4Nm0LLsZugQzV6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7571.namprd11.prod.outlook.com (2603:10b6:510:27e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Sat, 19 Apr
 2025 00:48:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 00:48:47 +0000
Message-ID: <7bb97892-16fd-49c5-90f0-223526ebdf4c@intel.com>
Date: Fri, 18 Apr 2025 17:48:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/26] x86/resctrl: Build a lookup table for each
 resctrl event id
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ee83c3-d093-4bd9-c436-08dd7edbf162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NDdqK3YyNWdsRnZFWFpZZW0zVnJzaXVPWWpzU05lSFdkNGo4SUphWHlWcDhp?=
 =?utf-8?B?dStjM05aZ3F6Vys0a25yQzI4K2ZwWmdOSUxUK2drMytmL2RlaU5xSVVRYkZV?=
 =?utf-8?B?ZSs5WlIzaWtVbHVUZklFTFNmZ0hkMjBPMEdKNnJnYUlkZGRvTy9uUGNUM01w?=
 =?utf-8?B?VjRWK1R4ZkhxQ1plVmRVSzZPK1IweDFTVkRsOHJFdURRc2dCNFNrbXpZeXJt?=
 =?utf-8?B?VG1uWmxXclg5WWNpTUxTUThPY3oyTGdnK24wMEtKYzNMM1diRXRkcFV0Z3Yw?=
 =?utf-8?B?MEhBUDFsQjBRUFEyS2QxM0xIRUhnU1FCVnRzN1hqbEdQWW1GWjVXN1NGb3Uw?=
 =?utf-8?B?WHRxQ0tzRzRhZUp2QlI2cmM0eHVYRU52SXlWUHl5WFB2dkZaNktsQ1BtZHM0?=
 =?utf-8?B?emRFNUtsa1ZaSGcvWFNHREw4bHEyUjUvVkUrbnpmdjM2UlFaRkVLbkNxOVl4?=
 =?utf-8?B?S3BYSVh3cXpDOGFKakRwMW1aNjd3UXJmTDhUeU1KTGxKSS9sNDB4Y1Mya25S?=
 =?utf-8?B?bU1GSkhRdFpIeVZLN2ZTNVlqSDc4NlBvcXlMeVEzRXgySnZHSGxzOURXY090?=
 =?utf-8?B?YjJWQU9WOWRYSUhkMDJhL3JQY2c2MW00UUNYNFRoQ1Nia3hLT2U4dEZ4c0FG?=
 =?utf-8?B?SHFFR0Z4UFBQNmVMV20rckdjYm9hbjdId09jUUFIS1ZPTmozS3k2MXVKTXV4?=
 =?utf-8?B?SDJ2VW9DeEVlTUdHNTV6OUpUbFhta1B6NllEdXFLN3RTblg5bmVLWjVCMk5Y?=
 =?utf-8?B?QlNRSTdGbmtvRXBXeGo1Sjh6Vy9RTDFYRGZFUVhCdzRuakZkemxCY0Z5SDZ0?=
 =?utf-8?B?ajhMckNTcnFhdUxrWDR2cWpsajEwMnlYMDBpL2hnK1VhUzlBeXpYbURJUzYv?=
 =?utf-8?B?dkFyZEU1T3dLNVhiUEI5Z3djb1o3SWhQZFM1akFNTTJ4NFFLZkUzVjhUaktq?=
 =?utf-8?B?a29heTVMUWpDbXBJWFZLT1hOQ0I5S1ZKUWhxaExuVmtJVCtkTnZDZVJiQ2hl?=
 =?utf-8?B?UXoySEhzcS9kNHpJMEtIKzc3c3QrRFFVR3R4anBOeUlGOTlxMnhzbWRteDR2?=
 =?utf-8?B?V09ldE1sOUxKVm1MQTJ6eTZUNUF1MXg4U2daNThmOGxaUTFrcHpGc3ZZTHpT?=
 =?utf-8?B?dEpsUVFHSlV5ZC8reUNzSE1qYnFIcnhmNXVtN2o2QVlJenNLQkxCNXlxRFNS?=
 =?utf-8?B?T3R6UmwzNExCNWRjcmptZzRwQmNFZC9OcGhSNzZTQk9xdVFRbEljT0UyZzUy?=
 =?utf-8?B?K09aN29iVE5MbVovMjdYeStEbndHWm1UVWQzOE9yQUxxUXdsRVJJWW4xRDRB?=
 =?utf-8?B?aDBRV2t6WXh6am5UUTZNUFhQaGZ5YVBJNW9zMDVWNDJQSDgxL1hVK1BWbkx2?=
 =?utf-8?B?SHBZc3BxUTBKanlvRWNPb1hIYzZzV1BZN29CLzhKalVjc0Y1QUNwcGUwT0VV?=
 =?utf-8?B?R1hTWVN1NFJ4enRtRld3OWJ5OEZoSzFtMGFBN0xMTERtaC9Kcmc3OHZlOGth?=
 =?utf-8?B?OWFaNElOeCt0d01LNlRJcDZBVU1MWStTMUdVS0ZnTjdyanRQZXdjR1FYRmlM?=
 =?utf-8?B?d3JScDdUMEE3NFNmOUIvWlZkUm5HRTJ2a0MvK2hXNC81ci94TXJMTUpsSFV1?=
 =?utf-8?B?V2gxVGUzQ0VWc1V1alV4VWpGOFQxTmhxRWdMVUU2cC9UUjdZYUZYa2dUUFA3?=
 =?utf-8?B?VkRsSG1mZmJ1N3ZvbEMvQTBQUE5vZTRJOHNtbWlIWG5RZEFwR3BRbzZtNS9X?=
 =?utf-8?B?Q21xREtFMnAvM0hVeGRubTc0czFmNE9rUmg4aXAxRkdraVBPZVlOeitBdkt0?=
 =?utf-8?B?SUJoeE1PaG1MZURpemZlN05LdXVsdms3OVliYTB2K2RLalJmR0RWWnhwQVM1?=
 =?utf-8?B?bFFVLzNid0dmeFJaVGRxU2xreWh5WlE2ZVB6cENjaTJXeDdNcldsR213dWZQ?=
 =?utf-8?Q?+i8oaupo43A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWRQWW5TNFY2WXdVa1FRYnhsaU5PcnVRNzdMM0lpaE1jbjRYckZRYWpTdFRj?=
 =?utf-8?B?SjU4Vy8vS1IwL3AydEVUL3lTS0F6UER3R0xBRktva1gzcEp5MnEvN1UxaEpN?=
 =?utf-8?B?UmdsQmFwMUNnb1BNMjNKYmNaSVdCMytJekw4b3oxTzVBc09LRDcxb0g4L2M3?=
 =?utf-8?B?WlVCTEFvUitBSFhUM0pFaVpUN3NmbUxHc1d2OGdwZTJoM0MweUtxTUJnVjRO?=
 =?utf-8?B?WjdNVUZZeFl2clFEL0RyQytFS2pTbC9JZDE3R25GMVlGMEN5YklDbVdvV3Vw?=
 =?utf-8?B?czZ3UjhacVFOdmR6MkErSHNtRHhqY0tNY1J0Y1IrM2w1M2k3M1JsT3FQRHdN?=
 =?utf-8?B?Yi9zeHVGa0hhQjN2N0Q0Z1lXa0srNldNK0ZKL3k4RlRMYUVva05adEorNytP?=
 =?utf-8?B?YnlIaTM5b0d2RVY1cE1YSE1MUGorMkV3bS9QdktOOVFnTVBYTHIzbEc3c3FE?=
 =?utf-8?B?OGhrSXNCYllJTHZCZDZneWNpdnZYeTE3SjVGVW1IRURjMllJTDBUK0hVSGZi?=
 =?utf-8?B?NStnKzFqdVY3dXJzeTJid3NydmVZdTRwaFFGM0lUSGtkTUl2MjM3Uk0rQ3lz?=
 =?utf-8?B?NTNhRGdCd1dDV3RuU3V2cldKUXlhcXhKcGJaeVhCb2V4WktRVUgvMXUrSG1a?=
 =?utf-8?B?Ykg1SG90V1FJQmFuYm1PMHhWakRVRjgxRXFUQUpXeUgvbUVyNXFTbFJwWVIz?=
 =?utf-8?B?UDVaeit1MWlGNzUwbjV4KzJ2Ny9YUTRJbG14Tzl1VFFza09rTlFXVnN3T00z?=
 =?utf-8?B?THduQ3Z1VVpBaFdXQUJMenZZRGV4YTI3ODBzSStGQUErTTBra3RqK0ZUMHgz?=
 =?utf-8?B?WXhrcnVhOUkweVNLWG4ya2FMQ3A0OXZLOVJqWFRDakw2NTJrVENUOWR5STRx?=
 =?utf-8?B?ZklRb0ZtY2wxQ2RSY3MxZUNTRjhtVjVlZ2xFaHRBRGUzczZPV3JwSHNET3hj?=
 =?utf-8?B?NGpDZjNJN1Bnd3IrQWpqZWhFejV2V0JwZnpGclp4U3YwUmVFQmxtKzJKOFg2?=
 =?utf-8?B?clQwc0IxWURuWk1Pd0NUQWNLK2RPcEc3MW4zZVlJalp1c1RRSHZvL2RwQkI1?=
 =?utf-8?B?TEhneE0zWXJmNFBlOUZiZXVwOThVbC9UdGhVdFpFaEdGenJqY3VPWGgxT1VG?=
 =?utf-8?B?VkZ3ZHlRc1hpb3BSTDYzRUplbnZ4RE1hd2RIb21MejFLVHdhRnJmcXRpSGhH?=
 =?utf-8?B?S1BucUw4VDNsa0JtcE9lOEZlVk1mZmN1aE1oZ1VmUnVrK2pIaDVjS2NOUysz?=
 =?utf-8?B?Rk01NVVHcVRHS05iZFNNTmFPNWZ1Z3hRNmNqeVRiVTZTL3lxVWVDTzZMZVZl?=
 =?utf-8?B?cWh5SnlqYXhTZHM0Q1ZqWFgya0pWN0dYZHRWVFVkV2hSc2crNVI1UUlxbFI2?=
 =?utf-8?B?bG00WmFLSmh3QzE5bFJ3L2NwQmxPcEZBWjNVQWJQZFNUbng0QTN2RFVZVGJt?=
 =?utf-8?B?VXErbzRXYzlYNTZyMFMxbkpFZnY4a2h6cjNCUGNKenRMTU84UDdzNzlORTN5?=
 =?utf-8?B?VW02dXJoczBnNC9UcExiWHVTaDB5cjBRRkR4MGIvNVNEY3RnWmdyZFBMUWpo?=
 =?utf-8?B?a216TzNaQ2tYclUwdEpnZkwzQlhhcDVHOXNIVDF6Nk9jcWpFMEdiNTZ5S082?=
 =?utf-8?B?dFZZT3pjSFhHZlA5UEd0OS9wTEx6dnp4NEIyYTVZa0xXNGJ2WHlQc3lNRHJ1?=
 =?utf-8?B?WHlsVkl0NnNaRzgrUytrUTIrNU5sOUNCb3BmS25naEJjWnhjRVJXZGxJTFlx?=
 =?utf-8?B?ejNLMDNkdkF0bEp1bklpc2FuVEZNWk9ESGVwcytSd291SlNXNWp1dUNzUHpC?=
 =?utf-8?B?WjRod1hlajZqTmlDQmp6WmVTd004dGxkelFVQXlRRTRMaGRJUlZwcHVFbnQ0?=
 =?utf-8?B?enlhMi9WaVg1Q3R5NFppWDJvbE9Ha05mKzNqY1dKWGhVOGVNUVV2eUpNdU9q?=
 =?utf-8?B?UnpWYXptUit5cnk3R0FmQUZMSjZlMkkxcFBmUHp5QkhIM0Y1Q0pzQXplZ1k0?=
 =?utf-8?B?WklDTXlleEYzZnlGQ0l3NTNJNTZ5R3l6bGt5NWs4SGZOMnM5NnhpNHp5V3lk?=
 =?utf-8?B?MzNHd3laclMxbi9IYVNIb2xSNGlMT0I2bTdFaUNOUmd2S3E3dkFTc2dHbmkz?=
 =?utf-8?B?VjR6eXRJVkFqdXQ0b3Y4Qk5ORDk5dEhNSEZIdndKeFZCbXVVSWppOVVHTjY5?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ee83c3-d093-4bd9-c436-08dd7edbf162
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 00:48:47.0803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0561r53H1EHmYROeEkYVB9qOArsl9HzNk7oZBNPjeLrIUniVx6G1UhH3kWr/elCMkZ8jFQoioY2u+N15DhVPGjh+m0EmHlqxyfIrV89kib0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7571
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> User requests to read events arrive from the file system layer
> with a domain id, RMID, and resctrl event id. Responding to
> those requests needs information from various structures.
> 
> Build a quick lookup table indexed by resctrl event id.

Why is a second lookup table needed? What about the
lookup table ("all_events") that patch #2 introduced?

Perhaps struct mon_evt could get a "void *priv" or related
member that points to event's private data that varies by
type of event?

Reinette
