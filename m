Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B0260575
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487198; cv=fail; b=Bw5c5gL+hqCeph95Mjslg5awBfC9LvhG1zLAIt5MIUpng1IP5bUo51nmTryjwrmjI9QY7czX3STdc49g/H4QRbZu6Ip6k8zGdkete+YG3jjAmrrDSIMEiFkzdjo/Bu38FSFCNaS1lTFpGexsiIl7OANVa3Gg5MqswCsytU8uo6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487198; c=relaxed/simple;
	bh=xdabRS86YE3Ei/H4cRVDiL6tded/bJV9Zhr0pQjUDD0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pRlnzbUCCV0AtSfG645DP3WiUGt0vx+RbS4EwZXV4wCKoMD35Apz/YyVth/11gG8DkB8wg5b1NunbSU4TIT+Xo582NnHBYsszxpGRH2vGiOuvGyAF+nNm4iSrTbYUMuNcTlno4vP6J2eUS7YvJxKENgXqzwpCqM5EMnLzc/Gekk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nolFpwA9; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nolFpwA9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487197; x=1785023197;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xdabRS86YE3Ei/H4cRVDiL6tded/bJV9Zhr0pQjUDD0=;
  b=nolFpwA9uZRJsz81oBLDLyyPizqW8M9hXPdHEIXuUY3NJpBzK4Dvf8q0
   ODnOVeHnjUb2Tpg3BUNzSaEI2fAxTP/4jXawPYKgngj+xRh77vrjEc36n
   wlXNOFLDaCiuPqPshlFyAQ7rEjbCUaeh9oZW05XcTl3XHFH7TZ+bibUb8
   Q21J6x4/QB3LK7GR5tI07/N+R/qmziUCF4K6xDCVaCslAm2ycl+MrEgqt
   10atiz8RqkhO0qF8XwyLUFbBA41ZgGJ5zMyEm4B96F7jgIpmxFQ7/Cg/E
   8SO50Tibok/j1fKT2GNl51WdsrArVagNAJ0b7L8CriB9NZZJ1dC9TmBwC
   g==;
X-CSE-ConnectionGUID: h8RQSxbBSySenrP/hPG6ag==
X-CSE-MsgGUID: j2j/LVRoRqqI4/e81M836g==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55039858"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55039858"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:46:35 -0700
X-CSE-ConnectionGUID: RhteIia4SG+SsqLDCl8kLw==
X-CSE-MsgGUID: Y7KdUqXiTJCZq6Uj5kaBFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165698477"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:46:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:46:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:46:34 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:46:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUm3ZT7VPP6E4jLJnyFlRSvLmHeggPUXyqBtz2Y2nMApGNlqK4SM9sIne4E1J2gUHc7XvHyTad0OCQGxmRx99WlL/LVilehTnMhvFdtLF/bxMY5lM+mRUOswAqe1YlkTIoWpkQQOcY/KaE229rwc6JvgE3eWxyTy0FxiLXlJjUQZlNUOlxm2fzZ1MNeHGNzNkftFyYfsICY1qDKA8kmSqnnF/zgayJbdiHVcV7tDr2DICAlbxYYCjk2chIpLWJ3vUw5dCzyILN4265I9srqUbr1En+W46eu2o/Nm1jHTh0sDD1O8yAjuRSmU5Vle9kzjQniaqiwpaJn9lV8rnmFv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBuuOm0KVu/bQ+UQRHZ9CY51rJwG9XM9VcKRS1ERxn8=;
 b=nh7ZqtzjVPxlFxiNPL9DO9Xg+xfuB3Qx+h6Oul4qYCpszT7G5BZyiITWcXYyMbZA1KY+j12dd4tDpmTbJ2qQZjec9xSuYqV6GUAGT+TbGx1kgvmtIoRCISZ8tRfKa4gin9PSKoO2CdSwTqjis/NFeyK/CWhc1d39APvoZehjFTGCRATy2wQ/2p2tFQx9+70MkuAy3FJdVjVnuT95U5ke6dXVk2uy1Iwy0hWpJQKBAQvxR4sJFYGgA8lRMxiSGE9PztYq/BzVLaijZUjHdYHbmnRVEgf5nKWh/Ngo0MxxCnJkX7tMOzjKIsoB+ls9aqytkW9Gqj12T1X7JRIHXuxjIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:46:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:46:28 +0000
