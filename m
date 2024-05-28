Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7951F13F432
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716936938; cv=fail; b=CEnHOE6syVQ2Hn/Y5gHDq/F1FHh9YuNUBtfD0AyyRGnuWTy61obsbFALHNkAr9SjkXvXxgnfxtY5WYPlHEs64kmtdAgqSszwFdDiiOhybybmt+Vpmsz+r0AknleSKZ3o04c6LLBa4KdX+f8fF8O+S4ti+QWTsNHN7ANlK6Q2Smg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716936938; c=relaxed/simple;
	bh=DktHndNqPptTDs2MhrHbZcGxxYrW/kbLrave+Mw2wBU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hI89LRaoMFG+9FRgmj8wN7MwnvvByXiTapY7+yoElV+zf3Y/FeHrNzZ8b4PxHE8sbArbtbqmIsYN6oCwRWjF9izB/kADGueuvrLv0zr2CMw24lqs46jlZP/raVAIDkEDSALNYxHZD/hdtYIh5P/R433HB6Za1W2Z6j9S1r1FBTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j46NxDXa; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j46NxDXa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716936936; x=1748472936;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DktHndNqPptTDs2MhrHbZcGxxYrW/kbLrave+Mw2wBU=;
  b=j46NxDXaAJJFyKoe7IRaby7L3bVqv8pFTR3cRpkkyJQd32Pmkk25sO++
   zWUDU9aXNR5WKCAA0USIg9Hxjzq5I760Fv/udt2in8fb9PhJKVg1vF8hx
   ABx4fTzPs+f8i56ymyEmRy4zCT69r18AYkWUQCxVRfdnKNUY9dkNVNlI0
   DJfFMEq8OMcQ0B8MHlyI/+pQDMOldSjNmgfEdVZ+FRJHIr5JnKnTN3faY
   wLasInNqxkj7Wa3uDfYXCZO96GfUjC0KLxKyW0ggYNktbL+fKdhIZLAtP
   Joq4KSmoKnb4RoTjD5kJVtZWo9fHoZAgD8WEn9nq65+kKSvOpvmj1Ut/E
   A==;
X-CSE-ConnectionGUID: r7oZb1ReQPaJIxGo3s5ayA==
X-CSE-MsgGUID: WYqACvU0SXmZwlqsDa5qfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13431512"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="13431512"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:55:36 -0700
X-CSE-ConnectionGUID: aunAzVB9ToaOaYfQmiMTkA==
X-CSE-MsgGUID: uTz4KDY0SNaJRE22qnEDIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="66415616"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 15:55:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 15:55:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 15:55:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 15:55:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 15:55:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMQbQw3nsHhzvVrt7KpE82OqgHeAl3JJnBLH9+RP5qWuvc8pPbrnJC8LR0cbuquUT4+FLLlNLERpqj8GdQ+hX5NowTVd4kN9997LPq+NvHB5VDVD/K4wqk9bmQpABTSJ+DB17ku0EnzgBhB1q8JuonLvDqYosed2uFq7Vvl9GF6HZ06w4qDPVbvyfowzQ6o3N1lcD8o/OPu/w7rCOk/Ak589jLKM2KWmDteSNN//7q9dDmETHWn6bqlkXSWN3x+KUhrObfCbQlT/fiNiXaXCiHA9Dsw1iVKQkxMWWgmFveWitid7RfqW1G0F6eI1Xcxd1dFUgdCd2t11CP9xgRbAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzBAVc9SwdB5O7mh8JsXt1oGZB3vgK46kMtpvuBEMlQ=;
 b=a0DWpQlOC/r6R7uK+YLVRIWuneM6ZU3qtSwPEJM/JB9kaq7LxjCfKFEdxGffyQOIYSHKRxJgp+yfkXk1qwdAeAJmQTG5KQ5fQmEQOGQfU2tVc+GRPT9IpcY2aIuE4ZAH+9rVuj1CvzeqjcYPXAZMsNiSO0q8Cq9vxW81prWvpo2ZUM97YZIhNrrtCjfY7lPyrmOMOawN9xZXxLqp5B2mlGwDpTRWGbvz6Oymz4Db8o1KqTYq7IrWtdh2hqQEELsPzpkd5cU2G/0vl9OTXtfJ4gs11nlZTh8hR566Ori/LL8+xERIfZBa6GRnS+u7tRLaLpinAic6InXjQCs9tw3ROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Tue, 28 May
 2024 22:55:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Tue, 28 May 2024
 22:55:31 +0000
