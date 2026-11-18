Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059562;
	b=bBKLOhWHf6QnAViHCZeszkd7crc4H7PMNJx3CiVBmpi+E5yt/c26bTe5ngXcKYPKEyIC
	 UZc4ECcYFfIb1wbeLs0r+QCuX+OEvgMP7lyCPcHg/yFklG0fknNVht+hg7xQ4xRWJTdtw
	 8OQf7px2d8UwZ7Kuir3mzEKKSLNImkJENhXXkSlFbL/wrPFRiTHvt4WC2IDa94IMHaict
	 WPMrs3lH7DMendYkMrQNQ8QkJl9jJYp3YJSsFk2kri/zv5O/WlVrfm21C4/6iY76hBf4H
	 sWr19DkuiYeCZFALxJI8IDa6AZP2SG2S/P8hf3UuHEDzAo8dGo8sRK7xotuQxT8xk0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VjXxx2pMBV80kdOlYUOoPtUWFtr3uY3QDcsi2dzLAG8=;
	b=RxSjH1IIsbUIWqc60a72XDldIs9ohmGr6rO/dWvd2iawqItUVyaaPPlMSfED4g/7Zz7p
	 rzvSIHXBODtjxDBDbTX5WOlzF6X5R1Hvx796TIs7tN/c0hTeDGIVZjd6ONICdWobAXD47
	 9Imem9XU2oWYd02AxV755jrbp2RJV3z+6nenbE9MdSq6+wbInrpxZJ/NA2gITXt24xdf4
	 FMUOnaO52T9BPH3Wre44hW4aLM5pQEULtrSiQ3OtykD2dlUtgHcExxC6fMFqq6XXkbZTD
	 VGBfU5J8F5m8jRPtUgTL6v5RF/yBCKqnck1fFJeUTK4XNnHP78tQYwSqcc1EMpvfdUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9rL9Fsx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E2606A325;
	Thu, 19 Nov 2026 03:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9rL9Fsx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543591F000C4;
	Thu, 19 Nov 2026 03:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059561;
	bh=VjXxx2pMBV80kdOlYUOoPtUWFtr3uY3QDcsi2dzLAG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9rL9FsxGjDY2osUAK6KmmxOUyGcNJTGje3YRvpo8OSsDdVDIRg8atHJjtCCR08Qb
	 03L9jaKy+sBON2NvMPJ/tUItIQeLHjHTu3HT271nRNJaO9/0AOg79yLYnZB/8g0h/m
	 KOk3R/fOtwVleAIBBYq8+n0gD9JFQ8LfGKQqGWqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0884/1848] Bluetooth: hci_core: Move all debugfs handling to hci_debugfs.c
Date: Wed, 18 Nov 2026 15:48:42 +0100
Message-ID: <20261118145953.496409266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 8331dc487fc55963e853b6858af716907717e181 ]

