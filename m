Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E5293B7D
	for <patches@lists.linux.dev>; Tue, 22 Apr 2025 18:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745346001; cv=fail; b=p2VKktLCxHzLcweaJCn/tS5PCufSIactGzpXccWws/Ei+dYXestdRy9pVFCXd67okCE7bORuKVquaTowb0kGLMRmr21+oKu2GBI42J8tgm9rrXNBf84lKz+RvHM6OvG/vxwHF2IqQn+P3oE+SrjaftXlu0Rs/aTpaBeZmijz0jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745346001; c=relaxed/simple;
	bh=DSjfagC3Cj6+9/DAnBg96Zny9i2mKhVo5Qw1Fvolo5k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YRZMRqxvxxD6jUxsvDqwyc7Scc+YjjyUyk1yxK1l8HPrb1ojHoahZgSB/m1/XXArX9PBSwQPlg3WkEnVoTI6PKWoEcRgkO8UxmBuDmEx16ATdcogEXBtzyaG4KhA4hG14hbIKEhwTlbl5s6zCIZu81eWQ4Arcz8Xx/eph+sDogI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bEb/njPF; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEb/njPF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745345999; x=1776881999;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DSjfagC3Cj6+9/DAnBg96Zny9i2mKhVo5Qw1Fvolo5k=;
  b=bEb/njPFhVHUB1SiSfx3Ir4ZYRmKszaiXcmaJs2KaHp8BcxUisaRTeSP
   FRr4uyxyqfa6+zrQcbGT0/iJL/ck48Ptt9hwjWS5KvvsD3GAf+u/1uySi
   55n/o2l/MhOytyp5EoTEN9tdKQL0ly0WVto04Q2+XoRol++wnGNYd+LD8
   nt/2qyTLGh4afczFjeysrm+tDUyQ8fZMXyY+Uz5YZBE6DGEQaFQnK+3Gr
   R/ufokmbkmkE1FU7kSVvqthBo8NIqUqIXOWODerVencdE6meccPTl+0uX
   ObcfRt7z2d4D61tptekf0HGuGMon3ES/Dq0qNVracq5usWzLuh5mdZc7Z
   Q==;
