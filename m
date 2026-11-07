Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065221;
	b=qJpbYQvhog/OQAfb8tsyvmLDXePSBxQs8ACLe7Y660pPkAgkWCPdRjg1bk+ZiB/HO4WL
	 GtYj4g2VaP0oL91Ngw2/DfaalKeHAcv+g4Rc6RSTSFQN3+tjorEaR/e0drBuWcTAlkjXM
	 4+FyOl7G/Yca6aYp3mqYxUGMR7Firc3UDYhQkZ2eYXwDdGGB71jArUmKWpeYSiePosXTk
	 poK3zW20od32JeLXlX1gQQMvx5rwMbwaEO1lMrqtZtYXy5uv32yucPaxHAqQfA45r8m6Q
	 kio+lcE/mSzRIcQdQmBG851Gcz19KLBBzW6D5ZZR1RieEQCDjpsjuV1pc7DCTHCXYOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HNGFmNr1u/gQnTBwr3AnnvIceE8/w45AV/CxfAcMKPQ=;
	b=BQKURnPO6alct1jXL5fM4zlZR+c/l4XWK30BskRaOewtC/o5nxx7fsiwxyjsAN0JwGAZ
	 PPmd3QBwdAi0KySmxN9CLZtbmSDpFrNyBvAJhhQd/J5ZAHDrdicYUdV7/PUGbqRQK2ZLx
	 NVYiWRypLk2PBx6Rbb6vH1wV2amvuEgMUos+2gvuYfSX00fUZ7KsuSpW/Yd9lcAEDS/lz
	 W5nhKVw/JSZTyOK1VScNzTsbpHH0AhY174+PbXYu7SON6vQT46TgBpN3HMC7xeocYmDZZ
	 iTk7psE7kLSh8zfRjTjFiaJ3y180//2TO5ke8gHAyPyWoX4Vczuht+Q4YgYG2uKtxMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HS48yKt0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F4B606D801;
	Sat,  7 Nov 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HS48yKt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E311F0089F;
	Sat,  7 Nov 2026 15:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065220;
	bh=HNGFmNr1u/gQnTBwr3AnnvIceE8/w45AV/CxfAcMKPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HS48yKt0pLS12ALilA/DQgtEVTT7Y3Hp6AXv9K+8IQ5RBjUtrh5RPIlXh76BpGfbq
	 wJLTffKdFUm7EbaBXxp/DapXjRZffmbnDlH08YvR5viF3leZLYhShl8dFtXO3uA0fG
	 3VsTIYWsXgWWyIBoE6+hHq91wKTFXo+mgvj6aIcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1013/1257] net: wwan: iosm: validate msg_head before indexing msg_ring
Date: Sat,  7 Nov 2026 08:55:09 -0500
Message-ID: <20261107135007.315589442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index f2f86f41fd10e..004920068c45b 100644
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



