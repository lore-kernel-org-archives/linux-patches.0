Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033789;
	b=DdOLVeaseGtp5DQOXNAX8WhjVoB4Q4ptpyBl36BdSOHFM5U7B8TRcJenGZZVmHU/1tnM
	 QJn/LUmvXNTR2FqV3VYXYYboe6UZQmbZ/uXIgOwXwrmOS2DkLrSG4Me7aVBdJaM2bQeDZ
	 9rAGJx8E7Gwn8TgffhUGlWrhygQGnqmnES6Ko8ew6YKD0IhSKbUgxbjxqv81zspalCmdE
	 W4g6x35U5fU6qPf0hlWV1MXtmXIUdRlkL+vWDj92OumXBkDid7AFgWh3oLKbHkE5hUfAe
	 HL04kceMoudy/pmbhsmK+HDz8BauJ82QBci3flSqnKTk2LibljYiWGiAIGhHnfo8i1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEY4eZ07lDnVjDjxjAaJ8xLoRKyfnponPUWbaaADLfQ=;
	b=HZOqr7KsCbC+AiP2hHdVK1ksp3zgoz7NyVr+0UQgY+fPL8N8+yZSVkbBu4LOScOXN8KE
	 LlX/Lyy84yJFOHEGAZGa3sMk/TpOwGmqfDoRZqUmqQB/mc9ocZB4hq++5pzsMgtPYAnWD
	 KhgMsqpq9sYlJ7KRXz/xiWB9H7fepTDnFbjPfSVreTkAcXBCZd4JUxOQ95S6SSa30nPMK
	 zw9sK5/1wTb2pP0EaGaxLDJNdj4C6NHck9FA8+hcOWUrDaoGqVWGb94TCEIHY7J5u2Wc2
	 GxPY2gWzTDP82Oy77bq5gylbmAGpFFCahUGjDiyi9pEb57kJO72PQbv+Q/qdflWDTzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVhg2RLa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F055606A31C;
	Wed, 18 Nov 2026 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVhg2RLa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F551F000C4;
	Wed, 18 Nov 2026 20:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033788;
	bh=YEY4eZ07lDnVjDjxjAaJ8xLoRKyfnponPUWbaaADLfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVhg2RLahXidpUfRakVsQQc4NBv0x06WVk0H6TWhY7RNpgZS4zg0vbfknt0Us/LOj
	 xoyAg7AHW0cMvBEQyvRxZxis9cSSoesKoZ7e7DV2ol2Fctyhmx9gbpvovQXglTV38E
	 v6FEGOVoYTwvr7bkVjritR7DOHJfrkuOXwlmKDdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0139/3318] misc: ibmvmc: reject oversized inbound messages
Date: Wed, 18 Nov 2026 15:12:41 +0100
Message-ID: <20261118150318.615764612@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 18189e5d84aa0b3bc89189cba13b9105634cb6fb ]

ibmvmc_recv_msg() trusts the message length from the CRQ.

It passes that length directly to h_copy_rdma().

The destination buffer is only max_mtu bytes.

A larger length can overrun it before userspace reads the message.

Validate the CRQ length before issuing the RDMA copy.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624175139.7981-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ibmvmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index 06eae39bfafe5..e881f326b1025 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1661,6 +1661,13 @@ static int ibmvmc_recv_msg(struct crq_server_adapter *adapter,
 		return -1;
 	}
 
+	if (msg_len > buffer->size) {
+		dev_err(adapter->dev, "Recv_msg: msg_len 0x%lx exceeds buffer size 0x%x\n",
+			msg_len, buffer->size);
+		spin_unlock_irqrestore(&hmc->lock, flags);
+		return -1;
+	}
+
 	/* RDMA the data into the partition. */
 	rc = h_copy_rdma(msg_len,
 			 adapter->riobn,
-- 
2.53.0



