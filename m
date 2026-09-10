Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDE361977
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013270; cv=fail; b=ix69/lDi+Ze6mIOFYgPWF2hpDPeHloxEw9Ssx9xfK9qAYcaCHbNHXVacg6bdZhiK7zWfpyGZFiafc+OkpYgE/sGq4u59pTWm0TI76wg3TULuBSNkvBMDxB3nNSmYUxNWFVVeKlDAPm+SlvGG1f3rqYzlIkwXNoVNAG+yL1TR+Pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013270; c=relaxed/simple;
	bh=f4I+fAzpOScjK+ufheXg7f06/c6/y1dibc3qFiO+Dqs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XTbgRlYFRevLl+aSiCKsSYnbB2YhEYAcnGuGJ5HsTypgaJI4hR14C+btpDyMCJPtKnPmB8xnCerxL/4btzdEsLp21VBvPef1Ljhnbjk2awfzKq0RqheD0hGGs7L4DPJdEULXfZ2CMff86Q5m357ucHWUHgi+A+77fr6dxtDjAmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EpjvRPU5; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EpjvRPU5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013268; x=1820549268;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f4I+fAzpOScjK+ufheXg7f06/c6/y1dibc3qFiO+Dqs=;
  b=EpjvRPU5dJPSsSJkSqvRK2qvIELusEYL9uwn7pgljJU077jJyysENlsu
   EuHXO64eS4PWI7qdO/F4tMaY/s8xkNLXMdwobLkqSAvwinRRJjvlfg7Mp
   wCXLAC0YHX7UChQa8iGkix4C/GnMQ3zhWsPVJUCE7R4sxRj/77yQ1MLSC
   6pmwMoL683lkFATKrN2t3t2EAoe8L2AXXJ20I9wgMKlYg/E3DWSfDoj31
   OfncfWAYT0N0GaAg/2eCeuWPjfOjIaGByRG+yLc1n8bip4PQTLuvF+8Yj
   Hi1lisce0BJQ8/U5JI9J3Rohhm5fdlgnfW3gkLq9kR3HAQkDJ28MBl6QW
   g==;
X-CSE-ConnectionGUID: IBJGax3KSt+ZQldL3gQruQ==
X-CSE-MsgGUID: aE3bZ2K3Ta2qWR2bqHZLXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="77012221"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="77012221"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:07:47 -0700
X-CSE-ConnectionGUID: O+UYUu8FQnavOeFV8JuD9Q==
X-CSE-MsgGUID: zAjco/FfQKi0MTrH5gDa/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="269747645"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:07:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:07:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:07:46 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.16) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iEVleuNY9AHfxJ2FzyIImURz94qEadNRdHo5qo/K7qxsxXyRxxaGFdB+Z8fhN6S3dkFNuj+b+s4kv7LLTlzZOEWgQ+uy7GdjJ+P3B26N873X4XwSGgQ2htPyObZj4dscMIiCmHQ1y9pxUdMvxcWjeXgCR+jD9HQUQKi68L/VNeMhRDwtXyOV7wEWhXSR6+QIkJ6jpe7sQtKfrkk37HaU8T6B+qfdSXN9lgF0hMQHQlzjVdq051aGSoV7MxtzZQ2yPgByS+1eAHMSjPP0R3Gk2F8aXce2+fz1HMarWNnPpU2zBxyO0F+2IFkwoFn0xMq/MH2VTyvkBoV1Afje5XYXpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdp/jYWPJaCbbZZS9ZlVQ+7JzrIUCLxwH3Bjgjgw5iw=;
 b=vJx4zRGfqTpNIpHrAD9Lfgek6gjGtN3kJw0xj44TpXrOkmjemeXx8rZOlCj2/w+kDQNX0d4GvzGMQ0qYJjrPv9bf1fT1D1Zo7xKdGagJvV4v0JWc3EV5czUMkn4jiWhK05oGzsmABAlnT9B3PIjxqkAqEQm3uFmtgDWfT2TCnsF96s/Xb/d2ndV3EiDN/KS0xM/dKMtdKiqtiYTX2dwvaGqtekBjghqgWUf6HOghsvjljExONQMYfdSXY7s2vcgP8pnsM8CFtlz8n9UgzwHRvHJ3Nj245BLN0Z9sWYKDKgYKQmCwXaiDdKd01Zj1dACfqF4ahRvDY3YkjgfiF6y8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:07:38 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:07:38 +0000
