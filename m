Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8C3DDC3
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759536646; cv=fail; b=BBbEbwyFUNNAoARtyOsB2f0ws2GCH/pwlrVubwcl/LyXZCU3qnTyqGApD1F/wkzw63jnvYoJltnI4mEoQaTu+TGX6BtZ7i7ixl4SdqkEBP7LfBMcawtfVZ41iCmDT8DBzc/qBMibooJcxo77wMVCtkCQwR4FPZ3lL1Ytjljo/Dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759536646; c=relaxed/simple;
	bh=b5obwMaMXTe4G1aorT4tJ1lzTo/ypUY2APlyO7m+dcw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eeUEhjRVHTH+mubMexqcEvYB4CW43b8i9+Fyd+91xZ59OFdKHP2RJPpji/V7OTRUY6xcXyhQ4ucL63wl8RrNZGDmkZFLjGtE21YU8woV+XLNn2CwZBqMVkcBmQOTksiltaXrBrxrtwXy/MZrZ743Af2EqdgI+YVv1vefjf+H1PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HuVPNX5y; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HuVPNX5y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759536645; x=1791072645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b5obwMaMXTe4G1aorT4tJ1lzTo/ypUY2APlyO7m+dcw=;
  b=HuVPNX5y/p+RwOa8dFDuyv7phWv7YGkGHkKvZ4RqilB7dOw/RcwDLG5M
   Z91/8fLhhEeM6WJVrJqihCe66l3W7ibp7TpslEvSKzoGTZq+XGlxJDP4u
   kYHCbygXV8EEf8PM8kp6towOitLmVEruGVD/0r42T780FyRHuO+jHqviG
   MwRwWhJ/3xHqFvVvIosrpJkPPP0Qc28s+b8NGcX5rAKmTXk4qoE2pel6j
   Jaj/ub48dmCFbAY/lHX8e51t1Bsi3OAhS3OcI1iyQUoCA3GummLC9N03N
   Rkud7zaL7rUFnf4hJgZX4HK5XZdkzv7pOjThEuW8FYsFCR0okHWTPnrP5
   w==;
X-CSE-ConnectionGUID: FAzlAWEUSw64xQbhTVZdyw==
X-CSE-MsgGUID: fNfcXD81QM6lmJ4xj3JsYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73173715"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="73173715"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:10:44 -0700
X-CSE-ConnectionGUID: Id14XI8hSAKMRfXtcXhHUg==
X-CSE-MsgGUID: gyoNAsWfRZSr7ZsY3VYeUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179329091"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:10:44 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:10:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:10:43 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.34)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:10:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pprAhlFSHMf7lVfSBTSld3nC455Rflr57xSsjHXW8a9eVp3j/4cjLvvzwcf7uUkx28dnFaGz9BR/8G7hnCR89ahtz5vbGMWAn8vRaDtEFWOy+P02xUvgT/RS17xA1bZOhcMlqIEBhO827TUIkzImZbIhBVEejcmq7eEcr4ZUTofcgk359UlPVPytvgeuEgGlXEShh2i69/Hnmy9JPutRrRPNGgJKxytFY4YU3lKBsnwfeBHWN/K5FLtlAX20CIYmhr3aFl1yVTj+Aqva5GcO8QWaZ3m0cygSKNmke9MAwaP7p85wKYFOqZxIL51VFxzvQbNuuhBVM55vWv+QZj+bAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2j53FeJDUWeL3kw3PhJoJmfmd4imzMTtdqBah82dcLk=;
 b=QTMaxv3UHTnUGWHyTFy/nW9AiKvwtaIL1qk1aDnkqN9sJX1UlV2i+hC/jmvwPss6yJkxH5BMIZAV8yOWlYHZJGB34bwZWPeS7MzhXBMDTvEwueq6GJDL5DrELSjBvCcZY9Y6Pl9vVwgZ3m4IxAUil/87fvzYDbMahHLCQCi6b2YSSesmHdI0UH/g6LoFqrUvE5V1m4sS6uMzI3vSEA6WlIkN1ad7vOvPng/n3XoisPTf4NsiZ1/0M8BvnSgvKJOjmvXibCl4oLXk0u2mRyd1BadgHtn6CAQGFzRKDkl4M2xxmYnqvAHgo5cnQpCdzxSalcV0/WLy/YECG1l/yQCBlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Sat, 4 Oct
 2025 00:10:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:10:37 +0000
