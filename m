Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633C91E492D
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 23:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781046246; cv=fail; b=NuHKucgMcpniqcoRVyceuEBDvlzlt0ErJ67jqLDc9aaA8mjdAjvyLfXNKTG/NVQtG6MMZ2JHgeQyya+Zl8kW8jSEWPSe0TLBogQ7hQ8cTWque52V6KC27hiBy9avrTyDo/pS4P15xms3CyyLjMTVilpTIi/FQQXsb/r2zZ2IxNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781046246; c=relaxed/simple;
	bh=TlC1T22lcueXTBE9eghbw9ZRJ48cvnQ5cBqAiXI28Mo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kt7NXBm65RA9Q04mx/sS21YYVdCRjKubAmvHtZ8vjQuFXPUPu5dR8mearfqcUTFFR7LzPPmDGCnjzBdUQajkALiUi/aJ8nqFBdHySwPtgPWmTDPUqi/cdwH31Qj31K8aV6RK9vfZlXLrEL27Ti3RxvgT8zBmhndom8Bs3LX/Y1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2oBx13q; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2oBx13q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781046246; x=1812582246;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TlC1T22lcueXTBE9eghbw9ZRJ48cvnQ5cBqAiXI28Mo=;
  b=A2oBx13qKOuPj8jos8pti2ZTdxnfH23eCQZYjCTzj5DawVNWv7y9GMhO
   WSRou43Yr5t63Lvky12htZo6CHIaLtEljXsxrDdDumPuSCfd29LKsA3Xz
   cQSXoI7bOn6q6Br+IbAhNF08/cO3O9N4ywiQIurqilzXlajoksuAgp+Dy
   AuAgCGSbIUP/gCnevHOfR8Gd+Ox2MM+wViMque5SusWf+WL+f6wGPDCG9
   ItzzA3hwC9C0/9LU6xkcngA1FUtkzxC2AE8pMgWXabVGBnNEyFGu6HBA7
   AcIbWubWp6ro9FKz9FkIDNs3lt+TzkYuksak09iIjszRvY+WdyKSyZ64e
   w==;
