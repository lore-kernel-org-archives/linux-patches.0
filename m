Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CE8401A1F;
	Wed, 20 May 2026 18:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302415; cv=none; b=mvelWwsgIYCupFEUMzGOzE4raN5s+5SP/Ucekk2AyUGl7ojTtBl6AThg/m1TkHL65AVH9fevIevSNKugbIT2IvDRuVCbuLg6OFeGEpRk9danCBEK2qoo/tv6SvgWsaGyR/yW7jTW9B2TH+XXr3uwVXRPxdlTE6rnn7htjrKOA/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302415; c=relaxed/simple;
	bh=ZcpQZ+u8RKAFCZmetz3NVuR6oS/FjmvSiE83SuNCQyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hg/kV207gbjI7ZWzL9Vx4RAADbwZjD8JLJcO+gI3yQvPYzpV8Zz+J1u5mCuY5dloO+0QotpPFQYE0IDS3NvqWi+uZTaTnuf5No/U0rYjOd7zcBbxhIGVHPO10d8hpLVJe9j5ILgvz69+dtPWm9dEGJGDVJcO+faiZu5JdwYJPYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yq0jNuKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yq0jNuKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB871F00894;
	Wed, 20 May 2026 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302414;
	bh=ytrdTLGa55pO1cw6RdZfOfc2AkCW1FzmE64WngUl2CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yq0jNuKLWa0wmWbqpiz6G0KNefvUB+4sZJIfhzoTZ+ersOPra6waizZ+c/KIvgrpJ
	 k1vzzbmZzZhFhHQmrIvCZmr1HGdrHg1JllxkVloGW4Ka15K+zlwDikAQC48gVHW3hi
	 UdiCaOh6BH7kocjDW4F5GE/rd0GebjtxOeDqsZ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <karom.9560@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/508] dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function
Date: Wed, 20 May 2026 18:20:39 +0200
Message-ID: <20260520162103.320104157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 72fb40de58b3f..3ea3e203253a9 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -546,8 +546,6 @@ static void dw_axi_dma_set_hw_channel(struct axi_dma_chan *chan, bool set)
 			(chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	reg_value |= (val << (chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	lo_hi_writeq(reg_value, chip->apb_regs + DMAC_APB_HW_HS_SEL_0);
-
-	return;
 }
 
 /*
-- 
2.53.0



