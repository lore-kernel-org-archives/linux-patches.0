Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C81346E5A
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 22:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908924; cv=fail; b=GD2r7liyjgoAww2AjeFQF+/xpeV54xLybmNNL4l3+q6rRkeStxjs4B8/gM2JeYGbHSVxrCNmneOrX1aupc10v62jzfq2N8V1Z0pZech2rz6NT4G36cq1d34NgJ4yjrUH4Bc7NY7bxEeq5Httwz8CNTfuWAoNHE/vMDXLurdUdgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908924; c=relaxed/simple;
	bh=gi1PD7pyUFbWw7vi56W0dh31waB6Tcphl0tDQ5L0L5s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qnG7jzWk1Y7BnSRjYocmhowxIaeShZ1rxwCBANFbjQo6KhjJILrto9zTjPVm0HvMgzxXhtjHHVKAL2smVCybfY8dBXZuMcktN+ygmh+F3W2Qsg7fUC67kjyFRAwgpa4IW5ea0y5tj6IWIkI9Cuf1ItYfFmnGAkSU21iRGwlHFLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6+XuxAK; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6+XuxAK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774908923; x=1806444923;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gi1PD7pyUFbWw7vi56W0dh31waB6Tcphl0tDQ5L0L5s=;
  b=R6+XuxAKhZftXSh1HagCT1HfMZDbyEPGgLWMkfGFOJOw66yu0ej0p+yt
   dUpHFVQ4UMf4ENp+7pDxXTWp9MnYumvm1Mv5GIyG5go08HDbMCD7xzV8L
   t1YYOLNW8/cpIaK2WUCsen0ilf3G6+P9o7q6U+0AVmcXTjE9Lod4sbqUi
   MT5BH1MBz4lC7YdQsM8okmVSDifLi5EMx0DQYUs7S+BnK8OyUC9Z06f36
   RenOmubDFirzIk1vcFf9LguPJQ0mTqxwktyV5jRfql03aEViXCwQNgUp/
   SFbeMenWiCKZS39B/dLsL2pgzz1coyU2yxtQ5o5Pl6ws7m9YxMTf2A1sI
   Q==;
X-CSE-ConnectionGUID: X73vpbc2R9mY/ZH9tMZnZw==
X-CSE-MsgGUID: rI2fMXMDSq2LSb60NBL8qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="86213577"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="86213577"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 15:15:23 -0700
X-CSE-ConnectionGUID: ZDlklasjQ3aP5qjeWTyPIA==
X-CSE-MsgGUID: EA/PCrX1Tb6IsBv6Lb9C9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="221774796"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 15:15:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 15:15:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 15:15:21 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.31) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 15:15:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBjAQXDysVbr6L23BzcsrmgWY/53gJn6fjp4OnPitYDooM1fbEtvzkeOXcPfP2NIApPkQfICBDCISXEAAqEdiFpolN790W8qOSy0vK8xmCCYzQ5RrLh1dV6joBzAxk3uHpMXMoG+1mfDcXhJ5nj0LSFrh+ToG7Za3lK+x6NeZC3RowGvWOSx0RvpTETo/AS8kljxVIHeAMMkz4uGsGnKyW36h31OR4YCQU/fyrg6TFHTMlq9dvU74BCMS4j9rB9dAT21RxzGXk+3vLeSW68nrlZqfIqxKBoHrJzajyVKyVGlG/GnKOKPLU/WchWITdCv7KFy4zzN30+fIQKB8rH24w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQsUGsR/4mNkUAvT78Ah1DQx5wOGoHt4mwRs6m+h0Og=;
 b=YRzcU3mFAKdC1Xo1NA7o83B+V2e5zZnZBJb7waOFkgnFei1u1lD5XcnUJ8iPKvNhbJkdVPYqTvsmNTAwIryjw1c63p50YALacFo2IJxobBxYfi8OeoVN+kwZsPeFWY5kjxjNJ/vNeag06xuz6dXGAuiFW2ylwpfu3N03CZE746MyQI9y2H56uzKs/45K3MBK0IP7E90eQh7W50Eq7Zcj2M92BFgy0u72V0bqlGd9gtAGqvB0pvTDc2trBtIj+qahKYhkoUjb1N3wTGd2x0xyS2FhXFEW47X1nzrI7LTpGyAD9T/MTuwTBW+ZZA2s+LJNufDlhTdkL2OZbFIIMWoTIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH3PPF8B755DBFD.namprd11.prod.outlook.com
 (2603:10b6:518:1::d36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.14; Mon, 30 Mar
 2026 22:15:18 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Mon, 30 Mar 2026
 22:15:18 +0000
Date: Mon, 30 Mar 2026 17:19:06 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 3/9] cxl/region: Limit visibility of
 cxl_region_contains_resource()
