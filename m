Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C395B511E76;
	Wed, 30 Sep 2026 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792952; cv=none; b=uES97wM4mtelnGKjPZ33vyFE35qbzPYzW6KMXsjz33v2xV0aEVvEw4gkj1Im65BRs291lNtbRCBKipCDjOgbaVl0x73ffjiOjlM0v+vTX6U8cxHKUujwEP/jPGL9Ko0rlmISQOz/sreLQMLJT5ptMzI+IDuCmsZ0nGrXZgk4r9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792952; c=relaxed/simple;
	bh=VC0nq2pe+azu8UqFX0qnpiKWimMYQWLsvDrD5rnplbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgHS9XAUe0HiFmpTsKSos4mYF5C4j4SHw0iaa3Z2aWkh6VDZOp/MV1aC/YRFUfJd+uMCFzm/d92vLEKYq4jVUHD4pQrlESMalqlPAnkkp79lT8jZMfs/yUxapziRCmrHnPRO41UkGbWlVTvbS3PvC+e3ZwgSR9Uy8xfjT6Yoz8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSk7wIC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSk7wIC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9371F000FF;
	Wed, 30 Sep 2026 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792950;
	bh=+WYjF+8MRcZV24HjNIqIHGHToDkRqWbnshvwJwfLUos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSk7wIC9leLfr+ua8s8EwK34/Iyli455XOFIjA37drcktCp3D7n65D5secmcKJ4tY
	 5Mm8J80AY5C0ezbOeB2hdZ7TDQIsi/GV11sKtEqV0ivCGB0gWP/yuSL2UOqfvkC1Qs
	 ByKtqynOj2XK/RLEp2ZwLFqqmtUhO4D0fiR2r53s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/395] eth fbnic: Add debugfs hooks for firmware mailbox
Date: Wed, 30 Sep 2026 17:25:46 +0200
Message-ID: <20260930152342.460204388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn (Meta) <mike.marciniszyn@gmail.com>

[ Upstream commit ac7b803c2dd57938cbf1e9a3ada23471925a5d46 ]

This patch adds reporting the Rx and Tx information
interfacing with the firmware.

The result of reading fbnic/fw_mbx is:

 Rx
 Rdy: 1 Head: 11 Tail: 10
 Idx Len  E  Addr        F H   Raw
 ----------------------------------
 00  4096 0 000101fea000 0 1   1000000101fea001
 01  4096 0 000101feb000 0 1   1000000101feb001
 	.
 	.
 	.
 15  4096 0 000101fe9000 0 1   1000000101fe9001

 Tx
 Rdy: 1 Head: 4 Tail: 4
 Idx Len  E  Addr        F H   Raw
 ----------------------------------
 00  0004 1 00010321b000 1 1   000440010321b003
 01  0004 1 00010228d000 1 1   000440010228d003
 	.
 	.
 	.
 15  0004 1 00010321b000 1 1   000440010321b003

