Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537E94D4868
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283316; cv=fail; b=tlPvDOyj8/mX7KWSBxc/8bAmQN8jXkhIKzkDqfPD3+0S1iwZP+ZH4VTLIs2LjLfP++ECVqmFxYCDB651Dd3dij8/9DTZNS99NmmW7TGPibYPod62DRwoD2frG/V7O9ckTuNWm0CKJVDErArlm7LVCYWMt3w6/XRkPooTpas2V6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283316; c=relaxed/simple;
	bh=7FTU6jUc3dJCtmyfn8T/PMvh+m/lRXfh2i9CgBThPJc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aPc2OR42FWj3vYGGzdmfvf4TbANVmOwqOJYNhaKh1aUc5H8imY0XiPkQsTM5FZUXkQq1xp28JIu3p++utGRqVyxvw5pgRFDtaKNkmpSY0X4uZ3vXlMZQRzhYYifxEZBBZmH9LJAFQQ9t12xOMOX96fdic46zW1JU8Dq3hMbJZZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gid29x/r; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gid29x/r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790283314; x=1821819314;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7FTU6jUc3dJCtmyfn8T/PMvh+m/lRXfh2i9CgBThPJc=;
  b=Gid29x/rYqEAJvzQDSltZLB3lv6TBO74LRmAgCgfYmpDxlKG2HeCUSKP
   aVf5AMt9pYWKb7HSO5IKyOjpZ0feVE74GJQJdyOEsT6el7Av7qfRP1GcZ
   247i2MToOsZtMOcTt7iBksx60F5iTCJnITh38EJAwWnKrlYTxnceCNwCs
   JkmaLrLscxQTXqxJDEZeQ6L1yDRUvxU3WsjzwIMY/mRmKDu+RvfV2I8Ca
   oYzTydbW5YvGfFrCUXGDub6X/Uoop9k6mMvZHTWJ1d3LGJb1XRP2S1uzM
   VktBCxG8lvkbiN+08DNLr5EFVUjwjU5Z+wXmon2C2/Hj4ZkdHb883ttZ/
   g==;
