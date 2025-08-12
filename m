Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B386BB5B;
	Tue, 12 Aug 2025 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024050; cv=none; b=dkUuB+GufwKqbT+92Eg7j3OcryonMdfQlFAR05tCahABjUJIS7QW/wPI56q3iAGBgvQsPKvX9Kz7vi6oD7bc8t33q/uqwa8bqqHh4c4YlaghTruTjmAfFBAi1Xq2vT8mDsdQ8fKokWvL8u4821v2pq8vV9TjzZ5ER2x7qFdy+fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024050; c=relaxed/simple;
	bh=6YVjzW/+tayNmLpugoOSwJ/+h9ZvHCPdW0udQMyxlzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4xvJwakG3zyntaX9TucQWJjjZ9HZmCIs3qoD9fk9FH11yEHp4qMLEaL3qDTKT72XAmxh1vBUw0cLX6L7zS2CUvDA+mgQRguKPxK85yYZ7tYxzl3L4AP25uTkXBeDlVXyvGjcBWO2pKcYIk1mVO7dh/8aly42uq65MF8IsCTaJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szKXuEh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szKXuEh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C8EC4CEF0;
	Tue, 12 Aug 2025 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024050;
	bh=6YVjzW/+tayNmLpugoOSwJ/+h9ZvHCPdW0udQMyxlzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szKXuEh2d8x/XfWMt25WPiCJGaVytKOB9fZagCySOxkg24X0qNmpldBUWWCPDUYWg
	 lmTlF2B9NmeVtaHmM8mXOgC8uu+IfVHmMNI7JHvjFCm6feffsRK02JLky25DJpSvKX
	 wq6kOflWgfs8aZSITXr4CwMrDiD/snj8czXJUKOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 258/627] Bluetooth: btintel: Define a macro for Intel Reset vendor command
Date: Tue, 12 Aug 2025 19:29:13 +0200
Message-ID: <20250812173429.130826524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 15843c7fdba65568704245fd3ea2aa3aa2d50825 ]

Use macro for Intel Reset command (0xfc01) instead of hard coded value.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 69b3d3acf3db ("Bluetooth: btintel_pcie: Make driver wait for alive interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c      |  4 ++--
 drivers/bluetooth/btintel.h      |  2 ++
 drivers/bluetooth/btintel_pcie.c | 12 ++++++------
 drivers/bluetooth/btusb.c        |  8 ++++----
 drivers/bluetooth/hci_intel.c    | 10 +++++-----
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 06016ac3965c..6aceecf5a13d 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -889,7 +889,7 @@ int btintel_send_intel_reset(struct hci_dev *hdev, u32 boot_param)
 
 	params.boot_param = cpu_to_le32(boot_param);
 
-	skb = __hci_cmd_sync(hdev, 0xfc01, sizeof(params), &params,
+	skb = __hci_cmd_sync(hdev, BTINTEL_HCI_OP_RESET, sizeof(params), &params,
 			     HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to send Intel Reset command");
@@ -1287,7 +1287,7 @@ static void btintel_reset_to_bootloader(struct hci_dev *hdev)
 	params.boot_option = 0x00;
 	params.boot_param = cpu_to_le32(0x00000000);
 
-	skb = __hci_cmd_sync(hdev, 0xfc01, sizeof(params),
+	skb = __hci_cmd_sync(hdev, BTINTEL_HCI_OP_RESET, sizeof(params),
 			     &params, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "FW download error recovery failed (%ld)",
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index 1d12c4113c66..431998049e68 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -52,6 +52,8 @@ struct intel_tlv {
 	u8 val[];
 } __packed;
 
+#define BTINTEL_HCI_OP_RESET	0xfc01
+
 #define BTINTEL_CNVI_BLAZARI		0x900
 #define BTINTEL_CNVI_BLAZARIW		0x901
 #define BTINTEL_CNVI_GAP		0x910
diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index f4e3fb54fe76..1638be0921a3 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1955,12 +1955,12 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 			struct hci_command_hdr *cmd = (void *)skb->data;
 			__u16 opcode = le16_to_cpu(cmd->opcode);
 
-			/* When the 0xfc01 command is issued to boot into
-			 * the operational firmware, it will actually not
-			 * send a command complete event. To keep the flow
+			/* When the BTINTEL_HCI_OP_RESET command is issued to
+			 * boot into the operational firmware, it will actually
+			 * not send a command complete event. To keep the flow
 			 * control working inject that event here.
 			 */
-			if (opcode == 0xfc01)
+			if (opcode == BTINTEL_HCI_OP_RESET)
 				btintel_pcie_inject_cmd_complete(hdev, opcode);
 		}
 		/* Firmware raises alive interrupt on HCI_OP_RESET */
@@ -1995,10 +1995,10 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 	}
 
 	if (type == BTINTEL_PCIE_HCI_CMD_PKT &&
-	    (opcode == HCI_OP_RESET || opcode == 0xfc01)) {
+	    (opcode == HCI_OP_RESET || opcode == BTINTEL_HCI_OP_RESET)) {
 		old_ctxt = data->alive_intr_ctxt;
 		data->alive_intr_ctxt =
-			(opcode == 0xfc01 ? BTINTEL_PCIE_INTEL_HCI_RESET1 :
+			(opcode == BTINTEL_HCI_OP_RESET ? BTINTEL_PCIE_INTEL_HCI_RESET1 :
 				BTINTEL_PCIE_HCI_RESET);
 		bt_dev_dbg(data->hdev, "sent cmd: 0x%4.4x alive context changed: %s  ->  %s",
 			   opcode, btintel_pcie_alivectxt_state2str(old_ctxt),
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index db27d28e8a7e..66fd84fbbd22 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2594,12 +2594,12 @@ static int btusb_send_frame_intel(struct hci_dev *hdev, struct sk_buff *skb)
 			else
 				urb = alloc_ctrl_urb(hdev, skb);
 
-			/* When the 0xfc01 command is issued to boot into
-			 * the operational firmware, it will actually not
-			 * send a command complete event. To keep the flow
+			/* When the BTINTEL_HCI_OP_RESET command is issued to
+			 * boot into the operational firmware, it will actually
+			 * not send a command complete event. To keep the flow
 			 * control working inject that event here.
 			 */
-			if (opcode == 0xfc01)
+			if (opcode == BTINTEL_HCI_OP_RESET)
 				inject_cmd_complete(hdev, opcode);
 		} else {
 			urb = alloc_ctrl_urb(hdev, skb);
diff --git a/drivers/bluetooth/hci_intel.c b/drivers/bluetooth/hci_intel.c
index d22fbb7f9fc5..9b353c3d6442 100644
--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -1029,12 +1029,12 @@ static struct sk_buff *intel_dequeue(struct hci_uart *hu)
 		struct hci_command_hdr *cmd = (void *)skb->data;
 		__u16 opcode = le16_to_cpu(cmd->opcode);
 
-		/* When the 0xfc01 command is issued to boot into
-		 * the operational firmware, it will actually not
-		 * send a command complete event. To keep the flow
-		 * control working inject that event here.
+		/* When the BTINTEL_HCI_OP_RESET command is issued to boot into
+		 * the operational firmware, it will actually not send a command
+		 * complete event. To keep the flow control working inject that
+		 * event here.
 		 */
-		if (opcode == 0xfc01)
+		if (opcode == BTINTEL_HCI_OP_RESET)
 			inject_cmd_complete(hu->hdev, opcode);
 	}
 
-- 
2.39.5



