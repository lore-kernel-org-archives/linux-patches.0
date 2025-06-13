Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5425664C6;
	Fri, 13 Jun 2025 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749847539; cv=fail; b=UiOZBdz7P2m2ur27wiAhuR/DuxkIUzDWVjeH7gWs7J2CCJOZoDfAUAtxiVkdKDbphUrSj9hDyhkLLz8YYxifOWHReyNW3nDSB6USZnHisYC7nLdha7TIHkfvTtLm15a561GmmMG96CvasZaqVKRoFdeYGSlDh9B7JW+anRDBM0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749847539; c=relaxed/simple;
	bh=rgxhmLm/ok6HD70vpWuCTaMB/hIhr/1othYzsavDl3k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FexblL+WNq4DaDwhRAC1W6gI7ZwrDjmKt+nNwc8GzH3OdInpzNUxcfbfAnfvjxI0k2/XtvgRFnpg3Nx4Q55SCn24LtV4r6CjkANUj4ql4CA4LvWjJnsNWqGKvBoNRKk47MJnfNEp4ZMBOrAmBTVK6XOphpavZjF3TTZ9l8GkQQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=izPo5r/Z; arc=fail smtp.client-ip=40.107.100.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="izPo5r/Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jY1edbxiesN2yJURNoO9F1wrKIakTRm1HpEgVO8Nw2nIf3Gqxo1YmA9yy4lbK1yXxUiopsBKwhkH7oKwBtdnywE7+1knCmJ4Axu42cr2BeTzDZmomTnx3x7Z5G345yRgsY9hFQkw38xQUpMU7TKqA7ca0XId8qK5SZOrXNw29WDfC1Ukpm9hj+XztT5uXRYIgNBBlyxMDCeVYbJH9hJ5/vOeGr8ERPitUvjV0QT/JFDxeB4Aeya6pFOMzIuAuY/ZmaitOUUuJCnZYAWg7czemhdDmO+nUBAg1HMGnXSyxhyglPixq4PSW+EVMe6lK9d9Nzg/pvOAr9JEohj6RGz/ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JvqcqrO9jEjwbsPAiWl//LJizxHS7de0HL0faHw9hg=;
 b=DApJiwImljdosfL0tIMs5Mcz5b8KPjpCEnvOos9U8nbNmiLKQfnCjuoEjGxzLam5DHJwVqZT3syOCxXxbscaKyj4yntvT5T/7ONwbab+7Jb3qOMjiL1d1jRFWurjF45pja8I8RYbOMEepqmSC5PT8tZl4lrPyK8vZ3e7j2NDclk/ZXqrkd6E7DsoHS+qqbG8tyL856V5tk8/bqCDRLRvPzy00B+3ckSC0ybO8PBP//ZRT/MwdtvnbOUhHmc9w95gr35BKs/N5Dg6P5iGf27SdMySM/06hFKqfBlMUxxw8IKWyHBipqy9+UlsPod/mK40ec/r8FCZpDQemUX2bOTOYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JvqcqrO9jEjwbsPAiWl//LJizxHS7de0HL0faHw9hg=;
 b=izPo5r/ZW4apfGCTe46Kpea0OHdTQJ7sg6V82xzaS9EWMwVJurOll/wZiiE0aZ847wASVd3kt2L8hsQekE5kfHcl1Ln26xKKAtzHSE6j0HtvVscK4aeI2DMdJrR3QncQUemrkXUFxSJLcKUEe3TOvo3Tg3pb+XsPdvQl0ZJQ/gsPTzwjUZNf0WPhyASZrHbR+gzvU18lXLQSF81AMAp7vWgldJwKfts2ShBj7Ql9SihzcO1ax8dO4kxq+nAEBK7D6alfcKXOPbh3AEjVFtkoS9PhZrZdd3+YtcaMIf0u7GDHel/9aP1hoJ+V8Mgf6wEIZEejX/NYGLQjNPH+8k5nfA==
Received: from BYAPR05CA0099.namprd05.prod.outlook.com (2603:10b6:a03:e0::40)
 by LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 13 Jun
 2025 20:45:31 +0000
Received: from CO1PEPF000044F6.namprd21.prod.outlook.com
 (2603:10b6:a03:e0:cafe::11) by BYAPR05CA0099.outlook.office365.com
 (2603:10b6:a03:e0::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.21 via Frontend Transport; Fri,
 13 Jun 2025 20:45:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.0 via Frontend Transport; Fri, 13 Jun 2025 20:45:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 13:45:12 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 13:45:12 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 13:45:08 -0700
Date: Fri, 13 Jun 2025 13:45:06 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kevin.tian@intel.com>, <will@kernel.org>, <robin.murphy@arm.com>,
	<joro@8bytes.org>, <ddutile@redhat.com>, <yi.l.liu@intel.com>,
	<peterz@infradead.org>, <jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 05/12] iommu: Introduce get_viommu_size and
 viommu_init ops