Message-ID: <49d86b88-f785-4540-9806-b5d635e2b618@intel.com>
Date: Fri, 3 Oct 2025 17:10:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 25/31] fs,x86/resctrl: Compute number of RMIDs as
 minimum across resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0221.namprd04.prod.outlook.com
 (2603:10b6:303:87::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: d7611456-a747-48ff-aac8-08de02da71c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3htak9EUzc5dUJQdHg4aCtvTHlWdlBVTEFhSlpOcUw3KzBRSVdHM3U2WjZ5?=
 =?utf-8?B?UTZiUlUycmw3ZzJwUlNYSHU0MFNHTGRBY2phOUl6L1Q2dFBVV3NnQTFnTW10?=
 =?utf-8?B?NTRyTzNoMDNVaStlcTR4cW1ST2JKdWErUjIwRnM2RnlBdFdWSlF1ZXVPNkZv?=
 =?utf-8?B?VGJwZENkTEFmNFQ3Q2hNT2RMV1VCTmY2ZXBMWTVjWkZqMjNNbDFDQmtNZXIz?=
 =?utf-8?B?YmpqZWdPTXEwY1QzMW4yK1haMXpsMXUwWE1qS1FRV3AveDRJbWJVNm8xZVRL?=
 =?utf-8?B?YW1HSWFwRHMwN2REWTJOQVFFZFg2VFRuR3JqVzdZTVFYV2lPdGJhbXZkTXZi?=
 =?utf-8?B?SGJiZGNBK0h5dnpEamxCRjNra2puY1F0WXB0NU5obE5wQnMxc2hYUnVMU2tT?=
 =?utf-8?B?RmE0Mk1jZGk5Y1E1RVJndGVRb01zb2FtNk0xc1ZLMG42UzVwM295VWYrWGd1?=
 =?utf-8?B?a09mZmE3OXRjMHJTUWI3QnIvQ1RON2JaaFVIemJtQy8zRVR1ZXh4SksxRCs5?=
 =?utf-8?B?Um5pZk9rTUhkQ1lmdzloMy9SdXZsaUFtNWk4cGNJb1ppaHBlTjAvYTRLb3ln?=
 =?utf-8?B?Q2FyUlNRdFFyN0FSdGpSK1RiY1llWk0zc3N2Tm9YZm9USGF0dWlYNVlqcUtE?=
 =?utf-8?B?T3pFN1pNV0tnRDRnVTZSMjMrSVBIdWUveDFyM3VVeXdySk5Ub2V3VW9uMGoz?=
 =?utf-8?B?ZklhSnNvK0NLeDd4UTduaTJJY3p2L2hMRFJBRmRITGRleEkwMktDNGVYeFY5?=
 =?utf-8?B?MjJLWEw5OUU2SFRZaGYvSzViWDRGM2EwMFFXZ0x3YzhsTUIrN1QyeFFxZWNm?=
 =?utf-8?B?eU5qc1RvOGpWemczV05nc25HSjlYOTFnTW55VXVNRktxS3REYVB0VmNTdDNy?=
 =?utf-8?B?ajJobWQxc3QyVWtqcW9HOWsyZkRCbUMrd1NSZ3FrTkZqS2wwS1dTTTdUeGlP?=
 =?utf-8?B?bTVYd2ltSllKdkhkZk1kV2pMOFhndjFReHBKejNPbnVOckZaaG1ZaEdpaC9Y?=
 =?utf-8?B?SHM0Y0FnQm5FQnc1YzJ4SjhjWVUyZ01KSmFod1BFdUc1QmdZWFBHdUx4WHUr?=
 =?utf-8?B?UkRUbitJVDNlT002MTE1anhtMkM2NTFCZVYrbjdsNk82S1FrV1FqbzQrYU1R?=
 =?utf-8?B?VDNoRkF1ekpaMWJxTFhpSFlPeDNZclpTZ0ZLUkxHQzF5eFNqUXRNNHNCRjVE?=
 =?utf-8?B?Tm5WRXl2c0dnK0lmM0NPZFZ6bVdFeEx5a1JxZjVQNGQ0dXVERURjQlh5alFq?=
 =?utf-8?B?aXVkZTcvaDRpaFRJazZLWit3RjMyY1RIbmUrSzRScWNYVVBpUHNYWUF4UGJx?=
 =?utf-8?B?ZXZnbjV5WENsRHROZ2VRMjBZU3lJZDlkbVYzY2hDU1duWHNNdjYwZ2pMdTk4?=
 =?utf-8?B?S0UwNGFjMTdrdmRxWTJ5TjVKV3F6MVBVOUdxZjVlRFI1alh3a2pWWnB3Rll4?=
 =?utf-8?B?ZlRwVC91WFRYRkpTamlvTFB0d0hZNnIwT2pzM1A1d0d5Ylo3Qlo2YWZOQnhl?=
 =?utf-8?B?NEc0TVJwbUZKZXovelQ4VmNydFNBWkxKdW5wTHdWWVpsNkk3RndTY01TYXNB?=
 =?utf-8?B?TThmb2hNdW9hOWxZWEtGRkphd0hKRjZkVU9wN2lpdU1BNk00RklEb0FvSEx4?=
 =?utf-8?B?ZmNHOFBVeERmbkF5NFBHd2daS09EN1VhRndPWXUrSTM2Szl5d1hwQ01pK0hr?=
 =?utf-8?B?ZW1DY2s2dmE1Y3NMK1VjdU9CNzZCNHUxdjVkRGZqVkZwZURheHVvbnNEa3ZR?=
 =?utf-8?B?eTlWcDhuNnl5NXNFcnRQNVd3V3QxbjMyWFU5MXFmT1RYYTJpTlROS2NXMGZR?=
 =?utf-8?B?R05ma3doSDYzM3VFekQ5WWh6b1U2VDI2M2RUMTAzWGg5RmFwNEZ0MXBHMzRz?=
 =?utf-8?B?ZkNjK0tBbHdDcExZK1ZseU1EYXBMNGNtdlFUemVxZEVTc2dpcFdJckgxdkNK?=
 =?utf-8?Q?vGZ778oe5gwqMXYDk9wGsOxjoVBSuSLv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmY1REVIdFVvNmdUb0JtbVN5ZDQxN09HZVFIaS9vKzBpYlQwbldZSjljUTgx?=
 =?utf-8?B?WnZLOHBHaDAwblJYMldNMWJDZm1qZXhOU3BwYWpqb2hrbFRlRFpXR0ZWUmhZ?=
 =?utf-8?B?RnBwRzFlYjZ4bFlOcGVJaE9jT1F3RGlNanA3VXg2K0crMTFxaUN3c2hmSEJB?=
 =?utf-8?B?eUtXTG1kRytsTzBjTGtQVW9uZkVwemdoZ25JVGsxWHJTZ0lWSC9yNlhsK2x1?=
 =?utf-8?B?SXFGRzdIMi9tUXk1SEc2OFY2aVJnZHhoS2lBS0sya2lheUd5YWF2aFVIRWts?=
 =?utf-8?B?UjR0SXV6c1R4QlNBZTIwVE5PdEhTWjk0L3hrSm54RDhmckg4SWk1Tk9uaVBI?=
 =?utf-8?B?d2wwMVRtbnFSQ1lDY1BTalNHd3AzZktTV1hZZGdEaWRtMkFkZmxrK0w3TlVa?=
 =?utf-8?B?NjRFUjl4T1VvUUYxbjJETEVsRzVxamxuWkx4czAvTmpFbUtLM3AzNkcrdW1M?=
 =?utf-8?B?SjYyZ2lZdmJHU2dVbUwwWW8rUittb0x6Z1BTNHpqRG9Gb2VhMkpwNnFFZ3dY?=
 =?utf-8?B?eDd6S3Mxb21pRGxNNUtzUU41UUUvN1VybW5valRMYk9yYTl4VG52WnQ0U2JR?=
 =?utf-8?B?eHBzcnZZR0lpc3FoVzVKamJNb3grcjhtUElwNkRvUXVoTmxpa1JERkhhUFlC?=
 =?utf-8?B?c2RITEV6OE5aWTExVWZpa21hcStxaU1va1NiQVcxRXdsQWJYTit4eXZDTk9B?=
 =?utf-8?B?NEtOaTU1bGdtZTcrNlFsOEYvNEJtaGZpUDJDa3pLL00weUZCM0N4ZDBXM3Vl?=
 =?utf-8?B?N3BTVzBLdWpJL3k5RVk2eTBxTnhUdVdDcndsdVJLa1ozMjRiSm5mNVlDM2lO?=
 =?utf-8?B?bjNIK0w5SDF4YUlRa1FnNlpUL1Y1aHhFcm50Z1BCYTBoT2R1VTdnc2E1VGdl?=
 =?utf-8?B?VlJpbHZ2dm9aYTdHREdvUEJvMGM3NHN1dEZ1d3JJRFZMbGJyZ0w2TXRvckRK?=
 =?utf-8?B?US82bXBEZ2lhY0pRS0xicmJtNTg0TGJBRE55Qk5tWi9ISjJCdlhVV3dmUHlp?=
 =?utf-8?B?VjB5aVdjczJLc2pHVVZVSlNhMVIyUnVpUE9PeUoyU3ZHR3gwakE1ZFlsNHcr?=
 =?utf-8?B?YUxqdG1MUGJieDBKTDkxVFpjbFkwNFpvd041OVFZeHZkQ203U1ZqdXVKazZK?=
 =?utf-8?B?YjBDb2RocmNIZlFvcTNFT2RDWndCUHc0RlNwRDdTbjVJWEFYVmxTWnV0OU4v?=
 =?utf-8?B?UFhDbHB2ZzdYL1I4b1g2cG5EckpFVmwrVDlCOGlQUGtTOS9BL2R6TGRsK0w2?=
 =?utf-8?B?cGhBZU1XalR4aWoxRktEU3BBcFVHakZmekk2cU5DS2xIOG8yemF5NGx4VGhv?=
 =?utf-8?B?cUZHR1prWFc4MWx5c2xaVUVKajl3Sll5MERBWTNZbncvK2JKdnU3Y2owa1lP?=
 =?utf-8?B?T3BiQ0ZPQURJMWY2bGp3MmJhbG1HRDVLUDBNZVpXWmtoR3FTRytRdy9ON0dR?=
 =?utf-8?B?NENJS0E1SzN6VGVTZUQ5MFhwWVh6RGQ4bDFSbXVlcFFMaGJvWGUwa0dkUmta?=
 =?utf-8?B?eEFDeDhiVVFxTG55Y1BJOHcrY0R0YURxaFVvbkNDWlppS3VOYmlhZmxCSlh6?=
 =?utf-8?B?dlArMGFXa3lXWVFSNEFCSWZ0SFJLNzZXQm5YMFhBcXpiZTc5NlZYRDVMbHp3?=
 =?utf-8?B?KzJucGlSQzNFdFRzb2MxNVBrQXNJSFZQTXF1Z3N0cXBqMVk3bFVJeUgzcFJL?=
 =?utf-8?B?M21OVFVsK0lrUnM4WnY3ZStRcFBDTmdSRzIwdzlEZmtNc1JoNkpXZk5pMFkx?=
 =?utf-8?B?TmlIVlRmSmVvRmcreE12M28ydTJBMFI3akwzSStKL1MwNDBsK1VTejlkYU92?=
 =?utf-8?B?V0gzazVvSTc5SWpBY3NGZEdqSlpUejFtcVc4RUNpRmg0MHR5SVRoQll1T29T?=
 =?utf-8?B?QisvVXBtbk5VWUxncCthOWZiSXpDV0c4b0VMNDFtdnp4RWR6eERBRVhUWUlm?=
 =?utf-8?B?dHZpM1lPUTFBa1V3VmRhR2ZuZmwyYm9JVy9Sdk1KaDJoZWpmRkI0bmZpMXU0?=
 =?utf-8?B?a1NxVStraUVQZUw2SHd1dlRnYXpMdHo2VVhHZUdaTUMraVd2QmkweDQrQVJs?=
 =?utf-8?B?R2J5bW5KYlFFc0xPSVBpOFdyTDlnbTJXTDBXQ2JTUUNnUnNRVFRGZGRHZUJI?=
 =?utf-8?B?a2VhcDBUQnU1c2x6UUNUV0lnWjgxeHgzRytLN0J2eWFBemp3S3cvellkU2xZ?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7611456-a747-48ff-aac8-08de02da71c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:10:36.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g30JP0VoM9yVJVzxYugELmEuLZAJfvp8a87ev9NUDOHjStsMuOCKcr0zOH/WQ/MaaRGkY8jT/o0aT1Ej3BAIyqtWIyAf+pOm8toxSVXfJrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com

Hi Tony,

Please use a consistent subject prefix (x86,fs/resctrl) when patch changes both arch
and fs code.

On 9/25/25 1:03 PM, Tony Luck wrote:
> resctrl assumes that only the L3 resource supports monitor events, so
> it simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as
> the system's number of RMIDs.
> 
> The addition of telemetry events in a different resource breaks that
> assumption.
> 
> Compute the number of available RMIDs as the minimum value across
> all mon_capable resources (analogous to how the number of CLOSIDs
> is computed across alloc_capable resources).
> 
> Note that mount time enumeration of the telemetry resource means that
> this number can be reduced. If this happens, then some memory will
> be wasted as the allocations for rdt_l3_mon_domain::mbm_states[] and
> rdt_l3_mon_domain::rmid_busy_llc created during resctrl initialization
> will be larger than needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

