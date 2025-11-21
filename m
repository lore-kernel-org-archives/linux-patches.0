Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7A727AC57;
	Fri, 21 Nov 2025 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733543; cv=none; b=V7St1dK+tB+JxE/kvrKDZW4OJ2vTbWj2dh6Z1uCzuovS7IzLsBU5yS0jYjne2mamni6t8DkQClsVnEkN3bXlXoiwduU8DyPOsR1s2RKWopRT9neT8KLC+rw8zcLNW5IGArTN6aoT/TtupwvmXn9lgD9azgQmmkElzKp2sExoSug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733543; c=relaxed/simple;
	bh=3+ndhFcJ9O9pIEP6l8jCXItITqK+2EWPt3BpntdS3tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0Ixcn46C1MNxSMpPhvBB2rRkQzHL+qlIKf6ICnX6Ecr/twPQqI8NLJs2hrsEmmjwvS6Qc6PTUL8fshGU+rxQnEBDx/zybN0cHBozdze9PjpzR4esaH0hwoTrdmnIlSLjuaSdw5R+a9PROJ2p6AxuvsADchkEcffA7B5OdJ6eaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qut1i4VW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qut1i4VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D7EC4CEF1;
	Fri, 21 Nov 2025 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733543;
	bh=3+ndhFcJ9O9pIEP6l8jCXItITqK+2EWPt3BpntdS3tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qut1i4VWsyeuM7DzjXoD/CiFlt4RP9aeyvrgqCdp5ldRaV/u2ukLkRg97kCs3iMRd
	 yLbP6zJeaFYwT2rPlR+9J8nkojh0Vl3Ct8qreNkM8JPBgOjMExEvJTBOKZXR+oDB+k
	 mbPgLfcn0zfZjGJvcRZ0a+wg1sXrYLWUZNCJv65A=
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
Subject: [PATCH 6.6 505/529] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
Date: Fri, 21 Nov 2025 14:13:24 +0100
Message-ID: <20251121130248.987970216@linuxfoundation.org>
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

[ Upstream commit e95881e0081a30e132b5ca087f1e07fc08608a7e ]

Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE which tells the UFS core to not use
the crypto enable bit defined by the UFS specification.  This is needed to
support inline encryption on the "Exynos" UFS controller.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20240708235330.103590-4-ebiggers@kernel.org
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d968e99488c4 ("scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd-crypto.c |    8 ++++++++
 include/ufs/ufshcd.h             |    7 +++++++
 2 files changed, 15 insertions(+)

--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -110,6 +110,10 @@ static int ufshcd_crypto_keyslot_evict(s
 	return ufshcd_program_key(hba, &cfg, slot);
 }
 
+/*
+ * Reprogram the keyslots if needed, and return true if CRYPTO_GENERAL_ENABLE
+ * should be used in the host controller initialization sequence.
+ */
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
@@ -117,6 +121,10 @@ bool ufshcd_crypto_enable(struct ufs_hba
 
 	/* Reset might clear all keys, so reprogram all the keys. */
 	blk_crypto_reprogram_all_keys(&hba->crypto_profile);
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE)
+		return false;
+
 	return true;
 }
 
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -651,6 +651,13 @@ enum ufshcd_quirks {
 	 * ufs_hba_variant_ops::init() must do it instead.
 	 */
 	UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE		= 1 << 22,
+
+	/*
+	 * This quirk needs to be enabled if the host controller supports inline
+	 * encryption but does not support the CRYPTO_GENERAL_ENABLE bit, i.e.
+	 * host controller initialization fails if that bit is set.
+	 */
+	UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE		= 1 << 23,
 };
 
 enum ufshcd_caps {


