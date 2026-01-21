Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AA541C2FD;
	Wed, 21 Jan 2026 06:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977654; cv=fail; b=FvagLAf09hZdKbirLdPP73Ynwmi69aFLj46GxSA6yQTXmDIk82RMZCup7zsukgTYYZ+8V18hTa7IAON4lVhioqLYPRu71rMg4Hif9Q8Bs6QVYxMtTnyXm5vJhnzlauKSeHJXiba8wjfD/uy5SlRXdcbWPB5+T7eVrKbypGv1x/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977654; c=relaxed/simple;
	bh=N71dj5mc19wxboOn5CGSoOIERMgSbMY0Hx95xZHmOYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LhHuh4hVl+pfsL3M9oPrMuf8oLicsoTmtuRl+im14yNo/WxvxvaUxZlWTzdyK/38T8Z3TCHr+70NBsSEIZMtp+8f6QWbLWkZsk4vCRmAuvxIv91aBSGLybHZYgDe091lm4WTMuXPODVUkLioL+T3bPTlN4E3iJUgzWNjYHkkulA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFTV5zZ7; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFTV5zZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768977652; x=1800513652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N71dj5mc19wxboOn5CGSoOIERMgSbMY0Hx95xZHmOYc=;
  b=VFTV5zZ7GlFM1sKPFThGG9byJpSOQE9wpbB3t6XBPFh63SaDeklEEFbO
   GK5mJ6LJ/vtMv6AmDGMZn545OWbmDkTRUoP6QPI1MM5iyEOTFaFuluWAB
   uO9ZLpteYj9FCHVD3nNcmvOeNnHyLCD0uPEnDNFCCA3YDnODm4Qp2Ib4G
   y4CHll03Zmo1CZhXa+3ZK81YEiqkPlNR2WsYBKhJbmlBsRG9SRCwrBomK
   niRR6dr++0/bEFUGZkFkr1XK0lEje5KRYp93s57U6gLUyxIhddh/cDGbx
   fo67+zzhYIlZW0aU1zFppx/d3e6Xuz419Wr0kcgUTbko3OA6puwuZgJQ+
   w==;
X-CSE-ConnectionGUID: KbM3DWLdSB2LIo7Kj5dvuQ==
X-CSE-MsgGUID: 0Tp3XV4WQXuH/s0YBkLQtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="73827653"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="73827653"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 22:40:52 -0800
X-CSE-ConnectionGUID: B/iGIXXcTRKaGVlAAYJ8HA==
X-CSE-MsgGUID: WFdPzWuqSUWlw7JiXJasSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="237024618"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 22:40:51 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 22:40:50 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 22:40:50 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.45) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 22:40:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvJ8tV8sM5t5L4l2OCxTjWeF3g0I5TPOS0ap+KHQr8SMR2M8BKUpPw00VZGuNmgkFRjN4neBOlPtxfAYqRGqeOzKEyJTmU8wFv+TACe7KcLKgfYltLrAj73dEwPHB7TBBOedYcuX0NcChN8RlGq6rLm0BD62nVCk67zBJ4pRH5bwO2gHPkZ4mbpVikVcTV0YfhPFB/FTC7XDlI8PWzlkhDr2waWlHqOJB61S0J9ih5Myj0SmeTJB+J5HbZT47GmWl1cYgdwBdEMx/ULPEUAYpyAPGfYWdMSD9p2JXkMOdIvXCYoGgOqQ6eWUIAAtlLqlLgzeulRdTSF5tBqPWxsStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N71dj5mc19wxboOn5CGSoOIERMgSbMY0Hx95xZHmOYc=;
 b=W+UydpLjX/0S1ubNPk7xThjsLF1ISfJLCVQkEI2mDhcbaUu9Ra33KG41YZ+s+/FARFmyGeqEbtmGpgSZbXLbUt45sLp5SKviamsfdLp7k6WX/+XojDhcZXxVSb94ZRHTqKkMHqZAN3fkzOQ9tt3jsbYmTuIrO5iZu79trXoFmRIHnHk65/6DzTTlMrk5l1DX6uPG13Ulon6YdkWBnR5T5SRkGjW8N5z2arSTDN1n/9ivD5SVFusExiifBR0xwlvCvL59ZXQs6NircsTkwssgMigXK5LR4wE7uiRLZNHPWsIAO/azvGbzwcgR6NwnVK5GUd0Z8xXTPGtFPFUM0SJMZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by PH7PR11MB8058.namprd11.prod.outlook.com (2603:10b6:510:24d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 06:40:47 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::780e:4379:6988:f48b]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::780e:4379:6988:f48b%6]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 06:40:47 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Samiullah Khawaja
	<skhawaja@google.com>
