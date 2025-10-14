Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398BB2D9EF2;
	Tue, 14 Oct 2025 07:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427690; cv=fail; b=Nksn6M1IohyGuvS/7DPLODCkKi4lpQ+Z+c2UvzzdWNLRo95or6AzPNFq8MMsrY5xeSGO3BlSZt7tGinF9/ATBg3Lermrzn+op3sjwwHiaaiDCttNGv+C1y4igGnQLuV1RsPDithfL7ebOWw0WJI+jEYuNu9dZ3KhQ8g6xVWH6SQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427690; c=relaxed/simple;
	bh=UVFmhcWDVa8bwj2LJH4zeVt+s0t/qe1IDRX8Qt4me1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B+1kTLMB46gxOaT0vDxY4LsrkF2k4bUJk8mytC5+x7YMq12eiRnvU8S0OAR4AvBBsf0fYZ08ZlLIeQyz3nU7mVC+q8ZThgBSTpZIEQIXbNDWX4TTPhs3CqVYWUSUqG13P4rGYy7TLEAPYk2J7GtfUn6IejdjFXLNAIwKPGJhceQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iDEjlFHw; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iDEjlFHw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760427688; x=1791963688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVFmhcWDVa8bwj2LJH4zeVt+s0t/qe1IDRX8Qt4me1U=;
  b=iDEjlFHwibufwXO3W75WrD5Iegqcu2yFuD/c8WJjLrmnPWI9t0+c33kV
   06UbcaflRSQWhxTNs0FefA+UxRms0o8GgeXO6aus3zAJQEUqTsIyEyJFa
   mHxql9uVaBCxyoAkd0UNYz0q7hIjBo25UgeBKIk+j0kah+VWInzgE/xa+
   NOFGhsQeXHpo+VlYEr5PU/hM9NkGeaXZFkBxvpbC01mcW+OvXdKshx/vm
   815Lz+a0zwV9kXd1EcX3vwAmcp+F4ftQzCA/jm8CwA+xjR/6lx+XOODBB
   XXMW/X+3SWxofIOI1poLgeHKmukCg4YVgwOfIAIgztNZrjp7ynsgaf/RI
   g==;
X-CSE-ConnectionGUID: gygw7BoBR3iB3z283HKcnQ==
X-CSE-MsgGUID: 70LuBJv1Q36MdyvmFX1QCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="88042671"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="88042671"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:41:27 -0700
X-CSE-ConnectionGUID: EUexVWG4RI+w9wam8ZJ0WQ==
X-CSE-MsgGUID: Hn+aAc+KTmuFHyyInYTrTQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:41:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:41:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:41:26 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:41:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKT3MdrNWIc7iXcXkDbfULviKrJhwOL7YCC30AMZh8XLnxu3nriPlkwvFhvM0UwpPI8CluESl4W5iMnoIe57cSFGDppIto4vzecG/ZVMjeyyx1TXv32KiD+UVzaBk5jD1UXRVzC3SN7g786aIAszJIaGO7xKNnb/qGCTovts4k4c7+D4yQegbAZAws582KaGnOrYTVgM1ZLOqWcCq755AYPAHqJnGs/jpTurxOinQklZoLGlXnyvpcjm9Od8lTqMxtAmrc5xLaE++rPKnUVkBqhwKks+d772qsrHyooy32zkwcoW4Mu1qIRdstU9jID9Wv+BA3VB28QL5I4s0oriFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVFmhcWDVa8bwj2LJH4zeVt+s0t/qe1IDRX8Qt4me1U=;
 b=gNek1aEejZXJJh9K6ld/isBnzasJRhcRZt9uA7A22QhLJ/+Ot5P0RRpAb9qxsIPffYODODLpcI6QlZwZY06ATAPAYhyFkubu6mqw3p96g5D+hxHGhRZzyGOFRk5V/DhAJjb01QelaFaPF9ZvFzRkKHZSbdFXmIG4S1nPiU9o/TDzmeP5R2nwA+EdWIRsP9I663Rkr/Zb3BSvt0FFDd9dWY9HHwoDYRN7vnHyQEpq3vXyE50MfKW3s1BxTjBEWl+NiaPsl7HKV3uWNUe3Pq7NTFHC6mP5VWTkv6cBhiKB+re74zyip1rsFMPi0d/OjmK6jFN6mmE/sSI0Ct0GMqYFVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by PH8PR11MB8040.namprd11.prod.outlook.com (2603:10b6:510:238::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 07:41:24 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:41:24 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 01/10] iommu/pages: Add support for a incoherent IOMMU
 page walker
