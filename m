Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058640;
	b=wBx0dGAVtBukWlHs2vxJQHnAZXPneOk34SF0nUfYgP1Z5osMiPFQRPTcWsSxRr894rMs
	 6YMHl4KRZfzsbxINrJVhqwFX803k6d5S1IyIg/ldC+kf/EJybxVU46fJLwaBfwPy8PMJr
	 vWQSAdBvCqDEay3P5aUM4bONEGlC2nPCuK4c3bjx63VApyquXTx4La/uJNb/zCjKcaWM7
	 lVySltJrPEXHBV0CW0kGJ2kXsA0fkWRUET29v0ZGwFtWf4yUFN0HzHtD7AxBwaA11Q2q2
	 1m0bTtfqBTatF/M/dma0PWZKhPCBMjhjuk01s5+F52hJMGDcnq/eYeXcLy/SlhFJyZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cXg1TI8ll/TBbQI9VqqA/Z19J8i4hWmtwGRHnfIrsAA=;
	b=1Ke51z1cU/zoEUTKdX9zQXr+AQlZc6c8LeF6m3+S5pQcRPpnGfM9u2xGO8JtQetR+U/0
	 //BatiQlW4HKemrUQoVGATOJyP+W43B7Os3v8KK8f+RIKn0yJ1FCUPmMbbxMGcG7n0860
	 hVaJQyo4YqOZfGHX6JMUgnvdVqjpKsntzK5KNwsfGZliA/7WowY2nzlvSKYm01pNQc1z8
	 Du9WaZrulxRIE9lXPq6P5w7zoYqscwtMVE+cg5uzeA2dc/UyeXm3eijxSqa7+B4kyGlJS
	 KmgK1dG1Lv5+LXZDCSzYdHHTaD2Pm2k6njUeeXrQwe2LagwoyfVLUWUm9BN8Apuovwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IORH0+8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7B1606A32A;
	Thu, 19 Nov 2026 03:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IORH0+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5F81F000C4;
	Thu, 19 Nov 2026 03:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058640;
	bh=cXg1TI8ll/TBbQI9VqqA/Z19J8i4hWmtwGRHnfIrsAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IORH0+8dQOc8E9xEigO5oDhnlYKVc1FmzJJeRoXfiu33uIiYX3il1v7XaVKzBWud
	 QW+2r+RCMyCAamZtHgKFgqwmWa54JsovGNM6Qkdovemth+7yqTsN+VY1c4Rt/9g+c4
	 6axLfUN2ktY6+qsZ7sjAOBQkUocuGI9FCdOmInOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sungbyeongchan <tjdqudcks0424@naver.com>,
	Giovanni Vignone <gio@octane.security>,
	Robert van Eijk <robert@octane.security>,
	Paolo Gentry <paolo@octane.security>,
	Shubham Antil <shubham@octane.security>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0531/1848] RDS/IB: validate receive fragment completions
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118145937.188448549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubham Antil <shubham@octane.security>

[ Upstream commit 65cf6863606b0507a7c3bd1711317e4f5d6b8b7e ]

rds_ib_process_recv() accounts every receive fragment as contributing
min(i_recv_data_rem, RDS_FRAG_SIZE) bytes, regardless of the completion
length. When a completion is shorter than the header-declared amount,
receive accounting can advance beyond the payload supplied by the
completion.

Only an IB_WC_RECV completion has the buffer layout expected by this
receive path. Other successful completion opcodes must not be interpreted
as ordinary receive completions.

Reject successful completions with any other opcode before processing
their length. For ordinary receive completions, require enough payload
to cover the amount accounted to the fragment before linking its page
into the incoming message.

This is compatible with the current transmit paths. MSG_ZEROCOPY is
restricted to RDS/TCP, while RDS/IB copied and page-vector messages use
full-sized non-final scatterlist entries.

Found during an LLM-assisted source audit and validated under KMSAN with
a malformed short receive completion.

Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@naver.com/
Reported-by: Giovanni Vignone <gio@octane.security>
Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207e204.camel@kernel.org/
Reported-by: Robert van Eijk <robert@octane.security>
Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207e204.camel@kernel.org/
Reported-by: Paolo Gentry <paolo@octane.security>
Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207e204.camel@kernel.org/
Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
Cc: stable@vger.kernel.org
Signed-off-by: Shubham Antil <shubham@octane.security>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261013025729.40815-1-shubham@octane.security
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_recv.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 89aef2fffc1ed..6f8c55e49ea21 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -948,6 +948,12 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 		}
 	}
 
+	if (data_len < min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
+		rds_ib_conn_error(conn,
+				  "fragment shorter than header-declared length; forcing reconnect\n");
+		goto done;
+	}
+
 	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
 	recv->r_frag = NULL;
 
@@ -1003,7 +1009,12 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
 	 * event is processed.
 	 */
 	if (wc->status == IB_WC_SUCCESS) {
-		rds_ib_process_recv(conn, recv, wc->byte_len, state);
+		if (wc->opcode != IB_WC_RECV)
+			rds_ib_conn_error(conn,
+					  "recv completion had unexpected opcode %u, disconnecting and reconnecting\n",
+					  wc->opcode);
+		else
+			rds_ib_process_recv(conn, recv, wc->byte_len, state);
 	} else {
 		/* We expect errors as the qp is drained during shutdown */
 		if (rds_conn_up(conn) || rds_conn_connecting(conn))
-- 
2.53.0



