Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623964;
	b=tE5wVQHC6oHQ9FAZk5AvGS1udUjQlk4JwCgEj4d+4DXlaJj4wt8G5gvOpq1VQKzrg4o2
	 i0Ou9bpNIRvL3wOiCowtK2/3hMLdrJzHAwVHRYynYqUB6XVnIaZjcU4tA80vvWmOCg09f
	 QfIhDc+64ZgPw5tCuNsDPelGNO7aTHtBH2c391QiudInhn8m1INx9PpjcSZyDZtni7ax+
	 EtjkdbpKekpFS6HcntJxwobJgYdRHzy3+cSCZr/bwvwuaHXDTgDB/iM6kHolYKYs06rTc
	 GYBcqmr9Kli8LdvtjPT+Edti3Ewrd8EHOP/wRaK8TdBLw8lbCuyIBoNDv67R59Z5UGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eu6GrbXyj+UaQi3yjV+U1Dr/9097cecpEEsHxp8wEcE=;
	b=WQHaEwbUg84zXlWS74pY9YKwRHkF/vbor9+esnilbT0hurIYlb7GqDbIMxrxhKZkpQWy
	 pB04yGoNVMZ18v0GSPNRsKhWn0iTlABrETtrHPUKoNuNBhx9cVWq92/e0xyVN86SL87pR
	 GllLGIzWnG1mWxx1YtJ/DXXjBK+Q7p4bUyNPzPX3OKJ3OAw/EpQRwfwqX7nsza5Ax03gP
	 OJ7XsNvdX+8gXFBu73I26DfmPQl0PNQ6eWpNajqdpcrj1Qx21n8nDnDwGwtd6ZOY0TSkc
	 x+fArPQZYoFyN/wV/il8QoSOlY0lFfupLGO+V5S5yzE7RHjz+4T2MEMUdam3IvzDbiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cqK1I/HA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5AE606A323;
	Wed, 25 Nov 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cqK1I/HA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5A81F000C0;
	Wed, 25 Nov 2026 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623964;
	bh=eu6GrbXyj+UaQi3yjV+U1Dr/9097cecpEEsHxp8wEcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqK1I/HAfwbbp/akLzx4GEfypv24Qt+gbQMrEO+LUyuDQZqiSjoqnvIz9/et3TE+B
	 9QQwyjhfVJ6GCruVhiQXI1N8K1B+iqxGB0J3UmOJjJMlQXADpGt9vbjG2rZItYP2cM
	 4bgakL9CwivS7XDiOmr4JgER0x7llO3Tdr3x+iDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gideon Heinz <gideonheinz02@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/816] Input: destroy force-feedback device on input unregistration
Date: Wed, 25 Nov 2026 15:26:31 +0100
Message-ID: <20261125143850.219832228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the ->stop removal hunks and adapted ml_ff_destroy() to the bare timer_shutdown_sync() end state, since this tree lacks the ->stop code and uses older mutex_unlock context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/ff-core.c    |  2 +-
 drivers/input/ff-memless.c | 10 +---------
 drivers/input/input.c      |  2 ++
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 609a5f01761bd..624f8defa5432 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -358,7 +358,7 @@ EXPORT_SYMBOL_GPL(input_ff_create);
  *
  * This function is only needed in error path as input core will
  * automatically free force feedback structures when device is
- * destroyed.
+ * unregistered or destroyed.
  */
 void input_ff_destroy(struct input_dev *dev)
 {
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index c321cdabd2141..852ec2d4ddcda 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -486,15 +486,7 @@ static void ml_ff_destroy(struct ff_device *ff)
 {
 	struct ml_device *ml = ff->private;
 
-	/*
-	 * Even though we stop all playing effects when tearing down
-	 * an input device (via input_device_flush() that calls into
-	 * input_ff_flush() that stops and erases all effects), we
-	 * do not actually stop the timer, and therefore we should
-	 * do it here.
-	 */
-	del_timer_sync(&ml->timer);
-
+	timer_shutdown_sync(&ml->timer);
 	kfree(ml->private);
 }
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 05366b82f722e..0220b913b9ac4 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2283,6 +2283,8 @@ static void __input_unregister_device(struct input_dev *dev)
 	mutex_unlock(&input_mutex);
 
 	device_del(&dev->dev);
+
+	input_ff_destroy(dev);
 }
 
 static void devm_input_device_unregister(struct device *dev, void *res)
-- 
2.53.0



