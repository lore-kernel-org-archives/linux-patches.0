Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE728C03A;
	Mon, 30 Jun 2025 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295857; cv=fail; b=o/R8wPPbG1kWXXsi/YXeGsUYKuftqDujHS6YNvuJXaYA/i/zydkrsrzJgm7Xy23FsUG05N7Itoemw40vCc33m6m4+yE6uPcj0oriRItGJyIpXjEy3ybD+xDE4S4UNL85EW+2M0GeFKFWWZ+3Uv/4Tay8ic9D3pqHbYkhWOlAQdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295857; c=relaxed/simple;
	bh=QA5DNzfIgepE9evOqCZzQTgc2tC0h7bW8bkTPWwj/3w=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AaRND/YcQp0hFFNt+VSZbQMYwQ62v2Os8vAXWJKE0oIQ3G6C2pS/utRwV4rC4ldmlqx+guCeTvv169waXOfHnI6bY4aNAeZZuLGhPP2S9tQbA3oSquT5MaIMN0Soltm03z2A2s0DgCxNHAQVOz1EbRa/V1Dv6gApMviegCWpLN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h00vYPfi; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h00vYPfi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vC7SXt+AafdYVhienusmywd38gCCxFj33+KmfVx8l082MDkG7hv3I3xkFW0J2pOJS/lTujRC/4hXuh8ytdRrXkioK68AiO37Jk991wITfLGIstodRRIE8AFNyTmtXXkXniTsJ3Yk14BuLWp5uGRdcqw0HdXTPKkW/eLHGcYLB1TwLBRIhEcmADmw2T20g7oHvKnKs+6mwJbPwXj1XdATjL6GUXTLhbcenG5v6IjrHyqGkL1Qz4Cj3D9IdBwOAhrh9PQFf7dgTmwPapLFLBSqeCv83iTh2ZsNNJZhpb4WAId/t+pAWWCw9PQ7MzgUMXpgZClweWo4vUaijejUkzvgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWSbyMA44KnTRwTGTT5NV8uuywQJGek4aTplXfl6wgA=;
 b=BqQvwKP1k8Wi3WgAV6QDZ2BNeSHuD+cNzyAT/UVs1yW7Qx8A46JlCTMsI1xinFlgytXRVub3RSTRDnKkhXXuVdLAyrIZ2dQlN8agSM2jIFBz2BGA47cygVwhlOLnmul60/RfmGjuc9kWqioSJVJqr7cBHp5lsiL0oObmX4GbGMULV+HAPiOKUTzFsYP2o+O3JIcbCSBM+4NwUe87mS3SBN7JX2sQCsIjkESBK7hSREOj5g/Z+2vn4K/eEksInjgwDqKnZNdl7iOT7HB7jQGznzLuoXyIrcaX5EOfkNfaZ0FfIHE6JR3qO9/hdzKMWkxFElcd/c6yItkHiVQqN6Ye/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWSbyMA44KnTRwTGTT5NV8uuywQJGek4aTplXfl6wgA=;
 b=h00vYPfivQJkdm5xiaaQXiQzGaOx19ww22EdohC9fcDJWKveWlLzPpEwxsuAodgjqiHtUPFszA7BZTX1WQI0R5N1qyLsxVx0cdYph6zHpx7fqeRgB8sdgvfWK7nFJS/nNYY9zFs/ageAM55yxex9MQN6UTVuLUfz8fC/plnxKbrDSEPAcyVmPYVmsasmMq+T8XmonVBETG851RBHE/pAURX5WtHBrOvqK34NdWqMNl1evUqJO/yDvKSsluHRr3ZsigVG9WQ30KlkAhqEyI40518dUsyu18wmJZLyv+rPWmgi0DzjE3zX/wODpaHR6JvCcxzmkp49hSvmZcE2DUXEUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 0/7] Reorganize Intel VT-D to be ready for iommupt
