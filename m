Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217C8157E74;
	Tue, 25 Jun 2024 12:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319081; cv=fail; b=fmXo5LWeBd/AsTUD7IgHClOKzOU0V94ZoFhzLrYZU1ahOxE3Js9b+qi50Mus9UEaJB2EOcl7tNiXahDieHn4FTFEgsdrOTxXEB9DFlL6rFConp2b8oGAFGjYw5Muz8fyfq+nVWwdmN5qXWVAewE7QIuLIWipVq7EimzIwXyriGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319081; c=relaxed/simple;
	bh=kg7J2wCxHDLdPbS0WBPk+79BXrPgOmuWWqyOy4iehLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uSrwaxK/4Jx9lsKPpvtLuw//2qrlQxYr1xQzuEowX1Dmo8Y5wun7q68TK3cYXMiw987I/CbSHGpUztb8L+t8pXEQGd/idGfSJjf2nKxZ04MuH7V251zct4OgFBASoBZBh4VfM0Ojvhx1BnxBHtGo8k+ZkZEGrhoLmhgSygWx47E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iKPbcwwv; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iKPbcwwv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/ZOCu7LlBVlkY+VsDdPI4oJcZ/2932ieSms4tXJbNIVr4jbvF4cQM4np/56/x8EqHVstUwlFYFjWxP7aoVpQbLtTkTTGYeWKEbFD8sWS4P33vBdP465YdZta8b3YzfckUHLa/TrGcbibHS8f289WIX4qgUBK55lde5j3WVW/QHls98I4bvVk8MSxU226vNif6047Tbvrt356XuUFGlSmnVNy88fNWvXI7mUwSV+iwLFGwAOXCUiyn2oKj5+78DSVZLgkBSs+0LAzuSfByO+9vEzwlXbDFys/H7KdV0AImGF5+u0ey1vVIEaszHJ0pVKtIM/ig9TwjEBqRIw6Auafw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wabBNxXyE372fzKVV6MgX7cQKFqRQEGkHidiVPr8psU=;
 b=KfMq+TyMi9auIMLSGpjiy+SkmnzzEwXbn+8Dzww/snKEDf1Z8e1YbzfGhRS61u7jnM1I1TW7tx3QAeSeQJ9010gNbz4MQmLoUAY7wwgtJRJZnGqK5zxjTOIzqxUPjhSXLxnvuGQYikLwhlzoiwhgDR41xqLUXM7Jvg3ahuowCRScbqsaXFShGsm845FVNOcf5O34srK8JyoylKbX+2SZuIFxILbFdwDVkKKfHyDt6vcG+SI70LcXU+6CVWpdSduqcPmep8jJlPC7TioQyOPSZYQG/Ae2bgKLKYhtiIlvbLQ+z5ylk5kFO88IO4EmYmgzovvSahqx3z1kdfFxu6z00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wabBNxXyE372fzKVV6MgX7cQKFqRQEGkHidiVPr8psU=;
 b=iKPbcwwvliCZOp7GbRju6n2n97/+wnrrAbwmIU+0r7frqnwUXBSUnvCgjF+o6H44qm4ARRT24ra2fQJFJ12gQTE4mVV1J196+18cUddjtLIzOURLwG5sYV/Lkv1Erd6PKGkGIo1OYf1IF+1U+2hM8tkRh0C35qxPC78R1fVyxJf3wVHSOo12qZSAbudF59OGSUd9PgzIwJfQPSGRWp5WJqo4qz61Va4fQ+pmCj+4ZU55M80vv52ispus1G6uAd+xUGaWruQOtfdUZfq3Q2FVDdlh/ElyRog8bDT4uljoKt4349qURvqW/KWXGfULDcu+R/bk12o3YA6WopAQtF0b7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:49 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 03/14] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Tue, 25 Jun 2024 09:37:34 -0300
