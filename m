Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032472;
	b=1+8QDCgfSI9iKGO4ypSbJkVchqSifSyeNUQwubUltkD1d5dCXr58pKdUZOOzikoKZZt5
	 sYEYoMu0fy0zkVOwqLf8wt1jFk0rNWb8ZuXt8ZpB4s9OE74gavHbXrJqMsiSEyqqBzRE2
	 rJ50WntdbQmwGPi1lhpuTgStg2MwO2/LEYeZKSTWcy9PlHBD74EfI/MpiuOwVW/wTqS+4
	 lf73B3H8a7yAAe9ipbYKVRAi7ybvnHFjGDdqUshV03Uu7IOipIPaqVyov53L0rV8Pp77T
	 ixQnVKxdBGNNlyZ9Drdj/XdV7Y/sInfV/GnQmdWL3eA2QeoMO98JAcsD3PJQW2xFO0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQBYjHm8Gm7aA6TQCjMev2hR25BhrogdnB+hKcozxEw=;
	b=nK6Pmv5FdUmSWrAkphzhZTf3ejPxLt8k3AQVRyn/YJ6ASW96STSQx0RpxUFrYcG+Y9pF
	 og7pBIsZ7d69tucXzUsJsPYSSyNpO5m85zG6jsyOdhE2LzOnOXAtK6zRujJfYqxszM8Wd
	 TuorKkXKukZMo+0Z/K2U90pf08+qvw+2vR2XJ07sDAed1j7RBTaJ0t8qI5E3BgRxCyAcS
	 1AG/rlhTvY4sFfu0u8Ph8Grr0ZxNH0Sa4AQUQg/DOtpMD4EwVENe344DHXyfc9heFvZ42
	 X9DLpmeqkyXwJb2t3EnAiRKVzqMbMUwCzsXsfMqFchPid2MEjgV75whnLxgMvtMJ2Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0mD/yvGw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB80606A32C;
	Wed, 18 Nov 2026 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mD/yvGw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF781F000C4;
	Wed, 18 Nov 2026 20:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032472;
	bh=TQBYjHm8Gm7aA6TQCjMev2hR25BhrogdnB+hKcozxEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mD/yvGwgNkvu/BsUDnIHYmfUsB3Pgadnm1imjGkuk9LfoDoFjbs+LZRlJRxOenuY
	 bgKU7nUTQ6riPZj73KFGIujMDAYnfANuFQkQoClt2Rp3ftdHe9gQS9zKyvQ8DNI3RU
	 xVVYdbYQFMhSO0cq4s0wHbZuOS/o0feP8AK8vv9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1425/1756] net: stmmac: xgmac: do not treat TBU as a TX event
Date: Wed, 18 Nov 2026 15:59:12 +0100
Message-ID: <20261118150105.887821715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengfei Zhang <zhangfeionline@gmail.com>

[ Upstream commit 305deb54c6c287e586bed92da2375ae1220e8dde ]

Commit 8d07a7930434 ("net: stmmac: xgmac: Do not enable TBU interrupt")
removed TBUE from the default DMA interrupt mask, but did not remove the
TBU check from dwxgmac2_dma_interrupt().

TBU is set whenever a TX channel runs out of descriptors. Since TBUE is
not enabled and only enabled bits are cleared, the TBU status bit is
never cleared. As a result, TBU stays set on every idle TX channel,
regardless of whether there is any TX traffic.

With a shared interrupt, stmmac_dma_interrupt() checks all channels,
so every interrupt from any source schedules TX NAPI on every idle TX
channel.

Only use TI to trigger TX processing.

Fixes: 8d07a7930434 ("net: stmmac: xgmac: Do not enable TBU interrupt")
Signed-off-by: Pengfei Zhang <zhangfeionline@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261013024747.2688984-1-zhangfeionline@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 4d6bb995d8d84..cc52dfead8d15 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -366,7 +366,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 		u64_stats_update_end(&stats->syncp);
 		ret |= handle_rx;
 	}
-	if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
+	if (likely(intr_status & XGMAC_TI)) {
 		u64_stats_update_begin(&stats->syncp);
 		u64_stats_inc(&stats->tx_normal_irq_n[chan]);
 		u64_stats_update_end(&stats->syncp);
-- 
2.53.0



