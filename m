Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793048287;
	b=d/lWrOCZG5X+MGbdHRjPHtLkB5zvnZkqG1wNfLaY2Td7LkJ6KPVf1MS6IZDrlmMxSXMC
	 7cW9utHHzZ6DGevYSaBqKwaeyaT29j/sNUU7fm/Y2haeV6JV6LT7yLH6/asYeuDTga7PS
	 V34HF0AMyDh4GXV2qDExU1G+7WxDWWrhNaB3mvDMnliWQjaeHRnn33A3BM3YQNJ8U2uSf
	 f9Y8LUVzzczbCHhkrx5Ad1MhQR5bNm9LJyIzNLSWfqUHwDdlTP9JzFfQeAp5nZ1P9rg0+
	 Moi3FBQ+73kgDk0z9DxQn4aOBEQO1z50vec2OpSRXOIz6mSq6yLozUbzAvu2fjotukg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793048287;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=EPb0bbf57H0BFcmllj2k9LbqNbjbisfCYbv4HFtJY38=;
	b=q0OLfNSsc4+GKjD24z0vbxCVg8tXl5D5/9EzqvPC9PT184s2dZ1Wcy1XkY2NN8TzX2YW
	 E1uFnHg8isU9wJ52gtzbnLZqpdvWGlHqt03PnwNrSrEmGYYQYE68suUYlXs78WMuY1BHN
	 ykBN+UFZ/LWGgEgMq6OmkQ/Kc5dzpFASSScOcJPFkuM1ddmpzEBGO2R7+2RF8FwfHNrZ2
	 QWU/nQuBoCqMnC+/sRrXdIBlyNO1pi1vALrGWEsPClCD9CivHsgnNS451H7u5T+vYWpSz
	 mO2CqkNGswL1DisTtHEbbTaRibF4V2+iI1RC09u3AxbBg4DksH2Ctie2L0pXJFt6dhg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=joxFKxGY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B6F606A31A
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 20:58:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09B6F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=joxFKxGY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793048285; x=1824584285;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EPb0bbf57H0BFcmllj2k9LbqNbjbisfCYbv4HFtJY38=;
  b=joxFKxGY2VyizHp//by1DfD1lpzhCnVfDQAUAsHHGcW0nGTbSrKi/7ML
   SpqUyeezSwbL3yuOL6NcDcXKl5fzQuzD4sa+f0/3CZUe/Q2V1FMvJLaWD
   ekctLsESt7qNDGBhGWir/T2JGFvJDcqbJYnJsyXwIY0Z1e7NfMCHmOvnp
   qsKeNKFeYuYgIpH1xy5x9DEO6e/XFrdvCKv9WnUMt+PIqe1yBraJU36Dk
   Oyj9IAD1TOj71bi3pI7v03BqkdozmdqYBB2d9zBD0PnsIhuLqOCI4zmAX
   20d12Mh/TrkT1YbF4oCHPkI2U6jKmIt0xzYlwOBC3ZQzqfe5SlYSHJ1ej
   g==;
