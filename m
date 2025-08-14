Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691AA279DAA
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207762; cv=fail; b=CSNjKmWg8HtKXITHPqWHdeH2ZkRC2FfQ6D5LLsl9U1lSxjJJYc3QazIApalklr0nqFJmW5CSXSMRASQkx9yEvUrvwEsa5friagxumqd8Eo1nL48Zvh3KMiRP+CXHCA/qby1zIiZyR8r7mWMN1XAePhbmFYYbHOg8kUQTUKF5Dwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207762; c=relaxed/simple;
	bh=GcG6fHnkUpAjNe/2OdEUdo4rT/BHRygSpbBJNUf6VDA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SuoMORkzk/GT+XRQ0914Pw8yrIrd6mH9eSxa9a5eRWWM/JVmp7HSVYbJnmbJlhoDhF4CAhhtn2rm+fHimODezodpEVmOQsIzHL6lSa5cOBc/iHFSfKpqlDbPiVPPEdV8EMs6HJG3t7he/5ziJItv0MHIUrAM9umdsIueCvk3JiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5fJ/+Xt; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5fJ/+Xt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207761; x=1786743761;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GcG6fHnkUpAjNe/2OdEUdo4rT/BHRygSpbBJNUf6VDA=;
  b=Q5fJ/+XteYKHtmJVDQqSN68bwyHtEXBWBZ9jF8FUBrnZWXQhhStiViEU
   5UrlfcWhcPxnqcv+/TRMAb8idaEBf0LLxJ1m42s4cMMqv2bxJFzGMmwIa
   dC/EzLfAJh/IvOaAJLHbMB3NI1sGOGW6SxZ8v4mkdKMNJRYs7iJnqEKjY
   WiOf41WkEwd6ShF3apgzxfdC7FjTdInosnL6oiWQm3C6TAEw6KsMdSczb
   uwCZrSIYeLo2GMFR/AStzgD0IJX6eT84nf1bdcgKJqZTJA2bzjMFwWvvC
   H/gbjZbKQIjZo66NYlho42oDlkc8ZWzV0PcxUkVIxxUo/OYSPA/wk0pZe
   w==;
X-CSE-ConnectionGUID: s61/eMD/TL6QZLFot9D0lA==
X-CSE-MsgGUID: Z09EzWC7TKK+jDqiHgKt7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="80117071"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="80117071"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:42:40 -0700
X-CSE-ConnectionGUID: eKcEfNNiRmKja+yzuzs+QQ==
X-CSE-MsgGUID: iKqYxVLDRC6xYeeDtUdLWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167229369"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:42:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:42:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:42:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:42:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bCf9IBSP3Qci2Ss8p39mm8qVk6xgyTLiBXmMwGaqZEX/kOpXQki3UlC4Sy1hf80wYq3roLkddJF3BhQ7Je877Bh25Fulxn3i58DLPDKvhLYxyiQGrfzGrUkVCTlJIiuS4aSiJI9n2GIUMxoWtDQOlNeQU3PVHguCDmP/D1DVEisJ0pRf/BCP2E3nOB2gkG6bVZzzTlHhSCwFU7aq8Rgqk9dEtSafXqK5vTfSJTm6pEme7k0AOFJb4IppDkiE6d/EzYnnykwGhyD+Z4tVMsLghbiYnnq1wT2y57Ntp6+D2m0C4OT8l0cpeaVFiUAS09VAqfaqEHToI2Jl/tTAmyOc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WHOyyG2JhVofTXH0hcNNYqlTuKOgZjNl48j4L5soQ4=;
 b=TvZMAVq28X/jJe9Dy0t+0GF61gzZTZRLIcxr4pHCdKALyXRVco3Y3t2Osi0TSXK/DxmR7VN3//9f43fH+ZdHzjvoGY7q7B7If9Uz2H1LGwobs/SXN2fpon0KUVRDNeM1j3gthY8Mn87AdA2DSQAieOJR+yIBR5rAtk93xSE192JcBTHy69VMAVnYTkERGIMYxbY1SAEQ1o8k7tAPuwGH0ADFO9xytPu1y63lyohEbuuNEEP+Pyfqqqc07GM0DXN6a/+0Eu72MlsQoPBNC0B4eQzMUNRGW3p+f5iPN6EkwxMQLiVz37h4pQcsUg9jLnSW6xAXweVYGAUBJs1WXJmB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB8988.namprd11.prod.outlook.com (2603:10b6:208:57d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 21:42:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:42:36 +0000
