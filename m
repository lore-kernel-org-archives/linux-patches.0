Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F511860;
	Fri,  5 Jan 2024 00:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PmrJPOpK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704415134; x=1735951134;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H0UjauDT0U08ukYw3PcmQ73AFC6ohS3Tf2hc4bY1vUw=;
  b=PmrJPOpKjzevF5We3Uv6rPILATJ+R1horbGS8DVRsNOx9pYQEoSeBtLx
   wE3xOZd75r8tirhtz5rwLT8lb1rK3tHPneiLqjEyLkxAYh1td/A2LFB6l
   Lb+Ua8WpzG89fE62B5p75TUmp07lBwZt5tyZ7XSwEH+Kp7jZ5WpkWmve6
   Uqw0hJAcEcJdQY5KcgdvCUKW7G9U0O46nLtg/5Q/hrW5+OWL6fCzj9RwX
   lw57zQg1GMXxGxZ0yCaacyZHCFugDwbjw59UJrQkmGrX6qUgJZvHCRrox
   8f1/mS2suUM1MuWgtYdzlhTV9ciCHF6NfsJpNHsnUd2zYs2VwZy8jUuTW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4210582"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="4210582"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 16:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="924082179"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="924082179"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 16:38:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 16:38:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 16:38:52 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 16:38:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 16:38:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKwIRlWnrgyGDJQV4tvKG04TytbISBwLuy/mbevm9++LWbI6cPPeHOh7gstS/EWUuPXGLL/MOoEKZnl1BdDT4i+hF2y7+e0voNeN36g6Y8Swmt9cxryPu0+xcfMf03Pp+ni+04kL4eyFzYlXP86RorSjhlfo14pfMScFao+mKsjsbGcyUYlrJH11Vki1qexOUgXI9Mo/NAkTmvzn8TyCxdzy8zvsJvL+TbivhCMQNT1YiXnfrmK2pe90lgzyC66D49z0VHqbO4Rs6OpzYCzwT9HYfEVOQ8mTDxatknsr/eSHF9n4jrgVvg5WjuvhkHgSs/cPg5wSJQKjpOiLsZGSbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0UjauDT0U08ukYw3PcmQ73AFC6ohS3Tf2hc4bY1vUw=;
 b=RbsELh5Hnl4wEVuovnWSYUY5/cpDmHNuqyBKTMuUdXz10cKt8OWo7VZeIQLqYYD/5RWFLEHz4bq7d8iXe5nTC1kwUYql0Qk7RiorD7eHrYZAMigP88jfASZqpPkWBExlKSe6XJnCad//wgqk4N1IvZ49zuR1HLoAD4ruS0LJevXeq5lGFscoOtWTzap4xHjf6tDBgJ8oL7LMXnC7hsYT9/mIumwciUa5aD6LXf1HvGxNLk6vLqzqoeOYtmJ0z58VscGqwz+VrFaUF+NuXaVS0TWNl+9SY9YqttV8ho9B+4F39B9nrse1aq7sTDw/ViGmHlrcjvXSV8zf2dmhiT0j8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6179.namprd11.prod.outlook.com (2603:10b6:a03:45a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Fri, 5 Jan
 2024 00:38:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 00:38:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, "Rodel, Jorg" <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH] iommufd/selftest: Check the bus type during probe
