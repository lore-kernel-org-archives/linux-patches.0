Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E691CD2C
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 00:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767831373; cv=fail; b=bGmvQ//9rbVxiRVr/DMZ5oV7rBV+QmwI2oxEzyLGXQ61fhHB36k722RJdR5OjRi95GmZDSDpAiwutKwQAD+93fk6DhDlfkpv1KRtw7PaFJsKfx+I+PjdX1GD5KCLImFauHexnrGI8GuqZXZmT2NT6WzvQc3Cipp+1tkoMc6LWFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767831373; c=relaxed/simple;
	bh=Zz6w+GLVCV5vM05rYhXnWlMudUbEs2uLfcnlmAKbEVo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cs9QLF6PcTpHJk4EzF44z6XnLnS9Dh8rHKNjo+3HfzcBhJpu5RqFLU/E3C0isCByEvwaDweybL+kACFoPEO4zTM/dEy5KEaEHClvTWkqlNBIJR2MJWR4YnbJai3JHWtoe1OnF+btef8Rxnuua8noaCRXTO4TPEHydinO+LDGFwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/4MfMFv; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/4MfMFv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767831371; x=1799367371;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Zz6w+GLVCV5vM05rYhXnWlMudUbEs2uLfcnlmAKbEVo=;
  b=h/4MfMFvJLexZvlbUbX7jHiR9fsvTcWZGI73UzgcuQVszQzIyynqkxdA
   jClEUOJI99sNxBtVIu1atGnfX+/5lu775RhplPdoRgj8LjkVqFNtJQlaZ
   HHZVFziAEqPzriYxl1HKFyiRgJ3WPIVZ7fNtlkPtR7TJeBQVDEpnjQ85y
   wN6ihKl8WVDjXAfa62GoY5YSQYh7wWrZ9j1BO3MqUhjssxjXmRThPbGGf
   bMHXWshgCfCHXLKIuyINNAtPwRpnT0bJO4VwtadxK33vRpnyeC5SYOTOy
   gbj6ddsrJIFawc507oM6e7HKlAtNfhoPHuFlqlze5Lsc/DmWGh1bnhTgm
   A==;
