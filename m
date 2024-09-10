Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB08198840;
	Tue, 10 Sep 2024 10:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964232; cv=none; b=S7CrANvwkVZRwSTd8/lrWuPMkhf8BSmjyUw9wZT+pPYe9MumM43HVIzqiiWrOzoE2ZGVZPW7k+IlDJOWs0gqjrAtWtkW0brP8gFuttMFBwRGGYmi3jCvwfVV2+1DXaB6PoxOhD4ZBLRmIjg5oljRb/cFTLlqvsuxNtAtNBVqWf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964232; c=relaxed/simple;
	bh=fFgL9jmFgP3TkfdfVmj0+6msp2grDUtFZlTjrvCAuKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DK6zGzwV0yEr0opwPYwcowW1e6w6aFOk3Jp1/5qh/z88YNjDa78Y3ISG5ErlM53SSKhvPu7q+bg9rErHrwzLqrSyK9mIImmgBHdgRoLGY1tHbQSiI6FrgceSyykubsor/YhLYlC3GQK/yya24xl44a0smSSfL9GdP0JahW7/s38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8y4lw2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8y4lw2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB4AC4CEC6;
	Tue, 10 Sep 2024 10:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964232;
	bh=fFgL9jmFgP3TkfdfVmj0+6msp2grDUtFZlTjrvCAuKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8y4lw2nfoDj6BH3n4lxo8uENQ9pReJmJL/wt02Gqtf7qsCETaPAcUbvBRGu0GFTz
	 idyO+/zZ3XJgANgtZcFVLW9RfHL20Xenn7ChxRupK7q8fsCDiPhiyEDyWMxz4UOjC3
	 1r6n8Vg4R2BrY1BouDYa7hWe+NBxlMZW1OO/To7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/269] Bluetooth: hci_event: Use HCI error defines instead of magic values
Date: Tue, 10 Sep 2024 11:31:39 +0200
Message-ID: <20240910092612.183021403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit 79c0868ad65a8fc7cdfaa5f2b77a4b70d0b0ea16 ]

We have error defines already, so let's use them.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 2 ++
 net/bluetooth/hci_event.c   | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index d2a280a42f3b..1c427dd2d418 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -644,6 +644,7 @@ enum {
 #define HCI_ERROR_PIN_OR_KEY_MISSING	0x06
 #define HCI_ERROR_MEMORY_EXCEEDED	0x07
 #define HCI_ERROR_CONNECTION_TIMEOUT	0x08
+#define HCI_ERROR_COMMAND_DISALLOWED	0x0c
 #define HCI_ERROR_REJ_LIMITED_RESOURCES	0x0d
 #define HCI_ERROR_REJ_BAD_ADDR		0x0f
 #define HCI_ERROR_INVALID_PARAMETERS	0x12
@@ -652,6 +653,7 @@ enum {
 #define HCI_ERROR_REMOTE_POWER_OFF	0x15
 #define HCI_ERROR_LOCAL_HOST_TERM	0x16
 #define HCI_ERROR_PAIRING_NOT_ALLOWED	0x18
+#define HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE	0x1e
 #define HCI_ERROR_INVALID_LL_PARAMS	0x1e
 #define HCI_ERROR_UNSPECIFIED		0x1f
 #define HCI_ERROR_ADVERTISING_TIMEOUT	0x3c
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 727f040b6529..dc80c1560357 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -93,11 +93,11 @@ static u8 hci_cc_inquiry_cancel(struct hci_dev *hdev, void *data,
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
@@ -2285,7 +2285,7 @@ static void hci_cs_create_conn(struct hci_dev *hdev, __u8 status)
 
 	if (status) {
 		if (conn && conn->state == BT_CONNECT) {
-			if (status != 0x0c || conn->attempt > 2) {
+			if (status != HCI_ERROR_COMMAND_DISALLOWED || conn->attempt > 2) {
 				conn->state = BT_CLOSED;
 				hci_connect_cfm(conn, status);
 				hci_conn_del(conn);
@@ -6430,7 +6430,7 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev, void *data,
 			 * transition into connected state and mark it as
 			 * successful.
 			 */
-			if (!conn->out && ev->status == 0x1a &&
+			if (!conn->out && ev->status == HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE &&
 			    (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES))
 				status = 0x00;
 			else
-- 
2.43.0



