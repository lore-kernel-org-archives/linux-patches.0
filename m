Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624357;
	b=PLc0+BcGyf8Kzha73EvXgNRSQZakAvjg+DgfmIh+97iO6r+y+3UXIEj45M7cBPmOdbrv
	 OAHo97a4C4eH851CjTuRkHVcZeaBUwPct+cdzSvefV4OCdDiqem0C2JivIASOp1fbn799
	 S/+suwkmSN+MsEpNqUZr15BeY8KjYCBnbWqZ3GU0/lBN832Qdg2mmGTVCgyn8r6pirw5X
	 5yl622ExwQ7X8XtXD2toVO//aXnu21uT+S1eQ+YXnJVCEp3sGBxnLSLKOuSjm7q/GJgX5
	 hsu/sJb6r7yvjHSliJ+QxYIrS0HYuBG+xH74RqmP/gVHvZmoRwZzKIJlDIHJ9WiiJ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bhUEet41Kvi3BaNVUtXawx/rRYsYNU2SGUOl09VMtJI=;
	b=hawmpJ3xjLF946ZwvM+kGIiG0Yf5GFj/+fOoTdPKV9yXGK6Kpf90tsSthsKfvsWLuLOi
	 LS4jdga+HwUK1PqYMJzrhVGP8Kk5W6hUQWJTZy9GEC/3gYNQrKgXKg5dY7H9kxvIxzn9P
	 EokFOgjhlf5Rn7jf7TmjwA5rVq2XeBYfebTkgj85/b71qd75nW/FRG5jlMYzySi+4OFTZ
	 lPjnEEZm5QzPzJYLnb9sI5ntZiKz1pt3wj1u3zICeurt+KxnhJGsWPWPwcVKzFxd223EI
	 LY8vxxZabinpyMf0Z+N73+2cttsF6KKQ4Hk4BuggcD6ZtpY8E0VMLsfybsILDnMhT9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyQksgNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86F0606A339;
	Wed, 25 Nov 2026 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyQksgNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74331F000C0;
	Wed, 25 Nov 2026 16:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624357;
	bh=bhUEet41Kvi3BaNVUtXawx/rRYsYNU2SGUOl09VMtJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyQksgNhSZodjJxK+LzLfGDeClzDIwwXudVBkxbfD8W1Txh3y7PHkXPAomnOgOIw1
	 x1dLgwuDFpYEHC4w2JaDpOWdgQQq9zx9NBkdioa270GMlXPyYCkC4fAo8fq9V5uHhQ
	 qDVi0PHGqDE+GOWlgeYMcgp+pMf2gQyDPWi6obVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/816] Bluetooth: validate retained LE Create CIS command length
Date: Wed, 25 Nov 2026 15:28:34 +0100
Message-ID: <20261125143853.037277194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

[ Upstream commit 1eb52f35fc8fb06ab7f2973fff29cba81f96b947 ]

hci_cs_le_create_cis() retrieves the parameters of the previously sent
command without their length.  It then trusts num_cis and walks the
flexible cis[] array when a controller reports a failed command.

A five-byte HCI command containing only num_cis can therefore make the
handler read beyond the command skb.  KASAN reports:

  BUG: KASAN: slab-out-of-bounds in hci_cs_le_create_cis
  Read of size 2
  hci_cs_le_create_cis
  hci_cmd_status_evt
  hci_event_packet

Add a length-returning saved-command helper and require the fixed header
and complete CIS array before walking it.

The reproducer no longer triggers a KASAN report with this change.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Closes: https://lore.kernel.org/linux-bluetooth/179317462624.87574.6271582002629080499@stu.pku.edu.cn/
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_core.c         | 18 ++++++++++++++----
 net/bluetooth/hci_event.c        |  7 ++++++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f846865db0ca4..b023f0870efaa 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2292,6 +2292,8 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb);
 void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb);
 
 void *hci_sent_cmd_data(struct hci_dev *hdev, __u16 opcode);
+void *hci_sent_cmd_data_len(struct hci_dev *hdev, __u16 opcode,
+			    size_t *len);
 void *hci_recv_event_data(struct hci_dev *hdev, __u8 event);
 
 u32 hci_conn_get_phy(struct hci_conn *conn);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index c8b4630bb5563..1ad2ea661e908 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3179,7 +3179,8 @@ int __hci_cmd_send(struct hci_dev *hdev, u16 opcode, u32 plen,
 EXPORT_SYMBOL(__hci_cmd_send);
 
 /* Get data from the previously sent command */
-static void *hci_cmd_data(struct sk_buff *skb, __u16 opcode)
+static void *hci_cmd_data(struct sk_buff *skb, __u16 opcode,
+			  size_t *len)
 {
 	struct hci_command_hdr *hdr;
 
@@ -3191,23 +3192,32 @@ static void *hci_cmd_data(struct sk_buff *skb, __u16 opcode)
 	if (hdr->opcode != cpu_to_le16(opcode))
 		return NULL;
 
+	if (len)
+		*len = skb->len - HCI_COMMAND_HDR_SIZE;
+
 	return skb->data + HCI_COMMAND_HDR_SIZE;
 }
 
 /* Get data from the previously sent command */
-void *hci_sent_cmd_data(struct hci_dev *hdev, __u16 opcode)
+void *hci_sent_cmd_data_len(struct hci_dev *hdev, __u16 opcode, size_t *len)
 {
 	void *data;
 
 	/* Check if opcode matches last sent command */
-	data = hci_cmd_data(hdev->sent_cmd, opcode);
+	data = hci_cmd_data(hdev->sent_cmd, opcode, len);
 	if (!data)
 		/* Check if opcode matches last request */
-		data = hci_cmd_data(hdev->req_skb, opcode);
+		data = hci_cmd_data(hdev->req_skb, opcode, len);
 
 	return data;
 }
 
+/* Get data from the previously sent command */
+void *hci_sent_cmd_data(struct hci_dev *hdev, __u16 opcode)
+{
+	return hci_sent_cmd_data_len(hdev, opcode, NULL);
+}
+
 /* Get data from last received event */
 void *hci_recv_event_data(struct hci_dev *hdev, __u8 event)
 {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 533a534d78867..e408c0e1d58bc 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4293,6 +4293,7 @@ static void hci_cs_le_create_cis(struct hci_dev *hdev, u8 status)
 {
 	struct hci_cp_le_create_cis *cp;
 	bool pending = false;
+	size_t len;
 	int i;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
@@ -4300,10 +4301,14 @@ static void hci_cs_le_create_cis(struct hci_dev *hdev, u8 status)
 	if (!status)
 		return;
 
-	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_CREATE_CIS);
+	cp = hci_sent_cmd_data_len(hdev, HCI_OP_LE_CREATE_CIS, &len);
 	if (!cp)
 		return;
 
+	if (len < sizeof(*cp) ||
+	    len < struct_size(cp, cis, cp->num_cis))
+		return;
+
 	hci_dev_lock(hdev);
 
 	/* Remove connection if command failed */
-- 
2.53.0