X-CSE-ConnectionGUID: n9HeLsNNR4Sq0l5ivraeCg==
X-CSE-MsgGUID: H9grYBcXQ/CIPc3FYfawMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1616881"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1616881"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 13:58:05 -0700
X-CSE-ConnectionGUID: QGJlQ1D+QWOcde1FrDBBag==
X-CSE-MsgGUID: 1HZha2/WScW7p3ur++/A6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4758018"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 13:58:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 13:58:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 26 Oct 2026 13:58:04 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.54)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 13:58:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snR6NWrXs2CtqXY51eETY/12K1tB4NCD9Xe3x6TuoGO/g86mvABdajCaVxr+IeiQatgKTRMuLQ4dXS/WqDy+NAdB8XQ0LAGiTHhbA4WPP95DvSLW2mLdqpX16+4fXEBCojGG6pI75fKFbBOHt/B3OSV+zRK9b5YzZj39RAMpGQ5vrLSdm0p9KdIPfmnW10qwJZaX8ixCh4rFJKvkdLNOU9bGasV1Nnu6MJJkAENgNLcorGctFLdERlkm6R6MKEmlnusQJbItNO3PKxcVCeDkDHiwO41zSQzqNSDhYaHX3Wh2SyttnKFBoX0ZALqXBIGapMZR62hxx57EH9UaJEmm9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPb0bbf57H0BFcmllj2k9LbqNbjbisfCYbv4HFtJY38=;
 b=zOviOZTIVGH9Aa9k4LATucTFK5jo9RpYXyrfQEcery7o64qpAvumoDG6TsHzMJDtdNhqW87iUnKEBfYAUC79dKEbFvoJR6G3FeFveYPei87UJwvQtDxEOPtyK+0TE4zUEUTgUdtmxSCpWGIvdhnFk+sMPzrumUlk07YTG0/TLY/oO4OW6IiaxBZB+m3JK0jni/yllU6vJmN5eWcbMQn36/jvXsECj5n1Cs7hQNuydkv8/d9bFqwMne2VbkOTifmfs6bGLpTWldjeKedXoU4u01o5K/m9ITAeiSLc0+xersZko3YpCA96gwVLoRXdhBa1kaXRvIweqn5AIWV1Al/JFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14)
 by SN7PR11MB6899.namprd11.prod.outlook.com (2603:10b6:806:2a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 20:58:01 +0000
Received: from DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58]) by DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 20:58:00 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Sasha Levin <sashal@kernel.org>, Nikola Ciprich
	<nikola.ciprich@linuxbox.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Michal Kubiak <michal.kubiak@intel.com>, "Nowlin,
 Alexander" <alexander.nowlin@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>
Subject: RE: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Thread-Topic: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Thread-Index: AQHdWwudoMChayQO0ECiVCp7VhxQS7b7sh2AgAGQ0QCADbSYAIACOgWAgAMxpBA=
Date: Mon, 26 Oct 2026 20:58:00 +0000
Message-ID: <DS0PR11MB73816FBC498124CC7400DAB7D6612@DS0PR11MB7381.namprd11.prod.outlook.com>
References: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
 <2026-10-24-1-daily-reply-0016-ice-xdp-rxq-frag-size-6-18@kernel.org>
