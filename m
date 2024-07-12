Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FAD376;
	Fri, 12 Jul 2024 00:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720743072; cv=fail; b=ptXbmB+InJdHh3iCXCVdSvArhoLFMBieDYHSN0xtZi07KijBDiL8Uytj7w3DqP8HTtjTHTueiJD1JyPSzPTJYTfzhKGN8sQtTMRzBEfeEU8nVGqEx/wY6mj1Upi7aWR/j1+WKLb4f8DIY2zDR5j2O2hqwmMalYsOnChCQljPgNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720743072; c=relaxed/simple;
	bh=7fpkwFKTJqY4sEiLVVGkghkR8atP/rSLquRCYKkIZv0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AMaRizbZLdYUEONypjsSYzRWJioFe+bSc6llBrPVXjP/OsA1fh7AYQrQ+mU7GqZ54P5+eeaR2n4tB90NMVFlP59aSJKC0FyXBjvPoabuMYm1Uh0GD+rNGUT3Kxw9RRGhMl/LY9j6b/SlYXb0QtP0A+ByEf8faIFuW1hOjt3VMqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LfoEhh6m; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LfoEhh6m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UgZdyKzmcLi+TB+PH7GNsmeJZgpERQtC9IZbJ9wNZ8iVpEzeZplpoP2QRht5hROIaDQ61VgwmdCH1JTCkOUFK1Rbka5+j2w1JRbPxyz+c7Y6/PqDz7cOH2ueEi/1A/r1SR8throngPKkW8vBi4Irf1ozhwTNJG1cZCMXfb56dzpWNN0pSxN7PJart0VVB0GsL0fHtM3eCKfpLE8A6adqdKlm2imRBMIpQcaVll/xklW9A+0zQxUDUZm5fBt08gRw6EO8FSkDz2LRe8Xn7DBZao3DkMJnsECRDyu7R99V1WTQLtNocJfizH7Xe9L+7FjTSHodupVgtZYuKUm3yYwVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUtJVYcYgQvY7IxLPGo8rU7EpgWPg8DvCsEVwRroMqg=;
 b=xbZbxlPZLN2vKZizuVBiXx8gWm0gHEQ1Q0BxkY6fDHK2ICMIbpbBsaJ+/YKWflR2SrnWgJ7bYuvAIto+sexsI8qYj4LBPL02FcVzNUdixEMpOj35xBSw6AsaJjMtL2enuAjsN2lRIL5XarrnJjlOXhcxvFGnqxnEScuKqhG6AOubCrTJprfwMnpwX6Ik5QaEQRB5p7XCwYx68JJYhXxxbyUV3cPxbthO4AjLeKH3weMP58WdD9mOpzYt0esVvIivY9AS6c6/2d1rzKCq5PoNoEq0cyDTPv9P14BghiFlg3XzB4pqAi6aba9o5afYOkm6BXve6+DnKsv/8zTy+mkhFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUtJVYcYgQvY7IxLPGo8rU7EpgWPg8DvCsEVwRroMqg=;
 b=LfoEhh6mGyiGJrUQuoZJ/XBhDxH8+EX+RPxXfaEQwL5j60a06A1vfAXw+sSCb3csfGbxO/9l1Hrv7AHdAGAjKw7NEHJrdykApRyySnIxJei8aezMzLXPbD8SKnA6j2JWwvwUGq7MgdER5R0VEeiABpk60hhNvx3GS3DrGMkYnaI7KR/BnRl7MfnicjUYRgzb2YQ5wiJ39sZjMQsuCOIltCgEIkDP/mJRqOcppdu7sXdKj3jZyQe8YEKHrol9n8tfalzvkczH9hEQIUDiSUJu5ZbH6rhrI6j5yH6fkBeXbtB9tV9jwCBP/AVddfkM9ikLyiF6jDaS6M4VXnyi6eSSwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM3PR12MB9286.namprd12.prod.outlook.com (2603:10b6:8:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19; Fri, 12 Jul
 2024 00:11:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Fri, 12 Jul 2024
 00:11:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommufd: Put constants for all the uAPI enums
Date: Thu, 11 Jul 2024 21:11:03 -0300
Message-ID: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM3PR12MB9286:EE_
X-MS-Office365-Filtering-Correlation-Id: f114d2e8-8cbe-48c7-9c0a-08dca2071f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2ijC1J3cNkSjfBBIdn7OeW6r42MjY5tWqQYQ8pOiPVTohVBjRc6nZK29s26D?=
 =?us-ascii?Q?U8UM7uE4T2nDvjDGAZ9wig7yyGv6WZrFGk4m/SIOeUA4yKkWD2jNTj0/c3CV?=
 =?us-ascii?Q?lqTJ4TOFwGqCLJCVjs0tCgSQEiG61RqcIxehukMmEhGFOKTpdt/65XccCwx1?=
 =?us-ascii?Q?nUyGwMVjrLx2FaqGWxsYztS14s61IIR1R5hk9zqJQiPunHEgqyglnLtJ9Z24?=
 =?us-ascii?Q?KecCZ6QNCm0mkagrV/dB1T9cJ+jm49DFDTJaBHmAUR5wh2Vyl31v0v8jlfLg?=
 =?us-ascii?Q?91Q7npQSfAw0pdZPAtsXnugRxZxIwDGw/go2a4k+TyR6YHunGS03GLtPYpz5?=
 =?us-ascii?Q?Qvgepi/5WGK9HuSEYc+ct6uPtK3sMj36lkw2zyf4J5aGfQjkYQp1/fsjxq4w?=
 =?us-ascii?Q?2rx22G80aEyM2d9ewZgIWre1W0AUFUlkZ9Cy3diustx0dqU6Iv2xeWEWz3ap?=
 =?us-ascii?Q?FBcU9mc8uRfPL9TURhhb2QuglBj9tBkcLYiQH+1peoEGd2AjWx897Ukmf6mw?=
 =?us-ascii?Q?+0dorlOBNwP2jvCn+LveCzF1j0rP33heu22Fffh7VcMq0eyJvr/QrkzxussL?=
 =?us-ascii?Q?hUt57OBzPdj8QveJGjS5sePDA+75F16877mWMuBzASiYM/xyfZD1iBuJZetF?=
 =?us-ascii?Q?AtQKwezdhnJxeVGUVRtv2gZYZEpkcXkEQZEShVK4OsenSmnECkq4ZtQ6XHBd?=
 =?us-ascii?Q?EQxWXBPpu1Rzo6XolNOiCPRdvcPAFj6BV2Gr9nve4fU10+vzGErILLRjHO9e?=
 =?us-ascii?Q?hTdjkGvHtD8Arduh7m9o9E8fwjKaF6v5atHwzmu9qVV7UTFBerW/H2pFvEwb?=
 =?us-ascii?Q?sGMZtZ9JuXfYRmJOlwt9KOhiGMGQKp6EPm4MniqEOwbRCzGjbrjjD9B5F2x4?=
 =?us-ascii?Q?1QnNhG/h4J+qWNbwFGf/1EdqOXgJZLgJUYrOVaOfe4UYUmnI8iPVRzdgA0vU?=
 =?us-ascii?Q?eKBxdStGnD67s7FisV8NWjO2B0htp+R9l1lTV47ej6/tkBNrZwjZB7tjz2nJ?=
 =?us-ascii?Q?YiLEn9QF7aPQiD1Po5GJLsrgwwVspxKDdME+Qm434WamL603xWghrNwtp8rk?=
 =?us-ascii?Q?DvV0in38acEQKqKis2brOK5Gw2RycTfXxL3x/+FPGbsrLdBxm6vnphRo8NgD?=
 =?us-ascii?Q?Cu9tefP4TBkDhV2d+dEPFMgUY8iL3irQjJCaDjVuqEOfsLklR4FnhGtRVup/?=
 =?us-ascii?Q?ZQUDCqv4h1cklVTRnVsha9r6rE3XCkCtrluDKS8e4IswnY1nUn2Z3EsD4+k+?=
 =?us-ascii?Q?+4S339aqmvc0sCO47XYuSpy1skXeIub3bWaWH3HaRqIg1RW3T7qGYySYynel?=
 =?us-ascii?Q?UmjA+rpzn0xeeFDIZWhtfcJnCapCZA83S+cgsM63MbIKRw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mc3ookHx/sJhXpoVQMSKZGc9pKlIKqJ6D6vNe5iDmSfA7m8FRya4/E7PRoFw?=
 =?us-ascii?Q?zVA+ZTmlbAO7J/DvZPlwyYgyCeQ8fdU5CNGRVBiC9SHYEkJZna3qREX6jRor?=
 =?us-ascii?Q?UESRB9AOu94cLqozzLQM+MinlwbfYThwXvOKQEQzhFDpWKP+/tXouC8LW/TR?=
 =?us-ascii?Q?7ayqejUhn/zswrfIsAX1SrThghrDDgaoDZFfAUcjaSGXIWf7j6gmaRKGZsWq?=
 =?us-ascii?Q?uw5rx+SEE15fVLAtVXWrYE9Y2UkxdsqEvRk59x+DI8IWT3lifgKq2aC9rtq4?=
 =?us-ascii?Q?NlaEYkFLnH4vu+DrJm18irK9xEElAulHfnOrd+7tlnwyConTP633hKRlUGxj?=
 =?us-ascii?Q?GLwVQN4wIDPjJUqzXT0//6HVxpEPsHEQniRNoD/v3mO+0J7EMmaYKaiWG+8q?=
 =?us-ascii?Q?3ZK4FWQUql1o0AyCSYm1pL7VwX0R6/8iFPlhmG9EhR6fJ9EzTmNUzK2fC9MS?=
 =?us-ascii?Q?vtdIXbr+7Mzm714dHVmxwuWkOFFgoV8/mvXS/yPPYP4wFdrhKhjdyxdTbncw?=
 =?us-ascii?Q?xN9BB05wc4xZ9sq3TLn+RgAxJn5ZNysetkMNuGOg6AiM1PE/2Nx9pziGrs/x?=
 =?us-ascii?Q?2C/IiUp/6hJWUhdoPz40588SXFMXaPHphI/W9jmxue0Nerx1LPEU/IBXqB7z?=
 =?us-ascii?Q?YyRq9Lv7JAptha12Rt6mZ1nM/IKXYeHDcKpaUXXDdLBiowKk2f/ehmExp9MM?=
 =?us-ascii?Q?Fa8U7kN6l4STBV3+/EltonUQovBzeSbuynsaRHCGuPEP1Izn8r7WcYuq9sF3?=
 =?us-ascii?Q?/7uRHmVYdrt4tn/0tf7YZQHDy3SRKUM1QSGWILRMFD3Z6Qlqsun8whbo9bXb?=
 =?us-ascii?Q?n/e5opS3iUCYoI6QM+Wg8jQuUDoHKNZvQ+Vx3lTZQYhW4FURQLDes+WdOkpl?=
 =?us-ascii?Q?k54YHw7r5VEQVf1ZZR7ti+00OqypSS3QtEg7Y5bs8tPURv4Jgnkr9HmELh1h?=
 =?us-ascii?Q?XzKoOC+p1VA5dei6HoFLT6sRgs6Ew/c3hER7u4cdXcHyYXFfvdFXttixt/EP?=
 =?us-ascii?Q?okCGHPTQ0eyndT47jpK7ySVRgffBsSyPdPaL7L5CnVzQi0kctCzUhvItRM2/?=
 =?us-ascii?Q?Nz17xp7llp3zgxubnnTAnQGk+5LbOuXZSWCkrStmc0P7u/vfsuN/flCxAR66?=
 =?us-ascii?Q?RwNLhAA7zX4I/QRvkFwxG7YVKk1unvYvoWB9b46CfJLgCy0bkVWAMbOfDYYa?=
 =?us-ascii?Q?Z/DIFl9UjkNxkLKpl3jtXsGfjviaj9doO7iLliHWsPVoLLprd72s3gxE9eBp?=
 =?us-ascii?Q?J4iW058jHBgFSTfbY0VnRN2qQj76fhJr/U/ZUaSwviPngJDm6HJLxm+eDMWq?=
 =?us-ascii?Q?Bi+Xarc9iYtpEwfXYr/TjEIZVeykwJ4wr8iNSnVe29xjdDrBHVRirD0/IK8B?=
 =?us-ascii?Q?TIY2dIF+La7iUCCYI4yAtTTnGh5t2fSgH7VVIyHi0dsRsF4EB0mTCT2BWC2K?=
 =?us-ascii?Q?SOP9dIgLmvXI3vE6VquckYCTVoBQWKju9TCQptoCF4ycdAOtjvsPmNI0bRVc?=
 =?us-ascii?Q?NEXIA4RFZIkU3RYDIFdfopM07+SXDCwxlYdA4fvC9r+xzxEi/OAWUa8ODLZX?=
 =?us-ascii?Q?TkXjUhW37KCDApv0UejI0BgtCZ2szzhO9LWbdFI1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f114d2e8-8cbe-48c7-9c0a-08dca2071f37
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 00:11:05.2867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCuC3oC0YQwp6tkjWAIdNnsCo9hRJp8r958ihCiCWRmlFwio2voEkEmpXiwVHTxi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9286

Relying on position in the enum makes it subtly harder when doing merge
resolutions or backporting as it is easy to grab a patch and not notice it
is a uAPI change with a differently ordered enum. This may become a bigger
problem in next cycles when iommu_hwpt_invalidate_data_type and other
per-driver enums have patches flowing through different trees.

So lets start including constants for all the uAPI enums to make this
safer.

No functional change.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/iommufd.h | 40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index e31385b75d0be8..4dde745cfb7e29 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -37,20 +37,20 @@
 enum {
 	IOMMUFD_CMD_BASE = 0x80,
 	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
-	IOMMUFD_CMD_IOAS_ALLOC,
-	IOMMUFD_CMD_IOAS_ALLOW_IOVAS,
-	IOMMUFD_CMD_IOAS_COPY,
-	IOMMUFD_CMD_IOAS_IOVA_RANGES,
-	IOMMUFD_CMD_IOAS_MAP,
-	IOMMUFD_CMD_IOAS_UNMAP,
-	IOMMUFD_CMD_OPTION,
-	IOMMUFD_CMD_VFIO_IOAS,
-	IOMMUFD_CMD_HWPT_ALLOC,
-	IOMMUFD_CMD_GET_HW_INFO,
-	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING,
-	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP,
-	IOMMUFD_CMD_HWPT_INVALIDATE,
-	IOMMUFD_CMD_FAULT_QUEUE_ALLOC,
+	IOMMUFD_CMD_IOAS_ALLOC = 0x81,
+	IOMMUFD_CMD_IOAS_ALLOW_IOVAS = 0x82,
+	IOMMUFD_CMD_IOAS_COPY = 0x83,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES = 0x84,
+	IOMMUFD_CMD_IOAS_MAP = 0x85,
+	IOMMUFD_CMD_IOAS_UNMAP = 0x86,
+	IOMMUFD_CMD_OPTION = 0x87,
+	IOMMUFD_CMD_VFIO_IOAS = 0x88,
+	IOMMUFD_CMD_HWPT_ALLOC = 0x89,
+	IOMMUFD_CMD_GET_HW_INFO = 0x8a,
+	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING = 0x8b,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP = 0x8c,
+	IOMMUFD_CMD_HWPT_INVALIDATE = 0x8d,
+	IOMMUFD_CMD_FAULT_QUEUE_ALLOC = 0x8e,
 };
 
 /**
@@ -400,8 +400,8 @@ struct iommu_hwpt_vtd_s1 {
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
  */
 enum iommu_hwpt_data_type {
-	IOMMU_HWPT_DATA_NONE,
-	IOMMU_HWPT_DATA_VTD_S1,
+	IOMMU_HWPT_DATA_NONE = 0,
+	IOMMU_HWPT_DATA_VTD_S1 = 1,
 };
 
 /**
@@ -491,8 +491,8 @@ struct iommu_hw_info_vtd {
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
  */
 enum iommu_hw_info_type {
-	IOMMU_HW_INFO_TYPE_NONE,
-	IOMMU_HW_INFO_TYPE_INTEL_VTD,
+	IOMMU_HW_INFO_TYPE_NONE = 0,
+	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
 };
 
 /**
@@ -629,7 +629,7 @@ struct iommu_hwpt_get_dirty_bitmap {
  * @IOMMU_HWPT_INVALIDATE_DATA_VTD_S1: Invalidation data for VTD_S1
  */
 enum iommu_hwpt_invalidate_data_type {
-	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1,
+	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1 = 0,
 };
 
 /**
@@ -768,7 +768,7 @@ struct iommu_hwpt_pgfault {
  */
 enum iommufd_page_response_code {
 	IOMMUFD_PAGE_RESP_SUCCESS = 0,
-	IOMMUFD_PAGE_RESP_INVALID,
+	IOMMUFD_PAGE_RESP_INVALID = 1,
 };
 
 /**

base-commit: c7a0991733cc7b05ca32217c156f7030617f5879
-- 
2.45.2

