Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC63F21ADAE;
	Tue,  8 Apr 2025 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111064; cv=none; b=gK0m4wEKttCkHdbeUA9/fjEJXo2vhmlX72BNQtfJ0peoZw68L2c2E+nokd7wl1/WsW4Qzqo/5u0bOdz4YfFuMNqGHyZ8JvE0wKriW5PkOWC2Jgz2JJ1LfqCbhH2NTP9X6UXNIQqKVRTvo/hTDEgnYqvHhgXBa7wr2cwIZQKOQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111064; c=relaxed/simple;
	bh=zfQEdhFiAkuwXLjgFQ6OjST5nfU5kIV36u3B7vevrOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9uNLX5lOW83zWx0ElNvcVnjHMMETaniWGcoCsq70cfB9ipxkGApsiDHXlSYIXgYCFFiePTWQ2gWteqBUWM7XA/siAeN5VofT0RhS+ArLhXVlThwpM5bgetVPTfQT1SJIiOE9XuaZ42yjpNJd2UhsDxU3eYd+r3OesWtjh2ncyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFWE90bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFWE90bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3CDC4CEE5;
	Tue,  8 Apr 2025 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111063;
	bh=zfQEdhFiAkuwXLjgFQ6OjST5nfU5kIV36u3B7vevrOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFWE90biU7TrIFq/Jw0ckNP9cjfNBx1MseA9ehSdrPrWLs3xlxYOO3StiBQXMZWE6
	 Y8tqBX0UGUtqR4NdYdXts/opeGs90tX2PAUwTErO84/ujb5zdyBfjtnGG3xZxefxKx
	 bPDDSMdzRq1EQ7sqdlL3M+y+rQkXHQfFmer1GmhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 257/731] Bluetooth: HCI: Add definition of hci_rp_remote_name_req_cancel
Date: Tue,  8 Apr 2025 12:42:34 +0200
Message-ID: <20250408104920.261753870@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit e8c00f5433d020a2230226abe7e43f43dc686920 ]

Return Parameters is not only status, also bdaddr:

BLUETOOTH CORE SPECIFICATION Version 5.4 | Vol 4, Part E
page 1870:
BLUETOOTH CORE SPECIFICATION Version 5.0 | Vol 2, Part E
page 802:

Return parameters:
  Status:
  Size: 1 octet
  BD_ADDR:
  Size: 6 octets

Note that it also fixes the warning:
"Bluetooth: hci0: unexpected cc 0x041a length: 7 > 1"

Fixes: c8992cffbe741 ("Bluetooth: hci_event: Use of a function table to handle Command Complete")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 5 +++++
 net/bluetooth/hci_event.c   | 6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 6da61c185c949..a8586c3058c7c 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -879,6 +879,11 @@ struct hci_cp_remote_name_req_cancel {
 	bdaddr_t bdaddr;
 } __packed;
 
+struct hci_rp_remote_name_req_cancel {
+	__u8     status;
+	bdaddr_t bdaddr;
+} __packed;
+
 #define HCI_OP_READ_REMOTE_FEATURES	0x041b
 struct hci_cp_read_remote_features {
 	__le16   handle;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ab95e49f042ea..dd86b7a242b72 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -151,7 +151,7 @@ static u8 hci_cc_exit_periodic_inq(struct hci_dev *hdev, void *data,
 static u8 hci_cc_remote_name_req_cancel(struct hci_dev *hdev, void *data,
 					struct sk_buff *skb)
 {
-	struct hci_ev_status *rp = data;
+	struct hci_rp_remote_name_req_cancel *rp = data;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
@@ -4012,8 +4012,8 @@ static const struct hci_cc {
 	HCI_CC_STATUS(HCI_OP_INQUIRY_CANCEL, hci_cc_inquiry_cancel),
 	HCI_CC_STATUS(HCI_OP_PERIODIC_INQ, hci_cc_periodic_inq),
 	HCI_CC_STATUS(HCI_OP_EXIT_PERIODIC_INQ, hci_cc_exit_periodic_inq),
-	HCI_CC_STATUS(HCI_OP_REMOTE_NAME_REQ_CANCEL,
-		      hci_cc_remote_name_req_cancel),
+	HCI_CC(HCI_OP_REMOTE_NAME_REQ_CANCEL, hci_cc_remote_name_req_cancel,
+	       sizeof(struct hci_rp_remote_name_req_cancel)),
 	HCI_CC(HCI_OP_ROLE_DISCOVERY, hci_cc_role_discovery,
 	       sizeof(struct hci_rp_role_discovery)),
 	HCI_CC(HCI_OP_READ_LINK_POLICY, hci_cc_read_link_policy,
-- 
2.39.5