Thread-Topic: [PATCH v2 01/10] iommu/pages: Add support for a incoherent IOMMU
 page walker
Thread-Index: AQHcFq6f3+HaUMGIBkqPiDTyoGiPHbTBjhqQ
Date: Tue, 14 Oct 2025 07:41:24 +0000
Message-ID: <BL1PR11MB5271AD5347CFE6E439860F0E8CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <1-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <1-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|PH8PR11MB8040:EE_
x-ms-office365-filtering-correlation-id: a9a916fc-1d48-4653-ee56-08de0af51385
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?l8BK8wYej7TS2rzk5kPc1ULr3vkAw2bafY86KSRtLQYpd2zbsncJsk9P6DmR?=
 =?us-ascii?Q?9BXV2FO2F4zmVpfC9AAO5poASRGyGjCLyBSASSzjOlMQwR4BpRbobe+NVYgq?=
 =?us-ascii?Q?hH8JkdKThPFPLng87AipuQCpkBl/5QjjfJhsm7GPX1VwNJ3J1WmSiIJN0qQY?=
 =?us-ascii?Q?2xf8zYkCZZh5fLT2nbxbI74svNn5/7gMbslldOfTmIUKkyLJ93cTU6GBV4hf?=
 =?us-ascii?Q?wWWOZeSQY0qieSc/98ahWAvwYMtUMP1m45KPP78hIDQAE+PXBPwZwZ8s0/W2?=
 =?us-ascii?Q?G3mj+nwvDZa0woIrTjHJtAdJPv71wjNqAgVhGHZbmZWY/bncRf9iY1AsmyiX?=
 =?us-ascii?Q?dqV9ty16YgABuT1V+YVifERwZk2pUqQDeRP7PJbGhuYkTqH6Rs0UEz13RvAV?=
 =?us-ascii?Q?uTb5iCHMHJbf6iVUwYAxxo/kL9GGAB8Kltu1oiJIMOnGjQh+i/YWFBPQiBtB?=
 =?us-ascii?Q?5cjYLKZBeyula91XBF8PAXOn+eB18T+jlr7uJPpGFLE6GTcK6DreAlN6CoTF?=
 =?us-ascii?Q?7QRRaXhB58XEOrqYr9pLMfIOz8ezKOLPtfBeZ2b64Rp3yJLasG5IytV1Q/yH?=
 =?us-ascii?Q?lI0zjdi7aX60uU+anii7q1mut5h5d5Dv+IO9cpQU2w2uaX8eTAymW35HRZCM?=
 =?us-ascii?Q?/A7ysuQqBzleKEudfd5ei/CE1w58wbAHCAURwT9/7Z8c/5R5bbfRJ+tUnSCq?=
 =?us-ascii?Q?G9YOjHqlj5YKI06+gC+E4h+dR+j4p4mYuWg7qAyT4r2+/68+zJoQLFPe6ijf?=
 =?us-ascii?Q?glWUyzkAbtpARAUY5Kwe0blF5POEbpUbGJSV1HRoRQJOeEn3wcQW0LBsyAYQ?=
 =?us-ascii?Q?Gngd6FwC5QSRjcxf94pyPSh9HXf0on1tTVjmRg3U6L2Cfy79CXUBwg7LvBGD?=
 =?us-ascii?Q?QkOso/QM/AO9+1B/hUc0fS2wESpZ3YC5GzRJw+ryHqfwQCgmp+evFreEW4Sg?=
 =?us-ascii?Q?v8EKnpKh7+pnmlGf3aLB6bx5DM4N2AnvCukaPIS0n7uqlAaPluk26uZ6RUAD?=
 =?us-ascii?Q?svHsmlAHuI61B7mWa+fANlPzY+NRUV+H/HjfrUhKWnjrjJVLSttE66zRKeSm?=
 =?us-ascii?Q?79fvS9fQpm7o3zQMKtRiPHiZas4KFqZMT2L7HyJ0UuuMKTq1IKUAtPNthXbs?=
 =?us-ascii?Q?aOYvJXEDgTI2nPY08QQu0FZ/+u5kcVoGAOiat3LJ7aGOy/uka77NnqtBNc9h?=
 =?us-ascii?Q?ByQ366LxIEfgExDehaYpEavdrb+eTL9F0jpK60AZAruwyisIkL1rCzBaXsNI?=
 =?us-ascii?Q?do2ZC9Yuq19ko/OS2pcCucuCsZ688l6mszLEScRft5POxDSzmI7L5+DLzKh6?=
 =?us-ascii?Q?X5xi0v9azJZfNSHfGWBj7EAyP37twQdeHtFKrtf7mRIY6xIxhGjS8Mqh+Lkq?=
 =?us-ascii?Q?x7zzK4rBKA6Ky73yzwScegGGW+EIEcaGfhdAOF2aNPGCCz9J8wstmWcukvA5?=
 =?us-ascii?Q?JXc9MUp1uDTwCmqoDFqk+T9hBAn1JgAshiicKxK7GiiNs5NY/0teBLwmShjl?=
 =?us-ascii?Q?3l4u3GVERRPuZCh3cSOAltE07a7EyTi0MqL0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/QX/11Z4EVS4MbPaUKNeOCS2wxV+2TZ3cU0OKGJXX9RjhuhPLxQm5MqN+mYd?=
 =?us-ascii?Q?7KV+N+MM/TCtbfTXF2STUugK+J6NyUfI0vlJAg/MrGkQCpCjXX5igAjJrMho?=
 =?us-ascii?Q?cZxkIZ84ow0FJhUtlchVKz9AonWg2OUsiqmXxIhZq7OQKoIpq+qSgTq0/CF+?=
 =?us-ascii?Q?YOLai7GvuRLk+eZbqsPyVvYgtsEcCRZYzJ9O/UvxJbRbC1JAQujpYot2B4Y+?=
 =?us-ascii?Q?H244K/9zamR8VXakPDjrFQ9PXacg30q/bdAO6rVjm4NUKwMflj2YnnaUkaIK?=
 =?us-ascii?Q?FvgwzU9PyEaPAExoJxKfagSC3g9X8CJC9fdUF104I+bkamUOdaa00WUeAnnD?=
 =?us-ascii?Q?Pj8dSy81+hCuy6HZwf88A4tS44bjxXJph6H795AzOJjnU9KwZlrDif+pD2FS?=
 =?us-ascii?Q?J4W7ynyDI/rJSXxKxP7Mda/JQ+FIgxmRjUkWWOcCv8BlrJzpDV/1/epIxYCX?=
 =?us-ascii?Q?rOpo83sPzWiP/5s+NhuOx06YxTltn+dqrtLW5CyXeDUhAel9jq98RY22v4wp?=
 =?us-ascii?Q?xlmEXvHHBx6BTa1/5R8WmKGk0Q+lEFZ+ehutT341QQZamptUPH6W/orKtv7h?=
 =?us-ascii?Q?+7O1GQtD/5excefynfZLn5F/HBGUzDr+ytjsZ6JXq/tblcImGFIwyHvL3YQy?=
 =?us-ascii?Q?GaDe+7jJPacbta4Ep00aaCQ/ltwpPoiNauMNYImNpve/cSF5gCNPdiKvJ2A+?=
 =?us-ascii?Q?yON8a3iwBF2z0GFZiA/2LBviMo/U9t6l2hvGE6KzlUOPbqJIVO0KlatzKlBZ?=
 =?us-ascii?Q?d4wSiVtW2nTRZWePxA2PNeHJRWqMhP5JZQBWuji+MMkLfyJ6Bt6cQuOi1OxU?=
 =?us-ascii?Q?SCGVYIAVgjfhT5nywhg3Wtczp7/QZM4yY/td5vLfF4CfAnHCnS7FbJGnQQq9?=
 =?us-ascii?Q?LSn8wYjJr2LKHuB5DNpvTcnHzs22/8gZqw/2RbHa+rjxUrlIOYwvC6CW/6kJ?=
 =?us-ascii?Q?7Vr7l7hyGNWWabhjyAErOPwRPg4P6rW4ZXexOP4wMX0zg5pwnjldIC5d1VPZ?=
 =?us-ascii?Q?qY/DTIHdvHkoM3h1e4TcthpbzMII+LfnqCbBiejXVJQ4FOoa6NkTzMDKLzhT?=
 =?us-ascii?Q?X7mXsY5yXOwGpVvbxVVfNR796VXyPl2Ppt4shEN5+WuF8gWXvnSpn2nBelLR?=
 =?us-ascii?Q?vBdMJaXJZ3gmeXLPp27DPanL7L5nr5aq/79iq/58GiVwqFO5Zn0R55P+xC4j?=
 =?us-ascii?Q?Eutn40iM58mO6YtZSlXtq71fPoynucgYc87Q9j28f3cVykLShkba+eh3fqZz?=
 =?us-ascii?Q?3OtmIoyY7uEL6AuLrbx2JBmKWnR/b6tRBSaZAzjKuRj/9VNbUp3wMt44TMk0?=
 =?us-ascii?Q?rulzAKNyPW1Or0pjnrjnDEOG3bzZeYDa/66ubT3V7pBp33pniPp4xQ5cxsjy?=
 =?us-ascii?Q?fbbOr2XYqzVox5m3v8IwODmGFjfQwhNeuHS+LrjzE+v1VP4uejaN7JgG3p+N?=
 =?us-ascii?Q?ViZ5ELhTNLbINNfS+xiBgegark8715/Iub0mgsXWHyFdtO8rSE4mXjZres8U?=
 =?us-ascii?Q?M1uqcX3eKDxecAFMSKp4C2pin3aOJK4HRLAINfn9R3bDDpCXonSS70GL9lUk?=
 =?us-ascii?Q?YVdXcCFmE1CbOQJWDmE9GV5aEjO8R3e2KadcDTEC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a916fc-1d48-4653-ee56-08de0af51385
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:41:24.2358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S5wMkcYyZoF4wDX9TBxQlr8lhEm/pOVYDwlZgTO6ZijIs8WuWYo7IwEuYrkgHyq7bjyoJZXTjhLwGGcSVKoV9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8040
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:26 AM
>=20
> Some IOMMU HW cannot snoop the CPU cache when it walks the IO page
> tables.
> The CPU is required to flush the cache to make changes visible to the HW.
>=20
> Provide some helpers from iommu-pages to manage this. The helpers
> combine
> both the ARM and x86 (used in Intel VT-D) versions of the cache flushing
> under a single API.
>=20
> The ARM version uses the DMA API to access the cache flush on the
> assumption that the iommu is using a direct mapping and is already marked
> incoherent. The helpers will do the DMA API calls to set things up and
> keep track of DMA mapped folios using a bit in the ioptdesc so that
> unmapping on error paths is cleaner.
>=20
> The Intel version just calls the arch cache flush call directly and has n=
o
> need to cleanup prior to destruction.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
