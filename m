Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25370259C80;
	Thu, 17 Sep 2026 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668935; cv=none; b=rP0TRtoXzNDJ+YcVDEDFdjKLgGmS9getsLKtf6G5x2IXso/YuL7HCoQYmZsNlZv/jhIzbZTi/a1d1HYKsgt7TParJR9K6tvyqs2q8nK+e4ydWFBSd1vVbZvjcf6i3JWbjgrm8Fo3/EX8IxUCY+0hx5+p+AudZFZe1XH65JMx5XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668935; c=relaxed/simple;
	bh=01REkuaChENODrBg+Osntg2fRCssV3bUh4cyuqjmD7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9cFoEdRXUy3kB18kHhSFsoD5PcC7zE3cTMwxFDPVyUlnSxWP430VtXk7zaXaovTCQX7xbux1d3we0UOV4NcqMrOe0TL2MNUunu6ZbGprwpnToFqe+qH+PAu8zKFDWbYtNovgsiEn+qixPBLI3o1wkM2VtTkNr5SBeaqaWb2Oiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKuPLJzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKuPLJzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFF61F000FF;
	Thu, 17 Sep 2026 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668934;
	bh=BqHuajmmYlj5MhibtPBrNA2iCwfpQAr4S9cWQ+E0tfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKuPLJzVRmIfJMARVFDiAOk/ZGLIdmuSHqGtfpF3+1xXyasChXVS820PsA/OunNf2
	 BfN8GKBR+VZ3ppX/Nvchz5Bfkvukso+OCt/XCLBTn8+fEmIK5gWwGMl0FXetKUcmIX
	 AS1wUqovN7KOjuYgjxULEkhZ8JAovBwIaKI3ppjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0588/1102] ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits
Date: Thu, 17 Sep 2026 16:08:51 +0100
Message-ID: <20260917151554.724618794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a560d06097d5e..ecb4b79520135 100644
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



