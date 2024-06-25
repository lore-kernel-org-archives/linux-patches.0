Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86F417F4F5
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358141; cv=fail; b=aQJogeeNs6yZRrDUaz16mOYjc1hXKyINhE6CMtew+3A8ELQQdgbGFk0YuBUCctkdESZiSKY8DirM3ax/jBGrnWUWsOORfzmMVgC49sOPW4ceesiOvLoJ5HAbuyDb4EXLxDnqWVsN4XZ2kBOx74pHAHP9akO+VeLmgnRwCQCx4Ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358141; c=relaxed/simple;
	bh=r+HEctHINu2mOB/LgZ53QoNdKsx6PYNUI1J7JwLYekQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fIn3GpascU+nUFICWe686evOotN605ewrPSJxHYLphNnjtUHMFVyObn3PutXP6wOedbBpg+jzEPrh0RsFIHYKPZvu+5LZ82/xHUh4QHN5B3mTdsACObeEIQjfJlNPsZ3g+i2pwh2OduU887scwbKza5HXDLQtPBy6HAfQLjbnEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DWxuR6UW; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DWxuR6UW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358139; x=1750894139;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r+HEctHINu2mOB/LgZ53QoNdKsx6PYNUI1J7JwLYekQ=;
  b=DWxuR6UWIBr4cY2QpFfDFvRG8eft9+kBmd3BrztXx+EOolT656VHbyfv
   g4p3Bb4jzY3lUPOYHChuAVIpVT8B1d71JzSQg9y/LPQbl4xaK5lKlDdcu
   CiLESEP1xcNIQUl8fFOsHUcg3i6jMpDO7WWpyYsgx8NhldjXN0SQO62Of
   Y2FQPVHSZv9JFNXnBGkejhW4jErMq4UZ6V3owRrk8RacltA5GzHGPSP6Y
   /W0CNRQ9bNXqu3A2UjFWPc8MdH38uhV+rETjnblywgDwPRaXcbzdM9xS1
   MvUOpNDNx9EiuUCicYEfxOAhilyDqE0uzGS60CU4s6duZdsQDsw7CB8vN
   A==;
X-CSE-ConnectionGUID: IE6xcyGaRqm8Y6eKNkNtkw==
X-CSE-MsgGUID: tR3lBGmSTD6knLv9gBJPlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16551481"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16551481"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:28:58 -0700
X-CSE-ConnectionGUID: tNFD5mcWQ3aoTkWWPviE5g==
X-CSE-MsgGUID: pjjbStAwTjyoixO/ZaqlHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="43917816"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:28:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:28:59 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:28:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:28:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:28:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6XgvE96OsdmnGJLukkRzTPkdHjO98lS220/ZiDwHMIpuf/veOmOiRoZHzyMAsw56qfpCcWL3CzyRO5hJ2yWYPzoeRmgy/pki1luvbn7DpvHSCqSsJS1bgFfxSdM3pLePmUi1TedPp00O1NFUjnIwsEzjvuI5boQmtHhPLaUcniqny4Wt9fLYC9cl/08Wgk0IfT80GvTgm05ROpNPWAuBhIOH08835T5wPVprtCL95M4YaVxGRrlNBvjvV522kJZkgeVVhaNkfboRexHlzEuwbTqzZPp4f91yp2fBUoE9rM4A9v2Gt65eyswRZtuXUeQw9r+JkNma4ExdFxhpl63EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48MRqqf0nr3RDDxiG9WUtrcn6mBYBxvjHHQv8mkWXQg=;
 b=XckbuXwxEO+eQcmYjAou9q7vfdZk8udBaLsmuw1s3A5sgicm23QwrMIs6N/vfnTTBiPDVoDggogC0d2QIliZG+3jWJ4biaHYuON9Fd00UxInzsKqyTuCilduGf2Cw1BxJPUdn8qFhgqVcq8XD+qrCBUNBKZSZr1Pncx+9n/GNfx2OfCIkUcK1Gunow9JcUHL1dJpy9hncM7jGWMi74m2fA9iguFCVyQ3b/QfsJv47rBfK8WEUCajukW8yfdaJTGfN/sWmH6rY0Ax+qpwEA4MW6nA2u3RcHU37WMp14phT4/4JXrCco70Y7GuOZS/Qx6Bg0GyM+2Y3grICtvW5xjSiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:28:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:28:52 +0000
