Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5099F3090CB;
	Sat, 25 Oct 2025 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409452; cv=none; b=mlm4aWdtEPTQ+DbdDz5a3RpkK7joQiscC9At64zAYyOiASpsiJt+ef1arUUCZ4vR5nTafdy7S1nb4SsPun3pBte+eM0GgwF3y9OEBkZMp8fQ+wRLbMUt3IY5n4DtrqWwa8FD6ijvCAMkwRy/w5HFjmxVQypLh9aDB8/Kudk+gOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409452; c=relaxed/simple;
	bh=kNpakNPI+HoD0YtFd2ODeOLYCyv2G8NIImYlxZ0hmJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMEfnvcSidZpDSZde2lStPSmhrWJ8S4O/PdYEKQ0qVkwY+oE56pFfo2RKBbAPLI1d2EV1N16Pe+X5z6ThTun5drDLJ7jobpsow82jfihbHjfpE5fVFUJMCilrJ69s0uwOwtZTk9nhWOSEMTDwcMRxubC6JJbzX9BqV0nOLly1v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4bFF145; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4bFF145"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C7FC4CEF5;
	Sat, 25 Oct 2025 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409452;
	bh=kNpakNPI+HoD0YtFd2ODeOLYCyv2G8NIImYlxZ0hmJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4bFF145c60IKsUgR9uHAQ5AjVRJNaUYXUKCxJzSwY1aT4qtHbRgc5xC5uOzXAoL1
	 eg7A0hXO6vqkDC3pU8NWeMsXuVpKI9mt0NnUkgjTpgmAfVAKBXQOFx5nYv/fkTMjlP
	 9lxrh56+a2/FUDxRpy0viSGAtrCqZFft3FYHTGC2li4wcCFZQpg5kPTq0yxiUxsWxU
	 lU0Rbo1sNWHD3OOv++nnLTxy8RjyEdjDpCPJPgsuATifJ1UFH2wU9JtuGnxf0/nwAS
	 ZhLxpKWG4fFDAB8Z+3wvLRDXqg2wudKQBx8zhmhykB6mAbLJH3jsAmIn+8ZEU9aZEF
	 jwCP/kbJotEVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	rmk+kernel@armlinux.org.uk,
	andrew@lunn.ch,
	0x1207@gmail.com,
	pabeni@redhat.com,
	alexandre.f.demers@gmail.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.10] net: stmmac: Check stmmac_hw_setup() in stmmac_resume()
Date: Sat, 25 Oct 2025 11:59:22 -0400
Message-ID: <20251025160905.3857885-331-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6896c2449a1858acb643014894d01b3a1223d4e5 ]

stmmac_hw_setup() may return 0 on success and an appropriate negative
integer as defined in errno.h file on failure, just check it and then
return early if failed in stmmac_resume().

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20250811073506.27513-2-yangtiezhu@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The resume path ignores the return value of stmmac_hw_setup(), which
    is documented to return 0 on success or -errno on failure. See the
    function signature and comment in
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3396. Inside that
    function, critical steps like stmmac_init_dma_engine() can fail and
    return -errno (e.g., invalid DMA configuration, failed reset), see
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3410.
  - In the current resume path, the return from stmmac_hw_setup() is not
    checked: drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:8033. The
    code then proceeds to run initialization and enablement sequences
    (e.g., stmmac_init_coalesce(), stmmac_set_rx_mode(),
    stmmac_enable_all_queues(), stmmac_enable_all_dma_irq()), which
    operate on hardware that may not be properly initialized after a
    failure, risking hangs or crashes. These calls are at
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:8034,
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:8035,
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:8039, and
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:8040,
    respectively.
  - The open path already does the right thing by checking the return
    value and bailing on failure with an error message
    (drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3977). The resume
    path should be consistent with this.

- What the patch changes
  - It assigns the return value of stmmac_hw_setup() to ret and checks
    for errors. On error it logs and returns early after correctly
    releasing the held locks (mutex_unlock and rtnl_unlock). This
    prevents further use of uninitialized DMA/MAC state and keeps error
    handling consistent with the open path.

- Scope and risk
  - Minimal and contained: only the stmmac driver, no API/ABI changes,
    no feature additions. The change is a straightforward error-path fix
    and mirrors existing patterns in __stmmac_open().
  - Locking is handled correctly: the new early-return path explicitly
    releases both the private mutex and rtnl lock before returning,
    avoiding deadlocks.
  - User impact: prevents resume-time failures from cascading into
    deeper faults by stopping early and reporting a clear error.

- Context and applicability
  - Many stmmac glue drivers call stmmac_resume() directly, so this
    affects a broad set of platforms (e.g.,
    drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c:1183,
    drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c:2066).
  - The fix does not depend on newer phylink changes (e.g.,
    phylink_prepare_resume()). While newer mainline code refines phylink
    sequencing, this error check is orthogonal and safe to apply to
    stable branches that don’t have those changes.
  - The stmmac_resume() in current stable series has the same
    problematic pattern (call stmmac_hw_setup() without checking its
    return), so the patch is directly relevant.

- Stable rules assessment
  - Fixes a real bug that can lead to faults after resume.
  - Small, localized change with minimal regression risk.
  - No architectural or user-visible feature changes.
  - Affects only the stmmac driver; well-scoped for backporting.

Conclusion: This is a clear, low-risk bug fix that prevents unsafe
continuation after hardware initialization failures during resume. It
should be backported to stable kernels.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b16d1207b80c..b9f55e4e360fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7977,7 +7977,14 @@ int stmmac_resume(struct device *dev)
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv, &priv->dma_conf);
 
-	stmmac_hw_setup(ndev, false);
+	ret = stmmac_hw_setup(ndev, false);
+	if (ret < 0) {
+		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
+		mutex_unlock(&priv->lock);
+		rtnl_unlock();
+		return ret;
+	}
+
 	stmmac_init_coalesce(priv);
 	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_rx_mode(ndev);
-- 
2.51.0