X-CSE-ConnectionGUID: Tzho21XSSkixcS4K/TC7xQ==
X-CSE-MsgGUID: MjGPcWhuR5yRtl17IQrXJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="79850545"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="79850545"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:16:11 -0800
X-CSE-ConnectionGUID: PJlqyBehSVWT1CD0mt0B5w==
X-CSE-MsgGUID: iR/L7asVSUqloVtAhdXQ0w==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:16:11 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 16:16:10 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 16:16:10 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.29) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 16:16:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gv2XHBSTKPLQnfzMtGDXT75wZ9kxP64ngFF2ZwBkXi+osS0NuALERiPImXvnf3CuL4+C/SoLgBMAdBpqO8WLLNWkSUuaYVOyHhbXnKeZcqETSLpGvt74SDoIK9QPrGaqfvMeevJWOAG9Job6SGq1OBjX23DwqQLe/Zv0ceFEGbCJxQ6iSV4WfPj+NjAXsZ9DfJH8kmFbNZz55mgYNMPbwilXJCahtGCOErZt4LM7xvgf/5Z/GntCDXuWtoloO69eWCkOcJlUMb6JDN7bUAc4vf3ctiEYUazv1k4QxUzzpJJgh/P70AfoYssWXSGj+qprH8Oh5MvkuKaVVWMbve+5Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRRehUj8c/vijH2vtAeWw6Rf9ApVbZJ7aAWbOcYgzXY=;
 b=VFiVZPVn9G8c+YVx6GNRIMOQyuBSxWavumz1GHnCegk2JFIhI2oNYh0oQLAgsN5wiyLWQIDh/YT3P8JDEQAu7utcdfi+6fVAFpErDuT/u7wgFQZc3UzHZFn70taGhg1WHH63kM91U1mPefiL2LJoLgDo+mukzYpclzTwKSpqzjlnsnXtxdTLM1haHlDJyd3RuDTtJev5yYvup9nSOrNmuN3k+MW/at6O/rx6pUgKzeKqZceNqphpBIihZWTcoqKDSNdBDyA1NA4/NElAncoNuiI/RR1exIcPv6Kzk5QFwLmV0wXtHNSkHjACSWlyaTzFuVAGKS7YWKJrS2Q3vj1BuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7482.namprd11.prod.outlook.com (2603:10b6:8:14a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 00:16:08 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 00:16:07 +0000
Date: Wed, 7 Jan 2026 16:16:06 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <aV73RiFGJvYxAeo2@agluck-desk3>
References: <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
 <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
 <aV7BIWu7cSSgCv1v@agluck-desk3>
 <cb41f4bf-7eb4-4a59-b46e-8bc4ae18e6c6@intel.com>
 <aV7d7JTp_YX_4BRt@agluck-desk3>
 <1945e4b2-9a80-4e48-be70-a8904e0fe10e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1945e4b2-9a80-4e48-be70-a8904e0fe10e@intel.com>
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7482:EE_
X-MS-Office365-Filtering-Correlation-Id: 04d266e6-8b75-47fe-9df6-08de4e4b1e64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eX+9rIZwBUnRlsUt0XbFi9pJQi6j1c1opmxVwODQhtUZ2dizjxAf2bMDSRIq?=
 =?us-ascii?Q?QNdHf2Sjx/Jz8o/PrvPA5zSdRMDi8h8PvRdBMMeAL1VSV+NTTN4qj2F8HSLB?=
 =?us-ascii?Q?42dGzdMKQie8Hex5786GcIE1hPuWnVz/ApMozmPPxZoE9Tf9915S9c2CGpEK?=
 =?us-ascii?Q?Lkkprs8bIXvjjSBji9TpXKqxnYscBv7uy+Ee33gp+df5C8C6YTuehzFZIrt0?=
 =?us-ascii?Q?NwmW7uG04gAnHw/4zfkhKO2EwA1t1KG7DtaongMM277gxXwZXrQK0s8ANr20?=
 =?us-ascii?Q?u3MSAz3sERxKOfoCNuHP0GC6TZR/XuBQXv0ZjIIXacZtSvCpOIBoUpo0eXMn?=
 =?us-ascii?Q?vNvnOqXYBSLaqUSkoXUU1KE3E5UbPkqJ/639N+guvbxysZ199l7bGHqh0CKF?=
 =?us-ascii?Q?m10C1SjTi1k/YX9lN4z4hhe2n0ela/cA6ZN+fMKFcdMkz0WDo4GHzFyQ5rNe?=
 =?us-ascii?Q?fTBfXQKf5AOV5pE/AMwoQCkAAR9SfNcSTSEH0v22m+86oFm1MQjwJzfu2cof?=
 =?us-ascii?Q?stQUgjyPho5HL6vjoaFE9xxoFfQazTJuWGXzdDJ5jgYVLc3h/1wFeV1+amHO?=
 =?us-ascii?Q?Q6G2rfvPG6HkVXYIwFf5mTW43i5E31waxxsEi1dg3oLgFMQ2/+qG7nocJ7sD?=
 =?us-ascii?Q?p36mqFkyBQoapq92HROxDUpr6OevUrssHH0G7PQoWECYX9kQi//OFAtsDDhm?=
 =?us-ascii?Q?5rZ7Cx5Du1biXbY/ahUXMuLlsYy1ba4l5pPu6LNFAYf09vhibFG59Dbg+WHz?=
 =?us-ascii?Q?cl2I+syzzh7yHYDSkinG4GIsjsZr0v1TNz1w/AIuReNR46nNxT10ZJ33m8aW?=
 =?us-ascii?Q?zfeQbyGVtHaY6ivbqy7foFWaq+o/d9NLvYL5ji04ql+IbT+df34WuHbVcWpJ?=
 =?us-ascii?Q?74/pxSpJSS74nbo/h9hWsJF5JQuZSyoHGPCmV0oibDCV9xfI5eFiG9QRZs2d?=
 =?us-ascii?Q?MhAm8ENgD+2PK2FQGPvmYH4cbCWJH+TWe0c0irAZvEnWlua2tMaWgsLOr4nR?=
 =?us-ascii?Q?KbmZ2uWkaflSLsjwOnTlk83wKICi/QlsE+kE/3X/r0nE5IC+3Tbh8tyKZBlW?=
 =?us-ascii?Q?dqlnhnKTBTnz6KzbnuGq/9+WUQs9ZtAq9iRPNyZ5dkn/e1FC2XKJczLR9GaQ?=
 =?us-ascii?Q?QV5bkwrtsm0sMHM054f7jFqD6kKMgVfE+3URyiZpBZ9noCHgzSI9d5HYJwpF?=
 =?us-ascii?Q?J8mJBwLZlMPkFbxaRrA5lE321QNLxRTUrcBrYMF/Qe0QIsO2UZBQQXyLFkxu?=
 =?us-ascii?Q?D2nI/lqaup17pdHNyEdwsE2FPeDcauK64rH7WUQWsjm1kEyM2ntvpi95vqfa?=
 =?us-ascii?Q?4TCkOzhuGrmhk/MdCadylKHWPDPCS8LE9CvlUzUWC3OWQAyhQGv+jC25XUb3?=
 =?us-ascii?Q?bTEAewJRJtGO4hLYszSmIqNjWuXTG/yXVufP+BjnCttliTVE9fe9cq5rAV6w?=
 =?us-ascii?Q?LVeDwODzFPdUVTeZJEsvRzpw+3LMWzg5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GD7HanzhX3wZlNKwJovVQtJBzeaZnJGLk69IYF5fD1GmUwjO7WuMydpI/AVr?=
 =?us-ascii?Q?wFt76qkmgdDmqrG/aok8DnXgvGkCUCRMgcrYQRqEIV/pwPKanVYehEyteOe5?=
 =?us-ascii?Q?s6yE+3ENkDMnRcSEoNUi+Ftl77zb3wZW+b7XGOj9BOyPpebLngEUBy6TL4gD?=
 =?us-ascii?Q?nNG64L6RC64SQ5dW0a+ivWBeqR4cEo4T/PO5nf0aVs/bFscQlPNNzikj2xU4?=
 =?us-ascii?Q?sJ+go1En1Ng0f7EgwZgf1eZ9vF2F1+B0uXKpA8ZKXNa1S6laZOXhEn+7fOgD?=
 =?us-ascii?Q?HblLclmt+GcUDVJlksM7IH1Ls+0l2up+NbMPn38OmNqzL3fIWenYCuGKzJC/?=
 =?us-ascii?Q?9z6FQ8lr5TPDUncOrf+OcRjPcDBwtrPubGC1qqryWspVnbA7xIs4JYXUAV5K?=
 =?us-ascii?Q?0sgWfSx9P1Jp5LVDMu6H4N6410xUo8soa3X0xKiWWoL0gjMRqdCQUYYZvPXm?=
 =?us-ascii?Q?B1bTKhUWHCfiH6OanokMNAX7mW1EDF0Yx4tXka5xT2ydHbtzH7Mq6Nhg9XoY?=
 =?us-ascii?Q?KFJF4zyi7wnuGQ+pG5FAXDrJcJTHx1hrg9Cfjo5EuZMXPIBdVNTyw7w1f62s?=
 =?us-ascii?Q?SxYe3fQLvY0z3QS8Qo0hF58rU6HlbsIHB+z1besoM+r2Ian7/EvjSgz+KriF?=
 =?us-ascii?Q?jWx6akJHoCeFQppRJzHkiTxwR3p5u0XN7NIuhayg7+pMAn1GMzblxkFJO4Qv?=
 =?us-ascii?Q?22lU+TZNaXMAoxIG4i4EvGL2QK2unPdzk5ICamNU10HbJs1XdUFq31ITyHF2?=
 =?us-ascii?Q?ZIsmve8lknNxs+x3VWLPyjR1MZiHeqSHPF8T+s99t4Zu1QmuzZJ5COdvuuiI?=
 =?us-ascii?Q?Y8OKcZ8Z0ebU8PZmp73i9ZPdHXFo65Upsa4biopiFNNj4VWN4IFY2217p4eP?=
 =?us-ascii?Q?SXDzr8fUoT0CUwMUZOPX+ONPxBv/ZtKYCNU2yBatFWPJR1uZnH8YjmdwSlHp?=
 =?us-ascii?Q?wnkY3m4uRmerrA4NY2qvtzzu4+l5TenfUyY9Mca/0fo+7WAGGlAFJ5PvWo51?=
 =?us-ascii?Q?9urJ7cQbcYulT9EGdnIEp1aAT0KJH5l+K/n5cpZnvfiMN9L1PKlOZ3ACJzi/?=
 =?us-ascii?Q?jL7srO4db11DoZ+aKXlJKnfxGncH7ps6q5ygF6Ifw7rAkVy9fbHGl/ObeOr3?=
 =?us-ascii?Q?iq0H1+5FakTPReW4Ab5LbW1RSIsDPdrnOj2lWsU5uq//FuuAWn1wKwDhcsts?=
 =?us-ascii?Q?0nU95GHTEsKDo3MCZNJ9E3wV+IcblqIO7zZqqiGwEBg9lld82ig/MPhIea7/?=
 =?us-ascii?Q?BdbKVSnbjEg6l9sH0Aveoq+Sbci6NwInaAy+/rvsZRFxXkfGD+4LxqH5Urhe?=
 =?us-ascii?Q?1PUS44sfcO2o7T8uPHTHHqKzH+Kl+dwO1nyqcN1aQpRFm+zv5qWCBEsr0IPW?=
 =?us-ascii?Q?2gDgxf/gTUb84P+skbCV6sN2eVBtiFGpgXgaEVq1AOlA3LOEwQrBnXZHSLrr?=
 =?us-ascii?Q?3XB4vgCp+VCf+Kti1T8MXZrRjKVqS+JOPvxmoBfmiiO5om/roQmsTOlSg2Ix?=
 =?us-ascii?Q?KTUHlLzZm9Qb04vJhUIKeUkReKpiNCRNLIRYoQz+NUbibDqUbYbJX276Et3M?=
 =?us-ascii?Q?zEh2uM8IJMJdWG8EEZakVNBJF99o1pIiYo4cDFAZBjT+7QxjE/hxnXu5IuZo?=
 =?us-ascii?Q?c2btzeD+IclILQTNgLqTmzYEPZ+hzyZY1rhfVIpmgMIO5+ycjTReV8Gnn6aq?=
 =?us-ascii?Q?BLO59ir0h7TlhfA3s207p2rM7zqv8nFj+tmkVKeGAOfQoo6sO3mA4VWejNHm?=
 =?us-ascii?Q?fCwsep6ZSg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d266e6-8b75-47fe-9df6-08de4e4b1e64
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 00:16:07.4717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0ywWupzsqvMWvXEUJqNO7FGgmUadnB9saIXE8XBTM56eZx86Pvxnh7ZBh64Z8wtDaLLkAxgPqd1PIsk8YmdtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7482
X-OriginatorOrg: intel.com

On Wed, Jan 07, 2026 at 03:09:24PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 1/7/26 2:27 PM, Luck, Tony wrote:
> > On Wed, Jan 07, 2026 at 02:09:35PM -0800, Reinette Chatre wrote:
> >> Hi Tony,
> >>> If these DO_ONCE macros are ever used heavily in run-time code, it might
> >>> be better for once_lock and once_mutex to be statically defined in each
> >>> invocation of the DO_ONCE() and DO_ONCE_SLEEPABLE() macros. But the fact
> >>> that the static key protects the spinlock/mutex from being called may
> >>> mean that it is practically hard to hit problems.
> >>
> >> Which problems do you have in mind? One problem I see is that since these "once"
> >> functions are globally forced to be serialized this may cause unnecessary delays,
> >> for example during initialization. I do not think this impacts the resctrl intended
> >> usage since resctrl_arch_pre_mount() is not called during initialization and is
> >> already ok with delays (it is on a "slow" path).
> > 
> > Reinette
> > 
> > Yes. Unnecessary delays due to serialization. But that only happens if
> > the first call to a DO_ONCE*() instance overlaps with another first
> > call. It might be quite hard to hit that during boot unless there are
> > many uses of DO_ONCE*()
> > 
> > Looking at this some more, DO_ONCE() is overkill for mounting resctrl. The
> > static key part is there so that DO_ONCE*() can be safely used in some
> > hot code path without adding overhead of checking some "bool done" type
> > variable and branching around it.  I don't see anyone except validation
> > executing resctrl mounts at multiple times per second.
> > 
> > But it does make the code easier to read with a single line with obvious
> > meaning instead of multiple lines with declarations, initializations,
> > and if () conditions.
> 
> I am ok with using DO_ONCE_SLEEPABLE(). The next question (perhaps nitpicking?) is
> if it is resctrl fs or the arch's decision to use this. That is, whether the flow is
> something like below where the arch decides:
> 	arch/x86/kernel/cpu/resctrl/core.c:
> 		void resctrl_arch_pre_mount(void)
> 		{
> 			DO_ONCE_SLEEPABLE(aet_specific_call);
> 		}

The AET code in resctrl_arch_pre_mount() includes building the domains.
That needs the domain_list_lock mutex and domain_add_cpu_mon() which are
both static in core.c. So either they need to be unstatic'd and added
to "internal.h", or that part of the code needs to stay in core.c

Opinion on making these available to intel_aet.c? I'm not a fan.

Keeping it in core.c means finding out if intel_aet_get_events()
succeeded or not. DO_ONCE_SLEEPABLE() doesn't return the return value
of the called function. It just returns true/false to say if it called
the function.

So with this approach I have:

void resctrl_arch_pre_mount(void)
{
	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
	int cpu;

	if (!DO_ONCE_SLEEPABLE(intel_aet_get_events))
		return;

	// intel_aet_get_events() sets mon_capable if it succeeds
	if (!r->mon_capable)
		return;

	/*
	 * Late discovery of telemetry events means the domains for the
	 * resource were not built. Do that now.
	 */
	cpus_read_lock();
	mutex_lock(&domain_list_lock);
	rdt_mon_capable = true;
	for_each_online_cpu(cpu)
		domain_add_cpu_mon(cpu, r);
	mutex_unlock(&domain_list_lock);
	cpus_read_unlock();
}

It does reduce by one the number of stubs. intel_aet_add_debugfs() can
be static in intel_aet.c

> 	fs/resctrl/rdtgroup.c:
> 		static int rdt_get_tree(struct fs_context *fc)
> 		{
> 			...
> 			resctrl_arch_pre_mount();
> 			...
> 		}
> 
> or something like below where resctrl fs dictates the function can only be called once:
> 
> 	arch/x86/kernel/cpu/resctrl/core.c:
> 		void resctrl_arch_pre_mount(void)
> 		{
> 			/* AET specific code */
This is the minimal change from my current series. So my laziness factor
leans toward it.

> 		}
> 
> 	fs/resctrl/rdtgroup.c:
> 		static int rdt_get_tree(struct fs_context *fc)
> 		{
> 			...
> 			DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> 			...
> 		}
> 
> It looks to me as though the first option creates opportunity for better isolation
> of AET code into arch/x86/kernel/cpu/resctrl/intel_aet.c, specifically, it needs fewer AET
> stubs in arch/x86/kernel/cpu/resctrl/internal.h. I do not envision resctrl fs needing
> to call resctrl_arch_pre_mount() multiple times but the safe pattern appears to be to
> place DO_ONCE* in a helper function to ensure that only one static key is ever created.
> 
> While the first option allows more flexibility to the arch that should not be a reason though
> since this is internal and we can always change to better accommodate arch requirements.
> The question here is just what is best for AET support. What do you think?

The current usage for resctrl_arch_pre_mount() is that it only needs to
be called once. As you say, that could be changed if a new requirement
appears. But the simpler approach today is to put the
DO_ONCE_SLEEPABLE() into rdt_get_tree()

> Reinette

-Tony
