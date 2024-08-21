Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6D1B3B09;
	Wed, 21 Aug 2024 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261858; cv=fail; b=ICoKMqBvKms+s9+ofMShvjDwj6aYCg9y1KiTGRt6IJ+8bWa1adab47iuOJRJFzKq+bsyqTKbD9e4DXOTndBZfgIgZwW9MnRLzBeNum3EmHzlpvcArm0BPWK8rGEJEZVahrNGRh2u6Xv8et/gxvd/VBoglmEXbtOzTo5Lqxe2U3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261858; c=relaxed/simple;
	bh=VvTMwty7xJ78lziBxQX/MRL9njebw+wXqasNMGx5woE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IzOqXnOac147W4reRmp+zoxoL+0VE8qqxsGIikgTtED/A9kBvpL3KwKKBbIc+nnpM7DSgt61lPwtxti4QTtIIik6uxNvpEWop3+IG7gZAa7d10GRLBhMpERgDT39WVdgNgSKs5t/+/hTc0vSGvafE3SgtizzHyaVklRnrUq7O2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hUO/yjrH; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hUO/yjrH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gwv3EpUg8yEsAq8rK9OaWXEyqmzDNjBZbLLWx4wc5c5xoY0v6w3EUbGHWhlSeTwwx9d4Aww1xmrj4eAA3wqvMUPq2HUwXi1RS3cGgUBxJPNEz1yZLm5rv/MTcmUaoPDXdUp3A2TVqjyFpcAo/MkYLQQYRDfkd8RYfoUuEtUwvlI7ylnpDzSbO8quW/cHrqu5DQWGxGpALHRxUtSta2/8s2mxMqrb8UCM6oM3R8KncVkM3DYUTfRbOHLpCU99tR5oAJ2CchbWsM6qm6VcLxlvylMpZcyYqW1zdkwLCEfLtsFxxLjIyblPmt2TR/HSJB1UfWl92QxKEgXfVYomGh9X/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YdF40MlrRNB/YqC54V7GTr4JSieW2CdNuwjXBjbcVQ=;
 b=d09mhVCIs1B3lYfMqnTnf0pHAIoqOJp/mwZlOYc36ZsHrsa7NTV1A7Cr/5W0e7Sr/E9fb7AUBRx5RnCK0xVhHm01rtPMvlaExjD9mWS1UTBL0jGZQK5eKRsJxFbAmUj4TQOkgreQQi62thlfaruJSyI7N/hl5WdxmKQXEQDvlOZW4vcLAMRGzXZrhaSFYC6q0GbF/C/7izb5DtR2s4u0q7Iv1S3VJ5gMGmGOvmK/46thgwgDFTnkD1/SRR4YTm/8jjj8K/nxPyvvbuISvIe2Y3uTGTpViKK4KGtyfYZ3zarX9OMkHKenf+0Y46AzyD8xJ9ov8+1kTQTvvbqYshX79g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YdF40MlrRNB/YqC54V7GTr4JSieW2CdNuwjXBjbcVQ=;
 b=hUO/yjrHEvUCQzQPNklG4IPBj8Hn+vSplHfgUf1mJGgs2DM2dr8MquBvKRvLlf8GBw06Xg/wgVRbFmL+/gRlxGCXvgacOmoDrhgKqmqxrvbJXXvODKQNecrigtZwmRuWR5w1WvkDhfcBUaqUVl2/irUMeMObbVcQ+xmGaFqlTS0DlE+fxVAqaByppyYH8iEhfHO+L236voMmtvQX3CtB9zeDVxKakBkB2xGFQpxLNxgLuu60kWI6F6IZET/uXljK2hxF6JntTRgdXtGvRB40JkuzFndNpqHX0+GyBbDiLP5JeRtOZSDzxyT7zmoMAxKB73gGZYZ602r+eq2r115W+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:23 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 00/14] Minor fixups and refactorings for AMD's io-pgtable code
