Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4611C37E5FF;
	Thu, 20 Aug 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238489; cv=none; b=oKEy+wQe4U+AuQQXn3DdHUEAd5KmXYADEwSCiQR7UxnAe/GnkXa3Y6mSzmGSNBL40hinGZFV2pJBtpG9PvRrL6+5GHm3rCNjSDTT9ZNDFH/4yZKAd6JGKGQfJUpjm7eH+9BNJ0HKQhBAZHdq1xsCp5C3lVmy1PSv5hzR8GIqEGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238489; c=relaxed/simple;
	bh=fW1Vq5vHnjWXYIM3D5QB48AIkOhqsFCYtiYitWppRV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ5d6VC1Wn+EuaVS85vbq/VfmDAZhRBMzR5d+VOVy8u1AKxY040oYboAv/xcM7hy2bxHGKW13OHgkgJ1kSa5xT/42ZhZFPQ0rXGiKXzBu+gvK6Em9MauR1ei2WYsl9k+vw31u2A8v6kUIafiWqcQOtulqG79jXsHBW0HZeRaDR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dpmewijy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dpmewijy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6CB1F000E9;
	Thu, 20 Aug 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238488;
	bh=llHIotU60pRrTjjj7sCSZ1B75DTI7+pWSmwu9/bqHjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpmewijyUsQLEp4DJ/hc9R9P+YODv8knX+iqJJjuc2xkL42eYrJt2sQBSMuruho4V
	 dLDdU2j9ZG9yUK9rEjqsZER0PG/5qn2wAvbjPjVVLTEhQyxSxN8QTZ8stguQGDJ+IH
	 8MbzzndGBwaG+7gEmaadfRr44mmzo7LbYXANBFio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 165/228] clk: spacemit: k3: set hdma clock as critical
Date: Thu, 20 Aug 2026 16:55:07 +0200
Message-ID: <20260820145249.697461123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit eb525edd48907795c0d4e498ff57ad168070b289 ]

HDMA clock is responsible for the internal TCM access path of X100 RISC-V
core, so set the clock flag as critical to prevent it from being shut off,
otherwise the Linux system will hang, for example in the case of a vector
instruction access generates a page fault.

Fixes: e371a77255b8 ("clk: spacemit: k3: add the clock tree")
Reported-by: Han Gao <gaohan@iscas.ac.cn>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Link: https://patch.msgid.link/20260630-06-clk-hdma-critial-v1-1-443c0ac88c5f@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spacemit/ccu-k3.c b/drivers/clk/spacemit/ccu-k3.c
index e0c5ca3df5824..4ab820a05b88e 100644
--- a/drivers/clk/spacemit/ccu-k3.c
+++ b/drivers/clk/spacemit/ccu-k3.c
@@ -1021,7 +1021,7 @@ CCU_MUX_DIV_GATE_DEFINE(isim_vclk_out3, isim_vclk_parents, APMU_SNR_ISIM_VCLK_CT
 /* APMU clocks end */
 
 /* DCIU clocks start */
-CCU_GATE_DEFINE(hdma_clk, CCU_PARENT_HW(axi_clk), DCIU_DMASYS_CLK_EN, BIT(0), 0);
+CCU_GATE_DEFINE(hdma_clk, CCU_PARENT_HW(axi_clk), DCIU_DMASYS_CLK_EN, BIT(0), CLK_IS_CRITICAL);
 CCU_GATE_DEFINE(dma350_clk, CCU_PARENT_HW(axi_clk), DCIU_DMASYS_SDMA_CLK_EN, BIT(0), 0);
 CCU_GATE_DEFINE(c2_tcm_pipe_clk, CCU_PARENT_HW(axi_clk), DCIU_C2_TCM_PIPE_CLK, BIT(0), 0);
 CCU_GATE_DEFINE(c3_tcm_pipe_clk, CCU_PARENT_HW(axi_clk), DCIU_C3_TCM_PIPE_CLK, BIT(0), 0);
-- 
2.53.0



