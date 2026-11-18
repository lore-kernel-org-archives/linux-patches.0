Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048246;
	b=1viUb0/uaIoqH+DA451N+UH8MR0v45At0UZtrqnxAQtdP2oDCHrOYfFwZNyBNCwRGAaE
	 bd1YROJUa4CI0LEbjirllYkDeYXbYHRuHdTveDk0BCx7P5fzTn4uRjDfeowx4flUiRJPs
	 TkXrZOnWED/5hzXQVdfmGu+hQod7FFDftwGp0bxheI1J/tBPd65zmNXt48BjvifH+GuYI
	 EOWPIh5cDrnIg30AK93UEOmMCdWwQKLquKw5VFq6pMQNcxSrSg1lSpV0nOm1nCU3Y1r8M
	 k1zB8ejEGg21FOMjqwhFSwHNHgh/FloypaiPyQ2aNO1rtgtDjVk/wT8pMRPj/vTS7Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQPtTQ9q00fcXkvLyvbuhcibtVlh+NwRfDAJKIpUXrw=;
	b=FKcWcQ1vq94jxTU60UqVanhFIV5PNLOdf58b4TN7Kl7DC5tHXeNwhH0hdWDAdXAwQ49l
	 VahcmjjLQbh3NcelW3IcRBSsrd5wuG9yU7301W41rZVmLCIOQB/ceAEP08Gm+FJjrLY0V
	 j0lkU6EdE08bcllst1N1s41NDJKLGmXPOufMXxFNeyR0Tbcel0CUeUau4GlLG4fhqEGWv
	 7cfatBLruRZYaxxneOsHB1/mdnd1l1AY3Z9IXlaWU3VkDpgnBFV9lDJjL8mq24Nv8yQHr
	 KktsuIoevo3VTVrzs8vfoCp59andU+rLkDTgVymebW9M/HCG+/GYXFXvZmmrxhcxrJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxfdRpot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80125606A332;
	Thu, 19 Nov 2026 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxfdRpot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8BA1F000C5;
	Thu, 19 Nov 2026 00:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048246;
	bh=JQPtTQ9q00fcXkvLyvbuhcibtVlh+NwRfDAJKIpUXrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxfdRpotwaErvPyodAOdFzp86SB9xq9d59qtjayAABPD+bc82WrwCLMgH2JZ4BCbu
	 krgRy2JIXcQQQwjwA7YLJ9FsSZO/ThXlxo7t3AhpOgUZG4FBg1Zl2+oiGSjfkGJ4yF
	 ga0/HkeHRx2h8OMGlUaLHZ4Uk1T5wWv4aHLPSEck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1926/2857] pinctrl: amd: Use pm_pr_dbg to show debugging messages
Date: Wed, 18 Nov 2026 15:49:20 +0100
Message-ID: <20261118150310.557237373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c9a236419ff936755eb5db8a894c3047440e65a8 ]

To make the GPIO tracking around suspend easier for end users to
use, link it with pm_debug_messages.  This will make discovering
sources of spurious GPIOs around suspend easier.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 44c232e80adc ("pinctrl: amd: add timeout to irq-enable readback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 95de96cdd807e..cdd7841b93163 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -30,6 +30,7 @@
 #include <linux/pinctrl/pinconf.h>
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinmux.h>
+#include <linux/suspend.h>
 
 #include "core.h"
 #include "pinctrl-utils.h"
@@ -622,9 +623,8 @@ static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
 			regval = readl(regs + i);
 
 			if (regval & PIN_IRQ_PENDING)
-				dev_dbg(&gpio_dev->pdev->dev,
-					"GPIO %d is active: 0x%x",
-					irqnr + i, regval);
+				pm_pr_dbg("GPIO %d is active: 0x%x",
+					  irqnr + i, regval);
 
 			/* caused wake on resume context for shared IRQ */
 			if (irq < 0 && (regval & BIT(WAKE_STS_OFF)))
-- 
2.53.0



