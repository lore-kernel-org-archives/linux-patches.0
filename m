Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E57202990
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207573; cv=fail; b=u3HgEXZFJ4yZ4dxVKZYWyjiVvlniJg1B7TDbhnd5OwGtKK+RaYwyiJZKUDuSTWldLAZ1L5NplDSDklvYDw92frqosUI/XFcYyitqQXCJcScsPEDgCkKI34xd4Lj12uAJfj3UVr2Ef84wwxAgrkckYjc+1DhBqefMgOHUqjHuKoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207573; c=relaxed/simple;
	bh=Pe4PCixjvjx4f82r6d6g+H61ajp8taHdJn1862Tbr2A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M4zYM6D4zXv5smcqRNVuLC0AuZPhgU2T3H8k3EJTb3pun+n2XgnXovLAQtwaP2YzaEuYj1gnHcYGaIjyIBLGevrdl21WOVkU9KqVcKLUUKx7iHnlTAqDlqcSPv4bQuJ7KuVcmd5Qlvcttrt0wTunVGiNJHg0NxaMH5U+COHVuDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OrdhmcCo; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OrdhmcCo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207572; x=1786743572;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pe4PCixjvjx4f82r6d6g+H61ajp8taHdJn1862Tbr2A=;
  b=OrdhmcCocn72SCUQTqE0LnvdHBmj4wFVZsj368UyE/IcXsUX7Coqukq9
   6WZTY+iTfA3ZRhzez5EctSzM1wvK88gXE1/730oxP5WYe9a19i9f66iLV
   FcktlOn9BgNtV580pEUTxjBZlA3A8Ah0rBOnTXW+a0X/o/AF02skeb9vp
   uky5G1DWF7UZfF5euYb1I4F7OXsKfYNPW3UmhI/3TidwzKW06B2OFYry1
   XKJJnOA45EcY56WgFYAJ4rTp6NvZsB8HZrCzyZS1itl01Vs2URa988Zdh
   ruIqICvzxCuYPdJ0VYYQ1aw0ILHc/3ISbsD25PPwxA+Y7nscp7ArffYVu
   g==;