X-CSE-ConnectionGUID: +STWPX21T/K2yiozqPBN3g==
X-CSE-MsgGUID: xzPZmKsVSqiNCRiSRejvTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46157633"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="46157633"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:19:59 -0700
X-CSE-ConnectionGUID: HeUarTI6QpuE9oU3ZFS1Gw==
X-CSE-MsgGUID: LrHuhAbdQRycw/eK+cUw5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="163136705"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:19:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 11:19:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 11:19:58 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 11:19:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zW1iK+nVvYrxZP49bxsOyK/Q6vY+Hxtm/Knch8CaaSTwDVDPFNSWKYAcFKGGDAO0JZFvSbpIJkjm/8Gq3senz58g0eAcS4jKrbbk6w6oGh0C7/aUIb4v/ZmZ/8D7QgIrfBap6b9D8q2LceXwhQXlL+4Spk1A3s0KhmvXXsECABat/f6GNBSnjYnpSeIId9oVbT3BTBOYLgN7DmEZVepng9DQTGAQFsIIjtrbG3MJ/v4C4mDUlkNyU6LkQ3nqeXn2cy3Sy4UhmZRnWxO9HKHnfU7Pex/JbyRcyNdULwfxTtoEADTFFfq8pnLuBMnTgI7ZN1WfJIoN35tfYeQpkJxbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVdnOIhDAd/cQ6YSKvetEDLHrvGGC8+ixujDUBQ2C2A=;
 b=ntMW3dcTwzEoYJvtUjnaMR9S68K2SqrPdwgfewikOGIwUoNJYOw+RmNHE8QBv0xLGQfZiMXv3WJmDQgB2P/lBjhrcboneRkvoXC+xHfrGsauM0bZOv5YhVp+t9/l4w+0rlEcegnKI76DAoJOPE+gSwBWL2qfWj2l34WmrS1HiVzUhB00Cv3YdpO4/IlMRzTI3xtXdQlsSDQMel01q2t5rH24bfgrbLAiT9TK5CgrAL4H3yXlKQ6Y8o86linYBsWTeN/t5CzgSR4UjfOpUKgNiFClyIliZ0aToAgpblm3A9Gh54bTsiQi6v5xVblX1S+pKmQk3jjfHTqsvbkCvneEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5820.namprd11.prod.outlook.com (2603:10b6:510:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 18:19:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Tue, 22 Apr 2025
 18:19:55 +0000
Message-ID: <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
Date: Tue, 22 Apr 2025 11:19:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/26] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-11-tony.luck@intel.com>
 <da51ba61-4ff0-4db4-a55f-743f6a3ea7da@intel.com>
 <aAaqbUk3gZbCan13@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aAaqbUk3gZbCan13@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0382.namprd04.prod.outlook.com
 (2603:10b6:303:81::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff8e3ff-1732-41a6-0673-08dd81ca4837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WjFremNHcERGKzFVYWtLdFpVYmd5dXczb0xwb2k0TVRNQkt3THJBYSthVXBx?=
 =?utf-8?B?Q1FnZ2pmRnRuSVNnQ0JESjlOMTJvYUlhSjdwQWZNR1p5TVNHbTZCeFVNcDYy?=
 =?utf-8?B?Ym16b0IzU2trelM3eG16QzVQRWx2dExJZmZhaFhkdXhlZktiNnVsRml0dU9l?=
 =?utf-8?B?b3BQUTVPb1lJZ3dCc3hVbUU0QUs3SUgvanFyMzM4aDIyQXlIcXJMaTQvc3dt?=
 =?utf-8?B?VFhzM3ZIUlVNTUdFT3ZpUmFrU25sQldWdTJTdlREQWxORDhZNVJ3V3dxQ1VW?=
 =?utf-8?B?YWtiMit1T2Rhc2QxZXd4S3BHOFVpRm9VYWo0Y3hDcWpYd1hCbURqNUtBRDc0?=
 =?utf-8?B?N1dPZDNDczZZSnBnNXdteVhnbDdCdFFZWEw4QnJKRFdMUXBLU1ZDcFgvQ1Ni?=
 =?utf-8?B?VUJ2bkxQRjErMmlXTGZmdTd3NXNQK3FkYldWZks5VEZLY25VQjBZcllsMmxF?=
 =?utf-8?B?aHRVODBHeHpFdDdzOXMwckppaUd4cWlXWmFObkljTTIrYjAzTU13aHJ4VkN2?=
 =?utf-8?B?UTFDY3FldCttS1JQdk1kdGVIOXROM1Y5anFBY2tSWThjUytBaHAwVVRDWnBl?=
 =?utf-8?B?cmZEZ3dORjJGUUpUL2RPV2UzSUttQ29pWVR3ODl0WWJ2YWNobk0zK3ZhVmo3?=
 =?utf-8?B?eUY5L0J6MCtBcm5kem9MSU95d3orR2l5OFJpaDVWZ25zOVNhVTgzQnc5QldW?=
 =?utf-8?B?SURSdTQ3U1lGbEI2TjFxbnVFZ2dERFVsQVdJRXIxSDA5bFBVWVYwTk56MDZh?=
 =?utf-8?B?RzdId3hGNGRIMFJrNXU2Z0orMHZNN1pldnhMRndGRjFGREFjRGc5VEkwQXZX?=
 =?utf-8?B?OXJndGRhcVFQQkM1eVRmMjNYbisxS01NcjNTbEpvcnQ0M0xhVy9SQkdmU1pY?=
 =?utf-8?B?d1VFMWIzd2dOZHZ2NFkzUVFvQlFib0gweHIwWjBybXhNV0hwci9ZRHY2ejk4?=
 =?utf-8?B?c2dEaUZxcytEU3ZCK0M2Sm9iSmxRTjBTdHFUTDNjVk5rdEN5cjBIdjJmb0ox?=
 =?utf-8?B?VmYybFE3aUwrNmpKempYVTlUVjJTUkpRbm00blUwOWtXd0ptM1ZxWjJDNmI5?=
 =?utf-8?B?MnFSTHVpMk1xR0liNmlZa3RjZ3JRa1g1ZUZoNk1naTZLTTU3bXUrb2IvcFVr?=
 =?utf-8?B?eTRqYjlHQ3hwa0s0ZkYyUUorOWsyb2FDTndQdW9FVkVBemc5OFNJZ1pzcnpW?=
 =?utf-8?B?cnVCU1l4ZFhLRnlLR1JrRkZFU01sMmRkdnpaRjZKRDkzWGJZZG5xSy9ac25N?=
 =?utf-8?B?d01WRnNFa0VGZVJjRWcrNjQxYWdLb2FvWVY1YlVoc0M0V1FCamUyWGdjOTAy?=
 =?utf-8?B?UGFLbCtkdDFzeWRIZWhPaTV4VlJ5cGcrVDNkZWsvQnVXelp2SGp2L3JKRlM5?=
 =?utf-8?B?N1EzbmVsZzZjWXhxSElpVzNzeHNmdzgzUE05c04reUhreGVUaEszemJVaXNp?=
 =?utf-8?B?bnF1cFREUUhFM2RibHhiMjcyVGovVk5tVTFLazFvNThCaWhGRUE4aGZ3WFJo?=
 =?utf-8?B?NFZiS3RSN2ZEdWRYcE95UjdkWW4vVE1mc0dZa05menJobkpsWXEwUlM0dWJu?=
 =?utf-8?B?ZVUzN21hSnRGQzhIN0N3V0lDdzVZUnE3citpUFVCRE9rejFJY2d1TWpHYjJ6?=
 =?utf-8?B?SXROdnNacDRFdUZFeCthQXBoVldUY0RCVXlENUhKdzlSbXRpaUNQRUkxRlM3?=
 =?utf-8?B?U09OaHlaNmRGY2hzSzZVT3lZbnZRdE9sRUZDYmVFTFFIWkdLUUNMMUlvUjVk?=
 =?utf-8?B?aHJHVU03elVkb1FwTVV4bTBab3doaDJ1R2RnZXVkbjJ4RGhDUmcyRW5xd3Rl?=
 =?utf-8?B?MkdyV004NW5CMUg4NEo4dUVuRVlkUW0vVU1yYWExRU5NYXZxbm5Qb1l0aVpw?=
 =?utf-8?B?V3U2cmI1elJoVFg0MVlRRlE2YldwbndDMmZlY2lZSHRWazVYWjV0SW9GSGFr?=
 =?utf-8?Q?lVsTrah2p/xLdFfhZ0Rsn7b2C0gxBRM4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1NSOXMzUUd4eUVWNmgzckF6TU1zUDdhbExlRzNwODlJaDNGWHRXcUd0VG82?=
 =?utf-8?B?aTdVZGlDenZYbW5tWW8zRXpjKzBZQzg0a3hLZVhEejZNellNNGh0Mk83cy9j?=
 =?utf-8?B?czF5a0Z1WitKVmxhNDVrTWI0alZiYk1LeHh1TE1tMmNKa09UcytFS0R0Yi93?=
 =?utf-8?B?V29LYmNCdmJlMUp1UWpLbWVYb1pEUk5xWk9iUnVmVU9rMUVjdndTWE5YelFW?=
 =?utf-8?B?T1BDOVpWcEhzRlhZVklRckNWVGI0SnRKY2crWVZjRmF3MEtTZkoyLzVleU52?=
 =?utf-8?B?bkcxdTFTQXV6YnFmTmE2N3p3MUV3RHZ1clZQZ3FOaEZka0lLUkRTaVRmM3Jq?=
 =?utf-8?B?T2FsSHFXY3FHWS8vTmZKWGNiM0lSY01NZHRXTUdxNy9WR2pDMnM4TVdEZWNC?=
 =?utf-8?B?UXZ1NnNqdUpoMjR2MGhFRUtLVU9oRG45cDJJQmdaYVF4WlBzTnA1WURqQVR5?=
 =?utf-8?B?NHlvQXVjYVZoSlFLcFBYd2V2Y2VyS21jS3pZM0FCVmVvdVgzZFZWY3RLN3Y2?=
 =?utf-8?B?VEc5WWx4d045V2hXMFgwT3QrS2E1TzhtcWpYbmxKckEyc3RiRDNFc0dvOHZi?=
 =?utf-8?B?QUs3bWRxeXlEUGx2aGNKNmtuWWx3dHBURHZjbEhvMitwcVdsTFRvYUxzTVdF?=
 =?utf-8?B?MGFvMUkzZ2Y1ZGtONTdLaUlYRVhveUs1dUxVWS9Ba2FUTkpLakdKL0pXV2NS?=
 =?utf-8?B?czFTZ1hjczhxMWx2UW41NDJvVTNsQ0Y0WElFUHp0OFJSbmdhYU9Ueko3MjhU?=
 =?utf-8?B?TldoY29iTTJMd1M1cXdRaTdoaEZTVCtNTVBUSEpCWWM1RHNPbTJ3UGkxbVJN?=
 =?utf-8?B?Tm9OZ3J3MlZJQWZ1cW9WSkVBcWtXb2R3dmtTeEZSeHlXRHcyWGhSQ3pFaGVM?=
 =?utf-8?B?VEdXVjlzV3ZCWkhNWXJ2b1ZyZjd2Z1ZsQmhiL2ZkQkkzZUJXdXA3eUNvbjNL?=
 =?utf-8?B?aGJGdlFVR2QwODNWUjdRWGRlSk9vYXlIS0hKb1A1MlJGa1lFZmNTVzFPZlla?=
 =?utf-8?B?QWVNUlRGZWNudkZPUXZjQUxZRmtGMUdGbWZRZTd0amUvZFlLSW0zQ3FGdEF3?=
 =?utf-8?B?MWFYZExubXB2TnNmQnV6czRQWVVLMEZadTg0cDZqZGZqQ1cweGtzdForS0dJ?=
 =?utf-8?B?NmJRYTFZbEgvcWsra1hzS1dtV2ZjOWlvMlN3OUZaNHQ0TXpTZGZ6aTlyaUx0?=
 =?utf-8?B?U1U2OVdIbmJkL0psS05Qa05XYlpPZ3IvRENVcWMrV0x4T3J0TlFmb3h2ODZV?=
 =?utf-8?B?Zmt4U1dSUitFdmdyMG1MYjU1QmkzcXNGZWxBRWxqdEU2cVIrSFBKZXpodS9D?=
 =?utf-8?B?d28zL1pZU2oydzkxZXd0K0JIZitPS016cklteDhYdnFmdXZpbUxIMlFXMisx?=
 =?utf-8?B?SzZyUHQ3aDFucXdXRnZrMk9BNm8rOXFnTE5mMEJFdFZaWmo2bWZBbXlWNjdy?=
 =?utf-8?B?Mm5IODJBMWpjdURaMHdnMVpzajhaUjk4MlpXcVBxZmVOSnV1b016V1p2bWtp?=
 =?utf-8?B?d0lKV3JudjZnMXFWUXdWeWgrR2lQTFFlWktLR1pjaGNNNTJGcWpPYzdxVkg4?=
 =?utf-8?B?UnJnTEFiblZOWUpqelROODJFaFZtSUhob0tCaHk4SkpxU2VSK3VsVWpQamQ5?=
 =?utf-8?B?dWVsOHpPTS9LQmkrYkZQSzhzdVV6dElYUkZ3dFpKbDg4UlNnWVUxaFhrMGkv?=
 =?utf-8?B?VWtTVzVoT0VKQ0NGOWpLYUJGUktZMXRPd0hqaExEY1c1b01FUVlyNTV3bnlp?=
 =?utf-8?B?UDJ4QVlTbXZGTDYwcGZMaFJNRzNjRGxBM1U4eXVyb2VJdFZXVndkMGJoMUVH?=
 =?utf-8?B?SWFxZnkwZGFvYzFOWmZKdVFNOU03TGMyY1NvaXZGWkhQc1RyeWd1aGhTUG13?=
 =?utf-8?B?NlBqRDFxSUIrR2d3ZjlpMktqQnhMS3NISVhnaTBDOFI0eDVHYTR0T25OemVB?=
 =?utf-8?B?Y042SXFqeDc1cmVXTXQzV1I5LzBjM29NdmE5K2U2QWE3c2ZzVUg4SWZocWNa?=
 =?utf-8?B?ckhzNnVMUC9CVWhTcGZveVptN3c1bVQ5K2FETG41WnozdS9vSVF5eERzRWNK?=
 =?utf-8?B?VUJsVlY2NHloRWF1WWIybUdvM1VoY1crcmdHbTJVNC9yVFUxeW1mZmFIM3l2?=
 =?utf-8?B?L0MyUE1sczVTaFA5VmVQcU5vV3N6NTZ0R05WNjhucUVFNlc3aXBvcDZoUkUr?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff8e3ff-1732-41a6-0673-08dd81ca4837
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 18:19:55.2984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUWszM5fHUR/BU5hqvl43xkAX3SOYSoRvUpMewlkhTKh0HRW3OwxZyP+5KUkP5YQugvIoppMEaYhDafIkwo47K2bQpt0xOZbsy1Hw3+AsV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5820
X-OriginatorOrg: intel.com

Hi Tony,

On 4/21/25 1:28 PM, Luck, Tony wrote:
> On Fri, Apr 18, 2025 at 03:54:02PM -0700, Reinette Chatre wrote:
>>> @@ -619,7 +622,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>>>  			goto out;
>>>  		}
>>>  		d = container_of(hdr, struct rdt_mon_domain, hdr);
>>> -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
>>> +		mask = md->any_cpu ? cpu_online_mask : &d->hdr.cpu_mask;
>>> +		mon_event_read(&rr, r, d, rdtgrp, mask, evtid, false);
>>
>> I do not think this accomplishes the goal of this patch. Looking at mon_event_read() it calls
>> cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU) before any of the smp_*() calls.
>>
>> 	cpumask_any_housekeeping()
>> 	{
>> 		...
>> 		if (exclude_cpu == RESCTRL_PICK_ANY_CPU)
>> 			cpu = cpumask_any(mask);
>> 		...
>> 	}
>>
>> cpumask_any() is just cpumask_first() so it will pick the first CPU in the
>> online mask that may not be the current CPU.
>>
>> fwiw ... there are some optimizations planned in this area that I have not yet studied:
>> https://lore.kernel.org/lkml/20250407153856.133093-1-yury.norov@gmail.com/
> 
> I remember Peter complaining[1] about extra context switches when
> cpumask_any_housekeeping() was introduced, but it seems that the
> discussion died with no fix applied.