X-CSE-ConnectionGUID: 9efOW3NeQL6QGt4fTIF3LA==
X-CSE-MsgGUID: 6wrbS/HpTeWHm+rh2uY1fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="85676147"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="85676147"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:04:05 -0700
X-CSE-ConnectionGUID: 1l2D5wzUSlqiib6rgZkdtw==
X-CSE-MsgGUID: tUEgIcntS+W/3Vn6YsD/9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="246025069"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:04:05 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:04:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 16:04:03 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.19) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:04:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fGbbRjSHKxp0Rr2e6bBdX3nRTym98f6fsahtxICq2cc4UMWX7FhLeLbzgK3lze04YHBLGqTkpiNrCnxiweOgPD1XPm3Xk/t0v7Phtl4Irs+TIltQJA3rACNGsQtzBh+KJX3fmojXUluhtUszfUHOiDdnVfYcPFTH+eD5Gxjf3OS7lzRDwtSeNpAtUJsWczRkvirm0fV3zTzccSVd8AUjq7lHXHRpBxt4IYjXU3aZIV6x5H+EPAE8RV2JBthOLeMqPq2Fojz/VHciC2eYaAtjY5ECekg4zpML9EmtIp4dn9lJDx/b122SyI0qzFL1/uLVQMetRL/jqYhvmAUSs5s1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kIfj/+0MO4vgnnl6SungtjufcJm5UnQ6/mb1PdWjnE=;
 b=xQw+MtNwSwAjDkKb0ttnm5KqXW3ug2MI9NiYx6aH7xo2ax9Hrhl03VKkaTsQroogxgXbqzHMlzJOJi4LrNtKcAlECquR+QkaY4q2sPpfMFw5emea4YgquayoFehrrUEOd8zKYMQS4vxkuLxlzZUPvNm7oQT3qQG2cl9c8ne/Wsx7UgxO+s5r4QxWTXoyH5l3edHSFoRJv0F9jiP5WP5JZ4qygTZHfsIbo+v9E8bX0wRl9T9KZURRc3LGM1iSeJTKf8AJzJUJCkxtoTrNzYMDBAWQYKtDPNbZL6fNGXDN3IG96DYwEs4yd6K1G8C6yCt8TuxmOfWJ7RQSu33VXr4b0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS0PR11MB7336.namprd11.prod.outlook.com (2603:10b6:8:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 23:03:56 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 23:03:56 +0000
Message-ID: <40404fc1-c355-4848-af2c-f39f8b3b03ba@intel.com>
Date: Tue, 9 Jun 2026 16:03:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/14] x86/resctrl: Maintain a count of enabled monitor
 features
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-8-tony.luck@intel.com>
 <ebb78841-8676-4383-a1b4-81ff4f1e782a@intel.com>
 <aihfcS3T7M-hn5NV@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aihfcS3T7M-hn5NV@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:303:b4::33) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS0PR11MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: fd478c71-2285-4521-82df-08dec67b61c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|6133799003|22082099003|18002099003|11063799006|5023799004|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: sjjaEjR67mJ+WROGG5RcCjdGORXw2fubetalvDF1wsNYFurhQb8WnPwFJAiwkmPjLGByfOPE8oPEsdCoKDMLQmiPpDR+u+tID1ssw+2caeBqHJY+BFjBRA0RVdZy/QIIbivPk41/RzFNKkL5pdnNpIUTnxql8HoExH7UgVbCR2NKBxzER1PXcYo1VoCVj4HweBt/Eib/LIcXjbE4/vrv7wLcwQCouiEwF+pvUN+D7bTIoOE31U2KLjJRGNpc7DehhPTGWQKRq5PyCPBsZY+hoCGr5dUDhPd/zO4Vdg8rmyg+tCZWiShb4DgSAl+ZJiMzRF/AL+B0R4S7N0EyD/atI0XbqTFr79aleq/nTIM3snJXAhsz7ThgmetbYFDzordoR1b8rjthQr0rATgKJ6mws/5+NY1V4cF0fUIwPjwKYxxJq2ZOD3jez0jsY+8H7YDDMOKGlKYJ+EPB8YXW1MBAaBFYlZBf+lhm5PFaDtfWf1wIcd6U+9YHwazaMbGWS51rh+bZh9vYW4595M9KQ670NkaaCHKaacbFEUCRtUiuq7U+1vuM0sXu17W0Yav/lYv8QDkr2f3X7UXLMweQ3xa9UKxV5Z0iIAJX9QTFd2mDK0Lh4Dho0HiSPN2Fa1zhl9D3QHG5pMWH1t3YfUBr4bEKOUZRAKrZ8r4JsrtaJybaWHoJJC4UGTjQoh5NaeWKLaCm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(6133799003)(22082099003)(18002099003)(11063799006)(5023799004)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0RrUVFDQStNYkhIbStOdzBnR0lzeG14VkE1YWFFWmphSzdzdTFCT1ZhUFJN?=
 =?utf-8?B?YkhnWmxFeEpEcUpaeldpWnc0U2FmbUlibDBzemtvQmZuN2dIL1lRMFNSeWJU?=
 =?utf-8?B?TVdGRlJKdWlvSlpQcXJoT3M4ZVpRd1dZYUhnZGVPWkVBcGt3WGJTSVpyb2hx?=
 =?utf-8?B?MUZSSUtyN2xRejJHaVNpT0UwUks5K0wxNnFONnM1dW9rMUFtTlFBSzJmRWYy?=
 =?utf-8?B?L0MyQnBIWnVFYXV4Zm9JbHlQUC9Idmd0bnU4Y2J0UVVnaTNMNlpFRWNMMVJI?=
 =?utf-8?B?a3VtbUNGR0g2RUpmaFFtZWhORTI4TWJ0MXBKMEZnRXpqZ2o5VE5DVGFDd0w3?=
 =?utf-8?B?ZHRocU5ETytiUmNBNUw4T2xBUUM5NmhqSXlXcVJtVkZsZjAvU0d5VUM0bFBN?=
 =?utf-8?B?TDhnL3NJYWNCU1E1RDliaWQxeXV1SDZCOVAvZzFIVEJ4N3dXMTdvand2L3hk?=
 =?utf-8?B?di9CYXhMalRTQ0pUcHVkL2sva1c2M25PSmJmb0ZvQ0pTT1NqOFIxUmhLV2NJ?=
 =?utf-8?B?ck9wdmZMZ01aUE1NcFVHUkRlbTRkTWN0SDFoOW1ncnpLaXRKYit1eHFvMito?=
 =?utf-8?B?WVRHVml5aEV0dnhCN3pPTjJ0dzQreVZnbjUzbS81VjA0a0I1MWhkdlZRUGYr?=
 =?utf-8?B?WHJ2dEFIYTU3cmRJZXFhWUpCQkl1c0pJK1lmYTJ2enEwSmdxR2NpRmlUbFBw?=
 =?utf-8?B?cU92SG5jNEJ1L0M4bkM1UElsakdmTVMxSUVMT0tJWU1EdGRsanU3c0JhMEla?=
 =?utf-8?B?QVhXM1dmMlgzN1ZPb1VLQnFpWUlGcERPMzNGc0tzMktML2tLVG10S0lGQWFG?=
 =?utf-8?B?MHc5ck50dzdsRTRORjVMVmR6QWhCb214blNQQlB2UXV5NllOR0pyd0lCTjdK?=
 =?utf-8?B?NnIvNHpCTnVEUTFycjRFSVVaak50UFluMmZnanZ0ZXhUU2Vaek41MjRBODgw?=
 =?utf-8?B?OU1QRjZWdCtZK0NJcEIwa3p1VTJDNFZRTmxvMEdLN0xXb3dTNWZKbWd2cnZa?=
 =?utf-8?B?QlJ6alBxbm9iTUowS1l3aW1lYXNuRW93cHpXV3lqYzNwN3MxamVTNVowN1NS?=
 =?utf-8?B?MlRKQzVxYitITGVOWExKaFRGOEFEMHA3SGo0cU1QUVJMVUtDVGxPVWxWUHJS?=
 =?utf-8?B?WXhFanRmUGVValZyU1RMeDlyTXlFSFY2dWphMC9oYmdVMVNYRTV1UEZSM0hN?=
 =?utf-8?B?MHRpSmY5SmdWZmU5c0wvUWkyb2lmc3pSMjEyK3I5L0cvTXp5RThCNTlCbmNQ?=
 =?utf-8?B?R1BZeExVSjN1Z1pYMmJ2b0phOVNSVTFKbkZja25FVHBLVjJhQW1HVUppaTdR?=
 =?utf-8?B?dWV1S1d2aHhWVWowclBPVTkxMFNoenRYQjFLMnFrbFJMWDRZMjdDRE5JdU5u?=
 =?utf-8?B?VG1sc1hQZ25aZFNMMG4zZnJMQjA4NXdiNGJOa2FYN1hVb1VWNXp5V0Y0VlFi?=
 =?utf-8?B?WVNFS0V2WStPVDZrVWk5U2FNNGxOaW1TcGdNNUtBbVZrc2dHM3BLOEc5UGR4?=
 =?utf-8?B?djVraHpkV1FyME1lT2MzVlJkNnhQQytpcjRXQzNBVnNjckp4eUJpeXkwSUtE?=
 =?utf-8?B?MFB2YUFpMHpTbXdrbGoxS0I2NEZJbng5M1BwRnR2ckQzdEtjV3BYNUdDSXFz?=
 =?utf-8?B?aXAzZlBVZDZoUHhibkMxVlBwbjJNbXlmaGZoa0RKTHdqQkUwUHVtNEwxazhB?=
 =?utf-8?B?YVhYWXVVZVkwemFQSkJ0VzlwdUhyaFBseTZJNVZrakZkR3EyVmp0WXArRDNC?=
 =?utf-8?B?b0R5VFVDWk5XZDAwN1g3a2ZvY1M1eTlZcGFjVjMvaGd0R0FTS0xpRFFVazNV?=
 =?utf-8?B?TU5WTTVGNE02R296Tk5rQWNLbmpwSnhXQW5GaVN2TTVpRGlBSjlkSmUxb2xJ?=
 =?utf-8?B?SnlheUpEbjRpYjVwSkJaaFRNYTVxL1A4Y1NZSG9XYVgvNVhDM2lPcUJUdkxF?=
 =?utf-8?B?czFMdWx0OHJDUGlnY0t3UldCQ05zMFM1UTFsK2tTSDRtbEVORHJWZThCdkdX?=
 =?utf-8?B?eklUbnl6ZERqOG9FZ1pFY29PaFcyS2JrcFRTVWpVT0wzb1dxZm5lMk1NS25L?=
 =?utf-8?B?b3plYjhFUGtwOVFxNVZwbkVaK2VKWTFHUHB6M0pjTENaOGFXSmxzTlIwRmI0?=
 =?utf-8?B?QlMvL3NaRmZCcUVSbm5JWWhZMHpxM3FDOURGYjNlT2g2YnZxa1FzRnUwVlZi?=
 =?utf-8?B?cUF0WFFkYyszTjExRThFMXMvZGtvSVJkNGMwS1UyaVQ4d2dZUDJQclYyd3RN?=
 =?utf-8?B?VjRXQmN1TGhGV0FCZ2VpWTFHNVhvVm8vcmRtVHYrZzU0am1vREliL2RaZExq?=
 =?utf-8?B?YU1PbXA1TlN3TGdZR2loTXlPSjdwV1E1TFBqL3lQYnpxVVp6ZDJCTkhDUm14?=
 =?utf-8?Q?VvqUZ4vCcAiVMyK8=3D?=
