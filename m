Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993752D94A0
	for <patches@lists.linux.dev>; Tue, 23 Jun 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782229511; cv=fail; b=Vf5phbSneiNgpvQebkWU8wPoUPRNP3N6ycnhg/L0NOmBSVx/AFL7epOGa8kKOtg26SE2Sj2jvSbTyQwvRKOeF+rlQD8yKC9WBCiah7gNG+2krhYVoWQJx+HPEzMqFvrE3UfsCgm49ftGctRMZ3tx4ztyimgVWQJhStD9KI0Hhs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782229511; c=relaxed/simple;
	bh=ewfui5468XKMNBY5GynHUaB/EOWBvKX+xYD+DHf4kHs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SDVjC0n0129UgPHgxxvz5eGZhWOD9etDmnmfdp+WNmycv/pF0T2K9K5u4pRkp2ArOol/UQQCpSbxbFOsm05yIaDaFBws+KUmFo6b47yU0Elp3akWZVQkUkMfhLF0lA9xO/7gpiTZqxGozgsXGuXT0az2jzlDLVaZLozIMtLLu8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cVjjLhWQ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cVjjLhWQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782229510; x=1813765510;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ewfui5468XKMNBY5GynHUaB/EOWBvKX+xYD+DHf4kHs=;
  b=cVjjLhWQEiae8So0nWky1dOr7/M9Q48DgAMZt1AeNiIUIAzAPMKcEHIb
   9pGLnkULawGN7ax05o/QiHGsvLVYmNw7R9/k1NT+pWu+t7TB0HLKYaEwc
   ldmuMcOQVq0IMwO4fU6wZiKxOoqOWJomFl0AKrm8uB3EC/uqYFr3yLWmh
   5NYeDPi6wiX211GQqBxiulZreczODwXnwE2kK7cuhhRMrokwbEKQEpn/H
   4mecLBJdmCNp2vYQZbvbNXEGsipxBBVFyZeI4iHNZaHQfLrehxX5op2fd
   fo3hRHS8r1nG7D9dpBLL9mzFfRj493yvYlInP1JWUes/zdW6IOG6q5W50
   A==;
X-CSE-ConnectionGUID: 8m0ui3k2RC6nG/jdInsFqQ==
X-CSE-MsgGUID: 3KEuKv+LS6q+km+TNm0YnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="100526212"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="100526212"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 08:45:09 -0700
X-CSE-ConnectionGUID: xDwVMXqYR6CKnM8HTxi2Wg==
X-CSE-MsgGUID: 8Qtdj9PVQpW1jzAHTCZ3lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="273619325"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 08:45:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 08:45:08 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 08:45:08 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 08:45:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Euke+OY7/XjA7SyS8Tahw/b8cPKk3gI8wpGdyAQKkt+e67EO1/swVF3n/8BXFPdslsUY/thg3rSASsuUE96AeNr719vfC9xJOT4cJ0r94auKTxoMJH1vNWaFPWG7yftNck2lyLcWT2gRvla6kAwXwqC6PdY7vl+BszavELSz6wpFqetNAa+fX6P/l5Ly/TdvLjA5sobrMevJ8GVVpqPFN6/ixcX+ouhkfcmuP7XEUbORblIhSTKHyatyBChzM5zbrpQ/GBuH+8zmq4E6wJyAvkOiqK1ItIYAg05XwrlXa2SqdTLAup2MZiEl2LpR15dmxagLpkkxfXmzZbbW3/utkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yn3TI+lSc4RV9Le1nwY1WoAoQ2W1eiqd7EwMaU9W2Vs=;
 b=iJfaLV6uJzSFVqhGAQXS27Ujb7dETaZY7+KcWSIfHRAT1vriuwkb2NEDL6oAOvOFnWxFIi5qpSmfAyc5nUd5Thk0RTsWUjm45YUODAgmsFTlwJWyci45zLatqpx+E5AoKl+mQskkpFK9/QRED9SjKkLkp1zjl+Kroz8iZdzsYGv7dPbUFJDQiSl/IiaamnJDvB3nggS/fVwDD6jGV+YJtwDrPTPIppdslwwX9WZW7VnSrB4wizcdx1DHkUygAYgYdt9sfQxaKnPUL7ymOZpVdCWW4U/xT5crF7GeEKy2t8Lr55G55zDzSxk6OGatp9252bdjx549TDjn9dW1GlnOrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 15:45:05 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 15:45:04 +0000
