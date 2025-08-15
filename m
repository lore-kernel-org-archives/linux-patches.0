Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739C225A4F;
	Fri, 15 Aug 2025 11:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755257360; cv=fail; b=OdEuqdbY51URrHPEeAl8bgViMlXXWUDSrpMPLatPlKnsFIh9q16v4ZAmNfmqxkJoRNodez2zK27orgQ1BBItCECSEXK/D+VuLeCQs4LHlNdg6wGbIAhR0xjpHTUyE/uS3CoDKouSOeZR8dOUORhdLUjqcibvn11mKB9bEr5lAnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755257360; c=relaxed/simple;
	bh=1YMZzcbmCXJMuuXvcKmxdNMhpNNywB1bu7csrHIJmLI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CjBIs47HwiT21QBziroO5EkskQi9qhujeKECQpfT5qr1XN4yNqb9hjmolOIVbaS0nQP2yCEpQoZl972bcGV3ZIfF3dRdVVQ5IA6kWUjSzc0hmG0SiMnGW9JE16TRf6BwDzz+LHM3TNZ2Wmq2OL2UIxjlp50wxUNq5q6kPUF8WTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e13BcZCn; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e13BcZCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755257359; x=1786793359;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1YMZzcbmCXJMuuXvcKmxdNMhpNNywB1bu7csrHIJmLI=;
  b=e13BcZCnoR3tVSFdj9VfQE358ythxCFFyZ+vHNVLtMDtTXw/YhFW0vvK
   HKmc0KJrZB4zB06y2+XIPz2PjE1oFHEi7ZFOImeIVw8lht5AULz4UKlnf
   T2t8Hw7qOr/AFR1ECyVPMo60ehnMiJ+r/MmOZsgquAvtkS2l2pzoHhx8J
   t+lWtDDf3wJ1iaSM8SE/wGp2Ht1lWaTjSDos0FTfLcRQUD0D/qrWOMFTF
   oUm8Ohlz3M1BsADQuAhBWodkpWf6AGKlXjxxO/90KnAJliDaNRWPRrcjJ
   0FsBP91Yeuujl+92sJLuEDmMvDjF0Rv5RfXS5al7Le/9c71eDZOzMZDlA
   g==;
X-CSE-ConnectionGUID: WcL88elCRdu04aXWE9Evyw==
X-CSE-MsgGUID: H6oHszBuS6K3VTr42ExzOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="61418497"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="61418497"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 04:29:18 -0700
X-CSE-ConnectionGUID: fgiMvoj7RKm8Dt9hVn9aRw==
X-CSE-MsgGUID: 8SuAPUDmS66O7Z6Q6+1Dew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="204177730"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 04:29:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 04:29:17 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 04:29:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.87)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 04:29:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIljOzqd9FgjVjN6O3H14sgOh6rGpL6XESMCMoVddQAv0OCMIXVpvcp63oBXkIgVCWyH9hXal7hVRo0OP5y4MkIEqZ6DaILhQmqBSwboYnh2mXml95qsCz4j7csjMqyADzl9O0HVKjDF5zMQnoh2sTehzQtItQJ6TepEjzPVQjgqEWh+/+u/VSCEOej60NJOybG5q9Yl8klvste1HA1oIO0eQoMhBjWe+aBvfoA9U3c/i+HA+obeAY0H9nMz8F+tS7mej075MkfsubghPIp+6yuhzCFbFP+bhTurHXf4/TfxGBjR2bfhwAzGidPTC7GIel6MdnZQ6ZcHNRXOH3AMXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YMZzcbmCXJMuuXvcKmxdNMhpNNywB1bu7csrHIJmLI=;
 b=BEcX4kKcwYxzfCV2RTLCAyMM3s95l0GQ9hp5Bo+asvziFOso4w+MZkc76oYCSsF4oqfTzEfchRpoW50NFon58dgmbMMOirZMsY5PjBQHkFuDqOYJHBAA4SQQvd+o2mb4nNJTeDWnW/0BdsCvxR8M7YrVOO5RM3nUpcuIcTh+CbFGRNvulnGM/q96OnNwgxqfZ5iA5JmTSADCYpvWqh+5ejVt95pdzmWPFUFrWps4ZqbbWkayUHtcj3jdd65e5VLHj+UHAITOUy0P4WT87LgUQ2M6VqL7L07mfI39wEWvFqrs9csMbGP8F+kdB0bs+5NANWnLBk3ZFYScKAekh3oh4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7549.namprd11.prod.outlook.com (2603:10b6:510:27b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 11:29:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 11:29:09 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH 2/9] iommupt: Add basic support for SW bits in the page
 table
Thread-Topic: [PATCH 2/9] iommupt: Add basic support for SW bits in the page
 table