Date: Wed, 21 Aug 2024 14:37:06 -0300
Message-ID: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:36e::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d5a7dc-7fb0-4508-2645-08dcc207e997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SIb+vBlwUgDtrQzLU6UoEfee+zPWCoSvkaLvJ65+PxB/lrOPFe0ef4q49jFw?=
 =?us-ascii?Q?EuPhKf/EcUMr6Fag3J1R3Jt3gNlQDDdvaR+O6oCS1NqtNeJN4EfWnPrUE9k3?=
 =?us-ascii?Q?rXauWbmXy5AB+i84FdXRVKdRrK5hl4MMEcTEeeGvj7Jvr5+zU4HHriM7EYwo?=
 =?us-ascii?Q?KwlAVsdMssc8KsDtoZ63/tDzn54LBm9U/oybAiAJW9gaNFsVgtDZ9VZakLtq?=
 =?us-ascii?Q?6BwQ1wcE7e+RA5zdABxmPDpM5jah9UXic1Sj+FkAtjq7uIi2jMf+ThufkqWY?=
 =?us-ascii?Q?GaYLaP4CHio+NQuXtB1Ag1s8fRnxuYLsuNxU8y9NamaX8nqX3kFMa2PRB9mZ?=
 =?us-ascii?Q?qekp7rtYxukA5hcyq6S8EuwYK8b4VPNQNKAUoeh2RRzzDvrmx2by8yYDP6MW?=
 =?us-ascii?Q?IKg/x6hBXODL9U7Pn6Be3MXbon2ngOnBT48ilrKc8JDUw5Ougre9Tb57AJue?=
 =?us-ascii?Q?sjhiyaOs5BhWwEr2j0ICcUow/hnRmOo5DtU9Qv3oQe7q1UANs5cG8BZXmLYb?=
 =?us-ascii?Q?c7iS7OUmBltpy56mdBxhKGyiksKZCdpaau3tiQ5jSrt9wxgVc4IlKtZbMHWr?=
 =?us-ascii?Q?OZnqQWdRQHhoXpSsql/zvy1ASwuDNspbkxVmyK8RdbnbdSMK1PmFl2Vk4vGj?=
 =?us-ascii?Q?B7m03Nq19XVdI7MlzOFEbzmBLEn7FadkTH59DkhwYRw2ZZRx5Zw3dvr9gEQc?=
 =?us-ascii?Q?oLyD54T/FF8GTAIBqCLchNsXnIQSWKnZCrHNgR8wJm+s3MfhbhehDeAqPaJd?=
 =?us-ascii?Q?3eshFEbwcPNX/rdVu7V6kG/LrvtpQ5OT3Uac9fbmwvGKwtswy2tgus2K8W44?=
 =?us-ascii?Q?2vfbC2NkQLf7KCjrWzvB6ITFPoSemYnCLxY2IdTlTF4Yw4WV5bzgT9z23sEr?=
 =?us-ascii?Q?WYLQ61wj0LoEN1u12OMhc1bOuZmfuPxNV4GVf6WVmqqXICr/10EQN0YHV5BN?=
 =?us-ascii?Q?Mr+C9asWgKAzVQALQOUW6DEqrdFr6N8WCRke9qnBpTp13CdGkJfXGD4/Muzc?=
 =?us-ascii?Q?8mFHA6p2kLL9Cvp5lBF/GbtnBw23IdqZE7RiyCxFoRq2ZOdYRc9ZsOTyXx2h?=
 =?us-ascii?Q?lKEsHhk11jhofDQXMXuZHnPqqxMrEJyo9WbvAK0UtHSoCGNDfzydprGYL1vF?=
 =?us-ascii?Q?ZJNH5PfpF/loF8OWTu3FmJiLlUr+HKsIFt274iN/Sy91x1E3BtaSKxvvC6lj?=
 =?us-ascii?Q?U7j8GwEbN/bsZ1kXEsK7WpHutGCtUwWKnEgbJHH7b5Y2zaFhulyQckz2N4Jv?=
 =?us-ascii?Q?UfSynE5+TJXBkXlfl43w75yPp8EteTFRKQGu0KRIKsWJ0TEZwh385KIFKxqo?=
 =?us-ascii?Q?6MA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TU+dLRILB7omYNhvpcryEug5ke8mU+Tl785NKH8hMUk8FrTra3p175xrHl9R?=
 =?us-ascii?Q?HiokayyRnX2hOAFFUmChsL/nxZL2qVyCpZ8s47vYA74g6Z+B/5HqLe1MH1Dt?=
 =?us-ascii?Q?VR5yzBzj1RuUyut5sC3DmRRHlCusNtFEJ/wvUmV4/+sc3sK221YAgBnkWGC0?=
 =?us-ascii?Q?6pjrOkDrxlBkIOB7MoZFA7dTSM398yilmEe9tUMwKyqhWp46Wsy/2FGKptYe?=
 =?us-ascii?Q?sVCqwEeKuNhtWn1uyP+zWJ+in6yBXi6GcfXmcj+XkgW3JzsXpweSBb1MvHHu?=
 =?us-ascii?Q?Biiqa5i+3RnSMtqjns2vLFdOTGDS7yAUsB3kC+mrSrSA0rAuCzUwNEKJdeY/?=
 =?us-ascii?Q?14X4nsY3VcbiojMSTDr4Koo/IP0JX68K7w23wvn0nL43J9Hte/JlfQzoGd4O?=
 =?us-ascii?Q?pfIjRaIlgcRDk/rQ8wx6WOC1sGaNeegZWrm3l4dqHpJ6+0MWuInMF2Ek63YP?=
 =?us-ascii?Q?ZzDiwJQzWPWMLZV19uoc6++Hu8dH9WghjdqmbqXeM5thj0PQ7yOyst1plUI0?=
 =?us-ascii?Q?WGInqwLu69MpDvfDpQL7i1/xv9/Esf7xXalfTx7bmYF8vOjeM9LypR/7CqD9?=
 =?us-ascii?Q?bk/j/CHTt5Huvn7fGMFH9GuiB6apGBoFPnfnoQ9XADTP8qBk9A81+D3wfRbv?=
 =?us-ascii?Q?jv/f08gIDuv0MUNwzWvcLvJyhIyTlY0j8rzggFe2J/tYd1b2G4PtU2vPr/1e?=
 =?us-ascii?Q?twRVskO1yOZUqLB07/EXtfWEFxB3VFBtNHAAp7SSZ2asWiZ1d926dIuxUOAH?=
 =?us-ascii?Q?IfjdeudeQtzf/TqidRDEsuKSysTaSbHgTt2oC1TSYCgpsz1r1Dho0HImVSFU?=
 =?us-ascii?Q?6x6HIh4BXL71bcBD2FfSpEeBxTQbzNiA8TEgI8B+14Vc3ygmZu4yY30iB3/f?=
 =?us-ascii?Q?ythxCvlUtx6EuyMHFDVbyNAf3+EmHwT35Vcis4XVQf/kysfAsIORLNrhXlIW?=
 =?us-ascii?Q?pTEfrOr3W1N0fOU9OvfgBpQIiwxoPk++E8y8czKjgYP8oHOau4mSLFWrlvfz?=
 =?us-ascii?Q?50Jea3WYNofysLVSrzNRvn3C1YP37p8DIpScOIdDqNZic4WaRuHOt/qWdc+T?=
 =?us-ascii?Q?Cavjzd7ljvcu8CNZMRMwZ747bx/IzzO8cHNJ9RQZhQQflOM66+8LCZcdmCTy?=
 =?us-ascii?Q?pUMVzygo84N6c+xSwWM9lMX4YxS5BB0qBc5tNRR6krLLDsG1Ivt97XkggnBZ?=
 =?us-ascii?Q?87QNQQm2Kuh5cKz1oZV04JY59clZ6g02mM6TR3DNzwzVEhNfyBjxMEAxjjVX?=
 =?us-ascii?Q?m+GN5boci3T7UV8ICOS1CLqhgiufEFKvPjoSBrL3u1dwMx+C2WMDYWN/OCVm?=
 =?us-ascii?Q?pKqVIPnodV1lAcfsDbIMCj1oMITmIrnlKFSuwjZiX/VbZyZOUOnayIZetxUC?=
 =?us-ascii?Q?THdlUfDZ2Km/dz8JOfo1ojlNjkWoNZN5gna8+mGXc+yG4BLf+q2tcqeRztHm?=
 =?us-ascii?Q?KE3cBJNOV9b413cg8MFrzYls3R8tFi/UPi+AbBwUHH/4Y3FJ4rt0NPk8ee9w?=
 =?us-ascii?Q?VCjRUuKq4JTzsJIfWbiLFuoqLPc9n25PFmjHSj5SgYVXFf6ps+pqU82C3SCn?=
 =?us-ascii?Q?vh3eNm1emWVZWZH8+W6Z8VNKMz5c4gv5y1tP/+Ao?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d5a7dc-7fb0-4508-2645-08dcc207e997
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:22.0272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkJOsknipg5WJQV6BfrW2k/wNIBAusb6yP+uqfaBB992yrkRDdg17ix/QpWfhLbr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

