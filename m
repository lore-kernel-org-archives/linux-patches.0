Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7365E4FECF8;
	Wed, 30 Sep 2026 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785023; cv=none; b=Nc+swpvGeSiCvANKa4EuqqdcbpO6ThkWoOUD//a9tBj/o3OXlgjioTRUMIrbP0NqzrAYIFo32EyYV9+MFBh/AIJRVaAcd4lYHOXFDKUqPOtEU1fZWhPnqqOq4JBoV+h8Z1Mmx63ONJ0wrWMwG1Ax2nCO0D/MNKxqS32vFFFR8VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785023; c=relaxed/simple;
	bh=A/WTQ+Zr0m5CtiktDd3euCvruTZ/vfmK2IoPJOZyR4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0tuVcYxdz4/gNkZFZyi9uy1f8wnyDetXwTtsiwXHyntx55ydaUsdBI5RFzPZKvi1EiD1aTLaB34fg5ZaQpLzjoviEhOs+tPz/fY0EGFG5gmWXjlLTMDmAoAQMXUsf0OGyc74M1yg6autwDkxU9OIs5kAxtcHgUZvwBx2ZDQHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl5DAJgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl5DAJgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B4F1F00898;
	Wed, 30 Sep 2026 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785017;
	bh=m5W/AKLESwTSWyZxSsPa/F0h+kKGDKJbcR3I5mEyYvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vl5DAJgLqx8GlkvOimc/B2bp46LmOVMNGahVcZtKAYY+M4y4emy03O/FXsYRU/QMJ
	 Sa7l54zoDLTkytLLLKgOLKMsHYLaVCHREZWA4/sOqrMKt1Pnmj/31u47gMjtt1nvMb
	 Fif5pw7Y4LMSjt6PrQQXgbY0EHgCOO2GM+gkzrVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 361/982] ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits
Date: Wed, 30 Sep 2026 17:18:17 +0200
Message-ID: <20260930152424.567574210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 643deed487ab4..617b1fe8b28b9 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -98,7 +98,7 @@ static void disable_pdm_interrupts(void __iomem *acp_base)
 	u32 ext_int_ctrl;
 
 	ext_int_ctrl = rn_readl(acp_base + ACP_EXTERNAL_INTR_CNTL);
-	ext_int_ctrl |= ~PDM_DMA_INTR_MASK;
+	ext_int_ctrl &= ~PDM_DMA_INTR_MASK;
 	rn_writel(ext_int_ctrl, acp_base + ACP_EXTERNAL_INTR_CNTL);
 }
 
-- 
2.53.0



