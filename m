Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9853A8CB
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358110; cv=fail; b=toVH112myAPSLe0mG1k3KYteLoyyHDkg+MhMrFUZO/s1y39XGErvUF3V37ox+1PanutfqwZIuQ+VMw0otcWXFgWM6n/i+JRziPCP9U2uARahoXLZ+DrDvjG47SLHXV8xoqWwsTvatXfVtz3+r0OKPXrA4svdWFtUXRte/UKbVX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358110; c=relaxed/simple;
	bh=nl/CYrN5/16Gat9in3Wzey7CG24L7cT93aukldswZ7k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Cs4O/4ZAIXASIPB9q8rIvO+Zbs6ywl/wur4btamc35uBZ1MdimvoRANBO5s7jtCfWTXgHLgcy/YnO6aesuyAYg6ZyU5p8slYqHoBR5PnwtFoo98yne/+JNjqdGvtfg4fv+qb/St/oEICDK4naeFbXF1yKUgiSUXu8IZWqh3TghI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BCH+//SY; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BCH+//SY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358109; x=1750894109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nl/CYrN5/16Gat9in3Wzey7CG24L7cT93aukldswZ7k=;
  b=BCH+//SYJBZXc5YHsMje1BoXQYAxGVkKAtzf0YSglOlPz5nzR3JUymxN
   KREkQDTLpxXBvde8JjSycsoEOQ91Olq94s7CKH/NQVhTmqB+jdtpqtr43
   QZS4dBLHqRlH9A0hqgpLkqAwvchAXhvB2zWdy8r2Hc0/jDiI8OOLgoE2s
   StnnsNAHse3j1wl0cPNtkuSq/zPzIUhTqXHIdfqlKlRjx9ynhZzv9FmQw
   j9OtuRQ9zSqgt4dFUul3aJje3NEjfUaL4vAvhSMXY7AFTXG+YNY/3KqLp
   WZzr+05sguN/Oe69EIPeETt/RU/rofqXLaUNzrIOFSuiluCSy2mGEsAbc
   Q==;
X-CSE-ConnectionGUID: tqUl//QxRlOayXnAn4Afsg==
X-CSE-MsgGUID: 3vSVaquwTF+275c0ffTJ2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16087305"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16087305"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:28:28 -0700
X-CSE-ConnectionGUID: uqUBQS/WSfSOyWrYM8qQ3A==
X-CSE-MsgGUID: 2BfUTjVqTPyi7LqZRgziFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="44460380"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:28:28 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:28:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:28:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:28:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCnHF69QEiB/U63DTe6VHOQq+FT+iOqko4avXlXc53aCSG27wZ3vVwLlNPixGr7fYTXjZsCyYlAasafutEECJ8P/Z47lzHJiK2JicB5ipymzKgK37QLYw98AuImoWwqbbUurKGeJUhLpE8hnT979fJE2BOwHH5dP8QaeI96U8dUL/MGt89dasnCGf3DTKQab3l0BWFb7dPHptcvIMvKzr1gNShYJONdwS/WJJOSzbjqQOB58DfvxkZL8NNP9Cj2iIQNbk95KKqotNOdoE6L1XENJFjATXPSP3OnDhO36qRaSxt1sWIzRC1+FBlRSv6mLvwFc7SbWHyQwMIVqcRW4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwufgX5lm+CO0x5YNEVg/OT49CiYCxD2MrH3m+SG+W4=;
 b=IejYRYTnxCRhbU/1+Kv9J0f4bzloXmQ+I+8r+eZ3UD9naXLmez832wmphD/24b1t4b/xKs50tI8EfLL1Ze+rYzECK8bP/YqE22aym1br+qObi+1oxqJ9yTFOk570cFT+AvoxpJoZZ1N0bh1Pbofde8he3G25DmNRxm1IqGD5ECWtazwPyqzsKQXeG25tW1z3KPWnMP0RbrwdVXoIjV5wNmFLU7GKSzyl94DF9SrJkIt1vsi3Pmmi9vK1Kj3qTcs+pzPxehv6tXoQaPTkC7F+ONzf/+bfLoHzUlAjZzHXWMDECfcKIyhmHG9xXYRV0/8z1PAMk0qDlIByKtnxhBe6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:28:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:28:25 +0000
