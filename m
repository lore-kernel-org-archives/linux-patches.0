Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AF424BC07;
	Sat,  6 Sep 2025 08:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757146878; cv=fail; b=Opw5VOJ2cvyJ+bAZ6f40flb0xH308D9EW5e6rY2twP9Te9024bWqGDhz2HQqBr686kq11gfqaMuEFJtp5VspOQJC9TGpAekl2m5FLNhIgdE7foHPDN81QpbuzVZdn2gZIz/nULsK6j6kBnO3UMRDW/ULWp1b8RGf3gYQLTn9Li0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757146878; c=relaxed/simple;
	bh=yTp/2VuIdhXlYU0Mado7gGaLyNnfojInSOP7V0n0/Ug=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/wV71vszpjH2FeZUszDVzohUa792t7trOsaZ0/rEPQ2j8slcHRWQW6XEelqYk0X0YzrJ6buCubzcbJyNb6TZcVlqViEsb0gc5c6e9TRBUyzZrNWnmi5EmoW6Qz1Gy52IZuVO9k5gEoV25U9YWOFRdpv4xxRJEnmov0lNzvKll4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J3LpCoOO; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J3LpCoOO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=geA2lBz96wE+gX02qpl3PCEfliIYx8D05CpRuu/Hvzm68C+6JkGKPHO6zLMBNoNtv7TgfAhD0jhh0j6MKqTYhDqA7YOzw20M7VUjfQGo7RM3b4dKITX5UaqbbRQUgcJptNY0S3U56puhYTXfhMgTyM9uZh7NlfooQTCOFd4LcQHNCjJ2pJF6GwfUFmXRJ6Ps5FwA5IgoWO+L+BxrJKENZ0a4emo5gNwF/lXTPnZZhkCpdbJESkpX15RXu+tc/6sIdx6DPnnvEiyEZUDtR7TuNnf2PbjjtsFO5q2Yed/z670qabJkgjCf4Lpeb3XiJSXo61tk/RCY9Zs2gCoIatTobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5W9Ek/Fq3AXC7BdmTmXZvAruZgMWsBJxGeqZlIkBZk=;
 b=xka1rTMWhEpRfiV7ochNdA9P4WtzOVq2P8zhgtnl/SWAUynIuIGxZ5zV02F4KFugZeof09xvdvHchwuqoaZB26nYaFuTmxIuPJ5IcZWPARWjPDqiO8TB7Zebefv314lO5Gxp7W9vz/aZ5hsD6mXoOkGfrjEe1ErVp+bAm68vjKPrXmFTVWgClaZkPWXE+fmYpVqjaYnTej9cgc40MWyiZxNIkFGAHbLkfWoew9blBqKeodZpO9GBnCtim/KuKKFgWErkepEBYamKQgqAlM4l/3TSUlLDe2APteqnnpwiQE+nKBgzfMjEiRsg77bqeQXSjQaULN0Lhgwe+WsuWdevpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5W9Ek/Fq3AXC7BdmTmXZvAruZgMWsBJxGeqZlIkBZk=;
 b=J3LpCoOOFnUFW9djwOn1VJRxgJfD8qO232OUpf3PlaUL0TY5xn4lsLrzIU38hLW3tjrXATc3Bggp7UjUwRE/FmAWcueRK+1LKfH9NWYprF/envim4H5makGDMviOkbzeeLKhYP6WEhs5fMoFOOhZKbyprIyqQQrmVfgVFUp6SQI95+97etncXc/H/NR3vUcnHu0cPk6hHXsdc2z9Fy4FXAyf3AEDeZx0j+aOnli7EzaQGewsnRceD4i6equ0XoxG3a6MuyDDIw6k6dU11OC0LVDDlV/eT7TLBE0eEnPibbDvhvNjacA44rptnGkEMb8tdTdEeyNqPCDHei3/wIUUfQ==