Message-ID: <ccf6db60-2fd9-4d83-8ed8-68e600664fcf@intel.com>
Date: Fri, 25 Jul 2025 16:46:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/31] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:303:16d::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: ac059c75-2189-44fa-c517-08ddcbd57930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YkJJeE9oSjAxQWN3cXBJVVRZK0c5WHpmY1ZjUjFaK3VmV01UQmpvT1hKRndp?=
 =?utf-8?B?WDNoMHFqb2hoR0VCbmdIOTBPSHB6bTRuKys5ZmhjLzd4ZWhtcEVZZVQzSDd2?=
 =?utf-8?B?dCtzMlJQQ21mWXN2ZFpWbjVPNVNaUGpqb25EaUozSVpFMGhxdUVVak9ZTjkz?=
 =?utf-8?B?SFN5UWlxN1crODR3d0ZLN0tCUllNamd3QWVJMkdYUUxzWWJYcU5QVWdocXVp?=
 =?utf-8?B?UE82VGw1ZGxUQ1I4cDhiMnM2QmpSanhETmxyd3czQU9IbTlpOXRpbVpNNGV6?=
 =?utf-8?B?NEp4YWVCTElNc1dSMUxya3hQVmVPMGRuV3ZNTnEvcGVLS2dxc2R5RXptOXhS?=
 =?utf-8?B?VEZINFlKemRzazFSUDVMbk1KT2ZKMTRUd0p3VmwvSy9nUXlNMkp4b2pUeHQ4?=
 =?utf-8?B?Y0FpbXBUaEYwbnNIZnhRMDFKdWtrY2pmUm5pOWFQTUM2SXBiZFlXM1J2WHR6?=
 =?utf-8?B?L2paTlpPT2h3bVpWRFBteUViWjNISjdkcXk1WkpHTWhwV1Z2aEtPb0MvbWx6?=
 =?utf-8?B?bzIwK1c5ZXl5em9VNUpVbXVxVmthdFNqSFBSd3pGcmlUOTV2N08wSHNQUTRH?=
 =?utf-8?B?OVkrUThsQTJxMFU2OVBxa2xUVVI5S1JCUzVjYkVDczMyZTZ5UkhrM1dDL2ts?=
 =?utf-8?B?M3dIRUNQd2t0ZVlBQzNWUXN3UXA3Mk03aU9iK3RJSFBpaEQ5aGoxZUV3a2Fl?=
 =?utf-8?B?bnp2b01IMHhnU0lrOHNtUUsybU9oMUNZR2lxalA3bVRNOFVyTXh0UWJESmJQ?=
 =?utf-8?B?QmtwSEE1S0N2eU1DekdES3JiZEtLdzVHaDJXb3RLeDF0OHdJZXVlVkViRmwv?=
 =?utf-8?B?UDBHQkhjN0hXc1Z0dStsRjNTa1E5NXp5L2plUXNaQjh6RGJwNlZXS2JPN0Fk?=
 =?utf-8?B?MXA3aCtIRnp4TEg1UWpnR0lRZFc2aFY1d3ROMlhkZ2cwRW9uZy9pa2tKVUpO?=
 =?utf-8?B?dGJEN0s5LzZUK3RyemdybXZ2NnVjU3dVK0l1UHEwNFhCMGZ5MStGM2laaWt6?=
 =?utf-8?B?WnJPM2tnaDFURWFUZDE2RXhYZEs1TytSZlgxblRjVHNQVTMybGYycmpJNlNP?=
 =?utf-8?B?Rkg2UjlEbTNXZVo3bHhPUTI0UnJISDkrWUVFdFhkOFEzZ2R0ZUhQamdoM2NB?=
 =?utf-8?B?bFd1OGdlY3BwUDZySUZUZ0tKVmc2UFRCQWQwZ3llQ01MQjRxUGhLbVFHTGlN?=
 =?utf-8?B?NjFVOS95VE1JbGJGYklGV0h0amM2WURoZTQ4dzlZSVB2T3I4OWJ4Rm1LVFpI?=
 =?utf-8?B?dXpHWkswd0tZYTdvSWhjTkdIZ3F6UnNmWitqejdIQVVIYjFQbVduVTMxUmhm?=
 =?utf-8?B?WGdWWWxRa1FtVHFwbmU2R0Zpd1kxaUhJa3hOM2tDTitsWEQyQ0l6bWg2cjcx?=
 =?utf-8?B?aThxbFZpNHo2bHZnb1lrTWxQWnBCdzNXUlM4MWNBcXZ6QVpjN2xscUgvVkRa?=
 =?utf-8?B?ZDRLRVlmcis4SzJ0YVhzTEo4N2twbEVMMWVtazdiYTFNTE5KTnFIMmgrcklw?=
 =?utf-8?B?Nnk5SEMxTG15SEx5N1hDMDZxaUFCREE2R1IweGRSSEZGQWtXdVRwSHJ5cXhv?=
 =?utf-8?B?NVJhR295MHFZRmJuaEtacWhHR2t1bHo4eXlXbExDem9RMm1hRytNVmp5aS9R?=
 =?utf-8?B?eEEvWVQzQmExbkpiNFVsUnFpN2syczQvcnU2MzVEQUxtNTl2c0Rnb2pRQ0th?=
 =?utf-8?B?U2ZJY1pxTUtFUm81eU90bEFBYWlUYnlHK3dVdVlsK0hrbWhCTld5TlI1TEpJ?=
 =?utf-8?B?aUxzRW1sMC91YzhNNEllU2ZXcmp4YXBZOFlzVEU3anA1ODVNZlNQQ2dUKzRG?=
 =?utf-8?B?SVhyZEhINVhuMVp3dnQ5M0c2NWhCRkJKN2t0b2doQVFWZFdKbGZDTHcxWEVs?=
 =?utf-8?B?UHB6TGNmOUd5Ny9TRmFqaU1UMkpEbm4ydm9ROEw1SGpkaUJ4R0JXV0ZCeFFG?=
 =?utf-8?Q?vy8A5keijaU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2V1YUozY0hsYkRwSzNSOVNjeDVnbzYxMGgycW1ibW1iL0pha1ZHakZUNDl5?=
 =?utf-8?B?eXdsZmEyWjBwT3NTMklqd2JlOWhucEZnZ0dUaHRGRzJ1NDU3bmJ5ZHhzRnZI?=
 =?utf-8?B?OWg5a2xNS0RkcndXN1R3QXdkTFNYTXRKTkZZVmw1QXZJMWExTHZsMHdlQ0x3?=
 =?utf-8?B?MmFzbFVKblA0eGw0MmgwZ0FyTkZuNUZLTk41VWxXR1VwamxnNlR0M2Vadmta?=
 =?utf-8?B?WFF3MjVLdXlHN2U1MC9ocGJzSFhENEY2TVZGTmpGVWJiZllUa0hEZFNkRHBT?=
 =?utf-8?B?ZTYvM1VaUnNNNm5iaDVyQUV0OS9uZWhGODdGa054MXFzRWx0YTQyeGVhU2Yr?=
 =?utf-8?B?c3NuSTN2TzN6YlgrSC9MY091SHJaNjJCUy9WbGxKeCt5aEs5Vjg0YjV0S2Uv?=
 =?utf-8?B?TWVPZzUyeHBHZHRiU09zS0xNdkJoOTJPcWxwbUVCS0VFWnNXQXBJQWFpK0lS?=
 =?utf-8?B?YXUwOHd2QVZxd2JMK01BNUNDdEhjMEZpaHJSck8xQkZpZDFxTmZlL0Z2TFdO?=
 =?utf-8?B?OFljTko4Tlc1MTdHM0Jac25qY09uNmFibm9leFNqMjEzMTBpSlV3U2lUMXNV?=
 =?utf-8?B?NzJUUTFCZTZqQzRPK0ZOcU1qN2ErZ3Z6RzY0M0ZlTHBrMkUwdnlVYjQyVFZT?=
 =?utf-8?B?ei9Cb0NCVkcvVUQ2R2RESFQwc3k1SUxYVzM4WUZpMDBXaENGMVIvS2FIRTNx?=
 =?utf-8?B?ODhYTGZyc3o1U2JLbENLaCtEeWxMWEFPRStUdWgrbWlnSEF0cjBabk8vbVZr?=
 =?utf-8?B?eGhCQ2phWXBoUCt2UVVUb01jbnRGRS9xZ1JuREhmTkVGQ3duTzkxandPOFQv?=
 =?utf-8?B?S0R1RnVOR2tuV0o3WUowS0JlZU14R3dYQUt5WUQ1OHBBenpUWWtRZzNoZUc1?=
 =?utf-8?B?UE1kQW1NUk5pTVpKd0VPNERzWFJkTVhaYUZpMEg3QXQrVEo3eS92QW5QVFJm?=
 =?utf-8?B?dk1wTldFcDdQbVJVclpYLytnazlLblV1ZGdhM1pzOVk5Si9QY1lKRmJFamJY?=
 =?utf-8?B?ZllDQ01wYkJDTWIxdVdNN3ZBOTBqcFVmWUlyS21IZ216YTFDQjE5U0VjQVNP?=
 =?utf-8?B?OHdYdFppQWRFZVRCRllybnU4YlkyVUtGQ1NTWSttMlNMQkpTaVYzaXlTaEJK?=
 =?utf-8?B?Z2VlOVo2MDMxRnBzOFJLa1BZZVR1RVl5d05CenVtZjIxbUI3SXFEVXBoTXNI?=
 =?utf-8?B?TVl6WnZHM2V3K0NKcHpvbUNxN1oxQ0VERmI0Q2xlM0pZcjdqdzYvZlpTRVlt?=
 =?utf-8?B?ckxPNFdtUmYyb0x3a0k3SjNkTm0xNCtXZFlvL3BSMHl1Q1E1dHdMZ2ppditz?=
 =?utf-8?B?a3JMd3ZickNsV2pSZUxFeWxnbm5mUG1rQS9NMzdVaTY1Ri9mMWRoWE1IL3Jh?=
 =?utf-8?B?d1ZMa3F1cU9ta3UzeTBUNGhWVzRmVHMveHlSMENyN2lCQUI0N2RsSHdDWFRl?=
 =?utf-8?B?MlU2N2NzaHJXNVpCT2cyTGcxcmNXSmFydU1zVTRwZWp1MEhxRjNUSTAwTWVi?=
 =?utf-8?B?QUJ5ZnJub3N5ZjJ4Z2V5MXlhTEpTb1ZnQkZmWjF2MUs3VEg1c0dvT2llM1Ba?=
 =?utf-8?B?cnRZTjZJT2dxRlNOYU5hNVVncGZuL1c5ejgydEhaK0FodXBaU0ZXNCtFR3J0?=
 =?utf-8?B?MGZaYTdTQVkwTTUrUCtrSXVwajdWak4vRk8waWxma2YzYjVXQkg5MG5xOGxj?=
 =?utf-8?B?aTMwdi9OSkFHYzlqQWtzSjZ0WFkrY0kzVHVZSkliUHNLMHlnZTRxYU94ZlJM?=
 =?utf-8?B?NGNienpDV2YzSFRHSGQ4QUEwM055TmF3Z3RCWEJaYWthRWhERTdSbEZxR1Zz?=
 =?utf-8?B?VmhhSy9nUXd0TDdnN1VybmkvSUxEZDRubUR4TW1XcWp4Mmh5NzJQalVZL0Ro?=
 =?utf-8?B?K1RlNVJaQy83QkFtUWNkajNXZGpvNUxVYzVDbHZlK3hUYS9aMlhPQldtb2hL?=
 =?utf-8?B?elFOa3BkUmMrRGhyWXR6cHlwbmt0TU1WQjc3OG55MkdYZTk4a3ZBcjhGS0Jj?=
 =?utf-8?B?WjZSMzdOSDFjbEtDVm44Y1JycnBDQ3drbWhGbVhxdVdhTW1VbjZDeHp5Mmsz?=
 =?utf-8?B?RndWQjlieS92SXZESG9Jd1p6UTFvZFFKSTlwcUZPbEVIRTNZV25yTUFoZkZL?=
 =?utf-8?B?RlJYSm1iTUNBMkpLTWtVZ2hWTjZBd293ZTdjamduZ2xPeXowS3Q5OW1TU2NF?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac059c75-2189-44fa-c517-08ddcbd57930
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:46:27.9775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGEbXBA+e5BXj4hSH0OdV8DQqaRNcgvH0qpN62+rhnZ+LuJBWloO8WOlmA07DOrOvmnfJcPXi/+kV9ZhrTsIPTdBtR+bDTSfbs6cMYLtD9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
>  #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
>  
> @@ -865,6 +869,32 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +/*
> + * Hardware features that do not have X86_FEATURE_* bits.
> + * There is no "hardware does not support this at all" case.
> + * Assume that the caller has already determined that
> + * support is present and just needs to check if the option has been

nit: "that support is present" -> "that hardware support is present"

option -> feature?

> + * disabled by a quirk that has not been overridden by a command
> + * line option.
> + */

Reinette
