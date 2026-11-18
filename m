Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036264;
	b=ZLTHesRf9VSocOFE/1/1GLQgqc8dDCGG8QF8jE269TTq89ziAzn50e+IemCTsNA/41K1
	 cZlM4avuVrPx2ad9WG+YIx5GXSjjs4ojzkWEhTM10p+fF6MVzFEt85oZ5calrm/iNgUi7
	 3HIRD+XsV0lvL7zKFFINs+tZFNXFvb59ganD73eUJX90zRuQ8r+LNDo+HGvLCqBkkSYpV
	 xXIh+etk7auqRg2QUTpStoXKkjmDH0b1bUwxZmN8tuI4MeQPLXgSMyEkiLzkF/eSWx8C5
	 6t3f5+kug4yVXjpW+1efsIYLVVmvs/MU5MoCcAXMrX0ZgxTmg+cpQojZqB8CHDMzc8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98LfplDLKsVBClVyahBMhyNM+0SF6HdWs3C2NqKWp1Y=;
	b=LfWRlU/F/07bXjLM/hHP7AXrDLDGgoWScjz394ykslIhpUbBhsRaWq6PgXaPIbygYd2o
	 4ZihDA3IK3A5hEGvSuPQIquIEgLVJl1oTmCjb9hBckDTjq2g+Al7w/sZV45JxUcfwWMrv
	 HBa80Zhb1W7s27J9Gta+D8b1i35RiGBXe9kHOJFTNbKYSUANs02wRAfp8INp5erRNWnyR
	 9R4GTgrittL322EvYFbJoULp6n3cys6cuXYKvQMBP9hifCxKhH12a6rP5/zEKUraWoGCD
	 xJiE7bIphENOHxRtl3Mw/nGdJjUzCoCN7zkXpznP5hc1gbW51kyFK2OMx/oLyjRW0Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvbn8X93;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32885606A31C;
	Wed, 18 Nov 2026 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvbn8X93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2081F000C7;
	Wed, 18 Nov 2026 21:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036263;
	bh=98LfplDLKsVBClVyahBMhyNM+0SF6HdWs3C2NqKWp1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvbn8X93t9BNiaXryBOhtcVaL7EeCdq3As/kd4PC5EJYxclu9j4u5vYqZY+4vYvm5
	 SeuIAKn2RuK6YvbDcuvVl5YJut0rJqtWLv9msRpxZ8QLE146a3z5SWZrdoy48AboOr
	 q4T/H5QV4ddyPZMB+aw6ygktkQiUFbSJDgttqBOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0970/3318] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Wed, 18 Nov 2026 15:26:32 +0100
Message-ID: <20261118150348.791661461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9b1391d27ed39..919dcbd9b06cb 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -175,10 +175,10 @@ static void msm_hdmi_bridge_post_disable(struct drm_bridge *bridge)
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



