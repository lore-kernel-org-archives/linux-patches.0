Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044960;
	b=ap9WnJjSdQYdY77SDFe/osIjzv4aO90TnJ2C7K7VewW4z5vKU5hSlSIzWcFpUDnymZ0S
	 TGbopdPVOcz5F5u7ybSH+wyOYP3PFrYivvE9p/AKwpGd//I5aojzSwcqMxUBxIg3z36yM
	 tbtP+fznyv42WAiZtjjwfNkDahfQTupRKLv3rgnjHbyJ7gxMBjZ0mHm88AhJRwCU4cspk
	 TyjQxUnHrjtPYcUWLSu9Dhe5dQjp/GpYs9a+Fv38szSLsB3m/gP3ljg4rkpmD72maNBUa
	 T7k/U6oRsrTNU8C4uvhxzGbEWN7BlAWYPUY9O0zSQUHYCljZ+JnDBhr3xqe7QEziblQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mD07lC2RNzHfvycwV9vEA3t9soCLtFQW8xQFaSnj82Y=;
	b=lOFhSKs3+prQOtbdS6L4DxZ5cyQCp4Rb5WTDghfo4RVZyeJYFGebvF+qrBBAYIc2EX+i
	 6SPQ+pruBf3cpuzzonQtdwpVkLAc/LQ2AEc3vas5XnL9BGq7760EdRq6PBku6Bz4d9JR2
	 LgskSlmFeGeZ4EZhaKXy0c3NtsirUiGLH5W+7E2FIEg/Q/2rBavvs5oRzBAV3V5Sha/NV
	 P9jWrQgDvPibVWN8a1IolJohypWkk4EC9bjfm2W5NSLoJ+fB8lY0uYH8nqfmMTsWhkYeJ
	 x4MU5dCuoV6A25sCxLR3eRfzdsvczScCVB5K0NsPpg0zDLTWpdcMybbKaTLmrmbul2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBQUMjg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064CA606A31C;
	Wed, 18 Nov 2026 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBQUMjg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540A71F000C5;
	Wed, 18 Nov 2026 23:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044959;
	bh=mD07lC2RNzHfvycwV9vEA3t9soCLtFQW8xQFaSnj82Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBQUMjg5gQiHOrmqiiH2yp3EzO94SjRKX6HlECf+NW6IEeo43mjI9QvP/2NPw6O6h
	 m2mTXy5dp4RwOCUSHpakrTgyDA42c3S7Wgpqkyzdbzav48qU9ktSeZ4yXztI5Pp5nM
	 ktFlRAjoztbKe+mb+gSw9i2FNmC/j6pUGVg6cK+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0753/2857] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:29:47 +0100
Message-ID: <20261118150228.666588387@linuxfoundation.org>
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



