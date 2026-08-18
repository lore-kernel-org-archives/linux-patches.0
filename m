Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61B2E888A
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787091140; cv=fail; b=JPjVPMcxNfoxp3SUMx70K87IKiKemFHCJyI+7Th1hhU8s2VpsNgzDxt4g4NNmYNzp1N4dMwqGp6kqY01+DQ3qzJ9TorelLNYpTTyKaboLlgQXScdlxLr8npTsNjYEz2r8uqEQkajZ3ejBO4++opGVgkYFIPMlOkwGJCfzVj6f+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787091140; c=relaxed/simple;
	bh=ehuzgUmz1cX/Jc0cPWNheNJcyqG37wYO59DGTRqL6x8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WUcWAuT01tnTL06CzJ8H8NqenEosqMQXnk7RaE+GlXuQSiV8XXCf3FeCDwA6u8P3TF1F1UAbRiurAa6r9m7dw+MngtS/Y1UApWBtzCDUgu/XEhChVkPLlkfVezyR3lfNfZAaREZssjnvDGcM5bksWl/OTAUDinkgn4GvOQ7FMjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDznC/98; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDznC/98"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787091138; x=1818627138;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ehuzgUmz1cX/Jc0cPWNheNJcyqG37wYO59DGTRqL6x8=;
  b=gDznC/98S/5NFn+sPaaNjyDWe5FVr8qRvBQlGAcsupFJPeb/8DYZxA8I
   NlMfg1Fs9BpFe2fA0OAdKgyDqLZkdEnPOycqriWxIX/8aIg/8byAQXR9f
   olVigo5dmGzLaJipagUkzORXv5JAwLqzc4CPzwC1SMNhVKiEz+Y/I22YH
   feMVWbljDqMRO/3p55eYPN0+vSrauuuum7xzXGJL+YZyetXttyKEAD3nv
   iHgE/Jiy5sK8KxKKedTdoWhwEUtWXxwtzDsADY3HxlEG1CSwzSBc8eWDO
   AO/AoEb7TyFlQQoPw8mqj2T3yZjDlaVqdgy6Qkbt2LmZr02XdakGYhqVd
   w==;
X-CSE-ConnectionGUID: uxjpNOL3SHCdk7xqyhwWDw==
X-CSE-MsgGUID: rqssqQUTSUqUi4fGJcKKfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11879"; a="87610917"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87610917"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 15:12:13 -0700
X-CSE-ConnectionGUID: 7ZUCPrsgQaqLjktpBGOBCA==
X-CSE-MsgGUID: LdbBH8OnTkCnNSXksgIjtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="264917405"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 15:12:11 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 15:12:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 15:12:10 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.49) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 15:12:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5qc+7ljVp55mPgUpW9QRyveB267AMMxaLCSHF/J+5Kp6RCecijrGMLvGjJiNSWclCwG3LXFoLvTG26BFJEa8z1tCXP3/CKkMAO8bzr82pvkld0lZdVaF6ZADn+L8cnKqu+and7bcJ1TroSGgu6ZQwPC0kZi37JsIm2O7piC3ma/ZRiq+bFAdmyLeEmIALC+Cakad+OPgh3sCZ3HFO6VQLFh81iMrBpQZ+0SfBHeSttVqiKYRzl2cRkZhuDfhrlr1O/lMuNd4IruE2lPUj6fuEvWIdWEHhN4FLJLK4jq8dC6jBqhiDabxFa7tdS4zWs0tYqqhH0Uuqi1oIELuKWSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oup0bkTRnlrIykOCen1OkpmZ5k/3OsyKPT7wfhPQYy0=;
 b=d3NvcRyZaWfE+Be6YPWL34FmMoq4kI5xjJ7rKWQOhms9vWvGqBivecezeSMkLTKthILIceU1/uxwHeiCREYF7G+yfnCzYVtCFP/XEJ+BCtxss1YTcuQwcDLgU7/42YtkHRZdMeoRgNBZD1yk+Wq1+AhEEETi4wrDDHxluxgWDNAc8Dtkt5dfM1Yn+wtazx2x/80h6zKw3hL5RG1is1o5WpQwVfE3WFG4EyoR/0M18VNlPNk0dC+uHM4M1RF2723n8Lgied5G6OZ8J1IRVeEq1uxLxXuJmdm66LEoel4vkcNrscM9HsMJkG9gECjJW9tFm9vWVHSqWFwhIYoqPS03Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by IA4PR11MB9324.namprd11.prod.outlook.com (2603:10b6:208:569::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 22:12:07 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 22:12:06 +0000
Message-ID: <2a18878a-a156-415a-aaf0-74597d3f3463@intel.com>
Date: Tue, 18 Aug 2026 15:12:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/17] fs/resctrl: Call architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-14-tony.luck@intel.com>
 <03257927-1015-4e0b-9d56-3e5d682d98aa@intel.com>
 <aoSiUF_29hCuN_Rx@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aoSiUF_29hCuN_Rx@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0369.namprd04.prod.outlook.com
 (2603:10b6:303:81::14) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|IA4PR11MB9324:EE_
