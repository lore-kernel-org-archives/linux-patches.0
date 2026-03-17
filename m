Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A72226E706;
	Tue, 17 Mar 2026 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767476; cv=none; b=OPKq4yeKPfcSX+26BwMS6JDuXXkjNYvzEaVSiA+ZbNLkJyP1AcMqluVIIo3AvuJN1+OTf1jwGjhHlmsaEizKu4F2Oo7Q8JFHoLVaP9NwNcZd3Wlc501GWPJuY3r2H5cYixxbuDkLJ2VaEG5b+eQLmrTyvp2/hu/tIoTLRwF/K4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767476; c=relaxed/simple;
	bh=6/uQFQEeZQ8vM29YZFuvmlb9CM6cTTu7tZ0AJMcYHl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrf262LdKVWPSoIeqGHclPK924jee9Y1Rn2k5onm1g5xMkPjZdeTqyszWVVlvOvl4LnP+4REV3IxCZtai7SRkJfHIUUCJmg3vovPjgmgqLI1aZZnl1pBRhXt0HKrrAF77crJRPJIuZ9CDXdMvNv1j7tRh1Hlu0eIHSMXvFOln/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VigRoEMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VigRoEMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56413C4CEF7;
	Tue, 17 Mar 2026 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767476;
	bh=6/uQFQEeZQ8vM29YZFuvmlb9CM6cTTu7tZ0AJMcYHl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VigRoEMXXBMEjFHMK3yzgUPRisU8w9ytIzjdBhuRcEZQRL4vFb/6CccjLduwGVDHv
	 csBwKiQf4Kf4fEpTMC6eAnxytl+IHsg/+pk8xs8+UcCreSzoJajzUv8bySgg7sAD29
	 /j81YO+Mz7RkMtXRoy9eCKXTECqGtyJBc+JE+TTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/333] net: dsa: realtek: Fix LED group port bit for non-zero LED group
Date: Tue, 17 Mar 2026 17:32:03 +0100
Message-ID: <20260317163002.856548766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



