Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ECA4EE866
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790012736; cv=fail; b=ET1WyEJIGOyvf5yvXcVqJnsg9XLBO+/j4K2eedSYuv6YLSVe4sGnX7MOYFZqx8swJy8Cz/SSo/knFfduVdcO7VP91EeJw/BRNzu+r1dlbZ6hprlKBPS8EEJCHCewWFRsvd02rer6vFVaT9rp/QdsJAuK8+XcvS5MH0H8CmVv4Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790012736; c=relaxed/simple;
	bh=g1j34EpEK9tR97+74iFgY1NquTfMOicpp+i0AV2xAMg=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CrYK03UU5fm22lW1gg80RcAvFSkhkuSDZ2pkk9FcsfLvVlQlMgmVsdhq9j7yx+ARzqYxxMBMN2t14hSl8NEsDvbqCJ3ZNCa7X9vTRpdokAyC8l640ZJgGQNUO+PYtCDWvj8NSPo66AnDonvVaY71cH7RonEdWQJVk0/DvdxNaSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CEeTRutC; arc=fail smtp.client-ip=52.101.52.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CEeTRutC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7d8tyI1apJRZr0oJWetDH03Rcce4lh4h4ZHS+Ds1lc+yRrvv0zphDQeLRKwl51wpRvet3BndWV7Qr/uR+ArvEqnePJzhN3ktA2RTPPGH3zCK8ahz5/ESoXNGsKEhs1AxZgc8iT/1+2NUYVUKrOvGJG7z3CSglLV8oYdY5bxV57rXhktPHbLQw1UXbxICHWexuwU12JgHoaN7GgAbVTCI1W2UAMFlebZ9T8VejrMsyTRrOdvUA7czGHIoqwJPQVihArg2mDvL6sIm7deMrTd+uuVMwBKi1SOPHvPq2VkRAOt07SAt5JWYJQCc1HsiCtyU/3YrPKt3X55y1kWepYUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+isonlRz9s1h+f1emnMlN3gOjhEbEkGs8OMwsclGd9I=;
 b=EBFHfxCspS/FuP2gUoy73mNPft4gdedk1KblAwsgm4PSSmE0ujDiQfR7BZKJb77y0C4XljdTpzBYiNAEu4y+GVLGfU1s+qMEQ7oNzL3JbG9S6pxUUYkabC3Fn+5A9Etk96UtBIV3gpizFzdq5E4C39rNjdx3AaFiNaclJr/kFpOyC3umgbDDYBLKIkZbdKwAYrPi/duKhGUpKEOlsgn7inAJFinVAzX2N6FSTDPG8mBV0OZPvVQ+zIUroUtuGC6OVEAXnZUWWiJdXzjiD6AsYh/yfwiWT9h4Nk9QJ1ID1eckbtJ3RxnsnbPDF/dg1yP+RB09/eoQ4xirXOT5mnUJcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+isonlRz9s1h+f1emnMlN3gOjhEbEkGs8OMwsclGd9I=;
 b=CEeTRutCXfeIiyZOodztDnnd9NDO0cvyI0jznqJP8PyC1vOTLy7L4HJ2K/WApdJtZXSkILa4g5buVkLbS02BmYFcbnmSm3aiCjs5bWQz7ofIgFct60+w6UTMYikQlklBaqnNUQPZhjdfLK9cW/Aw1H/iWF+7KYEkR3D9SGlj8E0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 17:45:20 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 17:45:20 +0000
