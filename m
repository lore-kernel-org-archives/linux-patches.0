Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067AB2BD597;
	Tue, 14 Oct 2025 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428723; cv=fail; b=uXaj1GH+cyC/aZMt9m6joI0vx98oZ445txIs1niNYI+aovUUP511TMIaccUaphx/rIQgbKoaXYX6+sHjxhvrzmY1UGKbGjxuY+MR1OhEc1pNy2ZF4qiwRVFsUaN1L9x+j4FPXwC8sJz4qVdgovL8suBhE1DtCtX7txi4NjlE2ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428723; c=relaxed/simple;
	bh=PL6OlJLXyy5nQFCDMhcuTf9V9QwgtYBB/lWhnzg+wdA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RkM97lhbyppWBDPAp/l+JpjVbYgsiPTZmxPcOmT9ohvpUTCezysYX5RssV9h+Q+Fzzen2bS5TwEWUkJlcaAEybSgSVgTObEQv3zYH9aBEpnDpboQcWg3lNvhRM7ZW7bKPPUjZYO63fEYu4Se9gMdyEGrpgXWDqb0MXIZN/19VZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bCTBYmEl; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bCTBYmEl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428722; x=1791964722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PL6OlJLXyy5nQFCDMhcuTf9V9QwgtYBB/lWhnzg+wdA=;
  b=bCTBYmEl3qo8Mt0HhJPPo+3nKVne1NxS1HR4VXjlmuhtxirspiORR4OX
   DI/hezRvQQmL112WrqoXQUx4PS9eQH8ksGPdhv1DTrTPks6jvC4OpHxkD
   AklbpOX/OTx0B/MVyf+9sYaOkqquPr3HIh8gKseL+v7sj62mqkG+XD7xq
   P6g7qQfs4GIvMwbTiBLEFpcokNsFT4r4NrzDnU7bEHfWX0ZHaOMaZ0Ego
   MV0rARuYrXOe0j7M1TvvChDiyIXbztq29PofTD5GURPe4O4hd2TeuLRK9
   SNmIHKAhoPjctyBMytAeRK3kqhKsgZFew1snBLuDMJYpBYGcYgAssInhb
   g==;
X-CSE-ConnectionGUID: qSUkv+d9Spqg/hMQGmM9hw==
X-CSE-MsgGUID: 7cyhEaWmR7yUT7qYT92WyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62477037"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="62477037"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:58:42 -0700
X-CSE-ConnectionGUID: EDBqKKWrRQKnvsdW1RfQ0w==
X-CSE-MsgGUID: 2ZgzlRuVSe6K6vacl9QyWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="181048476"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:58:41 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:58:39 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:58:39 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqcCO8MNHlDmq4RpL53KdoRUbtcXOwDFJovvY/AfaIkLzVwYKRzHpkDcdXVNXxwIwz18o6d/cnc4oMs4A7HGLFv+Ejvm2jN7KI42a1L1m/jLI4ZA2U7g1UyjMP+0MVUtOXSZ+vfwaHj/Daw+KP8Q2AVbBkpilE/Zs9OA0kaUtDLxFZ0vE5+M38Zsi48xSMjUqobHxqGTjcjsD7VvVGKrOf4IIsXncchUAZb3+u7AKR1oCR0N9BJ2LhExMblw1KBcqi5T45cB7RX26MZRWVMoY6Zz+Dt2V3//OQOI/gELCI7oqQiRpPgt3f7k3EFsqZXy/aQlsUiEQObDUUAYZwHh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PL6OlJLXyy5nQFCDMhcuTf9V9QwgtYBB/lWhnzg+wdA=;
 b=O9wGdvo4gctCEXrR9JqGT+3oR/46QYrGCiCSWdQOCnAHLOTOjd7Fiat1/hdWbN34RPxuWjXJ8IHVX1yqTbcVbTJUgphBrHgn7V9pL3htQbf/KY8X0zDQxRtm9jh90l9BzbQ4FJkahhDC/y2IXRVvlAG+MPBx18AIkDtwu5reIFDkd+YpwrDNBN5z0uNF0G/gcIVu4NNs6qdBg+2RUbhJfSD3BuIa45SMvaRDKdjep1tu+tTlXyP79cExco2ijCQgkNnrkhaN9FWHncsuoOTOjbtkwvLjeThHHfoYkzSAli/PDLBP1hJE6UcVm+uV5AU/Co/VGhCS/8NNRxAp+zf/GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:58:37 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:58:37 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into
 the PASID entry
