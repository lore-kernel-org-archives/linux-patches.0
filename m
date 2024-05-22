Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327EF76048
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412795; cv=fail; b=SgUtcxZFzPtenzLEc1GJ8uXlFNTFg8KSdp/3L4h4GfzX1uEpfu8CYd13TL1U0MBpHUNrGn1M6KBs0Eip9coOJY7S/8Yh16rlxva1v+CIif6xVgb1bSjdFZ8JPcbYVl/20MiQy8EyYpN9AxeoHdxgsWDw1ZBz+VDn9QseiiO0iLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412795; c=relaxed/simple;
	bh=RgL5ptBP3B1nL5esWh3HtbbUQmfIjlOvx9n/Q1qPkmc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mvDhNZnXM8x+bcGMm7p1YGeU215mNVy1nabyoSG9SPB+av26cPYfa1Lcwf30Jpvvlr83bviWHoh/+YOjVDJvhr2TmiVgqeugi3vrrHZ6Zo8d9XaHd/YWGn0dUV9sNruzUaZWYF8gNucCq9b9+q9B2GZjfaWBbz+CRS8KRzqTvCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjKIc5yZ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjKIc5yZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412795; x=1747948795;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RgL5ptBP3B1nL5esWh3HtbbUQmfIjlOvx9n/Q1qPkmc=;
  b=gjKIc5yZ7HSPYevKVGgKQe1leEYQ3jlat0YHTGV4Vbbn53E6cHkQ9IZk
   R9JVYEbUgYMXn0MF7Gwoe6TP2dvZ0D8tqzRjJQRmssSiEZbEW+uHjJ4Uw
   SLXEI5z2YlWUINTBXxx9emxHJCmYGktj2G50WYTxjpTuI7DTGSouZCDCT
   GRrF7M/3Dy2IegaNXcxgMScDYbEZSKx258Bu2oUwCXhLZ3uPtXUro0iZh
   Z1kZCxuEh/F2SJhzZhkdpF2vBfE30JDDQivt1el+9IMlwB84DFIyft0GS
   GvqJZ16zLWByB9Tx/Hr3xvrMa8KdSPE3VeXUs1NG9WX74U+minBTiEzde
   Q==;
X-CSE-ConnectionGUID: YR6P9ZeXQ4y35nICLFMq/Q==
X-CSE-MsgGUID: CRrNx+MXSuei3PPozDiVHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="30196253"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="30196253"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:19:54 -0700
X-CSE-ConnectionGUID: cTy8t16OT8+hr8nCWcS5bA==
X-CSE-MsgGUID: ewo041jdTxiwFZxWJQNN6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38216672"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:19:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:19:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:19:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:19:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:19:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayE03DLJ7NtraRxVtLuJeh1LlEo8P8PBOtfabhn4MkmWqz+JQmgsF8diXrp5eUZ266TtdKn5p/mLGmu6ocGv2clVPnRPB9wp4gGVVmNLrJ1qE3X2tjmIlr2hzTmRHylHkwWIgVeyLTazwzQF0QFMKLlsRstZ0KsH8pn0qYXQM+f95/YfJpL5WLY8ee3+xFf14M02WGPDO35v18Sb5afOxBVPNaOpmRYBXZYeT6pgtq4dsLdkMAXXf+plHEkYsBjjak/znTa1HzY13IzOUslsR0KxDCcKyqVZITAH6aBoEG4PKNxN8BgOcg+fd2dOkcqi2TAICaRuwzVV/yrhiSPLOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxD/QusL9a0uQLU8SFAeJuCKixld3ZA7ERjmsFslo1o=;
 b=YJ+ERczMzU0hinicFJSF9JDRU2C93QF8glUu33FYxqfOyBuU3gtj+JubqHZwAeOE8Vcuj8zg127Ug52nyPDxJkbCGe2l97anrYG0OxGLpA1W8AbW4a3uqMWKeOru6Ev/GcC5GpYoRHEszJuFWyiDHdtD9BlopXNK1AtissobgO8QDJ8K0F4vwwfusv2zkcb8jIEzDjG6wtuawprtPosBxF0c0v6AElLb6EAfUN4odFNjhLLP1ZEi0YU7EGVahjUDavWQy2Uz5ERlTzakHWlTDxWwrP24BT4YFp9atzrWXwTnuiBYndXGE7lLmDHOzrN04h+3rkmrd10jmbHaGF/exA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 21:19:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:19:50 +0000
