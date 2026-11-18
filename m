Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031905;
	b=K7g1f93g62LkSKakz/uIW+zeLbIGegxOPwRmNp5Eia8DQEe1Rj1F+u9vDYbsr9Pi9Smy
	 j1h4G0CVa2sE/EF4jI9/Q41SLO7G1fQyreL/5vMuwPq4h3ALrUwpqwV0y9NliiPpSMJTG
	 No74xCn2vgNWOFIvHuD5QP/yYCI0+zg03VTPThnb/2XzkEwNL3+XCAFNKgqtVC15+LZiX
	 CyuMvIcq1xMEzhUcikDcLIZBBjv9Wq3YtQSyb3AE3tZNo0FtPYejcMEeCcNcigNcPxmj9
	 UZH8+grT32HX1S+K/wg9iUyrKuxKxcILQOSFmxb/jD0Rvudb+giCGoBPmsMiHJmbQqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C0oYvkcWOrhpY4ba9RvtuC38M9rylT9/iWrRau7FeHg=;
	b=soWk0oLwKjFoqOn0nMobi1LgrI0BH1U5XqkT4bqi1e5M4B+yv/uzRTpd4WXA9/IHCJ/T
	 /Go+xgOgKDQT7QZHdLEhNXSy5gaVJBsLeHuyCvmiNrXo+XbsUxlGcMOohMHzPhdo7Wywv
	 9kc1srY/kzMe8Js2vGfvLZFtsBUI8EUp5gL5M88F0t3xVw+3K8owMuwH2R1lwlQ2zZfK4
	 kpqWWrCMuGbxz0PTzQZXek1747M1nFJ8fbcpAw+xSUDorY9HdIa5llBM6hBhS60iokpjS
	 kwE+4w2i9nD8m4O5M5o6q1UsPXQ7rwic6e9T4gYem5xtKMX40PFfRjEmfTiJWBayLQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LrNRwRwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A483E606A320;
	Wed, 18 Nov 2026 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LrNRwRwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BD51F000C6;
	Wed, 18 Nov 2026 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031905;
	bh=C0oYvkcWOrhpY4ba9RvtuC38M9rylT9/iWrRau7FeHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrNRwRwE07PDmV38YhiBPhx1eBZeXBrhYQ9jCrMykdu575KN1VWR590sLo9Vgzv5H
	 RShhcgM4Z6vRee+kNbRHR9DCKiq+Y8WXR9To6BAuP7xrgGP8SSgktrAmFwU4ZCqwx2
	 VeVYAi2kMFROTBvGLsmJFFCHS4WbbgkCnr3s6hqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1222/1756] Bluetooth: btmtk: Improve BT firmware logging
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150058.482958506@linuxfoundation.org>
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

[ Upstream commit 046fa20e9c7abbafb166b431fe446c49b71cb15a ]

The firmware log line in btmtk_setup_firmware_79xx() never says which
file was requested, which matters because btmtk_fw_get_filename() derives
the name from the device id and firmware version at runtime. It reports
the firmware's own hwver field as the HW version, when the device id the
driver read from the chip is the more useful value and is already
available as dev_id. And it prints datetime, a u8[16] with no guaranteed
NUL terminator, with %s.

Log the filename before the image is parsed, so a file that fails
validation still says which file it was, report dev_id as the HW version,
and bound datetime with %.16s.

The datetime change is hardening rather than a fix, hence no Fixes: tag:
every file in linux-firmware terminates the field, and provoking the
over-read needs a malformed file in /lib/firmware.

Log output on MT7922 after the change:

  [  365.245951] Bluetooth: hci0: Loading BT firmware: mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin
  [  365.245956] Bluetooth: hci0: BT HW ver: 0x7922, SW ver: 0x008a, Build Time: 20260605203811

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index b5a03513dea91..d7e26ca8a0364 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -214,6 +214,8 @@ int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 		return err;
 	}
 
+	bt_dev_info(hdev, "Loading BT firmware: %s", fwname);
+
 	err = btmtk_fw_validate_layout(hdev, fw, &section_num);
 	if (err < 0)
 		goto err_release_fw;
@@ -222,8 +224,8 @@ int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 	fw_bin_ptr = fw_ptr;
 	hdr = (struct btmtk_patch_header *)fw_ptr;
 
-	bt_dev_info(hdev, "HW/SW Version: 0x%04x%04x, Build Time: %s",
-		    le16_to_cpu(hdr->hwver), le16_to_cpu(hdr->swver), hdr->datetime);
+	bt_dev_info(hdev, "BT HW ver: 0x%04x, SW ver: 0x%04x, Build Time: %.16s",
+		    dev_id & 0xffff, le16_to_cpu(hdr->swver), hdr->datetime);
 
 	for (i = 0; i < section_num; i++) {
 		first_block = 1;
-- 
2.53.0



