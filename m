Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDF5340417
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012547; cv=fail; b=tCRWXxp84e439Rof+AOkW6UYibq/8b+f/G/Rou5eOOxiVClJ7Ofu7d4Ax9a8eGuZge0leLFbFM1BmeYlhQp6+7anJObeMTfFf5qgGB30W+oeSavjKczHNULk1mQNonPoKuZb81kc7bocUq1KHKR/OPXVrqvtbMmfLMUpYfUvEVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012547; c=relaxed/simple;
	bh=14GLibyV39Q+DwbpXtxHAqIfkRylCIbzdW4rPDgXAtg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C/VEE29GXHh8WdV0XfXEVZN1twD8TkXCWMTyFjx0DhFQKxUBgHW5XCU162vNLLY5xqqtnztI/Ocuxl1Xw1y+H2u9Zxz+FHbWNOXmh4gIV7rPtcxJ7uHYpYZ05dW0PxGNd/0YP5bC97t7K0lmMHDk/L9RGeFx16sOnMLFUcIc3qU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=harmIxVl; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="harmIxVl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012547; x=1820548547;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=14GLibyV39Q+DwbpXtxHAqIfkRylCIbzdW4rPDgXAtg=;
  b=harmIxVlpmXqpG1E0+hqQvEaXvkUuHYCg6dB6C7BXpppZIPMMV+c8eWN
   eLARCOYGJFMe6bHwwmKRScbi4BN31t1TOVMMbmfAD55MAoRDhknNVa2Y+
   ga2Fkd7gx671amF9jbQ6UlnmHX9nLN6g16g0P5fl2zGKe+HwWYY/iRA9N
   FM8cEQYS8Ov5aC+/97mBb6vX7r4TQJRCt6rqH0aQ98AhiP3BAa4sw/jnn
   jFYbdd0dh2G2L8rK8qwt4D+PY0n9Rp7TeND81OKml56+5oHdsb8pftR67
   geyTf07i/kas+1/ICfmUCZnWU+mI7zMEtohs+HM6sbarl3z3NvTKohMs0
   A==;