Message-ID: <91cacf85-38a0-4951-a6c8-c538db93ab0f@intel.com>
Date: Thu, 14 Aug 2025 14:42:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 19/32] x86/resctrl: Complete telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0069.namprd16.prod.outlook.com
 (2603:10b6:907:1::46) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB8988:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ed6a66-79e4-4022-33c1-08dddb7b7c1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TG5WUWlFRVpZNm0rZjRlRWs0NGpyVTZza3c5WlBBam1iTnVXT2l4VGdHR05Q?=
 =?utf-8?B?WkRuVmxSRjRSVDdBRDN0c2kreTY3d1BhZlU1SEdJdDZSMzMwQjFYOVY3VlZ3?=
 =?utf-8?B?VWlWVndzdVdNM3JVT2x4anZrSUFva0tWOTdKbGNMTXZhNW84UHBEREY1bWE1?=
 =?utf-8?B?UkhRTjlOcmNSSlZwTVlJTnpyTHFuK1pmOW5jSzc0MXdMWnlGbnAxMUQ2SVNn?=
 =?utf-8?B?YXNxaERzNXd0NHJnRmRlWW56ZHNDU09xOEZQL0JlUHdDSkZRN05oWGx6bEk0?=
 =?utf-8?B?ODl5TFk4UkphYnlCS1pJdGNqa0oyNVMrOHdMeFhUZUovMVUra3ZiZHRiTVRU?=
 =?utf-8?B?Yy9EZWZ5dUxpakpSenFkang3cUJ0cHVVanlWbUN6Nm1Zalh2Y0dPQ1BkWC9F?=
 =?utf-8?B?cFJwMHU4L3ZncWlDa3NtL0wyYndtQVpXSnVrOHVoNng0MzJrWFRzd3ZURGJt?=
 =?utf-8?B?K0pDUGlqUUNLaW14NGEvMjhwN3lwd3hNOGk3VWZWZDZEMzZRTWZ4ay9IY3V6?=
 =?utf-8?B?RDlkWGVIL3FhWHl0eTZjUlBhQTNCbjAvcGcyMGJ5T2xDRS9rU3A5aHUrNElw?=
 =?utf-8?B?TTkyTDV1cXhGK0JVMXBiL3BQZ2E5RDg1Kzh0WjBBNTA3OVc1SmpDTkxHQkJV?=
 =?utf-8?B?dHZ6eVJCUnV5VHNtd2hlaU5kdW0vTEw2Uk1QU1A2V3BCcDBsQlZqWXlrSFQ4?=
 =?utf-8?B?S1NFVy9Zbm5NT2g2bVJ4OTdtd2dqbU5IQzRyZlZDbVB3cnhVYUdranZQcC9r?=
 =?utf-8?B?blFxcGFNL2VMdnNqUGF3WnBpRXEwMXBXN0hnRlFnVGg2dmljR1ppOVArKyt1?=
 =?utf-8?B?RzBzZHZ4VW10VzJTcUxZUkt5eTE1NllIVk15c2RxeDhnV2lES3lkbmZzbm5i?=
 =?utf-8?B?TUtJclRwY3VkWmNVQVJYdEtOVjl1SWFUWFNtVHM4Vzd5akhJNnVWS2pyZnNY?=
 =?utf-8?B?VWhQR3pUZE1vY0RrbnJBNnRsYURUOC9rZ3kzd1N0a0kyUDFOZWFBSEhoaWdG?=
 =?utf-8?B?L0FLbXZoVzFQeEtLQzYzbm42ZitwNmpET1VmVzdvVzlZU1lqTlJMUTl3YXhX?=
 =?utf-8?B?bGt5U05lMEs0MU5iMzcyL1pCVmRWWHQxMFkvRGRWdUdLenkxWXlsU3o4OWpV?=
 =?utf-8?B?RitnOGZCR1Y5eUxBY083OVdHVlFxSjU4RXA5L0ZCbG16TkVqTjA0K2NZT3hj?=
 =?utf-8?B?Y2ZHTlJxWTBaM0lTYzdhL3V1K1lUVVBqTEpVSFo5ZEU2UGJqa0pseVdKR1ZP?=
 =?utf-8?B?VDNLSGpaTXlSUndQQUdyaFk0M3h3bDhUV0VVTFZSeHE5QURIbjh2QXFxaW1Z?=
 =?utf-8?B?MlZDZ21HVXVDT1N4aVNWSlpUUjVwMmpJWkZrYW41alEyMDlKY0Y4dHlJYU15?=
 =?utf-8?B?Y3NoT2lFVlRDOUZUb3RwdTl6NmpUS1E5dXVEd2hCZXBMQUJRcitnV2MydGVB?=
 =?utf-8?B?QmQyNy9pNXVwL0NDNUlQTUMrZDdEdG5NbkRYNkdWWXpaeDM1aTloS3ZDck5o?=
 =?utf-8?B?aEd1Q1JrNVQveEcvZ2VPdnVQa0xHRkdTelV0ZzV4MWo5blR6dk1HQnJoTVQr?=
 =?utf-8?B?TXVpbm9XR2lINHZETkFjaytnbWpZeHdsNDhyaWlySHViUEpsdk9vVEE4ZzAx?=
 =?utf-8?B?N3dWT2pVUTBqK2dMLzFIaGJ1WHAyVlAvdzRBSGhKVGJoNW9WRkRQNWw1eG5C?=
 =?utf-8?B?NlljSFVaOStJbktQY2tnY0VHU0hBaEREb3EzekZjcDFjNU45eENpZlFCN0t5?=
 =?utf-8?B?bHBHNjdncmRnei9qL0lwbGFQNlo1WG9ZWTJzTGFRRGw1MVhEWCt4bjl4MmVF?=
 =?utf-8?B?NmJ0aEM4ajNrUVM5dVdqbzBXZzVhdXdQR2d6YjQwblhHL2lZcncwaWpQYW1v?=
 =?utf-8?B?cjgzelhuSXBNWHE5ZTk5RGVuTU83U29ndU9odkdqN3NmS2c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnovUmY0eEJLcmdtZHlvKzJvZ2FnQ29iYVczeGRpOXRPUTlhQ0pMUXJtS1Zw?=
 =?utf-8?B?eTN6cTZJN3J1dTRPc1BHY3M2OHkyZU43ZkJDemN0ZTZGanAzb3BCeXJwUysx?=
 =?utf-8?B?M2ZQNEtQMDFRUlc3WXp1dFQ4a21aY0tDR2tKZnJKZWExT2Z4UWRremhYRjBE?=
 =?utf-8?B?VmdmZTFiNk5Pb0ZyNnFET2Rocmk5Vm9FS29VZkw4cVV3bDJlSzEyVWlna21Q?=
 =?utf-8?B?Y1NpNHY1alBRU2FJaEl4eXZIVEFGU0crTkNjMndhQVN2cXhFSXBSZDMxWnRr?=
 =?utf-8?B?V1BvUDcrS3JweUpuejJ0RUs5TkRrOWdHNFBvU2ZJdWFTbVBTMk5sSDUraTZu?=
 =?utf-8?B?aStHZXE2cU4rYlROT0RhbVd6U2RSb1RmQ0x1MFRVSlFQRmRRVkcwVWdnQUp0?=
 =?utf-8?B?dElIYWcvSFFwRENNazFGY1FFQ0pXY1hDaTJIVkY5bzFOdW9nbjE0TDZ5NTlp?=
 =?utf-8?B?eUdPMGRMczZiL1A0QkZtTGExdHNsdko2c3BmcndnNnBVZ0xYRGdGbkEyMHRh?=
 =?utf-8?B?cEFKdjZ2Uk54ZTRpcHhyYlpPRjZ2RWJhdnV4YXNpSWYwY0dCZVhTMTVUZ1Av?=
 =?utf-8?B?NEttNXh2UVViWUJNK1B6elFvL1crdDBJL0I4UGNZTkVOK3hXdEUrd3YwSDJv?=
 =?utf-8?B?SEliUHY1R2ViS2dnRHplUjVIVjZCU0R0WndLZHM5NnFpRjFhN1M1UHV5QmN3?=
 =?utf-8?B?bFNXOFdjcDRsT1VTZTlaN010MEV4cmsvbnRjM0U0Y3lMUEN3a09FeDdhT2h3?=
 =?utf-8?B?ak1weGFPRjVOOVlSZTZna1FtM25QQzlrWWRZUythaEJEL3E2T1N0aHFRd2FW?=
 =?utf-8?B?ei9KMHNOb3dVd2VPOXN5N2dYOHRRMGpPd2RwRytidjJMTDlka3lPaHEwYXJI?=
 =?utf-8?B?QTVuVXY0WllpckZqUStIZVY4SVhEaS93ZkxDSXlCMlNkWnovNk1XblQ1SFkx?=
 =?utf-8?B?RDU5Y2VMSXA3ajBjSXRQbXZ6RjNiNFI0RjU5WG00b0NKcGFUUjlSQkp4Smdh?=
 =?utf-8?B?eWdpeXgxZ3dveEtMQ0dKMm9sd3p2WU90eDJ1YnhYTitPUWxrejBkZ1lzQmIy?=
 =?utf-8?B?ZURvNzBkeHBKUkFiQWZibmd0a2puWkNJNUVYTWVxc0RnRzlIeFk4SXhHK0pR?=
 =?utf-8?B?ZENVcGNPeER6ZENScGxWcDlMQUQ1ejN6bDhjcTNrQy9Hd3FBUm5PSXo5cU1m?=
 =?utf-8?B?NitvVmRGYk5RejR4Y1ZWem4wWnJGbnlvWFJWbUJjTXlqamRKTVFsNWpZOEpG?=
 =?utf-8?B?QmFGeVpzSEZDTFJPSWh5a3BzZG1rcklxcElPWmZQMjQvWmR1R1NvNk1HYXNw?=
 =?utf-8?B?dHcxV0p1a2VQbnZxS2hraE1rTy90L3laYWdlNmxiMHhFZW03U28zekJOOGsr?=
 =?utf-8?B?OUU3c2REcHlRRlVicVN5eVkwbWlmVUxZVGdNSk9QUDU3eTQ1MjAzNDJwOXFR?=
 =?utf-8?B?eEM2eURVQnE4a0IranBYQmk1cG5HSTJIM1lTZWl6dWtKa2owdWQ0WWdvby9D?=
 =?utf-8?B?bDJIalJlcm1EQ2s2cWVlbTVGc3A3by9ta3pKem5xcnJxVVg3SHhRejBOZ1dh?=
 =?utf-8?B?M0IzeWtubFpSelp1ZEswOEYwbTVKSFp0MEcreG8yQWQrSjlmZ2V2WEVHOFJx?=
 =?utf-8?B?amRiZmljK0l4Q3ZlNmY4RmVnQ3BuYkwrU3NSZUFicURGOGdUdVdjdEhDL3lS?=
 =?utf-8?B?bmgxZ3VFTnVYS1V6WTNOSm5TSExialJYT1hTRWFLTHZjRkJFSGt0NThoMXYx?=
 =?utf-8?B?UFVvUFJ1Qlo5V1pKTnMxUzQwYkFDOEtFT2pONThIRllZODJlZXpwSGRDd0hX?=
 =?utf-8?B?dm5tVHVUemtXK0prODdtQW56MjhWTGRObzU2S1VXV2VSbDhxWkIzQ1RDek4y?=
 =?utf-8?B?eWlEdkZkSUpmcUhIU2xwVXk5MThsbmk0Rkc5RVdjNFptMVBoT1h5V0FKWmxm?=
 =?utf-8?B?RkdWMFBlM3NvZDZHZG0vamZ5N3VZeTR6VkR2OWhrUmlqRkVDR2p4ZGg1eUNa?=
 =?utf-8?B?aSsxSlNCbUJ5NW1DUWhKQlBHUE50ajNlRnB2MkNBbWo3NlF5aGYyakhmT3dN?=
 =?utf-8?B?VUJIS25pVzg3S2s3SmYrbGRqaWU3TURYamdCcG1GV2c4ZU1uODV1ZExNQ2tr?=
 =?utf-8?B?QjJpNFFCdHIvbzB5UEhid0c2S2V3V3hicmJCYml5bVZad1UzNTRSYm55cGNP?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ed6a66-79e4-4022-33c1-08dddb7b7c1c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:42:36.7447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eSAwsMG6xPWGpzyk0LTNg3AX+rndfnRTglaUUx+Bu2jkUem6rPyR4chA1a0kLxjlpriCmp9qpafLs7ftkNfEaZdQYOmT4cN74NcnnXH4qvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8988
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> Counters for telemetry events are in MMIO space. Each telemetry_region
> structure returned in the pmt_feature_group returned from OOBMSM contains