X-CSE-ConnectionGUID: YRUhqlCHQiaFrxLoyrBZ0Q==
X-CSE-MsgGUID: mOuQQ2QETwW1LK0nw3webw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="67806271"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="67806271"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:39:31 -0700
X-CSE-ConnectionGUID: KRZc9hSQR5y0U8E3fBDSMQ==
X-CSE-MsgGUID: Q4diB+pPS7qGHpg5tnb+7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167670584"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:39:31 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:39:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:39:30 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:39:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ug7fmBn3gRcv5yeuP97V5Ma8LE/4fhDW7AiuYWu60EsTl+NOkxQJkYZTNyE2lt6HRfRjYX5huaXx3SMTessmYRcRNIvI4Xolix9tovQhFnSLE/rFSVXew6kj2C/5vaJffxzPF/ot8X1sWSzIDLiPxxUd5artHAgxOPNPvysLEU2uRXO4qNL3Nzl+fNI3d8KpajalZGdMlUcjiMcI/kIIzU7ov8hVjov1yF6CtHNZVhjsMyzaj+4FTp3Qt9KTP/43wqnX9hA8Wa2Fg0FVTF9joG3n5Q0fu040Qe2hgq5zoZwVwkH6a8m/JDNStlbiw5YsUp1hMxy3GsucG/8CVViNzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IL9YF0Z284MKVpDykpLAa6o0z0GrEaHNjaveTsiz4RM=;
 b=k/iGZpNqVqbMYo+j9pzhzhGMqmttwkzjiEH6p+SZ+ZISShmLVf6Ugsk2Zqs0oss+Dah1chfDcOobPOkvwo1eJIu2e8abGSdAn75HZrF9H0ql0kWbuNHovLhV+dSnyvZWFqp/9KU6Z/3pqyCvI62PAkb46VfwgpZNzEBA9T7TJCN8XqKh0HTpv7EZefAm6mfNDcRMQFv0XdZVlvy12tJLf38iBJyA5vc0/kxbWVobE2lqdo+bYYM6rvRVqLl+A4irScCmZ4D8PMSVFU0N+XyjI0LOY2YzgyYBuQrZ4JSA+vYqlExrVl/h8klkR0pcLt4zmJMGW3n9AjuAJVhzY5nA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6552.namprd11.prod.outlook.com (2603:10b6:8:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Thu, 14 Aug 2025 21:39:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:39:28 +0000
Message-ID: <4e99b982-cb31-4166-8357-7994cb24cf10@intel.com>
Date: Thu, 14 Aug 2025 14:39:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/32] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0203.namprd04.prod.outlook.com
 (2603:10b6:303:86::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fce9154-2b7b-4fcf-7a36-08dddb7b0c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?amtoUTI3dFFWYW9nQ1RzSXhsaTJGRVNKOUI0VGV4T3ZianU0M2R0d0d4RWIz?=
 =?utf-8?B?S2c4eXp0WXRiSkFSNzFGeG54MUlrTWJGWmhMRGpZT2EvdmtmTElBVnVBM0hX?=
 =?utf-8?B?eWY0TGgxbitNbWVCYUZQWkNrYWdQTDhsaG1TRWZhKzJ4eVZpcnNTeWR0ZDRK?=
 =?utf-8?B?WCtIMEdhTjVPSXl4dzdlb3JVMkxDWmxIaUpaMmNBL3EwTEpOdUtWeGZHdm1v?=
 =?utf-8?B?c29kdHQzTXNuL1d1VVBYbmxOSHVGMWp0TVpmNVVwa2ppL2duM2FJWUJOaW1j?=
 =?utf-8?B?bU5ubG4vMEJFbGJPd2NSMTdaWVpCYjN2RnUyeFZYdzVvTHBRQUNxVHpRS3pE?=
 =?utf-8?B?QW1QQzJZQUtIbGpaWkdNK0w4dTBHYi9mUGdzZ2lEN3FiOGhxSm0yY0hZSEIv?=
 =?utf-8?B?S3NpL1phRzZJSEVUblVmMk5ieCt3KytsRm9yVllHY1RQNlFiN1Q2MkhWT0Zt?=
 =?utf-8?B?c1lScmozNThOQmpMaVNyVG1qM0ljRHdHYzVyNm1XNW41MWVDaUw2ZWtBQUpk?=
 =?utf-8?B?bGVTZjIyNHZDejVqQy9wdzRxdjRkdUsxYVgrRjJBMDlMc0xaVlB1TnY4WTJy?=
 =?utf-8?B?MTFJTVBMazdQOTFjNUpVTTJJb3BzMTNYTDBmNENaa3NkTGMwdCtqcjJmamtE?=
 =?utf-8?B?aDdOcWFKMzBpU2lEWHFzaHBNbFRZc0JTbTRwKzQ4MGZtZkZNWEhQRjQxcFpP?=
 =?utf-8?B?anJ5MmJSdkJHVEtnYnVIemxScSswZFduMUFVbGlXTXZkbkNSdEt3V1hGMFJu?=
 =?utf-8?B?aTFBOGlLOGU2VGFXM1Bwdi90UnBmdzZldmU3Zmd2d2o5bTZVVU4vbW4zeDRY?=
 =?utf-8?B?SGV1Tk9id2NjTmJHc3lnT25oTUtpOUFkRTN2TVFWa1RobmN5a1hTcXdWd2o3?=
 =?utf-8?B?TWlQZ3BrQlU0OXNtYjFBaS9weGpsR3Zpd0NJa0pJeE05aVIwYlNVZVRnUmU3?=
 =?utf-8?B?ejZCZkU3V2lrY2U3T1FiUVc1M3RPTXNXYW1vUEdRS3g2TWZoVkdiZlZnby9u?=
 =?utf-8?B?dkR5L1BwZUNLTDdIMjJ5ay9aeU1JN251VHYwV3FSZjZBcDFFUVV4ZDROZkh5?=
 =?utf-8?B?QUFub204c05USFE1Yk5GRFdwT1dRN2N4RTRhMm80STljUFlTYlFRMWsvZWJq?=
 =?utf-8?B?T1RHSGF6MEpxS0duTDNwcnZKTnAxVWx4Mk9oMy84ZjJtbGdYNzR5MytVM0w5?=
 =?utf-8?B?d1gzcU9zNElJalFha1dZNHFIdnEyb254Q3FZSWRnQXhnNEF3SU9WUm1yWVlV?=
 =?utf-8?B?YnQ5V0sxZG1EMHZZamxDNURXUmh0dGRTQWYxdWVNalFKTk13ajhSREhENFBX?=
 =?utf-8?B?V1dqV2ZWUUtaZkU1TkprbDBqTVp1MThCRFJLdWRvajdydk8rTC9KTkJ1dU1G?=
 =?utf-8?B?Uks5c2VnK2Mwbit4YmZtMnd0TjZSM2NHWXZjUmZ6TFJRbjVoQklxSDNVMDlN?=
 =?utf-8?B?VWZ0Vkl2VWJSSzVjZlFSUWdYdERxVjB5MmkwUkRpTkJLNXphUjhnZzUxbUNt?=
 =?utf-8?B?K3ZSclYxMkRZNEpwOVJiZUtNekFzeUZ3bG1GTzFIdGxGN0xFYUZDVGNsalBM?=
 =?utf-8?B?dkR3ZlZwYS9Gei96Z1RTMFR6WVNWalBBb3pHd3pTelFNWFBoOVIyNXE0dDdq?=
 =?utf-8?B?bnNjWTA5TU5LUG41bFFRSWFFVDhmNC9odEJTajZuTmt6Vm5qaFNQZmJkZ2Iz?=
 =?utf-8?B?dHZHV3FaSXJ4OUh5R1cwYzV4TE8vZlJLWnFKYmgrRkExdllzT3JWeFhaWHlO?=
 =?utf-8?B?UlRvMkhMTERWdVlSY1VDaW5vM2xsQU5VcURJSkd4UVRQSUpEM08xR1c3YVgv?=
 =?utf-8?B?a082Rk9SVDNiNi92TEgzam9tZEpidE1VS1NaWlBPODdQRmtVQVh6RXBhZ1JG?=
 =?utf-8?B?V3VST0hEeVBnS0lPaHB4V3ZXaHhtTHdwaEMrRW54UFdGL1BqcHg3TndZS3Vy?=
 =?utf-8?Q?+qWYFnSU2AI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1B2OVFOMUpoVXZraXN6Tmh3ZzJIcHJkNWJzUkJtM3ZRVEV5Y0d2K29Pb2ZP?=
 =?utf-8?B?ajN3WENiUytzbW9tN3FXbmZWbVNYK0NqR3djaEphY2llSWc3TENYbU05TjEv?=
 =?utf-8?B?Q3R4TGFDWWhibHI0dDNHb3ZKZlUvQzg3NzFqaWpOaXBOT3NSVDljLzJxY251?=
 =?utf-8?B?N1dWbjA1NDFMbUt3UjZCUVN2QXpQMmJ1M3FXN25ISHVFUEc5Z3JtTWtONWZs?=
 =?utf-8?B?VVFFNU5KeksvZVRXNUs5L3Q1NzdWMWpnRnR4QWthQ01lWk11Y3BmZ2h3VS9w?=
 =?utf-8?B?d0o3cXlHZ0g0Z0RhaE11NDlianNibFBqNldRVmRHSkkyN1k0N1gyWDI4Qzcv?=
 =?utf-8?B?MFd0MVlGakw0cGwva0k0L1dvb0RIVWFyQmVhbGFzcExhQXpDdTJxaDdtS2tD?=
 =?utf-8?B?M3pBQkxZbGsyV3d1ajRITy9sbjhiRURGakgzQXorZVFDSWZnNDhWeWJDVUg2?=
 =?utf-8?B?T2piNHJsUGw2Z3pxU29mR3lIb2pKejRlN1RGYUxBNkU2V1IvLzZaRUJwZ2ly?=
 =?utf-8?B?Ymp6UUI2MnFTajBydUU2RDNzc0MwZ2MvWWR6R3EwSHlZblp1TWlwY0FYSEhQ?=
 =?utf-8?B?UHEweGQ3UWJQWi8xeU9DT3VPMnBJZzNQL3E2c2J5OHBRd2pZMVhuOHFTN0JW?=
 =?utf-8?B?YWNKVmZuaGY1NWNzQW9hdFp5QmhJNlhjRFFhaUh0WVduTnVlZnFlRzQvbDNm?=
 =?utf-8?B?Q0U0L05ncGxNSmdVM1dVbm9NR0lpdTdVOHBGc0dQdk9xQTlnWDdocXI1ckth?=
 =?utf-8?B?YXFGdmlPc3JsMXRGOEVibzhVdmNOZE5qa3hqa1FtcjlRV2FDWlJCUzF1OFpR?=
 =?utf-8?B?a1R5RlNKOFpPUTRjR1J5UWkrSUNDVkVDRXl3cG1ZbmNkTE5EOGo2aDhrMzdy?=
 =?utf-8?B?VlNwSWpWdUZUTlN6Z04rNnBqZDNjR1JQSkZGSG5rQU1sdHNHTG8xM21iYVlR?=
 =?utf-8?B?NVUvUHFOUnZLVUdPSytRMmw3ZUxBRW1KdlF5d0VkanpaaHRiMGZhcVJxZjY3?=
 =?utf-8?B?QVdMT0tnZHAzSHJDR2k1QjNkak54UDd0S0MxSHE5eWNSYW5nejQyZTFCRkZW?=
 =?utf-8?B?UzhTT0JkbUpiVmRWYTVWZTd5c1I1M1hkVHdsekYya0pJNC9nSnFaUWRKNWtI?=
 =?utf-8?B?QUY0dVJDaEg3ckMrb3M5SmdtRlYrcU5WOUdNUk1sN3FUaUppVUMxS0Zma3lU?=
 =?utf-8?B?MFp3ZDhaOHY3TEJ3bHZBWmZGTGZJNGorQmN2MXBQcHFDY28xMGI3MDlyNHl4?=
 =?utf-8?B?RjI1OHpQUlBLYVhjS0lod2NyZWlnd3BLQ1N2bkUyZHF1RmdWNWZvVSs4V0Y1?=
 =?utf-8?B?ZHRVcDdsQlJLcGVtakFJREhsaHhVSzVNT3IyL1ZFMW9OU0MwTW5oaFZIZGhw?=
 =?utf-8?B?c254eW4rNEIraVRRYzdSTlBZeVpSSGZ5TlVvTGQyTWtRWkZNb3NnME0xRjBs?=
 =?utf-8?B?K2xPS1pRaU5Wc2JBcXJqRVA4N081elk5RVYvVUlhMHhITGNrYXNnQUVYemZ3?=
 =?utf-8?B?ZUpVSWttcHhnN29FaWxxc1RiYkZ4OUlnR1dZU2QzZUtOT1hSRnZRNVZldlRh?=
 =?utf-8?B?d3FsNnFXaUNFMWhKcFNGWVZLMEdSR3BWaVdpbGlIYjR2L1A3MG9DRFlPMzBE?=
 =?utf-8?B?K2gxYlRlYUZrR0hvK1g2dHZsaHc5SG1nMFlMYTRBeGFpVVJQZXRKTDluUWtt?=
 =?utf-8?B?bGhjK0QxMnpPRW5WN0xFNkpWek1mYVRmQmNqUkl0Z1FTSDd5NXViRnNFdnJJ?=
 =?utf-8?B?UWs2R1BtZGNnOFcwczlTWVJGYUd4c2hTayt1dTRWOFZXZzZ1NS9od0lZbFdt?=
 =?utf-8?B?L1lhbUFvQmNOcVNNT1BRUG9jVHVpMDVRaHFLcHllSUVyRmZGcmVEM0J3VVRr?=
 =?utf-8?B?U2Vaa2NzRmpzTXVtc3JjVkRTNThad2lXSjFWWndXamlWRDJHSVo2N1lxQ1F3?=
 =?utf-8?B?TVBYK3dObDdTRDdDa3FqVEVzTDdPZ1lEcjBwMlU1S2p1azcxWHZCR2E4ZlRD?=
 =?utf-8?B?NXZVVUxOYjhRbGZ2RktBN2ttSU1mejhQTTc2bEhMT2gvSmFCWmNPc2R1Vlkx?=
 =?utf-8?B?eHIzb2liWjFhUm5BVC9aUE9wenM4L3hZSm5UaW1tNHdubitXUFBXYkJsSS9P?=
 =?utf-8?B?M25hU1hESmxkREorNERtRUlBdUZEb1FaZEdMNk4xZ2JnNXVFSHBidmhYN3ZW?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fce9154-2b7b-4fcf-7a36-08dddb7b0c09
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:39:28.6938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbvIuDxxFk2qvw1ayf34JzpAJBgF0dv+zrx2kFQb9AVanF8qlHdGB4sYS1E1EJJW4I75EhUk5BIPA3lTpMjfM4RGspAwLFAin7LDGH1A6Wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6552
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> Data for telemetry events is collected by each CPU and sent

"Each CPU collects data for telemetry events that it sends ..."
(imperative)

> to a nearby telemetry event aggregator either when the value
> of IA32_PQR_ASSOC.RMID is changed, or when two milliseconds

"is changed" -> "changes"
"or when a two millisecond timer expires" (imperative and 
matches the cover letter ... almost ... there is timer vs counter)

> have elapsed.

Please make use of allowed line length. These line wraps are getting very
short and quite noticeable with this growing changelog.

> 
> The telemetry event aggregators maintain per-RMID per-event
> counts of the total seen for all the CPUs. There may be more
> than one telemetry event aggregator per package.
> 
> Each telemetry event aggregator is responsible for a specific
> group of events. E.g. on the Intel Clearwater Forest CPU there
> are two types of aggregators. One type tracks a pair of energy
> related events. The other type tracks a subset of "perf" type
> events.
> 
> The event counts are made available to Linux in a region of
> MMIO space for each aggregator. All details about the layout
> of counters in each aggregator MMIO region are described in
> XML files published by Intel and mad available in a GitHub

"mad" -> "made"

> repository: https://github.com/intel/Intel-PMT.
> 
> The key to matching a specific telemetry aggregator to the
> XML file that describes the MMIO layout is a 32-bit value. The
> Linux telemetry subsystem refers to this as a "guid" while
> the XML files call it a "uniqueid".
> 
> Each XML file provides the following information:
> 1) Which telemetry events are included in the group.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for this aggregator.
> 
> Enumeration of support for telemetry events is done by the
> INTEL_PMT_DISCOVERY driver (a subcomponent of the INTEL_PMT_TELEMETRY

"The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events."
(imperative)
Could mentions of INTEL_PMT_DISCOVERY be dropped? It is 
INTEL_PMT_TELEMETRY that provides intel_pmt_get_regions_by_feature()
and I do not see how describing INTEL_PMT_DISCOVERY helps here.

> driver). This driver provides intel_pmt_get_regions_by_feature()
> to list all available telemetry event aggregators. The list
> includes the "guid", the base address in MMIO space for the
> region where the event counters are exposed, and the package
> id where the CPUs that report to this aggregator are located.
> 
> Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the
> Intel specific parts of telemetry code. This depends on the
> INTEL_PMT_TELEMETRY and INTEL_TPMI drivers being built-in to the kernel
> for enumeration of telemetry features.
> 
> Call intel_pmt_get_regions_by_feature() for each pmt_feature_id
> that indicates per-RMID telemetry.
> 
> Save the returned pmt_feature_group pointers with guids that are known
> to resctrl for use at run time.
> 
> Those pointers will be returned to the INTEL_PMT_TELEMETRY subsystem at
> resctrl_arch_exit() time.

