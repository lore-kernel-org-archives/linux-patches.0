Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053817;
	b=0QLohTSqbjaYmWbEqSNwYR3TujhzY6IwciUKQcwVJNRy4UNFtfLuDX5Z8IxzfKt0S3+X
	 Wt6RlhYf/xdPjT8VWXgtlor7GYC5Rt5fvLc1x+CpS3S45rlDierV4gWwaXBIimUuQxmfw
	 gpWezG0aEwjJfeJoMPOEzIwfTTLoybNjYwP9WxDJkzkXuihB0mr0vM1ksh1Zs7WAjGdf8
	 tTvOZDTvbvtE0R4rJWSLlBFm+fOZzwHeyuk3hm/OJBjUkbzg+GTdd+2simVlRhGP0/2uV
	 TzruX0Z8NHdtHI1+kHh8aJ23Ytwvx23ySGOQzUAMl5lzofI/IPHpH3lGCt0F/Ik7ufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DZduJlWKkjEJ9x5peBHXUpILdU+EqRkY+X9+MzT6wwI=;
	b=cVuaJBZOfmPT9C0CnGvZS1gj6ugTkporAftT+yxhsF4oPkJIbjgcUMzTThvooYrUplET
	 Nv+seklzgye3kFA4klxHPT7tPAdGUHb400GNXofkCnIsUO9tWc5H3BAjc0C8bmdhIOfRs
	 Iok//wa6PHKpiVQ9vebAIdUga+xl1EllPv8HmVV3NA1ZjVTnv6uzEM144Ss5dsq4DENP+
	 zmTc05Jnrm8lo+H2PMlatfa05HBdxSVpJxo8CY4CR2hLK0WEnW4+t/8Uvgi6pEW8rsG0Z
	 wS68xT5KXgLZsBMPIIVV5SEBEkRLayKMg0RrvjD8wDnP8mM9HcfVEfVrLIqhs1DwbBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTqoRRcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8C0606A31C;
	Thu, 19 Nov 2026 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTqoRRcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2081F000C4;
	Thu, 19 Nov 2026 02:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053817;
	bh=DZduJlWKkjEJ9x5peBHXUpILdU+EqRkY+X9+MzT6wwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTqoRRcmu6RCg8ET2BPLy1kT1+HVIETbOe5rF9NgljBLnbYYBJkjjg3qqwLzmP4u+
	 qRfJp2eOyEdQVGOfC/rEiUI319s3SgSHtU8Zhn+OX1W8tcbOimsWtER849ILwzcFUS
	 YCnfolEttaXHukfwkBhNpSCaqTr/fyMcF4qm18vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1052/2214] Bluetooth: hci_core: Move all debugfs handling to hci_debugfs.c
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118150054.409584060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c31919623d1b4..170389a36bd9e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -61,130 +61,6 @@ DEFINE_MUTEX(hci_cb_list_lock);
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
index b4ff99a4e5318..be805c87619c7 100644
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



