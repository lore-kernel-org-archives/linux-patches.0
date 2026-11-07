Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064307;
	b=l9NnWkBalWGReuajQwXHXkIdajFJxfWGJRWEvnOVzwZMiRpYvOhNxb7gr+mbb2ofeLvq
	 vHoBQgfIbhfJS5htIW0TTLkDJi9vl780YTevgPsrwojqS9pWIRK/ccv6bCfSldUlUpief
	 4Hjle39AP0ayADFtJq3FTsxSWR05dALHMr+25AtHcwwrsvBSG2kkoNhaIOgC/fsQeCWQf
	 tR7hso4ogxmvTCyPO4PplhpVzzBQCzYsszK3s+No/qo6OzLSnJ/L1Qm0laL6dxGNrZ7qk
	 K+7pLn15o61RPLsu8knQYp9THP+DW/2hoWh29b0Mg3d0eLdalSyhaKxHIbN37dePAJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vC2N9aG8EBSm0d0fFqcY7V81n+E4n8iAbqpzmkyOX8s=;
	b=Wssy75RJfegvZFigI+0myZbOWhTtkDM++3/b67JAjKTJewJXuFyWMV4GtK1E0fIbTRCm
	 OK2iK+ECBHKtWZ/xl41tt1kiFMd3udhiWa247R4poDUPY4rw5hiqtiHL4A7jMwDBLxTvz
	 kcnAf6+bSIdge9I2T+pCNj1bVOHctoMVsYsnQRi41JF7m3ND6l+b/6zVfyxLb/udbwr+/
	 UUEWJ/IQoo6PeqJGcif7NI92rq9SIM/ZAFtNCa+Z9NRvcKxoIaoCBrOqv3AqrFUyji/4y
	 /YilmKCCLJI4QBMI//kIFi4tCFc1ug/182rzJ2kqxjbZLikDzer4JlzjFkmns/6b14Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Jz4US+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E769606C025;
	Sat,  7 Nov 2026 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Jz4US+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6B41F0089F;
	Sat,  7 Nov 2026 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064306;
	bh=vC2N9aG8EBSm0d0fFqcY7V81n+E4n8iAbqpzmkyOX8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Jz4US+J+3Xa6fLxIQc9qzasAyCDuxaQ805DKudJAoUsPT9ML23UnAO8SSQRzY+oR
	 AWxFrsDFFuHAcCTA0nt/V2zo6Fw3aWkY0HW7wGHw0eUCEskNmfYOgvg3EIekT91iae
	 lEG6yR0C2Hk9JEIurHtpha0VjiQFUbc5C/zDinHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0398/1257] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Sat,  7 Nov 2026 08:44:54 -0500
Message-ID: <20261107134950.532982853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index db85400e574e4..1860605850c9b 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -339,10 +339,10 @@ static void msm_hdmi_bridge_atomic_post_disable(struct drm_bridge *bridge,
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



