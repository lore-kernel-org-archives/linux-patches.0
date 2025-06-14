Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1341E5B9E;
	Sat, 14 Jun 2025 06:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882952; cv=fail; b=LpBbsSNotZz+yaQNY6TV08GpSZSWlITZ4zhG+clDLhT6Q6fCtc0/jXxChJyUouDBXlG2jzwFbBcuoUx9EK3S+z+hUZkE/fSaTeSyctV9nzel2yD4we05VE4O+fglnOrt/TF7q2YyetKXBGWryfu0RRy0Jge/x+zmCBh26eBg5Mk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882952; c=relaxed/simple;
	bh=pe8fvLpBqRl+hAZ1jKLHCgOa4iSeDF8DQiLY6LTmSGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckIK9rofnvOQf4BUaRRRfPSMOl8PB0W7ob2AXNDuWZwcJvcmUIUuj8HmH5DK5Dkl5JvHxhu+d0HfM/f9D86skNLqmfxkMGt1/bfrK0SqGH8mU401HSaiigJ1QmRqwXrJKICtTnCIG8cIH8+DjP25zAwg/m6bBC2IjW6ZvTRyWYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vut+mXIQ; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vut+mXIQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8Cwwgwyvs5qDZ3G6dDoUwKAXDycSW1+5EIdbGSIkf1pLQt0P/He5HdYrubRqlKJV5awsCabj4DWIdODF83ZwJIEbdGdMiUVqLJQrLBUYqx2ef27htQC9vSrT6SOdMOOrGDGUwKssSga9E9bHpoi9LfJqU8cTwsC5qAnsrrZMq4yFijG3SOKZc5Fb5DJh+mNa7w/NtssnK5JRV4AKr3YfgokuHDOYq/s0o4NpwkaI+ZENzlUeqBux4fsQDjuHzz0W1mk9WYjqio5I9D9a9fo4Kyzw8h/qWceQAvF+MS4Mr3KDtJXnHVNn6WCXSQBsvnt9eBJ5z41wrP4eG+DJExbig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl8W99GH0CZLHJoBgYZF8zpqVYJWRmyi0SYIDV6nWI8=;
 b=pcdxZ8kFZoWqg/T/nzYY8J6BJLa+pe5Qy3M7hAHOAFAtrBHN4QjKLLbQqEwqi3E47xrZS3UXN9uVgDw55RHg1CJ+QGEaao0oJdtsRLD2pFUVrCNt69GT4+Y6Dg6HeHlQ3RnipRTzi2JcYMezHihC9z375ncyhnuyQ0ZXYqx7HPETmEdKYT7TdcJMc2j94c1FcFNSVvBm39uh7trJR3maCZeV36GcT3cgHcMG3zQl52Sk1MiGjcVaWTMMVUsztOyI/KqkG2jn8ymTBa747iD6z1ELeLurBOPsqBllt79cQT9oleIP4TzCE9/e7/kzclEALRXKNxemAKmo1Jd1XZoWSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl8W99GH0CZLHJoBgYZF8zpqVYJWRmyi0SYIDV6nWI8=;
 b=Vut+mXIQ7fkl9cYssjCbbGPEF6kidw9DSkY7kSo8qDtKaf84tTa8+wyR/5BLBZEwAKGufWcNJTfqkQBg8Oa08UmpVI6fwFF+bn/J0NQUblLc7rHSn2AAh2Mb3/i48+yZlnTmX1PK/2Be0jC9IWswW9BN/DqGelpkEvJ9w/jpeulLnYsBsZoiYa5pOwD1bBpjps35eu9hWfTfW7mN3+JcKJW/34l6Ds7CDZQf8AJkWWcmTxaBr2wwdr2/8Hqj+mgwG5jyOBT2s03/GhCQNpIwhKufSS7KddUOjytWgCe8Fv8rBbL38xKOvdw8kwUsfzMR9ccT41fsZ3if6cb1etiqdg==
Received: from CH2PR02CA0008.namprd02.prod.outlook.com (2603:10b6:610:4e::18)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Sat, 14 Jun
 2025 06:35:46 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::78) by CH2PR02CA0008.outlook.office365.com
 (2603:10b6:610:4e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Sat,
 14 Jun 2025 06:35:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:34 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:34 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:33 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 03/14] iommufd: Use enum iommu_viommu_type for type in struct iommufd_viommu
