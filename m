Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062564;
	b=2BeeECcq/OB7AYhNi5XwsoH4oGzURDAiPsLzbljWGEslTUlgJr1Zqx440aeqqKr/PKos
	 HBOS1Ps612giygo8EsHH+K/SSO8Gnu41LHc7cHg8EM3QazKvuPsXaeHJMO40Fc1XdEDv3
	 eEU8fCoky+gLbGXo+VFTVyh4atk4onfvbV6RSBNfhkyl2V9XyTyHeJZ7AWFUoN72F9RWr
	 0XH7QpTUXEAO55DB6eoLS7QTTvGEgtQ2bOusuLwydQ9uDdIVuzbNQgh3cMZbLpZVqn7pc
	 xTqIeaTQSdhx7pUrNma0MsewdjWRHqmxL/5n3mDVB0kDcDET9UlWhALno4tCdwoiImQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TUBDGUR9Cm2WVI83xFXRwmsXPuWfoM8HUfi2gsajJGo=;
	b=zjyQs4VvHvOv6HZi4c81IuJtpVODVkwrdnf35niaT3DfL/uDiZH35JxaLfytvMdcupiD
	 2F72NqYB7h2tjCzDeEjW3gtXKFUspjiQekFtRO8EVeolvQMAOiCf4iNpd9dic9QJC9Qdc
	 h/HcByvMMp/8VG4o75VVkYU7undl2UDssQ4fAQG+ETdbGXtTQXitC/GJj/N2xkCMUDS9o
	 zVen3vFcdsAw8NtGPdatVoQ45mQCYrLMMi75osNDal+EtENmDu2/4mzZBdZaMcwnYhLIY
	 8EHDQCPidipnWLakoW8G5rFo/J8jyWUBRROa2yaByZY4fq9jEfZwmyIekx3hWpaVCmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVmrCtDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7FE606A333;
	Sat,  7 Nov 2026 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVmrCtDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F11F008BC;
	Sat,  7 Nov 2026 14:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062563;
	bh=TUBDGUR9Cm2WVI83xFXRwmsXPuWfoM8HUfi2gsajJGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVmrCtDcpwTvbtpq43CNUAnteN5R3LmfKO3q/79cB9M03WZq5/xOgnlZKmXhPszba
	 ZDz0TZB+HC+s7FxCsKCWtOEx+SJ6iFU0vG1S+3y8ojuu7GsplggpdgC3HwnrRS+ZJB
	 +ef+UcOGkCxy+giGYr28mb2KH5W2BVMkLmAlAc+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1409/1536] net: wwan: iosm: validate msg_head before indexing msg_ring
Date: Sat,  7 Nov 2026 08:57:05 -0500
Message-ID: <20261107135037.395667501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



