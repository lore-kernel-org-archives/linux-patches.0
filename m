Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73F58103;
	Mon, 18 Mar 2024 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784970; cv=fail; b=nLPcrFGmh1Xi2EA4iGLZSe8O+0uszltUMAZ1XCUzjckTM9EgxL8wP8g+qLTXo8alh0T5ZKNlWKbn8rOsaJ3KyM/aIgphQBuu3R1Q6gnKgmUkUn8cerkAMQj6wRKg9hDtX43q8RtZhTlUb8QjxZ9sy8GasmXbJJm47UlbzwkY02Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784970; c=relaxed/simple;
	bh=kQ6Gvz+4k3Imyuh6esd5GRUWDCvWf6nOnphSUFN5PqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jhabm7vkrC7BfqaFNcIM4MSjkh/UAWBh+ECU26HlTYvv/tvpzYUclslKNQ5e4cKFPFYK8UvOCgyVmdCjbm0ZmZgiL6eo3tVuHuKG3sTEIePNjlxVj2vi5C538n1K7YPk6Pqa+o8b9tpbG50uVqNAQ9st2M3wOEtki6hzSF4jPIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LjbNoNsV; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LjbNoNsV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjrF8tfZX5KYufdEZQiL3P9Mf/rfqCpcAjVlHKlVBHDX5eWxkQ7meCN1/FuycedIAA75PPz1POH5ARuNCPGWmUF3u9X3krWZC6KKD1vzNlT5CgCOpgzpZUB6vXKW11fCrhb7TAR8vacjr2YVIv/lu5BE2Y/MsSMy6ZffNAOAZZIz+HUMDzXWvBT9lAeH7azDj3x459NvZIIgvdO/7GhYIjJtFg/IST/WCAwvlcIiUA+blr+pobYehQxh4m/ZvzAJKZh+b1z4SzcQ1ffw0RY1LVOHf/iF+hcdypzRwChYhqRmDdoTucl9qlxOZz4TTh4CKtOQa/Ltf903zSgNwA70Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CVJ8A3WHlwDA6RDlsMbEPFaf5mIGvQPZ5546nu6tl0=;
 b=TS5EU7dh1l5w/xhV6wmTB9RhuqBOW1Q7j3do0pmyvi2CujXiPGlFgy5PKAKEfywyFuMIudv8thC5B1fu2HV5OjJRjHg8Qog5qaEGosqnyHnw/FiEunbLobB+rwju/N/KehdKk+GXHyi0WbnYaQPN0Cn4sp33YUjgj/s3ZbQCA5UJd2Br7zxDnJ1AJLfSA/ux3fD0dvxV5HN31poj9ASunp35jzfMJn+iNpxpqOSRSUabsCb9hIchgZVJVvFOJKiAeUM0zMnxQKQYUj3hAQEPgdzXAQqVBsiTydFf3Gg6rbVTDaSh1Y75y6Q6M6PUl3o2aOGimXLZ+4AT8e+LWDSruQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CVJ8A3WHlwDA6RDlsMbEPFaf5mIGvQPZ5546nu6tl0=;
 b=LjbNoNsVoE+MhqK8XBhxY/p/hMh1mTrNdBq1tdOUz47ldxgoFP4QQl61brt2q/PmCgxP7arePeL1zSi/gZEWAqeA8ibOk4q11VcqLOHeSWYDg3gKTQKfFXczPjqzCgGmm+vM0w2OZFvnzuRCeaXLlJJAhpEgDt1fmmEaPYHflT2Ga92U/zEWH3jaQyU3L8kXt+0pa8TvGeVy3kJc7o05cA8rLGR96XFb9XxqTQmDjz1VCKWTFo/78mkAXzPMaFqBGcxIb8yVgdp77TtLaoMqxZYfG2kaEw9SD7gFBr3YbvRzPdYD//WKGOv8oNY2tHA9PFmRxFuak4lljO8mRX2ycg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Mon, 18 Mar
 2024 18:02:42 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 18:02:42 +0000
