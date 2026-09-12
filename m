Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEB23DB326;
	Sat, 12 Sep 2026 08:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202123; cv=none; b=srcuACCq2lo/BQtzaUkeLdlLw1dEZ1yVodxmUgQM+ToIcABQhU+/ONsa+x0SdySWF9r7Yspb2IsqUp0Q6jLEOQJo5DybJ5xXbRoorJnRv3UfOn1sMfiqUo0dghJUKGBpBcM3VI5if3hn/LhfWvTIGwjNQAX2eesGLVEu2UHW6P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202123; c=relaxed/simple;
	bh=fga3MCArABhQRrDz8hUw+MFWBf86o24PZS+aFEz8jyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOX/JY7yVSy8gl8K9KVO1O/I0PurUSuPfmU39ajm0Vykt6AkWxDINZtEFEw5qv18B0StD4TkP4aDVmZPBzvWDmvh+CmNWzSxdU7XAvJRR9uN8BbX7Q+gePLu2sIg8TWJyT/2HRTneEc+q0lNN2me6hbQ+JMSTg4JYAVnrshOTLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi7nHe0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi7nHe0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3B01F000FF;
	Sat, 12 Sep 2026 08:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202122;
	bh=4aGQHdoat+qRQwGZkruiBgbkn953/T4s/wStalWcmEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi7nHe0qnExfcDUkAi7pBBQ8xQyHOtbobWt3gKzRtrJRIQdASUaABlom/CTRGsEep
	 BBI90AQ+8RSYCanbovF9dnY3rCP54xk7Azu0jrTqMSlNPJ+G17Ukk++lKa79fQf4YK
	 flbRTEz6ygl8KfqBgYD5MobpIkRqPck/im1/L/nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1136/1815] drm/sun4i: hdmi-phy: Fix H6 8-bit MPLL config at 594 MHz
Date: Sat, 12 Sep 2026 08:48:06 +0200
Message-ID: <20260912065715.690640437@linuxfoundation.org>
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



