Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FD2274641;
	Sat,  6 Sep 2025 07:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145173; cv=fail; b=ZFusy5EKKyTbfvJsLWyqerQiCdn8U8v68Du0ifGs4NQtRWHdzfZBkECQEaskmhE7SHYGXrSrAWOTKDoHYDoi5U/1id2UJZJOlH+n2Nw8m8ZRf4fPdXw7EHF5d+GsvHkBzeFtdJOmmAjOsMhsJ0y5dh87wD6wVj5+Sp5HrcVUb58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145173; c=relaxed/simple;
	bh=e0cOe0Xf9XXo1jwYznlpbvuFszDa8BaRUZ1aXLfuu98=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pv2Gyp1oZUSyvIVR08ZHkSB3ABkWAi+T6ht9I/yV9xeB5xNa2ABS73tbsDGiGczik7IDD4tKtJlc8eeN/hleCYpJhVJfGMzzBA2Qy/FvyalJRdMwXp7kYWdGNEElUAxIGXc/hrX/+nK0KVsV1DHeZFTgCsAqRMH06hUIezFd104=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ClVs+Gu/; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ClVs+Gu/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BlbnAVYDMtje54erlolXMDmpwGiZ/IyWgx/eRd5CjxLgknQNvvxPI5qI/EQyLvTzAXrNVBvb6X9ijyZZvVWjNLnXcSKVuklr17G06y+Nozenn9xBs5YbLkeTth4Z9elZhDPJfhTVfsiXCTnrag/fnylcag7kBsQPCql2Q+AthqJwJ1Sl8xs1g664LAgAbLtVSn/3CUccj50KSt8YQG6PU67dJQ5NP60v/fY+HoSL4TLB1tLuV/I56Wt9VTmyDbRKZyGV1hfbZFVj9eIg67MVYOG/s+k8yhRGiGXKK06Ui23nir5Fk9TJpWjS9Qbo7VJggkIRsf5xOmC7+b9+ml63fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckwJ90Dk49QpKovOdEVuRxcMyYpVd+YVkHWTPjGk+lk=;
 b=ZFs/Slu/0LObY44dQ/8oTJz4RHURmbf8t9+T+g62+z4/QkGI5n72pt9E38Zgsc6Csxg/ADbVN8KGmj4wDxC3Xt+ZTtq1BpR+ZqAglShHXg6PPtP+80o4kIk0/lP26L2aF8T4JNNZxlsRKYOLihVsgjtpK/vMQhLpQMQqNM9sgmsdy5G+fLaSXLnGfYvKWnI5Ib3k9B0wJHpD/svZ3KbBQ34V66x6Lk7L5m30f+d2w5EaJIEtOisGcZZ/+7VP+WlmA7l/8SICyrSrNoLn10WY133JQvfkCAt0JsKbh7vox9EDcXAxRF0pf7UxkwlI+29rX0Xk1c/RkXCtpl8RrtzTOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckwJ90Dk49QpKovOdEVuRxcMyYpVd+YVkHWTPjGk+lk=;
 b=ClVs+Gu/qnLwbhPIGtmR+XpBEm9jH0hMZtny2Rgr5JIrbeqDoq3ne1jcfGRZaPsmCrl9Yn8RNLfUKD+xVLglBokDS3Uz2URnJ3SHA8fP1bdzRDhZRxoMlmO+zaksqHzNFTQhBY7gmHR9irKYluV5PBDNfx2cpQa4krj+TQNPck9T0XsnbI5L+g2Cjvonn3iembW5ecVCciRsC8ZpN/QyxWvuMclk60aaA2GocnPJ+TqY/dXXFAkWo7+heRTiGkFEguO0JjwDaslv68/v0qIsvXQuEe/bY2dlu198nt1knI8AybwgngFGOuNn5JYqqXqLz5yuDJV8arvPp+gVw4aFSQ==