Date: Mon, 18 Mar 2024 15:02:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 03/27] iommu/arm-smmu-v3: Add a type for the CD entry
Message-ID: <20240318180240.GE5825@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV26ATewvBtf4tkyEP8CTS5SFj3-FBySwt6jsrLd3tH0VyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV26ATewvBtf4tkyEP8CTS5SFj3-FBySwt6jsrLd3tH0VyA@mail.gmail.com>
X-ClientProxiedBy: SA0PR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:806:d2::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: 95ad4e73-f916-4901-c396-08dc47759b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uU7YFzR4qXqDbh7FbwDpyMQ/t2PcJcRporZDUaa4oPnETaT1nvRbwNY3OLqtNMZrE+jmlJUZZSN2dKGAst/RXxmVS2Lc/56BbAATbO8tAh/Uy/78e3ZnFs4nUZXsion4SxdEvEC3KX+eCc4i0xjy4mBtqsB0AVztvtDox/VGnDDI6Nz21VGmfSoUUumlRG/0fWHU925IeQFV+4u4JktnqzAmceiOVh9uDgGUEch104Zyod0A98j5JgALX5xpDx4H5RMkSpT7grWH3QOXrOM4E2SOwbFlkirGt62JnxvIpnAnUOLE0hpl5Sb7u82CuaehU28TCbyT+tc7qEe5dxKn/ARh5K3jXet1eALEgBLksUWAH03pOwBvX46uGyTHhog18zhrvGpr9xtK4FaOGyD3KKpyQvaV+d92rsb5H5obQD1YD50oTbVydnJKYPQhPnrjSgTjFrsCvbYm8MhzYFmd9Xwamly3TJD3UyrtUCt7FCWxB5bHOC1GOeNnjpxTXao7btVDSq+Qcgp1MD6VLjro4tpmXj+DFZRIoQZVqG7GlZVoBg8yssMDgy/kxQMAtYzc6KJNN9PHorj95OT6FjT52tzM58/B9AvaCMYDRgS9mSifCnaSlxmA1oEMyWVXKd+pgE5X2Bq2We7HuT2OlQy7AGfroQtBDffhNTfv0Fr0eWU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUJyVjhmZ2U0UXNRMjRYKzMrU1dlTCtvUktqQWlnY3BRY25HL2lTbjk2S0ox?=
 =?utf-8?B?Rjk4dEtBTFFKWWtuMW1YaFR2YUo0dlNhN0ltdCtYOEs4dnpYWndLdEJzWTBw?=
 =?utf-8?B?RUU2TFBNdWY3YTY3YnM1SXd6RXlkemZ5TEh1cjBpVmljbCt6SXlTZ3VPcy9n?=
 =?utf-8?B?Lzc2bWRZYjlCdFJCMnAxUVpvT2dTUnNzWDBMVit4cEs4Q2dHeERuYytFUzFD?=
 =?utf-8?B?M1dmbUR6YzlvbW9WcTJXY2pGc2RwUXgremtsL2c1WlROMHdodEVxUGlEV1Uw?=
 =?utf-8?B?WDZSWDhMNks4Q0E4QzFXZ3o2eVFUakNlWFo5dTFTN2IwM3hMaUxXZDBNaldu?=
 =?utf-8?B?Zk10UlVQWThQSTVhKzBFUnJWK1lLekd2b3ZmTmY1MnkrRU9BWGpjaVdmeXNo?=
 =?utf-8?B?bENOYWx3azIrNTNkNW1KTWxBQTFrblFMbmoxaWVyR0RURjhOdDNmYjU4QjBM?=
 =?utf-8?B?Y2xDSnd2RW0zVFJCaWJnMVg1QngyMk9DTi9Kck5qYkFPWlcvR1AxZmwyc0hF?=
 =?utf-8?B?UThicW1YWmFzSXJuOFNtbHhCcS9zOFh3OXY4YnhaZllaY1p2WDdncDJFeUMw?=
 =?utf-8?B?SmQ0M2JYOVk0RGRVQmtjZFN1TU1RbjlHbDJBOE5YL0NOTzFnZlp6L1Y4ZkMw?=
 =?utf-8?B?UllJQ1o2aE9MZG5ZTjJlWlJoOE5HaDY0MmlCUy92YkI1V1FkVmd2NFFYd0FM?=
 =?utf-8?B?Q1c2Rm9wSEphYmg5S1FuZGpUeWNHTEtna0tJWis3TUJZNldwQXlsODdWOVd0?=
 =?utf-8?B?VG5CVldMSWN1Rm1sWlV2U1RieVZpUXIwQk9MUGptdDd2TlFQaWlhNEsvd3Zu?=
 =?utf-8?B?Nk5Jcm5DSHdQRS9icUtRa0FKdDBNN1RmdWMrNlpTZWhHcW9CQ2hlYVFINEZY?=
 =?utf-8?B?WWNFbTZRUExTWFV3N09Fb1pYeXRnM3Q3aWF3RFVkWkd6anRWNDNhQ25HK29i?=
 =?utf-8?B?SHpFbTMyZS9vMGFZYmt3SjhzNU54enNnbTV3dGFycFljVEtCMFFrZnEvQnRw?=
 =?utf-8?B?VkN5Y2FzdnI1RCt5bGpBT1ZNWG9mV0hQRE1OM1YvNWYrMlJ4d1pqMTFxRkhM?=
 =?utf-8?B?N25IaEs0bmIzRHI0SExBYXIxYW1uR1JrQkNOdzAvdE9aeEQvUm03N1Z2dVpi?=
 =?utf-8?B?QzcrNjF3azI3V2R1alNTZTU0Ti9ZT1NxNVRDSDhNUWkvdVZPKzFLbjB4Wmk2?=
 =?utf-8?B?cXR1TjI2VXRUMU1Ib0VXbGtFMkJnUlZscnNpUmlRajRKVndoWC9yWWEyRWFy?=
 =?utf-8?B?RmFjZ2hlck4vdEt4RTFqNFJSMldnK05ta0UxSDY1dUZmRjd4QUhPQzVFNjhp?=
 =?utf-8?B?SFZGT1dHSFRVTHVKRWlVNWRlYlh5ZDdodjZFQTQ3TWRHWHBzVHF4V3BGNXE2?=
 =?utf-8?B?NU9GWlJkN2c0OXhRWVBCYnBERkg4Z0lvSzNYN0Fpek5OcE9pTGl3V2V2UDdx?=
 =?utf-8?B?cWJZN3IzMDZ6ektzZTRxdXFaKzR2OWZIZEhqQWVaVkhPRzdocjAycEt3YWdj?=
 =?utf-8?B?bzJBYmJnbUpBNzhqMU5NWEFPL1dTMjMwMFJ2ZmVIWUp4RDRZR29qbDh5aVlF?=
 =?utf-8?B?NUFZUGJCK1o4a0NIYnU1ZmlPQWVBM2RIRjZ6MFVxUk9SNlNuaU9RbnVtdUUx?=
 =?utf-8?B?UHRmOXlReC9aLzYvQ0YvTnhPNXhPTVZzbG41d1JYdUxIbk43b1pmQlhIT3ZK?=
 =?utf-8?B?OGo0VHFDbHNKL3g5QTcxMWRWeXc4bEEwUjh0SWVwejdQRmprWEUvM205WnMz?=
 =?utf-8?B?dVZ6dlNESHZXZkJjSmtyQlBpbFRpbk5waFZQaWl3clZMQ241SW9VTWFldlln?=
 =?utf-8?B?K1dUUzg2dFBXZTBOdnRqQW13VVcrUitEOWhqRmR3YWVDRklXdmxPbDVkaGVD?=
 =?utf-8?B?cnp0R3pVUE5PZXJsQVJXNzY2dG9jNCtSSHh4cVR5alNDQnZsbytCZWZrVCty?=
 =?utf-8?B?azd4MEt2SEZvc0FtY09PTVVSbTh4OVZMM0t0Z2tPWWtNcWVLSkVCY01vc0dy?=
 =?utf-8?B?YUZUT1BBUkJpOWN0YWdraGhtL1hQMVExVlJpWWsxcHFzRlRmc1ZWamY0Q29H?=
 =?utf-8?B?MkI0N2hKTFJVUE92Z0E2QkljNzBweTluQlN1aVZxbklvWGZHQndQVXpWNFcv?=
 =?utf-8?Q?SmNs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ad4e73-f916-4901-c396-08dc47759b69
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 18:02:42.4954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27KOzr5CCqGomm/qc14W9Ij/gACgQOvQ4GOEJBdXFn8xpnWnO2C/RyyQ3n+hqWqX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7548

