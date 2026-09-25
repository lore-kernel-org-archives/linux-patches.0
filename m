Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADDE3BCD19
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359354; cv=fail; b=XKw6e1yMFOFmTQSxu6TiW2KupoOA09cvDcSutQdBgPuZJ4om43TgcZXxjbUgeoauwOJCR1SdhsKZWaRmbpVQbnNYaBXzCY7bUPUT2zw5s5LVpkZ+s4j5MHt1XxO6Sr79sAxXzwa7QxkQtHiS5BSr38Cht5dEXAcx9e2R9aSK1pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359354; c=relaxed/simple;
	bh=Kg63syz9Imalfvky1oCkjtb/Bw/mJKBcbv4v5nKBET0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RzRtWwRJ/KXH2yHiC2uvP3K2Ga7Jmr2Xjw8KOA+5ffCJ1ulTmkAzjqLOl3VDdOl8gwgKCyvpBE1mj5hn+CZfiAanQ6HHXgCd3PD7WgPtQ1P+ETan+FdFXJYRbrQqo/DR9wB3j9/GgFqP4etMX1pDO5dVmfOkSdaGMY/+ue0g2rY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0EIKPa/; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0EIKPa/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790359351; x=1821895351;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Kg63syz9Imalfvky1oCkjtb/Bw/mJKBcbv4v5nKBET0=;
  b=N0EIKPa/deQ07OhxABFMUGEyMTtMq5NPiX4jiY8TBvWsY2CN0zo8r/CO
   vTmUoyGx+YqMv3pvbNVgHPCwtuvw1ZYdLHH3S2DH0Gs7/w1VJ+lEGUvia
   VCzvjBxJiDKxk9BSQ3CGpGXfYDZGCqYdxmS9md1cLk6SU1x2Z7bXBGiIo
   Dfztj7XkjQExUCJpsN1GtrWqII1D27AxwDqVvMODteu3GaQNiKEpQRFTs
   +5amanO9HWfkUOacf1C45xJePwmdLob9OG9xi3QYhHGvIVxEQfdqiKthj
   OWnpdn8Y6oikbkc+4w2njF5so1Bri8K51b7gFNtGaatDKZeZ7JUEKsDF1
   w==;
X-CSE-ConnectionGUID: xJaZv5D8T4qH+hfyJwHWmw==
X-CSE-MsgGUID: GzGLUXEOSy6NdCj1XftOlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="78710951"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="78710951"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 11:02:30 -0700
X-CSE-ConnectionGUID: qu1uBk1ATPKv2QABzOYw+g==
X-CSE-MsgGUID: h5mJ8QfFSrGRS/1pUfgRvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="282473043"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 11:02:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 11:02:29 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 25 Sep 2026 11:02:29 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 11:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+9rq2Nw2nO/crpqHyX8BBRBnVho0o6SGvH2JJUDNcBJecXL6wyhh+G/287mqeJPP1JeoohJnueeAvlwtTJTYm/Io49WcJ7Rx6sl9xyun4zUtxBUusij/F/HZir+tqDA/muiPr40V4ZGc7iA0WLX8DKrm9GQamulDglS/YikiqZXkSQhMk+M5MAlzNoqzHJCF27/iorDB5utBxJJll5kqASPwmMCupZC9CUt+7bvtDns7iB875+/7v7epXe0H2IxnTY8wtmmKGRoOzQWe+oIRXNUTJKgOcY5c/VM3uQ5mdPsEMIUDjiga9pEXxtTA/CrJuz0YG13D8+Q/kbG9gODCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kF0d8rGhTQCY9Ys2T5XTB/yixNVaWe3OYNWcKigpVsk=;
 b=ldfxABeZBFEx+0YL6fJLJUcGZ87IF66miPp2LLQnQnl+XWGyYfeKkhRD9LMjtAdIRkABIF2q60tzImhmsVtRFEMgH/TWVRLPBZ30+uurcZ4n3qs5vgJu4Qnd0TwVyHRI2WQWuJpLtCao/N048hy9c9oMJ0lWM/q4HclK8xVfAgg2m37mR21n30EFy+55RjVc1jPu4JIbY2e8VFXeFRQkh1v6FM5b5UEmSUD1LA8W/sjrII+csykIBx3oe1HHghQ8xJeF9o7K3ghfNBzj8O/VRwnZNm2eQYc7TCPmc+fJG5xaKQX1FkAnGzXA9Q5+LhbmXIfshF0giGZZHgs6GRitEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 18:02:26 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 18:02:26 +0000
