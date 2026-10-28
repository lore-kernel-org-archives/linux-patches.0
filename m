Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212769;
	b=y5HGQsyMe44HLULUI/XHAMuqZWeYD4+aDYAssS8ZF+zwK6eoU7GVqk+7n1k4U1hhEuE4
	 abdTEwU6JQ7IfioK6a6awqIxH7qsIQhM8LbmWIHi2zT0U7bksMUmUEqLA8YMtUIwqBEeR
	 9EsMeGWXaYb95KrWJ8RwpcC9CxisF5sea0mSCtt56GNe6zJOZrRtqJAa6ycuzuLLD5AS/
	 3d6vewxncFfhH3cCEDk5k0Hpdk92EDtbguQKU2b4iMelez+mDVm54cxaXOfHfZayNNFDI
	 1soSDZv9oCz1P0xUeVTZZio8O+SzemwokXMkqzB0A39ZIIX34/BhLOVD04cGq0HXNgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9s8/W62TWcOCUksZeAVvfC7sF7Z1w7CV66Q/gLxDA5g=;
	b=vCDTGd5SbXliKZjUjriBSjlYLZ/FIix3xQ22oA7kFYiIYGs02mZVOsiD+qA2PWOPF4kN
	 D42mrVDdIO+OvTpE9qr63wVtRNYTXVxIUyBts7ffP9zPXMIucl6JNQNU5bvPdsxFhpLGU
	 m/mBc5xff2zFGiZ9buA+z8sNEW6D9lYxo+6I6HrqQh8yXGcS6L93D6jJwKjoIuWOw7goX
	 RFUKCfshLgndUDD2JXzfyTxdOghnLDy7iu0gjEqelT34eAmO9ECKpSdVcN0zw1FpqZFZ6
	 mAVo9RjV1u/5NyISbThk2otl3QWvTRHR4CeTrBCYKzaeXrTgk0bU6bfA8bLNSFPW7AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOBfVHhY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8DB606A31A;
	Wed, 28 Oct 2026 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOBfVHhY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6221F01825;
	Wed, 28 Oct 2026 18:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212769;
	bh=9s8/W62TWcOCUksZeAVvfC7sF7Z1w7CV66Q/gLxDA5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOBfVHhYupGX8w7wVLUULHSn0nmL9EnxKI/ll9vxzd5JdOlJOPC3II1pG2pbrccPS
	 o87ZinF+3dptVxAU4Ugou8qLN5HcLt1BAIz50i9BlRS4ruVGXH+Tl/qUs76EPbV3Q/
	 EA5wj5vHM70Y/5sdNDFZQLQrkmjwh7i/6cEFWMjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Fluhr <mathieu.fluhr@gmail.com>,
	stable <stable@kernel.org>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 0270/1887] usb: hub: use shorter 120ms post resume hold for SS root hubs
Date: Wed, 28 Oct 2026 17:39:26 +0100
Message-ID: <20261028170505.373778250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit 29480b05e6e226594dc11ccf2a036fbd5cdd0e42 upstream.

Holding a USB3 hub PM runtime reference for 200ms at hub resume triggers
an AMD platform issue.  Users running Android adb report crashes after
adb has been polling and waking up the USB subsystem once a second for
some time.  Vendors are working on a solution.  Disabling USB runtime PM
is one way to prevent this issue, but it is also proven that reducing the
hold time to 120ms in resume also mitigates it.  See Link for more
details.

Reducing the hold time to 120ms for the USB3 roothub is in itself a valid
change and optimization, as the current 200ms is excessive: a root hub
has no upstream suspended hub whose wake propagation needs to be
accounted for, but still need some time for USB3 link training to
complete.

Keep the 200ms hold for external hubs that commit 8f5b7e2bec1c
("usb: hub: fix detection of high tier USB3 devices behind suspended
hubs") is intended for.

Reported-by: Mathieu Fluhr <mathieu.fluhr@gmail.com>
Link: https://lore.kernel.org/all/CAPyJwA_D9qw0T72f8zwM1yKjP+To=maVANbcdsWM7yRmbBxYvw@mail.gmail.com/
Cc: stable <stable@kernel.org>
Fixes: 8f5b7e2bec1c ("usb: hub: fix detection of high tier USB3 devices behind suspended hubs")
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260903112903.542719-1-lovekeshsolanki00@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -69,8 +69,11 @@
 /*
  * Give SS hubs 200ms time after wake to train downstream links before
  * assuming no port activity and allowing hub to runtime suspend back.
+ * Root hubs have no upstream hub whose wake propagation needs to be
+ * accounted for, so they need less time, use 120ms for them.
  */
 #define USB_SS_PORT_U0_WAKE_TIME	200  /* ms */
+#define USB_SS_RH_PORT_U0_WAKE_TIME     120 /* ms */
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -1332,7 +1335,9 @@ static void hub_activate(struct usb_hub
 
 		queue_delayed_work(system_power_efficient_wq,
 				   &hub->post_resume_work,
-				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
+				   msecs_to_jiffies(hdev->parent ?
+				USB_SS_PORT_U0_WAKE_TIME :
+				USB_SS_RH_PORT_U0_WAKE_TIME));
 		return;
 	}
 


