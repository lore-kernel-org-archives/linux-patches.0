Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4442F25F8
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 22:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764714296; cv=fail; b=pwjzMbr3H7mlBnsuZlzmqLW5ke9YYVcxQokEXccZu2jGKkhvHYQ3rqjHwmxKC1Tl7jRIjliHJz85o5QjbPpVQrtmgVxzEiitOeeyyVk5e4E9ZLc69KIfb/gkXW+BLwpCXMVpqnGgFXWweJD4wqBGaUhOWrfo3r3sJRUqVX0wS3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764714296; c=relaxed/simple;
	bh=wMQUHXfNeUqKik2csdsfwo4m4mBnffCOl6wrM+i+x5o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XPZvqPERZkkxOspLnNgBqb5TfPaSN9VBrG0OWytGMI3I9a57u0hl0QV9ffp5VaeCyd9q8Y9t4yMd/zfBlnmXdVBvWawH0SQ5KoT53jcTGhtfnAGvr8tIjVs5R9W3qBV66ppsl7IIGqBHh/rjXEasld6u/PWi4HT18lzbKZrigns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFiRPkx3; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFiRPkx3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764714295; x=1796250295;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wMQUHXfNeUqKik2csdsfwo4m4mBnffCOl6wrM+i+x5o=;
  b=VFiRPkx3MQh7zpz/COx2clSOPi6FSYHuAC+3xGIlK+UPRQuiAcdTPdsJ
   qyp+3R08b3KLCLep39dzkj7uMRwjDwEGnBPTNk30jYdWmJeAqC0fagWfv
   aluhv532LG1yepuYWEZrUbNOPFqGYRyi/l7uVT5mnKiJt8Jy341P7bIq8
   QFFmsBH6IMCDgMcyEp2VhfG/Q6PULZKPiSflDw1t9y5FrSVr92Iy0XLXs
   /bLemsreHco8GQD2r9e28Vk+PIFgJlntNst48aniOtITAANeDO7xAtyOz
   uCq3GwjbWQUB8+0/dE7g7mCqMQ5aphmOC2ocHiwZlmdIinY3/uO7zuFOi
   A==;
