Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0823213248
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 22:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749075710; cv=fail; b=HC9WKy4TdUCh1XYFY4yMfA5DYX2OPuQZZJ5B3cOUMLj6Tv1kyso/cVv1GHwsu3YuvikJ2UyMQJmhGXbW6+RntfX3Qmy6UkMc3zxgwSxP8DCVT0YHqf0Txty9PcFjI9mGx8K9c6u1Vgt5/zAxNgLSQil6YvzLLHeAv703VPIrHWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749075710; c=relaxed/simple;
	bh=2FGMlQqskw9yHuoCctPux6Q6l3hfO2oryVDW45EycDM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kbb7f1klelRVM6LoFyKJQ8uUdzSOUvBhMqfGBpmQ584/n+Y0t7Zy4xplD57buROH5N46BCCkkzeSpfG8o1ESTo1NID/Sxds/gtqGVAlA7IFQc6Qa2I6WaOCf/h9bc6JjjMPYQrWCLGEAUCyrkQPVD55H4tnRzRclkd1gTzCYdTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CWrrbklM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CWrrbklM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749075709; x=1780611709;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2FGMlQqskw9yHuoCctPux6Q6l3hfO2oryVDW45EycDM=;
  b=CWrrbklMXjNEaNTHNjaMyxJ+Y8dOChHWon+7LstJ0myz17hw7oJ2BMwc
   C0SptEM3SOmn8PORsahG+g8dCAI1JhGGwnCMBDQZNH8l6oI8plzC94Lz8
   EdoElRKJ6Lvb/pnp1HMOP+TmudCpQVQ/89SvgKa74U7Nh5bfwoBCfcO4D
   uY8+OArojFmi9o9143BtgRCi+pF4ia6QqwqI7AKXt9xF/sLnrK+sQi0+H
   DDu148T4dGd5WlynSx4sm4VOsPUtz6brs6xlsvxHBYLFsvomeYGpRgOSr
   R8qSQciy256PmMSlA1ayPF5iIlPeMUP4cQL7HuaJWN4sMz97BqF4/7wSD
   w==;
