Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058451;
	b=ZxHER6TPwPfiORWzKGMOyy3aDpBW3Qe7NOOqe8DlIzbMjV1oPb30dbjMKspNX2+srjsp
	 UA/7e/Lg+NEAEaJWibvuTs1d7T5zAreTOPsshQ+MB0GKhpzstrK4CqMlMBEDkUeC4WSt+
	 pUWxK+A6Nv5zLH/luIiqRL3ODJc2zbNJ2lkLBBPeEWyPWZaRs7ohmx/ti2ebA/G6dvrl9
	 zY48tHHtRwZRzbduAf+uQagqeS9paYkla3VU/yRWYmELJB29Gj+WJloKDUv10CIf4Vu46
	 aZcflsFQWPCKkfQCnmIifc3FbaKvBG/eTLUjAU2Nm80oxYPvzH6LzyY10ogLX9J3CIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NalJsc+llC0fqMc/6L04aaCGhue88jfYAfZAqzL0aOk=;
	b=F05Mgr+/pQXhvcMWGYDFwEZMyWRK8qBhv17x139ivMzWqiCbQnbvc/XnOJ613kBzefUl
	 8wHJekPMz0rqhSaiC06K3XrZd2392NRo+2EtPIiltcEagSQiwL33XB+3JqlMXCmHiwaiy
	 afNuqNcysJ52t0NNpAM5yOAFRo3Hd539vQEw7tYCxK0n4IR8uO4bxi+z48dRAeAmNp2HW
	 ENkMDD7ytPUz984ldtWYfrqgpeqx6jYUTIX6JvT+EOF2eNUXzY7VIBOzjiwxVQFv3EZLa
	 YF1SOEOLm+RhBWmvAMU3ITCsYpBGWaxXy8uXiUrZTFdCt8m8hWO7WAGJVJzLWamStqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bGPsIEMA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188AC606A32A;
	Thu, 19 Nov 2026 03:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bGPsIEMA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC141F000C4;
	Thu, 19 Nov 2026 03:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058451;
	bh=NalJsc+llC0fqMc/6L04aaCGhue88jfYAfZAqzL0aOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGPsIEMA4phBJ/Q9G5xl71b4c8CnL4qUcA3yvtVJDFpcKdsqMXK2iOf1D71fnDN1r
	 8Hp2BZKWkRN4XzS0ii6z6cBq1kEwX4XNICMtYPULKTYDSaD+f/FDPA1tXI+5rMN4LW
	 N58trfZVRhCXy2L03fwFdAz0ga1JMMrTyvW65B90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0448/1848] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118145933.118459367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index efcfdd70a02e0..11b1919e37b1c 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -189,10 +189,10 @@ static void msm_hdmi_bridge_post_disable(struct drm_bridge *bridge)
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



