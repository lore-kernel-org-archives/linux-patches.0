Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D1C24BD1A;
	Fri, 13 Jun 2025 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807531; cv=fail; b=dxxjNxrwFfxUuWPY23rVWPMKGIdHkn5jL9j/7QTLvgdzmx6xdJpatbB+oCthACbgrR5rJznrCpJwDeVgGSYmDkD+xCmaGB5v9NIglyDdfd7ojVEDoJNChxKaARzGLVpRmpA+lB/BP4UVMEx0YXbwYaGXzfP60OrUf2ZBCW7JLM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807531; c=relaxed/simple;
	bh=UWm+pgxFj2ci4gjQ/5ZlBmTi4jIbhCAzNl2pgvkJiOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VAtP/S9LPp1P1Cv7bMT8CO0rf/a9f4uzrvhS+WU1L/5Db/EQYdiD4gUYwOpXfeSd5YFYGMM6vlaAl2Oq1S6eqze/BmefVhW83dEsqUcFtZKiIdDujvsk/JiAgMEut7d+3pTHmoY7/DWX2zGSejjTx415xLI3IPRhcd/wikGi0Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=behFLm5y; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="behFLm5y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749807530; x=1781343530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UWm+pgxFj2ci4gjQ/5ZlBmTi4jIbhCAzNl2pgvkJiOI=;
  b=behFLm5yTApNFVyF/tBhqwuw6m6UEpOIard5CYBVjhruwmh5BsYMubcJ
   hJJH+SJiK+3uPHQWd+w8NiTLvuXi7GkMDzXusY5MxeDnv2om/npIc0Wx5
   H9Scd3vAffJ8rRzP6lb5UMQYQEvdFh4loPlBNvcguhmshVbexocxkrCk8
   ibFy8cvM3WWNdM1T2tA+uOgslhqk0b3qUi+02z5B5OqKw4L7bPjSvhBAk
   WB/MteNVUHl3xhFiJ/QUiaEqqw5kARlpHmXiN3i96o46zbncZzvdcGcPu
   LygN7wBfE2mxIV88006n2d8EJQTS05SND2WaBMcYmLHT75CyneRwSHayQ
   Q==;
X-CSE-ConnectionGUID: zCqLpj0ISQ2hhW4EsMQX2g==
X-CSE-MsgGUID: fCI0qdRuQSSZWJTZ1THaOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="39627567"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="39627567"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:38:49 -0700
X-CSE-ConnectionGUID: ms0Kl39CS6W0uG/ZwUCw8w==
X-CSE-MsgGUID: KpEEjAsqSbmi+T/NfVg+tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="147634426"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:38:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:38:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 02:38:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.89) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:38:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S1HKeHvxWDt9JwDRP5FfCI9djpEjDC7fjy8cokX4mFxv+UVjnFUau5eAtAgsC4fmB5fD9sYtkXZOFS3oaIOl4/ML9Vh8e2Pn2X9R/JJYD+ijcv6OWwOAoq8rYXFdNVZVe4XXdiqNVyh5RS8FvwACyIpSZ+ogHXmbutODaQIeY8Vy8UoYqfbR0CZDZw3k4a+0DiHbVw0FJnRGsW1sGmJn+5BRW0o/5cFyN53PscAHLVhW5bQJLWaYKlxTjVEs5IJie1uaL92L24xK8vTY+C/NaEN56/GI2Ubh8xFu4i9t0hMTo99r+5CoxuXoUGS76zzTa9O08Ji1DPKOJIzwg4tStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfkNtuHU8Osnljl+RcVHDMJ/6rZHAsn5D1dEaQu/3EI=;
 b=Ld3FWeO3b+juDEN1HNOQTEKB8iTQLxsYArXV/PsyLqY9OkFn9FkLLpsvMpAy9MNlAK+JmeScHwYKGt9ztcgVrGku9DgdVo/Au1/J4LjAAHO6XZGoIppVwkMeyqgeoSq2xE3GWnhluKq2KC0NeeLVKwl51/HV4y7vV/bW4FzzLZZolaRR2lH+8KXBqGfKSNp1Qs6Jn0ZT6yfKf7a5WcXFpXe19m7WPFZ6GqzyTntcS3oZSYUL2F1o0L1QpckC8mP7yCS42vpgSpPo0MdOWGcA48jr5oq7gluWzlcvdrZmLe6R1XpfntFlSRy5nlo8PNdaZsCNf0SVXW/hxORa7+Wzew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8674.namprd11.prod.outlook.com (2603:10b6:408:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 09:38:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 09:38:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v2 5/7] iommu/vt-d: Create unique domain ops for each
 stage
Thread-Topic: [PATCH v2 5/7] iommu/vt-d: Create unique domain ops for each
 stage
