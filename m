Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5559433E7;
	Sat,  6 Sep 2025 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757144825; cv=fail; b=X/r+F1PCubV3ldoay3smIB1UPjaWCSKRAePTdfidtq+1Fhcg9X14XP4B4um//yinPLzzGgAJdbmMZ2lAlDFcf2IShRYBJu+UsuT98nMZYaJD1NvoQMfQqY39x5wujL9SL7JPXx4HznRDfGoYhKL/voeVzH85tzHC+Vu9t7NGMpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757144825; c=relaxed/simple;
	bh=ZaL0daOiT+3DxHq2GVltUTjLW0WgJUatvxS3u/LZNV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMhzhE+VCwrA/Kq1eRGtX7TUpkTUNbrbNhmngfOzky6wJTFEIYjEY2o+qDeRdyQI59rGGl7F3i3ab7AC13yDukIh4F7gcHJBv9Vr7MbdTsFzdeuGLCZDCnMiZ7uywjwkaa9x4+OpbNNxhnirGGVzoTPMZMZcyQA2Fd7OpBrI3PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dLzQ0J+2; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dLzQ0J+2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J2aR226lpNkOE7KLf2JZeuYVSFRK5tRbtV/3c/X9LBaHRkG7L8G0B1uHDR4MQHY1pvsKx0HDRu0ZdNzUEksFzX/QKf+4O8NxEAuNsJui9YghSSorW16wQCGtNXjQJksDVjqFVXYuBsmFQhZjDs39yqhvA+tJlNT6o/RDdch46+ILIxAz9p5l9bY5wv/t50aH0Q6OANB6md97iyPfYgKSZ1+LQam66G4gUGYrrXJTmqlotTFOpcgifobvwZySKonx0/HNaqUuSUH/fIAB6hP+jCT451+TP9G/tPwWMDkcBJYQib47gefOz99d0q5QjTQeNulBRIRlMCYaZbmMWMMDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B53SDGsYvVBR4Vi7xmTaxQdf5wiJ/kzNAhA9Vo9L/dg=;
 b=RvfsHUF4f1fDjX6oEBR/o8HNeC18wafHkqHT0zpNYmiSi/zF5urON47enKJsio2bGgtP+hPhtJeULreSjAHva/HnFV+1aAEbOATz316DGcAx4aPZfdY133Td7Oy14oRHBQ5JQlGnd9+Q+IBtOVjhNVovr6UU0/fyBFgqdPzXob3+SFZQzbrw2OMMMUaWLCERrnmGmeIUhF9PWKcExZpU8vQ2vZ/YnCLp6g++FL38jgCk3CJe8DkKPDV6dAN0vSNYP4e+zd1/Veu0OzUtP8iz/eJFwUn+aHIKuP3/azlYSBvGOdwH395KDms+IL/uzBCrO6oK1M9BCj3uI0E3jR65YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B53SDGsYvVBR4Vi7xmTaxQdf5wiJ/kzNAhA9Vo9L/dg=;
 b=dLzQ0J+2IH2T2PUFJQ5/V9H8KWqnyPj3cQE1AMtn9o9f2IMaA5cBbNd3daSKVLF30yXJmI9YMxqC+uaMdwD1csGGFYoP4yX52kEAlvojTzwV4IWZpEgqRLwTCwvThucnx1GGmHZ7QsmdwNkSuKBUnW0AMflkw9VCIiAtFrXFMMDaY/vBjvzJl8TrOuFYf080Tbc8oQlYlD2s6qwsKa1Zp9WPByKMHE5LbPZdbp0eiPyBSTUsL6CMYEKo+U0f1kkhFux+sc8GzDmG1FEjhqULeZmI16UiWqs8EYE9kzh2h5RHrGOrf6chWNdidOi0wM2FjJVcZc6K/sK+PLtJEfMODQ==
