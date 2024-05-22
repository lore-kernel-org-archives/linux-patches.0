Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EECA57CA6
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412351; cv=fail; b=mPlUYQHsgChPaOmqaSEWMXh0hnG1HwMcYAKw/G3zvXN0U5Ue+Sj0uGCptEA0tlmEBjNrMg3y1CKwvyl24D9E5W2PbycSuy1wsFBGsXSoku1s/xOA4mEACiSKjaGADWOIB4GvWOxzW18eaU5+QVrCiR8I4b+HVHO3dagfs4NoAAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412351; c=relaxed/simple;
	bh=X+TX+CbWuYY5836ToLzOPzH0ZGyuWqrAPSrEbcFJfiQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C73kOVHkDGOJwBWqT89CVCBCF9BKZp4pg9VrMOnN0emo/ejdgh1j5tABt8hpaWig4K2AOSdcghTEfiGjx/tNEs4lmsT51EIIeKQWuVNjUGV45xtgeQEWuA0lsvFO/Wi3Z3kOKPun/mvFi8c986RQI5Jvjf7pH/EoCmNohwyRnxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEa39HII; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEa39HII"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412350; x=1747948350;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X+TX+CbWuYY5836ToLzOPzH0ZGyuWqrAPSrEbcFJfiQ=;
  b=jEa39HIIICpYVaZkCKZHKUBYJqNjbMas/tGqMzGV/4H44UjI8cm9ppA7
   ekbBUyjtcuOO9snd9nCv9rhIN00yQcqsvWoNPss2U0kUBfrnl0Fvu3Bi7
   JOiRtYBTg/kTJbkTOzN7LM5d18q/dcZ5tahOnPaG01t6q8nXk1KavfEM0
   o0wn4j8cgVrC+EesFew8+5uVHkeRrLj7hY79lxv5plUPySsHqK1BDMIA7
   29B0lwy0CqiuV9dmXn48rmxwbP9mgSDy5LbGCX4mVpdHFra12sc3lzJ17
   AlXmU5edKewiD02ODNvidl12+DpN5Jx9yU+4r45mYQQlQk8ZN+6O+EL1w
   g==;
