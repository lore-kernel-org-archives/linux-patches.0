Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F33F24CEEA;
	Sat, 12 Sep 2026 10:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210459; cv=none; b=AlWpznYXkbwgN/nOIiwuZrHJPc2FQv6CuTeJIENhjGoMdK4QdU5yKRjfJOLhoZM+qHjl0ejWwRjVqAjY8lfLH8no6dWIgohn25JLZ2zr7CtZtPrvxmbmLuyS/tUWMcx5fofOEWO0bNEVO+pBdJRgW0VuQW+PLlSd+7aOGIiR6yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210459; c=relaxed/simple;
	bh=ia9ZWW0MZdlmLYuA/Ow5sHwfynmukzbKgbA+/b3GaLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qrk3YTLZunuV93MNrtvngY/KlVkkmewt5K+sFELshBiIb3VZHYNXphk7b8Ei2M/zxtVjinG6P1Y2Hf3kIBTnsHY+FT0FfV+J0SB2WfGc0MS9e/WVpZEkMlIgjG62TJZlJE2Nty3OCnp9E52Zzqoa2gTOhItcfTCZSMoNRGXMAMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXH+8/L6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXH+8/L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AFF1F000FF;
	Sat, 12 Sep 2026 10:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210458;
	bh=bSHoLZJLbZA8ZfILEhHEAbo3l16nNzI69NjahISqhCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXH+8/L6nkIwSpGzM/Uje7x8F3ojezkRM0yvtVmLORGIgY652WBLjQPV2lhp/wsos
	 3BKu4+sy42Bo/y9sTXuaOkbPBhMV5Xl2FM49qbEGrqPbFGLuBdH0+LxvLPQ9oqpUcD
	 O5iIjdVHq+oAaL3rIQLhTC1iIF6ZTSXl6oOMHXsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1030/1518] Bluetooth: btmtk: add MT7902 MCU support
Date: Sat, 12 Sep 2026 08:53:19 +0200
Message-ID: <20260912065646.751754167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit aab25984e55972e53f3e58821cb85a7101876056 ]

Add MT7902 device ID and firmware filename to enable MCU firmware
loading.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: b0c0b3794011 ("Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 1 +
 drivers/bluetooth/btmtk.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index df0b59e6f968b..580df595b4301 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1335,6 +1335,7 @@ int btmtk_usb_setup(struct hci_dev *hdev)
 	case 0x7922:
 	case 0x7925:
 	case 0x7961:
+	case 0x7902:
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, fw_flavor);
 
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index 5df7c32966247..b4506186b2f70 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -5,6 +5,7 @@
 #define FIRMWARE_MT7663		"mediatek/mt7663pr2h.bin"
 #define FIRMWARE_MT7668		"mediatek/mt7668pr2h.bin"
 #define FIRMWARE_MT7922		"mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin"
+#define FIRMWARE_MT7902		"mediatek/BT_RAM_CODE_MT7902_1_1_hdr.bin"
 #define FIRMWARE_MT7961		"mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"
 #define FIRMWARE_MT7925		"mediatek/mt7925/BT_RAM_CODE_MT7925_1_1_hdr.bin"
 
-- 
2.53.0



