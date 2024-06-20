Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D011B6E2AE
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919081; cv=fail; b=rLMMop2t6AaNPpGRgRku5239fdjcBYIMjJ8XNsBE1encA7oX2Wv3fSKnHt5MtfwHcF6dtSFM/DRIvB2yAiq/B506TwLrV7QITq6kSQdPqnb8S4XjO9BytKMI9H3IktrbAMIv4Srdclei2XSilalVu2Si2eGAQrYaTerqnDFqwhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919081; c=relaxed/simple;
	bh=Bpg8qlBctXa2nUL5FGlDFiCWt3d6776JBNsvLi1uRRU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BrNwZFTdIEC6lwA5XIUrZVsPNtWTbT03mAvWFdmGNU0k3/e8TI0RNRK3SDBgnjjUw+XIRc6a0JdFd5jHuHVY9/U1AJr7nuRWPcg0hYW5gHtGgRf5BKQt+dhbJ5K5K3KGbLWZzapdQsXyaJOwtipdIzHYYYAApTOwpSkHs22Mt84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FJBsyf7P; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FJBsyf7P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919080; x=1750455080;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bpg8qlBctXa2nUL5FGlDFiCWt3d6776JBNsvLi1uRRU=;
  b=FJBsyf7PDoUF/MRu9nXlUYUamsUsiBl4D4Mlp0+dfdVJ7vT+7YODvWjh
   n1m2GRcJ9JmGH2ktA+iH0az8YflxJLUnuXA55UsuH7gyz7XMGQvznr+oI
   4HDPoWRNJN/YRbn61KrHAYS6O/TEknQ7J78N6CqwJPShxsr33cn0ssTzO
   wDjFg6ygJ2QMGmWU49oMxOI1oCmS/A5AH8X4Gh6dURh9X+zA7n0yWKX3g
   nmnwabeQobTqyH041KlhaKQegwASWqrbEZ8+laI18/9mLsaPmrVQXzwF0
   8rfSrC0rOgfZ3tISo4iAf3v5xRSrTHZj1e5Tljp9HAZIGEZ6PhbbDqpcW
   Q==;