Message-ID: <ce838686-8309-4301-a05b-28f72357495f@intel.com>
Date: Tue, 25 Jun 2024 16:28:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 08/18] x86/resctrl: Prepare for new Sub-NUMA Cluster
 (SNC) monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240621223859.43471-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:303:8e::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 978034ed-49e8-4861-d520-08dc956e82f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZElFRHJWREgwYnV1OGFqYklEVkk0bkN2cll4MXFnN1BQQ2wrYm5yU1ZnV0x6?=
 =?utf-8?B?UkNGTG12NXB4VkErbDVQQkk0TmhkMXhlMVpPaHJSR3AvSFRzUjZjSmVVMEwr?=
 =?utf-8?B?U0tjcUdxOW5Ba3lqMlNSa3h2VVJOWUtHeXp1Y1lLbzJrT2lmNzhJZU0xS0tW?=
 =?utf-8?B?cEs3SEJkWnhKcFU5TkV4TzBHZnBNOG1mS2FjeWd5YWx5dEM5MkxrbVpJRGJk?=
 =?utf-8?B?a2pLQ1VBSzdOdEYyTkR3dXNmWjRjalhjUEJBZ0lJWjNtUnQrQTlTd1JkODFx?=
 =?utf-8?B?STRVWVA3WXdNbFNnVHM3c0t1R085QXl5VjVzbHdydG1YQW5oZ01vOXVBbElY?=
 =?utf-8?B?cm41NmM1bmE5QWgwSTJXM1g4Zm1DalRmcEpOWTQyL0VReHdUaFpza01iY0NF?=
 =?utf-8?B?ajlBMDdGcXpZdE1iKzhISFp6UTlqZmhTaTE0dG52OExpeEhKck5ac1hIaEZk?=
 =?utf-8?B?bTRsVDdoR0Rob1MwYWxBR3dZR3UyZ1IwREtUbk9NNnBTSHBWbldiNVFGcWN2?=
 =?utf-8?B?YnlMRVFuRzFTZzlUUVRlTWNQWmhhczFTQ1FYNEI5emFVWEN3c3EySEJ6SnN4?=
 =?utf-8?B?SFQvTGRYYitOVUFaa29XaXZHOW1Jb08vVzNuempYYnZyRERQT2NPVFZ1ZWY5?=
 =?utf-8?B?RHdPWTAwSmFiZUt4MUNJeFU3YklNQnFSRUtPbThFajVPQWVKeTJIcEdaN3pX?=
 =?utf-8?B?ZUYvZnorVXVlbzJpcDl6UDRWYndxSkhlSmNkN3NDWVk2RXErOFdoeVJSbkM3?=
 =?utf-8?B?enpGdVc5QVlDQU5sUW5iamg5VnRpYUp6VllZK3V1NkhPTmxUTzNCcnk0Zzg5?=
 =?utf-8?B?YXE1NGdEN0lBeXpoSTJOSC9Zb1dTY1RkNEN3VzIxc2VGUXEzRU9zL2R5MGdi?=
 =?utf-8?B?U2pkbC9IRkRwT3RyVmREY2ptbitLbDAweFlLUVcyRFFiWk5iSCtiZjJCajhv?=
 =?utf-8?B?Um5ZalNmdHV1VlgrQmtqU25hL3ZXVkxic2tSQWZaMys4SUhxVWNMbFd2emtQ?=
 =?utf-8?B?NmRLVjdMR3lTby93cFV6YS9LQWlYWHkrWkdWYWNnMzJQNjlJOTcraEpYTGQz?=
 =?utf-8?B?MWQ5ZWR6MmhFQnJ1akYrZUpmTHcxUnFUY0RpTitORmtVa0ZTYWU2MEFFOUJm?=
 =?utf-8?B?dzFCRWh5TXhhT01SYTNleDZRU3dqR0NVcjVPeDhTTHhBUk1mMzdaM2ZlT2p4?=
 =?utf-8?B?QWptVVR0WUFZMGM3UjdISXN6Mm5QOW1ZMFlGSlo3ekcwNXRrakphN3YrMjRC?=
 =?utf-8?B?YThacm1CQkZEK2FzLzZFdS9HWEJ2UXpLait0WVF0N01RTnZmNzBVOHlZcFkv?=
 =?utf-8?B?SVRvWURneEoxZVFRVTRPNnhGcGord1h1UTZuTTZQYXB1bGYzVkdUN1hCd2RM?=
 =?utf-8?B?TzJOM1NZT1pMMGc1dEplcmJuM1pUZ1hxbDZQdStNdm5ydTZHNHVxVXF4aGpB?=
 =?utf-8?B?alFtVjBSK2xMVDJ2OUt4RG9NZ0NZa3Jka25FelZFeHRhVkgxVzdzbTdHdTRH?=
 =?utf-8?B?V240TzM1MDRrczVmSFNFREJISlFJdmpqbWVXM09Gb1U3Zmd4N3NxRUhvRzMx?=
 =?utf-8?B?bnpIbVEyOWVoZFN4T21BQlppS3VDTGNzdWRBY0FwRzRIc2FITnRlTy9KRisx?=
 =?utf-8?B?Ykwrc1NoTUVrWHlXZWJCMDhwR0djeStaQkhUZSs3WWJ2ZWw1QWVTUHdLNWN0?=
 =?utf-8?B?WVQzeDdkLy80R3dxeFlYQ3lSVTdaZHovZnFWeTRmaUNDNjFOVHNxd1FUV1NN?=
 =?utf-8?B?c3NFMmJ4ZFk2WkZzOXBvalhPcXhwanZSU0hJL2hTV3V2eCtrY3Jrc1U2MGN6?=
 =?utf-8?B?NWhpRFdLMEhVeDQ2cHpWdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHJleDMzaHNGZDVXeWloR1gvOS9aWW1LbnBWRkpsOEhReWR0emxER011dWVP?=
 =?utf-8?B?TEkwMndnV3M3NW9hbWovTTIvZVUxTkN4RWpudG5lVXdkbTVsUmx4M3JvY29H?=
 =?utf-8?B?VEMrRlc3NUFNOWNqS0lJQnIwOG1SL1pZSlBXUUpnT2NWeVQwR1hRZjFBTUtG?=
 =?utf-8?B?eldnS1JDenlxVmVrNmx5UFlBNkRzU0NxdWl2b3NXYjJqY3NlZFlkN2Z2N291?=
 =?utf-8?B?ZFVQVXd1eUJrRDhlUCtYajkxVkt4T0UzWkN6ZzNvQllDSGpmNVJXeC93M2Fs?=
 =?utf-8?B?djRJQjFBanZRN3pITUd0NUZ5d2FubTR0OGlRZnpzYnE2QVNYZEhRVmF1cmYy?=
 =?utf-8?B?S1ZUMDVOZHJuU2FWcG9QQXVEZ2hSbDlJT0ZCVFgweE16akhyMGVsQS9ueVZr?=
 =?utf-8?B?MUV6YTVpc0h4VCtxWGxrYWRUUWdXTTNYT2tLN0drRlJZNW13ZUYrQTZpaVRE?=
 =?utf-8?B?emxKVGpyUUVISjUvdXhHTFFXK3J2Qzk1dm15ZlVWQUNyc2JLWlVQVVBhc015?=
 =?utf-8?B?MzFKbnhqdGZWa3N0d1ZZSEhseGtxS3FoQ2QrTHZGVFhTbDJFd2YwbmcvSGJy?=
 =?utf-8?B?RCsrbngwNmp2TjJZcTdjZVRXcWFvcWxrMjRxMEI5WnNKUDE5aDdZREM5SkFD?=
 =?utf-8?B?UUdTaUNKc09rRzNjZEFKUzljdzRJaFR4bE9lcTczODlvSkh2Z29BYWx1VmxP?=
 =?utf-8?B?cExGMURlcjB0UmNmZFd5UDRmajUrWkFiNStrVmJ1TGdQZWhjR0N4Y2JWYW5a?=
 =?utf-8?B?WFRvSzZNNTFjbHRwcm8rVklyY3ZtRXpHRlFpeUNvcGFtNkh5enBVY2xjaWJw?=
 =?utf-8?B?cmJzMDJhamJXaTk3dTgvRmZFVnEybUd5aE80ZGNWSkJ3QTFkQVlLUGhVczRO?=
 =?utf-8?B?ZDJYUTdSdDFacUVMRmtoUDRkTEE4b0NZVzhDWWRZclJJTWdkTmVxV0tIbXFj?=
 =?utf-8?B?OVlUY0lqcW5oSHZJbWtnVE5adDlieDEwbGViU1gxcGdncENDQXozVjQxMjhN?=
 =?utf-8?B?MGtMeW1WcUEwakorbTFNZGx1N2dqUkNnMng4NG9HTXRWU2RMQXNGcFlYb3ZN?=
 =?utf-8?B?MW1QTzFzWkEwaXZGbGhhMmt6YlA0aTY4Uzd3eE9pNk56b3dFTmtoT0NuT1dK?=
 =?utf-8?B?SXZRdC9TMXRqQkxGNkNMa0wxWngrQ1lVRnNnZ1N1NmFLTmdSMzdQTUoyUURP?=
 =?utf-8?B?YW5pR2NOUmUvUmxkSlVlVUxiRTZyWUNQMnJ1SGdmMGRFbWxJd1ExTnpUTXYw?=
 =?utf-8?B?b05GdSszeCs0b3Z4ZmgyazJSZVQ2TkpKNkhQVUlRalVaV0lsL1dtd0UwWXNU?=
 =?utf-8?B?WXQxTExSNWF4YTRUeTAyYWFnUkN6Ly9WTlRSZExNYnFmVkpvSVVXYnBrMzRI?=
 =?utf-8?B?bnpMZkVqMnFyU0h5Y3VpeW9uZmQxQ1J5NmVLdDQyc2czY0p0dWNvWlJOdGV2?=
 =?utf-8?B?c0p4YmRuSjBsZmJaNUJjNlJRQStiWFROS0hOcGQyVUhRNWJoL2hRVDYxdXM0?=
 =?utf-8?B?eFRMbTBIalVQSFZtUjBwRjQ2SzdZb2tSdGM1WUNlVVVnK05pYjRoUnZSTEJZ?=
 =?utf-8?B?UFRNdm5maER4V2M5Zmk4U2dIcU1iRURlSHIwRXNnbHBtS01DR2UrdzZieGN0?=
 =?utf-8?B?ZkpDNGlsMktQZTZxNEdmL2l4WWJySndNODhFNTFjWWt5NnNkeTV1bjFGa0FI?=
 =?utf-8?B?RkNCUGRLZ2VPcEJEY052T0tZZ0s3NlBuVGFFVWcyRXg4UGhtZE8zMndnb0Rh?=
 =?utf-8?B?OEdFTjRjNzZ6dk9NMm9nZnk4Nm5HZmRrQTY3YTYyaXZKOEkyayt0aEF4UzVG?=
 =?utf-8?B?WlZwOFdiemVWcmhRSjlidnFySHZhVVdEa1lZZkh2dUJuUGwyY0FvaHlIcDN4?=
 =?utf-8?B?NGtpUEtsUjg4SGFaNFZSRmtyV3hzbkRocXJJY1ZxNW9STFdzbFU3UHN5ZkFn?=
 =?utf-8?B?WTRFM1JEdm04ODVYSGNCZGRQdnc3TXNvM2hRV3ZYUWtQYnBDNWZCWjJiZkRU?=
 =?utf-8?B?NWwyYkRHclZmVCt3T0U3WDFkWExYRW56aE9VU1Y2UnFpZGx4Tk5oWGlwVGdU?=
 =?utf-8?B?UUVsMmQraDFHdjQyUjY5VGI2NER2Y3hmTmtsTEpoanRyM2FRaVlkL1dZQjRh?=
 =?utf-8?B?N1ZrVG5ybmREWEIwUW5CRVF3bUVOZi9XV2l0MEhMWVZJMXpFZyt3Q0w5ZTU2?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 978034ed-49e8-4861-d520-08dc956e82f1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:28:25.6964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfQgLXXm9vE0/jtSXtAPjkNQ0TEaOCI2YxotbYG37WaRpd/1+ORPl4Q8hoxeksZLSFQ1t9EysGsLCMmODiYb2WbpD+x27hgoe+YC2WQiIEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> When SNC is enabled monitoring data is collected at the SNC node
