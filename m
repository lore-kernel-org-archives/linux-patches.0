Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E207036207A
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756923153; cv=fail; b=JmDhaT4CowW29/oOpMEt+Ef/LoGsnacnkYMgINC6NyZZAxVaaJp3poskSz1ra6Gwg3TCQp6xNnnqz8vSkqd+6IHF/KGM0lfyrRmFJ3c9YAkrWzIbSZ9wCLOhqwT4vwxp98gXQUjpvzx3wJLJgwG1FBgr4WfTuNPUlEAv0RFs70Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756923153; c=relaxed/simple;
	bh=rxoGbi4G6p5KIFz8TcwmXuCX0UAmmTuowHPxWrJQooo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=keRv6Gj4THcW5kZ8WtyWZh9ZPMFylokVThanuc4fOEVVzMNvgM+7PheoC/W7Cp3gnNQt2Q4ku0Iir79NVMoqFVNcqTVaREO/varBuHWtTrexNZZtkCetZYWQeUoqUHYHBi4Dr4D1C6p5ZmUufwn3CI26xdEQJ+Bc/BEWLPvhbJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XIi9+8rr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XIi9+8rr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756923152; x=1788459152;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rxoGbi4G6p5KIFz8TcwmXuCX0UAmmTuowHPxWrJQooo=;
  b=XIi9+8rrT2du8VLlvbU+T+aXB9TFR/OiTXz7l20ggslqJndw8MG9PXlO
   Qap+LQdF5zqXcgOPCqrpnCEr92xKOy7C76/hg6UqSQX5NBmoXOwHeaowU
   4llIWpyYzQD3GlguhTMuYXiAYvM/wH6wukhmn0JhYSK8N/aGlmYjI76+B
   0Ik/o2btjFo0XhiK/JN61VGPv+9ecle+yI+T1xlrRp3Yq04eUB79ujpZd
   +Bep6abRLI/tecZFpp+wh6zVMdPWo5cHp1gtxQYKxB6t8gB28DqzXLnnQ
   WQEWOutXAGubgdlftem6FqVIbcPevr2uL5D4GoJlMpsJXx6KoN2gjWHsJ
   Q==;
