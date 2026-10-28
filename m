Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216430;
	b=SZM2nUjqIQg/2FSceqIr0A6rpesZxldL7x0/ZsOkPm3zD1ZeS1p1Z6nLdNCMYQwAInyr
	 BShI6lQj3UoA0OJprNm5MtOhjAt+pGRm+2au+w1jI5jrunraeOPsANXRy4xvkxxe1fWes
	 BInn92WWJ7V7FS11rjCBBlmtXnyHI8Dn6oCgCmrtKVxJ8yAFJex9OFU/XVNrtJgVAIwJ4
	 YbdeKRrMc5icxL9DxqETgLiqia6iI1AQZm/MbTQUlWOC5JtziLYdqKx2xGtisrkaKBAZ0
	 P7mB6SWKeKQ3CZgrF3DObCIwFJ/3UlbShRgjzVueVBfc1Um/OOrj1O8r5xbuC4HuIdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZBfsk77rsQKFmgQI+6q1xM2k1LlK6LZIAtg9+uSL0U=;
	b=oq6e2LIOmbrtUeeQVu3t9cGRD8gmcY8h5OACsjkkDHK8N7uoABb1UCf1W5BM56omDusg
	 LYuVlsu/w1UAsVQlRS4+cWJW2rkR8q2ILak5Qc2YvruLW6I455Y7tqZZUdtpLyI+YGO7k
	 G2jUoBeMnQiAXBn7+vuYVhadj0nlDsbJXbCPfVc/pREiuBciiiMMnZutootF7taz4V40p
	 z3ExyFU1JMOesg4PQmQkXRjjLzJvh7/VkrqibO672tgrohDCZtjQDJ7xM2vwB/B0+rIRk
	 7OciOntuHlzO8Vx/cid/frRTBItF8gc7qp/3JTYdpwezO/6MCRE58fwC7c1K8uPfTQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ECnOnUW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4434606A321;
	Wed, 28 Oct 2026 19:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECnOnUW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DDC1F01825;
	Wed, 28 Oct 2026 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216429;
	bh=bZBfsk77rsQKFmgQI+6q1xM2k1LlK6LZIAtg9+uSL0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECnOnUW/ENhJyowrddn0KwEof2ND/O0droqRbOxZO5MxpD5zN5HJXrl9O4FQpg/Bo
	 BGC1JLVs0Bd9oTzvfo0Bxr/kpH00TKFvHuoglVOUglZXVsXQZZ8Oo1IMpUWiGM7u75
	 bMAQcaWnSDh/Vj4GkZTfAzlHn1BpVPBSn7dOwt9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1510/1887] HID: sony: clean up device list on probe failure
Date: Wed, 28 Oct 2026 18:00:06 +0100
Message-ID: <20261028170533.825689640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit 7c65699a3a311198a07659a614fe64d45924839e ]

sony_input_configured() adds some controllers to sony_device_list before
HID core registers their input devices. input_register_device() can fail
after the callback returns successfully. sony_probe() then observes that
HID_CLAIMED_INPUT is clear and unwinds, but only stops the HID hardware.
The devres-managed sony_sc is freed while its list node remains linked, so
the next matching controller traverses freed memory.

Initialize the list node and device ID to inactive states. Make list
removal idempotent and run the driver-private cleanup on every probe
failure path. This also makes a second cleanup safe when
sony_input_configured() already unwound a partial initialization before
sony_probe() handles the missing input claim.

Found by 0sec (https://0sec.ai) using automated source analysis;
verified against the HID input registration and probe unwind paths.

Fixes: 4f967f6d7374 ("HID: sony: Fix memory issue when connecting device using both Bluetooth and USB")
Cc: stable@vger.kernel.org
Reported-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://lore.kernel.org/linux-input/20260724143925.007D61F00A3A@smtp.kernel.org/
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 01745b5df2e4e..f1a861cb99edb 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2564,13 +2564,10 @@ static int sony_check_add_dev_list(struct sony_sc *sc)
 
 static void sony_remove_dev_list(struct sony_sc *sc)
 {
-	unsigned long flags;
+	guard(spinlock_irqsave)(&sony_dev_list_lock);
 
-	if (sc->list_node.next) {
-		spin_lock_irqsave(&sony_dev_list_lock, flags);
-		list_del(&(sc->list_node));
-		spin_unlock_irqrestore(&sony_dev_list_lock, flags);
-	}
+	if (!list_empty(&sc->list_node))
+		list_del_init(&sc->list_node);
 }
 
 static int sony_get_bt_devaddr(struct sony_sc *sc)
@@ -2736,6 +2733,13 @@ static inline void sony_cancel_work_sync(struct sony_sc *sc)
 	}
 }
 
+static void sony_cleanup(struct sony_sc *sc)
+{
+	sony_cancel_work_sync(sc);
+	sony_remove_dev_list(sc);
+	sony_release_device_id(sc);
+}
+
 static int sony_input_configured(struct hid_device *hdev,
 					struct hid_input *hidinput)
 {
@@ -2968,9 +2972,7 @@ static int sony_input_configured(struct hid_device *hdev,
 		device_remove_file(&sc->hdev->dev, &dev_attr_firmware_version);
 	if (sc->hw_version_created)
 		device_remove_file(&sc->hdev->dev, &dev_attr_hardware_version);
-	sony_cancel_work_sync(sc);
-	sony_remove_dev_list(sc);
-	sony_release_device_id(sc);
+	sony_cleanup(sc);
 	return ret;
 }
 
@@ -2996,6 +2998,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	spin_lock_init(&sc->lock);
+	INIT_LIST_HEAD(&sc->list_node);
+	sc->device_id = -1;
 
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
@@ -3024,6 +3028,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
+		sony_cleanup(sc);
 		return ret;
 	}
 
@@ -3075,7 +3080,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 err:
 	usb_free_urb(sc->ghl_urb);
-
+	sony_cleanup(sc);
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -3102,12 +3107,7 @@ static void sony_remove(struct hid_device *hdev)
 	if (sc->hw_version_created)
 		device_remove_file(&sc->hdev->dev, &dev_attr_hardware_version);
 
-	sony_cancel_work_sync(sc);
-
-	sony_remove_dev_list(sc);
-
-	sony_release_device_id(sc);
-
+	sony_cleanup(sc);
 	hid_hw_stop(hdev);
 }
 
-- 
2.53.0



