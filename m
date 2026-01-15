Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1446134F24E;
	Thu, 15 Jan 2026 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498882; cv=none; b=dnjkwgl8P8soCe5qD2A3zqwCJ5oDEpWfCVsYw3e3UE00WO/seDByTDAEuzKaAzhtwjh6LcMWR/z4W9RPURP7hZmebMLLD9hty+8GvssCRYsv2iElhba8yt76q1SeP9NHJlaGPl5rNfEWBV6b3/W40zhTEQmnEhnU++GrrDCXNW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498882; c=relaxed/simple;
	bh=Wu8LkRPxFwIptvVpJ5o7oCyxUan7McWdSHzuHgNvMX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGVr5KZ4+Y1mGC9QahePkiYru2e5JCynoiR/b5iwO9UJ5pHAt0fbz6a45E4tNgZbqgp9drjpv76PlO1OZrhnIg2/BN4TgKaNnrRT9b8CsckKKgNX2jcZWhWfeNBfqnyyh6myTf3zuk5SEZVzIpsZ0PMqn4SH8F0L3obJdFunfOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbhR44cY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbhR44cY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A32C116D0;
	Thu, 15 Jan 2026 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498882;
	bh=Wu8LkRPxFwIptvVpJ5o7oCyxUan7McWdSHzuHgNvMX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbhR44cYZLNLlPjJEI/ZNxchKvCMZi2NN7HAf161neAijFnBNZN1iCFYYnFFsfem3
	 IYiRvXXzJSK5+XvuDHX8tc4hQX8+6iOtP9rEOFM43jxU2e7IEttV0w6e+b3IC+tj74
	 I7ya7tH8SXTTPjq4ocoaOWd+vv2M/YYi/VUNKbH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/451] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Thu, 15 Jan 2026 17:43:53 +0100
Message-ID: <20260115164232.055630591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa54bfcb0433f..7783cbdb8dc02 100644
--- a/drivers/irqchip/qcom-irq-combiner.c
+++ b/drivers/irqchip/qcom-irq-combiner.c
@@ -226,7 +226,7 @@ static int get_registers(struct platform_device *pdev, struct combiner *comb)
 	return 0;
 }
 
-static int __init combiner_probe(struct platform_device *pdev)
+static int combiner_probe(struct platform_device *pdev)
 {
 	struct combiner *combiner;
 	int nregs;
-- 
2.51.0



