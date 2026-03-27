Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC3431F986
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655175; cv=fail; b=XrdzIa6Kl7/TFIjhIFHVKjIx8613yEspWx/kHWodUjLSaXen4ANQEWw+9tvuzAFw7AO7vZqKo5FYBTsazDzGE899N9dmgDLLQnucWFW3QikmazsvgYG+7GMKJvBpfDEcxKG7GNh0+VhYyLCMIhrD5fESIo/Xuf5U2cBvlBJYxxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655175; c=relaxed/simple;
	bh=kOK5vojXxNQgw9cEzU8umUxfLv+QsIMWBgptMifE3aM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qhy9DfVVSbyJwBlPSHxHhO1FeVDDLORYvbl/JHCWbziT55aLCoPIEW4TP7DGCpz/L0I5jEuJplcWHeJrTMEAyjzChryB9TCUUE1Aygqaz2+Dvn4yFyVA3lhc0kk1ML+W224/YDzxLTtb+bB98gprENGZ3T0uXYxDaepSKEzPRQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFw4v39V; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFw4v39V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655174; x=1806191174;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kOK5vojXxNQgw9cEzU8umUxfLv+QsIMWBgptMifE3aM=;
  b=lFw4v39VT0BD0jd2DfJescXAUtCoEapq8RGKGqSoWfXT3D2kknv1NLp6
   jJhdjoXydORHJX6AXDk0zziGmnhk4EObKl85X98XjwYhavei/wRqa0QVi
   UvfXm0N86uQXX5SruAhgjmAksrCzuoGXrWOuikiKootF7ejypp85cmhHC
   Dv4N1RnmFdjYfTJ/ed/qX+NdvYfW85mpEm3OqQ+TdJKpnL7BTWJrIkR0J
   OHwTfQ+qWFkivuOGs/pHmmnYUdH1r+/x0G37nXhYECjJhcuz52d9Nq8W/
   QRkFSluDofUcggEM6b8PIbmvGRYqfLSQD5suvVfGnetf5HhH3BZ9HyZyY
   w==;
X-CSE-ConnectionGUID: JulPBTeXT3u/+9BJ4nJBjQ==
X-CSE-MsgGUID: ot2dTf5bTlKH+PlJKhhjig==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="98349503"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="98349503"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:46:14 -0700
X-CSE-ConnectionGUID: eAbv5SYRTx+sO/ummgVs5A==
X-CSE-MsgGUID: foWKR4GSRv2cPpAnZ5bm7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="221057155"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:46:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:46:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:46:13 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:46:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iw/LPng00r7bP1KmlB96u/lBXBBs3ObPVGwxWtaGEYLdpd6nGLn9OMuLE8W6Gjfa9e47cKOQ+Pd5FNXQXPxJvVGshG2iR9tBv36TdmjFZH1m/cSWajJjyKFeS9CI4Au7IWHEPptqmZ8hOTfDi/E0zV2Aw9LEYpepiVJid5f7XMA4jCGisGHDU7XCoIetWf2Eu5DnQtisi1DrxQnzWjYswhucpHqjWqQsJclB6M/iZKbn+oz9UOcaaSmLeIzttDDeR+3usDp7A72RsMMakqLW40qoKINly8TqjegOVG0dLWjVd1M0R/h90K9kE2ECyQGmOe6KVeVxUF5EwPFRVeMcZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0arxAJpoq5puzxpMcDw3cNr9hRbXlT86rebm66baI2A=;
 b=MyxrDmnNjX88AKwBIwGcOYVSvMkbVsj+S2WMtaNN6nbW8KPV4G8zGJMNrtQCjBJTQjB8WW+7qvJZXdv1IMyJv+05iH4XudPEDSlWfEXaS2w/QFCYhNqvk5wAAxvzjeFnQ+rcFpzY3hyFEniiJ6UercDw81a4pIsQMQQB0kfNSi6qClJyRd8ou730tFNehlLsX2GSI2hKrHtdtCxtWV7tgZXVdfXHo3oH3HGaCsZxosjyDGFD4dzLCt9qik0MV2UL1onVmOZxOGGdk9t8elINV2zYV2xWmtlDHlS3GwGbazK5JQfSj3dFS4edITeJKUSOZZI24ZCX1ZTK7aXijRVyaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:46:11 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:46:11 +0000
Date: Fri, 27 Mar 2026 16:46:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 5/9] dax/hmem: Reduce visibility of dax_cxl coordination
 symbols
