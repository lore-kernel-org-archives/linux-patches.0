Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D8223A9B3;
	Fri, 19 Dec 2025 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766171851; cv=fail; b=YDM0g/W3rdU7CdaVYsrN1aVqt+QZG9BExSBFp3VV/Y0cjrtP9GCEjW/ioJlOhJZudgLDpL+LkKBdNFy0hvfQvCHQPFz9rA6iFBLQZ7d8zioJoD36kSSzQzcWLN+4ho3wKaaR67Q7+GSDRA6CBN8H5hrRYanIyl+f1E0hiU3O7hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766171851; c=relaxed/simple;
	bh=H0BEnb78vjJESq0fIObJEJGZccIvO76vz/KzGF079eU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFVL1XsynL8cV2VmTAnVM/G1MuLcEGaRZQxK4jT09wxsuO1hTkVWoJx+myI3DqlhZ0kPctGRMApluXl5nZrMpxN1a2P7n1qgrnYwAmgNJKkH+RiQcYeE/cXn7hxmUKa/KDUNtJoBYn6jvpMQHRIAMWW/sZO+9yYhSxM70wwyYYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ISmk6uvr; arc=fail smtp.client-ip=40.93.195.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ISmk6uvr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cptCYTpk9kLm4x0s/xBR+mpGnjjhFreRJ6ZS58Sha18o8IqrfJrTPXcuF/PB/VxvQgYBsuLmBNmgxUovzHOcD8ez6vIzyVlkbOQThS0ONtgbpZzDwo26wt/52ewRaly85Tu9NSPs7cTOYOoqVQS/BtOZtNc2DFu4MWdofbFOz2uJgdIx+1LDni2Rrg9I0xpEe8BmiBUMxH09RRs6W/ddDWu0uRyUlgYp/ie24OiORDtYk5BeJh9JZXPTSRiTF2wKX+eYNpBZHyE/LZNF8G8qlfZM8AgGol1zrNTRg6+6gbnhBWI2bcspXRv37p/Qq3e1ElwTQ+cI640OycxLVCvgeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4H16LR84NZmBgTK6g0KWFRAsGbkCaQwb1PWUdab8w4=;
 b=MbFlporuIr3C0mIETfkFf36S3vHF2FnJv/MPnDPNc0fKeYBwzNE6QgOLlROuaZITzBaHQxQyjjyVo+/oIlW2ChNnGVB44cNYL2HlzlLOR6Nf67z5nJqtiUMWyzX1Aeg/4AP5y09AXSV++A4O3DfG9peoYAFuxYKzaKGSy6raaTOAYI4RfrfqHjfyx7hsT60iO+5hsdCpeCBv/BsdMJRzfUlhxnnCe8Z35EL/ZIOIt/arjNIBFTmnvVwsfg2EB/RN6DLjaFAKLVPFA6pVV9ugbtATSu7S9mtawz3eeAyzXDRHuCEb4a/5GneEAlUCGxajjMuFqm7CfTfIYQiK+d4rAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4H16LR84NZmBgTK6g0KWFRAsGbkCaQwb1PWUdab8w4=;
 b=ISmk6uvrtnsk6P0q48YHmQm+eIEnRb28zEt6NTNlO45eLRSPjprMbWNGHXfQ63IoUL6V2J0yvy0yeXH2BwHs+q50JROs5MgWTfLi894rsO8ojyeEYd5+EGUb4dxuxQaGSv/LVMHCSROY9DaTsJO3z8Bcdx/hFVa+F8g6XxncxpcTcsvptwxZuYEfkrSx+mcJrRjYXV+STEY3N38TI6KBbI0m8vTdWGmQJIvnMC6qb7Sm1rG/NAfdTB6f7cyYgRkEO374nfDyYvsj1PeiOUQivxu0CKzqWp2Y9YBcFdOzyptW2gxBWrcj+lzH2t7bu2RDzfGO2O9VskncTdr8JQ1u6A==