X-CSE-ConnectionGUID: TsU6zvp1Q6yKD2muP9eF1w==
X-CSE-MsgGUID: dGrKI6WlQM2oEoXdOGpp2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51048955"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="51048955"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:21:48 -0700
X-CSE-ConnectionGUID: AY9xliq4SjabaBZ1KNYohg==
X-CSE-MsgGUID: YGXa26DrSba/UKh+2U+whA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="176195776"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:21:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 15:21:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 15:21:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.43)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 15:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dZgCymvx5CTjZBMxoQgFZ7sMzj6T6LEDZaAZs9j0HSkBh1flGHZXNi+E53DdBhHeF8JN8Wlwgips0efXszO7n9dCMnImwpwvJB/BzNsqlazOHK+BcnhTFKwkYeV2P9eEdmbHYTMORbdK/34Zfj4qpMqrr4lmMHZY6A26hylGwq4ROMFBd1O3ZzGr7b/lC8TVRATz5SS85SRH/2XDa3+kQv8YyxGmQmV8KsyJJYLjIDQh6c7FDCIn7mkhE4KCr/CqKJ9G1mBX/g+s66tS7rdVrCeLGGTIjWcZNOJ2a89k/SGNtKhmen6I8AF2iuRBvR0YGzTMLvy+sbwNwGlxmjFVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25eQGA88Eabmc/2SnY7k1m13BoTzkjI05/p4tTATwNs=;
 b=zPHsk8nd3Gd/Tt1Nt0X7xGXxHOHegDVicDwsoe9UkxATvgsYlO9Ycaot75fEZodYe02Oa2thrz69NjV0RPtE/+ikfZosC5mAnuDWUHhtLBYiouEFeK5CnsEniZcRSkcXak0raxe7i4JYm4ifJ5drBoxh2rqSXnuQfqWrOBuKM8YZWvg5kGzQdvuKFBb88/NdN9Jj7JJT7afGxVAH1odIQJyP7wvhb0cUZ3a6Ia+SDigQhC2O4oL835J3DYcmkkPZdO0J5R/i0s5R+3Saswz7NdyuZFq9LpAOxsaiHiwDOQFV7ks0seTQ+1/iZuNHBhpqzMIMqs7S17MFlR5EM2gHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19)
 by DS0PR11MB6469.namprd11.prod.outlook.com (2603:10b6:8:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Wed, 4 Jun
 2025 22:21:45 +0000
Received: from CY8PR11MB6818.namprd11.prod.outlook.com
 ([fe80::48a1:723f:54ed:a6d6]) by CY8PR11MB6818.namprd11.prod.outlook.com
 ([fe80::48a1:723f:54ed:a6d6%7]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 22:21:44 +0000
Message-ID: <bb7badd8-dddf-41f3-b509-42cdd4539fbd@intel.com>
Date: Wed, 4 Jun 2025 15:21:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4 UPDATED] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: Tony Luck <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250604212208.49080-1-tony.luck@intel.com>
 <20250604212208.49080-2-tony.luck@intel.com>
Content-Language: en-US
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
In-Reply-To: <20250604212208.49080-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0123.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::8) To CY8PR11MB6818.namprd11.prod.outlook.com
 (2603:10b6:930:62::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6818:EE_|DS0PR11MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: ec153f6c-c33a-4b2b-1352-08dda3b6302c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MnVyQ0V0RzI1VWM2ZnZQY3l2ZWE3eXpqMk95OHVtWWw5YmpMTkxxQWVYTXox?=
 =?utf-8?B?V2VrNlhNcitrU1ZEK2lkaWJiaFJTcWx6Q3hGdndRN2JzbFA2TDUrbkVYNUFI?=
 =?utf-8?B?TVp2WHQ1OEJGRWN5NGJaNG1pdzhxZlRLM2FQeStmdlVkSFFoclRpakZJd0Jw?=
 =?utf-8?B?WjdjUWVudy9kM2FFR1c1QUI2SW5PTWo1R04ycldObzdaSndXdlhiWFJuc01o?=
 =?utf-8?B?cVJqRmlISTF3VnRtZWN5Q1JQc1pRODJvTEFQYUltZnYyQWV0aFZNUUFNbG1l?=
 =?utf-8?B?djRaMlBNUjVqR0RzaGNBR25yaTZVd0JmYjJDNFllTkRiVmxEWEdCWXVyL1Ft?=
 =?utf-8?B?QS9rSUFSNEtwd0NPL3JzMlZ1R29RWDZwVUtDc0ZrWjZidEVNNFUvQ0Z4ZzJ1?=
 =?utf-8?B?cE5rdVpvaWZ4bGtOQnpCdjd1TjNWZjM3SmJxc1RqL0xYWDhwSVY4aytid1dO?=
 =?utf-8?B?YzV1T3hKRmFabzU1c2Y2NWlISjhkdUkyTXE1ZTBTU3dhSG9KRVRxTXJMRTFY?=
 =?utf-8?B?eVo4ODU3RnVVSGJOd2UzejR5ZTRwelU1V3hFbm8xMnpHSkZyMkFaNzllblhO?=
 =?utf-8?B?aXRQVll5TERsNFNWeS9RcnZEVDlPV3Z3N3RsRnhKQS9WZytsMkR5RWpGTGty?=
 =?utf-8?B?MklZeTE1cUhWWnZESXNpRzk0VnFwdUdSU0kvRFl1LzRnRE5lcmNUUzZadzI2?=
 =?utf-8?B?L3BZVGJUai9mUFNiUWVhNDRkYllybTczdXRWK0ZFTnlLa0pNckF3ems5M0dt?=
 =?utf-8?B?TTJocVUwL3c0eDdNcG53THprZWVMMTZnSkYwU0lEU1ZpbnR3eEZuZGM5WTlX?=
 =?utf-8?B?cEtyamtsb1BqUE1uU05rMGExUW5ZU0xOOTRlL3RYS1dkenF2aGNsWWFoVXQy?=
 =?utf-8?B?Vm9kSitLd1FaZUlhd045Z0V5RklLNGdaaWZjdHhTSG41Z0RheHEzTzdNWVVF?=
 =?utf-8?B?OEhUUDRrOG5Gc0FQOUg3M0FNY0NxRloyWWpRQkNoSWgxSW9XNXpTN2tLQXNE?=
 =?utf-8?B?dUVWK3BWdCtvZ29NQllqK1EyVng0anFrdUhzYUZONGNnRDNIaWQ4TW5pY1Y1?=
 =?utf-8?B?ZjRrb1YxVWNYZ1Q4UHlmY0xGT1lUTHlqbU5FazFVbm00ZlpqVDZ6WXFmOUtr?=
 =?utf-8?B?cVBadzl0T0c5RWRZbjJrVHMxTDJqRWdJazJQTjZETU43bnc5MTBDOTYrT1Rl?=
 =?utf-8?B?UHlHYlZUMWhaYUtielpEVXNOVlQ5bHlDRjZZYkdtcmdKQUYrNGd4S3djT2dM?=
 =?utf-8?B?czR0cGNRaE1LYjMwL2hlSWhrVG50ZnZDTGticVZWS0Q0NUwvMEpra0ZsMnU3?=
 =?utf-8?B?TFllcFZ0djNkS2xBNDNmU1JkUndsekliT0ZyeElnYzgwWCtTVjRwaUp4cmVH?=
 =?utf-8?B?SFhnR3M3dWpBVGJ6enZGUDRxRW9KQm1lT2RPY0ZleU90SWx0MHRNeFNMSEtl?=
 =?utf-8?B?SkpBZVNqcE1aT01RSHZZUlE2SFZrdkV1VHBqOW5QTXo3Z3BSUng5OXQ3THN5?=
 =?utf-8?B?VmpHU1FTS0U5NjRmdVpTQXlUc1d3WjZoNnJDMFhDbHpiM0xIcXNUSnVIaUZ2?=
 =?utf-8?B?eUw2WDBRQzA4WlVrZDRYZjNyUnYzblFxVVZyOHdOb0RraWZXSVB6eEdtMWtt?=
 =?utf-8?B?Y00yc2d4T0VHZ3UrUlJsaVlra2NBUndtZUlObEVMTGNnbHBBUVZsWlVwTzFD?=
 =?utf-8?B?aEYyb2pXVmhNT3d2SThuUm9DWkdwYkRTVlZRSk1WWHJWNGFVeDBDT2FNNzZF?=
 =?utf-8?B?bHh4dkJ3bDZPQStsYmNYdlQ1MTd3b3hhaFhGT0VqbkpnbmRnQ3djV2g2ZlRX?=
 =?utf-8?B?T0x4cjdZUlFPY0hrdVJHNlhTWldESUNvcG9vMk1xTUNCYjg5cHZiVWpuY0xs?=
 =?utf-8?B?bnRFWVhIdThhQ1hmd00yVXVZc2hxcUJHcVFzVEpMTjV0T1FwU0VCNDBTZ2U4?=
 =?utf-8?Q?MTlI+8DZFXI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6818.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnNJVnZFakpWLy9uVC9UL1lpTHYrUWI4NVhOTklxREc5YkFwUjRFbzYzZ1BL?=
 =?utf-8?B?UUNBMWV4K2trUEpjTCs5NVoyM0JQaU9ZZmhjVXluRFZaQVNDcXRhN2xuRStS?=
 =?utf-8?B?dzJXb1JDRDhmRE51WWdLc2h1Q0hWT3RLdTBxZDJVNmVIV2V5SHZSQ3J1SmhJ?=
 =?utf-8?B?MjZjU1M1b3ZpcG5HSnczNjg4dWJHL0dHWVJTejIvNzNGNlBjMjVndnFkNTVQ?=
 =?utf-8?B?SDFwTkJYdDBnVGlCSG9lZjFicjV6ejBIY0hrbkhEbzgwYVY3cHpEV0pDdUE1?=
 =?utf-8?B?ZjNZKzBYcDNVako3NnYzdmdReG1wd09iVzlpaTErNlJaZ3hhOW5oQnZDTVVj?=
 =?utf-8?B?SFI4UWpxSTVNb2F5Z01tWUpuaFpiOTFLWFZlenR5THZSWjE0dlpiT3lRRllw?=
 =?utf-8?B?ZmNhTkFTcUwvckF3dzFkeGxxc1dSa0liRDA0clhRdWhETHdjR015K3VEaWtn?=
 =?utf-8?B?UjdCMkxxUUdWZ3QvTGJHeEpBbjc4ZkJPTkRVVkNsRDJlc0pjMUJEMU9hUEVw?=
 =?utf-8?B?OFBiaVZTMFBSaEVydzRlbk4vK1FoWDk5NjlLUkdxcHZzaWtROEJUdzFHaXdE?=
 =?utf-8?B?cHg1U1lPOSsxQnhVSGlacWxUYnY2ZTk2dHpqYTlKTjhqaFpuRmhtUVNYVmNk?=
 =?utf-8?B?ZXBoNUVFYlVwbUtlVUpqczRuWlJFUXVVRXJINmszOTZwREgyOXRTY1FYYmVn?=
 =?utf-8?B?cVBVeVQ0ZjU4Qlc0UHA3QU8yYjUrdTBkZGpySllvWDUvSE5kaWVmazhMSlg1?=
 =?utf-8?B?NHdxYUFKN0EzZnZhaGNFVDJOaytVMENBNE9JaXlGaE5oZXF1eHZxNGxCWUhK?=
 =?utf-8?B?ZmhNa1hwT3VaVTFJM2owNmlrbHRKZWVPZ1dLazV0Q2M1UXB3Vmc4eUNDVUNL?=
 =?utf-8?B?VWg5MFhsWi9mMDVTWVJRS2ZvWVlCMTJHaWY5WjNGNzljUTFSdjNYcVhoSXRP?=
 =?utf-8?B?eHIxTU1xanhFc0k4djB1L2djUDRrMnpPWE1manpjWmxVWldYR2c5OGN6Ymlm?=
 =?utf-8?B?Rm01d3B3eG5ZSWhQa0ZXbGNxbHZzNUNLSThPdHd3amE0aVhWeVA2Rmp5ak15?=
 =?utf-8?B?cXRuY0lndllFcnRUNEh1WThwQ3I2WTNBTmZsellXeFhrS0dNZEFZMnVDdjRn?=
 =?utf-8?B?a2I2WGtOYmxpdjRqemhZYXd4dWZvZnZxaUFvb3AwOW1IUi80Z0doTTVRKzRR?=
 =?utf-8?B?cEN6d21vWWlQQWE5akdnL1h2bncvWUswdllHeXF5aTRNUTlYeXhnY2didkFv?=
 =?utf-8?B?QTRQaDduTE9aZTQ2SitQR3Rtd0lDT2twUWxDYkVzMjJXdFYvWTlXMWdTb1VK?=
 =?utf-8?B?dFNaVnFHT09JTUJSSGdMaUpHUzRiQWNrcW4vUDI3OFVpTjJLQkNFWmxMZEpm?=
 =?utf-8?B?VHdlZlNKc1Q4N3JvOXJlRXpXc1lQWmJPVXFMVUVmUW5ETlQvMzU1RFJxRitO?=
 =?utf-8?B?bmdVN3F5cjRqUXVoaHFLdjRCVWgveGo5MkV2Sm1CMW1yd1UyclI4K1JlbFFT?=
 =?utf-8?B?MjhFNTF0Ny8zU09IVko2eXI3VFlTYVhGdHV2S29PdVE3TTkzU3NMNllNT1Zr?=
 =?utf-8?B?d2MwTU1tUHJLaXdtdkIrVDJzenl3YWdjalFBaEVlN0lLVkR4SlZ4aHM1bGRy?=
 =?utf-8?B?MzBBUEVFYm9UZHVPdTJ0TXFFcEtVc1FTL3ZueDJYb212Ymo2TzY1UThSN2pV?=
 =?utf-8?B?UHl2MHlSdTdzWTVkY0RQNkpHbWxxNWkyMi9yZ1BZUGdndTdOTlR3WTNSbXJv?=
 =?utf-8?B?MzhRdmF0K0pHUk5YVEhFaU9uTzlYRjdTdGZrdkh4d1RFSUhoNEFuS3hHMERW?=
 =?utf-8?B?bTEvZytkSjNUbVNkcXNoOTlmdTJTcGFnTVgzUnQ4VmNlRllsSmZHcGlkbUdv?=
 =?utf-8?B?UVBOa3NuRVRRRURVT0YrVWpWQ1Vwc2hUZmJHdkJuY0s0SWJZVW5SK3ZqZFJD?=
 =?utf-8?B?YVA3Z2pIYVF3RXg4KzI1bnh1bEdPUmhDTjd4SkJ2QkkxSFRvSmxEdjVvM0Rq?=
 =?utf-8?B?MStwdjExVGIyMGllbjFPanR1cUM4WjR2STZzdmlUL1lOa1JpMXQ3RTJkZWt0?=
 =?utf-8?B?UlpjeDR1bEFNaGExWHREODQ4SWV6TkRxc2xwR2k5Z3Ewa25RK2gwNDhrZk52?=
 =?utf-8?B?Undpa0VzQ3lITjB6eFNkL3R3VGlZQ3krTThuc0plbFNBeWtBY1pQdlp3SStC?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec153f6c-c33a-4b2b-1352-08dda3b6302c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6818.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 22:21:44.6780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wq6thimIscSS0RiYSQuX6BJLOCZ1UomJ92prsiRre9FfpmV3pGvgQ6ndpEhbwD2MC+zKxW1nY5MudWSkRo0CtDPITjG8DqTY0zp0/hXcSLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6469
X-OriginatorOrg: intel.com


On 6/4/2025 2:22 PM, Tony Luck wrote:
> There are currently only three monitor events, all associated with
> the RDT_RESOURCE_L3 resource. Growing support for additional events
> will be easier with some restructuring to have a single point in
> file system code where all attributes of all events are defined.
>
> Place all event descriptions into an array mon_event_all[]. Doing
> this has the beneficial side effect of removing the need for
> rdt_resource::evt_list.
>
> Add resctrl_event_id::QOS_FIRST_EVENT for a lower bound on range
> checks for event ids and as the starting index to scan mon_event_all[].
>
> Drop the code that builds evt_list and change the two places where
> the list is scanned to scan mon_event_all[] instead using a new
> helper macro for_each_mon_event().
>
> Architecture code now informs file system code which events are
> available with resctrl_enable_mon_event().
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h            |  4 +-
>   include/linux/resctrl_types.h      | 12 ++++--
>   fs/resctrl/internal.h              | 13 ++++--
>   arch/x86/kernel/cpu/resctrl/core.c | 12 ++++--
>   fs/resctrl/monitor.c               | 63 +++++++++++++++---------------
>   fs/resctrl/rdtgroup.c              | 11 +++---
>   6 files changed, 66 insertions(+), 49 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 9ba771f2ddea..1c87e1ed235f 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -269,7 +269,6 @@ enum resctrl_schema_fmt {
>    * @mon_domains:	RCU list of all monitor domains for this resource
>    * @name:		Name to use in "schemata" file.
>    * @schema_fmt:		Which format string and parser is used for this schema.
> - * @evt_list:		List of monitoring events
>    * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
>    *			monitoring events can be configured.
>    * @cdp_capable:	Is the CDP feature available on this resource
> @@ -287,7 +286,6 @@ struct rdt_resource {
>   	struct list_head	mon_domains;
>   	char			*name;
>   	enum resctrl_schema_fmt	schema_fmt;
> -	struct list_head	evt_list;
>   	unsigned int		mbm_cfg_mask;
>   	bool			cdp_capable;
>   };
> @@ -372,6 +370,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>   u32 resctrl_arch_system_num_rmid_idx(void);
>   int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>   
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid);
> +
>   bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>   
>   /**
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a25fb9c4070d..2dadbc54e4b3 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -34,11 +34,15 @@
>   /* Max event bits supported */
>   #define MAX_EVT_CONFIG_BITS		GENMASK(6, 0)
>   
> -/*
> - * Event IDs, the values match those used to program IA32_QM_EVTSEL before
> - * reading IA32_QM_CTR on RDT systems.
> - */
> +/* Event IDs */
>   enum resctrl_event_id {
> +	/* Must match value of first event below */
> +	QOS_FIRST_EVENT			= 0x01,
> +
> +	/*
> +	 * These values match those used to program IA32_QM_EVTSEL before
> +	 * reading IA32_QM_CTR on RDT systems.
> +	 */
>   	QOS_L3_OCCUP_EVENT_ID		= 0x01,
>   	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>   	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 9a8cf6f11151..71963255ad36 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -52,19 +52,26 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   }
>   
>   /**
> - * struct mon_evt - Entry in the event list of a resource
> + * struct mon_evt - Description of a monitor event
>    * @evtid:		event id
> + * @rid:		index of the resource for this event
>    * @name:		name of the event
>    * @configurable:	true if the event is configurable
> - * @list:		entry in &rdt_resource->evt_list
> + * @enabled:		true if the event is enabled
>    */
>   struct mon_evt {
>   	enum resctrl_event_id	evtid;
> +	enum resctrl_res_level	rid;
>   	char			*name;
>   	bool			configurable;
> -	struct list_head	list;
> +	bool			enabled;
>   };
>   
> +extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
> +
> +#define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];	\
> +				      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
> +
>   /**
>    * struct mon_data - Monitoring details for each event file.
>    * @list:            Member of the global @mon_data_kn_priv_list list.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 7109cbfcad4f..7b235b7691aa 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -862,12 +862,18 @@ static __init bool get_rdt_mon_resources(void)
>   {
>   	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>   
> -	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
> +	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
>   		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
> -	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL))
> +	}
> +	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>   		rdt_mon_features |= (1 << QOS_L3_MBM_TOTAL_EVENT_ID);
> -	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
> +	}
> +	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
>   		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
> +	}
>   
>   	if (!rdt_mon_features)
>   		return false;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index bde2801289d3..90093e54a279 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -842,38 +842,39 @@ static void dom_data_exit(struct rdt_resource *r)
>   	mutex_unlock(&rdtgroup_mutex);
>   }
>   
> -static struct mon_evt llc_occupancy_event = {
> -	.name		= "llc_occupancy",
> -	.evtid		= QOS_L3_OCCUP_EVENT_ID,
> -};
> -
> -static struct mon_evt mbm_total_event = {
> -	.name		= "mbm_total_bytes",
> -	.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
> -};
> -
> -static struct mon_evt mbm_local_event = {
> -	.name		= "mbm_local_bytes",
> -	.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
> -};
> -
>   /*
> - * Initialize the event list for the resource.
> - *
> - * Note that MBM events are also part of RDT_RESOURCE_L3 resource
> - * because as per the SDM the total and local memory bandwidth
> - * are enumerated as part of L3 monitoring.
> + * All available events. Architecture code marks the ones that
> + * are supported by a system using resctrl_enable_mon_event()
> + * to set .enabled.
>    */
> -static void l3_mon_evt_init(struct rdt_resource *r)
> +struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
> +	[QOS_L3_OCCUP_EVENT_ID] = {
> +		.name	= "llc_occupancy",
> +		.evtid	= QOS_L3_OCCUP_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
> +	},
> +	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
> +		.name	= "mbm_total_bytes",
> +		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
> +	},
> +	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
> +		.name	= "mbm_local_bytes",
> +		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
> +	},
> +};

