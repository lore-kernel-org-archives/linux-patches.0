Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063498;
	b=FxkvBaOdWU5Ol6a3Y7WimVfpdWwpOA8ZgQ69JVKIm8iRYMB62MdjxQb5qiPPVHca+S1k
	 QDqTmg744K2Eo3/Gc4Qs1DULP4/Zo5PkmKuLo/ARuylG6QrurURkJKUfJu51kl3E/kBjF
	 3TpVmOStVAqSwIVAgj+57K0JYzvRC678Gy5dpKJrZUi7YWSx/DJhg1H9bCEa+K27M1TvK
	 zeMG4ljkIj5npqKUm6E+AArLip2LbI/Wr1OVRSSubD0xkpUvCZ12t9WePewyuE/0CFXDA
	 sUkeluEzIUe3OCXGxoUOVokyt/9A+t4uzmVby6UqsO2R+GEm4nBE1L71hmT7uOvPpcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N2AZnTCJVocI8LlnUxjLdsVWFUnS8GUlsN6AidjisF0=;
	b=CuQO+4P82hxPaY8ivB5ynK4tTiIEodZ7n7pzDdfV73ZZfF3HAjm9iHSPWg+5x44uHCzA
	 WoyN37U+40sYbljip4UJaHJfnESQqDxyyuGdzoEL79Vyl9/syO8KAtL6OXCnLKc95ypXZ
	 AT57xGT2OYFAj/oKY641BKMuRRo/UnP9Rd7WnnoE9L80T3qevrFj+S08kPC2o7gHpcnGf
	 Q8uKQmAbzmZPaWjnqrMQAiZC1A3APRryInvrXWdss+hCZDY+ppDUvRZ69Xr1ossiAIis8
	 Kk/481wdyuDcy/b6cK7gVn4cWVzlUjGJSzli44tAJyb8Ev+4zk6pAhezJJx+qZstUPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qiFQ2//O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC268606A339;
	Sat,  7 Nov 2026 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiFQ2//O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E161F008A1;
	Sat,  7 Nov 2026 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063497;
	bh=N2AZnTCJVocI8LlnUxjLdsVWFUnS8GUlsN6AidjisF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiFQ2//OQVbXwuCmp2gKKk8OEADqXPb9yLwjtg8pCF3YbiN9QdY0OvwVf6yWzj/Yw
	 eKCuQ8JMa+UmBYhPm9j7JvGYcIu2sRGjMGUHO9sdE3dbe1xRziwUquJBoBxtbFVeRk
	 BWEs+sNNGkb3ROBSoUZOMJtd6DyNYNTPHUid33PE=
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
Subject: [PATCH 6.18 605/869] RDS/IB: validate receive fragment completions
Date: Sat,  7 Nov 2026 08:54:47 -0500
Message-ID: <20261107134913.606627637@linuxfoundation.org>
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
index 0b52e060988d5..ad4ff441bc983 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -949,6 +949,12 @@ static void rds_ib_process_recv(struct rds_connection *conn,
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
 
@@ -1004,7 +1010,12 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
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



