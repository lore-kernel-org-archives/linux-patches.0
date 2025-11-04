Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F84033E37E;
	Tue,  4 Nov 2025 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282860; cv=fail; b=YDm6rNA1h1BHYVuprxVYsbw1r6uMGId6CrMnaw9eiyv7FlXtNw/Auqk+ePlzpm8OID3p/0n58OWva5kXwW07xiPKWM4/kttpz8UkKiuNj6FpxlVPlW5ArxpfcWTaTkDo+IDgImz/8HCElNJrYPISyF0yX6nS/c34MwzDqznoduQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282860; c=relaxed/simple;
	bh=CdfRxnz5HV3vHVEENBTGkyJWMwWD/8ZkwPZPLpvl/Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JnggDszfl/LbjULXiqS4SoFIwhhoHMWJiKkRaksYicB1t7VniCHke6T5FG4Nxs9r4nmiiPZYHCyfsuh3qqPnS8Hz/xXa9VqNne64/NqWtTgfMDNlxl8EiKGKjqd/xxJnL2iccGIqKeyvutXRiOskjpqQ+e7s8NqY/AmimHZxqTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tr3fiqbh; arc=fail smtp.client-ip=40.93.198.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tr3fiqbh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TkLoR+7+dZqaDmhu3cv74yLWxPj9JYaPURA9z7qlSnAACx+I8Pbm5MxHTEnSJB268v8nhtQ/4sKH2/UslVFgoROyrEby/NctcqTXoVxJpETZN8nfjqEHUz6RnJLmFaYB4B9ujlW2r0DlvGQktPgnir0u3nes/2B2yraFYEDMxkPYb2FkO2MBtXDN4M4VjbgNvIKklnR3NVWugvohVYrHcymeLqXAAX+EW4PuzDeRK3zubUeVcP0xs07IYAnj7XsvPCP+wLNgxhUSJ5IbcSZFZCz2Kl4/tbiTaI2/CWj4ztN9NpgrR5e/V3dKMOevU3k6mfp3DD57xAdAPgscr/1XuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67KHeGV9qBsEc3Uq2g23U13SUM9p6hnDNJ66z1ZPkY0=;
 b=P6v2flFwroiVWH/iFAWcCNPX3l3Qu5zVghbau1ciMlJYTP+I/kKtoeN7QSsB3drxeJNbUexaPApRxPs+sYQWtvEID73Xo21ASVKHKfL6bK5Ug9JkUytvP9TqWjheyfKQi9+EjHaKeUtmi/vtHEIw8LWaiJPuXASwbJ44eQMyOhiCJy/FSojqXKRTEQWnAUo87Hg7Fai9u1+NHvRNvwwt64TTVeXna2EaJ/stJml3lRmK6KWQJHygb2iTneI2B4RXzl3L04knC/Uws/bT6kkG+F2otH0ZuRcaDVcbGDOO59be8J3/jGKZa8D8gyE8cUSQ5rVYSZd+IPEzo1XF1unOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67KHeGV9qBsEc3Uq2g23U13SUM9p6hnDNJ66z1ZPkY0=;
 b=Tr3fiqbhkUtADNLrWIjwkxsHuoIlE5wkgZWF2+Is6EU4og7MNDXGUsGfHquiFMB7qgBZ6QWAyxbjjPjUc8ihRRcoQnGLNNadebfBuASclC5aFse6hpYPEIG3Jv5daYdH31e/njW1ZRmRPARYUM1RY4Y2EAu6f9+oNzEdJohDTaS/8jv+df+42f2Pt+TNpNVmX94NKz9TO2ONP4Kb7lwnDVLXTvNqe7mMKSCKDB8N7eKBZ1/IiJ/njrDsZ2kUwTLxTt2qWxm7QhLdrxFdPS2OGb8onhOzfQz4UNIRREk43/FecZr/zfRrwz6RmoYgkjqf8/+wHyGkzjAFW2EeKqhNpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Tue, 4 Nov
 2025 19:00:46 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 19:00:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: [PATCH 5/5] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