X-CSE-ConnectionGUID: V27KmwB+QK+Nu3XQeTpFoQ==
X-CSE-MsgGUID: bziUTPpXRc2flpZ73yV2sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66418971"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66418971"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:24:52 -0800
X-CSE-ConnectionGUID: XuS+feOhQCeAugFvXhOIGg==
X-CSE-MsgGUID: KwNEA9JERmidvQEgVZn9LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="231837026"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:24:52 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:24:51 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 14:24:51 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:24:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O+tIWPNjQZt6N5UmPksfCoBFhp8xI1sWyrlqXIAGfyXh+nzNu+FCjGsOStOTHkuHdAlgILZ9VHOf+wpSloySRZeYYfVpBvPoP9gzTJQmreVKR0zXf933eGc66mzGqPMj3I9BdmUspqYt2FxWPa/XyH2jzHZ535hGAG+ritH3KPw/0PPFn7WXQs4nxRBeLafoXfqU86wkb1Vl7kQQLlodp5ej1cr9TepZoNQx7e64E9cVqxeJpQLHnuNjhrTSRtjPVOa/6Bb5i8/mQeUvCYabUhXVlJS+1GyvRbwGBwCIcfH0OA1WYBamCTbTJhQaeBr1WB/6+8PP/cyF0PSt3p5HGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdAG4xT4jqbteI66vWX8CvPecCLieY0itGQa/mPZ2y0=;
 b=dzwiF8gjD8jGas4w2jE7Rckp+X0+ARAdKnKzsOqWoa07GV2sEezgpxXp8XvEUakgp6gcrOAQN84+2wCjTNfbVBiANENen7uO8kO0x+rp5qerHWe1ZfFuVl7fwHV8SNY3dotMwfVLswXXlJOSOBi9vbiPjmIcnojNvf8Bt8aEYLpI4ijNPtPyivA4cPXfskXegF+hRJu7Q7Y9ZvULRXWl8Dc5KfzvgyCM1FdV58dLJoLg3DQGVdRdrrc5mm0c5TI6P4O0GadvvnQBpFic1Mrh7Dqt9rFixafmWux0HmTYRvuZGyfTR57GVqKihndXS9z07Pzdi28I4oZej6jNcbz4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB8944.namprd11.prod.outlook.com (2603:10b6:208:563::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 22:24:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 22:24:48 +0000
Message-ID: <ee83f3aa-9d89-4520-98bf-78f371d214b0@intel.com>
Date: Tue, 2 Dec 2025 14:24:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-8-tony.luck@intel.com>
 <895cee86-ac6e-43e7-aece-e283200384ef@intel.com>
 <aS9NEJAnx0MWoyaT@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aS9NEJAnx0MWoyaT@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:303:2b::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB8944:EE_
X-MS-Office365-Filtering-Correlation-Id: b0489b0e-3cb9-4a34-a741-08de31f19ac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHB2NmlySlgxVGhySUJvMHBJdzg5RzU3MDFqQXNJM25zdFloM3hVT0l1bUlz?=
 =?utf-8?B?SXZMWm9GWno4b1JRL2ZmV2F5OXZORG53NlBsSDBxVkJoam9QUlV3eGlBODVq?=
 =?utf-8?B?YWFOQm9EYm1jWitqWTJOa3liZFBKRU9yL05Uc0hXZE5sVUpxTjdmL01rRzIy?=
 =?utf-8?B?STAvZ0pGZ2lTUUUweWk0SXhISzdZZVRaQUFXbHVqM1RyU2xORFd5czdSRDZo?=
 =?utf-8?B?WVA3b1krT0FTenhFb2RLU0lzMHNxc1BSd0M3bXg1OEE4SCtJTUEzeHVCSis5?=
 =?utf-8?B?c2dLUlVzYkhZTFZlK08yWTQvS2MrTTIydURNQTZETG5UMmJQVEZzNWZMaDJs?=
 =?utf-8?B?c3FmWkI4MWhMTkM5bC9aMzFCamp6bjc2VTVWZ3FtMHdWbklLMTZ5cG5ZSnJ1?=
 =?utf-8?B?SjBnMkFNdWFsQ0FlUmZiV1BOOE9ENS9HSVdSYThhR2lFZmVURGdyMHZHVkgw?=
 =?utf-8?B?WTZWSnljYmRGK29wN0YvTTNOZ1RHdlhZVVlLbm1lakhCaEdSR1BHazFrTmky?=
 =?utf-8?B?NE1uczNZSDdkSSs2RmhmSWVnTVU2RHVuUjhDSVZJM2N0aUIrbHFsTlNYUzFS?=
 =?utf-8?B?a0lZQ3BXSjR4c0M5QldLZmZDU3h2b3p4T2NwbnV6dkE5YW5wRlQwR2hRYWVo?=
 =?utf-8?B?ckxKbTRIUmpmbjlWMm9VZk4xQk82NlFDNjBSdzNZWm92UzFyN09MM3hTY2Nu?=
 =?utf-8?B?UjZMNWFFNzdUOG5LWEZ5Y0ZCa1RKbWhFUlBPWUFzdUcvYjhmREZHdnRNaTVY?=
 =?utf-8?B?Vnc4U1pEZG1uNkZpM3B3ZWFMa3JWYXNkaU1oanBaNUF5cjdZbi8vb3VmOEpl?=
 =?utf-8?B?T09rVGFmMEZoNXdXQVFRVUxZZzQ2SFQvYndDMDk0eS9ZUnNOdUtKVWlIZXVH?=
 =?utf-8?B?MEhoRGNqeXYzTFBLTU5JWFRLa0tiSVltN0QwbjY3UGNIeHdpeXNlRnBVTHhF?=
 =?utf-8?B?VnVPS2FMM3ZxMGsyY3FaQ29NbkRIRGsrdmpySXorNmFWK2hNVDJuRWVhM0Ni?=
 =?utf-8?B?SWhENUt6R0lWZnd6ZkdJaEErc1RYUmtmRFJRZER0a1JYRjc5cklPUFVzY2Nt?=
 =?utf-8?B?M2wrQVA0czN4SmQvY3RtZk5pclcvSmVpMHRQMFdrbVBnb3RlNVc1SDZSY0pr?=
 =?utf-8?B?UHphcmk4c2ovamV3dGZwUkZzNE9BOEEwdnBlbnp3U0FHQk1wb3AwcjY0Wlh3?=
 =?utf-8?B?ZHJBa3VZYndQWWQ1QlFTNmgvdzdrdWY4ajRGUFE0ajY2QUh0a3NRbFpuNVlU?=
 =?utf-8?B?YTMwRXMyUWJTbnh0UXVtZVRLZTZ4MkoyR2lWYVdyRG9zem1XaXpJdDZCODcr?=
 =?utf-8?B?S3U3RjVrR2xjeExEdldQclc5TjZQVXlhTmgrSWNaVjBiZ1dXOTZiNUdRZW5R?=
 =?utf-8?B?d0JXRktlMzJsT21jbjB0TzJTTzVtcEZUT0N3V01NRkowTkFpMGFJMmFoQ2c2?=
 =?utf-8?B?cjdCTkgveXNXNU9qZWNLMWZlVmYzMmlwRFJqZENIVmk5UU1udy95UFBHSWhw?=
 =?utf-8?B?S1BjaUtKTkNVNzJTdTFETVh3bG8zdTBFYzY2MDVqY0JnNGZWN1lGbTlYWCtx?=
 =?utf-8?B?ZTRIaDJVend6UDBjYkRCdThzd01yd2Rud0hkUGtIRmdaVFZlYllOMFFnekpD?=
 =?utf-8?B?YnVFdUFKMDlWRTNjdG5lWGdzcVY1dXdSWEhmYzhLWFMxRjliVER3VEZsRXpO?=
 =?utf-8?B?d0g4NTNkRFQ2cmNSV2dxSkRWY1RsQ2RLQ2daa3QwdVZUcVZGMkVmd3hrSXNO?=
 =?utf-8?B?dlhsSHU1M0xuSzJMS1hYTFQ1RS9XOE16M0JxeDV3Q25SNjk0bWp3NmVxb09Z?=
 =?utf-8?B?d1NiLzNsUzN5b2lhZjdTemFwNnc4RjlUT0d6WVh5a2lNb2N5TkRGVksvSVJH?=
 =?utf-8?B?Z1VKaDFRRFRYTk5GWUVFemtIalVNb3B1dEJlVDJZaVFBTFJJL240N2s5K1Uw?=
 =?utf-8?Q?a2b0DedGRTzUAop04YEnpc92y9SwFTz5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEd0M1loQzIwdjUxZUwyVWxwM0hoUFQxOG1oWXowQXdwdG5lWFlWZWEzWVFj?=
 =?utf-8?B?MnJ5eWNEV0tKelNSMzVYbmEyTWFtM0FCMGRBRHlMb3lzWjI4UDArWnB6VlRC?=
 =?utf-8?B?U0RZRjRISUkzVGZVeWUwbEVsS3hrWGhLYnNaYmtLS1dTUkJrL2l0dkkydkJB?=
 =?utf-8?B?aXpDTzE3NXhQeVIvaFVPSFFSV3FycDFDUEQ0cEc0bEV3anFoRDdJUXpYNHJp?=
 =?utf-8?B?WjhabVRxYmRDYVdPd1FlYmxQaDNNWXRqRlBVNXoxb1NZTkR1SlRwUVFRSDl0?=
 =?utf-8?B?MTBqQk5DNzlucUUxYXJvNWp6OXJYYnQrTWlwaHUxb2pCN1JVdUtQeTMvUTJP?=
 =?utf-8?B?bmRMaHVmTHBka2JxOU9lUzBzbnlxV0lQUGhRRVQzOS9JSi9CRzRQd1NoaWdp?=
 =?utf-8?B?NHNGZzBCKyswMjcrekZ3WUUrRU04U0k1Qlc1enV6SjVqRzNqMkZVMU5xUjRu?=
 =?utf-8?B?dVVrY1kreHg3MzZTdUVhRnJML0JadnFSQWlBYURUdUJFUWZtUko3TUw0UmFD?=
 =?utf-8?B?aFM1L0JUTVVaRXNLcHUrbmJFNTFEWmZmSU9TNU4ybE13aU9ONVVPYjBDd09n?=
 =?utf-8?B?Z2hYMlIySEpyVFU4TDl4a01QOER0eVRhd3ZicS91STRGVU53anRvRUl2KzVz?=
 =?utf-8?B?ZWk0TEdUZVRuZVZrMlZ1WXNsYmdoSVpYcjhFTXJPMEZLVGpaUVVtUjNTNXov?=
 =?utf-8?B?dEJiZVFOZXplZVVNaGtIRHVXTzZJb1NGVFV0cWZVaU84RkRHbHhvTlNXUEhY?=
 =?utf-8?B?bTArQ1IzRzY2ai9ES3RhTm1LV1ZjbzNSOTU5ejM2ekk4YVlNTkJYVWtUS2xm?=
 =?utf-8?B?OVVheU1SdytJOTBndU5lNjlxcVAzZmZZTmQyVUpzK2NmNmpnM1oyWDMyOVo4?=
 =?utf-8?B?R3MyTS9ZSVQyUG5MNStnbnJhMlJYb2xnM0pmazhVeXdkTDFvV2xOY2pVWlpo?=
 =?utf-8?B?enlZMnM1bS92YzZqNk16ZElhTU1kWHNHZmdldlFsUWdqbG9BZW52d0xadXdP?=
 =?utf-8?B?YW9Kdkc4bnVIUFNOYlZjclVuOUhDSmN6UGZIWk5xc09jM1ZoMW4ycS9rWi90?=
 =?utf-8?B?anU3STByUW5KMFZoanN5S3Y5Q0dBNlZackhzTlBvUEZxQ20vYnlyR0NySWVQ?=
 =?utf-8?B?NWp4SXlKQXpEenF1Q0hsR042K01zZ3gwWnBTTldLd2RwczFzV1dISUlVZ0pY?=
 =?utf-8?B?a0NtMlh6a1RhbVM2T1N1WmY5OUQ3dC9uRHEvd3RtdmkwbjFNMG1uSThYZkhG?=
 =?utf-8?B?Ti81T3lCWlN4d250eWMrT0hRaU1zRHhnQzFjUnBQdGJRaWhweEQwbVpPalJu?=
 =?utf-8?B?bzBnbnZEZkVONEREVWJUTHJzeDAyUzVzWUZnc1ZWVXVqNTRCTFFTVktaWGRU?=
 =?utf-8?B?U25KUzZIK0ZpVkhPR2hJSVVtQU41NWZ3U3pmcXR6NGg5eWFPUGEyanI0bmVI?=
 =?utf-8?B?YkdzTlRrd1hOTllaYVp5dkFvU0p4cmlFUmNuT0FDMTVlWHlvRDVLQTJKZ2R3?=
 =?utf-8?B?emR0ald0dVFCOUE3aHdlMldDZHhMMmRXYnFRR0RycWJURWxWNGdRVEEwbVRJ?=
 =?utf-8?B?TmgvMVBrZE55L2doODBuMzlFUjA5cVZyaWlTb1VCaWJmZUV5ZFFmSUk1VDN0?=
 =?utf-8?B?S2Q1d1dIM3dnWmNHbzYvTy9VSlBJY2cxTUZLVWt3MUREQm5pU1M1TTJwK2NU?=
 =?utf-8?B?WExUeWpPOVF2SnRZZWhnZkNCNGthZWJxRjR5dFVjQWNRbXJTN2paQkFGVXh0?=
 =?utf-8?B?SG4yczAyOVppZTdHSHNBMkpLMkNzenpYcUhNY0R2QW10cG5tNWxUZG93Ulh2?=
 =?utf-8?B?MVhCMjQ2WElHUGJHcG9FOENCZGhZUTkxdFhXakh0S2t0R3hlV3N1ZHBiZlE5?=
 =?utf-8?B?VnJqUzA2ZEJvbmFnN2hwaWxKS3I4Um9STkhQd05oQUNYVzB1MElOc3hiR05Y?=
 =?utf-8?B?bWVoZkkzSlluSDRHUTVzUDVHZmFRUW9PUWlnZVFCNFZFRGZ6ZzNTSDVsVEt4?=
 =?utf-8?B?VlhRZElQN0QwZVM1TmcyRUJzMnJxUDFWZVpUMEJobStVc3F6eDJUVzFOZVV3?=
 =?utf-8?B?SEI0M1NjMUhHRTU2Q0I4U1hvNDFMMm95TktPYmV6WFZ6VDZrYXNKTkFhWGV3?=
 =?utf-8?B?QmhWM29IZnJSRiszb1BvV24ySzhSVW9QeGd0Vkx1aCtiSVF0S3VCSEFWa0xr?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0489b0e-3cb9-4a34-a741-08de31f19ac5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:24:48.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWZmU4KrIf6uf4B7lI5VfOYdp+7ERAs7gwywPkOjJa2tD6I2RmbLuvjwgjYYn2A15SZ5kG5w1q8Xe6EawnHoRbmyP1ntOylbL+lSUodzB7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8944
X-OriginatorOrg: intel.com

Hi Tony,

On 12/2/25 12:33 PM, Luck, Tony wrote:
> On Tue, Dec 02, 2025 at 08:06:47AM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>> +static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>>> +{
>>> +	int cpu = smp_processor_id();
>>> +	u32 closid = rdtgrp->closid;
>>> +	u32 rmid = rdtgrp->mon.rmid;
>>> +	struct rdt_mon_domain *d;
>>> +	int cntr_id = -ENOENT;
>>> +	u64 tval = 0;
>>> +	int err, ret;
>>>  
>>>  	/* Summing domains that share a cache, must be on a CPU for that cache. */
>>>  	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
>>> @@ -480,7 +494,7 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>>>  			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
>>>  						     rr->evtid, &tval);
>>
>> This is not safe. The current __mon_event_count() implementation being refactored by this series
>> ensures that if rr->is_mbm_cntr is true then cntr_id is valid. This patch places the code doing so
>> in __l3_mon_event_count() without an equivalent in the new __l3_mon_event_count_sum(). From what I
>> can tell, since __l3_mon_event_count_sum() sets cntr_id to -ENOENT and never initializes it correctly, 
>> resctrl_arch_cntr_read() will be called with an invalid cntr_id that it is not able to handle.
>>
>> There is no overlap in support for SNC and assignable counters. Do you expect that this is something that
>> should be supported? Even if it is, SNC is model specific so it may be reasonable to expect that when/if
>> a system supporting both features arrives it would need enabling anyway. I thus propose for simplicity
>> that the handling of assignable counters by __l3_mon_event_count_sum() be dropped, albeit with a loud
>> complaint if it is ever called with rr->is_mbm_cntr set.
>>
> 
> Reinette,
> 
> Agreed. I see little liklihood that SNC and assignable counters will
> meet on a system.
> 
> How does this look for the "loud complaint":
> 
> 
> static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> {
> 	int cpu = smp_processor_id();
> 	u32 closid = rdtgrp->closid;
> 	u32 rmid = rdtgrp->mon.rmid;
> 	struct rdt_mon_domain *d;
> 	u64 tval = 0;
> 	int err, ret;
> 
> 	/*
> 	 * Summing across domains is only done for systems that implement
> 	 * Sub-NUMA Cluster. There is no overlap with systems that support
> 	 * assignable counters.
> 	 */
> 	if (rr->is_mbm_cntr) {
> 		pr_warn_once("Assignable counter on SNC system!\n");
> 		rr->err = -EINVAL;
> 		return -EINVAL;
> 	}

Thank you. On a high level this looks good to me. I am concerned about the architecture
"SNC" term creeping deeper into fs code when it (the fs) aims to generalize it as
"summing domains". Mentioning SNC in the comment may be useful though since it
helps to understand what is going on by being specific.
As a nit could the user space message not refer to SNC though? How about something like:
"Summing domains using assignable counters is not supported."

> 
> 	/* Summing domains that share a cache, must be on a CPU for that cache. */
> 	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> 		return -EINVAL;
> 
> 	/*
> 	 * Legacy files must report the sum of an event across all
> 	 * domains that share the same L3 cache instance.
> 	 * Report success if a read from any domain succeeds, -EINVAL
> 	 * (translated to "Unavailable" for user space) if reading from
> 	 * all domains fail for any reason.
> 	 */
> 	ret = -EINVAL;
> 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> 		if (d->ci_id != rr->ci->id)
> 			continue;
> 		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
> 					     rr->evtid, &tval, rr->arch_mon_ctx);
> 		if (!err) {
> 			rr->val += tval;
> 			ret = 0;
> 		}
> 	}
> 
> 	if (ret)
> 		rr->err = ret;
> 
> 	return ret;
> }


Reinette
