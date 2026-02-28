Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC4D270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302184; cv=none; b=euL+OH7xZ/BC7TFZV1hYSDCGKTOvPxKaW1yyt1AMPQK63noZ7iiU5fmToJWfh5URvf8IIFDlxWdI6YRzzjBv7oRNCw/FeaGypj05kHhvY/kdq1FowjkLnmIWqAedMdVWvj9aWSW4JaWUi67oxIWdAz2U6YUGWZGpQt71CULS43A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302184; c=relaxed/simple;
	bh=2EuIn/+/Rt46MyTg81TWumbOpiiXUc4vyNDTFxO9jJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7iFEd0qqL1tVE1+bhS7iNqAliiGmfXenSp07AufqCYL8qqvA+qFAGQU+sYORX1Q+ezoamOgS27hLSraw2sJzqxQUJJddki75SagkUqUfS9Weynml7EYqS5ejhc7OCrq5mmUMTlT6Kl+qkk7djCu8Ht/oZpzirN110/31YEzyu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruLMwdAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruLMwdAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFAAC116D0;
	Sat, 28 Feb 2026 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302184;
	bh=2EuIn/+/Rt46MyTg81TWumbOpiiXUc4vyNDTFxO9jJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruLMwdAvhGiaOkrjUPeCJ6xhzGWQj07PJUfxaUEmsZUxC51QoyjKwurupjPYdQ5Ll
	 z2wih8QhHyrJSAqRChOUdkLi+Jvyq92GgjH+K0LGFaaiGnhH5qfySqh+TeH9pqC96u
	 IBs7QMQbqAwKwYtO4PQdQMMimM1OtRwwLt/YW5pEnC9uSi4TENnAjJ3aT8Ul57qBOp
	 SnkDncTzIv7HDJuj8b8qb8X4gJ1UIpv/Rxu7tsK90XJvT99N2FWFjjicBwPz31xtti
	 kKgBsl0SW2pSKOeZTc4HVs/D/qDFEyb0cscqSUCxOWPBGfq2VZTP61Sl+OGI646neJ
	 omQEWZVnu862w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/283] crypto: ccp - Add an S4 restore flow
Date: Sat, 28 Feb 2026 13:05:27 -0500
Message-ID: <20260228180709.1583486-185-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 0ba2035026d0ab6c7c7e65ad8b418dc73d5700d9 ]

The system will have lost power during S4.  The ring used for TEE
communications needs to be initialized before use.

Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
Reported-by: Lars Francke <lars.francke@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-4-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
 drivers/crypto/ccp/sp-dev.c  | 12 ++++++++++++
 drivers/crypto/ccp/sp-dev.h  |  3 +++
 drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
 drivers/crypto/ccp/tee-dev.c |  5 +++++
 drivers/crypto/ccp/tee-dev.h |  1 +
 6 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index d42d7bc623523..d001abc350cd2 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -253,6 +253,17 @@ struct psp_device *psp_get_master_device(void)
 	return sp ? sp->psp_data : NULL;
 }
 
+int psp_restore(struct sp_device *sp)
+{
+	struct psp_device *psp = sp->psp_data;
+	int ret = 0;
+
+	if (psp->tee_data)
+		ret = tee_restore(psp);
+
+	return ret;
+}
+
 void psp_pci_init(void)
 {
 	psp_master = psp_get_master_device();
diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e46682860..ccbe009ad6e58 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -229,6 +229,18 @@ int sp_resume(struct sp_device *sp)
 	return 0;
 }
 
+int sp_restore(struct sp_device *sp)
+{
+	if (sp->psp_data) {
+		int ret = psp_restore(sp);
+
+		if (ret)
+			return ret;
+	}
+
+	return sp_resume(sp);
+}
+
 struct sp_device *sp_get_psp_master_device(void)
 {
 	struct sp_device *i, *ret = NULL;
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 2329ad524b494..8bbef2426acd4 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -138,6 +138,7 @@ struct sp_device *sp_get_master(void);
 
 int sp_suspend(struct sp_device *sp);
 int sp_resume(struct sp_device *sp);
+int sp_restore(struct sp_device *sp);
 int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
 void sp_free_ccp_irq(struct sp_device *sp, void *data);
@@ -171,6 +172,7 @@ int psp_dev_init(struct sp_device *sp);
 void psp_pci_init(void);
 void psp_dev_destroy(struct sp_device *sp);
 void psp_pci_exit(void);
+int psp_restore(struct sp_device *sp);
 
 #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -178,6 +180,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
 static inline void psp_pci_init(void) { }
 static inline void psp_dev_destroy(struct sp_device *sp) { }
 static inline void psp_pci_exit(void) { }
+static inline int psp_restore(struct sp_device *sp) { return 0; }
 
 #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
 
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index b1e60542351a6..8f1b032f7e633 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -407,6 +407,13 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
 	return sp_resume(sp);
 }
 
+static int __maybe_unused sp_pci_restore(struct device *dev)
+{
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	return sp_restore(sp);
+}
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 static const struct sev_vdata sevv1 = {
 	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
@@ -585,7 +592,14 @@ static const struct pci_device_id sp_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, sp_pci_table);
 
-static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
+static const struct dev_pm_ops sp_pci_pm_ops = {
+	.suspend = pm_sleep_ptr(sp_pci_suspend),
+	.resume = pm_sleep_ptr(sp_pci_resume),
+	.freeze = pm_sleep_ptr(sp_pci_suspend),
+	.thaw = pm_sleep_ptr(sp_pci_resume),
+	.poweroff = pm_sleep_ptr(sp_pci_suspend),
+	.restore_early = pm_sleep_ptr(sp_pci_restore),
+};
 
 static struct pci_driver sp_pci_driver = {
 	.name = "ccp",
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5560bf8329a12..9c02706e94948 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -395,3 +395,8 @@ int psp_check_tee_status(void)
 	return 0;
 }
 EXPORT_SYMBOL(psp_check_tee_status);
+
+int tee_restore(struct psp_device *psp)
+{
+	return tee_init_ring(psp->tee_data);
+}
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index 49d26158b71e3..b0bf1de94ea6f 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -122,5 +122,6 @@ struct tee_ring_cmd {
 
 int tee_dev_init(struct psp_device *psp);
 void tee_dev_destroy(struct psp_device *psp);
+int tee_restore(struct psp_device *psp);
 
 #endif /* __TEE_DEV_H__ */
-- 
2.51.0

