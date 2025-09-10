Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA36242D9E;
	Wed, 10 Sep 2025 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473039; cv=fail; b=CWULrqn3Hd1gj0Y2hcSXOoeJEF6z+202MJb9NdsxOAruyTc0YOdKiYRBwQ9ML48EbhP+glbncABQM8nR+SLFupWnbAfZecuECkoOnSdgSKd1hZ3ij1gofcOTAVybbs7g2zuILZS6IrI5XBCj+jopJt7zYQMpMB7A8OFZiXuRmgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473039; c=relaxed/simple;
	bh=7Ae6p/oQhFRWNN3HB9SNLB8324YW2M5FvKHnsNF2nCI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIuasw+PV0YjO1+oBLSQt66i0V4lKEqKw2EBIr6qmPyBiQrEDtXk3fmUK6CYvv4fAYhKjGoq4/l/GHP3BpQ2nhSh8m5ZWNxXHLq+0nJOxDMwb6pf56rp/En67KRXEba7AmWUorW1lKW19u+DPNez+qdSowuiy2UDbmV9Z8WR9iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cXx4kd97; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cXx4kd97"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+WxC2vvdsAp+LpYH+ngeWhDG4C/iFHRPPrldVb+IQf1uU2Zxtwfv1jcmooGAsvS6C7/Eo99F4lAjtGcqcbey8GBIC409oW4hRq9K1CYiCpj5FINJYjmW8qglmQhf4pI+QyngwLnXhNF7buH613g6f4WBgfz6FUScqUA3T1W2fv4oCqZtqrPJaOio3jKlrr0IGfee0UmE/NwRL8quj332dyZyjuYKbby/s8xBwu32BgMoFzyEichb4T9N9UiWpfQZrDEcCWOmqLQO05rcgxFzQ4+9RaX1lASsVqzHNXp+OavqAjwjpKU3S/mUnlVVIDzc2rBv3m3PKGbwD6g14Pv4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Ae6p/oQhFRWNN3HB9SNLB8324YW2M5FvKHnsNF2nCI=;
 b=Ej16RizhroYDw7fu22eqOwqy4MBszX+lFQl4Grk0czSC46fKvetNXukoNV8D85KeldnvCJxzMQpf0/jVK40wU38y1lc8ErvvDUPzHdOoMhXH2lkwXmtntuE7f/4/B9Hk6r0fsBskKaWH/qENRpFwIYQD2SY7ZYIR3HgD89sZz3xZ6UEUkJsRbITUWVpSYfiXKaTTaIsf1DeIMwSVDppTh/CCNLPsJzda4bKKn61yW/cyKHBjH6MAG1C+ol1cVG5zbTF8m1p+P0kmXHIS32oTcTipzq/fCApBJpV/zZZR1MYieB0KDKe7Eti+0oXez7klkXgMog0/i4t+bluC3Nsc6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ae6p/oQhFRWNN3HB9SNLB8324YW2M5FvKHnsNF2nCI=;
 b=cXx4kd97qSTRBr6WpU6G8sPUuDeLQEQa4/hoaT4osGyynPmnNvddkWWesgUc80ndQOrxEALceqMlZpAwALmsEd2al5UEnYsdAvCFB7agHybXY9wWeBYCL+p7ZU8lxbeelya8ZyxWpRGEDCPejFYcOG15pHj57XA+BpIquzBFgxOHdfOHnC8+bnPcnlMjZ4zPfW00hInB/2LUDNwOvqTAqiUP3jPwwkpxJBzcx90+zJNqlcH0C+uX9w1mEQWfJuPOzwPGFsJwFbNGkCLRy18tNjsdrkSgIlkM4eByz0l8K46V4xNb4xFJG6Pcp+eekGmZEDq06+t+dgh4lhdvY9Czzw==
Received: from BYAPR07CA0027.namprd07.prod.outlook.com (2603:10b6:a02:bc::40)
 by CY3PR12MB9704.namprd12.prod.outlook.com (2603:10b6:930:102::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:57:13 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:a02:bc:cafe::1e) by BYAPR07CA0027.outlook.office365.com
 (2603:10b6:a02:bc::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.15 via Frontend Transport; Wed,
 10 Sep 2025 02:57:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 02:57:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 9 Sep
 2025 19:56:49 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 9 Sep
 2025 19:56:48 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 9 Sep 2025 19:56:47 -0700
Date: Tue, 9 Sep 2025 19:56:46 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 1/8] iommu/arm-smmu-v3: Clear cmds->num after
 arm_smmu_cmdq_batch_submit