X-Exchange-RoutingPolicyChecked: rhNNP682W68tuOl7QFg6WmxqxDtXbbcEcjYEvuvdy60mGYiBxOMl+y+mfZVvA9iR1ptpqp2+HlE0QKqFSFo3OY5717deqs7M35UAainZn6F5s8r1iSbs4HalpYaS4QaA6EKhLoraHEFzUM0BYqBF07koW4QnLs6AljBF8eQSJflfBb10xA2Ek4k/sI2A/2gB8X7TypGEhTIGFmqCCsGMWagl/x8RhvW1lTeMaGR4VmcZd8j+aOT1mieAw4GlVULFDu9e2LEBNN2qjpmB+pUL3HjZ/f22cnKiwJPOk3qpdOj+DUl25qV8KrugZp4ZQISmFhmgAkP5FyvkOS7avjF5hg==
X-MS-Exchange-CrossTenant-Network-Message-Id: fd478c71-2285-4521-82df-08dec67b61c9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 23:03:55.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOUwoT4zfkNPzikZAHfWpGgnxUOhTg1zFocci+a/qEF3rCvuRvdL4iqNzBFQPzVqlrMuJSX+MckwQ4UCFy4gsgc2hyDtdgIGj4bysNAcwVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7336
X-OriginatorOrg: intel.com

