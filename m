Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062004;
	b=M70nuYGzkxXPsgCPt3JmTfWSjiIZoSGn0IC2snxyJ37v1JLd7bTFteNIwLk5Tawko6zg
	 pd6+fy3AHC63SJFrqA6OCGVeGC0pWFAqbVikCcE58r2Qwfr4KTA0P8uyAdeCaApZX24zP
	 yGnQbOBjku/XQp8jAeYcTPCNKaR5FgZRxji0ItbECLowoo/1k6ELfdD3d2QhY5KLz75Oy
	 iE9WUW6O5aJF48QDC894Eq+QX76EU8d3WwLBJOOfA619UCgGywou0pIGA2K/qfiRZlpdV
	 w3SpUfR3iDhanSOcYb1bKNOwxhUFQiSdD+NfgC4Mfa5xf9CNZcK0280FnGaRWP1EsJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AO4bxFSorMvR5nfHYISSwhifAd1XmW726cbcI3E0c2s=;
	b=40DyPu/oMFue427Q/mMZvYQvFklue9ZC6+F5HhAKcXzzJBxhzAop/40YTOxFFzstEIcZ
	 tp54s2/tlA/DLc6RuL+iKarQqP0+JnlLfd/VaujbyLcvhsdXq1IuoEJBge8JXM5YDFPc4
	 2ez8eMaRPqZAW7fNokAt7bupZUtBhsPRHHZV0x9kHKWUJ8PopjogiKiIY862pwwxlN/bw
	 zB0pPxwmyHYzNwHx+uwysfvos0g61LN2TAofnl/mWYvVN31b5jNIju1vejCASssHFA/UZ
	 enyMaUpYm6RK609RIlPw3iqLgzXc8rRVHv6Kb1tgjstGnlsOP9cm0lbqT4/G5N/tvrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+7YHdFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25CC606A32E;
	Sat,  7 Nov 2026 14:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+7YHdFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E91D1F0089F;
	Sat,  7 Nov 2026 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062004;
	bh=AO4bxFSorMvR5nfHYISSwhifAd1XmW726cbcI3E0c2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+7YHdFHoOao2MpGU6xriYpi0qJFZV7K9kkKtcG/FRpHkgg/69izN8B/adzcfCU8a
	 MB0nK9EMdNPVBa5CsbGpgaPNE5TQXE2uvNVce1poIzfK24ANIRdZEads68iH/MM3UZ
	 gKA6V81P85zLmnSZFVvB0fjvtwDz4z3NAdDEBkb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0956/1536] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Sat,  7 Nov 2026 08:49:32 -0500
Message-ID: <20261107135024.502287295@linuxfoundation.org>
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
index f273efa330cfe..b95b6b4a69c73 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -3902,6 +3902,8 @@ static int stv090x_recv_slave_reply(struct dvb_frontend *fe, struct dvb_diseqc_s
 
 	if (rx_end) {
 		reply->msg_len = STV090x_GETFIELD_Px(reg, FIFO_BYTENBR_FIELD);
+		if (reply->msg_len > sizeof(reply->msg))
+			reply->msg_len = sizeof(reply->msg);
 		for (i = 0; i < reply->msg_len; i++)
 			reply->msg[i] = STV090x_READ_DEMOD(state, DISRXDATA);
 	}
-- 
2.53.0



