Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4691C84D3
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745011396; cv=fail; b=i+rIy2SgobFpfNdL8S6iq9oIHHZaDs6w2vPew3pEnaZf/jN3v1sHq5i74KtD2UFdVidqV1h87LJF4/3iXyZi2z03GF2U1T0GmeyI607J+WCfUfeHMcqjdAtIhTIYCRNOnD5g3vAijc1JTROTJZDwucuYFfwhYxiWAmsUno18v8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745011396; c=relaxed/simple;
	bh=i7otreqn5pYLKNpGDROzfRSGe9ONWZLMq3BjO/YXhSA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lx+qTSX21R61nSfB2XG1vNLUpkbB8vZba8I6yLTt3C6XE/pJIg9Nxi0yTXswArqxjO5biOsf6sJS/IxNvMjvkwUgrdgJDZzF+aA9WEq56bpTrS7h5++jspUcHKPoTmJI8QzHR0efK2pnrNwKVNU3btNxUoBqnbvq2OcAxJ8Tyb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmSJPKSy; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmSJPKSy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745011395; x=1776547395;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i7otreqn5pYLKNpGDROzfRSGe9ONWZLMq3BjO/YXhSA=;
  b=OmSJPKSy0S8wEAyflX/FKkSffjm1iMG3gnR6dproRd2zGrgQVGyViSX5
   tmN3C11JRS+9NRhDPkcDOe4B6QnGd1CuTeIo9d0JWnSh52Gbd2EmtllXU
   +ioPVzmCunHw5X0he+8tvTDRhnVYNt3XEidHah/IK6CIAslYFK4gg3CpU
   QL2N+ezmeUa2mUPHHk0m/D51Fr/1tJqwkyG+oDrUNi7ydk85Dc+E2uwyr
   LxbDZB0sXKrIkw/ko6ZKKRKoFsqSmGjEcqjTAWL5/HJ2sfKXmI3fGNf0f
   ii1Szz1XyBWu3n7uVkiMaaD2Do8JKWdQm/ZDxjCvqGidQTbfZczXGBWeb
   g==;
X-CSE-ConnectionGUID: ShyPSKG4QVqB4r8S3Yv6bw==
X-CSE-MsgGUID: OTboZw9oT8+cOrJ7VexZ8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46773655"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46773655"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:23:14 -0700
X-CSE-ConnectionGUID: 6YN+9UXKQGGBhLjadDr+Mw==
X-CSE-MsgGUID: Do9eITMDRkOM2KYFi3TLRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="136312073"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:23:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:23:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:23:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psAee7hGXC7lBnj3UtKm5sXuwuxCMNOwx1D+PkW/GampNJ9blbEF/Hwxk4jGmrIgvtPrJGMm2l8rmXUdFSzRf9QJVBDLM3kBEFsR5rjvKJn02iH0w1vQvkTrkhdpIg2Z2s1HJeu5EPPKwY8J7pi/dX+JgyciewK0+xuABw4Em1r7PMiafCKaLA3QEBl46Xt0VShquhAGrY26R6lIc0iETqNI+uxry8bEL5OBJvFbmYkq42bhnwBarwWixEde7Ay1P2GAYszTgjALbeIhrW1d0DWwgFgzuGHpG+kbx1D40a/LFaqKU6MEZBwlk13vEEsxuReSkm/XCqoEIE31m2AWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v72txkmuR51DWsnhDgLtxBKkAncTbCOH/MqF1f1eBHc=;
 b=sufXe9HFQgbV1p+v0aOEri8VKxh5AKNt/EaEaGeCP+I+cJd//UXuG7Bh4M4xlJH3J9K7lOG6SnzwT4z9eoaKyegiaDRCUGTfc+1vz8gYnYBMJHQtTnxspp+if10n8P0/nth89mI6cmDWvA+VYGO4f5SXWkSMBz8DMSO9yUYf8bTAZ3p4vaL1vN9OjRe+joK2WuoNT5Ku//lxGqTKrukL9LD7WRI5i4H7fBj8RPHGUZ/B41HPegn0a0sd8nUYghtLyHcYRCcVEwyjQX5mAET+Q1RFag278Qym6C6pyF2/hQVct0L1wzvZl2WLQX8dadEbTBQoklEbgm+UlLdit6181Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5124.namprd11.prod.outlook.com (2603:10b6:303:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Fri, 18 Apr
 2025 21:23:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:23:09 +0000
