Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7F225D6
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453212; cv=fail; b=jHCl15UPnlV0CX099kTL4cg6ciD8EIxX1pxnfg5WpFU6Xe4mtTIfEc0cfsSBydDapTD2BEbonB2mkE8uNcxYSSX6Lpe/eTqgqTDyTqKv/1YA25vVoqxz4XIwWFC9niVptScF5aqmQIij7quFD1gU/fSQ+nGLu36mo8IZ1eStdTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453212; c=relaxed/simple;
	bh=fAUX0pq//G8Y63m+orSQBxUdpIMHpKjgKseuuRq0Inw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NUm2WRLU5HXOzamdyU3aKj50aXIAVlbZ4frCWnGpkhfCwP2ltb/5C2zETxkH+JKvo4OdXLNL8vQXYj4xGfyTJiBGgvKWaBzYw6jx5AIiEcbeCdGGkO341AU3teRYiFOJD02f1hNIvLznC/GvUjVX+nk0VvknQzOydWX9vIlWjLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oDUX/FIw; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oDUX/FIw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757453211; x=1788989211;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fAUX0pq//G8Y63m+orSQBxUdpIMHpKjgKseuuRq0Inw=;
  b=oDUX/FIwdHFNGCawX0oa/tBQDzH/dxDWU3+dP81jk+/FKLfS5+dcNxfM
   jWzH6fybgq6P+Tf6J2RRP6xmF6Qmbg5cUAde8H8HK2ob3TWhft0ET6uJI
   1e3qe0iyDpR5j2GDInIGbPQgK3AjrF8Lck5ri6hhhXnhe6rFy7hOi8erW
   g64SADWBP6WdgyhA7mWxTlnbzNQb/eoJgj1quzYAJktEGx1BUnmTaLJlm
   TSKlQs9G8U/41cyOkNNzm13wCpZy1kt075Sez0ccs7ieWf/sVF2NJVIKA
   M78l+qqeKSpkLQRpWjPMgvkjLENDZF92b+oRq01rmZBJKuFPDVR9faraB
   A==;
X-CSE-ConnectionGUID: gKUaQyDRT8yPxe/w8arN/A==
X-CSE-MsgGUID: IZEYaKL0RxOjn0qRykoAdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59703978"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59703978"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:26:50 -0700
X-CSE-ConnectionGUID: XNKGTzBySSeQPMMeV02I7Q==
X-CSE-MsgGUID: 7zC7D18mRxyDvBsVCDFIFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="173657940"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:26:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:26:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:26:48 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.84)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpv0Wm51OhIpcMljYmeGoW/+sI3Ztcpmbgpwilj/TAMVdIJYm8ln5TBUP1aEqEsPzNm6J+0gHffd5pCB/fPtnDVydt9LMySQCsEUjieFPpHU+GKLGiRS6ghRo/EM9urrz0R3oBKNJHBy2/tQ+KdA4hGEbOreX1ilCjnNXu0YRSOABiPEPWY7rrLaQMfZngufGrcCFq8GBggRO6k1tNEo3xAiDbiNFsMUmK2kTjQTS8/JoDZS52gSCfAL6nRhnSM6uuPKGUsIDSYnovRCbKDdqtaGN3o3d0bNnb3A2PNdGPrbC9q0PzGeS69QRVR4XLLdOOWj9NRA8imkW/fkjQB1gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9mvWYSLZFjTu7eB+uT78xicTHJBxVOzdsLd/CcEUOM=;
 b=uIYvbh6CQePjSsE/09+3DHoYKL5bAnVPwzYPt5fqEpIcrlvzLTO3V2XTbwqFoFKcB/igMyzpvTQ5J8fUKBSyyKTSJAdZaAPcG2jjUVlCtvlB+pnpxNlchWJyhN1Y6EPjnPXyzatfxcRTGeVwbX9Fsms4DyOE5bcsfcYQLsv+iDwLAUDVfDCckcincfLwfR03ppzoSkxfvqC7Zpqej8mup1qtz2dPR8BxrV9jE9mNEqbaNsOWcal8jIWIV0YGXMd+WjluWDKLdN//LH4yjMrDSKKYaCpgqyiMZmwzhX5dtVA9AkZsURazNR/Ml0b81uszVXYQKSWdwuCEjggzjRZqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9297.namprd11.prod.outlook.com (2603:10b6:208:56f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:26:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:26:45 +0000
