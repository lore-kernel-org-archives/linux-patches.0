Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1562523D7E5;
	Mon, 29 Sep 2025 20:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759179176; cv=fail; b=bH3ztoo5XQZIjl0Sb93/RYrab+x8X+oGonMVuLaFhq32jftt+GwGbn46ekjMZNTwjv/jYkG5ir0SBH7pm04S7wMzXK/TcNf/ICNVGxBAd1Au9Vo7bvSQHBzjuZVA5feU4LhAvHKQ3sWgEcLBO4btFCPKs8eIHggFdd1KuWqJC7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759179176; c=relaxed/simple;
	bh=RxNHY49KeQCs0HBXKNooBZVH986ADuQC4wVdD70lktQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKSHGjrziiZXgG+hpKezU4ARyV9AgVXecc44+s3bGWKF7gqrVx78OV6Xa7GUM/t4ly1i86q9XnGY2PwB04vr4y58mV1TVpYMC3Kt1x9BtFnMG+CfgRCAxcMUUX5T6bgAVpnVWLlaWoKfoWNC6GU1YUBRSfwfuV/sLCaBMDnh7BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=st+L8oNI; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="st+L8oNI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=trDgioNhX8LhmdxBoYf1y/pawBgG1AKQQ6LlEqyjtxj6wZP3AXnrSVDTTMnOZtpnBsJXaffR9cOiidq5c2OKIXCx+pelba4nVumN4dihEH80NjyWXtwWfr6IT7q56rsVvMygf9d+EifCtqTMThR6JVePS1r+GnpUl56K2pTsXnPwIfye35R5Wea9+Q84C5Q0SNcDVgosggHnHpqCCdk5i11wpMfvhWoj/f7b9nzv+Q4T07GC779myv2FdfC6YO+Qy+x/AQljpZJrxoBhiLSJddz4ZI+MINiJr/65U3rCpHnxkfP7URLJv6nq8+Pkr1dZNFnoLiGO3tjqpzgQ9bI0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr6Hp/4LM6MGsvoKDnir0T5koxtrOukT9gM3UverxKI=;
 b=Vlh2Eetoi4gN26zUBIKZ3alUKtPaBNtLWIucNSYcQBAc8Ca/nvkG6bRPA+wIc6q8bApKeClLGOkRtytNOltZcPiC/ZrdGTa980s876B3awMrQbP8NvmZCa+IE9oJPEv3I7mBC+PKlckU8DW5dETy7EIGnQC0JEAsXeFO6Y/IK/lxnM0CPoyhkH2fvZsYexjvHI5SV1Tz8LEWk7lfAPBzhn0kuVeU3GVUZcOWl6RZzkFanHTRKki1oL3ZTx9Dgz4Ykkq8f/+j8d6YYcwX40QpKWLIlCWcPWRXUU1ckCY0BK31YTQDlfpLiK85Q1Uw/elNIVsppkYtYX9iKcdIz3XD/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr6Hp/4LM6MGsvoKDnir0T5koxtrOukT9gM3UverxKI=;
 b=st+L8oNIl2EjBxKpBnIp1cZjva6SiMMkQGXv1wtN+RSxWayuzlnJOIK5t9RRJ9p0ZNTbIp3rHbvFbfV2qRf2hP7YryHH2oDbQu9+hc07DZNIy2/KExH+ygStHCnX9hiW90079PuHwZwbkxKx98qRuStqwvKAkCfuLjDPqNNrbL+MMQ2IoPW3eEkFJJeZa5KrKD2Rx5bYnfaHOYrL7zmLXl4TYPfImNYZhO3pVwihbf026Rhf/dSRR0bKZkVEmtG5Fe834tg3lG3KP0aUc8K2Pnt5hKylr8+BXOJ/Xygk2THb8c3T7sGKQyhLd1CSWUMvyFvOD6gfUCgKLCa3wO6W2Q==
