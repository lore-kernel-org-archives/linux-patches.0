Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C444D2EC9
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283232; cv=fail; b=ZXtwB7iKyt+XfhtY89uTZun+2x/k/iRQ3SZF8ZuqJqJeIG0nvOO7Ih1GdB8ztq39RynI8sp8LdQ+UJn8g82GCoVbytlAoeLLAm4Di7JVrQi/b4XF0hmWsL7MyEEBBoCXnPn9Ouh3/Q2nhPuBpegITHB5uUBoBWdEN0K4ZyCJ9Dk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283232; c=relaxed/simple;
	bh=eFqsKB7/CbzvM747icx5xKNIrP/y6qLBbSZ972FYWr8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KpUBYlgtsO1clgRdg5fVV6qIQV5u+N98qJugq9UM2ZtJa8Olys3XSqPoIWaqT0YUqOkt62qiIaOAzon2eeULcid9GgGwsPakxMqVLouJqR7bnOTabamTK12MjL7gE4REjM44Tg2xEs0EKnfsX1JRIMB9vKwC9cyiHjq3MLKv4dY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BOzA1DH+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BOzA1DH+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790283231; x=1821819231;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eFqsKB7/CbzvM747icx5xKNIrP/y6qLBbSZ972FYWr8=;
  b=BOzA1DH+im69x4ALYE0nHv2fdq3SW/+YReqC3BwJhKbVq36HNioqauL6
   HxH+TWie2hmK/945cc0yrQSVs6e3dsM/mKfCOzkHbXrRqxmqLaTRVgei/
   fS20O52DHpZN7xTRiOg12YUF0VCzbtrGrhn3I83R4r8/Gs/H6gq86m1Bu
   Z68kDVKivvVf4NMkAHJaiBT95q2IYp1kA2z6HYt83er5a0askdLCfxsPA
   1Yw31TM9qIL3KgGyzYK192HQqjmqeOZ+sdJ9Ta1XjwHhNfBNl0R7uZ2/6
   gFsDYNTP3LGCxQ2B0/v7GrndIYTEph9yBK4BvNn9IRVKyiP3Xnb6cyqYy
   Q==;
X-CSE-ConnectionGUID: VhnP1fqmTd6CFyxrGpjhkg==
X-CSE-MsgGUID: utPTRuXDRjiklCZSf2pOEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="94886029"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="94886029"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:53:50 -0700
X-CSE-ConnectionGUID: tEAqtPWBS8KUx1MCuWC2OQ==
X-CSE-MsgGUID: wk40Ds0vQTSLUXBtVu6qJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273346506"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:53:50 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:53:49 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:53:49 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.38) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:53:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmEJUqi5juSC0oyhmF7XCpJcEJn5N3MJyAyZqS5XQAqBTmWJiXgD5N6l34krTXQMnOnbGprKYWBGvDybpHFkVhKt0qyPYfNnL8ZoujLkGkj0HZEoWRoxhHdOSEfoSbCrOfgK1CdmE4LKtDAOyKwJjHoxoqVZRK3QEnqVoo3r2XLLq2JfAA6wfPZvCqVeA1JS9AqI1Bbc4mudx/xOlAVGGqShhQO/OEnJYjtAg/JVhisNmwVj2w/qVId2p32MZuvg0GPhe2qRwztPMTtZh5XZy8fk9r3kY5CH9CVal4zeeC4ATSqF8me0oRn9kdp1TIhCH+fi8WvKGWyf7gdPTQv8nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdGnKjNwy28SPWkLatJc861Nj2MSa2dc1wxjrklCoAM=;
 b=fjLJs/YjrNYQPAVvOZbdPkW9zLfbWmI/Km4ccl4mRSR59aGH0PC+pMvHWNL/Q4JDNtipxZUINQrbC5TOYLorGBqwsXn2KFW0CcVzVUsiRwcnWSqBkRcOOnC5Gml6VhK6/Hn1pz//1hfBeLt9LzNo85AoKP6cSY0ZwR863Cg0wniZjHviF1aOMpvwDkHqrwMBPt65KO905uXiFYvwR15sdLxN+I9lEkIjy0jbkTs7yur+qn2F8bpZi0Gaz+L1oJ4ZLTHMtG+HMoR2TgRTP03+kfkWdwiDPXkhLHzrs0f93JizdD0cuJ59AGygU/teu1Y0cJkNfYJ3r8XhNbyfYJfOwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ0PR11MB6624.namprd11.prod.outlook.com (2603:10b6:a03:47a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:53:46 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:53:46 +0000