X-CSE-ConnectionGUID: ghvsQTTpTX6g0fMv1YbQlg==
X-CSE-MsgGUID: D7BrInk0SlKZykh+nSopyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="108560542"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="108560542"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:55:13 -0700
X-CSE-ConnectionGUID: /pyTF++NQrO3Ns2b4hrAqw==
X-CSE-MsgGUID: prOgJD61ScatxtxNxRPgZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="272259818"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:55:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:55:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:55:13 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.29) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:55:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MK+KhSowC2etYQiYC+hzb765FMV/ADcBUs9/vHTCsNcGOJcJnXYSSCuH8NfY3GqfNUJWtuvfoUxt0oTeP/d9BNaANAEyWbIEX1pRJan7dc9DrEwf9Ckgslk6k6soxAoaQItchnkBQu0nNxZpIzH1454VBS1FICgY70FD/YSZXY9sGc2+FFMYTKIc2hB+QkytCpWobnx0Nxb+Jp/yjUNu2v0O8gZ7Y7BfGI510egFaB9OmFsQ0e0B8D8ttVVdphi1iv9/eTStkkUpni3KGFT5GdQp8YywPwD9bymFF4giAzhVto4O9wSAlYY7lAgJ1rAGieD7Nub6U8XDhmCsFW/u8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1WELXSHW8OTXuSeKnN8TJyw7yBQZF29BlVkona+N+k=;
 b=IfplchL7RvSufmlYWLayOTDXZ3+UpWckJZAO/dW6hwow/zD1MFAOlHeaZzgf+LVeG+ko/3fptdFAQcHx+r+R3F5JpBdOKfUT9i4fPX6qZvDUWdtj8v103Mfxt9/qoYlwcprK9Ivad4iIv+q5MwC9KCkWIZGI4JE5Bgw2fWQFUc+hPfQrDoUKC59n49pM8VYHQD2N2Kgp5qdkgwnLS1Z0Nu8CDXfsQQ4FyMmCARaCIdIkiQCU1ml8Fk+ARws1QBGY62l3LvCK+h4RARxXEyWxq27nhnjb6MneGYe0LrmKkcuRTObZBsoEHQ5CEv5K6c1pXWUjKTrxHBxC8+OTSSXuYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSVPR11MB9916.namprd11.prod.outlook.com (2603:10b6:8:45b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:55:11 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:55:11 +0000
Message-ID: <baf34b6b-0698-41d1-b4d8-a4500b2b6a94@intel.com>
Date: Thu, 24 Sep 2026 13:55:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/25] x86/resctrl: Enforce system RMID limit on AET
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:303:6a::22) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSVPR11MB9916:EE_
X-MS-Office365-Filtering-Correlation-Id: ff87f16e-1c48-4307-90c7-08df1a7e1f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|4143699003|11063799006|10067099003|56012099006|5023799004|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: QwG3vAX+NOZXjhxGHCwRJpV7Dk3OPym4dte0uitxNdMK/09Zn4/JQZd/p7GO84Qvv+R0MR8HOeu0Nz9NyMwiHI83OJVY2jE867o9DhxLsdJSUrcPjgie1jq0A/57xzsbzG8u505gIGtlLa5NGvPBMgCD1Qo3bTarbfEQmZpU8zmVbPbjVmQoYJFPpKY028DqrbGWt9dai6WaSpS9BInNBd/XP+0XiUtdBADg4hCYaT6oXwheqWCmvNtz3tpHxWs/0qexlEiaCNkgSrp2zn6jK1NG7WLyyqF1VtZxPkqJMcdYIuZjvLEH3JXux1M4NX/5ar9ZO8WKdwjyg9VW9nGk742DZPfpqQba3xkW+KuoIEbQqO/lyZ9t6yTxRAjJnyE+yvd//keozHbCH9fdqpCfio/PshERXEO55SJilUCPpy4pm/oqU8QBjUcVOerKkBnfo59NzWSGWrm1xfbkQ2czHRPViKKSf1+xqA9hqu8NX/Is1v3BkzT9StpBRSXwZT4GcZASp8+6oMgJtSc6sDRgqjAYxgSQBDDsWVyDWjLP/4v56F1ZH57fIGCqVuKhANmvVDGALh2+Ys7fh5xk5dQRTliOmDHqtT78ElpQwuOl1ZmAV6CJTDyM7xELyOZEZNRxJnuid4crd/Fq0VyeknFXevxdjgEFga6JEwXUNPXKU6LIEK8rYvj4izAmjvYxc0YkpMJBIiGUbnvwtLjecsBKoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(4143699003)(11063799006)(10067099003)(56012099006)(5023799004)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2xEVHBEM1FibmpXdm5NRFFDakZKTWJnMXZUc2ZoRU5aMSsxL05TanZzMnpk?=
 =?utf-8?B?SjREbnI2K2ovZkt0T3VVVFZGV3NGeVhPTndvd2dOTklVUHVGbndQSG4xVm9x?=
 =?utf-8?B?b3ErK2cxUHZCUWQ2QVFmQXMxdkJxSUdnVTBsOHdZWDlTa2FmRGE2NlVJWTFz?=
 =?utf-8?B?VWZhaktPS05uK1RtUDdKK1JTbDR2Y0JTanFNaTRMYmtLOXdNU0g3bTl1cHN6?=
 =?utf-8?B?YWphdHBrSWtQeUFtNFJPM0doNGVnSkh5QXNTMEFOeElER2l6QlJIbnNuZVIr?=
 =?utf-8?B?VkIwTGgrRnZyMXFqbUludjlPdC9EVTRmYlRTSzlFUmE4MGxoUWJFTnUvN1JZ?=
 =?utf-8?B?QXZ0d0t5NmNmcGxNS2diTGFnV0FKbFhreTB5N2UwbjlpYXhTczdWeStMY3U3?=
 =?utf-8?B?RDhtakdaLzZyYWZEci8yWlBHWnZsR1VFRmtEOThLVjhVOGJERG9DK0pUa28v?=
 =?utf-8?B?dSsyaGloaExVdXFzbVF0a1NZV3NQTS95WUxMMlJRYmRiaEVIMXE3R2ErZWJH?=
 =?utf-8?B?OFpDeW9JZW56Z1MxcFhYOXhnZm9rS2JFS0JkY1ViVjFKQmVTMElJaG5uejJ3?=
 =?utf-8?B?Sm45TjczaVdIWTJTbGdCQTBMNXdhckFtMHllQkc0Q3JNUlJBMHhxeFphK3ZF?=
 =?utf-8?B?WUxSeVJHczZ4T1JDc0c0dHd5UVdIODBVY1BnSFZxRHBDMWlzUmt3b2ZrSitC?=
 =?utf-8?B?ODJjMnVSSEpldDN1REd0YXlCRkNqbzdBNngyaGhVdFJiQjZLb0xCU3R3Y1Y4?=
 =?utf-8?B?NzFqZXRvL1RrWVFGSXVrMnZ0WG54KzlTSDd0bnJ0V0J0ZW9URSt6N1F5ZlBn?=
 =?utf-8?B?UmlMNi82VXFXVXRvY1dTS0ZLbU9hNFJjUGIvaGVVQ1lWV2VkaDJhZFRZMWM3?=
 =?utf-8?B?Zk1iTUx3SFU4Z0FZd0pTNzAwendQNTZHcWJvUHd5U29Kd1A0dmdMajh3Ynd2?=
 =?utf-8?B?eUllWCtBckZ3K3Z2bW45cENiRE44ejk1YzRScjY2eXdrUjYrdXlTcjBBay9Y?=
 =?utf-8?B?S0xBU1BNakFVNy81OHVvZjRJT3JTR1dNRUMyQkhCczhxRkNscE9JUkw0dWgx?=
 =?utf-8?B?S0tqT3JjaWZXdEpoWE1TbVJsRTlaVU1UUHdMOERiejBvNE5ZeUM2UnpnVlU3?=
 =?utf-8?B?L1VoVFJ6UFZoMnE1eit5SXY2b1RCYUhOR09iYzhJLzZySWRhSXoyV1cxalpC?=
 =?utf-8?B?UUJCNjBtelBOSFdLREhMQ2cxclpaay9tc2tKUXArZmR1QUl0aGRWWmZ2TE5S?=
 =?utf-8?B?cFB3U1NUc0ZkRGVNSDJqN3hFRzh3bkhUSWR3cVhMZHl0WHpnVldQTlI0bms4?=
 =?utf-8?B?L3hYOWhoV09LNU5GTGtVZFptNWNCVDBQczgrdWRNNDBlVVNiTHdhYVovUVRp?=
 =?utf-8?B?b2lHVW93cTMzMEt6QktIOU5ueTA4V2xUTnI3am4xVjRKWW9STFNKWHNhL1VD?=
 =?utf-8?B?U3FJSE10Y3VyeTFaWGpFVGJXeVdLQTZuMks5OWgwWm9wVVphTnFPRzFTaHE5?=
 =?utf-8?B?V3Bwd21YRFJXdFJmN1JxcUxlWDJNc3p1bG9CeVJ5SnFxbWpaelpvaWcvcTNI?=
 =?utf-8?B?R0hLWVViTlRjNEExaFNBcTZrNjE1RHErQmhEb3NjTWRvam96cXl3LytteU8r?=
 =?utf-8?B?SlFNZXBzYlQ2a3FHU0thZjUyR2FRTm9TTmtXWE5Hd1JNYTRTYnF1MkVoM2FV?=
 =?utf-8?B?aGRTeFNRa1A0VjNRcXI1MnlNRkRiQWhJdkNCVmJhSnhxMlRXNTZ6eUo0R29I?=
 =?utf-8?B?RlNzamtSZUphNWZlaEtVUk9pUzZEVno3bllPVDVWRGJEU1huaVdIb3BJZFdC?=
 =?utf-8?B?YkRzTHNkbjVyM3NZT3htNTcrS0RqdE83RGNpSXMwREF3MHlEWVBPK25uYnJC?=
 =?utf-8?B?VjFEZ0RTRHlUNWc3TE54UTVNZFNqdGpLTjEyUUduR3dLMkNhZXBWR2s2OUlC?=
 =?utf-8?B?eXpjdlVLNkpxUDVxOGczeFQ2ZkpCakdmcU03ZW5ZOCtLZmx4bHExSVErQm16?=
 =?utf-8?B?R0wrcE9pQndrWHFoZzljU1pCWFYzUmVtakhRVS9QRmtaSG5wUXBIZTlKeFlT?=
 =?utf-8?B?TTVmWGZXNDF6ZGkyNlJuVmRsVzhyTHdkWXNkMVM2SEgvWmRDNERIKzhiU0ZN?=
 =?utf-8?B?MjFYTWhYQU1jemNsT0diOEFYRUptMG5MMTBNSGxOa0Vhd1JPQVd5NXhMVDYx?=
 =?utf-8?B?Q2UvWC9QQkxzdWt2MVpzaFFsZmsyTEY3cGUwOVFCY0tMTmovaEVrSWFPVnlw?=
 =?utf-8?B?T2hON3JTV29sRGFOS1dvZk1UV2wwNXRqYVJqYlI1S2JaVDNvU2V0SXNRQXhn?=
 =?utf-8?B?d2JhbTA3eXpFT2puRUh6OExPRlFaMEVIbERrQ3JJU25DM0RzRDEvNm1KMk9W?=
 =?utf-8?Q?1KIWeAiLXZftS9uo=3D?=
