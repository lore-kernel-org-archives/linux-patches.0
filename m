Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933F8182D2D
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100556; cv=fail; b=kF4fv3S8jZZ0absh3GHWdjYYxQGdaRExUsquhasX1Jk4454B31/8X+q2OiS+iNEPHejKOdSL9yaBMcYJvbD82etPSq87Q7Wf1t+J7mOvUw8UVJZ4RANAqE5yTMega04mxcIm+T1T4vdtx4Kutj+oFfH4zNevYHUJ5UwuyCuaj7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100556; c=relaxed/simple;
	bh=NQw+oiRu/pNny1jkeRfMSJxI08ANpGbB2dBWdsQxojo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lnz3LA4BCObowHgTvaSaN+pT0kjxDJEhc2Pbhh5cbcEPc5PN9X29PPss2qQqUvwPxqtpkimDH63hV+YmUPO0ybBMn0GyOXeylXVW5QyhclLYye/x+n3kLkMu6zlo5VWn/IwKl6YPlLZo3ypMEPiHv8TGwsejBwGIlwHNM2W6O+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mg/EmUuO; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mg/EmUuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100554; x=1748636554;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NQw+oiRu/pNny1jkeRfMSJxI08ANpGbB2dBWdsQxojo=;
  b=Mg/EmUuOBEGQz3LOtu0h0temTbBeWpJTmeSOABbIVvW/dNyLEOdniERL
   085TUfcnvT0CnqpH5C6ubEJBVAJr/iCfY4NGXuyjwUvB6JlyhTaXyA/Y0
   aVLhZ+yp+GoTDUVrbiUhMRkrEFKl1iKthii9kzv2OrR7V0uCrO1agB2EV
   +Es6yxZOevLpbXmWqyIiKl9aVYn/3VvH8tcnhcLVxsq0wegTUO6AazN9/
   K7hHBTexpnGwr/kv7VNIyb4g6ud//O2EdoxMMjBcS6JUgteUClAwyAsTC
   eowCUjeKsmkJ6Tm52be1tL84dJKZsTV9AygY0OKkYRENyGsvoKjS/3m6z
   w==;
X-CSE-ConnectionGUID: VMPuvLlkS6SRZjI4PBm5tQ==
X-CSE-MsgGUID: cZ3yuEICRpOTuWx61UYqOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13815181"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13815181"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:22:34 -0700
X-CSE-ConnectionGUID: Pp87GSyITeahBnzq+ImJ5w==
X-CSE-MsgGUID: OvO9maQwRvGNwXC3VXxc+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35877854"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:22:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:22:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:22:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:22:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:22:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc8vvKT9AFt+qzxXySxmW3TJ4UZL0noWrqxmqJYUAHfpe33FlFviCnMJyOQL8uqYSrC1Cuh+hSKdzzpHu2Ayiw8humWYx1FVEt3mVQsJON+xleWzRBnROnrdrY8wvXF4dD4wJEBG5RXebH2WBarZvGg7V0fSdxcT69f+1ROhOWsBbu4Jlbzio13g/XtC/y/N0j54Rw2mX/BwKmk/YP1b6Vyjx5+/6zJudCpgFNe2YbYZe/OrvSR/oaT/7RIGQeDL1mAwxgrxvHtpmkMeE0C/CuOxjufHMTz3xuuAnad05YONcGlwPZufor+ViwMsMj6hbMc0e+e+ACkT6Q1aVlgUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGQcudt0nZ5rk9AObMfdSulkqyMK7/q0CHAzubowFxw=;
 b=fpNVIjwy7z+v4A3/vd4YycEdiJKtLOx5qnW186E2VcN0XwYAIABbqP7kLJSJU6A5p4l67F2Ff31rf9n8X+KSWjnvBfjqmUv8YHTwMj+LXblRzbHaYVpGwmHN6kQPzKNHhZDv+T4Xp/y1AA4wgSceBeeN2N/m+5FNmLbLx7harBAKkiXsIfgBfeRq99TH8z8fd5QGX2bTNDf58N35A9tIyEWUIWDd9zxDs8AnLajX/tVCseaBl3XBovIidoDpBYep01cPndreNdqMMSyV3yfMR7keJtEPpuOWcTI5RCATcYg/zGgs2vgsT0K77EQcazR2OixHnGLVfpujMBAFplvFSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 20:22:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:22:30 +0000
