Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B21C8603;
	Sat, 31 Jan 2026 00:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817661; cv=fail; b=RLV1Uf7TSElIQWOC7Owf+pjscv6dKNMIbLlLClwk0gyQje9wMQirDegYSXbQyHLJBk2+M3IcKBiuHRRiwIT7U6SpXaKEWzUvuiLQRvi58p874+kzJdZFMM1eLk4XqsFYzs7VqOldBQbzVs/sIXCVxSNmXY+QI/cKbjvfXrY1RFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817661; c=relaxed/simple;
	bh=EeJkVKwojfCDC2dwsxu3kRBnCQ57QMuh1lak1YA2bmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ONFG1i3RSsnfrJVjFphhon8zRP97rBs4fZuXqDxRjB+0fWfyTrf+FuNlcMi8y/3lCjqPX6Vacc66Lkh3IYDvG3jEuHPQWSp3JSpRl8cncmCECPJrr7KnISn5mRiRQJnAok+34moimtkkQyzA4SjT6erIOWTdgWEGtRM2q/W6xpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=boXCyosR; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="boXCyosR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nvv/gS5kUl6hdDLQv9Z7u4gx/uOgYE4arCgITfT/VcR8N6G9j3LdKXgBciJpjWv26XxqQFkjg0iybDKlYUyPUjaqW9GTrxsUwiPHnhjicBBZwV2Hr5wAO1ZyodLbhsFaR1lRh0N727r+AW7ddNbUMlvRexhq95QZNZiRITftQlDnGf8Z2fQT0S6EjRQQChxuxqDjK6O/z7ol7ZuboS1FyuEp+q2tG+4l5mohvrf3yraHoa8vshMlVBst6EMcj2VmoQN9RwW9D0PuWFSV2i4tq5fUBu0ZvfG7tkhyJRJcmLpWNUy2e6Ffzdfhrn3Dy2aKp0lluimvKzbz3dfG27P+1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+gr6HHlIQVoTFOdgFwCUbZIM6zMu9Sk1FJIhJW0Y0w=;
 b=FV5rswGRqKX+ZRkrQ7ZswTmQn6kj+1KomYsE9wjHvgsc+f1G4xE617skx6r2lOIqSO5hpKP4ZjE5rr6B7DYkYd1usGKwTq3UlLfMoZWAjzt6FKf0c2vXtrLTiecvZDDiNgaQHk8MvaeaKlUgA6GXsoY7cUa4LEJk5lWQTW2JUDzomJIKeAKD1SAxobbpJGH9qHQYsc64/SuFVSSqFFdMVywkL011sQDU66awRbCN5VbfA5Xz900UICQjo4PoFYkdI6R9fM2zJRS383T5xoOvFqwh+osGaiw+qKnoV2ML5FhU8wWgTIKZ6+N0IZZ+Q5yxisqmA/4ByuCtc16AE99Bog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+gr6HHlIQVoTFOdgFwCUbZIM6zMu9Sk1FJIhJW0Y0w=;
 b=boXCyosRlp/mR5dC88K552W3hGrbOgexPVE6+qnInp3YgWKbO7XJPqXN0ReutJkc/lt69VOZJ35ZfEoX/EmuoC6aMz+o3zxQoFPgygdqQxbBaQzWlM3kdfk/NIVqGfzy88bmKukFJc/5X+JLfyjVFjZYU3kAI6TrGwAAdltI7H/6B7rjPsMbi9cQYajoiJk4TzvuLGAxKlIawfgc9OEY57uaRtESPgxGXiqOPz4dvdrbmAKo5E69yt1S5vdPWII/70vXzW1iS0rkdVVZd8qxRHcPGdm/e/jqFL6NzkAj7t4eNR/m5MTa9q+zR/t3viDbygxfj8N2zIyr9hfXrsQ3zQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Sat, 31 Jan
 2026 00:00:48 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:00:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v3 1/5] iommupt: Add the RISC-V page table format