X-MS-Office365-Filtering-Correlation-Id: 85bac4d0-c14c-4529-a5ed-08defd75bd80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|56012099006|10067099003|6133799003|22082099003|18002099003|5023799004|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: 8/RfThIBRoqk2Ji1NVt97APE6ZNnUk8GGnfrz2W7BY/ClNFdox0mVVbC7yprv6Z/rFi6o0RRgr4Y3OasL0xiND9pZMF5KYkZ+rDZRiHdmSDT7k9Jbxn+5FkY5r0SiCN9aKo5jVFiSCFmid6RBgQqXJuVzFeb5qmW+sZb/wHw4uvTcGpVUIXYssmU9dhi62sfZVBof7k6lNiOda+mVKZIV+sJ5hMBc5E2Ex9ABfsY0ix5C7p9xKn/II5ISKmuCuFItQiwgRzqmiZTwkPeh8/ZlXqnjWdp51fyrfxXiUdRotAZiSr3rwAIMczs7vNMlnHsOhV+STvxyTmbeOb0uZFxtlnkNTRx9Z6LmAKSlOoTcZ6f52JBM1i1XdZzchymErlGG1PtdbvWORiUGPMPcR7n3WQCDVXsPPLgWon3LQkcjp+bCJc18KA+98D8LjFJvHtlwThw5qrJNUdll+V7ZXbKxm7tsl6S34eRORnZeyjUb5APuImjmJFGJGk4zwhKMOiJkd2gbKc5JbWDyT8ktuhlnxxuAQLJMq/HukQz1R229pogfbM+vvvWdI1ofOPeufhqeJ3/uNB+lrJ0t3OkOcOnMCDhSEYWuK2fLQpDdNCNS3m+/USm2XGLeET79c3lWnilGLS1KTddub7Z9NuzAB8/fxvM5ODQ5KQdOOeetNSm6dM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(5023799004)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm9mMVFpZGozemRleXNXTEZCcTRDeFdNa0hteDQ5Q0gzaFJPbkZ2aElZK3VI?=
 =?utf-8?B?T1FxY25iZHNHc243R3htRzY2TUd6MXk0RXp5Wk9FUk5UTGRxNnlJeDVNdy9q?=
 =?utf-8?B?cVJHZlRlQ0k1MlM2LzBCRkhkZjAzcEZrSTNrb3MwaVZuUkVLY1J5REg3QTBx?=
 =?utf-8?B?S0Rib1kwUm0rSy8vUE9ablJyUzBNcEVtdEQxUG9FNnB5STdjbjRZaHp2Mi83?=
 =?utf-8?B?dXk0OUNHRzhIMmNYS0JrMENCR2Qvd1psaEhGdGZpdWQrQ3RUNTl3Vmxkems0?=
 =?utf-8?B?ck5yd081ejhSNW55U2k0dm9TKzYxaXFrQUdlV0FDNjAzQXhITWVGMHdrZmQ0?=
 =?utf-8?B?YnQyWG5scTZkY2VLb1dNaUdiOGpDQmhYdzNsR0crWm5aK0FMWHFUYjdrTTkx?=
 =?utf-8?B?R2o4T2FaOWk3Um5wU0NXbzVIanR6OXk4S0RIcm9SK2s4RlI1TDdGY3B0bmR6?=
 =?utf-8?B?VGpHM1MwNml4a2hyT29HdFVmd0lTUE1FTjZMNzZtODJ5RFg0NkRSL0pBSElU?=
 =?utf-8?B?eENDdWdveHVIZ08vUjcrSVg3eFhPOGlmeHF0UkhDYUcrdkRxZkVMUFRyeS9D?=
 =?utf-8?B?V1l3NXlSWmRkd1M2YTUzeWN0QUlURitDMmlEdHF6azlyNzZZWC9NZUEzV1pZ?=
 =?utf-8?B?bU45Y2FSN3lEYjJPL1ZsQlU4V09rNVFyNjdnVWoyb1c2NnRqaGJQYnFycWJi?=
 =?utf-8?B?bU4zU2FyLzZwbEVpV3dPNWE2dzRvdEIyVnVHNmIxdjNiaXZxMktRcDFtSkVX?=
 =?utf-8?B?WThhcllDNUs1Qm0wNkVLblZNMmNPeUpmMEpGaEZ1UDJuN1RraU5RZ0xmRlhO?=
 =?utf-8?B?SGxaZHpKSWVjRFJIWUlhVDJjMVpFSzVycVNiaXgwdnNuR2FKZldxUWNoRkk3?=
 =?utf-8?B?TVpDSzB3V3JKb1QrdlFsQmYvem1xMVhLMUNadkZ5aTNLdC9EVU93WWwrR1NM?=
 =?utf-8?B?eS8wNGUzVDViV2FYTlN1cWdNSFdTdkpjUmRSMGt0S25BRC9xTno5ZVBTbWFw?=
 =?utf-8?B?Z0xlMUZIQjhQejd1TDcwR294TTJMaXBJbmNMNFBYZE1sQVFDVHB1Y3pxTlhw?=
 =?utf-8?B?eTBJNTF5UVFpbnN4SWNhUWEwQTg2YVNBT1lpWm9zbmprMTl6TkZpVmxOUDU4?=
 =?utf-8?B?NzZRMVZZS1BtWXlWOFlNYUZYdUYrM0MvTVpSeWE1MjEzNWNWRmFmK2NDd2w4?=
 =?utf-8?B?Q2dpYU9halJpelBIeFdwZVBQdDhObVJsUWRFb1h6Zm8rQmx1RDZHd0t2ZXlQ?=
 =?utf-8?B?MVVCaUdnUFJXQWNTRTNucTBlbC80TVNuM1lRVFl3NFhLMzRrdVZpckNiYWtR?=
 =?utf-8?B?bU53bGQ0Y1lHMmJ6YnRvS0VkZE04Q21lZXRBQk4xdVkwR29WVzNEbHdFNTJt?=
 =?utf-8?B?V2NaTmRwbkVYTXd1RXNEMkJxUVFlOUtYdWRJUmlKQnhKY3R6aEdvajhxQ2ZH?=
 =?utf-8?B?ZHptRDhFY0kzemlCeEtyemtNS0xYYS9vRXJVdmRkNW54a2pjMXFCN0N3TzA0?=
 =?utf-8?B?d0hab1JQK3p4cDdzMXQ3Z0VIbkdvU2dxVFlFLzBZSlJTY0hxQmt0Tk84U3p6?=
 =?utf-8?B?L0p5WjBhaGhnMFdraWxCYlczak5rUTkrWDY1S2htRE9vQUpFRnAzc042ckNF?=
 =?utf-8?B?WjZIamFYRUxGNGw4NmhxcWhMbG51OTAvYVQraGtLZEsrS1IxdGQxU0xMNkln?=
 =?utf-8?B?aFpXZGJkVUM4ckxCeW44OWN6SHBKYi9RdmJTY3o3R0YzNFV5T2plQWpJUCs5?=
 =?utf-8?B?dml5N2M4NGlTb1JidW5oMEV5NnBTYm5OZzdJbEdXNjBRc1RFdmM4QjluS3Ri?=
 =?utf-8?B?d3BOc3R0Q3pudFhiYUR6anZjUUVhb0UxWmZJanhKemN5VEs3b0pRMnlyR1du?=
 =?utf-8?B?OUVkMTByRGhCYy9ROVRzdlc3Zm8yUXFaeElTQTY3MEx0VlhkbzFYclRnQlZU?=
 =?utf-8?B?Z1hEWkZBYXZGdEZqRGpRaVdEdWxReXg1bWMyV0gzdDdDV3lFd253UnFTT25P?=
 =?utf-8?B?SFFrbWZpUVJvWndlVVp0VGp0dFU3d2J2QzlOUkI2c3Bodmk0MXJtT3NQQk9U?=
 =?utf-8?B?M3ZxM1B3ZFRhNHdUaklibjZSUTdRQUlKa2QxZ2pHaTcvYVIyQk5JdUVpSjJW?=
 =?utf-8?B?KzRXb3R2V3VTY0JzSVR2YURPMkgvMlFrRnBqUHpXSy9rdXlldnpXS0NQVnZN?=
 =?utf-8?B?dk5jelNWMDhTQ2phZ09Wd2dyOWFpWFl4NWZBYTNhV3o1UWxDN1Z1QUxjOTly?=
 =?utf-8?B?bk9qTTVUV2k5cHhzcjIrQ0FROHl2MnJseXpmNU01Z1dhaHEzekV5NlFqL0FT?=
 =?utf-8?B?bFR5aEJXK0VWYXRNOGE5WnpvVFAwOGZCRCtjSHhzV1k5SDhUL1IvWHZSNUlt?=
 =?utf-8?Q?WoWghRaizRIX2DqE=3D?=
