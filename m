Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619720;
	b=zC5HvGzgHaUZrzTknDXa/mtnU9ExclXILffm3fAMXE6Q5SEja1ZqNKn/HsKGlc0nKVDo
	 XQ7WIiqMip5FcZTZDcuXRI82R7FbAHeZTA/J5UZICmh/ghcq04CQAj2E6Dm/R0wZhyDcK
	 oAs4cOeQg3LFVZWMJ8q5Ewu67Txtv1r0uZD+dm48j4vw/DKviZ82aHFBkfQTQu5XDKHGK
	 1mx03cq09zjG/ivmrzj6wYQ5j2cUPJNseHsIf/FylHlnCOpL9Crhl0k8WopTjdBGUy+N9
	 xYLDPN0oGzVKvBduQ1VNM8zwTHcuZWZEN84HtzMUH5UK3PYwyY1xafKVSDSEOzMkfNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jv9D5XQS+dnR+xCLPt4edmI4PT0QMCIKiqM31eDOFJI=;
	b=sIkv9tOpdfb6WWvDh5rhspFvNvpMuOoCPrrUag1+RA3Zvzfl+46HoAyUj+9ODOP+Jwxp
	 IlFS9f984vRRDu4duxFRSG/6XasBJhfAI5UMk7DMdHsdaopxnW1gDVCr/JEtgCgclD/G8
	 ld8cB85j8qCFmPexxYhtyueMJyPjEA9nDPlvxT4+eH3i4NteZtD1NKAtbv9Z6qY07dcsw
	 yHA+KWcUpOb7CKVF0c60P/IWdrANCXzs73TV0YpLjBc5Cr8EuDzquM8oEV0xJzKAUVrrl
	 Pi3ax0pV9VWBg3fSaBUkcxhl7ZUQIuIk5TaNro0g3oG7oN2CFwToA+jVg1agk2bOGow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upQ2PKmC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5A9606A31E;
	Wed, 25 Nov 2026 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upQ2PKmC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF691F000C4;
	Wed, 25 Nov 2026 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619720;
	bh=Jv9D5XQS+dnR+xCLPt4edmI4PT0QMCIKiqM31eDOFJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upQ2PKmCsttlYzItFtcMRrGuZwNDBPnNrFr6QQ5alQdVzJIMgtJ5LdW9rfFpLXf6/
	 DGBskp31OwPlug46q6t2B4NRgRcA+5xH5tHVLj5PfhA91npCS17wjWaecejqH+v3hz
	 YScuIO6c3ETMnHJHlfp/QCijG4ffSBKHEXMlEV+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.3 0685/1005] Bluetooth: hci_qca: fix use-after-free in ibs debugfs files
Date: Wed, 25 Nov 2026 15:33:43 +0100
Message-ID: <20261125143837.799170403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit eeca795cec6d9c6c193c2c1bd0cb26cde44f9fc3 upstream.

qca_debugfs_init() creates an "ibs" directory under hdev->debugfs and
stores pointers to fields of struct qca_data in the debugfs files.
qca_close() frees qca_data without removing that directory, while
hdev->debugfs is only removed when the HCI device is released. The HCI
device can outlive the driver data, for example when an HCI socket still
references it, so reading or writing one of the ibs files then
dereferences freed memory.

Store the directory dentry in struct qca_data and remove the directory
with debugfs_remove_recursive() before qca_data is freed.
debugfs_remove() waits for callers that are already inside the file
operations, and any later access fails with -EIO instead of reaching the
debugfs helpers. This covers the two writable files as well.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261102113654.8724-1-25031212351%40stu.xidian.edu.cn
Fixes: 0ff252c1976d ("Bluetooth: hciuart: Add support QCA chipset for UART")
Cc: stable@vger.kernel.org
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -161,6 +161,7 @@ struct qca_data {
 	struct delayed_work ctrl_memdump_timeout;
 	struct qca_memdump_info *qca_memdump;
 	unsigned long flags;
+	struct dentry *debugfs_ibs_dir;
 	struct completion drop_ev_comp;
 	wait_queue_head_t suspend_wait_q;
 	enum qca_memdump_states memdump_state;
@@ -665,6 +666,7 @@ static void qca_debugfs_init(struct hci_
 		return;
 
 	ibs_dir = debugfs_create_dir("ibs", hdev->debugfs);
+	qca->debugfs_ibs_dir = ibs_dir;
 
 	/* read only */
 	mode = 0444;
@@ -744,6 +746,9 @@ static int qca_close(struct hci_uart *hu
 
 	hu->priv = NULL;
 
+	debugfs_remove_recursive(qca->debugfs_ibs_dir);
+	qca->debugfs_ibs_dir = NULL;
+
 	kfree(qca);
 
 	return 0;