This is some preparation for the Generic PT work here:

 https://patch.msgid.link/r/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com

Where this aims to increase the separation between the page table code and
the rest of the driver. Ideally the io_pgtable layer should be completely
self contained and not reach out into the IOMMU driver's
iommu_domain. This doesn't fully get there, but it does enough for now.

Jason Gunthorpe (14):
  iommu/amd: Move allocation of the top table into v1_alloc_pgtable
  iommu/amd: Allocate the page table root using GFP_KERNEL
  iommu/amd: Set the pgsize_bitmap correctly
  iommu/amd: Remove amd_iommu_domain_update() from page table freeing
  iommu/amd: Remove the amd_iommu_domain_set_pt_root() and related
  iommu/amd: Rename struct amd_io_pgtable iopt to pgtbl
  iommu/amd: Remove amd_io_pgtable::pgtbl_cfg
  iommu/amd: Store the nid in io_pgtable_cfg instead of the domain
  iommu/amd: Narrow the use of struct protection_domain to invalidation
  iommu/amd: Remove conditions from domain free paths
  iommu/amd: Fix typo of , instead of ;
  iommu/amd: Remove the confusing dummy iommu_flush_ops tlb ops
  iommu/amd: Correct the reported page sizes from the V1 table
  iommu/amd: Do not set the D bit on AMD v2 table entries

 drivers/iommu/amd/amd_iommu.h       |  15 +----
 drivers/iommu/amd/amd_iommu_types.h |  11 ++-
 drivers/iommu/amd/io_pgtable.c      | 101 +++++++++-------------------
 drivers/iommu/amd/io_pgtable_v2.c   |  56 +++++----------
 drivers/iommu/amd/iommu.c           |  96 ++++++++------------------
 drivers/iommu/amd/pasid.c           |   2 +-
 include/linux/io-pgtable.h          |   4 ++
 7 files changed, 86 insertions(+), 199 deletions(-)


base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
-- 
2.46.0

