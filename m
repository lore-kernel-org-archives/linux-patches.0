Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFD130E0DC;
	Tue, 14 Oct 2025 07:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428482; cv=fail; b=Fk9b8nfQ49vw42HG4G3GmcBuwJRcMnIEugdgMcnKeGQNblEjlu5nYplpXw+djBe4NfhAs2WhA9nL3UFUFUizFQybUD4ffduuO3I3Vss8Xwf8rmDWHAuiLPMaGCWtlb0LFWd0oMZ2xL0OFqdJTOGlbJVerLJy4aUHRa7a0VCKyjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428482; c=relaxed/simple;
	bh=QJo5OKgpO5JbRJz3oND9YxVV7LzJG075dQi8yiqOqMo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KhcVM4ZA4jtKNMPvQXBrwI6HZDnn8wB3Sfl7hhvxXi525Im0md8hcf5jtXJlsNiB1uK9k0Capr+tAVlrvOIYJHyB8Losah8D8C7Pw7fDAi1HmPTZ+w2+SwlU8a/q3NrK37FlBlwGSxbe/jC6OOMVlcv69E2tQOX4ZsQ3USgCJDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8qVnNfr; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8qVnNfr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428481; x=1791964481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QJo5OKgpO5JbRJz3oND9YxVV7LzJG075dQi8yiqOqMo=;
  b=b8qVnNfrnhn+m91b3t1PqpyfVa5Opuwdb9iY4WJd07cjzQZ94YvN+xbq
   Q82meKFor1NYlm5nmf/tSWqXEuV9BZxU26c8Hvf/bDq5lBAluppgyvFxb
   gnlF4C4dtXaNLIKaxOuHz+/7mU4KvYI1d5VvIYsNnlBX0nEryqivNzk+4
   pX3yksVBKGQLanxMJvUGk9ISGwCACDMzSjWfAIyYE5GoMdSUVEkDz+Q34
   FoP88x7rG3YqGe5kkmBqnoXz4UMSWzxWWu7lI9nhApLwNONyAflXp8WA1
   7/cKsEyl9srogbykyPctaixvx1FEu1FBFFvJdn5G+tEyid2c+VjrPaMzv
   g==;
X-CSE-ConnectionGUID: VSktmxusTuSUz3lYjLAu2Q==
X-CSE-MsgGUID: KE8KbvJURq+PDB8Iv6Mtyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="74029021"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="74029021"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:54:41 -0700
X-CSE-ConnectionGUID: D9K8tZxPQgahfqtpafmZFg==
X-CSE-MsgGUID: kxGRw5UmTXWQQ/6HlME7Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="186915109"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:54:41 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:54:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:54:40 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.28) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:54:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JXcFxtJKf6bo4DSkw1yYY/AntRgvCon+ScPxULk7EEpjzRwOhzSBgt1e7AArjB+63ah2/GSyyKSLxeeE8Yn4AT5k5cgDKTzGVfF4P6AnvzGeW5Z9zgQGwBDsklirO7bBkJ6lFtLxxpLjtBHwe5wO4WwS0nGUAD9sb5gULesoIfw57+xPNGHqdiIjcrDtruFFp9VEn0oK/y7O3/6Faeu0I9jwBWBKP+KeNi4k17Wud6B6KpE8+kjPQVO4uBgcCQdkducwxqTOiEF2gzeQmqZHSsgMc3jMB3C3RmvHWwi7iAvOx3COTM2FrTpveQzRQB5WojgB/ADTzY6gHXWZKjaNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pLJsjJcW4pzTzRL+ltXriyfBNRieP0X+tXBrDMt8a8=;
 b=AGvzgG2QojIRwRCyPG2sFye79j7MkuKzyQ1iEfE4N0kBJwi/EI/8FvOUTK2MR1lQVCnA1RecytASdHvgiusIvdnpyEcitoT+3425NDJAk4Pn0jjcy9WRHB2L9dqQZ8jpId8KD1OZHM91k+pds8+6P7JRhBWRV2asMonybUILhO2ymi4NmTMmCVp5T8AOIQRdv8HV0JyH0hVnRnM3Y92EsOhR5oc/28HxEhR7BWgfyupNAML387E/27kxbJqYGC9BE/9k21CMbhrFpJmkollLNMcV1d02LOuU/wA6gMcBifqeVDAfA3VZRaqs+Ir3GClU/zaHOS4Km3Uygvsx/wj/Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:54:38 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:54:38 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 05/10] iommupt: Add the Intel VT-D second stage page
 table format
Thread-Topic: [PATCH v2 05/10] iommupt: Add the Intel VT-D second stage page
 table format
