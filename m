Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507AEAD49;
	Tue, 11 Jun 2024 02:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718071276; cv=fail; b=PcHQ82eUh6JxQXEqtH9BhMTPqLqwiYLMCenbAGPsvd/RpvZqfEEWFpJHj00YimZU8S6Gw1iy8YrWPErhQm75hqUaKHBaikjdJLjptzXiZsmJlzqsSK6kY21Dl2tNsjRjdApnVv1smtiC2wFBFPm3vOdVkLJ67zzF+OL3JOBv8hM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718071276; c=relaxed/simple;
	bh=EtEsNZpMIATnzw5obcBG8/4jg00hHG8LTYNlzwy2H6w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XP7fm4jSg3RRvUKfMVia15Zli2tSgnXIExfq25Y+i7CYmLmpCYBQ2t+Je1NOo83HEZXMTosjYR65OA23dwbZcjpICaSjfwxTKY6TuH7apbQFEMM6+p4oFXF9bng5vmv0JdJ/+ElhZlMDtG2q/5S15305zWXWW6bhPzbD8UxKklQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DLZjyE46; arc=fail smtp.client-ip=40.107.244.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DLZjyE46"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwMhcOYdstWulnf5UAm8mZEEwc7yjCPP+W1B2RE9AO0kJaI88dt6bwPOkXcQky3B7mrqjtYbt5IaIckXeSF7BljJb7Tq5T/GEwoumUfa2Y/yV9XuTAEOePo5ME+n1ChlZsxV+5IBZsDsOQF5f+1T73eLhdoBHynZ1uGOHrtilibOb1tDC5CG5nFt9R+dqfylsT8ptfLY0Gq/92ghZ7vG9snKRRaxLy98ecGTyfiv6DzATSETpmccQzWY7vFFMOBtGa9T7FjtsWT8qgFrnsfqpBCNu1rWSePJqvfWaHixwqw871HkrtttMcb4E96Ld7DkampM+qMF4cypS2Vwr1g3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmY2EioeeuiIvGDFFpqJowOQZlRVs8i0fHN8cFLqjmY=;
 b=knYDP/lZ4IygXJbJ0Vxfm4K5yS744Rb80z3wqKp0S917V3nYYSZk+uB4fXklwfOlS353WvzMsCedleSp/L9Awrax9meSXmnJZY9gaarD1yYtqSrAUt0boYomCGDM8dK1Eg6tSNEWO+jL/RcLfEh/5cwDtr+lGXqMDqoIXK6w5J/vMJ/9d2qqorSIy1z169dmbCTUHziSTp3d7Z+yQKxmxDuc/SaVbCC/j8xTilqhSeVAgV/284KDatk0uuK/c2NtyLbGFGD+hIV1Dlfpopbk6k6Sa9w2dooe1irQhqU297xmSknLFt0cyvGtZ68hbfXkbOeBAJnQv9zx0tXAfg/h/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmY2EioeeuiIvGDFFpqJowOQZlRVs8i0fHN8cFLqjmY=;
 b=DLZjyE46EvmaDj4SQKTkHqxzm9HLV3bwZ7ElB0uIsHEJgB4W1CMF+D9wE2Vz9NfihptOVgNNydO926hezXyC+9My0M2UckPXVBiXIQ8H+AOL/lxcMKAwxrzAMspBUdBgvtlPF+26tkiAk+6cUPFkJ9MfNagVL/rh/M3wy6L5nZKZR8FCkJ4u8iXeTvyhqu8BG5nq6uQr/GURslYq5mzIKftBtclcjwC4/7Hj2kAwbXxo6VBV95ANpCACQbRc30TO55gu59dQgVoPQtrAuoDAa0VUfaqeW3hrN4/cJdYKHqn1SCuk4Rllq3TWo7xUAUc2sdnHfqLkfnuB+PDokB8R9A==
Received: from MN2PR15CA0049.namprd15.prod.outlook.com (2603:10b6:208:237::18)
 by PH7PR12MB7138.namprd12.prod.outlook.com (2603:10b6:510:1ee::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:01:11 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:237:cafe::33) by MN2PR15CA0049.outlook.office365.com
 (2603:10b6:208:237::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 02:01:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 02:01:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:00:52 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:00:52 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 19:00:51 -0700
Date: Mon, 10 Jun 2024 19:00:50 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 03/10] iommu/arm-smmu-v3: Add
 arm_smmu_strtab_l1/2_idx()
