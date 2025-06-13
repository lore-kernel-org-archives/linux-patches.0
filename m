Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC092E11D4;
	Fri, 13 Jun 2025 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856677; cv=fail; b=rpOJOr4E94rDLk1ghZIsi1tPLXnFqH2iwrHo2T8OjzDKeKy2nViMRLBrhBT552bSuBvCCKAc6v4bu5vvKYoInmTW0dypJi/kMkmifkh56/ko7QbU99AuEh8cI3erOojvjQVrRESL6PehfdGCtMTImfHrvQZLajYMOTcXaUk9YOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856677; c=relaxed/simple;
	bh=iy4eLj3a/DCgQ8yp4q28CvmcQolVFV2ZHQsxFdLTxl4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=otg9brQEgtmci3kr2jrJ6j4weirgNMXR/8aUjkTQF4tO/oUy6qYhYGJdnIfybd5sqVUWv97V7S1GNmET7/ISRImLGnWURC+2Y9ScKK9rF8U1F9T0Qlt6qbG1+brm1ndziBjBCpa8PLLDBpOAc4e+vbo0f6PMTeKpYoRrOQz2KTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YjIjLwqo; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YjIjLwqo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZsbiyXmaAOWZW2L/x4EpAvzQ4NjrJzmL713NtHytqrfRynpbnA/1M99FCEjtdIHG+vOTHFHCTirl6YcrApJaooWPNB9AVpLwTQyYVzV7ArfWJ3s+a0+LzSFHTbT8E+l7VFp1xwu3iQzN6TrWq6JZ2IMBXg4JYbZHzaV2UlEZVdA0uIJ1K9MC1W7Yevs3OX7oZd7X+qdw7J5NDUGWvDvSn/Umvl21AQEsh/UrGDcC7BP/LupkeykRvPaqplADPVZp7ktynpaJ5GaM5eNdZouQ4p71+S84aGCAAtJsuLpzljyE3Qbb/iScij9+x7Nj8kk6w2kn2NGZT+wx2uDsA6zbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Po1n59z1FxV07FPJAP6oBU3+0MBf4fmgWHUxvH8gnw4=;
 b=nOOxMhx5Lt5vatCObrPh8Kt6uZKYZezODpMIE+8WJqtaAbxK40uLSKvQV5qyToLiCtFKhSRUfdJ8dlZ5u6pMtXwMOvWnqZ/SN/KsH0bCTsZ0IiamnbmO4q2pXXzuhoxeY0t3+VBLHTyPTd3uHprigY/4Ql2hBMWxj3I7DGhvFrf2mxUZ0NCFZYhagsuzlALjDqLLLcegEjh9APM+R+/r5oBkVQoF1P8Ol+CQLSupRY0QnEFdO+qTA40qMbr4FzOjpz2/MxGjBzYvcqKaXVGg5gJxx9xFIXN9POKBAqU7N6eie5VfcAabaqq3Vn/g4eO+zNBPjo0mWPopCFMgt011wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Po1n59z1FxV07FPJAP6oBU3+0MBf4fmgWHUxvH8gnw4=;
 b=YjIjLwqotvvpr1X+lYsFxJpECC3jvoG5M+oUJ1yZJVWyNurv5b+C7rWU3cm1dhaufa3ov/0jKhqkV8ez53RXmiwMJp49LEkIJydO98ZGliToxxK4j1drGtcqIVqtNiKTVHX29ZNYLqUPrWvODiOnZqH3tFHRI22R5fldK+b2DMiVQrEyShY01TCxBEdxoslXbQsoFiYMkk8CEG/yHiCUMu0BEUD9WyFnFl+FXUhjBsHRMMUnytp8giF7YHrQ6MtMhM1WU8+v7qQRocnxphbEO725G0Fceg5+pZ7xClKQJoeTyDGVh7/vfldO8hqPoUU3IVvLfq5dUueiLYbKDrhKkw==
