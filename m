Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F26282F01
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 01:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014906; cv=fail; b=Jy8mxCCz5OEt049/wBhxeSDR+7yDSM4R6iUcyQPYnbuvDKjP+nI1v+3zuoJroJuq18UoVcX3iHe6Ow6G6jT60Nuyv2ahVrs6cIdswFKVklKFv2K2Sjy9qqrSWyu/E0sqADfMcTxoPRG4GdWpbs+bFoiVeWr4DdpcVioc8s4pDAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014906; c=relaxed/simple;
	bh=Jhe6vdzAa4g6x36qtHBRMzZlvjA+ZuZD5fFOj8Mq47U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u3hkTWBJLXtYGhOl5owVv2+fGkNHsWnmNN01PXe2CknL+pWWzMxd5guWPfUlVlZ6ZFLg1G+cWDHUgjgIbkWUqe7NQLQiT6GvhSxiaI2Zil741qIiAje/n8WSOsh0bTco+hACliCbDD1mTELTrAIKei522v0ai4SWN9n2znxgnnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m91OlGr4; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m91OlGr4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014905; x=1818550905;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jhe6vdzAa4g6x36qtHBRMzZlvjA+ZuZD5fFOj8Mq47U=;
  b=m91OlGr41hfVOo7J8wkvTqyQQSjejeMlkXdXkKlUFmA7NpQ7UhETFg6h
   tAxGjCgCdXC/TcK2KP2XMqYWnYqTVwmE3mBVkZ3cIV3QgWDfbS+foBpDh
   Q7iMgdnKEAX2UgVIau3iDgfEOhDZm+JEZ6kqvAw+xWLcy9QT6/m8/1Z7G
   OVpaRcESRhGtrWjNhg82WxwwOTlRs6KF3xDsxOdsAAET/eITOiO6sGT9h
   MHfOZaC3sXRnu2a0zlfWpgmb9Ha/r98MerzqXT7+phR2s4EzlUmOP2SoV
   VghGU2e9Hm5C5xJT01jS77uTT1F+alVJ8vQQKTU40g8dcfFe44eGP+sYn
   Q==;
X-CSE-ConnectionGUID: eoGDxVJnS5OvC3o/wVtIQQ==
X-CSE-MsgGUID: rqbfHqYLQKuvjrnK06PGyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98650213"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98650213"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 18:01:44 -0700
X-CSE-ConnectionGUID: 5woLtWeiQymhczmzKwjulw==
X-CSE-MsgGUID: PMpVwOYhRk+1Bk4fWJnbAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="261330502"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 18:01:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 18:01:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 18:01:42 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.53) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 18:01:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbcoQo3aGLprNVju9jZAJ+NTdhQIMdNZjPSEmbI/+l9HlH9mlf37U3SUYUZJ6oivSoDgQg4XKS5RjTlC3AaTnaUvEdi6ttwPZbHHK1BJbTo4Wa+VAVSv6b+7hbzQF+QhQ0me8SRfyHX0f3b9PrKmYwM5o2V30p+uosPuCSOYIrWEHIA4J/JJhleSzUNMWNWYUpk0Q9JrfDrM4941twCGQ0myaUQR/hf0hiWzqNPjazJWlOh+yeOvUqPH3R4F358+al5pu+N5EEhIxhNOG2hOu6dTZGTjO201BShhPMOAgK1vIF8NfA0llxMNprtW7zqRWx/3I3m6TsRl2Zr87HUazg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Cyfvw/4UZM6+pbPg7DdrAFr1lBX4Fbc+IBzXtQ29rs=;
 b=N+hTraqB868fD6c4L1ZTP6eWmnkC1wS1LLbH662lbkw+duJboYv/4awztGGY9gpa8sk5oofKd+8b+24pExIydsbsh8Qrs8TN/xzVzXGeWWsWQ7bhGbUPUQIPnvoDPJqZDyw3JGbtybQfpGQMKKm1vConVE7sDPHbozlbH976m4YERZ3fuh9CLFyRR8IeMHc20nGyMsJ5rX5ENJoXS3VYTC0dLRHf+yNbcBlqYaXOIPGN0V+E61+EbU57MZIEViimnG4iH+Oiu80h1Z1weE1pA++BvdiNSIy50kIMc6A6Bb4VXXqBoYx71MZgWs4laI5oOBbrZ59Tp4yvh8uHmO9Bog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 01:01:34 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 01:01:34 +0000
