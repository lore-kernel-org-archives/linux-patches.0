Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062182;
	b=Dym7Yd3rMCQgKMtyALbBw8YDJSb3eC0hDol/gk8PEL8jaiFXMGVA0H74gaiRoi/CG3TH
	 TXwNzbls+deZTxPhGsOvKSe3ambb3K5VOEDebE5UCYgfA9iKs5SH5xTghY2T4E86wK1JL
	 zVz6vcdb2DCobFisHfCWFrW5r3YmkGkLLuA7OjqwzkuCNv2JjrRQ3YSakvgwpOvYSXbij
	 Q1IqFW9ArYx/jmmfm/vxyTLs1LxUng1q+wyrfpAHJMwegTrmX4vx4VrlMBaw822mFVGDz
	 1lL4QwG8ED9WgUlHYFTI9W1pu8a9i1a8RXtaAlRpsxosq2GkQjItqmBwA9o5KJB83hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oP51uGYahEl1JtL0iTOXU3V62oofSPob7G1kFwK9oB0=;
	b=tfxTQRYZfADm1YBQc8yKEKjw6CMpRJihaBMENzoQ28WDwKAPiZQgAHsDlxV0zcxS0PLg
	 KgCkYviUigtYWRAgnOY9WkuuhxnZQ/by3T3KJ/zrf0fIMu89Aznpd6mnDLuc7HpjxZhwC
	 YeqzqWoRxYF0eFxC4gxobzeuloH40O7s8tqCgcS8Zu7/d9M5cHiY2SATNihlQrTosyU6M
	 vVUdqeW7bVT8r+C/O3/mHcb+g+EpLLEI7Ecq0bBYrcYoVd7RMayIlolevX/p99xUrvrie
	 F5zWa9Up7Ki3GY3WTYkS24SrJirHUFTkrYKF5lRLckYC14jiePmctaH4JYHHGXDY2RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBXeulEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53510606A326;
	Sat,  7 Nov 2026 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBXeulEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0195D1F0089F;
	Sat,  7 Nov 2026 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062182;
	bh=oP51uGYahEl1JtL0iTOXU3V62oofSPob7G1kFwK9oB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBXeulEFvLq7ptGiUDatnd1qE/EpNWvtr1jP8gpRz/GTyToTxnZKTK5Mdo0+83bBL
	 6CI5OtNMyUxxlygxJeiJCCu3xWoXnTmTAebxAxgFMrqQZZ7KeaKOmYlqXTDG/6NZuO
	 zZK9cSt7tCneHajr5IDf4lODJsaa76Avfe7/IsOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1114/1536] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Sat,  7 Nov 2026 08:52:10 -0500
Message-ID: <20261107135028.997300465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4a5b5112227f5..b4abac49f5d96 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -167,10 +167,10 @@ static void msm_hdmi_bridge_post_disable(struct drm_bridge *bridge)
 	msm_hdmi_phy_powerdown(phy);
 
 	if (hdmi->power_on) {
-		power_off(bridge);
 		hdmi->power_on = false;
 		if (hdmi->hdmi_mode)
 			msm_hdmi_audio_update(hdmi);
+		power_off(bridge);
 		msm_hdmi_phy_resource_disable(phy);
 	}
 }
-- 
2.53.0



