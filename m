Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D58E46C4D3;
	Tue, 21 Jul 2026 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649727; cv=none; b=DRJIdElQc86DdVF6QfcgBypZsK6+v38feAGIPwnReQiWj4X05dZS+jsShJKScCYfG5O77ZeE2NGPYiDHkNkTS4FVer82X2Tv+EaZHa4fon+Xzqehx0WF4791dwqvFO3uoyQ5DYrUuuK/ekXwD6jFVhpu90GV/s0sLmbBRUpXFOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649727; c=relaxed/simple;
	bh=yQRilbFcx19jjVBOLrsbv7NE70SUVhZ/g+7lRJMtoZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fof25n+hRAFxE9O+5DL9CvwhUKCwBrSz0LQ7f1oE8QPB1h5lHllK2oV1ehJVJm+DM3MS/Yi4MkKlIs2DUO75XnXR7kBnTtTVEmDtpwM5+tStg2OLLAFbGUmBO5HZoWlOCKPkbgGipkpA34Ezi4NICoU5MIYMdH16+4jRO2i/8GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkRPw1Gt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkRPw1Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB2E1F000E9;
	Tue, 21 Jul 2026 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649726;
	bh=n0F8waLHRm02njMDHfy+7PlW+5kYblVVmLocneDgcFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkRPw1GtTlSuLaKdUBDjgWg7fyHywznsUKhRxAO0Q4MOISNuBlJr/up9wq9b/7ew0
	 uuiFi58USUvhYe/zsQz4VXfaIUyYAnoey4RUlzmqzz6idH97tMi8ZB2wyH+OEATVYf
	 OfD9IDY7gvmB7zbkuBi1WzjDYETMDQuNcmpScZ+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0683/2077] Bluetooth: btintel_pcie: Load IOSF debug regs by controller variant
Date: Tue, 21 Jul 2026 17:05:56 +0200
Message-ID: <20260721152608.905480462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>

[ Upstream commit e43b33bf8d671c50a45fe5f487819927595bbd50 ]

Load the IOSF DBGC base address based on the controller hardware
variant when reading DRAM buffers during a trace dump. Scorpius
Peak family controllers (SCP/SCP2/SCP2F) use a different DBGC base
address (0xf0d5d500) than Blazar family controllers (BZRI/BZRIW,
0xf3800300).

