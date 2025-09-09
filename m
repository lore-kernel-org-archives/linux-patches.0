Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694925487B
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757452442; cv=fail; b=f2/A+3LibdSIw0HO9E9mG2awIOYIDuA+3zh0e4iGWmuhGBgsLZG7sELmv9wHonRrkxdmLhtK9aIqBLj7IOyK4rm7bz6BmyuBc7vEnB+u/6I1y0GlBsom3cMUnJIfi2ArM5Pfj382AMWKg3gzCXiAt6b10NSeVCNPklSB0KOFCKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757452442; c=relaxed/simple;
	bh=FCe/YfIN5LLykvhSnOztExudHXyOdrFy4ounnqfWT3E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NsbBsdiYgOw7ItLqZe8xOg/DDqJPjkrYMtPxBZxf9qv7COBb4wvA4jul27k5ysyzuAgZa2FuO9Lr83anGBhh7zcnHfzWBpPgmX9mcex6i9tLaq7fTf7Kc4dsza0dKprAMj2qfLafDSiPYgRdOH/UDTNrfrczPykluXkzh2qRgjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INuW2ELt; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INuW2ELt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757452442; x=1788988442;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FCe/YfIN5LLykvhSnOztExudHXyOdrFy4ounnqfWT3E=;
  b=INuW2ELttDAHFQGyNsdqkJJhzZBXBN6rA3ZdfngilutsUoo8/oX/uSqK
   TYL62zeV7+nhyYUPxVNV3IMXcgsDMvjgUtVAsrKJKjouUPsKzcX6NKA69
   6ZkqruIhsZvrQ7okCf0yND64CTAmiLcFgelJ5lgtdueXRxfwUT9FOaLuI
   8JUwSSCIkWo+R0gRgxt2NWPDgsQiUFM2hjy455QTvMt9cxbPnP3QFBDcq
   NjuQhzDJ71s9qRbgtPOiGal7W2CWjALP++Cz8tSu8rjlr6dpJnYgFaff0
   qF0Xkd9nUxd1U+RoDPwJ21usn8/D1Q00cK8H4ZJUEDjEnes+jVMrpF5Nd
   Q==;
X-CSE-ConnectionGUID: wbLjxolCSq65R1xR05wlGw==
X-CSE-MsgGUID: xmma1cg7Q5+mrAZKecdm6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="70369100"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="70369100"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:14:01 -0700
X-CSE-ConnectionGUID: qNZMHZIsS3uNnmFMWh9kPg==
X-CSE-MsgGUID: Uh5qgqy0S1e1R0msf8vEUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="173595325"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:14:01 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:14:00 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:14:00 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.42)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:13:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9BsRSoH15Moh1hEtKiHaw+YCBhHiY0kV8WcDWG0LNWqI1kKTDbgOnZgfjURkqiMWShBGJruyVFY6EiH3DnrJzAD4trFJnmwPvZAPLfUPdyRiyYHqIGGz3+Lfsu3dZdhFuJBm2ipOqxCQYrFYjVyeEW73STwnidxlUv8cR9xLn7C6FMQjcAAVM4s8+YUUbNzxfs98FhpHN6DYGLr8Be6y+1AP5Rebdd6QhTFetBdz87Z1IoUT4PV2haijuvvJ2THiqpCwG+V8eG/2ZQbzvEXRxaGMYYLImQcB89y9WGqv5J7IfIZhA7399Nj8xqGKsWjxr/xjlC2QnodDPBj624SvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zoi2GFC9j5NqCLg4oGlvQgDvdYS2fheRkGnWMkgHlow=;
 b=MTOVVg7jHzj9ihHs59ZQN2eThs1DfCqXVo7ksdatkTYYAKWIdKmxP6CXo38KZyWM7ZjRkAeQ8fJk7tEToZocKeXV4stBozQIIIl6+3rykcJckv+6oUGKHQgyqOaKQD6g6J2si1ArSEZ+UXyYdkxUATw5YDUQ+R9oDxvUaUZw4bvlM9u7N20XirmKxSDzVXkoi1D+RhrLKEiLfCEJtFwnNlSCDNMns9SvPrg1FAHI7Idleu7fqAud7X+mFM4BEBjxtyURIzUcF870lnEfiFWAlC3jp6Iwm5EKvr5qsyNONIg7uCGNr7wnJYjNn6XaWnmWhffckTEtALxykdUPDARV1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB8985.namprd11.prod.outlook.com (2603:10b6:208:575::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:13:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:13:57 +0000
Message-ID: <92b583ae-a0d0-48c9-93bd-4211da973dc4@intel.com>
Date: Tue, 9 Sep 2025 14:13:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/31] x86/resctrl: Move L3 initialization into new
 helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:303:b7::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB8985:EE_
