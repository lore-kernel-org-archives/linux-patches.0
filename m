Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D31170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAB9C433C7;
	Mon, 11 Sep 2023 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441957;
	bh=Sf1Rjgjsd7iuK6Bw9YICZMnl3gfib8g6UNQXZfW4X3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMeZ7vrzkpP4SN0B54L3c2MInvSkW2z6CzkzVmumRsIa7WR0QACGFRaW7kJ4QXbH6
	 9oCyokh95O2RsNxA1MnlqrBfYG7WpBUQYKw9L4UOrHN4GsCf4+y52wL+Sb7GzavLvs
	 CP8/YAuzbC/BBgNHFezjMb1FIaRFuHuX63ncEIy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Zhang <rex.zhang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 596/739] dmaengine: idxd: Modify the dependence of attribute pasid_enabled
Date: Mon, 11 Sep 2023 15:46:35 +0200
Message-ID: <20230911134707.748971641@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Zhang <rex.zhang@intel.com>

[ Upstream commit 50c5e6f41d5ad7c731c31135a30d0e4f0e4fea26 ]

Kernel PASID and user PASID are separately enabled. User needs to know the
user PASID enabling status to decide how to use IDXD device in user space.
This is done via the attribute /sys/bus/dsa/devices/dsa0/pasid_enabled.
It's unnecessary for user to know the kernel PASID enabling status because
user won't use the kernel PASID. But instead of showing the user PASID
enabling status, the attribute shows the kernel PASID enabling status. Fix
the issue by showing the user PASID enabling status in the attribute.

Fixes: 42a1b73852c4 ("dmaengine: idxd: Separate user and kernel pasid enabling")
Signed-off-by: Rex Zhang <rex.zhang@intel.com>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230614062706.1743078-1-rex.zhang@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 293739ac55969..b6a0a12412afd 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1480,7 +1480,7 @@ static ssize_t pasid_enabled_show(struct device *dev,
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
-	return sysfs_emit(buf, "%u\n", device_pasid_enabled(idxd));
+	return sysfs_emit(buf, "%u\n", device_user_pasid_enabled(idxd));
 }
 static DEVICE_ATTR_RO(pasid_enabled);
 
-- 
2.40.1



