Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743E33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301142; cv=none; b=DtuFal/gR8NnM6L1O+UZrl0p0dZs38S4tqTwIS5bv2bEPctheybxzrgM1utLQ7qIP0v280cTO9MGt8v1FlB8Bf3U85qRLuVanA05rvYhHbHnMXQXzbRuLfFgRTmg+y0D4mJi2WuD7bT/LvIVWyrORMbnN3C6jz/SqyzXJzGPLhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301142; c=relaxed/simple;
	bh=xDfeg+nYG3ZnLLT7zdetxjoPi1et/04fBZls8Uq72to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9qVckdw8E44o3m1c0UA0THS17X6Q5lTEdf870A8m5qJfPRrV5OxobRWU2b0ugkMY4wOmt0aRKSDgO85WOal2SgnnX5Yug/jPf5yS3HBOfI8He6UFkKhDsM+zDOqyVXpJ3YG64inBmnTpoA+3MVMXMmpd/gUVMj4zEuuoT5HNP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozkIJt8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozkIJt8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527DBC116D0;
	Sat, 28 Feb 2026 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301141;
	bh=xDfeg+nYG3ZnLLT7zdetxjoPi1et/04fBZls8Uq72to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozkIJt8azXKHBjTXFl5f7HCkp/4204rdnop+6eumplcwKwfWzwwFdfW4PSWtyAEKO
	 7LErIfuvfrKEPpP28pAIUD3S/Dcz9dcIgrYoQPIYSeCcZioLe4mxW2MZuyq6/NAJ5w
	 fvL0jNjvJuxFivN8TSBo3TZw3uTzLGsYym7oDIMoKgHQ+JzP/uZPtIxG8+HruCM4gV
	 Ys2ycVgNKxj9EZPY8YXPJYASxJF/oYYZt4j4qMlRnFc3BbR27hTnUKWZsTDUj/h1CH
	 qGPuV/k8wHCXdYVBP+UpeGeAId9d5OAmtxsCYenayC1ingvlTfI6p1sAAGWHls6Ope
	 Ur1plwtEzaLBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 303/752] hisi_acc_vfio_pci: update status after RAS error
Date: Sat, 28 Feb 2026 12:40:14 -0500
Message-ID: <20260228174750.1542406-303-sashal@kernel.org>
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

[ Upstream commit 8be14dd48dfee0df91e511acceb4beeb2461a083 ]

After a RAS error occurs on the accelerator device, the accelerator
device will be reset. The live migration state will be abnormal
after reset, and the original state needs to be restored during
the reset process.
Therefore, reset processing needs to be performed in a live
migration scenario.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-3-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 5950ae5222476..f141f21566c52 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1196,8 +1196,7 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 	if (hisi_acc_vdev->set_reset_flag)
 		clear_bit(QM_RESETTING, &qm->misc_ctl);
 
-	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
-				VFIO_MIGRATION_STOP_COPY)
+	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
 		return;
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
-- 
2.51.0

