Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F77221F20;
	Tue, 28 Oct 2025 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761614310; cv=fail; b=SiHEbB6D8GGpkDZySFeurYyWiSqaKNRTPXXaOldJVuRlXlFbkPdrSU/LuEd7lrlIH4XkCEAHXjTP2SHtxaoNenincEBPX1znPwbI4TNl9zVfC8PLDuY5jwp9OzbF6asUInkisTtVN+IiaDE4EXMT41LG54DFvoDvhh0LigFzzFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761614310; c=relaxed/simple;
	bh=avy6bIBwK5Hse2q7TsG6y8wpuMnoxynsfJOhWTjF9p4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MsC226/07f5nu/DYzc6Uwb2EYtMjQTdtYb7xwX+yp1d1vYk/snT9ef2rFr2JAEYAD1dhKYLA0sBF1SGpjsCHKDPBh9CGGyaJB45QMkHa4/0IM7wijiJ7L/IjmALQaSLdXNZKk/dpqcZ7Nx1T/jrLYn7Ud121HWbywOI0Sfrwndk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1lEVZa+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1lEVZa+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761614308; x=1793150308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=avy6bIBwK5Hse2q7TsG6y8wpuMnoxynsfJOhWTjF9p4=;
  b=X1lEVZa+2alzeUDDiAf0f+cmcPEtJfQpQbTLLoshT5vHU0b6fyxzMR4T
   KCth7gELzYDf13MeHdd/AzMReVlYb8TflBQWgIbUrnnKP43gyrUrES0Zy
   S/ZpxdDreal0BiJQvUnGbonFC40owev52aUDEsjwag7oh27G203+uyWfE
   RsvHYd2EXdJPWu0t6b9hSRgUNWTtAqiCkWj7s6Q335+rFvNzxMODPA6jQ
   Ho2k4jb6J+MXctY4SGf3GgriDfIUBfq6Fs38l16dSppLVoN9XiAfSiWUr
   UDJOxXfh5/svFj5bUYbbvGglhJN9ZMe9XraAAagfo0Zs07d+RcETFq2k1
   g==;
X-CSE-ConnectionGUID: GKSrjwlPR82ynzhV6kN9gA==
X-CSE-MsgGUID: NOXCEP64SOaAOCPFgz8V/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63743866"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="63743866"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 18:18:28 -0700
X-CSE-ConnectionGUID: Vxip0jjPRKSvPinnjpZOOw==
X-CSE-MsgGUID: 0UMj8EfrSVqlNLhZz/UT4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="208806937"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 18:18:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 18:18:26 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 18:18:26 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 18:18:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPdCzp0TFk/DOmo4eqeGmLpuJznuN43lAHr4qYIKzKBdIpQIn6P8odzvop1+R+5wQs3/bns5gmaMoIOp73aUtp1vcWL6ui+EfRIWaTl637MrivrugOqvUcFkrqMYg4F+mnyMzXk/AE26b+HsNLIrjcM5QdTn2xiaGlOR1Jc17Rmmn5/zeknUDgkfBuAK9kdVoFlMt+eVyqe67V0TxMXDLCS9w/E24zqqdjP0h6O/WDevCSpsj8mjPGlZVjZJSxK3B5hKddR6GgHSQpBiEDbV20MH1sMTt/Htkg0Ny4YTS++zbJrc1H6A2spQkpcq9HQT1eCblxuRVeB83kh5pu85+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avy6bIBwK5Hse2q7TsG6y8wpuMnoxynsfJOhWTjF9p4=;
 b=blyTmM8Uk/s32cBB4tm4/DvlZhFrvq7GoA/qaoN2qUQubMBSHCsKXWrA9uvRSdSt8znJi6XEymJNPjqYOuDQ/B13gkGTLr94X09ZS4W4JK6UXNCmpQ/mqGFN7l0YXelFHNjoMrTcoKC2XBpvrziyVLSFrSlEkcYX0D8iL1KxxZhInJzZc4FNirVr7rZRvuycs5QpX1LuVFdmqb9m0NdO3IhD68sLbUpyS0vmjczfEzdayn5u1K/L2LGtVnLb/tuo8sa0GBhopzTKiqvmTai9qJc1+SJpy/2elD8KWtbKti800VAOj4fgxt251O4lor0qyn4d3SXfux1cW4urFQxRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8788.namprd11.prod.outlook.com (2603:10b6:208:597::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 01:18:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 01:18:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Tina Zhang <tina.zhang@intel.com>, Wei Wang
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v3 02/10] iommupt: Add basic support for SW bits in the
 page table
Thread-Topic: [PATCH v3 02/10] iommupt: Add basic support for SW bits in the
 page table
Thread-Index: AQHcREoPcJWGLPHY7kK5q0ipSSsJi7TWyLnw
Date: Tue, 28 Oct 2025 01:18:23 +0000
Message-ID: <BN9PR11MB527621119AD1EF71BEE7237B8CFDA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
 <2-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <2-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8788:EE_
