Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185372DC764;
	Thu, 15 Jan 2026 06:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768459457; cv=fail; b=I/aPCqmXP+jhj02aYxr8qUYDWooRx+Idm6FeSJ6M4IOHusuoBzN7d9RhLYrCtqBKZdP7b5Kx0BYZrqMMatvogCrbNu2E3ffUiblbZjtZSgJGy0WgyfPjeeQmlQpy4p0IanYNFIrYLv6qh2zNikqXHKTkX7r2jMAfjt+MnRTkPeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768459457; c=relaxed/simple;
	bh=2mf98gwAUJ61Hil623ZYMSPICEIEM+SYyRzLhdHcrbo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nvXa5L4pgKe5cz9SSsNW+KWezyq8uD+CcGoyLYex1qd/YDt/or3vIkijflG0gELKjQC+2lV83JOeFMn+TbzjO63PqL8/J6IydHp/1m6jZr6X8XLSueT5dOtP95wTiAjrsHmSjmZv02RKjSlZoyvczrVkrn0YPT27avfD2dqvXsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KH/oXyGn; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KH/oXyGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768459456; x=1799995456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2mf98gwAUJ61Hil623ZYMSPICEIEM+SYyRzLhdHcrbo=;
  b=KH/oXyGn7Wj8C0qdkG5+3+dbx/XEcoeWSZARxWXznqHPhxprqXkaDheh
   or7yf0ERzs2qEkLKfE1gg1ylwn6FXTz8kl41ejCvRB+RS8J8Gi1Z7W0wp
   tBxh7aeqMzGLxEbDUGsJkDswvdi3nSWDcrYc9kB+B0JiunULsvU/7NBws
   0ZfzOJzRIfWnNtZvRVbJoK4KzeT+4oo4UR3LbDJCokh9Cx1QJQI3MmtAr
   qEu+XmNSLmwZnhmzaW1r9iE3WOjgDQevpkbqWKWnf9UdWi+qy3NQgWqhh
   SNJ1WxcxPK5me3WKz1duItXBG4gu7ZT1CVVQvhGiQ67EKNLwg2qKrLRkl
   w==;
