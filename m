Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8CC1AB6C9;
	Tue,  3 Dec 2024 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241337; cv=none; b=ml1jyhYQdxw6FolQP8Ze+dYVCeiDp8YfyGf3mEgiHs8hQ5FGBfoKTrswMwJml0kwvtA32NKDaqv6MGdewRjsix9hJ9IN8ZdKIhHkrBkhOUxOCwZXe9CfH5XLi7oMiudVgqYvbAT9mIGafDw3AzVcgBWFySyCZzRNrftgEH7BMDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241337; c=relaxed/simple;
	bh=nkwfEBm5iG9GbY23q9AzEJ0YNOFz8Xge4bzozwOOuGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjnQ9N61oo/2DAVCJq1+SzIXWDi2IeUbmYhRCmkw6PwozrvLWlZ7WGTZymXkH1KbCKOqAAIoV1Ttst3OpiF3WCbMykPhaw0/ruTsfl1C5DWIdOLTmVSbjP2TZJjFFvMdgRvq9TXMxgVLaXLeBU5hgZgQFEhxhPkD6tQDPhvFxbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcrLPdwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcrLPdwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C233BC4CED6;
	Tue,  3 Dec 2024 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241337;
	bh=nkwfEBm5iG9GbY23q9AzEJ0YNOFz8Xge4bzozwOOuGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcrLPdwxZAsGdo+6+VmxbKNO7+0OSAdhdGj7Rw4yaexuGlHXJMeQcBLAY9uAEz10S
	 pZEcHDdOcjxHMgNxC8T/WfegMKJ6OZowEIr0Mht54aUybBYeqWz+drvn/P7Ou9oo4D
	 dlNC2xGpjjcnfAj0sC+N6r1EmQcWrQFy/HVPgb9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuyu Li <liyuyu6@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/826] RDMA/hns: Modify debugfs name
Date: Tue,  3 Dec 2024 15:41:59 +0100
Message-ID: <20241203144759.052270534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuyu Li <liyuyu6@huawei.com>

[ Upstream commit 370a9351bf84afc5a56a3f02ba3805bbfcb53c32 ]

The sub-directory of hns_roce debugfs is named after the device's
kernel name currently, but it will be inconvenient to use when
the device is renamed.

Modify the name to pci name as users can always easily find the
correspondence between an RDMA device and its pci name.

Fixes: eb7854d63db5 ("RDMA/hns: Support SW stats with debugfs")
Signed-off-by: Yuyu Li <liyuyu6@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241024124000.2931869-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_debugfs.c b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
index e8febb40f6450..b869cdc541189 100644
--- a/drivers/infiniband/hw/hns/hns_roce_debugfs.c
+++ b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
@@ -5,6 +5,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/pci.h>
 
 #include "hns_roce_device.h"
 
@@ -86,7 +87,7 @@ void hns_roce_register_debugfs(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_dev_debugfs *dbgfs = &hr_dev->dbgfs;
 
-	dbgfs->root = debugfs_create_dir(dev_name(&hr_dev->ib_dev.dev),
+	dbgfs->root = debugfs_create_dir(pci_name(hr_dev->pci_dev),
 					 hns_roce_dbgfs_root);
 
 	create_sw_stat_debugfs(hr_dev, dbgfs->root);
-- 
2.43.0