Date: Fri, 13 Jun 2025 23:35:15 -0700
Message-ID: <6c6ba5c0cd381594f17ae74355872d78d7a022c0.1749882255.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749882255.git.nicolinc@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: ed8d2929-c261-44bc-d702-08ddab0db169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pn5j6eK0paWWBf1mwB3TVIOfzFvBgjeGp1YWfT8L2vXAHGKm3y3v9O2E1T44?=
 =?us-ascii?Q?PqGlMJFvKzE/wGJZZC5AGFz2jvdYmbKxXTMcUeAFhJ5dd7YywTzaraqZdiqS?=
 =?us-ascii?Q?GfZx3RI4/3ne9YLHHioD68/ALUQWmIZpu5MJtAf7IVW09qCpE+HoWC/f2f4z?=
 =?us-ascii?Q?Ba1B2ZTNna0baCkQynwZjvcIZ3oMT7aJmpCU95FvznO/+rILeN6PmPsJyV5T?=
 =?us-ascii?Q?e1m3Ft7YUkJJ5HRWD4igTcCqL6sKck+AJ4tyEn+CHxj9xxypP+hjnlYX59fJ?=
 =?us-ascii?Q?LbP3EGnv5pm3MsYbl5Cv6Sd9DnpvLTJ5LRXpxF1q/OLNGMEBTjkBl//TWoFP?=
 =?us-ascii?Q?1z+5YWWvAZXOYffpE4FDfmIyz65kctIWw4EllVDWgIbdY2bBAEY9XR0z6BhI?=
 =?us-ascii?Q?FK/dFKhz1mxwtVaZAcPdP2yysS+ed/vT7EDdt8QvWEpJ4hROJPkzy9LcVN3d?=
 =?us-ascii?Q?gFL40Q1bn63m4G2EaiOwgIq4xxXb9kv9faXDASQX7GD8SFHAh7v/KQa9WLVh?=
 =?us-ascii?Q?PCEF4K3BiJfvWJjPmeGszwv2SB1BJarLiXDbBYFYOk1m9y9Zu9qy4B/wwMCD?=
 =?us-ascii?Q?tji7DZuHOw6OQvTGCbDEbrsgr/eyBrFS7uIgjOXVmKaZZeN+B5+PCGCMnyxl?=
 =?us-ascii?Q?WDErCWRph6DzvJ3wFNH618uANRXS6jS8PRNoCv4oU++Mi6jsY6L/OAnvXT8I?=
 =?us-ascii?Q?J4z7tkPwVlpyHCEUb3Ne4Vcr/Ap2mR6gOpXgcuxjjNqImVMJeLLkmnUoNXQQ?=
 =?us-ascii?Q?kNJeO4VJWxJpZcGsQLLXDELA/tB7JvOnoKZFJPvss9RSClT2YctCbLz1dPYL?=
 =?us-ascii?Q?A3tqIfgvvFae5NKE1TluwzianOATbhWGUeEwiRx8ryYv+kHhz55gTkvHAHzx?=
 =?us-ascii?Q?FIul0cXgFOeOnXZ7s+98okpYVJ4mu8EJ9EOwI279OxqWu8sPcX0pMPyiAdT+?=
 =?us-ascii?Q?L/TCuW6ClExYzkIa7fWPmDDNnYSV74jga+qrnf9PNzHpVE2LhwPSO3w1xTiH?=
 =?us-ascii?Q?J4x59KPh8qQI+2ZLM0MdavcnOJb9bXmf6zEiXI7jS8KMMm+0KE7VFicchW5E?=
 =?us-ascii?Q?3/TMqftlEWXhQB4NrRP7DcI55o+6EdDrdwfSRIwBukixC4+HYE8nzUIKN+76?=
 =?us-ascii?Q?11A3hFjqe+G755xwTvG24xPX35NBnlMkZ5EolTHpmc4EinIpyTWPTHR5V2eS?=
 =?us-ascii?Q?FUley7rWUMwFEmOUel7GQ3Il2H+WKHF7JQj5QWGZC1E8d7kAOfS3UCmTnqZG?=
 =?us-ascii?Q?rPz9qECRVZySuBR6cQ/Wr87YlOtDCcnJh9aUkrituH1KTKfT9zcxrx/Cl18x?=
 =?us-ascii?Q?cC+02jrdpcOMV7hCYnZgRokZMUnpmd4i5J6cSi5ww2AzZNPcpkwIbYLtEqXF?=
 =?us-ascii?Q?S5IL5RAcNXSA7A4gARe3Mn/cDwn4Dm5Su9XGQY5+sCXlitU5FwedLDPT55LS?=
 =?us-ascii?Q?FrY82WQIbEtF+hdVkWkjG2HP+ks96zp6m+ylxXvF1G5wgCXGxtieoBuIUzzw?=
 =?us-ascii?Q?c71ZGxc4Qy+wPJsCHQZO/Eq5+yIV1dKBJqsY?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:45.4300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8d2929-c261-44bc-d702-08ddab0db169
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

Replace unsigned init, to make it clear. No functional changes.

The viommu_alloc iommu op will be deprecated, so don't change that.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommufd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 498c9a768506..ac98e49e44fe 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -101,7 +101,7 @@ struct iommufd_viommu {
 	struct list_head veventqs;
 	struct rw_semaphore veventqs_rwsem;
 
-	unsigned int type;
+	enum iommu_viommu_type type;
 };
 
 /**
-- 
2.43.0