Message-ID: <3e81402c-902b-4499-8358-26077a8535ee@intel.com>
Date: Wed, 9 Sep 2026 21:07:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/23] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:303:8e::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: a23a6d1a-e7b9-4dcd-d93a-08df0ef10d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|6133799003|22082099003|11063799006|56012099006|5023799004|18002099003|921020;
X-Microsoft-Antispam-Message-Info: Ugv4ky4bZtnSUtEjMGjWH8RmiiTf7B6yMI9PCeZwQLlrR9tnY4V7U26sapXeHUvx1/ZCZgzPnEg1qoxr0Nh16GXiMXdCr/Hw1s0XKpa2z+FeQS7ImB8UdtADbV9ArS3Y8ezKBIYhvv/iBbh/o0dQTh1KELMc5lzAIXWbOSQ+gTlVYsZPFDTLXHRHPJ1qf37COjnFmQ/sSlrJl7Pc+iF5p83q23HnYINZ6ZaJ2tELJlOC6Aie1Nub8rXwyWpcQ1jQtJniUsI3nr7iDD+gMFgdG/zCjhyqmWeIZkiLzPqXS6Cljr34n0Gc+ewjc7hW9EnW7rbxxOIXxDmL6fpefmZnyW+Cpw0AxnkmrC+uaiDvrF54W1s2ad3ZwOBeqquA1KQ07sFaBZpK2+Fnj+o9uE88s1aAxCgXas3LAP1VNXP5EMgNdMdRFm2+NozkTYWE9trSo2Of52hX16kzLebl+DZOn5UAJ5y8bIyOnIbJhKC2kC9mEeZgNq8UQcq7UvmsWDNRlik/Kf16BPXLr+k2i6ZlT4Q2PEYC2OcQ07FQHShrBX7QhsOUg5Xtm0RkKZHHScU1zHiYHSWVExHpRq7pwA8O1aEP2YkvZr+2eg2WI6pEijWlvfW4Qo2EXUjk7J3bL3iVST9AdWLARVRRDneNX4/IY7jQqQknI42WzigagZCXX5UQhHX8tN8+MRneGfr9UB9GVtV3w1EbnvVNWX5G75ubPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(5023799004)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEYxTm91VDhmOVZQYVNZVTczcjhMRE4yVVlrQ0lYYkVMbVg1VUVWMGF2enNk?=
 =?utf-8?B?VEl5ZjhXS3ExODFaMlpOb1VCbi82eEhad1Z3Nlo2V01DVENZSGc3OXdDdW9P?=
 =?utf-8?B?OGs5TURGRjNzV1ZZcDd5b1Q3bUxSbllId3RZZFpwa3gwRndUQkU5VG5pVDQ0?=
 =?utf-8?B?RVRzVTlxL0poQ25vY3V4Q05FMjRVbTFqWHhpRlRDNjFqME4ydkZHQ3R4NXhN?=
 =?utf-8?B?OHJvV0lWTDNjTCt0aVFYdWJSeGw2dzE0cFNLaWZWeC9WMTEwT0pybkR1ZHB2?=
 =?utf-8?B?ZFpCOXNZd3NMVFRNdTJNM2d2KzkwcEJwVFRua3Rlc1VjK2ZLc2U1Qm96MzdW?=
 =?utf-8?B?S1VOZ0ZLNVRlSXdPNS9OeElJRkxKRlpEWGVvSDVQOEFpSE1iMGN3czJzaDlM?=
 =?utf-8?B?YmhuSi8rTVZQNDExeDNlQnRsV1paYWlRZjc5WGw0RThOb2FqcSt4aGE5QmRm?=
 =?utf-8?B?cWNwWTJTZStJc2VBTGorbU9veTNWdUxxQ1BWL3RiT0JER3FUb0NGRkZ3U3BL?=
 =?utf-8?B?bjNDaDlQN2k3Z1B1QW5RbVE1cU9JQ2dTYndyOUFKVEt4RnQ5cDRFS2VId0pK?=
 =?utf-8?B?Q1MvUlBELzdkYW1DWUFyait1cWt3bGVDM0plbmNLc3NHSExacXNVczJDZWRN?=
 =?utf-8?B?eWJrYkllSFgzQXZBV3J6NVVVVXdRUlhXN1Bwb2pnV0EzZmxSR0ZSRi8wZGJV?=
 =?utf-8?B?UVZpSHV4K1FxZmhZYm04WFhET1JxN256eGZkTEw1NjRqZGlXUzR4akFYUHht?=
 =?utf-8?B?bUpUVlNva3ZoSW1yN3ZVbXR4ajVNeEJoakdvU1lLcW1XbWJXYXBsNkZmYWNP?=
 =?utf-8?B?MlJMU3JCMnJvRTdUVVNuOXdxbG1VWEwzdnFFb3pKQXJTeWl4OUZCWU1JUnE1?=
 =?utf-8?B?V2lTMGlibUcxK00zZVBhaWJSZlBOazArVmlGT3Baeit6WlhZbkdJWDBYK2Uv?=
 =?utf-8?B?RFFVdGJsTWNRR2xyNFBFZnVzWmFvazZPbU9zRWxGb2ZMNVZhRmpHYnpmUHcz?=
 =?utf-8?B?R0xsTm9VRFJjd3pBMnU2M2VvbGNIRjVQWll4OFJPdHpIRTR6S2djTElUWHlt?=
 =?utf-8?B?eFNIZzk2ZS95V0xrOGJuNCtzZWJWZEVvWHdraE9JWkxFYnQ5NFVPSTQ2SmhM?=
 =?utf-8?B?QTZ6Zi8vaC91Qm13LzlMemZWR0g2cElRSmZ6cXRBcUZLME5KeXdYcnpLa1du?=
 =?utf-8?B?ZjlvTnU4RjdoQ2hwMTJWS0N4YjRUR29vbTZWdkdHZEd6ODJLMlprbkZzaDhm?=
 =?utf-8?B?NUx0YmU0MHM0aXNJbjEzTlVQUE9PUHR6cmlCdUtHTVBTWDM0cEQvWHlNMU93?=
 =?utf-8?B?LzlkYU5NUXVzNEdnUXg5R1ZLNTFEOHRGVHJyWXF4RjRBVTRSemorWGNZVllK?=
 =?utf-8?B?eTlkTXRBZ216aFZWVVBkbXpnUVl2bTd3N1dSWFA2V0NyQ3hLeVZRb0JoV0VE?=
 =?utf-8?B?cm96TXJva1pGRlkxcUwrbnExWXdHK1VKa3dlODJSZzlCNjErMVlrTk9QaU5O?=
 =?utf-8?B?OFpadTdnOEZGZC9HMUV4dG5VTTZOci9zckVnSDZ2WkVRTWw4Znc2VHc2dXh4?=
 =?utf-8?B?MGgzNnpMZkd3Y1phUzBmME13dzFqSXJhbXQ1dGhTbkJWUzdmVWh2Y1Nscks1?=
 =?utf-8?B?T1hJdldWcHZWUmxvbFREWmNER0ppRFkybzZCZm1PMzhtMnlvNHJXTWd0OEtu?=
 =?utf-8?B?d0NkMnlOUnhZc0xxSFZvWkQ1Qm9ZYytKTE5hNXV0cjRVRTlZRDM3dXNEcS91?=
 =?utf-8?B?NVhFSEE5eFI5RXFnQWdHUCtpOWxBN2FuMGJFUkJCV2lXeUhoT3FxYXJlbWlI?=
 =?utf-8?B?YVEzeWZuV01NeHdVQitEZnR2NGlyS2pTYzkveHI2ZVRIZkROV2NlZnNSWEVs?=
 =?utf-8?B?UDhKa1VxL3VhNS9SeFNqU0MvWE4raDUvdEN2clRKUFFvS0oxN010THJCclBU?=
 =?utf-8?B?b2dIRE5lODJZd2xiOHoyVlIra3JuSkZYUTZvWFp1cGVsdi9GNE1TLy9qdEtl?=
 =?utf-8?B?bkxGMjJxUnpiWjV4THlzc28rbDN4c0cyb2pmamNOSC9QMFQ0cXROR25rY0Nt?=
 =?utf-8?B?MEZGUnB2WjV2UmpRZTJTa2wybzk4NS9uMGQrd21OakNXOE5kZUdpK2lJZnFy?=
 =?utf-8?B?UW5vanQ3YnlRUFo5NDBPWjdOK0VqS05qUnlhSTVKSHBIVTUwcWpEQk1QU0NW?=
 =?utf-8?B?K25UR3laeVR0R29OYUpxNWwxbVI5WFBWT1hPSTdiUnpDR3E2dXlEclNsWkRZ?=
 =?utf-8?B?dTJxQitiMDhMQW9maWlZL0JnWUxpOTN0S3NNS0l3eFZyNjQ1VHI3SVk1WWxh?=
 =?utf-8?B?Z1pINnV1LzVGREpFeng3ZXoraXZyVlNUZEFOZ0JSWnNhWWxPTUw2UUVhSnJB?=
 =?utf-8?Q?y7cSnNekXRFfqXIw=3D?=
