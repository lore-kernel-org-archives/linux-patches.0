Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A46313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301138; cv=none; b=Z8ZOsJ/j94h05h9TF+hDbp+b9UPF+UWFaAHUFigyvfmFb5Q8vTCMG7NXFCubCydV2WfBuQqAQCXOzgb//BNYri9J5OXGqlViCrI7cSnN0buPFJjO7pm3Vqv5MkT9np/I4iepmeRyMCcyPx8l9k14jhQTxlTODSj+fmna1AbJT6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301138; c=relaxed/simple;
	bh=kcG1WGu6rdlqlnNBpZrp2bHJDjQL33bmn9XWUHoyw7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO8zfR48KEf5yIA7yczFpFN+T/QGx0UQhLU8BSbRRy8H7YLiu6PNPpJT8mlSNNZVEQ06nLwUzd/OCLmT6hvAB2tASgfHnkI4HOSLCilGqHpu95IUcnEGvryKDG+++objJNtjIvRjDwksqErTgUmjt6a4Jh56Kx3Dt/D+LDYpJM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uy2hLMPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uy2hLMPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5431EC19423;
	Sat, 28 Feb 2026 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301137;
	bh=kcG1WGu6rdlqlnNBpZrp2bHJDjQL33bmn9XWUHoyw7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy2hLMPungmWYNWBoaBjZB0SG1e5aLBheh695AWjkmKi1Bw4gkOQhGTYDxdWtSCUd
	 PAZxXdojakHZTZU/qFGJ+olHoMTu/ChRg+cjkpnYvqHExm0U+FIOX/lf6ONWtkD/LT
	 tqlIxvv2WrsgCeZiK7RTcxX/Vn4tGtCrKsIh3CcD65nJqcDAslN8IEsYzusHz7gv2P
	 Pd1iErTFQLyFvZEtUJ/jjtd+AfmQGKyIC6vzT6ELZcPTj+g5bGU/PateLhQO8q0mbP
	 jhUe1+R4gorOZeyfGVZmq4BRHE/SCqZEAOHuhd3zKjnBJJsZeNP3+5GO5EeJ3Rq1cK
	 oWadpgibNKYaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 298/752] hisi_acc_vfio_pci: resolve duplicate migration states
Date: Sat, 28 Feb 2026 12:40:09 -0500
Message-ID: <20260228174750.1542406-298-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 8c6ac1730a977234dff74cc1753b4a953f59be7b ]

In special scenarios involving duplicate migrations, after the
first migration is completed, if the original VF device is used
again and then migrated to another destination, the state indicating
data migration completion for the VF device is not reset.
This results in the second migration to the destination being skipped
without performing data migration.
After the modification, it ensures that a complete data migration
is performed after the subsequent migration.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-4-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index ed2ae035deb16..c7559f1d4e2f2 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1529,6 +1529,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 		}
 		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
 		hisi_acc_vdev->dev_opened = true;
+		hisi_acc_vdev->match_done = 0;
 		mutex_unlock(&hisi_acc_vdev->open_mutex);
 	}
 
-- 
2.51.0

