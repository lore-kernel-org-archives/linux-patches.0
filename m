Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035180;
	b=I89Rpz0oL+yiWcvnnMLEfyJjpnUyeux3tMU7bwItnsoeiEVS95fR5Vcw05gS8sb18Bxx
	 ydKsDTx6mbezcLGBZuliGzMLWlPTqAqqCnkprBBAGsb0anyI77t0BGwE4oEkY2kVwkUwN
	 NRbCvZefYm9BPR4kQkndF/UwOSeYAMD2lUAwsyw5leG2oBmkOR1mXgC7tq6Ia6O6bkQgU
	 IRtDuLBPQdaBxnVGF/ta17BNwt+yLZAE7JNiRZe5zuTyDkToG7TBYweH3SUk8zgpL65aj
	 F9FynVHkIrq5Lq3LysKeI1qzFWLG+fgnaTKdey2h0yQ0gWNq9zOydKEovlCdacIEjHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pgbPupLkn/FIUIYwp0NvZ4hPRersy3rLnC5qx3ztUj0=;
	b=rJKPBJaH9iz7GG7M9LCX/etKWXlMrRGvuwI4bbo5vuQLHzGO5PvlTNoFWEYR1WwDL9DZ
	 520KzD344ZLyEDnNvzfiZSIEjA5vu55mIZ0/Gqlm3yH4sVBFE/b4uAUFLLHrWsup3z8gQ
	 Qx1/6HzEdUogWkr6/+zCtncFBc/F528xgV5rdpNEGnIyCB5e1Bff0XcyLSDol/PMLjGjn
	 Fd2WTFGQ5s4UdiaVUFaHJl+KzOKZD7J+ivutXy5xbzPNYHThnGVryHkGTWmK+ZIlhpBCJ
	 pKi154t8jbhBuybqaVe0wxB0kXo8Hr+4PBnP/5yHQ8xf/7pZy7BMugww0/ej4czIvWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wKH33Mn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC7C606A31C;
	Wed, 18 Nov 2026 20:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wKH33Mn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6331F000C4;
	Wed, 18 Nov 2026 20:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035179;
	bh=pgbPupLkn/FIUIYwp0NvZ4hPRersy3rLnC5qx3ztUj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wKH33MnBVY+sDwI7UYzbJdNJV9CjRYksRxRzw0FUofb8eufAmTBZtOvhYxJ/zrJc
	 HZTpTE7Pm3HKXrbNz7l1BL//+e7FB2/je7k9joyjFrwMAqTXnWlHbNJVpCCGVXY6Ao
	 lJsuMlWUtQs3doI9vINgXdyiKSvBWZL9lxcH0F4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0632/3318] media: rc: Ensure registered is cleared in error path
Date: Wed, 18 Nov 2026 15:20:54 +0100
Message-ID: <20261118150336.848234035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 37efd09ba2c62e46e3a3a793025c186f8cd1a417 upstream.

If rc_register_device() fails, ensure that registered is not set to true.
If lirc_register() succeeded, then userspace could have an open file
descriptor open. This leads to a use-after-free.

lirc_unregister() must be called with registered = false, else there is a
possibility that an fd is open and polling, which would never return
POLLERR unless registered is false.

Note that registered must be changed under dev->lock, many functions
read registered under lock (e.g. lirc_ioctl).

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1929,7 +1929,8 @@ int rc_register_device(struct rc_dev *de
 			goto out_raw;
 	}
 
-	dev->registered = true;
+	scoped_guard(mutex, &dev->lock)
+		dev->registered = true;
 
 	rc = device_add(&dev->dev);
 	if (rc)
@@ -1949,7 +1950,7 @@ int rc_register_device(struct rc_dev *de
 	if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
 		rc = lirc_register(dev);
 		if (rc < 0)
-			goto out_dev;
+			goto out_lirc;
 	}
 
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
@@ -1972,11 +1973,18 @@ int rc_register_device(struct rc_dev *de
 out_rx:
 	rc_free_rx_device(dev);
 out_lirc:
-	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
+	scoped_guard(mutex, &dev->lock)
+		dev->registered = false;
+
+	if (device_is_registered(&dev->lirc_dev))
 		lirc_unregister(dev);
-out_dev:
 	device_del(&dev->dev);
+	/* registered already cleared above */
+	goto out_free_table;
 out_rx_free:
+	scoped_guard(mutex, &dev->lock)
+		dev->registered = false;
+out_free_table:
 	ir_free_table(&dev->rc_map);
 out_raw:
 	ir_raw_event_free(dev);


