Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FD47CF30
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919305; cv=fail; b=G8m+ClS+kgG9bQ4yarpu5iP3w9T/3aZBH2eUFJnceqg7aYdkg87k6LfTYpilninThue5+cGgWGAHLsjMT8C4m9sMz/mG2MwtKM+I427p9I0RXZrB+ZSiZDvo9YaEsDsnJtmAkxUEh+AdMKBfgpd0jjBh9JSbOCLCfYpEZCIIa+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919305; c=relaxed/simple;
	bh=GCSsVyid/8O0IPU/FtYiVIbe1IYhDICa2DrSclA9Ets=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FLwGFN8mR00L8ahwOxzmorDaXYJLEVMY3/gXAxtv5FB2J9qQ+StxMkmUwe4w20zPP6NYBphU5D0ic4PFhTUyfHkeVlRzNcPLkw9G++/a2//1LofypXbfzWpIPUtXiSjvFmS5lNUGDuXzYwhwR/WBoVDBNPJeOMmVUkj9vDHRjWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TY+9JT/Q; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TY+9JT/Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919303; x=1750455303;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GCSsVyid/8O0IPU/FtYiVIbe1IYhDICa2DrSclA9Ets=;
  b=TY+9JT/QvRNr2y1bL7L8qX89qN+Sj6IHuvu4y1HmMZgji1VwXNGjQxyd
   UJicVUQ/APRyYYT+JzI8M6d+eX+6IwDYtsooJGwZ732aCufbLoP/XbQVu
   5cQjtt4lBlhsUP0vm/gHlCf9jZLDVgd6G/DfZidRUP15CRpckhm2++x4k
   17FDG0xQ93eUt5nYF6ufAa80jlV/x7nM/BB8S06YUJo1kQhDKr36e9NFf
   oVPOcKDscnRvAjgFa4U1kAC/TwMuWIUtDwVutS9G/8Ex1WpFffzraa6WD
   bZndjYm3ByjaV9GyKxHLYfF+AUZpFCnOcBunGaVBe+7Hd2Vnna2L2Gi1/
   A==;
X-CSE-ConnectionGUID: Sdnsm+AmSbiA1wCJTLQQtA==
X-CSE-MsgGUID: nnvt275DRb+ZreWvWA6WrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15759476"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="15759476"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:35:03 -0700
X-CSE-ConnectionGUID: UV1dVS/TQ3K/iPKgLK8mkg==
X-CSE-MsgGUID: +w002xu/SZSUfxQTDW8p1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46723541"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:35:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:35:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:35:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:35:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpuIl7cNzJ4x+JE0Kfc2odyxoRaKF2/bzYHzv88YL7WPZ/lwdA/yCUmoNCW8uBWmx2j4l5d3QxXKOFcQMPSTrkzNvc3uQTZ8BxeT5rTm/QOqFHKLqkYNEgo3yea7Hcc4+/SdXMv101MW1S8eZUy6BKJbFxx61c7p/yLzQq3+cQxzQWWsPGd0SkWvI3kfW7Su4ios1DkoeaqBk2ZIlqSn7erptWU4jze07vobgb5mByFW1d9FB4HX0hpOCzTgWTYpFWku22LgauQVJYWjjoTbhgJBw11tsfEMZtcC8lOCKnDVbQLomzhWvMe7QI5N+BUAqkz9via6UQQz2Mt3t68zkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQvyccYnHECCdze3kyj3oRShwDy+HOa64ekHcyFUJUc=;
 b=nI3/px9tD2rjNpOwr+5eBC2t5EQeVYHN8euuTE1X9kmuSWMM//75yEQ11SGC9mqnkKYNGNToldH51hbA5EzX61FWHc/2jrI3YTgbBVZNPgxyUUku7wwAghoIenmd3A9giRIW+WUdtOjTaF2uNHZhCxxdQTZF7gOIO8swjQ2D+sgfglh4Jqxh1txDAGbMRNR6g7VfSCuYufJpWEaPMQ2DamHrj7WvtpQ1RMGxRKtPIHKWBJvviRy5iiQ/4easInl8it/fD7WpyU0xYSXi0i8GOE3ilWOFLgGieTxP3RXmCfiLrj+IiJpTS38l4Ietpf/+OzdkneAxmb6yd0E5PdpAzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 21:34:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:34:51 +0000
