Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016438;
	b=TgSzkl6Kbb6DA4MxCOZcRDSs02vWYWYIW+q1QQA57wS7BB4jybiIMmt/3GjZAPfKuSwS
	 G8uExu5d0HVGDObwok6nqldeLvhLKB13Nas7+mu/vQStHJmKFIiX0SZYnOg2HAVJWNfCt
	 fBPDFfOfrfCb7/2tCTipknqOtHeT7ZKo9pwEaaex/3Uj7y+219KuJuwUFvAa9qxF0Ik4s
	 rfazJo+0Ea8Kn00GdPMopdZK4kx2AheDkVe2oz/gDnhHcAMmLrW+zUeztBqXyrflkRlzm
	 L3sN2ufjKFWqWG/A8W8scHzoc8ev3Lhd5WlLpqasP/yCuJ+1vAeaE8CVPzv3KslwaKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J0lMQuO65ir/KMuIJ9Oi0F9p424d3tNA47idkUPb8PE=;
	b=cB9suQ8MVZfSLNRXBn9OJaL0R60zMWoC5l47iPbHOiTim39wxFTkoxSLRGNZHs16PlPr
	 X/6D9FDcHaKbxx4xv2G0UjV+kCySpw8odXVRXi6QHptmWXycv4TqC5vJShvjDVEgKXxwn
	 R5UtVt0vM2sk5je2sE2t0uxRKXjWb3NVe94/xUu5GiKSGWND0NDUXt+ef9iF67jU0W2u7
	 h+i83b3S2NJNBgPfl5PHFygelRJzb1TgDNADVthdUewoW3+J4W9RFf2fX50elr0cxw6gz
	 RAXksP2vFYm0DXueEzmQfzbuYPLgN3ETdS0hCTROm/hTHYHZbksOBLGXdU5ARzhvjpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NnGcD/yB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C54606A32C;
	Wed, 18 Nov 2026 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NnGcD/yB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9491E1F000C5;
	Wed, 18 Nov 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016438;
	bh=J0lMQuO65ir/KMuIJ9Oi0F9p424d3tNA47idkUPb8PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnGcD/yBZiXQtM/bRi+laqapAKMXjD7iknRurILHm6dTzwWPbzRDZeipQJV4ZRSFH
	 ydqOG3M0k+rr3t7eA77FQ/L4nvvR3lDx46L0o8veoWzGHWNE6jOcfLAnYOxsGVPKY0
	 R11ZtmjpNmjYQSdNjgUZFGM3rcfZjZQ5iWbL9iZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0530/2651] ASoC: mediatek: mt8189: Propagate APLL errors
Date: Wed, 18 Nov 2026 15:29:30 +0100
Message-ID: <20261118150306.846527439@linuxfoundation.org>
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

[ Upstream commit 6347f276da8c6c3e6e8262b30b9cd14dfbc48248 ]

mtk_apll_event() currently ignores errors returned by the APLL
enable functions.

Propagate these errors.

Fixes: 7eb153585598 ("ASoC: mediatek: mt8189: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260916050020.14575-9-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-dai-i2s.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c b/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
index 94c49a662e2d5..4826ee250d703 100644
--- a/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
+++ b/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
@@ -485,6 +485,7 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
+	int ret;
 
 	dev_dbg(cmpnt->dev, "%s(), name %s, event 0x%x\n",
 		__func__, w->name, event);
@@ -492,9 +493,11 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		if (strcmp(w->name, APLL1_W_NAME) == 0)
-			mt8189_apll1_enable(afe);
+			ret = mt8189_apll1_enable(afe);
 		else
-			mt8189_apll2_enable(afe);
+			ret = mt8189_apll2_enable(afe);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		if (strcmp(w->name, APLL1_W_NAME) == 0)
-- 
2.53.0



