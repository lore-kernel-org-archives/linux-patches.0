Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C541E4AF;
	Mon, 12 Jan 2026 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229354; cv=fail; b=J/ldf36lSmTShDjSyPnGoTcmY5wfCiAHblT5PsnnabF8FAjAGRdW5iVtebo/FTznYF8Ys97soaV1KZoAvMKYt2rtHI6vvf/nFLJHZ8BGnDsJrwT+4lrr2ylHjVPQRYXVPISOXeKNpVD6w6SsWQdMXFj0SCfD8OGnwxVmiczPNkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229354; c=relaxed/simple;
	bh=+xQmqRBCN6pUo8hx+MZdD/VRYUsN3uJaLWxZVXszE48=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nHXJ7mtbjyNrr5Z5rbCwZM0c0zhOEBE8XvjFT/JTwlOSLNmh9CjUJd7xE50n5Iy5Jf8tf9R/AR89qXd1/GyY4Xp0oJb+1HBGeEYc6QboOGE8vLv1Hnpyo8yW+AGfmlqB4+QarYja7Fc5lGktwM9zaf9inWnHRzvVakGyNIm9Vzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X03wDcvY; arc=fail smtp.client-ip=40.107.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X03wDcvY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJKiNKkvtDoTJR1vmWQQZcrcxz77BE9he/F7AwT4EvxS8iF25a1qH3XYetIAMOr/XTJZ6/SnLfbjiDE4djDyVlHj5UWESMAFqaSWotrKRubnULVwOqKZa2GDBQy3EeK6KtzpwO01jmROQ/ay1ZdQr59TI80C8GvKEuQxt8wy5X+OnHeJomXq1BkLxM3QlyXHCkbCYN6RIiIbsq1ue/VviAD1+OcOUC4QUezQFZ4aKs8dZpgc1od0dOpxtb42Fo9npOqlBnWUdeRTBsUAad8RIqSE9TLbZ/zREhddyWQB/++KbsBKfGnaYVtguUKruaiLpYiYivHjUPfuB1FLC5goGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCfrrs9synLWGpE4eZ8XQVmefyPdSVNvTRFgf82KK6o=;
 b=ZBSJ8KG2VW6TxnL3QEs73B8iTJ3LPXGPxEaDQBFG8Yl9BN/0/D1ptxj9h43U6XDqN0aoGq/PBYLfWkvgvLWNBr8z/nXt9HgACQF/s/wfoM00waZBGxh3gL+eLW51i/eZYWYRC8F4v1UacvHPRz4g+Hx0lPiEYVLJWX5gHT/8n9aqVlyWPDZWl0HG1QMaFHlKbdswPxcAMlUDqV9ajxM5m5CrYY1plbE52RbWPYmwl5d+TL78Onv3cJBBnZzL2AZjEIo1E90X0tQCkkYNl31ggdSvfgPp8gC0jTTpK84b6WeBmb5RKFR/1LTTAi0T28lIs+EaQbblf8J65rdjpJ66zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCfrrs9synLWGpE4eZ8XQVmefyPdSVNvTRFgf82KK6o=;
 b=X03wDcvYHR+u5/x1lgTzlR6hkG2K5vQuNu+d1sTayT9+vBoMmWWFoKxdWj4rxnGoISNBy7oHQ0JRPpXpMtFm6ZREf9uahJDM15YIy6epVpWrHeyLrxD/4SG7YejdxrSIslXzzzk8ydRJM9KtHUIz4LTd68ojWS/QhkG4ZXqcWB5qZgqzX2+pgv9YxuQp9tm2EaHpCWMLD2sZiosnpioMb/QhFcWZvjuvIHmRxUE3W31YvpXQoLq2toajSWG+5uV6U+g5ShjOBrPvALKgFLXvjgI0ZhINjId0H2Byjunj3rknrAa6fvnSjfrowk0hoe3878MC1+0V+zoISnZhDhYTiQ==
