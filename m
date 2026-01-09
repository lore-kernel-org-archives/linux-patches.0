Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA781531E8;
	Fri,  9 Jan 2026 12:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961550; cv=none; b=auy6JwvdSOZzxoEnNfk/MW/ABKd84PPmJtnozlO8V+Dbrddf+Vv5tvzx4dzse2gSkwVi0+Y7c1iwRoUV7VpOHOHimHsMUdSMoqp0U+Cge8ffPj1KabACjlNRG6Qr6LOC1I0bYYeupDxiKs/CsnzndgbvBdYm5PDyfa06ln+ljXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961550; c=relaxed/simple;
	bh=BC4Y2J58BV5CXtc1k5/139ENZBuF85j7EzStTiK/Y0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORr2XN69RCulxwDt/GFwn9OVUHE3CDGwsKmHYgz5/a0gsEInRx8WloqyLoOoEokqAZDzSnMCtiYwv3aIv2PL7UY3amfnE9uUy/aYRG2j9bNirl6SaFGX3jTMDR1kEkeLyEE+M5tCHuB/iQZ5n1g5zjHndsltaEMlkmVqk3c3d7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5cVU/hW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5cVU/hW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D93C4CEF1;
	Fri,  9 Jan 2026 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961549;
	bh=BC4Y2J58BV5CXtc1k5/139ENZBuF85j7EzStTiK/Y0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5cVU/hWzA7a6hrsPWNw9nNV5Weuel3LlMtvqqBm9E3QrjN2IVHT0h+HmAvtHNbNg
	 cO/E6PA6RLKsH71QEYMIyxAcF5ieOetGwOW+vuDuNjpprgbApuBeauTLr6X9kJFOZF
	 TILsQEyLk6XnWgWpz8ZCZZsDzpq3ghUFLSMK75CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/634] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Fri,  9 Jan 2026 12:35:31 +0100
Message-ID: <20260109112119.440844306@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



