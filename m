Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D57025228D;
	Thu, 15 Jan 2026 16:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496316; cv=none; b=FOxJQtjlK70VU13DL2pUUA8Q51e1WUuZ7os8C9l8GW3w18VhJ23wxouptfy2ucR+iv2VINWfaeR7CaUc0deL7mP8p4K3sTZ05qAgNWuU0PvqNDujNv2z9+q/QgFDe4woSsYFhtO9MGvQDC1y0uAq14c2Hd/qwPzgSNnPc8lvt2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496316; c=relaxed/simple;
	bh=n88uynv8kskMs4pf4tjzglrgYFXT/5snoVf+pNKeN7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdXvA3pgCI/hXRFdI4E8tso+bwYKt1RBOvC4DFYoNH+FHysH4PqLcSai4Mw5ij4Ge5P6Z1+WyRxnMRfiIuxQAjNrK8telppOY5PKhO2pO5YGy2ESZJjfiA8LaO6brFtclbWYTKCLXequUakLaDowsiCrhxy6uR7Kh0/FI5Qg1BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ/3SOz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ/3SOz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA56C116D0;
	Thu, 15 Jan 2026 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496316;
	bh=n88uynv8kskMs4pf4tjzglrgYFXT/5snoVf+pNKeN7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ/3SOz8le9CECI3e5l0YX/FckrsfDWPigQUO525z7FwPdGtXuQwIZ/frSFQ508Xt
	 WRAnoVTy8//4S8dAMDTftKLQ3ICroQlyd8n54mY9tlRpf7cD86WmC5MOGUJ1+9Ax8A
	 2RieGm8Wu+d6GYAg/VBdO5NDp6yC3CM2ediVGonA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/181] irqchip/gic-v5: Fix gicv5_its_map_event() ITTE read endianness
Date: Thu, 15 Jan 2026 17:48:11 +0100
Message-ID: <20260115164207.871681048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 1690eeb0cb2bb77096cb6c826b6849ef05013e34 ]

Kbuild bot (through sparse) reported that the ITTE read to carry out
a valid check in gicv5_its_map_event() lacks proper endianness handling.

Add the missing endianess conversion.

Fixes: 57d72196dfc8 ("irqchip/gic-v5: Add GICv5 ITS support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20251222102250.435460-1-lpieralisi@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202512131849.30ZRTBeR-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
index 554485f0be1fb..8e22134b9f486 100644
--- a/drivers/irqchip/irq-gic-v5-its.c
+++ b/drivers/irqchip/irq-gic-v5-its.c
@@ -849,7 +849,7 @@ static int gicv5_its_map_event(struct gicv5_its_dev *its_dev, u16 event_id, u32
 
 	itte = gicv5_its_device_get_itte_ref(its_dev, event_id);
 
-	if (FIELD_GET(GICV5_ITTL2E_VALID, *itte))
+	if (FIELD_GET(GICV5_ITTL2E_VALID, le64_to_cpu(*itte)))
 		return -EEXIST;
 
 	itt_entry = FIELD_PREP(GICV5_ITTL2E_LPI_ID, lpi) |
-- 
2.51.0