Message-ID: <8ec67bca-1f21-4489-8601-3dfd91aa5b2a@intel.com>
Date: Mon, 17 Aug 2026 18:01:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 12/17] x86/resctrl: Prepare to handle nested mount
 requests
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-13-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:303:83::7) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 8653ad6b-b6c1-4957-c71b-08defcc43fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info: BMTjpzvzofkyTWOJQye6Pggxp+nlHKLLjOaBs+nG4f20+XUYNx1/OhqBY1qpy63b4GmKLuYHGahUwj2iDnWu48Jo/uc7fojbOrBRySJUO0Qerk1FBMDfXfUI84AAehWVB/VX71AXunw/N9SSvcdojAL5SDJOAEQWJpU0uwnQ2r9t4q0NAeN8KGPRuNb9Wr3c3qJqXcyHD1mLQHTZ/ALCRyH2Cq6Wf3CszptDyEFJffwTT/UaxrLrI5eWusL3v57GR23IQenDxo8xGyNS7N9gn7A30eHAgMiGyBkavePb1VpTKrI0SA5t7qPfsctZ6nZxSAG9cWP8WkorRb/nFFOVgB1GUGM7Yl0L4NV1cig5muziS6it4EbmM6iUYNTKaefxSQsESARpVY6SsEzAS4LpBY/ixlx3SJx5XHR9yQ6A47MkQHp+F+he/a7isPHe6CVBHNzRnngSkQR3xboUYV/sePDgSnVvwk5/L4z5c65hjWch4EULTCzwIGg2ErMECQRFfTYvrFVqBc/FXbNPeeeqGr1xdiyxi7nnaSWK9y7HNqzKQjYs9aIbb435A8K1L01JgnE7ldM0VjzPaQeD3HpY7JDsNhooUTdAn5nFwp0abSSlVkbbK0C272q10Joej+3gOD7/mYBwt2wBYYZLi5MC/OLRR1lOkddv4x3r7vYIG6HrdTiD1R7LIKrzQHEc8WFilafKZlLkjB1wY9HJ5a/KNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjNFeFZ4V0VCaFcvNzk4Z1EzbzZNbnNvNmRpYXUxd2J6aG91aU9CTUpDaXpX?=
 =?utf-8?B?OWZkc1NDSXFMR3k1cnZYdVFTd0xOUUFSbjdUZm1IMXNyTlFUUGxrRHRTVEFl?=
 =?utf-8?B?Q1pYOEFReDRKK0w3UUFpMXRLWm5MdnZzejRDaXVUbE9SRDNIYk1oRy9zV2VF?=
 =?utf-8?B?TGtmdlFiVUFMZmcxZXBLaiszeGFwR3FiUzkyTUsyaTU5SmtEdFNyUk1WK0NS?=
 =?utf-8?B?amZoKzdxc1lGMERQTWhIYU0xdDVkcGxIcnFuR1BWOWZ4dld5N0RkTTJTSGJx?=
 =?utf-8?B?cTNoNWZuZCtwak5DaDcxNGhaSzdlLzRrQ05mYkVhRXAybmNXQ1A2VzBCcHBs?=
 =?utf-8?B?aHBXdGJXcjRWNlN6cXErSGliU0t4NFJMOEY3c0ZEZzFTTU9oL1R1azNOcFZP?=
 =?utf-8?B?VUIrMW93WjhzL25STCtUREFicmdNR3Q2NkhMRmdaVkVmYXQzVHhwNE5yK0RM?=
 =?utf-8?B?RUFLZkhxMU43ZFY3L3JtdE8wOTRmdzBrWVpIUVVZOC90Y2tJdnRIMTJ2amdk?=
 =?utf-8?B?ZkcvbS85YTJJWGlwbk9BT21PWE1pTTBneXl3ZCtRenhvRFByVExaSkpqY1hH?=
 =?utf-8?B?a0RjLzNKcnlMYzVSVGdNMVo4LzU0MWpCbVVPQ3FsYVJoc3NzdnBLMytYb0RW?=
 =?utf-8?B?a3ZYNGlDeGhuYjNYTDUzczhvZHVqTC9VNHU3dE51NmJRdGFCalFQWXBDT2cx?=
 =?utf-8?B?N285N3E3ZVY4S201SE1vdzEvUm05MzBJM1NVcGlqZ1cxYWJrRzVTUjhFQlBp?=
 =?utf-8?B?TWxCc2dqQklSTllzNzFzTGJuR29OcmtzVG5RQlpDWUtPMysxU3FxaVV0cTN6?=
 =?utf-8?B?REFtZFdEcS9OcEZxaXJpQlFycVMrenhESmJPT1RmOXE3T1o5Mm43R1ptQXBP?=
 =?utf-8?B?cDJxRzRWQ1RXeFZJbUxHRlBDMWRkb1U2cEN4bFlYaC9xREtjOG8xNEx3MVI5?=
 =?utf-8?B?T3cxbE54c2xNcEF5MS95QzNFRmxhMExxdU9hSVdSeG43L3pBajBXM2NyNmhh?=
 =?utf-8?B?L2NBdGhKZTFuUnphdXo1UUdId0JYcXJ5dWdzY2xBZEtEQmFNSHFzdU5qZ0Fu?=
 =?utf-8?B?eGJ5QzB2K3pVUTdPYmlDOEZobW0xNExCTXRubU5KdldnSFhKRjB1N1QzTnNj?=
 =?utf-8?B?cnR4QitWUDhSRmp6bVkzcjdMczdsck1KUlBnSGRxR21zQzZ5bjMvTHBzNlZh?=
 =?utf-8?B?eUZ2SFhLM2UzdmJ0TnhTS3poSkdmU1B1a2F6UzRLZ01pdUFzT2ZyVWtLdEZs?=
 =?utf-8?B?N2FmZlJKMjhQSkxVNVJqL1VVTGY4ckwwRW9OMnB4alBER2FqSU9BZVNFRGVy?=
 =?utf-8?B?RVFMdDVOK3VwTnBxTGZiMS9jZDEwb2hOckRjamFVUkJoazEwY0J0N0dRVGJo?=
 =?utf-8?B?T0hqSHdScFZNc3ZQajQreUszQThwNXdUdDM3WHhHWkd1QUV2Tk9iWlBRdnp2?=
 =?utf-8?B?RFE3ZG43bzlKblZKdldaUDhHVmlMVDNTTkFwVlp2a2xlakdaYmYzNVNGd2pI?=
 =?utf-8?B?S1NTSXlJTU5qNGFWMExBUWFFUS9FNkVkTEpvUEtkaytianpscjZ3NkpLOXhn?=
 =?utf-8?B?S2FsT1poMnVqa3h5aE5pUDhrd3NmLysxbi9yWFcycW9MSnpXVHlkTWx3bk9T?=
 =?utf-8?B?b2FzanFjaG5taG5nbEw0YVBON0Q3dkE5YXFqODErWUZlMTdad2RBM1ZvRUQv?=
 =?utf-8?B?dnIxNEdiRkY3U0ZEN295TFUyNXB4VUo5T1Iyc1luTmRYWFB6WWpkMnNJUGRt?=
 =?utf-8?B?cUJ3Q3czTEVtWXRwMllVMk1wTjFGQ04zSUx0QWNXZ1U2enhoK1BPNy9mZktl?=
 =?utf-8?B?UHl3YkFOZms3YkN5OWFEdTgvUzhuUlV5RnZ1VkNSNHlla0hoRnlvV3ZGQ0pF?=
 =?utf-8?B?RkVJWm1uQzRjdUI3TXpiK3VIUWdnSVdpa3JtNDRCdXM1M3NYMWZJODJPVFZO?=
 =?utf-8?B?ZnZZRjBMdGFvbWJOQWxsWWpFbXhvUGFPUVBSWWRNMzRmVXJwQXRyaDVrUlEz?=
 =?utf-8?B?R1ZkVnhzdDBkSVlJTEZZMzFHWlFTdjd1NWNPVGVnV1hSN1IzUkdhanpBSUVG?=
 =?utf-8?B?MTRyUEppcWo1MlJHL3RsWmFBN1JJTys2TG13WFE4ZVpGVk10VnA4bmhzTkVs?=
 =?utf-8?B?VzgxWHEvOHhVc1VBUTg3NXFLOXd1UWg2Q2F6YUI5eUtsQ21yeUM0Vk9yL2xx?=
 =?utf-8?B?d2FyOTZLaDZiamQ0cmovenc1RkR2ZFlyNHpSb29lNHkxQklzRU1zYlJXWUhF?=
 =?utf-8?B?VjQydVk0S1o0MmJ0WUlFR2syVXh6eHVJbEZVYy9XRWdvbm1aTGw4SkIrWlQw?=
 =?utf-8?B?VW1kNEFGSVhGZTVVeEl0SDhYeTJ5d2xrY0pYdXRkSGRHMjl3L3BCY0h4TkdM?=
 =?utf-8?Q?ctSDHcdKnErUe2Ls=3D?=