Thread-Topic: [PATCH v2 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into
 the PASID entry
Thread-Index: AQHcFq6dTy4Y/OMcTkirvS+keNtvALTBkp1Q
Date: Tue, 14 Oct 2025 07:58:37 +0000
Message-ID: <BL1PR11MB5271FC4F83276AC7D576959F8CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <9-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <9-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 7528a7cc-f668-4496-db8a-08de0af77b6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?kmKyBd55fyBZHIfV2UciT7UbudNMC+bzcQmyTBA2eN7nk/ZFdMfKAshnqyUx?=
 =?us-ascii?Q?AcT3YLxQthku+dvtuS8tWHq9bHwkAvxH2i9wjrTJeILWjQLZo+4XgtVbkQJK?=
 =?us-ascii?Q?KgTieGl5aTedqlcchxRN9ekOvoSJiPhyMC2fuBN93jK5yRQoLN+Q111rC9rC?=
 =?us-ascii?Q?bO3Wpa0NhpXl91STnmclwPVUmeuxALgvHq8g4tlwUVTpyZyMHD1rI6YQQEwI?=
 =?us-ascii?Q?8XpbJ4PVUyYUqkB8luerMOPve0+R5Z3XNY1xLVGHoBbb7rEX4hJxwzeIz0RC?=
 =?us-ascii?Q?tRUNqhUFDcIka9PXyKpf4aFcrY9tb4joUGeIjVC+IVWn0TPet+rLESdroTsi?=
 =?us-ascii?Q?O/CjdTMug1htkbCqkd0zdGRtX2EE4mIHi4QezgEmU4rFMWhap9k04XvaTeMs?=
 =?us-ascii?Q?Eq/1cr+fAmlGSV5eS8HV15dvaDVY7tsVIrXNinsoiEGsM8g+33FFtFkLES6l?=
 =?us-ascii?Q?j9GnPdAu2nCkucHngw8V+N1YMQ8K/Vq42JRm8eKnITv1sB7t1ESTa5t43esu?=
 =?us-ascii?Q?2r3RQtUTdbS4tLN804kIXqLsBplwZsBv1Wr9o3wbDWjrkO5+7DNSVTSEN4vV?=
 =?us-ascii?Q?cZM1hI/hO4/sqrdwTslOZzDNgFFDBbEQ84qCm/IALwdfYxFwSI4CV3NgYi1K?=
 =?us-ascii?Q?DATXk6ZSdn+9RVmuOk43GMYlLhDrpgu3lpq5EEyk+p6ClEJ6+DZGRbyLh+Sa?=
 =?us-ascii?Q?yiioL1Dq3bwCfzxoycuFcuH75q6PFk5ZxAtz2z4JKbbdkdbu7IdOkrAFWHPT?=
 =?us-ascii?Q?l4iCY21xaQ02XAK7LjQSlzuVY0pPaFNuMRXivJWI1YQyzlmYDECBfEbp/uYE?=
 =?us-ascii?Q?/xKaVI7wZQrnHVgUX28pQ3YtLHNQ3m/QDXahQ3FhB29jGK4cIaFRFxZFhQly?=
 =?us-ascii?Q?7s41HiMrvrltg9Y8NRAp+1nnjV7F4O3JlvMjx84mPf7zDjJhmLYpcK3OE8Gh?=
 =?us-ascii?Q?W8isfqTked2HLlNQG28w5AU9BXeYZrzqU7t/eNef398l6FxsKRcfj7JkXLCZ?=
 =?us-ascii?Q?p+nAyqU6o7Jd6UPcJoz4bZqn5CdxWYkEySRednSwpAZFqcxM7eTfcCbpEeDM?=
 =?us-ascii?Q?XnLJD4miprjXcFlfNoJGQQpQWhE2FxDmXgASehRNuYVY7jVYjV8vg3nVsfQG?=
 =?us-ascii?Q?BwvV3SpgcfP6dYW2K012T2qHTpmY3zXAOPjzyl6MuzxdONEfORgNhLpB6y/q?=
 =?us-ascii?Q?XMlVs9ATAdrMQo+Hp+0KDUBRw7VzIiKqJDcFBpMIiaVshl/Ju5rsKf+NryfF?=
 =?us-ascii?Q?fwIfiLKmRtutLSy0fdl2froiA4xzlvdboyPlhD9CyXlCKiH5Gxp3oS8LSoI9?=
 =?us-ascii?Q?QFDc94fyC3iy1q8KDKYmHmwwaS3RMzCinihw9wrUIlDulEsMv2nyZYeMZcU3?=
 =?us-ascii?Q?0hSksopLHe5oii9OwV3iFTCELwveWU00E+Fnmk3OULmXj6Lp5DhWM/Vmn89E?=
 =?us-ascii?Q?c/2h/rVZhGpY+SLD5YRsyM58HGJoEb1CSDI3Ae4LLc4l86rCIWSZmfRPoF6O?=
 =?us-ascii?Q?aBB0U1xbbTKdN/GwyK1F+YLxT3Z/VCT7utuP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oLG0dlwU2G12IMcl2sCWhZPwoSKmbj/EZt5/iInv9zse7oXEWejBv9c272uW?=
 =?us-ascii?Q?3XSdz+rJ50+CgwsQ2i63OpfcAWRAXJZG2eXcuHLAAyiIyBLyQsH1jASPVsuL?=
 =?us-ascii?Q?OqfP7eWyL91XzgezdBOinoTGop0nBL1bwtHhnnppIC25byAyxaRvzfWB+JMa?=
 =?us-ascii?Q?dHw/daC8RPpRBk6Shh3ItOMLqJjbaP+7N2fPh2VSpuSSKlLo4Ev87q1ceEVi?=
 =?us-ascii?Q?GbDUGBOT39LwOs74sQkDdWy2F13UFNYkXI2TTLtYKNeLENPd2T9+2una7Y9Q?=
 =?us-ascii?Q?PLI2dMRwA7q9GyD0q+q9WGwmVuT4AlQbJ4QkvRp78BOjl7oLvhTW4N2U7t7C?=
 =?us-ascii?Q?on7Ucrcwaili1NwOT/PiCsJyAxyw1W5YVgkjA0XdRYPydRyPDyS2qTPmMsEy?=
 =?us-ascii?Q?pG2JrlOUvd6Y2iafd/4gz3sy/lzojNINCH/wnXe5GSWi8Zx/cqkt1k0JhYx8?=
 =?us-ascii?Q?Gd3YArXelE6ZrcStpXYiWUp3muJj6rsTGBqFvybfsGp4esTecHWHp+hBwgML?=
 =?us-ascii?Q?kkQTrhhw0lGi0DrpFbG682mxSZbiwqV77oC5rgmijmWq2RumXXdPu3Bpy8Yz?=
 =?us-ascii?Q?SGIaerJ2oAhpe9OjiJUybBwZTr55mfwu/CFBDyamYyrY51yMRWljXdXofJBV?=
 =?us-ascii?Q?lUa9HO4SFyzgSTM9M+2hFiG6j1Kwprn7LdtUQ2ltBkrOH9v7AIB8Y9WmpzRn?=
 =?us-ascii?Q?7U4laXpVLHAPPaQxg1t3xo0bzYyDOrJjqWOhIb64iMJ1hDaj+TQ/TYvLnjVb?=
 =?us-ascii?Q?wIbJM/iuvTwD3Xd+2zS+ULUn14/2HeGENSznJbL/FZFlAzdOSdnJqiqXkldj?=
 =?us-ascii?Q?337Zzi7BOtF1c70AuroN6t8zzQROOiF7NiX9B1WTxUiEsCf6Xv62wDU630io?=
 =?us-ascii?Q?2+4bvnq+rml3P8JkYeZtZ9IrKmdpZSVTbxoJYqIlAd3r83Bp8rn4q8aLWKSo?=
 =?us-ascii?Q?IE+uuGPE6DGpAypQBdz7ahz7ouBR9bDgUjmCANOzB75iH4H8nZxG4wxDBUaQ?=
 =?us-ascii?Q?fqS9nesm79toFzNQaqP0Jx5cF5AB2jbafXh8SzBT4dbJpNKE/zuy7HJvzE+P?=
 =?us-ascii?Q?p8UKR/noNkxre00W0bsuUmfMEF/YLUcbSKTDKrEPU9CYz/3N7zEgFCqkQEB2?=
 =?us-ascii?Q?xp5pzSvoeuSmC3IuzTc1maV8Bw0RN/ogoXB53h0qQRxfVlGYR7kmLSx3YsYY?=
 =?us-ascii?Q?6bO94Dix89GBUpihtLTMqNpsddkipBMUgyeAoEEZMprIjjnCwrsaj4tdFx9j?=
 =?us-ascii?Q?tn5t8gukGkE4YM2LXV8ujZOF2xONvsEj1PS5OkR7a++zorqQdUawcEwlzp2R?=
 =?us-ascii?Q?EZcXuNmxI+f8Hp1EV/JBz9Xf3GJqS7KlkYGUH3QLqkPZlzEf+0IpwTW/8dMM?=
 =?us-ascii?Q?8LSgAd+j+03vFDpJIgomJZ8VAK0w4xjC2CD8aW7kpVgMvh7Jf8zlT80u/n74?=
 =?us-ascii?Q?gbcBhWERTmr1Q2MddD7q1J4zgAqRJpqEFcqga4xIQLfMF3YL1NDbqSLGgfnW?=
 =?us-ascii?Q?OugWAkGdqUAYeCdmnum1CvIagsgVMIX7dk77KtXdHaxHzgfEZUMVI3B57mvk?=
 =?us-ascii?Q?AgOQh5ymchKDp6wxTE66PccPfT2P40707TPVT0P+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7528a7cc-f668-4496-db8a-08de0af77b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:58:37.7126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 73R34Z+9eVGAbjiC/0qeNDYqdmz/dyvWnKn01SpgWQxP40Eektab6QJP9isYTUN/HF2RKZ0DBtb99QrgA12iNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:27 AM
>=20
> Currently a incoherent walk domain cannot be attached do a coherent

s/do/to/

> capable iommu. Kevin says HW probably doesn't exist with such a mixture,
> but make the driver make logical sense anyhow.

'but making the driver support it makes logical sense anyhow"

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
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
