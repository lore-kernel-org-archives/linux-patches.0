Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063927;
	b=niH6qWZ8k1JQLomkpksDsWnRyWgb0tSoV1JKOXZbfAS/f3SLOGythn7lDmMutPNOho3N
	 q0AC/LfPJFqApovubjfcsIM1cFxHgQJZZCPnVF5soQidpwu9rjKNKCBb0tpSKw7iVc2SO
	 dmAMy222PcaE2RFOb3/lU5G47UDk/BpUMFg2ppgG0N6HgbE1dD4ubBv2o0KNetxQvDqaS
	 U66GjVYU0+IG77JXQqHNZNT3Hqb2Ld0ckk1kl25DX5S7zRPRp39xg+pkODDkcFxt0VrYY
	 4x8paU8mthFPztj7QMM3llBKQQKNYTwKzsEFR2Zr/DXNGp1yTMDkXg6k3TLqnAeY9rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yc6Ifo9LB9zMphskWEOO6qC2vAfXTgZ+YPjUQYguEjA=;
	b=LeI4WUkqd1WtBFXJhACrvewaQVi/m0uFOvOpDatdCUBfiHI6QKVsuWtt0FIYy51LpNwY
	 Jzo9ettZHZixHrpGzFKgXFGb5pr4BiH3CTxtr+mnoIp+eGmn6+DA+36B6GnDQs5VJ/pKZ
	 EbCKdLnQd/fCAG3OBZHguvf6MvrXUx8SIFuNtMsUEdp0SleXq849tuYUfAQj4MjDyHP5/
	 e5qoBreRdAAiGMWUe6XfuqY9bQGbGLCZIuOyY7R5vafdlXNMGOvP/tvQncpL5mbbiy3DW
	 1cfZ8gTW5ACDVkjyyj/ECDY5aZZoMBPoPbGCI1s6o1kAmlWMjz5J6g+dyTW+zET5dQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrBQHHYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D3C606D802;
	Sat,  7 Nov 2026 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrBQHHYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8981F0089F;
	Sat,  7 Nov 2026 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063926;
	bh=yc6Ifo9LB9zMphskWEOO6qC2vAfXTgZ+YPjUQYguEjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrBQHHYpn38VzHXsMm2Jj+sXO2V6W3+2vma4w/H0DyAE9fYpz0C177FX+46puAIo2
	 +miaEXFLjrbz7+cKBi9vHiKaFIaRqapacyOrRN9zIIkNoAxDzqas1ag89R0/7s1D1q
	 DUNwpgMEpiG6Lxm3oGJ7KXYM8tzfsiJJMIoHMnI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0121/1257] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Sat,  7 Nov 2026 08:40:17 -0500
Message-ID: <20261107134942.674024935@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 6d7e70111b9c80a9e4cb17fe6a6c4f5470847722 ]

The FIFO_BYTENBR field is 4 bits (mask 0x0f), giving a length of 0..15
but reply->msg is __u8[4] in struct dvb_diseqc_slave_reply.  A faulty or
malicious device reporting more than 4 bytes will the array and clobber
the stack.

The stb0899, tda10071, and s5h1420 drivers all properly bound the FIFO
count against sizeof(reply->msg) before the read loop, so do the same
thing in this driver.

Fixes: 99277b3824e4 ("V4L/DVB (10803): Add core code for ST STV0900 dual demodulator.")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/stv0900_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index d15c55de2723e..0ca6b6d812731 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1773,6 +1773,8 @@ static int stv0900_recv_slave_reply(struct dvb_frontend *fe,
 
 	if (stv0900_get_bits(intp, RX_END)) {
 		reply->msg_len = stv0900_get_bits(intp, FIFO_BYTENBR);
+		if (reply->msg_len > sizeof(reply->msg))
+			reply->msg_len = sizeof(reply->msg);
 
 		for (i = 0; i < reply->msg_len; i++)
 			reply->msg[i] = stv0900_read_reg(intp, DISRXDATA);
-- 
2.53.0



