Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2922356E06C
	for <patches@lists.linux.dev>; Tue,  8 Sep 2026 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884352; cv=fail; b=XJSZBvfQvstwrEIkfMxZK6uupvoxLqBiIuSh4UKD+SdSSIjl5EZLCNTPzw/ls9RjmOXG5TRO8RmhXm6LLDetgiasosviFGG6V1LGr9UhihGoYV821g63l5Z7ONHpB0WpykK+DITPVBqGCOCR8v5/jSJieIMOxMOzimSWfecHOqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884352; c=relaxed/simple;
	bh=DGy1hAzzZ3o1dIJ3SV5WZfIQInk5v1e0tMx0r3dnONo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sIuRbgwWcllXagAhR8EmqE5kgeyovCodoXjmce+NpGGqwa2mf2+sW9YOClWZi8uxBe+fnXZNVx8vsTDYxojTZvn7oQdtDDiSgLSt+g5m5W9XmH1snfWfmzZeTZdh2T4o3QgWdZDsCmu3U+2tJ6PYDxiiTbUlGjcZ+tIb8U2tkpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ya+ZH0Ec; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ya+ZH0Ec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788884350; x=1820420350;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DGy1hAzzZ3o1dIJ3SV5WZfIQInk5v1e0tMx0r3dnONo=;
  b=Ya+ZH0Ec8fWI11nYKfUSFJq5J8fQZ5grzezQ8KZEMapyHfvHxl7jO2Uz
   PPtr1quf/4t4m1USw+XhKN3IolyWIqHm3oJS12F/F/G2mmrh3BgyV4iUz
   Qpmfd1mQrwg60BzL0m8VdkTnh5bN+lo5kDDXTIg467Ni4eUEAiikxkBgU
   jAArNDWvw5QFKfnzRRQFmbIprRL0L4xpc/lB0x4Xqs+8strHsZifXw8cz
   RCzW+q/s536/DMqU+m08tq7AbPsjYXwGIvVWVKYZJ/dX3aMg1edUdRkT8
   pj0pZGbSMXU7JpHWAC0hZCg0bE40Uv03H175wdiHDLYlbpNiaZDttxbr0
   w==;
