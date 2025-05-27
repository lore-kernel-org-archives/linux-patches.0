Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E7C27A900;
	Tue, 27 May 2025 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364756; cv=none; b=gbodAPcOxd9ZEzLj3anFhrfPuhyjj3119Fr5ioAXhg5qp+lcKwvMyfLheEdQvNgNa9rKLFVv1BRlTDhcEKsFQEZdpKwxBiy+UEujjUO4AHEfKNRZTovffGu5oe/lFqcpUtkLz+beZzp00x/Fiu5/mFsPkIHjiN/zYEHwLAPq4kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364756; c=relaxed/simple;
	bh=2eK4mg4vbUTecGLNvk3njGVHO+oshAiMpxwtH2H6B9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFMExTCGN0FuWQEZJMOxJCM8sEifZvPlC+V8oVeqYJsqFToe8EnNCc97FBSrx8X672HAjvnybRn3v6lw8SdirZMpoJj8FgGY9jz75VfksVvitw437mQA5EnlBIsIhAh46V/0YO0igyiQ/ktehGcxBuJDh6k4kItmt7T0+3zDUNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoOb+/5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoOb+/5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2305C4CEE9;
	Tue, 27 May 2025 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364756;
	bh=2eK4mg4vbUTecGLNvk3njGVHO+oshAiMpxwtH2H6B9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoOb+/5t9ls0ImN96WfHzGnTgT4Id3IyB2GKRqaPA8rDALm/8mwWZYlJl9nbuxWpC
	 szZpEwXZEolSU9ocC/Fl4TpL4RWc0uAHplb/mSHiNHm2KOus/xVGIH1dCyxZAMG3K5
	 XbBf8brRSCM12VvJ+8Z25kd1u7LFmiF+zIzzDvqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shree Ramamoorthy <s-ramamoorthy@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/626] mfd: tps65219: Remove TPS65219_REG_TI_DEV_ID check
Date: Tue, 27 May 2025 18:20:50 +0200
Message-ID: <20250527162451.403258872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shree Ramamoorthy <s-ramamoorthy@ti.com>

[ Upstream commit 76b58d5111fdcffce615beb71520bc7a6f1742c9 ]

The chipid macro/variable and regmap_read function call is not needed
because the TPS65219_REG_TI_DEV_ID register value is not a consistent value
across TPS65219 PMIC config versions. Reading from the DEV_ID register
without a consistent value to compare it to isn't useful. There isn't a
way to verify the match data ID is the same ID read from the DEV_ID device
register. 0xF0 isn't a DEV_ID value consistent across TPS65219 NVM
configurations.

For TPS65215, there is a consistent value in bits 5-0 of the DEV_ID
register. However, there are other error checks in place within probe()
that apply to both PMICs rather than keeping this isolated check for one
PMIC.

Signed-off-by: Shree Ramamoorthy <s-ramamoorthy@ti.com>
Link: https://lore.kernel.org/r/20250206173725.386720-4-s-ramamoorthy@ti.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65219.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index 57ff5cb294a66..d3b77abec786e 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -228,7 +228,6 @@ static const struct regmap_irq_chip tps65219_irq_chip = {
 static int tps65219_probe(struct i2c_client *client)
 {
 	struct tps65219 *tps;
-	unsigned int chipid;
 	bool pwr_button;
 	int ret;
 
@@ -253,12 +252,6 @@ static int tps65219_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
-	ret = regmap_read(tps->regmap, TPS65219_REG_TI_DEV_ID, &chipid);
-	if (ret) {
-		dev_err(tps->dev, "Failed to read device ID: %d\n", ret);
-		return ret;
-	}
-
 	ret = devm_mfd_add_devices(tps->dev, PLATFORM_DEVID_AUTO,
 				   tps65219_cells, ARRAY_SIZE(tps65219_cells),
 				   NULL, 0, regmap_irq_get_domain(tps->irq_data));
-- 
2.39.5



