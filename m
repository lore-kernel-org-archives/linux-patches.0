Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07450212566;
	Mon, 26 Jan 2026 07:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769412811; cv=fail; b=coGXvUpEH1mCTR/WkDe3+O99G2kblRSyMfK1yqvW6UUHD9MdQ3ybfVcO9QOE5HFYEaFW5p1xCh6RVCIv0Jtu2P053Y1+yjxmEwfycWah1mn7/utQROnBaNrOBHe8Ye7dumn2ybTaOoExqU8jqvpcWXlERIVTQvsQUTXahOP+0OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769412811; c=relaxed/simple;
	bh=JhRcj0WBPnQToy0eqSTg2ZYrgp4fHhoU2Q4DTOGcy7w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=na2+ziywhBdcqmUWtJI6iyaQghUcFjuCMnsB31tVXwyFdTDqcL7xHUq4g84jY68m4NVytuWYJFcQ6ujVyw5rf8MchfZPg/nFKKzax0Xjfp808qutQsVOZ8kORwdajw9jt9ZM0DIK4y/jj1MliEWT35la9o1P/JNQhofYZUemS+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJREHf2y; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJREHf2y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769412810; x=1800948810;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JhRcj0WBPnQToy0eqSTg2ZYrgp4fHhoU2Q4DTOGcy7w=;
  b=VJREHf2yCsb9eiBMxCG/EaWkziyIojcpYMpS0miMl4YP3Uf3SQ6FuJ6m
   Q0rgWcvBEWJ+49MbcFJ/WgPK/R4YfGsHbxYOFVKtxR8OgX1JF0s62sIzV
   av+Da/Z5sCdzDV2uLw6GvgKFeRk6CVqoq/2NRfWkuZVDDPI/FRYfKC8L5
   V4ER4ywcf+TfIrE1E0h0vJ0Q5LvLMuURuWHxZvvl1AwAnn1OQy9Ro2CPM
   Y6z52iUKKiAhK2T9ti93XLGNOtAxcCyievwnOPbZ8W+o/Ngepc24SVgHW
   xjZPnqGReI8uaVYn5w/eof7jw19J6Eoy0bRl+jhMWh9BpwjO1ghZu8HAH
   g==;
