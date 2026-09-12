Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79AC3F23BE;
	Sat, 12 Sep 2026 10:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209945; cv=none; b=LuwriXu0AqF+ApQDxL/20S+sODo3B29sHyDkgxtuNdMaYwtf2ba20tL2PQbsCPdxnayWbkqbmIq0Fx5ws61S+UDRsn6VX8I4dtGUoEo+1DuzBs35VpqGbsfAlTuwEEcJu17uz3kEdda3VeCE55WOlLiE8RGEr9iwNKPN0c5ZuQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209945; c=relaxed/simple;
	bh=5+DZrKr/uXWiGsz71Y0TAhYw7UL2PZxblXuUkpIWiPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8WB6C9JlfYpipgzdQYq9oN308ksrry4HYxdTIx0jalOeFdg+Xn5A17myR2hAKtC7r82kjoDYElP/4hp8A8jqWzFr7aLAxlXR3FaJ+78MlG4tQIzZF9viZJqU0GK57arU/rdAGi7TyKpx7iCqTHiXVJKzD0P/xtMcv4VuHcTAQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyVkvETP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyVkvETP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F021F000FF;
	Sat, 12 Sep 2026 10:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209943;
	bh=XT59j6RzWvIrMmSxHdDwPOP1Fuk/58fDdIDuMySSK5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyVkvETP6RqXjhrt7cgrGgxflxlBXm362K1OFlZlVLasnFMcyB/FTyxfm9UUyhdTI
	 /3wYERwgVI6OncynajDa3wjF9PB3fIAHg6+5oTBqGOkHrStMDTy/LpspLsPjWQ+7BN
	 6grAqwom1PhJo6HVI5Wgz8H+m0QxX8bIJxzQZ2EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0918/1518] drm/sun4i: hdmi-phy: Fix H6 8-bit MPLL config at 594 MHz
Date: Sat, 12 Sep 2026 08:51:27 +0200
Message-ID: <20260912065644.217855018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 4fa69c463dc46..489ea94693ffa 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -91,7 +91,7 @@ static const struct dw_hdmi_mpll_config sun50i_h6_mpll_cfg[] = {
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



