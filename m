Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62D71C225E;
	Thu,  6 Jun 2024 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683644; cv=none; b=UcKbIQ2FlKjmQmKJwZafcCwkFHVekRxs9c0fGmo03DMNMGduIlW4VlTQR2yfeG72c9aAep+LDWDoWjpKCg1ygNgmOYOGrlazuL47p1vxrNJGhci8AlvlWhi0aLSGqSbqdOnGEIqcw1P8wthpJNWqfcNk7rAupPfreplSXZwFAis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683644; c=relaxed/simple;
	bh=VZK45EHt4b6yyV36AEGh+Qh7NoRhbmdKFy6WNuOEz0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fg1G11zJph60hsVwz8+p29evip2cXTpBkNoV/QPnWmq09eX5vPFm5xy7eU54EdScxCgpbBpZthb8dpAemCeJ1FhXQ9ixHUK7Rpu9HndJ1GTo1W7GklPcM7pE8fPQ3v3U/tk1ejoVTkmq7A9W8h3KdK4uldfJHW1piwnbQul+OUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3nDP89M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3nDP89M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EDDC4AF09;
	Thu,  6 Jun 2024 14:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683644;
	bh=VZK45EHt4b6yyV36AEGh+Qh7NoRhbmdKFy6WNuOEz0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3nDP89Md804WhlkcYmrrlhlYNfrdN/58E22x23zH3S6A7HzrspHOrbgMV2Sn5L/Q
	 ZF4tBq8/YxTiwAEY+A18AptZgilaRkZ9b1zcJlTj8wJjXA/bFGhidg75SJVtenbfUP
	 PP6Y7WruiWxQQhX4NHmdI/F+TMvrvrvIN2UxWmSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Jerry Ray <jerry.ray@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 464/473] net: dsa: microchip: fix RGMII error in KSZ DSA driver
Date: Thu,  6 Jun 2024 16:06:33 +0200
Message-ID: <20240606131715.025676759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 278d65ccdadb5f0fa0ceaf7b9cc97b305cd72822 ]

The driver should return RMII interface when XMII is running in RMII mode.

Fixes: 0ab7f6bf1675 ("net: dsa: microchip: ksz9477: use common xmii function")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Acked-by: Jerry Ray <jerry.ray@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/1716932066-3342-1-git-send-email-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index dc9eea3c8ab16..f9f43897f86c1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2540,7 +2540,7 @@ phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit)
 		else
 			interface = PHY_INTERFACE_MODE_MII;
 	} else if (val == bitval[P_RMII_SEL]) {
-		interface = PHY_INTERFACE_MODE_RGMII;
+		interface = PHY_INTERFACE_MODE_RMII;
 	} else {
 		interface = PHY_INTERFACE_MODE_RGMII;
 		if (data8 & P_RGMII_ID_EG_ENABLE)
-- 
2.43.0



