Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39361946C7;
	Wed,  5 Mar 2025 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197033; cv=none; b=dHaUldLeDC89rNMoqMnlQ9GLd0n4bN9b1GFqIfsvRGaw0GQX0DmV1US6fefLRzOvxKma/0p+uQZOjMhFafn2jLMkdkUadDZ7t74EKmcogAgz1lAJebMLm9ew1wQLrfG6QdggV+a7DEYEkn1YLSbB2DY2Oc/dUaNfOXwxBLikrzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197033; c=relaxed/simple;
	bh=APAWL0jBUZBzKLcJwk/+PM7h7tRNeIVidZ8dyHhppe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyoHciEFi7rPlWXMM/m3nBFGpoLmIZ3iv6vXaQ97PCFyVSGyNwfUZHBPKUl6BPYspsZd8voE9fu/YXNv6fJGoN/yQlXJAI8RWJjveKJgrRPDYofo9X4bIKiBFGU8lqUJPniJTDCnSgC3JL1OZb7cUvjH1d7EftBrOSohRUAcFm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T43llqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T43llqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEA2C4CED1;
	Wed,  5 Mar 2025 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197033;
	bh=APAWL0jBUZBzKLcJwk/+PM7h7tRNeIVidZ8dyHhppe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T43llqSe6Q1RHc3n6C2+laAFdSTil7hq/Yi3FAzSni2ugY2ioD2Pz7PrgQuow6rz
	 Kbb5QyXJzGeD8c5OAKOkO0woFZPqg1O33bGzn5p70WMUlC83cFOGIAuTbHrXFaE0NY
	 braZ+wwynnF+HMtM5Pnkf8TXf902+bFlw7z+YCt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Steev Klimaszewski <steev@kali.org>
Subject: [PATCH 6.1 017/176] Bluetooth: qca: Fix poor RF performance for WCN6855
Date: Wed,  5 Mar 2025 18:46:26 +0100
Message-ID: <20250305174506.152928182@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit a2fad248947d702ed3dcb52b8377c1a3ae201e44 ]

For WCN6855, board ID specific NVM needs to be downloaded once board ID
is available, but the default NVM is always downloaded currently.

The wrong NVM causes poor RF performance, and effects user experience
for several types of laptop with WCN6855 on the market.

Fix by downloading board ID specific NVM if board ID is available.

Fixes: 095327fede00 ("Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855")
Cc: stable@vger.kernel.org # 6.4
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Steev Klimaszewski <steev@kali.org> #Thinkpad X13s
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 484a860785fde..892e2540f008a 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -927,8 +927,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 				 "qca/msnv%02x.bin", rom_ver);
 			break;
 		case QCA_WCN6855:
-			snprintf(config.fwname, sizeof(config.fwname),
-				 "qca/hpnv%02x.bin", rom_ver);
+			qca_read_fw_board_id(hdev, &boardid);
+			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
+						  "hpnv", soc_type, ver, rom_ver, boardid);
 			break;
 		case QCA_WCN7850:
 			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
-- 
2.39.5



