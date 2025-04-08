Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4D125FA29;
	Tue,  8 Apr 2025 11:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110479; cv=none; b=l4nVIiYpCEm9sLXdqVQ0WUrbsFy3fZMTTdi4a2E3YT9SDagJe2hgkHD2XKpCMzeD8SR6670EwSq5z9zmGSrXKwmXYW+pm1uccjN4owZ3lGcrX5KQx776eWK3z9349bx4aKWLHhndMX/Yjuzj272TBAfLx3sMlY/lMtLy6dH5Ny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110479; c=relaxed/simple;
	bh=ZRG+l9hp4NbNt0eOQAc8bZwKEUSMiB8gcz2iyuZ41Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRGl/+qnwtidlJ2cqfloi80pMEX6KE9vVh8HE15BWn1Z2TETx4SGPz7SRsk5QPkcILeQ2S17C4p7m1jZysFYfDphdl8b4spkGt+qUbB8BVdxWQ/3XV3yv7Za2XMg+Qq8xu2+WRjzAIeJWQzI1t/AWjZd4KiBa994qxPhKNF2AaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InvLeeVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InvLeeVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA01C4CEE5;
	Tue,  8 Apr 2025 11:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110479;
	bh=ZRG+l9hp4NbNt0eOQAc8bZwKEUSMiB8gcz2iyuZ41Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InvLeeVvptP380bfNcTh5tzcnKHmFc5t3PgCYRocrm9h5psaf1salkaLwx7PwFwQe
	 HO0ho/jcSS3vwKw4NZDkla78i5dab4rvHCaHU93/JWWtSPJ1EZlFw+hPcWzQCiz4gn
	 98QQRMiqBfKOJgcgqooGt69E6Sf0nGiK2iKDP3bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Nicolas Escande <nico.escande@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 078/731] wifi: ath12k: encode max Tx power in scan channel list command
Date: Tue,  8 Apr 2025 12:39:35 +0200
Message-ID: <20250408104916.084562557@linuxfoundation.org>
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

From: Sathishkumar Muruganandam <quic_murugana@quicinc.com>

[ Upstream commit 07c34cad10ab0ac8b06ede8a7fbc55ecf2efa3e6 ]

Currently, when sending the scan channel list command to the firmware, the
maximum Tx power is not encoded in the reg2 member. This omission causes
the firmware to be unaware of the host's maximum Tx power, leading to
incorrect Tx power derivation at firmware level.

To resolve this issue, encode the maximum Tx power in the scan channel list
command before sending it to firmware.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Sathishkumar Muruganandam <quic_murugana@quicinc.com>
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Tested-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://patch.msgid.link/20250107-add_max_reg_pwr_in_scan_ch_list_cmd-v1-1-70d9963a21e4@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index abb510d235a52..7a87777e0a047 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2794,6 +2794,8 @@ int ath12k_wmi_send_scan_chan_list_cmd(struct ath12k *ar,
 						  WMI_CHAN_REG_INFO1_REG_CLS);
 			*reg2 |= le32_encode_bits(channel_arg->antennamax,
 						  WMI_CHAN_REG_INFO2_ANT_MAX);
+			*reg2 |= le32_encode_bits(channel_arg->maxregpower,
+						  WMI_CHAN_REG_INFO2_MAX_TX_PWR);
 
 			ath12k_dbg(ar->ab, ATH12K_DBG_WMI,
 				   "WMI chan scan list chan[%d] = %u, chan_info->info %8x\n",
-- 
2.39.5



