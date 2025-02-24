Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB10C1EA7E9;
	Mon, 24 Feb 2025 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740425848; cv=fail; b=VbY7O7PAiZ/NPpcAkPcVQ6vxSNiKX6ObvMJCLP041+etQyxk3CrijTGeGhtQHfauvf/STYuG3c0Cd6+NGhQGZlqF4JyA420gx2K2uXMibHnW60LGxFce9HiX3W09CvcsPuwi51IlN5WoEP6iZ4NfLmebEDqQezcaDC+HWLp7RZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740425848; c=relaxed/simple;
	bh=9PK0oOhfY8jhReLtdUDa5jmMZYbuOKbnJRlmU8z5GtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j89xbF+O7DryZJrlgnJOSTb58X1NUFFj7uMivPPe6I6io0gpqn51saaZlMOgghY8nLYIC4cVFEsngixaZW4c48X8NYF6wwWiWuLAgKuweeY3Idop6PzoD3Ms0/hTrQwfTz9Q+HptiaTXNmDOtta9oHvzFg8g2zWkbej5gpTOQ9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LmaKCIc8; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LmaKCIc8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lEaEFYRlXyxPUFvOTfQTv15Rp9sqac5zhwBMZrXCPhewNXcsa4R075rNgDIt89XRUD1RSK8uti5J0JOZ95OZs5KGVdQJc064F4diS3O7kPnPyCbrvpvZc1hbi035Vfr5PfIof3KUwwnuaHL1x62D7T3Rh3ZqmHV6KT5jB+/ksYtTmIDT6BrCdfgf/AuQ3EyevCBnKwa8gSu3EIUvKlcU6tnSa9T7AkNBcPCZR14UevAiQWgGKPL5rUN7y5avGpZYpeyIwRKRD4/6dA7Hv0xMJivJzcH7/g++5ebo3dtxXi6CpAZ5JXLvPfagqHnYX6fbPgHGEdGYIywCAJmeh8CpBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBU4JJfnXg4Ctb65DKHYCVbte/sm+D3c7jeeygP7S6A=;
 b=j/D2sq6vMlGJrMeVRD9UXQSCzoAOqnpP/42Ug91RsikJB3FC3o2sGSvN0z+EM6L0WHedXQYz+/CXWl1KM8n4+He7jCg7zbKVaYagVVWZWGTjyEr6ECbn7GjYE2w3qivR3piLijzhtUCrZzjXxO8HipOuvaZQF3oRPhZ+L8Ek0WJT2cAhfdZZ0prkoaeujMtG/YnSIxwQr5MSac0teKjuzYx9/Q86Kcj44bUrenmxm7nej367fY81xaBPmCwqn4zJcUFuuPBcWS2IrTC0hPtMbebow228tP2aZDQlULmgsp+IInjNnwmgyDrpNIfOfIy187loXBzH/fI2Oawn81Z43A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBU4JJfnXg4Ctb65DKHYCVbte/sm+D3c7jeeygP7S6A=;
 b=LmaKCIc8/kdzB/rnTux4Ky5KKALzEo9xih9ytFrqCe5r72K6OGDFnRyxOBzlzxPY0hdmLE8lrp+ZLz29zdWETPv9Wh4c4Pnpzh0HozeP5fzbfJn69JiKPYMXzs3G1IP4puHocUPq+gXAnQNc383q1B6Sno9SeGEXeAb0mGlpmCMz9S3uD0uymZ7GZfrfcBLl3CEDSXtUWZAxyU3eKQaqHMJysR4NSu1Wy6UDXb2enxSX0y/F2UPN+mKb19Jp7KMJOnIB0Y0Mx0rMExHALmhPRaQkoc94uZyS9xeFxUqKfeFr5EdvhfuVn6zuNz5VmGNXy5owGEtxSUcIj7TLWVYOsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9110.namprd12.prod.outlook.com (2603:10b6:408:18b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 19:37:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 19:37:18 +0000
Date: Mon, 24 Feb 2025 15:37:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/5] iommu/virtio: Break out bypass identity support into
 a global static
