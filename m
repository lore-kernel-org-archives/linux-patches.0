Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623655;
	b=dwwCSegI7j5+p2sg90p0TRQArTIcZ69z5YBrDifkq0Rh8VFwsbC/nD73AxpeFgtKbrMa
	 Q/je0UFsQ0G4/DpeujkHxVQpT897kZyVa+U+KVaykb/kDXPgYqkaYCRe0ZE2RSrfEhz1s
	 NrZ3RGbsUMMVshXSRvP0rvk/b0zdKzzeRzvv7z3CuAPm3CzgcSPoUlM4+GxT6GJIxX9pm
	 5p5RYHtSqDUj2WXRSRd76tTu8zjYflp3pF9NqFn2o85O4/J93zPMC43jP9Y63dC/6DGV8
	 h2uBAL/mQhB1sEy7I0nBdzpy1woF0gqTdheBYmWERUIO74LoTYN9hKM1VZB9rleh8zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mPMuFEStvp8nrX4bjxrZDvHCWqoAT7RVTXu8ic4RQGQ=;
	b=ybHpgmZnpYbz7kVGWlkNq938izNgxak4RY5K9cvCGb+sJjgZpmYOqhYvdGOmyZnJUI2L
	 O6Ox9UqWOgwFL1xTZINLvci9N7oe0kh7TcV5bTSkDcL9Df8fX7jfVToS91nOgufIMGv4H
	 bxjLKDhhl2Yo1jSlKlXnb5C14xt1pndIQn2zBYXy9FLLq7YZeUijvaGVXhaW3fG7fh7uX
	 c3aa4vjH1h7PKEiqIOdKYthSMjQuyE3sxsQUG8VOCx6Ii1XiXHbYw6EKGKnyMpDQLQqwK
	 y+JsZTva7bwhwUwj4FoxB11ZByWRG2kMNBP86e8Nj45VS43VvAjaxqmZhB0UTPtNOeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+28CjeA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB05606A32D;
	Wed, 25 Nov 2026 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+28CjeA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7DB1F000D8;
	Wed, 25 Nov 2026 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623655;
	bh=mPMuFEStvp8nrX4bjxrZDvHCWqoAT7RVTXu8ic4RQGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+28CjeAHVTdQcVaEMEuVYRpHjZ6EefimzwnjEnD2X51QiOIxK5BaC0DXjgVRI5IF
	 pvzeioLv+61c4JxpI++8UDR39XjrBP3KmWE/+Wu7Eq/FOvzzJZcAwgl0qkC0om7YFl
	 wQQbY1lFGOkkc4E0VDlDxPS31jG9qw4cWkBbLzNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 885/990] comedi: vmk80xx: report failed transfers of the K8061
Date: Wed, 25 Nov 2026 15:37:32 +0100
Message-ID: <20261125143842.743874963@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 92fa93505576188acc22c5de1999db9a1c70c09b upstream.

For the K8061 board vmk80xx_read_packet() and vmk80xx_write_packet() call
vmk80xx_do_bulk_msg(), which ignores the result of its two bulk transfers,
and return 0. After a timeout, a stall or an unplug the instruction
handlers therefore go on and hand the old content of usb_rx_buf to user
space as a fresh sample (analog and digital inputs, counters, PWM and
output read-back), and writes to the outputs are reported as done.

All callers check the result already, because the K8055 branch of the two
functions returns that of usb_interrupt_msg(). Return the error of the
bulk transfers as well, and don't wait for an answer to a command that
could not be sent.

Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-comedi-v1-5-1899771ee15b@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/vmk80xx.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -151,7 +151,7 @@ struct vmk80xx_private {
 	enum vmk80xx_model model;
 };
 
-static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
+static int vmk80xx_do_bulk_msg(struct comedi_device *dev)
 {
 	struct vmk80xx_private *devpriv = dev->private;
 	struct usb_device *usb = comedi_to_usb_dev(dev);
@@ -161,6 +161,7 @@ static void vmk80xx_do_bulk_msg(struct c
 	unsigned int rx_pipe;
 	size_t tx_size;
 	size_t rx_size;
+	int ret;
 
 	tx_addr = devpriv->ep_tx->bEndpointAddress;
 	rx_addr = devpriv->ep_rx->bEndpointAddress;
@@ -169,11 +170,13 @@ static void vmk80xx_do_bulk_msg(struct c
 	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
 	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
 
-	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf, tx_size, NULL,
-		     PACKET_TIMEOUT);
+	ret = usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf, tx_size, NULL,
+			   PACKET_TIMEOUT);
+	if (ret)
+		return ret;
 
-	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL,
-		     PACKET_TIMEOUT);
+	return usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL,
+			    PACKET_TIMEOUT);
 }
 
 static int vmk80xx_read_packet(struct comedi_device *dev)
@@ -183,10 +186,8 @@ static int vmk80xx_read_packet(struct co
 	struct usb_endpoint_descriptor *ep;
 	unsigned int pipe;
 
-	if (devpriv->model == VMK8061_MODEL) {
-		vmk80xx_do_bulk_msg(dev);
-		return 0;
-	}
+	if (devpriv->model == VMK8061_MODEL)
+		return vmk80xx_do_bulk_msg(dev);
 
 	ep = devpriv->ep_rx;
 	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
@@ -204,10 +205,8 @@ static int vmk80xx_write_packet(struct c
 
 	devpriv->usb_tx_buf[0] = cmd;
 
-	if (devpriv->model == VMK8061_MODEL) {
-		vmk80xx_do_bulk_msg(dev);
-		return 0;
-	}
+	if (devpriv->model == VMK8061_MODEL)
+		return vmk80xx_do_bulk_msg(dev);
 
 	ep = devpriv->ep_tx;
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);


