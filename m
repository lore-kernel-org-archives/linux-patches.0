Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD04364B2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBBH8mVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DACFC433C7;
	Wed, 15 Nov 2023 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076610;
	bh=r7hxSxgpBlWbidD1E+oGhXA+/B13aNazZmGj3gOIqlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBBH8mVDI+tlIRccU4k+4RDlszXGOU1Hawdrq2kCcmctAz0FlekWXNd7r+VCvqs27
	 Ymt0Y03HaD+PiNeSMQdJISu5BoJ0io2vdYjFfstDCCT6/ZYlPpANK9/6Xun/XkagB6
	 HhVtemMvdJJjq23VOQFAkPeedqsqvZWqj2qfNuMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 338/550] ASoC: fsl-asoc-card: Add comment for mclk in the codec_priv
Date: Wed, 15 Nov 2023 14:15:22 -0500
Message-ID: <20231115191624.186912857@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit fbfe616ad40c06d68b83b657a94cd2e709dda37b ]

Otherwise a warning will be detected as below:
warning: Function parameter or member 'mclk' not described in
'codec_priv'

Fixes: 1075df4bdeb3 ("ASoC: fsl-asoc-card: add nau8822 support")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20231007040117.22446-1-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index bab7d34cf585b..5f181b89838ac 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -41,6 +41,7 @@
 
 /**
  * struct codec_priv - CODEC private data
+ * @mclk: Main clock of the CODEC
  * @mclk_freq: Clock rate of MCLK
  * @free_freq: Clock rate of MCLK for hw_free()
  * @mclk_id: MCLK (or main clock) id for set_sysclk()
-- 
2.42.0