Message-ID: <Zmev0oeUZ7yM2C+B@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|PH7PR12MB7138:EE_
X-MS-Office365-Filtering-Correlation-Id: 555d244f-a99c-4e96-c18a-08dc89ba5dbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+nfbE0BaPwS8zwFnpdS/obndgnmpkbwBNoIjQyO7yZaQl48jQkXrglEmczLd?=
 =?us-ascii?Q?upWRmSMeTJ1c65pgWZg24AH6iKvyppLPkpcpWHgpGJP3OF3oCTzJ5uTQj3Hi?=
 =?us-ascii?Q?EuDefjjrtSekB/IHOxurM9qse69CwDZbmy1vrrmt/Mmvos+OC8xclUdmHg4F?=
 =?us-ascii?Q?PpavbV9orjTPS9GjJUSL6qgdNGoZsinS9Su18EaXqrcdqmlfOpImmhyJBk2p?=
 =?us-ascii?Q?mdP50yWFS7k67QTOZWfgRJLWjbikH6eoLbgvqzNI/6hPurgPesu1vEgzdbNr?=
 =?us-ascii?Q?ThAJRcgJdLT7Sgzm8FrSG97/D4qHBCLP9Qq591fgKdYacB8EWJ7f1e4O3DEh?=
 =?us-ascii?Q?67JaR/6bGXzTHfdJiDqZA0CH0+MCaXxFFT1MZpddFWjFwc6BztiPy9/xnRzH?=
 =?us-ascii?Q?++LfHnyMWP9Cp6MW7poJw+35SQf5HLiTqUt+7zUcTbx9wBK0YRUm4EsHokzV?=
 =?us-ascii?Q?Ectva3H2KbNT6VcrHFoLMS/XK74YFuD3bOZv2OFX8SI0PBS2Ik1fnDF1Rx1p?=
 =?us-ascii?Q?PnUoxXpDkJOdBif07EbA7+4EwtyRbSEtr9k9sQfPvUmy/udBffnNwtYZVXtu?=
 =?us-ascii?Q?Cf4O6Cb9RuiOEV8w7+68Y3h3xBNAbHTH7RBllOXtpwqMR7/4XEC8oVTpE3A4?=
 =?us-ascii?Q?+BjZIUdZKAZYNZc+saB4yfoSLNNFnTnhm40pLtH6G8RbxKlLrphHwCty/wjB?=
 =?us-ascii?Q?RDIJlhIC1unvBPa2pNcbFfefpK53Wo4O8sewOEEg7tdXgCHZ/8KvP4ONXfQ7?=
 =?us-ascii?Q?6KTuCjv5yn/pzblxE8z0JJ5Ptq8A5pVhpHBP+K+bjBgEmnQW1RcJWK56Zpeh?=
 =?us-ascii?Q?ZVL33mKRXZe8AAxRjsnnGqdT5Sq+ZwJLE8KWq2F0Yv/5O4WUXoA+nbL+h7Wx?=
 =?us-ascii?Q?K2WNZR2b2THut+WZqhtCq1mOsdi73fD2uIzoZgo6geRQDr0dGEDtxAZtmyIG?=
 =?us-ascii?Q?/oS4IpOynDAU0iHmliTiXWtbMrfDh0qwROtoROsT1WKrBwwVIf8IgSBSskKP?=
 =?us-ascii?Q?1WqFAWZfJmvlaV72IdBckuOHKLYK1NCqPhmI00nRAfsc/YrUs6YAlyx8ZdCR?=
 =?us-ascii?Q?FNI6VAmyt9GC9AVCpyv6D0l9Yp679/mMibxfQAk3EB7G0iMlcrtEbVDrMfUM?=
 =?us-ascii?Q?ICSDUc3BpqA0+lV5U7ehzkfWkEmK1sZe39Ex6ruEs3BeoD1wIWYBz1DOEVLf?=
 =?us-ascii?Q?VZx2Jq744eHoEVkqQ6y8rR+8M2MJXGsfyR1PrsyOXs/iFtalzYicQqrhKSKG?=
 =?us-ascii?Q?bOPkAZUGzkymNAlonOHJfATzzSxmtBxWuhc5GiYMe7xskwLXkprmlN03qwu8?=
 =?us-ascii?Q?xRZ2LwTTNPeP5zNfSAORWDRp3/vifa+ONhz/R4XcVF7qs740K4koHaDRrk7/?=
 =?us-ascii?Q?CP0howLvCY78fi5VKVOfi8hBbeM5xzr5vfPCnBhVRWUnW6wGSg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:01:10.7466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 555d244f-a99c-4e96-c18a-08dc89ba5dbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7138

On Mon, Jun 10, 2024 at 09:31:12PM -0300, Jason Gunthorpe wrote:
> Don't open code the calculations of the indexes for each level, provide
> two functions to do that math and call them in all the places. Update all
> the places computing indexes.
> 
> Calculate the L1 table size directly based on the max required index from
> the cap. Remove STRTAB_L1_SZ_SHIFT in favour of STRTAB_NUM_L2_STES.
> 
> Use STRTAB_NUM_L2_STES to replace remaining open coded 1 << STRTAB_SPLIT.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
