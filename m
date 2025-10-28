Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E934C6C;
	Tue, 28 Oct 2025 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761614427; cv=fail; b=Lh4Dp2CKnFGPOt9pNiyBe9kGRWx2wqb4Sz6GcDsrbfhxWcNtscINWjBpqM+FwQzflJqg9dKrT5/J4QuGGRJ0kH9AxxPvyw9CQdRkTEgy2eIhjn/MTytW2DUJvCTpCPHdFzFLCipKsg5SL3Sv6gv1CTxoQvaNnMdJcLEPesEO4jE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761614427; c=relaxed/simple;
	bh=/iV0lo2eT6WrFZ6vEQ9xbmktFYG0ndk6gPh1QoRFWfI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p7uCavI2u3bTMKDY9Btg5UNhUMbg8Usx4q9BwnVp5BMSpSjC0wDvg9eRnyhC2lHRgx7dR08oaXPGBlpFCGRxL2bKdED36In9E6RRdsnUP+MJB24irm8XBfQ6KNjF06Z5hQvWV2tV4vNTn/eBodojUarOtUXHvmnTmOwH08ieaB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LH6IBqfl; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LH6IBqfl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761614426; x=1793150426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/iV0lo2eT6WrFZ6vEQ9xbmktFYG0ndk6gPh1QoRFWfI=;
  b=LH6IBqflB5hPIKugq98Su4DLRcGD6z2zdPoNfKgF+y6u6hRGXT/YEcMU
   MpJ29kvyGmwEP3Ge36XQ+OzHY9k3GFbGrsyvlxH+s5B2uGcYEd4f6P/ra
   y+njEioc2jceGHpE3nYPH+XxB4VW3AZKmkwW59jx6CQrKB4L00rtopeaq
   DNqX+XgleFsQnhRfgFDcUUHnfDcs4zbdNnP9DoP/gNthlDQiqU5DjnpGZ
   MZ1do7x7SbVpNyvsEA8pvnwjsdW0gE8lQ5rim/4kQK91NzQ1fiYjAe3eP
   ff4hg+pqpIoJiyzekIARZonRwgRjRWVGmnwkVOL9WIC3+chuo8GAySZp6
   w==;
