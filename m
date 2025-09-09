Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195A12652BD
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455992; cv=fail; b=bZbu7BWKbULg3U05HIPnJ+4NtjIgtxSAM1rYq+F+gYM9lCPvHhTfsnxMIU7YB7rtJXr00/dO92FIXgpLTiPESKql22yuuz7rOAHHgQYRJwAgDp7rpkaYFntw1uErLkhPK5EGFz38hs06Igv5jJHqNHFf9CSZ1dbbDwktlLa2WEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455992; c=relaxed/simple;
	bh=t5OxhEAXf5Sc7PfEyhhoHkfO4XJb1VetFbxzqGG6Z9Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XLdXWKcbS4l6IyDn+HhnmPB6sF2iQRqDeZSg13VFl+wwxXdg+qIibpDRAlG3rneK/xx2pAhCvqprEde4Y5fzoAnnNGRqZOzCxMG374XgsUg8mkUUJuJ82nTYCJB99mLIjncLWm5tHaawJ7vHBuFpRMGoh/KyFFmVG/S7/cXLdMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sh+6LRvp; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sh+6LRvp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455991; x=1788991991;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t5OxhEAXf5Sc7PfEyhhoHkfO4XJb1VetFbxzqGG6Z9Q=;
  b=Sh+6LRvpvWXxz2Wpn/zYTCCVa835VX4zmrFlVUcVFn7ywTiJvww4yR95
   sqL2mhZbRehoLj1URKDfeFhhgicoshh2az4R2xyxOAmgIE89eZPvP2gqb
   ITdHwe5wG7d9SKfpcILtNJ/8/iBDl3YLSvzHQ+Y+p6UbkJAjLphTWwDDx
   WtxdgOsi4zfFcFTIxuQF6SJAE6tmXeIW7vMH1GcXXQ1WMEXbdxc8gQ8W3
   hu05MSGdTiAm7BpsySdG2C9tlivBt97TiXphoYMsFzQtEYPhDHTcxfFH9
   jxKe+8DdV8EDBjEZ5FagV8xUGepoVGQhOKhORab8enryjcNBsVoZTy8Iv
   Q==;
