Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5851B87E8;
	Sat,  6 Sep 2025 08:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757146398; cv=fail; b=KoH/dHL9m8wUlCHcGppPoxdKNMkp6MyhS3+NsSud/rEEG5kLRLq/i8wNL/x/2DM+z+hOiI3XAwm7L2yn8P93xzTPHwzJgdmuM9DO9A6Dr3PByH1ZcCxIuiun4/TpeIjCFTrxybE0VSr5jbYSn6p1qHD738nLiFIlVMM+h9XOAZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757146398; c=relaxed/simple;
	bh=MBoiUQptkmIfcAzQlI+q1s7t749dis3Jx+ueZVVbDj0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8Wz50fIcCkH9bkGdIYpQyV251jPm9mguMg074tt8Opv0BrlDwmrzEKnk02a5Vce1LM99JNUamimxklf5DLP/n2M2QNt8u9QgpmyKq1jqR8wc8nwb7ZXzNGnzCkZMf3/gL71pdpw3k55hkOwLr3yB8Rpu7huEoPJAIbBMup9m8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VRxm0m71; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VRxm0m71"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dksN8ozcNYoF0vzUN/+d/AVqkHLxgKhLkzPRfwdoN2ripLcoyfe/GsTT1RQ2ic/+GwOPivIWJndo6hB/R55ya3STcUGoSXkBM8Kbb8xwjDda2QN85B31DnDvvXlvNGySF2V29XxU+xlcRBIugTVZAGB5KiOKvl9Gxw4TE4cflx5EY7SKanHGDj04AzrHLutX0B07pExsRLcJrMxVWACarckI0xN4aWeeOC0w6g+hCAd0BWxVL6ExBDd7Os2fg+OvO0qbPvSfclHGtn7lfqr1svuNT20EPyLCezeqBEHD89B8OnBHHb72mGAcemTHFy+AVRIurGPVzd0AzUWwqpE/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JhI0lZRadrjGf/5oHUsaGoK4HlngtWJ0UXu+4MzEAs=;
 b=kbQ/rwvhSSbZ+rY/DaepPkZe+InKAHqpVWfcBcHJr/MxjtPbIFw+F8fQ38DVxpUpOm0dyYNvriLjbjZAHOOGmZBD/ByFOBrtVokH50uRLR8k7PVkLIqUuv4k9Hfs9fcvrL3UyXWfCPNCdJY7WOQxbSMaOD74Asaq7zW0ldPJkwAj0oAEtJwtv+4wgyO4oybhZuGdPygzhPxrJmM5bCULbHp233laMJ38JyWVSpBWhcCRSRpMqYCxZDbnqwM6xBR+Ep2Kd2SUYyGMUvlA9SahnTPHk4RChgBV/qM9njRhWE5KRVcF+31C7hlR3CSU3pmzvSwawFFepYQmeYh8tA56pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JhI0lZRadrjGf/5oHUsaGoK4HlngtWJ0UXu+4MzEAs=;
 b=VRxm0m71oQ1B5BynIMarpuNPEnK+/yicU1y6loU1Q4pZNa2013v9yO2omkEFOisI0SbOIbc1Cltw0lX/iEZpzvHy0F8CE9dlFX7jcDf3shTrXRP0AqhTshEzaaY28J3v0XSAmpfOqXu76xGztUQLZ6PlXWzezpAjSSLJO8rVXDSpOl4c7ACiCG1oH6yW3KZbn1i5PbaMZvNd0udK1BRqKHOMmf+3Eno0EFJMqX2CB8mMjWcrmFkiDw33N2DF3LTIoCAj1HQ8SI6LfzVCw96W2aTG7INSXmy2AnWBRJGah/PD3f+DOez4aAlh0z0GQVIZnaOltgNOgpoATvaFpwL4aw==
