Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C588614B061;
	Tue,  4 Jun 2024 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717529315; cv=fail; b=o11D/qsbgXHK6uevnOEBRYUXAgOpMH3uQvkJXWDcU0Fs3UQWo7v9Hc7xNRx5xiswBoG1ZOSxuNTYXIq0HimRdXAmsNOS9790hoMqP4aQJJgXYmrbqpwG2WZ3bbAIrEIbogm9uWA0/utPWC42rKqvNsdLDhEZIKBXTNcrz/IXRDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717529315; c=relaxed/simple;
	bh=avfpCZJbhx1tkq0V6sA0j2XHhx520LSy4hRUC59uEz4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiAK8t8I/+q0gdMIek7IN9s6GfcLdHb/oq3KIykAlzShwzSDq5M5L9niN7ZEkvfbVFpN54VmVfs71Oy6/BtuT33KU9AVy/c/k/n/MDu51r4B3dNiRjRDm6a2lRzPUaDRNtPOhNQ563vXzlvy8ndpdnwC+ysBTKhk2dozXiLFggE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CP6jPIRZ; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CP6jPIRZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFmsX+iuQ9kNDbWX+VnyHeLY1ANVvUW+Do6dLlocMiMvnlsgVjEkiu8ynXvQQdmFO5fSTsqi6KKKHk4K/QQoPj4MhsY12kYIeAypH87GosF9fl3sy45RQ6TAZaNr+1MgLfHwJRP4MtGLJMlG9GIIcYOnIedmQEcb8gfVK4f1idtCG717qkLgwwgo/ykCFxK2BTNPEOR5zh15s4kmNGBkzKL3Jd88Ge2JFBHEQJCIvQTf4vMGSis04duFvHvoKOwh2pN5S2BHxaTdQHuhcAB8za6d96zx4VZaGHz0W54hH+25GVHOklq5W/n8+XImPiSzP5CpAhOjW54E058mq8JDLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9joHJZRe1EHrSykf6l+L3IW9VXAefYBhImHlpKTD9bY=;
 b=e2/qdX34Clcu2Om6goFZ+Ipuh5/6P461BN0TmSxJlxHqWs9iuC7SHa2zPIulXpz7G5+x2oVfan8CTwMNgGS7BoryAyyGtJ/0z/ZvRRFT3GoY9FKODHUPPXiL9YMC6frP37Z0+2u8Ru4waIycCcEOBlT+fnetIbeyMttJLG0LmLF1XuzkD8saKLC+xCxd3gOrhus6CeadvUfNMAH6JurqDdazZg+Zf38o1yLwxNAV3JZ2HjuCgwEFQmyes1J5nDtBodCfbdEAtuBozZMXhvDVWTOBfR5WtL7WHE1vi9vzrIJNscyNqT3+GW0Fzatj4e307lh+WrmOU+gAjIgfdXtrqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9joHJZRe1EHrSykf6l+L3IW9VXAefYBhImHlpKTD9bY=;
 b=CP6jPIRZ+QJMB3eVThPAjVJl531EAJHYMrNeVh6XqT7ohBH5h58oCRshEStH/3f4D0H5mywRTQWctW3EK9hPxplzQ+gs8FhX7EnwV9CYgwCXO2h/LZXmHxxAY7wYWdJg8+8kN4+xgozR9yKeLuGzY80ktcKNze29hwrFrAoLzYgkg/vE5YktYKHlJ2TH4/OkgJi86n1PaDZYMYHbVWNiDYTWUso9IuL7wcNHjEgfeFMvf7jquSgqtpdigYsn79JNJAEUi9WTDME02JnCn3B+paCB51bKe/xnLievhdJ8200jEXIAC7kjphAs9tf2PD6LDrYXreDzF+vf1XFvXoo84w==
