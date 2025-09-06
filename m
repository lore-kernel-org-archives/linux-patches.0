Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53A27A445;
	Sat,  6 Sep 2025 08:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757146663; cv=fail; b=W5qjI90Qr04bnawhkut8kTJNuitpaSX86hBUFnFPKjjcY//4/NLDUnbMl+cXXVVXn81tDXl8rGZE4zm+rONLiv9zCxZFoDkMdvHoN4F+Z11m1OQ6DYSJK+DiDDx6bsP0G9vlsv6O7aZ7WOPYvGYwGBK/VrECr7A9Y6dEzi1JP6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757146663; c=relaxed/simple;
	bh=qyx9oNCVx7I6w0KjgJlaObRg5DZBLgcWhI6R2PgnmlA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4C26cSTnbjF61K6D052ORiGk5DX8q4RBoJNbrFkC8c3SVqrExGQDoOaUuU3ryFzAk9t/P6gvvf3zhrSyQyiUBRBVsVk90BYyaiScYAP+iMXJdZXHVBnjxThG3tBJ5QOpOdqxdqH2uo/cklKZbKfuc1+NL5U/y6GnRVLvGhl2K8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r4jU/H7/; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r4jU/H7/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APgtWYOP+Z+TiGv5dAHhVWr6x/30EeL9f303rayEFzRE2UvX2hxken8XXku6uw264N6UCrpqXaNJz13Z+q/oJ5YyvIrGFcmvqaqo592ys4nJs5B/AYueCY+X3k+L3sp7ENTxhyJHm5tyMp2F8BNG/mWMeJhOcTMzm5QwRa/yWE5GgYldBMO0RdXKy6zOx6mUZ2J2PHvGP4rwGz14u2jS7ffeGOYFCSir+Vcwr68qomQd2r1ZJrBr4hzY741lMH4hlYb+b5fVapWp9vahvb4a9meoWVkUcrCDAUUJpnjs/SQjkyzCSAKCJfdN9UYoY1rU7wFD3kLhiBAL76Z1DGl5dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOxoHni5ELv0dgArPYosW7kv4f5uarOfU/4lnmYOo78=;
 b=DLI/6la3sx+JFYwxhmc+rVg4au8GQBmmUf43zQ0iC+t1z//gHd69uAu/6C8uVIhPS6T0po85f5mJhOb5QYzA9vOC9PpoYcFjxzhirOf8oP2SIHBBP5tbjU9dBOkTrdghqETlWWRKDBk21nRNYkVlqJUvNDzaU63Fcur+JIOmImpIIs/jf7JwWOair5hhvBFIbed0ofYCMDiRomAAfSrjAbRoyOUw5WVbpykvRezq+Et5LsUIgdjSnJrqPtTJRJuXFilfPRrxn+P4n/4r0t6RL1QVeL8QbXNpI5A9G9jR4uTqU/+QBUzmGUQljMgpcus+iSlXSIEuesewD8v7lFPPfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOxoHni5ELv0dgArPYosW7kv4f5uarOfU/4lnmYOo78=;
 b=r4jU/H7/GMHXhI9+q1dSXzBvUPuzEPTTL3kdKlSMFslcOyCI6+VhK4TjbX4vJQVRWkoR9KjAHVCj9RitrwiDm3wtLttebk+wB4kBXRF9o7M3M+G8tOPs8CHyyzyKnyZ0Tpl9MNQsoy3aeCR4xq8x6yImpAg0bcF+dvflaWVEpkjbe2JdJX2oFBSxQEk5XUooFDb/45zZ8P5z1h4b+bl0UGxF8+h79nLI62Emd2bPR0vTCY/KBQHZbm1KJYoINO50HjV8GhDSmsRlOVIpwoMLh36XBKrHwQTEy2F2ifFgdRo8kccDEyf8weaueVBbw14LikKVafeb9R8cxdK1D2c/MA==