x-ms-office365-filtering-correlation-id: edfb3a7d-30e6-4d5f-2245-08de15bfe3ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?9HYWUHEnr84Z/1GJ2U0+TDYZQpMFHpmO6n7ktHtznfBUsLYUCtDCwK4VxeWX?=
 =?us-ascii?Q?KAi/Rn9yMs188GZ78oFkzjYOqy9FRVoKREImdy17MCFRUbQhg5oRcLiuNb7H?=
 =?us-ascii?Q?dHVH8yDx+GCa2QZXzsW6OHEt8EGMk9w2WvU1REcWpY/SxspwnyfikI06KIOQ?=
 =?us-ascii?Q?do/Qq6ADsCtqhrgpwbsqGij0+WR+rmJbpTGUgKLJp7Gk4LbqB+5N2vCPQF9N?=
 =?us-ascii?Q?C5zII+KwC6pnUEhzwODqnJNNzvqo+ecU0adeirr4XX8X9nWy9I0/MHGRsrdA?=
 =?us-ascii?Q?+ivIHoo1Z/eKkAisA1ZSeiTiqmZwSOuqkKOTJX/lzn6+cXH6dyDliwBgOG71?=
 =?us-ascii?Q?pGgU3IVsTRZ4gEUtpeQ5erWUrySXEgzmy4dm9T5Hqj9gSXXfdHxg1s2Ig2UK?=
 =?us-ascii?Q?NTyep/momzJYShNdpt7Q1Z9BlRdeNGNfN7vrJJTgeRK7OvjbEn0ZbhgK62aX?=
 =?us-ascii?Q?GzoUnYup57e38WNOKUpuDtejS3HUzSh1Rox6UY+kD21LfW610AMaoblF0w+i?=
 =?us-ascii?Q?IoIv4YIpAbK1oiSzuM5T3kbFw6MoszYn4Zw/eKx4BmN37SXPR0fd5+iVM0X0?=
 =?us-ascii?Q?v1TKgc18cI883IZzt7Q+IiiI6kJ8f/G3W3USHqhmrs35aBW23Bdq9OuUMBqp?=
 =?us-ascii?Q?pzGzcRR9J4Y8F/+Z7kwj2NvIG2ffIacU1kPHSKXqEK9RSg4GRUbXerK6ZgIn?=
 =?us-ascii?Q?wAJPfUtCW9CnBxGd4riq37asgdWmLt4bSk9Uk/lokY5CMqZqykS5ABNatwrY?=
 =?us-ascii?Q?tu24be2xXHXhR7hkVKZxQXFMoXsPc9iC1CMFZ3zYERj/ILPjz36Qa2eJkSTP?=
 =?us-ascii?Q?/zN2gkZmtl9wtaPWggp8f0Mp11D4/fhrOA/pq5Fb2ixq+5/bzobpLMFrjNy/?=
 =?us-ascii?Q?LJ5iyX5lFV5gE/3ON85iQl850xaXUVhpBF/1LV6rac0Qx49G7WIK5JoazYz0?=
 =?us-ascii?Q?J5K56JR+nCGY/e8fAmbH5L1Cq3Ey9J0MRITnf+YGOBDxZIe6zNFpxoLwpmEJ?=
 =?us-ascii?Q?pYaX+Yg8vEC+r8LlypqUj0bAhDzzB49be4pwii3e3HwVNZWoHnUS3yzeVr7T?=
 =?us-ascii?Q?F0APFDz3KlKbQCAj0hhAHv16nza4BHNcQdfiV9bTA9sk8h3rTtd8jIH9SR7V?=
 =?us-ascii?Q?9K2xeSvWdt6KDZH+fQxvQopw1xl7IQAKuMKWS6yKY8ZQHYnm1ouxvF6EC3re?=
 =?us-ascii?Q?EOxothnwOFRppf9bLVPL+YH6USyEkStMWeGsg9KrQ0cEN+RHIGibSiFB1qNj?=
 =?us-ascii?Q?gihuiKqHnr+14CznglsUu9iCo4S4uTwS7Yg13Him38Tf2ekawnxIYrMDDjR7?=
 =?us-ascii?Q?M1xkFB1ETcfiVs2n9oOHs/CGtM189HHb5cHqZO04KrBNf67xhBjN8rRDjIKI?=
 =?us-ascii?Q?P2faG+AHRvZi+Jbu7McJ6J0DyeTkTbAPijOYcH0TQvIJM8x5GhyIZcCfHcGs?=
 =?us-ascii?Q?Ah7fOlknYSnVCi32oBx8UzdIGY5/TCSEDvGqB40b+yQsUwLz4hrxLQhi79cp?=
 =?us-ascii?Q?RJHkz6MXKuWzqcM2jBbnnfjuWmhKDZECEAHH?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9umH29aNvP4orFZ9qrPsnn7e1R0TfmqvTWjDddYBl1gykz9RMT1XUQWN2bX7?=
 =?us-ascii?Q?U1iYhFntBFcjt8ef+djXJrVA81VPw+juK44lRuClYhNCsvqam6/dKqO1gQQa?=
 =?us-ascii?Q?udtOm8tZ3beG4LfjcrdbG4nDhC63qGTTKUNLAciI7PHROKcfwZlieQ36N0Yz?=
 =?us-ascii?Q?hX8uOy+R9xvZwQaFlBw3NUZBt4U90SHuFIoiyV3WEAYTRXB4BV1hKtpfOLsq?=
 =?us-ascii?Q?ypnNOrrPo3lV5y1+60p1GzFqpLz5+cW1/snIKFH9cNC9CNUNEL2rF+AAcZRG?=
 =?us-ascii?Q?zmmSIhPPNCgi4qw7rJsvgOFHKW9YKtPh+BbvlRctZVLgrhb6wnjrWvZa4x1j?=
 =?us-ascii?Q?DCs6rokTsQYoyt+jt2XJezXBWqNvcE9yZJE3VRnJfEvTJ5O7ja32jqRYk8Yl?=
 =?us-ascii?Q?2RMqCNFshgJKaagYNbLCj4h7jgs6vm+2g9ggsL+TpSUecnhLKYTFE/2ZM+R5?=
 =?us-ascii?Q?24HvCHYLIng/kf+RKaydkb/5jQFfzsvaf6A19pO3xrfhpj8M0u9vopgemnEo?=
 =?us-ascii?Q?Nf9AxhUEMj04tHZlawwew8X2vJdGG9xOj9SVJJ9/77AnGtHzAww3b81bW6qa?=
 =?us-ascii?Q?ZABwOnF8cUxBTrFg/Jkyt7FHFVtz/Zz6uNALoc5L8Pk2j6ZFBHrdfPxsqB7w?=
 =?us-ascii?Q?74jVESEIJFc4o6YxElsfr14v+5AXSTeXrOspV9BljeuSHl0WFnDk9af8cDWC?=
 =?us-ascii?Q?1XWvF1xlAco9fQCZGY0kI+rUIzTgm5WEmElrfZ5YMQDc8hrfKslpSDumXrP5?=
 =?us-ascii?Q?2Jl3rk8tmj/csj0CvDOLQaCCE15/1djv0DlNTFs0gryLokbUMrrZ/+/r/NQC?=
 =?us-ascii?Q?vMTUzhla8j/HRoXcgSLTt0y5U7bLtBcqxvphBKs1AR/b3XqDaaDxGK6oivbf?=
 =?us-ascii?Q?edyp5x5H7WhBfQegpGmW++zX1QV8vO/C5cmd7qumJjWTZP0KV6EeXtT6uF7l?=
 =?us-ascii?Q?GNTjYdRI+M5EWbHDuswh7gRBuALKVdYQ3oMe6LHO06bABy+Tk8Y5l/aeJV7H?=
 =?us-ascii?Q?s3NfBwRFrdV2NZbN1UrVIEPJLOj6tkki2WHksoiGzpy/WwzxCCIseXGxEgKr?=
 =?us-ascii?Q?U7G3JJQBBW5FQHu04hxqSBOlcPZR5t3BMpTjG3iTSKYSst7xqbGhWzk4Ci4p?=
 =?us-ascii?Q?Zl8D57Dbbr3q0rcftMDOYbwQ1hVJFEWPEiXsNvoYkeALLqAOgFTt3Af1pOpp?=
 =?us-ascii?Q?IG49QcxPO0UOT6ayf+ykB/TK3eP0SdwoEC1pyDRYLLlDYk5fANAsy1sO1tqI?=
 =?us-ascii?Q?TT5Fh9H3vwFuFulBNtjOq9xH+1nnFA8NkohtnBvUIObGxiEM+O4/s0wG1E0T?=
 =?us-ascii?Q?YSfGF70uFYBYqrjtsosMuEiOFofiebiWTsZQM5/xJkny+G8JDvIqQFY0m/Vo?=
 =?us-ascii?Q?FcTVjsgjD/5t2QldRpeFX/rDeXJMsxFht69qD//2Qqeso3lLfqSHVGVGnVLe?=
 =?us-ascii?Q?eWaqyEC313d9vmI1Tbp1BR9xiN0iWPr0JCDk6u2e/B6Jm3QWjM3FaLbcIZe3?=
 =?us-ascii?Q?H2AlXWFfqxg5AoiCzNKEepc+Nqx0pqvs3kxcGQDckbqXK7zAEo1pZTGJZ548?=
 =?us-ascii?Q?AhMrZ2D+dL9OKCQQIV2+5sHEpIt0jih8IKOCL85u?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: edfb3a7d-30e6-4d5f-2245-08de15bfe3ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 01:18:23.5402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H71mVqudnd/yKj+0A+p90PEz2H/AQGTdNVOA3HOhHdcqoSHNsnGCxi8PxpM5xuEKRBCc078An8mygfoKReoA/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8788
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 24, 2025 2:23 AM
>=20
> SW bits can be placed on items, including table entries, single OA's and
> individual items within a contiguous OA. They are guaranteed to be ignore=
d
> by the HW. The API is very basic since the only use case so far is a
> single bit.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
