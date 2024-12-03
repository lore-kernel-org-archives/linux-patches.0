Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A711F8921;
	Tue,  3 Dec 2024 17:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733247104; cv=fail; b=EZymRvmjXX+e4/JkZY826x9P68OOoDRl2Rj2OlPfWwDU9R0jVfS//dSAlkotyrCLv14AfM8ODu5T9BalQs4LIWqIzYYbP1Xqbx1N7oYKY/uexHYiG4rVMIyhQsfbk8tc4a4BPOxqwVfW+loh1c0BR+sJl2gDpKaxzcEXwFwpwRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733247104; c=relaxed/simple;
	bh=3mbMVuB4hcbN7LKdMi8sNqKmEyxavp20L7In6Lg8VCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=juFqoGNBS0eyDKf2OuoDFHv2gFj+ego+qL4lkLTDa7/41WgqdvpHnPANRQnrXMRuH5sXIIl95Yi+xHyo+7WC1fECe5AT5Kr9CbPVCOnjJvAzd2k3fSiKTZJGhFsVxHEt1ZtLOjZc5C0FksNYASljG4MfvkhN2F0Kh56yPCqOPJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hmH3BCUu; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hmH3BCUu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaZKuQ/ALhimitJ7xxup1K4YqO3KRg5ucZK+9NopDpbyVRF8/b42/41wm/JCpeNwmuvbv4GqZ4X4QpEUzx2ZvLTMH84xzdmf8ANSmGkSNLoi7CP9agQ+c++tE90zYfIKEK7r/xB2QdiP6npQh6pGYh1v5ACsMzrc+QHrr+UZyb4LaucHeviz9EUDWNKC8zNHqTTrOFDzqXFWqqVqGejONhYlpXzLLeWzMPd9o0xuDpnBZm7plr2yFYhgsgAZi9iRw9Ct/WsO76jDrLQps3wAapdV2sT97IyDe6qKjfzYtW2eUn3f3IT3L0X6CvnDOdF7sitFqW+4lTYmWcxf8XjJMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thRiu1ljQKijE29fa+x/F0ZzXBsaZA7jDyS7e6ALdQs=;
 b=oa3sE7uplYzdpZ51mvaMncAiV5gmeFe+A9npGrexLVrDnylRuKZ8eTosMSnZinZLA3NqYH3V5gsMc2lhIh1bYuFCXZ+TxkoKKxd6xfsR55Xc6JEy+NiAo/EGr+hZHknPrQDskL+YySz5Noro/82sUv3hCZ2aRwrHtDps47kcFxhTI7oJ9ukJCZr0sbjFbbibLbX6r2kd6k8bLY3Rlyy95yZfV57nJQgmzmui3HLueciQTbbo+WIiAB2ahLhmmI3u9CF4lSUZqJ8KA1nbNcSZyKO5Cv6BSEoItbRmzhXzOxwaGQymNudVqWmyucSBWfzbFtA5ZNbNd9RuHZc3SHpeIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thRiu1ljQKijE29fa+x/F0ZzXBsaZA7jDyS7e6ALdQs=;
 b=hmH3BCUulDfYsG8YWw1nXOGDjToykTJUBH6ARIMaTouc/8GW9KbrrSybSl1wfduNdaXHQ+imEwgUvI5g0gZIK7GPgRyfb9M2MSSjKkWH6uRqx2QVdyHjTPCswxulQo/SZ1I5itZJqEN7kBhCorcDc9jQtMDL5zVfuWQHHaFL5n8fsoNmiV4He0pR+Ue/TZsk+ulwgI4CT6ajPcpDsjo5cvMaDkLKhq5clG/3f1TvvWurkUTZgs6BVxNJx7sgL6SKgBCKHORzE60lUhXGAcxvPjGTii7NOZTbDYEqE5V9BC7YlJ0WRPPS2Y+yfAGTkrZbHg7GESg45B/Zfcf73jSdOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7237.namprd12.prod.outlook.com (2603:10b6:303:22a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Tue, 3 Dec
 2024 17:31:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8207.010; Tue, 3 Dec 2024
 17:31:33 +0000
Date: Tue, 3 Dec 2024 13:31:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Improve uAPI comment for
 IOMMU_HW_INFO_TYPE_ARM_SMMUV3
Message-ID: <20241203173132.GA1930986@nvidia.com>
References: <0-v1-191e5e24cec3+3b0-iommufd_smmuv3_hwinf_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-191e5e24cec3+3b0-iommufd_smmuv3_hwinf_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7237:EE_
X-MS-Office365-Filtering-Correlation-Id: 22cefde8-35f3-41c0-ecb6-08dd13c054ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kQf67atuLGABpGE4IxZ8b1dxcBaAvCDWPOPpK00V646x848+wROq7h3vImwb?=
 =?us-ascii?Q?MwBx7W6n+zUDDue7rrLbJ3pLtc+LD+LUNLSQpAvgBT3ASkdkioetsyRMk2UY?=
 =?us-ascii?Q?tdJpCOYusLoUCioJmtdxeTI+cW4gN8xWDI2bJLKwCicaB/7UPkkPI7rxx5iu?=
 =?us-ascii?Q?yHGHeQshb2rXElv79BldBUV2bhyXRbcw3z6DwIKFgr+lwUYGF0b2Wk6R4iQ2?=
 =?us-ascii?Q?rioQJqnZVvNrShw+glC9cB/+TpdlEo97ioDp3V3KvfELyGBNTB2XJX1s2hPj?=
 =?us-ascii?Q?L3xsVfafAHmBXjGDoj4WwIbqgBtsEQxh4FH0Sb8EKBPhiLzj84CdkxoJcx14?=
 =?us-ascii?Q?O8bQMPtEy7B7mhc4FUSfgUjOajjKLhfOByraOM56vs2Y9P9cu+ZWBG9wpRRr?=
 =?us-ascii?Q?jmANR8UQsz6i9zzBTB/H98CW+G6M2GiKsKMLF+9EAeHJJdpWnzgFgZgSNAu+?=
 =?us-ascii?Q?jgwRiiATvY45ZabF5nVYzi7yzh7Hf2kiT1lQMu6wsR/ifYpvqE30C4f47J6M?=
 =?us-ascii?Q?SaGrqs3Jc1cWDXl/imuG9b8yRGvQhXt6UH3/1dvNnblINTXBW5vV4arvGqRL?=
 =?us-ascii?Q?zpTucjCoNLCsXJqbOERKZo/mIHGXoWO8C5k/XPP8HP+RBFCqF6XylzeeVkQQ?=
 =?us-ascii?Q?JhxsFYRk2CvjyyDgNPW5d78jHe8zrd98mqMaTTOS/JBZ6mvwKc1657L/QRYF?=
 =?us-ascii?Q?Vs6IK0lfqs2rNQqkwSxzB15NmyI9D1hlHrEl3a3qc/wJFv8kYJILZOSCRVZx?=
 =?us-ascii?Q?psI1X5ilbbbReqv4NQc8pK11lMWgQvU6WPAvB4bco9gRadfaDfq7L/QVC5g+?=
 =?us-ascii?Q?/bPCktusz8OFmHyKtEGUX+wNuw92GaY8hQQuMd5sb5QeuecJbXK0XoKLSKKm?=
 =?us-ascii?Q?oh/NAXEaYDMvCvdeaRinRTbHdBBEh8CUxw5BUj7LrLnhfGTnjtzUVZq4TEkQ?=
 =?us-ascii?Q?357T0WC1FgiEqoxQSPqNhdSBQJs601JK8LwV2iprZd8hCAOVfhQKrke3IhE3?=
 =?us-ascii?Q?dV7Hlj1jMiCZbudsysM37LCWVorNvNBeCDQqqHnpZnBYh38zEMNtuWEDc/Nf?=
 =?us-ascii?Q?4VVV2caxYQMAWwmAExK5140sxrXl1YUUTmnLkDqdiUDGq5/szlEK5PJJhAXn?=
 =?us-ascii?Q?k+2Sgt3iUI+KXbsC37ClzaPKZt4J6oq7r+2QvZ+mM+s/Kvx+OLFXK9XlCPKp?=
 =?us-ascii?Q?HzH1ZcFq69+hiakJpXrd8GA3t4lYZMsyngNCandGVDBM5NM9/6ApaSB6CluC?=
 =?us-ascii?Q?Dwfv99UCDosiFSCV2J81omEpG+pwXcTDez12dr9J/HPAgn2bI3KJ7d+0Tude?=
 =?us-ascii?Q?RVC0G2/zf6wotNuR+m7l9dfK8riKfPBpewB1QhqHuLUeGQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vDbXYnlS8s/h/csBUxUvBtWuo9y8KTcluoIl2RhZE3Y/dao+lNgxSPfojs5W?=
 =?us-ascii?Q?eUpuSHJ4wqZeU7Kv0jlG/GRJRILM0VAXgX3nVLN11YkjJf90rUjPla0Mfzbx?=
 =?us-ascii?Q?J/SL8bPw/rIaELPpQ9JX1RfgQm+vD/d2Jdiys5slYEnlFXjZrSJvjTWt/MUw?=
 =?us-ascii?Q?6A2tjT2i09OfMpDblGfAIYVZxqpS47wGK4SXSSMP8eMqT1DqXSp5j6I3F45z?=
 =?us-ascii?Q?lujHtUHBuvg4oE5QXqbSfi8c4QXhamxmZccmT6dHMg3yAiYEawcq3wiN89Vj?=
 =?us-ascii?Q?HtOVRr9LmSS6x5aByPSYANk3yXg5pzAPw+i46GfJjLFpaNU6mCvR8i8tulep?=
 =?us-ascii?Q?37ORP5xMmyMmLrSR2yQCuis8PScoSgtVrqtVZ51BwHxk7nqSJ+IewAEtwBqd?=
 =?us-ascii?Q?qgVJhExzwX0KcmRjCLlo6mzN8SkTlXOM25Ln4BAtNKFOOwOqbdX7CBflLH4c?=
 =?us-ascii?Q?C987Eq4usY7jcykBNSPO350VOe7e4JJfUgEDmc259OvW2EpyZxMti5VA8eeC?=
 =?us-ascii?Q?gHQxtkPmx57NWgbEVWpVxCRUmzCw7scAWJ2T15WL4SOreKrdYcTOUVAtPaHu?=
 =?us-ascii?Q?iIPYX1dzP44AVoZ3bKItP50boRl0Yfd3+p6FgNqRAlAeIwmXxEWVBEq3s+z0?=
 =?us-ascii?Q?K/69nYlTD4/o8wJ7PEZDUJV4ukWSoZv1c+1h2V+278/NwuuhREphDIsRDi1U?=
 =?us-ascii?Q?q3VyhKxvvgR3ITWyCrmOT6nTdX/VvEASFTtW8CLNWFWrFqOVgApl02TnnR9x?=
 =?us-ascii?Q?gjnDKZWnuM0lQ6DfwcjwYczUPVwsRYVbqejcAxcd/J6HBI7+6xiux+2Fo9vA?=
 =?us-ascii?Q?jAGHouXHeCkN4cr4Lr4aI9ErO+bbrcgz0qPCodjIuvKHJl5Ks2F3k/Hn/url?=
 =?us-ascii?Q?WqBzdmmZw3Hg63LzwBmOwSr1q658xQ6WKIk53/fPyu5EPG92QHUqzhbOHxwh?=
 =?us-ascii?Q?NKIrOz0Zvhh+gwqH+1FmtWVrlLyORrBNDCESOhRjlf68oRKg7pUHp9snudVs?=
 =?us-ascii?Q?Wqzo3f27z//wbAF7nSEcgzsck7jaPEknaYm9dPub85x2SmFfpvADFl8VYdtz?=
 =?us-ascii?Q?fqh3aG3BMfFQ1Wcf4iPsFlnwnaV9APiToAtiXs+P9RUv/EUsiBoXaBG92XM+?=
 =?us-ascii?Q?4RHW5BJI9N4IIqdyTgUYk1+3KuZ3iparbTX69gyW+PVMmdZTIxRAEdy6LD2f?=
 =?us-ascii?Q?lPMXt9zkmofsodVb2hZgNxZTzEQa6xJMmPfDU8NWEtucHUofqf33ZuxyHUwi?=
 =?us-ascii?Q?isLAW1qItnrw4Ejpw3z6xm6Jo5Y2ynJEIO3+yRRkSLDUsR/RrL7EdDKdnb4t?=
 =?us-ascii?Q?XGq0hjTpKP4mTHlaOw0bg4aM5YGgyW+W8/bjfRDvjG+6hlK/p+PQJNRwv9Aj?=
 =?us-ascii?Q?WQxTBp/NFTMwZ8gZfi2KWLFyhJ+yOsXkAWyOwanjA6LB2kBGXzLOiAZ5HUKd?=
 =?us-ascii?Q?DcwQjYNgOhi0xngDOEgR/tSu4GG69MdlfealLdlG4VghJ715AAuGmLhZ0s0L?=
 =?us-ascii?Q?8Nj5I1Cwtlo4uYsVM/xYaNqx7otcM+UofYBDLhtan+XDc/7xvx4bUx5Fa0C1?=
 =?us-ascii?Q?DYevKW/yhaN/hc1WyUfl4nkbUSRU/X1IzpnUZkuY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cefde8-35f3-41c0-ecb6-08dd13c054ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 17:31:33.3756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUWVLSKEes4p12ijwUlneyCwzKoozWBOKMZqyjoksGzJTNH33PbiSihMPpgNN5/N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7237

On Tue, Nov 12, 2024 at 02:51:36PM -0400, Jason Gunthorpe wrote:
> Be specific about what fields should be accessed in the idr result and
> give other guidance to the VMM on how it should generate the
> vIDR. Discussion on the list, and review of the qmeu implementation
> understood this needs to be clearer and more detailed.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/iommufd.h | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)

Applied to for-rc

Thanks,
Jason
