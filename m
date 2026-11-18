Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034951;
	b=KlEUpK4Qoc/OePXYOxkv5eDkJQ97+guMsBLI5IQ32GtRMLxBqDHoffkPiUgyTD7Ac03e
	 +ToEPaCPMfY26xLrFjcGP9AkLUFNk1/9jYjik9rBnrOmrhF+HG/4xy+dB1/Wlp5ipan+/
	 90ykAHh2sfa30PUPNZgMTY+MTussJ7Yck7smLEosAOudSL5WFKyoirY12Umf4Q1OHtjcR
	 Dzua0gfXISm5G27n63ElzMi4cgxPY/Tovf27BqUNzxwZZf1F2Hw1CqztZGHUGWVjG5Au+
	 PsR2gKhB/ICWkXURtcTyedafMoEI94rO2vvYaoUHiHA6ZXtadUq/Q/9cNpgD7qBmqsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FkFBIV9/O6J+KfDKzjkT9ASATYxBgVHe10fCoiW+d5w=;
	b=ONISY6Nsbg9aKkoOslHHKjaDJ1Xw8iUjm3LeZV5K+WZ3B7fnPXYAzqIfCS+5qavGD5uj
	 LrorZOY8jkjCCDzB2Ysnu90kExatzQuGgdOqjLbbOjSsAmjnMw18u4lOsRelF6JnSyj/z
	 7HymgF10ybayDzqj75wGLQjZS0jwapBV6D8809+WPZzvffAIdmjvGdhop9yOIesdUhNjq
	 js+lG5WA8ZuOJ0ClR/RIo5IUu9y793SR+sM8N7QuZkpy47KJv4pVJo6b1sf110bsGLcR9
	 Bu536spFzkLuQx0GVt9qjG1WHTcSR4W0JRUhWPS6U7uH6eO2C48HmVGOZgA65vx1qew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8I0np0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB5606A325;
	Wed, 18 Nov 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8I0np0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F981F000C4;
	Wed, 18 Nov 2026 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034951;
	bh=FkFBIV9/O6J+KfDKzjkT9ASATYxBgVHe10fCoiW+d5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8I0np0kvj4gLD8KDKyGcp9DqYWgxIsd0RK6udfcCyUWtebOR0yb/PdxmdXBivvrM
	 BiOHaTd2jUDEt6ECi6WDC5WfwbpnGdXQcXJzRZLsAxrzWfBZNguYkOWVhiCLcp7pY5
	 Prr1gmMmgY+CNOp05wjgc9GNaA+7Zii7LKiC2C/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Costa <leonardo.costa@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Swamil Jain <s-jain1@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0553/3318] drm/bridge: tc358768: Enforce input bus flags via atomic_check
Date: Wed, 18 Nov 2026 15:19:35 +0100
Message-ID: <20261118150333.910305735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonardo Costa <leonardo.costa@toradex.com>

[ Upstream commit ed761e0693950fcb4f6b0f60387a3961b972adf3 ]

The tc358768 declares static bridge timings requiring pixel data to be
sampled on the positive clock edge.

However, the DRM core default propagation simply copies the output-side
bus flags, coming from the next bridge, connector or panel, to the
input side. If the propagated flags are incompatible with the bridge
ones, the data is wrongly sampled, typically resulting in visual
artifacts on the panel.

Implement the atomic_check hook, replacing the mutually exclusive
mode_fixup, and set the bridge state input bus flags to the ones
required by the tc358768. The sync polarity defaulting previously done
in mode_fixup is carried over into atomic_check unchanged.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Leonardo Costa <leonardo.costa@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Swamil Jain <s-jain1@ti.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260706132440.1594239-1-leoreis.costa@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
[ sashal: Added a new atomic_check hook that only sets the bridge input bus flags from the bridge timings, since this tree has no mode_fixup to replace and the sync-polarity defaulting was left out. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index a552b6d90e42b..6c6d1677afcec 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -1145,9 +1145,20 @@ tc358768_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
 	return input_fmts;
 }
 
+static int tc358768_bridge_atomic_check(struct drm_bridge *bridge,
+					struct drm_bridge_state *bridge_state,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state)
+{
+	bridge_state->input_bus_cfg.flags = bridge->timings->input_bus_flags;
+
+	return 0;
+}
+
 static const struct drm_bridge_funcs tc358768_bridge_funcs = {
 	.attach = tc358768_bridge_attach,
 	.mode_valid = tc358768_bridge_mode_valid,
+	.atomic_check = tc358768_bridge_atomic_check,
 	.pre_enable = tc358768_bridge_pre_enable,
 	.enable = tc358768_bridge_enable,
 	.disable = tc358768_bridge_disable,
-- 
2.53.0



