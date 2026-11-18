Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059559;
	b=VakWYkuv+fUkbkTEour5N6PJU9SWdMrs+b93Yznb8WEzuu54tTfYrb5psiTr/3vvpnDA
	 uojCVkmpInXp5gfeY3LF33Tl8gdU4d7vG8DdrVNjVdhFyFpkFzMjCxlldbcgO6T3CjELm
	 FqaiLV7zgsM7V3YOa/JfFhDdqYk3EwbdIt9FeIQjFeaBT0paV5Cw3yyPM9kSkCka6aTXK
	 m+fAiivRZmYDkfy9QTG+hIdA3+MkjqxlrgAiTPxPSKKURxEGNn3G18sJrwN+vncnEj94o
	 LxmHijDwHbNUjrOJVbnREPx4GJeqoumm30JWcd3vct6TrLhfP7D0FmUEtM+vq4dG0Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wzVDxPu4E4Rh06UnxpTzOq8welSGU6TrE01G2PllpwY=;
	b=2espgiZ6+ER9LKdZwgCeKgWPJlqpDoXeABX2FFeZ4pGNSAqjwnw+DraCcwdWA188CmLh
	 d0nQSQn7JMkAVJKmZ2GQ4WoQr+JskoVIJa9jTL7JMcWKbJ5/ibt7qEeGzYm4q98INZCSz
	 Yh6toPreSISNBjEsY33++LA3W4Gh6aI5OZ6C2/0we+uLTJKQFTK70JP+vRifA55I4dmTB
	 fpjgUYPF2UMsJssMvBhM2BQbGnxe3ZBuL7TCLTOWpkdXgDQbC1i86BiiE/TlGwR9cT1vp
	 Ibj6mzN+AmttHsr0Io1Y6EgWHklznVK+brU20V+Z37YqyxEDH5Bo78+UKNUAJsIvjpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXEFb9Fh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5EA606A325;
	Thu, 19 Nov 2026 03:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXEFb9Fh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8598E1F000C4;
	Thu, 19 Nov 2026 03:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059559;
	bh=wzVDxPu4E4Rh06UnxpTzOq8welSGU6TrE01G2PllpwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXEFb9FhK2DuR7R6obU/+FWtD9etOjURdmoHzkPxyOU6CWTU6ihWpYHDK5b4BsTKE
	 cixENgFi2ZssMZSwyABxiRpYTp1hLOYbc+l9CmpJaGHI+u3S7pnwhNhym6Qh3vY9KI
	 FwOjd2nKqMw7DfkNs8LdWhhq2eOZCBcFfnVuaE6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claire Chang <tientzu@chromium.org>,
	Alain Michaud <alainm@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0883/1848] Bluetooth: Move force_bredr_smp debugfs into hci_debugfs_create_bredr
Date: Wed, 18 Nov 2026 15:48:41 +0100
Message-ID: <20261118145953.450216062@linuxfoundation.org>
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

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 82493316507a720b6faa2ec23971c0ca89c6dcb0 ]

Avoid multiple attempts to create the debugfs entry, force_bredr_smp,
by moving it from the SMP registration to the BR/EDR controller init
section. hci_debugfs_create_bredr is only called when HCI_SETUP and
HCI_CONFIG is not set.