X-CSE-ConnectionGUID: E4VFMmNfQDejHa7GYGgXSg==
X-CSE-MsgGUID: rnOAeCucRCqhvEVMrtifwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="106663027"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="106663027"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 09:19:06 -0700
X-CSE-ConnectionGUID: ofGTRBmyTLC8D1B5vxc0/Q==
X-CSE-MsgGUID: fC4BkbHTRFKiH5718qC2IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="274845938"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 09:19:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 09:19:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 8 Sep 2026 09:19:01 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 09:19:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQWHOa2WjrUT0g0N0KAOgl6RXEjHx/9eIeE4d/JZgsRHreiU5txSpEgDBpWSH0YSewetP9FAG8800UROVmeg9/hr4Gaf4aY6SRXggySgMZB/lVj3kgjIY+bFGwszWa1h/cBHr1otW8qGt6NhGz2/rkY+2+CcIvgMjVikfsBtCVU0803aBc/pKps6d9AgZWb66d7DKySCHWSM8WowdYYgtkeHhNEH9Yx3bKfoEiaM7TBxbvD1tHf6cXCkAfjs4xd30x4fhAVD7U79qys+h7AlYlPKKNvh32qDTb1R+Ofl4x72rIn6Mg+luychEJHMRJr8wYqZVBiKUqne4no/7eD6aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GNg3Ve6CFMC0FoIj3YLSPQqxRgzlXI5XKpXtSedHkg=;
 b=ykTkSlY3JLzU9NTm5bTd07O0o2Jpo1LGbmBxF+jOE7zhf0sXNnokqN06O9e+BO+xRTTBExSH+lm4gktCoo+lhjBDXhn6oc1YVezSNbPg1oXS1d6cFdLlC5nemlEm/zyLImhuC9uSpu0yDjDHjrff/PSBOXT2jOWiNhVZQrC9obbZEJICqd30uP3Tc/4tGBlydheCamIaNKNl97dKCix4IptWgQrHGEHcRJq/Z+skv3zvFl7aFPfE6J0AWFp7821ENi5fM/iZBWyJy+k/JX9b06wYPQJkFHXG4eU6qRWF6BAMurePfkSYH6u08TpMuA3Q0DhZq3LpBOzIQxyGRdzqow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA0PR11MB4733.namprd11.prod.outlook.com (2603:10b6:806:9a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Tue, 8 Sep
 2026 16:18:58 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 16:18:58 +0000
Message-ID: <d46d66c6-7a14-46ce-b4ba-57944b29932b@intel.com>
Date: Tue, 8 Sep 2026 09:18:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] x86,fs/resctrl: Remove "arch_needs_linear"
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <62904217290f2cd3225d8608c19e284d6dde3aec.1788452481.git.reinette.chatre@intel.com>
 <apo3lSWAQRRK2W_r@fengwei-dev>
 <35759986-3bd3-4ada-b2ce-434090cdc1cb@intel.com>
 <425a1c9f-7051-4baf-a884-65524e8f4fe4@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <425a1c9f-7051-4baf-a884-65524e8f4fe4@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA0PR11MB4733:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a47a6de-002a-41c3-0df8-08df0dc4e32d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: /nlrVXiz6Yb4IYOam7sYdsDfwGhJ/Mz5bf6URBti/Ju4069ykJ2HchCGHdS+uABVs0YRwUSgxfoS8FpS+H7xnaPqS/49MqFvsK8aGnYAuEz26QyBW0/+e9somQjD7Y+NMEsObNiazGeADkJfOv/U3UjA/8prwVq9imBKm/xs7PMpNPGv+63Emj6GiDtcAGX9upeB/5MxqF/FAtb4kApJYPTBWH2I3o9Tc2lK/SAqdxZuWGVNYsMUJFKBOLPPQLwZ6VMQhTQ2jpk9PYDwXbpIripZFVYbeMpyb4uNwJG9OJb5aFapvuJtJDi+YXbX9CWbij4Qf2HUTvQ5Fg1RTzglErfg83VtqbGPb57OBHTDPGYaHCap9a8LiNxKLZJyX9RCHw266dY3nRwl5PnZY7RsWukHYP14cI+7UNE7ZUh5qbsj6fclzAKpACzTW8BKBfk97w0Q8+6nbZ/HCE4NSu+X78NkQHyrdCwsD9K/KdkzGrj5b+SGr1LiStnfrcMKE0X9p/nNL6GQiJ22AxTUex7GJVaCFb2N+bMYUpe/Vtf7S1RIsPm4JH+9azVm+mjR44esgmEjnNDNgAFyAwCzJZKNhVEBnErZTztDSnumbUAI3JnJLmv88yZs5RE9NjsHX7byvtCTgQUnb/rL/vmPfi4EbgW7k87ZigwRFWyEtb2Rz8c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFQ1YnhqR0RiZ1h5T2NJRE9CVTdDKzlsOFMrSWFOUVJxVmpuY2xSZExOU0tx?=
 =?utf-8?B?bUZmczhqYjkwMXB0NWQvZXJNTHEwdnUvVGlkNjFLSzFVU2dYRmJtem0xMnhR?=
 =?utf-8?B?alFieXVRTE9keFdrK2JScU41VEZPajlQN0tLMXZ5Mkc4K3FVY1JVRWdxQk91?=
 =?utf-8?B?TFRnUm9rVDlRdDlRV2xDVWZCZEhrc201NDlMWlpZWGZBVGN2S2hWNE1iTHRR?=
 =?utf-8?B?Z0pOMUlpWFJzT3VPZU9ieXhaeml1WDdZR0Y2N1R0VHZJcXlzSUF0ajNqR2Np?=
 =?utf-8?B?cU44RWtYQjNHMHFENWF5Y0hCQ2NqVXcyMzdUa3hmQXdMTFBVWERTOEV5WG92?=
 =?utf-8?B?b3lidCtRMnMvS1FEODNJd3RVZkdEanh0eXJmYTBaVkNjU1R4NWgrenYrQzBF?=
 =?utf-8?B?KzgybUtiVkhTeHJFbjJOcFJ1cDZPdkR3K2ZJWmFwTTFLeVBTVWpaTU5rZ0Nj?=
 =?utf-8?B?QUtaQzFKbitGMmt5bnlObVYwczNINVFMcnE4RDVxZGJqaFNRSk1zQmpwWVdZ?=
 =?utf-8?B?enR5TkFUYTFiMHFJOHVaTG5vZFBBV1dCM3JzMkl2ZVhydEtrMlhWZkE3RmQw?=
 =?utf-8?B?NXlVTnNkK0RORy9RSTRYWXZuaDNxcHVoTnpWR2ZjYjJQTERkU0ZoOHV3eGp6?=
 =?utf-8?B?YmwvMjhuU2k4SW4vc3NET283d3lOcm55NFlBT28vS3QvcE4yNDYzdEsvbU0y?=
 =?utf-8?B?dC8zU2VQaHVNajBqajJnUFpGckZUYS9qR2hFblByajN1aW41cVJ4SXlnaDgy?=
 =?utf-8?B?L1BKRFduc3dsNlBNNCtLc25TbEhMdzhVcE9kMDU1UTlEMGJtNFpXU3VXdDZK?=
 =?utf-8?B?SUptTDBPQTdSbkhHcld3WWpWc0lGRlVQMjhhK01GNnRtNFUrUWlvRUcwMnMw?=
 =?utf-8?B?Q2VuRDM1aEpKRTN4c1pKTUVlR3NLV3h4U0J2STd4dGJrTHhXV1Jad1IwMzRP?=
 =?utf-8?B?bnlBL0lmZXhiNi9TNjlnelV4Vjd1dTNWWWt3c29SclgyVzNKZWlRZmtCVXJv?=
 =?utf-8?B?K21qYzRITDlVeGlCY2pTVzd2WnNpYk5ZczJuUHVKMVFpOHZRSVRGT2JKMFQz?=
 =?utf-8?B?NzhIbjlSM045TGdmcThJdE00L3lXRGtCZ2owbnAvMUJpdE5NUjNzVitiUzB3?=
 =?utf-8?B?dWtUTFR0bk1CKzdhT3UzTHJaMThPU2ZScWF0TUd3aXJZL3dIcHc5VFM4bnNs?=
 =?utf-8?B?Z01wV0pzZVVUY3RVQitEdytxejRZM0VqODdmY282cy9Ta21PSFhhaUFzem5I?=
 =?utf-8?B?KzZiMFRiUkVlNDZBbk52OVpSOUdycThxR3NNYjl5clFFRkVNbDltcjNaZDZl?=
 =?utf-8?B?bUlYRHFEcnFJNGFjT3pEVDdXNnZPc1JFaWg3VUxNYVBkaGFjZVF5N0hRdzI5?=
 =?utf-8?B?VmgrWGdFK3hPcG50bm96MklrTnhIWlBtOERlZzRwTzk1WFFUWm5VTWZweEhO?=
 =?utf-8?B?NWFod0tnQWJPbGF1dmZVMHdEQWQ2c0hGRVpSU0pncnhScWRPY0MweXFRaGY1?=
 =?utf-8?B?My80bmtFa21IS1NQdllLcVQwL3dvdW5tSlVtK0pEZ3lxSUcwUWE1eG52d0tS?=
 =?utf-8?B?SWNuMDFuRmVCQmlaZW9kRkl5WUFYRUd4U0hCSGdBa2laMithZzU2NlBlOGd0?=
 =?utf-8?B?b2tKV2Vmdzc4YXJ4Y2h5dW15bW5YczFhWnJWUG5QVVdRTDMzalhLV3JhaDVG?=
 =?utf-8?B?YmxKdURvdUp6R1ViY0ZycWlJWnBnY1NsTFQ1R0VyY0kzT1FheUNrODNBKytr?=
 =?utf-8?B?bm5DVzQyRkhaUVZxVEtadzhWZFp3M01sQUx3d0FISTVVNis5RjE0WXJZZ1hn?=
 =?utf-8?B?bEo2cFNTcW04MUhqMkF4YmU5MzJuYUlXbVN0a2tESkFvMjFnb0p0THd0eUxr?=
 =?utf-8?B?bWQ5TjMxbkRYTjFxVGRtQjFNMHlVeW5Hck1LS2NRVXlnaE45TmxjdXZiZUxW?=
 =?utf-8?B?TG4yU3BGbWpJaG9JaWxTa0lqUUljM1dPSTVKV25TZU1ET2FrUTZkR3A1NTE5?=
 =?utf-8?B?WVRmTnVSVjN3dUUwVlIvS2JaTnMrUWtxRDlya3hvL2xBNGRrRFl2YkFodnYx?=
 =?utf-8?B?cmFhUWhldkdoaVA5Y2o2T1F5aFlRekhKR2ZsV2lRZURBaWc2eUltSjJ0TFNk?=
 =?utf-8?B?emh1WTJQMXFlZkpZWVRRVy95VWhuVWljTGNpcTJXa1dielZjanU3ODMwZVNr?=
 =?utf-8?B?dWtpbTR6SFBSeFhWYTZ3bDdEWThEOHd4RCtGWkc4RkgzLzl6VUNJekJMaS8w?=
 =?utf-8?B?bUNORjM3endaMExlZ2o3MWV1R3NGOGZGRk9JV3VrN2w2L2hPWk1nbUlEMkYy?=
 =?utf-8?B?emg5b2JZcldBTG05aXg0UUtyVVlsRkw2Sm9HMTlaUHYyZEc0VGhxamNjdktK?=
 =?utf-8?Q?ggcIcFSVAkkphSqM=3D?=
