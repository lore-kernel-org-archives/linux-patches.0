Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013000.outbound.protection.outlook.com [40.107.201.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417337FF47;
	Mon, 18 May 2026 03:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779074890; cv=fail; b=sg9hWMrfqsEQZ+8tY40oYmSTI5qj4qge84/Cw7iqXraObKQOINosbFxJ1YoityeIO4mDLlUCP+IgTwRRFRx2jaIJ61/dnm9Lzyy+fd0x+QuiJ57qF5psjzmHJXo6uATcNNkUpk3a5PAIhI4VpuYGGvcwpZjFMRgT8TJ5dllF0jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779074890; c=relaxed/simple;
	bh=bk61HCiU8Nrz4tAy6XLL6eKDW7dznfNM8ogzku0INIA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r80IqIUxHbd3vsiAdDyYKqkNfpG70TF5RvwbiFjiTeEuCOVx5pwWaZ7lmOHY7vniiCdSylVf/zp3TAy8y9D0THJfappkbJmRh8x9RV7i3P8fFcZZzeGNDzz9kUu+MT5cGNDtAtQeDcSRfT+Gej1bmnKujBBipHP/QpN6xzXkyJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IUOb0sBP; arc=fail smtp.client-ip=40.107.201.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IUOb0sBP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LUXaHs1D0ocVvE9lF/0PSXG4UBjpQCYygwncC6h7AMEiEe61/rwkfpEWxVB+jL6Ws6IRxauBh10bs/QRt7Wevri8AYnEGMDBRChWGyaSr/n+WPw7RPFtbBkzQG1znapNWFEKeNwqa1zaTqD74lg7sjJb4E+3F6Rym1WOgs9t1pn80qImmQ6bBtDnN4P6zDQfJrky5B5gqnhjFmrftCwMZPNSysy+cqiCL8MjJQ7e/3N9jy37nPxciBM1HuH+/LZH9JizGa0rKJcYbGGwL78yvMfWAC02zkaZYhPa47HZwbVUds+qiADULS788s4cbtZ+ZG7Q5gUpl8+cLSMaE3osrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0j2yZM8fD4C4ChUvb/selEIH6WM6hnI8Hpz84bhdQpc=;
 b=cbwKo5FHbVUGTFXayCKFgmwu07RDoOJrixnRRER3TvApmOhkLkL0qLuAzXcRGMxstWCpBIYmFW9oy79GmmfDl9oTBf7xT9RRaUnguCW8enLplQfpagA//N9O5B2nsNYBOLu/HRHmcFbwMdx9i0e/z1BR+3NCIPFgnNwnuSvAc1WwvrzeqQiDhVte6F51CLG3lRYEDYU4EmobxXxZfEeq+6J9C44AY3sO6WN1UjT1xDgH4npZXGpX0ftdmMvw34CeGiqPxD6rcWK3UidA+IIMsHrVvXz1XcmJ0tCaesdkafFtKtFftuAIT/lLh55UN8OZlLcCPK9HB4gyX/cKoP0Abg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0j2yZM8fD4C4ChUvb/selEIH6WM6hnI8Hpz84bhdQpc=;
 b=IUOb0sBPu65S5dKPCGOBkkj0zFvt9knOjjbbzJRHhuIH859fPqB9lsP6dnqmWuMEZgy1jKTTXHuHpsgkgjJfu1VO1JjO8Zdgs0aWS5+1VdAHThk+5Ciawfy85VCZuqn9gsBH4b5+tGwgMpfCL06wcnLmJu0JnoXANrvIuCHFP2T0izwK5FvL1RutIf3qQPe5zeF4tOpFRUyWmMA/bm7f8u4QQnGuufwLxiBBBD6tGbPj2WGn+43udgC10O+kEOznWCYdZkpPl3tKcKSNylprOGDSxv0wknm3bkYG6OMry8IM5IOUDOzrjGYeynHVPx3TRS9XpWxGKJ6ghBernlBxYQ==
Received: from SJ0PR05CA0201.namprd05.prod.outlook.com (2603:10b6:a03:330::26)
 by DS0PR12MB8246.namprd12.prod.outlook.com (2603:10b6:8:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 03:28:02 +0000
Received: from CO1PEPF00012E5F.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::56) by SJ0PR05CA0201.outlook.office365.com
 (2603:10b6:a03:330::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.16 via Frontend Transport; Mon, 18
 May 2026 03:28:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E5F.mail.protection.outlook.com (10.167.249.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 03:28:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 17 May
 2026 20:27:43 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 17 May
 2026 20:27:43 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 17 May 2026 20:27:42 -0700
Date: Sun, 17 May 2026 20:27:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Jonathan Hunter <jonathanh@nvidia.com>, "Joerg
 Roedel" <joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-tegra@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Thierry
 Reding" <thierry.reding@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>, "Will
 Deacon" <will@kernel.org>, David Matlack <dmatlack@google.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, Pranjal
 Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Message-ID: <agqHLMyWkWRlx0pU@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <7-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E5F:EE_|DS0PR12MB8246:EE_
X-MS-Office365-Filtering-Correlation-Id: 435a04a9-ab46-4780-a21d-08deb48d7794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|1800799024|11063799003|4143699003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ICxdp8FkFThe8DuDZDrcIraumsr0grlAQMOlkG3A0HkscBrNilLbA1IizB3p1f6g8mO3RXnZVvdncmHscHO+qsHBdh4mZrJPt/t8yVGFObDIkdYg10WESF1TDq37ogdtDGe6++yys1WzzQ/zgRjbjzaKwavyaYHjegJGpCqp40WFvwLYVRHrYKBh7BR3MCoQINjf2lyhdzz6+/yGvb9+H0HkhRMEK97zwQUw2qGWo7zl0OBsxnxMMzYFQdSKTg7hOYdaum93BNXu8+T/VSXlAyCj/YdLhbYXe6UgjmTq24Ktrh/5zb2x01l8RU5/pF6dK8z2dHEbNhnKV/ZIa+9e2kfH2NYvZAZ/vZtgKJGbykzZSoBBC3fLdtHxwwYmrLgF9p9N13ubcg09L8oXj9paO8xD7BSJsMid82g/BJoA8hkRbh0Xr60x4U4t1k+ogWvPrNamO4booLBuPpFm9wDsKIvq8MFICje48BSlHxSD/r8BvEKWIQmJ2WTz+UmZ6OxaJtgt7sYVzmFFiflVLqd8FuqzKuf9yQMES0qpyYeqkAuY2O3Ndh+pJTDrq4a0aRiod6tjBjxk4J+G9pTUEuB7Kaxenj/dN0yh5rzFuoD2lEd3SGW02X4kwpcu6AV3Gv4WhxYALWUHwwJHIdN6gbn1OXxvIxyDQaGgF1kqdv7/goRo/+z4OEscrt/v3Ej2TXU0jaRU72fonYANNpCOjdOeQFsF79zOfNWOtmjCyFULSWw=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(1800799024)(11063799003)(4143699003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bzKdTjtzq7MlPaOY1YDwogYoAq5dwW2n2gUI1S9n8478Vysa8F15GdU7+0ZaCfgw7pXEu/NKpz3Mmozmx8Q/lCrzkdAaRa0vsBjec8sMq+rOcEUiVztoeWmOyYwizt8lSXVoHgIQAsy4fLaLNl6tQ/+xml9X66BWFoiD9RooQgFS4v0nT7azkRD7XHMiwuk5AovXBCRuMEMNIdCLT2gNVJcVW82NB/B7HkU9BPiCIcz55l6NxakIxOlxfSisDFHqDPPqdrDKYhMNO92+1KadBB3KrMJSsYDirWxsN9EeO91Kc/+oAxeafZKfCpWdNLY4FiRxOZa0lVbKSrjqM3EhdKdi7prUiDrO8wjQcsmRM8TKiKU0y6z4z1L2Z/PGPGEcYV51Sg4iP7I6YqfSteyRsIwCLnAGmXfrlZXnQBlb16uThw1VoxalrINn5CAhZaNW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 03:28:02.1887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 435a04a9-ab46-4780-a21d-08deb48d7794
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E5F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8246

On Wed, May 13, 2026 at 08:57:46PM -0300, Jason Gunthorpe wrote:
> Add a new command make function and convert all the places using
> ATC_INV.
> 
> Split out full invalidation to directly make the cmd instead of
> overloading size=0 to mean full invalidation.
> 
> In section "3.9.1 ATS Interface" of F.b the specification says:
> 
>   When the SMMU returns an ATS Translation Completion for a request that
>   had a PASID, the Global bit of the Translation Completion Data Entry
>   must be zero.
> 
> Even though it faithfully forwards the G bit through to the ATS
> invalidation command there is no way to create G mappings so there is
> never any need to send a G invalidation. Thus don't expose global in the
> new helpers and leave CMDQ_ATC_0_GLOBAL unused.
> 
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With a nit ..

> -static void
> -arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
> -			struct arm_smmu_cmdq_ent *cmd)
> +static struct arm_smmu_cmd
> +arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
>  {
>  	size_t log2_span;
>  	size_t span_mask;
> @@ -2395,17 +2386,6 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
>  	 * This has the unpleasant side-effect of invalidating all PASID-tagged
>  	 * ATC entries within the address range.
>  	 */
> -	*cmd = (struct arm_smmu_cmdq_ent) {
> -		.opcode			= CMDQ_OP_ATC_INV,
> -		.substream_valid	= (ssid != IOMMU_NO_PASID),
> -		.atc.ssid		= ssid,
> -	};
> -
> -	if (!size) {
> -		cmd->atc.size = ATC_INV_SIZE_ALL;
> -		return;
> -	}

.. should !size jump to arm_smmu_make_cmd_atc_inv_all()?

Or maybe add a note to disallow this function being used with !size
and WARN_ON? The function name itself doesn't sound very restricted
though.

Nicolin
