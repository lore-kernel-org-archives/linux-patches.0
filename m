Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49C11802B;
	Fri,  6 Dec 2024 00:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444032; cv=fail; b=bwK7MAyl7ScB09yKV4GwANejW6ldCPOXCJ0tkROr/hbTWZX+QymtNFcM+rgXMKOhn+/vLHCJCbWXKiDhJOIZZfJMRN8kY2WMYj3K4L2qOohPF1mKPB0Q6XGN2PjMoGjDFedgRAjOVpBLmeHsGtoA4oRw0OZIXLXPjWqO2IZhokU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444032; c=relaxed/simple;
	bh=OfvHBAVMQRvWkIPrte7f4iBVamVTQThLpnCXWTbdVYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JXMG5gAKy8I9/qPS5+H6MnyVNBO1PEVY2vtLYklyKxW8/nZqlHhBKdB6wtpmRYOLQ+PyOlZytK4A1Z8mslv/Sqed9MK6B4wLmN/qy8Ark5uRO4D4sTFAbT15/+8528ARnmHqWZcjK3Z+emfqrWOk7DKGC+k52sZAatJEb3jDKKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ym+IVkUU; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ym+IVkUU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cO+E8s1zeDswEZ32fivmlLA+9sogOMQ3IRqLg1lXPh3zBbGNYV7pv6T6LO/9vwDsV3ZHtun+M6Vgo15zMh7ZKuBhAdHD1TE4PMnOpqwMhsm4ksAdHLJW/9rPSQxgXWvAmmWhzBMreweoFsh1LGrRpBBSVEW7Gu4B4Hq5rEZoWCH/T1hPyOHQrrJ99XdMyWv38eQJBAOqQ1aWfZiZGrZvMrlBriKeUolaUE+GUH2oQ28I/p/d1167OYNAZvBZ4X0dPObfc6vvzeXF7Dm53xf79B6HcHIC3oEl1K2F2ra+TJR71YsoCbHApRF6a5LcPLpFGSiAdR42h7x7h63d7rOnpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFAwr55mGx6gak3Klqz1C0ebuCDiBsVbXH1SAQhxufk=;
 b=NMUFbxy4uB6Z0upJWOX3o5qpR6cX4OekdCSHxs3s/CmsMjQky5FgZjHJ7lv2E1SuZrB6eHTp4w4g6sjzVUYOUou/5x6sdHSPAsR5JOvb+pL+48/xHTy2obRHHmnZSmy0x4hSN91svrpGvhbxCOAlQ3sCnV1yrvr+hLKzwq1nfxiOdppMmG5uHV6U6R/cqwb++XIbHOvotit22HhGiBYzzddTiQ0Wof75TG/za+KHMKnkfSo0GuY7uWQyhgbJLlK3l/c4Di8wIzxLFdZmYaM8EyWZNCrhDeFwvD3p6JO+iwn4UxzmXdVWyrgS1LjvODjN5D413b0jrwUamm+Y76IuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFAwr55mGx6gak3Klqz1C0ebuCDiBsVbXH1SAQhxufk=;
 b=Ym+IVkUUw+MH17urBLS2wh7/xRx2jiyG4jHscg16sDLdyMd68IJAXqNORfQjRhKMZ4JVGziR+KN1OjYe5dj5cGGPLePEtv5nXK3sZeztOnfArbZtvOPOQJn65GQKXCda9unwph9nTVRInHTPOV0iMXPMNUx8ID9fIt+inX8LXJ2+seIY6YeJX4KkBP+djSBn1Q/totQZg+NDAVe8oEFVVQawh1IdTMDVgwZ+n+5y13pXD9tt5l0GKuu9Pgq6J+1Xdrl7rtDHX/xmRsRl29YywViDtsdl04yceQrpIkIHIoNO994nDarjHTcn6opV2rkIpaiB7bzUrgql2HQJVZbdWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Fri, 6 Dec
 2024 00:13:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:13:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH rc 2/2] iommu/amd: Add lockdep asserts for domain->dev_list
