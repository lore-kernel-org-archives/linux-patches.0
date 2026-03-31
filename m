Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ED043CED3
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 17:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774979658; cv=fail; b=mpYOybkDoFM+sh35a3zmp5YvUqRvGLnGNcICyAl0+NIj0hncF2WWfS/SV3ImJXdDzckhoIHSxfu9JbbmaENC65Rl3iCARrUrYTNZ90MdAu950vDh+a0GkLBS4tfKYzk6FdBqrRd8m2uolnmPfG7A5fj5zSZnFhzog1hx8eShHRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774979658; c=relaxed/simple;
	bh=7mKip2M5Ejd5uZ0lmbBahSlO1OB5Ehsi1XpRRUU80FU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qWXG4lUc4thcitYYu88d/A/zx3FBLDjwshALQ65iRPXnHq51adu7jvHXLeOGmVrur8G/lpeVk62BtdJhpMnVtlPKuzSGcp60TA8jAJakiPRMr5rFxjGmE8Ct1X71qhbon/8iCD1Wv+KWga3XWCgCaK2YrSDsqqw0fI6DLVq9BUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtnTdhGJ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtnTdhGJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774979653; x=1806515653;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7mKip2M5Ejd5uZ0lmbBahSlO1OB5Ehsi1XpRRUU80FU=;
  b=QtnTdhGJVThep9qfqVvpB16U2k/00ln4qsm2d472Py/nCSyytdqTe1/h
   5Nc/vPyQzjCFSb4NRyKd9tc9pF6zIb2xSdzmBaMnhTExKO+f6B5gnCF/A
   JvjI4EMRxOdQUzReCYnQGQY0jfTKSc3DCTsxSMDQ3sHvww98l7T1jG4fZ
   zrV8ZzyIFY8rH/WgEWpggB6PgZPmUgNxvlX15hnNLqrjvw1bJ3Mm3dlH7
   Le9JOY96/rPl82G4gzbx7MHhU8ChZkPeSeJBz+7UUbGir0s3MAPhSSCGe
   l/nQmn052hTdx5hzvcSrbEaUyVEEN56WrPdvNP4JItu52aCJ/7dD7drrv
   g==;
X-CSE-ConnectionGUID: sLhZg0CGSkOXZpg8imfHMw==
X-CSE-MsgGUID: TvGkBwjBT/m7LNkhfppcLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="79863721"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="79863721"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:54:09 -0700
X-CSE-ConnectionGUID: 91Gzb/NfQUaLKedp8fDhyw==
X-CSE-MsgGUID: D3ZX9TjbTQKgIc4XoKDz0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="226424734"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:54:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:54:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 10:54:07 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.11) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:54:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GrXh407VQzuFkB1kAdmD9SdsbMvx8Ea3KD8LwxVJRvKUK+tMP6/NbykTZ0//mmcs7GnWmV1gqa+awWvF3PvJhxgkr26O02nKO4dCa7OWvoIf0qPnE+UwnZb/zLLzkaGmH6aZdOzSj2yDWB+oLNhhXmuu8xx2PAXOp4P6DT/f3k+NxVzL7/WjuS8vG/Y7hvBdEsL9nThDC2G5oEiTmaNJofVzuSQtqMEuQ6k7OVm90e6Ywzur/PDRPb+fAOdhmIZLM0+3jGR5RsAVVaekpAnouIq6h+oe6NGNcDWkq80YL8hB/AOVx8Vl37YBjDNhqnc6WOU89HvEYnbwai6y2mNxfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpNTOYqQt4vQSOGhwGZYBanFUKoH1NM2PgR8YK/E/eQ=;
 b=e+o/0meKIxEjrNem2XEVDXlvP7B2IgvT9+0nEU0Iq9E1rmmDXVd8BFIFz26AZD3kHfASb/rZAAt/WDugAE7Wg2p6tahNIwUULwaOgaxKtg/DPrhWM3tRv09IoFZaDnlBWqWe4BBrmdeNyFHcEv9zxKpkNJzu0kK6xAsLevQj/ur7C2yNriJvXNsX8IxLdNxGPQBlIrXZS8JGwY+VDShTY3+Lh0jfKy5eMDPjMtOLF5EvGBBhNFgoCPFnNt1MngzoYtNqhVaHYnGziZYqPtVbfhz18VBQaZGFUHOE76yNjL/js6lFDdD0xViFr07XSArRT8X8yWSPAuKbV0k3cWrb0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH3PR11MB7868.namprd11.prod.outlook.com
 (2603:10b6:610:12e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Tue, 31 Mar
 2026 17:53:37 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Tue, 31 Mar 2026
 17:53:36 +0000
Date: Tue, 31 Mar 2026 12:57:30 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 9/9] tools/testing/cxl: Test dax_hmem takeover of CXL
 regions