X-CSE-ConnectionGUID: RldqrDA8SGCJBsJxPavU2Q==
X-CSE-MsgGUID: 6e4Fj6+rSa+X7/ScKWfSmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="81219089"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="81219089"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 23:33:29 -0800
X-CSE-ConnectionGUID: BSkwXLAYQJa3/jztBZaNhg==
X-CSE-MsgGUID: M5if7/BLTViI019YtHMKjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="238865166"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 23:33:29 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 25 Jan 2026 23:33:28 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 25 Jan 2026 23:33:28 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 25 Jan 2026 23:33:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbPUGratE6L9NFuuAzlshgXwNbx4TP5hZqaeAY+CDGqm7h1LFBKnrev99MFILzBIIxdSJHzvzkfWR4UBhrht6kFTEb9ncgBtsioX4x88KI4hheZWWMnOlEW2ONqFIyaLJ8GIQZJDdCojHsAPRe96lmcPIdrPTI03XzO6K7b9WZjSS8fNrQsiT+VYbuPEGlvq4bczRywSVa7e3qA2VUdUOtcJ08WmmDPUlYTArP7URwF4iPafiaGv7ul7DVGYQ/VQSzKoCIxCxx7ynYKXZVBRRsDV5gIdqbrq6sPhkuFP0jAatgKSqzaXOhgAC4EQsXIt84r5ufPwIM2mIqdg0AhcsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fa0GWONy/b0WmZFcQHZWl4Dw3QnDeT2BJps5yZqiCg=;
 b=yXWkqoZJozluV7a2PPkDNAcOilGIjzVm5lgkQFY8jJ6mvSx0W2Dmb1kgSmOoJhJuKweCfQsxbJ/0kjolCUsgRnxt+E2EwYyC4DCfjwceJO11yP9PK7Ktng3Pj+j8NzvQGQzEWxs9tYCEUT+yKAcEFWGra3X1Im4UWLieE8Oy9TDlkFw76yIseMk8MASBp7GWo7F8Gpdc8Yu+7b+Ct+NkLADu1pPsQwd6MzF2/srzScBCB7kjVId9D0uiLwPsJ3dGHDZXxmrNUtXbYH+PV0PTnDN1i4mPYzczAiJyiBgUUD4V4SmQhFuKg7OajFjMihJTh2X/ZZoTZN/Q3cH8aVRnIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB7951.namprd11.prod.outlook.com (2603:10b6:8:eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Mon, 26 Jan
 2026 07:33:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 07:33:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, "Brost, Matthew"
	<matthew.brost@intel.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>
CC: "Dugast, Francois" <francois.dugast@intel.com>, Joerg Roedel
	<joerg.roedel@amd.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Thread-Topic: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Thread-Index: AQHcjXSSUrfgiyXzp0aDYIe7CuoQ4LVkD5fA
Date: Mon, 26 Jan 2026 07:33:21 +0000
Message-ID: <BN9PR11MB527689AC9554360C2339E7598C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
In-Reply-To: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB7951:EE_
x-ms-office365-filtering-correlation-id: e50973f1-097b-4c85-5224-08de5cad2e88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?DyS48o1Mj2TuLYf4ubJyhtxJufXYWtpR9sc2VIEo8puq5gIidVrtLyoxUVfF?=
 =?us-ascii?Q?HDpyFhbRRlhKKC5BIULOvX2ge2g4YuxbxDvidZDYTBEjlp0BDkvQA9GKD1dG?=
 =?us-ascii?Q?AUShWlmKjIo3phShIhI/l3uGODQwgpOzhfAFSyZ7a2YF2faqRXXastPd9Dlw?=
 =?us-ascii?Q?yq/TZlelMibxZTIR+/tCVt0r4AdC5XzVTvENiU12cZu1hs2yX46FS0WdYza6?=
 =?us-ascii?Q?C542urMwrsINkKzqzJdU0i8bsl4XUctU+DrckNG8CvAevWoHNoMPxjUZ5W8D?=
 =?us-ascii?Q?fteYeHkm2d6BlKMMrN8kBujA89ygPF9WWV8xi1gYeRdi4EJCsFpqp3XWmvmh?=
 =?us-ascii?Q?fF3Q3P90vc+e2T+deemRKjiWOnj2M4+VVKNjX/oosisf6IALpWgW23r8Axg+?=
 =?us-ascii?Q?x918xCPhmFBlUJpseWIo73m3On1dpwpZB/yjiAF1+Ph0cZQ1urn46IIkGxHi?=
 =?us-ascii?Q?J7yggxA/jEJUCt+XXbAFUW2I/3C2yZhXI09C0psK0bICTKvsd0m8NAmEpIud?=
 =?us-ascii?Q?T8gPb4I3W+bo3B/x/DKG7QRBaYuD7QknX9HM2ELCpKZDgK/vTaZKt1z1/4Rm?=
 =?us-ascii?Q?uUdpelycoFUZjTKCDi1zZghHgCQpEEayfX8TXwx87e1UsKlcQekDxf2Z2bp7?=
 =?us-ascii?Q?EJeJ3SqlA9hpqPbseU5D62OHJReQgrr0XIphNeE6Ff+75/3kOU1AFBQ7ZIrG?=
 =?us-ascii?Q?Q49Ujj1zHy2VXOV7HA3ShR2D9+DgpUwbJCh6rAEavoETmPmp+GO8dJQXgn79?=
 =?us-ascii?Q?QRqYijHqbt9Wco06z7/37EYKGdOuMbvokIV5dIf4VDb5WCOuZhX0uwHHkZFU?=
 =?us-ascii?Q?wE8FuZbvCb1VYgZ+CHXU8H6DSYknncF0Ig2g/g2/AC4IjICpE6bUu1N4M5U0?=
 =?us-ascii?Q?u/o0AYU3iGtwtGRTrjrpVYQdBrDoxiJ9AVs+IoobgjZa1BscaIEbBmAB0Jjz?=
 =?us-ascii?Q?600pZZbQbdfezJi7xbOPWgA0rZUEJzBURa0/+jdGsF57yxr4rFuCZ4mZ/cQl?=
 =?us-ascii?Q?C1TZwiAa4Qk15cA+iQYp7B63EIKtiJp95KY6gpG1fbgcOXyrBytcYA1Ed/NZ?=
 =?us-ascii?Q?fTyOjL1wnbfW22/L/AnL0tMsArOVgYZ3f33LWoBA2X83jLSCU/Fvui3Zzih0?=
 =?us-ascii?Q?AIiGZbl2NJi3U7GhPB30MqIwdy7FIkL01Ru7Ksj0OvLJxdWV2VsWMviCQBpm?=
 =?us-ascii?Q?9NWmE2Gc7kqoh8CcYgjqOSOAnA6jOSvDoaobVIVRGeLvR8ZfbH9tINixUnZO?=
 =?us-ascii?Q?nicX3WrwPXZ4sTJzgwxPFEGdAP1GBORmTFC5VlP7zjPET2RbZIwpwaXJrErw?=
 =?us-ascii?Q?oZ0AvB6M6TSgTBqCyKE68cifzDhE6AmFiipU3GpARBrx0yCJvVqkaEHZTuPK?=
 =?us-ascii?Q?nGh/QKFBTsknm4jMkPcHdRIWTxfbsh8/FbzhBgIYxeTKto1vSUHLZsGBSCOq?=
 =?us-ascii?Q?ni6YEBfzKgrzw4TI6gvVfCyZoNUOvDUIKRwxXxsTDbZAwZEQU3lAHFIfocZS?=
 =?us-ascii?Q?gFpaoDTkRfw5/dSlFHQN4Csj+1OC/WzQcXD2Kxuh8AbIocArntTrMTAHnQ6s?=
 =?us-ascii?Q?RyMaYExWcrQ3kHPmPmFE28YHdwP2EEYuf/9c6BnmfJJC9N4ZqL5sYu7RCQcF?=
 =?us-ascii?Q?8+BeDe7qjtRkN++x9KC2A6w=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s2gKH0Jx/IqQjN3oeZtqb3bXC6muTPudamxH17wUUTaKctIn+Y6f2WqPLXuh?=
 =?us-ascii?Q?0S3QsydOnnwcw+6f7XnC9kruTrkqqe6LD6AP67Vve+ddWOBJGx+/JGKSXysQ?=
 =?us-ascii?Q?OeNwDvn8NAjHifF2hPWNriyhD6hTwvp/dy2Zo23IMbvA6IFOxRT12Jlv33Qt?=
 =?us-ascii?Q?QjzMlh8ez1q9skw7GNYnkXLu3Sm/CLv8LKvlW9xhsYkxzFG3M4fKCAkZOFd5?=
 =?us-ascii?Q?7W7hUa3Cdk2MBj7+os+2SzpzRl/S41/VbomAHxx0g4fsNBQh4NnOpBSmvYBk?=
 =?us-ascii?Q?kkheNbSfcv82q0x1A6pLcdYE72EIKLWRXWhOxN+yFOUbMPC1hB8cKLP4FTIH?=
 =?us-ascii?Q?z3ahKhJDj1I4qBz2eUJoN1X8q1xxnhnzNwBnKrAkIJ9QMZA2w+gIICuYswIB?=
 =?us-ascii?Q?Z5nRLAmDXjuMMbfaifcPQ9nSiTJK4ZUohqah7oRqzhnfBtwCebsocnnvj2Nf?=
 =?us-ascii?Q?xtQ5Yyj2Y7ou4OcvZYuiMfb6rlrr2z2pnU2l5oLIyjFpngDUhSt7WAbuiR7r?=
 =?us-ascii?Q?pL0ExTKsEb5SQp5amPtlzS104irGfWVukI6zM+6n4LVsDlweoIwXFQbGptOE?=
 =?us-ascii?Q?gSdYpzr2X1HdKAXKEVf79K7ANlnFb2RMaBUTDB2XDBWDtzSE8yeNJn9XczyN?=
 =?us-ascii?Q?Q35HGCwVPo4WZMf5US8ILGx8Wl/W1jJFmVOdpQrGD68RdXDlCs/kje6fzhoK?=
 =?us-ascii?Q?arLKIK1pEgTwy2uDeTf7fkRNAb3Gv4Q7EZYbsQNMQ4UbR2kLz6/Lt+tSxaWW?=
 =?us-ascii?Q?Eas8WM+U7gChQWx2/DcMJJplsQKSEgYbsdimvBgR8HpZmK4ckvF9CEO8i58p?=
 =?us-ascii?Q?XwJAMyJsFCQu2g4VGvZ3afqOR03y0WZ8rAFH57a1me2W3X/1dky6bQJB4y4U?=
 =?us-ascii?Q?mrdAPRH62ZmYBbza01ziBB2mzLP44sEIYk8IJO+b3tqgRgS6W2pSPRyjcsRm?=
 =?us-ascii?Q?omOeIW2wikgkthQy1/KoVDJ7dcc9U2AeUF3N2+a0JyZuGe+QAtNMT4zcZn4H?=
 =?us-ascii?Q?IAAnx3VOHH526zXDQ9xsyCYecWmwSnBemj72YItrtugtRZbJg4C9jlq3Baeu?=
 =?us-ascii?Q?JYhW3th4H0WD5Lgm8MaeNS5T42uuX4c7Al1JG8Shf7aaq57b8mdnI9BBpsIH?=
 =?us-ascii?Q?ohNxN8AIZ+BP7D+spDjvHt1u5OPs07SCMgZmpHl6bZ2tykiOYpMFx/8H/ElA?=
 =?us-ascii?Q?QE8LDvSX5Z4xuGM2WwlzFVlqlI4UqWWiWMDit3i3/oUpPP4GAPfxQ48TIYqN?=
 =?us-ascii?Q?C6VF9EmQxm6QqTBRVqhCPqtGWK1pxyEFUNwL3C5QTVmv/CbhUYPNn1ogW9ln?=
 =?us-ascii?Q?tv2YcoohdnNjPMx4dSkBwC6sBWPCnwXbYOlaJqBbySnvD9pQFrmeiz2SZG3H?=
 =?us-ascii?Q?eVr0zZySGx98UAKAjazGBf4/+4/WHn9va8AZZePNdvZKXaNtW//YE+rEtd1f?=
 =?us-ascii?Q?b6indFvL0+FsbYg4V7bPm5bzFY/LYl1USGeTE9FdUgS7i8WYlyRdbqWUy4pg?=
 =?us-ascii?Q?Ps/TrwqB/v6Kwt9XXc9rHvNirkvpp7qNWIc0Kqik5trQE5BorUIwGx2WG7/f?=
 =?us-ascii?Q?wN5bxBTlh2+UpnUfpV1eVLb2GXKEGP+AnRp4Q56pF4RgXubHfLUFmCgDnyu4?=
 =?us-ascii?Q?FSUq4nB/TjTyqOUsA3x1RzdYwpc2slXfAc/ohhlzKh9HCHtKqjroAmqpkAvm?=
 =?us-ascii?Q?Ayj1O7eL/n5teqkJjcPoh/jPHI/bGRm9jA0cHG0MaBNSuUH2hhk+dtY/dpyq?=
 =?us-ascii?Q?cYaX/YP3pw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e50973f1-097b-4c85-5224-08de5cad2e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2026 07:33:21.2784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dhW01P7rRRky/TAULcQ6xVrPkBoZvHMdQH5kyAWhnWZ46axKgEoxqJFGT4SC7mBsbS+1YGS/klDRSDpA/2PsHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7951
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Sunday, January 25, 2026 5:00 AM
>=20
> The cache flush was happening on every level across the whole range of
> iteration, even if no leafs or tables were cleared. Instead flush only th=
e
> sub range that was actually written.
>=20
> Overflushing isn't a correctness problem but it does impact the
> performance of unmap.
>=20
> After this series the performance compared to the original VT-d
> implementation with cache flushing turned on is:
>=20
> map_pages
>    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>      2^12,    253,266   ,     213,227     ,   6.06
>      2^21,    246,244   ,     221,219     ,   0.00
>      2^30,    231,240   ,     209,217     ,   3.03
>  256*2^12,   2604,2668  ,    2415,2540    ,   4.04
>  256*2^21,   2495,2824  ,    2390,2734    ,  12.12
>  256*2^30,   2542,2845  ,    2380,2718    ,  12.12
>=20
> unmap_pages
>    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>      2^12,    259,292   ,     222,251     ,  11.11
>      2^21,    255,259   ,     227,236     ,   3.03
>      2^30,    238,254   ,     217,230     ,   5.05
>  256*2^12,   2751,2620  ,    2417,2437    ,   0.00
>  256*2^21,   2461,2526  ,    2377,2423    ,   1.01
>  256*2^30,   2498,2543  ,    2370,2404    ,   1.01
>=20

that is great!

Out of curiosity - why would an optimization in the unmap path also
lead to better efficiency in the map path (in some cases map improves
even more than unmap, e.g. with 256 pages)?

At a glance I didn't see how __unmap_range is relevant to map...
