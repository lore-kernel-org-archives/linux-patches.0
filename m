Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBA9231C9F
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745013201; cv=fail; b=qM5xb2e7KkjxndEy19mgkbSV96qB2xXPRMt4y0hLJSnaCLJ3ghzXkMn8WK6QHniopR2BSjlYplil686AmRHT5irxfNoL8V9ZeCTtj8O46C1At/uduGE//unkTucleBZnHB9EslPWx8NoZLDhh8BgtV6zkdNIkqQE83OdjhmeNeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745013201; c=relaxed/simple;
	bh=8ScPygzxKton/KTNiImGeqjPHkko6FMfox8yhKMf9VE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cXmWg+hsBLjVa0u4HaT5Ji86BviWwkiCbO+Y1jfkZbG2YNu+TF44tf6fhWUyh4UGAFIQggZakpO3kA+Rgn/ITEF0+9PUy1nNfiiNghhR9eg75aqNvwTSgS/MelCqpx2BoTPUzZ21p0IzUBAtm6oDw8nTT61Y6auZt2PCtogNA3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qri5rR0O; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qri5rR0O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745013200; x=1776549200;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8ScPygzxKton/KTNiImGeqjPHkko6FMfox8yhKMf9VE=;
  b=Qri5rR0Oah2PQHQO3iXAuN85Shw7BR8C2gxKVceniCNlQFjb7PQaWw2Q
   247cl2yAcJYOyFhiDPMQ7efIrNnPdCZ5q2aYOFGAwL/NyEvXaRHj2xBmu
   stUX2u151okZeeq1e+HE/43m8pMBWFh8Z8U/6vGNYgsLB8Tf5i/0eGFZY
   fWdtn6Raqikeeln43aLZro6sOYMvjWkWh6mwHyhGLB3z45DLv9cWJK7ft
   DPHBxffWUk0kfqhenyCoA5HCsKaiuLWh2dcxKjH6euE7pzG7HyY71lzf+
   M73r+DPv8q/IicLpUSBgB3Allt3QziIMfLNx0KmccYN1XyMORrvidt3ki
   w==;
