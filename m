Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010032.outbound.protection.outlook.com [52.101.85.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DEF3559E4;
	Tue, 27 Jan 2026 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769532774; cv=fail; b=MQkKDclBX63x31WEITmuBZVhQ3YUkSdqhKv/J/J3BmEs4jAxIXB2mkotNiPH+NYTxkIZ6p/XHKY/5xfdTgyxXT3IY0okUnVeUnmU8hl3pHxWYcS7W/qGg3JZZRF11I5BTR5ZCQPjAodcvEd0ieXJIb4KtYYa7tvPkwDJFtBHhFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769532774; c=relaxed/simple;
	bh=a7MyYUaCThWRMXDQIhaYuTYRlEzK62D/CL6iU0eprk4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eojOlshOqd2M5RMNEWeMMwIl+x+G3Td2zD1TAKBKLLc6P2sPgjBQ8JYUA0y3F2H1DTsMiuwFy7kozjgL/hhVlgPopoaoFWLJji0F42lvtcxlbrHVuZY9X97X5UrzuWAEPno9Wupdn9yjHaB4IcUS70gE0SwyFy5rXoCc+mSSvqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DLfzmTDs; arc=fail smtp.client-ip=52.101.85.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DLfzmTDs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5rmK+vmPMhzbs6ilyP/27zjtIjLs1gjDZcbIr3hsbmbupjkX9YAYLUgPcv49PMBqRZ55wVHISp9bsRGoyyzLdjGkeSKQG+nOgB3KGCD2VGQSAKqL5mo4QCK4t7MpfljctnUVKxb4X0ifwz+gsIvh9v/tFQ2w1UIg4LKzpY+wnOfqZCbqy2vzuqyybao0S3dRxyXcKOYxStxedMGKDC5G+gR+/4P9WWUBxBAxgOXWIRXGldjyxB9PlvkcK5+Le2H4aDpygoKdNTPxVM04bgIxIbZxrmqIH4VH1UaLGR++O4ea1uk+a7yTsQIqEsxL3U4uXZdXdutne23pWs1W784Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oh2kpi4HJf79zaI0xXLqIb596d3juJvs3kCwEe6vDCc=;
 b=jpanPfcrHk5DyqDO0GBWox/6RvaBMMyTg8zR5W2vfmlnVQKEPTRVBJOvmwIo8XHgimpm4gl4nXpbfWY07/2BB4RPOIrsig57Py2Pb/Uwrv/Jlpuyb/X3E+tFHh5IJFYrgCgIEpGSKfmQ4ObTgEjNdRy9rNSiEeR2Cp93onQd+YHIvxh82TUszN1oKy+am1UfD1CuOgHQjBVK0uprbLCfIqcOA5KyMDSHwiELw5GjK98PUimh5ThUIMKcBkOZtqZ2t5lX+AM94p9mU7lJovilzDyxkzur94Wxn4NURnH413iJx7Fx2Ear23oEWlioWHExOfVPmB8JSbLp/JbCbzLRNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh2kpi4HJf79zaI0xXLqIb596d3juJvs3kCwEe6vDCc=;
 b=DLfzmTDshIpNUBIGEtLbNmFmNFiDDtov0wEdxC9CEE5JfcBs6ucgulhWrgLdRTJXCHYsTpRbMVB0F9al6KXx8mRjx/jlZtBPYsSQAXvtxL80p0/nT9ppJ/OpOse2Ja/C10xV5gUHAq9fW3iMIJgfm9K81TN/DaS3n4cDggc7wVKpti27NmI7O+quMwAs0xEHfBbtXBLRob84XYVZWWCljo8eEUk7Lk3sJhGWr/vv/BhOjxiCaPDDLLJeCI1JONi7AdaQpZFj8qRxKMeDxZUvu4rv56b4ckTxeEGzHNn9BLtTpyDjEQ7bu7PHJJvOMKVUpmOD9eVjP3sGzMW9nJ6z4g==
Received: from MN2PR03CA0010.namprd03.prod.outlook.com (2603:10b6:208:23a::15)
 by IA1PR12MB8554.namprd12.prod.outlook.com (2603:10b6:208:450::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 16:52:47 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::3b) by MN2PR03CA0010.outlook.office365.com
 (2603:10b6:208:23a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.15 via Frontend Transport; Tue,
 27 Jan 2026 16:52:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 16:52:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 27 Jan
 2026 08:52:24 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 27 Jan
 2026 08:52:24 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 27 Jan 2026 08:52:23 -0800
Date: Tue, 27 Jan 2026 08:52:21 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 04/10] iommu/arm-smmu-v3: Allocate IOTLB cache tag if
 no id to reuse
Message-ID: <aXjtRandlgc7J/cm@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <85f3361fa07ca6884500ccc917da6f6b84e13a6c.1769044718.git.nicolinc@nvidia.com>
 <20260126210640.GZ1134360@nvidia.com>
 <aXfpaN4UCYcY9W8T@Asurada-Nvidia>
 <20260127162908.GL1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260127162908.GL1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|IA1PR12MB8554:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8f3469-6c68-40de-cbe1-08de5dc47ece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FdVevaglitQTDb2ZF+WcKNAe3ASiTrlw5LpWVqwwpKprauw70wUGjjZYxSI9?=
 =?us-ascii?Q?p+sYXz9dJ95im1VhYGTX0IkI5SKCMN1ruRzrqpu2ZsIMkTimERQmSswD/72e?=
 =?us-ascii?Q?6scPfPVdAPPfaskdxnISJ050R8wIWMm2Kluu4ZaM/ezA0U+r1uadBTSbFynF?=
 =?us-ascii?Q?+xLEKDE09/xUHX7MsBrzry2XABYoumeoyC9eYdaTRZ/C20OhbVupX9+GHpic?=
 =?us-ascii?Q?SZqNrdk6TJSUQ43fdAn/I58m+UHJ82fKOfz5nc/F0H09/7bsghQ6TatHvOcg?=
 =?us-ascii?Q?y6LDh6flicf1H0yXoBhrNP25ovZSaXvrCaXc+vsnuNfBUpGplvw4VxwPN75Z?=
 =?us-ascii?Q?LysmJGL9WQn2ov8BPxzdFhr2Jhd2oGXh94EwsKvp/HwwprbJXGR8YnAAgDgJ?=
 =?us-ascii?Q?20Y9XJZVSiyn937VscJ807QVk+EJ08zYun8cjQmnLG/TuhuwtNCE3uA/RvyP?=
 =?us-ascii?Q?pe0rjBU8HLgaD85QH0MvdDS9CjLoroAJkux0NHtIHgAPjPzFiE/vz9SUP4yp?=
 =?us-ascii?Q?pB8EL/M2ucLbsPXL8wGDybQMT5ryWlxXBye4wQUb4cJRVMWoE7zqXMuvRc8i?=
 =?us-ascii?Q?tctP8jPcN5KgE/Qm2mRgr3XgHnPjvyORWaMTMQu6otQNTxTT4I+/6MwG29zL?=
 =?us-ascii?Q?hIVQA1a/vJzC/hQz6M8lGeIc+qkj2QSSrcyjSCTJjWea5quQ6NQmdpTh8VXw?=
 =?us-ascii?Q?YCW/a36Yh67jSCg+YPEakgqNPm722TFh75GEeUHjkJ005J1wm5MRyuf3eSfX?=
 =?us-ascii?Q?xQUhFe6OMDTW0B7busonQelh4H5xQR5jGfqd5mJRjXecAqVROVZFLSH27GHS?=
 =?us-ascii?Q?OJJG71mAsPPD4BCjxGfJXRGRfv623VaatFG9iXn5hVN812nS245Yc2XJ2Jco?=
 =?us-ascii?Q?37zyOYr0H9ozXSyNU/frXdXux1BPhssbCrfAo7ePDiaByU5hRHWdjHxymh4i?=
 =?us-ascii?Q?nZ9O/EnowifqZbAsAw7OYeU2Liddr/cVTAfyNZ2zGgxtMp5sfsUqOx3X4PVK?=
 =?us-ascii?Q?hFUI7iLcINvZqzsKS2pAYd77rcxd6TzFxX0s8CJjhgiX0EjKaho8bwEEJLWC?=
 =?us-ascii?Q?XMRtkHn4ITbR6dqRjypWEheG1sZ+AtTFOtQ9gVwGiiaeFH94dW9SZI7RvcWZ?=
 =?us-ascii?Q?AgNK6+vq4y/22vs0xkYrgWvuOe1yZJXT6SJ9YNpZwVT0hm/EKknZdCYXSEI0?=
 =?us-ascii?Q?OBFFxdfuvWs6EApbGUr+EVGX3wViKxJIduKfe2kBgqvja9bf3prQIFQrlx+q?=
 =?us-ascii?Q?mnqIHfsdNHRpJCahcp+b3El50M7walfv1nJWVrczmmL4O/vCN5HRBhvHPRvh?=
 =?us-ascii?Q?n3EDtuAfWhPQ8RUp8qiw5uoWeE0imDswFoaSwnUgiTAmiqmWryM5dAHFsrAr?=
 =?us-ascii?Q?mnlGCh3A04RK7oUcX44HnwN2AYqZ+KY+AIpHDt7SoAaFgLxRRodcoGqBugJf?=
 =?us-ascii?Q?hC/TrJR5FSZUvoQmOjXj0qFO/feoLGBoMQ+rScALkAWWeU/YJQLrLwaibN8K?=
 =?us-ascii?Q?YV/LwWuBp2hRHqlcU0EDvuR034WLkmx0It3rnMvTuOjCZXcAz0vtdYmgve6G?=
 =?us-ascii?Q?RWk5sMk4BcWZSsw8s1ymKNYCCAK9WdE4PufX9hYa4UQgan+DC1Nwtf4A7kgE?=
 =?us-ascii?Q?NzdtP5zpCMF0QeRfq/1QYq1FprDgb5PtfkkvsSeNDo/obkAnKG8JfeD40J2F?=
 =?us-ascii?Q?N7iIlA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:52:45.4370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8f3469-6c68-40de-cbe1-08de5dc47ece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8554

On Tue, Jan 27, 2026 at 12:29:08PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 26, 2026 at 02:23:36PM -0800, Nicolin Chen wrote:
> > On Mon, Jan 26, 2026 at 05:06:40PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 21, 2026 at 05:24:22PM -0800, Nicolin Chen wrote:
> > > > @@ -3220,6 +3241,9 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
> > > >  		break;
> > > >  	}
> > > >  
> > > > +	/* Set a default users counter */
> > > > +	refcount_set(&cur->users, 1);
> > > 
> > > I think abusing users here is a little too hard to read..
> > > 
> > > Can we just keep track in the state somehow with a flag?
> > >
> > > Or maybe union in a "bool needs_free" that is for the on-stack version
> > > of this structure?
> > 
> > This doesn't only apply to the case when a tag is newly allocated
> > during the attach, but it can be used when an old tag has users=0
> > during a detach, right?
> 
> Oh, IDK, I didn't look so closely..
> 
> I though this was just about cleaning up the tag during attach, the
> detach flow worked differently and did use users = 0?