Last two paragraphs can merge.

intel_aet_exit() is empty here and I think that the code that "returns the
pointers" can actually be included here to make clear how the
"get" done in this patch is paired with a "put" to not make one wonder about
reference counting issues. I believe that doing so cleanly here (without the
active_event_groups that I find unnecessary ... more later) will make the code
more symmetrical and easier to follow while also removing the "just trust me
I'll do this later" uncertainty.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

(missing the maintainer notes about checkpatch.pl troubles)

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..25075f369148
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			within the OOBMSM driver that contains data for all

"OOBMSM" -> "INTEL_PMT_TELEMETRY"?

> + *			telemetry regions.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_energy_event_groups[] = {
> +	&energy_0x26696143,
> +};
> +
> +static struct event_group *known_perf_event_groups[] = {
> +	&perf_0x26557651,
> +};
> +
> +/* Stub for now */
> +static int discover_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return -EINVAL;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> +		if (!IS_ERR_OR_NULL(_T))
> +			intel_pmt_put_feature_group(_T))
> +
> +/*
> + * Make a request to the INTEL_PMT_DISCOVERY driver for the

"INTEL_PMT_DISCOVERY" -> "INTEL_PMT_TELEMETRY"

Please use line length available to not wrap lines so short.

> + * pmt_feature_group for a specific feature. If there is
> + * one the returned structure has an array of telemetry_region
> + * structures. Each describes one telemetry aggregator.
> + * Try to use every telemetry aggregator with a known guid.
> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> +			    unsigned int num_evg)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	int ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> +		ret = discover_events(*peg, p);
> +		if (!ret) {
> +			(*peg)->pfg = no_free_ptr(p);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups

"OOBMSM discovery" -> "INTEL_PMT_TELEMETRY"

> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
> +			       known_energy_event_groups,
> +			       ARRAY_SIZE(known_energy_event_groups));
> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
> +			       known_perf_event_groups,
> +			       ARRAY_SIZE(known_perf_event_groups));
> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +}
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58d890fe2100..56f0ff94c430 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -525,6 +525,19 @@ config X86_CPU_RESCTRL
>  
>  	  Say N if unsure.
>  
> +config X86_CPU_RESCTRL_INTEL_AET
> +	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
> +	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
> +	help
> +	  Enable per-RMID telemetry events in resctrl

Missing period at end of sentence.

> +
> +	  Intel feature that collects per-RMID execution data
> +	  about energy consumption, measure of frequency independent
> +	  activity and other performance metrics. Data is aggregated
> +	  per package.
> +
> +	  Say N if unsure.
> +
>  config X86_FRED
>  	bool "Flexible Return and Event Delivery"
>  	depends on X86_64
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index d8a04b195da2..273ddfa30836 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> +obj-$(CONFIG_X86_CPU_RESCTRL_INTEL_AET)	+= intel_aet.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  
>  # To allow define_trace.h's recursive include:

Reinette
