Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AD2350D47;
	Fri, 21 Nov 2025 13:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733547; cv=none; b=PMfgsEVqC/RW40wGroDe5BUxU9THEO3qLHww9ZfTa2iqt/2gDbAm8JwPQjJth49wGaSD0Y4CZpo8r8Mn4fRDY3MlWB4olAS9cD4mlmEcnrd4VYoiapFgAL77F0cFaQD13VG9bkMqc7c/1Z6Y9b2cjbvtIZuyqvYfKKMRiPp3rPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733547; c=relaxed/simple;
	bh=nGpn55WUtiyn6oY5IbRJjtz1HJ8uQJ71ZEgC43mUDoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgIdNvMPVqlENnaxJTgGYykOpxpACb5a7L50vAdEeFUJ/e4n1/6fhHvHpXeuWxNmYcMB4v8lcOAiXrdoA0xdpDg5m5SDJ86CRDDP4969BqBtDPEnmSKYAbOeLEuzguLFkqPI6wocZsal3YVTzOsE8jyM4IYSXpfag0PujeD0OdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLjC2ei6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLjC2ei6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0067C4CEF1;
	Fri, 21 Nov 2025 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733546;
	bh=nGpn55WUtiyn6oY5IbRJjtz1HJ8uQJ71ZEgC43mUDoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLjC2ei6RYI5Jb6KziF85XrEU20peh6/BVs4R/hKJVIh3sJSexaTDivf6eFIaTIUd
	 L5bMusG8MesyDbLfIQaW7aq+3tvLKxvRXTpSNhA9nBMFg+H7AUk122TVFPpPv7n0ba
	 pGRNSYTnHaHbQmpzWNF0d8egvG4BmpxYkrQYz130=
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
Subject: [PATCH 6.6 506/529] scsi: ufs: core: Add fill_crypto_prdt variant op
Date: Fri, 21 Nov 2025 14:13:25 +0100
Message-ID: <20251121130249.024442432@linuxfoundation.org>
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

[ Upstream commit 8ecea3da1567e0648b5d37a6faec73fc9c8571ba ]

Add a variant op to allow host drivers to initialize nonstandard
crypto-related fields in the PRDT.  This is needed to support inline
encryption on the "Exynos" UFS controller.

Note that this will be used together with the support for overriding the
PRDT entry size that was already added by commit ada1e653a5ea ("scsi: ufs:
core: Allow UFS host drivers to override the sg entry size").

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20240708235330.103590-5-ebiggers@kernel.org
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d968e99488c4 ("scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd-crypto.h |   19 +++++++++++++++++++
 drivers/ufs/core/ufshcd.c        |    2 +-
 include/ufs/ufshcd.h             |    4 ++++
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -37,6 +37,19 @@ ufshcd_prepare_req_desc_hdr_crypto(struc
 	h->dunu = cpu_to_le32(upper_32_bits(lrbp->data_unit_num));
 }
 
+static inline int ufshcd_crypto_fill_prdt(struct ufs_hba *hba,
+					  struct ufshcd_lrb *lrbp)
+{
+	struct scsi_cmnd *cmd = lrbp->cmd;
+	const struct bio_crypt_ctx *crypt_ctx = scsi_cmd_to_rq(cmd)->crypt_ctx;
+
+	if (crypt_ctx && hba->vops && hba->vops->fill_crypto_prdt)
+		return hba->vops->fill_crypto_prdt(hba, crypt_ctx,
+						   lrbp->ucd_prdt_ptr,
+						   scsi_sg_count(cmd));
+	return 0;
+}
+
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
 
 int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba);
@@ -54,6 +67,12 @@ static inline void
 ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp,
 				   struct request_desc_header *h) { }
 
+static inline int ufshcd_crypto_fill_prdt(struct ufs_hba *hba,
+					  struct ufshcd_lrb *lrbp)
+{
+	return 0;
+}
+
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	return false;
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2589,7 +2589,7 @@ static int ufshcd_map_sg(struct ufs_hba
 
 	ufshcd_sgl_to_prdt(hba, lrbp, sg_segments, scsi_sglist(cmd));
 
-	return 0;
+	return ufshcd_crypto_fill_prdt(hba, lrbp);
 }
 
 /**
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -323,6 +323,7 @@ struct ufs_pwr_mode_info {
  * @device_reset: called to issue a reset pulse on the UFS device
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
+ * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
  * @mcq_config_resource: called to configure MCQ platform resources
  * @get_hba_mac: called to get vendor specific mac value, mandatory for mcq mode
@@ -366,6 +367,9 @@ struct ufs_hba_variant_ops {
 				struct devfreq_simple_ondemand_data *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
+				    const struct bio_crypt_ctx *crypt_ctx,
+				    void *prdt, unsigned int num_segments);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
 	int	(*mcq_config_resource)(struct ufs_hba *hba);


