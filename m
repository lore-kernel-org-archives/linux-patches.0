Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41453A8F7
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 00:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745023669; cv=fail; b=pY4N5RklB1CsgI62wgEMgy5dtI9DspXwKGxy+ZblCOou03caGABjUb9R83vKgJxaVeB+Om4V1BtLaZzEDVH/kiY07wCxO0h6WQyiDIOT2lO8IcfELnCzhbSIKXGZ6188rYMoj3Zw4+V+9fT5FPguKqSFQfmfjxrochV/TsxyAPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745023669; c=relaxed/simple;
	bh=JdKtbszK0hoZe/VqLCzGTVUIpedbVBi/xVPyBGHvDuQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rntRSb99rzUDth8Jh0MDAxGVKpBa1SrUt5nZmKFnYV76FmGsE5yqTwCYSXOHQK7ABrFnHvJAQjOUwEyxWryXaivlcv1xbatrOsuboUI8gGK5QM9xuoVK9Ygl381tZKbhJwEtNnJ7xTTQ9mZRcWihu2OPeS9/FECqTnHz/qsv3WY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEn+yI9v; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEn+yI9v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745023666; x=1776559666;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JdKtbszK0hoZe/VqLCzGTVUIpedbVBi/xVPyBGHvDuQ=;
  b=FEn+yI9vxnPkyDNw0TXWOiIB93ERc+lF9sMSBoXv2yOtrgSgWGavOcev
   Pz62o82+6tzEQMNO01zC/pph5v5JWHzwn1tzr/Z28+WA+DJvEJMBGvidS
   w6VII2N3B/a2FUSuZIUFmmX83ouWxQV0hacBFNOKa9SpcY5QQXKcYUnFp
   fK06K8SRrmuBPiqDA+ezJEk0nehEc4qcYuPwnsDbSyPk8WVZYBBJR5QlO
   qF30u3YaR8DTKP8xNhcjK6huvl47+bKBpHUKDKzTUMN4JI+IjBat7JA3S
   I0Ta3VHCgz5jFF5Xb3ApRDGEPt5QF1iTUO58h17UzLtbOTdfHnbCJFTT6
   w==;
