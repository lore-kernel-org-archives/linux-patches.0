Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D34547ECC8;
	Sat, 12 Sep 2026 13:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219480; cv=none; b=YCSZg6N+tdpEn/Y5HQERXSxFWehSVb0N+zaKfPqCUMi/ksuWNOLlOsYFhvZjb2aS4WIknMDE5WXRb1NA+RuAEWCrmlpdGRAihYVu85pve/enelv6RJ5lXD0rl/Y01cLFP90SKgcGFnV/8DIZ/pZMMWR1OmBQ6AHADCYzYPzMUxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219480; c=relaxed/simple;
	bh=fFdvjoYFIr2dDAmKAYDjVGEBRYd30eV2OOie+x7gPt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTC+D4DSlMNqLXvmLiEBS2ATAWGhDBZEPEZNnF18YFLcqQTtTygMmZXxNNieDAa1InuvCPekVWObPPwTEi1kaZU9YBg2+r3k345sWOgCUMXHbHrsZxc7CkwufQJunuzgkV1Kj6Qc75GFWxUymjph4fxP+piyx932pKVNVcaXvyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs6oR5uv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs6oR5uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1671F000FF;
	Sat, 12 Sep 2026 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219478;
	bh=DHfEpeMuJL4aMDAXcUbN1cJKrEJimaKtGTLUsCHwNgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zs6oR5uvaoxa1I/jefIm6SmRr0qwP7DxUaebAVd6/hwuXM7wIIURwUl0EpAelDgmI
	 ONr55Cng0L696TaMO5nH9Qbjc8hCwveseFU+UvrFm5KEfSe0wpx3qpPYhqglXn+jFa
	 L/Qhjns7QFXtyF/VjGomhANJ8ihLDE6EvVU1DOfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1359/1376] Bluetooth: btmtk: hide unused btmtk_mt6639_devs[] array
Date: Sat, 12 Sep 2026 09:03:05 +0200
Message-ID: <20260912065637.823679039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 81f971c6abec59240e2bcfc38756bda8172fa788 ]

When USB support is disabled, the array is not referenced anywhere,
causing a warning:

drivers/bluetooth/btmtk.c:35:3: error: 'btmtk_mt6639_devs' defined but not used [-Werror=unused-const-variable=]
   35 | } btmtk_mt6639_devs[] = {
      |   ^~~~~~~~~~~~~~~~~

Move it into the #ifdef block.

Fixes: 28b7c5a6db74 ("Bluetooth: btmtk: Add MT6639 (MT7927) Bluetooth support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 7e7ce595d5923..e7d01f1e26b8a 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -25,22 +25,6 @@
 /* It is for mt79xx iso data transmission setting */
 #define MTK_ISO_THRESHOLD	264
 
-/* Known MT6639 (MT7927) Bluetooth USB devices.
- * Used to scope the zero-CHIPID workaround to real MT6639 hardware,
- * since some boards return 0x0000 from the MMIO chip ID register.
- */
-static const struct {
-	u16 vendor;
-	u16 product;
-} btmtk_mt6639_devs[] = {
-	{ 0x0489, 0xe13a },	/* ASUS ROG Crosshair X870E Hero */
-	{ 0x0489, 0xe0fa },	/* Lenovo Legion Pro 7 16ARX9 */
-	{ 0x0489, 0xe10f },	/* Gigabyte Z790 AORUS MASTER X */
-	{ 0x0489, 0xe110 },	/* MSI X870E Ace Max */
-	{ 0x0489, 0xe116 },	/* TP-Link Archer TBE550E */
-	{ 0x13d3, 0x3588 },	/* ASUS ROG STRIX X870E-E */
-};
-
 struct btmtk_patch_header {
 	u8 datetime[16];
 	u8 platform[4];
@@ -471,6 +455,22 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(btmtk_process_coredump);
 
 #if IS_ENABLED(CONFIG_BT_HCIBTUSB_MTK)
+/* Known MT6639 (MT7927) Bluetooth USB devices.
+ * Used to scope the zero-CHIPID workaround to real MT6639 hardware,
+ * since some boards return 0x0000 from the MMIO chip ID register.
+ */
+static const struct {
+	u16 vendor;
+	u16 product;
+} btmtk_mt6639_devs[] = {
+	{ 0x0489, 0xe13a },	/* ASUS ROG Crosshair X870E Hero */
+	{ 0x0489, 0xe0fa },	/* Lenovo Legion Pro 7 16ARX9 */
+	{ 0x0489, 0xe10f },	/* Gigabyte Z790 AORUS MASTER X */
+	{ 0x0489, 0xe110 },	/* MSI X870E Ace Max */
+	{ 0x0489, 0xe116 },	/* TP-Link Archer TBE550E */
+	{ 0x13d3, 0x3588 },	/* ASUS ROG STRIX X870E-E */
+};
+
 static void btmtk_usb_wmt_recv(struct urb *urb)
 {
 	struct hci_dev *hdev = urb->context;
-- 
2.53.0



