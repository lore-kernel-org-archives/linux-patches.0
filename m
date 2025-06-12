Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3455E15573F;
	Thu, 12 Jun 2025 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716643; cv=fail; b=gP8A7/Qyc0a9O+a1gm12OEz6FNRk3sqWHV4JW9SUJ7t968x/bxqVUPGQAgyhJdPEWwwwvODPeAvwV2fQW0XqQTt5V+NMtqwTvOQ5rfeTlH7j7xMgft0tCe7bsV3q+ksNSeIRrhE8JB3JXlwLkqTzmnB4P1Ip91Uh4l+DR5tlxBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716643; c=relaxed/simple;
	bh=sKgoWcZIf6LWmhgCNkQqPfN15Zzj/dNCDBhKpGg6j/U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GQrmZj7qKvD+pdBi1y700JI+CHCPigT/cQr5zf8AZ5mk+fbGVgA7EINsku5Kj/qD5Wyy4ofwMAx7DLB7OUTRRUSrcTm9VNZic7riC2NsSqN3hb6B2RcsriPFV4MUpMNL4AJMHmGdWB+k2zn9owJ6dGcdxQiC032bY9526FYwfPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X+CuE1E/; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+CuE1E/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716642; x=1781252642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sKgoWcZIf6LWmhgCNkQqPfN15Zzj/dNCDBhKpGg6j/U=;
  b=X+CuE1E/3jFFNAW9lDYKYLoO5FStGtqaWxM71VYBlEygEcAW7HhZz6w7
   49EZeGYuI/xC/uvg0J2XVvaheSkFDfT/I8A7xjNwJHipTlaumYSRs1Q+t
   t3M9/t4mZJTttKGGldtZNGeoYuHMb1WORneLfuNMx6qK8T3kvKGf+5alW
   6aqP1LAw/n2cZ4Umh9P82CgOIoVPnaEhycJEmTTxoTC1cIn4/44oTNqmb
   0GcPnl+vO6NwgGkm3FyTlFBNy6frRLq2jNPUrnb/0fOl4ZqLxNsGc+kFl
   ra3/L10xs1dirw8vSiP/MR7o5WnbzVTHSpgV9SZ/JRNAdexAcPDv1TpND
   A==;
X-CSE-ConnectionGUID: QilrH4IwQ+qCMaPuvAltXA==
X-CSE-MsgGUID: /gHCDjubSCKDEqlRY8neZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51754731"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51754731"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:24:02 -0700
X-CSE-ConnectionGUID: S+G/YvhNSV2FcyuO/lwipQ==
X-CSE-MsgGUID: 0W/vw5jTSLCqlkMPW66kBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147337460"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:24:01 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:24:00 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:24:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:24:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xu2cWxxjprWkGeSY551/Yqx2EOsxK1V17mWmphootejrEmJNe/uml/8Rgr7WoGJcTCfCOa7B445Xq8Fmh7tM/CfHVSocrAPlM5P35d7eo0YJG/eWvHkEbFMvnjuu08CYI9MpBjx4E+Z0Un70tFcWLRjcWCsnaIoigFnDyiN0QBQL8vujR6VAc6N/z1kurIy5ODEc2irwZFJXYl1n0LIyNOUDDcuXE+tEF6/XjhABkESaQpcRUanwZI8umILFjiR5J1nQZNfRnJ5uKuibZAz2WEAiqDiZ6MVWdXLGdyKB/YJgukelMqIztgJd7z9jPNYBXfme9fm5YWFRMkoglUun2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKl+YKhiUdOWWkQghGINAFlz3CFL2ffV09dZ/fMH0I8=;
 b=USrvD8mlzVgWRGe8IswgMDfsui3dsZ1/c63rmFgUhXjtpIvRD60TEQcjpkt4M/XoOlnepYkWbyKLNeNV4/C6Kl2TS0rgqNfY6Tpl6m3g9WtY+UbH3EYyYkqWQBe9mU2QC0usX/LHVpt1NIxaokzOv1K1R3x3s0i/Kt3Qtly5LLXvRX7ZbYIRUGnO5wJ9c3GITaZWz0L0o2sxsgffYCUMRguwEJXAsK/3c2yl0GITHSdI0PVtJyNbf3r+MnpMhlxUsVYeO1ZMxe4pERttLMrKISmmyCbIktD83Dq5XRwjhSUZVx1nAnZ4i96BBFrQs6Jfu/es6RaoQ64fq/kDQYkyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 08:23:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:23:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "praan@google.com" <praan@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 10/12] iommufd: Move _iommufd_object_alloc out of
 driver.c
