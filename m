Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E3E3F54D1;
	Wed, 20 May 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300817; cv=none; b=dBfz3HxZbF2LBWMy/ZCWi1QtM0AtXDW4eT0xUkASy1I0KiwRgj/kpnu9899QXSgd7oDVSwr/DoEGniMFb035sSnxxUdPOP0rfP4Lx2u7Lj0mDgOyZ2XTEfSugdp6Z4l/yUc/fnyM3046kCMuAL8j2oPDBin2vfhovm/eSeyFQk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300817; c=relaxed/simple;
	bh=t6OMZUi3fZ/M0PH2lKFtGsaRifuEnM0Fg4vrmzPzrPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtZ3viJVkL5l5Wy23CLBOpQkfeE+pEoyNrR6Fz4gs3ZIL6liLRz2E/V/qXhK/qG7LZ4IkSjLokV7d8qn6hYLvPF0G0scihB5/ehMG64WswHIJF5iz0JUmnd4Sx39HIvuGpAErMLm8rfupqpPMoBd26VRzzd4GsQuuA00LZ2K0N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leSIyFg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leSIyFg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131F21F000E9;
	Wed, 20 May 2026 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300816;
	bh=n86tQmq0zlcVKrXmbw0AlQWnQRkJZSLgVstmtSz+MWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leSIyFg/cOsKPXEB4AYNbvw9lRrJcMAOqgbXrYDoKa1tENWv0qbCxLERnf714y6jS
	 WcPCP5fNcTr+/L5tZ1YI58x8BCyRJ/uPvojHPuJMUOX0p7/6gj0kBMgxUehjdp1IgA
	 XbGFsDPOy4Y9uqwHvZUnPbPiYLQu+gZKU9FGKHbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <karom.9560@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/666] dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function
Date: Wed, 20 May 2026 18:18:50 +0200
Message-ID: <20260520162118.135984111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index fffafa86d964e..adef111aca31e 100644
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



