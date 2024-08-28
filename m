Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE62F187FF6
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856334; cv=fail; b=ALIOEkquizcXfG6d9OV0NPq/vnravdxryRQShbIt0nezJU0LVQqBkRL7/VPf3ALsQSu3WoGcT72iWlfpJuGRGDb1OHkaY2NMU5qLshp+ehjJcgL9wQsC83WdpHRBL94Vi6TXxa2fB5N+8fsZm4BQL2TRClHEFCxj7pc751JCO3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856334; c=relaxed/simple;
	bh=IxpxpRv3kaKRveguuw+0hrfv3wlzRFGndDhFOvUvZWA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lwd8JN1YsxQVkODjrIiZaFId2Se5PoVx2KmkS20fQo1pCtHpl2mv/Ka61MDK/HDsENHw0nQamFhRneM4qV6MJCrrcZFQdS9g1aTU2BE4ubFKGLuEfU4RuJeCx8tnuGNaDUxYiLv6CLRV3Ii24RJpM0FLTsAF6wJGy3prv0H22nM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jJajiAkx; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jJajiAkx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724856332; x=1756392332;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IxpxpRv3kaKRveguuw+0hrfv3wlzRFGndDhFOvUvZWA=;
  b=jJajiAkxm3B73tX0tZMhoOkDfEOC2GmCmf8j1ov1rWFOMZrpSsi4MJRL
   o7ctFs3JSiNtwJfCPmpwLyLQJfwmUL2juajDYbH70h61v/LbT6uI6bWz+
   DJR9fNtLeIPfjNGB8QrdtvjjbJYrU1QshzSarYm1NaK1uDsIIuW+bLmmK
   wrL0XE1vKipbVPpxG+RKcJ2L92Mv44gEhaoA6RaidH2qFCv2tLxpe5wDF
   JuPgKk3xoOGIo0nw1s48gxXys1txBb1QxnwAfF+BSjlsNzujSj5ukpz1s
   xFWEBQO4JAj45E8XQzrp+5ArL5ful5SJttbgriOm4f34pKj/NHsDeWyo9
   w==;
X-CSE-ConnectionGUID: 92mYZrp9Qk2WJuQVsUB3YA==
X-CSE-MsgGUID: AtcpTxPWScefHFeCnArtnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34770048"
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="34770048"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 07:45:32 -0700
X-CSE-ConnectionGUID: 7oTk3JyvTLeb0Wfbf3a3uQ==
X-CSE-MsgGUID: E6WMcjF8SkeWRe3vDASgBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="63951550"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 07:45:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 07:45:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 07:45:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 07:45:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 07:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPqYa7QPIJ8jkWCs7RTyeSDSNmmJVd9E6/Tc14JpVJXgTdIY4UT11YYLdgAR1V7nWLBM8wcYjw7NqVinlkr+44PPbIUXko6s2OWg1rvBMGNzcuNGYUxFGraLhFSWKhrOwr+b5AjhT8wEOGowcM41gSTWhefYAVzF0vSvZvHrEIeMUWSn852Y0dTaC5IY/ne4oUxo39T+aI4kY+udnUBUEGLm+rJSLvXTEcSCu+ad7S4nQ1dSAL8F8EfzfkAAP+HQtB6+XP4AVnRHgSVHmJeoCT/5xYFUP99xkJplccKboYRTwkl+YajlZf3qpp61E46OyPUMko1DD9f0uh4zirbvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNlHhAF9fAaRR2bCwuJWjXmiBphdTOcVYRl1pF/P8lU=;
 b=jiemhwxwPGvfzXSoCzJymRXPBzVHYgk1NVLP1fAtaoSJovJns2MKVVspJ3G26Z0xllKoFNIIXww7tZ+LiN6A+V1DHsSf7GHEYzcBbASmOkaNClRpwImTAB8S4xKujrmnZoG9dmkTrddvTJ5SRdrYByrtrC/EkmfzMYLKbSO/h1/C1PuozZy1J5s6vGcSKZCwbuKCNtX6TRoBf0JBwnX8fEl5s1wvO8oExRMqiz1/avDjNNYkytFx3IJcIfsfOpH8nGaQfDaSv8vuPOzPl1AoD5SnQ0aINuv3URjIhfIwJL2oh59Lla8cVGy2dcA14BHD8Qhco9O2Knkgq7f+9m2L9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Wed, 28 Aug
 2024 14:45:28 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808%5]) with mapi id 15.20.7875.019; Wed, 28 Aug 2024
 14:45:28 +0000