Message-ID: <055c901d-4732-4923-a7b5-3936246a4980@intel.com>
Date: Fri, 18 Apr 2025 14:23:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/26] fs/resctrl: Set up Kconfig options for telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-5-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250407234032.241215-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e07b93-54e4-4a88-aff0-08dd7ebf37da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a2FlVnMvbHpMc2Y0V2x6ZXZUYnlrVDM5ZHVzYWh0aWRaeTYyb055akVUWDEv?=
 =?utf-8?B?NklPd2pQNmNVdW5IZktkQkozbk1hcHZWVS9EaWNRcHQ2UGZzNmpwVmFPVTJp?=
 =?utf-8?B?dEFUcCtTd3NNMEtNdjcyTUM5Tm9ZekFIV3dMRnc5QlFkZWJjM3JHSWdhd2pr?=
 =?utf-8?B?ck5JeFppV0JrMG5kOTJRWk0wdkNpck9QWFpYa2lSMlNPMWkvejhkQnVrWEdt?=
 =?utf-8?B?aU1RbHI4NldJRVlXd05zd0N3NzlweEFuYS9WYlJ1OWtZSjhmVVVsSE1BU056?=
 =?utf-8?B?Zll5cTNoZStHaFFFUmF3VnZsem5nVHFKZW5wZFlrYUlBNERjRVVHYkhHbW1v?=
 =?utf-8?B?ZWFVYTR6Y3E0cnFMNUpmYlpTYVpveEN3TWFoZG03MW5EZE5LelFCRXFxWXZo?=
 =?utf-8?B?MGZnRTBEbTVSSFFQSnlkQXM5U1NWV1V2QUF0RjlJWFpUOWxHTXFxU1RycXFH?=
 =?utf-8?B?T3EweFBvdlBDb2ZBdU16TnRSVjRhdWxiNmVxQjFiSk9SVmQzOVptKzVWYURC?=
 =?utf-8?B?dExtL2pVekNDcFJSVUZPNGFTK0tRUmkyMUQyaTlpR0R1YXRJbldKYWpCK1ZO?=
 =?utf-8?B?MlZ2c0RRT2FzZG1mZUVVaG1qQkJsNDRyZDNZa3N3d1p5ZkYwYlVDbklNa1VH?=
 =?utf-8?B?VEhjRi8zbnlUeEpNTUxzdGtnZXcrdHhobVh3N3VyRjBuOW9FeG1EOFlwcEph?=
 =?utf-8?B?ZCtERmZaWTJ0UVkvRGt0alZiaFN5UHQ5ZGx3WGNIaGRhc0dLRWdoRmNEeFdo?=
 =?utf-8?B?bVlsSnF2Nnh3aXdnZGdqRFpDR2pZcEtyRFdkU3l3QzV5T2tZRlpPN0U3eXdw?=
 =?utf-8?B?d3hmek56dmY2N3dzSE9SL0NCK3JFUkkrMUpmSHpTbWxtb1E1cXhPaXVJK3hS?=
 =?utf-8?B?UnRIMjRxVWdnWTV0MVhmdXh5L1J6NUtnbFVUbXo0eXlQRDEyejYxNUZOMlI4?=
 =?utf-8?B?Vk1pL3NhTURPRElST0w0ZiszQ2RQbUYvU0MyTzU2YW4vczk1dnByaXd2L2ln?=
 =?utf-8?B?ZDVGczBESGppQmhWWW9tU0ZDRnhGSkdqbWRQWTF6eFora3JZcy9QU3pmcDFX?=
 =?utf-8?B?Z0ZWdS9sQXNla013dkJ6aDk1b2ZpUDc5MEJ6RFNNRENYUnJuTzJsaXZ3VW9w?=
 =?utf-8?B?aTZ0WUc0bGdjK3ZXMi9FTEgxVkF1enkyOVhiNWQvMWVBR0tYeWFCRHltLzZH?=
 =?utf-8?B?azZIOG0zQkZCNWJZMmNXK3hsRkpCZmpWMDJuMXFZNURVdTJqd0ZlTEwwNk5n?=
 =?utf-8?B?QXJ1cFZ0ZC9sQkhQMmR4V0NGSUY4SkNwNlRlMEJmcFBqazdsUjF5dytScmp3?=
 =?utf-8?B?cjBUV1RHcmxLRVN5bFh2ZmVEdVgweGd4VmQ1VGJONmdHTTFkMlRHenUzRlBG?=
 =?utf-8?B?MzBJWTJzem40alAxaGFOM2FVUkFZOEZuL0pmWUl3eFBjejZENmdwY3F2YWFq?=
 =?utf-8?B?L1BwdS8rTlU3cTl3M0E4TVg3STJldkV0WERPZnpJa2Z0L1ViUHRQMWkvNnFW?=
 =?utf-8?B?WmxFczF3cURveDArTERMYkVVa1RkbzI0MmpHd2ZCZWI0TzJhTVJvVW5XU29r?=
 =?utf-8?B?UUpjWldLTEZYRTNpZEJpU0xUc3Q3VG9hQmwvSHgrTnBwNW92VTZDMUxwMUtk?=
 =?utf-8?B?UmUvalV2Y2FPQ2JPQ2tpRno0WE42MVBrREtpOW8xejdrSklKNDQ0VklScjNh?=
 =?utf-8?B?aWFMaUdLbTVrL3lNanNRbUlEUjQ4OHNHbHlEL2s0bXE3SkZxVWsyOXhlL3hR?=
 =?utf-8?B?Ylp5QSszM2l2bWo1TDNYckNCcUpSY2ZScVBXdXZpTCtzZ2dhZkQxZ0o2c0ht?=
 =?utf-8?B?MlMxbnZ5UXN5b1B1cU91U2hQWmMrQWRzNTFQcFhyRHNZZ1lzY0Z1VUQwL2hw?=
 =?utf-8?B?dVMxaFduVDAyQThxeTdWT243YzRnc3h6RVM2dFJjWVQycGNINkpnWTdPZUF3?=
 =?utf-8?Q?2Rt4trrUXVU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGQ5Vk5uUE5ZQmhtQ1U1c0tNdE03K0IwNG9FTDRHazlJeDJibUhLR3E3UUNI?=
 =?utf-8?B?YUdjUFRYeEEralNBVnlobnA5dnUxUmFSUEltUDZPbExmVFpuMlZ4VFgzajhL?=
 =?utf-8?B?T1lSbzhmU2dDSUxZeXlOU2ROU1RINmFYT1hrRTNWelNZVXVVdEprZGoyNlFD?=
 =?utf-8?B?ajdZckpKMWNEY3NmYUM2OENYZlBPbGh1dWMrcnBJQnZnZ0NTY2l5bzJEcHNB?=
 =?utf-8?B?b3QrcTNOSm42UDFabmpmV3JWMEo4bUxEakVySWd6eUZqSEp1SEdkdEJWSWJF?=
 =?utf-8?B?SW9MNkNocUxNcGdCTkpFZjArdkdMYndna3hmTUZPNURGdUk3MHRRZDVUNE54?=
 =?utf-8?B?RWZ4T3poRFZCZG9CN3E0S1lvWEpwbUFyNFNjSy9XNXFBVFp1aE9Pd1NUOVZU?=
 =?utf-8?B?eDdoTEdWbFV5aml1NnpDUEJvc1U4RWNPL2hlblVvc29JQXZPbUxQNW1rNWhU?=
 =?utf-8?B?cy9JMzlmUGRGazd3bVV5U0ZJcS9RVGRFYURPYnVPYjY5eW9jVStkUTZEMyt3?=
 =?utf-8?B?SFlHSFA0TGthOTZaMUVaUTFES3dmODIrNEMyNzZod0FoT0k1S0xETjlVMmN1?=
 =?utf-8?B?NHpJaTlSZTNBVHhIaDdQWVg0anpibzE0ZVVDUEIrZzhpc3VnckNIam5wOGNG?=
 =?utf-8?B?dldBVk1yb0J0ejlBeEVFZlB6MEl5ZEtkSFU1Z1JsK2xOVkNYSFAwUFlGeml6?=
 =?utf-8?B?aVo2OVRVaWp3QlBhQkFrd29GV0d5dUhHWThpVFpsa0FNUmc5eFIrQ3NIWU5X?=
 =?utf-8?B?bkVKKzF5Mnp3cFVlSnNmVU1sbGhMQ1MvUEpDWGpPV2duUXhwdkJNZEQyNTA1?=
 =?utf-8?B?dW93MkVGUFVaemNNY1BlcXlSTTYrYWo4SjFYZzlLVGl4cjVKRmVMSHRGRkFl?=
 =?utf-8?B?M2V4NTlNUDVMTGxjdllGbmxZYTVIRWZJaUdHQlNqK0FqUzRib3IvY1d0TEV6?=
 =?utf-8?B?NFQvcWw1dTdtalh6cmdIQjE3SEJVS2pVN01DVjZjY0pCcHFnWFhFQllLa2NX?=
 =?utf-8?B?OUVCanFPWlVGOG0wM0pEeEFNZGluMG1ZTW5jQ0pmRnArYi92d1FmUHZHM1pB?=
 =?utf-8?B?SG04Z05UUGFKK29LbVd6YnRMREhDYi8vaDd3aCtOSFg3aWlaL3I5SHNSb0lr?=
 =?utf-8?B?NmQxajNZaUJqTXNwRXkrYmdEa0xHOTJ2a2tSYW9HaExiU0tRZGVXc3hMaDJh?=
 =?utf-8?B?M1pvTmROcUJmS1h2NnY3eFU0YUZrM0dFcGdBSmppd01pR2RpdS9uWmtoNDZP?=
 =?utf-8?B?TFp3c05rK2p0b2dSeWttN01VMzhjdjNvYzlmbFNnVGxwZzlqWW0wMkRVNnhJ?=
 =?utf-8?B?c1VRcHJOdWtjY014WnVzejY5UHNMNDNTK1dIVDlqeFlKM0xpUlc4Wnk5UnA0?=
 =?utf-8?B?bXhFcExsemNFSXNlUTgxK3NKaWhNdDRSWElONHdtU2UzTzBRVDdRaU1raGlh?=
 =?utf-8?B?cGV1VTF4amFFNm1yQm5xZGJNaU1JdS9JSHlSaXJtNXpRUGd6Z3VBV3dRb2p4?=
 =?utf-8?B?NkpGTlBIdGRRdTFVNzcwRC9FN2dqTWpaU09rSTlZcUJvRmtFd0tHUEZvOXlZ?=
 =?utf-8?B?VEhkenZkT0tLRjJNTjdwWklqam5xd1krc09LaUdoZHo0RVBLUlVDSmlnUWJY?=
 =?utf-8?B?cjZlaW1wV3pQWXl1MXhTVTRPdzZFVEVFZ2V5R05MU1piQ2NiUHV4S1FDZHRT?=
 =?utf-8?B?c3ljTWoxZXZGNHNkblp5L3pxUWViQnN0aXp2b3FKUy9IYUoxMGlSc1NuditX?=
 =?utf-8?B?WnFWOThaWmJqMDJkUU9vYnUvcVdHT3FFbER4aFdva3dQcHZwbjRQL0RVRmdX?=
 =?utf-8?B?bDIxTm1TYmRtbzdnNDdXdExycFFKY1Bza0NzemtxcDFNcW0ybk1lbWp1KzF2?=
 =?utf-8?B?MG85QjJ3bXgwNSt0aXNwd0tVc214OGttUEJnRlBUKzVhVnlidm5XUmVpZUZY?=
 =?utf-8?B?TnpsOW9ySFllWTBRVlY3UGhDcVNxcG1HaXk2ZVdKQldGMzhzRW9oMklMa2gx?=
 =?utf-8?B?VkRTWDROVWM3NUI1NDJ5S045b0treTcvd1NqREMxTFo2V2UrV2EwMDJyancz?=
 =?utf-8?B?ZFgwQXNJbXk3YkQ2WTB1blYwbXQ3Tkl6NUxjK2QyZ2dvbjZNSUJGb1hmRzNP?=
 =?utf-8?B?TGYxejZQblZqUDBiUFlmM2txTm5mOUZFdXdjWU50UzN1QzVNa3hkOGhVWWdB?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e07b93-54e4-4a88-aff0-08dd7ebf37da
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:23:09.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4c91s1u7UOnF0Hj3hmTtdQrWCA13Z46OQTy+aLKp11lzzVFouZ1cgqPx+Xre3SXrR5jUZCUBFXxEF/dKTlXfJ+SKsUtyUulwbw8BQrFyU9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5124
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Enumeration support is provided by the Intel PMT subsystem.

