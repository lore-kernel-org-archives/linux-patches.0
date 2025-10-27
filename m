Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9893F31B123;
	Mon, 27 Oct 2025 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590535; cv=none; b=uBp2Gvda5ITbCGcKPhNDbdfZucw32Blb79HVBP8p1Ky+G8VLa/vvcUwrUfFmmjUSOfIKtv2J/jfZZcRi+FckpOovn6Jj+J/xnlSZmssvUDXRensi/3xo/N6NEc4C2nhP5A3cg42KumPXAxOd6p9agc2SuLnTxFLeu/HkSohKiqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590535; c=relaxed/simple;
	bh=U7MC9Y6rbyOFLENi0mOiiLJuAxQj6jEAErfxL5Xc2o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjxMXo+8n0KDbg3XFJFe7QTvGPsl/Kfh5lwMDER7Q+zYBPkysMd/qaf8yRE8mb1lod7EfPnEqPLXeCgsuXcgsQheQ13gj1XB6TVQfu9krPWAHAC61X3Blf+2tpThslMUimYsJzXwHzStwecZyo2UIQmcxOxzy7185Ml766HZ8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgydveIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgydveIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12B9C113D0;
	Mon, 27 Oct 2025 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590535;
	bh=U7MC9Y6rbyOFLENi0mOiiLJuAxQj6jEAErfxL5Xc2o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgydveIWhagUTUfNZBIM/+LlvtIVBFAftJ0fXEAmHvTidij6OUN2Rp+wKvYNCVfT5
	 OjSZF2Lal5jX1f2uC8VK2IilxAgt7xmQGLsjIzWpjyV2TQn5QUdJCW8g500CkKsPwZ
	 XBdlWEaXHlShe9Y8etNSW3AHu21//B9AoqxYdZ9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/224] rtc: x1205: Fix Xicor X1205 vendor prefix
Date: Mon, 27 Oct 2025 19:33:47 +0100
Message-ID: <20251027183511.164406444@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 606d19ee37de3a72f1b6e95a4ea544f6f20dbb46 ]

The vendor for the X1205 RTC is not Xircom, but Xicor which was acquired
by Intersil. Since the I2C subsystem drops the vendor prefix for driver
matching, the vendor prefix hasn't mattered.

Fixes: 6875404fdb44 ("rtc: x1205: Add DT probing support")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250821215703.869628-2-robh@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-x1205.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index d1d5a44d9122a..3b3aaa7d8283c 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -671,7 +671,7 @@ static const struct i2c_device_id x1205_id[] = {
 MODULE_DEVICE_TABLE(i2c, x1205_id);
 
 static const struct of_device_id x1205_dt_ids[] = {
-	{ .compatible = "xircom,x1205", },
+	{ .compatible = "xicor,x1205", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, x1205_dt_ids);
-- 
2.51.0