X-MS-Office365-Filtering-Correlation-Id: db57b0ee-0040-4e9c-5d70-08ddefe5c9e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L0pHWmhPK1hsY3VBWUJTRzdBSlA4aExxVzd1WEhDWFREcU5uUjlKUFAwSnBV?=
 =?utf-8?B?YTBSSjhvK2ozaUFGamVQSXZhS2ZkT1p1SVp6RWNKZ3FJSzJaa25nQ2orUFJq?=
 =?utf-8?B?akZJaUVUQkVlSmt3c2JubHJMN05RYTR3dndiWG1Yb2ZGdmRTV0ZReVBvUFZ0?=
 =?utf-8?B?VnlpY1VwaEwrelp3SkNtdWtIYW1heGFWN1B5am9odVNGYjlBTlJIWnNOYnJ3?=
 =?utf-8?B?RzA1ZkR0ZWZSMzhaLzUyM3NNUE9EVUsrVHRwemlod3BCaUVOaDY1OEhPeERi?=
 =?utf-8?B?T0RCRTV4SGxGVTlHeHU3Slp3ZFI4VVc0WllJaERlMTdneDJnaHI3YlpzZGlR?=
 =?utf-8?B?eFRTL095K2t5cDQ1MGY3ZnlFR3ZldkJQeWtTV3RlQXE2Z3FOVi9oby9uRXd6?=
 =?utf-8?B?NVNDSGtoOEMxbytSRnFzZkc4bXRTN1hQTFhqZWtyU2o1Q0VURnJFOGFGL29a?=
 =?utf-8?B?dlJ6R2pJZWxTVU1pVXN5NzdEdEJWcTgvSUNsMW9TUVNlRDhxVWkrczI2OVBX?=
 =?utf-8?B?VFNhYk9oWXQ5NE5zaERlazZTWW1rL1Q5bTZoMXlaTnZOUUxTSGRLUEcybVNO?=
 =?utf-8?B?L3JjQkN2b0RBWDF0ZmErSmtWQWwwVzRkSnVra2RHSHNwYTBBN3JkMThXaGxY?=
 =?utf-8?B?TjJzK2RibXVzZEhhU1F5MzhZV2lOTTROSEEwS1MrdzV0MzMydk9pUDA1SlZ0?=
 =?utf-8?B?Nm5nbEJpdGdRUXp6RXIzOFZJYk5zTm83cEgyNzdwbXNEUmF3WlFwOGFHbHdP?=
 =?utf-8?B?M2wrRVMzdkxMY0ZZTmpUZ1lLRE83Z3RITElRU1Z0UUhOYXp4a2NKZWUzOEJV?=
 =?utf-8?B?cTl4ckxLTkl2YldTZFpYS2twS3c5bzNvQVdNaVZnLzNIYitZNU9JenkyaGVO?=
 =?utf-8?B?VGFKd0NpOHFIV0NuWWJTMHR1WFhzb2MyUlZ5bVJRV284UmhBSFlEUmpaVnVE?=
 =?utf-8?B?Wk1WbEI1eHR5V3djemg4T1VWWmN4RGVhWXdEQm4yVktyaWpZdENQUUIzMW94?=
 =?utf-8?B?VzJHeDVNNWVIcEh4VVY4c1JYdXJ1M3UrMi93aUNWN1UzejVuT0E1OEE5RnZM?=
 =?utf-8?B?UUxEMmFZdTF6Zi96cEN2RTNLU0tlclgxa3pEL2lCM2t4R1hTSkxXVkVBOXdL?=
 =?utf-8?B?ekNTdTNlKzVucWxxL29abk40MmNobVlpem9JOTNBNW1Fc2I3YWo3YkxNUzlu?=
 =?utf-8?B?dVpiZGwvMkpYSWNIWjM4cHRCOXVUa3VTTjVaYjk4cE9yMDY2bWZ1RVRrRzRJ?=
 =?utf-8?B?SFRhUTFTSmlJWFRXakFoVGNkRkVaL0l5OWVWaEIyU1FBaGxHeWlHM3ZBWGpM?=
 =?utf-8?B?VFhQR1h3QVJaQm82VEdIVXpXWFRkaExxTFFvQnpMNG9XV2E2WitKRThYQmE5?=
 =?utf-8?B?ckRibHluUWdOL1VsRlAwdlZ6aVVmR2tyRTBTMEs4WUE3M24wVjNYcHFub0FN?=
 =?utf-8?B?UHhwTnYyVmJ6d2l4aDVPeDg4azR6WlJ0eHpkVFpKU3d1YmVydGZqK3Fnem5D?=
 =?utf-8?B?b0F4eFUxbTh0WlQ0MkFLTFJXTGlDbjNMWjZ1aFJqZDZiL1lQck15eFBHQlJq?=
 =?utf-8?B?K3BBM01JUEdMTDRTcXpGd2ZOYkN3TDBRU3hPZkJ6OTgrUVlrZ2k2dmQ0V2Y1?=
 =?utf-8?B?OHVVZkZ5RVpseUx2MzVwd1J2UUFSbGtYb2NnQzFiNmtiVmkrdVFxSWJUVG95?=
 =?utf-8?B?bFJQMzBiRitlSkQ5T2YrcTVxZGRCelBFd3lWZXlGNlhwZUd5WmhzSGdKNEZO?=
 =?utf-8?B?Um55MHZnYWdVWG5Na2JDQ2Zzb1BaZUZpUVo1YTNOUjFtTmxIeWRDdW5sbyt4?=
 =?utf-8?B?Z2duZ3IwODRBbmM0Ull5YVhtV0x3RzNSdEtuZitja1FxUm5jUm1CbUVhZnNq?=
 =?utf-8?B?cytRdFhpbC9Cay83Z0Vwd3dPTTdaWFlHcS9tZG0xMmJoYU9aYVRocEdrRmd3?=
 =?utf-8?Q?b0M3MElhdeg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Um1OTDByWUZ6cHlJWmNOMjlvK0lFKzRIb2hjbmgrYVArYWFOV2I4TXFIczlK?=
 =?utf-8?B?N2VTTllSazlOTWtaN1IxWjAyY2RBSDgwNlBIK1dmaHhzdkYyODY3Y3h5VHpu?=
 =?utf-8?B?V0tCenpReFFTNlhjTmRoSGV1S0xFd0VzdUVzVC9iT09HZTRUTU9CSEp4T3RY?=
 =?utf-8?B?alR6M2dTUGtsc0hPd0JNUmVudGt2WjRENzU2NGRKUWIvVFhpWlJ0V0VJUDBl?=
 =?utf-8?B?U295UFVRZUpUeVl4QTJEaWdMSzlUUjg5Qkw0NzFvNTZwamcrSkJZZHhieVdj?=
 =?utf-8?B?T2dKamVhQkU1YmhLejBtMVRLNUhBVW11Q1pmbTBrdEVTWmZNOWJzdDhhZWJB?=
 =?utf-8?B?bkxqNVhSTlNxMVEvTlNpQzh3VFkraHkxa25ZL1dyQjRTYVROeDFsdW0ybUlX?=
 =?utf-8?B?UUpnSDN4MlFUZFgrejBTOXdPSldYYzM4T1FjenpMQmVQdUQ2ZWxidjZ0RW9S?=
 =?utf-8?B?ZGh3b0UwRGEzT29nSUlQZERkZ1JFRkhlNWRXZXdwZHdSTjFoSTFCNy95Q3R3?=
 =?utf-8?B?Y0Vjc2xSL2F6SnI4dHdJdXRQZ0wxN1F2b2Ezc0MzNU9zT3VTbzYybm9Pa0Za?=
 =?utf-8?B?R04yMy9ZOGZPZ2lSdEdWRUlJLzFLL3c0T2lOZmJsWGVxU05XbW50T3VXY1Br?=
 =?utf-8?B?L3JYWWkydVJ5RUNqclU2MUFZajNTb3dWLzU0c056TGs0MkhuV0pPNVZRd21J?=
 =?utf-8?B?c0VGRFNmZ012cmlNd1N2TzIxZjA2WHkzTmpSR3ZHSmluMG9UMzBoUE56d0tw?=
 =?utf-8?B?OHVGcHlBaE04UlhqRTE4SmVPalBJK1p4MGF5KzZUOEtFQzFURGZ5eStGaGFH?=
 =?utf-8?B?Y0c3TWpQZXZTaFEzQjMyYWVhcHB4RitxQTVabkZlVmtIdjFhK3ZUbVRsc3FT?=
 =?utf-8?B?NXA5TDE3WUNaTEhUUzRMeFMwUVNtM0JpR1hrUy9qeXl0Z01qb05ERTFPV2tI?=
 =?utf-8?B?cUFhczJWU1dveTlPWnE5Tkovc3pPei91WVM3S3M0OEIrWWhoKzdUUEFEY0Zu?=
 =?utf-8?B?RTExZUVoT3BER0RTYy83bE0zaC9nMEZ2Mmc5NVFUNXQ2Q1N6blRKMW1SWmta?=
 =?utf-8?B?WFVXYlhSREFjOWlJbmF3dTl5RFNvTjRaWitPZlNXMlVPeXIyMzNjUDFOMW4v?=
 =?utf-8?B?MlVqbit2QVFCbUszc3Bvc2JHd2dvWStJVlNyczRwOFlodkZHM0FvejgxVlhE?=
 =?utf-8?B?cTJJUHJmN3QzcFVYc25qcU8rZDhhMmVXT1hqM3YzRWcvNzdLak1QTXlhd3Ns?=
 =?utf-8?B?d3BSeE5xN0E4QWJhZXRINGNhMFhscUZiVTEvUVcrdEZXUmZJSlNxMG5Mb3Vu?=
 =?utf-8?B?WjZtRFdLWS9wdjRyT1RISjROSWM2VnJ4aTNaMzRCam8zVmhyczJUTWt1Ynoy?=
 =?utf-8?B?Vm80N2FSUnJURHdxZGYxTXNJMU1sY0dSQUZZcmQzTERzdWtxREp5bVYwNFdO?=
 =?utf-8?B?WlovUWE1Z1doVjVENzdYUkl3blN3NldheFVqSXpYWlNiWVAzRkZQL3BjZ1ZG?=
 =?utf-8?B?VWtCcUVRZHFqWCtxcndVK1UrTkUrejdpSE0vazRRbWlINGpSUVFXdEhHOWtC?=
 =?utf-8?B?RDdqOGJ0cHNVVEYyVXBNdDErQW0yTVhCZUJ2RWtuK0l3dFZnVXg5ekVJK2l0?=
 =?utf-8?B?L3dNclpVbzZxUnhYQjRVNSszVytZT0kzTGZTTlNLTlNjNVpoRWorSitXanRD?=
 =?utf-8?B?dDZteVhjbUJWMUo2RkZDQS9lNmt3ZHdUUENFL1IwMTlIWGJOamxYRWNUTlk5?=
 =?utf-8?B?N2toeHNmNklGa1NVc3l1WTA0Z3FFa3d6SHFHb1J0eHJCMm9nUExMS3BESGxi?=
 =?utf-8?B?YlVmMUdxUldMNnFpQmllRHpNd0xVU1pHamN1SXhaSmdrLzk2V1NYRWMwRzNS?=
 =?utf-8?B?U3VIRjNvbEZpTE5HWHBPbTFlRWIwMktDdWtac1VSS3owVjVFdlBlZG5oMWV5?=
 =?utf-8?B?TGNTbEtjWGNvdGVpWDJXdGw2R2RBL0h2U05jNzRVL0JnT0VkOHloZDVDVkhp?=
 =?utf-8?B?WFRNZ3lsWmd2bmZvdG5QajFSSUFEalMyMURqTDZRM1AzeU5CcUkwdGpBbFZy?=
 =?utf-8?B?a0JmeklPWEU4L2VlSFczUTJkVDRZbmJlNlo5N0R1eHUwNERVbkZFcHBFOHZQ?=
 =?utf-8?B?TkZ0Z3ZyRXgxTHpVS01iNHZ4SFczT25qNnFnOWRHQkRlaTZydm8rQUZtVmlM?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db57b0ee-0040-4e9c-5d70-08ddefe5c9e6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:13:57.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewrUiZ4yXe6p85o1MW8YQ1yJ5WoD7JI97iucSQxtsdXuRx/I+Ovj01CaERyq480gFH2Mu2B9M6n/LEMWOOSkgm7N4ZEA5Xjc0HniBCdJHFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8985
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 56 ++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 420e4eb7c160..4db46c282b5c 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -496,34 +496,13 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	}
>  }
>  
> -static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>  {
> -	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> -	struct list_head *add_pos = NULL;
>  	struct rdt_hw_mon_domain *hw_dom;
> -	struct rdt_domain_hdr *hdr;
>  	struct rdt_mon_domain *d;
>  	struct cacheinfo *ci;
>  	int err;
>  
> -	lockdep_assert_held(&domain_list_lock);
> -
> -	if (id < 0) {
> -		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> -			     cpu, r->mon_scope, r->name);
> -		return;
> -	}
> -
> -	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> -	if (hdr) {
> -		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> -			return;
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> -		return;
> -	}
> -
>  	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
>  	if (!hw_dom)
>  		return;
> @@ -558,6 +537,39 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	}
>  }
>  
> +static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +{
> +	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> +	struct list_head *add_pos = NULL;
> +	struct rdt_domain_hdr *hdr;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	if (id < 0) {
> +		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> +			     cpu, r->mon_scope, r->name);
> +		return;
> +	}
> +
> +	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> +	if (hdr) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return;

tl;dr Drop this domain_header_is_valid() check?

Same topic of inconsistent use of domain_header_is_valid() as v8 [1].

I expect that domain_header_is_valid() will always precede a container_of()
that retrieves the structure that contains the header, that is clear and
explicitly documented in patch #5 changelog. Should domain_header_is_valid()
also be used when just operating on the header as is done here? I do not
think it is practical to consistently do so, especially when later in series
the header is passed around more.

Note how domain_add_cpu_mon() here uses domain_header_is_valid() as sanity chek
before accessing the header but the changes to domain_remove_cpu_mon() and
domain_remove_cpu_ctrl() that follow in patches 7 and 8 don't. Without a clear
pattern and such inconsistent use folks that follow this work with changes
may be confused and we'll end up with these checks just scattered randomly.

Reinette

[1] https://lore.kernel.org/lkml/2e0cdccc-ed1e-4bcb-8bd7-b0274609928c@intel.com/