Message-ID: <268305d7-db7e-4369-8dd7-9c9faba210a5@intel.com>
Date: Thu, 30 May 2024 13:22:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 12/20] x86/resctrl: Create Sub-NUMA Cluster (SNC)
 monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:303:8e::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4951:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b11a9b4-d760-4b7d-9bf9-08dc80e63ae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXlRWW1TZUtaREtpeHR6ZXltOGlVWEVNOHV6S2FYZ3BLM2IvWTVmcm1Tb3cr?=
 =?utf-8?B?MzdJNkIvaGZDYlV2dndyczlkbzRmUThDRGQ3RjM2dmNLUU43SkZDbE1UL0xz?=
 =?utf-8?B?MnBobVFFVmlzdkxxdWNCNThPY3Z3SjNOcjhhbHlhY21yZG5VellkeUt1QW5u?=
 =?utf-8?B?WTNEam1YTTJESnp6R3k1ajlVMUR3VitlT2IzL1JCK2FJZzRXN2lBQkFtQThv?=
 =?utf-8?B?dkp0Szl1YXk4WDNVMnB4djcyV2tadm5vN0hOZ0FvQjZlVmVrVEZ3MjVhVisy?=
 =?utf-8?B?MjBqWi8zV2tpR2RKYjl5eVBIa2NWdS9wUW1Yd0Juc2g5Q2NhUnpsbkg3NmMx?=
 =?utf-8?B?eFBHcVVOelVrUml4Z244MkRlM2NjKytmaVNCUE43bDJqRmNKVWdJKzI4cm5l?=
 =?utf-8?B?amRobjdheVBRcE51dnNvcVROK0c4akVDa2RCU3ZqT09wa3JmSjRXc1hmek5t?=
 =?utf-8?B?akdvbkE2ZDhyb2ZoSU5oNFRQdTJKVzhveG5VVm1rRWNLc1ZiZUhIOGNMNzJm?=
 =?utf-8?B?Y04yMGlGUjFBWERINTI2UTZwdTJ2aElZaVBNVTR4cTQ1NzdyL1ZCYVdoc1lo?=
 =?utf-8?B?YmR6VE9tTVg1WDJYQk1yTEFROWNYdVJNYnFJZ0Q3MXVyNTIzKzhJcEFMeS80?=
 =?utf-8?B?Z3c1Qlk0NUFxVjhrbHJIMHRrY2Y1MUNkV0pnTmVBWmtzK3prUTUwb2ZsalQ2?=
 =?utf-8?B?ZXBnKzYyUDlZWjRheXNMRGY1TjhZRGYrNWo5NkE0d2lYY1Yxa242VjlVVy9O?=
 =?utf-8?B?aG1HNHFacHZ2K24zV0dWUWhRTjVUTjNNc25XQlhlRHJMdFI4WWFObnlmbC9T?=
 =?utf-8?B?Y0tWWGpIT1phQ28zSnBxN0libDlEZERTYlBhalk3U2NVVWU2OU1aSXZOeHEw?=
 =?utf-8?B?cEUzNWsvczFBRGpJL2pRTVFuRTJvTHd2MElSZ0kxMHNDZG5MVmdBQ1JrOG4r?=
 =?utf-8?B?SnR3Wko2R21yOUZvbUNrM2NKUmtZeWVmRDRWYUFzVkQ0WHFJMlR6V3dZeW5X?=
 =?utf-8?B?QWg3cWtSZlJSM1M0N2JmTWRJUDFwUFQ4aHhqSm02L0RmVlNCUmZsdUtDdUFO?=
 =?utf-8?B?bVRneUIwY0JZaGRHK1ZnWVlOWGFSZTdjTm9vTmtUeUFVajZ0Yi9pOEFHd3lN?=
 =?utf-8?B?TnBGem5KZXJYcDMxMEFadnp2YTBlRHduVjFJYU9qTzlwdm51V1lrWFRrYkNw?=
 =?utf-8?B?RVNuSzhBMjJ0Vy9iNWM2YjFKNTJudnRqSSs0OGFVVmtTZWRWVlF1VWZwYUx6?=
 =?utf-8?B?YkMwSmMrU3JPMzZNbGZ0Tzc1cFRRUFkyc3BzSlFUTUhMdmpISnRTZTJicHcy?=
 =?utf-8?B?YmtoZWthR0IwR1ZlQ1BIbEFhdlhqQTl0R1l4ZXcyR0c4QU5McVd0RWZqWjEr?=
 =?utf-8?B?M0p0Z0dleXVPc2czWVRVMDFRMG41OW5mdG0vOTJpcHNuNVFSVWdVNGl2cDZF?=
 =?utf-8?B?VDB1SEh6ZUM1dnhlM1d4a2pmSjJxMjkrWVQ4THdRNGU1dXF1cXFvSENnMTUv?=
 =?utf-8?B?RjlxUjRwenJtMEROMHpOSEY1SVNlY2NFdE5qcm9MV0RBaE82YTJIZmV1TEpM?=
 =?utf-8?B?Y251WFhrMlBHamRWZlVVbCtRLzk2ODVoSHRMcC9zUE1reEJLT2RRU3h3dG5v?=
 =?utf-8?B?VzVGclZGc1ptalg4VEJybFYyVzFFSG1INldWMllsdGVTOGZzK1M4RXRLdGFi?=
 =?utf-8?B?b0ZMOElrQzVkV3JJSENrdkFyWENMM0xDZjRGR2dIMGh5NEg0b29RbnpnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2x4OGxiMXAxdS9MajY0TDdpWU0valkzd1lGSjVDNTlYb20reWkxN0ppWEI1?=
 =?utf-8?B?R2oyL1JUcjh1NS9jRUQ1N2wvajlLTFkyNFhkdEhUZHQweDJoYXFaLzNWM01u?=
 =?utf-8?B?dGZkV1htOXNnc3ZwTWZaU3kzY01RcjkzMFU0bVZKMUZOTTRmM0pmZ2NLQ1lR?=
 =?utf-8?B?aDZxc1U5SGpzbWQ0U3RFWWVDZHVxb0NRak1lMlY0NWtSWllZTVBJY09ZcGhi?=
 =?utf-8?B?cERIU3VpWjBobUpvYzhrZGdBRGI0ajVzM1Vlc2p2LzJVU1lsNlBGdFpnM1VJ?=
 =?utf-8?B?Z2xtU0NxQzc0V3E4WVlZZ1o2Q20zMUJ3eGdwOTdOZ0FXRXdoK1JwR2RpNitK?=
 =?utf-8?B?S3VqRnk5VnpyaWUyMlJZcEhNRXNCUTBlT0JCekpEcXUxR1FYOFBHdGJyZStZ?=
 =?utf-8?B?bzljaTg1ZGNoZmdpS1FiaDJudjN6bW8xYzAxMTRZalpycnJKMW96RjRZZmZh?=
 =?utf-8?B?bW1aNWxBbHdXbWJEWndabHlQRkltQThtN01CMlhxMDV0RG1GeFFBb2s3L2hD?=
 =?utf-8?B?WmVZT2hzTTY3c2FPc2hCRGtYeldPYW92T1YwL1ZnSyt3QnN0WlpFYUVjTHBj?=
 =?utf-8?B?bmNGM0RzZWs3eEgyR1dIQTNWNHUxVzZjU3EvYWowTXBCeTYxUDdxTWgrZ1Z4?=
 =?utf-8?B?UG5RNUVlY1ZzaS91N1dhdUhadmpuUEdkMUlhYzkzQVNxWlczWGp5TzNZWXpw?=
 =?utf-8?B?cUtwR0tEb2RGRjFHa2VpU1FsMU9nYlpuN1FIMDdXQmxKLzFNY21qaXEwbkJX?=
 =?utf-8?B?aldoRUpEa3AvMHQ1OTdRMjR1LzdycnJzWHlOZUl3SzJURlRPYjVNK2dmRk81?=
 =?utf-8?B?bkFoY1VBN1RvRlhBaG9mbzJSME90d0p4OFpPWituT3ZGNXRvM3dneWZ0amZq?=
 =?utf-8?B?ZEVybkNCaG5vZ21PMTlTMGFNakpPVXdUVVRXNHJjbVJaVnpvdWtYLzV2R0hh?=
 =?utf-8?B?bmRqd0N3VW1pcHB0bzQ3UHVKN1RxMFZjblpENEloV0ZxV3pPVzBicXRPVW1I?=
 =?utf-8?B?aVVkWTZYZUljRlo5cHd6WVFVaXdCU3p1MkV2ZVF0blBUaEEvMEhQaW9LK01W?=
 =?utf-8?B?SVMxVElJYVRWYmZIVzJCSG91WDJRQ3FoaW9CWTYwQTVIVjhZcXZHZDE1QkFM?=
 =?utf-8?B?UElnWkFWQzN1bnhYYXowWi94N1ZUMEZNdGVLeWNRQXg5QjVyQUdPRFBXOC8x?=
 =?utf-8?B?eXVMWWlnbnd2dXU2UTh0bkRiVWRmYnR2Tk5aUlo5VTg5bllDSEhDeXZqNllM?=
 =?utf-8?B?Kzl6bE9IT3ErcCtXTGVMdk9HMFByYWRTYUlWci9hMmRzRUhDOHpTaSt4TVJH?=
 =?utf-8?B?U0t2cmtiZGppbURldVhvcVNCaGdKdVNWQlNRd1FtYVNpK3c4S3lXNklzbTc5?=
 =?utf-8?B?TXBNaGVvdGZIS0FheUVvdktBMjJxaFBoMzZrUnVhRHNTWkRrZUNrM2JYWnBG?=
 =?utf-8?B?M1RqTU1zM1BBaUZ0dDF4YUIxSmxLTnRYbThTS3FMRm44TWdQY3FvVWVoOWxE?=
 =?utf-8?B?aFlDSU55OHM2eEZtVUIxT1RxNGQvOUV6NzQ3YjJKMWV2eUFGdnplOUZZdDEv?=
 =?utf-8?B?TUJMTVBHbi9WN3VDT0lSNDdacWJUbmRrQ0toQWo2RktWNzJSNnhjSWpCMzh6?=
 =?utf-8?B?VFFKYVJRNS9kU3BQQzdXS1kvMEhabWhKV2hRNkNlUU9zeXRUMmtOaEZEVVR4?=
 =?utf-8?B?UGhTZGlmczZNV2hFU2o2Y0gzNjFKQ2VSa21PL2ZjK1VuVXhqUXY4NGEzUzl0?=
 =?utf-8?B?R0h3RlhPQWpRN3MxT2tRbjdEOTAydzhTOXZ6TE5kQXFGUmlyRXN3cVF5V3Rv?=
 =?utf-8?B?RFE2SXFOVVBralNvNE5GWHZkQm5wU3I3R1h3MzFpMGQwQUFGU0xlUkxxNU42?=
 =?utf-8?B?blNQWWN2Qmhxc1VydFhZbDFBa2FyL3hZZmVPMHUzQ241eWg3NFIvcDZzejRm?=
 =?utf-8?B?ZFFZVmZ6ZUlENXdLT1FFcHpzVm5GN2V0VU1FSnJkeWdHRUJPZk14aS91cDdB?=
 =?utf-8?B?RlBGUndraTUzamM4cEFsMkhJc2VGNnlQMUoxNTZIVFkvanhybGhoUmRXVHIw?=
 =?utf-8?B?R01hVFkrQkJTTDcwdVMxaXpkRG9qRUwwRk1ZTk1XYW15WVcxa3lRdGtjOGRK?=
 =?utf-8?B?ZTF2bCt1amJVQVRJS1Z2OC9TZWNNQnRsUzRBT2w0SVZrWHlJWkxMM3FiSk1k?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b11a9b4-d760-4b7d-9bf9-08dc80e63ae0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:22:29.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATB1CR2+JCmTVpVTwgsnzpF3cHossyLtLF3DO3I7wkm0sOcNvybs2ydQr2bmk5IhrkilvlTfurNEZJ2M8RQSo+19s0msKz0Eu6wHs/17ThI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:19 PM, Tony Luck wrote:
