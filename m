Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC872D7D3A;
	Sat, 17 Oct 2026 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260196; cv=none; b=Cg52SSdINl3lsppm9I92Z/mKSrXfT9f/IKBNLce78pF+UwqhUdSB2r7Qix+Q+Zdpj3mRtnwIDY/WS8UFCoohVQorPheRXFiQkseF2DrS4bxkR9y03iSdXc/KaLYkw74zXlw5HkSnDST8scaC8Y4IplpvAbQAR43IAYgzQKe5Edc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260196; c=relaxed/simple;
	bh=wHyxySEnNO6ZW20TVLfLdtANCVXS/dc4+w/4A95Nqgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWPdEDGTgrwytDMdB0UoTSoYh6xIPfSVxczLShdvo71/oyDtei3+bnOYA0yxyDHc6ffdVC1ZnGMiIsaBrBM43+dwYFvpxGIbSGBLxyyhpcEyquyCX0zK/IUG6kbR/s0UNVo5vXdW/PH74JJrneQuAf3GD0Imu/m7axK65kBej/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4MgTPML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4MgTPML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1657D1F000C4;
	Sat, 17 Oct 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260195;
	bh=qnScWcikXc+mf1olzyNP4iwvXTU2chdP9BN8p+sCmow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4MgTPMLXeNqnuHRi9VRFNQSBYaaUD2Z9mZgfoZyL4f/SW+HZPfTPrT7un3lxGfNb
	 Cu9KIMUIDM2+fpy3oTwNP7SKUkYgOGOrFd9/G7xLAYhu0vjQqAE0LZJfULcpD/7m5p
	 Mn+FK9VY6xNuREsHKDPmbqKNFwdaxd7wT35lNvfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <Avri.Altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1466/1674] scsi: ufs: core: Convert string descriptor format macros to enum
Date: Sat, 17 Oct 2026 18:02:18 +0200
Message-ID: <20261017160508.800897742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 0d9a7085ec24983b5b8a4971c0eb6c756c75f1bf ]

Convert SD_ASCII_STD and SD_RAW from boolean macros to enum values for
improved code readability. This makes ufshcd_read_string_desc() calls
self-documenting by using explicit enum values instead of true/false.

Move the ufshcd_read_string_desc() declaration from include/ufs/ufshcd.h
to drivers/ufs/core/ufshcd-priv.h since this function is not exported.

Co-developed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Suggested-by: Avri Altman <Avri.Altman@sandisk.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Link: https://patch.msgid.link/20251107230518.4060231-2-beanhuo@iokpp.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d96e83d028d7 ("scsi: ufs: core: Validate string descriptors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd-priv.h | 14 ++++++++++----
 drivers/ufs/core/ufshcd.c      |  8 +++-----
 include/ufs/ufshcd.h           |  4 ----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index e334666090524..29153629f001c 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -83,11 +83,17 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 			     struct ufshcd_lrb *lrbp);
 
-#define SD_ASCII_STD true
-#define SD_RAW false
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii);
+/**
+ * enum ufs_descr_fmt - UFS string descriptor format
+ * @SD_RAW: Raw UTF-16 format
+ * @SD_ASCII_STD: Convert to null-terminated ASCII string
+ */
+enum ufs_descr_fmt {
+	SD_RAW = 0,
+	SD_ASCII_STD = 1,
+};
 
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum ufs_descr_fmt fmt);
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 60fdec1eab193..2873df557db27 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3672,16 +3672,14 @@ static inline char ufshcd_remove_non_printable(u8 ch)
  * @desc_index: descriptor index
  * @buf: pointer to buffer where descriptor would be read,
  *       the caller should free the memory.
- * @ascii: if true convert from unicode to ascii characters
- *         null terminated string.
+ * @fmt: if %SD_ASCII_STD, convert from UTF-16 to ASCII
  *
  * Return:
  * *      string size on success.
  * *      -ENOMEM: on allocation failure
  * *      -EINVAL: on a wrong parameter
  */
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii)
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum ufs_descr_fmt fmt)
 {
 	struct uc_string_id *uc_str;
 	u8 *str;
@@ -3710,7 +3708,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		goto out;
 	}
 
-	if (ascii) {
+	if (fmt == SD_ASCII_STD) {
 		ssize_t ascii_len;
 		int i;
 		/* remove header and divide by 2 to move from UTF16 to UTF8 */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 60942ed0040f1..bf84b00168bc8 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1410,10 +1410,6 @@ void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
-#define SD_ASCII_STD true
-#define SD_RAW false
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii);
 
 void ufshcd_hold(struct ufs_hba *hba);
 void ufshcd_release(struct ufs_hba *hba);
-- 
2.53.0



