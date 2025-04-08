Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FDF267B7F;
	Tue,  8 Apr 2025 11:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110563; cv=none; b=Ln/VJHWdnwLsdTwKajT6iPRpCwogU5N/K2QTrjZAyGfvEWUjR+Q+YrUIRTRSitMnvAtZpyAT1u82uYEiOVS7E0ScEERl7gpRSMB67d6AxCR7TMRFq26rFXb1xnHMUg6YpV9LHdrJgTVv4jAEA2nKy3RTns7gmC+gjdvT5V0oauc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110563; c=relaxed/simple;
	bh=b0yzXPlNc5s1hmIteTTtoUNfCFw0aS7YOYAbrm0DYkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaFCrwcozH2nlqcIrW4lGQUH4akYN5tno4BK+iGcbh2zKD/fGPvzAkN79L6jla9gbDirc53qTH9zww0gPAuvW57t9E85wZ8RocUGJIZLPhZDGn3fLr/JUo0f835VTFVyCijAJVBwoEK14dw+0A2gdnAMU+f+8nw5zOn0WF0u+SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4hp3wBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4hp3wBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF26C4CEE5;
	Tue,  8 Apr 2025 11:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110562;
	bh=b0yzXPlNc5s1hmIteTTtoUNfCFw0aS7YOYAbrm0DYkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4hp3wBUuQSOiObkdJhWLKQW6nOBPckmpnqu8BArDvayPj8M6v8tkbirw7WNr3zug
	 mHsQPmJdgRXqYC8QDiqkew8Aslx5C+ZzSnkBUzIhfxmjZIMrx6fn0oz2UXQIr/uR7Q
	 PrHsPMwj1j1j4LdDuFfN2JmsxUe7QjnWo5Wi8poU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 110/731] wifi: ath12k: Add missing htt_metadata flag in ath12k_dp_tx()
Date: Tue,  8 Apr 2025 12:40:07 +0200
Message-ID: <20250408104916.835019591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit af1c6007a64e78b729eb5a8d149637a820077bee ]

When AP-VLAN support was added, the HTT_TCL_META_DATA_VALID_HTT flag
was not added to the tx_info's meta_data_flags. Without this flag the
firmware seems to reject all the broadcast (ap-vlan) frames. So add
the flag, just as ath11k did it in the downstream QSDK project[1].

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: 26dd8ccdba4d ("wifi: ath12k: dynamic VLAN support")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://git.codelinaro.org/clo/qsdk/oss/system/feeds/wlan-open/-/blob/win.wlan_host_opensource.3.0.r24/patches/ath11k/207-ath11k-Add-support-for-dynamic-vlan.patch # [1]
Link: https://patch.msgid.link/20250124113331.93476-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index e0b85f959cd4a..1fffabaca527a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -368,6 +368,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 		add_htt_metadata = true;
 		msdu_ext_desc = true;
 		ti.flags0 |= u32_encode_bits(1, HAL_TCL_DATA_CMD_INFO2_TO_FW);
+		ti.meta_data_flags |= HTT_TCL_META_DATA_VALID_HTT;
 		ti.encap_type = HAL_TCL_ENCAP_TYPE_RAW;
 		ti.encrypt_type = HAL_ENCRYPT_TYPE_OPEN;
 	}
-- 
2.39.5