Received: from DM6PR13CA0036.namprd13.prod.outlook.com (2603:10b6:5:bc::49) by
 BY5PR12MB4193.namprd12.prod.outlook.com (2603:10b6:a03:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 23:17:48 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:bc:cafe::9a) by DM6PR13CA0036.outlook.office365.com
 (2603:10b6:5:bc::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Fri,
 13 Jun 2025 23:17:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 23:17:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 16:17:32 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 16:17:32 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 16:17:27 -0700
Date: Fri, 13 Jun 2025 16:17:24 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kevin.tian@intel.com>, <will@kernel.org>, <robin.murphy@arm.com>,
	<joro@8bytes.org>, <ddutile@redhat.com>, <yi.l.liu@intel.com>,
	<peterz@infradead.org>, <jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 11/12] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
Message-ID: <aEyxhKOSlvP23/81@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <52edfd3e74c264f0f7b1f706d29e9edcb705e2db.1749488870.git.nicolinc@nvidia.com>
 <20250613135817.GG1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250613135817.GG1174925@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: a9cd74da-e088-463d-1cb1-08ddaad082b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LjtQXZdXU3dBBL95fb43pwhm1r96DWkoBGPG9gLJxvsUqsTHY3a3qTWsG5tY?=
 =?us-ascii?Q?dQMfrdOnQ8OZN+4JItdIbgYComeqnXimHw6pxRa27xgf2T4Z3PjYo1TgAwOt?=
 =?us-ascii?Q?9258zWOxx80sBflmZWsun4twHJpwdm1RmAm67MnJMusU8aS1GSGAlR5s+obP?=
 =?us-ascii?Q?Wr+ic6cgBst4jf1UVQuK2FLLzmdpJatichQVSDHNZFN5X3Nn7JbxgblF0G+H?=
 =?us-ascii?Q?+YWn64a8nI8PlepT7VjS2+iXma/hIkok/AkPvvTz2p+HOngyHplOXFt/wd+y?=
 =?us-ascii?Q?WpEpA/M6r2QvsAH0FATpnEizKDW7AuhpDvt2U/yMQEtAMiGLT/c3Y/PD5Z8h?=
 =?us-ascii?Q?saxh0C89Bo3a9KVx5wsZNliXuG+W6EVXTyAqFUSpmDYkyWXcKoPdfyQTmZIo?=
 =?us-ascii?Q?dXR3O+lOVq1zyE6xfYuvvZXXma1dI8Uij0YTgXjDiv7E6QUywBwC1viR3z7F?=
 =?us-ascii?Q?ePsxzeyOKVtjl0rl7gQJPpdeia0wjhn4fpgVpdJIIXK7a3tJkyT5fQcecARL?=
 =?us-ascii?Q?sIhBB53L31NNgqf7Z+fJoYaaSnqk5ZUAV0EiQAr94Kcho2o2i0lnhZffQgIS?=
 =?us-ascii?Q?mj9J6L+RM6y/pZSgyXme3Egr8AtyYMVJNjySh+D74xApq+rFwNRy9uYII6Sh?=
 =?us-ascii?Q?dsL7IpjjfnKxIl51w7rx7CNSlKGK8txyK4nEWCl6W1cjxjSwCtSzWGztVH8/?=
 =?us-ascii?Q?6w4MdpIsyB3c5BBSGjQS6U0wZOfryKQRCAJYnEp6vPI8uvOLNr8q4FAF+Vt6?=
 =?us-ascii?Q?0dmGA+wBA8tZJZx9C9wDBmuVzDzd5Imr6wIb3Wp8MdudvzHtLGM3xJgggxg6?=
 =?us-ascii?Q?LVnQJI6o8SEAAkFB3LVIUHjdLGyBYnWN2g9G8mIjdBOhoR9ncpJUpcjpcFrm?=
 =?us-ascii?Q?23JfDSZg2vr5VyZoO5+3PkopfeEPq2cIKGctYe6qCIRcQMXiaOVzrYGCTZ0m?=
 =?us-ascii?Q?18V4c22aAmFeVf7Zs0x2Sm45NmC4p1yaIJ4eg7u0JQlbQgfIK62JSP/L94/C?=
 =?us-ascii?Q?u8cpYlpDwxkckwRaBQufSvOLwf9S9TxtaJOv151XM0Tor4w18Q6tdFM8RRpN?=
 =?us-ascii?Q?lNXY2JKoOr4adwGHIkm5Pex8noa4eoieqw46uUMdJ9Z6mj8bj+k9p7AilOy6?=
 =?us-ascii?Q?kLGs6+T4Ha/2BfTVSW/g8tlWX8I2sDWAv0uavyXpsEegnbFWuMEtvBOQGy8w?=
 =?us-ascii?Q?Ob9TamjHze5CtD4pvyfQY/UeiFH12De+QzyjixiI4WPbckTK+AeFJoaHmFjd?=
 =?us-ascii?Q?xHeqtN0ofpFbPpzKFNI/YU4OSzY9WiKRC6xQZ2iQbwRxYD4tV1vs6DJ6R1rC?=
 =?us-ascii?Q?FoOWc6noiucuV3GKZuand1FcTBSOJJvPW2OPYJsvlvoMMUBjj8Of+nbaTJbT?=
 =?us-ascii?Q?MYTEbVwm5ZaPs8y/kxhRZYW4x/K/O8B75i/1qzcRF9oqnakeBYRElT1IPBk2?=
 =?us-ascii?Q?3jzd4OS7R3r3SGi8LKmCbGTBFJcDJ2Kt74/T5KtmHF3ClMVGEf97inIBtNID?=
 =?us-ascii?Q?WdjS9ueMVQDlTEvkLpsOkRFR8RjDKqDyJf5K?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 23:17:47.8063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cd74da-e088-463d-1cb1-08ddaad082b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193

