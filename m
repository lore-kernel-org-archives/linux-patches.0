Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D8421B192;
	Mon, 17 Aug 2026 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975071; cv=none; b=U6blLzK8ho+S193auJsXUoKv+oz/RGHh5fVliWFxvOaKLVLH26sxgAGCSEFqIIcFb2LzqNB6AKEqn5OhZUOUBwRJtEz5levh71WNINvep9uhRtiJpCqpfNsUnBxOOReewFGzQnaBc45GlZk9yP9VIgsiQoo1oT5Khaj4bR7GPtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975071; c=relaxed/simple;
	bh=0ke0eKBSGaWqLqcTGKt0BMAwSm5GoGJqFLI0Rmb+1fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfeXV/W8qnJbXO/pxXo+t/ikcKxrxlSP0LFrr6T0t884+y2eKuICIPordmcg/ZqvqeTMPCx+lv66UKU++AnCMfADeyWOcYigMHBfNq9tWv5AwoJ2fbr5bqegtaX834b2+aDHeJwv93tJgIch1Nabn7XLu0tn+ok5DNfBn5nS+j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8+LADJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8+LADJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EAA1F000E9;
	Mon, 17 Aug 2026 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975070;
	bh=9VNupJAAzavtnCCgnNiBivQRMws42HoRHVtMYPleKaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8+LADJuv8uYVBMcbiOj2hmkBffDaQ6Qph8iSG/DR+6NAYXKL/L0+JRd+FeV93X3q
	 RcP4nkUbNXnKI7akmq7NIXcosu0mVbG2L3QsvE3aDHEBTWUeW7ApVh6LosmzqMoPCE
	 /jTWsfQsMFrnTIzRb1VyMxvF9reKsx9SQxx/OQY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ishaan Dandekar <ishaan.dandekar@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 115/250] usb: quirks: Add ShanWan gamepad to quirk list
Date: Mon, 17 Aug 2026 15:31:16 +0200
Message-ID: <20260817132541.269581886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ishaan Dandekar <ishaan.dandekar@gmail.com>

commit f3988e68fc089f6a5883f4f807955a3825bb7d45 upstream.

The ShanWan Wireless Gamepad (dongle ID 2563:0575) crashes with a -71
EPROTO error during standard enumeration because it expects a 255-byte
initial configuration request. Add this device to the quirk list to
use the USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE flag.

Signed-off-by: Ishaan Dandekar <ishaan.dandekar@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260802120128.38302-1-ishaan.dandekar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -594,6 +594,9 @@ static const struct usb_device_id usb_qu
 
 	{ USB_DEVICE(0x2386, 0x350e), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* ShanWan Wireless Gamepad */
+	{ USB_DEVICE(0x2563, 0x0575), .driver_info = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE },
+
 	/* UGREEN 35871 - BOS descriptor fetch hangs at SuperSpeed Plus */
 	{ USB_DEVICE(0x2b89, 0x5871), .driver_info = USB_QUIRK_NO_BOS },
 