X-Exchange-RoutingPolicyChecked: sBuNEo8GeTIcz7aMd6a4LTwPSQyOIhYRYn9+1qT4zohbjVp6lM7K/7gKs0kBMZw7uitha/Kc1ws9ktB/k5B8nsSiMKDOHDjnZRHQ6eyM0Ts4c0H8/Ic99GddKveydMV49JRWor7Kz9nm1yEbg64A3g6tT/RhPuacrebZ2+qugQp4IBbh9agJTQ4zu9zlMpS30x2rT77SkE9NnrdI0H7h4RyWX6UNKxKTeIHVpVky5pKLTm/YQmCVoUFuqamjQVWtSW983shOpMZ+k/Ut0yCwSGBOnzwzxLXJO3pvQlwz/ckK/vAxyZIu7UrHFiyxX8TwKmEItSoYsNDOOjDhPCjkwg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8653ad6b-b6c1-4957-c71b-08defcc43fb0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 01:01:34.6839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJ3pOtKNP8qf8Y7ZoxoLQV8RDefX5qsh7Ln050mmCyuy487y2UWgVBDbrm/rgQyhg8cbwAApSZZid4SBpriGJ5iUvjbrLwsppzajA8a+Kvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> There is no upper level serialization of mount(2) system calls.
> 
> mount/unmount operations can happen in parallel with CPU hotplug events
> that need to add/remove files and directories when domains are added or
> removed.
> 
> Use cpus_read_lock() plus mutex_lock(&domain_list_lock) to protect
> architecture code from races.

