Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213399;
	b=XombeCl0sTMPgNoD2AaKoFd8kHdk+9/icbnaMqGG9+YDvnfE5zWRz17j0B9vZ8KCnT+W
	 vlhummVrmeYezelk8YI2ZB8dEOZhMNa8YoNrTWgKUnwFReRgT0dbvnZMqvEIpCZow64Ic
	 2Jld291WrQVFfpYmtkud7P8mbP8YHTuoAfaXeExd5hbuuJCYqPRbrdKlkOUGkZI3UYcyt
	 9IG1hGE6XeK+SJT4kZ6ByXjYW19I49kMNFrz+3vMxpOIrYjZldjalqR1RInt4+IZWr5hv
	 +xfLR5oAd5ZuSPoIbLbBz3SPr40QwX5H19XYnhXegiOO6we4qKsSJGtPzJm/M1ZLCtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PtK5y1D6NL1/67pzWK90Mc4KvTRr6L7WQ9pKETXEDJY=;
	b=f5iZD8/usQbTLkm41MAz9yYDF2MmXjoLMQ/eBtKM/DgmlqIWOApYcIuj8tKk0Wufk5WV
	 hw6nNczQXp3hkeoEBMVip2C3WMHcYJfiIIXy4Jc4JN9nKw8uD+aKTdiJ+3vioojuugfws
	 Lt9y36Nn3f0sDdRHQRaC7gQ3DmhSaFUZH1NTFoMb+dRPNEW/Jm0whe9Bh2DX9znyo5CbG
	 Znb3natas+oG6PcDwwnXcMwsdP4oCMOijbPfMXkZoVygAXlUjFM5bhPzBH8bwpL3GPq4K
	 eJWlPs90ngHnJmAXU6YeMGYRqleE1bGx9wZj1x/DjbA1Yxtyfsb3WIWKgPfdVzhMSmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bg8TB3uK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913FB606A31C;
	Wed, 28 Oct 2026 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bg8TB3uK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25221F01825;
	Wed, 28 Oct 2026 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213399;
	bh=PtK5y1D6NL1/67pzWK90Mc4KvTRr6L7WQ9pKETXEDJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bg8TB3uKtwQZ8WuTJVbzKCaHb1qjUFbox2xgfjb4TSSbFLjSRckw6kN8gAeqlPXoE
	 VABsW61HOF+dk5D5dCae+08qCaeCLnDc/Gt8YO0TvXYfDTPRyscRgYx9uVVMu6UpBI
	 WkdZ4NtKOvz2pzyUPMH7icamh8ksBN/PIADUEJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 5.5" <noreply@anthropic.com>
Subject: [PATCH 6.1 0493/1887] ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM
Date: Wed, 28 Oct 2026 17:43:09 +0100
Message-ID: <20261028170510.495681686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9505200f3d11b..be0d6984bb861 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1531,9 +1531,16 @@ static int samsung_i2s_probe(struct platform_device *pdev)
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
@@ -1556,6 +1563,7 @@ static int samsung_i2s_remove(struct platform_device *pdev)
 
 	i2s_unregister_clock_provider(priv);
 	i2s_delete_secondary_device(priv);
+	clk_disable_unprepare(priv->op_clk);
 	clk_disable_unprepare(priv->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
-- 
2.53.0



