Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6B62882CA;
	Fri, 22 Aug 2025 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755854378; cv=fail; b=qnh7HY3XmKyU2XvlXtgGBXuyYQm7HqIB3QOb0jxTqNaekmQQedd1Ghf596X+oyzNj8+31/THronMfWH3Z/KNgpgcryYwJy+5lH/BGQxFnw1NXahzve1c8GNdr63wyp8sM3pmds0ApPHF51k9jSN/TxE7/KL/gXftzkNuSZNtJgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755854378; c=relaxed/simple;
	bh=C5LW08kmrTQUC5YGxcjejmQ1SKjnHE0d1kvJONbF/jA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BPw3AfYvDo299k0mHBjwhGq20R7Ii5TzJ0bd7deQone0kEPKK9xlaQrflLebrrOM0ab/DOSNhSrQIoL50z8DqBREgxnwsDKKBpy7o2l5cYdevUZQHpU47bvDTdqaPQsEX8Rvl+f9WaoYqE51aLYi/1Jw0EvfRLjT8R7KYqHu/rI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqPtDwEt; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqPtDwEt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755854377; x=1787390377;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C5LW08kmrTQUC5YGxcjejmQ1SKjnHE0d1kvJONbF/jA=;
  b=gqPtDwEtkWl0GLFkjwUUB7nXJUtyk6dqBOhb89J+wUX0fR5TZ6LHqa7J
   +2lq8HaBV3gndcisXfjXGcQ5cOPAbfR/DQ5BZpPgwme1AOr/EiVFhSbfu
   WUnl6Pw9SCFJPESSuIMrVB1nrslVArc/q+kMZS6bIvK3fhHkYvUk2EdOb
   aYPj/CN2blAIr43fhrKNdKs0kbiA4LHV7xVXclsW9Cg1TaDBLBOw1hWUS
   tSBFrE+r9q4GH7n6fTvoxDOsibHwZFWp0Sqo418GWRXKuRc2r2AHaeG6R
   EahUW5bSdORzJTDvlhVwRlIr5tTeZCoGWrKxDczAtxicx9PMKZgAz6Cnf
   w==;
X-CSE-ConnectionGUID: mOHE952cS2OQULtA70rD+g==
X-CSE-MsgGUID: DZ7w4K1QTPiu0TWc3hzz5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="45729861"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="45729861"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 02:17:40 -0700
X-CSE-ConnectionGUID: wopLbZsSQsiUkIFqUizgvA==
X-CSE-MsgGUID: EYImDhYvR62N+BqgJ3hGjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="167892831"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 02:17:38 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 02:17:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 02:17:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.71)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 02:17:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h936Si+X1tJJhdp6PddE7cgtPS5p7bkz+axI/fmz6+lROptnCCTrVFTIrGv0G+wRX8ObWvkR/SM+I4NboqDiMOV5I/CQmrsqe+Nxr9n4JvtJuaAwVcZNsmIbE7thzw5kci14konBPCsnAxYA5M3iyDfIobvxoXjvzehDEGwpQ+gLF3ddr/wd5Ggq1FediBhgKsWvkBaV9V+YiXc9PAIpEeoywDbT8f7dfInIWTlQw4wcnhQmDKAF3NiyFZkyuKlX/1JoCP/ZAyqia+JS/L8OBJkX2s/E/XodOZMDyWV0so5VatcKqKbtv1NSuk7mnEu88KW/a0QqvQaN2oHfahSi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0FpRHGGzsWU+9wQm2v7031S98MH3yOxpoviVfdfP88=;
 b=WfoG513b9WXmwmIFUT2r8Mim460b7Z7lT0TQAKeZRux72gnCY7W6SS0ojIwCpFf/e1pMJjlTke3VIFdw8QyvUqsLT8K4/tj2hOGtsfcrkFoKXvDak28fW24pj4bN5H8QCFFlkdMbY6rh9vcRzZ6YgwxRN+l7nwcWdpGKTH/tYIOdtzEJaDMSFM9wE8fFca+IX8mmtJlHh6UcJDWZgsBnKqSiXKpNVpkTpl4hPX9hVWWXiwxIJ3MtBuxTysgPvlD4ODQeE2m+vzbmnN4We/X/FhCfdKO2vDZgmPYmPcRV98Gzoo5KAWSdHyzQ0+0yPJA6OCKRAZqWDAAqvNfHyZ9Fjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 22 Aug
 2025 09:17:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.023; Fri, 22 Aug 2025
 09:17:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH 7/9] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
