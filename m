Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6099343634A;
	Fri, 27 Feb 2026 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205957; cv=fail; b=KmmC3ovOe2KPNZjrSWwsWSyV8xH/kfx4WILJUeDOx4k7ZzQRSSHrEYrMlUIvUr6P0uICPN6ondYx5hphcCr7+icKDNM24tIBe33v5Pl/x8ttgGtIrjtUQqNfd7VPeawuReEKGDsh24iwiCc6JSSptbuF24qrLdKJKWfacZgCz0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205957; c=relaxed/simple;
	bh=G6MHwqrVuhdDVP912i92JggeoWm/GvdUgd5oaazDLgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rCY0QNsBwKiKn5GKc+0WnuvemZkMq65LKRqGeBHo6gLRqYaSYCjPT/HuqRpT+naQZTd+/4L2AZih2Lj2k3d71nFY5d3jTeLf+ZEyySPBEosbtTNmX6G8rwFzMmjFP0Iqltfbrf+0rL+c23bX9pUQTXLAu8ORiWcrJEHL5n4e/sA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BNYFhrRm; arc=fail smtp.client-ip=40.107.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BNYFhrRm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EQYpVbPNt7REvphMacCt3gMsJ4ZckYQZc886QQdbSsNv5ohOsBJpXZkizRLutjs5KudYxVR9hCsvzYT78uvRnTdFUiwJqz7iKHyQZbFVYxC0s6+GXfCJGl+XzkG3Xl+VUl05rpVvXVgv6RGDXfXRPHTtxdQ05AzZiiCsYt/5DeX4sydw5FIORa90ypjWd4hGUqHVx39H+wKMgMwGKuMwrhHJiRIFyL5WriceLhHLF3CEPvWdmZPTD+1xPLV+YTzziRTEy/1sow6ZK1O3JzUjVqJP++OIXmngydE327WpV9uFzfnyy22l2VD2c4ZbU7riZbcVLaohBf9+ev9Op/rgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PhmXtboA+MubDZplf7b2rplJjGDopcRLnXMPpSBq2Is=;
 b=ZfVfsTIzuH4LsIHoWR5u1IY5kdw9NFjSqxJ7uZydpGj9f9qaJLW6vwUVgAcwGAE7U0AWnA4t+Y8gm4to29MK69zCDwHlGBiFabPBUXT3atura7nudvFDkiiNAN5Ttu8uW5ArxrT143PBJ6AsKvxxWN+nE9Wg45Y+9zH4MOY/dN9xOVg2mUEiQRbUaXh9S4YX3Hl55IzwKN/vwuH3pWWdWJVYT7CvaocQicQ/fJKKFI1EnPA5m2+pWq/x5Bqcx+10dE40Fj9kzvuZ2Eq3FCZJG+EwWcBbJPdrcCVD0GwGwbEex57JcEM9KkzVr/VoBUhP7/8/0eR6vSH65kswnG9Pcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhmXtboA+MubDZplf7b2rplJjGDopcRLnXMPpSBq2Is=;
 b=BNYFhrRm3a/Un3D4ZZIdAIe5BYk0pJpiYHpMa9Hkfj+TYWS/Dl9PwhUrbXjfWIEbzAKa0f4ANCSxep1wm/loUOe+TFuIOlBXXn4CxIBGj0IqSKwfWfls2jLMVMXRi4/4Y0r5GV7PwsDGkSfkNVK4F1NkI1kNFYZTSUEGlM9fDXlQ2JIz6ejawUt6G/GjfccUwLm/QM0Ir4Le/X6jxQ3t5SrayHrP078I1oWv9CBNEauGXMlCQlBUapymrlZRfftSU4y8ZuyBj6Xu3qskOEOoIdlRDY98G2XSmmUROYPfXJ630MmeDCRSfP1Cvhgd/uaSa7VmcC/yvt3WVl+FpEEviw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:25:43 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:25:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Joerg Roedel <jroedel@suse.de>,
	lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v4 5/6] iommu/riscv: Add missing GENERIC_MSI_IRQ