Subject: RE: [PATCH v2 2/2] iommupt: Avoid rewalking during map
Thread-Topic: [PATCH v2 2/2] iommupt: Avoid rewalking during map
Thread-Index: AQHciaGeL7dLZMNUCkuLtUHtmMpkaLVcLmWQ
Date: Wed, 21 Jan 2026 06:40:47 +0000
Message-ID: <BL1PR11MB5271E72D596081799BC88FF58C96A@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
 <2-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <2-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|PH7PR11MB8058:EE_
x-ms-office365-filtering-correlation-id: ad0087bc-5faa-44d4-b8fb-08de58b802ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?CRLhcmwsCClR3G0GCnFKkLctAwFEUnldwKf2rlHEuLUQwhIips16PSUnPPZh?=
 =?us-ascii?Q?E8BeSCsS5MTu7beNMKs4PpS+p7rEoLKO2ZwcYJmyzGjy2HCJM1ZVkCSOUsn0?=
 =?us-ascii?Q?jQdy3d0oJXmf9Zzm6QRgSClSlTxTQKTplTai9lGZCpr1G2tfInCz/O5pBI/x?=
 =?us-ascii?Q?4JTYNwvCEkJKkw8/sU1GzY/a7WCD9VU8DDR8JXFiLte6ssKOw87X1nY91+My?=
 =?us-ascii?Q?SHFOE3s0DeyoUdw7y+iALTuwbF6KIbFF0ijKV+99Wc7VJKEa0RdxImjyourL?=
 =?us-ascii?Q?+i50NF7aw9ZK5VeLKIY4SI/sCatnzppW/3qGBS8Vm8sR0bjhCYsbzYAY8rP3?=
 =?us-ascii?Q?GbRbmIBZnDIH7z+YPdb5re2OA0j46j5ADha6FiKGdV85OIhzP5fncEz9Su2M?=
 =?us-ascii?Q?8ZcAmZo10cbq0vGcU7eyBZcTTu7FcuA8SOtg0IXe0lp3zlF+TrO5d9XukDsa?=
 =?us-ascii?Q?b1zhLSyOzojBpyuIa2ZQAJ18ObjW9GO9y5l0P1Y6WN5KXFse7wLgeG+y8Mj6?=
 =?us-ascii?Q?tZvUjCP6+8ZwOCWM6orCxTotBtm2HgQDZsgxlfAMpMe+1DzhrRksh79q8/dT?=
 =?us-ascii?Q?Ayfgw/XswsQytY+HfXjsv5zlLEb21YLxgnekkMl4gbgHjPI87YBSGrOVn9n4?=
 =?us-ascii?Q?m74302bqUYXsoCOoiX6iW5qq7CER047wj9qkbwxbNdciB83JlOqgooFhHQUo?=
 =?us-ascii?Q?AsrGwmK3IYn74dCVPcuao3fns3EtKsdfAeCAxQvGCXh26mnvETp5mai0Cx1G?=
 =?us-ascii?Q?aJUZ+Y3s19j+hvnmHk4D/Ioqq5t3eemYk/Y+lha8UTcuDEZYcc8vHP2Ao6Cj?=
 =?us-ascii?Q?ebbIGmbivrMbGZVYqLEAgLLO50DV8roFMmgI4snHgw5mIB14Bep5gIpxzL2p?=
 =?us-ascii?Q?Lh4X2qVGaVMdH8ho1uALpJDFEASoqFoOgSvR7bdAYjEl5fxW5isr2XZwCiCJ?=
 =?us-ascii?Q?A0T4cqCKOfzECoARFlcZAiRzkl1eH++ifjt0Lxt9gpEI/3UbfY5JK0wiROrf?=
 =?us-ascii?Q?GOIQPsLj5SiP/6gNn1T8AwrlM6XaBzYlkmULX55wus8af25snn7/39Bi8eGE?=
 =?us-ascii?Q?3o+0XDRZz+rGHmTs0TySsrP6L5F3frg6587y4D8m6H34/wjA4q0vzX9M27WJ?=
 =?us-ascii?Q?IBIJweCBrd9GFtnsdiQMOg0nQUFuCs9bSEAM/nv4qMIUjrBkjFPh4ueks5sW?=
 =?us-ascii?Q?bcAehQuv19ZKNgmTJk3rDFJNH2noMM5t/Tq3gUAREl2lQu3JIxOhmgiBbGg+?=
 =?us-ascii?Q?wtsPAhIkjsujCsK40HaC9TI0Z1RvOdsyuU0lV2pNmZi595YW4ugNVS1LHlF5?=
 =?us-ascii?Q?O98zE9cAIc1xzomhG1DdqeOkTuZodmf/VFDdCw6fvpXMJXhlVDDorcHDBpCb?=
 =?us-ascii?Q?GSCxe03VAdTXJdhzmIEFsSInfmpHIjsOAxy7iAYR/nLipv0qjQH54hSdKKwY?=
 =?us-ascii?Q?bj+cw+XvPBDL7I6niRH6GWIzyrKMBR84kdQGiWRIq18MHFLLZetdUCf33tP3?=
 =?us-ascii?Q?7wVC2wgwhmbrviB9QsElYsO9YlOJdNWOoBPsQOx9jcLfdO4/ScCV2tr+q7K/?=
 =?us-ascii?Q?/LVri7vxo6uujYc5mGQpe/rHjE+ZT5D/0uUsbZhTf8xyOUuwyCLh7yXsz5gi?=
 =?us-ascii?Q?TOSOW071/6T4x80usCSocq8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CTo4x3DcEq1KXHGuHL71wL5wkZ+hHelKiMXWsMB0+FCHTCAWQ+oN2VQzO3bo?=
 =?us-ascii?Q?nhcRCi3vblxR2C4puQXQRGceipkR1Eyw8z4HayaOfQs+EYg7UMeF9ODjJAUE?=
 =?us-ascii?Q?GH2VGCPSTCwZ0LVVha+aD6fiVTNgzIOxF6kJhHQGXXHGYeT7pwHev0/f/ODK?=
 =?us-ascii?Q?VEolr6xuFbsVYgcSU9SV2p0E1IFw5umJbhNQ5beIcIlitJ/rhSf5grMcYlpV?=
 =?us-ascii?Q?8q8Cv/rniBq1bbdlNsqQ27jPulW/ZT65ljfApKetYDMsTxYCeW0lETo5N9EG?=
 =?us-ascii?Q?10Y2xvwlcv26YRzwbFR7e1vaZ+F/I3VG5pQTN9etSB2aEuXoip0rcGXFPX0y?=
 =?us-ascii?Q?/xD2761VmDLqRli9MbwiSgfBUKXLOGzEXwfNOc/qzS1cN21xThm0bxWoDju9?=
 =?us-ascii?Q?k9nC0M143mpV/OsZB2Zp0wWaUStNxag+Ba1HV6FJSNTOZDxq0CRmt9G+2WGK?=
 =?us-ascii?Q?t70ebc+Mhw3/FaNcLOu2ErGd1uJQR+zLEk6Zk9488ubc1HjIfTVCLDgwA9Ph?=
 =?us-ascii?Q?CAGgpBsvGLbxjyzd0rbxMTEkX/mFEpyQovQrAWYuaF1eCrPZCPeo3wpXF2+Q?=
 =?us-ascii?Q?EyjTB21WtkTBHiCWq4dyLig7Y7OPQTTLOsOPksuxXtxChWUvfKf5PXD173bm?=
 =?us-ascii?Q?MR1OjQNyKCSyVRxS567BJVr2nkFylgx33oV8Rv9rXiG2FjpT9GUVkl8y6jr/?=
 =?us-ascii?Q?y4+K8W1QAi8k1O6ldPASyaKDlnn0jgF4LyEyfdAYZJKw4lbzrI6utbsg4STt?=
 =?us-ascii?Q?1jEyBpZOwMpzKzX1pgkTqAx4WkjUPVwG25HbsiInSA1MhdeOtC3sJp0fHyQX?=
 =?us-ascii?Q?aLWod/ht64w4kfHq6bq2xP6oFZWgrfzo0d9GAN5aXQDeCC1x7Hrwa/NtFBpV?=
 =?us-ascii?Q?l6u1uo5/hzNUQWh0WXhQJWqV10t3XM0opQS7y4yqVKJCdjuoldx8HQkxFk4g?=
 =?us-ascii?Q?3Z57/+qqTUg3VJA0HRvGKBB0e0aoRKC499y9jOfWAR0EZfwFtLYIQiy1y62n?=
 =?us-ascii?Q?bEiBJHASez8zuVte7RlQtAitO1P53m+7FGKLJbN0jwqVHZYvBw+g9Zcvctl6?=
 =?us-ascii?Q?zgGsD1cLvaLzcZHblRaLD11+S73RiXgzXN0Wi/BAqIGZwVTVCcizZijt+5dU?=
 =?us-ascii?Q?l77YKI/85f//An16O0+FSCvikDtsXEATKQKZufJKQ1vQ/hNqaUb4l6QjD6MZ?=
 =?us-ascii?Q?Hh4wzQg5axpF9SjXm1yjnbKr4oLEl+tri3Xt9UmOLLyOY/uXUVOUOCy3DAp8?=
 =?us-ascii?Q?xjgWrdJMG+IiOzL9NP2R3RE+5lXwWiXnuxiIOMPheJF2hSgvooRu5LSTv2Sg?=
 =?us-ascii?Q?MWN84YcRtGJsxpFBjGT8za57T58hcJR/CLITJQKxLVz+dY96l1zkuNxMir1a?=
 =?us-ascii?Q?7XWBKS4+cD/qq5csPJSOudDehaoe9dgHfp01Ay6gm/OnndZmMGTKx37D+8d1?=
 =?us-ascii?Q?j6Gh2oAvd0IUwpwA9cGt09tzAWHVhP+VIk69n6knO+I14jrRsRsevD+a1Ztp?=
 =?us-ascii?Q?XhHhs9oAZbMHMDHHBEpF8KMzgXnQXsEPxcmkzQeVQl0K9r9wmdPp9O9eJC8x?=
 =?us-ascii?Q?imLFx84g4St0dfZpXQF3DHCn+xUU86pi8XL96MA+NLsVr1gAai+Llypm4JZv?=
 =?us-ascii?Q?QM10fIK4ZMnSXvcURI1eu2N2uwYUeUuzeyQYI5hHBKdZVDj6qVtqDPd/oo24?=
 =?us-ascii?Q?GfjlHQBPzMYqRjgqZ5tpESzdpXjnAM8Kd1NkUum4s4Te4bGu6cW8/MytNJlm?=
 =?us-ascii?Q?0QfKDMV4Jg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0087bc-5faa-44d4-b8fb-08de58b802ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 06:40:47.4125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 27BLNIaj0PJyo825t5a0xz4MYQ6bDZN/yJMn8cV9thIpnG+fOtp47zt1zEx/Sr81OKESfu2CfeyQ1dfD4ndDxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8058
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, January 20, 2026 8:13 AM
>=20
> Currently the core code provides a simplified interface to drivers where
> it fragments a requested multi-page map into single page size steps after
> doing all the calculations to figure out what page size is
> appropriate. Each step rewalks the page tables from the start.
>=20
> Since iommupt has a single implementation of the mapping algorithm it can
> internally compute each step as it goes while retaining its current
> position in the walk.
>=20
> Add a new function pt_pgsz_count() which computes the same page size
> fragement of a large mapping operations.
>=20
> Compute the next fragment when all the leaf entries of the current
> fragement have been written, then continue walking from the current
> point.
>=20
> The function pointer is run through pt_iommu_ops instead of
> iommu_domain_ops to discourage using it outside iommupt. All drivers with
> their own page tables should continue to use the simplified map_pages()
> style interfaces.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
