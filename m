Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD0E43ABC
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919160; cv=fail; b=Xps2N2JpCTpHqD4/20wFyKbQhwFwbp0nYPMSEWR80l7euoUpqBA+NIXn20VwWvdTVpq/hRyLPHGvZWeRGTTrCr+F2z43kh8i+s9FPytW9ShXXF6oSFHgtlJ4bz+tGxCBlx2ZTG/wiVDlfolSXqfA2a/KgEB5B+G7aTTpwnmbC3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919160; c=relaxed/simple;
	bh=g2TVmsLsQzzgMTReaqoMBeCyleendqKU8SIb4IxvVXE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xlbmrq8TniWS0SIkxVaAeXJbY08Df4MfIrbNmQS6N/fiYmvrGfobJ8aDAm6loEH3R0A6jmdS4d0+Pafp8JKokSpojtAy5aZJcNUYrj+WIsM3y4DOVNnnXINq5LBfpN4+BRgCpXe2LsmTzpJgfkhTqJgvjRY3LVFlcZerBa+0iic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EUS3e+2O; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EUS3e+2O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919160; x=1750455160;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g2TVmsLsQzzgMTReaqoMBeCyleendqKU8SIb4IxvVXE=;
  b=EUS3e+2OWqwGAsqr/Qqr/kTSUL8NcvARNcVV9pvnZe3518qxONCIom5v
   fP74tzGXS04ZwlZ9JSwBkv7L20pIlX+a1Efodcvq9taLl+QGX4DtR1cP3
   eac8Ph0iJ3dVSzydO1u+XtQBC+9iPCCjNnWeILl5b18OKkxsc8ZEFv42J
   baCKQWNhpLuPQVWWkaPaLOL2gw2aXLimkOpwrjud34J+S4lGv2FK7FHJj
   fTwQq9n5YJSWRVUbg0RBQ2Pn6qB3SXiEba+L/cOa33Dj+yWaX5L5oiMMA
   31dsH+n9+4id/jGKuUCGZR71uIx8s0F2DfbazxvxmwDg6Wrpg577SIrIN
   A==;
