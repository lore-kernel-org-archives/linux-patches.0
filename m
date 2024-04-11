Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF5B2EAE5;
	Thu, 11 Apr 2024 10:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829655; cv=none; b=hm66pNXRQp80InvwjeWJcjVE8gJPUsjKc08xYqfooyYkiAcV35ZzQ+ga7SDedlqfMzma+aIT9qtLtLaIIwvDOCcNija4ueBqk1BvcjFlFbNWwqmta74uX0vx+fNvv2MQjt9wHwYo5OCBi7HRyyBAipR4PmaliFcxv1Nj4cv1O2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829655; c=relaxed/simple;
	bh=UclLc3x3cfMooEG7uwxUoiB9DONvo5+Nmcrzcr24rlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxkRS3TGm4ljEWQCPwso7cQ+eebG8/UuP/lwdLHcIr+C8PTZ0DB9XyUdkKIxhWBMyZst/Cx2PDe/eIfxNx5QU6ewHXFu4wnGt2+2eiqu+DxvjxW90u9ZOgq6bbAr3snXwclCcWHMr2ZLbxMsZWZzLFYqwyQ9bA3RJ/KmXuQ7g5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxXtuc/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxXtuc/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B725FC433F1;
	Thu, 11 Apr 2024 10:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829655;
	bh=UclLc3x3cfMooEG7uwxUoiB9DONvo5+Nmcrzcr24rlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxXtuc/MkD+0gcvwu85tVHGgAzhs6dj2/M8UpjTlbXdQV2mM8uEiRpGRueA8qVbZd
	 zTVvjff69i4c8uf1A24UERUkwyp2JdGVnRBnqbaOyxvBsdETzIxYs2YO5034/T+zFs
	 L8+K1uQT2aj1wzyuAv12wOM9zRzzajpD7IzOjirg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/175] drm/imx/ipuv3: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:43 +0200
Message-ID: <20240411095421.372489820@linuxfoundation.org>
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
index a96d99cbec4d0..290f68b9adfea 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -78,14 +78,14 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
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



