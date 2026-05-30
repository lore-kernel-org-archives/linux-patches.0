Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B0A33FE15;
	Sat, 30 May 2026 17:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161348; cv=none; b=Hms+cCKBi525YkqnjfztE6klcgZtmR0K0oC8k2E/sgED+gQDYlHlUSzTGXTMW1Dw26WmRNY+styi+CBJi/TBTll23rMgKHdPd9bkHlOMRe8fxUuqdSZ1eKXMEGph7QA7RBVV7q0twk2fHd/2n0wnqUETCbZcC2EaqVZU0ucdWsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161348; c=relaxed/simple;
	bh=TrZOPVdEjhtwliT/TB/i/L8+934qV0BFP/k/vu/eVL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn392y5G9hxuOCgOlKKa70/eexX09TDpjR3PR/U0Qx56ja6oYW2755MN1kvNa7d9lBkHN5cpTDn8P5y3xhnkManhBT1vDqPIHLZ0yEcVh60koAQHmMoU9UEebgAe1J99nimAIM8nfR1NCVH5tIUyxs7TOKJL/zJCgm5Cr8sg1vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TK49NW+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TK49NW+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034351F00893;
	Sat, 30 May 2026 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161347;
	bh=RDGcnefnx8yZu3C6jwfbF3UkYPvIvCVoIfD2IvP8ZtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TK49NW+vJraCDoaIJvMNggketq0Im/IF+TW3SRgLyBscQjUpBbw9OKO+41JXPSKcp
	 0GIB1ridDhops0Kddou2EreQTped/l68LMsQ1W3SQcs+L2ieeDZr16wMReWASPly9c
	 CzsyDk41s37dLKOyF4jqL/dsCAPgLxxHF/Wm/UoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <karom.9560@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 596/969] dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function
Date: Sat, 30 May 2026 18:02:00 +0200
Message-ID: <20260530160316.880022323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Khairul Anuar Romli <karom.9560@gmail.com>

[ Upstream commit 48278a72fce8a8d30efaedeb206c9c3f05c1eb3f ]

checkpatch.pl --strict reports a WARNING in dw-axi-dmac-platform.c:

  WARNING: void function return statements are not generally useful
  FILE: drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c

According to Linux kernel coding style [Documentation/process/
coding-style.rst], explicit "return;" statements at the end of void
functions are redundant and should be omitted. The function will
automatically return upon reaching the closing brace, so the extra
statement adds unnecessary clutter without functional benefit.

This patch removes the superfluous "return;" statement in
dw_axi_dma_set_hw_channel() to comply with kernel coding standards and
eliminate the checkpatch warning.

Fixes: 32286e279385 ("dmaengine: dw-axi-dmac: Remove free slot check algorithm in dw_axi_dma_set_hw_channel")
Signed-off-by: Khairul Anuar Romli <karom.9560@gmail.com>
Link: https://patch.msgid.link/20260202060224.12616-4-karom.9560@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 7596864bf8bb2..46b080941b621 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -540,8 +540,6 @@ static void dw_axi_dma_set_hw_channel(struct axi_dma_chan *chan, bool set)
 			(chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	reg_value |= (val << (chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	lo_hi_writeq(reg_value, chip->apb_regs + DMAC_APB_HW_HS_SEL_0);
-
-	return;
 }
 
 /*
-- 
2.53.0



