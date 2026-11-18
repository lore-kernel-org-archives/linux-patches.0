Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041846;
	b=MMYIL5z0Uw+lTuWNspNscsB3fO8niFfKP80dKd6qnNDFKrBCJDFdqvngekiYqt4Bm7Pu
	 SM+s7Dxn45gunFWRDQ3Gq932TKRqnrI7EYkbHfA2vrq7GU1We8qhp6fHqZGdBABB9NX44
	 Gn0hKzz65TRPqld8+sUSZ+9MF375nxQtIRX94fRL8DEqHNdE0EvWe7Wg4bqqEjHZ4yrxn
	 XTsMzHDnksJNC5K1QZwXfV74yuxPJd1TT8rmxWxMPA2F/Nta3th8amzrfBJ38RTZHAEKM
	 2mctQb74EbfT3Pd6dh7d38CtvEx6eehwT8TQW0sG8gKsZ/x8eH+nuQNy5WJg1sQH5zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoFvROMm/2/4igxJGizyr7HPJq5cOpd03lBxpqa6OT0=;
	b=mOjABHT0Ks/3I44XfTHC/jeRTfF54vhDYL8PKvcj58TM7rKdcJ+A8ak3MmeUb8jK9bOz
	 6MEXd7tnWvlyMx73NEKBVwGPig2lMDL9z/dGu4cdSbCJkxMOUzHdYF+AANBNNEvHLRjcO
	 h19O8tOYSjJyw94meEHTLdGhSki9d84pdJ7MWQXy0V0/vfjlGjUB/7PRRsRzHzMUfYdDf
	 ZH1o9/0Rc3koKUaZx8rbFhqNHUXpC3qQYLdUQ35VY8owvgfsoxqAdLM/LcGlMGokdO9Ik
	 RT2AubtS0C5qw3o4J5NRu0ur63lNo8E5wFK5DMDAi2rGSZQqd8aIVNCb2juI7llp9YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TntDriBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88846606A320;
	Wed, 18 Nov 2026 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TntDriBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5F41F000C4;
	Wed, 18 Nov 2026 22:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041846;
	bh=xoFvROMm/2/4igxJGizyr7HPJq5cOpd03lBxpqa6OT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TntDriBG/pCm8O3k2+1ohJ6Qz95H5F5d096aM7u+alK0ZIV5olvTudOKBe/00dUfC
	 ctqKSYbSt3gvWQpmj3Xh1AjB5Ai46t8R1YKUZC5IVh8cDI+9OcHzsjC0be00d65pP7
	 vfXkEBon+FJNEotwifkkPm2nd+0i/qDMLHb1oYFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2959/3318] ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
Date: Wed, 18 Nov 2026 15:59:41 +0100
Message-ID: <20261118150449.069574590@linuxfoundation.org>
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

[ Upstream commit 91dce9c7eec25e95b5ca32e17e60e2c27333d411 ]

Propagate errors from mt8195_afe_enable_clk() when enabling the
ETDM MCLK instead of always returning success.

This allows callers to properly handle failures when enabling the
MCLK.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index fd4f9f8f032de..db84f9e34114c 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -1554,9 +1554,7 @@ static int mtk_dai_etdm_enable_mclk(struct mtk_base_afe *afe, int dai_id)
 	if (clkdiv_id < 0)
 		return -EINVAL;
 
-	mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
-
-	return 0;
+	return mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
 }
 
 static int mtk_dai_etdm_disable_mclk(struct mtk_base_afe *afe, int dai_id)
-- 
2.53.0