Message-ID: <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
Date: Tue, 28 May 2024 15:55:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:303:6a::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b5d1fc-0238-4e22-01be-08dc7f69469e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M3ZabDFVVm50bVV3c1lrY0h5UEQyNE9ITlhVcEdvZUFvbVhONUhhZUJFRVRh?=
 =?utf-8?B?c1o0b3V3ZVA4ZlcvQnVQUEJJazh3VzJqdzBjVVhRdGhGSFJ1b0JyRVNjUmpP?=
 =?utf-8?B?MG9La0ljbzNGaXlXeTYwWVpEOXd5bWxZS3JNbStGcC92L2trQjIxV2lFclNO?=
 =?utf-8?B?dmhsdHN6QllRb1pvQnVpYjUzcnBhTmQ2dlY0ZkZjMDhnUnpnQkVKcWFRVGUr?=
 =?utf-8?B?NUVLaVg2VEFDTkI1WFk4TVdSVlptc05TbUZFRDk5aGVNWEdoYjlkZkd6NE1r?=
 =?utf-8?B?T2V2RnpQdnBlSmxnRmZMNXdzNVkrNEpUcnFzekEvQ2hZYzROOVpvRFY1cTZO?=
 =?utf-8?B?eVliRlJiQ21jVTc3N3dTakYzZUY0dXhNOEVoSUR2am5tM2FkR3FONCtGaEoz?=
 =?utf-8?B?eUF5VC82d2VJSXRsa2ZPa0dWNGJZWmE2WmtDM1E1RWxMbk0vcEtOZDdlcVF1?=
 =?utf-8?B?WDZ6anFvakpCVU8vbERqWEZvZFA1N2dFN2FOV3NKMFlvcWlCZnpKV0NPb1lq?=
 =?utf-8?B?WDkzckU5K0tUNFJhYUNIRVVjVUFMcmFJbnFMN2M4clc2Y0pXTXNEZGpNWFRu?=
 =?utf-8?B?MXhVNytyNmp4eHI2LzBFNTNxQjQ3WmpYMytTelduNnNUMVlHKzdYTjZtZlBs?=
 =?utf-8?B?cjhQeWFscVhDUlRKbDhPSHFpeGVLNEh3QjA5QzNkUDZjOEg2bzR2QTR5K3U2?=
 =?utf-8?B?Z08rWGJ0dmdyc3ZUMVJHZ2FTZVlKVkhYaDlvQncxQ1VXNXM1dWV4RzlJckdV?=
 =?utf-8?B?SUY0VzVqcDc3cXpjRkRXL2hscTZCZDM5L3B0TVBndDhyU1FhYWhPaUI0M1lV?=
 =?utf-8?B?b0dwN0VPWGNqRTFHcmt6TTNzckhlT3VMY1E4QUVyVHdEKzdERE5yKy9rMWRP?=
 =?utf-8?B?RDZnNWpBSXZHTi9adVZaV0tyT3pCVkVMTHNaaFpPL2M1VXVIRy91RXNid3dE?=
 =?utf-8?B?ck9nb0lkRThBek1ER3JxZUpkemptRTZWVXBjejlnYjdWdzFrbzhqQ3MycWRm?=
 =?utf-8?B?RnVrc1FSd0tCQmFBRjBBUEZieHdFMnUxMlFvaDZjOFpDM1NFOVBLV3Jmb0NQ?=
 =?utf-8?B?L21SYkYzWURGTzE4Z0hydHUvR1hMb0xhNE9RMUhMNHZsZHJEWTU4dG5yK2VY?=
 =?utf-8?B?NWhrT3RCcmVzQ1FwT1Z3Tk90SVRYK04yT3RiTzBTVkE1clRFYlNieTM2STYr?=
 =?utf-8?B?Skc2aU1CVnlnQmpyQ0tkWEZVUE96L2JrRWg1WHU1WEM5akVJNFVJMllyN2No?=
 =?utf-8?B?UTFuRnJHVjdRVmJpUVA5MmNLZm5YV1VUU0hpcFlUYk9ud25aNGh4dVBrRi9l?=
 =?utf-8?B?VFdJejRrYUk2TkZIZnpuQ2ZnMnFnS2o4R2JhZHplOFlabG0xazMvZDJRM2c1?=
 =?utf-8?B?TVdUeVB2cFBDVUR1RFREK1E5ZFVIZzZyOHJoQnhVcUhkekxaVUpwbnMzTWd2?=
 =?utf-8?B?aWJOS055UC9JNXVSSDNudVByZWZlNGRyaVpMYjQ3OFY1NkdpYmhtTTBaM1dP?=
 =?utf-8?B?K3N2MzBkOVYxL3loczJZaDI1dVQrKzdFYno3K2Uwc251ZnBkU21sd1o0RUYy?=
 =?utf-8?B?anBlTHNkTkI0cTlzbWNZc0pZTE4vZ2lNN0RqbmVSTmlvc2QrcFFTMWZJQWRp?=
 =?utf-8?B?akZZSmR3a3VRR2N1dnBqUHF2OTl6dnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0JvK25vTFBsUFNGMXRxZTdtTUJtNnE5d3dHdTBYaTZDZU5EQWtWelowQ3ZH?=
 =?utf-8?B?NU00b1IzdXpDd3VkOVhEWi9XVHlwa1BVK3E0dk9NcjQvcEVzbWY2dkVWcFAy?=
 =?utf-8?B?NUlKTlJCWmpDaXBYNzRhck9pdTIwaUVjVXVXK0R1NE1yaHRtamkybUo0VXBZ?=
 =?utf-8?B?YUZDS1cxMnZxZElrcGk5TUVmSEFpNTRhd0w2a3NqVlBPU0krMytUdnFsVVJr?=
 =?utf-8?B?M0h0WlE3YzI3M1VoVFBSNmIreEFTc0o0S1pFSGxHMlhXS25FaFJPN1hlTTlS?=
 =?utf-8?B?Z3lBMzV1YWhMNEVRNHl4K3NoVStibnE5Q1d1bEN1L1gyQUk5M211bFZEM2RY?=
 =?utf-8?B?VzFOdXNBRnBIRjN5R0VkUTFyWTVQTmFXZXRUd25wSE5lVWpteFRZVE9aYmdm?=
 =?utf-8?B?ZlpFbEdOWVFuWitUUyt0RzV6M1FNWTIydG1jNXVhZUtQY2p5UkR2b2RDcTVW?=
 =?utf-8?B?N2ZMeGhOeVMrekFna0RjZGQ1WVNKODdLVHVadDA5MXZCdlpLR09QUm0rY2NX?=
 =?utf-8?B?cHBLRmZuUlRZTUdTVCtHQitSaHV5aGdPcE9LOXpaU1FxVTcrd2w3bi9wZlBL?=
 =?utf-8?B?Rmc4MWtiM2xRbVhyS0FVbVlSL09ILzIvS1hjUy95dHV5Q1E4ckluVWVMRGsw?=
 =?utf-8?B?L0hDcnNYblFDcTd4SloweWttdWFrdzQ5U0Y5eldQYWRpVTNobFpxTloxdlQx?=
 =?utf-8?B?NzlYSlZUVkhlMS81bStoNHJkSXNyMmp1UFA3R1hNMmtULzREdndSYldHdWpD?=
 =?utf-8?B?RVh0MlBtT3k3MjNYblM1RTdlbnU3TmFZNldzTHltblBqN1R3eVFLM0tPcmo0?=
 =?utf-8?B?N0xjUHpyNzN3elNGUlM1NHNzU2hYY3c1MUIxUS9jaEd6NVZBWWNRV3AvZUUy?=
 =?utf-8?B?eWJUU25tdzFaSTBEd01PWWczeGpTdGtlV1pjejhocGVQZzVERytRVlMvbzRH?=
 =?utf-8?B?cXdKV3l0TGVYSlNQZ3orZURXaTNIc2puM1R0MmRpRi90TDU2VDdSUnhYYzRy?=
 =?utf-8?B?ekZTZnc3MlBPYS9YbjUvRytOTVhGcTZINDZLc21TQ0xFZm4vVkV4dUlWYnNG?=
 =?utf-8?B?UEFFdVZsWVpOb2xia2tWUi9TY29Tand2RTBUcExIU3I3SGxJYUdLcnFKMjVB?=
 =?utf-8?B?eU1iZFJia0kvYUlhU2ZwclZzZS9HNXNyYlBIeW41VUlBTHdyeG5wekR0SmdW?=
 =?utf-8?B?bVZnTEtKdDE2dUFTT3VoeDk1b3hwdGF2ZktNUWYwUlpyU3Z5SmVROXdCSWVK?=
 =?utf-8?B?Z2Z1aVJVeDRrN0lVcTBRY2trTzFPaXFJT2xFVU5CZ2xCWXI1ZnNJa2lWZnZO?=
 =?utf-8?B?MGhsWG16V000eGVTeDk4NjYxKzJKbjJsOFhzblU3ODdaQWxqNnNOUlBFSm5S?=
 =?utf-8?B?UGMrT1lQVjJ0RUhLajN1Z1hqaFJuYTlQdWpCdVhna1NVU1dVeVYyUU5DWTJ5?=
 =?utf-8?B?eGZoQmoySE1FaWk2QjgxUk5nbEVKdXdzQlhSYk5wL2RQKzdnVmJkU1RIa0w5?=
 =?utf-8?B?ZlJnRzlyMitKQkwyamZ1eGREaW42Q3M1Uk82ak82VXNUbTBacnVPeks3N3c4?=
 =?utf-8?B?VTZuK080aG5ZTUNtd1VzWk1sbDJnMHRid2drek5qL204TWFYT0NqQlNsZktD?=
 =?utf-8?B?OU40aVMvMFltYlA0Nktza3FCUGxoL1hiMDVWdnpSMUhQZk5wZmNrWTBJZ2hZ?=
 =?utf-8?B?aG1FZXY3K2YvUklaRnplVkl6b2xUUW5GcnpjNFZxcU9Ja291aTJMYmZ0cENr?=
 =?utf-8?B?Q1lnMWh3TXNVZkluYmsvbFVOUVZlS0NzL09vMVhDOTZmYW4yZkR6WTRRZzQ5?=
 =?utf-8?B?d1gyL01kY1ZJZjFuT1NIVS9lUmNOWVNOMU1QUnJ3aFhpZktvTVBzeWNUSkRB?=
 =?utf-8?B?bm1WZjltb3dOYjhjQUxQMXN0bk5uZnoxcjF6NXV2djIwNm90dzlrQ3I4SVJL?=
 =?utf-8?B?VDBvaGd6d0FtL1ZKQkNwM0pBVlBhaFh6eE1tMExid1UyUjRJN0tWTVRBaFZn?=
 =?utf-8?B?SmRnT0xBTW1pemNDOHNycHpzd0ZWVlloNE93QW1CRVF5MlN3RjloK2pKZGJ5?=
 =?utf-8?B?TS9VS1NtVDNJS3YvLzFqbTlLVjlKUnhoR2JrVytldnhYODdWL2JtVzZ1TElh?=
 =?utf-8?B?RTVRWFkxemNnZ00wWkJDZm84Tzk0L24xK2ExQ2J6U0RjbEE5a2RQTkRCazdY?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b5d1fc-0238-4e22-01be-08dc7f69469e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 22:55:31.4063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2TUk2tk/mPZNwpav4can4Uwl9AVCCwGvMJleZF7ptW68O0sD+HzYvDCc8OBwvbnKtgL0qbjLSYV2ITSztzkHaFE8u3bU5MxYLBRP/7gWgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:19 PM, Tony Luck wrote:
