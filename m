Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020803;
	b=W+zvVh0/XwXUhkdHSGTRfKH/V8bYbPx/wo9uCXYvEW9IORl3a5NK4MCxoxRRYavp1SXk
	 MxyrKDI6/6Akqzdn5wzFkhs1CPxQ+0jm0lPnEXxL8MmLjYYC0FuW2VNA2gaHxLMzcI31e
	 2LBBSdAKA4Ep+ME6yESIJ4D6EV0BACaurtPo7r091H/QmFTt+yDsTZL5zEEUslhRncX7m
	 DJIYRr5METL0Z/IyuBqaDI+PUyLEH84VoL7An5uWfCBZOItgz9iluq4hu9F01F5A0wKUt
	 aaP9bXS0l0iEQmAJqUwUGs07TCk/KkoXNjRI2vhipmZlOPk2NnrYux6A26aZAVufqVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k7F3HfTQr7fKAtezZKD2cU1JwwLzZ0UWRSMPLPRGzBM=;
	b=4VYLTu/ydo4kYq6XVOCBBBT6uYxb0YL94fdI+qsEzLC/bdJj1B7yw4ad+Zc0D1rODxsJ
	 8CDtN2+V1cFCFwhmYRuYO1xoWR0bRm362uA0u6DXere3HojkCP0IKltxhPE13AhtyAyPS
	 m5C0m65EkGYyNskl7ljp+gvvRWoV8YOTzWkSV0EYfxbwFRXu8Vcc3ZjOEXI4kerC8KEyS
	 y18Jq0PvzP2Ff/49P+JS//5exCZaoS/e85xR+X0+CVCCZeIhrcmhYFF4LampikATtJyUA
	 zRGkpwYsOV4+0eWDx3O4mwajUXoz8u/JR56pXNnS3Ya9KOM4pS5CmJ80tzIGe1LvdZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHvlddhG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B694606A320;
	Wed, 18 Nov 2026 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHvlddhG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472481F000C4;
	Wed, 18 Nov 2026 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020802;
	bh=k7F3HfTQr7fKAtezZKD2cU1JwwLzZ0UWRSMPLPRGzBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHvlddhGdbZVSF3JFZI/t4r258+BQNHUzh5ZWjmti0tq1pr/XRLBd3wq3Sps/a/nt
	 e/HXDmeh3SAcOD/e9MOwINs0xaAjeUNQ8T4yuxvpJrG9/RT+xcNx1U7J6iUCUfXeIr
	 Hy+/MJU1QWEQSJfdl1lzhqCJzNcHZq52sMp3St2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2054/2651] platform: cznic: turris-omnia-mcu: stop button emulation producers
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150400.013022064@linuxfoundation.org>
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
index 4e430d6c3fc4b..8f43bfa923738 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-gpio.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
@@ -11,7 +11,6 @@
 #include <linux/bug.h>
 #include <linux/cleanup.h>
 #include <linux/device.h>
-#include <linux/devm-helpers.h>
 #include <linux/errno.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
@@ -841,6 +840,18 @@ static void button_release_emul_fn(struct work_struct *work)
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
@@ -1082,21 +1093,9 @@ int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu)
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



