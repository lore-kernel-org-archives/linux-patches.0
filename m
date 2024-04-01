Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308011DFF4;
	Mon,  1 Apr 2024 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991053; cv=none; b=dLVi2riGYXOweQrnrbBG1ie2jJugG6C5TCpnCmcakLNjJcknvHGU3AT4E8CiLkf2wQJS+sBpqGnCOuwAIA9fKFyA2dnbrzRX+NC98r5g7bD7d3rugGPRHwtS8r4tsGufpNuCQO7DZt+gzaJta29Zy0AxFda7Fo0O5hP8fQ5svPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991053; c=relaxed/simple;
	bh=tkc/09EnPYyjTT6cFUiO7bgnuCSGs9eC+3SiSwQQB4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9U+TFuZHGsMhDm33gvRS8DluMVY3bU7ZnN5OQjPfuUsVmSnHoca/tWXpq/RKUWx8fECy5WSE9H7wA1rl/PRZTOa6xExR2aC+yl1XSJ2QvtSA1O7UloFwSvAZZCVJS9+3dZv9TKNiMKJ78cAW7TZa0K84v0jyt1eCMfGlRUCMUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBm7LbkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBm7LbkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E73C433C7;
	Mon,  1 Apr 2024 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991053;
	bh=tkc/09EnPYyjTT6cFUiO7bgnuCSGs9eC+3SiSwQQB4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBm7LbkBqWlb5HocDJ1N7HhwhjnHY32QmWciQchxBYtpTpkK17dSaUE/CpuYxfhq0
	 J3SVPRUt0xEDJeCwC13q8Z1h97CEQgmuMdB3Yq4mXIbif61I2PI3NtY/hrpmewWHlt
	 sUnOC+l7UEwJEvXFZ+/jAXfbaCyJIpRHNczPwhmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/272] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:45:09 +0200
Message-ID: <20240401152534.386716581@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea2eaf6032caa..f696818913499 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -497,7 +497,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4_hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	drm_connector_update_edid_property(connector, edid);
 	ret = drm_add_edid_modes(connector, edid);
-- 
2.43.0