Received: from LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18)
 by SA3PR12MB8438.namprd12.prod.outlook.com (2603:10b6:806:2f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:09 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:05 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 14:49:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH 0/3] Let iommupt manage changes in page size internally
Date: Mon, 12 Jan 2026 10:49:01 -0400
Message-ID: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|LV8PR12MB9641:EE_|SA3PR12MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: b39cb02f-d947-45c3-55fe-08de51e9bbd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y2sPUlTdYMCZQWx7D9W0/GhP+3gAOXwd/CJViwQZwYt4SUKnscx4Rrcv305A?=
 =?us-ascii?Q?dfIgQ7uuPte4El/xyUu/+yBCeOsHrADWe7KrtOego8M3XBIs4iOWXfu593fT?=
 =?us-ascii?Q?riYGI07FmjgFR+IohCXyWvQgmkwZJsLe37sYyHW1uza52i3pooe7tIK2B47p?=
 =?us-ascii?Q?Y/AldWfW07fGONi2Ilz0jrNhvD172dCUFmGTDyHwvFTMN8luNUyMJbSTtdTC?=
 =?us-ascii?Q?AMnm2ZdkRCwwGLRiN0l1gcjYw3VaMYjZNzgIAqg7FAuLTjTGMe3PscyTBwZI?=
 =?us-ascii?Q?boDTKpyRb9etG1LuUp+2fsBeGFVwoKApbKuLBObTyQx1oy7vnqxQZ1pLVvwY?=
 =?us-ascii?Q?/fJybfiFXHGg9YAMG2soTF8PLJVvVVPyWEyrJfQISIx9djRcinz3TBR58A4g?=
 =?us-ascii?Q?3XzNF95mrFnbfolc2M9FlPfkJ3oLwTQlExQEVyMiLfsbK6pIHhHCod18EM7w?=
 =?us-ascii?Q?MR+POK8lboqP88b6GjIOg0vDfDexkDdfgLQouO4RadMxcTZ3FDW43dh082Ug?=
 =?us-ascii?Q?qAYrOpR47Igci90DuRDzr6Cd5lJbtGH3oD82wHqpfvRUi9BWG2hXP7Up2vNG?=
 =?us-ascii?Q?g7oqhX4+eWApV8CltWvckf2fHlEVLmT1vZrnbl5AWHI3bfvNZ9Rm1nUrV09E?=
 =?us-ascii?Q?rJYHizJITcfTpqOsmoBxxRtJJOtR7ZakM7jlDUxaDi+uocOgNHn6b+dRLxa6?=
 =?us-ascii?Q?DZEbC50Gahh6EWodGsn/TgRj9kgzCubiPNwEYtHvNxn8NJikcnkXTs9e+/+D?=
 =?us-ascii?Q?TRBcM2cOgxNAVOqiwUzfIsomzwJBbZcBz+gHGxi/H3m6orhoszjEor6RLpPB?=
 =?us-ascii?Q?E5lBMBxELA4Sq9QfW45dTAf7L2LsBTC5MuanvEnif5RkU5pDwgFPoRrP7cTM?=
 =?us-ascii?Q?th7b1sCaYxb0NK+LRKaO1wVLuCwcYnx0OcbszqXh+FM/SfIvtn+OIr9nDFv2?=
 =?us-ascii?Q?x9G6u7m9zkv/2aQ8by7cfPVQT/SIukwpMkzUeJdbpFy/mGuU2hNTBgVrrwUB?=
 =?us-ascii?Q?qkjBzmKMnR0eqB8c5xFEiRW585pIVIw1ND4VfUAHtUO1EjFqIA4MruFHIMwa?=
 =?us-ascii?Q?4eRSYLURs0ILM4DIkXXX6Kdw7emwerXbw2sOkqShyh+ZIdxnecXTemhIW3I/?=
 =?us-ascii?Q?tBSWk5IH7n+zz4B7O9rd+s/xyj/YwdpccAd0mCglomnjvC8M5F58u7Gg/G6v?=
 =?us-ascii?Q?9eEiEJKatOQ6oqpkTa198KXgLipdiRmT0WvUrwqvq0Y0SGwqP5lnHZ509kEp?=
 =?us-ascii?Q?sTRVmKBUQOpm3hSM5MjWT37RpBrywjfEC6FSiYWz7k224F/w7UqD+5ZZdET2?=
 =?us-ascii?Q?MaQ87OyOAlUY17fL8R/3bxjzQedMYNBNFN6RPeAS/VhlC4LGV0JtbAfywcsI?=
 =?us-ascii?Q?MPZXRQQCDSAiWYWu8ETnaFHFKFHXc14LA5n20rgVsAYMQQ4LUqHHYXwH/GzW?=
 =?us-ascii?Q?b2tT/D+Wo/HTbxZeZWBV0LWIJlcbLF6W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b7en9xu9HE9YaHhEqy7FNkw3A+h2CSKCuMvqpbQIkuy26iHjAveqU+5d0OGh?=
 =?us-ascii?Q?G4TOd+O/N3EpHDSx3x+SK5bbf8OKCeQMhkTg3+wsizdONbYzL9OBMwZuPCTM?=
 =?us-ascii?Q?zzAgd3fHRJ/cG7rsItbg4CXP0d45rqtR4RIxcI1ShV5duWZBJxKgvjldmuEH?=
 =?us-ascii?Q?Mjb1mPKJD2orCP2gtl4UrdSc/cH86hL9aphrA7Fp6vzliqCvhmYo2j7c7y49?=
 =?us-ascii?Q?Tedpq5HyJvfgfsMd3FDuMM5TCfawlcCxaskDH8bIE+8lozXXUOy2Bp2TMKsH?=
 =?us-ascii?Q?b+JMceRrBehg5xAMcbbQy0bLA59he4Jey+vrOeX9ooAacCNyj3dXVGnNuFC7?=
 =?us-ascii?Q?YUH3YCg3yBRhzRstoDOjoVNioPs4FA/KKDnvrCjTjl7viopXSl2gzMExEwjD?=
 =?us-ascii?Q?lGUc8URtRo64AMuCA1oAUW0NbpovuaEMg0CKwNsrfxsovBUVzE6khOnXcdJo?=
 =?us-ascii?Q?gsIdCLpD4+tZeJ6WXrIhGkECfZZcBrPMnvKm1qu/x7PtTnPKIr18WMM2pfIU?=
 =?us-ascii?Q?rVtka6hGGXaDXwu1R+BPO9NtgWTZCdaom7nQIigqBsMcyog/OAoTkAaq/uVJ?=
 =?us-ascii?Q?vl7ISXy6AMIpeLeuyV2jpy3FXMQ+BrbNlUWAHYkmx8xaz1uIJ7USTkknIQ0O?=
 =?us-ascii?Q?g5n2Q+7IKwIrZazYdjdAYk9PxHy7Eb9Zlpjvyy4QCRoL/UiUkVLGjDSAVCdP?=
 =?us-ascii?Q?3GHbjAbGt1+O+jdSg3JsDnHRgbgruC1b3STT//aBTejjBW9DN2+lIDc0uo/7?=
 =?us-ascii?Q?7W4waO298nZrdjxNZaju8ontHDAV48GClC6jIEGrLUoAhV4W/fppj12RglTc?=
 =?us-ascii?Q?vuRP4fxmQQDnujTCZhEC3NC3G34v3EkKGoOpC6AlBdhH3Ec+d9nwtJCLOvw5?=
 =?us-ascii?Q?sdMQE+DEEpjyMteEBFlwvhljPF7q6/z6fYAvEbQhGPfvi75YULH7Olo/BYmW?=
 =?us-ascii?Q?4PMwVtQur/dhw+H3SJwrgN1xHaHCPnC0bbMZ6rKwjDN7s4PDzycLsgdI7r+M?=
 =?us-ascii?Q?roJ3Sp3WJ5MzURwc7cqnXhwfH2rqrKocH8vP2kOElAL6rMhAlF2Th6J6Ro4m?=
 =?us-ascii?Q?ppRUg/EPWai9dgvC0IBL+HTUmPYMLOU4oWQrBZfZQsQfL9Rz7XKJcqPXt8yv?=
 =?us-ascii?Q?C/p/db0/DexRBMTg4Jp/70YXebJ2ZFnMwvPOpIf1qkpXHME5HsCiTPhfZ4BU?=
 =?us-ascii?Q?dja5qeL2/FsvZoIbQPoWGnxG/7ZdMO4xvcoAv0cz9jik/+1Vi7U0u9lE+gYD?=
 =?us-ascii?Q?/V6NkMAtj5vNWtPdJo0muEebCRPg56DqCEq9NRn6ybXjXzu8Hh85WFDMJOxH?=
 =?us-ascii?Q?rE7oTgkyHtbL0+g7WpTg9ww4JbJSg+QbjJNro0KHCTTvlZEX34rEd8On3J2n?=
 =?us-ascii?Q?ORw+uj+Fcde+gYWde3HeVzUk36+Uusp5+R+a2PtjAVnhe0m6nKN9XXRDvEfy?=
 =?us-ascii?Q?9XP94OIfWsYqKqgQatF5gHcI3p14tdp+2o9qGlDrmsE5wl8GPoYlLeD2gOt7?=
 =?us-ascii?Q?FQwGgEeP6c2cUNST3WigJnux/+mMYvG7LXlQJf1SHLVwTXODtztHymz2J/O7?=
 =?us-ascii?Q?aXIcmjmZaVPF4PGLiLKRm0XwxQ8F27ZfmQs/7yB8H0tGOkE8OX5IK0WNdx9K?=
 =?us-ascii?Q?Z/pgOhQffj6sYNi/KIGdyi+O97FwyUp9cPtxjMfS1WGZiREZlQmGgZMgMHnL?=
 =?us-ascii?Q?jzTmd427guF0gLUFbSvM3p/yIXj5Sl23/N0it+MTgUlX5786Uw5UBN1XNaFh?=
 =?us-ascii?Q?7fgvG79qVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b39cb02f-d947-45c3-55fe-08de51e9bbd1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 14:49:05.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXfkRn2+mEYGg1VDVbxxWgo/O8zv+WicnWQkUoRQlhkvncJoDzZqvOLXaFZ8yIJW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8438

