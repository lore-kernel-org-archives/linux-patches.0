Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845CA245005;
	Wed, 20 May 2026 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295840; cv=none; b=fQbZj1FqOZqgNuAqz6eeqo+5CvJH3NEtYBW8bGYGc96RJ6zHtoXuwnwv1N7Gra3H0RSE6ayim6x+2EUdoDm3to06gbZch6+VxO14nIzVqg3EAFcKrcKOFX3dSPQe5Oo+6fj2ELuVhGmAUBVDs4VYam4/sM+sf1BNDccUkYUAYd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295840; c=relaxed/simple;
	bh=eAuCNZV1JzGcBxg81/KkYvsXpFAnTPV8804+T7t+dJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5PpHYrpfFVMImJneJrO4Yc8i6xV1S26YlOXUvr/x1DxQEvx3g8ORjruIElWjJCwfUPgzNr3So9oB4WZIUUKY7g2Y61dDyMXkKv5j7FMd7O9VgjmxlcI/UtIJ8VFYs4NaUDoahOPqgjVfCRDDyBe9zvt0CIVsQcbG1QRiC1W7qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boLHU+KS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boLHU+KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88061F000E9;
	Wed, 20 May 2026 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295839;
	bh=nvJ8o2J2rxpa+bEB48/crL9jsBuxhgvQpKbVWqjlkzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boLHU+KSOopRx6g5mP3kqp8AC0vHOeqIdwzp7Q4vBZLSjGmywn5ZpsHPFcuGk+ZMw
	 JpHDKAS9+hMvb9dDJLXwPxuXHzaA/lCjHhklK+FmPa/aEaFiM/1gPwxC7dHqLPeRAQ
	 T1M/VBx2rDWxJjJJ5gKQZqz8FtG1UvQv628aHIRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <karom.9560@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0573/1146] dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function
Date: Wed, 20 May 2026 18:13:43 +0200
Message-ID: <20260520162201.151168334@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b9fbfeb873e76..95e460422b2ad 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -592,8 +592,6 @@ static void dw_axi_dma_set_hw_channel(struct axi_dma_chan *chan, bool set)
 			(chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	reg_value |= (val << (chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	lo_hi_writeq(reg_value, chip->apb_regs + DMAC_APB_HW_HS_SEL_0);
-
-	return;
 }
 
 /*
-- 
2.53.0