X-Exchange-RoutingPolicyChecked: j3Yp9KVBRnIi1bhHg9KpPvM2JtqF+9SZYpmSYX0Ix5ECCDu/v5znvZFiV07RWgWnDGXZVeyKvgM4B8NqEC6FwpQ1BtS3AiaezkqiptgbTAN0zeVVxNNqguctNPNjW0G72U3tnjJqzyJ/R4URZ57xzBT0JQHwSJV4r3o7JNTuc7wR19qJhnUzMz6AFQzsrxK1pxMCB7AUzOfzzVC7GA6X3eaDU1ak7liACy4RAn0CyQPJf8Q1J8PoFb7GJCG3Lq9ro4pomyje8Ax/hob1G3KRTs8a01tCpE51vcYmPidGy+DGp4aGqpD2SqIP8BSO8cnohe8v7vEd93XvRwvqt8y7Qw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 85bac4d0-c14c-4529-a5ed-08defd75bd80
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 22:12:06.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WubAY/Daht3x2zXUEi8XAYlGW9J6YqKIwJ8OnHTS3E2xmaDHF2X52FWlhtck4LuY80pV5A6FSPXu7EscCRGZnNVi4yu3aLqaTgepE6PZuig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9324
X-OriginatorOrg: intel.com

Hi Tony,

