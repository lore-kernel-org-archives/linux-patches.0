Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B721ACEAF;
	Fri, 13 Jun 2025 09:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807345; cv=fail; b=r57JigXZnRYF4vAyg17rhMZGJ78u9QG95zoneu98p4Eq7rfyPjUC8X1J6lpQlOCIK/ydJ5+XiRehbYz3Yb3yU8bl1eXSqziODIbudwkOpNL4C/veJzc7MwDXNKAfFENGBzVaLNv2x8502PwpN5VpprdryWtRkjAuKCzDdQZ08VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807345; c=relaxed/simple;
	bh=Ppg4j7ryOV8Ptj6O1+x1ZaNB8KcvsQ3The7s0ddXNKs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GHihKXO6DUJ4z//YYQcw0JZFSjxgWB+Uf6SoBWqu9YfEEJ0nuojSp/arCUb0l8BrrkjCl7QiF/8oZNa//aGR62qOeDJZmLW/1edhLK8QvU8s0z1iRKKiNAdo6Mcy9P2kTmC5ByvZF88nglDCN0/JkR1Yq4RFI4QLITWFElOW8QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PA19Wtcc; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PA19Wtcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749807342; x=1781343342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ppg4j7ryOV8Ptj6O1+x1ZaNB8KcvsQ3The7s0ddXNKs=;
  b=PA19WtccP6HCSEH3su7GbU6dCBXAlWrMfUHPDPWzDTJYNJDPw1mTCp1A
   cGCDNOFVz9UghXD7wbstv9Ffemevcupd4tLRwr6O6/0U+iSgYRoSFWUvj
   1ZtSdeSepBYOI4D3TNA3aNaesqeelXaNWib8WhKjUrMIPhCDbTRMDENEO
   fAhgT1Knod3nP8hl/N1woWbGf0eKfZQqAopWATl/bmpY2IzoLFEnPYgnl
   WDe57zCCnVa0P6me+HUSDvhoaP9t2IQB8jOYq5Ms3bG4ThDu7yFJWwJWO
   KUuqmD4QmE1etJg0K6IfdsvSp/HuN5k+etLyav1cQGIYT4GkX44VnHTf0
   g==;
X-CSE-ConnectionGUID: ZHA7HYlzTYiNinoncIagDg==
X-CSE-MsgGUID: rhr1esfYRsanR3mOH5pI8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52114288"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="52114288"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:35:41 -0700
X-CSE-ConnectionGUID: DQ+gywYTR6uKUwOFcVCOLw==
X-CSE-MsgGUID: lEYvAJFaT1KtPO5Alhy9Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="153071913"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:35:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:35:41 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 02:35:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.89) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:35:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTeels2UIQLmk8g4Rii0J/TIWhmWLhyARwu9Tt9JlpyME8pd7Pvg1xE+QYkymLx4hbi0i9XYEZKUj2fT3w4a7jAt6FUGxVsRYtGJQCtW0Lq3s58m77rosIlt5sm04ugH1B6MRZDIQG5vg2rB3Em8Hi+W9UbbkaJIrPhtmqTAfBLL7mb1oK1nwOT3a+de+RW6MghCsfI9EEjkN8d2FZhezFOD/giW7GQUcuAXqHO51X38MwriYNrs6unmVricqNSOLMeaX1nOQ0VdfWTb3w7HdjmOfP2cTDnVVdATmIPWa22JZ4K87Wb4m5UoCxK9haEOamHsczeaq3DE4RdR0Jlbog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ppg4j7ryOV8Ptj6O1+x1ZaNB8KcvsQ3The7s0ddXNKs=;
 b=rn9P0SBQosunrTUBBwPjTTpjTh+xb29A7jV6ump5b+WibyAzXFj2vg8S70o3ahzU3U7c0xkus9W/1TI+D5Iom7CMbX74wOwTVk2Ao5bA0A91hLrEifqKnLKpsrFNEovRqupVnQfd5ptq8WkTdSaBpQmzrrKlew2ea5KYv9eI1DW6313+/WN1hzHN4vOIOFo+pP6OLQ+xv9Mgq/d0CFI5fyZjbH6sagTzGnhIH/TrY57NN4axdpM3MGiivVDsx9GvuvL5z8v7veaJsg7bkFaq9zMiXzzLcz0iv20VOjx5+ZtTTXOXhZxfsuv4pB+mPFMLbAMmj6GD6j72Rn/7+NsivA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8674.namprd11.prod.outlook.com (2603:10b6:408:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 09:35:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 09:35:39 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v2 4/7] iommu/vt-d: Split
 intel_iommu_domain_alloc_paging_flags()
Thread-Topic: [PATCH v2 4/7] iommu/vt-d: Split
 intel_iommu_domain_alloc_paging_flags()
