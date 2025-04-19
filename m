Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6178F5B
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 05:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745041256; cv=fail; b=jNxHXNx8B2z59Z893sMZCRwZiWzoiW0sgG0eFTRp0ozhtdzJdsKd95GKoUnKXVhVICpO7OHlUvS4IH0Zxyz+ys3VuZuMPTMR7oAot7Q1NTdRYqUMVwIUnwkchnrGgCtAB2dYvdJhJagL0IndG6nV+sU3vUpuoikE4MPRgNN+TLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745041256; c=relaxed/simple;
	bh=erQnZlnoIYMietx0sOH3jRTF0kss4FjIAj1alhY6WEU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P1ese5gNUWUn6VucizJm1eXM3kz8IBJHiyg26Sab4F4Huqx1m4tgvDX7g3Ax93f6dOGa0TPlVNiFuwMzipUuTdjJ+G9CIEom+DnBj+HRZQs+0UC+x82SFeBmbzx3d2X6mJSOvhkv5fbB0KHhdrJ+G3tWFkBjoUHfy4VLymxJwns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0rfBryH; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0rfBryH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745041255; x=1776577255;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=erQnZlnoIYMietx0sOH3jRTF0kss4FjIAj1alhY6WEU=;
  b=M0rfBryHghExFBwJFt9l5g/sHTSrbVCmlr3nDhUzymr25a2PGvqSNdUh
   f39QMkrkTgzW96lVVesn2g8qbxr5yAtDBehoikrablCsF4oFBen1ksLv2
   hDFhVfbBY8i9+DQrgvScPnVJCFxaQSd6njKc1XVwkils90pL6NfdIMcRP
   CJDazJFZVE8kWtfc7Q6/GD47zEaaaPo1m5jokSzeQSdRUK93akU8D5Xne
   gvaoIn80uU0dpsfdhoznt87P/7WhuoB7tF/LJqLBH5u8hTfM7cKfadxfC
   gzrEfqVw5QIHzG4mg369jT0U+XRhyc0NYvhRg+qyGMenhnuEDdmZwnb1V
   A==;
