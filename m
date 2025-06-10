Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B54D28D8C1;
	Tue, 10 Jun 2025 09:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546867; cv=fail; b=NKsAR/tOufxilOmzSE5kIEF71NRkh5XoN60YTB1wNkj8eVkknCDeyieFIPjMvISRAwVPXeBkARu/JMHly0PLWphi4nd/4A5E2zmS5YKmxKFlzhtX+vmMTb+6uBV4erfWS5vCuP8dP2PJ4lFBHaA4N3w6kbyCqJGQo4OhOwDYvt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546867; c=relaxed/simple;
	bh=DeiyAdEj0ygV7RPUwp2apXc9gOJNdpDxysm85lu9Ny8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IbEx4gzfM8z0HcoswJ1/hrNFuaUuY2n8qj4+KRliGiUuMtEIPdb9zDtrhFlLjjhVqAMRK3Y20gq6VsOBfcpeTC/+k82XVkGgiMXTvGxNud2t6a3G4l/gYTJGDL/rldCw27N2My+ZtXhLwnMmcPscLL7SOGBfm5j8p7w+0iOdQq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgsmhDDs; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgsmhDDs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749546866; x=1781082866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DeiyAdEj0ygV7RPUwp2apXc9gOJNdpDxysm85lu9Ny8=;
  b=PgsmhDDsiCUM6sOOaYT2hs229tzUOYgMw2/NZyTc8A4ShbjlFuRXeh18
   rFqSCsaUX0omMvFbfYi7KudpKLfg0ztpV9b0x/NfAiAS8FjGxQ0ErrqQL
   ueoTT4zCV8tDcwb8zEGCme6SJQAgES135sZLqZxIfzQBEnXf9pKapRg5B
   bO5eZFB8q7CvG4zlcn6n4yn/8FPqowzkt5r4/GcceNEF514dyAZPZiNpJ
   +WmTPJq1cwLlKvjh+v8HSwk7xgrWxgesmOQjEjMJSGCfsPU0Slj4hwW66
   pkoJNdh2q3ayAv1rEmt7kLQ2RcQX1CWgHKFt10Tcd0Sa50hxO5Iz35Ypm
   w==;
X-CSE-ConnectionGUID: Q8SBqdjnQqeBSKNRAtciJQ==
X-CSE-MsgGUID: w2LegfZfSEWJuJ6k3xkqIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="61917992"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="61917992"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:14:26 -0700
X-CSE-ConnectionGUID: DYqdL69nR9a1eFyO8VhIXA==
X-CSE-MsgGUID: vRsvkMOgR86XxyUt7eLwtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="169952982"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:14:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:14:24 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 02:14:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 02:14:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOcpeY5Bsh93quy4or62Hst2OLpCj2oFhCsZabAYA5VQyMAwiJ8hEDRdYYVj1Ak+vESBBPqUKz8cEfDETOSO7gxzN5RIAxi701FJlAYeLHUzwPZgrVGJtEPM02WjXQTZ5V/nCozqZTDzMB/8marRHXZEz4cOwfDosuK03SOrCyzga/esFDxvnkke6hyDnroX6neTggUuyHY+kQoZkbnJ3N9eiz9DybwslYUWKMSKIxfvEJx+Xiz0f1/hILoH25+m4aRUZQAXPxSh2grZvMG/4liynlGVkoOOF7X/liyO8Ipl5Qv+g7AkPJ8e12fipjbitamZALtz1TqGTQRJUUbb7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVLsXx/l1hfsG2bWIjuh7ep0aMdWtuZit35XlYserpo=;
 b=hyLjxr6XquDK6g80UNob4fWpF4B69hDpuonkYJX2soZlt1R7SAh78cx6wLu2aVGYyHDSfhJO9+O/BEnOVuqHZJih0lCg29FwS3y0kz1nQHaTDAUJbA3CvSJvsojAl+eOkrukMpW356mTy2Z49fSkeslCY3JBWstRbkq3yt4AOQoDHDPuncPsY6ukccUu4dNQtGv82XBphoHnIhN8zAKx26gRscRuOufP17FOUteHKuHqOeHIKoWSaJ5OCI0OeQnpXV8VHlhMaO23X6/kdPyMMiVl8SHJ+L6mZHdR4akm+kz6rUp1g56k0/QSX8mjqbGdWkAM/V8ZbJLAJYjpP8QjTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA3PR11MB9253.namprd11.prod.outlook.com (2603:10b6:208:571::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Tue, 10 Jun
 2025 09:14:22 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%6]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 09:14:22 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 3/7] iommu/vtd: Do not wipe out the page table NID when
 devices detach
