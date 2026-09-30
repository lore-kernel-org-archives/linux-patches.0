Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACDD3C10B9;
	Wed, 30 Sep 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795027; cv=none; b=BJfJotmKrby5E4By8oj6YkyfSlORxZqs6q0YxRcEtGt4fVDq2F+K1ShKfB3I+FeQXYSKe/6oHIg31AXlVLZTd3jXU6wgS8du3+qa+ClqgHQhVeusM+7INUQklx5b3JjeuTSYObuMj9AnAWtobzoKF4zfsOjsUqfJsPTiH0m24og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795027; c=relaxed/simple;
	bh=QQG2PPToouRUOQhbPsk7B9r7z7qCoDT83jR1AHfJig0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThNaE5IxMkXU05SiCZT9eAoqM1MM64XPWBKkQ1XZ6DEfRcysbeeSaWid8jO9X7lYCJieXjS01iIC2nTJu1gm4gF4YKeglPcOiMpZKHrwVGDkJ33gb6KG/CcFtaL78MY1/uHcJG3veCSjVwt8NRO+8AGi9jPu3R5lnINm1Q4//iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfpR0iwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfpR0iwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770AE1F000FF;
	Wed, 30 Sep 2026 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795026;
	bh=2jxCtijuXpUWITjWTxVLUC95aIyg7XrC0lbGTXMgpQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfpR0iwPezhoHjGyCXIEW4elmRuX0SpXL60PRjvGfCIH+tZjwIPnfwEo64XoqXFs5
	 ut9g3YOyok1gD7JfxKFruUKZFp8rk3uBZJiphNwAJlxY2jSaVl1vNxiGeVa9AAD36z
	 G/iMkPlZGh5nnTmhiEoz5bsvJjmmdmQhIUM1HKRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0415/1193] Bluetooth: btintel: Export few static functions
Date: Wed, 30 Sep 2026 17:18:19 +0200
Message-ID: <20260930152443.419547503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 67d4dbac3b8c48ada784ae923f7cd68dfac509ec ]

Some of the functions used in btintel.c is made global so that they can
be reused in other transport drivers apart from USB.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a086c0892969 ("Bluetooth: btintel: validate version TLV value lengths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 26 +++++++++++++---------
 drivers/bluetooth/btintel.h | 43 +++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index bac58babec1e7..24c9d7081bc60 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -235,7 +235,7 @@ static int btintel_set_diag_combined(struct hci_dev *hdev, bool enable)
 	return ret;
 }
 
-static void btintel_hw_error(struct hci_dev *hdev, u8 code)
+void btintel_hw_error(struct hci_dev *hdev, u8 code)
 {
 	struct sk_buff *skb;
 	u8 type = 0x00;
@@ -272,6 +272,7 @@ static void btintel_hw_error(struct hci_dev *hdev, u8 code)
 unlock:
 	hci_req_sync_unlock(hdev);
 }
+EXPORT_SYMBOL_GPL(btintel_hw_error);
 
 int btintel_version_info(struct hci_dev *hdev, struct intel_version *ver)
 {
@@ -450,8 +451,8 @@ int btintel_read_version(struct hci_dev *hdev, struct intel_version *ver)
 }
 EXPORT_SYMBOL_GPL(btintel_read_version);
 