Message-ID: <a1d51ba9-a76b-4356-ad1f-6554b3253e07@intel.com>
Date: Wed, 28 Aug 2024 16:45:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
To: Wang Yugui <wangyugui@e16-tech.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>, <broonie@kernel.org>
References: <20240827143843.399359062@linuxfoundation.org>
 <20240828223526.7E07.409509F4@e16-tech.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
Content-Language: en-US
In-Reply-To: <20240828223526.7E07.409509F4@e16-tech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0093.eurprd04.prod.outlook.com
 (2603:10a6:803:64::28) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|CY8PR11MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e6a54fa-ac42-4429-1a3e-08dcc7700ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K2tPalBkTnB4M2p1RDlMTmpOK2Z4YkxHZmlJUGw2OWlQbUhiVU9LOS9QNTFH?=
 =?utf-8?B?QjVNKzFpanJKcmhDcXBsLzIxN2dzRWtNbGdBZ1BvS2grTE52aE1mTEZ6YXBK?=
 =?utf-8?B?OFBYc0Z0enBzZFFHUlNxdTc0R3RncjMrOUd1WDBJVHU4NzRNaGpUMEh4UUYv?=
 =?utf-8?B?R2VZZmhWb0dKUXJpUFBnOWVhVjY4YXh3RDNrS09nTUJSYVMzcDhlYXlOczcv?=
 =?utf-8?B?SEhuRVd2OWt4VE9DT1I0MWRIZEVzK2ZaSENBUTZFZFNDSVVQekpLVldJV2Zr?=
 =?utf-8?B?SkFhVVRPWURGd0xVN054UmlOZ2N5eHZNN1FrcjlZbGI0T0pVbmZFdHN0RkpU?=
 =?utf-8?B?WnM4b1VxUnJhZjFoZmZwOUlkTUdLcm5aZUxoamxEc1hYZm11Nm1VajAzMWdl?=
 =?utf-8?B?S2FXVmRrNVd5Sjd0cUdYT3VVRFNhQmdvRS9lTG81Ym1yT2Ridmt0MFZhV0ox?=
 =?utf-8?B?bkd5cUVDcnJPUS9KUXFqc1IveUErR1Q2MGd6bkFFTXJNTGdMRlVyRzRsZ0l5?=
 =?utf-8?B?NHlqVFdWWVNOWUM0WGM2VEZWZksyMDk3bU1oMW1yM2VoWVJDK0ROVmN5NDN3?=
 =?utf-8?B?SWFHNWVMcW1veHJiaEZ5YVdXcjBSSTZHYk1TdWY0M04xc2REU1NtZE5PbU5Z?=
 =?utf-8?B?ZmZKVjFyYWlTUy9FVzNGOUQ1bVdRTVdtNEpIczdXZXNPdTQ4RHVINWRIcEFX?=
 =?utf-8?B?RGV3Z2tueTNuWElOYlBmTHgrOStyVFN0NmhJbFJaVkZVc01QV1VSVGFydUov?=
 =?utf-8?B?alVxQ3hhK3E4U2NHZzlKT1ZpSWw3T09HQTRuaURvZXkwbDdiNnBhS2UrWStP?=
 =?utf-8?B?QXVtNGFpemJrVXVQdWhoeVVUbmlXZzA2RWlhVDBQVXUxSnFoY2FSYnExcm1x?=
 =?utf-8?B?TkY0YWxQb3hCTEozQUFFQ2JFdGJrc1dQa1hRWWFEbGl5Y3pGT2pnbVN5UmJu?=
 =?utf-8?B?SWlYZVNKK2FJTEt2T0V6TnV1dStSMW9sNVNXUzQ5YUxnakZnZi9YSjRXVmRi?=
 =?utf-8?B?L3Fva2p4aDR6ZW4rQjVqeXpIU0tCeG5qUkozUjBsNW5nMldpS0ZwTHJhcWpC?=
 =?utf-8?B?VUdEZDU3cVdVbHZvUHBrUzZWdE50T3RsMkt2b1YxbjBtblNDWi9SZzVISmw3?=
 =?utf-8?B?V2p1MkVxTWUwLzhNNS9SSU9HbDREU3ZrdWVFa0w0ajJsRHhsZUx2eWo5N3Z3?=
 =?utf-8?B?T2FJVVVvK3V4TEp3YXY3Z3k0R05DekZSYmtXVzllR2VtUk5ucmxZb3NyVnZa?=
 =?utf-8?B?Ry90Q1c0bWYzeUFtTHphZTZEaDlSdnczc3RiZm1FaXhJMEYwNzNkWUdocjJJ?=
 =?utf-8?B?UVBBN0JjTFg1YkFzZllvU1V2OENoc2pjUXlaVko2M2RMRkMwMjVmcy9Sald5?=
 =?utf-8?B?bk1ZRW1DWWIvNHJvOWk4YjVaaUhhVGdzTmE4QXhRWFdta2FHaTRtV0RIUmpE?=
 =?utf-8?B?KzBKV2tuM1Z1L2FZbnMvRUR3V0M2bDFIeDFkYXZxQ2REdFNld0RzUTNGaWNE?=
 =?utf-8?B?UXhpVGlVRUhsRENrNFJ4MHBXV0RiRVFSb2xUSjlJRWdvdFRRaTRaVUZxdlho?=
 =?utf-8?B?c0JBUWpqZS9XRGs2VHl1amt4Tm9jdWg0WC9mbGF1RGkxRUJhVlJia3hHWjBk?=
 =?utf-8?B?R3Y1Sk1GZjJGV09pN2Q1OXhSSjk1Z2JYY3A1U3B5WDBFVVBkcHhvTnk3Rnll?=
 =?utf-8?B?eXZSMDJVcllvUSszMnNuY1o1aHF3YWtIdlhiZVRSV1RPQmx5bFR5ZWhvYzhi?=
 =?utf-8?B?akZCZjNZN3FUQ1RmajJ1dU1TWjNhSjBBekdwUDhJdiswaExGU3FZeXFRWHVk?=
 =?utf-8?Q?kPKG7zwNG026dHPrJuS19KqIYAg5qfS2J5uLs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm93Y0FJWWpmTVh0OTh3U2UxVFFaOVczT2poTmNMU3dvQjdXSG8yck00b0Ey?=
 =?utf-8?B?NC9BeFJWYjNqWlZ6VkRSNWFjNWQyaVNNOUk5REVZUGJXcUc1RU1EdU5yZkZp?=
 =?utf-8?B?dGpUY1o0M0RyTmNENXp4WExmQytHRTRJT3JqRDlHcVJvMXZQOGdpVk5mTWRX?=
 =?utf-8?B?ZmRGVVpOSjBmWDZhdzhkamJjbDJFaThnWVc3U0ZTWExpWmVPRFRIMmJvQ0pJ?=
 =?utf-8?B?SnBYS3F3NTBxOFUvOUFuMDdXY29IdXVpRlhCb09QV2JLMFkyb3crbWszL3I2?=
 =?utf-8?B?MmMzekEwTytiQWgzTnZBTE4rc1VpdnVDd1pYbWVNYkVZRlUrbm9KU0ZQSXFK?=
 =?utf-8?B?RTlSRjBZZThlS3EwWDUvQ0p0NHlzT3owSisxNSszQjVuUW9LZmU3bU1IckRu?=
 =?utf-8?B?NER6ejFISUpWSStOVDVHdEJiaXRSbUszakMxamx3eWxNYkNOLzRobGF6aE9m?=
 =?utf-8?B?ZXZtWUFsZ1J0Lys4bGYwek93ZGZlZGdXQmVxM3NMNDBGS1RLUDdQcC9YUWpG?=
 =?utf-8?B?MDZTTFNWUCtrWk5Ha3NodHdSMm9qZlQ3S3gxdnNEcEV6U2wzRG9ya0c5NVNO?=
 =?utf-8?B?L21vMU5RUUlXVjhPYjdmeTdjcSt1cDR0eWRyc3lFK1lwdXlzVTZiSFBSa1Jj?=
 =?utf-8?B?bmI5Z3VmZUt2UUpEbzl0M2s3YXRmWU9XajEyRTdSVEhRZnk4L3c4bUZodCta?=
 =?utf-8?B?TUl6djNjTGNFVGEwTG15RDdGcGlPTThObUVvWUQzRUZqZ0VObzRRZE4wZnZN?=
 =?utf-8?B?d08wYWlIOSsvY1VSQU9QQ2dESGhVVTFyQVhuTWxJUE8vZlZYVThmZ2lTMGhi?=
 =?utf-8?B?Q2lMbm9XR2VMTUd0aXpmZnB1RStscjVuYTh1MmFmQm5ERFlyZWxLbzBGcFU3?=
 =?utf-8?B?RFdkWDhZUHh4SUVsUmdTMmZUVVBSWUFwbUM5cU1yS0tMenB1R3Vxd3o4VXVI?=
 =?utf-8?B?WEpSU1ZncmxLajdLVGkvdHF2TmVLNXhQVTZSQi9ZQjRPaUlOemhvZHZ0SjZl?=
 =?utf-8?B?b3ArTUcxYTZkcUxyaklMMEd3b1QrM3UvMnN0UzJYQmpoejVTcGlIdmp3MGEw?=
 =?utf-8?B?ODFDbnVPSDA2RXM0ckRZNmpYTGdiNTdqdHdOQi94N3Q2ZXpvdGowMGF5akd4?=
 =?utf-8?B?N09PLzJXaS9RM2Y3RkR0WTFSWko5Mk4wem83aUkzL0pKVU5KMkE2VEVHSTlO?=
 =?utf-8?B?eGdUNUR3WFNnNUt1d3B2RXZuNll6eGpQeUJYbVBOVVB2clNmR2JRcE9iRm5m?=
 =?utf-8?B?eWtOck9zQ3FIT2dOKy9XNjc1RVBmUGdnNW1tL0w2RHIxTUdYQ1UrdGdZaDFF?=
 =?utf-8?B?elRaVDljaGZQQlZCQ0kzSTFjOFo3eXl1ejlhM3VEZVIzdTRnaXhIeHJudHdu?=
 =?utf-8?B?WnprcmZKdFIrMzB2bVhKbjlJWW5ORnEvNmpLNVlzdVpYS21sTnJ5WUhTRDlW?=
 =?utf-8?B?ZUUzMFJlVGNRQjdYL3drUnlxRi8rUTdzMGJoall3VThORjBKckI3azBjSHdv?=
 =?utf-8?B?R2lKQmt1aklha2VUUGswSnZ3SldqcFJTWG5XNmVSbjBaWWJmbEZONTJIYUlX?=
 =?utf-8?B?UmhZN0I1MnBTamFiTE9reVRjSnB3RG0zeTRXd2tCV3RwNFVaUWtyMFVtTHRB?=
 =?utf-8?B?R0tKWHBvRzgxemlhZk1NZ3dNWUc4a29kT0MwdzAwM29YNmtub3ZseHlma0xm?=
 =?utf-8?B?aGRzeWJYakJ6SVljU3cwREtzRTduVjd3QlFvSVM1Ny9ZZVl2UWlkdWJXWldM?=
 =?utf-8?B?RG1qc1hMVGo1WDVXMXMycTdvWCtxZkxHQVJ2MW9za0MxWHhTZTBVQXFsM2ht?=
 =?utf-8?B?NDhRbHo4U3k2NVpMekRZSVRVdHFaTG8vSStXQ01ydDZMVEJnOUxUYlZFQ1hO?=
 =?utf-8?B?U3g2NjhkY2tZSUNJcTJ3ZHpDNTJDbDJ1T1VPSEN4RncrVSt6elJpMVA0c0Zx?=
 =?utf-8?B?YldpTHQ1dys5TDRIUHhBR0VoU0lGOGJ6WUMrb1ZvSnBReVRETDlvMFpxcG1T?=
 =?utf-8?B?N0cvUUZZSGNQRVV6UzhGdi9Ebld2dFB4VVl0MS9zMmxHUkRlTTU5Vnd2MUVl?=
 =?utf-8?B?Q1F5OHdwbERDMGpkaTdDYmhRZHljOHJHbXFuSU9iNlJnUmRzTlZDUUtqQ1Zh?=
 =?utf-8?B?SXBTMmRWQkRRTm5ob3NDWlZjSWFoM1dpQVRmQlI3SHA0UkdxZ0ZuUjF3K2lG?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e6a54fa-ac42-4429-1a3e-08dcc7700ecf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 14:45:28.1041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixPu0PXxMew0mvcPRkRhdR3RaOC8MIkDs1f8AGzQYN6yNxbpC5XcsC5TqyCvzCIiLIa9GA+W1A8wX2M96KZ9Tsks11ErBwuoI2zC/4JIkUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

From: Wang Yugui <wangyugui@e16-tech.com>
Date: Wed, 28 Aug 2024 22:35:27 +0800

> Hi,
> 
>> This is the start of the stable review cycle for the 6.6.48 release.
>> There are 341 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
> 
> We need a patch
> 	upsteam:  0a04ff09bcc39e0044190ffe9f00f998f13647c
> 	From: Alexander Lobakin <aleksander.lobakin@intel.com>
> 	Subject: tools: move alignment-related macros to new <linux/align.h>
> to fix the new build error.
> 	tools/include/linux/bitmap.h: In function 'bitmap_zero':
> 	tools/include/linux/bitmap.h:28:29: warning: implicit declaration of
> 	function 'ALIGN' [-Wimplicit-function-declaration]
>  #define bitmap_size(nbits) (ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)

Patch 29/341 and its dependencies 26-28 is an improvement, not a fix. Do
we need it in the LTS kernels? I'm fine with that, just asking as
usually LTSes only receive critical fixes :>

> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2024/08/28

Thanks,
Olek
