Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712FD39A4A4;
	Sat, 30 May 2026 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164354; cv=none; b=q9YTM1uO2jJUTpIv+CGlGK9E4eB2dnRmTEmYnWSuF264SMWcEmSYzhF+GYgh+hhA3WyT+XpWoYQaLrDO3F7ds1mkMF7urzg5+1hf6EwrMaNgLrwGDws3e7NG2y9UmAtr+UE2ZtI+bdunzsMBtBm7PC9I0ok6ehkILgeoE4efrMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164354; c=relaxed/simple;
	bh=vX+o4eyHgG/1boF0nKwL2AQ+NHO9GiEdqDd6mKqoz40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/ncNEziLAOJWPr6SLN7XlyYAfLaqWR0N9JflKxHe8JxerwOedkd46zC2G1PjlUp2Z3M+4Ifh/h8PIZVLzwH0jGVmELv+3oE5aMEroBNi7LmRWDPJ7WpXYoRkVcrWxEyx18wv8VHdmO5ZE+4liziPF1AQ7/dIhAstZc8cwZqE60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DImS8lc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DImS8lc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F061F00893;
	Sat, 30 May 2026 18:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164353;
	bh=iG36f9sP1EaAjw4eUBFzXbFylKj6E09lPqVKx6kKnC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DImS8lc/BsmzVNX/EKKgKQvGk19IWjnqxLNWdkAx/aeunpKNAj/KrLKTV3tCGXdUU
	 cR5DSAYEz0aI0EGTFflsDyniRS2dVckd4ihUWyIEMYvoV3sIwunGnjvrA4lxuHAGbo
	 dZV+BzPj9Rdm0nYul+Fd3qTlA2an4YCzhpQ+uGj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <karom.9560@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 500/776] dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function
Date: Sat, 30 May 2026 18:03:34 +0200
Message-ID: <20260530160253.215487525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6715ade391aa1..95b3c2ea98419 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -502,8 +502,6 @@ static void dw_axi_dma_set_hw_channel(struct axi_dma_chan *chan, bool set)
 			(chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	reg_value |= (val << (chan->id * DMA_APB_HS_SEL_BIT_SIZE));
 	lo_hi_writeq(reg_value, chip->apb_regs + DMAC_APB_HW_HS_SEL_0);
-
-	return;
 }
 
 /*
-- 
2.53.0



