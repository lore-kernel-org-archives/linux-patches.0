Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216343;
	b=zk7XUHA4DDNpqr54ePeGs3c/VMqkYQ2DqhLu+NZHKahLtNlwVj2Xpxt5fx70atc9hKRI
	 3E97AtMJ3jjAxwXuq5+HRdKoAGHQD7Zj8XV1cF8mDhTY/WRr5GJygVqox1WjDiAQBjne/
	 9R65MExUWWkG15lS9KiaWHHXg1SYE3cHi4Ih5xz9Pijd/SgwIqMPVP1gZz2ILK3snMKcQ
	 Zjt2D+nOUIdgUv0HIsLYjdzP+Kp/C5awxGYXnkGJb+Kv3P4KnDv69mM9rMuGEq6UaK4Ue
	 6miOMzDVjOUrSLZyrBMnyu7hIJjzZs8xgeJXL95H+YWYOi9Ei+SdnKsc04coxw557Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Gm7A88u3S66uF12yJZn0Q7Ujw5sb/AQHHmRtpqXU20=;
	b=0Hedv5HIPYu5duD3SZnPQ0kTj1h6Mx60xFvmwAGm5DsbF3+Lw0ZqanstXHcgUGM4EXDl
	 si9Yg6YNPaAlS2Iq8eb8i3/7DD8ObE4qPgkts8iAvi0stkvQZEnjolO7ZnpevTpw1daot
	 ceQtEBRNkzvu+9AwVwq5awRvpQ2Q5vWuxgZSnKE/DkjaxdlABrNCWCYrNVI7kBU/7PpXm
	 NHc0MnPMhEQxg3h4HOA3fuc5Brgat9mZXR3FHnbsDXYrHmXtDBUzhbgSGhXhbiqJ+tcBm
	 9QtbkLmR2T8kl2emG9AoFbVQOIntOiv9pcL5UMsH//ajzCow0oIKjOjvdRBNtr/zMzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYmSDQ7z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E334606A31C;
	Wed, 28 Oct 2026 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYmSDQ7z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5261F01825;
	Wed, 28 Oct 2026 19:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216342;
	bh=2Gm7A88u3S66uF12yJZn0Q7Ujw5sb/AQHHmRtpqXU20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYmSDQ7zZzAfWKzwavWwMb6WmqRxwP1xVD8e1mi0uF//Is+R+RFqttbVWPy6yNLh3
	 i673VuqANEwfi9z8yk5ZQ2GqwOKBRR7LJotmtYJCXiNmY11XTwOTO+68m25O/Obatd
	 woy8PTIJZxCKOXiSVS5UYngQt0MQ3ra6bnVBRHg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1525/1887] net: qlcnic: validate unified ROM sections before loading
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028170534.166452356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5e8076e4e4124dae75a3e080ddc20404700d7585 ]

The unified ROM parser reads directory, product, and data-descriptor fields
from the firmware file.  Existing validation forms table and data ends with
unchecked additions and multiplications.  Malformed values can wrap before
they are compared with the firmware size.  The parser also dereferences
typed pointers at firmware-controlled offsets.

Valid descriptor extents alone are insufficient for the consumers.  The
loader reads a fixed-size bootloader regardless of its declared size, the
version parser assumes a 17-byte tail, and a partial final firmware word is
read as a full u64.  A truncated image can therefore make the driver read
beyond the firmware allocation during validation or loading.

Replace the pointer-returning parser with bounded range helpers.  Validate
table entry sizes, descriptor indices, section ranges, the fixed
bootloader load length, and the version tail before exposing any section.
Read all file fields with unaligned little-endian accessors and assemble a
partial final word from only the bytes that remain.  Apply the same range
checks to the legacy image before reading its fixed fields.

Fixes: af19b49152bd ("qlcnic: Qlogic ethernet driver for CNA devices")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260816052109.4607-1-pengpeng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/qlogic/qlcnic/qlcnic_init.c  | 445 ++++++++++--------
 1 file changed, 248 insertions(+), 197 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
