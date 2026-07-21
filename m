Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968E823C368;
	Tue, 21 Jul 2026 20:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665253; cv=none; b=LD/ecAz+6FlLYXdRfw+Z1TwaAM7jANXT4GHBQV6WHY7GUBX/SnB9KARq8N5ohxlOtXmQuOIlcSWQEq3R4wtrUrQchC7RL/OjJKLo5x+oR6KcUabkp9cUVpaiaocc9j+m1liZBCvkLegdkrTmEnl/ODm5Q1j6g3ldhH7vBqUcuvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665253; c=relaxed/simple;
	bh=4L0Z3CJPnzKYuKi/wkusvNMOWHyPx4nqT1b2ywCKrjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LU3cPXvIqMhO7wR5BZxQaxxIEzGEVrLbeiyrYg9hFe78iY7DGaMLETapftD5oB83UQMnOj/GlJdOFHDYhinUm0WsSoLCNkITayTunQNNIZmPdM5VnziBrrLq9OleROilCDcfEO2Ph89PIUUopMFtVEJfpaHcT+KerbYW9VvaUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ah2bkDAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ah2bkDAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D6C1F000E9;
	Tue, 21 Jul 2026 20:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665252;
	bh=rJz5qgIehkFUxjCjj/gMTMGcEqOtzcZ9AyrxfA2Z1n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ah2bkDAZAr0EF9fjzmMoMnZwzwBPKy5E5Riy8eCYdix1fdIW78wslAQkCzcSrYKRl
	 R9MpFZ2Yyd4TBVgFBUp78Oa5jogPLZUnaJPZtCBgqtrTotg4ltE0R0KxlfHnmgmBan
	 c2/xC/Fm9oUMx6T2HVOsTicxbQmveYyiKuaohV/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 0227/1266] USB: core: add USB_QUIRK_NO_LPM for VIA Labs USB 2.0 hub
Date: Tue, 21 Jul 2026 17:11:04 +0200
Message-ID: <20260721152446.896614946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>

commit bd728c3d9b1cc0bb0fda6a7055c5c8b55d7477b2 upstream.

The VIA Labs, Inc. USB 2.0 hub controller (2109:2817),
found in a KVM switch, fails to enumerate high-power devices during
cold boot and system restart.

Applying the kernel parameter
  usbcore.quirks=2109:2817:k
resolves the issue.

Enumeration failure log:
  usb 1-1.2.3: device descriptor read/64, error -32
  usb 1-1.2.3: Device not responding to setup address.
  usb 1-1.2.3: device not accepting address 11, error -71
  usb 1-1.2-port3: unable to enumerate USB device

Add USB_QUIRK_NO_LPM for this device.

Signed-off-by: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260603113626.395612-1-lugathe2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -574,6 +574,9 @@ static const struct usb_device_id usb_qu
 	/* VLI disk */
 	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VIA Labs, Inc. USB2.0 Hub */
+	{ USB_DEVICE(0x2109, 0x2817), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


