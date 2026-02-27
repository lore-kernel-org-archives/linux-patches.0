Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010011.outbound.protection.outlook.com [52.101.193.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466BA2673B0;
	Fri, 27 Feb 2026 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772220632; cv=fail; b=R+kwQ1phdpe5+FcxQKPDRwNT0jxHFb4tpHq96xBBoGxsNcXpklwx5S2Ummj/V5+a3pNjx+D0cwzvpfCJBPUhk3O55tf656NIbLh3xfgpZGwRLQ+X47D51xP8+Wz7OqtpjkrzE+lAiZtMW7OvTQulTOAGXVNOcQ1z4IZUFlY/eyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772220632; c=relaxed/simple;
	bh=6u2oJ7vMws41kPrJuopD7SmDzWk8hPyYpsm6jgm+4XA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Yyvv0CxCTGimpEDM86F4hsgVIPrAHk8eWs57bCVa3DP4FWrUwT9AP23fuo9GV8fq8hCPISe+hEoa+wERCOkAEBDjLaF3xWBPooWBDxCJeEd8d6593HqW/QRgc2k/EcIw9GZgjWux8snUNTHSHp6+aigLyqd/71Z9kdhqq4laVr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hUWDfUGM; arc=fail smtp.client-ip=52.101.193.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hUWDfUGM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1oOulnr/Rw4NVh0n4r3Rous8DQAKGrlzkpCdbPSj1OsY+k1AupXcgX+jc893T971BTtrfNIBMXXtKGiZvOdhQyUIb04wRYl53mduCZ1D/ZXo2W1eIhqupVhkabgJP5oh90sS0rAnvADc7pm2TsXjXgLcemOt7illmi/GQXiv+Pd5fryxqTM8mf6l/C/4JtQOAZRwqsOUU/71frjIMtyzV9lIMUBNmaUYFVIsQ469cl0n8p3hMtkerVXpKelu9CAXxiyjYT+sZJMbHZuRraKP0DBLlPU+OCaKlh5dx5Qsbm+jujBVZnMe5iXZ76XrwhQApj/6eCWlHYmWq5iB4tgnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fF/ICA6H0DvnzO5hRCllROkbnH7iPJRHz/4ifqQaPDk=;
 b=paoHf0X3G6z42yvM5ac9TIr0AhWYhVEOY+LTHL4nnw+LZrKxBsn+EybIjRLkUFx4xYKUPs+F9dFcaet8RCErybcXdJ8ddQ2JpijqROBWm9YtchuZyrHIZ6GdNvpmPySYPqUBdHwTg9Oe27ARaIFph795L6I0qC+KanQST+/5VgiIvlwQkJ6CGdROiNPiOHOpvfVwOtn080Gby8YlwgmipRUpjNTeEoSEfafhd8AMloDIbvBJCrgXRlH+GFAKmT/t8a4k6lyM2vevew7vyUYqzVaI5EWCkH6814+Do5Q48P4+K64Yl4zFfvPrlojXYPP12ZlAwnOgWDjxru+QdoKaQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fF/ICA6H0DvnzO5hRCllROkbnH7iPJRHz/4ifqQaPDk=;
 b=hUWDfUGM1PZZpWb21Bc47bG8RBJPxtwyhESMfsNXs+UcDCA0UMN7Yni3ZlUh7D8iK8iV8PyERdIZ9LtU464mbdXyLv5sg2OI7xjL7kYw9RtGbNjpxh6beYjDdE7OTgmK8YDBKdvOZB3WbIy09/4k1hO7PYfqRH+5E7lB2jpWKtigSQIG+EgLqMlXhowSD7kOr/lEZGHl8cK4Mv2qwpNzU+fP9kYpvMx2kuAb98FfysnBt0nDTS/7wqzxpabHE6npc4NRszH1+rBy9UvV4NN1eMSYoGMudNPk8yZqaVleAAIr3Mvb1Wp0QWtmK++XLpVkZIcog3KUeDZtapgMTSh+AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA5PPF3C36BFCB5.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Fri, 27 Feb
 2026 19:30:13 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 19:30:13 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH v3 0/2] Let iommupt manage changes in page size internally
