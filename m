Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045353;
	b=IERYKyex5TCL3+VWg4DnBODUTTzT7gxQVZeIu2H0fK/g7YW1OEOga+yKShIsJSt/DRfu
	 q5keY290XpGtJS3CxBY4crPjZqss266psL8lwBWgKzVdtcG4yM075mFQxRGqN5aM7QspC
	 TQdsNXT5MgcU3KkyPkR1NPZKt1E8W1ECZAKKN0Ha1FQND48MajP0PgS5Yp6XbbQIBmsdj
	 8K8BXwSRkuol1dfyBWTggDC/+ZVCZrFL6IsSJuwiZa9/LcvPRkIiOXP9C9TgLYUOU9sPA
	 oZuAVKegfyDVOg8ZNMWWeuO99Ky3nO9MDFEh4/qcDPFqPp3BLACcHzEipUg+d2GE0cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/c43w1q4uIym1CWnAFOKEGUX6yZHDERaE0RETFVATcA=;
	b=02OlWg1YU9sIfbzpd9jn8NI80ACg9UTdVwr1Q/IlPgNvxNWe4vca4a4Tdwg72KAD6GcU
	 4OEq2FBa4c9i9nNZtuAdG4f7WCoQH9pI9MBfV8dTKH16xnU/W/cymzkngp+rTiAEAjvt9
	 Zbc2BZ1zbmAoy2Z+ULF3w6ZKVY6wRdoF2gby29P+oX2F8BkOZh0AxNbwz4sXoJgpBj6Cr
	 8Hl0cBjwxLoB6CGbZmfvGsdI2DZCltMZVPoj+s6DOow63rw3iF4U8kRSpmqJgYcwVATU4
	 Cchx8xbeEkvbHSyE5RZNEgOO83Vaaoz7+kCs/Kq+gsA51p6iQUPvW6CRarb+zBlY1eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MZfc/YYe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC0B606A325;
	Wed, 18 Nov 2026 23:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZfc/YYe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E0A1F000C4;
	Wed, 18 Nov 2026 23:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045353;
	bh=/c43w1q4uIym1CWnAFOKEGUX6yZHDERaE0RETFVATcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZfc/YYewXabYVZK/B5dmF7QDZKvcEUYv4zKST8hNSkdcvJS/W1Y/AWG6IKUEYckd
	 MSIQuNQDEQdkqDyGfJIEZ+i9rv1bV1OMTSQ99yOriHrVmz1DPqlko0a5zVYlOHDPJ7
	 A9oJFE2IvwaKcUOy/okxSIvTYzKFgrLGB8+nqUQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0843/2857] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Wed, 18 Nov 2026 15:31:17 +0100
Message-ID: <20261118150231.927991893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



