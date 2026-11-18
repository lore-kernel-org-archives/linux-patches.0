Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036825;
	b=NZgrmJJP1QMhWBHLJXbtAeYeQfZ+gPF0UvaT1PLgd4Jagn1Xl6U+sMAgFuLRiYkR1lKa
	 CXTNSTlF1pFvTZpmSRJVTLptrseWpr+imIuMO9OV2p+2R+BmOvuMbmioFXr6v4K1dVuNE
	 TyvyhgNRD47l6yJ8Jic6g15YrXwJY6TonqluT1hn1+twf+R4MaRZN+jJ4ybix6IFwtyMi
	 I45h9lMjS0VT7/GdCYAY+j48lfp9D4cTIS1XxqHHUsGiB/SZIu4+kXZncWm7nh72VXp+v
	 vGGdsnFZBBNAa6JUKcqJCWqX3V4BJWLoAP4aCZBxQsbWHw3a8SH48XfvEYVTKX8R8Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9KIsksEhBLKx6PB9cBwlqID73D96weGSd3BeTr1A6E=;
	b=Gn3jFe6g15OFINVCMNR/OK/NQMe38Kp0DGlkW83eNv3Cv8LxRF7tm22stUEcraUZ+UOH
	 IrC/k9KGfR+zXZ1/N06fAOLcHZ2Y+0UyzPitw1lzCXnfhj2MP/xsT+SK7HEPHSzDh+uHI
	 5FKKRZnWaJ01f8GiAX48cCDEf4QI6+YXtYBEg8ZL/cJrJMFno5k+yKx0E+lH+XSDkeN5U
	 nTwMnNAkf6dcYa3cACmCQNCQuRQQSL19EbALOusCFvsxyQFGADh8e1EfHjrbb/bWgMGYr
	 AsSNSNCUaeyZTSPORuP22NXF7F24dkAtmcw0twmigVYD7GzDlWV3z2Bj77VS84uowbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ff0qTbHj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4871D606A31C;
	Wed, 18 Nov 2026 21:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ff0qTbHj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC2A1F000C4;
	Wed, 18 Nov 2026 21:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036825;
	bh=y9KIsksEhBLKx6PB9cBwlqID73D96weGSd3BeTr1A6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ff0qTbHjG4djb6I681YSNUPFXPa8yZB4VlqhkyA2PJ2YhlvNLVtpIF/TbHaI726hT
	 YCKCAVPr19KBA5w+s5U74ADkOeHr3frVkf9GgQNxNLi2wBzqDDTQ4hR7Zzr7KfBuQ8
	 ar/agx4jJ4txnW/lNjVKHjv/Sf2i13RH75GN96p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1195/3318] net: wwan: iosm: validate msg_head before indexing msg_ring
Date: Wed, 18 Nov 2026 15:30:17 +0100
Message-ID: <20261118150356.020394531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



