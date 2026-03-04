Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165A932A3EC
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772637519; cv=fail; b=oDaPb5KFWCMc6CxhF+fw8ri2RlAMt8CjoBcb57jPqitaca5w8qHEt9t8fEJD8zTNNK7e7hNs/kQ8UvyVdaA05s93YyU/Ff8CspSkw4zFlvmdWdxNA9jkjCPSep98+I6F6T6VBBR4IEMcdgpU8PfM+aIedaTsSMOmQjtIh6H8ovo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772637519; c=relaxed/simple;
	bh=lyjWuP00WqMvBORFbx6Gm1NJwogOVsxPkoBrLixPb9k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fPLyv544QQK6Fs6Av843ud24NYmtEvrAqatopvUrcUJJhTIbqr57mridCx6oanpbvzIsgf09TIk/eqvc//kBF5+X9zSJi2IEPJbdr1OgTW4L6UDFEYuOigLPW7U3RJQcN6c3C3AaazHYz8PsYPrnB/hnBoofZ+Piq7k0V5sl46o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nw6SZPiq; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nw6SZPiq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772637517; x=1804173517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lyjWuP00WqMvBORFbx6Gm1NJwogOVsxPkoBrLixPb9k=;
  b=nw6SZPiq52Mvjplp/Y7Wvl3h0wEmXDZFTSanx9aeFvlrMwqeYUJtcAWz
   v6Q5mp/oTxYw8//Bz5Eh+lvHUGsyNOMCGKJ1qSXtwEAHog5iC7ilcWOQo
   KhBaG7g8V0I1VM2L5Que1BJv4whbXzy8Kw6w7yqad2nx/HVhqzCu85FMr
   gYW0WAQ5KoZqDhzgJAFy9htkUPNIdsYYYWAIlP03DfWM6hasPIMloPga/
   PmlP3gDkt17prP5SSLSypzI6UrAkLQR5yhaLhDqQSwCOFWYjLtq6cuAWs
   kl2sAspZREWDpmyI8TqbTO8EJXmOeXu0VwuRCyW1JPEXg3UHBOu0jE/d0
   Q==;
X-CSE-ConnectionGUID: Zbs4a6fZStOPvCSaFzKEuA==
X-CSE-MsgGUID: 7zI9Ans5RDOzdmm5caONAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="77571183"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="77571183"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 07:18:36 -0800
X-CSE-ConnectionGUID: 1aMdJKvaQuySNxuhrL99og==
X-CSE-MsgGUID: ReLwVqkCQUungqfUStH3tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="215302963"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 07:18:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 07:18:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 07:18:35 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.38)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 07:18:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MaORRHkfhvEI01ZTsxcxeUm+SkikO2WWleJGD4glqadOze4rH7s8fGLjNmXsEp+tYSNKf2/iqx58Rwx9jI6Ezj1BXgQFoka6S+n72wPoqU5t3tvrdlnecdL/3xt1fHyCETwUiqV2H3V5AyVLvZDk2Pm20cVUcz4L9HGyBw9c1Iv3TsLUahi+6cSU5UZYmWRNdEcDFBVKXpOXFpt8RcEa1/39MgItvUrbde6cXhpAvz6Arv3JumA8Tmu5l837LOidQdTmJk3pXoB0bD/9C3w0A7UQyUFeInBIlWiz2QjXBV/gCdJQYD4z8Rq5J1nD04sxWkX36AO3JD/8npzN32Y0Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CA2RIwvQGQQ+w9AGErbvrCc4BrO7TEEJ9Zn9gbxr+nw=;
 b=sE9+8Jt89z/XlI4R1I4v71uRSAERJTU2vpPicdu/zpEFqNf5mYA3fRyt7QOpng1eRzWLNx6sWMbkTOVUzVkWu1pbVPPJSFezlo4QvYwF6fPWpJbHcyHLV37Or7Iz9r58TIzicnuRKt5zb3e3eHklTVA40vy4rHnsfLtJEL2O0c3cx0psG8Pp2471H6BbiFFZJ6RApGATrp4SeF/hh7HE86ljY+B+vkapIn5uirDL3vApZ1C/gqYpJerWJ2d1DFk4vK1zQOOJTuh2nHEEB5GHIFfpB1OyXi8AXEuswKFbfv3HVn3JhtkZ3W4PV4C1voeBL8kppvU4/1dXi7F48nN5cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA4PR11MB8990.namprd11.prod.outlook.com (2603:10b6:208:56b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 15:18:32 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 15:18:32 +0000
Message-ID: <4b6cd592-ab84-4dcb-ab86-ecb1be3482c7@intel.com>
Date: Wed, 4 Mar 2026 23:18:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] selftests/resctrl: Fixes and improvements focused
 on Intel platforms
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <fenghuay@nvidia.com>, <peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <shuah@kernel.org>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <babu.moger@amd.com>, <ilpo.jarvinen@linux.intel.com>,
	<tony.luck@intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <cover.1772582958.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::36)
 To DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA4PR11MB8990:EE_
