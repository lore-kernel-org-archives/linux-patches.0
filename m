Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6AC3E1D05
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 22:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909371; cv=fail; b=MD+AaeKibst+rg39U+Lsfi/XW1Va21E9D8Y1kPQ+Z2N40jZpS3+7CNNjTaJZJQ4iirXQpNzyktGhY0lBo3gs9AGCbaOeUQXbc3b9KSRhSZ7VhbdniU9doFV7z13Imm6h1HU1nmT7xfCgkX1BxCjDPzK5DpGTdhEWO3I+fyoUnSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909371; c=relaxed/simple;
	bh=1HOxsAaCspos02zRFv02oBoBKrTbxPA6RifoeFvAHJc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cl65r6+x0stsW4ZwL07akO3a/1nAnP7+fJ8DT/CnikxjdFPxnwDNSlITltayNQGt/JK3jheUyOA9O93eoP5oKfwcZxp3Bn2C26YUTJP13IT/JNEtzZze72mZlIC+tKjyLwwF2pDH+yhJe2J+KxY7lzN3I7KfBBk8PmepNdXltDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eqbpICwk; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eqbpICwk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774909361; x=1806445361;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1HOxsAaCspos02zRFv02oBoBKrTbxPA6RifoeFvAHJc=;
  b=eqbpICwkkUouu+15hixEu4cMMM5J/NxvRhTTbIn/NazLWtvxNtZlVStg
   kIAv6J9fanu5UeRCB1LDDbG5q/41+k9lqTEyQY34Q/vgkXfjvwMd0jAak
   etLNTqtD5JHldA4bdJYEQrJl/dozFFQCwtUmbeBAMLabMznUcT56wwT3o
   PQn/mIPZyqCcYH5/yCxlxyFqr4DESXBfQhchl1qWUFhmktQzcIfAqgReV
   PiMU1MjWGYJ3lebN6deaGOyXnGrEZQmeCADC+QgJm0FT1lm5rIwEuIiUG
   ipjv8rEEP3fKyn/xa5RkUxdch7IcGWxl7e7cc7NQkGfdlYhhZSV92X08L
   w==;
X-CSE-ConnectionGUID: MR8aEWLoQpOxJWKWv7yCtg==
X-CSE-MsgGUID: JNWAaYLNS9iwh3b8cRj0QQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="86606238"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="86606238"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 15:22:39 -0700
X-CSE-ConnectionGUID: Nmy5lTgeRja6shXXSeNQQg==
X-CSE-MsgGUID: mKbuy9CiTEaJrZvztXEGxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="230242413"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 15:22:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 15:22:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 15:22:38 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 15:22:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/hNYoyby6R5cu5c6XGeHHt3sje9oEKrQeWMpqX6g4aS38h4lvn9XSsRg4K+1N12z5zBacFXn+eTwppwmawz/aW9cUFRp2UXRDOzhTM8BpU8Gm3lgV5Qb3dwD56++Ba7jrWCyVde/5g29IXFdffVRFYnE+4+dHXez+kcj97hPkuCc+1fnI2qc3dkBgF+fJ9Ad4VM6+Ba9ESJ2UyeqHSDH+enlt9Rb3Gw9HNVbcoFnMVwAWXexu4GyOVxpU2Bd9hkv+Nm6JoqDlQGaBW4lpdjWwIs17jPg7khAjwc6ScT5F9kcN84czv2n5qV6QODFFh1QUXTky3ap735XwUrMMApjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHX9JvUpDZ/hSKlZMl7z0/+DsZjN6Em8FAqAt8UiNFs=;
 b=frID9kAC1f/C2kiG1RpdXWS5dOYypQMIwoqtjo1A/9BXo4EP+yZnGwAyaRhoqZRKx57Ke798HtM+gFb0y0WHeSNZ5Nz0lIJTuPCdLgCxIWPZ0YklU0y/ngcegtF3B86TubUHv/dl4O0yLt/tIBJny8nJIT9Tc8obelsiEGyZw4+JOuo8zCeV2r81smuWi50+Ox4bsUHKO8W1is2FRIr73YGSDaQg6p8w1XgfZez4apHyzAtTsmKpmzq4o+zdffxxkgWAvwla2lyJM+mb+Kt8doRwgfUisfaguOS1ImXrz29HZwxdUf7O/dsxxDfIGRUGMGe6B4hsRDlwFUvmUA1drg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH3PPF8B755DBFD.namprd11.prod.outlook.com
 (2603:10b6:518:1::d36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.14; Mon, 30 Mar
 2026 22:22:31 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Mon, 30 Mar 2026
 22:22:31 +0000
Date: Mon, 30 Mar 2026 17:26:20 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 5/9] dax/hmem: Reduce visibility of dax_cxl coordination
 symbols
