Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6118BBA36
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 03:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752030023; cv=fail; b=V3UR0pLBx61IIUTAnCc+4WOhOxvYaf1cX1M+LAZCYtAjq4wE4/I0p6Ig6urU7bbxpK2Z/tbcGelnHDt/nuzsa39vhfaFlCfuj0pRaoEWN+j4xBWqXiPlSiJGSqcIh+MOT34etYggrW6IHuO7UakP1swPZcu8LHQpcbNL/gQurm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752030023; c=relaxed/simple;
	bh=8om8f8s3uNyJjb8osTaCufxus1rOW+jHgQ4TvVckUas=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EJfqlWN3GTN56nh/BXqaPugys8hJA9QF32qAuOeIGW46n2WOp9MtZB3SHfIdDyoiFT+YQKCdCsHyaIlN3szxsppoohqMi1VPB/Z1ZasR+Hnt0OairYCjxeFb/mSjuaOg6ok3AaogrMICbsDsk/EdUMO5jiA+vjucSDKC2fOmQ38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QcjF1Oij; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QcjF1Oij"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752030021; x=1783566021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8om8f8s3uNyJjb8osTaCufxus1rOW+jHgQ4TvVckUas=;
  b=QcjF1OijgpOdegwVEFpR95PgOO1eSiSi81ZdPlRHWQH+9reb5r+zXgK5
   0CJ7D2ww+DtJIHaijtF8/LPyaOSb7CenJ5bVi7ZWySyvaj+zTY/06eolI
   7L/ZZotTLW5QclRj7E+65VFH1v7X8gDadi8GViZMeqPaeNZYLGUCTS9Iw
   8/+FEt2LsdY0XHGmpta22971++5Pw2cUSo7eYW3UdZn9qcgeO9UNfn8vu
   T0z2JPMg0d1LDQ0uN54ds6YzwRDA59UVbShP83K895MW86ANt7r0pYwzv
   dnCnSUN/gHa4Wra/r4aPMndi/mtxmhf0IHAoFZu9tNWGyvAQABxj2WCvv
   w==;
X-CSE-ConnectionGUID: 0Jr96SpFQ2yaTYoPcSJ0Zw==
X-CSE-MsgGUID: 4vs7YvNmQ7+tU9iup2BDGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54210369"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54210369"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:00:20 -0700
X-CSE-ConnectionGUID: nBqeTZPrRz6Jp3tS7THxVQ==
X-CSE-MsgGUID: 2TxevsSbSe6DxrBytMnXCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159917753"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:00:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 20:00:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 20:00:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 20:00:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jdZcfv8Gj/GM275YW7Gok2IrbnjDs3vn0CIcGVxy2coCIDvUv3iNzTTcYreDLvBKnwoMiz64urenP9gh0vvOp55ZPa3xJqZIcsZPkHG3KOvDViGcEFUalqiQnCOmllCv2BUT0WxjixXC9QMHYue9gzH8RuUQdN+buwynZ3Uvk+aMoV3WsVFWnKFK5lHuj8+utXzaNNjm1A+JjqZJ7avvqwahd0aZE5sVxHblPVkgqUF/a7siZefNQ2yrxQVRt7Y4SeIzKUYyDHi6f8z8E73xfyPg0c9p2Q8MPcouMW4WgMB0KFslDcKpBcvWyOCLbNOv5COPeQnHSKsdsnss6/nfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NIz+vdAdL9Cx5okogP2+IKVcldJGztt9kZpF3NYdh9s=;
 b=fbZQ4Wp6IFGDTjqK/nwbK3Z1SRkcq1+/2c5nJydT/EXI6EvXHLf8yIaYPR7GLybdlX5QBDG2dGn5ixisqxquGdTrei2a1e9YYtjnQl3VbwfOAWbP79vEDAuCmBnHoLSKfJ/VbS6TD8wLSxxosuzs/uUOpPsbu9e3hAgzzQa/bmlBLq4B49qC3f6WknjGOG2Un0uedvTTzHlro3y/88yL14HUH8ZyxR2ephUD25WVrguv73JFPOwAg3HmmQ/sT2yt1dXGPr2jtoSo4bkq6QNh5tyutwnPYRWHCHCYml3Oef3jNzwEf5aghqHdLsdGra1KVxbH5zbTiwn8EKKUicwVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.34; Wed, 9 Jul
 2025 03:00:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 03:00:03 +0000
