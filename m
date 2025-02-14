Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FF17555
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739553478; cv=fail; b=fm5YMo25fWAf941OEfE4ozJR1tDyi0e/vF4HbsAkQVz6WGtnQ97GmWB+ChIVWlxDwalVNHg7vvaOjetsY15HTZrUeKSiPjlvnBkFjjD/TBojbbS0nBBb2JhN8n8d5utJqk/KwIZFxzYXu16P0Pu9EiJvEVqU8PfIkTJlzHNya40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739553478; c=relaxed/simple;
	bh=x/J4tmDzXGm49q93k7525csfH9kpNolu43n5qBw2U0c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gNez3bTcwhvoNevRGPFNmjoHtHu+iXoR1rauWLMR4grxMV65Qh8D72E9hxIPeC0lDPkf0kNFgwWidiWRneVitlxFUh1Ls7NQ8aVXS341IOof+bAGghULhd8oSXAnGCWeOULd21/2tKZe273d1v0Hfs0K7aaK6nxzTQwJ91nM2s8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FiRYPa59; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FiRYPa59"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739553476; x=1771089476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x/J4tmDzXGm49q93k7525csfH9kpNolu43n5qBw2U0c=;
  b=FiRYPa59f2HEdiOTA0N7aUMEmnXQs7kfkPy8wZk20uKcgO8QAkSrPFgy
   TcRzRiM4Ar5H8nbzHTS/1fEuUnxTJzfGxsawVAYCERTui9iwN1GXiKa3S
   DQdeXUkg3OuYZ0Fd1AW5GR+qDSfCicJfyW50yuQKHJKGd0DBKF/bPQXKj
   g0xOza7WMoSlyNJQfIO3VvvtQF4JcEP3B5IrANUmca8cylXxnNB0V+AyA
   sUYbePV8Y0zrCwKqQWkGdZAny+c1pb3/imU9EFhUqjsbV2/uTb61RT7zZ
   VL8803aQJT5VSYq3nCIxxKH3n0qRJcr7c/dG6vScHOz+F4wMqup6+Mw8e
   Q==;
X-CSE-ConnectionGUID: R2kt42XbTGKWxKX+5c9MRw==
X-CSE-MsgGUID: xyyKHc7NR+qbigbGPoiT9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="40181106"
X-IronPort-AV: E=Sophos;i="6.13,286,1732608000"; 
   d="scan'208";a="40181106"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 09:17:56 -0800
