Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047981;
	b=tU8DHad0D46fQhgXiPifL339X7ar0fzn9Fuzk92KD4FWQZNZeXqUaW11I6oNLXBW4Z1u
	 rr1iq53S4WE/vy8/dWmtG8TkTBr54jGDSrYvS67wBlQcqaEtT43dvRaS87IiNFBGXN8+m
	 A3cdPDgN2vohQZvk9sfeTk9p3dmD5oTk1sx15kXfxs0X0zZGaSeJlnCM4930pBLdpjp0S
	 Q6mrSRnB0BMM3IkG0IBUPIU61f0DKFOtk1Y02i67F+1hsFjqX0dlIPtdhqM56ZDY0NGhy
	 e7wJz06p+g3p4B1DL+AulkUNE2eS0+ickTwXYmHhRdKLZlz8m0m1LFjG+2/y/pNlOTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5eAAcg0sTcMzALLMOkmJk2MOgiam7dnT11hJf8xbGgM=;
	b=lSvlc+eiYcyB7g2ekIIKNKHiOeogT+s3hFm8CnF+rc8wQp/43qTPr7dSaQUYS2xHqPzm
	 rquysP3X4ypuXb9/uX1WmoerTVTBm1KteF4QCdg6WQQVXSE2kV9tNJ83qxqwTzUEammR8
	 6DN6fHpAMlpXFYU02YYCqYVNnQaByf6wztWn294K0bSNU8DInY28AepeAePx6dZn1h/Jp
	 DXoHYJaGz8AE5LphSQQByFgTyCZ8A6DxO6s5h4VVTGZDWuylgKy0vOKZlJKAMXJ+BQuI5
	 fEntMC0GWOg1qQI2jCUX9ao+Dntaxy9as/hIfIZQuuliehN0cHI6AdEHHiS85kEh1ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGSHm4GS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7071606A31C;
	Thu, 19 Nov 2026 00:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGSHm4GS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE94A1F000C4;
	Thu, 19 Nov 2026 00:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047981;
	bh=5eAAcg0sTcMzALLMOkmJk2MOgiam7dnT11hJf8xbGgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGSHm4GSezk2uDtfp808Qm9ws4vEhnxtn/TtPJj0npC7ibnUPGH8riBoYxH2dUApL
	 Dmk67CSJBK8PCiajKxZXUTWh2DUlSqmVgDH/xjD96H6IhAWRZ0NAHL2KUohFFN2CEe
	 r3Rwo29iWMY+WW1/PyqSy1EtuuSJI76UMHFeA3Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1815/2857] ASoC: mediatek: mt8186: Fix AFE clock error handling
Date: Wed, 18 Nov 2026 15:47:29 +0100
Message-ID: <20261118150306.592067077@linuxfoundation.org>
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
index 43aa6d3b53a63..87b5c23986cf0 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -290,7 +290,7 @@ int mt8186_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIO],
 			aud_clks[CLK_CLK26M], ret);
-		goto clk_mux_audio_err;
+		goto clk_mux_audio_intbus_err;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
@@ -317,24 +317,22 @@ int mt8186_afe_enable_clock(struct mtk_base_afe *afe)
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