Hi Tony,

On 6/9/26 11:46 AM, Luck, Tony wrote:

...
 
> Conceptually this is much simpler. But I have questions about the
> implementation. The new function is trivial:
> 
> bool resctrl_arch_mon_capable(void)
> {
>         struct rdt_resource *r;
> 
>         for_each_mon_capable_rdt_resource(r)
>                 return true;
> 
>         return false;
> }
> 
> But that led me to #include hell when I tried to keep it as an inline
> function in <asm/resctrl.h> because for_each_mon_capable_rdt_resource()
> is defined in <linux/resctrl.h> after the #include <asm/resctrl.h>
> 
> So I've moved it out-of-line into arch/x86/kernel/cpu/resctrl/core.c.
> 
> The MPAM implementation is also out-of-line.
> 
> But then I wondered about performance. This change on x86 goes from an
> inline function that simply returns the value of a global variable to an
> out-of-line function that scans the array of rdt resources. The common
> case will be a hit on the first element, so not awful. But still worse
> that before I touched it.
> 
> So I looked for places where resctrl_arch_mon_capable() is called in
> "hot" code paths. There's a bunch in mount and mkdir, but those aren't
> very hot.
> 
> My list (check to see if I missed any others):
> 
> 1) Recurring call once per second in mbm_handle_overflow()
> 
> Seems redundant. There is a check to only start the overflow handler
> on mon_capable systems (only with enabled MBM events!)
> 
> 2) Call for potentially every task when reading tasks files in is_rmid_match()
> 
> Also seems redundant. Next part of that "if" looks at "r->type == RDTMON_GROUP"
> which can only be true on mon_capable systems.
> 
> Should I clean these up in this series? As part of this patch which
> exacerbates the performance impact, or as a separate cleanup patch?

Thanks for catching this. I think it is reasonable to include it in this series
as a preparatory patch with this patch helping to motivate its inclusion.

Even so, I am now a bit confused and concerned about the PMT dependencies. I am
not very familiar with module_get()/module_put() capabilities - can it be
guaranteed that PMT remains accessible between those two calls? I peeked at the
sashiko review and it mentioned the usage of "unbind" triggered from user space.
It sounds to me as though PMT's .probe() and .remove() can be triggered at
various times from user space irrespective of resctrl being mounted or not and not
prevented by a module_get()?

So, consider scenario where PMT is loaded and then resctrl is mounted and user space
creates a couple of monitor groups that contains the AET event files. What will
happen if user space then unbinds PMT? From what I can tell this will not
trigger AET unmount like resctrl unmount would and thus leave a lot of dangling state?

Back to the above ... if AET needs handle a PMT unbind, do you think that, for
example like in is_rmid_match(), that resctrl_arch_mon_capable() could return
different values during a single resctrl mount?

Reinette




