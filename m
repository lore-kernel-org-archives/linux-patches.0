Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CBA309F00;
	Mon, 13 Oct 2025 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367633; cv=none; b=aZ7rY2/dgb1nGH1Rj73/uCREhvSqhaE9WhEw6hrUbhWaobd82dP+pMhMzqTeCdPuNMPkBiN00vLqUs9Cy5hg8x2aZFGIU7QCO953DRu7/440ypQ+vfVBNf3ZoWW13owf/rYutOpI/b3yvRm5BKwmyJ9kcirJ6u8UA2f+u8rrrNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367633; c=relaxed/simple;
	bh=QHw4dncETxSk9SU8m2ykMOAuwpcnd7U4iGlTygG61ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOOj7rK/j8o1fiQgMsCi9hIZeX2PKkGeF6DcmrVMGYoC94NmR2s9T7scyFlAWv+2lKD48zmR7OzFqt83wW0uH1saMbG/819sAE3ofiHlklL+ZdtQ/4BFXK32bbeuNFyQpBjXevIXxVnBkdFW/dv/QmmbY5fkpSgb26dAoweJFU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLraV/Wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLraV/Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA46C4CEFE;
	Mon, 13 Oct 2025 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367632;
	bh=QHw4dncETxSk9SU8m2ykMOAuwpcnd7U4iGlTygG61ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLraV/WdfUC+omYQf2+ZgDAklWEClhF76W1dQn0WB8iljwEqjTcH2/Wm7yiQlfDFD
	 sxUjsB4BnW+6YsprV11yPTvQmpqtgqmyvYFeC6ETZ6Qk9jwbavEaZypPx4CNjhKDxP
	 Y3kAANXC2ApLh8XpX3bTBg4PQWhOv0wg5qISXesA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/196] crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations
Date: Mon, 13 Oct 2025 16:44:31 +0200
Message-ID: <20251013144318.210274886@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit d4e081510471e79171c4e0a11f6cb608e49bc082 ]

When configuring the high-performance mode register, there is no
need to verify whether the register has been successfully
enabled, as there is no possibility of a write failure for this
register.

Fixes: a9864bae1806 ("crypto: hisilicon/zip - add zip comp high perf mode configuration")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 66e553115adfd..6e419c5165cb4 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -469,10 +469,9 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
-static int hisi_zip_set_high_perf(struct hisi_qm *qm)
+static void hisi_zip_set_high_perf(struct hisi_qm *qm)
 {
 	u32 val;
-	int ret;
 
 	val = readl_relaxed(qm->io_base + HZIP_HIGH_PERF_OFFSET);
 	if (perf_mode == HZIP_HIGH_COMP_PERF)
@@ -482,13 +481,6 @@ static int hisi_zip_set_high_perf(struct hisi_qm *qm)
 
 	/* Set perf mode */
 	writel(val, qm->io_base + HZIP_HIGH_PERF_OFFSET);
-	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_HIGH_PERF_OFFSET,
-					 val, val == perf_mode, HZIP_DELAY_1_US,
-					 HZIP_POLL_TIMEOUT_US);
-	if (ret)
-		pci_err(qm->pdev, "failed to set perf mode\n");
-
-	return ret;
 }
 
 static void hisi_zip_open_sva_prefetch(struct hisi_qm *qm)
@@ -1180,9 +1172,7 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	if (ret)
 		return ret;
 
-	ret = hisi_zip_set_high_perf(qm);
-	if (ret)
-		return ret;
+	hisi_zip_set_high_perf(qm);
 
 	hisi_zip_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
-- 
2.51.0