Message-ID: <fddd44b4-a3d3-4c37-8a01-2c5b55c36657@intel.com>
Date: Tue, 23 Jun 2026 08:45:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
 <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
 <ajRf2P2ChE7SExwO@agluck-desk3>
 <ddc91d49-c861-4737-98ed-9b5d2e583449@intel.com>
 <ajm-jVzj7TUeJkY-@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ajm-jVzj7TUeJkY-@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:303:b6::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA2PR11MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f99565-9afb-45d9-b28e-08ded13e650c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|3023799007|6133799003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 3nJNxGA/89aoKkfSusSs9xE6kAepcFARC5D8Gb4mxeK2FrCBUoPxonSSNtOJBw4F47ZRzXdHGKdYPT/3IRz7m8AViKb28OPRiTqecx+mLb2Y9MeRzfXOuopx8W678Ljuy+btWO0UdFtFQ6h2+CcxFEme5O9DoACNQ72Ic2MWzZVVx9AIrjyTDBgDQZEwql8zJVUoR4LAcdg+m+HLD3mmuxn/BIq9kEBMKGzDx+3ZuOvfD3cFEXP9guhV9DKTksiSTzR2wcktZINBJN1XJ7Jwgmv+/ikVBW7Yirtnok4m3Zge8jxlZQPS7889uB5G3XlvtIE9jlLZOEMvChDmckrJ51B5UwNpBvIsX98zQ6dB6eNQTAp6E0rygKkq6WykhOXt2Blltdg7sSFWdp2gXOO/sFNEwNxh2k6FkVLi1fhxSTT/gJK3f7lNcdxquWIpNpHESWFZ7ZMImJeM6H2UhKZSZLVZOISaAppSTR7Q3jc3WVXwno0CpjNe/BOgNPLMO3s1o8f90bR23C9azFyv3qYNtz1P1eplZTrzInw2te0V1bk4KNfew9MYS+Pv6Hz2XXDM0/Q6NZv/eCfEQtjm4sObdASxxXrvw6rtPI8vtelGn9TmOaAOPec5VTSnelMr+zu96DlHppgFzmYmY1bZB/PWyuxuzOKW5qOXuuVN5D4ZSzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(3023799007)(6133799003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3RrLy9pMzY1bk9tQ0JaNVllVWFuS3lPeHlhS0NTUWJIbHJpU2tvMlBLR1Qx?=
 =?utf-8?B?dEV3LzltQmt4RlFVdittNGZ1MElGZ0syanZkN0Fua1dkY3ZYSVl0b21LTHdk?=
 =?utf-8?B?eTIwcG51L1IrTTlGNlNqOG9tdUdIbUJuNXBGMGpiSk5nUVlibXZhSE9TWDg0?=
 =?utf-8?B?NHdqY2VhSDI1ODNSVTN6dFVjZFFLcUxhK2haNWFpNXRBWlB4eVpkeElTZDVE?=
 =?utf-8?B?WlV0cXlpbFZINi9mZVZkQUVkZFhHUXdRVTNNT29adklRUEZMamxaSmNCRzUy?=
 =?utf-8?B?NEg5MThuRi9acWhPa0ZaTnJUTkZpTDFXRFNqZmdHdXRwNGh3N1RIUXREZnQ3?=
 =?utf-8?B?VUVnMU9aUnRhUG91TUN4WlhlRml6bVZlYi9od2JKK0NVelcraCtOdGhZQTlq?=
 =?utf-8?B?ZVkyeStGZUxUY0VRSFovWWpBUWFxUWVXWjNlUXdoOSt6aGFEOU1CZGV0VFNU?=
 =?utf-8?B?ckdXR0RacG45djNXU1pZdjBkSjM1QlBUbC9VT3R1TnR2UFQ3eWNNUE5DbmRo?=
 =?utf-8?B?RThUL0lZOGZlZHdEWWFydlcxNFV3bUZTM0FUc1hLVzUrM05xT2JUTVAwMElx?=
 =?utf-8?B?UFpNSTRiWDczdE9QR1V3RHhvempSR3dMd3A1YjJQOHJBOEovWno4NWcrTVZm?=
 =?utf-8?B?VVJyQlZpNkgrU2hBOTByeVZWY09ydlFBRjRPbWlVUjJ1a01Rak1JeWJpc1A1?=
 =?utf-8?B?d1lvY0kyTGkrUW1WK0FiNlJGK2xVZ2RZbTBxV2RoZk9XT1JwNGUwTHRDb1Iv?=
 =?utf-8?B?RGhPekFWWmRRcnY4MVJraml2U296dDNRc1pEVm9odzRDeDZXMTcyM1dTZGMx?=
 =?utf-8?B?YzZkZ2xEeG9NTXBnTkNOanF3SFplVGV1NGcvQndwZXE1N1hXc1dSTm05ZTVo?=
 =?utf-8?B?dmh6c1dVNkdzMGRjZDZPZTBQNEV4TEVwSFA5VFpWVjVwVlhSZFBEUFk5TEFL?=
 =?utf-8?B?QkltYU5KMmNYU0ZFOU5DemVJeWhvMkVuQ3F3cHpWQWpnbTdVbG1mL0hJUjB6?=
 =?utf-8?B?NE0rVThVNDVqUUI1aUVPdCs0anAvNjd6Sk81RkFMQThuWTdLMUdtYWlyMG1p?=
 =?utf-8?B?cUx1QndlOU1YNWo2TDIwcU9ucWc1RGg3bUI4NFdNVU83cVNGdFQ5SUtXRzB6?=
 =?utf-8?B?R2Nxd01RVkFpbFVLZlBHRyswWnhkR1lyVmIvNTlrdGJTRzJ1Yk83UHdDWE1a?=
 =?utf-8?B?MnRHVHorNHhsTnYwanZqY1B0MWpQaGhjNTBWUWo5dXJDb05sM1VJZFZQOVMx?=
 =?utf-8?B?amRHeDFWS2ZnYytJT1ZGcTFkQXlINURvanNEcjlsTVJpUHJxZWJyZHBoM1VM?=
 =?utf-8?B?biszZk1YQzBZa1JVeVIwSnhxd3dTN3U2K1FBY3V1Y2tXSm9WaUFsNmtGeDRo?=
 =?utf-8?B?YkdTTmdQMkRFUDU5MDlRZzdhejhxY0JXU3dVUlN5dTJlMi8vbmdWN3VOTkJE?=
 =?utf-8?B?Qnc0MjZPTFhmYWJjREwyMll6UmFRUCtPcEFLWUdUeWJ6SERuZTBnTnBvQlo2?=
 =?utf-8?B?UHNXYTcxOFJCS1U2TjI4cG5GNXFNWEhGdlNnbVdoVmdDRWZQaVFJd0dNRFBJ?=
 =?utf-8?B?anQwNXVJeGEwcHNsV29LdmNnaEdYQUd1dnN6RVF6SnFYZkZPRjN1bEw3Wncr?=
 =?utf-8?B?NkhpcFB3Z1pZK3FabnZJM2FSWmdRNzlraVh3MmJkNG94WW40MDFYZzJuamE3?=
 =?utf-8?B?RzNwV1JDelM3T1Mza2syU1FiK0VITlZtejZid0orVjR5d3dCVW4xeHFqMjZh?=
 =?utf-8?B?WG85WDdDdExsTlpQZEJNd3A3SytmLy9VajdVUkR1U3JQbzBVU3doanhLTE1l?=
 =?utf-8?B?eXQwNkw1Ty9YejVtNk94c0dzMXJBdzc0aTk2U3pSTGF4b3hkaG9ySmRUQlFs?=
 =?utf-8?B?QVpjakZqZ2hhbm0vL2ZLR2FjSVZYNy9yTm9DbTZiVG5JTENKSzdGRlRUTHI3?=
 =?utf-8?B?ZytFMTRwaXVHOE9FMmVMcE10Z2lyUjF5WnlEVTYwczdXSURHc0JFU2hyeWNZ?=
 =?utf-8?B?STN0VFpQZERQbWg1OS92TFJDNnFDdHpxbkxpcnhua2wxVmNHdFNwd3AvTE9D?=
 =?utf-8?B?SnpYTkZhek1UOVRRNGloSzF0QVVRVlIvV1VxVGRrZ1pNZ0Jnb0lRZWJUZ3U0?=
 =?utf-8?B?U3pVYzVYRlc0Z2RaN2pja0JYVDNkQTFsdkppWnBGOFlUci84YlJMSG1TWm13?=
 =?utf-8?B?ZS9vd2NqZm1hbVdnMGRuV3dwRnZVUHNDaGYveEZjUm5rWjdIZ29IZEt6eXpy?=
 =?utf-8?B?eE1FRnU3cDZmT3o1OG9Kb1VvdzNZREhSWUNuVVVONFdMTE1CN0RxUFY1Z3RO?=
 =?utf-8?B?Zk1LREFDdTMrZlQwMTNIRHFMQ3JIM2tiQVFtbEwvVGtIRWNURFByeEJTa01Z?=
 =?utf-8?Q?CThTLT8Wy+IOBGco=3D?=
X-Exchange-RoutingPolicyChecked: DiJVF/zaUx/EjrLqdVREfMb6I3OOS45cAt86Z/e3kjP3g9oAafgti1P9+sXmQvjme3r5euSV4MoUMzW4d2ukI7wIMjX88XMdLLDTfODByNZL5rrjTy/IfzbL3ybM4DHz/c5uE7fl4l/u+hsjmuWlf78OubWelLEGnczFfpuGm+DeXwV34sYRbsdNOgIMXCKFgZWOiKNC5PbRcxLLK48SuvvVilwE0MNsv0V9lJPSbpXmZbCZMV6tiJJTaA+mbMqmIDfi+Kbu0ups3aAI4SggoTt5MCd9CNqDH0Yg3WZswD7iWsJknBZhVpCTCrTCYiqLjZqkLbneP1ywqsocV6sM/w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f99565-9afb-45d9-b28e-08ded13e650c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 15:45:04.8798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKCCI1ib5AGs6yVJGbwhT/m1p2Ux4We7vp5Ywf2/MefFdvMcUb9IdANIBp96F251B6/nIE8o/7IwoKMHuLiwi0xHKYE2TCVUBI95bbPC77M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5052
X-OriginatorOrg: intel.com

Hi Tony,

On 6/22/26 4:00 PM, Luck, Tony wrote:
> On Mon, Jun 22, 2026 at 08:46:31AM -0700, Reinette Chatre wrote:
>> On 6/18/26 2:15 PM, Luck, Tony wrote:
>>> On Mon, Jun 08, 2026 at 04:22:27PM -0700, Reinette Chatre wrote:
>>>> On 6/1/26 12:56 PM, Tony Luck wrote:
>>>>> INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
>>>>> call PMT functions directly.  Register the telemetry enumeration function
>>>>> pointers at pmt_telemetry module init, and unregister them at module exit.
>>>>
>>>> To ensure intel_pmt_get_regions_by_feature() has access to complete data, could
>>>> it be more accurate to register at the end of PMT's .probe() and similarly
>>>> unregister during .remove()?
>>>
>>> I agreed with this. But on further reflection I'm going to dissent.
>>>
>>> There are multiple devices (at least one per socket). So .probe() is
>>> called for each. Registering with resctrl at the end of .probe() sets
>>
>> Thanks for highlighting this.
>>
>>> up for a race with a mount of the resctrl file system:
>>>
>>> modprobe				mount
>>> .init()
>>>  auxiliary_driver_register()
>>>   .probe() for socket 0 device		rdt_get_tree()
>>>     intel_aet_register_enumeration()	  resctrl_arch_pre_mount()
>>>       mutex_lock(aet_register_lock)	    intel_aet_pre_mount()
>>> 	get_feature = get;		      mutex_lock(aet_register_lock)
>>> 	...					... blocks ...
>>>       mutex_unlock(aet_register_lock)
>>> 						... runs ...
>>>    .probe() for socket 1 device			Does enumeration with socket 0 complete
>>> 						but races with socket 1 .probe()
>>
>> Could you please elaborate the details being the "race with socket 1"? Wouldn't
>> moving registration to init() experience the same? That is, if registered during init() then
>> at the time of resctrl mount socket 0's probe could be complete but not socket 1's? The
>> move to .init() has additional scenario where resctrl mounts when neither socket's
>> probe has completed.
> 
> See '*' paragraph below. At end of pmt_telemetry .init() all probes have run and completed.
> 
>> Are you referring to how user needs to remount resctrl to obtain all of AET that
>> the doc patch refers to or is the race more serious?
>>  
>>> I may keep the unregister call in the .remove() because as soon as the first
>>> device goes away, resctrl can't usefully run. So it seems a good idea to
>>> handle that right away.
>>
>> The "resctrl can't usefully run" is not clear to me since resctrl mount seems to be
>> ok to let mount succeed without all devices probed (per above). So it is ok to mount
>> resctrl with partial telemetry enumeration but once all is enumerated this will not
>> be supported?
> 
> No. Mount shouldn't run unless all devices have been probed.
> 
>>>
>>> I will provide details on the reason for the asymmetric .init() vs. .remove()
>>> in the commit comment (and in code).
>>>
>>> Ok?
>>
>> I seem to be missing a few details to understand this solution.
> 
> For AET telemetry to be useful all aggregators must be enumerated.
> Running with some subset would only provide data for some subset of
> the cores on a system.
> 
> So now I'm trending back to registering in module .init() after
> all probes have run, and unregistering in .exit() before doing
> anything else.
> 
> Some experimentation has shown that the asynchronous part enumeration
> is just the intel_vsec driver kicking of auxilliary device probes.
> 
>  * Looking just at the pmt_telemetry .init() routine, the .probe()
>  * calls for each device are run sequentially and synchronously. So
>  * when .init() returns all of the AET enumeration is complete.

If I understand correctly this is because pmt_telemetry relies on 
device_driver::probe_type initialized with the default (PROBE_DEFAULT_STRATEGY)
that can be overruled by a user space wanting to "boot faster".
Should pmt_telemetry's probe_type be set to PROBE_FORCE_SYNCHRONOUS to support
this new requirement from resctrl?

> 
> Today I dug into the problem that mount initiated automatically
> by systemd from an entry in /etc/fstab occurs before pmt_telemetry
> is loaded. I asked AI (Gemini) if there was a way to let systemd
> know it must wait for enumeration to complete before invoking
> mount(2). There are MANY options to do this. After cycling through
> several that either didn't work, or seemed overly complex or fragile,
> I've settled on this one. I can add to the resctrl.rst documentation.
> 
> It uses a systemd service to mount resctrl triggered by a udev rule on the
> load of the pmt_telemetry module.
> 
> The udev rule:
> $ cat /etc/udev/rules.d/99-rmid-telemetry.rules
> SUBSYSTEM=="module", KERNEL=="intel_pmt", ACTION=="add", RUN+="/usr/bin/systemctl start mount-resctrl.service"
> 
> The systemd service descriptor:
> $ cat /etc/systemd/system/mount-resctrl.service
> [Unit]
> Description=Mount resctrl pseudo-filesystem after Intel PMT loads
> After=local-fs.target
> 
> [Service]
> Type=oneshot
> RemainAfterExit=yes
> ExecStart=/usr/bin/mount -t resctrl resctrl /sys/fs/resctrl
> 
> [Install]
> WantedBy=multi-user.target
> 
This looks very helpful. Thank you very much for investigating this.

Reinette
