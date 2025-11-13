Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C132D7D47
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074418; cv=fail; b=M0i3ii+ZTUQSMYvHLQAK7+yeSowOCuMcBA5uZIEvobnggcFj241sRbN/jWc3jesEpH33IsI4/d/zbGhH/K68kdZ17mjkc6U3JPAbMyMyHE1bo/UMMM+xfbvlAe3i4jdsW08tQCi6EgpZUZ402pNMbbWuHV8jyqFEqhId9TuafhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074418; c=relaxed/simple;
	bh=FcnPmoj6NKEdPsLHfg3gxBEQFAlJ2YKaeZbyT8ar/vU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EpAFhRpwLRuv4hVXGg8VCe+5FPFKvWXQcVh6nE8FbmBB50H/vi8x231URbX0KWFKJqW65suF1FD3kuHyKGCuP97OItzseKGmGjPq1t3NGMBpiGiBBgsiNU1WpmjSxJe/5BO+kInMS1kga3j0Wh15qcQY3bVumwv2b68R/ICEz7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=idVcjnXJ; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="idVcjnXJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074417; x=1794610417;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FcnPmoj6NKEdPsLHfg3gxBEQFAlJ2YKaeZbyT8ar/vU=;
  b=idVcjnXJ0Y6nozgbrhg36F+xtpGJQXN1huXT6dhrJkFt2MPSN3+qhtRO
   tacZ/fQuqGN27diHE5N5B9ePsCcaawn9oAOW/Era5uN93Eju14GrQtHVd
   +yMfKLN2lmIV9+KsWFi9kC8qUs+1vHBG31hO7AH2xLDC2CwJ1J/siFnOM
   FZUfGqN3de669zg2DA1hNmhaljsIQpY/B6Sg9E7KwqQdcNse7Jzm9mQMX
   6kYb9g/VoqM5BKkSfQzfffAYN4i61YBhuK/dBA0KurPJc471nmC8aNEby
   3XPXs2lZUHTxKfAOp5ryeRBuKR7q1iw9GbRVP+8wXiXl1X43/bPRim4Tc
   g==;
X-CSE-ConnectionGUID: GW1gWavmR0qZnW7YpR8E3A==
X-CSE-MsgGUID: jYnfKA37SYi+EziZZRYbyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65052632"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="65052632"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:53:36 -0800
X-CSE-ConnectionGUID: ZP3w7v+7TiSHXKi9/qXXzg==
X-CSE-MsgGUID: HgE5RDyaSu+6ZZVgrJEwJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="220468104"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:53:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:53:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:53:35 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.33) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:53:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RvB1NuzCxge19FqwxExgH1ClNxOlgRtLEy6PZyIwxXr+wKDbplh19zTCZBaw2u/cu1D7QOWqMMTDOisdIx3UmYra8l7G0FZD+eVykSvxt0uS8jE80D7MjSnWuwG5htvrKvELGSt7UeFRWz+AKU6D7AyVHUrTP9Kid5LdzdXOWPlGjdIdMUHph1+d7iVGTYqdTeyj5cV4OLUTQ/2PDQBJ6ZSgy/b0jra1Di5LRcDZ6//nOkOPNFJ4KuE7K6EYnC5ZrMqI5myCj/C6p987jgNjS+Ol6Z7s+7tDVR1tDXVgZSEt80U1UbBu71AVT4GbhmoVGBa4IBiCts3jTWC3iU1fbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJWT4veOO96tsidbuUHI5h3w9/Y0iH3kLDqt7K+AgG4=;
 b=d6Ko6cOk1czYqOH1y7G8rza4Vx1RQk1sz8PRtLF4QD0LDJ3jLmWmtLi8T9dhnGeFRPbFDrG3Rzj/jioisQ9FAsEiDt1nZgll5sTHSiZ0qTJDzJ1ozqJlSS8KZxgSk1VzZbF3VAhEUiMgv1xulzsT+hEN4vJwtKTfU3/QNTzSXfuZgdlcc+8J+1jha+GrsdJ/2TT7DBzvJheVo/366cx1VnBu6D6fIqPJ036b9WAKTjVLRIhXdL0WtzdOo/TXaSB2dqBbWgYFbU+usVZVtF/y8qaJDCwftCvc4rCi5i+KztJyFoiF3CuIFZSGFEzvFnhKtJ9uEVS00bBS2TD/CDIohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:53:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:53:28 +0000