X-CSE-ConnectionGUID: dF6CBOgWSreON0mq1k/dLw==
X-CSE-MsgGUID: KgpDewYyTHakXeNIU8mGzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="69859396"
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="69859396"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:12:31 -0700
X-CSE-ConnectionGUID: AP0ZqUFoSV6mfo9KTdy7JQ==
X-CSE-MsgGUID: meQrK/LCS3+9ftLLwUsK7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="171549862"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:12:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:12:30 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 11:12:30 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.73)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:12:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgN4n4nJaFDXIjmCMrlBGR/26fTq5mcFYKEXmGBlKNBa+DlHaAIrbDsBqjZAUO602ZleunzNEWbEOloXofiyJCnFN/jxvSFVNmxUxr/rea+STNJa8MnkYqVyabvWkdV6DCW5zM9qYWn2GKK/+nmyho9wnMgo1WIsbXPGkRFsR0aqnm/V0Rnlh0ccKEfD6qScfPJ9+rDe8cEhm09uwLe3JFHrirK5XYoRC0+WAKUytv0r7WoURDSkjPUj/1hD9WcDcQeIaUPMRB43TJWMc5Td2a7aoYyJgi9UTzPNpyNlK6rQv3BI40YRZN8E+QpRk2Vh4lOSDwzS+CfuXI7h4Xr8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyEdpfLvl0EmlC3gfgNk0jYVtMfb3rydntPXCSFB1Ug=;
 b=d7NdTijtJ6JLB4aWD2GKAcHoV32GFQhpHyxq7BaqHoeXyxB9wUnkzf+TtfGQT9Bw0o1+8LuCrQ5dGD6Ut+yB0wMzVbhdQnlX9ZcqNE0gSBz9thULdbss4PGflwLFCc7vJOQo52DF2k+m/IwkhAwvPbC3MCjefNaWzO5fj5nMNvOWjASG1VleuygQZgn2dwfuyD4yXwvOFhrv4KAQu7kv4gUuh6GCvunfXKL3hcl7T5YkqmRD5YnOE+lSNhoiTgYxphDhYHKlUYlO73oU3WOlKmpFumghBZ0f5HHs19KOjeobG3WU3j6Y1zQ6i1D7KpPOQkODX908NxMll9ttYJF5hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7460.namprd11.prod.outlook.com (2603:10b6:8:142::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 18:12:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 18:12:27 +0000
Date: Wed, 3 Sep 2025 11:12:25 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 17/31] x86/resctrl: Discover hardware telemetry events
Message-ID: <aLiFCRiM4UgC8c7C@agluck-desk3>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-18-tony.luck@intel.com>
 <1cc035b1-7bd8-8fa9-e3d5-f530bcdec517@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1cc035b1-7bd8-8fa9-e3d5-f530bcdec517@linux.intel.com>
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7460:EE_
X-MS-Office365-Filtering-Correlation-Id: 63c3fee0-7b7a-4ed4-55ac-08ddeb15707c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gGwZ6keu4FC0vRWFzfOeiWP8EUKXj5e+HlDUOVdLqcG7j3Bx8ntOT+p8pi7F?=
 =?us-ascii?Q?xIQEHivGPC+oqxAkFjDIGQN3sIFt/UDAoQ2NvDdEZFFsH5a8cM9q7wYKfEnM?=
 =?us-ascii?Q?nAOFOsPGzpiMo5ix8Xuu5haqeE3wg9IJe3Om3ug/Aqqa4wfeh/t28Z7OUDp1?=
 =?us-ascii?Q?5wdcVtWRbqGYtubIUH6eFzAOn1TG2Oyw93DL4OzSo4zBEdMGS9rf+IFwaRV8?=
 =?us-ascii?Q?dyrWlKmWnMadpZcME+nAOYTnBSpW09kqilO6D1EzmdRq3uN+ZauMrHSOeSbN?=
 =?us-ascii?Q?Vv2zUdC8ktSMF8xiII2j3DY4AWCcEuHu278CBponodD57asyQPRzwAGHkYgp?=
 =?us-ascii?Q?iI/PNV0gt4MON90a8KNFNxYA7QyNTdWd3wSq/RW9zzJFv5ebkcJcIGM26es8?=
 =?us-ascii?Q?AgXoH93VgZRvqDYNCD4kQ4pjycrsPtmcZzqQaU8bSfLvBNTiYJBk32I4hLsD?=
 =?us-ascii?Q?Yq8HLdRdusLo1tvWlXd2ZnuvBpQHrr2MrcNci04bRqzosCgdGfAbnWtmMiHV?=
 =?us-ascii?Q?OkuSJ5dzH068RLyOlfGEe08AiFshF5l2S94DKubHTvz1LgWhM1UoEvE+WUk8?=
 =?us-ascii?Q?E8sBGL/MQWapOZRgEh9cHs+ymz6Lq1VUSzvfpNFf6siZvOtLIckJ1QuO/izB?=
 =?us-ascii?Q?pn6sP9MGDFVAZCSk0oxfyFINuE5GXyiLiuxi2aD+5UhAqKlxlA80VxmrbMPW?=
 =?us-ascii?Q?s9b7RFlmtTyvtKktH1pnccpebs6shiYbPZs9M6IXlNZVy00LsXh0VzMljeNK?=
 =?us-ascii?Q?PM+Qf4AMxvpL6utBBr+56p6EBo1UQkeKcIDOS9gOvDO817hEb91dwiGjyk9b?=
 =?us-ascii?Q?UHk+OsdrI6LYfA2PlYNZAP3gU0/WOZY9kixbXt+lSFqCE9XDjjTbEqyHpiMg?=
 =?us-ascii?Q?/CHFOyQSDVJttQKi51MpFJoeZxdH48Up3yNSNHt1Ez1dJOhbGLGCseJ2GJow?=
 =?us-ascii?Q?LKxKjdcTDhpSrsOOe1s6QIZ93XCFyJbsGwOJhWwbzJMBVvxBzxqXXxPrMgc6?=
 =?us-ascii?Q?u3f4sbgJBooGoF8IBMRXiAdQscPoonrRG3e6MFX7uumEwEnCQaKn4xEoJsCH?=
 =?us-ascii?Q?Sqsw/srUyilEahAYoYclCmpOdlgfI7ciT8ckO8hAmu54F3K+9M3ljbwkkXUL?=
 =?us-ascii?Q?1ByycrwCG92wnyXUlm7+LWP+A2mshdvrn31DJGrr4QMfki5Q2JnjUrooFHnA?=
 =?us-ascii?Q?XyJxGcXA0dJKbOup5ELOYyr4iXWaPIZpGGZAt8YDf0gcMpZPD4yrI58vDxW8?=
 =?us-ascii?Q?LXdUfIE3C1IRVaROeffVv8Ki4kjw1Z5Y4JsC5siwLcZlpreFy+zXxH8ppvfq?=
 =?us-ascii?Q?vgEIgkwMRQbHGlOgCd40XuHI72LeMrHUTW6sC3ijulpH9wc06Uu/WGyOHVYf?=
 =?us-ascii?Q?OIDejbByecXnCaFnncB59T3rDqFKHn9VLAM6KTuUtFBL3HEmLbOsRwBXOxFu?=
 =?us-ascii?Q?Ho6sM0Gq4jk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NFQEhR3yG6DJ7KHZlmdLRypxVprFeTsP5LZ8BiiMU836MoawiMkOiDLlsDN2?=
 =?us-ascii?Q?Ke2LXWuYeFcS376brpE5bIOyrW8lV+MTDJTXmO0Z1qOUgdQcVnkrg7xEh6NL?=
 =?us-ascii?Q?UxPLeGZmkpI6Vokk44K/nXOZRgzQE0hamNBMvH/7+LrKu6iHxAY1U1Rsj9eu?=
 =?us-ascii?Q?aSze/5d3bfpaerRBi+IvOGa2Z8X9g5NhM9fBfhHX+IyZKnyWW3cxNan47gWe?=
 =?us-ascii?Q?0rKUxUiykANYmQu5bscsWG29QmDPyV9gV1LR5NUaqRqTD0T6Pqj3zJi5FgHR?=
 =?us-ascii?Q?GR+eIGxWlgMGrs2St3UM361IJMWx416BZq1J8DEK8+n1GKA9NViL9nv6WWbk?=
 =?us-ascii?Q?Xz9rTkTmF6CYQtSwnYMXalkmSToxC5Q3Hxmr97lo6ZoCgx/I4rrzcYkWtmbZ?=
 =?us-ascii?Q?EHDg2+EXpkoK2NKfo0tVVWqKQLBn9KQroyXsyIOwDdoUIMbIZyYY38Us0yXP?=
 =?us-ascii?Q?cL/AWhLWtV6LOhWnUFyexuV0j3n7aXBQmwcavAopacMO0BlRSJtWQwdrmocJ?=
 =?us-ascii?Q?xAWU/v658oMPNOjBTj6OfbHwuPjzFkZZUEWRBLF5A3Q7ZaDFqLPV+lls45Az?=
 =?us-ascii?Q?gTl9Y2jzbILC60O2U5sJS2f+uRekDgvEu96+s+XijIb5cd1osrz3EZjYeu+m?=
 =?us-ascii?Q?MhC2dgHsmnSQ1LbGrCQTc/t7LJmqO2o+9ZPpZWSF9lXo1uir4Aic6ZrQgoeC?=
 =?us-ascii?Q?ckEDPrlXJI4wgksHIbpBiQcQNs6vU9JTfarmhPxKAAKA74gKXyauFNldiPee?=
 =?us-ascii?Q?/SvzbQusOK0YJMZtif4K6vgjU3dGgRbYClIfPF7yg+xyem34WANtY0tK6pRj?=
 =?us-ascii?Q?BdpG1w9PxZPf545DWBCNYrhMCtMgXI0wohpsGnJF2sRkYM2/JIzVhH2ozNML?=
 =?us-ascii?Q?FSXAyiCCJq4lyGU6vR7qwV2Vfnz/9r/WhkaeCLleLFcJOZaX7fzLEIBD6LT0?=
 =?us-ascii?Q?5Lt+o+AfoftfE8xJ10koweUXkDT0IBRM+xhe/chW1/FkIuVEghQxwmsvR/Kx?=
 =?us-ascii?Q?xEM6C/Rmzmd4Jv9a9XHaGWPw5S5L2YWKTlghr7m2kZcQ630gHdIdz+C/CsYJ?=
 =?us-ascii?Q?VISRYevlzPdBfN2MXNxkPFLMXrXihryRDAVE+X17/7LZc9LaHLK8j1nin5yN?=
 =?us-ascii?Q?UAl5KHSQkaGN/VUQO9GLmXeg12MtLPADeoC5Q3UDlhJTjODV0w0K569+gCf7?=
 =?us-ascii?Q?emPhi6JgwBHxZGuK9CZZZ1AwLPETAoaBA2QotO/c9j7Wy0B8ze01drcEiJJs?=
 =?us-ascii?Q?3e0ZCiN273k3wi67S/XOwVy0vlltTIy/L4PWEuC515UF2FMX4BiTv/WINZaz?=
 =?us-ascii?Q?EcYsJy1maYcKyDj8oRYELXPLXMPHJVBnLkkpcnLbp12XMRHPqqt/gVCTwV48?=
 =?us-ascii?Q?XqAt35SRoQSLZD4hdCC65TXcIepwsoa8g+Vjwd3vO5ASjCTsInL/Ntu51cqe?=
 =?us-ascii?Q?XNAC4DPF43n5l5qRxldyL0l12RY7g6CIpDlDAjr1C6qeoDD8TzUNRquGlGmW?=
 =?us-ascii?Q?nJDEWLezmb8de18rhWjDwzpRIKGgFkBxKSBHoMc8ayBCNaCyquBOqHCmVqle?=
 =?us-ascii?Q?2+qOtWZg9Tm7IHvsP0ntcFuS+71WFo3Xw+s7GVPe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c3fee0-7b7a-4ed4-55ac-08ddeb15707c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 18:12:27.4494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAg9xt646Uh9dA5O3RkCUv9Xro6v2OmpTzU1PkEoTty34M31kQ1kZ39LWVWvRkEZFRw0p/QxOVTYWfPYgLqPBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7460