The initial complaint was indeed that reading individual events is slower.

The issue is that the intended use case read from many files at frequent
intervals and thus becomes vulnerable to any changes in this area that
really is already a slow path (reading from a file ... taking a mutex ...).

Instead of working on shaving cycles off this path the discussion transitioned
to resctrl providing better support for the underlying use case. I
understood that this is being experimented with [2] and last I heard it
looks promising.

> 
> The blocking problem is that ARM may not be able to read a counter
> on a tick_nohz CPU because it may need to sleep.
> 
> Do we need more options for events:
> 
> 1) Must be read on a CPU in the right domain	// Legacy
> 2) Can be read from any CPU			// My addtion
> 3) Must be read on a "housekeeping" CPU		// James' code in upstream
> 4) Cannot be read on a tick_nohz CPU		// Could be combined with 1 or 2?

I do not see needing additional complexity here. I think it will be simpler
to just replace use of cpumask_any_housekeeping() in mon_event_read() with
open code that supports the particular usage. As I understand it is prohibited
for all CPUs to be in tick_nohz_full_mask so it looks to me as though the
existing "if (tick_nohz_full_cpu(cpu))" should never be true (since no CPU is being excluded).
Also, since mon_event_read() has no need to exclude CPUs, just a cpumask_andnot()
should suffice to determine what remains of given mask after accounting for all the
NO_HZ CPUs if tick_nohz_full_enabled().		

Reinette

> 
>> Reinette
> 
> [1] https://lore.kernel.org/all/20241031142553.3963058-2-peternewman@google.com/
>>

[2] https://lore.kernel.org/lkml/CALPaoCgpnVORZfbKVLXDFUZvv8jhpShHPzB3cwdLTZQH1o9ULw@mail.gmail.com/
