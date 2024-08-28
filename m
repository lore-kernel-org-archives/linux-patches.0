Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF3C1A7AE3;
	Wed, 28 Aug 2024 18:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868839; cv=fail; b=S6PZBjmKXFH3Rsmh+FznMxY6rqW9E4xAsHci9KiNUJxyFlevFyKrlmQ1XEbdd2yEfeyOxJqI7VqiH/LmK7rhlOqTan1lMIUdAunJ0RWbQ5rxnK2T0T/01goq1VuoWrK4Ov8/J9MqKREWv4HGIIcyB8DhyT/CvzJCYPkcMO1kqgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868839; c=relaxed/simple;
	bh=XY+5zgHYrq+agBPbmbszk4Ef9RHz8fJ+xvXn0Myi/Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J6RZd0S6gpqXwlZCZKir8C5h+QTE/itMWsvShNRGEPzH0n/3uTSlHhD3kRUWdr5HtKijMebxo8tmGVv8nqvcUd4wswyukmK4f35kWP9ym1ShvwevYkHZ1VyPq53/DFbjJVvm9+MXAKMEubBPrJUdbx4IF4TjKuHte+tKliYcxEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qd8kIDvF; arc=fail smtp.client-ip=40.107.96.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qd8kIDvF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moGfoNAt3qzOkTg9rVJEuBHSXQJxPXT2vfB8edcEQDLpBsmKNyZ7MrVC25dh/RZQFwsSVQjXOf0Rt3S9Q6nBxIhrPXhHx1gRya07U3538gRXMP7ZUGAb1EnT/JGadM1QtS5M52nTUYpJyUrqviul0g5hRY8667okZkP0ZqoiOEfBbYimv40bhtPU+LQZpK7+jEPQ7I3uETluXWnxGb9zz9b9Q7i+lKFRnj8lmaZoyvBNpLhf897Khgo3cT/aA7g4yOepqWqXFMPvA/h5penC/4z+Kg9gL0dVkq3NaC2iR91xXgwhDSX/26C9AAn/iTIRzKihyhGEVhYev9+azHyoJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEnvJu/hzWWYu8jfHH0zZDu2a3IeCN7lBd6pr7MaXsI=;
 b=IK+dQjZtqHIyX6JgyIdrkjGC+FYYI9iZk8Is86ML0IMyOySpT2dYnl7ndm8FoMgv8iUaIvjdy1vy7GlysAhfJ0KfXmwfUA9op9CrymyEOnGBMqkEGAUY9GIeNMRf08g7VafosKzfl0pSdC6gvAfXSxg6CDYH67WRfLmxbaTXO+tD8bDqyfIrlhQYjMPguj7pfB2djgOj1Q56x5rVNCDbm4+IVuEirWA8DmlOY3Ut1P1fF32D7qWNRPGdvp61yNVfD6Qo1lJNUFnex9g8+YYLbHGTGSelIXqij09dCNE5hHnQtbqlwQPYmqYOEy4T8+5C22nuUq82sifEeHgwS+Fm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEnvJu/hzWWYu8jfHH0zZDu2a3IeCN7lBd6pr7MaXsI=;
 b=Qd8kIDvFBPYwstWbLWkpBCZc6xk/6RXVW58RAclPsc7AQlj8srIfcmOHkuWJG1RZlWs1KRM5UlG0Xmbd7z100q5qEYORypjnPT2ICTORnjd6AST01DNGY+NonLXhufFy20jUqFXHXusmGYM6tlYPHHyitsL1xYjvUVRsJ5XdHVWZfHtizoVoNT1RBTFWh97c7OCqq5J/Tktpzr5Oft4aABNHe42zzAAaZWh37yNroaAe+sF/D0qZFd6Q0S74ZrmjhdMByu85Tnei66a+tvcMTyY3H4jipkPc7x2PW+M2TFibQawCntvEBwdg+rcTFQrnIZj2xfo/V8W5MZBL5HP2RA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW5PR12MB5597.namprd12.prod.outlook.com (2603:10b6:303:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.22; Wed, 28 Aug
 2024 18:13:53 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 18:13:53 +0000
Date: Wed, 28 Aug 2024 15:13:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
Subject: Re: [PATCH 08/14] iommu/amd: Store the nid in io_pgtable_cfg instead
 of the domain
Message-ID: <20240828181352.GB3773488@nvidia.com>
References: <8-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
 <fb029720-17a3-4cb6-8a2c-6a5931279e98@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb029720-17a3-4cb6-8a2c-6a5931279e98@amd.com>
X-ClientProxiedBy: MN2PR22CA0014.namprd22.prod.outlook.com
 (2603:10b6:208:238::19) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW5PR12MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 9539b6ab-acc6-4834-a40f-08dcc78d2c58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yepxobjcwTuNK+sWUb3j+wGvVGAN8p5OwfvUVh/ejvqMzbiX8b1NZSotQEfh?=
 =?us-ascii?Q?BeWN2fs0+xHxadqiH9ePpC4+EQ5/c153KIShJIUyZIlrYhA+FntWq0iM+C/k?=
 =?us-ascii?Q?Ipf2TwnqeFnPCM25k7/K7zE7cz+j5Qs5Ct5H9SiILw+yoiaWgWlqxvKw8UVL?=
 =?us-ascii?Q?z43/RISU47t5YM6T6k5/plLlebhIGpBlIcxVFFuo1YdTl42LpOx8HI7Slj8g?=
 =?us-ascii?Q?+lmA0cU4GYA44ahoE89FxctM0lDI/cGQoXZ2WuFHI/DWPxvwWft3a5bU5isp?=
 =?us-ascii?Q?VnJrM0LxfO7shHY9tbj//5ZORpHzOAzylZ8uhE4NXfkftHa7gpO0EsQ7/yD6?=
 =?us-ascii?Q?yneMATnUw/JCQNe27ECl/kTIvnEImYwYCkJaeSZ8RhbGeuKt+H7eBPa9h6Lp?=
 =?us-ascii?Q?XK9LFY0mhSjjuBoPugeOYY9ZV1X7Ahwqx5nTZ8O1Hi5O+aW7uYHbWSDlwh/J?=
 =?us-ascii?Q?OQwHUxPw5Lma3OQWb7lfvlqfZVqkRSH0WyGYwsT20uOmzj04JpSQajYDQkMT?=
 =?us-ascii?Q?fsu5po0IUEHC57epP/a09cUDe51ohe+cPHoHrvdigEU1EwdVhXSCb3PIQDEa?=
 =?us-ascii?Q?cwKcXH4xMjt3tN/yf63Hv7OF4pxWz+DI02exavIOx/QbHCNNVan7KACLKQSH?=
 =?us-ascii?Q?AX7pUknHprKeOp+q711SpBg5MIrsjNch1I5hiSz6Mqpc0ywfQcWUZ8JqRBUp?=
 =?us-ascii?Q?+qWssHAHHXTWO8UHpruUCyp1haJl6mjE5kp1gWBhlreXX8XLwizXvK4qa/nC?=
 =?us-ascii?Q?bxo8nj1F2Zh/xy3XG0iIs2RBXhJGKvD9oxBq+knFkVWa+AWfFOb2mAXiGWbB?=
 =?us-ascii?Q?pkHftlvS/87wnRQZTsmDZvJ01FIW9W13koAknPLMTdgtzTJWzlT2Ry0gSYyK?=
 =?us-ascii?Q?hM42hwE6OHpxHVqPBq8bUqFmU3gzls7prErKUbpN4nuFv23h+tpSHiI9K2ru?=
 =?us-ascii?Q?GGBcLvVRjrjwudIsAIVp3tsByVoZ5O0lCoc2R3Uo+ndH0PT68RCA71gXJgAZ?=
 =?us-ascii?Q?uorwO5gcBSg9RjyrNzzPcZT5iQ4FhCOhPjwebA62KvqZe500ZnWwSxoe/Yql?=
 =?us-ascii?Q?6rbTJLfUPDlm1o4W6Xi2c8cLHiGvJ7Fpo2GUs6OMIKyde/QIbrSx7siLs/ui?=
 =?us-ascii?Q?SpKtRufHAxbF6dgfqbTK2Ko4fBb6Xhn6PM6okQpeRWoHJGAMRcI8VQr/xbBT?=
 =?us-ascii?Q?fcPYVY0s0LfHgDToCereKDth/voG0v+qJ3t2iwEdbikuB4A2z62oCP7jhD9K?=
 =?us-ascii?Q?/DGrl32yrevpOjCqvNWpuncq2tKsEu/fx3ju4VRS5e9qShh/SqDqPPbrmf3f?=
 =?us-ascii?Q?U402a4H4YHry0kHks8k+1+hnD5mfQN1Cz55HtXSNZKeZAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PMepdlDUTq6d82PbRQsWe6kJpkii4UrSEczyabj1WUSLkxm4RFF44fepXDL6?=
 =?us-ascii?Q?+yItVYQqDNrP5u2xemJuDFLuyTGyet5qSFoWYboylajhNMrPKaPGqlbSQWb8?=
 =?us-ascii?Q?eieSFcf0Ju2iU/SEepFDRsf0aegyRJk5aKU8tkSwJaWG3px72KmTd6RLGmt2?=
 =?us-ascii?Q?XPdZ5tLy6WzZH7QwA9rNOTcFl+XUP9EG1FBgH53YQ9uO96VlcuTnSb/Tqg/+?=
 =?us-ascii?Q?Zujq/TNljICvmF8iHeltfgzMlhMVVPg/IMNsw9VPj7dQkok5J4NOByLPfNs9?=
 =?us-ascii?Q?qjLyGGBJF52KV+cv/VsYZ9oocMK6TToNfs5NMzPLjzGsj04FRJcA2ybuASuc?=
 =?us-ascii?Q?MKfPXCo3bnzS5q5I9hX1wtyw3yvKlqS3CQu+40Dsq11jbhUE6zcxknExqfBh?=
 =?us-ascii?Q?1Vitj3OrWvOrqSElq0koViy/IoEQ3j6L7Nt52mUgTQAp6nztLNvbc61vFXTQ?=
 =?us-ascii?Q?SIEV+4RKWruShtvBurlNkr9KxWcZUKd7CkaGNtd4ovSOHSaTY1xVjw6jwkfm?=
 =?us-ascii?Q?7CeDriCoaEbDCAoPUB3zteEitsZtt1M7GInAWb4vKHlznEwFeVMmfJUHHOcG?=
 =?us-ascii?Q?OcpaiwFnE99ew729UUdJywGGrFouLRYlxTHjXaralV/KwIGPsHKtf52vsjT9?=
 =?us-ascii?Q?XYhQBEPWJHL0M8jE+ex7qJufzitfjfOTKExX4ffgfdDk2SevlBJkhF00pMjz?=
 =?us-ascii?Q?Ev0h54mztId75yHmxZeD089AjbH8TKc3a9ux+NRBk592iS4HDqGvOS5q3sE7?=
 =?us-ascii?Q?LrEoxPylaRziSVVpHCaSCvLZ3AoZde4imo+jH0S3Y1s3bgr2jO6FvYXGbq0Q?=
 =?us-ascii?Q?FVWxbFASzghau324UV7l1fh+UocpkhliSva7t3TKAyXM1DrHhimIZRIVszB0?=
 =?us-ascii?Q?hkIwoMatkjTJo19khSgGnUpBdpJ1a7dK270og2jfCENCdAk/7pJnIPBemlzX?=
 =?us-ascii?Q?w1aiYtwQf2mZeTXAKBP5rD79LK/qMpjwiH122jMiQsidFxfG0qGxuFLYNDNl?=
 =?us-ascii?Q?hVzpjCKcECW0ulJNarr64xj0Z0ZqnEAKBO00KmgCqK6A4hLIq5osAQzyjOkg?=
 =?us-ascii?Q?Ort3gduoSeOXr9VrRTX6ePd6cHxECv+8oCYdk63fxmE2FMcLGuGe/So59SRP?=
 =?us-ascii?Q?NYHb6eZ1eOzZZfrh8aJXHiaI/ie4g3L4e9DxSKuReCyg573eCAIhbFC0NtJ7?=
 =?us-ascii?Q?+z3qeTr1JCYB7RGDS/5Z4GGkpHm/KL4N3biHe3zncEZGjjpQnef55iYLXT3M?=
 =?us-ascii?Q?BT5nbBZXfKKEsGohPxraN2TDY6/60SAUjj+o7qo9pTT0zNO87WsX+1XBhx+u?=
 =?us-ascii?Q?zP1bbt8nq0PEovkH64lfO4XvgGfKi1/vhvOmZ5c9g1vOvpUv25nfNwZZuor9?=
 =?us-ascii?Q?17ztu3V5KFx1JHD5F5lXr3ySAXDUz0ea7E2WJQv2cHSVsa0w109dxBlYmZg1?=
 =?us-ascii?Q?0uSxqeunDh/ao1CHxg+ZaC7fhqFWEtBqUacSXliNhSNaVH9Lf14r82Z66U9e?=
 =?us-ascii?Q?LpLQN6DaDj3mNygChY2ZZevzp1AwKkTVUIgWjPYoKrW5mzPi43CYHxag8ErB?=
 =?us-ascii?Q?ObaM0BKUBRFtAa9JNY49YeNOCccrqKuKJ9yLFQk9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9539b6ab-acc6-4834-a40f-08dcc78d2c58
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 18:13:52.9509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLcAngOqVPplc4WLHWz6/5DsdMeKdkfWHDzGKX4GKm/SnXG+qO4KgPFCHka17yWl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5597

On Wed, Aug 28, 2024 at 12:09:01PM +0530, Vasant Hegde wrote:
> > @@ -145,7 +145,7 @@ static bool increase_address_space(struct protection_domain *domain,
> >  	bool ret = true;
> >  	u64 *pte;
> >  
> > -	pte = iommu_alloc_page_node(domain->nid, gfp);
> > +	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);
> 
> Too many level and used in multiple places. IMO its worth having helper function
> to set/get nid.

There would need to be four functions - set/get domain/pgtbl which
seems like overkill.. How about we just put some variables in:

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index d56be842c0b71e..f71140416fcf6c 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -141,11 +141,12 @@ static bool increase_address_space(struct protection_domain *domain,
 				   unsigned long address,
 				   gfp_t gfp)
 {
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	unsigned long flags;
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);
+	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
 	if (!pte)
 		return false;
 
@@ -182,6 +183,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
@@ -233,8 +235,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(
-				domain->iop.pgtbl.cfg.amd.nid, gfp);
+			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
 
 			if (!page)
 				return NULL;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 1cdd1675a01af2..806156632bf70a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2030,6 +2030,7 @@ static int do_attach(struct iommu_dev_data *dev_data,
 		     struct protection_domain *domain)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int ret = 0;
 
 	/* Update data structures */
@@ -2037,8 +2038,8 @@ static int do_attach(struct iommu_dev_data *dev_data,
 	list_add(&dev_data->list, &domain->dev_list);
 
 	/* Update NUMA Node ID */
-	if (domain->iop.pgtbl.cfg.amd.nid == NUMA_NO_NODE)
-		domain->iop.pgtbl.cfg.amd.nid = dev_to_node(dev_data->dev);
+	if (cfg->amd.nid == NUMA_NO_NODE)
+		cfg->amd.nid = dev_to_node(dev_data->dev);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;


Thanks,
Jason
