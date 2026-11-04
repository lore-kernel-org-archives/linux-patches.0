Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831507;
	b=JiO21wmBtv3Ox6ShJozzqBLjZwrOAtWGQtB1czwaqRO820ueXTrbmbxzOj2WepQgxPaX
	 mIW9eKFrjGbCGJ/M0H9utQM1ZIDHYD0QJxdoyhsBFo+BGz5/Yt/FPpEUROko1XRvoZTCQ
	 rARW2ztzX8uiyLjW2ySP2CA3VKtRLLh46WQ61Hzhk0F4BHE8mq33wdc6f4XCDBbUr628Y
	 glh4c+bXVqu5j3P/o+xPB8I3a64D4Av975QPTGBYY7FEbQt7KbLMzBP2laRIC3ZEstuAj
	 g1c+dmPhyFxxd0pgjZiqgCTJilHvw91Td3RFQOBofJo/gYIOZVo68zft0ZtxMOiDrWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vTNTABf/MgwPfSGxY+Qzklm4eg+YiD8Rk5hJJ74DiRk=;
	b=bh0gBYBnLeemEpiUceeakgk5hHhkjujVDhDB0qNrGUWjarR40qhVFDG7AXEr73eKijUE
	 XwpfRHZk8op3TGO3/xE92Ggcqn3LPiDUptbp55SIdoR6FmVldMjQ+Xlldasy8HbEwP1I1
	 q11jQGghsUi/7CVO/ZKwW/iE8bSR0HnPrg609Z3IP1/pC8C9Lv9tg6DH7wfS9GY9llUsT
	 +005EHl08ddeVW4kOyQvKRJaiIiwfuHwn4GTsNiHcPeiXuMAvbP4ZSibbJnoa8dhHEPKq
	 dr6aXt+zvdSqHHhJcpfXkzcDxk3sB1gtGL6AAV5e+27UeQq8rfQqgd1Y3kJk43AFv8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIBl3d4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C25606D80A;
	Wed,  4 Nov 2026 22:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIBl3d4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A91D1F00A02;
	Wed,  4 Nov 2026 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831506;
	bh=vTNTABf/MgwPfSGxY+Qzklm4eg+YiD8Rk5hJJ74DiRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIBl3d4j8ENVFidH4KL0T4OQ437/VCqN7hJyCtRPcwvnYOiisvMWzlU+zSnBKkj/x
	 FyXaqrfKZWLrV70qj1T7MSIhji1BQKVpDNuuyLAy21FH9M/UjlYfLtc6yRu53pGURX
	 HmehKiC1i5KV8YKr5Plvgm0rPGNhgiqTcM5bOVL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0744/1005] media: rc: Ensure registered is cleared in error path
Date: Wed,  4 Nov 2026 16:07:57 -0500
Message-ID: <20261104211104.307610334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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