X-OriginatorOrg: intel.com


Ilpo,

Thanks for looking at these patches. Applied all your suggestions
for this part. Updated patch below. Also pushed to
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip

-Tony

From c717ab20b7781eec8b6dcf711eb0e2f8255aef8c Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 25 Aug 2025 10:45:34 -0700
Subject: [PATCH 17/31] x86/resctrl: Discover hardware telemetry events

Each CPU collects data for telemetry events that it sends to a nearby
telemetry event aggregator either when the value of IA32_PQR_ASSOC.RMID
changed, or when a two millisecond timer expires.

The telemetry event aggregators maintain per-RMID per-event counts of
the total seen for all the CPUs. There may be more than one telemetry
event aggregator per package.

Each telemetry event aggregator is responsible for a specific group of
events. E.g. on the Intel Clearwater Forest CPU there are two types of
aggregators. One type tracks a pair of energy related events. The other
type tracks a subset of "perf" type events.

The event counts are made available to Linux in a region of MMIO space
for each aggregator. All details about the layout of counters in each
aggregator MMIO region are described in XML files published by Intel and
made available in a GitHub repository: https://github.com/intel/Intel-PMT.

The key to matching a specific telemetry aggregator to the XML file that
describes the MMIO layout is a 32-bit value. The Linux telemetry subsystem
refers to this as a "guid" while the XML files call it a "uniqueid".

