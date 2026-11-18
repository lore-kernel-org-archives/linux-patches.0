Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052328;
	b=rnjv0UoR8DojJ4PUoYQS++IgU0/KtQE7BI33XAyuPYQ7Rr/qEQF0zGyO7+T/DHwchW2b
	 cp0CE6Uu4JcsK8oTZ0NunLtpxLhdF49keZGkEkXIqea36Haz+prdwmwqcztZ2pG/UfJWj
	 yEQ0B7Kc5TjMDmo7s5sS5WI2uaJNT8Idiu79ed+eWqy+wFCsQrHkYpxZKtm74i6ySvOvI
	 IGveHqEK3Q0t/5Ssp3ETiI6fIqDc0VMDf9GACZiu+6cS4NSpIFzyZ16LlsBcl4DEVO05s
	 io2Xf7DexhJfHkCWiklY+ZdVtwrWFipDSw6BRLZHmo4Q2TCYg110z6IIkO9RNfk8FSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=so1rol72OkuHRCMtv5lK8lEmULBsEzocQhqb7JHfhgs=;
	b=mldpE53YZJqmAIBpPG2A6fUldQ5pMbrxzY18thdnsBe42TseGMfXGGl0QsTqnJ0y6A/N
	 Jo67pBN3nTED2IIY5uKjOWAIFLmz7cdrz1HZDHTVNLkkdsaZi5qbVHJvZSCvQF/0fHeNh
	 QPCNMCoZfR8bH2cYlo2/D2VJuJkihta9TSmNZjklM+YiKKsCmUQhDRvL2oIo95jEPA8AA
	 k+X3R46j2qeX+/0PVFNcEWEM/+gpmt3HPK6OAr/AImH/VlBidYY2bAIOxbjiBxMy68gWJ
	 adXgo/8vvvNkXRUR7opQncjxdp7AMBLwHsgYAWwamj6+TZ7Mub80oL56CKp59O5z1PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoHr4SeR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAC606A31C;
	Thu, 19 Nov 2026 01:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoHr4SeR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CDD1F000CA;
	Thu, 19 Nov 2026 01:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052327;
	bh=so1rol72OkuHRCMtv5lK8lEmULBsEzocQhqb7JHfhgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoHr4SeRtwE6z9yeEJmqrEw2fTxqJuYjmK1Bp1jmGki7ZpmOTFGOPdCdCkC/D9c3e
	 niVDLNWy5SQRTMIW9gl3OZD5GTcKk+j3WNxs2vQbAH3oS6EJykYe13rLU8s9f6u4Z8
	 AQt3TXJNysW80r4XiPfrDFoNu1n6gMjj7Xlm1T7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0474/2214] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:35:50 +0100
Message-ID: <20261118150030.141360758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 799dbefb9eef7..06d412c7112ac 100644
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



