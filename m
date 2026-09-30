Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9AE3C09F5;
	Wed, 30 Sep 2026 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795076; cv=none; b=uNjvOLLy7pM7xiSoF4FEOoawzkcT5qnCJwP17UVZiSPrmQ4RBp+GCuTHG81PSKdLn4FYWgG9ZTLnDC7nNS90e3NFjEK/C9iUkFNhfk+AzB/kJA8pLMVV5R15Vc1LiObzFdeRc8EEbp7DjIg2AOitZKCw3apxd2JrZQXELi0gv7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795076; c=relaxed/simple;
	bh=Ms3WaTg1MiF92IiMj4fu5mm/MFLOjPUe67VGckNJ10I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSdg4+v1EyPwLz4mJRMWfC+MfLcOq3BycPgoe0B/NfyTCHiT2Jhv7t6ZHqJdbQC3mr6jvOHPYkwMgJ4y6G5m8F4ZPRRbEjv1Bc884BmbJN4pbBdH8EVo2pfqO4Fe+WGEyiZX6kmjHe4ZEbAKAxL8wEgbI/7clkzHZfKkcOIvO/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABbzgfno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABbzgfno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C751F0089E;
	Wed, 30 Sep 2026 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795074;
	bh=xhvdAeYHom5c2XUGRLvO84yp6BDEjf0EkD5AGftCagw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABbzgfnoonUFM3goiBuh55Dq9Q1mRXGMalfW/YGd5PryGDBEYvrWdtzNP1mAgHQdK
	 wWHvZe/xEsQ5GwmfripG/wskegMMymsWqrkXXbE0cuJCUkaFBPuRaQ4u6BO/dhfOPQ
	 zIJQoTI9ksTzYC33aT4i47noio4bT11jiKtQKd7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0435/1193] ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits
Date: Wed, 30 Sep 2026 17:18:39 +0200
Message-ID: <20260930152443.854560229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 0c06c4ce0206290c9a934a1e7196aaa86adfe018 ]

disable_pdm_interrupts() uses |= ~PDM_DMA_INTR_MASK which sets all
bits except the PDM DMA interrupt bit instead of clearing only the
PDM DMA interrupt bit. Use &= ~PDM_DMA_INTR_MASK to clear only the
target bit.

Fixes: f621a3676d3f ("ASoC: amd: add ACP3x PDM platform driver")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260824063507.483784-1-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 39223ff37b14e..c7c4d0829564c 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -104,7 +104,7 @@ static void disable_pdm_interrupts(void __iomem *acp_base)
 	u32 ext_int_ctrl;
 
 	ext_int_ctrl = rn_readl(acp_base + ACP_EXTERNAL_INTR_CNTL);
-	ext_int_ctrl |= ~PDM_DMA_INTR_MASK;
+	ext_int_ctrl &= ~PDM_DMA_INTR_MASK;
 	rn_writel(ext_int_ctrl, acp_base + ACP_EXTERNAL_INTR_CNTL);
 }
 
-- 
2.53.0



