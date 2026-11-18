Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020112;
	b=r/X5bEfqCBm92SUubfhWI04MEqg2gHiEQs4seDshn1zFknlfrEiRJZa8AC83pRsTklIX
	 5IjB4rivAd5F7yHVbI5A9DbYDkWaSMg+vPlv2Avtc5O9ezHiSw+Fa8lUQaq67Yflqiwc0
	 0z7WS7t1RraA1diO+el2TUAk4Wz35UCrnDTcg8xub2Ge2hTcRSZZCJ09Yi5ICZTzS0a8G
	 B4blmBBJJJCjrk+iCrd1JfW7G+10Vj58AiHE6W/e8BpQ7gAqXOExF53UTAWFgu5gcu5Wv
	 XcqWH4QYwMKfmvzqCBXIbIK4O26JwTthPPo+lF/UVSzX+EwRse4C1fX960ZKwPPkRaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ajTlOFu2gwfcmwtyHfxt8DJcM0J8+6M5K5Yvdlx5XjA=;
	b=YAMOhEe4as6sBaP5kC38ofFV9yO94ceo/oED9IX9bFF/crWchhePjMWyz73tIsn9gRmI
	 8zLAyi7CFVdsSPXXgc8J3Kn8cKp5Dxuh7ie6MkiDRUnE2lv4E/CSZz68WJY5CQbjvwtxB
	 egFB5sDMnR9oObJ4JNP0x6TigYTPD58xM1oMvq8q5+OLik/VSYvHqGaTc6nBtfz2E2Z11
	 NSXYR1CUg+tKE/uOOT+pwLGwCykpxyJM3P6YGboQ1vrI6kZ2MUlg+Xu9lygH9qwPwOJWN
	 d/FhZbncAKSRxL+fJvggKam6pqbq1Tp7U4ryE4jmyFEYSB+ZQGENqoLrN8+4/hi2fpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Em96NFa/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BA5606A320;
	Wed, 18 Nov 2026 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Em96NFa/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDBD1F000C5;
	Wed, 18 Nov 2026 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020112;
	bh=ajTlOFu2gwfcmwtyHfxt8DJcM0J8+6M5K5Yvdlx5XjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Em96NFa/hWmx6H5Mttwotq+szsBdOQJPsSLBVMpfjlkiPfgA1WfS36CKB2Lw8rnJD
	 fgObo4Z1V3YpuKe1/Zy1BuU+WYmmxy1Lhu/pFn5lm0ykj7c3zGrvlCH8AIa53Vfe6b
	 Nd+90iwROtpFTSDNbevLR419+zenGblvBGor91pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1795/2651] ASoC: mediatek: mt8196: propagate main clock errors
Date: Wed, 18 Nov 2026 15:50:35 +0100
Message-ID: <20261118150351.935207166@linuxfoundation.org>
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

[ Upstream commit c33bc2dd217d249de7b1ddffb80b8e4a0c597cf3 ]

Propagate errors from the main clock enable and disable operations
instead of always returning success.

Fixes: 7384ecab34eb ("ASoC: mediatek: mt8196: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-afe-clk.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
index 6198711e01b5c..dbfd02d20338d 100644
--- a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
+++ b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
@@ -598,14 +598,12 @@ int mt8196_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
 
 int mt8196_afe_enable_main_clock(struct mtk_base_afe *afe)
 {
-	mt8196_afe_enable_top_cg(afe, MT8196_AUDIO_26M_EN_ON);
-	return 0;
+	return mt8196_afe_enable_top_cg(afe, MT8196_AUDIO_26M_EN_ON);
 }
 
 int mt8196_afe_disable_main_clock(struct mtk_base_afe *afe)
 {
-	mt8196_afe_disable_top_cg(afe, MT8196_AUDIO_26M_EN_ON);
-	return 0;
+	return mt8196_afe_disable_top_cg(afe, MT8196_AUDIO_26M_EN_ON);
 }
 
 int mt8196_init_clock(struct mtk_base_afe *afe)
-- 
2.53.0



