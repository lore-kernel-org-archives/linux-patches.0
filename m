Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C46F2AEFE;
	Thu, 10 Apr 2025 05:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264021; cv=fail; b=G/87Mq8IF5eFhpuYkTz0sxpdnwAS6c46wsJxtEvA+FEwYjP7IbQXk1xB0T4FtSansJW56g5ja8ClAJPnfmqrXhDpl6rbn63uYVDx5gQH4VOV58I20Kmp2H8RaTi0KiT6L5dvx2dy6wA2G6OX2axUkBA5AQRIjgGV2AQ4bPRIlsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264021; c=relaxed/simple;
	bh=QcL0vRgkk3EwJdLgwZxTXO6iKabH/MDDwX6ynMUA6+c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hcFG/ovuyWbF9oOXWvtjIMCk3oPEPbnqD+3DE/nzc08CbV6E7aSjiHMDIN6M1ldmjI8L53XzU776xhRPzBJXxYgAgQF6U/PWNW2o+5ca9IgMwCT6wfP9Od01gK4AHKwpGiH0pPnjtEV0TPnpF3jklQEF3qB7Gh+4PZP76612XWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Smnf3fta; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Smnf3fta"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744264019; x=1775800019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QcL0vRgkk3EwJdLgwZxTXO6iKabH/MDDwX6ynMUA6+c=;
  b=Smnf3ftakjyCldVXxrCbz1dXnnUAH/qtdmlNHb1TOHcmpDO+H46YZPlq
   tf+lkN8UmQNSe2xL1WgVlLyoGIXTp+P69/5Mazf242q+0pu2ekNmUqms8
   uUVggX1hIgTolLrRdf79PzzT+yJBCJhAkepL6L4rwWstWsN4VeMrfu4Ot
   pVhw41o8Rr7j57SNeu0exJPJVgbC2q1hObxTrp62JSfKTpHbPJeWqZBqu
   YYsB4fV0gI1E/gHzscS4yrHN3APYoDARXFw9/EqiZ0qLtRhoChXAP7wp+
   qYZlKx7c+r04+rsDsZwSryJsEscz9WeA77KKgUQgtlagTt4uabdg8A4/V
   w==;
X-CSE-ConnectionGUID: 5PuOqOODRpqhgPthSViD+w==
X-CSE-MsgGUID: ECn4rCVJSRWpgBK/blssoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45476891"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45476891"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:46:58 -0700
X-CSE-ConnectionGUID: Vku74wO+Qa23br1pdWqwNQ==
X-CSE-MsgGUID: wlcqsUazTXiFnSJx2pEAeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="151977846"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:46:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:46:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:46:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:46:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p5e/BvAjRQjW7qPwOTsfY6krY+9QJOLXmUCh5P1slF+iAEBpP/kaI7TNGJhk94D6D8xvyH4Q9Uh1RZtNaia2Rrb24G0rIzTaMbQmPL206BONORgKv7rFaQavAJE4NPZqOK5Wu4xuHr2oPaM1qoF8oA4w1nohvPqkYrX1c8odK2cHXK3tPmT5wdpedTxMEQ1fwYgmm8mamQG0dm68wB2+pXOU7xe7OwV8x3XZ4WpT9AtCY9U1s+DD1ZdFlmhM2XM+6IrqrFgTGGfZhVrovM++cHT/yPWPxrtwDLWM4ee7WJO5U6ekUtCTCBL7xf1wKcQVYkHLIb9KjiqC3vHiS243LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcL0vRgkk3EwJdLgwZxTXO6iKabH/MDDwX6ynMUA6+c=;
 b=YOeVpIBwUdhKxwR0iNyspbWteaKk7ujq7tiMvM474VYflSQsxyyKhp9BMxIA4jbIEbj8E72jNkUzpMB3AglfR9r8rEO8LsiUtoe8Uo2MrzaxJ97jX1/i37be7hCCE1C5mexcrofrb4VZP0mYY09Ed1kotcZaewchiRoenV0xL86pluiqic8NO709GKjd6Jymls7ErZW01LLlEaDseC8V3UqWhcREKpPlKtMJaea2lTDbSurCM+dKMGwz018h5aoy9/475K8QtcRmH2Z6fERaL7QA0tftAXPXWvo0zQYhqpPK4tPmYNj9gB9U6VrFEzEPOBOVUD3wfTqi80MAP78d4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5291.namprd11.prod.outlook.com (2603:10b6:408:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.23; Thu, 10 Apr
 2025 05:46:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 05:46:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, Will Deacon <will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 1/5] iommu/virtio: Break out bypass identity support
 into a global static
Thread-Topic: [PATCH v4 1/5] iommu/virtio: Break out bypass identity support
 into a global static