Message-ID: <accWvx4iTcvcaNqN@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-6-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-6-dan.j.williams@intel.com>
X-ClientProxiedBy: BYAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 08aa616c-c27d-4065-3faf-08de8c5b063e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: iBN/54qlBXCbzJ7syrVsbfFN1UNlV7RrXdHaZXA7gnsowVjZT/898Y1zcdUrMAaiazmaDhla9/bJCnPqUSRU4YeSxXECIGcIBXY9d3WuUGEFNI6uhW8T1DoMZgneB3FHnIwgO3Tso5W551/6xMFxitchEM7aJuU+KS8254VBPut0VFfjRdlLogL2jJk/a1tfxBuYRURMh2JA2ungEj+A9kiDxmJ2bwjzst4XHx1xIL3Ov76CsXEvQFV1LJRgSAiKSdnvlAz825nCEHMEaej5glbPyP6hoIXkKrQKkNlyd4fAU4QiZ/Iq39F2MVsDSkkn5pTA0I2RoczbCjAvZau9wzkXNuy0uLirDSFrQEfJQAg5McSzNnPBIbPTQNbXo+Gz+CI/OIvNxS8f1pz4/ZOLrAkLS9cRXVPrEdyL76TzGanPu4FN6osXb3Zhzob+2zvURhFdOf2rXDQ1lBg+RErvRr/x6mKDjWGKKpsCukEuAYgRsmk72TH3jnkG3m2hO1WSBX2P+y6BjTxEhGdUUpxjSC64qwqZgEb2coWFNreg9GxOSCOw4ChS67v7e+Ai9rQyukXhTEG3IhSub9Jbsl3n3TmTU1Cb8AzW3jcVh8lQLf1TCmxHm9XXp9SLThLxQdNUR+6QM4FVGgL4tss/a6RizLiZHngSvtqDEKlsngiVYYqPLFvud3peXRdEos7ktkKZO1bTV/voFH1iGvrMc7Tbdxw46+9CHwH+Ok+0HtgwkRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7I68syTeAVl9S3FQA20c5R0z4c4gHU4jXp55ls3akdEvyLpBWw3zU/sDJST9?=
 =?us-ascii?Q?y9gnM8Iq/UXB68tMz1LYqLgu62TarKote4LEZdRSH/GlbD5BhmLPelZclcSK?=
 =?us-ascii?Q?aqMT6JoSHX0DjfYY3R6Y/Gcb8av/ARNcKU0N13vA0KlKlW9CCAhyeR6aD9X1?=
 =?us-ascii?Q?ggRxsJcGRNTl63HVEUznTGLvOKl9RuWKRMhkOFwQGk+YxOBGyVbIf/OM0Zd6?=
 =?us-ascii?Q?1WkqDSUG/tLGafc25hBMlLGCzLOgSfNo/jeY3IntERmAitBubArclA06d2JH?=
 =?us-ascii?Q?A+KGE4YPC5z+XPBGwb/giT8Gq5S7mn1u1sWD4XHnncHZLkoPLfEUrE9lcny/?=
 =?us-ascii?Q?N3Yk8+SNKer4n9bsDtYUbJcZ0sHzyVcCLiVQedtsWgeVfWvwbIflZUGfTB/v?=
 =?us-ascii?Q?4Tuy+CQW80DQJ5nMf89j9YKDq2dHcwnhDrpHOOKdhTyy6CDU2N0jku/YV/Yt?=
 =?us-ascii?Q?W886Ko4kiyljdv9q7XumHIzRTC5CFaoyqZcMdcYVZatE6sDCePjsL3xIHkKJ?=
 =?us-ascii?Q?R+SUl47QB9KHR8uc8d2Ad+K5bWkMinZy3LFCQVK9frkqLIhh8Cl1DArptVNw?=
 =?us-ascii?Q?96pu147/5m/TODDMjmo6FJ2PCf45iZvbeCIM+9vsxABy981SRGKMvudiXpXf?=
 =?us-ascii?Q?eYOwZ0tqDW9o621Zb4T7NyCCvp44dQ2gqm3Wm0i2ggK8EOp+suxVTsrHdgX3?=
 =?us-ascii?Q?YdWZR1CFdEral0tQOkmWgS/QebhyudX2jl4u7jImyNXsZagub6TFqeoikAO9?=
 =?us-ascii?Q?aGZOcymYk/vxbUsv5JKN9GjxE+jQp2oUQHZFFEfp7tAmAT2Nfe3nn6OkYkGt?=
 =?us-ascii?Q?XUgru71I7alc0tVXIAVt9aa+syYnoxzC8lG+NVwPFWD5hkJSSmYGGQnhgkFy?=
 =?us-ascii?Q?oShewoYotO1rWLfymnZ8GMXo3wh3DgiS5Yhy4G3mYArffTcRWqF0G73WeJOL?=
 =?us-ascii?Q?JFJINb9dQnhNVMfS2O9z0lX2h7fidkXdscYL4iL/zdcgBjEV7s2tfs6vtGmS?=
 =?us-ascii?Q?nxGrnq0epUW6E/6EW0xcZVjxO2nIy5cDLE3rgewKyRcpvRunGc7fqS+ESm1d?=
 =?us-ascii?Q?mYAyji0LbX4Q+GKYtrbUmjRX4Ao6FiizMnEFHsDolcLqdvs1hD/hGOtss24/?=
 =?us-ascii?Q?Tjyf6s/Fvnu5eW72O8swJuJy1ansxFKqYnYrwhKar2WqIjhbzDjTZWoniMMq?=
 =?us-ascii?Q?awmT/VaUfoa0+4dmRQDfxbkcUODRMsa7/B7sWGABtKQKr+wj8I9uV1tvkGC0?=
 =?us-ascii?Q?E0tO8zlxKBEMPZKGrqVAy1ZS/E6mkGlsHT5HLrGQjEmycKf3yBy1GqdPQQmp?=
 =?us-ascii?Q?KfWpTDltZPUN8JEK1EX1SstxSb5pwZX9uEwXQ3w29sE7UeFA+Xe7iWwuCEfS?=
 =?us-ascii?Q?xyB/LiYuGnDUmHRulTe9MITLIZotzh5JxE5tPexHaGd8fH1M5i81cSFxe+Cd?=
 =?us-ascii?Q?+A12U5kk2OK9bs3zaVG2juFRDSdvNquqxa5jmVIeXVbMmWS+rItoqRuJyxdf?=
 =?us-ascii?Q?X+Ukpg22QBrPJU4nqCzMugTpiNf6q9rzOBgobHmOwMeyme4Qp2n933XZL0Jy?=
 =?us-ascii?Q?UkaQkQMKC7npZ+KX2sb/u2V4aYxPr/cikBnejDbH2DJLRDlqMwhMyD+SlHLR?=
 =?us-ascii?Q?EyGgftTvG82RN/CiI8FWXa7ifh9szWlqG4pm7HnU3l6c/btEY3vDkPVBWB31?=
 =?us-ascii?Q?t8/1ZPvJQjactjiIc68S80F2uZmEmRf3GY6kIn+O7aO39RC/pLe2oJeszBVf?=
 =?us-ascii?Q?9RYeKsP0nHMiSwSLIz/2XRh3F8Unhk8=3D?=