Date: Fri, 25 Sep 2026 11:02:24 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is
 the only resource
Message-ID: <ara3MJ50n2y63dYm@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-16-tony.luck@intel.com>
 <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
 <arW6xlQWVWkixiWe@agluck-desk3>
 <110d2c7f-8354-4d25-aff8-cd5ceb46334b@intel.com>
 <araYQUCPvnBH_Qlj@agluck-desk3>
 <dc052810-8e63-4bf0-8056-59ce869b3d52@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc052810-8e63-4bf0-8056-59ce869b3d52@intel.com>
X-ClientProxiedBy: SJ2P221CA0011.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:a03:5db::7) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: d81dcc47-1b8c-4271-2c6a-08df1b2f27f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|56012099006|11063799006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: TGdPnYw0rGze6FRVmTVuoyjnjlMK5cSsJTTbzbAJY0sB+iSKxmjFMZ8c3imH9drL6NKYP3dqOpeiNn+MNq+cQ7QZvProX8v1RfixIQe+glua2w/eejMFW/5X3zsS3/9pXlArdhUbUPoJbhctJzDQAQ/u13LWLRD+5ckhOk0SrOTM9XUcrD+ykkyKzvnPDqkmLv3f6BUAZh7+3qMrZ+azMnIYw4Sp6aX7WHquivgG2ZC92jDIayhbV2vZwsRrmhn22JqaNo/FCufbOuE1l0dlLOehZ8ELpfYcPry3If5CCuhmv6y61h8iRBkOeR9GWoqWa3YLa8d3StApF3QXL5pcUEZnhCFboRcswwheUcy/gf+uW/kLknKTkNj5iab3X9T6vMrO2M/hYWQKe87s4pCr9g0+ooXmK1cJZIOTGavCXEmm+SpN3jxSQstH346QBX1pBjFRtHWfsp4OtsQBwf0nJZoPXiojadSPW4OladewfzWzItGZl72MxAWO2WqVXlWwxn67IyqFpqzxz170W6nb7aV3FWXUTq/6zJ7rM6HChhIiMPOsPGLdGr+b2MNp2rLI1uA63AjMMMrhldD1+BbrH1uhv9/wZA1H+iJ5ze1PoXgEWAcToARXQeUVwbVQ6dyf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/SFz2ysrv68+2dfvAvdnnzvyuedVV/Kc7QwXirFmA5E5mGQ9SFT4ZHTzV0?=
 =?iso-8859-1?Q?w4+Sp6DC/SIyZ6RNgJqsfDLttKnImTrklzPJt+uIXluP4H3rXyZT7poQFY?=
 =?iso-8859-1?Q?/o1XhUpLCvOumPTdCWlbOkic87p9PRqnHxludpLtkb2fnuFWVywRigGSon?=
 =?iso-8859-1?Q?qMzORc6Tvuhq045s6ZHrYghv/GgYVKl1/Q+QHdNH1Slia8nD/2RuzH+VqJ?=
 =?iso-8859-1?Q?03Jc4MnTN1zfLvoCgxGG2NL7OcEcExEoktU+LSUViajzcJgokfxzKr+PA4?=
 =?iso-8859-1?Q?kryPA7AMdXYN9rt3M7ezu4YnXqirHByanxAN9Xv6eX4wV/b5bGzakXuBJa?=
 =?iso-8859-1?Q?uu7AICBNpzvLPZJcmtMgQ5YokBcjhMf+IAnrMa8NdkYRTB4zbGNfTaW7e/?=
 =?iso-8859-1?Q?3xRFdkyLqfy0CMWllTGmYgjA3iiHmhJi97xEIvWXe84sL0h6hzzL0amRxE?=
 =?iso-8859-1?Q?eDceT9k6y0aE3KyAsdUZ3uESBVLMby6n9JVV83z83H6hYS/KWNbdBPykuG?=
 =?iso-8859-1?Q?gtiVMQRiihLkfYJOwT0Bknr1fHybEMyB53y7JGsFeicIaj+aDKGU4QoDoR?=
 =?iso-8859-1?Q?gXob4d1A3CDVr+i1bZqU8ixgOHqXrCd4W4pVRJL+ubsCMQiqoNwrd0mb6n?=
 =?iso-8859-1?Q?MDUb6C7poivWt+aJMJrta5EpoxavhYvPZUnt/rogiDoaJm7+byRhEWHfHq?=
 =?iso-8859-1?Q?hLW5uYiYVq7YWRVuxub/qJJIrU5o+KCzKsLU9ftThj6faLVnzsJkD34XJP?=
 =?iso-8859-1?Q?Uy8zucyJzx8S103P0V0zdsvytbRwu0E4bSYt5K5gOLUxRT2RP2vZIraFek?=
 =?iso-8859-1?Q?mI70Z0wHRHmQ7bhBot9astTiZ5+cbqZrhH//8ptPi44LfQwyv4C4m9T8Wp?=
 =?iso-8859-1?Q?alVs5F4gpCWHA40XAZ8TUArDXnj7Dv3pWSa270Obmi96CH5Fjvx7ezTu6j?=
 =?iso-8859-1?Q?6luvHIuOSvTp78DIREb8XqUpDKG6JyhANenBB0c4O66VR6r2vmYuTpOu2l?=
 =?iso-8859-1?Q?ELbiSjWjpFzhNn9NseyEuoeMn8IuLA95VbMZE9R6FUOwJIlchQMe5LQSfW?=
 =?iso-8859-1?Q?ZHYklHmBerPEecvW1cvAwGctg5nfTikrr0JWxWu5+6NqSu+MafSYuU7/ma?=
 =?iso-8859-1?Q?ssLP7H1zP8SiD5X/4Qa7uBnUQf2EGmhOtIYg7ditWk9wn+92kypsEL1/xk?=
 =?iso-8859-1?Q?J76ux0f/wNoxD4YRR+HzcxFEF4r4xzaRF+14mwdC5lcJhX8RaRPD+Gs+Xs?=
 =?iso-8859-1?Q?YLyoKiJplRYddDwbpzOhczNpJaj9q9AuwnQEXl5aJPXfaThmIhF5aVuEGM?=
 =?iso-8859-1?Q?akl2d0qYTb++I1xS6f7eJ71WQphZU0iNBjltcKkhQ9jP+VIbWnjTOBGJd5?=
 =?iso-8859-1?Q?lFQ4IDBhGfteYHtupDEj6MvUw05SRLz6gE5OfDWj8OUWd2cx66qwXlJYl0?=
 =?iso-8859-1?Q?05MC6L6xFWZ86/FrOZRtY9yfFlEQU9s+avqRkOYlYUnovXsJvlCf2fn+Y+?=
 =?iso-8859-1?Q?/95MC+nJJivtHCPm1ayqpROM9rvP2CQ3/aBRPzIpNX+snsrfVHneGwQAcT?=
 =?iso-8859-1?Q?lkKUEIo5ntKk1Qp+aKjiJaHa8XBpnjZLeFMNP0OEpKrn7rWLnVVjESH39h?=
 =?iso-8859-1?Q?DB8IW2Z7ac2lxdJQnF2GLS7dTwnxUkf82dEPIKAQ38FSAVMSnGFy/YYXp2?=
 =?iso-8859-1?Q?fZU9IMOmyXqdLdoS04dCJ6eYRF/RhIYDVSitnJlA454HJ+P+qM/DDHYixH?=
 =?iso-8859-1?Q?a5WMjD1+VvA+1F3LLrtJ5s9eZhvSHK+gphnzgc5G+Bh2E8sTTdB9AN5n4Q?=
 =?iso-8859-1?Q?nu4vWdyu1A=3D=3D?=
