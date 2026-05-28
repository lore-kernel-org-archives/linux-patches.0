Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F62333C51D;
	Thu, 28 May 2026 20:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999879; cv=none; b=tZYqZQ7QUgM+DlM2wUq8tZlwZNWca8xthyjNtIeM/rEkoLGOLmA0S4cekvVDyMEZl2lMvgzv2/Mv3ZGNh8/h7bcuQQzo5MPWcOdQfzY43Uan+o9Va20d1TI22OvgdKKvesqwwMgAsl+VIhwIqPGqPEiaVGCkaIqyglmJovWzTD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999879; c=relaxed/simple;
	bh=517p9j9WozpB3EC+5Q2CUE7pePp9qe6OJ/kTdJCI3J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTErr/ww9C2J1/dg4sbW0FAlL1genXTXStDhKA52wokyi5k19sHgbN1acXTzfqfVcIJrRkCmfLz8Sq1oVIRZqpxEwyeXhgAqOSId2xvqj+ifw1uWk9byIKKSwo7NzRndDC97VCtd5W5RpU4hiFEei/mw5h3ElGzx2rq+UAKb5BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FI2EfCNB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FI2EfCNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A491F000E9;
	Thu, 28 May 2026 20:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999878;
	bh=k+jhgIHdRMmSFg3yDmRW8SVYNNm7JHSnqFRGCFHSzWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FI2EfCNBwkbvToCvkolgGkiKMnHHvQaMukh1s3E/PwGdgDNQpurTtN19f97aOU903
	 CIBxGChnRYeuHRPlX10S6cjtf8bZj4P3A8Zu+mWm7iCdsAP2bZ4nhuLoJorCzRDPEp
	 xubfygcjYnUcY5liMAXEQMSaECvkzcMZioXxA2tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/377] irqchip/ath79-cpu: Remove unused function
Date: Thu, 28 May 2026 21:47:40 +0200
Message-ID: <20260528194644.821374203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