On 8/18/26 11:20 AM, Luck, Tony wrote:
> On Mon, Aug 17, 2026 at 06:02:31PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/29/26 10:27 AM, Tony Luck wrote:
>>>  static int rdt_get_tree(struct fs_context *fc)
>>> @@ -3175,9 +3176,11 @@ static int rdt_get_tree(struct fs_context *fc)
>>>  	struct kernfs_node *rdt_root_kn;
>>>  	struct rdt_l3_mon_domain *dom;
>>>  	struct rdt_resource *r;
>>> +	bool cleanup = true;
>>>  	int ret;
>>>  
>>> -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
>>> +	if (resctrl_arch_pre_mount() == -EBUSY)
>>> +		return -EBUSY;
>>>  
>> This does not look right. Are you intending to add new meanings to EBUSY returned
>> by resctrl so that user space now need to choose between "resctrl fs is already mounted"
>> and "the underlying architecture is busy with something else"? Based on the implementation
>> the architecture could now also return EBUSY when resctrl fs is mounted, but what prevents
>> an architecture from returning EBUSY in some other scenario? This error code to user space
>> does not seem like a responsibility that the architecture code needs to have.
> 
> I've been struggling with how to handle races between multiple mount/unmount
> operations when the resctrl_arch_pre_mount() and resctrl_arch_unmount()
> calls are not protected by any locks.
> 
> As you have seen, I have some (poorly documented) locking at the architecture
> level that attempts to solve this by keeping its own idea of the mount status
> of resctrl.
> 
> A call to resctrl_arch_pre_mount() when the filesystem is not mounted
> will do AET enumeration, and if that succeeds create the domains. A nested
> call does not need to do anything. But when I had that simply return, that
> opened a race against an unmount request.
> 
> If the unmount wins the race to acquire rdtgroup_mutex, then the file
> system is unmounted. At the end of the unmount the mutex is released and
> resctrl_arch_unmount() called. This will execute in parallel with that mount
> request, so various bad things may happen as the mount proceeds while AET
> is being torn down.
> 
> My solution is to have architecture return status to let filessytem code
> know that it did nothing because the file system was already mounted. I
> think that filesystem code should just return at that point.
> 
> Is there a better way to code this? Or is the problem that I didn't describe
> the race, and thus the need for architecture code to tell file system code
> not to proceed with the mount?
It is always helpful if the changelog describes why things are done in a particular
way.

When considering the race you describe I do think the locking you introduced in [1] is
a better solution. Specifically, a new mutex that (together with rdtgroup_mutex) protects
resctrl_mounted which is held during resctrl_arch_unmount() and resctrl_arch_pre_mount().
This should eliminate the duplicate "is resctrl fs mounted" state in resctrl filesystem and
x86 resctrl while also eliminating the race you describe.

I tried to read the discussion around [1] again but it went on some tangents and then stopped
after moving to the new solution without new fs locks [2]. My original concerns seem to be
new asymmetrical resctrl fs locking to appease architecture code. I believe that you clearly
demonstrated that this cannot be accomplished cleanly by architecture alone.

Reinette

[1] https://lore.kernel.org/lkml/20260330214322.96686-5-tony.luck@intel.com/
[2] https://lore.kernel.org/lkml/aeqdOlO3BkKQqSQ9@agluck-desk3/
