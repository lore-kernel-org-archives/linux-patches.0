Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626076;
	b=kCNXFkOLsWZKn3yXmWKAu0WzTBH0C7qFPTiQ9Pg64VVev9nPKcny9kXmXakPEWf8n6Kc
	 9GMMU4vfEJfPqvOrKbweGHsaYtGSxZumtjg/N/UbgZGuHd0F2TYwZYVoNFAzFJBxWNdtv
	 cGpj7RaFAPkDIxYpFmfhR493etsBrC3+lu4dklxiUcwNcDCxjDQl8H13ypUvm6V9N5zWw
	 9oDNdnsY9pxL0zyTTGNpJ8j4bdw6NDVPHYocT3dw6ALpuhFcf9wCnITd/BydxosO+GrJp
	 ca2+5WnxHEiQ4NVx+HIXjvtaSSVicy8bhN0OS/MlwmIFinyAx6Onm4PjrVYQU28grdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SI7t3SIZofJteqfu6NQSF5Q7Ql8Wbf9iMCXgdt5FwjY=;
	b=AGIkjqIjQnLySOvmEd7Pd6BuApq4wLXUYQ2vtoqfzJF8qN2z4Ib76mWnnnfGWGo6c/AC
	 ySgrFN+d/Vc7aGCvUTeMEYAt+Skd2Cz7E5Ci+Rtx6d0gl1PS+q/7ncoi4aG5TgIiI2BZs
	 tmTpzyzLexbN+lWjVDsT0iMrhg+by4yd4tgzJ4gXMEaKfLUyDV2v7+GOnWRSC9Pc+Dozw
	 tt92Ph0Wms+x/ygGxEDvBmV4qIWLBnDdubsJAcP/AmuTW1CLVFtZmuunvo4m8/TT2Wy2P
	 pC1MsJLAzVDjq1OAzfd0amjwLWISYJmkjLPltlha3W3hA3GgAwJaLR9O5AHaQ+p/Vbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYykZiuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B15606A321;
	Wed, 25 Nov 2026 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYykZiuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B347C1F000C0;
	Wed, 25 Nov 2026 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626076;
	bh=SI7t3SIZofJteqfu6NQSF5Q7Ql8Wbf9iMCXgdt5FwjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYykZiuS+n6BOa43dmu/FgAZvBhy2uritPxth9WcekRQU+co49fv/SSlMQCZ0CFYW
	 rzN0kPZ7o0O9pxmcV0DqIDzVAk/LstsjGxzArQXhjq44zSGLTzescaMM4S2CXTOBJ3
	 RWFD/zWqmXfpM9ovDjbSIWGarDETVtN+xOJfZ0xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 724/816] comedi: vmk80xx: report failed transfers of the K8061
Date: Wed, 25 Nov 2026 15:37:52 +0100
Message-ID: <20261125143905.937060329@linuxfoundation.org>
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


