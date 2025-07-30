Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31421CC48
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753907295; cv=fail; b=OOMtoYwwfPbUunIp0mq9ZmWC2uCGjvDdE5PhV6Bb4tYxEk7kIgpucYZr+sDvoxrJP7eJ66Qptj88phetjBIOZOQ41iB7usYctN1VnyvA6r5sv33pxtR6BhRlodwPewdwTkHvVyJfZk1qa+d7MBWTXkFH2jWOnr0IcbBAwcBghwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753907295; c=relaxed/simple;
	bh=DFfzpzihPplfRv6GvX7NJFsoH4ceOAA7SALJeuI7r9A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pNQqINxvJptGBHUkuefRKevfj/gY+qPUl8Cd1OSqOklZvgYCR3vQceuxG7QQozt7MT4FeYuZMYf4UizVJYTSDO4Q1kpfKF0WpC6gLsyn8qch1oHFMb/FNWmNW7TcA/3eVmlZZv4ecjocnhOr9wbAXLfXocAAlXZ+S9upEAytut0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8sNp30F; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8sNp30F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753907294; x=1785443294;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DFfzpzihPplfRv6GvX7NJFsoH4ceOAA7SALJeuI7r9A=;
  b=f8sNp30FgFlm4slsyCpVoeuCQbYTxVExSIFnYNzfYXUCXDz1QS3VEHIq
   VDPHVCdSF188SQqC1o7BMY8TG9Y8iX701OCnocnBbHOTrDxS3Gx9+LAx2
   abXtapkrKNUa6iFoyIAPLEOZCw2hgeTr6d78ETSiLwDviEkfYzetM18Gp
   31Jg2Xz217pNoJJ1aCLVHNp1nZqccWI0Nm+l8+GOGa7joqHMI5rIF4byr
   oRVZvbmnbw7WkhVD4zowE65TzwJ9Byu8Uin0IO6EKhMDTuk+XEklUQCLY
   sCH3zy5X0mi27tET7YlYkGqvqud1nXoupRb0ga8fOm7eOhRWTQzwraKJd
   Q==;