Message-ID: <aa7d64b1-7c8e-4594-9e91-dfef2bae191b@intel.com>
Date: Wed, 22 May 2024 14:19:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 12/17] x86/resctrl: Create Sub-NUMA (SNC) monitor
 files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-13-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0218.namprd03.prod.outlook.com
 (2603:10b6:303:b9::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 781814a0-6c34-4a6a-5e2b-08dc7aa4ea71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N0ZTUEFVQlNwMEFKSXduV0luNlRKYnVKeGNSSWNhY2g1T1VQcTQ2eVJoNDdU?=
 =?utf-8?B?UVNvOGNPeWRqNnFaRGl6ZEdjeXNVZW9Ea0N2Q3ptdWFrUERpTE4zcUpiS2Zm?=
 =?utf-8?B?b25QbWFiZFRBUU5JSUhVYzhaSVVuMXhZNTFSWldwOW1GQWlOTkZwZjlsZ1R4?=
 =?utf-8?B?U3FscGhOcnE1VnF2aEtKMXdyTEd2cmRka0RSTVlQTWZHWVIvSEZxMDNKYVpF?=
 =?utf-8?B?akFqR29jcndnWmhEalhESGd2WnBKdGlSOTRIejIzUGtvR1hoWnZJR1hYMW5h?=
 =?utf-8?B?dDlwVTR4c29TS3BIQVpWamRnL1I4RkxJUjNab1FWd1BmMWZQcVQxRmszZCtU?=
 =?utf-8?B?K2M0SmJ4RTRGeUJXUnBlSFpEa0tNaHh1OVlReWJZalB5cFFrTHdVSjJBaHpW?=
 =?utf-8?B?amdEeXdzL0ZDWWdLZEVBbkhzWHp5YkNvWWZmVXAyYUpvejlPS1FQYXg1bWxw?=
 =?utf-8?B?NzZqamIvdjlpWkxzY2ZlR2lZTlpiVDBpQlhROEdXN282SzFKa2NETXBKMEpO?=
 =?utf-8?B?YUl3clhQajRhclJwYTE4bjcyQUZ2VDdKaTJxTGhsQlBjMi9PcjFvR2JWdTND?=
 =?utf-8?B?a1k3VVhPb3dySmlkb0FFSDdOZjM1TVB1WXJia2ViSnBjeXdiZDhBL1pPekxM?=
 =?utf-8?B?ZDNnQ3VML3ZNVHRNbyszM05Cc2VhVlVJTWcvbWl6bUN3eHdobng1dHhzdVpT?=
 =?utf-8?B?WjhsNGZ0SjRaZ3gvNGV3VTFVVjk4d1B4WThGa2pCTGJvaWVVaDF3RE02clJJ?=
 =?utf-8?B?V1cwbEJOK2ZaYkJPcTZaSjJRMG1sTlQ5S1UyYkl6eld1NjNuY0U5Wm1WZElV?=
 =?utf-8?B?TGliWFByN0IvejgrSG9VUmhLTUFTZUVOZWJWV0JLZmkxUU54ZTgxWVpxQXBC?=
 =?utf-8?B?UlVISnp1bkNZejlaVFNtOGl5MGpGaE4xSEpYaC91NTdlY1E4TGlqSDVjdjVv?=
 =?utf-8?B?VkxjcHVUZWt4VSsrTmQ0QTY1SnloekRqRFNoVVJrbTliZGhubE5uMlhGRHRk?=
 =?utf-8?B?QTlGNEVyZTNIQy92TkRURjhhVDJ5UnNVRENlbXFvbDloempsR3JCNWRvV1R4?=
 =?utf-8?B?Qit6c09pdWhXMFZMYzRyeC9ONDlmbVl6emZmckF4VXg0V0ZDWlViRWdtZ0tJ?=
 =?utf-8?B?L2ZGTnJVR1dpSk5PVEtFS2crZnBJekg4MnpuZGdpM3Ezd25RTnM0cVBOT2Zn?=
 =?utf-8?B?UDJpaS9JODI0MGxrRjVtci8zdC8rVitrTEl5UEFaVkFZMzBOQldzUmM1Zmli?=
 =?utf-8?B?OVpDWExKOFVTZWd6aXllcFI0MHdwbENabWtIYnFTS0JLZUFiR0NiL0FhQ3Vm?=
 =?utf-8?B?VlZFZHdJVlB3ODJBVFRqeVIycUhEVlFteklkeFpsdjNxM2dIYk5jclJNV2Q2?=
 =?utf-8?B?bzNkMlNuanpFT1pSSkFBWU1HeE5sN2JyU0loQW9NR2VBSXNRVnVlWHB0NWVP?=
 =?utf-8?B?M1docTJ6N1p3bTR1b3RrOGQvYWF2d0NhanRxdzdUTVpYeG9LWjRBSi8yR21D?=
 =?utf-8?B?eEhYcGc3a0RIck9rSm0yU3MzSnJkL3hESG5hWE9qUmd0UisrL2M4bHh0L09J?=
 =?utf-8?B?QVFweWdrOG05OE1qYlo0RzdvaVVCZTJ3SzAwMFlndGI5Y1IvbVJLcGdCSzAv?=
 =?utf-8?B?Q0cvV09pYVM2WFhnc0dhK0MyeDZhbW50Y0x4eThmWkkwUVBZVkJpejhJc3FV?=
 =?utf-8?B?UjBqSnhIVXJrVzZqUXp4elo3YUR1OEJkYVF1Mm9KY09sWmdCVnNqLzhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE5kNjhIcWdBbUtYZ3hHcE1nWTYzUFpINXV0YWVzK0lhRXR1K1pWTWZCeHFn?=
 =?utf-8?B?KzJkQzhJbE85RTZzdHprOWkrZVN1RytnQmRCbUtWL2FOWGY0cjhrdXZwa2V2?=
 =?utf-8?B?RDYzRzIvY1FMNHR5WHMwemhrd0dPSzJ2YWxJbTRTbi9idHp0WnI3M3RhWnBk?=
 =?utf-8?B?Ui95d0FqWFhLZkdRdkx2WVNWbmU0R3dxbjh6N0IxMUxZcmpER1hrczRoT0gx?=
 =?utf-8?B?cDZYSGFZMjlXT0JxYk1JYWdBV01EYlprM0dFQXM1RjAvOGFObXZ0NVA1WThV?=
 =?utf-8?B?SFRwRVJvZWMyM0hhZHZWWXFnR3NIVjRHMUoxd0Urayt3S3hqMnBWSThHQkoy?=
 =?utf-8?B?ZXVRLzhwY2R0QXAzWEVmcGx4cE03bW1QTjViczJXTDlSRWpCL1lRTXFqYWNS?=
 =?utf-8?B?UnhOclgwWkhXdGxPYklWaUVubWptWThNbGxaTFFQZTJHNXJXMEk0Y3Nwbkh5?=
 =?utf-8?B?MUJtWjF0QTBBck1OKytDUUhaVm1oZ0pWenlOTmZzMWgzcjZVbjlxYWJJMnc3?=
 =?utf-8?B?cUtLWVEyU3p5elhnK3NlS242SjArM2pQK3RxZ2tDQ01udXZtalJPWEFSRnpI?=
 =?utf-8?B?c0l2ckhnMDdqczRSRWhzdVNQZEJSODV6eGExNGgvK1ZVSGNBVHdOYWVRVG9y?=
 =?utf-8?B?YzJZbTh2MnhLeFpQVEZnU051MzRtNEJ6ZTBzdUpVRm42ZW03MFFUL2lkZWUy?=
 =?utf-8?B?Tkl1ZGw3ZzlKb1l6UUc0L1RCQjNuRHZwUDVLWTVMekUydmVNaElyZXpDRktr?=
 =?utf-8?B?RDhJeUhIUGt2ZXM5ZGx1a2RFYTdkREtyL1JYRGhGa1lGeW5CRmZqeXlNb3gz?=
 =?utf-8?B?UUlPZ3k3aUNKWlV0SUVzVzc2UkdWN3hUUlhrS1Q1SVpjd3NFV1VmcTM0YkJ5?=
 =?utf-8?B?SjNOQmxBclBpNldIYmZKWVNncXBUbFJ4UUJ0VVNyYTgrdkpFTzduVFFoYzln?=
 =?utf-8?B?dmN4bHNMUjBZQTEwY3hJUC8xNFVpS0N3TXB0OGtDOFFxVW1ndm9iSEtCWGN2?=
 =?utf-8?B?aFhINERkY0E0Z3Ayc0QzaFlwRDFsYUkrcUMzYzZBS08xOTB5U25VNEZJK0tQ?=
 =?utf-8?B?eW0vZDNvMXc5NWx6b2tFb1U3Wk1SdHBIenN2bkpxOWZ0b2ZBMFZlSUhPQUlj?=
 =?utf-8?B?bEFMNDErVktaWTBmTTRtYkZ5d1NhRVBXNzErMlhoOWRLTHgvTW5wMTFQdFhh?=
 =?utf-8?B?Q1pFTzlCNFg2SWNwQmw1SDQ5cmlxTWhEQldmN2FqNlJUN0tobXBpb3E4M1NH?=
 =?utf-8?B?QjNGOE5aWi9iRGVxc3FnR1p5NEhOOXdkdEJISDZJa3JVaEZpcmdYRGpQaDJw?=
 =?utf-8?B?Q0NIMXlLNXdjdXFLeUxQdlVVVmJ5M3NxeFViSnQ5bzdCdDJVWkNqSUZ2Q01a?=
 =?utf-8?B?aE52Q0d3MWF1cnU2U05XOE4yNnBOdkp0WnE4RG1pVGZxS0dXazFZRnlYbVZR?=
 =?utf-8?B?cEJKek9BelpOYjBOT2U3cmlUbUFiOHg4VmdLaExJaFlWV0MyS2VkSEliUjJD?=
 =?utf-8?B?UEFMd1A0eFJGQit4WUdnMFdtS3EzVGJqNHlzZWRpKzFBSVdkU3NLUXZYQXBL?=
 =?utf-8?B?cWVVNllaU1c4aTVyWDdzM04zNUoydTBEMTY1WGwrRmlvNHBHY0RlNWM5ZnpW?=
 =?utf-8?B?S3JxTTZsOGc3Ny8xMnlUaHhyMjNPTmx4TkRlZzFoY3JYK3BjdzJrUnRLQUdw?=
 =?utf-8?B?S3FoQm5sRVNBYTE0RHZjOUVpYWpPNThyamlCL0J6Wkc4MXZFSzJmbFVMUnVE?=
 =?utf-8?B?cjVDK2RneHZraGxUSGZiVjJrS1h0SjBLOVNjUllyNHZqdXNJZCtQU3RWRVRa?=
 =?utf-8?B?UjJKZ1NFSUpVMm5ZdG8wQXpRamdsTVRRMzdXNkF3T3lDTUZpWWdKNnpCVHVV?=
 =?utf-8?B?NHE4K3FDdTdsdmU0aCtSbDlJQm9NUmJTR1MwVVMzU2QvU3U0cnhocWZVVVpT?=
 =?utf-8?B?eDVmdlRMNGx2RDlHZ2srUUdwRy9QSVFySTRhZEx1RXkyam5rc0crbVlrMVN5?=
 =?utf-8?B?d1h2R3V2NW1yRzZ1N0xMMUVCcGZxc3BEZEpSRVFUWEgxcnQxUUdIaGwrM1hx?=
 =?utf-8?B?SUdiTzVOb3QvK2FJLzg0bTNmcW9nWlhkblJNVUxBU3p4UWhLOTB3b0FmbzlU?=
 =?utf-8?B?cUx0MGtnSEtjbTNod0NoQVJmb3RzQ2ZJQTlrL0kyM1o5M0lLVXhsOW1Cdjd0?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 781814a0-6c34-4a6a-5e2b-08dc7aa4ea71
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:19:50.7347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4Mq9efCntedfhfZZZJRAIzf6B/bHRcGjuiQG3zi/dCiDqGJMNmN1BF2kCQDAfoLlor36PQtt+Lfh4iCWiQPC2IYfcwkx4C2otOsVAULPjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> When SNC mode is enabled, create subdirectories and file to monitor

"and file" -> "and files"?

> at the SNC node granularity. Monitor files at the L3 granularity are
> tagged with a "sum" attribute to indicate that all SNC nodes sharing
> an L3 cache should be read and summed to provide the result to the
> user.

Why go through effort to create a generic "monitor display scope" and
then just always refer to it as L3 cache scope? One consequence is that
the code and changelog seems to have a disconnect.

> 
> Note that the "domid" field for files that must sum across SNC domains
> has the L3 cache instance id, while non-summing files use the domain id.
> 
> Also the "sum" files do not need to make a call to mon_event_read() to
> initialize the MBM counters. This will be handled by initializing the
> individual SNC nodes that share the L3.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 53 ++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 7a6c40aefdcc..f0f468babdea 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3026,7 +3026,8 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  }
>  
>  static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> -			     struct rdt_resource *r, struct rdtgroup *prgrp)
> +			     struct rdt_resource *r, struct rdtgroup *prgrp,
> +			     bool do_sum)
>  {
>  	union mon_data_bits priv;
>  	struct mon_evt *mevt;
> @@ -3037,15 +3038,18 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  		return -EPERM;
>  
>  	priv.u.rid = r->rid;
> -	priv.u.domid = d->hdr.id;
> +	priv.u.domid = do_sum ? d->display_id : d->hdr.id;
> +	priv.u.sum = do_sum;
>  	list_for_each_entry(mevt, &r->evt_list, list) {
>  		priv.u.evtid = mevt->evtid;
>  		ret = mon_addfile(kn, mevt->name, priv.priv);
>  		if (ret)
>  			return ret;
>  
> -		if (is_mbm_event(mevt->evtid))
> +		if (!do_sum && is_mbm_event(mevt->evtid)) {
> +			rr.sumdomains = 0;
>  			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
> +		}
>  	}
>  
>  	return 0;
> @@ -3055,23 +3059,42 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  				struct rdt_mon_domain *d,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
> -	struct kernfs_node *kn;
> +	struct kernfs_node *kn, *ckn;
>  	char name[32];
> +	bool do_sum;
>  	int ret;
>  
> -	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
> -	/* create the directory */
> -	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> -	if (IS_ERR(kn))
> -		return PTR_ERR(kn);
> +	do_sum = r->mon_scope != r->mon_display_scope;
> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);

Why not just determine "display_id" dynamically here and pass it as parameter
to mon_add_all_files()? Previously you mentioned that error handling is a problem
but this flow can surely handle errors, no?

> +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
> +	if (!kn) {
> +		/* create the directory */
> +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> +		if (IS_ERR(kn))
> +			return PTR_ERR(kn);
>  
> -	ret = rdtgroup_kn_set_ugid(kn);
> -	if (ret)
> -		goto out_destroy;
> +		ret = rdtgroup_kn_set_ugid(kn);
> +		if (ret)
> +			goto out_destroy;
> +		ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
> +		if (ret)
> +			goto out_destroy;
> +	}
>  
> -	ret = mon_add_all_files(kn, d, r, prgrp);
> -	if (ret)
> -		goto out_destroy;
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
>  
>  	kernfs_activate(kn);
>  	return 0;

Reinette
