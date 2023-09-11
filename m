Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04BBC153
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FACFC433C8;
	Mon, 11 Sep 2023 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442945;
	bh=COixVYk3EV3/zxYDLCdbLf8C7jIke5QA0LhJkegqatA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY0P/ZXSnvD5XGjqtrUKzO3JzSTkPjOqJutEMKG7MA8/ooLbWHmKzUggTDNdXNSXQ
	 QJs7QtqBudKv3EJtZ56aFSvxx68JPp7vK8Ia56B1zfcBHe9l17E/65+z/t/VL8dimC
	 i+H2Co1hOy4OnTX6haRks1nRfa3sdf0y+bjS08IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 203/737] Bluetooth: hci_sync: Dont double print name in add/remove adv_monitor
Date: Mon, 11 Sep 2023 15:41:02 +0200
Message-ID: <20230911134656.269695654@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6f55eea116ba3646fb5fbb31de703f8cf79d8214 ]

The hci_add_adv_monitor() hci_remove_adv_monitor() functions call
bt_dev_dbg() to print some debug statements. The bt_dev_dbg() macro
automatically adds in the device's name. That means that we shouldn't
include the name in the bt_dev_dbg() calls.

Suggested-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a2bcd2b63271 ("Bluetooth: hci_sync: Avoid use-after-free in dbg for hci_add_adv_monitor()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 793b66da22653..04b51ffd946b7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1949,14 +1949,14 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 
 	switch (hci_get_adv_monitor_offload_ext(hdev)) {
 	case HCI_ADV_MONITOR_EXT_NONE:
-		bt_dev_dbg(hdev, "%s add monitor %d status %d", hdev->name,
+		bt_dev_dbg(hdev, "add monitor %d status %d",
 			   monitor->handle, status);
 		/* Message was not forwarded to controller - not an error */
 		break;
 
 	case HCI_ADV_MONITOR_EXT_MSFT:
 		status = msft_add_monitor_pattern(hdev, monitor);
-		bt_dev_dbg(hdev, "%s add monitor %d msft status %d", hdev->name,
+		bt_dev_dbg(hdev, "add monitor %d msft status %d",
 			   monitor->handle, status);
 		break;
 	}
@@ -1976,15 +1976,15 @@ static int hci_remove_adv_monitor(struct hci_dev *hdev,
 
 	switch (hci_get_adv_monitor_offload_ext(hdev)) {
 	case HCI_ADV_MONITOR_EXT_NONE: /* also goes here when powered off */
-		bt_dev_dbg(hdev, "%s remove monitor %d status %d", hdev->name,
+		bt_dev_dbg(hdev, "remove monitor %d status %d",
 			   monitor->handle, status);
 		goto free_monitor;
 
 	case HCI_ADV_MONITOR_EXT_MSFT:
 		handle = monitor->handle;
 		status = msft_remove_monitor(hdev, monitor);
-		bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
-			   hdev->name, handle, status);
+		bt_dev_dbg(hdev, "remove monitor %d msft status %d",
+			   handle, status);
 		break;
 	}
 
-- 
2.40.1



