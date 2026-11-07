Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063065;
	b=CLdZ6yhpq1pDrkS5Fset/SLvXVxNIKzk8O8WDSB2HZ5djiSn04ishtTtNPdiFw15xjcs
	 Hy8mRozlHPWzwToN/665qtDBOQtnPELEp2UmgclYR7CLJ/LnTiSY9OPToQgKrJhy6OUPI
	 oZfQZ5cYMSyHtsyZDx3NJVhWXjF78JXGmY3UjMxN5w0fcT/KaqdxpvAEZspaTWuB71MOV
	 LYWtblzoT/Du7f5Pjpun9+0Ou8EQMIsYjXUUqglXXaAZg2gkRJBIvGbINGIdOHX+8cHm6
	 ocgrRFQt5hkW6P6wHUAWipj4BeLVQXo0mvQNnyVcJpdcD/VNQwKcfCNz6tx857BRbaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3BTsAKovALrp8Dar4xZRYfpFYVmcH1OsyHatqnEWYQo=;
	b=Fu2IqpZKUuS8CYlMWMB6iztfXfDNBuxtW3wkfYrC/T8mhKGU10wb7NL/HMj2RSwKmMD5
	 zmJTecMfVEgw5SEzrGkejaIh3W0LON70abaQ5WZ70lonV9PBbB8pU2PmufiTcny/E7wzR
	 DI3htApfBq/kdJR/51kVAkLYafsknLiAC65NvANth89UTyMH2BhXQVGDDkPu8YuBAdWUv
	 +SEMjGNtBYXuXCnyHIwQL5jr+TKV+brxzGCvNEPGIo2vR6qWwl5w9f/2VvYQMw+cQM9xN
	 DmbFE4C0fCinFDwl1pWf2aRittwv9N9cGk856kd5NcsKMWn2yOK4ZYFYJwfl48iBQ5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6vHvzDK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E38606D82F;
	Sat,  7 Nov 2026 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6vHvzDK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C5F1F0089F;
	Sat,  7 Nov 2026 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063065;
	bh=3BTsAKovALrp8Dar4xZRYfpFYVmcH1OsyHatqnEWYQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6vHvzDKJ3oERRgHdiJ2r7/Ms/fA7kdgCZL05p3H1qKYJJenLe3RGS1Y6059yWZ79
	 S80JTqTkk3h1dmNQV++w9R4M3HISiIOMopIQX5fPyk49eibdSKZSbgEav1nr8qXxIb
	 aIx/rZH1Qi/v6RtGTgyDqHwiM484WzwFKdEyjGYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/869] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Sat,  7 Nov 2026 08:49:48 -0500
Message-ID: <20261107134902.919759809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 0499f0576e4442d67c164119f9d7f75d3cc945e7 ]

Turning off the power in msm_hdmi_bridge_atomic_post_disable() should
follow reverse order of powering up, not only because it is logical, but
also because msm_hdmi_audio_update() accesses registers thus block
should still be powered on.

Depending on specific timing, existing code could have accesses to MMIO
of powered off block.

Cc: stable@vger.kernel.org
Fixes: c0c0d9eeeb8d ("drm/msm: hdmi audio support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752655/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-3-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
index 45bc4db5f66cd..75dea34c43a88 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -354,10 +354,10 @@ static void msm_hdmi_bridge_atomic_post_disable(struct drm_bridge *bridge,
 	msm_hdmi_phy_powerdown(phy);
 
 	if (hdmi->power_on) {
-		power_off(bridge);
 		hdmi->power_on = false;
 		if (hdmi->connector->display_info.is_hdmi)
 			msm_hdmi_audio_update(hdmi);
+		power_off(bridge);
 		msm_hdmi_phy_resource_disable(phy);
 	}
 	mutex_unlock(&hdmi->state_mutex);
-- 
2.53.0



