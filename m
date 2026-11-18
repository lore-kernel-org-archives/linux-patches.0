Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026698;
	b=I3+5oMaz2HzoHgPHuYCsTitgvUJA5JLS+84l5OqzWJiYK5SXwKqjl2m1rAscdP+B6JLI
	 Ipeg3eD1Q+ZmQvN/+8fMXRadAJGpUZlApKdXFYiaunL4d3xuc4g0AVOynD+pcbUqZ5mjF
	 3G8Hm4wZUWtiBPikKWHyyBdp95uN3K/wVcojy+C7Y9w0MaQ0SeHtJbE9Z1lqciK970g2I
	 EQXNKizPhKpL19JOoSAJfjcq9LrsmWURX6xe65o5hILo+pApnhgHIADX0CtizeqHYiWMG
	 L8rkOB3pnPN/HjlHIylpg0EhtQeYJXDqU3lqtlcarn5FIrLqiTiA27DmfE0OwkXlJhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=drsA510EuJfo18VhIrKDsgnZ+0NsYalHzTJ/BDSL+nA=;
	b=hie9faJwXFv+0qAXUpmDg3FhEDBYuf23RgD+tFJKWmkx0VSaaJs21Hytnq5zJUKH3Xiz
	 mthLLpEmho6iI4EECVY1WFQeH5CdifpShdEa59Jg+Tc6DxE3aom0XZNcZzoSZwPearjw9
	 ZFGDQeSDhvYskfD8BGWXBfDiSYfggFfzk4R+YuiHcASqdjg2o8MkwkhbpASc+OyOR49MK
	 KJ6Qugq7DxNgLk2YpgZLMjcDkXBh1lpZF/CgPhOnO30VnwGpL7aLzTl7ytXAbLuWnLDKH
	 JgHpu4s0Up4UE4KbFh463n3SGSn7wZQR+4XrwCLH/IcKnCcrENesmIW8GnB5HBdnIxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxTXdM4b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BC606A31C;
	Wed, 18 Nov 2026 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxTXdM4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208721F000C4;
	Wed, 18 Nov 2026 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026697;
	bh=drsA510EuJfo18VhIrKDsgnZ+0NsYalHzTJ/BDSL+nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxTXdM4bOtd24u024Ba5KdOjZUo7njcbtp8V6mGyblpd4p3yLC7NhMxHQEzm3a2wd
	 TE9y9LqowZuWm3N4P34HyhaZeC1QBaJEo+RS2MEgbghLCf7g2gPMZC6EX6Zzwp475U
	 KEJlN/sgHH1pLl7Ew0GzQwoII1ujUlUK853FunJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1528/2151] Bluetooth: btmtk: Validate the firmware layout before parsing it
Date: Wed, 18 Nov 2026 15:54:23 +0100
Message-ID: <20261118150217.488844733@linuxfoundation.org>
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
index c525e2685a861..528dcd000d303 100644
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



