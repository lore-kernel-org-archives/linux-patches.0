Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D7F9CC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxZyQ41B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7CCC433C8;
	Mon, 16 Oct 2023 08:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446139;
	bh=NzOtwo/i2nhwP5zMqPGkren+/YdDjKqB+rwYImBwJws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxZyQ41BsE3SUm61DtdrU8c5meanwJiZ4pY8v3FZ+2I5X9TRzillMWWgAWMcbYSS8
	 r1pPGVA2u2adbVnGc40MtLUA+HvzCR44tSv1VawtAjPEDU3xNPzT0fdfTKVTE0PAAG
	 bgjxSjZ69GHa40fYukoOjPmMCmfVKA4/UTdroUc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dharma Balasubiramani <dharma.b@microchip.com>,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 5.15 076/102] counter: microchip-tcb-capture: Fix the use of internal GCLK logic
Date: Mon, 16 Oct 2023 10:41:15 +0200
Message-ID: <20231016083955.723339543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dharma Balasubiramani <dharma.b@microchip.com>

commit df8fdd01c98b99d04915c04f3a5ce73f55456b7c upstream.

As per the datasheet, the clock selection Bits 2:0 – TCCLKS[2:0] should
be set to 0 while using the internal GCLK (TIMER_CLOCK1).

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Signed-off-by: Dharma Balasubiramani <dharma.b@microchip.com>
Link: https://lore.kernel.org/r/20230905100835.315024-1-dharma.b@microchip.com
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/microchip-tcb-capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -99,7 +99,7 @@ static int mchp_tc_count_function_write(
 		priv->qdec_mode = 0;
 		/* Set highest rate based on whether soc has gclk or not */
 		bmr &= ~(ATMEL_TC_QDEN | ATMEL_TC_POSEN);
-		if (priv->tc_cfg->has_gclk)
+		if (!priv->tc_cfg->has_gclk)
 			cmr |= ATMEL_TC_TIMER_CLOCK2;
 		else
 			cmr |= ATMEL_TC_TIMER_CLOCK1;


