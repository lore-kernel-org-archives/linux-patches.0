Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342C02E8B82
	for <patches@lists.linux.dev>; Thu,  7 May 2026 18:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778178660; cv=fail; b=M+bWa7GTWHCDRK6sE+B3AWYi+pwQuWY+5JduA42LkaooviDV32rBovZXw9cBAjbxTodzg1lu5bCSoK8/v4eUovSTZEoXLrXei4yNzCxXHX++PnPfvhbViseOhxvqBHF+dZUIdMI3qWgMY80tLAXJM1D4WaGRJIc5D5dNZEyNe3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778178660; c=relaxed/simple;
	bh=ZfdvFWlFQsDhTIaHN0A01SylCb0ZuP0g15KAGHGMyME=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pK64N4tDWds8PgrbjwQnjB+DJ/cxF0x8DFH5njIidzk88qWAprr/yp+IRf/0wvEVR9CclYm7EJBus16Oc6p6hrLK4zeUBbWgBqPrZfYYn92Wa139q3EXkTgN6ZGn33sRJKpWTcHtxQ89ZHjbqbdV0c2Ce9eytqvmiH5uQTs9iwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfKL9+HQ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfKL9+HQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778178659; x=1809714659;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZfdvFWlFQsDhTIaHN0A01SylCb0ZuP0g15KAGHGMyME=;
  b=dfKL9+HQTC+B/oF2B3/NiRYAgrFS5Qh1z0UEIdexxjdUdPbExlHLfb3v
   7UZ0I9MZIu8k1EYec28oqpVF3Fc/TXnRI9Nn7/kSzAru4aielypx+9vLS
   K3al/UBnlak9zQy5Eos0Gb7XgBy2QlxZFc/YhBInovaTeJ2b/XOhz+uDF
   qdxOJQxsmx0vANZsKw15u0coa+G+AXzH3r9xOjNdm2DuTBGU6hOInt0e4
   n7wJty7WdhvwDF6kw9/HWKnEgCVOueWVDvNcKkKg7SF6eg+G542lY0dxw
   Vmn/4AcfVqBhc/kduHS0He1SU8+EsT/kLJ7t0dm0OQ/WJLoZutwm/wpvB
   g==;
