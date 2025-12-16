Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58835355029;
	Tue, 16 Dec 2025 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885952; cv=none; b=WExqObFxGqnZ4Y9BEX7WSE8kgiObUQFSS3OcnvYmo7QAg4hfPG8kKKLvwak06nJm8Va+iDJ/utRBWlX+XfokFrFXNHKsNtsPOh/JbOuFJtOUuKSanLxA8cfue8i0RLd+KFy8jlTpGoVi63UD9XShygShlK0TyqJpn++BVwY91bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885952; c=relaxed/simple;
	bh=iT8OnL2vG91fWzoBOOO7o9MdVHKHmQKdBlof5MSSOZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhpUCDdK2VJOba6l94k0A0I4QmoIRt9JeFmYrclIvq47/9Q57k194KjRUN3KhhLakzebjwrXrb27+tEVdryq8Z2MPvUwx+AaVxEj8bSENmBexvoRXK7U3Q5dM26Sv0KbipzUG8+RioYozIXevMk+x3XMhE32dWvNQgBwthac+Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAj6QzN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAj6QzN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2187C4CEF1;
	Tue, 16 Dec 2025 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885952;
	bh=iT8OnL2vG91fWzoBOOO7o9MdVHKHmQKdBlof5MSSOZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAj6QzN408LstAy/pET13ED+y7uaXHmiOqgoP3zWpo6DiN9ExmtfWRgD75tdIlnKk
	 JcJwawVcJypnp2wTbPsvz0uYNujtu6PsTaseH6GjOXI968rF8ooeuQoCJn2zrnbZS/
	 quhSj5Br1EjHeJFBu5Y1sKMvidZYbki0I7HWv9O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Algea Cao <algea.cao@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 294/507] phy: rockchip: samsung-hdptx: Reduce ROPLL loop bandwidth
Date: Tue, 16 Dec 2025 12:12:15 +0100
Message-ID: <20251216111356.127313213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 8daaced9f5eeb4a2c8ca08b0a8286b6a498a8387 ]

Due to its relatively low frequency, a noise stemming from the 24MHz PLL
reference clock may traverse the low-pass loop filter of ROPLL, which
could potentially generate some HDMI flash artifacts.

Reduce ROPLL loop bandwidth in an attempt to mitigate the problem.

Fixes: 553be2830c5f ("phy: rockchip: Add Samsung HDMI/eDP Combo PHY driver")
Co-developed-by: Algea Cao <algea.cao@rock-chips.com>
Signed-off-by: Algea Cao <algea.cao@rock-chips.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251028-phy-hdptx-fixes-v1-2-ecc642a59d94@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 8adf6e84fc0b7..9751f7ad00f4f 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -500,9 +500,7 @@ static const struct reg_sequence rk_hdtpx_common_cmn_init_seq[] = {
 	REG_SEQ0(CMN_REG(0043), 0x00),
 	REG_SEQ0(CMN_REG(0044), 0x46),
 	REG_SEQ0(CMN_REG(0045), 0x24),
-	REG_SEQ0(CMN_REG(0046), 0xff),
 	REG_SEQ0(CMN_REG(0047), 0x00),
-	REG_SEQ0(CMN_REG(0048), 0x44),
 	REG_SEQ0(CMN_REG(0049), 0xfa),
 	REG_SEQ0(CMN_REG(004a), 0x08),
 	REG_SEQ0(CMN_REG(004b), 0x00),
@@ -575,6 +573,8 @@ static const struct reg_sequence rk_hdtpx_tmds_cmn_init_seq[] = {
 	REG_SEQ0(CMN_REG(0034), 0x00),
 	REG_SEQ0(CMN_REG(003d), 0x40),
 	REG_SEQ0(CMN_REG(0042), 0x78),
+	REG_SEQ0(CMN_REG(0046), 0xdd),
+	REG_SEQ0(CMN_REG(0048), 0x11),
 	REG_SEQ0(CMN_REG(004e), 0x34),
 	REG_SEQ0(CMN_REG(005c), 0x25),
 	REG_SEQ0(CMN_REG(005e), 0x4f),
-- 
2.51.0



