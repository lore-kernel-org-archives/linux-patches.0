Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68B1DE4CB;
	Tue,  8 Oct 2024 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394159; cv=none; b=AimyUiZdRzPrkpojDr/tJFzFun1PN7rgTNDvW3byLM6LQSCjxMmDsfZ9Kby3XyP+eA1vtCn9bjMHLvAlENksDAr+ngpeB/ZnqZWK12byIuf3h2xLH5thCy1sltkDDzu1xq4pSywsTnFcRrIKW4kKinU2JvfV+gagXDX79Wco/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394159; c=relaxed/simple;
	bh=RsRUjQFUGkGZeT/ifaRkir4ZzxPAwQnqGeH3NOEazPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SunGBFNGp9iDwn/gXL0NETphCVIelgZWKvjZhkpdPjGGkrjWwyuieVY7dlg7AcwfqBa/Nx2JNCZg3Px3tktUjkXVSYdWRCnvWMEpnaoHNLPQ0OJelQAFlJ/f1RjopV/Mp71US0qQT6s9i6XC0O5raeK6lBEdRW/HNZNVdm8yjTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWyi8Mko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWyi8Mko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAF6C4CEC7;
	Tue,  8 Oct 2024 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394158;
	bh=RsRUjQFUGkGZeT/ifaRkir4ZzxPAwQnqGeH3NOEazPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWyi8MkoxU/Dvq6Mo6vBHVsGiNH6d9bkGC5CCi3PJE1lDwPtfypeDgJ9o5qBhPgth
	 W3i2LV8VFNmFODXFYIGWlXFmyVn7AQctvXrm38q3ULpHwONk2uV+QsloPA3kBcbJm2
	 iCXzmabv0TV/EJT7nc6Sno9xftW1M8vr1a2ftzAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/386] i2c: synquacer: Remove a clk reference from struct synquacer_i2c
Date: Tue,  8 Oct 2024 14:09:38 +0200
Message-ID: <20241008115642.487018569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e6722ea6b9ed731f7392277d76ca912dfffca7ee ]

'pclk' is only used locally in the probe. Remove it from the
'synquacer_i2c' structure.

Also remove a useless debug message.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: f2990f863053 ("i2c: synquacer: Deal with optional PCLK correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-synquacer.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-synquacer.c b/drivers/i2c/busses/i2c-synquacer.c
index a73f5bb9a1645..e774b9f499b63 100644
--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -138,7 +138,6 @@ struct synquacer_i2c {
 	int			irq;
 	struct device		*dev;
 	void __iomem		*base;
-	struct clk		*pclk;
 	u32			pclkrate;
 	u32			speed_khz;
 	u32			timeout_ms;
@@ -535,6 +534,7 @@ static const struct i2c_adapter synquacer_i2c_ops = {
 static int synquacer_i2c_probe(struct platform_device *pdev)
 {
 	struct synquacer_i2c *i2c;
+	struct clk *pclk;
 	u32 bus_speed;
 	int ret;
 
@@ -550,13 +550,12 @@ static int synquacer_i2c_probe(struct platform_device *pdev)
 	device_property_read_u32(&pdev->dev, "socionext,pclk-rate",
 				 &i2c->pclkrate);
 
-	i2c->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
-	if (IS_ERR(i2c->pclk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->pclk),
+	pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
+	if (IS_ERR(pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(pclk),
 				     "failed to get and enable clock\n");
 
-	dev_dbg(&pdev->dev, "clock source %p\n", i2c->pclk);
-	i2c->pclkrate = clk_get_rate(i2c->pclk);
+	i2c->pclkrate = clk_get_rate(pclk);
 
 	if (i2c->pclkrate < SYNQUACER_I2C_MIN_CLK_RATE ||
 	    i2c->pclkrate > SYNQUACER_I2C_MAX_CLK_RATE)
-- 
2.43.0