X-CSE-ConnectionGUID: IJIB6eYbTYye6QHZ3vHe/w==
X-CSE-MsgGUID: rg/rDRRcQYaoFp09lkFb4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,286,1732608000"; 
   d="scan'208";a="113486609"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Feb 2025 09:17:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Feb 2025 09:17:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 14 Feb 2025 09:17:54 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Feb 2025 09:17:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sS/QkO7eoNbTF5dtq11u7htZxMM53xNftEIH6hp37oNBuOxtjX9WdYm20hmSm8ZWVOqYy2BHUzgVYlBm+dbsS2THENHFf25AIdcigijnJiQ0QccJ1HHz7NugxhOzCJ3xGAKI1kTHyO8aJo0e0FkV3seFHBEYnqGDRGRU2sk6ox+lCnL8qxJF+Iq7ecmRIDTUPvIlUvq3u2G6l/tU+LRxt8mJ2Cly6kqn9N4hOJIXtqja7a5+9vLqhmdx6w31dm6LqDJPMP9ip/3LIzcFLvwJVbzHmDL/B3xSpX3dPaVwGgGLzLS0N042+0cBEgDwAJVrOi83RxvrLZ0/LUqeKg78yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/J4tmDzXGm49q93k7525csfH9kpNolu43n5qBw2U0c=;
 b=E/kUUy9GYw04jumvgDzN20aX3aReX2wcDHEITOvlHZ6EXRwUHdQBAbQqFK8ts0IN7zCsSeUz09mBR48H7MLJaZijWrqiNNsPDYC1q4A5z4Et0iZdnomHR498CrQPCWd+QM1XxzeOjrKW6S0CzdZB19Yv21QLyVhhqheoCDNJTa3pQjo8E96F11JWzbb3DSaPKhnHIigBMc5FJfCTm2d8jX2OHcw1gB0Qe/kb9sgcNkOTCuTZCduu4+sRsuf2uIoj1qLWcOAsfsxBE6Uq9OFrwnWNv/mZ+WuNmpCOqijqG0d1Wu9VTp+Vntgxun6ZfZbdK4LiNMijzVVVWMTy4Tr94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB8052.namprd11.prod.outlook.com (2603:10b6:8:122::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Fri, 14 Feb
 2025 17:17:51 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 17:17:51 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, Peter Zijlstra
	<peterz@infradead.org>
CC: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "x86@kernel.org"
	<x86@kernel.org>
Subject: RE: [PATCH] x86/cpu: Add two Intel CPU model numbers
Thread-Topic: [PATCH] x86/cpu: Add two Intel CPU model numbers
Thread-Index: AQHbDd9dF+gR22kTGEOmrX/vELh3ubNDwhsAgADySWCAAvEogIAAOEgAgAALgbA=
Date: Fri, 14 Feb 2025 17:17:51 +0000
Message-ID: <SJ1PR11MB60838D20A4EE6FC26A544E0DFCFE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240923173750.16874-1-tony.luck@intel.com>
 <c8545ed5-b822-43a0-a347-d077bccf9d6f@citrix.com>
 <SJ1PR11MB6083F36D7C68AE8DF5AAA39DFCFC2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20250214130205.GK14028@noisy.programming.kicks-ass.net>
 <6ec8839e-cdd9-4607-8556-dd412aed41a5@intel.com>
In-Reply-To: <6ec8839e-cdd9-4607-8556-dd412aed41a5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB8052:EE_
x-ms-office365-filtering-correlation-id: 70c8d916-87e2-47ff-c74d-08dd4d1b8340
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TUZWRjRuSWUxVFEwNThNdHJLU3NZNUZ1WGllZXJLbXBycU5MeFc3MStIUyt1?=
 =?utf-8?B?djhyY3hjdzRsL0NsNGd6OXNlZzVyNldzSEREVDdtV3NLRlhLWXhsL0pPVlVO?=
 =?utf-8?B?d2hCLzE0OFVzbTdNc2FxVWFaWkxqMDBWclhFYkNzdUNwbmhhWDZObmhHUE5z?=
 =?utf-8?B?ZEQ4YkpuZWZOSjcyYTNVWUhVb0FzSUNGYzFhVmR3Q01wYVR0MGU2akJTRVMz?=
 =?utf-8?B?ZGx0WFVNVytrRDEzbDJHbEV5bDRpN0d2YnBwUWF5K1BwRFkrdTlpNWhGOE55?=
 =?utf-8?B?RlQyT0ZBSXl6Uzd1TGtUSUZDTm9DajVzVk9WL1VDTGk2MHJiSU52MVFBZHVC?=
 =?utf-8?B?bEdBNnNOdVY5Und1MjdGbmF2MGMyVm1YWGh0d0Z3VUYrUkgxK2hvOEcrdTJo?=
 =?utf-8?B?WXBuZ1FBei9WakoyTnlqU0Y0RnI0cytqRnc2YlVVYXhUMHU3Sk1vbDhuYXR5?=
 =?utf-8?B?YVJpQXRnRHEzUHVtQ0s2MjBBTlpJc1FidU9yQ0tma0p3VWVJWXBzbXhjcDQr?=
 =?utf-8?B?aHRIUUxDV3pnWWFHYlU3ek9jOXd5SS9xdk9hWWNjQ1lVTDh5Nm4wODR1Zks2?=
 =?utf-8?B?SUVVb0l0MlIrUHBibUVmMW8rdkk1KzQ5d0NPc1JaSkV1YVRzWmEvNjdnVUg4?=
 =?utf-8?B?QndGSE5nd2kzMFBTWEs4Rnp0WTJRZlZUVnE4dVBsUUI0V3lhVXVZWTRjWjc5?=
 =?utf-8?B?YW5DUEJQclZhdEpobmNkWENSWVgxZCtid0hRWi9XL1p1azdKaWNKMGNFbmJ3?=
 =?utf-8?B?bTZ5S3R4TGgyWEpBUVF3U3JtbGZOQXlIK20vMEkwTFJhc1BmMW5GUTlFTFY5?=
 =?utf-8?B?UW5WWDhzVEdsUTdjdngrOWxuZDVTTStPWE9mVTF6NVpYdzhZekVxbURYY3ZM?=
 =?utf-8?B?MDZRV3lIU01weXd4TjlXV21aVWF2ejlEUkVITVBrZHJxTTZSNkxXeklYZnFW?=
 =?utf-8?B?d3RTbkZWc0hCcFc3Ymdpczd3QUpBSHloTmRUQ09tYksxZysxam1xWHU4YUFm?=
 =?utf-8?B?OWtwMFkzRlpTRktiV3dVN1FEVU9YeGhacmp1elUwZzhSUlNxdkNNaTVYTkY2?=
 =?utf-8?B?VHBaYm9iSUdiM29MaDhBMEVyZHBRSldXQWZLVzFyRlNlVlhLU2hLRy9ZZjJv?=
 =?utf-8?B?L3lNSGtkQ000NEsyS3lGNzZPNXhaYmhjTFRqRDdJTjRubnNQcUV2cTMxZDNG?=
 =?utf-8?B?SEJUWVdRc3pFbnUxaml1R0VRb3N0czhNcng1UnJ5WXV3bnZxQzlIaEZkTkFK?=
 =?utf-8?B?TkdpcC9LSmxwdUlwcUdUSEEwNFl5Y0oxbVp6RWtWWkJuaEtaNnk4K1pvbVdP?=
 =?utf-8?B?VkpxVzhaMjNvd3A3aWszekpuQXMzTFVMSnU2MWZiOWQ5eFFvYnNPYWw2K2hE?=
 =?utf-8?B?dDJCK3g1Sk9mVzlOY2hORXdXdS8zZHQrQzNHOFBNTG9PRTlVd3FIYVhSbjRp?=
 =?utf-8?B?RGxxQnpnMFhGK29xUzRkL0FMVjdNVDhTclJNbnJKMlI4djhBNU0wN0VhNnRu?=
 =?utf-8?B?TWZ2U0xUWm1QcHZNMmNrQ0VNdk5PVVZQREFPU1lWdVVBT01KYlBmT2NQbjR6?=
 =?utf-8?B?L0pDeDNJU3hXQlZkem91VjM4N1FjaWN5bXZPVVJVSDdGZnNmWmU5SEpURGZv?=
 =?utf-8?B?cUF0aFErZkgwQUhMR3lBd1ExU0MvdjJLNnpxSzA2NHZEWE40am55bU1VcGVF?=
 =?utf-8?B?S2h1d1E2cTdOY1BDY240M0lFQUc3dXlGZUR2WndKUGVKM09KM0ZQL0R0bkZC?=
 =?utf-8?B?azFGT3I3SHQyV3UrQTFBY2NDTmVrczFqZGk5WURJS0hTK1JXZ2I0R2dOaTRt?=
 =?utf-8?B?aUNCMnErcy80Vmk4MmNFa2p3QjZkc3M3Q0VyRlFKM3drVk5OZ1JvODZXTzl0?=
 =?utf-8?B?dnhuOVhjME5taldoUUhPQzF4bUdnaExUM3loR0pNVUswcnl5QU5vOGdGU1BF?=
 =?utf-8?Q?8QpyiD4osGmSLr2K13TY3to+HjhbFeTC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2k3eTJPNjhxTThYOHZVZVBuSURLZTRWTWIxNHpzRStNTVA2T3JWQ2pLRGV1?=
 =?utf-8?B?cEFTajFoMElvYWdMWkc0Zy9WRlJoaU9sYWkvZFhsTkVXTUVzZk5UaHJvRE9n?=
 =?utf-8?B?czNoek9zRjl0OSs0ZUM5NlRjek9kVTl3RXVpRXVIU2NRL05aSllINTNWeWwz?=
 =?utf-8?B?eFZVWVV6ejFQMWtWZEF5YzQvVHVFOGJGMFhiWU1NelU4d0ZhODFPZ2NsdXhr?=
 =?utf-8?B?MU5OeHF6OGhhWXc0UW5pUk8rZGZhaFMxQTBjaWY3RE5zWTFBRjdrMjNSVDls?=
 =?utf-8?B?azR0YXdia3lCcHNuU1VCR1N5R1Y4dWl3NTJBU2xaSW5yVFNQdklxbXUrcUxL?=
 =?utf-8?B?ZlBtTkY4UzBHbGxkbEhJaVBTTTcwU0QzZnBMSXB6bFNHN2IyUFkvY0dEVmhI?=
 =?utf-8?B?UmwvNGIrRTFaQkoxT3dtczF1ZXhlZFpCV2VJdEwzdS8wQmVDNmVTWHJNT1NJ?=
 =?utf-8?B?WFh3K2ZNZnRNMWJnTVp0N1Vheng2NVIyeHZkbVp4K2VseTFuRDY3cEQ4VEo4?=
 =?utf-8?B?bnpVc3I2aFZQeW5DZTBYZ3lwb0R3WS9EdWRxczd6WmhiQ0FITk11ZTRyYXJ4?=
 =?utf-8?B?OTk3S1J6UmVZOFc5Z2V5Y1lxbGY0ZjJabzl1OGhIUWw2UFd6bUtZQ3hFejht?=
 =?utf-8?B?dmlCUTN1dUpsSVZFdkNSVTBySWRmQmY1WWtaM09oK2NwT2N4SWtCVnoyUTZD?=
 =?utf-8?B?aHhEYytLNE9QZzFTYVFzb0RiYmxXUlhrN3ZNa2didlFHdCtnb05CdkRUQ2xW?=
 =?utf-8?B?MWliQW9zUjJHeGZhcDBUeXVnR2hZaG1sOEh1NmtSclprdVppK1N2aFY4RTNx?=
 =?utf-8?B?OWg2THVQR29HTjNBY2VHa1Rlcm9NMGpJNWIvcDQ1amNqSy82Y3I2aDhDY0hR?=
 =?utf-8?B?eFZZVDdtZHVMam02RDAyalNBRXgyeXBOWHNOTjlpSEZtbWNsUmtFdlhyMVhU?=
 =?utf-8?B?Sy9WTzRNVmhFQUxaNVpBZGNkTk5oOHN2ZDVaNzk2aVU3R2YzOW1nTmc5VC9l?=
 =?utf-8?B?S3hUV0J0emJQREZTaEhiWjNJUjRnZ0lJb3dOMnlDRzB6cW9LdndIOER4RlVH?=
 =?utf-8?B?YWt6OThDL2ZBVzBRQWZYZ0RkSWYrOWpwZEZDcUdKMUNJd3BJcVdzd1JrcTdL?=
 =?utf-8?B?K1M5L2xHZEhxd3hUK1daTzJmS1ltT0o3Y3liUStMejYyWEZtRUlBS2QyYTNH?=
 =?utf-8?B?UjNJQkYyK1h5MjZOdUVVOWswVWZjN1RjU0dJdElzN2d6WnpnZGFTZVBobFVP?=
 =?utf-8?B?RElnTGVUOGZrMFA5Yjd2MGtRQWwvQXVaOWdHZlI2MS9RQ0xuSVJxZlFLT3RK?=
 =?utf-8?B?SmdYOFZsUllPSC92VWl2N0pxTHJwc294TmFjM0U0SFZHeDBDK0NNSWxETk1R?=
 =?utf-8?B?R0Nib04xNHhPbko1TXY1RlZWa3JJK291Q0YraTVtakwybGoxTG5wVGlZbXh4?=
 =?utf-8?B?aVl0ay81Y3dhVGhDMDk1WkNGbzRkSXBwaXRrZWtzK21RZFo0aFZPVVZDSU9i?=
 =?utf-8?B?dndGVEJJUElPMkc3YzF0Zzhac2ZnYUFFOGhnRk1YNUluRlhBeGxTbmRHMHhW?=
 =?utf-8?B?TW1YRnZEcmR4RnpyWVlkVGFtZ1k4NFRqd1JLK09ZcEI5SllTMHZRSkhYWkt6?=
 =?utf-8?B?dDNCSTczZXFIN29WamhPRUZDbHJrWHZHWHg1NXVRc1JSV3dnbWM4MGxLVmd0?=
 =?utf-8?B?b2p6Tm1DVTBSWjQ4TjhrL0tpdHNJWm56SFdaTEJsaEkwRVI4a0R3a2REcGQ4?=
 =?utf-8?B?NHZTdTQzZGZBVHFaUzducjA1RTVXSkJpUjcwcWFsaVhpZG8vSFRISHZrL3Z1?=
 =?utf-8?B?MUFHRTI3Y0ZmdVNQQVFqeEx5VVB2dk9JWXFRellpd2F6a2s3Nis1NzlqM1ZO?=
 =?utf-8?B?dE5oM0VKdW8vNWlnZEZFakVuRmYrSVN4Z2hTeW8rTG1nVmRESVNnbUVCV21z?=
 =?utf-8?B?NzZ6L0NXQjFWS0gyTUc1ZExuMjJEN2syRWhHSnZTNExsdmFKMXFneWZlSE5K?=
 =?utf-8?B?em0wUCtLVkVnTWRDUm5tdmpWTC9XNmdTT3NjVTIrQmdUZ1pNRFBpUHdCajVE?=
 =?utf-8?B?K01wOSsvdzAzcm1peHVkQTdiK21KNmpFOVBvT05MdlF0SlppcW8rYVlyajBu?=
 =?utf-8?Q?uESZh8URbXddm4s/cZ3rdEEOZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c8d916-87e2-47ff-c74d-08dd4d1b8340
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 17:17:51.7687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7uOzzOfPMUzMCQ1YAz0ZyuF7cuNPYNX2M5a/P3WUF5kFSST8KNLHGN7ZUMMPb/Ob/o132/vGOxigP8XTraWhfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8052
X-OriginatorOrg: intel.com

PiA+IElzbid0IHRoZSBvbmx5IHJlYXNvbiB3ZSdyZSBkb2luZyBhIG5ldyBGYW1pbHkgYmVjYXVz
ZSB3ZSBjYW4gb3V0IG9mDQo+ID4gbW9kdWxlIG51bWJlciBzcGFjZT8gSXQncyBub3QgbWFnaWNh
bGx5IGRpZmZlcmVudCBmcm9tIEZhbTYuDQo+DQo+IFJpZ2h0LiBUaGF0IHdhcyB0aGUgcHJpbWFy
eSBtb3RpdmF0aW9uLg0KPg0KPiBCdXQgdGhlIG5ldyBzY2hlbWUgc2hvdWxkIGFsc28gbWFrZSBh
IGxpdHRsZSBtb3JlIGxvZ2ljYWwgc2Vuc2UuIFRoZQ0KPiBmYW1pbHkgbnVtYmVycyBhcmUgc3Vw
cG9zZWQgdG8gbW92ZSB1cCBhdCBhIHN0ZWFkeSByYXRlIGFuZCBhbHNvDQo+IHNlcGFyYXRlIGRl
c2t0b3AgYW5kIHNlcnZlci4NCg0KTm9wZS4gVGhlcmUgaXNuJ3QgYSBjb21taXRtZW50IHRvIHB1
dCBkZXNrdG9wL3NlcnZlciBpbnRvIGRpZmZlcmVudCBmYW1pbGllcy4NCg0KVGhlcmUncyBhbiB1
cGNvbWluZyBwYXRjaCBmb3IgYSBDUFUgaW4gZmFtaWx5IDE4LCB3aGVuIEkgcG9zdCBpdCBJJ2xs
DQphZGQgYSBiaWcgZmF0IGNvbW1lbnQgdGVsbGluZyBwZW9wbGUgbm90IHRvIGV4dHJhcG9sYXRl
IGZyb20gdHdvDQpkYXRhIHBvaW50cyB3aXRoIG9uZSBDUFUgaW4gZWFjaCBvZiBmYW1pbHkgMTgg
YW5kIDE5Lg0KDQpJdCBkb2Vzbid0IHNlZW0gbGlrZSB0aGVyZSB3b3VsZCBiZSBhbnkgdXNlIGNh
c2UgZm9yIHRoYXQuIEkgZG9uJ3QNCmVudmlzaW9uIGNvZGUgdGhhdCBsb29rcyBsaWtlOg0KDQoJ
aWYgKGZhbWlseSA9PSAxOCkgew0KCQkvLyBtb2Rlcm4gZGVza3RvcC9tb2JpbGUgc3R1ZmYNCgl9
IGVsc2UgaWYgKGZhbWlseSA9PSAxOSkgew0KCQkvLyBtb2Rlcm4gWGVvbiBzdHVmZg0KCX0gZWxz
ZSB7DQoJCS8vIExlZ2FjeQ0KCX0NCg0KSSdtIGZpbmUgd2l0aCBQZXRlcidzIHBhdGNoIHRvIG1v
dmUgRGlhbW9uZCBSYXBpZHMgdXAganVzdCBhZnRlciBHcmFuaXRlIFJhcGlkcy4NClRoYXQgd2ls
bCBoZWxwIG1ha2UgaXQgY2xlYXIgdGhhdCBmYW1pbHkgbnVtYmVycyBhcmUgbm8gbG9uZ2VyIGlt
cG9ydGFudC4gSnVzdA0KYSB3YXkgdG8gZXh0ZW5kIHRoZSAibW9kZWwiIHNwYWNlIGJleW9uZCA4
IGJpdHMuDQoNCj4gT3IgbWF5YmUgd2UnbGwgcmVhbGl6ZSB3ZSBtaXNzIGFsbCB0aGUgZnVuIG9m
IGZhbWlseSA2IGFuZCBqdXN0IHN0YXJ0DQo+IHNob3ZpbmcgZXZlcnl0aGluZyBhcyBtb2RlbHMg
aW4gZmFtaWx5IDE5IHJhbmRvbWx5IGluc3RlYWQuIDspDQoNCkFmdGVyIHRoZSBlYXJseSBtb2Rl
bHMgaW4gZmFtaWx5IDYgd2hlcmUgTGludXggdHJpZWQgdG8gY2hlY2sgcmFuZ2VzIG9mIG1vZGVs
cywNCml0IGJlY2FtZSBjbGVhciB0aGF0IFg4Nl9GRUFUVVJFIGJpdHMgZnJvbSBvdGhlciBDUFVJ
RCBsZWF2ZXMgd2FzIHRoZSByaWdodA0Kd2F5IHRvIGRvIHN1Y2ggY2hlY2tzLiBJdCBzaG91bGRu
J3QgbWF0dGVyIGF0IGFsbCBpZiBuZXcgQ1BVcyBjb21lIG91dCByYW5kb21seQ0KYXNzaWduZWQg
dG8gZGlmZmVyZW50IGZhbWlsaWVzLg0KDQotVG9ueQ0K
