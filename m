Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A18B2D9792;
	Sat, 12 Sep 2026 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239704; cv=none; b=kMGzuuAVb+f+0dafBmSlO+xU1/1JuA3MDqx1TI80QD2Qnsvv2EYsxc2m0edL0FTwCwR9LbJZACz9RDQ9jEzBkO2hUgAgaeP4OJ7whaRi7cf0PtFx7PafqjGYdRUPJyIbEY/euukWP0WdCHoJktZ5bWsgfAnzFezhgsg599Vx/Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239704; c=relaxed/simple;
	bh=4nDE0q0OAhxhO+X2Mh+bBTQK4pLf6HbzekXNgwSYVZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDwkp6P5VDETSVU7kTh4OPIPD4OVBxUv+PGFar6iow9MhemojtPAKdkQrBaLCZgeUqltUDkUOlLb/paR2eFnRyFyPPTE9dXBWnar1JpJcEfFq3wM0omiI5FftM96C5+/C98oU/uDx6OS956noRcZhMLOqD9OBIJzG+NqnP1Prkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+JXGY5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+JXGY5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6482D1F000FF;
	Sat, 12 Sep 2026 19:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239702;
	bh=oedgjx5Snc+mDv4tnodzu07zkcBCLZMXrSbuavJvqfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+JXGY5VBs5nhNKCxMkP0TMm1mpjjvvOI7sNj4Pgh2VpOjVw9gZmajw0Rl/SEX865
	 rCvGhers7DCFXJ8IY57GSl/e+d0XlJV5K+kmLWlmJfIgv5D0ol8Hoaq4ldso9yaY+c
	 T7WKsrXTNiH37EtB7lCxdaYBmKK+bwoeo/i36pt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 716/935] drm/sun4i: hdmi-phy: Fix H6 8-bit MPLL config at 594 MHz
Date: Sat, 12 Sep 2026 09:02:26 +0200
Message-ID: <20260912065543.258524040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 0ba6deddaae74f0539c0303bfb5f860adbe1a68b ]

The 8-bit entry of the last MPLL row (594 MHz) doesn't lock reliably on
H6. 4K@60 RGB/YUV444, which is the mode that reaches this entry, doesn't
come up.

Align the value with the vendor driver. Other entries are left alone,
they are used by lower pixel clocks which work fine.

Tested with 4K@60 on a LG TV.

Fixes: 0fb4b858b102 ("drm/sun4i: Add support for H6 HDMI PHY")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://patch.msgid.link/aec9060209473b8176eb43bc7c63c20b21306adf.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index 5e2b0175df36f..441829bdec40c 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -90,7 +90,7 @@ static const struct dw_hdmi_mpll_config sun50i_h6_mpll_cfg[] = {
 		},
 	},  {
 		594000000, {
-			{ 0x1a40, 0x0003 },
+			{ 0x1a7c, 0x0003 },
 			{ 0x3b4c, 0x0003 },
 			{ 0x5a64, 0x0003 },
 		},
-- 
2.53.0



