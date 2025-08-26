Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A810238C0B;
	Tue, 26 Aug 2025 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229204; cv=fail; b=W7n23Clk/6xmgduIoOqDc3nYzY0lpLgRWoLpj7gs6TParaouvN6djd0eFxeTD2B2TekZBXGnD+jI5gehQbLVJJs6yayB0/7GlxmwNeOc/pVHtPSVhaBUw2FhfbrC2OB+QWyLJc1gWEd8F232nl1TTdQOKx6U8SKDDF2vZcQazJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229204; c=relaxed/simple;
	bh=Zc2JdrLWrsiKrZKaCRwWqMy3pTHji6N7qEoown6wkIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pzucBPxbotrZ8f+ZLz+ZYPDBG3F/aVrSxf3Gq1lpcD0l7JFesjqU2I2Wpegx8+Xao2KMNIStAIiddbUnuKSL9UUaCBEwXEgI9VWgRB1mINE92payZ1QppfELOMhhE6NaWkujYthqDZexX2NWSHebt1yQO1YkballNzYHOZ0zpUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Re+w6bkN; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Re+w6bkN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZsxVt748U/HEZ/J+HpBJ05bx2+cVGCVVypmvyYt17DdpLm5Kaxj3nzdRzm5qcCbAY0VYQohBAiw45D7eJGmg50q0YP87u7tAl7Jpc3H3dn/dCCjDKa6S2mPPKuiYOXKqp/g6ornjwNwldmMcLYZGDx0w+cJN7XQDe4dQ0oasUems01q3jy9mmEZ0BwY/4UN1P4zvViVdkt3K1I58bAcmLJwqOKrDeICdt2dZcrjEYOrqRj+gYd2se58z681NyvU1bM3axBixX8basHCtFTfFm0DQQZBFw8r4u5VXe5G24IC4+2juJKYP28DiJHU+hH1KE/sSeIfINwS0fk8kuqzNfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvDECVQbZ+Q26Ee1wbYWfzZHn/VERAyyXN2XSbfk0hw=;
 b=lVONV7UVxAEWoo8IlMs9U2Acy2zxJIRMuGqUe90R1WI5R5CLMETnHXrkGsSyILoBfDnidn2o66Gcv+3aXImNO1ocpcrt0DExXyz+mHwq6sP2TJDsudN5D+6SmbFY9il8hHoLNNyahaNf8uTVT1z7cwoqcboC6w9W2/7xSZpAeS1A9qoqTxVXCn+OsHgB9d8s3gedZ8E/8frQu3yk7aJuiLCMDb9L9OijcS96UwAK1XjY3zDFE/tLfzWj2Y2I7rGsENuVyKFUG0EotUHHeN++uoHz77gB6lF/77X7spPO2BFPX9rOuHeqUzPkysDyf7UJvDy6mJBGq3Xf/QmgKM2fVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvDECVQbZ+Q26Ee1wbYWfzZHn/VERAyyXN2XSbfk0hw=;
 b=Re+w6bkNH2iE4ZWVLNQz8YHGmfwowxiBreUhiNZuS/UktfGOkXKdv5YLa40yjVYlVD9CobLKYQnGp9jAAv2dmhC5EO1va8rS/NWclGPsUovUghfuBxU1dZFN3qEyafOmiOtkuVWPtmu9tDhWoB4BSGQJvk9DjOnmakq/zURYci/fUdD198xTMkBkkES0X+K1BWuelf76m/E/OYGVR2TqSm7t0uzVvD4689RxJD0f74IO6Eg0J0vgwn0ei5Qn3waF9p++dmoYtt+Xjx3I3MlO2L6DEXlEh5Ia0cCGo3DiVKFG6LrDII4VS5lm/TTbmLsSkI7WQYyDYyDARxhGNcY7SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:39 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:38 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 06/10] iommupt/x86: Set the dirty bit only for writable PTEs