X-MS-Office365-Filtering-Correlation-Id: 1be7e51a-5d34-4ade-a210-08de7a014b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: uQMH6kBv+fCn1ooiI7Ju3cWaOBorRvcUPa/Mv3LaoT2Gcut6HqcjEeR6HKV+vmNPJ/5f7Uv2AWQL9MAXXSSCuf/uvDJT+RLy4zp4rqHkQfO8WFtg81zgVhkaUYot/xum/BVSMntRjNANZh1EgfhgKkww1fe0aeiXq1x04ewkYoKM3I8tNALGbadrojnsGSGk5OwU6cqaOFAEwv3MMmUWVEh5xsp3oJ3loNqAlSWWy3hTF2WZhsQN+ifDCwdrf/WheLVjSo7X9vbmrjL86muGASjgME1VPFAzLQBuvjLyv+xAyz70RlQtdOaJ8647DNH9s7IQUGK3uqaHykUaJ4fv+hdGm1cVW7MQRXIE+0cC30wmerlqnAbldPrOKCWfFHV3+fNxnhZmIRmBe5RuPcZkKPH4RXPRmEELJy8EtdcvR30t7YR0S2csCEdtPZv6Uof0tFdEBg8o9KFAdl4096cKfq2FbRbyrsTQDpmL3nY4koYecPc8n9efi6gXtlTg7B5y26pcKCuGj2jWA0AMdr2J5uIdvyNQCiyi5T5ASr1+8Th2ASZetZa8brZfIyt5nWeSXpYQcKXv4cUpd7ZgsCck8U0sSVDJSDhg2rSe70qS8YfRx4wxhNrG/OiCngdPVq0kAVT+Xialyir9MP2coZbAU2UNRqPjf4AYmy+53H7eH8lKyvQ/pNXFHFtEehmM7n0FFj+MWummhwr+PnMJOAyfHT/UN7ekmPxuVWYgAhPWIEoTGQsFptkXOLC6gqR3cn2m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2o2UVVxdGxXVFdUaFAvbkVjL3RJM00wY3hjYzgxR3RqL3B6eWJrMlB2T00v?=
 =?utf-8?B?QVBrMCtEUlZWNXpRTWNkaHJiWkxCQXRuM2JLOVVTOVNkKzN6MWR1MDFWNlpr?=
 =?utf-8?B?L0JJUVIvdCtNalVJYWl6MnlKcTNRUE5yaXVZdXo5Ykd5Z3AzNnNhYVJ1R0FW?=
 =?utf-8?B?YUUzQ25kaVRqMjBMeUwyejNLNUdLYUVlYUJBRW5HTVNYbndtSVp1Zll6OW1s?=
 =?utf-8?B?OHQ5b3JjRGpnVlhlUXB0dFVuRzNpVjk0clJCbUhzOStya3RnS1pKRTBLV3Np?=
 =?utf-8?B?Nit4eWdLMW9rOTM4YjJiVHpRYUtONGxPc082R3FCOTdnMU1aRlpFdnViV3RE?=
 =?utf-8?B?YzRSS1p4RENnWHNQRDJwVTVrR1pJdkhMTlZzWis0ZnRWd01nOGxQNEU1NEF3?=
 =?utf-8?B?cDhyaVdnSTFYRy9jSWNPbVBuYjZ2NmFzeTJ3OFgyMVoyNUZYQ1JjVmxXN2hm?=
 =?utf-8?B?WVl0aDNSMVNUZU1wN21pVDFBamdLU0R3L0d5RDZCRkdGb3BkTCtqbWw3R1py?=
 =?utf-8?B?Qk0yOUE3Z3J3V21lUlgvVXRLak1Gd3ZDVnZOam81RmRtenlxRytEbFFyOWlI?=
 =?utf-8?B?NFhiK2NrWDVKVExobEZ6Qlc5K29KWjVIdW1KV1JFdFoxTUpmWmFEUU8vV0RX?=
 =?utf-8?B?SXZSaC9pY25Oa012TGFrYnV5Sm1WcGprU2hUaDhCSmdSRVZtQWZEZ3paWG5p?=
 =?utf-8?B?alk5ZjY0ZFVXc2VHLzgya0x5TWdYUDhNSE1rWHV6QUxoMzkxWFZ2M3RSdzUx?=
 =?utf-8?B?ZXVMamVyalFkRmhLd1VGRk5YWVMvVUNBU3F0SzFVeElZRnZibWdNMFNSMzFZ?=
 =?utf-8?B?VGE2cHZkVGNPc0VGM3N1QVZDYWE0T1hkZi9VRHE4MXkwM3BjUTREL2RIVDN1?=
 =?utf-8?B?QnZqb0pGZ3E4bUhaRnE3b1liY0wvTlo4WUE2WmlKWmVERk1mUFg1aVk5SGEy?=
 =?utf-8?B?L1hsWDc0bUxnejdjRWxrTU42RitWM21tdEZzVmJQeUNWTG9kaW5TRGtGZ1pi?=
 =?utf-8?B?RHBPSk5nUVg1VzB5WmVTNW93S2VyK0xmN2lIRVJpZzE4a1g0UG8xUGhuYU10?=
 =?utf-8?B?bkYzZEVZRFpaUkttUTZjcGE5d2FROFhhWURzRk1Hb2NCT0tzQ3V0UkFXUThI?=
 =?utf-8?B?MlE2dzQzcTRnUEdGK2h5OElZMUhSVUE4YTBoR0psOTZkYXQ0N0ZsVXFaL0Zv?=
 =?utf-8?B?THd5QjF2cENVd1NMSGNibStpVGV5eUlsTDlDeGw1dnRGRkVRYThGek9taHZo?=
 =?utf-8?B?QlFuR1d2SWtwWVlNanNFKzRpckJ2WVVwWmVMc0picUE5MlVNdVZISHU5UHdk?=
 =?utf-8?B?bkxETFVETmY4WDNpTndDNWtFcHg1VEV0andGL0ZuL1huQnNJcC8yL3cxUFFr?=
 =?utf-8?B?aHlSaVhFaUdlL2lLUXZJU1NpaVA5eElBMXlYSjQwTjBjbnRlMktKdndwMU9h?=
 =?utf-8?B?THdnV3VoWlBISjg3d0RUNytJWFFRZC9MUDNaUTZsUUs2NVJ6Z2xuTEMwdmxs?=
 =?utf-8?B?ZWZNRUZucVFQUzM4djZ2WEljbm1EQ1kra0g5RVprNWtxQTFmWVFUSWNQLzh0?=
 =?utf-8?B?MDl6b1ZnWkhPakRXSlBBOUk4Y25VS0FiVTExWEV6U0FFSDMxN0U1dUxOMTdB?=
 =?utf-8?B?SGwzektySWdiZ1NvYWpCbTQ5cmFDNThoRElFcE1MaUlIZU9yS0llNkQ4dWJo?=
 =?utf-8?B?NERJalFIdkQxbDk4amJ6KzkxNXhEVHZQdjBsSkx4aWlRRDdycktaWGg3S25C?=
 =?utf-8?B?UVdQNzZlVWdSaXVLbWdDMUt5aUlHemtOa05QNnVGZnpPQVpSQlNZUDdsZGZW?=
 =?utf-8?B?S0dkZHdIYWx1SkpXOUNsQzY3Q0lNWlg5NjlQYTRtYWk1cEJUNDgzcHdHdGtJ?=
 =?utf-8?B?a1VHTmt2UDc0QUxyV0RJSnN6VVp1ek1ZMUlNVlNjNFZjYWVGaDRCQm1yUUpV?=
 =?utf-8?B?dXVFSi9md1Rka1F1S2xkQ3VhdDhza01TTGFWeXkweU0xN2VWWGF5Ylo2Z2FE?=
 =?utf-8?B?Q3dpakJsYVNvSlFZSWRLVjRhTnNobnlENW9HSVFsbUNmYmdDWC9RUzMyWmxT?=
 =?utf-8?B?NTNicENRUFFsUk1RM0ZkWFBFMVdtZ0pObzZTMUJza08zVVFxa3FpNFdIY1ZS?=
 =?utf-8?B?bkhsbng3YnZqeXI1aEJ0NVF3M0FkUWd3VVNmOWUwaERHSkRESENqOHRDaW1l?=
 =?utf-8?B?UU5NN0xOUXh4UHBFbWNVOXZaY0lDcnZjTm82TCtRWWdEOVBCRHhFczlrUnJL?=
 =?utf-8?B?WjdLZ1BBNkFLSXc3b2RRZThDSjVxc1VDZ3BZUWlzNFpaR0pBamFHZ3RuMkp0?=
 =?utf-8?B?eFBzSzRkQWdQR0FGNnM1eHJWcHJSVVpWT0wyb21JUkxhMVB2d1VmZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be7e51a-5d34-4ade-a210-08de7a014b9b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 15:18:32.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCEY34MaGrLYqBTfKHOZmz6M0goLnMM5/posCVJ0wppJ8T+bF9Q46wBZLCUoa4HN8mr8H1GjjMdqWEi9Fa1/9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8990