X-CSE-ConnectionGUID: KmMLk4ZQQGipn5CCSIu3rw==
X-CSE-MsgGUID: l57MBTypQPmfqEzZtAjADg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62737209"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="62737209"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 18:20:25 -0700
X-CSE-ConnectionGUID: gWv5HGe1T2qJmGSu6+9NMA==
X-CSE-MsgGUID: 2R/A5veJSHysOjwhR4Q9pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="208807152"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 18:20:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 18:20:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 18:20:09 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 18:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APZeQWKm5q/Y9Xi92R2xbnCBjAi2R9PWTlm3ypxpAkXiu4DC0NJDk0AdxxFNcQCLku+0m71nt7xE6zjGJe1/cd97axbjqWQncQolZfmLYn1lsHT2WTTojyYhmKAkl2RFuL3HE3N6b4s6sYnQj9bsGDeDbph8qlQWzX99HptJYGH8Srrdnm0x4MbK+oAXMid0MQac/89jbzZSEsjaohGh2JQywZdakGiMHh3B16/DWzZLgjvLgOpkSytYmGa8HJc1QTWi5dOHLWVvtl5hVitXkeNXZ6rxFJY9HyGK+Nkosc3cCrUA02HZI8iIUUeS8lyzkHlNApM8Bf22ndSP8YlsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iV0lo2eT6WrFZ6vEQ9xbmktFYG0ndk6gPh1QoRFWfI=;
 b=nuXcE6IIIiBooqnHQXipDCeO/SmzjoOeGQmNxEeWMAwQMtrclt739TzNiJIRkSZv23HKNpeGXE7T9Rj1IxQRSBlGc1MTx4GRnmvru88k7qZK7pDUXBU3zbG8eahZkokhjgLzy6W1j2QayMOuPzflKaWjxEyjHIygzQcn1UYvztYqn3Q7UJVMP4A/4sshTKB21wbrmSI7wWAAgq3Jo7SoInYmR/mk7rz6xu0NkCzBuCvB66M/dfRw9k4U5GAsBBFyELlmPsXHkSNro2HqHoQCS7TvT7hYJ3lHIu3nSpZg2Dy8WFvzDVeOmwLAHTHehlHYkUX2WkLqsHo6CZrJ4T8tzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8788.namprd11.prod.outlook.com (2603:10b6:208:597::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 01:20:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 01:20:07 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Tina Zhang <tina.zhang@intel.com>, Wei Wang
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v3 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into
 the PASID entry
Thread-Topic: [PATCH v3 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into
 the PASID entry
Thread-Index: AQHcREoO3xKpubOiQUGiTdvJ/X1ocbTWyVgg
Date: Tue, 28 Oct 2025 01:20:07 +0000
Message-ID: <BN9PR11MB5276B0DFE219B8E37AD6C3E48CFDA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
 <9-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <9-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8788:EE_
x-ms-office365-filtering-correlation-id: a4f74f3f-dd94-41ea-ab6e-08de15c02181
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?XNbVnOkaT49DMgKy3DZM5qf882BmOyuZEjkzeL6hOVxR3/Y6VKyogLB78BiW?=
 =?us-ascii?Q?f4Ei9UQGcdCDGi1P5WnSX1gP21Z9EqMO6TBU1Fig1GXgQiQjSZNbGd3fs80Z?=
 =?us-ascii?Q?9+GKG76j8jm6Z9m3YcYBHE2/zxW/RCjN50mSr8mZDS96zO576sBekd+kHh4u?=
 =?us-ascii?Q?kqil5TtGvemLHMggpYJ9kCJy0JghXS8gLT95JnmsFyxH4RJrdSTWztcIAVAs?=
 =?us-ascii?Q?dTK3yV+8vAL1XG/UE3ylPS7L4KOmtcoqSd9qZxLWLCAzyhdvnkWmlPXmAhrD?=
 =?us-ascii?Q?Is+VVGZ6LqqHPaJZnQc18wUzRrf9oc028TtleqPVAns79zJzhrGFOfxXHisc?=
 =?us-ascii?Q?FzY7b29VbYKBizP3FY4x/ZTwPMGIj1OXnDKbZpPocJvAPJGCD5da27XbcVmU?=
 =?us-ascii?Q?Karh+eM4grXh2M417G7x7COAoY4f0UxtJVGjhti8xUN2fHleWd0WyBr4vVrP?=
 =?us-ascii?Q?4mmByVqz6FOsi6BfauYQaCj0aczprvthHoY1bL4E1s3/q9OgI9yB6K7EQb3J?=
 =?us-ascii?Q?Gb9pFNJ7KMJCsq3w9hBSG6PURyM95YFoPpXoL5AvUaxScFlDBgFdx+sT68ST?=
 =?us-ascii?Q?g6INKlIVB6NVrLWph2zc0japHOBOIoG3GnOIyA1yDPQsWW0zolc76j2KCw7P?=
 =?us-ascii?Q?C9T6tK5dDieXKUa4MFHLBqtQ8XBI3nZoGvnEzsYLZ88rYpMszryUyldUzd/W?=
 =?us-ascii?Q?VGdn6gOdvDM+iRZu6m/zTiKETr401MO4dEUQh3NscaATLUotgbs7uQapFYtE?=
 =?us-ascii?Q?1/bnbgOUc4LrOQmLAxQ1z2pTjVnSetnMIQluvlbHB4xoGPBZvzODGAobRNCo?=
 =?us-ascii?Q?gloOQ0QknQ3ZwGq+P3Dz1X+2eA8iTMMYFKKPSu5msuxX6RMa8YdqAX7F2vJs?=
 =?us-ascii?Q?MYIRSrDJfCNniygG0J0Imet0SuXIJDs6qhXC/i2mE5hQoTn9T+IKLG2zSTNJ?=
 =?us-ascii?Q?PFBo4o8AQOhnC84ObPR+BZZQzIQlYIkABd1OpA1ffUKqD2nsZ0tOwDD5oDSs?=
 =?us-ascii?Q?/qPdpmTfy9kHel+vUUwv6sbqNpWwB8GlLWBUBctFiSLFKOEwTSOapUUZ18T6?=
 =?us-ascii?Q?gosmnHybysP/On+SSmKlujbh7ToM53R2/eCBaG1jlrN3P6Eo0guu5UxWdx2A?=
 =?us-ascii?Q?s/+GGtyzWRF0MSTs1tOeSGfR8dEJiA1rrrCsEKPC5zlF6y7ERojY/Ifmwmi8?=
 =?us-ascii?Q?Mw6G1qTcGVgNqOWGlD3bEkfRh3hoKTLpmWmcMVtcgJrd9lahhk5LAjSrBfiJ?=
 =?us-ascii?Q?kx9OJO0RlDjklH+s41ijBNld3CwavHEdiqQysjQTW2vwZaRPEwXcADiAG5sB?=
 =?us-ascii?Q?qaxQPTG0xjJcO3sBOMbe5KbNeVUD7o9FkZUuKzQ7lXfBngGlztbm+t78Z/KE?=
 =?us-ascii?Q?kWmMe8EdzMdVBQyYVojcZx+QHOer03oVD3Eo2FEA6LETTho5NQMyUrFqtCQS?=
 =?us-ascii?Q?WDDj/mYiWbGGZ6W/9E3XrG5nTyf3YyPckhNLT/biI9+lBZcyCpNqnJ9zEwo+?=
 =?us-ascii?Q?d7nEHStDOcp2V7oA2UHK21UaZ5uxy+3Ysw2B?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eck9tT2pXxWFlbJhSeW+ye+J/cqSezj7drs/Z8uaF2IbzhgC5Ia4HoTRSFHq?=
 =?us-ascii?Q?/olRj2ZNX84x1Eke1K/cQ9VIXduDXKpXeXXtRJ9kMhcSBFOs3u/QMQfVBLrI?=
 =?us-ascii?Q?zAcwtYQsDY1MmO/nsrI9QuUCjkH6oHrxn2nGXiViDraaJVpdZ3WyoOYOPJgx?=
 =?us-ascii?Q?Q4udTS76v2n1dncBM16Kx7svtTlj0yc3xR+4jUEnz9rjfMBl2Qf8TMyD+ZY4?=
 =?us-ascii?Q?1woqjtcBaVsUSwWqYKYK8JiFzZ/lwRpQkDRR97TwCY2FzkzBPTtJgrIwOd8m?=
 =?us-ascii?Q?vOHpRqBgfX+HSnFBlswySRtwaf/CkiPPiJ+VxsdkZYZaEP3xBvyzJWvnxwNA?=
 =?us-ascii?Q?AyD6wz08n6r5rWfQvItQ7AX1q0C3EyWPLN1GOQLeSZr3POTwXhLaVoKHHOQZ?=
 =?us-ascii?Q?xC6Zhkg0xKMz+jmhC4i80gWrn6KTwBOhbHM9JZD/dgzTY3lNgHA3ee/qYFy2?=
 =?us-ascii?Q?zMH9aF1PhPtN0doh5kRHAdGDlufFjAoBZ1VPmPPxU+Hsz3rA3lC7kMlkA4aT?=
 =?us-ascii?Q?J0pv5+UbI7Yom+yeg7AbxAT4gA3PuHC8IHZEneDTUjJr6dadqYJRrg6xK5ho?=
 =?us-ascii?Q?sOocaK3HEF4DAGvyN2ScPfOF+A7dsk6rZ+XNTUximl8bqhkoZNQ6X0xoYsSD?=
 =?us-ascii?Q?9Ik29Gssgq8vAnUVLgE2lEcsC60vPEC6h1LEJgE9BY8/R/LPJ6SpT3K45aNA?=
 =?us-ascii?Q?eRtZDVI9GyFjJp5P6ZyGurhpN77blGsuhcOHD/87CLjzbNc0qqSptP/x9OW9?=
 =?us-ascii?Q?FLf9WpxkvoT4Co+8zBwkswJznbhmTisey/BrPUCF0pQxMFqfExNYkY4saIkb?=
 =?us-ascii?Q?yU5Nk3smVG6yp0k9xKzSxJIIo1vKpWaEWsr9xjazJkCoktmuL2LmU3Dnti6k?=
 =?us-ascii?Q?9O12E/vhs0cWVl41T/CgJv1dqime3kY6F5RNfF6XGFHMPaq5T06payh5Ot16?=
 =?us-ascii?Q?pQLvR+zn/kP/TzC+Vo6lIil3B2xfdGDfuBV46c2LSl1yGdXURwnXt2cI264n?=
 =?us-ascii?Q?b8UFaOpjJby2P+qO37Uknf8dIlitNrA1yiHLB9rlnWMx6MIXjC/zf0f4eTNF?=
 =?us-ascii?Q?e/5rlqRk95lJEcktFpRHe72nKMUMDOulROw87e0uSLtlCmvfhSItfvXEZtMV?=
 =?us-ascii?Q?WnqToRZqFTbBhUTkjgs4IfimB1oYz0YfyJ3KmTin7l+dZZHLeEjsyOtBYR9N?=
 =?us-ascii?Q?Nhho0C5mpRA3XP2mzi9f1Tvk74cjksmrwM2R/cDG7QZh/GSK2T6sdtiRx/LY?=
 =?us-ascii?Q?CBBMDhjbGHFcdKbv4eEfjAe6V+f4D1Cc5naV8pUUipCTeMHeHLaOr2ulWua2?=
 =?us-ascii?Q?f5LPIJwVmvHXVxOuhD1a5ZbGbxpSNgErrWPgZ+ggTJ7Vch2PiMpC5cMicGPN?=
 =?us-ascii?Q?viUJu3QvZumyBLgDfyYmqYmebpS/d22uhsUYAX7awot4rBtpWCo4EVdHMuP8?=
 =?us-ascii?Q?CgIl9qGH9N5yl8UMWsu/OA45gi+SXBeqScHzYeEA0Jvc5POjgXwvFIS5IWyY?=
 =?us-ascii?Q?ei/6l/7kInPcrs1nn/A3C1Z11puGGE2xLoq6OwqcYsb2a9V0hNDZZujFB8ar?=
 =?us-ascii?Q?t4PuTgVyHT9F30+XvuwYOrU1MmTH81i5vq9x8RoP?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f74f3f-dd94-41ea-ab6e-08de15c02181
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 01:20:07.3057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bHimFn0E2qKKGYLBsosINgwcfUslH4weVEoS7g7OkDdf9CJGNflw9NJZwxKko64tEIOraxB4JpX6VDYwqCJtgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8788
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 24, 2025 2:23 AM
>=20
> Currently a incoherent walk domain cannot be attached to a coherent
> capable iommu. Kevin says HW probably doesn't exist with such a mixture,
> but making the driver support it makes logical sense anyhow.
>=20
> When building the PASID entry the PWSNP (Page Walk Snoop) bit tells the
> HW
> if it should issue snoops. If the page table is cache flushed because of
> PT_FEAT_DMA_INCOHERENT then it is fine to set this bit to 0 even if the H=
W
> supports 1.
>=20
> Weaken the compatible check to permit a coherent instance to accept an
> incoherent table and fix the PASID table construction to set PWSNP from
> PT_FEAT_DMA_INCOHERENT.
>=20
> SVA always sets PWSNP.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