index 09f20c7947545..d6cc6288436dc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
@@ -6,6 +6,7 @@
 
 #include "qlcnic.h"
 #include "qlcnic_hw.h"
+#include <asm/unaligned.h>
 
 struct crb_addr_pair {
 	u32 addr;
@@ -740,159 +741,212 @@ qlcnic_has_mn(struct qlcnic_adapter *adapter)
 	return 0;
 }
 
-static
-struct uni_table_desc *qlcnic_get_table_desc(const u8 *unirom, int section)
-{
-	u32 i, entries;
-	struct uni_table_desc *directory = (struct uni_table_desc *) &unirom[0];
-	entries = le32_to_cpu(directory->num_entries);
-
-	for (i = 0; i < entries; i++) {
+#define FILEHEADER_SIZE (14 * 4)
+#define QLCNIC_UNI_DIR_TYPE_OFF		(8 * sizeof(__le32))
+#define QLCNIC_UNI_DIR_ENTRY_MIN_SIZE	(9 * sizeof(__le32))
+#define QLCNIC_UNI_PRODUCT_ENTRY_MIN_SIZE \
+	((QLCNIC_UNI_FIRMWARE_IDX_OFF + 1) * sizeof(__le32))
+#define QLCNIC_UNI_VERSION_TAIL_SIZE	17
+#define QLCNIC_UNI_BOOTLD_SIZE \
+	(QLCNIC_IMAGE_START - QLCNIC_BOOTLD_START)
+
+struct qlcnic_uni_data {
+	u32 offset;
+	u32 size;
+};
 
-		u32 offs = le32_to_cpu(directory->findex) +
-			   i * le32_to_cpu(directory->entry_size);
-		u32 tab_type = le32_to_cpu(*((__le32 *)&unirom[offs] + 8));
+static bool qlcnic_rom_range_valid(size_t size, size_t offset, size_t len)
+{
+	return offset <= size && len <= size - offset;
+}
 
-		if (tab_type == section)
-			return (struct uni_table_desc *) &unirom[offs];
-	}
+static bool qlcnic_rom_table_valid(size_t size, u32 offset, u32 entries,
+				   u32 entry_size, u32 min_entry_size)
+{
+	if (entry_size < min_entry_size || offset > size)
+		return false;
 
-	return NULL;
+	return entries <= (size - offset) / entry_size;
 }
 
-#define FILEHEADER_SIZE (14 * 4)
-
-static int
-qlcnic_validate_header(struct qlcnic_adapter *adapter)
+static int qlcnic_get_directory(struct qlcnic_adapter *adapter,
+				size_t *offset, u32 *entries, u32 *entry_size)
 {
-	const u8 *unirom = adapter->fw->data;
-	struct uni_table_desc *directory = (struct uni_table_desc *) &unirom[0];
-	u32 entries, entry_size, tab_size, fw_file_size;
-
-	fw_file_size = adapter->fw->size;
+	const struct firmware *fw = adapter->fw;
+	const u8 *directory = fw->data;
 
-	if (fw_file_size < FILEHEADER_SIZE)
+	if (fw->size < FILEHEADER_SIZE)
 		return -EINVAL;
 
-	entries = le32_to_cpu(directory->num_entries);
-	entry_size = le32_to_cpu(directory->entry_size);
-	tab_size = le32_to_cpu(directory->findex) + (entries * entry_size);
+	*offset = get_unaligned_le32(directory +
+				     offsetof(struct uni_table_desc, findex));
+	*entries = get_unaligned_le32(directory +
+				      offsetof(struct uni_table_desc, num_entries));
+	*entry_size = get_unaligned_le32(directory +
+					 offsetof(struct uni_table_desc, entry_size));
 
-	if (fw_file_size < tab_size)
+	if (!qlcnic_rom_table_valid(fw->size, *offset, *entries, *entry_size,
+				    QLCNIC_UNI_DIR_ENTRY_MIN_SIZE))
 		return -EINVAL;
 
 	return 0;
 }
 
-static int
-qlcnic_validate_bootld(struct qlcnic_adapter *adapter)
+static int qlcnic_get_table_desc(struct qlcnic_adapter *adapter, int section,
+				 size_t *desc_offset)
 {
-	struct uni_table_desc *tab_desc;
-	struct uni_data_desc *descr;
-	u32 offs, tab_size, data_size, idx;
 	const u8 *unirom = adapter->fw->data;
-	__le32 temp;
-
-	temp = *((__le32 *)&unirom[adapter->file_prd_off] +
-		 QLCNIC_UNI_BOOTLD_IDX_OFF);
-	idx = le32_to_cpu(temp);
-	tab_desc = qlcnic_get_table_desc(unirom, QLCNIC_UNI_DIR_SECT_BOOTLD);
-
-	if (!tab_desc)
-		return -EINVAL;
-
-	tab_size = le32_to_cpu(tab_desc->findex) +
-		   le32_to_cpu(tab_desc->entry_size) * (idx + 1);
-
-	if (adapter->fw->size < tab_size)
-		return -EINVAL;
+	size_t directory_offset;
+	u32 entries, entry_size;
+	size_t i;
+	int ret;
 
-	offs = le32_to_cpu(tab_desc->findex) +
-	       le32_to_cpu(tab_desc->entry_size) * idx;
-	descr = (struct uni_data_desc *)&unirom[offs];
+	ret = qlcnic_get_directory(adapter, &directory_offset, &entries,
+				   &entry_size);
+	if (ret)
+		return ret;
 
-	data_size = le32_to_cpu(descr->findex) + le32_to_cpu(descr->size);
+	for (i = 0; i < entries; i++) {
+		size_t offset = directory_offset + i * entry_size;
+		u32 table_type;
 
-	if (adapter->fw->size < data_size)
-		return -EINVAL;
+		table_type = get_unaligned_le32(unirom + offset +
+						QLCNIC_UNI_DIR_TYPE_OFF);
+		if (table_type == section) {
+			*desc_offset = offset;
+			return 0;
+		}
+	}
 
-	return 0;
+	return -ENOENT;
 }
 
 static int
-qlcnic_validate_fw(struct qlcnic_adapter *adapter)
+qlcnic_validate_header(struct qlcnic_adapter *adapter)
 {
-	struct uni_table_desc *tab_desc;
-	struct uni_data_desc *descr;
-	const u8 *unirom = adapter->fw->data;
-	u32 offs, tab_size, data_size, idx;
-	__le32 temp;
+	u32 entries, entry_size;
+	size_t offset;
+
+	return qlcnic_get_directory(adapter, &offset, &entries, &entry_size);
+}
 
-	temp = *((__le32 *)&unirom[adapter->file_prd_off] +
-		 QLCNIC_UNI_FIRMWARE_IDX_OFF);
-	idx = le32_to_cpu(temp);
-	tab_desc = qlcnic_get_table_desc(unirom, QLCNIC_UNI_DIR_SECT_FW);
+static int qlcnic_get_data_desc(struct qlcnic_adapter *adapter, u32 section,
+				u32 index_offset, struct qlcnic_uni_data *data)
+{
+	size_t table_desc_offset, table_offset, desc_offset;
+	const struct firmware *fw = adapter->fw;
+	const u8 *unirom = fw->data;
+	size_t product_index_offset;
+	u32 entries, entry_size, idx;
+	int ret;
 
-	if (!tab_desc)
+	product_index_offset = adapter->file_prd_off +
+				 (size_t)index_offset * sizeof(__le32);
+	if (!qlcnic_rom_range_valid(fw->size, product_index_offset,
+				    sizeof(__le32)))
 		return -EINVAL;
 
-	tab_size = le32_to_cpu(tab_desc->findex) +
-		   le32_to_cpu(tab_desc->entry_size) * (idx + 1);
+	idx = get_unaligned_le32(unirom + product_index_offset);
+	ret = qlcnic_get_table_desc(adapter, section, &table_desc_offset);
+	if (ret)
+		return ret;
 
-	if (adapter->fw->size < tab_size)
+	table_offset = get_unaligned_le32(unirom + table_desc_offset +
+					  offsetof(struct uni_table_desc, findex));
+	entries = get_unaligned_le32(unirom + table_desc_offset +
+				     offsetof(struct uni_table_desc, num_entries));
+	entry_size = get_unaligned_le32(unirom + table_desc_offset +
+					offsetof(struct uni_table_desc, entry_size));
+	if (!qlcnic_rom_table_valid(fw->size, table_offset, entries,
+				    entry_size, sizeof(struct uni_data_desc)) ||
+	    idx >= entries)
 		return -EINVAL;
 
-	offs = le32_to_cpu(tab_desc->findex) +
-	       le32_to_cpu(tab_desc->entry_size) * idx;
-	descr = (struct uni_data_desc *)&unirom[offs];
-	data_size = le32_to_cpu(descr->findex) + le32_to_cpu(descr->size);
+	desc_offset = table_offset + (size_t)idx * entry_size;
+	data->offset = get_unaligned_le32(unirom + desc_offset +
+					  offsetof(struct uni_data_desc, findex));
+	data->size = get_unaligned_le32(unirom + desc_offset +
+					offsetof(struct uni_data_desc, size));
 
-	if (adapter->fw->size < data_size)
+	if (!qlcnic_rom_range_valid(fw->size, data->offset, data->size))
 		return -EINVAL;
 
 	return 0;
 }
 
+static int qlcnic_validate_bootld(struct qlcnic_adapter *adapter)
+{
+	struct qlcnic_uni_data data;
+	int ret;
+
+	ret = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_BOOTLD,
+				   QLCNIC_UNI_BOOTLD_IDX_OFF, &data);
+	if (ret)
+		return ret;
+
+	return data.size < QLCNIC_UNI_BOOTLD_SIZE ? -EINVAL : 0;
+}
+
+static int qlcnic_validate_fw(struct qlcnic_adapter *adapter)
+{
+	struct qlcnic_uni_data data;
+	int ret;
+
+	ret = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_FW,
+				   QLCNIC_UNI_FIRMWARE_IDX_OFF, &data);
+	if (ret)
+		return ret;
+
+	return data.size < QLCNIC_UNI_VERSION_TAIL_SIZE ? -EINVAL : 0;
+}
+
 static int
 qlcnic_validate_product_offs(struct qlcnic_adapter *adapter)
 {
-	struct uni_table_desc *ptab_descr;
+	size_t table_desc_offset, table_offset;
 	const u8 *unirom = adapter->fw->data;
 	int mn_present = qlcnic_has_mn(adapter);
-	u32 entries, entry_size, tab_size, i;
-	__le32 temp;
-
-	ptab_descr = qlcnic_get_table_desc(unirom,
-				QLCNIC_UNI_DIR_SECT_PRODUCT_TBL);
-	if (!ptab_descr)
-		return -EINVAL;
+	u32 entries, entry_size;
+	size_t i;
+	int ret;
 
-	entries = le32_to_cpu(ptab_descr->num_entries);
-	entry_size = le32_to_cpu(ptab_descr->entry_size);
-	tab_size = le32_to_cpu(ptab_descr->findex) + (entries * entry_size);
+	ret = qlcnic_get_table_desc(adapter, QLCNIC_UNI_DIR_SECT_PRODUCT_TBL,
+				    &table_desc_offset);
+	if (ret)
+		return ret;
 
-	if (adapter->fw->size < tab_size)
+	table_offset = get_unaligned_le32(unirom + table_desc_offset +
+					  offsetof(struct uni_table_desc, findex));
+	entries = get_unaligned_le32(unirom + table_desc_offset +
+				     offsetof(struct uni_table_desc, num_entries));
+	entry_size = get_unaligned_le32(unirom + table_desc_offset +
+					offsetof(struct uni_table_desc, entry_size));
+	if (!qlcnic_rom_table_valid(adapter->fw->size, table_offset, entries,
+				    entry_size,
+				    QLCNIC_UNI_PRODUCT_ENTRY_MIN_SIZE))
 		return -EINVAL;
 
 nomn:
 	for (i = 0; i < entries; i++) {
-
-		u32 flags, file_chiprev, offs;
+		size_t offset = table_offset + i * entry_size;
 		u8 chiprev = adapter->ahw->revision_id;
+		u32 flags, file_chiprev;
 		u32 flagbit;
 
-		offs = le32_to_cpu(ptab_descr->findex) +
-		       i * le32_to_cpu(ptab_descr->entry_size);
-		temp = *((__le32 *)&unirom[offs] + QLCNIC_UNI_FLAGS_OFF);
-		flags = le32_to_cpu(temp);
-		temp = *((__le32 *)&unirom[offs] + QLCNIC_UNI_CHIP_REV_OFF);
-		file_chiprev = le32_to_cpu(temp);
+		flags = get_unaligned_le32(unirom + offset +
+					   QLCNIC_UNI_FLAGS_OFF * sizeof(__le32));
+		file_chiprev = get_unaligned_le32(unirom + offset +
+						  QLCNIC_UNI_CHIP_REV_OFF *
+						  sizeof(__le32));
 
 		flagbit = mn_present ? 1 : 2;
 
 		if ((chiprev == file_chiprev) &&
 					((1ULL << flagbit) & flags)) {
-			adapter->file_prd_off = offs;
+			if (offset > U32_MAX)
+				return -EINVAL;
+
+			adapter->file_prd_off = offset;
 			return 0;
 		}
 	}
@@ -933,93 +987,81 @@ qlcnic_validate_unified_romimage(struct qlcnic_adapter *adapter)
 	return 0;
 }
 
