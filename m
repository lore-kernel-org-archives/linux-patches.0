Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036669;
	b=TBGNnsLU6iE+QsHxGecCQsu6cYZqIwfdDHJFX/TGeCYOy/NJ+vi+lVnY9lPWBHM4Tj0f
	 U1g4M9aTJ2BF5FnyKBNLVVstXrGzLrZjaLRaGisNb1t7puylT2s627LhYpr6voKKPZbzB
	 JIIiYtxkHqTkSqlsL9QFihs791TB8bPM6p9Dc8SHE1gD2epn9KmGQQj1quvGw7Pfz422E
	 3/FJluJ/GP/Rb+OIc4Qmmg5b2tBgAfbxqManc2DtKMAlD4sJafiYG9YxbZ1bw4B2pH0uY
	 qSJ7t5xAMHE9jd2F3GaVsoZRebBtGPLyoKE8U2DnpxSQYvcnLJLCnfkn5dV7MCeWdlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yrc65Iop/FbSvPAJ/z00iQLRY76jUZrHYH/0qFVuAAk=;
	b=qqmwJz67ETw+crhq00L9fr/Xcq+Bf1F/Ad0FVdWbZ6n0tj+pC3a6zGssNY3ULZS2mQMH
	 kNGQRthUBOTfgggCwXslkpl1gAdUOu25vuFugt3GqkcEzZ4m6f21bg5w5pl1XYbGjCNiT
	 RF9SLgJ9hfElON1TtMQMJSFHgerfbqJkFZ6JIjdk2G6lUR8PzoJBc64944Qui8/6Mdaii
	 x2i/w4I0qLpOS1MVAWltHpUYlFR7nVPv1rITO1JSCW1dZXpNA5vuRdoCr+UGHE5nDLme5
	 05NgTyNjLFFYM7hewZhA5+riQCIbv38joqphB7R5SgtBbIdLaEFWbn4FOzrKJBiFYUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XgaM0E/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2320B606A31C;
	Wed, 18 Nov 2026 21:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgaM0E/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0D31F000C5;
	Wed, 18 Nov 2026 21:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036669;
	bh=Yrc65Iop/FbSvPAJ/z00iQLRY76jUZrHYH/0qFVuAAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgaM0E/mxFVAT9xzxTFmQ1EW9HpNhoW5BZXJ5CQS/5LZD8W7KKsv0NXhZe1E+xuE4
	 CwoRqwK+RieABtSTCTqGarC2xW085OuCHoOLx7wHsJNlHshzYOqPo6+0o8YVnJU7go
	 HYB+Pt06FqN2vmbh1xnudQlHowADLySMZt/1jFFE=
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
Subject: [PATCH 6.6 1141/3318] RDS/IB: validate receive fragment completions
Date: Wed, 18 Nov 2026 15:29:23 +0100
Message-ID: <20261118150354.295848575@linuxfoundation.org>
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
index 7310ac4d4be48..7f918fb377de4 100644
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



