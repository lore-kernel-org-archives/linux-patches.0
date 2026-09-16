Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012042.outbound.protection.outlook.com [40.107.200.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B784F7999
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602605; cv=fail; b=RIoupSjqaZ58qupR1U2l0sHYCwITA4YXJctYlnog7zU8UDKwuwFUWrMCeeILKV17dtyEVg27YZifP9nkI2wkFSm6iFwETFTvxCJNSMotQwu8Ens7KKuOYOzBlc8KxTDEeOulGyAenculZnlGRobGFd61eq4xAgr8CXwOB+ThbKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602605; c=relaxed/simple;
	bh=UfcYrdEEjTPjgAV0jp+B5djlFBDLYq88639IPHoM4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=t6Cix6v+csTJAYzRrCFDApF/H+wH2HFdWwN8PnWgZ1dBOBOztL1/oaLtqjtxRza/XHiKSuOJvVpxzhb9U8e8Kw/AjfcIPx2GhrAJ2ckrGNwhqvoK6d12sJqBNw9ET97+ITUeKgjbpxJS1XD9ae2lLDkUjUmlW+a7EOmp7ghMFWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k+epJGbN; arc=fail smtp.client-ip=40.107.200.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k+epJGbN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uvbFAxXnoAxhXwR04NCV6205TMj/S1GKDCTy7t9NOA1zubkPFoonKDjVaMeq/1+Htt2U2oDdZsrbBTy7orPVI9EtNDs1RfiySNYMV7uZhm+0SQu4u9b+3wk6J5ewo+SxDw4dNsm5r5b2qXcbTrs+9xuq/5fJqUevCr7nYjy1nK7p7IiZrvXY9AxwoxZ5KEoF8wRNni2zvtNE3CrCHWS3og/odkoaegTWmLf8iyYpcqNw9Z80vDoWbLyh7P7sWreOmnmdHnTvZ/qmXeRXCCFnGHCe/+yMBGovPao2QTlnBoIt68NlXtuG+cb4t9bnnwNAmZ+94Egidb7vJT9YfOtOrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4ELZApdgCYwKoE9nuLd68Yv2tEHsnuFqFQ/QV/1sV4=;
 b=Wxtj0qy7YU43pazdNPDnaiZDuv5UE9y3rBOI8S6ThO+3KooZhmnJsHz6EFoCfzGGEQHQN5YUIRvNBvVtXws8tbiC3NLOrh/I08+xvKfbRV0wnBblDwyezxW51uMyVpq31CvT/iF8v+3mPasF56Z7WfjCOSdvcL2sy7I4SbphymqYd1GMzPOPZOmDgFX1vns0S88a6MoCTvcUXiJRWQ0fxOT4/Ddzs9MQWSw/hJ6vr+HmrVMPLQD4sxl14UM2WiS3SYBiyT5Z++Rb+KqqN4bpmiHsoL1ZsII3ZoUgiD/SJsvQ8DeccbFfU1YHqKK60rKoN4lJIyhSwPb13HpfUq9cQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4ELZApdgCYwKoE9nuLd68Yv2tEHsnuFqFQ/QV/1sV4=;
 b=k+epJGbNZLUwmeEE/XGGtVIfuje+0JfcASsioJ0gLPnddy9mXEQJiAkCeFjlyCGd/XnZpNZTaHEQiJr9sj2x1hX/Hlsmx2c/DaVwTAxvvSzZnj5b63dvxcx89buCLMyFqm4GbgubYFNxsFcy5FBB+bj1oLnHlo28Yy1IZAh2EUO2tDq2cET8T/55fFTegPsggIU+BR3pteHE1bQ0a9qREU2QFamZfQ+enz/uuoYmsJ9OBAKoLKRN7S7jS3ddH01jO/BHoSrDx6RFW5NYhW/akFVvUQL+aGba78QXsEbFe9TJoxngEFrVKaiznOUivrJHTu60io2JsGux0CIjNlX3zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:49:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v6 00/10] mlx5 support for VFIO self test