This moves hci_debugfs_create_basic to hci_debugfs.c which is where all
the others debugfs entries are handled.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 2a3e2287877b ("Bluetooth: hci_debugfs: Pin module for debugfs file operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c    | 124 ------------------------------------
 net/bluetooth/hci_debugfs.c | 123 +++++++++++++++++++++++++++++++++++
 net/bluetooth/hci_debugfs.h |   5 ++
 3 files changed, 128 insertions(+), 124 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 87ef9fdeb12ec..834cefb43b74e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -60,130 +60,6 @@ DEFINE_MUTEX(hci_cb_list_lock);
 /* HCI ID Numbering */
 static DEFINE_IDA(hci_index_ida);
 
-/* ---- HCI debugfs entries ---- */
-
-static ssize_t dut_mode_read(struct file *file, char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct hci_dev *hdev = file->private_data;
-	char buf[3];
-
-	buf[0] = hci_dev_test_flag(hdev, HCI_DUT_MODE) ? 'Y' : 'N';
-	buf[1] = '\n';
-	buf[2] = '\0';
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static ssize_t dut_mode_write(struct file *file, const char __user *user_buf,
-			      size_t count, loff_t *ppos)
-{
-	struct hci_dev *hdev = file->private_data;
-	struct sk_buff *skb;
-	bool enable;
-	int err;
-
-	if (!test_bit(HCI_UP, &hdev->flags))
-		return -ENETDOWN;
-
-	err = kstrtobool_from_user(user_buf, count, &enable);
-	if (err)
-		return err;
-
-	if (enable == hci_dev_test_flag(hdev, HCI_DUT_MODE))
-		return -EALREADY;
-
-	hci_req_sync_lock(hdev);
-	if (enable)
-		skb = __hci_cmd_sync(hdev, HCI_OP_ENABLE_DUT_MODE, 0, NULL,
-				     HCI_CMD_TIMEOUT);
-	else
-		skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL,
-				     HCI_CMD_TIMEOUT);
-	hci_req_sync_unlock(hdev);
-
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
-
-	kfree_skb(skb);
-
-	hci_dev_change_flag(hdev, HCI_DUT_MODE);
-
-	return count;
-}
-
-static const struct file_operations dut_mode_fops = {
-	.open		= simple_open,
-	.read		= dut_mode_read,
-	.write		= dut_mode_write,
-	.llseek		= default_llseek,
-};
-
-static ssize_t vendor_diag_read(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	struct hci_dev *hdev = file->private_data;
-	char buf[3];
-
-	buf[0] = hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) ? 'Y' : 'N';
-	buf[1] = '\n';
-	buf[2] = '\0';
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static ssize_t vendor_diag_write(struct file *file, const char __user *user_buf,
-				 size_t count, loff_t *ppos)
-{
-	struct hci_dev *hdev = file->private_data;
-	bool enable;
-	int err;
-
-	err = kstrtobool_from_user(user_buf, count, &enable);
-	if (err)
-		return err;
-
-	/* When the diagnostic flags are not persistent and the transport
-	 * is not active or in user channel operation, then there is no need
-	 * for the vendor callback. Instead just store the desired value and
-	 * the setting will be programmed when the controller gets powered on.
-	 */
-	if (test_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks) &&
-	    (!test_bit(HCI_RUNNING, &hdev->flags) ||
-	     hci_dev_test_flag(hdev, HCI_USER_CHANNEL)))
-		goto done;
-
-	hci_req_sync_lock(hdev);
-	err = hdev->set_diag(hdev, enable);
-	hci_req_sync_unlock(hdev);
-
-	if (err < 0)
-		return err;
-
-done:
-	if (enable)
-		hci_dev_set_flag(hdev, HCI_VENDOR_DIAG);
-	else
-		hci_dev_clear_flag(hdev, HCI_VENDOR_DIAG);
-
-	return count;
-}
-
-static const struct file_operations vendor_diag_fops = {
-	.open		= simple_open,
-	.read		= vendor_diag_read,
-	.write		= vendor_diag_write,
-	.llseek		= default_llseek,
-};
-
-static void hci_debugfs_create_basic(struct hci_dev *hdev)
-{
-	debugfs_create_file("dut_mode", 0644, hdev->debugfs, hdev,
-			    &dut_mode_fops);
-
-	if (hdev->set_diag)
-		debugfs_create_file("vendor_diag", 0644, hdev->debugfs, hdev,
-				    &vendor_diag_fops);
-}
-
 static int hci_reset_req(struct hci_request *req, unsigned long opt)
 {
 	BT_DBG("%s %ld", req->hdev->name, opt);
diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 1192280031685..987a546de3ae1 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -27,6 +27,7 @@
 #include <net/bluetooth/hci_core.h>
 
 #include "smp.h"
+#include "hci_request.h"
 #include "hci_debugfs.h"
 
 #define DEFINE_QUIRK_ATTRIBUTE(__name, __quirk)				      \
@@ -1270,3 +1271,125 @@ void hci_debugfs_create_conn(struct hci_conn *conn)
 	snprintf(name, sizeof(name), "%u", conn->handle);
 	conn->debugfs = debugfs_create_dir(name, hdev->debugfs);
 }
