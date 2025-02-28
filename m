Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADAD28FD;
	Fri, 28 Feb 2025 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740702014; cv=fail; b=eFCAdM2aHbS9XXBC9no5R9cHUEctbhfvq2VzhwNyw2eIx5qZu32+mTqC/5w82mERXf9MhqhllJrmp9bnKEBlZF7TqaoGZTht1/F3bXvRm+PcJwcTstO5jnpA4Ll1egEF1/A247iLBYqnBX7bltEbujYPT3NZMcteWmBmT+c7lFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740702014; c=relaxed/simple;
	bh=3SXHcqH85iC8cQkP2964kYWVta5Ch3hzhZiGcGAgTio=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UT5gy4gGIL7F7TJZQNrknkMc8xC1grIutp02E+rHwtNusPYgoPaaWl9C7ecAsKAFNIQ0vk3f9eREvTniZMexnIOxddR9KGUBzDq/I68sFbmvXq13L3vJ5NJlblgrVWuQdRAI6NX7Ja/t2XsKdrvWnAw2yaU3YhmOvo6nFXsHV0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VsbCPLQz; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VsbCPLQz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpSXAT2Fl62yhLFVyEr+PBsConqq2xJqmBK+Pp8hauLpAgqsdErsHOAAN7y1txBSb7Mhu68uQddGz5DdellzckRB8xgizeSXE2oWuCB0XOzsBqXWi2y7bxFsp3taYMdyOteU89Yj3DDyhE8uchnS58aLY/x/ultLDo3976fsWS/kb82JWkIzpjbPYsEhO91MTbw8U6YrD8vZnSPHUho++jNH9HHOLnzbroiLJqeiUh2JyO8VLNtfCtwhx1AHzXNGsidekdl4XfjH+RTZwl2I5xyWwN+hDHlsjgLv71BmI7tGfzJtxFMTfPhlL4sRl99T4EKfGVUw3aPm/VUI/xUAKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZP7fJRABYBk6c0udGfqOrTd5XwjXL/4W1BcJtyGWhLE=;
 b=QqRgBcHM3I9N0cQBFGDLOPpDxMvLM80zuhEp4XdX3D7Iukjtfyf7hJBMaunrZK0TNc0UB1jOvnB45LbQ+kjVhqrnK8vd5h2q98tQq+7sfHIgVLs9Yf6y95WC+1MifLfXsvQCVSnSpk1iqbH5f20mAKNyo9JNEW2108OiEmr9mu4Ze9NYlT+/o+rAJ0Yd3Eqrt8hT1hdepmSX76R3lfG5FDkQ8gfne9QP0wJgr/9YW7QAgb+oOCqQ5DPmZLE6bHZMgBhya+Bsj0SQpFQSrouwBl5FrVT14YFAMmDaMyKZWCHptLvWob174Sj29I9k4NxX9UtR8XjgcLJsmlofUzyA/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZP7fJRABYBk6c0udGfqOrTd5XwjXL/4W1BcJtyGWhLE=;
 b=VsbCPLQz+kTtbIroOADG+FxKU46UufiMxpJjBC6ghXMWAW7IlNif2gvU29X7801VlqTmIBvIuPlCUE7ikaHSTKfUnUmP3jzg80pKBDl79L2MJ6NOCHqR8PGlBGAkbSt0O2LCxryLWI78h9ytcsMeKqIt21cemDooxlRKgRAIXy56FtKNO5WYCh98q8V/CD1Ku7h3VscNvXpatn5NDmG0ssw29Tc7TQeRb+b8MPAHHSzaRDZlgoMVnSZDRL/5bNLR9s2FDO847djq1BOPAdVwZvz4+gAW0MzmcMhBRRE4CHcMfdbs2Yzu3KbSaPXp227f5T0dMQbj1i4XaGtHzqQo2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 00:20:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:20:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 0/5] Convert virtio-iommu to domain_alloc_paging()
