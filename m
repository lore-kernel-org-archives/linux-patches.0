Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031903;
	b=oaMtVHfvN9BbELzbMUIev4wtBASYC3kQw+Lfb+Oxma0aXN1LCqGkPRxM1p4wyDw/5n/6
	 +rGsyfDHehBEiGKMVo+w/mxrDmt0rBvZsxZ1kbelNsSJjDiIKL5xXySCpuAZ0pM6BGtu+
	 q/oC+mO2TxxLntFWqo4lG5twgbkPLd7FMzwYmd5fP8Gku7W1nX6+/RaDKy5FkQilUR/3G
	 UB5zoFySayDUqUpLILC1bX+H9neYRrHtL1cZc7pJTNrOX6doDZEp7eyeozjGnB2lzYMxL
	 LOezqV/5H2qOCSvGWa5VJvAf9NaVD14n1Ta3wMj5Kv5I549srT0CXNhNNP2gatKcR8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FA/EB9punmJjry2eGhPIRkqMynMcmzyV67CQ54EAP6Q=;
	b=L0ZnxECfyjctvxG65vIfjmeLMGjqjTZQdD/tFYXzcT7Sj5/ogBalTX/+IvWVBmwwEwHd
	 y0ccO3wEGCnEHUr/pWuQ5i6pyYudxiM+TiZyaODMvzK/huVcQwrMyW/j4qRzblTPcRfEY
	 7ml9NthdwwkfO5uA7evBH5FzcMhyiFASjvMBHz0lbUlNTHq4TGT5Okg0/K8ZfKz5cYWO3
	 fjN3h59mY+Q3vXHUOju7InvHwQQf5FDdY8JzYe6EE3GFw/TC3QyTXoAgZEltIYM+87WSa
	 pTEMcac9wlquNvDjA50M5+20DiCRHipSsvuveY5j3fqlaYG3OLj0gbRIz9OHpBtghFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhstT0r5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF0606A325;
	Wed, 18 Nov 2026 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhstT0r5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274BE1F000C9;
	Wed, 18 Nov 2026 19:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031902;
	bh=FA/EB9punmJjry2eGhPIRkqMynMcmzyV67CQ54EAP6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhstT0r5QFIkvPcRkPo0oshhlcNIv1gTsoGsCCDG0r5Yo+3oT7KeBFYLVLDUbIWpa
	 vToxMogJukSwRP+TPJYYglQ2IoYI0z7t0O68CpN02fp9sIs29MMhv2++UYjGL2VCvf
	 5Q1HlLhQg32KYGhnxYYiTNAbo5JJmKiSag+ljtBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1221/1756] Bluetooth: btmtk: Validate the firmware layout before parsing it
Date: Wed, 18 Nov 2026 15:55:48 +0100
Message-ID: <20261118150058.445307107@linuxfoundation.org>
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

[ Upstream commit 760ac9d02dce001f2e20c17deb18e7bb63d8355e ]

btmtk_setup_firmware_79xx() reads the section count out of the firmware's
global descriptor, then walks a 64-byte section map per section and hands
each section's file-supplied offset and length to the WMT download path.
None of that is checked against fw->size, so a truncated or corrupted
file makes the driver read past the end of request_firmware()'s buffer.
On 32-bit the section count can also wrap the section map size
calculation.

Add btmtk_fw_validate_layout() to check that the header, global
descriptor and section map array all fit, and btmtk_fw_validate_section()
to check one section's offset and length, both written so the size
arithmetic cannot wrap. A section count of zero is rejected as well: it
passes every size check but leaves the download loop with nothing to do,
so the function would report success on hardware it never programmed.
They are helpers rather than open-coded because the MT7928 CBMCU download
path added later needs the same arithmetic.

This is hardening against a corrupted /lib/firmware rather than a bug an
unprivileged user can trigger, hence bluetooth-next and no Fixes: tag.
Well-formed firmware files are unaffected.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 74 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 33e0e3eb65159..b5a03513dea91 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -6,6 +6,7 @@
 #include <linux/firmware.h>
 #include <linux/usb.h>
 #include <linux/iopoll.h>
