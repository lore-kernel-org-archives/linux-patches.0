Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFBE82C60;
	Tue, 29 Apr 2025 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947279; cv=none; b=gJTKwbAh0mIPVnC5LMtbhovUaTKXSjuSFsfpuMDWPIgqgF6yrKOQcLtxQTMmFg7G6j4tsWIyb2ZboMH3mjWmHECp2m4yYsL8pa4Kzw2d67R8n/nNn9MkoY5ioIxglmg9KPB4ibgo3ZulN1jW/2KwfZC6iDjtZIeDyXn+GNE5T38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947279; c=relaxed/simple;
	bh=U3mlQMTjDdzEbGJJw+rSGq+8f1VrnrbG9b+yQUOhxyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S63nMswSLJ2YUQWySF/3yYUDIoyf0kQ54K7oS5PhVvT3OfD/00syber3col3aKNjg4X/gzgFmZtgdxFII9PMqRfaT6xCPJWcx9sxTylS0kFi8N212kTQ5bVYi50smNhFCKBv0Nb504l16xZKWRdqx9bKv8Xg5F/ztpSAvzGcfSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9RTr9M0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9RTr9M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143E0C4CEE3;
	Tue, 29 Apr 2025 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947278;
	bh=U3mlQMTjDdzEbGJJw+rSGq+8f1VrnrbG9b+yQUOhxyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9RTr9M0aEC/7VSwWT4mWJazn4CLUj+GbmGIs1EBK3nlU5CqHrdIUjk6aYLAChm+z
	 AZXspQNq8CAFLftnLIzY8xbrPHrQcUx7AXmDOeklgWCKYET6IB8UkiDEbALuJOc++X
	 pbkGUxuUi2inm69g2CrfO7KKnYB1y7ezUz+tMd4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/286] media: streamzap: remove unused struct members
Date: Tue, 29 Apr 2025 18:41:44 +0200
Message-ID: <20250429161116.185103686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 4df69e46c352df9bdbe859824da33428a3ce8a1d ]

These struct members do not serve any purpose.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f656cfbc7a29 ("media: streamzap: fix race between device disconnection and urb callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 37 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index e862a866b9b0f..cd994e27362eb 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -66,9 +66,6 @@ struct streamzap_ir {
 	struct device *dev;
 
 	/* usb */
-	struct usb_device	*usbdev;
-	struct usb_interface	*interface;
-	struct usb_endpoint_descriptor *endpoint;
 	struct urb		*urb_in;
 
 	/* buffer & dma */
@@ -85,7 +82,6 @@ struct streamzap_ir {
 	/* start time of signal; necessary for gap tracking */
 	ktime_t			signal_last;
 	ktime_t			signal_start;
-	bool			timeout_enabled;
 
 	char			phys[64];
 };
@@ -211,8 +207,7 @@ static void sz_process_ir_data(struct streamzap_ir *sz, int len)
 					.duration = sz->rdev->timeout
 				};
 				sz->idle = true;
-				if (sz->timeout_enabled)
-					sz_push(sz, rawir);
+				sz_push(sz, rawir);
 			} else {
 				sz_push_full_space(sz, sz->buf_in[i]);
 			}
@@ -273,7 +268,8 @@ static void streamzap_callback(struct urb *urb)
 	return;
 }
 
-static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
+static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz,
+					    struct usb_device *usbdev)
 {
 	struct rc_dev *rdev;
 	struct device *dev = sz->dev;
@@ -283,12 +279,12 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	if (!rdev)
 		goto out;
 
-	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
+	usb_make_path(usbdev, sz->phys, sizeof(sz->phys));
 	strlcat(sz->phys, "/input0", sizeof(sz->phys));
 
 	rdev->device_name = "Streamzap PC Remote Infrared Receiver";
 	rdev->input_phys = sz->phys;
-	usb_to_input_id(sz->usbdev, &rdev->input_id);
+	usb_to_input_id(usbdev, &rdev->input_id);
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
@@ -319,6 +315,7 @@ static int streamzap_probe(struct usb_interface *intf,
 			   const struct usb_device_id *id)
 {
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *endpoint;
 	struct usb_host_interface *iface_host;
 	struct streamzap_ir *sz = NULL;
 	int retval = -ENOMEM;
@@ -329,9 +326,6 @@ static int streamzap_probe(struct usb_interface *intf,
 	if (!sz)
 		return -ENOMEM;
 
-	sz->usbdev = usbdev;
-	sz->interface = intf;
-
 	/* Check to ensure endpoint information matches requirements */
 	iface_host = intf->cur_altsetting;
 
@@ -342,22 +336,22 @@ static int streamzap_probe(struct usb_interface *intf,
 		goto free_sz;
 	}
 
-	sz->endpoint = &(iface_host->endpoint[0].desc);
-	if (!usb_endpoint_dir_in(sz->endpoint)) {
+	endpoint = &iface_host->endpoint[0].desc;
+	if (!usb_endpoint_dir_in(endpoint)) {
 		dev_err(&intf->dev, "%s: endpoint doesn't match input device 02%02x\n",
-			__func__, sz->endpoint->bEndpointAddress);
+			__func__, endpoint->bEndpointAddress);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
-	if (!usb_endpoint_xfer_int(sz->endpoint)) {
+	if (!usb_endpoint_xfer_int(endpoint)) {
 		dev_err(&intf->dev, "%s: endpoint attributes don't match xfer 02%02x\n",
-			__func__, sz->endpoint->bmAttributes);
+			__func__, endpoint->bmAttributes);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
-	pipe = usb_rcvintpipe(usbdev, sz->endpoint->bEndpointAddress);
+	pipe = usb_rcvintpipe(usbdev, endpoint->bEndpointAddress);
 	maxp = usb_maxpacket(usbdev, pipe, usb_pipeout(pipe));
 
 	if (maxp == 0) {
@@ -379,14 +373,13 @@ static int streamzap_probe(struct usb_interface *intf,
 	sz->dev = &intf->dev;
 	sz->buf_in_len = maxp;
 
-	sz->rdev = streamzap_init_rc_dev(sz);
+	sz->rdev = streamzap_init_rc_dev(sz, usbdev);
 	if (!sz->rdev)
 		goto rc_dev_fail;
 
 	sz->idle = true;
 	sz->decoder_state = PulseSpace;
 	/* FIXME: don't yet have a way to set this */
-	sz->timeout_enabled = true;
 	sz->rdev->timeout = SZ_TIMEOUT * SZ_RESOLUTION;
 	#if 0
 	/* not yet supported, depends on patches from maxim */
@@ -399,8 +392,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	/* Complete final initialisations */
 	usb_fill_int_urb(sz->urb_in, usbdev, pipe, sz->buf_in,
-			 maxp, (usb_complete_t)streamzap_callback,
-			 sz, sz->endpoint->bInterval);
+			 maxp, streamzap_callback, sz, endpoint->bInterval);
 	sz->urb_in->transfer_dma = sz->dma_in;
 	sz->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -441,7 +433,6 @@ static void streamzap_disconnect(struct usb_interface *interface)
 	if (!sz)
 		return;
 
-	sz->usbdev = NULL;
 	rc_unregister_device(sz->rdev);
 	usb_kill_urb(sz->urb_in);
 	usb_free_urb(sz->urb_in);
-- 
2.39.5