Received: from BY1P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::10)
 by DS7PR12MB9528.namprd12.prod.outlook.com (2603:10b6:8:252::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Sat, 6 Sep
 2025 07:46:58 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::f3) by BY1P220CA0015.outlook.office365.com
 (2603:10b6:a03:5c3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Sat,
 6 Sep 2025 07:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Sat, 6 Sep 2025 07:46:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 00:46:38 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 00:46:36 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 6 Sep 2025 00:46:11 -0700
Date: Sat, 6 Sep 2025 00:45:58 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv1 5/8] iommu/arm-smmu-v3: Pre-allocate a per-master
 invalidation array
Message-ID: <aLvmgXW8BpAyXMVV@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <2b55869f698340d5791210b9a7e542f81ad20bcb.1755131672.git.nicolinc@nvidia.com>
 <20250826195641.GB2151485@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250826195641.GB2151485@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|DS7PR12MB9528:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a84e703-dbfc-4aef-958b-08dded198e9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b4XdSKxIa61ZHBXgEetlv1YeOtfnDsuT8XWj17IXe+q1yhcCy8+WXPvRFGLg?=
 =?us-ascii?Q?IDPiUpe+sTShN6jD09zmzYdSrnV3JWFC9qIFzwsE5od5X9/Ff1pZnmwyH3iU?=
 =?us-ascii?Q?HEJCY/PBGKDNlx8jqlMqprSOLEz5HJum7UK8AVwlfqYGJ87g8Eb747fiG7C+?=
 =?us-ascii?Q?Ic8JgghrkyuPdILV8o5K1JSFpa6CJVm9nrxX6kVa+bx0EFAoiOHpa/FqgiW+?=
 =?us-ascii?Q?0arimlXKeAsPo/sCMhEoNdvXj8PCmIWwC8k73nu2myPtobuxXVlHn3q/vKyb?=
 =?us-ascii?Q?xrc9Ya3bQmIDcmEPg1qdL7YlH6LxOoZ+obAASQqFVDfvNP7CXeGmQONPVnwV?=
 =?us-ascii?Q?DO/Hry9LfLFW9FkgQQvUghxwxAVXmMj1qryoynh2Ynq3er5j9rSTg2sQ2MxT?=
 =?us-ascii?Q?PUllKYI9WNe5pScN03JIjbrE/vev782/AG8Z0Wl7j2MG8MZ6NDAiHABTXzH/?=
 =?us-ascii?Q?laHcy3BbAhxKQAFuCYXbaqkD04wthJryyqhTMNfwRougY4MsV46TIuwL4raT?=
 =?us-ascii?Q?+1jnPgGKichPdQQCxHurjlo/81qztHoDeAXhmONYf20fOLISz0jdcq8W0YUh?=
 =?us-ascii?Q?llLVqt9Je8cZ5wkI9Fzp7UAnc4RvUxTVxTsN1QHPjaMsIZLCRm4lRibmJJXx?=
 =?us-ascii?Q?VZdN1UU9j5ppadB7ozcXCnuRIBy9N5YgouSiHyOoeD4jVGAl/3gArfFggPnq?=
 =?us-ascii?Q?abwBbbCQUTP7TunlBC72wYRLB0lLJJiil63IVHvgJquUrLTaK+9Q7d4SIw8S?=
 =?us-ascii?Q?V8bTZZ5EmVPnX1zom24tohpxQGHWJhQ+cY/gWIACxQplnYBXkD040D3MZX4G?=
 =?us-ascii?Q?VwAEHcpQVrkjnlJduNNf4M9EMmsH7/u+ZcUwMKEUfeoL1zPb6e83lh8w9EN9?=
 =?us-ascii?Q?hKpm80qnUbFoHGay0+FJvtVL3/OC1t0knkqOEb+JDtMwrefqeCpDAZdhnZ7W?=
 =?us-ascii?Q?X5WCffDlpiz72DhX1bHz0xQfk/OCTD2PG9uxYZwi+dJ0XODoHKACn981DL/n?=
 =?us-ascii?Q?v3CF6TrMPePpkDcgD9Pm6QcdnjBPkrwPwv+Y8ScxbGZELvxl7xFN18EMkPu2?=
 =?us-ascii?Q?CNg1slh9ee7NHNCiyJh7SMzH0qupT2SuEc8Jf++E33IStLjruA7rkhYmifv0?=
 =?us-ascii?Q?DoK3HvB3GQju71fA85x7uQQeQIbNqBFKBc5mqRHNLfwuB27b1KZ9750qw8hh?=
 =?us-ascii?Q?neP4Qm3TyDfG7ALslmXz4SZG+BNU9KMtRPONaZW7AwgzXYmJBi9OPhkKyM/x?=
 =?us-ascii?Q?3BgjMjV5XJ6nYVwzhd+Y3PjSFVCgp+0SaLVEL0t+dQgwPTEbivPUmhHMqt0a?=
 =?us-ascii?Q?mIBoQ0XO5XOyS4HaQsPKReI8DPHRvw8Uo+2iD4RSJy7DysZ8La77ldPBcutG?=
 =?us-ascii?Q?fVNYK7XgLUbWBeLI12ft6P00KRQMhqOHZr09TFUcqG4b4fZ5q9BMzdjYvb1E?=
 =?us-ascii?Q?GjrXPWUDv8A2xkVPs/wvfQ4I4+8XT33Z2iCGxH3EzRqrynywHY+n+vuOU7/H?=
 =?us-ascii?Q?MjO5j2cuQEKWBElOOcRHr42b4JOPDg/j4iTm?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 07:46:57.0486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a84e703-dbfc-4aef-958b-08dded198e9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9528