"OOBMSM" -> "INTEL_PMT_TELEMETRY"?

> the base MMIO address for the counters.
> 
> There may be multiple aggregators per package. Scan all the
> telemetry_region structures again and save the number of regions together
> with a flex array of the MMIO addresses for each region indexed by
> package id.
> 
> Completed structure for each event group looks like this:
> 
>              +---------------------+---------------------+
> pkginfo** -->|pkginfo[package ID 0]|pkginfo[package ID 1]|
>              +---------------------+---------------------+
>                         |                     |
>                         v                     v
>                 +--------------------+    +--------------------+
>                 |struct pkg_mmio_info|    |struct pkg_mmio_info|
>                 +--------------------+    +--------------------+
>                 |num_regions = M     |    |num_regions = N     |
>                 |  addrs[0]          |    |  addrs[0]          |
>                 |  addrs[1]          |    |  addrs[1]          |
>                 |    ...             |    |    ...             |
>                 |  addrs[M-1]        |    |  addrs[N-1]        |
>                 +--------------------+    +--------------------+
> 
> Build a list (active_event_groups) of all the event groups that
> were successfully enabled. Use it to clean up in intel_aet_exit().

While this adds a note about active_event_groups it does not motivate 
*why* this additional data structure is needed. I find this additional
data structure unnecessary and actually makes the code harder to understand.
As I understand event_group::pfg can already be used to determine if the
event group is active or not. Adding a new data structure to track this thus seems
unnecessary. If this is a data structure created for convenience I think it
should rather be replaced by helpers that use event_group::pfg.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...
  
