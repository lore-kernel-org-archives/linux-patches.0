Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C601E9914;
	Wed, 15 Jan 2025 10:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938526; cv=none; b=rR3FbBLlstyqIUbkqeO98FaAlWs2CuzxNsfTJI31xIWXUUyrJs91x5EjLlapq0YRCA5D9ZwaY5n+5goDk/FHSKEdA+qCROclGMAJUDeIZr9cMXFXmYvYeNv7zF8VC83y3mSdzBp1bc2ngy//LgZcDwWinv1NiZBl4GIgHYzdnAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938526; c=relaxed/simple;
	bh=wMu6hkGc7oLuDnXzXa3xnNk2MDCzu5lNGf1cdZcHMlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBT5uJID+casFWqAKygjkYK5fxIg3L+7UkJdjq+MVtPM+R+VnFsTZRykyNpCa93r4UO5E5oBzN+vH1EMD6XIUFoOAXz97l/HP3DSCSMyyel3HbCztVX00Kthitg8Pcb4kwNGBUa59dbX/RZ/9qj2IVGQYDIpXXD8jiQkwcjq524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeeypMjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeeypMjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE5AC4CEE6;
	Wed, 15 Jan 2025 10:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938526;
	bh=wMu6hkGc7oLuDnXzXa3xnNk2MDCzu5lNGf1cdZcHMlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeeypMjW0uJO0nmhQR3MXF3OoYA/twOqLHBQfKzkSHfUZqX8dY+7621Y+S9MspIdf
	 z5qhqlkIt4SdZ/Oi/8PtU+6baeQhQnbH+WnfRdpDPF3xRwxw9Ysmbli434kT6evmZa
	 X02SorBxoBI66jXmqyJA1dv/ka+97WKed/LIQw3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Simon Horman <horms@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/129] ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_probe()
Date: Wed, 15 Jan 2025 11:36:33 +0100
Message-ID: <20250115103555.095044312@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit 2c87309ea741341c6722efdf1fb3f50dd427c823 ]

ca8210_test_interface_init() returns the result of kfifo_alloc(),
which can be non-zero in case of an error. The caller, ca8210_probe(),
should check the return value and do error-handling if it fails.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20241029182712.318271-1-keisuke.nishimura@inria.fr
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 4ec0dab38872..0a0ad3d77557 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3078,7 +3078,11 @@ static int ca8210_probe(struct spi_device *spi_device)
 	spi_set_drvdata(priv->spi, priv);
 	if (IS_ENABLED(CONFIG_IEEE802154_CA8210_DEBUGFS)) {
 		cascoda_api_upstream = ca8210_test_int_driver_write;
-		ca8210_test_interface_init(priv);
+		ret = ca8210_test_interface_init(priv);
+		if (ret) {
+			dev_crit(&spi_device->dev, "ca8210_test_interface_init failed\n");
+			goto error;
+		}
 	} else {
 		cascoda_api_upstream = NULL;
 	}
-- 
2.39.5