Received: from SN1PR12CA0109.namprd12.prod.outlook.com (2603:10b6:802:21::44)
 by MN2PR12MB4357.namprd12.prod.outlook.com (2603:10b6:208:262::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.24; Sat, 6 Sep
 2025 08:21:13 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:802:21:cafe::d5) by SN1PR12CA0109.outlook.office365.com
 (2603:10b6:802:21::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Sat,
 6 Sep 2025 08:21:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Sat, 6 Sep 2025 08:21:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 01:20:54 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 01:20:53 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 6 Sep 2025 01:20:34 -0700
Date: Sat, 6 Sep 2025 01:20:23 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv1 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <aLvuxxT3aYK/Is7g@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <d4dca0a6288e4c15994d41aa6722fa7d66e3816c.1755131672.git.nicolinc@nvidia.com>
 <20250827182123.GB2206304@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827182123.GB2206304@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|MN2PR12MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: cdd15eaa-7271-4eb0-3517-08dded1e579d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v0wgsOmfgRXDlb3Fw0Ga05sqNoKy+MLdLCMOvDKzyogWS3MIr/ciVxG6vRaC?=
 =?us-ascii?Q?Nnaxd7e1xoLFjze4wZxoS8Vxbjt7FozxKNZWSU9Hnk9kB1iHux9/qCwo5cdU?=
 =?us-ascii?Q?Xv0tv3k/zf/SPvzxT7SQAP4+upeoieboplUc7MooxEWVCgWhRse8WLj7UF8Y?=
 =?us-ascii?Q?jaMUyMQB+GAZqlkSjNIEO5cfH2V8qZRwKwAAYGp5t0IK/A/whgro0kCVcbOB?=
 =?us-ascii?Q?23+eX77MaVRHeLAu2znjhDDRG75LBi75MTqsGVQD2/2lo6QxYIEuw45MSXVu?=
 =?us-ascii?Q?/xgH5U4QO3EW1gcM2U2+sPo5zWbP2a3cJ+rkMjE30dxf55rOal2XPOkPhFov?=
 =?us-ascii?Q?WilNhImfmhmvWvz6m7epnX3AqrXYGszT4ZQwufwv/kFg2mcaY8BOZXxX8uxt?=
 =?us-ascii?Q?pJqIvyQMthkixAe0l8cbH50WI+u1njlkPkUtJEwQtuz3uVElKh3jV8WcqGd7?=
 =?us-ascii?Q?FUmqzkA60952kntpdsRSkzF8XJxH6kWgMUADdu9w4nU3BK4VnerVzl7DQ47R?=
 =?us-ascii?Q?7c5kuYQsUZmW0DolR639qNMCzF81U/vuKyzAnpiqb7p6bttKvYr+KAFuFomu?=
 =?us-ascii?Q?6jO9aHy+Tj9sbvLoZb6Y4N6RXR1qNsdcSSDw42cUqYHCRK5PmpHUgtl++U7J?=
 =?us-ascii?Q?GMyAYOIwVnnxwGawLe7yJ3xj6E5Q8yXwVPb7tqSGvi2iNAQ0S/X2pc2rI8vx?=
 =?us-ascii?Q?+SD5VRywLoJhgFM4imNkWqQYVKGp0MQZNdbjo8QHxntd0J9OSCtACEKQIRRu?=
 =?us-ascii?Q?i2ywpUTErRVXZSSMrl1fy1IELh0YIr5PAX0izuyws4iNcCAR8JFZQHKzVTMV?=
 =?us-ascii?Q?BuBPKor3wvgP/voKAd+lRMw1Rh5gE1dUniO6RS9K2nEjxA38v33mZDtHyiQu?=
 =?us-ascii?Q?3YSvGfacAOr9tqUrULLAdBQt2I67go7gA247bTlTsZug54VlzzK6NWuSqKdK?=
 =?us-ascii?Q?oW0AgajwWGDwtWk3mp8wnBSBaA8mo5IEBXbzMhcIf5Aam5h++fAD9LwMnVc2?=
 =?us-ascii?Q?s4b4P1O1LRLalmBkMKpAYIBQS7PPKcAltGEQ/Pplu7PIhHxD+iIk/Kn2qx5O?=
 =?us-ascii?Q?ZD2WgDP+AqT/gFJzVwqpWibnCKusujAu7BEm3bPyBlsHBdPJbqou6VszdNKO?=
 =?us-ascii?Q?jbNgan0e0j/YeNbkDzlmjt8tNyZNuxC53W82a1HzUsWV/Z4nWdnUKuV/HT/x?=
 =?us-ascii?Q?CgxxBAdJUO7Bbc401J/XhDAVyol9dZyW6f5EmEVhHJ0QvgeKLAYDi7nZLY62?=
 =?us-ascii?Q?26Obr2++vfoWTLisSpXSSaCHulKucfywEL1myxaefdWYMQVwhEPpTwlM/LcS?=
 =?us-ascii?Q?h5yEwro4ygcKNumJvh3cowm1g9c9kIcKnnGETOW6GjPRf2XcVe/RTxNLeDDb?=
 =?us-ascii?Q?euj5sMy+Tnz+9EDIuvTWD5rwh+C8DoC43lHm6bxWx0aP+yemwt07mD1bkh2Z?=
 =?us-ascii?Q?IX0kbfL4Tns53bDTE72D2OcpBGLw6KNHLtiO4GZYHQxd36b6LKjyF5KaKp5f?=
 =?us-ascii?Q?kjTNoiWLBO0W5Gz3dbhMvhocsImjxor3wuCp?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 08:21:12.9680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd15eaa-7271-4eb0-3517-08dded1e579d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4357

On Wed, Aug 27, 2025 at 03:21:23PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 06:25:37PM -0700, Nicolin Chen wrote:
> > +typedef struct arm_smmu_invs *(*invs_fn)(struct arm_smmu_invs *old_invs,
> > +					 struct arm_smmu_invs *invs);
> 
> no reason to pass in fn, this always just calls it as the last thing
> so the caller can do it..

The only concern from letting callers to invoke separately is that
the master->build_invs is a shared memory. So, embedding it inside
this arm_smmu_build_invs() allows it to be used before overwritten.

Having said that, I think we should be fine, as I noted this down
in the kdocs.

Thanks
Nicolin

> > +static struct arm_smmu_invs *arm_smmu_build_invs(
> > +	struct arm_smmu_invs *old_invs, struct arm_smmu_domain *smmu_domain,
> > +	struct arm_smmu_master *master, bool ats, ioasid_t ssid, invs_fn fn)