Date: Thu, 27 Feb 2025 20:19:58 -0400
Message-ID: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: c79ff19e-5ff6-4dec-c488-08dd578da6f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5X+Eu2ZdHKQefOfiXR6SwrqAnvcYcU5GGUMHcT8oYlEfQ7AGPwJsz4plLaM1?=
 =?us-ascii?Q?L0FjStPm1zgmjxsmOtnFwWqRymYHgluyhiZ4pooab4ESftizYoo2fk7r05VN?=
 =?us-ascii?Q?bfDA44qHtDpUXWt2reX5ku6/qxfMzRr0wN9cUwXXTtBM2G5403+BF3f5rA1r?=
 =?us-ascii?Q?rT+BOiGeHcJABTNRa1F/BcYg7IyqieB76XdRhYvgx+BKOxSvGbFinuezn5gt?=
 =?us-ascii?Q?Va6rVHbnOs6GaUWaMFE2jGCoilc+i8lBiGeu+vzTWYps0SFjtXoELMf91KPv?=
 =?us-ascii?Q?cfymvY+4saEuz9WrIcNsnVQuoZ89+SZ6FuqCWjEdm92K9BRf5ouR7sumRPGh?=
 =?us-ascii?Q?xJH73R5JdcnTXjqxPn7m1BvqfvGtZ9t3Cl1EqQak9PVq4JGCKkLMGD78mLeU?=
 =?us-ascii?Q?tr7wglQ+f2kGLzPv11EzabuCZrxS7B8ti1LXQrkjwm/uX/Sx1v5oyGKfovn0?=
 =?us-ascii?Q?ddCJJMNjGesxpRVUgBZRzcvaOQ2lIbozgU1lq0zfZ/pw60p5CEQuAtcyA2T5?=
 =?us-ascii?Q?K9kLBGJeL4/gHim72R9+b6OUeunkdYUHVC37OWyOcK53h/exN2aKr21V3WE5?=
 =?us-ascii?Q?g7hahjcNFZ2cGem1n2tIcSxG85J3dBlpCw+iMdNQOK4qfcXtjJUHWioyOINz?=
 =?us-ascii?Q?jKBCcIZkqPS2TArbkk8F0MK6aflK49ekEC1A8igYdI+g4rc1Q36AADig5U3X?=
 =?us-ascii?Q?1VHjGTOFcFkKXJiRoXH0yX7rWz2SejzpshVcpoOgQflTrmStcL9SXOGhPjNk?=
 =?us-ascii?Q?dmtKtl4kW5m8lS4RWnzttguzIaHcY2VeOPn0cXyjhTnDkgBT92iB9IvIA6Re?=
 =?us-ascii?Q?PsykgjsOTzLd43fc/rMVzY3qJtyIk84jBrhGzZ8+UCb4sYVnpd/LQmV7g69Q?=
 =?us-ascii?Q?8iUYDtb6FN3HI6ZLfNt/cKTrfDgeNhbo3d7QpZ2qvOnQ13pEGnX//nlN3Zdl?=
 =?us-ascii?Q?uWK4/DGVwoVra3fKzb6gX09wkLwGO8H4qQP8REF5XWkXPdeA81qOKJQkFswB?=
 =?us-ascii?Q?3M3QjHyRRZcMkhRf42VXlhRZ2rg4DgqI7IXnGDjhTa9u/ExKB/HyJxi4jqUR?=
 =?us-ascii?Q?1BAboiIhMjJ3nAZrdxiwkHR6LctceAzZwP9FeRq1qUWR9HoU9M2Dq3YFKNP/?=
 =?us-ascii?Q?kU+akJrQocJwtk7RqS2/vCRINZjCbcG/pw6bciHRMEtnzIsKSPdFIg0XXNKB?=
 =?us-ascii?Q?XmgIVYGHtyarspMo0LxV7yiTPjYWJhwnt3GzpiAx+CeXYH5wIqqvzuP17wFV?=
 =?us-ascii?Q?EYBTu0Edidk9sxC9LfmGVMPpbR83QrkuO4sLWOUF5UFhjyeQBVaOE7mB0qvU?=
 =?us-ascii?Q?AuySPRHZCXPQMHE53zskMHHazKrRN2xrb4UEyAgsyzWavQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KTwBB7fgboUzkMiZW/r/H4YHt3Z6Zxzyw3qpWlgsgXh+ZgNOz5MAgjLejW66?=
 =?us-ascii?Q?YnLC+xxKschgzO5RusNmNw3IGxscTvGbTHu3dPjiYiuD+Rjxz9zZ5KVm/7nx?=
 =?us-ascii?Q?UMvnr1jvr5+7tS5hxtmffP2/FrTAHCK/OoY4jayJ+vc6Hy8YWv4jVcGA7NAo?=
 =?us-ascii?Q?coRJx4KGTbhbUkM71V9z5ahSaRcRREbJQIjL8SSOHaoSVRgOtdVy0c4YvXAj?=
 =?us-ascii?Q?ttmIreK0v3PUcMtg/pyZ1pQctB9nPrt6+AWPbB9I4vQqS8Rk7Yt6c832HKoQ?=
 =?us-ascii?Q?fjIuOyjgpG7NqoBGZLh8rJnd4RUVcbOvVP9T3/PrVi4CBxlcU7lJiui9IZkW?=
 =?us-ascii?Q?uKWkwoeMhtWz6wqASkbMgwa7D94QYhv/jGgBK93J3Q/MbNBu66sl6vJa+Lj5?=
 =?us-ascii?Q?F/Ueiv+wsXreVIATUL6hwT+8WPyA7+tFjLn6gdP2TdT25VJdvOQw4DvDAB2S?=
 =?us-ascii?Q?vzgQCeHrRX453b0QYGDTXVALHM3TJFvX/c2mGNf8xMNVDUP+REoUDjTcbw+1?=
 =?us-ascii?Q?LMjQAozDPp9DiEbOPN7oTJZ/9RUs42jA6nCW6BCh2n7Au9zRm7XjHWnHpMMZ?=
 =?us-ascii?Q?sQnIbdPvGCPkCBMNnjpEfPpa6slnsQb2Dl+B0gctA4EpLCFu4/kJswvgGVr1?=
 =?us-ascii?Q?X0we4eeAJFtS8A5Eo43WwZMB2ioeaYciv+Oty4w1lakTubpPLDuQNshu9NLG?=
 =?us-ascii?Q?S1TcJf6qB/fR3Trt0JkZY2J6a0eHyifnqukaUoRVgx2IzYasbEk9zQuQ0yM2?=
 =?us-ascii?Q?cgqjoFzOyhBJlPK0w0bptFmR7tvxNmk9gb+DEBWikqBbryKMQRAxIoKgjT9a?=
 =?us-ascii?Q?Wddu7rIK94wW6/7nt3PUvpeaR8usZDcqOUtdJkv5ctSJoOD0C8vb9jKy/j3H?=
 =?us-ascii?Q?fHP81YbPYBg3WebdKZPBnLrc3a1OplRXGi3abS9pip0NH2AGEQ3LG9N7x0Nb?=
 =?us-ascii?Q?jVmf6Aw9Kgc79Ckc7gBjUBRa7F++TJMX1hvfQfBhdBTomduQswMzrdA4btgl?=
 =?us-ascii?Q?1a86/mXa67ea/7MQq0A4Zw3QKep4XZR1xyWDHo+iJVgwLWfqvKoHvUJHxph+?=
 =?us-ascii?Q?ZA8h5u1LwxYhxxOKKpPF3BI85ZSSaknBNLQLWHZiYGMJOYSe7Qlcc2Y/odUA?=
 =?us-ascii?Q?/l8UibbddpbItCe1ze8EFfuL4LQHrVjpIAjidwlntJN4xmqwQN13S5eS9YR8?=
 =?us-ascii?Q?7M180iKKmTuzgWjfJACwuNWtLHDcd4basLvOzFna6XiVlEn5DxjbX9aAUmm3?=
 =?us-ascii?Q?uadUG090dWTWKDb9d7JbXX34djpKmEFUJ5OIgKaCADxbR4iTTCPt8PhVTyEC?=
 =?us-ascii?Q?wpHlHdSN/yvc4RhHNKOHwKMjFM5kEGziKATt9jzam5IZMlr+xl4vWcZbI5Yx?=
 =?us-ascii?Q?jsmc8JAiTLvgkHTT/LMKqifblryIwqEJmRiXriTvQW+XWlt81Rl84JI0LKQn?=
 =?us-ascii?Q?P5ZoCcSUdw/6/0vAHZYUHhHUaLYubX3rhvE6/cIyQlk/lazihoSceY716zzm?=
 =?us-ascii?Q?SeAwC+rVI3yzGeI+mKaqeTcWTcv3KTf67TZ4l2luSKmusTF50MC65jhRz+J2?=
 =?us-ascii?Q?/8OhVUkjyrsUBJ/4W4RWuX4917Z1tJTSYVv5UAEq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79ff19e-5ff6-4dec-c488-08dd578da6f8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:20:06.2099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmwL9YGjFynIeDnLqNC+xSbyP6X0ukKkFDedZ1To15os22iVCyEPV43ySuqDJoia
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

