Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A602AD0D;
	Tue, 14 Oct 2025 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427964; cv=fail; b=CoXKeBsSK/v5/kBu9f6DqQtyC4ai3t8QT5SYhSe58gehu0eAN2lDOJ2Krf2Tmtw5AZ6F0RTPecVsTyoH1wwUc/GaQRbGo/z5J1ig6gsGncO6SFwtKiovZb7ypDiE8xV5g0PWEnT7RroE5AbibuVe8L8W1z60sucTZH9FCWHMYNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427964; c=relaxed/simple;
	bh=u2jhWrAu+sn2qejAI1Qv7Q2FTHJf3VS2Qbg7dhLJREs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AWoPTcf8KXPZiHYxL5sWxfmF1Hd5gAD5a1jaHHAFvQbZDkIx0OryySjhrB4uuRYgriLfKYKMqiiTBoeX+gLWFaWyfQG4C3/H1VXnQJokFe/1gXps9+Kxi31XMyCX0eUfLA2tCb6ii5QLaM0EaiXCtL0Q8fE7Q8UyDmwpysPW8Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mYChCPjZ; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mYChCPjZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760427963; x=1791963963;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u2jhWrAu+sn2qejAI1Qv7Q2FTHJf3VS2Qbg7dhLJREs=;
  b=mYChCPjZGe4rk1zY3/GNYks3TYarThEAMzmKDBL+ondsmoV51UxTunWK
   pbUQX7dYFJGeAesyktXVJkDUm3fFEroiszZeazU8WmfH7jKw+SMDB0LJl
   Xugzz+luZrgaIbOUtMOOWgM9Q0OmuEGCPl7aTv1ix3Ofvh8JYUa794Dfa
   Gu7cJpPMgkorMsd5lB7LgBjcIoJ2Vtl3TmK9+/aeMiVtxumlAOiKAySCS
   AkfbY2ApR1ehUyGR60UqscCvayAd4g+2pcauwnn9Ma9d6rd3rzEU//5LI
   PhK6WWjNqS/y8CY3ONj5ryVOQBluonmRo/t+tSXEX5Bog7LsE3Wl4K3MA
   Q==;
X-CSE-ConnectionGUID: 9gphajBGSj67waNy3uBKjA==
X-CSE-MsgGUID: d82Vt98tRVm3h1N6urUSlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="73259740"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="73259740"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:46:01 -0700
X-CSE-ConnectionGUID: ISZ1V0ymSMSet5xwG7DxUA==
X-CSE-MsgGUID: Utyv9N1kQZiwq8lQhS7zIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="205509715"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:46:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:45:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:45:59 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.70) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:45:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bF4Lvqmpk0ht2RTsmH8xtYTKOZas2aur0wk6dnS9Umg/dBTLOPf5awXJZ43Mno7SdUtn5B2pBVd1wY22/FwNHDjcm0MhyZyPZpAHY5qXioN9onYuDhnn55Gk1bLkqnNqKZ8DFeOTOCcTFqkRCyfxqBff2C5sTwQK8upHPHp68Vw+paYf6KdjF5KDjczy5MaxAfyntdu3rJcCWxRcl23KNqKY1C+iS6YMz3ryBi8+hGfHEDPmch6LlWpr1+1MCVN2zfeHD2IMA00TzACDe34Lv5NWZ5pdZDAT36GoqrCv6r2OwoJ7XRRn6IRtk4DLWrQuOoZaE6tfZVeXcl9moI9z4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kWk062uW8aUfESEB1/gK8/BuGBz73QFbKvwS7NYl98=;
 b=rNIANRHOWVVyPhFT0QFRfMjJhOSp8lJrxwtX1v2KEJSy+xdMTWz2ErL6xpEsQbYMvJvL9oR/bVV1UpXIq7Cavypvf2z8x541jHFJWdAdU3ejOhj+v+7OVhegvpvkfinxXUej8WSiyuFNGTbYTelNXyp1ITQQoLjaJQsSeDQDVeHlnsr4IEnwisKB9iydqp0ULjslMBaYcj9FM/z+5QDu47sXQf9b/2IKl3ou8U9MfOCCMdYVBTo75yyFVPKMarwc7SMYt81z/aPhGHu149hoVzB+wwLjwDfjtG//O+O1pcRlPoUsp2Z8BtHdr1ei9eYaMYTmryXhCQGXntgpVAK9cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by PH8PR11MB8040.namprd11.prod.outlook.com (2603:10b6:510:238::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 07:45:50 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:45:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 02/10] iommupt: Add basic support for SW bits in the
 page table