Thread-Topic: [PATCH 3/7] iommu/vtd: Do not wipe out the page table NID when
 devices detach
Thread-Index: AQHb2XjlxmfxMMORkk+ImLlBpgdY37P8DJyQ
Date: Tue, 10 Jun 2025 09:14:22 +0000
Message-ID: <DS0PR11MB637393BB05E9BEB42D7D9132DC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <3-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <3-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA3PR11MB9253:EE_
x-ms-office365-filtering-correlation-id: b30bdb92-2686-4cbd-415b-08dda7ff3036
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?4+79l0DM25pzCz9CZLKbjzDHLSbzOjmB46vsqRSYZnoGqxz0vBnupUxLoSlR?=
 =?us-ascii?Q?rCKlYtWd1uDEQZb3WLxHvw4NnXbaqv/1uCnh+oZD/TrZEY2Gz+MZtjZqt4wc?=
 =?us-ascii?Q?uvSTbbnNAvYqHJdV0TzyPYU//5J/Z9xcFRlaQ+7ntNAYCqENZyblDloFLehO?=
 =?us-ascii?Q?a77qYBI7VKiGb1sTwDxHpfWnWN/ehrR2hhTnAEtOsBGUC5AT9DBnn3Ve5Mbd?=
 =?us-ascii?Q?SaHo3K1swxl2oVctc4w+QE8bVvSo3vuOTHqUwyDg+HByYWAVtgzNv7q/zc6g?=
 =?us-ascii?Q?3NsNjiBgWwcY2a1FMzMnOvoE84s+p9NV+GISwLxVMZCVID6PIx7B8YU8ZjlK?=
 =?us-ascii?Q?UfHx7IG8xNkWpBI1ygaW8UWWQ97wDdLIHY/bqaZBpLa/XY0mTBBFv3m/sOb5?=
 =?us-ascii?Q?Diaw3C1L7YJUvwuJUAox8tk3PrHH8cWu7YsF1OGupYB8a4i387Oy/8za9N8D?=
 =?us-ascii?Q?UN/frEoGVo4nbgWUrRq0RjTlYiW3Cxa/w+D9wikE41QNvUbQgBJ2JlU+xbOs?=
 =?us-ascii?Q?WviOXdyt6sBMwGq0jXDtqQ4v/YpdzelUkyPIE/wn3J3FXdkhUThIH8HowPUg?=
 =?us-ascii?Q?BEGgiJgpOA6cYNEcpa2CpLw1gJEowG1d5Kee+Z3ac6Is5vfoWMqPjsJNesZ+?=
 =?us-ascii?Q?z1pSKBgZtpICzmKsK4SKtP484cs0YW9XAxmLkHXaOvTe3hUI3+M0Kh1naY2/?=
 =?us-ascii?Q?H0GtLS6oWXy0smX85s+Cz9p9kaGbjU0gEviK27rXzT9v849Tfg31118/K4iL?=
 =?us-ascii?Q?1pPRwWokQ78mgDqU7Ajs5vrV9Ihfa547vzFZrq0NwmOXAiLGHUnkML2wrMd2?=
 =?us-ascii?Q?9FXskDUcFrN3qG+Eq/ghpE8i2f+amciEae2wG8omwAsulnf0ddMX1FvaHCRt?=
 =?us-ascii?Q?YPnHiv9MaiGXiwdzvoPJSlTMsaoxpSCLEhwmoJ0hNRux1BPU68hgnVeQMjtQ?=
 =?us-ascii?Q?HQTNconjX5B616H8Z2yUamfAGuMOjRZWyEUD3QPtgKdOz0JFfXR+7AUtlmRE?=
 =?us-ascii?Q?LsGBxdm0G1Pa5RUknpZXRTjpUPoX9gnfCZFpDxu+7llUs4tfw4vIM30DkybX?=
 =?us-ascii?Q?HsoS2ko1mSvGV+POYGzBLLrBZlz1LRhF2GyVUEpRL/Mu3rK2T66ibqz/Qipa?=
 =?us-ascii?Q?FPwthqzYpyHorTdZLqRSy78Pmj7CAZNL2BCgX7MCvJY5ACSOusSO7FcNNmR7?=
 =?us-ascii?Q?Trdan+TMHkHdtdIH+s+9YjLjB8VmkcqbdMEgRzoB4dEPVJ60GicRZcGdaA4B?=
 =?us-ascii?Q?jrPP17ePpeNK2A3fEdQgmOppY6XsQQdwoTXAM7TEAx7thOi5EaVPEhEvStbr?=
 =?us-ascii?Q?Oac1ZUPBHEKVTRranCqzCVswJx2E5EYRNFe3fwFH6Xe04pBHkwSX0sl202oG?=
 =?us-ascii?Q?qBhfoD00tSp59LO0RDNw9e+MEae6Oe7Ps7RRN2Wvg6MTkT/xdinQ8FzLFnR8?=
 =?us-ascii?Q?7ImNUtLVwWDqNZoWH9MBbaGcfObykZrrVvhbneM4f4hTZRTty6tUJUMA9eiJ?=
 =?us-ascii?Q?l8ijSQfSlOXYckg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P2oPB4Vt/hURoZiKf+slZVuUr8FPgQ9bUe77N9joFDKToXVEd+pGUGvMoru1?=
 =?us-ascii?Q?1hZnTvNHKbYH1KUcLaWRSKAWUx7w2V176PksdydYPq6w9fG2EwKH+f6Lp9R7?=
 =?us-ascii?Q?RUcO2tw+dhy2EW3OCQxPIGfeOjp4ze7vUA0JWCZp94lTM5R38+KFR0NhIE+5?=
 =?us-ascii?Q?WMesxsxxJwmtFylqmFdWIFJsYgI/dC1BTzFraOcocX8PnSs2PJTqa+RdJ3mH?=
 =?us-ascii?Q?23zu8CCZZ94NDVApvdZNdR6djn0SpLb1bp33YcuGeXF0Sc0PtKpCx7yWnijO?=
 =?us-ascii?Q?dDjfTStC8WPYBJ9/atCf3mNjYK7gUACVUcI8P3b8oeLug7kWNdTq09p4Qo6U?=
 =?us-ascii?Q?WQd2cyDqj+7A0H5QZCR5RWFYUEcCltq/d8xpgI6evQhDnoNtyANZSzrTY9Od?=
 =?us-ascii?Q?PPOxicV/mEdmHk800ETbzQPYsyIEpoWvUTjqnWwbys9NDx0ro2WAEIgDlnzx?=
 =?us-ascii?Q?noMFzr2ZgKFV3bwB9gyGdWX1GOOfnb5MZTTVxWjfVg4TqxpY8tSR3EsFp6wW?=
 =?us-ascii?Q?Ne9XrWCHzBz7Jubb6yOPl8v4eOyt7nFADlmzZMEM4YAaKZTAHWMEw+urYtip?=
 =?us-ascii?Q?KNYwrm1tBEOk170wdkD+VccJPPPWD1nRBL3T5jS2nloRkZprUaHPUwlyKW9Z?=
 =?us-ascii?Q?8rRuYgNPnkmcOXR77HJ9xRb4na1kV/nCAH+CDiz/O6E8wrqB8zZsTc+R7nC9?=
 =?us-ascii?Q?fRSTOnQxGfIMflLPfZ3TaHt/Pqss4ttPV7wgIv6civ7S+DKhKK3xyUZPC8ha?=
 =?us-ascii?Q?8ud8b/2cJdBaq3VbqOhB2JFN+O/8ApsA8KrWq57JCZI9bLjyaRDT2uV8l8wa?=
 =?us-ascii?Q?Fzu9DPV0kbsK09NCbn9RO2vtP8KHSJz/qwWBLaZUAlrO6mVn2Gzdu5cH7rJF?=
 =?us-ascii?Q?51/oKhwH7ZmxgiXOEXQRvVp3C9Ottou+dGO1OoFzCUL30PWHKaCymiXBs+SD?=
 =?us-ascii?Q?6GCJw5buzniaZ0/uoqiV9evavkx9KWPcVyLBpaOWgmZyyBkncd2GbcaYUi8g?=
 =?us-ascii?Q?dXUqB8uWBiPBzcq1IoYJtvhWK6v/H9+Q00Rg30YW+E9wORIvU7fj9jBV5uao?=
 =?us-ascii?Q?eqFlcQkqbWRvQcp8h27W0EGG59AOHC8aJLzDiq8BN0+NjThtyEUhbEt462va?=
 =?us-ascii?Q?fqBZ0dQ+u9TRXqA4JN6PZFGBEaJOMzpiLjGOyeziL8toi3/58L2o5RW8abtx?=
 =?us-ascii?Q?HyVYY04g+AWtgmTNxjCe2T3aDuwm44qN8St4GwtLVGmfas4GSn+5PH1OkQjx?=
 =?us-ascii?Q?bbAUGUlzZztWv6vvmvXEO2UuV9hKxCWfGCtdbtd1UHzjDrcQYfhyVBzbQ3wH?=
 =?us-ascii?Q?/LAv0RIbZZ21xrWxloSngqzKLcv36UFvqJgwkPVi7hep+0f6maEmwXEPCQ9j?=
 =?us-ascii?Q?2XhyJ7WL7o9mDqXzW5i2RxxL+VRk4ntIDmiAHFhhQl0zaC443/jjWfZt/M9j?=
 =?us-ascii?Q?wQ1RQL16vr/d1aBir3na/ZEaVYlZ5AJlWD+UDPn8alGqi+NF27ZO24l+QdNt?=
 =?us-ascii?Q?rGDu65J1HwkXw6lCmW2Hrh2YuhztnhYhd6bycRATSINs+xbGlYUsyyY6bM0h?=
 =?us-ascii?Q?7ZmYWGT2Ej3PCZBaPJdjK/i+hiEjmBDCQVfkX/jM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30bdb92-2686-4cbd-415b-08dda7ff3036
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 09:14:22.3785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jFgoNzn8VM+MMOngoJ6kTbmU47dWu6pT4WlsMwa9GOL9q08xJOJfPNzidtotTbR87U6jGUzxQSnhbWjLgg3ZRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9253
X-OriginatorOrg: intel.com

On Tuesday, June 10, 2025 3:58 AM, Jason Gunthorpe wrote:
> To: Lu Baolu <baolu.lu@linux.intel.com>; David Woodhouse
> <dwmw2@infradead.org>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Robin Murphy <robin.murphy@arm.com>; Will Deacon
> <will@kernel.org>
> Cc: patches@lists.linux.dev; Wang, Wei W <wei.w.wang@intel.com>
> Subject: [PATCH 3/7] iommu/vtd: Do not wipe out the page table NID when
> devices detach
>=20
> The NID is used to control which NUMA node memory for the page table is
> allocated it from. It should be a permanent property of the page table wh=
en
> it was allocated and not change during attach/detach of devices.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/intel/iommu.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ceb960a796e2ba..72b0769c391008 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain
> *domain, struct intel_iommu *iommu)
>  	if (--info->refcnt =3D=3D 0) {
>  		ida_free(&iommu->domain_ida, info->did);
>  		xa_erase(&domain->iommu_array, iommu->seq_id);
> -		domain->nid =3D NUMA_NO_NODE;
>  		kfree(info);
>  	}
>  }
> --
> 2.43.0

Reviewed-by: Wei Wang <wei.w.wang@intel.com>
