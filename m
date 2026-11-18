Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024730;
	b=fxvOTwiSr5UrJgxafGWwPIt+A2AOfwQvsoTg1qIOS5P0bc/aJ7NmwZ9MiZDDTWPKOJSE
	 AxZiEgEX+zoeVLf2hyM/pr+YGIP7GcBVrloQj4QRokNWuBjN+UIh3z4IBoggf2Gx3IMgO
	 vw9MdAMd7P0+OeKaLw/LPhpGRqaQcsz4VPyEI26UY37c5YF1D11FY90QtNkjVAUe+Sf/t
	 K7vOviJPnt9Ax2oyaup0LBSK3YxLM/r0oDLflgRcmErW2bvSHkeDMvbX/N8DE9gqjWi6C
	 8ywrAu+dLliMEXyef7yyp3NuzXLhHPNygzFkEIsqTSVqE8nz61nbyqEJmn3XyA69PEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuO3nqfOsTvgUV2n2s2olKRbtRx5SPMPZmXdbOrhoaY=;
	b=eCBsyWAVST4puslYPGlFHiUcm/CZQKGTi+5L2pOmc0tfMbLIS9hlgi0o9YCHbY7AiJfI
	 3j5dyxNyXDY0OSAY2vVS8OxGvn8zxPzFDciRZkWlCxEt0y8pnqZWfpjvQoDjYZUQWNZ6p
	 qmKjiA8gD5CHnt8tBgSxQd4dS82foKoVC4KfHlTVgAAT6gx0FR2BMFGT7SwfwLK1cNPcf
	 8OVrZdgNWNHSqghKV5iVmtX2zCdbC5oBYRY5pz/rf094Y5Yf/hjYrNcJMCwRbpQGLqJNd
	 pqPObgllTysrEM6dFQ+BXSrjUQBJMF6Yh0V5Tij2z5LCaPt364h0wDpvKK3WC80IGXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNXM0bki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C26606A31C;
	Wed, 18 Nov 2026 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNXM0bki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834691F000C4;
	Wed, 18 Nov 2026 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024730;
	bh=MuO3nqfOsTvgUV2n2s2olKRbtRx5SPMPZmXdbOrhoaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNXM0bkinuMB4josgcZNJPUBstUSYm0ETLQNhhOjbgjEzoQLrTGwRj6GIqMFDXV2g
	 hZqp9TR+2zZ+VE5R5f3lkVEZI9X/MOafdzS+nidXVsULosn9sMKIjb5fBS+Nc196ea
	 mfdymfRD95pD8Q/hYvkKTy2Owmx/VytQfESq3k8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0822/2151] ASoC: mediatek: mt8192: fix MCK clock error handling
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118150152.075073360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 4a0ab266cb1594f8c6aef3c79726476ad99618c5 ]

If an error occurs after enabling 'm_sel_id' or 'div_clk_id' in
mt8192_mck_enable(), the function returns directly without disabling
the previously enabled clocks, leading to a resource leak.

Fix this by jumping to proper cleanup labels to unwind enabled clocks on
failure paths.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 118dd48196828..77f596cab92da 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -619,7 +619,7 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto err_disable_m_sel;
 		}
 	}
 
@@ -628,17 +628,25 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto err_disable_m_sel;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id],
 			rate, ret);
-		return ret;
+		goto err_disable_div_clk;
 	}
 
 	return 0;
+
+err_disable_div_clk:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+err_disable_m_sel:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+
+	return ret;
 }
 
 void mt8192_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



