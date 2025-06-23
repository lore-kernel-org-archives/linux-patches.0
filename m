Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA75724A06D;
	Mon, 23 Jun 2025 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686139; cv=none; b=BE+vNQAnMsow/E6AAHVOrDSOzdcmdX6JSgn01DqBqBngedSH9JDAaeL9Ybo0Ejdt/fb2cJV5GetKsV2HhXmUcN8zv+2NU9rVzrQlt6SsByou7Gz+D9qaBzKz4ahVaHYK8ACq5/Mr7bW1y48PcFOxkJyNbjlajs0mDXx4Wu1Tgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686139; c=relaxed/simple;
	bh=AvubVWhCH4vpvhwCSf8bZIZTaFWJgvplZV+nAdWTLek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pzq0RuyNMVp+41pUK1bkeAtkn1E7C+02mzTcf3g6S/vGEPeKAI1xQVEUDuECROaZjA98YROhxC0Y+ruNZCzXjGSN5hVrBw+H9xLmkYq/o/79sagKeNYRjoySTf93us3evta9Fywa63oTWKM5N7F2gN1VlGESHe6pF8tJiWPugTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTMJinUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTMJinUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB82C4CEEA;
	Mon, 23 Jun 2025 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686139;
	bh=AvubVWhCH4vpvhwCSf8bZIZTaFWJgvplZV+nAdWTLek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTMJinUtAFXJKkwtx2MN1FKPHB6h1r6YrqNfEuqi/+j0Yss4YqcS+Y1PZjC0Aprk4
	 rDPN68NDfEEoXv0FKeBY/R1etIKcxmnZIx56qQoH3KJKRIGGixOWtc44lV1ekwgwYl
	 LG9CQOW1nkAIBCDevYqeRDjNUzHY8yS2WN0z9Mkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/355] spi: bcm63xx-spi: fix shared reset
Date: Mon, 23 Jun 2025 15:05:01 +0200
Message-ID: <20250623130629.792769681@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 5ad20e3d8cfe3b2e42bbddc7e0ebaa74479bb589 ]

Some bmips SoCs (bcm6362, bcm63268) share the same SPI reset for both SPI
and HSSPI controllers, so reset shouldn't be exclusive.

Fixes: 38807adeaf1e ("spi: bcm63xx-spi: add reset support")
Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529130915.2519590-2-noltari@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index b31b5f4e959e5..da559b86f6b17 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -533,7 +533,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	reset = devm_reset_control_get_optional_shared(dev, NULL);
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-- 
2.39.5



