Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1823B7B98;
	Tue, 21 Jul 2026 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667337; cv=none; b=JD0tsN4UEMcUV0+kSWDtZGmDDQ6Mbjjv5V/rqEGax19wVzoXkm8163hJLZfpia4R+t3vLN+jbfW8RQTeENb8jSmWDwZK/tpYgyJLmOmAV3ffXQmmqM086LEcT31DFOSfffT0lpSiPdn6Wyd1Sk1+rb7APerG39yMs2sK06BZgbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667337; c=relaxed/simple;
	bh=wGqL9zAefBrWH4dCzTRyMfxO2DfKNYMB1+qPWxBwKTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwr8LwYr4CRBxop5s5Y+sNtT3x+bU2Tc11SaSLg5cDm0xH8/sXGXLcfDthxxzDwzlxPHdWxGmtcnhq0DlNqUtxfg/wLUH3mG6EJIO04/ZJMcXcKNBPcr/ysGD8x9Tis2J30O82VTLl5az8lEqK4jHc82/hKrbcjkUiwUHJ9Gq8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYj5KYLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYj5KYLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC771F00A3A;
	Tue, 21 Jul 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667336;
	bh=v4eQsYXFlT5Xev7REHFFu4dPWPBDAqrEgPUhIo6B6Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYj5KYLGgQG6BpGYmJmZnbEopcAJnWFH93n5B7x4VK/jiQcpynH1NKNXlRrVkkZpv
	 UQ7XfMyGZVrA5ozekqx25mKnvVPI11gHwtE6ur+YI/7elx/GKJxi/OovSfUTUn/ii6
	 ShS0JUO//MdLdiyGqo04cX4VWcHDa59rQTF0+1pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Vivchar <rva333@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 1024/1266] i2c: mediatek: fix WRRD for SoCs without auto_restart option
Date: Tue, 21 Jul 2026 17:24:21 +0200
Message-ID: <20260721152504.740323003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Vivchar <rva333@protonmail.com>

commit deb35336b5bfed5db9231b5348bc1514db930797 upstream.

MediaTek mt65xx family SoCs have no auto restart, however, they still
support the WRRD mode in the hardware. Because auto_restart is set to 0,
the WRRD mode will be never enabled, leading to read errors.

Fix this by removing auto_restart check from the WRRD enable path.

Fixes: b49218365280 ("i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD")
Signed-off-by: Roman Vivchar <rva333@protonmail.com>
Cc: <stable@vger.kernel.org> # v6.18+
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260709-6572-6595-i2c-v2-1-b2fb8510d1d3@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mt65xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1253,7 +1253,7 @@ static int mtk_i2c_transfer(struct i2c_a
 	i2c->auto_restart = i2c->dev_comp->auto_restart;
 
 	/* checking if we can skip restart and optimize using WRRD mode */
-	if (i2c->auto_restart && num == 2) {
+	if (num == 2) {
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;


