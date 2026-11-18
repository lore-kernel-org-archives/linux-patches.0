Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039387;
	b=tlPyiqoDEK8qUXSsUZjhubA0BJsOW63yVPLcBbR5LOyBGdIQad7biVe+cdJMlEjOafsu
	 5znKvHcx9gvasfIK1cmSQUfVHddHO91r7t+D/YbDkHcqUNo5GqWDs/lKdbVJSwyGgWNhk
	 8QgfCAW9uS2gmHVEma1HP4edRWUGJhBI/3/dzlpaOyfRz42rWx5plGI9nGNBeE2k5Vy5q
	 SDHm4NiwY7oWADQpD8hlhf9yKtx2dtad9BBHZDqfHEG68gb/GTTm85SfBwB7Ldco5e4pK
	 VBe/9pJ4tVa1fN0a94DG8zF0rBf4EdKjPU3g8sCrazlmBnYMZg0JYbkER4NYQRNRVew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=akqvYQYl45WPRmkXuoZUvQ7rXvGpllVipXKI+Lo7gR0=;
	b=qRGbFrNjVrkRkd7M38rQLTjg/9jiZHZeEI8FOse6nCbTNtD0o37bCWWrmksl9i9NOHrG
	 F4vJ+q6BW8CzFMswRT9KJRvC6wdyf/EsbY2xwjkl9HF/5k5kTQwHSPzFIdgGZHEUhGjQ0
	 y38/xshrw58EU/B+C7hKQKDjHt7nweJTylRnxTkO3ZkN6tpoAQlZsNNsD/6a7uwGjczyO
	 CGkXR3wnH1CWwnBKe+ZBvGvGsE8F62jzPkFQ52mxkTceDRZXJoKvn/XhHL/azXRq8jBJH
	 OwJLU2yrEZlnX9rx+pUUJOjWpxCl4zN6oAjuF6vt1ou4knclBYniL+mlGT46IioQhUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTmJUl3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936BA606A32A;
	Wed, 18 Nov 2026 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTmJUl3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FA21F000C4;
	Wed, 18 Nov 2026 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039387;
	bh=akqvYQYl45WPRmkXuoZUvQ7rXvGpllVipXKI+Lo7gR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTmJUl3sLraZXWEN9Ka2ep2xFE0TdCj8zGayKwZ9qpdIEgkae/G61qSfuMGhj0SGG
	 J+tLlDNaKp4d2emzJr+74aV52ImzdP1r9XS9pUynXjKgOIIqhjIA3XFasrouKtoGIg
	 XTxHzCLlsHB8VpTKdGT8EeZrf0Z4hUB9hxXWJR2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2081/3318] ASoC: mediatek: mt8186: Fix clock handling in mux disable path
Date: Wed, 18 Nov 2026 15:45:03 +0100
Message-ID: <20261118150424.516539797@linuxfoundation.org>
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

[ Upstream commit d70109f5510b423e72894dadfbab27087a7b26b0 ]

In the disable path of the appl*_mux_setting() functions,
clk_disable_unprepare() is called after clk_set_parent().
If clk_set_parent() fails, clk_disable_unprepare() is skipped,
potentially leaving one of the clocks enabled.

Remove the goto exit paths so that all teardown steps are attempted
and any errors are only reported.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index dddb3ec55248e..effc4193e63ea 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -131,7 +131,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
 
@@ -141,7 +140,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 	}
@@ -158,7 +156,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		       afe_priv->clk[CLK_CLK26M]);
 	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 ERR_ENABLE_CLK_TOP_MUX_AUD_1:
-EXIT:
 	return ret;
 }
 
@@ -205,7 +202,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
 
@@ -215,7 +211,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 	}
@@ -232,7 +227,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		       afe_priv->clk[CLK_CLK26M]);
 	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 ERR_ENABLE_CLK_TOP_MUX_AUD_2:
-EXIT:
 	return ret;
 }
 
-- 
2.53.0



