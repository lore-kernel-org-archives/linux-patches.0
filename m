Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000B13F452;
	Thu, 11 Apr 2024 10:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830762; cv=none; b=qj5okfPF0gvnI1U1mHtHdn5YPRAvbcH9Dq+BaS4Ssh4s0KlB98GImchfL5A2rLZJHhnsvfb3tx1DPJfsyzg92+NuhtHUWWbAKvzIsqXEtwhPWEDArbgI/fDFALEK5M/ds5/2Q29Phjh1fV44IIIhXCNMzmuWKRxVNIFFGqfxRsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830762; c=relaxed/simple;
	bh=c3Lm4od9bWFhOoiwDt9q3pA7RvgRlKqBxPcqsKIjB1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxg1FxtzPTIvOmqkZbisEfluWBjNUyAmuASDae9vL9fvlUzaPtomygXIZbTbsWb43vyBGZ6RsKRUSxNk07F98F0rDou84H6gYlq+dM6WN1I75EjtH1cSSQEUTm7nV9Pm98QXDXGK2x7HY5lQsNh7xnpILYPdfkTm69Ht2Ch47Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hKVDhJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hKVDhJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB8DC433C7;
	Thu, 11 Apr 2024 10:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830762;
	bh=c3Lm4od9bWFhOoiwDt9q3pA7RvgRlKqBxPcqsKIjB1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hKVDhJ0T+ex5vcQw1bIJgCP2o2WK5If/2iqrcI4FyHhhu06XFU6KuDRmZ6pnu4Y7
	 dv+gVJCB5wPbEC+FK7zeXEVC+lJoHRbnBohJkTOFFCH6krmTLf0/Ca4q7mAdHmBTaA
	 Mmw2alFiJV7o//nQcBAaUr0vm3sWsFzfsdBYHinE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/215] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:40 +0200
Message-ID: <20240411095427.034533254@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 54435b72b7611..ba71200169866 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -236,7 +236,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4->hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4->hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	vc4_encoder->hdmi_monitor = drm_detect_hdmi_monitor(edid);
 
-- 
2.43.0