Message-ID: <5e8fee73-6d5f-497a-947b-f8f8da62d15c@intel.com>
Date: Thu, 20 Jun 2024 14:34:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 17/18] x86/resctrl: Sub-NUMA Cluster (SNC) detection
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240610183528.349198-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:303:6b::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: d5b5dd2e-b7ba-44c5-1440-08dc9170d14b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c0o5Ym92YkRnU0U1SXdyVnczK1VoaUxwdlE4RjR3eCtuNWoyUmZMWHRpb1c2?=
 =?utf-8?B?d2pGS0dhME1EMnQ2L0hMeVAzUTZRVzhLYWFBTnZnUjBtZzhrOEhua2VUTmhG?=
 =?utf-8?B?UGlscjBMcURSWWN2TFQ3MEd5aloxUlM1NHVOUnNWRkNscSs0TkZhdEdmR0Nz?=
 =?utf-8?B?dlorOWJiZ2IzdXE3WFlZTWZGMFVNREVyNjExZGdzNncxOFprQkpvZGc2S2JX?=
 =?utf-8?B?b1VLVlExMlpmU1pqbStmbzFQYkFYTG9UZDBkbEt1Y0htR1AxekhSaXl6TGNQ?=
 =?utf-8?B?K3dOcENXNW12LzA5MVhJZUQ0TWdFcUQ3OFBvandLN0c0NEgxRDlPbEJKT1ZS?=
 =?utf-8?B?OGtKZGhuTDdtR3Zwdm1EeUVaTWp5eHp1UEZzeDltM2NVQ2pjYm8yNGcvRWVK?=
 =?utf-8?B?ekJGeVcyNW01dlU3QnFDazQzTHIxS3QvNzF5dkNLOWtSZ1A4RUtZS1NhRWVj?=
 =?utf-8?B?N29rdE5MR0JSY1pzcGhHUk1MZEpXR0EveTc2ZDRITkYvY2JrczZzcGdPMnR1?=
 =?utf-8?B?V3JlM0ZmV1dkRVNLV2d2NGxrOU9Qb0taUDNad1dqZXMyYXVFWnJnQmdxeld1?=
 =?utf-8?B?UU9WOHpGQm5wNmZjY0NzYlBYM0pwdjlCL09QNTBuV0ZoMFlKM0hyenQyUk12?=
 =?utf-8?B?c1NPSFkrZk52N2ZJSlduQUxDK2JtQkZJNnA3Ymc2WmlnVmJ1ek9OMXpoMEpm?=
 =?utf-8?B?WXVValR5eDlmRlpqQUEwbVc1eldFZTZRbTJ4bmlsVUpadEQ0ZXU3L0pESE1v?=
 =?utf-8?B?K0RMVy9HNHJFbVZpVHU4UDk1MW9veW1FYXB5ZTQyaEtmaGRpbnkzbnpiSUZX?=
 =?utf-8?B?ZE1GRENkbmJDMDhxZ0hmSHdKemQ4MVNkR0UxYmRPQkdLQW1WdXZzYzU4ajB1?=
 =?utf-8?B?QXZvRHFLZmFVeWJwWFp2Zi83UmJ0NlkrRkdsQS85WXVqZ2V6bHZqSTZlYnJp?=
 =?utf-8?B?SzFNeDlWdERFcFlNSk15RDNVOXg4Qmlwc3M1U3RPcUJDSTJSOU5kbm81eitw?=
 =?utf-8?B?cVlxRjA1OUhFa2FRYWMxZkt4TENKVFhaRDJHTkUzbFRDN2hrbFpBdFRySU1q?=
 =?utf-8?B?eFVteHo4akZORVNPdDFoMTUzZi9LYnRpUTFXcUJoWmpyMDFadWxBMEMwY003?=
 =?utf-8?B?bWh3cGdKbFBXOUQxTEhsVkpmSTlSSmpWeisvTm96RkwwT1pMNzZha0NPVm9M?=
 =?utf-8?B?bmtYb3lSMG1qYnk4NjZ5bGJtWUM3YmNYK1RzZDlNaGJYNkYydDZmejlIYm4v?=
 =?utf-8?B?VFdTdXU0Mkc3SVoyT3ozNDlEM1lyeUtTOGJNNUZOMElTcHo3N2NFQUVmZ1V1?=
 =?utf-8?B?WmZ2VXcwT3kycFRjMXRvalR1TTN2TEJocE8xYVpUaFFRM3k1ZUdTNnczNXc2?=
 =?utf-8?B?QUFiRjRzUGowY0ErVnFsUWpyWFg3ei93UnNxbFBaWDlUOWpkY3Vjb24xVVpr?=
 =?utf-8?B?Z3JHUmhDc2x4YWRWVUlDWWMxRGJPRTIxalNRbmg3Um5ZM0luNzBYbGNwSEZQ?=
 =?utf-8?B?T2tmYlRwTlZRdGJlTjUwUlBLTjRvWHVqMmdGTmM5Mldwc3R6SXNDdFJNdW5H?=
 =?utf-8?B?R1Y5UFA4NUg2TzNDUjFwNEVZa1dDcHZWcWlUck1paVFqUU14R3d3V0loZmRN?=
 =?utf-8?B?TGhQbUd5a21zc2lLVS85aE5mZGkxR2FIRTdPODJVZElTOU1jaGo5alZodGdR?=
 =?utf-8?B?ZEQ2eUNRa2J3aEJpNnNvYzF4ZjBWOE9HQXlOMUNhemRSeUhUc0o2cDV4blBU?=
 =?utf-8?Q?8+BFa5t/CBvzoiOQFBtmDO7FoxdDVDobVzYRsjP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFdOQStHNzZuZVp1enhLWnBTQ2h3cG5pZE51ZjU2cm1WTWZSQ3hIYXFwVmpN?=
 =?utf-8?B?S3RKc3BZVlA5THJWZ0RheERCRzNtVHF0VHBlYitqRlo5TmpIbE1lSGU0L21z?=
 =?utf-8?B?SGJRNUh4VngvUUxwTHNabDJiZDA2UEhKdWV2U01aeHdweGpnZ0crSStsUVNw?=
 =?utf-8?B?VVVBeDlnYzNJd2c5WStJSlZzY2ZXMGQrTXNPK1dhK0plUkZQWVpuNC9ybUtr?=
 =?utf-8?B?c3hkZVZkVWhiK05EMjZKaUZ6dzJJY0tJby9qbmRld1F0Z21YcXN2V2s2ZEg4?=
 =?utf-8?B?cUVuM3NUc3ZtM21HUElBT05QK2JHN0taYnNIKzBuRDBaUUFNSU1UK1RMQXV5?=
 =?utf-8?B?SUVjNHNIZ3VDa3VJNUd6c0loS0VJUVpHQ0Q0L1hxTEJVaUl5SEhhbU5xaTI1?=
 =?utf-8?B?TGxFSFNMaFJla1FiTjloYVFpSm1OUG1ZZzdIMUtsb3U3OEFVdXZjUFF3b25m?=
 =?utf-8?B?MDltUk5LSEJjR1gxV0I2UDdIeVR6eEw5UGZzNjIxOXFvZEZFT3FERTB2N2t4?=
 =?utf-8?B?dVJUSjBKSit3d1Era3gvN0FOUEhvMnBIM2M0Y3RzTHV6dDk0Y2ZqSU4zNEts?=
 =?utf-8?B?TGxUaEhpKzJyRG4yTWRaelJQbU42NkZiK29ZMFVML0V3aTJkQVZOODdIZ0xn?=
 =?utf-8?B?TnA4TWtjWmVrc1NIMkh5RlJTeEk1NzlncG9UWlZjbDM2WVhWSlN2Rm5LSmth?=
 =?utf-8?B?OVRSN3VnSXp1Y0ZKSjQ4UUwyaWF3MHNTVyt0cy9kYjRMd2MwTjJFZFROU2RR?=
 =?utf-8?B?VWVwSy8xSmNqVVF5eXNDcVgreGR3Ym13a2U0alQxVXl0TklycmRBbGFKQTFW?=
 =?utf-8?B?cWduN3BaQldrOUtzbVdPL0NOUXN3ekVtVUJseDV5VlljclJRUHhBNk5Cc1lH?=
 =?utf-8?B?eFhzWDhnVkRGYmFjaElnUE5wVGhiTDJnWjdhZjcyTVR4YjRFOGFoY1VqMGxq?=
 =?utf-8?B?R0pKRUdxeWFtNlFmR1lzWXFEU2hBbzVNS05EbmVXbXhsZlM4OGpDL2IyRUhM?=
 =?utf-8?B?TGgwbXVUZHJ6NlgraWVTVWZXZ25wTGtKQkJiMzlkSmNZb01UOUNGc1FpUnkv?=
 =?utf-8?B?V0E5UXFVajJhZldoYXlKVXdkdGZ3WldxTUFieXZJc1UzNzQwSGZ0RkgxNDdh?=
 =?utf-8?B?eHJUTGY3VXZFVXRNSDVZM2tkbVB2MFNqVG5wdlZOVi9wOWVhQWl3MGpvVXY0?=
 =?utf-8?B?UUN1S2pXSVVOb2Znc0ptVmtjREsxNG9ma3JyN0twYVVxZDBkK2VsQ05JMDdz?=
 =?utf-8?B?WmY0YkZxbVA3eHpXZGFrWmVxYklhNkhUeWN2R3ZjYlpRQ1NQOFlQdkc0d1Ir?=
 =?utf-8?B?VGd4SDROT2lBa21aTWR0VHFvTloxcHZiVzhsWkY3YlplU2dhYVVmd1QxcWxG?=
 =?utf-8?B?Z3JKVVJuZ0VjYnE5Y0taTk1tSXk3UEtBQTNpYjBrb09lSHF0RVRhQWdhNEI2?=
 =?utf-8?B?a1dlWExMMUJwVmp5Z0lpM3VpR1hOb0JlUzdIVy9aMXVXQ0hBMVdRenhPWFh1?=
 =?utf-8?B?TjBqN29XZ29FZzlwZ3dHOHp5ZFlIMjdibTkxeXZEbEJvdmdmcVZSdkNlREkv?=
 =?utf-8?B?TGxwUmRhcnJNamlmRmEzeDRRM01Fd21NYWJEZWdzdjFWU1Q2cWdkd1h3Rmdm?=
 =?utf-8?B?MXgxcnJKRTJzSWpOcTl5WG1raW5oY3VkUXNpVVNiR0ZneVROdlpGWG01N1Ur?=
 =?utf-8?B?L3ZqM09mUDlrbnp3U0ZGK0RoNFJ0ZWZITk0vcDM5ME40akxCTHV2Y29kSWdD?=
 =?utf-8?B?OXhxNnlrOVoxS2JVUFpKcWVGNWJwNTV3ZGRFL3dwd2FGMFA3MndmL09Bd2pW?=
 =?utf-8?B?QnhlMFdnV0I0TzZrOVZJYlZSSXJ3TmVTMlBEcjdodjN0eWsyclZiM2Z1K1d0?=
 =?utf-8?B?QWxzTGVPN2xFempQNUMvR3l6NFhBL2Zyb0dvSnNpWkJ3NnYxVVNQWXFzQms4?=
 =?utf-8?B?c3VlbGR6alNxNXRCZXowdXhqUVZURURyVWRONzFoWjA4RHRjQUl0ZWRCNDg0?=
 =?utf-8?B?RGJzY2hsTFdibUVOaE15aDNxbnA4QVhydVU4UjRjZlVHRlFmaFFOMFBiVlF5?=
 =?utf-8?B?bjFMK1RPTUNoWEU3ckdQVStwaXhMLzRkT2VBTkR2dFcvZytEZmRDdmZlcVlL?=
 =?utf-8?B?eHloUUJ0TW5jMXJsak9OSUJkV3pBdTJ0QzlDOUpHTTFGdnhNc2RaUjM2Zkh4?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b5dd2e-b7ba-44c5-1440-08dc9170d14b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:34:51.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ro+brbyYAwJIChlVcrmXGolbgBf4N8XVeNpxh5R0yODA2mIPYOgFpbn2NEH7fnGUP9ZK3dRW8tqrIiqkf60orfMqyi6o6p6/tQ07gDbaSQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> There isn't a simple hardware bit that indicates whether a CPU is
