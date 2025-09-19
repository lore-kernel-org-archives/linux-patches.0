Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC142C028E;
	Fri, 19 Sep 2025 08:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269599; cv=fail; b=h4rQDWWEBdXWysUWHg/0EYB0jFJWPd/ZMAlygKddkvhwDWGGUoyE8s7Oaxj6YBI6LPZTl3Emf8ujlk20qmF+mp/fUtde+IUAvLTLtduTojOG/tiwSgpQbIa5W2KHQo62oMEP7w2dqeqdrS1+Z+xEBZsP2BbxZXDj7OnenQpaYko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269599; c=relaxed/simple;
	bh=0DJiGQN5UF43IlrXxzHih4dyvKkk4hJhlTYi++4UIyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rHGqfwHxZUrE/5MA3zzrM5MvYK6d+6MrciXSwpdDkgYXQ5z6X0ONduAEIkgSa3PCcalPnF9HY1H13MsAnEbMveYVlqkBtl52n3At+6A5UTz5W7S4bmXSZlmOvWZ3LfpblLE89pDWyv8cTkX8cQ4u5IhmKJYC8v3WCNv3/Dx4eqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PyrGPl0B; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PyrGPl0B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758269598; x=1789805598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0DJiGQN5UF43IlrXxzHih4dyvKkk4hJhlTYi++4UIyI=;
  b=PyrGPl0BIMCZZiYw6DG9XsRSjtB3t/8s4CUYIQQmnM7Gyj2ZJ6LQzDwz
   Dy14lgz4mIp+bVOHEGqZ0tAnIW4SgpzSjLZ/mF0zl1pZShgk8e5/BR40R
   RQ7v9BFPKxyML/ARTk+3YENwd+2RKGVxfNptuu8/b3oCQNEQPc7iHUu3R
   tc7OAn9JggOh3SpVCMdSfMHjwSNABiT51bKsXVdnuMZTH9iWoPkeuI7JW
   wOmunz6CKLnP9wRngbApHn4vay/iPuc5utRup7/Cis7IdgwNvjl1At1yE
   PUckfZ0HmxwoVLFAUHhUO1wbOv5oWnD4VocKdGSxqzzzll7pcdds1OaRV
   Q==;
