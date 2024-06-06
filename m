Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E22196D87;
	Thu,  6 Jun 2024 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683009; cv=none; b=ox5Z7IExP6W9y+xo3LruChbPOzDDjIJu7iAap7ApfQyZBr9cjtsgiEB3PnHE50va56IujtR0K0Kq5QWT7bUajGq10Wplhtp49rtWwfDXJsMC6HzpB0ZKGGID9MU5ghRT8cgJ93TuS8gIVSocgLECjK0Ezeh42HQvbhM0UMlVvjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683009; c=relaxed/simple;
	bh=8vZOB/mkdFBls8Ut3qP6bLyRl3r5W8Q5k0+5FRExro4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9zrc2ouy6iYLxg0EycW8BKIudj/E7KLPVBMR9T8QmviHhx9UMfxPBCesBhroZ27I//7Lxf9GPdYCcwslVt83DeQNXqaHTjAISWva6rXARhF8hm5nfJ1KYt+5ZjeWKPFfHyhWrW8BWfA1hmeoVNoTqjTjFI5WEfE/IQY+vsnKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFPqHnQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFPqHnQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F44C4AF18;
	Thu,  6 Jun 2024 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683009;
	bh=8vZOB/mkdFBls8Ut3qP6bLyRl3r5W8Q5k0+5FRExro4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFPqHnQhZrxkXBzhKPlOKRzU2lr1bLxuZe3uI52BCmxeSWPqcilXicOcVg8wKLg+Y
	 8LHaPREdM4i5rRzawx8NbwSBgCdeqY8JIdrNpcMokfkYUDcDNMo3kda4suySvccbHr
	 rR0tm5hkiTiMJzpychVv8W5Dsaqu7yOcTjPNxwiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 219/374] ASoC: mediatek: mt8192: fix register configuration for tdm
Date: Thu,  6 Jun 2024 16:03:18 +0200
Message-ID: <20240606131659.132845639@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit a85ed162f0efcfdd664954414a05d1d560cc95dc ]

For DSP_A, data is a BCK cycle behind LRCK trigger edge. For DSP_B, this
delay doesn't exist. Fix the delay configuration to match the standard.

Fixes: 52fcd65414abfc ("ASoC: mediatek: mt8192: support tdm in platform driver")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240509-8192-tdm-v1-1-530b54645763@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
index 9ce06821c7d0f..49440db370af0 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
@@ -566,10 +566,10 @@ static int mtk_dai_tdm_hw_params(struct snd_pcm_substream *substream,
 		tdm_con |= 1 << DELAY_DATA_SFT;
 		tdm_con |= get_tdm_lrck_width(format) << LRCK_TDM_WIDTH_SFT;
 	} else if (tdm_priv->tdm_out_mode == TDM_OUT_DSP_A) {
-		tdm_con |= 0 << DELAY_DATA_SFT;
+		tdm_con |= 1 << DELAY_DATA_SFT;
 		tdm_con |= 0 << LRCK_TDM_WIDTH_SFT;
 	} else if (tdm_priv->tdm_out_mode == TDM_OUT_DSP_B) {
-		tdm_con |= 1 << DELAY_DATA_SFT;
+		tdm_con |= 0 << DELAY_DATA_SFT;
 		tdm_con |= 0 << LRCK_TDM_WIDTH_SFT;
 	}
 
-- 
2.43.0



