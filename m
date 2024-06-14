Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D3D146A86
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 16:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718383614; cv=fail; b=KiCUvRGl43/wvnAgAcVf2M+l5nxIwscfaoxOSMqSrtJh0ZhRGTZO1nD2gWa4wz0DO+o8vIfW78HojNOfpGfbhoO1hS/CPPkNyxoHG/qCJeC/+eIyeZmxEgO8HqMO0rG4ED3vcqQJ5H6XrtddR1bDGrgo+pCqMfdY/ejJW+/QglI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718383614; c=relaxed/simple;
	bh=uA1s+NXwOUYoRL7lazTQV6Bkk43+Ilq+zeQ8hTpRGsI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sF2UYcqCNitEdFNzPqdpL99E28ToXJ9xQkgGLw/riBaK7l1eudi1dXuszTdcw+4q/5Hq2A0Egwq+LP+IUO+NnuNbO6HoTSKw7yHyc4RZCuufUZuVXD+0K2a1IXPrLP4BIZSPjSgOvsIgmQmqwtI67BnpMB6vaU0MGAfvBn0RFuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pnr01JJX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pnr01JJX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718383613; x=1749919613;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uA1s+NXwOUYoRL7lazTQV6Bkk43+Ilq+zeQ8hTpRGsI=;
  b=Pnr01JJXz3DRJU2lFcGapztzNhouRGccOtWPaQ0XbDq6I+pVVbb7qanG
   PyLjG2yxXtr2I2L+se33c9EjBT9mhJazwSCPZimB/Gdr3qGbCGx5vQrqO
   Zo3H4jLHBKjKIe/bZh2Cia5C57MAlotwKntnVIOPvlHE/sa82v2wVtdt5
   wfaQ+XBNluUu7wVuV0mVpDXLbp1b/U7h+TTyZ9Rqo/9NF2aInhzUTp9tH
   a7bG2OHI/g9kSqLW20VqtaMQAMTxjj8DgH7FTLdJ5HkN+sO7b58Tzzg5G
   ovlxyTK5wG2OCTI2IPgzllcqELZfNHK7+8SK6VVAVRmHsYVi/FElhqW9f
   Q==;
