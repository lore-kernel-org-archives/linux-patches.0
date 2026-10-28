Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208519;
	b=JfUrnlq50WRv87Vq2W2gDlU2Ul4+Ng8xzeKlqHmcowYA1YtCf5jz4hzKDp4C4P1maKjS
	 loX65/C3/szxEJiTnkQC8EsGN8j7qTK05WJCOD83C2LEbuNrKvCW9O1mxZ9zwZbN5UlnO
	 7jklEU1Vcb3p6RkAVY1HQ5cOlvnK5wFX7JDrrHuveUlqSLs2faAslUOJUrUA2qEvMLenZ
	 tGSyZJtwFcyYPDkDwJMoUKG7r2S+QIB4qe1XeRbwAzRt+P5YVj8Gx1uXyGCvWCVcvHVgz
	 gBUBFLR3p8Z9de1vHKS87R38eAfui3pXLyM6w9W9N8M79Gkh/SilxLTr2JGU5qTRiFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XkrW4fIx4vQ6LgSdzPZRicrqj7vpawvIr6o+NxrB7Og=;
	b=u1U9+kUy41gbExzv1+dftrpSokYNe6hB4j16euPaEGTSXePxDpK06phnyXMflAjFxoue
	 ewuH6sEIvmVkZ8t7udcYlqTuQVukMIX+AzAboHzZuaDy9Mn0M0eKn8NrqNy+ocVDQGZLA
	 jFXFL4BbUDFT4eJJD6V+28IpRZn34uemUTr5bKxnOMBkykOTIMRhPrbXrop+knQ0Zal2p
	 Ik1EUMLfj+JQ2OX82w6pybK5qpqWMKyGjNm96X/xQCh8s79SPEu+364c9S1JE2RG4XAeT
	 anzPohG3GI2PdyIC7uSJ3U3h6yG+aQ7jEXP0GWjly+NDT0i4Kdy/ZoGf0TGR+mwCn5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wsafDP/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7792E606A31A;
	Wed, 28 Oct 2026 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsafDP/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61971F01825;
	Wed, 28 Oct 2026 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208519;
	bh=XkrW4fIx4vQ6LgSdzPZRicrqj7vpawvIr6o+NxrB7Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsafDP/qGJAPipytgnKCZ02FchoWe4aNfJTen4jD4bdvsrQC3DqDdIUm+AEfe6adH
	 7J8YY8efOxyfrca7i9K2ELdF+1Vi4tYAVzbQWkmznofUWgLQCpcfoc47V4j4yJNNEV
	 FbaLg1BumgR3C5j+WdSOgKmYeGQYJ77/EE0zGnrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/516] drm/msm/dsi: do not enable PHYs when called for the slave DSI interface
Date: Wed, 28 Oct 2026 17:54:07 +0100
Message-ID: <20261028170005.773165803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a14440042fe8dac6b7c507a946f46a6f50c9c05d ]

Move the call to dsi_mgr_phy_enable after checking whether the DSI
interface is slave, so that PHY enablement happens together with the
host enablement.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210609211211.2561090-1-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: 6cd33b6f4155 ("drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index fb421ca56b3da..5736665da97b5 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -381,14 +381,14 @@ static void dsi_mgr_bridge_pre_enable(struct drm_bridge *bridge)
 	if (!msm_dsi_device_connected(msm_dsi))
 		return;
 
-	ret = dsi_mgr_phy_enable(id, phy_shared_timings);
-	if (ret)
-		goto phy_en_fail;
-
 	/* Do nothing with the host if it is slave-DSI in case of dual DSI */
 	if (is_dual_dsi && !IS_MASTER_DSI_LINK(id))
 		return;
 
+	ret = dsi_mgr_phy_enable(id, phy_shared_timings);
+	if (ret)
+		goto phy_en_fail;
+
 	ret = msm_dsi_host_power_on(host, &phy_shared_timings[id], is_dual_dsi);
 	if (ret) {
 		pr_err("%s: power on host %d failed, %d\n", __func__, id, ret);
-- 
2.53.0