X-CSE-ConnectionGUID: upY45SStRDqdmoH15CO28A==
X-CSE-MsgGUID: QclymNw9Sl+onNsjylZ11w==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12925964"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12925964"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:12:26 -0700
X-CSE-ConnectionGUID: QAbquMT2QAOHD46SDXmfXQ==
X-CSE-MsgGUID: Yl5DPkIkTYmQYKXDgD0xYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38269058"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:12:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:12:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:12:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:12:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPW/S/97mZb0NFiLglHGdWwyRSJnx4RAQBm7r7ds6USXPoWYStbumihqX8j2R+Mj02HCbGEo7qApJ6kUeUkZ5EGopuFA3clnRa6R0vYl3mOXPgWIiI47KTdgovCfNthQ1jvQnaWucFSxN2097sFfayeGaSAGIlrWAeKVyl39hq+EUE9g3rYmPeOQ1iRkmq/WaM2yK2SLzrPKdOnLQZpi5IZ/VPaqN5R/pso+8yB0fwuk7dt0Geezc7RQ17G+1h0KTNws+tdXnWAnlvhmiDHIxmZ0D+pe++0b6fj/2Hc03AHA52kx5Af+Z8BgE10kOLsx5C0ACyzXbUJmHJ6LwpsNmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qvc2wt1pz+vLuvZBQCWZOyQjBRINNoh5QTK5sYzKdmk=;
 b=IiZvx6HLmuZLP+m3wUTWU5lxbJv3eChQjEeHcxR5Ohx0lk5tmxFmSZR8Bsko3XwYzXwczgnRCI99lCrXDOxPU6vXDXlV6buC0Fsi6+LJ82xghOwFDzd8coBMVUnvcW9lGZoqVPuu640eB+yGavA6zYLpvcl/CDkjRZAMJBxxcaOh6Y8mPmrRnEYDSzY4lweS4oZoiEJEp9wvbVuZG6AD1xf3yYh9VRYlMV4uxE/V9YkNPcDXHvZ3jkNPmOxUB/rvOR0a+Eydh09/9zy7RYZlHLkbvSyZuupnOsVHsTnIwKz5Dp8rdukc0OnqtJJyVfF/YiJR6pjHFXtWh/V0GvTAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6559.namprd11.prod.outlook.com (2603:10b6:806:26d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 21:12:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:12:22 +0000
Message-ID: <7887abff-8118-4064-8cb6-3f4af8cc4b2a@intel.com>
Date: Wed, 22 May 2024 14:12:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 07/17] x86/resctrl: Prepare for new Sub-NUMA (SNC)
 cluster monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: 809ae837-6f03-48ca-7355-08dc7aa3df2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NEtuVXp1NXJiMDdIblFEYnk4NFFzWWI4YVFBN3RNZzlWbUNIQ0kwSW9oaWsz?=
 =?utf-8?B?Tmg5dDl5cUo1UlZnVVVKUXJKOGloalpXWkd0cnZxWHZmNm9NTmZUa3h2ZTF6?=
 =?utf-8?B?VVVMaFRTVGVEZG5Wd3NETCtmMjRFNXRBc2xrcmF3Q3RQa2tZcW1kVWJ6aURj?=
 =?utf-8?B?Wm9mZFIwbUYxVFJ4T0FBL1ZLQ0VwU0dHVVpleTVEdWFzblhNNlZKcnM0cEFv?=
 =?utf-8?B?UUkrMzEvSkZrejM1Q2J3K1J5U3MxUnNaU00rY0JKS1lnSE1VN0l6Z3piY3U4?=
 =?utf-8?B?cGEvYjVTOWpRTTVEUUJvWEJwYW9WWmQ5UnZFWWlTOFBmSjlwL081WkhOZFFB?=
 =?utf-8?B?WFpqY0RTbldlOHZ6OFpZMjdFaklDaWowZjg1TGhpeWlvMDNHMTd6bWFybElJ?=
 =?utf-8?B?S0dWWlBaRjZ0SVJEbWwvRlR1S0RPV3NVVC9VelIxajZEd2NRa2xnRmhBWk5J?=
 =?utf-8?B?V1p6UWx6bHN1enJ5OStDcnBSVFhPa29lenFsR2Y4L0tWTlJSeEVqWnlWQmNS?=
 =?utf-8?B?ejd2SGk0OWM4TXlRWm5YRU9mZjhneDlVbDUxSk45b2xINTVQbnhiK2Y4bGhH?=
 =?utf-8?B?WlYvYmdWZHpDSjZza1BpR1FDNzFYRkZSVS85ZVVEcnZQUmNJUVJ5MHdSTVJx?=
 =?utf-8?B?RWRpWWdHcGlhbFpZZkJRU3hDVjE0QXAwWGZNMHZsRTRFY2d6VngxS3ZuRGpr?=
 =?utf-8?B?OHBsNFViempoeWc1cVhsYzh6azFjTVRDQml5Y05xdGhHeTF2alAvTWo5YnNO?=
 =?utf-8?B?aTRIU01PaFpYTWwwK0dsR3ltNlZobTNLaWpCTkI0bC93OW1GRklqSjlTZUdO?=
 =?utf-8?B?bGtiaVVnSVRUSjNpcXc1MmxxWHBmOWZBU21wUXZ2eGl4bzg5c0xtaWUrZExj?=
 =?utf-8?B?OXphM3FKZzBvQ1gyaEdrN05lZUNzam95ZjlISXVZTnlqOGNiWDhFaFBHcDNw?=
 =?utf-8?B?c2JGQWF4bzNGQUNkcUVpU1lVdlBjN2F2dVhlL1YvRzl6d2RaVmg3Tnk2TmFj?=
 =?utf-8?B?dlZuclpFOHRZRS94S0VVQTdoc0YxRTdhVlpBUit1YUNpWGVnK1FLK3pvcnZL?=
 =?utf-8?B?Q1gzMVVNWitTQk0rUU5YZWtXdnBsSWRucEtFZzRZWHUyUDRtL0ZDTmJhREg5?=
 =?utf-8?B?YzVYcjIyOGs3WHlMUktlNWZ0RUdWb1VXRXRhbzVvR1ZhaktsUHNvUDZ2OUM2?=
 =?utf-8?B?OHZ1c2poU2d3S3NRK2dPY2pRTjB5Vm1tRjdKRmg1MVJwSzEzSWd3NlpqZWxl?=
 =?utf-8?B?LzdoZFVNbFhWQnhEL1dRNWZxWUN6cmd2MlJLR0N4ZU5FbEhLbG9kMEpnT3E0?=
 =?utf-8?B?WWNCTGR0Nmw2aTE0RHJCZzE1b1VQYW9aam0vOFpXVmNiUkMwNnRnZklRYjY2?=
 =?utf-8?B?MHpZZEVNRzNMelVGYmRjVExKOUo2QTNDUDRhdXNNa0FxLzhWWW96T29RV09w?=
 =?utf-8?B?NDJabkR4U3lSVjFjN3VjUVpVcUhPT0owQkhzeTduWjVVblhHcWh3K05Yditt?=
 =?utf-8?B?UzVnbkZ6VkM3ZHBoeU8vTTY4ZXU5cU5QaU81M0QveVY4VVh4OGIzZEpRNlV5?=
 =?utf-8?B?NFBwaXZWNWZKMUl3RWZTS1N0cFZSU3BFbm1RNThXUE1lWEt5N2dKdnBvVURZ?=
 =?utf-8?B?b2g2VU0wdU1SZzdMS3F5USsvTnYwVVJqKzZycUFaMk1EWkFuN0lMSE13bTBv?=
 =?utf-8?B?cGNrU3pyWDRrYXVvSnVnY3pkRmY2OVpCenZxbU1zQk5KUWhlYW12bzl3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnJKSU11ejdPOHJTTTkwMXpoVkFydk92ZXFVLy80NlF0QWpLNXlqdDJBRWsv?=
 =?utf-8?B?VmdQOVlGVnFDZ1h4NTJQMWltdTRvc2NPL1p4cU56UTRlN0pYYzd6OVcza0Zl?=
 =?utf-8?B?WWM3RWFIS3JnYzlQTEhpTzFsOUhGSUNVcnA0RU9hMFNKNmptNDN5NTB4Z3hZ?=
 =?utf-8?B?eGc4RHAzc3RlRFNzb1R2SmwxcTY0cFVkTWZRNmw3b2FRVU44cGpBRDFwM1VZ?=
 =?utf-8?B?UExiK3hPcEw1NjFkTWRoYTdNb3V1WXlzaTJoMWswemZMT2Vnc3J6VWIwVk1k?=
 =?utf-8?B?RlQzV29LN21oS3l2TzV4djBUMFNzeDZrdTBRVVlkSmJLbkV5a1d1enZNQjJu?=
 =?utf-8?B?NVhETlNqanJVOWE2Uno3aVFnMGM5Mnl6L3VvSGNjTWlqMURlQ1ovVDllOTNU?=
 =?utf-8?B?K2orcU5MKzg3emxIdDlqZ09vSkdLNmtRNzZnMHFQem82NE9YVWo5TC9pbVJB?=
 =?utf-8?B?QnE0YmZPK09JSjVIYVF4dlY0NlJqOWlIMVlOWFJZaUoxRGJ0cE8vQkhYSWdD?=
 =?utf-8?B?MFNDYnRJRkRaNmxoam1DYkZwQ0hROTZ2ZEwxcVdLWVkvd2VVYTRFUnhrTkpC?=
 =?utf-8?B?alFYUDlEQkcyVW5NbW5JQTNaWWl0Qmd6N3dubW01cEVYNjk4Y0Y1TUlZWnlH?=
 =?utf-8?B?aFZLRVlIOFM5SFEzYmhOYXdDcExac0Z0THN2aE5scXMyWTAraHdHVnJoOGRk?=
 =?utf-8?B?UXJqYXBEV1JKMUdPUFpHZmY0TDJ2c25GQjBLazFubHNWQ3B6dnpVYkxmUmxD?=
 =?utf-8?B?N1ZuOCtOQWExZ1pZMDR3d1JHR3VRbllaWjJMaVVrTWF6WW1vOUZDaGw1aGU3?=
 =?utf-8?B?VlBzTDZyRTd4SUt4OEtwS25sOXNqc0ZqU2s4NXJkaCtIZ1ZzSlpyTFpwNFBL?=
 =?utf-8?B?dzFLNzYyM1lFYXpXdEozeHE0RytZWk9zM25KNW5vRHNlKy9KQ0hEL2g0Uzd0?=
 =?utf-8?B?RDROTm1lK2hMSlJ5TGVYbnpIN2VNVzhZMXBlR1RqNW1jbXQvaFF1MmdYVEMv?=
 =?utf-8?B?N0JCRWV2ZWo5aDNWV0laSGRwbXgrbEZTZDVlVnlyRDFEM3JSOE5OcVY3cTg2?=
 =?utf-8?B?M3h2bTNVS0t0VjNzVCttTVBCejk3cER3VFFVZ3BlSnl3VUpXbklDWjZMWkdj?=
 =?utf-8?B?T2o3bHpsVTdzUkppU3FTLzI1enVXRi9FT1ZlZW5iQnpyRmFNRWJIbitJa1V0?=
 =?utf-8?B?Z2g3N3BOV3FhaTBhRlJUOHdETkN3VlV4MU1Mcm9CS1V2bUdtVXI1Z201NEE5?=
 =?utf-8?B?K2RFUlgxYnNPUXhxZjErNStPUHhvRjZRTmF2MFlXQ0FTdVFEUkZLYlNhOC9R?=
 =?utf-8?B?cjErdmhMU1o3VkYySTdXbUh3S0grYjJSTlNwallpdWRXcE5oTmFUenk4NUQ1?=
 =?utf-8?B?RUZ2SHNaMnVMOHBUQ2NZckdvU2p0Rkk1OUxraFI4TTI4VlJJWjJHaUhIbWtR?=
 =?utf-8?B?OHc0VmdPRnJKZnBGeW96SkFHbHZ0elo4WUhMYlRVZVpvMjNmZlAvOUdjc2Zw?=
 =?utf-8?B?Wkg1SUNDdHBRKzEwZ251Uk1CVk1CRC9mcURtZWNYSzR2SzcxTHhVbG1nalNN?=
 =?utf-8?B?NHZDc0tPL2dXYzZIREVSRTc4K1ZQMW95eUVxNFBibzNEZEdBalFWcHpjNGVk?=
 =?utf-8?B?UnkydUZ5QkN6TStZN2ozUm5UY0o0L0tJY3c2blRBcHE5RnpUMU02UTRhb0lu?=
 =?utf-8?B?M1ZoNGNzdVYvbmxaVVRrbTdvR1VIYkZHVGVSSXVMdTBRYVVkMXR0dTFhNVBh?=
 =?utf-8?B?QWg2aG9xK2NXMGxSYW14LzZ0SWdrc3F0OHpsN0pMSUZyTkR0QTNhUGo3NTFj?=
 =?utf-8?B?OXhiaXMvV2l4K0Fab1p1cDNzUHRVb1hOM2JodEFtNW1YRVlOcU9oNENwYk1W?=
 =?utf-8?B?N0hhRWZUWitIRE8rZFIxQ0V4R3RQVmFBUFdsNDRxQXdtYmhYSmVUbkowWUg0?=
 =?utf-8?B?TFJtSGlJdVlzczFaNnl2ekVzM2hxOGJ3OHFxM3B1UUQ4ZHBKa29DNkg3WVVt?=
 =?utf-8?B?ZmU4WDBPK0pxUEFMTlJrQ3FGV3NtaUdGVW9lTnVxLzhxTzZLQlN2cFAvSWc1?=
 =?utf-8?B?UGJYUktxMndyaTJQWklwY05RbDM4M3pPQkhRSkJxSEZhOVk2Z0pEVW5mYXd6?=
 =?utf-8?B?T3dBNjl2d2c1UXJJU1hJSEZwSXFHeGpTNWwwSW0wM1phTy90T1lzVjBRS0VK?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 809ae837-6f03-48ca-7355-08dc7aa3df2c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:12:22.3941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrE+xAWvR4hNTpWdl4IBivazxYVhJ1iZvylBWOBTxgVVCVVLIDjUovHlKyRE2T2NVVaPFsCOYuG9XCnBk7+PZgEktMus1hNlzA9SLSYwalg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6559
X-OriginatorOrg: intel.com

Hi Tony,

Please note in the subject (and many places in this series) the
text "Sub-NUMA (SNC)" is used. Is that intentional? Other places
it reads "Sub-NUMA Cluster (SNC)".

On 5/15/2024 3:23 PM, Tony Luck wrote:
> When SNC is enabled monitoring data is collected at the SNC node
> granularity, but must be reported at L3-cache granularity for
> backwards compatibility in addition to reporting at the node
> level.
> 
> Add a mon_display_scope field to the rdt_resource structure to track
> reporting scope. Default is for non-SNC systems where both scopes
> are the same.

Just to confirm ... the reporting scope needs to be superset of
the "collecting"(?) scope. Is this something that is implicitly enforced?

Reinette
