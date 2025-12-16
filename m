Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD26347FEE;
	Tue, 16 Dec 2025 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885128; cv=none; b=qXFmhFu0l9vEeeJPhm6M4kgo61XwkMzPZI+x205+JnjkBOqhbv72Y8pV96g+YaLsmAhBlLO61yeKk0n/d+/wBeDsCF3RwajHIDxuK4LHpwkJ5krDc+x4LN/+n92Stp7m060/jFd6ZlBTRzcAzthIgMqJwUPReew6h4WKXtncmb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885128; c=relaxed/simple;
	bh=sqUslxzKDwgFQ6CTYk0j6h1KvR7nKac3aUn2SJVQrzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOdB4iRPADKEBFE0TxpMMr/GMoaxfjvwZ7oQQmddJblzfE1d2yINqXzl5S81IxkOxQrOjJCn635OiCH8kTsL5qzfGInM1Xq3glMOzyDnetYXoal/hVPhyAba7A7yqBeyzV91sJ8AwT9Ldu0kjQcWpQ0ORtqCGZ58VN+lJTqL1Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvLWMzyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvLWMzyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AAC4CEF5;
	Tue, 16 Dec 2025 11:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885128;
	bh=sqUslxzKDwgFQ6CTYk0j6h1KvR7nKac3aUn2SJVQrzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvLWMzyhPn9rsIx1IKZJCoQwWEhrsMdPIwlFaSVbfXG5mTZ8U/kewFSLVEFdPGiiF
	 PfgdFbPzZRFbSKTydg1ikG5n0mD2VuET9wxp9pTIdLpOr7Pm6VQ71AXc6lL3Lh6VOa
	 JJ5SqSx+liL2GD1as6utFjvZEjh/okl/BtYPvxM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 046/507] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Tue, 16 Dec 2025 12:08:07 +0100
Message-ID: <20251216111347.212431988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



