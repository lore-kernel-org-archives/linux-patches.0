Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016426;
	b=CGBDaLSAUn9vH2RwcHLvk4/fYeOmkSxmvTc/5m8398z44zcfo4AUuZS86EvegO4eE4dP
	 g3R6Mo9UeqL+4k4oSIevOEA1qzvtqA5gfn+zunL7ephTRLkmeTWSIqLurgtk/rMhJGAE6
	 OIJ3/tqVx2UxYmSeUCC7/wh/YrEZ1PPUBL+qWqnega7+cStR9i/LW4X9J7fMNkyxvJfxZ
	 Me8Fzb47TQSmsFhdOSWAX3RFu5HcUzLMXw/2FX6GGMEJNUxbra5XfMSd96/6TUBHhq3Ni
	 jMcZXJaixITKk8alw+oIVd//0ovq/tkWwINt3512kDN5a2sT/Yw7tjyXvbEJp4KpkIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fnlaG5ImH1QQuWtd1eJFsK542nAG0cp2fLHxuBTHbIo=;
	b=x3ML5oLuqo+h5v/ICgGAcPETUg0Xvbhbrrra8PdTBjPOH1oVolD4J5uTfx+sYEiZ9DLU
	 1d7hTvN6KIWHgFAMBmpyvxeRtyj7n3X+imKn32xsfGlN9KYopvGVohV4H19KuXrinKlvx
	 AiL2GVL91o/qXxUDXrgevy5BddjZVjLUrD5wYLNzfNfV3X0NTaS8E7qjZlwBR/DOfWGIt
	 Pk48yjyRo1pQdOb9Df8umhsKObkkZE7CbTe/XGSVX6u+dxXEWWat/sGjwnoGGXEB47BM8
	 3NIKI5BDnv8Bm6QipOfdLZCgxAbNtX9qDcOU6jUcxcRixbEqpxbGjCAH0Gz48o9vbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bua3mbhI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5B606A320;
	Wed, 18 Nov 2026 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bua3mbhI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425C11F000C4;
	Wed, 18 Nov 2026 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016426;
	bh=fnlaG5ImH1QQuWtd1eJFsK542nAG0cp2fLHxuBTHbIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bua3mbhIHTEsOKv3woMF08mv2PK12nuIR6xTeE3SxxlFl511q+Df+XKMhz06Q1nUW
	 +3B37DMgGB4br05rp5ek7rPhGlGIE6gY7zKEsHi53y21p5GyVluTP9Fu2jkuJG5B33
	 OlhQjj3o6f212ZmLcMnW6U6mq45GrA3vAX1o6sXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0526/2651] ASoC: mediatek: mt8189: Propagate MCK enable errors
Date: Wed, 18 Nov 2026 15:29:26 +0100
Message-ID: <20261118150306.679452074@linuxfoundation.org>
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

[ Upstream commit bd9a8d9def207a8d7eeaa4dda1c53c5b4fca4008 ]

mt8189_mck_enable() currently returns without restoring the clock
state when setting the clock parent, enabling the divider, or setting
the divider rate fails.

Propagate the error and disable clocks enabled by the function.

Fixes: dc637ffeed6c ("ASoC: mediatek: mt8189: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260916050020.14575-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-afe-clk.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-afe-clk.c b/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
index f088ccf804488..56362c4756c92 100644
--- a/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
+++ b/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
@@ -639,7 +639,7 @@ int mt8189_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 		ret = mt8189_afe_set_clk_parent(afe, afe_priv->clk[m_sel_id],
 						afe_priv->clk[apll_clk_id]);
 		if (ret)
-			return ret;
+			goto err_disable_m_sel_clk;
 	}
 
 	/* enable div, set rate */
@@ -650,13 +650,21 @@ int mt8189_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 
 	ret = mt8189_afe_enable_clk(afe, afe_priv->clk[div_clk_id]);
 	if (ret)
-		return ret;
+		goto err_disable_m_sel_clk;
 
 	ret = mt8189_afe_set_clk_rate(afe, afe_priv->clk[div_clk_id], rate);
 	if (ret)
-		return ret;
+		goto err_disable_div_clk;
 
 	return 0;
+
+err_disable_div_clk:
+	mt8189_afe_disable_clk(afe, afe_priv->clk[div_clk_id]);
+err_disable_m_sel_clk:
+	if (m_sel_id >= 0)
+		mt8189_afe_disable_clk(afe, afe_priv->clk[m_sel_id]);
+
+	return ret;
 }
 
 int mt8189_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



