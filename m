Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436E526BD90;
	Tue, 11 Feb 2025 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739256176; cv=fail; b=WUtKHJjbdbjgWcWP2b7FO7SgIaD7226eyfz1TutLF0I/OU32u+XS8V0h+6XyhFFS9qnFRYtMQevHJMRjdajxHJsBXOP6+FO3m9X4CCGq44bdxT1rMmxYuHfV1vcOHEnyWo7gLso1whBeID8eZpzv3nA8fjog2iw8sP8yefIooLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739256176; c=relaxed/simple;
	bh=dt4z8L/Fa9iImUUqiwVJpwI7COTsgOBiUoZj5fgECNw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bH1q816VZFjDAADc+c3tL+w6t+3KFjRpulKE75t6J2vpqZIlsTqTcj5CqpgK/MkQ3DmDkBx0LpgvKLGppvRGW27d4uArDqVhpITrMBNa8ApnPsbn5jbqgDm5a+0bDW3miOyhr2v+IsI39YzI0UjQ95ZjIASvYuHii0xKtKebkOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a3+vhiBx; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a3+vhiBx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739256173; x=1770792173;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dt4z8L/Fa9iImUUqiwVJpwI7COTsgOBiUoZj5fgECNw=;
  b=a3+vhiBx04P/AX6AqGorW7wNsl1Q5QdqMfRqJistssBGo2l882DdWRYo
   f4jKo3auA+uz/eXC3M0aT+5GjRT7QKxQbQ72lGATJ9CbTO2HfsaNd31I5
   pa8s8eqaTjWxHZxnA4w9jYPwjL8B7vhrhy64FnOsxWigB1SIg9omA1zUx
   azcDAtPYH7oXOFp5M72v0GuPRE6LPIzQLz1bnjq3+UIjziPus9UPF5sWA
   kzz05TBLyojTS/IM/GNR6nKHo0O0tTxQTV5SGHmnWdzMrmwYMLOWQYYam
   DK3EXxNzS5Nv9MwQXBGr1CyysZFOUjGcTfvY9gf+tGAcfUU9Nzk8DdPZ3
   g==;
X-CSE-ConnectionGUID: KUfyta0+QsOk/ggOJ+Gbsg==
X-CSE-MsgGUID: L+IO4nxHTLapCVgcxPUH4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39556698"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39556698"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 22:42:53 -0800
X-CSE-ConnectionGUID: fKM7I5hNSGG9dh8LyJY3DA==
X-CSE-MsgGUID: JgGDLH6aSB2sU9RLxcbl2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="113057230"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 22:42:52 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 22:42:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 22:42:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 22:42:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lb8b0PFJGWkioeCJCK9o4BWulpBvmqiq5RKBZTyljnjdJhIC1+/ZAlHWcLpPCSmNB6Heo7l40KHcTfx/SS6sCQ4ZItOzH3TiRXPg+aSGMlMVmYBJzrqQtZ0CdheO6tEfHTofQxzXuEwgRwcjIvvneiXZ/zXLfa39uKeLcZpqbGhseQa+MQNmd2lre2ppP685gEDTDijjJjTXn4B73mP2ikdSBRjljE1pqAyqmfrsR9rJ3bdDRSGGqnScMC5HKhAqrHbWJNBk67WqaKb1nsfiqFfvbuHQOupMi76HinjIFUT7M+F1lUos4XHtq/LesJB+6C/YK9V2yzkxpxYiBMaTtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/YRGgvpsEd/V7v7JSkgpR+bCbXYryyxukZflvxwQZM=;
 b=kdjQPMfOmQb3AYffzdFKwjDHw69499V7PDXCBVdHy5qjaYZEe80tOhfWS693SzEeHHWJBIY6PZmhlhA62gbReiojtt16rG0PC1ombw2w+D1tSRB1u788fNexnoXlcpNG0eH9LeDBhIokmoFnw0QFfZdekl56OpAQzjNRq5I+c5w22sDYFCJKiBLPnZrtzTlONam7TgNCl+p64I/67CeaRV9XUc/j3LIiiyEbkea3ksnl2TJv3RzeUrPzkw8N6jmHdkBeOJtDG932X/vVQ/Lv23/o0S9JqzWZ/27o4+CTCVgufY1qHrA7YEDe1iY1NFR3YxqzlRka+DFGtzC62QMLnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Tue, 11 Feb
 2025 06:42:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 06:42:35 +0000
Message-ID: <6ae5d623-c14e-4d64-8e24-86e83451f231@intel.com>
Date: Tue, 11 Feb 2025 14:47:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] iommufd: Make attach_handle generic than fault
 specific
