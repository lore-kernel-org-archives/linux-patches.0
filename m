Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355497FBDD
	for <patches@lists.linux.dev>; Thu, 23 May 2024 22:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716503519; cv=fail; b=TlX0WmIfVYU6Nmzv/rV4+V7JzkWM0JUNtBkZ44aJCOXdEDRTm4Mbs7i913eV+STX3iwe/nCaIbSQlrBEkpQHCPtJqPZQw0r4JUPoGUL2uha8U0vsphgZAgoYT5VwRf23S9LAzIVoHfIt0RbaZosHqJbbqM7tkg2LlX1sRoDW488=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716503519; c=relaxed/simple;
	bh=khFMwyfOD/3cCPjdTWCOYSua2lCTrhe9Vm4CawPuI+c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qv9eZILDRVCiDaLdoT0pDCGWrnUlSQ7dos1GqucCXa41gsLROY3LBpLTeedRNSx1O0lXKfvJfw6V3Wm0sTIVDRUjq1HZ29QjpqE+Lyqj/AyNyW6KJHCN86e8SVXt9dDRBD3mmSXPYPdV3GCCEFr1lvIHJAohdHINrqsFt0JuyaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jHVSQ3tu; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jHVSQ3tu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716503517; x=1748039517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=khFMwyfOD/3cCPjdTWCOYSua2lCTrhe9Vm4CawPuI+c=;
  b=jHVSQ3tuRkWyE/19WGI7mHOhYCW4irDfZbiuhoQtjq/DXyqa9akgL/NV
   KrnBXrP6JuUqPMh48NGLOY66c5Tw53UF0o/ss8tAoTpuWEvWlC3JS1cIL
   DXoOkNwEtODTuE6cM3LMILFkhH/jS/AyWlT4JNPou+uGXCbXivc7Dbv5e
   IFkILvGCAfGQ/WIHNkFnSQTa4aXwZrtjwDk4+9CkgFPVnRco9efyYRD5f
   h26ij1rLpNs4y6YoqS8z/czYPnryURLKUX2pjZ0LByw/aY1154fDGwLn1
   k1vRUlOah56ed7OJEKBcaN0HqMUV9INyxNTUnpop8c7VJFAhGGzULA7JJ
   Q==;
