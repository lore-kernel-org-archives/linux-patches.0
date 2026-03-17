Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2853ED5C7;
	Tue, 17 Mar 2026 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765830; cv=none; b=KK47K/G2S33Gd7Jx+tW6S4hBIRRdwI1mh7AOXJvc32sEOT/zzOJp0+DwYPzKLKF+B0ZSL84gGH1nHAuLgDqQNl/toiUR39fhUNq1ThHiHpH31oaizqIQJTwZLvxi/t7YsN1WKqOqm5hA7GekfUR0NEwdRrOdOixmuM4SS2xnrKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765830; c=relaxed/simple;
	bh=WS2x6U5zPEE3DCVjACt36Cu1T0j3K1A80GQ882s6DRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ogg7AVcDvZCN6e91l8ciaBC09agiZsgUzXexUZ5GVQaLOnsh76I0FeOoSyrhnkdBRIlnWamebylpMHi9Wz9dC90yjzOcY8iQPLnfL0LI45W544uwfcq/z7kZT36aFqiB/ppPLLR20Bf5g6dSxSlNhMIV0aJP0WXzMV6OPfX5ABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrTt80RQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrTt80RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47256C4CEF7;
	Tue, 17 Mar 2026 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765830;
	bh=WS2x6U5zPEE3DCVjACt36Cu1T0j3K1A80GQ882s6DRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrTt80RQmQZuVJK1dYznHRUKyq3KVSj3hVkOPaWmqcJsuis6u4bZp6UqygIAFZUyA
	 ElFN+PEYtW+bGBuAekCkp+c895p53922Wyykl+BLqYKCibpmIEMv8BR3PzX7rp1rN/
	 lImyTP6+r2EZ1pFjGe0jVPvitrK+E16paGxMh/U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 105/378] net: dsa: realtek: Fix LED group port bit for non-zero LED group
Date: Tue, 17 Mar 2026 17:31:02 +0100
Message-ID: <20260317163010.880567641@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit e8f0dc024ce55451ebd54bad975134ba802e4fcc ]

The rtl8366rb_led_group_port_mask() function always returns LED port
bit in LED group 0; the switch statement returns the same thing in all
non-default cases.

This means that the driver does not currently support configuring LEDs
in non-zero LED groups.

Fix this.

Fixes: 32d617005475a71e ("net: dsa: realtek: add LED drivers for rtl8366rb")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260311111237.29002-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8366rb-leds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8366rb-leds.c b/drivers/net/dsa/realtek/rtl8366rb-leds.c
index 99c890681ae60..509ffd3f8db5c 100644
--- a/drivers/net/dsa/realtek/rtl8366rb-leds.c
+++ b/drivers/net/dsa/realtek/rtl8366rb-leds.c
@@ -12,11 +12,11 @@ static inline u32 rtl8366rb_led_group_port_mask(u8 led_group, u8 port)
 	case 0:
 		return FIELD_PREP(RTL8366RB_LED_0_X_CTRL_MASK, BIT(port));
 	case 1:
-		return FIELD_PREP(RTL8366RB_LED_0_X_CTRL_MASK, BIT(port));
+		return FIELD_PREP(RTL8366RB_LED_X_1_CTRL_MASK, BIT(port));
 	case 2:
-		return FIELD_PREP(RTL8366RB_LED_0_X_CTRL_MASK, BIT(port));
+		return FIELD_PREP(RTL8366RB_LED_2_X_CTRL_MASK, BIT(port));
 	case 3:
-		return FIELD_PREP(RTL8366RB_LED_0_X_CTRL_MASK, BIT(port));
+		return FIELD_PREP(RTL8366RB_LED_X_3_CTRL_MASK, BIT(port));
 	default:
 		return 0;
 	}
-- 
2.51.0



