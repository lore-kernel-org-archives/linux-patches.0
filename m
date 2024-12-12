Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EA42156FF;
	Thu, 12 Dec 2024 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016021; cv=none; b=BD6/W0qadgyxtSY2mKeB//bGe0uvCvzygV31IwwaEf15csW5sq4ceiDzWcIyFfDuTBvnoiIOrf5vizTxrvyNu+ckYM7iaIkNQ5vpZrhUBgaI5/+1YYerpJOlEmKU0Z/JuNb+hcx5AjojKYdnPeJkX09LbPuGq1Ts2F5VaeZkSmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016021; c=relaxed/simple;
	bh=eVXmPmI44n9+i/GQlD5bbFqbR2SrFZQin2QURVEvm4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZj3tZgbPjnCK6abs3Iwrehtu4IoIltVA9KUdhCw6fv8G7XIbjvz7uF76oluTjtbexmmGTuP1lqHuN7sgX+mhUt0KrYAPiDDLuncY+8H2WLDUDPmHwusywsYZvC5LFnqTK51X5+586T4MTEfee6UrwXLDy4WKOVU/9367wQlFOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q2DjHoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q2DjHoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676F8C4CECE;
	Thu, 12 Dec 2024 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016020;
	bh=eVXmPmI44n9+i/GQlD5bbFqbR2SrFZQin2QURVEvm4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q2DjHohiCduaf70+BOMmmbdyEM4b8U/vRVMZlz9TiLjmyRz0gjcxEN+fz+1UVybf
	 7qmWqMTs7C60tWuDud2BGICDEXXz3vtpJx8dqygePxUdwSX9rndKqNxRN4HMopvyYJ
	 al62m3DFHhG1WTalfhMe4hIU0njXuD1j+4hFkyzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/466] ASoC: mediatek: mt8188-mt6359: Remove hardcoded dmic codec
Date: Thu, 12 Dec 2024 15:54:39 +0100
Message-ID: <20241212144311.164064924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit ec16a3cdf37e507013062f9c4a2067eacdd12b62 ]

Remove hardcoded dmic codec from the UL_SRC dai link to avoid requiring
a dmic codec to be present for the driver to probe, as not every
MT8188-based platform might need a dmic codec. The codec can be assigned
to the dai link through the dai-link property in Devicetree on the
platforms where it is needed.

No Devicetree currently relies on it so it is safe to remove without
worrying about backward compatibility.

Fixes: 9f08dcbddeb3 ("ASoC: mediatek: mt8188-mt6359: support new board with nau88255")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20241203-mt8188-6359-unhardcode-dmic-v1-1-346e3e5cbe6d@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-mt6359.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-mt6359.c b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
index 4eed90d13a532..62429e8e57b55 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -188,9 +188,7 @@ SND_SOC_DAILINK_DEFS(pcm1,
 SND_SOC_DAILINK_DEFS(ul_src,
 		     DAILINK_COMP_ARRAY(COMP_CPU("UL_SRC")),
 		     DAILINK_COMP_ARRAY(COMP_CODEC("mt6359-sound",
-						   "mt6359-snd-codec-aif1"),
-					COMP_CODEC("dmic-codec",
-						   "dmic-hifi")),
+						   "mt6359-snd-codec-aif1")),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(AFE_SOF_DL2,
-- 
2.43.0



