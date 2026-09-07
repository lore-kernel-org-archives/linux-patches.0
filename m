Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DF4A3410;
	Mon,  7 Sep 2026 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794324; cv=fail; b=BfSJ4Tv4eJLcWbrqxRxY/leZf154Eo7jfeA21lx4g66LSYzKOGcnCBPTOVWRuxye+0wO9dGaOqMeidQza9DXJMZwOE/iwdI7pf3GFwFaue9kqPePBC+m4tIlsH7iaVt6Wrcv5q48xVdkFsn2NL8n8APg+tFz4vQ5PXctoG5M5ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794324; c=relaxed/simple;
	bh=OigKm4UM6URz8evs/VGapuuZNSstW1VeMrO1JNIj5xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cZvRaYzrhpGUC7o/DHd0LYl6D2xyoPovYPqYuWT0mH551B8g7JqyD+/QC2vzdQuMJ6U+5QF3TkgdeO28RmTeFjkC9YdzQ6t72TNDE0EFoUkh+xF6df1sqMt4c88XYPXIItbiQjVGbu/88eadXZqdGl6UI8Dv0mZFHH7d6g0vniI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F+Wc2yTa; arc=fail smtp.client-ip=40.107.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F+Wc2yTa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFIuptBxGKbdTlwTm38PnPbo1CPFBKlEAquoiKCek/zvr+SdHEKuK+/dk9ZI3Iu9oNr83zb5jJYxRTZnIo54sDckSmD90gy/lNXXh6jrnw4h8gChp7QZjyySwcKGj65RMoqxRczHm3BUCp8UG+gBY8jfdYiXVpNdOM/DdUiXe4M/bA86YPD5fyVRqWBj5Vk8I3E4Vfmbf2mlfKqnHQkvYsUpCFXXPKTqQgV/e5NVjgciB58cmCAJUQLF+NfiMPo6D7PFs7mUTn7cfvnW0bA6qAwCHvuSRP8qaJP3f3nMA8HTa22HZ9v2FXMIiqRwBDh/cPSyxd65nE9zK8Q3lHs6kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dm99nNTp+VexkWDcGqgrzlGLvkSXgG5RFVuZ2Vpo2b0=;
 b=NuzqwqL4MBFlrKl0Zzw1aZTYG+aDrJHKoWoRk8EXp0Q/b2FpJnkpmXAdRYP1Ko0cbMKPMKS3dfYg1EcS4i+4EC25KsbzVdD8/GzkLjd3jIuSpIhMijxDLActMxAuxlgdJDcpNIGF7Kl3M2SbS25wxdYq2dAH4Rbv6la+m8EDxeBSXTK0Gq7vKCt/Nj2CvCmtHfbBt+Vk/8ezSFNnDM/w13w/bf8OatQGtIcx+35RpfQt/dTsM+NFGV09Rgp8d8xg5iN9BanJaCjqtvpx9JCuiPxYbTRss2zQ1du405JAAGsvXA4Rl0rWcDBgX+eOOYKeVKLeF8WpH7xZ+0CxbIjYXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dm99nNTp+VexkWDcGqgrzlGLvkSXgG5RFVuZ2Vpo2b0=;
 b=F+Wc2yTashmdSRZtoMSCcX3eKAxGdKWF4wFxlqDUmGZy8YzjhR+Yx8xJRGEznkmmgj0NpBDq7yxjWGhZZV5hzDwK8oWt3SE5vJPTAL1oQXsF4rF0jS+jrwjhmP+7JZj3YWLbLA63qgvZiWfbc3PnvU8FRJaqyFDE3Ls/hoHGgy5FW1PNGRtoGjXB1Vc0spZdDsMGmbyRbFSgRu0xjJukIqsf29CBmlHCk2J9x5nbtdGdCJ277JvNmK+gB/G7XJP/NNJQdKE2OHYOmeQz49J63OeitU3631YSQAcpK34wxMSwlAC5WEuOa7wa1W+j7pAc/gtSpisXgLTxSHi8h7pCRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:18:36 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:18:36 +0000
Date: Mon, 7 Sep 2026 12:18:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <20260907151835.GA2610069@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <1-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7IeAfVPZL3Hqt_@google.com>
 <20260907151145.GY4157646@nvidia.com>
 <ap7VcBXG0NyX6acW@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7VcBXG0NyX6acW@google.com>