On Fri, Jun 13, 2025 at 10:58:17AM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 09, 2025 at 10:13:34AM -0700, Nicolin Chen wrote:
> 
> > +#define iommufd_object_alloc_ucmd(ucmd, ptr, type) \
> > +	__iommufd_object_alloc_ucmd(ucmd, ptr, type, obj)
> 
> Lets add a comment here and on the normal iommufd_object_alloc
> explaining that this function automatically calls finalize and abort,
> the non ucmd version requires the caller to do so.

Yes.

@@ -231,6 +231,11 @@ iommufd_object_put_and_try_destroy(struct iommufd_ctx *ictx,
        iommufd_object_remove(ictx, obj, obj->id, 0);
 }

+/*
+ * Callers of these normal object allocators must call iommufd_object_finalize()
+ * to finalize the object, or call iommufd_object_abort_and_destroy() to revert
+ * the allocation.
+ */
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
                                             size_t size,
                                             enum iommufd_object_type type);
@@ -247,6 +252,10 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 #define iommufd_object_alloc(ictx, ptr, type) \
        __iommufd_object_alloc(ictx, ptr, type, obj)

+/*
+ * Callers of these _ucmd allocators should not call iommufd_object_finalize()
+ * or iommufd_object_abort_and_destroy(), as the core automatically does that.
+ */
 struct iommufd_object *
 _iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd, size_t size,
                           enum iommufd_object_type type);

> > +struct iommufd_object *_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd,
> > +						  size_t size,
> > +						  enum iommufd_object_type type)
> > +{
> > +	struct iommufd_object *new_obj;
> > +
> > +	if (ucmd->new_obj)
> 
> WARN_ON? Something is coded wrong if we hit this right?

Yes.

@@ -67,7 +67,8 @@ struct iommufd_object *_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd,
 {
        struct iommufd_object *new_obj;

-       if (ucmd->new_obj)
+       /* Something is coded wrong if this is hit */
+       if (WARN_ON(ucmd->new_obj))
                return ERR_PTR(-EBUSY);

        new_obj = _iommufd_object_alloc(ucmd->ictx, size, type);

Thanks
Nicolin
