Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3D3C129;
	Mon,  1 Apr 2024 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988480; cv=none; b=C6v7GkbTU4CBf+BHOH4CUh6NTbNG2VwlEQRchF3N8xWGpSTxrn/G7zmuBPQoynjMw3ROK9VdNAW4+UgTnFEEyP3ov9wMV51lgZb4KTJGdXYZx9W3nMqw+r7aphS3MZrA80pYecrWxJpmV8Gkiz5wdQ2YLj+wKvW+HclusEkhMsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988480; c=relaxed/simple;
	bh=4eBGXpjWeE9m3oh0jpDUCBf8KrqECFQrPARXrpuO+x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4Ijvtk5PJ1avWccJbT7TFdEjdEXoac8iMM1fSGh4Mynta3pxwnXfwSSwpooF9+kknAqiUlV0aYoTCH/Qj48o75oSyyoH+9oJFLjeCLXVwz7lbLa1Xu9hkH/S1qrUCgQrrhh6pViU6MA+VXW4RQCRqyTQfF8/wghN+RfyeonDnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlgfmMTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlgfmMTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED1DC433C7;
	Mon,  1 Apr 2024 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988479;
	bh=4eBGXpjWeE9m3oh0jpDUCBf8KrqECFQrPARXrpuO+x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlgfmMTUq8+HcQR7FC80jDgJxVglUnMkGPYEGJp9o9ZFIFSYB98xK2AClZ2EB4/tn
	 jN4srXt3RaesyLvBcdk5V++i9Jjvrv3+B1JoJsjN9HhESaMWkvKvq96gyXMs2C46sC
	 fDor5tO84huaEswXQFDdsvE26okQ+kaxaeJwwu2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 168/432] drm/imx/ipuv3: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:42:35 +0200
Message-ID: <20240401152558.160947843@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/imx/ipuv3/parallel-display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/parallel-display.c b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
index 70349739dd89b..55dedd73f528c 100644
--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
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



