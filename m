Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1531A704B
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787760627; cv=fail; b=r17yX1AeMmTJzj9T/kqdAqnkYrlqdFRYLh4hCELFKHsEZtEiCFA5rRTndSpFaHEIbus+Widc7SsB+U8gJ3u0pRwUvlPFs3JyszGBusiXnfpExuM8bl2/AoS0zlxUaXtkdyjyUMRXiJeT7ZDKDH4GyZYVJPw8Hs0IO+BgvKDEj2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787760627; c=relaxed/simple;
	bh=qq1SczrexSvP/7gcAsSu8bfxzu0L+tSCCN3bGvg49zI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oSMlKXOvapYqcmZPd5E8CRnr+ObOtmiKMaklR8580tSJBK/Ds6skbuIpWFmM8eUxpGrsT3lUMpEEXj+ASs72MGhSY75lJmsLDHWfPppM4ykt/YuhPY0Utbb/BJHPHHLkK+GH6SQ/CvDrfXu/A7mDBebvfWyOcCmM3EqbhHez7OY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hN5L59pp; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hN5L59pp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787760625; x=1819296625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qq1SczrexSvP/7gcAsSu8bfxzu0L+tSCCN3bGvg49zI=;
  b=hN5L59ppM6XXEqVGgnSCJ391zujJx5O5huBkVM35ibJ4ABcc+Irwmp90
   oBiCc9m0/GrCJH0LW38w5FV1rgNMkemr5TxagS7FHm4wwR81W+VqAJXzY
   28KbteXFbIYEsoqi/c4IrhMLXe7F1jPysRzbSDV60F1T4ueL1dR5ps8ge
   lw8oGZ8pnQu6posAChaKSgedM0MmhTNwAasij7lnQFkBNHeGuYO9ya6lX
   k4ALUHPBsOVAsqS0edEyxjYTPEWk6U5Y/+X7h5z8zLNEnTC+XzILCdirz
   qqgKe5gX9FEobqFaGZiyqIr2S46IbhaD7deZyOL8J62ctSP5bYbbqGkLE
   Q==;
