Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210959;
	b=1NHX/XYdAgJOsjGpWApsXkhkCmwNND2Thcc0CPD7iKS/E8JeoVqjtDhD4FMNB36M/CpL
	 y9thuxHQy1FeGWAj51ICZWyQOBoEntVlBkC6zxVk9iPynFpugvg3R0esLmBoae9jHQK8b
	 EMTnsn9P5lnSoPcMlDd1dx6fWPvhI9Udr2OVEGxVzWvKAuBRzBIFURr/GTwzh5o+7wxGN
	 7AbDeVU2llEldVvu2gVTWZ3wc+Nh1joQuRSySv4Kc0FdPPH0WF6dPde7d3BORIhm5eFhM
	 11lUpR+jRYUcyAs/F130CwXDlbLR2siCRbNGvTvOk4U+hXkzbOkDBx5MZfeb0NYVovQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IeONskHq/Htz7VDUskedKTohiF9/TsRn7i2K6Ajsy6g=;
	b=nJ/pRjT9RBsLBv6u2PumYuGmu1PnS3v+5JWoR6xZoLYwS1B6geB5SKStSVcGUZzv5fm8
	 s678S1bVxb4sOKEVbuCICCxERw4M1P2diLDWfJh+/qwU+kdAWPqCTEqRUgBRQ6NAVls+Z
	 gOBPOE5TRey7Ar3cvKpNjR/JwVfbJxGUO3+jX8DANfHzOgcZElSCy2IODCzku69qbza5i
	 98yhqOZ2YUbK99a2Mgfsn2PW3sFOGh5/rMtgFBWuhyW8pf9JCTXfBG8escbohYBTKm6om
	 5skFAHff9mDKxBumIcsJ2FhQ0SnltpPfhi6v33uFzhIpaXKsXDka8NZADG5PxiWuXnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBdiJ+71;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BC9606A31D;
	Wed, 28 Oct 2026 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBdiJ+71
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7FD1F01825;
	Wed, 28 Oct 2026 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210958;
	bh=IeONskHq/Htz7VDUskedKTohiF9/TsRn7i2K6Ajsy6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBdiJ+71NitFMoFA9non2GAX6bXNyAJJjetjyYTqtntog8Sb4YUhn2Z3GmzzxOWx6
	 9Hj3up5tfgEbinnuA80ETaBemu3Fb/vj08z2kpioXgwIRyV5X3rEviXYesEMZWvFpF
	 HhIme52lqLQWR0X1MXkSJ2bN482EL2thVdXw6sQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Nazarewicz?= <mina86@mina86.com>
Subject: [PATCH 5.15 208/571] usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC
Date: Wed, 28 Oct 2026 17:55:55 +0100
Message-ID: <20261028170012.938941228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

commit 9cd072788c76595529eb38f42bf94d23852f8534 upstream.

When user space sets up FunctionFS with only full-speed descriptors
(e.g., flags = FUNCTIONFS_HAS_FS_DESC) and the gadget operates at a
higher speed (such as USB_SPEED_HIGH or USB_SPEED_SUPER),
config_ep_by_speed() detects that the function lacks descriptors for
the current speed, logs a warning, and falls back to full-speed
descriptors. The endpoint is then successfully enabled via
usb_ep_enable(), and epfile->ep becomes valid.

However, when user space subsequently issues the FUNCTIONFS_ENDPOINT_DESC
ioctl to query the endpoint descriptor, ffs_epfile_ioctl() selects the
descriptor index solely based on gadget->speed:

	switch (epfile->ffs->gadget->speed) {
	case USB_SPEED_SUPER:
	case USB_SPEED_SUPER_PLUS:
		desc_idx = 2;
		break;
	case USB_SPEED_HIGH:
		desc_idx = 1;
		break;
	default:
		desc_idx = 0;
	}
	desc = epfile->ep->descs[desc_idx];
	memcpy(&desc1, desc, desc->bLength);

Because user space only supplied full-speed descriptors,
epfile->ep->descs[1] is NULL. Dereferencing desc->bLength triggers an
immediate kernel NULL pointer dereference panic.

Fix this by falling back through lower speed descriptors if the current
speed descriptor was not supplied, matching the fallback logic in
config_ep_by_speed() and historical f_fs behavior. If still missing,
fall back to epfile->ep->ep->desc (the active descriptor), and return
-EINVAL safely if no valid descriptor is found. In addition, mark desc
as const to match struct usb_ep::desc and avoid discarding qualifiers.

Fixes: c559a3534109 ("usb: gadget: f_fs: add ioctl returning ep descriptor")
Cc: stable@kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Acked-by: Michał Nazarewicz <mina86@mina86.com>
Link: https://patch.msgid.link/20260918005438.81263-2-ndaugoing@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1351,8 +1351,9 @@ static long ffs_epfile_ioctl(struct file
 		break;
 	case FUNCTIONFS_ENDPOINT_DESC:
 	{
+		const struct usb_endpoint_descriptor *desc;
+		struct usb_endpoint_descriptor desc1;
 		int desc_idx;
-		struct usb_endpoint_descriptor desc1, *desc;
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
@@ -1366,7 +1367,17 @@ static long ffs_epfile_ioctl(struct file
 			desc_idx = 0;
 		}
 
-		desc = epfile->ep->descs[desc_idx];
+		do {
+			desc = epfile->ep->descs[desc_idx];
+		} while (!desc && --desc_idx >= 0);
+
+		if (!desc)
+			desc = epfile->ep->ep->desc;
+		if (!desc) {
+			ret = -EINVAL;
+			break;
+		}
+
 		memcpy(&desc1, desc, desc->bLength);
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);


