Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035860;
	b=pijV7dtJzHptgxldkdhsz7x67iwJAiRjne5qjm2BJ/DDuj4pLQUz9AOnoNIr6CMlhyTW
	 U087Xzx6jwKrPhdOWgyy3YNyKNo0b/7/pUH6GfTUlIpeOMhUj4vUmrdFlo60hkqYk53T6
	 47qA2Yxx/V3a27Qb906F5bWVk+4huU+g5rPafxBRCNE5/bKRyR/O5NBHZqZXIVaZ71RCl
	 ETNKEJNULVhzrPMHYpuXUTFDQH02xqXPkt1n3cNtVn+as3yZNleGBKcfNENzime0QAyzv
	 EMMboi+gth9j4R8KaDSPSAT2N6wLoIWWza8joqIWZ6Nj1IDCzOriUjKUJV4zywQDYfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BffHkXfkUQF5sOnPP1Fy76ZqHDfIDJgP20oo/CnNhBU=;
	b=T4rW2djJfJhiNRvzhSaqmc150Z/YYy/gaKjRQLGOe8wHneiDCpC34nhNn4lENYA+N4pn
	 CwM3tzUYZWgg2pXSHWWaqvBWXFFtuyPGSCZfWTi2CiMRC9G/WLokwnNiDX1v/0mweEgrG
	 BFhtZTXPmfQ5K3smMuJh5XPKGlKP4tuiWGCRXf3HNTwVsZ7iRKaSCvXrs7IrH4cZbK4c1
	 /Ul8LZS0LUQKHolTTzICFtCfnV7k+FCgbLlQD+yoCEwoC0Xr9Nm24qfOJdK5pAKeoOPFV
	 8BvUpmLU0lt0osGwGY+xaJJNpEQEmNCjwNFDEPqjmIEIttAKyfy+esIA0J6DMF3S4gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxnmWVUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99587606A31C;
	Wed, 18 Nov 2026 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxnmWVUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7C91F000C9;
	Wed, 18 Nov 2026 21:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035860;
	bh=BffHkXfkUQF5sOnPP1Fy76ZqHDfIDJgP20oo/CnNhBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxnmWVUPKS5X7S+15KYzqZtmzcD3c345WzzjcVROrOWIwoIFcIT7ouwiyEVHufWi1
	 zqju1029MumT9FeMP1apuo2C1lL+bTeTOFhU4iaWEpNpsQgEhTTkoksvP0vv8sOAEw
	 3j6k+0uTT5zmB1Ofsk7+3WrtLSpzYqCg2T7hz6Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0853/3318] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:24:35 +0100
Message-ID: <20261118150344.821173574@linuxfoundation.org>
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



