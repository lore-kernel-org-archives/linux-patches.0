Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061608;
	b=P8/8i1JuEjqHX0zMv1o0ot8vi56+76dPOpXvn69Sy9Hx6Yq8zUcL2qBQzl5Tqz0NJ26Z
	 BBiW5eBat5mAjnnClcsF2Dajd+dS8T6aev6KL7XO+G6QytOXSZ6yaPxpRsfXEUQcyTZcx
	 7ecVW6Bf3zR2oAs6CmzN8uV+BpsYQVxmE2faWBjUtHiiDVdlQjXkm4CFkSFhFc2wFijkc
	 Kl6BWsiN6cM/2PibFofGDuZbRVve6XfdswFZVWlJgq+ML5kerQCpC9VDf2Qq/KVWTFZR3
	 NbilOn0n5Re8IQTg34fM0vsy2WP2joLP0bg2iK//Jp94wsS8bi+60jFfehwPwy4ASKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wels78JTlUg1p6vdSKRpxSHXPx1NSsMmBkyJvWDKWno=;
	b=NHKbyPu7SYgABJZELM8GVFOlr50lhojJJp5vK9OYrdNjXp1tfGwSwSjvW+Vczl/3b/Rj
	 hELhyJIVue5v0YIb/ukK/fH9E+JtQh8yhpndOPoOyZ+cvhoL+O8aTN094WtghvHB70W7R
	 TQc9O8G9Qp4fuiE8obrM8eHZVt9RGSGSMstSWBGAIf/tYbAtcGQm65CgbbjCjOavehC2O
	 SB+eKMz4rAKrMeVOMSnz7b1DkB2M/8Skq4eungbd9hWkS+3ezUJM6vpXIuL+DenjCNUu+
	 n6uJngosqPpzOyChkJZOEgJUPcA5tjDwokM43G78m/px7WJMkb/qfXYz5VlL3RUPshA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfiKLY8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C274606A326;
	Sat,  7 Nov 2026 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfiKLY8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1211F0089F;
	Sat,  7 Nov 2026 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061608;
	bh=Wels78JTlUg1p6vdSKRpxSHXPx1NSsMmBkyJvWDKWno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfiKLY8rGlREHErgKMVTt+1ueB3MOU8hIBnCev3KSiKPHt1oy0nlukC0DPOJ/ZD9O
	 EVfUXwVQb8wIG8bS0F8WVhDsCMB2eAFRr9nBWXm0dy2nGX+TtOp3pTfYFv4ItJqXVH
	 dtARAshRdXwV0izrFplmOzzyDhl/goyryPi6EDEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0662/1536] media: rc: Ensure registered is cleared in error path
Date: Sat,  7 Nov 2026 08:44:38 -0500
Message-ID: <20261107135016.105009910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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