X-CSE-ConnectionGUID: Ql1jif8HQieDdZDXS5/B0g==
X-CSE-MsgGUID: iFvgB7VfQfuAelgTjFCQ9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69849488"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69849488"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 22:44:15 -0800
X-CSE-ConnectionGUID: kCz/IHLbREWZgDgBdJfWpg==
X-CSE-MsgGUID: erc6gRk3RYCjDdPpmn+Yew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="205396494"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 22:44:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 22:44:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 22:44:13 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.10) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 22:44:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRzCiyn4G7hCyFKMU3g+aR8UGdWYpJhOhbh2tSKSjJMf6bRm6B12KcP/G6rj9XVTA50umSIB1/gyPYL2VHazT++nFIQFUIxNcfD53B0kNVgednsbWMa2BJStyQe0m5GlTyT8I1afxfkPm8dFXPK949GDdG6KY7OWNe2KlonQ1lU54lgsPLli5CsV15uXkKyOx3olxtz/755Or7eHSKuE+pGv9eOQtVuondiJvGZbZoc9eX9eDIEZc+1ZuRNfkqgfjUlnZpBDLVwg5WH50FXTuIwUXVahrTfS3HxZ+NUUOxyXf0JUhFc3O/1k1+7C28RuFBTRmiteA7tIgArk6GOZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4d4fBLwY2VIaRElb5RP/QV8TS+DYEGL8f3j+kwW0ehs=;
 b=rGg2Jvp89FnSmf9J6dNl/reYrlh9XvDRdkrld8EpI6UawqeM7NVCv/JLlHV1FyhQfy2fnAxDV/qp1wCJg1lzm6mXk5Cc8Glmhen2yQzC2M46Yrstu3PuOXsMqOvZnkxgYblTjLDzT+PagNQoYwGVk73j3MNJ7zKixuRqOI5B8BZRT0Q7YHxKHpGSoiIfn6XsLQkmqQj91P1VDggSUUrYXSuFPJzgXugFxhM5MUMTCRXMeOA9dmajviyMFrp+uyxudsaWeRNKivO0K+GsrvuJZ8AXeFYTjbVg+cZQ1Ap9x9YE7dXul3OzgJ8+WpojL1eoJj/RRCVVgL5xGOPQy+WxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA4PR11MB9201.namprd11.prod.outlook.com (2603:10b6:208:561::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 06:44:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 06:44:06 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel
	<joerg.roedel@amd.com>, lkp <lkp@intel.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Samiullah Khawaja <skhawaja@google.com>
Subject: RE: [PATCH 3/3] iommupt: Avoid rewalking during map
Thread-Topic: [PATCH 3/3] iommupt: Avoid rewalking during map
Thread-Index: AQHcg9KobiEPgIPidEaI13WTC0BfJbVSzCPA
Date: Thu, 15 Jan 2026 06:44:06 +0000
Message-ID: <BN9PR11MB5276F66B367DA84472817F8B8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA4PR11MB9201:EE_
x-ms-office365-filtering-correlation-id: 1b44e401-70b9-4b27-3b06-08de54017ae5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?z8UwNSiUPY7IDAVXC07NmQNAR0deSiv+keBgtQoLGGMJs0UKozRPTJkndH8t?=
 =?us-ascii?Q?+DRPtfxkWHmbYGgr7b9rI6n7mntUSdmkLBHXYIV6gnbk47VNVsPt+3GVnrgF?=
 =?us-ascii?Q?IjHB+ygBYE37HT9Ffj6j5FdN19OFMKJe4IKnxR/q2Ff9koVnGn1TSYKzyI+U?=
 =?us-ascii?Q?XXj3R3WBvM0SgNAibg2z3UhhS7jWCfx40JSGzsAqD5BY7lNa0DD4Pli251/5?=
 =?us-ascii?Q?xn6DrgkLi60gDizIqSN0AOos4Q6/erwjzqisLfjZzfS4rdYKpC1Cm9qVXzzH?=
 =?us-ascii?Q?bLrZV/uoDYUGBWxVSvITY4ImLoY9fd9iq1+cTPZQN6t2iW6T7hdCSpv4Svno?=
 =?us-ascii?Q?6M5gojL5AsI7OBNXzB8TJAMJm5QRsRpKyqwEKw8ayVPWom6cC/kKIqs41z1r?=
 =?us-ascii?Q?vLwvS5LMlhSkMiXEpSRK1EJ4sCC0Kq6Ubp02Jkob+q01XufY8lG+IzqEW1ZN?=
 =?us-ascii?Q?OHWd8hW/7mtksIWnGzY6MPJpny8r0wPzmWgMsfor8cEGsRUqzB1brUUI5s8j?=
 =?us-ascii?Q?UmgH2MUeNYTfygE3Hj5DiBiVpHlaKC/kiyvE3Zhu/NyiH1q09jjlJkdxGSxQ?=
 =?us-ascii?Q?NjHFpx0EJdfnnNYxhfAdBDkCgG1P+aDdPP3Bw5ZTPfi/ucm/JFar8zspk9Ge?=
 =?us-ascii?Q?qekfljM7tAkWwgE0HriuO4w+6cRNf0qINnjmfYX4xTaS8Twu5rrZehw9n/mL?=
 =?us-ascii?Q?zU+oyHDS11gLFr+AY+kV9DJuLnB5/wAgcQ/+YqAU07miSzxOh9yDVMNZJsHG?=
 =?us-ascii?Q?X2jBqnomWYJhjRFEe44o0IxC4bh50pM2NJlenV0lEKtdW8n4UwsK4BMM9WXb?=
 =?us-ascii?Q?NKpGFAeek0AyQyburwagBsLs7sRw47fV8XFx7Jc/MslkzQc0ANRQkc9BsRXD?=
 =?us-ascii?Q?2L9I3WuC56qj/w0d1V8CQ9ecxEHEYyZEJ3058GfJ2k9ryovHk+lraPHe4+sA?=
 =?us-ascii?Q?5u72iFmMO+lgffyOo1DjeQutUSyK0VF5KGTZaG9llS6HkCgI8WSE7PArMPvo?=
 =?us-ascii?Q?/DKyhEQeH5265dmcMCL+pXAfCFIlv9IDgSQjP68H/K1pLPIHUSJJw7k8nAJf?=
 =?us-ascii?Q?9ZBn+NSN7WTE1FdzZ4zoJkju+6ssNCgZZh8KV3YKug2x4a6PSHiYkiT+JeA4?=
 =?us-ascii?Q?46YSj5M8hBiaBge4cjSZH/vz3RUUa5DifUv/aVVpihA0A6bYYNSe3QNMjoQr?=
 =?us-ascii?Q?z/SisMSYKKPvcQbPGTdzhKddmFoxon/3H8+iNJk+9GFozzZAD1+CaBmScdaU?=
 =?us-ascii?Q?MGAjwOSGWema/uaP2jpaezkWoWO3xUfP6+Xcz4g0y/IQjs5bThTbQswJlOio?=
 =?us-ascii?Q?EDp6AyKuaSlHL2BJ+0dLVKDjJM3rHHYynSlymexnPP/C5d5Bawa0FMhn/Cij?=
 =?us-ascii?Q?xs2HvYig4m8LdgKjWdoJUZEf1axUQxSU4S0tqEf3/00tuAMAgSX446E7OvFP?=
 =?us-ascii?Q?CY/usfNecqDHzkayUi0vqf3BXPpE4lhiliJHlgyxO4AMXopfVHdYAL2HC0lh?=
 =?us-ascii?Q?zzRKgd9S5YKO2/q+opUok/blQ/jhNktnDxSrhMsol2BP1sUE9N31BwmOsuXd?=
 =?us-ascii?Q?9uGTX0Bg1jl3rP5eQ2Ciyf/zR2fmezUI+rKmzoX4dkzEAgdZUOHwZIIQ6wuE?=
 =?us-ascii?Q?XdL3a6yfx/B0WidgK2QDdcE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C/GeXz3ZXKD4SyNOCr1ns9SpAmYCPpFwjK9uzdTVc79GB/9CSa4R/v9j62+Q?=
 =?us-ascii?Q?lV+2TbYEa4LNrOZKKub7bkcXydohG8UsEs4FzF8wJ7mU1qZjhTlDz3RH+8Tc?=
 =?us-ascii?Q?HsL1PwaK0POp/WtYuboH1MB4vb+WfIZMWaNYubNBWWfgQvxk4ZMssScEo90c?=
 =?us-ascii?Q?NIigxSPJd5gND/m+2FoZOWeaH+7UU1awpLMV6og4TsemLSDA0Dw+yEHonvh8?=
 =?us-ascii?Q?W5hqbJuay933l2DiQM6QL9aS7v8hmf8xvs9qljvKoi+ACPDPhpBeSIGR16sb?=
 =?us-ascii?Q?aRbX0VIFU60n4lX0mRtnwPvLpRbqB59RwA9cQwp5cAjQQ4NBSWIubs7t0Bkv?=
 =?us-ascii?Q?g9YaLv9vn2FtD3weGVFCJbgDNKzxF9XqqtR1BsRN05QuiBIYgJelqKz/n1aU?=
 =?us-ascii?Q?awJlj7X5gzAEmcDjEgbXgdGWC1BFj7tCcntq/yd0RBteWZsNCN7t1kDWTjoy?=
 =?us-ascii?Q?QhEYvdyctIkAsWAUbqF2EVOZIuZ6L9R95LCj6CBaa/odVWIEysNPOURyAoKq?=
 =?us-ascii?Q?NE2ewcM+lnWNGNL8yvGivIDmxsTboNIvKFJC6sBom3d0pM8IT/kwIedd+2hj?=
 =?us-ascii?Q?Ixf3gTrqn4r0l2sfjg46LE/9vaPANoiKmK1lHE6gwtukBOWAxxgiLcj/11zK?=
 =?us-ascii?Q?8A5WBlJ5oVJRtI4F5A9PjWoKRdYhkyeIUohTOdlsPr9lb6astl8cc3YHPFX6?=
 =?us-ascii?Q?GD3lXmSSmgeYkzeSJt6YCs7r0sSD9ZdF7vzn53DWbVuiyyLlZQ+29fJ/FQuU?=
 =?us-ascii?Q?XHEX+o6V3EjjMTS/SwsawApegRBVqbkQ/DAhxiHU8Q0DGPE7LZjt2Iu3GaNt?=
 =?us-ascii?Q?m/OXykzlmbpQid2vxRmo/rIzYk0lNQ2ehEKVG35zqHDNqSUNYvoLi5keURna?=
 =?us-ascii?Q?5irWObf5hKHLKUakQRtEDJohpiis9WXnoEH7fSgLqp+4DRnl/Etf8B/l9PhS?=
 =?us-ascii?Q?3L59S95w2q1611OSUqvNiYOi9468xw8I8nalTMlieNyA1ubVAnJNXwptmn6d?=
 =?us-ascii?Q?94cvm57PRIfMaZiLZCmqqhzgNO67NyfwpGVWylpm6X+dw5+/eFC7lnOfehro?=
 =?us-ascii?Q?ic6kTV+YCvfaUJEXf5c+ik9bkw2Vo/xuqJsMSgM58aTBLTrsCMfwM8SgomrW?=
 =?us-ascii?Q?E3/wuhM3Lk7Jk/WCUZxHLw4U9v5vfWHKK/jPL1UACZqMArTFsZnl9C+Pr/eI?=
 =?us-ascii?Q?/aOcddduDd4DH+u8YHnw4GbqoVAIKHXKNPdU9Hsj4HL6V7jq7U2BOhvkqxzC?=
 =?us-ascii?Q?KZAErIFagEMuIS+sr2oobiJ0yjYtTBQOOajoiW6l7VDuSlBHAmz6n4cOQV1V?=
 =?us-ascii?Q?SDdwYVnc45VlPyUDEg9/L7H3N8ecVtHIHscdf1w0hHBUdLee2HJe+O00A6uB?=
 =?us-ascii?Q?K8fstdre7zuGVM+vvxkGIH16kc0tFPfnO06u/+erkL1nm0b6ME2Zno8p9HEN?=
 =?us-ascii?Q?oicmr3IKvVw5Fgg1usgAeQPdt/69hbkZUOJ1oWwTxGLvvixb7bW+1F2ruZO/?=
 =?us-ascii?Q?Lu2QETzyr/9oAZ3j2d8ROiZ+zC93rjLZzDlPxkv2o5/V2rKoHvYJcvbSbri5?=
 =?us-ascii?Q?BcA+U1n9dvAgU9+LnW8cNYFgFhdKWnC9fP/S8H49VaaWY0nAP2VwSV15PZgi?=
 =?us-ascii?Q?5+yrruZo7ZLMXiTnS84H2kI3fzLee0k0X/SyPAtaoM4lsVuieb+jNwSQuOY7?=
 =?us-ascii?Q?crglQ2pgpnJylyhxXY1Nvt1RtaRxPYfeEKmJRlwlaxZvouGoXJ6mY/9jVSTO?=
 =?us-ascii?Q?xVG+utAhAw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b44e401-70b9-4b27-3b06-08de54017ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2026 06:44:06.6171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zXS7C5ZyfpMudFuBGl/uTi95792RKMhqk4wR0PhAAZVr2/WDhnApz9U5M66OQXzvf7sFLlSZH92IpG6oBrM8LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9201
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 12, 2026 10:49 PM
>
> +int iommu_map_nosync(struct iommu_domain *domain, unsigned long
> iova,
> +		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +{
> +	struct pt_iommu *pt =3D iommupt_from_domain(domain);
> +
> +	if (pt) {
> +		size_t mapped =3D 0;
> +		int ret;
> +
> +		ret =3D pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
> +					 &mapped);
> +		if (ret) {
> +			iommu_unmap(domain, iova, mapped);
> +			return ret;
> +		}

lack of trace_map() here if succeeds

> +		return 0;
> +	}
> +	return __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
> gfp);
> +}
