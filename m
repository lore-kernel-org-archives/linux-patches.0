Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020583;
	b=USQ6JQTV8vP2YDwY7n7PPIdy2Bh110zg8YG8hO3ISUIJOuHokS6Q8e/VD5ptvg8q7yRt
	 eKsZ7BpqYDitVz4nwIbqMWdcow6818vcVlUdJtHAsAY+qG65gEE+ODc9pmcr4HKBZc579
	 q+wygXAMmrECuHUzrJH0s8dgNOj3b2bNTpavh77qKc4LBnvAoz2qdw3U/ZIrVd3ZME40s
	 btvD6wUOZkixq9OQRXRmV5GB8ojUuFKBC49dKlJoHxNS7nCDTsFyCIPDIBgHwuzuGPgnw
	 wjPcF4QyRLzvdsqUBR14O0CIn+A+EuVSsME6VzrneI8ymSh62f1d3Fa2GV6lL+j45Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukhh14JcVZ4Qz2zcAlFvJ9sq8VlcEDtFRtry4DkRBkA=;
	b=IhRD5Gvpg7e0YWRmdsMlBTTQgbOJvmjHp2Ro+ETZBRK2UG6yQm4G13LD173ZdjE5wXfC
	 /C+oBB8ObKyT+O12TcUdcLW9minuM8oqaHiq3lOFQVuJim8YoR2CYfE/oLxVkAUtxbqU3
	 /SXh06WhaiKbe0YlBMePKpSeZW9Fb4HQ2ay6FspwyA+dBvWhXhghJpo/Wp71Bfn421IzZ
	 3EAhpR9+oxxkXXOQl+kVHPniTuhR8pfomCgIYTVbnjlgDwu9tL2QdYZYQjpT2/EiQymnc
	 dFEGXEPl2qutBysJfVXeih6+0haHRxJuQtrMTZWo2XGDwcw4BqWdra1OLhwVbMXpopg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l90V+oKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533F4606A31C;
	Wed, 18 Nov 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l90V+oKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A601F000C4;
	Wed, 18 Nov 2026 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020583;
	bh=ukhh14JcVZ4Qz2zcAlFvJ9sq8VlcEDtFRtry4DkRBkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l90V+oKgl9bHJZzV2ajRkFqBofJT6DYscahZS0gimu0AVcln+YUkPYuvxkMVRyRFd
	 jRlngrdoPdLyhL3AfZI2qJEotezkvwdMkpeAQVSMhZDqZeVJt7QE8Dts+ZwpVd9/DJ
	 r4kf2kT8VqaMztFmfxmZ3+eM2z1UCGhe7PN//G4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2002/2651] ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
Date: Wed, 18 Nov 2026 15:54:02 +0100
Message-ID: <20261118150358.375676890@linuxfoundation.org>
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

[ Upstream commit 91dce9c7eec25e95b5ca32e17e60e2c27333d411 ]

Propagate errors from mt8195_afe_enable_clk() when enabling the
ETDM MCLK instead of always returning success.

This allows callers to properly handle failures when enabling the
MCLK.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index 1a20adb2cbf53..fba51c552eecd 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -1549,9 +1549,7 @@ static int mtk_dai_etdm_enable_mclk(struct mtk_base_afe *afe, int dai_id)
 	if (clkdiv_id < 0)
 		return -EINVAL;
 
-	mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
-
-	return 0;
+	return mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
 }
 
 static int mtk_dai_etdm_disable_mclk(struct mtk_base_afe *afe, int dai_id)
-- 
2.53.0



