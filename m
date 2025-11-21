Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCC7307481;
	Fri, 21 Nov 2025 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733549; cv=none; b=HXhnHYF/+zx3dAUnFApJy2PHcAIPV5QKOe40E1NWd/DYJy0JC2BNQmTcxpQ/TzOGPOel5S7l7Cv0XTmuH9m+1NkdiZsyQU0vJVVcbIkt+hGNqaAIrWXBDv9+ihD1HP1IOcYq3/OnNWTzuvo05FkC0Vta8FddsFFxbMNxRCldxhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733549; c=relaxed/simple;
	bh=YaJnkBkrefdnbaznyf5QjD5OBY9HVYMCvE/tMjJwZF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acdvQ1G0s1DNfjtPFu++Mkkd04gsYp7L8y1T0np2PYyAMdtm2pJ10XNrheXYNZ43Ixo4tlcj8RGhq37ajMGHwQVO0dVuCv4gejtoTx00rCIBimDunrCwzABnCDMaLulOsKv+YXskjKfmaRg2SbqgexhRC8mMnz+1SFPcB557uAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHhb04xN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHhb04xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23ACC4CEF1;
	Fri, 21 Nov 2025 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733549;
	bh=YaJnkBkrefdnbaznyf5QjD5OBY9HVYMCvE/tMjJwZF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHhb04xN/vo8kvdZjSnTnMh16fC4THCFdceuhn3L1jYH3QCgKHukA7Zgl3sOdxcjQ
	 usBlNHWnQC6Mb5IbYXkp21EFopgYN4VLHaakp6Cps5rZczRH8yrCUkz3aSkK8WQFcK
	 Wutm1jqg10k7CiKR2BHqK5n88C60o1Gui+W+yRnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Eric Biggers <ebiggers@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/529] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
Date: Fri, 21 Nov 2025 14:13:26 +0100
Message-ID: <20251121130249.061174456@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 4c45dba50a3750a0834353c4187e7896b158bc0c ]

Since the nonstandard inline encryption support on Exynos SoCs requires
that raw cryptographic keys be copied into the PRDT, it is desirable to
zeroize those keys after each request to keep them from being left in
memory.  Therefore, add a quirk bit that enables the zeroization.

We could instead do the zeroization unconditionally.  However, using a
quirk bit avoids adding the zeroization overhead to standard devices.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20240708235330.103590-6-ebiggers@kernel.org
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d968e99488c4 ("scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd-crypto.h |   17 +++++++++++++++++
 drivers/ufs/core/ufshcd.c        |    1 +
 include/ufs/ufshcd.h             |    8 ++++++++
 3 files changed, 26 insertions(+)

--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -50,6 +50,20 @@ static inline int ufshcd_crypto_fill_prd
 	return 0;
 }
 
+static inline void ufshcd_crypto_clear_prdt(struct ufs_hba *hba,
+					    struct ufshcd_lrb *lrbp)
+{
+	if (!(hba->quirks & UFSHCD_QUIRK_KEYS_IN_PRDT))
+		return;
+
+	if (!(scsi_cmd_to_rq(lrbp->cmd)->crypt_ctx))
+		return;
+
+	/* Zeroize the PRDT because it can contain cryptographic keys. */
+	memzero_explicit(lrbp->ucd_prdt_ptr,
+			 ufshcd_sg_entry_size(hba) * scsi_sg_count(lrbp->cmd));
+}
+
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
 
 int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba);
@@ -73,6 +87,9 @@ static inline int ufshcd_crypto_fill_prd
 	return 0;
 }
 
+static inline void ufshcd_crypto_clear_prdt(struct ufs_hba *hba,
+					    struct ufshcd_lrb *lrbp) { }
+
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	return false;
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5512,6 +5512,7 @@ void ufshcd_release_scsi_cmd(struct ufs_
 	struct scsi_cmnd *cmd = lrbp->cmd;
 
 	scsi_dma_unmap(cmd);
+	ufshcd_crypto_clear_prdt(hba, lrbp);
 	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -662,6 +662,14 @@ enum ufshcd_quirks {
 	 * host controller initialization fails if that bit is set.
 	 */
 	UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE		= 1 << 23,
+
+	/*
+	 * This quirk needs to be enabled if the host controller driver copies
+	 * cryptographic keys into the PRDT in order to send them to hardware,
+	 * and therefore the PRDT should be zeroized after each request (as per
+	 * the standard best practice for managing keys).
+	 */
+	UFSHCD_QUIRK_KEYS_IN_PRDT			= 1 << 24,
 };
 
 enum ufshcd_caps {