Thread-Topic: [PATCH v1 10/12] iommufd: Move _iommufd_object_alloc out of
 driver.c
Thread-Index: AQHb2WH2y8thw1F/9EGP0nFAUEVTOrP/M8uQ
Date: Thu, 12 Jun 2025 08:23:57 +0000
Message-ID: <BN9PR11MB527627F3AEB562829FD4B83F8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <2ebd4bcbd404039d4faaf840dc52d7c44f672016.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <2ebd4bcbd404039d4faaf840dc52d7c44f672016.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4572:EE_
x-ms-office365-filtering-correlation-id: 579e4f9e-fd48-4afc-7c22-08dda98a7a37
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?LfIS17mp+225hpv7avwDg+/SbeV3uG5VoDRccmdqA25GmLQTFQuVAPhFLQjk?=
 =?us-ascii?Q?+OAdx7aBx8RA08vGaUDofzDPeLAr7BYRIPVSPVMf5oo9hndH0lKyajFNAP8l?=
 =?us-ascii?Q?P4ip5tmQbUJjuxrDuYDVg2OpMuYuptkBE4L/papmvbxfoAPNsqNTkPLIhpSA?=
 =?us-ascii?Q?mY/MZRNoeREYwpHvvYGrYNDDnZX/x/1i8r39bzglHlY3USEe3urBhGQjUo6P?=
 =?us-ascii?Q?BdXRNnQRqrGWHuiTTSmPX1f+qMi/jNXTTL4eU0jGphXOnLkQockQ3mDq9K4D?=
 =?us-ascii?Q?qugJvU6diTlt8UcRbJPMhZd2EHDAq9Rh89anfvJnhLU+Id3qIk+jnChF1ZIw?=
 =?us-ascii?Q?FjVA52NHFvOznMCzFxksRemBp4TRVUP1irpkn6JxCXGpgWZB4bcoDlq3kBqq?=
 =?us-ascii?Q?Mez2519+DkY1DFmW8Fdrsay/7eddTKk83WVBsaaTGuwQJ0lJt5URSxfzdO3p?=
 =?us-ascii?Q?5tXtyd2TkW4Gg2lG2d6aviuKrZ7bg7nbje0aCqC1JeyWj9pCQ0uSGEzdJkxm?=
 =?us-ascii?Q?5XNv5QLMKWnSVflo8+jtWYh2WC/8jrZSzcqkbHbHSOOKAenX7tp+FUs+yD8O?=
 =?us-ascii?Q?aF7hfK/Nbms64ImOhp//vTqHAVjvCvN0KI+6PEb33OE0d/4W/1DBFlyuYeHh?=
 =?us-ascii?Q?GLMin90SymjlL4RXw+dNbatvrrlGMe8M69eRfMC7nXJBndtLFa9BaT2+wtf5?=
 =?us-ascii?Q?VK2vOV8sUqSZrj9R7eJgvUfi1Rx6xuoP87hlZBxU5k1FZ6rPO00WhkSkPlhv?=
 =?us-ascii?Q?GldLryEWGMZAj1gcM27vvfAPKvdo3ADyIA8fbTEWZnaKoVBhgjrgJ07pysIj?=
 =?us-ascii?Q?k/wAo7k/W6b0lGKNUFH6xWZy/IVvufS/iaPgFRpSIPcxkYccAGtuzfA6NJU2?=
 =?us-ascii?Q?1OiLFjZ980QwJZR8h0ZNB89F3AjIP4+BDZ+YlHNYRZRSm8n4RwtF+K3fOIxw?=
 =?us-ascii?Q?aAS+rq5aMOl7plcAeRJt1ph3PKE+ObvZmn6n6XOYT72bUqF8HFdBfyeeBcGo?=
 =?us-ascii?Q?HuwSDEDF8RarsJ71eOykymvMrdUumlpF6MM5C/U6e8TA48EN3l6j+4ul+wb/?=
 =?us-ascii?Q?Cy67aChfEjhFYiekNUxl5Y6Rbj4fcNnVJKLYQb/DCJrthexQnyebqB9GK3+w?=
 =?us-ascii?Q?6m97ISCJuo8OzdXYQukDikc+s1RNpWqM7oBDTmvVMzsDE1b1QHM61JoDAg6O?=
 =?us-ascii?Q?KV/SMz9Fk1b0qMtNaONBc/zeZt6LpXzIcUOzDVjImeHUmli8XOVK0A3JBfmo?=
 =?us-ascii?Q?e4apSOyS6C7IA2VHQmFvZH+BVprmp9h4nhBCafPsQqKUIeNJPEvS/KHOr3ex?=
 =?us-ascii?Q?TjKcthaz07r8eKGy0uTv+1YGawSx6FbwG9J1FLC8GUQFEuYK2+B5H2fpF9Ml?=
 =?us-ascii?Q?it0QMOziVR3f/Rdgjd82TbvEx8sqHaTJBmu99GZLgWOzEVBSAtAzjwsU71U6?=
 =?us-ascii?Q?UCIr6VdBjxdns5UTIN5kSSB6pqcUEkrMnaggFkQHG1GNSEvdoKK9Tw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Omltd+jfntz3x5ptG2FS/zrYiaHI97gGyoFhM80MgZorTdVmvg3Cl+AX0v4H?=
 =?us-ascii?Q?g+bYF12NNDVpJpHIPE4GtzlGrXt/muCskwxhmnOk3gWxT6m9mD9vKWLhKb89?=
 =?us-ascii?Q?PFte1ropytT/eJWhXhgiGfpT6OL7WSbhrzlZ2TfbVhy0HwdHVSB2KuTlHRg6?=
 =?us-ascii?Q?XWe/PJuPUrV/8ymdAv5uJLMojNwbx7kwDFiB2aOff6hWnJAuSlrimt7+OgR4?=
 =?us-ascii?Q?KatV3507Je4Z0wjU6huY/ez2QsoJkZHsgjAnxyv7qmYCvp97ICXuREU92Bu+?=
 =?us-ascii?Q?AbtOBnSI6VT4b0HGlx5FZ/+QuEjbln0mCvQX4nfGeR8NzMYIl5RiEIzmmDDh?=
 =?us-ascii?Q?ApDy98euufsWBQv2sFubWZRT72gB8Q7XwdhjMzxvW66145x6nPXT3UzPLAjb?=
 =?us-ascii?Q?qh9ZvmVVOJ1mGpUq4yUNsBS8qj29gms9/E5T9Zr+S8pY3SPItTBh1dThuS18?=
 =?us-ascii?Q?aL0L4Y0Pg5sHQBD76eGJeEOOqk9r8M7+2Ov+bqpEE3GUmH//vlTZgBmJEDqL?=
 =?us-ascii?Q?N1ttoc5re/svAHokbsPx/OHR08AyPFmJhHk8yyAYFmPowNJlxTASv3F3EYQ0?=
 =?us-ascii?Q?HZy5a1RVoAJvqeTjaaDZpzV06kLKGsu5nXQ2C+v1Sx0u/PoR02+fz4YWpIQz?=
 =?us-ascii?Q?gjy3AwDwXLw1cXYpo/7iPGNOyRXvL2c5bi9xuORz9oETctVpWTcm6Oq2Q/Ob?=
 =?us-ascii?Q?6MCU0KKEg0B3J1vAPnChnKtu/L0CB5Xirj80tiFXScN+bqWze+9MWaP7nKhN?=
 =?us-ascii?Q?pVNrEZL6ZOGFnw/phOOARYHPZI3FBqwDM9vy1RnytbT5Ho/exX8dJGvgNBhx?=
 =?us-ascii?Q?zQEMS7jLkh2lX2jcU6c/zrrl61gi7yFwr2dHSbnFmR5H9seG3/Tzw2i9tL2J?=
 =?us-ascii?Q?vJQ1lPUKDE/WCaVnrksYSYCD0exPhTi6mS/VB5QvUoy74CPaK4RoHyhkkYVh?=
 =?us-ascii?Q?IkrlpqYNV56epPPnyy6xeBdgRzJHyZe1jslDJdXnT0Uyw+qTjGRaqMlSAlMr?=
 =?us-ascii?Q?2fNAgP89vdKF238zPYyxaK6FEXDaFaiGdfUEO7gVHye+qsoBAZNQ9uOZDrDd?=
 =?us-ascii?Q?1R5W6wIHjqfqm9wc10englg7uq7fT8S8uUfj6ii8evF4wjISl1SbhwPWMHiI?=
 =?us-ascii?Q?proxzD+Q31RgqHCmBW4NFr8J+9H5Jeso5RRr2ZFHyimWupH7HZj2NQMnwJ0o?=
 =?us-ascii?Q?DW4MaR1QAwf+jueszZjpMkzwDMnucwtuvv2oiCBMiPjKihfJ8gJjjO5Wpznx?=
 =?us-ascii?Q?2KQm7jFkPyCirQXHJ+G7xnY8ToDp5ah6Re0flCOz7KYn6gheljJJI66Uzk4o?=
 =?us-ascii?Q?2qoWmZVmaYtZOzgqhSmiYcWreOc6tsxIq2DuLQEFLYy+Utv+pc9nAWJQqfGj?=
 =?us-ascii?Q?2ykwiFJNcfuPYHhjxByMf3yaLioGC5pPlUcUwYjdhNK0ul1j3XYuem2YW9Te?=
 =?us-ascii?Q?jOS3d5eBfa1jpnAH5ymWxnvoywHViKekUHgwnhNa+JHeVKtOhOC/f+NPCIpY?=
 =?us-ascii?Q?9gp26W51/vzEjZiLaM3jktRUpbMrnSRNC9zChaKSJTz4K4YuFgmiQOocGn9Q?=
 =?us-ascii?Q?FAjKogf2liXNoLokuy0mvALLcBkfg7Ie+CVDBsyD?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 579e4f9e-fd48-4afc-7c22-08dda98a7a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:23:57.7169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aml3SyDE/RE/piWMrqspBH/Pm0HPBQVhQonZ/Aux8x3MXe+iRUOzb244EwClRy30SyC3igRHnLpVs3t6dOCe3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:14 AM
>=20
> Now, all driver structures will be allocated by the core, i.e. no longer =
a
> need of driver calling _iommufd_object_alloc. Thus, move it back.
>=20
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    3024	    180	      0	   3204	    c84	drivers/iommu/iommufd/driver.o
>    9074	    610	     64	   9748	   2614	drivers/iommu/iommufd/main.o
> After:
>    text	   data	    bss	    dec	    hex	filename
>    2665	    164	      0	   2829	    b0d	drivers/iommu/iommufd/driver.o
>    9410	    618	     64	  10092	   276c	drivers/iommu/iommufd/main.o
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
