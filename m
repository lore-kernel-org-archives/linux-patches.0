Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CE8224220;
	Tue, 17 Jun 2025 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177487; cv=none; b=YkMe9v3IAZ/3FgaSigJm3TExV0WZ9sV8nAtd+NQe9utLerPvasqNfUR/uriFpTL5rBnTWeYrhI5PqROJz8vTEYbL9pXRfp8yI91ejauGFbz8rp+G2JOfGTFzqksSHrtZMHm1kLzor0CL5vWdXJQKep15JcP0ph7ACbEsSDONCQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177487; c=relaxed/simple;
	bh=VdPUrCoUYeE9LfJ+FU9GTOf2cKEBQLoWV1ZhMCS0p74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3fjH1S+ycBjYq46YdRHYIE8msaNv7yQ/fs9E8YcDhIYxU968UymC8OoNiETaYiuHdOpdGmkHEahFJ8Ry+VcWeUpSNnYKyW73f4rRJic3CdOBA88cQVwW0P3rTqXFBB+r29jkNFQgCI8VrWdpD3jkjaAFxcXinzlA+oWqqgNlTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb7wVhmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb7wVhmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D6FC4CEE3;
	Tue, 17 Jun 2025 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177487;
	bh=VdPUrCoUYeE9LfJ+FU9GTOf2cKEBQLoWV1ZhMCS0p74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bb7wVhmfzVQs+9VPYdYexTv985DG7+oDwva9JE5hpFvDyD0Kh07D1Mb6rnB6lIrV/
	 rRauB89Tr8pktv3dfTXdZPrr2oV1qzw/9Na+tJ7CG8YY8J2DAc4qwoNasKy78ZaF4E
	 VhMd8i7u1karV1+ZKVtTsDeB/X7dDUHSldCx1U3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/512] spi: bcm63xx-spi: fix shared reset
Date: Tue, 17 Jun 2025 17:25:19 +0200
Message-ID: <20250617152433.882197250@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef3a7226db125..a95badb7b7114 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -523,7 +523,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	reset = devm_reset_control_get_optional_shared(dev, NULL);
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-- 
2.39.5



