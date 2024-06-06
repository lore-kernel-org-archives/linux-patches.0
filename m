Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE5C13C
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717700562; cv=fail; b=KXGzFyLiXmmtMATUOQstN1KjeWEFvtwmZaOGzgeqvvRpUOaDy+shdJTXUqlMO5t2a3E4CyNuMrsxcBDBToH1zctd+UU1akpuz+xiDmbU6tqj2O4NvXfONfuN5b9wwgkYJEKAceNEVJjCZPUXrdNWnza08oHE3+sT9h5O6t2+E+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717700562; c=relaxed/simple;
	bh=YeBFHL1eL/GJhpNv7d9as9cHSCkJaUD1YHnJt8i49/8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rhWsVAKRoNjubrXdVV4boRMcrCeOQimDxW9AZ09CpJ78ubdD54QFyW809cyr/ewvfceoKD/ste9dtCu5nzIJxbSP+ZwEToKEtZVpHi6nLY0NW4H12A8Lx3fRIBhP3b/HiD3EtqgVFP/2cR4B7Gnmimwwm5c8XlHcmtuSjRjsk8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fBfbmBsE; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fBfbmBsE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717700561; x=1749236561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YeBFHL1eL/GJhpNv7d9as9cHSCkJaUD1YHnJt8i49/8=;
  b=fBfbmBsE1Dgu39fxoe1HDgo8y+FQu0ANookiDSKzelomFnkaJ/5EeuFc
   r3mNt9wPWTx+ANWeo+NFZ6pAq5IfIgzlMvkplhkFy47FTnQVERa/fj5KW
   PnQupOgCyzUtvO8sWI7tpbB2iQ3EGkn97buyTQDV2E6XLVZVYk3F2xSVU
   6CEnkUlcrNYLsYbGDg2cinVtLpWmEYZnejojNXv82GD/Z6WWu+iSPAinL
   lGFd1FSV70G29uRhWn8B+hXfy2/f+pgmbUMzWTHmqptcZdVw1OEt+VDF2
   RFE2EeztcqfOBaF04e6jUuMAfSkSnzhOuD1MU7zdpH9e6BPfU8LdfA7nj
   A==;
X-CSE-ConnectionGUID: H12ZcRshQFSpVSzSij1AlA==
X-CSE-MsgGUID: 88hVRbP7QKiUbEW14kK/UQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="11948579"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="11948579"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 12:02:40 -0700
X-CSE-ConnectionGUID: FddT5jk0QwmedvLUHQa2ZA==
X-CSE-MsgGUID: Wc9Aktw3QDu5GQluToRYAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="43001291"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 12:02:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 12:02:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 12:02:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 12:02:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 12:02:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPdF3efekVf1thQx0ssmRoE6Grj26K2bTN/L5knEiIBYt3JC16SRq98DLkkIDIwtu68Q65ULvN/fuEpoMRlMrgiR48s5fAemQ3y3MU/tzNb3lVht8Ug2UiiBsEL/fNqDIKQks69Cu4pf8y3KKoIw9rt1NPZauCpLBdAMgqrQKyJEk1dDTGMF7st8W8wfM3ML73ttSogh189Ttjkotpm9kvRvg9QSrrDeLNZFTBPd81hiYSoxoa1ujCZHMzhUQoFEKudU1FIB9L2hl4XBHZGgTv3vxnzKjVj03f5E0sB4rofD6YwHQci6zBEnVZW1nRAMAyBu825zTzGzTVt90X+qVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozVwylsjcy/aqG2e/gjkEwXEcs16//qz62yqLKRFFzg=;
 b=IHicwk4rnjKpoRxnZPnohlX/PtjXUlNZQlZcupdZ9lJHqfGmrMdq1SYVq25wdIQFtyKnbu3HZBgonURn7h0OwmUh/7CXmBSiE9W0MylPE27/IySyoHGxf/mAtUERHbHVXn2qtB9GoW2ngQ2Zy/uiXyIWQ5gMu1gHj+xGQZ8LmbjcyGbmCMhW3rizx1TvjnPkFG4/dfWH6BQWO2NrT0LtQ6CF9/Gh9UG9YJVlMKowh3dWXwSnriymLUb+YXOEss27iO0GBMhNMGd6MBbRFj9E/zocpA39ny+rz+AvO41fWhHVvAnvX58E6vJebUzI1LW2jS8Z6fe6tY/eoM1nRfNF2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 19:02:36 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7633.018; Thu, 6 Jun 2024
 19:02:36 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Thread-Topic: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Thread-Index: AQHauDBdYeGsvVFf40e5nFEfBMSU4rG7FovA
Date: Thu, 6 Jun 2024 19:02:36 +0000
Message-ID: <SJ1PR11MB60830475F52F359E116B2274FCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240606164047.318378-1-tony.luck@intel.com>
 <20240606164047.318378-2-tony.luck@intel.com>