Received: from SA9PR13CA0073.namprd13.prod.outlook.com (2603:10b6:806:23::18)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 19:28:30 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:23:cafe::ad) by SA9PR13CA0073.outlook.office365.com
 (2603:10b6:806:23::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.16 via Frontend
 Transport; Tue, 4 Jun 2024 19:28:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 19:28:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 12:28:14 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 12:28:14 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 4 Jun 2024 12:28:13 -0700
Date: Tue, 4 Jun 2024 12:28:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <Zl9qy9XA7Wivk3/J@Asurada-Nvidia>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl7RFCZhAbI/DzwC@Asurada-Nvidia>
 <20240604125955.GH19897@nvidia.com>
 <Zl9ctWSM6m3gkH5T@Asurada-Nvidia>
 <20240604190247.GP19897@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240604190247.GP19897@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: 9105699d-39cb-4733-84da-08dc84cc8451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ku/jUkurqfKu8PE7ddJRWvS2hWMcMiycFvvGDqHC6uVjxKEHXyUa9Yybuhtt?=
 =?us-ascii?Q?FEpDhV1lbh+/O6YCN6QNIOLyX11qtbZuKbTpZbRlGuKCllbo7GaUF28ivX4Y?=
 =?us-ascii?Q?6Z4FYXM/RbFNhfZF3//xo0aSceb65oReEBv/r8cuJfVUosgfmN5xAKs+XGRR?=
 =?us-ascii?Q?DHFCn+0rRILPHn5TaIL3R0/Fv+G8jTImYtaVJKNvEME1QJ+CkgKgnHpzsCby?=
 =?us-ascii?Q?/FN96TGjb0dazMvFOQBEiLzeuJMDsnqqWgief/wZWaT0/RDF7OpxIAMkOWnX?=
 =?us-ascii?Q?rF6Hvm45qF0ZSWUHjKyGyvPgM17xFAMjr63rKIv7YHG88etcR3hHUyrKfIq8?=
 =?us-ascii?Q?46wz0IhspUglv+svW9ILvEGHqdhMgD7CVMnDHMYyIw1LL8om/xlYk6WRMHCR?=
 =?us-ascii?Q?UYv8lRPNX/BM926SW58Z6DesrK95BL4xhldlJVTyktTS375UtOr1CwDJovou?=
 =?us-ascii?Q?s0taOR3fmhB0zpWVf2ZyPnmaj06jS7tugjA2h6b4TYiwcIob2eY9OK+s5+ZT?=
 =?us-ascii?Q?sAteEqW7mTycfykcaINFJE5qYDEa1PXtNzTz8MEOhEc5ae0mrjCOLH8XQZZD?=
 =?us-ascii?Q?IjugxZg3b8VqGQERmH1GXEi6PBdwTqeSsa9d4pxsqKy1AqR9bhctCRGX6/Nk?=
 =?us-ascii?Q?AQYz+5MTWDgWfV8zH0PVA6eaZnJUoKQ6t4ObbUVktYiHEDqGgriZ5CnD1GcB?=
 =?us-ascii?Q?f4kRQhD+B4+5GeFHNbjtnF7a3B2uWsVf6kOb8KFyin3k6JD+ItrkeVNT2QA/?=
 =?us-ascii?Q?nNMqQMxup3aPSu9UtP3tsxW77U4Pbsj4Z5eIa2lRJt0AhB9cyyJ4dWvwdUCL?=
 =?us-ascii?Q?IEIL5FUbhmcfpBpZGtloKu2+EM1YEx8vSRa08LD7DY12sfab1mhuqTedRF8X?=
 =?us-ascii?Q?JsJ3xkQD7sNonNlosdIa0miWaHjiCdmehDM6SEKC7zdFKiXLV45FcHuw43Hr?=
 =?us-ascii?Q?LBciOsbtrlpcKakizMyPaUNGjDd/Xzq0dE/g3DrAEbNKEOyby8ccfFaNv6/t?=
 =?us-ascii?Q?ZpSnfCeomA6FqH2UJafUoeGSfSPQqPtw3rbCca/q5qaevoxH8suaHtZB3aIv?=
 =?us-ascii?Q?BJr8pTiB7UxOLp32xd8rWwkr/Lr/cR3ndEJvDQu7nIrCkesqvwZkUiF6u2uT?=
 =?us-ascii?Q?fGoY8Jgbp01Z5dBMv66MHfXGoAi3EUOb29Ztg4MBUTzsUognnRB3oO+Gmrkn?=
 =?us-ascii?Q?L5G+F8yfR8EBnUUSizSWHb8qiBMgMW/GXelUblZ4vtg80DBKOihOjiLhhBu1?=
 =?us-ascii?Q?CPGa7Fyp8GRwkYuAzRCiaYeagagAIO2PCmcVduQ+NIi3Sm8UMvg2Sdq/Ql9N?=
 =?us-ascii?Q?1MQXWoX75GDTSuaytBsnvSGgN5uqCJi0P6XKXEhJHpVGJYtBve8Ea+4tfLiU?=
 =?us-ascii?Q?V0D0JXM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 19:28:30.6178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9105699d-39cb-4733-84da-08dc84cc8451
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802

On Tue, Jun 04, 2024 at 04:02:47PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 04, 2024 at 11:28:05AM -0700, Nicolin Chen wrote:
> > On Tue, Jun 04, 2024 at 09:59:55AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jun 04, 2024 at 01:32:20AM -0700, Nicolin Chen wrote:
> > > > On Mon, Jun 03, 2024 at 07:31:27PM -0300, Jason Gunthorpe wrote:
> > > > The "struct arm_smmu_strtab_l1_desc" seems to be only used at one
> > > > place in arm_smmu_init_l2_strtab(). So, how about:
> > > 
> > > I didn't do it but, it would make some of the maths more obvious 
> > > if we encoded the table structure in the types:
> > > 
> > > struct arm_smmu_strtab_l2_stes {
> > > 	struct arm_smmu_ste l2[256];
> > > };
> > 
> > I personally prefer this one, though why 256?
> 
> #define STRTAB_SPLIT			8

Oh right! And similarly, "struct arm_smmu_cd l2[1024]".

> > struct arm_smmu_strtab_linear {
> > 	struct arm_smmu_ste *ste;
> > 	dma_addr_t ste_dma;
> > };

> > struct arm_smmu_strtab_l1 {
> > 	struct arm_smmu_strtab_l1_desc *l1;
> 
> num_l1_ents too

Yea, missed that.

> > struct arm_smmu_device {
> > 	...
> > 	union {
> > 		struct arm_smmu_strtab_linear linear;
> > 		struct arm_smmu_strtab_l1 l1;
> > 	} strtab;
> > 	...
> > };
> 
> Yes! That is quite readable and understandable! I was relucant to do
> much more than just the small change Will asked about, and even that
> expanded.. Let me see if I can reasonably squeeze that into a small
> number of patches.

Yea, I hesitated too at the beginning, until I saw Mostafa suggest
something further.

> > Only arm_smmu_device_reset() really needs strtab_base/_cfg values
> > that we could compute them over there, given that there are quite
> > amount of smmu->features checking already?
> 
> Certainly could do, but that seems to have less advantage..

Well, either way sounds good to me. I was just considering that we
already did something similar with s1/s2/cd cfg values. Yet, not a
problem to continue storing these two.

Thanks
Nicolin
