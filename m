Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211502;
	b=beu7ZXJXIQd5cl0MJ6aI3LTpljyXAlAWfT5reuRRIjXLHkQdS93uL+PkYfMKecd37s7I
	 nHVZhJN/KoASmGjP6YR5EJzi5o5cCsCDDH6vkZx0NzpFhuxdw9Oq5Qdk9Yo4sygaspRvj
	 ZR0gEn9QEKTq8t7qSPaMLGlF0UizoTddcjDEz+8rhTnSc6rE65EzE3gKrYsT0eWDzYTwa
	 0u+YoCVBp2O88KK6FBpVVXVvNWEfVyIxSpU5pnSe6sS459daV7ZTdaava8/5CGi1I72YQ
	 xT9K/XMNyV1FCoDs17A2lqGpP+AdL7i7+aA31EWuL9aT+xTufUZhs0iR4eQ7lj8lWGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8Z8lezuoLS4hyx+OCXmAKfcnJmwt+hgD0ykoS2mn30=;
	b=b4QClZjPA7GPsmyAYEHP7LmsF0LBrwS0dqC6i0ZMjrgUltmHAsEn2EtOJb3Pg/P9ZCqd
	 fczL6H94nuHMivcXcoRRpJJfOfOtunIWgfAQ824yXsPGQwo9ynD8Xqrre2dWBwK8kWIq5
	 Qx8czX3ttbV8GTiVZ0kAYkM3tun5BKUS2XMf7G2gV1OXpCvNN244ZcaKxvTx58Z36d5er
	 OyRKuF9bOPjj/u/ez0ayZ44KqwmmN/h2z2UpT/5RdoRw6VyL+DAVE6BmAnlyLfXS6ZESh
	 JoGKxuv02nNM3GUupxXLYzS8biEPbUOzarUwMlY+xg4PXFL9kTGAv1ht5w9NNn7jW5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BH7eCqoj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3CE606A329;
	Wed, 28 Oct 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BH7eCqoj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001241F01829;
	Wed, 28 Oct 2026 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211501;
	bh=F8Z8lezuoLS4hyx+OCXmAKfcnJmwt+hgD0ykoS2mn30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BH7eCqojlsYJeNTpASgJ6tfGFn5DTChS3Z9SmQ6/94jzV4pDWZwgkjqQ2Nw9B51M2
	 0hbvVu4gFX8Mp4bykel8+UT6vZOoUBEzRXSgIN9QkLdZetFlr+zRJ5w1ogCv/eglFd
	 UURQ20iQWp50cPdV2TmohESjdts9XisSzoGDrna8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 5.5" <noreply@anthropic.com>
Subject: [PATCH 5.15 399/571] ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM
Date: Wed, 28 Oct 2026 17:59:06 +0100
Message-ID: <20261028170017.481246062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 7529254014764ae0b8c33d5c61a58f36c65b1a1c ]

The probe function puts the device into the runtime PM active state with
only the "iis" bus clock enabled, but it also sets priv->op_clk to the
parent of the RCLK_SRC mux without enabling it. The runtime PM suspend
callback disables both clocks, so the first runtime suspend after probe
disables op_clk once more than it was enabled.

On Exynos5250 Arndale both clocks resolve to the same EXYNOS_I2S_BUS gate,
so this triggers the following warning during boot:

 WARNING: drivers/clk/clk.c:1270 at clk_core_disable+0xe4/0x23c, CPU#0: kworker/u8:3/45
 i2s_bus already disabled
 ...
 Workqueue: pm pm_runtime_work
 Call trace:
  ...
  clk_core_disable from clk_disable+0x28/0x34
  clk_disable from i2s_runtime_suspend+0x58/0x68 [snd_soc_i2s]
  i2s_runtime_suspend [snd_soc_i2s] from genpd_runtime_suspend+0xc4/0x298
  genpd_runtime_suspend from __rpm_callback+0x48/0x18c
  __rpm_callback from rpm_callback+0x4c/0x50
  rpm_callback from rpm_suspend+0xf4/0x718
  rpm_suspend from pm_runtime_work+0x9c/0xa0
  ...

Fix this by enabling op_clk in probe right after getting it, so the clock
state matches the runtime PM active state, and by disabling it in remove.

Fixes: 48279c53fd1d ("ASoC: samsung: i2s: Prevent external abort on exynos5433 I2S1 access")
Assisted-by: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20261002092116.585466-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/i2s.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 309badc972907..b63d381d02edc 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1525,9 +1525,16 @@ static int samsung_i2s_probe(struct platform_device *pdev)
 		goto err_disable_pm;
 
 	priv->op_clk = clk_get_parent(priv->clk_table[CLK_I2S_RCLK_SRC]);
+	ret = clk_prepare_enable(priv->op_clk);
+	if (ret < 0) {
+		priv->op_clk = NULL;
+		goto err_unregister_clk;
+	}
 
 	return 0;
 
+err_unregister_clk:
+	i2s_unregister_clock_provider(priv);
 err_disable_pm:
 	pm_runtime_disable(&pdev->dev);
 err_del_sec:
@@ -1550,6 +1557,7 @@ static int samsung_i2s_remove(struct platform_device *pdev)
 
 	i2s_unregister_clock_provider(priv);
 	i2s_delete_secondary_device(priv);
+	clk_disable_unprepare(priv->op_clk);
 	clk_disable_unprepare(priv->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
-- 
2.53.0



