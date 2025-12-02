Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBF28373
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692327; cv=fail; b=AFOPJHXZT87SWgsHyb/pm6NI5phKija/pI8JDAwK/QQHjdzkHkonpOdALLVUFdqi0F/7lCsOdHBNeYTajarffHHKc56MeLBGk3MsSsWiYxMoCl/pfjPdxeMMQB3l2YleMEG0FBWWkaz0+7RYqjGZCs7H+9Xk07LpXEO2sKeknU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692327; c=relaxed/simple;
	bh=8XNrV/fLqC8Xf88gU5NZQoFuFqsoY9JHfHOSXxLGEqQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CnWKeNb2dNUyqbc37EaKHF3Anze2XJpDO8y4w67c9ocoG8hYppJR5vcJdEXU4ATEqGuwjYa+Xy1JogBNN8/gaEtGgPS/PMCqMP8VJ39CUMdrv4VEp3ZyKiRfWhUBMwujUA7GCLX+C0mz4nYQ5Z0ZyP+kT2OqB279b2j7aiVYaCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZAYBDkGR; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZAYBDkGR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764692325; x=1796228325;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8XNrV/fLqC8Xf88gU5NZQoFuFqsoY9JHfHOSXxLGEqQ=;
  b=ZAYBDkGRpGkuPsRBEfxk+srY53poUDeXwE8iBq3qEVTOEk2lOYfpuglK
   8k/IYHT9VIZLQmFvFAktmelUvooRHDmRo0G/qblKgZrUPzGkV7utuo1vD
   PHF3MZl9bp2ogxTdRLJRBib6iXxJKUR8YKrimSk+5fmmcW/YGzdradgHr
   uHf0er3eAIyVQ8cs62ytHPXQ5AQcaNOqPqhCpx00hg2uLYNk9afT5LPLS
   sZL7fE+tkE+AOx9qgHt5IJLeZ6OJrAPKihhMRLhRYKWqkzc3KDFsVr0y5
   Wq74O0i9iSWiuuYYNJC0jEoQRX6u9FpCEKvUv9baD9xEepO9rIVUhdSir
   Q==;
X-CSE-ConnectionGUID: vPpYNwreQ+aRGQhsompU2w==
X-CSE-MsgGUID: wFNRAr3vQPOfFtG12alOhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="84062816"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="84062816"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:18:45 -0800
X-CSE-ConnectionGUID: NE6S0fHXT/mMcQgL3bZB4A==
X-CSE-MsgGUID: Dh7/No7xQ9Spk4cA8v7U0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="198605959"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:18:44 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:18:43 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:18:43 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.27) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:18:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xVvSCYs/+U5HqOIpAaIvLH3kIFKmZ5tXt2sSECI1AP08C4g0ZTP5hqktv9bGFq8R0z2huN5z+y5wUal3UktFZz08XlOB9Vqjw7GKhloY4YR1QPXgiNYECVKshBIIBg9oP0HM/J/kV6VRpKJu4xIG0TbIjWsQUcy0imclpNQavxKZJCI3jkD3Qoub1IveLySevGZpT5C8GqvfwYc/MM+OJLzPewvSoT5V/WMjtRzdn9q9pIi1eBVeykHmKUVxX3XNgxE/d7rVdxArhtCU5kkS0lFzo7GoKp+GYcpB5mRtsfSSxfXv667gyiyJ5rckzsOeHiD60H/6ODAHX3EISGvi4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6zOfepKln0vhT1rWr8V+A9nnP89ly4q6JNef7Z8MSk=;
 b=GsL31uXX6wAR8NWduygW8rg2BzwEmQPJUnmjgwU9gQa2mpjOyVY0LhXQ9iZ632fP/cyJvuL9ZXcoHLj53ft1Aqy5mmBiU93V+mxd6LUSSP3gmD5FZCR4IR1LnKmB748u5qfTx92O+hk7lyOvc6PJ5kuKPinJ8MINUTyyrmymy1Z0o4Ad63L3DQzJIf9SHMHCLkaNtsh5S1dug1d7aQALkPmMCLERYZVK5NJl7TDVDjA/2IbrQsVbd7WfquuKdnfLrQeGfW271NJDOdv9XzZHct+1RHLrmF1Qk4IFfzLK4PRa+wpO84wsZWctSH6tOncadqQpf8jJkUFF/OhK+kO3xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Tue, 2 Dec
 2025 16:18:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:18:40 +0000