X-CSE-ConnectionGUID: 2UjTTvYPQf6Um58oDTFmSg==
X-CSE-MsgGUID: LOu4EjarTkaFDyOgSPxCRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46545868"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="46545868"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:47:46 -0700
X-CSE-ConnectionGUID: RThNZggaT86xyiWV+WrnzA==
X-CSE-MsgGUID: CJZ0NeDARPa/cfkg9R3f1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="131783684"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:47:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 17:47:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 17:47:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 17:47:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaQCrbpdScwr3dVsjZ/67oBsj3oATKhr3x/20Fk8wz9zO674bnWV2oXCFNn5GWiidU1hpkzmxTHJwHrj182lfLAOH5nHeLNML3OqxmIHYRFDklsfrTwGkEJZ8YyVeFpKkIu2wyTeMx74qxR0oFuK9Sm3nl7sjNMvIEIBKg9pRDlL65ZBFvy/2Y/aTPbXarDSJbP2gWqhbzqfVkkWsXtH8P9MdVJpRWEEzT4m5bJ4cUAC3R05odFl9wyBf2Lzz4uFyjofH0/cC+WU7v6urJKbm6PDNIv+fDpveE8F6HD0XT/lzQPmLwQe0xFlzNlMImpOLXmvderC00gkw8XYyWPKCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+eTafsFJd1tX67f0IxkBV+FOec9xLi6PkxwXkroN10=;
 b=keZxqwxS1PkkHAXEVhuajUpl2pQJMoEnjqz9iWrc6RouiVWuP5LZpcWp9wHIa4eR5vdbxVQZKmPZPAZ+SlsTOdV87j5ZdRr/mN/Q0XlGBwgmeziFIQyEyQqHRkglRYvdX3GooU5tGg8PsyI+ir6ZROYbHdBEqQDt+eIKLbXTLPRTfLcaDTddHds+z9bs1FwPlj6f7XzP4trfrfS6R5vbjF4SHaxKJOSCwefxnzReHpSfNwCQzK5fi9of3iDDO28CFuyM68OpZvcgFK3N+Pba34VnrOUxBqgiGYNfXcnw7lhIGKrAQpCH46g7aE6xiaL3BMe8w3KOGeoUJJKggot7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7571.namprd11.prod.outlook.com (2603:10b6:510:27e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Sat, 19 Apr
 2025 00:45:48 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 00:45:48 +0000
Message-ID: <d6a0106a-3c80-4eec-9453-b3167badfec8@intel.com>
Date: Fri, 18 Apr 2025 17:45:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/26] x86/resctrl: Third phase of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: adaed7b9-350c-4abc-4f5c-08dd7edb86e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aTRlZnhzcDRJQUZCdHAxa2QyQ2xScGRJVXpWSjR2eHd2OXJ5aCt6d01iWkJW?=
 =?utf-8?B?Zkp4NVc4bnI3Tnh3aG9hOHZ0QXp2UXpEL0g0bVhVRE5pT0JXcWkxS3hFL2hO?=
 =?utf-8?B?NE5UWVZLU0plTkk4R1p1ejRvOFN0Tm9SZlY2NUEyVFNyUHFTVkZad2FuN2Iz?=
 =?utf-8?B?WWJJRFd3OFl0VTQ2K2lrc0xIWlUwb01UVnVsK0p6VzFUSy91MGdKamdwbitx?=
 =?utf-8?B?SDJvenNQaG9XTytqMmlzbEtISjNCbUtSVGFOd2dZdENKMTM5dk10M1cvWlZF?=
 =?utf-8?B?NS9xMWVhVVZLa2VTR2tJNHArTjcrOGhReGtoYjRNQ3U5eDY5NGdiQkpzWkc2?=
 =?utf-8?B?Qy9QNEFOeUxOUmRFNGdwRElIKzJIMHRiWUxJOW9LNTZFUVFsQ1dTSis2UXpT?=
 =?utf-8?B?dTFMZ0tzUXVFR01QeEhML0tJNXBLSFR2SDEwaFdTcGlDWDIwSUlPeWRLN1RS?=
 =?utf-8?B?V3QxN2tYdDIyVFZzVE9mdW5ZUm5nR0NocTBNdkxwNE15cVF2Y1pSZGpEcnIr?=
 =?utf-8?B?K1J2UW5uWFh0RUVhcVFJbHJMSC9VbFYrYk0wUHFwNHNkNzFYeS8xYmt5dUdD?=
 =?utf-8?B?bnozakNpN1Z2WVpVQzNURDRwdmNnWVdlT1pJTkhlcU5YcXUzNjZURlg1VGo3?=
 =?utf-8?B?d3dtaXAxK2EyenFxM2VrZFBtc2dTSGg1Q3pXbzAxeEdyMnhFaTAxVTBOb1cv?=
 =?utf-8?B?V3pwZ0E1RDRsanpoRzVTUjRiTy96UXBDTnEycGNHUTUrTmV1eTlXUHhRZlpM?=
 =?utf-8?B?SExwQkJyc25IOXRIOE9scmE1L0Z1OEI1R1VOSUphZjN6c3VTRjRESDFFSFdL?=
 =?utf-8?B?UHJlTTNJL3RmNms3M0RKZUpmQ0luQU5TZFZkTEJPUnQ4K2VMNUxtczJyQzNx?=
 =?utf-8?B?c1JnSEEycFF5RS8yZHRWWjdpU1haalNaanlKVitKbmIra0FXU21LV1R2MXBK?=
 =?utf-8?B?RnBMYy9QNDlORkNldDhnSVdUcFBRalFEdGhhYllBMTUwK2VrSktpL2ZmR3ln?=
 =?utf-8?B?bTF0ZUpVVnBkTml6bkd2OE1RZ1ozYjJ3anFyNVNraHcxWmYzdDBQdlVCc2RW?=
 =?utf-8?B?RFNiNFc5dUhyT2pRd1dQM2ZUeXA0KzFVb2JDcDlCR3NMb25seGVSWDNJMndC?=
 =?utf-8?B?NzFLWU1UT2JHaXZIcEZxV3c4OWVjWjcwckFvZ1R2Qzl1ZHVFNXVGQWVyaEpS?=
 =?utf-8?B?dGFnZmI0Q0xKMTJ4c0pBb05KSnN0MU43bjVYRnNTbCsxZytsaEJQSjFCYVlG?=
 =?utf-8?B?QWptOGVkNktZSWZqYXZ0Y2FDOGNBak52VzRaWHYrakx2dmxFMjkrczErS2w4?=
 =?utf-8?B?NFRTbmx6ZmtPWDBmRDl2dXhNQUE5UGhrWFdHMnZtOWh1cmJicm5VWlBlNVZn?=
 =?utf-8?B?N283cDJCRGtjZkgyV2wzUlJKNmx5L0UybHBqUFMwUjk0N05XbHNGRDgvK2xz?=
 =?utf-8?B?RXdUZFhGaVJybDBiUkpEc0ZHQVJ2S0VqenVBbkgrTXVNM2p6Um5sRVdQUTJj?=
 =?utf-8?B?bGlaNnd6emgvRG5jMzdsUFFIOEt2RU4ybHZXeWQyaE9RZlVZRzFIZWhPUWxj?=
 =?utf-8?B?VVY4VlVxY09NRGNGN1ZidEZpNUtlOHBEVFhvMEpjc1BtQlIxbUR0QmlKM0N0?=
 =?utf-8?B?UGhLb0F2WkRjQVZ6NVEzTG95Ymp3bjQrbEpvZWNVaTVZelJXR3ZoM1k4SFd6?=
 =?utf-8?B?YzMzTDh3TWE0elYwcjJ1bHExZnJwaEFzSmlVUzN1QytaQ3FpS05HMm9naXQr?=
 =?utf-8?B?MENQdEpuRFI3emQ2Vk1jK005SS9tU1N2Qll0em9ldnJUWU5uQlI2T3Vrd3Nm?=
 =?utf-8?B?enE4Z0JzaGFiQmdhaTNuWG53Um8wY2MrakoycDBwWnV1QitiQUNzbEsvTFE2?=
 =?utf-8?B?Z25pYW9wT2ZjK2JXcmF5MGhWVnd0Wm9rRGxVNGxHYVRYSC9zb0ptOFk5RFhL?=
 =?utf-8?Q?MvzMAuXfRgE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVQxNm1PZGJneSsxMHVEZDBMdUtoVTJlcXVvbW5QSU84THRvUnVLOG9ya003?=
 =?utf-8?B?cXBabXBFZzlscU54c3N2S3pHbWVjcklqQ2grand6V0RhQmh3Y1BWemcyem9q?=
 =?utf-8?B?M1BBRHIveHQvVWY5eVZPczR0bnY4elB4ekwyaXF6MjBtR3VRdFpHeE94Q0hM?=
 =?utf-8?B?ZzlUS3ExZVIvbW4zZzZYcmwva2pSdDlrbWxHRVlQR2EwaFkxM21MNFc5MnRq?=
 =?utf-8?B?aU5IWXlGRHJxUHFRb2tPVkdHNDFXcWpHZHVjM1E1RGo2NU5IT0JnU1dTQlBK?=
 =?utf-8?B?TUFFUTFqR05hcDF4WXE2b0YyTGRhN3NzNmZkdW1NWkg0VkgxRk9iaGRaWkVn?=
 =?utf-8?B?eElmOWJkOG1WQ25KRFAwajhNOC9uZ0pHWjZwOTF3clZxWGlsVTZyVnlvZ2ZD?=
 =?utf-8?B?YkJaK25jMng2elVmcGwveStJU3VNUDdGNUdzN3JDNkQ2ekR5c0VMSWt4QThv?=
 =?utf-8?B?YzhEeDFMSUI2RFdOY0VZY295UzRlYjN0a1ZnVzBZR1lIOVRmZ0JWSi9yRW55?=
 =?utf-8?B?RGtNYnlJN0l5ajRGU2c5cUJud0VsZkdwclZGSzFqc2lZdko5TGNaNWxVOXVi?=
 =?utf-8?B?dmFxZ0RRREtVME1aZ2R1UDNBUFFoVlBCS3gvT1JyQS9nMFArTHhNVFJoUXNY?=
 =?utf-8?B?bHhneEFqVncwNUZPRlVQc2lPZzlDL3JrUmFjY05SWUY0YjFKSHdjSkFKOW9p?=
 =?utf-8?B?dEhOOFpONlA5T1UzZGdJa3RZb2ZudGpBcWxPVkJPbXl3bnRRWTVVUCtKeXJM?=
 =?utf-8?B?YjdJWFR0Z3hsVnVueUQ4VUswM1QvbGVkN1lsZk9JNm1rS29oVFRaN250ck5Q?=
 =?utf-8?B?L2Y4TVEyRy9aeVl4bXZibU9DQ2RRWGRvZ1RGTzVLSnE0dHZhTHRBZDlOSzBU?=
 =?utf-8?B?MHcvSjk2M3cvd2lraDVLTEY1elgvU3RkQXpIV1pjOGdHVzBCb0dUekVjRHBX?=
 =?utf-8?B?REpFWjdUcUxCVDYxVWhqc0ljL2tyMnNXblZKZWY2OGsvZ1VManhUekdWbml0?=
 =?utf-8?B?NEdvK0RENGNwVU01clVRUmk2dkljSGxrU1VVWkhRTzlQTTBVamtockZYYzcv?=
 =?utf-8?B?bzkzSzFiVk9GeDA1cWs4M3dPRVF5bmNNejQ1cTNIOEY1SXRHSy96Z2VrUW9m?=
 =?utf-8?B?RGNUTlRvSjBabnE3T29VRzFhdGg5VjI2dWV1L3FKTkcwVWNaT0Y5OVFXak5L?=
 =?utf-8?B?SzVwUjM1V25laHJ0RDBvbDYzZ3FhTnRsR1p0cE9qM0pQKzNNUGNNN2IrcnU4?=
 =?utf-8?B?K0EzNGZMYjBZYVdzeFlwUk5QaFVwM1lOTlJyUEU1MFNjY3FFK0VPakFZNWYy?=
 =?utf-8?B?SWtpMUIzclpOWnVqa3ZoYTFqS0w1bWk0S2IyUjJrZC9RclFoaTgyWThjTDl0?=
 =?utf-8?B?bDNXdnU2VWxKZ2cwV3VheFU2dlY4eDNPSWh3d3VsOUpIWEZId2FvYXEyV3hG?=
 =?utf-8?B?NGw5K3FFdEgycFFzZmVCQTZoVlFxZTdDNFpacllKSEhoSWlWNHpOaXhaVmo4?=
 =?utf-8?B?K0lTOWFsWkk2VVQrMmhISUt6WUxZeXBtZXl5K0dQelJKRklFU0xubEFzVWww?=
 =?utf-8?B?bzFjcHV2Tnh6VTg3Z0dTT05IYlJjL0NIeTRWK1ppcEJ0UFZ3bWRnNzlvdlFJ?=
 =?utf-8?B?UE54ZFFmeHZqaVJBRmd5Zkl3YVNqQWRZODNnMi90YTArWEI0SWg3dnVlUzVD?=
 =?utf-8?B?N1dYZlc4TzlUV3JNVk9acFNLVFFFbFY0YlA1Wk03ZU1OUWlnY1pMRjFEdjZ2?=
 =?utf-8?B?R1Z6R2g2M1dZNXMwMU15YUJoQVowMlVCeUhYUDVuQ2R2dEd0bFBvY3I3UFM0?=
 =?utf-8?B?eVlMZlVCV1R1dmVDVmtFb3o5ZHNIeFZ2dUNvdVRKSEVUaVkwZXpiUFlzaUhq?=
 =?utf-8?B?WmtWdVQ1RXlEU1JtTlArWTBEREhQVncvMmlURUx6Rnc4R0xQUGc0c0lldytK?=
 =?utf-8?B?Vi9zWlEvRVlpY25ob01ITkpoZnVrQll1emc0N0ZpVjY0aDI0bU8vakhyY0FW?=
 =?utf-8?B?Mmx6VXVtZFVNOUh4VGtmT2JaWDB3SnJ2RW55cUgzYU1Ldy83UnFJM1JqcGt2?=
 =?utf-8?B?R25oYmNvWHlxaHRUZ05WZmUzdlRYZk1YS2ZDRG9sV1hHejVBK2YwdThsVWR6?=
 =?utf-8?B?WmhmQW9lUzJ4YXRrUXB0RzVudzdZUk9yNlI1TlJOd1FwMFlja09OT3ZwQXJv?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: adaed7b9-350c-4abc-4f5c-08dd7edb86e1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 00:45:48.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lv+JBLg/s/RdDHzi8ySCwILiHehhdppgTE36MJV+jZMg33yNfwGlszGuO0tbi/iuO+VNXrytnvNufgRoKtaqGW9khFWR+9xEEoXSrkQFG2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7571
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Allocate per-package arrays for the known telemetry_regions and
> initialize with pointers to the structures acquired from the
> intel_pmt_get_regions_by_feature() calls.