X-CSE-ConnectionGUID: e8WI39MjQLuRYxXAw5IuaQ==
X-CSE-MsgGUID: yFzq1DOLS2GlijpQjLesAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56311563"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56311563"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 13:28:11 -0700
X-CSE-ConnectionGUID: Z/54Vq69TDy8Z+hudxgV7g==
X-CSE-MsgGUID: u+j/oV99QWq5wCW9yyJidg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162961474"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 13:28:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 13:28:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 13:28:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 13:28:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTF0JGYxSPs5rFFaRgIjUvzC62p8v3bCsANuJ3CHxgJNN3ccVpcEk0R0C8xMSn/29EqF357qpYqwthf51zyPz4jJSklrkxLfKIaS1Nd1w/JhOfBz3S9J233knWa4TONt2s9PmpEdS/hOk3G/sq7hRQAmx4jpDHGQBuiFVGqmyKq6R4vJVpabBERwKfQt4OizAqXNnYBoM6iNCcDHVhQxulveTAIAkyuTl5RQZr9SQBzh16U3qpLtXLGIH7soDgfKLvDtXxMafhgOclr4DmjlBGDBxBVgFWMq0UTewrmicvKBALXdgoSoE2qD6HRIoQDh9adTbBEXzDNh0R6lGEIeAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UznmmTX3IeyDn9fW0GwgQq8SoBKYK/UoUyF/6GIZrcc=;
 b=elKASZU9B08Inv1Y9SJGfsUGPwCrvDsyflxos3UmeNafKHTvXhARU4xRZ6LPhfTeMRu7zOAxqKtDtmSAe7K23AjRErkkuqGBIMPNwqmf56Z0NHSi71WFlhiS7lKJIxi2uX0+XoatV9ky4Z3ouJbP4BbbycTNNfu+u2O7E6H9xEYg050ajzEDBrsEUji7GEXyBssFKb/omo3DYCLTBlX71HZKPt/9FbUt7tv4ZwbegNDCheCidUUTHKe4HsAHdBLFq5NVGpx0voCYFJHkwc6Qj5Vm2RqBM9RsFxIrCHauHLERX04tEGm9kj9IGVUS58cmlutPZ8s523ocTKaveJ8bGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6141.namprd11.prod.outlook.com (2603:10b6:8:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 20:27:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8964.026; Wed, 30 Jul 2025
 20:27:37 +0000
Message-ID: <866fddd9-edff-4a81-8b11-ed017b9a9d9f@intel.com>
Date: Wed, 30 Jul 2025 13:27:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/31] x86,fs/resctrl telemetry monitoring
To: <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <91258652-7573-4065-9590-3d03e13c9e0b@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <91258652-7573-4065-9590-3d03e13c9e0b@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0354.namprd04.prod.outlook.com
 (2603:10b6:303:8a::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7a9b54-ea7e-4b87-cc19-08ddcfa7862d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d3hWUUNxZ3drOHdmb24vU25hZUJ3OU9aM01wVEtwbVU5bXZXR0ZlUDlqeVhR?=
 =?utf-8?B?YWZnWE92Y0dzL1k4ODZzeGszTnRpNUMzNHNvSjhzV2VOSHduOVgxMkprU0hW?=
 =?utf-8?B?Z2p4aHFkWm9CNFcrUjZtdFVsVU9CaHByS0R4VTlURys0d0paNE00SUFjNHVC?=
 =?utf-8?B?S3MvbElDcUIxTkIySWpWUmdHeU9yNW1ndU5iKzEza2NLRjJGd05KRkY4U3k2?=
 =?utf-8?B?SmtKWFJxTFBNaVFzOC9BWHNSa0w5NnZodGl5VVNpdmVlUklEckwvZnZnQ21t?=
 =?utf-8?B?NldwTVl3cFdUOUJDWnVKWEU1UndieFFGU2l3S3dHUEtSZUhLcitNeUh4SWt2?=
 =?utf-8?B?ZVYxVUZsWEVjYkxBOUlaWEVJRVBQcVphQy9JV2tBMUF3VWpzSjBoTVIrcU0y?=
 =?utf-8?B?WVQ0eHhxUVVhQ1l0WTJwSlFzY3plSU02K2toRHIrUWtBOVdwVkthUGFTRUFj?=
 =?utf-8?B?Ry9MRE5PbGI3WEQ4bUhJbllIdlVYeE1XVUdiUW1kaFo1L29lMEJ5bUh1ZWFV?=
 =?utf-8?B?V29vSWFQdXpWdXJtZEdEQU9IaEFZM08rQ1BhUFRJY1lsMXlJaTlZaU5tUGFW?=
 =?utf-8?B?b2Zjc0M0RWF2REJwNzhQMlVzSzExRWxhT3c4MjN3LytaRTNLU0NiczFTVHlm?=
 =?utf-8?B?Uy83OTRaT2kyUUduL2ZUMkxpenZGK3VYOHdJSUdESFp6TVNIejNpRyt4dmg1?=
 =?utf-8?B?UWw3MHdKQ21SeWtjSlZyeHptTW9mbmhsVTN2bFowMUNJYUovVS9CR0xNeUZN?=
 =?utf-8?B?VEErRjBBek9WdWZpWWRKUk44ZzBYOGRaV1pncWR3d3VsT3pHYVNPamczZUVF?=
 =?utf-8?B?UkZLckEyemVPT2JTMVJHV0dob1A1ZVJWSVZxSXJkcEROT3VuYWFrMFNaWDdl?=
 =?utf-8?B?dWI2OU5QaVhVbFp0aXBUcWkzWkN4L0RyOEZJODNMbXBGUVZrWXY1YXZRVzRy?=
 =?utf-8?B?MGVkL1M2SjJyK3VVMXVRWTUxL0tqdlpKak52aEhWRHByTnR5Zmw2WDhxS0pD?=
 =?utf-8?B?WGJQVHU3U0lKNXZJdmRlNS9Xc1NYb3hiNnY2dmY2UW5zT1BMc2hueG9HQ2xR?=
 =?utf-8?B?cGJaMW81UERhODlFbTlaOUUxcVRwcGhQSHZEMU1iUjdTQU5SVHBKYWVJSXNO?=
 =?utf-8?B?WlFaMWRMR2NMMDNPLy9OQUpkekUrV3JENTVNd245ZWhVdUlXYlBQRTRaS3pC?=
 =?utf-8?B?T00vOW9ubTRsNGw2SXp2Z1pNSHJGVk1pZFBJbGUwOWVZeThUWm0vKzJxMURX?=
 =?utf-8?B?bG1vaEhHTGNCMkwyRk1XVU1FUEVHdzZDU0tWbkZ4RVhGV0xLejRRaWlXeDVr?=
 =?utf-8?B?YmRCL3RuZmo5eFhuaHI5aEtKWmRKdHFpS2VlRWtxMjBvbXZmZ1FnTEpiYVpV?=
 =?utf-8?B?aXdOb3RRaWR1bENLRHpFTEg2TXNyRU03bE5pRXZmMHIvRlU1TVl4enVJeVU5?=
 =?utf-8?B?cndWdUNHYjd2NFVoZW9HcUFyY09USUViUkZ3K3U0cU5rYzVoV3pSeDVDaWtw?=
 =?utf-8?B?NnYxbFFuTkNkeFhidU1XMDJTeFRDdnhyb1RUa21QYkorbEx5aEc2QUE1VnBm?=
 =?utf-8?B?VFRlOHNHcHgxQ094TUtKWFZTdHNmVUlyUnFuUFhJTkpoSHcrTmZFaFZ4MkNj?=
 =?utf-8?B?QkVxOGh3bkFubHdoZVdRV0RXTVNsYkJXdlpFWHZ1c0JtRTRjNXJ2akw4alhJ?=
 =?utf-8?B?L1NKZWtNVFlmTDNqdzRueDdCVCs1MzUveW1nSkJxczZIaUlaSXFKUU9iaFdj?=
 =?utf-8?B?V1pkTTZ5TDdWNzhvYjNjWWVlYUZ5ZFRJVE1uWGhDOW9MQTE4elZid2Y5YkVD?=
 =?utf-8?B?RHhDa0ttM2RUU0QxcU84alFSNjQ2cU95d3dxemRWTkZtQng1QlJFbDJBRWpF?=
 =?utf-8?B?cGFMamR5cE1PajB6WUpJRWF4bkZROTVXWUpZejZ1WDFXdDlMVDBIMkt1UUlJ?=
 =?utf-8?Q?5hS1+LkufI4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWdIQk4ySkYvc0dQWSsvRkM3VktBNEdLeUVhbTN0MU9EYldMRkN0RzdUK2p0?=
 =?utf-8?B?QUdJQjRiNWQ0SzFieng5eFpoblp4WnRWQS8xU2xtcFBJNWVxb1I3aThGU1Fx?=
 =?utf-8?B?Rm15Rlk5S2hYZWYvVnFzdjEvTmxqN1FSUTVVcDdSVXptSVcxUmZTUitWSjZU?=
 =?utf-8?B?Mm93UjI2OERXL3lXRmNZbmk1N1RiVnpSNmJ3MHVHTnFqbmgrZ2xMbnZ0YnpC?=
 =?utf-8?B?a2dmZHZLWGxtY3J4Rmp4c3RhVmlyakh1czZCTnlPY0RBRWlpNHp1T2pQR2I2?=
 =?utf-8?B?TjllRG8zVnd4Kzk1RHBTenZpYU9FM2RwRFVUQlJuNElPc0w3L0NDNVVYS290?=
 =?utf-8?B?MGFkbytORkVyaFJQRW9NSkQyTElYNk9INFp4UitSRWpSSUlIcU55RnlLUVBR?=
 =?utf-8?B?SzBHR2Vkd0Z1dFRaWGV6bk15MGRKWUxZbFBKZjJRVlhrZHhYNllNbUx1S2M3?=
 =?utf-8?B?QklPWEpnQWZObkM1RnAwaVdaN09pQWlQc1BnVzNTTGhRd3B2UVJHeWUrN1Bk?=
 =?utf-8?B?TXhvaytnb0ovT1ZNbG9pZXZIWnR2Y2l0NjI5TkMvR20rMlJZNWNZUlR6ZHg1?=
 =?utf-8?B?YmlIbThSd1JWR2xZS1c0YnlsTDlkRTV0WElLRmtWaldvdDFnQmNIN0ZjYjR5?=
 =?utf-8?B?WlBYSzMvMlBCbGlaQmZESGkra21XUExKbTBHUmhUaXB0YUdnTUxMRDB1Vlcy?=
 =?utf-8?B?YXJLLzd6WXB4NGV6eTM1eXprVVBpVThPK0tBMDNXRWJJSFFObSs2alpEaElR?=
 =?utf-8?B?UHFodVpKVm00Q3JXbkZZekEvZkx1QVNDV3VweDF4UnB0SDdDdlMxV2o3RVFo?=
 =?utf-8?B?cjExRmxra2xuSFNqRnlqejNJRjJMUXNSeFBCc0tWenZFKzh4RDhRYmRnVVBS?=
 =?utf-8?B?Qm1UL3JaOHgwc09YVzNpUlBkem13VmdVYllLNWtmUk9oVTBHQytHait1em1t?=
 =?utf-8?B?bXhHSUFrWENQaFRWTWlEK2lmSkR5NENUZTRINWpoZjdOM3lESFNCRDI4VVd4?=
 =?utf-8?B?aHM3SXc1NmM4OVVKb2psMG5aSmpiZXIzb2N2YTZtY016eHI4Q0MwZjZQRXlU?=
 =?utf-8?B?eldoMGhKQW9tQ2dGYXExa2EwMTBJRElJR0FMN0t5dU5tMmM3NndKYUx4RSti?=
 =?utf-8?B?UVpyM0grR3NhWkt4alY4MVg2cGJrakc3V2lqQ0k2WFFZNUxKQ2hyZnd5ZGNR?=
 =?utf-8?B?QUxOREVIeERKUmdieXRmc0EzZHg2R2VYVFRHS1ByMFl1UmxtOUtHOXdvNkYv?=
 =?utf-8?B?UmdpWjVwOFI5aHlmUEMxSHBqcW5RSjkyRGZHYmtSbWhFempNeFZBdjNGSmNJ?=
 =?utf-8?B?OE9FY3NvUFptOW0xWDMvMG9OcmN6cHU3KzA0RmVydkJyMnVQME5wTzU1aEhh?=
 =?utf-8?B?RThNKzc0aTZkNmRCWFV6bTRLZjNmTDZ0OENORHg2bFRhNUZGdU5vaGtpaENK?=
 =?utf-8?B?YW9VZjRvczMraEE4Si91TkIydGJNL2dVTXFvZFowTFFwblZwQk1OazluWklZ?=
 =?utf-8?B?bitjaUp3TUdGaXBaRkJkVUprTm0xUlJzdy8vTXVJczQxMERvV0lsTXZjVWVK?=
 =?utf-8?B?bmI5SlBDdStUbStCM3Z2NUJpT0FOZE1leHFITkt6NHpwcXZZZGRHaHZoUlgr?=
 =?utf-8?B?MVcrM2FubGNqQ21keVNINXR6SXc4d3dBaStoemVQajdOcUg1azlwTDU2V0kr?=
 =?utf-8?B?RGY4WUMwMmlobWdpKzY2NW1hTmc4cVhtTm13UjhBZjdWUzdwMW5UQUlDUDVH?=
 =?utf-8?B?SmxxWnN1ZDVxZVJuYklyc3Nac1J1b1AwdGFQT0FPVkxpMHpNQlQwS21yckU2?=
 =?utf-8?B?QTFMbjZ5WmFlU1p2dDAzWmUvbThScis3K1dJNXZqR1VFMGdEdlVVbms2Nk5M?=
 =?utf-8?B?akM0MGx1bnUwK0E4NjFHZmNoK1BUeWhTVVhJMFpYWGlMOFdiWnkwN0t1M253?=
 =?utf-8?B?QmZyYVA4OEZKN2xvR3ZQZnhKWlk0dFBYMjVoSXYyYXl3MDlST014WUhSUXhU?=
 =?utf-8?B?V25RdW5ZU2lXTVFmTjJJYzNQWWVNamx5eElYU0JKb0psbFVRUEdySTY0dkdt?=
 =?utf-8?B?U3pRUi9GWWtGdGdxODkwa0MyTERHM1RCSlFObitYTG5kSlJmSzdzRkR3a3RF?=
 =?utf-8?B?V0pXUFpyaEVobG9JcjhzSGFrb2dTTmZGQVp4Z1drejNNZUxiT0g5Wk9qWWcx?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7a9b54-ea7e-4b87-cc19-08ddcfa7862d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 20:27:37.5594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeXoMGsDCSN5jimexc00VA8mm3mR03Muw+ah1h1benyfmS+ykM8H6EzQ6L6hHJxU8xQeOfeYCeg1At/ygicm4xUXFP5YAQxGFfD2LxIjDPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6141
X-OriginatorOrg: intel.com

Hi Babu,

On 7/30/25 11:42 AM, Moger, Babu wrote:
> 
> 
> We both(Tony and me) are carrying these patches. As we are in a merge
> window now, any plans to send first four patches for 6.17 queue?
> 

No. Any resctrl patches targeting this merge window should already have been
merged into tip's x86/cache a couple of weeks before this merge window opened.

We can definitely consider asking x86 maintainers to pick up these four patches
when they start taking patches for v6.18, at which time one or both of these
contributions may be ready anyway. Will know better at that time.

Reinette
