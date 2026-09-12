Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B986C390990;
	Sat, 12 Sep 2026 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243067; cv=none; b=cWDD4RJTt3y8MXMZzOKVj7FYnGFI2i+mesE0YcHHTk4nNxOXB3DvPP04s6S+4WJDkuL9h7lpP0Di0nuh+X63uv4fgoIDk94N4olV5kQOtfHNUX0P3YQWqAGNxUY8gf13XlmCPpyBzjHU1zLy5ROlFektc8VkJWv1QkcG3UR37m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243067; c=relaxed/simple;
	bh=tGZ575cwJe7EGfUOTNhL7577cVLfvjIzEA9wBUtmlJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdN4+kk56KJwCfqFlJfyWyDp5Pr+kK75hDfT96HKQgEzPGFLartuyRBfabSvkZyar8N5Ahj0JaSAOC4KdRPNIP8tfdrrZAX3+Mtgax2Mp8alNZSXSicPD6im8GTvt10thThpcDJBBhuzm7Y9gyd9Y4iV/WLc0Igc3ZO4KTeaa48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7XBzR69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7XBzR69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091291F000FF;
	Sat, 12 Sep 2026 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243066;
	bh=pX2FzaOQ57zY/dZfrYyC9SXOUtH/xgLToHWMNGbkxSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7XBzR69Eeal8J/hJdQpcmOo6EEyvgycsMjwXIrrAQRVRJJIMpgW9/foN9dTzn2RW
	 qSsrnDyJtNyibTMmfAwSswN2bmjeMmc747M6r4/odYaYytkp38PzIdqx0Tj807PPjd
	 xuOU6dFb57OMrKCi0ADRhC0cBApNUxetzL+JgJBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 625/798] drm/sun4i: hdmi-phy: Fix H6 8-bit MPLL config at 594 MHz
Date: Sat, 12 Sep 2026 09:04:13 +0200
Message-ID: <20260912065531.446575620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b64d93da651d2..b70bc9de761fa 100644
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