Message-ID: <69cc0b0acf961_17924f1009@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-10-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-10-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:303:8e::34) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH3PR11MB7868:EE_
X-MS-Office365-Filtering-Correlation-Id: e8e5f8d0-9394-4481-3303-08de8f4e6eba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: Gsu7R7SJ+UmiboWIfxKqoIOphyjfbVJt74KLTG2Eab1CL8XV2yZ/DtyAcXs8qk7aJBujsB/q7NI7gLUeq0n9L3aX/zu8RgVoGehn/l6lFXfQmEPqYLfiHLAOcwygB2X0S8TUw68LuRcR75prA7qP89uzhbD5w4HA0uBCCiY5Q/D9BZ/ei1R6b4As3PL517gAbLBKnYEcg+acsiis3HMaIMW/tKKIrhnlRFg6ElV06FNgcpTa4k6b7ko7L8YiKGqSSGnyBGYQuZrFhKSL2PelTRe3YYly/Zu0uKl4fEdxxwCYls8jOoY/gff8CX6WYSPdMiBdPMgKrd/K4RsbnVHFICV8yqk3Ug2qjaz/mrXQbt7tZxUXC+C9iPzHW8p0fC41BT4jPFuQgyTn2T1l9oJu8lbH8K4dmFM71fdhgniWVjUoJcEej3Mr64avTqr557al7upbPLf3J63H2xegS5lprS9+S6WXeYemYKu9OUyXrm6Q4PNG0nR1pMXSrDVku5XJ+qRcHuGN8LgpwoW4J89otN3UFy7YCozuy6Wm0mQaqXj1qadlh8zrbL+4BOtbJitWAFRm4zkneSnLL4CHEGS3CNKpPHNr78uDf8Q1AB5RCTODE1ztXW/wpbQ5qZTh5cxFmUyGB19YTbTH4phlzGtKMUKEIT2rLqNEcxXcCAY3wIV3/irreG8PkYqu5yDHWUuzhmiykiu3RSjChoFHw7Dy9zKqVoVUPcMfyu/RmD+YfVA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8aJtEXPTtbRdenM8Z8R0dEUsoMRmBq93NNT0C8N26XIml3XzvkbsLTvQLEgQ?=
 =?us-ascii?Q?6ABJr3pvs4MiuR/MBwn5PJ7MiR6u0XeJkQfldgB4uQ4U1iu9ppnz8+lOJV/L?=
 =?us-ascii?Q?h4yKXVOX5wR6WrI7778yR/DW8vgccSBNkSsBJ5EJ3X0oFEUhjEy8l4XrgqBi?=
 =?us-ascii?Q?TX7aK4HNepOsLnUoSEL1loIXtbPhB9ytWoasElNtGhDYQGHXzAjUCeLgL5V3?=
 =?us-ascii?Q?hQbDX32eebWyrbhsV4FPsvhhtQs4/73aLrdxFm2PeC99SheSSAzxNjLe/und?=
 =?us-ascii?Q?iHCZAOeZ2Mf/qye/0HGA+4w1TkmIxSZKoZ7kvbZBH6kserutrbRd4sUdW6pY?=
 =?us-ascii?Q?O3ISzFpNd/5jUUZNB83VnBMbd1P78fLI6FAQFTBxl1Fj29lu1WX/ZuoFBXRG?=
 =?us-ascii?Q?O6McqeWxyNUaItuqOtB3Lkvvzi6demQfQpQFBhyxmd4lEunJDGtmhSUNDFaV?=
 =?us-ascii?Q?64fzU1aRDd17US1bdjDzP2O5b5ejcYA/dN2eRLY3ggaKou8fOywAXZbmSNoX?=
 =?us-ascii?Q?H0r6OsEZfbAr0Sik6UKE+Xe7oWNJdO1dR5k1ZxP+v7z9dRUYS/3fCLNSXw72?=
 =?us-ascii?Q?JXmhgqOnJZSoc4BwcN1pBTuqGuVy4etw0Mp74q16haEKuKxL0yhaWALNmKkR?=
 =?us-ascii?Q?DZpPGymYAfNhUJvNsJHGJsARjFTyapjMj4o/eI58ii844gRX3P+OZBHxyijF?=
 =?us-ascii?Q?f2j1qrcsK8D63y6UzhefnLDR1wWOWg/46Kx+pFXmR/YDnZepQpXbF50HWOVN?=
 =?us-ascii?Q?dvOxA5RT60fmeOX5UYD/xJqdKcbY3KpSOji0suQpdzELrAf4C92+xjMfR7Db?=
 =?us-ascii?Q?bszQeWZb29m8/CQ4l7BzzU7ZST64DdRcoxcaA8MG6Q/Pt6reye7UoWV8jGHf?=
 =?us-ascii?Q?dMJQINsCyRtEEPJnIq24MG9Kol29rsfTKa7N2sW6ubbP7bfb0ddSnVlN0OcT?=
 =?us-ascii?Q?NJuRDIcjlhuL0JTS/2UDqCfucXI8FNArddmEd9zeDUTFw0gq1ftkeym84vnw?=
 =?us-ascii?Q?FEuFCiXulkyChsvz9bHESExh0jWxHzimmZvctmCU5sBNMNTj/U9SyCfH122Q?=
 =?us-ascii?Q?wraWImVPhT4AKdkcCq0NEL5y0fOpAqhSqgQQRxGiKtsg1EzB77LP0NovbSvX?=
 =?us-ascii?Q?ie//NBg2wyMbVDF+CD7LPe5zhcPBDXS+AiQvdHow6CrJyqd/NmcJek3dUPFU?=
 =?us-ascii?Q?+oG5z+Nprf6CKjlQleBhnwbm8hhR2y4ywE/MBM9rQHsQcAmkhlxS12lj0Ff4?=
 =?us-ascii?Q?wCaiQFqf8ZZ0RG6+APbZaPxhOKAsSuoaf5ab5rNwUNyq/POh1DlEL28BLZDH?=
 =?us-ascii?Q?E+0Q1HobVXHHu4czP1OgSLEVyLZAaELdgNxmN1aIfO/n2kVVH/z4/FWJg3CB?=
 =?us-ascii?Q?uA8/tIwtWIlZ7/lAwErl+uAQnNBTj5Ux8tH3zCmtVWqog87BBfenoZoq8KOq?=
 =?us-ascii?Q?ZsWZnqrYeJIkN5ItPI5fFhuAK5NHpFgO+2IudJhQZhLXOGAIRTqXxtzn9Vhc?=
 =?us-ascii?Q?pb42SfPBgq9WgzuhVEdrdidxQ1pDvWYkC9mZq++SgntfVeLKYpbH8y7BfHdr?=
 =?us-ascii?Q?GLmRCLfT41F34cgCGQTEtcjpX2l7tKhXDb5HjTEJqOql+6CWcnc9k6NcHXJP?=
 =?us-ascii?Q?Aw9xLDKV3WROE9HE/AN4YcS7VXySyebSDsfbY19XG5xyzwRU15S620+gCIt9?=
 =?us-ascii?Q?aL3AsyuP7aau+YIDEiW/V10p6+WYyUunzba9By79mLcG2Nm+HBRRpgfLYQ+P?=
 =?us-ascii?Q?duhR917qZQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: fFKxoGADgWTLrhLdJ2HrBmP1bw7UrJ9biw0XvaXKmx4NXOqVQ8Aj3y7QHYQj0zsNF2m1UqgXZvI/ahGZ499RVtf7KrIjChS8ZdCin9+jGu/29eBRCmyHhe/b8XP4aFm5iI+NfpfmGwKN0WBOWP/2cGcqV7LB09Hu3XwqhO3fFPbYVTr0V7fLCi5cHq+qdKW3lV0So8/R8edFX2Jt12gaT56XVMrqL89qrr2wt4jGCC5kT2FMDmrm8e9fh4D9eo/jOCRiI14FiB5LoD/GqIHJuLQJ1IcteKeH4fpBr7sE1eBbR/AvvyJqHfW83d/2VBBx2u7Oe9xToyGVh2qUljMFFA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e5f8d0-9394-4481-3303-08de8f4e6eba
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 17:53:36.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSTfnGGofvNNIEN1Kg3AxLJYNN+xRa8lTCSKtKQWik79ddP8ZpTPIWsrCmmwVXGGFXSQIpYabyio03e8fiovhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7868
X-OriginatorOrg: intel.com

Dan Williams wrote:
> When platform firmware is committed to publishing EFI_CONVENTIONAL_MEMORY
> in the memory map, but CXL fails to assemble the region, dax_hmem can
> attempt to attach a dax device to the memory range.
> 
> Take advantage of the new ability to support multiple "hmem_platform"
> devices, and to enable regression testing of several scenarios:
> 
> * CXL correctly assembles a region, check dax_hmem fails to attach dax
> * CXL fails to assemble a region, check dax_hmem successfully attaches dax
> * Check that loading the dax_cxl driver loads the dax_hmem driver
> * Attempt to race cxl_mock_mem async probe vs dax_hmem probe flushing.
>   Check that both positive and negative cases.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
