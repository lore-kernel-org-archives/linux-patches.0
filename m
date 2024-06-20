Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B597407A
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 22:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718923339; cv=fail; b=QMfTHxw0BW6uTxRDYtzIsmViN4e5jalttcV2RG0oLYPKeAOOvR7nrUxLa7O55ydFFLHNQOPT4+9W4PP415Q0g21xL7hVMUhIa8jkiN4Pj+tZTyr82MXBY7CeK4r9X8baCoMfEzxsv4bgkh4ifU/jZZw5aIhTQSvjSunltYllwGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718923339; c=relaxed/simple;
	bh=6uVMRZg3I/5ewvpgqdhxqW9xX5Kj2fSvfCAXcdxyHLc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PTTifnbOYEJNfwK8P4SIUdjKjHUJ++PIhQJyQL7GN/lgo3Svwlk65i+sAgJh27z/aQ1aM9+hcCPbJSWNUI3zovvb5nyCsuHjdHJQ48AaJoqKO3LT+Ydm8DaFIHaAZw/lWPQFfOwBDnC5WzOlirmi1f7qq77Mv2B8MBolqUvSvvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iq+pRnPS; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iq+pRnPS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718923338; x=1750459338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6uVMRZg3I/5ewvpgqdhxqW9xX5Kj2fSvfCAXcdxyHLc=;
  b=iq+pRnPShG2dy27As9GhwMatPiwmPrvhA/zfbzY8CvLO5Sbv2oJVGLTt
   IC5VXoPW6EK1xp8y2UkK2nJ/MNSf4EDgLwN5r2xgmzgd+6VQv5+xu8vmI
   O0M5NEqcRNSfStuPtyxnz3eoNPeSo5NCLlfxJWb4MSGvqBIDq1UmQ5bKJ
   OoyzxqQoHan8BnL3tNAf3KMBwcHurCusx1bHGULk0w8m/iUlOaaI0pEO6
   8CPSyWjnOvdzc3BYXjOfL5jfpUeLUu42JT4TU8tebI9TladuoP910FTCE
   MRXc7pHDVDHxBPkKoyCndqkdLklwFtoqQqDuN1hrG6yBnetAo0OcFnZW5
   A==;
X-CSE-ConnectionGUID: WFD0b5ORQXytt1y1aS+U6A==
X-CSE-MsgGUID: zoFrJlY4SKW7Qo9c03ma7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15696650"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="15696650"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 15:42:17 -0700
X-CSE-ConnectionGUID: Aw9LS1rFSJSlDYOz0H/QeQ==
X-CSE-MsgGUID: qBGDcISwTfW4WGWfH3R4kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="43079067"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 15:42:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 15:42:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 15:42:16 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 15:42:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnNm3LlxUo9tXxT9ktuRcUQt41pAZszCE+k9ry9uMd7gN74x3+KRXeqrYIa/KpDvnYghEZCEt9peHgXvFCPc3xSlCWdiwhDzvOwEmwndPrz4SXXXUk7cBKXybPbjcCna9R5Zdn7qOWpwxtK4XMrV4IJg15kk97/hNnxWA5cpfUrD5DrEJBXEXVux8KX/YPcM0tR3brh/DCWSQkBTK/G418+/Bvy3u6TVCi8T1qEUxR+ddrUEvTN90Cjg6YW3a96/EMaW/1bSiJ5K1lYkpj0qNAid3DRtaL5VTTNV0JIZZBpL+AfxO90aumDV1T62QQ4rHTK/0OL/gFh7q6R66O6GyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uVMRZg3I/5ewvpgqdhxqW9xX5Kj2fSvfCAXcdxyHLc=;
 b=kfscdMGVaj1mLqcntRjl37h4uN2I0xVn2rilmTV/iznMbCy00l+G5UVwBpm/3KWrSV5C6q6aJHwV6wXuigGI1EYkzMr94r+zPIcY9KJxmbZpp6Vz+VjzBPlGMOB5qvj7dUz2LqD47jpcEHm/HeD3ScCo107v2Hl3/YVLMaD72niNYIUo2gGU/9Ei49ol5YynX7DKo9mptYz7QWDP2tBimGj4PrDswEVuRv1BY2xwTtdF4F/qrB18Xs1n9beh3cFwC5jdGpiDVrsdEffgXqEJiIKsxBVlvp7TPnf07iHRZLM3T5bWkf4QISO6pFNVghXYhbKIlolqdlhJJwzz0ocUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Thu, 20 Jun
 2024 22:42:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 22:42:12 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
