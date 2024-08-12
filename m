Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD39E183CA6;
	Mon, 12 Aug 2024 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478921; cv=none; b=T0+K1DRASU7oNk2hxmwfyJxpC1mDyp+4amnFuVWcRx1Jcama6Is6/u5TP/cxkxD6KfeY4EYr64pwMnMZiQ9ATS91MP+X3Au1Zxs9DuPeVutul1aoZZg/jetR9uaDXNVDReoGy3vmKb1EOcc/QQzasR535NKheEv3yHALsLmQdVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478921; c=relaxed/simple;
	bh=nSCGLv+hEr1enn6ZdkHMxhTfM/IlZBmz5W/+M9oUH3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ9xeepPpBNhfcjxYhumFuIexqOlBn2SLGXD2oHhIjk8vc5dq1MRmwGsvuK+bpulRbM2wJiyi91rNJdO8IQ8zdI+qCc55GOwHpjjA1orkciaUxaXNSm4cAw2Ef56W9P46TXMCvZkH0kwsvVOenx1UcW1E/7mFuCL8SYgN6aIwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMFYfWix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMFYfWix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D52DC4AF0D;
	Mon, 12 Aug 2024 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478921;
	bh=nSCGLv+hEr1enn6ZdkHMxhTfM/IlZBmz5W/+M9oUH3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMFYfWixGjx3GVnrzn2Cgi9weq14FzcdzQ2jSN7XN9RE9N8X5KlwC32zAovLsVidh
	 AilpwerJS7CP/ZIfCBeIrF+bdOAk3lqQtaWePvSu2EroC6+ZjaiQCUydm0tWpZtSDW
	 KkyOwFMnYZ1dlBaDKXvYVLKWngF6J9FXVL9/zOwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Malainey <cujomalainey@chromium.org>,
	Wojciech Macek <wmacek@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/150] ASoC: SOF: Remove libraries from topology lookups
Date: Mon, 12 Aug 2024 18:02:38 +0200
Message-ID: <20240812160128.146904363@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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
index 3c81e84fcecfa..53cadbe8a05cc 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -662,7 +662,7 @@ static struct snd_sof_dsp_ops sof_mt8195_ops = {
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