X-Exchange-RoutingPolicyChecked: 2+XH02hiJKGmKfXPX6jPIMnM/dLqp5UA8XHOR+Yok3rbm9PkyUBBZjmBkOl1XNDC3z3OBXedf/VXj0GN41fEhulqmUJc8pXJNBPYGhiia3VTMrBxHJFQeNnIFOrjiRFRZpD2XBh5l6ujpOAxmWr6ECj3jnZi5OSVfyA5YGXhuxNpzDehENhQ9Em4Mn6FBifeyb0yu2c6uGOttHkAGxuKa293GhBkIMztUGFFQ3tA4rkv/cVKjdb0Y5kTzrZcijIpwc+s9nOv6XUpeSyNgMDXHxai4jzsGqcIiogZykusmAm6Um6DUJ3OmhK1hDWIut+STPAkkycZ6Nk7PH1O89AKUw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d81dcc47-1b8c-4271-2c6a-08df1b2f27f7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 18:02:25.9528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34gXxGMzTv+0OlpLcJ58hIY5PXLlNExM12vI1WEL5zGyxGioJKVsg4/0AbOCKaKQSUsSHCvDQkvaL74MPSxzgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6771
X-OriginatorOrg: intel.com

Hi Reinette,

On Fri, Sep 25, 2026 at 09:39:13AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/26 8:50 AM, Luck, Tony wrote:
> > On Fri, Sep 25, 2026 at 07:37:20AM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 9/24/26 5:06 PM, Luck, Tony wrote:
> >>> On Thu, Sep 24, 2026 at 01:41:48PM -0700, Reinette Chatre wrote:
> >>>> On 9/16/26 4:13 PM, Tony Luck wrote:
> >>
> >>>>> @@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
> >>>>>  
> >>>>>  	/* Any of the L3 monitoring features? */
> >>>>>  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> >>>>> -		return false;
> >>>>> +		goto skip_l3_feature_checks;
> >>>>
> >>>> This goto looks unnecessary. Why not just "return true"? Even so, this 
> >>>> also changes behavior from the previous version in a way that is not clear
> >>>> to me. I was expecting this to consider the number of RMIDs supported by the system,
> >>>> now that this function added:
> >>>>
> >>>> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> >>>>
> >>>> Should this be:
> >>>>
> >>>> 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> >>>> 		return pqr_assoc_num_rmid > 1;
> >>>>
> >>>> Although ... looking at this closer it does look strange for pqr_assoc_num_rmid
> >>>> to be 1, thus reflecting that the system supports one RMID, when zero may be more
> >>>> accurate?
> >>>
> >>> If X86_FEATURE_CQM_LLC is set, then monitoring is supported and the system
> >>> must support at least one RMID. I don't see a need to insist on more than one
> >>> RMID as a precondition for using resctrl. It wouldn't be super interesting
> >>
> >> My suggestion was not to use "more than one RMID as a precondition". By copying the
> >> relevant code not shown in the hunk
> >>
> >> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> >>
> >> I aimed to highlight that if the system returns zero then pqr_assoc_num_rmid
> >> will contain 1. The "pqr_assoc_num_rmid > 1" is thus not a check for "more
> >> than one RMID" but instead a check that the system did not return zero.
> > 
> > Architecturally the cpuid_ebx(0xf) can legally return 0 meaning that the
> > system supports one RMID. Here's the description from SDM Volume 1 Table
> > 21-38 "Leaf 0FH.00H Intel® Resource Director Technology (Intel® RDT) Monitoring":
> > 
> > 	Register	Field Name	Description
> > 	EBX[31:0]	MAX_RMID	Maximum range (zero-based) of RMID within
> > 					this physical processor of all types.
> > 
> > This code path is only executed if the test for X86_FEATURE_CQM
> > succeeded. That should guarantee that leaf 0xF exists[1]. There's
> > no way for leaf 0xF to indicate zero RMIDs because the MAX_RMID
> > field gives a zero-based result.
> > 
> > So a test for "pqr_assoc_num_rmid > 1" really is checking that two or
> > more RMIDs are supported.
> > 
> > If you want resctrl to refuse to support a crazy system with only one
> > RMID, then the check should as soon as pqr_assoc_num_rmid is set:
> > 
> > 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> > 
> > 	/* Systems with only one RMID can't usefully support resctrl */
> > 	if (pqr_assoc_num_rmid == 1)
> > 		return false;
> 
> Up to you. I already highlighted in
> 
> 	https://lore.kernel.org/lkml/39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com/
> 
> that my goal is simply to align this version to the previous 
> 
> 	https://lore.kernel.org/lkml/20260831174421.13921-14-tony.luck@intel.com/
> 
> that used 
> 
> 	return resctrl_arch_system_max_rmid_idx() > 0
> 
> to determine if AET can supported.
> 
> Ignoring this simple question in
> 
> 	https://lore.kernel.org/lkml/arW6xlQWVWkixiWe@agluck-desk3/
> 
> you instead use the SDM to argue against me for some reason.

My apologies. I should have included in the version change log from v11
to v12 that I replaced "resctrl_arch_system_max_rmid_idx() > 0" because
it is the wrong thing to do.

I'll try to be more complete in the change logs.

-Tony