Thread-Topic: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
Thread-Index: AQHau2UDun5MbjmM/EypFZCVcSKIObHROS+AgAAUVTA=
Date: Thu, 20 Jun 2024 22:42:12 +0000
Message-ID: <SJ1PR11MB6083E7C6C3FB2345A2495480FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-10-tony.luck@intel.com>
 <1bba8391-6ee3-48aa-935f-b9c08bee049b@intel.com>
In-Reply-To: <1bba8391-6ee3-48aa-935f-b9c08bee049b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MW3PR11MB4683:EE_
x-ms-office365-filtering-correlation-id: 046c4df6-c7b5-487e-2fd4-08dc917a3a24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|376011|366013|38070700015|921017;
x-microsoft-antispam-message-info: =?utf-8?B?VG9ObHVESElzdnYwcnBaeG8rKzZHUTFRazZQMVMxdkR2TnhVV1lwM0lqeDNG?=
 =?utf-8?B?TUlDaDBHVi84SVp4cUpQTTJ6VjJGUm9VOVJNbElGWElpVXN5TVpKd29BdU5j?=
 =?utf-8?B?Z3hFc3pZS0dka2k4WlFxdVhmU25NYVFyOGxkdENmc21ZOWNiLzFXVmNJenZS?=
 =?utf-8?B?RjR5NTg0RnkwK3BjN2ZpeXpMVnUxT1hZUS9VOVdQYyt3NTBvVVVveGEyalZp?=
 =?utf-8?B?QURvV2ppRnphOTFJNktNbDdsYW1RckJhczRhay9rckM3SnQ4Y0xNMm1ldktB?=
 =?utf-8?B?anBOek80RFRyTHozQ3FDanlYZFloczlKT3RRUUY2M1d3TWNxdW0zbFBrTjBq?=
 =?utf-8?B?bjRNSE5vNiszZXZKbDdzV1htNTA0RmhVSks4M1pNNGtUZ1FINVFwbGpNS0ZM?=
 =?utf-8?B?ZEZ6a3ZFS0NIQ1VKMXprV2x5VW4vbWt3enZvck4rTk5wVHFXYzVjUm5HdmRE?=
 =?utf-8?B?MEZOR1lFWkVGMG5VeVpGRmFER3RraU9DU25EcVpaMk1VdkFzSVVRdE5laW1D?=
 =?utf-8?B?WllVY296YU8xQWZNTyt4YnEvazhScUY2UGEySldFOWxRR0tIaHRORDRobUtL?=
 =?utf-8?B?bXBvL0lKWkdBeTN3Vm5PT1F3NksvOFJSL0FKZ1VzVTNYOUYzU1ZZVUFaZDZ3?=
 =?utf-8?B?c05kdzQyRWZWSjVwdWpXNGkyeHRVUkFsZldMWjNOQ01RSVJXcmROaHpRaW5V?=
 =?utf-8?B?aXUyMkpOU24ydjJwUFhTdnRjNGRZZUVSWmowcWYxV2tGUVNmR3VibWFUZGg3?=
 =?utf-8?B?OWJQbkltLzFBQjcrS2ZoZ1V6QmM1dkVoZnlGaXpzcFVCcG44cDVoSUhuaURY?=
 =?utf-8?B?eGdScC9HWXJiN2dHUlFveTdGNExqM3BHTVJCR0t3ZFVTK2dQaE5LQ2FJZlQ3?=
 =?utf-8?B?Q1lwT0ppR0YzUTRieTZ1bi9YSDdKVS91c3NTQis0ZFFqRjMvRFpjU3MwcXFv?=
 =?utf-8?B?bnBmMVVwbUhNQ0hJVTdidWtrbGt4cVNNaTJTbGZ3RkZvTUhPM3dkRmJpL3Q5?=
 =?utf-8?B?KzlQUWNhQmwxc2RPaGRTbUlGT1BDZlR5c1BrY2dvbEtyL29yRWV5STRBYkNh?=
 =?utf-8?B?YnRhRE0zck4yM0JyMVJNVmNvdlVXOVoyR3BsWk8yQ3NWTnN0MnpxamZjcnEr?=
 =?utf-8?B?bWFZY21FZHBEK0N0WmlyVGZpNnBlZFNicDh2YndOV2dTdHZJT2RPU0ZmaEJt?=
 =?utf-8?B?TS9WRjJYazQyZFc5cW1zTU1OU29hcGdFcTEveFVKUGk5TmN5MHk0ckUwVjVZ?=
 =?utf-8?B?RS9Jb3hOUzh3Z3kxWjh3WldTdEYydHdmMDFvTCtUS3MyMTZYdTFYVC84d3Jv?=
 =?utf-8?B?bVZzVUJjR1lyUTY3N0t0VXlnTlhFQWMvWisrZS9HWGpxZ0FuUmtOUkRuNzVM?=
 =?utf-8?B?THI1UVNueGlzQURnS3BYWEIxS0htRHBOam9zdWhSdHNvblcxVGhwNW5RRmky?=
 =?utf-8?B?dE1aSmFMYlJ5dCtwRlpMRFlsNUZDYlhPeDVQZFFOQTJVZXhCQzFFcVRFamov?=
 =?utf-8?B?Q0ExSUh0cGhMc3dvL0dTMTkzcmZZYnZnN1EycmR6Q3plbDVYTERLN24waTJ2?=
 =?utf-8?B?QTJWenFVVFhyRkIxV09LZlYzSFJIM2tHSXFzbWY4b0hPU3dSOTEyQ3hSZ1pK?=
 =?utf-8?B?bTd1QzFFdloxdGd5MTlCNks4d3RJV1ZPbC9rRng1QUh2ZmI2WUZ2aEpWZ3lp?=
 =?utf-8?B?NVhHWTRsNERCNVNWYUdsWlYrazdvZlFPUGhYRE9lZDhHSWFFM0ZwVisycHhx?=
 =?utf-8?B?ZVNaTUZ3SXFYRTlqUGpmb3poVGxST2lsUzFlSWtXcWo0b3NRWExLbExlSXNG?=
 =?utf-8?B?Wk1pRWNRSDR3QVlLb3dEdTNhN3BFY3FxM3FlZ3pxc2p5S0ZhTm5rLzJOdlo3?=
 =?utf-8?Q?WrVgedlCql2D6?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(38070700015)(921017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEp0eEVmeVJUblp6SUlwandNMERVYlduaTdRTUdQUEVzWFBnR1lQWURuZm9K?=
 =?utf-8?B?cTBSOXpPUlhVelArd2p2YVZMWkVCOS8rUXNPaEVzL3pKYlZjWVNWYnJtK0ZO?=
 =?utf-8?B?dktyanMxS1JCTTBndTA1d3pCc2NJUURYanpsRkxvc2Npdm9XdFhVQkZteFdi?=
 =?utf-8?B?UU5VUk5CNDFDWmpqZi84L1pGcjBmeTltS2FxenhsemJmSUFuVHVQdnBMd1p2?=
 =?utf-8?B?cWtOK2gyTWZNT1FhQ1NueCtUYlNuM21pWUpMN3JOZDRIRU9BczRESGRWT3FE?=
 =?utf-8?B?cnNLMjlocGpxaVgxQktzV1RGMm5nWmlBY2M0VFBxczV3NHRiaHZLc3NvVUY0?=
 =?utf-8?B?L3F3RDF5YUYzOTNNMU5IbE9jTXdrVWFNTkQ4TXZEV3krb0dRaU51RjE0cnZT?=
 =?utf-8?B?S0l3YnVaUXNPbEpoWlpGZitQQUw4aGRnM3dSRnZDMGNnYXNzV3dxSkdMWGJL?=
 =?utf-8?B?MmtNRFZpL3ZKSGQ5bFcyZ3BLTFhhU1JVSXJJSmtNWTBpc2ZvL2l0VWRreFhW?=
 =?utf-8?B?bjRwcjRoU3gzQ0FoZUUrdVJDQnkxcUNmYUVnK1JZbWZOenhzUHhKM2haTUp0?=
 =?utf-8?B?MEs4ejVuMkozQTVSYXl4enk2bHdSSnNkcUNNeEVLbDM3MkxJbFFsQTdsVkhC?=
 =?utf-8?B?clpwNEdsY1FTWTR3UEx1MHBPZDF2ancyOEdzQUJaS2NzaW00Q2h0NDBvc1pD?=
 =?utf-8?B?VGFSZTlTOTEwemFMc09qL1JoeDFZbXAzVk9TQ1VXbDVZQVZja2Y4c1NNdVZ1?=
 =?utf-8?B?Q0hVbHo3VFd3dFNtOWFUbURweW1sdDZUSk51WWpsS1dRb0QzT0tlR0NtN0tQ?=
 =?utf-8?B?aUZ2RU9BRVVEMXBEQlpsWFlZV1FvL1o0bFo5U0hIcTdidkNIOHUzYWl4Wm5x?=
 =?utf-8?B?bEcyWUlGc2o5M2NXSXdtbytLWFZySkxxZ3M4eERhNXBWQlZQQ3R0ZzQ2RXpp?=
 =?utf-8?B?aVFDdTkza2h0Q3BBUU5HMURsaUVSQTU3TGVnYXpvZUE5SlBYYk9CeFlBa0pU?=
 =?utf-8?B?U293cmZHazMzYWQ4cEc2TzBScWRydnFYK2c1U3duNTRaKzd1ZWx6UG1WWXZU?=
 =?utf-8?B?VkdaWU9HOXlWTU5BaDZOclJKNEpkZTFoTFdUa3N6Q1pUbUpQNmpxSXBpcWpa?=
 =?utf-8?B?eUZ3NnF2RUJ1UmttUkt1ZzZ5TmRqMVZCVjRrVE4zNzRhM0FOWEJqa1J5Ujd6?=
 =?utf-8?B?amNrVmxlMzY4ajhMNnFjeGJwRGJTNitYTVZ1Zkw4UnJGaGxDU3EyeHVIWmlw?=
 =?utf-8?B?KzlIbGZqc3N0bEtSaHprdE05ckp5RUs2YTRVVEx5enZES1gyMEpxQndQdldl?=
 =?utf-8?B?ZitwOFg0ejA2WXQvU1NmZGJZZUw2dW5lK29iYlJNaW5UUmxLaGtHdzFVZGVi?=
 =?utf-8?B?dkM5a1JxeWROQlY5NmxIWEYvSWNoeW9DYmI4YzB2NEZSZWlyY0tuTjNsYjRv?=
 =?utf-8?B?aW1EaHN0M1NqRW5NZTZXWlptT00xZFNyc1dBYkVuZVpJcjN4amlrUHVCQXRL?=
 =?utf-8?B?NzliSlhPNXllYzVsUVJibmhPNDhKa3lNSWk3VGtqMkt6VzFXbzY1Sll4SW5p?=
 =?utf-8?B?clpMeTVCdWJRYjlhNnJBeXpSc1lscUN2OWZBOVhaQU4yTm1tS2xlL05sN3c5?=
 =?utf-8?B?aTRCdldZc1I3NnV3K1doeVN6cENiRjNXV21qdmJPR0ROOEpCczJMYkkyK09o?=
 =?utf-8?B?Y1M2MFk1TmgwN25DcDFETmQ2cmZIM0pmKzJIczh5YTdjYTU0QkIyK0FYK2Vr?=
 =?utf-8?B?YTRjaHdLaHgvVVYwcUtPbFpRVUZ5ak9EUzNjMHJwQUM1aU9zdU54aVQxYkdH?=
 =?utf-8?B?V3pPUDl5RzNtck4rbnR6TjR3RTUvUWRIcTNBdlZwRnNuYlRrbHpnK0FDeHVY?=
 =?utf-8?B?MXAwUWdCYTdSa2lRcWJlWDFMZCtKN0VzckNNdFA5R2h2VzJvYW1hMHBwaHpr?=
 =?utf-8?B?Um5uZEtNL3pmbnpZVEVsZWRxY1NKWXorWWd5R0lRaklvK3hqVzFzbURIYWJv?=
 =?utf-8?B?dktWVnBqc2hjc05QeGorTk9OQmVhUThLSFhaSGs1OW01bnZadUcwVldFSm5I?=
 =?utf-8?B?YlZxNFZkVHNKUVNPSGdhMHkvNkh0TExUUWF4RXRSQnNPWENqMEt5SlYvSlJr?=
 =?utf-8?Q?Srvz415UveFKDCP5oAdcZnKx4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 046c4df6-c7b5-487e-2fd4-08dc917a3a24
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2024 22:42:12.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dp7tqWxtmmKp+dNRe408/KFsttl2t/uJKlFwO2heeNXSmj7A3Dbt17S2cUmGWyFd6TKrKDCUuPSHvd3AOid81Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
X-OriginatorOrg: intel.com

PiA+IFdoZW4gYSB1c2VyIHJlYWRzIGEgbW9uaXRvciBmaWxlIHJkdGdyb3VwX21vbmRhdGFfc2hv
dygpIGNhbGxzDQo+ID4gbW9uX2V2ZW50X3JlYWQoKSB0byBwYWNrYWdlIHVwIGFsbCB0aGUgcmVx
dWlyZWQgZGV0YWlscyBpbnRvIGFuIHJtaWRfcmVhZA0KPiA+IHN0cnVjdHVyZSB3aGljaCBpcyBw
YXNzZWQgYWNyb3NzIHRoZSBzbXBfY2FsbCooKSBpbmZyYXN0cnVjdHVyZSB0byBjb2RlDQo+ID4g
dGhhdCB3aWxsIHJlYWQgZGF0YSBmcm9tIGhhcmR3YXJlIGFuZCByZXR1cm4gdGhlIHZhbHVlIChv
ciBlcnJvciBzdGF0dXMpDQo+ID4gaW4gdGhlIHJtaWRfcmVhZCBzdHJ1Y3R1cmUuDQo+ID4NCj4g
PiBTdWItTlVNQSBDbHVzdGVyIChTTkMpIG1vZGUgYWRkcyBmaWxlcyB3aXRoIG5ldyBzZW1hbnRp
Y3MuIFRoZXNlIHJlcXVpcmUNCj4gPiB0aGUgc21wX2NhbGwtZWQgY29kZSB0byBzdW0gZXZlbnQg
ZGF0YSBmcm9tIGFsbCBkb21haW5zIHRoYXQgc2hhcmUgYW4NCj4gPiBMMyBjYWNoZS4NCj4gPg0K
PiA+IEFkZCBhIHBvaW50ZXIgdG8gdGhlIEwzICJjYWNoZWluZm8iIHN0cnVjdHVyZSB0byBzdHJ1
Y3Qgcm1pZF9yZWFkDQo+ID4gZm9yIHRoZSBkYXRhIGNvbGxlY3Rpb24gcm91dGluZXMgdG8gdXNl
IHRvIHBpY2sgdGhlIGRvbWFpbnMgdG8gYmUNCj4gPiBzdW1tZWQuDQo+ID4NCj4gPiBSZWluZXR0
ZSBzdWdnZXN0ZWQgdGhhdCB0aGUgcm1pZF9yZWFkIHN0cnVjdHVyZSBoYXMgYmVjb21lIGNvbXBs
ZXgNCj4gPiBlbm91Z2ggdG8gd2FycmFudCBkb2N1bWVudGF0aW9uIG9mIGVhY2ggb2YgaXRzIGZp
ZWxkcy4gQWRkIHRoZSBrZXJuZWxkb2MNCj4gPiBkb2N1bWVudGF0aW9uIGZvciBzdHJ1Y3Qgcm1p
ZF9yZWFkLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogVG9ueSBMdWNrIDx0b255Lmx1Y2tAaW50
ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL2ludGVy
bmFsLmggfCAxMyArKysrKysrKysrKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0
aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvcmVzY3Ry
bC9pbnRlcm5hbC5oIGIvYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL2ludGVybmFsLmgNCj4g
PiBpbmRleCA5OWY2MDFkMDVmM2IuLmQyOWM3YjU4YzE1MSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNo
L3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvaW50ZXJuYWwuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2tl
cm5lbC9jcHUvcmVzY3RybC9pbnRlcm5hbC5oDQo+ID4gQEAgLTE0NSwxMiArMTQ1LDI1IEBAIHVu
aW9uIG1vbl9kYXRhX2JpdHMgew0KPiA+ICAgICB9IHU7DQo+ID4gICB9Ow0KPiA+DQo+ID4gKy8q
Kg0KPiA+ICsgKiBzdHJ1Y3Qgcm1pZF9yZWFkIC0gRGF0YSBwYXNzZWQgYWNyb3NzIHNtcF9jYWxs
KigpIHRvIHJlYWQgZXZlbnQgY291bnQNCj4gPiArICogQHJncnA6ICBSZXNjdHJsIGdyb3VwDQo+
ID4gKyAqIEByOiAgICAgICAgICAgICBSZXNvdXJjZQ0KPiA+ICsgKiBAZDogICAgICAgICAgICAg
RG9tYWluLiBJZiBOVUxMIHRoZW4gc3VtIGFsbCBkb21haW5zIGluIEByIHNoYXJpbmcgTDMgQGNp
LmlkDQo+ID4gKyAqIEBldnRpZDogV2hpY2ggbW9uaXRvciBldmVudCB0byByZWFkDQo+ID4gKyAq
IEBmaXJzdDogSW5pdGlhbGl6ZXMgTUJNIGNvdW50ZXIgd2hlbiB0cnVlDQo+ID4gKyAqIEBjaTog
ICAgICAgICAgICBDYWNoZWluZm8gZm9yIEwzLiBVc2VkIHdoZW4gc3VtbWluZyBkb21haW5zDQo+
ID4gKyAqIEBlcnI6ICAgUmV0dXJuIGVycm9yIGluZGljYXRpb24NCj4gPiArICogQHZhbDogICBS
ZXR1cm4gdmFsdWUgb2YgZXZlbnQgY291bnRlcg0KPiA+ICsgKiBAYXJjaF9tb25fY3R4OiBIYXJk
d2FyZSBtb25pdG9yIGFsbG9jYXRlZCBmb3IgdGhpcyByZWFkIHJlcXVlc3QgKE1QQU0gb25seSkN
Cj4gPiArICovDQo+DQo+IFRoYW5rIHlvdSBmb3IgYWRkaW5nIHRoZSBrZXJuZWxkb2MuIEkgdW5k
ZXJzdGFuZCB0aGF0IHRoaXMgZmlsZSBpcyBub3QNCj4gY29uc2lzdGVudCBvbiBob3cgdGhlc2Ug
a2VybmVsZG9jIGFyZSBmb3JtYXR0ZWQsIGJ1dCBjb3VsZCB5b3UgcGxlYXNlDQo+IHBpY2sgd2hl
dGhlciB5b3UgdGhpbmsgc2VudGVuY2VzIG5lZWQgdG8gZW5kIHdpdGggYSBwZXJpb2QgYW5kIHRo
ZW4gc3RpY2sNCj4gdG8gaXQgaW4gdGhpcyBwb3J0aW9uPw0KDQpUaGlzIGlzIGFib3V0IHRoZSBA
ZCBhbmQgQGNpIGVudHJpZXMgdGhhdCBoYXZlIGEgInNlbnRlbmNlIiBlbmRpbmcgd2l0aCBwZXJp
b2QsDQphbmQgdGhlbiBtb3JlIHRleHQgdGhhdCBkb2Vzbid0IChtYXRjaGluZyBvdGhlciBsaW5l
cyBpbiB0aGlzIGJsb2NrKS4NCg0KTWF5YmUgc29tZSBvdGhlciBwdW5jdHVhdGlvbiB0byBzcGxp
dCB0aGUgcGFydHM/ICBEbyB5b3UgbGlrZSAiY29sb24iDQoNCiogQGQ6ICAgICAgICAgRG9tYWlu
OiBJZiBOVUxMIHRoZW4gc3VtIGFsbCBkb21haW5zIGluIEByIHNoYXJpbmcgTDMgQGNpLmlkDQoq
IEBjaTogICAgICAgIENhY2hlaW5mbyBmb3IgTDM6IFVzZWQgd2hlbiBzdW1taW5nIGRvbWFpbnMN
Cg0Kb2YgbWF5YmUgImRhc2giDQoNCiogQGQ6ICAgICAgICAgRG9tYWluIC0gSWYgTlVMTCB0aGVu
IHN1bSBhbGwgZG9tYWlucyBpbiBAciBzaGFyaW5nIEwzIEBjaS5pZA0KKiBAY2k6ICAgICAgICBD
YWNoZWluZm8gZm9yIEwzIC0gVXNlZCB3aGVuIHN1bW1pbmcgZG9tYWlucw0KDQpPciBzb21ldGhp
bmcgZWxzZT8NCg0KPg0KPiA+ICAgc3RydWN0IHJtaWRfcmVhZCB7DQo+ID4gICAgIHN0cnVjdCBy
ZHRncm91cCAgICAgICAgICpyZ3JwOw0KPiA+ICAgICBzdHJ1Y3QgcmR0X3Jlc291cmNlICAgICAq
cjsNCj4gPiAgICAgc3RydWN0IHJkdF9tb25fZG9tYWluICAgKmQ7DQo+ID4gICAgIGVudW0gcmVz
Y3RybF9ldmVudF9pZCAgIGV2dGlkOw0KPiA+ICAgICBib29sICAgICAgICAgICAgICAgICAgICBm
aXJzdDsNCj4gPiArICAgc3RydWN0IGNhY2hlaW5mbyAgICAgICAgKmNpOw0KPiA+ICAgICBpbnQg
ICAgICAgICAgICAgICAgICAgICBlcnI7DQo+ID4gICAgIHU2NCAgICAgICAgICAgICAgICAgICAg
IHZhbDsNCj4gPiAgICAgdm9pZCAgICAgICAgICAgICAgICAgICAgKmFyY2hfbW9uX2N0eDsNCg0K
LVRvbnkNCg==
