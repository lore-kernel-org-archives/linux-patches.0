Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0201C3BEB;
	Thu, 10 Apr 2025 05:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264582; cv=fail; b=HBusBfLMoDYifaxvoiWifZDBwNu7B+T3tJlim2pGbDRz3W3r1Q+U6tuXZ5mnxngChm17Atfymdf8Uoqbq+jTVTlw0DsTMjv3FMHCvq8UZ3l8X01Ne9hl9JjK0sv5ghYhQzbbRwU1aGThXcGLxdg3fpwd3cftfqZ43Q/gtQSOb+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264582; c=relaxed/simple;
	bh=r9fkaMoQmAeMifDmKbtm0MQsLCDgMs50/rMae0vhrw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o8bJZ7d/86hYKRuMcqPiIBwugFjAd1g/u3tIXJsUZWkY0R+/G5Ymyqj8y6b6Y/FOW4E/NOZYnMpaEYICOujF1W/bTcORJVENRp7ydldQcxAFyb7lZEFdQVU62oPgkCLxgxoJNMUlkxCW4fwLgpHjbjL/jawTRvSzy9OUG3m2AQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MmE+Eixz; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MmE+Eixz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744264581; x=1775800581;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r9fkaMoQmAeMifDmKbtm0MQsLCDgMs50/rMae0vhrw8=;
  b=MmE+EixzIMajOigBv0oVJbWAhsMs88k1ojocJKx8DMoSpfkVlrAgR1Pd
   +RjAGAGWvtdgb00COE7gFpEYTGMccC565DwjX81+cQxEfE1RWbEC+zC+W
   BgyiY2eDwto+21q+yjF2iYvUt6faR/Y8O+B77oDn+tmtXrxdGMD1NBIyF
   h/ay1PkCfMf59NL47AuoqWzfbVZ6Ksk3T264TyVq30KUZ5CortNNPrbHr
   kuZr/0ca6HBNuQK3DLj0tU8k+XM0kfvkFpaqffy72aKfW9HcXZeEdkyxJ
   4XiMJJsgFfN7BfSuwVB1htlphWHF8YI56TT24XAbrEzOrVd5OgxtZmt0Z
   g==;
X-CSE-ConnectionGUID: INbik2raQj28luq130nJMA==
X-CSE-MsgGUID: CwVZG868TUqndVAgoTgiYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="49605305"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="49605305"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:56:19 -0700
X-CSE-ConnectionGUID: b3N/ybg3RjqSzZxypN957g==
X-CSE-MsgGUID: uHibkwdqRIOh70fvE5C1eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="159778537"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:56:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:56:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:56:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpX86dSRWQ5lhVmbmgnA/Mx3A8h4FCLjZL4SB9cIg4m9MUmqQXLWg5DHc46S5m+92nep7PgHT5Zo/SIrR2qP/arGboxuOtXZdeDI/hPJxZZB6yyFLzNiBnUcHjR4gXDmrTI00fU/Jylhv8iXpDxX+6F7X2rJCTGaLFj/T/2oZmGEaafURm3lOGZE5N3d+j+vNaiwq3yEBVUW4GZpvtYXEAwkGd8YJGvvi9U7TvNhra9g/B5ugz4QIN7023qww3hFCpJRwxje5AraxawQpRPyuM1oRoXw6Cm+xnYts4DQdkpuQ/aIpFByn6cWh7H0TaoiEf57kyVNho7BvT1qo7gPhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9fkaMoQmAeMifDmKbtm0MQsLCDgMs50/rMae0vhrw8=;
 b=uh4pqOG3xi8LWCce0vUtjtWmWLrXTJHBmrY3+7b80e6ahhUgjrBDaRb6Ti/Tkn+3+XoWCQzR2VcAfjo++2s0ywyziuTJ3Yg3UGntFcRoIMyTMHv2W46Alf+ep01IeMcQwI7kdErTL41qHSrEXz25AerGcImr4RGG1jyy+pR2gNqN1uO+eYIN8w1qwySYARyYUSA/VNooIxAWIpPJHos6sFiZdXCFDuFCMUjH750VOzmessKWbeoAvd7KgI0GSzMygtYMxLAYohsBoLMNDlydcLJZaJblR+P2NnXhS0htS5yGy9/t8jZKiBRNNnYisrjX2YHJb+tVeOvL3lkruqqaEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 05:56:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 05:56:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, Will Deacon <will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 4/5] iommu: Do not call domain_alloc() in
 iommu_sva_domain_alloc()
Thread-Topic: [PATCH v4 4/5] iommu: Do not call domain_alloc() in
 iommu_sva_domain_alloc()
