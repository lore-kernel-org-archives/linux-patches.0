Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA804199FAB;
	Mon, 23 Mar 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275051; cv=none; b=DB6iBF9i8jJXeTUK01LhgGlcXzd+/eqRqPgHh31MJLXcYndl/gLLKVySBB1ehRqNGu0FoxieAAVlWS+OYz7uj7KBU6r0sdX5hSx33P51tShqhULnICpT4e7hzWPuTaFok06HNaD0LJHcGmDACteGu1rsewJLOPErDFj/omARvyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275051; c=relaxed/simple;
	bh=pVCUpJqlzL7AO15cJ7TKim5wbZ8toQhOoyN9y1vkZFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnIENqkmFZE05EsdRkdfQkgcvQLba/Qd5LsF3c1TuWC8h+m987dX75lKnsuLsS6+FticwpaE0KLiBVnf2/udC7a8KCyo7LVTW5yh1r8mciZkqQDCo3y81PngnL0AsVL12a1QTM/ygYToEKvukk5vJuwe3X1bnGd7/3XJeRYXLV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhXmcIuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhXmcIuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB247C2BC9E;
	Mon, 23 Mar 2026 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275051;
	bh=pVCUpJqlzL7AO15cJ7TKim5wbZ8toQhOoyN9y1vkZFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhXmcIuy/7i2+mb/YfWFBHffr+xcg8lEUdudMA2vZe5Xb9VekIx85CDfzvzEkv0If
	 8ttb8Ho+/ZLjRTO7F5PBSAA1Tt79mCVTI1yN3ai2zlaeS6awDAw5mJ8iXKq5Q7i4ZO
	 +XvO1UXpfT3dFuZb84BLPGfV5+41WZEIv9Bm0XTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/212] drm/bridge: dw-hdmi-qp: fix multi-channel audio output
Date: Mon, 23 Mar 2026 14:47:05 +0100
Message-ID: <20260323134510.234154759@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit cffcb42c57686e9a801dfcf37a3d0c62e51c1c3e ]

Channel Allocation (PB4) and Level Shift Information (PB5) are
configured with values from PB1 and PB2 due to the wrong offset
being used. This results in missing audio channels or incorrect
speaker placement when playing multi-channel audio.

Use the correct offset to fix multi-channel audio output.

Fixes: fd0141d1a8a2 ("drm/bridge: synopsys: Add audio support for dw-hdmi-qp")
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260228112822.4056354-1-christianshewitt@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
index c85eb340e5a35..d302455875167 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
@@ -818,7 +818,7 @@ static int dw_hdmi_qp_config_audio_infoframe(struct dw_hdmi_qp *hdmi,
 
 	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS0, &header_bytes, 1);
 	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS1, &buffer[3], 1);
-	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS2, &buffer[4], 1);
+	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS2, &buffer[7], 1);
 
 	/* Enable ACR, AUDI, AMD */
 	dw_hdmi_qp_mod(hdmi,
-- 
2.51.0



