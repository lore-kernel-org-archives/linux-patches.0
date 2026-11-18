Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058144;
	b=S+6t4AzJFVCuaeGMAAoF7PGKg2ovEyP6nZr5V0gdcawsDDw2ifz/A2TxZqhMhcXjIm6U
	 aaJipxL7pINEt8kkWaKxJXAhJRL/Z2jgsTJYMMIh2/h9M5jdlHZDDusasOHwudu7R3wdL
	 00eXacZFcVN4fOXkPlLG8/MeGdtSv5xoMDugcZZT9fHccg8/5F18tuM8vHBxlh85Xxa6E
	 fuRJY//Lck3YaASt35LkPObp8bueLRRbLsfU/m+ITDyBg0n+3U7TnFcEH6agwj78ZEC6s
	 LAiDSIpVA5Vb28VIKhEqViBl78GUAiMtnRrV1T+cs3fx25UgQuKDugm1LhmMvvAL3yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cg94z/PqVuZzZEw+O9cTtEBcf6qCDoRkkP4viwhBOg8=;
	b=NlGXQ6QrV6DWOyap9tmw+LCcDXLvqraQQYj2mPaFrrT8xzrmrf7bRQwGfovo/5NX35eS
	 7/x4zCxRsFiEYBE9iJK14yi8Tiuge7Ei+DmGbjM9i0Iieragxajoo88fmrv50rw6ICMrG
	 IGTBD/hDUKOFN3QQL47Kpo4EpJ6/o0sZI+NQGImYOaeR7q3vF7AbpvHVcwmIaWeKrauLZ
	 YwDzNIQPkXYUtixV9NGPZ+xXiRaFVvYZxj+UHneB/NsIQXVfTYBwEk4d9gKquKrbCzk9K
	 DQP0EDAVviXELrwWzg/2EDvART6Xiz6ckSh8twAqgEGh3VlqgDOFA+txuBmEQSUHEAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTZ1L37b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71948606A31C;
	Thu, 19 Nov 2026 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTZ1L37b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA56E1F000C4;
	Thu, 19 Nov 2026 03:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058144;
	bh=cg94z/PqVuZzZEw+O9cTtEBcf6qCDoRkkP4viwhBOg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTZ1L37bsRtO+4hDttwI12wJLohpWNP5uqLjlIYj+hFybtKcN5o3ZmmSbIf77Qmyi
	 iZv4FP4dbyWbcqJ7G3KVioj6H4AIlk8sOvOMO91fkHARqbR2L92muRA9Vi9rwyUYwW
	 yDruYSsGQK5xMcTvm9PocIfArkppyo+f/6DDNvQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0380/1848] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:40:18 +0100
Message-ID: <20261118145929.451201981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