X-CSE-ConnectionGUID: 5iw5h/KIT0ieHUD4M4Mjjg==
X-CSE-MsgGUID: 7gWYunjhSpuTcNV3iIIUTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16163779"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16163779"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:31:19 -0700
X-CSE-ConnectionGUID: fNjrfQZxRqSRm0UPR0HYTA==
X-CSE-MsgGUID: D5gVLKSAQla1/1EQgrrh2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="65624671"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:31:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:31:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:31:18 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:31:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmAziFsywGL1RBFHLCr00i9bA7Riqlqgiu42Cl7kmm4+iqidy3VegpKhhbtnYvghCXSWSlfQDyCVA+GNlotZZ7C9LhQ6RwFW95k07GlMWHZ8iJa/MuKcYr4j72HgyD7Y3ccVPY3a+4Q8b0Cms30blg1FPOMVNZUQNmXmXS2XhxkzsgU6tIAGWpKXS22hE3PZwbdGS4jyNMWpxou8+yqBzTQdWRJ1JNB8d4ZAByDbz4iBCJ6sn/75NEd5bqk0xOiZF+v856YOCJMJ0ij27/XryBTcQBbN15r9LYzbRoDdqWjeloLIVOsb887OzVGpPFxlDBWSO+IFgM6XA89JBdYZew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wggY0OKYZQcaz6FRBCsPvnF8z8q4KpEMT2RaSMKhEZc=;
 b=USSC2hAAIIGnGY4lEag4Jw91u/cIdQvCa7sdCB7/yY+19y1qX4MfIsYfUwHBFf1LTVj8Oah4xHQ7KCg1VBdkoFSv8Gtw6h0yhHLoshKnUCNDJwrldYJXcaz30HzduAV6fYfGUJaqchfxZJHldxnV5QXh3SaucLUBEjMNRp4FfEE+I32jT9BG+gVCLpETkLY/CmizwaqNPheiheXMDSbYOes/ndO1MWBb2PXp1UY2QjKjFsQjNR5NaWr6uHz+gytInvyFzVMjWHP+n6Cycz1VbzKxs3gXzJau9HG9Wij6AifDd+/D0UlGWFPu22Im9Qhjj+sTu4A91rNHAH6YL/iPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5200.namprd11.prod.outlook.com (2603:10b6:a03:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:31:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:31:16 +0000
Message-ID: <19565646-074d-4c53-aa30-2b6145429666@intel.com>
Date: Thu, 20 Jun 2024 14:31:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 12cf31cd-f27b-4d74-190d-08dc91705100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UTF4SDZXbnJLV1FlZk1hVzJsM3JJWU4vT0s0UGEzQ1d3dmVRTjhuZWtVUzNx?=
 =?utf-8?B?WVE0aE9PU1VuVVFoTWV3eGdWYlVqZ0laZDV1amdseWcwR3VxQ3dETm4xL2R4?=
 =?utf-8?B?bUwycmZSWVM1d0hselB1SU5pTTJyeDBTeFhZWGNkbXRJWnR0cG4zcEhXanc1?=
 =?utf-8?B?UUdqN3RQeWVMQm8wblhBL1dRV2NINFlDR0RxU1ZVVjRYMTE2QSt2MHVURHAx?=
 =?utf-8?B?dUpCRDNyN0VscEFTV0VmMkNicWVwLzZJdVBCczVCeWpHMTcyMldZbk05VGxM?=
 =?utf-8?B?bHYwMEtJRHRsMUxoZFJ4TkVGdWNGd3FOeFZwT0E2bGJydWY3Z0h1R3Z6Z0NT?=
 =?utf-8?B?TTUySFpHMWxKKzJsMGJjQ2p1K1pINkVQRkJCQ0VtOEZseXIvZVZ6RStXcnlQ?=
 =?utf-8?B?cFJ5WW5HNS9lb2pNWHFhV1Z3a2ZmTEU4TUsvVE1rQVcycHdiMmpISm1xY3NB?=
 =?utf-8?B?bitQMVFVelNOSVExN204WnVKVkZReXFZM1Yrc2xVb2tVcEs4cWwrR3A2MGcv?=
 =?utf-8?B?Z2ZzS2U5RjVuUXJ5NU9tUFhGMEthRDZRUVUza3lRQWVsaWt5cDFRbGk0eWxT?=
 =?utf-8?B?VmhRMSs1bGw1Vng2QXltWDZ1NFU0dDNkSWNnWjhocmgwREYrODVJOEpFaUE5?=
 =?utf-8?B?ZHZMdmhOM2wyTW95TThPYVFHdHdhb1E4Mmo5RFZtZ3pJampaSVlDbzVVYVpm?=
 =?utf-8?B?bEZKSmp5RXZlNWdkQndsS3FZYlRkRnZnSFMwVEpULzBjZGt6MUFTWjlPKy81?=
 =?utf-8?B?Z002UEhEVnFUejRZbmpGOE85bTFGaWJxOFlQUU15ZjVWeUROenllMDlTYWdv?=
 =?utf-8?B?WkRhNUJxa1dpSmRBODdubXRkaVI1N0pGczNQS1cxQWtuWmlpUlN2bTk5Ukpp?=
 =?utf-8?B?Z3ZsRDBuOTFucmF1MmNZS0pybTBjTll6RnVlMTJYNE9RQnd5d1RDOG1zbWlv?=
 =?utf-8?B?Q1cxNnJITmVPRU1SYlQyWFhKS2F4bDNDd284STk1aGZlNjhRS3UzWmtkN2FZ?=
 =?utf-8?B?L3BKci9kVHpPSzJpZThJdkp6ZzYwVC9jSnQ1STk4VjZ1L3JlKzRIRVMvb3dZ?=
 =?utf-8?B?elB0ckhEVGhGbkNRaHpPc0RpRXZCbU5lL0RMVjJFdjhFc1lUaVA0UTM1L1Vh?=
 =?utf-8?B?SytEK24yUmpyNHBmcWRmNTF3NzZTczlnMlRyejZPRWNhTDg0bS9oZGxMZmo4?=
 =?utf-8?B?NVBJYlMzYjZ6bGRjeFVjL0R5d29KWDZ3QStRY1FMOXQ1anhVeWRheUtMN21L?=
 =?utf-8?B?MEdjem9mSG9MdW1TeWhwYnQyYUlwbkplSXlnalIvWGFHWG1OcmQrL3FNc2gz?=
 =?utf-8?B?SHNLdUlscnRTbWVyQXZuOGF5Y2NDM2dzaGU4WmZSbG5TcXdCR3BhMndYSStj?=
 =?utf-8?B?ZXVreDJPek5rRVNHRGlxL2J2TnNJVHdyT1g2UDc0NUhSUzFad1hCK0crNTlD?=
 =?utf-8?B?UXN0dG5CeFZiaU9CK2h6eFVkbVRJM0JLMWgvUUxPaDgyK2dUWXRCMDVWeGlv?=
 =?utf-8?B?NjVtUTBmbTRFb2JBTTJkUFpXMG1hK2xjVURwNXV6OGNjRVY4K3VxcHZaZEhG?=
 =?utf-8?B?T3ZWbkVVSnk3Wkt0YTd0MmZyM3RaK2ZjMXpDWkRWekJDQ3lRNVFBTnRxeUFq?=
 =?utf-8?B?d01IWjllM014T01OLzJySXVoSHQ1NFQ5d0ZKMG5kVXRrSWhwVXp1UnlpdzNz?=
 =?utf-8?B?Y1FVbTVMcjk5SWYxWk1Sc1MwcFpFL0tIVkt6anJpekFHMXJWS2ZlWWZRWHlk?=
 =?utf-8?Q?fSlh9y1675O4KOUAGhuJksi7vLWa6M9bvZmCya/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGxxeEw0MUxteUVyaVZsSHJjbnphYkF5bmNOUUtjbU84K0JpOElWK3h6dnpq?=
 =?utf-8?B?VU5nUjY2cEIwZzNKekZvdzJqZERMYzdCV1hSc1F2VDN1SUpOS0dGVzM5WGRz?=
 =?utf-8?B?b0h0aDZEVmZEUFYyd3o4bW1pV01RYW9QMWw0YUZzbTdBK1l0TGFKcHNNeTJT?=
 =?utf-8?B?R29YbEQ1Qm9PbFkyQWhiK1ZMZHdZcDIrVXFTYkxHN0MzOXN4UmFWRldWRmRZ?=
 =?utf-8?B?RUVZSHdvc1lsMjRzR1Rsd2hVUnZUanNQQ3RrWURDaUVyemNRNENyaFkzSCtL?=
 =?utf-8?B?eDNLTnVoM1ZsOEx2cVVydHRKSzNvcHdEOTVFYXp1L3RBb3FyWENkSEdPSnd2?=
 =?utf-8?B?VkF5Nzc3ZWdqNDVEZGh3RkpKOXA4RWNFd3VkcSsxUWVVUlRBN1FLbmQyY1Ay?=
 =?utf-8?B?bFl1K2plV2FlWTZSVFcreXVTNXJ0Q3g1WDFLclRmb3A3dFVJTEIrRU1aZ2lQ?=
 =?utf-8?B?NmRaSEV3VTl0MmJsb3dHb25yMjVqZXJXdmtKQmJzZ0JJZEJGSjFMV2kvQmo3?=
 =?utf-8?B?eGVENG5Yb1d6Vi83WllhWXpCSFlVQm9WdXhwV0k4enZQckhydGxUMjdvcnpo?=
 =?utf-8?B?Ryt4NWYxMEZqRWRMVUM4TjIrWUYvbU1laVZEZWRLaVZleDZOQTBLNmpJMlUv?=
 =?utf-8?B?MlZldldDS1VWSGxQelB1VnczOWxoK2dKUW43WDkwWS9hUWdYanFMTW5vVUxw?=
 =?utf-8?B?MXQ0emRleXhRa1FlZXJkcjBSRlVVRUlGZHM5bTFIZi9mT0xDbFhwRGFlWERL?=
 =?utf-8?B?dEVpZERYbnBTL2dPSW9kWWRYTjRQeUJmcUg5YWJHZys5ZGRmZW8vWjV4M1Nn?=
 =?utf-8?B?RWhkRTdUYlFScmVOWGUxc1NBcW1OV0ZkRzl1UFlTaTJIWkdYK1BWRzY0dHUx?=
 =?utf-8?B?bjJSN2cxVGYxN0NjMkREQjNLSDFLQ3JHeVZMUDRoa1Uwc1c1QlEwZ3pTd0JK?=
 =?utf-8?B?b0pmdEp5NXZMOTRWVmJXVm8vR0I3MzRoVXV5b3hRWHltbmJMaUNmVFRmV1JY?=
 =?utf-8?B?aWJEdmdHZHZBbyt2WjFINm9kK2NGYUo5K1V6cHJIOG5jTEo1ZWNXalVyRW5F?=
 =?utf-8?B?ZDZJZTZYMWhRU3JVUkFwNjJQa1JiU2xWb05lZ3o1dnlTWm1lWHRzUjVxTFFS?=
 =?utf-8?B?dXNLM1BZWk1kU3NKS05zRDVTVGRvU0dZOXdYa2NuU0hvN0VXcGx1RGJiL0lK?=
 =?utf-8?B?akk2aWFuL1JOaVcxWHpvbUM3R2lkRklkelhBSk1uL0lyeEwyNmJTdzdjMjhG?=
 =?utf-8?B?aXBuL1dxZDV0eVZUMThhaDVPL0M1UXI0c3VzQzhEd0o5YVBoWVgvNSs2enRS?=
 =?utf-8?B?ZmU5UXlrNE9od2owVmgvTFk5RDYweWhOYnVRT2QzTWsrTEdJZ29IYWxuQjZ0?=
 =?utf-8?B?ekFjTWFiUG5UVlBtekU5eDU0MDlubFY3VzMrWVVhczZkNVd1NXpndnNRbGdK?=
 =?utf-8?B?dmMzVVpoRVNla2ExcjhVNS9ReXpJUGVmKy9PZGVYOWp0ODI1aWJ2d0tnKzR2?=
 =?utf-8?B?a2hHUk1acU9XSUZENThXMlJQNW1rVU9rM2JtWGtybHJXSFNZcXZhVk9OUlh6?=
 =?utf-8?B?V2xGa3Q5M1hLVmtraU9vQUtWOUdhT2RLa3loVExvNitHWnJMWmlPb0pGdENa?=
 =?utf-8?B?TUp0RVdza21mTlVTNGlmZTcwbmRVTkx4ckkwTTMxU1lCUzR5VmRZWVk3bW1S?=
 =?utf-8?B?L2ZzSU5aRlFSL211NTZVakZFOHlKVm83QkNJT1hpZFZMZHpMNUdLemdpcWho?=
 =?utf-8?B?bStvWExtMHB2MlNwT0JRdmdRM1NNM0NHZEl1UStxQnlVcWtTcjZlclpBaC84?=
 =?utf-8?B?dzl6YThFV1FPRWFsTnpxbkVhdUhqN3BFNXo1QlFlQTYzRnNBM3ovN0dKRG81?=
 =?utf-8?B?b2JoamVyYTdQdjRyYW9VYzg4SU95WkNIMmxGVGFWTUt6dnh0NG1BdVkxODRo?=
 =?utf-8?B?bmxaTERRaldmZVVNWmRkOEw4blBlSm0vMkpmd2tXM1hNUWdxNDNKTU15WTRk?=
 =?utf-8?B?a29jelc2WndHYW8yN3R3WHBOMTB4aE45YWRIZWxkN2NZUlprMFFvcXcrdHJ3?=
 =?utf-8?B?NzArOW41OExWd2J3VjJoR2FseUpwMEFmWk5ESmk4TThCd2E1QkhwdDJGeHN6?=
 =?utf-8?B?U096eHMwa0JZSU1UV3pTWlA1TGw1UU5CdFN4QjlkMW1ZVkxlODdiWXhadnBZ?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12cf31cd-f27b-4d74-190d-08dc91705100
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:31:16.2901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouBD5MkKcP57K7cGS+zSsoBTlivbkEQa3AFFFeaKh4GJEU0KXwBDHee5tkWI0okBdIWfTkwg1vuKun+dLSHru5fMzA7dJrozJ1/2lqknBVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5200
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> mon_event_read() fills out most fields of the struct rmid_read that is
> passed via an smp_call*() function to a CPU that is part of the correct
> domain to read the monitor counters.
> 
> With Sub-NUMA Cluster (SNC) mode there are now two cases to handle:
> 
> 1) Reading a file that returns a value for a single domain.
>     + Choose the CPU to execute from the domain cpu_mask
> 
> 2) Reading a file that must sum across domains sharing an L3 cache
>     instance.
>     + Indicate to called code that a sum is needed by passing a NULL
>       rdt_mon_domain pointer.
>     + Choose the CPU from the L3 shared_cpu_map.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