-static
-struct uni_data_desc *qlcnic_get_data_desc(struct qlcnic_adapter *adapter,
-			u32 section, u32 idx_offset)
-{
-	const u8 *unirom = adapter->fw->data;
-	struct uni_table_desc *tab_desc;
-	u32 offs, idx;
-	__le32 temp;
-
-	temp = *((__le32 *)&unirom[adapter->file_prd_off] + idx_offset);
-	idx = le32_to_cpu(temp);
-
-	tab_desc = qlcnic_get_table_desc(unirom, section);
-
-	if (tab_desc == NULL)
-		return NULL;
-
-	offs = le32_to_cpu(tab_desc->findex) +
-	       le32_to_cpu(tab_desc->entry_size) * idx;
-
-	return (struct uni_data_desc *)&unirom[offs];
-}
-
-static u8 *
-qlcnic_get_bootld_offs(struct qlcnic_adapter *adapter)
+static int qlcnic_get_bootld_data(struct qlcnic_adapter *adapter,
+				  const u8 **bootld)
 {
 	u32 offs = QLCNIC_BOOTLD_START;
-	struct uni_data_desc *data_desc;
-
-	data_desc = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_BOOTLD,
-					 QLCNIC_UNI_BOOTLD_IDX_OFF);
+	struct qlcnic_uni_data data;
+	int ret;
 
