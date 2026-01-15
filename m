Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4B03BFE2C;
	Thu, 15 Jan 2026 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497318; cv=none; b=tkuKPXLvbZpClyk/p7nzcund9PE0pE97IKY6GP+XCONAilyjFSMaUsqs7pzJUQQALkkwP7waJG+TLvvrrxI9b9BH15+ZcbSRCHHpIoGBfjCZYPGKkNdtxK+u4lNNmAxZvJG2LP+k/X3oB2IrofHulF6+qCdzk2HY05yLX4WIizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497318; c=relaxed/simple;
	bh=XeiP/VRNc+JRAjmK3R3fz6SLSnRenVMFpYrYGHcMEm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUm15BhjQBV2Nn4YHTpe3st8BUv2MspKwi6iAkcG3/hzgP6t8TOUmRz5CQ/b2vjMZTL6LVMxXcGnwPD7xnN8BgPFXllPb6rgK3AFwHM6OqMEk+cuU0adjV+sfI6Iji2LZ8mmTs3UkPKCXHII/MJZhr2olq2E/CiD2tJPLBZhVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6yg3RcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6yg3RcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C89DC116D0;
	Thu, 15 Jan 2026 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497318;
	bh=XeiP/VRNc+JRAjmK3R3fz6SLSnRenVMFpYrYGHcMEm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6yg3RcVrlJre2/dyfPdEedS+8vg/JmriUDWOgb6q/AAYNiamWOTCbZiXCXliEYPp
	 RmVF1I6N4t9iOQ43dHVTm8IrMguFz8cIzDe5H3b7HgGmtSuP5X8cKMFjGMz8ETm442
	 zZOGPbBqR0MKiCRZ5sgwZP19b2sf7E/6WAv6MzCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/554] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Thu, 15 Jan 2026 17:41:46 +0100
Message-ID: <20260115164247.692141299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9b685058ca936752285c5520d351b828312ac965 ]

Platform drivers can be probed after their init sections have been
discarded so the probe callback must not live in init.

Fixes: f20cc9b00c7b ("irqchip/qcom: Add IRQ combiner driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/qcom-irq-combiner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/qcom-irq-combiner.c b/drivers/irqchip/qcom-irq-combiner.c
index 18e696dc7f4d6..9308088773be7 100644
--- a/drivers/irqchip/qcom-irq-combiner.c
+++ b/drivers/irqchip/qcom-irq-combiner.c
@@ -222,7 +222,7 @@ static int get_registers(struct platform_device *pdev, struct combiner *comb)
 	return 0;
 }
 
-static int __init combiner_probe(struct platform_device *pdev)
+static int combiner_probe(struct platform_device *pdev)
 {
 	struct combiner *combiner;
 	int nregs;
-- 
2.51.0



