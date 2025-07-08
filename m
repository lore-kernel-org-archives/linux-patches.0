Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D11FF60A
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008564; cv=fail; b=FQ9nPTOVyg+w7wHdWW8SIAcaYf0D/XGz336MhqsnkbS4u+SKeiDSUyl4WF8JpkpVLrTBFWbtXbOfYM3hSsfHuFwFAo5//USx+RBT9DejqynNkbj8tX1Kc7BTLD2RO+Nhmpg4WHrbsTssTgYJULxVZqKXm7vmq74rtbD/DVUmfjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008564; c=relaxed/simple;
	bh=Nfprs7eJCKMMOCycydB4JqAQQG/IxNxbhItE3DHITMU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SZLms6IJ2pTjZ1WBszMdGgFf9nt795UsDeHq+PzZKxyPPfIHfO/IlqASLHWngRAdDpaWKdF8jxFu0VP5cOJ6H0BWFTznIKP2Obct7hRUwegint+JvmtnYZ9DNAIiYuykddPF9TmG5jIKZvZLxCmIPe/NkPDeTHHs5uCsSqVUy8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bz8t4v6U; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bz8t4v6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008563; x=1783544563;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nfprs7eJCKMMOCycydB4JqAQQG/IxNxbhItE3DHITMU=;
  b=bz8t4v6UcXb4uVFdSpgMrZlxjU5IhMJm7UhF82p1kgFRYFIhaiebbdAu
   aLl9XfP4ZUkd7zNoADywf6jvJX4KynghjjEKe3NFXc1wYeKpwBL5XTPQh
   leYTtKV6edHdBElktjoY0vXoOv0boBWzN+IlpRme19YgYN9N6yqZe7i/m
   nIT2hClTBu5J3S9566jGivubeeG4S3QxGHqEeWIHOXL/iIpqWtME4o7hm
   Gc0fkQw/4Iuki8Q4vYlPCzClL9UiDFOuI207WeWY7FE0gvkN8xSaQ0Z5F
   9JXbD9SQqWOCbUC2tKrd6j5scc1MD61P9SXA0KJnW7m+ZeLpSZZMvxIW/
   A==;