As we start adding many more events to this struct(including region 
aware specific events), this this becomes too stressful on the eyes to 
read.....can you consider simplifying this with #define something like 
below in your next version? NOTE: For the feature that I am adding along 
with Chen Yu, we started to define a macro as shown below.

#define MON_EVENT(_id, _name, _res) \
     [_id] = {                      \
         .name  = _name,           \
         .evtid = _id,             \
         .rid   = _res,            \
     }

Above #define can to into include/linux/resctrl_types.h file and the 
above code reduces to using MON_EVENT as shown below.

struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
     MON_EVENT(QOS_L3_OCCUP_EVENT_ID,    "llc_occupancy", RDT_RESOURCE_L3),
     MON_EVENT(QOS_L3_MBM_TOTAL_EVENT_ID, "mbm_total_bytes", 
RDT_RESOURCE_L3),
     MON_EVENT(QOS_L3_MBM_LOCAL_EVENT_ID, "mbm_local_bytes", 
RDT_RESOURCE_L3),
};

> +
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid)
>   {
> -	INIT_LIST_HEAD(&r->evt_list);
> +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> +		return;
> +	if (mon_event_all[eventid].enabled) {
> +		pr_warn("Duplicate enable for event %d\n", eventid);
> +		return;
> +	}
>   
> -	if (resctrl_arch_is_llc_occupancy_enabled())
> -		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		list_add_tail(&mbm_total_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		list_add_tail(&mbm_local_event.list, &r->evt_list);
> +	mon_event_all[eventid].enabled = true;
>   }
>   
>   /**
> @@ -900,15 +901,13 @@ int resctrl_mon_resource_init(void)
>   	if (ret)
>   		return ret;
>   
> -	l3_mon_evt_init(r);
> -
>   	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -		mbm_total_event.configurable = true;
> +		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>   		resctrl_file_fflags_init("mbm_total_bytes_config",
>   					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>   	}
>   	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -		mbm_local_event.configurable = true;
> +		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].configurable = true;
>   		resctrl_file_fflags_init("mbm_local_bytes_config",
>   					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>   	}
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index cc37f58b47dd..e4e4b6af5147 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1150,7 +1150,9 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
>   	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
>   	struct mon_evt *mevt;
>   
> -	list_for_each_entry(mevt, &r->evt_list, list) {
> +	for_each_mon_event(mevt) {
> +		if (mevt->rid != r->rid || !mevt->enabled)
> +			continue;
>   		seq_printf(seq, "%s\n", mevt->name);
>   		if (mevt->configurable)
>   			seq_printf(seq, "%s_config\n", mevt->name);
> @@ -3055,10 +3057,9 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   	struct mon_evt *mevt;
>   	int ret, domid;
>   
> -	if (WARN_ON(list_empty(&r->evt_list)))
> -		return -EPERM;
> -
> -	list_for_each_entry(mevt, &r->evt_list, list) {
> +	for_each_mon_event(mevt) {
> +		if (mevt->rid != r->rid || !mevt->enabled)
> +			continue;
>   		domid = do_sum ? d->ci->id : d->hdr.id;
>   		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>   		if (WARN_ON_ONCE(!priv))