> This series based on top of Linus upstream commit 33e02dc69afb ("Merge
> tag 'sound-6.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound")
> 
> The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
> that share an L3 cache into two or more sets. This plays havoc with the
> Resource Director Technology (RDT) monitoring features.  Prior to this
> patch Intel has advised that SNC and RDT are incompatible.
> 
> Some of these CPUs support an MSR that can partition the RMID counters
> in the same way. This allows monitoring features to be used. Legacy
> monitoring files provide the sum of counters from each SNC node for
> backwards compatibility. Additional  files per SNC node provide details
> per node.
> 
> Cache and memory bandwidth allocation features continue to operate at
> the scope of the L3 cache.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> Changes since v18: https://lore.kernel.org/all/20240515222326.74166-1-tony.luck@intel.com/
> 
> Global: Consistent use of "Sub-NUMA Cluster (SNC)"

(briefly scanning changes)

> 
> 1-4:	No change
> 
> 5:	Rename RESCTRL_NODE as RESCTRL_L3_NODE to make it clear that
> 	these "nodes" are each subsets of L3 cache instances.
> 
> 6:	Changes for snc_nodes_per_l3_cache are localized to monitor.c
> 	Don't use it in decision block use of mba_MBps option.
> 	Moved the old get_node_rmid() function here, but renamed it to
> 	logical_rmid_to_physical_rmid() with a block comment explaining
> 	how RMIDs are distributed when SNC is enabled. Function now
> 	checks if snc_nodes_per_l3_cache == 1 for fast return.
> 
> 7:	New patch. Only allow mba_MBps option if scope of MBM matches MBA
> 
> 8:	Replaces old patch 8. "display_id" field is no more. Add and
> 	initialize the @ci (struct cachinfo *) to rdt_mon_domain.
> 	Note that the new get_cpu_cacheinfo_level() helper function is
> 	added to internal.h as it will also be needed by patch 19.
> 
> 9:	Instead of display_id, add pointer to cacheinfo structure to
> 	struct rmid_read. Add kerneldoc description of existing and
> 	new fields.
> 
> 10:	Added to commit comment describing why mkdir_mondata_subdir()
> 	needs to be refactored.
> 
> 11:	Dropped Intel specific description of fields in the mon_evt
> 	structure. Say that choice of bit to steal was arbitrary, but
> 	can be changed in the future.
> 
> 12:	Fixed typo s/and file/and files/ in commit message. Now using
> 	the cacheinfo structure (specifically "id" field) instead of
> 	display_id.
> 
> 13:	Wordsmith commit into imperative.
> 	I looked at using kobject_has_children() to check for empty
> 	directory, but it needs a "struct kobject *" and all I have
> 	is "struct kernfs_node *". I'm now checking how many CPUs

Consider how kobject_has_children() uses that struct kobject *.
Specifically:
	return kobj->sd && kobj->sd->dir.subdirs

It operates on kobj->sd, which is exactly what you have: struct kernfs_node.

> 	remain in ci->shared_cpu_map to detect whether this is the
> 	last SNC node.

hmmm, ok, will take a look ... but please finalize discussion of a patch series
before submitting a new series that rejects feedback without discussion and
does something completely different in new version.

Reinette
