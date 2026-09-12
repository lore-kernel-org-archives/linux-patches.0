Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D891D288B9;
	Sat, 12 Sep 2026 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231304; cv=none; b=CdXWFH5RNvxHUkxmAZBY0he7/396l8VetkeAkITJFiqRVA9/ZNnROTjsXlkQgll3ciN+g658oTGKN8sctMxg+y1BORGoUM8ALTo1U642i8vKQCfzPvRq7aTtNNbebusSaimi1RnKVj34WlXm6/GwP5WjumpqT1A6/lpTLyxHnn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231304; c=relaxed/simple;
	bh=zm6E96WNIbcVgeGKyQKYbC57eb56JJhFYP1NYZPNWlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzLU6rH+5sSAsNXSHOueQIc5OM+ORYNvz+lYlvUlskA8RuxdnVjgKInbNGTh93btqappmlokZSYrHTtQlAnI1o3xibkUWxbARkW2svmqQD3SyXJdn2RhniPP/EIafh6mCl3ojIMZ7tQQZ65PIZTYzWVzM0kZjdMOGDGMlRVy1HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLrDS580; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLrDS580"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2281F000FF;
	Sat, 12 Sep 2026 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231302;
	bh=29/IDWZ8SMDPpBqKRtsG2iTioKoYWdHKtMOfjVEIvZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLrDS580WxxINTWQOlfb9XUMOSotQV0aXoNbhS4eHeUxDmKOGazNyvAyk7uYSyEU6
	 xJiNs8oZ28zLTpnuS+eQvGhsPcERfQZB4WVkOsL5LICu5fCaCMjarjqdXwjtd6OEDC
	 0Jo6YKuy9oHg7JyjuWzlSF5Ygsghup3lk++5U4v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0928/1191] Bluetooth: hci_event: Use HCI error defines instead of magic values
Date: Sat, 12 Sep 2026 09:00:56 +0200
Message-ID: <20260912065609.073236247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit 79c0868ad65a8fc7cdfaa5f2b77a4b70d0b0ea16 ]

We have error defines already, so let's use them.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 42de40abe25d ("Bluetooth: hci_conn: fix the SCO setup context lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 2 ++
 net/bluetooth/hci_event.c   | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 22b9c031986a2..403988938ea1f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -623,6 +623,7 @@ enum {
 #define HCI_ERROR_PIN_OR_KEY_MISSING	0x06
 #define HCI_ERROR_MEMORY_EXCEEDED	0x07
 #define HCI_ERROR_CONNECTION_TIMEOUT	0x08
+#define HCI_ERROR_COMMAND_DISALLOWED	0x0c
 #define HCI_ERROR_REJ_LIMITED_RESOURCES	0x0d
 #define HCI_ERROR_REJ_BAD_ADDR		0x0f
 #define HCI_ERROR_INVALID_PARAMETERS	0x12
@@ -631,6 +632,7 @@ enum {
 #define HCI_ERROR_REMOTE_POWER_OFF	0x15
 #define HCI_ERROR_LOCAL_HOST_TERM	0x16
 #define HCI_ERROR_PAIRING_NOT_ALLOWED	0x18
+#define HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE	0x1e
 #define HCI_ERROR_INVALID_LL_PARAMS	0x1e
 #define HCI_ERROR_UNSPECIFIED		0x1f
 #define HCI_ERROR_ADVERTISING_TIMEOUT	0x3c
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e48df723afcdd..aa879b0b64cf5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -90,11 +90,11 @@ static u8 hci_cc_inquiry_cancel(struct hci_dev *hdev, void *data,
 	/* It is possible that we receive Inquiry Complete event right
 	 * before we receive Inquiry Cancel Command Complete event, in
 	 * which case the latter event should have status of Command
-	 * Disallowed (0x0c). This should not be treated as error, since
+	 * Disallowed. This should not be treated as error, since
 	 * we actually achieve what Inquiry Cancel wants to achieve,
 	 * which is to end the last Inquiry session.
 	 */
-	if (rp->status == 0x0c && !test_bit(HCI_INQUIRY, &hdev->flags)) {
+	if (rp->status == HCI_ERROR_COMMAND_DISALLOWED && !test_bit(HCI_INQUIRY, &hdev->flags)) {
 		bt_dev_warn(hdev, "Ignoring error of Inquiry Cancel command");
 		rp->status = 0x00;
 	}
@@ -2245,7 +2245,7 @@ static void hci_cs_create_conn(struct hci_dev *hdev, __u8 status)
 
 	if (status) {
 		if (conn && conn->state == BT_CONNECT) {
-			if (status != 0x0c || conn->attempt > 2) {
+			if (status != HCI_ERROR_COMMAND_DISALLOWED || conn->attempt > 2) {
 				conn->state = BT_CLOSED;
 				hci_connect_cfm(conn, status);
 				hci_conn_del(conn);
@@ -6410,7 +6410,7 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev, void *data,
 			 * transition into connected state and mark it as
 			 * successful.
 			 */
-			if (!conn->out && ev->status == 0x1a &&
+			if (!conn->out && ev->status == HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE &&
 			    (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES))
 				status = 0x00;
 			else
-- 
2.53.0