virtio-iommu and fsl_pamu are the only two drivers left that still
rely on ops.domain_alloc()

Update virtio-iommu to have a global static identity domain, implement
domain_alloc_paging(), and finalize its domain during allocation instead
of on first attach.

As virtio-iommu was the last real iommu driver using domain_alloc() update
the core code to isolate the remains to fsl_pamu.

I tested this using qemu x86 7.0.0 and 9.2.0 with a mlx5 VFIO PCI
device. The kernel behaves the same after this series.

However, there seem to be some unrelated qemu bugs. 7.0.0 does not have
working VIRTIO_IOMMU_F_BYPASS_CONFIG and neither qemu works with an
IDENTITY domain using !VIRTIO_IOMMU_F_BYPASS_CONFIG. It prints:

 qemu-system-x86_64: iommu has granularity incompatible with target AS
 qemu-system-x86_64: iommu map to non memory area 80000000
 qemu-system-x86_64: iommu map to non memory area c0000000
 qemu-system-x86_64: iommu map to non memory area e0000000
 qemu-system-x86_64: iommu map to non memory area f0000000
 qemu-system-x86_64: iommu map to non memory area f8000000
 qemu-system-x86_64: iommu map to non memory area fc000000
 qemu-system-x86_64: iommu map to non memory area fe000000
 qemu-system-x86_64: iommu map to non memory area fe800000
 qemu-system-x86_64: iommu map to non memory area 0
 qemu-system-x86_64: iommu map to non memory area fef00000
 qemu-system-x86_64: iommu map to non memory area ff000000
 qemu-system-x86_64: iommu has granularity incompatible with target AS
 qemu-system-x86_64: iommu map to non memory area 200000000
 qemu-system-x86_64: iommu map to non memory area 400000000
 qemu-system-x86_64: iommu map to non memory area 800000000
 qemu-system-x86_64: iommu map to non memory area 1000000000
 qemu-system-x86_64: iommu map to non memory area 2000000000
 qemu-system-x86_64: iommu map to non memory area 4000000000

v2:
 - Remove the viommu_ops.identity_domain = NULL in the last patch and
   re-constify the ops
 - Fix incorrect tracking in the identity domain attach
 - Christmas tree variable order and some other formatting
v1: https://patch.msgid.link/r/0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com

Cc: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (5):
  iommu/virtio: Break out bypass identity support into a global static
  iommu: Add domain_alloc_identity()
  iommu/virtio: Move to domain_alloc_paging()
  iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
  iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU

 drivers/iommu/iommu-sva.c    |  15 ++-
 drivers/iommu/iommu.c        |  16 +--
 drivers/iommu/virtio-iommu.c | 197 ++++++++++++++++++++---------------
 include/linux/iommu.h        |  10 +-
 4 files changed, 136 insertions(+), 102 deletions(-)


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.43.0

