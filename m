Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9897130FF1D;
	Fri,  9 Jan 2026 11:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959485; cv=none; b=JRuD3VmXGPqGSAWGctdpXusj6mIHwc2qJhuwyWcgjMyPo1SHthO9ef61j8W9X28cCOwrmSzdRktg0yFanANIEQl6io9tNXD/GWiF6iZicuUmGKhiW2pof1YtZQU0sEFIgMd4jAYUR/u9+RBHwQNIcZOr3Nf5HibqPM5Xhd0ad1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959485; c=relaxed/simple;
	bh=EykewuUKMRWAm6WBNt2KNViLwW1TH2s/npV9V4ObOcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfC9qXzOKGpuTvtTtlzrDXWDt3claCaaXmXTZCKSPQfB/s5woU2jX1tKlRIn1hMKdU0L+j3m7zmDudOvhUg8IJZgxCUlfRYqBDtQVp2VhgR4miUsLUBmsUs3Hkhs8VkLDMQOFsnAiZEow2ShtSMMaWM9mnyZmsooR/5rtp6TzVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H99a/p4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H99a/p4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C56C4CEF1;
	Fri,  9 Jan 2026 11:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959485;
	bh=EykewuUKMRWAm6WBNt2KNViLwW1TH2s/npV9V4ObOcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H99a/p4hkR8X9auoCgTME629lhNhgZHdXUqnppnlKb3aRsLIHLeA0XYVsLLOovYjL
	 7UHQZZELjCl+ddYNq5xC3f2BTepUy6F24G4MX/4GOsqEabBsKPg501ZTQxtxIRBywh
	 urZCln+xtDD4Z5DMef6NVV3pvIrtTNCT5XGFDhz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/737] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Fri,  9 Jan 2026 12:33:26 +0100
Message-ID: <20260109112136.518733842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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



