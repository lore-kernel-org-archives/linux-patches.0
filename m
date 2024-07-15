Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BC18629E;
	Mon, 15 Jul 2024 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721038221; cv=fail; b=exNQoa7bR+6tcvDDBU3UInj9wSZGQfIFbdkMj/kS/6AkwEi6HQRGimEUNSe2fe0W2TciA555za9dIZ4UUyk/Zi58dKvKf6KnROzYibTeK6ITc5JL/84ZWX/YnNVg+cBacdYPPUL16UyXNH+u1EgPbyBpJUbuVZfmM2pOac8Jq38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721038221; c=relaxed/simple;
	bh=uU/T2mMCfwdMWh4N/62dL6wx2bu8r3IWAvUOFJxd4Cw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nz1eGyCCbvzj4j3W9waEiTLiQT2+RjkQm1Ur5u6cMS5rRAzDjlzX0iQUfCa8HRX1XjCZefmsuewvHfS9NVBLiJ1zoNgZ/O4toR8GXHlW32vcmIA8WPDW75T3qNP3mQ5FJ8ekXQ7m+aN+IafSD5v8WVYTAvRXZVSRsXU+l8SX0yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FhGf26uK; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FhGf26uK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721038219; x=1752574219;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uU/T2mMCfwdMWh4N/62dL6wx2bu8r3IWAvUOFJxd4Cw=;
  b=FhGf26uKBBYS+P8Gq/HZGgrNKIO95JyxaKHFIh88EKiZ5wpHVX0wfQ3D
   W+QFOn7EmMqtXtVTQ3gb34uT6nI4mRacLCnxsHfuNaV48w4cpGwA1sdOs
   IDt3vclUM1HJbom8K40vIX5mY8EU7+R1FCidPDQpoifytb1TwPUC3iNQi
   2dVufsA3WWFnh+zg1eg5OXb8s5CAvha/Lc2j5Dv4N0aMQilt1/bDynCB9
   TgePkRQhqF60DaJE9VrdGaMIRjngYepJlzfZfosLLfb5Y9i3s38h0i6Ct
   Um2sgbpvzzN6IHggajf4grPfBvS67d0vMUHMbGVZF7TP8pCUCkGEbd6/b
   A==;
X-CSE-ConnectionGUID: TGuNcN9ORVmD0+NUntleGw==
X-CSE-MsgGUID: ez8iTDxRSHahnmkvaMcvVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="22170818"
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="22170818"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 03:10:18 -0700
X-CSE-ConnectionGUID: jqIPyMNGT4OiInaciON9MQ==
X-CSE-MsgGUID: HTxRMfnARK+EdS0zpjxt5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="49447358"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 03:10:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 03:10:17 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 03:10:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 03:10:17 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 03:10:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7n2Stth6h0BeswEkHE/lzvb1rP8ZUeVjdhTWHtJTfJd08W790PkyfHpYU7GGs+zLZTUakmX/2spVY6TI+ZtZ3K35rnDF+GfdYm4jBl4I1s9hQ5mazFkm55tJ64II1Z+1QNOdLv8ZBZdRlzvXjnIxrlCDm8brrP/JrZ/FvZ7TkrGKdjkBaQjYIv+jft4UZmFQDjLEVtZeE+IHvkE3Zh4UeAH4U0cxnhLVS9aCranaSzH9XXsg7fyaA77h1opFma35BVujbDAkUrGpAso1PSmrY0Kfh0OJweEVhfJ5d9osKan9cfPcTeCFCjGAi6VtgOKZR6VzFgaDuTyD/d0omnoPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1j5Dltk4pdG9PZa4+Y+lMJZ/1kP3Ta8IJvIasrg7nzU=;
 b=EcGBhZF05oxL4v9jK6C42iPw7w9H4q2Ev38ZRRv1XJZvUs/WucKLiTFrbPUB/41H2j/32yd6xn1MfKuYuO7XJuVFbCYc+LlLYFTYeTEJ5zv8nzaCR5KaTe4VsdgaC5LHTvaKT8xox130VVJEVH7tDzScaDb4y3cwSwbzxJKtSImt5trroXI/hzXHqmAm76p2rYaiAvUiVTS/5VUlocyxvjQcwtcZJ//HbHBgmgtPqlrMd1FqakKZhsNLbykhV6NSJlzaNpXp8CYJFZ881/pQFcq80eZ3BlA/Y0aWmPr5gc5ccF5A6WKq1xxUXN3PRMVKRx+UJvzCaUL3r5iNUg0ECQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB8599.namprd11.prod.outlook.com (2603:10b6:510:2ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 10:10:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 10:10:14 +0000
