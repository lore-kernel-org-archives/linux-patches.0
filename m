Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026703;
	b=IHXLdH7rjDQrBRRO1ohJY6iiEkezm/Nhv+E1voClRbS9I/nFeb7I7OsSmlF/6+Evxzlg
	 M4pGpA31eMvWjh1xheQYw8TjVKrtGk4wGerAkw5pmuYUhwObb4uJ9Q8nSrPNi5utzyn1r
	 v0s2wXt0zAwiCOAeSHgxaZ1g538huk7rtenhS7G1IGO1986mG5y8xrGfbShJ2H80Mk7Fa
	 nPxgcVRvdhT1LtcqWt+s4az5crp6JOz2C41g8AhmWHgKBABW9mS4JVXukHBQZ0LKhQnnb
	 B4u+poEMhwpYsDUshGyP9MZFKvsng3HQ/Ft0pPgIumHM0ufXLC6WceI7yOb9hm4e+hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0dR9c07fv2qwbYcCj/ZLkynz93pesIThabVfxvD0Sr4=;
	b=Lv96hWC0GRDoAAFKxAvI07h3Eh3fsoZQ2ltMEZbvNe/Nk99w02TympaWMajFlBT6lh33
	 0Jfyy6PaHqaeHPRy2tvEhME8b4I6vbtlaEx6EbFI0vypS6wcfMQ/BMgATc94C8Cql1l4r
	 QaICkKcjBIa/0Z32tLICw7cqGCkktZ9LW1L8T2Tuz4iTUF74ZqBFKzOXunSHTY8+ZEEvH
	 p3QoySy8l2AR54KWLEbuY113I0wLkfamvgymo9G/xqWXuIF7rsc8Qjcd87YLD+KjXzDza
	 KoW9u5EdvFOS4ePKZGwoeeIpLidnWPDFojj7U9dzuspt9eNCBu8Fzuqpxr+KnvBLxbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwW42AZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B64606A336;
	Wed, 18 Nov 2026 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwW42AZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C341F000CE;
	Wed, 18 Nov 2026 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026703;
	bh=0dR9c07fv2qwbYcCj/ZLkynz93pesIThabVfxvD0Sr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwW42AZeIjG05uxtpgSnsNffkJEjKAo2Xw/UTClm+xZDTmPeHPDSSkCxPVjpC06VF
	 LNwKyA18znNO9XefNmhohNEMTaa1pQ+xxvN/BeWc/eZLHUiNfmyi5RpakbdoZTyO5o
	 pNErLMxTmOoExWFD9xV3Po4+f/Kcih9Kpbhppnkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1529/2151] Bluetooth: btmtk: Improve BT firmware logging
Date: Wed, 18 Nov 2026 15:54:24 +0100
Message-ID: <20261118150217.524571913@linuxfoundation.org>
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
index 528dcd000d303..61a6f33ba658d 100644
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



