Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020364;
	b=oYE6wGheYbzwfaOfeM6vcnpoU1rMFjGgk7zk13MQruRcdRY4LCLGxFTWIJZppI+FMQ3t
	 KTbIUNRkGYFwxu3P5p1hTg5b0ihUKZI9lTiJofhN4etkdQcszLQFnMF1xdTJbMHsL9Aog
	 GZg+f6wvNbH9ORzCSZOFQ0VSHD/4NgjYDdIPpfJe4WYm+USzVBy3VH5wSVYOwT5pHDZ0I
	 MNUwo8ZyX+b58HWHRi5qNuC8+OGIcUUGn577v8Mw2GcQ13vV5yFBegQq9w4HYzdqgpKhY
	 B/XTaYdfTZ0RAfsMmnxr8g8a+ZHHWaY8DBO+ZTlStYD/uCxc3tEagPQhwCFphg1KQSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGjn681DkD9gh1ycov7toSsjWvqt/fS7vgQu0sM45tE=;
	b=C0JSLoEuW8KRkVH8Eluc8dz2mSEVFfcKzPYfiYAqxBgMNMqkydGcOTaQihtE+HGSYYeb
	 6asFAxdEoB3F7oVAoZuY7SoPTMosVh9LcoAtjkd2o3/hvk5ifF3xyrtzxMK17Jc4+uvy1
	 qofoxyM2zD+Shrf2bnxhv8m2k1v8+Wk69vxvEPV25uqMAa8jT5WaHTkbNso95XdM9LmzK
	 i89ryd/8PO0mLvEazibGcWXEJfWJAvJvz/qGzLH/+CrZq2xTtdByKek1Pv8lgv8ZlyMpG
	 jbgsgbr14IDlYa2wZuwETEa3d5pTwIi1p3WhxwkgUon4mQdgWxIU97jdmoOeThtenzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkQQ0l63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228FA606A325;
	Wed, 18 Nov 2026 16:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkQQ0l63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7820C1F000C5;
	Wed, 18 Nov 2026 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020364;
	bh=nGjn681DkD9gh1ycov7toSsjWvqt/fS7vgQu0sM45tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkQQ0l63lNcD+Nxv6rQDJipdpafOzGd88WJ50bc7LIEHYvGZV0d3262ngTvbptS8L
	 wOHpsGpU8rqjexiweCUDjfCNmUPikAf5Kt9ZUCQ/k945WkEuidORcaSoivcg2+lPyU
	 qHP29NpksZenbcZsU/ANp54elWfXNskWFrLSs6Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1884/2651] Bluetooth: btintel_pcie: sync mbox tlv parsing with GP0 alive interrupt
Date: Wed, 18 Nov 2026 15:52:04 +0100
Message-ID: <20261118150354.738615053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit d572ea4b621ce60279da5179a0c338660c8b7331 ]

Performing a target access to read the mbox TLV table while the driver
is concurrently posting RX buffers to the firmware causes the hardware
to return 0 for the target address, resulting in an invalid/empty TLV
parse.

Add a synchronization handshake between the mbox TLV read operation
performed by the mbox worker and the GP0 (alive) MSI-X interrupt (which
signals completion of RX buffer posting). The worker now waits for the
alive interrupt before initiating the target access, ensuring the
hardware returns valid data.

