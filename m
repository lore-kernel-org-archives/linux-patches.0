Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385751FBCB8;
	Tue, 17 Dec 2024 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456675; cv=none; b=XhEGnfMwQevKzXjBeXLQAagfo5IOYqvajn19tXtlAhZBAGl2zyn5obZ9HlXEoc9HlfYoKOOSeeJLFXDC5HY5Nd30cQlTIw5F0W+44EUzMy+ajd/WVoaOTPbxytbyvXQI8HgWfniFOdpkMwz9PzilU8IiGpl0jZ9ej2wGYmZxrTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456675; c=relaxed/simple;
	bh=LjW2CBRogzRiVu5NBUemnJRxeygiwI5jSYZD8iMTh50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFUeESVXu/3bRdcF1aSOA5gX7fWfU0ea1REyV4Ne4Sh87OSLp6vbdfgNDfkI5woJqXxyv8NU7pHDE3oP4NZnLo4QryVNZa62VK8APvmkMqAFhnahO3Xo2M0XuUYgEzWO7Tr+1tZF5W+j6IXg4wI4yNigNzap91W31nGO4haf+mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekCu73ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekCu73ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CD7C4CED3;
	Tue, 17 Dec 2024 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456675;
	bh=LjW2CBRogzRiVu5NBUemnJRxeygiwI5jSYZD8iMTh50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekCu73igb/KbtonQ+BjN2wSCOTnj+9Qa8ONF3X3wSn2orEXGJ4okNL+HkUB6l281s
	 vvmuH/vspZx+1/hAgNg/vMkLohbnYvRdoPX6AMJsuBDD1KhCC8iQMTWPjQTO7kDejN
	 4se/RwQhmye8tv3/hysL+Byk+p1e154D0uoGoZtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/172] ASoC: fsl_xcvr: change IFACE_PCM to IFACE_MIXER
Date: Tue, 17 Dec 2024 18:08:07 +0100
Message-ID: <20241217170551.774586888@linuxfoundation.org>
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

[ Upstream commit 7c17f7780a48b5ed36b6d13a06004fac993e75af ]

As the snd_soc_card_get_kcontrol() is updated to use
snd_ctl_find_id_mixer() in
commit 897cc72b0837 ("ASoC: soc-card: Use
snd_ctl_find_id_mixer() instead of open-coding")
which make the iface fix to be IFACE_MIXER.

Fixes: 897cc72b0837 ("ASoC: soc-card: Use snd_ctl_find_id_mixer() instead of open-coding")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20241126053254.3657344-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index beede7344efd..4341269eb977 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -169,7 +169,7 @@ static int fsl_xcvr_capds_put(struct snd_kcontrol *kcontrol,
 }
 
 static struct snd_kcontrol_new fsl_xcvr_earc_capds_kctl = {
-	.iface = SNDRV_CTL_ELEM_IFACE_PCM,
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Capabilities Data Structure",
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
 	.info = fsl_xcvr_type_capds_bytes_info,
-- 
2.39.5