-static int btintel_version_info_tlv(struct hci_dev *hdev,
-				    struct intel_version_tlv *version)
+int btintel_version_info_tlv(struct hci_dev *hdev,
+			     struct intel_version_tlv *version)
 {
 	const char *variant;
 
@@ -535,10 +536,11 @@ static int btintel_version_info_tlv(struct hci_dev *hdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btintel_version_info_tlv);
 
-static int btintel_parse_version_tlv(struct hci_dev *hdev,
-				     struct intel_version_tlv *version,
-				     struct sk_buff *skb)
+int btintel_parse_version_tlv(struct hci_dev *hdev,
+			      struct intel_version_tlv *version,
+			      struct sk_buff *skb)
 {
 	/* Consume Command Complete Status field */
 	skb_pull(skb, 1);
@@ -640,6 +642,7 @@ static int btintel_parse_version_tlv(struct hci_dev *hdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btintel_parse_version_tlv);
 
 static int btintel_read_version_tlv(struct hci_dev *hdev,
 				    struct intel_version_tlv *version)
@@ -2531,8 +2534,8 @@ static void btintel_set_dsm_reset_method(struct hci_dev *hdev,
 	data->acpi_reset_method = btintel_acpi_reset_method;
 }
 
-static int btintel_bootloader_setup_tlv(struct hci_dev *hdev,
-					struct intel_version_tlv *ver)
+int btintel_bootloader_setup_tlv(struct hci_dev *hdev,
+				 struct intel_version_tlv *ver)
 {
 	u32 boot_param;
 	char ddcname[64];
@@ -2599,8 +2602,9 @@ static int btintel_bootloader_setup_tlv(struct hci_dev *hdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btintel_bootloader_setup_tlv);
 
-static void btintel_set_msft_opcode(struct hci_dev *hdev, u8 hw_variant)
+void btintel_set_msft_opcode(struct hci_dev *hdev, u8 hw_variant)
 {
 	switch (hw_variant) {
 	/* Legacy bootloader devices that supports MSFT Extension */
@@ -2623,6 +2627,7 @@ static void btintel_set_msft_opcode(struct hci_dev *hdev, u8 hw_variant)
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(btintel_set_msft_opcode);
 
 static int btintel_setup_combined(struct hci_dev *hdev)
 {
@@ -2873,7 +2878,7 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	return err;
 }
 
-static int btintel_shutdown_combined(struct hci_dev *hdev)
+int btintel_shutdown_combined(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
 	int ret;
@@ -2907,6 +2912,7 @@ static int btintel_shutdown_combined(struct hci_dev *hdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btintel_shutdown_combined);
 
 int btintel_configure_setup(struct hci_dev *hdev, const char *driver_name)
 {
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index d19fcdb9ff0b6..4b0f526be8c43 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -228,6 +228,16 @@ void btintel_bootup(struct hci_dev *hdev, const void *ptr, unsigned int len);
 void btintel_secure_send_result(struct hci_dev *hdev,
 				const void *ptr, unsigned int len);
 int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
+int btintel_version_info_tlv(struct hci_dev *hdev,
+			     struct intel_version_tlv *version);
+int btintel_parse_version_tlv(struct hci_dev *hdev,
+			      struct intel_version_tlv *version,
+			      struct sk_buff *skb);
+void btintel_set_msft_opcode(struct hci_dev *hdev, u8 hw_variant);
+int btintel_bootloader_setup_tlv(struct hci_dev *hdev,
+				 struct intel_version_tlv *ver);
+int btintel_shutdown_combined(struct hci_dev *hdev);
+void btintel_hw_error(struct hci_dev *hdev, u8 code);
 #else
 
 static inline int btintel_check_bdaddr(struct hci_dev *hdev)
@@ -324,4 +334,37 @@ static inline int btintel_set_quality_report(struct hci_dev *hdev, bool enable)
 {
 	return -ENODEV;
 }
+
+static inline int btintel_version_info_tlv(struct hci_dev *hdev,
+					   struct intel_version_tlv *version)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int btintel_parse_version_tlv(struct hci_dev *hdev,
+					    struct intel_version_tlv *version,
+					    struct sk_buff *skb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void btintel_set_msft_opcode(struct hci_dev *hdev, u8 hw_variant)
+
+{
+}
+
+static inline int btintel_bootloader_setup_tlv(struct hci_dev *hdev,
+					       struct intel_version_tlv *ver)
+{
+	return -ENODEV;
+}
+
+static inline int btintel_shutdown_combined(struct hci_dev *hdev)
+{
+	return -ENODEV;
+}
+
+static void btintel_hw_error(struct hci_dev *hdev, u8 code)
+{
+}
 #endif
-- 
2.53.0