X-CSE-ConnectionGUID: zZLYEv6wThOL13likuKGFQ==
X-CSE-MsgGUID: DVysL0dXRxi3Me2BZeeH2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71842946"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="71842946"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:02:41 -0700
X-CSE-ConnectionGUID: JT26jnNnRB6YuEL3CLEucw==
X-CSE-MsgGUID: NB5MSTCTRy+xWxYN0dIbWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155008363"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:02:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:02:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 14:02:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:01:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irIvNMFm7fWnkFA98sSS0ZlzU5pfAkGzRGpDfFjG3vLhfDd59+XN6l3/XMCeV5BlwXaDyiHC/gDonEjw9GJwE5q7vEr8LR6Cy3oZNQLaCBmQjdqSSydoK9QnnrI2Y3DrSJNHbEeYP+xz7GoCFvzZVotfWItM3hkZUFRtAeFiRqko6fzHJfruKa+FS6MGlC1rAgMQXGAj3z0h8HyCOX2p5EzTpn7zeVkHwzxWXZ0k82i//7Ls7oX0htJgRW5vEbgqqDALOSYRi/5rv+GUZ1ggVnmdTqiiKVNp2nvknNchUwX8wrZKxo1qcQ395d3mvyL1Ka3wovdAWACD0iTVzfEY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9RWZo/0U/83fpZxC0yFYH9/MUDAbPPazlsx807ibxM=;
 b=I2oHzoyAdqFNnO2p6uoLbdevB2aJOwheSS8VNh25zu1jljBlRl/kxXEwGBrfji0ccFcgzEVzwod6nIXl0Af3E4g6vuz7TnmGBdCWC27/KSQsKUlqV3O/xUfockyopJVps7rZGXt0yuZLoJG6WpB3I76AkuQoi5s5RWY3PGqD8LrJ/mLKnkiyQ5deEws4sXUBx+XFUmlHLQNgZgY7AWYRXJmCae1tKhAf8IS9Od1jXGgNuSxKzGDgi1KQhOLXwk5mjwLZewM1KvLE2xiv+AxgiLwe2TZ7qTWnwpzmhR9g/uajbP8ibtOPiolX9O/f0j+l2aohe6lAZD5pr2SjuL/F+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7505.namprd11.prod.outlook.com (2603:10b6:8:153::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Tue, 8 Jul
 2025 21:01:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 21:01:17 +0000
Message-ID: <fd40240d-353e-4c0c-9613-572df66e0055@intel.com>
Date: Tue, 8 Jul 2025 14:01:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/30] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0099.namprd04.prod.outlook.com
 (2603:10b6:303:83::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b71feeb-abc2-4025-10b0-08ddbe6294b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SUt4Wm9Yam9nd1JCMnNzcWZETllVWVRPajhQRFc3OEd0T3AyemtXV1pFaHJs?=
 =?utf-8?B?ckVPenlkNEsvZTJ5TjRUSEpaWjI1RC9Fb3hKbkcyU2pYbjlDL1lvV3pTOXFl?=
 =?utf-8?B?d2RiaFFSWHBpWThaSHhXT1VkV0JTZzRZMFlJclMzTVRyenQrN1NDUU5FRE1H?=
 =?utf-8?B?cS9OWXRWK0ZUUHRGSHRzSGFJNmZPWXBXRFRra3AvbFowOWZ1b1Q4M0d6N3cy?=
 =?utf-8?B?OHRkcWJZQ1FCUEZKODEwcTdBWFZMdi9hZDRWMHZLRU42QUZCK2lFL0wvTjVu?=
 =?utf-8?B?MlRpb3puakVnU1VxSitONDJVeDR1RzB0Y25hd05IU21JeFhQeHhyZ292LzJq?=
 =?utf-8?B?RnB5b241bVYweUdZc2swcHV5T1hMOGNxT0Z4OXhHU3JtREpZUXZuRFJtYlVl?=
 =?utf-8?B?UnErNU4zVFVkZkJTRVBKeWR2U09HV3BneXNEYk0zZUdBdzhLdksrcHJ1bEVF?=
 =?utf-8?B?L0RGc1FIMFQwa3ROaDJMbTNrYWU3UFdRdFc0Ti9GREJCdWZkOE1sMHJTT3k5?=
 =?utf-8?B?VWFGVk5XVjNaWWh4ZmZsZ2NnSGd0NW9NTVlzek93dnBzc0k5M3laVjJQWUJI?=
 =?utf-8?B?Wmt4dzlSRis2QzV3c2RCYlROalg4MU5Kek8rc1NiNG5aczNPeHNDd0ZlN2FZ?=
 =?utf-8?B?dllQK0hHVVpvTDZyQXNkVWFhdTVOSkg3WncxOFpKTEpqZmNvK1BXSzJmQXZv?=
 =?utf-8?B?YjFiaS92MTREaXc0d2R5Z3dHOVR5TWhBRTM5blVxVjV1STlZbnY1aCswUXRy?=
 =?utf-8?B?bWJlZXRvM3NjSldqSm1DVGdmRzh0cWFEMXF0VG1HRVA5QnB2cXUybmdxdHRT?=
 =?utf-8?B?MlJvYnQrSnVrQ3hEYm1SK3FyMlR2U2Q0RVFGT2xZR0dGMmFlTnMzaVloODFj?=
 =?utf-8?B?ZG9oV1hUSjlac0FqVzE4dFpNNUdEaG5Hekw0OXk0WE5KUC9QRjl5VkpvVFNR?=
 =?utf-8?B?Q002U1FSeDE4MTJJWERTT1h5c1NSK1RNMFpnQ1g4azZzSTlkbTFCWHRiVzQ1?=
 =?utf-8?B?OGlkcVRpaEo0NjhPaUlVdER6ZGVkSnNaZEw3OXhOUDNQVjNyY2NGTVVydHg2?=
 =?utf-8?B?RXZ1NzI2ZmR5Tk1vTXA3anRpbGh1MVRBN0lKeHdTeDlzK3R6cmlXNzQwVUVV?=
 =?utf-8?B?VFRrWkR3dUYvTlhDRzVkRmZSdnNDRmNISlgyWmphV0xwSVFaU3lmQnZvLytE?=
 =?utf-8?B?UWwyUnZKSXpSWXVmTXpac1BkbnM5UUpiTnNXQVNsUjIxeEtURGhkZnd6eFI2?=
 =?utf-8?B?ZVRXdmdjcFRRRlY3NlBlV0VWak5LMUFlaFBhM3lpK1pCNlFZd1V6YzF5NUxo?=
 =?utf-8?B?RUladjQxaXBvQlNsUXZXVmZ6Q09lNWJHYVkra0JLc3Jyb0Fvb21MLzdEVWd3?=
 =?utf-8?B?SGZGWjFtdGFseVdrOVhReUFoRGdzYWRzQThFaklEYkhVUjI3dGsySkJWS1Rm?=
 =?utf-8?B?Vkpwb3d4dzdIM1Ntb0JJRVluYmxKSU5ab1VZVDk4N3ZIN1ZQQUJqMGNicUov?=
 =?utf-8?B?N0gybGhDMzJJMzdrRXpiNnVnR0EyMGpkVE9KMmNhSGlXRUlBbVk5LzZhT0Rt?=
 =?utf-8?B?VktLWFJ6Q1I3M1FIMjVYVU1jQURCUklpbmRxQ2NuM1JQZWVLTDJNYy9vTUts?=
 =?utf-8?B?dlpnM2h6ODJhazBjUEdGb3RteHg4TFA1UjdxNXlBMHJTc3dWTFFXRi9JNE4w?=
 =?utf-8?B?Smx4Yjl6OTNUWHVQZFJ5U2taQ09QS2FvUkIvMkhQeTJMdG9WNDVKNHBmRy9Q?=
 =?utf-8?B?aVViY2RDdGo0ZWIxdENjNjBJZ3IvVjA2c0RROEtSMEU5L3JEQUQva0hSTFlq?=
 =?utf-8?B?d2V5dTd2TDA2dWJFN0xTc3FYaUZsYVNhMnNWam5MOHVURXROemQzZGZrN0kr?=
 =?utf-8?B?ZDFiYUlsM0ZISGxiZGRzbXNSVlovUyt2T3NtSTY1VHdVS21jd1VUNEhVMmJD?=
 =?utf-8?B?WFZMN25kQldESFhpWnIwek9PYUYxckkxVzc1dmVUTVR4UVZTVUx3RFNXc1dS?=
 =?utf-8?B?Qzd1Q1BjT2lnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTJDM1Myd1JtZDdGZkRiUk10a05MRlZ1VVRkMkhvRGhUY29RUmJ0S2xkdElu?=
 =?utf-8?B?MmdvamtTV2NqWVp3eTU0YzNIOTVVeWt3cXNwVDIvajdVTDRJdk9TaTk1UktE?=
 =?utf-8?B?djRVYXoyeGxDejNxMmJrU3FQbTNQMWFqN293TVpnMnpwSWRGSktBbng3RUZN?=
 =?utf-8?B?YkNzcGRjeGV4cEFwUHNxSjMzMHpXK2pqYjcwUnhHOHF4UGJmUmFhMzBPSUx2?=
 =?utf-8?B?OWlTZFpLYS90TUZaRDNvM0xvMFdDaXRZSURCbFBXU0JUcjc5bitaUllWMHMw?=
 =?utf-8?B?Y0k1UlZTYXNlV2VuQVk2RGZiYnlUYXlwMHhWa1BIeTRmYzNBQWxTcXhMTGs1?=
 =?utf-8?B?OUQ3eGxFdG41VzFRMGZ1U3NWZzBKWE85U3FrTnZnZkdVVk4rZGdVZXZCZ1BK?=
 =?utf-8?B?eDBuMlZEZ1lyL2N4c0plWjVIVTZrRmIyQ1pKWVowbHZtZ1JvT1BIeUVVbFZQ?=
 =?utf-8?B?RDJBYUJqUE9idkJ2bVpHYzZ6ZlFzQ3lIMkc0ejQvU3dnL1NPMXRNZjVQMjZy?=
 =?utf-8?B?SDIrLy9BSHFsWEJxNGIyem5FaWsrdi9WcURDbTZGNDZndUFFTmNJQjk2ay9k?=
 =?utf-8?B?SzZudHVPNFVPeVpoVXdWdlJUbG5makVidzhtYUhoeGV5VDNrRFBEdlk4SW0r?=
 =?utf-8?B?OUFRRCtSVllrYjQ4dDM4VEt1RWtZNWx3c1FwM3RVYk9LaGNvaThSQlJra1Fj?=
 =?utf-8?B?eExqUXc4UVlyUVVmanpvZTlCTElaZFJ4UnlBdVdjR0RrTU9hS29ZZVFkbGxX?=
 =?utf-8?B?SGxRMnhDMHpLNXEwOXRJVlhLemFpb0pDSjdyZUZEYk5qSFpNeklpTS9XRkZk?=
 =?utf-8?B?RmFTa21PYi9PblVuVXpyVWFCaDBBQWVBYWtJaDhOQmdUZzA5cGxhVzZIYzNy?=
 =?utf-8?B?TjFUdGY2MDdNbkdGVkRzMWlRa2xoMktOUm5KbzZmMHRwZk1VbmlKRW5kdnJn?=
 =?utf-8?B?dmI1bUYyYkpDbklELy9lS3MrQnFJcEVESE5xUnRTSE96K0pyc1hQSVR1aE5u?=
 =?utf-8?B?bEJiaVRBR0NiRWlBQkRyQ2puU3NoOXN1TzBkcFdIY1Q0OW45Rjlxa1pvVHRF?=
 =?utf-8?B?RndIbjZPVVJpdU12VmI3TEd2NmQ4Z25RV24xUGU3QWljUHVnV1R2d0JCUjBh?=
 =?utf-8?B?QTRDU3JoS2pOZ0RWUUhldjh4dXpCWHRzOXNaSFFBWlFJVW52a0JrbWNqc2xi?=
 =?utf-8?B?YWNkTXpxZ0F6NS9adTZZVldrUk5FSVBjT2I1VUxFMHl5ejl4WmlOV1pzbVhk?=
 =?utf-8?B?TGQ5dE5rL1RUMTVzUU1GWXFvV2ZBRkxGM3BRRHNDYWFzd1lyOXZjVGZuaUNz?=
 =?utf-8?B?T0ZpVjJEdnJwZlhPSHpTOXJRVk82aG5Qb2ZSWWtFYjFyVk1KVEV6bVBpd0JL?=
 =?utf-8?B?SzN1NTZpc1F0djYvb2pVZWE2VHlKVU9ON3oyalI2Z3QxU3FEekJ3Rzk5Rlhv?=
 =?utf-8?B?QUVjSmFCUHdXWDFRZG9vdWc1a1NCWjlvWUVsSUV0RnU0NWJURC9FZ0hyZ1E1?=
 =?utf-8?B?TTZtMy9aQjA5MzlXWmZXd0hBcXRHc1RkblFhaXNxdUpoSGduVU5VMXFTZHhZ?=
 =?utf-8?B?bC9jdllnZU9XL214ZEFhVWVMNjZiaWdzSWdSOG4xclJaNlc3SkhnOUZNbkFD?=
 =?utf-8?B?dkd0SDlEWXoxK1JSNTN1TGtNQU1EZXJxTlNTTU9PNjI1a1JXSCtSM0xpUlg1?=
 =?utf-8?B?OWM3VFNld3J4VWI1ME1IVmlmdlpQVkpPNTAzdEYwbzUwTmR1S0pnSENhUkli?=
 =?utf-8?B?VWtGM0Rzc3lWcVp0RkRlbzh2Y0R6OENyNndxbjRsMlBXekhEckJORDNIT3l5?=
 =?utf-8?B?eUVVUmFJbC9LQzJDa3V3cjJWUEVCVUF6QmNSRDlWZHlxdENRSlJocjRVaGFH?=
 =?utf-8?B?VE4wU0xDdjc2R0xFOTNaeFhBZWdEbEJXNTlhY280RTN2a0U4THNYMXhwclNj?=
 =?utf-8?B?cE9XZ2xBWk1wdUJPR3ViaVlPSkYyaFl2eXVyVEpFNFFRTGUyUTJjbmtVUyto?=
 =?utf-8?B?ekdiek5qU1JibGdoT0RWUkxaRm0zZXNyUFZEMkc0UlduakE3Wm9CY2dRTTlK?=
 =?utf-8?B?WGFybDNFRHdNK3VIQlBiT1l5TW5KWERzL2ZKM1dFS1lLOCtqbmJqbktIQ2Np?=
 =?utf-8?B?b2J3aTdzNFdxdWY2NmlYNDVneGcvUDlBb3ZObjJpc2Fzc0M0VlZUOTRCNkhW?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b71feeb-abc2-4025-10b0-08ddbe6294b9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 21:01:17.0596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gfl1io7yqA9N/NSg3Sq4Mu0W8+JssGbaE7e7ZIskTXoLwvrs8tdnbb9eFRrKOz3EGqvzn9Yqq0rYWOmZoOYtZ4jD+U1+HVsKETNQTw26pU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7505
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> The rdt_domain_hdr structure is used in both control and monitor
> domain structures to provide common methods for operations such as
> adding a CPU to a domain, removing a CPU from a domain, accessing
> the mask of all CPUs in a domain.
> 
> The "type" field provides a simple check whether a domain is a
> control or monitor domain so that programming errors operating
> on domains will be quickly caught.
> 
> To prepare for additional domain types that depend on the rdt_resource
> to which they are connected add the resource id into the header
> and check that in addition to the type.
> 
> At this point all monitoring events are tied to the RDT_RESOURCE_L3
> resource. So hard code the check in rdtgroup_mondata_show() to
> that resource id.

Comment about this hardcoding below ...

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  9 +++++++++
>  arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
>  fs/resctrl/ctrlmondata.c           |  2 +-
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 478d7a935ca3..dc7ccd60e8c2 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -131,15 +131,24 @@ enum resctrl_domain_type {
>   * @list:		all instances of this resource
>   * @id:			unique id for this instance
>   * @type:		type of this instance
> + * @rid:		index of resource for this domain

Similar comment as in patch #1 about use of "index" in resctrl fs.

>   * @cpu_mask:		which CPUs share this resource
>   */
>  struct rdt_domain_hdr {
>  	struct list_head		list;
>  	int				id;
>  	enum resctrl_domain_type	type;
> +	enum resctrl_res_level		rid;
>  	struct cpumask			cpu_mask;
>  };
>  

...

> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index ad7ffc6acf13..cdb4bc8baa99 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -643,7 +643,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  		 * the resource to find the domain with "domid".
>  		 */
>  		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
> -		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
>  			ret = -ENOENT;
>  			goto out;
>  		}

I do not see why this hardcoding is required since the resource ID is available via the
struct mon_data associated with the file. Looks like this is undone in patch #9 anyway
so the explicit handling by this patch is unclear.

Reinette
