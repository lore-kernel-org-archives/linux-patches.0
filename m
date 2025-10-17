Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFFD330B0D;
	Fri, 17 Oct 2025 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716075; cv=none; b=kGdB3NOl7Y2sCbDnzk+iRo/8XfJAbR+ViSMzGL85quBvCVmIMkwtNdsYIcV6IPnKcU8924YS/8fmcmBmuYU66ryX/EFOxNWH75THCQvlkS2qFae816/TBrSjmKnE20NA6gW5CQSRxaCUk++o1Fb2SX1TDCgWFhrGRIaKt1CA5QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716075; c=relaxed/simple;
	bh=McJP3rwC1QLDOdauUZ4gNXKZTfhyKWoz+mrmMnjXCfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0NnRQJwdCdJrv4kq8JtnO8CXXrkw/AQjEKy7KPhFzEGnE7gWyRc5h2FBp4iupNBnRHZqdgGqFLhOWvvlpzTTkXMoFzrFu8sj5pTEc6Jw6eSMavZ0selQBpGF7cRIXeUfDfhGcGmLWBufjxxpHztvwBZ6+Aqo+n4KoyzlTEdljI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eU4tU9/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eU4tU9/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A478BC4CEE7;
	Fri, 17 Oct 2025 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716075;
	bh=McJP3rwC1QLDOdauUZ4gNXKZTfhyKWoz+mrmMnjXCfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eU4tU9/Ov4YU5MS6dfwFmxDQ1vn7UCe0mUxLBPfjHO0dnvH2ZSq9En18XxjKWBaph
	 x6Ietazqd1I+MzM13vQ1XPN+37l8fpwNozyQrAU6MU36R5iYr2iDQkr1wL6XVyRXMb
	 31wDQlR/R4W7mmSB0JkqKeKQE+Szhxp2XyGVccnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/276] usb: phy: twl6030: Fix incorrect type for ret
Date: Fri, 17 Oct 2025 16:52:37 +0200
Message-ID: <20251017145144.825974145@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit b570b346ddd727c4b41743a6a2f49e7217c5317f ]

In the twl6030_usb_probe(), the variable ret is declared as
a u32 type. However, since ret may receive -ENODEV when accepting
the return value of omap_usb2_set_comparator().Therefore, its type
should be changed to int.

Fixes: 0e98de67bacba ("usb: otg: make twl6030_usb as a comparator driver to omap_usb2")
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Link: https://lore.kernel.org/r/20250822092224.30645-1-zhao.xichao@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index ab3c38a7d8ac0..a73604af8960e 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -328,9 +328,8 @@ static int twl6030_set_vbus(struct phy_companion *comparator, bool enabled)
 
 static int twl6030_usb_probe(struct platform_device *pdev)
 {
-	u32 ret;
 	struct twl6030_usb	*twl;
-	int			status, err;
+	int			status, err, ret;
 	struct device_node	*np = pdev->dev.of_node;
 	struct device		*dev = &pdev->dev;
 
-- 
2.51.0



