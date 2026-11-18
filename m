Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054740;
	b=1Jw7vFiV/V8k+u7sXExrFIlqlJpMlMPeSu+QELrTBd0+p1L8eG7Gx1i5ZIP6Kwt4wQ7F
	 W1a5gDfCRfm2O6GLzgz4/pUHsBJwIP3uAs5MhUHrxtMPe1wxfiLJYaRQgNks3OHYxH62Z
	 izGMyGUORCCfH8RHSgHoYvuIOC0EX89r6cZ0HpE+oMxaTQ2X5l5z6rpMZBGmfm0oLrjqQ
	 YK1TH5w8CIf/l21uZUG3jvvGQmLha6+/LwFxAPUN1EheyPcyvnlf+0D1SwKf58QRrnZUV
	 vKag6u5hYEEx2/t+xLUCMTxx7tPgkZj2k60/0tyFYNIjUiKBO7D5p5HjzlQkadTb2kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GVoZQM+No8Ln3tySMUP9En1EPEFhugA+QIZiXX+nI6Q=;
	b=A9NsNoPzTEzRr6mAPOI+CqYVVkBdaECVqYe2MVGRhuXXDUrtvzUCgo+RRDJFGWhBBOsL
	 sWeIZd7WZobcduj8Lu1ObaYqLZZSAGR/SPiVJ2uJvOfkPJGzwpzgcef4/nTpt9eFuxKxD
	 kj3jpFMy+dIyRmRCERJ2n+k43DNMnrkXujWCZ99gyZvimomo42Edyv37v62Zsfs++rGn1
	 x7o4GtK/4oCTEUebHeOdeDBZJ20msJPnxYntqzWXLYEMlFFOF3BrEG0N+uMaetmFVq4wq
	 K/4W9w2koxdiKaK0r+wByWUam5OsHLb7IhCreqNZkWN5YK+Vz8OV/aFJ28ocq2zOtZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gw4yBLk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5585606A325;
	Thu, 19 Nov 2026 02:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gw4yBLk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25E21F000C4;
	Thu, 19 Nov 2026 02:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054740;
	bh=GVoZQM+No8Ln3tySMUP9En1EPEFhugA+QIZiXX+nI6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gw4yBLk9JfpFkGSTjenUL13glhubppHZecUJEZvdepndbSr89XS+Jv0hWNiSjz9k4
	 MmZfoCeNUy2y3pQFlF8yWh3cn6WOx/WSsBOeYKKzNhzVhS0ln/WPOyfQp6Kmu2Bx2r
	 v7/XB97OR2Da5DaCXly0qyDkiVvfKFIxYppevJis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1375/2214] fs: dlm: add debugfs rawmsg send functionality
Date: Wed, 18 Nov 2026 15:50:51 +0100
Message-ID: <20261118150106.403590547@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 9af5b8f0ead7cd90161b0555ed8e85ee38f79fa5 ]

This patch adds a dlm functionality to send a raw dlm message to a
specific cluster node. This raw message can be build by user space and
send out by writing the message to "rawmsg" dlm debugfs file.

There is a in progress scapy dlm module which provides a easy build of
DLM messages in user space. For example:

DLM(h_cmd=3, o_nextcmd=1, h_nodeid=1, h_lockspace=0xe4f48a18, ...)

The goal is to provide an easy reproducable state to crash DLM or to
fuzz the DLM kernel stack if there are possible ways to crash it.

Note: that if the sequence number is zero and dlm version is not set to
3.1 the kernel will automatic will set a right sequence number, otherwise
DLM stack testing is not possible.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 7bf1aca6d626 ("dlm: validate lock modes in recovery messages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/debug_fs.c | 37 ++++++++++++++++++++++++++++++++++++
 fs/dlm/midcomms.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/dlm/midcomms.h |  2 ++
 3 files changed, 87 insertions(+)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 47e9d57e4cae3..555904eeea8ea 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -768,6 +768,42 @@ static int dlm_version_show(struct seq_file *file, void *offset)
 }
 DEFINE_SHOW_ATTRIBUTE(dlm_version);
 
+static ssize_t dlm_rawmsg_write(struct file *fp, const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	void *buf;
+	int ret;
+
+	if (count > PAGE_SIZE || count < sizeof(struct dlm_header))
+		return -EINVAL;
+
+	buf = kmalloc(PAGE_SIZE, GFP_NOFS);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, user_buf, count)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = dlm_midcomms_rawmsg_send(fp->private_data, buf, count);
+	if (ret)
+		goto out;
+
+	kfree(buf);
+	return count;
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations dlm_rawmsg_fops = {
+	.open	= simple_open,
+	.write	= dlm_rawmsg_write,
+	.llseek	= no_llseek,
+};
+
 void *dlm_create_debug_comms_file(int nodeid, void *data)
 {
 	struct dentry *d_node;
@@ -782,6 +818,7 @@ void *dlm_create_debug_comms_file(int nodeid, void *data)
 	debugfs_create_file("send_queue_count", 0444, d_node, data,
 			    &dlm_send_queue_cnt_fops);
 	debugfs_create_file("version", 0444, d_node, data, &dlm_version_fops);
+	debugfs_create_file("rawmsg", 0200, d_node, data, &dlm_rawmsg_fops);
 
 	return d_node;
 }
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 8e97da3555c57..ae71f13c91e4f 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1434,3 +1434,51 @@ int dlm_midcomms_close(int nodeid)
 
 	return ret;
 }
+
+/* debug functionality to send raw dlm msg from user space */
+struct dlm_rawmsg_data {
+	struct midcomms_node *node;
+	void *buf;
+};
+
+static void midcomms_new_rawmsg_cb(void *data)
+{
+	struct dlm_rawmsg_data *rd = data;
+	struct dlm_header *h = rd->buf;
+
+	switch (h->h_version) {
+	case cpu_to_le32(DLM_VERSION_3_1):
+		break;
+	default:
+		switch (h->h_cmd) {
+		case DLM_OPTS:
+			if (!h->u.h_seq)
+				h->u.h_seq = rd->node->seq_send++;
+			break;
+		default:
+			break;
+		}
+		break;
+	}
+}
+
+int dlm_midcomms_rawmsg_send(struct midcomms_node *node, void *buf,
+			     int buflen)
+{
+	struct dlm_rawmsg_data rd;
+	struct dlm_msg *msg;
+	char *msgbuf;
+
+	rd.node = node;
+	rd.buf = buf;
+
+	msg = dlm_lowcomms_new_msg(node->nodeid, buflen, GFP_NOFS,
+				   &msgbuf, midcomms_new_rawmsg_cb, &rd);
+	if (!msg)
+		return -ENOMEM;
+
+	memcpy(msgbuf, buf, buflen);
+	dlm_lowcomms_commit_msg(msg);
+	return 0;
+}
+
diff --git a/fs/dlm/midcomms.h b/fs/dlm/midcomms.h
index 1a36b7834dfc5..6bcfd84591834 100644
--- a/fs/dlm/midcomms.h
+++ b/fs/dlm/midcomms.h
@@ -31,6 +31,8 @@ const char *dlm_midcomms_state(struct midcomms_node *node);
 unsigned long dlm_midcomms_flags(struct midcomms_node *node);
 int dlm_midcomms_send_queue_cnt(struct midcomms_node *node);
 uint32_t dlm_midcomms_version(struct midcomms_node *node);
+int dlm_midcomms_rawmsg_send(struct midcomms_node *node, void *buf,
+			     int buflen);
 
 #endif				/* __MIDCOMMS_DOT_H__ */
 
-- 
2.53.0



