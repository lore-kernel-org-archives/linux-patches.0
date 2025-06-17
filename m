Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645412F4328;
	Tue, 17 Jun 2025 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178033; cv=none; b=O+erXwD6Eja7dAQvNdl3aG3/SuqaFKWROPn87va3hjRm1CY6gi/73pfJPTgF9JcoFuOmT2bgsoB/4KbvK3KRlBAVaFm0Q1cwVv3xiHe4P3GV1RjU217CFSA7KcgOv3r016e736JAmCzsK/jRuhyMQQWNMNMmRJfNo0EYRq/0z08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178033; c=relaxed/simple;
	bh=JA0vn0W7D/XKCXXV4DPPR9FEBbpLNsGgCDSvlLVgt/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8mJ18a52losmwBdYhA7vMPBeTHXuZKF81tmESYv6KDdG4yWuPhIY/0LcKEZLuTAeDCztPoclpXanfAU9o7qc9KQDXmvSp/pOP/RKT/4Mh/O+NXjdLFmJjDXSfpDy8tsygwiHjitbqPI1Zgw62+sqqK9qco3xDE6b1thyuApITQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyJFw1u0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyJFw1u0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86DBC4CEE3;
	Tue, 17 Jun 2025 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178033;
	bh=JA0vn0W7D/XKCXXV4DPPR9FEBbpLNsGgCDSvlLVgt/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyJFw1u0DYqLHv5ms9KGmc/IxewvGETzQuAusIuRG3IWLe9NYhsEaqLNwK1wgdW+W
	 0KGuCRb+3iaI03B8e6JNgkKZy8YMCyuWoF3xA8bYpjj8LGmhoUZJuEGv0IGCRhlNml
	 xnWf4jX4c9rNjdTjxytC177wHlHGHJ/cEFb3Mito=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/512] wifi: ath11k: validate ath11k_crypto_mode on top of ath11k_core_qmi_firmware_ready
Date: Tue, 17 Jun 2025 17:26:40 +0200
Message-ID: <20250617152437.155431589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit b0d226a60856a1b765bb9a3848c7b2322fd08c47 ]

if ath11k_crypto_mode is invalid (not ATH11K_CRYPT_MODE_SW/ATH11K_CRYPT_MODE_HW),
ath11k_core_qmi_firmware_ready() will not undo some actions that was previously
started/configured. Do the validation as soon as possible in order to avoid
undoing actions in that case and also to fix the following smatch warning:

drivers/net/wireless/ath/ath11k/core.c:2166 ath11k_core_qmi_firmware_ready()
warn: missing unwind goto?

Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202304151955.oqAetVFd-lkp@intel.com/
Fixes: aa2092a9bab3 ("ath11k: add raw mode and software crypto support")
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250522200519.16858-1-rodrigo.gobbi.7@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 28 +++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index d08f40f77031a..8002fb32a2cc1 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1812,6 +1812,20 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
 {
 	int ret;
 
+	switch (ath11k_crypto_mode) {
+	case ATH11K_CRYPT_MODE_SW:
+		set_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
+		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
+		break;
+	case ATH11K_CRYPT_MODE_HW:
+		clear_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
+		clear_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
+		break;
+	default:
+		ath11k_info(ab, "invalid crypto_mode: %d\n", ath11k_crypto_mode);
+		return -EINVAL;
+	}
+
 	ret = ath11k_core_start_firmware(ab, ab->fw_mode);
 	if (ret) {
 		ath11k_err(ab, "failed to start firmware: %d\n", ret);
@@ -1830,20 +1844,6 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
 		goto err_firmware_stop;
 	}
 
-	switch (ath11k_crypto_mode) {
-	case ATH11K_CRYPT_MODE_SW:
-		set_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
-		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
-		break;
-	case ATH11K_CRYPT_MODE_HW:
-		clear_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
-		clear_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
-		break;
-	default:
-		ath11k_info(ab, "invalid crypto_mode: %d\n", ath11k_crypto_mode);
-		return -EINVAL;
-	}
-
 	if (ath11k_frame_mode == ATH11K_HW_TXRX_RAW)
 		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
 
-- 
2.39.5



