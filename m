Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052331;
	b=hmD+h5KQmRKrVCPsKhqm8T7u9/11IWBkY6kEeAWBNcNWMnSiqeT6zB7iOvhboEo4VDOm
	 EsMqFWIsPhWF7340WvS/iamaaMeSLrS9ihvdCFGBH+rZ9rQQqgWqtK4lwuGhPKy4WO1co
	 Lhn1Ph0LYS9J8tuAQB7SkF82zSHse0nfZnfYowRr8CEvmj/K1pgQYF2TohKsgno0Yo3U7
	 kRRxp1JyTFcNsVHG1Ay9KXNAg3p9EZUd3qZDP8Y1/niRSohHiKR49mhz5MOURIxxYnNAT
	 02wDB72WJr+nx5PtVbieIBmzOuVSl2TleonfDB6NauNi/ZRFTBFtW/rGla0P4Qj5OsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXFM+mKWqBrAaHa2uSnsj4p1wADUUvBd59+HTJzGjAY=;
	b=r7susf12AeC7wJyJ480S1GW6GrfvNhTZRHv5Jocu6mRuIiK6LZBu1FNNPlcMFF8Ao5N5
	 xu0De6E41RmDKTYUCelHlNHnQjx+BQFqCIgp9dGlBtFRQsR/TbAdnxbrFmnvqIUxmM1lU
	 O9lDdtOBUQPJixYcw5ycmS9ElX5rQ25M7PuPcSDcdYhmjNsM4/3IuR5unQKoVRA0pwf5D
	 NXuxhlJWE8UxNU2OZA0zH1wnBBvWN2+rNWRum6ZmrtX3yVFLCXSjQOh2BJtxK0hLhLDy1
	 JCJ9rUosxio5tqsytXHDIcXjwcQIO38o6FFZkQWqny/dp9gqxuAjOw36kwrYwekPF3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khmzTDco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB4E60A2605;
	Thu, 19 Nov 2026 01:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khmzTDco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E2A1F000C9;
	Thu, 19 Nov 2026 01:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052330;
	bh=hXFM+mKWqBrAaHa2uSnsj4p1wADUUvBd59+HTJzGjAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khmzTDcoKNs7fY5fy31hd1oPq894kJdOjf+dlRjVmYckOtpKgENKz8SBkX/KgZsq1
	 86nNqxTI3RwBMCmc7r3GzObdTvXcwUr/oF/tIlt6EFMJyx2y4yB5oUYMLt8VToddZl
	 2DnYXtwdjoV2d+y+7gLnLaODV7WNOrZ/6f9rOjRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0475/2214] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118150030.177433920@linuxfoundation.org>
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



