Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84B13822A8;
	Thu, 12 Mar 2026 19:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345303; cv=fail; b=jUCK+x1TbPKjdex55NEh+X/yDE8+hp/KF2sfRqaHxz35D+ZgT5ScpgqVlK3A6WhZ+GtKRo3tydvnUHg5nfYLW5D1La0FO2986Dk6kFlWowCzVazAVukbQq2yhg4v1sgu/UZFATs8rNRIIZWgk6O56zIOJz43oYrXtWqzAQ9HAF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345303; c=relaxed/simple;
	bh=SPQYmp8W2K6u/h9+yvTkzQvTluvspDL2l1Aqlek/3c0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUsVKhOu/iC6Xbu26EmecGFs0aHMNEMd13OvRqEARRMynEUb99EJOsGfMUQFy9uXEiR3Q7TdjIUnuAsEZI2PPovmaWoQgdMWf5BDcXrq7Otve3kXmvPgF1M0IQVSDfij1kP9xO3XRkR3JY7hNzCIYDEXhaV/BJtJvFy/1uxGIHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eU4mPF3c; arc=fail smtp.client-ip=40.107.209.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eU4mPF3c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUftiv/wClQrcId8XwSJpQ8jlTSx04GnnLul1c+uxuqwihTUaNNNaPbDiUS6Zv/dpDftl8fhmEfIWKYW/UyKEEJkG8MTUW16Ji/k81f5Cotq9sQ/9Aq/3e+RKacL4Moej8yMI4ttxh2bsfzplktS1aVmzmISJVUHnizV++Gw0gxSRS7WMLaDLnOOcDCYglCP08O0RMfzTLRPTmrysvNRPwQJZnoLkzWQE3CFG29VxoAjTJ7CTyLmjtk0P7LAYCi+wQ1LkAPOTNfdlSSaAR70UTkICB/vbODoCq91Iiz/2HFJZIfGAm1GwrbxTCW0NsTEObU0bXZzqULZxxl2d7ms4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBkFlWPP21OJkYgDYRy7c+ihbD87VeDXGeYepEHx7gc=;
 b=Jm9qD/YJYil6EMdfhJ2vpv0Sn6KGiM3dQ8WRnP+h7GdQOqlQR8Arg3W0W1KuLDln0+6n747yGZ01o6HHTiZQp3C94ESnbxDl8gGBEbVk1RGYKAx44voZiKvr6DrSRq68tmHCVOElzIbF1ditjTm14N9qJ0+w3QgY4aZiPSCR/dO4mZl+j0KmQlnC+Z4r/F2pP9IxWKD0Gkw6qdB2msRbLfQ+XNod0KRbp2oDogFy0ADu0x3v3U9pZJ73Kwv7ydREWVwg0gXwrMJ5E0d8xP4EvN4Msks2T7p98khYN9Npr9zOu1cBFF4hzxnGVXmG+NMQGahCSFmElpr7qf0OI2xLgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBkFlWPP21OJkYgDYRy7c+ihbD87VeDXGeYepEHx7gc=;
 b=eU4mPF3cOPmb/yldNTWcaPksFW+Gn9GQOKxi0PPT3cAiXZ7JsaBUGpo3QBXX7RAF/VTGCVi2Xm/jBydY/6TI78Vi9ILjZLlLFTXvA2iURnXyDoBCmgv3QcZa4JwuApNAd+YHdjo4u9o+85ca4AAJKsjvFIVKzujE1FlKrg5eIQk2JpNVT3wG/ib8kW9Hd66Al7CCI/A4tau6G9r3R44hCd3FHo/MzL/dgD0sFuHJRm3r7PlFmPHumtdTv23BWWqERMy1KWgYk0kxgaH+lvo+r9+Aptig6E2rwbaRN5j7qDfuFwAX3CpEJx3oJyjzFvowPRvjh04r4s1qEyGZqaOtpQ==
Received: from SJ0PR13CA0185.namprd13.prod.outlook.com (2603:10b6:a03:2c3::10)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 12 Mar
 2026 19:54:55 +0000
Received: from BY1PEPF0001AE16.namprd04.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::2f) by SJ0PR13CA0185.outlook.office365.com
 (2603:10b6:a03:2c3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Thu,
 12 Mar 2026 19:54:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BY1PEPF0001AE16.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Thu, 12 Mar 2026 19:54:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 12 Mar
 2026 12:54:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 12 Mar 2026 12:54:32 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 12 Mar 2026 12:54:31 -0700
Date: Thu, 12 Mar 2026 12:54:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>,
	<joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v3 08/10] iommu/arm-smmu-v3: Allocate
 INV_TYPE_S2_VMID_VSMMU in arm_vsmmu_init