Message-ID: <32263987-c680-4f3a-8b08-9d7e8f4ae08c@intel.com>
Date: Mon, 15 Jul 2024 18:14:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommufd: Put constants for all the uAPI enums
To: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>, Kevin Tian
	<kevin.tian@intel.com>
CC: <patches@lists.linux.dev>
References: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:3:18::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: 452804c8-e390-4eca-a239-08dca4b651c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MGNMNmJIRGRzM1J4N2lnaEdRNUpJUHlETUNxM09UVmxMelZTYzYwSGJxWTA4?=
 =?utf-8?B?U0tjN1krTXJ4OThNeG5KMjJlVUEyM0lIZy8vbW81ckVBcFdjb3Back9VbnlC?=
 =?utf-8?B?RlB2WHdvYkhYNndrZkRwZTVvUnlJS2E3dS9Wd2FOaEQ2NzdxNXVFcWluOG5B?=
 =?utf-8?B?MUNCUmNuWFNGaS8zQlNyK25xZWs5dEtUb0tCMHNXNG40K0hJbStsV3dDbmFF?=
 =?utf-8?B?WHpXR3JFSFdlYTFxcE8wcGNHd2lNRGtnbEtweHNsL0VabG53dHNYVndwUVBV?=
 =?utf-8?B?dU5KTXQ5M1Q5M3o0MWNPOUZlSnM2cURmV0x3MFVoeGcvenBaV2gwa0diR3Fh?=
 =?utf-8?B?UFBndFBsbXVKRUpXTmNYOFNMY2ROa1R1M2RuRlVEWWNWaDQ5ZU5EdU1hbldE?=
 =?utf-8?B?cmwrR1RKS3ZadERHcFcxM3l4UHhRWUVaTWdhVnRGL0NxaTBFZ2ZNNjFMVFVx?=
 =?utf-8?B?ZUhOTWF5RktiTDllTTBBTWliSThFSk1hVFFXcWpnUnNMSUVBaFVlUFVGdzUr?=
 =?utf-8?B?L0hpRmdkaVhqdWFORHF5b0JrekFvRnFLaTJPbUNEOXdPUVRySUJUb0F2SFNm?=
 =?utf-8?B?Y2xNQXdHS2xTRlRONURSajJCTmczVUhQdmROaUdxLzkxaFdLWCtuNFUzNkYv?=
 =?utf-8?B?djVZWEtGK3NMS1VvajBWS3BNNjJydmRNazhTSC82UXRuMSt4elRuRkFQT2p0?=
 =?utf-8?B?dEExUWMwK01Kc2dyYVlvSXZmZHJNVnRSVHhhaTA2N080YUJRWWNWTjRlMTVD?=
 =?utf-8?B?SVRVUzF6bTEzZFZRSjNsbE9VNE5YVUVFMVZDdnY0TDFPVmNmdXBYcTVFUGJZ?=
 =?utf-8?B?YS9hem1RQnFoclNoUEt1clpKN2NSZW95TFhVTmw4OS83WVdGbVljV3AxQWZ3?=
 =?utf-8?B?YXhvSnZxVlEydGN3Z1UrMHdaM2doWXk1TGtrWGFHeE5haHJHVklSRFBkTlZI?=
 =?utf-8?B?ZU1zVTdMY3VaVXNoemMzb2hxQ3hHUjZXS0ZubUJ5Vm5KQTh1dnZCUklWbUI5?=
 =?utf-8?B?aFo0Mk5mVGRMa2lvUUE1Y1Zseml0bnpGcGwyT2ZUcXJsRjBrODI1bk0vN2k2?=
 =?utf-8?B?ZVgyNHQyeTFkNmpoRExDNFVoczNOUlVoMW5FWDdvYVExL0V2Y3FKcXpIRDUw?=
 =?utf-8?B?bU9RMEdWb0EzcHhkbWRPdnE4cjdwTHFtNmtLRTJraHAydVBrd1FYWlYzTzNN?=
 =?utf-8?B?TktldEI1WUo0RUlPRDViRmVGUGZVelY2ZGxyVlBLTlMyeGJLUWxnZEM5aTZE?=
 =?utf-8?B?YlBWYno5WmtTUE9XSXcycEQxb0ZQRzJYTHBzdzBFekJRUzhpMDBzcU04b1lB?=
 =?utf-8?B?ZUV5bDhDeFVRZHJHRGRBS0JIZ3RlZjdHNDFkNVA5UUlvUXB6aDNCSlpMbVlU?=
 =?utf-8?B?cGY2eVR0ZHhBY1lqYkVqTEhESWp0Qi9jUjZockVYODcrbktIeTd3TmtOekRJ?=
 =?utf-8?B?OXUycVlnZEhFcHlRNllrZGRybVpUUDMySXdQelFJOXZNVXVVNnlVY2hPM29L?=
 =?utf-8?B?d1ovdFBNZEE2OTVYWDhRTVd4cjRNc2ppZS9ublJsMVVFUTQ3V3NSY0p2a2h6?=
 =?utf-8?B?bG00a3MxbzFEamNzMHhXclRxVXVHcGR1citQSk9sR3pPbktCS0VhNmptQ0JX?=
 =?utf-8?B?Q0o3U2hnRUEzampBbHVCU1NLc0JWZjVSSy9HK1kxTTE1aFFQVlBUS1J0T2JY?=
 =?utf-8?B?Y2tZREE3UHFwZ2dWYmZkWWNubnNadS9INlZXTnoyNUNqSVdPUmdOYlUwaDdP?=
 =?utf-8?Q?dNJV74PAMNcg9xqBfo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWlpajR5b1Urem12Nml3RytTZm1KOXAwNzIwQlBHMXFRMk9OSjZ1cEYxWkUw?=
 =?utf-8?B?U1FJRGFvYk82cnBNWUlqbGhDdmlKQXVuaHMzelVVMXY1THMwc2ZNWXczRWNX?=
 =?utf-8?B?M3REZWtrSXBNMWJUZXV5N3kzcHh4RnZtYkd1VXdFK1EwcTY4dlltd1BPK1Zs?=
 =?utf-8?B?QVFjamVFbWN4SjUreUI2WUNPTnU1SEY0VElqYkhnV3QydXlGRysvOHVwNWxz?=
 =?utf-8?B?MHNGRmpHM2cvNENsS2dqNHh4dlJ1TkVRTGVtRWM1TEFGTjNaSzhyWWZYUVVh?=
 =?utf-8?B?SkNnaVB0ZUhBZmF1L1d6MHVwemxRNHg2VTUwdVFsYXJueDRtQlhITlIvVEpX?=
 =?utf-8?B?UHZNOGtLdXY0d2tDRyt2V3R1Q3E1OFNYcml6OGpEZGNNcWlQNytDY2ZLamp5?=
 =?utf-8?B?UndYWFAvSjJ0WGJHUVU0OWhwaTU4YUhLdVRTNWVxeTBhOVdSbW1rVmVBUEpO?=
 =?utf-8?B?RElKUWFKaTJiSjJ0M3ErMXd3TjZlbTZXN2tVNEs2VEpiTExhL3dGZVY0TG1i?=
 =?utf-8?B?cSt3cFJRVk41TGhHQUV2UEh1dHo1U2U5aTF6QlhQWG1aemRoMEFOS0ZlVnJY?=
 =?utf-8?B?RFhscXBZNUo1czZJTUtTbTV5M1RwYXdBazdLaUJYYjNFaFlFVUJQekViMm10?=
 =?utf-8?B?c3NnSlJkd0ZHSVVmQ2xwL2l3bFR1YVZJdk5FN3dzQmdzYUZnMTFaUGhxM2wv?=
 =?utf-8?B?L0lqVUdEZVRPL1dldDNtT3JwRzZ5dEZaS0ZzZjlPWlN4RTBtUGJvbnY5VkZQ?=
 =?utf-8?B?Y25ISHRTN29udFd5QXA5UTRUc1l0TWxJYmlnZkloVUwxTG5pb1ZuR05XZWZ2?=
 =?utf-8?B?UitPV1VYNkZuSXFkemNoR0d5U0FCajRKZUlVdHkxcUI4cnd4U2NneGtSQ1dw?=
 =?utf-8?B?VDJNa3pNcndXQmtqdUZGUmpYMXQvSzJWMzUrdXhQU1h1MzFjUVZKV01oOXgz?=
 =?utf-8?B?YUEwRmk3VE1jOVpqM1VPRFZjNmxDTlZveUlUTFpWMVBNeTBwMGpxL2VsVGxo?=
 =?utf-8?B?TWJCaFc0ZkNoYStDNHNVOGlBQlNROXNxMmNLM2RQYTBtSk83a3hXTmxsZUZh?=
 =?utf-8?B?VGRtSmxZWTk5Zy9LVnJrLzZ3dnc2TnI5ZW80UVdIcFc1eWhZUFM4c1ZwTjRD?=
 =?utf-8?B?blh0ODhPUzhRU05tMW9NSGJ0ejNTcHRoeVM5aXMwd2pGeUxyNW5pdkZKSGlr?=
 =?utf-8?B?ZjRCcWE1ZThrQ0FweTlhNFhLNm82eHBQdzBsODdoUy84R2NWQWtiaWxxbGgv?=
 =?utf-8?B?ZUZIMG45Q0FsT08zUVlPck5BbUpsQ29IT1k0R3dMNzNGVVBkZ29DdTZmYWho?=
 =?utf-8?B?STlOS29lZVphMDd4YTY0SHIxNEV4NDVJZy9HdWwwTnVQelBDNkVhNVI3Mlpn?=
 =?utf-8?B?eUlyTkNEcnJaaVZqZDA5dmpReUdWbkJmTGRNUVdZZUtjclA5aCtjZmJZb3Iz?=
 =?utf-8?B?Ui9ycU1FR1orRjhFLzMzSFU2aUcvTStvWlpBbDgrT3FySTFxTlh4bjRDOXJm?=
 =?utf-8?B?djVQMXdrK2wwZ2hoMUJBOENyRnBHeG5WTWYxYUVneWZuUzIzcXdsOEtTUE12?=
 =?utf-8?B?aVFadTZneDhTUDkvVm5FcXUybndOeWt2TUxXSTFHenpRb1JZcDNjQjc5VXhp?=
 =?utf-8?B?NndHdUM4WWY4dXA5UjJPUjhKSUNGZkNGU2cyZW1jd0RGd3RBS3NHanMrYjQz?=
 =?utf-8?B?ckU4bkVzQmNXYy9MWWJPREhQQ0x6TDdLMHJNTm9sa3UveDZ5dWo3M3p5N3lW?=
 =?utf-8?B?RnFrbHl4cmNHZXNzSW1WeDB5dkxLWFFzQUYxR25XQ1Q4YVhwZ1NYaVJNdklu?=
 =?utf-8?B?ZkE2cUxlc1RaSExEVzRqbmtQTTlEaldSSWtaUVRzaldlanB5TWpxNE5PTUt1?=
 =?utf-8?B?R1dIOXJUaDI4NElST1c2dFZsZ1RJYjlXMzZTT0R1QUhaNHdEMWlZQ1kyaXkv?=
 =?utf-8?B?Wk96Q0JrQmxBQTVsL2xpbHlOeWNmVERMc1g1MWVtRHpiTSsyUUMxOGFuZS9o?=
 =?utf-8?B?dlJWWU9pWEdHenY4cWIzWjdTbVBnK0UybExRbUlNZlRJcE5vUSs5MktkNGRp?=
 =?utf-8?B?OXBmUWpyejA1MVpoYWNWd2ZwOWFsWFJTU2VHQSthR055S05yYjFvVVdmTGdT?=
 =?utf-8?Q?3EDwp/FAmYhGRgyTnxt8mEJdB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 452804c8-e390-4eca-a239-08dca4b651c3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 10:10:14.5426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APxix7jydks1tVmWug/+CIzZXdHef0WiTvjOX0P3XjQqWJ1T244PwzAAZIxLP5tfR8PbtfujLpzy1WlZPG6Mwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8599