Why? 

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 9d414dd40f8b..fb03f2e76306 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -108,6 +108,30 @@ static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_
>  	return found;
>  }
>  
> +/*
> + * Copy the pointers to telemetry regions associated with a given package
> + * and with known guids over to the pkg_info structure for that package.
> + */
> +static int setup(struct pkg_info *pkg, int pkgnum, struct pmt_feature_group *p, int slot)

setup() is very generic. I do not have a suggestion since it is not yet clear
what this does (more below).

> +{
> +	struct telem_entry **tentry;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		for (tentry = telem_entry; *tentry; tentry++) {
> +			if (!(*tentry)->active)
> +				continue;
> +			if (pkgnum != p->regions[i].plat_info.package_id)
> +				continue;
> +			if (p->regions[i].guid != (*tentry)->guid)
> +				continue;
> +
> +			pkg[pkgnum].regions[slot++] =  p->regions[i];

(please fix spacing)

hmmm .. this looks like one structure copied to another, not the pointer
copy the comment mentions.


> +		}
> +	}
> +
> +	return slot;
> +}
> +
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
>  	if (!IS_ERR_OR_NULL(_T))					\
>  		intel_pmt_put_feature_group(_T))
> @@ -128,6 +152,7 @@ bool intel_aet_get_events(void)
>  	struct pkg_info *pkg __free(free_pkg_info) = NULL;
>  	int num_pkgs = topology_max_packages();
>  	bool use_p1, use_p2;
> +	int slot;
>  
>  	pkg = kcalloc(num_pkgs, sizeof(*pkg_info), GFP_KERNEL);
>  	if (!pkg)
> @@ -146,6 +171,19 @@ bool intel_aet_get_events(void)
>  		return false;
>  	}
>  
> +	for (int i = 0; i < num_pkgs; i++) {
> +		if (!pkg[i].count)
> +			continue;
> +		pkg[i].regions = kmalloc_array(pkg[i].count, sizeof(*pkg[i].regions), GFP_KERNEL);

As I understand it sizeof(*pkg[i].regions) would be the size of a
struct telemetry_region that the code in setup() initializes by copying 
the data from the struct pmt_feature_group.

The changelog and comments creates impression that resctrl's initialization
consists of adding pointers to the data in struct pmt_feature_group but as
I read it the data is copied instead. Am I reading it wrong?

> +		if (!pkg[i].regions)
> +			return false;
> +		slot = 0;
> +		if (use_p1)
> +			slot = setup(pkg, i, p1, slot);
> +		if (use_p2)
> +			slot = setup(pkg, i, p2, slot);
> +	}
> +
>  	if (use_p1)
>  		feat_energy = no_free_ptr(p1);
>  	if (use_p2)

Reinette