> When SNC mode is enabled, create subdirectories and files to monitor
> at the SNC node granularity. Monitor files at the L3 granularity are
> tagged with a "sum" attribute to indicate that all SNC nodes sharing
> an L3 cache should be read and summed to provide the result to the
> user.

What does "all SNC nodes sharing an L3 cache should be read and summed" mean?

> 
> Note that the "domid" field for files that must sum across SNC domains
> has the L3 cache instance id, while non-summing files use the domain id.
> 
> Also the "sum" files do not need to make a call to mon_event_read() to

Drop "Also" - it is a red flag that a new patch is needed.

> initialize the MBM counters. This will be handled by initializing the
> individual SNC nodes that share the L3.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 53 ++++++++++++++++++--------
>   1 file changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index dd386ad9458a..6a5c35a176d5 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3026,7 +3026,8 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   }
>   
>   static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> -			     struct rdt_resource *r, struct rdtgroup *prgrp)
> +			     struct rdt_resource *r, struct rdtgroup *prgrp,
> +			     bool do_sum)
>   {
>   	union mon_data_bits priv;
>   	struct mon_evt *mevt;
> @@ -3037,15 +3038,18 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   		return -EPERM;
>   
>   	priv.u.rid = r->rid;
> -	priv.u.domid = d->hdr.id;
> +	priv.u.domid = do_sum ? d->ci->id : d->hdr.id;
> +	priv.u.sum = do_sum;
>   	list_for_each_entry(mevt, &r->evt_list, list) {
>   		priv.u.evtid = mevt->evtid;
>   		ret = mon_addfile(kn, mevt->name, priv.priv);
>   		if (ret)
>   			return ret;
>   
> -		if (is_mbm_event(mevt->evtid))
> +		if (!do_sum && is_mbm_event(mevt->evtid)) {
> +			rr.sumdomains = 0;
>   			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
> +		}
>   	}
>   
>   	return 0;
> @@ -3055,23 +3059,42 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   				struct rdt_mon_domain *d,
>   				struct rdt_resource *r, struct rdtgroup *prgrp)
>   {
> -	struct kernfs_node *kn;
> +	struct kernfs_node *kn, *ckn;
>   	char name[32];
> +	bool snc_mode;
>   	int ret;
>   
> -	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
> -	/* create the directory */
> -	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> -	if (IS_ERR(kn))
> -		return PTR_ERR(kn);
> +	snc_mode = r->mon_scope != RESCTRL_L3_CACHE;
> +	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);

This new kernfs_find_and_get_ns() call takes a reference on the
kernfs_node before it is returned. Where is that new reference
released or why is it ok not to release the reference?

> +	if (!kn) {
> +		/* create the directory */

At this point this comment is not useful.

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
> +		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		if (ret)
> +			goto out_destroy;
> +	}
>   
> -	ret = mon_add_all_files(kn, d, r, prgrp);
> -	if (ret)
> -		goto out_destroy;
> +	if (snc_mode) {
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
>   	kernfs_activate(kn);
>   	return 0;

Reinette