Message-ID: <3-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:208:160::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b0a42cc-388f-4e43-86e8-08dc95139e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wpZy99BxgZHPA2T7ki7cb68gFyX00a8JSuu2zopaB9n3AX5m97tHlPeHCNh1?=
 =?us-ascii?Q?khsuOxk331z6i3T7IUs8kUE4imj9Czh1fCyqULDCITN7f/mePumcVshpF21q?=
 =?us-ascii?Q?xPvn7OToYJce2pjSPwXdsibCgEH+jOsZwkhAXM25sseglr9dF2vYgSWcegjP?=
 =?us-ascii?Q?/YuQ94EitMVwBvig8sKJJBC5Zx3PRk0tp9JVMLmfkCVOvfvoUC3RPcInAuPd?=
 =?us-ascii?Q?Y8VVUX9UiToUN825u7aoTyeQYo0W4mCWjlPmAqlTLsoUE8/wyiNnuuezFbj+?=
 =?us-ascii?Q?WP49+hFJ2GfMzBtAeH1TODzGNwyG0TqiBfaZUz32xLt9XbAkCX+J0XM4SZh5?=
 =?us-ascii?Q?yhVXKa/dFw1vvLB3Pgh/a+5uyZBO6SA51lfGzGScExDh0Y7/38K9gREkEPBL?=
 =?us-ascii?Q?ksvFhhcJCk5H+agWQOSC/rXL1GtXwJrJdS+NwKjOewMklPRufEnHjkCiSNOu?=
 =?us-ascii?Q?JRLZIT9VRBq4ju8yl3SuW74FUgv3V/t+/ac1bZDIsBqWyYiYEMdioQAGOBHU?=
 =?us-ascii?Q?9kb/e0gx6VoEW5oLRTq4vcCGXfigxRtmkEhUIhZ5UsbRBREuRYUzTgYU4xBf?=
 =?us-ascii?Q?jjId5kRS827Lkyz1TNLpzNeQwBJyJxypMEauxQmfWL5+ghVRwIYzqdMamRPO?=
 =?us-ascii?Q?irj0kOg/QW6WTW+NkiCbEnOE0cyhLnd8dq3iiU29QL9BhBQYquJtxWkGn1kb?=
 =?us-ascii?Q?kLvpRjHf2vtuQB9NSfIghPJgN3EItyhwRVVO5V2NwgXMkD/WxnfaJLPkgpvs?=
 =?us-ascii?Q?mfj8xumxwYEY3HdPH51VYBdWrkX5o9G+bRqRKJH296QJf8phS6Yi1htvq5Hq?=
 =?us-ascii?Q?ov15Ac+XJmkMFhfJfFgFLfumXNiirM/VqMozDdSghZ6cr0UK3gYRS5kGPFuc?=
 =?us-ascii?Q?fkDS20blCr/iHalhuZiH93CVL++rRMO/2qV2YIGoW7zXzQGs6tfFDvlV8BPs?=
 =?us-ascii?Q?SBGP+zSSRIVzriLztCgp3Jg67qw4QauOD/qCVCxI0j0GbgY7uxvAWDtYmn12?=
 =?us-ascii?Q?Y3l5s7EIOQHN6Bp6vebZ6m7VjbV69dZJXI5x37BRklLp32tREm6a3gWZQWWF?=
 =?us-ascii?Q?w8DP/ktQtofNe6zE6ihC9wFwcY8eUsQKVL+DXmeU/S8j2HFBkHrdAXCsuyyN?=
 =?us-ascii?Q?pxYXHV5sm2l97ISr9cj7pvR66X+iYaSjtkMptu2eOC9I2cAWpugAjfeUt3p/?=
 =?us-ascii?Q?5TA1zJTOCg4KaZg+unRcI5I73ueHGgqj9cJCEw9stnu+GhEvAlVUs7qPUOiP?=
 =?us-ascii?Q?mYsvGyEch8mG0gbozXy/LBkxfd9NAKfs7iY2mnQW8EoDbaiMZsIVlwBPmono?=
 =?us-ascii?Q?B7sNY2tCXdBct0oKmrnjPixH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UVA0pQ+y4l8H+zL9ayuiMBmdflLIVpVpOqZ5r81WJZCVkdDdnMVh2mkzyIRL?=
 =?us-ascii?Q?HvXsoyyiRZAWE17lCG7RYyWuokObo3mTjQJ++9LyOIUKiCWklyOmHkG0RQsh?=
 =?us-ascii?Q?vUXAT2fPA0Way42yy7qX+Q2xfgJPGAaJsraVd7+aIp6LRQcrc8oMFS6quTHp?=
 =?us-ascii?Q?H3QviufUO0otvTA6+Cj4rKW2FzyMYSCM00ddZgNOJKPGmEgb3AerU2Mws0Ep?=
 =?us-ascii?Q?4l6hOeBo+mU0II04JHoa3qGZjkBHPFHXdescV2PAyF/2OQtnrCR/L3WLUgc4?=
 =?us-ascii?Q?hxJ5lSuDR8fPi9/bFdNtHGvN7r17UMIS0v14GDgz6y7OA8McNT/x0unae8TN?=
 =?us-ascii?Q?HT3NaaZbjUFSiGciaNU8JiXbYAeuQnY2FfZAW8Flb04RpvFyVo+qTkQjhFMh?=
 =?us-ascii?Q?fFJnIISzhInibyCAcTIc5XUCXjke4UagKYG9vjJWFasoEIz8R3AhgivDijcj?=
 =?us-ascii?Q?ZSa6zM6gqwSCglgud5A2KG3MgeYtoDo7aCRzAyE6auZtQFQDw+UJdgzqbhe5?=
 =?us-ascii?Q?kBbP2WIqF5Gj6F140zzHcUFtjq8PrG/fCupRRl80tgGz6iS8CDdOpPHR6Vbm?=
 =?us-ascii?Q?f7YZmi/N8EiPy3oIJIpS5Yy9Z9+OdJxu/VYwu7drZ8NeUIWPPHtQhaGByK1l?=
 =?us-ascii?Q?9awFBfqmr/RITDuNjBoztHjTsbp3RlkYzEdPY46zmqLt973DQbq2HKnWgCbv?=
 =?us-ascii?Q?YSBA/PJdSEvQA1ZpIdL1EdrMunDoI9NqmcMo/6UJAyUSew73sbUafN8RUuG3?=
 =?us-ascii?Q?sK70LUXzsBcJgOj2RkLOFGCOpOa/FdHeqlhcf8TNAwT7/jeCWCslqmZ1W0cc?=
 =?us-ascii?Q?Y3WlKCBCrqhlloM3Y1b/d0Li4oPMKSFo78wJ192ACGFpKyjKGytsp8BHzojJ?=
 =?us-ascii?Q?p8MrnNfeJluM1g0g2WdEYYrXcEUXxtzWTjJVqybt/BAcudH2tH8pjPmM0laS?=
 =?us-ascii?Q?R5joKSeFQnjNts2I289uo96fU6V5YVGV7WRgbpNJhEPb9LAv925ACxDqyyMk?=
 =?us-ascii?Q?PbnJOB7WtMwHu+JRPuq0KuA/MBYuJbfxxR63csum/dopxN7MgdP8KBJ8BUzq?=
 =?us-ascii?Q?DOHfPO5tpu72bYh43IeAlh9J2/TruxL2k2+gxUqlJSVbo+609J4OYUWJ1UBm?=
 =?us-ascii?Q?hgGW0TiQ+eAog25Ci7bhl0C9BsTmCXZAweV1d5YVVNooNuqfi/ctfUdXV0hq?=
 =?us-ascii?Q?SMouVch7h5p7d8914AGhufo7B61DbYi7hnfdcCXVXK7HFG3o/6APpQ/jM+I2?=
 =?us-ascii?Q?hTw188s77xWKElne+gq+vpqRuvcLE3zl5hKoxdsShpt/PP3b05TMn0Rl7E8r?=
 =?us-ascii?Q?IPB8OLKu5X/ebLjy1gK3bvJQ2o7eJXm9jhOGwsP5lpybLGScQW0Izks1WLEY?=
 =?us-ascii?Q?EwX24Qpp1hu5kKo4iVCCrMLbP9GRwX8CvHLAIMeUGgZCOjgkwxxwMbR2OCiX?=
 =?us-ascii?Q?R5igZOhvjq4zC0vOfFgb7BgAXrnMkNsSs/Tp32VZf4ia5knKQLqVsgloeWb+?=
 =?us-ascii?Q?7LjIqZV9LnJ2adlsD/wNGFx5TCsnrbOh6taXXkTusPy4cWdtUqprpwFJqHCL?=
 =?us-ascii?Q?wvi+VvUwrUiZLuExLjiMwHQcNh5HJWdAppyBPlnq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0a42cc-388f-4e43-86e8-08dc95139e09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.9555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbIneuE8WrZmPNtCYvtoCwy5EZLzR/uKy5x1rx9GuEjWKfUgmNbo/Jq5pfU5c+52
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 71ca87c2c5c3b6..cb3a0e4143c84a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -38,12 +38,13 @@ static DEFINE_MUTEX(sva_lock);
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
 		/* S1 domains only support RID attachment right now */
@@ -301,7 +302,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -315,7 +316,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * but disable translation.
 	 */
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3f19436fe86a37..532fe17f28bfe5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2015,10 +2015,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size)
 {
+	struct arm_smmu_master_domain *master_domain;
 	int i;
 	unsigned long flags;
 	struct arm_smmu_cmdq_ent cmd;
-	struct arm_smmu_master *master;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
@@ -2046,7 +2046,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2534,9 +2537,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
+static struct arm_smmu_master_domain *
+arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master)
+{
+	struct arm_smmu_master_domain *master_domain;
+
+	lockdep_assert_held(&smmu_domain->devices_lock);
+
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (master_domain->master == master)
+			return master_domain;
+	}
+	return NULL;
+}
+
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
@@ -2547,7 +2567,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	if (master_domain) {
+		list_del(&master_domain->devices_elm);
+		kfree(master_domain);
+	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	master->ats_enabled = false;
@@ -2561,6 +2585,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2597,6 +2622,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2610,7 +2640,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2925,7 +2955,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6a74d3d884fe8d..01769b5286a83a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -697,7 +697,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -731,6 +730,7 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
@@ -767,6 +767,11 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  u16 asid);
 #endif
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.45.2