Assisted-by: Gemini:gemini-3.1-pro-preview
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 4f6ead67b93b ("Bluetooth: btintel_pcie: verify and serialize D-state transitions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 42 +++++++++++++++++++++++++++++---
 drivers/bluetooth/btintel_pcie.h | 10 +++++++-
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 8ad639e4d3ca0..9f7a9bf592f69 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -989,6 +989,24 @@ static int btintel_parse_mbox_tlv(struct btintel_pcie_data *data)
 	struct mbox_tlv *tlv;
 	struct btintel_data *cnvi_data = hci_get_priv(data->hdev);
 	u8 hw_variant = INTEL_HW_VARIANT(cnvi_data->cnvi_bt);
+	long t;
+
+	/* Wait for GP0 alive interrupt to post RX buffers */
+	t = wait_event_timeout(data->mbox_parse_wait_q,
+			       test_bit(BTINTEL_PCIE_MBOX_PARSE_READY, &data->flags),
+			       msecs_to_jiffies(BTINTEL_PCIE_MBOX_INTR_TIMEOUT_MS));
+	if (!t) {
+		bt_dev_warn(data->hdev,
+			    "Timeout (%u ms) waiting for alive interrupt before mbox TLV parse; skipping",
+			    BTINTEL_PCIE_MBOX_INTR_TIMEOUT_MS);
+		return 0;
+	}
+	clear_bit(BTINTEL_PCIE_MBOX_PARSE_READY, &data->flags);
+
+	bt_dev_info(data->hdev,
+		    "mbox TLV parse started at %lld ns (%lld us after mbox interrupt)",
+		    ktime_to_ns(ktime_get()),
+		    ktime_to_us(ktime_sub(ktime_get(), data->mbox_intr_ts)));
 
 	memset(&data->dump_info, 0, sizeof(data->dump_info));
 
@@ -1232,12 +1250,22 @@ static void btintel_pcie_msix_gp1_handler(struct btintel_pcie_data *data)
 	if (target_access &&
 	    !test_and_set_bit(BTINTEL_PCIE_MAIL_BOX_INTR,
 				   &data->flags)) {
+		/* Arm the mbox<->alive handshake */
+		clear_bit(BTINTEL_PCIE_MBOX_PARSE_READY, &data->flags);
+		set_bit(BTINTEL_PCIE_MBOX_PARSE_PENDING, &data->flags);
+		data->mbox_intr_ts = ktime_get();
+
+		bt_dev_info(data->hdev,
+			    "mbox interrupt received at %lld ns; queuing mbox_work",
+			    ktime_to_ns(data->mbox_intr_ts));
+
 		WRITE_ONCE(data->debug_table_addr, addr);
 		WRITE_ONCE(data->debug_table_size, size);
 		if (!queue_work(data->dump_workqueue,
-				&data->mbox_work))
-			clear_bit(BTINTEL_PCIE_MAIL_BOX_INTR,
-				  &data->flags);
+				&data->mbox_work)) {
+			clear_bit(BTINTEL_PCIE_MAIL_BOX_INTR, &data->flags);
+			clear_bit(BTINTEL_PCIE_MBOX_PARSE_PENDING, &data->flags);
+		}
 	}
 
 	/* Mailbox is read, ack to FW */
@@ -1347,6 +1375,12 @@ static void btintel_pcie_msix_gp0_handler(struct btintel_pcie_data *data)
 	if (submit_rx) {
 		btintel_pcie_reset_ia(data);
 		btintel_pcie_start_rx(data);
+
+		/* Complete the mbox<->alive handshake */
+		if (test_and_clear_bit(BTINTEL_PCIE_MBOX_PARSE_PENDING, &data->flags)) {
+			set_bit(BTINTEL_PCIE_MBOX_PARSE_READY, &data->flags);
+			wake_up(&data->mbox_parse_wait_q);
+		}
 	}
 
 	if (signal_waitq) {
@@ -3345,6 +3379,8 @@ static int btintel_pcie_probe(struct pci_dev *pdev,
 	init_waitqueue_head(&data->tx_wait_q);
 	data->tx_wait_done = false;
 
+	init_waitqueue_head(&data->mbox_parse_wait_q);
+
 	data->workqueue = alloc_ordered_workqueue(KBUILD_MODNAME, WQ_HIGHPRI);
 	if (!data->workqueue)
 		return -ENOMEM;
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index 81f1abd14f359..a7573b377a3ef 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -126,7 +126,9 @@ enum {
 	BTINTEL_PCIE_FWTRIGGER_DUMP_INPROGRESS,
 	BTINTEL_PCIE_RECOVERY_IN_PROGRESS,
 	BTINTEL_PCIE_SETUP_DONE,
-	BTINTEL_PCIE_MAIL_BOX_INTR
+	BTINTEL_PCIE_MAIL_BOX_INTR,
+	BTINTEL_PCIE_MBOX_PARSE_PENDING,
+	BTINTEL_PCIE_MBOX_PARSE_READY
 };
 
 enum btintel_pcie_tlv_type {
@@ -179,6 +181,7 @@ enum btintel_pcie_mbox_msg {
 
 /* Default interrupt timeout in msec */
 #define BTINTEL_DEFAULT_INTR_TIMEOUT_MS	3000
+#define BTINTEL_PCIE_MBOX_INTR_TIMEOUT_MS	500
 
 #define BTINTEL_PCIE_DX_TRANSITION_MAX_RETRIES	3
 
@@ -587,6 +590,11 @@ struct btintel_pcie_data {
 	u32	debug_table_size;
 	struct btintel_pcie_dump_mem_info	dump_info;
 	struct btintel_pcie_mbox	mbox;
+
+	/* Wait queue for mbox_worker to wait for GP0 alive interrupt */
+	wait_queue_head_t	mbox_parse_wait_q;
+	/* Timestamp captured in GP1 handler when mbox interrupt is received */
+	ktime_t	mbox_intr_ts;
 };
 
 static inline u32 btintel_pcie_rd_reg32(struct btintel_pcie_data *data,
-- 
2.53.0



