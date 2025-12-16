Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC80C34B43D;
	Tue, 16 Dec 2025 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885255; cv=none; b=odKfJYkhUpOr5GQAtwLkJTp49ncXm9KPT403Kz3Ymuu7vF3FqVUfZUaebOZ55UO2o6Wzl/Vm/KvPHaiDeYKEJiTW9Bjz+uGLJh7p8BFx/v1ZAgiPzGbwQeVA+rsolEqj36iAiafCUQpwdYfRzpHuzAaWzQP1khBpBjXQxWccHvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885255; c=relaxed/simple;
	bh=AfdsCDAHdYdpaDz6SVvQ8T7bYrCPHeRg9EJwdc2CLcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djUi3i1ZfkpkyLmwXzngfY64NsBxXzx1O2yYjZhdnAkR/wS/a2s+sBvJYFHgsAOKg5sMssfma2kRcr68jLn5nCu22Ly8Tl6ReicQQhhCKR+iiuTZPEcytRe/tohEabvf0oGRKsn/D/E4PpXo0GAOOUFZZQBA+WSBANOZ6lVTxrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1URZnAiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1URZnAiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDB1C16AAE;
	Tue, 16 Dec 2025 11:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885255;
	bh=AfdsCDAHdYdpaDz6SVvQ8T7bYrCPHeRg9EJwdc2CLcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1URZnAivHad0OzK1l0evd5zwojgmuduPU0u3B2Jt7wa6okL8/ihGNYgoA5HUhgbJK
	 Y7SiSKajSsbWaV0JwzOZBPvmLHm86RVtusv38Z5VvgG97UO/Fwt1ILxrXEEQcP8c2P
	 x0aK0GAleKLIIW0LLJOM5ntixB2C5by+RUa9YV6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 084/507] scsi: ufs: core: Move the ufshcd_enable_intr() declaration
Date: Tue, 16 Dec 2025 12:08:45 +0100
Message-ID: <20251216111348.582779010@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index ace8b9c33f1f9..0303103e8cac1 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1328,7 +1328,6 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
-void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
-- 
2.51.0



