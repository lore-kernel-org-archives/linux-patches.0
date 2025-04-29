Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96B52459EA;
	Tue, 29 Apr 2025 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947275; cv=none; b=V+zMf5Hu1feO/Ku30r+zbG5JkxiBpcp1AAU4bZPrh4a3SIDBqbIO70EaVRRFp580k5OA0+sDUv6cZKXZevk1KwQ3OJnwuLwnmpZQLxQ2FWx25qcoDx1tTms9f9InbKlfKjYxrHM4kcv7CEBXXtiRrmnxF50FDDN4JwOipQ8FNXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947275; c=relaxed/simple;
	bh=XPJ/6vTqhLrJmGmddTQ1ioZ3ZP06OW7bCUBcazK6aWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFZXl3HDN54/wDy5Qxyoc7Gp01hRV8mB+/zi7vXXa2AZDlKw/wiOp0LA/OknC5fWrvu+jYvRmL4cvtNmwP6QanFBtx7Y9yirxcisORsWlE4sgJy6NBPmn0f8QnIKdf0qxxBdn7ElNAs0JcBBdujo9lGd2kBAf8gzRv4d0IkiQrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBZa9E+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBZa9E+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C36BC4CEE3;
	Tue, 29 Apr 2025 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947275;
	bh=XPJ/6vTqhLrJmGmddTQ1ioZ3ZP06OW7bCUBcazK6aWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBZa9E+1Uki8FxO6TQDEN7ikIDxRj2wOw6AoKbNX435iMhlP0jzUI+p1OsTLZuMHC
	 0cZK/aSLtnumqTV/b2rDgD0l3TMYK6fmj7uIABhjEpmenrvNGz/NXm/YE0xWHByfjK
	 zzOhWTERNgQ0khqCW4zST/oLaTH8A5YfKBWazLtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/286] media: streamzap: less chatter
Date: Tue, 29 Apr 2025 18:41:43 +0200
Message-ID: <20250429161116.145659376@linuxfoundation.org>
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

[ Upstream commit 35088717ad24140b6ab0ec00ef357709be607526 ]

Remove superfluous messages which add no information.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f656cfbc7a29 ("media: streamzap: fix race between device disconnection and urb callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index b6391ad383143..e862a866b9b0f 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -26,7 +26,6 @@
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
 
-#define DRIVER_VERSION	"1.61"
 #define DRIVER_NAME	"streamzap"
 #define DRIVER_DESC	"Streamzap Remote Control driver"
 
@@ -281,10 +280,8 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	int ret;
 
 	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
-	if (!rdev) {
-		dev_err(dev, "remote dev allocation failed\n");
+	if (!rdev)
 		goto out;
-	}
 
 	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
 	strlcat(sz->phys, "/input0", sizeof(sz->phys));
@@ -324,7 +321,6 @@ static int streamzap_probe(struct usb_interface *intf,
 	struct usb_device *usbdev = interface_to_usbdev(intf);
 	struct usb_host_interface *iface_host;
 	struct streamzap_ir *sz = NULL;
-	char buf[63], name[128] = "";
 	int retval = -ENOMEM;
 	int pipe, maxp;
 
@@ -383,17 +379,6 @@ static int streamzap_probe(struct usb_interface *intf,
 	sz->dev = &intf->dev;
 	sz->buf_in_len = maxp;
 
-	if (usbdev->descriptor.iManufacturer
-	    && usb_string(usbdev, usbdev->descriptor.iManufacturer,
-			  buf, sizeof(buf)) > 0)
-		strscpy(name, buf, sizeof(name));
-
-	if (usbdev->descriptor.iProduct
-	    && usb_string(usbdev, usbdev->descriptor.iProduct,
-			  buf, sizeof(buf)) > 0)
-		snprintf(name + strlen(name), sizeof(name) - strlen(name),
-			 " %s", buf);
-
 	sz->rdev = streamzap_init_rc_dev(sz);
 	if (!sz->rdev)
 		goto rc_dev_fail;
@@ -424,9 +409,6 @@ static int streamzap_probe(struct usb_interface *intf,
 	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
 		dev_err(sz->dev, "urb submit failed\n");
 
-	dev_info(sz->dev, "Registered %s on usb%d:%d\n", name,
-		 usbdev->bus->busnum, usbdev->devnum);
-
 	return 0;
 
 rc_dev_fail:
-- 
2.39.5



