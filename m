Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011042.outbound.protection.outlook.com [40.93.194.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A29395AF6;
	Thu, 17 Sep 2026 02:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789613067; cv=fail; b=NQsUyyN31pf26ImFVWtF9NZQCHjKIKRjUCq3wYc93pnuExUAZQPHc8Z/nzW5NnbU47HBi8LQt8qz+338MCMr+v0LdgJzwSEqAUQ0ml8Po+jpZdS2P0y1u4qXmC7RSCkRKVG+u+rVACwNUXygo466n9cgdmP/aryKvbk2VylWUh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789613067; c=relaxed/simple;
	bh=xH5ZWwTToQDdqHkaY2tiejcyckbYNSmFmKoOreMEcts=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFUL7xV7aR8mFAIH+ltmXrhsNB/aIKW+9W3+Lc1n5/y/rWcbTikKpR+mCd657ec5alAPzOOiiM+yL1QxU5em6JhQGuWMxcI7i3Yo4+TEpVx3Aw7zREgueXb/V4Aq5ya4SoFpkDsu9hVU8UmOKAwhGTEifpsgVBINS23Ac2XFmbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o6yIW/38; arc=fail smtp.client-ip=40.93.194.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o6yIW/38"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wNizo4wEvduG8zimjRzfVXR649oghGybxgnN+AGrApSw0YLEnUlkUMlocKTC9uN4CtSurkdkt+VFbnmOhLoddawyT5a/ncpdmhBUuA+1JTNvZD73mVkCKLsWTtLDkm+4ocAZgjuBroXbxf5XEVkhLNtymDdnB6tfGn+2OmMOFJ7QWeaY7VVuUzo7UWc5yXQHGY1mRFhhGgI3p0KLGkxcyiatGIEIgHFlPAkoORLj7bdosRVCSQSbjFcrSjbpAesR978ch8tQKyulTWMJBS3xKOKwRdzjoMP2VQ/If/nXADZKaTloZjr2MuKSrDOJZYIX6nlrrpGygXBqLb+xdKasNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SgmpTeddKoYljOoFhvuONdqPI/uJeGpN5GkIusLcQoc=;
 b=IWWHzRgdsbLBNecZ1DPEFE/yTZSfXa5as60N1SmTyD72FR354A0Sm8o19+UMuWMYMaU8+SkfDvVOCq16Dqh/C/p7sb5dNpQ87I9WBsnLDZajX1CqngThnBgU6BFSl00EHXdLVC/vAGlt8Wc9XqSoZLZ9qgPYhByBgL/AXeW+s1ixsTMx38ADPTcPwYguG41EHGXpkKRHLHfo31xumu8XVr1e5c46sjWbKTeyGjBxIRQvlDJo8sJBo5MTdX64uFYTQEkJPeZI8rMx19QpB+Pp+L8izuZE0/sDIQbpQDY1Q1+m8WYVpIlstfH2bMxX8AZKrAnekxmw6wkbV8UbSh2xRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgmpTeddKoYljOoFhvuONdqPI/uJeGpN5GkIusLcQoc=;
 b=o6yIW/38RF8hKv6Xm7lcScoYw05HTp5xKoM24CNJ+/XT98xb9jQE9Hiy1TL7789m8vBHzkcOAYM3L1RNh9FNeNOF+rRV4kpIMqoNyWVsGTCV9TGcfdlcoTv1fVPt5OwIdZE5Hr4jias9+2oS2O8jh+rzkJXX59+4O/THgEodUl+gsCWC3HhWOYag9spidgn16AnOFipaxsA37p8oOsDykgzwQ7mgrlnSvyE8m6Yu8h843M4d5S4iEW7Ij+4lIPlbdvca7GAFAbY9nEN9+I9yLUebazsGWpxvEYyLyVpBax5ktAE1UYZNa9TQOK70lTu3MUokoaFpgmfxB58nE6VYjQ==
Received: from CH0P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::13)
 by BL1PR12MB5969.namprd12.prod.outlook.com (2603:10b6:208:398::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Thu, 17 Sep
 2026 02:44:10 +0000
Received: from BN1PEPF00018070.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::30) by CH0P220CA0011.outlook.office365.com
 (2603:10b6:610:ef::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 17 Sep 2026 02:44:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00018070.mail.protection.outlook.com (10.167.245.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Thu, 17 Sep 2026 02:44:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 19:43:56 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 19:43:56 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 19:43:54 -0700
Date: Wed, 16 Sep 2026 19:43:52 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet
	<corbet@lwn.net>, <iommu@lists.linux.dev>, "Joerg Roedel (AMD)"
	<joro@8bytes.org>, Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, Randy Dunlap <rdunlap@infradead.org>, "Robin
 Murphy" <robin.murphy@arm.com>, Shuah Khan <skhan@linuxfoundation.org>, "Will
 Deacon" <will@kernel.org>, David Matlack <dmatlack@google.com>,
	"Jean-Philippe Brucker" <jean-philippe@linaro.org>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<patches@lists.linux.dev>, Pranjal Shrivastava <praan@google.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>,
	<stable@vger.kernel.org>, Vijayanand Jitta
	<vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 0/9] Organize the SMMUv3 invalidation flow so iommupt
 can use it
Message-ID: <aqtT6P1TsQk/N9dH@nvidia.com>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018070:EE_|BL1PR12MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: 8be12ea5-2c6a-4c27-af33-08df14658d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|10067099003|56012099006|11063799006|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	IawGfcGIMVj8lmYRixAmPB0OEJtGoj7Wu9Vwa82u0RSifFtfOuZBCtAykROe3z4xk03wZPY8SZFVYpxlX+3848r9V/7gfBvv1VT7Yp+G9Spa7zm9xfya2AxoSO6m5IjVYP2+cTTZpYsXrdwoAilgOmo2W59inYJqAunvGxVq8kAPsUKWDW/wFT+lv5JRsKu4i3WP/DWP3X0suGjaWorRVbZhOZlAC0qf42UNYOQkYBZPfI7LSe38P782yBDUFkDwrL4H1ON1utyN1NxSQI4iYdJnkClT1ADmcdPhs8kQhXxuRKYS0FuLbigcUcqfYTR7GXpMbLqrg7vJfbuXYhyznQ7ZcxCU7ZUrOncRdkhxdA5mWgG9LXFc5kNYv6G/QwV8SvjQ8xndUFSH9f8Xpi8tmub09EV9X10l6HK5KywAIAE6CuzrmLbSQhURcQ/7Y14iYLh7SOOLfdASSVChNLAKFM7neE3xeB7pMSVdbynWgX90j8o9YuE//cHkQ/kaTMZRlGEK9CNmmljDQVNJN/QGdm5ea5CGC3Aw14PY7J7OGq9Jd+x+6Brknd7JHhh1U01NWqgN6oL5J4IdHQU8co1WOzZDOmsJzebocMxIP52KOxKqrhqOl/I0wbaQZAO2kxSqTq1DzGOnWQN9xg1jy3EOUNQaMFPt/ELABisRfOgorWMbGyAmRUKmk0KYP1E2Y42DyEIpwHaxoyGEyHdcGoJTDA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5UdHRKKRXhP0KikUbWzpX7cmE8Vyr9XfI4724KWiYsJmUdD+t1APAwZ936VVPoHg5aZLm+qkxrZ5TvvXzzUbHIuBtbxUN3qDFfx7Qna4nomJ7bhpMSZEQDGrZXrkD/2M/4Ks29uFcppHOfXbmLDlVwghmgHZfq7aDLXbY8GOIJuA/KGWtgLDb+o8OhiVnmWEedmzLDj4TkyOv0n/XRLXL+VSfH8ukTqLERWrLjxfxwA3rSZw8mKadFwGfHT2qej+0+TVlaL5pFN31HQAoyv6DCTNHBaooKULaFWLdYOI5d8fX9tcibByv0jbtHIQEVzh3SP9yaJRzkjKQX5Hz+l8jM/Vnp5qaV4VEoMmySJCw/7c+Vsxo3a3FtDWbMV/MTmd/ZPEfROJvC6bNi+zEMHAuoZ5g9j3zeJzQSrL3k0nZtrEAEwCeakJHSw3a7QISBCp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 02:44:09.8198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be12ea5-2c6a-4c27-af33-08df14658d04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018070.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5969

On Wed, Sep 16, 2026 at 09:27:41PM -0300, Jason Gunthorpe wrote:
> [ This is part of the patch pile to move SMMUv3 over to the generic page
> table, the precursor patches have been merged now:
> 1) Organize the SMMUv3 invalidation flow so iommupt can use it
> 2) Use the generic iommu page table for SMMUv3
> 
> The first patch should ideally go to -rc
> 
> The whole branch is here:
>    https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/

> v6:
>  - Rebase to v7.3-rc3
>  - Add helpers arm_smmu_pt_level_to_lg2sz(), arm_smmu_pt_lg2sz_to_level(),
>    arm_smmu_ril_calc_scale(), arm_smmu_ril_calc_num()
>  - Remove unused leaf_only
>  - Combine has_range_inv and range_inv_scale_max
>  - Clarify comment on arm_smmu_iotlb_sync()

S1/S2/SVA sanity runs okay.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
