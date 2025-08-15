Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D1D2036E9;
	Fri, 15 Aug 2025 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755257760; cv=fail; b=R9V6OEnzi2lJZ8Cqr1jdNzsuJQ0cz2JQyW+tgqCZOX18cYqi5b9WOnCu2H+Uv2fhNfrW5e/xF/+La74Wa4aQfDWJnPyhCXUFITgyIUkKkWUlpVQ4NgddkDc7TiFMSQ3oGdnUfFANAoZ9pyVhzAtzNGfTBDJJuwj7lBgt4p83Vc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755257760; c=relaxed/simple;
	bh=IhaAJblRTvU4uMXKVvDCllkiC7Io72rZOcq/TGrh+mU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z9KHYzi0eOMc5lKogl311Li6Xfr3HZdfUPzwy+5NFUUSwbzTraUYWxKmWNGesw7Y0vCCXNq1oLkb7Sv5sCMtLIWI9DdAHqsLai8YyNxP60fl294KVuAo70zYSU63dtTAlz4fqe7c8Na5k8ZUg+amheC9D8ReaemgZ5M8w525zbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HyUzOWre; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HyUzOWre"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755257759; x=1786793759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IhaAJblRTvU4uMXKVvDCllkiC7Io72rZOcq/TGrh+mU=;
  b=HyUzOWreqiT5CNUQqUd9of2rYTftDz0KcvsR8/PLi7HQDa0UxUtWGbAm
   oePCXOTn03xUpmp1qabfD7YTKMLmHaIYrayf8pn/VWGIykisrcQx8HGzE
   vkJr3HUJw9xaYyCcS4QU2XrLdqRvT++OMvCNf8c3IiYQSd4lp5sQAHa+0
   jb95O9Q8M1v9vYiom2KolQyG5LVYMrD/bUtRVF1Is69I9SYXTFwwe+Yyo
   EG+KeJMNAHr3NWKSQz3Qb3BLLDrc64i4xLV6ALUHvle+T/Op6+t6qCEtZ
   r2fhBe5h4WP7ingU6imf/gw85pQS0APbyMg54F2maVUyzGCXOGGMkPfq2
   A==;
X-CSE-ConnectionGUID: FxZG+FChREWiJmYVLg97Bg==
X-CSE-MsgGUID: sEBT4n8OSm+HKlED38MPKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68664858"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68664858"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 04:35:58 -0700
X-CSE-ConnectionGUID: IycnKZwJQROQuo0Y0QQQNA==
X-CSE-MsgGUID: qi/KO3RXQpusUsRw2XABjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167811379"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 04:35:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 04:35:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 04:35:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.81) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 04:35:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xltxYwVcerPDTU1p3emKx0bHlQsr/ewenQ29KSfugz1xWrMCydEzlfaPyJnkdu9WreDPkwpjs4m9e5a4ATgPBfdjCIhoxhuf69LTHMAGTqWkIuOkNXyz2XB2zniLTG+zBW65Yk77iePbYon/hiiefkGWaYg8+hFurnaQVTqS4/IJQ1/oZdIdNjqSIGvVH5HFHPVBnMbTCj8pqrsbxqfg2I8D2BpybX2S6xcddU45MiKepJKaNZ/Do9BDuMnQ/gij/sRczJE0g+SI/atGCc/kMAz9DaIVe8bt2KhmWvZpZhgSmbHlslhhX05iCROv0T4UycFW+K7Y24Z4PUqtF6p6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syz5aT0oFqbFc9dfDwXVFa6XR4kBOzZsPQ1KQJZIRtQ=;
 b=AzVFpnH2kJsxoDB37j/8z4CpCyBa2ABr9V+SlLQ8rh47Mfu2oUPLUEc3ZxX8uG65FMHOUVdaIAMx+WGb95GjdNnrnWaJK3u/lAu674IAKFiRyngh7aBy6K+kC3FZXuy8KWGq+t2KIHAziYeks5yLYw4Wrp4cQWtdEu45NeVpfZb4ZAuO6eiFo80YnwK4tUUcXNTgn7tNdkeY5oLDEKNtoQE4us5b+fiAwYwBMuOtRtDYnABkrwz7MLjR4WR6raVz6oo0+qzCWWxCxRs9onH3T0KvKGvvSIInil2rdnS/I401A9WEpdw5QRPmxoo6ff92PoisXhJJXz97NpcJHD5UEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6146.namprd11.prod.outlook.com (2603:10b6:208:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 15 Aug
 2025 11:35:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 11:35:47 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH 3/9] iommupt: Use the incoherent start/stop functions for
 PT_FEAT_DMA_INCOHERENT
Thread-Topic: [PATCH 3/9] iommupt: Use the incoherent start/stop functions for
 PT_FEAT_DMA_INCOHERENT
