Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD7C1D07A6;
	Wed,  2 Oct 2024 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876553; cv=none; b=LTISS5W7dE9VQ+gb7bqY0zBVcVwz2+ZUieaLKiEBM9SvehHTxgMU0B4S1fXeoYSyXn4+WX/kSvb6/YY4LiF268Q7LNB8AR+eifw4RWVjyuSGgKUIw7IqbxlURMDxWHmZHZz69xpMcrwQju3353Tt5P67PYKT6abc3JC7pHjUQ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876553; c=relaxed/simple;
	bh=c53//+4YNvci6+q+XPlh81uQqdbqHwZ5AORfsIW7OZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DchzrW8reUiNnICvMM/ycg54ABxTb5F1aUc7NUO4RKy6RHsAckzwhzb6mwgQQ7Qro81axV+sMiUJHCSCaMQZy4/jUCX/ZthtuJYYp3grtw+S2RrRsy4xOZ04EHTRC4R1noP3e6mNxqYm/2/hL7cS2ZA3yflL0QTS9xpGSN9c3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=di4TnCFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="di4TnCFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45850C4CEC5;
	Wed,  2 Oct 2024 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876553;
	bh=c53//+4YNvci6+q+XPlh81uQqdbqHwZ5AORfsIW7OZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=di4TnCFe4LWN/9kpeRLg04ts5mO6ZrTFXZ0KQ/3OTdiib3WDo9MGl7yH98TNb52b4
	 GJXdSGmqm6TdYp2FvsTZKcmRWHXFfx3XkXpwoS7f29MGQwYii3UzLAuLFzbSiEavoS
	 yPDRvAORdBBMkTeNijviF2qStGLRe0e9tMtc7+PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 483/695] net: phy: aquantia: fix setting active_low bit
Date: Wed,  2 Oct 2024 14:58:01 +0200
Message-ID: <20241002125841.750534653@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit d2b366c43443a21d9bcf047f3ee1f09cf9792dc4 ]

phy_modify_mmd was used wrongly in aqr_phy_led_active_low_set() resulting
in a no-op instead of setting the VEND1_GLOBAL_LED_DRIVE_VDD bit.
Correctly set VEND1_GLOBAL_LED_DRIVE_VDD bit.

Fixes: 61578f679378 ("net: phy: aquantia: add support for PHY LEDs")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/ab963584b0a7e3b4dac39472a4b82ca264d79630.1726580902.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia/aquantia_leds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia/aquantia_leds.c b/drivers/net/phy/aquantia/aquantia_leds.c
index 0516ac02c3f81..201c8df93fad9 100644
--- a/drivers/net/phy/aquantia/aquantia_leds.c
+++ b/drivers/net/phy/aquantia/aquantia_leds.c
@@ -120,7 +120,8 @@ int aqr_phy_led_hw_control_set(struct phy_device *phydev, u8 index,
 int aqr_phy_led_active_low_set(struct phy_device *phydev, int index, bool enable)
 {
 	return phy_modify_mmd(phydev, MDIO_MMD_VEND1, AQR_LED_DRIVE(index),
-			      VEND1_GLOBAL_LED_DRIVE_VDD, enable);
+			      VEND1_GLOBAL_LED_DRIVE_VDD,
+			      enable ? VEND1_GLOBAL_LED_DRIVE_VDD : 0);
 }
 
 int aqr_phy_led_polarity_set(struct phy_device *phydev, int index, unsigned long modes)
-- 
2.43.0



