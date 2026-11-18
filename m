Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052406;
	b=u8nyk5bVBF8k+fszGnTh3GmEYeJ8Mhfy4FEMzuo4QDE8VBJsRUKknWGSBm6phW0b/1Jz
	 MsZqH8NmicWceq9QXE5feUYTCzYYD2fKPRLhcXpDGFhGms49RutANXt+Q1oClxLXzhmqZ
	 PKDbwByPfIb+SIB2n63gj0HxolyyBFC1Xc4R94giwnQIv1EEasVdCK6UhGYFMi8t6iMEp
	 ez/uf0N1Gn6+hGVZarwvz3mca18b6TTvy0qtYRfx/Yz6zuSuG81U3hqLFRYeez59imi98
	 HjyC+kgFN7CjVcOpPx7xaHvReY9r9mvyPCdMpnXHB+yYEsOZo3xuYYu4c+W2vD6MMCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KLyrKnEMUjA8vidxOfYum/j+MyFGuVyKvj3UQBOdsw=;
	b=dy72NumaWkhlqnYstPp/qpd2khOMPke4Bzn0zmvI4NOIjhLiCoCKQG1nlygEqMNkC07z
	 IWlWtbu+ntwRevQI4OKVJrJtzuntTha7bPSSZNR1mHB4RVYVdJdRPLHgnGGwM7BzVOVY+
	 9wQzrD0S33SU7Vhj+5X3A0yC8oOjgfN58KWZ2/uM4+LbgK80JOdhDC0xf7wNIDYFSGJGm
	 FL2K4PeEuxln0bEXM+wKfEDKuXtw7OSl8/9bNufadannIY2uWQsVG5TKE8ma6MWCtOg5i
	 4/vQcj5oFa57PkJ29qRs0fFuCZnVQlIDF2PvPr5SSd3HfeKv/TBesaN8hayphagzCMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tmHfrRzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B02606A31C;
	Thu, 19 Nov 2026 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tmHfrRzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384C91F000C4;
	Thu, 19 Nov 2026 01:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052405;
	bh=4KLyrKnEMUjA8vidxOfYum/j+MyFGuVyKvj3UQBOdsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmHfrRzM4EBsGTZO5UNFK2r8f9VSt8NqwGTu4PYWDx+YAxiWLVl0rhOGy8LCiWKRo
	 rvRljYbDkWH/FFCwn0rvgZpCoYK/iWgdnyGD1qfZEFkumoQvqhH5Vz0tQ9Brovl6fH
	 J+yMAi0M1nGnN8I5zn/ASNPI/0Pqk8rDEEj0kCiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0551/2214] drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable
Date: Wed, 18 Nov 2026 15:37:07 +0100
Message-ID: <20261118150033.034382255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