Thread-Index: AQHb9ov1j7bjon7uSkqPKZvHQi0NFbRjwnJg
Date: Fri, 15 Aug 2025 11:29:09 +0000
Message-ID: <BN9PR11MB5276372E3F386A590B00DEFC8C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <2-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <2-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7549:EE_
x-ms-office365-filtering-correlation-id: 4a8e4d78-9e51-4a70-74ed-08dddbeef3f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?+BXFbt36ruh4yNygtbJlFaNs01HgnLQFJJ5THVKyu85pr/a4dXzTiiKviBs/?=
 =?us-ascii?Q?b4Z8z6gMbc9TsySGzbKQ8EbYLr6fHFcg2FR7RjX4rHKwwX8D8r6v/pYl5dCZ?=
 =?us-ascii?Q?flCD+EJCOhV+RIEcLXwdxohZ/0Y1BjG0Fm+JOjEulPVNtYkcJupiI5+jbNcz?=
 =?us-ascii?Q?A0C91M4Oi+vWhHX/xJeIARSs8n0DeOB5CLDuVqqsGGqpbmsp1A2G8nS83/cL?=
 =?us-ascii?Q?7rfooFoU/SdG1ZgsgtaxYfmWW81x7h9PzY22CIxS/bqAq3zurDRavl1YEaA4?=
 =?us-ascii?Q?NaHVDqwZ+lYfBgGOgIfjjvQMioMY1sebFm6iM6MWQA2FCiDowXMrCReThCMJ?=
 =?us-ascii?Q?IftWrqc6/6SDZfKW0YqPxNFmDOZ923y2EoZzhwCjvRmyHZ4ljYKwefN93Z/F?=
 =?us-ascii?Q?qwPCFPm+8nSMj0ip1jITZgHkcWdZLHcXWYTlopjO5TVsw+vRg1PeZO005udw?=
 =?us-ascii?Q?t7IA6QzjhzLAgWI0vunPs+m8tBgTH2gEjYuwJAXEtvp21vMT1EgA1SdfZP8j?=
 =?us-ascii?Q?Z9tL2dmNQ2Zmhwv/oEC2rFoz9ndmAopK8eiUtQcnE3zV2zQhjwj4uY882e6S?=
 =?us-ascii?Q?OQaxqNLaumsczGMzBMsJxAM34w0XfzN0GEwtV2HLaHdCztZtPzmdt4MaoJPz?=
 =?us-ascii?Q?hU8HVivsbIw/2zld+2y0sIqCzyY/0pTdik3lBng/5oTkO1E2DFrJqjfNLHNR?=
 =?us-ascii?Q?OBP3rxHevV6a+qoIOzy/37pjjgbdev4rfExD3n1LqUBov6+JjTqX1c2I6jFd?=
 =?us-ascii?Q?ZqbgwAdh210qj/XhzRMCVHuUaUf9Sug6dD6PvpJtYW8B27W6EWzQxcFIMRh5?=
 =?us-ascii?Q?4gIlazjHEqTCcadlM0z6B+H16Z+N291J2FeqcUKjaCaNpx1KxC2621P5gqjm?=
 =?us-ascii?Q?FtuTBdn87wU6BB8DAJ2o9KMXgmze7j8k03BSOI8WjvuyFITkAhcs+VbPeZTf?=
 =?us-ascii?Q?Vw9u6d+CDfb+o9Y8cHN4TK/dngidlobxVGJ09FJtaW4/tLWqOuidAiCYhViz?=
 =?us-ascii?Q?0wOAPT6xeUEHOeIMk0OMil7xPkebQ4tRC1I0nN9V2m7Sfkk77aELigepfT6c?=
 =?us-ascii?Q?AX3sIFE8vr2rBibFIQkY83vE1d1xty6QTT9qhGbb/QXbWgDVBJYdx/RD561q?=
 =?us-ascii?Q?66HS58peomzgHb8PSntxxO7iJjfgYKaOYBVWS++QIlqbunf+rVfl6V76Qpyc?=
 =?us-ascii?Q?p4MKtQNNMTasC0b5FIwiC3Es0Mx8Z9jhinkweXlSBz7cnHzqN75BY2YTy7Xs?=
 =?us-ascii?Q?YQITLMJxOfj/yPYZX7v8qP/3BDxdL/fIAK3+Ug5FqQPBvP4olCHh9s3173qz?=
 =?us-ascii?Q?fMdZ1XimXHfhi5Jepb4joYlx7BVtXMyhaLMnurZyHWtoAlgBeGyh6AmDqzbt?=
 =?us-ascii?Q?LUfccHjkz9qCvxx11PvCUO/MZNIZ9emM+01Q5qlYCwavyoUS8262bEu2g/iv?=
 =?us-ascii?Q?NgbXFneePWENIQkfH4CBeOinxbZ/jv6mAI1Xo8vIHPcSM9+K/l0gfg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lk/7KJzb3R1jpXTIRgADXm+8XNlqgiStL9isNrCnaiM2gWmZvEdtOt9Zle1d?=
 =?us-ascii?Q?qCUNXvNORJi20oVjzibRdTYEycL1wJ1BYBQ7tYoUYVlDo6mX1tNFX71MYgLr?=
 =?us-ascii?Q?588axMu2HmMZlnYj2k60et6w7oN9wFW0JAz3UqYPFA+xZTW1FhILWqarF9SW?=
 =?us-ascii?Q?FCiUdP13IT4qLJolmh23evkkZ87idWXVi6SUN1Y0h6c0lgjZe1DS7sdyTQ3R?=
 =?us-ascii?Q?txUSZBRGqpy9ydpSWpLKjyuCrCI10jHnDLAw7zA9wyZ6ipHlK+ln9imYAWn+?=
 =?us-ascii?Q?PzDhhH50GbPPtMU+JT53Ya+JVT+fLkhlzW9pkA5or3E2ETKcEgFjHeqkqeLj?=
 =?us-ascii?Q?2AngKrcsBFzRxuWc4eAv+nONR5K86EeW0Y1GvatbMwE2bsKzX8HgBHPqR4Xn?=
 =?us-ascii?Q?/+4nl2HrK4yEq9KIdUkETBRj139bzfWq+ozVRRdYKbA7SKQLarrXDGC9Wtzw?=
 =?us-ascii?Q?C5h4J+Oqix1eHCCyuCuDIR1KnYkexJU7CIbhcAlGOJkpF5Xyt/sqguXLcD6e?=
 =?us-ascii?Q?1GswQLLb8f4XcdVSutXlrCbkaLWVjDgLlRnFKSBIpjDs05BPllfskVd4x5Re?=
 =?us-ascii?Q?3fEOBLH3Cw3hnRiHlhaHd5nwvCNYF3ZkRZJ3oBGp5683/DN5w5UgSeSGBTug?=
 =?us-ascii?Q?OKUD+CyzN3hPBzhzlxXwrO7rDZXJxL+cMg59Iv35P8ezX2BxEfNi6wf16SLM?=
 =?us-ascii?Q?yUdzFLwWd1pfRQ6wtdu3hmcNkLg/xVGqWU/RBB8w0QECkN+Vr4AP1LFkXel1?=
 =?us-ascii?Q?n2UfY3p4rbC9/mxiy1EB2+peB2Hxa9UJkPPffQ8gtqo9kVB/sHWkav5+IePw?=
 =?us-ascii?Q?cv1PUX4leD3FAhvoKeCzndWl43v9AN9vCVAqGKbQm6lWha4pZ3UfsJkCaBLP?=
 =?us-ascii?Q?lOtLfGGQdOOgnDXHho04AcwSBIwkt6lHX3eUsEJfPqHdv4HTizL3SYk4ykk7?=
 =?us-ascii?Q?2z26gO+oQcbpa5d2h/teWU/cLObJMiyVmd+ky9FDY/tYq2ervcl68WU7BW2r?=
 =?us-ascii?Q?yHQVhLIeW2/ZZ5YHNFgXk98FpyoN+xrXPMhCU2wKjcp8SmyKzWhfVwWkcbyO?=
 =?us-ascii?Q?cI8SDs/LKElo77aMg7DbOKeomBmdUJRXi25oczAzsUk04BO9UVY7frzVZNGw?=
 =?us-ascii?Q?DOZbE+O1s39niKM7JlM22LZxFkVT8xZzgYFI8RcZB6hKPf0gj2z+F6YX5fSe?=
 =?us-ascii?Q?IPMN6bavX93pEI9Nc1gfSEkxafx2lktaNfQ97F4jWqurXXtwx6HA6AXtN+2K?=
 =?us-ascii?Q?cJpDZWs5tlysL/EP7exByoxvLC+8c5yn4Ni5rLCwFx0kLNEol4Y0y+Oo5swg?=
 =?us-ascii?Q?1cdUxyyQJBmcEZlm8vtOm7Zm/QQdud6FGuJVnXSqu2wicxKe7OaXx94s9P4E?=
 =?us-ascii?Q?W5ipoDG57OknakbITw9ftAQTZilVRyKgr1a510pm/WQaSn4Hnf1elGPQauKu?=
 =?us-ascii?Q?9XrgKisHlYGEFPdnx1wa/he+8maTp+Ip77YXix9BObNbyBQw+68th6v/8DXV?=
 =?us-ascii?Q?me98C7jJvYK2/gwIfr4yvXoKUpnIEf7dGzPj07pDm/dxTdbCgegI9wdNX2h9?=
 =?us-ascii?Q?+IOBMssDnH177p2cr2/kidYIJ0ePZAayKpssCRhe?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8e4d78-9e51-4a70-74ed-08dddbeef3f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 11:29:09.7539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkFt7j9hjrhbzMCqgsKWZosNuGsl3bqxkH3IRrCsgvfJQV5DHcNvQuzMMag54NXBKjhWoprHEkkDVOvXaV9Glw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7549
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 17, 2025 3:58 AM
>=20
> SW bits can be placed on items, including table entries, single OA's and
> individual items within a contiguous OA. They are guaranteed to be ignore=
d
> by the HW. The API is very basic since the only use case so far is a
> single bit.
>=20

what is 'OA'?
