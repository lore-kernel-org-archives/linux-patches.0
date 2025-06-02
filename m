Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5B233727;
	Mon,  2 Jun 2025 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873963; cv=none; b=lYBr9c2y0l71W01uu9f9vJPv4iXSYE+t/ptNK8bTIH9kMZ0JCI+ogUhMtggg3ka4bEb9cv9XjpVLG/dIbt8q0LpUfa37MI/loG4ge3RorG5VvqPlW9j3j9dvFdxMZd9Se+HjvJeF7Fh3ZKHYGBf+sb7EnJAeKYY+p5sAkgnVeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873963; c=relaxed/simple;
	bh=YvFqAsLXapJ6e/Th5XhM7d0tPr3GBaE49naMSOPicFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtF8lrYExXXhFXEW4rF2MZiyTVWRl+ZMrV+dWLTJbehdftuNAdCz55MJ3pSlzAH8EKC1/P48wQ3O7fAi6bSUozDqq4EMEA9fxCGX13SiI216ImVVyvoUYrGSxZrBTby0QNZG5cVXmmhiCY5hrs37hqFMRWOC49PaIVMY8RNQ2gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcJbxMw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcJbxMw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3688C4CEEB;
	Mon,  2 Jun 2025 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873963;
	bh=YvFqAsLXapJ6e/Th5XhM7d0tPr3GBaE49naMSOPicFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcJbxMw1y9X348JE0EKx6dCGW05ZNN7l4kyCNtwtNcykR07DjvBMtWJxtYoQeFgm6
	 agWeLCia5eWcQCfXB5uq76nVODiIasFPixbWWEO+Zu0HI5xOUWowohgZ3esrTxf44n
	 OCS/lvg6WUBl5p8z9slnDQ+K13duWF77Py1ZMb6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/444] wifi: ath12k: fix ath12k_hal_tx_cmd_ext_desc_setup() info1 override
Date: Mon,  2 Jun 2025 15:46:08 +0200
Message-ID: <20250602134353.276243014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit df11edfba49e5fb69f4c9e7cb76082b89c417f78 ]

Since inception there is an obvious typo laying around in
ath12k_hal_tx_cmd_ext_desc_setup(). Instead of initializing + adding
flags to tcl_ext_cmd->info1, we initialize + override. This will be needed
in the future to make broadcast frames work with ethernet encapsulation.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250127071306.1454699-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 25a9d4c4fae76..474e0d4d406ea 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -118,7 +118,7 @@ static void ath12k_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab, void *cmd,
 			       le32_encode_bits(ti->data_len,
 						HAL_TX_MSDU_EXT_INFO1_BUF_LEN);
 
-	tcl_ext_cmd->info1 = le32_encode_bits(1, HAL_TX_MSDU_EXT_INFO1_EXTN_OVERRIDE) |
+	tcl_ext_cmd->info1 |= le32_encode_bits(1, HAL_TX_MSDU_EXT_INFO1_EXTN_OVERRIDE) |
 				le32_encode_bits(ti->encap_type,
 						 HAL_TX_MSDU_EXT_INFO1_ENCAP_TYPE) |
 				le32_encode_bits(ti->encrypt_type,
-- 
2.39.5