Thread-Index: AQHb26bOIZ0887hRnEWsz4zPy9FQILQA1aMw
Date: Fri, 13 Jun 2025 09:35:39 +0000
Message-ID: <BN9PR11MB5276F6D07F09FC1CF79408868C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <4-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <4-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8674:EE_
x-ms-office365-filtering-correlation-id: dca0889d-ee7d-43a0-a4e3-08ddaa5da892
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?/BwT6VGtaT9DChDeijCC63Bi6pfuC7i0I/APezhUqKy7ttZOpz3MW57du6Kc?=
 =?us-ascii?Q?SxXlOKZ+2UkUhsQS2pXDa2wK50QiWpEuto89v7KYwyyBOkFFwI2skDCuI4e6?=
 =?us-ascii?Q?U4J7UrIbN6xrARXse9G18gEP+ukn5K8F3GyoIfdjxO2MIz/ha8jUe56nlvK7?=
 =?us-ascii?Q?og0eVmLX/EFGN1S0FCiB/3vY4JDxoZy9QCuaNo7o+xzbo4+wfmgZL5I8/s8S?=
 =?us-ascii?Q?0IJQ/FwvjUU995OCHwazBxhaBugy1b26JRIqf+df18xliCkJAluAkIN1W3Rl?=
 =?us-ascii?Q?UvL4N5YUYys9bqU6M/xjx9HgGRIdhHmGwUxjezbn+2xoqIjivkWMu8VZp9o4?=
 =?us-ascii?Q?OjSNmaaKksaU9OTsNX3buHhZaSqGw4SD1Xu/sZBJ9WL1PP2aqgYGzy4YvJYH?=
 =?us-ascii?Q?aR7Vxs8A/gbaFzhcnMfuTRrxziZy54Y02jlJ6g8bR0wOv1rSNyDqrrf8RdOf?=
 =?us-ascii?Q?XX4rtAUVpKngRXaETHaWU4QEXP05gOymjBzjRGIefFxjdbRb6z/+WbGzHJxL?=
 =?us-ascii?Q?FfkSXCnwfFC7Qt1yWla1u/xaHHfpJcMNV0cGfAGCaUgYrRRKNukm//qNK0Ts?=
 =?us-ascii?Q?FliqvVc8iL5Ghg79z5kKkJeCD1M0S2OBe9PzhVPtBt7VXax9Ml3AkYv0WuA9?=
 =?us-ascii?Q?P2Jtf4z2y59Yg1Z0lmtQFELiAFOIQ5jvG4TbtXt16oFJ7S9DIAeVOKzJFIEm?=
 =?us-ascii?Q?rBlakGh1SW8kLNEafS+t3GP72oOUXE/w35fIinjL01ZYbN8wLIuZKd0WDE2Q?=
 =?us-ascii?Q?XSJQv0MchSb4kRIW3LCOZrX/WdxNBncwLbY5yc058/rI0uIkztVfoswnQLxI?=
 =?us-ascii?Q?ce2VQvdDqXOwCoL7vqL6afVicU4Id1qHM22XmyAxqLlOiPT0D77t6LbwVO/H?=
 =?us-ascii?Q?6qZtd0+V9e2WRIQgZGqNKaR5tqraai0OM7OhimC9okZ0jrzCHaFX2nxJY26/?=
 =?us-ascii?Q?SeUFIpI6ZOU/+1jOgqdax1CON/+Jy9IiVx4ticUGKKhQbeq/T+Uo9VWhUIMB?=
 =?us-ascii?Q?CbWnCHqDzlivKiEon+wxshLJKFTXzErMgL75eQWVr2VzyCjE9wXIXrhgFeaS?=
 =?us-ascii?Q?19W2TKosV/nAR+0cBYRxDehkKwJNeq6CxonJY2ilrZxVZEbJbtgkZu4be620?=
 =?us-ascii?Q?xL2EsMtKYPH/hD/UFrXlTXMQBhh5jXOSNGQkT5SMLurmUB+5Jw33RuS6Fa1S?=
 =?us-ascii?Q?RidgbvT+IDXATWl/ux6nUpbqqmoY4FW2DRJ6mCK7DhGh3+zoRKaMY+6OoPHt?=
 =?us-ascii?Q?xYNQSzda+jHKxuPUq2KdNB4vlRgvIzJfDI6hi7ZPzH1xzseJ2BfV8isr2U2q?=
 =?us-ascii?Q?qfvweImp+38QMzVoBnOf8L6xcM7fXUr5fwkrr2NymG57XOr8FXvhWg4CPMhA?=
 =?us-ascii?Q?2metMxSGAJhMj1LKT3g2Vp+PU1JnSsrZEvZbcbXZhGshyv1FJ0vIJXOr/+ay?=
 =?us-ascii?Q?tFsaNPBpxu3m+cSc3sJYOKs2csU3NWRPgXCnKhPnCCIrdkcP18i+jQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F7C4PTYu7H3Bqcp0y5/DIjU+Hdz1BGOT3O3tzk3nsgNl5AXg0oyijl84sm8Q?=
 =?us-ascii?Q?i48YfJ4WsBGksTxMB8A2lXa94I2/+KTQ9ve3xUjosLvfSpsvhPS1UUMTwnH3?=
 =?us-ascii?Q?nONa8X2XG8Nv5p8CWqTu56+86Pd7Wn0ErV80mapwF3n7sgDlXGG+TKdM3vc4?=
 =?us-ascii?Q?AZvzQ3QLFI3Qby1fdajmh9cdZm2rzJYYApJmCgSJ4XkcW58c0J9lBN34NaWB?=
 =?us-ascii?Q?JmYQDtVBQc17CWHXHqV5AHM2enXHGt7dbafNaoNQKfs3UkajOdvd2ISjNhYL?=
 =?us-ascii?Q?1i4Q+S5+Dt8MohgZNOXVsnJLfNGYJNts2gjwtElTRyOuSjJGMgF9n40Sesqd?=
 =?us-ascii?Q?bA8ELOja5/ffkhvDujHHx6tiJSG3w6eie/FjB+wCf/aWrcO0SCN/KUObyKzh?=
 =?us-ascii?Q?QTLSxYNAJBZWgaCA1NzWX+g82jlf4KIExjZhCKhuEWFQlF7+yVvL2px1g7vb?=
 =?us-ascii?Q?E276SGkRxPtlr3b/IIk8wJCL3lzLX6qjhxWq7/A22prRb6GO1+Of9cmhV8Ub?=
 =?us-ascii?Q?jyTk4S44NlIWSwG2daxtXcJm/IdjhNhm4PfoJkFYvkmnustVB9DKm9M0MxjC?=
 =?us-ascii?Q?IR9BXfcKWmZ+/xu5CprT0Mxh9rFzBvt3bz7ja00kYguh+rgyGA5DcKC/8rBQ?=
 =?us-ascii?Q?BgrkYTebOPntP/uGfC2xWFRJdb/ovEVZWXsLUaijWCKvqCeKHo76U5Be/0D0?=
 =?us-ascii?Q?WEGuB1dRwEfk470cn9MWkRDTtAIvFpMW9DhPL+Ghw/ULfbBFb0vZh4VbwIsA?=
 =?us-ascii?Q?dRnQoVaZn6MCjCP5frYoaG1PqSe5T9or9wcNYaUrfO1qRusPfFM/1nHwBnO1?=
 =?us-ascii?Q?W2dfQFDBLGIAPIXcD5J4vkzui2bCUVpKs8p952eYI3QY0lqWVF4biQ4V7ud/?=
 =?us-ascii?Q?Eg+IfG9iRanQgJMJFhur98LbCm7EorWh1tpzOwSCFDC8oVdgBZvz8QLxn/qo?=
 =?us-ascii?Q?bJU10nEHgBTOu75n0JROEE/m9mnLOf+SLvb5VjLEvOQm/mBTyecn6UulJRxE?=
 =?us-ascii?Q?M4SGJ2nWbkW5EctTU4hIW9Cs5Hn9vX25BOmfzR9FdImek7+hlo2Rb+GVd4/y?=
 =?us-ascii?Q?h80iDT1Q0RWGGsey8+hOlkHdgq8WKxHcwF7i5Po9of3G1H8YYw61g7fX8yZg?=
 =?us-ascii?Q?qTi/KDmqSSKPf02rx9uUGraZ8xPK/HG1QJf3DkROIzQO+jFFLg9SnfTGKeH3?=
 =?us-ascii?Q?WIWJElNWOw8KIB7TH8dtGcpvtSAyQ1Md36OnKYupKcJkG33aovZ2lIGZh18X?=
 =?us-ascii?Q?oexOsZbefObupLTZH7CIO1peG4isIYuw55GBdn4yK2T3VeEVyRnUQ7Lc3EV/?=
 =?us-ascii?Q?gR2Noq4RdJiX2cl52B+UO+QL0Q/UXEGndjHt+FIw3s/91oRJbzsCvCwbH3+p?=
 =?us-ascii?Q?L24u89eWW7K2XWRGvxss31JzE+/fhiWC63LLtRx8/mW6PSZg8FJpQ1sYi7zS?=
 =?us-ascii?Q?SqLfpaQdN6PC2hNzuiPMfdSiVAbsLUduaSymBTTt9KTuD/FtHP+j3NfPUaSB?=
 =?us-ascii?Q?bKlIwc+PqGBWRebI3xB1aPZ1cld3ENDVXl9jY5EWQbDJyu5UUTdILeUuzVKd?=
 =?us-ascii?Q?xhh/JWlJHimlTGoztm1Ff1Ph1w0PPg6U1JIr97Go?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dca0889d-ee7d-43a0-a4e3-08ddaa5da892
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 09:35:39.3196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GsyABgGu0tox06ThmZQ+W2IPXbY0lnpmYOz6FpPLy+Bvayy7KQwE7Gri+DIc75zff/Y7Am/TJwkt2RN/wMUrog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8674
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 12, 2025 10:32 PM
>=20
> Create stage specific functions that check the stage specific conditions
> if each stage can be supported.
>=20
> Have intel_iommu_domain_alloc_paging_flags() call both stages in sequence
> until one does not return EOPNOTSUPP and prefer to use the first stage if
> available and suitable for the requested flags.
>=20
> Move second stage only operations like nested_parent and dirty_tracking
> into the second stage function for clarity.
>=20
> Move initialization of the iommu_domain members into
> paging_domain_alloc().
>=20
> Drop initialization of domain->owner as the callers all do it.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
