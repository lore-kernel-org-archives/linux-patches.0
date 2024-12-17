Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3377D1F8930;
	Tue, 17 Dec 2024 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456678; cv=none; b=mlRgeHWUCua/H2q7cubEvdv6gdmD3Yys1u7MEDGjSd+rOX6ZmP6lgMp41vzMg7IFeTaxFTnWfT7pi2dz9sB5Qp7kFg0/8Ukup1c65GstmKmG9R0ve/+po6K2Wx1r+ipnZvR/5lVDhisZoQL8twYBiLBHqcfwCLegBfbbF2zvyIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456678; c=relaxed/simple;
	bh=aagDCXjWLoIllyA0Q3yoqFgD9fXdI4T4YimpU4GPGOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqhXml7tgHC2y3gC2jY7VpI6BETHfC8e2PGN6yto9eyMPlEIhHc0uI1COa2g/Uo/GdsWk6gaYaY+t5LaRhLEr0C3HgPXGaav9M215xxrCNp3anBuFswlaOUDMklFZdGHUn5FRJtHmjxqp+lTFfXO+kahd9dHWszn5AZXd5kogp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsOO/alm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsOO/alm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2FDC4CED3;
	Tue, 17 Dec 2024 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456678;
	bh=aagDCXjWLoIllyA0Q3yoqFgD9fXdI4T4YimpU4GPGOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsOO/almju0bGc3VXdzczyu3SfT+EGq1rUXATy/+J4X7Nyv7zf85BAJ3wcm8686+f
	 3dwCdcgGMMccVpt5h6OstE4sEGD8/N/EApSPOeCdJtxXG+auYFZpGEiQZzpdx0SiVw
	 BKEty5oMX5h9BKH5n0aQHHGDcoIyyPX6k77/kpBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/172] ASoC: fsl_spdif: change IFACE_PCM to IFACE_MIXER
Date: Tue, 17 Dec 2024 18:08:08 +0100
Message-ID: <20241217170551.816178673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit bb76e82bfe57fdd1fe595cb0ccd33159df49ed09 ]

As the snd_soc_card_get_kcontrol() is updated to use
snd_ctl_find_id_mixer() in
commit 897cc72b0837 ("ASoC: soc-card: Use
snd_ctl_find_id_mixer() instead of open-coding")
which make the iface fix to be IFACE_MIXER.

Fixes: 897cc72b0837 ("ASoC: soc-card: Use snd_ctl_find_id_mixer() instead of open-coding")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20241126053254.3657344-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index b6ff04f7138a..ee946e0d3f49 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -1204,7 +1204,7 @@ static struct snd_kcontrol_new fsl_spdif_ctrls[] = {
 	},
 	/* DPLL lock info get controller */
 	{
-		.iface = SNDRV_CTL_ELEM_IFACE_PCM,
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = RX_SAMPLE_RATE_KCONTROL,
 		.access = SNDRV_CTL_ELEM_ACCESS_READ |
 			SNDRV_CTL_ELEM_ACCESS_VOLATILE,
-- 
2.39.5



