Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192CBA42;
	Tue, 11 Jun 2024 03:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718076358; cv=fail; b=phcaOj6b5vI9GcdhHF95yCrt6PQG9r/t/vkoURz3pfxp7CUHPa+Z0AcFlnRc4K/U+9cnRIloQOIC2/ZskvDWPni9l8+IBos/k7YfsebCQ59x7GT6zACgnNAjcOLRyD0z5Py5m3yUiWn70LF9NThKBr7Y/lQExhgISZ8UI6A24XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718076358; c=relaxed/simple;
	bh=X3kd0TzcglxGSHBrRWNBKVenMuSYrC1vLT/KCI7onDA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qw3T44y387rXy2yedMsFROnV1wZDKeNgjsuVjGOIKqKhguqUayD0MsesibHvHZCBkzflXeKFclCZgbQcWXvXFH8dlyxDAyszWo+LZWJk5HMKEuYzsRBgzNZX/a8DIv1ch4LbSz7y37YpK+BL+pxdRBeltp0QVFnsR2EXRd1gajc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QbtEHThX; arc=fail smtp.client-ip=40.107.243.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QbtEHThX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6ojDqud00OzYDf1smykW0SI+0EiWc0znmTORPPsNg5XJFBfqPKoBWzSZbZGIeFDOjwbG6YqL6hc1mmdc1g/y0L9VBwEi9nx2akdawQxWe8/W11RVuUDagHWDiQiF5aE+UdV8upbhp+68M3BQVH7U1Dnp5ez95LOwmhrOJG16RUTY6BUypBH2+++5BW9k8qV9TWpK7Bavs6iUNJLEgzuOUkwa/VwSZX0ixYMASwFrj8VAZ4qVDbWTwqxZkUYn/Co3N1SC1AlYKMyvQd7NkUWEbXu9fgW8KapFFLf60bjEm+8ikDPJdcM/5stT96eaGdgz0TmHKpoW3JJu6Cp5L6ueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSW3iPhRfaLIH197dcF+Hcc2/Qg+OdUuAp221eyFADk=;
 b=NRAjK6YwYJs5sZaGKfbJqmEXpxrOeFPek534zze2c6BLp4egQrh94XVZUVytYYqjEfC/btrh5mvhGqJH01tgr1iqS/w8Fk+6TGChlLPwOPUye0bPv88UjLWEBATNh/zvdVTsZxg+gXlR5M3mKfVUMdLysa8mTt+oRXSGdGSczLeEu0nySO69CeSFGuJA2cWt3Ac4O0j4Z9mp8HlKmwEnj6mhfSfWbVVfU7obpmUFijZFulYuJYuiex81YnCb5JXgWJKOhCTjzXN4y2CmK6gjoAlQcKaCuzi4YsOHB4KfhoOqzX1mKP7TcKfC8hfcGmHmsvLJWJz6nwyB0cUeT5yx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSW3iPhRfaLIH197dcF+Hcc2/Qg+OdUuAp221eyFADk=;
 b=QbtEHThX4vfpgJLW4I7Q47yRGZipjLWLBs6dvFcODmnK5SzIUyEnDRvIB1ZZpWHMT2UbEzi/E1wfRZ0y0ubxNro8JJwA3ZuEFbKiSKLJ8tsnUghvji81rfwjSqKelSvmDdJHLU0o4Fx9szOs8yWOeIcdWUHRg7Ai895nmRq+FX7K1rqH254BEjqCPmarRudJDrvhCtcphxbWSFvjV/FgLgDDRWcyD+NVxbVzPmNt+d8pNWKmIr6BNsP4sGfGaXf34XGpf18N8I2Q3SRDviPjYAqR0AcL0B2EbN37Fro/4WepaQenhQeTn4qn8EYV8ij7jb52AqQ7spnlFYlowW9nXw==
