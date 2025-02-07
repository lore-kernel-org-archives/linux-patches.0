Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD89B2594B5;
	Fri,  7 Feb 2025 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939572; cv=fail; b=mwBV/pcfdNWtY/QvZb+9S13sjMvNBE0X4APsRCbFUDREHgjlYJFhsuV10LieAq08umNqaQ3pbJZQq4+4cO22I2NJylwk8cmMY8z4R35/Kb4dxWsHj8OVILPo28H8DXZOhIND776qXUYiKWisuRbUF6ORuGd/Dqri3PanEBDIxYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939572; c=relaxed/simple;
	bh=TIWfPLb9lZq/tvuvlXeKiUbCbkfZ/AszpTGAeZvfEOE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Qyz9ZECMGWG+w8X0c8zmq3HxPcNrrlXPY1zUbgBq3QwovHn0mmlgPYcgbqwwa7M4moDqWvILSyZUp7OOBl5zoKHqqNo0bJfzDbnNALF5W3ohyIfigdlfqLtqcezibTkJtn2WXIOYo6U/UyNxW0mSANtR5VGb2QPswQC6R+BDKsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SiZJC4cr; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SiZJC4cr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKpwx6jC+Qtj1YDuA5C+H0mxVFOc4Rspmi0840JWXFLzGLy8svcZQHQ9Td9wS3gIyqxRKTGaNlS8jd80W3h0FJMYawV7C3EhBFzbtr6LZ+AS7v5AiwVreDcAQbch+TkbAWrykseS8OcZCL4rxI/51T5F5ETWx8uw1m54qtUmTTOg/5EMVlyZGv2TSo6qiQRaEso0ghTu/1r9fOpEBqUjh8I09zEQFc3FXIPiMgyXUUtdc+CoaRdeW/TJdrzMxIDoVatQWHbaX1/TOxD5cnkenObZm2DKFGzUPBvBhg1I3AEMCNw/XuvQEh/uYWQi7oxo/EZz/QjDdKp2+Cao2cE/AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyEJyJP6g26YbjhPctOAsZmJem+GdQOyXzw7ylfeNws=;
 b=kGxIFfmbZnIiW5EIHA6Q7lc/rdFVE0Bik9CObUFi5FsgID4b+Vk8USYOnfMloQs/1230mhrwR5lQhPj4g76dUSnHGeJQwkYO64DtXgIup6N8ZOsSK4zHh/V7heosZ2Q0IqCc4gEjTiS9qMa9+meav/qNAKwTBEe30scIJJrfnWtiRQczhWjeCc2mdakFU8tEGhpajkO6SU9g4lKdDXKGdkudjzOnlevBMnAJ9GZYvFG2OZnscmcm9IbIWVoCvGkH2uqW4C+4tLLK157IcD1cD7Q+5Vt+5RIYWy1Wsiq7asEs2Goe24s3/puOdsEBbVjK1QIVy9sVCQqttbFGJEkXwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyEJyJP6g26YbjhPctOAsZmJem+GdQOyXzw7ylfeNws=;
 b=SiZJC4cr+8S2Csx0dlLc6/rxRXsqN9K6BfmJCssbt0390RLT/4RWjpxSH/3hWkLqhgjXo+WfujnT4dL2H6Uza2w1SKhYtFuWIYgJPIFOXlriiWYYsWgWDtnPCxMe/XsM9UuAxh5pAxyWnl2yTR3MNrPKQSJfM2a2RdWPxaQ1qqfmVF5Squ6HImpsvjkl/v0ULqcBcHq9ZkOQhn8hv/f11hEvmuzi8BWvfx7xXXJXR068SBne2Zse1chst/Meu75hK4vqUSUxu5TvC9Sysyg3saqLUrs04418A18DQ/n3IGbVUpE3tkcWbxGBD8UuneOKP/DP1u2kffreIEm4dumOmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 14:46:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.011; Fri, 7 Feb 2025
 14:46:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Date: Fri,  7 Feb 2025 10:46:00 -0400
