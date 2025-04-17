Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078822371B
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744907183; cv=fail; b=P/fMUxMt4DVxKsP0Zpaw0Rf8XHqbC3N3EaWwO540sEq0DbmG9FX4rSe7Ni5WuvRQpsK7lWGUpKv6E0cn81CVPnzG8X1cCSTHiwKVaCoBopCJDO3aIDxyz0Jw9+8Y6U34XQc+qIMlq/5jmJxbax/r5rj9zbqOVD8GKdE2mLx8tsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744907183; c=relaxed/simple;
	bh=OKlc/XQmFCmh4dSM/R2o1rs9nplgVtfu1zWbuPSLmY4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Dl4Lf4whryntdnsS1gWk4DnNexz02bKcCio/GxJinIEwpTAc2tYvvB8lp9tzPlp6kHtiLp6AQ0t2GQcL8nr5ZLq9pKLNQRx1tjPHD+kHOapaaR21O2YeCDgJv8A31z1wF/RpFfXqCAo+kYaTC3VeihPdSab0wk8/eOkAHrTstDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jig0oK7t; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jig0oK7t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x4x7NXaacVuSVUhEQW9HBW+g6g0dk26B+zBOBxZ7aE3U23yDniZiAr3JigiK2jih37yHRRFRtAeV6ScS0XHF9lGMBq9liJOOrnH8oTIMqGgP0zKdzIv3m6TDO0m1Q8OQA0VuUXi6PMHfpg+G/PLX3BIuhx0BaqU5Rd2GMW+Qj7LElc4Uk7YCEDANByc4YRtEcBjGTObGPbhVaaCWi5hzkNgU64AIufFXZaXF0d+1/VNWBizFXnxoeOap/kS6iIVNOAqUyh8gF3NCdcK/zPoDhq1XwREJjf5soArpL/ldp07gKXDZcdEUKpKK4vpvCvkEhyOXSX7dZpc7OWtgLd+DTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWlajyrKhq2ZhjdhB/AiFuN7J0cES8P2c9bpY8UBhro=;
 b=m3/dzwPY2aXXYDwq72C06sG2YNuxdNWJM/mFrkvveRwuqzpalQza5cr/TuP13gLe+WaS9NCWGGAa3AWkuQph1FZAZUGVUHPA+3Q3a0n+8NHWAzgQF9+oqF4uKr2juD9cE2IB8/FV8GdpZ8Rj12JJI6TTTShSnCfLic0EoP39RX25b0jPWfZjU7xFxC71CiSNROGqrb0bEIMsj4XErb798ly1/Dq6lrPiat/7oZaLeFYETkrhtUbm/Wqrwx2oxZ+4feyzqh75c64VKtKd+DC5wYP+gM8R7GikqL1++hIpzhiBjOAMy65+FMfZiIUNaoEKkRd/ZIU6tJ58u/sK2U7Y9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWlajyrKhq2ZhjdhB/AiFuN7J0cES8P2c9bpY8UBhro=;
 b=jig0oK7tveOXDPrIH5zHqo/nyht7hUXkISE68E3r+lMjwwZiC361WGPmzrvqZMQqWmro/I179lf+nt4wTUfaexp43rLgiE5k5ClheSt3CFoCR08+wg0JNhyYxuTrntFyGrJrfeChY1rzowfQgerOy9aM+ianP78UkMAH3rYS1Awlm6uuwYTF07H3lFM+kGiRKz/e6zNPyZCEEP1ZlHl8gP6hNjj+SzvkH7MIhfqp+2Qa3KxtOPBOR55s0x8/w4mDyIFlPYx6q30Fe0dXhgvGT2xvwVc9IqXp6i8cUnqiLsxw3FYmMK3lgHg01eaI38EzXMmen062LYEc4xAsZn8C2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8211.namprd12.prod.outlook.com (2603:10b6:610:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.48; Thu, 17 Apr
 2025 16:26:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 16:26:18 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] arm: Add missing includes for mem_encrypt