In-Reply-To: <2026-10-24-1-daily-reply-0016-ice-xdp-rxq-frag-size-6-18@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7381:EE_|SN7PR11MB6899:EE_
x-ms-office365-filtering-correlation-id: b839fb44-d330-4b3c-7881-08df33a3d235
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: gQ5G1SNDaZ//g5qZjjDuAdK0QSmUmU6XTNoiBSnPFz4qRbBbULGmwAMcccNFUKZVI3T5f1nB7/UJb1b7+XxkGvNF0jxk/5qUoEiiY1oliYQ2PPu3N0NZmsqIFUz7iKuQutCiXVbHjRhW6s7/Gv2ufX3Ri03DFFvgPSXRV/SE+rWJncaDvAiCaTq9FCvfUBhuO5o3iaQr8po7wx09/AZQVgs+Xxhdxj1yLPjPOfKGQjaoJPPsh1cWMmLtnXs0pHcWTAnq96dZlJF0Kuz0y/gS0083MxkDogL9SwR+baSaIgZ32g5Xd381O71XlRH4iQWoajbzYDSd92BnfCY/bUuPbzfB2fZDIjtSAfVgTm4nO/prPGDlLu0vgw0u/lPcfzzegfyC16GX5VKQ/4lnhkhJXTmHGV2Q6y1WZIrQhdzHGwys1bX6h74X1dF22fsZwE9tkYVAFi0ndox9/2NmhX2/TKxQpRsOn1kCaLbr/eNN+wF2MxPRFq5D2GtoyWDCII+gLE9L2ILI2fwuuWhDy/v0pByXD6GywMJuGxQdhc06hzVttmR78EptdHl0PD4u2TTpsCGk4jXHzl0vMerFTwxydNPGjDDq7nU1VS+CNIgebZSApyeY+EP6J9ZGaEGIXJzgys5hbWnOHStWbdNlpNaHeK/Z28t6lH97hw7G8hEIrkFA3P+9AHX0cpWWMfdf1QPHdwLPD+8GBykgxrWqExrOSti80+cE7jr8kra5QYwBHHk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7381.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?39aQsho3G6T8ZBoiwWSCejO0A3N5CtWuP5hqddRqIW2SELOizIX6mfLsvZto?=
 =?us-ascii?Q?Fdau8Qu/UYjvBhyRENYIZTpjFPXopAGiBr3T0aCYIDuKJAhfmbgVPwQsC8ZR?=
 =?us-ascii?Q?ko2pU2f0g5JlOk1YzHbVStWrEvshhJguGmIEwg55FlFb1rTr170e2KY0q7Qx?=
 =?us-ascii?Q?FtP4boigHhdNBV6b1pd1dVMamMDYidU9B2N8MIt53e9eBYyS35oVg5znyaVz?=
 =?us-ascii?Q?9XnSdvVG0S8WynkYeZDO1lE1Pj6NcaI9DI+o2yFCP1OKkemZNuciyHTCtwA5?=
 =?us-ascii?Q?oIHqD/wYeRUSTcA2eE95k4YGjaZM5UaITtR+xqyPVRAlAsMcyi/wyLN4lwmE?=
 =?us-ascii?Q?5/wOob9Rj3SJnMpEvI/updFqCtFBJjNjASlJgZuqfftpy2Pxj4bwKCY1nusM?=
 =?us-ascii?Q?CQ2v3AQY9o88gsyYewQMXgxvXK8aYXZkIB69s6VMEEbWtsURxISdbAGkntQO?=
 =?us-ascii?Q?sU6UqzfWfsNqqKCxaoyqwsN5qCO8DAuOtVmRDmPNKsoK3vc+z6nsnJAC4zZT?=
 =?us-ascii?Q?YMUjplbZ+7ETOy9FZM10WEO1yAqInDf18Uk/GDHWr0wOgLB37UcWARcYq6jA?=
 =?us-ascii?Q?w4KtPva6baHUwSCe9CL9TB6stmi+Dr1H+NvWK4UIPVuFldpdBPhpxRHEM8PN?=
 =?us-ascii?Q?ywK5HvF6rLKXwDMn/ebzmrbTwN/pGbH/HawFvpS4Pk4FwYJuu3M8Zz+LC8qq?=
 =?us-ascii?Q?ce3Dvr9dXppCemgWYd7V/PHAtm0G4pf+8VJBE/jyBkjZCbdj38lw0Vl8Vtir?=
 =?us-ascii?Q?BPDU3DXDQoz9PwQ4i8u/NdYaz0cwIn/HP+xQH6VQEJ4UV1ju1EciqjxPZ1m0?=
 =?us-ascii?Q?YhAA00ZqrbNUwirAE5dauTxsFxnuFYPtJ5/KhgiGJhV6zjhetQJxWF83rfZB?=
 =?us-ascii?Q?WOvvJBTtnPW2L+k7ZGXDszmpGqPTI9bCutL9aUcAPTBqAd6zgShd5EFlyaeY?=
 =?us-ascii?Q?5HLxHLCx+MHJDQ8A0iT2wZwAtlaqDorNswX2H3HMgOzD1bo3tSiRIbZcFLKO?=
 =?us-ascii?Q?Cq9XfqdYYp6XiCtuTnGewEwWMVYPahgBCKq/QLG8Ndug/vKOyNFf6qJu2EmP?=
 =?us-ascii?Q?FvXjTvU1VebHrZlFlJl/gHETor3ik6wDRQSnr0w/JVkSdyHFtZ0/neztqUNQ?=
 =?us-ascii?Q?+fzX6523onW1wcrR0A0Zhxj0EwiJIHxSR91r1ZLM3OtJ71X7UPLFrbp/u5y2?=
 =?us-ascii?Q?aGD4Jsar+egX0i7XjG9OmC5I/Vsp1dMwrBna85ae8LblMZC6pLpvtg8zPf+c?=
 =?us-ascii?Q?25CzZvjDuxKhsxzJght7YoPI8nyZTnjwYeL6viVo1gHkpOUfD5Qc24HUw6/8?=
 =?us-ascii?Q?AUWEK/LX5oJXSrCczZY6CWdmOVKZe9o4KFItoKt5EETy4ixwTJTcg/y1W3X/?=
 =?us-ascii?Q?wwTpl7zRG+clM7ZEyG8J32EDVuR0DTyzU5Yf1eiJTuyiX1NJlVwxtBgH36jf?=
 =?us-ascii?Q?Lwx3DKO71CwUH0U69eVROx2Cu5vxCTuT3sIEQFvbqZuhPcEdAtNKK/TM4mSh?=
 =?us-ascii?Q?MkS8UR8ZmBJ0H03wxsOKwZgCPmw25/ay8lFyhQ72rU79p4FG9IO9O8nmrLju?=
 =?us-ascii?Q?owT/5v/XSqdFNigQy2lQhUmIM/arEpx9P1P8uykBYIuR3NutcWCuXqrJVBM9?=
 =?us-ascii?Q?8i07Q/7L0cHPMagXjgEOZcbqLoqc86kEB2IShNeITi9kWqXZ8L1m8fcTH7JQ?=
 =?us-ascii?Q?K2FZgqWXdwHPuLDwfKQfEe0hjnA4Qx53E6vL4qAmMyfpHdE9GxejmLxIIkxh?=
 =?us-ascii?Q?gKF4acNPzA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 5NqpdJvq9l6IppZOgHVIF8KQ9YFmNGHG9mCrfJs3cfe9begCRrs5VNp6ul0BQ/dQ9tLt9UYHeTVHtdNrts50ooJWq2l44Tsyh+y+xPDyhJ/gwmemzRO28v8FxorBxjbQLxjbzEtNdXtDNqp+lQEwTZox0phAxyLOjfzZNqgQkSUd8rMFGQmfkuto2UWL0dOWaOyUvce17O1cdS+ujrYRyXFegItzH5v+FvnhCSPAufUXVJ7C86AYyyimbgzugPHliHnGBir2UrMAZg3IZpY0gvu4J3uwPTF4YpxuwQzziaZrMpoE8mxw35SqgVTB5JZRn6b1xJjUdPhwAgLFNkVkLQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7381.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b839fb44-d330-4b3c-7881-08df33a3d235
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 20:58:00.8916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xanfcZbIpIN5TMnzDqxJ5pEHToHw3gw6Cht7JJIDLTvXd6gLE1XjB3gNKvrWtS8joefLobkUXPAhukNxIGhbp8lvgiNPd/FflFzLmXm9FVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6899
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Saturday, October 24, 2026 1:11 PM
> To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> Cc: Sasha Levin <sashal@kernel.org>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; stable@vger.kernel.org;
> patches@lists.linux.dev; Keller, Jacob E <jacob.e.keller@intel.com>; Mich=
al
> Kubiak <michal.kubiak@intel.com>; Nowlin, Alexander
> <alexander.nowlin@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Lobakin, Aleksander
> <aleksander.lobakin@intel.com>
> Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
>=20
> > 02852b47c706 ("ice: fix rxq info registering in mbuf packets")
> > e142dc4ef0f4 ("ice: change XDP RxQ frag_size from DMA write length to
> xdp.frame_sz")
> >
> > That leaves 6.18 without the XDP frag_size fix (the fifth one above). C=
ould
> > someone from Intel send an adapted [PATCH 6.18.y] of it for the 6.18 Rx
> code,
> > without Page Pool?
>=20
> With the full Page Pool conversion back in the 6.18 queue, no adapted pat=
ch
> is needed. Queued the two XDP RxQ fixes quoted above for 6.18 as well,
> thanks.
>=20

Yep that sounds correct. Thanks!

-Jake

> --
> Thanks,
> Sasha
