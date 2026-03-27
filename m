Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4068D32BF4B
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655141; cv=fail; b=oF1Tv7j9Cw3fPR9ToM2FOxRHhUYxCwDvS1Z2iiqxOVVNyoopXfcleqfAoVMOqlHO8aFyO2Vlfw+k89p9kJyloPhULSiprefllr/CeIOoGbi3MrP60WOVL7d5MmZR9p3iU4lEU+XU9N2eY9ru028xSS16pjrigap4AxWwlvOnoyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655141; c=relaxed/simple;
	bh=fOj/tbhJKzoxBb404im9WNC8YElONEihRBhUxCRprto=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZPVxtjcC2FxNVmUzuUUZgccSc4TauWaPWAKWzqLH03NTeS1skxx9BV6eTczEgDZW8cSJ9nfLGpgDdEEha8BAhHM+SgSPHyEj6aM+kOs/ClkvEt3B2nY20vE3ZwXiUyQeKHhLu82DmFigEHSlEqxY/SaEFYxXY/e8VLhG/n/qRuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLAH6d1A; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLAH6d1A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655140; x=1806191140;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fOj/tbhJKzoxBb404im9WNC8YElONEihRBhUxCRprto=;
  b=JLAH6d1Am9iNJ6sEfQcpm/fma2UioXZPY/fXQ8SamtDGxNQtCo2NYVux
   jm8RDIhd7+sYUDYzK02osTRi359uNhx2RItFyEFoNa6DrZy0gqTWf7BtH
   Q/88jnL7cymudslsRZSzDkSACvxWu05vky4lmFnogHmfDX7ElK7uiKmAE
   YtLQ2oOWR1pTFnVennFL3H2nukUFwCJRuOi6E5cZVuPI85WCbb79FTt1G
   Z0RY9oMjInzuUSHuEUw4XIpq1g8095acrjSg8sZ0yDdCd81zrtjzdS77G
   wwh9yhJ8OO7fAZSQFwoDR3bAt/5Sj1+9qHTaP63QYajsJJm2vpvmisAeC
   g==;
X-CSE-ConnectionGUID: 4XdFEvIPSNKeJj+1QpnZdw==
X-CSE-MsgGUID: hkspqyGISj+LgK9JEQZFYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="74917262"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="74917262"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:45:40 -0700
X-CSE-ConnectionGUID: W89tQk5UQoev3g/wZXI/GA==
X-CSE-MsgGUID: 3eoyIqXaRa6dyx9nTk/a7Q==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:45:40 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:45:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:45:39 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.6) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:45:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YrtrU7W/5EYwiiDJoVEj1UhdrYCZiatKL5ZtjeTsFkSPxa98Bx48UemmUwO2h4QNTfZ3TAmjVPnqRsfR2FZPIvRhq/uIYsXOFAm9yr7niHesTEHxoquTmEjPaovbuCvHDFtjzu2/VxPdCMSEda6Mon934WQ+FxnxWi30UyRVBRoWZq10sny0MwQlU9EnudoiyTTE51/UbJWV+IFPBML4oXG75MgGTP0vbmMsqyb+EJJfrFCDbpMbn+LYGKA1S/CX6T2hwdqnUmVDMrTXWs/58981BRURZeRyCHJhCE5umaWWMgWUkxBjjRt6uESuR57G7IvYQDE3hc4+IhjU0H2MoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WszVEpmsEHFsnMqthT02YpYdqy1C5ew8uD3puvgDlpI=;
 b=akcnrJJNQTPZVUzRj9jsiZK0I52RSLLrBfwvov6HtcyIxfiZMd/GPo/JzE2c2XhdAflDmgjwLhxWftht1wuBGwidl6N6imcoiVy/oJDQodXp/s768vy2CUFW9qAZ2iHFnQHDjhQQkO+ok75xvEozPDnIpZjdRk7pBE+U7/RQEi9aNbTs+GVxox9Qf0EW3tf3GxiUZX4uZFJ7NLnh9uEDVmi3wlPJx7J3axs/RoLTnT6F6nOp3+8WdN3fjhqjoN6arFED7mdtK7+Rk47G3C39urj0pBr7n5k26poPGTKq+PDU0iE3bLEuUh96r//88kbSB9hr2JN0RuwurX6HorqYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:45:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:45:37 +0000