Signed-off-by: Claire Chang <tientzu@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 2a3e2287877b ("Bluetooth: hci_debugfs: Pin module for debugfs file operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_debugfs.c | 50 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/smp.c         | 44 ++------------------------------
 net/bluetooth/smp.h         |  2 ++
 3 files changed, 54 insertions(+), 42 deletions(-)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index a1f6e6c9dd4f3..1192280031685 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -498,6 +498,45 @@ static int auto_accept_delay_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(auto_accept_delay_fops, auto_accept_delay_get,
 			auto_accept_delay_set, "%llu\n");
 
+static ssize_t force_bredr_smp_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y' : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t force_bredr_smp_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	bool enable;
+	int err;
+
+	err = kstrtobool_from_user(user_buf, count, &enable);
+	if (err)
+		return err;
+
+	err = smp_force_bredr(hdev, enable);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations force_bredr_smp_fops = {
+	.open		= simple_open,
+	.read		= force_bredr_smp_read,
+	.write		= force_bredr_smp_write,
+	.llseek		= default_llseek,
+};
+
 static int idle_timeout_set(void *data, u64 val)
 {
 	struct hci_dev *hdev = data;
@@ -597,6 +636,17 @@ void hci_debugfs_create_bredr(struct hci_dev *hdev)
 	debugfs_create_file("voice_setting", 0444, hdev->debugfs, hdev,
 			    &voice_setting_fops);
 
+	/* If the controller does not support BR/EDR Secure Connections
+	 * feature, then the BR/EDR SMP channel shall not be present.
+	 *
+	 * To test this with Bluetooth 4.0 controllers, create a debugfs
+	 * switch that allows forcing BR/EDR SMP support and accepting
+	 * cross-transport pairing on non-AES encrypted connections.
+	 */
+	if (!lmp_sc_capable(hdev))
+		debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
+				    hdev, &force_bredr_smp_fops);
+
 	if (lmp_ssp_capable(hdev)) {
 		debugfs_create_file("ssp_debug_mode", 0444, hdev->debugfs,
 				    hdev, &ssp_debug_mode_fops);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 5466b1f1add9e..eefc9aa479f08 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3388,31 +3388,8 @@ static void smp_del_chan(struct l2cap_chan *chan)
 	l2cap_chan_put(chan);
 }
 
-static ssize_t force_bredr_smp_read(struct file *file,
-				    char __user *user_buf,
-				    size_t count, loff_t *ppos)
+int smp_force_bredr(struct hci_dev *hdev, bool enable)
 {
-	struct hci_dev *hdev = file->private_data;
-	char buf[3];
-
-	buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y': 'N';
-	buf[1] = '\n';
-	buf[2] = '\0';
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static ssize_t force_bredr_smp_write(struct file *file,
-				     const char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct hci_dev *hdev = file->private_data;
-	bool enable;
-	int err;
-
-	err = kstrtobool_from_user(user_buf, count, &enable);
-	if (err)
-		return err;
-
 	if (enable == hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
 		return -EALREADY;
 
@@ -3434,16 +3411,9 @@ static ssize_t force_bredr_smp_write(struct file *file,
 
 	hci_dev_change_flag(hdev, HCI_FORCE_BREDR_SMP);
 
-	return count;
+	return 0;
 }
 
-static const struct file_operations force_bredr_smp_fops = {
-	.open		= simple_open,
-	.read		= force_bredr_smp_read,
-	.write		= force_bredr_smp_write,
-	.llseek		= default_llseek,
-};
-
 int smp_register(struct hci_dev *hdev)
 {
 	struct l2cap_chan *chan;
@@ -3468,17 +3438,7 @@ int smp_register(struct hci_dev *hdev)
 
 	hdev->smp_data = chan;
 
-	/* If the controller does not support BR/EDR Secure Connections
-	 * feature, then the BR/EDR SMP channel shall not be present.
-	 *
-	 * To test this with Bluetooth 4.0 controllers, create a debugfs
-	 * switch that allows forcing BR/EDR SMP support and accepting
-	 * cross-transport pairing on non-AES encrypted connections.
-	 */
 	if (!lmp_sc_capable(hdev)) {
-		debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
-				    hdev, &force_bredr_smp_fops);
-
 		/* Flag can be already set here (due to power toggle) */
 		if (!hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
 			return 0;
diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
index bad594642a53d..c5da53dfab04f 100644
--- a/net/bluetooth/smp.h
+++ b/net/bluetooth/smp.h
@@ -194,6 +194,8 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
 int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa);
 int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16]);
 
+int smp_force_bredr(struct hci_dev *hdev, bool enable);
+
 int smp_register(struct hci_dev *hdev);
 void smp_unregister(struct hci_dev *hdev);
 
-- 
2.53.0