To: Nicolin Chen <nicolinc@nvidia.com>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>,
	<patches@lists.linux.dev>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <cover.1738645017.git.nicolinc@nvidia.com>
 <32687df01c02291d89986a9fca897bbbe2b10987.1738645017.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <32687df01c02291d89986a9fca897bbbe2b10987.1738645017.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) To
 DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1914f7-10b9-486f-15a5-08dd4a6744ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MW8vNG9sU3N0UXQ0UFR0MndQSHF6Ri9hODljdUplSnJqenAvOXdvek9CamlP?=
 =?utf-8?B?R3dUR0pDVExBQVF2WWx0SjU5cFE3aEpUa0ZYODVyeCtTaHVER2JGcEJYVnZ2?=
 =?utf-8?B?dWgzdC9ucUg5UkY4NjJMOVVnbDJFYnRLRVBnaHU0cGo2a1F5c2F4TEF6MTRY?=
 =?utf-8?B?MHVBNTQ3TTZvS3l0NGN5RUhVRDdQWmEvNVJXTEZScmdRdW02UldwVWNETURI?=
 =?utf-8?B?Q2greUlGWThCQTVNcUJ1RzhPRGJyR1hhN0k2THFWQVZqdnB0dFdWTFA5bnlC?=
 =?utf-8?B?dEs5RnlqbFlVK2h4akREM09uL3BSZG9halgxMlJzMnBjK1JzZzVScjlFMy9v?=
 =?utf-8?B?cHlpNkVSeGZoRUZtblN6bVNZNjZZNTNrekpVbWhJVHhBZXJCbVhxRmtDLzVQ?=
 =?utf-8?B?OUV3OFgyc2ozbGRJTDIzTzZRSnAvdkdoMkJGNExKS01HK0EvK1ZsWG9kZE9B?=
 =?utf-8?B?dkJCcUs3NFZiOWRDQjA2OXhCanZBZkRuazUrNVVZYllEZUJUYVhuRXUyZTZC?=
 =?utf-8?B?OE5BUm1pa1BsaFBWQjZqRjREbDFsLy8wZVNkRXJmbTc3cTJYalFQTzNCd3J2?=
 =?utf-8?B?MHUydXk0alp3YVdQejlxSmpXcUhVT3lRMzVzUW1DRmtsZkRIUDlvdnNyQWcz?=
 =?utf-8?B?WXBpclRZWTA0MlZLSDRSR0g0d1RFL21aaGc2ZDVTQmxvcktMeWhtby9YdXlk?=
 =?utf-8?B?Q04xNUVqM2N1OHUzTjByT3U1aFpXY1pzazRoNkQvaFFrcnAxYllPSmZUNXZX?=
 =?utf-8?B?OWdydXlvN1dmakJOMnFIMnRNaVJ2TXpHc2p3b1F6YUlwcDdCWkFxZmhXMUlq?=
 =?utf-8?B?Sk0wR0NkdlRmMEZZaVFLekQyd3AxNmU4UGRFOTNDeUVYMXVUMk1ZSjBJOG5M?=
 =?utf-8?B?SXdBR2x6T1o0RTU5aVQvaXlXV3pxTk0yUW53Q1VlSmVVUHdVMTVET2tOY3BX?=
 =?utf-8?B?ZVhTRmpxN3RBUWxmUUwyeGpJMkdQemo2T1BpbnBBeTJqQTF4ZnZxb01WNnFL?=
 =?utf-8?B?Tk9aendRcHhLczJQS0VXcjVRK3gva1BJbzRFamMrUEJGLzE0cElOWDZvREtJ?=
 =?utf-8?B?M3RSNTF4bUx6QWZmSEMzQmlEdXByQVlQeUVNSnB1MHlibThoa1dKejVBRklO?=
 =?utf-8?B?S1UvYUFMaFJ2MS9rMnBaY1dadzFZaFNzTDdGR2VxRHN2ZlJUb3R6V1FJdmgx?=
 =?utf-8?B?VU4xRnlOblV1LzF2eFA4dFV6ZGlnSXJZOVZ0TzF0QWRxZUcwM2xDRk9CQXY1?=
 =?utf-8?B?am5SL2NyQ0pYVERlUld5alozSVF3eWpZRDVZTHV2Vkdsd1kyM1BWaDJzS1lO?=
 =?utf-8?B?Wmd4eUF1aUw0eU5rSTFpUEtoOXFEcnJHSjM3ZU9yUEd4RzlvWVNFQTdsaWI5?=
 =?utf-8?B?WEhGQ3MwemQ4Rks5dmpnY21CYWY1MG5WRm40NGtYQXpvZkkvZDRJTXA5dEZt?=
 =?utf-8?B?VnhOdDNKQjJBazJYT1R4Q3MyUXpQWWlEZ1R0K2xuMXRQdVdkTXdVSG9CcVpG?=
 =?utf-8?B?QysvVXd2TThiUGlRKzAvRE1zQUxQcU5NWk53UWtnbTFyUm1xaWZsMnNiUUgv?=
 =?utf-8?B?Zy92MDkxZmdva0l2ZFJWdFdKT0M4bWJDWExQajM5YTdKaUFBRjZBK29VV0Fx?=
 =?utf-8?B?dXdMaUFBRkxPYUpVOXJTMm1tUWgwQm5FWCtzM0lHVk8vb1RRRTB3ZDdSY1Zl?=
 =?utf-8?B?KzRGRXd5MVduMG1PY0RqakV6aUoySm01M2p2KzNod0ZnemloQTB0T2kxYU16?=
 =?utf-8?B?MENZYWNFMjhYRzVzZGl3aHlWRDJWRXh1dWRFbGd5Qm5uZ1EyWFhsRDVHaklv?=
 =?utf-8?B?eXU4Rm9SZTExRW0rSkxQaWp5TGNqTzhGckJ4U1p4WUxuZWk0amZ2cjNySmNO?=
 =?utf-8?Q?gcYyhK0eVc6gu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTVOZklDQVNMSEl1aVZtc0VETW10N2c1QS9ETGM1VFFIY3l2TlJoUURjWS9p?=
 =?utf-8?B?dFFoZUxuN0Jmb2M0SUNwYTViVTlUMzh5VWUweDhYdngyRkdoV0hkK2szU2V6?=
 =?utf-8?B?SGVCc0tndEdVd0R3ZVF2bmx4SW16Ni9Xbm10dXc0U0d2aW4wcXc0SjFib3hu?=
 =?utf-8?B?aUR6ckxsdCtCbHVxaU1Xb2JoS2tiYzFIbi94SzQvSkZuQXY2UTVCMmp3WlNM?=
 =?utf-8?B?L2haQTRSWFlCWFltWllKR2hWY1o5YTExaURsa3VQRk1LblFNU0FsS3kzN29a?=
 =?utf-8?B?SnpWWHI0TUxsMU5tK216ZzhnSSs0c21IWnJGM1NZQ25FNDhUVkdTK0c3WjYx?=
 =?utf-8?B?bHA0UGxQektxYjd2bDBqbjFRaG5XK3A3MEtnVUtGQlpaOS81WDZteW9RUDdy?=
 =?utf-8?B?Njk5MTVRRWdSbFdXMTRTbHNjWDNabFY3M3hwY2h6Lzk2RjcrQUxHNk50bHpT?=
 =?utf-8?B?eWNZVStWcmNmVHd4TnVmNVBCSzE0S3ZFbjdlbnA4bzZRVUJGTlIzaTRlamEx?=
 =?utf-8?B?L1BUbmJ4U0diem1FbXNsRlFhWmZmQkJGaXp4OFNGNTN2WXp0ZDJxUVdEdEd2?=
 =?utf-8?B?WmVRdVB5NmJKVVhMN3ppTm14VjB2Mm1tejFHb1o5OVhzU3p1aU9UNDRpNTVF?=
 =?utf-8?B?dFhDSXNuaGd0dmRYZnp0SnpFZ0dGcW9pbnpQWXJ0TjZMVnI4WWNGMXhCdmZz?=
 =?utf-8?B?eFFqcHVrTlJVVDVKcHFzOTZaOTJadW8zMWYxT1NDUm05M1k2eDBlZXdNbndx?=
 =?utf-8?B?VjFEeEZ0cWU2MHQxZE8rY01IbXZwdTZYcll2K0c3cTlkMjhaaFgzdDFxZG0v?=
 =?utf-8?B?Y3FIR2pDNW5nOFJKd2dvR3hCaFBOdm1jQ05HRzdteDYxUVFNSFdiWk1kbmFx?=
 =?utf-8?B?UDZFQXVaaXg3Vk9FSDUxZy91WEZjV2VZWXhIamNtbVBhTHJPZmZDc3RxUjhZ?=
 =?utf-8?B?dlpZcE9yZC9WSGZ6K3NQYnZNYkc1T1M1ay8zajEyZ2lHZTJwRCt2N3hGVjhR?=
 =?utf-8?B?bXltSG1uMXhEaktvMlYzMTJzMjB4WHZzS01FRkxqUDc2YzFFOEd6dTQxYm9l?=
 =?utf-8?B?QTJqa2FnMHpjbk5QOHNZMHFQZG53T01FY3RVUWdreGRWWGFBaWdJWktSVUUx?=
 =?utf-8?B?TzYzZjJ1bkNlQkdvZFZwQ3dCMmp1R2pXYUlUeEJxc0ZUakNQVEozQWFwblc2?=
 =?utf-8?B?MWhXNXo3OVQ1MUZVTkV4ejI0STVkMmErdW91VmcyWnVRNmFFeER4SGM0dlBY?=
 =?utf-8?B?WEFxdTR5Q1dKSW9VSlpwVjE1cE42RURFblREbHNsZ2xscGo1QWZEcUJCVUhG?=
 =?utf-8?B?bjcvQ3lHSGthZ0dsYjR0V0VnQXN6bSszTU5kdGp5dncrS2hUbmU5c0RWNitu?=
 =?utf-8?B?VEVGQlY2bTBYS00xMThQTHJwVXY4YmpQTS9xbW9zQlpRM2ZxOWZGNlo1UHVT?=
 =?utf-8?B?aTFYZWJhQUFDcmFCSGJydDdIY0dyQ0dqdkhpMkpSaGR6WHN0czRVS3J2OEQx?=
 =?utf-8?B?QjIzREVlQml2TkJ6UXRwMWx1OEtYSDFkZlhUVkRIeExYV0pQZVpIUGNYRWtq?=
 =?utf-8?B?RG1KZXcvYzFONm5KTC8rTUZnU3JRamVCM3RpZlRtYXQ4d21ZQVh4T05HOE9L?=
 =?utf-8?B?Rkp3MmJTWVhlTHd0TFF1TytmeU4wTURPRW9yeXFFNXNqU05qYUYyWWx5L3ov?=
 =?utf-8?B?TjNOeEV6Y1BnOGlKZ1NMUFlBTXFPaTZncDRyRTNZcWluM2w4WHdoNHNSWVpV?=
 =?utf-8?B?OEt2UW9ORFAzNXA5V2d3ZURLZk9DbXFScWtXTUlqZS9ETVpObDNhYTlsMW9m?=
 =?utf-8?B?QkJiTUxpMndkMGdicUJpUDhTV3UreFI2WHcrWEoreWpXVHNnOXMvVmZwV1Bv?=
 =?utf-8?B?NXdjczJNdWgvRjhxZjR6bUJmMVJCNHlKVHZLU0szSEROVW5zUSszdmxOOFB4?=
 =?utf-8?B?MDgwN0ZCQXZDamdoRzVYNDhweXp6bTVxZUd3WUlJTVBybXpYMWhKRWJPTDNL?=
 =?utf-8?B?dHQ2bzhIdjdDQzdPQ1I4Y0NveHI5Z2JnWkZwNnp4ZmFxS2E4Nkx6bzVZQkxY?=
 =?utf-8?B?ZEgxRExEVnRuOWtpcnZDUVRsNVNRUU1iV01rb0Z2c0hQVjhScnVqbFJ5Tkhw?=
 =?utf-8?Q?W3rvp86+Yioi6iSnKoViq/ksP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1914f7-10b9-486f-15a5-08dd4a6744ef
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 06:42:35.8527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVPabokBevKjp/fm5S3RbDlHwCVCoMpWY71rcXNG4kaKyPw0QxaZku3MFEI51ekNN+ZOXn5PvldXflc40ryzrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com

On 2025/2/4 13:00, Nicolin Chen wrote:
> "attach_handle" was added exclusively for the iommufd_fault_iopf_handler()
> used by IOPF/PRI use cases. Now, both the MSI and PASID series require to
> reuse the attach_handle for non-fault cases.
> 
> Add a set of new attach/detach/replace helpers that does the attach_handle
> allocation/releasing/replacement in the common path and also handles those
> fault specific routines such as iopf enabling/disabling and auto response.
> 
> This covers both non-fault and fault cases in a clean way, replacing those
> inline helpers in the header. The following patch will clean up those old
> helpers in the fault.c file.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommufd/iommufd_private.h |  33 +-------
>   drivers/iommu/iommufd/device.c          | 101 ++++++++++++++++++++++++
>   drivers/iommu/iommufd/fault.c           |   8 +-
>   3 files changed, 109 insertions(+), 33 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>


-- 
Regards,
Yi Liu