Currently the core code has some helpers that use iommu_pgsize() to
fragment operations into single page-size chunks and then the driver has a
simplified single-page size implementation. This was helpful in
simplifying the driver code.

However, iommupt has a single shared implementation for all formats so we
can accept a little more complexity. Have the core code directly call
iommupt with the requested range to map/unmap and rely on it to change the
page size across the range as required.

The iommupt implementation of unmap is already fine to work like this, and
the map implementation can reset its walking paramters in-place with a
little more code.

The net result is about a 5% performance bump in the simple iommupt
map/unmap benchmarks of mapped alignment, and probably more for
unaligned/oddly sized ranges that are changing page sizes.

Introduce a iommupt_from_domain() function as a general way to convert
an iommu_domain to a struct pt_iommu if it is a iommupt based domain. I
expect to keep using this as more optimizations are introduced.

Jason Gunthorpe (3):
  iommupt: Make pt_feature() always_inline
  iommupt: Directly call iommupt's unmap_range()
  iommupt: Avoid rewalking during map

 drivers/iommu/generic_pt/iommu_pt.h         | 156 ++++++++++----------
 drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
 drivers/iommu/generic_pt/pt_defs.h          |   4 +-
 drivers/iommu/generic_pt/pt_iter.h          |  22 +++
 drivers/iommu/iommu.c                       |  43 +++++-
 include/linux/generic_pt/iommu.h            |  69 +++++++--
 include/linux/iommu.h                       |   1 +
 7 files changed, 213 insertions(+), 94 deletions(-)


base-commit: 0816b0730a71ba553b2000e7ecd6429ee61d9c2c
-- 
2.43.0

