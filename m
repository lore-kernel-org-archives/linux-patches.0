Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058138;
	b=BPV5H6KZGQbA5/+IzyU/em02B3W+HpTWjzpcA2hpb1XgmEfkgLt3XgJkTOu9G134fT3N
	 TsLVHtGanYjh2uI5hAL+JLYxOEYXTbBL5AzVjQv/7YV5fe+4Q6zG+CmLkEuuRHaQ1NCBD
	 /13B+eaPfyjSuzKkNhU6C97kBW52MjKmRU9wbxYRaWyJT8q8W/Gx29qv6J1cwiNpgpcn4
	 7GA3MyJsdaGkx4gDvdhIqYo0ca5mq3CL1JLZiInDf2gv32AHKNWSoUq4Wv4GChVnSrlWA
	 POXEt9PhFaa3f5Nkp+yYx/wqAruoBO4cncBI93e4kS34CFiXkCyW4dTyJVtDvS9Oqow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wD6HV8pxTXd0dNozFfpMP6Sra6aN9j58Kqol0GyikHQ=;
	b=bOP47ViB6uLkjMD5W7n6WG7HZYhc4iMGjtNCzWMJaT5LKrohChBfl4KJnt9DZ1+iW0gY
	 0dIQLEcA7Fk+k9p8y6VDQMYgk/cT4IDeUirpt11PKpItDKSsqPkawXg+ifjO6mGXracLg
	 F7HW+HO4x22URHm2sc4+ouVV1iPXxYasxBXfym6yLrYGJktBqK/UyOzvvTFTwW+S32+8J
	 AeVUhgJC/kidVzxyHcRhJriLDCO/9Es1CkTlrLD0tzfPZnKiA/FoDcZ99uzuv5jEm4k6H
	 M0dxeqq9dZ85Vdz00UAwgEJAujNdTAFlu5jN/a/aOlFhH9l3dkEfL475ImdAZSYbs/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuFqEebA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EDA606A31C;
	Thu, 19 Nov 2026 03:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuFqEebA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C35A1F000C4;
	Thu, 19 Nov 2026 03:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058138;
	bh=wD6HV8pxTXd0dNozFfpMP6Sra6aN9j58Kqol0GyikHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuFqEebAWz1G7yAD5Ytc1iizLCDffVX2hBCxOYNgbxqkENyAlWzSl8NZtS0oiYqef
	 FP8RhX8jPiVm866m9g5Pi6hXCdD7nkBIoZ7UXO1VFEIaWmqaN2HuWu9++LEZLdHrb9
	 3NpNaUPkeq8DPC6BopEr6m0VAUptqs4CK/jcCP9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0379/1848] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Wed, 18 Nov 2026 15:40:17 +0100
Message-ID: <20261118145929.387780696@linuxfoundation.org>
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



