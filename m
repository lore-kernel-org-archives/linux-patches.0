Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031889;
	b=4e6Wna2OzRXWay+4L+ToWa6hcsdBsaN4W5MJw3YfDJh7dWUxxns1Cd7QmU9XoBGP19f2
	 CKgjetLz8wWPQuoI+wcqgyAS2E46fAwr31Q/3LRNgYq5j5D9sp3D97OVZUaXYDrVVEq9F
	 RLGvuGMAzPs30h750BIwk02AmhVlKbFS4wltqGgKh+56RxpFPY2qmWb3jzXZdw/pRg+oV
	 xSNiCmdjlilvyWm5qq485uj630Pnjd1s5Cv0XhRqw5FHA+NiRGeBt6rLIOpuKF/v39301
	 SpWTyaQqn17o7ZtBB/N6Ej74N1YOXyHE+FJvW8FJIYZ+DnE81B/+6vAoXu8exdpD3+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QEA5FiA5HKJzHtBHadlBI6JmerJsn8j/sJhy4764J1A=;
	b=HmADOu/E2+dFUMeM+xyPC0olyzKnVXnKG24BLV7q7f98YNUj7gGZ2grBiBFqbrgOygRt
	 pGCp9rQQSjOxlYzDbhVjF+6Zf4SUupAm6JPxOA7xumH3BBZrKz/cGQgW/vOvJo6Fi+0Ti
	 cc8TW1zPPnxX7tWjxY/Rp9P6TwM+q/ixdXZ2JtBuvrnkd1EzXnmrWdPXBEl+f6RW2UtOb
	 5pA/aa2wRehRWoGo5J0blsXtVcWtvikuw3V8tCIfyA59n5iqnQBOAiv9yFywsQ2ooTF/4
	 S9Mz+uyqZLf43tZpzO0Gzd44YwnkkTAnqz/vhlWzaOHlLW2omdxHlRW30r6JgqTkBdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cdNR7oe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCD8606A32A;
	Wed, 18 Nov 2026 19:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cdNR7oe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3401F000C4;
	Wed, 18 Nov 2026 19:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031888;
	bh=QEA5FiA5HKJzHtBHadlBI6JmerJsn8j/sJhy4764J1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cdNR7oeKGeBkXXyrhYpda/8+P0ZXiE2buduYXf6K4APmU1SYbAQos/kMsWS4KFTR
	 xUx+IMcV6eJmOBHCLt6X9OqNGUzSzbv14k4+T7QVZPtBCowj1doTGK8Oq1ehAJR69n
	 XgzEhLOVfejCj0JQSTMyjAftkHKJ6KvvNtbPSv5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1217/1756] Bluetooth: btmtksdio: Pass the hardware device id to mt79xx_setup()
Date: Wed, 18 Nov 2026 15:55:44 +0100
Message-ID: <20261118150058.242133578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3e3e6970d48d1..7bdff69fd9d09 100644
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



