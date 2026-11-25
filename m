Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620896;
	b=O2CID/XzGNvf7civ7W587Gb6E8ZBj4RuTBpXbGhyUudoxaS1JzwbN7NNPjnWXY3twLQl
	 2I7QWQAmQdL0I2HC55wkR6/QQPGx31rMEpE2hNiUcPuk5UIgE4fR5ScMWWSlAh8eeouCF
	 ojty4QoV+dxuF1s/wWqWJWYQ6A9JHE+FigFCwGTkAyDDcjwqXaAHOprRVXiWOXhtzeCK3
	 70cAW9209F1dqkFuBiualX4jwyoQdgdBt34ZPdqnTPlTictWPIE63JQyaMv2aXGiFuU0j
	 ZZ0Xx6VjWLAFHAJNfezwZe1kcJpDH/ry8NaJxNczeTLf2LSS14hgQJhLVQTbqyPsaqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vl6IaCx1TvhEdhGzhAo6dL0ugtHSvMne1oCY6bhgN6g=;
	b=U4FA/HsFSZucrZ+tjg9w28aB2akhzcRQq+SuiTZJ2gHX+uyqTJBRhyZLXVjLGuVfWL3y
	 048jeuKCPNCuVUkSxIIGtThMJADfPpPXA9QLeaG0LFxOJymJ8agIrtyzf1ODsUdPOfee9
	 oJf+6BxNo/3l0QCt+v1Sni+PQGPHGDMPBzVnS32oHHvDF96Q54EaLNBU5nbvvr1q/r5bh
	 R76CK127JncBXaO/bDTJj4OYxAIX5Sr98qI4Dl51IkApMZf5/yBRaO+dZ51HD/YBMwBq7
	 JXiu57DYXdTbyFY3sJRxzQ1FzbyO5y6KzpmqvnOAJUKu0ifoRseeBJuMsC99I4P3Ckg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xnKKZ1nY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8F7606A326;
	Wed, 25 Nov 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xnKKZ1nY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35FE1F000C0;
	Wed, 25 Nov 2026 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620895;
	bh=Vl6IaCx1TvhEdhGzhAo6dL0ugtHSvMne1oCY6bhgN6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnKKZ1nYOiZ878frrYCLCAG0yvNmBMc+CD7JftvR9Vd1Kbbk8glsqMMQyX7Z5bg/H
	 XoU0/3MgkXvtQGTGm2UJ8gxBQNDn8B9vZpMl/P6FnZcoDrqlLte8XrW0lvh+xH4QTC
	 +6we2AZxchAHTgOuElYXKwRewq/sZliZ12Geqzjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gideon Heinz <gideonheinz02@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/990] Input: destroy force-feedback device on input unregistration
Date: Wed, 25 Nov 2026 15:23:42 +0100
Message-ID: <20261125143823.375862469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the ff->stop removals because that callback doesn't exist here, and ml_ff_destroy() now uses timer_shutdown_sync() instead of timer_delete_sync() to make up for it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/ff-core.c    |  2 +-
 drivers/input/ff-memless.c | 10 +---------
 drivers/input/input.c      |  2 ++
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 66f7ffe8c7e05..34fb744ec50c4 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -339,7 +339,7 @@ EXPORT_SYMBOL_GPL(input_ff_create);
  *
  * This function is only needed in error path as input core will
  * automatically free force feedback structures when device is
- * destroyed.
+ * unregistered or destroyed.
  */
 void input_ff_destroy(struct input_dev *dev)
 {
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index e0c1c61aae713..ba910b08ceb96 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -483,15 +483,7 @@ static void ml_ff_destroy(struct ff_device *ff)
 {
 	struct ml_device *ml = ff->private;
 
-	/*
-	 * Even though we stop all playing effects when tearing down
-	 * an input device (via input_device_flush() that calls into
-	 * input_ff_flush() that stops and erases all effects), we
-	 * do not actually stop the timer, and therefore we should
-	 * do it here.
-	 */
-	timer_delete_sync(&ml->timer);
-
+	timer_shutdown_sync(&ml->timer);
 	kfree(ml->private);
 }
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 9907dd9ec880a..8df346f1ca42c 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2196,6 +2196,8 @@ static void __input_unregister_device(struct input_dev *dev)
 	}
 
 	device_del(&dev->dev);
+
+	input_ff_destroy(dev);
 }
 
 static void devm_input_device_unregister(struct device *dev, void *res)
-- 
2.53.0