X-CSE-ConnectionGUID: pPLTJVJ3TjuIGmBGHFzs9w==
X-CSE-MsgGUID: 5cqx/DNUQV2WngFQdFZ3Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60676443"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="60676443"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 01:13:18 -0700
X-CSE-ConnectionGUID: 7CbLtvuNQEeKbELuMK9qiQ==
X-CSE-MsgGUID: qV/zN4ZET/O99KPlXIsFyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="176217405"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 01:13:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 01:13:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 01:13:16 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 01:13:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2gpkcGIeXfqA+sZFicQmSCvWVcLPOo5heza7AlAzg2cWbuKv3dfActsuD+jV2dV2daU3tJEJ+GruL5VAtJEFYQb/opuJISUnRHFfT/lFyuk/Wp6c/C2cTbFYP7bqzYJHe1R1DRjpNEYZyrQXpI0NpKJt5VwXZTeQYYwUaPBfcAEyFAB2Hw3usT1i4UL8iYHeODX4RUK8rGxsk2I1diGJ0ml1bW8hNgTnQ5RaFDPchW46M2+mZS7CWv4/Lskq3i3KCfM8rFLv7j/NnGZHLAnE29unUFI8m2dW57Z7FHsih3PNSC0Vqf6liQOpIlAZVsLEPWYHMEZx4AKQK2sM+/+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DJiGQN5UF43IlrXxzHih4dyvKkk4hJhlTYi++4UIyI=;
 b=NzMczvqOzkJe7EC3vRDekkhGLiebykgcCaVBxv0Lin4aUNEsJ+spKgfNgm+x0loIN4SewUD63f15Hq4v2Pw64+W4s3JsT/Dt59CkIDcDKSjLRXXaGSULefZcXtELWnwR7Rpk94my2MKs/+DkuUos4KJMsZ99qJ5lp9+V7etKyvRzpySZcbdla3rPz2ThnhQznBHHWSvxZAhznOKzEENfGoEUZvSjlnzN3RTL67SRa0EXdWo6OjVwuEbtCRAhDDGvQamXk0jYqHMdYMt5QV48gC9iuFPD9SVpFUOsCp4vrQFu3Dy4f5Srdh54+vM2WjIGe7mkMRdTVDDJZic7oKGgGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5256.namprd11.prod.outlook.com (2603:10b6:208:30a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Fri, 19 Sep
 2025 08:13:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 08:13:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Pranjal Shrivastava
	<praan@google.com>
Subject: RE: [PATCH] iommufd: Fix refcounting race during mmap
Thread-Topic: [PATCH] iommufd: Fix refcounting race during mmap
Thread-Index: AQHcJyRtdcRTvtxITUKenYvTJKOSJrSaLByw
Date: Fri, 19 Sep 2025 08:13:14 +0000
Message-ID: <BN9PR11MB527677DBA4A1504CBB7BBDE08C11A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
In-Reply-To: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5256:EE_
x-ms-office365-filtering-correlation-id: 3da1e661-c77e-48f6-4c53-08ddf75461ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?emwrVeN3XTatKm62EGHtyXWMTwRQooumBP2z5rRViIdfSBWqMWWjUZ7tAi3S?=
 =?us-ascii?Q?CV7fEXnemTZXiuWloWMbmkIRMFUQ7xS6PfFCJmWNaRDypL/wkkRcAtkWVbHR?=
 =?us-ascii?Q?enOZi+FTfBg2osokpxBhU9C0rKb4C0ct6QOAlwthfJNIfBB/mQdfWrE7BWYn?=
 =?us-ascii?Q?X5NMn2HOvr9+9tOlrTiwCP5dvCMGLY3hkAT8DZJkvFchEHZbG2JWrMpFaW65?=
 =?us-ascii?Q?UQamEY6AWWYt+78TiA1L4WVtgORbfIraXFGCWfIRrH/AFOL+NN/wHndIiq8F?=
 =?us-ascii?Q?KOjwanur87T3OSnCNL06g48/NHC0Ax+EKUDnJMqVPwLgE+ilcCPZbNGfy6bu?=
 =?us-ascii?Q?kQeh+kHtWQXYIJ1SwcC8pm5ZsK7zbMI2uy/+bWSWP6UfqCg5Do8Izga0FrPq?=
 =?us-ascii?Q?zYkxCk1HChcqmgLInr8uRwIZNawcNJJy0o5aqYk33iEhLxqiLCvee4BtCLyF?=
 =?us-ascii?Q?Dyi5uHZaB8XkfWsKgP1Tu2sxKYdFF2O1A4K7yjpekXJiv5MKe22G2M1diBn2?=
 =?us-ascii?Q?nJhlX0EJcMLMAnWPcMjKvFmnsrRTpI6VRmdZWbn3woLjl0gVPxFxVbDS9i5n?=
 =?us-ascii?Q?0CYYtZTO+ndHhKcobcEGlxG3z6MsmdcsCgrf5Bt9iNGsYT0xqDpz1dSREi9r?=
 =?us-ascii?Q?IJN7v8qoq0j3BxdhMUlctveoO9yQk47Lk0Wz8f66Z1DXJzR5rAsEpaWxPmH9?=
 =?us-ascii?Q?FvRXG10Iyiui6q3JAhX5BDO6ihXeolY70vDhC+0KCLTiVpGbIE9ia5xR8Cly?=
 =?us-ascii?Q?KEvl8WphFgNdl3QPs4gZOMX8q22Dgtz873vVFUbWSh+Mc9OJkLsIuZwCUJbu?=
 =?us-ascii?Q?CU3t0AFqHoK1FRlUdAXV+S3/etfICbNt7XRqhMEmSGeKOLv/G0JNHBZHcZ62?=
 =?us-ascii?Q?K0yu7hz7CCDG/71OXUVRFKc+zgZq0FC6bL224CHjMseP/VoSNVXlVpliHAPr?=
 =?us-ascii?Q?oZEtjuoIKRGwrIZ8VQz+T2+HIcMHz07Orynwj5XeP8OjsqRtYYX3Ru44PZIs?=
 =?us-ascii?Q?EOp3jJiKDWKzZ7IFCv1O6732EkHSngmni+uQYzZeytCJqKBUN7rjlQM8upW5?=
 =?us-ascii?Q?4X0YrH7V2Dp+cQpkeN6c+3pjyZ/ivZa3ZHwtDk7zHP2+mXvhnY3wZm6H6Dc0?=
 =?us-ascii?Q?FpIuS0g1yI8K2AFkYbqI4XDGDCwYC0SbKmFFIQrwVaBi8f6W5Eyv5MyVTmYF?=
 =?us-ascii?Q?QOPNQM3HtzEhvfl7OwlPXQcaBqI1Aeu3GGd1Jb89dNwg2U9Wl0sm4GvVhjw3?=
 =?us-ascii?Q?949sBJCnwAtS1B4M5mHYqEvnVef6cees7ZKh9e0f1cIotE3o2dX/u5tumJaZ?=
 =?us-ascii?Q?N3CHhtWS6jTVDbr10c8JGGeNn2xKjZYjR6HC1NGUEJvMLkaIZLszVD1luoDp?=
 =?us-ascii?Q?DeUaqmTseuxRUOGOINgCVH5sOh3YY4Pouyuu0sPZSRG6cnD+usxiNHNs90CH?=
 =?us-ascii?Q?jy1BftwZW+Gwj1ii7ie1gLZJcns8PPqBC98xEC/viYtl3PoBXPG+Sg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?89KbKe9RY80k1MXCo3FaXAUW2XeaM5VLB3WTDzDuhpYSJmsaztuROuxRAUg/?=
 =?us-ascii?Q?lDFk45kJ7Pdn+7hkqbDOw9ujFEb3wJwLQJjGcbqglXIwH+cU3YQB3dahUg5V?=
 =?us-ascii?Q?uzYEQCv04U3yzRcZrmyJrEK5ntjfHqrTOlYtotN9r9TGlguqaeqdzyHyHL1/?=
 =?us-ascii?Q?YUS0KCsFoYD/0uJBACndi5pE7WCrn448hCRG2XjxPnIR+COzemONT1zKdC0O?=
 =?us-ascii?Q?kCHfui0ZP2cpQ+ev2yyvOWlIxILd3Xi7vL3TSt5gSmCMm3XWbDI4P4NgLoK+?=
 =?us-ascii?Q?qx5SHtEbLoXR5FJ6RCMTVIInvmVoW101ITktV1NkkTu0DFmXKL+MGpM+bqUz?=
 =?us-ascii?Q?fHgNvfgIrrqzeNVHxy+PPyyjA2GBU48Kd5LLgYGaRC/hVqT/Ga7NJwF2wpvt?=
 =?us-ascii?Q?zntZfg8KiyE0lJ18QAN6M2r++9rO88NV0y+37a/i1qoD43Z/cIaHFQKJR5NW?=
 =?us-ascii?Q?XLyEESDDSjT6e08C0e1t0SVO14JQqzSryDsYPvvFjTEWHHBGvYBBH1pbiTJ8?=
 =?us-ascii?Q?dOMo+jfZd6XMYIFaS7f10Q5AU9FNMJNt7Y5PhxeoXjIACWEzvVK3tSmoQa57?=
 =?us-ascii?Q?pXbugMb8KXOzyp/7oJA7FVf/q3T1d8X85TRK/6AT3v8Xn1VD+CjbFUCX3Vrw?=
 =?us-ascii?Q?e0R8WL9qmIJlX5NSAeXVDm62iYOX9JQ/rPW+QJWnf/64tDYjIGtJrOOMf42C?=
 =?us-ascii?Q?SktKEreTBTwp4Zh4e+P4ImvJ+qjYE9MV6CTGpkiPrCS7tLNyG9JLZmMv0LxW?=
 =?us-ascii?Q?Mj+pLR1YoQswPiFVhVzy/DLHxbnKg3xHDcWe0EZ0G5aE1NqFK/mONNEhfoxp?=
 =?us-ascii?Q?LJuoT66DtrRy1XSBreqhfYpU9ElbIaH9B/lqg8+IknK6iLP5gsu3N9Bl+vIu?=
 =?us-ascii?Q?Ohp3GhiD8KoTJQG71gjfcB7S6Bwga44OcAzCbvjgZWPOdm996/G4RrHCtiB6?=
 =?us-ascii?Q?jaQMoPRQwnr0O86cwsy+PTL9tX/A4kaKz+sUV1UdCXEV4rMaeBpK36+BMRvE?=
 =?us-ascii?Q?BNd6OOAotuKYRAz/YeFZWdVI1fG3Q1Jxj3L0ZiQ9nBVgPiViZzBcddk4wXCG?=
 =?us-ascii?Q?8GcvtpJ4PewAvd1oyOOEu9hPn8bMS1rV6kmOs/PBcSc7BSrczwgOqs2T3SJx?=
 =?us-ascii?Q?Wy7iMr40t/JTBW0WphWSlGLc7/B0QeCMJknVqxYibt5+7nZWq06h6pIE+z01?=
 =?us-ascii?Q?T/e1V8B7mrx4dZjU0OWW5epAPMwT1E0xfokco0bSJw+jzrfnrbxgCki0F9Lb?=
 =?us-ascii?Q?cSqxPN/Jyk981I68a9Liu1u9dWJy7hQOoIVFq2nQtnWXrXbAopFk86tL1Xtu?=
 =?us-ascii?Q?us7xKcYkpATRKCxXCT5akO1x6LcDqByEWUanbbfsYc9eKnCabh1Q1vIJgFVt?=
 =?us-ascii?Q?m3iNUAiurKET/JWrcipzEWYv/0DPisOtaAoztIQPr0anXjyNNbLBo7rzD/2s?=
 =?us-ascii?Q?Xq/1qqQVtjvUbY6UOZd3yQfUR1wDPi+43BkTBMS2lErSKajBsD69TpVb4RuC?=
 =?us-ascii?Q?6VlPRizjZi8zLweIG8UCm+Sf0a1p7N6zqhqJEFN4pL/5ryLI9Hi7+S6bfYb4?=
 =?us-ascii?Q?mjpBZ2YZkEJ/LQ+keb8QTTTugpF559y3zY5lY0WS?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da1e661-c77e-48f6-4c53-08ddf75461ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:13:14.3963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z99YIQw6qRrRetT5APcXPLI4rl+CmWGtOq/UJD1CUx/Lk2ux4SWaAEMMH+NBHTEt+O4jR1Xv1zrFGhcppF7Uvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5256
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 17, 2025 12:10 AM
>=20
> The owner object of the imap can be destroyed while the imap remains in
> the mtree. So access to the imap pointer without holding locks is racy
> with destruction.
>=20
> The imap is safe to access outside the lock once a users refcount is
> obtained, the owner object cannot start destruction until users is 0.
>=20
> Thus the users refcount should not be obtained at the end of
> iommufd_fops_mmap() but instead inside the mtree lock held around the
> mtree_load(). Move the refcount there and use refcount_inc_not_zero() as
> we can have a 0 refcount inside the mtree during destruction races.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 56e9a0d8e53f ("iommufd: Add mmap interface")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
