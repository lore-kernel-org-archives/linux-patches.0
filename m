Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9CB847D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BD4C433EF;
	Fri, 10 Mar 2023 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678455894;
	bh=mpdXmXUtZN3L1OMEJO1JO9Swez2ShNpVB5+YAfK5iCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQctv692de+OgMP3K1kKriw4xuq7hVOHj7BNbf+3eMu4X5Zs9JaGO5X0aSeqy2GEy
	 ilCsN4wNrIttH2haFo9jOt0wkvrAVdKDG+Cg7m2FJLkDhpm+7YrPa8iu9rfiBmFKAK
	 MtAYYfXgo17Em8D48abrejpNo3zj0tXPSqheSkf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke D Jones <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.cz>,
	Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 012/193] HID: asus: Remove check for same LED brightness on set
Date: Fri, 10 Mar 2023 14:36:34 +0100
Message-Id: <20230310133711.346718374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luke D. Jones <luke@ljones.dev>

commit 3fdcf7cdfc229346d028242e73562704ad644dd0 upstream.

Remove the early return on LED brightness set so that any controller
application, daemon, or desktop may set the same brightness at any stage.

This is required because many ASUS ROG keyboards will default to max
brightness on laptop resume if the LEDs were set to off before sleep.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -298,9 +298,6 @@ static void asus_kbd_backlight_set(struc
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
-	if (led->brightness == brightness)
-		return;
-
 	led->brightness = brightness;
 	schedule_work(&led->work);
 }


