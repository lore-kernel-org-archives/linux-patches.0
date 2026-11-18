Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039390;
	b=dzx8Fd7V5scmQyL+G6SEP0Z8LFnLxQBrmtO39DevOg6tM9WHxpq1rAm9sgcGVrLNNA28
	 k4GLLWF8eIt8EGbCD/eIPymYcoF/rDEdVqx/B4GTVACpc+ZrV5WKtIDEFTjMlRG6uH8wg
	 1IPBrGmfYMLAV+zu44sMNR9087Z0awb0FRGwprWekeXyOKmSvt0C+mwR9/1RkK++dBu9O
	 xQO4rVgesYZ51vGHH68syh2D9eQXpYQ3HAFokBBl5DhZeW6kvVLoEolg+Wk0PpezhJhaq
	 ArrA5EgRSuwcYalvEDhcYeUrH33ahi1Nwv8XlE9E9BG2RfQtZZqXeFwqGKIlbRNeoHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0F/aktTneD7N3S4rBcmINGC9eVeC5wj7prqoySWa3Rc=;
	b=43/fnwR3V7IDxuoOZMvHrI4HvxJaEk8BAi83FhrhHy9Jrn8/BllyXjGOTf+Obu4yIiqn
	 FwbHBKOrneMvacHa+NIoIgU+7uzLAznmuUCUM8VEj1j++cZHYmEx02ifsGU+DxnZWhGP6
	 bONkYsGFtVIKvJGq3vNPLfW3w5EWUHbvT3nnW+gTT8cYZNs0FhPeQ0NVLRL/Xe4YkrFWc
	 5n1mXChJEWBVtqQz2pZgAozQvRoGa1puUxDqnp04U9v46Otvmw7dczMYaKhnjsY9U87zN
	 8cLqHbrBte8ugeGVquBtgBR7aWA3x0cKSelbV1SU0ALTBt0mz2og5gjcNT7dd0RkbQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHM6VZlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE0606A320;
	Wed, 18 Nov 2026 22:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHM6VZlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63A71F000C5;
	Wed, 18 Nov 2026 22:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039390;
	bh=0F/aktTneD7N3S4rBcmINGC9eVeC5wj7prqoySWa3Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHM6VZlbvSgQNpjmXMp6lLcC+vPPq3lM1fWeF47AhOIHbij3Yu1YLZUpNVDf44azF
	 J4f3rQnA4aGOGfnSilLFtv1oI9GAuaLLcRUdy/Xt/EDfzw1/t9S4zTAglTU2CvMkhZ
	 rAqKtip+4XS6v62L/ZKekoCUeAMOciouDV42n4mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2082/3318] ASoC: mediatek: mt8186: Fix AFE clock error handling
Date: Wed, 18 Nov 2026 15:45:04 +0100
Message-ID: <20261118150424.547549684@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit eb72060a1966baf9a6ed753186621ee6e39dc889 ]

The error paths in mt8186_afe_enable_clock() do not consistently
undo the clock operations performed before an error.

Fix the goto targets and cleanup order so that the audio internal
bus parent is restored to CLK26M and all previously enabled clocks
are disabled before returning the error.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index effc4193e63ea..13781d5ca5444 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -288,7 +288,7 @@ int mt8186_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIO],
 			aud_clks[CLK_CLK26M], ret);
-		goto clk_mux_audio_err;
+		goto clk_mux_audio_intbus_err;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
@@ -315,24 +315,22 @@ int mt8186_afe_enable_clock(struct mtk_base_afe *afe)
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_AFE], ret);
-		goto clk_afe_err;
+		goto clk_mux_audio_h_parent_err;
 	}
 
 	return 0;
 
-clk_afe_err:
-	clk_disable_unprepare(afe_priv->clk[CLK_AFE]);
 clk_mux_audio_h_parent_err:
-clk_mux_audio_intbus_parent_err:
 	mt8186_set_audio_int_bus_parent(afe, CLK_CLK26M);
-clk_mux_audio_intbus_err:
+clk_mux_audio_intbus_parent_err:
 	clk_disable_unprepare(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
-clk_mux_audio_err:
+clk_mux_audio_intbus_err:
 	clk_disable_unprepare(afe_priv->clk[CLK_MUX_AUDIO]);
-clk_infra_sys_audio_err:
-	clk_disable_unprepare(afe_priv->clk[CLK_INFRA_SYS_AUDIO]);
-clk_infra_audio_26m_err:
+clk_mux_audio_err:
 	clk_disable_unprepare(afe_priv->clk[CLK_INFRA_AUDIO_26M]);
+clk_infra_audio_26m_err:
+	clk_disable_unprepare(afe_priv->clk[CLK_INFRA_SYS_AUDIO]);
+clk_infra_sys_audio_err:
 
 	return ret;
 }
-- 
2.53.0