> granularity, but must be reported at L3-cache granularity for
> backwards compatibility in addition to reporting at the node
> level.
> 
> Add a "ci" field to the rdt_mon_domain structure to save the
> cache information about the enclosing L3 cache for the domain.
> This provides:
> 
> 1) The cache id which is needed to compose the name of the legacy
> monitoring directory, and to determine which domains should be
> summed to provide L3-scoped data.
> 
> 2) The shared_cpu_map which is needed to determine which CPUs can
> be used to read the RMID counters with the MSR interface.
> 
> This is the first step to an eventual goal of monitor reporting files
> like this (for a system with two SNC nodes per L3):
> 
> $ cd /sys/fs/resctrl/mon_data
> $ tree mon_L3_00
> mon_L3_00			<- 00 here is L3 cache id
> ├── llc_occupancy		\  These files provide legacy support
> ├── mbm_local_bytes		 > for non-SNC aware monitor apps
> ├── mbm_total_bytes		/  that expect data at L3 cache level
> ├── mon_sub_L3_00		<- 00 here is SNC node id
> │   ├── llc_occupancy		\  These files are finer grained
> │   ├── mbm_local_bytes		 > data from each SNC node
> │   └── mbm_total_bytes		/
> └── mon_sub_L3_01
>      ├── llc_occupancy		\
>      ├── mbm_local_bytes		 > As above, but for node 1.
>      └── mbm_total_bytes		/
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
