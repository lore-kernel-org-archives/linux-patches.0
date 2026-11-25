Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617746;
	b=fXIvHTEnmteJZj6ByOByGOda67jXmOi51YF8SD9O4y/BrMis6NYZwoGqMIEg6jjxtygH
	 yFjqUVRC90ETcg2VS6us25kvFhX646MH5++dV7QTfhHmXG17CgXWl81a0BE2NfWEOJDUZ
	 rijXUYjyqxBeUUIZ9f+y0KCwJ+b6MpX6PDFjuDOd+wsn5Lm9dx2woESYKf87tBgt6DzNG
	 /ZycQwLMFyocyLeVgrhJSjDP5C8EcX/0IKO0blkKNsOCbXG8JIRAXHrSqVOThCqLVy3WD
	 EmbfEAsUkvC6fB1/a2CzefsjhLS/1DOX8LgktfRqcEGM8oOm9+HsxKK/0PpZEzKPMmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LhoD5Wqul1ayvjAy15Hri2ZTMyGXWAQiHhZmVMI8W00=;
	b=PDMPmMMD0RXgnZzslP/LEnRSHICaRn6i2rmR75xmVhAxPrVXd3NM5LSP59EUhqi33wSq
	 jurgw/w25A0afUsD6/h4pNDldULW6CyM8g4Yd7QR1/nVikhLvgPKJICBHtHiE5VHBey5A
	 8asjRGQdmfRTEmrcCBIG+Z1pSz1ZVOGSF3X7uZwPUK7RLMU6HVYq3y6q35dNVvFC4LAse
	 LDuOBZs/tN4FshvnK4h89frkyyKb2veQ1b2gqjxHB4K079fPoaFpr1T6/H2VCFCDEGIlq
	 /CA1KkrIiowUxtDpnBxkSYd13fE7c6kzUEkmLctlf/RKZh3er89rmXD0bRdO9FGMKFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5HMvN8m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EB4606A326;
	Wed, 25 Nov 2026 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5HMvN8m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99891F000CA;
	Wed, 25 Nov 2026 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617745;
	bh=LhoD5Wqul1ayvjAy15Hri2ZTMyGXWAQiHhZmVMI8W00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5HMvN8mrT4UVpGBvyXCjd99P91hHwXt1LDlLkZ2uDSVrRZC7khBKKSgmujmGeE8h
	 SuSQgLoC0vDKGbtB8avxl0wrClhfrsA69OqT4P66yjy3WlaXzvrqEUC3PrnmbpUPVC
	 w2UMz+k2yd9Odi5fZf2jMpohn41wqHcAGcpVpHtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gideon Heinz <gideonheinz02@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0024/1005] Input: destroy force-feedback device on input unregistration
Date: Wed, 25 Nov 2026 15:22:42 +0100
Message-ID: <20261125143822.302552231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2ae35f090d029d2d8491b0a7f98a04c5c05d0a44 ]

When an input device is unregistered while userspace holds an open file
descriptor to its event node, input_dev_release() is deferred until the
last file descriptor is closed. Because input_ff_destroy() was only
called from input_dev_release(), force-feedback teardown (ff->destroy
and freeing ff->private) could run after the parent driver had already
unbound, freed its device state, or even been unloaded via rmmod,
causing use-after-free errors or page faults in unmapped module text.