Message-ID: <69caf6da5eed_17924f100be@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-4-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-4-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::30) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH3PPF8B755DBFD:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bda1a79-add5-4662-0bbb-08de8ea9d3a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: VUjQSGbK7DPEeCbkOlMvLTud+GylKlTKHO16mv75iggPvhdXpB90OjRXdw4QyFASXnYP68m6L/vN3Ogv6ucBnOcypN/nTsI/shwHC/RdB/weMHNwIT6wOaawp3xpIARdj/s8m1d8tGK0VSJeMHwnNklJ5EbRb1aLz9ZKY0Fp6NkZRfzzAgBPGFc8iUN02784TBzAKASiaY9QKphBn5ly8uUdtlUGqyejMooyJ1kMBLIt7urkRQtiCKSUDnUdk2irMORQCBxyM0bsdxjK8+19RLWAN967lc/qfz3sR+1hvjqDgV7nsTuLe2wdEXzUtLaVNG8BOrPMT14o2iZ3FICocAvDA4/68janBoTVLmzFVVvyZG5fGRMKIG9pi4ZmTBCOlIX0QHf4i6waDpaA0rIvd24t0ADluhska9A+dOxYhCgbj1l6tY5Rvc8ocYOXxyORcX9yAXzzwg+YaA8xnZT8wjoa1SAWtAMq2ViW4sb9XbsVUb3tBP3X3MC3+eOpu1zwzU5zBRZEpm4/7/wz8obTypxML2g0Tt1kzI+jVLELcpJERffq7/k9zWDXo2cBcV20dVyG0FAHu9xxAEUFSek5MJNyrHmJkgR9k0ED9XAy/vcMdAhE8zy0ywvc51PcNhHpEhcYCzaJ63kfteke+Hcb4JaZb/lQV0aCZBrc3Q+dZxAp2ZbMjkXk8vjs6FZCXBV2CBj7nnt5FWfT+lwmBS9DQlt2+wLwWQPO24MORsiJVKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+JZ+yBsZwi69gpERYQSmJv5lxASfvvqQuA0J6nNzCct0Wa4NUk/ssrYIdmyd?=
 =?us-ascii?Q?5uYFJg8rPfuOc16BcaeNd+c05hwTKV3IOmfit8kRayIoEVsymXONU0pgu2Z5?=
 =?us-ascii?Q?+cAoNNmLnECD7n+9g61PfCWFIHP+siimJGmEZrOzC2uBI1QRmv9oEs30mr+R?=
 =?us-ascii?Q?u+hJ7myz8dJ5QB6ClDKIlikeq9SgAYepemXzPM+zUOyZTnLXzG+b1APKXgo6?=
 =?us-ascii?Q?Tnm2u43m8oQS6bSPexJFvgbFvgvhT9oZlZjLULro/TcQ/7RxHcp3AXkBUU4A?=
 =?us-ascii?Q?wKKER/wzkV9v0/arYwhCySX0kv1OcWm/3PH/9IbT1QFDAVE1NebpA7IQ5BLM?=
 =?us-ascii?Q?z2FaLnoTEWa6VGwjf3UsEAMRdDbNbZnuw79pO091OdWdNz3pWkXrGYBodQLw?=
 =?us-ascii?Q?G3dSlyTtbKFto03haJ/7yNTOzDSXWtllD+7deQ9WgIzyrB1lQUF6ESaGGU3g?=
 =?us-ascii?Q?sOpxbQbtYzSuIZPHz6zCTq5nUbuMB9LsXcmb1digErqtk0l7bcwT9+55opyR?=
 =?us-ascii?Q?LzCTYClP6wWQNvpTeV4m7tNrmTwJ/SRCaz2jPd92OGdWnuiHoX420aSss0Md?=
 =?us-ascii?Q?Rcf46vMnT9F+y1Sj0/j9AOarcbrzRyDAiW9GtiOgkN5Eyz9M2F6ye46IkdXs?=
 =?us-ascii?Q?BdNgjEq2arZ1/OzxBMhGv0ObWwZMxVzFNotT+V8+H/XjzdPxFSZPk0KetF5r?=
 =?us-ascii?Q?ts6xymJ11BwezWL8FB5duRZ3MUdRqYDvs2Wlr4WHzBjh9RHMPnFo4A8Ktu4e?=
 =?us-ascii?Q?zUfOL/iJ8YQGajOntBG0V1rcqwOlmVw2Hi61E9UmVBm9sM5UuWUSraeJIEst?=
 =?us-ascii?Q?ykoHNMg/mMlHe1yPNkVN5bSzReDNzgcD0nUPSoSlfzF8XO9RW+xJ03m5/gbG?=
 =?us-ascii?Q?QQn5Xv/6kYsh5EoXndpxc4ZPg4aw6oS0KZb59ryIhA2kJgauB738SZqbsAKn?=
 =?us-ascii?Q?0BpV2eJ6ezZEaN2IOYH07yKsJ/0s67JjEEt7r/MWfb0ErAP1J7pk60547/71?=
 =?us-ascii?Q?n0kbZF/FNReRRIs7PNN+/BhjKsFzGqKY2NV988CyC6XyRsJLrz7O9/S7wHsl?=
 =?us-ascii?Q?pEEy/HI0/ZEKW+H/ZgUG9GuHqZZgf7of8te8h0zpojlNrZiMpU0LZ99O7NQP?=
 =?us-ascii?Q?+AuqKzH314We6ksERNMYfNxU13QYbwoQvQrss4No520sIFIPOfhylORg4U2b?=
 =?us-ascii?Q?Xvw5H5MmteCod7jJmxuo9E0LIHmSFNRwvgh8xRs//rdiaOtWzDVo0t0qS+Xe?=
 =?us-ascii?Q?GsYnNTr+cWZJ7GNNBlcJtGzcSVO6Pc2olT0kUjRt7mK2fTbJx1dcu2LeGXNM?=
 =?us-ascii?Q?DU1Q5upvWfZUQVNob5r3vlWMG74SqzatnQfIqwif8bxJEbY5rk/0fVKb+K33?=
 =?us-ascii?Q?J3axrEMeoV/O+vBmbLHiN3m8gn9Y2AV1mQhB/QTOGKpNHv/3Nc9ZjAL3P9Ho?=
 =?us-ascii?Q?KW0Skb1VOS6gveDgCd1bHABkmCZ2ESbRb9BoFkya0LwOLcy2v2OVNKLg+dSg?=
 =?us-ascii?Q?GWmTTpFcFqbq7Cs/XwFtQQp1seh1QpffeTJvb2AlWZTHZJrj4ZiINTPJV/lG?=
 =?us-ascii?Q?dVCRhOx7iup+V3fsnsTfuFTfElW8S5r14YUA9eiELgcDkqSNqbVXJFWTbOOk?=
 =?us-ascii?Q?/Yf3bC3M+ivnrBbry/F3FxAcjXDaBwhs06u5ZK+rQHfxCvdPZNV1A4gpdDwI?=
 =?us-ascii?Q?3yGR1DMCGHfTzCzk71rjFAYZ3IB/4UtGvMhjsrBBAWqYF3TZRfW9qLkygtGg?=
 =?us-ascii?Q?9MiLRmsrxQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: MFMTF6hS3eyc9UXD9XqgkOiPgzASMIUHM4MQ61mUPyCgcn2xqnVXV3Syu617AibcqbyiXrL+WyDsp921MRWEV40//el/H/0tNQ17bG3I5M5ffovUwrm8mnQQkfgsb4CTA4bPzzAYgvnrWfuQ41ByPNAwuLLXx7HKn6+YK0OtZXaVpP8vGlVafGcQ6ARV0RMFXNiBKmxqnm9iLBtcnDQnPNV3UunuRRYUV4pQh9cHYc7OMBUPh24K3DmH6q4xlAizWvE/FouRyjMjTpHbfZlZcb4N7aU2WmQLq2SaLpjypAyqwdiKplt6SU0v+An02rKDloph+HjNuTIBi5k2NMJE6w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bda1a79-add5-4662-0bbb-08de8ea9d3a1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:15:18.5969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AaV5c8qB2j34wUw/IOn7YiVHyaTKSQZNzccn0fkC+yICp6bNKBN7E2k1L2Y4Aalp+TBADcd/h3Agop3l6s8eVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8B755DBFD
X-OriginatorOrg: intel.com

Dan Williams wrote:
> The dax_hmem dependency on cxl_region_contains_resource() is a one-off
> special case. It is not suitable for other use cases.
> 
> Move the definition to the other CONFIG_CXL_REGION guarded definitions in
> drivers/cxl/cxl.h and include that by a relative path include. This matches
> what drivers/dax/cxl.c does for its limited private usage of CXL core
> symbols.
> 
> Reduce the symbol export visibility from global to just dax_hmem, to
> further clarify its applicability.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
