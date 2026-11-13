Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590216;
	b=bx5GGQSk5g0WRata3MeU9Coer6ANwHHuBRxDTwdfMCc/Q0k284cEF5Hg2CIWx+INdKJj
	 HdzaIPWEMvcLG1ub2p64sfFBJSDASU6itUBsKeEumkoTbx2OMk18ZgN+a717IBv1i52zw
	 N1x5Q0FULPKVmubIPTghQ4FQY5JI/38+L/kihiF2Bq9NzlxtVd6xj/WELrEIYE/j/5qVW
	 tWBwvy/DHkqQdyvENK2vtqdBogXEhiuRKn0OduCZrm6uIxa2/WiS1yp5XcQQy40vraqXm
	 doOTy25lawPEWkwZZs6medA2TVQeBOGBhIQznWPx4GitbWOj7HueEOgCiFjb4fttVOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Fylb8wsCETaSYkspYB7JaLJE4P0GM1jZV4OWg9ooes4=;
	b=CXBl9cr2VcXh0PWiBVxnRInQ5ubDiGW1TBHRlzOSrTkashfoL+AxEFI2R8immFhch3/D
	 uUKHeWEXvd3gu711WccfRf0iNxfjgFKcTjMOlRZqk7PXbRwLqu3yxL4OagChf2X3qDjwv
	 uMWmdbyM0kmpIrR3/PSEtnqwVXsKndaF48TciO/799dq/zcfVsYZuz+l91oTec3geaoau
	 //74TIXx9FoA12gM7k9FDtDEI6J6HVFn2zxnHWypQ35yH0JxHJczhxFDhtD4NnVs6Awp0
	 MfosV5Q0E4gXXZLBXLFZBy4nbCDh0YY3syVOTlJr9Mtt4IpvRTAYLvnGmHiiALY7/Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSatgTbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DF5606BD21;
	Fri, 13 Nov 2026 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSatgTbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0F31F000C4;
	Fri, 13 Nov 2026 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590215;
	bh=Fylb8wsCETaSYkspYB7JaLJE4P0GM1jZV4OWg9ooes4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSatgTbrnLiYFs3g8bOMpx21zf1LHnOps4hXQiwaMfC/HU7oRZl91oePLJusMWY14
	 T53uRemlPPgWw1fbfoJxoiyE2GvYI4/uloq6PtYNWdrTNGxocOTGDtEoeT6Ud1uukC
	 gMqTwFBZXley4Gz9biUyxVKk//ya1B+vW+fPrkGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Lucas Tanure <lucas.tanure@neat.no>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/686] drm/vc4: hdmi: power down the BCM2712 PHY when the output is disabled
Date: Fri, 13 Nov 2026 10:45:50 -0500
Message-ID: <20261113153828.386377532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit a59a60e6e9e3a1d5177b28577d935d5ee37ace66 ]

vc6_hdmi_phy_disable() is empty, so on BCM2712 the PHY keeps its PLL
and TMDS drivers running after the HDMI output is disabled, until the
next vc6_hdmi_phy_init(). The TMDS clock is therefore not stopped
between two mode sets, which the SCDC clock ratio change requires, and
the idle PHY wastes power.

Reset and power down the PHY on disable, as the BCM2711 variant does.

Cc: stable@vger.kernel.org
Fixes: 0b1dbe82e051 ("drm/vc4: hdmi: Add support for BCM2712 HDMI controllers")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
[lucas.tanure: Rewrote commit message to clarify the issue and fix]
Signed-off-by: Lucas Tanure <lucas.tanure@neat.no>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patch.msgid.link/20261026164028.78792-2-lucas.tanure@neat.no
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi_phy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi_phy.c b/drivers/gpu/drm/vc4/vc4_hdmi_phy.c
index 56e6a35da3576..5040f014bf7e6 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi_phy.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi_phy.c
@@ -1197,4 +1197,9 @@ void vc6_hdmi_phy_init(struct vc4_hdmi *vc4_hdmi,
 
 void vc6_hdmi_phy_disable(struct vc4_hdmi *vc4_hdmi)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
+	vc6_hdmi_reset_phy(vc4_hdmi);
+	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 }
-- 
2.53.0



