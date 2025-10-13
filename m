Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38142EC08B;
	Mon, 13 Oct 2025 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367124; cv=none; b=l4lt/Cx/2xWKeDEyyYTfyadka2Gg5gkMOL2qIOk1U5zAbq/S2md29E0PrnpAa1IJq9s70Ov9E84I3ZMw70j5mJ9dK8EFVCa1EWFeNSFOfaUlj7egRzaDYxzlyKO3iN+UXplpumIFwGCLqWeuOUttwm0jcK2eE9qtza+RFarNuQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367124; c=relaxed/simple;
	bh=+2/qSUapj2nzwCI/gnUo0M2L6G3AI62BaWZWaNw0xTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebDHIP9jWSTN+TFN/DjrpRUJr73+R8ybaZvsrAp0fsVDSdZXYPtg214it4X90INdSzrB3ZyxJQ84JVBs7K9Mcpx1ZVEtK57onAQrNEKXb3dav5dYpPwVScU8TZa8O720+s6KgxF2Z6qXJITwcImBw6EQeYPAn2jE8xOW4XGUaC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erefXECJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erefXECJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6961EC116D0;
	Mon, 13 Oct 2025 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367123;
	bh=+2/qSUapj2nzwCI/gnUo0M2L6G3AI62BaWZWaNw0xTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erefXECJ+r34DhW9i5nd+Gr1rfRvZ8SqF1tbqHbwI20T3oaUbqnfXtol5zK84Nh/L
	 Q516Dgmne9Z0PngqUB81sZuZfSjx1IAZD7vqQQTPL9OJdyM7jitdq/E93R0a1zwWPo
	 vTnoW0xpThOwrs9ATv8BEgM0xokl4sOukfuxrQF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/196] crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations
Date: Mon, 13 Oct 2025 16:44:34 +0200
Message-ID: <20251013144318.353371820@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 86e5178120936..4e10090067f18 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -470,10 +470,9 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
-static int hisi_zip_set_high_perf(struct hisi_qm *qm)
+static void hisi_zip_set_high_perf(struct hisi_qm *qm)
 {
 	u32 val;
-	int ret;
 
 	val = readl_relaxed(qm->io_base + HZIP_HIGH_PERF_OFFSET);
 	if (perf_mode == HZIP_HIGH_COMP_PERF)
@@ -483,13 +482,6 @@ static int hisi_zip_set_high_perf(struct hisi_qm *qm)
 
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
@@ -1181,9 +1173,7 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
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



