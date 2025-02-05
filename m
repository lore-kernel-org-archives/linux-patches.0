Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7DB15CD74;
	Wed,  5 Feb 2025 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766969; cv=none; b=MqDinIYgAGCvDUaut9dhZ0fH0HOD3L6TJhRsY/rrS9ukhmPZ4YLvGxzCqVMdHp3Yta3c8XtmyLf2zkozuST/t0xsA139Jhb55cdDaTP/9Sutyc2JEn0j4TmQinr75GhBSBeyZMNCU7SBQJRcB0kkprh2/2YSZfM6w+/sPYstzcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766969; c=relaxed/simple;
	bh=ShT6SaJKFEyD8UmZkDfbHnHEDuyytSgXH6ziMKzw2mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh+6/80i0a6godnr0pGRfxs1uPDMYg4cmnopwtWZH54JJB1sE0crbdxyrKkVl12br2wsyK6ucsau63DJQKT7oQNVhQYxYTmTuIZ6TYqybMJHgdTSPcucUnkI/mbwrSGWUOu4jPL7JJ7OBA8g0f6r3GpnbjGNKAa/28tChKtesTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtECIihJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtECIihJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434DAC4CED1;
	Wed,  5 Feb 2025 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766969;
	bh=ShT6SaJKFEyD8UmZkDfbHnHEDuyytSgXH6ziMKzw2mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtECIihJYRYl1cEZ281ITiA7JvZVw1x/KdYpBsvcLtrBoQh3P/SrtvHf3vFWkXjT3
	 PQSU38mKs1gACqGULKeblZ4hX/lzIVHyHgg2vy03TMN6ZdQMrThlGfAvxc05Qktf6H
	 TIblQM+Us95uTjQzBM/MoD9EpG1INmXSlS6wUqYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/590] RDMA/hns: Clean up the legacy CONFIG_INFINIBAND_HNS
Date: Wed,  5 Feb 2025 14:42:04 +0100
Message-ID: <20250205134509.387389210@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 8977b561216c7e693d61c6442657e33f134bfeb5 ]

hns driver used to support hip06 and hip08 devices with
CONFIG_INFINIBAND_HNS_HIP06 and CONFIG_INFINIBAND_HNS_HIP08
respectively, which both depended on CONFIG_INFINIBAND_HNS.

But we no longer provide support for hip06 and only support
hip08 and higher since the commit in fixes line, so there is
no need to have CONFIG_INFINIBAND_HNS any more. Remove it and
only keep CONFIG_INFINIBAND_HNS_HIP08.

Fixes: 38d220882426 ("RDMA/hns: Remove support for HIP06")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250106111211.3945051-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/Makefile     |  2 +-
 drivers/infiniband/hw/hns/Kconfig  | 20 +++++---------------
 drivers/infiniband/hw/hns/Makefile |  9 +++------
 3 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 1211f4317a9f4..aba96ca9bce5d 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_VMWARE_PVRDMA)	+= vmw_pvrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
-obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
+obj-$(CONFIG_INFINIBAND_HNS_HIP08)	+= hns/
 obj-$(CONFIG_INFINIBAND_QEDR)		+= qedr/
 obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
 obj-$(CONFIG_INFINIBAND_ERDMA)		+= erdma/
diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
index ab3fbba70789c..44cdb706fe276 100644
--- a/drivers/infiniband/hw/hns/Kconfig
+++ b/drivers/infiniband/hw/hns/Kconfig
@@ -1,21 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config INFINIBAND_HNS
-	tristate "HNS RoCE Driver"
-	depends on NET_VENDOR_HISILICON
-	depends on ARM64 || (COMPILE_TEST && 64BIT)
-	depends on (HNS_DSAF && HNS_ENET) || HNS3
-	help
-	  This is a RoCE/RDMA driver for the Hisilicon RoCE engine.
-
-	  To compile HIP08 driver as module, choose M here.
-
 config INFINIBAND_HNS_HIP08
-	bool "Hisilicon Hip08 Family RoCE support"
-	depends on INFINIBAND_HNS && PCI && HNS3
-	depends on INFINIBAND_HNS=m || HNS3=y
+	tristate "Hisilicon Hip08 Family RoCE support"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on PCI && HNS3
 	help
 	  RoCE driver support for Hisilicon RoCE engine in Hisilicon Hip08 SoC.
 	  The RoCE engine is a PCI device.
 
-	  To compile this driver, choose Y here: if INFINIBAND_HNS is m, this
-	  module will be called hns-roce-hw-v2.
+	  To compile this driver, choose M here. This module will be called
+	  hns-roce-hw-v2.
diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
index be1e1cdbcfa8a..7917af8e6380e 100644
--- a/drivers/infiniband/hw/hns/Makefile
+++ b/drivers/infiniband/hw/hns/Makefile
@@ -5,12 +5,9 @@
 
 ccflags-y :=  -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
 
-hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
+hns-roce-hw-v2-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
 	hns_roce_ah.o hns_roce_hem.o hns_roce_mr.o hns_roce_qp.o \
 	hns_roce_cq.o hns_roce_alloc.o hns_roce_db.o hns_roce_srq.o hns_roce_restrack.o \
-	hns_roce_debugfs.o
+	hns_roce_debugfs.o hns_roce_hw_v2.o
 
-ifdef CONFIG_INFINIBAND_HNS_HIP08
-hns-roce-hw-v2-objs := hns_roce_hw_v2.o $(hns-roce-objs)
-obj-$(CONFIG_INFINIBAND_HNS) += hns-roce-hw-v2.o
-endif
+obj-$(CONFIG_INFINIBAND_HNS_HIP08) += hns-roce-hw-v2.o
-- 
2.39.5



