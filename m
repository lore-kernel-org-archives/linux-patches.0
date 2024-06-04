Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E1A149006
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717524207; cv=fail; b=MkbYobt1dB8Dnwbhp3Fzfg+rVoyEIbJ7PBfilU1Csu9AXOcr8+eXBzTzk1hTUmLDYprTpnQW621pjKEQg59Tdd3GygD0X41WxnbXLJYkNrCTGFcrkfguO/NLTUDLluGj8+Ga1GYufdpexcoabO+hSp5sb7CCKeDnuyU4hkqlGsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717524207; c=relaxed/simple;
	bh=ThtgwptN8kGkw+NzwPXs9uDjhu5yUddS9juIjyFblbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dAn/gy5maX/f9+YkG8jge73ITLFY7GKpNIPTkkj9pO4v10paaYfVnAb94rI7YP36qz5Z19rxRGKR7AWzMHnawUorS0TF1gZU4QyOglXeiRVD1HsPJWQkklgA1on/BZ38IYqJ8Fbx6DMzWqonwhmoQv32Qt7WWibavrloFZ5C6H0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XlJKSQbj; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XlJKSQbj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717524206; x=1749060206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ThtgwptN8kGkw+NzwPXs9uDjhu5yUddS9juIjyFblbc=;
  b=XlJKSQbj7SjKolxGiJ8T4LjT4LnksYvpNA82qidCx6e9FnJ7ifqUCuox
   AzTZr3mNwdvYlhWzQ+rdti5KnwN0digja6GtO2EdCJ3YI+zK4Vsjt8sW2
   Kv3zYu0c3kQNOGnztWEQSEoGtTZ5LLU9/sz9nQJJoktlAcWVi8zhOreZl
   HHrHvQPkViXuwQHmD/NcmEXcv0Brj+zYMQAo1YqW71AvEWxT4OLaDTqmH
   2N5ubsGozEWVnHktbo/506hs/bRn6EqzCUZKixuGjAUwqIjl7EhAtYO+q
   UC0U3AnqqKov/vo6e0r0wpI7/PkvWo6PE9LWiKjqtjclvucGSGQmj3ypt
   Q==;
X-CSE-ConnectionGUID: FkQSwgDZT/Crp6hBP6Lvrg==
X-CSE-MsgGUID: Q/I/62tdRmClOfve+F8eBg==
X-IronPort-AV: E=McAfee;i="6600,9927,11093"; a="14248334"
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="14248334"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 11:03:26 -0700
X-CSE-ConnectionGUID: A9vXLylsQFGL5LLnUZAdMg==
X-CSE-MsgGUID: mFxvos+lRUSu/5MYuty6CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="68135948"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jun 2024 11:03:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 11:03:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 11:03:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 11:03:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 11:03:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9ZcNd+KQzVSfZgdH3Sv9eZRB/+J1GCO6l4JGg7kOdQPO2TEsnt7XWbONMGpTjDVG3WS7xPKcVgv1AQ9y7WxozlC4TKQf9E9Cv7O7ezsLm9tOCVlsL/zUFLVchiQXrTVLR+D2jOWQXhIoZ3H3g2a35K9sHpI5Z0sWQwc2SCxswR44Y9toeFtmjYQfxM5dXT5dTYfI9zE+/fqd5yQw51++vF13EyC+I3UxiHLisw2DzdZmM9vCgibUPHfxyByuEkcQw4IaGtoi4GhstGG7fcY0rSuSDzkhmRzgN6UgfURzB0U4sZAWH7hoFCb79Gv3q4g4s2t3e6JFsq7Wt3y8HNdow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThtgwptN8kGkw+NzwPXs9uDjhu5yUddS9juIjyFblbc=;
 b=naR4QXgDgOSyRIPZA5yV+2Yi0BHNWhSoIURuovNYwiD6x1gObtuOtohZo5tJD8koNnBjtUc/LRAvD2UTAOl5CRiFms5UYETRdDRp8UJBNTETnAwnXS9iYVerAKR7/sRHT1z/1LxVKD6Nzn7R2ekY9OVRVtHEup5RXqhm3Ycx+9y4TaJ46BlPlxdYHkiMkCH30kauJagMEeo+HtA5947J5U0ou96K5akBnr4cYEM6zodmZe5mCHrSbv6vbsabA/diK91w4N95Q7LCWdJK+7iBCDvUMVat7i+Jpo9axV672VVPoGIB2sf7vq93N4PQSLJpRMxtbxPOoVRVARuYlEKhWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6449.namprd11.prod.outlook.com (2603:10b6:510:1f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Tue, 4 Jun
 2024 18:03:23 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7633.018; Tue, 4 Jun 2024
 18:03:22 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 3/3] x86/resctrl: Replace open code cacheinfo search in
 rdtgroup_cbm_to_size()