Signed-off-by: Mike Marciniszyn (Meta) <mike.marciniszyn@gmail.com>
Link: https://patch.msgid.link/20260127200644.11640-2-mike.marciniszyn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1b97a269a5bd ("eth: fbnic: Handle FW mailbox completions flagged with an error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/meta/fbnic/fbnic_debugfs.c   | 48 +++++++++++++++++++
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c    |  2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h    |  1 +
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c b/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c
index b7238dd967fe4..9cdd03bfec340 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c
@@ -170,6 +170,52 @@ static int fbnic_dbg_ipo_dst_show(struct seq_file *s, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(fbnic_dbg_ipo_dst);
 
+static void fbnic_dbg_fw_mbx_display(struct seq_file *s,
+				     struct fbnic_dev *fbd, int mbx_idx)
+{
+	struct fbnic_fw_mbx *mbx = &fbd->mbx[mbx_idx];
+	char hdr[80];
+	int i;
+
+	/* Generate header */
+	seq_puts(s, mbx_idx == FBNIC_IPC_MBX_RX_IDX ? "Rx\n" : "Tx\n");
+
+	seq_printf(s, "Rdy: %d Head: %d Tail: %d\n",
+		   mbx->ready, mbx->head, mbx->tail);
+
+	snprintf(hdr, sizeof(hdr), "%3s %-4s %s %-12s %s %-3s %-16s\n",
+		 "Idx", "Len", "E", "Addr", "F", "H", "Raw");
+	seq_puts(s, hdr);
+	fbnic_dbg_desc_break(s, strnlen(hdr, sizeof(hdr)));
+
+	for (i = 0; i < FBNIC_IPC_MBX_DESC_LEN; i++) {
+		u64 desc = __fbnic_mbx_rd_desc(fbd, mbx_idx, i);
+
+		seq_printf(s, "%-3.2d %04lld %d %012llx %d %-3d %016llx\n",
+			   i, FIELD_GET(FBNIC_IPC_MBX_DESC_LEN_MASK, desc),
+			   !!(desc & FBNIC_IPC_MBX_DESC_EOM),
+			   desc & FBNIC_IPC_MBX_DESC_ADDR_MASK,
+			   !!(desc & FBNIC_IPC_MBX_DESC_FW_CMPL),
+			   !!(desc & FBNIC_IPC_MBX_DESC_HOST_CMPL),
+			   desc);
+	}
+}
+
+static int fbnic_dbg_fw_mbx_show(struct seq_file *s, void *v)
+{
+	struct fbnic_dev *fbd = s->private;
+
+	fbnic_dbg_fw_mbx_display(s, fbd, FBNIC_IPC_MBX_RX_IDX);
+
+	/* Add blank line between Rx and Tx */
+	seq_puts(s, "\n");
+
+	fbnic_dbg_fw_mbx_display(s, fbd, FBNIC_IPC_MBX_TX_IDX);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(fbnic_dbg_fw_mbx);
+
 static int fbnic_dbg_fw_log_show(struct seq_file *s, void *v)
 {
 	struct fbnic_dev *fbd = s->private;
@@ -249,6 +295,8 @@ void fbnic_dbg_fbd_init(struct fbnic_dev *fbd)
 			    &fbnic_dbg_ipo_src_fops);
 	debugfs_create_file("ipo_dst", 0400, fbd->dbg_fbd, fbd,
 			    &fbnic_dbg_ipo_dst_fops);
+	debugfs_create_file("fw_mbx", 0400, fbd->dbg_fbd, fbd,
+			    &fbnic_dbg_fw_mbx_fops);
 	debugfs_create_file("fw_log", 0400, fbd->dbg_fbd, fbd,
 			    &fbnic_dbg_fw_log_fops);
 }
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 6edd01e58bf06..69b9bd03d00e0 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -40,7 +40,7 @@ static void __fbnic_mbx_invalidate_desc(struct fbnic_dev *fbd, int mbx_idx,
 	fw_wr32(fbd, desc_offset + 1, 0);
 }
 
-static u64 __fbnic_mbx_rd_desc(struct fbnic_dev *fbd, int mbx_idx, int desc_idx)
+u64 __fbnic_mbx_rd_desc(struct fbnic_dev *fbd, int mbx_idx, int desc_idx)
 {
 	u32 desc_offset = FBNIC_IPC_MBX(mbx_idx, desc_idx);
 	u64 desc;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
index 1ecd777aaadab..30e74ccd40e9a 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
@@ -92,6 +92,7 @@ struct fbnic_fw_completion {
 	} u;
 };
 
+u64 __fbnic_mbx_rd_desc(struct fbnic_dev *fbd, int mbx_idx, int desc_idx);
 void fbnic_mbx_init(struct fbnic_dev *fbd);
 void fbnic_mbx_clean(struct fbnic_dev *fbd);
 int fbnic_mbx_set_cmpl(struct fbnic_dev *fbd,
-- 
2.53.0