X-CSE-ConnectionGUID: ux6a9NJgTq+i4JMGQmliyw==
X-CSE-MsgGUID: ySW8hFK2Q0WLhbsLZrQgmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="15115617"
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="15115617"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 09:46:38 -0700
X-CSE-ConnectionGUID: AjCg5FDSScmfbJc1ZiN/EA==
X-CSE-MsgGUID: q331oxM8QDGDuJh0OcSmuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="41274035"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 09:46:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 09:46:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 09:46:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 09:46:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUeExs/zKo3TG7qbH42S1ZXsslyByS3w79wX+UOTImeHAhHRMa2EVigzPuKfxc/ZnIX794cymbzK71PoDJpLT0bYM+VPb3TeFnJdSN3Upie6TwQ6lMZ47pvQ+XE1JVIWudkIrOtTeeTBoSr2bsINSQDtiPAfgoYmRSu3dyYt8VL7VyxvkSnzyP/PLvEr30sZMyugeNC8+oSviCcSra2l9XSij3rf1lDMxsfX6aS633UgtILznmRxdcOw8uoV98wccLIffmPeS7ObLRyIqE9xvMhfNvNgkZBNO6mO8iboAoPlFujMV5XpXJgZ99eFyci/GHoEoWZANRK8g6LfueZtBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xv3X6RxYpzEmohMROwt5ipNd00Qsn3B4JwcTLDWTFm0=;
 b=mkc6UCIKWsoOfAxE732XU+IhHr2KMBwEaiMqC2itnGp4y1P/Sq8fovBi76tuoyR5uzHUhJPM0oDNb6EcW3EtCO21F2stXrGERrWe7CrkSj+j6lM90HQ4zf5fRrfgXEyK8/d7HEvvM2sOuevs2zNy+PguLsUmiOcVLRKcBqjEjyGooR3WwOzpB9NH5tt+rC33FKMDXi2xmWM3z5quVhfkPWpON2TgQEDMjlx3vqKGJgNCJOQElJSP/gd4ofhBQeyfqPY3vnC8Lf1sHkJpaHTvgqAqoBIOTZkkguvoYD/COpA9ak+J/S4STB6075dIvjzWsk4pbn4+3cqaSYHOKRf/0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW6PR11MB8437.namprd11.prod.outlook.com (2603:10b6:303:249::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.21; Fri, 14 Jun
 2024 16:46:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7677.019; Fri, 14 Jun 2024
 16:46:27 +0000
Message-ID: <f57e9cf2-35b6-401d-afc2-8d11b22836c2@intel.com>
Date: Fri, 14 Jun 2024 09:46:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
To: <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu
	<fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
 <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:303:8f::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW6PR11MB8437:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8ccf84-ef90-4132-0a6c-08dc8c9188c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QWgxOHpZQVI3cHArR2ZlV3o2bTNrdzh1a01adjIzYzBXaktwNU9VeEF4VFlY?=
 =?utf-8?B?aDlQaE11MDdEZmJJYkthRW9nQlVXRkRtMzRkNkE3N1dyY2oxUDRSN0dCNm5K?=
 =?utf-8?B?cDErUW1HVWdua3BzdURLRHRTVDExM1I3bFo2OCsvTTFvUlgvRGNnWWFMZmpk?=
 =?utf-8?B?Y04vSEVYeWczaDNsOEI0OWlTcldxQ0hBQjhHL1g0Z3UzWWI5NTVNVUtGVXc5?=
 =?utf-8?B?U094Rm5rU3o3RXcyZ0wrcnBqN053Ri9rQmY2U0ZKSGdPUlVwVXhOTWpUaVdi?=
 =?utf-8?B?c0J2RGNzam5UMUowZmc1SzBDMnlkZTlpcGIveS9UdnR3b2dGUTNNSnJhRUs1?=
 =?utf-8?B?dVRVeWZpbFlNVGFWN1IxeFQ2dDhFOHR4dVRNZ3pUaU5nNlduZXBGaTRhMitj?=
 =?utf-8?B?NkNmcnZreXd5WmFlNEo0cnVrRHBweHpxNnBRWGRLVEV2dG0rWml3bVZMaHJ4?=
 =?utf-8?B?cUVnSGphVm8wc0g4ZXlYS0k5MGhCUFFpSEo3M2dJbUZRNHlzY0t0NmtDeDA4?=
 =?utf-8?B?YkZCY204ZzNjWlBiTjJQTThreFJ5OU1IVHJDZC9RYmdBeU9jUXBTaDlGUzFn?=
 =?utf-8?B?S3ZGTDY4VVN1cXMvUmk3WERGUFlqVnZER0pBK3RIUTFldWhDK2QvQmZ3NCt3?=
 =?utf-8?B?aU1IdTJZQUhNSGFET0JsVFNtL2pYbm8xa1ZxQlc3dEkxWEFMRTVKQ1hrKzRp?=
 =?utf-8?B?VXlyQjNuRWdTS3p1MEJaY2tQWEdRMkZDckFuNkZUVzU2WGJubitTbi9zU2RE?=
 =?utf-8?B?aytUZmc5TnZGUVN5RDN4L1lRQjN0cE0yTll0RUIyWW1SUWZ3Zk94S0xPWU1H?=
 =?utf-8?B?ZVg1ZktiV1ExUWh5VzdDUVJDa3lVK25Eb3J3REg3VGRVRU1VZ2FnN0V5R0NU?=
 =?utf-8?B?dVZoNmxYWjU0UXRlM1h0VjhaOWFZV2hGV3c1bmZITG9OUnNpSUJWcGI0bFVY?=
 =?utf-8?B?eVZwVy9ZVEpCaGhsV2t3NzhmRlN4TlpyQTNNaWNuUE1UNGJoSkhHOXBrcHhp?=
 =?utf-8?B?R3RpamFyYkRhb3VqYTl3RmdRRTM5ejV1eW5qQ2pFblJmY1J1UmE5bytrMC9i?=
 =?utf-8?B?UE01MFF6ZG1uRXZEQlRob05wTXN5Umx6L0h3S1NPWkVyblVOQjFwbUlUV1pB?=
 =?utf-8?B?Q0tGcXptdUh2cFRvc0dqVWdoMTl6Zk5mUVQ1ZERzODZWVDBsNVVJTWE1RlNm?=
 =?utf-8?B?NjJZSUpsYU9xaFMxVVN0NExRZjNFeEFyVzNVOXEvZjhMOVlWWkZlVUhJeTUw?=
 =?utf-8?B?YXZQVU51MDhpd1BpWlhZcFkyUG5YSGQvMG5mUW4xRWhBc25iQ1l0OWlnMG9r?=
 =?utf-8?B?dWR0aG1DQTJYc2xIKzY0S0VaZmJKRzQwTjhPR0E2aGU4MEh4aVNCME9PRjVu?=
 =?utf-8?B?Q28rbDhGZzhuWXYxZjZWWkw0T0xSa2NzdWZycXdNVmJ0M0NWbkpzb2JGNk0z?=
 =?utf-8?B?WjNnbVFGYVp1Ni9QdGszU1ZINm55MDZqWGd4TFROTndMQTlZcHBZSG8ybkR6?=
 =?utf-8?B?aUtyVjUrcHNRYy9SdkEzWElhak5Md1lrUHhCWWl0MFlkVUZXaENydzVGZ280?=
 =?utf-8?B?V0RvNjQrdEcxbEdXVGtsdDJsMDY3dTkycFRHZlVrUnlhTzNoV3dYNEYzQ1dL?=
 =?utf-8?B?eTdheEVWaFV4RWdJQ3ZaSHlnV2k1ZXFGMGJrUWJ5ZURDM1ZHMHF4dytReU9P?=
 =?utf-8?B?b09PNGxnZ3VYQ3pWZlZPTlVHSDdGSzl4T3kxK2FTTUVsMHhkbUFZUWdmYmJl?=
 =?utf-8?Q?nSf0mdxdUVS5g7fC9TY1t83CpBR/yBfRy3q/HD/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEhkMmF5bDN4WWpEdjZ3Z3NWQlFBQWY3YWgzTURxRWg1d01IUjJvWmFJdDBH?=
 =?utf-8?B?L252b1Bma28rc2FYT1dGREVjTEF0MjlFU1AwUTVDdkMwcUdVdDlXY1NNTE9n?=
 =?utf-8?B?UE5jSFg0bTlKTmhtM1V4Nnl3ODk0cDZWV1I4U0wrSE82M2w5bGxyUDRIeWRI?=
 =?utf-8?B?djd3RlN2L05IMjJWalozZ1pRdGlYK3M1dG15dXFOVTg3Y0o4UnZKa0JvMFhr?=
 =?utf-8?B?VEJqUU1ERExFL24wN1ZNSzZsVnBsZjBwRDVDelN0QXQ5MDZPMU5RK0dWcjcw?=
 =?utf-8?B?RjlDeVR5SG13NXhpOVRzVkdPa0lWbVM4aGRjcTJSZEtGbnZlZlBIVkExUCt6?=
 =?utf-8?B?MVBTcDQzT0NDcUxGSFBtb0NTTGJHSzNMdWpsVnBwMkdIZzlWU0JtMnV2aVVu?=
 =?utf-8?B?Zk5DWndTOTJjQjVyczByMUVGVXc1VmxEZWF5Ykp3bllHQUZsZTREcm1EOWxC?=
 =?utf-8?B?aW1uWUJORmxVdW93c0JDUS9QMXZpZU04ZFpjSERjSFF1R3VHRE9nem1uNWlC?=
 =?utf-8?B?TmVWM2ZUWE4vMGoxSWVDWVBUR0I1ZUxrRkZlMDhkMldZMU8rK2hYQ2VQRmd4?=
 =?utf-8?B?ZFlPWExUcXV1NkVoRHU1ZTg5bUFoMmE5K093dW1rSUxUNWtUK0dkdWUxR2ZZ?=
 =?utf-8?B?cjVEbm9SckF5eDNtYkhZTm9WMlMwNGU5SEVjV2RDRi81TVR0ekZoT1BINmox?=
 =?utf-8?B?STBIQVVCZHYzamlBQlRIQlVyQTJEWDVWWkR2enlQT2hTVDE1V012SDJlUUdT?=
 =?utf-8?B?dy8vWnVibGFITDAyVkllVENjKzlGN2cwVjRYVEMyYWxMbW9DSFpEQnhEZi9m?=
 =?utf-8?B?SlA0RG5jb3pFMGZtWG9GcDdXcW1haXgrYjdEY2NnSGJrZWRCQkN1dlF5SU4y?=
 =?utf-8?B?ck5hdUZOaGw5NGhob2dSbitZMXRxMzdaTGhHc2Q3a3RSRzUxeXpNWTJEOUE3?=
 =?utf-8?B?ak5YN05VN0NidUx0eW9XSGp4YVFqRXpuNG5WM0VjZmZicnptQm16MDl3dXVK?=
 =?utf-8?B?bFhOc3c2dzZVL3JHd2tjM05DMjM5VGhENy9hTStPN3R5eXp1Q3NMUUlVTHlL?=
 =?utf-8?B?TU9Od2tzMHhNWEZQdDk0SW8vYUpucHF5RnN6Uy9hdXRLY0pjNXpIZ2k4QTJi?=
 =?utf-8?B?M214cnRISkVBS0hsRkMyTmhsZTFuWkpCYkc1a3VWR2pjckJqa1NqWENrOEQ5?=
 =?utf-8?B?M2xJZ2NiYzN0R0NkcEZmaHVjSVBZdlU1SWl1eVZIMXVEVXA1ZDh5VTBhV0Nh?=
 =?utf-8?B?WmtST2l5YjJDakdvSVdmRFhJcXJRNEVkUFAydFlkRGxpUlNUVkxoU2hmVmpo?=
 =?utf-8?B?WnJpNXFLaFJrRldZR1NNbkEweXBTeWp1QmVkSjJaQVlhV1l0SzUxeVA2V3BQ?=
 =?utf-8?B?cEtNaTVSNk1QV3RnNTMvU0gwc0o1L2kxV0UxZExqdXozbnp2VFJad2VTcVNQ?=
 =?utf-8?B?cTZjQmZLTnU0ZldHZnYzdzdrbE14RndFVmdJMURzbTdjcDZTVDNaTDc0TzVN?=
 =?utf-8?B?U1AxdjNIV2pibkxRcFRUUlB4SlYvb3ZTNTZIajJrZXVydmVMUFRIbkJ1eTFa?=
 =?utf-8?B?LzByUFF3SEt4ZDFqMm43dWVLb2VNd1E5RG5rYkk3VExaaGNqMFBKYlhOTy9M?=
 =?utf-8?B?aTVBU3hwQ2ozS3ZNbHNsUXk5SlJ1WmhNZUpscm4yS09DYkhDdnB1OFpNbVBU?=
 =?utf-8?B?ZjZCK09vVzAzc0pvRzd1Tkk4R0k5cWloSDF2NXBweFB1WTIxMXRNejBYRWVh?=
 =?utf-8?B?bVZ2eU5IQzdqWE5JdGRwY28yMVI2WWhEMTcvNEl0ZVJRWFQ3a2Zwd1g3ejEy?=
 =?utf-8?B?a1FBUXd2b2lmckNnWTBlcnlyaUVSQ2lPYW1WalhoR3U2UVBPaUk5cjNwQ1Fx?=
 =?utf-8?B?VnNOT3RJVGZGWjNTL3hQTXJYL1BwaGw4ZStVTU5MbUFmQmdjTkVMN1VIMTJr?=
 =?utf-8?B?c0d1MEd3VVlmVUhMV3lSSTdocHNaUDRGcWtoMm9lRTJzcXBtcXRnMEw5NVZZ?=
 =?utf-8?B?dHk4REUybHcweFR3dndnT3M5NzBkRW5SMm1PNk5rMnUxeUkzbW1KbC9BT1hG?=
 =?utf-8?B?YjdQVmd1M1B5T2RpclpycVNiQ2p5S0J0TTVtc1lIOEdxeHE5T0xFZGRna0RO?=
 =?utf-8?B?c2FVSDdic1FPWWMrbFRpQm5qVXc1R0dEQkZvS3NMY2hPQzBib0JmajJBbldh?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8ccf84-ef90-4132-0a6c-08dc8c9188c3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 16:46:27.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HipWmpYcNEmgvjmfRAF9dn54HCofeL1OeKVqojs1j378nGq1iejOX9VyGh7+k+/UMpsY/DImzW7Sec1ARmW8eMPumlRFJvVCbj9ffKNFVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8437
X-OriginatorOrg: intel.com

Hi Babu,

On 6/14/24 9:27 AM, Moger, Babu wrote:
> Hi Reinette,
> 
> On 6/13/24 15:32, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 6/13/24 12:17 PM, Moger, Babu wrote:
>>> I may be little bit out of sync here. Also, sorry to come back late in the
>>> series.
>>>
>>> Looking at the series again, I see this approach adds lots of code.
>>> Look at this structure.
>>>
>>>
>>> @@ -187,10 +196,12 @@ struct rdt_resource {
>>>        bool            alloc_capable;
>>>        bool            mon_capable;
>>>        int            num_rmid;
>>> -    enum resctrl_scope    scope;
>>> +    enum resctrl_scope    ctrl_scope;
>>> +    enum resctrl_scope    mon_scope;
>>>        struct resctrl_cache    cache;
>>>        struct resctrl_membw    membw;
>>> -    struct list_head    domains;
>>> +    struct list_head    ctrl_domains;
>>> +    struct list_head    mon_domains;
>>>        char            *name;
>>>        int            data_width;
>>>        u32            default_ctrl;
>>>
>>> There are two scope fields.
>>> There are two domains fields.
>>>
>>> These are very confusing and very hard to maintain. Also, I am not sure if
>>> these fields are useful for anything other than SNC feature. This approach
>>> adds quite a bit of code for no specific advantage.
>>>
>>> Why don't we just split the RDT_RESOURCE_L3 resource
>>> into separate resources, one for control, one for monitoring.
>>> We already have "control" only resources (MBA, SMBA, L2). Lets create new
>>> "monitor" only resource. I feel it will be much cleaner approach.
>>>
>>> Tony has already tried that approach and showed that it is much simpler.
>>>
>>> v15-RFC :
>>> https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/
>>>
>>> What do you think?
>>>
>>
>> Some highlights of my thoughts in response to that series, but the whole
>> thread
>> may be of interest to you:
>> https://lore.kernel.org/lkml/78c88c6d-2e8d-42d1-a6f2-1c5ac38fb258@intel.com/
>> https://lore.kernel.org/lkml/59944211-d34a-4ba3-a1de-095822c0b3f0@intel.com/
>>
> 
> Went through the thread, in summary:
> 
> The main concerns are related to duplication of code and data structures.
> 
> The solutions are
> 
> a) Split the domains.
> This is what this series is doing now. This creates members like
> ctrl_scope, mon_scope, ctrl_domains etc.. These fields are added to all
> the resources (MBA, SMBA and L2). Then there is additional domain header.
> 
> 
> b) Split the resource.
>    Split RDT_RESOURCE_L3 into two, one for "monitor" and one for "control".
>    There will be one domain structure for "monitor" and  one for "control"
> 
> Both these approaches have code and data duplication. So, there is no
> difference that way.

Could you please elaborate where code and data duplication of (a) is?

> 
> But complexity wise, approach (a) adds quite bit of complexity. Doesn't it?

"complex" is a subjective term. Could you please elaborate what is complex
about this? Is your concern about the size of the patch? To me that is
not a concern when considering the end result of how the resctrl structures
are organized.

> 
> For me, solution (b) looks simple and easy. Eventually, we may have to
> restructure these data structures anyways. I feel it is the right direction.
> 

I understand that it is tempting to look for smallest patch possible but we
really need to ensure that any work integrates well into resctrl. Doing
so may end up with larger patches but in the end it makes the data structures
and code easier to understand. I specifically find the duplication of structures
troublesome since that requires developers to always be on high alert of
what code is being worked on and what flows the particular code participates in
since the duplication results in members of structures be invalid based on which
code flow is used. To me this is an unnecessary burden on developers and against
your original goal of making resctrl easier to maintain.

Reinette