Message-ID: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0260.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dee29fb-207d-4b4e-0136-08dd47862738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PNsBGlQsy1qS5shs6VzNdtc9daWQMqC6IfzpOfc/Te10KNHKGJXBhQrRkcMY?=
 =?us-ascii?Q?fy32KHWm6F26L7aZZLkn/x+JXgT5v8CpscTRpDPJ8GLSBYo2UENAt7CXyyAk?=
 =?us-ascii?Q?/I65bFoR7WMjelJ8LFWoySFQ65kauIpVJfRzuGwQAFgX4CTYZRggMjCfPknO?=
 =?us-ascii?Q?Bm2oiGeOcuHkm7lJipkh4P87yNGgPDXeBOIUjgdTyEPNIDx6aDn1xkrwS/JM?=
 =?us-ascii?Q?W6WIrWi4Q3ICmE/wa9AdCKMIiTyUNga99S02jyPTfhtiKsTDI9jlYJRC2T9m?=
 =?us-ascii?Q?203yZBEz7yy/dHRyL/4vGiDqJP5iWfvkG3hKRk+MkFliGaARSPo7GA6h9CWK?=
 =?us-ascii?Q?WsUwE+i9CLiTUzexpNOUNd2qyKGWMUH+quFjzVnM99mjNes+ZfvxjCTatJ4a?=
 =?us-ascii?Q?m0/yNtfos2cP+N0VGfTKU5Ph7ZrRGMNLLSqZhOPQVdLW1+X8lTJZ2THPuDHs?=
 =?us-ascii?Q?X1QtIHwS1l3/SQnyOeCcZ5sxHxcDpCVlaBpRSXBo7EyPpnlAjUzhB4rEfEEA?=
 =?us-ascii?Q?1Rzncx7ynGOO4/Q2Q1NJtNTnfSIs9Q3K4SoWLVc9r1KcAWI/d07BeltWFJSE?=
 =?us-ascii?Q?ZiUNjc3ZZSnbKixyVuiY8P09HyJuFGW+49N9cCvM7pu4rOR5YCvuPKU2OaBi?=
 =?us-ascii?Q?Tk62UoaPJqJ1QyAC1Z+oBHG7k+uDzTrWV+2JmY8lqoFPwEHOD8aAS76B7Qm5?=
 =?us-ascii?Q?jPack/0xOv+mqhhJpmQJsP0ZXhcx5fTRzqt/6yY+2mt3j/4uvDLPY/aPMVBF?=
 =?us-ascii?Q?/Lay3YS/GbrL5VgCJ/W6lxJyu+VHCDGdDuMCGC2K/HFNZrYxt+JANhTyWOa7?=
 =?us-ascii?Q?7jWhEgLlRo9P2lKEzb58ZBw3fN2IMhbPiXVRiamfB11D2fEDhHJOH71OZbNZ?=
 =?us-ascii?Q?3MHOlngUM6pi3aiH8rudcstIWI0me7GoOu4yZrylj4erb72UxHe6NBTEMzyh?=
 =?us-ascii?Q?SQmqrAwPqKxPkZxlqIbKXjWeuQbTtooGTmtB6jMg3K90PzeiKA/+J5y+/IUE?=
 =?us-ascii?Q?vF537al41GCR+Hk80FvTn62qmlCzHorxktXSVIs5s8HrbY8X/1/GrWGI+ZCU?=
 =?us-ascii?Q?JJVlBiTJnY43ULSQSCxzD1gPpyRskQWKuhLkXMPJhrhpKIRP8l6GUVPUC1Nm?=
 =?us-ascii?Q?VYpEVIDV6pfVE0WBa8RMfhe9+bGJjrMuvLPWA0UVBQ0VA+STEWi0CV6TSv2+?=
 =?us-ascii?Q?Adeu29DkXOh7OUaZ2kQ37OT10S6ZmkRPeoj4BSY4SLzkJptwgTXHvAKG7HOj?=
 =?us-ascii?Q?Ab1jLqEr94VsoI9Bem+F1+eTcyvHj8euWGqamZ/u+Hi6OQW6x6fcDFuKJ3lW?=
 =?us-ascii?Q?8HDRz3BcSLVYQUSbzuj6HsvN7RF+CxvEPky7g7RBn2O8lnV8HmVmB6CmXkcW?=
 =?us-ascii?Q?shwzxlt65IVLi7ecy9QRHgagt3wd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bVpIeRZJ71np7YPu9WoqfG2tUstX5YpHwJb5vhf/mL1QLs0U8D4abxhqgped?=
 =?us-ascii?Q?tcOkmWGHUq/6wePkidoUICer7n0K8AGDeQqkGYU9cnXpefLKz/cjkcPAaEyo?=
 =?us-ascii?Q?NZYFdO/jyJpxWvQD9LOC9uFkLFEA0a738aCCgfn1mvWQ3mY4/CBxa+cpKotJ?=
 =?us-ascii?Q?MOt7OtOdyREG2v8DzoowxY0mLeMA5WLYVjWs8xH1N/chQAyZSFXOsHWXiECN?=
 =?us-ascii?Q?MEKFcGSqtLa9uuRuBsHsRMbnM9qQhaIj+svv08KEO+F/s1QSll0oWX/UasJ7?=
 =?us-ascii?Q?MymAXg3/mvpb6vL9YrWlfEI6xNmLudKPfHwsy3TvKNXpf6oGtjHDglTmXajC?=
 =?us-ascii?Q?2IlFU9kJiVHLWrcPUvSiRHCzIgoG1EgzeBZobWRewqTVXtqK7BbzgGivLe7B?=
 =?us-ascii?Q?F4MdtL6aafvAjY2VGM/2h0Tvqpx/PFa+irKDUXe4tUPVS2FLs0cX8G/Ql6W5?=
 =?us-ascii?Q?zCW5vf++ao1jJMPhBhrIYSrkcipnbWpFdixTg/z70L2c2+naieyvW9Mau/wN?=
 =?us-ascii?Q?FmfosZ5NjN0OlmIxMkIpJjt43Gr+mNxHfJdsFAG7t+b3/p34Ixt1ZrI65899?=
 =?us-ascii?Q?ntRHkvN4wtJlAW+QsgpIVwk3F/o8si3DBGxdGxq6U/WNIwhM8NUJSXKXb1hm?=
 =?us-ascii?Q?fxSH/rlXfVlWoijY1EaVItmfMwgzdfDoypQPqD1EEvXkDFInzl62qa4LVgoN?=
 =?us-ascii?Q?EmNPZZrWPt+inP0UAP6HiaLca8P2EP7g7ueKDes2YtqiIIeSCppAD5Mity2o?=
 =?us-ascii?Q?IARSlaF9k8L6hO+dyFmNPmpjbGIoyrOleBEj41I0WBwJNAY8baBlWSc8bFVa?=
 =?us-ascii?Q?mlBM2aXIXecbn75/BHPWFVCySlnWUCkk0/eTxnB5zD9jYVUWVHw4/oFYbhtK?=
 =?us-ascii?Q?qYD72zp5VlZf99G91s64aV3YVcOPuRlvgfJgrThHUgqBMN6SKvWpSxFHkEWe?=
 =?us-ascii?Q?YD9eUu8LPCdJQ/LhmpNwMHwBdARr+d3WywDjrqhV6XyDUQTQZlHhbywAb9FY?=
 =?us-ascii?Q?ER1/4fhamUEuLeXjefe0e9hoWgE6cJKYeDm24EZ+Dd2qIfw+oCYxfdsqIT8W?=
 =?us-ascii?Q?eAQGLqUb0gAM5q/XEh7LFAQ69HztIuuJp4watj4YJD8KLYDGR9AOXLg+tDw7?=
 =?us-ascii?Q?uzSHzB0LDmuCRcf+zsB83Imj9IVbqx3UUHQBhTGUpM5XBXg8a1WObxJrD2Oy?=
 =?us-ascii?Q?diNRdMQaQJ1ADZJhvLTUmhSCc435muNWLUpfn87yYn+EsHQvAvuSkIiUKrKb?=
 =?us-ascii?Q?bZ5qrw09v/5zuMTfrWq3cKNABb0kyy0jIcyarKfyBDwzJRZLpzN9nS/oMxcY?=
 =?us-ascii?Q?6deKrQyXHPzNiUMw+VmK9T2TF3mlh2KUjte2kZ1JFACPxzkO6uY/TDF0mcby?=
 =?us-ascii?Q?dhxQqquBfL/+Rm1j5/h3w+hz/VQk0mGr2BKY4BwXuyK/h6CVafjjI/hiNj85?=
 =?us-ascii?Q?cwLSNVpmXWVwAUM62LEb1GpRg3VAEhxp9ySgk0HEZAsneN40OgUBHlf2jd9s?=
 =?us-ascii?Q?dGtNxJw8XDCEIQmwZ4qq5mJwBa1EwrwajJieycaNI9fm03H+Vx0EZbN+oawH?=
 =?us-ascii?Q?/OK/EnH9HC9iQ8eYBOGQcp4AC+vyNf4vNYWsvF6/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dee29fb-207d-4b4e-0136-08dd47862738
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 14:46:06.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6O68IxBCtzcb68v+5lv6iRQFtG8gZrNP1E1ozG7lBn28K8qMNYG1/3GeIxFGWtC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