Date: Fri, 27 Mar 2026 16:45:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 4/9] cxl/region: Constify cxl_region_resource_contains()
Message-ID: <accWnTzh-8lNuhXZ@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-5-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-5-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ed21cb-d5d2-4a39-bd68-08de8c5af20a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: S5523AA7jnYJrjkU1IU2jlsDPzQ/mSzqKNqb03l+/RZ3w79UKIq2filUcg9mHUAYnMyhQgjBQSIxQqp3vR3F4iiB/PaueQG7AD6M1h3MHQBclf53Nr0y0jsU0UYvEM1S5/ReB9cQUid4EtpbKgs2bj1fKHU84AFlwwICFur+NCnKME+y7szzIXBO4xBrmZzFOgsI+oeEYaEz9M4eCmq2T3ZLfGA520izoIUH29f55I99webBNH3qFwkyMQrPqNBdexSK8HV2A1xwiRy5p4OEpbmb1jDsxn1kSnSdyEYXFnR1V4FUYiHZXDOuBQfl9XuVrRT9u3uEqMMjpg0jKT5EvfDW7hsUJ8b5qHM9p9ciAezn4eFaFvtpVlvFOML28u5Pbz97woQ2VvDMxHVxVWaXFbhigUtM7g41vvb3++UHj147oqq+r8Yz9yyPhO5asX6I6gbCoplEJ5i21gWOOOpS//NtMJRqF/C76xhEuIyPvDWiv1+T3N/RrwjU2NNQTO1C3p63/J6GGFbodweUSa8AF65m4hsCLiMZ8qipB7eYtRpelRO446Qyeb0Et3ZfLCHNavI8la0DvxIViaOnoCIulrEf1kAbpJu5rRNSmwlCgA5pqb/hCbEjWmi4dznvGE+XnKiqzJXSMRK9dwrhPKb4cKgGNdCRJLJpgnM/CTGyu7vhsDs53qzhA20xjy1vEU6XtJL+4maXJig68QD3Bq/rnuIxJH6tzNml59QyphRevSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kkpr5LoKPp6RyijpaoNVHdKEY9gPHHMasyH7rbCGGNqBCD5w5v78t3R43kIA?=
 =?us-ascii?Q?rVY1WlrxfAgD6ijMF9EqyyAYzrC4iO3A2A/nNMb1Dx2FRR5NlOW5Az0nrl4I?=
 =?us-ascii?Q?ZheRLx1ju+camSxXYJqTV+KaT3HaRqerjkynrKZR6CVS8//tuVwn2j8f8SXs?=
 =?us-ascii?Q?TUgIH6enz0R6HTOXhFnJef5z/i7MGMGcEqBFhalZjCaSZIZ/HPlmjCes8uOn?=
 =?us-ascii?Q?G2SdP95TdJwgceleCzTiI8iS/uHk4v7Szjlz60USR3bgDZhB9KoUd20vVEy7?=
 =?us-ascii?Q?KGmagRCHk2D9690ftABT9ZYSxKU/ot3gjsXl3MGgEAvT3Awylu0MWe5ObaJp?=
 =?us-ascii?Q?+uCD3ghWM8cLDf4tkT/ck5faMzITcuwl6i7xCMcDyi/e9Up097Vld4VQAUUo?=
 =?us-ascii?Q?giWCA8l61tlxAkrGAL4HUKAIMTbCKzhL2KlujKHI3fA4gI3oKjIRUX2J4xqe?=
 =?us-ascii?Q?wkjs3TBb6lTE0EnqMphD0vo2fDZUhElmKr+EAnPrflMdV+im4joH2o1WHuxw?=
 =?us-ascii?Q?SAzCgbSvnTqj/5aBoR1woaL5yHLyFb1+ERqrpwVlSpPwsLV8N30bD386g8xp?=
 =?us-ascii?Q?QUPA+d+iGENqqWe4KcsnXGNPOc2O4QN4hMuT3o0CT7/VPbuu+SyXv34+k3rK?=
 =?us-ascii?Q?7gZ/Ts+CW2PbfEpttD/gcwiyzxe4lteAOzzHX7jxbuUx1yJ27VQXFgA9TnHz?=
 =?us-ascii?Q?KKNCY56tU5m5YQsuG544yBgQGVfA5HnJs8ToutKtUL0aX87lPITcOO1zcaPw?=
 =?us-ascii?Q?MOyVOKOWXoVBdwJgdjfwgvKREt80J0lCm6AeBujMqv7svGuzp0uKwL/1PwEo?=
 =?us-ascii?Q?6tARDuLwI6rPJi2QwYrivpd9qqYZpBbfyuZRi55SJa50drNGXWkjQfBDYWV8?=
 =?us-ascii?Q?Xoj3KkaXcI3YUPm1XAudpBGUE/8ItI6aBGmWGi0P1h9umMTiyuEwthHjmy/9?=
 =?us-ascii?Q?dPQbfTpd4eYTGr6p+pxny2MFO7z9L3tucmRuSHDUUjM38+ySwP3FSJE3lCEF?=
 =?us-ascii?Q?7bAFGsfDcnOlJrUR6uKIo6NkhXSQFtekhdO3bXy3XgGbcmzNNlurG9z48iTh?=
 =?us-ascii?Q?5WYbF1ociWlMG1mwfNBmJXb+AXnEVUcEsHFn9UfxVYT+aO538xXwCaSANDz0?=
 =?us-ascii?Q?drc5ZwyUaCx343o20PDlTxpFu5fbd8rmviC63LBsobW1PbMJvgWDlOogW2pl?=
 =?us-ascii?Q?qOmH3QFYl+uC6UlyMzDmuppokfLaVE1z+6Pr11pqBbzFy2nIP6YE5iNp6FmU?=
 =?us-ascii?Q?/1fIjX1qKiTdiM5M86BScqNAwrpxsJIGTrVCAWiDdXxrMnqMhsnKxpT/0J6Y?=
 =?us-ascii?Q?enEmskidtQE48caGBlN/qaavWOVqeALlW3U/3cQM49COjM6ttQEI+Lxmj6Ke?=
 =?us-ascii?Q?Al3ZwpOZ1r14Jsw57UQomb5okgP4Wyd+ML+sC21+54nNV85A+Cu7FAJAbNG+?=
 =?us-ascii?Q?HnWGgkh0Y4f9QOPeYPhKZtcICKCJ4BYas3aX2DuQJz2ITrPPdWsvpYBQ5s7P?=
 =?us-ascii?Q?7KZEvC71yW4U1MHw6AzGBPnpE0D4UaswuP3coBCKSglIlD7n2rb9O/Jp02fF?=
 =?us-ascii?Q?ArBfXv7aSp9NjR7IaLBhirfvtVW9bFpYj57M3/f0oxPwb75a2CC3L4Uz6Irm?=
 =?us-ascii?Q?P0sSL3LQdGhCOig5fdvwi4H5cYYWV3gX8QiYw86MJX/sn3luSEBVA82bgVMo?=
 =?us-ascii?Q?anaft3PYO48UwSYm9XOs0uCL2P7RoPqWd2Er33klnBfXZRrMaLA6HGXHWR/2?=
 =?us-ascii?Q?ZbS84qbRe8DPgs/AqJ/hczy314CNOuI=3D?=