Message-ID: <abMZ9gwr2SAYCl/+@Asurada-Nvidia>
References: <cover.1771877893.git.nicolinc@nvidia.com>
 <71438f280adcf17dc76d56810e336445fb4bf85d.1771877893.git.nicolinc@nvidia.com>
 <20260312171120.00002356@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260312171120.00002356@huawei.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE16:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: ab831cdc-0580-4c7f-65c2-08de80713aa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|18002099003|22082099003|56012099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	wBc4JcR5oiqs7hrwaLL0jvr2XBQLsVTQM8yntfdtc/eP1cbaF+XzkqhSfGrnrUkXl4BJH8pgzTlaYfusnkEkdTRHH1ltZgfeGcPSCTC3CKM2Sp68xSQfZHr9vh0qW3sVGyMC/OrV/Q2Eeehm3MPnxTJpPOx4qPuDfXHka94AKC01QR/QHixViIBQ4t7iMJfxLWT0umSCGpc2924DqJinte6xQurfc0OFsTuhdJLwxTfqa90CNc9UbTV/OytWMjuNlOVNlfunj1/Ml6n/qF+jIsjj2TJDcNJfayubVNs6+xiUcoFROoCchFzL0MMknX3zGdiH3vIKjlf41yx2cwpZdx89OQveK36oN8YNUoSkyDfg4x89jfOHyoX8kAipkEDXHK0RJqYzE1w4+PM/I4YyCQVayLdjx4axEKcLxhvCWmSSwXVFo+VK/2jI+wVChoPxbhKRAur7j6mQrwQ3StU37YVaE9EO1jJQgtZVRUiwz6UiVuPjcE1+JCQw8+kGaRsT40mzIrNgBvJ42ZRmkvM2Sf2kZ8ZPEArA1FsGjbhsVmm6fyxH/pkBUTph5l3eaFJNvrzWFqfL+MRGbKzpl7LOyeI+RvhRpbpcHhd9U9cjIK9dUz258gSOvgDer1LCduRWfMJ7DDVS88fITmaXqWkqc/53PLHDeFOvSCdseWvJbJwonnCLKxlYxGSMrX/u+9Pn61VZbjWEp7jTO/Aunmv6Cx6htScZUncj7d+0tuhj9EM79k+EAlPMJTxS+UZ/+8czGIdrxSbvWlApQZLpqFyqA90nE09NVrORPOOf7+QVCSH7Fad++Ppx84bIpSzhltTJtKFevPS91hKeV6SU/z/a2A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(18002099003)(22082099003)(56012099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PsN3Js76R2St7I3MwUCvmYIu4dUync63beg8iHon6HiegJJvL94n6E261mgzmiCLCAghov4VvXdYUAtBE92/LrrediXZCEzGfs/TkOlkQCQqk6hunkKF/+3nLbGebukfCvHJ3GdZOpod8saZz4UK2X7BGu3JQTfZsw5bECEie7e6YQS+hH2OEKD2ec4MG2Qhg3n5qxyHKPR/uv+1Dy6pWO1HGvVVga1qbAgzpYAVh/fHl4MFSb+HJf9M0YNnyVc225VUDAQQWmrfS8R58mvRhT++OJh9MFtwA7YP7ifa1pjfynWu7/fQ5z+sl8r2jXuhVNTb/qDWh1p3lYW8F0N1pehJaknK6NkiQFkWUhhuYX0WCz+xKOtEBOZH2nmt392OSGtZX4/6+i7XTOzCrWIEhADd/ECHgzRbs7OpKjWOd5Q+C57eNXV8Mb//ViNlog9G
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 19:54:53.6209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab831cdc-0580-4c7f-65c2-08de80713aa1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE16.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263

On Thu, Mar 12, 2026 at 05:11:20PM +0000, Jonathan Cameron wrote:
> On Mon, 23 Feb 2026 12:27:44 -0800
> Nicolin Chen <nicolinc@nvidia.com> wrote:
> > +void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
> > +{
> > +	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> > +
> > +	guard(mutex)(&arm_smmu_asid_lock);
> > +	/*
> > +	 * arm_smmu_iotlb_tag_free() must have flushed the IOTLB with the VMID,
> > +	 * but it did not free the VMID to align its lifecycle with the vSMMU.
> > +	 */
> > +	ida_free(&vsmmu->smmu->vmid_map, vsmmu->vmid);
> 
> I'm being slow today, but why do you need the lock?
> The ida itself doesn't need it according to the docs.
> (it's using the xarray lock underneath)
> 
> Likewise of the ida_alloc_range()

You are right. These do seem unnecessary.

Thanks!
Nicolin