-	if (adapter->ahw->fw_type == QLCNIC_UNIFIED_ROMIMAGE)
-		offs = le32_to_cpu(data_desc->findex);
+	if (adapter->ahw->fw_type == QLCNIC_UNIFIED_ROMIMAGE) {
+		ret = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_BOOTLD,
+					   QLCNIC_UNI_BOOTLD_IDX_OFF, &data);
+		if (ret || data.size < QLCNIC_UNI_BOOTLD_SIZE)
+			return -EINVAL;
+		offs = data.offset;
+	} else if (!qlcnic_rom_range_valid(adapter->fw->size, offs,
+					   QLCNIC_UNI_BOOTLD_SIZE)) {
+		return -EINVAL;
+	}
 
-	return (u8 *)&adapter->fw->data[offs];
+	*bootld = adapter->fw->data + offs;
+	return 0;
 }
 
-static u8 *
-qlcnic_get_fw_offs(struct qlcnic_adapter *adapter)
+static int qlcnic_get_fw_data(struct qlcnic_adapter *adapter,
+			      const u8 **image, u32 *image_size)
 {
 	u32 offs = QLCNIC_IMAGE_START;
-	struct uni_data_desc *data_desc;
-
-	data_desc = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_FW,
-					 QLCNIC_UNI_FIRMWARE_IDX_OFF);
-	if (adapter->ahw->fw_type == QLCNIC_UNIFIED_ROMIMAGE)
-		offs = le32_to_cpu(data_desc->findex);
-
-	return (u8 *)&adapter->fw->data[offs];
-}
+	struct qlcnic_uni_data data;
+	int ret;
 