> @@ -169,4 +234,13 @@ bool intel_aet_get_events(void)
>  
>  void __exit intel_aet_exit(void)
>  {
> +	struct event_group *evg, *tmp;
> +
> +	list_for_each_entry_safe(evg, tmp, &active_event_groups, list) {
> +		intel_pmt_put_feature_group(evg->pfg);
> +		evg->pfg = NULL;
> +		free_pkg_mmio_info(evg->pkginfo);
> +		evg->pkginfo = NULL;
> +		list_del(&evg->list);
> +	}
>  }

I think above can be simplified by making it symmetrical to
intel_aet_get_events(). 
For example:

static void put_pmt_feature(struct event_group **evgs, unsigned int num_evg)    
{                                                                               
	struct event_group **peg;                                               
                                                                                
	for (peg = evgs; peg < &evgs[num_evg]; peg++) {                         
		if (!(*peg)->pfg)                                               
			return;                                                 
		intel_pmt_put_feature_group((*peg)->pfg);                       
		/* rest of cleanup from intel_aet_exit() above */
	}                                                                       
}                                      

void __ exit intel_aet_exit(void) {                                                          
	put_pmt_feature(known_energy_event_groups,                              
			ARRAY_SIZE(known_energy_event_groups));                 
	put_pmt_feature(known_perf_event_groups,                                
			ARRAY_SIZE(known_perf_event_groups));                   
}                                           

Reinette
