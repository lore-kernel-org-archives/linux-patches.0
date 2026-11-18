Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044957;
	b=5evJU4CQQCT5Y+TMASAbRITf2gGgjBZ6lWUOt7OGs/X5FiwX6bWBnqtAXfuEFaTnEb6t
	 001420PhdO01QKuoTOO13Md/mhVUaRydRsMzP5/De6GHpWkpmJwxJbPniymovL00JTPPd
	 KJ0/ZlLAppa+4PGSzo7DWWuiOJjmFsIvH2Uxm2r7UYA8+PhxJhV+ixR0yZQWFABHCvnMI
	 IaaUQvKVmEP+oiIMOczPZ7stNR3Lbpxya4kCuVeumq2RL95DvlvvCWLtTf15yjpaCbKE4
	 wmcOlnwo0bGrIWnjcDJAkgP8w7tjbTCfEk+AKlneKtoxo2URBNeJpw1rbGcGKzFOYOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+PcFX94nqpeMcvCdiroSNOwL/WYdPzyyP0OXfWXatt4=;
	b=2XLMsNSR9lgCzewaR4EEqSJFzdP8W2SjNIMNldOXt4L0rdaqKCbZewfBYI8AkZY1w9Sv
	 Ea4fxWD47ECYTUqMPR5t4c92i21tSVPfOsfEHB75VliJkMOXPKOLno55k3SQpGeOANOSe
	 vu7KFZzMEIZs88O7FponT8b5FJaHBqAyNxDBqjaclBkGY6OzSkkDPh+xMdDR0M38hNdYn
	 ct5YjomKBoVfVHHbqED4JxlM10Ta8r5oQ8eKcOhbFC9oXqtLsFdCe0DuVri1jy5Jroo7L
	 IZuYMPY/0TOWCvPcKQqiiL5uBKSHEblR4vsjmPCsMQUk83BGQUXVnXeIXDLAgJtJ+/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBM6NrZx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F99606A332;
	Wed, 18 Nov 2026 23:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBM6NrZx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE2A1F000C4;
	Wed, 18 Nov 2026 23:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044957;
	bh=+PcFX94nqpeMcvCdiroSNOwL/WYdPzyyP0OXfWXatt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBM6NrZxPPNwhsNhjDc3PA6eM4YRhoZ2l4PUlIhDkg3liSRn3cejBS6857TKtbwot
	 92Kw1Kfuek2VwMgrC9mj9o7vXA2sUkPIkl+DSRmLhfKbRRu/rqUrMPsJtHTKlJoujP
	 l2fNFBY6DV0J8jehceiN6xatQb5ayFWHQe94InBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0752/2857] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:29:46 +0100
Message-ID: <20261118150228.632122870@linuxfoundation.org>
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
index aba64162dac45..c3a13ce7779be 100644
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



