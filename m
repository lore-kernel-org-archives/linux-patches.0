Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E6625334D;
	Tue, 29 Apr 2025 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949239; cv=none; b=Y34yEZdTcBvWBDSFTmhg38fsmXaQ+TA2FpJCrV1++Vlimt0VtOoPGXYLD5/CPSHSUTSkSZM9WGZJLEq5gW/Y1TmPqKA1gXP8G2mftadj4yBuhRWt/JE2DvlwBcXrNZ3U5yqI1hdTTiBPp8+BWDaPxwYEtOQf24X3m4xO5XGOMBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949239; c=relaxed/simple;
	bh=oJe3wzJbcYpWk58fynZKC3T1zvgLMVHlOI2afqdavFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGsqJ2f6nBjZKPEOBNyq8A+PtvuATHKwOX54HkeDa+VIX6NF1G/u2VolW5i86WXY7GrN7oSufcu19959GSA+yEmc4ZZP8v4NDDshYLIjpVLoVe9kgLcXzH9Vl64frSSn3rcY5o7RodYA5K08aqXZemi2vghyMXvo7PIx7KH1SsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgtPOuiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgtPOuiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C274CC4CEE3;
	Tue, 29 Apr 2025 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949239;
	bh=oJe3wzJbcYpWk58fynZKC3T1zvgLMVHlOI2afqdavFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgtPOuiQmTdqH60fxc1omyaRoffkapnFOUbiN6gK8hdqr3Blrxl2wmO6IEdixtBpB
	 Q2LyFkxqTIzith/CgplUIFWDecCFtj5bez4zeKx4PFM4Ktu0OotfFtqJ1LkiK7YvYX
	 rdDik5V7OV4Zhw8TLyPBgpsINlVOdHU6VOhHxhQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/373] media: streamzap: less chatter
Date: Tue, 29 Apr 2025 18:42:14 +0200
Message-ID: <20250429161133.695496320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9ef6260d2dfd2..aff4dfb99a827 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -26,7 +26,6 @@
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
 
-#define DRIVER_VERSION	"1.61"
 #define DRIVER_NAME	"streamzap"
 #define DRIVER_DESC	"Streamzap Remote Control driver"
 
@@ -279,10 +278,8 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	int ret;
 
 	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
-	if (!rdev) {
-		dev_err(dev, "remote dev allocation failed\n");
+	if (!rdev)
 		goto out;
-	}
 
 	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
 	strlcat(sz->phys, "/input0", sizeof(sz->phys));
@@ -322,7 +319,6 @@ static int streamzap_probe(struct usb_interface *intf,
 	struct usb_device *usbdev = interface_to_usbdev(intf);
 	struct usb_host_interface *iface_host;
 	struct streamzap_ir *sz = NULL;
-	char buf[63], name[128] = "";
 	int retval = -ENOMEM;
 	int pipe, maxp;
 
@@ -381,17 +377,6 @@ static int streamzap_probe(struct usb_interface *intf,
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
@@ -422,9 +407,6 @@ static int streamzap_probe(struct usb_interface *intf,
 	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
 		dev_err(sz->dev, "urb submit failed\n");
 
-	dev_info(sz->dev, "Registered %s on usb%d:%d\n", name,
-		 usbdev->bus->busnum, usbdev->devnum);
-
 	return 0;
 
 rc_dev_fail:
-- 
2.39.5



