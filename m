Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212806;
	b=CsIY/Sbv4bDHfLmabNvfSWt+HNms3wyZHEJGLGujWKYRhe8CM9du5espD1akRoyzbHUR
	 Kqo/uhYLrypaIYgaZhwHmAd0uM5c3jIIOIoRfuBCAYf1JbsZWE+2xAjjtZFhGxdOrmbVt
	 KFNfsqtRpWMdUWQFtbv0+6kfcUUcHQfLBPNlZRp3B2bFcp8tfm2LXHul2SIirup/XwZls
	 3BpxdB9S03WLCH/Uo4i6APLRRkvoGtoKBuu0yUzOfPlASrbGqqH6Fl0DHMNkDFFQcqoWg
	 S6WcB2DNCfCicFcvs67cPpyuC76aUAUcon5CwVETZ8yjEKzMtz3d7c51dUGBrlbC4IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xAUYlzakDLTIdEOIa94jCvNEWncLpPiY1ErEZhdIw1c=;
	b=Is9gvguHqcF7yNBZ9bAscvqay/C0wO8vi5G+/9DkvRhOeNqBsUWnCqZVh30NTbIvyiBi
	 VQB9J1md7E0D2/r+IPgYAiQTxCXOlrJ0rNN0SWAb/XffO0ZSk46oj7nm1LRnD1SI0hCLu
	 Jl3QjD08xuK08/MdwCPZJeV3iZ1JnhnwPSh7pMi7/RP52szgnu7rvsgrTA/9WIgg2Snd3
	 3Gd75Ulu47ebCkOwzuaWMM7dwL4J9tphhxM72z40cHn0L9dsllNlGASDqWViUBOwDl0hW
	 d4p+nvCkpvXNnD1iBp4iELoykKmm3jPBCTTqk+lQzKE6WK4ZePcoBXI7z4VIXo9trGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVtSlEhn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45676606A31A;
	Wed, 28 Oct 2026 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVtSlEhn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922191F01825;
	Wed, 28 Oct 2026 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212806;
	bh=xAUYlzakDLTIdEOIa94jCvNEWncLpPiY1ErEZhdIw1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVtSlEhnH6Z8Ejwfx0dy/ruSAmaE4qRv4w/fLG2Af4PImMD0quS0iis2cHLU4T4mo
	 b3Cq3lasH0U62ZES9f7axZzu9anvhmLt8GEgD1s6gpiB8JZl9mhEkovQ52O8rLJJJd
	 rlimA+rif3MkX+kNzkHfoDWEjDx1SHHq0pMd+gxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hui Peng <benquike@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0282/1887] usb: core: clear both ep_in and ep_out for non-ep0 control endpoints
Date: Wed, 28 Oct 2026 17:39:38 +0100
Message-ID: <20261028170505.645936356@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

commit 0e8baa78d872f2db440d8b9ded946ab8dceb89eb upstream.

In usb_enable_endpoint(), non-zero control endpoints (where
usb_endpoint_xfer_control(&ep->desc) is true) populate both
dev->ep_in[epnum] and dev->ep_out[epnum] with the same struct
usb_host_endpoint pointer.

However, usb_disable_endpoint() only clears either dev->ep_out[epnum] or
dev->ep_in[epnum] depending on the direction bit of epaddr when
reset_hardware is set, leaving the opposite direction's array slot
pointing to the disabled/freed endpoint.

Clear both dev->ep_out[epnum] and dev->ep_in[epnum] when disabling a
non-ep0 control endpoint with reset_hardware set, and update the
function kerneldoc accordingly.

Tested in QEMU against Linux 7.3.0-rc3 using dummy_hcd and raw-gadget to
enumerate a USB device with a non-zero control endpoint
(bEndpointAddress 0x01, bmAttributes USB_ENDPOINT_XFER_CONTROL),
verifying that both dev->ep_in[1] and dev->ep_out[1] are cleared when
the interface is disabled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260920231702.110963-1-benquike@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/message.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1331,7 +1331,8 @@ static void remove_intf_ep_devs(struct u
  *
  * Disables the endpoint for URB submission and nukes all pending URBs.
  * If @reset_hardware is set then also deallocates hcd/hardware state
- * for the endpoint.
+ * for the endpoint (clearing both ep_in and ep_out pointers for
+ * bidirectional non-ep0 control endpoints).
  */
 void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
 		bool reset_hardware)
@@ -1352,6 +1353,11 @@ void usb_disable_endpoint(struct usb_dev
 			dev->ep_in[epnum] = NULL;
 	}
 	if (ep) {
+		if (reset_hardware && epnum != 0 &&
+		    usb_endpoint_xfer_control(&ep->desc)) {
+			dev->ep_out[epnum] = NULL;
+			dev->ep_in[epnum] = NULL;
+		}
 		ep->enabled = 0;
 		usb_hcd_flush_endpoint(dev, ep);
 		if (reset_hardware)