Message-ID: <20250224193716.GA524338@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250221113527.GA719702@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221113527.GA719702@myrica>
X-ClientProxiedBy: YQZPR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: 781559ba-e0e2-4c28-a731-08dd550aa666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tgbcFxeQAncWlOTS5AbH9/qeWbqc/Q+XfPkTLnXrdXL0SnFbeagMmViMCPQy?=
 =?us-ascii?Q?VLtyvA0qW7Vqs22u/k7eMKo01j2Tse4Giipvn0pkObkICrEHJ0o+YMglgpUc?=
 =?us-ascii?Q?bMGMbZ2nOUQXZbJkbZxHU2zfiZtqweB8AyHK9obEwiS4/HP/pHylAWWRZiQP?=
 =?us-ascii?Q?/VEePYKFm8M02PonkYCOzX7Ywe+tSbWU7pv7Hl8cXfCxJHjBS88x3ACwH9oJ?=
 =?us-ascii?Q?SdyoD1kDUL6XAXvohlx7FYJSka9/UUDDRy4+3BhF0yhObFH7VsYreNPALb5e?=
 =?us-ascii?Q?dgnSMdqyUyocWQJkPfEue/ouYxi27nDbJXJPYc8Ep6k4/dxElRc7GOGC3SqK?=
 =?us-ascii?Q?rwO56u+OAchlJn0voaOtxVrWowovs3HpUOoqWLQC5trU6UN1UigC+J5Tci0h?=
 =?us-ascii?Q?f1zfZHfSFZcPwXnTN17M7hJlnhWmF31CVCoIUJ4A4kRhQkXa8GDnBpQMuEf/?=
 =?us-ascii?Q?PbCc5aa03sgOpj3pWDc7JUDRtkD+AGSUvYTq2UlCB9Okuy3o69UuRQUxnH1t?=
 =?us-ascii?Q?05nN2U7UVJJ1GUmi13QIwL0PneoLaIM/00w/SfTTFOOAmf9nGeQTiKo5QYNZ?=
 =?us-ascii?Q?GoIg746mEtshhU5+mgqSC3QrwGiURhPZk3Ud/sb0IGe6RC7R5ahUVYPm36+h?=
 =?us-ascii?Q?suM7jm2vh90tMKNwCkkJYVN/210f09AKN4jiLRm/e0cxUjWsCVEcaugI45u8?=
 =?us-ascii?Q?9kBIBpn73A29NLjZ2qbORXQ2Wql7Vz7AaF/ozaxMZFzCt3MKTQ1Vs5FHGhsP?=
 =?us-ascii?Q?WeHo5YFQ25cGDNdqgbTtGFuxJUOIm5HAn7SSp7Gv2cgLVzVoiu0E34d/tR2b?=
 =?us-ascii?Q?X72HDhMNdCtOZmWzu1wbr6z1KhDTwj7A62hwIeshvM6mTjOuCfzht0zXyRRr?=
 =?us-ascii?Q?iA7renGN1TA7vO30Qke4IP32Sfxe7PUh136A97d5bRusV0zdfDjrgUmTPUTv?=
 =?us-ascii?Q?AzsiKXvdMh7i3NklRCPY3xJunW0EI5rzv/Wl0XrEcgeJuJIUtpMeM9oICZx1?=
 =?us-ascii?Q?cwHBujnWl7AWp0kclL/2mDUeSOrOilO8LyjMddphfw57ukMI+CJ7AiLI64XJ?=
 =?us-ascii?Q?viN1arGKgxfn9Um8apNVZx3C//4Ofc2Yp/08lSh6QYuobQt7B1eye5k0ycWq?=
 =?us-ascii?Q?tbWd5ZID/ZzVqPo9K/MJXLS3hyOWDUp8jgGtC2qnpd5bpvcvzioJ6Axrkic1?=
 =?us-ascii?Q?dm6/+VVI7vpnbViSK5ImxqBD9eSqNfiutyvtx/6APxMGlwpNvjBxguNIxIQ9?=
 =?us-ascii?Q?7QoDtSNZsRvPDls1dTpXfltw3QWnGtWQD+r2tFetz9Xpdo45HiX861iDaWd5?=
 =?us-ascii?Q?cHmaj4lMFKySFlFjuUPVb/IbtvoIE+07HfU2aqReSk/+ykQ4QNYDTdYe9Zy5?=
 =?us-ascii?Q?Dak8YIM3fWggTQ8/8cJ/Iap1aeyi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ze7GzTs9tc//rtWnURgoEMpL5zZlS2eiErOhHDn0Ko6s0hg5vgzRaAOe2x00?=
 =?us-ascii?Q?z3jMplPXoszHiHSNDpL5YHiFUIOgumIJ3n5/DsLnB7C3WH9ofpLN/GW1UJZD?=
 =?us-ascii?Q?MmSDVVo58SqMP5ftROLeFVYnX34SkvlYeSn+T0g5iGIzRwtqf0YTHK9l1F/3?=
 =?us-ascii?Q?UBhG9oCPiZy1bQ/MBUn9sLnAN4N2dzFhBAvUEu5oEybDcXSCukb9HWJFOMYH?=
 =?us-ascii?Q?qL6WJjRYIZ3aUHG6im0dnk4OsywBinYVs/nEDCdCdL7o9kZEKrqVDlJLM/iM?=
 =?us-ascii?Q?E0LxoQEOtdF1+67kPRn6B/Hz7dJiDXHe0dt7L+Q0tt2THGijM2Iu1Y+GSbBp?=
 =?us-ascii?Q?k04KC/oMnXF6MXD171wwIqows2q0cfwaIavmhWad3hHS7yKCfDlZX/MUrrU+?=
 =?us-ascii?Q?ks4J8IEPyjAi+icYpd7hZdBBX/YhxSdYtCIVrXZLIXcT4x1OBSn5eZDrulaU?=
 =?us-ascii?Q?t+Wx8hNkY8AZuJCl/YO8i3RLHmwHudK+5oNwQhgNLRRKQdnRhDs+nVG/xiu+?=
 =?us-ascii?Q?ZgWqsRX6REh8OSsVXTXUeU7AZCaIWeIX9mMrPYLhoF4vcJ9PUD6+IvIE4stt?=
 =?us-ascii?Q?wIp0eof4h6s23hNvEdNkk7k0dWHatpYDtmGBHTBnFDComzmF/KlWalCjOfRi?=
 =?us-ascii?Q?CbDfY1Pnb0AqYwcXeHzlla18Ky1pfCR0X4xIq2X3UPKYzThZg6By213mUwZ5?=
 =?us-ascii?Q?vWDBR36I5zhvxGGSlJDydJgnrf8ci6OEADWG1Vg80AyVA/krFDzJXpce4JWY?=
 =?us-ascii?Q?n8qsXCMb5Hi+17ZzJFLlQT9Rhia+IKNeEJSsi6IDa7RjoiY6GJwbU0d+JKN6?=
 =?us-ascii?Q?jx0sBijGZUHpxaiv7QlL584dVODDFyW32wHfHZHcEqL+nWYZ48GsmwILKi29?=
 =?us-ascii?Q?QnQLQJwZtM0SRIqJOWiUlIrBi5QN7xUGMthIzVcFwpKUJVfK8N58v1fCuJXI?=
 =?us-ascii?Q?B2qKsWZnCNAnP/4qy37SfLKKxX6ZTuCMDanJbSKpTjoUfP/HpM4jjXHSxbwy?=
 =?us-ascii?Q?i6+eP7diVNzSl/8SoRktz8cAWpZQtwMuIFdrTJ77lYpKDo+c+7F2IZ91a4Zs?=
 =?us-ascii?Q?AFhgumZHSCvBEb5qY9WCA8jJi8/gCwkbeJOm/e/GVEBftE+bspCh/JBdZR6e?=
 =?us-ascii?Q?7hiw0T+a8la43/WLaitVMUfPm43oL62s+u9p7KSYS+sanvWDaIgq7Bl7gPy3?=
 =?us-ascii?Q?0uPV+ZHUuovYbLv9Rz3sPdbeVG+H8c6laB5+wPtwWMHrybm0cdnJJE2u+zVD?=
 =?us-ascii?Q?7jcjSevlA3Q7faJjzpkn8x9um8qIr98fhz2vIrmJMPTwpqErS2xs8gqjM9jF?=
 =?us-ascii?Q?YaJej/STHH1Vsl+zyHsRS/gP4pU4fyNjs+p+GT/EIz75w1nOslORkqpGTemD?=
 =?us-ascii?Q?SqZ70gcIR1BDfULA1LSQb4Mlt/uDSIR/p33dMxuwNUvKc6BUgEnx4KuaOICM?=
 =?us-ascii?Q?RSd1VqEA/sbWVgbEo0E7yfSz1/BqDZjPgJ8ptFzb/G/S1lzWz6DddyizCKEv?=
 =?us-ascii?Q?cP5CwUtP1MJ5I8uLcCi/o30A0DpDJl2bbkh9RqEk1eeyHeejVAC9fLRNqSLH?=
 =?us-ascii?Q?Aqkz042KNKSb4HZKP2gh+66jXVbis2blj6jotvDB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 781559ba-e0e2-4c28-a731-08dd550aa666
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 19:37:18.7979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AU2dB6fcCV6mtj2yK9yiTNHWSqYaScQ4SMne6W0liYgWIFmW6pgI64OyrHcy2ED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9110

