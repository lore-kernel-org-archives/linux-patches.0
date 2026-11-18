Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035857;
	b=SotAPwsYe7v5J4SduUvsj+Q891meqpxS4I9aYTmvJDGFOmcUzo+MVWIAVF0mwEO+/F/V
	 DBn+U78LmTu28mEsts6ctiGjsaIGXOQwCj1Za3CbXKcV6uKfsLWuiz8/vtlKq8OQB83Py
	 9bRbXf82j8+aQo6LpkNZgH9ifwSR8FrpYa5JRgeWYhcD7lQ5+jODAw2CWr7FDwSy69Yi7
	 jhTPzOgrJL9S2awOqUMZ9qxM02IQt/EQ7GIgzfdnNlweODdnqzm8vdRAGxiHDCZqb6nr/
	 Nb3+CBmRrotLs6MKXYpLqv2x2nIpfrm/K0w3Sveu8X1wKlK0+TJ9WMuZ4ALQEmKndlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y+WSM3xqpoYZACPFavY35Vty1EpewqMRZi74yTnmOUM=;
	b=YWorQtubeSdknrmEatpF8l1Rus7uwb2KZKf4KbVpgipxK2gDPpkFmsDOMCkakG3in2d4
	 3T8LMt5kMTuSLsjenZFyHo8R1OOQpXIooAKP3xkqBVndsRtoBdqIeu1WIdJ3G2h6ewHv2
	 nzNFMU/zc4Fb/cCM7p0jU5SGWa/bRn+u3Z1KLPpJ2eB/SDrnIYrO49T/DAuL+dc6ru0Xn
	 SFA+evNpjTeFUQk2Rw1dJqhQZsNe0kBDo5/B6SGUjlPmFo2Z0L4evioJSEgJ0BIn7Nk0z
	 HhR4jLpBsvJbyJZYbboS+yLPb0aTvHEXs5LnPBGlhZinUqxgd9oQIvQ/hFk24k9TvIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7U4tcgQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6A2606A331;
	Wed, 18 Nov 2026 21:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7U4tcgQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCAE1F000C6;
	Wed, 18 Nov 2026 21:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035857;
	bh=y+WSM3xqpoYZACPFavY35Vty1EpewqMRZi74yTnmOUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7U4tcgQcZoCwfoue/jFqaUYaub1EWxK0APhJh4zadcdGYzD7HpIsYB0ckOf5PQwK
	 UUJlnKyOswGjVhUlY+WFizlx6gMOspULwx50D2eDTKcdtMM+QHhXJiXRV0kZ1sR1mV
	 Iq9rfNDHDh7cdg5gFCg4b+xuOVsoEpfg56aIo0yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0852/3318] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:24:34 +0100
Message-ID: <20261118150344.787720441@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit bad6ce6e0856f344910ba95b006e6c0ebee2d9c8 ]

The FIFO_BYTENBR_FIELD register field is 4 bits wide, giving a length
of 0..15, but reply->msg is __u8[4] in struct dvb_diseqc_slave_reply.
A faulty or malicious DiSEqC slave (or i2c bus glitch) reporting more
than 4 bytes will the array and clobber the stack.

The stb0899, tda10071, and s5h1420 drivers all properly bound the FIFO
count against sizeof(reply->msg) before the read loop, so do the same
thing in this driver.

Fixes: e415c689a884 ("V4L/DVB (11579): Initial go at TT S2-1600")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/stv090x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index cc45139057ba8..600733dab86dc 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -3897,6 +3897,8 @@ static int stv090x_recv_slave_reply(struct dvb_frontend *fe, struct dvb_diseqc_s
 
 	if (rx_end) {
 		reply->msg_len = STV090x_GETFIELD_Px(reg, FIFO_BYTENBR_FIELD);
+		if (reply->msg_len > sizeof(reply->msg))
+			reply->msg_len = sizeof(reply->msg);
 		for (i = 0; i < reply->msg_len; i++)
 			reply->msg[i] = STV090x_READ_DEMOD(state, DISRXDATA);
 	}
-- 
2.53.0