Date: Wed, 16 Sep 2026 20:49:48 -0300
Message-ID: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::29) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ed7697d-fe9d-450e-6574-08df144d380c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|3023799007|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	tIU18Z3wWeUSjyqa58m+NofntxL9ZTCB4TD04REpvTnJvdogstKtwUlH2tIMDOkUDxJ9U3RxN0kvJg+gE4Fb/6u4q53gjzztXTzonlt6G2UbBvRPVroTharNlJAqT8qxXIY3hpDWkISke3LqOpyRlJpa5ccOPHlFDEQj7oInydTgivjqtu8zenBueeIFdn6WfJaWPcwXUsiHsZa8zyHqOx9S+QmBq+gbAIbfl31zB9Bmfy3tbMHNrq6MWR+UlCxwo8TPrL5vlPYFH+Jt+iNqHxVTHMtJYrRtdFXtfSJvAzv7OD/zy3Rf8ubkWAFwLIRLf/oa87yEH2F75WV0B+QdojHMaayR1xvdZ5G6ccTv8RCVRnU+sdsGQPhd0WQEHEpZGy7WwzB9reIFsFtOB8w3GSEZ13pex0uFFGfFbjsOP58zArehmZa43EmNLwrKLaSbO7+B3OIqWzQup2uDkBEr36bRtwxE0BrHJFdkbCQr2JcXmXMSXQvq6pdJiFdsWBgo2m7d0jd9dQWT2vz8JSp7UzM33IOqslK5Ix9IBwAHzbJ00EgugcCi36A0pjIyVQFrAtJhxEBOeZMyCw2CDE1o6CfdF7QX2HhbkWWxwayKwmLjF6zYNMT7xhiSVqdLcEG1ceCluw4wH1GlFU8aeLiTAGUkq1Lfa/wdHCq7vnawmsvkl2pHcQ8KHc2cAmA2m/NMpnjhvsXedpYgjaIe5A7qgA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7NV4RDY30Mboc+sb30Q0kKKiEJ9c7E74588E0z2LPrzGoK/XKpocqxyBW7kx?=
 =?us-ascii?Q?L9tz7/LnhlhGinLs+a+pLPVjHeJ72BoIV4OXg1dgV+shP8SKU+JA3/Ye4sx4?=
 =?us-ascii?Q?8VFRaC4Dmk2Yapy0CIUo4Brx8RqvnzcvSVlNqGJn8yCgIGVhTzKdZvUzlOja?=
 =?us-ascii?Q?JZMm012MmTyfHsqUhSEOrm/7BCRTVedkw4QJXUbwA9EM1gbS6+YI9XUCsCUz?=
 =?us-ascii?Q?ohMME0calfbayvyG9w3hpkl7uXjGxgomAzBdzNnaxlLKUYrehK+TwqtUc4xw?=
 =?us-ascii?Q?yk2XI/QBKbfLkpzEJnhgtckXFeDEIZDdDVtQMImacU8aQRGANuL/Dg+IeKfk?=
 =?us-ascii?Q?+r3H6v2jODhwQpacVwz5eaBaI7jdKDvTkSaN5jQZBtBeF9/V6NywdBHaAcxF?=
 =?us-ascii?Q?9xkQSJG4KqE4LBWWS+V5+osfF3sRlJOSouHIvH+4X1BukPF7OYw1z6Fwa+dB?=
 =?us-ascii?Q?KlZDCS/SSOQ1rS89yTFHIr/8iqtEORpxHTth9QCfLjvkYdP8KXbJU4v9xrkX?=
 =?us-ascii?Q?CETaWg2tNQi9D2D9FbRZoXC8Oc6Qt9gf+PmWqvysTVDDB10NFUt+u6yzU+Jg?=
 =?us-ascii?Q?AQstTTPU9SUg8wRvqT4f/DCuVt6K/FjGMTGoDvmxYgB1pj7FAgWw+nH6Gywu?=
 =?us-ascii?Q?RnhodE3RGqMK5+ehs+NiTZXfm2/8dKx/z2frx7hQdl9pmXyW1WGIJs5te5vC?=
 =?us-ascii?Q?bMk2GtKnjgqUvt6AieD0O+C1QR3NPd9bN6TAFGpdgkcpJvxpiHJ8FB4YPLGu?=
 =?us-ascii?Q?Eh2Q/oDMOmE1iRcaFBOu0StHAc7Z3uOj3tE9iSmcmjMNGATrRIcRR9Syh62y?=
 =?us-ascii?Q?rCR58VRB3ngK2E51wchvFaKZkRxuomPI6DXXo5OhP3YvKn6En8SF3kXQBQD3?=
 =?us-ascii?Q?fNErBwpVwX00+MxiHroAtf3Zpc7Od1lf2459Xc7/iv2peYP2J091fKcaHR+7?=
 =?us-ascii?Q?OKZP9XXhzJbSwbIl0xqwnHngs2Eb4wSVBTTaz8bVBhFSXTv9i0jNHICCFBNi?=
 =?us-ascii?Q?3hy6H4DtoUvkOsYKgRi8eBEqQ5Wt9p+POekOfdWl2xC7Lx5ypU5O1BcQKnxh?=
 =?us-ascii?Q?wrXXSTJC+LVQYRFUWqdC1g4m2aEdZOTj3Zq6Yt5+sqEq5P7aaFg1f4ma2B5M?=
 =?us-ascii?Q?7FGzM+IyCy+uhXKMvO99dQ+y7xHOTx05PchGaJ4VnhEgeTJ+26cM1OSX0U/b?=
 =?us-ascii?Q?S695BA3w8NyXnDZtFrhLhN8XVHZQcm0S1JvHwR3AwT8lH+bM9hRw+vn/bBAB?=
 =?us-ascii?Q?722aEIHKhlOWoTq5a3Eb8BI6E/kanESAbd4+krFRliEskSqNBXUNCbutXT9A?=
 =?us-ascii?Q?eF4s0bNQIHBawptVRwONHsLF3oqKd9004BvZWbtEHRYGW8p+KmCPidAZ3I5G?=
 =?us-ascii?Q?5cSwPGur+k5R5cJK91AAK6m1JzdmqPbYX+CvP4PLkSlRFPEVkYwevAGmmH83?=
 =?us-ascii?Q?YtCgS14LJhCKvF6wcasqQ9kS3k4byMwU579FKfvsbuRwL2F1fMvWRdhZFHJZ?=
 =?us-ascii?Q?YtZ45FD29keEjlp90eWPuEQfFO5Z9blXwWxuDKM5PqHGqksEOumNbrMryl2q?=
 =?us-ascii?Q?IX1FIVUTSCW4/Orpe9Nb/wY2hQpueuCr+bO1Xaui1yJsLqDMFp+s9xXFww5q?=
 =?us-ascii?Q?q6/8vnOA4iwkgUn1g9GhK1wgrrcnPySvRgxnA2TbnKu60X7opUgCz0aDGkED?=
 =?us-ascii?Q?EkBYKwKm9coxL3Yv5IaFJX/ms/4pEg8KiVaGmLwiMGLq/Fvc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed7697d-fe9d-450e-6574-08df144d380c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.6439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQUJPkHpq6yFlwn2SEW9Du3aSsi4SgjjHie6uQn+WK+P13yW01otlVph8wLvqSS8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

