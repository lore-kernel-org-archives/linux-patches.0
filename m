Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6ED290F;
	Mon,  2 Jun 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875642; cv=none; b=pMPMWJbtwGvWozh1PBmRu3zyJKg/bt2b7WGUIf0rF22qc4yYoPgzOwW06isEidBXdS27gqjCmrDLT0KFEcbJqzWx5HBvXisCRHVCKYUfUPu5vVVrc3LT8Umq0uY3FWQtCcOsU1yl+VeyoLqm12ZzbrTxb3Ul8wKFftj1aGN6MGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875642; c=relaxed/simple;
	bh=Euvd478mm3Tkf9BbheQb2xWg96raW8k6YnsH4yciIIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu0uh41Ubd3V5OwXuNz06kvG7gBrzspeo/wVBv9UddWEQWroqFCtL490I2qnAKPygJYIOLdYnyl8DS7Ap7xtxMSucrQrEgxAIRLlJICikCXUsfy0bye/dTp4L6GUOwmrd54Gwd6t/G9JyQjMeaT0d40VezOlc6iL3Rc6YUCYwuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDucxkeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDucxkeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7CEC4CEEB;
	Mon,  2 Jun 2025 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875642;
	bh=Euvd478mm3Tkf9BbheQb2xWg96raW8k6YnsH4yciIIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDucxkeSxHD15xs/mTM/JPrSIoGelFiAY8+XqquSHAtNgZ4d6FaNPv0oGynmYsZ69
	 TftEjZdSDlNCNYx/WghiTnWVHxzjJgJlXiOTXST+y0tNCziY2gcXg3sfAiZFE3UltN
	 FiAgZi+VrbHEcsxr2q5TAzgoY+DEVhacfHLJ7lQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/270] ieee802154: ca8210: Use proper setters and getters for bitwise types
Date: Mon,  2 Jun 2025 15:47:23 +0200
Message-ID: <20250602134313.672138266@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 169b2262205836a5d1213ff44dca2962276bece1 ]

Sparse complains that the driver doesn't respect the bitwise types:

drivers/net/ieee802154/ca8210.c:1796:27: warning: incorrect type in assignment (different base types)
drivers/net/ieee802154/ca8210.c:1796:27:    expected restricted __le16 [addressable] [assigned] [usertype] pan_id
drivers/net/ieee802154/ca8210.c:1796:27:    got unsigned short [usertype]
drivers/net/ieee802154/ca8210.c:1801:25: warning: incorrect type in assignment (different base types)
drivers/net/ieee802154/ca8210.c:1801:25:    expected restricted __le16 [addressable] [assigned] [usertype] pan_id
drivers/net/ieee802154/ca8210.c:1801:25:    got unsigned short [usertype]
drivers/net/ieee802154/ca8210.c:1928:28: warning: incorrect type in argument 3 (different base types)
drivers/net/ieee802154/ca8210.c:1928:28:    expected unsigned short [usertype] dst_pan_id
drivers/net/ieee802154/ca8210.c:1928:28:    got restricted __le16 [addressable] [usertype] pan_id

Use proper setters and getters for bitwise types.

Note, in accordance with [1] the protocol is little endian.

Link: https://www.cascoda.com/wp-content/uploads/2018/11/CA-8210_datasheet_0418.pdf [1]
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250305105656.2133487-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 9a082910ec59f..35e2b7eb30761 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1488,8 +1488,7 @@ static u8 mcps_data_request(
 	command.pdata.data_req.src_addr_mode = src_addr_mode;
 	command.pdata.data_req.dst.mode = dst_address_mode;
 	if (dst_address_mode != MAC_MODE_NO_ADDR) {
-		command.pdata.data_req.dst.pan_id[0] = LS_BYTE(dst_pan_id);
-		command.pdata.data_req.dst.pan_id[1] = MS_BYTE(dst_pan_id);
+		put_unaligned_le16(dst_pan_id, command.pdata.data_req.dst.pan_id);
 		if (dst_address_mode == MAC_MODE_SHORT_ADDR) {
 			command.pdata.data_req.dst.address[0] = LS_BYTE(
 				dst_addr->short_address
@@ -1838,12 +1837,12 @@ static int ca8210_skb_rx(
 	}
 	hdr.source.mode = data_ind[0];
 	dev_dbg(&priv->spi->dev, "srcAddrMode: %#03x\n", hdr.source.mode);
-	hdr.source.pan_id = *(u16 *)&data_ind[1];
+	hdr.source.pan_id = cpu_to_le16(get_unaligned_le16(&data_ind[1]));
 	dev_dbg(&priv->spi->dev, "srcPanId: %#06x\n", hdr.source.pan_id);
 	memcpy(&hdr.source.extended_addr, &data_ind[3], 8);
 	hdr.dest.mode = data_ind[11];
 	dev_dbg(&priv->spi->dev, "dstAddrMode: %#03x\n", hdr.dest.mode);
-	hdr.dest.pan_id = *(u16 *)&data_ind[12];
+	hdr.dest.pan_id = cpu_to_le16(get_unaligned_le16(&data_ind[12]));
 	dev_dbg(&priv->spi->dev, "dstPanId: %#06x\n", hdr.dest.pan_id);
 	memcpy(&hdr.dest.extended_addr, &data_ind[14], 8);
 
@@ -1970,7 +1969,7 @@ static int ca8210_skb_tx(
 	status =  mcps_data_request(
 		header.source.mode,
 		header.dest.mode,
-		header.dest.pan_id,
+		le16_to_cpu(header.dest.pan_id),
 		(union macaddr *)&header.dest.extended_addr,
 		skb->len - mac_len,
 		&skb->data[mac_len],
-- 
2.39.5



