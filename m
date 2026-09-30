Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2872E5158A8;
	Wed, 30 Sep 2026 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786791; cv=none; b=drQyF5gyhxxoB4xzNJKxzPk+40ldoVV8WcAlCxCBhUYT6HzB9L6S2A+xLpadZCzJQHwzdk4suu3bYuxxORZsQ/0bvZXp+t8xvrAyycO4jfXoYrDXR7usL6KlZYGiKqJ901mU1gvav2Fm5JjaNUk50cbpkIlNQDYg5GPVgJL+Ow0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786791; c=relaxed/simple;
	bh=YsTnUFXgNaA+bVs2oQ7A0XAKa/4bqyrP98aihOQ7EjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTnOq0XFNC3n8VQn1PS6Pt1uHrjzA+B4igiNe2mqQVxvwneulxCDNUq2oV8gJVf6d4WVs2Dn85B+kLz31eG5jOsWhjMTHybarIxesMyg92q9hAdAolSbJC4j2jGpCkueO7ag5xcSZT7mHB/cotgTF7s/VEv2+8w11vB6i+ybPVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/zzTk+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/zzTk+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AB61F000FF;
	Wed, 30 Sep 2026 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786790;
	bh=JwT4WAu+rgkfGrxTNkV9avhducljB6x/CRF1Ilsz00w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/zzTk+fEiLZ6NWhbE/D3Et9Z9m+kl2P1nqmAF6+0HlIIDVIMH7yVH87Kq/dnGZnW
	 YKUhXY9eTFk5t+h8Vt7h6Tk8ILXwm3N07Jm6OOex9kztcsa/lZQkAXetaBIRt4K2Pg
	 8zqOczvwgc852TxGRa12YaywzKlTeyukGo6dgz+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 6.1 979/982] lan78xx: Enable 125 MHz CLK configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:28:35 +0200
Message-ID: <20260930152437.771880846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 5160b129f65fc6e1a4aa282d44f824e12aa800ee upstream.

The 125MHz and 25MHz clock configurations are enabled in the initialization
regardless of EEPROM (125MHz is needed for RGMII 1000Mbps operation). After
a lite reset (lan78xx_reset), these contents go back to defaults(all 0, so
no 125MHz or 25MHz clock).

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20240529140256.1849764-2-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Minh Tiến Nguyễn <zizuzacker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2979,6 +2979,8 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	buf |= HW_CFG_MEF_;
+	buf |= HW_CFG_CLK125_EN_;
+	buf |= HW_CFG_REFCLK25_EN_;
 
 	ret = lan78xx_write_reg(dev, HW_CFG, buf);
 	if (ret < 0)


