Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1DB1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTJacJWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377A4C433C7;
	Mon,  9 Oct 2023 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857553;
	bh=T6H3Jvz0xIel/CMhLRkphXxfGzCGjKIaIWN+vC7YdmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTJacJWT/aH75950rnn4Jk/m1371ZfBM291aSUJxSyWI/sCM1gCsJPPktxBiejeLT
	 mZsN6WN7MRTTfFlLl1u0V2/8w5lWpqnN4EZ/4CK/nyWhdNVf8EaxQ0luU+SkFzbbVv
	 HG7kd0MxPIUPZC+0U1yIr1KVPqhCnM7xIabh10Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/162] leds: Drop BUG_ON check for LED_COLOR_ID_MULTI
Date: Mon,  9 Oct 2023 15:01:04 +0200
Message-ID: <20231009130125.209013374@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 9dc1664fab2246bc2c3e9bf2cf21518a857f9b5b ]

Commit c3f853184bed ("leds: Fix BUG_ON check for LED_COLOR_ID_MULTI that
is always false") fixed a no-op BUG_ON. This turned out to cause a
regression, since some in-tree device-tree files already use
LED_COLOR_ID_MULTI.

Drop the BUG_ON altogether.

Fixes: c3f853184bed ("leds: Fix BUG_ON check for LED_COLOR_ID_MULTI that is always false")
Reported-by: Da Xue <da@libre.computer>
Closes: https://lore.kernel.org/linux-leds/ZQLelWcNjjp2xndY@duo.ucw.cz/T/
Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://lore.kernel.org/r/20230918140724.18634-1-kabel@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index aad8bc44459fe..d94d60b526461 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -424,10 +424,6 @@ int led_compose_name(struct device *dev, struct led_init_data *init_data,
 
 	led_parse_fwnode_props(dev, fwnode, &props);
 
-	/* We want to label LEDs that can produce full range of colors
-	 * as RGB, not multicolor */
-	BUG_ON(props.color == LED_COLOR_ID_MULTI);
-
 	if (props.label) {
 		/*
 		 * If init_data.devicename is NULL, then it indicates that
-- 
2.40.1