Message-ID: <69caf88ce4b4_17924f10054@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-6-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-6-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::34) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH3PPF8B755DBFD:EE_
X-MS-Office365-Filtering-Correlation-Id: 675ee5b1-35a7-4ce3-586b-08de8eaad5c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: NhwT0CwDuuRIIus03EOe5Tl/36WFzS2r2taOKPOssl4F7A88RY6V+LmXeth7EjryIAGzRySSl6P4700NiyaO/X2425d9zrqioo11ylMCsGJNZevfFZMJZgAXn6pPE4p7m/pSo3nLQZCwzsZATAoo9q+Terifeq7x5ClPbQNoz5uDvGb92IrTDWiuIc3YXjrBL89eZ0mAAJwff2AIF31Y/V70rZjyWd1Ya6QsPF7lDb0VkdDipoQE0EKNB+D+s0weWJTjXdL8e/LJGYEuLyLEYrXC4pvje+edfA5o7tQFfUkuVlPZfuCnZUcJzQeP19AcqV9fg00aeKkgUQ7x6IN3ui0Th14GrHLK30fPuDEAtr+SsLB1ydB/bzuQkBmVETr6G2t2eY4HIMQzqIMF07xNG7X5a2+xN/DeqQjaZNFmlYiJksQI2SgVpJfRAE3kw3fJIMgbWmMDw4IYs3oUJFjYTsPYYP1Kfh86s7JF4Ag24iHJV9BmrdwUCzxEaAdLevKDmkrirGp3R8z8wzYYZVFygnk5O0ydr1mo/yinjrkYOcnQVGd7K01p/waqHnGbRqi33rV61Ol4gAa7jQTPZqqptZx9pmrSgvMPs3KTWJHqWKedayMhj0Xkbb82k12RGnLVy7Xf/lsyFN8egMIFFwu3VSmL044Uy91K0Zg9gA8qzRHXdboigysE9PBrNK07oXh18GikCwX0rLXdbjfBjZJ957WrNaRsrYdpwtF3f5a9C4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NNTD2dAAMSZKBMkL+UdoILUDjigk4bHXzGowXUJrSaj6N14PProQ7jzBpkRi?=
 =?us-ascii?Q?ECOHrgDydKmUGyuiaHceSUMS3bFS63+DwBrPwyP2dEFDrWLrH/uVJUp+xBsS?=
 =?us-ascii?Q?NNacPoFnhkpuX0O5x6xCUQgtmkXVJMorBsC6afpW/z2NJ+nfCLh3LgSImCay?=
 =?us-ascii?Q?OFxumCeno2ukAe5+QIQZj35DTlBv8ItAomnFNA0hd9PhTO44YQLzK/cqFaDJ?=
 =?us-ascii?Q?Y9jg6du0lST1ia2qVYl0w53LecJJ4HiEbFeUcO19BemTcyHiIE4bGz8TBhrY?=
 =?us-ascii?Q?hT6BJ7vxs2A2/JA7tQI864Q6Vu1A8L4wK5MYdkE4ST0V+4XOy8tZYatZA542?=
 =?us-ascii?Q?XIrW2APVOqTQLCHNOfLsBPXnAcoC6U+DXF361GAH9MdRsbTt9hQ1FSGFzHNl?=
 =?us-ascii?Q?/sU7wj+iUBiiTSfYZd5joFB4rDEdqQm6Jzim9rvcfQrREkr/zlYPkpt18YXM?=
 =?us-ascii?Q?ogBj2wjDrDVN5IfZ6+ZDVywsfTJUQBwz1wWXvMSqEMIBZrDkL/z9P43hH7ky?=
 =?us-ascii?Q?2QUuTXkbkiFLdLQDG7MBByUY9e4joilsv9BwHbnHIY33KDhlB6iQYLoaQGpt?=
 =?us-ascii?Q?cO5VKLXwOXUuzCBSwr2FHcrLoQ/WjFEs3pgJbvG8aFEYjzX24k2vZXtEfmCi?=
 =?us-ascii?Q?xrFf9TCgtwSTEOiA3Pxawqbo3P+INW4zEFsUaL0I3fDhsO9ZNGzaXA3BsB1D?=
 =?us-ascii?Q?wdnaYaPIEpUTEt7k3PuYYd+1CqhbmYLxl/1aE9mRtfmcm/Eo4ODjiLzZK5rN?=
 =?us-ascii?Q?u2TZyDAm/ECdKvMPONzzlXXUzeKcXAImgpNQWLCYEWpYmvuYdIRuq9n62Ol9?=
 =?us-ascii?Q?SG0rz+EFEOHsmKWgQtV18vFDdLAIFAlVcg0MsZi1uLG26CSTBNgAex2elcpZ?=
 =?us-ascii?Q?HtwXe4HkqM0hetnYXqiM8JZqacF5yLoaPqWpoFF/dcud9aGVf1IvprwCgbO+?=
 =?us-ascii?Q?f2+ZqUg34dGhuLxOJGYeHkkq+pS9OvBtLwccKxFGRvr5w7Vke7aNuzUVcR6Z?=
 =?us-ascii?Q?1+8WXAUsIfNbiUTsaqRgOP1ed5z5XOoXX0bciXHJSk8ms02XYqrg9dW46sh2?=
 =?us-ascii?Q?2nE8EvjmUjFmMT3roFEeeBpOtZaMO6Z1k2jyFTkhD+qq2tYT9pXfZt7vooqo?=
 =?us-ascii?Q?9A2tifHGS1VVpRrEj5iRIZ97WIk6Fcl4fAEedv3XqQJT5XFIBS7GVEdrAndb?=
 =?us-ascii?Q?sLD0RXZGds2jTPAUtNloEfDdjP3uM5Oy8aCh+YDMrkSngQf4eMC9esySNTWL?=
 =?us-ascii?Q?ydCmV7gwuNp7vBWprNmxQYlnMn/hyyfCWXquHF1xJBL9nZ/gTkxjvdvoB5C7?=
 =?us-ascii?Q?y/XYylViAzbJUGBNa3D/50E5pDJWzfJBsPq3zToXruIE9yT6dQ+28iS/bEe6?=
 =?us-ascii?Q?CN3sU4oOtCsJ05kHnVoX70uZPKDWDNAXm0DbA8K2Tw5EKL9stcN4VJIQHBrP?=
 =?us-ascii?Q?o6j+mBp7BJhPXGLOwhaW3+Cb+IJCh5JTWAglfNGkzTgGkW6Q2O39CjxEsln/?=
 =?us-ascii?Q?DZ7qA0BIdY+AliAhscatPTV+U+A7Dy7XBOqB3t2HEp1TJkqYiMq9ytb/S9L8?=
 =?us-ascii?Q?q7wRHRsMkNV4MU76yrP7wal5gzOR86+G0UD6BTVk0/OgdqTtBoqbTHZJcLb7?=
 =?us-ascii?Q?fwhAeOPiPq1GzHzRfjs4IaxkpVFMlzyrRa5YzZEDk2+vS8DLauOSywrdgrLf?=
 =?us-ascii?Q?qhPZkyGlqRYB40cxgUF04kpORpW2ymVwtCr6Jh24HzkYgabA+LTPcIlWCXgB?=
 =?us-ascii?Q?uJdympZe8A=3D=3D?=
