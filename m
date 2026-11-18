Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020575;
	b=c6esnFkMC19JN7GE4dLQ/QD0+F2w21OVnaSOzEx86xOofRWjim+v/XiktUfAVuZcs7Yf
	 iyLWw412lcHte3rBpR1KwZWfBGMpYX794BWjJysndInRi0pgHLINFxKW+BMEVMg3aYqA5
	 XLrX+2dOPR7n7c1nXPgZO89czckMnDSaRfyR/RqZb1dK/Pb5hm1ytM4V1U4QePMas20Cx
	 k/sFxO3gJuVY4b0Ug4SGFHA32UyaUiy4WpRQtYba4F2tvwdhZMx3I+XX85CuOvPaEm8EI
	 3L6mYgYR2T8PVsxctz31zdg/EOLXb7hCxXSPal69YDbNvsiDNFo1o9c6KoIz/f/FdmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KLoEGXdF+4LetLzjhcYaAH99lmrGE5newcUsgDhrNg=;
	b=TnnnGmcGhrK77YQi+WHvsLAulngeeNT+/sxk1IKp1uJiPJ3WF2IOINA1nvVms37uRDxm
	 Cp3XZ6rfhw2jAMmoQZ6Nj1D3IGMNBiSUNrEV6RAd3O4ZtntdBYbvdt5jimNwABJVNQIZO
	 pgytQx5MDtOBG8b/Ov5T33ZsPdqdhDKaaMClJ9DVFZBeTT+bbCzKukVKK+PobftpIos2W
	 BwlKQ7FDhgl+U0FDML2ac7ZtKOAEWwzHZDP+FxJKHlHnN4bF8+bZkj2B1Bp0QX/WMOrXy
	 9zawFXsUI6huuDtEof4qf+XiI7NGECpElOknp+pjbh1sED8dsapfANbWR8CCRib53yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hI39yjw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55470606A337;
	Wed, 18 Nov 2026 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hI39yjw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4291F000C4;
	Wed, 18 Nov 2026 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020574;
	bh=4KLoEGXdF+4LetLzjhcYaAH99lmrGE5newcUsgDhrNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hI39yjw7WANF8WSucpMv/SfPlBPktub1rGo9Qy4enQL1a5LhibncFN7gGD3jax+Yf
	 kpSeidIgEFVph8ksgeFPXZivp4DUhgv9kcqG5YkmnPhMlC9q1rUr/7Dg0oAazwAYsK
	 K7owUEAylFODvjQjMnSiNm++YbqeubAXqfVAQDvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1999/2651] ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
Date: Wed, 18 Nov 2026 15:53:59 +0100
Message-ID: <20261118150358.285767125@linuxfoundation.org>
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
index b3e01d2839765..9e6d1a2a9e7e0 100644
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



