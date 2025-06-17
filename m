Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99BD238C1E;
	Tue, 17 Jun 2025 16:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179287; cv=none; b=LgOaA783fbTVqV5PHfCvraJVCROGIJH4s2htcqTGO7J+jCR2iXHWpHrsQ8SsghZ+tQtEGi1sAgWTcrTbWTjN1WFgMnK72AbaY7z92TsBBnATecJLIimiQNUqtGPOVqi6voj/l8aCm4o1lMzFilPfsGESpDMae6HS5B7VrcPwR+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179287; c=relaxed/simple;
	bh=LhVJj8SPGmTgjNrB/wvjq5ZcUsNhYQCR9/wBGSl31GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qxt7KlZKi+WExHjrBNgB79XwtZ9LP295QrfPJPU4f03Wqn1DdPKXH2BZ67vj7DVw2V5ThmiUwNj/Iz81P5OoghKcfeCzwZ5xrht+L05Tdznxiqt8W0E4Jv1M3T9wcNzY2Kd89ldPJbLGw04dFoBC0zoFUEyxJfgn4pt4moz5v8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imYi2nGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imYi2nGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8D7C4CEE3;
	Tue, 17 Jun 2025 16:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179287;
	bh=LhVJj8SPGmTgjNrB/wvjq5ZcUsNhYQCR9/wBGSl31GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imYi2nGMBy8D3DAlI85oq+qShJRC0MSLhyz9cZu2PcsUjvEFsR3f7qAEOBv6JgTwk
	 5Z2tzrLRGEU4++8FVcRyVymNgwrwt2nrzAgUaW9A6OriqJ1SotLHUL3QIJElqKZvUV
	 cQAbhUSiCIt4KYZmLNQkKt3V8b1lD37y0dNXGbaM=
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
Subject: [PATCH 6.15 676/780] wifi: ath11k: validate ath11k_crypto_mode on top of ath11k_core_qmi_firmware_ready
Date: Tue, 17 Jun 2025 17:26:24 +0200
Message-ID: <20250617152518.997618601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c346a8df2df1..22eb1b0377ffe 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1947,6 +1947,20 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
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
@@ -1965,20 +1979,6 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
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



