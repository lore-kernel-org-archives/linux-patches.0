Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113481714A1;
	Thu, 15 Aug 2024 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730130; cv=none; b=BW6gQmqfhz9d9zXzlZTMEwATkOC8CMH9sbQcsCK4EjxxD++5c8O4zIadeF2F1uckEnY3A/HyZ9+YIKyxtEy6xrhXkE4VOq3gjQDpbBeIZp6H/MtKOT9IqtDTGJUdg00CPvKRU22FL9hgMkaqv4LL/oy68bvWu6sb4bVm7pTxn+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730130; c=relaxed/simple;
	bh=XaTPKSdlxnLUzi/0dMZIFxSC8luhyzcgMjv18M5Hyj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJPthC9ZGd++jiigIlXUiz9jtXVVZQGr4eo9xUyAwLSCNg1OMomxvo+R8EJ+r2hxMU1iqGa5aTTwVrtFSnGCVzD6UtIcZlUNKfVTl76on70UCx72pCcwICv6kA+ZaTD6UYfHaN51M6TX+6qaAUwPnr6LBCAw7LDVAkVEhnfw0dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+HwOHJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+HwOHJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87530C32786;
	Thu, 15 Aug 2024 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730129;
	bh=XaTPKSdlxnLUzi/0dMZIFxSC8luhyzcgMjv18M5Hyj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+HwOHJKJyOC9g9NOFgcWQmqEG7qg5Qcq7jot5rlWJj08KN7TwvC8VXjh+Pgrg+7q
	 COZBWp+34DnGSU/ssjohKZKn7N9ECeKyHs4soy07YYF6Ey4UmpWJNWXoXfSR10BpaW
	 FFyjjFYvCJOXcEpKe6Kc+9x6gft72QvTqoqG0eIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/484] leds: trigger: Remove unused function led_trigger_rename_static()
Date: Thu, 15 Aug 2024 15:22:51 +0200
Message-ID: <20240815131953.495400773@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit c82a1662d4548c454de5343b88f69b9fc82266b3 ]

This function was added with a8df7b1ab70b ("leds: add led_trigger_rename
function") 11 yrs ago, but it has no users. So remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/d90f30be-f661-4db7-b0b5-d09d07a78a68@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: ab477b766edd ("leds: triggers: Flush pending brightness before activating trigger")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c | 13 -------------
 include/linux/leds.h        | 17 -----------------
 2 files changed, 30 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 024b73f84ce0c..dddfc301d3414 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -268,19 +268,6 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL_GPL(led_trigger_set_default);
 
-void led_trigger_rename_static(const char *name, struct led_trigger *trig)
-{
-	/* new name must be on a temporary string to prevent races */
-	BUG_ON(name == trig->name);
-
-	down_write(&triggers_list_lock);
-	/* this assumes that trig->name was originaly allocated to
-	 * non constant storage */
-	strcpy((char *)trig->name, name);
-	up_write(&triggers_list_lock);
-}
-EXPORT_SYMBOL_GPL(led_trigger_rename_static);
-
 /* LED Trigger Interface */
 
 int led_trigger_register(struct led_trigger *trig)
diff --git a/include/linux/leds.h b/include/linux/leds.h
index ba4861ec73d30..2bbff7519b731 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -409,23 +409,6 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
-/**
- * led_trigger_rename_static - rename a trigger
- * @name: the new trigger name
- * @trig: the LED trigger to rename
- *
- * Change a LED trigger name by copying the string passed in
- * name into current trigger name, which MUST be large
- * enough for the new string.
- *
- * Note that name must NOT point to the same string used
- * during LED registration, as that could lead to races.
- *
- * This is meant to be used on triggers with statically
- * allocated name.
- */
-void led_trigger_rename_static(const char *name, struct led_trigger *trig);
-
 #define module_led_trigger(__led_trigger) \
 	module_driver(__led_trigger, led_trigger_register, \
 		      led_trigger_unregister)
-- 
2.43.0