Each XML file provides the following information:
1) Which telemetry events are included in the group.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for this aggregator.

The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
This driver provides intel_pmt_get_regions_by_feature() to list all
available telemetry event aggregators. The list includes the "guid",
the base address in MMIO space for the region where the event counters
are exposed, and the package id where the CPUs that report to this
aggregator are located.

Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel
specific parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY
and INTEL_TPMI drivers being built-in to the kernel for enumeration of
telemetry features.

Call intel_pmt_get_regions_by_feature() for each pmt_feature_id that
indicates per-RMID telemetry.

Save the returned pmt_feature_group pointers with guids that are known
to resctrl for use at run time. Those pointers are returned to the
INTEL_PMT_TELEMETRY subsystem at resctrl_arch_exit() time.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
Note that checkpatch complains about this:

DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
		if (!IS_ERR_OR_NULL(_T))
			intel_pmt_put_feature_group(_T))
with:
CHECK: Alignment should match open parenthesis

But if the alignment is fixed, it then complains:
WARNING: Statements should start on a tabstop
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 140 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 167 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 6b3f3203edc4..9ddfbbe5c3cf 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -169,4 +169,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+bool intel_aet_get_events(void);
+void __exit intel_aet_exit(void);
+#else
+static inline bool intel_aet_get_events(void) { return false; }
+static inline void __exit intel_aet_exit(void) { }
+#endif
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 566530c6dbc3..57b34e1dc088 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -735,6 +735,9 @@ void resctrl_arch_pre_mount(void)
 
 	if (!atomic_try_cmpxchg(&only_once, &old, 1))
 		return;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1087,6 +1090,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..1a9b864e2dc7
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Resource Director Technology(RDT)
+ * - Intel Application Energy Telemetry
+ *
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Author:
+ *    Tony Luck <tony.luck@intel.com>
+ */
+
+#define pr_fmt(fmt)   "resctrl: " fmt
+
+#include <linux/array_size.h>
+#include <linux/cleanup.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
+#include <linux/overflow.h>
+#include <linux/resctrl.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+#include "internal.h"
+
+/**
+ * struct event_group - All information about a group of telemetry events.
+ * @pfg:		Points to the aggregated telemetry space information
+ *			within the INTEL_PMT_TELEMETRY driver that contains data for all
+ *			telemetry regions.
+ * @guid:		Unique number per XML description file.
+ */
+struct event_group {
+	/* Data fields for additional structures to manage this group. */
+	struct pmt_feature_group	*pfg;
+
+	/* Remaining fields initialized from XML file. */
+	u32				guid;
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
+ */
+static struct event_group energy_0x26696143 = {
+	.guid		= 0x26696143,
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
+ */
+static struct event_group perf_0x26557651 = {
+	.guid		= 0x26557651,
+};
+
+static struct event_group *known_energy_event_groups[] = {
+	&energy_0x26696143,
+};
+
+static struct event_group *known_perf_event_groups[] = {
+	&perf_0x26557651,
+};
+
+#define for_each_enabled_event_group(_peg, _grp)			\
+	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
+		if ((*_peg)->pfg)
+
+/* Stub for now */
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	return false;
+}
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
+		if (!IS_ERR_OR_NULL(_T))
+			intel_pmt_put_feature_group(_T))
+
+/*
+ * Make a request to the INTEL_PMT_TELEMETRY driver for the pmt_feature_group
+ * for a specific feature. If there is one, the returned structure has an array
+ * of telemetry_region structures. Each describes one telemetry aggregator.
+ * Try to use every telemetry aggregator with a known guid.
+ */
+static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
+			    unsigned int num_evg)
+{
+	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
+	struct event_group **peg;
+	bool ret;
+
+	p = intel_pmt_get_regions_by_feature(feature);
+
+	if (IS_ERR_OR_NULL(p))
+		return false;
+
+	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
+		ret = enable_events(*peg, p);
+		if (ret) {
+			(*peg)->pfg = no_free_ptr(p);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Ask INTEL_PMT_TELEMETRY driver for all the RMID based telemetry groups
+ * that it supports.
+ */
+bool intel_aet_get_events(void)
+{
+	bool ret1, ret2;
+
+	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
+			       known_energy_event_groups,
+			       ARRAY_SIZE(known_energy_event_groups));
+	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
+			       known_perf_event_groups,
+			       ARRAY_SIZE(known_perf_event_groups));
+
+	return ret1 || ret2;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group **peg;
+
+	for_each_enabled_event_group(peg, known_energy_event_groups) {
+		intel_pmt_put_feature_group((*peg)->pfg);
+		(*peg)->pfg = NULL;
+	}
+	for_each_enabled_event_group(peg, known_perf_event_groups) {
+		intel_pmt_put_feature_group((*peg)->pfg);
+		(*peg)->pfg = NULL;
+	}
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100..50051fdf4659 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -525,6 +525,19 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
+config X86_CPU_RESCTRL_INTEL_AET
+	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
+	help
+	  Enable per-RMID telemetry events in resctrl.
+
+	  Intel feature that collects per-RMID execution data
+	  about energy consumption, measure of frequency independent
+	  activity and other performance metrics. Data is aggregated
+	  per package.
+
+	  Say N if unsure.
+
 config X86_FRED
 	bool "Flexible Return and Event Delivery"
 	depends on X86_64
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index d8a04b195da2..273ddfa30836 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_X86_CPU_RESCTRL_INTEL_AET)	+= intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.51.0

