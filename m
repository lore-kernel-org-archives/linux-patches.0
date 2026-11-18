Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041838;
	b=JkVtubU9L3dwuRHkl9P3zFDZpYP6Uk+Xl+JvhCyj/iiv/fdvH6Gx0S+GzmQL21EC7WYI
	 ak0Gr+wH3DEzsuO4ogitxj2Keu34b5+OYNxKpT05Y0cbiDGSEOF8aZ3oT7uDm7MZjtj7d
	 ++PFL5BajmlD9fghmvIPRXbYQGuX5spz970ZPzv+bIM1tkD7i+YCvteYqxLuojV6QBSw8
	 HHeMpvEvcnd7eFBCWuMqQ6ptPUXSCqVQbOkQyHQ/blDatsp/BNV0hddYpi7K5B549MsX4
	 2F56jlZYx3G+l2tvALGV5onLB3orHGxXIDPueQHNztSqz5b4QTePNU+NMwVMj/qmS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jb0JHOX6/yx+Wn7YenJz7yIVrwaVBjG5n8Zhh2tSnSA=;
	b=k4BKFCYI741sAsKZP7gs/8aCn45O8VqPKM3qdf/rNHNlbt0Or7hcG06sBcIC9NKVEsn2
	 V/3OGPqUqCAJtgtVR4X0L/rTys6x+wbaSElBI7HePGGzqn5hJrBBc2n6VNiuaa9YQw/6+
	 /FceGgp173pNF5dviF6RD6Y/h4VtNlwQ9nx5eM8Yv+nwsBNWI6Ue2RERCIqtsLRlpV6vY
	 +90oO7tZcOTqP9+1JzZee2/Eh6YsbjaBgUKlZyeZb0Xfj1GNHarjYSb6NmujnBYGUWckp
	 0sTi+7kQEbZrjTZOCpxMGHQx3JcDtXfF9xvwChUVLFHyzHBvnTO3LJcepdLB3LaDoKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="anCZJBi/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D19606A31C;
	Wed, 18 Nov 2026 22:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anCZJBi/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687551F000C4;
	Wed, 18 Nov 2026 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041837;
	bh=Jb0JHOX6/yx+Wn7YenJz7yIVrwaVBjG5n8Zhh2tSnSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anCZJBi/nRZDlTv6BH4WgTZ/igN04v1c7wxpd5OcEEqk1vdfkhc8GtW4oG/xI99ic
	 4wyfpg7NOz6AQIBVpAyC73FWQWQ95f8+XpiB2vr2KTfcPeAXvN6zmvp5/NA4Bvk7ht
	 L+8+o9XqK2TX1oPM+7h58W+2KDZjI51LPkarZh/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2956/3318] ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118150448.983812437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a2ae972c75a18ecbdcbf331ddaab21e1a08333fb ]

Check the return value of mt8195_afe_paired_memif_clk_enable() on
START/RESUME. On failure, stop the MEMIF and disable the channel
merge before returning the error.

Also skip enabling the paired clock if mtk_afe_fe_trigger() fails.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-9-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 602dcca21e336..ae8727d27e696 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -466,7 +466,14 @@ static int mt8195_afe_fe_trigger(struct snd_pcm_substream *substream, int cmd,
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
-		mt8195_afe_paired_memif_clk_enable(substream, dai, 1);
+		if (ret)
+			break;
+
+		ret = mt8195_afe_paired_memif_clk_enable(substream, dai, 1);
+		if (ret) {
+			mtk_afe_fe_trigger(substream, SNDRV_PCM_TRIGGER_STOP, dai);
+			mt8195_afe_enable_cm(afe, cm, false);
+		}
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-- 
2.53.0