Thread-Index: AQHbqKRbfJX3X74z/EKpG1Xx9Y9EibOcZi2Q
Date: Thu, 10 Apr 2025 05:46:14 +0000
Message-ID: <BN9PR11MB5276E3CF17D2339DFC5C18788CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <1-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <1-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5291:EE_
x-ms-office365-filtering-correlation-id: b32bca8b-b6cf-45f7-ac1e-08dd77f301cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?kr0AmkzTAFbJBTcIBxVol5H9stkKZcv3710mdRb+Jo4J9+og3qWs6pwVPW45?=
 =?us-ascii?Q?8VI7p67Am36tJamdYT9iaaI+22Z8K66z4cvvEWdWzLsDlhW6b3Z15INzRUj6?=
 =?us-ascii?Q?obiTRlfEps40cxdoYm4JPMQsOt3KWodr2LCE11KFN5fY82/+dCw9LYnVEeFC?=
 =?us-ascii?Q?MnAKNCueOT8MrmPPiQ3tPzh/r+H0AlDmj7aUPPrl4DcCa5nN0anaeo/HJ0ox?=
 =?us-ascii?Q?2kM3fSbLl1hD6ZeO4I1oz9QvdibkCqhE3Pn7ju85Zyc2sd5LPrB71R61UzBo?=
 =?us-ascii?Q?tDzwK465ukirISi9VKWiynmlbhGzQRI/5239/aHghiePlFhnpv5kCydD12qa?=
 =?us-ascii?Q?HxB0c46ukd85+g2cDXOknjeZyibzBWdQ4xfqR/R8CIEq/o5HZI7PmGH/Cy6w?=
 =?us-ascii?Q?n1QH5Ye7ULHH/rdw42PlvddemSlHjhnlQJMIZ1/YrOK9lXwbuHODRlpmzHT+?=
 =?us-ascii?Q?yHjXng6DFpPQ5380Af2p+AWnjLiDYp5VK4hpZgqvpRWwlc5Le8PIYDrYk1u1?=
 =?us-ascii?Q?fIZGqpl5OnIySYqZ5PhkwzmtmcG/kmOjPFjJC97IYIBEIQNbA+WSVwRoSc5p?=
 =?us-ascii?Q?T+kJaqiMunjzLaUd3mbjNdFO+MqwRWIQJpnrPSLxXWodduH4v8iP9BEBFCZp?=
 =?us-ascii?Q?g5fEUvlDM0XvtaKaRx/KesQBDg2bcXZVNpzCMIRzDQrVHej9MGcu5P1K8Oqc?=
 =?us-ascii?Q?QW4Q1hxd0b+pFlQdReiNuAE9RHM9X7mQ1qDKWIykb41F1oEj9aHzfpzzwHJR?=
 =?us-ascii?Q?DlztK9VsgfUInOQOx4XovwhHSSaULgLu6jY5frbBEGfzSyJw7LVZgBsboFn3?=
 =?us-ascii?Q?9A0P60xFfBRFE0QvtNIRj7haPmjBTKXEpeZiJm/nHjt2QcnK2Tlxxo3fmEe6?=
 =?us-ascii?Q?SJDcWILzAY50F3snKnk/m55qF8DfCGL7BwALJJ8ClEH4CDW+hFWlG4xWQ0gV?=
 =?us-ascii?Q?DAf56nH1Ef9H0Xms5mPpLJvkcEtLWcExi0DJzwCDQ8dos0/VCKaTomyjoITB?=
 =?us-ascii?Q?+Zc92PuLglPXYPf0iRVwdZOcbrRYLbwcWNhuAq+JQXK5FkiIyCGNPbwAYSlm?=
 =?us-ascii?Q?7lnAbRWwuOcJNyZ/VDJbTxFM5SDGggELZexfdvedkS1gNvqGD94+EXU+TzlN?=
 =?us-ascii?Q?JW0l3Z6TtRI2HZwyZmVCifks19GDN3XtB5dKMJNSM56BVu+nMM6yXYRzeO7B?=
 =?us-ascii?Q?pM6djd+2xgL8WTQqD73DZse38E4UAKNntXFCyAzWarvgIJUNnCWcDbhH9UXE?=
 =?us-ascii?Q?h5IRYHPlbyBpJFLgWcv0v7Ezp98vSeIB/lxaYcg/CMEQ6msD6v2hqukvoCsD?=
 =?us-ascii?Q?ty8kdxyzpJQz+d3LsY/ELYwCLJ5DRiuDysyrtuvFSCi+xm8NxrajXjBt49F3?=
 =?us-ascii?Q?EUrdTVbmYjp7+nWakTywPolw5XVL0SBpDucJctZHe5om3l+jxApBMgGdCYiF?=
 =?us-ascii?Q?XgKdkeM9+B6FaMCugkFMJV0s9vJJYWMi?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ynaArFx0Zdj4fIxhR9wugsvbmmE4U4NF2mu9kpGLxkMfhS3JzUb3k6eirNZC?=
 =?us-ascii?Q?6+HryJGiWptln1EZfgFZMKKFJKdGln1fwV+kemnIK1ukkBPw7ZDWb7v+xkSJ?=
 =?us-ascii?Q?pdzWOOhRvT/EXiyJk6gk4GXngsdYtX2EaZbSN5WTJCaqTvZMT5nfSQxEosdL?=
 =?us-ascii?Q?TdSQdbp5dp/mdmk7V20QHukT12eZEfLFRFkRYH3rEUsFpCjWptlFPhEtgbc/?=
 =?us-ascii?Q?NabmGE20rt5UR26LJ/ZmlKY6TG6ToMneVFPCU4BeQTVgZB6bg/Mq8NoPacRp?=
 =?us-ascii?Q?Ci+zUFygQQO1dV2HQPS1IIZJN/iq3oj+cYTRjRSnajPCnGsdotBjQVhXR1Tb?=
 =?us-ascii?Q?wYVLZMfSUmHsHFXnTFytgo4LxkLfjmghNAd5T2bwwTeMjS26WG2hJzOpZ7Wv?=
 =?us-ascii?Q?pznm++O1sfTUDSt2jYWz1yLD5AB7UAF+ts43aWryTLJiwE4fx19MgC4wWGI8?=
 =?us-ascii?Q?5BlSCRMAGsIMWGwDq1DoAPsUjwwXpkXvYkg6fLEMaqLev8pfgcsddMPQxbhj?=
 =?us-ascii?Q?2i3RNWIk14+foNNPglI1tDFCKXw1MZKGs51zCJ8mY+dV1/prjncEmyopqMZ1?=
 =?us-ascii?Q?7lITm0E1Pmx4vg8D2wX4sDoYdM3MD/4Vx82+Owlpc8c182ueBQrnfXeTtiYb?=
 =?us-ascii?Q?XErmxf3KNXK3EX82kr99+02SAu94dfhfPDpVMgrMscAqnkc3WpkzbaAvJBO7?=
 =?us-ascii?Q?GvgyzxR1ZhaRdrdlG/eX8sxEh/IdN+sjUlr9aqvsUplfRhMQZZ1zQ9APmn7A?=
 =?us-ascii?Q?VanafQfWlL0H9szk0hOzi+7/ApnYc2+JAo1GFmGQHTne4JqCe2EYbfSzax+5?=
 =?us-ascii?Q?o337weJq46dUH+jVC8r06EU75X3m3rFhktFuuJRJ4Y1YBHceTd3zdmVRmpLb?=
 =?us-ascii?Q?aq9huOLyS7r9SMysN8KwbgJA9oMY7NV+5fTwwBbPaeyDOl8DWkMU4rulS+4d?=
 =?us-ascii?Q?IcDZCmbw1O1ksCU/Ol2ty4ws9Mz+9Mqe+XgaE2aE+R9ic8RFpYPG0nSpu9JG?=
 =?us-ascii?Q?CAFrZIyd7L7niZUtuSeJ5KX4rd+mOXF7yjA+TqMs0eK85/P6KR6auEXiMiUf?=
 =?us-ascii?Q?VfB2DJnXpnCMImHmIZ9v9vtlz+qoAR58TuZtJSAhq/1fZ6peBp6pTQ72kVdQ?=
 =?us-ascii?Q?dkcvprF6aG9qFy9pa8C7CNgU30T0AjO+snr2dyQ6rOHJGll/SfStRwnzZ/KH?=
 =?us-ascii?Q?9CFRa++BTys4Qv0CbKXD9J+mfQPYFG8dQ92MgiyFtLzEV6L8orPH59INagJM?=
 =?us-ascii?Q?Y2AG2We/c23Tdl0qyN2z29u/o1/1B6G7wTIhm1K59rFV5CTcAy5C5YdrVvT+?=
 =?us-ascii?Q?xLLloydt/nDEAUls2ufRFKr3IrMbhwhIYtRMqSKnglFGI0pBAbKjTyeWOu2Z?=
 =?us-ascii?Q?3uujCJnxzqzeRRawcd64fUGE7oBQZ9qrCb0Uvs1gdzf8npOkd3tdoGFGDj/i?=
 =?us-ascii?Q?BvNVub4ZaItLWldVKbFPdfUYC5prE7EcSijerneD0n5cmzBP6HbO+F/SjC/p?=
 =?us-ascii?Q?l5hysbSxyhOSZr/0WAGM86ztJ6xB68e1wEOc1S3uAT5f0XQHOCs6Km3OHDN4?=
 =?us-ascii?Q?iURPOhOYgk52MSQ/hwh7qYmBivUEelJ58u6x2srJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b32bca8b-b6cf-45f7-ac1e-08dd77f301cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 05:46:14.7270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wvMdk33JNYMJjPrGKBGqV3lSEcHTi8eBATFIWerK8ooL6P8yT48jU4toqAuModAyx/dOj7AuBULd66+SDiztLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5291
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 9, 2025 12:36 AM
>=20
> To make way for a domain_alloc_paging conversion add the typical global
> static IDENTITY domain. This supports VMMs that have a
> VIRTIO_IOMMU_F_BYPASS_CONFIG config.
>=20
> If the VMM does not have support then the domain_alloc path is still used=
,
> which creates an IDENTITY domain out of a paging domain.
>=20
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