Date: Fri, 27 Feb 2026 11:25:40 -0400
Message-ID: <5-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:208:239::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: b67eaeb4-b177-4240-8407-08de7614780f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	FUrBnH+wc5pQt+EWtZActpzBYFGg10DcL5MbL3E9FPR/qh6QIzUNLb6OIj6xOli4wHiS8OPC2WMD+RzNZFAUmf5TTKTrR9tJhtFd2w9R2DR19g4niHR4Yk8yDkMQjk0nxAR6GmtcUGszC0TxKrssRJbRgOG6V9h4qdCjmPKAr2zQ/HvbqWsMnwEzIdF8pqjS5jDeodWVh0XG0NiRUQb+VDN7qdtXXJoutPBs6ZkH37UW2B9BjVRA6rRQQy6fgVCXmwCLPMb+UBkugGt0Xf8oQ1WiuDEw/TNCLSxknNEDV28u5Mso12YcnGszmmIQYB6sTghmIbG4d7yVVUxtBj1mIxMLi1WNE2fNArHJtNsH3PIMkp4lRtXkH2GjtyZt1o9wTl+ZLPoB69wDrKOSd3X87s8AmB1ahNz0MH+UhyjfpRr+6+8cgRqwzZdpk/WiEkjYLaZ9NSi22fTfgjJpeE7hYi3PWM3O/rblXpTWh1Pw1GqzBiC8KxHpbMzfNPQD5H0RUITM3hZqCS3ZYxTlfwLqIuvilfAMBE3ofT3lNy1ajqHDmkW0C9nfHBlYbavqjMQ4Wc9Q7ZhgBtSCYigNFCQl8srL6HA7e7XlXxwbbQqW5qyuNahLOqmkDgyIsGsxwzxHXR1qaiX7zY1wEJZ/bu3jrfPZrPyo9absYavWcAP4C5uLtoxxCA88eaISvBsZluT01Kdlm49viAbvM32RHgyeZ3JLJO6++AGVjJBhzmijWDo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8R4OunOWGu+OwuZdDG39pY3znr7Vq3Gkbxz+In0rr0gBNjAhM6G0KzsIBaDK?=
 =?us-ascii?Q?ei1pjKFofQLl2zQ+i7PAVodK6i/nkQoAzbHjGHNRZ8VymXMxpSl/phnXelk5?=
 =?us-ascii?Q?FGWbGfnFa+RB5B9qpHmGDFeCIPUcAL7xkLRZvqUXuvzznFti/cSu76BmShW7?=
 =?us-ascii?Q?bKMHoT+C87UizwXWgqN0U5xQywYt1kohsKU15gFb73IAeOPxhhrGt2CzEVXW?=
 =?us-ascii?Q?PzW+cieLq/rihzq7Cdmy5jov0tbTNX1R4NqciWGfa/LjeJDK+H8sk/DZ5rKa?=
 =?us-ascii?Q?9ReiAuahrRN8lzzDx3dco6KwQhW47QyucQoTFl7o2aP92qMoeFLBgorjRyBT?=
 =?us-ascii?Q?We68zQUQ/Ve9QCAshiD8W6BYo8o0GwrtJlkqm0KLRygbINZHJ/gnCOwhzkE7?=
 =?us-ascii?Q?YUQjlqgMncRBMXRZubMn9UvAt3tWtZLhPRW70nd9XZUZ/DdA7iYhVc+xmpnU?=
 =?us-ascii?Q?iGql9GlmPXAlMKclEAArY9blH2YTcGSSUO9DuS0GHF3L2+WRN44tAC7XXjDk?=
 =?us-ascii?Q?YTF44XsBJnL1ikYxTozCLXMXsicXcoo8114yBBLME3zNPCJ2x4xusbj3dF/x?=
 =?us-ascii?Q?DpGto7i1kBIWTHJ8EOOQ4Fbpw64Jy++Cu7X3I1SbN/ahq4qMcVj9zIzm/Hbr?=
 =?us-ascii?Q?LbFsPghZdvVmp4iQWwWqDkPQkyMuJUHVuleyYFwwAq+gel/xifXR5QjrWZwv?=
 =?us-ascii?Q?eSpyICQEJeUEyZGpQaOQe+uEhHExlKv1LN1fp83PoFmLfW5fu4KNc9gY99kM?=
 =?us-ascii?Q?s9vy814olBYG5k18R3PcuTw/YEToHdsTBa3Y30qfBMT1iw7CwXuHVISITEST?=
 =?us-ascii?Q?iuSY4GE23gKFwGe832S6AN58eyFeKw33tYkVA6CFxAYnVoRrkMDqDK8TgXIr?=
 =?us-ascii?Q?eItqhz0c033sxYqiKEvwbdSMkvDzjPA15pB6gIaDpNovZVFG6Rxv0edufHzL?=
 =?us-ascii?Q?jU7bNDLt/Gktir06Z8Myc0x+qHKtJb0FKi12MXwkCYvdAbq6yxUMMXXLGLfS?=
 =?us-ascii?Q?RjIVLGUqyKJTaaVo0LfK8kRwA2xmVTVLYagZtjafXGP00cm2meNIuyGtflTx?=
 =?us-ascii?Q?k8NwsHcxRJlB7pLjO6zA/TfWbNv4R4WGDRSZAxvYQ70Hk2YJWEcOPzabTeK+?=
 =?us-ascii?Q?W0Ti7Vtu3U1Frr/pjvVCHvEMbLiaigrt9+romKyqOzfYm1pSF4ytjd6UPbus?=
 =?us-ascii?Q?gS/DaRVEmWCNUL8AIWlcvPduLElL7HQpEEb+6xfUXA2L+QwvtszHSAx7b0gP?=
 =?us-ascii?Q?ASXyZxa4aDvgNjMSvvwuPo10wjnb9lFQactilKVycdlTb50ju+UVk46703yn?=
 =?us-ascii?Q?mnQ224cgYLAcc9DlvzyYfHE+35oAyqiy1YpY8lTL7i9JSCe+2csG5cJrbcWt?=
 =?us-ascii?Q?YWe+FnkexhuImA6gcafdYITDC95dXasgyRHV2LwLaZjSf/9KVKoTuF8viGLT?=
 =?us-ascii?Q?BjiA0kF8NhNaP92f19H1oX8GgQd+qJ+kRylxT+poXcQMg5Um6I+MEvcb6k8z?=
 =?us-ascii?Q?NbnhLjaxcdHqm9F79XVtcmrFh9a7KmpEm6rCOL62LeOZUed0dflb+DA3Ufsp?=
 =?us-ascii?Q?HbFjrAMtkjgpbUhW7jPsq0w7b07RF0WyeC0arPg5+7+DOc5cvfIKDsZOuK8B?=
 =?us-ascii?Q?GPs1wJCwF3XHyTlWOV+sYzrZZ7T0fwUK4M438enz/ZUaEx36Klqf/OBLj//Z?=
 =?us-ascii?Q?CHurfLGa0cuyWf1kd5T2spHRjcZxvg3AsstrKHJlp3J1YY/+Gxk5wJbBckjv?=
 =?us-ascii?Q?HIlKUa4kog=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67eaeb4-b177-4240-8407-08de7614780f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:25:42.2008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dLZG/sTJALINw/Il4K7CEW7XBi0tW20t0BPG76446E7m0GL9WGNcOwp//IeYok1m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

The commit below added MSI related calls to the driver that depends on
GENERIC_MSI_IRQ. It is possible to build RISC-V without this selected.

This is also necessary to make the driver COMPILE_TEST.

Fixes: d5f88acdd6ff ("iommu/riscv: Add support for platform msi")
Tested-by: Vincent Chen <vincent.chen@sifive.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/riscv/Kconfig b/drivers/iommu/riscv/Kconfig
index a329ec634cf1c5..849e72321d8a82 100644
--- a/drivers/iommu/riscv/Kconfig
+++ b/drivers/iommu/riscv/Kconfig
@@ -4,6 +4,7 @@
 config RISCV_IOMMU
 	bool "RISC-V IOMMU Support"
 	depends on RISCV && 64BIT
+	depends on GENERIC_MSI_IRQ
 	default y
 	select IOMMU_API
 	select GENERIC_PT
-- 
2.43.0

