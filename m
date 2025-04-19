Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ADF78C9C
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 05:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745039682; cv=fail; b=kETF4UlqkXPP9pE0Bo+F7wcq8vpMjLKVVw9Y33Ll290aeworheQCUqbT194K8AyeWxH6PtIhzkGoaKv+CAj2I6H0fI3PwvjCIMLT8WngEAKRsIJUYVyCxH/eVDp0CljqAI+yx0ui8gJrUHrVljIzYLsbtT1IE9rSW4hzyn6UQX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745039682; c=relaxed/simple;
	bh=fY+6cYDrOGt1EoXi2VRUIzoMQVYoNvIYSJUb8gUDuAg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M0Wea7ucMRMDrbAhiF3qpV01/VuWhN0FoA+r3aQmztUeiSrHYpckdVFkEv6Xjn+x2m5pgusNQUxH3nCk0lSOIIa6RTp9sAvuE4bifH4Tzs6jQzJsfg4VvPsCHYS3tw9sMvMMjXse0ZJbw08YurefXgNzDVtdp2v5wqyrlb9NZiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TIzpQndM; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TIzpQndM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745039680; x=1776575680;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fY+6cYDrOGt1EoXi2VRUIzoMQVYoNvIYSJUb8gUDuAg=;
  b=TIzpQndMkgz446mv9S4tY+2b/yFF87puPlvuLC6Aey4psN4bvV5pGf2W
   tJoOoE2s3QY5ROvNpapdn7Wnh6cezSJg9aqNHD0WJGpsmOaAgQ5neU8AE
   ClbF+e3d2fqEFVj1/IcXXWUwXk9Zm83p7fp/udslCXxLU/e9Z4ktkk4Cy
   V6IapCzl3pIBgdVOfDBOOvV/nDPOvz3d4DzHMIcVyIL9IQDLKJ/Ne9jvM
   TzEXySPOsPVxjNjdW7YbGu3301BbcMbI7w/Fn0xqVX6ekIaxDwrVIoUI2
   oHnUUvXp70jdnlq6JLrsgmnEm8f//u6T6/Qfjs8X7Avs84oEfVesQDvG8
   w==;
X-CSE-ConnectionGUID: 80f2bFYfRPqjNQchcfIDbw==
X-CSE-MsgGUID: WxQeMO9xRYysvaCA8NnXHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="64198231"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="64198231"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:14:39 -0700
X-CSE-ConnectionGUID: AAwKokBwRIGYjdcAnUerKQ==
X-CSE-MsgGUID: pbvXCnnvQq2ThKZxAy4Wxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="162230793"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:14:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 22:14:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 22:14:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 22:14:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2bEg/VFGFPu9O2D1leEfgQiHMF0ghvOBUbFgbQxZIlJCQMpOOU1iP+ZoNak9JigFS0biGxnLkNt6y4HYbLo35LSXr3zRnNIdM6Jcy0yTbKUvHKArhmEQDbx9Qbl5utKFtnCxoWMhzMCwsuaRI8LUGUtRQEti6f+p4bkd14hC+NwVqxtHIhsEVRdtJIM19eUKoqawfWB9RT/qJrzftzTA1ZrZr5xwuG2gGY/e04LlsxE0JQEmUkoauOlVxifXtXUWpv6jPl2V3oUOoscXXFWiQri7glXNktiisYZtxjIMcJDL6awbwkYrCrfunYdjTTrCnFjvROFPgNYKBJ9YRcUgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQVmvwKVB2gbSa00YP/w1b+n0Utb1bAOkH2Ftn+kWV8=;
 b=Zc5lFw8lMtB9ujfe51WOz9blQ0DE67CToUstjTGCQn+e6Y3FevJiWnr8H0ykSErIdYfvGI0qbk39HqBu4/9Pkg314dkf2iWrqRT/R0SizpNoKwyAEi8UIiwojSYHPSRuFyFTvCSNyO11MfKlqMQ6i6VpF8Sq/ZR5Ip7GYH0noaj8wOgMduBWVHQbuJn48JZkk0lIZPOSOa4u+3kHhSp6FvB9KlYyI797QuWJDhBLXyYkOO7fqfqNZjKMkyVzGlQq7eh/BGuqqMUQ7K1kOKiBBTTiz/ymi3usy3XXAejKE6Qa9WCZ5HcW6glSceqq5DoTZdNGduC6i3HrBhOWI/34kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Sat, 19 Apr
 2025 05:14:35 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 05:14:34 +0000
