Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EE53A6B92;
	Sat, 17 Oct 2026 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253200; cv=none; b=bcQQalYQ3b0Xznrd0PhgYBdo+IvoQyxX/9rdnHR1nJJ5j5TNaR6gYO8kXFwqMhCHjlg9Oq/EDAcv4J92IWZ9qDjdsw09YsLg+BsgQ8RwnxKYAQwvNGkLGRH4Hv8QbtqIesMQbQXe7b8HdUD74Np3rCHdyd0dw7iVKCCUyt6LBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253200; c=relaxed/simple;
	bh=a2QwBSpKs7kLK06B/x9QiKw4JdtRbs3cY65RKTxTjsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpesUQ5TIzUwzzvf3oG+RB77jby4aOtSVtkGCHDYxe3xx17/0WETLP8tfMQKSmwjjvcPnxSCe+C1mx4JkRnS+kXB+Re10PVjeJ/YdPSUBkqBfKzFvloDYA+H56f1Y/Rvn9FoLOSrN7nTjrB3fd/KIhmBbwFCbyxuZgoacryBKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkCY0dbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkCY0dbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08461F000C5;
	Sat, 17 Oct 2026 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253198;
	bh=3R4SSqaN5llpFzAeCwSHRtgUXPYtUbqoUbJuX7l5Vpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkCY0dbLUclbkmnzwXP1i7U58o9F0hyoKF2XIijkFbZ9U5QOinEjZgk1YEwFIoIjJ
	 ZXOg+20b7qYKjErIAuJFmJ+XAhw0BbysAcHYDh8E3a4KUP41RI754wxlOBo7CwAe0D
	 ud0k7IvomZu1yK47gUQmWdNmIOpfntCH0v4FKkDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/869] scsi: ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()
Date: Sat, 17 Oct 2026 17:48:02 +0200
Message-ID: <20261017160038.069628235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1373df88d53594a32534fd8960c51d1d09be8ecb ]

Document the aspects of ufshcd_mcq_compl_all_cqes_lock() that are
nontrivial in a comment block above this function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260401202506.1445324-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index d4129ceaede6c..09c40308789a6 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -315,6 +315,14 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 	}
 }
 
+/*
+ * This function is called from the UFS error handler with the UFS host
+ * controller disabled (HCE = 0). Reading host controller registers, e.g. the
+ * CQ tail pointer (CQTPy), may not be safe with the host controller disabled.
+ * Hence, iterate over all completion queue entries. This won't result in
+ * double completions because ufshcd_mcq_process_cqe() clears a CQE after it
+ * has been processed.
+ */
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 				    struct ufs_hw_queue *hwq)
 {
-- 
2.53.0