Please describe how these locks are used to achieve this protection (more below).

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v10:
> 	New patch
> 
>  include/linux/resctrl.h            |  2 +-
>  arch/x86/kernel/cpu/resctrl/core.c | 40 ++++++++++++++++++++++++------
>  drivers/resctrl/mpam_resctrl.c     |  3 ++-
>  3 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 568a650c0224..65245f2fdad0 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -579,7 +579,7 @@ void resctrl_offline_cpu(unsigned int cpu);
>   * Architecture hook called at beginning of first file system mount attempt.
>   * No locks are held.
>   */
> -void resctrl_arch_pre_mount(void);
> +int resctrl_arch_pre_mount(void);

There is no mention in changelog why this change is needed.

>  
>  /*
>   * Architecture hook called when mount fails, or on unmount.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index e335a143f3e5..906aa4dfc363 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -16,7 +16,6 @@
>  
>  #define pr_fmt(fmt)	"resctrl: " fmt
>  
> -#include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
> @@ -807,25 +806,47 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> -void resctrl_arch_pre_mount(void)
> +/*
> + * Linux provides no synchronization for mount(2) system calls.
> + * resctrl_arch_pre_mount() and resctrl_arch_unmount() are called
> + * with no locks held. Mount/unmount may also race with CPU hotplug
> + * events that add/remove per-domain files and directories.
> + *
> + * Use cpus_read_lock() plus domain_list_lock to protect operations.

"protect operations"? Which operations? I expect it to protect concurrent
changes to data expected to be protected by the lock. domain_list_lock is
understood to protect the architecture managed domain list. 
It looks to me as though what this actually does is add new architecture
state, arch_mounted, and let this new state fall under protection of
domain_list_lock to protect it from concurrent changes. The reason why
cpus_read_lock() is needed is the locking order requires it.

I find "protect operations" to be too vague description to use as motivation
and documentation of locking behavior.

For completeness I expect arch_mounted to be added to the comments
above the original definition of domain_list_lock to make it clear that the
lock now has expanded scope.

Reinette