Message-ID: <fba9db1e-4840-432e-87ff-12819381ff41@intel.com>
Date: Fri, 18 Apr 2025 22:14:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/26] x86/resctrl: Sanity check telemetry RMID values
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-20-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250407234032.241215-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:303:8e::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: b94eb918-d612-443a-69a9-08dd7f0112eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NWd3dVF6c0JKcTlXejVjbnR2UG1rbExoMjhNeGphZnlwSWlRMzVZYU12WGNP?=
 =?utf-8?B?czIvZlFNczBIU0c2WklrNVZYV2w5aTVFSUpYakV3ZFBiK1BrTmtidjVHa2VQ?=
 =?utf-8?B?anpCdDVjZ0ZwY014VGFUK2c5NHB1WVhNZlVxMFB1YjZES1dPVGtXcWZWTkQz?=
 =?utf-8?B?WGFhbnQ0V1QveTZVaVEzb2ppak91SGVkdWJSZGdpR0p6bW1aeHJHMndOd1JV?=
 =?utf-8?B?QUJVbkM4c2Z3NC92UlRIZEZ4TERXYTJHcmtKQzRpVHlPVHlOSDlTTWQzajBx?=
 =?utf-8?B?ajJJM21FRVBqMDBobDQ5TnkzYVdaUEJJb3J5U29ob2dGd1JjWjJpZWlVSWdI?=
 =?utf-8?B?S25HVHBlWUNTRERzMWpNNE9QdmhLL2loeisxenlZUTRDazhsNDEwRGdINmht?=
 =?utf-8?B?VlpZS1pUbk4wYVJBWHBzUmc5Q1hNTWUyMHlIZzg3WkFZcmxCOGdvbWVoU1Jm?=
 =?utf-8?B?Nk0xZDJQVXRZb0ZOOExWWGgrZ1IwYWU0SklVVDB5QXd1K3VRMW56ZGQwYUxr?=
 =?utf-8?B?MDZvdm5zVHhjYjloZVJTK0hWeGwyMEdXQVJNM28vZXFHdjFNMG9uVnRzc1FU?=
 =?utf-8?B?cHpFcU52Z0xZTGFxbE9GRkNwMnVLSmNPWXM4c3JoQ2dYS3dud3JFOG1HZTBo?=
 =?utf-8?B?ZjF4SFVuY21MRjUxWGhLdUlLc3EvaWd0ZUNsSWd6L1Y5Q2JCckFqTWROaVdk?=
 =?utf-8?B?TzhBSG9SM1hmaVA1Y0VvRzVMMWtENFVSRUZHNW5HaklncmMzR3g2MTdEYkdN?=
 =?utf-8?B?TThCV3hVQ3ZrUXpKSmlIeTVqNmxkRmtqaStuUVMvMDBNeGhaMnliSTlBWGNC?=
 =?utf-8?B?T0FMcDVkTml6YWhCb2JZUFpVSVRGSUhVeG1PUHFVNS9pdjdCRnFPakRSMlpx?=
 =?utf-8?B?b2NoNnhvMHhZdTlCdHIwdWJnazhSUUhFNEdKdGRDNk9SZDVoU2VFQm9EUmd4?=
 =?utf-8?B?LzVOeFlDMkFPN01xNjF2SkNUYXBFNVRyeDI1SDdTUVdSRjIxamR3U2NoSGRU?=
 =?utf-8?B?K0ZINnRYbmtTS0J1VEhlMFMybU5CWlBqdmFaaGhLNWNPVWd3NlBESmNyMGpo?=
 =?utf-8?B?aU44ODdzS0NzQ0ZQK3dvZTJ3K2s0cnVPTkpaSXNvUUI2ZDRUOFEyS0dxSS9Y?=
 =?utf-8?B?bG9UOXlEcGNpN3M1cFhYNWpoeFNDK1hYeUtEYXAvWjFGTVlrdjlZZEt0NWZk?=
 =?utf-8?B?dmVzYnN5VG9VQ3pFYlNXYmVjbktENk1nTWFGaVdGTld6UnVWc0M0MTc4Q29V?=
 =?utf-8?B?WlgrcWxLUmpaTVR4eE9xQk5EZ1VFYWxzbHkwbjFOOW91eHNOdGRLc0hVTldB?=
 =?utf-8?B?RTllUmNKSmozd2huOWZoY0RucmV4TjF4TnlWL3V3UlNNcjZxcGIyRm9jSXZ5?=
 =?utf-8?B?Z3hJNWgrY3ZCMEp0RytOS052MkpzbmtjVXpzd1NVQ1Zwblh3YmdZRlphSTVN?=
 =?utf-8?B?czZjZnBaMkVxUE9BcHhnVGl6bFVPMXpDUXBDWXVSS2VwY1Azbm4xWHpOWUdn?=
 =?utf-8?B?MDBDWFFwKytaL2dDUGFPWmNINGVKNWljRW1JSFFib1ZlYS80aGcwRStuN3Fq?=
 =?utf-8?B?MFJnU3d1U2I2MU5GZUhXNjcvY2xMYWJ3Nk1JUlhleVkxME01dlBFNXdLV0g4?=
 =?utf-8?B?R0VWK3lRUlBTRlBLUHNUUGRHa055bjNBTXlzK2xtSlIvYU1mM3FKaEE5cU1m?=
 =?utf-8?B?bnlQVUYwWFJiT0pmNE96dU9GRkVaWlZtbEJDMnZGb2NoaFVPU1hrOE0xRUxE?=
 =?utf-8?B?cUwwSHFwYnRncEdmT0p5b1ZOV3FGYkRRRlY3UkZ2d2tiZjdKKzNkVlA3UGdq?=
 =?utf-8?B?QnRhTG02OHZxNGw3RmY0NzdiYW1Nb1FIWEVWOWo2WGtpQVowUTdsUGxrajVW?=
 =?utf-8?B?bm1PbFYxblV4MktydjJxQURGU1o0ZU9qSVVUQ3dXYUNqdWtwZkxKRGl6ZW1M?=
 =?utf-8?Q?B7CpneHf4JY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkVnejZFMFR4cnR5WVgxVGtURnhCQXR2eG0rU0RmRTlmNjdNK1RTcjBkV2VT?=
 =?utf-8?B?K3dDMHBXa3VOd29MMlJhblJKT3VjNzF2T2ptZEVmRG4vVy9OaVlLNjlGMUl1?=
 =?utf-8?B?N3Q5MGNQdE8yVGhxaXBmZmpHSTJiajJVMWRCSzZqaTYyTDNJWmJhY2xrSFZm?=
 =?utf-8?B?NHd5aW5NYlFmVng4TTZDTFVDeTFncUhlVkVScTRKNEtUbyszeEFSNGgwZ3pT?=
 =?utf-8?B?eTJDL1JDL2U1dytzSFEyRk9TUU9Oc3BFV0cvMlBKa2VaRHdScnlYbG0xSGk3?=
 =?utf-8?B?SFBtTHRQYzVwOXpBNXN5dGZpZ0NyNzA2ejRmM2t5bDB3b21lblFIdE8ybm90?=
 =?utf-8?B?SFJ3dFpLRXdhbjZjWjBsTmNKajhtSlIxcHB1TjZLamJxT3NiNWM2WWxmdnFQ?=
 =?utf-8?B?OHhwQm96bllzSkRWbG5pVms3WkxvdXFkVTZZZ2dyNjdMc0tmOHlPdVJpQ1dQ?=
 =?utf-8?B?TGZuMGFTcEo1SWkrbVMwMFVOTStGRmZTdXpjRk1kaDlLVlpudEh5RzJURU1a?=
 =?utf-8?B?bm9nckhUMXF2eXpGQmRwRnN1ZFhpcUF5WWFmOC80UFMwZlpOeFBZWUgrcFkw?=
 =?utf-8?B?elRoaVUxYkJVQVBMUG9YV0FDbHJabnV5Umg4WWJLSFFwSHFxWS9zajRWL0cx?=
 =?utf-8?B?TVhJdkpIMzNKc3A4K3cwa1d2U1VQM0NnS1F5K1lvKzY1VHkyMTVxNUZtemFy?=
 =?utf-8?B?SlRvVVR2MXcxK1kwcHFvNUhTY1JGR3ZGdlpXTmtOckpYcEUrSFlQdkNPYmdn?=
 =?utf-8?B?NHJGQy9aczBxM29hMC9uWXZkT3l4NlN5MVhuclF6K0dWS2tvakVSSUN0dGli?=
 =?utf-8?B?aURmN0RkUFZZcisyWG9naFZrWU9WTXgzMlpwUzc2M1ViODNwa0FzbnV6YzlL?=
 =?utf-8?B?NEIvYnBGYk5LVzFjVitoaWRteHBpWDB5N0tUV2JaMEtJejFkLzkza2ZkeUsy?=
 =?utf-8?B?TFJEanVvK2U0S2FVZFIyaHNockxyMEx1cGt4VTJLM2NjSU9FYm03eDZySW1j?=
 =?utf-8?B?RWplUXpVUlM5d0NFVlJRZEw4bzZpUXkvNGw0WHdrQjFiVzcvejZ2SEVtdmVK?=
 =?utf-8?B?OUJBK2lteno3SitXQzhZaWpoa0dGWlMvUWk4d0xzSnprK3lTdm9DSHdYaVRM?=
 =?utf-8?B?MFByUkRrZ1B1ZjYxazF2WGdzN1djSTBlOTZySzNnSktHUTNOSm1SSjNWM1Zz?=
 =?utf-8?B?WXREYUFvMitjMjV4QW42Q3UwcW5ibHBIZGU1OTl4TTFRQm92V1lWUlB2MG1Z?=
 =?utf-8?B?M0IxWmlVOHZwNWpSd0JORHl6ZmdUUlNScE9qYm1JTkFNbnRvSUJqckM1S1ds?=
 =?utf-8?B?enIweVpKY2loWGFPZ09yTDJUckN1QkRuSUpGeFVtbGQ4eDZHNE9aalVJa3RX?=
 =?utf-8?B?clczQ0xzeW4xNm4wS1pncW91aEdhMm9oZEwyWmpVU3NvUjZGU0hMWmwwRTli?=
 =?utf-8?B?d3JkbEpuUTczN1oxZWhHRnl1UXlqZHZPN2U5T0lnNUJpakUxKzBvamZ3Rkd4?=
 =?utf-8?B?V2FPN2tFdUx4dlI0SGhLU0tKc1hiK0ZUSklnVVBrZmpRU2dUeHc0K0ZjYWI1?=
 =?utf-8?B?QUVQdW04N3F3cXRtYnd4bmdVWWg2bzNlSWNhNDZST01LWUY2Wkt4b0F6Wkt3?=
 =?utf-8?B?bVRCbm43RmJOd1g3cHJDUk1iOW8yUXJ4WmRxV0Fsa3lrVVlJSFZoMlRZcnpR?=
 =?utf-8?B?THRBc0VQVkJleWdTWFZVTTF5RTlZNHh5NmlQTStxMHYzRnBvdkt0a3g5SUdz?=
 =?utf-8?B?dXNFV0d5bXc1TU1FS2I1TTNIbWFpNW5VbHFGa3FKUTFRdXZnZWpuc216Vnlo?=
 =?utf-8?B?QzUzZjZIYk1qVEcvMTlEbnhuYTltRGxOSXM4R2lISTgraW9LcllhVjlSVlZh?=
 =?utf-8?B?OWRaV1ZnbmFuaHArOGs1T2JnQmd3SFpDcDVJVlcxclRaakRnNFNYZVlGdFRD?=
 =?utf-8?B?eXFKTEdGcGNDTFJxY2tsRi9tRkxVV0FIanhsZWNBS21hUGNwWjU1S0dWNHRt?=
 =?utf-8?B?WFhoYkx0d0xJZFo5VW13MGhPRnhUenN4dEhtNnk4eWs3Wm9YVEE2U0MzMmZD?=
 =?utf-8?B?Z3NzKzN4VStKSjRnUUZCTWFQNlpYZE5Ha1I5dTdLSEE3R2xjM0tRa2hvSzBw?=
 =?utf-8?B?QWZDdDU3ZUU1cUoxU25VK3ZyTjlab1d1U0s4QkFncE1tMTNxU0RreCtSL2tV?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b94eb918-d612-443a-69a9-08dd7f0112eb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 05:14:34.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMGC9Z4o0EJTrw/WKje2P7NHktePfMo8qsV9BufCGB9/Tmzg7Asd49vj8USvyT3xzk9St88ShNO8HHMONhxBerE6OeWzA4qTzCv950EzsR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> There are three values of interest:
