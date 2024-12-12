Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E7B2135C1;
	Thu, 12 Dec 2024 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017953; cv=none; b=bubNjWVPAJCe9qe7oguuIWaVtYjz5oLMB5qG2lkp9hdUFPm8/l6ARqpK7aB0Aj9wDZoEdCyEAQY2m/eyUT8MTBMPIV5pNnylv0E/ASpxdBNBytzJic5MEe49HhRvS4MatE8eTcl5RndWI/2emg0ca/wKD93aKvXNULJmtCHnZbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017953; c=relaxed/simple;
	bh=hYz+U4v+uOYZLaoNXfoBjp9hLOsPrg/YhkI8DcmN1Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTc4eOug63hX6VEp2j2T+UzT7vjuzSWHpGuQBMHj/niLLZch3N5wppVV+mHr2hC7rmgg6WEj4JMR6jq0NPGOErSDjxZjqQ+maycVLqXj2zlFPbSrGByVlElCFIGsbK8F0h5nSDUmymYJdma3fax95L/y/bvfAIgpF9idcOiovL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2ArfBbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2ArfBbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8781DC4CECE;
	Thu, 12 Dec 2024 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017953;
	bh=hYz+U4v+uOYZLaoNXfoBjp9hLOsPrg/YhkI8DcmN1Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2ArfBbs1L041kx+BaWhM87jj1ldji6qLw5QE+yc2nrCQdeLv8yLILM8RuTCUcKE+
	 76ed3GlXL6PrDzMgC6GRYfNmzpiKODXBFeo2+GMmI+u4AGWtp36aY3Y24JcYG0lH4I
	 AAV70jcVogWuefnpjdVDGmscx+DSpPfATI+VftnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/356] ASoC: mediatek: mt8188-mt6359: Remove hardcoded dmic codec
Date: Thu, 12 Dec 2024 15:57:27 +0100
Message-ID: <20241212144249.711978812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f7e22abb75846..61813b658e3b4 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -171,9 +171,7 @@ SND_SOC_DAILINK_DEFS(pcm1,
 SND_SOC_DAILINK_DEFS(ul_src,
 		     DAILINK_COMP_ARRAY(COMP_CPU("UL_SRC")),
 		     DAILINK_COMP_ARRAY(COMP_CODEC("mt6359-sound",
-						   "mt6359-snd-codec-aif1"),
-					COMP_CODEC("dmic-codec",
-						   "dmic-hifi")),
+						   "mt6359-snd-codec-aif1")),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 struct mt8188_mt6359_priv {
-- 
2.43.0