The kerneldoc in patch #9 introduces new requirements related to
struct rmid_read wrt how NULL values are interpreted and
used. This makes it essential that struct rmid_read is always initialized
correctly and should no longer consist of whatever is on the stack. I
mentioned in response to v19 that static checkers found issues here.
I understand that mbm_update() always sets the domain in
struct rmid_read, but I do not find it acceptable that it
passes garbage as the cacheinfo pointer based on subtle assumptions on
when/how __mon_event_count() uses this field.

> ---
>   arch/x86/kernel/cpu/resctrl/internal.h    |  2 +-
>   arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 39 ++++++++++++++++++-----
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
>   3 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 77da29ced7eb..75bb1afc4842 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -627,7 +627,7 @@ void mon_event_count(void *info);
>   int rdtgroup_mondata_show(struct seq_file *m, void *arg);
>   void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> -		    int evtid, int first);
> +		    cpumask_t *cpumask, int evtid, int first);
>   void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
>   				unsigned long delay_ms,
>   				int exclude_cpu);
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 3b9383612c35..5a43931fd423 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -515,7 +515,7 @@ static int smp_mon_event_count(void *arg)
>   
>   void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> -		    int evtid, int first)
> +		    cpumask_t *cpumask, int evtid, int first)
>   {
>   	int cpu;
>   
> @@ -537,7 +537,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		return;
>   	}
>   
> -	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
> +	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
>   
>   	/*
>   	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
> @@ -546,7 +546,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   	 * counters on some platforms if its called in IRQ context.
>   	 */
>   	if (tick_nohz_full_cpu(cpu))
> -		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
> +		smp_call_function_any(cpumask, mon_event_count, rr, 1);
>   	else
>   		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
>   
> @@ -575,16 +575,39 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>   	resid = md.u.rid;
>   	domid = md.u.domid;
>   	evtid = md.u.evtid;
> -
>   	r = &rdt_resources_all[resid].r_resctrl;
> -	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> -	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +
> +	if (md.u.sum) {
> +		/*
> +		 * This file requires summing across all SNC domains that share
> +		 * the L3 cache id that was provided in the "domid" field of the
> +		 * mon_data_bits union. Search all domains in the resource for
> +		 * one that matches this cache id.
> +		 */
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->ci->id == domid) {
> +				rr.ci = d->ci;
> +				mon_event_read(&rr, r, NULL, rdtgrp, &d->ci->shared_cpu_map, evtid, false);

Please split this line, it is over 100

Reinette