X-CSE-ConnectionGUID: EzvVS84KTom08Jy/wYztbA==
X-CSE-MsgGUID: DAIVmmLCRE+wTh+CYRpjzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="58015049"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="58015049"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:53:19 -0700
X-CSE-ConnectionGUID: JAyZIHJ3S+mOf7AsfrbbeA==
X-CSE-MsgGUID: Ec2PNvlMTLuyksVjJV+FtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="135318283"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:53:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:53:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:53:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:53:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8Adf8BrzW1IiicdN7wrrA7+EncEhGlcqqmlPwuKKM1TtmEtaGSnNLuqquCDCy4iNgREtSd1o4HK+wEEUCK4tk0BHSLhT3b9ZqTSDnf0kL+N8m20d/UqBGmdUC95JgWhabmS95ccdmu2nV26aT2mjJ36a4N83F3VBdu3+UmDun2iIc+sgiVn+ALxZyrUOGgd1WRJtdlGiEfSvM8DBh1O9vmGNY5jdbDANOZ0ZWRS7Ct85Mf4C+3wx7KI7wpoe4AQOL5wX0OcGu16MYKHPxunvt99GTngYHjf9xasGrWGdH9+MOrFQPLElbgMx6TcSKVsneIKHP/nNuoul5H0xCogPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ToiWJjusP9vUT3Kwp6mDsq8wrI42opuDF+3TFzIBoCw=;
 b=wcpLaMIPNGbcJshNjvIb/GAQAB6PaCxzTaRdPF9JFQ0sqSKyCWYmZmaVm+oyKT4h7RAor69XwCdB7bcYLfIEDr8RHoyv0a5RgzpP9r4B2QWyPc4ip7i14w8HaO9UeZBg2N7hC7cAs8C943x+Bnd58oOppEUfFSVa21+pxrA8BlXQH4rFNE7wXvC8qZzFudXVSZWK1c0hRHIOgw2UM4aXM8W5n9gLaohLcpu702f24YaocHLKvmQBr8nVXcBOPwsM+DDefdRj9Fb0lEemJElm2VJ9t7NUlQbe1mWKjLMb04TOC5og4IEHh6Vxxmb15ZcKMXXSHG2OcPCJ1Uqfln1QiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6986.namprd11.prod.outlook.com (2603:10b6:930:56::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Fri, 18 Apr
 2025 21:53:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:53:13 +0000
Message-ID: <deaa0d30-2106-4a9a-8181-847d86a34b8d@intel.com>
Date: Fri, 18 Apr 2025 14:53:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/26] x86/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:303:85::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6986:EE_
X-MS-Office365-Filtering-Correlation-Id: 34ee8034-6dc6-4712-504a-08dd7ec36b13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHgxQ0FWSmhjN1BWMk52azJ3STd5WnZ4eXNRWUlpODdwbWZUSmJkYzhidnNV?=
 =?utf-8?B?RzNLT1ViRGRTbXVJOWpFdnA1aC9Yb1ZiZUJZSzJSRHQ3Zk55WVA1bXJNa1Fr?=
 =?utf-8?B?SGV2b1htTUM3Wk1iSUU3dHR1aTJrbDRhZThMTDNqQnJJa0VpbFlGQU1CS1BR?=
 =?utf-8?B?RWVzUDhBYnp4YllZZm1UTk5LRjJzMWpzbXh3aSttSjNyeEowY2thZ1pSVmJw?=
 =?utf-8?B?LzUvUXB0d3luOFk1bEtQWlRUb2xTU3NSTk1lVy9hOW9ORXN5VGcwSmxuclJH?=
 =?utf-8?B?dm1wRytlcnJoUld3MXI4Mk15WTF5RDB6dlRRT2FnaWYydWpZOS90YmxZZXEw?=
 =?utf-8?B?ZWx0UWtyREpUb3l2NzVYMEQ0TkxlZ2tZb1dQTHFUSEtMRTM3UCtxMk9zb0lx?=
 =?utf-8?B?NVFaMGdGTHR2bFlMNVFIb1pUOE5iYXlSY3JNQlpDdnhlMzZZY2FaNWtLOEIw?=
 =?utf-8?B?aEFiRlJpdU5UVTNYUGtoelpsOE5XMWpVVTN6M3NSVFdYL004bVVzaWlBK0V0?=
 =?utf-8?B?cFc2TmhLK29RZUxadDltMnNiSUZWaHVZQyt0b0MzM0hYTjExSGJmd29NY285?=
 =?utf-8?B?eFJkK0xoeWVSR1dWQ1BtVTBZczNBc3lJN3NiK1RNNHJGdlhlQjRVNi9DN21u?=
 =?utf-8?B?OFJucUV4TlhSbW5iNzd6UEdydnF3NzZuZ05QNlZqcmZVeTBxNExVYVVvbnU1?=
 =?utf-8?B?WTg1MVJJRVQ4UnhEWnFBOXd5aEhNclBkQmdTYk5Cc3BTa3d6TDFaUGJNM0dV?=
 =?utf-8?B?WFZiNU9HM01PcGk2SDRqMlduSWhZQTkyVEJEbWtjNVBNNmpMaVk0clZGQ25q?=
 =?utf-8?B?K1RNUmwwWjM4WkVXaUNxV0U2dElGQVpQTjVyRWNLVnpBVmdEVVBlL2tkRDFE?=
 =?utf-8?B?bXhXUVJLREJHVGh1R25KcTE5bWNyOUJ6UE9PcUlWOUtRNWpuTVJQQ2poYWhY?=
 =?utf-8?B?ZktJVXpTSVE4YnhPOVRUUXNYUHVpcm1uR0VBdVlWY09LZ0F3NWc1Q2RrUHIy?=
 =?utf-8?B?RFVnOE95cXdnRnFGd2g0dlhPSFRNQUpYQ1lpUW1BUmdJM096M3ZtQXhENXU3?=
 =?utf-8?B?VVpHZTRNM3ZpajArOHkzZGpISDh4V3Y5MktlcTl1L2g4aFpZQTZqOXJveHVl?=
 =?utf-8?B?QWRyWGRLZCtQVWxydmNjRE5iQzZ0OXZNSFFKMlB5M2VCUmtUNC80MHJiUzla?=
 =?utf-8?B?K3ZpNEdKSTlJL0cxNEJ6Skg2Vkx0ZGEvRXNFRnVtTGJyQWlIaE1abFEyaENm?=
 =?utf-8?B?elR0K1F2Vm5hTFRpNktDYkJ5SHhkYnpZYkNmdmF3VGdxRVUvY3I3TCtnTUd2?=
 =?utf-8?B?OHNPU1F5WXBycy95eWpaOTRmOVp5Kzc3TEpFZGJMUlBRUzNzeFdFMVFkbTYy?=
 =?utf-8?B?eitQRWM3MStFekJra09Pczd1a0xTSk1pblZsamVOZHRqRElnazhOa0xuMWtT?=
 =?utf-8?B?czJMNnBSdHZLemc2UmZ5SGZHVFdVVmtYT0NoQTk4NFFDSjNrU3BIdWRxak9h?=
 =?utf-8?B?cXhjRGZ6aTViNzhVaEZobnJDQ2xEbW83TTMrcTRxN3p1d0tKZm84K3NmZENl?=
 =?utf-8?B?d1JSUGFXR2pNSlc1VnU3TlUvUzVZbWNtcjhrT1psSzA1eDNpaHhOUDZqSlpW?=
 =?utf-8?B?eVl6czRiamJ2OHRwZ3lHd3c4RTNDajRHRmNZQTEzWExnc0t6NmlLNXF3Qnla?=
 =?utf-8?B?TWtwVWFBdVVvK3BCS05qRWxmZ0M5emhLZ0pVOVVwVmRDcTkrZjZiR2JBcXZk?=
 =?utf-8?B?dVA4ZWxjclNaand3WTBnV2MzWExoY2xHQkdoUG1nc1pTSElybEFUUXBhS2V6?=
 =?utf-8?B?czY0VWlINDFadHE2eDdRZXBBcExha0lzeU4xMktZQlBSWGQzZ3dPeDV6cHZG?=
 =?utf-8?B?WDJnM3dmcDdvTnlNU1dXUkRlWDAzc3J5c0src0F3U3V2Z2c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFI2WklBL3FTM0V3MVZEb2FXMXdwTnVWdFNMUnZMRHNMVUw5LzYwUjVQRnhP?=
 =?utf-8?B?VXpWUEkzeEdUMXdaaDV3UWIvRnA1TERuWkNxTWE2M3RJWCswc0FXUWJWVVkv?=
 =?utf-8?B?TkNiREhYYVFjbk9lMElIMm1ranFjaUtDcUJBVDJVYW5WTUJEYlVkbmdkMHFa?=
 =?utf-8?B?aWtWZlpSejN1NDV5czRXL0k1Q2xKUzdNYlZqVVJQMG5neHk0bi81N25iUE02?=
 =?utf-8?B?WTdNRzFidi9nS2hrbEJWZkp3QTlOY21GUE54OTFkQmMvU3RxakNBSHk0Um0v?=
 =?utf-8?B?enFkVmdHK3ZITEdmdHBYeU15aU5pNGZpTFdXUjVteDN0SHV0NlZDY25oT3o0?=
 =?utf-8?B?d0FzanI5RTJGSWZxMnQ5R1d2eHNWL3dhNm9RUGhFbGorSVlsM1RGbW1Ja3pa?=
 =?utf-8?B?ZE1tYTR1UzE4bjQ5VTBIM055YzUrNWJrc2E1cXlpNnFCT1RHTkc0eGVTK0Ju?=
 =?utf-8?B?K2ViOU1HOVJiOUFnWGt1V3hxRHVDNVhGYkxUOEZaNTBkWXMxTjlXR0xQbTc3?=
 =?utf-8?B?eXlEeERHSmNubm9ybUFYYkQ4UG9NK0JPczFaQnZCWjY2QTVNRUtNSXdtM1Ix?=
 =?utf-8?B?K1FhSUQ2L1NPeE02ams5NWJma3dPeTZwNmlMYTZNVFJDSnJjc3hwZUdZalNX?=
 =?utf-8?B?Q2UrclJwWGhhSHV2NnZOY044RlAyTkpZUHE0MEZneENkdG5JMmdrT2w1M2hk?=
 =?utf-8?B?a3JDN3FzM2ExTEIyL1F5VHN3M0tIbTVSU05rSXpXMXRIUU9XMGtNK1pNRzZr?=
 =?utf-8?B?dGJQVnpTVmhSOGpxQkhvUUFWbDBHbDFwT2lQTmNqY2NDT3dRSW9CdmVxWUNt?=
 =?utf-8?B?UkplQ1pjc3ZONnBNLy8zMmhScFV3eE44Qmowd0lZb1BIcUtzYXRuWnlZbURx?=
 =?utf-8?B?cVAxMmlzUmFpdDhlUlNiMXhsNmQ1dHJURW1WUlF3L0k1NjZOM2swVVJVYjlY?=
 =?utf-8?B?RHJSb2F6R0RralMwNHRIRlk5WmwzdWlQcWFUYWVPMFZHNGZRM1Z0UDcxckxT?=
 =?utf-8?B?WXc2UlFGWUt0bVdVU2NrdnFCSDR0bWI2NEQvREs2eXFWQWY2SUxCR2xUdzVB?=
 =?utf-8?B?OGg1elRSTW9jV3ovRmc4cWZ5UVpWYmpSVm9tSEcyL3Z2SExXZWVLZkswL2hQ?=
 =?utf-8?B?SWVVRXRCT0JNbjZkRk9wRE5wOWxYTnEvNVIyTW05QzQ2dzVqNG5VK2RDSWc4?=
 =?utf-8?B?THJidVo1OWxHRExOS1BHQkljVFptN1Y0VXFBZmswN2V6ZmZrQUlwTlc4aXhz?=
 =?utf-8?B?YWMxTzZaR2hOUEZKamJiR3Nnc0NrbGFoL1A2ZFBhdXJiMDhsMjNwdVVubUFK?=
 =?utf-8?B?cFZHYVJYVWlOS2ZmMFRLT3NXblFkQXYzakI1c1ZxUmlIcEZ1RXozUFh4b2FM?=
 =?utf-8?B?RFFVbUlqMHlLMzVRRmdLbzNnS016RzVsRTcvZ3QrRHdxUWdyRHJpYnhhdy83?=
 =?utf-8?B?NHYzdUZmc0V0OWNCTlRwS1ZqeS9wTFFrbzd1bHIzY2RFdU4zR2Z3NWNVaDM1?=
 =?utf-8?B?cWU0RGRoTEZhejMzK09PaTdIc3NLaVlFc29UdU9TM1QzandTSkMzVHgrTCtp?=
 =?utf-8?B?RlR6QVM2eTNhVXdkVVBzdktBQTBzU3hoem5GeU14ajhHWTl0Z0l1T2pYaXpw?=
 =?utf-8?B?SnpIeWFjVUp4T3QvREVLcWJaSG9ucXRKUGtIdlhCT2RYZHlGaGhZT3JKeG96?=
 =?utf-8?B?c256ZUMvR3IxK0E0Nzhhd1pWWGZDOEVOeW9IM0NRSEtsOWtldzhaNUFuUlc4?=
 =?utf-8?B?TkFTdzNRVjVKd1dTbkhiRTNzbUMvNE9PdTNkTkpDV2poQU41Z0pLMTVXSjN1?=
 =?utf-8?B?TzZTZzdvMTBsWmRXSXFpWmtXTDJscTBmK3JwdFVac05LRGdIVlkrejdNS2dl?=
 =?utf-8?B?VnlOQUNIL200aHBnZDFGbncxU1pMZCs4b3JPcTRtSUo3S2tyWkloMGt6OFJs?=
 =?utf-8?B?VXVyTFJXalM1MnZuZjJEYS9rWmphRytHLzE3dE9DUzJhMENMMlpEOTd2NzBj?=
 =?utf-8?B?MGE2TldxRkdPRkFva21DQTJIVE5JQk1YTWU0Ky8ycUdrSm40SUNjZ2xGaFkx?=
 =?utf-8?B?MkQ3eTZDNmNFQlV4OXVaMkxjUks2NmZzNWdzVGdSMVFoWlFoY0RiTGZOUk80?=
 =?utf-8?B?K2dYWVpKVFdGVjNCM2p3RUdjRmdGR0xYRnhBMGpvSVhFV2tZdlkzRnlVNEkx?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ee8034-6dc6-4712-504a-08dd7ec36b13
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:53:13.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTPjlWMIV2GAwwBi8uWHR5RxLuE1FoNVU7hs0CNY/ZJMmaqyJeUASoMhQGzitSvwuTEYQbSUb95fkPB02lhgO5vcBXPv5AkgSRR0xH0dxGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6986
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Different types of domains require different actions when the last

Please expand/explain what is meant with "different types of domains".

> CPU in the domain is removed.
> 
> Refactor to make it easy to add new actions for new types of domains.


> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
