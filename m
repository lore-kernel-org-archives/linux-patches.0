Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29DB1DFF4;
	Mon,  1 Apr 2024 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991050; cv=none; b=kfH4NweXP4CKrZV5hNIPFdjN5c/s45dd3NtLDstMmaX7/KM3tH8Yf5UGkBgHvfuYUT+ReJsefGQDSRZhM+cIFYPHyPA+IGC5Bt8WpmZruM/04gyheZ93Lqcwf77BaoeE+MsmT3CMgunThdbLjf/AYI/MhOFJoSGcj/2lDNRNspU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991050; c=relaxed/simple;
	bh=/koHFeNz+HL+427PvVIYvN6/Jw3eIdAohm3Wtmp0RkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWPFvZc4aCdsd5BlwzYRRx62HzHzPZxlFTZ77H623o6Kin/mVfsIvlOdyNNvBpg2E31w1P1rQZzqWFrIstSLqP32uQh1dX36BZsy/JMG1XixOh9yYKb0Q0+32DoQUeHwuQQTH3MmiC9liCfrUt2icC7ELKA36koH9J4WIfYpK50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCRfSzAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCRfSzAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511EDC433C7;
	Mon,  1 Apr 2024 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991049;
	bh=/koHFeNz+HL+427PvVIYvN6/Jw3eIdAohm3Wtmp0RkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCRfSzAsSfeLCgiyuTGsUorkWsk/i07AdiDYyl1mfPQuZEGJQNKYkTQmY0dIvocpv
	 sRF4wIt2IrlDA34tEyJ9x038vHNgLnx8BocSHCqGtMWKil7Kj86YDtp4anGUXLop7H
	 ZgqGq7wHpxM5xZzHQl68k5dVjSmO6qF22ivXACzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/272] drm/imx/ipuv3: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:45:08 +0200
Message-ID: <20240401152534.357033630@linuxfoundation.org>
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

[ Upstream commit c2da9ada64962fcd2e6395ed9987b9874ea032d3 ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/311f6eec96d47949b16a670529f4d89fcd97aefa.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/parallel-display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index 06723b2e9b847..64b6bc2de873e 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -72,14 +72,14 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		int ret;
 
 		if (!mode)
-			return -EINVAL;
+			return 0;
 
 		ret = of_get_drm_display_mode(np, &imxpd->mode,
 					      &imxpd->bus_flags,
 					      OF_USE_NATIVE_MODE);
 		if (ret) {
 			drm_mode_destroy(connector->dev, mode);
-			return ret;
+			return 0;
 		}
 
 		drm_mode_copy(mode, &imxpd->mode);
-- 
2.43.0



