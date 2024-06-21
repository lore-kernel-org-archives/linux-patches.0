Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAC859155
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989813; cv=fail; b=RRo0Ufis8uVtJhQzuJMZ25dHfqZdHbPv6IeGkFJXNSiRfKA7Ou+B5kmh1cT9uid2YIj7eGW861gFztq9z+9fctQ2MoKYpd12sihO/S25zoTFKXfsFXqAz4vBJZHS41bBTg1+sV/kEeXES1kIHdQV3j5QjikQI464qHQhHttTglQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989813; c=relaxed/simple;
	bh=MqOAUk9fO4DLKUtABNFlSpRP5kR0qQqxl19iEJBDAMI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t0BTuFXj/9tuoAGkYkhFS2WFA2p+OoZra+GNshEkyot80cGAnAe6dewy2r8BpJ+pzlQeaYkMTddQyifTSH7OM2Gp5VjjBOPDCu3cffW1oB8OOzuBakV10A5h75wNzf2dIDkND3un3hFB57ysw5JTFk3DY1MhUL+9qp+O+zVtmDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xn9a+xsf; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xn9a+xsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718989811; x=1750525811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MqOAUk9fO4DLKUtABNFlSpRP5kR0qQqxl19iEJBDAMI=;
  b=Xn9a+xsflggf7cKHPmZywVptqFfcJ0EcgjtlRj4HRjOUfitnOBpTmz73
   pF1HQyLHpiJoEIOor1+CMHLD6hJHs6DVILGyL9FBAHhI7t7JJ0SFjSa74
   UO3JQn5vmkB0GL9CRNHPVSQGn2C1I+AalEqnZMHjGz8WoDBIf2RGPSVVq
   lvHrEANpZUmNsHcE4+rkn5Nk7JgkyeO3rmpPd0B2XVFI4hj5BF6ygb0wO
   2t3O2COo0pf4F2260vPyFn3wOl27zaiTsv3rKyzc9InhO52v9k5IiFID/
   3zojBQ4SRZ4dnhdtBzV64QS5kgxEgNZ8qncpSR70/XQb7V5aKCsZrFQmr
   g==;
X-CSE-ConnectionGUID: RAf0t6zJTdC2+yCePYfXTg==
X-CSE-MsgGUID: OqdT/qv0Qk+2NNDsL0pFyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="16176570"
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="16176570"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 10:10:11 -0700
X-CSE-ConnectionGUID: jKeUz8ejTAK7g8eQsn3GuA==
X-CSE-MsgGUID: qgrRQpIPSha9qp9PZHSXqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="47831403"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 10:10:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 10:10:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 10:10:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 10:10:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 10:10:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMJ5tcx45OlphjNHWZ//I2l5z6Ib/AsxooLmwGxQfEcATsARkuy2TYkkBqDyyi9DiiTmyo/67APF2r6WgRRNaWWjjf66ehWflLff8bWdtxpW94SBqRqpgRQkCmeIPiy9ujRx31HGNY8tMqz688KEGZrWiXqtALl8WiHy6rqIyz1pbLGGbl8Mk8+1N+MkkGFgjPiPIFDe848/Y8KSMAj7GSmtOzo/BEpg8OogV4L4mlZZvwPMYD0HXKPpzoKWTrDlxv6+BDiqwIGLhWOVSNhco6V6bSAUq4fQ1IrqmVvKsF6ZDFF9+4G0qwXqNYJlx/CiL2eY2N3JNhzJpVVrLjxWNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTjaKaco6panE+lJe842YlFVgk5q9Z/6ojpBtzcEgS8=;
 b=FWXHL3mHox40s/jK4YSyrYaZQT+seQ6MyJJsgjNUk3SSL3uQd/K4Mg07nfHAqegZHyu4mLB4qp1Q/geHpYOFmAfTcNy/55yVQp65iYhgrPYf3lCfabt46hs4Aul3z9CpJ+Ws12tIWdhHLtjz1a4rIsKKWk3LHURFWS4A/yvSCacztEUH2VMULbQ6Tj6XE9To9o92qhY3OOaqbGAnUkFHsJzMsn6Nt9+VXy29U4KQfoYTbVvOkS0sKJBiM8ddCgrieEy2cEgtJ96oBz+7Vqm1cT8WY3yU191Qe/pIETJAgdpItTjNGTF+CcIGsMZF1Xj9l+qtXBSlzEsCk6cN+TSbJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Fri, 21 Jun
 2024 17:10:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 17:10:06 +0000
