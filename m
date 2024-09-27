Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9999318C334;
	Fri, 27 Sep 2024 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440270; cv=none; b=U4jkgMJ9YFseNBAN872Ab37AUggCoaLt9Qh4aL+QVHb4hQsh929R4PEjieFD7dHrp6w15UduLZrUMKmg0RZ3XMRO6g1uIVo+Izm07P0tHpneyTkc8wKYkAPzhd9CkvwEy3YuQO1HWZwrrO1IaOC7UA4J10cFoJAPiOOBPJ+A2Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440270; c=relaxed/simple;
	bh=j7i18h0Cjbc219rJ6+w+9RSlzCJEEwL4Zj1w+SmHdSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQXeN2iRZfzOwzkgi5qSES0wCiGJENbWdvq9+x63gNKlrrlDF/jWzyLhmy4vbIFUQ37rVTXxOy8YsDNmJo3xDF+OuLuyFYd9nAt3vVFzPG3Aia3N9tpN2rftmV8Mha0ZjGDEYpKdhmxONKWHY/Dyxm7safV01F4BdomFSejy/Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3ehjURh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3ehjURh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9CCC4CEC4;
	Fri, 27 Sep 2024 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440270;
	bh=j7i18h0Cjbc219rJ6+w+9RSlzCJEEwL4Zj1w+SmHdSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3ehjURhvXag0nBqhwz5C6kyk3ZDPCxv5aDFv98R8aEabOE4xhQZ0Q1DPHNgzGjKR
	 jyYdZ4tAk0rK4MqMgm1kzfFiEseZceXkhfQZy/HFFxTz4nVcfSB5+xrBgGxRjwn583
	 gZyUXWOzpxqLVl70SlshKLxT5CgaAn6H5IDbuU2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/73] spi: spidev: Add an entry for elgin,jg10309-01
Date: Fri, 27 Sep 2024 14:23:33 +0200
Message-ID: <20240927121720.786280957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 5f3eee1eef5d0edd23d8ac0974f56283649a1512 ]

The rv1108-elgin-r1 board has an LCD controlled via SPI in userspace.
The marking on the LCD is JG10309-01.

Add the "elgin,jg10309-01" compatible string.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20240828180057.3167190-2-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 477c3578e7d9e..7ae032f8de63c 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -722,6 +722,7 @@ static int spidev_of_check(struct device *dev)
 static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
+	{ .compatible = "elgin,jg10309-01", .data = &spidev_of_check },
 	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
-- 
2.43.0