Message-ID: <aMDo7vljVeeWWzRE@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <2f7f5fff38d43221fd60139323d23b258e34cf8d.1757373449.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2f7f5fff38d43221fd60139323d23b258e34cf8d.1757373449.git.nicolinc@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|CY3PR12MB9704:EE_
X-MS-Office365-Filtering-Correlation-Id: 03596709-dc1b-4403-845a-08ddf015bdd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FXNh4nZkqFdWbTGo919Uwn1pmg7vjZcYYh4Zpcx2O6lTrMfdoV4qAtBKoJUQ?=
 =?us-ascii?Q?QPZKu8ieLhxRKg5Sq8BfKe4uFXXvhv7DczTaAQoiFPtC1C04tZQX2+j414tZ?=
 =?us-ascii?Q?qXp+9yltz1owESbfpk1fF5k0100dZ29AGJReGdhfuOhsh7/zgpyKL7rxx6ud?=
 =?us-ascii?Q?RH/aI9DOHeJWvYq4wuV/I64iMC8rcDhBqcOfIrhRVEYw+dS4hHvuZeu2Me+2?=
 =?us-ascii?Q?DKKiEjUAR4YIZXT7d7VSn0gjGDZLcVVJ6hHm8PSQB9YMSOb7KUVm3aIYokNR?=
 =?us-ascii?Q?TxsbijlX7Sip5ChMdhXxojy0ljAjXGKywwZaB/1XcIHgin9ft8lJ6xQdB1Mo?=
 =?us-ascii?Q?T92HynpvharhbRPJVivPU9EnwGWjEVeAxuTyPGivd2HLwmmo3VtcFg1aQAQd?=
 =?us-ascii?Q?zvKSrK669tTJBDNv+c4tqKCysxRCDjeMYnDhbGEA43cSGqdc/GvhVLxyC2Af?=
 =?us-ascii?Q?E9EdpdqhQeZRpFWqrGF6oiwxsUSF4QD+W0i/INgNKP4oxeQHijD928tk90t6?=
 =?us-ascii?Q?Fqb0rJt+xE35CRPCZZYz0ymVuXvzB9hZdaglppAujbT/FkNOwlDQEDQKwuDR?=
 =?us-ascii?Q?d8DJJK8S+CqugTAnNVgm4bgRPTVngz1/EfXiOLI5NRXarxdVBdRfwbZKDpQm?=
 =?us-ascii?Q?iLkYQElHO3qNI5bYTjPAEsPfl8NbjNf9LDIGGv3Ku93igmgGP48YD4i+ZFd/?=
 =?us-ascii?Q?WRdrEMthyPVksuML987voLrB0QuJOD5jUESWdnxuXggg4pPnyvQw/tHp4svt?=
 =?us-ascii?Q?rWXZoxu44wuS0Y/7lU7P5ngqAGzsJbSrlWeGfJfQnmw6Pemqoun3jbwmPpZ8?=
 =?us-ascii?Q?71zc/FiWGV3QNbVk3FbAUVR/OdYs35ilz3eQ98JZ+N4p+4+VpZt7BZQSxdMP?=
 =?us-ascii?Q?MfIoCd5/MPB3boUXd/YNfwR0UZqfs2fhflBSfIjeg0rAea1DqpHpN/Tsi7nZ?=
 =?us-ascii?Q?vz52RVJjzXaoedQZQoux+ziueDvvLIlOzwcoJyDlusmqn6bkGvGeae51MLcU?=
 =?us-ascii?Q?DSMWadVGg4ol+lB2wbnQ79Qx3FYKSFtAx1EhdBI5gxSDex/BSFHGrfU162+u?=
 =?us-ascii?Q?AH2mOrC59FDxe0ELEB1QlbIf0Vk1UmNOo7cKd5VhTIfkY2bRTZDE28LS2VZf?=
 =?us-ascii?Q?tHDhsqugm86l9MBXp6s4nXXdRGeT2qzURwXhO6jgBj1mwoZj4p0xV3vayRiw?=
 =?us-ascii?Q?z5vzS5himXUPoIQ77dvDqoiUeQMKUVl4PVRDokcBt1sLK8X498ENDYANs3pO?=
 =?us-ascii?Q?fyXhQ1F8Pq1ouQPSW0/QlPNcfk5lSSknzEuae1xB6BSJejtXcFXhnEThWses?=
 =?us-ascii?Q?C7jOyDHXd3mg8ZuwOsmozPGWiwrtdUsNI0Eizgrn10y7VTNAkLu8UDgjb/Kc?=
 =?us-ascii?Q?nUGC4Icap0g8NuMztPwwyr3nZ/66aVp4e5HeW6MOZ3MFAXnpZY4ak3b4wT3q?=
 =?us-ascii?Q?vWXvRM8f0Wmg1ymL+QJcu11/DBXDkndrE/Snkr9VDlwRmYU8vYrUYe9+l2Td?=
 =?us-ascii?Q?0JiDBrPk7EojBiYdi/q5+ZYxNWPQr3R0dv/E?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:57:12.3449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03596709-dc1b-4403-845a-08ddf015bdd2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9704

On Mon, Sep 08, 2025 at 04:26:55PM -0700, Nicolin Chen wrote:
> None of the callers of arm_smmu_cmdq_batch_submit() cares about the batch
> after a submission. So, it'll be certainly safe to nuke the cmds->num, at
> least upon a successful one. This will ease a bit a wrapper function, for
> the new arm_smmu_invs structure.

This was added when arm_smmu_cmdq_batch_submit() was needed by a
new arm_smmu_invs helper that used it at a few places. But after
a few rounds of rework, I found that there is only one call now.

I will drop this patch.

Thanks
Nicolin
