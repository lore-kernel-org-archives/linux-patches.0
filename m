Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79673285063;
	Tue, 17 Jun 2025 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178105; cv=none; b=AOKJK/GyVKCj/awD1s7z+rPm/rRWnqcXbdpBoFdoWfN7YEGxtNiYwrd4h0f8YWWtiF72TrcUy0RDvr6QaN8u5IZQCwZEN835vSJRIaBFIk7cLA6YVad1kiRHriuMtXgBhqqkPdok0RrX4484W1KJw8ley5eDvmpehH1JNYENQdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178105; c=relaxed/simple;
	bh=YDJD12FLMjyA32SR/slzRI73awAg6/gxjve8WxoreDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwC/wqzVmE5buQhAfgsnSA/SeikSePNpLr+Qx2XSZUi5iPnBx4wUc3hfc108QEiUEsyqeJd6mZkwFRP5EZ3KsQ0a0Qykp/wDMRpANgUPQll3SlY1Rb0jpM/IuoymyGwBhkOnsdH4aKDCbEXcOqgYB/+V/JiYMiKMF7NTFHDGxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNCFSvVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNCFSvVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE157C4CEE3;
	Tue, 17 Jun 2025 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178105;
	bh=YDJD12FLMjyA32SR/slzRI73awAg6/gxjve8WxoreDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNCFSvVorebZPbrYCnyS+wnR6C1AEGQFd8A87UfNJQbCS7CYHawVpbWi374881SVq
	 RMo06W4LOEm/vWB039EftQ1XB4HthcLWFqRFcSY063ru62Gkec9L7vA63+/Eh7oPDe
	 ibAH0kwRajDTHgjoPx0saeUduOJNEySIKGHBeTBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/512] drm/meson: use vclk_freq instead of pixel_freq in debug print
Date: Tue, 17 Jun 2025 17:26:53 +0200
Message-ID: <20250617152437.679085259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit faf2f8382088e8c74bd6eeb236c8c9190e61615e ]

meson_vclk_vic_supported_freq() has a debug print which includes the
pixel freq. However, within the whole function the pixel freq is
irrelevant, other than checking the end of the params array. Switch to
printing the vclk_freq which is being compared / matched against the
inputs to the function to avoid confusion when analyzing error reports
from users.

Fixes: e5fab2ec9ca4 ("drm/meson: vclk: add support for YUV420 setup")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250606221031.3419353-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_vclk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_vclk.c b/drivers/gpu/drm/meson/meson_vclk.c
index 3325580d885d0..c4123bb958e4c 100644
--- a/drivers/gpu/drm/meson/meson_vclk.c
+++ b/drivers/gpu/drm/meson/meson_vclk.c
@@ -790,9 +790,9 @@ meson_vclk_vic_supported_freq(struct meson_drm *priv,
 	}
 
 	for (i = 0 ; params[i].pixel_freq ; ++i) {
-		DRM_DEBUG_DRIVER("i = %d pixel_freq = %lluHz alt = %lluHz\n",
-				 i, params[i].pixel_freq,
-				 PIXEL_FREQ_1000_1001(params[i].pixel_freq));
+		DRM_DEBUG_DRIVER("i = %d vclk_freq = %lluHz alt = %lluHz\n",
+				 i, params[i].vclk_freq,
+				 PIXEL_FREQ_1000_1001(params[i].vclk_freq));
 		DRM_DEBUG_DRIVER("i = %d phy_freq = %lluHz alt = %lluHz\n",
 				 i, params[i].phy_freq,
 				 PHY_FREQ_1000_1001(params[i].phy_freq));
-- 
2.39.5