Received: from DM6PR07CA0087.namprd07.prod.outlook.com (2603:10b6:5:337::20)
 by LV8PR12MB9207.namprd12.prod.outlook.com (2603:10b6:408:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Sat, 6 Sep
 2025 07:52:48 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:5:337:cafe::52) by DM6PR07CA0087.outlook.office365.com
 (2603:10b6:5:337::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Sat,
 6 Sep 2025 07:52:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Sat, 6 Sep 2025 07:52:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 00:52:42 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sat, 6 Sep 2025 00:52:42 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 6 Sep 2025 00:52:17 -0700
Date: Sat, 6 Sep 2025 00:52:02 -0700
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
Message-ID: <aLvoIp8RNQtVrjV8@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|LV8PR12MB9207:EE_
X-MS-Office365-Filtering-Correlation-Id: 66ff5db8-1830-44e3-a803-08dded1a5f2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JhhFNa7TRYGBZt9LNPqGiAeNPK5PqLG0cwqquVyRCXOMcAKbZzvh6zma7QAI?=
 =?us-ascii?Q?KZqHu9gFKf+2KZlw0tgKjg53Ek6jOw99GqUR41lPKIX+0Io2FTd9N1RY26FO?=
 =?us-ascii?Q?cT2Df52dyho5KfwCjOLwC/JyxWSnruz6pNx9v4gjFTjhaMhYpSOl7wQmQ6q2?=
 =?us-ascii?Q?SHqASyJ5qwn/4Vwa6W1E9eqeQBHU8VcdruupyTCDY+oAbMs9DoedOyzYgTDF?=
 =?us-ascii?Q?WSRPq3oqeMV4cXSp59KSJLIfdvUMPesk3lAVjVsriAJuqcJAoOEUKQnsSIhc?=
 =?us-ascii?Q?N5zIKToiQfGf+9hRoGULha3qBfEXDQb/fkHbA2+EmeSv8MIFp0POVBqiWj2/?=
 =?us-ascii?Q?Q6/2QbBjnHmVTHbsKzRO0/tD63oAf7A0MMr1nRqCWiSibPqcqojbGJx7El+z?=
 =?us-ascii?Q?zrdw1+LAzPNs+guf1pEv2FnHg8P/lp7vyS3iXRUqrypxh+zA+hm1wk0Mru+u?=
 =?us-ascii?Q?44wC/O4NSalbBG4zynGR8z6PXqOd09ATA1HEpo9RiADxLv9BcPjaAKIzKe8A?=
 =?us-ascii?Q?IMQoKQ+7HLQxC/gl8NytXd0jBUgZxsk9cVjd3ZqNAIAdLsMSYaDwEsEsRC6n?=
 =?us-ascii?Q?XetPayUrye0n3v5ZY2YtSpVzKFvx9DqkhjdwNaZOStcYtMDjkWhCIX9pZtb6?=
 =?us-ascii?Q?EEGbN394+6XF+Gzym2kLyEhuWtEG0AnI7O76Jc2SZE9RX+SMJ/hffuT3Ewcl?=
 =?us-ascii?Q?v7P8FIEcim+bkZ+smOrKSzkdYYNJgEXmljlOPwFFapogAnm2f5r+jP3cLpDI?=
 =?us-ascii?Q?qM/hhqvMogreeeh4ZLqBgVf51U9qRAgOTShyYfwHIZAp4ip1KV7tCXzc+/I3?=
 =?us-ascii?Q?ksFMNMOEcjX2gKZ1EJDmYfjAi5OkQXL06mFQJaE5SEyxsDj0MdfX9v+w1+oX?=
 =?us-ascii?Q?7xqQo/dOlx+qPbVfYAztAW1GBZAvNcYkTxKiJG20DkehFiExFOnpSliL+pWq?=
 =?us-ascii?Q?8MvZG9arPn2SJtQzGXHoGuo6lZ+af5Nd2sJ+ZguUM12eX+y5hb3ZYZtsqiuz?=
 =?us-ascii?Q?WhUhMjfIjPcCLvF7spMB3owyqq5W18Hn2/ZgYVG6fSa4aTyaQf06dy5OD/O5?=
 =?us-ascii?Q?pyVBVL4e2EyUXc8Puaqx86JrHbhN7NYG8w+Bd8dIjJ5fku3tASAIYVSVucCa?=
 =?us-ascii?Q?OpexhpEYh/ab+kvBSh9m6xaGdo42cOmlTI9NJ+0m5yJGcZSTsmsEDZ6eznRy?=
 =?us-ascii?Q?W3t4djDhXi3z+FD5FHThIibdDI0xmuk2cwNmpnAuxYzL7PLFxvhhchBLu35w?=
 =?us-ascii?Q?CPS7Vkej0G+ADzWTlCdPFsKpsghgyHEalRWcKbQ/ztciV6XDAUm9LdCH1ZZu?=
 =?us-ascii?Q?PbFaRhUQ5ugktpuufd3su+pRrw45OXYrGleYzM4heaoMYjp+QgiZM2KkSTaJ?=
 =?us-ascii?Q?U7WcevL3Ec3N9tQ3NtZdQiv1rVqzEfofM1J8DGKZe3ltKWp7h6TSINAMYmzz?=
 =?us-ascii?Q?kixrkTjN21kIQPQCiUtckCymVFnM+Y8K4gJI8tpYQNGkkBSGijHCYU67Uf3Y?=
 =?us-ascii?Q?7VA7eJD2tGuHQ8P8qYd8H/px1s87WSlXTnMy?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 07:52:47.7075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ff5db8-1830-44e3-a803-08dded1a5f2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9207

On Wed, Aug 27, 2025 at 03:21:23PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 06:25:37PM -0700, Nicolin Chen wrote:
> > +static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
> > +					struct arm_smmu_domain *new_smmu_domain)
> > +{
> 
> How about a comment:
> 
> /*
>  * During attachment the invalidation lists on the two domains are sequenced:
>  *  1. old domain is invalidating master
>  *  2. new and old domain are invalidating master
>  *  3. new domain is invalidating master
>  *
>  * This uses two updated invalidation lists, one with master added to new domain
>  * and one with master removed from old domain. Prepare these lists in advance
>  * of changing anything. arm_smmu_asid_lock ensures that the invalidation list
>  * in the domains doesn't change while we are sequencing to update it.
>  */

Having addressed the other places following your remarks, I had
a little trouble to understand that 1-2-3. But I think that can
be elaborated with:

+/*
+ * During attachment, the updates of the two domain->invs arrays are sequenced:
+ *  1. new domain updates its invs array, merging master->build_invs
+ *  2. new domain starts to include the master during its invalidation
+ *  3. master updates its STE switching from the old domain to the new domain
+ *  4. old domain still includes the master during its invalidation
+ *  5. old domain updates its invs array, unreferencing master->build_invs
+ *
+ * For 1 and 5, prepare the two updated arrays in advance, handling any changes
+ * that can possibly failure. So the actual update of either 1 or 5 won't fail.
+ * arm_smmu_asid_lock ensures that the old invs in the domains are intact while
+ * we are sequencing to update them.
+ */

Thanks
Nicolin
