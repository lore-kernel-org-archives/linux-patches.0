Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CE54734CD;
	Fri,  7 Aug 2026 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116989; cv=none; b=uQYdthj6oKTgu4FkO6srPNPKrvyl21wKkvSLxVuIa3ovKQKy5uQcUHh9rtvFf+24Phsvj8TyN03Dxd77BGa6W34zLNYmPiPTQvAS95mvw2lLqOq95Mm0Tap5SSCpb/a+Bxsfm66vr11fS7nTxomK3W7eTXY3aJzFI8DEp1o2SJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116989; c=relaxed/simple;
	bh=jJUrFVtWPIXGH0JuNzSKHZnoZ/dTcdcLz/sP7FLrDII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKSLC9lIdbEeYIC1wRdCzZVv5k4g89mZlWjgDqKLYsaMavrWwxSnvzDlANoZv8BSRcbcDIUbnLCF6RBPXOFJ/WnM8U8ct6ibR+Lf0L8uHXoiEXJrZzeTTMp3CrpwoIwPm/ICbCGMANyYsqa43NYofDU5Z7hVINIFP7Z5KckPPnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Vkz/4W8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Vkz/4W8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1A01F000E9;
	Fri,  7 Aug 2026 15:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116988;
	bh=PSyv+awXsPtht/Pnh0+7CHeNC9QNXWAYM/AZ+0kIA/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Vkz/4W8wyti9Sv7+wSPeTK6LoqF9oX3XPr26Yv+W4oqX6zaDdl76WLXyE0dHn5Fp
	 m0HgDiHiA6z9MhjdGEeFwRaOMEWlXFlJ6ZMk4lzqomXLsc4Kzs6rHirzt4CyFvphlY
	 huGRCLDog/5xAFmeOBwMJDhwfQ3CWlh5RyNRSQ6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiazi Li <jiazi.li@transsion.com>,
	Ao Sun <ao.sun@transsion.com>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 159/438] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
Date: Fri,  7 Aug 2026 16:35:55 +0200
Message-ID: <20260807143431.423308598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ao Sun <ao.sun@transsion.com>

[ Upstream commit 0279fd451a9971c0d5b959fc59f3e11b55e1694e ]

Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL
pointer dereference in the device teardown path if ufs_rpmb_probe()
fails.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Co-developed-by: Jiazi Li <jiazi.li@transsion.com>
Signed-off-by: Jiazi Li <jiazi.li@transsion.com>
Signed-off-by: Ao Sun <ao.sun@transsion.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Link: https://patch.msgid.link/20260723034440.217-1-ao.sun@transsion.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-rpmb.c | 2 --
 drivers/ufs/core/ufshcd.c   | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index ffad049872b9a..62120dc2e9da7 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -152,8 +152,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 		return -EINVAL;
 	}
 
-	INIT_LIST_HEAD(&hba->rpmbs);
-
 	struct rpmb_descr descr = {
 		.type = RPMB_TYPE_UFS,
 		.route_frames = ufs_rpmb_route_frames,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 082eac1e13463..d6444b3c2ef16 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10924,6 +10924,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
 	INIT_LIST_HEAD(&hba->clk_list_head);
+	INIT_LIST_HEAD(&hba->rpmbs);
 	spin_lock_init(&hba->outstanding_lock);
 
 	*hba_handle = hba;
-- 
2.53.0