> running in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing
> the number of CPUs sharing the L3 cache with CPU0 to the number of CPUs in
> the same NUMA node as CPU0.
> 
> If SNC mode is detected, print a single informational message to the
> console.
> 
> Add the missing definition of pr_fmt() to monitor.c. This wasn't
> noticed before as there are only "can't happen" console messages
> from this file.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 66 +++++++++++++++++++++++++++
>   1 file changed, 66 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index efbb84c00d79..9835706ef772 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -15,6 +15,8 @@
>    * Software Developer Manual June 2016, volume 3, section 17.17.
>    */
>   
> +#define pr_fmt(fmt)	"resctrl: " fmt
> +
>   #include <linux/cpu.h>
>   #include <linux/module.h>
>   #include <linux/sizes.h>
> @@ -1108,6 +1110,68 @@ void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
>   	wrmsrl(MSR_RMID_SNC_CONFIG, val);
>   }
>   
> +/* CPU models that support MSR_RMID_SNC_CONFIG */
> +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
> +	X86_MATCH_VFM(INTEL_ICELAKE_X, 0),
> +	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X, 0),
> +	{}
> +};
> +
> +/*
> + * There isn't a simple hardware bit that indicates whether a CPU is running
> + * in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing the
> + * number CPUs sharing the L3 cache with CPU0 to the number of CPUs in

"number CPUs sharing" -> "number of CPUs sharing"?

> + * the same NUMA node as CPU0.
> + * It is not possible to accurately determine SNC state if the system is
> + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
> + * to L3 caches. It will be OK if system is booted with hyperthreading
> + * disabled (since this doesn't affect the ratio).
> + */
> +static __init int snc_get_config(void)
> +{
> +	struct cacheinfo *ci = get_cpu_cacheinfo_level(0, RESCTRL_L3_CACHE);
> +	const cpumask_t *node0_cpumask;
> +	int cpus_per_node, cpus_per_l3;
> +	int ret;
> +
> +	if (!x86_match_cpu(snc_cpu_ids) || !ci)
> +		return 1;
> +
> +	cpus_read_lock();
> +	if (num_online_cpus() != num_present_cpus())
> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> +	cpus_read_unlock();
> +
> +	node0_cpumask = cpumask_of_node(cpu_to_node(0));
> +
> +	cpus_per_node = cpumask_weight(node0_cpumask);
> +	cpus_per_l3 = cpumask_weight(&ci->shared_cpu_map);
> +
> +	if (!cpus_per_node || !cpus_per_l3)
> +		return 1;
> +
> +	ret = cpus_per_l3 / cpus_per_node;
> +
> +	/* sanity check: Only valid results are 1, 2, 3, 4 */
> +	switch (ret) {
> +	case 1:
> +		break;
> +	case 2 ... 4:
> +		pr_info("Sub-NUMA Cluster mode detected with %d nodes per L3 cache\n", ret);
> +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_L3_NODE;
> +		break;
> +	default:
> +		pr_warn("Ignore improbable SNC node count %d\n", ret);
> +		ret = 1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>   int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   {
>   	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
> @@ -1115,6 +1179,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   	unsigned int threshold;
>   	int ret;
>   
> +	snc_nodes_per_l3_cache = snc_get_config();
> +
>   	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
>   	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
>   	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;

With typo fixed:

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