Date: Fri, 30 Jan 2026 20:00:41 -0400
Message-ID: <1-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0060.prod.exchangelabs.com
 (2603:10b6:208:25::37) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: efaf7e2f-2c12-4030-e10a-08de605bc9c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2QwNbmrTlyRm5W8Hbz+esiQnNfgLCLcZhzAI/OcXkMjvxzwLK9yOUwQcjUoy?=
 =?us-ascii?Q?s0weJ8EKFAfQB9UGqlY9g2++wxXT+OHMdaiCTusraRRrqYu0IV6N95uQahAS?=
 =?us-ascii?Q?FQ7Dc5FK5Mteygx0PuDzCHOzZbjO4LIZqwrQI3E74be6jBXK/GaOJ3Mwg/a+?=
 =?us-ascii?Q?zAZ+mbT5N5UZ9znKdUSka6CdLF9/N+P9BxBcCfZ2YqX1obZt9i83MPRYgkEh?=
 =?us-ascii?Q?ZJZpwgCcZ9nHram6cS1S/+1qQkPKcooYRO+F3vhQy9OwKDXwwIZgRa+Xi3Vc?=
 =?us-ascii?Q?/hmjlgVT9iM2O2Dx1aSnrv2+/jb6MW7bKaEbI/pHiRIjJ4/0HLOyNrdBmxjX?=
 =?us-ascii?Q?Fd9SHx+u+OWfygFmiqPXzqqH7aBmaG0fEG4jlF46M3XJ3sNdfqlQmgG3B9cm?=
 =?us-ascii?Q?JZ9lkN5yl0TxtfFlaM044eHwoi+kPPWe7cLeooXCO0R0c6Vg5hAQiKO5DPw3?=
 =?us-ascii?Q?fGtJS0O7Czzo002FINypUFP9Tl1ngCPRwOBJecBjGSxzzQf34hNcmUL3GvYZ?=
 =?us-ascii?Q?fqLuB12uTn+I7AJTSeLaVZ0cHiVGwXk5s+xszIT4TbuaxMNAWpdrIveWhNq/?=
 =?us-ascii?Q?KfA0x4+HyMAx4Oa2470is6xc/nAhrSYh5GvxahKOrVlvX1hwDdsEuOq6Pbtb?=
 =?us-ascii?Q?ChGm0fSyGFCP3S/FPCmVlSKIC/dns1UkMaTLirKbFvLal2zXDFb6qm3rEwd3?=
 =?us-ascii?Q?xpox0NcnHJAeqz2I+XvcEetLp4Q9v62gX5b8nFkkys4HTnwiBQxA2zUJBG8P?=
 =?us-ascii?Q?D9/5ZN/0Mmz7zJA+GNzJpUwoaAFE0BS+nSiu7azY9CLsXPA51uqkwG0y9JbD?=
 =?us-ascii?Q?dyDEvrLgQa8LHBPM8IK4iDGtjvoQaflQ63yaY0BW1BmEXhxkKhFwYgyivGEc?=
 =?us-ascii?Q?cJasiAY9+33NDSlxylTDJaMfsmM6zbI8Jo7mX2WDl6EOILLRWC7NGMtn8huF?=
 =?us-ascii?Q?OqSF4oqdkE/JysfoKJecjTXOg6cvtyFSOX6NBmDwXDeqtSZjI96P66GmG6Fo?=
 =?us-ascii?Q?MQJg7kAJ3kTUkrXULocc0qETk+ZtWYDPb83YhRROrVheWpLQk2aOP/B1WJF9?=
 =?us-ascii?Q?mtVyTcBY0GAbwpAAqtNveh5PW866VKxjC19U83ewwcEjMbjd2LvQBqVohUan?=
 =?us-ascii?Q?pqmSOcUl0Jx/EW8oip2u0/uroza36Q3eMNfyQctWg8bNMZX5ESm1ZAy1SY6F?=
 =?us-ascii?Q?X0sZRsTwqONhMBdSsAbtIZVEuX6hpFO1RI0+6fagFz+gSRaQ5fbkc4ilHcIl?=
 =?us-ascii?Q?sjv2/EZaJCmHHyWfZmpl5c+60D6oFAVNlVpGK8sSUMUOdk1VMgDZZF004qm4?=
 =?us-ascii?Q?65xDQqYAkc8MBbR+19yuetoXNYaoyszxYSt1aUPWFWr2gnAnxu2glyncaOvW?=
 =?us-ascii?Q?3FOYkJYDQR0GQMbQ6M+0L1x41PTYf8BXUf0oXKshnbiet2VqopLPS4yxx6wp?=
 =?us-ascii?Q?RX1Q4vntRNpJFZmoK6r1jA8Fdwdts/jyYL6LVAcLMN06s2SnGfxZCwPTWz7G?=
 =?us-ascii?Q?u5CboO39fD4FSttmZho/fKzkKl+guhmZnCOgDmw0lG9cXBirC5A0zR44kF0v?=
 =?us-ascii?Q?2C39thj564+5pgOuqI8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ifP0WzsX4vMezXYsA0eixYkJQzrjUw58HZlhBLW1xPHrsYtzcdrv6xzrgzU3?=
 =?us-ascii?Q?IoCw/SKMDaRXGb25FIP5FplRNFugSRxWjawYiDSXtpN28YodIL1cNMNIKQFR?=
 =?us-ascii?Q?opwwCPYsfOoS+rpZOcnQBdgXUG3yLAQgriM2ge0Qh/z6Av1WCg65Yqjo6O70?=
 =?us-ascii?Q?bA0en6VnuY18HyC1C4a3wAKbSrtepPxVBj7HXHLYv0LqMeKPZE35YntofQDK?=
 =?us-ascii?Q?nKU4N94j8IS5ep8hmD0Tro56e19854pLSd5SwrCz/jVThqEvzqZLsxStFIyq?=
 =?us-ascii?Q?TTZSnIMUKi96fgR3u3DKF3xKjQJXRCbho1ieQ2vr7NEqIunw7FbR9ddtmYuo?=
 =?us-ascii?Q?Uf9E9f1xzfOW2Em64MX1INsiylyc5xWGcgfmxGgT6QVa9n13eqjF6ir51Lsm?=
 =?us-ascii?Q?lYEsa1i8L36EA0yDdZc1RHJsyP+qTXDhqCjQJ3Z11Tg96Bkc1UFszNs1xcu2?=
 =?us-ascii?Q?tt21Z3P3ANfS26J9Ca1PlYno1iu+Xql46O8M/z5Eippqp/+hBE+wAgTQ2SBX?=
 =?us-ascii?Q?Jzf3J6qq0ivSx4mslkbJ4UCU5LjRFegi7lYkPCPHczz0S0ZVl1ZG2X04Sfid?=
 =?us-ascii?Q?/aH50QWw8gHll2nTCuyTmZxnpBuvRMqhKNZVMQBPc+SeSUdd7dvBi65K7laO?=
 =?us-ascii?Q?CXKrBtBd6I2yqF7yG/Hi8aRg92HN+/apiB5oVq+n7Nb6OwkdTN4j4HRJyaJq?=
 =?us-ascii?Q?icl8BPL4q1G+UWRh/XI9jaw84HShlcfWMcPoNe4CMMSAHwswMQBAhYC6BYmA?=
 =?us-ascii?Q?LFxqjrgMXwsJlp+gxDVT7mqpZDusg/d+6T9hTloLzUOKX5LDUNgOJiP9vpnT?=
 =?us-ascii?Q?BgmFEVLuwhEQFSOIgF4t+iTyEGyf1Gnc9T0A8nDX/kh2q0sda5SEb0UlVVpP?=
 =?us-ascii?Q?ngA45Cq62deI8a1l2Y0asmQVUcBFB2XblayE1jYiLfFJCqR1ynIgALIy/lBT?=
 =?us-ascii?Q?KGLgJRwHP4LxHFOKqfDtO5ouA6UnNnTu0pzP9YE2/qbSaMyyxKjkb4pFgXCI?=
 =?us-ascii?Q?SfTws+SWeMrt0OFnYDSn+wAZ+RwwYOS+yDN1XbekTws8X07E765cz0eAQpih?=
 =?us-ascii?Q?ZCm9IiMsj2gdL1Bm9dMx4JJhWn5rlMMWp43OwZ7sMbxeRu8wcXpVJQPZIw3c?=
 =?us-ascii?Q?nfkwn67hkDny+ySGQ95IPUOsuc369aXoTSUNmSt3BoTuqvzPCFy+nBrnffP5?=
 =?us-ascii?Q?z7c6LsbEe5pPkg5PDZ8/RHbkAa+nbA3MYXYFwClBWJbTQByqvV8OFDG56M5c?=
 =?us-ascii?Q?j8iWS0vg4Vi0cDSpowxQruxZxGQdn7GMLZGP9pXe0hdFcpa8HLjr4vm2+KfU?=
 =?us-ascii?Q?Zq9G4byqEefZRp84A3YC1Nmu3uVDBcMZfa1xmvT+LP67bwzAfQMjXwYwFnN0?=
 =?us-ascii?Q?IRNqvtG4ekBtkWf07n2q+c59vTlVPNvo6IrbezqHb2xcRgjX18O/L09IT5ev?=
 =?us-ascii?Q?hZJtn6UdToySYjCxs/jpHvqMv5Zn9ReJcRcqGLhmBmibNYpyyjLin+kjuxAP?=
 =?us-ascii?Q?7BroZvNfUKZYnJ5BV5Npm4WChXez/Uj7XCO012/GdXMNLv9AIHsMgF+Gn4Ta?=
 =?us-ascii?Q?m5/iwPkKMcHrLGxwlgHiWSMkRnvsdzNxKEojl8rml+S/v7qdXXcs/hgbLZDJ?=
 =?us-ascii?Q?xyRSxnQWQOMaJJfL+92YS/f6MxMlls2HCvCfmJq8ZwqElMTROU5IK69IveZX?=
 =?us-ascii?Q?ptVMt8I1OcP6zBUFg/s0uO60TOeDJBn/3H+Wnh+5NYCyWBr6M+8xx0P3fOZW?=
 =?us-ascii?Q?5iUCoWuK0w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efaf7e2f-2c12-4030-e10a-08de605bc9c1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:00:47.8407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIKQ6o3iSk0xFhHu7df1odvrDedt5MUPm671J7t9vco473QuijDHFr+EYQeZQIIz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