Thread-Topic: [PATCH 7/9] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
Thread-Index: AQHb9ovxO+sZtVpqeUe2Ug8mw3ENFLRunbqg
Date: Fri, 22 Aug 2025 09:17:32 +0000
Message-ID: <BN9PR11MB5276C6E52E069F5E2D608CEE8C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5027:EE_
x-ms-office365-filtering-correlation-id: b03a430f-ae2e-47e6-d3a4-08dde15cb9ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?KQKM2ngmF7ysm8q1f07tLQzKl5PtXhrvfJMiu9Vn07APoc6e+OVdLwu/9YK5?=
 =?us-ascii?Q?xss1gfoscvMeekIUNhK9Bk1zBubGcrkfDC87pDGI6E+HDFPOevgGcGT675gP?=
 =?us-ascii?Q?ck4FGD4nCy7Bvicg+EuoV/dM0EkUjK7L98hKVG0djD/aPVUZiSRZATHtKAkn?=
 =?us-ascii?Q?XegOrG50VxY3OKLTR06wtnMiZkgtIBOaMBnoZoRoN8fE7MzW6fgDFn8TN+Ph?=
 =?us-ascii?Q?tRI0rEDH5r6HB4AoUEbxoX/ihNaeeUJGS5QDcp6f4vrw+Ffrak4CqacBXJ6T?=
 =?us-ascii?Q?0pJf/aDGGZUsO27uJR1/uPiiyMcFfTVIgncOfHGRX/fB2YdMXiEiGVIfdyTG?=
 =?us-ascii?Q?wdbwLKOIfun+8esOfY26NPXmbs8lck8JbkJM/P1xJIcyOVjQBvv+zVqj+qKE?=
 =?us-ascii?Q?5LIHYGZqqmB7kkWTxGhzst1TiF3ByYCkBzTvlFX/0yJoEYiKHBSPxg7v6YB+?=
 =?us-ascii?Q?TiYgbX/9S4GKBnkA4zfySbwVEJXK1bZJ6h2GUVeurxbKT8ZD9ng9+7ME+mqq?=
 =?us-ascii?Q?E2qIEwueHo5kaTPbA5/+jlESteTW/aTgqk1n8GZt4ZL7EBYaj+ymBepJQaIe?=
 =?us-ascii?Q?KPmj4sqpNw8VniYyRMPyXyt92WB3U5nTc558jTyjA/Gtybr+RUxa57+OVmdB?=
 =?us-ascii?Q?FkVp0yRvoo4dzqY/474a9Q7dw3c108hovWRAfbeGnyS9dACXDXErrOfa7ttk?=
 =?us-ascii?Q?9zt7ON0QsACUzWfG/peGgQZZ0XD47ouG7+nVePc2md2whjIJGgnWsaGCLH44?=
 =?us-ascii?Q?qM8mu6eOpCvlMpxtRjvnxSXo1+YOklhTMxSw8N7MW/7cnLSBDDSEuTGQO8gC?=
 =?us-ascii?Q?YoVDNap12PnkiRpeRS2fUYJ97T8V6pPgKkyC3cMtHrwwGSn60dvfDSqDYRR0?=
 =?us-ascii?Q?BemCXHaw/t8T+YdmuJUUSPiZ4CtFdkQQvlxETphaAU8UrXmQvP/U8Ok3s3mc?=
 =?us-ascii?Q?pGQPlQhqoJyGr8mc7dIsCZikDDvpxsAWmnuyBGCZIGCiRb8EPkGV3h6zSBcG?=
 =?us-ascii?Q?Z3aEbfyX5nexyJAzGDafr2lZhLio0HeM2QFGTbKX/vaZAIuhQT0A9o6R5heT?=
 =?us-ascii?Q?U+HdCQzyxsOiGvzphGKAwVacblBVma3LWvCQRX1EsMPtkcyDuQ0tbZ4/2b9I?=
 =?us-ascii?Q?A5hcjs28LBt3zO56qTBccrBjnVam/1q+XfhAfkXBDM7T32FqVYl8sK1IaZnv?=
 =?us-ascii?Q?5kQqam5ydeOFYIiEQ+k5bYJ8PcneLa6fbxUijjnDu831GgTSM9+TMZNMWYiN?=
 =?us-ascii?Q?FSS0hQgKKlA0jj3NS+ydZpZ2Z4QTVeYPpDwnDYgakBiuhE4ViK4IM1CcacIF?=
 =?us-ascii?Q?VCWnxell6M+7rc2VFXyw7yB9wKVKulxykhbf3XAqx8at7oBKUtlXguUdkRI5?=
 =?us-ascii?Q?PC9IydFc+AVlk3Fzrj7juodXUtwcS25gLz+ycQnyb0W3B/ufNd5MzZHcku1p?=
 =?us-ascii?Q?jaalrecATurIQbonJdgUxMaviMkimOaxnDudOV+k16UIg14qg1FuDQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2UAtrLEDpc81jDjMzD/tvRjlrX//3llyBmv1oxcgegoCFR/DLo36DQx/FYRX?=
 =?us-ascii?Q?iC4g/FxAKDvX/Lrz9b980OWaPZj4EScpNbJ5se+rXtCL2N3/w01/xJPkvfOC?=
 =?us-ascii?Q?V/+PZ6YXBRm/bzYxuDy0yIcJu0R4SJW/4DP/9sfDd3qIMsff+oq++Q8hPPvq?=
 =?us-ascii?Q?tPn33fpKncy6Hz4cr0Pf77CY5yNS59TUy9jGtkuesy/I4KjtTb0p1+Lnkv8v?=
 =?us-ascii?Q?NBHKTppV5/JoTMmaKDFZYqknvAEwrW6gBupbA0913tb1WpA7xnRXibTimbhE?=
 =?us-ascii?Q?3wzCfeCyqZjWup8974Aq1R9wQ8a/NghDGLIqQfb8idEUhybyJ21vUugif+Gn?=
 =?us-ascii?Q?6TY4r5NYuc5/1l9Hy/rYNEUxqRYZi0e0MvMlBHpEa4Y1ZurFTSTkJLdJOuMs?=
 =?us-ascii?Q?ktBjf884gbhScVXFrM+dnFkZNsRB2E2VxcPTQAFptxRJQJcV59rYXlYR44F9?=
 =?us-ascii?Q?UVEOeKd4NAJieSUb9HiCKAIJm/Pwp8gIHzas5J2Dj/H6/YR5QMJNv9dacvrp?=
 =?us-ascii?Q?uW+g3+DyNikb9FhBr9Kcn8oep+p1Jpegw3k0rHbdG18GuVPZeaGglwSp67FF?=
 =?us-ascii?Q?RQ/c9xAux1K8jx5qK02YZta0/j6ouFANRLAOJIgb/KhlHWJg7rPELZQQrT3d?=
 =?us-ascii?Q?Z1XqJ8GsClqBFEkT8ffp9iypvW7Smd6DUCD9UqJCcuB/2TeV9XhhvhYjiWij?=
 =?us-ascii?Q?FmZXgAw+++wcUExJJkDz5dAFnY87y2NmLKZQntIJXH6uc/elMVxI5eVVdekn?=
 =?us-ascii?Q?BLV4mgGg3Bjn03bOxdnVVPpNIrQV5fJ2NTWeu8QVJDwEB+oRfqG5PeJAe02b?=
 =?us-ascii?Q?FQKlmOw1r3hK0gcRmZmVRhia0UX8DRCUYEyZTKy/JNhp77ycZHUvvo/o9CfH?=
 =?us-ascii?Q?o7vPNwDn3f3BjOuDSDe6gnHlp9tT5V8jaLOxysFMYm4HYd0U+pkmot281mRo?=
 =?us-ascii?Q?AvsG2YdIDxL3VtfxnXbFeA1I/U4GEm6pCLQ7fZIlR/jEAHqpP8heivxF0t2X?=
 =?us-ascii?Q?Y5hbn760tFCCapisK8MeopWQc+dQLzeP+aTaUgocU0viIMGa5d9EV2VG/m2m?=
 =?us-ascii?Q?NZlXTGSyHHXxdGm0h0H/2PYmySQPLIojRigyFjgOo7r3SCBbt/sxdR2bttdc?=
 =?us-ascii?Q?wnlopiv+P9VwM+F9f3O9pt3Elbky5pH3DCyIVYqDyMu9yaB3SAA8gp3loQ7Z?=
 =?us-ascii?Q?4YgVw8IilqZa8ZWL6Q3F9o9oxHigbg159sas1TAB3gdOTuWfvK+SpSLABqSa?=
 =?us-ascii?Q?ayt9y3J/+ghnIEXHBas4OmuQUzq+Zg2U3VVZ6eSYwL3tlFG6shJKIf5Iq8Yc?=
 =?us-ascii?Q?7P6LIErUGtIxM0UooWlP5uSU+nzVi2gGMzaAgyQ0EPMHs3t6ls37ikzJeB1a?=
 =?us-ascii?Q?lU7RkXdH43tzP6cqyn6epCmm+hD9CLxmD0f1xKBR5e/Kr6RnI4hw+5mHOp9A?=
 =?us-ascii?Q?G0QCSpCGXAFtGvAuZ03q91jJkL0J2pUAfI2eAEW24wlj8HhOKJmHdGeigaf5?=
 =?us-ascii?Q?O5jfQl64OjpnedvFcQAg9+WuGOWw5BF1kEK9vTi4lHoUyA41VMcXfVa1xU7w?=
 =?us-ascii?Q?YIHMO8GzI/nSwOPbQE+Z6K0Vdp/C1ufcnHKp6K9A?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b03a430f-ae2e-47e6-d3a4-08dde15cb9ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 09:17:32.9972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: suU51HA2GeQW71lt1JAc1QmYxep1GmbXndT6zfLq+cEWGMGHleVj8eeWDLpBsOfs0JC5QRIikL1/4r3GAFSJWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 17, 2025 3:58 AM
> +static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
> +{
> +	/* Bits marked Ignored/AVL in the specification */
> +	switch (bitnr) {
> +	case 0:
> +		return BIT(9);
> +	case 1:
> +		return BIT(11);
> +	case 2 ... 12:
> +		return BIT_ULL((bitnr - 2) + 52);
> +	/* Remaing bits 9-8,6,4,3  are only available in some entries */

s/Remaing/Remaining/

bit9 is available bit in all entries. As commented in last patch, I'd proba=
bly
just remove this line.