Message-ID: <93f0353f-dbbc-4216-a0d0-68fc53d0e2f8@intel.com>
Date: Tue, 25 Jun 2024 16:28:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 07/18] x86/resctrl: Block use of mba_MBps mount option
 on Sub-NUMA Cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240621223859.43471-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:303:8e::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f7141f-14e6-49b6-983f-08dc956e924a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b05sNW1yNDN0bktUbUhUK2l3MWJmZExBZHZvQ2s5Rkt5TStsSmZROFhnTmhH?=
 =?utf-8?B?SjJXUXk4aEhaMFVEb0JldDZtelJLUUYyY2x4alIrZUZLcjJDMUVFeEplUUxW?=
 =?utf-8?B?TkdMbDEwMmlWTHlVT24xQ00xSUNza0hLUWlwL2xiT1hINEJ2N0tsSHFuNGxR?=
 =?utf-8?B?R1dXY0kxTExRWHBvMmJDUGFTbG5pbDZFTXV4bWp1WnE4OG1wSEc1T1hXWkNU?=
 =?utf-8?B?MGtrMU9yYUIrTkpHOWhlcEdGdmRHbHFXdHRxQ05PZUkxQ2NaSkYwT1Qzemsx?=
 =?utf-8?B?bkl0aGhmWHRIM0FjYWN0L0hyd3pteVozTUt3b29RQjdmUzV4WXJOMTBWNVNO?=
 =?utf-8?B?c2RscUtNOFNodERUUlVtVmI3VWduOGwzVzgyQThaWTI1aEowbkx0ek5EV2li?=
 =?utf-8?B?dVdzK2ZrUTNGN01VWmpJYzVWZjM2RG9RaWdSRVNaeGYzeDlRTktyaFhXSlZC?=
 =?utf-8?B?SVAvNHFvaUdhMWtWYTJqZCtaY1RPYVZJalIvUXdMOTk2UzdtVzNzYllOOUZn?=
 =?utf-8?B?SzdJcFBvNTdmKzlzZ0ptazF3MUsxVmNJUDV0L0NjQW1tSWd0VjBxL3VQR1Ax?=
 =?utf-8?B?dkszUFdLelRySEEzUzJBellwVmVDckNuT3JiSVd3MWd4OVdQNDVrOTduNS91?=
 =?utf-8?B?K2h5ZDFReHU2SytQM0pXWnpmT1BvMVZ2cVR3cFFxdUxFUDJtV0tnOWdyV0Qx?=
 =?utf-8?B?ZHJXcGR6aGdoNk5VeGZHcmllUVhGaWJUdFA1MVVIV29QbGh3MFNna015dkh6?=
 =?utf-8?B?NmJmNktrZ2gwQmNqbWljUUN1R2tIdDdONXRTalVBbnZhQktqcVg2V2pwZ0VU?=
 =?utf-8?B?SGkxeTQxQ2k2ZXVTdnQ5dUcwaHpKQm1NMUlJdzBObjkrbU1hSEhCU0kyYmhk?=
 =?utf-8?B?UXBISTd0cjZ2MmwyRUlvSmxibHlOY0poWDBIZ3FHL244WDZ0cS9GNTRVcGdS?=
 =?utf-8?B?MW9aV2dJNmVSM2JYVDNqRmljZWRkRjFVV0h3cE56QklybVhGTEdrMUhKaEU5?=
 =?utf-8?B?c3l0L200RXFnS3B4UlZOMktUc3JHQ1FpMHpzVXpyc3NGVENlRndHM1NkS2h5?=
 =?utf-8?B?UVMrbVhrTDdhWmlvTjNjamJnQ2J5YnRiZ043ZUNYdmZrTklraE1ZcTlJTHJV?=
 =?utf-8?B?ZXg5dW10TVNVK2lsSWlheDkwMjdaL2JyUTNVdVJmc1FoeGJOQUJHTDZpcmRl?=
 =?utf-8?B?V01uQk1YYyszQ2paNWh5QTI3KzNwN3hVWlVFWUhvODBoTUxUM1lCVlZSSTRs?=
 =?utf-8?B?N2dUZE1mNGlETWVZWklMYlJjYmg5dHJUSWU0YlJIQkgxNjg5TDdKaTFXWHRl?=
 =?utf-8?B?WkwvYkxuU2IvZk5FZW1mNmVNZGhBWk42elFTa29UZG1KY1R3di9uUWZNaTd3?=
 =?utf-8?B?dGV5b1lFVE1RSTRZckhuS0U2RnQyUTE4RjZNZ1VDMXd1U1p0Uk5WMW03aVcw?=
 =?utf-8?B?cFh1TDhGMmJOb0ZZOUhNcUVod00xTmhDTVJwSDB3RTZjVjB6TWkzOWliZU9H?=
 =?utf-8?B?bWNsNHBCOXBudUpNdWRZUTMrWStlYkdZbzR5WjFMTGx0RGpTNHpkZDlWUXda?=
 =?utf-8?B?eTRjakplNDdBQWFyM0x5UmdQUW1UaW1LVTNNT0srMjM4aTl4dTFTNVlPamVK?=
 =?utf-8?B?SWRCNFpiMjJKVStScWdhZ3VSLy9TU0xONCs4YjFGcFVXaTBsekxVeGFMKzRS?=
 =?utf-8?B?cmUyb3c5czd6ODR1RC9MVUNlRmxNaTNuRGFCbEJ1SmxwMmhlZWwrT3VnMThL?=
 =?utf-8?B?aEZGL2w1V3VpakQ3Z1o1cTRBR3NQWGlZMEh1K1JnOEh4OE93M1RNMnVvQmhj?=
 =?utf-8?B?UUs3U2hwK3ZJSEdrYjZ0UT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlYzVXMybXB4ZmZidUlnL20vSmpmYktVbjBPanJFaDhlWi9QbVFuZkhEM1JH?=
 =?utf-8?B?OEsySEhxV3YxK0FvNEpGL0VUUkF5ZzQ4cXFGSWxLQ3hITUppNUUyWVZveVA3?=
 =?utf-8?B?V0loeUI3VnU4ZGdXdmI1L04xT1kxSUZYTVhhRmYxQTlNWGpCc2hBckVWNFVI?=
 =?utf-8?B?QUxXM2M0aHArRXdVUXh0WEJJZWZYOFA1SnBacHp6RFpiNE1mREwzTTkrM0xo?=
 =?utf-8?B?b1ZpZHhtL0NGY1B3Q2JqVTlzVkNHSFN2eWZydGthZ3Z1VkdmRjJNZzBkUjZY?=
 =?utf-8?B?YWpjellwQ21BcWZ4T3FZNGIxaXpreVhMNVNwYWZMK0F4cm9DUWdJalVEMG9v?=
 =?utf-8?B?SnR5SEFQVTVLbVdVMVVzRWZ1cnZxS1dDdklacVdyeWlkR2RXODRGa0lyK01B?=
 =?utf-8?B?a293MzdPZXRGVm1HSnZxWEVxVjA1WDdKajRZb0JWckVyUXF4aFg0UzdyMUx2?=
 =?utf-8?B?Nkh0YmVjSlZnSnhSTnFaV1l3QTAyWHllenpTeWhFQ01GN3NhbEUzZjUvMU1o?=
 =?utf-8?B?WU0zUXdpVERQeUtYemZzTTZzbDh4b1ZMNFVDTWNpTzFhNHQvUE9XT25yWktS?=
 =?utf-8?B?b2VVbTJ6QWZOTWxPSXFzanAyY2hjSCtDQm9pd2FKV3d3U0kzZnI2WTRCOUNX?=
 =?utf-8?B?aWwreVZNYmMvY290UkpOcHFMY1dveE52SWt6bURUOWpteWhURGJ5SkVDSHcr?=
 =?utf-8?B?K2FnZGJpS2U5eEtoazl2UmxuMW9Jb2NnY1VZc2M2QWJ3V1BucEZJYmljN2Uw?=
 =?utf-8?B?cE5wNHN0T0JVK3g1VkFEaEJIbUYrWUppL25jUlVkUWZhUmF0bVBOZU9DKzVq?=
 =?utf-8?B?bFNPZ1ZQd1gxRUZ1THBIZlFlZ01QVjhwK1JNV3Z3a1h2eHpGL1dnWDY0ZmZ5?=
 =?utf-8?B?U3dHU3Azdnl3VG1QZnVYTTFjR21XcXFvY21VTkt6T25sZ1pKTHo4aXhsVEVS?=
 =?utf-8?B?aU0wVEdOUHdYWnJBN1IxTDVPYTRjbWpCT3FXcVVNbWdTOHBGdFRoRnNJVVJj?=
 =?utf-8?B?UmVlaEgxanVzdURjNkVwWFFiZXJ5TEdzRmtUYzBYcWUvVUhMNmJEV2pZWTlk?=
 =?utf-8?B?UmU2Mk1pUmV4N0pRVXY3Q29TWXNaK01LN2pmdXYwQkhTVEVVRzQwUWEycGFM?=
 =?utf-8?B?WlJvTGRLUThZRldRWWFBVW9BMC9VaEtPSTFGN0dZTVhPV3dsYVkxQS9NUHdw?=
 =?utf-8?B?Y0JRdzFkMU9JdmJpdDF3NzZtQXZHZThnbUVwZnBnczF0WE5Iak9PZGYvekhQ?=
 =?utf-8?B?V21CMEw3bVRRNTFWcWFxRTB6REhJc1hoNk55K1RORXVHK3p0TEFldkhwRTY4?=
 =?utf-8?B?Y1lQSHgvY21WZ3RRem9FY1NNQUtNN2NRbk1kU2pnWC9pVytDWmxleE5CMktx?=
 =?utf-8?B?WkRMdjZYZ2FBKytvS3dEbHVubmhLay9aNEJoRFFlSUlPOThSRnZSNkhTV1BY?=
 =?utf-8?B?OXBjcnlJN1EraHlGWDRRNE01NFpaRW1CSzVXNDZXYWdkblFiaTc5QTJOc0kr?=
 =?utf-8?B?SXRSQ2I4Z3dLdzFxV01DYk5vbENtTUpoOUxRLytKSGdHWjVBYjlBdXpSUG90?=
 =?utf-8?B?MnJGV0g2S2QrdVI4dTUvTysxVFlvcnhEdEp4Mkl3ckdSSEVlUGZuRjQ5RUpT?=
 =?utf-8?B?aVRIVmNCWXBCLytFWUphOTN0WnRVQzJLbE80cGhQMG80OWUxRHlXU1hyMU5S?=
 =?utf-8?B?T3BaMlgxbXVPbmNIKy9yYmltbHBIeUpNSTU2dXo3K2NSVGJwei90OXF4NHpL?=
 =?utf-8?B?cThrY3hpVWFneDlxa3V4T3NRY3Y1cDVmaWY0V3NMQktNVEZybTQ0eC85QnVs?=
 =?utf-8?B?Nm15TDd2WlZEUmFPT1NvdmpQRmpuaWJBWk1tTzRHZXlseXhZQm9QL1VXeTRy?=
 =?utf-8?B?QTlMMnpnZkR2OWtOWXd1aW93d3F4TXlxNmkwTytmOVV5S3NQckRFQkhZQ3VK?=
 =?utf-8?B?bGJGZ3A4b1lBRmNwNm5ENFpTTUFQRkQwaEhOcVY5NHdydHVjV25lVHFhWGl1?=
 =?utf-8?B?TGc1WjV4RlhKUTZFYm94K2xhM3lkMFlJdFdoQUNsWXBXQ2lLYldxQTVqWTFm?=
 =?utf-8?B?UHpLQ0JBcVJjWWdJOGdmekJFUGR6YytHeWxjU0dvL1NHZ3Z2QkJnYmNkVDZi?=
 =?utf-8?B?Vy90QUd6OTRpUjNxNVoxY0V2T1hNVEt5Vm84clNpd1NzSkVoYUVtL2F0ZDNy?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f7141f-14e6-49b6-983f-08dc956e924a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:28:51.9401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09IY1YIY33DgE/3KOEXCmjb2jj+60nhYfbX3Gu1cmgW5E377P4/gvBjY3Y2z/gd46xPhoqjj7PMKYylD9yjTiC/I0XNwx0CHVCoZUsm8iWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> When SNC is enabled there is a mismatch between the MBA control function
> which operates at L3 cache scope and the MBM monitor functions which
> measure memory bandwidth on each SNC node.
> 
> Block use of the mba_MBps when scopes for MBA/MBM do not match.
> 
> Improve user diagnostics by adding invalfc() message when mba_MBps
> is not supported.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
