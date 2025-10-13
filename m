Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E35F30CDA8;
	Mon, 13 Oct 2025 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369941; cv=none; b=UA9iIfPO+Ghdoz8fydOPznfVnQhMY6SnK8nV0jyD3Lujy7C9vMEANgt2umBMyAD77c84VgpUwuEdIdXGmaYGVUPM70F6YTZ4Z+ytIJfcTvN+AZ1RTkD2l/aW1HnPi9N3tcl4AhJAbG6ho2vJNmdgxn2bAu9g1n9OEpTivCQgjnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369941; c=relaxed/simple;
	bh=ef97HFogLo9SQjInffE798ELwCAMzEKd0rl5xtXWOiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtqF4QBvLTNib21tHt8KpVTvW/bK5tNPLY/4n/CNStqHV0PYvWM/vjijJhLHWkOqj3wgql8dBynQobPTfT1Ehs/CUJMR2BmEF4KoAXAaGiLE9sbL49o0AG91Vq3mwmRWOAtqwXEHYwx7uQrWojsn+T3rI1Y3ARFEQFS9N0U1KZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+qzFOoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+qzFOoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CF3C4CEE7;
	Mon, 13 Oct 2025 15:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369941;
	bh=ef97HFogLo9SQjInffE798ELwCAMzEKd0rl5xtXWOiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+qzFOoNrY0KNN0tK2mR0q4xb6shfjNIwHKinnwvJ+PoG02dr2UDP+878BRYDN5sS
	 VGSz9UnyoJMQWtZyyGyqH2Ul36bE1ngR3ktmvSlMnSyBXULfRvBfCRCRWw2d+Y1G6L
	 YoNH7ZRCBQ+49rQkJ6UeoWBhNP7ONLBgePMYlCNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 423/563] coresight: fix indentation error in cscfg_remove_owned_csdev_configs()
Date: Mon, 13 Oct 2025 16:44:44 +0200
Message-ID: <20251013144426.612658943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 21dd3f8bc24b6adc57f09fff5430b0039dd00492 ]

Fix wrong indentation in cscfg_remove_owned_csdev_configs()

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506102238.XQfScl5x-lkp@intel.com/
Fixes: 53b9e2659719 ("coresight: holding cscfg_csdev_lock while removing cscfg from csdev")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250611103025.939020-1-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-syscfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-syscfg.c b/drivers/hwtracing/coresight/coresight-syscfg.c
index 83dad24e0116d..6836b05986e80 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -395,7 +395,7 @@ static void cscfg_remove_owned_csdev_configs(struct coresight_device *csdev, voi
 	if (list_empty(&csdev->config_csdev_list))
 		return;
 
-  guard(raw_spinlock_irqsave)(&csdev->cscfg_csdev_lock);
+	guard(raw_spinlock_irqsave)(&csdev->cscfg_csdev_lock);
 
 	list_for_each_entry_safe(config_csdev, tmp, &csdev->config_csdev_list, node) {
 		if (config_csdev->config_desc->load_owner == load_owner)
-- 
2.51.0



