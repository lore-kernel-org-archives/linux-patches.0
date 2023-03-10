Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224ED881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F6EC4339C;
	Fri, 10 Mar 2023 14:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459453;
	bh=fZ5rapfdlAzrCg0xIEjPhhoPk9/UiSMJQ2aXTC7GyfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDuBeIkWVfHZcqfR5x4HiWjCX9q5NBjjOeAQuCFhyHKblBjGOrmYQpHGwDaRzvalB
	 FUQWYkovifVjGYLtP6VNv07mVD4QZdncmDXHMd5gZqMHhRv/q/bxyljxISb+o5Yhct
	 cBbEj2n/wOdr2et/H831Gj7F7pX8GUbANxKrxrYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke D Jones <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.cz>,
	Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 001/529] HID: asus: Remove check for same LED brightness on set
Date: Fri, 10 Mar 2023 14:32:24 +0100
Message-Id: <20230310133805.057707515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
@@ -402,9 +402,6 @@ static void asus_kbd_backlight_set(struc
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
-	if (led->brightness == brightness)
-		return;
-
 	led->brightness = brightness;
 	schedule_work(&led->work);
 }


