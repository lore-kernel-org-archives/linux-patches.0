Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EF72E92BC;
	Tue, 17 Jun 2025 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176154; cv=none; b=rtMZ6Wv72t8eCUT/yo92FoTcMTh5/ihoI1ZvG5fnKRggx7HX7lp9io0Ll5BVqK4DYKCy2s5NGroKIajs4fWupM7VEO9INyumxX/cforXqaC1DS91ne+8/KhfN/Yc2WkXRoHim/UEPX6mqFqI/2waJVQwkHgi5T5cHc4Cu+k0vDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176154; c=relaxed/simple;
	bh=geJjy+4O1jmnbAHeeGfg8KPO4kYPYsyRx0GSkA85Mvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txE0uoW8QBounfMZEIczG4R2kLygw0WxMsXGRZc/mRBQIU8r00qTO8sDOqMwQXWDKM+v67bfAc+PYASTh+5WYYOTTbwIf1y+EItjfky+fbajzdfqU5pOttqF71QywlkuW3Oq5QZOWYIar5DrPPiQ7zfFoGLFNow5xQCjEwbHc/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yz50JD07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yz50JD07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545DAC4CEF0;
	Tue, 17 Jun 2025 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176153;
	bh=geJjy+4O1jmnbAHeeGfg8KPO4kYPYsyRx0GSkA85Mvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yz50JD07142t+Qo3JzTseybeQKAHRVV5O1ZRimCWd1r1bkoai25/pSzDg9kS6Z7C7
	 IjrUvWEpMhh71TH98/hl4FEWFJqJ+KLsOS+f7LjopSryznVx+8nJq2noxoqCMveG7z
	 IouKXW7t/ILZPnJsqLCYuI4tJvx3fLtvrJBlR5u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/356] spi: bcm63xx-hsspi: fix shared reset
Date: Tue, 17 Jun 2025 17:26:05 +0200
Message-ID: <20250617152348.266504375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 3d6d84c8f2f66d3fd6a43a1e2ce8e6b54c573960 ]

Some bmips SoCs (bcm6362, bcm63268) share the same SPI reset for both SPI
and HSSPI controllers, so reset shouldn't be exclusive.

Fixes: 0eeadddbf09a ("spi: bcm63xx-hsspi: add reset support")
Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529130915.2519590-3-noltari@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 1ca857c2a4aa3..8df12efeea21c 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -745,7 +745,7 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	reset = devm_reset_control_get_optional_shared(dev, NULL);
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-- 
2.39.5



