Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AA6364EA6;
	Tue, 16 Dec 2025 12:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886992; cv=none; b=Wp3H2KAaS+5EKSpD6RqqL0UrsQxYRDDG4FAg3Fa5LCTTRneS9r3Zlu6SWOeYrqydyS9bmb/rBkxoFShoHIMg2f2WbNvStfq/5G9LQSu+WCa2zQi+S4Qq4gA9c0rbwB37cIzIeTh9FdQSjnDhrxUqfZRtpoBfgffoMlzLMM158tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886992; c=relaxed/simple;
	bh=XTnjzUJQs7RZZBeL7EQXVXNYWEalwxn9AlCi0BArJHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myQAlq3ZDGP2zctjuV39gUsDJIQF1KRq/h5Ev4K98Rrbe+HkrprxBhWfo3p8y27mispnPluZ3m1g/YN16us0/KjHnIBjBb+XqPQykmb0NV/JUnfGWD2HrPZnUkW8o00BfPe78/Q6YTbfgDymANsK+cLLkXn1lx2YFtis8Jkwevc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyiTE3PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyiTE3PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59BCC4CEF1;
	Tue, 16 Dec 2025 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886992;
	bh=XTnjzUJQs7RZZBeL7EQXVXNYWEalwxn9AlCi0BArJHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyiTE3PH2WcvDaBhXgCpweImc2TntQ/CXscorcZ1YU20xksh5yK3kFwv0wt99j8Kc
	 n76Iek4CDnyMHwQywerfRyzmRnw/zAZ2/z2toNyABs8rMMDVTV7jdZY7naMhbs0uCP
	 A4V0HzV6UwbaAM5jBtwDHXukVs5BTHgICtLtMKd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/614] scsi: ufs: core: Move the ufshcd_enable_intr() declaration
Date: Tue, 16 Dec 2025 12:07:40 +0100
Message-ID: <20251216111404.690493184@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b30006b5bec1dcba207bc42e7f7cd96a568acc27 ]

ufshcd_enable_intr() is not exported and hence should not be declared in
include/ufs/ufshcd.h.

Fixes: 253757797973 ("scsi: ufs: core: Change MCQ interrupt enable flow")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20251014200118.3390839-7-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd-priv.h | 2 ++
 include/ufs/ufshcd.h           | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d0a2c963a27d3..1f0d38aa37f92 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -6,6 +6,8 @@
 #include <linux/pm_runtime.h>
 #include <ufs/ufshcd.h>
 
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
+
 static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 {
 	return !hba->shutting_down;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 0f95576bf1f6c..d949db3a46759 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1302,7 +1302,6 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
-void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
-- 
2.51.0



