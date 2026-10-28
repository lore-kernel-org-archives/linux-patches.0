Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217303;
	b=UvNK/JQzR7qUUWqlKM+sFuRmQLNJQXpn6hPQB/cbXTNYzx3/OWhABRG4TyzFAysNjGvc
	 DY0m70YbqIzeuK7TLkEC2amzMAI6q1jQ7VhbAEoblcQ+q92FnCDYs5RtdJOeijD1NWXgb
	 KIEC0/Sj1cnVW/uwUX8dZBzrOWUurD/TLggvBKWLV2nNADrwNy5gicJ8ELM3erht3nyG1
	 WNUlrjsN/W9UOZak9fY4VdmeCZ0W5WwnrMfCkQSs3u8XFBwlFQ7EdhFZow2IH/D0V3xFH
	 tGLs43ib+bq7VoNqC8ml6rEXZTjF7kD6zTsiBd53lfDObKJ0v0bIutLk5oiEtIW1XqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QrXanMwDe5Zm9Ml+HXL1u4ct1wt45CSHXjBOIlgNwKQ=;
	b=taTwei7s3qPDAAikKlhdumxOKolb3ZfDHIRSYdDY1q047yv3DlyG24fKEO7nh+vDrcq2
	 eV91lCtEGW2vHzJHnqrQBwsYhaCaqCqRhPvGzPr+RD6JsyOcdQ3gC8ztZWYZPfmlufqkK
	 AnZQ8kB1Qdk1RuGX8J1TtsMCd0iw8kzQcZgat8UxRA9dZUuLxhvnsxvE2Ga89Q0X4CXYe
	 G134f1cu+wAJqQoq2SOHkDjS04rLBI4e9b00g8/K9bg/ezg2ncPgJU2m8Qj0z4JKCygXi
	 Qvw0oJ6txpCV5jQuB++JrYNqjRRgVeperLIJywvGR+IEGEwTWC9AdBusKRg+rOF6DTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVaKH3kE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20C9606A31C;
	Wed, 28 Oct 2026 19:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVaKH3kE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6EF1F01828;
	Wed, 28 Oct 2026 19:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217302;
	bh=QrXanMwDe5Zm9Ml+HXL1u4ct1wt45CSHXjBOIlgNwKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVaKH3kEkNOqnRwcBeQKcPaIP2KVRzq127Wtdzsbu7UvQjX42f+YjhGRtc27LLJOo
	 N89V9aAcW8upNn6sCAeG3mSai2u9V4RGoQqn9lU1QEOzc28CTUC25He2LO86p/vdWq
	 Hkci9M+Sf5X1AmiPYeldLnr8fy6BI26tzY9y53U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1857/1887] Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete
Date: Wed, 28 Oct 2026 18:05:53 +0100
Message-ID: <20261028170541.711563710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e8785404de06a69d89dcdd1e9a0b6ea42dc6d327 ]

There is a BUG: KASAN: stack-out-of-bounds in set_mesh_sync due to
memcpy from badly declared on-stack flexible array.

Another crash is in set_mesh_complete() due to double list_del via
mgmt_pending_valid + mgmt_pending_remove.

Use DEFINE_FLEX to declare the flexible array right, and don't memcpy
outside bounds.

As mgmt_pending_valid removes the cmd from list, use mgmt_pending_free,
and also report status on error.

Fixes: 302a1f674c00d ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/mgmt.h |  2 +-
 net/bluetooth/mgmt.c         | 26 +++++++++++++++-----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a4b1664d0db41..c7b5a517ac54f 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -845,7 +845,7 @@ struct mgmt_cp_set_mesh {
 	__le16 window;
 	__le16 period;
 	__u8   num_ad_types;
-	__u8   ad_types[];
+	__u8   ad_types[] __counted_by(num_ad_types);
 } __packed;
 #define MGMT_SET_MESH_RECEIVER_SIZE	6
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 655b260c5bb06..50ac226fbde41 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2157,19 +2157,24 @@ static void set_mesh_complete(struct hci_dev *hdev, void *data, int err)
 	sk = cmd->sk;
 
 	if (status) {
+		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
+				status);
 		mgmt_pending_foreach(MGMT_OP_SET_MESH_RECEIVER, hdev, true,
 				     cmd_status_rsp, &status);
-		return;
+		goto done;
 	}
 
-	mgmt_pending_remove(cmd);
 	mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER, 0, NULL, 0);
+
+done:
+	mgmt_pending_free(cmd);
 }
 
 static int set_mesh_sync(struct hci_dev *hdev, void *data)
 {
 	struct mgmt_pending_cmd *cmd = data;
-	struct mgmt_cp_set_mesh cp;
+	DEFINE_FLEX(struct mgmt_cp_set_mesh, cp, ad_types, num_ad_types,
+		    sizeof(hdev->mesh_ad_types));
 	size_t len;
 
 	mutex_lock(&hdev->mgmt_pending_lock);
@@ -2179,27 +2184,26 @@ static int set_mesh_sync(struct hci_dev *hdev, void *data)
 		return -ECANCELED;
 	}
 
-	memcpy(&cp, cmd->param, sizeof(cp));
+	len = cmd->param_len;
+	memcpy(cp, cmd->param, min(__struct_size(cp), len));
 
 	mutex_unlock(&hdev->mgmt_pending_lock);
 
-	len = cmd->param_len;
-
 	memset(hdev->mesh_ad_types, 0, sizeof(hdev->mesh_ad_types));
 
-	if (cp.enable)
+	if (cp->enable)
 		hci_dev_set_flag(hdev, HCI_MESH);
 	else
 		hci_dev_clear_flag(hdev, HCI_MESH);
 
-	hdev->le_scan_interval = __le16_to_cpu(cp.period);
-	hdev->le_scan_window = __le16_to_cpu(cp.window);
+	hdev->le_scan_interval = __le16_to_cpu(cp->period);
+	hdev->le_scan_window = __le16_to_cpu(cp->window);
 
-	len -= sizeof(cp);
+	len -= sizeof(struct mgmt_cp_set_mesh);
 
 	/* If filters don't fit, forward all adv pkts */
 	if (len <= sizeof(hdev->mesh_ad_types))
-		memcpy(hdev->mesh_ad_types, cp.ad_types, len);
+		memcpy(hdev->mesh_ad_types, cp->ad_types, len);
 
 	hci_update_passive_scan_sync(hdev);
 	return 0;
-- 
2.53.0



