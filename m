Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E10212B2D;
	Fri, 10 Jan 2025 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526914; cv=fail; b=i/V+JFihH+A58xaGnQDdif/ZTngyRxc+S2siiAe1RwAuDsGrUOu5n5GtID+D5Wpe33RtCU+Fk9P3elI5/eVaWxnUg/U57kUa2KBMVS6Z8R+RDGHJtQuUNZVOHOmDdr6me/ul6zYVhvZmyOBZbqp33wIw/FD8doT6neSUnt4DfN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526914; c=relaxed/simple;
	bh=WOjwllZMLotzEN/VGlCFGKm0wv+bIbBVjwfmj8jzI9o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Hp1MK2hOw8dc6UvbbiP/R1u9BUzfKnZ/2tVyCwpfUkXed530jb+QU/MBXyvcygxBtiuoZV5l3m3uL7EuAd/vAR5dZuzMJmK0FoYKoWtVUDbLXFTHzCRGETXykEsWrkwuq2QQcGo6Vc8CRKzSeRfh2glBKWvA2iZUC9ZAFrjileM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YG17gF7M; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YG17gF7M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPZ/MmcCD/nmleMagvwH6V95iLljXrm99x4K1x2RlnECJLthj4U6YdrNyVvcNUWe3LTY7rnakKJd8mBMUJNTUa/ItvsnvAZUR+lFsjfpbYY3cGAaAQYv08uyBjLWvvG5Pv3AzBJJfosUYGw50ul/vKdRIfsb8rY7U9sIWmE9twf88e4grdnT8Xfh4ek5J/Q6HJCBwZi0kdseyV79Z//4XMP5yk8tL4V8ZXPdgstfKz1vuxclzGxmmxAyNh9OGU4FqfkE60v9XebLc5rfhPCWHy5wqCRNcsHyNcATrWcjV1ZaXwdLQnCsw9eyYrIAzsfsIlLTSedF46ZfYQ30D8J/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k16jbWypqp7zeLW0/wRdPUPw9BFEAxIi2LerM94mL6w=;
 b=jJRzLPFX083vSedcAoPAZwVbrRFnwV17MCIvvuIYih7QpmjUPWpIPsx7pruvtqwQLKaqwoEjMv9SGo3aBUZAQs4jGSx3daQXgEazOXmQ0fS8QVqM7ofOdYjl6RC9vtt95K100rglSI546l3xv9QH8WxY7HhweFvmNm24Hv2kWIMLONOhVGm8j9k2RKhIzI6kSU61b4HM5eD5jaq85jWuqwHuQgBli8qyaF0bcmde9daQmWeDOW1nzdi3rdDTAp30FZwTMEsCb0nNRajY4KpsNU6sjlZn23Ieh3MAmZqywMh0LBtQvR5foJZZPdFi6NijfASjzlQtSboWyxGmI97vCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k16jbWypqp7zeLW0/wRdPUPw9BFEAxIi2LerM94mL6w=;
 b=YG17gF7MSCaGS85Eyt9xL3hHsOJ5p2iUU+FuRpEhiUUGWeZENMB8Md+aQKkVMBuMPSMlNXYGDM3FYTvnoGVwxOM+z+qM66+ShxXP1xbyYRACy6DsFwDEu6rxg62Nm7BTj0HSG5zos2xtnJI/d43J4ryUmzLnr/5XwrxTUyrIJokWQ0LxAyd/AdOPEjpE8F9dq2BGqfYQJcMJPH5WrR2vtzFU9bpGgNfKmE3mqGzKVlCp1GlU9TO8cOh20eVhjbcQsBlQK1NtNQeVprxwXNBe/Y0MeLhl251dSQLCM5mZHkH9aoJ6LKLxfzNjH8QjQlA4gTk7dOENjBLaX+XrTMH17A==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 MN6PR12MB8515.namprd12.prod.outlook.com (2603:10b6:208:470::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 16:35:10 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 0/7] iommu/amd: Cleanup some of the domain_alloc_paging path