Date: Tue,  4 Nov 2025 15:00:44 -0400
Message-ID: <5-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:408:112::13) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 888aa75d-1a24-4a64-9da7-08de1bd475bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lwHFNr8SW4H+V/9mzLv6cnz3OEYT/525hAATuxmpFABidshhwJzf1xAZi6J7?=
 =?us-ascii?Q?kdY5LjZ3xs+xy9Vab1nd+C97to+tnQGSa/8xdPaCRCq7ZH9nHRUzs8ucrW+T?=
 =?us-ascii?Q?woRJahqQB3iuwcQTs/9b6oJME9PX1t/AAcYBBnbPw0zRWEXiiD4/I4iSnSX5?=
 =?us-ascii?Q?liuz78EyMJ8wvg9P8dUMYpuNo1c9UVJDNXy6Szwt4eNa8/5JSTcGBjCItfK1?=
 =?us-ascii?Q?/hJqBg5VM5SVJA5LYsvmHZ0WMfJ5ZjhTYqo9u5qoAZouVIfOJHViYkOsaOYJ?=
 =?us-ascii?Q?pnxelAvZTKr4yE0G05hBdWBiexeYmmzBvEMHUooRzdUp2JLG5vDjo6tABWIc?=
 =?us-ascii?Q?tzSdTmzUEBEI9WecM6J6gHfEIOMHPNd83IyEycKpso+xnLeSqL3D/DrmJtjc?=
 =?us-ascii?Q?OmxOxnvRE0iyWqM7Nwl/UOXZ5swi3/lm6VuPAbDdSflwvFID/vzdmMkuZJww?=
 =?us-ascii?Q?EFLocHYLPyX89CHlQpTXYRXFjI6gs+/TNYFqL/Wuq5W8hKACrMNxruMOGh0X?=
 =?us-ascii?Q?+iJ98fcWXNQsO9tn0AprKoC61MIUeoMlYWF4JzqhZrOYQjIX3F+2Tfvu6PXa?=
 =?us-ascii?Q?HVGicbgZJo5OHk/CFgxzmKWf/97IQfxePoyHcxemd6u/YrmgZbngzDQo4d8K?=
 =?us-ascii?Q?zpvMTJeIttdFgZnDofcYwSURP4+GPpGPlNcKx6za0UrSU2A5XDyqB/7x82Sf?=
 =?us-ascii?Q?xKZWrK/Gw7afOmnvYc0xSmNgfWYV5vM8puo3k78tA0fD7E+BHxSCFm6RGRum?=
 =?us-ascii?Q?KccKTPrIi2oXlkzSVW5seAdum9rlWb3bbIIZkyKfUsVc0AE3pVe5jhaBoJWr?=
 =?us-ascii?Q?KTOq/R5GStcWodlTlJQWAYxtuskpscbCJYYqx/uOi3/RiQqBnI3p4CLvtxgz?=
 =?us-ascii?Q?Wv1N6+HjOlu+/oJ2csTMEfN55nBOjeKBpy0EnrI20MRIN7iScf8QWqETRkEX?=
 =?us-ascii?Q?KF+/6eUdzKitxr/+m4W2JlaW2tu62wuwUrrzez5+0hBXunjgaLpdWu3BoieU?=
 =?us-ascii?Q?t59nKUoijIlLQdRRTKFPUSp18Au1CcSjubzR2BGx2cwrRVAA/roEvXPmiVc4?=
 =?us-ascii?Q?GwYaGfNltb/YdRMA+SJTm/hXM/iL5+xtFF23B0mj61mspjkOjldXbMDe7Hrz?=
 =?us-ascii?Q?UAgZlVASpPFXjiNUVgu38gwAmChD9CS6365QB9gxs2fbOYjXQ2t6JpNnGM84?=
 =?us-ascii?Q?JaBg5Q0HDcEmsvevev5C9XFmZjOfg7/JwkL7jbfbt3ZXwPCy3w38Ns5hH19J?=
 =?us-ascii?Q?6U/To0NNvKql7pKv5XSMX9HpBmhVJiHvM7IztrAygiFM0/LEKHXqA2sAQuwn?=
 =?us-ascii?Q?8NlEG0Hq3Cq/uTMXFaG2334ZXuO2x5V/twzLgbCMG2l38xqcSRRqvrAAbJHo?=
 =?us-ascii?Q?0EBOCRUwTaJVNHVQLDAovwzFf4hfkzh7SXyjqCQQ4tiq4re101fGzWanXgxm?=
 =?us-ascii?Q?yHtM/BNMgY9wsrMLOudlhchB2UUeOblMT3k62tfg60wEcx6gpEW+2p9/y/6A?=
 =?us-ascii?Q?38oI95kL4K5pmEU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ok93qkBNMlLOXD+mPz0z2g44Hnq/InGhRrHbdB1tKUTpIt0wUJNMkZzJCPvl?=
 =?us-ascii?Q?U1Prmhx0B36E1/GNgnhgDjyRx6NsO9s2cNKHiQlKJvkuHxH5QNvEn+tGfHhm?=
 =?us-ascii?Q?KecCnUoBg1m9emcT/afLoe6I13fGj9mDmtkEyJpNNIk4fzxBXrlNHfODNbpx?=
 =?us-ascii?Q?6ZHY33aZ9WHQqGjrNpgj+qeix5pErRZg3y/pUbZ8kuK32Y86+i6tPzGMdzZ0?=
 =?us-ascii?Q?bd4I/ER0Uxidwis3K/gXnj8LejR+h6zxfvBLQTrVKHh5BYwXMKVDwnQU22eu?=
 =?us-ascii?Q?fE1mU0qOs12l48YhfA8Yz1wHAev+g4L/QAY2lEUFTxDIphMfOZXIkpzX2zkc?=
 =?us-ascii?Q?ni5y8g3D/Km9KkM6Ky8KeAc0l8E/aZqMqQc8G+HlXKF2LoFRCPdPJFN4k9c0?=
 =?us-ascii?Q?XmEfqSTwakm1fwSF0jaU5tC7mY7lvFSaiDUiwRHonaBwOp7v8ep7eet6bGKX?=
 =?us-ascii?Q?09ek0AdS8XciCFPA+W4JLI2/AcY7ZA2Yh6eUUC6vhbdDGTz4wkQgQ34cBC8r?=
 =?us-ascii?Q?Otgc7DhcTgp/W6Z4Mu21E7EgeZHX7mnXJpQYn5YD3IKoLX4tWo4B8uJJ1D7w?=
 =?us-ascii?Q?sDcTaudlvnwpIOD4O25mA/l3Hwml2w6/c2WSD2leSYVvYyIEETPP4P3kMGuf?=
 =?us-ascii?Q?fhPQpi3YOadokcptHiTjFpqZju3r25s1Mu5XP3eioCvl5MO43I9eSEpo3s4s?=
 =?us-ascii?Q?FnBzMu5Vee9SWuZp+C9DEK9Z/gSpSBqzkUjW7sWvnWkuJXAjj5aGI51mDPMo?=
 =?us-ascii?Q?N2a//jt0AuKLiaqfJfwYOPcZ4cHbwJZgc04u9lWzBV1TG1LlU1PCbYtGjEoj?=
 =?us-ascii?Q?sjq8wOF70ZXvLqIURuYl+XpuKs7VsRivoHyG0w3KQmvwp/WzKdjAek0QnsnK?=
 =?us-ascii?Q?d7LSK18GLW7ZvIjTAjlqgtjZHUmov3zSUtBw4mQKj+se3oQfyHpUrAOrE04A?=
 =?us-ascii?Q?YX1vLJagEwfODsFXY/BV2Sy7ZpnOHjFZtSKoBsvxtiimdi50QBGs+VfZabE9?=
 =?us-ascii?Q?yabmWE9I6ismRYopgl2NIEwPOLP1EsEKO1yfbHea71CMdBQgSRYq6TOvfffu?=
 =?us-ascii?Q?bFo0Qrs+5Gz6706WRspHWletrC6WmpDubWI/Y4W3FAjcv/Ye7Vhmrv4ymwUC?=
 =?us-ascii?Q?+xiGv5y1vPB5mrwJtFcNkFuJX4yO0sfCkBHJjkSJeD0N9LRhtbSH+Zxad1HS?=
 =?us-ascii?Q?LM6ZH2s4AOutUWgNFcbS86w5W5e2BcJ632reTIxDMVk9WE+mXiYNNQ0o2VEk?=
 =?us-ascii?Q?3XP1X8SSjxrIlaFxbGBqCpU90BG6tmSyT6seAK1GftacjSjzEbk2vE+Qqigd?=
 =?us-ascii?Q?MYMolUaW8JKHwmkj5iDH1/RTrmtpTTCs4DmydMXr//wgbWmrSESi+kCUqI9t?=
 =?us-ascii?Q?IO4zF+7Hxqe19mKLQThK0aGu8Tdsq+QDW2OX8zXoMJZuD1rt5eQabWntbNNX?=
 =?us-ascii?Q?Mrngl2ry0IgtOWU1++Txwkp4CAAfzdIiiyeoC8zGv7hQR+L3kfSCGJdVqlWa?=
 =?us-ascii?Q?l/ugKP+allojjX7km0UlReER2vNCxMYVKNmryZBD1d/yQpWLpGmqV9Pn1zec?=
 =?us-ascii?Q?78NNJoQ+3Z5RcY7OKdc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888aa75d-1a24-4a64-9da7-08de1bd475bc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 19:00:45.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hH/XQyqwOE4dNaoaWXIvx1ApDkVZd6KSijbiBoKZ92cfn2oV5cVTn4LIlF0OBSVr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071