The RISC-V format is a fairly simple 5 level page table not unlike the x86
one. It has optional support for a single contiguous page size of 64k (16
x 4k).

The specification describes a 32-bit format, the general code can support
it via a #define but the iommu side implementation has been left off until
a user comes.

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |  11 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 include/linux/generic_pt/common.h            |  16 +
 include/linux/generic_pt/iommu.h             |  11 +
 8 files changed, 394 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index a78b295f264d23..0bb98fe581fe9c 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -5,6 +5,7 @@ CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
 CONFIG_IOMMU_PT_VTDSS=y
+CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index ce4fb478691457..f4ed1add58b749 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -52,6 +52,16 @@ config IOMMU_PT_VTDSS
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_RISCV64
+       tristate "IOMMU page table for RISC-V 64 bit Sv57/Sv48/Sv39"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for RISC-V 64 bit 3/4/5 level page table.
+	  It supports 4K/2M/1G/512G/256T page sizes and can decode a sign
+	  extended portion of the 64 bit IOVA space.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_X86_64
 	tristate "IOMMU page table for x86 64-bit, 4/5 levels"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -66,6 +76,7 @@ config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
 	default KUNIT_ALL_TESTS
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 976b49ec97dca1..ea024d582594ee 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -5,6 +5,8 @@ iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/defs_riscv.h b/drivers/iommu/generic_pt/fmt/defs_riscv.h
new file mode 100644
index 00000000000000..cf67474d5ebaeb
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_riscv.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_RISCV_H
+#define __GENERIC_PT_FMT_DEFS_RISCV_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+#ifdef PT_RISCV_32BIT
+typedef u32 pt_riscv_entry_t;
+#define riscvpt_write_attrs riscv32pt_write_attrs
+#else
+typedef u64 pt_riscv_entry_t;
+#define riscvpt_write_attrs riscv64pt_write_attrs
+#endif
+
+typedef pt_riscv_entry_t pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct riscvpt_write_attrs {
+	pt_riscv_entry_t descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs riscvpt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_riscv64.c b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
new file mode 100644
index 00000000000000..cbf60fffa9bf7d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT riscv
+#define PT_FMT_VARIANT 64
+#define PT_SUPPORTED_FEATURES                                  \
+	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
+	 BIT(PT_FEAT_RISCV_SVNAPOT_64K))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/riscv.h b/drivers/iommu/generic_pt/fmt/riscv.h
new file mode 100644
index 00000000000000..a7fef6266a36a6
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/riscv.h
@@ -0,0 +1,313 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ *
+ * RISC-V page table
+ *
+ * This is described in Sections:
+ *  12.3. Sv32: Page-Based 32-bit Virtual-Memory Systems
+ *  12.4. Sv39: Page-Based 39-bit Virtual-Memory System
+ *  12.5. Sv48: Page-Based 48-bit Virtual-Memory System
+ *  12.6. Sv57: Page-Based 57-bit Virtual-Memory System
+ * of the "The RISC-V Instruction Set Manual: Volume II"
+ *
+ * This includes the contiguous page extension from:
+ *  Chapter 13. "Svnapot" Extension for NAPOT Translation Contiguity,
+ *     Version 1.0
+ *
+ * The table format is sign extended and supports leafs in every level. The spec
+ * doesn't talk a lot about levels, but level here is the same as i=LEVELS-1 in
+ * the spec.
+ */
+#ifndef __GENERIC_PT_FMT_RISCV_H
+#define __GENERIC_PT_FMT_RISCV_H
+
+#include "defs_riscv.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+#include <linux/sizes.h>
+
+enum {
+	PT_ITEM_WORD_SIZE = sizeof(pt_riscv_entry_t),
+#ifdef PT_RISCV_32BIT
+	PT_MAX_VA_ADDRESS_LG2 = 32,
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 34,
+	PT_MAX_TOP_LEVEL = 1,
+#else
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 56,
+	PT_MAX_TOP_LEVEL = 4,
+#endif
+	PT_GRANULE_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+
+	/* fsc.PPN is 44 bits wide, all PPNs are 4k aligned */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(55, 12),
+};
+
+/* PTE bits */
+enum {
+	RISCVPT_V = BIT(0),
+	RISCVPT_R = BIT(1),
+	RISCVPT_W = BIT(2),
+	RISCVPT_X = BIT(3),
+	RISCVPT_U = BIT(4),
+	RISCVPT_G = BIT(5),
+	RISCVPT_A = BIT(6),
+	RISCVPT_D = BIT(7),
+	RISCVPT_RSW = GENMASK(9, 8),
+	RISCVPT_PPN32 = GENMASK(31, 10),
+
+	RISCVPT_PPN64 = GENMASK_ULL(53, 10),
+	RISCVPT_PPN64_64K = GENMASK_ULL(53, 14),
+	RISCVPT_PBMT = GENMASK_ULL(62, 61),
+	RISCVPT_N = BIT_ULL(63),
+
+	/* Svnapot encodings for ppn[0] */
+	RISCVPT_PPN64_64K_SZ = BIT(13),
+};
+
+#ifdef PT_RISCV_32BIT
+#define RISCVPT_PPN RISCVPT_PPN32
+#define pt_riscv pt_riscv_32
+#else
+#define RISCVPT_PPN RISCVPT_PPN64
+#define pt_riscv pt_riscv_64
+#endif
+
+#define common_to_riscvpt(common_ptr) \
+	container_of_const(common_ptr, struct pt_riscv, common)
+#define to_riscvpt(pts) common_to_riscvpt((pts)->range->common)
+
+static inline pt_oaddr_t riscvpt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(RISCVPT_PPN, pts->entry), PT_GRANULE_LG2SZ);
+}
+#define pt_table_pa riscvpt_table_pa
+
+static inline pt_oaddr_t riscvpt_entry_oa(const struct pt_state *pts)
+{
+	if (pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K) &&
+	    pts->entry & RISCVPT_N) {
+		PT_WARN_ON(pts->level != 0);
+		return oalog2_mul(FIELD_GET(RISCVPT_PPN64_64K, pts->entry),
+				  ilog2(SZ_64K));
+	}
+	return oalog2_mul(FIELD_GET(RISCVPT_PPN, pts->entry), PT_GRANULE_LG2SZ);
+}
+#define pt_entry_oa riscvpt_entry_oa
+
+static inline bool riscvpt_can_have_leaf(const struct pt_state *pts)
+{
+	return true;
+}
+#define pt_can_have_leaf riscvpt_can_have_leaf
+
+/* Body in pt_fmt_defaults.h */
+static inline unsigned int pt_table_item_lg2sz(const struct pt_state *pts);
+
+static inline unsigned int
+riscvpt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_RISCV_SVNAPOT_64K) &&
+	    pts->entry & RISCVPT_N) {
+		PT_WARN_ON(!pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K));
+		PT_WARN_ON(pts->level);
+		return ilog2(16);
+	}
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 riscvpt_entry_num_contig_lg2
+
+static inline unsigned int riscvpt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 riscvpt_num_items_lg2
+
+static inline unsigned short
+riscvpt_contig_count_lg2(const struct pt_state *pts)
+{
+	if (pts->level == 0 && pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K))
+		return ilog2(16);
+	return ilog2(1);
+}
+#define pt_contig_count_lg2 riscvpt_contig_count_lg2
+
+static inline enum pt_entry_type riscvpt_load_entry_raw(struct pt_state *pts)
+{
+	const pt_riscv_entry_t *tablep = pt_cur_table(pts, pt_riscv_entry_t);
+	pt_riscv_entry_t entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & RISCVPT_V))
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    ((entry & (RISCVPT_X | RISCVPT_W | RISCVPT_R)) != 0))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw riscvpt_load_entry_raw
+
+static inline void
+riscvpt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	pt_riscv_entry_t *tablep = pt_cur_table(pts, pt_riscv_entry_t);
+	pt_riscv_entry_t entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	entry = RISCVPT_V |
+		FIELD_PREP(RISCVPT_PPN, log2_div(oa, PT_GRANULE_LG2SZ)) |
+		attrs->descriptor_bits;
+
+	if (pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K) && pts->level == 0 &&
+	    oasz_lg2 != PT_GRANULE_LG2SZ) {
+		u64 *end;
+
+		entry |= RISCVPT_N | RISCVPT_PPN64_64K_SZ;
+		tablep += pts->index;
+		end = tablep + log2_div(SZ_64K, PT_GRANULE_LG2SZ);
+		for (; tablep != end; tablep++)
+			WRITE_ONCE(*tablep, entry);
+	} else {
+		/* FIXME does riscv need this to be cmpxchg? */
+		WRITE_ONCE(tablep[pts->index], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry riscvpt_install_leaf_entry
+
+static inline bool riscvpt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	pt_riscv_entry_t entry;
+
+	entry = RISCVPT_V |
+		FIELD_PREP(RISCVPT_PPN, log2_div(table_pa, PT_GRANULE_LG2SZ));
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table riscvpt_install_table
+
+static inline void riscvpt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits =
+		pts->entry & (RISCVPT_R | RISCVPT_W | RISCVPT_X | RISCVPT_U |
+			      RISCVPT_G | RISCVPT_A | RISCVPT_D);
+}
+#define pt_attr_from_entry riscvpt_attr_from_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_riscv_64
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->riscv_64pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, riscv_64pt.common)
+			->iommu;
+}
+
+static inline int riscvpt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	u64 pte;
+
+	pte = RISCVPT_A | RISCVPT_U;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= RISCVPT_W | RISCVPT_R | RISCVPT_D;
+	if (iommu_prot & IOMMU_READ)
+		pte |= RISCVPT_R;
+	if (!(iommu_prot & IOMMU_NOEXEC))
+		pte |= RISCVPT_X;
+
+	/* Caller must specify a supported combination of flags */
+	if (unlikely((pte & (RISCVPT_X | RISCVPT_W | RISCVPT_R)) == 0))
+		return -EOPNOTSUPP;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot riscvpt_iommu_set_prot
+
+static inline int
+riscvpt_iommu_fmt_init(struct pt_iommu_riscv_64 *iommu_table,
+		       const struct pt_iommu_riscv_64_cfg *cfg)
+{
+	struct pt_riscv *table = &iommu_table->riscv_64pt;
+
+	switch (cfg->common.hw_max_vasz_lg2) {
+	case 39:
+		pt_top_set_level(&table->common, 2);
+		break;
+	case 48:
+		pt_top_set_level(&table->common, 3);
+		break;
+	case 57:
+		pt_top_set_level(&table->common, 4);
+		break;
+	default:
+		return -EINVAL;
+	}
+	table->common.max_oasz_lg2 =
+		min(PT_MAX_OUTPUT_ADDRESS_LG2, cfg->common.hw_max_oasz_lg2);
+	return 0;
+}
+#define pt_iommu_fmt_init riscvpt_iommu_fmt_init
+
+static inline void
+riscvpt_iommu_fmt_hw_info(struct pt_iommu_riscv_64 *table,
+			  const struct pt_range *top_range,
+			  struct pt_iommu_riscv_64_hw_info *info)
+{
+	phys_addr_t top_phys = virt_to_phys(top_range->top_table);
+
+	info->ppn = oalog2_div(top_phys, PT_GRANULE_LG2SZ);
+	PT_WARN_ON(top_phys & ~PT_TOP_PHYS_MASK);
+
+	/*
+	 * See Table 3. Encodings of iosatp.MODE field" for DC.tx.SXL = 0:
+	 *  8 = Sv39 = top level 2
+	 *  9 = Sv38 = top level 3
+	 *  10 = Sv57 = top level 4
+	 */
+	info->fsc_iosatp_mode = top_range->top_level + 6;
+}
+#define pt_iommu_fmt_hw_info riscvpt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_riscv_64_cfg riscv_64_kunit_fmt_cfgs[] = {
+	[0] = { .common.features = BIT(PT_FEAT_RISCV_SVNAPOT_64K),
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 39 },
+	[1] = { .common.features = 0,
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 48 },
+	[2] = { .common.features = BIT(PT_FEAT_RISCV_SVNAPOT_64K),
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 57 },
+};
+#define kunit_fmt_cfgs riscv_64_kunit_fmt_cfgs
+enum {
+	KUNIT_FMT_FEATURES = BIT(PT_FEAT_RISCV_SVNAPOT_64K),
+};
+#endif
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 6a9a1acb5aad37..fc5d0b5edadc08 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -175,6 +175,22 @@ enum {
 	PT_FEAT_VTDSS_FORCE_WRITEABLE,
 };
 
+struct pt_riscv_32 {
+	struct pt_common common;
+};
+
+struct pt_riscv_64 {
+	struct pt_common common;
+};
+
+enum {
+	/*
+	 * Support the 64k contiguous page size following the Svnapot extension.
+	 */
+	PT_FEAT_RISCV_SVNAPOT_64K = PT_FEAT_FMT_START,
+
+};
+
 struct pt_x86_64 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 9eefbb74efd087..49d9addb98c52c 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -275,6 +275,17 @@ struct pt_iommu_vtdss_hw_info {
 
 IOMMU_FORMAT(vtdss, vtdss_pt);
 
+struct pt_iommu_riscv_64_cfg {
+	struct pt_iommu_cfg common;
+};
+
+struct pt_iommu_riscv_64_hw_info {
+	u64 ppn;
+	u8 fsc_iosatp_mode;
+};
+
+IOMMU_FORMAT(riscv_64, riscv_64pt);
+
 struct pt_iommu_x86_64_cfg {
 	struct pt_iommu_cfg common;
 	/* 4 is a 57 bit 5 level table */
-- 
2.43.0

