Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87799257828;
	Mon, 13 Oct 2025 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368392; cv=none; b=HRZYEI8E0z8UWnCPk885PTV31sAC2GG27emDLknqeV8IKml7acZCjVYdnrbpu8OEfyBhmQoBgueoHFfLoYVnDiapEwWn0J4/Gz3/iUYfk7KVpKufw4aIJ/ITKDAxdOhlJM6Nbn67Pp8l/VIMaJlmHBWQtw1BRyyhVBQpaDvXDlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368392; c=relaxed/simple;
	bh=UAxdxW0RSYChfWc1IbUIkfdcSInpiIxy0Gbji7II7CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k41iC8C1sRFW/FmNRDjwl/e/Cpbt0Gr5o6aGLGGf0ktR8Bv/K5XXOWuPjchnknrxB6guzluNGe8q1rMc3QDa5JBdlurYTNciLShh0AnrUenBq98SElAgYeR3e6Rx0dbNHsitF5/SC3qj8L6zIn0GRHikPBmD/Lc34kEMNYuzcHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojLwY4r0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojLwY4r0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8062C4CEFE;
	Mon, 13 Oct 2025 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368392;
	bh=UAxdxW0RSYChfWc1IbUIkfdcSInpiIxy0Gbji7II7CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojLwY4r01bNDM8p/3pBUx32Ltin6bwkFW9D/57kdea9OR4sM4FNl3LAcqLwiwJ+uJ
	 g9bELjajdrGeLVYUd2cYFFoAy1Hk40QKBdi7Q1kStU006rs1PTASsgMyTCk3A2GyT/
	 n3TrcYCTUpv7eMbArsjQE6BuafsEjXdYQvIwYy6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/262] crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations
Date: Mon, 13 Oct 2025 16:44:13 +0200
Message-ID: <20251013144330.123092188@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 80c2fcb1d26dc..18177aba3d3a6 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -449,10 +449,9 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
-static int hisi_zip_set_high_perf(struct hisi_qm *qm)
+static void hisi_zip_set_high_perf(struct hisi_qm *qm)
 {
 	u32 val;
-	int ret;
 
 	val = readl_relaxed(qm->io_base + HZIP_HIGH_PERF_OFFSET);
 	if (perf_mode == HZIP_HIGH_COMP_PERF)
@@ -462,13 +461,6 @@ static int hisi_zip_set_high_perf(struct hisi_qm *qm)
 
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
@@ -1171,9 +1163,7 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
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



