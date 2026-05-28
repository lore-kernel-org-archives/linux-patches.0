Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B2F32ABC0;
	Thu, 28 May 2026 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998719; cv=none; b=VrwkT/suZ+6+bE4Izf7bbV0tFYEw71rAoODUkdNPmE/tyTf9jQvmQFDRrRgo4LEkCI6uwrXfQCN4Q3nNOfDRVwG/0xFu16sw9sGZ3q/s9gQ98vJXMnpsMhKWnFcRjtRRcL25VS/WRENTZH/qLTgC+YB7sbib39IdRhsdeFlRr+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998719; c=relaxed/simple;
	bh=w0Qavf5/UP9HiCs/EWYZNftAzRZGjRHihLZIcu5/ewg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lt75hC/fD5pknOa/RArnBUBVKd+UdWZ1yVesZHcIUmGVtg5xOAJQ81UfjF2CmiPUFg4CBo0BEFtD2l1PsDdoslDViGT3g5nBRok35+6FhIR5c/t2155HKnHo9nJh0XA0g3ZPwt2O1cxLHkuyHHHjvcgFPk1BtgkFfmaBG81wHbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrwhu9VW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrwhu9VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64C51F000E9;
	Thu, 28 May 2026 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998718;
	bh=5SVNtNRCbmSTQkzQQDnbWxlTHGQCIrKkzdtUd0TEo+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrwhu9VWlckhxH66PKlxX+ZQFcmDCOT2AMMdRywZZ6L1QbqQZVF7kowhu0iq1KH3R
	 CfCWSlGWS+mEliTQsl0i+TIZbrlhbXjO+Hn6iPKHm58zzy6ZrGj54i2ZC46FQM5jY6
	 tfScbNNC6whZZf6yPeUeprap/sM/Mqe31Ct9xJcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 237/461] irqchip/ath79-cpu: Remove unused function
Date: Thu, 28 May 2026 21:46:06 +0200
Message-ID: <20260528194654.003504902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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



