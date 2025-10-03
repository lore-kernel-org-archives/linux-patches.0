Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A8265CC0
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505422; cv=fail; b=eVW4nc93bATUdRZiGvwqElQrFxKy+/KffoOJXWuiu3Eob5e1Dyu53y4KFh+m/qSLjx2dkn9K2SYLQdMCywRQ7ds6E0T5Lt60r8cnO7S1/8lSUEJF7sQW8Rz8UiY83bQniTdLaP6w66rH/nM3e6q3ZTtmy0lZF+cOjgBXIiXqD0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505422; c=relaxed/simple;
	bh=8g8sloIrKYjz7Pqg5OEsvhNt3cUpY3+PpF0oLnDoL+8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dXUiALtY8oOFJbuq2RLQ2WlP8JNPkEx1FK2Gy7XkwfDT+LH2xVH4/JiSIpxqJOo8BVGEJO4KWQofpzOsPHujrNsKMH9/OUHCoC1Tjel86GxVm3RVTKQH0oVIQq8wrQdw/WQTPWPGr1QQ+CmZRG3e+xbBmd5Xe/cGLBNxLki6/QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlSR+Zal; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlSR+Zal"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505420; x=1791041420;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8g8sloIrKYjz7Pqg5OEsvhNt3cUpY3+PpF0oLnDoL+8=;
  b=nlSR+ZalM1TxBqbLMvjfFQrfG1wdNxtysxp8fJblUyFrUAVV5F0UUD9p
   4IAYkmfUT7Uoh3ME7yRNR45HO35v2UGNSzdYIGvjySKEosK2TewpTmrrk
   pX/C5Prb3orFsAOKXtk7W9oU7hIADWmOnz+W6xMxbqfSB83lohS63oDwe
   GEnVYW/FeBY5OMmgkRBIgIC3iQGjjhGaPQJtKZIu/JQu9b8LjTzKY3KrP
   opjqm42Jxfg9opnEvXNXSXHN+GsCSSiGOGYYTro+FOvqvlf09lm4JA73K
   ZS9nhJVJIPJyzpL0aNXEh3h6BCeIn1wHu+oyF5AfvpQWmHlIRi5rQcVE/
   w==;
X-CSE-ConnectionGUID: DxsPfViaQ7yYvPqgE+LiEQ==
X-CSE-MsgGUID: TNkMn10PSRK0QLGWaDU8rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61706510"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61706510"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:30:20 -0700
X-CSE-ConnectionGUID: oHCMXodlQQeOj5VRhghbsA==
X-CSE-MsgGUID: 8Quz4X1MRg+Gn6vb72r5nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="183330381"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:30:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:30:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:30:19 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:30:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUFP9zNVRa1+YlIr9OJdGuz7WzeFdIFx8D+ObKCqwrUMI02PNDMLqVovL8JWPAGkMYuqpubyMfX7MhdN8xPvshFGedXC+i870BY2cm856LsmUhySO/qYkf79CXqSCSO0drmgzX+b43EcIyCR5DJH3+myjFjWC2HC+R2WpY87Li/iW+uBRwI1I2ufcHvdYo2OQTfrt2dKhsW0FXQfz4AkEZubnLC/BFx4LerrqU40FCY0/DjWMg7qYLJqv/DGdHWB+OM5khHVETDYm1+1r/Pp3yly/UGEd8/IleuwySq+Qz9hMPgMM9IF9s8QNq2RvekJm5e/z3lxm1GHLcJiPcKwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uSvnDF/zDJOykYn1WvUIuypOHXRyo/GZbnaLYAGxyM=;
 b=tf5nW1H07E/QfTHbO4EvBZM6+yNDOBNbvIEaA4V4O746zO3yOrc9ejmtBXBBOjFXwVj/xTQ0zL37ojOwCpjYEQPP0mecQqv40FpUK4oG73SOqTPC82ZE54OF/aDyxHrEQgicOm6/H86yZvN7tyCm+DJn0+5qBzuIdyIv5uacZc8/en/4KFg1UyF+L9Ho6MxggXZfOkBP4j8ahX1to+IDSkZhedshd5rDU4NgAVUGF32UGlaUf/ZqSI7sXlgYS0KjyX0/oDQd+EKO/o5C4BZkxykuW7N7De5P5d1iixPTqGTz+UuAXzGn/pO0h1DrD9++uIvxJNRI2P255x52vohhyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 15:30:12 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 15:30:12 +0000
