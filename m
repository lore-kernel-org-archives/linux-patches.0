Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063579;
	b=zwu3nRithdJsFhfazoVWFoJLwXagsR2JXe1TN6sCtyPGZZjEZrfl3IagFP8L+5+J4PRp
	 /5m/hRfFuhzFQGwH3bMdrNppoSP/ld5d7WbtafUkfPOFn8MQUpyQs9ti2UepBmFUxoHqk
	 HIB9j6x+T/BZM9BWQrKIXQ4NCRaqzDH/NejvQwwJlN+k6gM/XNYputdSa/4XjPxMEsb/k
	 4V7OK3a1nnWO5N0mUlTwpzElTYUMVmmqhJIl7b8ATK65ZYOs9Oy7W/wkwiZrFpgNV57xc
	 ST9n6VEszbRlkXKrsv/T5mwYRsdlEAFr+9/mNzqF2MEEnW6wFnEXuAKkJ6YF5iM2gwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xw9ZwWMa7Xc6YF8mkhgGTxt1trJH/F59+BRdqNrYnoQ=;
	b=iNsn1MQ6Wo7gr4/wEA0CJWDg8fDTvWMhMFVyfDWFgcpWkJmgsGHlJ95Uxhfr/BHk4FGO
	 VpNhF4VVY9wNqUfzexfkmf6LtC+zL7q3SfaA+ByHl+RMfH54sPfKWlgRJ4p3zNqSoKmpR
	 OUkZQT03BXnXAHa3A8HJXC7SWN47nE/r1FR53FXzAkqkRQMNrZrd94akUh9hKAsOsmYOe
	 K01lJBjVVx3CSQVlvbAeNcu+weYykAgGKJhTlRCgShOjmms4Z8BQ95Mwf/6kdJ7qQ0IS9
	 57Pa+TAcvdXOwabsqujwwh6NE/RFWknLgEMqvhlNOGDlSibKHEikZlAnUE3yy2+fstQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHOi0hXF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3460A2634;
	Sat,  7 Nov 2026 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHOi0hXF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B01F008A2;
	Sat,  7 Nov 2026 14:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063579;
	bh=xw9ZwWMa7Xc6YF8mkhgGTxt1trJH/F59+BRdqNrYnoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHOi0hXFfFxI7cdRqNd6XVSi3dyiORrr7tqLTGOhyNRp5Nb0uRmZ1zp2JpDr/4BhX
	 b8hWbqODa70/d0fGCUcEiA8665TDir4gqmWagd/nw8HAkpn0L0g5X7MGn7we5Xmw6E
	 KovBxep6SX3tZjzVQkL5/JUFaOc8siNHD6LW6a+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 708/869] net: wwan: iosm: validate msg_head before indexing msg_ring
Date: Sat,  7 Nov 2026 08:56:30 -0500
Message-ID: <20261107134916.906186252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Liu Chao <liuc63@xiaopeng.com>

[ Upstream commit 46cbf85155e5451b6682ea0c17bc62ec564aec36 ]

ipc_protocol_free_msg_get() reads msg_head from shared memory and
uses it directly as an index into msg_ring[]. If the head is out
of range, the subsequent memset() writes beyond the message ring.

Validate head against IPC_MEM_MSG_ENTRIES before using it as an
index. The ring is a circular buffer, so a value outside the valid
range indicates a corrupted head pointer; report the error and fail
the allocation instead of writing out of bounds.

Fixes: 64516f633bfd ("net: iosm: protocol operations")
Cc: stable@vger.kernel.org
Reviewed-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20261020094254.4017726-1-liuc63@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index 4627847c6daab..455b3b6f09917 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -14,6 +14,11 @@ ipc_protocol_free_msg_get(struct iosm_protocol *ipc_protocol, int *index)
 	u32 new_head = (head + 1) % IPC_MEM_MSG_ENTRIES;
 	union ipc_mem_msg_entry *msg;
 
+	if (head >= IPC_MEM_MSG_ENTRIES) {
+		dev_err(ipc_protocol->dev, "invalid message head %u", head);
+		return NULL;
+	}
+
 	if (new_head == le32_to_cpu(ipc_protocol->p_ap_shm->msg_tail)) {
 		dev_err(ipc_protocol->dev, "message ring is full");
 		return NULL;
-- 
2.53.0