Message-ID: <578965f0-55f2-4ea4-98b4-bfd589e8c028@intel.com>
Date: Tue, 2 Dec 2025 08:18:38 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 16/32] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:303:dc::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c9b8406-613e-4983-f267-08de31be74a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MUVLMjdieHRYWlNkdUhhWXlFeThzeG1oM0d5S2xsWVhUUGVsQVdlRGY4Lzh5?=
 =?utf-8?B?R2RiV1RxbGJlWVJwNXN2Q3E0b2xGeXcyeksyRVo2L1c3VGNXVTBpQkhBOFpQ?=
 =?utf-8?B?cW1Ya1pyMk5ZVDE0V3M5cHdiU1poKzZnMFBGRTA2ZkxvcVdva0FBcWpBMDQv?=
 =?utf-8?B?S3FoeWZPTmdGWmJCRlc5ZUVrSm5mdXp4Qi8rZ2h6dDZkWFgybEVWdi8zMGRD?=
 =?utf-8?B?T0VCZVlBcVpGeGplY2laN2VHOTdNZXVsZVUvS1U0clZtWUo1aUVSR3E4MVY0?=
 =?utf-8?B?RGxDNDdQVklna2FWaXRnRjk5NXFqbzkxekNqNFVKYmdJRGtEMzNndkJERGg4?=
 =?utf-8?B?VTJMWEFXS3lGUWRzTWc4bklGc1ozMWRYM0JSOExBZ2FML0dHQ3dxUEh2SllJ?=
 =?utf-8?B?SUtwdTB0TmVWL2R2MUV0byt6U1A5U2doOXM1d0FNdEFGY3hqV2loam1tQytC?=
 =?utf-8?B?VVN6SzFSYTdZWWhhV1d1TkVORUNkQ3JobUZCQUVYbFdmc2F4MEdKQjgzVFJu?=
 =?utf-8?B?d2Jzdnhuc0NpWVNnVkRYLzFQbjZ3ekl2bk5MV2FFYjd4RFpteE01RUMweTJy?=
 =?utf-8?B?YVJ3VTVtQzBDcUpvUnlNR1h6c013MTBCTnpUeGNVL3RWcjhTRzdrOEdzTzl6?=
 =?utf-8?B?S2RNMWVpZzNlUjY1QXV0WlRaZHAyVXRZS3hKZ21JNFZFK0tXaEJyVC9oN2tu?=
 =?utf-8?B?T1o4S0M1QS9nYUFhRXIrbzlTV0dKQzVSbCtodGd2SFZwYXh6dHVueGo4ek9B?=
 =?utf-8?B?eFRSYWVIUnAyaFhBWGkxbVJjOE9MWXRFUExKMmJwOUJ4NVNSc3pHc0xSaFkz?=
 =?utf-8?B?SDZmNHgrUWVYRDN6NCtHTkJLR1MyYzB2S1llc1ZYNFA3SzFybjV5NEpGWTJZ?=
 =?utf-8?B?VXdyOU9Ra2NBNlo5UmFzc2FTWE55ZlRVejJ5NU90YnBpaWRsdENpSytPSUZ3?=
 =?utf-8?B?UFFxbk1kUzBvUmJSWTAzUElkSS9tc0dhWnJaTnVCb3hvNm9OZ25jRENEdi9Q?=
 =?utf-8?B?RDZFcW9HaHhrd1NvU2QxdWR4SVR5eTRnR1lwSlFyQzc0cDNTYW5tSjIxMk5V?=
 =?utf-8?B?NDV4Q3ZJT2pKRkdmSzFxNEJCNk52eVZ6TFM4dGNMbC9KNER3bXN1cWV0L0Iz?=
 =?utf-8?B?RHNyYU9zTnJvcExpNXVTc0VxUlRWUGtrenFJV2cxbUJWWGludTIvMmdCT0hN?=
 =?utf-8?B?M2VybjdjYVJGMC9vcU5SVVFFRVFJcUlHWTUxTmUyVkgxVEczdHJVU1llcXB2?=
 =?utf-8?B?eHZwWUpITWhucW9TQ1B0SUtleE81NSttYlUxdUxOcExpV214RWZJTmFhY2Rs?=
 =?utf-8?B?MW5aTjFKY1h6bjFQUjRhTytmbXdCZ2JUc3FycXcvL2hRRTg1eEJBUXNFUTh5?=
 =?utf-8?B?N3U0S0xqTlhtUFgyU2xVTUc4VENDUUZCM1dmV0NhUmxXdjhSRG53RUx2TWw4?=
 =?utf-8?B?UXNxbGZsd3RBOEt5dXh4dnl6a3RUelhTbGM5cFEvVVpNM1Axa2k0M1BWaU1B?=
 =?utf-8?B?RnhVeHA4SlF0K2kxZlBVa002UHZoektFOFRuTUxuZllVUW5mSzJ6YmFvZTVz?=
 =?utf-8?B?blZIUGtyR2ZjZEFjQWpOQk0xYkZUZUk3RnlPUU9KYU4yc1Znc21nTWVEMS9Z?=
 =?utf-8?B?N3czbEs0Tm9tS2tlakRGN0RvMkN5Y1JURlNkOFhBRlVUR2lBc1YwVjgwR1g1?=
 =?utf-8?B?RTFiakVMTGFvR2paQllWa3d0NmNYd2NYRlVmcm1BRWlWcjErcjREOFNjbUFR?=
 =?utf-8?B?aHhlVmRWZUd1WGhDc0U4NnFBcTBDckVKeFlrdVRRL2ZzSW8wSzlvRnlNSWF6?=
 =?utf-8?B?VWNFVVhPK1BGc1BXWkxwQmErLzJkdWJuL1A5NHlEVVpZVGRPMURrQ1dKQ3o5?=
 =?utf-8?B?aU8wMGFkbDdKbkp1Q29RdjZLVjZBd1M1cEZRc3hGTk0ybEo5WkpYMFVucHpo?=
 =?utf-8?Q?a3WBOcuMG1Yco0WqALaQo1wBFuq8deE9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDNONm83OHRMZWh5bVhUcmdleDM5YTJMc25ibFV0QnRRNVRZYlArakZ5cWo4?=
 =?utf-8?B?ZjlteEk2RXMyS1NtQmlUdW9tZ1BrU1NOWVpKRkh5MFRZbmdzKysrWG45UnZG?=
 =?utf-8?B?WjVVaVdidVZLK0sxS0kzbFkyRTZ3WGZibFFyYVpNVER3NVZyWnNuSFNRUlFl?=
 =?utf-8?B?b1pZNlVkb00wUWJqbEd4UDU2ZGJpbXBnSHJoTGpzNG95c1RZM2JzVnN0L0pP?=
 =?utf-8?B?V1cvL2pjTjAzc3lHR1JEZ0E5ai82WDF0c1hzbjZVU01rVzNxemJUaS9abGY4?=
 =?utf-8?B?Q3JqLzBYb0dGSGpQS2hEUlhVaEVVOHNnTVppSDBxRytUUDNwcDBTMGhmbi9O?=
 =?utf-8?B?bDduVzBMbVFveGE4ZmtPaWpPV2hFUjNQWThnSTNiQzBwNmVsMys3OVF5ZHdl?=
 =?utf-8?B?M1BmMUhEUUZld1FGYkwydW9lelNPQkNvWHloV1Q1TEZDdllWWnJJRC9DTVJT?=
 =?utf-8?B?RGk1TWo0QnRDaUZud3pES2UrdjN2SEEyUlJRUnAyb29JMEhQbVRoUTR5T2t4?=
 =?utf-8?B?NnhMN1pRSEQ5NDhndTBaMXJFaUpJSGxNTFpVdGlOS3FXQlk3akZYWUhTUVRQ?=
 =?utf-8?B?dUV3bjh6Ri9uNVZDNmFqRTFpNVROWTF5Wi91SkkzcFM3VU9ZNk5SaWljaFc3?=
 =?utf-8?B?Um4yUVBkQ0toZTBYOHZDQ1V5dHltcEZiLzRoaHVTbkhGT1Fsd003bmNhZ21v?=
 =?utf-8?B?d2hOby9vMWJyYWwyaEVpTzc2V3VvM1hmdE1jTlpxYk52NXFZZ1U3cGtuSzJU?=
 =?utf-8?B?L2pxR28xR2F0aTRUL3lXL3MxNFhCY0luZk5WZVBPNCt0a1hGMEFiWUpqZE1q?=
 =?utf-8?B?dGQyb0s5YXE0djlWQk5wUkNGcjE5dkEwSU8yQWxBZjdQN3llazZMU29IVGNU?=
 =?utf-8?B?R2JLOVRoMnJVdVZ2NTB2L09GcE1GTHpha1NqYXF3dlZyMHBxcjlZZTR5eEhP?=
 =?utf-8?B?aUtCaTYvbFJ0cG1qeFJLRFRTbFQzdVZTRUxnQlA4ZWpONzd5Zmo0cDU4ODIv?=
 =?utf-8?B?NE96VnFpR3JTcXNwWDlCcUUyWjU2Ym5DV2lSTTJzbEYrbjJ6U2ZkZWRsblpa?=
 =?utf-8?B?Q1RkNG90WmtCa2sybzhRWWNWSDhyT0ZuQnFnc2VYZnV4S1hOUXEzWTFKd2Vr?=
 =?utf-8?B?T1B4Q3FJbkltUEl6V3Jqb2hYTDhhQi9ucUJ0blZzc2xUSFAvam4wRlRDeXhD?=
 =?utf-8?B?MUlsQkVMYmI2ZmkzQng4SnVQTXJmZyswT0UwRmJRS1hva2VKZ0dGeC9UdDNi?=
 =?utf-8?B?RU93T3J3NE5kMkIyS0hxck1nWnBaMUJ5dy92akduc2EwQVdudnY5WnJxbWdo?=
 =?utf-8?B?VHdMSzUxemQrTkJ1azZTbzNGNEkrOWJzZi93cXF4dEZQZE9zaS91NGd1RTJ4?=
 =?utf-8?B?bVowdWtXbm5Fd3paOXVubWZuM0NIa1VlL1Q0dmVHR1dQUk9pTm9RQ3lsYk1a?=
 =?utf-8?B?TzhyQVJzQlNzbmVoTnRQbFgwdkVoV0xpenRBV0E3cVg3dWlvNEM1Z3RNSXA1?=
 =?utf-8?B?Tzd4bmhPZGFacG1wT0RTbFVhZEJkM3grcis2dTVTU2dzTDdJZFprSitHNkNu?=
 =?utf-8?B?NnhSL0g1eXdUNlovek1UNE9PbjRVREkzNDdsY0hkODdQS0ltTXV1TTl3SjZZ?=
 =?utf-8?B?cWJid2I1SEtwanBIREhSNlhBay9HcTFYVmZac0VXVTcveEJFbXhsQVlhQ3lt?=
 =?utf-8?B?S3JTVXRTbmdncEFkU29IUWRYTlBBSVlvL0Vtdks2aDkrOXpUSHY0bnE2Y2Y2?=
 =?utf-8?B?VU11Z1pwOWIxRzVlZFZYYW9wVDVkdmc5a0F3YytlcDh3ckl3N3BpcjFxYTI3?=
 =?utf-8?B?bjhBY2o4ZHBzWWg1NWcxRm5SK0NUL3k0YWlnSFFvR0M2bU9udlZoUEIyblZY?=
 =?utf-8?B?ejNwNENlZHp1SWx2UVdjMHF5ZHd0UW1FRUd1c0hENm5qYmVaajJ5bEozczlL?=
 =?utf-8?B?OWo4eUxRQWFuQ1Nad0NhUGZFTEhYRDBTVEpzKy8yQ2lLQVdWZnhiYUxWd3Vt?=
 =?utf-8?B?L0tTYzlqdXU4eDY2cHBMNlNqam9CbnpkYkRXZ2FWcno4OWZCbXFyYTRiZHVi?=
 =?utf-8?B?ekhmdkNzQzFMYXhLdWpxc3dWeVdzNC9qcENXR2VDdFJnUVdFK1B2eGMrdjNW?=
 =?utf-8?B?UzA4NkM2N0ZLOUV3N3RNUmNyYVlPQUxBLy84RDBocGdNdnhnVjdJWDB2cnRT?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9b8406-613e-4983-f267-08de31be74a6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:18:40.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/IPPi/uYrxeAtQjoMwVXkF0WOUPlJp+tToXl0INUZH1BSA9wODvB8kuLr/nWBmFeocEqH4j+PJ0oHgbnxkm8betlflP0EjL4EFbFxyTjNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..5d34c7349b02
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,98 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/array_size.h>
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/intel_pmt_features.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/overflow.h>
> +#include <linux/resctrl.h>
> +#include <linux/stddef.h>
> +#include <linux/types.h>