Thread-Topic: [PATCH 3/3] x86/resctrl: Replace open code cacheinfo search in
 rdtgroup_cbm_to_size()
Thread-Index: AQHas5TOO+7aVjyBe0il+ukHOv2QMLG2WpQAgAGQwBA=
Date: Tue, 4 Jun 2024 18:03:22 +0000
Message-ID: <SJ1PR11MB60831325BBB492294E60B510FCF82@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <20240531195720.232561-4-tony.luck@intel.com>
 <c11a323e-1703-4fc3-b05c-c12f6fbec63f@intel.com>
In-Reply-To: <c11a323e-1703-4fc3-b05c-c12f6fbec63f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6449:EE_
x-ms-office365-filtering-correlation-id: adbf7ad9-4a61-48bd-1e49-08dc84c09f5d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?R3AxY3V6ZkQ0YTREcmpUWUhwTW1GcnBZQWYzaFRTUGVneEFSL293eXNHVCt6?=
 =?utf-8?B?azJOS1RuQVB6VkVHUjY5S29VN0FTbVEzSWcrcHNrcEFNcnd1ZXdnMkFqUmRO?=
 =?utf-8?B?dE1teCtQai9zQUdjOENJOTFDaXNXTmQ5TlpxNjB2TjNWZTJDbDZiTWdxeDdC?=
 =?utf-8?B?OXhtb3V5NjFTYy84UThtZ3h4MXZrdDZqYzZOMk5KMGczR0wxWEFFZFU2ai93?=
 =?utf-8?B?LzN5cElPU0RRR2d4NmpBYkRkS0hlTXpZd2gyL3ZPdUxjMWp4RmVtcXlHOFMy?=
 =?utf-8?B?T0hGWjB1Mm9IVklmd05yS3dNTG11ZFpETkxtVGZrT09jMkU0a1Y1emxLN3ln?=
 =?utf-8?B?Yk5SQzJ2MDIyM0wwajJ6bFUzaUFONWtUTElobFAwR1lXQnFNVG91RzRJS1BB?=
 =?utf-8?B?NVJ5MnVjYzZTanowZGdxQ1NPaTR5OGtpUDN6cFRwaHZTMC9EWWFxcEo0Z0R1?=
 =?utf-8?B?Z1dhQXN2VEhWUU5hdSthZk1EK0VKUGZqbzhVUlJaMVVEREo5emU2dnJjN2dr?=
 =?utf-8?B?aXFNVER2bjRoc21BNEdwUFpjaVBkUHlhcDQ2YXFTeWFpRHJGU3FxMmIya1dx?=
 =?utf-8?B?cmIrRnd6d05NQkY3YmJpQzNhQTkrVHQ1M3EwcFY2dlFPR2pITTNZK2hyaHZa?=
 =?utf-8?B?TnhWYmdjOGVPZkhnTUVsVGlaWmhka3VMM2ZlNHV1elBIUHFxdkVnSmxNVmJJ?=
 =?utf-8?B?dXBDY3VNbVU4UllBaTBZUTAyL1NqR0lKMmp2eGlubkZ5aStiam1HdG5GU3RW?=
 =?utf-8?B?N1J2L0hLcERoNEtCSWZ4UkVWazJJaGMrZGRFVzV4dm9Vb1BFbEU3RmtWdlNh?=
 =?utf-8?B?MnZvTXlqc2w3bzNaQWFKcmNjcm9OWHBJait5MUZlWndBYlpYcU5FRmVsdzdh?=
 =?utf-8?B?cGtUVVpvekc2S1VHUFhoOURNSndUbmRwdnJmUG9QQi9PK25qM2VST2wxTzhp?=
 =?utf-8?B?NTRPdllNanhHUjNwVjA1eTZWYUMwc2UyZVNadS9PbjhKSUVoN2dPRmtuQm9D?=
 =?utf-8?B?b3pOdmhQR05NOUoybUJSSTFjZklFeEwrTnAvS1hSdU9HMi9ZMnc1Z1Q4NHEz?=
 =?utf-8?B?QVpsN3k3VWRJZWgzQmJkSFpWZzgreHUyZGZLTzlZbWdyUnpRcDZSWEtWdHhY?=
 =?utf-8?B?c25KNkp0NWo0OSt0cUFKMll3bUlVTVZBL0MwUG16WW9SeTZIc1htSDZRZG53?=
 =?utf-8?B?NVlHZi84T1Nkb0lrblNhNkJEL1ZNa3Jlc0hmS09uaUJUdG5ENFBiL2FweHQ1?=
 =?utf-8?B?bVFiN1hCa05RaHZXcmVvNE9pM2JpaVlvMHBHZTFvL1czd3R3MW5jNXBoMkg1?=
 =?utf-8?B?N045bGxUYnBKTDQrYUJCQTNHdTVTbVFpbC9GeHQraTdtbmpUN210V2NEak5L?=
 =?utf-8?B?ck1wSzU5d0MwOE9DOXhNSTMvQzZyKzFKS1dyYnI4ejZBZ0hJdkMwQUluZkp3?=
 =?utf-8?B?cVZPVFRFc3FpYlFOUGZVM2tmcXplVncvK3NvYTU2RGloQkdVT3U2Q1R1Y1FW?=
 =?utf-8?B?WEhDaFdaUG9Id290Mks3aEk4cE5SRkFmYndSQnZ3YVRQc2tkeWNpeStCRjRz?=
 =?utf-8?B?TXFva0I5SGQ2T2hiL1NUckFoZEZyZVoycU43Y3pURzMwenhsMHY4eStOMTNi?=
 =?utf-8?B?T0NWODVPL3FUenVQNnFPeE0wTHkrb0VmT0MvS0VBTk1tQVZWT1pjeW1BV3Fa?=
 =?utf-8?B?YkxraDltQ3VNb28rZ1BVVjRhMmQzRkpIT1NWNTBCdXV4QllDeTIxSGNnZnpZ?=
 =?utf-8?B?eDJLY2o0TTdJd2F5SitIeTBOV2hrSVVLd2JuemtGa1daTGh3b3cvT0tFR2pI?=
 =?utf-8?Q?/I5PH0DwRB8wMc1PmXrqGgUotIIdbpFZ7OuHw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1FnbWFXSFZlS083bmpWV1M2NFBQa1V0c3Q3dXZ3V084cWZ0T2hTeEdaNFRu?=
 =?utf-8?B?ZDEveFBpSXdld1BaUDNybDNyV2gyOWh1UzlXSmphMDBWREw3MkZYUDRPWlNp?=
 =?utf-8?B?QmxvNlBuYzEyWml1aFBRYldFeHU4NUxWUXdRNEdnc2dDYkJNaVF0R0xDM1pZ?=
 =?utf-8?B?QThXZktRZEtTbUg3TTZ1THNGaWZTQkpaQWtpQllDL0VZbEZmQVk5dnU4SVNz?=
 =?utf-8?B?MDRSdm1oUTkzcUJickszSkNaSTFiRWd4blB2M1pjZmlHR3BkdnZkQUVsbXJM?=
 =?utf-8?B?bUFqaVQwVm1BaUpSamFlajh1WDh2eU1waUNsMm9yaldLUU1sWkFaeTlHNmQv?=
 =?utf-8?B?eld1MW1iQkZhaHlnR1hNb0FaR2VCMkZQdmpPSzh1bllWV0Z2RHBOcjNsY1g4?=
 =?utf-8?B?WGhQTzRlOVRoQWYvVndJdGVwL3ZuRGdyZDJGQ2wxWFgvekhudVpRWkkzdmlP?=
 =?utf-8?B?SGNGcXNKejM0VmtNdk5zamdIMlpwNDhrd3Q1SHYvNXhuMjNUZE9VOU4yWC9T?=
 =?utf-8?B?aHBpZk9vbktiSFZKUzFtUUhMTlByTjlwZ2tmSk51d05VS01Mcm10ZUw3eDhT?=
 =?utf-8?B?akxFdit6SWdIenRLSUJzVGRYTVFpVWo1ajU2MGNaUUxSNTdEbDVBQVkydGp0?=
 =?utf-8?B?SFN3cjVVUWh2Rmg1cUpPeEhpdnR1MU1lMEZhOGpidE9ZTmh1cU5sK0dZUzFI?=
 =?utf-8?B?OVI2VFVzU0trRFAreUN0Q0tEQWtwMFFMeFU3Y2k2dDZpSDRxV2ptMjlBY3Rv?=
 =?utf-8?B?MUlsMHM5Sk5VaWtld1J4NVpHb2MzSzVnQzlvZXNrQUovQVZYVk8vZHA4alFH?=
 =?utf-8?B?WFlZeHFhQU9VZTdKQmNEUVdxOW5CUDhOT1NwRDQ1SlJHeHFpZEM1VUszVWZx?=
 =?utf-8?B?OTM1VjBZUjJCYXNDYi9KVzlNZ1RGdnFEYzIrbnlLNEZiQ3Noemxja1hNRTgy?=
 =?utf-8?B?bExSTzJzR3Z6bmtuVnZBa0tIemRCei9OVGE1UlVjWEtUMlBETENQTmNzZnBG?=
 =?utf-8?B?UUQwWUlISng5dGVkcHl1UlRtaFE2NHdSK2V2ZHJ2czd4WE1EN1dFSGlZVk5n?=
 =?utf-8?B?eUk2eHQrbi9QZkNRNGxZdW9hK2ZCWUEwcmt5WjMzdXNaWnlNaklXbVc2OEda?=
 =?utf-8?B?ZU5Zdjg2TkRJQ3BaUlNxUzBielVlVVkvakVOWU5EQks5VmJ0VUlIaU44Tzhq?=
 =?utf-8?B?aDFVdXRwdmhQOGdiZU15VFFwdlRFSjA0WWNtL2h6bWZnM1JxTGZKWk5zVmlU?=
 =?utf-8?B?ZkNubnZhVmJJSHdUdXJtdHNyb20wT3N2dENHYWJpS1BLMkMwMUNBVjBzdkZz?=
 =?utf-8?B?MUtNK3o4K1RhZWYyem9iTDBPdVBCS0dsRDh3NlhiRkdwUDBwUDQvNnVxbG1y?=
 =?utf-8?B?ekNteklvZEJycjV5dEZIMEMwOGxXbGpCaGhNWEs2WGlMTC85eDR6dngwWjA3?=
 =?utf-8?B?anhrRXRXdlpPZjBLb3ZFZjFFa3NqSmRrN2xoaTYyUWhHWTd3a0l2bEZjREV5?=
 =?utf-8?B?MmRDMi9LdUd0dzViZWw5NE1pUEJINk4rTklGeVR1TDJ2alF2V1ZVWmVzZ0x2?=
 =?utf-8?B?ODVpM3ZkMEVIU2V5aEJha0tQNnRuRzhvZnBTNmFBSmg0N3krQ1BQT25aeDkx?=
 =?utf-8?B?WkZ3cFgyei9qRkJhcnF1QTdzcjlNcWlNc3lHdVV4eTRyN0R1R1dsRWt5WG9D?=
 =?utf-8?B?VnVsWHpDdTNkT3BEWVF3aDBKc0x1akN2VHJvZ1o2UUFUNVJBVHRIUkpSU2l6?=
 =?utf-8?B?ZktXbXNnVk9yV3E2cVBrcWMrR1F6UCtJWHAvQUp6a0FzcTlXK0FBZGVtbU9v?=
 =?utf-8?B?QjZUM1Eya21nWURNY3N6cm5iYzRGYUtQank2ZWs0S1NXZlJWeEFMWldDdmRy?=
 =?utf-8?B?cHJjWjZvOERQZlU2TFViNy9ETERabWpDVWltSmdxUjRWaWZXSit5WWdneEM3?=
 =?utf-8?B?VnZVb05vUGRNR05ScFBJSjg4Wm8zL1gwTVUyVzVXeXE4YXdWVjhWdE1rbzdt?=
 =?utf-8?B?R0lHdVNUU0NHdkMxUXhiQ2xqQnh6WjZSeTNOZkdFUFhjWndUeHZOaG9DSTJo?=
 =?utf-8?B?Tkc0WklPVEo1eU83bHpWR29NWHVIeGRFVWZycFUwOE9Nb2QzRll4eUNJYThT?=
 =?utf-8?Q?11J/6Ed1y5hbUROqT7ADFVNJm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adbf7ad9-4a61-48bd-1e49-08dc84c09f5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2024 18:03:22.1708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EmfPeaLAlV/lQcPn2dFJzkXs0Cp7LS1rNEQH9Lh3D2iiCqdKA0FYh5cKuqaU85i6UPRCSB01DekfvFP8iqPhmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6449
X-OriginatorOrg: intel.com

Pj4gU2lnbmVkLW9mZi1ieTogVG9ueSBMdWNrIDx0b255Lmx1Y2tAaW50ZWwuY29tPg0KPj4gLS0t
DQo+DQo+IFJldmlld2VkLWJ5OiBSZWluZXR0ZSBDaGF0cmUgPHJlaW5ldHRlLmNoYXRyZUBpbnRl
bC5jb20+DQoNClBhdGNoIGJyb2tlIGZpcnRyZWUgbG9jYWwgZGVjbGFyYXRpb24gb3JkZXI6DQoN
Cj4gew0KPiAtICAgICAgIHN0cnVjdCBjcHVfY2FjaGVpbmZvICpjaTsNCj4gKyAgICAgICBzdHJ1
Y3QgY2FjaGVpbmZvICpjaTsNCj4gICAgICAgICB1bnNpZ25lZCBpbnQgc2l6ZSA9IDA7DQo+IC0g
ICAgICAgaW50IG51bV9iLCBpOw0KPiArICAgICAgIGludCBudW1fYjsNCg0KLVRvbnkNCg==
