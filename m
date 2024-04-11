Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5182EAE5;
	Thu, 11 Apr 2024 10:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829658; cv=none; b=Kg9T6x0t84rty49bCmhDSEUB9QRG7WZlL/waQp2iVF7o3ph0y5//TnS0rSapI0MDOQvu1gA0VIDCTkJsVGDPnzyEsAy77S60ekJP1FHAgzAKWguVUKyNuWqJQfVux4KOth+Zzb7tg09jJGNo883AGavhStidX6eyheE42YjuJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829658; c=relaxed/simple;
	bh=SLiohcervRLDneKut0KfdMDc+0rEcJDOFGfLHBzwhTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNbLP9Kx/Ug0yFvQmhXNJIQBkQAtaWCFAwPDYb+LI86FHCT9u60qNL+nw90Yj4WEDEgrPq9dTdz4+bcqX+0dAzYjLKr4V701BXBRsfvSmDVh5SDKKvG5FqtlLmPM5oY2aIw88y8cOKDV1U+nSEUun/qk7MCFkPSNYRmjjV+aCPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtHn7XyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtHn7XyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7753C433F1;
	Thu, 11 Apr 2024 10:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829658;
	bh=SLiohcervRLDneKut0KfdMDc+0rEcJDOFGfLHBzwhTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtHn7XyE0DWPwzs4nXiUzeqBnIF2r3wbEqdvBZhz2twp8zkCWXyzq7fBAljjQnNky
	 ScFLxo6qFzRT5d5d5oUfb5HrLUJMkVTfCveG/A85K3AH6yG6e1V17RwIWRgdenEymE
	 2OQICVvgBqrwbdh93NTNmPMwTk2d7EfeVdT5lWV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/175] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:44 +0200
Message-ID: <20240411095421.402610830@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit abf493988e380f25242c1023275c68bd3579c9ce ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Maxime Ripard <mripard@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/dcda6d4003e2c6192987916b35c7304732800e08.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 1161662664577..013dfc63c824e 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -276,7 +276,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4->hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4->hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	vc4_encoder->hdmi_monitor = drm_detect_hdmi_monitor(edid);
 
-- 
2.43.0



