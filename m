Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015715;
	b=CCZym3KzJUCwA6B1qYSopGf/1hTI0F+qwDSRrJx2ovH+Voqp2hNNMOp/s0D8m2bzb4+x
	 iCmyF7Iu4oIwiibGnBLfcE9/1E/Pp4fnrbOrS+0+rib2scVM1v8/36u+gAgW8Ozfh+jEk
	 cCAwzKquKmi3kD53o7EdGEA0uQFo1zXP+NA3Ulo3o5AAT01wo1cc0cHo5Gfa2mqPPQINA
	 OwJCQbe2qjV7uri4lpJdNgrkeB0y4ugEdRXEhDKD4UYj3BMM/2VUYFHAQijuMupT1F4hX
	 H3r4mzIv92TUlOw5Jojb6CAvoDsEddonjxIm6RUGmqmrrERimSlR5HkWcBCEF23GnwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gn76Y7BhQ94ZkGchg6hHDfg0M51YfBgbczYKmA5KwCg=;
	b=SMJKHhoQiX3AMEpHSyPl7K/PVlf5iaozL7KREZmqx7KiRCxUkt9hs3bstcb0NRl22D3x
	 tfCZluJ9Ht+NcKk+DIMh69nTjrz0X9x+Mc1HwPIWKPZSHWZFWlbOA+N54xu4SzTIJhsRx
	 rBwwEU1gRvTuwVxU70JIlZN0rrMuCuBK/+UfFRc75Ta0h8T6Npyf1UgoFuilBoKr2bqH7
	 o5yTmn9/laX577kD1tfASTSyAwM944oHghZ/K/VwoVqlNj7ruWJVxe7VobYNPCJbwWjH2
	 gry55XE0bxybdYEXunygTJf5hwKpFsAXEpCAHJW5sLvQMsghdTfmZkgIGaVPVBj3W8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aX7JRzap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8340D606A31C;
	Wed, 18 Nov 2026 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aX7JRzap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47E71F000C4;
	Wed, 18 Nov 2026 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015715;
	bh=gn76Y7BhQ94ZkGchg6hHDfg0M51YfBgbczYKmA5KwCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aX7JRzapdXTqOTqDn/b3ahPfNXWN0EnBC95lLalLp+1vYD2xATiVB1rlwA7utX9PK
	 Q7oBvJrWqYvGcmfhfuH2dlTqNx6dvZo/2acjsFHo/35tNXCRBwsfbV2kq6bVAeceV/
	 69E0fyn6sAYnWNqw0lSLNBmVPZO18vZj65Un217g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0272/2651] ASoC: mediatek: mt8186: Fix AFE clock error handling
Date: Wed, 18 Nov 2026 15:25:12 +0100
Message-ID: <20261118150257.701533016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3edd0dd20eed0..685dc27c77807 100644
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



