Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058665;
	b=rGxJFAMCrHZXBLuiFwy3tqReUQ0kaU9Atjah3kVxZkfAyz6hfVF1z6KzLL0c87ZZoFHk
	 wiA619rLqDej5awPiZREBoEvrA0UvW7kwdEPBQZwgEqjIqehdgCw8+KHSGOUQgmRi/TDm
	 sQxcwQi5PMpLM37hS5k+ivLZOVtGlAZOPrXAbC7osgQ29Z1Why2HphZv1GP5yR7uz5Cnl
	 7VE1uDEU4ZsrlElLFSc96KIcDpqhc8PHnx6p+DZQWskXeZMcg3zzhzH8CndCVDopOJVIO
	 rt1UsRV0ScUVHcXtdhuF+8JNwQVpws316Dsn1EbsOJNPYPKaulfmtJ8RXjZ0PcPcvRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gHZoLg6KtWeyZ/KNolQPrQKOXtCre92G2RddeZh4H8Y=;
	b=UpALpHpHBHhotvmjhNxj/Wuo2Vtq+tPFP5+JAeEgfQfqFN6yPjoSfPREFgaxJmxdx55f
	 1QLERdWw1L8Derrojc0YmeKwiDJZjLbtD4L/SZs3e7FfU7rMAxyPxDMOUvB/6q8T9QK8U
	 uvyEu28is5IHqVTLiTHYjSiZx+au3IwZ15YybIQlPrUtdvVF1qLzi34zsgV5UGn/o0u1a
	 o4jGM1m4glwvr0R0kD+c84UNwafc0kZGqRivwEw7OMH6Uaco4RLlTP3nJaRpnmkeHxIGs
	 VzVWGKYr1y/R2jOKLLZxUqatp7oepexlBXkK2LsUsnUxfuIPIABq5Qdi68qqlmYne2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2OMW00T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18EB606A320;
	Thu, 19 Nov 2026 03:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2OMW00T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423011F000C4;
	Thu, 19 Nov 2026 03:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058664;
	bh=gHZoLg6KtWeyZ/KNolQPrQKOXtCre92G2RddeZh4H8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2OMW00TdtedAiQMfEwL4GyN9BfMvhEz0cMCdmE6U51cTo4Q9zugfpeO9DVBU5m8h
	 PlKJ8wWTcFfOlvr3oRXu7F5kCXIKyyUmUTuEBuhTxoE1yPE/xyycgQANbvLSrlTguz
	 8qq39VIJXweJ2Magq4djEu5zwMV6YRIq0Q5//IwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0565/1848] i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len
Date: Wed, 18 Nov 2026 15:43:23 +0100
Message-ID: <20261118145938.620575234@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit b7fd977fec0d3f2bdd4f13bb59949c817a365652 ]

When a page_len is less than 5 bytes in mtk_i2c_xfer, uninitialized kernel
stack data is copied and written to REG_SM0D1_REG. Equally on the read
part, an unnecessary read is done.

Guard these extra copy/write and read for the page_len to fix leaking
uninitialized stack memory.

Fixes: d04913ec5f89 ("i2c: mt7621: Add MediaTek MT7621/7628/7688 I2C driver")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261022193853.670625-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt7621.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt7621.c b/drivers/i2c/busses/i2c-mt7621.c
index 901f0fb04fee4..d9728b763bd30 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -143,7 +143,6 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	u16 addr;
 	int i, j, ret, len, page_len;
 	u32 cmd;
-	u32 data[2];
 
 	i2c = i2c_get_adapdata(adap);
 
@@ -189,6 +188,8 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
 		/* transfer data */
 		for (len = pmsg->len, j = 0; len > 0; len -= 8, j += 8) {
+			u32 data[2] = { };
+
 			page_len = (len >= 8) ? 8 : len;
 
 			if (pmsg->flags & I2C_M_RD) {
@@ -197,7 +198,8 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			} else {
 				memcpy(data, &pmsg->buf[j], page_len);
 				iowrite32(data[0], i2c->base + REG_SM0D0_REG);
-				iowrite32(data[1], i2c->base + REG_SM0D1_REG);
+				if (page_len > 4)
+					iowrite32(data[1], i2c->base + REG_SM0D1_REG);
 				cmd = SM0CTL1_WRITE;
 			}
 
@@ -207,7 +209,8 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
 			if (pmsg->flags & I2C_M_RD) {
 				data[0] = ioread32(i2c->base + REG_SM0D0_REG);
-				data[1] = ioread32(i2c->base + REG_SM0D1_REG);
+				if (page_len > 4)
+					data[1] = ioread32(i2c->base + REG_SM0D1_REG);
 				memcpy(&pmsg->buf[j], data, page_len);
 			} else {
 				if (!(pmsg->flags & I2C_M_IGNORE_NAK)) {
-- 
2.53.0