X-CSE-ConnectionGUID: /c2XBId8QrCHAY46DVpT1Q==
X-CSE-MsgGUID: JGzK/MuhT/WVPQj4O04axQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100617713"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="100617713"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:55:46 -0700
X-CSE-ConnectionGUID: G+DZ/jU/RWetM8iy/TDzIg==
X-CSE-MsgGUID: swskGd5gSMi93CnmitA3WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="267221960"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:55:45 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:55:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:55:45 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:55:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLydNQi732ooe62GiVYifjYsJe6Kc8IA1mUzUWF7wYicq/C23gWvMkAB3MQ3kJggnLp9gfohs+rJiK3Ad4LABRsyYSGdklTdZeaBxCxDDTfUWmZBfyEzYHdfspzRuT7PfosoUdXwlXmC1ghAHf7fYD9D21sJDfqbY/xwHWWwpd2jraFbzAVkazIwRos6mOYC/PsSETlPDjZ6zGSXfA5ljpQOSH2oXnjAewMrDlDZg9zGic7u+nOTotcqN47+Ll/KJkONHpQrHbS3FfeSvuZNZQD94O2d+9RSowvKlm9NnfqkyLL+Losj+y5nz1oiMqzTfTYkNB29aBTdaW7Q5TmBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJKxOG66dCvh2S5myN977+NJ+2uYf043LAtHBTRih6U=;
 b=b5kHJa2lJWoBBJB49IzPS3qphmny4DO5ImWKEJfXwj0Fioo/T1O8FbYRwduYFf6YeP6mZ6rfTinOyzF2LX4ZDDnV3cNxfiI6lR+OyBrBSdYxk+EFXvnqcTcWGrQpM7ariPo/P27RssN1w/2+SRztoxt8NdI2LXzxN8duB5KFeJfXmq75I9Ec684as1sNlGPQxtEQ3C48AeIMHv2is73kc2bptj7KptAcOhQh7/zdCCdCUqOT+QjIYxb4/VCF+MBBscDEkKNv8vn2fyAMx+4GcEWziZtKfmcuotI+DmXFndeGGtfC3rlxMAPAX2GdQubxbBH3CQ/jUpa9dNC61MXcsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB8073.namprd11.prod.outlook.com (2603:10b6:806:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 03:55:34 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:55:34 +0000
Message-ID: <f4ced57d-6748-499d-8778-ec0141c17136@intel.com>
Date: Wed, 9 Sep 2026 20:55:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 04/23] x86/resctrl: Apply Intel MBM quirk from
 rdt_get_l3_mon_config()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0313.namprd04.prod.outlook.com
 (2603:10b6:303:82::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f6524fb-2dfc-4282-46fd-08df0eef5df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|11063799006|5023799004|56012099006|4143699003|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: veirWujlb2UPExyXNqUPcJ+lPRtNxgURVa/+5lGs16pRH6o0tOdS/TU4LuixKVf0Vm8x3FbPpVi1wPoKG9mpJFCU0OepijSWi7QKGYYq+lZ2cz/U7j1gP3wml9EEPPXAY3rrjFuz/soWiTkk3Mqvll4uoJ2D/v0HZLFFKPcQqG8CxIB0r+TbZS6+B3v5Vai/28lMIYXkezANBka0NYqAhaR7As/JffptcDL4wARSkIt94pxfkcE36OOJAUAeJ9PNYEu9nVUz0D+oyf5jGdTalKKudW86kUuUKGh6qEY+FuOwu0GRnBMBaiT5KQkC/T8ZXKha9Omt0uoQh/HSqcwOEdFpuiFncY4IkdGGHc9TQahrz6CzZRyLU31vJbkaPlyyRsCj/H2817UUE9k9lps9pdUkpTAIeLOXnYqLS986/ap9H6FzNRmVXTChUoT0msZXwk8K8VIsR131kUX3RRiISQ71FZemANhp22q9wy9tqQlUqipt/wlIKbcIR5kv5WeGGYdqUjc6O3AL9VXhC5NOHTc7cYW5dm2OmFKSed/g07YVw/ReKxgwSxpQXnvp65gh5PATXRZ8IbEJjSpTy64ucX/bn0A7fxWo9R/DbAXIaT56v+99G1zSEWsn24Gi+g7ftykn3Z0GVJNf6gLUA6/0lSTR2OYHsHQX9GwXXwV6El9FYeA5JSci17EVHegpQawzG3MzHAF8wWBocp7++QlLdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(11063799006)(5023799004)(56012099006)(4143699003)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE10ZWtyVXZTSFp1MXFXeld3WEF2SEt1YmFtRWZaR0N5bHNqdGlkL2dsSlUz?=
 =?utf-8?B?aE1XN3I5bVRWUjBqM3lvQSs1K1JOSi9ldG9XVngyL0Jta2xFMGFBYkhOS3VO?=
 =?utf-8?B?MDB0TTNzcG9ianl1eWpwMElkUTNJNWVVZFhPdjRubW04eklKVTJ6WVNWb2pz?=
 =?utf-8?B?Vk0wYk9XOHkzM0xGTmtrNE9DVVdueG1GWEdoNlU2eWZFeldCN3dXMzA3cENN?=
 =?utf-8?B?WmlORGxnL2tEem5DVWRpYm95VENZRS91UXpqSzQyZTFPMVlWY0xhZmtZMWZ6?=
 =?utf-8?B?NG1SZkNnLzNNY1NXSThhOWJsc0ZDc0x6ak5ZbnhBUW9EaG9hUGU3ZVNhY1Fu?=
 =?utf-8?B?RzdYcDR5MGcrOWtwVFVuMDFSVzdmUHNIek9ZYVRjYytSaC92TS9KcDlzSyt3?=
 =?utf-8?B?QnQ4QWNoTWlmN1V0MjdvNUpva0VLOVVtcnNJTnVuTkFLOXRLZ0xuckZla2dY?=
 =?utf-8?B?N2JGRGtTaTNCSGtsSDZRandqZTFjZTRiVVNOT1gxNzZyZCtodXBuVUdLY056?=
 =?utf-8?B?R3RUR1RUa2dlRnJVdkVUZlN5SEc0VmpkNEx3WWxtblZTUzJjeDY2TURVc3BD?=
 =?utf-8?B?VXdDYjZDSDJJV1Jub011NUZnNHlsYVFZVjhVeTVDSlBscmVockZyUDN3bytO?=
 =?utf-8?B?VHhLN0x0SnZsczgrZjR5eUExMHBuM0czbXVkd1Z3VzNhRjZGTmprd21peVU2?=
 =?utf-8?B?UzFwM1RJQWJva0VQa1lTaWFTT2dzNDhyb25pNGpTamJ0TDdDbElsVm42cTJv?=
 =?utf-8?B?YVRpV0p5Y1FqWStuRjIrajFDYjdZQ3lweWt6UGZPRDNsSEpiWlZqajNLWGhD?=
 =?utf-8?B?ZjhjczJLVnVTZzVpckw4Q1E1dmI3RC9ramtMVVVQRTYzNGNVZm5kTERlWERB?=
 =?utf-8?B?MEZmcWxhRnIvMERKOEdXRmdNK0c0SG83WXdaYzN6U1RsQkc2cnl5OFBEalFW?=
 =?utf-8?B?dDdXa01LVjAyQ1psbkZLcXlCdnI4WGlUaXdsMk1ldGxGMkliVEVEWTFxdkRT?=
 =?utf-8?B?cFpacWJmRFdmQW1JaUlWZGNDbi85OUwrSmN1YUtTSHBsZFJ4dDNxM0RhMTUx?=
 =?utf-8?B?R09EdEtBVW1EOFBBN2VBcmQ0Ri9PUEV4TkNmV3MxZVJnL3FJU3YwVzNGcWps?=
 =?utf-8?B?NXFtaXEySnNxUUNYTFloTTJiL0pRNVVxVUJKTlJ6REZGZDVHSDlBSTd4ZXo2?=
 =?utf-8?B?a2ZBL0UwcDBOSUgrNkpuNlN6anlCNndTdmtXbzVUYi9NMTBjNUJPYmxEVDgy?=
 =?utf-8?B?Ym1Ib2x4d2V6Y1lQbHJmNTA1Ykx1UFYzL3NmU1JHRERGSU9KbS94THBVNjdq?=
 =?utf-8?B?Y2J6dFROa1RnMWpMcWRCSFFuaEtxNjhIbkZsNHI4dlV6ZGlIOWxUUllIMi92?=
 =?utf-8?B?cGdDOUlNMGR6SFI4VnZRYnU2ZVpSZHpYRUY5Mm5KamN3QXVlcUJLR253cUh3?=
 =?utf-8?B?emY1cEROL3pRV1loRVNleFJ3THVSUUZBRDEyU0gxRkp1N0JrVFFqSlYrNy80?=
 =?utf-8?B?N3dheVNFeVo2RGdRT0laakZ3Z005SVlqRzlsN3pzK2Jpcjd5ZzR1UE1NOWxj?=
 =?utf-8?B?cEdrUXVBSWpFN0NXVGx1UEJ3OTVrbHd6WjI0MG1Bc2FPRkNRMENiMnpWc0Yr?=
 =?utf-8?B?MjRXeTVmUXplQjkzRWN4RkhjQmV1akFFRFNGSGgzVlBKeTBTK0Q2M2lKbFhR?=
 =?utf-8?B?d0tlYmU0M0tGQlJkTnppSzFEUDhnNmJOeEllZ0NLbTdyNHVwQUhSWThRRmF2?=
 =?utf-8?B?cjlnSUpwU3RJYzh4RVEwcHhTVytmVU4wQ1Z0K2p2NmlacTlVZjdEMnFxSWhM?=
 =?utf-8?B?UjVNeEZ6S0tYc0JjLytVbituNVZFWkN6aVdjRUxCZzZoR25ydHBIV3Y2VVBO?=
 =?utf-8?B?Vkx4NXdrV1Y5bmNmZXZSb3ZJTnowdEdGdHZBYWFjYU44b0NsbnVQbFRQQWdY?=
 =?utf-8?B?MXlnN0pHZjhGc0h2UVhyYTVjcWN4aG4vMVpUU2xFVmcvMDROTVI2T3NhR2Zj?=
 =?utf-8?B?SHNJTDBzWkZFQ2pkNmlvOGRLaDN3ZElzN2l1cEZ1OTRKWHEveGFxK3dibEVp?=
 =?utf-8?B?dTFpcEpqS09sQ3hZMi9qdC95NmUyOGk2bnJmOUpvK1pGVmZyWTI0NzhBRXE1?=
 =?utf-8?B?YjhTalpFdllaTitIRHpvYWl6ZnIvQWNGaDJLZWtRZUdEQmJkTG40Y3BLV2RM?=
 =?utf-8?B?WjJGWkwydlJSV3QrTy95eFFhaU1kVjM3aFhEN3hCem5tY2lRU0JuM201S25u?=
 =?utf-8?B?bUtWb2p3TEwyMnh5Tjlmblhmb29GUlR6Um9qVi9JWXIrcnlRY0djeUV5NTR1?=
 =?utf-8?B?TXFvWDNveDBhdnBXSlZPcWZDTStYcWlkNnJFZEg3MjFTeFZvM3JJenZHSlFx?=
 =?utf-8?Q?OLiuw4Z7e4spVYcA=3D?=
X-Exchange-RoutingPolicyChecked: wJOIugWSPfRhCk8bsG+3p0Gk8qWnKkEMsMO6F2KZea7W7luKA5TvF8JGqSq+7eCYBo8QgaND3nqlpVpmKdEE4cDUuizBMjU9d4aV8+I+TqKJMIfOXglpVFZUJONVv0BpIdOxL3dS46GL4VhM/Ho8LoSycvWywAcu3NLApm1kkjyMPhMa32YifiJr542gzhUFeD4f+nMuqPKVR6ej7iWXJTer5dUoJ8z8LSf5HivNCG6kYdT0EAYX+Uyg6TW8yxOw+5vZfqDPo0Sr/LuvGJrUn0x3SAawKh6+hIvTOMVxkM8EIyET9rxGBCGZsSd7pExDl5GtXTqYIgKncCU9njMwVg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6524fb-2dfc-4282-46fd-08df0eef5df8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:55:34.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOYEQBriyq35STu0bRElS7C+QuiornUZspb7oeFq2Dc1c0vXdGEonq12ieYjEdMv+NeDfBDPvXJbv8SWnRb5tvkiqn9eUrTP+m89CsGZt2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8073
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:

> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 0c2aa20148a1..0bce199a5f7b 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c

...

> @@ -421,6 +423,20 @@ static __init int snc_get_config(void)
>  	return ret;
>  }
>  
> +static void __init intel_rdt_mbm_apply_quirk(u32 num_rmid)
> +{
> +	int cf_index;
> +
> +	cf_index = num_rmid / 8 - 1;

I suspect that cf_index was made an "int" because the original code 
initialized it from int boot_cpu_data.x86_cache_max_rmid. Now that
cf_index is initialized from an unsigned, compared to size_t, and
used as array index ... unsigned looks more appropriate?

> +	if (cf_index >= ARRAY_SIZE(mbm_cf_table)) {
> +		pr_info("No MBM correction factor available\n");
> +		return;
> +	}
> +
> +	mbm_cf_rmidthreshold = mbm_cf_table[cf_index].rmidthreshold;
> +	mbm_cf = mbm_cf_table[cf_index].cf;
> +}
> +
>  int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>  {
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> @@ -500,25 +516,14 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>  		hw_res->mbm_cntr_assign_enabled = true;
>  	}
>  
> +	if (intel_rdt_mbm_need_quirk)
> +		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);
> +
>  	r->mon_capable = true;
>  
>  	return 0;
>  }
>  
> -void __init intel_rdt_mbm_apply_quirk(void)
> -{
> -	int cf_index;
> -
> -	cf_index = (boot_cpu_data.x86_cache_max_rmid + 1) / 8 - 1;
> -	if (cf_index >= ARRAY_SIZE(mbm_cf_table)) {
> -		pr_info("No MBM correction factor available\n");
> -		return;
> -	}
> -
> -	mbm_cf_rmidthreshold = mbm_cf_table[cf_index].rmidthreshold;
> -	mbm_cf = mbm_cf_table[cf_index].cf;
> -}
> -
>  static void resctrl_abmc_set_one_amd(void *arg)
>  {
>  	bool *enable = arg;

Reinette
