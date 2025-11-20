Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A623B3043D1;
	Thu, 20 Nov 2025 07:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763625378; cv=fail; b=geut9NQ0kiYAqO74Qt/imTpf15p9XHuJXHOvBrYdXg10rF6PJ1MpKjt/0hTgHgQRnTlmDWsR/Wgnm+bw/Dy01ByNWrl8mz/BQ+FtEVsOyPwgChECN9gEAsdE37RAEGy1zWB6Le22pfW7hVjYve0nWOAwMbx8W9Lf1QXqNI5vhWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763625378; c=relaxed/simple;
	bh=V/1cmq6giVD3JNSc1BTk/uyfWQdZhs0vy/t7mz9/E8c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f8ryVmyNTc4OJi/4G/X4CAxki9mBXgXWcUq3r0/OQvpactwlyz8osC4ui3823J3ReS49rc4oEVSOux0p+e75pQMueIPjCH/U6/MFsdjDO5X77XAAGODW/iMylEeX6tgqQxXRvSGJ3r+sJO708RR6DzSOzVnrkxkoCECDp86Olec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDlSmmu8; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDlSmmu8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763625377; x=1795161377;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V/1cmq6giVD3JNSc1BTk/uyfWQdZhs0vy/t7mz9/E8c=;
  b=mDlSmmu8UWyuGg+v/S6i/cSlKCYt4VYeax6NmT1xw1RPyz8EFnMzz+Oi
   YvaUO4D8YWyISUwde+KEkda+Ce7M6km5vsp3JnnDnCDliRp/tWUY+9mNM
   +1ioGWM5JfpjaDm01JAiYKXo6i3fz248krptc+tQw30UEN4mz7NUuqOQw
   YodqJca7fydeJCCk+6cslUtcXU8P72BjSpKf4KeXhoFgSYrTTmjUJtBQx
   QdHGcQyRz3MZlxyS1aHt2wCm50qkR7HL139v3b0wOqKYOidTES34u995G
   33OXmL5l1eS2LK0l71oO5bcQeBof+d9kBCQ1wnWNYvcoo427aFW3ZwIuh
   w==;
