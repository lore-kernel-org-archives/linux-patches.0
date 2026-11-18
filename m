Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017103;
	b=1rzGqkfFmU2wyW/yOPQEM5XnqgAP588qDBOPFAlxD1RjD2uayJEt0IgM1+W7GWCwZ/ZB
	 6FwZgNR2fHVG/Z5WlXocpsYNnfE2tdXlBmumT6OpEK7UKibWsTut2z3L16BTMsEpOb9Pn
	 3QEh0nPF8cY/UBf/+9XaEcNOLhbP/8Rg97fiqyOKjLuVR3u3LzO0unhsEjhuQNiC0v4TN
	 cKqrgTIBTXxPqpDMt2slU01mIKF1opAe3mDlHOTkiprw1qJtHvT4JVARBdGaIdFmhxtM7
	 90tZ3aW5CEWaXdtsynEygn64Z4L4uFgxJ2u5YogrnnwqZLYCQNG2LyfvUWjwUzNVBgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMvzwFfnBWaIIMc/FHoC1XOPg7Q5Yu7rnm8jr2uPsmM=;
	b=x+YpebNfZwY1wCoGVeIbGRwRNEOSXOAKp6Qff7J20dP8JRE40uKtYaXGC663AyHbL61G
	 qRtX9LniEkPDTH/5RUB1GP4qlsSR7Ama1fckpLJ3W6Kvrbtu1yGG4ZCv1nu8lfnOlVw2C
	 TjZJOdajSCmZ2n1ra6vzMPKQ6n1AbZf9YchIOoEkLtDnn78BmzghS1FyN69xOiqBOmFzb
	 S+9jJmyMRD1lVEpeXd+MzQlJF1oKgHU8fssXvwfvS9Nq2I7cQloQhOsOmycCmaNDeeWrM
	 J3g15fc//ZCs9o4Px6a+MD+jQzI85uqdixvexem4onEQVziUyPvor48Sv12iEvrt8mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+YFDaTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18944606A325;
	Wed, 18 Nov 2026 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+YFDaTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A421F000C4;
	Wed, 18 Nov 2026 15:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017102;
	bh=KMvzwFfnBWaIIMc/FHoC1XOPg7Q5Yu7rnm8jr2uPsmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+YFDaTqaS431nNfdcAkRu3amLocRBcgrBxcUq9sT29F4nt4LRBi4ez/ACY6WFhVs
	 CUElOkRrhsVvUT6nNFm2bJWCYoS19HIlrUBiEhZxYGz+wWQmUGmhShvOLKNCL+9qV6
	 Wl6PHPFHmbMXBHUgEzQaBkSqrYWZ2jTAW6eqdqzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0764/2651] leds: class: Always protect brightness_show() with led_access
Date: Wed, 18 Nov 2026 15:33:24 +0100
Message-ID: <20261118150315.387929917@linuxfoundation.org>
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

[ Upstream commit 6887f40dadb5a263de1d9e4b5517400c08089d35 ]

The led_classdev_register_ext() protects transient states when
registering with the led_access mutex and relies on all sensitive sysfs
attribute callbacks holding the mutex to prevent exposing transient
states.

The Fixes: commit broke this as it accessed trigger_lock without holding
led_access. Fix it by protecting brightness_show() with led_access in
all code paths.

Fixes: b819dc7d8fb2 ("leds: core: Report ENODATA for brightness of hardware controlled LED")
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260921-leds-trigger-hw-changed-v7-1-fe3cdb6dec51@rong.moe
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index a51b0ed538864..4259533dafa19 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -43,13 +43,13 @@ static ssize_t brightness_show(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	unsigned int brightness;
 
-	if (led_trigger_is_hw_controlled(led_cdev))
-		return -ENODATA;
+	scoped_guard(mutex, &led_cdev->led_access) {
+		if (led_trigger_is_hw_controlled(led_cdev))
+			return -ENODATA;
 
-	mutex_lock(&led_cdev->led_access);
-	led_update_brightness(led_cdev);
-	brightness = led_cdev->brightness;
-	mutex_unlock(&led_cdev->led_access);
+		led_update_brightness(led_cdev);
+		brightness = led_cdev->brightness;
+	}
 
 	return sysfs_emit(buf, "%u\n", brightness);
 }
-- 
2.53.0