-static u32 qlcnic_get_fw_size(struct qlcnic_adapter *adapter)
-{
-	struct uni_data_desc *data_desc;
-	const u8 *unirom = adapter->fw->data;
+	if (adapter->ahw->fw_type == QLCNIC_UNIFIED_ROMIMAGE) {
+		ret = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_FW,
+					   QLCNIC_UNI_FIRMWARE_IDX_OFF, &data);
+		if (ret)
+			return ret;
+		offs = data.offset;
+		*image_size = data.size;
+	} else {
+		if (!qlcnic_rom_range_valid(adapter->fw->size,
+					    QLCNIC_FW_SIZE_OFFSET,
+					    sizeof(__le32)))
+			return -EINVAL;
+		*image_size = get_unaligned_le32(adapter->fw->data +
+						 QLCNIC_FW_SIZE_OFFSET);
+	}
 
-	data_desc = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_FW,
-					 QLCNIC_UNI_FIRMWARE_IDX_OFF);
+	if (!qlcnic_rom_range_valid(adapter->fw->size, offs, *image_size))
+		return -EINVAL;
 
-	if (adapter->ahw->fw_type == QLCNIC_UNIFIED_ROMIMAGE)
-		return le32_to_cpu(data_desc->size);
-	else
-		return le32_to_cpu(*(__le32 *)&unirom[QLCNIC_FW_SIZE_OFFSET]);
+	*image = adapter->fw->data + offs;
+	return 0;
 }
 
 static u32 qlcnic_get_fw_version(struct qlcnic_adapter *adapter)
 {
-	struct uni_data_desc *fw_data_desc;
+	char ver_str[QLCNIC_UNI_VERSION_TAIL_SIZE + 1];
 	const struct firmware *fw = adapter->fw;
+	struct qlcnic_uni_data data;
 	u32 major, minor, sub;
-	__le32 version_offset;
-	const u8 *ver_str;
 	int i, ret;
 
-	if (adapter->ahw->fw_type != QLCNIC_UNIFIED_ROMIMAGE) {
-		version_offset = *(__le32 *)&fw->data[QLCNIC_FW_VERSION_OFFSET];
-		return le32_to_cpu(version_offset);
-	}
+	if (adapter->ahw->fw_type != QLCNIC_UNIFIED_ROMIMAGE)
+		return get_unaligned_le32(fw->data + QLCNIC_FW_VERSION_OFFSET);
+
+	ret = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_FW,
+				   QLCNIC_UNI_FIRMWARE_IDX_OFF, &data);
+	if (ret || data.size < QLCNIC_UNI_VERSION_TAIL_SIZE)
+		return 0;
 
