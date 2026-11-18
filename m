Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027204;
	b=4e2/Rg4Qm85Sv5TrmiN8WEoTuIx5ABPnaSV/4vhTp+uDCSSj16J7kt4QT/RSeLc9Z1gz
	 boph1VjG1EmroBknqTFQ5+Z/nbWeR0oL1hfFUVDGfpib80qVlheumiYVd8/86E5LJvfaf
	 YN8tjonrdDxh2Xo8WLaewIh6Qq2OBXKMvW9DWI8VXPTAxNBk5esdG60yuvWG68blJFY1o
	 leIMG6WyVaWPzpYEiS0DvMn2B616P4APzegQhwYKakqZJsgo0oCH7AJfM2/fgsYKZ7T4I
	 48WQo5RYCMops/wPboee0rKGUmzlkVUUe/083Uy7TprF96rVAMy+BrLmrYuqAU/RJ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fGObxRTEMubWJ3ZJou+deaMt4f8jq2Uc5jLnY7CrwMY=;
	b=R4QOuwG+kwVq3CEZ3Mc0HvVYN/F5ZsbNHwdDnc6gsHTRid8FcbMeTjHyqmX1yciNKfxJ
	 DEthuWt8wl7AtuQKFMT40t9ea1o8cfZDAOSfA5zU4KYcAaso2KSQ/JMbDn3t1FvMlXu4Z
	 9jvECEQLicb/6ulLvVYWoRC6C2wwYIA2N2ErEEHm1aoDe+gBPcr1vAZr7ebmUlclQSPb8
	 bji/bAccbWiWY/7x8911rQv7qFdXrsGhOmrbwOnD0UNLB4MGvAXMzSxEs7kym/Y2dmlHH
	 eDV3dz57ex5KDzU04D/yiIboD3R3gvQLZQ4otkK/MbkuHc4eUSefSPc/Bc1K8nBae0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7HcS682;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA470606A320;
	Wed, 18 Nov 2026 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7HcS682
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAFD1F000C5;
	Wed, 18 Nov 2026 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027204;
	bh=fGObxRTEMubWJ3ZJou+deaMt4f8jq2Uc5jLnY7CrwMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7HcS6822Wt2QQuNzttN0pk/UGxaQpXgpDn8Ut+dMQ8FKtpHa0F7uqi0pXnzRM85z
	 wXabeKZfHu6mHBVUBtPnP4GUo4hArqoPDWISt39hm15HF3/XFqEpWzFmwPflHhQoxP
	 7I06xnIkc04KuEdOwWZJfY23XZP43Vp14nHYP0H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1690/2151] platform: cznic: turris-omnia-mcu: stop button emulation producers
Date: Wed, 18 Nov 2026 15:57:05 +0100
Message-ID: <20261118150223.390554812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 7f0ada4fa6062..9b43563c8ab0f 100644
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



