Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F051FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57381C433C8;
	Tue,  1 Aug 2023 09:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883237;
	bh=QsYuCVHwNhX7htojaEBKLZ0mhsd7dkS5VMUMjDCGC4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tu+tQNgFk8xnbRzrKT9Fda+xv75OfGrF7SlgELYBPp+Q+GoylqlUpNzhZ6sgIkhAs
	 DAcKYdHK8h6AsNwCYWokDxvuofZCCFLBxl1g7jxPxR5Om80h6L5h2T/QNH2jLVZcxV
	 SDsVxPOXQkK7Wg9HBwFpTObV5s9pOaRXr3zJ6ZP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.4 165/239] usb: misc: ehset: fix wrong if condition
Date: Tue,  1 Aug 2023 11:20:29 +0200
Message-ID: <20230801091931.581270473@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

commit 7f2327666a9080e428166964e37548b0168cd5e9 upstream.

A negative number from ret means the host controller had failed to send
usb message and 0 means succeed. Therefore, the if logic is wrong here
and this patch will fix it.

Fixes: f2b42379c576 ("usb: misc: ehset: Rework test mode entry")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20230705095231.457860-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/ehset.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/ehset.c
+++ b/drivers/usb/misc/ehset.c
@@ -77,7 +77,7 @@ static int ehset_probe(struct usb_interf
 	switch (test_pid) {
 	case TEST_SE0_NAK_PID:
 		ret = ehset_prepare_port_for_testing(hub_udev, portnum);
-		if (!ret)
+		if (ret < 0)
 			break;
 		ret = usb_control_msg_send(hub_udev, 0, USB_REQ_SET_FEATURE,
 					   USB_RT_PORT, USB_PORT_FEAT_TEST,
@@ -86,7 +86,7 @@ static int ehset_probe(struct usb_interf
 		break;
 	case TEST_J_PID:
 		ret = ehset_prepare_port_for_testing(hub_udev, portnum);
-		if (!ret)
+		if (ret < 0)
 			break;
 		ret = usb_control_msg_send(hub_udev, 0, USB_REQ_SET_FEATURE,
 					   USB_RT_PORT, USB_PORT_FEAT_TEST,
@@ -95,7 +95,7 @@ static int ehset_probe(struct usb_interf
 		break;
 	case TEST_K_PID:
 		ret = ehset_prepare_port_for_testing(hub_udev, portnum);
-		if (!ret)
+		if (ret < 0)
 			break;
 		ret = usb_control_msg_send(hub_udev, 0, USB_REQ_SET_FEATURE,
 					   USB_RT_PORT, USB_PORT_FEAT_TEST,
@@ -104,7 +104,7 @@ static int ehset_probe(struct usb_interf
 		break;
 	case TEST_PACKET_PID:
 		ret = ehset_prepare_port_for_testing(hub_udev, portnum);
-		if (!ret)
+		if (ret < 0)
 			break;
 		ret = usb_control_msg_send(hub_udev, 0, USB_REQ_SET_FEATURE,
 					   USB_RT_PORT, USB_PORT_FEAT_TEST,