+
+static ssize_t dut_mode_read(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_DUT_MODE) ? 'Y' : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t dut_mode_write(struct file *file, const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	struct sk_buff *skb;
+	bool enable;
+	int err;
+
+	if (!test_bit(HCI_UP, &hdev->flags))
+		return -ENETDOWN;
+
+	err = kstrtobool_from_user(user_buf, count, &enable);
+	if (err)
+		return err;
+
+	if (enable == hci_dev_test_flag(hdev, HCI_DUT_MODE))
+		return -EALREADY;
+
+	hci_req_sync_lock(hdev);
+	if (enable)
+		skb = __hci_cmd_sync(hdev, HCI_OP_ENABLE_DUT_MODE, 0, NULL,
+				     HCI_CMD_TIMEOUT);
+	else
+		skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL,
+				     HCI_CMD_TIMEOUT);
+	hci_req_sync_unlock(hdev);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	kfree_skb(skb);
+
+	hci_dev_change_flag(hdev, HCI_DUT_MODE);
+
+	return count;
+}
+
+static const struct file_operations dut_mode_fops = {
+	.open		= simple_open,
+	.read		= dut_mode_read,
+	.write		= dut_mode_write,
+	.llseek		= default_llseek,
+};
+
+static ssize_t vendor_diag_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) ? 'Y' : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t vendor_diag_write(struct file *file, const char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	bool enable;
+	int err;
+
+	err = kstrtobool_from_user(user_buf, count, &enable);
+	if (err)
+		return err;
+
+	/* When the diagnostic flags are not persistent and the transport
+	 * is not active or in user channel operation, then there is no need
+	 * for the vendor callback. Instead just store the desired value and
+	 * the setting will be programmed when the controller gets powered on.
+	 */
+	if (test_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks) &&
+	    (!test_bit(HCI_RUNNING, &hdev->flags) ||
+	     hci_dev_test_flag(hdev, HCI_USER_CHANNEL)))
+		goto done;
+
+	hci_req_sync_lock(hdev);
+	err = hdev->set_diag(hdev, enable);
+	hci_req_sync_unlock(hdev);
+
+	if (err < 0)
+		return err;
+
+done:
+	if (enable)
+		hci_dev_set_flag(hdev, HCI_VENDOR_DIAG);
+	else
+		hci_dev_clear_flag(hdev, HCI_VENDOR_DIAG);
+
+	return count;
+}
+
+static const struct file_operations vendor_diag_fops = {
+	.open		= simple_open,
+	.read		= vendor_diag_read,
+	.write		= vendor_diag_write,
+	.llseek		= default_llseek,
+};
+
+void hci_debugfs_create_basic(struct hci_dev *hdev)
+{
+	debugfs_create_file("dut_mode", 0644, hdev->debugfs, hdev,
+			    &dut_mode_fops);
+
+	if (hdev->set_diag)
+		debugfs_create_file("vendor_diag", 0644, hdev->debugfs, hdev,
+				    &vendor_diag_fops);
+}
diff --git a/net/bluetooth/hci_debugfs.h b/net/bluetooth/hci_debugfs.h
index 4444dc8cedc21..9a8a7c93bb12a 100644
--- a/net/bluetooth/hci_debugfs.h
+++ b/net/bluetooth/hci_debugfs.h
@@ -26,6 +26,7 @@ void hci_debugfs_create_common(struct hci_dev *hdev);
 void hci_debugfs_create_bredr(struct hci_dev *hdev);
 void hci_debugfs_create_le(struct hci_dev *hdev);
 void hci_debugfs_create_conn(struct hci_conn *conn);
+void hci_debugfs_create_basic(struct hci_dev *hdev);
 
 #else
 
@@ -45,4 +46,8 @@ static inline void hci_debugfs_create_conn(struct hci_conn *conn)
 {
 }
 
+static inline void hci_debugfs_create_basic(struct hci_dev *hdev)
+{
+}
+
 #endif
-- 
2.53.0