On Tue, Aug 26, 2025 at 04:56:41PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 06:25:36PM -0700, Nicolin Chen wrote:
> > @@ -3730,6 +3731,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
> >  		return -ENOMEM;
> >  	master->num_streams = fwspec->num_ids;
> >  
> > +	/* Max possible num_invs: two for ASID/VMIDs and num_ats for ATC_INVs */
> > +	master->invs = arm_smmu_invs_alloc(2 + num_ats);
> > +	if (IS_ERR(master->invs)) {
> > +		kfree(master->streams);
> > +		return PTR_ERR(master->invs);
> > +	}
> 
> This seems like a nice solution, but I would add a comment here that
> it is locked by the group mutex, and check if ATS is supported:
> 
> 	/*
> 	 * Scratch memory to build the per-domain invalidation list. locked by
> 	 * the group_mutex. Max possible num_invs: two for ASID/VMIDs and
> 	 * num_streams for ATC_INVs
> 	 */
> 	if (dev_is_pci(master->dev) &&
> 	    pci_ats_supported(to_pci_dev(master->dev)))
> 		master->invs = arm_smmu_invs_alloc(2 + master->num_streams);
> 	else
> 		master->invs = arm_smmu_invs_alloc(2);
> 
> And probably rename it scratch_invs or something to indicate it is
> temporary memory.

I renamed it to master->build_invs:

@@ -919,7 +931,14 @@ struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
 	struct arm_smmu_stream		*streams;
-	struct arm_smmu_invs		*invs;
+	/*
+	 * Scratch memory for a to_merge or to_unref array to build a per-domain
+	 * invalidation array. It'll be pre-allocated with enough enries for all
+	 * possible build scenarios. It can be used by only one caller at a time
+	 * until the arm_smmu_invs_merge/unref() finishes. Must be locked by the
+	 * iommu_group mutex.
+	 */
+	struct arm_smmu_invs		*build_invs;
 	struct arm_smmu_vmaster		*vmaster; /* use smmu->streams_mutex */
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;

One thing that I noticed is that group mutex alone isn't enough,
because there can be two arm_smmu_build_invs() calls during the
same attach_dev callback. And the second one would overwrite.

Thanks
Nicolin
