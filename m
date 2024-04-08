Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652627E78B;
	Mon,  8 Apr 2024 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581949; cv=none; b=t41OTK/hhqPv9UcnNhx9ib2Yq7O1LixjW6ON29NtEjXyQn9TNOOtRPht3IBYg4xefI+2HEUUYTltsF5u3sfZLJr7ITv0Gy3vFvHUYnl+yPkrP65ukoei8MigOHFAwJo55svOIEPllAfyXfW2abSJ3Qh8k5/5l5/tR2Q9VlNN3mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581949; c=relaxed/simple;
	bh=4X8xvfDWKK7iJ8HJ2+2Z8ZYQi4piOj2H5rfklttg/rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGVkrXbM6fR1UsJsL8Mf8hsMhZpv7OIQD+FyHMko8EpfrRtqivfJKT7fyRXQIxkWnA6sk+TwgZ8mJIxNEjS2zbj0cCT+8V9l9QbM2E7er5HT2fM8aKdqF8+ZxnTAC5aCAWt5bqL1Hti+UZaop1KqsFQgHZgl6GGB2IM5RyY613s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3keJDhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3keJDhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E8AC433C7;
	Mon,  8 Apr 2024 13:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581949;
	bh=4X8xvfDWKK7iJ8HJ2+2Z8ZYQi4piOj2H5rfklttg/rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3keJDhyHtnOmHZ2NxUHMBp0Qw8I3G1uxRcTSGdYq69zvgJhe+3XkZLgaRHqW+TCu
	 ML7UgNetfqltt+Um5EiwxDzjCS/7yrIgGtHLLDqGFAce0dOlfP6mymgLdIsLVN2SpY
	 8bKLmYsa51rHsNqzMVJQWB7bv2dGLVG4FrI6+/sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/690] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Mon,  8 Apr 2024 14:49:25 +0200
Message-ID: <20240408125403.078355607@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a8353d7ab36a..88aa00a1891b3 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -222,7 +222,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4_hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	vc4_encoder->hdmi_monitor = drm_detect_hdmi_monitor(edid);
 
-- 
2.43.0



