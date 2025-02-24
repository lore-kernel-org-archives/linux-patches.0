Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B33412E5D;
	Mon, 24 Feb 2025 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407897; cv=none; b=nKvUpb8gqaqM79peqrecuvzvOmubZjNMElAKhMRA6nMoHqFGLuaJNHsK4U5wmjNbA0b6oL2LPSQFAudEf/lq/i7ptIO967JIep1OmXP+2HfdMCHmq9bO+D5IAAd5ZWeuVu8WcY1pwh4rcdGOcRJUjUBRWxzTFrDhvBNsACQw2NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407897; c=relaxed/simple;
	bh=eB+NywMssZAntyCyO5UO0GupMHsmdmOmR0inFp2CbxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCOz8eYNx6ori16d75AUCE0Hnn9K1LvDuOfn1qb5mTWN2lKRinktMM3vxzHSXwmYLWKYH3Lc0wZKbmXbnCpn/udREwcO4WUEtZeCUlZ3o6JersuR6czH1KfFrjeK0PG1Y2Ne/SrZ4jEiPTJRYkAeuiomSAFKa6oA6YRo8Fo+R20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJHVwZFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJHVwZFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76489C4CED6;
	Mon, 24 Feb 2025 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407896;
	bh=eB+NywMssZAntyCyO5UO0GupMHsmdmOmR0inFp2CbxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJHVwZFiuIJIxQaNM4ZR6PASEPtQVlOSHhrjj3pQDB2Mqvo1NNq7E9HCiOwfz4bFs
	 7cq77eaJLWNnqzgNzZ9ucQkIVgWc3b/sXqmBEhSS3T2+jjURTRSU6NXt+KSzpwebWb
	 QUHlMx1QxEi0hPufNnmgYCqyKt/R7sLHHAZQnjgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Steev Klimaszewski <steev@kali.org>
Subject: [PATCH 6.6 041/140] Bluetooth: qca: Fix poor RF performance for WCN6855
Date: Mon, 24 Feb 2025 15:34:00 +0100
Message-ID: <20250224142604.623055661@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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