X-OriginatorOrg: intel.com

On 3/4/2026 8:19 AM, Reinette Chatre wrote:
> Changes since v1:
> - The new perf interface that resctrl selftests can utilize has been accepted and
>    merged into v7.0-rc2. This series can thus now be considered for inclusion.
>    For reference,
>    commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
>    The resctrl selftest changes making use of the new perf interface are backward
>    compatible. The selftests do not require a v7.0-rc2 kernel to run but the
>    tests can only pass on recent Intel platforms running v7.0-rc2 or later.
> - Combine the two outstanding resctrl selftest submissions into one series
>    for easier tracking:
>    https://lore.kernel.org/lkml/084e82b5c29d75f16f24af8768d50d39ba0118a5.1769101788.git.reinette.chatre@intel.com/
>    https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
> - Fix typo in changelog of "selftests/resctrl: Improve accuracy of cache
>    occupancy test": "the data my be in L2" -> "the data my be in L2"
> - Add Zide Chen's RB tags.
> 
> Cover letter updated to be accurate wrt perf changes:
> 
> The resctrl selftests fail on recent Intel platforms. Intermittent failures
> in the CAT test and permanent failures of MBM and MBA tests on new platforms
> like Sierra Forest and Granite Rapids.
> 
> The MBM and MBA resctrl selftests both generate memory traffic and compare the
> memory bandwidth measurements between the iMC PMUs and MBM to determine pass or
> fail. Both these tests are failing on recent platforms like Sierra Forest and
> Granite Rapids that have two events that need to be read and combined
> for a total memory bandwidth count instead of the single event available on
> earlier platforms.
> 
> resctrl selftests prefer to obtain event details via sysfs instead of adding
> model specific details on which events to read. Enhancements to perf to expose
> the new event details are available since:
>   commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
> This series demonstrates use of the new sysfs interface to perf to
> obtain to obtain accurate iMC read memory bandwidth measurements.
> 
> An additional issue with all the tests is that these selftests are part
> performance tests and determine pass/fail on performance heuristics selected
> after running the tests on a variety of platforms. When new platforms
> arrive the previous heuristics may cause the tests to fail. These failures are
> not because of an issue with the resctrl subsystem the tests intend to test
> but because of the architectural changes in the new platforms.
> 
> Adapt the resctrl tests to not be as sensitive to architectural changes
> while adjusting the remaining heuristics to ensure tests pass on a variety
> of platforms. More details in individual patches.
> 
> Tested by running 100 iterations of all tests on Emerald Rapids, Granite
> Rapids, Sapphire Rapids, Ice Lake, Sierra Forest, and Broadwell.
> 

