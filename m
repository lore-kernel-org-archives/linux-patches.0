Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623179;
	b=cjgzzYlxZ8m9lzoEcOV6PuBXRHKFRjg4Y/q/hYGxhugkm1Iny65SeuuObtEHB66jtkz8
	 z6WkHSz/tY7lpFEn/WhdsAKU0iHirQ2iIxKjX67NLuR9kHg1ZaC5ZXL1Rm4velsFpGk4e
	 N8L8fRCCKDube9GWo+6O9yq3nprxndQ3yfEsgzwPq0YNHs/TfKZk8LbRRinupfUSqMsGe
	 mkTWLvPNA9sUIUqJs1kXk2AWvBWguOaVt68ApHLBnC7GuJIImTw2v+3G/+zvyrBjdOHsa
	 lUmv4DXxataoJJeOdeDhSyWwQNRRpQauAMCTvg7dnU3TSnZHYrDxlHnHucoEEpB+/pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rsyFPjx57pLlwhued3mtyj3jMQZhpYSjOE2B+JBhjXk=;
	b=mmwPLvnKqIfd+paZNiD2TA1dBwdaTcFDPm4h4XlqIk/nnYbyxLGmLgVP+WpYwUcXYJsW
	 jEaGgOiO/PfYzMrjHbX1Bun1aqdsdl1f34Hd3L9w682OCFSjvw8H5CbB4h7Go0TKPyPX6
	 VryB1p2VXmG1UJ9vXOcAogssgniIl+7CrC6P3AIvO8NZfXYHT1hDoQf3fFjD5Tfhy0wJn
	 7ail3omOca8O88kHl+USsORhet3qGYsXqfP5VudtdM7NQKtsEH/QqGV0xwIoXlHJ0xPt4
	 +8/msnsWPzoAmrKrNsXAPw3Dvy05mzS4S0Lk+HP8VkuWtl/CNY2BnjzTs8ANlhOOi6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYkuNHRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FC6606A32D;
	Wed, 25 Nov 2026 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYkuNHRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6213A1F000D1;
	Wed, 25 Nov 2026 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623178;
	bh=rsyFPjx57pLlwhued3mtyj3jMQZhpYSjOE2B+JBhjXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYkuNHRDX81C59lwyn0ziUML1Ze1MZIFb9qRySvuPbzoiloJmdcg4NLTYyelTLNEC
	 bbUZ881q4XitLLjBZHeQxZLBNo9QgMSoISdDQq6Kv1rs2+Cb+mvfio+kVF8k2JkS1q
	 vE0e0zedG0fYWegFZIIc9XfwFyWS5Kmh0E35lLeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 739/990] Bluetooth: hci_qca: fix use-after-free in ibs debugfs files
Date: Wed, 25 Nov 2026 15:35:06 +0100
Message-ID: <20261125143839.376755230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,6 +162,7 @@ struct qca_data {
 	struct delayed_work ctrl_memdump_timeout;
 	struct qca_memdump_info *qca_memdump;
 	unsigned long flags;
+	struct dentry *debugfs_ibs_dir;
 	struct completion drop_ev_comp;
 	wait_queue_head_t suspend_wait_q;
 	enum qca_memdump_states memdump_state;
@@ -667,6 +668,7 @@ static void qca_debugfs_init(struct hci_
 		return;
 
 	ibs_dir = debugfs_create_dir("ibs", hdev->debugfs);
+	qca->debugfs_ibs_dir = ibs_dir;
 
 	/* read only */
 	mode = 0444;
@@ -742,6 +744,9 @@ static int qca_close(struct hci_uart *hu
 
 	hu->priv = NULL;
 
+	debugfs_remove_recursive(qca->debugfs_ibs_dir);
+	qca->debugfs_ibs_dir = NULL;
+
 	kfree(qca);
 
 	return 0;


