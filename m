Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B1013E22E;
	Tue, 23 Jan 2024 01:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971999; cv=none; b=DwpYFBahl1CCyzIWt6mf7ud263L2mWZ8pelPUQS+ObSR/T0aOqoUh/ezVx7o3ZGGpIKW3ru04anFzc8a0lIp6FCqvGKx7GOfONUBCJmRiodtQN6uEEIFI/BzK+N24nQTEyCFCNQIdmKojEOf72gcVCCene1Ggy+3MwzeLaWZZpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971999; c=relaxed/simple;
	bh=Ij1fFahgDjnnQX/dxb7YZAqiV0wEZxeAoQdZV8kapb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR4yTQePg50QR3KLTaNahYdqNv0onHVgfHCGqw+iGCszO/xSv83oFoKmHjk82MpA/PaS396Zw8FCe8ZcVlRZkRvytCt2M2Fei97P2B1zQu+VxjjQ9fj+6BZlm13XfDMOWP2ULDrZYrsMipanv38/zSCiqiE38mCOvV1u07an8iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gv3Pb7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gv3Pb7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E1CC433F1;
	Tue, 23 Jan 2024 01:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971999;
	bh=Ij1fFahgDjnnQX/dxb7YZAqiV0wEZxeAoQdZV8kapb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gv3Pb7I9ioVzEAx1qGwD/FV55WtNHb7lwPBEQ132qAATtOaR3YVftKTjs71bJZGy
	 /tWqbBk7LSmoaPcJDgLEMrqKt+J9niO6q+xvsduv9ThQo4dG0rqy9wWoySJ8uZ2pjr
	 3Q5h7ifiKB926b2ZbA8ql2+evJqZH1sY8qu9ulgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 376/417] ASoC: mediatek: sof-common: Add NULL check for normal_link string
Date: Mon, 22 Jan 2024 15:59:04 -0800
Message-ID: <20240122235804.814349417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit e3b3ec967a7d93b9010a5af9a2394c8b5c8f31ed ]

It's not granted that all entries of struct sof_conn_stream declare
a `normal_link` (a non-SOF, direct link) string, and this is the case
for SoCs that support only SOF paths (hence do not support both direct
and SOF usecases).

For example, in the case of MT8188 there is no normal_link string in
any of the sof_conn_stream entries and there will be more drivers
doing that in the future.

To avoid possible NULL pointer KPs, add a NULL check for `normal_link`.

Fixes: 0caf1120c583 ("ASoC: mediatek: mt8195: extract SOF common code")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://msgid.link/r/20240111105226.117603-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-dsp-sof-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/common/mtk-dsp-sof-common.c b/sound/soc/mediatek/common/mtk-dsp-sof-common.c
index 8b1b623207be..d4d1d3b9572a 100644
--- a/sound/soc/mediatek/common/mtk-dsp-sof-common.c
+++ b/sound/soc/mediatek/common/mtk-dsp-sof-common.c
@@ -24,7 +24,7 @@ int mtk_sof_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 		struct snd_soc_dai_link *sof_dai_link = NULL;
 		const struct sof_conn_stream *conn = &sof_priv->conn_streams[i];
 
-		if (strcmp(rtd->dai_link->name, conn->normal_link))
+		if (conn->normal_link && strcmp(rtd->dai_link->name, conn->normal_link))
 			continue;
 
 		for_each_card_rtds(card, runtime) {
-- 
2.43.0



