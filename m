Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1DD299929;
	Thu, 30 Jul 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425690; cv=none; b=er0cO3dzrgt+L83UWy5dwNz+0YLvz2rMjCkTSmwrC6G5INdug59ctt8K1dHSvTETLoETu6GCQ/hb3TVKD50XPw9Aq7HulTcH2E5kuIEBSQstXoJTOLlUfF1bq4gn6IMs2BrmbJifXPG99Wh+SvvJPqjd368t0cOC2E02XTmk+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425690; c=relaxed/simple;
	bh=DuYN8YbYpQInXEvMstGL2LxVL4P937LOmTQXm0SIxZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIXpQ/I4se9a4dEwp03Wt4wcIMlDl8lbN7rPxAR/hXXnQivF5cp48z9tDKD/er+7LO8zl3ykmQmdYRzl96a4Va9Pqe12HiTNzmI2Nr16Hpjkf+esrkOCmC296maSFoEZraRrPl9cGHcAdHPYacP3ntz0M/I6dpFAUWI9cQij/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IijSkXAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IijSkXAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AAB1F000E9;
	Thu, 30 Jul 2026 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425689;
	bh=3KNAfv9HuhpSQQxD37t2GJlPV9e1uhWuLQmsW+QuKZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IijSkXAmQjiiY/Fgl6tJfsOLnzPkhw+LiRVk9WiItWEv+Ka3/fXwfBF2W5Z5j1cMT
	 KGGMY4Kg4dNW92VQtqlYFl+mTes43qDNmdkrJIEsoaoQKyECrftFfjdz1XjgcKWmNQ
	 h1wm8iXGTRmKiVXcl7D6svKs33gki8Bn1V6Y/UCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/602] ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI
Date: Thu, 30 Jul 2026 16:09:09 +0200
Message-ID: <20260730141439.272671724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0b604e886ece11b71c4daaeccc512c784b89b014 ]

The bt-sco-pcm-wb DAI uses the same stream_name strings as bt-sco-pcm
("Playback" and "Capture"). This causes duplicate DAPM AIF widget
names within the same component, leading to debugfs warnings:

  debugfs: 'Playback' already exists in 'dapm'
  debugfs: 'Capture' already exists in 'dapm'

Give the wideband DAI distinct stream names ("WB Playback" and
"WB Capture") and add corresponding DAPM AIF widgets and routes for
them.

Fixes: 5947e1b4992e ("ASoC: bt-sco: extend rate and add a general compatible string")
Assisted-by: VeroCoder:claude-sonnet-4-5
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260715100620.1387159-1-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/bt-sco.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/bt-sco.c b/sound/soc/codecs/bt-sco.c
index 3afcef2dfa3529..c0bf45b76cb8c5 100644
--- a/sound/soc/codecs/bt-sco.c
+++ b/sound/soc/codecs/bt-sco.c
@@ -17,11 +17,17 @@ static const struct snd_soc_dapm_widget bt_sco_widgets[] = {
 			    SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_OUT("BT_SCO_TX", "Capture", 0,
 			     SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("BT_SCO_RX_WB", "WB Playback", 0,
+			    SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("BT_SCO_TX_WB", "WB Capture", 0,
+			     SND_SOC_NOPM, 0, 0),
 };
 
 static const struct snd_soc_dapm_route bt_sco_routes[] = {
 	{ "BT_SCO_TX", NULL, "RX" },
 	{ "TX", NULL, "BT_SCO_RX" },
+	{ "BT_SCO_TX_WB", NULL, "RX" },
+	{ "TX", NULL, "BT_SCO_RX_WB" },
 };
 
 static struct snd_soc_dai_driver bt_sco_dai[] = {
@@ -45,14 +51,14 @@ static struct snd_soc_dai_driver bt_sco_dai[] = {
 	{
 		.name = "bt-sco-pcm-wb",
 		.playback = {
-			.stream_name = "Playback",
+			.stream_name = "WB Playback",
 			.channels_min = 1,
 			.channels_max = 1,
 			.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE,
 		},
 		.capture = {
-			 .stream_name = "Capture",
+			 .stream_name = "WB Capture",
 			.channels_min = 1,
 			.channels_max = 1,
 			.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000,
-- 
2.53.0



