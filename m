Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A1290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2148EC433EF;
	Fri, 28 Apr 2023 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681361;
	bh=u2ImX3bGwlWGqc/nfLy2Ar/BmZ9LM3hO0uhSXRbR+/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVi5oYCajm9skPmtggBgSwLamIn8aKAX3SY7XiozaB9ikvaHh3K3wh3+44koRj4St
	 on00J4EvoAjaeye0BTpR8yQNUg8XQLW4x5uhsckCVyTs7b1OyBXMRh97zwJzsV/HWK
	 VcTXulnO8ZB8UN90PZl6VlRDNHJjepicKL13ivTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Justin Chen <justinpopo6@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 02/16] phy: phy-brcm-usb: Utilize platform_get_irq_byname_optional()
Date: Fri, 28 Apr 2023 13:27:54 +0200
Message-Id: <20230428112040.138768041@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
References: <20230428112040.063291126@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

commit 53bffe0055741440a6c91abb80bad1c62ea443e3 upstream.

The wake-up interrupt lines are entirely optional, avoid printing
messages that interrupts were not found by switching to the _optional
variant.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Justin Chen <justinpopo6@gmail.com>
Link: https://lore.kernel.org/r/20221026224450.2958762-1-f.fainelli@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-brcm-usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -445,9 +445,9 @@ static int brcm_usb_phy_dvr_init(struct
 		priv->suspend_clk = NULL;
 	}
 
-	priv->wake_irq = platform_get_irq_byname(pdev, "wake");
+	priv->wake_irq = platform_get_irq_byname_optional(pdev, "wake");
 	if (priv->wake_irq < 0)
-		priv->wake_irq = platform_get_irq_byname(pdev, "wakeup");
+		priv->wake_irq = platform_get_irq_byname_optional(pdev, "wakeup");
 	if (priv->wake_irq >= 0) {
 		err = devm_request_irq(dev, priv->wake_irq,
 				       brcm_usb_phy_wake_isr, 0,