X-Exchange-RoutingPolicyChecked: lQrMhwhh2YjPh58vgbXyzd/cb5NzAuiUd6+kSWGVq5wwIuloFbpkwBqHT9GjwvLNsB/ynHKBH8oGL9L0EcAgNkh4zN+kYzMUj4qZNMY2SyUDl/Bf/8oh8iBbL1K1B0KhPVGk1gogOTRBHhghxPha5IeAyGSyZVl+q2XwdWAdlrRk6SBKxFD3XFQANPVRy6R0xAh863g1jBbyo6Dwwmdjs9zjRlZI8uZfoHfpYAub9okwiHPB8a4G3gem+mkVSKu67ahAHhfV1eH//O2XcYwZL+ZLo4kleaJXqLHyNYqWhZwTqlfnnRWAcgx7q9jZZ/Bf0Fv4ryaD38arolLbQLK5wA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 675ee5b1-35a7-4ce3-586b-08de8eaad5c9
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:22:31.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfVO3U4KdCgwmhjWd7/IbJYgStafjAMLj/WT+K6FfgV/VjotMqXx9G3qe+eWxjC/Q6QQfmlZTEPe1Ci7oui+8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8B755DBFD
X-OriginatorOrg: intel.com

Dan Williams wrote:
> No other module or use case should be using dax_hmem_initial_probe or
> dax_hmem_flush_work(). Limit their use to dax_hmem, and dax_cxl
> respectively.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
