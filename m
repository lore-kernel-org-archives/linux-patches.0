Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705634;
	b=ohv3ryIfHmvYZdAGPspVFCEMbE9WgZhrozLpDSFLa/0MGaPhcDxTj5tLmkQfNIJmTFmq
	 3yveXITLsTjuE5iaz6FoMw0rRQRtmoLlEHx/qwxW969BREeUE1Q3XCKst/OPZEGP40XyK
	 ZVgW4TNGGWZnrRETQUOaQg1kU/WVL6cFcU+P2JMHk8uV5ForoEXB3p9DgbFKUknwROG77
	 mvFaf93bfHlROc56/KrENClp9kgdTLSCaydidYhSCWO/6HfXyN/XCfj19UIQn2MAZYCdU
	 qVwpRDK1HwawQsP1u1a2cjV5DzZNTyZ5Bd8WE3bF03/K+L3c3Vrkeqy2W//GjnnAqyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aT7mzjo3gEsH1Oq4ZqSHbUfW0R6wNa0gMkmHfbxO54I=;
	b=JZ5NZkYN+TcZICDFN/f+ADCKkBd8ZEKhg+pP2YhKpX2RL2SOeK9PGGQk4YkODqEN24ov
	 LM/ESygixm0tKXGyyVLaWn9+lSO9zI8mCfWtrKJ4yNWwkc5YiEqH2VWH/XWWfdjL8j7Ts
	 Ev6z8jZ7slijXuaP56p3qQyoDmozPejTnWEcxx22afu9fQCWSTs7wqGLc+lzyJhyrU89k
	 UZH8rMsVAWHe9S8Oiy8ZuKBZRRnY8u/ZlwbkTtoq545hNseiJFXnWVkAAotkYzdSbRrui
	 V3F/BNgTgzJIH72nsG4oAFw2qWoZwuhUsLuHI7n8GeziTD5ofivOZzdH3x1oXhllBSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbUdOkf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61CE606A334;
	Thu, 26 Nov 2026 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbUdOkf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E031F000C0;
	Thu, 26 Nov 2026 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705634;
	bh=aT7mzjo3gEsH1Oq4ZqSHbUfW0R6wNa0gMkmHfbxO54I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbUdOkf7LMlKjbX+R2HHPAjgrq4R9Chyryol5iB2PnpfRWBZaYHm3JOdkWwUlr+DF
	 kEnp2vJuDTk/IAdNLkJYkAjaxpO6O0GRLuCsEK3C9xaoULt4p+u0FzRA3qnShJL+rb
	 SG2otJNwtUIE/Icxv0qMKvhFJ/Ro8r6CYcOBwHzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.15 262/319] comedi: vmk80xx: report failed transfers of the K8061
Date: Thu, 26 Nov 2026 15:40:30 +0100
Message-ID: <20261126144012.659906036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,7 +152,7 @@ struct vmk80xx_private {
 	enum vmk80xx_model model;
 };
 
-static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
+static int vmk80xx_do_bulk_msg(struct comedi_device *dev)
 {
 	struct vmk80xx_private *devpriv = dev->private;
 	struct usb_device *usb = comedi_to_usb_dev(dev);
@@ -162,6 +162,7 @@ static void vmk80xx_do_bulk_msg(struct c
 	unsigned int rx_pipe;
 	size_t tx_size;
 	size_t rx_size;
+	int ret;
 
 	tx_addr = devpriv->ep_tx->bEndpointAddress;
 	rx_addr = devpriv->ep_rx->bEndpointAddress;
@@ -170,11 +171,13 @@ static void vmk80xx_do_bulk_msg(struct c
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
@@ -184,10 +187,8 @@ static int vmk80xx_read_packet(struct co
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
@@ -205,10 +206,8 @@ static int vmk80xx_write_packet(struct c
 
 	devpriv->usb_tx_buf[0] = cmd;
 
-	if (devpriv->model == VMK8061_MODEL) {
-		vmk80xx_do_bulk_msg(dev);
-		return 0;
-	}
+	if (devpriv->model == VMK8061_MODEL)
+		return vmk80xx_do_bulk_msg(dev);
 
 	ep = devpriv->ep_tx;
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);