Message-ID: <aEyN0oY/Y8n0gsVb@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
 <20250613134117.GD1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250613134117.GD1174925@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F6:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: b85714c8-ee46-4977-cb9b-08ddaabb3cc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GPk0Rdw0jXAYSuwpikzNkhSoknGHF41/hDJpqRx+FFC8Jp3mWOlK1bmxgqY3?=
 =?us-ascii?Q?EHhWuheV7UthF2ABwvKg0tWPPA7311031BEkfeyKT73h2I78FiSeIx6n4GM0?=
 =?us-ascii?Q?lBQZf44R4Rl/Ja5Y9PFHxJ8i8qwyr3/iEvuhDMfhxu8xEuhVykehNort1xU9?=
 =?us-ascii?Q?bQyhsVRI9n9w3oyWhXsayRYQ1wtH3zdZLa6kfSwriuYH7q8Q3JWp5vUOYA7K?=
 =?us-ascii?Q?+iuyBG/yMXXwzZecGUdcBt/1rBJuI4BbCsFKH8h1ChhK+tii/dQ7smAqkDOm?=
 =?us-ascii?Q?95J6pJ6qLXkjABGhkoqB2HlYX8T6waPD1DwBqnILMJhulGHeZ11RxtUnvslB?=
 =?us-ascii?Q?79YX0vX9HkOK/9fS1yn5qW+2SAVkYcwOHPsgscKs4hFhno3XqhURcZbcdGUT?=
 =?us-ascii?Q?KPjzBBioDnaRgMpOvAnui4XPLX8rxRtTDaOaj7FhB5ywGJShjiXEyb/qetzx?=
 =?us-ascii?Q?tNmAgjZZlpWMXFg3zaXvL5Mi1AWpihUtyUN0SKu2yde9ntQQ5GUZj3pEOtUr?=
 =?us-ascii?Q?dyHtHABXl1O/PeDSkMGeMn9wRsYAVeq8+9pLVWS5zCCnvh9ZU22l4odPWJ4L?=
 =?us-ascii?Q?lG3NfgTANoDVSCbzrHprS/Hqv3sHjjcPpYN+Lyaowx42Xurg0/iMEFRIO/F0?=
 =?us-ascii?Q?WLzj7IOgZDiUEmXOKTW8sx6IJkYUcxcz+UFy4OW03oToQyyILu5E9Te68LTU?=
 =?us-ascii?Q?QZHH9fRP67rKRPl1j5fO/Fcpps7bEoDw5cIJJUO22q5mPzTn4jzCEjxie86m?=
 =?us-ascii?Q?Me0O59C2OY9pIeLWzeDETGZmhx6yRaAAdWo0FkDYO1VMQXYrisuPGjsSLC37?=
 =?us-ascii?Q?5vhyE/znQwEv8Y79EHUY71Q1kh55N2ymy5YXljfPJZl+rqsk3AgjiowLPtfA?=
 =?us-ascii?Q?lnDNrXWSU5cKRrIOnRiX+OoVoVkB33qT/wjhUapigaJean3iP1uGPxk8MpRy?=
 =?us-ascii?Q?4dVAqgJnqQDg6DXxCA8eLWErbqHDhccYAULNl/6gLhauSFxRrf//IWLOw2Cx?=
 =?us-ascii?Q?Wz8eZtpJhlXY+ThXxYdA+13uXan1ZBN+2bqh0k9rG0PGCUnvjbMYDofMi35L?=
 =?us-ascii?Q?o4qvHM4rUto+mZLyyWil9R6xxpS5U7rTcjDDIs/nlRJ9S+USeJwDEIKmOyuS?=
 =?us-ascii?Q?TxU8hu58pGRsKV5iA59Q3yuexdOx4w4A07WJ8Ud25zMUXwgTDXFW47XWDi/y?=
 =?us-ascii?Q?5mCrTAYRQ3/VrvxbB8sSGV3L8AcrE1DdU0pb9a6sTC5DlHFmHyEr4IIOYX7Z?=
 =?us-ascii?Q?F+pBniY5NBMzf8JSECudpe7eYVUTmVyPjVuyKaKALnyDgjqSbiqiPGvhwc03?=
 =?us-ascii?Q?U8Dhizzd1/C1DvxYbSNaKgfENRRVap2ZsxpFFJZLerXcHdlJuMawMGJirVbE?=
 =?us-ascii?Q?tCMbXe7s6b0k8VKr86Sk1xQaUJwqzSN1mTQvDC9tXoyKqLyYxs2T01pW9Y6Y?=
 =?us-ascii?Q?4ERllhVWQnAxFhk/JW9fOCfjmrWVOqQP7Gk1ZHHiWmQWba28n0bR6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 20:45:31.0144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b85714c8-ee46-4977-cb9b-08ddaabb3cc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168

On Fri, Jun 13, 2025 at 10:41:17AM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 09, 2025 at 10:13:28AM -0700, Nicolin Chen wrote:
> > @@ -654,6 +665,10 @@ struct iommu_ops {
> >  
> >  	int (*def_domain_type)(struct device *dev);
> >  
> > +	int (*get_viommu_size)(enum iommu_viommu_type viommu_type,
> > +			       struct device *dev, size_t *viommu_size);
> 
> I'd return the size in a size_t instead of using an output
> pointer. Make 0 mean not supported..

Yes. Kevin pointed out the same.

I found that the final version only has EOPNOTSUPP errno (had one
of WIP versions reporting EINVAL). So, yea, doing a ssize_t would
be cleaner and EOPNOTSUPP is probably enough. Will change in v2.

Thanks
Nicolin