X-OriginatorOrg: intel.com

On 2024/7/12 08:11, Jason Gunthorpe wrote:
> Relying on position in the enum makes it subtly harder when doing merge
> resolutions or backporting as it is easy to grab a patch and not notice it
> is a uAPI change with a differently ordered enum. This may become a bigger
> problem in next cycles when iommu_hwpt_invalidate_data_type and other
> per-driver enums have patches flowing through different trees.
> 
> So lets start including constants for all the uAPI enums to make this
> safer.
> 
> No functional change.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/uapi/linux/iommufd.h | 40 ++++++++++++++++++------------------
>   1 file changed, 20 insertions(+), 20 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

Apply this patch to 6.10 and apply a WA patch[1] to make the iommufd
selftest functional. This does not inlcude Baolu's PRI series. Did two
tests:
  - Boot a VM which uses iommu nested translation, and run a test within
    VM.
  - Run the iommufd selftest (iommufd and iommufd_fail_nth).

Both results look good, hence,

Tested-by: Yi Liu <yi.l.liu@intel.com>

[1] 
https://lore.kernel.org/linux-iommu/20240111073213.180020-1-baolu.lu@linux.intel.com/

> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index e31385b75d0be8..4dde745cfb7e29 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -37,20 +37,20 @@
>   enum {
>   	IOMMUFD_CMD_BASE = 0x80,
>   	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
> -	IOMMUFD_CMD_IOAS_ALLOC,
> -	IOMMUFD_CMD_IOAS_ALLOW_IOVAS,
> -	IOMMUFD_CMD_IOAS_COPY,
> -	IOMMUFD_CMD_IOAS_IOVA_RANGES,
> -	IOMMUFD_CMD_IOAS_MAP,
> -	IOMMUFD_CMD_IOAS_UNMAP,
> -	IOMMUFD_CMD_OPTION,
> -	IOMMUFD_CMD_VFIO_IOAS,
> -	IOMMUFD_CMD_HWPT_ALLOC,
> -	IOMMUFD_CMD_GET_HW_INFO,
> -	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING,
> -	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP,
> -	IOMMUFD_CMD_HWPT_INVALIDATE,
> -	IOMMUFD_CMD_FAULT_QUEUE_ALLOC,
> +	IOMMUFD_CMD_IOAS_ALLOC = 0x81,
> +	IOMMUFD_CMD_IOAS_ALLOW_IOVAS = 0x82,
> +	IOMMUFD_CMD_IOAS_COPY = 0x83,
> +	IOMMUFD_CMD_IOAS_IOVA_RANGES = 0x84,
> +	IOMMUFD_CMD_IOAS_MAP = 0x85,
> +	IOMMUFD_CMD_IOAS_UNMAP = 0x86,
> +	IOMMUFD_CMD_OPTION = 0x87,
> +	IOMMUFD_CMD_VFIO_IOAS = 0x88,
> +	IOMMUFD_CMD_HWPT_ALLOC = 0x89,
> +	IOMMUFD_CMD_GET_HW_INFO = 0x8a,
> +	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING = 0x8b,
> +	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP = 0x8c,
> +	IOMMUFD_CMD_HWPT_INVALIDATE = 0x8d,
> +	IOMMUFD_CMD_FAULT_QUEUE_ALLOC = 0x8e,
>   };
>   
>   /**
> @@ -400,8 +400,8 @@ struct iommu_hwpt_vtd_s1 {
>    * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
>    */
>   enum iommu_hwpt_data_type {
> -	IOMMU_HWPT_DATA_NONE,
> -	IOMMU_HWPT_DATA_VTD_S1,
> +	IOMMU_HWPT_DATA_NONE = 0,
> +	IOMMU_HWPT_DATA_VTD_S1 = 1,
>   };
>   
>   /**
> @@ -491,8 +491,8 @@ struct iommu_hw_info_vtd {
>    * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
>    */
>   enum iommu_hw_info_type {
> -	IOMMU_HW_INFO_TYPE_NONE,
> -	IOMMU_HW_INFO_TYPE_INTEL_VTD,
> +	IOMMU_HW_INFO_TYPE_NONE = 0,
> +	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
>   };
>   
>   /**
> @@ -629,7 +629,7 @@ struct iommu_hwpt_get_dirty_bitmap {
>    * @IOMMU_HWPT_INVALIDATE_DATA_VTD_S1: Invalidation data for VTD_S1
>    */
>   enum iommu_hwpt_invalidate_data_type {
> -	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1,
> +	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1 = 0,
>   };
>   
>   /**
> @@ -768,7 +768,7 @@ struct iommu_hwpt_pgfault {
>    */
>   enum iommufd_page_response_code {
>   	IOMMUFD_PAGE_RESP_SUCCESS = 0,
> -	IOMMUFD_PAGE_RESP_INVALID,
> +	IOMMUFD_PAGE_RESP_INVALID = 1,
>   };
>   
>   /**
> 
> base-commit: c7a0991733cc7b05ca32217c156f7030617f5879

-- 
Regards,
Yi Liu