Message-ID: <7c80c9c1-051c-4ba7-bc4a-d4fce7b263e4@amd.com>
Date: Mon, 21 Sep 2026 12:45:18 -0500
User-Agent: Mozilla Thunderbird Beta
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v12 09/25] fs/resctrl: Remove redundant calls to
 resctrl_{alloc,mon}_capable()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-10-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-10-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0244.namprd03.prod.outlook.com
 (2603:10b6:610:e5::9) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: eff06af7-5768-4be6-b154-08df18081b4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|4143699003|5023799004|11063799006|921020|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SGgZ2pHej7E4JU0lUQeLX/lAoh+n30BR3iEqSyZ+rpar1piCOeSn/brmbkr+4gotAg53B6Yoht9Qx7ZOVhwx7m43UScsPUMjWcemMgzWYQTTWMwlD7FZPD/6IoEjjyGP0psaOm9D1mWYTE32/LA3DFizEjeUYLn87xNWo59OLfWyXk4CbMY4Y0bt3afIo3unGQ8tupQhV0Xt/Ql68czyvC1WYDxogPqqdam32jbvS/VvYNsOr2lyDmoKEynavY+nKtonydfQnGjdPUnoeFwBua4t9s6hi0kO6okSEQL15XTZDMhDdVgm1+hZEup1TMc3oA20DWBRH70arNGBStQrspF4BWpsBwylwnch3m5ERkAC/h7VfB8kffmHFGC6HVGz7IOELGv7XClyKlTWILDMO9vLHY/wWbvP0Rv4c8CzxIscEEEix+hqTlqMzUvjE5otauF9t+eD1LI8UT0mKpxXEuzTt8mbprGlG2bQvuHNUzANHpU11/S7QfxRObS0peYCg1ghUrPjHFtAVPi73k50lbkoDDpyKDIpkcwtnraErbW9rURZu8mDrhmt2eO9i24/TnGfiJ5eE/1IeYJOPUloETnyWZCSBQIh9lMYmB3hSHTiwHV/397piHslTlQBh0vWS0G0dcmpRB3z+glL0A1EhDxSPywKZcNnsnaPowYWjUhS51GIjJN0YgN71tBkMriO9H7hhqrIb8WCsdUrk/14zw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(5023799004)(11063799006)(921020)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFNreEtQbE83SzZpN3dkOFZTbytLaWFwQXhpamZ6d0NSM0hqVEhlcnhYdDhC?=
 =?utf-8?B?YnpTWm5ucGcvMm1IdEZ3aDJXeGhCcVlBSUJ3OFBVOS9mOWZpS1VWYURyRHZk?=
 =?utf-8?B?dHg5Q3JDY0NtNG4za1htSzhrazlOMFc0M0xVZ1YzQW1rVGpWTmhUK285dWtF?=
 =?utf-8?B?eERGRzFOTU90Qy8wa2dSQmVGUm9qalE0NTRXam1aL1lrNjJpaURHRlAzb1BI?=
 =?utf-8?B?YnJKNG9rMzZmejEvM00yeWo4aUJlYjEyaUNqUEpUWnJlYkZST0RHNVpzc1ZT?=
 =?utf-8?B?TllqamVTYmFIbDhxZFdTQTBzWGxmcFN4NHJnNWJCdVYvMDQ0MUhCOUltWElU?=
 =?utf-8?B?YXcrV24vNG1FZnpDSFdNMmtZcHlXZjE2ckZSaUhFUHFjVnIrbHB0a3c1d0Jt?=
 =?utf-8?B?bUxnYjFnT1NtM29PcVhNa1RUQldEV1hwallJcTV0UmtkbnhRUFRIUndxY0dL?=
 =?utf-8?B?UXAwUUtDK0tHMExjWCtTZGhlNVNhdGNYa0JLNUxkVCtCTHZGaGJMa3J5dDJT?=
 =?utf-8?B?SzdvbWpLVWdtUnRsUTNxdlNFWll4bnVUWXRJWTcrdDZ6VDFDL0pBdldER3Jj?=
 =?utf-8?B?VHBjSGQzc3hQZFZqVkJnVkRTc0pwOWNmcUlrUWI4Qi9jb2JDVFg4a0JtU3gv?=
 =?utf-8?B?cWRSWVptMnVJRTNrTndCME5QNjhoWElwYjNsV1JlMXVIZHNoeGlHUkwwdElQ?=
 =?utf-8?B?VllKUk9EeE10ZVJyZG1QbmtiN3pTRG4zU3NOSDVoMStoaFlYcGdWS0pnaVBq?=
 =?utf-8?B?T2p1Nm9TcEpLbmw3VDgrUFZkWVJ5R21kdDdRc0ZGQndWZW0zMnFiTlVQTzZS?=
 =?utf-8?B?enRBeTY1UUFFOGZkMlQ5YjE3RlR4RDJKTjRkSko1NytqMEhkQzhlQjc1OE0z?=
 =?utf-8?B?c3QrZHdWcWN1ZTZLSXFmdk44MHZEaXhlWU5qaVRRRmozRzZuV09ocndUMjdO?=
 =?utf-8?B?Y3prRlJUdWhzWUV2ekQzRlFISzhEUWJjWWRxN2I5QTZXdUpQUklzNEhPcXVE?=
 =?utf-8?B?TkJmZmNHaGJ0cjhIaXQxWG1HUllkSU9lV0dOMzJIYi9Ea2tHU3BZNWxRWjBu?=
 =?utf-8?B?WlVPc05ObXFRcHBUemR6RVNLNDZ6NGgwVUtNMUQ0ZStZb1RnNG13L1M2OGQ3?=
 =?utf-8?B?YlZtOG1SYUZGUmJZZHFVLzVLM3g1M1F3cUp6ZDAxbEhpSUpwcXdxaVZGbjh5?=
 =?utf-8?B?R05RZnQ5Qnp1aVhUemVrTm5qRE4zNEdyMkNMYm1DVzZyWWQrejNsajN1VVZS?=
 =?utf-8?B?RzRkMXdjWEg4WHdUbVJxSlpBcW9vOHNQRXkrTXk5WjkvdHZuSE5oc1F5ZG10?=
 =?utf-8?B?UG11Q3lvbm05VklTQW0vZEhSRWRXRUpEakpDZVM4MXpVbThhMTdFTEdpSzlD?=
 =?utf-8?B?d0JMdEs0NjgvSXZJUjdKaDNBK1ZpUkNObkJZWUpUWmN3NktUcHQ0RGhiSFh3?=
 =?utf-8?B?NWlCNUhIbXY1N0t0b09BcWcxMEQ3aGNyajBMY0VkSDhsM203b0E3T0dheGFX?=
 =?utf-8?B?bGtTRFJmQXVyVGM0dlpickVJc2k3MTJmVUlMelpGcUcyaTBEM1FHYnk1OStY?=
 =?utf-8?B?blVTWHBGRmtBbStnRXE4SzY0aTRERzI5NlZVQ1c2RGNUcVJteUR1Vmh1dHNn?=
 =?utf-8?B?Q001U1laYTRnRStwWmZZZHR6QnAzY2hkTGJXVE5CMVhvR09TaDhBMWtBKys2?=
 =?utf-8?B?UXdoQUN0MGtwSjRtRlkwTnFTOTFVQVlwaWRqSVA0c0ZHYWwyV2g0WDBpYkhl?=
 =?utf-8?B?YTR3SkdLQkRPODA0bkxiTFFPZFJtbzlheWg2b3E0K3dhRkwvNHI5RSt2blQr?=
 =?utf-8?B?TWZHWk5qNkZINUY1QzVaUGFtdW4zVWhkK01sUnMyRVMzMFViK0dhK28vTlBW?=
 =?utf-8?B?OTJRN2owSUtpeERGQnZCYzJwWHhtTXJRVWFnb0hQRzQ2R2ovdXZVZVlXRUcx?=
 =?utf-8?B?d2FWK2dWSk1VcTFDTlA4OHZhbS8raDM2ckhnSHhySWtyOHQ3OXlXMmgvY29k?=
 =?utf-8?B?MUNyWHRObWgxTHp3cStXbFRmUlhTdzQzZXhZcnphMkJpVVprV3pZRHJOZkdt?=
 =?utf-8?B?NnV5b1Qrcnk0NEgwanJVNkNpZlgxMkNrUVJoWXN3TWtjWWc0OFBDQ0tGWVNU?=
 =?utf-8?B?RVZyRGZOY00xcGhUdXlhZkcrb0cyUEF0MWRPeDVVa2V5N1h3QUJyb0h6SUV5?=
 =?utf-8?B?SEsxTmlXUmw4UXp1cml2RW94dW1Kc0dZaTNaSXZDUmdHSnRXYTNYT0pwRFZk?=
 =?utf-8?B?dHdnNDR6cDJHODJUcDJDbmlNNFAza2JoblRLUUt4NTFxK01aeTNVQVFROHhB?=
 =?utf-8?Q?nxDD4MHGIaMHydHcw8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff06af7-5768-4be6-b154-08df18081b4b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 17:45:20.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eK28GxldnFVDj1EQQX3NsYghEH4dm/adPFjvkDSu258ZTU1XBITvIDHSapRGbHx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651

Hi Tony,

On 9/16/26 18:13, Tony Luck wrote:
> resctrl_mon_capable() indicates whether any monitoring resources
> are enabled on the system. It does this by scanning all resources.
> 
> Redundant calls to resctrl_mon_capable() in hot code paths should
> be eliminated. There are two prime examples:

two -> three ?

Thanks
Babu