Message-ID: <318f0347-b33f-497b-bdcc-059af788ac0a@intel.com>
Date: Thu, 24 Sep 2026 13:53:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 19/25] arm,x86,fs/resctrl: Enumerate AET on every
 resctrl mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0121.namprd04.prod.outlook.com
 (2603:10b6:303:84::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ0PR11MB6624:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f620025-ab97-45b7-62d7-08df1a7ded1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|6133799003|18002099003|22082099003|3023799007|11063799006|921020|56012099006|5023799004|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info: dniDp5e62YhUBWh/d/obFtiqxGYPyJfbfOPvUIgf14VggmONlLGkxcF0Ik/IXy74cUjBb4oBHvI8GqICDu5nJWQ6bJFXfSkMCvK6//scPKwdSs3PC9L5Qxs/TZfllw1yRGMcdVTKTRvfVhS7O3qHvKwKzdwXfb6/ghmhq6ugwXtguE/LiG2kNM1BoNw3GSTeXcFJTpAWLJEO14QSyLszG9uK21RKWQRna06Pyg9R/yE9JyKO4x0fG9YI3QTjew9Gs7rspEbsNHxGpG3SCBjdJROvATYjJ2VgayTHdVEBr4WeqL4YGfmJMxNlFGRdTHNKsD1KVglnikn2sy40eYSzEQhRf0iMNjnvo6hZ+gC4kyYhSPR/qbX6HO0boiAUqPB1rR6GEDW1bb0dNc1DXtj65VFJki+6MMO8ksZEUksCbtjyYg3yiEXJKgm+VxAWiMsnGxpCaFZ2J2drK6LwRxpPEPLRnnfGZF6EgveN2bPJXQodvybWgdTp7yFtEqBZqkG5ecjISzGjNOfpfAQAI/D6M2cMZUXWwKtSTeUtsoyJenx8WC2n4AE7I+v0ORuyvbqPJOP0G0aO32jZqB8/a/cB04IS/Hb0rNdiFZh7QhFUsP0Wj8ZMsS+1GAYPaWnKDyqbpP62tTcloutvYn6kNNItxpO5pJsoPnBasGkpQfCKBrrp+vHC0xpYBmF3fHTWmPSssByxqhfhNyIUcv3Gee+jnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(6133799003)(18002099003)(22082099003)(3023799007)(11063799006)(921020)(56012099006)(5023799004)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3ZOdHhieG5CRnFNWTBXc2x6NW90NzRXUXpQZmJQMy9lRUt0U1Z5a2I0N3Rn?=
 =?utf-8?B?aGQwS1hXbUUxZmVWa3RHMFdtNmlvMXUybXNYTGhLQzNraE9TVUQvSUZZZnBs?=
 =?utf-8?B?c0JwS2FwMjdSUXd5RkVNTTFab1dETXBBcXlwMFdjNDc2YlE4OUJ6MlJwZC9G?=
 =?utf-8?B?NTFWemwyeENTanBYZ1dEKzh4N2QvM3R6VGtGYVpGMU96ajNxblFFS01JZzVz?=
 =?utf-8?B?U3hHVitjbnRWaW9aK2FTem5VS0s5bHlQbHhWT3pmTW8wcUR3OUdlem81dmRD?=
 =?utf-8?B?dTViK2xqaG9OVklPNE1QQXN6NkpwVEI5WEFodlQ0d2MwbDh2NGE3RllzSTl0?=
 =?utf-8?B?RzlLTHBZdFFYQTU0S1U5TVBkaTBDc0dVMlEwcFhKMEd5TWJpT0ZXZzJPanBW?=
 =?utf-8?B?WmdiYmUwSEg4R3pWcjh5MG10dXdRRGhGQ29mRjN4UUw5SDFLTEphNWh6ekdW?=
 =?utf-8?B?NXRmbzFLdC9IbjF4OWJoL0JmSkpjaC9CNHVlYU1XbFV1ZnRzWE1ua0ZvUTJj?=
 =?utf-8?B?b0VxQlMrcmFYL0hkQjAza25FTldHRHJMejBQT0JyenZCMXQ5d281TGFzbnFK?=
 =?utf-8?B?cVRjcU1SL3ZDVWRjTUZMVEhyMnRHcVg2UU9udXZoeXozcjRhd2tuWTZOS0lh?=
 =?utf-8?B?bVdDYmp4Mmpoc3I1bjhWYU9HdHBsUlV0bitEVWIrQlZJNGJMbURvYnZLYWdq?=
 =?utf-8?B?Q2pCL0F2dFRCU1ArbnI4OWZpQ1FxcXRxTUFkWU9GdkY4R3pXRlppb28rcGNQ?=
 =?utf-8?B?WnJPSU5SbTREZ1h1bVVSSFUvd0llV0xYVFBPTkd0VDliVFJGRGJiNlZ0Nmk1?=
 =?utf-8?B?MFZ6MmtFMUpqdFplcThqVklXWXFLVEE5WTlyajhmNnFkQStOOTQ4bHFldmZI?=
 =?utf-8?B?T1Y2SVNCMXpoSUtiTG0wSzZnQnZDb3lndSt1enkwK2d6b3FOV3pHTjF5bmc5?=
 =?utf-8?B?WHZCMTJEMEVDWnFSSzl2TnJGK0tBVlFMNWlBVnVlWmZNNGM3S3l1MHV6eFJS?=
 =?utf-8?B?aXdKZGQyM09vTDgzUzk5Si94WGRURHlmV043d2F2LzZrbmQyWWVKbGk5bndn?=
 =?utf-8?B?YlM2SjNacERSS0JmcHdyeHlNcG1sUzBKQ2hJdVBKTTVpTzN5cTF2OXNxM2VY?=
 =?utf-8?B?Vy8zRlRIRnloaW5lajEyRDdWMDlmQk16bEJ1N0lLVlpjY1NUYTIzU1M0Q1lk?=
 =?utf-8?B?bENIaFNZT3p1YnFGY0ZUc3c0M3I2Y1ozZmlublVWVlRhMkk3YUc1QTE4eWpD?=
 =?utf-8?B?SGdnVVBVNlkwbytsS284VG1vUGhhWWcxYXkzaENlS1ArYmhyOUcxYTN3Sm9l?=
 =?utf-8?B?RGM1bzR5bTdsc3hPWEVzSk5tMi9jWmNML0YrUmVjbXp2SEFIV3FqU0dLVFNI?=
 =?utf-8?B?eVlTNmNWcHIzeHdyRVdiVHdocml3TXpqMVpRZk55eVR3QXU5ZXFob2MwbHIx?=
 =?utf-8?B?WDVSdHpJNDkxNTdGS1Q3dzE5WGMwNDFnL0lGdnZkdjVMd2hNTFR6SWp0TmlY?=
 =?utf-8?B?bG9PWncrUHNWVUp6bGwrVUd4clZDYkN4aG83MGV6WEt5Lyt2akRxT0ZHZ2dT?=
 =?utf-8?B?andWeisxZjNiN2h5MUVQZmNCVzk5K3pCVjVSRkFHQ0J3Snorci9xMnN5cmNy?=
 =?utf-8?B?d1hFcEcybXAyaDZ5WGRlU0dMVFdkOVdwRDVyUCtGaXFlWVlSemVzSWRGMUtn?=
 =?utf-8?B?Mjk2SUVrb2xBVkdwTlZVRFBTc0RTZkRqbDVLdTF2MmFTOFZ6N3NENE9tVnNW?=
 =?utf-8?B?d1ZNWDlZdTZCUENzSldTTStTMCtBNlh3YWczMlNTNFEzWFMveUp3em9aSmdP?=
 =?utf-8?B?WGZ0dGN3c2hscithUTVYV0ljbi83MVZDZ01tZmQxMVdFdFZ1V29XTVF3VVJI?=
 =?utf-8?B?eWZzR2N5MnJxZ3kvL0tUb2dyY2F6M0RFbUxGODJ2OFNrUVNhTnNJaUhwbUto?=
 =?utf-8?B?dU1VelhCVU9UWDE5ODVDSHJQT3p4aFBIS2h6cHIwSUppMmlzcWwzMUJIbmR4?=
 =?utf-8?B?bWZobWNBekhMK21yU2xYR01VWU5RS3d1WWpWeHpLVThVajI4SFFTeUMxeHo2?=
 =?utf-8?B?bHZGdC9wSFpVQXhlUU9Ud1NXNXg2bFdaeU9OQkpldHczMDBkeThPQWh3MUJH?=
 =?utf-8?B?MS9yOVVGWXpRZFpLT1c4UU9KVmRncnpUNVQ0bGVOejhLNEorYTlyTmZuSnVI?=
 =?utf-8?B?SHBHQVhYengyOHRWa1VZd0NpOGNjUmJYeHR1VS9JOHhUUzZRMkRDZjZBK3ov?=
 =?utf-8?B?SEJFblg0a0JKeWVORzM3ME5Kc2VPallvcnBTK0pFcUN4T1BxR2o3cGJ0TVgy?=
 =?utf-8?B?V0s1VTV0LzBPTmM0WiswOWtldTdhWlI5VTlZUjFTU0ZmYThVQ3ZkUEV0ZjRr?=
 =?utf-8?Q?HDY9v5tcGHNCxbyI=3D?=
X-Exchange-RoutingPolicyChecked: XWs/yFccg1vnVNlemLX08ORCoNQF2UzjdS2r/gqFQ1o9Cq0COZH1RHe7EJWEHyNWNNH8NzigUdrqT+xW0b42xphjIzeEBZwUI+DNAegZDIPTZa/Fk7vGC9Hpltt9cKowQ4NVxOLE3K8cFSJSPZhKWeim70SuJkp17yhsDZyn1iO1Sc4neeu7KWnJNo3MHmeC/0MpXscGNbhi2ucm4q6cHFoizIQMRoE1VypzHnxoVV8bEk2s82JTcisWKRSm9630oAEF1IqMj+eg46SN0z6JGB9l5hm6KVZ8khv8akKeu8JdHKTvHXWx/CUNMnkFzoVpWW6II3wEVxigqnB/Ay0Ysg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f620025-ab97-45b7-62d7-08df1a7ded1a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:53:46.2310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgaYLG67TAREOetcAtXEGSjx6pgyuWRSsGC5dLrqBxnCWCAtO0N2bXyRDBibrnnVmywghEJ8tg8Ky9RInsnkTylRcTdnmu8PnvXMz/eETWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6624
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> Call resctrl_arch_pre_mount() for every mount protected by
> resctrl_mount_lock. Add matching resctrl_arch_unmount() path for
> architecture code to clean up on mount failure or unmount.
> 
> Remove intel_aet_exit() after moving all the cleanup code into
> intel_aet_unmount().

Please do not just summarize the code changes.

Please rewrite this changelog with tip required context/problem/solution,
focus on why changes are needed without verbatim code descriptions.

It does seem a stretch to claim this is a "code move" patch when
the new unmount code does much more ... without any mention or
explanation why :( 

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 604ab7af7c2b..5a975856f670 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -590,11 +590,17 @@ void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
>  /*
> - * Architecture hook called at beginning of first file system mount attempt.
> - * No locks are held.
> + * Architecture hook called at beginning of each file system mount attempt.
> + * Called while holding resctrl_mount_lock.

resctrl_mount_lock is not exposed to architectures so cannot be documented
as being part of the API. Could this be something like:
"Serialized against other mount and unmount attempts."?

>   */
>  void resctrl_arch_pre_mount(void);
>  
> +/*
> + * Architecture hook called when mount fails, or on unmount.
> + * Called while holding resctrl_mount_lock.

Same comment as above.

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 32f3f30894a4..8aa2e18a6bbb 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
..
> -void __exit intel_aet_exit(void)
> +void intel_aet_unmount(void)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	struct event_group **peg;
>  
> +	guard(mutex)(&aet_register_lock);
> +	if (!pmt_in_use)
> +		return;
> +
>  	for_each_event_group(peg) {
> -		if ((*peg)->pfg) {
> -			intel_pmt_put_feature_group((*peg)->pfg);

Previous patch added protection against pmt_telemetry module removal so still
seeing direct calls is unexpected. Could the changes to intel_aet_exit() that
match the intent of previous patch be moved to it so it can stop being asymmetric?
I understand that intel_aet_exit() is not run at this point. This is where
a comment about try_module_get() behavior on a built-in module will be helpful
and why it has been asked for in three versions now.

...

> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 2e9f71901f68..07fefa3c434e 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c

> @@ -3297,6 +3311,7 @@ static int rdt_get_tree(struct fs_context *fc)
>  	if (!ctx->kfc.new_sb_created)
>  		resctrl_unmount();
>  	kernfs_put(rdt_root_kn);
> +
>  	return ret;
>  
>  out_mondata:
Stray hunk.

Reinette