Message-ID: <dc3130e2-967b-4907-9c59-b17cba60b56d@intel.com>
Date: Tue, 8 Jul 2025 20:00:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/30] x86,fs/resctrl: Fill in details of Clearwater
 Forest events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: 4209f1b9-99f2-4cbe-1ca5-08ddbe94b3b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V3hnU3pQcDhaVVVUdFgwaUdvSGgzaXRKOWxxY3R0a3kvT0R1UFFRZHNoYWlM?=
 =?utf-8?B?YnJic0NSZVE2aWovQmJ6TWVGM3ZQZ1dEdmsrRE5VZHVXZ21ZSklkQmdRdmI5?=
 =?utf-8?B?V0lnUzc1cFBzMVZWYlBJaE5mRUIzMFFPMFFSNnlBTFljdEtqOGFjZ0FQWmZC?=
 =?utf-8?B?bHFlVjZJVytrMmJyZFVaL21Pb1RLbnlrUVM4UzQ1aE1FRU9WeCtZZHZJckkw?=
 =?utf-8?B?clNkOGNNVkRSL2VmNWx6OExTU1F4dUVDaHV4TzVrVzQ3TlFSeW5xLzZFVlBX?=
 =?utf-8?B?OFBWNUR3cXdISmxhbS9TSzJKRk9kQjQzM2JNMVUzS3lERDIybldIczR5aG50?=
 =?utf-8?B?WE5vSGVFOFBIdEprYk5MMy90MmFFZC9iMDlrblYxc1NjWW9MQ0M0SXZvSDZm?=
 =?utf-8?B?Q25RYjJYTTR6Qno3bENqVi9LVnd1M2ZQcUdSZkJmeHVadFlvZVoxeHllM29V?=
 =?utf-8?B?ejV5dys2L1cyYTlNQ2FaREhKMXVZdTM2TnZYek5JbFdqNE5LTHY2c3l4ZEFV?=
 =?utf-8?B?VTBSeVRjYTFYbEw1M1A5cXNzcWF5SmFkUjNVMUVNenk2US9aNDl3UVBKVlla?=
 =?utf-8?B?WnBqOVpiaHU1ZnZqdHRTdnlIK05kTnB6UCtRZGZOWU94ZWc1QzZFN1NFM0cx?=
 =?utf-8?B?NmRWNndjSWlHRmVQaFFuNVJVeDVKODBERW0vRlU3SjBRUk5ORDJsV2U4SVVU?=
 =?utf-8?B?NkYramZ1SGlQbjR2SXVQL1dGSGM4Y0piU0lLRG9CTEhhNVhUM2ZVaWhnaVR3?=
 =?utf-8?B?UXBuQ1lKT2NNV3htV3Y4WTFRR2tyWDhyMSs1QTl2bmxOeU1hU09hSHBxMG0v?=
 =?utf-8?B?NTdCVFJkMm04OUJhVnVQYmVRMERsUnBHYmlVSkdQelpnN1JJaHNGWG1QMVpY?=
 =?utf-8?B?cjQ4RFVWV2F2SU5FYWpvb0FqQ1lHUDBOeVROSitRZXRwLzYyRmZNemlxZGI4?=
 =?utf-8?B?ZHZJSFV2end1Z29YcmU3Qm0wWWVpNjRvdEN1c0RGaHl6RHpKVUFFWHRONEkz?=
 =?utf-8?B?QlVSSElRaFQrNEVxMXA3cElEMzV4V0FDeDViSDFKMjBFb2wxRlZpZy90emtw?=
 =?utf-8?B?SHhMQTE2WmpYUkd3MGlhMjRLK0t6Z2NORkphWGhIMjlrb1g3Mkt4ZWc0cFVl?=
 =?utf-8?B?N3dLVDlDNlRHeWRhV2o0TVJSeFpSa3VueFJhMEVCa3Z0RlkrM3p3TVF5MGMr?=
 =?utf-8?B?ZnoxdUhtdkZhK0hRYnExa2hjTGxFN2FRWXo0NnVtSGRHeWY4Nk1GK3FiZngy?=
 =?utf-8?B?a2hEY1dzS0svWTgxVEphb1NocVM3YkJ1SkF0TUE4NDV2WGtkWTlEdjI0VUxI?=
 =?utf-8?B?M3RuQVgwTmIwRTRGMHJHdHVqbWVXeGxuZUxOTjlUOWtzRTNSbCtsMzVZMkcv?=
 =?utf-8?B?QUwzT2ZOZHdPM3Vqc2Q1L0FUTmx4aUgyWXQxNUZpb2ZwQUtndkt1RElIU0xB?=
 =?utf-8?B?QlArQzE3Z3hMNVdlR3hLNm5DU1JydWFFZUVvVC9KUXp4SDVRY1lQRk5SZzdt?=
 =?utf-8?B?MlRGVldwWjBCclJ1ckNKQjZqT1I1NnJjVUR3S1d6bHdUbHdOcDVXcDVKaklR?=
 =?utf-8?B?OTkxWTMyR2J4aHBGYzlzQzVseVBYdjVDSTRVVkxoWWV2OFBjeVlvcDE1ZFAx?=
 =?utf-8?B?WUtNNTNTbHluT3Rna2ZpK2ZhT0tndVJhSTk1TUhWM2NlRzFiRUhLa2lKOGVD?=
 =?utf-8?B?VGVqbmRtSmpaYjRXMzZoR203Z2VTK1YwOVJUVHR0R3dhT0hnUFM2M2E2RnU4?=
 =?utf-8?B?RHFwb05JY1lMR25LK0duVzBmRGFyZG9hMHNkZDBwUTg0TTN4WktoWUp3VG05?=
 =?utf-8?B?Ky83TDlUcU8ra0FjVGwrL3FEdldnb0o4Z05abW9icTluNC9PTGRjbzVaUG9a?=
 =?utf-8?B?ang2ZGloQnVjaU9IN2NUUFo5Rk5HZGVjY1FUQ1FHNEhXbmc5WWV3TEZCS2VR?=
 =?utf-8?B?dWVhYTRXM3J2NzJ1dHo0cWdrL1FGZFRXV0wyWnlyS1NEckI2aWZnbURHQnlQ?=
 =?utf-8?B?Tk1UMG9KSmdBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFBSclZQd2tVQUczcGE4b0pSQzVkUDl4RzRFejZVUWc4MjN0VHNWeDRHSWE5?=
 =?utf-8?B?ZXl3RGhYUTFIczBtTDhVMWFVQmVOSGg2THc4TFBMM3Z6U0RoZTgxNTlUUUEy?=
 =?utf-8?B?QVE1ZC93ejdDSkkxb1dlNURlVGR1R0NlNWZGdGl6STNjQzhHQXJ0VEhQS1Q5?=
 =?utf-8?B?YXBQeTlYUGJSM3pyZUdIa1pvbUcxcSt5TktVZ2M1aWphaWdGbVlOL2x0RTd5?=
 =?utf-8?B?L2RiVjlJMTRIdlhsZXA4Y0RsOGI2Y1dxOTRQcU1MVFVKWEMzT1ZXT0lSdnJF?=
 =?utf-8?B?bHNuOU96WTN5YmVhOFVLOE4zbytja3FkMlZ6UDNIVkhmL3NwSVN4bnBvU3Nm?=
 =?utf-8?B?TGxmNXVPWkY3ZWh6cEhaWnlIaksxQ1JGM25HYm1oUkV0MlMxRXViejJZcEw4?=
 =?utf-8?B?WXdYdk16b0Y2VzNuM3FhY2dzMXgxOGtxZVhyRWdPZ2Z1dVBUR3d1SjNlVTNJ?=
 =?utf-8?B?Um5tdmNpdys2OGNxMXNKUnNpMTNNL25UK3Q2ZkpPamp1d1dLSXI0eEd3amRC?=
 =?utf-8?B?L0h2bFp4SXhYajNTcFV0YjVNbGsrZkF3bTdGTTdIV2RCRU5FaCtxQUtpZUhL?=
 =?utf-8?B?bHc2amoxUEF6MVh1bkxPajk4eVB4b3lzclRKTXRYRnUzYXFEUWtrbEtUYkYz?=
 =?utf-8?B?cTYxMk9NRTRxQXNIUUJHOVY5RHJkV1E5b2hwMmJHZEw0MFdGMk1QdlZmQVRq?=
 =?utf-8?B?NEw4MHZUNzM4YWFjTUx4d05LRTlZYVRlbDdsdjkyNFlaN054SmZZdDU3eW1O?=
 =?utf-8?B?VzFCNUpGY2NsdjZvbDdqMmszU2l1REtvanh2YVFEOGludW1KUUl3N3FBZWpl?=
 =?utf-8?B?YTZzMnlDKzkzKzR4VzIwaGNFaGdpdWhxdVB4UmJzSFc1djdUb2dzUWh5WmJ3?=
 =?utf-8?B?eE1FRTg5Wit1blppZXBUMXhkTXJ3VUFEVFRWaU9RRDA1UDlub1Q5d0hBc09r?=
 =?utf-8?B?ZEp2TlhKM3ZNWnRFaFpBaWJOWE9pdURLVy9OM0toempjL1dXUVJ3NFArQUFh?=
 =?utf-8?B?WkRMNlFkU0Y4VFhoUXdocjhEd2VOdXp3L2dvdzRISVEyMGRjSlV3dnYzemE3?=
 =?utf-8?B?K1QxREVFOTdXbXZHalJHRjYrOGZuazhxYWhzMTNLVEhwczJYdWpxVHNNdlI1?=
 =?utf-8?B?T25BN2k3OXVTK0JtRXZSZUdMV25ia3ZKWWVqU2lmemVzcjc3OCtlK2RSNTdT?=
 =?utf-8?B?Y00vc3VvblliOXRLbUxwd1l3SVZxMUVaZGZtVGlURGJUVmhHNlBhWkpqSXBq?=
 =?utf-8?B?c0RSN2JqMG1Vci9tOENaRitUUk5lRks3Tk5NOS9aNVRmblBxc3ZaWG9idCtG?=
 =?utf-8?B?empjbGlyWFFIT0ZLY1d0NjI0RUd3V1VSYzkrTUNyQUQvTTNKRUM2U0Nlbkwr?=
 =?utf-8?B?R0JQbWxvRGlzQ3pKa0gyWk5LTWljNDBUZXY4RmdYZDN6TGZOV1dodUVwTWV0?=
 =?utf-8?B?cTNsSlVSMlo1a053UjR4K3o4czIzZy9EWURLcXhXTkhjcXIybStyYW13YTQ0?=
 =?utf-8?B?Q0g0VXZWZm1RME81SWJiMU9LYVRCMCtMWUk2TGZnVlV3MkhvTFdFTjBvd2xu?=
 =?utf-8?B?S3pTYzRPcnFLUXRodS9JcitFK0ROeDUwSHlOSEIxOGZLU3QzSTA3TzBrcWVZ?=
 =?utf-8?B?TUw3ZTZ4by9vWWJLcmhzc3BGU2xzQjRLbHYwQ3UrSVhPUDhERU9ObTVtdEQz?=
 =?utf-8?B?a3IzTEdIL0F0RFFYeHNVZWtiUHE0NXFDRmtSOTNnN205a3piTVFzVUorbUJQ?=
 =?utf-8?B?RU4weWlPTWFDVWJCdTN1ZitNWGdFdnBQRWwveUNlZnkxQTdJRVk4Q3liVUtP?=
 =?utf-8?B?cWgxTjBEQXFGVlU5aFpoZ2N3TTlvdUM0K25KOGFQVWNCWXA2NktmdHlPTUx5?=
 =?utf-8?B?MXMwSDJOTjI1eGo3ZS9ScUwyWjFnTGYyNDFuTTBQYWVMUVpxOVByUnlmLzhO?=
 =?utf-8?B?cmR0QXI3RVpiWUE5eDJ3anZPMFZLV2FqbEgrWVNDT2ZBRUttNyt5ZTlCdE0y?=
 =?utf-8?B?enkycE5CY2FGZjc5ZkptL1Q1U3Bvc3NGOUZsK3RtODBTczRLNXdtYWNXK04y?=
 =?utf-8?B?UER6akIwM3owZXpHNXdPQVlFYVREUStBdFh5WFdSMGtnMHFycXo0U0J1TW1Z?=
 =?utf-8?B?NmxtMUo4QzIvVEdwZGJxM01FbzB4ZWNxMFlGT3d5WUplSlRGR0FMbzJSQVpu?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4209f1b9-99f2-4cbe-1ca5-08ddbe94b3b1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:00:03.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOcwWWSq0eDkG0kU1M/IdSkhfk+KTefuELRaHsZkTBRXrcP2tGZn82LMXFcNybW/p/qyD2gGzTQY5gREZjfkd7u4G7f329CmvP+goAEO0yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7925
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Clearwater Forest supports two energy related telemetry events
> and seven perf style events. The counters are arranged in per-RMID
> blocks like this:
> 
> 	MMIO offset:0x00 Counter for RMID 0 Event 0
> 	MMIO offset:0x08 Counter for RMID 0 Event 1
> 	MMIO offset:0x10 Counter for RMID 0 Event 2
> 	MMIO offset:0x18 Counter for RMID 1 Event 0
> 	MMIO offset:0x20 Counter for RMID 1 Event 1
> 	MMIO offset:0x28 Counter for RMID 1 Event 2
> 	...

