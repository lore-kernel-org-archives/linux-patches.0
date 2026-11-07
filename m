Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062533;
	b=lK6JjoK/2SfTKwSw56Oectq/0tqWRKAfjtvWgEu76PqHMN0G/VVKEdKp3Nh3/Dum3ezD
	 Rb0aqhV3D1uEGlOHtECNVHq+0IdRXZ0qUcIHyH/ZCgmhF2ikPF5IzXXrzzydQGhdkLLcy
	 6uI23FNqNCpYmRGFqmqonkH3cPvoM0PNkz6XU4V2tmzC4Kb5SNWq3xXvaOpnFOcbE7Xui
	 VETVqf8/Ne5rls3avFpvSPNIi0zaG5M7ezP9TBMvJyMx2WzIyGi6irkE+/FMLkxjuWt4P
	 Pu4KGCmCmZXNadjx5fJfDzXhGw2GNKBHerCZwmrn93eVhafQr+k+lbyhkf7ukHu5yEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DGdB6QDxPoKs2zRYRMp4BAsXeG10dcSZJ4d6yO/u+jc=;
	b=uUV9QpNMiUeCOPPDTPfNcJZUMSPbIOdcD2E+1JnPjV7b6ht1s2ot08RLhoMnOqY1YDFR
	 FeeVbs2ngX+kE93VTgmENPrBf+IQiKIFmJmAiphbSwwNPYOGNdGCEHL6my1Q+GvuYEINb
	 HLp2EaEvSrol4/jn64Z4vJkBn6cDE5Kv4+OsbXS/Qkzqbit3meZnr/PgM/Ue3Ejk6Nai6
	 wHVpsGbzq7RsscljOXg3fNOGnF+iXooYr84Ki/vYH30Jb8FOk7l3zszwrUBNlUouiQ7Fv
	 vipVpO+GlRsHMnQwjHBi1sSMUWZTs0FnzNgjggdUBUKs2gy/AeCvkyyDDctplsNwj4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFePzDyk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4DF606D80A;
	Sat,  7 Nov 2026 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFePzDyk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3411F008A1;
	Sat,  7 Nov 2026 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062532;
	bh=DGdB6QDxPoKs2zRYRMp4BAsXeG10dcSZJ4d6yO/u+jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFePzDykJoDG0ElCXBxwnJcB/X/J3/nIrgT7NVcmkGoW6CsCc0UyPEuSbGx2JKQtO
	 ArmspAPmuMfyawCZbKf9yEZhOaHp2NCvuPaAlBlt3rDzZETjGIvsdXlEIZ0E1pdmcM
	 jQFrulK85N8iFcNtXLOFQwOvqOujgT1gfw9ibdIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1424/1536] i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len
Date: Sat,  7 Nov 2026 08:57:20 -0500
Message-ID: <20261107135037.824072626@linuxfoundation.org>
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
index 23d417ff5e71c..9fbdd6c056e3e 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -144,7 +144,6 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	u16 addr;
 	int i, j, ret, len, page_len;
 	u32 cmd;
-	u32 data[2];
 
 	i2c = i2c_get_adapdata(adap);
 
@@ -190,6 +189,8 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
 		/* transfer data */
 		for (len = pmsg->len, j = 0; len > 0; len -= 8, j += 8) {
+			u32 data[2] = { };
+
 			page_len = (len >= 8) ? 8 : len;
 
 			if (pmsg->flags & I2C_M_RD) {
@@ -198,7 +199,8 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			} else {
 				memcpy(data, &pmsg->buf[j], page_len);
 				iowrite32(data[0], i2c->base + REG_SM0D0_REG);
-				iowrite32(data[1], i2c->base + REG_SM0D1_REG);
+				if (page_len > 4)
+					iowrite32(data[1], i2c->base + REG_SM0D1_REG);
 				cmd = SM0CTL1_WRITE;
 			}
 
@@ -208,7 +210,8 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
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



