Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A818F4F3919;
	Thu, 17 Sep 2026 15:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659822; cv=none; b=JwWahm/buVymx4NwTizvw9O0hnZ5jK52lBxi/ykgc03NQBYOZMhIdawILm1fJRkf92KjJoe42dOhr8i3iTp8a+WGZQKZ62rV4/mu0csGHhqqgGiApfwaMRfC+X9EEApC4H3RqTMrZu/b0RLjam3RoPqid+ZAhiw29HNBD65iG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659822; c=relaxed/simple;
	bh=ui1X2cudw+1mLdB7pwGRGp3SJytOouno2Jej6gHf/1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVuWE6d4CNt+Uew+zgSGStIUKO4aipUO8+CR/MJj9eceUAlIngDVWNlOMb5WcuK7cHDuhq1PzOmWMbXQGAYXTeX/evRjTqzNClo74a5Vgg3HDrtAoRIha0MInBgERqu5PLwtR5VusQvo/TGJRq3/GfihbMOMYkda0I82y9jjEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7yyVu93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7yyVu93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8251D1F00893;
	Thu, 17 Sep 2026 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659800;
	bh=+QOau4Q/MOg8wRMzS9WIE6VFu7UqiJBBJinH7BvkN7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7yyVu93kwbNf4TMf67rfsOyBey/jBcZp6FGivZVZr05Fsp7zWLm2tyUdzSQLZGJL
	 ZfMnt2UfeEgfJEsx3/7MDscvhAQF5/3IcWNUaAypkhXVcURGxGFQPwt+vVVMzy7foI
	 0IvLM05s48uDELIYUAkxnZFfcY1dN4+2xKRp3GAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 379/733] Bluetooth: btmtk: Declare MT7920 (MT7961 1a) Bluetooth firmware
Date: Thu, 17 Sep 2026 16:11:27 +0100
Message-ID: <20260917151401.114212898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Hu <ivan.hu@canonical.com>

[ Upstream commit 3d8a8e81ea8ad8813d4c82a12ba53ecb597b217d ]

btmtk_fw_get_filename() constructs the firmware name at runtime, so for
the MT7920 variant (dev_id 0x7961 with fw_flavor set) it requests
"mediatek/BT_RAM_CODE_MT7961_1a_2_hdr.bin" without ever declaring it via
MODULE_FIRMWARE(). Tools that select firmware from module metadata (e.g.
"modinfo -F firmware") therefore omit this blob, so request_firmware()
fails and Bluetooth does not initialise on MT7920, even though the file
is present in linux-firmware.

Declare it with MODULE_FIRMWARE(), as the mt76 driver already does for
the corresponding MT7920 wifi firmware.

Fixes: 1cb63d80fff6 ("Bluetooth: btusb: Add support Mediatek MT7920")
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 1 +
 drivers/bluetooth/btmtk.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 9589caff925de..26d525acd6590 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1577,5 +1577,6 @@ MODULE_FIRMWARE(FIRMWARE_MT7663);
 MODULE_FIRMWARE(FIRMWARE_MT7668);
 MODULE_FIRMWARE(FIRMWARE_MT7922);
 MODULE_FIRMWARE(FIRMWARE_MT7961);
+MODULE_FIRMWARE(FIRMWARE_MT7920);
 MODULE_FIRMWARE(FIRMWARE_MT7925);
 MODULE_FIRMWARE(FIRMWARE_MT7927);
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index c83c24897c954..bc26148ec5442 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -7,6 +7,7 @@
 #define FIRMWARE_MT7922		"mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin"
 #define FIRMWARE_MT7902		"mediatek/BT_RAM_CODE_MT7902_1_1_hdr.bin"
 #define FIRMWARE_MT7961		"mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"
+#define FIRMWARE_MT7920		"mediatek/BT_RAM_CODE_MT7961_1a_2_hdr.bin"
 #define FIRMWARE_MT7925		"mediatek/mt7925/BT_RAM_CODE_MT7925_1_1_hdr.bin"
 #define FIRMWARE_MT7927		"mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin"
 
-- 
2.53.0