X-Exchange-RoutingPolicyChecked: lpGH+3wP+2tEcuGg23N2nLvKMYkhPxHkCp51GvBI2/PnyJEZxP75oN0YR69PMHnQtc95cMRchE0JQMphDIb3mcB93AaVZGFmVOj5gl8WeGqYKuFt+hVZxICPzKUSLaFGVBKKsf4QYlrmWnnQ9EWawP6tZ926ecWEbboH9X8+WqOPnQxAkJk50OFeSCcGqH+IZG9sD6F8/aeQGOe7xB6IkNCaOSuCY2+KaIHnSZzKbIBfH3QLoAFePrVlCG8DkxncjlA7OOdfYfgMJinEZ9Nj4vAR5k/hJgUf2iTApdSgsnEv1s/qIzUyw3bMucPedfeSPTgVEOV7U+Pj1ys+J4FNyA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ff87f16e-1c48-4307-90c7-08df1a7e1f9c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:55:11.0178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5P3taqgLdebUzkFb59Lnq/ms5+JkQtlPiJ7r0wnrw+pJEKDWUtruWTMopaPw9mMOyHV++oZVCq1eZ1Sw/zmZgJJt0UJA62kw+givL+MnwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9916
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> AET (Application Energy Telemetry) event groups each support a specific
> number of RMIDs. But that number may be lower than the number supported

