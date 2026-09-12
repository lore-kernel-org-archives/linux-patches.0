Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB7C3B813A;
	Sat, 12 Sep 2026 07:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196859; cv=none; b=DL6C/KqMFPQ0YODpY9dBnAGCtqIVZZ4+YUfnjDdvv5AKWtqnIVZ7r66rv2LIhWEJWvzjAUwxZvJr37QiNqySjLBmExmvLOZZNR4fVL/50HknjxLj1nzDcmGGlovtiJM65HZCaDiGAryUiHXWyeUsi6Ci2F2RM5RQY1v/w/Mldj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196859; c=relaxed/simple;
	bh=Y7ExEs4x6Ev3IkZW5HVYmTCNztpBPQ9z2PK5W7q7dag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmcY6r6Cw3RZjfstjECpXWWBndWG/XNyyDHpDlu3L4WErMl1vhylTdvh86mN2gijyUhFjrxmQz/0t2gOxC37voLHeLcdqyuPLhK3mcJB8h312w31U+2CY/bxtFxsFw/om8JjEbMwA+1uXNLhqD9Smb+/2KNI6+bRmfMIj4+qVvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZHL7YnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZHL7YnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CFD1F00893;
	Sat, 12 Sep 2026 07:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196858;
	bh=BphdMsmSdYy7Hjrp/vPL5DZ61Lb9rXwylVTC7l+EJJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZHL7YnG0dt9iG807jvBB7Pa1TN2I/0U2Ijc8EUUlPMmm0aHevPp99XQzSkoUt+mM
	 Bd3y2eMd4iGpOIjuhbeAnI2TNwzRVC4Nn/dMawII2pGN6ezhdZFw4sauyHGcXahSFO
	 2EuBVCAgoBrXsHlKk90tKnRJwSM90N6nA/tnRm9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0044/1815] drm/rockchip: analogix_dp: Enable hclk for RK3588
Date: Sat, 12 Sep 2026 08:29:54 +0200
Message-ID: <20260912065650.055460938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 104f20616d72825fdcf56cfdc5f89f4e96fd8dbe ]

Acquire and enable the HCLK_VO1 bus clock explicitly for RK3588
eDP controller to guarantee register and datapath access.

The clock was previously enabled implicitly via rockchip,vo-grf
phandle reference, which relies on side effect and is fragile.

Fetch optional "hclk" clock in driver to align with updated device
tree binding and keep consistent with hardware clock dependency.

Fixes: 729f8eefdcad ("drm/rockchip: analogix_dp: Add support for RK3588")
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260601065100.1103873-6-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
index 06072efd7fca3..d2af5eb29dbb5 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -311,6 +311,7 @@ static int rockchip_dp_of_probe(struct rockchip_dp_device *dp)
 {
 	struct device *dev = dp->dev;
 	struct device_node *np = dev->of_node;
+	struct clk *clk;
 
 	dp->grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
 	if (IS_ERR(dp->grf))
@@ -327,6 +328,11 @@ static int rockchip_dp_of_probe(struct rockchip_dp_device *dp)
 		return dev_err_probe(dev, PTR_ERR(dp->pclk),
 				     "failed to get pclk property\n");
 
+	clk = devm_clk_get_optional_enabled(dev, "hclk");
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk),
+				     "failed to get hclk property\n");
+
 	dp->rst = devm_reset_control_get(dev, "dp");
 	if (IS_ERR(dp->rst))
 		return dev_err_probe(dev, PTR_ERR(dp->rst),
-- 
2.53.0



