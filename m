Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337A6524DC
	for <patches@lists.linux.dev>; Fri, 10 May 2024 21:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376262; cv=fail; b=e9XZ32RBkHVRfkaVVJKdrgjl/TETtrn+cvNgsqFzKW0BXtX6tG3Og4han0ic/hevIQDiDpWG3I8yCEQmwgFv6ie1xgFvL24vXRuG4WlbVT/H6RoGr7ex3UErOPkc6ZBzTyiSY78ROACKyRJdP+w35RGm6zoHcTLUnXEVM4AdAME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376262; c=relaxed/simple;
	bh=K9YsHUEy5A2VuOBRx2VCuV53QMRYGU/QtgOcJITdgMY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lrbq5BjtYNZtXgNQ+kFjwsQVZeSrZ/pFvStwpr/Gq9wjqFA/RricxKyr7Ix0eoJd+kCDyJ6u81ub+BA+Pe4mHiEhjcJY0XIYgrlONYwi1q9O95oMxQcPsS4faXVTBoUOv/+DIP1D5r/I6FYPGyvcVR1bTlYzZbF4o/idr+jX7O0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BwPnV+OL; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BwPnV+OL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715376260; x=1746912260;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K9YsHUEy5A2VuOBRx2VCuV53QMRYGU/QtgOcJITdgMY=;
  b=BwPnV+OL9KS5dsrHuTkkjMaRdfuQphTxyNr/8h5ps7FC+TzyZ27QDKGC
   NEwOEozALH05nVZLJoTXtv8Bea3TPwuUh5iASLlZVjXx4G8pJ4QVxz3+y
   Oo00GzBt50bThXCJ/XcrDp6j9dKjBC+uhps94TmsmFsQHx9KWbFVElFjw
   4kDnbWvdbUgx879A9fVZn9Rwfyyq9OxRhOKC9Ddchx6r17uP1FbOG76Fi
   j4zpYKMnHAUIUaSj22ZgnzgvkZDiQu0gnmfl0YH3R6rJcNTMl5B19ULjG
   O229tldThrZP7OuQfPbI4uELbiWfnm5EeaPyytu7D+BuPmDX/TZObNS33
   Q==;