Thread-Topic: [PATCH v2 02/10] iommupt: Add basic support for SW bits in the
 page table
Thread-Index: AQHcFq6nb9sGZulyHke2Vpr1qU92SLTBjotg
Date: Tue, 14 Oct 2025 07:45:50 +0000
Message-ID: <BL1PR11MB5271784B896AE595272B56D98CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <2-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <2-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|PH8PR11MB8040:EE_
x-ms-office365-filtering-correlation-id: 28f75eb2-b151-40c4-a879-08de0af5b231
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?rbvmbTrt8ukiDSBJKmG+EP2ikuKuEpw+/ste+5Pp2hR5KS8Wf69EnbtKZx18?=
 =?us-ascii?Q?/Aozn4kqUqumU1dL0txFpP/UMvNtkiqye5fmrRGCQ1LYzB7/CBvGqY5Fk2Fi?=
 =?us-ascii?Q?BJMfkl8G2+MSGpcGNQHAjx+Uh7ignwXvLXyBYQ6k3iGPQsGrFhTFpNcAZItI?=
 =?us-ascii?Q?zVnqD2fV0vUrwjsg5YdAaqC3cp7LKO8Z8bjP+1s8X8WjfE6DHxO0zGmR1wkN?=
 =?us-ascii?Q?JP8dLEYk/X0cNwcDZ6L+C14YZdHF/skHln0ypn2Uw68+CXz0RBuKgw/3g2zB?=
 =?us-ascii?Q?5jPowe1vwpFDCvkBbeO7sCkNtskPSSo2EkJBNYoC+esI4PNLfHi7pHLqLbV3?=
 =?us-ascii?Q?H/akPYNm9TWvpQWMdM85Ffw83F4FVk9P/c+Pvx9HThusrRLX03CgOfxmUbUg?=
 =?us-ascii?Q?XzvSHcGoxXQhA/HRBd6MuNWxfmqa99NQf1VzVrxXyzJ/r6LCxwn9tZRToHho?=
 =?us-ascii?Q?FyHh1xQLnQUmnoAjfJpT+FGWDU4NsNP4Er5jDi1OuIzbG1TO0pSbePUSKhqo?=
 =?us-ascii?Q?y0PHnAndQ3nUm8fT7h6ltXkN63AKl6iZDct/Q6HVQz1+1xrPW2mXHcCBxidH?=
 =?us-ascii?Q?H+0fkccHUFnS9xH1KY2TX5efmdsvBv5KzHxlAo4Tp2OQf1Hn1A1X+eAgFxd9?=
 =?us-ascii?Q?57oDqI69Enc61D2F0jnlX4zcNPud9PBgrTM8lK4ap/OaFg4LhiY5r72COmG5?=
 =?us-ascii?Q?TD9njuWFdpVgI8ivIfMEz+dTsui1hFdK3UUtDagHq7zGsmz0Ob0hLugmD2Eq?=
 =?us-ascii?Q?j0gPquXs9/ac4PTOCrsI/S+VNnjidmQLSZsHW1dmqLp+/q8fa40FJHeDcIqH?=
 =?us-ascii?Q?D1iKXQs+bfG22ZoI5P+2nMFsX9o45928l0k9uxG8J2deskbB/74f8EkhF/Fe?=
 =?us-ascii?Q?5YD66hx7m5QdRgs/AZFVLxPVlPywOMc/WDGtXcEeetzvePDsIQ80h06m3KNf?=
 =?us-ascii?Q?/TboxTiVqhJeaAXrwp8q2qSCH+j3V/zxzgb9i34UiqnNd/XImR/teH73qE/I?=
 =?us-ascii?Q?dsQt1vna0nbXIcLKCPKtGF+oBW7rB7CVL5Dk0hrE+sx6e+nx+DxIXu7nxoad?=
 =?us-ascii?Q?GE0ip0IJM6cDpaXrlZuhN6d4xFexvO++jmwZ61uMjlku5Xk3KiLE2vKxR2uv?=
 =?us-ascii?Q?xXf6HfMquTrHDGRY/aHL0fYlMJPhzvGKqAQCoxcwL/0/58iTI8v7Y9wI5du9?=
 =?us-ascii?Q?RJv8E5Ty3XSVoeG+a/kiRkL+vHWhxARQssMQBflrpQDE7bCHa42q6SLFWMlg?=
 =?us-ascii?Q?mIYpdpmqgihybgR8Sai2rZ6f9eQ8k6GfJ849iPnv/ZV8pWbxBqKu+uRWGtV4?=
 =?us-ascii?Q?HOh93f32rQxcA0JTw49SfLuqreOuRKp9wZXlK2Ymk8FRB5BeFCQsuPf3Tu72?=
 =?us-ascii?Q?bqyyWI69/YYIVHS1UAonC5t1HegJaZygmqTAXf7ZoIeD+vuNii4U1wBGnU4x?=
 =?us-ascii?Q?Sl3JCXCO7/WHlMVywd6p0T0BuSir3Wtb37nT10FkC+0Mw4F2qGtp59Zqfyj4?=
 =?us-ascii?Q?Wxl+wj5Kim4mZ4aOsIIQoBv9uSo8OILwEKFl?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MD21Z+nngVlrlnT3pFYPIXpbUoYeM4rrJ3qFiYXnwRuFT4tSYNN2AS9FuVV8?=
 =?us-ascii?Q?ST1HIHc9HBFJ6c90EdCjDBhqdv6yZrhOs/zA+QYNIFCyS1fXFfuP5W1To3GZ?=
 =?us-ascii?Q?z73xvGjpAYu97P5TQ5nFIvOKiuc/hdIkBkrHUAQchvE4b1zmLIhJS1pd8k1r?=
 =?us-ascii?Q?21ZYdSWtv85ewDNDu/eG/6MeWDqEuZ+smzJZy0+x9fEH1UQxXKlZyaQHwqJq?=
 =?us-ascii?Q?ckhXL+odjtFyo6jaJKJQ618tT5vAKxoW1hk2iZlUuE9uTYg9qC38kRyZX7BG?=
 =?us-ascii?Q?NF1qjGPXKYcYpusO2eUj3YgQtXBCPTEEp08oGXpfeKqcvYeiOuGb6oBeVMxl?=
 =?us-ascii?Q?+Fdr8SXV/STm9TGanOe2oL6ylFgUGnJyZLAZj7j4+kKV/w1GOnsXrQgTpnKa?=
 =?us-ascii?Q?7+GfWcpFUo3vAk1s2sI/P7DWvAaQ9odfon5mdsHs0yGQTpu/XUqvc+35ZRGn?=
 =?us-ascii?Q?NxBIDE7wt8ubl2ZVr3CcdSFM7PEeU5QtlrBekKRUG1ptlYGOlnDbNz70kvQe?=
 =?us-ascii?Q?Fpjg4N+9M6SODjTOhgGNVuakci1cQEdASmsNbgwGJ9e/N1kLFtCKJbb4hU6W?=
 =?us-ascii?Q?5KVvcvLsHhxQ9+8W41/We541PYGMLRmpxDlc7OrCS3PDgd/HT7pLlz0yqf+V?=
 =?us-ascii?Q?4TbJsindr8Mn8fMbfxG02eqlIJcxYG8YxWt2oLfGVoWkj/d6MamOiupy7Wqq?=
 =?us-ascii?Q?rwc0efAAAenp5ITbhgEnNvdy2oOjI6oKgduL3MdVpTB5DPXeCKyPN0J2yfiG?=
 =?us-ascii?Q?vVYTtO/1CyuwbxTIH8WvCAKa0gnHp6TeSrLxP3Tnlm7KciR3qhP5/U7pmgK4?=
 =?us-ascii?Q?WcVQqe8fJuV9opTpTUYnAgM/6nCWFXViPnHD36/1Y4aMsJd0yaMInj15v9o/?=
 =?us-ascii?Q?kqpXvPTjSBYMLol6Hd14GgYRau2Wut+IntXBJCcPf2dTwBzzNYr8wxE72EMm?=
 =?us-ascii?Q?UqaCD5MzvvlTnl2wKuAXV6QmWdy3xsUOBnCwVj/UMARWaP4gsSX42hG7gOlq?=
 =?us-ascii?Q?QwKeD3rYgtazUeCiT7oHfQYAUGQO7ZJpu/gQ4te640sfP0Kgitt5d6CMIYmv?=
 =?us-ascii?Q?SStw3ms6eRm+KCY/9Fvag7E9KwcLPmxVQkXf/Qnj0tDB3QQ8IXo3FBMa3lwQ?=
 =?us-ascii?Q?i5B7O3kT/P4kfoTIfasS9ahe9Mf0+6Q0sKuioPWRUBoPFeurxvuS8OS2HAA8?=
 =?us-ascii?Q?KLGn6sz3IUfiJtNUyM09txwxOV7pnpcPNIzsgR6GxKgAb+zHNyGvaWprQr2W?=
 =?us-ascii?Q?ddFJu5BWhKF0AMqGxW0VC5ReUI03gNfDg2rXzthPs+LD1xPTKLtEjxN0LJpY?=
 =?us-ascii?Q?VLgfGb4XFxtgq7OvUHXyfovS2Wuw1WfsObXZYXrrb8f/jstP23/Lt0AU3PXN?=
 =?us-ascii?Q?byQTRntZ95rf8WyLZpj1AYoC4oBdEJmg23OTDcReYncFtXP3hPdt+DjPdSMJ?=
 =?us-ascii?Q?ZAEHSKPll8/gN2UfvYDwEmWMe0FkMh5FSuHt+81LuhJW2PRVfUonWkqY94lg?=
 =?us-ascii?Q?QHBKwZeogeh1zGOvsgTQuQ+M90Joa+CHpgbkMGYfr1TOC/eXjhQkN5r5EhBk?=
 =?us-ascii?Q?CtRpmVt+NOtIw5eBAkYq9toY7ALHtEDGFugQujkt?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f75eb2-b151-40c4-a879-08de0af5b231
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:45:50.5380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jI0SMkQAVeCG48aHYZZIVXcXysgVjzoFBBJVDEasfSj51F8AmoMIu9oZ/aaGXqI7b5rINmmgdxmqJS3jP/iNZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8040
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 27, 2025 1:26 AM
>
> +static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
> +					  unsigned int bitnr)
> +{
> +	/* Acquire, pairs with pt_set_sw_bit_release() */
> +	smp_mb();
> +	/* For a contiguous entry the sw bit is only stored in the firstitem. *=
/

s/firstitem/first item/

> +	return pts->entry & pt_sw_bit(bitnr);
> +}
> +#define pt_test_sw_bit_acquire pt_test_sw_bit_acquire
> +
> +static inline void pt_set_sw_bit_release(struct pt_state *pts,
> +					 unsigned int bitnr)
> +{
> +#if !IS_ENABLED(CONFIG_GENERIC_ATOMIC64)
> +	if (PT_ITEM_WORD_SIZE =3D=3D sizeof(u64)) {
> +		u64 *entryp =3D pt_cur_table(pts, u64) + pts->index;
> +		u64 old_entry =3D pts->entry;
> +		u64 new_entry;
> +
> +		do {
> +			new_entry =3D old_entry | pt_sw_bit(bitnr);
> +		} while (!try_cmpxchg64_release(entryp, &old_entry,
> new_entry));
> +		pts->entry =3D new_entry;
> +		return;
> +	}
> +#endif
> +	if (PT_ITEM_WORD_SIZE =3D=3D sizeof(u32)) {
> +		u32 *entryp =3D pt_cur_table(pts, u32) + pts->index;
> +		u32 old_entry =3D pts->entry;
> +		u32 new_entry;
> +
> +		do {
> +			new_entry =3D old_entry | pt_sw_bit(bitnr);
> +		} while (!try_cmpxchg_release(entryp, &old_entry,
> new_entry));
> +		pts->entry =3D new_entry;
> +	} else
> +		BUILD_BUG();
> +}

so if CONFIG_GENERIC_ATOMIC64 is enabled then only u32 item
size is supported?
