Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045711;
	b=0uaElBwAeok5rtnY3N102hHQrE8ZTlo5F0xtU+GqdQ7n4qmZ40Itg5XVgesyNsHXElEy
	 rOX86LeqauaI8MpRR0PpWIwiei/8dyXE0P8jP0ybkvN1j1nYHQgPUfp/Y2DlEzpo4btXL
	 8Zb01t/vauKd6Zs4aFxL2n9M3r679Pn64cq0OHXc0iXCmgNWAhP6A7rFcIEbPy+cuoOyq
	 c+vpZsQPdw92BxhnQ3jVmEAJVl3UCRh4/BXzPExJomiAn7NZhi5YocT/ggzbBuY4TEvFt
	 Zvhs1Cc4DK+tmW/O4II+rr0LNfi2Jz5U1iXxttMOZ+HY8EueUrrpBuNf11d+RPjxrSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xa1WVW9FQ0j9dGreVirm/ZxPv7HcSUCqtlCNVWcHnRA=;
	b=AhUwK6zZ6nQj9ylHUY6+FTYlsODg4jFk40M3biRjeaXIpbClDXdhcC40zdxMElCdPRZT
	 en4Rw/JKxsPPKeZtvkQdgHJCe/gUgIpXeUHzvOlU8m+ltdvrqIbMocG6+BC/Iss0oYgsW
	 +2zGWgpa9P+P/CKJhbheqt/5MI5IBWhOuRwLQp+KgpHQvfQUAMgWIVj1fAxi4lC4X8JS7
	 arG/FGn8MdQpl6sBLoLi4EZO+0XGCyznS84Rp/wEb/68HB0yGMmfsEgInfKZIuh6HduYX
	 qbzmuO2pq+riqnbnMFvEFeKHCecFdZdp49i3I51Nw2+GvEmweXxqoiD22ZOHjz7oh9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAYrh5UF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC10E606A31C;
	Wed, 18 Nov 2026 23:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAYrh5UF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494681F000C4;
	Wed, 18 Nov 2026 23:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045710;
	bh=xa1WVW9FQ0j9dGreVirm/ZxPv7HcSUCqtlCNVWcHnRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAYrh5UFvkIt1tZMc8o5nEKGl9aK1ym+TxScXZpUsfrXEEbqzpWQswM2ReyZ34G5l
	 G/iuFHNzy7Ce+w+RlA9McNqEzaIiQ8t/mJGF612M/960Wv05epwLJmH91t7afh6SwX
	 oZS9t4i8l+sn77dIRdcBS4M0JimYUPYNiXzkF8Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1020/2857] net: wwan: iosm: validate msg_head before indexing msg_ring
Date: Wed, 18 Nov 2026 15:34:14 +0100
Message-ID: <20261118150238.325232493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