virtio-iommu and fsl_pamu are the only two drivers left that still
rely on ops.domain_alloc()

Update virtio-iommu to have a global static identity domain, implement
domain_alloc_paging(), and finalize its domain during allocation instead
of on first attach.

As virtio-iommu was the last real iommu driver using domain_alloc() update
the core code to isolate the remains to fsl_pamu.

I tested this using qemu x86 7.0.0 and 9.2.0 with a mlx5 VFIO PCI
device. The kernel behaves the same after this series.

However, there seem to be some unrelated qemu bugs. 7.0.0 does not have
working VIRTIO_IOMMU_F_BYPASS_CONFIG and neither qemu works with an
IDENTITY domain using !VIRTIO_IOMMU_F_BYPASS_CONFIG. It prints:

 qemu-system-x86_64: iommu has granularity incompatible with target AS
 qemu-system-x86_64: iommu map to non memory area 80000000
 qemu-system-x86_64: iommu map to non memory area c0000000
 qemu-system-x86_64: iommu map to non memory area e0000000
 qemu-system-x86_64: iommu map to non memory area f0000000
 qemu-system-x86_64: iommu map to non memory area f8000000
 qemu-system-x86_64: iommu map to non memory area fc000000
 qemu-system-x86_64: iommu map to non memory area fe000000
 qemu-system-x86_64: iommu map to non memory area fe800000
 qemu-system-x86_64: iommu map to non memory area 0
 qemu-system-x86_64: iommu map to non memory area fef00000
 qemu-system-x86_64: iommu map to non memory area ff000000
 qemu-system-x86_64: iommu has granularity incompatible with target AS
 qemu-system-x86_64: iommu map to non memory area 200000000
 qemu-system-x86_64: iommu map to non memory area 400000000
 qemu-system-x86_64: iommu map to non memory area 800000000
 qemu-system-x86_64: iommu map to non memory area 1000000000
 qemu-system-x86_64: iommu map to non memory area 2000000000
 qemu-system-x86_64: iommu map to non memory area 4000000000

Jason Gunthorpe (5):
  iommu/virtio: Break out bypass identity support into a global static
  iommu: Add domain_alloc_identity()
  iommu/virtio: Move to domain_alloc_paging()
  iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
  iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU

 drivers/iommu/iommu-sva.c    |  15 ++-
 drivers/iommu/iommu.c        |  16 +--
 drivers/iommu/virtio-iommu.c | 200 +++++++++++++++++++++--------------
 include/linux/iommu.h        |  10 +-
 4 files changed, 141 insertions(+), 100 deletions(-)


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.43.0

