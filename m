Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F4A5F840;
	Tue, 13 Feb 2024 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707840971; cv=fail; b=nP+0FxIN0ryzu5wHDpccBNyO7SiihyDSFg0wRg0qwmhFESHM/rIOcDyNlf81mARc4x9JTmL51YJDHCUSuUjMqSXgDlxtd4SxLzfCm8VeY2mmQQJ2y7k2wz1kf8AM/8HRqU2GUnabgMi8qDKZGdr2X5ApJ6dek6JWsSnaJilmsfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707840971; c=relaxed/simple;
	bh=j4ce6/tAhWycTUiguiTiNUIsWYxfFrTi8QvcE1p/8Js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BZEu9AdunMc+sm1Ayh5rHicMAfSXLhAWjwElfdfVxQlYWypfJTR/px+T4dbxpeV7ILOpXMx1/iQD4k9nLmKgy4Q/5tSpiW3D276OdzhmeJKGdAfND8VazaO7SVhRQUR67msXBMZ1rdvEtTjBKSWLBlXG25EkpM1vJjasR3wsfvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TfuoGHXV; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TfuoGHXV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdvDVWU3nmOaa79hbGrpIrL+y2LpayLEnKIJoqe5HdGbASxVkAtcDR0QSjWfPLV1RMaDx2dgEBRzXQqyknacY7gt2Sk4WMAlof/YVQDdkQFiDhtKR/QxJUJ7r/vCCODW/VrVcd0goZQvnVDWdSA25ueLVvkBnI/KNg9Zm1Zqc01qbU8GLZFfIabNMm1rmdGNF+5I4PTYSxaWa7ysBwXliISUkJgiNk7Ga14j/YSWkKkDTjAP5snSOxi5ySeaqKwKkUxmrn35NpSdFii2Wl3QbfCK1zyrMEsnznBH0b7uL6svbYDK/K9DkPlKohyr6kqaodD+Fbdd7rW40nbgo/gTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsVhwbqgfj8cyLYQ9SH6Coi7Q5UkAQDoYrP8VwWbjLM=;
 b=GLMq5OCDVbSr3zYnbkpsiW0SEWZUKpVuKHH5TCpcDyRItPG6ovu7W9+t+wdiiPs+5078AITKmXIdn4R2ZfiG9MQk/kd2Tp0d74xU3EeDtUe7A7UzkuwZ8HHBSa1YBX9Og+ZjFPC6LOQMq00L/PrPAYxz+LO8/uw3erhQjESYCGxzlbGTSJyUZQMmWI64FRZsVnO7uts6iCPaB1pTz/pLfpWFwEMIiJFXcNSyZVA4X3EP73NkFe1AXWdZBhzhGvycfExUkO+zfTo5fnD2JlsMiam5KaD9lIJf9tPZd5r5IkX68B8Js2PXGPcF7lNkqh9KJBdHzDwZrL6WoYCfK0t+jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsVhwbqgfj8cyLYQ9SH6Coi7Q5UkAQDoYrP8VwWbjLM=;
 b=TfuoGHXVvyyqO9arQcg7tqZQzj4mi7KqkOj+xAQSJft1gAdMkTOcjs2ks4wBmfNWtXGiKQArSCtsTVv1F8mTDUKcjxlVDv/zYRUMqRnqf7iWiq7PyUZcr+0FyaTWbZM/4nMejyL2sS79/ihOGKFACsdrDjCd09wJ0JKWtQFtgSSklSQJUEMJFQf7Re2oq1WssmyGfSpkoq3uIeI03VgH1ggk/oJxLxAO3LfI64BopyezB3Kmys5R1vRKbjFHG37z/iJ1DNe/latBv/jx9FdKlfQxM7sGGlfgt+lEJ9yzShE5GZHi4DXhtILU21DoQR+s7LCerNtQFMWSkiMzfOhNPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4298.namprd12.prod.outlook.com (2603:10b6:5:21e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 13 Feb
 2024 16:16:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 16:16:02 +0000
Date: Tue, 13 Feb 2024 12:16:01 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 03/17] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Message-ID: <20240213161601.GB1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuMx0w6MDWpkLne@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcuMx0w6MDWpkLne@google.com>
X-ClientProxiedBy: MN2PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:208:fc::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4298:EE_
X-MS-Office365-Filtering-Correlation-Id: b7267d75-5004-4dbc-6ead-08dc2caf129b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OQx41qccx04eKpSKHK5NRt1SQU6fFDanp2Hs/G9vBC5jDzXX5vHSxP3N0vvkCP4hG6u2YM+n8+tlqcbNgIdc7r85pYHIe1ExOAlsrQzAloTvAj9xtTJ1FMG3o178Bk1QnExUNblZLmMQJhB9Ss9JhO1xadOHV9EAdXdRzb7Bc+bJZNLOBQkb/97Wt85eR1/zsJkG2MpivCPnoW5ARJff4t7lCPqw2Cd0F7hjqfWmD8gplmSfuosAXx+sOurZuuI6MEAjYFc6zhg+oHrLCy9K3ajwl8cWpnC/3fgPYdKxmC5NSfGJstURkPti1ShYEsiYbLb21r427njldA9Gvxsp8IWs5gsL8+VRXx76vYir0KNpQNVsRPmYkJTMp2HdvBAiQj8a7RnnXaansUkjxelN0Mw3dX6OjtVYCfv3FLDa0knw/MP8ly0kF7djPz3jXx+VxEVpYzUUBboIsV2Upf1owwhpnJelsQ4NBmW27tbduudfXqhCAbH46/B/J/qNHk/kUqvO2MrIMqlDgyl9nPiICwseExVm5SYwdKH+JVYzQ9IIOGRxGu3+jrCwKYGmLWnLiSqtz29jPNhZqxQunNM6lWL7rF24xnlqmA8+47WdH48=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(136003)(346002)(396003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(2906002)(66476007)(66556008)(5660300002)(66946007)(7416002)(6916009)(8936002)(8676002)(4326008)(86362001)(41300700001)(1076003)(26005)(2616005)(316002)(36756003)(83380400001)(54906003)(33656002)(6506007)(6486002)(478600001)(966005)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ax+TyLf9kJ0baYyxXRZ/Tdh91Lnq5zX4P8CZ0OHHzzVRpIVwDtaNGdt5yctl?=
 =?us-ascii?Q?tnfBtC8mtVOK8s5s/LcD4owYazOnvQXOjOn6S2Cy4FEfZtEslYzVaOiL73w+?=
 =?us-ascii?Q?Vibn36uqHWvHkg6ZiKzoFNnoMq25oNE78Lhd2Zm1lbzhiYKTIUmAQC0GuxiE?=
 =?us-ascii?Q?yaTunHehxvk1Sqd5+KjxEuXxKV3awmetGMmjdDwifLun9AfDxoDyRotYBYCB?=
 =?us-ascii?Q?t8lAIMijtVNiycBF4LSgNRhrC9VrNDf7VupmlE9Jc10xAlyVTJB+zHTqotWL?=
 =?us-ascii?Q?/I1pMWeq5Y+gvctMVFZRUbCcZfYLTdPKF4mUhrB9uGAXRTwmJbFY/9C7c3x8?=
 =?us-ascii?Q?n6pUFKiEqFs/CblxgjAaYz7WecV4LKkC+BQe+WmoIeHJjXr+EKkJlp4z5ps1?=
 =?us-ascii?Q?LlgqlPP1RniO/9GMfNHJvjHAOzWPq0ObLDbWdQ9AigLH82L4FoFheXL7K3Et?=
 =?us-ascii?Q?zCn7X58A02KQX1KZ8KKXK6po9at/VRqu8hJmEs+RPWHL2yI/CXAsR5WHuG5/?=
 =?us-ascii?Q?Pp+9eDClsUMPqC0RgETfWX/vNK1G0SkOauKSkuchAU0yjMrSb5OC1hyjEjW7?=
 =?us-ascii?Q?4Sv1vViyNRciIC90lDQOpE2cMB+5fKVK5d5NC0cbNPw6vnRrGgcERp7PfKK0?=
 =?us-ascii?Q?Z5mGNVnJ5mRuZiMc28N8jAudmoXx6wyPuzCH3ov7oayfkDHuOVThbwDrBfr2?=
 =?us-ascii?Q?66UZtAKhlIVnDui7kBRDT6AFxJSYSWcs8aTmuxjK5FAgbdQU5x93bXvndmdZ?=
 =?us-ascii?Q?RUKT13ZHtzKhMr2WJE8kimadBfp0ktgEZjacPGCCmiFJjxdkaTbuunjZVLko?=
 =?us-ascii?Q?GmRTctbj9MTfnBMuK7Q/RTksf1Xtp2BpJLxNGjzLDQ7yalzYFkmqwCS+d2vN?=
 =?us-ascii?Q?NUcqAhdJHmWYSGWdpgGDhE/R7pl96zjlfHyzxDPpEn0qvFJbpZcOTh/nOhnz?=
 =?us-ascii?Q?NH4VFX+l+f3AEs7vDfUtTA6ZqgdW5UhC/tQlDQYxM/le/bQEIQuEjorvTkHl?=
 =?us-ascii?Q?4eE7n56dvl2+BLvsmEtWNyFsrrLn3T1XTm/12h/Wmcful2FVvRLf+3Px+/SH?=
 =?us-ascii?Q?w/vwUA3aAA9wYdjOI4dbxYzBA6H/oFihwrPwhMpLh55Dsai7l9S+8IgCVl1A?=
 =?us-ascii?Q?KBKn1VbfGGgcF1zNS4aJHoeo0bZfgNw7fehvs+JSrco/0RrXie3xcpFQQlpt?=
 =?us-ascii?Q?55kSqD7NlkZmQxLR6QP6FM1S0yV+BRuE7FxXYILYJG7S6thYUSvMfXfpnlyh?=
 =?us-ascii?Q?EaXiR/pvaX9ALIzSa/q/rjbB1HBWLyJQTLCpXhxH+2w417Se6HxlRlBIFU/T?=
 =?us-ascii?Q?LoQCZlXDR+HhnkypiweFeJKG+zU4QbeeaqXIXnPuquE2HUBKeDYrkeL+LL+9?=
 =?us-ascii?Q?dgx1tXN5zBtrHTDNHuMinjcAmKc2At93MAAe+sVGJ89bcFOheE/9OqPxscxV?=
 =?us-ascii?Q?mBir6mg0YfziswPp7QwurihqqYZxbnuZPWQSGLs67pDG+Yb7kZt0yvfnnddq?=
 =?us-ascii?Q?O4lNG7YDdhV+HfN/aCWhrfpJeF5FtcAHh4QjDZcVaHVWpHLcNXMFIkLIeax9?=
 =?us-ascii?Q?11gWwHH32bM4MqDLJ0W0YfXYxiVmLyLKLRzWizr2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7267d75-5004-4dbc-6ead-08dc2caf129b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 16:16:02.4254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CizqCoMAZKEiqCxxS9tBwmquA2565xWFUJOIK/gYv5oG3VnOxHrdQ13TDAVK42I2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4298

On Tue, Feb 13, 2024 at 03:37:43PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Feb 06, 2024 at 11:12:40AM -0400, Jason Gunthorpe wrote:
> > Logically arm_smmu_init_strtab() is the function that allocates and
> > populates the stream table with the initial value of the STEs. After this
> > function returns the stream table should be fully ready.
> > 
> > arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
> > any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
> > ensures there is no disruption to the identity mapping during boot.
> > 
> > Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab(), it
> > already executes immediately after arm_smmu_init_strtab().
> > 
> > No functional change intended.
> 
> I think arm_smmu_init_strtab is quite low level to abstract FW configuration in it.
> For example in KVM[1] we'd re-use a big part of this driver and rely on similar
> low-level functions. But no strong opinion.

I'm happy to drop this patch, if no strong opinion I will leave it

> [1] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linaro.org/

I saw this but I didn't try to figure out too much what it is
doing.. It looks like a new iommu driver that re-uses alot of the
datastructures of SMMU but has a different HW facing API based on
hypercalls?

It seems interesting, but my knee jerk reaction would be that a new
iommu driver proposal needs to implement the new iommu core APIs, not
the old stuff. IMHO, when this progresses past a RFC it needs to come
as a proper submission of just the iommu driver, in the normal way.

I also wonder about the wisdom of sharing so much code. Code sharing
is not unconditionally good if it doesn't have a robust abstraction..

Jason