Yes. Detach doesn't allocate a new tag, as it gets the old tag
and decrease its users counter in arm_smmu_invs_unref():

+ * This function will not fail. Any entry with users=0 will be marked as trash,
+ * and caller will be notified about the trashed entry via @to_unref by setting
+ * a users=0.

With that being said, we may still add a "bool is_trash", if we
want. I just don't feel very necessary since we check "is_trash"
throughout the driver via the users counter already..

FWIW, I kept three refcount_set calls in the latest base series
v10, copied from your earlier suggestion. I moved that to this
arm_smmu_master_build_inv() as I felt a bit redundant. Yet, it
is probably better for readability reason:

+	arm_smmu_invs_for_each_cmp(invs, i, to_unref, j, cmp) {
+		if (cmp < 0) {
+			/* not found in to_unref, leave alone */
+			WRITE_ONCE(to_unref->inv[j].users, 1);
+			num_invs = i + 1;
+		} else if (cmp == 0) {
+			int users = READ_ONCE(invs->inv[i].users) - 1;
+
+			if (WARN_ON(users < 0))
+				continue;
+
+			/* same item */
+			WRITE_ONCE(invs->inv[i].users, users);
+			if (users) {
+				WRITE_ONCE(to_unref->inv[j].users, 1);
+				num_invs = i + 1;
+				continue;
+			}
+
+			/* Notify the caller about the trash entry */
+			WRITE_ONCE(to_unref->inv[j].users, 0);
+			invs->num_trashes++;
+		} else {
+			/* item in to_unref is not in invs or already a trash */
+			WARN_ON(true);
+		}
+	}

Nicolin
