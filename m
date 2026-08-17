Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321C03ACEFE;
	Mon, 17 Aug 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978129; cv=none; b=XJefWQP88N3Kz8Pr8ArMFO2w3lj3EC7QS6FQnO7MP0bchXiTnGvKKuBZO73vO5EvnHdjB5DJnDc2/9PMapNzzmClx+DtrCOpVbFM49Bl86kwkwdu3/0qs71E/xeCdYnZJHI86kKf6QHWv84pPb2PbX1aDVndRHESFwQclAItqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978129; c=relaxed/simple;
	bh=6yhceNrFKVnRkfxYD5XrxcuCPVzTDq0EaHoy5VFZom8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3QlczVJNktC2jfKftK3lcR1MMEF+uGw/XiSq5rDCrys7Mryg2mexkM34Ih1jrNYvTxVR/fOOJE6RmUQrB35NC3oPIv8mNgYgxtbHPaZbN9/iE/Fvq1aIV6cFGH/QbwyKxe4xanTUGxGhtf0FDmGxDPL+9jee4ENnz45T3yoGqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mITska1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mITska1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548BB1F000E9;
	Mon, 17 Aug 2026 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978127;
	bh=cR5Rs0upEBn3F1rANpMbch4sfKyWYdbMEqjJ02p/Xds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mITska1bDoNp87Di1IB8NUHDyPQQS8q8TOwqtXLsa/WOVrW4D/TbiEzRjoTBzmTrV
	 7PtMIQkDJcrTWAPw5B6tJo8lpoaL0+CmcMiiQt5H1sUOJbUeBwOc8elT6R1uBlRNUl
	 t7rg9pmAk1eC5hNjOlp+D7k1WZG0SsjYoGTVgvy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dionna Glaze <dionnaglaze@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/181] crypto: ccp - Add new SEV/SNP platform shutdown API
Date: Mon, 17 Aug 2026 15:33:24 +0200
Message-ID: <20260817132539.838327203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Ashish Kalra <ashish.kalra@amd.com>

commit f7b86e0e75bc234751cb7a82d888083a57ef28b2 upstream.

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 9 +++++++++
 include/linux/psp-sev.h      | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d668f9318c286..7c05cae7e5778 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2444,6 +2444,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	mutex_unlock(&sev_cmd_mutex);
 }
 
+void sev_platform_shutdown(void)
+{
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	sev_firmware_shutdown(psp_master->sev_data);
+}
+EXPORT_SYMBOL_GPL(sev_platform_shutdown);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 613a8209bed27..6a4435cfa977e 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -947,6 +947,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
+void sev_platform_shutdown(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -981,6 +982,8 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline void sev_platform_shutdown(void) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.53.0