Thread-Index: AQHb26bO4JV9iUfdrkmr1W4spkmNeLQA1iqg
Date: Fri, 13 Jun 2025 09:38:30 +0000
Message-ID: <BN9PR11MB5276631EC5395DC7E4A2B14F8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <5-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <5-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8674:EE_
x-ms-office365-filtering-correlation-id: 23e1c2f0-fce1-41b7-3978-08ddaa5e0e64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ya96KPPFUTWVZ39cL48IgtWrHvi1UmfWaqVfnXACj15i7N2kae7S4+bFpCPM?=
 =?us-ascii?Q?nIqvICzyMzpb0T8OlrtuH+UgUcR72cHbP69FBZTBjUG1reFsJe0zLjvxj2PJ?=
 =?us-ascii?Q?tKehbYNpedgV7UQtoOu6Z0RGRvmbs2m9gFc+6HXW44m69z6T36qtb121OFe8?=
 =?us-ascii?Q?RS0lmX00i4XVOcD0e82VTsW6pT8wOfN0ls77i/BxFXd/tNwqrcazDNzgiX2E?=
 =?us-ascii?Q?EObknLh0jdBpuaP/gxVKL0c7X5TkjB8ho+dz40JmzvXfIvYxfQOsaUknSfdZ?=
 =?us-ascii?Q?PlP1bsbvhBs40DX5yws0ROw2kvLHEaEVSbB6ehF0QUk+OU+X/5MnolT1z+3m?=
 =?us-ascii?Q?ldsGklYkq0sZxRcPr9XFgOOxxXrNw58C23qfxfw0Y6RoIYVbDZ5Y0u1HSOo+?=
 =?us-ascii?Q?PUCn5kRu7D+PFFlKt7rwvKOFOmal91K/qumPasqIk7VWvhvBsV/gGGKEmrHF?=
 =?us-ascii?Q?IFbOuf8gKusH5ZJB28RXuntfH7FA35AaOIrxrhOfLOeQpwHMXd7Li6M2C72H?=
 =?us-ascii?Q?7joZLuKQ/xqBp+czXNQVQwWMqt2qWWgTsfC6rqYAY9cZhyD6nnOQ4xrb6BQO?=
 =?us-ascii?Q?wiyAlibtfevnYsfpX2bPaHWIlh9u/Zaaz0sMZB8NIdPCxGUx5d5Ie6b09kem?=
 =?us-ascii?Q?n785wwgmQ5CwABIRIKNLUR1OmfrPu8J1U1MVIoQi6+CUZyFkghYSteSQACqB?=
 =?us-ascii?Q?U2ksIeZZCHk1jxDV62fBrhCa83An7K/8FZ6n8hhT6BMCOxQIIpnmouv4RxzR?=
 =?us-ascii?Q?TT2wKYiYHR/3dNNV1LcOFTosDnooF/Jlb2ITYPA1verPP1zolyMtC7CDPtoQ?=
 =?us-ascii?Q?R8FwVneODJVdMPn6zeOTXj9c2FLYPNkJUiuGxQ3i+9L0hKPQfo5v8KUAKUxq?=
 =?us-ascii?Q?B0AzpyItwTMA7N7f4YnZtK/I26aaD2X/PNucHqqCbK9O+z2n4VSzn5QA5G35?=
 =?us-ascii?Q?4JBYF7SmnSOYLsa4zzyULmvrloQ++AN82JO0kMNEeqdXxvKpa3VLpJn2QK2m?=
 =?us-ascii?Q?VIoHeNupC8loyW72nuSeS1WXxJbl8mzBnygoDMpuRMByGaAu4I2StPrkPdrw?=
 =?us-ascii?Q?sQnCqP6Rj89pWgAWEz0Rc8WPattNHKZwxQlik3g/lCmXUJmgiMhOR+3UaNBe?=
 =?us-ascii?Q?ys7BomC5KiJJrFnE2tH0V90yGWUzuuCm5dMD3WTXhiKskEdxA2JfIw0X1BQV?=
 =?us-ascii?Q?mG9gr6NAG0KdyoWnjuIki1nMGrO7csDL7HgUbrmmkpc70B10uK0tIez6COaM?=
 =?us-ascii?Q?an42nFP4+epWH2YMS0F9RRGRquLCTkbYBjSld88UZzDePUMCGFLHrbREPCEM?=
 =?us-ascii?Q?fMp58RkSkXpD+IhSgfd/1TpkI3QK+k8wy7PugnFN/KngO8lQyjkJUBOL0m+n?=
 =?us-ascii?Q?v/+ogSQRoQw4esFkjPuVpUiBpLWhNustrxSBwiQuP5iGlH38Yi6mFyHD8/lr?=
 =?us-ascii?Q?WJNKAYbt5N54/wSiUkGMpdgOjcnm29anvakssA0LbNaI00zlQHwHnQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h18yv0ymwNGikdsWFvjxy28b5CA++Z9E4QiTS0BT/jm6xrTQPciDY04mvvYc?=
 =?us-ascii?Q?s+X7STDUMH5PqCxc0SrF5inRisBU45564gxjaVe/EnV2i81oiV5DFl9craJ4?=
 =?us-ascii?Q?ipOhrq7K4haUTDI4rW1vtiucpx2yr75duIBMDKBtA2Q4S24ftEEiKELAqTYt?=
 =?us-ascii?Q?m9hHCOGju9JHgQ6I8nIhGb4KmZJOe7sRbdWW3IcC4GR4cy1uEv8qQqvSeef+?=
 =?us-ascii?Q?VftWHkbuXQWg8CafXs65Jyj4MHqS9JjqksX168t2S8kkm3h/cEXYMW/NlhMv?=
 =?us-ascii?Q?J+UdYPt0lLcyfdUhg4xyEJgqIqf53Ku5gqHa/dkMRIN6K59IjgitE2BtQDjb?=
 =?us-ascii?Q?YPCDQugZEsD4OQ91WjT0Pi74s2WIyVqYMBqiK4FCFZHUpv3lDCy5MRHBYwHM?=
 =?us-ascii?Q?5IfdPJ5CNWV6iVplH7LJxEkcZXEDsmDMIyWVgjc96EhyRIoie18rtWq5vg3T?=
 =?us-ascii?Q?S+drLkOp9Jt7f3Kpgjc6oNweF4CJme+9EcjDE7G0gfe9F8t+BSOdecZc8gyd?=
 =?us-ascii?Q?n9EBUbjDLXCMfiS3lOcb6pam1FKGG0HHxk230jbxocxHJhw8KR57LtlQyBzS?=
 =?us-ascii?Q?Eb9xSJ3XpQUEARRskBAktMPpjAp2c98o0TpCJ6o6YWBeQ/hpkfDW/YcKY7y2?=
 =?us-ascii?Q?IN0zUZrKJQlw7sCBmma9BohB1GuDZoFafslTSbG7gviQP5bCFKVKU26N0lr6?=
 =?us-ascii?Q?d90gFZvNXrD/tUbUZNCC6dNWZY8DbJyLvvfdhZqtmO9jH2CEFqDIOHmnSSy8?=
 =?us-ascii?Q?MgYrYXnaxHCDGYYmVYFIn4c9+fXHjtXafIwg1ibg3H8dHcdMlo0G96ERfsnt?=
 =?us-ascii?Q?Zqq+zZ0vvj/KpdU/zh5JiX7TwVoqq6GuRR4rOtY7wIpRAXlW1WpIMptFpJ7F?=
 =?us-ascii?Q?tCnlsnWTCq6OppzGVV5XwHk6UDdMLbUtR8QAPFaKlT0en646WVGtM5NinnCb?=
 =?us-ascii?Q?GpDdvBSI5K+WrSft4IMf6TZK7/o2OTQu0e2ePPLdu/pHArj1kEg2XPAa3mVb?=
 =?us-ascii?Q?JX+DMc3B9ryLVVZGGSTQ+8zis4qM0mMCO7s4dkC1CE5swPLJZP80+gEYlpY8?=
 =?us-ascii?Q?NKR4zv+HxddI71jmyyUeyKTt93kJLx5U00pkEvUwxsbKX69+jxP5ub7XqWjK?=
 =?us-ascii?Q?fRBawCHK0CXY9QBuVkzDLBcXjDE17KbbT134xe8DjXNcKuAXo+xtK+3jCMuq?=
 =?us-ascii?Q?cuJzDLRsN6R9hFkEto8tLe3YGjrXxjfJvOtg69moRGdO0L8tWCvqpaHkJDAY?=
 =?us-ascii?Q?RZ8KPPD19HQE8Rp90e5zyEz6yTZrHepcQslJ90ameCovAHV13ryMW2c3Eiyx?=
 =?us-ascii?Q?BsY/PmZEz6yfGNzpkJrDRFlj+XiWKfLghvKNpH9VoNEdp3T5Px3ja7k4LZdH?=
 =?us-ascii?Q?f81pZ3+ZoifAAPsCIPPzoUR8fTDST8aRHFjOWG7OrVs3XQZJLGV0nzQYc0qy?=
 =?us-ascii?Q?HIRctBhgCXoq8lVjakI4AKDDrAZvkzB5ocxMgXflOLanhWxQ13Q6nkZ14bBX?=
 =?us-ascii?Q?EMHSf9/OVUUlMTFZQqVAo0CjBr6/4OvF+eDN68plqWn3PhdD/+RwEmiMuguo?=
 =?us-ascii?Q?8M0+bOfQVo/HRggqhTa7TOoNUEcDMFI7Dnxjyx63?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e1c2f0-fce1-41b7-3978-08ddaa5e0e64
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 09:38:30.1113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0V1Ow6OMHph5+qsM1eIOn+QZDOR/qpGoadoCKt6d3Oco3PO2mBvhvBMYQOdHEm9PCajKp5dFja6iw7LtEgz+/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8674
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 12, 2025 10:32 PM
>=20
> -	if (domain->use_first_level) {
> +	if (domain->domain.ops =3D=3D &intel_fs_paging_domain_ops) {

It is more readable to have macros:

	domain_is_fs_paging(domain)
	domain_is_ss_paging(domain)

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
