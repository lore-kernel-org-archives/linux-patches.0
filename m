Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B56185A;
	Tue, 23 Jan 2024 02:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975762; cv=none; b=T4yO9C6t1dMEyi9iNrpxUgakKXyAlgaeBRaEYef+TNEHHUND/kLpFg/VRRHZsKnwvMwZ4cW2j1YTU1wangve42YyOWxoG0X8+eeAMzidZz+fGx8brunerIcf8hE2mMmGdyN74DgHiFQh3KSaeuGGQ0dJk+aQr0oEOSwOqyqkuSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975762; c=relaxed/simple;
	bh=Ipd66XPjTc+swLzNY+xkd/N+CsoD+Mwo9cvqWvbU5eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glJc9xdJopCid+EXUoPrd4DZV3o5tDTKSctVWGCfiUTMaYApxdwWriQnS2fQrbEmOfPhfLpteHQz/lk92ONkuUBK30F4lCN9PTxfoA0d8iZuR9HXZhGtOm5WhPpKq9xUlrQixWs4rMZJAf+CJyJHYr6cEoaliDTlyl3v+k6iAGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiNWABpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiNWABpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAF7C433C7;
	Tue, 23 Jan 2024 02:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975762;
	bh=Ipd66XPjTc+swLzNY+xkd/N+CsoD+Mwo9cvqWvbU5eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiNWABpSjaM/qbA6mdgsd0EKk0XcRVFYWar9hAykoyy+QuMjxgRvDvtbwirBmclvw
	 LVkLYU7FfKgoHnPcBKj0RLuDTwdOGIjOGg6jlppfhWJx28D87yWcip8C+03qP5Rn1G
	 BmzMpgmfn3SVUzLlzN4BiLBlDDhamzLM4A4vvsc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 522/583] ASoC: mediatek: sof-common: Add NULL check for normal_link string
Date: Mon, 22 Jan 2024 15:59:33 -0800
Message-ID: <20240122235828.047455300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6fef16306f74..21a9403b7e92 100644
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