Date: Thu,  5 Dec 2024 20:13:42 -0400
Message-ID: <2-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: 465fe1c4-270d-4d2d-249f-08dd158ad856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EgHqs8PYMUfj4aHw4Rbrc9de2nu+FAcDLghSoUj+kOipXVxWPS6N2ixpNcYK?=
 =?us-ascii?Q?M4NE0CxGgIH/NOcQ70eYvL4RtVKShouXG6w2Di7iByus8P5ImKRfS13EoQrZ?=
 =?us-ascii?Q?sU2+5kU4zHfO2Tm/19Q/tsrOyrpybVLQpl8YMzoOykVMfblG4nHN2vcsohhq?=
 =?us-ascii?Q?XkJHYfCTIMAPJ5aSfFaSNerdKzwSrC6oHhI5YDhpqzYT5WLzADM5ASJcMUvI?=
 =?us-ascii?Q?nffLzWA1KO38aaYX309YZyw7HebMNgopWSt14bF3RuvFLbOYOhHPuU9Z8E7i?=
 =?us-ascii?Q?2IfUGqJ1bRpQda8OceqJsSdm3CLNeL6yNWN1rbUFBY8AnWDVNCcOi0wA5+yT?=
 =?us-ascii?Q?I/5kowIZ5cRD+5Gnq1oGYh0HTCYj0163MhR1yYbp0pPvC1KN/RJAwtBzM/ei?=
 =?us-ascii?Q?fY+edHYWuYgRFwvQ0OSJEI3Y66tTfyn5a3aYrVRykQPVxsfRvfx5/gYytjUG?=
 =?us-ascii?Q?uUEwjRVQ2edZCnYZtpkRuW4Dw2rO6cosXKBqyK1ekRPplIiT+W28SYaRrNN1?=
 =?us-ascii?Q?Sw+GmApZXis6Ody/I9aBuUi82Mca+7r6qLQPlMUw+SRgS13EPARNtBUwdISa?=
 =?us-ascii?Q?tD/JarYB5NXwYiVBQCxDZk/J3z14j2pdCgmbDsmITwcLFEC26s+JYfgra21N?=
 =?us-ascii?Q?7k7/zVvtX3XoHB6uPs40NOkVylX9oNvWjOnvWH8bI016lapc/8HNbM/gMPKU?=
 =?us-ascii?Q?c7RO900GCV3OXxKCRJ2XVuvifs+pe5/jqi21ZNLZuayDkhkkBAw7jkLP9wMi?=
 =?us-ascii?Q?o2TEPsDDL3+cIaTg4WAJiPqOM48XZsT4RHfNAYDhsWU+EVSnrn1Q0nc8DEDa?=
 =?us-ascii?Q?gsrQdGJb6s1aJolc+Ks8EyRrxWUnEBluDHVPi70/Qr9wFKLo+XyMwrTIZ8rZ?=
 =?us-ascii?Q?m4MqjZsOlwNEtvQipVCmsJGC9hpscy9j2QjTDiuAC2SjRmCuuh2uqL2r4sMV?=
 =?us-ascii?Q?tOtql4lO0zN2RBgyIHCgmVdB+zb0KJ2VvlUj/IgBoIjsCC3sJn7pxADEohAH?=
 =?us-ascii?Q?ly4eNg0kU4P8G/lXdvNK64KcqbNLy0PTTq0ReqFBTrShH8IEQPqNR4ZXV1p7?=
 =?us-ascii?Q?wpNTlm2aYY3wWjThEbyJzKhERiVBtakRV9zVBNYE8RomyWHtvz78zbHHZBrx?=
 =?us-ascii?Q?OBc44nFuBx4jB1s5pvnFFrjgnCFwgv5ejQOmH0Xg/fcHW4/Q4idhfesMh7UA?=
 =?us-ascii?Q?aoaPL2qmakuZwicsa6dBw+/USMVpVU7cepECMF6K1iMFy4sdKwXEn89dUM8u?=
 =?us-ascii?Q?qjg/kp5VV/2HKhEALuN0KHvREonf4xiwf9JwEADEsKW9lWg42D5T/agqPfsx?=
 =?us-ascii?Q?V0LXvQQ6dAa7LecdvYzRSQ9VUKkxz229wulIvX5fernz2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jsw1zoQ6NYHjNJPDbCPMPhxwp1bYxhDhrQmXkxEmCfOnpDzFJRQfVNVdWISz?=
 =?us-ascii?Q?jRHrv1yGMIwN2YOyDGfaeaNk52/IvgTqcQyOgLrl7zHqRLQxNpse6EetOe2d?=
 =?us-ascii?Q?qpmGHOtolqus9Jlck5uEiv+tUgUOg9FeCfxv7NaDJTiY10CIwtUgiKSvxU+/?=
 =?us-ascii?Q?0NBrf5AwZF7n2PI1lLiq1UHctM07pDYiodmZpj2Eo4XUmF/8oZk8enDpvFV9?=
 =?us-ascii?Q?Mt6yR4L6hhAijDYOWFGYpqiz86qUUDOYOYRAj2DEkJclwQJ1heZJWQ76g5T7?=
 =?us-ascii?Q?z6HTj3slhiiB4k4Idu/qd0Apq7bTIQOALUb81PJbM0DsAQsvp4W4mbQr5uh2?=
 =?us-ascii?Q?ox5b4m9bWdW+ouPeHRqOcSBiIbfyPZAk2MDWQHq60a3S0ryCa+u72uGb5S/Y?=
 =?us-ascii?Q?/SPy6r9pBpcDPcOkSPbjx0GRTWvA/G0M1G9LqefsHz1gOU4JfXEJIFc/oJzv?=
 =?us-ascii?Q?v7ugrFU1/WopEchppG/j4vAF0vD2HdRp14GtZRRUWn8Bjvg35A/r+Av+Zw9E?=
 =?us-ascii?Q?n6RjWDv3HCDqrKiqldOLm76BKA/0OYCwK10nITFinQ2arILO4/vQXTdnzwpo?=
 =?us-ascii?Q?i3fYX+4dvsBYQNQKQ+A4Z3vuySpB+Jl9DEwVexKMc32ZftBs67YJeBVtcRwA?=
 =?us-ascii?Q?jQm4hRbNYk6vBngELtLNC6UHLAdYYO4euS+KdgGvC+jpPkJ2dKk6xMgCHzuO?=
 =?us-ascii?Q?ojbjDcaJxDW4wlRrUSop2/1dS8j6oHAamexzfGiRvi16CWLz7J0r/drbTSba?=
 =?us-ascii?Q?DJo8/a6b/ci9vCqGbx5NOq4Lk/2FwhIqnK2EKlT4wWxDVvusarL7ta797Yyv?=
 =?us-ascii?Q?nRUYac1LRAZdMPPeTvYGsgrifW80iNJkg8oHQwIaW/T8/OswbfbTCODBbRv7?=
 =?us-ascii?Q?frmGpI8oEqsXMTL+i001O2f+iJImyE/h7WXS/6Le4he/DxL5x4R7LBL3jEpD?=
 =?us-ascii?Q?CoeldPeqJK4+5qOadHipkX5c/hbPJsM+MAdQnTZKIf8XJHv/wduk+x8fzsrC?=
 =?us-ascii?Q?qTyouwXkiy0Pj0X/gAWCazTFk0vfmQcoWzmKGPlPVnKKgpLikbVLNIaPJlF7?=
 =?us-ascii?Q?nd0TKe6+3hjtcMBRzOOhcy4eFt11brIy86lXv8vai2VYx5yPeZphxArIxr8a?=
 =?us-ascii?Q?Alg/L6NHF2nB6kHx3beMwWRH7+x3buZHiTLHP93hBmqaPznPwyQimtNY7Byx?=
 =?us-ascii?Q?CUmi0OIa9IzgdPwE33hbAUTIMiVdwuvMro7A1KogfTnA3o37ZkNaeAilfGRs?=
 =?us-ascii?Q?0bp2m8qryyUKMElw+CUV7dYOMzAm85p9mDJnWgtXJShiNIlFqM8VfkXhpBj1?=
 =?us-ascii?Q?8RCpDuoRTeEf3QXPu5iC+BLau9dwDWnjymuc7pCfglGHmMIewJW6BzBLHNUE?=
 =?us-ascii?Q?JPLIws/zchejMzk0HESRQ6PFOS9MjAibeDZqPM+He6o/g66zMYDr5E+Hd3gV?=
 =?us-ascii?Q?SXCDquVI/DdcEjNR0afbaqnHMbWNpFWBwl8qhmdyYVf/oerSTD7aQjmJPyes?=
 =?us-ascii?Q?DOFmsf6Ttc8ZJQl4fs3qC4ZKUhhQPIk6z0nP7GY2YxOPW48YYwQ3GnyPh48b?=
 =?us-ascii?Q?Dr5xjUrrDbA4c4NSG7G7juRTg8vPaHJYl4jz4T7v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 465fe1c4-270d-4d2d-249f-08dd158ad856
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:13:43.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4eCRa46q2hVF+zmAYYmRlX4pDlgcdkADjvh7gcA4fuMRTRXQAQIEZFuH3jPJONtF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7496

Add an assertion to all the iteration points that don't obviously
have the lock held already. These all take the locker higher in their
call chains.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 23a168e229b171..16f40b8000d798 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1415,6 +1415,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 	struct iommu_cmd cmd;
 	int ret = 0;
 
+	lockdep_assert_held(&pdom->lock);
 	list_for_each_entry(dev_data, &pdom->dev_list, list) {
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
@@ -1464,6 +1465,8 @@ static void __domain_flush_pages(struct protection_domain *domain,
 	ioasid_t pasid = IOMMU_NO_PASID;
 	bool gn = false;
 
+	lockdep_assert_held(&domain->lock);
+
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
 		ret = domain_flush_pages_v2(domain, address, size);
@@ -1585,6 +1588,8 @@ void amd_iommu_update_and_flush_device_table(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
 
+	lockdep_assert_held(&domain->lock);
+
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
 		struct amd_iommu *iommu = rlookup_amd_iommu(dev_data->dev);
 
-- 
2.43.0