> 1) The number of RMIDs supported by the CPU core. This is enumerated by
>    CPUID leaf 0xF. Linux saves the value in boot_cpu_data.x86_cache_max_rmid.
> 2) The number of counter registers in each telemetry region. This is
>    described in the XML file for the region. Linux hard codes it into
>    the struct telem_entry..num_rmids field.

Syntax telem_entry::num_rmids can be used for a member.

> 3) The maximum number of RMIDs that can be tracked simultaneously for
>    a telemetry region. This is provided in the structures received from
>    the intel_pmt_get_regions_by_feature() calls.

Is (2) and (3) not required to be the same? If not, how does resctrl know
which counter/RMID is being tracked?

> 
> Print appropriate warnings if these values do not match.

As mentioned in cover letter I do not think that just printing a warning
is sufficient. It really becomes a trial-and-error guessing game for user
space to know which monitor group supports telemetry events.

> 
> TODO: Need a better UI. The number of implemented counters can be
> different per telemetry region.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 31 +++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 67a1245858dc..0bcbac326bee 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/cleanup.h>
> +#include <linux/minmax.h>

Please sort includes alphabetically.

>  #include "fake_intel_aet_features.h"
>  #include <linux/intel_vsec.h>
>  #include <linux/resctrl.h>
> @@ -51,6 +52,7 @@ struct pmt_event {
>   * @last_overflow_tstamp_off:	Offset of overflow timestamp
>   * @last_update_tstamp_off:	Offset of last update timestamp
>   * @active:			Marks this group as active on this system
> + * @rmid_warned:		Set to stop multiple rmid sanity warnings

rmid -> RMID. 

I find the description unclear on how to interact with this member. How about
something like:
	True if user space have been warned about number of RMIDs used by
	different resources not matching.

>   * @num_events:			Size of @evts array
>   * @evts:			Telemetry events in this group
>   */
> @@ -63,6 +65,7 @@ struct telem_entry {
>  	int	last_overflow_tstamp_off;
>  	int	last_update_tstamp_off;
>  	bool	active;
> +	bool	rmid_warned;
>  	int	num_events;
>  	struct pmt_event evts[];
>  };
> @@ -84,6 +87,33 @@ static struct telem_entry *telem_entry[] = {
>  	NULL
>  };
>  
> +static void rmid_sanity_check(struct telemetry_region *tr, struct telem_entry *tentry)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	int system_rmids = boot_cpu_data.x86_cache_max_rmid + 1;

It is not clear what "system_rmids" should represent here. Is it, as changelog states,
maximum supported by CPU core, or is it maximum supported by L3 resource, which is the
maximum number of monitor groups that can be created.

We see in rdt_get_mon_l3_config() that:
	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;

This makes me wonder how this feature behaves on SNC systems?

> +
> +	if (tentry->rmid_warned)
> +		return;
> +
> +	if (tentry->num_rmids != system_rmids) {
> +		pr_info("Telemetry region %s has %d RMIDs system supports %d\n",

Is pr_info() intended to be pr_warn()?
The message self could do with a comma?

> +			tentry->name, tentry->num_rmids, system_rmids);
> +		tentry->rmid_warned = true;
> +	}

Could you please add comments about consequences of when this is encountered?

> +
> +	if (tr->num_rmids < tentry->num_rmids) {
> +		pr_info("Telemetry region %s only supports %d simultaneous RMIDS\n",
> +			tentry->name, tr->num_rmids);
> +		tentry->rmid_warned = true;
> +	}

I am still trying to get used to all the data structures. From what I can tell, the
offset of counter is obtained from struct telem_entry. If struct telem_entry thus
thinks there are more RMIDs than what the region supports, would this not cause
memory reads to exceed what region supports?

Could you please add comments about consequences of when this is encountered?

> +
> +	/* info/PKG_PERF_MON/num_rmids reports number of guaranteed counters */
> +	if (!r->num_rmid)
> +		r->num_rmid = tr->num_rmids;
> +	else
> +		r->num_rmid = min((u32)r->num_rmid, tr->num_rmids);
> +}

As I mentioned in response to previous version it may be possible to move
resctrl_mon_resource_init() to rdt_get_tree() to be done after these RMID
counts are discovered. When doing so it is possible to size the available
RMIDs used on system to be supported by all resources.

> +
>  /*
>   * Scan a feature group looking for guids recognized
>   * and update the per-package counts of known groups.
> @@ -109,6 +139,7 @@ static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_
>  					pr_warn_once("MMIO region for guid 0x%x too small\n", tr->guid);
>  					continue;
>  				}
> +				rmid_sanity_check(tr, *tentry);
>  				found = true;
>  				(*tentry)->active = true;
>  				pkg[tr->plat_info.package_id].count++;

Reinette