This driver used to use a lot of page table constants from the architecture
code which prevented COMPILE_TEST on other architectures. Now that iommupt
provides all of the constants internally there are only two small bumps
preventing COMPILE_TEST.

- Use the generic functions for the riscv specific phys_to_pfn() and
  pfn_to_phys()

- Use CONFIG_MMIOWB to block off the mmiowb() barrier

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/Kconfig      | 5 +++--
 drivers/iommu/riscv/iommu-bits.h | 4 +++-
 drivers/iommu/riscv/iommu.c      | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/riscv/Kconfig b/drivers/iommu/riscv/Kconfig
index a329ec634cf1c5..f681188d19a1bc 100644
--- a/drivers/iommu/riscv/Kconfig
+++ b/drivers/iommu/riscv/Kconfig
@@ -3,8 +3,9 @@
 
 config RISCV_IOMMU
 	bool "RISC-V IOMMU Support"
-	depends on RISCV && 64BIT
-	default y
+	default RISCV
+	depends on (RISCV || COMPILE_TEST) && 64BIT
+	depends on GENERIC_MSI_IRQ
 	select IOMMU_API
 	select GENERIC_PT
 	select IOMMU_PT
diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index 98daf0e1a30690..29a0040b1c32ea 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <asm/page.h>
 
 /*
  * Chapter 5: Memory Mapped register interface
@@ -718,7 +719,8 @@ static inline void riscv_iommu_cmd_inval_vma(struct riscv_iommu_command *cmd)
 static inline void riscv_iommu_cmd_inval_set_addr(struct riscv_iommu_command *cmd,
 						  u64 addr)
 {
-	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, phys_to_pfn(addr));
+	cmd->dword1 =
+		FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, PHYS_PFN(addr));
 	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;
 }
 
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 014de227e6123f..2dd33ee778c009 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -160,7 +160,7 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
 	if (FIELD_GET(RISCV_IOMMU_PPN_FIELD, qb)) {
 		const size_t queue_size = entry_size << (logsz + 1);
 
-		queue->phys = pfn_to_phys(FIELD_GET(RISCV_IOMMU_PPN_FIELD, qb));
+		queue->phys = PFN_PHYS(FIELD_GET(RISCV_IOMMU_PPN_FIELD, qb));
 		queue->base = devm_ioremap(iommu->dev, queue->phys, queue_size);
 	} else {
 		do {
@@ -436,7 +436,9 @@ static unsigned int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
 	 * 6. Make sure the doorbell write to the device has finished before updating
 	 *    the shadow tail index in normal memory. 'fence o, w'
 	 */
+#ifdef CONFIG_MMIOWB
 	mmiowb();
+#endif
 	atomic_inc(&queue->tail);
 
 	/* 7. Complete submission and restore local interrupts */
-- 
2.43.0