X-Exchange-RoutingPolicyChecked: kdRBEHPxDAgHdk/BWXdpK7N2VeK1tH9/L01TAHp7SgK393nkKMVodKWqeJoII/CEYpTEz4LD3FEu7HW5ObkbPO0TLDVF5ffkYkSqN5rkRUDoC7D8hNWmZe5Yg+qIsej8A0cN4IayaowqGFsEPekB3efKe+55wAsTZ3LHcWJXi1ANcKCFO72+WoPiP0IQUsS+P9ZOOYpw/dC/i/ZLxrDkTdlPmoXMFyXJ9xuNiE9j56UQWv7x2ePMg/M/sMwHu9DP/hNnv6s06ttJ2i2tPBX5OxdvD3gWrHqTgNpd1H1+xKjZjEL8Bsg/X9ZHbzxU4QpWNZsxnzKF4ncIGZc+jT4b+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ed21cb-d5d2-4a39-bd68-08de8c5af20a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:45:37.0142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbRcg8n4hOVvIL1FHQoKoV5eZQxl8I2JTAqbliHN89Vv3sw1DVacwUJ/SI2DI/vr64Y+4gESfxIWAFQIVzhnY89f6f80zX+SyYWsKa2jQ2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:16PM -0700, Dan Williams wrote:
> The call to cxl_region_resource_contains() in hmem_register_cxl_device()
> need not cast away 'const'. The problem is the usage of the
> bus_for_each_dev() API which does not mark its @data parameter as 'const'.
> Switch to bus_find_device() which does take 'const' @data, fixup
> cxl_region_resource_contains() and its caller.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