X-CSE-ConnectionGUID: XxZuxHRoQ4KEzyWUG0LOXw==
X-CSE-MsgGUID: 3dJGIJBETVu8as5ZpcWUwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="27068297"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="27068297"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:32:39 -0700
X-CSE-ConnectionGUID: Ok8KNQHpQLSL8yHp4Hi5vg==
X-CSE-MsgGUID: Lm/HlP1dT7Cz6UEHUquBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42462919"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:31:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:31:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:31:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:31:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:31:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tu5i8rBTeK9FsiyBWnRbDVSLd2MWH3t68KNqihpHpJNQzYCgWkErfMEo2FU+PgwE1DcUaaxFiqML+McifPw3dB1xueQfeRq5XAruhWtcPbafS6bzatwZcAW5PYvfGMLvXQG/ZgY96o5qFnLcOKvHlPGrBDsAbOeBlJlSpSbChMjjUq3y2cplSBYXXf02Ajque5Lll9lnpohjoUA5Op/fKdcHLY9QWKAriY6lOnWKHl9GFkDWlyYvBnASqRcmXbf+nmjAK78L+Lf5P65MdjEflqo4AeyoWedcLpjkvF8O3V2pPRlAe26OF9ySNzVX/dlKebcL0sYcS5RqZndvdbJLiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEmNwYHdath4hnJdQEsr4BwzhomW615J6VgUCH0oCb4=;
 b=WCwpcDF84wi78E1eXYiG+H2lDP9jmujVw7j9bRLd5rxyQ1lYCp3zsJBKe2QmJ/YsZp6/mCWPGtd4fuo5BYy4m7A8uAGQgVuRjh5HK+vW694AslJqRC5EJsk+IjL/lMcTId0cU+fQwgzn4yDDmZam4uF6J6pJaICc6SRTD4RTi2X7XciiTxfD0XVEiJSTtmi15+YTUTiDvMwJomFectnDPYke+i1vJJw0X/4ewH9gi3qoNlq01JH2qc+rQP7Avdw/PkK0MQekhE/nzoo2jfZuAfsclRJ82lxj3drz2rtx1Wy8w7vf4hWbzfytkSxlsEzqlzM8KlvgNczl3yxKrblZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB6152.namprd11.prod.outlook.com (2603:10b6:8:9b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.30; Thu, 20 Jun 2024 21:31:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:31:54 +0000
Message-ID: <ae43b9c3-15f9-417d-aad3-ee48987c9b90@intel.com>
Date: Thu, 20 Jun 2024 14:31:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 15/18] x86/resctrl: Make __mon_event_count() handle
 sum domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-16-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240610183528.349198-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:303:2a::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d3c4ae7-7d89-4747-3b07-08dc91706792
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VDg1bVhzNXZxelNoM1FIN1F3LzlqaVF4cDlkNm5reUJjMld5RW1ZRThTWDNE?=
 =?utf-8?B?QU5yVGpUdUVZUnlmTUwxSnVaamhiTThnWUtodmJsSFZlZlFqT2R2YXZRdGxk?=
 =?utf-8?B?bENCSE1Lc2J3YUpJMjdoeHdNOFJjY0JxWkpJQ0RjNXBncHFoR0NEU085dVZo?=
 =?utf-8?B?QkVDYmEvd0x3Z0dLUGVleGFCbGc3czZmSlB1UFpOOEl4c0lCOTY0a2wvcHpD?=
 =?utf-8?B?Y1RXa0U2bHpUd1d4SkgvUnB2dXgzUUZ5blRycS9UYTVjNnZMVFVtRnVTZVRV?=
 =?utf-8?B?R2pqYWdyODBDUVYxTW53d2N5S3hyTk5uVFVIYjNNNU1vektjMTE0VzlNWkxs?=
 =?utf-8?B?UGpIMHVUM3VIZXB4QWo2bEhMdjNmYWlPZUJtVGluYlQ2M01aQ0lwM3JQUUVi?=
 =?utf-8?B?RDVPNG5RbVI3bkxQeVJIckhWekxKdEVxNGVuSW0xN2hhdk9GMnJmOFdtTGJw?=
 =?utf-8?B?bmdjc1FGdXZYYlQ4Z1J4RFdIMm5uL0FzYlU4UkNMNmg1eVkzODhQS00vcjBZ?=
 =?utf-8?B?ODlzeFB6TUFjSGFBT01pU3VKUVVQZ2VMTjVNTW1hREhmcXhlL0RoVkZEVTBU?=
 =?utf-8?B?SzBRUmRaK0NuNHNrWDI1WUtKTk5BdGFCOHFyM2VGdW9BVm1salBDNk1kcnY0?=
 =?utf-8?B?VmV1byt3SjJtaGNLaDc3U2RiZUJXd0I1WElhNklSbG5FdHFlTUdoaEVpR0xx?=
 =?utf-8?B?NHhjYitzdFNjdmZ4Rkc0Q1JpRnZGTTBzM0xrSEl5bHJmOG5DenJpZ2pzem84?=
 =?utf-8?B?VDVpemdDRk80MEFDaC8xUXBHOUhWMzNFQmJrUzNQdVNMZXh4ZjZLOTlQSzhZ?=
 =?utf-8?B?Yy9DU21qbTgzMEI4cis4OVlYWEs1Q2dxN1FLKzBSdVlDWUdpNW5oVGNJTEdx?=
 =?utf-8?B?ZWJCckhYTEd1dmUzTmxjZDBBMzJ1WmtyMGpRYlpJSi8xOWRoRFV5NEk0UU1n?=
 =?utf-8?B?ekFDYURqUXFyOE9wUVNkTkFGVlg4Y1RJSitwS0JaZmJOV0pEREJVYmVMN2JT?=
 =?utf-8?B?TkJHZEI5UFc4RkllUHpSNGFUMEh6ZGpVMXB6U1dLZTYxcHFnMEdFWitsRzhC?=
 =?utf-8?B?ckhMQ1pEd29rdUQwbURXQjkwRitTUlgvSVVNNjJ6c2ZqZzJGTWdneTc1REFN?=
 =?utf-8?B?ckgyZ3dNWEpYMnhyQzF5Ry9vQ1c5aTE2QzZKMTRGODNZVjZib2I5QmNWRy82?=
 =?utf-8?B?RCsxelZxNGN2VmVISm9vUVk5V1RjeTZrb3puL3ZGUlA0TDV0M25aYm02YWkw?=
 =?utf-8?B?K1pDRmV2M1RrSGlCODNsZlV0NTBBVjh4d2p6b1pvTTkwOC96R2ZLOVg2RXFh?=
 =?utf-8?B?cHR5K1U1c2p1bkMzaTE4dThodTZ1dUxwZjZNejB5OHUyK2RXTnVMV0FnNEt6?=
 =?utf-8?B?ZzIyZkYyeDk2cjRLbkNLaUdkcE52Y0lRU1YyZEwyeHVkekViY3c5U0xKelR1?=
 =?utf-8?B?bXZRWThmdEw4T094ai8xRll1UkJTMmhrd0kveVRUMVNRUUZTcFJjUmNzY1lm?=
 =?utf-8?B?OVIybzdYRSt4S3dTdkJWeVZyZHhPY0toTDVVOEVocFVUVm13UkVLU1hqZzZU?=
 =?utf-8?B?Q202aVFkajdsQnNNZHdnSFBuMTkyZEdtbmlkNVMzb3VtYkEzZ3lNWFZiNUtM?=
 =?utf-8?B?eFAveG9YeUROdWREbVR1SjVYZzVvRjJyS05nWU01NCt5VWpKalB2cnZpeDlH?=
 =?utf-8?B?T1h0TlJSbVQ4OUpMVHN1b0RmdlhpbkxVVHpWcE1vNCtXaW1KWjVUcHVRNFJP?=
 =?utf-8?Q?Hu9nN02EuCdBq0gsYHHZSbJordwtaDoe9FxWP+4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkxUdWZXeHNqUnJOaFl4ZFZCYUEzN2VQZGwrQzVrVGdYSm5qNGRqWjJRN2F6?=
 =?utf-8?B?SHZqQWxkUHZRVDRzTG5obWxtZXBCTGdLd0dXQW9SWmk3bmpiQnQ1YklNc3lk?=
 =?utf-8?B?enV1WlF3QXEySERUY0ppUDhZSlJsQXNaQmIvRlVGQ2RIUGs5U0Z4cC90T3BS?=
 =?utf-8?B?aHdEQU1pd1pvb040UUpmTDl2dFJCVy9ZZU5TUEhBVkNQek5TSTIxU2QrTFJ0?=
 =?utf-8?B?ZEtpV05MTjdLS3NLVFNWbnkyUTJYMlBPcFBBaFR3dFFtQUFVejl2NUQvd1Jt?=
 =?utf-8?B?aVcwME1VNVg1RHNUU2xTc0RxNVZZME9TVkhtZkZJQmNLblNPbzdjYXZ4L256?=
 =?utf-8?B?RlNmbTRTWEFDSzRDejBOSlpaWlJLUHhzWHprWTdXRUFtREtFd09hWWpuQkNN?=
 =?utf-8?B?aGxadG5yQ1dlTDZ3TnAyRGp2b3Q5cUVseUJrK1dCV1ZqU2ZHcTlPYUg0dnpp?=
 =?utf-8?B?T1BrYzZPSzBXR0xqMUFNQ2YyV3hPU0tocEhrZS9Dejh5S3FSVlBOY3gyNWlC?=
 =?utf-8?B?SXVONmFqYm4wcm1oL0tjZmRoK2t4MVJ1RTRVSWwwMjhVbWpVTHZ2VjlxcTgr?=
 =?utf-8?B?RHdZSlpHZHdsM09xSThwWDJSL0YyRXUvZTk2aEpnSlhKYUFZNHovNUcyZ0Vm?=
 =?utf-8?B?RURMMExCR1VWSmM5cWZuSUdvamsyblUvL3lRU29vL0NENXNBUTliUEVzb0Rw?=
 =?utf-8?B?azRLM0FSZWYzQitjY2NtT2IvemZ4Wk0rVERZMVgzdCsrN2QxelczUHB5Sy9z?=
 =?utf-8?B?ZGRjNXkybHorL3lPcjQra21jNTJNMjVlKzE5WktwTERjYThPaGNNMTR5aWtw?=
 =?utf-8?B?cy8vOVN0czZDNzZzNXVmcnhWT0h5ZVMzK0ZxZEtzTWFnVGJvT3FrZGtNYmNw?=
 =?utf-8?B?Z01nM05DdG01UHcyME5KbXdKY29qbDBXRVJlMWFPelhhQXdJUXFTbXYvdEts?=
 =?utf-8?B?QVkwdjBJcWV2eTFRdWlsSjhqRUVEN1lwWnZKMmJlcHlVdGNwMDNadytLdFZ0?=
 =?utf-8?B?TDBPVU1MbGtGYnVwd0prYWNqUzNPaU85ZkxTa2RTZVc1b1BJb05NYjNoR3lZ?=
 =?utf-8?B?VUlJdUVYck55cXN0cTZ2dnBZd2pLNmhIemVGRWpROG5MZWhGbnYzYnlWV3gw?=
 =?utf-8?B?aERzd1krWnVSMVdhY2FCTmNaY0Q5VmlhazdRWitIcmg4TFB5MzZQWWFzZk9H?=
 =?utf-8?B?YXVhdWZUbzNGTVJReTZoNHM5MG1ESU1UYXBoUUNSQlg3c2tPLy8zTzVoR1p5?=
 =?utf-8?B?VkwxQmcvNzBkcHpDYktQOHdzK2pqUFNmTUxwdGtIZFRobEduN3hqOFNHWUdQ?=
 =?utf-8?B?UzlVMzhQdzBVL0ZhTE1JZS9jcjZPV0lnVW0vREE0R2Q1TnlyUit5SlVpT0hs?=
 =?utf-8?B?L3hJMnZGSlJ5U3JkdDFRajlIa0VpVklqR0sxdDBNajRCa1k5cE5weWliQk92?=
 =?utf-8?B?bWlFdUVQTm1tV1B4MFUwd0xQYTZ0RjF3QW40VXlSMEJlb1k0S0ZVVXFoVFZx?=
 =?utf-8?B?dCtaejlQS1dVeUtBaDJ1azllZ3lyNTgvSHdpc0dCTlY5UG51c1FTRDFYVW03?=
 =?utf-8?B?cm1WYUxPR0x1ZHF5NURHMm15RThtM2x6YTJ6eGQxc3VtR1lRdUtoZWlPS1pE?=
 =?utf-8?B?QXM5TnoyYWlEek9mSy9wYk5mQ2J2OEk3VmZLZFVNcEZHekl2UXhEb2o0eWQ4?=
 =?utf-8?B?NTQrbndvemxRK2txSkhNcWdDVjJCNUQ1ZFJYUFpBUjQzNTYxNVA4d0ZTNFQz?=
 =?utf-8?B?Q2o3T3NVRWhqcE9WTm5iWG5PbkFmUW1lZXZDY0lENTdMN1pWdzNwYjJxelhs?=
 =?utf-8?B?bUtkNHlIYWhLV29sRW02bFBTVFFCTDljSHR6UTBvTExIenBSb1ovdVg3bmRy?=
 =?utf-8?B?VmpodzB0cUkrU3VSK1FaQ2ZhYWU4cVpxdklSNEo4YkNxNVY2Uk5ZL3RwbXcx?=
 =?utf-8?B?Z3ZsWHRLRmRyQWhKSTczMkRaYjdWVU1kaXI0Zk5ZWG1QK3lyOG1yeE9zRjhQ?=
 =?utf-8?B?ZDlFMWtRNGR0ZlR6WWZFNUlGd0dzcW9xVHdqUm53YzFRL0tJT0VXZ0Vab25l?=
 =?utf-8?B?YXNpTjUweEYwM1ZWVXhTUklCZEg4bGVUZERNMnJLdTdvUnVIa3pVcmNmajJ5?=
 =?utf-8?B?YlZNNmw1c3VNMWtKVm5jbzREODNFTjgxRHJBRjFFdDRLem1EWWF2dGN4bFpv?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3c4ae7-7d89-4747-3b07-08dc91706792
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:31:54.0974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3E12Zoozv+ZXaObqzcsJ9vw+zDcQhdk00FeXlXynG/P/51xp4326biHG7GrSmzI47K6dTivdm7Qfifku63Et99V+5BzdkBOa3pRa6ZeRMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6152
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> Legacy resctrl monitor files must provide the sum of event values across
> all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.
> 
> There are now two cases:
> 1) A specific domain is provided in struct rmid_read
>     This is either a non-SNC system, or the request is to read data
>     from just one SNC node.
> 2) Domain pointer is NULL. In this case the cacheinfo field in struct
>     rmid_read indicates that all SNC nodes that share that L3 cache
>     instance should have the event read and return the sum of all
>     values.
> 
> Update the CPU sanity check. The existing check that an event is read
> from a CPU in the requested domain still applies when reading a single
> domain. But when summing across domains a more relaxed check that the
> current CPU is in the scope of the L3 cache instance is appropriate
> since the MSRs to read events are scoped at L3 cache level.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 40 +++++++++++++++++++++------
>   1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index f2fd35d294f2..c4d9a8df8d2d 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -324,9 +324,6 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   
>   	resctrl_arch_rmid_read_context_check();
>   
> -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> -		return -EINVAL;
> -
>   	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>   	ret = __rmid_read_phys(prmid, eventid, &msr_val);
>   	if (ret)
> @@ -592,6 +589,8 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>   
>   static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   {
> +	int cpu = smp_processor_id();
> +	struct rdt_mon_domain *d;
>   	struct mbm_state *m;
>   	u64 tval = 0;
>   
> @@ -603,12 +602,37 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   		return 0;
>   	}
>   
> -	rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid, rr->evtid,
> -					 &tval, rr->arch_mon_ctx);
> -	if (rr->err)
> -		return rr->err;
> +	if (rr->d) {
> +		/* Reading a single domain, must be on a CPU in that domain */

(nit: Please let this sentence as well as the later comment end with period.)

> +		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +			return -EINVAL;
> +		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> +						 rr->evtid, &tval, rr->arch_mon_ctx);
> +		if (rr->err)
> +			return rr->err;
> +
> +		rr->val += tval;
> +
> +		return 0;
> +	}
>   
> -	rr->val += tval;
> +	/* Summing domains that share a cache, must be on a CPU for that cache */
> +	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> +		return -EINVAL;
> +
> +	/*
> +	 * Legacy files must report the sum of an event across all
> +	 * domains that share the same L3 cache instance.
> +	 */
> +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> +		if (d->ci->id != rr->ci->id)
> +			continue;
> +		rr->err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
> +						 rr->evtid, &tval, rr->arch_mon_ctx);
> +		if (rr->err)
> +			return rr->err;

An error here means that the hardware does not have data available to return. Should
the unavailability of data for one domain be considered an error for all? Note how
this is handled in mon_event_count() where the error is discarded if any of the monitor
event reads succeeded ... should this be done here also?

> +		rr->val += tval;
> +	}
>   
>   	return 0;
>   }


Reinette
