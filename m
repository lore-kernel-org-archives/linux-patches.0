Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063925;
	b=oUQ0rN2OJSlykEjlTefnRE+/dcsIj+iq1m4mBI+NgTqUuaemeGOIDnJqdiEHeVR/MIvQ
	 7JM3qZnQMBpe0TzJYFTsPntKsLQ07d9F4F20eJwcL/a9vCQQDFoYJuouGbaenXjPOjjeZ
	 x5fEUXcX/BtUDsNVLFkk/rGr666NZnpLqzU8S2knkcxH+tNrDYTjxQ0yY2mQPmJK85Je3
	 lvEu6D6S+cE+aEEhNylJ0pkVWF5b+Q82eP5oE3CbL+qaanFBCIhI0NIWMee1mCpk7V0CH
	 mJdCTbzCrT2+XfZ/WcPFsBK4ChwkZolw5LUBKS65eTcFmXXLToZ1fBXWUhFeefg5HyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3DbQsoxsONyGAxKp22ZAl75WNWjhsgWna1yVOIlMyE=;
	b=mZsPSJDvbZXKeLGFhVOpuPVUHhEOJeiQ/zKKEOu0Os4uoq04O0KPRRtgpQR4mfM2QDyU
	 ZqeTvP5dd8UZTGFqU2dikZT2cr6+c0LEP7x4pjzZ93+K2S3v2jCWrHHoiOfQ0YbDKoznF
	 ITzfSB6yX2XzUdVLsTILKPfOLcbFBPoF16pCe/H0OqY5YW7g6IX6lBGFQq//zkbDcc106
	 QotvvndUeJH5OAkNDBGeq2pNls6aaCw2GoBKTxthhxLurMCE6YzKqAr0FoFBU/QiImBkt
	 O/HmWFSqirNiH3YZwkJGEmZbtbF+PKrDkSnqnFZjU1jkB90UNXL0TokWuTdHLH2qkCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVHiX88H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88158606D802;
	Sat,  7 Nov 2026 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVHiX88H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339311F0089F;
	Sat,  7 Nov 2026 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063925;
	bh=m3DbQsoxsONyGAxKp22ZAl75WNWjhsgWna1yVOIlMyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVHiX88HmCjG5Av6qhKfPmsbWXsnmzITiBdvjP6zFBV6WBL+3POPqGYQKCDYEkzpx
	 qybEQIS9a8+Qy3bXC3Tj4V3tXb+MwOPDObm+c22yo8NXhSIMV13RV9Ck+KLLcvBudf
	 InuVA6sLgHe2AUE1Y7B5dZU2MW3rRA+/LryzNkvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0120/1257] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Sat,  7 Nov 2026 08:40:16 -0500
Message-ID: <20261107134942.648457488@linuxfoundation.org>
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
index 932bbed5497aa..63be9ee104abc 100644
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