Date: Thu, 17 Apr 2025 13:26:16 -0300
Message-ID: <0-v1-47aadfbd64cd+25795-arm_memenc_h_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR12CA0010.namprd12.prod.outlook.com
 (2603:10b6:408:60::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: 75bcd62d-9b35-4fbf-2646-08dd7dcc94c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cbjXz+BmevjdNTvpbjWL0jR17AlAq1McflL6yAWkDYgjdpvFDh+KSAp20qXH?=
 =?us-ascii?Q?E034Zx0uNEJTf3jvH0FwBQYcE7ZZYfaGTCicR2WQ81TcxdXU93jtZ1cX6Y16?=
 =?us-ascii?Q?iVjZRmH+ylqlkDGqFxL2ZnuLRshrR5GFa+XX6M0f64IL6Y1qUj8WU3bfa6eo?=
 =?us-ascii?Q?NfOk5rrAigv5fxgBV/IpgmHWuJmvS3y2YYtMlfPYVNy6Hv7wvUrzcmGC/GZp?=
 =?us-ascii?Q?RHVUhiq13Un5IuR6yqM1m0OsAUgHF/uUkdVeWX3FSm4Ng8e/HkzPU6GZe39S?=
 =?us-ascii?Q?V8ENhkju1dLWPG++lL8097MDCaPCIBg6xVpBc0tPub7ocPpKLb7Zyt9VHklQ?=
 =?us-ascii?Q?un81LYjk0d5/VrjkcTjQALzjm/uVXgJlWVdm5y8T8F/gluLYd/gkP+EJjxwx?=
 =?us-ascii?Q?rSVy/GrmIe48kMupFVkEzG/1BtbridW3FRAKAPxD9t6ZEygScF5r9m5T/Rhh?=
 =?us-ascii?Q?3OQN4WHodKh8xNyv0XaQMPZqVnoDZi4orargImkh77XjcA6oH6YZrDJmMFHl?=
 =?us-ascii?Q?qzc2T3qugxr5vSgDnQwUy2whdHBCZ0raaWSk56mZvDt0zrjFZH8mYQcNp0Xh?=
 =?us-ascii?Q?meHeFpjeoqgYdihvOI5ekEglUV2x/enf9rZHW/2SlHJvHxfWjDvKemYM6RM/?=
 =?us-ascii?Q?kADztBcjNC7tiz+F4EJytj91zU3xExEgw6xzGHuQzBkBR+c2vgRSeW4CEk0m?=
 =?us-ascii?Q?bFd8hDmoP0SJvf0HnGOb5IUGCyVF5noljWwmWFH17mcSpoj0UQzjAVaubFUx?=
 =?us-ascii?Q?GrrGewvpVZxH3WceGrc5gGOWhhqW5wN4PoyiP3kHmuG7Iv964JnGTndwYoBw?=
 =?us-ascii?Q?HTOElTSAT22h6z+O8qjp/RmYj+2O/ikL7BwUd8QVgeWweDzZRLX+EKUx72YY?=
 =?us-ascii?Q?OYHmq73mG3Ub/8uP1kmdM4cRAMnjwCofa+GO300rucm5YW/ajFTx1jzpIPrE?=
 =?us-ascii?Q?GFujyVNq4+j3nwfV57VbMxl5LY3uhFAuOhG7SdsHk7Bm6qJaHuqVh0hEzPRU?=
 =?us-ascii?Q?yIiIToM6X9DXMynecEpQCCNZcKPHGx4PL/2S74s8kGtgu4xo40nndYWlHOqR?=
 =?us-ascii?Q?4kQJYUdyH8NByJTOuJ3GC7zI8y5sX5x/OhgJPayJQFpctoEcEygL1YhIqH1d?=
 =?us-ascii?Q?J0PvFyBBSYOlws9fYHgdUUTMrO/Hq9faAUf4t16b86+xBt+3FY+UOeKeFfMu?=
 =?us-ascii?Q?9NbfO4O+Zk957OkfBV1b8+U7N6c2wna+4uKKxiHmca0GDuGdCzhd21Y96qq1?=
 =?us-ascii?Q?/hDj0sKjd/Av5OrxnFmhj9wodzLCT+Ku65Xhwdbo68dqC1PkQbvpNeA3RQQd?=
 =?us-ascii?Q?hWRfox+eLQ7iaC+8yOwNrX55IP31G+yh8LhDwJFlbLVDAfuY3pS9C016bYTz?=
 =?us-ascii?Q?BZ+9/2VZ1WTmluAdQOVtjbGLVCZ5KQLEcmPAX79+SdEUwoNUnS3jd2NnloMV?=
 =?us-ascii?Q?/8VposeWRHo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hq3gymlO7R9ZzkjrmYnoLBrTJgyToI/DP1kc86taCoG22SK6TGD2hGIZLwLm?=
 =?us-ascii?Q?1Rymf/roQmKH8XWfP1BjPMRUW1zHYYffQdmlQXOX/1AGQrS9WS2i8adGkjMf?=
 =?us-ascii?Q?Eo2er+YXWaE0TZTMrXXcxUWwI4TjN/N/KnYT0oJ8U701u65SMpiHZgu+8PFT?=
 =?us-ascii?Q?Io9uOVLYeh7blr5RKcwUseTBaiMfuNZo8IQOxQfco8TfiGufNc2+NQ6IJzoF?=
 =?us-ascii?Q?wF4AtOe5ZTEuqFSBBsGBGXxhteP25Hj51KR5sU57/Ab+tvLwOt5zkJpoIZBy?=
 =?us-ascii?Q?wU2OhModJqJuk5H1GWLTAT9sHvDPNZcps5GpDoVz9+fXRCJ7+iwWlcH2C8eW?=
 =?us-ascii?Q?HDpA+lKJ6n3RO17c29bqnyLhonYQgCl2GM4fCGOfTwNoxJgHmhcd0cE0GtLC?=
 =?us-ascii?Q?yWmro17oanHjpf8wjiGuC4BwJrk9UaxhYvdtWw2QdW+iOxkpXLdTqyk2OoLm?=
 =?us-ascii?Q?cQ9h6m2gxBTTKsLNdVPyFQd7c6ipZGPrb0AfLfo3fJpnCP/Rsk4O5b+zSJ07?=
 =?us-ascii?Q?xR3e3npfkjieAA2Zz6LwF25jKrUKoo7QvhXNJR6h1mF2BKLoxoucyELAMKEh?=
 =?us-ascii?Q?0PmD9GALHd5Xe+Ch4+FlWgyS+5BbKEp9y1C+nS1cRg39m52zrGdHjQEPQLe2?=
 =?us-ascii?Q?4YyQqRP+nWnAqSGJ428r82k6cpDYZJ9aTLLyccdNdQS+K2RJKF7oQJXCV4TG?=
 =?us-ascii?Q?xbOkCErZvxfEcbOhPtalBrnC6zkHrV0LDVkFot6hwvmikDwE+kxYTsOQbam3?=
 =?us-ascii?Q?Wgt9AchAaOnCaPpQw8rIRISvyqlqxOvYHzQv8twoMTxkiPzXfzMee8Fkaeuw?=
 =?us-ascii?Q?9Sw/5kCeJvpDEx5/pJSkDamNMRosazkFsr0PuxusAUg6MyEoINsw+zgV+eCt?=
 =?us-ascii?Q?BbKFNIRfuBa5Qp+cAoqefUUpq0vGH0nd/UXa9A0exZ7IYczI+myPwyVWRZik?=
 =?us-ascii?Q?kYLoT8cYTI30d5Dxtxbx0Jck9DKWsccybfe0ALF6QwUarWLnM7jHK6aEfSKR?=
 =?us-ascii?Q?0MolcpdmWlfNAbhOzaZIyRLooTCz0DZ7HmR6kJIWUUAp141QnYzGfY2n/nnk?=
 =?us-ascii?Q?E79QuLZ4k6XZgBnFwt+F1fMxQH4zykhrEFnr2OE8HvDL4LvjZMTzQoh5SR+1?=
 =?us-ascii?Q?mqhYTntKqFjz9wN1nnKctU1R8ArMcf08Ur+DRqiPMrIBlay6Yde4i4zV7Y8X?=
 =?us-ascii?Q?eqlBH9mtXmdLC8cbRrNtnS7S+dlETDFQ94x9l3DKR/UN6xo7cscbHdLV28OE?=
 =?us-ascii?Q?UnIa9JYAyaO96i4d4IHJpKisTO3jrcxLdvWmMycRt71ov/VEgi8XBLJtSToj?=
 =?us-ascii?Q?fbeEyhLOmylYKFMiU0vY3w+uTm2ufXwfZC2sDkZXGY0RY9J7P9HCzysZeFvz?=
 =?us-ascii?Q?o86RcbRNWbaUJfOxdbvgP0NnI84YiIm9DO+yNdjTUAsBvCmEZyDwGknhzeT0?=
 =?us-ascii?Q?DEckWurpsnh3jbaWNUGm3g1I4e+j5iouIS2WIxw4MIJEnzQ2YTitA0yCf/e+?=
 =?us-ascii?Q?QuWi/CARvWGcstuzw3ku3FhjX919YrWyApS6vWhgzNZNLw3pfM87kZONMAKX?=
 =?us-ascii?Q?h2rr2Au6dG+v2tEHxZqSf7tfI+qU8xtN9SElf6pS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75bcd62d-9b35-4fbf-2646-08dd7dcc94c4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 16:26:18.1626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zcYvkK59eNrbmCJRjwpsc4ogDvEBp0uqKxjYTtXxbNMLekKU5zEtbd32iPDSM/f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8211

Doing:
 #include <linux/mem_encrypt.h>

Causes a bunch of compiler failures due to missing implicit includes that
don't happen on x86:

../arch/arm64/include/asm/rsi_cmds.h:117:2: error: call to undeclared library function 'memcpy' with type 'void *(void *, const void *, unsigned long)'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  117 |         memcpy(&regs.a1, challenge, size);

../arch/arm64/include/asm/mem_encrypt.h:19:49: warning: declaration of 'struct device' will not be visible outside of this function [-Wvisibility]
   19 | static inline bool force_dma_unencrypted(struct device *dev)

../arch/arm64/include/asm/rsi_cmds.h:44:38: error: call to undeclared function 'virt_to_phys'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   44 |         arm_smccc_smc(SMC_RSI_REALM_CONFIG, virt_to_phys(cfg),

Add the missing includes to the arch/arm headers to avoid this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/mem_encrypt.h | 2 ++
 arch/arm64/include/asm/rsi_cmds.h    | 2 ++
 2 files changed, 4 insertions(+)

I ran into this while working on a new series that uses mem_encrypt.h

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index a2a1eeb36d4b50..314b2b52025f87 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -4,6 +4,8 @@
 
 #include <asm/rsi.h>
 
+struct device;
+
 struct arm64_mem_crypt_ops {
 	int (*encrypt)(unsigned long addr, int numpages);
 	int (*decrypt)(unsigned long addr, int numpages);
diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index e6a211001bd38e..2c8763876dfb77 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -7,6 +7,8 @@
 #define __ASM_RSI_CMDS_H
 
 #include <linux/arm-smccc.h>
+#include <linux/string.h>
+#include <asm/memory.h>
 
 #include <asm/rsi_smc.h>
 

base-commit: 6a94d74b67461c203bce8090d677c6c110f67245
-- 
2.43.0