Date: Fri, 27 Feb 2026 15:30:09 -0400
Message-ID: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0106.namprd02.prod.outlook.com
 (2603:10b6:208:51::47) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA5PPF3C36BFCB5:EE_
X-MS-Office365-Filtering-Correlation-Id: 41cac96f-d7f9-40c1-2d6c-08de7636a018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	NyPm+tm56FRaUw57+EM0Ui554xOjF39K4ijvM/30P02iHmRCUxBkQL0SSxB8+mOkRaEh+XZliy1eT8nOnt12urI1XlkWSYBm7IO8j3CB5iKuLjG7jDEbiFIDX6jSQhgAEzuYIO+w3qDlnSwHuMXFEdq3yJaZDFAVeD8m/5g+jTwmGuN91WtX/feMOfE8bNTAspiqISlMfMIP9948wEinokv80o9xDUsIQjbSJr73eiGNhhJARPwVVnQL7vADx0r0prW4W9CIER5d1Nb7KHEwFOEWTpFXxKxKUszAmBA+Nzfr3fyxvSj2cG+N4aZsrI6AGEjmm755RHxgeIwR2uDQTpCmQG9/QKCxrrtCxuOWCSKCKWM8lIoxSDa6/rGz56PX4ECM8TLQNT9pcfcdKZXBS4BfuBiYhbPzWnt6TuT/7iPhUBJ/pjX1FJXhiebcTmIl3qKFJcTF/85zqOIm+QW49l9yiYfUuIqf0XMY6oC1NCIn/0NV6HRzqGtm/KcSrRWObA7LFn+rUhsuvkZBnE5RxiSyLfMnHBhbnS+PrhYhfin9LwTNoYc9JEFDuUylEgaZIn2O7iv7RVaKf88QlcczV0xHMeUj33ydQqclh2UfRfbivv/PSwlkq0RcbbB7akohofh/A6ER2ODq0sPPX1O2a6VcJA52QauIkEKA9Fx1ujuQGn65EgBCzCnI6mWHTAqW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?us06K6FexCPUHb5s0doHqJERl4fJg8ayo6oTt65AhSMJgXCUHPY0Y2ONer2t?=
 =?us-ascii?Q?JwYPIoBZ4Yyw6OZA7e5Q1aIaiakLZTSQ1luIl6OXJ8aezX5AUjiZ6fasZy+U?=
 =?us-ascii?Q?qmkSRTYKQKjAuWQ/Fkm3YqXDMYtuSzotkjv0IDsYyUG64SvAEwNuhtqu8VXN?=
 =?us-ascii?Q?RKMl2lTmbSqY7ZW3ZdsAXn7SjFNQI7SHuKY0Y5OxUsQd8H6bwLibOdzZkOGS?=
 =?us-ascii?Q?L3FDtkrvwT9zYAa4Wb40jjMoohkDyeC1P3Q/akWLdxXNsOEyLY5thHGkvXkH?=
 =?us-ascii?Q?Sge7B19zn1VnMfPOeDiRWz+HI1Gj/kzAZBSAdK9R8eqwAreKypWwHIZw9Scr?=
 =?us-ascii?Q?QNIEIp9CtcWXlF6Sv954xQiKHGK2tdB4FvUSmy0cxzMwQTwNweDr4qfhlM+k?=
 =?us-ascii?Q?SRsOGGcfK3/lk5i564PUbdoSyNASRcVtNqrlxSYgv20UTCJY0B4bmfmK2Tqp?=
 =?us-ascii?Q?35/xqwteuDC07I3e2jO3V3menT//q7+GkkNrewl+4MXpm/eUJhcGZsVrZG/8?=
 =?us-ascii?Q?Te5kjdsRYTOMtISAsP4ZJeQKIwU96YImu0JD3fxJ+GDmW+Gt12qKbzlZKgRE?=
 =?us-ascii?Q?RgQTU1JsynCfro/GpuL1R95bTVCWFSeB4TTTeJSKtqaLD0no29i4XB2KAGYq?=
 =?us-ascii?Q?SukGu6QeINRuAEjsRlFLUxHZTQrGX4hs/qoBv4k2VCOqWAOgzc/qXR22lPd1?=
 =?us-ascii?Q?18tKVi0oj/77kBLZJfPhFVUJcRpmBzpKUFVrqOTKrcQPsQ4oIu+19EBFGUSZ?=
 =?us-ascii?Q?s5V+usctWd12LqajWyBwX5abRo7m/zeLSfdbp2ZkhzFuiRZjb/U0tARIRyyd?=
 =?us-ascii?Q?GGn8Ke+jFRqa2FqqCjupFnA3erN/Fi3I54GNz8xPTinwVcQs0NoH4s0SmHaz?=
 =?us-ascii?Q?32g+ZKbZga5KPU3rtZqMK0Xc4WY5vpLaSD/YR2KM1kSdt43S+rRDDRr8PrXU?=
 =?us-ascii?Q?QmM5QpVyjwytm/E/NAA3929uwuldoxB5qWRgk47tEWPmeK/0mrYskijo258R?=
 =?us-ascii?Q?IPfhEwhxDH9W1x7n59xh5qqY8puQyVXYOEcVBDl8uJ3/6DKHrj5W0kEdSwCV?=
 =?us-ascii?Q?hhUeGCEz4P3UGoeUakXXt8OypzNfhHuYWtlhdKJ8mxUFkQZ8sN/hQaRH0x5K?=
 =?us-ascii?Q?LOeTIrOqI7EofKKN5xwMFubMRfhZwmXv9beMB0OMLPjbiXSym6myQqrJJltg?=
 =?us-ascii?Q?vtVhDVL189Y2bIex5hOXwiF79G47ox3sjsSIOSpXFXufGh+w2oc9/di/TfXR?=
 =?us-ascii?Q?krsMBnef2sbnI/lq9q2pfIxYpUDcB4MjmSeiDqAOkM9Hy8AIoRkSj5FpW4uQ?=
 =?us-ascii?Q?YxMYeX4hm+BNcPnRgZJQaKEuPylVNpu5MhFEhqEINoY2htyKrnF2gg7XFyqT?=
 =?us-ascii?Q?atRGvJIXaWd/WC1CogMhSA52yzrCBxk64h5UzQvuqKPtl+EVkw93BGXWh4dX?=
 =?us-ascii?Q?iMJ+P804K1MiSRrTnLXOZ+hyMmVEixIfnq/CFndGvErjrA2mLNkVk4we5n2m?=
 =?us-ascii?Q?oqJwwcirUfIn2oB8EyW9du6G0xaGQole/vdoGx70++kWTtLw1BvHiPYRbZ5T?=
 =?us-ascii?Q?9GqawpZJwOYONUu2OslvBxBQ+ANcdRUVVzNCF6NDeV+iXZzm+wQokIBk7ZTL?=
 =?us-ascii?Q?J5mDPU4fsC0t5eDlTlWaG1rcpMqA5nVlxMOH/eqDQLo9X786lbgAUztjty7Z?=
 =?us-ascii?Q?SwQTDxouk/8HRC0t+reSolMT/tTBDzTR3fdESqwzMFZjCG7HvK0vL0wn3b30?=
 =?us-ascii?Q?kcKulO9TGw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41cac96f-d7f9-40c1-2d6c-08de7636a018
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:30:12.4149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbsEtfH26HFRM1IhJejAF15BFkbIb/BNOzm88RMA/Ct8Q6SgJ7WSosKxh4fKaCGJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF3C36BFCB5

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

v3:
 - Rebase to v7.0-rc1
v2: https://patch.msgid.link/r/0-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com
 - Rebase to latest iommu tree
 - Adjust to the IOMMU_DEBUG_PAGEALLOC work
 - Fix missed trace calls for both map and unmap
 - Add a comment explaining the level changes
v1: https://patch.msgid.link/r/0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com

Jason Gunthorpe (2):
  iommupt: Directly call iommupt's unmap_range()
  iommupt: Avoid rewalking during map

 drivers/iommu/generic_pt/iommu_pt.h         | 162 +++++++++++---------
 drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
 drivers/iommu/generic_pt/pt_iter.h          |  22 +++
 drivers/iommu/iommu.c                       |  66 ++++++--
 include/linux/generic_pt/iommu.h            |  69 +++++++--
 include/linux/iommu.h                       |   1 +
 6 files changed, 231 insertions(+), 101 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.43.0

