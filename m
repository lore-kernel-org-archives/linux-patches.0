Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018443;
	b=Z80DfxpG/N7+ZKpEVT26A5U98QLzaHhEvUqi/6HIe0WJm98m5Usom/Gind8mNopd9U66
	 QyFmNsvazHC0rdCAz0wwhKgHbcHgrI2lcbkzvx0fkuycTHMivNhZf+Nj0o42UfOsa8oiJ
	 g9d+YdiLCQIG2zuF5IvgKAqTqpv8oszWMERHAvdlCwLka34rbgWj7C+luXOMF59HN+utt
	 txozPl1eVgcE76JWGucNKJ4JYMlDxaTGtK/VibP5eW1CvGckQBhK2fNayOhjmS7MnhbW+
	 fDoe6Gi1p1jvPN5nlIduCylHmp1QgxDgUFGyvxKHq6FMOSNrm+7Q6dJ8sibCiW5pIQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odw6Fws0YUOoseq0nE3CdrE/OQAlWozmnlYBEhnHzG0=;
	b=PNTk2V0neOr9aYBAMJqfXv6eZntozMtuAvmCHonyeH4GgRstGF1vhJXdn2Ur0jLQrw55
	 0LD6FpxqMEdf+zYod93lorN409JG5JjPh1BVaM8oHmWpr9rr58CMRYYUY7DGLXqV2toR8
	 GJeZBpIXH6N/EtXRSZ3WO+N4Jz+dQfMDanjwTfX5qIB0UvieF1Ld/ZPGMqjFJ3VG07XnK
	 pka5P8yJxEqSlB1bzmLJpH//bijfSpHRmNFlT04H35Sc98UN0M6uiVdwMctShN+7UI6Em
	 rZz61QW9QsSoEDY5bLSiqubZvVqzd52yaBxkHNTkTrybmZrZ6NgOfQyXJU1rsAB09KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/xs0ieF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F69606A320;
	Wed, 18 Nov 2026 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/xs0ieF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21F61F000C4;
	Wed, 18 Nov 2026 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018443;
	bh=odw6Fws0YUOoseq0nE3CdrE/OQAlWozmnlYBEhnHzG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/xs0ieFDE+XaHDm1S9HN4VfHOWE8Gmc8QCQ4EmeXJXSIYHu77gGD6wI3ZnG4uP70
	 HwVbnBBPHx6j7a8gDm8aJMKG/iJw0n1D+mpnHVFUl5+J6xLYtVMJzzVAMFprF19yAY
	 1dVrWxt60SFYqTq4UPzno1XoR/DyqdjtR1CTMk0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1242/2651] phy: rockchip: samsung-hdptx: Handle PHY config after module reload
Date: Wed, 18 Nov 2026 15:41:22 +0100
Message-ID: <20261118150332.712465747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit a673b3d18e37e573d52bf41c47e75d46982f2fae ]

The pll_config_dirty mechanism introduced in commit aec3e4ce25da ("phy:
rockchip: samsung-hdptx: Handle uncommitted PHY config changes")
invalidates the clock rate in determine_rate() by resetting req->rate to
zero, ensuring CCF will invoke set_rate() to program pending PLL
configuration changes into hardware.

However, after a module reload cycle the PHY PLL clock gets
re-registered with CCF, which causes the framework's cached rate to also
be zero.  Setting req->rate to zero then has no effect, since CCF sees
no difference between the requested and current rates and skips calling
set_rate(), leaving the PLL unconfigured.

Address this by first computing the actual target rate from the HDMI
link configuration, and only then invalidating it when it matches the
CCF cached rate.

Fixes: aec3e4ce25da ("phy: rockchip: samsung-hdptx: Handle uncommitted PHY config changes")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260901-hdptx-ffe-v2-2-3a5922c76fc5@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 24ed0d7eb6f8d..b03042ec9a847 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -2346,14 +2346,16 @@ static int rk_hdptx_phy_clk_determine_rate(struct clk_hw *hw,
 	 * to ensure rk_hdptx_phy_clk_set_rate() will be always invoked.
 	 * Otherwise, restrict the rate according to the PHY link setup.
 	 */
-	if (hdptx->pll_config_dirty)
-		req->rate = 0;
-	else if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL)
+
+	if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL)
 		req->rate = hdptx->hdmi_cfg.rate;
 	else
 		req->rate = DIV_ROUND_CLOSEST_ULL(hdptx->hdmi_cfg.rate * 8,
 						  hdptx->hdmi_cfg.bpc);
 
+	if (hdptx->pll_config_dirty && req->rate == clk_hw_get_rate(hw))
+		req->rate = 0;
+
 	return 0;
 }
 
-- 
2.53.0