Received: from SA9PR13CA0055.namprd13.prod.outlook.com (2603:10b6:806:22::30)
 by PH7PR12MB6980.namprd12.prod.outlook.com (2603:10b6:510:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Sat, 6 Sep
 2025 08:17:35 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:806:22:cafe::86) by SA9PR13CA0055.outlook.office365.com
 (2603:10b6:806:22::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.10 via Frontend Transport; Sat,
 6 Sep 2025 08:17:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Sat, 6 Sep 2025 08:17:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 01:17:17 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 6 Sep
 2025 01:17:16 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 6 Sep 2025 01:16:55 -0700
Date: Sat, 6 Sep 2025 01:16:45 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv1 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <aLvt7WBgvVsAD7wC@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
 <20250827200002.GD2206304@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827200002.GD2206304@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|PH7PR12MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c2698a-07e9-4589-0839-08dded1dd58a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KgSIbp/MLcCPh73q7ReWrrZfwjx3OfblENInqcrSbFGeJVgn6wHA1PFTawXe?=
 =?us-ascii?Q?wh4oU/ksHTU/dV/fMtZBLy9Drzh7843oqTjtlN1tUpp6NL8EkfbZbCgjVWY9?=
 =?us-ascii?Q?ZY3BeJqSdYXG0m20+M5/oKWLNx8EFYScxJ/kRkVuF6n3iqJ1FUhd2vZuWRsD?=
 =?us-ascii?Q?XLqh5s9GgVK0tnlcwb3a5s7toJ/ww2TYg8vis1dq9XrbDhiEo5KAJ538Cd+6?=
 =?us-ascii?Q?u7XIBvwCn9qXES5h/yID4jBmo4WEykbG0oXgpi9MOdBxc3bSY04dtB93ttfY?=
 =?us-ascii?Q?5C+uGva/vAf9Ltu2zVvbSFalbfkqcv46wsonqQorziHQi+slstmPRFGQRbVv?=
 =?us-ascii?Q?Qt5N3fdl3rciFn/xS6wuzQ3DVLgCztfhoNMIeGD9GSTE1Z1lLZUzze4SbGFc?=
 =?us-ascii?Q?H3lz+r/c6RyKLTNQ9DV1SH9XIFLkcJSan9YdcCQYKZA63UULAMVZGCqr+Kek?=
 =?us-ascii?Q?oJtI3o15nMsNMxer1gD07lYa45USr6gV7Izv4yF9ptN5opjkMQgk9P6tGwRE?=
 =?us-ascii?Q?eTGBV3KY6hyC2JuthBCigpdVbYddpi/pfZkBTxaiaXQ0kQJSQlglysXcv410?=
 =?us-ascii?Q?NJGnnN/GyQKfsCZmHwLP03I0AM94Mu/ivc0bNb9rzQV25wJUS9/c69hW0sdC?=
 =?us-ascii?Q?7VrIpU14GbNminrQzsFlb50pvYTb9fRrwhO0tcPlZV0nT2DzA1Gwfq3ioEnI?=
 =?us-ascii?Q?sXdSynFPh6g5hfyRxeeNkHZC69g6PEZfS1l04SN/1+bkobG0LZTeNFt8Nc/l?=
 =?us-ascii?Q?NYV1IRjiMze23zimZn8LxmviZ+otrPXgZUUhhiF5HHUXiE69DRFyHEzIjCme?=
 =?us-ascii?Q?v0afzApixuelcUF2c0rO7qkDtrhUnrNEqXwPbhi27/nseVVyuBdDX8rCl8s0?=
 =?us-ascii?Q?ge5hW3F+dQHZbcluIawZDEcB02uGOcsMLDvnk/oJTahHEq5npWGLO7+ePQMj?=
 =?us-ascii?Q?T4+eWZQg1XnAD0c8K5ScnJQXFY5P82rf9j7fWb41uI7e2ngaLqTfsQqS1IFW?=
 =?us-ascii?Q?/yRxJzl9qF2dUXmokbNuHW2Zvt2BFlMm7dGxWW3sDKlappcWV2zWBjFRnhav?=
 =?us-ascii?Q?BlB2wWjORyeToOfdEyUxyS0gidwyrOK0ArDXs/efqqC14FzxIFWG9I7Q/gpl?=
 =?us-ascii?Q?OOqIHs4obb8MVdS8HCa9bwM9BpcPQaxb16ijWB/k8/0t68ylMX02vbPPUUnP?=
 =?us-ascii?Q?LfVtCMp/Db3EDRu491rI4aDDD1pBeIloTtigaQQKpA4DCS+qQUYnEMU6S76g?=
 =?us-ascii?Q?ETn/S3KDBsTl4PRPr5Lvb/WQNbTEKz1vrMPpKbWcWVfvYOjX7uawwAwk+NSi?=
 =?us-ascii?Q?GmoydTIll1JgPeioWpQssrdQwxvN6MuEt1U3P4A7c0x9nUykDWgDItZh9o5y?=
 =?us-ascii?Q?OUPFeqYyGKK0DF8tfyZa/Uip+lc1+t1tOgnVU8AtYe2KNAdZKl+zNtxxVMEj?=
 =?us-ascii?Q?GMbKPOCt9ZNR5Qjih91CNpPqclS6PgDXT+/4H64RJ3cbOzfSHIUxc+oMJBK0?=
 =?us-ascii?Q?YIoOKNSQbAPQA2QT36cpTiEJo62b+X2sGYdp?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 08:17:34.7555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c2698a-07e9-4589-0839-08dded1dd58a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6980

On Wed, Aug 27, 2025 at 05:00:02PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 06:25:35PM -0700, Nicolin Chen wrote:
> > +struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *old_invs,
> > +					struct arm_smmu_invs *add_invs)
> > +{
> 
> It turns out it is fairly easy and cheap to sort add_invs by sorting
> the ids during probe:

I have integrated this and also renamed these three helpers:

+struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
+					  struct arm_smmu_invs *to_merge);
+size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
+			   struct arm_smmu_invs *to_unref);
+struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs,
+					  size_t num_dels);

