Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026686;
	b=cHrvhgVBCGZB3LOE2aTM1hMIq0e0wWs5AP++rVq0vco9oyS4UrA+N1YsRbqEPKsQiaeS
	 1Cpsp53OYpeZTGTmM4MDJ5wHV1lGZdApLhQMpAGULQWwT65N3T0nADLlOhGPH0bHq5dAi
	 /uzjvXkRqGUscMH4rjUSIvcKsuI4DokYzvcSlg6N9T1aQowx21K4U/1x8OkcR+9foltKB
	 McpXCkkQ9F4PyZwcE0c+JSkgab/tyMe2vbTELHZUiFoR8/0zc5r9BFp3H6+qHZraL13bh
	 b+JUAUz2dBSeDTMZCb0exhO5cQH2w5I4Zzmc1ezcScDyIKBwMnGBgOp+743cRO8NDgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8I90pFx1GyAujWjIH/yvyQs5R9wq0F9w6tsIeBwimeE=;
	b=vN5T3NnBuhcpDLESLUeMQ3dvaJu7dPx4UZoZ2YH69zrMPAA5f2Eq5HsZcOzip51Mxio8
	 fZ/eXANAiivLbxtPrWd2GTXxDhRckj+1a9jd2Hbq4ANGLsYon2qLWp7fXnpymhztLYPNd
	 IqkQPdJ1olOPrfz+XIoZ9XvdMkJrV0wnXKi5wtAH9i5uPwzeCjTbIrIi98j5BoXQsevJz
	 udNkLbtHc2N3AfO2s5047jSXEL0o+SDoIRqsDx5SbU6EMBJjDyaoJHtDuYxLjlgamFmre
	 CFAIY3nOI/pBDk3vmIMhHc0qibfH0rqPasuU/QzyshbFoojbWb8MdeygSxpTSIorrFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3ec8aAy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B0B606A320;
	Wed, 18 Nov 2026 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3ec8aAy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3AB1F000C5;
	Wed, 18 Nov 2026 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026686;
	bh=8I90pFx1GyAujWjIH/yvyQs5R9wq0F9w6tsIeBwimeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3ec8aAyzB+QpkXXal0oGmnnYPbgtCHgKjns3cDMF8DVGgLOO88MiFHBGSXoahiVA
	 XJDb0etjRpAN/62y2dgMZe34VdshQg+XAKhTk0SkEXVh13S5SlyhVe64FcSZAYXVt+
	 OThAXjQf4FbjPzuJihB7Djo+iR4fCvlUnnKsRFpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1524/2151] Bluetooth: btmtksdio: Pass the hardware device id to mt79xx_setup()
Date: Wed, 18 Nov 2026 15:54:19 +0100
Message-ID: <20261118150217.350839557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 70f7fe7ba2930..029cbc7e35071 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -892,14 +892,14 @@ static int mt76xx_setup(struct hci_dev *hdev, const char *fwname)
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
@@ -1112,8 +1112,8 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
 	char fwname[64];
-	int err, dev_id;
-	u32 fw_version = 0, val;
+	int err;
+	u32 dev_id, fw_version = 0, val;
 
 	calltime = ktime_get();
 	set_bit(BTMTKSDIO_HW_TX_READY, &bdev->tx_state);
@@ -1155,7 +1155,7 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 		btmtk_fw_get_filename(fwname, sizeof(fwname), dev_id,
 				      fw_version, 0);
 
-		err = mt79xx_setup(hdev, fwname);
+		err = mt79xx_setup(hdev, fwname, dev_id);
 		if (err < 0)
 			return err;
 
-- 
2.53.0



