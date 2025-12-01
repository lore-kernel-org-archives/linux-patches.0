Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5A1263C91;
	Mon,  1 Dec 2025 11:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588823; cv=none; b=Q7L+v3XeiOZcFrStAe4Waj5ilBq/QmCoGTLFtnwiVLcbFbASwz4/rkccTJmrDn34LWJXidiAfgMcOidB3LU8E2biXylYyUFYyfexRNBvApG+WbEOXgR9QahrAxGL3/9GT45y2AGsWPII77riCbrqJMzfEnBoR20CjUueH2fgfmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588823; c=relaxed/simple;
	bh=AnLtmN+pOKBj69H3SC1TfFIfE6FqnYnxOXijtvVKcwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cauadM5knR8X1A0812NRQ55V/F4PtPX0G6zB0sF225fj4wtj/0hH6CATnBIHW6c7+jr2O45+JZkyFDj/0vVlUCuo2YBjPkXbDfC0214pQ1LpBgij3rS03DvNGltXXtTLeO+Vi15jYwoc0MvEJxTtXBLh87P0vhrEl7KHVgyj7lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7lxNx1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7lxNx1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF8CC4CEF1;
	Mon,  1 Dec 2025 11:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588822;
	bh=AnLtmN+pOKBj69H3SC1TfFIfE6FqnYnxOXijtvVKcwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7lxNx1zw5Tkrgbqc/aTKnx0JMK+VEhOj4m1aUSz/KaI2hH5mzQv1Fw2XlGs853FP
	 dOOLIcLzbuCKSMCyOzB6Ya4DQZO2JGQNmSJTjWoWBngolZEWMYnSaJk35E+M7gs75X
	 WwebP95YrZbVksY3Kh/lxuJUTzrdUsVJ2acH9/WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Syrjala <syrjala@sci.fi>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Henk Vergonet <Henk.Vergonet@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/187] Input: remove third argument of usb_maxpacket()
Date: Mon,  1 Dec 2025 12:24:50 +0100
Message-ID: <20251201112247.785557523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 948bf187694fc1f4c20cf972fa18b1a6fb3d7603 ]

The third argument of usb_maxpacket(): in_out has been deprecated
because it could be derived from the second argument (e.g. using
usb_pipeout(pipe)).

N.B. function usb_maxpacket() was made variadic to accommodate the
transition from the old prototype with three arguments to the new one
with only two arguments (so that no renaming is needed). The variadic
argument is to be removed once all users of usb_maxpacket() get
migrated.

CC: Ville Syrjala <syrjala@sci.fi>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henk Vergonet <Henk.Vergonet@gmail.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20220317035514.6378-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 69aeb5073123 ("Input: pegasus-notetaker - fix potential out-of-bounds access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ati_remote2.c         |    2 +-
 drivers/input/misc/cm109.c               |    2 +-
 drivers/input/misc/powermate.c           |    2 +-
 drivers/input/misc/yealink.c             |    2 +-
 drivers/input/tablet/acecad.c            |    2 +-
 drivers/input/tablet/pegasus_notetaker.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -639,7 +639,7 @@ static int ati_remote2_urb_init(struct a
 			return -ENOMEM;
 
 		pipe = usb_rcvintpipe(udev, ar2->ep[i]->bEndpointAddress);
-		maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
+		maxp = usb_maxpacket(udev, pipe);
 		maxp = maxp > 4 ? 4 : maxp;
 
 		usb_fill_int_urb(ar2->urb[i], udev, pipe, ar2->buf[i], maxp,
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -749,7 +749,7 @@ static int cm109_usb_probe(struct usb_in
 
 	/* get a handle to the interrupt data pipe */
 	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
-	ret = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
+	ret = usb_maxpacket(udev, pipe);
 	if (ret != USB_PKT_LEN)
 		dev_err(&intf->dev, "invalid payload size %d, expected %d\n",
 			ret, USB_PKT_LEN);
--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -374,7 +374,7 @@ static int powermate_probe(struct usb_in
 
 	/* get a handle to the interrupt data pipe */
 	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
-	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
+	maxp = usb_maxpacket(udev, pipe);
 
 	if (maxp < POWERMATE_PAYLOAD_SIZE_MIN || maxp > POWERMATE_PAYLOAD_SIZE_MAX) {
 		printk(KERN_WARNING "powermate: Expected payload of %d--%d bytes, found %d bytes!\n",
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -905,7 +905,7 @@ static int usb_probe(struct usb_interfac
 
 	/* get a handle to the interrupt data pipe */
 	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
-	ret = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
+	ret = usb_maxpacket(udev, pipe);
 	if (ret != USB_PKT_LEN)
 		dev_err(&intf->dev, "invalid payload size %d, expected %zd\n",
 			ret, USB_PKT_LEN);
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -130,7 +130,7 @@ static int usb_acecad_probe(struct usb_i
 		return -ENODEV;
 
 	pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
-	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
+	maxp = usb_maxpacket(dev, pipe);
 
 	acecad = kzalloc(sizeof(struct usb_acecad), GFP_KERNEL);
 	input_dev = input_allocate_device();
--- a/drivers/input/tablet/pegasus_notetaker.c
+++ b/drivers/input/tablet/pegasus_notetaker.c
@@ -296,7 +296,7 @@ static int pegasus_probe(struct usb_inte
 	pegasus->intf = intf;
 
 	pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
-	pegasus->data_len = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
+	pegasus->data_len = usb_maxpacket(dev, pipe);
 
 	pegasus->data = usb_alloc_coherent(dev, pegasus->data_len, GFP_KERNEL,
 					   &pegasus->data_dma);


