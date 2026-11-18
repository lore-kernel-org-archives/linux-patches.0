Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017108;
	b=x8jBcRX2Ui0+fZsKVKHDuLf5gTGGq4BF8nxOzew0Z/Qfkqlc8+J0QlnMYZSbX8ajklOl
	 EoI37Z6OYt2qUewS5ceGrJi0+sKeqmimwOg5joo7pKGi+bFiqzwgq33oIxTgq6n7qdHEA
	 9AvGqSTgPYk5HwmYT4xqReeO3ua9vTdY75fv5NDR+vtL1wwFNa5iWqKnl6jafYetXb7G4
	 4ee1mVmzeVfL6VknKgDyfDr1DlBUFw5cE2wvUS3alesyox0WcFluMCuyy4JATIwxSQ/bF
	 BgQxWeK/xnScRsFjP1Vx0XW0EUvlGWxAusmZvDy3REv5Qe/NNE2b02/ee2OSleq5CWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/MA1yR1/QkZ186cmz6zLrTre/9CTWgjZYo70hrr3zPI=;
	b=i8lTQX5HYvtsu7aMrx0rzlMkyaPsRnisZm3L3V3I85D6C5XNLOuiMXdzP/0gtGu82WDI
	 6DwYKPP4Y5/UFxHPUzmk2cuoWS1sGLMUfoD6bLFx66VHrRxDWLBUbpAoU4V1rg2QXpuWY
	 fzemKbrxwYyOI4mbjUzSZt09OG0VGQ68LpbwiM+mrNzAxOKEdasBaUPqv+9iysak9mdPp
	 RvNbpneBOEmLSP51X1ygqdrVWrwIza+ZNDGapbODWXz1gw2tws+EMSYuLpVRyFlhe5o6k
	 hUZcQVnNUP2vdNCpjPS9sfWT7ljrl91ry7HJ0aNlPcgEWxsBQcC/YXkNXwR3Z6eHGZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVEOcdFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F4606A32F;
	Wed, 18 Nov 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVEOcdFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8C11F000C4;
	Wed, 18 Nov 2026 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017108;
	bh=/MA1yR1/QkZ186cmz6zLrTre/9CTWgjZYo70hrr3zPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVEOcdFTpVIUEs0k+LJ2O0Z0HKwkJruKpEG2bCRLv/eI0p+WP/ZmjU7qmJBkyL3WW
	 e3lLFulpHqMl7M6BFLoucmmdJUkYTgOrjB28WSM4zU4p1iAKutIfsJYIBiSGMwjm7/
	 lspiBj8JXP+m5xfTtwXXepGIVx3JAQtPy8WFYHxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ike Panhc <ikepanhc@gmail.com>,
	Rong Zhang <i@rong.moe>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0766/2651] leds: class: Remove hardware control trigger when writing brightness
Date: Wed, 18 Nov 2026 15:33:26 +0100
Message-ID: <20261118150315.458442865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit 96b4ddd6d2d8c645d672f1f26130685d9f40cf2f ]

Since commit b819dc7d8fb2 ("leds: core: Report ENODATA for brightness of
hardware controlled LED"), the brightness attribute becomes write-only
when the LED is controlled fully by the hardware. A write-only attribute
is very confusing.

Moreover, most LED drivers set hardware brightness innocently with the
side effect of disabling hardware control, but the hardware control
trigger remains active, resulting in the software and hardware being out
of sync.

Fix it by removing the hardware control trigger when writing the
brightness attribute.

This should also match the semantics of hardware control:

    When the LED is in hw control, no software blink is possible and
    doing so will effectively disable hw control.

Fixes: b819dc7d8fb2 ("leds: core: Report ENODATA for brightness of hardware controlled LED")
Acked-by: Ike Panhc <ikepanhc@gmail.com>
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260921-leds-trigger-hw-changed-v7-3-fe3cdb6dec51@rong.moe
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-led | 4 +++-
 drivers/leds/led-class.c                  | 3 +++
 drivers/leds/led-triggers.c               | 9 +++++++++
 include/linux/leds.h                      | 2 ++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-led b/Documentation/ABI/testing/sysfs-class-led
index d4c918cc11a12..f6d4e17e1a3b6 100644
--- a/Documentation/ABI/testing/sysfs-class-led
+++ b/Documentation/ABI/testing/sysfs-class-led
@@ -28,7 +28,9 @@ Description:
 		Writing 0 to this file clears active trigger.
 
 		Writing non-zero to this file while trigger is active changes the
-		top brightness trigger is going to use.
+		top brightness trigger is going to use, unless the current
+		trigger is offloaded to hardware (in which case writing any
+		value will deactivate the trigger).
 
 
 
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 7110bfbe3b837..39cc2f3ea63f7 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -64,6 +64,9 @@ static ssize_t brightness_store(struct device *dev,
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
+	else
+		led_trigger_remove_hw_control(led_cdev);
+
 	led_set_brightness(led_cdev, state);
 
 	ret = size;
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index bf2543538ed08..804a04b326c4b 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -287,6 +287,15 @@ void led_trigger_remove(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL_GPL(led_trigger_remove);
 
+void led_trigger_remove_hw_control(struct led_classdev *led_cdev)
+{
+	guard(rwsem_write)(&led_cdev->trigger_lock);
+
+	if (__led_trigger_is_hw_controlled(led_cdev))
+		led_trigger_set(led_cdev, NULL);
+}
+EXPORT_SYMBOL_GPL(led_trigger_remove_hw_control);
+
 static bool led_match_default_trigger(struct led_classdev *led_cdev,
 				      struct led_trigger *trig)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 46ad2e03e1c65..d778709f5b1be 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -533,6 +533,7 @@ void led_trigger_blink_oneshot(struct led_trigger *trigger,
 void led_trigger_set_default(struct led_classdev *led_cdev);
 int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger);
 void led_trigger_remove(struct led_classdev *led_cdev);
+void led_trigger_remove_hw_control(struct led_classdev *led_cdev);
 
 bool led_trigger_is_hw_controlled(struct led_classdev *led_cdev);
 
@@ -586,6 +587,7 @@ static inline int led_trigger_set(struct led_classdev *led_cdev,
 }
 
 static inline void led_trigger_remove(struct led_classdev *led_cdev) {}
+static inline void led_trigger_remove_hw_control(struct led_classdev *led_cdev) {}
 
 static inline bool led_trigger_is_hw_controlled(struct led_classdev *led_cdev)
 {
-- 
2.53.0



