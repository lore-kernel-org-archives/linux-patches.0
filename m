Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956AF3C13E5
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787159571; cv=fail; b=lhq4hfTnaqYq9N00peC0WPUPeXWLZE+4HiQXWOlVLbV80EP3wllXq83Ks6Ok1Cb73Szl7WO3nbEgI7jIIDegnzfiHcUxsjZF2SaiXHpFKugP7Qey+9gxeiZZVkQVscv6PFwBGywa8eGo/DWKw2ikijjb6oVUGD1vOMA4rCREL9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787159571; c=relaxed/simple;
	bh=6YgvTnnDjJkNFYvcPFRgeSVgHA7hHTSKAxIo/brud7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H9cPqlnoDhXpLBHit0yNXOOGF3iU1wOgMAUC1TkDVklDTiOVv7MKzsaRBk66DsbNNpz7gdJUT7OJwqEjQHGh55yCnjQlJl+7nEqTZnOK/IFSmJNwlpLV9qnfk/5aoi1hs4aTtGwoH4k3rOYIYQudRoJmyB3oicBG/hKPQ9O2Ed8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B2JEE/a4; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B2JEE/a4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787159569; x=1818695569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6YgvTnnDjJkNFYvcPFRgeSVgHA7hHTSKAxIo/brud7U=;
  b=B2JEE/a4W8nycxa6M6DpIWl019atWn7sMCY8wFX9f1mSrpVnpfC/8OTs
   FBrukJamuz3VP3+TluJmfQrXsJWAb8JvxQbQJAZpnElnGT2EJguZ4jOf/
   sSekbriCGrQHeLm5KkAnpdqwvm2WvUlfEMg3a091Tj+x1jVNFAbS/25CX
   ZnWEck/9Ka8vSiDjUJTQT6btfAzHZXE0SAu/tGrn4Fcc56RmgkaHnhy6q
   Pfk1MR49hfK4eKSqDkwi+MIzqFxVsD1z67vBLSf6ih01Yv/8PN9HHnEeW
   PdwhC0OBZnriWp/vUEAGDWBTp8qqQ0pmyr3NJhPpFuJYwv3KcPukTOJNM
   Q==;
X-CSE-ConnectionGUID: txh9yS52QGeKfsF9rDYygw==
X-CSE-MsgGUID: WNqdt/7BTmu9H7EalLt+rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="105068502"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="105068502"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 10:12:48 -0700
X-CSE-ConnectionGUID: XjistTkwQGakGbBQPKrZhA==
X-CSE-MsgGUID: b0FR4FgtRAK23mNBlF39xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="267563150"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 10:12:48 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 10:12:48 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 19 Aug 2026 10:12:48 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.7) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 10:12:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQq+yLnI3rjJu/SqAM9d7pRt+zhJH9agje9R36cs/SxdTGQamBgLGnDgBbTDG1cjcq1Li3kpBVMblaaMvhNiMA8Tq2v6nCDFgjluR9vFusbqm2PZfGZ1raQHFK5bIA3+PWBNc+hoInWYHTNVXtfAz91mifikX3L2xET6Mzg7Xp7djIOWlTBDji0Ilp+1DPQ/N9blTBeW9KNZDjqbainrvaZPw7WD2i0G3PvXVh/v91UsKjqoeWmpH2L/YGtePzQJ9MgeZYGSmDzQc/7d5odE8KyLKBorHH7mIXvfcMKPEVqsCY2UIAAxlR0u9ye+2Ijuu4wk3Sp44doPw6KQayxj/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YgvTnnDjJkNFYvcPFRgeSVgHA7hHTSKAxIo/brud7U=;
 b=C/wRMd8z5pkeL4GaxXg+DcUpk+/+uWBwmYcqrV4wMpB+0mNroeTHjgjKOm8zkR3uQJYGZM6IvA/kElQ6oglvjV0Op/zurl8/g6jQIWjj1qFhDEFo9ymd1XArskMDgARwfGRM/m0efUhnI9VyucQ8AepKTJsiZFgQP24fx3e7zNmMBD5cAqVG/fgW8ETz4IyD6PI75lor1h56b6+SauMApNMcwDedgmqZHI5IrwgFhqkbVYybpwu/F5S3PjPY2SgpJCM1dNbfDdq8o208uVyAywKq4HMWUrECIokouxyWKJQl8Hb/nqf6tBNa3idkdfIxMI7rkidc6dTKFZaKbAh1EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6141.namprd11.prod.outlook.com (2603:10b6:8:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 17:12:37 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 17:12:37 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH 0/4] x86/resctrl: Refactor resctrl enumeration