It is a bit unexpected that this patch is (a) specific to Clearwater Forest,
(b) it is noted that Clearwater Forest has _two_ energy related events and
_seven_ perf related events ... but then the example is for a layout with
_three_ events?

> 
> Define these events in the file system code and add the events
> to the event_group structures.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h           | 11 ++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 33 +++++++++++++++++++++++
>  fs/resctrl/monitor.c                    | 35 ++++++++++++++-----------
>  3 files changed, 64 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index d98351663c2c..6838b02d5ca3 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,6 +47,17 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  
> +	/* Intel Telemetry Events */
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
>  	/* Must be the last */
>  	QOS_NUM_EVENTS,
>  };
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c770039b2525..f9b2959693a0 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -32,6 +32,20 @@ struct mmio_info {
>  	void __iomem	*addrs[] __counted_by(num_regions);
>  };
>  
> +/**
> + * struct pmt_event - Telemetry event.
> + * @id:		Resctrl event id.
> + * @idx:	Counter index within each per-RMID block of counters.
> + * @bin_bits:	Zero for integer valued events, else number bits in fixed-point.
> + */
> +struct pmt_event {
> +	enum resctrl_event_id	id;
> +	int			idx;
> +	int			bin_bits;

As I understand a negative value will be inappropriate for idx as well as bin_bits.
It looks like "unsigned int" is more appropriate?

> +};
> +
> +#define EVT(_id, _idx, _bits) { .id = _id, .idx = _idx, .bin_bits = _bits }
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   * @pfg:		Points to the aggregated telemetry space information
> @@ -40,6 +54,8 @@ struct mmio_info {
>   * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
>   * @guid:		Unique number per XML description file.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
> + * @num_events:		Number of events in this group.
> + * @evts:		Array of event descriptors.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
> @@ -49,6 +65,8 @@ struct event_group {
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
>  	size_t				mmio_size;
> +	int				num_events;

unsigned int also seems more appropriate to reflect this is a value that
can never be negative. Also relevant to mmio_info::num_regions.

> +	struct pmt_event		evts[] __counted_by(num_events);
>  };
>  
>  #define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status)	\

Reinette
