Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032235;
	b=IVKVluMBiTmyfBgcd3yUwiVPg0AVErJw7F+qoDOOktehnzrSJpuzefSo/ZVZufR1wX2C
	 F4PJU2DORA3vkJpRdE4mRVAHGA+c24Zza1oMkxOkgRA08pHttuvbK1E4G9+JeFm4jyNLa
	 tKHXrDUFPSwXCqyR6KfJXERr4cJgqwaoUgTd/XfsQuItKYMOlobfCUpzDNsv2x2n+Z0jo
	 GSVCo51lj5NaWfpsRQ+dRniXQ+/Co4Pta6DRd/vHaASj3gl5vCKVAAuDu7YC8WbvdwUSF
	 EugKvHbdVNOYIafBqQ/Z1geHi1f0v56I2Z24rcSQSga/zw2QMmfS9XIlO2MYzf3rW1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zmu2XYCGyr5s8mYOk2ksjWWveOHRicPYB09TQtGlx4Y=;
	b=5g9krZLaZ21cIJNerwDLvx8alq/wmXpDrnilR/RERhLfgeYxt4vskDBzHFYWrvjP1O3+
	 zN6OOedyZD5c5uoeUlG9SY/XMv6SiAXzF/xgEDYj+Q0KDV0Nac3KoZW2TZSM0EygajR5q
	 m0ZxoYEgPbkOnGLzrtemUQmoNTqBYUNhru3hoVl2P4Uv0rKPlpg2qzWSsoJXRNqddjisQ
	 xz/15ZvQAz9nG4qZQ0Bxei2G9IqeiHVnWb8T2+8KgeMxOY6WX8RxU1mQyJh4yFJUjEYyp
	 tFsdNkEybBM4A3mds4XuupVwLTUY6lf0WgG4n1Y+aeGtKIorf8WljYjChRjhXUZJYOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAso0p1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DD606A325;
	Wed, 18 Nov 2026 20:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAso0p1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83441F000C4;
	Wed, 18 Nov 2026 20:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032235;
	bh=zmu2XYCGyr5s8mYOk2ksjWWveOHRicPYB09TQtGlx4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAso0p1tywz0vIor18KtXio6R30aYSHWZLnRradQ30jJGaId3phAe4LG3SqqFA91C
	 xfTFOA3Tg0vqQO8K2PQBxwrkpy63KjfnegMMIe65PjKj6RKJ57TUrf6kInmD/9MJ8v
	 LEiCkINlf849rpumwg1qc98m3sbgtMO3Z5ZJrIB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1341/1756] platform: cznic: turris-omnia-mcu: stop button emulation producers
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150102.727503430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 0045cd6b8ab2319e9d8de46e5e329cdc35ce6d05 ]

The legacy MCU IRQ thread can requeue button-release emulation work
after its managed cleanup has canceled it. Since the IRQ is still active
at that point, the newly queued work can outlive device teardown and
access freed MCU state.

Use disable_delayed_work_sync() to prevent further queueing and drain
the worker before the IRQ action is released. Keep the parent IRQ active
while the worker completes. devm_add_action_or_reset() also drains the
work if action registration fails.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: dfa556e45ae9 ("platform: cznic: turris-omnia-mcu: Add support for MCU connected GPIOs")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://lore.kernel.org/r/20261016013918.3492835-1-mhun512@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/cznic/turris-omnia-mcu-gpio.c    | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/cznic/turris-omnia-mcu-gpio.c b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
index 88e208d458820..13cf9d0b02aab 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-gpio.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
@@ -11,7 +11,6 @@
 #include <linux/bug.h>
 #include <linux/cleanup.h>
 #include <linux/device.h>
-#include <linux/devm-helpers.h>
 #include <linux/errno.h>
 #include <linux/gpio/driver.h>
 #include <linux/i2c.h>
@@ -831,6 +830,18 @@ static void button_release_emul_fn(struct work_struct *work)
 	generic_handle_irq_safe(mcu->client->irq);
 }
 
+static void omnia_disable_button_release_work(void *data)
+{
+	struct delayed_work *work = data;
+
+	/*
+	 * The IRQ thread may requeue this work while the IRQ remains active.
+	 * Disable and drain it before releasing the IRQ action and the MCU
+	 * state used by the worker.
+	 */
+	disable_delayed_work_sync(work);
+}
+
 static void
 fill_int_from_sts(unsigned long *rising, unsigned long *falling,
 		  unsigned long rising_sts, unsigned long falling_sts,
@@ -1072,21 +1083,9 @@ int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu)
 		return dev_err_probe(dev, err, "Cannot request IRQ\n");
 
 	if (!new_api) {
-		/*
-		 * The button_release_emul_work has to be initialized before the
-		 * thread is requested, and on driver remove it needs to be
-		 * canceled before the thread is freed. Therefore we can't use
-		 * devm_delayed_work_autocancel() directly, because the order
-		 *   devm_delayed_work_autocancel();
-		 *   devm_request_threaded_irq();
-		 * would cause improper release order:
-		 *   free_irq();
-		 *   cancel_delayed_work_sync();
-		 * Instead we first initialize the work above, and only now
-		 * after IRQ is requested we add the work devm action.
-		 */
-		err = devm_add_action(dev, devm_delayed_work_drop,
-				      &mcu->button_release_emul_work);
+		err = devm_add_action_or_reset(dev,
+					       omnia_disable_button_release_work,
+					       &mcu->button_release_emul_work);
 		if (err)
 			return err;
 	}
-- 
2.53.0



