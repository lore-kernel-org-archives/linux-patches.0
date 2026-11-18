Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016494;
	b=mJe9ngCnx4wlbrOQh921OU4agvUStJ/piasWSH/wTgGRa/DLLBf/GuCViMvg/kiHGlNV
	 kdS6I6lwkyeYON43wjBMtXYo/GtICZdyNmIuM28a+oRYwgqqCNwKv/uStu+MpUeP9mGrp
	 FLWIQuCH1rPunPL/LLUv8sddvIbWQ+7nyUYwv20865wqQ2Y3p4nliKvqvsjLVh8Q2Crg1
	 Ex9bL7xEA3M0Rwi6Ej3e0Gaw6C3+WZNDNILX1MH3DyRD5ESX6FktUIhSJNDU3abrMINh2
	 dRINeW6uSY/E+Wu6lXT+qmJpfmvTKKxhamPvrrqpc0WNyx9m37sczfOqtiIu9is/eQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3D91293mAHEceTlOVy7tdSaYAAVS4gOeMP4lNX7u5pY=;
	b=TFhsxh1Dk/40AuxIHDi2BzHc53CMO4EKMgSAsdJXqtuOgseChDQuQTDkNr024nNI3GxS
	 sQU9NTEhPw8DNH86W/pBnXrGk7/2jJ9kXU1sGgJj4V7hcEM5gqMAY+PTtv+WG0eY9wcTW
	 8Tvu/xZg0iGMRdnq/LaLFWQgmkqlInB2lY17ofaGXWBDRDovTYQnDXLDbhoeXvXx7D6dO
	 PSR3t/bBJP8w61hx6cut2KbUpBwDlBTmrei9cvCMKWveMZqQpReiOAG/81NW06PoyG4K0
	 QaKGMpCIC+Jk1Me4Xj3JktHbPGdigzG2KNVNwaYUFtyVA3tquDZ3KwNbaND3S1AhUHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4zXLeG0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71FE606A320;
	Wed, 18 Nov 2026 15:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4zXLeG0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225731F000C4;
	Wed, 18 Nov 2026 15:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016494;
	bh=3D91293mAHEceTlOVy7tdSaYAAVS4gOeMP4lNX7u5pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4zXLeG02HKnu7I5ezJhLevISSDr2Rc2HI9Is8Ww+q+gehZMEv0Woey0DS1F+cr40
	 Sebk3T5H9nErJ4iB5SlvL7g3WxajP7e538UlDuVKS0au9RuVyBjXIkj0CXdpmz15vz
	 vfRZCPQRK7XvF9aRT5mfzmEVlkx8/Z4XK+LbS9dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Chang <seanwascoding@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0548/2651] drm: bridge: dw_hdmi: Fix constant truncation warning on phy_mask
Date: Wed, 18 Nov 2026 15:29:48 +0100
Message-ID: <20261118150307.476026754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Chang <seanwascoding@gmail.com>

[ Upstream commit cb6a133bc75bc4c5b25f7c278b6c74bf46a3d71b ]

In dw_hdmi_probe(), casting the bitwise complement of (HDMI_PHY_HPD |
HDMI_PHY_RX_SENSE) directly to u8 triggers a compiler warning
(-Wconstant-conversion).

Due to C integer promotion rules, the bitwise OR and bitwise NOT are
evaluated as 32-bit signed integers, producing 0xFFFFFF0D before being
cast down to u8.

Fix this by explicitly masking the inverted 32-bit result with 0xFF
to keep only the lower byte and prevent implicit upper-bit truncation.

Signed-off-by: Sean Chang <seanwascoding@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260819151216.56833-1-seanwascoding@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Stable-dep-of: ac18f34f5927 ("accel/amdxdna: Fix race between unmap and free BO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 34c5f583e9108..937d61c42b58d 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -3353,7 +3353,7 @@ struct dw_hdmi *dw_hdmi_probe(struct platform_device *pdev,
 	hdmi->channels = 2;
 	hdmi->disabled = true;
 	hdmi->rxsense = true;
-	hdmi->phy_mask = (u8)~(HDMI_PHY_HPD | HDMI_PHY_RX_SENSE);
+	hdmi->phy_mask = ~(HDMI_PHY_HPD | HDMI_PHY_RX_SENSE) & 0xff;
 	hdmi->mc_clkdis = 0x7f;
 	hdmi->last_connector_result = connector_status_disconnected;
 
-- 
2.53.0