X-Exchange-RoutingPolicyChecked: HOToJBT6ppiSJ+j+CCu0V45KPiU6uJE8NT/o0FocUEZ+HRa0a71Efu103KBZzsC7s3pkrbPIp4yB/4PN4FYlbIxQT/i6fUVWNQ1y0nZcsQT/hkrafS8pcpo1CjYvrx9yx17ka6Mu7D4MySBFNRQw8Eyg4WShd+lVgAVvm9X69Y5ERext2iSeECDVM3UmsTSB8sBeqU3GwipK5CxQSjIsh9PV0RDw5nLRK4dTmP0JhVHiFyX8r2PQAnkzEIiwpnNbVqz8feTw4rUr5ZXvamCihFWLnVrUVY84flvSe8PzZvd56ydOpoweqT+u987uGXI2/OlpHNGjQcbmBh+cs6kV7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a47a6de-002a-41c3-0df8-08df0dc4e32d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 16:18:58.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQIRapKpy1DtYbGMZzugYddqnlhwdpoxZEO50K59n55dk6ztSdlDgax2OLU04FpQiu6Sw53wQ7YQlNunylkc2eu1JgO4iBE1BiPLyJNqO1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4733
X-OriginatorOrg: intel.com

Hi Chenyu,

On 9/6/26 7:10 PM, Chen, Yu C wrote:
> Hi Reinette,
> 
> On 9/4/2026 11:50 PM, Reinette Chatre wrote:
>> Hi Chenyu,
>>
> 
> [ ... ]
> 
>>>> +
>>>> +    if (!(ecx & MBA_IS_LINEAR))
>>>
>>> Maybe also print the following from rdt_get_mb_table()?
>>>     pr_info("MBA b/w map not implemented for cpu:%d, model:%d",
>>>         boot_cpu_data.x86, boot_cpu_data.x86_model);
>>>
>>> In the previous patch, a "Non Linear delay-bw map" warning is triggered
>>> during the actual write operation. Similarly, displaying such a message
>>> during bootup in this patch might also be helpful.
>> ok ... but who will the message be helpful to? This is a check of
>> hardware state, not x86 resctrl driver state as in the previous patch.
>>
> 
> This can be used by the admin (not the driver) to query why MBA is not
> enabled by checking the boot message, IMO.
Right, but this message will only appear on hardware that does not exist, no?

Reinette
