Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E8AF9D4;
	Tue, 14 May 2024 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687836; cv=none; b=XCABD/j5+dkJQuPtoaAFwhEBw4NyQ/AKT8Qhy+eTrMTmKTPNaSuEH5tnqFCZJsCTvimjxXtAuzufIxqXAkLBV2ygyBZ/2AgXxibW2c9rL+IK3PKta3UWr2mRK1lIFa/BsodbTM0OAwKlPN0l9uWiKdc+ZCkGP6nVOvYwx4Qpqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687836; c=relaxed/simple;
	bh=EYbikkwR5l2RZBWzaSnYIYntwu6Vs12sn40emkBxiYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6KixKcnabuUjPKh8L5O9+pgUHqwveBWCAoUU3rsaD4os22ThKsbIvawI951jDBDcoBFxOwgOb+cVjM5macEQS5tlu2kXBHsRq4WWsaBhwheXFGLJV8J69EKHI39+2BY2+taVWtc051TUasOzUn1A2v0xrsCtLuw3bRulQrr0NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKidl5z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKidl5z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394EC32781;
	Tue, 14 May 2024 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687835;
	bh=EYbikkwR5l2RZBWzaSnYIYntwu6Vs12sn40emkBxiYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKidl5z0ztxd9oAfIFIBkh3FW/LlAfYneNtBPoaIG0N2kxlrD0o1qr5r3z+TgQN8I
	 Q8KTE93ZSbn8XhE3EUOUCbugeGIagGG9qT+5FpieoWaQBV8bvqPTPCP7m0V/3y1UFT
	 qOMjpDp2sqXnkrA9Lsx+1P92QZi+QRGFJt5htVOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/168] net: hns3: refactor hns3 makefile to support hns3_common module
Date: Tue, 14 May 2024 12:20:20 +0200
Message-ID: <20240514101011.289793958@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 5f20be4e90e603d8967962f81ac89307fd4f8af9 ]

Currently we plan to refactor PF and VF cmdq module. A new file folder
hns3_common will be created to store new common APIs used by PF and VF
cmdq module. Thus the PF and VF compilation process will both depends on
the hns3_common. This may cause parallel building problems if we add a new
makefile building unit.

So this patch combined the PF and VF makefile scripts to the top level
makefile to support the new hns3_common which will be created in the next
patch.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6639a7b95321 ("net: hns3: change type of numa_node_mask as nodemask_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile       | 14 +++++++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    | 12 ------------
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    | 10 ----------
 3 files changed, 11 insertions(+), 25 deletions(-)
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 7aa2fac76c5e8..32e24e0945f5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -4,9 +4,8 @@
 #
 
 ccflags-y += -I$(srctree)/$(src)
-
-obj-$(CONFIG_HNS3) += hns3pf/
-obj-$(CONFIG_HNS3) += hns3vf/
+ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3pf
+ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3vf
 
 obj-$(CONFIG_HNS3) += hnae3.o
 
@@ -14,3 +13,12 @@ obj-$(CONFIG_HNS3_ENET) += hns3.o
 hns3-objs = hns3_enet.o hns3_ethtool.o hns3_debugfs.o
 
 hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
+
+obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
+hclgevf-objs = hns3vf/hclgevf_main.o hns3vf/hclgevf_cmd.o hns3vf/hclgevf_mbx.o  hns3vf/hclgevf_devlink.o
+
+obj-$(CONFIG_HNS3_HCLGE) += hclge.o
+hclge-objs = hns3pf/hclge_main.o hns3pf/hclge_cmd.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
+		hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf/hclge_ptp.o hns3pf/hclge_devlink.o
+
+hclge-$(CONFIG_HNS3_DCB) += hns3pf/hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
deleted file mode 100644
index d1bf5c4c0abbc..0000000000000
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ /dev/null
@@ -1,12 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0+
-#
-# Makefile for the HISILICON network device drivers.
-#
-
-ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
-ccflags-y += -I $(srctree)/$(src)
-
-obj-$(CONFIG_HNS3_HCLGE) += hclge.o
-hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o hclge_ptp.o hclge_devlink.o
-
-hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
deleted file mode 100644
index 51ff7d86ee906..0000000000000
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0+
-#
-# Makefile for the HISILICON network device drivers.
-#
-
-ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
-ccflags-y += -I $(srctree)/$(src)
-
-obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
-hclgevf-objs = hclgevf_main.o hclgevf_cmd.o hclgevf_mbx.o  hclgevf_devlink.o
-- 
2.43.0