Message-ID: <61c36cf5-236d-49f9-8416-d87760ce15e3@intel.com>
Date: Tue, 9 Sep 2025 14:26:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/31] x86,fs/resctrl: Use struct rdt_domain_hdr
 instead of struct rdt_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0141.namprd04.prod.outlook.com
 (2603:10b6:303:84::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8385db-f731-42d6-202f-08ddefe793aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0xONGg2ays5TndGNzVOaSt5Y2FOb2VhMVlwaEZJNVIyajVtaUVPNndteUFJ?=
 =?utf-8?B?MjJ4c2pUMS9hOU14ejFaTDhQbmlpVHl3NUMyY1JxUWNiaDhxWFFlYmRHU2Jj?=
 =?utf-8?B?ZHJpR3h5UktMNjB5eVRKZGd2eVRyVkU4NnVMUmhpcno0L3JhejNLL25SU1Rs?=
 =?utf-8?B?S3BjZXIxUjIwUGRPdEUxTjRaa1QvWmZpT3JCTWh6Qm1YRUJnU1JodUdNdDgz?=
 =?utf-8?B?NXJWT1VCUjc3L2NMOUJvNmY5TUczd1FjR2JyOEJEOVBJMERWaTMxYnM5QTE1?=
 =?utf-8?B?Qy8wNWc5UnI4WXRuekswbHU5WmJKSDlHVVZlNXg5eUVnT0tIaEVWeXVDdkVI?=
 =?utf-8?B?NnhRQTI1VlAzQ3RpbnJJd2hRSWpmTjJodFpiTXN1NCtYZU5FNXZoMTF6VHlN?=
 =?utf-8?B?OWMxRnEzU0Z5eU53MUhpdHk2WEQ5NEdtdFF4RUNEcjdHbDYyZTFIaUw4UGxD?=
 =?utf-8?B?TFZGU1VWd0FKczV1THZjcHpqUU9vNm1qeHYxN3Fxa0ZBdnUxNmNRa0doQ1Zw?=
 =?utf-8?B?bVQzYU1JV3JLWS9ySXNVZnlRcTlraU1HVHhHZ3hGYm9tNFlXSmRYeGlmeThj?=
 =?utf-8?B?ZHErMzRiYUVHMGE2SXRYV2ZwVlN1djd3MGkrTHU4T1NackNhVVBDakRxdSs0?=
 =?utf-8?B?eFI1bVAvMC9CWVgvQVI3OG5RbkErZ1huVVI3OG1kM212T2QrWTlhc1ZiYzJw?=
 =?utf-8?B?MWZBN3JpUXFSRlNjMHdzY0daN0Y3MG9vdGFBUC91MSs2RTVJVjVQMVcrMVYv?=
 =?utf-8?B?QjFYbkNmTXRjYnFPWVBWeVA2NVlMN1dqSWp0K2VhUVJZb1ZzWmY3cEVIRFps?=
 =?utf-8?B?bndHZXJDYXdEN1FqZ0ZEQjhnSHUzY282VmxXL05LR01yUjhmNHlxZGxkMWxy?=
 =?utf-8?B?QUhDWUp3V0ozSm03dWdZc1hSTHltdGgvdytKNncwdittak1mSGlrMXk4cHBm?=
 =?utf-8?B?T3VCVllDT25mVkMzRURhYXh2S005eHBlclRqZ2RkZit2SUFsUEVOdEpmUzhl?=
 =?utf-8?B?UnBwZDBEamdvS2VXTWZ3RXZZUmE2R1d1Q2NRQW9CSW5vQXFFeE82R0dXelNs?=
 =?utf-8?B?VnFUbjRSRnBtQjNkV1dpdWk3MWlmclhZRVZuU2Fodm5PS3ZleDZMdjJHRWx6?=
 =?utf-8?B?eFlVTDR6TWkxVWFrV3FxcHhxSGVGcUFIV1U2bHMwd2QyVFc3dGFJRHExQnJT?=
 =?utf-8?B?bTNKanVWQWpTNWE5ZHk2Y01tWGwwY2RVeFlpSzY3bUtmS1QycnZwSEJjMGJ4?=
 =?utf-8?B?NVJnbVcwcDJVYldwQWsxL3FsOFNVWStCMDF3ZG92K0k1T2pEVWppbURqak1J?=
 =?utf-8?B?VTMrQjU1NUtPY1JNdUF1ZFF3STNNUUZvRGt5Q0swN2o0RENsRElQMFpKd29D?=
 =?utf-8?B?a3hxd1pVWFE1S1dRUHVieE5uZlFCQ014cVVCU1dnN2x4V1d2Wm1OSTRmUzl1?=
 =?utf-8?B?UVFUdkJlZmpKQWNqZld5UVB4dEtwVnJnN2Q3TGtjeC9LblVmQ0VROVlJLzM0?=
 =?utf-8?B?Mnl2aWRHYVpnM1NVVDBpV1FFY3BybjhCaW9IM09qZGJYOWVveW5JRFdSY1lO?=
 =?utf-8?B?ajF2eEp6eVdwQXBRMldNSXJkd0tEc2UrdHpiYThDamppN3dpa3dHOUkyTW5J?=
 =?utf-8?B?NDNDcDhzbkF3WGJZYVlhRUp5NEFiVHBVbzdDdWlRZm40a1Y3TDljVk1TeGxQ?=
 =?utf-8?B?UFlXUVJSYmN6K2F2Q1Y5bmF5MWRqY2RvMjZ5L3lwWElweHZNOWhaYndJYVB0?=
 =?utf-8?B?aGRhMWx1WUtvc0grVGxLSDNNdkIyQ2tHcnJrSGU4WFpjaWlVTU1ndmJveWps?=
 =?utf-8?B?Z2FmWGRCWTdOcnpvM1owKzF5MWRxbnNMeUh6Yk1zWmhVYURJYVpaR0E0c3hh?=
 =?utf-8?B?ZFRDSkkxbEF4MjRWZVdCRkg0dVZpMHRsNmNWWWMwWlQ2QUxWelJsWjY1MFI1?=
 =?utf-8?Q?461IBV01sKg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlFaN0p6WFpFalVCbzFrYWFSbkNMbFo2c1V3VVk4S09qOXBaQUFVU3Zha1FV?=
 =?utf-8?B?d2MzMHkzTHVnTW0xVS9KcnRnczhKS2t4Q2pFL2VZc2hzb1Bqbm9QaWZrN0Q3?=
 =?utf-8?B?TjQ5eEkvZ2tBMlRVRHJ5VVdVOFI3aUhqdDNLckN5clQwT2o3LzZMY21JQXA5?=
 =?utf-8?B?MzRaTXFOWUNJeU9ScldXOEY3a1hNUVh4WndOT3pXNTVHbXdxcXpIQ3ZtYnRW?=
 =?utf-8?B?V0NzYzJ3QjJxWmVhSmhmUGJVdkhPdm1DZ3VXSks3MDZIVHZyd0RGRHliaDJn?=
 =?utf-8?B?N3JaQjRTOFh5UmhtU3ArWEpDTGlOTzd6aTRKbys4RlBsN2o5Z3BYcWRoOHdi?=
 =?utf-8?B?Z1dKNE9pdmdjbDNiRU0rejlSdUtPVkNwQytQYXN1Y1ovL2NiK3haWlgzR3Vn?=
 =?utf-8?B?dFRKWGdKMUZ2dWdwbmxMWW1hSGpBZkpJNExIOVl6MHo2cStZcjZsbms4Rml6?=
 =?utf-8?B?LzhONDFGTTJTakQyNWVFRWt5cUlYRXZLQ3lIZW56RzMySlVOYThzTHhPMjFh?=
 =?utf-8?B?RTgxTTFqeEJWbFYrSVlSSkZqL2FkTVlYVEFlQmdkVUJNM0haRDNuckVlWnNs?=
 =?utf-8?B?UzRnOVY1MDU1Y3lGSWRHNWlOWXFhZ1ppUE5MRlZLOVRkUnNESFd5K2Jmbm44?=
 =?utf-8?B?bSsvajRDQk9WeWxSNmdzVVhROUgzNCttbXUwYm4wZHREenFmYTNEek5KM0xn?=
 =?utf-8?B?WWpPbCtPSFM5NjB5UDlwY1gxWmNZMGtYck5XOVBacDRBU0hXWGw1aFhLUVFo?=
 =?utf-8?B?b3VzdHVtNTFCQlJsU3VpNklaakl0cUlZdjB3S3NicW05b2M5OFMzcHFHWUFq?=
 =?utf-8?B?TlhtaVNTRFcwTGpsRDl0bnRQSW9IWjhzalBLRThNTmpKT1hOb01GMXhCWEVZ?=
 =?utf-8?B?OVlTaUczRWJ0MTR6QU9OQ3VkYWRYd1NqenA0VFM4VWRiUG9nNFhTQmZ5Mzc0?=
 =?utf-8?B?bnVidFFNM1UyWnhiQXdIbk5YUUQ5WnVJdmc5eG9KVjJ1L2syajlGTTByNXlE?=
 =?utf-8?B?b3VnVzZZL29ncm9zWmthbjBBNDUrVjVneStBY0pwV2F2NXY0YnY1WGtRd1FX?=
 =?utf-8?B?MERoSTdLeS91RHlrcVFqdUt5UFRsajFQWW5xZ0Noc01wd0IyYWJLOEVWQk81?=
 =?utf-8?B?UkVYLzdUR21heisvZURjcXpjbnViZnl2WTR3cnh2U1E3YmRuYnNKMStGMGlE?=
 =?utf-8?B?SnIzOUlrVW4xeDVtVzhFUTJNbDdZb1Q2amhwSzhHYXNqOEZ1Mjgyb2VaNzBC?=
 =?utf-8?B?UmxpU0xPNkdEYjFPUGFqVG9Pd1l0N1p5RUs3NkhaNzJVcXZSZ3lDQ0xlOTh4?=
 =?utf-8?B?dXhrRWF2SFg5YTJwVnl2bWdXYmROZDhtaDBwc3NaRk1XK1ZXZG1HMnlzKy90?=
 =?utf-8?B?MGVyZVc5dENlYzE5NjA2M1g3c0FMeno3TVRvNmxBNW5nclVtTlF2Zk5FLzFr?=
 =?utf-8?B?MTdWelZQemVrYVplUXdRdVBCMDh6c0pkbEJGbG9aRk5LWXdqbDV4aE0wZmRM?=
 =?utf-8?B?SFk5Rm1jNEpOSGxLK05yNjlCTkxpWC9KbFZxNE9uMnRaSG5UcUdIdVVad2Rx?=
 =?utf-8?B?K0hSM1A2ZzhPV3JteUJ0ZnRwcGhQNzBLdmppdzRaWERyWWNMS2pwWWZCZjdy?=
 =?utf-8?B?eWpmeVl2MnArWDRKV0JmTVBYK0phMU42ZmdoYzM2bVY1TUJpeEVGeTN2OVl4?=
 =?utf-8?B?aDRwcEoxYzZYUkxFcllzdS9KQ0k2VWNIdWljTTZKZ3FkMEFMZ01iVzRIWVZl?=
 =?utf-8?B?R3Vkb3hnQ1ZibWsyelhSbzdIeTNONGNQV00vRnFPckdGcjFxY0YvemhnWnQ3?=
 =?utf-8?B?U3c1bFJjcHdzVVR3eXdNeXM4eWp3OTlCVHdJQ3l3d0J1QWZSeFZHdkRJZ1B4?=
 =?utf-8?B?cExMWUIyNWhuMjhXcFgrTkFCa0tsL3UyaVJmTDdNc0swVGIyVFRBVGFDMVhh?=
 =?utf-8?B?UittM1B6VjlmOGpOVGFYN0dVenlTelRheTBFbElJVEE0MXZBbThNWnV1Mld3?=
 =?utf-8?B?ZVRtWWRKUTI5R0R2czVvNkNwU20wbjBmVjlUcWpTRVI0bkszMUZaOHpKdGN0?=
 =?utf-8?B?RkZmSVRYa1VPSkhZWC9yeUhmZkpZWFZ5blh5N3ZSajJmU1UrYU1uUS9pN3BP?=
 =?utf-8?B?cWkwL0pUb1NGbTNWNFh4QjBLK3FLZWYwMzNmSW01QzU5MW5CLzg3K29UbWdU?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8385db-f731-42d6-202f-08ddefe793aa
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:26:45.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1uhDHoiARQZQxdAAHxR5rmW8PVeg1TkE8AP3NMn63YWbzrpPwjlviyMjI9N/mxpPoWzkeuGr2hdAc0/Twy0T+/+wrQfxbGBv+XVpgozlEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9297
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
...

> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index f01db2034d08..b31794c5dcd4 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -217,20 +217,30 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
>  	return chunks >> shift;
>  }
>  
> -int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
>  			   u64 *val, void *ignored)
>  {
> -	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> -	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> -	int cpu = cpumask_any(&d->hdr.cpu_mask);
> +	int cpu = cpumask_any(&hdr->cpu_mask);
> +	struct rdt_hw_mon_domain *hw_dom;
> +	struct rdt_hw_resource *hw_res;
>  	struct arch_mbm_state *am;
> +	struct rdt_mon_domain *d;
>  	u64 msr_val, chunks;
>  	u32 prmid;
>  	int ret;
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> +	if (r->rid != RDT_RESOURCE_L3)
> +		return -EINVAL;
> +

What is benefit of these additional errors added? From what I understand it is in
the "should never happen" category that the domain_header_is_valid() that follows
already handles?

> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return -EINVAL;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> +	hw_dom = resctrl_to_arch_mon_dom(d);
> +	hw_res = resctrl_to_arch_res(r);
>  	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>  	ret = __rmid_read_phys(prmid, eventid, &msr_val);
>  	if (ret)
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index a7d60e74a29d..1c1c0e7bbc11 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -547,7 +547,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>  }
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> -		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> +		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first)
>  {
>  	int cpu;
> @@ -561,7 +561,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  	rr->rgrp = rdtgrp;
>  	rr->evtid = evtid;
>  	rr->r = r;
> -	rr->d = d;
> +	rr->hdr = hdr;
>  	rr->first = first;
>  	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
>  	if (IS_ERR(rr->arch_mon_ctx)) {


> @@ -592,7 +592,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	enum resctrl_event_id evtid;
>  	struct rdt_domain_hdr *hdr;
>  	struct rmid_read rr = {0};
> -	struct rdt_mon_domain *d;
>  	struct rdtgroup *rdtgrp;
>  	int domid, cpu, ret = 0;
>  	struct rdt_resource *r;
> @@ -617,6 +616,12 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	r = resctrl_arch_get_resource(resid);
>  
>  	if (md->sum) {
> +		struct rdt_mon_domain *d;
> +
> +		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
> +			ret = -EIO;
> +			goto out;
> +		}

Apart from what is described in changelog this patch also adds a couple of new warnings
that seems to focus on the SNC code. Could the changelog please add a motivation for
how these fit in with the change as described?

>  		/*
>  		 * This file requires summing across all domains that share
>  		 * the L3 cache id that was provided in the "domid" field of the
> @@ -647,8 +652,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  			ret = -ENOENT;
>  			goto out;
>  		}
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);

Above change introduces domain_header_is_valid() inconsistency by keeping the check
but removing the "checked" container_of(). Again I'll try to point these out as I see
them but I would like to repeat my request made in v8 that you review the related
changes to ensure the pattern is consistent.

> -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
> +		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
>  	}
>  
>  checkresult:
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index dcc6c00eb362..713396cbda32 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
>  			break;
>  
>  		entry = __rmid_entry(idx);
> -		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> +		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
>  					   QOS_L3_OCCUP_EVENT_ID, &val,
>  					   arch_mon_ctx)) {
>  			rmid_dirty = true;
> @@ -365,19 +365,22 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	int err, ret;
>  	u64 tval = 0;
>  
> -	if (rr->first) {
> -		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
> -		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	if (rr->r->rid == RDT_RESOURCE_L3 && rr->first) {
> +		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return -EINVAL;
> +		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
> +		m = get_mbm_state(d, closid, rmid, rr->evtid);
>  		if (m)
>  			memset(m, 0, sizeof(struct mbm_state));
>  		return 0;
>  	}
>  
> -	if (rr->d) {
> +	if (rr->hdr) {
>  		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
>  			return -EINVAL;
> -		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> +		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
>  						 rr->evtid, &tval, rr->arch_mon_ctx);
>  		if (rr->err)
>  			return rr->err;
> @@ -387,6 +390,9 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  		return 0;
>  	}
>  
> +	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
> +		return -EINVAL;
> +

Another SNC related warning.

>  	/* Summing domains that share a cache, must be on a CPU for that cache. */
>  	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
>  	if (!ci || ci->id != rr->ci_id)
> @@ -403,7 +409,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
>  		if (d->ci_id != rr->ci_id)
>  			continue;
> -		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
> +		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
>  					     rr->evtid, &tval, rr->arch_mon_ctx);
>  		if (!err) {
>  			rr->val += tval;
> @@ -432,9 +438,13 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
>  	u64 cur_bw, bytes, cur_bytes;
> +	struct rdt_mon_domain *d;
>  	struct mbm_state *m;
>  
> -	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return;
> +	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +	m = get_mbm_state(d, closid, rmid, rr->evtid);
>  	if (WARN_ON_ONCE(!m))
>  		return;
>  
> @@ -608,7 +618,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
>  	struct rmid_read rr = {0};
>  
>  	rr.r = r;
> -	rr.d = d;
> +	rr.hdr = &d->hdr;
>  	rr.evtid = evtid;
>  	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
>  	if (IS_ERR(rr.arch_mon_ctx)) {
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 05438e15e2ca..2cff82208327 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2887,7 +2887,8 @@ static void rmdir_all_sub(void)
>   * @rid:    The resource id for the event file being created.
>   * @domid:  The domain id for the event file being created.
>   * @mevt:   The type of event file being created.
> - * @do_sum: Whether SNC summing monitors are being created.
> + * @do_sum: Whether SNC summing monitors are being created. Only set
> + *          when @rid == RDT_RESOURCE_L3.
>   */
>  static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
>  					struct mon_evt *mevt,
> @@ -2897,6 +2898,9 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> +	if (WARN_ON_ONCE(do_sum && rid != RDT_RESOURCE_L3))
> +		return NULL;

... and another new SNC warning. Could you please help reader understand how these changes fit
with the domain -> header conversion?

> +
>  	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
>  		if (priv->rid == rid && priv->domid == domid &&
>  		    priv->sum == do_sum && priv->evtid == mevt->evtid)
> @@ -3024,17 +3028,27 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>   * when last domain being summed is removed.
>   */

Reinette
