Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202A36404E;
	Tue, 16 Dec 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887916; cv=none; b=rAUeKwiofKUJP6K1soN/Jhcbfe+7Hfj4RlxQva6KPL0JfXZB9Qs0rtOSCFCzQjr14MwH4tVdENVdF3NDDdh3+pFgaso36brxmVpLtAHBOfmAG+KGfrTGU4TPZb4kOme7ar6PNvRquxmQXi0eGAh8M25swAqdXmjmajMZIXsAYUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887916; c=relaxed/simple;
	bh=cgR7hawmkhRVDYeen3hZcZZLiKZ3makGR5cfzAxXUzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CX8zoRIb2J4wJIvoyDs/abvW8AFOuibXcv9aIQ7mSCh6lhAv18ap0JPW4YooqYatVu0PsjrhP7aB2ZxtSxa/oQ8X6J0Ez/0GUT6asbGKNTLC3dpqdbWd5jazuykVwUdTQlcB275l0usni5OBfWmGYSWOBp0KDUnsljwy2avhuZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ch0wk3VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ch0wk3VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B41AC4CEF1;
	Tue, 16 Dec 2025 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887915;
	bh=cgR7hawmkhRVDYeen3hZcZZLiKZ3makGR5cfzAxXUzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ch0wk3VFQpXejar30Odg+H1qsR/mS6rjAXEdOLZMilt2u9J6YptcO5TqPPW9ZzP5L
	 lBOwuKWn774ZEYszaUd1MRkWtE+tBmQMVrIqIHiJj8gOUodRZHRY/cfUBYRmmRdSSG
	 AyYWajdi6w8VHt7TCm3iYSYhq6Pm5Sit98PP5ETg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Algea Cao <algea.cao@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 349/614] phy: rockchip: samsung-hdptx: Reduce ROPLL loop bandwidth
Date: Tue, 16 Dec 2025 12:11:56 +0100
Message-ID: <20251216111414.007680971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aee03e8655f66..8ba9b53c2309b 100644
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