X-Exchange-RoutingPolicyChecked: kXkK7ND++cII1ptONKjJqw+Ke4pPcnBonXC56lYMePNzA2bMgg5D7v9H6IclV8bXR4h8Gx7598/jX3GXExciK5oz7WLX++nxUyqpG+R1v6Vww5dQOJ4k53sVt2NbBqpHXDnnTCaaRBp9LPE7vvMu++tWX7VfxRiX+vkLa0SZyGGRUHiv0LuictMaDM/F7yO+avw560Vs7CBFD43IO+ZpL8oSHwR6UuK6lBw5KYzL5pGyI0s7EUzPvJa6Q1wSWtwvvue/UGDlaST7WC/4NriO8FHwPKrJame/FG/nqtMHBRfYVw/pvEnPyki/GekIpv+CYJRmVzEU77zzKUvFq7qXGQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aa616c-c27d-4065-3faf-08de8c5b063e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:46:10.9270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSXGEKdu80/EuiLapRzQ3N1gcZclLcElsBHv1pDm1eV1+B1+0SGC1mEUlCKkkjzIqkGZIE0EOIsfrdsCV44vnXa94MMPknOaNxTUX6QXYg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:17PM -0700, Dan Williams wrote:
> No other module or use case should be using dax_hmem_initial_probe or
> dax_hmem_flush_work(). Limit their use to dax_hmem, and dax_cxl
> respectively.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