Date: Fri, 10 Jan 2025 12:34:58 -0400
Message-ID: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0906.namprd03.prod.outlook.com
 (2603:10b6:408:107::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|MN6PR12MB8515:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d3c0a9-c94d-4f13-0100-08dd3194be6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ikMep6oe1CPSDJIhuMh5lrEIgYXGmYEckKLFPhntQP4xUiYEjKacWE8U8fkW?=
 =?us-ascii?Q?oEWQswidnCM1L38uycpFc2HxeqzLLFE5L21uCRbXFDe8LUuku4P858wh8ZQ6?=
 =?us-ascii?Q?43i+2ypGnlIYD5e8BLao33Y4Hd+9TXUoD7Ocj+SvwD2QrXyw6KaJOmqu8VzT?=
 =?us-ascii?Q?t74BFp71JJExleQ5PDhVaH7XbzxFtCxQ5lM2yCcuQKFWU9IHID3nARDmvpKe?=
 =?us-ascii?Q?uZzcFOZZ0NnQIcneGXBFH+TZpb4nh6ojIIt+8FtFU/V8HyvpAF+OwMt0j9bs?=
 =?us-ascii?Q?D9trt7JiNj/2FF7HnJzT7Y0+pCI1wnqsEGt4oOYxbo2FuuoU7RZsDZudnoRg?=
 =?us-ascii?Q?1hz7FxV+E/1mAGzqE/atf3gWxLinDWazpp7bU78nAi8R5ESB4UOp2TT6/WO8?=
 =?us-ascii?Q?av9hBlY6En5WBD2aQxtztuIoP49t1HZsZFSUqaU1O9ONUPWfZ/g4zp34f/Am?=
 =?us-ascii?Q?QEuq2eQ+Qu4C9EYYgVawciLKUasPJLQvlDoyAfK7nu0ZX25+tcY83oVE8bCH?=
 =?us-ascii?Q?2YE0kxRoaK3ZhkSruML9HQ/xw2gArf9Qr97srcaDeLngRmWlP9JaJ8rfnxmP?=
 =?us-ascii?Q?lS4Y6ShGNqd99oE5kYgZpC8CrEE75Vwf9lOM3s8le9bsfCMHKNLSBR1j8973?=
 =?us-ascii?Q?3eKGbys4siqta7eAtdSev0hr6rNH4Z4pVdStLkpS847WdjQkXqQQmYCuUlxe?=
 =?us-ascii?Q?P7zW7FBW1oXYHC3rM21Gh7jQaoli6/hGPdT01zco9gBAgaZlrD60X+i8asZB?=
 =?us-ascii?Q?7MIkZ4pKyO0CO9h4k0vSWOAee8rSGxnsVcVxC8JuPe5v7YznqDScNpZZ+9/l?=
 =?us-ascii?Q?zCeVHMHL3pRh0n80aJCXe1vWGrzUCJwuL08Q1MStBEqd1lUJt+VW1g15x+fS?=
 =?us-ascii?Q?2HnwxkaW5b5Bis4UP7ByWmDBE0NyoQ+ttpxtGZH0ePCcihV33+Id1aseGFxe?=
 =?us-ascii?Q?zOAiUAfkkbw9alg0LZZJaovMg13ceiyS6Cq89KoUU4lSoMzKym02O5bhjvBW?=
 =?us-ascii?Q?5lcUtn+uonk50ZqzH3+8B/HnypjC4VXpdfw5W2PdbykI82r3RUKAc2QLVAf1?=
 =?us-ascii?Q?ARJYBBX3XVdQ0eY9sAzJup7qWFvmyYF/ckf3t5RbEhTXqm1fYK+hYo024Gy/?=
 =?us-ascii?Q?PM5/p1Sp1bG/XmGCddG+laZV3vXA0MjdKPNcdyLY/McOLTCXMP3BDLpXq6yV?=
 =?us-ascii?Q?fDSNgG5avOD9BsANq8qDmrtTMiGCR4IdjK7hZIh3Z0J6GBiPMNSKEzt3jhih?=
 =?us-ascii?Q?D1b0xrFKDbUn8dylLvKu19O36IZGDh81JZUveIJHQHCiJaB7zXo+Xz+Dr5M7?=
 =?us-ascii?Q?m0ERGpQaoElobEhCM2hWB3ASSE/gB5Cu4CVjpgw3xSag5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IY6yftYAkfdIeNwppOaT7bXMQhtyxkJZyGces7RIvPODjAQJdndm2CpzbLMU?=
 =?us-ascii?Q?Ep7l8+0gLiq4YV0N1jVXKIra6AVDwQQ1WGecnmrfHswLEdtL9Iaaht5wFNu3?=
 =?us-ascii?Q?lZyyc+RYdKZC+bAjT9MkVgz8wfPra8qykt8fGV8m8Mpo7RxEKvpDTxL4E4WP?=
 =?us-ascii?Q?P422ycrlNzrHXHxMUsaNX9ZNwXHhumnb4yyc9FgJ+62EJJYnmRBwJgXy3cow?=
 =?us-ascii?Q?6QEH5d1LEl0QohP1b5j+nVLItEC0NiJUup2rVLW6hHH/ZSknS5i2AxdFraEr?=
 =?us-ascii?Q?n/MC+Xqj2kiytyRtxmtZf2Bdqi8geSGN5cc4OkNLYwKCgjhVREr6/dSr8KQ0?=
 =?us-ascii?Q?J/0LIpAXSuMVbVUHkyW6dzBvBbV1pcodu6VMGzmVu7ogonxW5sm/AQN1Pi08?=
 =?us-ascii?Q?tl4+Ay3Z9MkacqA7jN7ES0B2Uu09Ie8AFedlR++rZQH29TVnJ2mQ/P5O5XxT?=
 =?us-ascii?Q?F5zathDxiKh/SeckcC3I+Nm17+n3ihdT42jP/CN12qCV2gaJ+0q89FXS8ZxT?=
 =?us-ascii?Q?aDui8DQXPPoB7yVjUo0kKVRZ62Idu8DIEOd9HnmUyjiBHh4xsEI7e9ZxH6Sy?=
 =?us-ascii?Q?sojdlcFrMgwoLiOjI5ndPI47WbNlY6skXMsHspuorscii8eDZtgs/fQMGy7N?=
 =?us-ascii?Q?07nWRJcnxfr7nbOX2vcRSAAzYG5GAcJ5LsWaKlGHAoKrFGYBXJ6AzXVSPcKI?=
 =?us-ascii?Q?EzQmlqRxGcQaBcj2yVBvG8mk78IwUcAZKn8okwRHtx2HNA+RT+mFa7/aix2B?=
 =?us-ascii?Q?C3zpN1uaT68MjrpYVkWLoULUMdtYAyPwukH3K88iwTnFV89DJWiTIZRAk+lB?=
 =?us-ascii?Q?2WwjSZyJ1o0EwzwsSRRdqYzMj8gYRionEbFmo9e9b67n8+5DLuFosPj+5YfW?=
 =?us-ascii?Q?uYaxFgBvn2evhHcRQ3VWj50ZOdln5aQ3RKzTBUgPREjvC/+kKALoReZIsGEh?=
 =?us-ascii?Q?sQ8IZ981cw8kM3B+QnYD44my3D0JEwZ47yfS/wi9iwPsDME7p8aeQdL2bDU3?=
 =?us-ascii?Q?6RfUmYyMW4T89Q8PoOyagqhNsxhOoHalhTYs3f45ZGH9beu0Sny9S092hOBI?=
 =?us-ascii?Q?rqPfBSierxrSZwFdioKkEt/5ykSUg1aiwrnQH+23pq6tmLD7JDvyFHci9YYI?=
 =?us-ascii?Q?E2AKcVDDaVd0kzEc1yxnkBG8STBo+5WnD/ZhTKnChzGCip+HNT25jrct9ZY7?=
 =?us-ascii?Q?TrVNl26FO3AraH2QAWWUUVcJdvJ14hla4NcAa2GNJItvGgbk5O+3V0Hl1YqQ?=
 =?us-ascii?Q?GGM2/m155ygrXZHu3MT1M3ilFK4lVBk25/i2yNhiANt6EzQQF4vmEEGOYyDz?=
 =?us-ascii?Q?UxZxGCGSz3jZkkx7A2NrK0XyWd4wTFD6KO4qncfxMatVkKQGIAxiBlSQjOQf?=
 =?us-ascii?Q?yVL+RpP2BEn5k0zooC1y4Ry2axQeYKautHmwDhqRJsOyuN/Gpr7bDuv9OzxW?=
 =?us-ascii?Q?TMQSFVuRVpeF3+gWLaOviHgSiGUr6LASl8CoBQyzR17fFqehLjwiSmWv65Oj?=
 =?us-ascii?Q?AduOi9vfSfbhC+molh5KkuUg1B5li8pt0oQxzUyAEZMyLdtzPk9NCOjoJ0o9?=
 =?us-ascii?Q?I1klOKqDsDj7ucTk9Xm5bR+zOyvVbqDzhTjhK7pP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d3c0a9-c94d-4f13-0100-08dd3194be6c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:07.7378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8og2cmuPvVhrOMmpsjp0GiO8A/Wqodd0QgR2vN46Ud0aitt8p8jISygdTOq7fSJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8515

This is a small collection of cleanups
 - Remove amd_iommu_domain_update() (dead code)
 - Remove domain_alloc()
 - Remove now obsolete NULL checks
 - Remove obsolete domain types in the domain_alloc_paging_flags() flow
 - Use PD_MODE consistently instead of mixing with io_pgtable stuff

v2:
 - Remove bitmasking from switch in amd_iommu_domain_alloc_paging_flags()
 - Update commit messages with comments
v1: https://patch.msgid.link/r/0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com

Alejandro Jimenez (1):
  iommu/amd: Remove unused amd_iommu_domain_update()

Jason Gunthorpe (6):
  iommu/amd: Remove domain_alloc()
  iommu/amd: Remove dev == NULL checks
  iommu/amd: Remove type argument from do_iommu_domain_alloc() and
    related
  iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mode
  iommu/amd: Move the nid to pdom_setup_pgtable()
  iommu/amd: Fully decode all combinations of alloc_paging_flags

 drivers/iommu/amd/amd_iommu.h |   5 +-
 drivers/iommu/amd/init.c      |  14 ++--
 drivers/iommu/amd/iommu.c     | 144 ++++++++++------------------------
 drivers/iommu/amd/pasid.c     |   3 +-
 4 files changed, 54 insertions(+), 112 deletions(-)


base-commit: 40a9e0c5db5f23103fc3ebc8f27fe665b057bceb
-- 
2.43.0