Message-ID: <30e73735-a1ee-4dcc-83d1-2217c3f0d472@intel.com>
Date: Thu, 13 Nov 2025 14:53:26 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 31/32] x86/resctrl: Add debugfs files to show
 telemetry aggregator status
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-32-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251029162118.40604-32-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0047.namprd03.prod.outlook.com
 (2603:10b6:303:8e::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a90ce1d-5cbe-4265-b6de-08de23077619
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aGVqbWhMN2lxMHRyT2ZVNWo1R0hqanFPMUtJSCtWQkJVRnZBZElXU0VmQXdm?=
 =?utf-8?B?MURnY25VZXBlYXlZZjRDMkRnR2FvSnlPMFM0N0t0TVE5WEREcjIrWWd5N0gz?=
 =?utf-8?B?dE1YMThZUDlmTGRIQjJ4c2oybStXbWpVTnd3RjkrWmQ2SmNPd1JVUEJwMENl?=
 =?utf-8?B?cFdMMTJTTlZrYXRGazVHUEtVWkF5cCtJcXFaeDYybklwRDZVekdiVytSazcv?=
 =?utf-8?B?NlQyUk5NOG1GdzlqYzNGdmNZLzBQbllMR3RPMXlmMDdHdE9GMm4wbHVuWlJh?=
 =?utf-8?B?MHJHNUVpSWV2VmlGUWlGV1I3SDcyR1hWeXY3eElkaHE3YjE0dWMrK1ZEcERF?=
 =?utf-8?B?MlJSTmo1T040RllZMWIzSmp4ajgxNE9LMk1GaHk5dTJKWno1L0VaNENhOTIv?=
 =?utf-8?B?UVRHNnp4VWF0YmMrdWRyOEovUnNnRmExVWxhMmJwT2dicmQ5aytpT2NGczlY?=
 =?utf-8?B?RmcwYkVPdHNkaGRVZlNVT1c0Y0g5UzIwMmZwOXlGQVFSZmFSS3lNU28zU09D?=
 =?utf-8?B?dnlWaWJ5b1h2UzF6aUJzSUtRQVZSc1VYTjNCZFo3MjVCcWw1TlppbGFFNVd4?=
 =?utf-8?B?d3crcVZUVDdZWm9CcDA0T1RGOS80clZUNWt3TnBMRjBaT0Y1SzhvWlpaMkpo?=
 =?utf-8?B?TE1zU3A4Vzk0aCtDS2trZVVkRjJzU29lTXRCdEFwRk81cVYyTFRsaXZtbGVU?=
 =?utf-8?B?clUxM2d0WXdDREJJNVBoNjVmMkwvY293dkQ0dVRrV2FXM2ZNaHU3Z203RDhs?=
 =?utf-8?B?M1ZFWDNxa2NyWkdUSHc1RFRaT3JPWU4zaFBkclN1SVBtSlFBaWZpbk9YWEtY?=
 =?utf-8?B?UUpDRW5pYjM3SEJvRE16cC93NHAxcjVwOWdqcndiV1h3V1NxWnNRQWYyRzZK?=
 =?utf-8?B?MTVaUHR5cW9zTGQ5NkVMdURCZDlHS3V6QUk4YWM0NUJXZ0NPS2ZGWWJ0T1la?=
 =?utf-8?B?WENFZTBlWFJjb241ZS9SYit0Q2FicEhwaHRnRkEyS1JZUitBTG93YU96aGhJ?=
 =?utf-8?B?UUtUS25iY25PTDIvVnBWMXRYdEZSbENhRU9PQ1M0RUxDRjZZSGM5NjFma0NM?=
 =?utf-8?B?RU9ETGJaLzBlV2F1c1BLTDhKYmxkNS8rZWdSdHE2R2dHR2VzbzlWSS9Mdk5v?=
 =?utf-8?B?cUpCVlY4NVFudEdYVXkvejFGeVVlRnRUSm96cmxzRXJjZTBJbCs0dEVxOWxy?=
 =?utf-8?B?VUxIbFNmQVg0VWNQK0N2RjdmNHFIQUoza0xSdHU0Zlp1QUY1QUlxYThNQlAv?=
 =?utf-8?B?MWVuajdIRGk5T244Wi9VRll4UVJJaGFBMUVwOTZqWDh0TUppbHVKRDYyTkZS?=
 =?utf-8?B?eWRMT21DeVBoWk5aNUNMNU1HaDEvcHZXNHFLMGZONlRhOVJuNG40TTY1andQ?=
 =?utf-8?B?cXdUVjQ5MktQVE9HbEdzY2d6dTFSK3dBbURjOWYzTktaZFlkdHRVcUJka1dY?=
 =?utf-8?B?UlZhbVZkbSt2czZITmVOZzBSU2YwV1M3ZFIvU0FqL2dRM1pENkJ5TVZ6RFNx?=
 =?utf-8?B?aHEweWNpMFc4aHA0Y3dFWGFvSm1jZCtCalZ6NnNzTzB4bWR5WlBEdU5aUVNz?=
 =?utf-8?B?c1VXdWhqMkpHVXJlK2pCMXNiTWxSTzlpZlVGekJ4NmdTVVNXUHc1bDU1Um9s?=
 =?utf-8?B?Qnl0QkpYK3ZaNXBVNC9wQlpWSDYzK1pNVmkwblo1UHA4Q3Z6blliMnRDTkxD?=
 =?utf-8?B?S2lFdVJGSEcxZlY0ZXd0ZGdyRVlTYTVBaGk3dEtmSk41eW43WmYwZ2Ywcm8v?=
 =?utf-8?B?NElpTHdhb1NWWjBGdys1dkk4Z1FjeExQZzJOOWRDUEFucm84RUh0aTVxMytQ?=
 =?utf-8?B?WmhOd0QxUjJXSmhpNTAzdUN1OHJZL2RNUGNiVmN6enp4M0tQc3pieFlndGNN?=
 =?utf-8?B?L1hZUW9hOFJIdFVQanpTaDIwd2N3QVQzWGM2V1FWZkxhTmVyamMvdEhwMjFh?=
 =?utf-8?Q?h9fIQzlsTc4ms/DMn7O2lgFzySOJ6O0C?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3hlSi9LUFViT2xKRmFYWm16enQxR0JHam1SRnlqb1dGQWxxNmhXeXlVYUky?=
 =?utf-8?B?KzVjUjJzYVlhdnZyVHI3ZTFWeExwN2lWckZDMHUxV0tvS1NOZjJXRzQzdHhr?=
 =?utf-8?B?eE14bjd6cmZ1cERhSHJJZHhpa1FjUEtwTlJSYjNEeElkSkpKM2lUSWxNY01C?=
 =?utf-8?B?eWdsZ0QvaXRZVUIwQ1RlUldqNGtvK1hQZFdOa05iSE1GUEJ6NnFpcTNhWFV1?=
 =?utf-8?B?Y2syZnJ1RTFjSEI4Z3pBMkVPVFBMR2p5NFcyMEtabEFPWUJFL2VNdmZYTnl2?=
 =?utf-8?B?VzVyeVZTdkI1aWk2cUV2bnBaS1RGQmNURjJpZ3BlV3B4QUNuZGNsbXZvVEEy?=
 =?utf-8?B?L3luMTQrWEMvWWNhU2pwRWhLTW1NOUZONXNYUGZ4d3VPaGd0R2k0aWJrb3Fk?=
 =?utf-8?B?Y1NWNFFrREhKRUNWQjVvdVd5dnZGc0M5aUJtd3ZQMjFXVnJJTXVPNTNScWRR?=
 =?utf-8?B?c0VDNTF1T0taR1lFbkpqSWUyaDlhd1FSZ0VTM2U1WEsxYXpIWlE3bVdMVEpx?=
 =?utf-8?B?eWROZXRJOEVwS0NvNTJZUjNmZHN0Z0hoTkYxZlFKZWhNSXJzbkhmWEtraktM?=
 =?utf-8?B?SW5jNnd6dXZNR01HdE5jOG43aUdzOHZGQWM5UTdsTmxFNkJiUmpsOElDUHpx?=
 =?utf-8?B?cGUwdTBrVm5Ed1V4U2lDWURsMGtDTXFNSXM5cmZsTEVvS2x1ait5bDVsa1Jv?=
 =?utf-8?B?eVNYekNyVUdZUU9YQ2Z2VkNXeWtiRmhjdDFvNmQ3cjNHRWt5Umg0ZWg5MGw1?=
 =?utf-8?B?VjV4dHZUL2gyNm96aVZvM0J1T21wODJKT3dWNGlpdngrcHdMVk9UbnlkS2Zl?=
 =?utf-8?B?dVFMUklncUlENTJ0MVc3aGhVaVVWaEZGRWhaRFkxNUhaRWo2WWNQMEdnSXZs?=
 =?utf-8?B?L2xZOUR5R0NqNVdvQVR2RFA0dHVQZEF1eTVTOFlZOTFONEVEVStwSE9OL2Ru?=
 =?utf-8?B?eVhsN25saTRwam9Ucm05dHphQ0JDNHNoK0t4eFhMeW4zeEo0NXRCcEVkbkMw?=
 =?utf-8?B?bk82enZtSVhZMXEyVXp2R1lORm5aK1BYc0VOVU8rdGcwc2c4S1ZWZEU3dFNw?=
 =?utf-8?B?YStIL1JRWmZSUm1ibk40a1hac2dZMS9iNmpxc3hQK3huL1BnUHdRb1hMWW11?=
 =?utf-8?B?VVBFUnRTcjBlbVVJdkNHa2FObjFXaU9vTWFpdmF2ZE5NSko2SDRtT2NrdTVi?=
 =?utf-8?B?QXVUVi9pTWlCTWVZL21uTHFBaENyTXY3ZURFZ1dzWDFwdlhtUW9oU0E5b2Q4?=
 =?utf-8?B?R0cxcW1uSzVwaCtIc1k2bHF2WnRkNDNoZGRGWDMxOStlbFJCQXBhVHdzMHRq?=
 =?utf-8?B?RmdITDZNQkZ3WUtTZ1pKV1Y0YWd0R0Jkam04UGxBYzZqSHpTN0RsMWx0UW9K?=
 =?utf-8?B?WmJLR2s5cm02U2FuMWw3MHlXdys0UjZsYXpUT0JzRXFCeHhoK0k5aS9DOFg2?=
 =?utf-8?B?WWUzNVk3eVZHQ09ONDBKaWJ6MWdJenpkVFJhWUkvRlBSYmt0cU1RYTE1YmVt?=
 =?utf-8?B?WjI2blNjSGdndVZhbTZLcS8zV2p6S3ZCQ0lyWUE5ZFF2aFpoOGhmZGtpMWFF?=
 =?utf-8?B?ZWZEdXh4ZFNSOEx6V2lGekJ4OVFhR1pSbVZGdWZKM3UzOWl0VGFvTUQ5MVhu?=
 =?utf-8?B?a2NHTEZxNWw3YTB6eEFaZzloTTJIZ1J1UmM1Y2RNd2g1VWJHOEIyNzRPazNh?=
 =?utf-8?B?Rml3d2dYYmVETkRpZndGekFXVVMrVytKWVVDLzhaL3ovZW5FeVBEeC9oRHRw?=
 =?utf-8?B?bWNqcEoxbU9pZjdseDQwYWROYXlyNTlRVmJxSXRuaHVoYXpxVzBsUkFYZVNh?=
 =?utf-8?B?aXBKVDhBRXAxUXRBV2FqeUw1cXNTYTkvWGZvWXFwQ3pGdXNRenQ4MEtoL0FN?=
 =?utf-8?B?NURLWE5VWDJqYkhLZEl3TmdKeUFhQXV3ci9Cb1MvS0NHL052OFpBaW1kR1VI?=
 =?utf-8?B?b2xwZW96L25yZlFuMllsUzV2SzVCcjZwbzQwdXA3UnArc2F0MFFJcUZhT0FY?=
 =?utf-8?B?bWdWd3BrUFhrRzVBc1loREVHbnZIN1orUFA0OEJ4ZXNDL2ppN3VQeXMzWjlU?=
 =?utf-8?B?YmtwVzNKNkRMSFVSZ2dYNEdjTFRUOGtCVEhCQmxHMnJGa1Zhak0rTGZocmh0?=
 =?utf-8?B?bk8rYjFlZEFXSnFvUUNYRGl1Yk11TG1xOHpNb1Q2NTUyOWt5Und2cjVFTHJW?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a90ce1d-5cbe-4265-b6de-08de23077619
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:53:28.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKa/pwUwGnj8A5pz/OUo/0nmmPG3xDGt0/kZ7LALx/IML/lZ2A82X16FICDnpz/a7zoujY74VkfcLQmUwFQP9Jr7i3gjLOsnG3JfTaf0OZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> Each telemetry aggregator provides three status registers at the top
> end of MMIO space after all the per-RMID per-event counters:
> 
>   data_loss_count: This counts the number of times that this aggregator
>   failed to accumulate a counter value supplied by a CPU core.
> 
>   data_loss_timestamp: This is a "timestamp" from a free running
>   25MHz uncore timer indicating when the most recent data loss occurred.
> 
>   last_update_timestamp: Another 25MHz timestamp indicating when the
>   most recent counter update was successfully applied.
> 
> Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/
> to display the value of each of these status registers for each aggregator
> in each enabled event group. The prefix for each file name describes
> the type of aggregator, which package it is located on, and an opaque
> instance number to provide a unique file name when there are multiple
> aggregators on a package.
> 
> The suffix is one of the three strings listed above. An example name is:
> 
> 	energy_pkg0_agg2_data_loss_count

Would files named like above have enough information when considering the
theoretical struct pmt_feature_group from patch #16? In that example there
are perf aggregators with two guids. As mentioned above the aggregator
instance is opaque so a user may not know which guid a file like above may
refer to.

Reinette