Date: Mon, 30 Jun 2025 12:03:50 -0300
Message-ID: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: a589adda-9cf3-461e-1a1d-08ddb7e75794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Ne6nZhi0EnyHVOQzaDlLfdhKtULvu4Hc4rn/yZM8jJG79QAGTYAED8z3DnF?=
 =?us-ascii?Q?Z7uNf/nlcDAkmrLzYzS8qTwFu+x694Um2g6HmMIdIy0QnDDCFRIfEL1fTD4a?=
 =?us-ascii?Q?3/7mxEa6tBeS/lsdZLhrBnqiAq5gjRf3dlCkxQgnXx4Vc6nwXuNnm6gT2R8V?=
 =?us-ascii?Q?ec89rESlgR+cSHq+KvLYYnSrpCi0wvl2UDnaIX1SJ9ddKcsm/bernckow0js?=
 =?us-ascii?Q?ywKw3vPmg9yuS4gNPy1S1GhlXMaYQKzSSLXu93uJgSpdq8rjSiqVzK1HFdjt?=
 =?us-ascii?Q?Bj1fXAZN8cI1RoGpby+bXSX7HWZhLXiihA+zWQHeGI5NBp1iP9L40GIDQGA+?=
 =?us-ascii?Q?v+K6eTaTRvJU9P25/8cAFAFNAK9zR115vE6KX31FoN8/RG/mXO+nFv+ib6Wj?=
 =?us-ascii?Q?iw642Mu4KsF3hjRv0GEIH/OSk0G1g14CbCCTuTRRs21zh6znxibfHiwO8FHH?=
 =?us-ascii?Q?hvAre3SQ2bQzbQVBVhebt5+Y+k05ix0MA5FI4OOanAa86vAuLNbB829DHhIh?=
 =?us-ascii?Q?h+ZyliEW3E+idWm7X8zHtF7t2wfnzF6Io606dD3OfqNc6dROfk3IzyqpDVtg?=
 =?us-ascii?Q?hQ7GRgB6KCxrcSGSIX6/a2qqYVvVz2Yg46Ikl7y0om5rTlfSkTCo2bD6VCRw?=
 =?us-ascii?Q?bfJYMRNuPJjvLcxdY3m+JUjrD85em2XulnMLA6jbukK8f9Z6PmlglJgKy+Bj?=
 =?us-ascii?Q?ZDuzfu4vxeppBXcxSmZZXCQ33jHd+OKXcdu329K4UrioKixeHrkCIEUGq/F7?=
 =?us-ascii?Q?CzaXJpAa3q0hYUNnWuohPRbel7PMlGuaoStLK5AByBttpE1zZKYMMEd493fl?=
 =?us-ascii?Q?Dmbz+zLrPsZQS27u8go+J0qUnQEUclpcepSzewLM4WWTGaLKkzaOhpGgg31t?=
 =?us-ascii?Q?hDvAIOEykZ6WuEg6HHKCzfjHjWAblQRNw8hlnXZw/YPHdOdT6YJOkIQYIByn?=
 =?us-ascii?Q?H12eYMTZiIEEf2mZ7cgp2wkSoW23hfg0jf/lulVaiJWz7pCAlgCXjatBJZbS?=
 =?us-ascii?Q?aXbse3ADxB7FUkHz/D/LYV7u3/EB10nsgnEhDKI6FIwn2T5Jurp6AFC7s+/L?=
 =?us-ascii?Q?lrFyrDgThLD0LCgwfGBIMQgadprWPkRya3kWGsfJrhsV4pez7/bCuCGZufdH?=
 =?us-ascii?Q?m1SIGOOglF0sSHF6exvlgvmwSHKsO08azk05Oi5lDf2E6fSU4M41Vebqd/So?=
 =?us-ascii?Q?+LCl0YKMY0WVbP6JOgc2XfspCnTXnsx4YhaOocB+nXjQIEwqLUb7waDnZV3K?=
 =?us-ascii?Q?1ZWLGuaCSAkWNbXpDt4O74g3U2oHcwfwmedOS+lEaTh4G2ezRWMUsezgKsMu?=
 =?us-ascii?Q?W4LhxuNSqHOxAui0ptVnYzOg+awwDoHnt4dilo7hPMhMHPycMm4tPaLkm78Z?=
 =?us-ascii?Q?kNZObwxxN/I22iAHIwf+PkJXSPIr4ANmDL02b1J3qu4K4nC6zSZ3E/dJolZy?=
 =?us-ascii?Q?fj3Exu9FRd8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OSSyNl0OgbSIQ/we98S4He5lU+WxdKnM2d9jHWeNjsU3YQ9TjLVUJ9qWQGMU?=
 =?us-ascii?Q?DoS95y6/OoSL/Kje5fadHwUP3eYGVT3ghNQ0v7V0WIDmHlbyw9ckc1fvMjYb?=
 =?us-ascii?Q?5nmw4rRc6eG+d4c5JLUS/kUJglM/c2tiFxlBGeKawkJeHmhRTIyW5yEA2Mah?=
 =?us-ascii?Q?VtsB0U2VLh9YvjzxBz7eQCaudo8SbzHUl/Vv5/v+C7Y/whEJsXMn+FrymCwH?=
 =?us-ascii?Q?dKaICOMBnA3Zz+qk9Oy3svJhIHMOeGQ+ypRtCG63HtwFH5DDzB9kXizgUxDE?=
 =?us-ascii?Q?QVOpWk4LiqW32SdG5R/2EBusezQOpDUzKfnqKfBO8AZB6NZ1p+aKHBX+8XBa?=
 =?us-ascii?Q?DleWy4FXLtTmNJpgQDZqmYTZBj2c7K83XskaNswV5dRSmr3Ku1nju9anUA0N?=
 =?us-ascii?Q?xvNzHXPRBGJAFyCbIel/qDB63IhS08qlnKgwsf7MhL3w5zBZt/0j4Ra2v+6F?=
 =?us-ascii?Q?qJxysNXTRXOrPCISxpJ171BbhAv/aT6nmULGONaF41ooPHHHM03JZ5eann4t?=
 =?us-ascii?Q?jNkS6b4lh++Hc4ZqS3i12MEAzOsZoqB1yruGpLtDCC8tQH1f8LedxqnHfpF6?=
 =?us-ascii?Q?9Fv+8+TcIUOfg7L9jIWhkxfUkS33V4+LiTYb2/q3pZyaOJdaHcF+74m8kFOR?=
 =?us-ascii?Q?fXBCyXhd2i7/WV2I/kVbEhYOWDlOO1J0mIBs+eBeo4KStwsnuKRMjGlr7XYp?=
 =?us-ascii?Q?1GcoWtYPKTKX/8UiHtq/ct75I+YmjSvVf0RZoo/ZhtPXbWqPXl/4J0iWHXJO?=
 =?us-ascii?Q?xskyLw7NyBu3j/pM2oo1bPGWDA6aQ9RYnC3XYMuanAK0A1gjPSE/s4HGoD0W?=
 =?us-ascii?Q?QKs1HaWqGZxcUGJ0gNr8aU703rg2YJtkgJwzR6VQLhKbVLtEzf6ohQFFyW/m?=
 =?us-ascii?Q?0B/K7rn9tXw8jtjE2sfBlzmuU8izugsiNYFtEbYoeX/9gjg3kCNzvYCf2Xy4?=
 =?us-ascii?Q?bv5X9zXYHAoLZDqSOt/3tyc0KfbGxZ4+54z8AIsJfHg3yDZ8/J8KZWR9gRS8?=
 =?us-ascii?Q?+HUcCr75ksno+kF3g2RHf4Dmn0jZruRYN/wCwt8Cz1c5GEJ1fcxnE6fphNK5?=
 =?us-ascii?Q?ZOHKYqBveSnXeQiCxVsqKSXlRAfEcrf+rBXu28NOz6/sNXN/MhyUpnEeuGwr?=
 =?us-ascii?Q?0x1gJcY+OiBYYQg3jA/EZnoFuLTqOrLXQ/1ckjCgxKVsGloKLzRW2H48cY4o?=
 =?us-ascii?Q?kc50cJowJ6FXqm11d4gwMGSTrBObljvTkY/5zO5rwVKlWr0v981UEwNMRwHk?=
 =?us-ascii?Q?QSmEePuWY2CP3imUdXUaiKHIe7NPQtR1sp0szbZUeclBzMXZqZWMKc+TIwhK?=
 =?us-ascii?Q?5t14KolDNOtQ3t6r3T0iDZ/3Mqd4t6wYu27yT3iKXJgKXvkDqm+s5v4CPHSX?=
 =?us-ascii?Q?JLtX9L5vZS7+HBdaqT2huZZtZiYqVFt5TT6/QPL4YVySEgGDTtx3CuE015la?=
 =?us-ascii?Q?nkX6oa8KbGbyz+CemgfZTK0Pyy7ay8xfKTyKPWPLc3o8YQ45JQx6BsQLpRdY?=
 =?us-ascii?Q?OpVBbzmCBgEmHzRfFKs+q3rnJvuJbi8IP+VBBtD/VWRngg+ekKYihZwKkMTy?=
 =?us-ascii?Q?Iw7ATI0BLfWLbViP9U/BBBr4frmey87G8j8xYk6i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a589adda-9cf3-461e-1a1d-08ddb7e75794
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:03:59.5416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1UzbnYTq6VxCn3OWZqd7RQxinTB5IqG52bMmuPiXY5x32ptAh7JrrBHk5kL3s8S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

