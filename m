Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34323328FE;
	Fri, 17 Oct 2025 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714085; cv=none; b=VMUucUonAcnWvYmRN/DFUXwMHLOKt6quGWFghYoj7diU+qt1+MWe6Gv/PtSonxtnPUs/pRTPgh52hrTLjZ/d1cVlc/s0eL6LTGd8yGKX3a8JBS+gvS66WXr/qGNiWEmQq+qDSvHf4LnLEod6eihSiLtKaVVT6RPmPUoQgCHDML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714085; c=relaxed/simple;
	bh=4IcOjbzdmUFqBjNdfI65RV+SwdvtaJldsJ3QYSVM114=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6HInbTSoBqVwH7KalKX7HEbBfQ9IM5dCzAVWgrzVhQvVzuzCy/43BPs3m03On5Udl6gc0JREI7+Tg6F0e9gjj+6jNzlYvEcir9WuF+93iphJ8jUiL1rrSyfAScczfeY6GEaUiDDsScpYC2dEbxoqAId4Nqtpo37GEeYfGQAo0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQy5EKAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQy5EKAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBCDC4CEE7;
	Fri, 17 Oct 2025 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714084;
	bh=4IcOjbzdmUFqBjNdfI65RV+SwdvtaJldsJ3QYSVM114=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQy5EKAHG3WwdumQmUK1v5xg5DTrgcoIxGel1HVn5O5EyAdJSHu2JulBn5X9Bsx/R
	 Fujaqp1GJR9g6OdThr1tfsx0WUtYII2D3sSaXw4HU8VLiEsF4ahUntOYDds1o7WvGU
	 lwseybXT3WhibAuKFlDZE9xdnWMaq/KL54pgd4CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/277] rtc: x1205: Fix Xicor X1205 vendor prefix
Date: Fri, 17 Oct 2025 16:50:28 +0200
Message-ID: <20251017145147.922630783@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4bcd7ca32f27b..b8a0fccef14e0 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -669,7 +669,7 @@ static const struct i2c_device_id x1205_id[] = {
 MODULE_DEVICE_TABLE(i2c, x1205_id);
 
 static const struct of_device_id x1205_dt_ids[] = {
-	{ .compatible = "xircom,x1205", },
+	{ .compatible = "xicor,x1205", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, x1205_dt_ids);
-- 
2.51.0



