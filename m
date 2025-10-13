Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E10330BB96;
	Mon, 13 Oct 2025 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369569; cv=none; b=ZpY6f1+IdtbJzjLWuM+0eZiF6xatv1BZZWWlYKC/4XNNPtt3hL0A77FS4BHJPYJKiebsPL/sC5vflOiEi+3yY0RzXJUHwOOXUDbnjn8Wortt+YIfNFTQZL0Axcd4EsY8WjL4tGdmTg3jEqbzZoE0rgXDPGZAj8akYemb7zbHo/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369569; c=relaxed/simple;
	bh=S0HJso0NC3JGzxemHnwkgI+ZC8BsQbxnIZcdMWCDjNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMNUi13qzRz8GBOVLsR8y39MRSCeXmby/VJu63LggvlDHjjK85x31lfERnq3Odj0kgUzK7MgaKxAkseKAuUJA1vE+1o4C1eSgu4pJ1hMjDscRFLQ1RdXKPkBpHGvlyf9HTFs+5QQZycwVyJaOum07/a/T/18QOk0QLTBKjZtMzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fD96JwMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fD96JwMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB7CC19422;
	Mon, 13 Oct 2025 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369568;
	bh=S0HJso0NC3JGzxemHnwkgI+ZC8BsQbxnIZcdMWCDjNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fD96JwMdolyc973AJxpevE8Ut/+B9mnfs3/RCzjpf/mBxU+65ahwpEG912fXzxY12
	 8I+0yaZ6s6eOGM06UaDhyJxL1Rxcei1iHTn3ARvmABOoxQ9548ibaxhnswIKz0eV7S
	 gwRw8F7PaWCwEHPM+vB9bUhViczHv1sS2+a+8Rqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 292/563] crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations
Date: Mon, 13 Oct 2025 16:42:33 +0200
Message-ID: <20251013144421.847009342@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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
index d8ba23b7cc7dd..fb7b19927dd32 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -448,10 +448,9 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
-static int hisi_zip_set_high_perf(struct hisi_qm *qm)
+static void hisi_zip_set_high_perf(struct hisi_qm *qm)
 {
 	u32 val;
-	int ret;
 
 	val = readl_relaxed(qm->io_base + HZIP_HIGH_PERF_OFFSET);
 	if (perf_mode == HZIP_HIGH_COMP_PERF)
@@ -461,13 +460,6 @@ static int hisi_zip_set_high_perf(struct hisi_qm *qm)
 
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
@@ -1251,9 +1243,7 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
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