On Fri, Feb 21, 2025 at 11:35:27AM +0000, Jean-Philippe Brucker wrote:
> > +static int viommu_attach_identity_domain(struct iommu_domain *domain,
> > +					 struct device *dev)
> > +{
> > +	int ret = 0;
> > +	struct virtio_iommu_req_attach req;
> > +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
> > +	struct viommu_domain *vdomain = to_viommu_domain(domain);
> > +
> > +	req = (struct virtio_iommu_req_attach) {
> > +		.head.type	= VIRTIO_IOMMU_T_ATTACH,
> > +		.domain		= cpu_to_le32(vdev->viommu->identity_domain_id),
> > +		.flags          = cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS),
> > +	};
> > +
> > +	ret = viommu_send_attach_req(vdev->viommu, dev, &req);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (vdev->vdomain) {
> > +		vdev->vdomain->nr_endpoints--;
> > +		vdomain->nr_endpoints++;
> > +		vdev->vdomain = vdomain;
> 
> These two need to be unconditional

Woops yes

> > +static struct viommu_domain viommu_identity_domain = {
> > +	.domain = { .type = IOMMU_DOMAIN_IDENTITY,
> > +		    .ops =
> > +			    &(const struct iommu_domain_ops){
> > +				    .attach_dev = viommu_attach_identity_domain,
> > +			    } }
> > +};
> 
> nit: how about
> 
> 	static struct viommu_domain viommu_identity_domain = {
> 		.domain = {
> 			.type = IOMMU_DOMAIN_IDENTITY,
> 			.ops = &(const struct iommu_domain_ops) {
> 				.attach_dev = viommu_attach_identity_domain,
> 			},
> 		},
> 	};

Done

> > +	/* Reserve an ID to use as the bypass domain */
> > +	if (virtio_has_feature(viommu->vdev, VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> > +		viommu->identity_domain_id = viommu->first_domain;
> > +		viommu->first_domain++;
> > +	} else {
> > +		/*
> > +		 * Assume the VMM is sensible and it either supports bypass on
> > +		 * all instances or no instances.
> > +		 */
> 
> Maybe also a WARN_ON(!viommu_ops.identity_domain) above?

It starts working in the following patch because the core will call
viommu_domain_alloc_identity() that can make a correct
per-device/per-viommu determination of bypass support.

Let me fold this into the next patch to make that clearer:

@@ -998,7 +998,7 @@ static void viommu_get_resv_regions(struct device *dev, struct list_head *head)
        iommu_dma_get_resv_regions(dev, head);
 }
 
-static struct iommu_ops viommu_ops;
+static const struct iommu_ops viommu_ops;
 static struct virtio_driver virtio_iommu_drv;
 
 static int viommu_match_node(struct device *dev, const void *data)
@@ -1086,8 +1086,7 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
        }
 }
 
-static struct iommu_ops viommu_ops = {
-       .identity_domain        = &viommu_identity_domain.domain,
+static const struct iommu_ops viommu_ops = {
        .capable                = viommu_capable,
        .domain_alloc_identity  = viommu_domain_alloc_identity,
        .domain_alloc_paging    = viommu_domain_alloc_paging,
@@ -1216,12 +1215,6 @@ static int viommu_probe(struct virtio_device *vdev)
        if (virtio_has_feature(viommu->vdev, VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
                viommu->identity_domain_id = viommu->first_domain;
                viommu->first_domain++;
-       } else {
-               /*
-                * Assume the VMM is sensible and it either supports bypass on
-                * all instances or no instances.
-                */
-               viommu_ops.identity_domain = NULL;
        }

Jason
