Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214547;
	b=qKPewzflAgfjZiqweMWIW4MxMiYR//0eqELaYK46jjDjUgDepv8WTEAJ4gk+/nmhwUPA
	 LaO8dhh70btapQQ1ryl+NAg6NZ3JsyvPlA3iElO4Kr2Rr1BcWCdoIZEkns5XMeJY8n5/n
	 8pxMvH6Y6bLUiC3w/7wZuRE+lWpZHqpivp+HdZFVeswGiq8iqpQqINbQgh/BBc17Zsrza
	 ULnDCDHDh4jJGG5tYpsb9sYBIWXN3lzouI867ngRYhK2a7R5nW1yFzWG8hIIhNO6Y7NfK
	 ADHw3qDv6R9/nSfH3+pkh0OYiI9GhIOMo5ubbaMSoYPue3BMyp++r1rSvg/ADCYhPXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zPW2vMw9fSiKgsIlro81csbwQtT1tCMx4mx31hsNyqM=;
	b=eeOWxd3P1VMpR2ZF8rY4lUcyjLtDdvZ7zePFC6zQ/RiUp+RAhs4osjYH71odFJKn207d
	 V2h18LAEKDtB8cEh897QKgfnVF4DJwPjBVIdjvF/Nyc+BJ0wvmYaZ8SKo3cWxKvCfjsQO
	 kDXP585F/YwA6355s+XfpoBZqvkPHV0uJ58kvszPK4gwIE0hpoQCzxnAh8hutJUXiwf8Y
	 oWXzBfPGWhrdP0TF0vppdkByvMe+P0L30NVPNPOLuIgweb/w7RNQObSzjZ2vJdWT5I5B4
	 jGbtx4ly/DywSCUyQYXYwchVKcRyPwLCE0uP1t3BAWZiJYffvCXXD8lW+Ob5v8NTd7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MHpmmDjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BBF60A263D;
	Wed, 28 Oct 2026 19:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MHpmmDjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EA01F01825;
	Wed, 28 Oct 2026 19:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214546;
	bh=zPW2vMw9fSiKgsIlro81csbwQtT1tCMx4mx31hsNyqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHpmmDjXAQ0qht3xSfSdKo6wVktHLreaiwZFEOM5t6MdT9Z3YCNDL7gE5yYen+eql
	 JTkot22Po8LbE39bvhD2exg5tCQqBJ5C3vusmsPIfL14r4pmzGWWwaNOmYn4z6KUb2
	 QgXodHXch6N076MF4+6Irvp9E6hdjixIqE5MHNkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0895/1887] can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing data
Date: Wed, 28 Oct 2026 17:49:51 +0100
Message-ID: <20261028170519.786450809@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 395d988f93861101ec89d0dd9e3b876ae9392a5b ]

The URB received in gs_usb_receive_bulk_callback() contains a struct
gs_host_frame. The length of the data after the header depends on the
gs_host_frame hf::flags and the active device features (e.g. time
stamping).

Introduce a new function gs_usb_get_minimum_length() and check that we have
at least received the required amount of data before accessing it. Only
copy the data to that skb that has actually been received.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://patch.msgid.link/20251114-gs_usb-fix-usb-callbacks-v1-3-a29b42eacada@pengutronix.de
[mkl: rename gs_usb_get_minimum_length() -> +gs_usb_get_minimum_rx_length()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 59 +++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index d0fe0e5e9021f..1f021366afab5 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -251,6 +251,11 @@ struct canfd_quirk {
 	u8 quirk;
 } __packed;
 
+/* struct gs_host_frame::echo_id == GS_HOST_FRAME_ECHO_ID_RX indicates
+ * a regular RX'ed CAN frame
+ */
+#define GS_HOST_FRAME_ECHO_ID_RX 0xffffffff
+
 struct gs_host_frame {
 	struct_group(header,
 		u32 echo_id;
@@ -523,6 +528,37 @@ static void gs_usb_set_timestamp(struct gs_can *dev, struct sk_buff *skb,
 	return;
 }
 
+static unsigned int
+gs_usb_get_minimum_rx_length(const struct gs_can *dev, const struct gs_host_frame *hf,
+			     unsigned int *data_length_p)
+{
+	unsigned int minimum_length, data_length = 0;
+
+	if (hf->flags & GS_CAN_FLAG_FD) {
+		if (hf->echo_id == GS_HOST_FRAME_ECHO_ID_RX)
+			data_length = can_fd_dlc2len(hf->can_dlc);
+
+		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+			/* timestamp follows data field of max size */
+			minimum_length = struct_size(hf, canfd_ts, 1);
+		else
+			minimum_length = sizeof(hf->header) + data_length;
+	} else {
+		if (hf->echo_id == GS_HOST_FRAME_ECHO_ID_RX &&
+		    !(hf->can_id & cpu_to_le32(CAN_RTR_FLAG)))
+			data_length = can_cc_dlc2len(hf->can_dlc);
+
+		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+			/* timestamp follows data field of max size */
+			minimum_length = struct_size(hf, classic_can_ts, 1);
+		else
+			minimum_length = sizeof(hf->header) + data_length;
+	}
+
+	*data_length_p = data_length;
+	return minimum_length;
+}
+
 static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *parent = urb->context;
@@ -531,7 +567,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
-	unsigned int minimum_length;
+	unsigned int minimum_length, data_length;
 	struct gs_tx_context *txc;
 	struct can_frame *cf;
 	struct canfd_frame *cfd;
@@ -574,20 +610,33 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	if (!netif_running(netdev))
 		goto resubmit_urb;
 
-	if (hf->echo_id == -1) { /* normal rx */
+	minimum_length = gs_usb_get_minimum_rx_length(dev, hf, &data_length);
+	if (urb->actual_length < minimum_length) {
+		stats->rx_errors++;
+		stats->rx_length_errors++;
+
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "short read (actual_length=%u, minimum_length=%u)\n",
+				   urb->actual_length, minimum_length);
+
+		goto resubmit_urb;
+	}
+
+	if (hf->echo_id == GS_HOST_FRAME_ECHO_ID_RX) { /* normal rx */
 		if (hf->flags & GS_CAN_FLAG_FD) {
 			skb = alloc_canfd_skb(dev->netdev, &cfd);
 			if (!skb)
 				goto resubmit_urb;
 
 			cfd->can_id = le32_to_cpu(hf->can_id);
-			cfd->len = can_fd_dlc2len(hf->can_dlc);
+			cfd->len = data_length;
 			if (hf->flags & GS_CAN_FLAG_BRS)
 				cfd->flags |= CANFD_BRS;
 			if (hf->flags & GS_CAN_FLAG_ESI)
 				cfd->flags |= CANFD_ESI;
 
-			memcpy(cfd->data, hf->canfd->data, cfd->len);
+			memcpy(cfd->data, hf->canfd->data, data_length);
 		} else {
 			skb = alloc_can_skb(dev->netdev, &cf);
 			if (!skb)
@@ -596,7 +645,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			cf->can_id = le32_to_cpu(hf->can_id);
 			can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);
 
-			memcpy(cf->data, hf->classic_can->data, 8);
+			memcpy(cf->data, hf->classic_can->data, data_length);
 
 			/* ERROR frames tell us information about the controller */
 			if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
-- 
2.53.0