X-CSE-ConnectionGUID: S76nFjwtQ+G9D4v3CdfRRw==
X-CSE-MsgGUID: P1PN05cHSYSS9Zg2qNHRaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63586259"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63586259"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:13:11 -0700
X-CSE-ConnectionGUID: fr8tSkOpS6Ksw7UHdtLjcw==
X-CSE-MsgGUID: fLCixs/3T6+p/Q79QvXDcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172783527"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:13:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:13:06 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 15:13:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.52)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:13:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJle6/XXNQJnFH4QvkykypcB4ssyVRPoYFFhSqguQkG45y5bqmhJ1Z9um56lD5UIjUy2+tpA5l/CVrQlTfcZpMm+zpYgqslSR+trnDeLawbqQqk84J+bfZpaAYd0EnAtbg9scAqrg9hN6xeWEseBn+7dUNMpSQfEtsUWoVNq0wuweQd21DzdBZhXOL2fdO/XwAe5Zqs0jSlRjXgJazVE5YldfciFMla5xgPngGuJ7glwoSmUL99BzfJK8y0tA/lH9xsbLm6uT9TKczw6mUGrjC9Ea5uIC4xYI8XtsQmq5Zatu1TxofGnNvPRERsLEyZp7L0vun9gsR2xgyGinUDqLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDljOYwB4MKPeD40pEt7yTHf5Lv0W3mkmPeayP8rSys=;
 b=IuJUDIuyUNzj3au5YCiGetdgmge03D40mmTfqdoHTDdrhX+Dkc6nMKyeZT1F9BJfQrZfgyetZ8lAxeZOpMRT8HHbFwD/bTtaC77TWnlC1buCbqlprhSKC8jId7m/rr30ZjbEt2All8JzmfoeZEbncjDsiMysOgtafHdRZASJPuK27pFAIDJ64zzI1cDoiikfCQPsayRp9LnOq0aX8FnkHnVkALHcwCsOqjDxwIUwzR0R7FA0yrz2BLu7EsYvKjNctsyjCQ9yjxAhOPJA6bN76rh5XzTbQfMGWTzGXh86n0Fk7klq1LzLGSSYZdYEEYdgLVEUTyoADKHc9voUTSusrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4836.namprd11.prod.outlook.com (2603:10b6:303:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 22:13:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 22:13:04 +0000
Message-ID: <7b0ef715-a587-4293-9d79-c5e6095d4cf8@intel.com>
Date: Tue, 9 Sep 2025 15:13:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/31] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4836:EE_
X-MS-Office365-Filtering-Correlation-Id: b02a9c6e-f2cb-40d9-c73e-08ddefee0c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TjRHaUwyY2NCaXhsUkROU0VkQXIxdGVPSE8xVTRYWlZtUzV6blZ5U1F6cXlt?=
 =?utf-8?B?ZWttclltM2pPb1NKdmhsWm5TS1VGTHI1YUZ1OENIQ2NqRVVGNFpJWHZZaVNu?=
 =?utf-8?B?a2pkYUN2UjE4UllSazVKWW01aWh0VDRlOWRNQldOWjUwdzhRczZDWGNTSkZY?=
 =?utf-8?B?MmorcjdLS3BaYStKTlo1TVQ4U1YzTHJUUmxaMnJLY1U0REwwY3k5NXdFR2ty?=
 =?utf-8?B?eXZPM3VtdGI0Smk5ZzlEN2M2cWtiVWhjYXREaml0NEcxaThiR0ZJRklqSjR3?=
 =?utf-8?B?VTZNUUxuZ2JVN2M0ZFdwNEt1ZkVRVjRRcnFwcG5Iei96UC9oaCtuNnh2YVdi?=
 =?utf-8?B?NVV6T1lsV1I3VFVIVWlYUmRMYUxubGIvMElGbmh0c3Z3ZlU1K0pyZnVuWVU1?=
 =?utf-8?B?S3Blbllkb0lVbFFTYVplYm8xQTJrT3gybVhNcVpuSC9JMXpSRjBLRldETGIz?=
 =?utf-8?B?QzdWbWZiRXVtZGh2S0Yrd0xiSUhSbkhacURQZ3ptc1dkYVJRWjZqWGhiQWp4?=
 =?utf-8?B?K2RxZDlQTnZkRzljcklIMklBWkVmbm9weFRJcnVoODNJUS8wV25CUUQ2cWgy?=
 =?utf-8?B?dE8vUWZNdTd6K1l1QVNPK0VTSGtQZ3F5OFBqRjFjejNpWjdpRGQveUhIamJ6?=
 =?utf-8?B?SktyTjB1UUx6L2FZZU5TcUdlRVFpd1hQbXpaSEFvZmtlT0JhU21ISW43YWM0?=
 =?utf-8?B?UW0rNnVKSkgwV0pDcTdkL29WTjduQ0t6ME9GbEVVRkN2eG01eGVaWUtpYmVK?=
 =?utf-8?B?d0FPaWdWRzZoU28xU3hwRnVhRzZ5TkZwajhrQzhYM21SWnMrdmhTY0E4L015?=
 =?utf-8?B?Zzk4NHh6bGE0NWVOSVdwK2I0a0pSanJ5VkNLOVRTTE9NMWpvNURzZ1p6SGMz?=
 =?utf-8?B?RkZQeEJKdG5mMkd2Q1FJU1pLTkZUKzBWSkFaNXRUNXRkZDdpV1ZyRCtiT1p5?=
 =?utf-8?B?b1NnSmJyWnRVUTBuSlE0Vldtd2ZlT2xKQnNMWGlqV2ZJU1FpV3BZUDkvaDNl?=
 =?utf-8?B?bVBlekROYnRib01acU12VnRCYUtjQUFHVXA4c2dXc3lyTWxiZHF1ZnAzMjJX?=
 =?utf-8?B?aXRySUNBQjhiVWdTaS9xN1d0V1kvU2YzdVhBeEh0RUVCdEZrNVhSM1UvRFgw?=
 =?utf-8?B?a2pnZHV1NjJoUE1aaVhlVVlVUWgyT050cXFmbVlnNjd6L3F0TEo3QnU4b3ZU?=
 =?utf-8?B?MWFMa3NaZCtSR2l5R09oVWx4ZXJ1ZlBXZWg1Tmx4aGpsT1ZBeExPZVJGTTl0?=
 =?utf-8?B?dnFzVWYxR29oUUVRd2tqOXNmVDFlZCtUZnVPRXlYREM0MU5rNVZFcGNBTFpz?=
 =?utf-8?B?YkdSRDNBQWkraEVqNDNBQUhmazh4RklRbTI1dDNSQVNGZVluTGVqKzgwT0Y3?=
 =?utf-8?B?QlJZWlp3SHVYTkNRT0Y2dXhxMTkrTWtJNUN5a281ZzNNVkdrVFlkcXhqUENu?=
 =?utf-8?B?UVY2NTJDT1IwdEVycUxiU2o5Z1NGSG5IZmpPYUJpYjBYdytPWmhlOEVrN0c5?=
 =?utf-8?B?UWJZcG5ia28veEZLZnV5Qjl0UDhpUERkT1Jkdk0zWmk3eGpLN0pjMC9vTFVJ?=
 =?utf-8?B?TVRDWDl6WGtNV1AyZU9oYTFEVklhdE9DNlRIRmtob281K0I4RGlnMlRtWHIy?=
 =?utf-8?B?UmUzMTZxV1VVc1hqSlg4dUlpZnh4cEdYVkM1WmsvNGlmNWZsVktGYzQwM3d1?=
 =?utf-8?B?ZHUzUUtnb2kxTHd1SnhZR1BSYnJJK21MYnlDdUNVQVIyYnB0LzRjKzV3dm1o?=
 =?utf-8?B?dE81eVpnaEtGSldxTXZxUGphMFNVMXNiamRWZ3Y3UWVUR29EY1o3NDBET0tj?=
 =?utf-8?B?SW45SklYemtZQ2tBaGNJdDM0d2VSVWhveDljbXJrVWZvekFiKzBncUt2RXRS?=
 =?utf-8?B?RTBmN09LZVAvN2wwaEFacTVLZjVzNExWM01KUm4vYnU0ek5mMGVxem1rZ1Q4?=
 =?utf-8?Q?ciUe8UrZKvA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amN5RHFFaXIvSWdHdXI1WWNlQ1o4U3RCS1lDMnkyc1NtM1JCNXRWamZ3ZHpC?=
 =?utf-8?B?TjFzcHROMThpaDM1b1JCTGtMNHpLaFZ4S2xJNzV1Q21kSk5VRFVnbUYrbGc5?=
 =?utf-8?B?T1B0clJwUzZ2SmxIV0VhMzQ0WmVOTnVLMDdZZGtYN01FVnVGUHpDd0swVWU4?=
 =?utf-8?B?eXlEY0k1S2xGcWJSY2tEYitzTkxEWmt1NlFsTzlidExMeVpWc2N2cGhrQk9r?=
 =?utf-8?B?RForRXErb2dWVkNPZE44OERaK0JJMmFraWoxLzNURTZUK1BBK2VNa0J5emlz?=
 =?utf-8?B?cUpjenJtbzZWRWtvams1cmxVZG9WeVhPUWg1V1daaFNReGFnZmVlMWo5VE9p?=
 =?utf-8?B?ZlJyTk5LVDJyeFJwVFc5QnRHU2hEV2l3SUpISFF6c3dGcC9BQXpGV0NPZkpY?=
 =?utf-8?B?Q0E4MFJkcFdHY1VBWDgwem1zTDIycVhFenNxdXZLU1JUbUt4blBmb0RNVUtI?=
 =?utf-8?B?MnhzMENSWUlydi9jTHZBY3lIejROc0E1MnlmbU55c0wwd0NJY2gyMXhVamkr?=
 =?utf-8?B?UFNHN1NXQTFxejIzVkRDcUs2RmduQlZabk1ZM0Z4eUk5cnhRblRPYmpmZlVO?=
 =?utf-8?B?WXFLZWN0aW52SDZQWXdUVEpoUHIwcXBiQjVKVUJaNVYwR2t4Y2JCUVM2Nnhl?=
 =?utf-8?B?S0tYRUh2QlJ6M2I0dW9sVklxYU5ZUnU5RDBISzFyNC9tVldrNkcxa1R5bU5L?=
 =?utf-8?B?REcwMWxxMmVPTXllTG1RR0VxWTRwQkVJdTFBeVhoQWxzQ05zcUJzN2hHTTU3?=
 =?utf-8?B?YWRzazByalJpbXlnQ1ZUUk04SkF5bUh4RiszODhySVE2WXRQeS9UT0g4KzhV?=
 =?utf-8?B?WHlHMGxrZXlISEJUNEdpQTB0TXJpbS9ML3JiMHBzaThyc212ZkZJblYvcDNO?=
 =?utf-8?B?NHQ3a21lRUdpK2prbDBVbk14Q1UxNEN2eGVjY2tqc0FSejk3Nyt4VU1iMjBN?=
 =?utf-8?B?aVdabjZiTVpkak12KzBBZ3FrWmwrbWFIZUV5dHVmNnVwMzNHSDFjVU91WENt?=
 =?utf-8?B?VXVTR25KR1hQbW1TWTVxL25DVmg5M3hQM2JvWU9ORWlJZFZkOW10QW1PL09D?=
 =?utf-8?B?ZGlJNkNralRtb2F5bnBYejMrNlY2dTZDaWFRcjM0R3hLOFZDbTlnNGR0dTVa?=
 =?utf-8?B?VXVUK2VLdUthSEQycVRFUE9USUxOOEJpWlY4TXdOUGUyNHVsdWZxWlFQKzZm?=
 =?utf-8?B?UEFVRVQvdUZEdjZPVEtyUThXVjJSb3hvbzZrMEM0N05uNmZ4ZWd0dkN5T0lu?=
 =?utf-8?B?eW56UC9pRnk5cmNMeVFFUDF6MGp1T1FOWTdiSlF3b3hPL0pqTmhVOGtNYXNK?=
 =?utf-8?B?UTg4bm5OUnFDT1hRVTNWNkFVYTVDUEhybWNielA3Sko1RGF0T2VTZ25iMkZv?=
 =?utf-8?B?elhNWFlQTTlGRGpaeUx1SVIyb2ZmTVZHRHNZWWNLUlYrMFpXZDFQQVhvN24w?=
 =?utf-8?B?RjE2QlV2THhEUTluZ2J2VmNHbVZFK1E1b0Z5WTRYY3RJTS9HRUc2VVM5RmZE?=
 =?utf-8?B?d3ZnTm4rUzk5b0ZMOUpnOWdkUFNVdzJlT3RFT1Z4UFhMWm5NVHRnSVE5TExr?=
 =?utf-8?B?cjlEQmVOcDNYRmplenRNSEtSbkNkTGFwWXdwNHgrMVZBMFJoNmJrSElIY0ZV?=
 =?utf-8?B?RzhJV3VxR005blpXa1lYMGdraXk2KzA3VFJSTW9uODJmQ1VCZ2xQRlFSVEx2?=
 =?utf-8?B?SmJ2ZGxxZjlaVmwvSWEwaHA1TkM5U2wrcEVsamZlbFVmMHZCN0VFMU1BcmVU?=
 =?utf-8?B?S0VDcUNpd3pyRmxjOWs3REhsbW9Wa3RMWVhVOHpIc25hK2lhRi9WM1JiOHlx?=
 =?utf-8?B?OElhOEFvdk5TbTg1OVJieHZLbUw2eTYrL1NPNWpMQkUrSzBMKy9OMFJoMmZx?=
 =?utf-8?B?djMwRGRzWW81bGkzZTVXaVhNeWZtTzVqT09lUTBEVkU5Y0FFbC9wL2dJQU9s?=
 =?utf-8?B?N3ppZE9Rd0ZOLzEvM1JJaXIrcW12b3g3bkhqUlJBWUtINTJEZHFicFAxcks0?=
 =?utf-8?B?SWl2N05lUE4xdkJqMVRUZ2drazl6WjNNV2lMTjlQMkpHZmNIbk4weHJKaC9y?=
 =?utf-8?B?Snk3ZUI3Y3Q4OHFiSzRWbkx4d25OdHFVanR3SXBiTklYN2lrZTFyM3ZwSWhO?=
 =?utf-8?B?RUFzS3laZnZ5K3BKNDYvOWVWWnNqOEg4MnJPNzRHVHhWL3pkTzE3Q1dJaUly?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b02a9c6e-f2cb-40d9-c73e-08ddefee0c4b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 22:13:04.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ngn+DXte4003ormHN/E6wM2dhEqFH0z6Ran0YBQusePCtLZJZS5nOC4Pm0lYGAh1emNYFXg+nZOB0H3nEiaRi5mC0sT5buLT+rYbV5mBuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4836
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 81c3fb6a95b6..7332e65b0e01 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -356,15 +356,47 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
>  	return state ? &state[idx] : NULL;
>  }
>  
> +/*
> + * Called from preemptible context via a direct call of mon_event_count() for
> + * events that can be read on any CPU.
> + * Called from preemptible but non-migratable process context (mon_event_count()
> + * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
> + * smp_call_function_any()) for events that need to be read on a specific CPU.
> + */
> +static bool cpu_on_correct_domain(struct rmid_read *rr)
> +{
> +	struct cacheinfo *ci;
> +	int cpu;
> +
> +	/* Any CPU is OK for this event */
> +	if (rr->evt->any_cpu)
> +		return true;
> +
> +	cpu = smp_processor_id();
> +
> +	/* Single domain. Must be on a CPU in that domain. */
> +	if (rr->hdr)
> +		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
> +
> +	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
> +		return false;
> +
> +	/* Summing domains that share a cache, must be on a CPU for that cache. */
> +	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);

This patch itself looks good to me. I do expect this patch to look different after
the rebase since get_cpu_cacheinfo_level() is no longer called. I peeked at the new
version [1] and the series looks significantly different. The thing that I wanted to
check was if you kept the WARN_ON_ONCE(), which you did. Do you think it is still
necessary since there is no longer a get_cpu_cacheinfo_level() with a hardcoded L3
resource? Otherwise I assume that this check falls into the same category as the
earlier SNC related warnings and was not actually a check for the RESCTRL_L3_CACHE
that followed above?

Reinette

[1] https://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git/commit/?h=reinette-abmc-aet-wip&id=9f2f31b9dbb0d64c65b9aad754afdcb36935d719