X-ClientProxiedBy: YT3PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: 01727385-47f7-49ba-d8bb-08df0cf34993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GvvMeGQu5A6PcDjTg7q3cBfyvGe7sbXNWdBcxeH5ATu0JVt5ai3X+lOY+9eYaYaFU3TDpvsWEb7bRjVs+uP7z58WUaBTGCscLhd+XEwXF2mN/QHa/CTNC2y4NC/GC2IsGAq5h6yUU/+JLc/9VjFKevcx3ahKoaBX2JmgR3krW2k9r9EonkbxeANQ5dTtGWNkYTVPPkOAcLMn/ZLWAqGUzenGf9A3T1hqP51bd94yjWDGWm+5QQnmedO1mQLiZX1Lk9ZbA5buJzJIj737LnAQ+sQziZZMlmX4OfFYV5U3zVtdWWklpi+O7wz62nWZm9XDAc0rvowJljorBgHxP0XJ9OIsh1Bm6z7VU1GAIWCshLcM7bAXnvQm3weoeXuySR5IBjAb0fbnJpNMdq0Gzfjx4wmVp90aE1CIVgbXVZetbrYhSE/33nsSNoyaak/AAIHL8eOhGKnr3NrlREA0Bi8vO9dPE5HMyEKSnVC94LaQWWxVjGBOqLZzS9wXSehOYjDcm6WUQ8hgybx0EjqiwOL73jZ4p14jDrhFh35P8FvPPRCapjcuf4VPsGZK4abRrS1YwWQQwnPYkC+ivNNYVoa+RwPrXCSHx6v6HL0KnvYxjinc39018f8g5sX8s2JJLE6EZhibpXrrEyJWyIo8i9mkTAvrlF3Jfev16cFSTChsbcE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jGWlr3Dx5GR4yJoZtcxkSZeBlWvMeLNsVelGyIwg9mmlwAKBoZZ0QrCBeQEg?=
 =?us-ascii?Q?oiEzGYWffyUqiHNipKt9YYZG3Kny8hPlsNR/FwyiyRfGGIYZb8GLMzjWZc6K?=
 =?us-ascii?Q?uM2Hola837nv63mzz+UYfdagcLzK7XhLPx8H78XJy3jrfCf0v/mfcvJ/sHfr?=
 =?us-ascii?Q?vULwK1au/0xUT2Zr0JW8wNuS4tX2XaUTSHDai8uCCSyknHjLiDOxN07gfIK3?=
 =?us-ascii?Q?DV1J8KunaFmssS+6flDsnmkdFH68ChcKhAtQXUZgxv+te0H7XjJOfB9oUTuo?=
 =?us-ascii?Q?/rvqFkaNvRZ844NjyZrOQ/mTc/N0G46CJYD+AOH88XnJRgYs0+ELMcO9sOEq?=
 =?us-ascii?Q?V/a5wEBQKcvYJEPDsMdbAbEz2H4l3c9w0ms2NiegiBaEktZ1d8BJXFVEl6+w?=
 =?us-ascii?Q?Bs3Bzv+R1XociftaNpL4MA0+WlBhSWhf+Ws2Yjbwh8ciGPjIQ1iZgLCTxw7a?=
 =?us-ascii?Q?+b0a5NUM8MXxiPm2rINNZOPNo7xyERxCItEbkK8Wbj5iB/uTGOGQKiXuWdy4?=
 =?us-ascii?Q?Em1fLegqHhg+Kpd9mCVPJfEjmMXorp4ixcvAziK/D9nYLeQy8JD+NYSGE2h0?=
 =?us-ascii?Q?BoHvpgrh+p12R0MMakmRIMI2/kbR8JCJWz385kKWqcbFnyEhIzF6m3RryfEd?=
 =?us-ascii?Q?GSXfhX8vKRNZJwQyvRo8QhkJH6RGdc9aDG26kLmE1gvPSPgcbG7cj3HIQPb7?=
 =?us-ascii?Q?+3cnQn1L72TbPctyAt/EwhXPdAPrAByZVZ5CXgeaXYfKbViPMpNwk3qDVSZL?=
 =?us-ascii?Q?ecxjI3p8vzcEeYXjvkqpHA6MzVpDaB/MMjwsDjIDGTeA69MmTirVufmjv39P?=
 =?us-ascii?Q?vmz5vXJJCNoiKG0PDyVs9uzK/wyGtnIGH4epMCWSl7uqCLtheVVJoTUzo4d9?=
 =?us-ascii?Q?O/tJmf0TQCLKv90FgBCvEdQ8ZDrv9wzJe4bPueSmHbeob24hTuCODc+bJH2P?=
 =?us-ascii?Q?2qkV/+FDqIDSB968e9to0ca5OVd0aTuHTFvCA4qZVcIquAnGmghG+HOUM0rF?=
 =?us-ascii?Q?3OA50wjQfczgb61ORfAlfC6Tn4+4L8yfS4kF8ttyot9TjFe/GtaX3QKKtpN+?=
 =?us-ascii?Q?qXoQOsQTEjDoOev1CW4Yv3RwUX85CTk+Yb8iOzXa3C6OLW4BFGrijdze8lqc?=
 =?us-ascii?Q?9RFZgT1SURXc7AYTW9yY93joaMvXMTaC/E4AQq6DUE4pdyAR6dvR8t+YiJQF?=
 =?us-ascii?Q?LtyIOa0aoiyiB2M0LyMywcRVG4shBoamkIBsVCodcFl+WFbxjwnpBi2eFYo0?=
 =?us-ascii?Q?1SYyJJEi8RVjG+sBuDRU+LDToOl87JGNXyqzt6IyX4D6zNe2vKF+JmtaSAGN?=
 =?us-ascii?Q?Yg03Wt5HK6NSa5roDoc85FJTlsQGaQ+TOkedKp47dmC+G7NVt8xGuQ/J1jUh?=
 =?us-ascii?Q?KeNib9N4Az50hCbOldPYO2jNNpDtFzzoX6e9PZEY30oAqBKAXMcKEPed5FBK?=
 =?us-ascii?Q?o4966RPowvM2nsM9glNCE6HTWx28YQ9jGzedSeVN8jWeNbtpgf0REX+xMAG8?=
 =?us-ascii?Q?VrTrClhZfrcRCJIRIiOmXMWtTm29txJJQHtsncjlSb6TsqD0VDtcka5wnOtw?=
 =?us-ascii?Q?7zNVQkAkgeYr98opM3PpSDewjXVLDDV2xip2EBSxnbIxNDKZnPP6XPgDDBDZ?=
 =?us-ascii?Q?yWqt3QCXyrvKKXTxTqZPL0kmnZBDDvxVvLMvm+FwiqCpgWtLIzR3O3KF86J9?=
 =?us-ascii?Q?OAz6ind3UV3tLAOok7qzr5NWkvjSQj7bkkyt/imbEx645Amf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01727385-47f7-49ba-d8bb-08df0cf34993
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:18:36.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUs6R5uZsdN6xHJ/UJb8Y1JWV16Q6caycyXEXHJe2CWkAX8BejH+kCq+ND7yD2Xx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8660

On Mon, Sep 07, 2026 at 03:17:04PM +0000, Mostafa Saleh wrote:
> On Mon, Sep 07, 2026 at 12:11:45PM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 07, 2026 at 02:21:44PM +0000, Mostafa Saleh wrote:
> > > > +static bool arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
> > > > +					struct arm_smmu_cmdq_batch *cmds,
> > > > +					struct arm_smmu_cmd *cmd,
> > > > +					unsigned long iova, size_t size,
> > > > +					u8 tgsz_lg2)
> > > > +{
> > > > +	u64 cur_tg = iova >> tgsz_lg2;
> > > 
> > > Nit: tg suffix is a bit confusing, I guess pfn is more accurate, but
> > > no strong opinion.
> > 
> > I don't want to use pfn in any of this code because convention has PFN
> > as PAGE_SIZE, while this is a "translation granule", ie the base
> > granule size of the iommu domain. Which are not always the same thing..
> 
> But this is an address not a granule size, not sure what that could
> be called then :)

It is the iova in granule sized units. PFN is a mm sort of thing that
refers to PAGE_SIZE units.

Jison