+#include <linux/overflow.h>
 #include <linux/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -59,6 +60,67 @@ struct btmtk_section_map {
 	};
 } __packed;
 
+/* Reject a firmware image whose header, global descriptor or section map
+ * array does not fit in the file, and hand back the validated section
+ * count, so that the section map walks stay inside the firmware buffer.
+ */
+static int btmtk_fw_validate_layout(struct hci_dev *hdev,
+				    const struct firmware *fw,
+				    u32 *section_num)
+{
+	const struct btmtk_global_desc *globaldesc;
+	size_t need;
+
+	if (fw->size < MTK_FW_ROM_PATCH_HEADER_SIZE + MTK_FW_ROM_PATCH_GD_SIZE) {
+		bt_dev_err(hdev, "Firmware too small: %zu bytes, need at least %u",
+			   fw->size,
+			   MTK_FW_ROM_PATCH_HEADER_SIZE + MTK_FW_ROM_PATCH_GD_SIZE);
+		return -EINVAL;
+	}
+
+	globaldesc = (const struct btmtk_global_desc *)(fw->data +
+			MTK_FW_ROM_PATCH_HEADER_SIZE);
+	*section_num = le32_to_cpu(globaldesc->section_num);
+
+	if (!*section_num) {
+		bt_dev_err(hdev, "Firmware declares no sections");
+		return -EINVAL;
+	}
+
+	if (check_mul_overflow((size_t)MTK_FW_ROM_PATCH_SEC_MAP_SIZE,
+			       (size_t)*section_num, &need) ||
+	    check_add_overflow(need,
+			       (size_t)(MTK_FW_ROM_PATCH_HEADER_SIZE +
+					MTK_FW_ROM_PATCH_GD_SIZE),
+			       &need)) {
+		bt_dev_err(hdev, "Firmware section count too large: %u",
+			   *section_num);
+		return -EINVAL;
+	}
+
+	if (fw->size < need) {
+		bt_dev_err(hdev, "Firmware truncated: %zu bytes, need %zu for %u sections",
+			   fw->size, need, *section_num);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Reject a section whose payload does not lie within the firmware file. */
+static int btmtk_fw_validate_section(struct hci_dev *hdev,
+				     const struct firmware *fw, int index,
+				     u32 offset, u32 size)
+{
+	if (offset > fw->size || size > fw->size - offset) {
+		bt_dev_err(hdev, "Firmware section %d out of bounds: offset=%u, size=%u, fw_size=%zu",
+			   index, offset, size, fw->size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void btmtk_coredump(struct hci_dev *hdev)
 {
 	int err;
@@ -137,7 +199,6 @@ int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 {
 	struct btmtk_hci_wmt_params wmt_params;
 	struct btmtk_patch_header *hdr;
-	struct btmtk_global_desc *globaldesc = NULL;
 	struct btmtk_section_map *sectionmap;
 	const struct firmware *fw;
 	const u8 *fw_ptr;
@@ -153,11 +214,13 @@ int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 		return err;
 	}
 
+	err = btmtk_fw_validate_layout(hdev, fw, &section_num);
+	if (err < 0)
+		goto err_release_fw;
+
 	fw_ptr = fw->data;
 	fw_bin_ptr = fw_ptr;
 	hdr = (struct btmtk_patch_header *)fw_ptr;
-	globaldesc = (struct btmtk_global_desc *)(fw_ptr + MTK_FW_ROM_PATCH_HEADER_SIZE);
-	section_num = le32_to_cpu(globaldesc->section_num);
 
 	bt_dev_info(hdev, "HW/SW Version: 0x%04x%04x, Build Time: %s",
 		    le16_to_cpu(hdr->hwver), le16_to_cpu(hdr->swver), hdr->datetime);
@@ -180,6 +243,11 @@ int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 			continue;
 
 		if (dl_size > 0) {
+			err = btmtk_fw_validate_section(hdev, fw, i,
+							section_offset, dl_size);
+			if (err < 0)
+				goto err_release_fw;
+
 			retry = 20;
 			while (retry > 0) {
 				cmd[0] = 0; /* 0 means legacy dl mode. */
-- 
2.53.0



