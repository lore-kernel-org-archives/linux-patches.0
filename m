Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C695678281;
	Wed,  7 Aug 2024 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043333; cv=none; b=FdRvO/g0UqGEHMLUAZykdRWwvgif0hz90SEo2q69EriFUsDJ/VeFm8TOuiz7Q7b75jL5mcha78G29ftsdDQmCTK/AnnoTtVa4CJMZx7ZrTdvYQkK/vqrYP0Up8HU8+ZFm3YgO7trSRvOQpTT6fFy1VT5Z01zvbmJhtoCOg04i0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043333; c=relaxed/simple;
	bh=VbXEu9ghFo6MPRSCRfq5V+QmZGcNoqHq+BaG24UJ2D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1yFeirp99i19ELxPZzpQ1ZvJbGHVGAmmxIzJzxuJ5U/g/dZOZKJMYSmSCQbXkR0tAVKy3o2Zn4D/vaeT2RAsGoUd+RcaTxvFVMTcwtOyg22QXUOPg6LsKQA3289FNSB3s5jx81kyDqc+HFSLJZpaI7GffVGpDyg1k32Sd4n+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1hZTQzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1hZTQzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B01C32781;
	Wed,  7 Aug 2024 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043333;
	bh=VbXEu9ghFo6MPRSCRfq5V+QmZGcNoqHq+BaG24UJ2D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1hZTQzcL+lixboSt9MkPDTV9WQdOPmfYFytaxuk5H8/IsnERTnBCHsbNKCPzlxNB
	 NAiEr4lHAn5fGx+/06Zc8ldkagDzTfQmp0oZgA8fuL/WBolPsdCljd5EV1gwXqPLIv
	 vo383kkHtQsR253KBjU0x+6QD8RQFchBDl8HtrzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/121] leds: trigger: Remove unused function led_trigger_rename_static()
Date: Wed,  7 Aug 2024 16:59:15 +0200
Message-ID: <20240807150020.108605948@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4f5829b726a75..081acf1f345b3 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -269,19 +269,6 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
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
index aa16dc2a8230f..6a4973feecd65 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -527,23 +527,6 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
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