X-Exchange-RoutingPolicyChecked: fkuZnMIAmo80P6QNIJs85Ppj6BigBX0kpumUtyMLTCpWo5wG+RxOVtHcXgJrVzLd22tIEoeQlMt3kL9GoBbFKIulgmCe6tooqVHRhyn26ZjTPuSfjH2dsQKDWNwhAPJfl1QPOKzHJuiCatsbiHtYUosWN4SLpqiJB2qP9VTQCk+kLGVdUDY9DzN51ehL1CwkWZUusAcfcoljQOmvC0LYn1q37P8duQRMpL2jYaSn3V0fsP3DW01VAiEvacvivN82oXlIRAfj3KzP6BzZ0ftdTK78oSaGGhy4R84rxRs3Nvl9/G8xGWkdjZWT6+y1xH9bgxjCq2Ygwr6Ov0g5BTUTtg==
X-MS-Exchange-CrossTenant-Network-Message-Id: a23a6d1a-e7b9-4dcd-d93a-08df0ef10d16
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:07:38.0682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRlCc6f0VWTC9R+8m2PbIOIZUFvgRjV/MRLizisccwuTI2nbYgwjRySakLP12v49PxgWDYdf1TjOykfe9mpnfuEmIaqPWMN0e06t1bIZqHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
> logically independent and should be loadable modules.  Switch AET to use the
> function-pointer registration API instead of direct link-time references to
> PMT symbols.
> 
> Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> the filesystem is not mounted.
> 
> intel_aet_exit() was never called because resctrl is built into the kernel. All
> cleanup is now handled in the unmount path. Remove intel_aet_exit().
> 
> Note that the Linux file system code does not serialize calls to
> fs_context_operations::get_tree(), so there may be arbitrarily many parallel
> calls if users invoke mount(2) multiple times.
> 
> Zero rdt_resource::resctrl_mon::num_rmid for RDT_RESOURCE_PERF_PKG so
> that it will be re-computed next mount.
> 
> event_group::num_rmid may be reset (reduced) during enumeration. This is
> not worth resetting on unmount because the same reduction would occur on
> each subsequent mount.
> 
> Place a hold on the pmt_telemetry while enumerating AET events during