Does this patch need all these header files? For example, cleanup.h, overflow.h, and
cpu.h do not seem necessary?

> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
> + * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
> + *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			returned by the intel_pmt_get_regions_by_feature()
> + *			call to the INTEL_PMT_TELEMETRY driver that contains
> + *			data for all telemetry regions type @feature.

"regions type @feature" -> "regions of type @feature" or "regions with type @feature"?

(if this sounds familiar ... suggestion was "of type @feature" in v13)

> + *			Valid if the system supports the event group.
> + *			NULL otherwise.

nit: "Valid if the system supports the event group, NULL otherwise."

> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	enum pmt_feature_id		feature;
> +	struct pmt_feature_group	*pfg;
> +};
> +
> +static struct event_group *known_event_groups[] = {
> +};
> +
> +#define for_each_event_group(_peg)						\
> +	for (_peg = known_event_groups;						\
> +	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
> +	     _peg++)
> +
> +/* Stub for now */
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return false;
> +}
> +
> +/*
> + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> + * pmt_feature_group for each known feature. If there is one, the returned

This has been changed to "for each event group", no? We seem to keep talking
past each other (me with feedback and you with a new patch series ignoring the feedback)
since I still find this to be describing a previous implementation.
Previous suggestions to v12 are just ignored without reason. If feedback is faulty,
please respond with motivation so that I can understand why instead of just
resubmitting without addressing feedback.
Consider, for example (please improve):
   
    Request a copy of struct pmt_feature_group for each event group. If there is
    one, the returned structure has an array of telemetry_region structures, each
    element of the array describes one telemetry aggregator. The telemetry aggregators     
    may have different guids so obtain duplicate struct pmt_feature_group       
    for event groups with same feature type but different guid. Post-processing 
    ensures an event group can only use the telemetry aggregators that match its
    guid. An event group keeps a pointer to its struct pmt_feature_group to indicate
    that its events are successfully enabled.                   

> + * structure has an array of telemetry_region structures, each element of
> + * the array describes one telemetry aggregator.
> + * A single pmt_feature_group may include multiple different guids.
> + * Save the pmt_feature_group for enabled events.
> + */
> +bool intel_aet_get_events(void)
> +{

Reinette