X-CSE-ConnectionGUID: 56lvCXyMRsemyWULH0qPow==
X-CSE-MsgGUID: msUg+QquTIW51weDQ6KMNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="21978722"
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="21978722"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 14:24:19 -0700
X-CSE-ConnectionGUID: mU7j8oQdRPOjIDQO/HxO+g==
X-CSE-MsgGUID: KkyNi2ozRgWGRkz/GYg3Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="60587382"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 May 2024 14:24:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 14:24:19 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 14:24:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 10 May 2024 14:24:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 14:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wr0AerUAT8h7czZKdKuTzP6Ey8Kt8GNSqtdERWH4mQNklP+o3+MHqC9ua9Iz7UsQmvRWQ9N3JJCsh6EKKJOOui1ojKSYvEDd9M45hghmRJMAngbEIJ2ZxDk5fMk8ZtYMElMsfaCAtg3RuLlPm43brXMrI0VU+jpDGttU6mV/sXx77ohQGd4u2UAdcJQDEFtKuh3WkTbokwkeSVwXj2UtiDacHkQ1bzMs+LjRIXVoCllDEsnOgJhB4mUd4sns5dIu9K8vCu4qTDArKy3z8ELe8bplgHzyGhGZQNsxVPFB8dteZJtEFX4LcdRW9ZiZ6r1SBtcANKFK6qfXWuohZrXodg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKC/Ezg4TksKxJCUyPdMf05izgZvVOWlB1EzwYRvoAM=;
 b=ULTBqZaXa6eP3Ns218ea+PcpY3umGP0Bkbtf/ejUYJmjowIyT5de7IHwb+zZnHJi4I8LUrhe61b27Y/PCvvbsLTTm+HsSH1Dff9K8Bkm1RAbV/oUsvBneq85IQ7bKMF00XnljZRFo8K5u6f/zIekOhbSiOg6iJ+Do8bLpNyneRHg0m2jxy3ksR2fRbQmebyX50TombM/3Lx3p11b/ZyrezA7dZgt5V9uZUIyZdIWujWcTZGgEKPB2w53+se0OAqLp9EyukUjY1Z/dZs3pSVf7wXX2211tIgKNnfcggTiWidRKCRDE6Q1TL+PJFla5L1HZNZM9BnJLwG+/cVu709LFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6914.namprd11.prod.outlook.com (2603:10b6:930:5a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 10 May
 2024 21:24:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 21:24:15 +0000
Message-ID: <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
Date: Fri, 10 May 2024 14:24:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240503203325.21512-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0342.namprd04.prod.outlook.com
 (2603:10b6:303:8a::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: fae8193d-98a9-45c3-5711-08dc71378b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UFFxQm1BUnZwNXNDSTB2MTFUL29CQTZsR1JFakx1NnF0TndodHptcVhObmxB?=
 =?utf-8?B?Q2wvY3p6anhmUVYwMWFxTGhNZFBJRWhiaERmdXZaWWYrSkc3c1hyYTFzZW1s?=
 =?utf-8?B?VXNhaDNyQ01qUFowV2dJYXV5V1NuZkRjVFk2OC9XeVloTVAxZkgzUDlEK2tq?=
 =?utf-8?B?TFNMQWdTQUlGMFJZb0dJUHFuaGxlTm5XS0VveUFIRlljSmtGWkpKZWVIK1Ex?=
 =?utf-8?B?ZGxxejFCcmZjVFUrTzBXbkNGYmpWS0RvbmtCSHJYYUc1SGMrT2hwc3NEU3pM?=
 =?utf-8?B?NnRZM0xPd3haWFVaV2ZYMy91VXA2elRydG9ma0hVZlF6dzl1QU0zcXVSaWZN?=
 =?utf-8?B?aCtUVkhONGF3N0JJVmxvQmxTRmluQXlPWWRVTHFHdnpPNmJFRXhkUnQ2UlZD?=
 =?utf-8?B?U0pXUm92SVRSRkltVERWWVZQRU1vZzVZeThBaFh5b0pYOU8xelcyNnoySGsy?=
 =?utf-8?B?Z2JVeXV1ckhwZTZ5am16d2orbk9uNjFsbTJGQ3pTeTNFN3ZSRFFORUQ4MFFM?=
 =?utf-8?B?VGkzVTd6UjAyRTNaNkFkYkJOOTBVRDFkRDhWQWtGNmNyRE1FRFB0cGo5YUJV?=
 =?utf-8?B?QVRnNE9CMDB0ZmtzbERTZ1E1bWZ5Q0lrV2QrTS9taWpmZXdmbnl6MzVvdHdZ?=
 =?utf-8?B?QnNndy9SK2swdTczYzM3TllCdmRxaGxQY3RHUDd1Y2laSWZ0c0pKdWpUUjE0?=
 =?utf-8?B?ZlhYcTNaQW9kQ0VVZ2E2UzVkbUlVN09lMi9PbmUrdXpZWkpKNlRIdTYzQUxQ?=
 =?utf-8?B?aEtyalA3bEc2b1BEMVR3eEE1MG10dlMwbCtKOFF3NkQ1dldnOGVKOTJyWFlH?=
 =?utf-8?B?bjVITmQ0K2M4SUJqSmwzZXVvUTFHZkJmL0syZW5hbkxxcmZSTEtjS2VscUE3?=
 =?utf-8?B?RVVDRGs2R3liOUNXR0tZQTVnSEp2d292K1B1RDJtWGxUNlQxYTNjQmlPQ0VV?=
 =?utf-8?B?Y0RaSTMyRjc1ZW9YQ0JaZTJhTnUrOTh5Y1BmdDZXRmZRMmI2UVFMNzhncGF0?=
 =?utf-8?B?OWpLWUFERUZsT3krSE9CMU1JZHgySjhTYkUzTUV5OUlUeXkxMjZJdTJhaW5P?=
 =?utf-8?B?QWhYN2g2c0NsTzE0QXU5b1ZZczc0NjhaWVE2aUl3dUZRYnNqL0NkejNGZUF1?=
 =?utf-8?B?NEtTc1dZeEYxaFJaZWhwdTUxbVNqUG5lbmlUYXlydlFTU3NwMEE1aitjS2lY?=
 =?utf-8?B?MTl4c2pxMHNZeXhvRlZnU3U0TVc2TVdtT0VTOXY1VjNGb0ZKVFdINDE0UG1Q?=
 =?utf-8?B?RUZQM3dzcUNkYlZ0SVhHTC9wUUEzTTJnN1lRMUcxRCtYbkNjNjhRZFpyVE1W?=
 =?utf-8?B?SzJLUUFyVmpxTW5iRCtuN0JPK0ZmYXF1MXVVOUE2NDBtSjJ6dkdLeldrUWZR?=
 =?utf-8?B?bmtoVUZrT080aHF3LzJEVElzalFCVkd4eXpsb3FxWlRZWVBTWUlYNmZSdzY3?=
 =?utf-8?B?VU03bFM5UCsyY0t0TDdoZTNYOVZaanpBV3MrMG14SHBHL3psb0x4QjN3M3F6?=
 =?utf-8?B?RXRIMDdVbHBWbFBNMVR5WXJiWUtQZ2dENUhSMjAwYVZmYThjOUtENWpUS1Ns?=
 =?utf-8?B?OEYrL3pSZGFWaHRpaTcxN1NGS2xzcktkNU9BcnY2Lzh4L1ZUVDVBZWN0SVNJ?=
 =?utf-8?B?VDB2WGh4aFozNzZrekRUWk5qMlZhdHo5YzdCWFpuODJ4TG5XRWtYc1JSOVN6?=
 =?utf-8?B?c0s0WDFSYmVZcW84NVEwQU1jMnlHdjNYSmZhdXVWekl3SEJqSkF6c2RRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWU5OU55SzBYbG9LMFBJL1VhM1JqazllQ2NMRjcrUUE0bmtPNnF1eEJla2Z3?=
 =?utf-8?B?OWdCTzFoZjNyTE4vYVhESGJrOGJIZ2Rqb2VMWW9EcTFtOEt5V3pYQlI4cGRK?=
 =?utf-8?B?ZXlPZEtleW1Na0RFNHNDdm1PdVcvSm1oZDlUTTdFQmVMZktpR0JaOXRhMit0?=
 =?utf-8?B?YmdGakM0WFFKZFROY2FmMlRNUHJyQ2UwbWFTSnpoZ2Fzcm1YVWpPOFZKL1hX?=
 =?utf-8?B?d3NIT1NLbVpjNnYrQVpDWmorV2d1aU5ERDErampOb09xN0NKRDc3dk5nZ0Vq?=
 =?utf-8?B?cUoxdm1wSU5SU1VGOTN4Y1k4YW91dVRjS0hRdklHUEZUWDdRZ2MrVzVrcU1h?=
 =?utf-8?B?S01Va0dGSExpOHg1akdSbUFDZjdKWTFUWWpzcDl2NlEzNkQwMkNjZ0VOVmc4?=
 =?utf-8?B?M0RvRGlhSUFtTHlSK3NwODNyVU03enJGdGRMckZ2dUd2UXV1a1BIanJ2ZDNn?=
 =?utf-8?B?aTZqWk1uWnVINmxROGpZMUNhK1p5cUNac3hGQTBuUkwwV2p6elltOEFpTGtS?=
 =?utf-8?B?UENmaFc3d0VETDdyQVlod1hibk5JV09VQzBTb0VQY3R0WHR1Qmh4ZjN5MmQx?=
 =?utf-8?B?Q3BFeStlcW5nUW8xNUQ2SUR0V0ZXZzZPSG1NYlhlRkk1N0FudU0vOWlxTGhQ?=
 =?utf-8?B?U0dsc2kzSHRJNWxVNjdSYUZodmZ6VTlrMjNsbkpidWpIb0p0aTNldWQrb0RI?=
 =?utf-8?B?Y09zZWVCZ1kwS3l0MGtFZTViSXJLYkhvQjRwdkZRYkFZMWd2aWY1RElyaUxo?=
 =?utf-8?B?WkRtL3lRamIrVSt1b3NZSGZHaWRNU2lHSFhOT0ZDMU1jbWZpRlVPT0c1dmdy?=
 =?utf-8?B?cWRjY1d3RDJNd0hMd0lXNzRFUjJHUmtlT081M01ibVR1ZmREM1YvYzNFRkJW?=
 =?utf-8?B?OXJsNDFBODBQT0lTWCtjMDJTWnRCOGY3T29LNTNuSlJMQnorV29XaVlBWjRq?=
 =?utf-8?B?bTdvb252R3VqcWI4WlcxTWJmK2U3aHAxOFBBdzdYWFpOU2dPVXBTOGVjS1pO?=
 =?utf-8?B?UDNvYnpOSmMzazMxeUJQYm8wYTR5MDVpeTM5bFBZelAyWGZYRWN4d2JSV0ZO?=
 =?utf-8?B?eDRKQWR5eHZ0b0l1dnIxL1VrOS91UVR2Rm9YeVdnRzY3WWRPSCtScS9tT3Rz?=
 =?utf-8?B?R0czUm8zVmdxeVAzM0ZZVzlPUmRVYlFrTjNKY2VoS0ZqNXFiK1UxNU0wSEpa?=
 =?utf-8?B?NGlkZ2NSRTE3ZWc0WTZWZXZuYkpGem1EZWpPd29ydjRobmJRODNJMEQ3ZEx2?=
 =?utf-8?B?VHpBZHU3b3BaVkd5anlESnNQTlQvWm9ET2w3WXF6VEd2SWhmMm4vOEJaRTQz?=
 =?utf-8?B?WVVVTnBiUkNLRWc3eXlYTW95S3YzZlA3czIxU0lqMTdkeCt6bEdPMzd6NlIv?=
 =?utf-8?B?ZDBHVE5ZRGI0UEc4c0lMb3hzbnhOeko0TnpoVE9ZRTdtTWpkaWtrK2NoYlJj?=
 =?utf-8?B?bVdIZnNtdW4wSnVNUThXa2RsUkNVNFNjbnpaTUlDZFdHZkxSZnZwQzU2VEVl?=
 =?utf-8?B?VGJ1YVNqaGxCUkl4NjY1OHFTbThTQnNacVBEWUZWVHhYTzJKQjM2WmZia3hU?=
 =?utf-8?B?R1QzR0g0d1hBeURhelRwc282NjV1dWRUQnJHU1g0V1lxblYxU1dJRkJObFRt?=
 =?utf-8?B?ZU5MZmRPR2dhR2VGZFJEc08wK2xPNHpjSTR4WVY3ZzFGQ3ZmbFNOU1g5cGoy?=
 =?utf-8?B?clZaOWpKMmdVaXFDSDVkdjVLd3FTSkdhOVVNbG5PbjkxK0RFWkV1UFhwclBF?=
 =?utf-8?B?Zm9QOTVGbkJoQ0dyZXVlT0lNL0tMWEs5UmphLzBvN0d6VW1ZdmxqT3ZtSmtM?=
 =?utf-8?B?RmtncmgxcThCNThPNlJRVlMxbGI2WFhUMDA0bXpnYUF1YnAxM0xYNmE4SkFI?=
 =?utf-8?B?WFJlTVE2QnBhMnZPUUYzajZ3VUhzOFF3UE1tYVJHNE9lTGFNMG4ycnRaRjc5?=
 =?utf-8?B?MW9EcjdDTWxRZ1RvMkZmVGVNZHJWbERaWld4b3FreVl5T2dQbm5sOEZrQ3Jo?=
 =?utf-8?B?QkFhUWkzZVVhV2NRR3lwS2N3ZXp5VnptUG5vWi9iLzQzUU4rd1o4UmFEVUJ5?=
 =?utf-8?B?UHpNUVpSSFJHbGZ2L2ZzdDNiQVAvbWsvczRNNVBCSEhEVlFRaGh5dUJzZVEw?=
 =?utf-8?B?VDMwTGJkTGtvMjhuc2M4YzFyQm95czNKbVFXUkZqRUxJVStVN1VyOHNPbVMz?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fae8193d-98a9-45c3-5711-08dc71378b4c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:24:15.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0Eli6HpunVWs4527+vs3OeV7Qh2lgrEPaevHeDnJyErW5hwq0MAnzPveI19J3ZVRUNES9bRFFqhKZRhATVMeKVI2+3islUC6stYMnvG7bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6914
X-OriginatorOrg: intel.com

Hi Tony,

On 5/3/2024 1:33 PM, Tony Luck wrote:

(Could you please start the changelog with some context?)

> Add a field to the rdt_resource structure to track whether monitoring
> resources are tracked by hardware at a different scope (NODE) from
> the legacy L3 scope.

This seems to describe @mon_scope that was introduced in patch #3?

> 
> Add a field to the rdt_mon_domain structure to track the L3 cache id
> which can be used to find all the domains that need resource counts
> summed to provide accurate values in the legacy monitoring files.

Why is this field necessary? Can this not be obtained dynamically?


> 
> When SNC is enabled create extra directories and files in each mon_data
> directory to report per-SNC node counts.

The above cryptic sentence is the closest the changelog gets to explaining
what this patch aims to do. Could you please enhance the changelog to
describe what this patch aims to do and more importantly how it goes about
doing so? This patch contains a significant number of undocumented quirks 
and between the cryptic changelog and undocumented quirks in the patch I find
it very hard to understand what it is trying to do and why.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                   |   4 +
>  arch/x86/kernel/cpu/resctrl/internal.h    |   5 +-
>  arch/x86/kernel/cpu/resctrl/core.c        |   2 +
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c |   1 +
>  arch/x86/kernel/cpu/resctrl/monitor.c     |  52 +++++++---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 115 +++++++++++++++++-----
>  6 files changed, 137 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 5c7775343c3e..2f8ac925bc18 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
>  /**
>   * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
>   * @hdr:		common header for different domain types
> + * @display_id:		shared id used to identify domains to be summed for display
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
>   * @mbm_total:		saved state for MBM total bandwidth
>   * @mbm_local:		saved state for MBM local bandwidth
> @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
>   */
>  struct rdt_mon_domain {
>  	struct rdt_domain_hdr		hdr;
> +	int				display_id;

(it is not clear to me why this is needed)

>  	unsigned long			*rmid_busy_llc;
>  	struct mbm_state		*mbm_total;
>  	struct mbm_state		*mbm_local;
> @@ -187,6 +189,7 @@ enum resctrl_scope {
>   * @num_rmid:		Number of RMIDs available
>   * @ctrl_scope:		Scope of this resource for control functions
>   * @mon_scope:		Scope of this resource for monitor functions
> + * @mon_display_scope:	Scope for user reporting monitor functions
>   * @cache:		Cache allocation related data
>   * @membw:		If the component has bandwidth controls, their properties.
>   * @ctrl_domains:	RCU list of all control domains for this resource
> @@ -207,6 +210,7 @@ struct rdt_resource {
>  	int			num_rmid;
>  	enum resctrl_scope	ctrl_scope;
>  	enum resctrl_scope	mon_scope;
> +	enum resctrl_scope	mon_display_scope;
>  	struct resctrl_cache	cache;
>  	struct resctrl_membw	membw;
>  	struct list_head	ctrl_domains;
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 49440f194253..d41b388bb499 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -132,6 +132,7 @@ struct mon_evt {
>   *                     as kernfs private data
>   * @rid:               Resource id associated with the event file
>   * @evtid:             Event id associated with the event file
> + * @sum:               Sum across domains with same display_id
>   * @domid:             The domain to which the event file belongs
>   * @u:                 Name of the bit fields struct
>   */
> @@ -139,7 +140,8 @@ union mon_data_bits {
>  	void *priv;
>  	struct {
>  		unsigned int rid		: 10;
> -		enum resctrl_event_id evtid	: 8;
> +		enum resctrl_event_id evtid	: 7;
> +		unsigned int sum		: 1;
>  		unsigned int domid		: 14;
>  	} u;

(No explanation about why evtid had to shrink and why it is ok
to do so.)

>  };
> @@ -150,6 +152,7 @@ struct rmid_read {
>  	struct rdt_mon_domain	*d;
>  	enum resctrl_event_id	evtid;
>  	bool			first;
> +	bool			sumdomains;
>  	int			err;
>  	u64			val;
>  	void			*arch_mon_ctx;
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index cb181796f73b..a949e69308cd 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -71,6 +71,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
>  			.name			= "L3",
>  			.ctrl_scope		= RESCTRL_L3_CACHE,
>  			.mon_scope		= RESCTRL_L3_CACHE,
> +			.mon_display_scope	= RESCTRL_L3_CACHE,
>  			.ctrl_domains		= ctrl_domain_init(RDT_RESOURCE_L3),
>  			.mon_domains		= mon_domain_init(RDT_RESOURCE_L3),
>  			.parse_ctrlval		= parse_cbm,
> @@ -613,6 +614,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  
>  	d = &hw_dom->d_resctrl;
>  	d->hdr.id = id;
> +	d->display_id = get_domain_id_from_scope(cpu, r->mon_display_scope);
>  	d->hdr.type = RESCTRL_MON_DOMAIN;
>  	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 3b9383612c35..a4ead8ffbaf3 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -575,6 +575,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	resid = md.u.rid;
>  	domid = md.u.domid;
>  	evtid = md.u.evtid;
> +	rr.sumdomains = md.u.sum;
>  
>  	r = &rdt_resources_all[resid].r_resctrl;
>  	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index d0bbeb410750..2e795b261b6f 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -16,6 +16,7 @@
>   */
>  
>  #include <linux/cpu.h>
> +#include <linux/cacheinfo.h>

Can this be alphabetical?

>  #include <linux/module.h>
>  #include <linux/sizes.h>
>  #include <linux/slab.h>
> @@ -187,18 +188,8 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>  
>  static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>  {
> -	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> -	int cpu = smp_processor_id();
> -	int rmid_offset = 0;
>  	u64 msr_val;
>  
> -	/*
> -	 * When SNC mode is on, need to compute the offset to read the
> -	 * physical RMID counter for the node to which this CPU belongs.
> -	 */
> -	if (snc_nodes_per_l3_cache > 1)
> -		rmid_offset = (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> -

This removes code that was just added in previous patch. Can the end goal
be reached without this churn? I expect doing so will make this patch easier to
follow.

>  	/*
>  	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
>  	 * with a valid event code for supported resource type and the bits
> @@ -207,7 +198,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>  	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>  	 * are error bits.
>  	 */
> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid + rmid_offset);
> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
>  	rdmsrl(MSR_IA32_QM_CTR, msr_val);
>  
>  	if (msr_val & RMID_VAL_ERROR)
> @@ -291,7 +282,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> +	if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
>  		return -EINVAL;

Does this mean that when SNC is enabled then reading data for an event within a particular
monitor domain ("node scope") can read its data from any CPU within the L3 domain
("mon_display_scope") even if that CPU is not associated with the node for which it
is reading the data?

If so this really turns many resctrl assumptions and architecture on its head since the
resctrl expectation is that only CPUs within a domain's cpumask can be used to interact
with the domain. This in turn makes this seemingly general feature actually SNC specific.

  
>  	ret = __rmid_read(rmid, eventid, &msr_val);
> @@ -556,7 +547,7 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>  	}
>  }
>  
> -static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> +static int ___mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr, u64 *rrval)
>  {
>  	struct mbm_state *m;
>  	u64 tval = 0;
> @@ -574,11 +565,44 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	if (rr->err)
>  		return rr->err;
>  
> -	rr->val += tval;
> +	*rrval += tval;
>  

Why is rrval needed?

>  	return 0;
>  }
>  
> +static u32 get_node_rmid(struct rdt_resource *r, struct rdt_mon_domain *d, u32 rmid)
> +{
> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
> +
> +	return rmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> +}
> +
> +static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> +{
> +	struct rdt_mon_domain *d;
> +	struct rmid_read tmp;
> +	u32 node_rmid;
> +	int ret = 0;
> +
> +	if (!rr->sumdomains) {
> +		node_rmid = get_node_rmid(rr->r, rr->d, rmid);
> +		return ___mon_event_count(closid, node_rmid, rr, &rr->val);
> +	}
> +
> +	tmp = *rr;
> +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> +		if (d->display_id == rr->d->display_id) {
> +			tmp.d = d;
> +			node_rmid = get_node_rmid(rr->r, d, rmid);
> +			ret = ___mon_event_count(closid, node_rmid, &tmp, &rr->val);

If I understand correctly this function is run per IPI on a CPU associated
with one of the monitor domains (depends on which one came online first),
and then it will read the monitor data of the other domains from the same
CPU? This is unexpected since the expectation is that monitor data
needs to be read from a CPU associated with the domain it is
reading data for.

Also, providing tmp as well as rr->val seems unnecessary?

> +			if (ret)
> +				break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * mbm_bw_count() - Update bw count from values previously read by
>   *		    __mon_event_count().
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 0923492a8bd0..a56ae08ca255 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3011,57 +3011,118 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
>   * and monitor groups with given domain id.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   unsigned int dom_id)
> +					   struct rdt_mon_domain *d)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct rdt_mon_domain *dom;
> +	bool remove_all = true;
> +	struct kernfs_node *kn;
> +	char subname[32];
>  	char name[32];
>  
> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> +	if (r->mon_scope != r->mon_display_scope) {
> +		int count = 0;
> +
> +		list_for_each_entry(dom, &r->mon_domains, hdr.list)
> +			if (d->display_id == dom->display_id)
> +				count++;
> +		if (count > 1) {
> +			remove_all = false;
> +			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		}
> +	}


This seems awkward. I wonder if it may not be simpler to just
remove the directory and on completion check if the parent has
any subdirectories left and remove the parent if there are no
subdirectories remaining. Something possible via reading the inode's
i_nlink that is accessible via kernfs_get_inode(). What do you think?

> +
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> -		sprintf(name, "mon_%s_%02d", r->name, dom_id);
> -		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> +		if (remove_all) {
> +			kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> +		} else {
> +			kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);
> +			if (kn)
> +				kernfs_remove_by_name(kn, subname);
> +		}
>  
> -		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
> -			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> +		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
> +			if (remove_all) {
> +				kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> +			} else {
> +				kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);
> +				if (kn)
> +					kernfs_remove_by_name(kn, subname);
> +			}
> +		}
>  	}
>  }
>  
> -static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> -				struct rdt_resource *r, struct rdtgroup *prgrp)
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +			     struct rdt_resource *r, struct rdtgroup *prgrp,
> +			     bool do_sum)
>  {
>  	union mon_data_bits priv;
> -	struct kernfs_node *kn;
>  	struct mon_evt *mevt;
>  	struct rmid_read rr;
> -	char name[32];
>  	int ret;
>  
> -	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
> -	/* create the directory */
> -	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> -	if (IS_ERR(kn))
> -		return PTR_ERR(kn);
> -
> -	ret = rdtgroup_kn_set_ugid(kn);
> -	if (ret)
> -		goto out_destroy;
> -
> -	if (WARN_ON(list_empty(&r->evt_list))) {
> -		ret = -EPERM;
> -		goto out_destroy;
> -	}
> +	if (WARN_ON(list_empty(&r->evt_list)))
> +		return -EPERM;
>  
>  	priv.u.rid = r->rid;
>  	priv.u.domid = d->hdr.id;
> +	priv.u.sum = do_sum;
>  	list_for_each_entry(mevt, &r->evt_list, list) {
>  		priv.u.evtid = mevt->evtid;
>  		ret = mon_addfile(kn, mevt->name, priv.priv);
>  		if (ret)
> -			goto out_destroy;
> +			return ret;
>  
>  		if (is_mbm_event(mevt->evtid))
>  			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);

I do not think that the "do_sum" file should be doing any initialization, this
will be repeated for the "real" mon domain, no?

>  	}
> +
> +	return 0;
> +}
> +
> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> +				struct rdt_mon_domain *d,
> +				struct rdt_resource *r, struct rdtgroup *prgrp)
> +{
> +	struct kernfs_node *kn, *ckn;
> +	char name[32];
> +	bool do_sum;
> +	int ret;
> +
> +	do_sum = r->mon_scope != r->mon_display_scope;
> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
> +	if (!kn) {
> +		/* create the directory */
> +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> +		if (IS_ERR(kn))
> +			return PTR_ERR(kn);
> +
> +		ret = rdtgroup_kn_set_ugid(kn);
> +		if (ret)
> +			goto out_destroy;
> +		ret = mon_add_all_files(kn, d, r, prgrp, do_sum);

This does not look right. If I understand correctly the private data
of these event files will have whichever mon domain came up first as
its domain id. That seems completely arbitrary and does not reflect
accurate state for this file. Since "do_sum" is essentially a "flag"
on how this file can be treated, can its "dom_id" not rather be
the "monitor scope domain id"? Could that not help to eliminate 
that per-domain "display_id"?

> +		if (ret)
> +			goto out_destroy;
> +	}
> +
> +	if (do_sum) {
> +		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> +		if (IS_ERR(ckn))
> +			goto out_destroy;
> +
> +		ret = rdtgroup_kn_set_ugid(ckn);
> +		if (ret)
> +			goto out_destroy;
> +
> +		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		if (ret)
> +			goto out_destroy;
> +	}
> +
>  	kernfs_activate(kn);
>  	return 0;
>  
> @@ -3077,8 +3138,8 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  					   struct rdt_mon_domain *d)
>  {
> -	struct kernfs_node *parent_kn;
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct kernfs_node *parent_kn;
>  	struct list_head *head;
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> @@ -3950,7 +4011,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	 * per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
> +		rmdir_mondata_subdir_allrdtgrp(r, d);
>  
>  	if (is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);

Reinette
