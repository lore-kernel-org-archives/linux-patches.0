Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A316532862F;
	Tue, 16 Dec 2025 11:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884021; cv=none; b=p+3wIApEGITxsUdZef+TMPiWt6ViVvyZGS6bz76J/Snr/kPOOdLrH5e1Ce68FxsuDce/LLzQ4LYj86qHAMSG9G0dSDedJeVywcCw5lBgkQjsGcG3HRnrFMWV9HC5HbUnBuXjQ9yesK08c/JpkEbM6rdt2lk/Cz8VMp9jO15tFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884021; c=relaxed/simple;
	bh=O7s4efUYCypIMA7icb7gcVutYcQjNyBuL1P7fEJrPlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvqBJeAly7lbiG+QNdXfvh5L2kDjtAL8yrJqvEg8E5qn9oTwE08jI3aite3fKeZzz0FBMwtCdb6mk5dbjrJi9ETPI6MtZdy3QM02PNluwirALZ11Zk29gzugz5tQLased6EQlg01kF3IDz5T5BbUBgeO2HhbbmLergVNQn03cQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQGD1IUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQGD1IUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19CCC4CEF1;
	Tue, 16 Dec 2025 11:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884021;
	bh=O7s4efUYCypIMA7icb7gcVutYcQjNyBuL1P7fEJrPlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQGD1IUZSaaeu5IpcKhqpHqGgpMxgg4ylsonqgGrU+7LVBEXkC+9AwAStNFc2zn+2
	 Efy2C3lutT4gie2D2P1/U1u5PO+y574HoaOnByF245X1lUSwdZedMYP3E7WuG68smQ
	 xM5eL4mby48Nh1/Vc+XYaEy+SNuAx0DBZt9t8nho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/354] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Tue, 16 Dec 2025 12:10:03 +0100
Message-ID: <20251216111322.222700812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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