Add an mlx5 driver to VFIO self test. This is largely a remix of the
existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
to issue RDMA WRITE operations which effectively perform memory
copies using DMA. Since mlx5 has a stable programming ABI this
should work on devices from CX5 to current HW. The device FW must
support the QP loopback configuration.

Also support send_msi by arming completion events of the RDMA WRITE
to trigger MSI delivery.

mlx5 device startup is very complex and most of this code is just
booting the device, with a smaller amount for operating the QP.

This entire series was coded by Claude Code in about 4 days. It
used about 4.5M output tokens, 30 individual sessions and 5600 lines
of AI-generated .md files. I spent an annoying amount of time
de-slopping and cleaning its work product to make it presentable.
However, previous VFIO drivers have taken on the order of 1-2
months to write, so getting one in a week is pretty remarkable.

For those interested, the flow I used was broadly a prompt sequence
sort of like:

 - Hey Claude, go look at the falcon series, VFIO self test, the
   mlx5 driver, rdma-core and some PDF documentation and make a
   plan to put mlx5 under the selftest.
 - Write an rdma-core application using the built-in VFIO provider
   that can do the required memcpy operations that vfio selftests
   wants.
   (This resulted in a 1k loc C file that compiled and ran the
    first time but had a few bugs related to device programming
    that the AI resolved.)
 - Replace the rdma-core components with open-coded versions to
   create a fully stand-alone program that does the DMA memcpy.
 - Review and audit the thing.
 [Pause and de-slop it]
 - Make it work on a PF too (this is surprisingly hard!).
 [Move to a kernel tree and copy all the .md files and .c program
  it made]
 - Hey Claude, look at all this stuff and make a broad plan to
   actually build a VFIO self test.
 - Here is my 1 sentence advice on what each patch should look
   like, make a detailed plan to make a patch for every one.
 [Pause and polish the patch plans]
 - Execute plan X then commit it [pause and de-slop each patch,
   repeat].
 [Review and final polish]

