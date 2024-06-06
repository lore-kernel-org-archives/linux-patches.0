Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE465198E9A;
	Thu,  6 Jun 2024 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683509; cv=none; b=ojX/EX5h527y1HeiRy4A/HHsEl7VJQ9vtx/b/tmyNWC4RWVPNd5QfCqZ0VxWX61IaxKb0EhniNBuDKbPiX8dhMlCllgI21O/EOrvu5qM0Z3hvmvd4tm2jEeWh5kHon53N/ba+Lyp5m0rIPLVKCfem94Xq8I6HOZBAqaZmlAB8h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683509; c=relaxed/simple;
	bh=nbY+WKW2/zYfdjc1NFO9s3FnSMeZN6Dw8tZc6w/l0AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo0+PNluB/oVpDTSt5WGV9xwsS58ildLPr0Dr463/qnU1sX4d2ad4RYQKeWqwCAwZdHW4RfTf3UBc2df1/fN0JmDwBZ+JQ8TfEXjvkHYgwQpjkjIw/yLZX5aDO+gYDthVvJSzcbMJSFupMdaffEzukHXyAopECAPz7Y+YHAm8lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm5lpeid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm5lpeid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E77CC2BD10;
	Thu,  6 Jun 2024 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683509;
	bh=nbY+WKW2/zYfdjc1NFO9s3FnSMeZN6Dw8tZc6w/l0AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xm5lpeid22Hwe7E9ghgi2coiIl1LzKmJmKd6Yk6eGmxFke4ZvnrWdpsaz0vZxpyYQ
	 U98PrmONK4ET7YTaee1wwoBvilDe0IpOuc/h6AYAg9BSBbPgRxmtinm1f1MoOxQHUv
	 5OXHN8/8VFsvlMTXiWA6PPsbqz4NJxg3M4OLD7d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 398/473] ASoC: mediatek: mt8192: fix register configuration for tdm
Date: Thu,  6 Jun 2024 16:05:27 +0200
Message-ID: <20240606131712.979033215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3bebed2428a7..360259e60de84 100644
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



