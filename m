Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F930E0F5;
	Tue, 14 Oct 2025 07:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428323; cv=fail; b=qFZowvEwyVSM4JCck68ijZK2Jla4QOqGGiz+QfhBvFckaitOdEVjDxVm1T53aksHPWuNca8qoHmnyCAQH76j7VvrJ5fHOIBRE7zfN5QgRR137xSRprqYDvr5KA7Zss2V0kXFgzgJBc6XCgDu4WCDOfCIaEm96WtS5ftMke53ZYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428323; c=relaxed/simple;
	bh=dkq9wm7reBIcxnBel01KOQsdfM54so9KRQ9qT84T45I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=apyk3AnFD0PW0jYgYN7AqbfleJXpnFLBynJxqpaBmfBwekWPvrCDY0jKbJpJ8R7qbu9GsYq6rO4XpfjcPQnHT4uFxAHA9ETn6knycDfiZneKQ+O5moAyUW5Fb5RIABMJc3yu+yuJwqUfInRVCWSdFQawAxB0nKzg5c1/FS5Szio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ni6Vv1/y; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ni6Vv1/y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760428323; x=1791964323;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dkq9wm7reBIcxnBel01KOQsdfM54so9KRQ9qT84T45I=;
  b=Ni6Vv1/yg/qC8xuq4z3pIFhy1T/rzLIBdeSl2kNWmDkU2bp9Zgn75STa
   JmyAnSFq39hw5e80+h8FyIFhmse0dIppgMiGo90PEpfpFyO+4lgVF3j3q
   qxsKXLX7ILOGk9epxw7hHyMVKHVtJK3jmC6EiMypcQmVBAeBi+LGQLxT3
   iCWc131FrsJdLcm8U9OWHmLEp9SGGs14tx1olnBKDAQmXKccTTbK0Fc08
   2UtgSOrRbaWxvnLGjcHOTBsEoHwiJoaF88xX5fpXF9O/ZCfG7a+lGezjp
   rTD4CCY90h6gXYUCsWYh31+y8dSdvV/QREX6hyWtIY3yoxzap88Ib6uvw
   w==;
