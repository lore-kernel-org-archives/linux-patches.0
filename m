Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6A811CAD
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtmVRzt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D5AC433C8;
	Mon,  9 Oct 2023 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857034;
	bh=XmLt1JsT9DUeZsWZhZZ5lZGEzBGz1o8WKUaPkHbGig8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtmVRzt57xVreo7KIrKUyWTVhnU/dc+NRI/vMGEkgGORVbhXeyS2IaW3VjMGU6WHE
	 GSKfn1Fvw8Ga2eFmJvnH//odTbE6xS/4NaQnTQbt2wLDlCzlRVSSDIt9FTmqDgxZ4C
	 vh8+CeJopgRS7N5OULwjXgHCPnkPRyTIfZy4U6nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 074/163] leds: Drop BUG_ON check for LED_COLOR_ID_MULTI
Date: Mon,  9 Oct 2023 15:00:38 +0200
Message-ID: <20231009130126.095937802@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 04f9ea675f2ce..214ed81eb0e92 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -479,10 +479,6 @@ int led_compose_name(struct device *dev, struct led_init_data *init_data,
 
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



