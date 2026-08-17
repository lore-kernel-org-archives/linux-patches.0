Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D34282F24;
	Mon, 17 Aug 2026 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974337; cv=none; b=dBSgyhZ9q78iko2bBTEXg8Skj8MsTILKfEnjxwefbdXVH6VyZLeArzrKGetPopyQwVqg3w71fTDzY5eZaT1LOuDvWr/ymnoLrxqDGLbO0l3B0HgOdENyp63Y2ySeQiV7fVmE2u2W6FxPwfI1uc6NlnVfzC+Vi7J24zG35W6Dk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974337; c=relaxed/simple;
	bh=XD9Z3NX8NAA6zEcocd020PVHkV6EckMg61/BN2Ls8qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG3OObdhRrwiEMqtMYOaKD3vJT3GF68jddyMIFkzC9NEIYPnwMrQEjhG46Y6FZKg0hegtoHkgrH2Uznby5sP16ZvGzrdZFqyFeECX5ux7KKfOTIxy5xr4Q2UzUtmFCKutLF14vT3uRfuFxQIFoT92m5PPlhIY305+gKaKrNzj9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFNUeA2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFNUeA2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088E21F00A3F;
	Mon, 17 Aug 2026 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974329;
	bh=90pzUpKj79P/RauM0mwpq3Ap82xEiPcyS2dwMLcKbuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFNUeA2buoEll9rWI92q8JZIPtji6oYb/PFWGGG1zEAddqy7NgF8pg1t4pY08K9Il
	 RhL8ezZt5UeUKXjunxRTaAyROmmS0UmdrA6R9teQ3tLcTsXWfWO0hR9QrXyeQmIdSX
	 9oing3EvmXlPuuZX8++ww2CqTTgAUB4B21aGdo2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ishaan Dandekar <ishaan.dandekar@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.1 128/271] usb: quirks: Add ShanWan gamepad to quirk list
Date: Mon, 17 Aug 2026 15:30:53 +0200
Message-ID: <20260817132542.122579355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -593,6 +593,9 @@ static const struct usb_device_id usb_qu
 
 	{ USB_DEVICE(0x2386, 0x350e), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* ShanWan Wireless Gamepad */
+	{ USB_DEVICE(0x2563, 0x0575), .driver_info = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE },
+
 	/* UGREEN 35871 - BOS descriptor fetch hangs at SuperSpeed Plus */
 	{ USB_DEVICE(0x2b89, 0x5871), .driver_info = USB_QUIRK_NO_BOS },
 


