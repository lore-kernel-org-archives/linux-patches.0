Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020210;
	b=CcL9zORRaUUJkZ5e2KvSM7rOxMb3Txs8fOUpzm5lWKmYwKNAGr44o85jl31/dHo3m3lf
	 WnqlSph81N7Hbt0shP0a1J70XGi7wnrPOIEF/S2T6qHPeMh+QtTnD6DScHBDiDO4gCod8
	 CpaGT4mLY0pP88qe2izolSc34StDJaasX9QAFRklNKGlFUMeEqVL5iR/5W+pS/CiwxGSA
	 An63pMwz2KGvVfHLuxnaBkoqLd2a0MEVVAvVYb3mEhdmff0nboxffVJTTrtlswaY5sCnS
	 aFDUQTSRPCsnh58SNhWLMkdffpFDXeNhYb05Mo5IQyvQAv+QzUl3QFD2CmT2J16Ij+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4eMl90AtPNW51nnuYtBT5mVod2F6DVYCBYWo4D0dEiM=;
	b=hcz5+2qOx7Wp643in7NsMtgm2NT/Ycp5TbPu+beRFc5RR8Z9d9k0uEZiPLUywB/CgCz9
	 uHkVKEwVsOc7ramElXsqQzN1drue43qhyCNm2eM2cfrrQzUOWKpCPpNtgEIMV27wKVjN8
	 25TdbZxG4oPNVGvNY2j6PWkeoCXI5mrkZJwG9ttvydfr0uNTDiRJzKGNyVOAw5YcV53vh
	 WDGDpqszUJDl6jkT0DbcDlSUIhRDOeT0rHmse/e/ApU8nrfrz22fPSzsINY4W0lMTTkoS
	 EEAqQtUsrPxNONRBkEiz7tD9jc5IiiGyfG7q9TZ6ZJDMi1OxGezW4XGJiVZnMW4TyEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8zoFczv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6084606A320;
	Wed, 18 Nov 2026 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8zoFczv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E991F000C4;
	Wed, 18 Nov 2026 16:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020210;
	bh=4eMl90AtPNW51nnuYtBT5mVod2F6DVYCBYWo4D0dEiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8zoFczvDCXNmzwkVvQ2JX3UC3gaZQdnyAze3AYFpzPEz/xLjaHD/vL/6XZAIAM3o
	 4pC5oEbV9CikRdy6fXh0zi1UB9INvaN7cb3ZkYFdTFXpIIYDTi+B7XkS6Qf8AwFZV1
	 QUZGEZ5w0upJ1TM4BlSgi75P7fzSkXq6H6BJy36M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1869/2651] Bluetooth: btmtksdio: Pass the hardware device id to mt79xx_setup()
Date: Wed, 18 Nov 2026 15:51:49 +0100
Message-ID: <20261118150354.254193528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit a2bb734c368766a2499ed00590ea838cac13c76e ]

mt79xx_setup() passes a hardcoded 0 to btmtk_setup_firmware_79xx(),
discarding the device id that btmtksdio_setup() has just read from register
0x70010200. That argument only gates the section filtering for MT6639,
which has no SDIO interface, so this is a no-op on supported hardware and
carries no Fixes: tag.

Pass the value that has already been read, matching the USB path. Declare
dev_id as u32 while at it, since that is what btmtksdio_mtk_reg_read()
writes through the pointer.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 79a2adb7fc5ef..ba907845d8257 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -909,14 +909,14 @@ static int mt76xx_setup(struct hci_dev *hdev, const char *fwname)
 	return 0;
 }
 
-static int mt79xx_setup(struct hci_dev *hdev, const char *fwname)
+static int mt79xx_setup(struct hci_dev *hdev, const char *fwname, u32 dev_id)
 {
 	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
 	struct btmtk_hci_wmt_params wmt_params;
 	u8 param = 0x1;
 	int err;
 
-	err = btmtk_setup_firmware_79xx(hdev, fwname, mtk_hci_wmt_sync, 0);
+	err = btmtk_setup_firmware_79xx(hdev, fwname, mtk_hci_wmt_sync, dev_id);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to setup 79xx firmware (%d)", err);
 		return err;
@@ -1129,8 +1129,8 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
 	char fwname[64];
-	int err, dev_id;
-	u32 fw_version = 0, val;
+	int err;
+	u32 dev_id, fw_version = 0, val;
 
 	calltime = ktime_get();
 	set_bit(BTMTKSDIO_HW_TX_READY, &bdev->tx_state);
@@ -1172,7 +1172,7 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 		btmtk_fw_get_filename(fwname, sizeof(fwname), dev_id,
 				      fw_version, 0);
 
-		err = mt79xx_setup(hdev, fwname);
+		err = mt79xx_setup(hdev, fwname, dev_id);
 		if (err < 0)
 			return err;
 
-- 
2.53.0