Thread-Topic: [PATCH] iommufd/selftest: Check the bus type during probe
Thread-Index: AQHaPllnSYt3xgdmFEuLUk7TSKQ4orDKYkPw
Date: Fri, 5 Jan 2024 00:38:49 +0000
Message-ID: <BN9PR11MB52766626A292048AA13F04A78C662@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-82d59f7eab8c+40c-iommufd_mock_bus_jgg@nvidia.com>
In-Reply-To: <0-v1-82d59f7eab8c+40c-iommufd_mock_bus_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6179:EE_
x-ms-office365-filtering-correlation-id: c452419d-b0e9-424c-db16-08dc0d86af46
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VGmaV3pMg7JsZjDpT+TyQdiiul/wq2hoNMZ9BivX142b0uLRceTAEg5xyDPY9vuKAk25OY9i6Sp6dXg2ChRwdhKPAvSCvlVr0y21e+donVscHFsNMNVT1LzS3MS11ecIiCdXGb3G/JmA5EEgAhHgeKI8QphDRWTntmEzxhazsLwakufB3QhYFjt4Cp3Ek0uYd+pfonbiH05JePN2fQEs1YekEVzGNGNA9pN6WOKAzAccuhcJyDVIhif3HhKaMfT70iCS28Kbxah9GG9DtNWXxDHjwQQTuL1DBxgCQHv/Pb9WmhCgJU4yyjK+fgIhve3a4x5wM9WhatOEkMojcr/3O6nPzLwsep8hAraTIspflcgWWt9EhHZFWfIyH+Gl/LqFLMa/fih3XmfPYPO/IOZB2YJlTlaBHnXJHeh0EL9ItSrVg0/kAEVbeMJ2LwNHl0jm03iMh6KbfHgqt1clZx/5fYSAhUqQ6z3G4mBhZhmRzwklCSrXfNaeICoxBdeSTdmzOuhmdADZh3Ka209H/+z4gizCVKbfjoA6SLRA2wZZqHXp+V9vENDdljR23vGR/xpCSiPgVoueKPoKA9eAjpaf9B7xRQRRAWmGB0YdL3ohg0HljmkAGK9xTfgheZ8nNoYP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(122000001)(38100700002)(82960400001)(38070700009)(64756008)(86362001)(55016003)(26005)(66446008)(76116006)(316002)(8676002)(8936002)(66946007)(71200400001)(9686003)(478600001)(7696005)(6506007)(66556008)(66476007)(110136005)(54906003)(33656002)(41300700001)(4744005)(4326008)(5660300002)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CTlcPAU3BkGJ3h/ei7N48y+Wiv0BRXEb5sNo8DHB2u9MSozRAJKerco0emzL?=
 =?us-ascii?Q?+wFzn5SZ1jXd0a+W1Xf2JVyQetCFkVMWudi5BanwE6jbxuZp7GR7pdDMhsO/?=
 =?us-ascii?Q?xKpscTffgMIbWra6IZMmF54aq5kErwmm8vm9GHUWs5gfrx9QCiR+gTaLpYnv?=
 =?us-ascii?Q?OZV1DESfiLueKx/GzhR3sAUd+NZUCsFRYAnQ9fd9G/L22AkNzUwcv26zVW7e?=
 =?us-ascii?Q?zlq+BW0iyT4mZR5ypAbY3Qelr1UlI8vPZjkkzMY757sliu+Q0OqidX8GkxCn?=
 =?us-ascii?Q?fqqdrwfEJttAWQuOwWKRp54n3EqVuNmd/tbY5ulsr6dmxTIawmr20ii7vcQP?=
 =?us-ascii?Q?cVeJTucuCazqcIo8KQkc6JHDSURI8LJMbo6caN2al/Hjp94WDFSf3Eg3TFhx?=
 =?us-ascii?Q?Xj5DJlY8I58o8Kjdosc2I9k57ScJPyr/Jjh0ck0v36xf9PYY45O6wejVjn3m?=
 =?us-ascii?Q?xL37Ko9incv0RcuVQ9bYMiMHJkXPJ7L8Q5uMRK/lcFXWRXe9CqexPMELEt/N?=
 =?us-ascii?Q?y2orlXnLomoqFiCRx133Z/1Om3KGDBdw8XoIfADONQLpZR0PnqsVM1k0Ggs2?=
 =?us-ascii?Q?Ghdp+a911aj1dTmd5X1kSRumsgPxXE9idVnG/K2pw3zNJrQxS9a+2WwUk0po?=
 =?us-ascii?Q?z4A3IaT9+QDbAPYAngfUckMR/0rQad4x7zqqAh2skBiOrYS9hQTjWWKXAjWw?=
 =?us-ascii?Q?bsjNYp5qpl+FMwmeFJZrkqHhOfdTebMACKxKmRkMdbbipmEuuLDfuECbuCwr?=
 =?us-ascii?Q?PoplIJzAMHGz0dr6Ks5bQvegoQH/xF6U8LPze13m6PLB0ddZrA3mZGMcWBeC?=
 =?us-ascii?Q?oZZ96DYbOtlfCsm2u1SKzH+hEbtWILEACxMtpN9dwnwNaqt3fjKZv/yBxWWq?=
 =?us-ascii?Q?aCPJ9/wmirJPpfpG7KlhBAyMRx28A/DRONWy+efddQugbcYw92LNsstci5xR?=
 =?us-ascii?Q?7Xhw2DJTDwBN37saHWXWGk8RSIw0+0Xv1aBWxSpYr4P7kPYpmFI/utpxmKnR?=
 =?us-ascii?Q?J6NSTashbhqHffrCvMkfXuvJzInbNAeqHbMGGC2o41dKlDJ5Lugx66R1xkQW?=
 =?us-ascii?Q?+yBkGttimSgjz+2GvZPbLyLiC3UhisnIuWmKs0jfV/wS2Ko8XHrbhx2WraXV?=
 =?us-ascii?Q?fHr3Vwd7rBsNB9RLqjqukr2UT8cAOkVWSu4QpNVBCqIapyGlMEe4kiYbEqfZ?=
 =?us-ascii?Q?q1bQLIKd+dC18xC6UuGpot/KVvqrLks9q8ZZmWl+bGD/TyGJZGChMyEmL4rM?=
 =?us-ascii?Q?tkoWlSYtQ/qtIVV6najWakYtdm3IGSRN8M3xROe2MPUtbd+qIr3fjwOwmDJo?=
 =?us-ascii?Q?TSZ0qvPKTuYeOrVvB3hqny5exKq/G/fjiMrFbgqo+W6ITxaoa3wTqk5fXone?=
 =?us-ascii?Q?dGj+KhYS6uoosUqJH32Dv5jXkIjgfxmw25n5u2C+e6j6r/gumpqeE4KXxznC?=
 =?us-ascii?Q?2D4dHzyugiMg8TostaWG1aaAXlat4S53R/H1L1SncvHhtd+WrBGh3QnrR5mF?=
 =?us-ascii?Q?bh+cv/q0VOdzkL716zGOz60UgOm7DgJiawtrNwbWTJaKA4eWkUGC0QpAIfOL?=
 =?us-ascii?Q?ORl9ZlNqWO6Adl0FkE/65TS4Zqa4qfRkDK4cuiAy?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c452419d-b0e9-424c-db16-08dc0d86af46
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2024 00:38:49.7055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kcSw/qyTmRqVW7BBYGuURkYOVbAc6foPPy4FqnXh2udxLFnBw4ijbdRG+6/tyhd7/iorZmS5vzYHz5z1yS1LXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6179
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 3, 2024 11:27 PM
>=20
> This relied on the probe function only being invoked by the bus type mock
> was registered on. The removal of the bus ops broke this assumption and
> the probe could be called on non-mock bus types like PCI.
>=20
> Check the bus type directly in probe.
>=20
> Fixes: 17de3f5fdd35 ("iommu: Retire bus ops")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