v6:
 - Rebase on v7.3-rc3
 - Correct some minor sashiko remarks
v5: https://patch.msgid.link/r/0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com
 - Rebase on v7.3-rc1
 - Adjust how region_size is computed to min it to getpagesize()
v4: https://patch.msgid.link/r/0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com
 - Rebase on vfio next, update igb and falcon
 - Move rounding to iova_allocator_alloc()
 - Remove arm barrier changes
v3: https://patch.msgid.link/r/0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com
 - Move max into vfio_pci_driver_probe()
 - Rebase on v7.2-rc3
v2: https://patch.msgid.link/r/0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com
 - Rebase on v7.1-rc3, drop falcon patches
 - dev_dbg checks the format string even in non debug builds
 - Sort includes
 - Adjust comments/commit messageas
 - Use linux/pci_ids.h
 - Compute the driver.max_memcpy_size the same as mlx5 kernel driver, it
   should be GBs now on most devices
 - Put region_size into all drivers instead of allowing 0
v1: https://patch.msgid.link/r/0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com
-
Jason Gunthorpe (10):
  net/mlx5: Add IFC structures for CQE and WQE
  net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
  net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
  net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
  selftests: Add additional kernel functions to tools/include/
  vfio: selftests: Allow drivers to specify required region size
  vfio: selftests: Add dev_dbg
  vfio: selftests: Add mlx5 driver - HW init and command interface
  vfio: selftests: Add mlx5 driver - data path and memcpy ops
  vfio: selftests: mlx5 driver - add send_msi support

 include/linux/mlx5/cq.h                       |   10 -
 include/linux/mlx5/device.h                   |  231 +-
 include/linux/mlx5/mlx5_ifc.h                 |  178 ++
 include/linux/mlx5/mlx5_ifc_macros.h          |  185 ++
 tools/arch/arm64/include/asm/barrier.h        |    4 +
 tools/arch/x86/include/asm/barrier.h          |    5 +
 tools/include/asm-generic/io.h                |   28 +
 tools/include/asm/barrier.h                   |    8 +
 tools/include/linux/stddef.h                  |   10 +
 .../selftests/vfio/lib/drivers/dsa/dsa.c      |    1 +
 .../selftests/vfio/lib/drivers/igb/igb.c      |    1 +
 .../selftests/vfio/lib/drivers/ioat/ioat.c    |    1 +
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 1928 +++++++++++++++++
 .../selftests/vfio/lib/drivers/mlx5/mlx5_hw.h |  114 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc.h          |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h     |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_macros.h   |    1 +
 .../vfio/lib/drivers/nv_falcon/nv_falcon.c    |    1 +
 .../lib/include/libvfio/vfio_pci_device.h     |   11 +
 .../lib/include/libvfio/vfio_pci_driver.h     |    6 +
 .../selftests/vfio/lib/iova_allocator.c       |    7 +-
 tools/testing/selftests/vfio/lib/libvfio.mk   |    1 +
 .../selftests/vfio/lib/vfio_pci_driver.c      |    6 +
 .../selftests/vfio/vfio_pci_driver_test.c     |    3 +-
 24 files changed, 2501 insertions(+), 241 deletions(-)
 create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h
 create mode 100644 tools/include/linux/stddef.h
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_macros.h


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.43.0

