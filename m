Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061959;
	b=UF28NspbZlKOjalkjwnPc9H6Bm77dZMDTji7AWpnamcjWTT6r/McbIC57se5Y9EbVlnZ
	 iBX6WDlMNGSHo23EbshRJwDZ/NwlfoPmIU7ssfG12FqCJaICHzs+zD0T100A0KA4gJnkQ
	 MIKuhWbFXeMZTs/SE/wuPQA91yOkGXltNZoU9MORJ3AZo/HulTj+UKLdOFYg9/GWvKleG
	 jsuJSx8PP1izwkJuR133tlUiwHKqTuo7rmrV8gnUnXR6GGy5z12IH6Gg1ovAXZhVSr+an
	 fX0odRkhqgeLWqMKgwWsr76devCEP58PQ0VHGLgrYSECcempHSQSADcnLkocBqkw2uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OPCm+Oxv72fTR0V+4bzomvOYFYriz0k9+yJk24YTuaM=;
	b=UpJuyHQRfUMoxAwH6cG8imXT/k9bRn/1otz32uG0v6hR79nzY43Rp1jozaAR0hyWvmbD
	 pHdeSaQyKG41EzbFVQhhgmzEqGHepa2O8es6kA/9rePia87/S5V4DFX3GLNxnn5srhWe8
	 SU6965n+SSIQ5U+jmo8WTAvdBjj64CUpsfcUlDDH89I4ZVQbQjVYU2PuZ4I0Z14b5avRY
	 Gn3Xbw+WEVOPk6VuLr7UeekVO0bwS5S94we7oyWlnk3V6/qJC7GQWmcwJX//hTbMijHJY
	 b3cM5K3tuV5jsNLrbKcGxFRN+DCkJL1xfwzpFKq1u93HLRTGFf8tXgy/VVBMuJMfN7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FdXiGS4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E59606A330;
	Sat,  7 Nov 2026 14:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FdXiGS4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4961F008A1;
	Sat,  7 Nov 2026 14:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061958;
	bh=OPCm+Oxv72fTR0V+4bzomvOYFYriz0k9+yJk24YTuaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdXiGS4ce1ApYA/yK0TU4eNTO3d46oUr9a/hKRlOb7nOLqVz8y9nNIazQAA3MLenT
	 0tTcLrqnAcbukql8ouwgQ7zWkuW5i/xEivLItkv5fC0ZWjb5zHIfa4U+HANikvVxLI
	 AFWYLTfq48ctm4+RVEode6HcX99NT2TXgbJl6SKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0957/1536] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Sat,  7 Nov 2026 08:49:33 -0500
Message-ID: <20261107135024.531820051@linuxfoundation.org>
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
index e7b9b9b11d7df..ce228f2ef330c 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1775,6 +1775,8 @@ static int stv0900_recv_slave_reply(struct dvb_frontend *fe,
 
 	if (stv0900_get_bits(intp, RX_END)) {
 		reply->msg_len = stv0900_get_bits(intp, FIFO_BYTENBR);
+		if (reply->msg_len > sizeof(reply->msg))
+			reply->msg_len = sizeof(reply->msg);
 
 		for (i = 0; i < reply->msg_len; i++)
 			reply->msg[i] = stv0900_read_reg(intp, DISRXDATA);
-- 
2.53.0