On Wed, Mar 13, 2024 at 05:44:35PM +0800, Michael Shavit wrote:
> On Tue, Mar 5, 2024 at 7:44 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > Instead of passing a naked __le16 * around to represent a CD table entry
> > wrap it in a "struct arm_smmu_cd" with an array of the correct size. This
> > makes it much clearer which functions will comprise the "CD API".
> >
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 +++++++++++---------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++-
> >  2 files changed, 17 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 9e9233331c4636..c60b067c1f553e 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1219,7 +1219,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> >         WRITE_ONCE(*dst, cpu_to_le64(val));
> >  }
> >
> > -static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> > +static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> > +                                              u32 ssid)
> >  {
> >         __le64 *l1ptr;
> >         unsigned int idx;
> > @@ -1228,7 +1229,8 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> >         struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> >
> >         if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
> > -               return cd_table->cdtab + ssid * CTXDESC_CD_DWORDS;
> > +               return (struct arm_smmu_cd *)(cd_table->cdtab +
> > +                                             ssid * CTXDESC_CD_DWORDS);
> 
> Can we define cd_table.cdtab as a union type to avoid this cast and
> make the struct definition more explicit?

Yes, those patches are in part 3 to fix the CD and STE to be like you
suggest. In the end the above looks like:

	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
		return cd_table->cdtab.linear + ssid;

Thanks,
Jason