In-Reply-To: <20240606164047.318378-2-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|BL3PR11MB6505:EE_
x-ms-office365-filtering-correlation-id: 090aa8ae-867c-4555-e298-08dc865b3a75
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?bU0SwToYUd+JQ+b+KMsgXQerRsPEdeTLDU7frZQmStQcx5hloCLmnGE7BXG2?=
 =?us-ascii?Q?MScujO8k+GDfWQn203QiCagxABqJtKMA2iMWsGpVdYHWUfDIgyoCS7MiLbcg?=
 =?us-ascii?Q?w5VQpRj6f+D3qfPnDPw1MKXzuKglPfOiS72O1h62hrUR1BYtbHwxn9Uy/wKh?=
 =?us-ascii?Q?OlqNCBfAkpqcaM+W2e+JSXKJ/qizJTQOOJ8sIHIJ4t25qK71xKRJFn4DOvwd?=
 =?us-ascii?Q?InSu8vW1TQTmU96kFPC4GtTfdQ1UEFUlLuGFmVv9uNmRG6MBkzql+Zc+ezbF?=
 =?us-ascii?Q?lRYqHBREJDHq6TpG41H/CE/6EEjNpLlOe5p7o2QC3TD3405cPLrWeZVPmtw7?=
 =?us-ascii?Q?i15NQa9Dp0UEM9yfyTG6FMh3xyrC5uquy3BFUA/Th1eIb5rQRixEK38Zhu4f?=
 =?us-ascii?Q?moTW8fgTJB7RSB3eRhSdd9YMxq6OKPG8BXAiJvWvrtQvo6YSyvDCDYhc4d9a?=
 =?us-ascii?Q?+lEAiSngFSYfdRgSHgCTK05KdLIasbxDjhYLcFeNnICjFb1eMuMKRpZKUF+d?=
 =?us-ascii?Q?c2e8HGNWOaumZKG1Np2svvCJOv8zFWgQ4/H+vxMSGOFBogXLeDO+zzcObnP3?=
 =?us-ascii?Q?DdRT6PPd4OQ5pvNZCzzFaFZKuB9c8A6KZ3Wf1RnVPKz/Sui6V9Ub271XupIn?=
 =?us-ascii?Q?i0NK9HgXmaBYDslIB/ZepexPTnZ4ltq93xd92qXogGfvh2YOoHJaELY9oqRW?=
 =?us-ascii?Q?ngep/cYX6wlj+aRC1dXp8vcfQhoWwDFrsptlDSDQ+RoGB8aecT29sd/Lh/2k?=
 =?us-ascii?Q?elpFI3WiCInU+cxMBtBbV9yANoD+sDf2mdCZeyRIjyCChAYbSM/ubU3d6VVR?=
 =?us-ascii?Q?jxvADNDUioSRBW1O8nEDwpUr7jKJoifxueXq4R6aF6XzjRhe3PEq3w+xVqo9?=
 =?us-ascii?Q?m168Ihn50V2MlUJjt/2VEQE44D1OWFvWIVtwN8rhC9yy3YxxNxkvEdlRqcte?=
 =?us-ascii?Q?zhuTkOH6oo7OM3DWOJakZGoOLyeP7IN1QLkcyaFBss5EUn+l/ahWOl4p9H1W?=
 =?us-ascii?Q?wDXeuGvndEbgOFrGokzGR8q0LHpmpZxqY/yuLxMklyhh9N0PDPBuQFrzcdcr?=
 =?us-ascii?Q?A9S/BzwhYQL1axdHftC3Y7+UNb6SxAVDNwCy9FBZEVAf1caVGXhNf3F0uFrS?=
 =?us-ascii?Q?LDxHbA7pNiCE7+PHKOklQ1n9y4JnEOCHMdAi0ItHDAjw80HaumOCSeoeco6d?=
 =?us-ascii?Q?qMyluSGcXaZZXIB9ndUaJZ6okw48frEQbpsdGVsffmlBXt5hoZ/VQmB7vj21?=
 =?us-ascii?Q?+3lXIvCfe0O/Jb8cWnAguncAfFJ/dyaN8vdbLxsVZOII9b9nKSom+8FsQwk5?=
 =?us-ascii?Q?pyysL73iEncS1BbqMdhOa/+ZP70sv1bUDou98lQarR+uFOkXC5nfxLbt81QM?=
 =?us-ascii?Q?kO//wlI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yqS3RonNn2ZHqyqa6GsyCozCxvnHPenYQJXLHMuPSnde1OBsbKba4KPvO9OG?=
 =?us-ascii?Q?FgLMzy0/U0b0+zsq9Uc5M6rLIN60/FimHdl3dWGyu3RzIsrLvD0KO22KbKmO?=
 =?us-ascii?Q?KaXKrYHVX613dZVJAbPttcMzICBxpEKGsxIPotMxatPh6/owYkbihWzM1mU1?=
 =?us-ascii?Q?dENDCAEkMEx4v6eL7ZgXWP+lJJJpZBBqknWPfAgdzQODf7eJIfFEiUuILzgK?=
 =?us-ascii?Q?DRaykBBby5Z0bqwFpR2jc5j6/vs4SiXVwNcNS9za6xfTQgsKltl5E5aFDvsZ?=
 =?us-ascii?Q?qDazzxDIhzavkeu8/TyvHb7IWGTtNmYW00Opv1aT6AWcqpr/VE50RoroAjP5?=
 =?us-ascii?Q?7D9nPbo195BmDis+1naCzaInz+MJ3AWkIDiW1HUvms5WL3RXHtcSKVa8yzYB?=
 =?us-ascii?Q?dLRAxhbWft9UMszh2NceCopNkakE986j8hsS2QCXg3swer6Nx5yBYzIj5fBn?=
 =?us-ascii?Q?QYOpcvZg9xC7p21i2s3xtKd5sqcYHSPfZu2LNHfLWjP/pvo6PRyBJZdWZYKE?=
 =?us-ascii?Q?9TZ1abUN7RioK+f3ktG9wKkhcUdFNrcso6U1dWkyc1OTB63GASatlAFokbRR?=
 =?us-ascii?Q?bY5MCWJNwrJJ4D929Msim6x6orDzy8GgkZmZ3sNYJ8f3Ir7YiN6qYPZLzQ+F?=
 =?us-ascii?Q?A0+tGdhcTuu2Fw3MEgxzXTxONreOGZgMVXohDH3UlGQnfzIVKC++Tgo+Gcuy?=
 =?us-ascii?Q?m6dRngOI1CcnHki503Ye+ek9Ll4u9u1+OK4vXaYlGQV4e1Qmr1KeS3IIJIx6?=
 =?us-ascii?Q?G9FnRvQqgIVQMYEZxFTRPz0wbvqN0Zca1t2YzEIqU/z6MmLycjg9afbksu85?=
 =?us-ascii?Q?pNNXbtjl/h9+4OGhqYpfaWbdsS0fH5tvOWxfkGhk/aGJ2s/S2X3mdA66tPWM?=
 =?us-ascii?Q?U0/OP223AVbnImOaKpVDghePlryZArucmtoVX+7Vtt5+C8mxo6DLR0JoCP+n?=
 =?us-ascii?Q?nJ31vjc67y4OvCzPcKI54pXWt6PAITZo84BsGMpCFAhZ92ksKtGLAYbzlZ+3?=
 =?us-ascii?Q?SFoUuVydR9ztyyv6S2lCfPSWRIMzK4xDzzY5luJbMan3BJcw/TK5s9l2mYOb?=
 =?us-ascii?Q?EcojWjXIr84sjEUllJSMFXJgHTFPULzPS2afQusiZAtT+vTIeSL5rTp0PQVC?=
 =?us-ascii?Q?dbQEoIavA1cszFsgs88XBOMX9yQI+IzcSgM+u+d3KDkO+8nVdYTI4XVngmWx?=
 =?us-ascii?Q?RlgEy4y7irD+G9CDGGNC3hwNbqi3geflDHz0J81pGm2ffNfnGqg0U63xllgJ?=
 =?us-ascii?Q?s0jkWlBGnJ/4ng0lRWQpZV1jPHqweaAD8emMeZKrkrR7AKB40zGIjYQ3uwUh?=
 =?us-ascii?Q?eRZLIXYrxn2FMU8T2oOMYwqEiBeBjFy4iX9A9L5g5OjtjBg3CgVU9iCQjeJM?=
 =?us-ascii?Q?JjRb4wqrYfFHK2d7gF5PUj3o2Et3rcJjODaQ60Xi3JMzE7Zc1yibyQ7ou60P?=
 =?us-ascii?Q?HVbhpV1ua9LUktLiecRoKHs1E12NRmbxWHJbuAO711CQG5F7CEibEpWAXV95?=
 =?us-ascii?Q?z3MUBnEFPJMmc2Hww8sUeQcDWzhxXrLoJDKSQ+CeE8hzfu9oYkxR5oRGJnrr?=
 =?us-ascii?Q?exs8WNrHa3q8b5977qQgnKVo9yPXBbBf//xYKw8x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090aa8ae-867c-4555-e298-08dc865b3a75
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 19:02:36.0597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3lAzMM1n3ETOJRTrjd7Yg5V2qvX4zQsSPVF2IEeLUyqxYzQPkssXdDI/ohNd25ditxGowoTidLvKgp3sT9pnnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com

+	lockdep_assert_cpus_held();
+

lkp says this breaks riscv-allnoconfig and riscv-defconfig

   In file included from arch/riscv/include/asm/cacheinfo.h:9:
>> include/linux/cacheinfo.h:126:2: error: call to undeclared function 'loc=
kdep_assert_cpus_held'; ISO C99 and later do not support implicit function =
declarations [-Wimplicit-function-declaration]
     126 |         lockdep_assert_cpus_held();

but I'm not really sure why. I added "#include <linux/cpu.h>" to <linux/cpu=
info,h> to deal with similar warning when building for x86.

-Tony