Thread-Index: AQHbqKS7KZwMWhYiiUaldMyk1mG+grOcaS6w
Date: Thu, 10 Apr 2025 05:56:14 +0000
Message-ID: <BN9PR11MB52765A54A5E3BA70F5E4CD078CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <4-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <4-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6690:EE_
x-ms-office365-filtering-correlation-id: 6f0efc86-e647-495c-ff42-08dd77f4677c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?c3XmWj+Poaz8hxcln5i/b02de3RibqtQxPsfDFATZegaT1KKarpOCbCwiZys?=
 =?us-ascii?Q?umWMDzH20dS9NTCg3IWnvdLE6BRja1+mEUUpGJLDYfrsYNebhkw1Ou/Uunyg?=
 =?us-ascii?Q?vkrItMP01/2EjBOE1Xl8rszo71snRYST/SBOOGcqkaM7cjcPnluzbzMOFjg6?=
 =?us-ascii?Q?FgzM+Vpe6vhYqLAj4t7uzyxQsecoFY8BadKPr4l4DL7EptWL1MNE3zarNJ5y?=
 =?us-ascii?Q?bnKb5VsuTuxGStkjnmeUyvST7N26wTIb5KgkdgJv7HR6rovdQZSpq72Ut8yh?=
 =?us-ascii?Q?vqod2j40+7CU05eg1Sxi6vwMMHu73JGMnbOU9DEUmo4JcoXDqt7NYWEL4U8+?=
 =?us-ascii?Q?7Sw0HKW0vosAuQTBDDzoDyjl5YVRnVddI3qj5Jv28Nr7wq3mkaB5enOARcvx?=
 =?us-ascii?Q?EUkOHGJZtTErLdpZFP/6bCCgc4KX9zfE68p5ExG7yYHs/XVUNzDYjTxcxDgL?=
 =?us-ascii?Q?xofncsRR0TzBz0rY9YKJJFzWnvei0BX9M9b4Gy/TAANjWS7h8dESuPDKiuU1?=
 =?us-ascii?Q?urV7GA9yriSZVmLkHRCm0Lv4QE1AzvmbKV6+3iBtjTqJ/2+cHHKB6M5dbSo7?=
 =?us-ascii?Q?mqePM5ISCfCjIKp/hw+UHk/zekgR+asAY2b4GRYT2uDKeQiaRXbg4a483Fnn?=
 =?us-ascii?Q?tny1XYHk6O61JsCBdOdYvSGhZUOlLUDI9lNqACSFhUiYYcdtOJVZQb/O1dy3?=
 =?us-ascii?Q?8XhzafCSP8SsKe2Dk+HXyQy3qRU2HwWUxHePCZIIvphyvZ05chAPhOQJIAKY?=
 =?us-ascii?Q?b6rIJJv5mzrgWhQtqB8xxJIcl4J+kpK+kS/xj1d98ESnmzdXVa2NfXDrNRa+?=
 =?us-ascii?Q?EWrCol7KTBTDPtmRQ6PJdr61Fv/Hv8vpM6P7OTzm9M2F/Yq1YzjUUalvVKHQ?=
 =?us-ascii?Q?/3hPMmkFd0ze0ZYG0flCLnHTIQ6W5pg7VO+znSbB26ADvcCgvCVauYj7ndfJ?=
 =?us-ascii?Q?sRFaFGOuTCN/rMwESUcwhlXZkw8Yfir/0Ljcy+o6Luxm1+T1u09eJXwDbwTF?=
 =?us-ascii?Q?i8gi5o2CXU0mmkGwgIbWelqlwqvAckSJiTZ90CAyE8ZVBYegZrO/xW34KT7j?=
 =?us-ascii?Q?6jbYA+28LDyXCOqBPkK3Tskg76/Xk8gtJfBe4wXuR/Wezo4GZk1K4IHxrizR?=
 =?us-ascii?Q?UfYaAPFaQzQwSFMZKdK2jpVRzSr5zI/lpUhfLhKI4+F50sQ7j0s/Zpy9l65L?=
 =?us-ascii?Q?E/xX4dkJR+/3sNA3kpOdqQFd21mlDO2MVaoFVEZTc9IgW8STEAIQDp5mw3te?=
 =?us-ascii?Q?k07cws9EQSchJZ0AzE7TyRf+jE1OBk17+byQax6L6t2eixaP0Y9naEA/4wmJ?=
 =?us-ascii?Q?CVFAikdHi5CZ/uUi1diO1aY7uxYBPqvglKWx/fcypT3OpNzp8DGm0I6fB0UA?=
 =?us-ascii?Q?HypkKWDWKkr0y3zkSzdgLzBLVUQ1fLRAOBIYaPiLSsU/JFROaBupK1jRAmt7?=
 =?us-ascii?Q?ejFwFr7/8OsigUJ6Vji4FTwT9GtxiUyS?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ewJGPlb/Y63QQwP7xwcBjtiHDpoWsijt9RDVVh1FKhmCtpiOOADStqwpaPQC?=
 =?us-ascii?Q?yAkfkJpsIVznoYOpNNpNrZ0cBHkfsRuxgxeBWpfBWu4SaJILN9J5AgglFDDV?=
 =?us-ascii?Q?c4Vs2mKjcR5w2XOPoT2JnoeNLhRHkaKFIPhdd8nE4PBpjhKv57TGMuEYxRO4?=
 =?us-ascii?Q?4SQJFpwKytdxbu0sS9yRTMXfH39nW3LISzMHSBLpagHLqT0Nan0fTum7G2z6?=
 =?us-ascii?Q?xJxhE6H8K3y3t0+rVT569D4KhZYENM7p+b6jcYy4+gzovZ/+X3cnKFgxLNXc?=
 =?us-ascii?Q?SJY5EQzNqr+VUA/jomc1aN4NGbPk4Bm6x0m1qIpC5vzpyOqdikcKlCMBOOVJ?=
 =?us-ascii?Q?nd8sReOzdXCAN96GzuDz/4uNYoArlt2kcNcSkW7hbZ+nLzB/KwdguiNTK73Q?=
 =?us-ascii?Q?DtyQYl8aywcfn8NuVKFR+PfSASjMEKUREGiB72riS1j8oEqG/8VplDoJiYFO?=
 =?us-ascii?Q?iYOZBq+fO60ii+9if03KKycVCLadTU5fU8OS/78mRrSa/uBhiEW3/OVMDcqh?=
 =?us-ascii?Q?QhXEVQCznfZIDhaXmyVJuD9uDayVBFdY8x8tUawNDOYpy4sRjshkRvEikB1A?=
 =?us-ascii?Q?JjwVSUW9JOgZVs1J99tngrAKdQCESWWG35zqoQ+mlBl6T1ysifXZ8+pWLEk+?=
 =?us-ascii?Q?+whRC+NvO8/gDiUMjPuAfTwVc3RL4SVB1I8FW/Jk8PS5Jx5Hy2CrEnoNLmEg?=
 =?us-ascii?Q?sUQ/8ZVs5vjdmVZY81DWzfxVMuAgnNGBDILssat5vPDjdbGf2SKGbKWgd8mn?=
 =?us-ascii?Q?TmWdaK+QvvXKYhizCMkY/BUzis0wGnedwGcq2ued/Ccd06pXoklbRrYStU/X?=
 =?us-ascii?Q?bbZeW+PQhMmzk07DPmwF3a3vZm3VzSp1SAwOc/1P6+7/AI+G56JewaINdrPM?=
 =?us-ascii?Q?lum8yl7Nfj0baptNka/36gIGPCivtBTcu3QmX0uC6Aq76QOVwfq7WpES+n60?=
 =?us-ascii?Q?BgMsXcvvLDa2vf6UPjZ897CIvgXvEWIPYAWBucaSxE3KjcRLZvH3DVfxCxf4?=
 =?us-ascii?Q?36ekTllib/Y7vxFXLAMe/1dBFM7KEvE4wVkvRpgfok4u2HlBSNZOjwNB8+IW?=
 =?us-ascii?Q?m2miT2p4IkvX1Bp5ddXrThxYjwSNuHrSnO73/tFPHPuh2aDqTeiE1LS9ffj3?=
 =?us-ascii?Q?MTR4ZIiP6h/QDBnAhRpfKI4MuqeLJzayiR4JxbjlyJ0m4C/E968YOj4laz+/?=
 =?us-ascii?Q?aql2FCtxc7enog9KA2jQpoJtxRJljAvpYjmwKlkYCLSZhh92JJKBrmitUPmA?=
 =?us-ascii?Q?lO8+tUOpXtkNa1anrE6VstIlp8jp1IvVGh6slBSVY2vCAyQbCq9XGuc/95yj?=
 =?us-ascii?Q?82K48SxfdFSIBFzPxUeRi+GXLkgZgV//UfgKSbMSbNjJrmN8BILjXI2XeS+N?=
 =?us-ascii?Q?JJOYtEYjQjHPcz55Pem/jGgOWV/IDf/+Q2bwKZPDWN3Jxd/wZfmpLIgHJ9KH?=
 =?us-ascii?Q?My3p1dII1aKFIW7vX/Xl8el2Fe/WsutM1QkV8Z6TAt8DaLwhYkt7l+gPqZCR?=
 =?us-ascii?Q?rVLOozztWKslGoe41ulcnG47n2bEDn5eGxLlMY8iSeRipBxfCBguY1LKKuoz?=
 =?us-ascii?Q?cBT3ysBi6yfN3BQxwAiEtZOE/G7jI0YYN6lSzUKw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0efc86-e647-495c-ff42-08dd77f4677c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 05:56:14.8320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aZx5Vz2an3q0tuZBDZhi+d4uzGDiUWh33h7uaEjxOBX+bxzSBRW7mCYux3m9CdLD0xziP8i38L3N/lySAxIloQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 9, 2025 12:36 AM
>=20
> No driver implements SVA under domain_alloc() anymore, this is dead
> code.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
