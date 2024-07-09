Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0CB15A86D;
	Tue,  9 Jul 2024 11:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524152; cv=none; b=iMO8iBd9ppg4w9kV6jyTG+1U++Zk6pdsGF8KejZWZjnZZPCwGIKl4o3y07qeznmKx3YLQxw6tnlT2tuUbILFEzAGLnjdnrpypRBDBlqqwkysq7VTPzYFoQzDmTLG9boVrhpHGr6ggNLObiJIk2PVTeZSUkrpDU2Cmta4p03dbkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524152; c=relaxed/simple;
	bh=1sd2CEIYZSTGeH+RZ7G/MirHynE22cyPvAaIeDWJCHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRm3/3tr3MWHrIacwMg3uc/1EnCXDVLnmjxWAAtWlByK0Acz+i46OMYjSM9/QqaKsndYWDkBRnpEi4Yz3AAXZQOO59Y4clEMemNkrH1nSHnr17RzyVJ3CeE60l9aH4QZ0roa/uSILpxOTu3H5SVKDkA42bF7/5o+K2c9N5XYczY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2i4oObY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2i4oObY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6A1C3277B;
	Tue,  9 Jul 2024 11:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524152;
	bh=1sd2CEIYZSTGeH+RZ7G/MirHynE22cyPvAaIeDWJCHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2i4oObYSeITkqpO6Uud0Jt78gasS8u12ZksWmkUvtIaNfkVphCmSwOPnLgWNvZRR
	 aGiIsacekhcf/8jQoTGOgVfxbcvOJj7EQWAXNTyOmm1rwGCmv4p1uVYoytppu36bKu
	 j6Kj3DIXAuJkihAVrW/TgC3P26NVJKRTmwzJd6vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 087/197] net: phy: phy_device: Fix PHY LED blinking code comment
Date: Tue,  9 Jul 2024 13:09:01 +0200
Message-ID: <20240709110712.332093296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit d3dcb084c70727be4a2f61bd94796e66147cfa35 ]

Fix copy-paste error in the code comment. The code refers to
LED blinking configuration, not brightness configuration. It
was likely copied from comment above this one which does
refer to brightness configuration.

Fixes: 4e901018432e ("net: phy: phy_device: Call into the PHY driver to set LED blinking")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240626030638.512069-1-marex@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3f68b8239bb11..a62d86bce1b63 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1121,7 +1121,7 @@ struct phy_driver {
 				  u8 index, enum led_brightness value);
 
 	/**
-	 * @led_blink_set: Set a PHY LED brightness.  Index indicates
+	 * @led_blink_set: Set a PHY LED blinking.  Index indicates
 	 * which of the PHYs led should be configured to blink. Delays
 	 * are in milliseconds and if both are zero then a sensible
 	 * default should be chosen.  The call should adjust the
-- 
2.43.0