X-CSE-ConnectionGUID: lhrT18jkR1CYNNzR0fCIfQ==
X-CSE-MsgGUID: lp3PLJ/HSB66H7eop/2s+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="50463691"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="50463691"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:40:54 -0700
X-CSE-ConnectionGUID: uDA6Rl41TKOCaX7ld+LeEw==
X-CSE-MsgGUID: m+MzDIxHTW6WKDqzzm8gNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="136450840"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:40:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 22:40:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 22:40:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 22:40:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbrzmJbqR62zazzqPo5cD6dmMLUndnT+MCiLp9SYAEsAnvjqYxFczA8jb86yKBuOqnfX9pUFpVnqHG4dnEer+nVBGysvUtdW30hgsij9pxVU2f5L5ofn7Ybcb3d9InD2nQYu4N7JDJYH8++TyNm/vQ6QFfJVzBiB79FMRfc/GMDmpaj8gInoKgVHw3Bk9cmhE0oT1O6DIqcXBVFm9CVZKQP9ToSS6ZaiOJI4u3QKjaHVgZPoaxPos3fgSFdOTZafEa36m0i9AYgRHqjqaBt/1Ft1hZoHleuMLp7+fUN+NKul5ID2vnzRoO1UsMrgXSspUhiUr2iytcLDabHcvxmiNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwmCLT8Yxh8BsWfyJITef5rClfIAeTUqJpg5GsZ1gsE=;
 b=KK4bzoql8UVLHf3ebiW/StT4HW2PLYRmQa6d0S+3tmaskRkk1vz9BfKqbsDQWumzMH4g8iv9rx2F7HVbWEB/UFX9GKsDMvBjNj9s8pqdbr20LoVQo4U0C39ax8q3jxvAzmULA4QesXUpxJtaCHEl5pNxO5OivzMSM1ShEw5wODUYU5aXmr/T5iGCGVeNnxFfFDChgzvJbwPADGtVhCxsBdfrds77x5hLMk58jNKi+XJguVHuCtFdH3RgVI+deK2DNdwKoDEQGoVXW3r/iCwsXmqzRHn6ujHTmc+QudaCBnXdY1yIPOiF4uCy+2c1/KKhW/L6IrikMyMfx/JDJKWgXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6257.namprd11.prod.outlook.com (2603:10b6:930:26::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Sat, 19 Apr
 2025 05:40:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 05:40:29 +0000
Message-ID: <8256d312-ba54-4fec-9a0a-db7d7f461a3f@intel.com>
Date: Fri, 18 Apr 2025 22:40:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/26] x86/resctrl: Update Documentation for package
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0386.namprd04.prod.outlook.com
 (2603:10b6:303:81::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: b1fb70d8-912a-4ffb-0900-08dd7f04b159
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eVV5QXhzWGlEY2FzdXAxNnpkaVpiVjNWVExNSXFGZVYxQitEeG9MNXZqWEJk?=
 =?utf-8?B?UTZrd3NzbFROT0lVV1BUaWtxK25ZNEUwVkxHd3NPTmRKS0tmN0FXbndjYmF6?=
 =?utf-8?B?eW4yai9ZcXRjR1hncTRYRElhRkRiVVFad3J5Rk1WckY0Q2c3bDRGZTBuZnhG?=
 =?utf-8?B?QUExalRiOGMzb2c5KzVCMmVzaGs2ZUw3Z0UyckJlSk5qOUUweXl1MVk1QXg4?=
 =?utf-8?B?a1R3S2JZNHd0bkJ1S3lRK1BidzdJUS9SZzRGelgwemJJQ2sxZU1tanNrbktM?=
 =?utf-8?B?TTZHQnZMbkNPZWpPQnRtdWdqSWRqd1dYdUxUSHNjYnA5c2w1NlpjNGlEa081?=
 =?utf-8?B?T0RMb2JIR0VPZDVBOS9yTXFWZDhMQ1NOY0hoVXR3aHlyODcvN1o0TlFqdE5l?=
 =?utf-8?B?dkxYdjN2dzBuNVpmWnhFbmcxeEdpUUVCY0RnYi9PcUlJbEZOaGVWU3dKV2o0?=
 =?utf-8?B?aWUyYktqem9reEZ4S2RaWHczNGNnSU5xMVpvYVNmekx1REVCZ3F1UEltd0x0?=
 =?utf-8?B?SDJYOURKZVVvWGNvZXd2SkRMN2sxSzV0MzZzNVFkRXpDbnNOYXo0YTQvY0Rq?=
 =?utf-8?B?Zld3YURTc3h2TlVkVjQ3RWgzMzJnZ2pqaUtGcythNmVUOUdxbGhTTThnclBa?=
 =?utf-8?B?SVlGUmcrQnpjcG4zK1czV0VWWWhYTVVBcXVGYWFuSkVreGYvcTZTVExDYXpq?=
 =?utf-8?B?bEVVSWZkZUs3NSsxUXFPT0xXQ2FpY01DcjMzdVVhSlFuR2hIK0Mzc2dsbkN4?=
 =?utf-8?B?b3U3TEtlcGFUdzh6Y3NRenpVS3ZQUlRiZk8yaFZIcUlpVmFIcHg2NXZnWHQx?=
 =?utf-8?B?SHJrWmRkcSt0NVVnTEhaaGNYUk1TcFBFQ3c1bnVjZTlkRFBpVjNPbk15OWVP?=
 =?utf-8?B?SmhvOHRid1A3Y0hubnVyaFQyTSszOGhLU2dwdVNDMktiWUZTdGx2UTFWYThT?=
 =?utf-8?B?a3JiMytyTTB6L3VoVlJjUjJyK3QveFl1VCs2ZlJ2a1FKb3VFYlpHNy9xSldT?=
 =?utf-8?B?VVdBWlN3VlU3b2Z1Ti9DUVFLRkNEd1pqbEYxNC9Sc1F1aEsvWEE2eGNUSHQ1?=
 =?utf-8?B?dmJtb05GSE1DS3Jvb1h5TnYrTmZWaWtDcEQvdE1mUHJTbDdVMGZRcW1RaWNM?=
 =?utf-8?B?RTZnQ0FCb09zNkRoUXZ1MnViZ2sxSU9uQVltb2VEdCtPZzRQRDJIQzdnVnp6?=
 =?utf-8?B?MUNvNmhWODI0Y2VGanJtdVppNG14ZE41UE00V2JJaFg3L2gxdDEzQk5sL05S?=
 =?utf-8?B?TkhNMGk2T1NIWDIrT0NCZ2xKbGZ1R1pNOVZPcCs5UW5vZ2FMYVNkRi8yZ2RS?=
 =?utf-8?B?REdLUTA3dkxFSWFLYXVlZ3NFc05mT0haa3JMUEx3QXAxZGpHKzhJRkc1VUlS?=
 =?utf-8?B?UGFVaEgvSnlYbkFaK1FiZ0VXcEljNXZhY3ZNMzBZRkp4ZU9oVTVubGFtZHZE?=
 =?utf-8?B?VUFDNGtYMStmUVIzNmduYlFoa1lYVFlxUXJpS291cmIzNU5MbW1iaUZaL0Zh?=
 =?utf-8?B?RFVaalIrTXIvKy92d1hxRFd5aHhvUlhuY0p2QkwwTGtmSTBTS1N6V0xxcHBa?=
 =?utf-8?B?dGJCMStMMVVNamF0UWtNVzgzdURMWVd5cE1neENNMUVSa2QxdGNtQndRRTlC?=
 =?utf-8?B?SWo3Z0NkTmxXSGJtRjY4SlFWVkxWU3BYZUozNmpuRGRHYTllZzg1M28rZElE?=
 =?utf-8?B?YVhMU3l3OTVHRktjSnJmKzBma0kyS2g0N1l3V0RWREM2eTlnbWZjdlVQZHBH?=
 =?utf-8?B?MjkwUkhlNlBsUCtkQ0JWUDJGK0F2aHBHcEJmNXdLQnlDWlM4ZVByZWxaQ29z?=
 =?utf-8?B?UHVIZ1pMZW5Pcm5lbTFXdkJzZEZSZXNWQXU5a2RrNWNsZ3NBNEF1aFZEdHNK?=
 =?utf-8?B?Z2Q3ZEo1eUpkcUc0RWZEbUlvYldDWm42aVptZ3BVbVRET1RxaUZjV3JRck5j?=
 =?utf-8?Q?qMaPVCO/vNE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1puSkhaTWpEaGlOVThkaXRtcUVNdlc5TjRnUjlobFk4NXZmOTVqQytYamYw?=
 =?utf-8?B?QUZDSUF4cjdvOXBEcHRWdjBWUkVpQjdaN0ZtUHMxMVMvbG81T0J4VElSaTUr?=
 =?utf-8?B?L2t4akNVenJVRDR1L291QTkzRHhwTjdzTTdXZEVSaUlnL0x0TlNUVGwzcHh5?=
 =?utf-8?B?cmkwZmVrUWxtdlczSUtqbFNEOTd1UUpBZm92aVBYWnJ3cEN2VkRQU25WcGMx?=
 =?utf-8?B?QTdBZVpINks5dU9JK1NQMHBUN3IxYmNIdnd4dXpQOUl1MC9uRGpxUTdEVTkz?=
 =?utf-8?B?MmtyQUMvcGRVZkxhOVpUTEI1MlNrRk9nZyttbGU1L293aDVBTXBDRmUxRGIx?=
 =?utf-8?B?V0xnQ1NRcENkMVg5elBpR201VGhuRXdxa0tGTjRXb3RrR01mMVgxNFhUV0U0?=
 =?utf-8?B?K3d6VFE4Y09zeVBDQ3d0OWxKaUo3VEtoNWZmRmNVamIxWHBRRDlMa0Z6UGxZ?=
 =?utf-8?B?MkptcmdabVgyN21rQ0xtTnhDRDJZQWlzUzFCVHA4cHRMVTd5OEpod2VWUHFO?=
 =?utf-8?B?SENoeGZ0UmNya3U1ZC9ES2VCQlBCRVlwOFVkMU5XN0J1amNUZE9CQTZDWUsx?=
 =?utf-8?B?TUE1MXNBZzNLMGJnblZLL3FMQ2dITFhuTEFDZlRQL2tHUHlPUHJTNTRjdkd2?=
 =?utf-8?B?OGJmbGdUTjZyVE9GSVhXUmN5UzFOeVVHU2h3RFJSS3h5WWtWQXlVM3NZL1FB?=
 =?utf-8?B?M01uOVNXa1lna0hTTHJLQnFuZ3FmeVRvQTNkU2lwbm9ONTJuN2o2VlFEZGpN?=
 =?utf-8?B?NlJMNTdoUFAwVFdIY1RMQVgrZWsrNVVhM3luVTFnSVFveFhvMWN6VXNBUndz?=
 =?utf-8?B?VGtSWlMrYld1Q1hNRjFLdC9IN1o3RkhZSm9qeWtlSWhibHc1clN2UWVJVWxW?=
 =?utf-8?B?TWpPYkVid0I2cXZId29PdVpYMXZNeVdTb3JySzhtMlhYS25hWVVONXJwNXN5?=
 =?utf-8?B?UXNtbEV2M0pFZG1rVU5lTzNOMnNZM0Vja3JlblVWQVlEZzk0QTg1SWpqeXFy?=
 =?utf-8?B?Nk9sTStQK0UzeGZuVExVTEN2YXhUd0JrTG8xMUV3SjFuSG0vWTdiSlRRQ2Mv?=
 =?utf-8?B?cWc0Y0hSMWdrQXdhQzZvNFcrbHExd1daVjNBK3lIUUNsNFVJSTRJQUFlTTVi?=
 =?utf-8?B?c2libi9ITGtsUTg5S1BjNWxlaVU5eE9QaURRa04yZHpqbjdyWjBJc3NhUGQ3?=
 =?utf-8?B?Q1krOVVibnRGSWdvcm80Z05VWFZDenNJenZlemtqKzFxZktWMllhc0FuelND?=
 =?utf-8?B?Mmp4dFFQSWFpdEtoa0ZnbTlLNTBlMTV5WlZ3YzJZZ1ptbDV6VVdTc0ovYzhs?=
 =?utf-8?B?SGpQazZ0Q1IzTmN5RUc2bWF1T0tBNUZaYWl2RWhIZSt0YVVtTFlGbGx5d1ZS?=
 =?utf-8?B?WTUvNjRZejJmeXFpL2U1citUVmJwVzFTRmYySmE1Y1FJUGxCRkZJdlJQaUNO?=
 =?utf-8?B?c2hIR0UzUlJxRFZxN1ZNbEV4dHRnZHR3SFdaSVlXZ3BWNlFFa1gzekZlNDdy?=
 =?utf-8?B?OGVQbnlnYTBuOVFrZW9MRHRVQ3BhNVRydHZvUUlSRGpVL2tLcjVYNFdQUXZQ?=
 =?utf-8?B?ZFpnU01Sb2FDaGhCaGtVOXBPWmJGSVd2QTBPSUlzcENLSUxRaW1JNzhvcVpa?=
 =?utf-8?B?SWNnOFBqUFYyZ3k2M2laaEZrZGRKVlBlUE5HWnpjQWpSMWxsdmRzKy82dENt?=
 =?utf-8?B?bHpjNHFDRjV5U2VneDAydkk2TUd1YTNQY1BibWdQNno5Zy9NZFl6U3hQQjAv?=
 =?utf-8?B?Ni8yQndYcnhHeDc1VzJ2YXNYSHdIZzhSREZWL3JXalNvS0RNZ28xOWFFbU5C?=
 =?utf-8?B?enZ4Tzd3aHlMMTArekFzVzdTWVJhRTYwNzBTUVFHNUdTQnIxV2RSaWVIeTcr?=
 =?utf-8?B?KzlTZElOeTFlcjVxaUV6WEdwN2hZelNOL2g2RDYwUW9MbkhqajlOMVRCUzlM?=
 =?utf-8?B?dnp4eklrV3FDZUM0RndEcDE4dmdDbSszYWUvZXVNcThQOTVuVS9GOUhCbU5F?=
 =?utf-8?B?RjhJeTNZcXVuK05JZm9wNG5JSmE2SlVITFpHN2RhalU2b0M2aUo5cCtlUHVO?=
 =?utf-8?B?aVRRQm43SitwWldCeVM5WFdKQkVjUllNL1RkSDliakozeFlVbGVXWEhFaGdh?=
 =?utf-8?B?OHJWUnRaY2ZYZlhtMFdsek11ei81VjJPMmgzRWQwNkpjYzJLRHhXQkErUzFa?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fb70d8-912a-4ffb-0900-08dd7f04b159
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 05:40:28.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iO7LVn/wOLP+bK+NG3MUihm1C28Aq5ahGnbesFi1Q9klIkivODP+ZvCatBFbzoCz5jreMAlyzsoKnfiYFoJy/Y5W0Be0M8wa/s7cfMGxXoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6257
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Each "mon_data" directory is now divided between L3 events and package
> events.
> 
> The "info/PERF_PKG_MON" directory contains parameters for perf events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 38 ++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index 6768fc1fad16..b89a188b0321 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -167,7 +167,7 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If RDT L3 monitoring is available there will be an "L3_MON" directory

I think "RDT" can just be dropped.

>  with the following files:
>  
>  "num_rmids":
> @@ -261,6 +261,17 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If RDT PERF monitoring is available there will be an "L3_PERF_PKG" directory

"L3_PERF_PKG" -> "PERF_PKG_MON" ?

I understand that the existing L3 documentation contains this term but I do not
see a reason why the documentation should make this new monitoring Intel/RDT specific.

Also, I do not think user can be expected to know what "perf monitoring" is.

> +with the following files:
> +
> +"num_rmids":
> +		The guaranteed number of hardware countes supporting RMIDs.

countes -> counters?

The use of "hardware counters" is a bit unexpected ... the series did not mention
this or I must have missed this.

> +		If more "CTRL_MON" + "MON" groups than this number are created,
> +		the system may report that counters are "unavailable" when read.

To be precise it is "Unavailable" ... but I do not think that is a good interface.

> +
> +"mon_features":
> +		Lists the perf monitoring events that are enabled on this system.

"PERF" (all caps) at top and "perf" lower case here?

> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the
> @@ -366,15 +377,22 @@ When control is enabled all CTRL_MON groups will also contain:
>  When monitoring is enabled all MON groups will also contain:
>  
>  "mon_data":
> -	This contains a set of files organized by L3 domain and by
> -	RDT event. E.g. on a system with two L3 domains there will
> -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> -	directories have one file per event (e.g. "llc_occupancy",
> -	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> -	files provide a read out of the current value of the event for
> -	all tasks in the group. In CTRL_MON groups these files provide
> -	the sum for all tasks in the CTRL_MON group and all tasks in
> -	MON groups. Please see example section for more details on usage.
> +	This contains a set of directories, one for each instance
> +	of an L3 cache, or of a processor package. The L3 cache
> +	directories are named "mon_L3_00", "mon_L3_01" etc. The
> +	package directories "mon_PERF_PKG_00", "mon_PERF_PKG_01" etc.
> +
> +	Within each directory there is one file per event. In
> +	the L3 directories: "llc_occupancy", "mbm_total_bytes",
> +	and "mbm_local_bytes".	In the PERF_PKG directories: "core_energy",

stray tab here

> +	"activity", etc.
> +
> +	In a MON group these files provide a read out of the current
> +	value of the event for all tasks in the group. In CTRL_MON groups
> +	these files provide the sum for all tasks in the CTRL_MON group
> +	and all tasks in MON groups. Please see example section for more
> +	details on usage.
> +
>  	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
>  	directories for each node (located within the "mon_L3_XX" directory
>  	for the L3 cache they occupy). These are named "mon_sub_L3_YY"

Reinette