Thread-Index: AQHb9ov1OhkxnTmKmEargZP84x4I1bRjwtGw
Date: Fri, 15 Aug 2025 11:35:46 +0000
Message-ID: <BN9PR11MB5276D23F19A7C8AE247A93F18C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <3-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <3-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6146:EE_
x-ms-office365-filtering-correlation-id: 00742796-c656-47d2-f866-08dddbefe0bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?icw0YBPSrzlcrIq84HKrDZGjOwyVPEG0gtaUA0brUBCLnCO54lPbQpraXPE+?=
 =?us-ascii?Q?DSKr8c4Kp1raHG/CoZq5iXR564frc7gE4Seq7txzowyPRMY7Tr8srGcDHCUk?=
 =?us-ascii?Q?CXlbZ8iH4GiT6UV6IeSqwapvQbhaa0XCKPDHEZwlEgCN76Yfw0oNqJt8kl8e?=
 =?us-ascii?Q?Bg+6yXz18ZjZVKusNeYRVCPikE2Me+kKdIZm3uFxEWmitJz7xmCzLMq43AxM?=
 =?us-ascii?Q?HaKPfGyTEiYwQnEzkdnM5pj24VVFHHhzpOAgmADkpzWBUXNtcUUiECR8ix+6?=
 =?us-ascii?Q?aTisl7rUgHxvYsIFOl7pXJv/uhaGQzFzyf6kCF0i8VSUUcmsHvHh1+ZSHN1d?=
 =?us-ascii?Q?aU0EJr99evfZzokY7fUNhEYKbO8lEf4XjQ2/V3tiLtd3lbIujfYTQwOusXNo?=
 =?us-ascii?Q?jBkTYE732ZS3p+5WVYnfRxtY3BEJPFX6mwFOSvQY3VmVBUtwG6LlJ8hr53nh?=
 =?us-ascii?Q?0Ul3KgLnTdGx0N0qOQ1m/E87oylkU6yQe43xYiVwrHGpCqQUU3SLnB3f0RSJ?=
 =?us-ascii?Q?8cdslkvHZXrG+p1NMASdiVR4c4QWprdQyMy1e9zk8XKce8WA5tApO6tXKWvy?=
 =?us-ascii?Q?qcjWLfdA5VstvObc9CWSAInifAlfq0/vnPn2gBvxkfvIi/6lWInh8q2xaLKd?=
 =?us-ascii?Q?Wj3fTJTcsERbrAYUkDAgepmKWI6avjlE55ysmWVa/oEKmZ0Ara/DjmoDpuLG?=
 =?us-ascii?Q?6oRGQnMmGnL5WR1pH+Q+WJ2p8PdrCtuhz/aXqH74Bgxt6fX888P/URxB9352?=
 =?us-ascii?Q?zUWy5zHrvvfRw6gotJFnkCk/YFO7G41X0GIokPyy2KcCR3/UwZdJOVDyaR2b?=
 =?us-ascii?Q?DVKO6Z00Y/ScK1irYnoKKNTX8CPCpxDYWa+DaVR1AE0lz05WwxQgSQ5xTew9?=
 =?us-ascii?Q?KJ2fJzWeopIvXGUmxfPtD1UmTQYK3cd50h+QUc9TLiZublAOrQVlvnzWLmdH?=
 =?us-ascii?Q?ou/td3ggVcRZ6Lv4530uwXOQEwn7qpTrz4K1ByMScotz9Dw5RER17zRfKF4F?=
 =?us-ascii?Q?ZQpDVskRVR0JbWzfZt2UH6tdr2t69P20foY5pjCGYoFcQBnkgwN90aLF+IG2?=
 =?us-ascii?Q?vHicXALRWmwkAM4BjIlQsRAwuTu7yyxdVIGWHWfhEAKKdChW5Fxj5xRzckAI?=
 =?us-ascii?Q?L6BOvm02PNxfIGjtxv1AcziWa0l4EncZnfCkgYKdVKpu5DUFgMiqONUc4uOv?=
 =?us-ascii?Q?I93cM5aDqdRz4p8tTuw1eYJU8/PMZ/gtxteuCmxRl013FVxu8atJEv13U7nu?=
 =?us-ascii?Q?WdTkFAOk+XpbP3lDGKJr9dik+N3nLqPZf4kY/7hZYiTrc3p+diPEfUv6UcSp?=
 =?us-ascii?Q?bhNqPY3N/R2TJV+xSoETuqAq4k50DYnhVIhQtQBrXEiLur0ehbRW2oGgw61o?=
 =?us-ascii?Q?DXNNVDEW5HjtfH0RO/mtuTyyFv8GuIrq5Cx+fGH78pL5aCUhJX5bWANw2VgU?=
 =?us-ascii?Q?rZM+5zvuXZGynnNBEXveGFx1fzw/h0L+PzUeuejZCOAb1OjT1B34rQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pHbFkHCAonsQfvRZfNAfyzJiA7Jd4weEhZwBDrDUesRIo+M3rIwb5UKcoe/f?=
 =?us-ascii?Q?PBrgZ4R37Qo0d21GVmazv9KvdPih/U5//AAfJZ5oFS4A/f6RJ+1RlQKsjcPb?=
 =?us-ascii?Q?b48iq7junugOjeSlc+peIjBYlu6j+B0hDe22DJueK+DGtzY32bTmFp9U7jQT?=
 =?us-ascii?Q?sTfANs5b8F/uPVELeT9jinkiaZVvZ7p2fancXtnfRD3yUrdoX7byJ2jMrkdV?=
 =?us-ascii?Q?ZZM7qMUODVougjYwophbiwTRCvjQ4NxicrTGlWRgLFfBSGHXZFGRPiAqxrS2?=
 =?us-ascii?Q?zMkea47LcsF7pB7PQtsWK5uhu90n+1LOy03RQcpY9qXoP4Cb/UKNQlV3YPyp?=
 =?us-ascii?Q?Hp907lTgtyJMm0qQbC/KsS3Mk4RK9sadz4JUwLx0VXLIVXaQZe7iN0Zs9frF?=
 =?us-ascii?Q?1/wVoaJWhVNB6XZkmBuLG0ngkXWCAwq8OocD3omwksqRe/Pv2uBjWUeO0iEX?=
 =?us-ascii?Q?2fe+uNrnYFz/ExJS4nBQl0vitPeknsU2abnLElVr5AShE/ySktc83NCXdiZK?=
 =?us-ascii?Q?drFtH/aOWx8Le+wxY69CeuUuZg0n3mZVvx9owmCs2dodzZHon/o20yS0/XSe?=
 =?us-ascii?Q?HJVRgW/qO6mKAWGPhH0d8lxMUA/OXiL5lrcfv8myEu7qszvb4I4QVHnmwPhv?=
 =?us-ascii?Q?FRWLo7QGBYJhDmyC5/7dLIjtGKemhbSsg3ZrFU+UproKDiX/+zQ2lbvKso6x?=
 =?us-ascii?Q?rF9BGVkZkNsEoc6NpE3GOaNkSeyz0+abRxWEmo362q0eZT92GvFFJH6Gud7k?=
 =?us-ascii?Q?24+8YUndJBdx9qak1DDCdustVeMbj3pnow4IQHl4ibiH5CTBHTx/mBnMiNcu?=
 =?us-ascii?Q?fkAs9qEhl8uya4kKzqElyMc2xJy1c26MUcj76PZmARJbkghBHZ7vIMl3PsRe?=
 =?us-ascii?Q?she4BzEMeY5q6wbg19Yv0ba1LTRbhMAIEY3l51I9H11lwuxI3C6ijIsQW8mU?=
 =?us-ascii?Q?6mppTvBVmxN9kInWT3YPl4QxGkoFqe2DlR3uHyft6UvGF9sUmWJ8kyoFLEdd?=
 =?us-ascii?Q?fZs7Ye2c7F7EZspiqltFt5bicBd9DA9qh2w6Hi1sTytIjRhxhCr7BLG1W8+w?=
 =?us-ascii?Q?20ZpL+rYqVZyxSqyj8jat2tZc6mB/m8x7yeIKW4O0Zw5ZFepeAMxugXweWwo?=
 =?us-ascii?Q?NSTeOP0Q7F1VutEBoDdJU+xcBtKFKBb9hY8iEeqeXNot/+Rc5wq67d1LGmLc?=
 =?us-ascii?Q?NEuLzjHikTNyidU7Ryzs+jeyQnkBwvRUYK0r4/E5S9bvKhdRW6iyBCYDgvA+?=
 =?us-ascii?Q?SyHoAvf+qF6b+AVwkRMZcaA/KHxGtpzmTqI5f2q5RTaiiM5mH7k/NKU+mWiC?=
 =?us-ascii?Q?gjfx8ZwT+z+rNTDRa0mZBg0GeaNp1+yAwj888taoqd5LOFOmMy4xVmkBmCk4?=
 =?us-ascii?Q?/zVLYB6goiajbbCjZ/smbOK8D6ShD1IRlkgTmbwc5EeiCloXuB7uW5+QK9qy?=
 =?us-ascii?Q?Vz30dE5K5HU/1dSlbsDNlMXHYxF2uX1QioKMPSkMS2V8/kkm38Dax+CGFnFc?=
 =?us-ascii?Q?7ugg6iMXanq8gGeRwub7KuIIZ9xRA0hTxf+bSiCoxhA+4ybxVY5K5VWLTso4?=
 =?us-ascii?Q?Xx2RoZTAFsixx8nrLrTpq5TcKdtlu+bs+jnficBG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00742796-c656-47d2-f866-08dddbefe0bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 11:35:47.0206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vT21FPgzEDQfs9xZ8jF+IDlrUDEDp5cD5hRFOk60VgaTOvKWjG107UMhMM749kIHuAZsQ5tVwcIIK+gePxUSGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6146
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 17, 2025 3:58 AM
>=20
> @@ -57,6 +57,12 @@ struct pt_iommu {
>  	 * table walkers.
>  	 */
>  	int nid;
> +
> +	/**
> +	 * @iommu_device - Device pointer used for any DMA cache flushing
> when
> +	 * PT_FEAT_DMA_INCOHERENT.
> +	 */
> +	struct device *iommu_device;
>  };
>=20

It may be worth pointing out that a page table could be used
by multiple IOMMUs but we expect all IOMMUs sharing the
page table to have the same coherency attribute so here just
record the pointer to the 1st connected iommu device.
