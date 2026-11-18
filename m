Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030651;
	b=rvkWjQecHA+7u1XbWWWfwJC105p9qF5uMo7rv/+4SBCGCok0LzxqnotviPWhiFmr9xuS
	 Nvii1FSvsALGZ+tNAdBlWPB+T97vSIKvFtaH7GHcx//QiSvuZItZXoq7TbTY4qVCDd/mZ
	 V6iw+lXxEFnOkgKMmaHcWNzMc5Zj2U9kU789zHaUJc/tzLAtG7YFZ8GvPyNmfd306swmR
	 T0tbQC0erl7OydYiLzGHwp3BT+jjb6hl4tW8OuNPWIH9P5yLyBr5PRYUQXLjJE1CCcicQ
	 0fgLS7KEIvQ/4v3P5poHG8VnJ7uw/tGdrsPZagDwP8kvoI+Uohnmi/AQ3rD3oj69KtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDO1L7KDYOjU8Y/wv9LmJNX58EIA5zYIZ6RERke7P+Y=;
	b=UVapBHE6MtfGMo+hWeHfeHerICzQmEpLpcvyA2U8YOwoIDLdKbTHYIe39WFYftKDyG59
	 DohEiD6NPQBItlyeQvppuhOkHVMOp1J5iKIdSgR5+z85gpmycCa5iUkRWI74jf1cX+x7R
	 7bMa0AZCQXe88Jtc4KZr3uK/c7Ky4R6VzcgVLwFIaLzQTYbKMs6wFYWz5Yu2NnKnXbYcG
	 flOcHe7mgcC/0FqHkXNtrwpG1xoQOIuL5iniTJ0Ow8vFkqQY6fHICfg/NnGjIz6zf0ahl
	 LBWjC9nOYPggz9BqE2iHMzwrFNh1Tj8r9OGxh3PACI2XJ6jk8Iah18zxf5cs3JMhKGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4QdlVba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB11606A31C;
	Wed, 18 Nov 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4QdlVba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5981F000C4;
	Wed, 18 Nov 2026 19:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030651;
	bh=DDO1L7KDYOjU8Y/wv9LmJNX58EIA5zYIZ6RERke7P+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4QdlVba7XueeMENZt3LED1Krn7z5isLUYHGSke6xn9V7auTip041b6MVDiiP0Bgv
	 Q0wSOeIvh8jhMTZ02H9uzK24mkdDYTwYL68QoM2rCgBYVX7GorQBxbFZPOFx7j+bxv
	 9vP0lp9dEr9wjK0NULiHoM12z5G4h16NvmwSbkdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.12 0779/1756] phy: rockchip: usbdp: Fix devm_clk_bulk_get_all check
Date: Wed, 18 Nov 2026 15:48:26 +0100
Message-ID: <20261118150040.620195854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit a2ddfc60a7d3ba0f571f037371b261642f8ed208 ]

If devm_clk_bulk_get_all() returns -EPROBE_DEFER, it is replaced with
-ENODEV, permanently failing the driver probe instead of allowing it to
defer. Avoid masking the error code to fix the issue.

This effectively drops returning -ENODEV in case no clocks are being
described in DT. This special case will now be handled by the follow-up
check searching for "refclk" and exit with -EINVAL.

None of this will be hit in practice, since the driver is only used by
RK3588 and RK3576 - on these platforms the DT is validated to contain
the clocks and the clock driver is force probed early. Thus there is
no need to backport this.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-4-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 469908926d5bf..f8288f9875913 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -427,8 +427,8 @@ static int rk_udphy_clk_init(struct rk_udphy *udphy, struct device *dev)
 	int i;
 
 	udphy->num_clks = devm_clk_bulk_get_all(dev, &udphy->clks);
-	if (udphy->num_clks < 1)
-		return -ENODEV;
+	if (udphy->num_clks < 0)
+		return udphy->num_clks;
 
 	/* used for configure phy reference clock frequency */
 	for (i = 0; i < udphy->num_clks; i++) {
-- 
2.53.0