"on the pmt_telemetry" -> "on the pmt_telemetry module"?

> pre-mount processing. Release the hold if no events were enabled.
> Otherwise keep the hold until the resctrl file system is unmounted.

Same comment as previous version: this "hold" is asymmetric in this patch since
the unmount code is introduced here, but never called. Could you please describe
in changelog why this is ok?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Drop unneeded include of <linux/cleanup.h> from core.c
> 	Comment on data protected by  aet_register_lock
> 	Add commit comment on module{get,put} activity
> 
>  include/linux/resctrl.h                 |  6 +++

This change implies fs/resctrl is needed in subject prefix also.

>  arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++--
>  arch/x86/kernel/cpu/resctrl/core.c      | 24 ++++++++--
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 62 ++++++++++++++++++++++---
>  drivers/resctrl/mpam_resctrl.c          |  4 ++
>  5 files changed, 90 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 4fb06d434c85..0d7fd294b760 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -591,6 +591,12 @@ void resctrl_offline_cpu(unsigned int cpu);
>   */
>  void resctrl_arch_pre_mount(void);
>  
> +/*
> + * Architecture hook called when mount fails, or on unmount.
> + * No locks are held.
> + */
> +void resctrl_arch_unmount(void);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 27dc27480f6e..4409ee20474d 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -234,17 +234,17 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> -bool intel_aet_get_events(void);
>  void __init intel_aet_init(void);
> -void __exit intel_aet_exit(void);
> +bool intel_aet_pre_mount(void);
> +void intel_aet_unmount(void);
>  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
>  bool intel_handle_aet_option(bool force_off, char *tok);
>  #else
> -static inline bool intel_aet_get_events(void) { return false; }
>  static inline void intel_aet_init(void) { }
> -static inline void __exit intel_aet_exit(void) { }
> +static inline bool intel_aet_pre_mount(void) { return false; }
> +static inline void intel_aet_unmount(void) { }
>  static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>  {
>  	return -EINVAL;
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 8b763cf638ef..cdcc5611345f 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -20,6 +20,7 @@
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/mutex.h>
>  
>  #include <asm/cpu_device_id.h>
>  #include <asm/cpuid/api.h>
> @@ -800,7 +801,7 @@ void resctrl_arch_pre_mount(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int cpu;
>  
> -	if (!intel_aet_get_events())
> +	if (!intel_aet_pre_mount())
>  		return;
>  
>  	/*
> @@ -816,6 +817,25 @@ void resctrl_arch_pre_mount(void)
>  	cpus_read_unlock();
>  }
>  
> +void resctrl_arch_unmount(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	int cpu;
> +
> +	if (!r->mon_capable)
> +		return;

Since resctrl_arch_unmount() is introduced but not called it is difficult to reason about
the safety of r->mon_capable accessed here without, what appears to be, any locks held. 

> +
> +	intel_aet_unmount();
> +
> +	cpus_read_lock();
> +	mutex_lock(&domain_list_lock);
> +	for_each_online_cpu(cpu)
> +		domain_remove_cpu_mon(cpu, r);
> +	r->mon_capable = false;
> +	mutex_unlock(&domain_list_lock);
> +	cpus_read_unlock();
> +}
> +
>  enum {
>  	RDT_FLAG_CMT,
>  	RDT_FLAG_MBM_TOTAL,
> @@ -1160,8 +1180,6 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> -	intel_aet_exit();
> -
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index f5007bea8346..c3bd3536c514 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -12,6 +12,7 @@
>  #define pr_fmt(fmt)   "resctrl: " fmt
>  
>  #include <linux/bits.h>
> +#include <linux/cleanup.h>
>  #include <linux/compiler_types.h>
>  #include <linux/container_of.h>
>  #include <linux/cpumask.h>
> @@ -25,6 +26,7 @@
>  #include <linux/io.h>
>  #include <linux/minmax.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
> @@ -293,10 +295,22 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
>  	return FEATURE_INVALID;
>  }
>  
> +/*
> + * Protects pmt_module, get_feature, put_feature against races between module
> + * load/unload of the pmt_telemetry module and mount/unmount of the resctrl
> + * file system. Also protects pmt_in_use.

Thank you for adding this. This accurately reflects what aet_register_lock protects
in *this* patch. aet_register_lock protects more as this series progresses from here,
could you please update this text as this mutex protects more and more?

> + */
> +static DEFINE_MUTEX(aet_register_lock);
> +
>  static struct module *pmt_module;
>  static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
>  static void (*put_feature)(struct pmt_feature_group *p);
>  
Reinette