Message-ID: <22ee0370-2cdd-435e-a7d4-81dc0c3df547@intel.com>
Date: Fri, 3 Oct 2025 08:30:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 04/31] x86/resctrl: Clean up domain_remove_cpu_ctrl()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-5-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0127.namprd04.prod.outlook.com
 (2603:10b6:303:84::12) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|PH7PR11MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb63dfe-1edd-4d2e-7379-08de0291be1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a01ZdUg5S3ArcFhoemkyaEtjcWNqdTNkdk9qMk82SUhJMXVPbTYvNVdKOTBj?=
 =?utf-8?B?dlJ6TnJDL2JvWWhLZ0JuMVJmNjRzWlY3NkJHak1sZTdPR0NGQ1IyZlhFZUVt?=
 =?utf-8?B?YmdjUkRDdFdsazFFSW1NRmZyc2RocGFubHlRcjR2aWhXaTJscXRBellmbjNS?=
 =?utf-8?B?QmNROExPSFJwTkFuU0dvZUUwNzA4TnduSW9iTVZSRUVxRktYUDhRV2lvdkU0?=
 =?utf-8?B?YWdUUWNxRmN2VlRCSk03WGxtbFNpRG5LL0N4eDFOYW9YZzlrdHR1N1NKMy8v?=
 =?utf-8?B?RE1tYUVkOHZ4VTl6a1h4cStnYzFCK0pBNlZ0NjQwSkJWZDd2dGZ0em9sRHdC?=
 =?utf-8?B?cDUzeVRmZGZBYjl1MEwxTWgvbnR6ZmhpZEZzRk5uY21lOWNCTExndFhTM01n?=
 =?utf-8?B?aEYwbzI3U1hhd2Ewbm45eTZZakFiOFZKUEhSQWhDaEYvemVCYnMzUmkrd05O?=
 =?utf-8?B?S2QrOEJnVUx3MFFTbEQ3Nkx3aWF4aTJHNis3K3BnL091bXVlSUFseiticHZa?=
 =?utf-8?B?M1kzOVh2OG5Ub3kvd1lUdVhuSElpaEVvRWdDSkRnVTJqQjJIRktqSUQ2TE5C?=
 =?utf-8?B?bnd2eVpaMmN3dVNrUERXR09GU0ZXQVB2V2xXb2JEdHo4SFRBLzJzZ0txak83?=
 =?utf-8?B?MS9lMGVKVG9mYlNNUE8vYzIxSGF2NkFrRmZtbm1VaDNtMi9PbDMzVWJRU1Fv?=
 =?utf-8?B?VnhtOW52VVpMSkUwZ2lmc3NFdXY0L1BacGQvemV2NUZuOTJMMXpVSkUxdGNE?=
 =?utf-8?B?enRUWGdmZmZYaXNSWUJMNStQMWRiVTdFdllEV1dQYmUycmNidHdVVG43ejVw?=
 =?utf-8?B?bTF5UzdmNDN3S0x3bkVZa3NTSkhKYXRGS3FUc1h1eHNidkNua3ZDZlZhRTBW?=
 =?utf-8?B?SVhsakFJMXBBZFU2Y3Qrd3hXS1oxYUxmbnFMNHVHaFFUN3VWam9yalF5cUJ4?=
 =?utf-8?B?S2g0TllnVm5oSFA3NWpSU1ZJVkw2OHUzWjhvZU9DTlZybGdMVlllTXByZ0Fy?=
 =?utf-8?B?TlIxUG1GWXRnOERpNzA0ZSttU0xWQTRmaWtCUEZFU0tCUkJGTGxVUUp6VHZJ?=
 =?utf-8?B?N2QxclN1SUEvNHlhTTE3S2pqVDRpK1hXV3YrRGlnK01EK3Z5WmZGUE10M2xq?=
 =?utf-8?B?c3FOS2NwbCs3Sm1jOXRDMFhLTnRMQkNRVzJYL1JKWEF4YzRjLzljNUdKeWJw?=
 =?utf-8?B?UmF3anN3aHRDWWI4WmNua2l6ZE4zYkd6NnA0aHFjNDNvYndJSm41RzVsdm5O?=
 =?utf-8?B?Smk5bU4zV1M4Zzlyc2FMYUJoTnFWNzdBWURvcGIvQmxzQVN6Sk91Y0VyVm9I?=
 =?utf-8?B?VTNNYStFN1k4YUo5bFdUSGthK0JLV1dWTkJzUVlrckJCY2VZVmk4RGV1NytC?=
 =?utf-8?B?WFhRNGZacDA1WXRTWjkvSER2eHY3clFUUC8wU1ova0ZPbDYva0ptMVdpMmlw?=
 =?utf-8?B?UmUyRFZDQSsxTG1Zd0xRNHR2YWpqTDhmcVBSZ1ZYSTQ5L3o3SUVvYWllM0JR?=
 =?utf-8?B?Qno2bE1JL3U1bXdkejZreGdRTGl5cUZjSDMya1dDV1lMd05QbU9DQU8zeStQ?=
 =?utf-8?B?Vlg3NFhGcnc2QWVJUW9XSGwrQXRzclljNHV5bTJWMjBZbm5hNm5NSDlHQVVC?=
 =?utf-8?B?MHBwTHg0T3AzL1lsU2NwUmEvMDhHcHdnQ2pXaWx5VzdIbjZsNFpYa29kNE5Y?=
 =?utf-8?B?Z0tvK0tWUmJtQVBxdTZuZmI0dFZlM1dxNkhIclVqUFgrTDh4N25LR2FPR0E3?=
 =?utf-8?B?d2RWcnZSRHk4R1JPcWRXTVQrZ1k5OHRscXRTSlhvTTJQVlRKTmhhd1B4ZkNK?=
 =?utf-8?B?ZjJySXdBMHZwNWQ4YkpHWU9OaC9pcDBrZzFvVjdTRVNhN1RoekRKNEc4SzI5?=
 =?utf-8?B?cXlzUGtkZkgzNHRScHNlV0FxalNBRFNSbkZZUmdacFhTQTJIUXduUElCMFBI?=
 =?utf-8?B?TXhVMGZuaWtsbFM3dUlac1VONXB1V2NXZzV6ZzBIWjdQa1JmeFFENVVSL01v?=
 =?utf-8?B?d09uOTVrL2RnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MERVSWZtSWxIOGpncGVuZ3diaFJWUnlETUJIdVkwNXYxZThZdlRBRXJyNjZC?=
 =?utf-8?B?eGVubElWSVdBQURRQnhNNTk1MmordzdOdDhNYkVvQ3pzd210QWdjNWs5MjBi?=
 =?utf-8?B?WnhxSUdHeHQwdmYyRVNwTlpsalMza2NHZTllSTl2T1hicjJZZDB2VUxvL3ZR?=
 =?utf-8?B?cUdSWHd2aGo0R2pmWi8ySmZrdkFZSityQWw3UmpiL3kzSVZnMDRYNkV0ZHZ2?=
 =?utf-8?B?dUtXNkl0c2tWSnZqZFRhczJQdXRCY0FxNjM4VmcxVUpSWTVLMW1vdDF5OFZG?=
 =?utf-8?B?aFM2KzF1bUpZQndMSk9NeXhuQkZMUVpIL21BWmEzRmxZNjlJNTVublE0SGRM?=
 =?utf-8?B?dnVBNGRHRUo2R0tJQlYxZUlZQlJLaENhOGdhcTB2RGtXaGF0QkVIWDh6THdq?=
 =?utf-8?B?cW1jeFNHcFNGWlBJdDBoc0RiRnVvS1JyWkVxZS9WcENkZG9pNHJYeHNKa2xm?=
 =?utf-8?B?SDVZckM0c2RuUmVlejJCdXFXWStDWmJpdncxV1hOb3dwU1Uyb0wxNkhwck83?=
 =?utf-8?B?OW4wTUlEZU9ndWhCQU50ZjVuZVFtT1lVT3l1M1lDMVBKUWFyZ3hucFpvUWEy?=
 =?utf-8?B?aS9lNVl4bUNycU1CM2RGMU0yMXB0WDJ6SUdhSUxjWS9jL3E4Nnl5VXBsVm15?=
 =?utf-8?B?dGcyWW1lUnhGclZOME5KMEJ3Vzg2NkE4RnlTYkFEdzgrSDA2dXNhc1ZPLzVH?=
 =?utf-8?B?UDZGdGEwTEVQUitPdE5YREFNWTZ5QnBYVmZTSEdDRTl5VVNhUjhvaitVYVdU?=
 =?utf-8?B?SUNhWURJL0lmWXJ1REF4aDlsakxydkhnOVFIeFZiMVpKbkVaNFZPUFlSVWlo?=
 =?utf-8?B?R0REeXJyNjUrNktObjV6QURHK21JaHdJVkN0RGdmZWZ4Z2locW9yc3BEN2I0?=
 =?utf-8?B?RWtjVmUzaDk3VHZnWm56MkViV25vMis1cm1MeEtqUlczQURqdmpPbFFoY0pQ?=
 =?utf-8?B?VTJNMmlnNFNCZ2dZRFNONElmSURYMUxSVFJ2UklOTU5qUGdEYjBNSUVxY3Z1?=
 =?utf-8?B?Y0tSQnhhVXhPNEh0MVc4c1ViK2dEQVhTNHp1ekhqU093MDgrcHdoUWt3Tk5I?=
 =?utf-8?B?c3lvdExqREdEcm5VclUrVis4SlZoaXQ3K1JmV3VFcW5OVWtGTXkxdkU2Ritt?=
 =?utf-8?B?aVlLNmRaS0lzZzRoditRd2FZaVR1aGFZL1VSU25FbUNYZnhOekNaTTRacUp6?=
 =?utf-8?B?Z3BLOVdreVZKUWFiY0hldWs4WGR6eGJrTW1MV0VLU05LNkhUR05EMFB1QnNI?=
 =?utf-8?B?WC9PQ1NMTnRRQ29ob1NUcWRDN1VZbWI1alUxSHJIZERZbXNDTzNPb0hFY01F?=
 =?utf-8?B?ZVlRUkZ0eU9GaWEvSktuUUh5alZMcnMwSnpISlNtY1pJZ29ZNU1BY1VROEd2?=
 =?utf-8?B?MVF5YWNWallPSmRmbkxLT002cEJncy9yeDlBREhPL2RaNGt4N0NOa1FnMk41?=
 =?utf-8?B?UkhXdDZqQjQrUHB3UnRSNTgzTDMrWVJKRVIyMUhreXBqRGxHWWpNa1pDUWxT?=
 =?utf-8?B?M1QzYk4xTm5MeklkQ1VzcUo0bktqcXNVVm93b29BTzh2clVRLzJ5SjFLTHVX?=
 =?utf-8?B?OVhxeUdYdldJUWJyV1pLd0tOcFRLQmRuOUlWNjlkdHBKSWN2YmZGQUhXanB0?=
 =?utf-8?B?ZldtUFMreUlMd1g2NTdMU0ljZkI0ZzB1TTMyVDNHdlhLSnBwblZINDdhWGFL?=
 =?utf-8?B?K0xIUHVEQ3I1RVJGZlo0bDRrMysrUWRQUUNJSW5ZZ25ScFlpaHVEQ0N3MDYv?=
 =?utf-8?B?QzZ2Wmk2WHJHWTM3ZGtrUlZoamx6NjRWQ2tTcytmeHVsQWJ1UXFLUnhpcXlV?=
 =?utf-8?B?QnR3WVlNKzg1bS96SG9SeG5NdUVuZFk2ZnNmTTVBRVBrQm9wYXhZMDM0aXNR?=
 =?utf-8?B?Z01LVW0ybGYweGU1SGlydWRmU093WlBoZ01EUmY4L1RkM2lnZ0x0dlowckdV?=
 =?utf-8?B?VjJIWG9jYlJLQ1pLQUJqOUpRNVBDbms2L1U0a1Q1ZDViS2twMkNTdXJuRmhN?=
 =?utf-8?B?bFZzZk9icGJxSm82aWpTLzNYcjNzMFNFWlA1YSt6MVlXKzhwVGI4WU8yalhl?=
 =?utf-8?B?MWc0NisyazhHaTFMdnUwMW9tWFZqUWlTS0xVNTNCT0ZYTWQwNWE4YmVsZ0Vx?=
 =?utf-8?B?eG5jVE9RY0IxcDRSSEd4U0dwaVdKOUZGQzZ0SnFYQ2Q0Z0lTdzdEU21jQjB5?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb63dfe-1edd-4d2e-7379-08de0291be1c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:30:12.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIyxqNoQcMH1kRttIWTbzhjgWYNjgzGZpVlGP4cU5CNKstQHlwrt1j7ovvxwKEr+3JBE0QViSNrwZo0GS8tQbUR3e7/Qf8FuA6ERjEVTCw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:02 PM, Tony Luck wrote:
> For symmetry with domain_remove_cpu_mon() refactor
> domain_remove_cpu_ctrl() to take an early return when removing
> a CPU does not empty the domain.

These changelog lines are getting shorter and shorter. I do not know if you noticed
but almost all the ABMC changelogs were reformatted during merge to use closer to 80
characters per line, sometimes more. You can avoid that extra churn by ensuring the
changelogs make use of 80 columns. There was a brief exchange about this at 
https://lore.kernel.org/lkml/20250916105447.GCaMlB976WLxHHeNMD@fat_crate.local/

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
