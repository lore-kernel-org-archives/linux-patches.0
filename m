Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F32E60254;
	Tue, 23 Jan 2024 00:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970850; cv=none; b=lE3x0PgvFaK5Efo4cX+tLAs+Bq/A0vdoqjUH3h/YjPfvzpORnBtrsLbOJfDp3e9dNuNIdVhcHgLWkxR+MHBuH0D0CV+CMqW66Cb32//eiIBQ7sINhVfsO3BDN1yoh5dj7mbeFR36kYPYnZOxbpvEyZBRFCT6Y5GlchXpbD0QFyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970850; c=relaxed/simple;
	bh=kbQLxoovu+uEZNhJaQqfnbza66Q7zMBCU4oJosMpeEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOftRUN6k/qtmEw1DY0p4/jPZWzrgjyHCaAozzETxLvTIl/yWLsVQCnkVnYoiTZQfYkjCaNxcdaR1VSQSHQaIFLz891+Oc0M/Tg78whmf1Z9HbS+7cYsektE8DyB0TRlaGPIybSeKIhBKfJ3MD21bOCay17gV2Zj7JFW3KebG7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeBGYVfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeBGYVfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E253CC43390;
	Tue, 23 Jan 2024 00:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970850;
	bh=kbQLxoovu+uEZNhJaQqfnbza66Q7zMBCU4oJosMpeEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeBGYVfH1Lr2GTbdDbqqLaGMnp4R3EjmAllXKXGgUByp+LvXnADdrpVy+lGOa9tF0
	 kDrDdsYsIMahy0w3J3ZfFKHPrnc++4chZWKqICdBtMWNxlYr88Z+OzPXCMtPCmHaFr
	 UDU2DQIPibt3/w5QOdulsW4n0ZElggLNHrIMejeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/417] scsi: hisi_sas: Replace with standard error code return value
Date: Mon, 22 Jan 2024 15:54:44 -0800
Message-ID: <20240122235755.795689242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d34ee535705eb43885bc0f561c63046f697355ad ]

In function hisi_sas_controller_prereset(), -ENOSYS (Function not
implemented) should be returned if the driver does not support .soft_reset.
Returns -EPERM (Operation not permitted) if HISI_SAS_RESETTING_BIT is
already be set.

In function _suspend_v3_hw(), returns -EPERM (Operation not permitted) if
HISI_SAS_RESETTING_BIT is already be set.

Fixes: 4522204ab218 ("scsi: hisi_sas: tidy host controller reset function a bit")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a8142e2b9643..450a8578157c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1502,12 +1502,12 @@ EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	down(&hisi_hba->sem);
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 		up(&hisi_hba->sem);
-		return -1;
+		return -EPERM;
 	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c4305ec38ebf..4f816b2cfa49 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4981,7 +4981,7 @@ static int _suspend_v3_hw(struct device *device)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	dev_warn(dev, "entering suspend state\n");
 
-- 
2.43.0



