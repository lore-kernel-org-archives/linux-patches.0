Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585430;
	b=iHagE4iNbrQAl49/PbT+lh+09kn/2SOWrNYgdRNWAFWlTwXHRqE+jjMaAWXpdA6NyTaI
	 Dqgo672vK3LEqvr0LG7zk9WwWNQmypFMusF45QTKygMqSfkPH0j9AFmU0aHOYrN3QX8o8
	 Eqn+Yg3Y3r13BvX0FKWlPFiEcNJETtlHRWCXwZdr4FTfLP8avWdbXpXEbTXmFHs9sx2sQ
	 EEJtD86yOuL7txb7zsdT8XPvhlIju9vV71BxbOZCETUEkVesKONE4wwTjlr5KrnQSvNUa
	 Rxfijedo3E8XF9ux55FnFa7MB2Xk8hGWc6hQHSp8+X/HNQptE9VDR24KZW+AAtVZ7Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vCBQBMxE8ODKIvxZG8V2UV3DCqa6YmLxCWA+7bGyazA=;
	b=j6rRGsxyt4oZ5mF37+xf8TiKrFhR2hiF9eSBBkdVuiNBnFNrPwkSafC25zEmWofWRM+j
	 9VF4USnNL8bzEd+VgqpL+4sQGyvZoSrug5CUZ+l5egbrvG5y3k3QSyN67QecOY+/yjWSz
	 +wakY9E0+aJevcz8znwT1GpXscnneO/wHQcLtwpzp8TWtus20m8TXsY1x8z300cecAsHD
	 Ec1mx/npl/Aw5Jo/12wYI6adHFZrk04i4K+cCUjFNEabXvrVDCvUSRRjgu0Tczf3qLuHQ
	 Hk8HtEFMW4xBbsqyNE4oYvF14GYAozmEV8P5HuxK88YLcd1t5y12uiR4ySB7sZyRPDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQIwpsiS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E5260A3839;
	Fri, 13 Nov 2026 15:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQIwpsiS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43901F000C4;
	Fri, 13 Nov 2026 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585430;
	bh=vCBQBMxE8ODKIvxZG8V2UV3DCqa6YmLxCWA+7bGyazA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQIwpsiSpuBZUJ1HIRB9DR4Wb0LM+v2fRN/DWbl0LxTNI2/s3iEn9f2ZZ9zTZLV4x
	 5m+3k4tOTS9piZxwNc1x+hzvKNxSIS6VvtdS+hQqE+r8VsuGyev3xNjDT+WhKWwgl0
	 6crgbWF0CMXG6aQOE7TkMqkE+ZCdAdyDAPq92A/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Lucas Tanure <lucas.tanure@neat.no>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 091/507] drm/vc4: hdmi: power down the BCM2712 PHY when the output is disabled
Date: Fri, 13 Nov 2026 10:46:35 -0500
Message-ID: <20261113153757.093729063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



