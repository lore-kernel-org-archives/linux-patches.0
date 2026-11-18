Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040126;
	b=4cfF61Uwiaq6bM/gNAeCsbb410dj+JZ796NhQ/uz0LD+GHupRoi20mcvEVdbwR1Yda3O
	 zIIV/CbW9G/CxKt4GxiKoZlk2yQdKSY1uJKLvcWGcqX1Wa8AdznQlWqe66BaqQUNOAOM/
	 /CRok0AtjVkvejMRH8uYxSUzL+t1cyL6wpf+DUdC24Byt3IFIgbWmmd12llGVionwFlzk
	 uto3VuNp+BU1PmLaZ2yzEsPozia2LrEJV6BCqbydXWvGa2QZ7S+nwWVSnxQ/VG07By146
	 wSu3e4c8CixVoTMqD/BJRzi50YVnYk+7jucHPy6drESjaV1TY8kEid3UPigkmaty3ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fkAceajfMcywp6XiDlZOs3sYlQwnTB4hhkb+8FPjREk=;
	b=3Tfc9QKRsDDOJMHOIXA7TKNgzfPRlMdBtL0h7m7nYYfl26EY1lA1atnF4grGJJjA0xxv
	 JfyD7g2C/8bg2AI9vpwNF47iMUZL+5v6WQB2hjYG6RZvk9l2r5rdFk6spY9g/VWsQvCri
	 LRP912+pLTXkjTwRdgjDzwrZDk7aAypVtw675zk7tUivy66oMZLn17TLKPrfnnR9WgH8h
	 dpEf7aSY0SpdV7wHNHcaoOW966iZi51OSZDiR8GHevSCx1smn1+lBqy3Kb5Up9O7EUtys
	 WxUcONLQ9bZG+GkYVBKplgjj0VrgdL5ckKug3fZlyS4tKraUJbq8Nc1R2DZJwMdnHwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NW4fTXCD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA679606A31C;
	Wed, 18 Nov 2026 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NW4fTXCD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE521F000C4;
	Wed, 18 Nov 2026 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040126;
	bh=fkAceajfMcywp6XiDlZOs3sYlQwnTB4hhkb+8FPjREk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NW4fTXCDPMUmMKD74EuFCY4olyzwui2NjXnkqEUcXFOWXKHJJNoh28e3I/6KiIkZV
	 A0+PvUQ1edy1hCE8xdnaqcjuRgyAVN3MlqCdGTJAZt4FzaWXHvojTNR7WmPIhDh3xL
	 e6x3vt0H9Ip/QhBhf2voWyXvNJ6+T8f2pz1GM8MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2345/3318] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:49:27 +0100
Message-ID: <20261118150431.975352974@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit b4136c0d69ead737197af741e20edd1c3574f6b4 ]

The temporary Front-End DMA request can fail independently of the
persistent channel acquired earlier in fsl_asrc_dma_hw_params(). The
returned NULL pointer is immediately used to read its private data.

Check the temporary channel and release the previously acquired
persistent Front-End channel on failure. Clear its slot so a later
hw_free cannot release it twice. ASoC marks a component's hw_params
only after success and skips unmarked components during rollback, so
returning an error alone would leak the earlier channel.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 3117bb3109dc ("ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260913125147.109920-1-bolin.liu@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index 91dd85153e83e..7c6f12816deda 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -233,6 +233,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
 		/* Get DMA request of Front-End */
 		tmp_chan = asrc->get_dma_channel(pair, dir);
+		if (!tmp_chan) {
+			dma_release_channel(pair->dma_chan[!dir]);
+			pair->dma_chan[!dir] = NULL;
+			return -EINVAL;
+		}
 		tmp_data = tmp_chan->private;
 		pair->dma_data.dma_request2 = tmp_data->dma_request;
 		pair->dma_data.peripheral_type = tmp_data->peripheral_type;
-- 
2.53.0