Received: from SA1PR05CA0024.namprd05.prod.outlook.com (2603:10b6:806:2d2::27)
 by LV8PR12MB9619.namprd12.prod.outlook.com (2603:10b6:408:2a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Sat, 6 Sep
 2025 08:13:10 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:806:2d2:cafe::3c) by SA1PR05CA0024.outlook.office365.com
 (2603:10b6:806:2d2::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.11 via Frontend Transport; Sat,
 6 Sep 2025 08:13:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Sat, 6 Sep 2025 08:13:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 01:12:55 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 01:12:54 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 6 Sep 2025 01:12:42 -0700
Date: Sat, 6 Sep 2025 01:12:33 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv1 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <aLvs8WrxEHpykCT/@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
 <20250827184923.GC2206304@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827184923.GC2206304@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|LV8PR12MB9619:EE_
X-MS-Office365-Filtering-Correlation-Id: a251fedf-801c-4803-4ba3-08dded1d37b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xx4vPh3lmaBtcLQ+tfsv5qRrJQGSqZn8iZ57T5l1AFqb4D8UzJvJRWPeUeMI?=
 =?us-ascii?Q?powS1eNWUsGtoFSmy5vbsYmgEFmrpPjLPH38itHi/WtUYMdPBSx7q3/C1Dfu?=
 =?us-ascii?Q?LfLmIW5g4I6qi0mQxLASVtmP6XFvxWV1ro92nM926fqftnmEJ9g2mWP8wtjo?=
 =?us-ascii?Q?L2hLp7RIy8GlId+pN5BKzw2VSBQMx6Hp43/1Q3dzUfRT9AMLdUxbagYL3KhI?=
 =?us-ascii?Q?SViaoN/Hc8+JeuYh7w/X0QLpx6LyyX6heYt+2jW+tU2cZQ4vR1yJgEFRT8ef?=
 =?us-ascii?Q?X3AsZoiyEVEAuIiave7MpsAVxoqA+wVO5hMGmAmCipzjgU9Qa8orzHqsVXFC?=
 =?us-ascii?Q?3PZVslOgN27qKrfzI+2NxY9uCZZTutm9NVlsL0rTcQYopRLUIJ6Sf2ZLwqHt?=
 =?us-ascii?Q?UzhZqqo42doW/7wjexaQCgPmIPj+XH+noz5Mug3sBiyWek5w7M/cMDISGePK?=
 =?us-ascii?Q?EqBPQEfNOjfC14hqXYiqgfvX4hTAogMWf/bS2+iZQXJygLzBpjaS/KdjQxBj?=
 =?us-ascii?Q?73UjNjmkMYBnRNREtSNxa6y6uozIlbHrTcRxLWtXP7Brv6k9cItDI0Xp+QiL?=
 =?us-ascii?Q?L/cc3bGlrnZOM4o9lbH62eJj/XkzkuTbO0E5BMqxaybHYSEg9lcRJ0qf8DvC?=
 =?us-ascii?Q?+D54yBWS/bigR1qDNT2ra3UB0x6h0jfbEQeqtR3Ar5V2GdEZgpvuxETDqTf2?=
 =?us-ascii?Q?5mF/Yz0GjWajjV7Sv+OQkx/TgsOqiXqVVUmaJ/6VCCrUnqt2LGX3IVcAEAK1?=
 =?us-ascii?Q?/2Bs/2KFtujd167mxm5XJZrIypoX4oDXFvnDWFyFMjQgxqFxg+RmpvyAxWcA?=
 =?us-ascii?Q?3//BkG/w9YDZwIwVaH9ioNMCBegq6IVf3E7ruPxSzcX4yN4iiQFkQ/8FllS3?=
 =?us-ascii?Q?HFu+QPsL2bDGOV43rB3hghCsW56mPU24r25kuGOe3Dz/PvhKOHOe/k2aKE0z?=
 =?us-ascii?Q?RUHfMXm8jlL1ZToUiZntrx/9d3XB/SinQND2PzEl+A0xlNcJ+BJKM4zekUeX?=
 =?us-ascii?Q?0ONEqAOdTEgqkYNXp9oSokxQbFQSrhNE/op1+WPnTvee8yA16AzU2H7F2juC?=
 =?us-ascii?Q?nHcgaVmwkJQcf625zGLd5ZeewQEuUtbs3G+zgvzJVX/Hn2zTWrpjYN0btbzt?=
 =?us-ascii?Q?k5NtpJ494d7Q09CxfCealT7TGBc91eTA0z9Hg3GfyXcjqUjvAxg53O+PyIHh?=
 =?us-ascii?Q?W1rzNQ0kMwv3r+4KJI5giWq3RylH7Az60wvVROCVKZtwZ+AVujDNQNoHP4HW?=
 =?us-ascii?Q?EwmXZGFUmmDSi426LwYnOhtE66bl0jaD5ExG7RZPpF9ZMwTiSU/5BrZsWWlr?=
 =?us-ascii?Q?vl78E7LY9J9w5QAZIcjM9sOXIbBoGa8WIf/A8/d8Q8bybD2+yC1tM9yBoNll?=
 =?us-ascii?Q?3/WV8oo7ZYPyDko2tUgj6XNmKoA1kPK9FGC/qJhM6XTkVE+59cC56I6NdbYi?=
 =?us-ascii?Q?Kl9g1Xsqq993M5IkTAwMvi3LK0MRlqTcL108DmVVwws5xYs8KAyuaAcxk4Kz?=
 =?us-ascii?Q?+6LrJRqTM8tK7Kq5QP+0uaQRuN5r/K3dSUnNC/9JhEL1Sy45VB7xKKy4RKKo?=
 =?us-ascii?Q?NvBWHogsp3GNAaxe8Zk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 08:13:09.9555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a251fedf-801c-4803-4ba3-08dded1d37b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9619

On Wed, Aug 27, 2025 at 03:49:23PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 06:25:38PM -0700, Nicolin Chen wrote:
> > +again:
> > +	invs = rcu_dereference(smmu_domain->invs);
> > +
> > +	/* A concurrent attachment might have changed the array. Do a respin */
> > +	if (unlikely(!read_trylock(&invs->rwlock)))
> > +		goto again;
> > +	/* Only one retry. Otherwise, it would soft lockup on an empty array */
> > +	if (!retried && unlikely(!invs->num_invs)) {
> > +		read_unlock(&invs->rwlock);
> > +		retried = true;
> > +		goto again;
> > +	}
> 
> This has missed the point, it was to not get the unless we have
> ATS. Something like this:

I recall one of my earlier local versions put the ATS and blocked
conditions on the attach side. So, here it could be unconditional
because for most of the time this would be nearly a NOP, until an
attachment hits the FLR case.

Maybe those conditions got lost during the rework prior to rfcv1,
so here this ended up with missing a big thing...

> 	rcu_read_lock();
> 
> 	while (true) {
> 		invs = rcu_dereference(smmu_domain->invs);
> 
> 		/*
> 		 * Avoid locking unless ATS is being used. No ATS invalidate can
> 		 * be going on after a domain is detached.
> 		 */
> 		locked = false;
> 		if (invs->has_ats || READ_ONCE(invs->old)) {
> 			read_lock(&invs->rwlock);
> 			if (invs->old) {
> 				read_unlock(&invs->rwlock);
> 				continue;
> 			}
> 			locked = true;
> 		}
> 		break;
> 	}

I know that performance-wise, this piece will be a quick respin,
as the attach side releases the lock very fast. It still looks
a bit complicated. And practically, it would respin even if the
attachment removes a non-PCI device, right?

Applying the condition in the attachment on the other hand will
be accurate and simple "if (master->ats_enabled)"?

Thanks
Nicolin