X-CSE-ConnectionGUID: K7LXGkbLQfq5Xofjl6TABQ==
X-CSE-MsgGUID: 8Cz+46CRQSKUcIOyiUEwQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="79185833"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="79185833"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 11:30:58 -0700
X-CSE-ConnectionGUID: RswtSHcwTUm2bHJdioZU7w==
X-CSE-MsgGUID: s/png2qyRvyuA35x+uV3sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="232179540"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 11:30:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 11:30:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 11:30:57 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 11:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPZGp/XaJ5loAfXQ87nRZmYgTLf9Rqrr96EneXh/ucpO0DpUgZv5/FfXSIVWKOC4pG7Otwh0WuG08fpwQ6cNfiBDkglpJOpSxJOmKCAYHbGZLWwr7H5vNhaf5cdWocgxjWEYQ6cfGHHUUigHrSSZDsLnwlh2qGkZ+I93VrdYIU0arH8n58QF996pop7IVR81/OKTlzHtpdEX5CW41l++dKXxZCbX72MCvUheDMdqJOp7ofyFlYYBzCxGi+ciISCzTCfb+Ni9G0i36CN2Tn77IPfhvsE98AyYYt9PK0P+mtEXU7MWYUknsuCZ8xP1oXXZZmMA6De9qs0V1Ds5vBdBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uSOSOndnPSK9g+Y+fzQzPQZkjMpZKTbvTYrB393o7g=;
 b=oUSjoVy8wqaZ228ZrA2mAMJqfu0yQFyappR82QnubztimpykqzAF7BeKZpBHvGShzqxpAC+RNVGJvw/IRPCeaY4OmSG0ncbj8ur0VTxQfKulAPWcZyZN+dhMbLTzDqFbUYocY306C+P+EI/16sxWT9PS7S+c8w5I4ZBrKJEAw8QlDTmlUvY0bM0Eqq27HZ3kgEN7iX4FkT995TAGF73/NPRSA/L9xNSot7INSEc9q+8Zk8ab+8EPxjg9o31lRI6j2B/ecUNptE4/f6bgoWrSBbjxnM9e+BvnGZ2pxhpC2xhEJ1EjhWpq5gMR8fWASkYIFFS4Wu/5iuT+dCczDbF3YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA7PR11MB9596.namprd11.prod.outlook.com (2603:10b6:806:4d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 18:30:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9891.015; Thu, 7 May 2026
 18:30:55 +0000
Message-ID: <d3b1f1c1-266f-4d17-a049-0f12cf5a9360@intel.com>
Date: Thu, 7 May 2026 11:30:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/resctrl: Fix deadlock for errors during mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260504220149.157753-1-tony.luck@intel.com>
 <5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com>
 <afzQFkVPiNW8QR8J@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afzQFkVPiNW8QR8J@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA7PR11MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c862bc4-f79a-43c0-e821-08deac66c6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: SGxS10Cyl6L9vxHd7mJRzyt8rI45suZK4c64GllMEaZXop7C9VLYAaCUNkSBtXVElnUZuSBQLFLdM7vhJrkdiGsz4FLVWKg+f71TVxlAz8ZFxSj3doTmtnkiteoUtn0doO2DqMxl2VAXq+OQkfFHcONquGiF+fY42TzmqsAzUOg0W9QEqbFUWs6tPI9tM2oEyV4UmMRwmiUum7hl5OX2PCcvoU6tQlh61vy8P2fNZ3P3BHRnP1eMon+gXZjdqkkFb4OIuI5I7p7egFrIGZr9LEBrYdIxVY3sGMg3+f2LvAXfltIl3Y8FP5amirkGGhUuA8LwgRlAzKhnNpwkxS5F0LKtD5sq8mpnQeb7Nmmy8pa+Qs9t06IZxjNwVGUpYGh1uVoqRplL8KZfc2bRdCMFPGRSzAEz2iB7BHYmCmxKE7az6A86w1Pz+OUt3dIDqaQerTvMEkmab+Nv/ZSGGhnjNbtdwyi0XmwI5AcWLM9CaXmgBOLWcqOcMrAILIIVClr9iMtqneml/z42sRoxYriVUgakCd49uLTO1uMe+fE7sqXQ+Pw0es1tSLzniCytsZjMj1vrM1IrQnzM5otAyEmDU4qtRJtnRdRjM6yToazxKIsyse1Ed4o6+vZ/0o65k5eXq9HU07GKc2X6qgkpYLK+XbC2I8SZQHNfGgYATOwugqwIe9pK+VyD+3YzPlhyVAoe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1Z3YndLN2Z0ZlJlQzdJQldVUDA2VnFqeFdXcVVnYWtlOXAwV2RXTE9aMU5y?=
 =?utf-8?B?ejd4REYyUlNXU1EvN2xvUTdJQmdBc2R1dG5zUjNHT2M4ajJuR1lYWmxJbVRD?=
 =?utf-8?B?OEl2NFFPNGVjemxRY2JpTVRydnJMVXJoL2JxdVM4di9QNDZSRUhaUzhYUWty?=
 =?utf-8?B?dVlhMnFMSDJYZkhKTU4yWTJmMVM2eVlEOXVoNUhOZkZ3a3VxQVVva292aGtT?=
 =?utf-8?B?V2wvQlZCRkp3UWJab1BOSjlLTTlwTCtqOFk1SEQ0Zkludi95cDR4ZzgveWNq?=
 =?utf-8?B?THJnb3A4Mm5CcTVpVG01TUNRWVMvRXJiaE5JZkNkZ3RkMzhLemErMXdVNTAx?=
 =?utf-8?B?YzA1N3dqTFg4T0lKczhDMDFlbXMrUmRDaEFhckxOSmRaTUh2NEpJMnhxdVZh?=
 =?utf-8?B?cnFrYVh3eGp0ZnBXb1lPMWVBM3A0U1oyV2xRTDlvQUlENG9MK3d4UXFSMFhG?=
 =?utf-8?B?cTk2ZVd6dUVuV2JDNWxITWRIeGs1aWswMzFqcWMrVTMyekVnSTBFb3REdS8v?=
 =?utf-8?B?MWVXL01KS1o1S3ArZTNQSGVIYUNLQm8yS1V0VmQ2S1AxTmVzZWFIWkV4clVT?=
 =?utf-8?B?TGJaVm5keE13UUZGelRLTGpGMVRKSUJzOHZGRE1IdC8zRzcxZ1RtUnhJL0VS?=
 =?utf-8?B?cTgxVFk1RWdUTkhPaHB6YU1mWUgyMWZkUHlqMjMvY3JXbjVyOGJndU5nMmNG?=
 =?utf-8?B?Ui9jcm1qTjBESTFaNVlTVXo0VnpERWlwMCtOQVl1UHpHNStqN1J5d3FhUkcv?=
 =?utf-8?B?UTdMUGNFKzhSRU5RYmJPd1VET3dNYUt5Qkdxem51TW9mVzAxRXFvemtOeHVT?=
 =?utf-8?B?OEpuaHhwNklkZVRadUZ3ODB6UUFTU3VXS0tnVHpYaUZUd1JNbTNyeEdMcEJm?=
 =?utf-8?B?VGo3VXJxWW1vc0dNMnhFR3FjTVl6dUJPVStpc0JjSFV6VmMzQ0hTdkJ6dWd5?=
 =?utf-8?B?YmFFSXoycFhYa1dGL2pEaGdmV1BENW1zM0dDVU9OL1BvVndZUm9iRXh2UUU5?=
 =?utf-8?B?bHpvQldSMUNjeER5V3BpMFl1NUlBUUkrdlhadjFYZUxMWUZIQ29LbU5qSlVJ?=
 =?utf-8?B?d1FtVVVleWYxQzB4T1VHVHlsQ3ppNGRETlYrZzZlancyeUFSWlJaRmhQeG4w?=
 =?utf-8?B?S1hwbU5ZZy8vWllYYUVzczJRYlA3Z1E0b0dINFdqR0NMV1kwKzFReDJMOWF2?=
 =?utf-8?B?RVpFZVBBTEpGN1d1R0NJUjdPa0JXUU1scis0R2xJUlJpTlQ5OEJNNDBjMkRu?=
 =?utf-8?B?VnBENjluRnFLS1BlRmpNeDNBZVNJd2x4V3BnbzYwN1kxcWZ5NEJCT3lGd2Ex?=
 =?utf-8?B?K0twNFA4QStodjIwWEF0U2ZaUEpMTlJzcS9FSTZ3RGxTK1dnQjN4U25VdUQ4?=
 =?utf-8?B?aFNvUk5IblNHamY2Z1lNSzY5Tm1hWFllbEV5ZFZUS0J0d3VNUzBPcHpLMWhW?=
 =?utf-8?B?RUgvWDFvdUtJbE16QmswN1l3Z2ZvS0R4akswVkdMVzBDYWpTSFk1dGtVK3VX?=
 =?utf-8?B?enJtdmM2YmxVMlQweVh4YVNDY251QTlEVjU1cmRKSUNVK2o0V3R4VE1mb2xu?=
 =?utf-8?B?V0swaXdobnNnTFQvdHJLdWwvK2dicXhvNHVwNmZ5c2Z2TXdXU2xheUFlRE9X?=
 =?utf-8?B?TW03dmd2WWdPK0gvL25GeTZHUVhhb05CR0NZM1h0VlRVOXhOQU5XalJuajBU?=
 =?utf-8?B?ZmZCWG9KRWU3Yjc2T3p5b0NhM1hoNEpIcnhrSzgxVzVGd1NiUGRHZUozUVVH?=
 =?utf-8?B?LzR4Y2ppcUU1VWFpYUllT3laMldQdjloMGhkN2gzQ1ExUGZPWUJyNkVTdWlD?=
 =?utf-8?B?Z3lmc2YvckhONmwwaHRPNGs0ektaRDNKRjd2UVd4bzMrQ282dEM2dlZ0YmRy?=
 =?utf-8?B?aFNsc3E1YS9hNm5BTGFCMm1KVUpTMnRDQ0t4TyswUVdPdWhLOTJRNUQ1eVJV?=
 =?utf-8?B?S2xwbjZ0MTRQdmV2WURkR0Y0WWpFdnlCMzVmdXlVdTArTXZlQnpldGxNV08x?=
 =?utf-8?B?emRmWG1weHVDUVUzeTR6OWV6WG1PVG02WUR2K3VoYnM2WTdOajdGQVdRdUpW?=
 =?utf-8?B?MCt1MzBvbnF4N0RxLzhFZlZsRGhvaU5YQ3ZwZ29EN0ludFBhMjhkOUZyS2lR?=
 =?utf-8?B?cHhHUzZQTzduWG54MUN4Z0w0VXZFc3NZdE1xQ3BNcFNkRktRMzRWRGtQMldu?=
 =?utf-8?B?TlJGUitBNmUxMzBiSUpqNkN2dlpkZUI5RnEyL2RKd1hhcVF0anhJdGtJZFh6?=
 =?utf-8?B?Q3JiL2Z0R3kvcUFKWnJ6MzJDYmZkdkJleFNRSWJtTGhvMFhsZ2ZjbWVUMWN2?=
 =?utf-8?B?RDhjbHFaNGxRUXk5TnVqRUkwR2RXLzlnQW5yZkdKU250SGFtSVBNbDZRV1pH?=
 =?utf-8?Q?Sjx51ZdVrlXafNhQ=3D?=
X-Exchange-RoutingPolicyChecked: iRXP4sAPUL5i+U9GAk5YIbJoQt6DzqRiHzRa6pi3/qeLVhZBoJnmx63YJE1hJASkq80AeAJ95SomOB8JrPHppCC8QhX5ZH5sowHGYdATULkVMTnGF/YRo9vauH8v+OJXzncBbD31DlMyZ0rqBesoKhTet1t8GzPaL91rbS4ONeUF3ls/gqlrmOpLyPc4PbVnNnlU5+itywaCXvZPIq4qJ4YadvZQIAOFUG+/Zf7YXm4wHIic5M8/J9xJuf5OBjzddTIBjoeSKhVy1uiXMEmfn8iJgI9PeyX7AoxOG8ys//PLOt3bJ0RyZQAVhJCoAD02HmnfR/tHFRJWTCq9YAWw1A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c862bc4-f79a-43c0-e821-08deac66c6ae
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 18:30:55.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AhofWe4Na3QCbvVX0w+/Q/RV7B122GfvrvX3c1Cf3rRF5TN1WD2b0pdladKnEbK+VrjSh/nVNFIpCumvHXxQYskiguXZOAS+VeClKBOEXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9596
X-OriginatorOrg: intel.com

Hi Tony,

On 5/7/26 10:47 AM, Luck, Tony wrote:
> Reinette,
> 
> This looks promising.
> 
> I'll split out the missing call to mon_put_kn_priv(); into its own
> patch before the deadlock fix.
> 
> Going to re-run the tests I did before forcing kernfs_get_tree()
> to fail early without setting new_sb_created, and also late.

Thank you very much.

> 
>> +/*
>> + * Temporary forward declaration for testing only. Move functions instead.
>> + */
>> +static void resctrl_unmount(void);
>> +static void mon_put_kn_priv(void);
> 
> Question: How much are forward declarations hated? And how to handle
> this?

I am not aware of forward declarations being hated and I am not aware of
documented tip rules about this. Even so, I do find it cleaner if they
can be avoided. To handle this a prep patch that just moves the code
without any functional change should work?

> Moving the functions around in the same patch really obscures the
> actual change. Is it OK to have a patch to make the functional
> change including the forward declarations. Then a separate commit
> that does the re-order (where it is obvious that functions are
> being picked up and moved without any code changes)?

My preference would be a prep patch that does the move with new
capability built on top. It seems unnecessary to me to add a forward
declaration in one patch just to remove it in a following patch.
I agree that moving code as part of functional change should be avoided.

Reinette