Received: from SJ0PR03CA0168.namprd03.prod.outlook.com (2603:10b6:a03:338::23)
 by DS0PR12MB6488.namprd12.prod.outlook.com (2603:10b6:8:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 19:17:25 +0000
Received: from BY1PEPF0001AE18.namprd04.prod.outlook.com
 (2603:10b6:a03:338:cafe::6a) by SJ0PR03CA0168.outlook.office365.com
 (2603:10b6:a03:338::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 19:17:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF0001AE18.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Fri, 19 Dec 2025 19:17:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 19 Dec
 2025 11:17:05 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 19 Dec
 2025 11:17:05 -0800
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 19 Dec 2025 11:17:04 -0800
Date: Fri, 19 Dec 2025 11:17:03 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v1 3/9] iommu/arm-smmu-v3: Store ASIDs and VMID in
 arm_smmu_master
Message-ID: <aUWkr5e+C11mbx0X@Asurada-Nvidia>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <f7fa8725aab1fbd2c2a1d564e7493b16a586e88c.1766088962.git.nicolinc@nvidia.com>
 <20251219151608.GE254720@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251219151608.GE254720@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE18:EE_|DS0PR12MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 721da6a6-c142-4891-9a75-08de3f333e3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8gpURnhOrm/7NSNYagNtl8mNcfMQ6IUweJSNQy2kMNiVulcI0V0sDUW8Pjky?=
 =?us-ascii?Q?bMesNAHodVESrElmwNvab6B5AUX6XrevRcb6MpeJk5+O9NaiRBgQx92F3/MU?=
 =?us-ascii?Q?QaiZ19GSCa9mlAtaXunvfSW818cC5MXiJY7zv+kTTkqkn4mHcxNmBZkFIvEt?=
 =?us-ascii?Q?xVJIqOfw9dDazEj18OKOkghC/XlPFuYHiSWebhVLQgFam1mRXQlrL+opYur6?=
 =?us-ascii?Q?ARPcMgFtTMtLWvaDq6hP0Er+VUJtOgLlbNprRGPa50DkahJmtCvMvWLW7mrq?=
 =?us-ascii?Q?MWmoADpvmhUvw4nM5SfLPpw8fZz6MJIDiZUb5psDN+q6KLX7RHl/HHgxJtFf?=
 =?us-ascii?Q?WdLD9e4fo6UThgXSJSHCQZkWUZcZxsVBB/gQDjaZFZNQKG5mpYE2Jmn0goeV?=
 =?us-ascii?Q?E6jZzpBELHbGWvdz7h4ZbVVEoJnZ4+pwOHnVXt29gcyvfPpPYsiV/UyKpcyS?=
 =?us-ascii?Q?RIzI+kuxBk5eQLd2Pz0jCtz4vRf9xp0ev1C5nFbjLsUnBQGmW7K4MAvFOKUB?=
 =?us-ascii?Q?oXJLbS3T9DR6KkLxP81IxN8rKJSIL7whObTR/Gg/H0SmEugP4JRve6nP0Rru?=
 =?us-ascii?Q?tvOxJ/X3OJzAZk6t5gsypTDC38U4+89bKtmU86UPCiuEjr6ogcxJG+c8iZc8?=
 =?us-ascii?Q?SuzA9RNbB2p+UTT9avR60OS0hek342c5GZxNjXTPPbvNF5ifUe9KrLZLTyHy?=
 =?us-ascii?Q?IE3MUuG+HJ+NPye6Aol2mqEJRTE71727ABXS1e/VO7MBAudVjA7jkoug1L5T?=
 =?us-ascii?Q?dYssuWaThRWxWehyh2+M/yea6X1wXiJ6jOfT/lFR9hGcLWZFwyy5seB0Gqq3?=
 =?us-ascii?Q?SOdSK5Llz/JKtjkuWZNAWMXdF7pSoCRedMO+gCcJ3y1jzZQxHmAWN918O0I+?=
 =?us-ascii?Q?0ye8g5d1Jq8UL3RwD/4SlWu3AvDzjnDfvaNqjU4VnLXp2HfBYAJwm0L0QBoi?=
 =?us-ascii?Q?LM0//TnNeWXl3LePcBFa2aB3jRMx9Bq3NCuryUWAgSRlLPMUSDp/IMqQGfOn?=
 =?us-ascii?Q?kCmyKrRd0OiLuqV9H1ekmI/KBlnRcxa0OSMJcfHz7Z/OyXdSmEtjsUZ0AAXf?=
 =?us-ascii?Q?ENBprbq+Ur/MxDyujmv/ZLb2XZurarscT83wwPf9dizUlslVkzwAcK/vKArt?=
 =?us-ascii?Q?BJpgQBS5yPdI9qyKgkSxQlKZ++Y4zjtMmynMxskOspyaY+wyhFkMG5AV5mSO?=
 =?us-ascii?Q?iz1cI+xO4inf5yDEEfdMZBHRxJvWjllsRjp1/XTWgZlMcpEv3IJulsxLkmJ3?=
 =?us-ascii?Q?MjZvM0CNYBRiT5yrH0wGI4dP3p0vjdBXevvUPIGFqZxlMrzhoEVjbTFHu5fq?=
 =?us-ascii?Q?GKBOIEhs7XpIrzIS7K8a5UBcHivuV+BqZsEGBvLumDz6l6MQzkIm4yJ+5wCJ?=
 =?us-ascii?Q?ecWabDyTCkB/22725SgFl9i00kFVQgs+rZxC6OoEBB7GBif+HPBHmhbzPFs9?=
 =?us-ascii?Q?nCSUXVqCvOYKWECdJZNoOi2r6e/g3B8EevYkYRTs1GDaPuNQUjVVeTeQ1tQL?=
 =?us-ascii?Q?2q9y3LBrC3LvM+++ilVFdbZEg2Osyf3S5A1XYVG1s/6RKKhbap/nwE3+F9b5?=
 =?us-ascii?Q?cwSbtma4PTqmbk1depM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 19:17:25.2800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 721da6a6-c142-4891-9a75-08de3f333e3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE18.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6488

On Fri, Dec 19, 2025 at 11:16:08AM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 18, 2025 at 12:26:49PM -0800, Nicolin Chen wrote:
> > Currently, ASID is allocated per smmu_domain, stored in the domain, and
> > freed with the domain.
> > 
> > Practically, ASID is only used in a CD as an iotlb tag. Therefore, ASID
> > doesn't really follow the life cycle of a domain but domain attachment.
> > 
> > On the other hand, the CD carrying ASID is installed to a device's STE.
> > 
> > This applies to the VMID as well, which is installed in an STE directly.
> > 
> > Since a device can only have one ASID per SSID and one VMID per SID, add
> > an ASID array and VMID in the arm_smmu_master structure, to decouple the
> > ASID/VMID from the domain structure.
> 
> I don't think this is entirely right..
> 
> When a S1 is attached to a master the master needs to store the VMID
> it is using, as the VMID is global to the STE and effectively becomes
> global to the master.
>
> But the ASID should be stored in the invalidation list of the domain.

Hmm, you mean the nested case (host VMID + guest ASID), right?

But in that case, the guest-level ASID isn't needed anywhere in
the host driver? The ASID should be configured in a guest-level
CD. And the invalidation command directly coming from the guest
is already filled with the guest-level ASID.

Also, the invalidation array stores either ASID or VMID, there
is no case of storing both, right?

> Jus search the list for the (instance, vmid) pair of the master to get
> back the right ASID.
> 
> We don't need to store it again in another list, that's confusing.

Okay. I was trying to get rid of the extra for loop searching
for an ID in the array. That's why I had the alloc_id/free_id
ops too, so everything would be done in existing two loops in
the merge/unref functions.

Nicolin