Thread-Index: AQHcFq6faKrdoiKrlUGQdP0I6nLrrrTBkeSA
Date: Tue, 14 Oct 2025 07:54:38 +0000
Message-ID: <BL1PR11MB527167C84F5D5904BD7B22B38CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <5-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <5-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 3c168cc7-dbd1-4076-7c6f-08de0af6ecc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?ngr2ypMcf+QluxnjchrpV8+ohmgKj/5AeZRXTVXhZo8voDrh++A4O2lChqO7?=
 =?us-ascii?Q?5Kz0cfu5Wrp1Mp9jsaALDV5JkYtUoehMdm/K07hB8lKfFYX7Jz9jbBAHQfJo?=
 =?us-ascii?Q?ZXqF/mXtemL1fS8oSuZMkZsnwqY6SlG8e0knuzc+xXRCXK+0znJw+TixYm0p?=
 =?us-ascii?Q?tB28xYNdaHlSMWtE5Ac1oCKIIOvWx6LdAtkvz9DjY8khvaDIzUE7gff2kMEg?=
 =?us-ascii?Q?rUZh2Q3U4AfMLtGmHJRJrmnPffXhBi8f9r4vBagEETv0Z2g09yqVcvVApez6?=
 =?us-ascii?Q?rhADSCeGkf2jwzL73f6fM9BRmKzmML+wq1GnwgDUeng8PhZn3DXeN4h55Tjt?=
 =?us-ascii?Q?C650C7Ik0gJ2YhsClemgMEoTG+dC0tk8mHB3jBGzgDxItqpjyQ5ridzVh7xR?=
 =?us-ascii?Q?3OgV0OWcwdQJMzb9RHDSLa3VJHScHm/jea4VAeOL6K0PthkHO9+bJIaQY2/M?=
 =?us-ascii?Q?AXDwNtL1uuyrlRrTcdgY1iu9eW7mUSf/CclFf8X5NlC9oiN5tjp6ZiMtWlnD?=
 =?us-ascii?Q?KtrxVr8xsRRkSaK65gyGzKuH+NnFqx9N3B6xVeHrmwY/tkAzcOHZ1dPxC6PR?=
 =?us-ascii?Q?tE6IoDsBVt4xeuE8pYK7wPVd8JX5nU7qTpdVZG0c7Avfh+1RhixBhgRDtKoj?=
 =?us-ascii?Q?h0+gLV++LIh9tGZAXjyYb1y7oyoKDZnaC9RkXNqbfULJ05uBroXlJvOvNV4Z?=
 =?us-ascii?Q?7BZR0caByplglhP2wthPyzlv5h6S/GYHMccs8boO/l0rpvLuMzg2K8fvn4aV?=
 =?us-ascii?Q?/0eGqMzqCo89686qtPkp+VQ6Hd/RvMijZJXNixalMkeLeCmD7UlUnhM8/XvI?=
 =?us-ascii?Q?xTbjVaSkxTUxM5kvmAwtBZFaMh+Lkk9tHa3FbAzXr0aKm+Pi55yHKZ/aduUX?=
 =?us-ascii?Q?3zy9sSfSrRpE1UysEQDtsCevuwAzDuQ6iAaeCS9JJDJ7a3J6efuNC0XO3dwW?=
 =?us-ascii?Q?WSaNTmkmErYgPB6iHFRKcKpxsPMa0KKjnfx2DKJPViOYzgIq+4Xp7md5m2fr?=
 =?us-ascii?Q?gC37Lsm79XfVLYN5H4rPE22rwkXShtmB7phNb4ZMSkfkiHdelpVfPbns/xBk?=
 =?us-ascii?Q?MMV/j1mXFHss1vqIeuMqf+xzj3VNCnDFbQOeMczUqYALFFzzbu84MCyipXoY?=
 =?us-ascii?Q?gCYxwsA2k6QLeyd5mq/ddQ6ZXYFkJUicdWZu6NiK9AbjvTkgNRsiLaZN0e/2?=
 =?us-ascii?Q?QAOXDCMbFCyz2lR4/6Iun9UaeUJTZ0uWOwOg9M7RDHuLzFWLd88gvDFQ4e8G?=
 =?us-ascii?Q?LKp7cGUcSP5GfZf3Pft8CN1mum8SrhW8mpkqxEq79SHoxTPaaLkckDMtidsp?=
 =?us-ascii?Q?9UXSokrupF7CZgLXiTmAgn/gX7yNLQZ7EQLOuK6SKExfvFw6pzxCvPCTL8+B?=
 =?us-ascii?Q?5xabV7ZCh2CF5raCTi9WwH09RJ503Af6X57Clj6C32q3MN2LIQwQe2jj+9uc?=
 =?us-ascii?Q?0i70c1NKZ8Eg1oAAPtow6rOrcP9oN22+U68GIRhqzwzdniHpPNf/ftIc+ek7?=
 =?us-ascii?Q?7sjQGIqAUO2ufUOBBXUBgaQ59L2yyF1hkuvO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y52t3MJXUW5lI8eaPSA3ppB7TayLuZLN6uwGD8T03/JAcuRHnmOL0b62hAq2?=
 =?us-ascii?Q?WZg9dz9iHXjgkJotC+/FgecSj4VmRXdyyxRD//LqTOgkjcRBmbENEdXuz/Gz?=
 =?us-ascii?Q?RArV1LhIJP8t5JTUapq3GqCJoKiFDXVGqr+nhNV/L0mmnthmeePeuBHmYSzy?=
 =?us-ascii?Q?NNO6obmE7Ld/ddpfnJoqOVM+vVAxAjMpigCWwfscyFhHm9RgTaW+LmKPrhTe?=
 =?us-ascii?Q?pfjeVzzXzWIFIkWRzWeQHdAi+i91aowEpcMjMUIVwkGXEU7AOwc69SFmnECS?=
 =?us-ascii?Q?P6Wxrt/t0v1dHAqFYngsynS2wgFWhWAeLIghVxxnqIrSIuY4TbR+W/gp0Tdf?=
 =?us-ascii?Q?B8ZY6WhQtE8JDS4vkDnNyNLLsFVtynhNZuT9OgPid6lNZRcPesduMDGEK8lm?=
 =?us-ascii?Q?HdJde7r1IO72G0dTk0TjPyvqhzwTzxFFnrow1TjYIuJ4MhZnoDNLK/E6KO2m?=
 =?us-ascii?Q?hDdpRLoT4k5zBjiUFlFSS0suuj/Hqcvbw0ykfniB5UgKoPqAsMHqCaqcjuti?=
 =?us-ascii?Q?C7IwqvUrbPhtlZfEwtpZvPzkVqCr7mv9wNMZ+ROQYqZbvwMwRQrILP3bP7Xg?=
 =?us-ascii?Q?2aZJehE/21FMwbxrhOey2tnIJkIdcO9MFoWXXtyaNM4bArfFNnOsXe3ETsdZ?=
 =?us-ascii?Q?N72ls9mH41LTuNFYHvUunNyCfoqoPlkIvv98pHtCTcMc42l3qKEO545D+BUc?=
 =?us-ascii?Q?xWb9oqZImTRW3BuhbRfBCK44RiNpB6S3MGD+7q7V/YGPp+SYw+OL4T5/YZyH?=
 =?us-ascii?Q?rszcbWsT7rnD3iMpfbHIZkg6w4QeAU1bnoq2TpMUz42A0D88kSSHZeZXCZms?=
 =?us-ascii?Q?dqnSbJ/a1z1GIxsrjNUefu89d118A2qOyrzcVrvPN9Z494NGgQsDsFDimWBM?=
 =?us-ascii?Q?3DZInS3e0p7q3PJ6uhS2GMG/OnLasSIcXbXRjmoerkQLHFGX2Ed8IigQGVbe?=
 =?us-ascii?Q?+VUFCZOPSHWBabIOrttqXQRvpnXMo6WveAw21Q4T9jIYtwQdVAbNmXhfr68n?=
 =?us-ascii?Q?loMVDrbhgNmIBq6mnbYDYZdvxpU/Jlp9/AFsPYrSonDmKS3uunbI+RF5WnTz?=
 =?us-ascii?Q?nBtMzh8/vapDmT9PZgwKNU8Jt+3+uVtMXz0fxpYqu3DHlFjpIuuWyzR+Sy+A?=
 =?us-ascii?Q?u+Qox0ijtQ2IYsULLX+rV3hoRg2cmJVNj0gJzEUUuCaTAsXDSnRatmHJAuv1?=
 =?us-ascii?Q?ZQUKG+trSsmP5/9uNTQOi2AqCLKy4JJdq6x4ImsgQawAOnUvYxP0UupiOgoY?=
 =?us-ascii?Q?Up4PPgDbK/62wu1H2BFWm2JKhQ/FHmHfcxzVxDV3IAwKHOzCZkKXm0U8K0q4?=
 =?us-ascii?Q?I3Owq3Z+1b8qCZzh/VVRp8Rfsz6YzK/FLp+gaKrV674qyEqA8hxWDEg2uv2+?=
 =?us-ascii?Q?PmZ5WRxUpUHy8Hk6Tyb3Loyy2JvmBb5yJ05O8JSDF3ZX1fZqoOHhe4refdLL?=
 =?us-ascii?Q?141tRk31WH2WT/WlNfYSDeU00VtLyQ2Uwf/z2sf78fBL4E9OZpCVz3n9IkL4?=
 =?us-ascii?Q?XXkva4XqAcWvLBfB1xHzpu0uYmAIsxQOlAPFV/+eLe/9P5fVOUxmUG2iSHbq?=
 =?us-ascii?Q?fyKEycCGUb5P0ldRtOTXtYrX/iYbeiIdQw7NYlth?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c168cc7-dbd1-4076-7c6f-08de0af6ecc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:54:38.3226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sLHvlx0vw6tJ2nHAA9RUES7sJb2OoMSB+KUrZ1EzJvVHJ4oHj7vLW37migtwBcX24g2Uu7LXPzOcu6uq+9R5jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:26 AM
>=20
> +config IOMMU_PT_VTDSS
> +       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
> +	depends on !GENERIC_ATOMIC64 # for cmpxchg64
> +	help
> +	  iommu_domain implementation for the Intel VT-D IOMMU's 64 bit
> 3/4/5

s/VT-D IOMMU/VT-d/

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
