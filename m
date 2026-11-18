Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026965;
	b=tPBJ+Y0KFItCXawXFh+/2EhO/uSkU/dPjT9ikw4SneW4hMDlgzgExSf3BW9VqO6UVoTs
	 oBg85Tyojq6ZN6zdqUgrzWSyZjdUCoAUZ+ppJZ7INEGD6UIGVuTlzGivQK2+1RRgQdml9
	 XTmk28HW3wU931gw9tL88SvzE1TWknmsITz1zjYIPGqzsHaB1wu9qZaXsivCUvyt75ntm
	 bQsj5t2DsSBOBGokeCXLKcQLC7P6khY0CH1IBPUFT7nK+z1zLtkO4CatnCjJU4Wf9qHsx
	 mfXqTFXI09ouGEhlCm/k+hAzC9rcfrxD3F3NHNuFgSjmKMXQd6h7nDLVdZ9WCo7rLyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cUza6clh4EVbdwnsKv1GFpYFRRi9qTYy/wcoZ6qQS0U=;
	b=L+eDXvtuB417Gj+L4ln4B9BXPk/GsYZpsP1YQ0tyJ9IhGiRkSTEaQv4XYJArXGMaBSyo
	 DE3MHDf1+fcLk0bskuULA0RJXfSgB/oQ4B7YAKI0oxpEigJYZJHGCRaWhFFmYG+dbSr8v
	 cr5kJhM5VcRzWTsLuWK062sJy3OQyzeW5pP6gaNx+vMtz44NDbce57/Gt8Rnnp8wTBWst
	 tKdbNEpKfkMsNAtRh8D6KevRrfALMz03XhrFQOhqQECw3Sf4a0Uz5Q1lY/tPF8UeR64JF
	 soTuEPfM+bH9Pk47aT/5GRLyoMAuzC77s9FAtnIp47T/PeLEcy13I7NJTtb3bTkAkkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0wKSdFv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE564606A320;
	Wed, 18 Nov 2026 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0wKSdFv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314861F000C4;
	Wed, 18 Nov 2026 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026965;
	bh=cUza6clh4EVbdwnsKv1GFpYFRRi9qTYy/wcoZ6qQS0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0wKSdFv/j+ub/0Jf7JxE+FWnxQBBGxWU5yGrcH8OaRu3jimxvGq4DIa6fqkJNN7H
	 3Ezm+DHGY2EPC/VdjPyd6GxR0w5qRzvS0g3Qpn8Hq34q+F/Ci91PeJ3I2S4KNx93xk
	 nh1pFkvbymrc2Gs76L2l4eMotRrW93ryz6W88oHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1622/2151] ASoC: rockchip: rk3288_hdmi_analog: Use dev_err_probe() for error handling
Date: Wed, 18 Nov 2026 15:55:57 +0100
Message-ID: <20261118150220.965809340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 06f5854050f56775977f9972b78a21806de001f0 ]

Replace dev_err() with dev_err_probe() to prevent log spam when probe
returns -EPROBE_DEFER.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260806052136.21034-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f15b2df0b940 ("ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rk3288_hdmi_analog.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/rockchip/rk3288_hdmi_analog.c b/sound/soc/rockchip/rk3288_hdmi_analog.c
index cb9add725a3c3..d5395f2e6a5c6 100644
--- a/sound/soc/rockchip/rk3288_hdmi_analog.c
+++ b/sound/soc/rockchip/rk3288_hdmi_analog.c
@@ -204,10 +204,9 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	}
 
 	ret = snd_soc_get_dai_name(&args, &rk_dailink.codecs[0].dai_name);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to get codec_dai_name\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "Unable to get codec_dai_name\n");
 
 	rk_dailink.cpus->of_node = of_parse_phandle(np, "rockchip,i2s-controller",
 						  0);
-- 
2.53.0