X-CSE-ConnectionGUID: kkVuT9XbQAW1CGL8m/hsEA==
X-CSE-MsgGUID: 5WMzeswpScWMqM0TJhaY0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65722736"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65722736"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 23:56:16 -0800
X-CSE-ConnectionGUID: tFyZUrMNSjGIdwgVXdIwRQ==
X-CSE-MsgGUID: jirLshALR8GZf2aACkTDQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="222223559"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 23:56:16 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 23:56:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 23:56:15 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 23:56:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y56RYxV9gxfk/oHIIusWmZsXrdyPdXnwPjhS7Z1c3ZumsyJgy/hQcrfMrjc8yc/IbM/5Xcdowh3AB8G9NfRGXElDkm1rgvqD8OVIGZDjgcOpLnx5Bym3W0NUzeszA6q79Agd+PAcd6CwZ2lgmmbJFlGs3KPYdmWHhid+h3ZBJpibC4eppaDvcNx//yTbv98LdGtpIKrsC/XOKaz7On5b3ObQsANXjL0EkpfrPdWNkZNlk+SSbP2jlZBbt8F/8Cry2swEDAECrhCtEWSjzexHJc93nCemCncC0K/v89G6O5TA9ehaDoMdvKnC489LyMvP3SJ2N+iviJNjeWpS3cQFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/1cmq6giVD3JNSc1BTk/uyfWQdZhs0vy/t7mz9/E8c=;
 b=NRY3858JLwsfLX+zzCNTwX+moFt2y4ut8xvR+pzLcZokRhWIyTVuYD4ZpMpABR7183Qg9R8fYoA19iOf09NhoMf+tcXays+2Nzc64VOaShL68KufACm7ZFF5+5/ceGX/9hVe3rozszIuaOJhUAS1iSKWdEWzMKtbfpPZ4e9LZfkr1zakGrmJc3PzXjlg9oRVC55VkQBRZ7qgum7VO/SsS1m7GE9hB579hQh75s+db3A4KDCpJ36Buix7wbtNlQvg9L8k+pkwDG35ISVwC1Qh5yafr9mMm32qhb3Hxz/1xYc6w9Et1sCLRviULIguCvMUKC+nhPt1PwtVkiCZFvZWTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV4PR11MB9489.namprd11.prod.outlook.com (2603:10b6:408:2e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 07:56:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 07:56:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson <alex@shazbot.org>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>, Sumit Semwal
	<sumit.semwal@linaro.org>, Will Deacon <will@kernel.org>
CC: Krishnakant Jaju <kjaju@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Matt Ochs <mochs@nvidia.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Simona Vetter
	<simona.vetter@ffwll.ch>, "Kasireddy, Vivek" <vivek.kasireddy@intel.com>, "Xu
 Yilun" <yilun.xu@linux.intel.com>
Subject: RE: [PATCH 3/9] iommufd: Do not map/unmap revoked DMABUFs
Thread-Topic: [PATCH 3/9] iommufd: Do not map/unmap revoked DMABUFs
Thread-Index: AQHcUAaOumxVJxabL0GJPezWyk6CZbT7RhdQ
Date: Thu, 20 Nov 2025 07:56:14 +0000
Message-ID: <BN9PR11MB527680CB97D88FA56EC403858CD4A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-af84a3ab44f5+f68-iommufd_buf_jgg@nvidia.com>
 <3-v1-af84a3ab44f5+f68-iommufd_buf_jgg@nvidia.com>
In-Reply-To: <3-v1-af84a3ab44f5+f68-iommufd_buf_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV4PR11MB9489:EE_
x-ms-office365-filtering-correlation-id: 1e59412c-a043-4206-b99f-08de280a471a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?5sRzNsvu9Q6KlBFSdmXs6F193FOe88ph8K0Gn822a5rHO/B1qWgz+vPFHo?=
 =?iso-8859-1?Q?7zthrVo695D811Q8zCjLxKGoka2Q8ivPzURPBo/+9yDa5ohrAFVl2M7H+j?=
 =?iso-8859-1?Q?hQEV+sfTvyIsD+gXpEzrvVwJqKMN1jb7Aal6mMbsowConULW3NrtNZinp6?=
 =?iso-8859-1?Q?Ozx0X7mecaMSnGJ/zW3TRUYUOV5uIoLijyO3ECoM1dp6rIn5XofIoQvzq1?=
 =?iso-8859-1?Q?z4F+/C2M9Jz7u1HkoOnOtw9s9+EkPzYprNLoVpSx7noKRYelrEGWwNMDKx?=
 =?iso-8859-1?Q?9Sgkekzmn6vBNV2OhEMvZuHUkLTt20kBbOEK4LmCv8HNoN/jhdkNxjgEdb?=
 =?iso-8859-1?Q?tkaYVWz3Zn+ozhHnCajVX0WFkqVvPhGMhrLcBskwIKnTEtOV5oLBIW0JEu?=
 =?iso-8859-1?Q?oYgXLcoWycFpKTxwKuP8q3QGW9j7+Otx6K42UXmsrKRMOyz0JbOYpPKNW+?=
 =?iso-8859-1?Q?FZZNofsR8DNj20sOOo2s+Ua23Ae72cjvCgpPONTwaLQMhsxrvbGGk59fqw?=
 =?iso-8859-1?Q?zHCzKfWtSP4LAfwgaXUAY0o2vy7sU51MQwWSr5geyYE7u1qvOaatKVGldb?=
 =?iso-8859-1?Q?NxjG5+qHcye731sJmQeGIygVNbjtnc0ENBlU+jLVze+70Dx4bLbYOQuPhT?=
 =?iso-8859-1?Q?vHn/aw8DoRNJPFjItMrEB48VA7y9345sRnthfXewaa9iRD0152IKjlBSTG?=
 =?iso-8859-1?Q?/XmnHXuhusqMmOAwm1MmZp6M6GZsi/ta8ixphBaYOZ8aRB7dLAlOzOF5DF?=
 =?iso-8859-1?Q?j/n+KYht52XOP2/PYT1kDG4fc08yF4EqlTfgmkMREALZ5QkZzad+6kUI8x?=
 =?iso-8859-1?Q?MBYO1G4LpZK8KtXTBhI72RMFWD1wxeabJblo6LQP7kRqSCCnaXquMSsi4y?=
 =?iso-8859-1?Q?P6KTOoWhTJ/800bySkN6C4GEw2sszcd6UenD5LcWmHipeQTVfmQ5Xbj9eR?=
 =?iso-8859-1?Q?zscBfwH1pHSGKR8bsUTI/FCQHexOEmMOUUpKouWnAUWjhtVy8N9pDW3Zh0?=
 =?iso-8859-1?Q?bya5wsSWaUHYlGcW3xtVUjV9NJ3hYqhiaVJmdk+CHdbhn+cqs7FAdlYrtg?=
 =?iso-8859-1?Q?JCbIgAPq98suDJ2j0wc/CeQweQQIHnbMU+Mr5bQz3/VhfxEQ3G3Yc/M5Co?=
 =?iso-8859-1?Q?gVihDp25ZOHLZG+povr6HVclMkP4SKUGQzMWZEnjBkcM5blAjS+5qdXmxA?=
 =?iso-8859-1?Q?nfiHoE6X7s7zyi4EGic5XI20b1QbnjH+cwykVtINqYXc9TjUg2d6h04g8i?=
 =?iso-8859-1?Q?DQiU60fjhjVT4rPycUw+Y2+6BtcCu3ZrvacmGsUzLRnkNcPJMBdFyQVEOT?=
 =?iso-8859-1?Q?uKArg43viBUPZKjImVvjzJu8RaCRuBPnDO/QyEcNFZYUx1dMm3PDTxk0g5?=
 =?iso-8859-1?Q?wcYD3+2r9T5QnEOzlTLpImN7SczTFACDGWdxIdNeU4oknRR7zVHRDQU7JM?=
 =?iso-8859-1?Q?sBAgLocv1vx68hjbjh04h1DxAaA86YLU0hzFNOOFivUdUtkHBGkaJKeLkK?=
 =?iso-8859-1?Q?Y1MQxMGcuYjrirFu28ScNItAsJhe5/pSAMVVlrIalGmEBYQJJPQi7Pf8ir?=
 =?iso-8859-1?Q?gcsWTOI02NFFmcQysqmsQH4HKXEwxvtsarqk62RvUoPssoECgg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?s/YNN5IUWI47x/jKgF7i7mFDsRSG/mOisBFgSWx0ByLfpWchHPYK0QdHcL?=
 =?iso-8859-1?Q?qBqqndVir62iU3GizYz3+n7mO90FWmNp1v+R5iM4HVYiaQ67NJBX2SZWNR?=
 =?iso-8859-1?Q?NQ8jfMcPHqGppqYMgMBLl4tINHXocGpVMCBCUwzpdLN4yQGO6liUnTOf9W?=
 =?iso-8859-1?Q?kkX/r7hoEwR4xQa2gwI5MigpYOqgbfq7vZg9hlhb3x/X3AbW/qWGIK9Boo?=
 =?iso-8859-1?Q?e7cJc7jlsM1AwO1TW9eSS4PF+I0eOoXKsdqdUcwUpmDRMB698WHt/QfHYw?=
 =?iso-8859-1?Q?h0fDywtcjyU+Z9MfNbD/VHsZpvSgG2QihzBMugUUn09qxr5xOoNUBZ/ZDW?=
 =?iso-8859-1?Q?cSwOZ4E579ceuk54CWIKx5EiSwvDeVeYuVOPoAVwOT8DkPgwqP00u71h/J?=
 =?iso-8859-1?Q?tJspG6SwsGLuaKOraQ+83MjfNQadU1baHgpzyxeM/IDQgEx7WIkzOerT/q?=
 =?iso-8859-1?Q?OaMxUS/afmUE03tC8eoWmOzbjJkZgbiEDRuVbXmGNQkGLb7zgYrQRbj5i6?=
 =?iso-8859-1?Q?CizRayV0EflVub18BF4f5wkd6x5WFQcaQrQWABB2027yrlh+Iy2C65lpsX?=
 =?iso-8859-1?Q?E2BWyfEhxmJnuj4SbtuZT32hXnO9GowbVdJO5pSskhhNEEp0KPskrUNbNE?=
 =?iso-8859-1?Q?KRRumoNk2cEDH8J+7rRstNql/NbV5pwdRHgoXXYiw72t0crRqplimz7Wmo?=
 =?iso-8859-1?Q?RVs1eNLf/2ZkJ4zfCVhnhAg4tHxEqinzyJ+HNdf2sYWZSbFIGQHYrvl+s/?=
 =?iso-8859-1?Q?WUT0NKpks5/OdQoZ+13SGKOZkeks9hEYCOpnTimWR2MJGDPZccrA5ZIgFq?=
 =?iso-8859-1?Q?nVuxVppLeUSWlpszN4iUEMahZdic3I1YnKXnfYVMOWXqZ2LGScRJjyZ5Xa?=
 =?iso-8859-1?Q?kWVjSJt0v1N+s+uhh3qBKaGGOPMd2T674FlEPgT0UCneNs3WJztoodsnkC?=
 =?iso-8859-1?Q?f3fKdyV02/TUzVwy5aM3LWAFHxMtr+0TWWcjBOt2s145JGvnCWehzlxCwO?=
 =?iso-8859-1?Q?xouXQArRLM6bxa7qqAT8cBczTlk/LDKgQLcRTTiEPGlk6sThRunJctU5Kx?=
 =?iso-8859-1?Q?VrC3eP8b17w7CUyISVXA1E+1KSiAxHRdtjyOQ1NfA+bSFS0pXudLRdLqBe?=
 =?iso-8859-1?Q?urJRk5QU4m63zMJVpWNnIRq3a3uCVCXtk3ihl4ajpN73od8sQ87muQ9sRK?=
 =?iso-8859-1?Q?XVfd+41XwRokCKOFL86I+town2VUWXxXPVijwHNsgZThakgsLN/YMN+8av?=
 =?iso-8859-1?Q?FW7oopO8sm0tsyGh3cunIi6BlbKFvYVHSn6gQb1GA083vExrkRS3vzgubY?=
 =?iso-8859-1?Q?yjttbBfEKTextfw3eEU0la0wshyhYOXHJvcrjJkPuIjon5O2wsqj9RPhTt?=
 =?iso-8859-1?Q?EQPQTJPGtYlFWGTf0OGdTIaskr6EgIwfBCup7d87lrf7YojW5HqR3IC5bK?=
 =?iso-8859-1?Q?QQk2M32qPTtfMhM9aUyImm/gLWKERf3u+0z2sii09UMTrEwhP3RaKL0g44?=
 =?iso-8859-1?Q?h48UCtJphudS6R0ArIF7Eexwnkhx76w8dIJIOO1CT2RQLmStZZHa9w0aQj?=
 =?iso-8859-1?Q?NQfQ8UK8u6esSTKFD/dTr3IeUH4jbEHCLjGswTVX0dGMkeu1ZJ9MalK1K8?=
 =?iso-8859-1?Q?Xz+NiZxelhV6cXk0RxGW9iAiBRzZWIGfQn?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e59412c-a043-4206-b99f-08de280a471a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2025 07:56:14.0295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J34FjUlt9969pB8/Fg1ydjzu96DMiosBb+eZ5cr0JPfsYF+E6TRg6ncC3XhJTUoCoKylLG5dQu22kZBFyzZuow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR11MB9489
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, November 8, 2025 12:50 AM
>=20
> Once a DMABUF is revoked the domain will be unmapped under the pages
> mutex. Double unmapping will trigger a WARN, and mapping while revoked
> will fail.
>=20
> Check for revoked DMABUFs along all the map and unmap paths to resolve
> this. Ensure that map/unmap is always done under the pages mutex so it is
> synchronized with the revoke notifier.
>=20
> If a revoke happens between allocating the iopt_pages and the population
> to a domain then the population will succeed, and leave things unmapped a=
s
> though revoke had happened immediately after.
>=20
> Currently there is no way to repopulate the domains. Userspace is expecte=
d
> to know if it is going to do something that would trigger revoke (eg if i=
t
> is about to do a FLR) then it should go and remove the DMABUF mappings
> before and put the back after. The revoke is only to protect the kernel
> from mis-behaving userspace.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