Received: from SN7PR04CA0206.namprd04.prod.outlook.com (2603:10b6:806:126::31)
 by MW4PR12MB7437.namprd12.prod.outlook.com (2603:10b6:303:21a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 03:25:54 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:806:126:cafe::2d) by SN7PR04CA0206.outlook.office365.com
 (2603:10b6:806:126::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 03:25:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 11 Jun 2024 03:25:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:25:43 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:25:43 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 20:25:42 -0700
Date: Mon, 10 Jun 2024 20:25:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 10/10] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_ctx_desc_cfg
Message-ID: <ZmfDtHTJMq8LG80k@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <10-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|MW4PR12MB7437:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d0db7ee-0a69-4720-3ec5-08dc89c6338a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uGPeXFr2G8NWakZHo/ztTERWLEgYZ5X7mCHFnT8xvklGpFiwlCa2x8eXzbq3?=
 =?us-ascii?Q?ExxjJu3tOABPUX2Hm5OOI4BbnuH0gBApD0n9i6m3UU6bE9xkLcV6uMPnYBcn?=
 =?us-ascii?Q?2CebgPFrBD/qPDcl3E8AuDKj2nwj5hKRfPICKKGiCT3gX3LsDkoDROGyte5D?=
 =?us-ascii?Q?CpAJXIljDqZiVkw90jrU4qwfCFPCShvmo1Tj9oEBrK9e+psA76ZhmJvoiIt1?=
 =?us-ascii?Q?8Uaugjh+kzN9I9NoVPWQjXeM2HnAQGN8v0kG+tOVYt28BkkP/d8xzrODloWB?=
 =?us-ascii?Q?NHx8DQ7mu8UOito24Yvp3odeFsXl4/L9L/dgrfrOWKYYWNfE6MqRvK6nkBOI?=
 =?us-ascii?Q?Yg2hPQbe9apwRVRo2KZ7TwgvXkmb0ydbzbosyPQtsEFF8Kz4k6QlVd4aq8pH?=
 =?us-ascii?Q?k1S4MPbRS0HRUpxL67KyIvTQsQaihIjRf+Z8wV86uu8Vza7DsmDmaKHbBGsn?=
 =?us-ascii?Q?CRiy8ghxNMqgTj0Zk5bthKdfIG20wcUbF4G59WzgL1FjrtCZ+GLkOPDuz16u?=
 =?us-ascii?Q?fuC1//GfGD9WFC8KHeTbLBAvC/7+YOYwNmm/D6gFgB84MEe8tAxVKmNcwh8I?=
 =?us-ascii?Q?wKLYBH3RcFIObkYm0IGIOOzjTruLjXde9XGJJYaR6HF9c+WjxUR05SoWhpwu?=
 =?us-ascii?Q?vOFgpR4ghzXoO5xweVLbT0eM63scBjcrusLqqxlGfijkZvO9nbndy3oSe0zh?=
 =?us-ascii?Q?QHiIgTw6b9Z4affzcqaHGXxT/3YafUwUKRaJ9HjCTPbkhHsMSYIDWjVVovHU?=
 =?us-ascii?Q?JnUsO1cjaPSORsslPZ9Gr+dspTKymsEIPAclJNoaE9FsiB4WRyL8E0y9t/3H?=
 =?us-ascii?Q?299dDXtievMz7LwrvAAU599pYAKIrY4sslBjIC+6LyBFDvKg1qewg7eueyvR?=
 =?us-ascii?Q?zhiXgA0DcPNp1KL/NaY/T5n9fEPV9bO1Uj53ChZAX3S6BNKxP26ItC6GqZVy?=
 =?us-ascii?Q?o/GZdTKfPUJdSywleBfUWmWa6neUjVuJKU+IJAGQybUJ0wgKXucjxnvgM08l?=
 =?us-ascii?Q?JfKUGSuVmKgLQxQWhhq37vly26zCFFTD2dNOzxTsNHLXpvXADLWCMnpuMGAI?=
 =?us-ascii?Q?7dL3qGOpehqnVijjdyUMfv4hHrm4euoqTitUEraVD4Fepu6JuPYzaLNf9dqx?=
 =?us-ascii?Q?boF8fGR8h/1wqN4WU57Hf7GMbmFTAGRWBLgW2RA+XuuUWFiwEWIohPKArwkK?=
 =?us-ascii?Q?A2e84GQIl95sRyoeDFr9D2s+zB/ETodqjuJg9kveypC3INh/n4P+RyDIH+2C?=
 =?us-ascii?Q?qyWjdxB9DR2EkiG4bdkG+aqwJXJo/uCpmBZYxvHZHEs4Tn/oZI4MOtPMwKDm?=
 =?us-ascii?Q?wbX2IjQzZVBNG93vAVwZ6GLc/2e5n+WpnIbUfjghekNNQi6+bvwAIR+21qKQ?=
 =?us-ascii?Q?/fhaYyF0W/gTiiKC2/Ec5IcfMumByVVmyUTTgaF7KoSA133QCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(82310400017)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 03:25:53.9589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0db7ee-0a69-4720-3ec5-08dc89c6338a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7437

On Mon, Jun 10, 2024 at 09:31:19PM -0300, Jason Gunthorpe wrote:
> The members here are being used for both the linear and the 2 level case,
> with the meaning of each item slightly different in the two cases.
> 
> Split it into a clean union where both cases have their own struct with
> their own logical names and correct types.
> 
> Adjust all the users to detect linear/2lvl and use the right sub structure
> and types consistently.
> 
> Remove CTXDESC_CD_DWORDS by changing the last places to use
> sizeof(struct arm_smmu_cd).
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
