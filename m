Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893DD233D9E;
	Sat, 30 May 2026 18:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165095; cv=none; b=Pi4UNnFzpDZ8DKj8960HMwG+0OCjI8+pUb1Fasd19qYF3GvSaBG77p49BrOjL0O7X+lmWtX2xb6g7LuMBxNS76oGEFQ1rlWKF1H6XKHMNrFe6BHJRHKJQhesZzagaxF1BKKFhvk739sxYiGIU8PKF+5mNZR+vsTJNxuzAVQp/oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165095; c=relaxed/simple;
	bh=eiEWH06mLJPrYNbMYsI7/igL6ok7wBkUvMVGpnefNKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlwCzvNpz7Xv14tN3Y2AZCV1W7UYJTiKnZdyewv10zaFfhu5O6xhGhSvd7qnxDIWDe2pqwQfhfR5K9zplSUy+gu+MJ8Aatre3cL7rpCsHsw4p3pc00BbX0MOzQpN86hrhUf3+1dyR1TS1grZgDnEKTA11wLOs5Qe/dqMESsY194=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdcXKVz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdcXKVz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D681F00893;
	Sat, 30 May 2026 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165094;
	bh=MaO3MbL/0/CK12TJkS1bmTpTDjTdbb+Uh0BeTvD34uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdcXKVz4TLbgc5dbLKbJ0xY0QT2HZPyhVm2BScvnBuJFna2QqUH3JRKAKPaHJ81ls
	 NnAwMaTg0qjCSGyMzv4TGYUERiNBCEbhhIgwL2ptN5nQbt73fWPMK/DrSwltxVw+jn
	 PuHVFnR/VtfhUvYKfdOrNtjJZ0IHAwxT9DAk7ff4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 747/776] irqchip/ath79-cpu: Remove unused function
Date: Sat, 30 May 2026 18:07:41 +0200
Message-ID: <20260530160259.080371637@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0fa10fb77069fb67aa51384868ef3702b7791465 ]

ath79_cpu_irq_init() was part of the legacy pre-OF code that got removed a
while back.

Remove it to get rid of a missing prototype warning, reported by the kernel test
robot.

[ tglx: Fix the subject prefix. Sigh ... ]

Fixes: 51fa4f8912c0 ("MIPS: ath79: drop legacy IRQ code")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260506085522.1210143-1-rosenp@gmail.com
Closes: https://lore.kernel.org/oe-kbuild-all/202412011509.kGQkDr1y-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ath79-cpu.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/irqchip/irq-ath79-cpu.c b/drivers/irqchip/irq-ath79-cpu.c
index 923e4bba37767..9b7273a7f8ced 100644
--- a/drivers/irqchip/irq-ath79-cpu.c
+++ b/drivers/irqchip/irq-ath79-cpu.c
@@ -85,10 +85,3 @@ static int __init ar79_cpu_intc_of_init(
 }
 IRQCHIP_DECLARE(ar79_cpu_intc, "qca,ar7100-cpu-intc",
 		ar79_cpu_intc_of_init);
-
-void __init ath79_cpu_irq_init(unsigned irq_wb_chan2, unsigned irq_wb_chan3)
-{
-	irq_wb_chan[2] = irq_wb_chan2;
-	irq_wb_chan[3] = irq_wb_chan3;
-	mips_cpu_irq_init();
-}
-- 
2.53.0



