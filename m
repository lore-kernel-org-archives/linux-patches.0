Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2116.outbound.protection.outlook.com [40.107.220.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD251CAA6;
	Tue, 26 Mar 2024 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477861; cv=fail; b=E9gcS2oGA8pTiQ3AsgwgXMb+4z84Fm2YafVNYI/RK40Evbz7f09l0+baaKSzr77LH5/rwkXVQlk8u/g0U6jCLDVBa8glOnnW5QsTX9CheUPgDYUfs4DhSJWY0Mt6X1tgDXFGroAm45GN1QAoFe70aIb56yiQFKJwHPaogTj6DJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477861; c=relaxed/simple;
	bh=vby3//qZZSxaQEX6ISCF2Jw7Sxs4afGMRGSbyD9+N6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a3AvV/90iTSz6llWcUCatOq/6L3Qu/XraarcxrF+SgsZII2M6l7fk/niQDRQ6R83P88wqaEboiptj8hKehmZzH3U7QlmbXGR//+R1zvfoqKRKU4jpDgqpz2vd4w6heh3m2RFXIV/pehok1mwrMQJSFMmsJf9h/St+qFYlDZqM+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XvPbGZ2/; arc=fail smtp.client-ip=40.107.220.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XvPbGZ2/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR+4jsOBgtt1/+XuIBfTgiyj1iKMx7ugMw9d2O4TAQZWmvbBiLWPUGqZHVEBWCdNDW7/Zln7DtOQGskCEj9zRhQfF21G2At/zE/18SKKq6uMYU/NEfynCBi0bv/QHpMOGVauMKGuCKYJoj4djUKKqABDrTWzUqem08ZyyeqrHAaMCdrFFfFjE/8izwOMqy3JQFJjuzXVxw7YP5F4uSGyhIRomb8ubJuwovd2RI1C7OWh0O9Er0P5Mh0F3E9Osx9P33mKqj/G/e3CUrsFUn+JR2DiBWGH7vAdnC4YrVZlXBC12W99tG7Kfe7yN0rMuALoMotiQhzjhjK5hWvzl2utAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrL8ynBy9qnZ8nLs1Oonksnp00fUG/H90DVG4VoNpH8=;
 b=PmXOounjwe8VvzpavW/Fz0YJk1ZodlznfGD5M/X8jg6xngWRgsWpzj+6H5sYu2PjUP8Wz5VmMJT97O55kGq/JnBRafjoNeFqUxWp+ngn30ubYr8QZiPn0ojoA0/sK++3pRFpFT/vJ4e8MCfDbpZOk7t8w9Glj4bhsfp8dQrpS2ickQRNsQB88iTFAsg0zgY5ptNwlWEBc7gdnEBpzaY4IAXqG0MeYmdLGd+rxA8B4cW2p8b1EwbYq9kjQxgr4DnQ9qqj95I8TvvQPCujoY1NCIcOhua2B3CYH97q5M0gEdXbRNoONyTnO02RYOTWoaga1GUjsCKZ3BhY00paimLixw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrL8ynBy9qnZ8nLs1Oonksnp00fUG/H90DVG4VoNpH8=;
 b=XvPbGZ2/XkBdkMtOdBgoKZ/1YW2y5rR9Nj6KJU6jYgULXY9txgAMJBw/+xJl+yI7zl8Kfdd0qlv0BeAlRs3Xg7U7eqLyH0tjj8K77CPeZHRWzqCct3ffl8d5rQ2pxGyUrWqhGaZVfh7BvZe3IbO8wCoHP713s9NWGkVfKGjwC6QXeoPwrnD8I+cfy3vAtxfbXRSaMg6OZM6XZ56DJKjg3GmuvJyIEmff/MnN3vrOLQ4lMZtes6gPCOPuh3W3PeGqfoxz9LkDNluOVTIa7V+2cGKHzER/hKOiHqkXFCcCSSagERWcpZuI9VfUfCyN6d/YrAnt8Z0mEo953NUAbWSYrg==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CYXPR12MB9388.namprd12.prod.outlook.com (2603:10b6:930:e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 18:30:57 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 18:30:57 +0000
Date: Tue, 26 Mar 2024 15:30:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240326183055.GL6245@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7S109OKJlRVXiR@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf7S109OKJlRVXiR@google.com>
X-ClientProxiedBy: BL0PR02CA0076.namprd02.prod.outlook.com
 (2603:10b6:208:51::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CYXPR12MB9388:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xIH0Ffcdc5Xp71DyOZfUXNA2c+rx4lafazkghTPGv2uPj4W5XzZrJAqk4IOCAfZ+npasf+7zMa/2WGn+9unildSVtyjp3OxMWwfxHPxIw/UfZfLscWDSXLMS/xTQwZdSgvKusyqNjsJdGL8yYpyd6qNuzChRicGdTOKIFx9QXAK/xiM6MQZaRCXbGEbV4VLWqvp+nMhUS2eVgdxkb7RNcRLc1JaCZrKl7oURC5UrfVkSK1Qjn9W/QBpw/IOCnZexNhKZKcqt25V+qYZjW6s+M6G/UUNFcYdjgpVeY7fOiwKhmQ7KeqsMjcZUP2u/l4Dv5dfpvc2tEu/wlab3c97q+oZAlx4qkXd+MHOEOn0J/ySBI3WXgxxgvbsQiPeOqK4igUpOs9YQHaG+lXLUq3p3mi7U4oMa+zhidF0w5gufQDfJcPlliwtEEvCjuT+rn5p1MWFl4hpNqbAJIPLub+NNNKWNct+EO1JHA7BEkNVgGp31EC9iL9alXHGX5S2KGr4mbM6oIJlctTTxftPQ8WMBVH0dhl3JPDzcyuMqpaoNwbTLUUN7jDwrY+3qooPahDze9kEYPUoM7jOw/osuIfrjhELYSsk6qpoFDEK/RGgWKJN4R/SUHf2ifDeUVHghGrXpbePcJcdU4Dg76zRXeYEOYStuMaMuJji1sfFERdWTB4s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lIkT+FG+C0eZXuZbJ9/jtHcVCrhGECAQ5NQInNriBYMqGvekAed+NmZaMwe8?=
 =?us-ascii?Q?Ry8qENI/Q0RH0jxgETVnS2D63G04xXE+lwbTLd6AHbqiexOGvdlcluPs0iVq?=
 =?us-ascii?Q?CyVEkgb9oKaKKOeobKq/CdzSsEsoihTs1nDi2FodopqBjnfW3ZrufeQybDWC?=
 =?us-ascii?Q?DdD8Lz45sNcSD5QHup4zhC9pZDwlPB1AHgTvfTlkUOO07lJAtHirn5RHRQxn?=
 =?us-ascii?Q?Y9QjhuDHCOheQbzrsJm/geYwxnq5Hea13wlSY6kC6Tpns6sjtARRGCy+5gEx?=
 =?us-ascii?Q?iWIWXcLJdqqWYtry8durB5dDZ9a1kOJZujAt7V64mLc5i+k7Oa4h0MijP5un?=
 =?us-ascii?Q?gwFTqoMTORUJ3Q1C6z3x8k0EFqJ5/izpRjXDGvdIPNl5WMj5uyLxQerRdN7z?=
 =?us-ascii?Q?OPs6OTl6xYGVxcR35YilrtF0baniv/EAbPqPQeTVwyd2AIZpyfpp4ZkHiC/Q?=
 =?us-ascii?Q?vFnA0Soup+OZtQbPDkl0Kem728W2AVakbS7Rjs2KfzorDpkX6TTxH279yP5v?=
 =?us-ascii?Q?5six8olggXTQaAbErt3UsUoOO3CnfOOhHQBjm52wags1LX2Xqkffosce6CY/?=
 =?us-ascii?Q?0UqtysiJXUe21YopmzYnsykIYWM6cllPlQo7tZD/qI/+FZ8nKT56jBwlXkMr?=
 =?us-ascii?Q?mRopslWsMLL02N/82qv6JuPOXvuK2RFuomKSWSkR9DMd7I44oYfl4W5CdNmH?=
 =?us-ascii?Q?dNsGcMmbItoV3JyiGmLaOWSdnIEgsXiG43dOjvFh8aPlrjubxfubze312dGI?=
 =?us-ascii?Q?UqIIjFOPlQIa0pxZZLW9mPIbSTzZZlKWayaLKcpGbVu6zDCD06tWjrn2yMNm?=
 =?us-ascii?Q?PjCeYBrnkCeJ8YL4rzgNnsFXMKLJ8/WFW3mrTiqIngFP27UtU0/9fICgapZE?=
 =?us-ascii?Q?VfBYVzh6ZJJUGLKmJplTL2sq5MkyJiihQ7Guzt0kFvvfZBy/mqHIOqX63+V/?=
 =?us-ascii?Q?lmtW/f+rqzOinVgGgEbnDtLXEyGNEn+pkt769zZdGcYBap4SN+zd3GvrL7qV?=
 =?us-ascii?Q?PhNOkAkLWjlrBQBFauAlng5xboMWyi4NvquJlC4OzaW8ldmGepEkuHKHCFnt?=
 =?us-ascii?Q?SPg8pVTQ4vnw3oTTibmrZtFWIU5DNhUp5qW4QqUvYZ74VnHU41DV98UGT9db?=
 =?us-ascii?Q?DtwZTeG/owFRP+5kQ1P6qw3pcQXo/sek0upjSHOeujP8J8L8KK0yvH5b2VtT?=
 =?us-ascii?Q?kYx5t4G+S0KYVyxX9Q6EFaL1FlAeu5MkXLz20ALCO9HfDLs8GBe6Vx3fTHaq?=
 =?us-ascii?Q?K0x9UyY/5RXhv0FhLEFd8CVbWMFSo/Ruob0dJgjgyWTd9CV6tiym2Oqnnoqa?=
 =?us-ascii?Q?UWY5O4ZB+ipQvpJj/McopZpeqzuvu/1WkHZGQYJJ179XUL5vrwgblNAqtNPD?=
 =?us-ascii?Q?FNmUrDs8LjgbCtAqzLDWkYgn9Mm1KE0bvT7SDB4maHRrI/+10YuwJsZv7ahz?=
 =?us-ascii?Q?ZgfNkY/LgRhe/URt32ZsmyjorLgVGkeukk3orfTlWP454dCluktQ8ACK0lE1?=
 =?us-ascii?Q?jPwjPjU4l6HrVkaowajV7D6CkDP72aCy1M0UN1Eh3DVDf65byG7rFltTF5kV?=
 =?us-ascii?Q?QwV4CkTpAwWE9jSHIfEG5ObCB862eb4zSCE51txq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff6d388-d4c5-45a4-9853-08dc4dc2e0c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 18:30:57.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MMsabUzxXWmiSjdF18cL2kp5Gg0DJ0yQnd7f4/9Q3Y4z9AhBgDahZNEyVnGXOAC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9388

On Sat, Mar 23, 2024 at 01:02:15PM +0000, Mostafa Saleh wrote:
> > +static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > +{
> > +	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > +	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > +		return;
> > +	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> 
> This is a slightly different approach than what the driver does for STEs,
> where it explicitly sets the used bits. Is there a reason for that?

It is just more compact this way

> > +	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> > +	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> > +		used_bits[0] &= ~cpu_to_le64(
> > +			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> > +			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> > +			CTXDESC_CD_0_TCR_SH0);
> > +		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> > +	}
> > +}
> 
> We should add a comment about EPD1 maybe?

Driver doesn't use TTB1?

Jason