X-CSE-ConnectionGUID: 3BsCsXJeRTGXsU8Thlxj3g==
X-CSE-MsgGUID: rdEYhz76QYWYUXbE6hF0aQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="38240079"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38240079"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 15:31:56 -0700
X-CSE-ConnectionGUID: PS9X+8SsTiiE7KGzJBxbUA==
X-CSE-MsgGUID: MQ5+9yUDTwGvFm1u7ypmEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38615582"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 15:31:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 15:31:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 15:31:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 15:31:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPZ9CiMdGTLgWioi0orZMC7e5OWJXL2KntPuGFIFcy60jZeoIIdKkR3CUse4Z1MCN0PT2Skxbde1BS3Yoh7SDK58c4GF8yoeL2eGZQ4TpYG6NRvqRUqSjoM969woPGgEsV19xwecsptiMQGVX5iST0ywTFHwXOFpgKQEhGPbJ9l9sQTCpLY4Vshx3ekjvCTuc5UpDC85IkkL105ZNx8XwnidmOalNV0C577b7imohVCOm+PZAqlO9TBVtwjc43rCD0fQgM1tdtSGyeQNVZ5QpSsDEg0g+ipDLoONxeElb0c2PW3wzlHwS2QaFDndh/rgXY80cypWqi+9yJp6Kn/77A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOkfCTXHStMro/pD/M3FIB+PX4MlJvNV+ZmLjJ/g0m8=;
 b=mIHqRbA0nlJ+ln65JTAixkYTw2+aeTEudMiTjSIEbgMBy9yk1Lb37FL3y4CjSToNtQVUEe+RvLiRHykI+/iodmxl5WDl6cwTlwdjDSHcL5IJT13SznnZ/STPZHi2VDcCfKDEEYOiKEcD9AWnLB0Qj5ciDy3BZSNP1UAI5xg+eV/BHnotXejmzCJnHXOTI+e4PPOgp764rDlvFM8YSrkOQ0xKNYvIRaNKWLENsqMpynuJ7dSpyzggrEKohz2jVaocXkgHlS/AeoY4FDws2AYbs+6RjFneNEx8w70U34216CjSc1vWAALXJPbAnJW9lQa0Fck04PnWg00FWIv+UTRckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7811.namprd11.prod.outlook.com (2603:10b6:208:3f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Thu, 23 May
 2024 22:31:48 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 22:31:48 +0000
Message-ID: <f326387d-9636-4377-b82f-10e8d335c6ff@intel.com>
Date: Thu, 23 May 2024 15:31:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
 <beee3369-0075-462e-8449-88fee807463e@intel.com>
 <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <013c9532-cacf-4604-b1d9-e90fdc80e7dd@intel.com>
 <SJ1PR11MB6083C6A9DFFF58FE305A33F3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB6083C6A9DFFF58FE305A33F3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb9e202-3c66-425f-52a5-08dc7b78223e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QVNEMjMwY21TOEVoVG5uSTFYK2Z1MlR5MGpjMDlCcmQvamdZb0lUNE1OYU5S?=
 =?utf-8?B?Q3lEZVQ1aTBQWTl1UGw3d0UxQWdKRzhreWlydXA5M2hncW1kb3paWmZjN3o1?=
 =?utf-8?B?SW1hMVpkQWVRK2duNGJUb0p6YXRxeU44Mzk3S2hTMEZjSDVCUElFZ1FrSVN2?=
 =?utf-8?B?OENocEs0WW0zVU1Tb0Jjbys2T3l5YktKTHNIYktiamk3ckNTK2h3dmduZ1Bn?=
 =?utf-8?B?Z3VWMjRUOCtRZVE3RmFURC9LYjFaM0t2Q2Z0RVNhMGo0VEwwRmlyV2JDcmtI?=
 =?utf-8?B?R1dXMkNDRjlCUWtyRUNweWYvUTRmaUhpdVVkN0V1VFZNY2dIM3RGMU11REdF?=
 =?utf-8?B?OStSRy9oRmNiY1BnbERVNUdYNVhGb3BTSkZtR0d5QVhIdWZZVjU2b2FIaG83?=
 =?utf-8?B?VXhFb1FXSzdoak5La082dHFxRVlZVTBZTWR6clFuMTA5YmJYU01VcnpDejJs?=
 =?utf-8?B?cXMweHRjbFhzZW9GUCtFUGtPL3Y3KytNRHQ2MmlsYTZSM1NQNnJNOFA0TXRq?=
 =?utf-8?B?R0swdGNkd3MvWVREcWppeGxUUkdmVldpRUhFeXRCTW4zTVRiR1JUNHNCTERT?=
 =?utf-8?B?SkpKYmp4Y0YvZ1UvTStuVTBnaVN4OUxmV0FLTXlKK0pPM2Z5OU4xS3ZkMXpj?=
 =?utf-8?B?ZTY2b3JVRUlCUkRobkFIRjdsWUdTUHVFVWM1SkZSNGxZdDlDRDA2SEpGVFdy?=
 =?utf-8?B?VG84Z1BZZE5BOThHcVh4cHVPUUpXclF0eFB6RFIyeUxrUkdkVi9xN2s3a05Y?=
 =?utf-8?B?b0E3R21iamxieXZCTkwzS1Q0UUxsaW9Lbm9RSHZ4WHpuckN2SGRLSWNOUHl5?=
 =?utf-8?B?YzJ6TFp2eVZ6TzRjdk42ekhIUFRwRHBVUC90VzArU0pqNmlLUDJiTTRSemxt?=
 =?utf-8?B?MUIzeElVV1piWHhyVnBnbEVaek5lWnMvYU9SYStPMkIzOFFmMWJhVXhFQVp5?=
 =?utf-8?B?anluQ2dGTDk0VVFvdFNieU85QXJjSy9oOWZTVVlHczlOZ3hyUzBkeFYvaDJX?=
 =?utf-8?B?UU9NYUtGTk5rMk1NN21uaDdDVmZmRzJkV25td2tueGF6SHE5ci9uSStRQzdU?=
 =?utf-8?B?YXIvMW1sb3BjK2RLNk0rMnZoOURIS29TQlJPOWV3b1hMNld3bFdZazgxTDdS?=
 =?utf-8?B?bTV5RXhsMXM4U2w0amxJanlidVYwQkJEeEdEd1pISUJiZFBicjM5TFBzWVVv?=
 =?utf-8?B?VXE2QndMcTNpUHZmTWJxaVM5amF0MExocWxlZmJ4enYveDVybzlBZkJ3cG5y?=
 =?utf-8?B?WmRRQmVmaDVqeGR0K3Fzbk5IVFFKYi9Hb3ZMNzBuYUtDTnBZUXpWQWVSZVFn?=
 =?utf-8?B?RGFqc1dNbERnNWdoMG5TRzhtTytIdmZpY3pteFdHekFSN1BuMGdkZFYvNjdx?=
 =?utf-8?B?ZldpUFJTSHlTWTNzdHZ5NnQyYVRXNVE3YjUwSENYVmVmTkZ6elJsYkJLRkxq?=
 =?utf-8?B?RUJvem9ZZHBoYnRpWEZsNG5TTFhaMGNVSVQyUHZGOU5SUXd1bkZtTzdxQ2R1?=
 =?utf-8?B?SitJVkZvTjJFbTQrSE9ESitUVnRFaWlhYjg4bkl2MFlqQnh2Tk1pLy9kKzEy?=
 =?utf-8?B?Y2wwb3U3cllEQStnYzdmK0dHemdKQk15UHpWb2hIYThqVXdXL0ZzbUd2VmM4?=
 =?utf-8?B?d3B1bm8vdTRPQ1dVYmVXLzVMMXdmcEtLWlAwaTZGOVNMM3hDWHFaWkFSUzJo?=
 =?utf-8?B?dXFkMTYra0dkMDBZSDFNVVlGK0hwWmxaNmJUOSthMnk4bDZEcG44YUVRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHJENmVKdjY1U3Mzb3JRZ1Fmb0FUdGphWm1RMzVZUmIrTDl2WlhUSmtpMG1Y?=
 =?utf-8?B?VU51eXpXaG80Q29yMVd0UUVOekdsMXR4RTJ5aXJDRGJxb0JlMmhLMHFnYlY0?=
 =?utf-8?B?MlhkR3hNNjIyYm4yRU5OUmFYb3VQTUREeWEwTUtyWVBwM0o5TGlzMU1sVWFE?=
 =?utf-8?B?cVpNaGgrVWREeHRUcjJrTHNIK1R2OTUxSmlON1pZS0RCNFpNNTkxMWxldm9V?=
 =?utf-8?B?eEJReHFGK1hNSFlRMXRmT2IvQWNwODRtektjUmtlMlRRUUQ0OFcvMGZ3SUxR?=
 =?utf-8?B?d1dhazdyVENZUDdUZFYwdUNTL3BzRUEvdk45Qjd5Uzk3bXhoOFplRGI5YUpJ?=
 =?utf-8?B?TklOeHdXK1BEWHlzSHoraUJGRVFQZDZ6TXBtd1RQTmlRdG91OFpyR1JMSWJy?=
 =?utf-8?B?d1JLK0wwTGNhSDhQTm5uOVkvaDV1RVl1Mmk3OUdPZm9JTDNQcElyTS9ZS012?=
 =?utf-8?B?OVpJdEI3T3hIUjBTNmhFcjY2NDlaTmhSbGJJdW1aWG5MMHlLMDFVS1VVZXVz?=
 =?utf-8?B?Z2NXTnUxM0JTbnJXVnhiQmVpcHBBWWtJa2NoWGJPKzRBaTg2NktmWWxCN3Jo?=
 =?utf-8?B?eWRVTldmdzJDZ0pIYnVBOEdRZ3g1ak5iR0t0dG44T2xCYTFpbm5jY21uOHNs?=
 =?utf-8?B?Umx3UWY0MzZ1RnY4aGx4SkYrVE5aL3RJOG1OUzZ0eFk3VEErYnMwK3QxK0tP?=
 =?utf-8?B?WWZTcS8rMXp6UlN3MnRVeXBaMVQvZ2RrK2kxSnhYK1NObHRpVnpUT1lDWU40?=
 =?utf-8?B?ck82R3RHcndoNG9hN2V6QlFmc3FNcG1URDhYZ0xLelBDQ3JIa0M0UjBObkJM?=
 =?utf-8?B?KzNSTUptUmc5bXZnWnJiUHNGMU9EWUNYbldPUWZ0eDVicWNmOFhZdEFHS2JI?=
 =?utf-8?B?bDNQL2ZTR25La1l6c21xbTRwMWk5clVvazI1LzNyODZ4UzdTWWpSUWJSUldO?=
 =?utf-8?B?WGt5TWN6akNRZkdYcHR2bDNNTFJqVVFoUE5NckV4YSswM1dqbHI0ei9WcVdZ?=
 =?utf-8?B?aFlBeUROMHQ1OFVPUk5qc0dMYkVMM3k4c2lWWFQxc2NzQUpzQjg0Uk9VOU90?=
 =?utf-8?B?ZmZyY1diNmE4aWx0ZTFGQ0VZTU9FazhhRGhrM0xmUnFzeXRsdnczNi9QdEJ6?=
 =?utf-8?B?TmxQU0RxTEJXRURBOEFiTjZQYXdQSnZuVVZ1UUJKTXl0eVZWS3Y0K2c4LzdN?=
 =?utf-8?B?QUVPZDZkdmZ0OUlvWTZJb1oxS3dpeG1BdlJYZlU5UFRVc1VLajh1MUI1RU9w?=
 =?utf-8?B?ZTdvWEo5WlFnRTlWWDN1bTNTVllPZFNqT2ozM0xSTHcrVjZvTmZwS3M2K2dT?=
 =?utf-8?B?dk5RTUtRN1hhTXdUNHBOQmJ0TjVyVkxrVUtia2h6eUxUNDgyZHNpREVKZkFn?=
 =?utf-8?B?d1c0VjVtWllWTEtaekxQYXAyc21zZE5JTUtQNURPZWNxMUw5dC9LSldieGdm?=
 =?utf-8?B?Ly9BakMzOWhvcEN6Zk85a1FZOXhmQlVXbExLdVdVdllFdlFheVU2emRvN2dz?=
 =?utf-8?B?MGEvTlI1cXlybCtxWmpicG95Szlsdll5cEZhbVNkTG5uTHNNaStyZ3YrdklN?=
 =?utf-8?B?emRmUUFxMEl1a1MvcStzMVIwY0t5U3IyZFR3Z0JpNW1NazBPNjZQZUNPWEFv?=
 =?utf-8?B?cGh5cXFkbWErelYvUENVRFJ4ZkQ0QThnRFhGOXBlb0pXYjhkTG54eU5NejAy?=
 =?utf-8?B?ZkNxQzFLWnpzT1diYjhUVml4VzhRU2IwbkIvR1dBbTI5bGRadWRiSVQwZDlS?=
 =?utf-8?B?ZnB1Tk40UGdmbElWODlHZ3NCOThBdXo3dmh3cXJsVlJaS1ltS0NLdk9wa3hy?=
 =?utf-8?B?ZGVUZVdobEk0RkVyWG4yaG9PcXEzcU1Ra2tqdVFXY25XRFhtU0I0ZFlkbE5y?=
 =?utf-8?B?d21EQVN5U3dQdTBHL3ZuMmQ1dnpvTmxReGQ0MzI1YXFDeDU2endidVUrTkFL?=
 =?utf-8?B?MnI3b0NORDF6aXpPaUI3ZWt2MHBUbEpHZGRDb2h6TUNZTmhQemZEZHdEako4?=
 =?utf-8?B?N2RFVHpDYU52bXFteWUzeEpLcC9TN0cwY1RCTHQwaWdyN21NTkpBWkZ4Qnpu?=
 =?utf-8?B?QkdUdU9RMVV2WXMwa0pJekdoclVoTGdCZHFJRnk3UXBua014cWcvZHhjQVhF?=
 =?utf-8?B?RDlOT2R4K0JTSWpTQ3llY2IxSWRlTE1ibDQxV1lLV3YzdGRvNHlVeVBjU2VC?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb9e202-3c66-425f-52a5-08dc7b78223e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 22:31:48.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IB7VDu7lz9ToNDUbAByLPsQ+Btir9ag4KmwEaIwt2nv1EuCnZ3oou0l/zzWMluvq7eFbg0Q5thtg0ZxR/uMb71yaRjGBbWtzlJ29CaQbG1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7811
X-OriginatorOrg: intel.com

Hi Tony,

On 5/23/24 2:25 PM, Luck, Tony wrote:
>>> I'm also contemplating dropping snc_nodes_per_l3_cache from being a
>>> global variable and making it a field in "struct rdt_resource" (only needed
>>> for the RDT_RESOURCE_L3 resource). N.B. Babu had suggested it
>>> shouldn't be global many patch versions ago.
>>>
>>> Perhaps name it .domains_per_l3_cache or .subdomains_per_l3_cache?
>>>
>>> Bad idea? Good idea (but you have a better name for the field)?
>>
>> With the check in supports_mba_mbps() changed I do not see
>> snc_nodes_per_l3_cache needed by anything but arch specific code.
>> I thus do not see any reason for the resctrl filesystem (or, for
>> example, Arm) to know that this value even exists.
>>
>> While struct rdt_hw_resource is a place to put architecture
>> specific information it does not seem appropriate to force every
>> resource to carry what is essentially a system wide (not specific to
>> resctrl) L3 specific property. To me this really seems like an
>> architecture specific global setting but I'd also like to hear the
>> motivations why it should not be.
> 
> So (in arch/x86/kernel/cpu/resctrl/monitor.c)
> 
> static int snc_nodes_per_l3_cache = 1;
> 
> Set and use only in this (arch specific) file.

Since this series initializes this value in
arch/x86/kernel/cpu/resctrl/core.c it is not clear to
me from just this one line how you envision the changes.

Just to be clear ... when I refer to arch specific and
filesystem code I am considering how this series integrates with [1]
since that is the direction resctrl is headed in.
Being "arch specific" thus does not require that it be moved into
monitor.c - it could be added to arch/x86/kernel/cpu/resctrl/internal.h
where it can remain after the fs/arch split.

It will be very helpful if you view your series while taking
[1] into account. For example, when looking at [1] you will see that
mon_event_count() and __mon_event_count() are resctrl filesystem
functions. When you consider that it should be clear that adding
an arch specific get_node_rmid() between these functions will make
the arch/fs split more difficult.

Reinette

[1] https://lore.kernel.org/lkml/20240321165106.31602-1-james.morse@arm.com/