Received: from BN9PR03CA0798.namprd03.prod.outlook.com (2603:10b6:408:13f::23)
 by DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 20:52:51 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:13f:cafe::65) by BN9PR03CA0798.outlook.office365.com
 (2603:10b6:408:13f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.16 via Frontend Transport; Mon,
 29 Sep 2025 20:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Mon, 29 Sep 2025 20:52:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 29 Sep
 2025 13:52:33 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 29 Sep
 2025 13:52:32 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 29 Sep 2025 13:52:31 -0700
Date: Mon, 29 Sep 2025 13:52:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <aNrxjkUEEUzKU+za@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
 <20250924214215.GR2617119@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250924214215.GR2617119@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|DS0PR12MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b9a826b-2d19-4676-7349-08ddff9a274f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mveknu9RxggeH1lsnfUl9cq3bUCe4RmcfFKUlN55nkbbEr0hv5kp1xwmmtx3?=
 =?us-ascii?Q?wCi42xGYBd3kNTm0CjHzvCMt2ndPUBh2OcpVk5Pt6XpdEtmXuU7sLBWCBRi6?=
 =?us-ascii?Q?uzSAJtKPmt2XR0iytl3DFBGrTHpTmKE5kWXN+0xqCMtHe/OIJKPVSZbA9ICB?=
 =?us-ascii?Q?YZG5OHJ4tMhFXNuddb3EHOIaOtNqC4pCc530nolLXroR5GPlI11IKgak+YaM?=
 =?us-ascii?Q?kI6V0OB3yZYccI7OTJjcxS7oVE1pmDQmXx/j5+XpfDlHoSW9FBPA+u47QjVi?=
 =?us-ascii?Q?GWrD1ZO4D2ls4vR5QEUAXyQxXVA3p9+RW2l4zymnoYBnTY7POQmx0ue2/yB6?=
 =?us-ascii?Q?wZJDt5XXIkhoBBk5Gl6UJMq1JTLCGxQ+lGfNEgGlNvQ3eMC8NC28FfZ2N6kM?=
 =?us-ascii?Q?gwyo/yzRLKd27jTbmzhlunT5TOjXStLjv/PvvvGKisweOSsNDWA8XLHOpEzr?=
 =?us-ascii?Q?VbeVNN1DTMHhgZMftk4lVyPUPq5TWQlF87K/OtRfKgKSy+LSTWk0KKKD6P98?=
 =?us-ascii?Q?kJxQtOzKYEt1cDjzWhbur4uCYo4qglcwWP1bz63CrHpFi7UPB8KdhYVLt+9H?=
 =?us-ascii?Q?K1ugO5ntB7264BYwxHtCqkNgcPlojFkldRhI7gpRA0sPX9m9jvqDEJa045Df?=
 =?us-ascii?Q?9vgiD4DECbG44lEQNBZB/S2zO3h3nLZqC5g6MMyc7QalynAU4oJ1FrWgE1xv?=
 =?us-ascii?Q?qc5aJDh/T3JrBgtX2MzT36VgJMW+Vfq8tHEpthZvisJ04z1rtP2p389nnPx3?=
 =?us-ascii?Q?tHTXS9ImQVrkbkL6HwYv1YQ9DjPpDytuOTmNb/TKBnuAQZJKhvkqUteQ19ao?=
 =?us-ascii?Q?00jFOUUTsyMwR6s1RHEAuc+Bmag4E6ktLOODyKuFGK3wPh2ukL9qlDQ89E/O?=
 =?us-ascii?Q?IY7caf9RERyuzgdswYGowgOQYVo9h4OrARX4ttnCmVw7msFjv89H+7jNghDZ?=
 =?us-ascii?Q?Qlv6n18XROqh/LQL1UFhr5hnC/crFjzy445TS0qxoMionF3x65JYUnZYcB5G?=
 =?us-ascii?Q?qgfoD2Pl/dcMl0QafQye5DSyypEeuiDhRAWpBZNL1bmV+UIqB+8HZKNDESGb?=
 =?us-ascii?Q?0Vw6lvw2Kdoe+cBu030/RBXvqP2s7LfkN/y52UuJgK2UJa8C0/5F+a/nWwJw?=
 =?us-ascii?Q?ctDXLt4+loWRAdACOOt5fjL1FaBZE3riRefg+uXep9GBi0UpXN5QbT6k6BO+?=
 =?us-ascii?Q?800ATFGBvc2vmFZHiQjaTPJ6SLF+RsHGgET02nfkToLhIdM2r9MENmjY9Zk+?=
 =?us-ascii?Q?2xP80RGmjhxbAgCbZDc5kn1l+6r16I3vH6Pz/+e/avBTOpTDAH/Csa3kbnyi?=
 =?us-ascii?Q?Umhtvo4Ql4JiQH0n4ASysPKlZdZScWyuytalOwARoed5OBeaWLgPkeDz9QAc?=
 =?us-ascii?Q?Wwfm1CGGTPvH+24Ck/fVjOElayY5AFb50DKA75+WxP0dloqCTnOgHmQVJ6Ft?=
 =?us-ascii?Q?3bSc1yYigB3NAcs56X6H5KvMsllPB1D0OER16vGZxAaWFxBsyW7TEiY11DRN?=
 =?us-ascii?Q?4eN6P2iMjSWPKIsGYfzuWV+h/LjWBK5d9rCOqdbqUEtyAYrxm9cZ2DJmPxsR?=
 =?us-ascii?Q?JMRFgX9saK8oIIkylEg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 20:52:50.4288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9a826b-2d19-4676-7349-08ddff9a274f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575

On Wed, Sep 24, 2025 at 06:42:15PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 04:27:00PM -0700, Nicolin Chen wrote:
> > Update the invs array with the invalidations required by each domain type
> > during attachment operations.
> > 
> > Only an SVA domain or a paging domain will have an invs array:
> >  a. SVA domain will add an INV_TYPE_S1_ASID per SMMU and an INV_TYPE_ATS
> >     per SID
> > 
> >  b. Non-nesting-parent paging domain with no ATS-enabled master will add
> >     a single INV_TYPE_S1_ASID or INV_TYPE_S2_VMID per SMMU
> > 
> >  c. Non-nesting-parent paging domain with ATS-enabled master(s) will do
> >     (b) and add an INV_TYPE_ATS per SID
> > 
> >  d. Nesting-parent paging domain will add an INV_TYPE_S2_VMID followed by
> >     an INV_TYPE_S2_VMID_S1_CLEAR per vSMMU. For an ATS-enabled master, it
> >     will add an INV_TYPE_ATS_FULL per SID
> 
> Just some minor forward looking clarification - this behavior should
> be triggered when a nest-parent is attached through the viommu using
> a nesting domain with a vSTE.
> 
> A nesting-parent that is just normally attached should act like a
> normal S2 since it does not and can not have a two stage S1 on top of
> it.
> 
> We can't quite get there yet until the next series of changing how the
> VMID allocation works.

Yea, you are right. Let's add this:

Note that case #d is for the case when a nesting parent domain is attached
through a vSMMU instance using a nested domain carrying a vSTE. This model
will allocate a VMID per vSMMU instance v.s. the current driver allocating
per S2 domain. So, this requires a few more patches for S2 domain sharing.

> > The per-domain invalidation is not needed, until the domain is attached to
> > a master, i.e. a possible translation request. Giving this clears a way to
> > allowing the domain to be attached to many SMMUs, and avoids any pointless
> > invalidation overheads during a teardown if there are no STE/CDs referring
> > to the domain. This also means, when the last device is detached, the old
> > domain must flush its ASID or VMID because any iommu_unmap() call after it
> > wouldn't initiate any invalidation given an empty domain invs array.
> 
> Grammar/phrasing in this paragraph

OK. I asked AI to rewrite it:

The per-domain invalidation is not needed until the domain is attached to
a master (when it starts to possibly use TLB). This will make it possible
to attach the domain to multiple SMMUs and avoid unnecessary invalidation
overhead during teardown if no STEs/CDs refer to the domain. It also means
that when the last device is detached, the old domain must flush its ASID
or VMID, since any new iommu_unmap() call would not trigger invalidations
given an empty domain->invs array.

> > @@ -1183,8 +1183,11 @@ size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
> >  			i++;
> >  		} else if (cmp == 0) {
> >  			/* same item */
> > -			if (refcount_dec_and_test(&invs->inv[i].users))
> > +			if (refcount_dec_and_test(&invs->inv[i].users)) {
> > +				/* Notify the caller about this deletion */
> > +				refcount_set(&to_unref->inv[j].users, 1);
> >  				num_dels++;
> 
> This is a bit convoluted. Instead of marking the entry and then
> iterating the list again just directly call a function to do the
> invalidation.

OK. If we want to generalize this arm_smmu_invs_unref function,
I suppose we will need to pass in a callback function pointer.

> > +	if (!new_invs) {
> > +		size_t new_num = old_invs->num_invs;
> > +
> > +		/*
> > +		 * OOM. Couldn't make a copy. Leave the array unoptimized. But
> > +		 * trim its size if some tailing entries are marked as trash.
> > +		 */
> > +		while (new_num != 0) {
> > +			if (refcount_read(&old_invs->inv[new_num - 1].users))
> > +				break;
> > +			new_num--;
> > +		}
> 
> Would be nicer to have arm_smmu_invs_unref return the new size so we
> don't need this loop

The "new size" must be invs->num_invs subtracting the number of
the tailing trash entries. So, arm_smmu_invs_unref() would have
to have the same loop validating the tailing entries, right?

(I will address all other comments as well)

Thanks!
Nicolin
