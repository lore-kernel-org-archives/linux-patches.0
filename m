Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E156D183CA6;
	Mon, 12 Aug 2024 16:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479556; cv=none; b=rxdMZLiv5fZsmqUt6YH+m8rVapDc6vB/xgY+9kw0GoP+WVttY4ITajP+o+zhj3sMK/+X/2KDSPQVehMm0HgG5ui4pLvIfIN+h5lBm+O9SwL9fdWDYgoXzXa+84aNyWQ81iQe4L0VZ1OPp+8hs3fY9UNkdaxVeubVkoCfnaNVNcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479556; c=relaxed/simple;
	bh=FDiepMl/UERA7eA7Mdl6XlrkWRzJA/HpwdMLCX0e6+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+UhPD6efJiltZSEGuCeJJ/Fxdq5YLzizJPZ5QZxgX7jmL2GPkoBI0cgSHPBz64L8S1BeL5Rok7oeK0QAi28pvHLoVlMuQI9okl7PecI7b6Da4gbvgfagMLtISmDP5FQFMfC4DnInXhpnqWcBl2A6L+MS21We4BmhVb3KRphqWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWYtG+WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWYtG+WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE50C4AF09;
	Mon, 12 Aug 2024 16:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479555;
	bh=FDiepMl/UERA7eA7Mdl6XlrkWRzJA/HpwdMLCX0e6+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWYtG+WTZow2OsGRz+J/T5Z30xG0LfdIbS7L7snA48EC7CG09twVXZtT/SxgW1j7n
	 phwGcIv302MhamKfBUwSJYxpGf7x0CeJAbGr9wKkl1sKJIAYpWN+XMZHctvaD4rx1Z
	 d6A89cPen/DErCS7cbhrYlsgakz313wAUwOkGwAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Malainey <cujomalainey@chromium.org>,
	Wojciech Macek <wmacek@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/189] ASoC: SOF: Remove libraries from topology lookups
Date: Mon, 12 Aug 2024 18:02:32 +0200
Message-ID: <20240812160135.839057234@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit 7354eb7f1558466e92e926802d36e69e42938ea9 ]

Default firmware shipped in open source are not licensed for 3P
libraries, therefore topologies should not reference them.

If a OS wants to use 3P (that they have licensed) then they should use
the appropriate topology override mechanisms.

Fixes: 8a7d5d85ed2161 ("ASoC: SOF: mediatek: mt8195: Add devicetree support to select topologies")
Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Cc: Wojciech Macek <wmacek@google.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20240731212153.921327-1-cujomalainey@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mt8195/mt8195.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/mediatek/mt8195/mt8195.c b/sound/soc/sof/mediatek/mt8195/mt8195.c
index 7d6a568556ea4..b5b4ea854da4b 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -624,7 +624,7 @@ static struct snd_sof_dsp_ops sof_mt8195_ops = {
 static struct snd_sof_of_mach sof_mt8195_machs[] = {
 	{
 		.compatible = "google,tomato",
-		.sof_tplg_filename = "sof-mt8195-mt6359-rt1019-rt5682-dts.tplg"
+		.sof_tplg_filename = "sof-mt8195-mt6359-rt1019-rt5682.tplg"
 	}, {
 		.compatible = "mediatek,mt8195",
 		.sof_tplg_filename = "sof-mt8195.tplg"
-- 
2.43.0