Fixes: 07e6bddb54b4 ("Bluetooth: btintel_pcie: Add support for device coredump")
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.h      |  1 +
 drivers/bluetooth/btintel_pcie.c | 30 ++++++++++++++++++++++++------
 drivers/bluetooth/btintel_pcie.h |  4 ++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index 0e9ca99aaaaea2..035ed1ea6ce965 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -77,6 +77,7 @@ struct intel_tlv {
 #define BTINTEL_HWID_BZRU	0x1d	/* BlazarU - Meteor Lake */
 #define BTINTEL_HWID_SCP	0x1f	/* Scorpius Peak - Panther Lake */
 #define BTINTEL_HWID_SCP2	0x20	/* Scorpius Peak2 - Nova Lake */
+#define BTINTEL_HWID_SCP2F	0x21	/* Scorpius Peak2-F - Nova Lake */
 #define BTINTEL_HWID_BZRIW	0x22	/* BlazarIW - Wildcat Lake */
 
 struct intel_version_tlv {
diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 37e0507636330a..d4426ac767fd8c 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -626,9 +626,10 @@ static void *btintel_pcie_copy_tlv(void *dest, enum btintel_pcie_tlv_type type,
 static int btintel_pcie_read_dram_buffers(struct btintel_pcie_data *data)
 {
 	u32 offset, prev_size, wr_ptr_status, dump_size, data_len;
+	u32 status_reg, wrap_reg;
 	struct btintel_pcie_dbgc *dbgc = &data->dbgc;
 	struct hci_dev *hdev = data->hdev;
-	u8 *pdata, *p, buf_idx;
+	u8 *pdata, *p, buf_idx, hw_variant;
 	struct intel_tlv *tlv;
 	struct timespec64 now;
 	struct tm tm_now;
@@ -641,7 +642,28 @@ static int btintel_pcie_read_dram_buffers(struct btintel_pcie_data *data)
 		return -EOPNOTSUPP;
 
 
-	wr_ptr_status = btintel_pcie_rd_dev_mem(data, BTINTEL_PCIE_DBGC_CUR_DBGBUFF_STATUS);
+	hw_variant = INTEL_HW_VARIANT(data->cnvi);
+	switch (hw_variant) {
+	case BTINTEL_HWID_BZRI:
+	case BTINTEL_HWID_BZRIW:
+		status_reg = BTINTEL_PCIE_DBGC_CUR_DBGBUFF_STATUS;
+		wrap_reg = BTINTEL_PCIE_DBGC_DBGBUFF_WRAP_ARND;
+		break;
+	case BTINTEL_HWID_SCP:
+	case BTINTEL_HWID_SCP2:
+	case BTINTEL_HWID_SCP2F:
+		status_reg = BTINTEL_PCIE_DBGC_CUR_DBGBUFF_STATUS_SCP;
+		wrap_reg = BTINTEL_PCIE_DBGC_DBGBUFF_WRAP_ARND_SCP;
+		break;
+	default:
+		bt_dev_err(hdev, "Unsupported Intel hardware variant (0x%2.2x)",
+			   hw_variant);
+		return -EINVAL;
+	}
+
+	wr_ptr_status = btintel_pcie_rd_dev_mem(data, status_reg);
+	data->dmp_hdr.wrap_ctr = btintel_pcie_rd_dev_mem(data, wrap_reg);
+
 	offset = wr_ptr_status & BTINTEL_PCIE_DBG_OFFSET_BIT_MASK;
 
 	buf_idx = BTINTEL_PCIE_DBGC_DBG_BUF_IDX(wr_ptr_status);
@@ -718,10 +740,6 @@ static int btintel_pcie_read_dram_buffers(struct btintel_pcie_data *data)
 				  sizeof(data->dmp_hdr.write_ptr));
 	p = btintel_pcie_copy_tlv(p, BTINTEL_WRAP_CTR, &data->dmp_hdr.wrap_ctr,
 				  sizeof(data->dmp_hdr.wrap_ctr));
-
-	data->dmp_hdr.wrap_ctr = btintel_pcie_rd_dev_mem(data,
-							 BTINTEL_PCIE_DBGC_DBGBUFF_WRAP_ARND);
-
 	p = btintel_pcie_copy_tlv(p, BTINTEL_TRIGGER_REASON, &data->dmp_hdr.trigger_reason,
 				  sizeof(data->dmp_hdr.trigger_reason));
 	p = btintel_pcie_copy_tlv(p, BTINTEL_FW_SHA, &data->dmp_hdr.fw_git_sha1,
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index 13efef499e4e83..c7db89af49056b 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -68,6 +68,10 @@
 #define BTINTEL_PCIE_DBGC_CUR_DBGBUFF_STATUS		(BTINTEL_PCIE_DBGC_BASE_ADDR + 0x1C)
 #define BTINTEL_PCIE_DBGC_DBGBUFF_WRAP_ARND		(BTINTEL_PCIE_DBGC_BASE_ADDR + 0x2C)
 
+#define BTINTEL_PCIE_DBGC_BASE_ADDR_SCP			(0xf0d5d500)
+#define BTINTEL_PCIE_DBGC_CUR_DBGBUFF_STATUS_SCP	(BTINTEL_PCIE_DBGC_BASE_ADDR_SCP + 0x1C)
+#define BTINTEL_PCIE_DBGC_DBGBUFF_WRAP_ARND_SCP		(BTINTEL_PCIE_DBGC_BASE_ADDR_SCP + 0x2C)
+
 #define BTINTEL_PCIE_DBG_IDX_BIT_MASK		0x0F
 #define BTINTEL_PCIE_DBGC_DBG_BUF_IDX(data)	(((data) >> 24) & BTINTEL_PCIE_DBG_IDX_BIT_MASK)
 #define BTINTEL_PCIE_DBG_OFFSET_BIT_MASK	0xFFFFFF
-- 
2.53.0