X-CSE-ConnectionGUID: ILJj7uOBTA6bc12o8Cqp/g==
X-CSE-MsgGUID: Sqj/19EwS8euXMW7hLKA/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="66236039"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="66236039"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:52:01 -0700
X-CSE-ConnectionGUID: hXBZcIgARiiF0AyUPWsFfA==
X-CSE-MsgGUID: 34fI5e8JSgmBT/hbV3L4cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="181494912"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:52:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:52:00 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 00:52:00 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 00:51:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I47gumdpBOsQW5pegVDLGEYtJMnIWgJHA+a6X5Wsow7nFMfB+7RIccWuaVH63GjLEHDFig12rzQfQhkdlxqqx5BRa9eoVo6QGr1UeizRnCWL6yYzQcflHd4Qv6/IPbwLeTXcI4WxzCLxo3g7xBRK6DIxBdolNhMwEWIS40DPpkMquagVWidye6zZfaiWvRCHdoVeaVEVobfdnjra3RBs31yMvSUHNdSUUU3aPhhLxDnKtYaf7cZBmeg4jP7HZuV8uYgwLP+yGSewWF4FXToIgpDwttiqVXedbGyo2946dlan7MoxwRHwz8YtWwpMTFrH26U7DK6dL8BBUoCYSyS/Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkq9wm7reBIcxnBel01KOQsdfM54so9KRQ9qT84T45I=;
 b=gs1VgRF8rSn7+dq6Y56W4fEJohiZxzPMqk2X262+T4blLWpcX3/4cVvAmhgZmOorlXZJhydDp8bLuOIezDEwcAEbvfZXT5VnEo1l2XQOMfU2fTM2dz6sK/E43VcgZkVquAxIZSYw071NO+AfveTEiLXLnZ1xyEAJTj0GvdhJfIqw6B67IB8quZSquwhYeH+UQtqJFL9opawWxCAssjIL2SHYhxVXWXvZ/EVELRpS8v7BqMLHPvQ/muOB9s3jiz2WvIsWJSOeo6r0V4n/aC4XuUuVwvvnQppGvupGM3frYrWg1emXfQrST/K9fKzRMnz6n1K3/M4GFMyZIriS16ue+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS4PPF8ECAFAD61.namprd11.prod.outlook.com (2603:10b6:f:fc02::3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 14 Oct
 2025 07:51:58 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 07:51:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: RE: [PATCH v2 03/10] iommupt: Use the incoherent start/stop functions
 for PT_FEAT_DMA_INCOHERENT
Thread-Topic: [PATCH v2 03/10] iommupt: Use the incoherent start/stop
 functions for PT_FEAT_DMA_INCOHERENT
Thread-Index: AQHcFq6mEx6jU84O3Ui3IU96SDX0rbTBj8kQ
Date: Tue, 14 Oct 2025 07:51:58 +0000
Message-ID: <BL1PR11MB5271D3D720A50EDFAEE52CE38CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <3-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <3-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS4PPF8ECAFAD61:EE_
x-ms-office365-filtering-correlation-id: 5518b588-2e33-427a-42f5-08de0af68d65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QmpRSjZSVmpOeUY1aDBkQWFXYktkaEZlVWFpdkMzWENJZEZML2pFWTlYVTN2?=
 =?utf-8?B?MXN6Umd2Mkg5cjZOZWp5SE0rZnp6dVErblJnbVl2VUpkdXZ0YklDN3lqYVVT?=
 =?utf-8?B?SUJJajFrRVZRQWthcW42YTNGWHQ1elg2VS8xZGE4VlNJc1dodndFdHkyVGk5?=
 =?utf-8?B?ZGx2eDhGVVdGV29uYjY0Q0gwS3Z0N08yYVQrcjc5MW1keXYreTdGZytTY1E1?=
 =?utf-8?B?cGVodk9MNHd2WmpxQ1Vnd2ZoNFQzZzNCcjI3QjJWWGdISFNGcERjN1RLVXpY?=
 =?utf-8?B?c3dSR2tibEZqaFdQNXFmUEh5ZnFCZHhvR1QyQzh4SVRjcktucStjNTkzaHJQ?=
 =?utf-8?B?RTRuSXdPYXNZWHZqNEdhbWVqdFlxd29jN1lacjNkN1dxb0hSQTllTFkwYmNB?=
 =?utf-8?B?L2FZVGsyblJvZ2IydnhodFJTNnIyMDE0dHVVaWlTckJwR0p4VGNzVThlYXVi?=
 =?utf-8?B?cS91RnE0R1ozV24xeWtjaGJXUTlYYS9rMVpLSEhiVCtqdlVzVVJ6Vks2Unpz?=
 =?utf-8?B?VURkVVlEcDJoU0g2VDZyVjIzb243WHBHSlV2aXJCRXVlK0xGdGIyWHlXd3ds?=
 =?utf-8?B?dlBkdExEa0NFT1JTK3h1Y3BYOEVpTURMMmxIVzRFblNsUkpwaEJrSkRBeHlW?=
 =?utf-8?B?UnpjZy9mZitLaE9Na3NsZjZjdE94ZHhJNmJvOEJoVmhrcjNzMENpTjNBMUJQ?=
 =?utf-8?B?dFN1N0MrcitTTC9Ddms1UEo0OVZGWjJITFp5ckhqVFpCSFdxalBSTEFLTHYr?=
 =?utf-8?B?QVdHMG0zZkU4VG1lZnNjbFN2TTIxekRjdzJabU54bDFINVc5NWdXajlEbnkw?=
 =?utf-8?B?VzBxOVB5cmZMSHRTMHc2clJpWDJhc0pwZGVmOGRwL0djMURDLytTaklKUTd4?=
 =?utf-8?B?V0s1ZGFpQUZJVkM1MHJjZmlxY1V5cGpISUw2UzF3OTlGMERaRkNsZFpnSk1S?=
 =?utf-8?B?ZmtHa1lSaGwyMzNsZy9Ea3Fwc3pHY3RWT1Z5aCtvbkh6VHJSSVZpSkNxbVhy?=
 =?utf-8?B?bnp0dDFNR3N4TG0zbjZUZGcrRDdCMjAzMlZWUVpBdVFqNm1PT0RsdkNpS2x6?=
 =?utf-8?B?WThQMldtdHZ5elF2U042S2JUMkcrRTBKM3RzTXVKL2crbk9VT0dFaGV1Q2hr?=
 =?utf-8?B?b3ErRmxtTlE5V2N0SVo0WEJmOTRJSVhFRWNQWkFVQWROUkE1VVVQKytiS3Bm?=
 =?utf-8?B?NFpZRjZBWm9VL2oveWRUNUVHOUtSS0N2ZGlHQzdLUmZ0M0dwMGFBU2hCT3hG?=
 =?utf-8?B?UktUR1pvZnpjWGp3QldWeFY4WWt2QUNoNmtkTk5sUGRFSGVZMmVOckN2WTA1?=
 =?utf-8?B?VjZIVitqZC9nd2xPa3dLd2MzUjdvRjVJT0VGSVM0cVN4bTh0d0FnWGpzMlgy?=
 =?utf-8?B?ZC9iQW80YWJYU1lHR1FPZzUyVkpnVlJUY3VOR0lqd1dxM2hBQUx0SWRzLzVw?=
 =?utf-8?B?OEJSeXVnak16ODRldkV2dGRPY294N1VrcG9HVWNyYTQ4U3c1RGlxZnhnbWly?=
 =?utf-8?B?S0dzUHJ3Z1lkWTVXTG9oMk1sRjFZTExuZlFISEFCUytucnZHWjMxbDJOcm4w?=
 =?utf-8?B?NG52cDE0MXp4UGRqVjF3U1ZJS3FzZWZST3Bxa1hxbXJXU1hZLzBpblM3Y2RI?=
 =?utf-8?B?UTF6a1kwSFp1d3I4RFJoK01RbmlFeHY4SkgvcURBWGRLbDZ4R2V6Qm9CTWUz?=
 =?utf-8?B?cmhiNmcrUnI0VlBLdit6VHNsQmlPbjBhZndMZThHWkt6QWpwVERrM1ZzQ2M3?=
 =?utf-8?B?NC85cXliT0QrVURPNWdwWU1NS3dpczBjb05adGtjK3RZQ25FcExVRFNlaGNV?=
 =?utf-8?B?b1lTQ1AyUkdtcUsyNWZvSjV6b2Z0OW1PUVppMG9GVm9TSjRuTlpGQ21HZEF3?=
 =?utf-8?B?bUxVWUdIenZpeVo2RTV3TkVvWTAvaDMrNktUM2cyZnkzc2NWb2pLaHI2ano1?=
 =?utf-8?B?WFpBTkZjTWhVODRKL1Q5NnZJRkJjKzdBS2JmTGhuekVWQUJEcEdxUFB6blAv?=
 =?utf-8?B?WCtBbmZnWUlQZzN3ekw5T0VhbmUxSW9RVTVOTjNkaXRGS2FBOVRwZXdhZGsv?=
 =?utf-8?Q?tKcGA7?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0orY0pKQlgyblRVRzJCNTZMdGpjbFhhQnk1TEk4TzRvWG93d29BNlRrdXZT?=
 =?utf-8?B?Wk0xYWNvQ1V3KzZyOTVVRXFBVElCT21paGRwWjV1c1o4MGxITkJBQllNZ1RD?=
 =?utf-8?B?TUdPWFJ1ekNkWGtVdzFWRHhVV3FRWVdLQ1dheEhIc2ZUOXFpRlhZeHJ1OVhL?=
 =?utf-8?B?ejNwcWhyMW5GM0UxWHhUaE4ycDFhUzFRalZ0WHFldjJrb3F4Y3pKWTZSb2dZ?=
 =?utf-8?B?Z2ZoODkwTkZLTUJMTUd3QXB3TnBTY1hFUFZKa3pvaEN3TWNpK1hqZDhoeHlo?=
 =?utf-8?B?WW9CMElPRWJqQnRkWFl0MHhwS01kYnVZTktLc1VUSVQrcU4rVGRoS0JuOWM2?=
 =?utf-8?B?NFpZSjZidHJxWllJeXZaMUVSUlNCRXgxVnFBNE12WmovL1dodDZTUXJaU1RH?=
 =?utf-8?B?eW43M25sSUIvRFNyOHR2aWNnbk5WM042UXlPVFgvWENleDQrSDlKeDdQRkYz?=
 =?utf-8?B?NXRscFpYTVRLWnhzVGFrdkxnWi8rMGFqbVNLdUhyUXNXelRhc1hUR25pNjd0?=
 =?utf-8?B?eWZJQ2xGeThiNFlTb3UxZkNvSTVnU0Z6amtWVTJHTVFQZHFvalZYM2NmZE9p?=
 =?utf-8?B?emdVUjFYZXpZbFBIMXpTeHZ0d2R5MnFFbzNIUU5rdHkrbnMyQXJINVN1Q3dQ?=
 =?utf-8?B?OElYdEFCNWFidXEwQ0FWQWhwWUxMRThuNUpsKzhDVTlkRkVnNDB0NlhaY1Nj?=
 =?utf-8?B?VzF3Z3dvbGRweEFGUUsvSW10ODRMMGNJVy94dDBMQ2QzSTROWEEya1RIYk5K?=
 =?utf-8?B?aEZqR1ZpSUkwenFMTHFHWk1OU1N3QjBNZ1F4b3I3V0xQTE9OVm1vYlRSdEVs?=
 =?utf-8?B?TGtNRXMzZEovL2NXWHEwdGUvN1NGZFBxaU5WcGlQMDc0VXR5ZlI3cEVkOC9v?=
 =?utf-8?B?bkpVc0Y4UmpCY0ZoWlA5VEYyR0owdVk5WEVFcE5WbmM0bjM3SEZJQWRGczcw?=
 =?utf-8?B?aVducjhEVUY5K29jY3BIdCtLMEdxcTNhYkd1YXZKOCtMNGRJV0V6MU4xUWtn?=
 =?utf-8?B?dVFtUWgxbWJuYkZoY3h6S25DeDVlZ2VhNUh2aDRiWm1tbjJNVWVrdm56TjZy?=
 =?utf-8?B?THYxSGcrYjVlSWdOZklBMS9GRUo3cG80dk14Lzhrc2tURXY0NDZXb0lucjVV?=
 =?utf-8?B?TnVUQzJXY2tqNGl6OUJvZ0hsQVJQcCsxZXNwUXcycTJiSlYrSlZyK3hhQTkv?=
 =?utf-8?B?TDVDRXlqYVFMc2lYNzk5ck5BRnR0WUNEL25hbWNNcnRVKzAzdDRoaDM4WnZl?=
 =?utf-8?B?a1RIYkFHRjgrVXBNb0w1WlFoZS9PZzVsV01zRktyYlBtVUZ6WVNMbXE1TWJv?=
 =?utf-8?B?ZCtLaXk0OTAxQkVCaEE1TElaMnJHT0l5dDFUOEl6MGNrNzh1c0xvQ1dhS2Ji?=
 =?utf-8?B?RDN0Nm9Sb0xadjlQYWYwTEI0Z2JzVEpBbU9PWkk4NzdYK21nUlE1T1lpMzFa?=
 =?utf-8?B?Y0NHdWl2LzBmbDhIMDVIUFVFcVUydkRrVHI2d2lqV08xTnhmZDAyWlVHa3BM?=
 =?utf-8?B?dzlobXRrMis4TzkrUWFnU1E2c0oycWlNa0ZwNm5TenphNjN3QVhtTFlicjRt?=
 =?utf-8?B?dlRHYkNpRjdUcjNZQmVqbVc2T2I5Y2xPaVZzaFNjV085RC9tVG4yR0pyQTl5?=
 =?utf-8?B?Qm1vSEI0RHM2dHVJSjBCVmxBTm9wb0IvNTk0MWROSjloNXVCempwa0pyWGtt?=
 =?utf-8?B?TStPUThqR1JOUDNzaWw3aUovclVGaHpNaUI1YXdyME9GcW5pMFkwbjhHbmNn?=
 =?utf-8?B?T3o1RXJNL0ZyS2RFaTJvQ2ZES3lYUnZhZFRJWnpvMnloN2ZXZm4vUENXMEs2?=
 =?utf-8?B?Z2I4RjN5T3pHU0YxU0pXQ2VZNHlGdGE1VXJsVXdxUjRqVzhIb0lMNzJBZzEv?=
 =?utf-8?B?UVJ6Sm9OVWlaaVVxTGR1NEhiMFVHazVTU3VDN0dqYS9DdmsxWk5xU09YNkhC?=
 =?utf-8?B?T2VrL1dlUUNjMlR0c1Y5N09xNVpSNURoZkZ6OFZ2ckwrNFRvZEQxci9ndEVV?=
 =?utf-8?B?N1loZm1XeXFyRDg0azRMWWJTckVWMFdISG1nVmRUMTlocFZQcmNvaVFadkJD?=
 =?utf-8?B?bGRsK2ZVSFF4d0xLYjgxMHFqdjBHc1FDWVNvaHJSNDdEM2hCKytMaWYxdTlO?=
 =?utf-8?Q?YxRhXbVuSDyOBuQsislfthRB0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5518b588-2e33-427a-42f5-08de0af68d65
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:51:58.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CxkEI9DBGGaKkd1EvufzgSiYUC/fFDU3MDQRtTTyv8oqpbBMwVxJkZJmo9nSETxrCt/VWjg3YFm1NVNPrJHKNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8ECAFAD61
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEF1Z3VzdCAyNywgMjAyNSAxOjI2IEFNDQo+DQo+ICtlbnVtIGFsbG9jX21vZGUge0FMTE9D
X05PUk1BTCwgQUxMT0NfS0VFUF9JTkNPSEVSRU5UfTsNCg0KSXMgaXQgY2xlYXJlciB0byBjYWxs
IGl0IEFMTE9DX0RFRkVSX0ZMVVNIPyBJIGNhbiBzZWUgd2hhdCBLRUVQX0lOQ09IRVJFTlQNCm1l
YW5zLCBidXQgb25seSBhZnRlciBzb21lIHRoaW5raW5nLiDwn5iKDQoNCj4gQEAgLTU1LDYgKzU1
LDkgQEAgZW51bSB7DQo+ICAJUFRfT1JJR19TVVBQT1JURURfRkVBVFVSRVMgPSBQVF9TVVBQT1JU
RURfRkVBVFVSRVMsDQo+ICAJUFRfREVCVUdfU1VQUE9SVEVEX0ZFQVRVUkVTID0NCj4gIAkJVUlO
VF9NQVggJg0KPiArCQl+KChQVF9PUklHX1NVUFBPUlRFRF9GRUFUVVJFUyAmDQo+IEJJVChQVF9G
RUFUX0RNQV9JTkNPSEVSRU5UKSA/DQo+ICsJCQkgICAwIDoNCj4gKwkJCSAgIEJJVChQVF9GRUFU
X0RNQV9JTkNPSEVSRU5UKSkpICYNCg0KYWxzbyB1cGRhdGUgdGhlIGNvbW1lbnQgdGhhdCBETUFf
SU5DT0hFUkVOVCBjYW4gYmUgZW5hYmxlZCBpbg0KZGVidWcgbW9kZSBvbmx5IGlmIHRoZSBmbXQg
c3VwcG9ydHMgaXQuDQoNClJldmlld2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVs
LmNvbT4NCg==
