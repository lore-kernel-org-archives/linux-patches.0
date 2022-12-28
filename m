Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2164A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B4DC433D2;
	Wed, 28 Dec 2022 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245835;
	bh=3swcK/NmKUbI4gOk2irO20suKHXcAyadUszm2JI/quQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivi3aI6e2ctSdRyH1jWcix8xgVlhEFKGsYU1m0W37m1hfoVkdEhAn1AoqpG/ZKdzH
	 l9mrLql9kleXXGfBzmt14u4SQL4mLBUWduUVIwhOlCE2MJTKC+MHCu2rbCVjGTpOT+
	 pn7//WWGCTSCkTiKChZtwnlmNmrVQBRVfU0eFAw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0933/1146] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq
Date: Wed, 28 Dec 2022 15:41:12 +0100
Message-Id: <20221228144355.635079983@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arun Ramadoss <arun.ramadoss@microchip.com>

[ Upstream commit 62e027fb0e5293d95e8d36655757ef4687c8795d ]

KSZ swithes used interrupts for detecting the phy link up and down.
During registering the interrupt handler, it used IRQF_TRIGGER_FALLING
flag. But this flag has to be retrieved from device tree instead of hard
coding in the driver, so removing the flag.

Fixes: ff319a644829 ("net: dsa: microchip: move interrupt handling logic from lan937x to ksz_common")
Reported-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Link: https://lore.kernel.org/r/20221213101440.24667-1-arun.ramadoss@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d612181b3226..c68f48cd1ec0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1883,8 +1883,7 @@ static int ksz_irq_common_setup(struct ksz_device *dev, struct ksz_irq *kirq)
 		irq_create_mapping(kirq->domain, n);
 
 	ret = request_threaded_irq(kirq->irq_num, NULL, ksz_irq_thread_fn,
-				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   kirq->name, kirq);
+				   IRQF_ONESHOT, kirq->name, kirq);
 	if (ret)
 		goto out;
 
-- 
2.35.1