Thread-Topic: [RFC PATCH 0/4] x86/resctrl: Refactor resctrl enumeration
Thread-Index: AQHdL/W5Z0eH4qHkGUmYgj4O/9uZ37alml2A
Date: Wed, 19 Aug 2026 17:12:36 +0000
Message-ID: <SJ1PR11MB60831E7998B29B3BF98B6E0BFCA52@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260819161323.11587-1-tony.luck@intel.com>
In-Reply-To: <20260819161323.11587-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6141:EE_
x-ms-office365-filtering-correlation-id: 1712a7b6-4f00-4002-5d20-08defe15113d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|921020|11063799006|10067099003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info: k4q/OuITh0V6jys05AsK5XGdu5W1tdipsFi+v8WjPg2jgicbLDoH1rKT31W8EFoMhbVcHAk1TGirSLA3pLuTbxOhEtPwtiJacGmDxLt9V6A3VHEvFc3kHnlckAXJ5Qs5xExXbWOtJm38XUrbSghh/9Oiv5q5c6zejBEQYGve5FvsG00n2ZpkIgtq+1n7qQmpyJjpavQaz4BKzdBDYZOJOmXRlhXaiFcc6vP3+hWyCSKJM9THg1GAqkUm87FcnDZmhzkmHlpCsOPloBbVh1yam2l/GDn15Dh/ykXdRqtAKkE9oy0DqzHfzkGrpxizKspBBM1sRFRFd8a8fYlemcLQ+VB7EbTMSbWUhXj28qCLeU4BRwPl3Mu2R62mkhnAevUqO1YQSPZ/uZQTFdlPMw61UdjOHgrjeoY/3ixirtm2cWCt3aHb8ZJjzNvBH6ILqD717rbxvvlW/sY+sfORtb1ZzHIHcbjAoUw7ElDtRjplW3VXh8DnI5DEr483fAmoMyz5AvBACt/q6AfrdKYKZ372vaXr7+LyQNutsLVUMDfCrci+3ILA+/CT3lguxGJfXx4CROOVsAVDy9yZm4ewOnfUPBq0SHnbiHjERZfI6Tr0qS79fWhqk4CC4k6ao+si3/uokysMPtZm59G9p5KG1VM7dOszYirih7+d8C9GPVcVyfcVlnCmjhROY6GrDzSmQQyj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(921020)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+pUomFkOEvr9t84xfHXk/XB6sWQAwLJ3K1J/YUDJQFgHfC7UJ3fJlPXq7r5d?=
 =?us-ascii?Q?W/HbKwj4wbsDLlvvE2qTcXJ/QbATHwkKkXf+P/xFWInOtZim5ItC/SF8q3MO?=
 =?us-ascii?Q?QAF4pWAQkQHuTYNh4igGpggaTr9CxpJJTUqaGLhbm4/CwXTdk95gxIs/ZqnF?=
 =?us-ascii?Q?hs4uOxKbYhOmwuRAv7PGAGlAqEGEYUPBVtOfTgj92Kst3f+NEDmKS7bSlHVV?=
 =?us-ascii?Q?nQTvjg++ncNbCNlRq0tg7g9D+aOkJNXLI+ztCIE4pV1UEy6O/Q7t8JdmWJhy?=
 =?us-ascii?Q?2nkeQbMKe9nDbK0P/nYLE43ov+KR5XBQu9cjA7oGxaH0Z6W0JxOpB+d5Idc2?=
 =?us-ascii?Q?mCPPp748cm/AoVwr8obIhP7jaYivV48AYTXxMuB7HXArZDlu1kS8n2BS6kYS?=
 =?us-ascii?Q?xYnQM+ohcO9zY84OPHyOWUo20aZIjMDopVf909UJ0fdyy7G7E0r6q7lz+jaZ?=
 =?us-ascii?Q?8nH3I2YFI28YGmB5coig0zIs0IJm0mJoaI4FYJYvpOFNotRtBF2OmeWM3Sku?=
 =?us-ascii?Q?T1y4ExACS8XOxsWZFHh0CRqXIg0aJaZiGY2kM9HQjQQlFxcywyl3uvjYLMYp?=
 =?us-ascii?Q?TwMyAdxYskH/0uSzGlj7gbcgoew3Gz0NHHPpXZ8zBqqJwNUIQ5jb5sxHc7xs?=
 =?us-ascii?Q?4jpSCd9Y3ItRUlvhSJf4BjkHbWyecyViAfpN2OBB/9iZfR4u4lQNl6A/m/+a?=
 =?us-ascii?Q?HNejN/muVrgpuhV77kZZy8zSdfcUcCyCcYWDKuX+ZQvF/I7r2bcjMz267BWj?=
 =?us-ascii?Q?19S8ZHyGWBHqvczy+qD+yiOSfaJh4fKheXDLaA1MXv9E7D4SliJOwFvKjtw5?=
 =?us-ascii?Q?T24NQr3GGljTChgP+MvDHQHIcP6x6k/oaIBY3Hxyji0WGN6jlMlpnW9x3ptd?=
 =?us-ascii?Q?GIyf7fCEiiDX2mZgLdZNU6H7q6lFDknD7uCcBc4oFvBo3g7uJL139yKDlJIG?=
 =?us-ascii?Q?K4fandvjvw7U/aGDCMqxIf0JdRU0IT6x7GsTe+IG+xJuQQIovm24vf61wc9/?=
 =?us-ascii?Q?X2xejKW7fc/TwxTg8PDTIcWLrMARX9/gNgakhVtNAOrlyoonlxJrwgu26E2n?=
 =?us-ascii?Q?nXgxHDmMjSouIBe8U8sQFSN+civP5x1zJGFzGXBm8Nm1MTUActpfbnzg2rdn?=
 =?us-ascii?Q?5gu4KQ9ljRw2KutTbThfScLiPpbOEwjplXCtClzSKvHuIUNYZoQknH5JSWCU?=
 =?us-ascii?Q?8EHTeP33OtbYHuP1IGjXSxj6nCH3p6ekYkPD03JT7k9ELs+gQeBmc2NpAebn?=
 =?us-ascii?Q?zbjlk4SwoahLFtYQVCsZUsaXWwyU4Riyr88UmNC61T3uM5EllsO8hGvR3mJE?=
 =?us-ascii?Q?GzUCO6gc1Pg6ZrCL2oJb0IkNn1QtHiawQAJT5DAx1BlDNHZbGsTQr1L+meQQ?=
 =?us-ascii?Q?rqPaGQIS8RhKKDTwHJCbfpIu126wft6Poa7lzz/ra7g+Cv/X/zYddFDp1KY9?=
 =?us-ascii?Q?FnACnB3MKhZ/DUT/ZskNlsPb3qsgL1wl206qSoa6JuyRCpMVV3ORFYkMiV4q?=
 =?us-ascii?Q?3OkBkN9pZs8p5h3ZVQd3EH+i/0BWVDePY+U3ZjKPvQRGTF73aBGfpIQZ/Ypc?=
 =?us-ascii?Q?fxkDRuX+w4D+lAFo7JhopbC9yJ7HGx+QfGKei04urBDWjmptV6eKH1ZKkrV1?=
 =?us-ascii?Q?OZ8Mu5fcW1/ZGPvcIMW0ULJiliudfNIb3hIUS/PdXYKcV30e+3KZX1Aru107?=
 =?us-ascii?Q?InJ+PM9fW+sJBoiSTYGnWDcUBhUpyPHTl5gPxSqvSYCDQdxA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: L9jfJC11GWWdpyhAGVvQvHNBB7s+e/pZNCM1XpKWKrx9m/S7AZ8USyNZBKCOlDKfyVIf6TfG/Uy5a3XzvJSvQmyWjjbts0108Yu/jwhkfvlbHgZLMyyoDTFKOn0pibJpXqpg/SyxFxTon3hi2hwZ+C7lCytwZl4be6rCtURWAQyTjd0IKo13JcowezNAURe2PN/3QHTt3+etKshLKfrliddQ4YlocJrG/70bb7awc7C5f8i7ISGpxzO82cIGU5M/cR22xNrGVu5bbIs2rnTxDfL/lT7ookkjkEdxTYIMEF+y8lvAIxmuuYgjP5EmvGjlF9JOMngYliP5lbW0sK9j+Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1712a7b6-4f00-4002-5d20-08defe15113d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2026 17:12:36.9776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YS0qxdMYL/C3zcwyohh6dGzKE/lpbwym7tVJx0z3v8pyM+aOGDjeZoE887PBtPFTnnFspTsGnayj/0WI0FKjBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6141
X-OriginatorOrg: intel.com

> This series is posted as RFC to get some feedback before I incorporate
> it into the next version of my patches to fix Kconfig issues. It was
> prompted by Reinette's comment:

Sashiko review is done[1]. The only complaint is that I didn't address the =
pre-existing
issue that a malicious/broken hypervisor might provide invalid return value=
s from
some CPUID invocations which could lead to divide-by-zero faults.

I don't intend to address this. Virtualization of RDT would require a great=
 deal more
support from the hypervisor that just getting this CPUID enumeration right.

-Tony

[1] https://sashiko.dev/#/patchset/20260819161323.11587-1-tony.luck%40intel=
.com
