Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7171B85F8;
	Mon, 14 Oct 2024 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917572; cv=none; b=WgS4hEKdrKhk5jxUHcw5nzbUwKG7A9s2O95GrSqFJSaWJ2ksV9IFLDnmY8YR7hN1T6MGKPthNO0fcR7kRgoCUGF2ArUf0VFwn+2YPJUoYO/so0wmHeFre0h6vwkMsFljqsmkFUCXkSMVoBu8yBEfda25MKgeni1jtJtpXq9mQTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917572; c=relaxed/simple;
	bh=nMPrnxhmZ/sHb092lPPKYPV2pGUipdOcBnlyfWwcJ0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBqakvQyy67TZG57rH32CWVk/QGWfpvUguXezp8gmEoYP4Mi5gbgLVYcVCivJIgwF7Xnj+PxwjWG10HvA7yGK3we8adKBvr7qAwpRbfl1j5Senbo+LScjPP+5+eq15O0trWtv//KMtDo5KMKUTS6+O3RyY9gICVPJ1EeeVu7ONc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iC1QMzjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iC1QMzjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1C3C4CEC3;
	Mon, 14 Oct 2024 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917571;
	bh=nMPrnxhmZ/sHb092lPPKYPV2pGUipdOcBnlyfWwcJ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iC1QMzjnVRL2evfoTpdHCQzhThKPYLbr+mFI3hZFjiNsSvhUJu79+BCO+ofnbdx02
	 d/y1Scn5o9X1Cxxl39JuX6RxvLnNHoE1S1NMrf+UJH7xaLxBRFOx2gIabS8GQrilOV
	 2duxcecXxoGYpIBrc2OSSwBBKAQ6ZD+HKLb2ZzWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/798] spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
Date: Mon, 14 Oct 2024 16:10:25 +0200
Message-ID: <20241014141220.729412565@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7781f1d120fec8624fc654eda900fc8748262082 ]

0 is incorrect error code when failed to parse and map IRQ.
Replace OF specific old API for IRQ retrieval with a generic
one to fix this issue.

Fixes: 0f245463b01e ("spi: ppc4xx: handle irq_of_parse_and_map() errors")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20240814144525.2648450-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ppc4xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index edfe0896046f9..be1dd4e6a3e7d 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -26,7 +26,6 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -410,9 +409,10 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 	}
 
 	/* Request IRQ */
-	hw->irqnum = irq_of_parse_and_map(np, 0);
-	if (hw->irqnum <= 0)
+	ret = platform_get_irq(op, 0);
+	if (ret < 0)
 		goto free_host;
+	hw->irqnum = ret;
 
 	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
 			  0, "spi_ppc4xx_of", (void *)hw);
-- 
2.43.0



