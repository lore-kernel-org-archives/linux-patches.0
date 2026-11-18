Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020344;
	b=j4HEt2fKVG6rLVTVs1J5Xpld2hx03PRcg+yaLxg8/lYHwLVWcHp5hKO7hzUNkgKsCLgT
	 vOouLntQzNHgDqkuSislerk5bz54XggC0Jx/OODrLT04TEbZy6Ux4Rejx/ZwRdKIydExc
	 AEBUAsdyZpBFt21pWUo+FxMoGr9Wc2wiPkfV28GD3HkHSJmOaPB6aAFs9v45DVhSy5HE8
	 yQl492tJx+W+seppTacC73k/uvvFn7tKz8td//Z1o8aaG7rPLVtDgLfD1ULO+XP/dEO4i
	 p7XSPs84jE+P/G5Vp+MqVGhCOtjS6J9TjMYbmxg10+f+Mcm8W8rOVCl2lOZzf/mqmiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d+Gap2eIiyYW3Jb2/4I3aYhk7fAuzLDll6eTxddNfqU=;
	b=12wVKulbupLd03JUFjs+s3S4ZgIP67Y2yMb1/UbRAxk7md6YWRuuFL+rT2x0ZxuiBSvu
	 iSez4OCiraSWAc5Ka0imjKsPQ/5hT1pxEdi74OT+f6WHuzeHAIJDQFJWZQjI1qBV1sUJO
	 VkSzCtLgrkTQi/IXMaChBfYLJ15ni4ZWpJMB3OcKXek+3wAAzcBjvjZPklsCBsN7zguck
	 ftqIXs7jmGR8O6wgqBGcHGeSx2OcXQ0h3a/IAIJgI7NNka7aQ26Wwp0beqhmpnmWYb8xz
	 GbpkieA/WyATKIJz3YtKixiVJcrxDA5Gn1lZD+zVFUI5FpbP6kzZLiEwp1ypVElCsbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yfnZKbpa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96400606A32C;
	Wed, 18 Nov 2026 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yfnZKbpa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D8C1F000C6;
	Wed, 18 Nov 2026 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020344;
	bh=d+Gap2eIiyYW3Jb2/4I3aYhk7fAuzLDll6eTxddNfqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yfnZKbpa+t6Wlt3qeS+TNVjU4j6V/kKAo39Ofq/R7Py9jQKX3BIl5rKc8gyyScUSf
	 IiO56oxyKTUkIw8M7Gol55C9qj55zszV7B9itInJJWusmK+XN1XA/swjqBj5UaG73R
	 ADmDQ8HULJwVcxyPUZ2HCQZh76gwKPGkA2TxoqQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1881/2651] Bluetooth: btmtk: Improve BT firmware logging
Date: Wed, 18 Nov 2026 15:52:01 +0100
Message-ID: <20261118150354.644769627@linuxfoundation.org>
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
index 4ae545cf065b1..54cfc83032fb4 100644
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