Date: Tue, 26 Aug 2025 14:26:29 -0300
Message-ID: <6-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::48) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 71ae7ace-c313-497b-be08-08dde4c5b703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1tNZKlcKQILb2R/GUugtOsSrGEfO9gZ3pnFiSwmYEj/6yZ+g2rcYP/sPyaQY?=
 =?us-ascii?Q?mkhmBNEFSsTdbSiwr78o/1kvViKFEztwsGS0vTI8lpVSmDULGoFBVSYGHrQj?=
 =?us-ascii?Q?oPcF6fa3eO+d+t2hEJcd38t5Uo+pHjUFc99ESHiSF/hE+lgRdKmAZDxJUx1U?=
 =?us-ascii?Q?FenjWj8XZVynoibLBAc5pxhCPUFdWH91wn+l4hj26TAmnk3EzG7NhT7GlYBg?=
 =?us-ascii?Q?TiIuGpimFJkA+cUtEYFo38D2RIKJwx1uWiTSJ0GfrAOObLHHx5UH3e/KWKuA?=
 =?us-ascii?Q?wUtauBA4EUTZ57+lRYfrGM9C+qjqykwBr7V2w2eCEuNlzojl80Affq+ks0Ef?=
 =?us-ascii?Q?RZlzJ5LxveYvDELFKUgeZ0Ks8nD8FLHLIOsuoDQRz4JTb4s/SF0tMH1WlrAu?=
 =?us-ascii?Q?dT1j0M0u8F/5YS+4RfGY2PP/aSSdVnfiy2NJ3OdOD2/0dcA/UWTTRBER8qVt?=
 =?us-ascii?Q?+AOmD+xIoXuon9OYgT9qEamhoBjxph3BG/o36B18oySoz6VqFB8oTBkKA0kq?=
 =?us-ascii?Q?L1s+ObHxphNGfjJWzH+0SUwDTFFGxZXbS68FY3MHn8R1RjREPZo6QpukLkdd?=
 =?us-ascii?Q?f7+k3kvL/oekgp983L4CuqA5Q3LwWKX8d6tY/fS8pBRGrwStU7hISdiELPpw?=
 =?us-ascii?Q?xfU0O2YJjG9KQKx0MtRXhEWbL4fNbYWQgjMQRtUOUVXJTMjFRumS5+DhlvFy?=
 =?us-ascii?Q?10QgzAR2iOoZf7b9IPkkpWc486C4e/Qylfl0bKc41J6gMaa5DGas7tSUOR8L?=
 =?us-ascii?Q?O3JMydmU9a8xOgsy6HT3ZGNxPq9fkgcbdGNCJO/SW+bI+f8dTH6DT5KUFS8c?=
 =?us-ascii?Q?gFm1EnVOjxHGfKX/8sXc2v/nNJdi4rQI3Czhqr4mctZ/MfzIXi3OztFKnSfG?=
 =?us-ascii?Q?qJYIcZNYIl6ZRn1VAp7nzlCCjLfhvZg2qP9XjcxicDRscapHBgA24LOm09pj?=
 =?us-ascii?Q?6Hnr6N4id2NVXnANutuoVtzvFvYFF2iCmb4QDHSNjOckiok1qN1KvqoAZE9B?=
 =?us-ascii?Q?QuuW2OsKNu8indL41RnF4QzfhqBihW+Caz9ds8DdIS5JXzJJ/1CASaFTFoIy?=
 =?us-ascii?Q?4n4keGGYJxwehD6gNo1+F6tKOCnjxaMVgANkmscdqlJPJ5vSFUVccCtANP/S?=
 =?us-ascii?Q?Ly0wiEU5VPpPKxlDB3hF80Z9N4yjwKOBth4eTRj3e5xfKItmZaP816KyXSwu?=
 =?us-ascii?Q?UwZEQX7yANHTN8pH27Z8ryho+0V/z6wBZQ0DF08rvj0JOovc1wt/99/IoKUN?=
 =?us-ascii?Q?ZjrRq4WV4Hm35olHrnsiSzDtUEBfaDqAY0TPYUjPuH6s2q6Yunan+eEhDsaC?=
 =?us-ascii?Q?BuHALvAoIRZaZbsjhX3hB7bnCJNFTeUmtBheKTFJYjZk9HVvS0VmoJlUfZ30?=
 =?us-ascii?Q?OsrjbnmscR+oNpV6578ZWhHON9QeTzyxxzyRL+abGeS8vdT3Jl+mJr71EV9W?=
 =?us-ascii?Q?OE7Hc2kzOys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SzyDD/zwJuLT19S4udejlU3YsedgZtLYUYKxBke+qJnXU0qd5HipfO+JyM2R?=
 =?us-ascii?Q?SKXmXUteo7dzkNrBG5gsfOfFIQpdkGMbHqPNu5AQKwK6Slz8EWX3I6U3gzfm?=
 =?us-ascii?Q?tzl9tb3ruVNS0NhAFq1OqDJQBwvI15wc3od/u6dj3pe83TBWdLgBU78tmQTO?=
 =?us-ascii?Q?0J1BTZQLtvS2iDsEnvkWGQ3dAnLPo/MhP4LP9yyTaTKyhDx883jlMtWLCAwH?=
 =?us-ascii?Q?d2UtDJGE9neZ27Gqg5IBUBa/BZwF1ZH1jvpFoOCVOUAACL3nXxspHS37B9yC?=
 =?us-ascii?Q?+2ytZgIOvL38MEqglAasfHZnAXx507IUZmHnwNEfYE+MLnSElfd7xqUXA8/L?=
 =?us-ascii?Q?uB7gjVOVT3fzyS60bRdo8ggk/1OuKFFmT6BR3OcmEbvd2s/N1NG9MkCuBnUi?=
 =?us-ascii?Q?v4p/VhGThiSYEy8DKOqy/Yx0FQqO+NK3mRXnAIgKCxaslKq2+RqhUOYNz9Jm?=
 =?us-ascii?Q?LrJN4ZgHPH/xbOfdHmMkCZtBf8qqadlliExFiLQ4KukN7IeoI7hxFk8TRLLj?=
 =?us-ascii?Q?bwZuyeapNbJMB1TYavnG5Qgsgw1HXEviPpRRfwiogFmIucwgJIBipvIc3LWF?=
 =?us-ascii?Q?8P/GN46h+3as5Qho3nTGrtFlsA4iVPaS++yojYg9TqpN+241rUgZllAgkvjD?=
 =?us-ascii?Q?ySB1g5+8oOy31IfeDJH0fa2OJLKLgmHU3Q8XKe4BRlZoW5DUR9Xu6TCOCNYR?=
 =?us-ascii?Q?kJjFrYqCiJGxwyino78/Z959loaFDkyJGdW5uC6IyiB0VEOUyosA2ndJCB5r?=
 =?us-ascii?Q?S8oemMyxiWgtXery+v2WTtSkLD6aXCg8x8hhx969g81d9OyAuvLQACJ6Tpei?=
 =?us-ascii?Q?n0AwzD9CqLAb0/XhxhOjCtB900WRWQxWObURkrJu+Itr8DmBlVEd57cBo5cV?=
 =?us-ascii?Q?p9xS8SJIY04k8xdiCr1J8rdRU75Rb1RnqVnQnqKzAbIcD9ZUYjTfBbUEIGDT?=
 =?us-ascii?Q?LqoJMR3rh/R6f27TOxPecI6DOYIoakLXiEHaYfxFBxhF96omXKnPhj5pEwCx?=
 =?us-ascii?Q?tDJ4EZV40WFz1zuDCY8hoqfgLUTAijMyLY5w9jLpQ2sJhYh+0Kv9hbetL7Jg?=
 =?us-ascii?Q?iYMh92YwPN0nCATE9cs1UEjsq5mQqeCpE60Ct1DTAfeuTEX6Dm9RuBYZ0b8R?=
 =?us-ascii?Q?R1jsGPno7NMkWGrg8SMTvHwVcOToj1IR1Vw8RjeEaFo3DGxsr4YHijlSXo4J?=
 =?us-ascii?Q?Ww3k0+uUoJjXqs6xfr2JLGuPVhdOzxm4FQlzmzEzqgk4a5LblnGpl2thNLUw?=
 =?us-ascii?Q?sdcC5u/u9yzpTCWbKOR2r8YYILHWalB9NWkveyigTxTHncqhfPVl+jI6OhAq?=
 =?us-ascii?Q?3P5KRHnjHYnu1d1PJNHhcT96g8C4M1IG26XkAq1vmHOow1Steyxso6xxy6UU?=
 =?us-ascii?Q?9AEBVF3IzPuACOMmCMZXwu6/KY7MIb0EhjmUp02k4vhy9EfNyM1kzTM7GZGW?=
 =?us-ascii?Q?M36sjKrl3WGTyYzJOwwC2uj0oCEmMrizm8AYwRVgyAnndllsv197YtW6RbUq?=
 =?us-ascii?Q?FT7sZ3vHdH5w9gAkCfq46ryd0D0PISYbwItWSpc+wenYFD4hjIFDMItfvvyO?=
 =?us-ascii?Q?UZSCvOwsL8RBYii6bHNPooan3jA9JX4XHrGyVre5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ae7ace-c313-497b-be08-08dde4c5b703
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:38.8468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rliLk8sLIl+RMwWKKwGXtEE7wiv/QHmJk46Ycnn6xd9cMPLYCC1ujM5+/B7CbI4g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

AMD and VTD are historically different here, adopt the VTD version of
setting the D bit only on writable PTEs as it makes more sense.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/x86_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index c01815b6229cce..60f8bd6b164b54 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -185,9 +185,9 @@ static inline int x86_64_pt_iommu_set_prot(struct pt_common *common,
 {
 	u64 pte;
 
-	pte = X86_64_FMT_U | X86_64_FMT_A | X86_64_FMT_D;
+	pte = X86_64_FMT_U | X86_64_FMT_A;
 	if (iommu_prot & IOMMU_WRITE)
-		pte |= X86_64_FMT_RW;
+		pte |= X86_64_FMT_RW | X86_64_FMT_D;
 
 	/*
 	 * Ideally we'd have an IOMMU_ENCRYPTED flag set by higher levels to
-- 
2.43.0