Needs context before jumping in with solution.

> 
> arch/x86 selects this option based on:
> 
> X86_64: Counter registers are in MMIO space. There is no readq()
> function on 32-bit. Emulation is possible with readl(), but there
> are races. Running 32-bit kernels on systems that support this
> feature seems pointless.
> 
> CPU_SUP_INTEL: It is an Intel specific feature.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/Kconfig                       | 1 +
>  drivers/platform/x86/intel/pmt/Kconfig | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ea29d22a621f..44a195ee7a42 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -504,6 +504,7 @@ config X86_CPU_RESCTRL
>  	bool "x86 CPU resource control support"
>  	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>  	depends on MISC_FILESYSTEMS
> +	select INTEL_AET_RESCTRL if (X86_64 && CPU_SUP_INTEL)
>  	select ARCH_HAS_CPU_RESCTRL
>  	select RESCTRL_FS
>  	select RESCTRL_FS_PSEUDO_LOCK
> diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
> index e916fc966221..b282910b49ef 100644
> --- a/drivers/platform/x86/intel/pmt/Kconfig
> +++ b/drivers/platform/x86/intel/pmt/Kconfig
> @@ -38,3 +38,9 @@ config INTEL_PMT_CRASHLOG
>  
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called intel_pmt_crashlog.
> +
> +config INTEL_AET_RESCTRL
> +	bool

Usually these settings come with some "depends on" ... no dependencies needed?

> +	help
> +	  Architecture config should "select" this option to enable
> +	  support for RMID telemtry events in the resctrl file system.

telemtry -> telemetry

Please define what is meant with "RMID telemetry events" before this statement.

Reinette