Tested on a GNR with SNC3, without this patch I saw MBM/MBA failures.
With this patch applied on v7.0-rc2, I did not see any errors:
  sudo ./resctrl_tests
TAP version 13
# Pass: Check kernel supports resctrl filesystem
# Pass: Check resctrl mountpoint "/sys/fs/resctrl" exists
# resctrl filesystem not mounted
# dmesg: [   16.192737] resctrl: Sub-NUMA Cluster mode detected with 3 
nodes per L3 cache
# dmesg: [   16.287785] resctrl: L3 allocation detected
# dmesg: [   16.287961] resctrl: L2 allocation detected
# dmesg: [   16.288093] resctrl: MB allocation detected
# dmesg: [   16.288186] resctrl: L3 monitoring detected
1..6
# SNC-3 mode discovered.
# Starting MBM test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Writing benchmark parameters to resctrl FS
# Benchmark PID: 5503
# Write schema "MB:0=100" to resctrl FS
# Checking for pass/fail
# Pass: Check MBM diff within 15%
# avg_diff_per: 2%
# Span (MB): 640
# avg_bw_imc: 8815
# avg_bw_resc: 8570
ok 1 MBM: test
# Starting MBA test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Writing benchmark parameters to resctrl FS
# Benchmark PID: 5506
# Write schema "MB:0=10" to resctrl FS
# Write schema "MB:0=20" to resctrl FS
# Write schema "MB:0=30" to resctrl FS
# Write schema "MB:0=40" to resctrl FS
# Write schema "MB:0=50" to resctrl FS
# Write schema "MB:0=60" to resctrl FS
# Write schema "MB:0=70" to resctrl FS
# Write schema "MB:0=80" to resctrl FS
# Write schema "MB:0=90" to resctrl FS
# Write schema "MB:0=100" to resctrl FS
# Results are displayed in (MB)
# Bandwidth below threshold (2500 MiB). Dropping results from MBA 
schemata 10.
# Bandwidth below threshold (2500 MiB). Dropping results from MBA 
schemata 20.
# Bandwidth below threshold (2500 MiB). Dropping results from MBA 
schemata 30.
# Bandwidth below threshold (2500 MiB). Dropping results from MBA 
schemata 40.
# Bandwidth below threshold (2500 MiB). Dropping results from MBA 
schemata 50.
# Pass: Check MBA diff within 15% for schemata 60
# avg_diff_per: 6%
# avg_bw_imc: 4669
# avg_bw_resc: 4355
# Pass: Check MBA diff within 15% for schemata 70
# avg_diff_per: 5%
# avg_bw_imc: 5556
# avg_bw_resc: 5231
# Pass: Check MBA diff within 15% for schemata 80
# avg_diff_per: 5%
# avg_bw_imc: 6257
# avg_bw_resc: 5942
# Pass: Check MBA diff within 15% for schemata 90
# avg_diff_per: 4%
# avg_bw_imc: 7126
# avg_bw_resc: 6804
# Pass: Check MBA diff within 15% for schemata 100
# avg_diff_per: 3%
# avg_bw_imc: 9246
# avg_bw_resc: 8901
# Pass: Check schemata change using MBA
ok 2 MBA: test
# Starting CMT test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Cache size :167772160
# Writing benchmark parameters to resctrl FS
# Write schema "L3:0=ffe0" to resctrl FS
# Write schema "L3:0=1f" to resctrl FS
# Write schema "L2:1=0x1" to resctrl FS
# Benchmark PID: 5508
# Checking for pass/fail
# Pass: Check cache miss rate within 15%
# Percent diff=0
# Number of bits: 5
# Average LLC val: 52264960
# Cache span (bytes): 52428800
ok 3 CMT: test
# Starting L3_CAT test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Cache size :167772160
# Writing benchmark parameters to resctrl FS
# Write schema "L2:1=0x1" to resctrl FS
# Write schema "L3:0=3f80" to resctrl FS
# Write schema "L3:0=7f" to resctrl FS
# Write schema "L3:0=3fe0" to resctrl FS
# Write schema "L3:0=1f" to resctrl FS
# Write schema "L3:0=3ff8" to resctrl FS
# Write schema "L3:0=7" to resctrl FS
# Write schema "L3:0=3ffe" to resctrl FS
# Write schema "L3:0=1" to resctrl FS
# Checking for pass/fail
# Number of bits: 7
# Average LLC val: 620490
# Cache span (lines): 1146880
# Pass: Check cache miss rate increased
# Number of bits: 5
# Average LLC val: 1149986
# Cache span (lines): 819200
# Pass: Check cache miss rate increased
# Number of bits: 3
# Average LLC val: 1604363
# Cache span (lines): 491520
# Pass: Check cache miss rate increased
# Number of bits: 1
# Average LLC val: 2285082
# Cache span (lines): 163840
ok 4 L3_CAT: test
# Starting L3_NONCONT_CAT test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Write schema "L3:0=ff" to resctrl FS
# Write schema "L3:0=fc3f" to resctrl FS
ok 5 L3_NONCONT_CAT: test
# Starting L2_NONCONT_CAT test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Write schema "L2:1=ff" to resctrl FS
# Write schema "L2:1=fc3f" to resctrl FS
ok 6 L2_NONCONT_CAT: test
# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0

Tested-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu

