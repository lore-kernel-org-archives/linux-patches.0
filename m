Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052811;
	b=HnayiirQiw7sF7AMMJzwrirKRAtn5s941M1U8Eon0ck5oocdgVZ/uOP8LWwolr/IY2LM
	 iPpjZTdPlYfBtVNbVgj8IfydquukVLQ9+6dpdqvV5xy1C9iqeHVjm+jf7nX7ebRWXsAnZ
	 BeJUbqJBBidtmre0eUOS7A9jDQY29if6shHxN1nTeKmfGuPikTyMP730HMMooDT3ugca5
	 hxeHx8/LaBo0tzI4dJy/dB2VEfEN+4o3JeCL2y7alKuf/7Z3fNJvlmsIBvWCUQx0qXrGZ
	 Wl+AAlZewa4py0D/HLlIVSutUxAtu8pTJPgsDnbjegkaT5BsdnvIxT7DLZ/Kt/FEGHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oilfk4a5jP8+hf6ZJeq0Nho5AZHALUGjuKhMN9h0rJM=;
	b=RU9XLCpsaESxjyjWeGRQQClAs7JrTNsj1cJAEdXcN+V8Bw8wGCg4F3cnglvQx50c1PPr
	 oInZuoSxHABbDEdAX/MAFgBlVMEWFP8lbQ2XKrnzHzurQCo48cFWhqdJsoG8x4EpL27M5
	 Po2ANsaM2g3do7nFjTS86NCHvhGaJu1WxxKe+Z6aMPOGECzhKgkB/gNWAfnsOL7qBN4aD
	 xFSPAyITWDemh7SdkUTK/fdbY0gEbM34B7QeIuHzw/9HhpBDztlwDzTKnS/03nJtjbaZA
	 SrVZDnrM1aVt4EodPTEXbgiKtSde67K3YZG+ZQhcRCz7RNe3XYVcOPCl/b1I1lAP4nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0kUV9Kp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C3E606A31C;
	Thu, 19 Nov 2026 01:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0kUV9Kp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221731F000C4;
	Thu, 19 Nov 2026 01:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052811;
	bh=oilfk4a5jP8+hf6ZJeq0Nho5AZHALUGjuKhMN9h0rJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0kUV9Kp4O7g7+U2YSa8BKShvG3bVRIBL5QKgEnBd0OaQpjNgCgwboHcKuAo6hAfN
	 XVz8lNwvC6qrSJGrxvc1HsbZ4WaaMaJ39URCZYsUHZgc1klfLeubsj20XbrV9jgslQ
	 ig1MmNi8wjkSQd5ZlZNGAvjYnncG7oT5HvgSiXug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0698/2214] i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len
Date: Wed, 18 Nov 2026 15:39:34 +0100
Message-ID: <20261118150039.736502859@linuxfoundation.org>
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