This is similar to a series I sent for AMD.

Lightly reorganize some of the page table related code so there is greater
isolation between the first and second stage logic. iommupt will introduce
distinct types and code flows for first and second stages, having them all
combined together is difficult.

Splitting actually makes things generally more understandable anyhow as
they do share only a little code. Most of the registers and logic are in
fact different. That was being obscured by small helper functions that
combine the first and second stage information.

This would replace some of the patches recently sent by Wei.

The full branch including the iommpt conversion is here:

    https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd

v3:
 - Add intel_domain_is_fs/ss_paging() as wrappers around the ops check
 - Set force_snooping for the ss as well
v2: https://patch.msgid.link/r/0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com
 - Fix intel_pasid_replace_first_level() signature
 - Exit on all the WARN_ON's in intel_iommu_domain_free()
 - Update comments and commit messages
v1: https://patch.msgid.link/r/0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com

Jason Gunthorpe (7):
  iommu/vt-d: Lift the __pa to
    domain_setup_first_level/intel_svm_set_dev_pasid()
  iommu/vt-d: Fold domain_exit() into intel_iommu_domain_free()
  iommu/vt-d: Do not wipe out the page table NID when devices detach
  iommu/vt-d: Split intel_iommu_domain_alloc_paging_flags()
  iommu/vt-d: Create unique domain ops for each stage
  iommu/vt-d: Split intel_iommu_enforce_cache_coherency()
  iommu/vt-d: Split paging_domain_compatible()

 drivers/iommu/intel/cache.c  |   5 +-
 drivers/iommu/intel/iommu.c  | 327 +++++++++++++++++++++--------------
 drivers/iommu/intel/iommu.h  |  19 +-
 drivers/iommu/intel/nested.c |   4 +-
 drivers/iommu/intel/pasid.c  |  17 +-
 drivers/iommu/intel/pasid.h  |  11 +-
 drivers/iommu/intel/svm.c    |   3 +-
 7 files changed, 235 insertions(+), 151 deletions(-)


base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
-- 
2.43.0