X-CSE-ConnectionGUID: EDg43mi1Tv+KX+c3qpYStg==
X-CSE-MsgGUID: hIkCoVCHQeiXA5wuHSVZ6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="98581851"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="98581851"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 09:10:24 -0700
X-CSE-ConnectionGUID: 5b9sUIHjTveVDeTdduJAVg==
X-CSE-MsgGUID: mUVguqJ8ThSZZXzlEDJvig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="271422077"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 09:10:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 26 Aug 2026 09:10:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 26 Aug 2026 09:10:23 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.39)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 26 Aug 2026 09:10:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bw9o84w3s3BpnNUp+EurSkI92wzKLeM3xuQaci3N021BsWNaiXxFwQmyen+eICWTrZ61qoD/DvKx9D/YvbDWQmgoxX7MAzvcPTNy1SbxsIiUbHb7005v08kYRmUoM5lHge48kxMv9R4ncdA6Cku8yQL8SVKcdcuv8BAkiSdIb5aCu+QbE2SV22eyJrVyNP+Nh7QYrRIWRAKiOR3Oklc/4XFOtd5IcBgByWrgJ3EZACEwQdM4GA6HrO6yFu9Kiq7mBdecvqI1Sgj1Gb5juass8bEc98GQqNAULB+RPFbGcB2NHcqnuJVRat/WbvqCVEZ8tUlKM1EQ+2eDiJQLjWbHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JC4WDB1Ib2ZsdL+9GXuA2fcYIVRFlfkleWHYPSmvS3I=;
 b=QEvflkAbmxwvfqCWP8MCxHU93eNO9jhGHs+BoyzscmiIUJHrkNFnx4hfl8LIBKPEfnPEoe1ibzH/ncbJQ0ItzkjcK3FjxPvu/0fOYnwTfCcJh4FlE3hwZvwLbafKE4Wr6F1mJnB4u7ioxLQMBpxUf2zM+oX3M6UUTFk25e6bNbnjY6zzhHsgnkVv/zsD8vUIJlBt6z3+KDPzi826eYcXsfG7SRomRGmNqXJTVrs8jxK3uU4J27muM/AtWa/93Ooje88CBjHWHX/JmyO+RghogMywaB1nQBxB8mtJrkS/nSevoMj7RV1fewpRMgleaoKOVpBcYso+PL2eXSItfNLVlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LVXPR11MB9778.namprd11.prod.outlook.com (2603:10b6:408:386::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Wed, 26 Aug
 2026 16:10:20 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 16:10:19 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: Hans de Goede <hansg@kernel.org>, Borislav Petkov <bp@alien8.de>, "Breno
 Leitao" <leitao@debian.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Subject: RE: [PATCH 4/7] platform/x86/intel/bff: Add Diamond Rapids support
Thread-Topic: [PATCH 4/7] platform/x86/intel/bff: Add Diamond Rapids support
Thread-Index: AQHdNL3E722JKPRtkEWbvDZojxTny7av/TKAgACCvBA=
Date: Wed, 26 Aug 2026 16:10:19 +0000
Message-ID: <SJ1PR11MB6083BFB77A052D824D68D5C0FCAE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260825181526.13203-1-tony.luck@intel.com>
 <20260825181526.13203-5-tony.luck@intel.com>
 <1dd80e86-aba7-0cf9-c2ca-5f72c9f0dcf3@linux.intel.com>
In-Reply-To: <1dd80e86-aba7-0cf9-c2ca-5f72c9f0dcf3@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|LVXPR11MB9778:EE_
x-ms-office365-filtering-correlation-id: f0a27695-3298-4e95-3014-08df038c8654
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: lrr3wnuPEUOMWmyEo6IjVianSv159rBftHl5hmiP0spberfPlhHAqmJ1QjYjyYbKBVFx3hKhSkpC/2UwPWcK+lcKvBsfR1K0yiTVhGGJgjreJWNKpPomIO3I7lALhk5Oa7fR8TIs/oRfITLTTTRmJL6Evcxh3Jf87bSkHLazGwV4X3UzboEMwulZE2PInpI6MXMRrLcNZzY3Z2D+8fdpV8IAnY6nyl88OMxGeZCYmFGOOy4C2y7oZvWLFBpcQGsSgdsb4HrJjpiyxW1nxT4lyfFjvXP/kIm/bBw5qzd0GbMCSrHKh0AtGd7CJQeS4MRBHA6XXrFHEHKxz5qXM2+ibexdhJ9MU7gK1QTguoibX6nZS5dYb+wqv5m/nPpKmrtUOwHkC/f8C4nLmcrB3Vhnp0ijZVUz4qJf0s6OKb4AgW7O/vOuCcIZOwmKs0t2nnqxH6ORxxZQavgr+PbMP/5PEPeKuXyNhWVSVIM1AK9irPoGIKSG547GAuFRKpnLHfgFm5wmctl4H5XpJskZjt8Q8Pf5lP7uXqTyIVpbsXPOPSEmE+QTDrYE0bKqi8ylJFSi+wvdrqN9EjKjn2CD3hTVnNmTMnRqn265uXf9O11S3WbULk3jBHktDAI9lNERhyCAuv6mFCSiakSyyHSNxdxrgqjWAMmJKtQFuTLfIk2i14xH97OcGz04rtbR8GP540V+vdtZckTE3P/1FLr2SD6PZBhKl5eEu7j9pe7LZdp5lqk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kKJ7vMqsY3z4HEoK5CjSR87aSQiuTH8mA9+T7rp5MVMu59GRvAFsspq1nK?=
 =?iso-8859-1?Q?1GW1Sq1Vf63dm1yNxvTKn+UNq2q/42FHEcKiKRJOseXFNfdE0CbfO6wy2k?=
 =?iso-8859-1?Q?rAUYBxsDhuikNCekshvMpLVUKR2tUewwh/yajL6RtY5vtsGbOAmn0k+U1B?=
 =?iso-8859-1?Q?Pst5sdUw2N0xxCaCLik/towrakAUbUWEJUFP2g7STn0Y24gfe5P5blozf2?=
 =?iso-8859-1?Q?T0tnrzGdMm+0QobeoDz+/fzsd4yl1FqjqETJS5Ba/KskANu+llCUfp2lNl?=
 =?iso-8859-1?Q?BhQ0cHCSOBFUOeQS9lesTNF3mHqwux1U/6OcgU55cuxw23Ic1X8opPJlcs?=
 =?iso-8859-1?Q?b01Uovy17neQofvfLQHVKWeWzzIIpoluyAEyyi0oEaf5uzw31qnYo3WhQn?=
 =?iso-8859-1?Q?Yos6A/BoXICaps09nCmvTYMZaDCzmx4cEEWN0uR+/gTmzrvIejCQ+fcvhL?=
 =?iso-8859-1?Q?dfX/B4nfFJdiWmOreYfGzaIUn+lo5VuESkK6l5hWGaLNo1PUbDyANH+E5P?=
 =?iso-8859-1?Q?wYcFwqes98s7/79H+uVxKf5o/W+ZQqzGiuNz+5MCX6/2Zi2XD+RbSNlXWj?=
 =?iso-8859-1?Q?4uKGHA1cglvZnbC7nXJjUwSJO6PUa9h9+Akblrzn8+Gr24rZdc4y3+Exyb?=
 =?iso-8859-1?Q?6iU+KGzQhlJKJVWs+dyIOhvyROM6ulG3H15Yczp9i5PQYGRCW9W9kMfmtt?=
 =?iso-8859-1?Q?Lz4rygK67bwu4KaqzHzhxtCbT4TEvJ9yyH11NlFZR530oyXXwFnwPYnoXJ?=
 =?iso-8859-1?Q?6mbvwmo0iVbz0Sb7KTaPc3rUgrT2dx71uz/503JzFl2j7dvr976Z3qSbwJ?=
 =?iso-8859-1?Q?/ucgv0/gsasy1/atOj6hFo7ZeVXYPHm+TEpyJLNwIOP+x9sXjsDUDOkeRO?=
 =?iso-8859-1?Q?n9wG6vqRaMZ/M1VEwa2KVFFBTJSLmFTT+eq9NPa0C1jMA9muLX564YmQhx?=
 =?iso-8859-1?Q?fOoB5pjFQYMeTZApvM8IRW0dzy6COH5sVyr8OAiKjR8VGrVv8TwNsONYHW?=
 =?iso-8859-1?Q?1Bd33R3m7wy/jPitQn2G5f6fo2Rf4qLxrForB6f1vi9DDLy5IlZAIoFSfU?=
 =?iso-8859-1?Q?e/i/7a8J5NKntweYCrETjOnwGLH15//f6o5lSoDLh4BLslDp2zBLYy3YRP?=
 =?iso-8859-1?Q?7SMy3Ama+0jeuyapbqW/f0z9wyYyFYcsC7BQ2EfrePUiQWzZIAZnXN40SE?=
 =?iso-8859-1?Q?bop0LdA2IVGbtklfMJF+gpdrU0kaCuoK0wWdUm/p6bUnqRzlpB7NRinwKJ?=
 =?iso-8859-1?Q?3jve9yBoPji+VrpLIao+rJgdMddTN2SBQv9UHWgMCqXglGMyr94iA2LhWu?=
 =?iso-8859-1?Q?zfjNZzGBTOUCdne1aJE3jSgjWhk1Bkhvm8VodMjVupqQABAxWWdlj3p2zY?=
 =?iso-8859-1?Q?DFmZZMGnbXZGxUZVDOACrm9GdUj+iG0c5v+LWivaRZGnrLxQo1G9X/EOVH?=
 =?iso-8859-1?Q?UaaxvUzaAHhHSIfgJoRK0Nq3CaUzRGbIwuHtLzcdySiXQn3rUNQJrw9aQv?=
 =?iso-8859-1?Q?5S88Kh/5VNcG+yd/ATbKNVcGaK/BUxowtfXJ418NAZ59fOmFzx8/WIgJWZ?=
 =?iso-8859-1?Q?q03erEpKG2q/E3dOuaITfmEBaBiHuRkGXnXlN/jH9+wmkuyR8UcuFJy/x8?=
 =?iso-8859-1?Q?0mItr1DcOZAiJ/8ECy2nrUVpPiXEYaPRVFK7ffF+oTpHrcvCPWnSSO4xwP?=
 =?iso-8859-1?Q?CAWLPY++3OkFNtJDSlovzHuCFaCNOWQpnMlbIc4Ir2/gFtcTQUmCeEVV2F?=
 =?iso-8859-1?Q?fBRzymk/Lx7cpKxoIOeyrPEkUuXVHZQ7zu31yjGs3ahOJV?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Yw+WPlZz0IaUrJ3I5KsNCNeSBd2Dc58N0EwIceb8bVoaG/UfaD8669NGpgfNcoGiPnSj2Nd+hHHOX02GEp0MfJt8oJ+J5sdOWcuSqBtXPbk7fXRJAATbGMxHeSHhkfkAJB6uzP+CHW5Pv36SLTo5/knTLocQ6gT1BUwX1N/KXHavJf6TpRcF3ok3w3tjB6eIZObDldX+/4dF6zfDVrsJctKnu+FnIVxSVNA7UMLbSkJmVcC+LeI4NVh6ZE4fTjBOBNY9w/VatHgTrqbjjL5DIxzkn/iG+R6tefHlJAwvfOXYR5ZGlAs2u4SfP/PnjzVGxG+xaLlKHn7DpA6XufEsew==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a27695-3298-4e95-3014-08df038c8654
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2026 16:10:19.3498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1eYP69qUY0+rR1F3LfCRqCHriSZWGdbjAH1B1xbWdmJSzkOlnI/xT2hE1LWVx3WpPMYH2yFMVWpmG6q96eeR2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9778
X-OriginatorOrg: intel.com

Hi Ilpo.

Thanks for reviewing.

> > +/* Machine check bank scope types */
> > +enum bff_type {
> > +   BFF_NONE =3D 0,
> > +   BFF_BANK_DCU,
> > +   BFF_BANK_DTLB,
> > +   BFF_BANK_MLC,
> > +   BFF_BANK_CCF,
> > +   BFF_BANK_HSF,
> > +   BFF_BANK_IOCACHE,
> > +};

Trailing comma here because this enum will expand when additional CPUs are =
supported that
have different types of banks that support the bitfix filter.

> > +
> > +static const enum bff_type dmr_mcbanks[MAX_NR_BANKS] =3D {
> > +   [1]     =3D BFF_BANK_DCU,
> > +   [2]     =3D BFF_BANK_DTLB,
> > +   [3]     =3D BFF_BANK_MLC,
> > +   [6]     =3D BFF_BANK_CCF,
> > +   [13]    =3D BFF_BANK_HSF,
> > +   [17]    =3D BFF_BANK_IOCACHE
>
> Please add trailing comma.

No trailing comma here because this list is complete. Diamond rapids will n=
ot suddenly add a new bitfix filter attached to a bank numbered > 17.

-Tony