Is it really a problem if an event group supports a lower number of RMID
than what the system can support? Was this intended to be "higher" instead?

> by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
> enabled as that reduces the number of supported RMIDs.

The last sentence seems out of place. Does it really apply here? This is
about adjusting the RMIDs of the RDT_RESOURCE_PERF_PKG resource to what
the *system* supports, it has nothing to do with the L3 resource which is
the only resource where SNC adjustment comes in, no?

> 
> Reduce r->mon.num_rmid if needed to ensure that info/PERF_PKG_MON/num_rmids

Please replace verbatim "Reduce r->mon.num_rmid" with what it represents.

> does not display an unachievable value to users.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	Replacement for v11 patch 14 "Enforce system RMID limit ..."
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 3bf4d1a07593..a20439a5099a 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -798,6 +798,12 @@ void resctrl_arch_pre_mount(void)
>  	if (!intel_aet_pre_mount())
>  		return;
>  
> +	/*
> +	 * AET may claim to support more RMIDs than are permitted to be

 Contradiction between "may claim to support *more*" above and 
"that number may be lower" in changelog.

> +	 * assigned to IA32_PQR_ASSOC.RMID. Enforce this limit.

Please use grep friendly MSR names. "IA32_PQR_ASSOC.RMID" -> "MSR_IA32_PQR_ASSOC.RMID"

> +	 */
> +	r->mon.num_rmid = min(r->mon.num_rmid, pqr_assoc_num_rmid);
> +

This is AET specific enumeration code. Could placing it in aet_get_events()
that is closer to AET specific enumeration and original initialization
of r->mon.num_rmid be more appropriate?

>  	/*
>  	 * Late discovery of telemetry events means the domains for the
>  	 * resource were not built. Do that now.

Reinette