Commit ef166ce08801 ("Input: stop force-feedback timer when
unregistering input devices") added a separate ff->stop callback for
ff-memless, but left ff->destroy invoked from input_dev_release().

Once __input_unregister_device() has disconnected all input handlers
(which flushes effects, closes the device, and marks evdev dead) and
deleted the device from sysfs, nothing accesses dev->ff anymore. Call
input_ff_destroy() directly in __input_unregister_device() so that
ff->destroy() always runs synchronously while the driver and its module
are still active, and remove the now-redundant ff->stop callback. Keep
input_ff_destroy() in input_dev_release() (where it is a no-op once
dev->ff is NULL) to handle input_free_device() on devices that were
never registered.

Fixes: 509ca1a93836 ("Input: implement new force feedback interface")
Reported-by: Gideon Heinz <gideonheinz02@gmail.com>
Closes: https://lore.kernel.org/r/CAPb1+K2BxnfQ7VUQ15td5f9pVhn-ARSM9EjfOU8WuW72o+cvPg@mail.gmail.com
Tested-by: Gideon Heinz <gideonheinz02@gmail.com>
Link: https://patch.msgid.link/2f722967b6db0692d4dd4164aff39b62@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/ff-core.c    |  2 +-
 drivers/input/ff-memless.c | 23 -----------------------
 drivers/input/input.c      |  5 ++---
 include/linux/input.h      |  3 ---
 4 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 0e5d1d1ceb460..133b4622dc49a 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -338,7 +338,7 @@ EXPORT_SYMBOL_GPL(input_ff_create);
  *
  * This function is only needed in error path as input core will
  * automatically free force feedback structures when device is
- * destroyed.
+ * unregistered or destroyed.
  */
 void input_ff_destroy(struct input_dev *dev)
 {
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index d1fefd1dfc0de..3069436148ec1 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -483,32 +483,10 @@ static void ml_ff_destroy(struct ff_device *ff)
 {
 	struct ml_device *ml = ff->private;
 
-	/*
-	 * The timer is normally shut down in ml_ff_stop() when the device
-	 * is unregistered. However, we still shut it down here as a safety
-	 * net and for cases where the device was never registered (e.g.
-	 * error paths during probe).
-	 */
 	timer_shutdown_sync(&ml->timer);
-
 	kfree(ml->private);
 }
 
-static void ml_ff_stop(struct ff_device *ff)
-{
-	struct ml_device *ml = ff->private;
-
-	/*
-	 * Even though we stop all playing effects when tearing down an
-	 * input device (by the way of evdev calling input_flush_device()
-	 * that calls into input_ff_flush() that stops and erases all
-	 * effects), we do not actually shutdown the timer, and therefore
-	 * we should do it here to prevent it firing after the input
-	 * device is unregistered and its associated resources are freed.
-	 */
-	timer_shutdown_sync(&ml->timer);
-}
-
 /**
  * input_ff_create_memless() - create memoryless force-feedback device
  * @dev: input device supporting force-feedback
@@ -543,7 +521,6 @@ int input_ff_create_memless(struct input_dev *dev, void *data,
 	ff->playback = ml_ff_playback;
 	ff->set_gain = ml_ff_set_gain;
 	ff->destroy = ml_ff_destroy;
-	ff->stop = ml_ff_stop;
 
 	/* we can emulate periodic effects with RUMBLE */
 	if (test_bit(FF_RUMBLE, ff->ffbit)) {
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 6c45a158047f2..2f0fa8ebee857 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2265,10 +2265,9 @@ static void __input_unregister_device(struct input_dev *dev)
 		input_wakeup_procfs_readers();
 	}
 
-	if (dev->ff && dev->ff->stop)
-		dev->ff->stop(dev->ff);
-
 	device_del(&dev->dev);
+
+	input_ff_destroy(dev);
 }
 
 static void devm_input_device_unregister(struct device *dev, void *res)
diff --git a/include/linux/input.h b/include/linux/input.h
index 3381608127f72..02047cc45d04c 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -549,8 +549,6 @@ extern const struct class input_class;
  * @set_autocenter: Called to auto-center device
  * @destroy: called by input core when parent input device is being
  *	destroyed
- * @stop: called by input core when parent input device is being
- *	unregistered
  * @private: driver-specific data, will be freed automatically
  * @ffbit: bitmap of force feedback capabilities truly supported by
  *	device (not emulated like ones in input_dev->ffbit)
@@ -579,7 +577,6 @@ struct ff_device {
 	void (*set_autocenter)(struct input_dev *dev, u16 magnitude);
 
 	void (*destroy)(struct ff_device *);
-	void (*stop)(struct ff_device *);
 
 	void *private;
 
-- 
2.53.0