Thanks!
Nicolin


> @@ -3983,6 +3989,14 @@ static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
>         return 0;
>  }
>  
> +static int arm_smmu_ids_cmp(const void *_l, const void *_r)
> +{
> +       const typeof_member(struct iommu_fwspec, ids[0]) *l = _l;
> +       const typeof_member(struct iommu_fwspec, ids[0]) *r = _r;
> +
> +       return cmp_int(*l, *r);
> +}
> +
>  static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>                                   struct arm_smmu_master *master)
>  {
> @@ -4011,6 +4025,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>                 return PTR_ERR(master->invs);
>         }
>  
> +       /*
> +        * Put the ids into order so that arm_smmu_build_invs() can trivially
> +        * generate sorted lists.
> +        */
> +       sort_nonatomic(fwspec->ids, fwspec->num_ids, sizeof(fwspec->ids[0]),
> +                      arm_smmu_ids_cmp, NULL);
> +
>         mutex_lock(&smmu->streams_mutex);
>         for (i = 0; i < fwspec->num_ids; i++) {
>                 struct arm_smmu_stream *new_stream = &master->streams[i];
> 
> Then arm_smmu_build_invs() trivially makes sorted lists.
> 
> So if old_invs and add_invs are both sorted list we can use variations
> on a merge algorithm for sorted lists which is both simpler to
> understand and runs faster:
> 
> /*
>  * Compare used for merging two sorted lists. Merge compare of two sorted list
>  * items. If one side is past the end of the list then return the other side to
>  * let it run out the iteration.
>  */
> static inline int arm_smmu_invs_merge_cmp(const struct arm_smmu_invs *lhs,
> 					  size_t lhs_idx,
> 					  const struct arm_smmu_invs *rhs,
> 					  size_t rhs_idx)
> {
> 	if (lhs_idx != lhs->num_invs && rhs_idx != rhs->num_invs)
> 		return arm_smmu_invs_cmp(&lhs->inv[lhs_idx],
> 					 &rhs->inv[rhs_idx]);
> 	if (lhs_idx != lhs->num_invs)
> 		return -1;
> 	return 1;
> }
> 
> struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *invs,
> 					struct arm_smmu_invs *add_invs)
> {
> 	struct arm_smmu_invs *new_invs;
> 	struct arm_smmu_inv *new;
> 	size_t to_add = 0;
> 	size_t to_del = 0;
> 	size_t i, j;
> 
> 	for (i = 0, j = 0; i != invs->num_invs || j != add_invs->num_invs;) {
> 		int cmp = arm_smmu_invs_merge_cmp(invs, i, add_invs, j);
> 
> 		if (cmp < 0) {
> 			/* not found in add_invs, leave alone */
> 			if (refcount_read(&invs->inv[i].users))
> 				i++;
> 			else
> 				to_del++;
> 		} else if (cmp == 0) {
> 			/* same item */
> 			i++;
> 			j++;
> 		} else {
> 			/* unique to add_invs */
> 			to_add++;
> 			j++;
> 		}
> 	}
> 
> 	new_invs = arm_smmu_invs_alloc(invs->num_invs + to_add - to_del);
> 	if (IS_ERR(new_invs))
> 		return new_invs;
> 
> 	new = new_invs->inv;
> 	for (i = 0, j = 0; i != invs->num_invs || j != add_invs->num_invs;) {
> 		int cmp = arm_smmu_invs_merge_cmp(invs, i, add_invs, j);
> 
> 		if (cmp <= 0 && !refcount_read(&invs->inv[i].users)) {
> 			i++;
> 			continue;
> 		}
> 
> 		if (cmp < 0) {
> 			*new = invs->inv[i];
> 			i++;
> 		} else if (cmp == 0) {
> 			*new = invs->inv[i];
> 			refcount_inc(&new->users);
> 			i++;
> 			j++;
> 		} else {
> 			*new = add_invs->inv[j];
> 			refcount_set(&new->users, 1);
> 			j++;
> 		}
> 		if (arm_smmu_inv_is_ats(new))
> 			new_invs->has_ats = true;
> 		new++;
> 	}
> 
> 	WARN_ON(new != new_invs->inv + new_invs->num_invs);
> 
> 	/*
> 	 * A sorted array allows batching invalidations together for fewer SYNCs.
> 	 * Also, ATS must follow the ASID/VMID invalidation SYNC.
> 	 */
> 	sort_nonatomic(new_invs->inv, new_invs->num_invs,
> 		       sizeof(add_invs->inv[0]), arm_smmu_invs_cmp, NULL);
> 	return new_invs;
> }
> 
> size_t arm_smmu_invs_dec(struct arm_smmu_invs *invs,
> 			 struct arm_smmu_invs *dec_invs)
> {
> 	size_t to_del = 0;
> 	size_t i, j;
> 
> 	for (i = 0, j = 0; i != invs->num_invs || j != dec_invs->num_invs;) {
> 		int cmp = arm_smmu_invs_merge_cmp(invs, i, dec_invs, j);
> 
> 		if (cmp < 0) {
> 			/* not found in dec_invs, leave alone */
> 			i++;
> 		} else if (cmp == 0) {
> 			/* same item */
> 			if (refcount_dec_and_test(&invs->inv[i].users)) {
> 				dec_invs->inv[j].todel = true;
> 				to_del++;
> 			}
> 			i++;
> 			j++;
> 		} else {
> 			/* item in dec_invs is not in invs? */
> 			WARN_ON(true);
> 			j++;
> 		}
> 	}
> 	return to_del;
> }
