Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E11A1C8618;
	Wed, 19 Mar 2025 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395193; cv=none; b=CDwnuo8QwJnaxN1yP1cOxwWDpkFaAnkMcy9+ZxH0ky9GzBuEB0nQ9V1fydOFMEEX6+RN49HKCJNWcRdgAVtFpLy/eocT0p07GRP3NksOAEqW+PRCddnLLMZnwHY3xoI5Px6Q/eHWGy/M69pmh+Cp3IZztB6udeARJWTbMWMBRkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395193; c=relaxed/simple;
	bh=yLJaiV45JM0VQEG77xm86eOEKhLVJg7aKsb16OuxFD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmLMWdKeF6ZYtySIxNF5bk/HE+kHStgUy1b6LyZRw2ha1lSopaL+WXoxqq+6or5Fy5ggHL4Ixccd1UXavEEw+a+Ezi+2DtLqm4dM5AvDzbJskhg4hRbFop5dtc0QLhwfx0jRmyggGr8dQuMv+Fn+yU3YQMRknfHGBP56UIs2sDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQuGfECc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQuGfECc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F25C4CEE4;
	Wed, 19 Mar 2025 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395193;
	bh=yLJaiV45JM0VQEG77xm86eOEKhLVJg7aKsb16OuxFD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQuGfECcjBft5c99LuxyZM2Xghe2jIbOF2+Ag29oOGZuBYWBuY04JU08GEUHCN/46
	 Um/mKS8uw7va2sJtWkKarq6hlRzNF3fDeTJwpw4+/GrQygdnZZBEnKv6rpyj6jprLC
	 fXvbRmRz+jx/xZ71gaPUEyIFijgqv0H8Q60HaVL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/166] usb: phy: generic: Use proper helper for property detection
Date: Wed, 19 Mar 2025 07:30:24 -0700
Message-ID: <20250319143021.429571192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 309005e448c1f3e4b81e4416406991b7c3339c1d ]

Since commit c141ecc3cecd7 ("of: Warn when of_property_read_bool() is
used on non-boolean properties") a warning is raised if this function
is used for property detection. of_property_present() is the correct
helper for this.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250120144251.580981-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index 770081b828a42..2b4d2cbafe748 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -217,7 +217,7 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop)
 		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
 			clk_rate = 0;
 
-		needs_clk = of_property_read_bool(node, "clocks");
+		needs_clk = of_property_present(node, "clocks");
 	}
 	nop->gpiod_reset = devm_gpiod_get_optional(dev, "reset",
 						   GPIOD_ASIS);
-- 
2.39.5