-	fw_data_desc = qlcnic_get_data_desc(adapter, QLCNIC_UNI_DIR_SECT_FW,
-			QLCNIC_UNI_FIRMWARE_IDX_OFF);
-	ver_str = fw->data + le32_to_cpu(fw_data_desc->findex) +
-		  le32_to_cpu(fw_data_desc->size) - 17;
+	memcpy(ver_str, fw->data + data.offset + data.size -
+			QLCNIC_UNI_VERSION_TAIL_SIZE,
+	       QLCNIC_UNI_VERSION_TAIL_SIZE);
+	ver_str[QLCNIC_UNI_VERSION_TAIL_SIZE] = '\0';
 
 	for (i = 0; i < 12; i++) {
-		if (!strncmp(&ver_str[i], "REV=", 4)) {
+		if (!strncmp(ver_str + i, "REV=", 4)) {
 			ret = sscanf(&ver_str[i+4], "%u.%u.%u ",
 					&major, &minor, &sub);
 			if (ret != 3)
@@ -1034,18 +1076,15 @@ static u32 qlcnic_get_fw_version(struct qlcnic_adapter *adapter)
 
 static u32 qlcnic_get_bios_version(struct qlcnic_adapter *adapter)
 {
-	const struct firmware *fw = adapter->fw;
 	u32 bios_ver, prd_off = adapter->file_prd_off;
-	u8 *version_offset;
-	__le32 temp;
+	const struct firmware *fw = adapter->fw;
 
-	if (adapter->ahw->fw_type != QLCNIC_UNIFIED_ROMIMAGE) {
-		version_offset = (u8 *)&fw->data[QLCNIC_BIOS_VERSION_OFFSET];
-		return le32_to_cpu(*(__le32 *)version_offset);
-	}
+	if (adapter->ahw->fw_type != QLCNIC_UNIFIED_ROMIMAGE)
+		return get_unaligned_le32(fw->data + QLCNIC_BIOS_VERSION_OFFSET);
 
-	temp = *((__le32 *)(&fw->data[prd_off]) + QLCNIC_UNI_BIOS_VERSION_OFF);
-	bios_ver = le32_to_cpu(temp);
+	bios_ver = get_unaligned_le32(fw->data + prd_off +
+				      QLCNIC_UNI_BIOS_VERSION_OFF *
+				      sizeof(__le32));
 
 	return (bios_ver << 16) + ((bios_ver >> 8) & 0xff00) + (bios_ver >> 24);
 }
@@ -1106,24 +1145,26 @@ static const char *fw_name[] = {
 int
 qlcnic_load_firmware(struct qlcnic_adapter *adapter)
 {
-	__le64 *ptr64;
-	u32 i, flashaddr, size;
 	const struct firmware *fw = adapter->fw;
 	struct pci_dev *pdev = adapter->pdev;
+	const u8 *bootld, *image;
+	u32 i, flashaddr, image_size;
+	int ret;
 
 	dev_info(&pdev->dev, "loading firmware from %s\n",
 		 fw_name[adapter->ahw->fw_type]);
 
 	if (fw) {
+		u32 words, remainder;
 		u64 data;
 
-		size = (QLCNIC_IMAGE_START - QLCNIC_BOOTLD_START) / 8;
-
-		ptr64 = (__le64 *)qlcnic_get_bootld_offs(adapter);
+		ret = qlcnic_get_bootld_data(adapter, &bootld);
+		if (ret)
+			return ret;
 		flashaddr = QLCNIC_BOOTLD_START;
 
-		for (i = 0; i < size; i++) {
-			data = le64_to_cpu(ptr64[i]);
+		for (i = 0; i < QLCNIC_UNI_BOOTLD_SIZE / sizeof(u64); i++) {
+			data = get_unaligned_le64(bootld + i * sizeof(u64));
 
 			if (qlcnic_pci_mem_write_2M(adapter, flashaddr, data))
 				return -EIO;
@@ -1131,13 +1172,15 @@ qlcnic_load_firmware(struct qlcnic_adapter *adapter)
 			flashaddr += 8;
 		}
 
-		size = qlcnic_get_fw_size(adapter) / 8;
-
-		ptr64 = (__le64 *)qlcnic_get_fw_offs(adapter);
+		ret = qlcnic_get_fw_data(adapter, &image, &image_size);
+		if (ret)
+			return ret;
+		words = image_size / sizeof(u64);
+		remainder = image_size % sizeof(u64);
 		flashaddr = QLCNIC_IMAGE_START;
 
-		for (i = 0; i < size; i++) {
-			data = le64_to_cpu(ptr64[i]);
+		for (i = 0; i < words; i++) {
+			data = get_unaligned_le64(image + i * sizeof(u64));
 
 			if (qlcnic_pci_mem_write_2M(adapter,
 						flashaddr, data))
@@ -1146,9 +1189,11 @@ qlcnic_load_firmware(struct qlcnic_adapter *adapter)
 			flashaddr += 8;
 		}
 
-		size = qlcnic_get_fw_size(adapter) % 8;
-		if (size) {
-			data = le64_to_cpu(ptr64[i]);
+		if (remainder) {
+			__le64 tail = 0;
+
+			memcpy(&tail, image + words * sizeof(u64), remainder);
+			data = le64_to_cpu(tail);
 
 			if (qlcnic_pci_mem_write_2M(adapter,
 						flashaddr, data))
@@ -1156,10 +1201,9 @@ qlcnic_load_firmware(struct qlcnic_adapter *adapter)
 		}
 
 	} else {
-		u64 data;
-		u32 hi, lo;
-		int ret;
 		struct qlcnic_flt_entry bootld_entry;
+		u32 hi, lo, size;
+		u64 data;
 
 		ret = qlcnic_get_flt_entry(adapter, QLCNIC_BOOTLD_REGION,
 					&bootld_entry);
@@ -1200,26 +1244,33 @@ qlcnic_load_firmware(struct qlcnic_adapter *adapter)
 static int
 qlcnic_validate_firmware(struct qlcnic_adapter *adapter)
 {
-	u32 val;
-	u32 ver, bios, min_size;
-	struct pci_dev *pdev = adapter->pdev;
 	const struct firmware *fw = adapter->fw;
+	struct pci_dev *pdev = adapter->pdev;
 	u8 fw_type = adapter->ahw->fw_type;
+	u32 ver, bios, min_size;
+	const u8 *data;
+	u32 data_size;
+	u32 val;
+
+	if (fw_type == QLCNIC_UNIFIED_ROMIMAGE)
+		min_size = QLCNIC_UNI_FW_MIN_SIZE;
+	else
+		min_size = QLCNIC_FW_MIN_SIZE;
+
+	if (fw->size < min_size)
+		return -EINVAL;
 
 	if (fw_type == QLCNIC_UNIFIED_ROMIMAGE) {
 		if (qlcnic_validate_unified_romimage(adapter))
 			return -EINVAL;
-
-		min_size = QLCNIC_UNI_FW_MIN_SIZE;
 	} else {
-		val = le32_to_cpu(*(__le32 *)&fw->data[QLCNIC_FW_MAGIC_OFFSET]);
+		val = get_unaligned_le32(fw->data + QLCNIC_FW_MAGIC_OFFSET);
 		if (val != QLCNIC_BDINFO_MAGIC)
 			return -EINVAL;
-
-		min_size = QLCNIC_FW_MIN_SIZE;
 	}
 
-	if (fw->size < min_size)
+	if (qlcnic_get_bootld_data(adapter, &data) ||
+	    qlcnic_get_fw_data(adapter, &data, &data_size))
 		return -EINVAL;
 
 	val = qlcnic_get_fw_version(adapter);
-- 
2.53.0