Message-ID: <369f5ed6-603f-40b6-9c73-e2ee27bc7997@intel.com>
Date: Fri, 21 Jun 2024 10:10:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount option
 on Sub-NUMA Cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-8-tony.luck@intel.com>
 <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
 <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <74ed79c1-b024-4b22-9858-14c1e5284a20@intel.com>
 <ZnWbSTY64N9_aSWA@agluck-desk3.sc.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZnWbSTY64N9_aSWA@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0337.namprd04.prod.outlook.com
 (2603:10b6:303:8a::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: b3c91cfa-64f0-41b3-2c7f-08dc9214ff77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UHlvSjFtVlV0aXR5UStUejhjam0wS00rZ0Rxck5PU3RUK2RXcUN1WWFlbzZX?=
 =?utf-8?B?eFYycnpVYVcxYnFWMGg4NEIwcHEzbHkzcVZOTU9oNWZDdUR0TVZiYjFsRG44?=
 =?utf-8?B?Wk5lYmZzb2pQWTErdlZlREkzNGFpWGVpNGo4a0VPajRxVHpOSFZGWW15c3Rs?=
 =?utf-8?B?YWtXZnpGMEhkVGREdmd5UzV0V2twSUN4b1J3OVIvRnRXYnBkTU0zeE44UFNO?=
 =?utf-8?B?QlliZFJ3Ukg3WHppcVBWVXFGelR5RzdmMXY2UTk2YVdLYk5Ic0twbTVXU0tK?=
 =?utf-8?B?NEJXbFk5ZHhPQUtMZlBsdmVTTENwMnB4Y0tHaEZySU9OUkZXYzNGTENYL2tq?=
 =?utf-8?B?VFlJWWRIZGtWZzNKYXMwWWlucUNPdVZQRU9xelA0aFlWK2xYVzljZzNqcHpF?=
 =?utf-8?B?WXFITnFaN092YWNMaXBqK3BDckk0cm80TXh0b0FVbUtlNUUvVTFIRjNFMjg2?=
 =?utf-8?B?di95V1hyLytUWXRjeHR3cW13dTBWVzhrbkxwLy94TEtZZWc2Tk0ycDdzeGNI?=
 =?utf-8?B?L2hFNFlSYXdKU0x4SUZZUGVOaVM2eTRiVjNyamRjSFY1ZzRHQmhnKzVhd0tn?=
 =?utf-8?B?c296eFYwcm5sNFFaMWh1cm9SQUoyM3RuaTEwWm1Rb3JvckdpcmJ2OGlQdlQw?=
 =?utf-8?B?WEUyU09tU25OMm9IMUg2YmlmdE5nSHkyQlZCMFdKRnBxL0VTSUlmWEZFQ1dV?=
 =?utf-8?B?N2RBWUJ4SUF0Mk1FUk9INnRvY0dWMkx0U0pwUHNuUXJpS2liR2FHR3VJWHJn?=
 =?utf-8?B?V2k5VFBkekNLWHFNVzNDam4xazQ1amJGM0YrOGQ4UEVsUE9QYS8vK014bzBo?=
 =?utf-8?B?T1Q4SU9USm9PcWxzcGJhdGo2ejQrd0VuNSs0eEZ0TS9BQzhzbitUTyt0SnNN?=
 =?utf-8?B?azhRV0x3MnFmbUlrS1ZySmRDdVZSSFBzZi9MdkJ0ZUlaZ1dyV1gyZ3o4NWM2?=
 =?utf-8?B?THI3bzdYZ1drb3U1czdnN2x5M1BHUU54MCtzSU5xSzR3SDhhMHpaZVlpMWt0?=
 =?utf-8?B?VWQvSVE1TFlpNmVSVFprYXArZTJnRnRPYkJGVG9xenJQQVZZL2pzeFNTVlZM?=
 =?utf-8?B?TVVtTkhGNXJVZEZlOFhFWnFEY1hwWnp3WnVJOWErSmsxRnZNbzVpeXg2eGhT?=
 =?utf-8?B?U2g5MDRWblhjWVlOVXRnOFhoek5lOTRYRE1VbjN0WERpU1YwNjZIc2pEb2RG?=
 =?utf-8?B?YXJTYU9NWXhRTjhaa3h3QzZuMERnSDZITkplTkcvWmNDV0VOSjVkZ0MrN2U2?=
 =?utf-8?B?OFQ5SHZlK2N5Wm5XQWVUWEpWR2pnUEo4Vnc3aUN3bXREQnNmdEdIUy8zWnVY?=
 =?utf-8?B?M1poMVBSeHkxY3E3M2xwOUI1ZFNrcDJ1K0JsTWdpTGpXNzU5WDgwNVZVR3dM?=
 =?utf-8?B?d2NLay9mYUZnQkxPVS9TNGJCbW5IY25yK3FqQm9hZUdTWll3cStmSnhoRS83?=
 =?utf-8?B?Ukp0ajFDMjlMN1pRMHhwcnVubytERmxVMURjbEUwait4d3NTeFBVUjhUcE1E?=
 =?utf-8?B?bG9JTWlBWmhWQzg5YUJ4OEhlWjRlTlRhNmhyQXYyMmdzNkduemtRazVJZTU4?=
 =?utf-8?B?QWJsNUE5SHZoUUxCMkJwL3hXb0tNSmcvNnZqQjFhZGRzaHRoeXQ0Wk03M091?=
 =?utf-8?B?L0NvYnFDSHRRWEtYT3I5WVdMOHk1WnpYK0ZKZXVlN3VQanVETE01VFdlemRG?=
 =?utf-8?B?Q1FOMExUZk9UR3NLNWZJM0p3NGlFeGV2enQ4clBCd05vb3lCeTdySGZnV2NT?=
 =?utf-8?Q?XfyFUiRiiDuKFI9JS50VLuLCbZuVjX5E/NQYekx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXBxSE5IV2hWSEdzalFXbENXTkxqTDRsZ3dsdUE2NkwrNkMwdkRnOElKL2Ni?=
 =?utf-8?B?NnZDenhnSUw2OEVmakpEVWRNdUtCRkx0clY4YzZTVzdEZjVoU2ttNHgzaStY?=
 =?utf-8?B?aXBIU2N3MjVLSFJ3Sy9CRWhXMytzZldsbEh0dWg3ZENyL1VFbVp3NkUxSTU3?=
 =?utf-8?B?UTdIR3dwMktaZ2FoenJpNVRTYUszNzNWQkpvNElsRlNRVVQ3OTZmcTBLYTdw?=
 =?utf-8?B?YlRVbXd6a1hxTGw4QUtwU0g0bFBmb0llTEhsZm42TlEydUkyY2Y3SjhMVjBw?=
 =?utf-8?B?L2ZaWHZ5L1dOM3dkcGRGeHJPb1Z5a3VRQUVFUlEwRHpQd1R0cTRPRFVmVGZh?=
 =?utf-8?B?L09sUzZvenFGeFhLdlJnNzlyQXNUL1JXTkRidEtoZEJnTUxtcVJpcDBtSTFC?=
 =?utf-8?B?dG14N0NDbitsS2dhUm91R2VWNE9jbTErbE51MkNFNjJhRGZMVFNIbitXZUJT?=
 =?utf-8?B?S2xjWnJucXJjUExxWGdXa0plUlVrYXdCTXZmY0g3R2NLWkp6eHMzMWRtUU5q?=
 =?utf-8?B?clpYRzAzRU1CSG1BVEhGNzd6REhHUWxnUG5ITG9SNFFZMVo2TEprTndZdWdm?=
 =?utf-8?B?WTl1YWtUSytwZWFPVEFRdCtENGl4RVZ2azBVb0FxaGJ4SllOOEQzU1NWVHdS?=
 =?utf-8?B?REVqWmF2amF0ZE5ORGxmci9qL2pQUTJXU2NoaDRRL05xNmROK1pVdVFmbklO?=
 =?utf-8?B?dXZJYlJRQ1lMVVplbEl6T21odjJWZ2JkOTlSYVZmb3IvVXd3cG1RWjcxZGpI?=
 =?utf-8?B?TS8zSGxqU3Q4WjdmZ29BNS95WHRVTjRvNUZmOVY3eXMrVkJSVWtmaXpuUm5p?=
 =?utf-8?B?bVJFS2k4bWhSSnJlUCtub2F6VWM3WGR4WVk5bTBzRXZVMnhmaWY5Y3Zia0ty?=
 =?utf-8?B?Zm9VREozS04yM3Jtc2pNSlFnSGFzaE10SFBqM0tMY1B6QS9mcTAyWFJiNkE0?=
 =?utf-8?B?aFN0c05KU3JnR0ZoWUxXdVJxSHpDdTA3VmFOa1FUYVlUeUlDOFJvTHlCbitz?=
 =?utf-8?B?WWJvMERBVHRqd1QxSm44S1RtcmV0d05oZGVYK3ZmNzFFOHZWTk1EaDd5bTVU?=
 =?utf-8?B?NHZ1czdwWUt0U2tMYzVsY2I5Y2hnWit4bE44d0lYMC80UHd2YjBTUlVyc1cr?=
 =?utf-8?B?cHdFaUlGbjRzQStBNllicFdDNFlZV2p1N3NJYzVwVjdDSVVkd2gxSEhpakhn?=
 =?utf-8?B?enM3Y3BJQ3NlS24yOFB0KzhqZGdsWXgvWHZtV25XM2xNcFY0RjVTVERCa0k5?=
 =?utf-8?B?TVY0UElOUXgyWkxMamxRQmk5UjdyMnZ3K09hRjZydXJDT3pZL1VHaWtZWHZN?=
 =?utf-8?B?U2JQMVJlUWFFWStJbXRELys5TkxDQ2tZRWFvM1IwRUEva3o3VUs4YTJaUDZW?=
 =?utf-8?B?WUhpcFJacDd0TGJUM0VJZGxHcVJ4UklTTjJXcFUwTk9XRm1ZUUxHSUQzWjhq?=
 =?utf-8?B?V0luL0pMM3BNVWdFcENoU1VBeGFSZlF1Y1FaVHpCSTlrYitnNnZBL05iMitX?=
 =?utf-8?B?QnFwL1hsbkYxMHBjRTVoSksvTGhjOWV5L2JNV3FZRno1Q2NnUUFvSi80VFBp?=
 =?utf-8?B?UkFkRW5IR3BZSHJPZWtrQjFmemgyZE1QM1ZLM3ZsdFNCZlQ1eTIzRXQyVmxJ?=
 =?utf-8?B?dGMvWUJ6ZFFqVVk0SHVvc0tWM2NTanZ3T0dDRzZKdGFhWjBTK0MzZWFyV0NZ?=
 =?utf-8?B?SkNJemtsMUlRaEc2YTRlbkFNVXVKNEVOMHV1YkF2K1kyS09zbkxLZy9mSHZ5?=
 =?utf-8?B?RGJQT2I0VUtMT24xWS9Qa3dFbzNOallMK0o2em00dkV2QXpUQjVQNmVYcDF2?=
 =?utf-8?B?M0VOTUpGdG1SZG5uMnJqaFM5azJmVGVjTkJZTXRJY3VRaFdTR2JzbE5DSWhE?=
 =?utf-8?B?Q2ZnZFpGL0dlTTNoQXltcFdvWE1iRWE5eTA4NndNUjJVR0ZuT2tKTVo4Wm5i?=
 =?utf-8?B?U2h3UE5DV05xejBKQTBRSjJVeGtTZFQ5emJZM2lJQ3RrQllJckFKWHVVdjN1?=
 =?utf-8?B?TWVpYzFTcFdybzNiRERxcW81WFZGdVk3M2lvY2xUVUdRMDQrckJpVStkQ2l1?=
 =?utf-8?B?NlZ2NzVzSHVieFpvbUZVT3MxNnhhQlBaUEUweTJWeFU2d052ak1MOW16UnJp?=
 =?utf-8?B?YWdDbyttNFZCdzNWVExzazFXcWFUT255OG4yQkRtcnJ2U0NlYzRteEpyU1Jv?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c91cfa-64f0-41b3-2c7f-08dc9214ff77
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 17:10:06.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EigZgDs/PFzNH4T+rfJs/dld0dthv1KiZYKC0OsMgCFjAzhzRTux2NS8X9D2FCIMQryYsiRPTh/pl67+C3VWr3kxTZMASat/dYkvWZxdBPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 8:24 AM, Tony Luck wrote:
> On Thu, Jun 20, 2024 at 06:56:56PM -0700, Reinette Chatre wrote:
>> On 6/20/24 3:07 PM, Luck, Tony wrote:
>>>>> When SNC is enabled there is a mismatch between the MBA control function
>>>>> which operates at L3 cache scope and the MBM monitor functions which
>>>>> measure memory bandwidth on each SNC node.
>>>>>
>>>>> Block use of the mba_MBps when scopes for MBA/MBM do not match.
>>>>>
>>>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>>>> ---
>>>>>     arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
>>>>>     1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>>>> index eb3bbfa96d5a..a0a43dbe011b 100644
>>>>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>>>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>>>> @@ -2339,10 +2339,12 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
>>>>>      */
>>>>>     static bool supports_mba_mbps(void)
>>>>>     {
>>>>> +   struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>>>>       struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>>>>>
>>>>>       return (is_mbm_local_enabled() &&
>>>>> -           r->alloc_capable && is_mba_linear());
>>>>> +           r->alloc_capable && is_mba_linear() &&
>>>>> +           r->ctrl_scope == rmbm->mon_scope);
>>>>>     }
>>>>>
>>>>>     /*
>>>>
>>>> The function comments of supports_mba_mbps() needs an update to accompany
>>>> this new requirement.
>>>
>>> Will add comment on extra requirement.
>>>
>>>> I also think that the "mba_MBps" mount option is now complicated enough to
>>>> warrant a clear error to user space when using it fails. invalfc() is
>>>> available for this and enables user space to get detailed log message
>>>> from a read() on an fd created by fsopen().
>>>>
>>>> Perhaps something like (please check line length and feel free to improve
>>>> since as is it may quite cryptic):
>>>>         rdt_parse_param(...)
>>>>         {
>>>>
>>>>
>>>>         ...
>>>>         case Opt_mba_mbps:
>>>>                 if (!supports_mba_mbps())
>>>>                         return invalfc(fc, "mba_MBps requires both MBM and (linear scale) MBA at L3 scope");
>>>>         ...
>>>>         }
>>>
>>> Line length is indeed a problem (108 characters). Usual line split methods barely help as the moving the
>>> string to the next line and aligning with the "(" only saves 4 characters.
>>>
>>> How about this (suggestions for a shorter variable name - line is 97 characters)
>>>
>>> static char mba_mbps_invalid[] = "mba_MBps requires both MBM and (linear scale) MBA at L3 scope";
>>>
>>> rdt_parse_param(...)
>>> {
>>> 	...
>>> 	case Opt_mba_mbps:
>>> 		if (!supports_mba_mbps())
>>> 			return invalfc(fc, mba_mbps_invalid);
>>> 	...
>>> }
>>
>> On 6/20/24 3:12 PM, Luck, Tony wrote:
>>>> static char mba_mbps_invalid[] = "mba_MBps requires both MBM and (linear scale) MBA at L3 scope";
>>>
>>> checkpatch recommends "static const char ..." pushing this over 100 chars :-(
>>>
>>
>> How about something like below that reaches 96:
>>
>> 	case Opt_mba_mbps:
>> 		if (!supports_mba_mbps())
>> 			return invalfc(fc,
>> 				       "mba_MBps requires both MBM and linear MBA at L3 scope");
>>
> 
> Reinette,
> 
> Alternative option. Move the messaging into supports_mba_mbps() and
> split into shorter pieces for each reason. The other callers of
> supports_mba_mbps() that are just re-checking status would pass
> a NULL argument.

This fragmentation of the mount parameter checking, splitting its error
reporting to be partially into generic code, does not look ideal to me.

Looking at the information provided in the messages you created I can think
of two more options:

rdt_parse_param(...)
{
	...
	const char *msg;
	...

  	case Opt_mba_mbps:
		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
		if (!supports_mba_mbps())
  			return invalfc(fc, "%s", msg);
	...
}


rdt_parse_param(...)
{
	...
  	case Opt_mba_mbps:
		if (!supports_mba_mbps()) {
			errorfc(fc,
				"mba_MBps requires local MBM and linear scale MBA at L3 scope");
			return -EINVAL;
		}
	...
}

Reinette
